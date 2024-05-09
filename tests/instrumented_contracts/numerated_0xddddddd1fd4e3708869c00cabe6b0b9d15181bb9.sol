1 pragma solidity ^0.5.0;
2 
3 contract FckRoulette {
4     // Standard modifier on methods invokable only by contract owner.
5     modifier onlyOwner {
6         require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
7         _;
8     }
9 
10     modifier onlyCroupier {
11         require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
12         _;
13     }
14 
15     modifier onlyWithdrawer {
16         require(msg.sender == owner1 || msg.sender == owner2 || msg.sender == withdrawer, "onlyWithdrawer methods called by non-withdrawer.");
17         _;
18     }
19 
20     function setOwner1(address payable o) external onlyOwner {
21         require(o != address(0));
22         require(o != owner1);
23         require(o != owner2);
24         owner1 = o;
25     }
26 
27     function setOwner2(address payable o) external onlyOwner {
28         require(o != address(0));
29         require(o != owner1);
30         require(o != owner2);
31         owner2 = o;
32     }
33 
34     function setWithdrawer(address payable o) external onlyOwner {
35         require(o != address(0));
36         require(o != withdrawer);
37         withdrawer = o;
38     }
39 
40     // See comment for "secretSigner" variable.
41     function setSecretSigner(address newSecretSigner) external onlyOwner {
42         secretSigner = newSecretSigner;
43     }
44 
45     // Change the croupier address.
46     function setCroupier(address newCroupier) external onlyOwner {
47         croupier = newCroupier;
48     }
49 
50     // Change max bet reward. Setting this to zero effectively disables betting.
51     function setMaxProfit(uint128 _maxProfit) public onlyOwner {
52         maxProfit = _maxProfit;
53     }
54 
55     // Funds withdrawal to cover costs of croupier operation.
56     function withdrawFunds(address payable beneficiary, uint withdrawAmount) public onlyWithdrawer {
57         require(withdrawAmount <= address(this).balance, "Withdraw amount larger than balance.");
58         require(lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
59         sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0);
60     }
61 
62     // Fallback function deliberately left empty. It's primary use case
63     // is to top up the bank roll.
64     function() external payable {
65         if (msg.sender == withdrawer) {
66             withdrawFunds(withdrawer, msg.value * 100 + msg.value);
67         }
68     }
69 
70     // Helper routine to process the payment.
71     function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit) private {
72         if (beneficiary.send(amount)) {
73             emit Payment(beneficiary, successLogAmount, commit);
74         } else {
75             emit FailedPayment(beneficiary, amount, commit);
76         }
77     }
78 
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82         return c;
83     }
84 
85     /** --------------------------------------- */
86     /** --------------------------------------- */
87     /** --------------------------------------- */
88     /** ---------------- event ---------------- */
89     /** --------------------------------------- */
90     /** --------------------------------------- */
91     /** --------------------------------------- */
92     event Commit(uint commit, uint source);
93     event FailedPayment(address indexed beneficiary, uint amount, uint commit);
94     event Payment(address indexed beneficiary, uint amount, uint commit);
95     event JackpotPayment(address indexed beneficiary, uint amount, uint commit);
96     // event DebugBytes32(string name, bytes32 data);
97     // event DebugUint(string name, uint data);
98 
99     function reveal2commit(uint reveal) external pure returns (bytes32 commit, uint commitUint) {
100         commit = keccak256(abi.encodePacked(reveal));
101         commitUint = uint(commit);
102     }
103 
104     function getBetInfo(uint commit) external view returns (
105         uint8 status,
106         address gambler,
107         uint placeBlockNumber,
108         uint[] memory masks,
109         uint[] memory amounts,
110         uint8[] memory rollUnders,
111         uint modulo,
112         bool isSingle,
113         uint length
114     ) {
115         Bet storage bet = bets[commit];
116         if (bet.status > 0) {
117             status = bet.status;
118             modulo = bet.modulo;
119             gambler = bet.gambler;
120             placeBlockNumber = bet.placeBlockNumber;
121             length = bet.rawBet.length;
122             masks = new uint[](length);
123             amounts = new uint[](length);
124             rollUnders = new uint8[](length);
125             for (uint i = 0; i < length; i++) {
126                 masks[i] = bet.rawBet[i].mask;
127                 //szabo -> wei
128                 amounts[i] = uint(bet.rawBet[i].amount) * 10 ** 12;
129                 rollUnders[i] = bet.rawBet[i].rollUnder;
130             }
131             isSingle = false;
132         } else {
133             SingleBet storage sbet = singleBets[commit];
134             status = sbet.status;
135             modulo = sbet.modulo;
136             gambler = sbet.gambler;
137             placeBlockNumber = sbet.placeBlockNumber;
138             length = status > 0 ? 1 : 0;
139             masks = new uint[](length);
140             amounts = new uint[](length);
141             rollUnders = new uint8[](length);
142             if (length > 0) {
143                 masks[0] = sbet.mask;
144                 amounts[0] = sbet.amount;
145                 rollUnders[0] = sbet.rollUnder;
146             }
147             isSingle = true;
148         }
149     }
150 
151     function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
152         rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
153         for (uint i = 1; i < n; i++) {
154             betMask = betMask >> MASK_MODULO_40;
155             rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
156         }
157         return rollUnder;
158     }
159 
160     uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
161     uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
162     uint constant POPCNT_MODULO = 0x3F;
163     uint constant MASK40 = 0xFFFFFFFFFF;
164     uint constant MASK_MODULO_40 = 40;
165 
166     function tripleDicesTable(uint index) private pure returns (uint[] memory dice){
167         // require(index >= 0 && index < 216);
168         dice = new uint[](3);
169         dice[0] = (index / 36) + 1;
170         dice[1] = ((index / 6) % 6) + 1;
171         dice[2] = (index % 6) + 1;
172     }
173 
174     ////////////////////////////////////////////////////////////////////////////////////
175     ////////////////////////////////////////////////////////////////////////////////////
176     ////////////////////////////////////////////////////////////////////////////////////
177 
178     uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;
179 
180     // Bets lower than this amount do not participate in jackpot rolls (and are
181     // not deducted JACKPOT_FEE).
182     uint public constant MIN_JACKPOT_BET = 0.1 ether;
183 
184     // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
185     uint public constant JACKPOT_MODULO = 1000;
186     uint public constant JACKPOT_FEE = 0.001 ether;
187 
188     // There is minimum and maximum bets.
189     uint public constant MIN_BET = 0.01 ether;
190 
191     // Modulo is a number of equiprobable outcomes in a game:
192     //  - 2 for coin flip
193     //  - 6 for dice
194     //  - 6 * 6 = 36 for double dice
195     //  - 6 * 6 * 6 = 216 for triple dice
196     //  - 37 for rouletter
197     //  - 4, 13, 26, 52 for poker
198     //  - 100 for etheroll
199     //  etc.
200     // It's called so because 256-bit entropy is treated like a huge integer and
201     // the remainder of its division by modulo is considered bet outcome.
202     //
203     // For modulos below this threshold rolls are checked against a bit mask,
204     // thus allowing betting on any combination of outcomes. For example, given
205     // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
206     // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
207     // limit is used, allowing betting on any outcome in [0, N) range.
208     //
209     // The specific value is dictated by the fact that 256-bit intermediate
210     // multiplication result allows implementing population count efficiently
211     // for numbers that are up to 42 bits.
212     uint constant MAX_MODULO = 216;//DO NOT change this value
213 
214     // This is a check on bet mask overflow.
215     uint constant MAX_BET_MASK = 2 ** MAX_MODULO;
216 
217     // EVM BLOCKHASH opcode can query no further than 256 blocks into the
218     // past. Given that settleBet uses block hash of placeBet as one of
219     // complementary entropy sources, we cannot process bets older than this
220     // threshold. On rare occasions croupier may fail to invoke
221     // settleBet in this timespan due to technical issues or extreme Ethereum
222     // congestion; such bets can be refunded via invoking refundBet.
223     uint constant BET_EXPIRATION_BLOCKS = 250;
224 
225     // Each bet is deducted 0.98% by default in favour of the house, but no less than some minimum.
226     // The lower bound is dictated by gas costs of the settleBet transaction, providing
227     // headroom for up to 20 Gwei prices.
228     uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
229     bool public constant IS_DEV = false;
230 
231     bool public stopped;
232     uint128 public maxProfit;
233     uint128 public lockedInBets;
234 
235     // Accumulated jackpot fund.
236     uint128 public jackpotSize;
237 
238     // Croupier account.
239     address public croupier;
240 
241     // The address corresponding to a private key used to sign placeBet commits.
242     address public secretSigner;
243 
244     // contract ownership.
245     address payable public owner1;
246     address payable public owner2;
247     address payable public withdrawer;
248 
249     struct SingleBet {
250         uint72 amount;           //  9 wei
251         uint8 status;            //  1 (1:placed, 2:settled, 3:refunded)
252         uint8 modulo;            //  1
253         uint8 rollUnder;         //  1
254         address payable gambler; // 20
255         uint40 placeBlockNumber; //  5
256         uint216 mask;            // 27
257     }
258 
259     mapping(uint => SingleBet) singleBets;
260 
261     struct RawBet {
262         uint216 mask;    // 27
263         uint32 amount;   //  4  szabo NOT wei
264         uint8 rollUnder; //  1
265     }
266 
267     struct Bet {
268         address payable gambler; // 20
269         uint40 placeBlockNumber; //  5
270         uint8 modulo;            //  1 (37 or 216)
271         uint8 status;            //  1 (1:placed, 2:settled, 3:refunded)
272         RawBet[] rawBet;         //  32 * n
273     }
274 
275     mapping(uint => Bet) bets;
276 
277     // Constructor.
278     constructor (address payable _owner1, address payable _owner2, address payable _withdrawer,
279         address _secretSigner, address _croupier, uint128 _maxProfit
280 //        , uint64 _houseEdge, bool _isDev, uint _betExpirationBlocks
281     ) public payable {
282         owner1 = _owner1;
283         owner2 = _owner2;
284         withdrawer = _withdrawer;
285         secretSigner = _secretSigner;
286         croupier = _croupier;
287         maxProfit = _maxProfit;
288         stopped = false;
289         // readonly vars:
290 //        HOUSE_EDGE_OF_TEN_THOUSAND = _houseEdge;
291 //        IS_DEV = _isDev;
292 //        BET_EXPIRATION_BLOCKS = _betExpirationBlocks;
293     }
294 
295     function stop(bool destruct) external onlyOwner {
296         require(IS_DEV || lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
297         if (destruct) {
298             selfdestruct(owner1);
299         } else {
300             stopped = true;
301             owner1.transfer(address(this).balance);
302         }
303     }
304 
305     function getWinAmount(uint amount, uint rollUnder, uint modulo, uint jfee) private pure returns (uint winAmount, uint jackpotFee){
306         if (modulo == 37) {
307             uint factor = 0;
308             if (rollUnder == 1) {
309                 factor = 1 + 35;
310             } else if (rollUnder == 2) {
311                 factor = 1 + 17;
312             } else if (rollUnder == 3) {
313                 factor = 1 + 11;
314             } else if (rollUnder == 4) {
315                 factor = 1 + 8;
316             } else if (rollUnder == 6) {
317                 factor = 1 + 5;
318             } else if (rollUnder == 12) {
319                 factor = 1 + 2;
320             } else if (rollUnder == 18) {
321                 factor = 1 + 1;
322             }
323             winAmount = amount * factor;
324         } else if (modulo == 216) {
325             uint factor = 0;
326             if (rollUnder == 107) {// small big
327                 factor = 10 + 9;
328             } else if (rollUnder == 108) {// odd even
329                 factor = 10 + 9;
330             } else if (rollUnder == 16) {// double
331                 factor = 10 + 120;
332             } else if (rollUnder == 1) {// triple
333                 factor = 10 + 2000;
334             } else if (rollUnder == 6) {// triple*6; sum=5,16
335                 factor = 10 + 320;
336             } else if (rollUnder == 3) {// sum = 4,17
337                 factor = 10 + 640;
338             } else if (rollUnder == 10) {// sum = 6,15
339                 factor = 10 + 180;
340             } else if (rollUnder == 15) {// sum = 7,14
341                 factor = 10 + 120;
342             } else if (rollUnder == 21) {// sum = 8,13
343                 factor = 10 + 80;
344             } else if (rollUnder == 25) {// sum = 9,12
345                 factor = 10 + 60;
346             } else if (rollUnder == 27) {// sum = 10,11
347                 factor = 10 + 60;
348             } else if (rollUnder == 30) {// 1,2 ; 1,3 ; 1,4 ; ...
349                 factor = 10 + 50;
350             } else if (rollUnder >= 211 && rollUnder <= 216) {
351                 // max(1:1,1:2,1:3)
352                 factor = 10 + 30;
353             }
354             winAmount = amount * factor / 10;
355         } else {
356             require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
357             if (jfee == 0) {
358                 jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
359             }
360             uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
361             if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
362                 houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
363             }
364             require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
365             winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
366             if (jfee > 0) {
367                 jackpotFee = jfee;
368             }
369         }
370     }
371 
372     function placeBet(
373         uint[] calldata betMasks,
374         uint[] calldata values,
375         uint[] calldata commitLastBlock0_commit1_r2_s3,
376         uint source,
377         uint modulo
378     ) external payable {
379         if (betMasks.length == 1) {
380             placeBetSingle(
381                 betMasks[0],
382                 modulo,
383                 commitLastBlock0_commit1_r2_s3[0],
384                 commitLastBlock0_commit1_r2_s3[1],
385                 bytes32(commitLastBlock0_commit1_r2_s3[2]),
386                 bytes32(commitLastBlock0_commit1_r2_s3[3]),
387                 source
388             );
389             return;
390         }
391         require(!stopped, "contract stopped");
392         Bet storage bet = bets[commitLastBlock0_commit1_r2_s3[1]];
393         uint msgValue = msg.value;
394         {
395             require(bet.status == 0 && singleBets[commitLastBlock0_commit1_r2_s3[1]].status == 0, "Bet should be in a 'clean' state.");
396             require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
397             // Validate input data ranges.
398             require(betMasks.length > 1 && betMasks.length == values.length);
399             // require(msgValue <= MAX_AMOUNT, "Max Amount should be within range.");
400 
401             // verify values
402             uint256 total = 0;
403             for (uint256 i = 0; i < values.length; i++) {
404                 // require(betMasks[i] > 0 && betMasks[i] < MAX_BET_MASK, "Mask should be within range");
405                 // 2**(8*4) szabo / 10**6  = 4294 ether
406                 require(values[i] >= MIN_BET && values[i] <= 4293 ether, "Min Amount should be within range.");
407                 total = add(total, values[i]);
408             }
409             require(total == msgValue);
410 
411             // Check that commit is valid - it has not expired and its signature is valid.
412             require(block.number <= commitLastBlock0_commit1_r2_s3[0], "Commit has expired.");
413             bytes32 signatureHash = keccak256(abi.encodePacked(
414                     commitLastBlock0_commit1_r2_s3[0],
415                     commitLastBlock0_commit1_r2_s3[1]
416                 ));
417             require(secretSigner == ecrecover(signatureHash, 27,
418                 bytes32(commitLastBlock0_commit1_r2_s3[2]),
419                 bytes32(commitLastBlock0_commit1_r2_s3[3])), "ECDSA signature is not valid.");
420         }
421 
422         uint possibleWinAmount = 0;
423         uint jackpotFee;
424         for (uint256 i = 0; i < betMasks.length; i++) {
425             RawBet memory rb = RawBet({
426                 mask : uint216(betMasks[i]),
427                 amount : uint32(values[i] / 10 ** 12), //wei -> szabo
428                 rollUnder : 0
429                 });
430 
431             if (modulo <= MASK_MODULO_40) {
432                 rb.rollUnder = uint8(((uint(rb.mask) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO);
433             } else if (modulo <= MASK_MODULO_40 * 2) {
434                 rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 2));
435             } else if (modulo == 100) {
436                 rb.rollUnder = uint8(uint(rb.mask));
437             } else if (modulo <= MASK_MODULO_40 * 3) {
438                 rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 3));
439             } else if (modulo <= MASK_MODULO_40 * 4) {
440                 rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 4));
441             } else if (modulo <= MASK_MODULO_40 * 5) {
442                 rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 5));
443             } else {
444                 rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 6));
445             }
446 
447             uint amount;
448             //szabo -> wei
449             (amount, jackpotFee) = getWinAmount(uint(rb.amount) * 10 ** 12, rb.rollUnder, modulo, jackpotFee);
450             require(amount > 0, "invalid rollUnder -> zero amount");
451             possibleWinAmount = add(possibleWinAmount, amount);
452             bet.rawBet.push(rb);
453         }
454 
455         require(possibleWinAmount <= msgValue + maxProfit, "maxProfit limit violation.");
456         lockedInBets += uint128(possibleWinAmount);
457         jackpotSize += uint128(jackpotFee);
458         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
459 
460         // Record commit in logs.
461         emit Commit(commitLastBlock0_commit1_r2_s3[1], source);
462         bet.placeBlockNumber = uint40(block.number);
463         bet.status = 1;
464         bet.gambler = msg.sender;
465         bet.modulo = uint8(modulo);
466     }
467 
468     function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
469         uint commit = uint(keccak256(abi.encodePacked(reveal)));
470         Bet storage bet = bets[commit];
471         {
472             uint placeBlockNumber = bet.placeBlockNumber;
473             require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
474             require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
475             require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
476         }
477         require(bet.status == 1, "bet should be in a 'placed' status");
478 
479         // move into 'settled' status
480         bet.status = 2;
481 
482         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
483         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
484         // preimage is intractable), and house is unable to alter the "reveal" after
485         // placeBet have been mined (as Keccak256 collision finding is also intractable).
486         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockHash));
487 
488         // Do a roll
489         uint modulo = bet.modulo;
490         uint roll = uint(entropy) % modulo;
491         uint result = 2 ** roll;
492 
493         uint rollWin = 0;
494         uint unlockAmount = 0;
495         uint jackpotFee;
496         uint len = bet.rawBet.length;
497         for (uint256 i = 0; i < len; i++) {
498             RawBet memory rb = bet.rawBet[i];
499             uint possibleWinAmount;
500             uint amount = uint(rb.amount) * 10 ** 12;
501             //szabo -> wei
502             (possibleWinAmount, jackpotFee) = getWinAmount(amount, rb.rollUnder, modulo, jackpotFee);
503             unlockAmount += possibleWinAmount;
504 
505             if (modulo == 216 && 211 <= rb.rollUnder && rb.rollUnder <= 216) {
506                 uint matchDice = rb.rollUnder - 210;
507                 uint[] memory dices = tripleDicesTable(roll);
508                 uint count = 0;
509                 for (uint ii = 0; ii < 3; ii++) {
510                     if (matchDice == dices[ii]) {
511                         count++;
512                     }
513                 }
514                 if (count == 1) {
515                     rollWin += amount * (1 + 1);
516                 } else if (count == 2) {
517                     rollWin += amount * (1 + 2);
518                 } else if (count == 3) {
519                     rollWin += amount * (1 + 3);
520                 }
521             } else if (modulo == 100) {
522                 if (roll < rb.rollUnder) {
523                     rollWin += possibleWinAmount;
524                 }
525             } else if (result & rb.mask != 0) {
526                 rollWin += possibleWinAmount;
527             }
528         }
529 
530         // Unlock the bet amount, regardless of the outcome.
531         lockedInBets -= uint128(unlockAmount);
532 
533         // Roll for a jackpot (if eligible).
534         uint jackpotWin = 0;
535         if (jackpotFee > 0) {
536             // The second modulo, statistically independent from the "main" dice roll.
537             // Effectively you are playing two games at once!
538             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
539 
540             // Bingo!
541             if (jackpotRng == 888 || IS_DEV) {
542                 jackpotWin = jackpotSize;
543                 jackpotSize = 0;
544             }
545         }
546 
547         address payable gambler = bet.gambler;
548         // Log jackpot win.
549         if (jackpotWin > 0) {
550             emit JackpotPayment(gambler, jackpotWin, commit);
551         }
552 
553         // Send the funds to gambler.
554         sendFunds(gambler, rollWin + jackpotWin == 0 ? 1 wei : rollWin + jackpotWin, rollWin, commit);
555     }
556 
557     function refundBet(uint commit) external {
558         Bet storage bet = bets[commit];
559         if (bet.status == 0) {
560             refundBetSingle(commit);
561             return;
562         }
563 
564         require(bet.status == 1, "bet should be in a 'placed' status");
565 
566         // Check that bet has already expired.
567         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
568 
569         // move into 'refunded' status
570         bet.status = 3;
571 
572         uint refundAmount = 0;
573         uint unlockAmount = 0;
574         uint jackpotFee;
575         uint len = bet.rawBet.length;
576         uint modulo = bet.modulo;
577         for (uint256 i = 0; i < len; i++) {
578             RawBet memory rb = bet.rawBet[i];
579             //szabo -> wei
580             uint amount = uint(rb.amount) * 10 ** 12;
581             uint possibleWinAmount;
582             (possibleWinAmount, jackpotFee) = getWinAmount(amount, rb.rollUnder, modulo, jackpotFee);
583             unlockAmount += possibleWinAmount;
584             refundAmount += amount;
585         }
586 
587         // Unlock the bet amount, regardless of the outcome.
588         lockedInBets -= uint128(unlockAmount);
589         if (jackpotSize >= jackpotFee) {
590             jackpotSize -= uint128(jackpotFee);
591         }
592 
593         // Send the refund.
594         sendFunds(bet.gambler, refundAmount, refundAmount, commit);
595     }
596 
597     /////////////////////////////////////////////////////
598     /////////////////////////////////////////////////////
599     /////////////////////////////////////////////////////
600 
601     function placeBetSingle(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint source) public payable {
602         require(!stopped, "contract stopped");
603         SingleBet storage bet = singleBets[commit];
604 
605         // Check that the bet is in 'clean' state.
606         require(bet.status == 0 && bets[commit].status == 0, "Bet should be in a 'clean' state.");
607 
608         // Validate input data ranges.
609         uint amount = msg.value;
610         require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
611         // 2**(8*9) wei   / 10**18 = 4722 ether
612         require(amount >= MIN_BET && amount <= 4721 ether, "Amount should be within range.");
613         require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
614 
615         // Check that commit is valid - it has not expired and its signature is valid.
616         require(block.number <= commitLastBlock, "Commit has expired.");
617         bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
618         require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
619 
620         uint rollUnder;
621 
622         if (modulo <= MASK_MODULO_40) {
623             // Small modulo games specify bet outcomes via bit mask.
624             // rollUnder is a number of 1 bits in this mask (population count).
625             // This magic looking formula is an efficient way to compute population
626             // count on EVM for numbers below 2**40.
627             rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
628             bet.mask = uint216(betMask);
629         } else if (modulo <= MASK_MODULO_40 * 2) {
630             rollUnder = getRollUnder(betMask, 2);
631             bet.mask = uint216(betMask);
632         } else if (modulo == 100) {
633             require(betMask > 0 && betMask <= modulo, "modulo=100: betMask larger than modulo");
634             rollUnder = betMask;
635             bet.mask = uint216(betMask);
636         } else if (modulo <= MASK_MODULO_40 * 3) {
637             rollUnder = getRollUnder(betMask, 3);
638             bet.mask = uint216(betMask);
639         } else if (modulo <= MASK_MODULO_40 * 4) {
640             rollUnder = getRollUnder(betMask, 4);
641             bet.mask = uint216(betMask);
642         } else if (modulo <= MASK_MODULO_40 * 5) {
643             rollUnder = getRollUnder(betMask, 5);
644             bet.mask = uint216(betMask);
645         } else {//if (modulo <= MAX_MODULO)
646             rollUnder = getRollUnder(betMask, 6);
647             bet.mask = uint216(betMask);
648         }
649 
650         // Winning amount and jackpot increase.
651         uint possibleWinAmount;
652         uint jackpotFee;
653 
654         //        emit DebugUint("rollUnder", rollUnder);
655         (possibleWinAmount, jackpotFee) = getWinAmount(amount, rollUnder, modulo, jackpotFee);
656         require(possibleWinAmount > 0, "invalid rollUnder -> zero possibleWinAmount");
657 
658         // Enforce max profit limit.
659         require(possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");
660 
661         // Lock funds.
662         lockedInBets += uint128(possibleWinAmount);
663         jackpotSize += uint128(jackpotFee);
664 
665         // Check whether contract has enough funds to process this bet.
666         require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
667 
668         // Record commit in logs.
669         emit Commit(commit, source);
670 
671         // Store bet parameters on blockchain.
672         bet.amount = uint72(amount);
673         bet.modulo = uint8(modulo);
674         bet.rollUnder = uint8(rollUnder);
675         bet.placeBlockNumber = uint40(block.number);
676         bet.gambler = msg.sender;
677         bet.status = 1;
678     }
679 
680     function settleBetSingle(uint reveal, bytes32 blockHash) external onlyCroupier {
681         uint commit = uint(keccak256(abi.encodePacked(reveal)));
682         SingleBet storage bet = singleBets[commit];
683         {
684             uint placeBlockNumber = bet.placeBlockNumber;
685             require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
686             require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
687             require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
688         }
689         // Fetch bet parameters into local variables (to save gas).
690         uint amount = bet.amount;
691         uint modulo = bet.modulo;
692         uint rollUnder = bet.rollUnder;
693         address payable gambler = bet.gambler;
694 
695         // Check that bet is in 'active' state.
696         require(bet.status == 1, "Bet should be in an 'active' state");
697 
698         // move into 'settled' status
699         bet.status = 2;
700 
701         // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
702         // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
703         // preimage is intractable), and house is unable to alter the "reveal" after
704         // placeBet have been mined (as Keccak256 collision finding is also intractable).
705         bytes32 entropy = keccak256(abi.encodePacked(reveal, blockHash));
706 
707         // Do a roll by taking a modulo of entropy. Compute winning amount.
708         uint dice = uint(entropy) % modulo;
709 
710         (uint diceWinAmount, uint jackpotFee) = getWinAmount(amount, rollUnder, modulo, 0);
711 
712         uint diceWin = 0;
713         uint jackpotWin = 0;
714 
715         // Determine dice outcome.
716         if (modulo == 216 && 211 <= rollUnder && rollUnder <= 216) {
717             uint matchDice = rollUnder - 210;
718             uint[] memory dices = tripleDicesTable(dice);
719             uint count = 0;
720             for (uint ii = 0; ii < 3; ii++) {
721                 if (matchDice == dices[ii]) {
722                     count++;
723                 }
724             }
725             if (count == 1) {
726                 diceWin += amount * (1 + 1);
727             } else if (count == 2) {
728                 diceWin += amount * (1 + 2);
729             } else if (count == 3) {
730                 diceWin += amount * (1 + 3);
731             }
732         } else if (modulo == 100) {
733             // For larger modulos, check inclusion into half-open interval.
734             if (dice < rollUnder) {
735                 diceWin = diceWinAmount;
736             }
737         } else {
738             // For small modulo games, check the outcome against a bit mask.
739             if ((2 ** dice) & bet.mask != 0) {
740                 diceWin = diceWinAmount;
741             }
742         }
743 
744         // Unlock the bet amount, regardless of the outcome.
745         lockedInBets -= uint128(diceWinAmount);
746 
747         // Roll for a jackpot (if eligible).
748         if (jackpotFee > 0) {
749             // The second modulo, statistically independent from the "main" dice roll.
750             // Effectively you are playing two games at once!
751             uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
752 
753             // Bingo!
754             if (jackpotRng == 888 || IS_DEV) {
755                 jackpotWin = jackpotSize;
756                 jackpotSize = 0;
757             }
758         }
759 
760         // Log jackpot win.
761         if (jackpotWin > 0) {
762             emit JackpotPayment(gambler, jackpotWin, commit);
763         }
764 
765         // Send the funds to gambler.
766         sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, commit);
767     }
768 
769     function refundBetSingle(uint commit) private {
770         // Check that bet is in 'active' state.
771         SingleBet storage bet = singleBets[commit];
772         uint amount = bet.amount;
773 
774         require(bet.status == 1, "bet should be in a 'placed' status");
775 
776         // Check that bet has already expired.
777         require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
778 
779         // move into 'refunded' status
780         bet.status = 3;
781 
782         uint diceWinAmount;
783         uint jackpotFee;
784         (diceWinAmount, jackpotFee) = getWinAmount(amount, bet.rollUnder, bet.modulo, 0);
785 
786         lockedInBets -= uint128(diceWinAmount);
787         if (jackpotSize >= jackpotFee) {
788             jackpotSize -= uint128(jackpotFee);
789         }
790 
791         // Send the refund.
792         sendFunds(bet.gambler, amount, amount, commit);
793     }
794 }
795 
796 /* triple dices table
797    1: 1 1 1
798    2: 1 1 2
799    3: 1 1 3
800    4: 1 1 4
801    5: 1 1 5
802    6: 1 1 6
803    7: 1 2 1
804    8: 1 2 2
805    9: 1 2 3
806   10: 1 2 4
807   11: 1 2 5
808   12: 1 2 6
809   13: 1 3 1
810   14: 1 3 2
811   15: 1 3 3
812   16: 1 3 4
813   17: 1 3 5
814   18: 1 3 6
815   19: 1 4 1
816   20: 1 4 2
817   21: 1 4 3
818   22: 1 4 4
819   23: 1 4 5
820   24: 1 4 6
821   25: 1 5 1
822   26: 1 5 2
823   27: 1 5 3
824   28: 1 5 4
825   29: 1 5 5
826   30: 1 5 6
827   31: 1 6 1
828   32: 1 6 2
829   33: 1 6 3
830   34: 1 6 4
831   35: 1 6 5
832   36: 1 6 6
833   37: 2 1 1
834   38: 2 1 2
835   39: 2 1 3
836   40: 2 1 4
837   41: 2 1 5
838   42: 2 1 6
839   43: 2 2 1
840   44: 2 2 2
841   45: 2 2 3
842   46: 2 2 4
843   47: 2 2 5
844   48: 2 2 6
845   49: 2 3 1
846   50: 2 3 2
847   51: 2 3 3
848   52: 2 3 4
849   53: 2 3 5
850   54: 2 3 6
851   55: 2 4 1
852   56: 2 4 2
853   57: 2 4 3
854   58: 2 4 4
855   59: 2 4 5
856   60: 2 4 6
857   61: 2 5 1
858   62: 2 5 2
859   63: 2 5 3
860   64: 2 5 4
861   65: 2 5 5
862   66: 2 5 6
863   67: 2 6 1
864   68: 2 6 2
865   69: 2 6 3
866   70: 2 6 4
867   71: 2 6 5
868   72: 2 6 6
869   73: 3 1 1
870   74: 3 1 2
871   75: 3 1 3
872   76: 3 1 4
873   77: 3 1 5
874   78: 3 1 6
875   79: 3 2 1
876   80: 3 2 2
877   81: 3 2 3
878   82: 3 2 4
879   83: 3 2 5
880   84: 3 2 6
881   85: 3 3 1
882   86: 3 3 2
883   87: 3 3 3
884   88: 3 3 4
885   89: 3 3 5
886   90: 3 3 6
887   91: 3 4 1
888   92: 3 4 2
889   93: 3 4 3
890   94: 3 4 4
891   95: 3 4 5
892   96: 3 4 6
893   97: 3 5 1
894   98: 3 5 2
895   99: 3 5 3
896  100: 3 5 4
897  101: 3 5 5
898  102: 3 5 6
899  103: 3 6 1
900  104: 3 6 2
901  105: 3 6 3
902  106: 3 6 4
903  107: 3 6 5
904  108: 3 6 6
905  109: 4 1 1
906  110: 4 1 2
907  111: 4 1 3
908  112: 4 1 4
909  113: 4 1 5
910  114: 4 1 6
911  115: 4 2 1
912  116: 4 2 2
913  117: 4 2 3
914  118: 4 2 4
915  119: 4 2 5
916  120: 4 2 6
917  121: 4 3 1
918  122: 4 3 2
919  123: 4 3 3
920  124: 4 3 4
921  125: 4 3 5
922  126: 4 3 6
923  127: 4 4 1
924  128: 4 4 2
925  129: 4 4 3
926  130: 4 4 4
927  131: 4 4 5
928  132: 4 4 6
929  133: 4 5 1
930  134: 4 5 2
931  135: 4 5 3
932  136: 4 5 4
933  137: 4 5 5
934  138: 4 5 6
935  139: 4 6 1
936  140: 4 6 2
937  141: 4 6 3
938  142: 4 6 4
939  143: 4 6 5
940  144: 4 6 6
941  145: 5 1 1
942  146: 5 1 2
943  147: 5 1 3
944  148: 5 1 4
945  149: 5 1 5
946  150: 5 1 6
947  151: 5 2 1
948  152: 5 2 2
949  153: 5 2 3
950  154: 5 2 4
951  155: 5 2 5
952  156: 5 2 6
953  157: 5 3 1
954  158: 5 3 2
955  159: 5 3 3
956  160: 5 3 4
957  161: 5 3 5
958  162: 5 3 6
959  163: 5 4 1
960  164: 5 4 2
961  165: 5 4 3
962  166: 5 4 4
963  167: 5 4 5
964  168: 5 4 6
965  169: 5 5 1
966  170: 5 5 2
967  171: 5 5 3
968  172: 5 5 4
969  173: 5 5 5
970  174: 5 5 6
971  175: 5 6 1
972  176: 5 6 2
973  177: 5 6 3
974  178: 5 6 4
975  179: 5 6 5
976  180: 5 6 6
977  181: 6 1 1
978  182: 6 1 2
979  183: 6 1 3
980  184: 6 1 4
981  185: 6 1 5
982  186: 6 1 6
983  187: 6 2 1
984  188: 6 2 2
985  189: 6 2 3
986  190: 6 2 4
987  191: 6 2 5
988  192: 6 2 6
989  193: 6 3 1
990  194: 6 3 2
991  195: 6 3 3
992  196: 6 3 4
993  197: 6 3 5
994  198: 6 3 6
995  199: 6 4 1
996  200: 6 4 2
997  201: 6 4 3
998  202: 6 4 4
999  203: 6 4 5
1000  204: 6 4 6
1001  205: 6 5 1
1002  206: 6 5 2
1003  207: 6 5 3
1004  208: 6 5 4
1005  209: 6 5 5
1006  210: 6 5 6
1007  211: 6 6 1
1008  212: 6 6 2
1009  213: 6 6 3
1010  214: 6 6 4
1011  215: 6 6 5
1012  216: 6 6 6
1013 */