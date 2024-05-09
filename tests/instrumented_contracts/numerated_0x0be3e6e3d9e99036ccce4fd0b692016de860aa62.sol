1 pragma solidity ^0.4.25;
2 
3 
4 contract FckDice {
5     /// *** Constants section
6 
7     // Each bet is deducted 0.98% in favour of the house, but no less than some minimum.
8     // The lower bound is dictated by gas costs of the settleBet transaction, providing
9     // headroom for up to 10 Gwei prices.
10     uint public HOUSE_EDGE_OF_TEN_THOUSAND = 98;
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
21     // There is minimum and maximum bets.
22     uint constant MIN_BET = 0.01 ether;
23     uint constant MAX_AMOUNT = 300000 ether;
24 
25     // Modulo is a number of equiprobable outcomes in a game:
26     //  - 2 for coin flip
27     //  - 6 for dice
28     //  - 6*6 = 36 for double dice
29     //  - 100 for etheroll
30     //  - 37 for roulette
31     //  etc.
32     // It's called so because 256-bit entropy is treated like a huge integer and
33     // the remainder of its division by modulo is considered bet outcome.
34     uint constant MAX_MODULO = 255;
35 
36     // For modulos below this threshold rolls are checked against a bit mask,
37     // thus allowing betting on any combination of outcomes. For example, given
38     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
39     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
40     // limit is used, allowing betting on any outcome in [0, N) range.
41     //
42     // The specific value is dictated by the fact that 256-bit intermediate
43     // multiplication result allows implementing population count efficiently
44     // for numbers that are up to 42 bits, and 40 is the highest multiple of
45     // eight below 42.
46     uint constant MAX_MASK_MODULO = 40;
47 
48     // This is a check on bet mask overflow.
49     uint constant MAX_BET_MASK = 2 ** (MAX_MASK_MODULO * 6);
50 
51     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
52     // past. Given that settleBet uses block hash of placeBet as one of
53     // complementary entropy sources, we cannot process bets older than this
54     // threshold. On rare occasions croupier may fail to invoke
55     // settleBet in this timespan due to technical issues or extreme Ethereum
56     // congestion; such bets can be refunded via invoking refundBet.
57     uint constant BET_EXPIRATION_BLOCKS = 250;
58 
59     // Some deliberately invalid address to initialize the secret signer with.
60     // Forces maintainers to invoke setSecretSigner before processing any bets.
61     // address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
62 
63     // Standard contract ownership transfer.
64     address public owner1;
65     address public owner2;
66     //    address private nextOwner;
67 
68     // Adjustable max bet profit. Used to cap bets against dynamic odds.
69     uint public maxProfit;
70 
71     // The address corresponding to a private key used to sign placeBet commits.
72     address public secretSigner;
73 
74     // Accumulated jackpot fund.
75     uint128 public jackpotSize;
76 
77     // Funds that are locked in potentially winning bets. Prevents contract from
78     // committing to bets it cannot pay out.
79     uint128 public lockedInBets;
80 
81     // A structure representing a single bet.
82     struct Bet {
83         // Wager amount in wei.
84         uint amount;
85         // Modulo of a game.
86         uint8 modulo;
87         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
88         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
89         uint8 rollUnder;
90         // Block number of placeBet tx.
91         uint40 placeBlockNumber;
92         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
93         uint240 mask;
94         // Address of a gambler, used to pay out winning bets.
95         address gambler;
96     }
97 
98     // Mapping from commits to all currently active & processed bets.
99     mapping(uint => Bet) bets;
100 
101     // Croupier account.
102     address public croupier;
103 
104     // Events that are issued to make statistic recovery easier.
105     event FailedPayment(address indexed beneficiary, uint amount);
106     event Payment(address indexed beneficiary, uint amount);
107     event JackpotPayment(address indexed beneficiary, uint amount);
108 
109     // This event is emitted in placeBet to record commit in the logs.
110     event Commit(uint commit);
111 
112     // Constructor.
113     constructor (address _owner1, address _owner2,
114         address _secretSigner, address _croupier, uint _maxProfit
115     ) public payable {
116         owner1 = _owner1;
117         owner2 = _owner2;
118         secretSigner = _secretSigner;
119         croupier = _croupier;
120         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
121         maxProfit = _maxProfit;
122     }
123 
124     // Standard modifier on methods invokable only by contract owner.
125     modifier onlyOwner {
126         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
127         _;
128     }
129 
130     // Standard modifier on methods invokable only by contract owner.
131     modifier onlyCroupier {
132         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
133         _;
134     }
135 
136     //    // Standard contract ownership transfer implementation,
137     //    function approveNextOwner(address _nextOwner) external onlyOwner {
138     //        require(_nextOwner != owner, "Cannot approve current owner.");
139     //        nextOwner = _nextOwner;
140     //    }
141     //
142     //    function acceptNextOwner() external {
143     //        require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
144     //        owner = nextOwner;
145     //    }
146 
147     // Fallback function deliberately left empty. It's primary use case
148     // is to top up the bank roll.
149     function() public payable {
150     }
151 
152     function setOwner1(address o) external onlyOwner {
153         require(o != address(0));
154         require(o != owner1);
155         require(o != owner2);
156         owner1 = o;
157     }
158 
159     function setOwner2(address o) external onlyOwner {
160         require(o != address(0));
161         require(o != owner1);
162         require(o != owner2);
163         owner2 = o;
164     }
165 
166     // See comment for "secretSigner" variable.
167     function setSecretSigner(address newSecretSigner) external onlyOwner {
168         secretSigner = newSecretSigner;
169     }
170 
171     // Change the croupier address.
172     function setCroupier(address newCroupier) external onlyOwner {
173         croupier = newCroupier;
174     }
175 
176     // Change max bet reward. Setting this to zero effectively disables betting.
177     function setMaxProfit(uint _maxProfit) public onlyOwner {
178         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
179         maxProfit = _maxProfit;
180     }
181 
182     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
183     function increaseJackpot(uint increaseAmount) external onlyOwner {
184         require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
185         require(jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
186         jackpotSize += uint128(increaseAmount);
187     }
188 
189     // Funds withdrawal to cover costs of croupier operation.
190     function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
191         require(withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
192         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
193         sendFunds(beneficiary, withdrawAmount, withdrawAmount);
194     }
195 
196     // Contract may be destroyed only when there are no ongoing bets,
197     // either settled or refunded. All funds are transferred to contract owner.
198     function kill() external onlyOwner {
199         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
200         selfdestruct(owner1);
201     }
202 
203     function getBetInfo(uint commit) external view returns (uint amount, uint8 modulo, uint8 rollUnder, uint40 placeBlockNumber, uint240 mask, address gambler) {
204         Bet storage bet = bets[commit];
205         amount = bet.amount;
206         modulo = bet.modulo;
207         rollUnder = bet.rollUnder;
208         placeBlockNumber = bet.placeBlockNumber;
209         mask = bet.mask;
210         gambler = bet.gambler;
211     }
212 
213     /// *** Betting logic
214 
215     // Bet states:
216     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
217     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
218     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
219     //
220     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
221     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
222 
223     // Bet placing transaction - issued by the player.
224     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
225     //                    [0, betMask) for larger modulos.
226     //  modulo          - game modulo.
227     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
228     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
229     //                    by the croupier bot in the settleBet transaction. Supplying
230     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
231     //                    after placeBet have been mined.
232     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
233     //                    guaranteed to always equal 27.
234     //
235     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
236     // the 'bets' mapping.
237     //
238     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
239     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
240     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
241     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
242     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s) external payable {
243         // Check that the bet is in 'clean' state.
244         Bet storage bet = bets[commit];
245         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
246 
247         // Validate input data ranges.
248         uint amount = msg.value;
249         require(modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
250         require(amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
251         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
252 
253         // Check that commit is valid - it has not expired and its signature is valid.
254         require(block.number <= commitLastBlock, "Commit has expired.");
255         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
256         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
257 
258         uint rollUnder;
259         uint mask;
260 
261         if (modulo <= MAX_MASK_MODULO) {
262             // Small modulo games specify bet outcomes via bit mask.
263             // rollUnder is a number of 1 bits in this mask (population count).
264             // This magic looking formula is an efficient way to compute population
265             // count on EVM for numbers below 2**40.
266             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
267             mask = betMask;
268         } else if (modulo <= MAX_MASK_MODULO * 2) {
269             rollUnder = getRollUnder(betMask, 2);
270             mask = betMask;
271         } else if (modulo == 100) {
272             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
273             rollUnder = betMask;
274         } else if (modulo <= MAX_MASK_MODULO * 3) {
275             rollUnder = getRollUnder(betMask, 3);
276             mask = betMask;
277         } else if (modulo <= MAX_MASK_MODULO * 4) {
278             rollUnder = getRollUnder(betMask, 4);
279             mask = betMask;
280         } else if (modulo <= MAX_MASK_MODULO * 5) {
281             rollUnder = getRollUnder(betMask, 5);
282             mask = betMask;
283         } else if (modulo <= MAX_MASK_MODULO * 6) {
284             rollUnder = getRollUnder(betMask, 6);
285             mask = betMask;
286         } else {
287             // Larger modulos specify the right edge of half-open interval of
288             // winning bet outcomes.
289             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
290             rollUnder = betMask;
291         }
292 
293         // Winning amount and jackpot increase.
294         uint possibleWinAmount;
295         uint jackpotFee;
296 
297         //        emit DebugUint("rollUnder", rollUnder);
298         (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
299 
300         // Enforce max profit limit.
301         require(possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
302 
303         // Lock funds.
304         lockedInBets += uint128(possibleWinAmount);
305         jackpotSize += uint128(jackpotFee);
306 
307         // Check whether contract has enough funds to process this bet.
308         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
309 
310         // Record commit in logs.
311         emit Commit(commit);
312 
313         // Store bet parameters on blockchain.
314         bet.amount = amount;
315         bet.modulo = uint8(modulo);
316         bet.rollUnder = uint8(rollUnder);
317         bet.placeBlockNumber = uint40(block.number);
318         bet.mask = uint240(mask);
319         bet.gambler = msg.sender;
320         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
321     }
322 
323     function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
324         rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
325         for (uint i = 1; i < n; i++) {
326             betMask = betMask >> MAX_MASK_MODULO;
327             rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
328         }
329         return rollUnder;
330     }
331 
332     // This is the method used to settle 99% of bets. To process a bet with a specific
333     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
334     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
335     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
336     function settleBet(bytes20 reveal1, bytes20 reveal2, bytes32 blockHash) external onlyCroupier {
337         uint commit = uint(keccak256(abi.encodePacked(reveal1, reveal2)));
338         //         emit DebugUint("settleBet-reveal1", uint(reveal1));
339         //         emit DebugUint("settleBet-reveal2", uint(reveal2));
340         //         emit DebugUint("settleBet-commit", commit);
341 
342         Bet storage bet = bets[commit];
343         uint placeBlockNumber = bet.placeBlockNumber;
344 
345         //         emit DebugBytes32("settleBet-placeBlockhash", blockhash(placeBlockNumber));
346         //         emit DebugUint("settleBet-placeBlockNumber", bet.placeBlockNumber);
347 
348         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
349         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
350         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
351         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
352 
353         // Settle bet using reveal and blockHash as entropy sources.
354         settleBetCommon(bet, reveal1, reveal2, blockHash);
355     }
356 
357     // Debug events
358     //    event DebugBytes32(string name, bytes32 data);
359     //    event DebugUint(string name, uint data);
360 
361     // Common settlement code for settleBet.
362     function settleBetCommon(Bet storage bet, bytes20 reveal1, bytes20 reveal2, bytes32 entropyBlockHash) private {
363         // Fetch bet parameters into local variables (to save gas).
364         uint amount = bet.amount;
365         uint modulo = bet.modulo;
366         uint rollUnder = bet.rollUnder;
367         address gambler = bet.gambler;
368 
369         // Check that bet is in 'active' state.
370         require(amount != 0, "Bet should be in an 'active' state");
371 
372         // Move bet into 'processed' state already.
373         bet.amount = 0;
374 
375         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
376         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
377         // preimage is intractable), and house is unable to alter the "reveal" after
378         // placeBet have been mined (as Keccak256 collision finding is also intractable).
379         bytes32 entropy = keccak256(abi.encodePacked(reveal1, entropyBlockHash, reveal2));
380         //emit DebugBytes32("entropy", entropy);
381 
382         // Do a roll by taking a modulo of entropy. Compute winning amount.
383         uint dice = uint(entropy) % modulo;
384 
385         uint diceWinAmount;
386         uint _jackpotFee;
387         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
388 
389         uint diceWin = 0;
390         uint jackpotWin = 0;
391 
392         // Determine dice outcome.
393         if ((modulo != 100) && (modulo <= MAX_MASK_MODULO * 6)) {
394             // For small modulo games, check the outcome against a bit mask.
395             if ((2 ** dice) & bet.mask != 0) {
396                 diceWin = diceWinAmount;
397             }
398         } else {
399             // For larger modulos, check inclusion into half-open interval.
400             if (dice < rollUnder) {
401                 diceWin = diceWinAmount;
402             }
403         }
404 
405         // Unlock the bet amount, regardless of the outcome.
406         lockedInBets -= uint128(diceWinAmount);
407 
408         // Roll for a jackpot (if eligible).
409         if (amount >= MIN_JACKPOT_BET) {
410             // The second modulo, statistically independent from the "main" dice roll.
411             // Effectively you are playing two games at once!
412             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
413 
414             // Bingo!
415             if (jackpotRng == 0) {
416                 jackpotWin = jackpotSize;
417                 jackpotSize = 0;
418             }
419         }
420 
421         // Log jackpot win.
422         if (jackpotWin > 0) {
423             emit JackpotPayment(gambler, jackpotWin);
424         }
425 
426         // Send the funds to gambler.
427         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin);
428     }
429 
430     // Refund transaction - return the bet amount of a roll that was not processed in a
431     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
432     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
433     // in a situation like this, just contact the fck.com support, however nothing
434     // precludes you from invoking this method yourself.
435     function refundBet(uint commit) external {
436         // Check that bet is in 'active' state.
437         Bet storage bet = bets[commit];
438         uint amount = bet.amount;
439 
440         require(amount != 0, "Bet should be in an 'active' state");
441 
442         // Check that bet has already expired.
443         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
444 
445         // Move bet into 'processed' state, release funds.
446         bet.amount = 0;
447 
448         uint diceWinAmount;
449         uint jackpotFee;
450         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
451 
452         lockedInBets -= uint128(diceWinAmount);
453         if (jackpotSize >= jackpotFee) {
454             jackpotSize -= uint128(jackpotFee);
455         }
456 
457         // Send the refund.
458         sendFunds(bet.gambler, amount, amount);
459     }
460 
461     // Get the expected win amount after house edge is subtracted.
462     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private view returns (uint winAmount, uint jackpotFee) {
463         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
464 
465         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
466 
467         uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
468 
469         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
470             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
471         }
472 
473         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
474 
475         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
476     }
477 
478     // Helper routine to process the payment.
479     function sendFunds(address beneficiary, uint amount, uint successLogAmount) private {
480         if (beneficiary.send(amount)) {
481             emit Payment(beneficiary, successLogAmount);
482         } else {
483             emit FailedPayment(beneficiary, amount);
484         }
485     }
486 
487     // This are some constants making O(1) population count in placeBet possible.
488     // See whitepaper for intuition and proofs behind it.
489     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
490     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
491     uint constant POPCNT_MODULO = 0x3F;
492     uint constant MASK40 = 0xFFFFFFFFFF;
493 }