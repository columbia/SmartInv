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
21     function setHouseEdgePercent(uint _HOUSE_EDGE_PERCENT) external onlyOwner {
22         HOUSE_EDGE_PERCENT = _HOUSE_EDGE_PERCENT;
23     }
24 
25     function setHouseEdgeMinimumAmount(uint _HOUSE_EDGE_MINIMUM_AMOUNT) external onlyOwner {
26         HOUSE_EDGE_MINIMUM_AMOUNT = _HOUSE_EDGE_MINIMUM_AMOUNT;
27     }
28 
29     function setMinJackpotBet(uint _MIN_JACKPOT_BET) external onlyOwner {
30         MIN_JACKPOT_BET = _MIN_JACKPOT_BET;
31     }
32 
33     function setJackpotModulo(uint _JACKPOT_MODULO) external onlyOwner {
34         JACKPOT_MODULO = _JACKPOT_MODULO;
35     }
36 
37     function setJackpotFee(uint _JACKPOT_FEE) external onlyOwner {
38         JACKPOT_FEE = _JACKPOT_FEE;
39     }
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
74     // threshold. On rare occasions dice2.win croupier may fail to invoke
75     // settleBet in this timespan due to technical issues or extreme Ethereum
76     // congestion; such bets can be refunded via invoking refundBet.
77     uint constant BET_EXPIRATION_BLOCKS = 250;
78 
79     // Some deliberately invalid address to initialize the secret signer with.
80     // Forces maintainers to invoke setSecretSigner before processing any bets.
81     // address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
82 
83     // Standard contract ownership transfer.
84     address public owner;
85     address private nextOwner;
86 
87     // Adjustable max bet profit. Used to cap bets against dynamic odds.
88     uint public maxProfit;
89 
90     // The address corresponding to a private key used to sign placeBet commits.
91     address public secretSigner;
92 
93     // Accumulated jackpot fund.
94     uint128 public jackpotSize;
95 
96     // Funds that are locked in potentially winning bets. Prevents contract from
97     // committing to bets it cannot pay out.
98     uint128 public lockedInBets;
99 
100     // A structure representing a single bet.
101     struct Bet {
102         // Wager amount in wei.
103         uint amount;
104         // Modulo of a game.
105         uint8 modulo;
106         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
107         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
108         uint8 rollUnder;
109         // Block number of placeBet tx.
110         uint40 placeBlockNumber;
111         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
112         uint40 mask;
113         // Address of a gambler, used to pay out winning bets.
114         address gambler;
115     }
116 
117     // Mapping from commits to all currently active & processed bets.
118     mapping(uint => Bet) bets;
119 
120     // Croupier account.
121     address public croupier;
122 
123     // Events that are issued to make statistic recovery easier.
124     event FailedPayment(address indexed beneficiary, uint amount);
125     event Payment(address indexed beneficiary, uint amount);
126     event JackpotPayment(address indexed beneficiary, uint amount);
127 
128     // This event is emitted in placeBet to record commit in the logs.
129     event Commit(uint commit);
130 
131     // Constructor. Deliberately does not take any parameters.
132     constructor (address _secretSigner, address _croupier, uint _maxProfit) public payable {
133         owner = msg.sender;
134         secretSigner = _secretSigner;
135         croupier = _croupier;
136         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
137         maxProfit = _maxProfit;
138     }
139 
140     // Standard modifier on methods invokable only by contract owner.
141     modifier onlyOwner {
142         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
143         _;
144     }
145 
146     // Standard modifier on methods invokable only by contract owner.
147     modifier onlyCroupier {
148         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
149         _;
150     }
151 
152     // Standard contract ownership transfer implementation,
153     function approveNextOwner(address _nextOwner) external onlyOwner {
154         require(_nextOwner != owner, "Cannot approve current owner.");
155         nextOwner = _nextOwner;
156     }
157 
158     function acceptNextOwner() external {
159         require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
160         owner = nextOwner;
161     }
162 
163     // Fallback function deliberately left empty. It's primary use case
164     // is to top up the bank roll.
165     function() public payable {
166     }
167 
168     // See comment for "secretSigner" variable.
169     function setSecretSigner(address newSecretSigner) external onlyOwner {
170         secretSigner = newSecretSigner;
171     }
172 
173     // Change the croupier address.
174     function setCroupier(address newCroupier) external onlyOwner {
175         croupier = newCroupier;
176     }
177 
178     // Change max bet reward. Setting this to zero effectively disables betting.
179     function setMaxProfit(uint _maxProfit) public onlyOwner {
180         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
181         maxProfit = _maxProfit;
182     }
183 
184     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
185     function increaseJackpot(uint increaseAmount) external onlyOwner {
186         require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
187         require(jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
188         jackpotSize += uint128(increaseAmount);
189     }
190 
191     // Funds withdrawal to cover costs of dice2.win operation.
192     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
193         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
194         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
195         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
196     }
197 
198     // Contract may be destroyed only when there are no ongoing bets,
199     // either settled or refunded. All funds are transferred to contract owner.
200     function kill() external onlyOwner {
201         // require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
202         selfdestruct(owner);
203     }
204 
205     function getBetInfo(uint commit) external view returns (uint amount, uint8 modulo, uint8 rollUnder, uint40 placeBlockNumber, uint40 mask, address gambler) {
206         Bet storage bet = bets[commit];
207         amount = bet.amount;
208         modulo = bet.modulo;
209         rollUnder = bet.rollUnder;
210         placeBlockNumber = bet.placeBlockNumber;
211         mask = bet.mask;
212         gambler = bet.gambler;
213     }
214 
215     /// *** Betting logic
216 
217     // Bet states:
218     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
219     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
220     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
221     //
222     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
223     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
224 
225     // Bet placing transaction - issued by the player.
226     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
227     //                    [0, betMask) for larger modulos.
228     //  modulo          - game modulo.
229     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
230     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
231     //                    by the dice2.win croupier bot in the settleBet transaction. Supplying
232     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
233     //                    after placeBet have been mined.
234     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
235     //                    guaranteed to always equal 27.
236     //
237     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
238     // the 'bets' mapping.
239     //
240     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
241     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
242     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
243     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
244     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
245         // Check that the bet is in 'clean' state.
246         Bet storage bet = bets[commit];
247         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
248 
249         // Validate input data ranges.
250         uint amount = msg.value;
251         require(modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
252         require(amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
253         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
254 
255         // Check that commit is valid - it has not expired and its signature is valid.
256         require(block.number <= commitLastBlock, "Commit has expired.");
257         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
258         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
259 
260         uint rollUnder;
261         uint mask;
262 
263         if (modulo <= MAX_MASK_MODULO) {
264             // Small modulo games specify bet outcomes via bit mask.
265             // rollUnder is a number of 1 bits in this mask (population count).
266             // This magic looking formula is an efficient way to compute population
267             // count on EVM for numbers below 2**40. For detailed proof consult
268             // the dice2.win whitepaper.
269             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
270             mask = betMask;
271         } else {
272             // Larger modulos specify the right edge of half-open interval of
273             // winning bet outcomes.
274             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
275             rollUnder = betMask;
276         }
277 
278         // Winning amount and jackpot increase.
279         uint possibleWinAmount;
280         uint jackpotFee;
281 
282         //        emit DebugUint("rollUnder", rollUnder);
283         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
284 
285         // Enforce max profit limit.
286         require(possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
287 
288         // Lock funds.
289         lockedInBets += uint128(possibleWinAmount);
290         jackpotSize += uint128(jackpotFee);
291 
292         // Check whether contract has enough funds to process this bet.
293         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
294 
295         // Record commit in logs.
296         emit Commit(commit);
297 
298         // Store bet parameters on blockchain.
299         bet.amount = amount;
300         bet.modulo = uint8(modulo);
301         bet.rollUnder = uint8(rollUnder);
302         bet.placeBlockNumber = uint40(block.number);
303         bet.mask = uint40(mask);
304         bet.gambler = msg.sender;
305         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
306     }
307 
308     // This is the method used to settle 99% of bets. To process a bet with a specific
309     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
310     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
311     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
312     function settleBet(bytes20 reveal1, bytes20 reveal2, bytes32 blockHash) external onlyCroupier {
313         uint commit = uint(keccak256(abi.encodePacked(reveal1, reveal2)));
314         //         emit DebugUint("settleBet-reveal1", uint(reveal1));
315         //         emit DebugUint("settleBet-reveal2", uint(reveal2));
316         //         emit DebugUint("settleBet-commit", commit);
317 
318         Bet storage bet = bets[commit];
319         uint placeBlockNumber = bet.placeBlockNumber;
320 
321         //         emit DebugBytes32("settleBet-placeBlockhash", blockhash(placeBlockNumber));
322         //         emit DebugUint("settleBet-placeBlockNumber", bet.placeBlockNumber);
323 
324         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
325         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
326         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
327         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
328 
329         // Settle bet using reveal and blockHash as entropy sources.
330         settleBetCommon(bet, reveal1, reveal2, blockHash);
331     }
332 
333     // Debug events
334     //    event DebugBytes32(string name, bytes32 data);
335     //    event DebugUint(string name, uint data);
336 
337     // Common settlement code for settleBet & settleBetUncleMerkleProof.
338     function settleBetCommon(Bet storage bet, bytes20 reveal1, bytes20 reveal2, bytes32 entropyBlockHash) private {
339         // Fetch bet parameters into local variables (to save gas).
340         uint amount = bet.amount;
341         uint modulo = bet.modulo;
342         uint rollUnder = bet.rollUnder;
343         address gambler = bet.gambler;
344 
345         // Check that bet is in 'active' state.
346         require(amount != 0, "Bet should be in an 'active' state");
347 
348         // Move bet into 'processed' state already.
349         bet.amount = 0;
350 
351         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
352         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
353         // preimage is intractable), and house is unable to alter the "reveal" after
354         // placeBet have been mined (as Keccak256 collision finding is also intractable).
355         bytes32 entropy = keccak256(abi.encodePacked(reveal1, entropyBlockHash, reveal2));
356         //emit DebugBytes32("entropy", entropy);
357 
358         // Do a roll by taking a modulo of entropy. Compute winning amount.
359         uint dice = uint(entropy) % modulo;
360 
361         uint diceWinAmount;
362         uint _jackpotFee;
363         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
364 
365         uint diceWin = 0;
366         uint jackpotWin = 0;
367 
368         // Determine dice outcome.
369         if (modulo <= MAX_MASK_MODULO) {
370             // For small modulo games, check the outcome against a bit mask.
371             if ((2 ** dice) & bet.mask != 0) {
372                 diceWin = diceWinAmount;
373             }
374 
375         } else {
376             // For larger modulos, check inclusion into half-open interval.
377             if (dice < rollUnder) {
378                 diceWin = diceWinAmount;
379             }
380 
381         }
382 
383         // Unlock the bet amount, regardless of the outcome.
384         lockedInBets -= uint128(diceWinAmount);
385 
386         // Roll for a jackpot (if eligible).
387         if (amount >= MIN_JACKPOT_BET) {
388             // The second modulo, statistically independent from the "main" dice roll.
389             // Effectively you are playing two games at once!
390             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
391 
392             // Bingo!
393             if (jackpotRng == 0) {
394                 jackpotWin = jackpotSize;
395                 jackpotSize = 0;
396             }
397         }
398 
399         // Log jackpot win.
400         if (jackpotWin > 0) {
401             emit JackpotPayment(gambler, jackpotWin);
402         }
403 
404         // Send the funds to gambler.
405         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
406     }
407 
408     // Refund transaction - return the bet amount of a roll that was not processed in a
409     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
410     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
411     // in a situation like this, just contact the dice2.win support, however nothing
412     // precludes you from invoking this method yourself.
413     function refundBet(uint commit) external {
414         // Check that bet is in 'active' state.
415         Bet storage bet = bets[commit];
416         uint amount = bet.amount;
417 
418         require(amount != 0, "Bet should be in an 'active' state");
419 
420         // Check that bet has already expired.
421         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
422 
423         // Move bet into 'processed' state, release funds.
424         bet.amount = 0;
425 
426         uint diceWinAmount;
427         uint jackpotFee;
428         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
429 
430         lockedInBets -= uint128(diceWinAmount);
431         jackpotSize -= uint128(jackpotFee);
432 
433         // Send the refund.
434         sendFunds(bet.gambler, amount, amount);
435     }
436 
437     // Get the expected win amount after house edge is subtracted.
438     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private view returns (uint winAmount, uint jackpotFee) {
439         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
440 
441         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
442 
443         uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
444 
445         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
446             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
447         }
448 
449         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
450 
451         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
452     }
453 
454     // Helper routine to process the payment.
455     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
456         if (beneficiary.send(amount)) {
457             emit Payment(beneficiary, successLogAmount);
458         } else {
459             emit FailedPayment(beneficiary, amount);
460         }
461     }
462 
463     // This are some constants making O(1) population count in placeBet possible.
464     // See whitepaper for intuition and proofs behind it.
465     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
466     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
467     uint constant POPCNT_MODULO = 0x3F;
468 
469 }