1 pragma solidity ^0.4.17;
2 
3 contract BitrngDice {
4   // Ownership.
5   address public owner;
6   address private nextOwner;
7 
8   // The address corresponding to a private key used to sign placeBet commits.
9   address public secretSigner;
10 
11   // Minimum and maximum bets.
12   uint constant MIN_AMOUNT = 0.01 ether;
13   uint constant MAX_AMOUNT_BIG_SMALL = 1 ether;
14   uint constant MAX_AMOUNT_SAME = 0.05 ether;
15   uint constant MAX_AMOUNT_NUMBER = 0.1 ether;
16 
17   // EVM `BLOCKHASH` opcode can query no further than 256 blocks into the
18   // past. Given that settleBet uses block hash of placeBet as one of
19   // complementary entropy sources, we cannot process bets older than this
20   // threshold. On rare occasions dice2.win croupier may fail to invoke
21   // settleBet in this timespan due to technical issues or extreme Ethereum
22   // congestion; such bets can be refunded via invoking refundBet.
23   uint constant BET_EXPIRATION_BLOCKS = 250;
24 
25   // Max bets in one game.
26   uint8 constant MAX_BET = 5;
27 
28   // Max bet types.
29   uint8 constant BET_MASK_COUNT = 22;
30 
31   // Bet flags.
32   uint24 constant BET_BIG = uint24(1 << 21);
33   uint24 constant BET_SMALL = uint24(1 << 20);
34   uint24 constant BET_SAME_1 = uint24(1 << 19);
35   uint24 constant BET_SAME_2 = uint24(1 << 18);
36   uint24 constant BET_SAME_3 = uint24(1 << 17);
37   uint24 constant BET_SAME_4 = uint24(1 << 16);
38   uint24 constant BET_SAME_5 = uint24(1 << 15);
39   uint24 constant BET_SAME_6 = uint24(1 << 14);
40   uint24 constant BET_4 = uint24(1 << 13);
41   uint24 constant BET_5 = uint24(1 << 12);
42   uint24 constant BET_6 = uint24(1 << 11);
43   uint24 constant BET_7 = uint24(1 << 10);
44   uint24 constant BET_8 = uint24(1 << 9);
45   uint24 constant BET_9 = uint24(1 << 8);
46   uint24 constant BET_10 = uint24(1 << 7);
47   uint24 constant BET_11 = uint24(1 << 6);
48   uint24 constant BET_12 = uint24(1 << 5);
49   uint24 constant BET_13 = uint24(1 << 4);
50   uint24 constant BET_14 = uint24(1 << 3);
51   uint24 constant BET_15 = uint24(1 << 2);
52   uint24 constant BET_16 = uint24(1 << 1);
53   uint24 constant BET_17 = uint24(1);
54 
55   // Funds that are locked in potentially winning bets. Prevents contract from
56   // committing to bets it cannot pay out.
57   uint public lockedInBets;
58 
59   // Set false to disable betting.
60   bool public enabled = true;
61 
62   // Some deliberately invalid address to initialize the secret signer with.
63   // Forces maintainers to invoke setSecretSigner before processing any bets.
64   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
65 
66   // The game struct, only supports 5 bet.
67   struct Game{
68     address gambler;
69     uint40 placeBlockNumber; // block number contains place bet txn
70     uint bet1Amount;
71     uint bet2Amount;
72     uint bet3Amount;
73     uint bet4Amount;
74     uint bet5Amount;
75     uint24 mask; // bet flags ored together
76   }
77 
78   // Mapping from commits to all currently active & processed bets.
79   mapping (uint => Game) games;
80 
81   // Mapping for bet type to odds
82   mapping (uint24 => uint8) odds;
83 
84   // Mapping for bet number results;
85   mapping (uint24 => uint8) betNumberResults;
86 
87   // Mapdding for bet same number results
88   mapping (uint24 => uint8) betSameResults;
89 
90   // Events that are issued to make statistic recovery easier.
91   event FailedPayment(address indexed beneficiary, uint amount);
92   event Payment(address indexed beneficiary, uint amount);
93 
94   constructor () public {
95     owner = msg.sender;
96     secretSigner = DUMMY_ADDRESS;
97 
98     // init odds
99     odds[BET_SMALL] = 2;
100     odds[BET_BIG] = 2;
101 
102     odds[BET_SAME_1] = 150;
103     odds[BET_SAME_2] = 150;
104     odds[BET_SAME_3] = 150;
105     odds[BET_SAME_4] = 150;
106     odds[BET_SAME_5] = 150;
107     odds[BET_SAME_6] = 150;
108 
109     odds[BET_9] = 6;
110     odds[BET_10] = 6;
111     odds[BET_11] = 6;
112     odds[BET_12] = 6;
113 
114     odds[BET_8] = 8;
115     odds[BET_13] = 8;
116 
117     odds[BET_7] = 12;
118     odds[BET_14] = 12;
119 
120     odds[BET_6] = 14;
121     odds[BET_15] = 14;
122 
123     odds[BET_5] = 18;
124     odds[BET_16] = 18;
125 
126     odds[BET_4] = 50;
127     odds[BET_17] = 50;
128 
129     // init results
130     betNumberResults[BET_9] = 9;
131     betNumberResults[BET_10] = 10;
132     betNumberResults[BET_11] = 11;
133     betNumberResults[BET_12] = 12;
134 
135     betNumberResults[BET_8] = 8;
136     betNumberResults[BET_13] = 13;
137 
138     betNumberResults[BET_7] = 7;
139     betNumberResults[BET_14] = 14;
140 
141     betNumberResults[BET_6] = 6;
142     betNumberResults[BET_15] = 15;
143 
144     betNumberResults[BET_5] = 5;
145     betNumberResults[BET_16] = 16;
146 
147     betNumberResults[BET_4] = 4;
148     betNumberResults[BET_17] = 17;
149 
150     betSameResults[BET_SAME_1] = 1;
151     betSameResults[BET_SAME_2] = 2;
152     betSameResults[BET_SAME_3] = 3;
153     betSameResults[BET_SAME_4] = 4;
154     betSameResults[BET_SAME_5] = 5;
155     betSameResults[BET_SAME_6] = 6;
156 
157   }
158 
159   // Place game
160   //
161   // Betmask - flags for each bet, total 22 bits.
162   // betAmount - 5 bet amounts in Wei
163   // commitLastBlock -  block number when `commit` expires
164   // commit -  sha3 of `reveal`
165   // r, s - components of ECDSA signature of (commitLastBlock, commit).
166   //        Used to check commit is generated by `secretSigner`
167   //
168   // Game states:
169   //  amount == 0 && gambler == 0 - 'clean' (can place a bet)
170   //  amount != 0 && gambler != 0 - 'active' (can be settled or refunded)
171   //  amount == 0 && gambler != 0 - 'processed' (can clean storage)
172   function placeGame(
173     uint24 betMask,
174     uint bet1Amount,
175     uint bet2Amount,
176     uint bet3Amount,
177     uint bet4Amount,
178     uint bet5Amount,
179     uint commitLastBlock,
180     uint commit,
181     bytes32 r,
182     bytes32 s
183   ) external payable
184   {
185     // Is game enabled ?
186     require (enabled, "Game is closed");
187     // Check payed amount and sum of place amount are equal.
188     require (bet1Amount + bet2Amount + bet3Amount + bet4Amount + bet5Amount == msg.value,
189       "Place amount and payment should be equal.");
190 
191     // Check that the game is in 'clean' state.
192     Game storage game = games[commit];
193     require (game.gambler == address(0),
194       "Game should be in a 'clean' state.");
195 
196     // Check that commit is valid. It has not expired and its signature is valid.
197     // r = signature[0:64]
198     // s = signature[64:128]
199     // v = signature[128:130], always 27
200     require (block.number <= commitLastBlock, "Commit has expired.");
201     bytes32 signatureHash = keccak256(abi.encodePacked(uint40(commitLastBlock), commit));
202     require (secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");
203 
204     // Try to lock amount.
205     _lockOrUnlockAmount(
206       betMask,
207       bet1Amount,
208       bet2Amount,
209       bet3Amount,
210       bet4Amount,
211       bet5Amount,
212       1
213     );
214 
215     // Store game parameters on blockchain.
216     game.placeBlockNumber = uint40(block.number);
217     game.mask = uint24(betMask);
218     game.gambler = msg.sender;
219     game.bet1Amount = bet1Amount;
220     game.bet2Amount = bet2Amount;
221     game.bet3Amount = bet3Amount;
222     game.bet4Amount = bet4Amount;
223     game.bet5Amount = bet5Amount;
224   }
225 
226   function settleGame(uint reveal, uint cleanCommit) external {
227     // `commit` for bet settlement can only be obtained by hashing a `reveal`.
228     uint commit = uint(keccak256(abi.encodePacked(reveal)));
229     // Fetch bet parameters into local variables (to save gas).
230     Game storage game = games[commit];
231     uint bet1Amount = game.bet1Amount;
232     uint bet2Amount = game.bet2Amount;
233     uint bet3Amount = game.bet3Amount;
234     uint bet4Amount = game.bet4Amount;
235     uint bet5Amount = game.bet5Amount;
236     uint placeBlockNumber = game.placeBlockNumber;
237     address gambler = game.gambler;
238     uint24 betMask = game.mask;
239 
240     // Check that bet is in 'active' state.
241     require (
242       bet1Amount != 0 ||
243       bet2Amount != 0 ||
244       bet3Amount != 0 ||
245       bet4Amount != 0 ||
246       bet5Amount != 0,
247       "Bet should be in an 'active' state");
248 
249     // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
250     require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
251     require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
252 
253     // Move bet into 'processed' state already.
254     game.bet1Amount = 0;
255     game.bet2Amount = 0;
256     game.bet3Amount = 0;
257     game.bet4Amount = 0;
258     game.bet5Amount = 0;
259 
260     // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
261     // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
262     // preimage is intractable), and house is unable to alter the "reveal" after
263     // placeBet have been mined (as Keccak256 collision finding is also intractable).
264     uint entropy = uint(
265       keccak256(abi.encodePacked(reveal, blockhash(placeBlockNumber)))
266     );
267 
268     uint winAmount = _getWinAmount(
269       uint8((entropy % 6) + 1),
270       uint8(((entropy >> 10) % 6) + 1),
271       uint8(((entropy >> 20) % 6) + 1),
272       betMask,
273       bet1Amount,
274       bet2Amount,
275       bet3Amount,
276       bet4Amount,
277       bet5Amount
278     );
279 
280     // Unlock the bet amount, regardless of the outcome.
281     _lockOrUnlockAmount(
282       betMask,
283       bet1Amount,
284       bet2Amount,
285       bet3Amount,
286       bet4Amount,
287       bet5Amount,
288       0
289     );
290 
291     // Send the funds to gambler.
292     if(winAmount > 0){
293       sendFunds(gambler, winAmount);
294     }else{
295       sendFunds(gambler, 1 wei);
296     }
297 
298     // Clear storage of some previous bet.
299     if (cleanCommit == 0) {
300         return;
301     }
302     clearProcessedBet(cleanCommit);
303   }
304 
305   // Refund transaction - return the bet amount of a roll that was not processed in a
306   // due timeframe. Processing such blocks is not possible due to EVM limitations (see
307   // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
308   // in a situation like this, just contact the dice2.win support, however nothing
309   // precludes you from invoking this method yourself.
310   function refundBet(uint commit) external {
311     // Check that bet is in 'active' state.
312     Game storage game = games[commit];
313     uint bet1Amount = game.bet1Amount;
314     uint bet2Amount = game.bet2Amount;
315     uint bet3Amount = game.bet3Amount;
316     uint bet4Amount = game.bet4Amount;
317     uint bet5Amount = game.bet5Amount;
318 
319     // Check that bet is in 'active' state.
320     require (
321       bet1Amount != 0 ||
322       bet2Amount != 0 ||
323       bet3Amount != 0 ||
324       bet4Amount != 0 ||
325       bet5Amount != 0,
326       "Bet should be in an 'active' state");
327 
328     // Check that bet has already expired.
329     require (block.number > game.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
330 
331     // Move bet into 'processed' state already.
332     game.bet1Amount = 0;
333     game.bet2Amount = 0;
334     game.bet3Amount = 0;
335     game.bet4Amount = 0;
336     game.bet5Amount = 0;
337 
338     // Unlock the bet amount.
339     _lockOrUnlockAmount(
340       game.mask,
341       bet1Amount,
342       bet2Amount,
343       bet3Amount,
344       bet4Amount,
345       bet5Amount,
346       0
347     );
348 
349     // Send the refund.
350     sendFunds(game.gambler, bet1Amount + bet2Amount + bet3Amount + bet4Amount + bet5Amount);
351   }
352 
353   // Helper routine to move 'processed' bets into 'clean' state.
354   function clearProcessedBet(uint commit) private {
355       Game storage game = games[commit];
356 
357       // Do not overwrite active bets with zeros; additionally prevent cleanup of bets
358       // for which commit signatures may have not expired yet (see whitepaper for details).
359       if (
360         game.bet1Amount != 0 ||
361         game.bet2Amount != 0 ||
362         game.bet3Amount != 0 ||
363         game.bet4Amount != 0 ||
364         game.bet5Amount != 0 ||
365         block.number <= game.placeBlockNumber + BET_EXPIRATION_BLOCKS
366       ) {
367           return;
368       }
369 
370       // Zero out the remaining storage (amount was zeroed before, delete would consume 5k
371       // more gas).
372       game.placeBlockNumber = 0;
373       game.mask = 0;
374       game.gambler = address(0);
375   }
376 
377   // A helper routine to bulk clean the storage.
378   function clearStorage(uint[] cleanCommits) external {
379       uint length = cleanCommits.length;
380 
381       for (uint i = 0; i < length; i++) {
382           clearProcessedBet(cleanCommits[i]);
383       }
384   }
385 
386   // Send funds.
387   function sendFunds(address beneficiary, uint amount) private {
388     if (beneficiary.send(amount)) {
389       emit Payment(beneficiary, amount);
390     } else {
391       emit FailedPayment(beneficiary, amount);
392     }
393   }
394 
395   // Get actual win amount.
396   // dice1, dice2, dice3 - dice from 1 to 6
397   function _getWinAmount(
398     uint8 dice1,
399     uint8 dice2,
400     uint8 dice3,
401     uint24 betMask,
402     uint bet1Amount,
403     uint bet2Amount,
404     uint bet3Amount,
405     uint bet4Amount,
406     uint bet5Amount
407   )
408   private view returns (uint winAmount)
409   {
410     uint8 betCount = 0;
411     uint24 flag = 0;
412     uint8 sum = dice1 + dice2 + dice3;
413     uint8 i = 0;
414 
415     for (i = 0; i < BET_MASK_COUNT; i++) {
416       flag = uint24(1) << i;
417       if(uint24(betMask & flag) == 0){
418         continue;
419       }else{
420         betCount += 1;
421       }
422       if(i < 14){
423         if(sum == betNumberResults[flag]){
424           winAmount += odds[flag] * _nextAmount(
425             betCount,
426             bet1Amount,
427             bet2Amount,
428             bet3Amount,
429             bet4Amount,
430             bet5Amount
431           );
432         }
433         continue;
434       }
435       if(i >= 14 && i < 20){
436         if(dice1 == betSameResults[flag] && dice1 == dice2 && dice1 == dice3){
437           winAmount += odds[flag] * _nextAmount(
438             betCount,
439             bet1Amount,
440             bet2Amount,
441             bet3Amount,
442             bet4Amount,
443             bet5Amount
444           );
445         }
446         continue;
447       }
448       if(
449         i == 20 &&
450         (sum >= 4 && sum <= 10)  &&
451         (dice1 != dice2 || dice1 != dice3 || dice2 != dice3)
452       ){
453         winAmount += odds[flag] * _nextAmount(
454           betCount,
455           bet1Amount,
456           bet2Amount,
457           bet3Amount,
458           bet4Amount,
459           bet5Amount
460         );
461       }
462       if(
463         i == 21 &&
464         (sum >= 11 && sum <= 17)  &&
465         (dice1 != dice2 || dice1 != dice3 || dice2 != dice3)
466       ){
467         winAmount += odds[flag] * _nextAmount(
468           betCount,
469           bet1Amount,
470           bet2Amount,
471           bet3Amount,
472           bet4Amount,
473           bet5Amount
474         );
475       }
476       if(betCount == MAX_BET){
477         break;
478       }
479     }
480   }
481 
482   // Choose next amount by bet count
483   function _nextAmount(
484     uint8 betCount,
485     uint bet1Amount,
486     uint bet2Amount,
487     uint bet3Amount,
488     uint bet4Amount,
489     uint bet5Amount
490   )
491   private pure returns (uint amount)
492   {
493     if(betCount == 1){
494       return bet1Amount;
495     }
496     if(betCount == 2){
497       return bet2Amount;
498     }
499     if(betCount == 3){
500       return bet3Amount;
501     }
502     if(betCount == 4){
503       return bet4Amount;
504     }
505     if(betCount == 5){
506       return bet5Amount;
507     }
508   }
509 
510 
511   // lock = 1, lock
512   // lock = 0, unlock
513   function _lockOrUnlockAmount(
514     uint24 betMask,
515     uint bet1Amount,
516     uint bet2Amount,
517     uint bet3Amount,
518     uint bet4Amount,
519     uint bet5Amount,
520     uint8 lock
521   )
522   private
523   {
524     uint8 betCount;
525     uint possibleWinAmount;
526     uint betBigSmallWinAmount = 0;
527     uint betNumberWinAmount = 0;
528     uint betSameWinAmount = 0;
529     uint24 flag = 0;
530     for (uint8 i = 0; i < BET_MASK_COUNT; i++) {
531       flag = uint24(1) << i;
532       if(uint24(betMask & flag) == 0){
533         continue;
534       }else{
535         betCount += 1;
536       }
537       if(i < 14 ){
538         betNumberWinAmount = _assertAmount(
539           betCount,
540           bet1Amount,
541           bet2Amount,
542           bet3Amount,
543           bet4Amount,
544           bet5Amount,
545           MAX_AMOUNT_NUMBER,
546           odds[flag],
547           betNumberWinAmount
548         );
549         continue;
550       }
551       if(i >= 14 && i < 20){
552         betSameWinAmount = _assertAmount(
553           betCount,
554           bet1Amount,
555           bet2Amount,
556           bet3Amount,
557           bet4Amount,
558           bet5Amount,
559           MAX_AMOUNT_SAME,
560           odds[flag],
561           betSameWinAmount
562         );
563         continue;
564       }
565       if(i >= 20){
566          betBigSmallWinAmount = _assertAmount(
567           betCount,
568           bet1Amount,
569           bet2Amount,
570           bet3Amount,
571           bet4Amount,
572           bet5Amount,
573           MAX_AMOUNT_BIG_SMALL,
574           odds[flag],
575           betBigSmallWinAmount
576         );
577         continue;
578       }
579       if(betCount == MAX_BET){
580         break;
581       }
582     }
583     if(betSameWinAmount >= betBigSmallWinAmount){
584       possibleWinAmount += betSameWinAmount;
585     }else{
586       possibleWinAmount += betBigSmallWinAmount;
587     }
588     possibleWinAmount += betNumberWinAmount;
589 
590     // Check that game has valid number of bets
591     require (betCount > 0 && betCount <= MAX_BET,
592       "Place bet count should be within range.");
593 
594     if(lock == 1){
595       // Lock funds.
596       lockedInBets += possibleWinAmount;
597       // Check whether contract has enough funds to process this bet.
598       require (lockedInBets <= address(this).balance,
599         "Cannot afford to lose this bet.");
600     }else{
601       // Unlock funds.
602       lockedInBets -= possibleWinAmount;
603       require (lockedInBets >= 0,
604         "Not enough locked in amount.");
605     }
606   }
607 
608   function _max(uint amount, uint8 odd, uint possibleWinAmount)
609   private pure returns (uint newAmount)
610   {
611     uint winAmount = amount * odd;
612     if( winAmount > possibleWinAmount){
613       return winAmount;
614     }else{
615       return possibleWinAmount;
616     }
617   }
618 
619   function _assertAmount(
620     uint8 betCount,
621     uint amount1,
622     uint amount2,
623     uint amount3,
624     uint amount4,
625     uint amount5,
626     uint maxAmount,
627     uint8 odd,
628     uint possibleWinAmount
629   )
630   private pure returns (uint amount)
631   {
632     string memory warnMsg = "Place bet amount should be within range.";
633     if(betCount == 1){
634       require (amount1 >= MIN_AMOUNT && amount1 <= maxAmount, warnMsg);
635       return _max(amount1, odd, possibleWinAmount);
636     }
637     if(betCount == 2){
638       require (amount2 >= MIN_AMOUNT && amount2 <= maxAmount, warnMsg);
639       return _max(amount2, odd, possibleWinAmount);
640     }
641     if(betCount == 3){
642       require (amount3 >= MIN_AMOUNT && amount3 <= maxAmount, warnMsg);
643       return _max(amount3, odd, possibleWinAmount);
644     }
645     if(betCount == 4){
646       require (amount4 >= MIN_AMOUNT && amount4 <= maxAmount, warnMsg);
647       return _max(amount4, odd, possibleWinAmount);
648     }
649     if(betCount == 5){
650       require (amount5 >= MIN_AMOUNT && amount5 <= maxAmount, warnMsg);
651       return _max(amount5, odd, possibleWinAmount);
652     }
653   }
654 
655   // Standard modifier on methods invokable only by contract owner.
656   modifier onlyOwner {
657       require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
658       _;
659   }
660 
661   // Standard contract ownership transfer implementation,
662   function approveNextOwner(address _nextOwner) external onlyOwner {
663     require (_nextOwner != owner, "Cannot approve current owner.");
664     nextOwner = _nextOwner;
665   }
666 
667   function acceptNextOwner() external {
668     require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
669     owner = nextOwner;
670   }
671 
672   // Fallback function deliberately left empty. It's primary use case
673   // is to top up the bank roll.
674   function () public payable {
675   }
676 
677   // See comment for "secretSigner" variable.
678   function setSecretSigner(address newSecretSigner) external onlyOwner {
679     secretSigner = newSecretSigner;
680   }
681 
682   // Funds withdrawal to cover team costs.
683   function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
684     require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
685     require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
686     sendFunds(beneficiary, withdrawAmount);
687   }
688 
689   // Contract may be destroyed only when there are no ongoing bets,
690   // either settled or refunded. All funds are transferred to contract owner.
691   function kill() external onlyOwner {
692       require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
693       selfdestruct(owner);
694   }
695 
696   // Close or open the game.
697   function enable(bool _enabled) external onlyOwner{
698     enabled = _enabled;
699   }
700 
701 }