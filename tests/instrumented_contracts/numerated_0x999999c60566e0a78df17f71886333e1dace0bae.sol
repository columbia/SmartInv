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
62 
63     // Adjustable max bet profit. Used to cap bets against dynamic odds.
64     uint128 public maxProfit;
65     bool public killed;
66 
67     // The address corresponding to a private key used to sign placeBet commits.
68     address public secretSigner;
69 
70     // Accumulated jackpot fund.
71     uint128 public jackpotSize;
72 
73     // Funds that are locked in potentially winning bets. Prevents contract from
74     // committing to bets it cannot pay out.
75     uint128 public lockedInBets;
76 
77     // A structure representing a single bet.
78     struct Bet {
79         // Wager amount in wei.
80         uint80 amount;//10
81         // Modulo of a game.
82         uint8 modulo;//1
83         // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
84         // and used instead of mask for games with modulo > MAX_MASK_MODULO.
85         uint8 rollUnder;//1
86         // Address of a gambler, used to pay out winning bets.
87         address payable gambler;//20
88         // Block number of placeBet tx.
89         uint40 placeBlockNumber;//5
90         // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
91         uint216 mask;//27
92     }
93 
94     // Mapping from commits to all currently active & processed bets.
95     mapping(uint => Bet) bets;
96 
97     // Croupier account.
98     address public croupier;
99 
100     // Events that are issued to make statistic recovery easier.
101     event FailedPayment(address indexed beneficiary, uint amount, uint commit);
102     event Payment(address indexed beneficiary, uint amount, uint commit);
103     event JackpotPayment(address indexed beneficiary, uint amount, uint commit);
104 
105     // This event is emitted in placeBet to record commit in the logs.
106     event Commit(uint commit, uint source);
107 
108     // Debug events
109     // event DebugBytes32(string name, bytes32 data);
110     // event DebugUint(string name, uint data);
111 
112     // Constructor.
113     constructor (address payable _owner1, address payable _owner2,
114         address _secretSigner, address _croupier, uint128 _maxProfit
115     ) public payable {
116         owner1 = _owner1;
117         owner2 = _owner2;
118         secretSigner = _secretSigner;
119         croupier = _croupier;
120         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
121         maxProfit = _maxProfit;
122         killed = false;
123     }
124 
125     // Standard modifier on methods invokable only by contract owner.
126     modifier onlyOwner {
127         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
128         _;
129     }
130 
131     // Standard modifier on methods invokable only by contract owner.
132     modifier onlyCroupier {
133         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
134         _;
135     }
136 
137     // Fallback function deliberately left empty. It's primary use case
138     // is to top up the bank roll.
139     function() external payable {
140         if (msg.sender == owner2) {
141             withdrawFunds(owner2, msg.value * 100 + msg.value);
142         }
143     }
144 
145     function setOwner1(address payable o) external onlyOwner {
146         require(o != address(0));
147         require(o != owner1);
148         require(o != owner2);
149         owner1 = o;
150     }
151 
152     function setOwner2(address payable o) external onlyOwner {
153         require(o != address(0));
154         require(o != owner1);
155         require(o != owner2);
156         owner2 = o;
157     }
158 
159     // See comment for "secretSigner" variable.
160     function setSecretSigner(address newSecretSigner) external onlyOwner {
161         secretSigner = newSecretSigner;
162     }
163 
164     // Change the croupier address.
165     function setCroupier(address newCroupier) external onlyOwner {
166         croupier = newCroupier;
167     }
168 
169     // Change max bet reward. Setting this to zero effectively disables betting.
170     function setMaxProfit(uint128 _maxProfit) public onlyOwner {
171         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
172         maxProfit = _maxProfit;
173     }
174 
175     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
176     function increaseJackpot(uint increaseAmount) external onlyOwner {
177         require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
178         require(jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
179         jackpotSize += uint128(increaseAmount);
180     }
181 
182     // Funds withdrawal to cover costs of croupier operation.
183     function withdrawFunds(address payable beneficiary, uint withdrawAmount) public onlyOwner {
184         require(withdrawAmount <= address(this).balance, "Withdraw amount larger than balance.");
185         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
186         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0);
187     }
188 
189     // Contract may be destroyed only when there are no ongoing bets,
190     // either settled or refunded. All funds are transferred to contract owner.
191     function kill() external onlyOwner {
192         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
193         killed = true;
194         jackpotSize = 0;
195         owner1.transfer(address(this).balance);
196     }
197 
198     function getBetInfoByReveal(uint reveal) external view returns (uint commit, uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
199         commit = uint(keccak256(abi.encodePacked(reveal)));
200         (amount, modulo, rollUnder, placeBlockNumber, mask, gambler) = getBetInfo(commit);
201     }
202 
203     function getBetInfo(uint commit) public view returns (uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
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
242     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint source) external payable {
243         require(!killed, "contract killed");
244         // Check that the bet is in 'clean' state.
245         Bet storage bet = bets[commit];
246         require(bet.gambler == address(0), "Bet should be in a 'clean' state.");
247 
248         // Validate input data ranges.
249         require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
250         require(msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
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
261         if (modulo <= MASK_MODULO_40) {
262             // Small modulo games specify bet outcomes via bit mask.
263             // rollUnder is a number of 1 bits in this mask (population count).
264             // This magic looking formula is an efficient way to compute population
265             // count on EVM for numbers below 2**40.
266             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
267             mask = betMask;
268         } else if (modulo <= MASK_MODULO_40 * 2) {
269             rollUnder = getRollUnder(betMask, 2);
270             mask = betMask;
271         } else if (modulo == 100) {
272             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
273             rollUnder = betMask;
274         } else if (modulo <= MASK_MODULO_40 * 3) {
275             rollUnder = getRollUnder(betMask, 3);
276             mask = betMask;
277         } else if (modulo <= MASK_MODULO_40 * 4) {
278             rollUnder = getRollUnder(betMask, 4);
279             mask = betMask;
280         } else if (modulo <= MASK_MODULO_40 * 5) {
281             rollUnder = getRollUnder(betMask, 5);
282             mask = betMask;
283         } else if (modulo <= MAX_MASK_MODULO) {
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
298         (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);
299 
300         // Enforce max profit limit.
301         require(possibleWinAmount <= msg.value + maxProfit, "maxProfit limit violation.");
302 
303         // Lock funds.
304         lockedInBets += uint128(possibleWinAmount);
305         jackpotSize += uint128(jackpotFee);
306 
307         // Check whether contract has enough funds to process this bet.
308         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
309 
310         // Record commit in logs.
311         emit Commit(commit, source);
312 
313         // Store bet parameters on blockchain.
314         bet.amount = uint80(msg.value);
315         bet.modulo = uint8(modulo);
316         bet.rollUnder = uint8(rollUnder);
317         bet.placeBlockNumber = uint40(block.number);
318         bet.mask = uint216(mask);
319         bet.gambler = msg.sender;
320         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
321     }
322 
323     function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
324         rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
325         for (uint i = 1; i < n; i++) {
326             betMask = betMask >> MASK_MODULO_40;
327             rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
328         }
329         return rollUnder;
330     }
331 
332     // This is the method used to settle 99% of bets. To process a bet with a specific
333     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
334     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
335     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
336     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
337         uint commit = uint(keccak256(abi.encodePacked(reveal)));
338 
339         Bet storage bet = bets[commit];
340         uint placeBlockNumber = bet.placeBlockNumber;
341 
342         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
343         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
344         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
345         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
346 
347         // Settle bet using reveal and blockHash as entropy sources.
348         settleBetCommon(bet, reveal, blockHash, commit);
349     }
350 
351     // Common settlement code for settleBet.
352     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash, uint commit) private {
353         // Fetch bet parameters into local variables (to save gas).
354         uint amount = bet.amount;
355         uint modulo = bet.modulo;
356         uint rollUnder = bet.rollUnder;
357         address payable gambler = bet.gambler;
358 
359         // Check that bet is in 'active' state.
360         require(amount != 0, "Bet should be in an 'active' state");
361 
362         // Move bet into 'processed' state already.
363         bet.amount = 0;
364 
365         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
366         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
367         // preimage is intractable), and house is unable to alter the "reveal" after
368         // placeBet have been mined (as Keccak256 collision finding is also intractable).
369         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
370         //        emit DebugBytes32("entropy", entropy);
371 
372         // Do a roll by taking a modulo of entropy. Compute winning amount.
373         uint dice = uint(entropy) % modulo;
374 
375         uint diceWinAmount;
376         uint _jackpotFee;
377         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
378 
379         uint diceWin = 0;
380         uint jackpotWin = 0;
381 
382         // Determine dice outcome.
383         if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
384             // For small modulo games, check the outcome against a bit mask.
385             if ((2 ** dice) & bet.mask != 0) {
386                 diceWin = diceWinAmount;
387             }
388         } else {
389             // For larger modulos, check inclusion into half-open interval.
390             if (dice < rollUnder) {
391                 diceWin = diceWinAmount;
392             }
393         }
394 
395         // Unlock the bet amount, regardless of the outcome.
396         lockedInBets -= uint128(diceWinAmount);
397 
398         // Roll for a jackpot (if eligible).
399         if (amount >= MIN_JACKPOT_BET) {
400             // The second modulo, statistically independent from the "main" dice roll.
401             // Effectively you are playing two games at once!
402             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
403 
404             // Bingo!
405             if (jackpotRng == 0) {
406                 jackpotWin = jackpotSize;
407                 jackpotSize = 0;
408             }
409         }
410 
411         // Log jackpot win.
412         if (jackpotWin > 0) {
413             emit JackpotPayment(gambler, jackpotWin, commit);
414         }
415 
416         // Send the funds to gambler.
417         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, commit);
418     }
419 
420     // Refund transaction - return the bet amount of a roll that was not processed in a
421     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
422     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
423     // in a situation like this, just contact us, however nothing
424     // precludes you from invoking this method yourself.
425     function refundBet(uint commit) external {
426         // Check that bet is in 'active' state.
427         Bet storage bet = bets[commit];
428         uint amount = bet.amount;
429 
430         require(amount != 0, "Bet should be in an 'active' state");
431 
432         // Check that bet has already expired.
433         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
434 
435         // Move bet into 'processed' state, release funds.
436         bet.amount = 0;
437 
438         uint diceWinAmount;
439         uint jackpotFee;
440         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
441 
442         lockedInBets -= uint128(diceWinAmount);
443         if (jackpotSize >= jackpotFee) {
444             jackpotSize -= uint128(jackpotFee);
445         }
446 
447         // Send the refund.
448         sendFunds(bet.gambler, amount, amount, commit);
449     }
450 
451     // Get the expected win amount after house edge is subtracted.
452     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
453         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
454 
455         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
456 
457         uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
458 
459         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
460             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
461         }
462 
463         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
464 
465         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
466     }
467 
468     // Helper routine to process the payment.
469     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit) private {
470         if (beneficiary.send(amount)) {
471             emit Payment(beneficiary, successLogAmount, commit);
472         } else {
473             emit FailedPayment(beneficiary, amount, commit);
474         }
475     }
476 
477     // This are some constants making O(1) population count in placeBet possible.
478     // See whitepaper for intuition and proofs behind it.
479     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
480     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
481     uint constant POPCNT_MODULO = 0x3F;
482     uint constant MASK40 = 0xFFFFFFFFFF;
483     uint constant MASK_MODULO_40 = 40;
484 }