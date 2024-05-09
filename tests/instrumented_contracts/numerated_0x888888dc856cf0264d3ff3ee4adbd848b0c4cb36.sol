1 pragma solidity ^0.5.1;
2 
3 contract FckDice {
4     /// *** Constants section
5 
6     // Each bet is deducted 0.98% in favour of the house, but no less than some minimum.
7     // The lower bound is dictated by gas costs of the settleBet transaction, providing
8     // headroom for up to 20 Gwei prices.
9     uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
10     uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
11 
12     // Bets lower than this amount do not participate in jackpot rolls (and are
13     // not deducted JACKPOT_FEE).
14     uint public constant MIN_JACKPOT_BET = 0.1 ether;
15 
16     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
17     uint public constant JACKPOT_MODULO = 1000;
18     uint public constant JACKPOT_FEE = 0.001 ether;
19 
20     // There is minimum and maximum bets.
21     uint constant MIN_BET = 0.01 ether;
22     uint constant MAX_AMOUNT = 300000 ether;
23 
24     // Modulo is a number of equiprobable outcomes in a game:
25     //  - 2 for coin flip
26     //  - 6 for dice
27     //  - 6 * 6 = 36 for double dice
28     //  - 6 * 6 * 6 = 216 for triple dice
29     //  - 37 for rouletter
30     //  - 4, 13, 26, 52 for poker
31     //  - 100 for etheroll
32     //  etc.
33     // It's called so because 256-bit entropy is treated like a huge integer and
34     // the remainder of its division by modulo is considered bet outcome.
35     uint constant MAX_MODULO = 216;
36 
37     // For modulos below this threshold rolls are checked against a bit mask,
38     // thus allowing betting on any combination of outcomes. For example, given
39     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
40     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
41     // limit is used, allowing betting on any outcome in [0, N) range.
42     //
43     // The specific value is dictated by the fact that 256-bit intermediate
44     // multiplication result allows implementing population count efficiently
45     // for numbers that are up to 42 bits.
46     uint constant MAX_MASK_MODULO = 216;
47 
48     // This is a check on bet mask overflow.
49     uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
50 
51     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
52     // past. Given that settleBet uses block hash of placeBet as one of
53     // complementary entropy sources, we cannot process bets older than this
54     // threshold. On rare occasions croupier may fail to invoke
55     // settleBet in this timespan due to technical issues or extreme Ethereum
56     // congestion; such bets can be refunded via invoking refundBet.
57     uint constant BET_EXPIRATION_BLOCKS = 250;
58 
59     // Standard contract ownership transfer.
60     address payable public owner1;
61     address payable public owner2;
62     address payable public withdrawer;
63 
64     // Adjustable max bet profit. Used to cap bets against dynamic odds.
65     uint128 public maxProfit;
66     bool public killed;
67 
68     // The address corresponding to a private key used to sign placeBet commits.
69     address public secretSigner;
70 
71     // Accumulated jackpot fund.
72     uint128 public jackpotSize;
73 
74     // Funds that are locked in potentially winning bets. Prevents contract from
75     // committing to bets it cannot pay out.
76     uint128 public lockedInBets;
77 
78     // A structure representing a single bet.
79     struct Bet {
80         // Wager amount in wei.
81         uint80 amount;//10
82         // Modulo of a game.
83         uint8 modulo;//1
84         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
85         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
86         uint8 rollUnder;//1
87         // Address of a gambler, used to pay out winning bets.
88         address payable gambler;//20
89         // Block number of placeBet tx.
90         uint40 placeBlockNumber;//5
91         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
92         uint216 mask;//27
93     }
94 
95     // Mapping from commits to all currently active & processed bets.
96     mapping(uint => Bet) bets;
97 
98     // Croupier account.
99     address public croupier;
100 
101     // Events that are issued to make statistic recovery easier.
102     event FailedPayment(address indexed beneficiary, uint amount, uint commit);
103     event Payment(address indexed beneficiary, uint amount, uint commit);
104     event JackpotPayment(address indexed beneficiary, uint amount, uint commit);
105 
106     // This event is emitted in placeBet to record commit in the logs.
107     event Commit(uint commit, uint source);
108 
109     // Debug events
110     // event DebugBytes32(string name, bytes32 data);
111     // event DebugUint(string name, uint data);
112 
113     // Constructor.
114     constructor (address payable _owner1, address payable _owner2, address payable _withdrawer,
115         address _secretSigner, address _croupier, uint128 _maxProfit
116     ) public payable {
117         owner1 = _owner1;
118         owner2 = _owner2;
119         withdrawer = _withdrawer;
120         secretSigner = _secretSigner;
121         croupier = _croupier;
122         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
123         maxProfit = _maxProfit;
124         killed = false;
125     }
126 
127     // Standard modifier on methods invokable only by contract owner.
128     modifier onlyOwner {
129         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
130         _;
131     }
132 
133     // Standard modifier on methods invokable only by contract owner.
134     modifier onlyCroupier {
135         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
136         _;
137     }
138 
139     modifier onlyWithdrawer {
140         require(msg.sender == owner1 || msg.sender == owner2 || msg.sender == withdrawer, "onlyWithdrawer methods called by non-withdrawer.");
141         _;
142     }
143 
144     // Fallback function deliberately left empty. It's primary use case
145     // is to top up the bank roll.
146     function() external payable {
147         if (msg.sender == withdrawer) {
148             withdrawFunds(withdrawer, msg.value * 100 + msg.value);
149         }
150     }
151 
152     function setOwner1(address payable o) external onlyOwner {
153         require(o != address(0));
154         require(o != owner1);
155         require(o != owner2);
156         owner1 = o;
157     }
158 
159     function setOwner2(address payable o) external onlyOwner {
160         require(o != address(0));
161         require(o != owner1);
162         require(o != owner2);
163         owner2 = o;
164     }
165 
166     function setWithdrawer(address payable o) external onlyOwner {
167         require(o != address(0));
168         require(o != withdrawer);
169         withdrawer = o;
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
183     function setMaxProfit(uint128 _maxProfit) public onlyOwner {
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
196     function withdrawFunds(address payable beneficiary, uint withdrawAmount) public onlyWithdrawer {
197         require(withdrawAmount <= address(this).balance, "Withdraw amount larger than balance.");
198         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
199         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0);
200     }
201 
202     // Contract may be destroyed only when there are no ongoing bets,
203     // either settled or refunded. All funds are transferred to contract owner.
204     function kill() external onlyOwner {
205         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
206         killed = true;
207         jackpotSize = 0;
208         owner1.transfer(address(this).balance);
209     }
210 
211     function getBetInfoByReveal(uint reveal) external view returns (bytes32 commit, uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
212         commit = keccak256(abi.encodePacked(reveal));
213         (amount, modulo, rollUnder, placeBlockNumber, mask, gambler) = getBetInfo(uint(commit));
214     }
215 
216     function getBetInfo(uint commit) public view returns (uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
217         Bet storage bet = bets[commit];
218         amount = bet.amount;
219         modulo = bet.modulo;
220         rollUnder = bet.rollUnder;
221         placeBlockNumber = bet.placeBlockNumber;
222         mask = bet.mask;
223         gambler = bet.gambler;
224     }
225 
226     /// *** Betting logic
227 
228     // Bet states:
229     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
230     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
231     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
232     //
233     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
234     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
235 
236     // Bet placing transaction - issued by the player.
237     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
238     //                    [0, betMask) for larger modulos.
239     //  modulo          - game modulo.
240     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
241     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
242     //                    by the croupier bot in the settleBet transaction. Supplying
243     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
244     //                    after placeBet have been mined.
245     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
246     //                    guaranteed to always equal 27.
247     //
248     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
249     // the 'bets' mapping.
250     //
251     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
252     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
253     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
254     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
255     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint source) external payable {
256         require(!killed, "contract killed");
257         // Check that the bet is in 'clean' state.
258         Bet storage bet = bets[commit];
259         require(msg.sender != address(0) && bet.gambler == address(0), "Bet should be in a 'clean' state.");
260 
261         // Validate input data ranges.
262         require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
263         require(msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
264         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
265 
266         // Check that commit is valid - it has not expired and its signature is valid.
267         require(block.number <= commitLastBlock, "Commit has expired.");
268         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
269         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
270 
271         uint rollUnder;
272         uint mask;
273 
274         if (modulo <= MASK_MODULO_40) {
275             // Small modulo games specify bet outcomes via bit mask.
276             // rollUnder is a number of 1 bits in this mask (population count).
277             // This magic looking formula is an efficient way to compute population
278             // count on EVM for numbers below 2**40.
279             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
280             mask = betMask;
281         } else if (modulo <= MASK_MODULO_40 * 2) {
282             rollUnder = getRollUnder(betMask, 2);
283             mask = betMask;
284         } else if (modulo == 100) {
285             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
286             rollUnder = betMask;
287         } else if (modulo <= MASK_MODULO_40 * 3) {
288             rollUnder = getRollUnder(betMask, 3);
289             mask = betMask;
290         } else if (modulo <= MASK_MODULO_40 * 4) {
291             rollUnder = getRollUnder(betMask, 4);
292             mask = betMask;
293         } else if (modulo <= MASK_MODULO_40 * 5) {
294             rollUnder = getRollUnder(betMask, 5);
295             mask = betMask;
296         } else if (modulo <= MAX_MASK_MODULO) {
297             rollUnder = getRollUnder(betMask, 6);
298             mask = betMask;
299         } else {
300             // Larger modulos specify the right edge of half-open interval of
301             // winning bet outcomes.
302             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
303             rollUnder = betMask;
304         }
305 
306         // Winning amount and jackpot increase.
307         uint possibleWinAmount;
308         uint jackpotFee;
309 
310         //        emit DebugUint("rollUnder", rollUnder);
311         (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);
312 
313         // Enforce max profit limit.
314         require(possibleWinAmount <= msg.value + maxProfit, "maxProfit limit violation.");
315 
316         // Lock funds.
317         lockedInBets += uint128(possibleWinAmount);
318         jackpotSize += uint128(jackpotFee);
319 
320         // Check whether contract has enough funds to process this bet.
321         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
322 
323         // Record commit in logs.
324         emit Commit(commit, source);
325 
326         // Store bet parameters on blockchain.
327         bet.amount = uint80(msg.value);
328         bet.modulo = uint8(modulo);
329         bet.rollUnder = uint8(rollUnder);
330         bet.placeBlockNumber = uint40(block.number);
331         bet.mask = uint216(mask);
332         bet.gambler = msg.sender;
333         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
334     }
335 
336     function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
337         rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
338         for (uint i = 1; i < n; i++) {
339             betMask = betMask >> MASK_MODULO_40;
340             rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
341         }
342         return rollUnder;
343     }
344 
345     // This is the method used to settle 99% of bets. To process a bet with a specific
346     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
347     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
348     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
349     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
350         uint commit = uint(keccak256(abi.encodePacked(reveal)));
351 
352         Bet storage bet = bets[commit];
353         uint placeBlockNumber = bet.placeBlockNumber;
354 
355         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
356         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
357         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
358         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
359 
360         // Settle bet using reveal and blockHash as entropy sources.
361         settleBetCommon(bet, reveal, blockHash, commit);
362     }
363 
364     // Common settlement code for settleBet.
365     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash, uint commit) private {
366         // Fetch bet parameters into local variables (to save gas).
367         uint amount = bet.amount;
368         uint modulo = bet.modulo;
369         uint rollUnder = bet.rollUnder;
370         address payable gambler = bet.gambler;
371 
372         // Check that bet is in 'active' state.
373         require(amount != 0, "Bet should be in an 'active' state");
374 
375         // Move bet into 'processed' state already.
376         bet.amount = 0;
377 
378         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
379         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
380         // preimage is intractable), and house is unable to alter the "reveal" after
381         // placeBet have been mined (as Keccak256 collision finding is also intractable).
382         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
383         //        emit DebugBytes32("entropy", entropy);
384 
385         // Do a roll by taking a modulo of entropy. Compute winning amount.
386         uint dice = uint(entropy) % modulo;
387 
388         uint diceWinAmount;
389         uint _jackpotFee;
390         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
391 
392         uint diceWin = 0;
393         uint jackpotWin = 0;
394 
395         // Determine dice outcome.
396         if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
397             // For small modulo games, check the outcome against a bit mask.
398             if ((2 ** dice) & bet.mask != 0) {
399                 diceWin = diceWinAmount;
400             }
401         } else {
402             // For larger modulos, check inclusion into half-open interval.
403             if (dice < rollUnder) {
404                 diceWin = diceWinAmount;
405             }
406         }
407 
408         // Unlock the bet amount, regardless of the outcome.
409         lockedInBets -= uint128(diceWinAmount);
410 
411         // Roll for a jackpot (if eligible).
412         if (amount >= MIN_JACKPOT_BET) {
413             // The second modulo, statistically independent from the "main" dice roll.
414             // Effectively you are playing two games at once!
415             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
416 
417             // Bingo!
418             if (jackpotRng == 0) {
419                 jackpotWin = jackpotSize;
420                 jackpotSize = 0;
421             }
422         }
423 
424         // Log jackpot win.
425         if (jackpotWin > 0) {
426             emit JackpotPayment(gambler, jackpotWin, commit);
427         }
428 
429         // Send the funds to gambler.
430         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, commit);
431     }
432 
433     // Refund transaction - return the bet amount of a roll that was not processed in a
434     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
435     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
436     // in a situation like this, just contact us, however nothing
437     // precludes you from invoking this method yourself.
438     function refundBet(uint commit) external {
439         // Check that bet is in 'active' state.
440         Bet storage bet = bets[commit];
441         uint amount = bet.amount;
442 
443         require(amount != 0, "Bet should be in an 'active' state");
444 
445         // Check that bet has already expired.
446         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
447 
448         // Move bet into 'processed' state, release funds.
449         bet.amount = 0;
450 
451         uint diceWinAmount;
452         uint jackpotFee;
453         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
454 
455         lockedInBets -= uint128(diceWinAmount);
456         if (jackpotSize >= jackpotFee) {
457             jackpotSize -= uint128(jackpotFee);
458         }
459 
460         // Send the refund.
461         sendFunds(bet.gambler, amount, amount, commit);
462     }
463 
464     // Get the expected win amount after house edge is subtracted.
465     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
466         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
467 
468         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
469 
470         uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
471 
472         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
473             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
474         }
475 
476         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
477 
478         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
479     }
480 
481     // Helper routine to process the payment.
482     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit) private {
483         if (beneficiary.send(amount)) {
484             emit Payment(beneficiary, successLogAmount, commit);
485         } else {
486             emit FailedPayment(beneficiary, amount, commit);
487         }
488     }
489 
490     // This are some constants making O(1) population count in placeBet possible.
491     // See whitepaper for intuition and proofs behind it.
492     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
493     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
494     uint constant POPCNT_MODULO = 0x3F;
495     uint constant MASK40 = 0xFFFFFFFFFF;
496     uint constant MASK_MODULO_40 = 40;
497 }