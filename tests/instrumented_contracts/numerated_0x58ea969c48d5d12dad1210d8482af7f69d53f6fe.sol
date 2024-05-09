1 pragma solidity ^0.4.25;
2 
3 
4 contract FckDice {
5     /// *** Constants section
6 
7     // Each bet is deducted 1% in favour of the house, but no less than some minimum.
8     // The lower bound is dictated by gas costs of the settleBet transaction, providing
9     // headroom for up to 10 Gwei prices.
10     uint public HOUSE_EDGE_PERCENT = 1;
11     uint public HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
12 
13     // Bets lower than this amount do not participate in jackpot rolls (and are
14     // not deducted JACKPOT_FEE).
15     uint public MIN_JACKPOT_BET = 0.1 ether;
16 
17     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
18     uint public JACKPOT_MODULO = 1000;
19     uint public JACKPOT_FEE = 0.001 ether;
20 
21     //    function setHouseEdgePercent(uint _HOUSE_EDGE_PERCENT) external onlyOwner {
22     //        HOUSE_EDGE_PERCENT = _HOUSE_EDGE_PERCENT;
23     //    }
24     //
25     //    function setHouseEdgeMinimumAmount(uint _HOUSE_EDGE_MINIMUM_AMOUNT) external onlyOwner {
26     //        HOUSE_EDGE_MINIMUM_AMOUNT = _HOUSE_EDGE_MINIMUM_AMOUNT;
27     //    }
28     //
29     //    function setMinJackpotBet(uint _MIN_JACKPOT_BET) external onlyOwner {
30     //        MIN_JACKPOT_BET = _MIN_JACKPOT_BET;
31     //    }
32     //
33     //    function setJackpotModulo(uint _JACKPOT_MODULO) external onlyOwner {
34     //        JACKPOT_MODULO = _JACKPOT_MODULO;
35     //    }
36     //
37     //    function setJackpotFee(uint _JACKPOT_FEE) external onlyOwner {
38     //        JACKPOT_FEE = _JACKPOT_FEE;
39     //    }
40 
41     // There is minimum and maximum bets.
42     uint constant MIN_BET = 0.01 ether;
43     uint constant MAX_AMOUNT = 300000 ether;
44 
45     // Modulo is a number of equiprobable outcomes in a game:
46     //  - 2 for coin flip
47     //  - 6 for dice
48     //  - 6*6 = 36 for double dice
49     //  - 100 for etheroll
50     //  - 37 for roulette
51     //  etc.
52     // It's called so because 256-bit entropy is treated like a huge integer and
53     // the remainder of its division by modulo is considered bet outcome.
54     uint constant MAX_MODULO = 100;
55 
56     // For modulos below this threshold rolls are checked against a bit mask,
57     // thus allowing betting on any combination of outcomes. For example, given
58     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
59     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
60     // limit is used, allowing betting on any outcome in [0, N) range.
61     //
62     // The specific value is dictated by the fact that 256-bit intermediate
63     // multiplication result allows implementing population count efficiently
64     // for numbers that are up to 42 bits, and 40 is the highest multiple of
65     // eight below 42.
66     uint constant MAX_MASK_MODULO = 40;
67 
68     // This is a check on bet mask overflow.
69     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
70 
71     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
72     // past. Given that settleBet uses block hash of placeBet as one of
73     // complementary entropy sources, we cannot process bets older than this
74     // threshold. On rare occasions croupier may fail to invoke
75     // settleBet in this timespan due to technical issues or extreme Ethereum
76     // congestion; such bets can be refunded via invoking refundBet.
77     uint constant BET_EXPIRATION_BLOCKS = 250;
78 
79     // Some deliberately invalid address to initialize the secret signer with.
80     // Forces maintainers to invoke setSecretSigner before processing any bets.
81     // address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
82 
83     // Standard contract ownership transfer.
84     address public owner1;
85     address public owner2;
86     //    address private nextOwner;
87 
88     // Adjustable max bet profit. Used to cap bets against dynamic odds.
89     uint public maxProfit;
90 
91     // The address corresponding to a private key used to sign placeBet commits.
92     address public secretSigner;
93 
94     // Accumulated jackpot fund.
95     uint128 public jackpotSize;
96 
97     // Funds that are locked in potentially winning bets. Prevents contract from
98     // committing to bets it cannot pay out.
99     uint128 public lockedInBets;
100 
101     // A structure representing a single bet.
102     struct Bet {
103         // Wager amount in wei.
104         uint amount;
105         // Modulo of a game.
106         uint8 modulo;
107         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
108         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
109         uint8 rollUnder;
110         // Block number of placeBet tx.
111         uint40 placeBlockNumber;
112         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
113         uint40 mask;
114         // Address of a gambler, used to pay out winning bets.
115         address gambler;
116     }
117 
118     // Mapping from commits to all currently active & processed bets.
119     mapping(uint => Bet) bets;
120 
121     // Croupier account.
122     address public croupier;
123 
124     // Events that are issued to make statistic recovery easier.
125     event FailedPayment(address indexed beneficiary, uint amount);
126     event Payment(address indexed beneficiary, uint amount);
127     event JackpotPayment(address indexed beneficiary, uint amount);
128 
129     // This event is emitted in placeBet to record commit in the logs.
130     event Commit(uint commit);
131 
132     // Constructor.
133     constructor (address _owner1, address _owner2,
134         address _secretSigner, address _croupier, uint _maxProfit
135     ) public payable {
136         owner1 = _owner1;
137         owner2 = _owner2;
138         secretSigner = _secretSigner;
139         croupier = _croupier;
140         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
141         maxProfit = _maxProfit;
142     }
143 
144     // Standard modifier on methods invokable only by contract owner.
145     modifier onlyOwner {
146         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
147         _;
148     }
149 
150     // Standard modifier on methods invokable only by contract owner.
151     modifier onlyCroupier {
152         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
153         _;
154     }
155 
156     //    // Standard contract ownership transfer implementation,
157     //    function approveNextOwner(address _nextOwner) external onlyOwner {
158     //        require(_nextOwner != owner, "Cannot approve current owner.");
159     //        nextOwner = _nextOwner;
160     //    }
161     //
162     //    function acceptNextOwner() external {
163     //        require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
164     //        owner = nextOwner;
165     //    }
166 
167     // Fallback function deliberately left empty. It's primary use case
168     // is to top up the bank roll.
169     function() public payable {
170     }
171 
172     // See comment for "secretSigner" variable.
173     function setSecretSigner(address newSecretSigner) external onlyOwner {
174         secretSigner = newSecretSigner;
175     }
176 
177     // Change the croupier address.
178     function setCroupier(address newCroupier) external onlyOwner {
179         croupier = newCroupier;
180     }
181 
182     // Change max bet reward. Setting this to zero effectively disables betting.
183     function setMaxProfit(uint _maxProfit) public onlyOwner {
184         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
185         maxProfit = _maxProfit;
186     }
187 
188     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
189     function increaseJackpot(uint increaseAmount) external onlyOwner {
190         require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
191         require(jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
192         jackpotSize += uint128(increaseAmount);
193     }
194 
195     // Funds withdrawal to cover costs of croupier operation.
196     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
197         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
198         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
199         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
200     }
201 
202     // Contract may be destroyed only when there are no ongoing bets,
203     // either settled or refunded. All funds are transferred to contract owner.
204     function kill() external onlyOwner {
205         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
206         selfdestruct(owner1);
207     }
208 
209     function getBetInfo(uint commit) external view returns (uint amount, uint8 modulo, uint8 rollUnder, uint40 placeBlockNumber, uint40 mask, address gambler) {
210         Bet storage bet = bets[commit];
211         amount = bet.amount;
212         modulo = bet.modulo;
213         rollUnder = bet.rollUnder;
214         placeBlockNumber = bet.placeBlockNumber;
215         mask = bet.mask;
216         gambler = bet.gambler;
217     }
218 
219     /// *** Betting logic
220 
221     // Bet states:
222     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
223     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
224     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
225     //
226     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
227     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
228 
229     // Bet placing transaction - issued by the player.
230     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
231     //                    [0, betMask) for larger modulos.
232     //  modulo          - game modulo.
233     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
234     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
235     //                    by the croupier bot in the settleBet transaction. Supplying
236     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
237     //                    after placeBet have been mined.
238     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
239     //                    guaranteed to always equal 27.
240     //
241     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
242     // the 'bets' mapping.
243     //
244     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
245     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
246     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
247     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
248     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
249         // Check that the bet is in 'clean' state.
250         Bet storage bet = bets[commit];
251         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
252 
253         // Validate input data ranges.
254         uint amount = msg.value;
255         require(modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
256         require(amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
257         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
258 
259         // Check that commit is valid - it has not expired and its signature is valid.
260         require(block.number <= commitLastBlock, "Commit has expired.");
261         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
262         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
263 
264         uint rollUnder;
265         uint mask;
266 
267         if (modulo <= MAX_MASK_MODULO) {
268             // Small modulo games specify bet outcomes via bit mask.
269             // rollUnder is a number of 1 bits in this mask (population count).
270             // This magic looking formula is an efficient way to compute population
271             // count on EVM for numbers below 2**40.
272             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
273             mask = betMask;
274         } else {
275             // Larger modulos specify the right edge of half-open interval of
276             // winning bet outcomes.
277             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
278             rollUnder = betMask;
279         }
280 
281         // Winning amount and jackpot increase.
282         uint possibleWinAmount;
283         uint jackpotFee;
284 
285         //        emit DebugUint("rollUnder", rollUnder);
286         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
287 
288         // Enforce max profit limit.
289         require(possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
290 
291         // Lock funds.
292         lockedInBets += uint128(possibleWinAmount);
293         jackpotSize += uint128(jackpotFee);
294 
295         // Check whether contract has enough funds to process this bet.
296         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
297 
298         // Record commit in logs.
299         emit Commit(commit);
300 
301         // Store bet parameters on blockchain.
302         bet.amount = amount;
303         bet.modulo = uint8(modulo);
304         bet.rollUnder = uint8(rollUnder);
305         bet.placeBlockNumber = uint40(block.number);
306         bet.mask = uint40(mask);
307         bet.gambler = msg.sender;
308         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
309     }
310 
311     // This is the method used to settle 99% of bets. To process a bet with a specific
312     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
313     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
314     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
315     function settleBet(bytes20 reveal1, bytes20 reveal2, bytes32 blockHash) external onlyCroupier {
316         uint commit = uint(keccak256(abi.encodePacked(reveal1, reveal2)));
317         //         emit DebugUint("settleBet-reveal1", uint(reveal1));
318         //         emit DebugUint("settleBet-reveal2", uint(reveal2));
319         //         emit DebugUint("settleBet-commit", commit);
320 
321         Bet storage bet = bets[commit];
322         uint placeBlockNumber = bet.placeBlockNumber;
323 
324         //         emit DebugBytes32("settleBet-placeBlockhash", blockhash(placeBlockNumber));
325         //         emit DebugUint("settleBet-placeBlockNumber", bet.placeBlockNumber);
326 
327         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
328         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
329         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
330         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
331 
332         // Settle bet using reveal and blockHash as entropy sources.
333         settleBetCommon(bet, reveal1, reveal2, blockHash);
334     }
335 
336     // Debug events
337     //    event DebugBytes32(string name, bytes32 data);
338     //    event DebugUint(string name, uint data);
339 
340     // Common settlement code for settleBet.
341     function settleBetCommon(Bet storage bet, bytes20 reveal1, bytes20 reveal2, bytes32 entropyBlockHash) private {
342         // Fetch bet parameters into local variables (to save gas).
343         uint amount = bet.amount;
344         uint modulo = bet.modulo;
345         uint rollUnder = bet.rollUnder;
346         address gambler = bet.gambler;
347 
348         // Check that bet is in 'active' state.
349         require(amount != 0, "Bet should be in an 'active' state");
350 
351         // Move bet into 'processed' state already.
352         bet.amount = 0;
353 
354         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
355         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
356         // preimage is intractable), and house is unable to alter the "reveal" after
357         // placeBet have been mined (as Keccak256 collision finding is also intractable).
358         bytes32 entropy = keccak256(abi.encodePacked(reveal1, entropyBlockHash, reveal2));
359         //emit DebugBytes32("entropy", entropy);
360 
361         // Do a roll by taking a modulo of entropy. Compute winning amount.
362         uint dice = uint(entropy) % modulo;
363 
364         uint diceWinAmount;
365         uint _jackpotFee;
366         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
367 
368         uint diceWin = 0;
369         uint jackpotWin = 0;
370 
371         // Determine dice outcome.
372         if (modulo <= MAX_MASK_MODULO) {
373             // For small modulo games, check the outcome against a bit mask.
374             if ((2 ** dice) & bet.mask != 0) {
375                 diceWin = diceWinAmount;
376             }
377 
378         } else {
379             // For larger modulos, check inclusion into half-open interval.
380             if (dice < rollUnder) {
381                 diceWin = diceWinAmount;
382             }
383 
384         }
385 
386         // Unlock the bet amount, regardless of the outcome.
387         lockedInBets -= uint128(diceWinAmount);
388 
389         // Roll for a jackpot (if eligible).
390         if (amount >= MIN_JACKPOT_BET) {
391             // The second modulo, statistically independent from the "main" dice roll.
392             // Effectively you are playing two games at once!
393             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
394 
395             // Bingo!
396             if (jackpotRng == 0) {
397                 jackpotWin = jackpotSize;
398                 jackpotSize = 0;
399             }
400         }
401 
402         // Log jackpot win.
403         if (jackpotWin > 0) {
404             emit JackpotPayment(gambler, jackpotWin);
405         }
406 
407         // Send the funds to gambler.
408         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
409     }
410 
411     // Refund transaction - return the bet amount of a roll that was not processed in a
412     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
413     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
414     // in a situation like this, just contact the fck.com support, however nothing
415     // precludes you from invoking this method yourself.
416     function refundBet(uint commit) external {
417         // Check that bet is in 'active' state.
418         Bet storage bet = bets[commit];
419         uint amount = bet.amount;
420 
421         require(amount != 0, "Bet should be in an 'active' state");
422 
423         // Check that bet has already expired.
424         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
425 
426         // Move bet into 'processed' state, release funds.
427         bet.amount = 0;
428 
429         uint diceWinAmount;
430         uint jackpotFee;
431         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
432 
433         lockedInBets -= uint128(diceWinAmount);
434         jackpotSize -= uint128(jackpotFee);
435 
436         // Send the refund.
437         sendFunds(bet.gambler, amount, amount);
438     }
439 
440     // Get the expected win amount after house edge is subtracted.
441     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private view returns (uint winAmount, uint jackpotFee) {
442         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
443 
444         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
445 
446         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
447 
448         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
449             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
450         }
451 
452         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
453 
454         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
455     }
456 
457     // Helper routine to process the payment.
458     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
459         if (beneficiary.send(amount)) {
460             emit Payment(beneficiary, successLogAmount);
461         } else {
462             emit FailedPayment(beneficiary, amount);
463         }
464     }
465 
466     // This are some constants making O(1) population count in placeBet possible.
467     // See whitepaper for intuition and proofs behind it.
468     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
469     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
470     uint constant POPCNT_MODULO = 0x3F;
471 }