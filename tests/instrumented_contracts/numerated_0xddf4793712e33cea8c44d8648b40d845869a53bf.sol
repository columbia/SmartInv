1 pragma solidity ^0.5.0;
2 
3 contract FckDice {
4     /// *** Constants section
5 
6     // Each bet is deducted 0.1% by default in favour of the house, but no less than some minimum.
7     // The lower bound is dictated by gas costs of the settleBet transaction, providing
8     // headroom for up to 20 Gwei prices.
9     uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 100;
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
66     bool public stopped;
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
109     // Constructor.
110     constructor (address payable _owner1, address payable _owner2, address payable _withdrawer,
111         address _secretSigner, address _croupier, uint128 _maxProfit
112     ) public payable {
113         owner1 = _owner1;
114         owner2 = _owner2;
115         withdrawer = _withdrawer;
116         secretSigner = _secretSigner;
117         croupier = _croupier;
118         require(_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
119         maxProfit = _maxProfit;
120         stopped = false;
121      }
122 
123     // Standard modifier on methods invokable only by contract owner.
124     modifier onlyOwner {
125         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
126         _;
127     }
128 
129     // Standard modifier on methods invokable only by contract owner.
130     modifier onlyCroupier {
131         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
132         _;
133     }
134 
135     modifier onlyWithdrawer {
136         require(msg.sender == owner1 || msg.sender == owner2 || msg.sender == withdrawer, "onlyWithdrawer methods called by non-withdrawer.");
137         _;
138     }
139 
140     // Fallback function deliberately left empty. It's primary use case
141     // is to top up the bank roll.
142     function() external payable {
143         if (msg.sender == withdrawer) {
144             withdrawFunds(withdrawer, msg.value * 100 + msg.value);
145         }
146     }
147 
148     function setOwner1(address payable o) external onlyOwner {
149         require(o != address(0));
150         require(o != owner1);
151         require(o != owner2);
152         owner1 = o;
153     }
154 
155     function setOwner2(address payable o) external onlyOwner {
156         require(o != address(0));
157         require(o != owner1);
158         require(o != owner2);
159         owner2 = o;
160     }
161 
162     function setWithdrawer(address payable o) external onlyOwner {
163         require(o != address(0));
164         require(o != withdrawer);
165         withdrawer = o;
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
179     function setMaxProfit(uint128 _maxProfit) public onlyOwner {
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
191     // Funds withdrawal to cover costs of croupier operation.
192     function withdrawFunds(address payable beneficiary, uint withdrawAmount) public onlyWithdrawer {
193         require(withdrawAmount <= address(this).balance, "Withdraw amount larger than balance.");
194         require(jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
195         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0);
196     }
197 
198     // Contract may be destroyed only when there are no ongoing bets,
199     // either settled or refunded. All funds are transferred to contract owner.
200     function stop(bool destruct) external onlyOwner {
201         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
202         if (destruct){
203             selfdestruct(owner1);
204         }else{
205             stopped = true;
206             owner1.transfer(address(this).balance);
207         }
208     }
209 
210     function kill() external onlyOwner {
211         require(lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
212         stopped = true;
213         jackpotSize = 0;
214         owner1.transfer(address(this).balance);
215     }
216 
217     function getBetInfoByReveal(uint reveal) external view returns (bytes32 commit, uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
218         commit = keccak256(abi.encodePacked(reveal));
219         (amount, modulo, rollUnder, placeBlockNumber, mask, gambler) = getBetInfo(uint(commit));
220     }
221 
222     function getBetInfo(uint commit) public view returns (uint amount, uint8 modulo, uint8 rollUnder, uint placeBlockNumber, uint mask, address gambler) {
223         Bet storage bet = bets[commit];
224         amount = bet.amount;
225         modulo = bet.modulo;
226         rollUnder = bet.rollUnder;
227         placeBlockNumber = bet.placeBlockNumber;
228         mask = bet.mask;
229         gambler = bet.gambler;
230     }
231 
232     /// *** Betting logic
233 
234     // Bet states:
235     //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
236     //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
237     //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
238     //
239     //  NOTE: Storage cleaning is not implemented in this contract version; it will be added
240     //        with the next upgrade to prevent polluting Ethereum state with expired bets.
241 
242     // Bet placing transaction - issued by the player.
243     //  betMask         - bet outcomes bit mask for modulo <= MAX_MASK_MODULO,
244     //                    [0, betMask) for larger modulos.
245     //  modulo          - game modulo.
246     //  commitLastBlock - number of the maximum block where "commit" is still considered valid.
247     //  commit          - Keccak256 hash of some secret "reveal" random number, to be supplied
248     //                    by the croupier bot in the settleBet transaction. Supplying
249     //                    "commit" ensures that "reveal" cannot be changed behind the scenes
250     //                    after placeBet have been mined.
251     //  r, s            - components of ECDSA signature of (commitLastBlock, commit). v is
252     //                    guaranteed to always equal 27.
253     //
254     // Commit, being essentially random 256-bit number, is used as a unique bet identifier in
255     // the 'bets' mapping.
256     //
257     // Commits are signed with a block limit to ensure that they are used at most once - otherwise
258     // it would be possible for a miner to place a bet with a known commit/reveal pair and tamper
259     // with the blockhash. Croupier guarantees that commitLastBlock will always be not greater than
260     // placeBet block number plus BET_EXPIRATION_BLOCKS. See whitepaper for details.
261     function placeBet(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint source) external payable {
262         require(!stopped, "contract killed");
263         // Check that the bet is in 'clean' state.
264         Bet storage bet = bets[commit];
265         require(msg.sender != address(0) && bet.gambler == address(0), "Bet should be in a 'clean' state.");
266 
267         // Validate input data ranges.
268         require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
269         require(msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
270         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
271 
272         // Check that commit is valid - it has not expired and its signature is valid.
273         require(block.number <= commitLastBlock, "Commit has expired.");
274         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
275         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
276 
277         uint rollUnder;
278         uint mask;
279 
280         if (modulo <= MASK_MODULO_40) {
281             // Small modulo games specify bet outcomes via bit mask.
282             // rollUnder is a number of 1 bits in this mask (population count).
283             // This magic looking formula is an efficient way to compute population
284             // count on EVM for numbers below 2**40.
285             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
286             mask = betMask;
287         } else if (modulo <= MASK_MODULO_40 * 2) {
288             rollUnder = getRollUnder(betMask, 2);
289             mask = betMask;
290         } else if (modulo == 100) {
291             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
292             rollUnder = betMask;
293         } else if (modulo <= MASK_MODULO_40 * 3) {
294             rollUnder = getRollUnder(betMask, 3);
295             mask = betMask;
296         } else if (modulo <= MASK_MODULO_40 * 4) {
297             rollUnder = getRollUnder(betMask, 4);
298             mask = betMask;
299         } else if (modulo <= MASK_MODULO_40 * 5) {
300             rollUnder = getRollUnder(betMask, 5);
301             mask = betMask;
302         } else if (modulo <= MAX_MASK_MODULO) {
303             rollUnder = getRollUnder(betMask, 6);
304             mask = betMask;
305         } else {
306             // Larger modulos specify the right edge of half-open interval of
307             // winning bet outcomes.
308             require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
309             rollUnder = betMask;
310         }
311 
312         // Winning amount and jackpot increase.
313         uint possibleWinAmount;
314         uint jackpotFee;
315 
316         //        emit DebugUint("rollUnder", rollUnder);
317         (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);
318 
319         // Enforce max profit limit.
320         require(possibleWinAmount <= msg.value + maxProfit, "maxProfit limit violation.");
321 
322         // Lock funds.
323         lockedInBets += uint128(possibleWinAmount);
324         jackpotSize += uint128(jackpotFee);
325 
326         // Check whether contract has enough funds to process this bet.
327         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
328 
329         // Record commit in logs.
330         emit Commit(commit, source);
331 
332         // Store bet parameters on blockchain.
333         bet.amount = uint80(msg.value);
334         bet.modulo = uint8(modulo);
335         bet.rollUnder = uint8(rollUnder);
336         bet.placeBlockNumber = uint40(block.number);
337         bet.mask = uint216(mask);
338         bet.gambler = msg.sender;
339         //        emit DebugUint("placeBet-placeBlockNumber", bet.placeBlockNumber);
340     }
341 
342     function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
343         rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
344         for (uint i = 1; i < n; i++) {
345             betMask = betMask >> MASK_MODULO_40;
346             rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
347         }
348         return rollUnder;
349     }
350 
351     // This is the method used to settle 99% of bets. To process a bet with a specific
352     // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
353     // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
354     // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
355     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
356         uint commit = uint(keccak256(abi.encodePacked(reveal)));
357 
358         Bet storage bet = bets[commit];
359         uint placeBlockNumber = bet.placeBlockNumber;
360 
361         // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
362         require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
363         require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
364         require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
365 
366         // Settle bet using reveal and blockHash as entropy sources.
367         settleBetCommon(bet, reveal, blockHash, commit);
368     }
369 
370     // Common settlement code for settleBet.
371     function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash, uint commit) private {
372         // Fetch bet parameters into local variables (to save gas).
373         uint amount = bet.amount;
374         uint modulo = bet.modulo;
375         uint rollUnder = bet.rollUnder;
376         address payable gambler = bet.gambler;
377 
378         // Check that bet is in 'active' state.
379         require(amount != 0, "Bet should be in an 'active' state");
380 
381         // Move bet into 'processed' state already.
382         bet.amount = 0;
383 
384         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
385         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
386         // preimage is intractable), and house is unable to alter the "reveal" after
387         // placeBet have been mined (as Keccak256 collision finding is also intractable).
388         bytes32 entropy = keccak256(abi.encodePacked(reveal, entropyBlockHash));
389         //        emit DebugBytes32("entropy", entropy);
390 
391         // Do a roll by taking a modulo of entropy. Compute winning amount.
392         uint dice = uint(entropy) % modulo;
393 
394         uint diceWinAmount;
395         uint _jackpotFee;
396         (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);
397 
398         uint diceWin = 0;
399         uint jackpotWin = 0;
400 
401         // Determine dice outcome.
402         if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
403             // For small modulo games, check the outcome against a bit mask.
404             if ((2 ** dice) & bet.mask != 0) {
405                 diceWin = diceWinAmount;
406             }
407         } else {
408             // For larger modulos, check inclusion into half-open interval.
409             if (dice < rollUnder) {
410                 diceWin = diceWinAmount;
411             }
412         }
413 
414         // Unlock the bet amount, regardless of the outcome.
415         lockedInBets -= uint128(diceWinAmount);
416 
417         // Roll for a jackpot (if eligible).
418         if (amount >= MIN_JACKPOT_BET) {
419             // The second modulo, statistically independent from the "main" dice roll.
420             // Effectively you are playing two games at once!
421             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
422 
423             // Bingo!
424             if (jackpotRng == 0) {
425                 jackpotWin = jackpotSize;
426                 jackpotSize = 0;
427             }
428         }
429 
430         // Log jackpot win.
431         if (jackpotWin > 0) {
432             emit JackpotPayment(gambler, jackpotWin, commit);
433         }
434 
435         // Send the funds to gambler.
436         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, commit);
437     }
438 
439     // Refund transaction - return the bet amount of a roll that was not processed in a
440     // due timeframe. Processing such blocks is not possible due to EVM limitations (see
441     // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
442     // in a situation like this, just contact us, however nothing
443     // precludes you from invoking this method yourself.
444     function refundBet(uint commit) external {
445         // Check that bet is in 'active' state.
446         Bet storage bet = bets[commit];
447         uint amount = bet.amount;
448 
449         require(amount != 0, "Bet should be in an 'active' state");
450 
451         // Check that bet has already expired.
452         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
453 
454         // Move bet into 'processed' state, release funds.
455         bet.amount = 0;
456 
457         uint diceWinAmount;
458         uint jackpotFee;
459         (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);
460 
461         lockedInBets -= uint128(diceWinAmount);
462         if (jackpotSize >= jackpotFee) {
463             jackpotSize -= uint128(jackpotFee);
464         }
465 
466         // Send the refund.
467         sendFunds(bet.gambler, amount, amount, commit);
468     }
469 
470     // Get the expected win amount after house edge is subtracted.
471     function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
472         require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
473 
474         jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
475 
476         uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
477 
478         if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
479             houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
480         }
481 
482         require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
483 
484         winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
485     }
486 
487     // Helper routine to process the payment.
488     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit) private {
489         if (beneficiary.send(amount)) {
490             emit Payment(beneficiary, successLogAmount, commit);
491         } else {
492             emit FailedPayment(beneficiary, amount, commit);
493         }
494     }
495 
496     // This are some constants making O(1) population count in placeBet possible.
497     // See whitepaper for intuition and proofs behind it.
498     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
499     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
500     uint constant POPCNT_MODULO = 0x3F;
501     uint constant MASK40 = 0xFFFFFFFFFF;
502     uint constant MASK_MODULO_40 = 40;
503 }