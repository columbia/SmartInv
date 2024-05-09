1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5 /**
6 * @dev Multiplies two numbers, throws on overflow.
7 */
8     function mul(uint256 a, uint256 b)
9         internal
10         pure
11         returns (uint256 c)
12     {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
23     */
24     function sub(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256)
28     {
29         require(b <= a);
30         return a - b;
31     }
32 
33     /**
34     * @dev Adds two numbers, throws on overflow.
35     */
36     function add(uint256 a, uint256 b)
37         internal
38         pure
39         returns (uint256 c)
40     {
41         c = a + b;
42         require(c >= a);
43         return c;
44     }
45 
46     /**
47     * @dev Adds two numbers, throws on overflow.
48     */
49     function add2(uint8 a, uint8 b)
50         internal
51         pure
52         returns (uint8 c)
53     {
54         c = a + b;
55         require(c >= a);
56         return c;
57     }
58 
59 
60     /**
61     * @dev Integer division of two numbers, truncating the quotient.
62     */
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b > 0);
65       // assert(b > 0); // Solidity automatically throws when dividing by 0
66       // uint256 c = a / b;
67       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68         return a / b;
69     }
70 
71     /**
72     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79     /**
80      * @dev gives square root of given x.
81      */
82     function sqrt(uint256 x)
83         internal
84         pure
85         returns (uint256 y)
86     {
87         uint256 z = ((add(x,1)) / 2);
88         y = x;
89         while (z < y)
90         {
91             y = z;
92             z = ((add((x / z),z)) / 2);
93         }
94     }
95 
96     /**
97      * @dev gives square. multiplies x by x
98      */
99     function sq(uint256 x)
100         internal
101         pure
102         returns (uint256)
103     {
104         return (mul(x,x));
105     }
106 
107     /**
108      * @dev x to the power of y
109      */
110     function pwr(uint256 x, uint256 y)
111         internal
112         pure
113         returns (uint256)
114     {
115         if (x==0)
116             return (0);
117         else if (y==0)
118             return (1);
119         else
120         {
121             uint256 z = x;
122             for (uint256 i=1; i < y; i++)
123                 z = mul(z,x);
124             return (z);
125         }
126     }
127 }
128 
129 /* solhint-disable var-name-mixedcase */
130 /* solhint-disable const-name-snakecase */
131 /* solhint-disable code-complexity */
132 /* solhint-disable max-line-length */
133 /* solhint-disable func-name-mixedcase */
134 /* solhint-disable use-forbidden-name */
135 
136 /*
137     .___           ___.                  .__
138   __| _/____   __ _\_ |__   ___________  |__| ____
139  / __ |\__  \ |  |  \ __ \_/ __ \_  __ \ |  |/  _ \
140 / /_/ | / __ \|  |  / \_\ \  ___/|  | \/ |  (  <_> )
141 \____ |(____  /____/|___  /\___  >__| /\ |__|\____/
142      \/     \/          \/     \/     \/
143 
144 B-I-N-G-O
145 
146 for everyone....
147 
148 [x] Fair
149 [x] Open Source
150 [x] Better than grandma's bingo
151 [x] made with <3.add(hate)
152 
153 Play it!
154 
155 Or don't?
156 
157 Nobody cares.
158 */
159 
160 contract Bingo {
161     using SafeMath for uint;
162 
163     MegaballInterface constant public megaballContract = MegaballInterface(address(0x3Fe2B3e8FEB33ed523cE8F786c22Cb6556f8A33F));
164     DiviesInterface constant private Divies = DiviesInterface(address(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48));
165     uint256 constant public AGENT_END_BLOCK = 232;
166     uint256 constant public ICO_BLOCK = 200;
167     uint256 constant public ICO_TIME = 3600;
168 
169     event CardCreated(address indexed ticketOwner, uint indexed playerTicket, uint indexed stage);
170     event Payment(address indexed customerAddress, uint indexed stage);
171     event NumberCalled(uint indexed number, uint indexed stage, uint indexed total);
172     /* user withdraw event */
173     event OnWithdraw(address indexed customerAddress, uint256 ethereumWithdrawn);
174     event StageCreated(uint indexed stageNumber);
175 
176     /* modifiers */
177     modifier hasBalance() {
178         require(bingoVault[msg.sender] > 0);
179         _;
180     }
181 
182     struct Splits {
183         uint256 INCOMING_FIFTYFIVE_PERCENT;
184         uint256 INCOMING_EIGHTEEN_PERCENT;
185         uint256 INCOMING_TEN_PERCENT;
186         uint256 INCOMING_SIX_PERCENT;
187         uint256 INCOMING_FIVE_PERCENT;
188         uint256 INCOMING_ONE_PERCENT;
189         uint256 INCOMING_TWO_PERCENT;
190         uint256 INCOMING_DENOMINATION;
191     }
192 
193     /*
194     fund allocation
195     */
196     uint256 public numberCallerPot = 0;
197     uint256 public mainBingoPot = 0;
198     uint256 public progressiveBingoPot = 0;
199     uint256 public paybackPot = 0;
200     uint256 public outboundToMegaball = 0;
201     uint256 public buyP3dFunds = 0;
202     uint256 public nextRoundSeed = 0;
203     uint256 public prevDrawBlock = 0;
204 
205 /* stages manage drawings, tickets, and peg round denominations */
206     struct Stage {
207         bool stageCompleted;
208         bool allowTicketPurchases;
209         uint256 startBlock;
210         uint256 endBlock;
211         uint256 nextDrawBlock;
212         uint256 nextDrawTime;
213         Splits stageSplits;
214       //  address[] numberCallers;
215         mapping(uint8 => CallStatus) calledNumbers;
216         mapping(address => Card[]) playerCards;
217     }
218 
219     struct CallStatus {
220         bool isCalled;
221         uint8 num;
222     }
223 
224     struct Card {
225         Row B;
226         Row I;
227         Row N;
228         Row G;
229         Row O;
230         address owner;
231     }
232 
233     struct Row {
234         uint8 N1;
235         uint8 N2;
236         uint8 N3;
237         uint8 N4;
238         uint8 N5;
239     }
240 
241     mapping(uint256 => address[]) public numberCallers;
242     mapping(uint256 => Stage) public stages;
243     address public owner;
244     uint256 public numberOfStages = 0;
245     uint8 public numbersCalledThisStage = 0;
246     bool public resetDirty = false;
247     uint256 public numberOfCardsThisStage = 0;
248 
249     mapping(uint256 => address[]) public entrants;
250 
251     uint256 public DENOMINATION = 7000000000000000;
252 
253     mapping (address => uint256) private bingoVault;
254 
255     address[] public paybackQueue;
256     uint256 public paybackQueueCount = 0;
257     uint256 public nextPayback = 0;
258 
259     address public lastCaller;
260     uint8 public lastNumber;
261 
262     address public lastRef;
263 
264     constructor() public
265     {
266         owner = msg.sender;
267         //initFirstStage();
268     }
269 
270     function seedMain()
271     public
272     payable
273     {
274         require(msg.value >= 100000000000000000);
275         mainBingoPot = mainBingoPot.add(msg.value);
276     }
277 
278 
279     function seedProgressive()
280     public
281     payable
282     {
283         require(msg.value >= 100000000000000000);
284         progressiveBingoPot = progressiveBingoPot.add(msg.value);
285     }
286 
287 
288     function seedMegball()
289     internal
290     {
291         if (outboundToMegaball > 10000000000000000000) {
292             uint256 value = outboundToMegaball;
293             outboundToMegaball = 0;
294             megaballContract.seedJackpot.value(value)();
295         }
296     }
297 
298     function withdrawFromMB()
299     internal
300     {
301         uint256 amount = megaballContract.getMoneyballBalance();
302         if (amount > 10000000000000000) {
303             mainBingoPot = mainBingoPot.add(amount);
304             megaballContract.withdraw();
305         }
306     }
307 
308     function()
309     public
310     payable
311     {
312 
313     }
314 
315     function getMBbalance()
316     public
317     view
318     returns (uint)
319     {
320       return megaballContract.getMoneyballBalance();
321     }
322 
323     function withdraw()
324     external
325     hasBalance
326     {
327         uint256 amount = bingoVault[msg.sender];
328         bingoVault[msg.sender] = 0;
329 
330         emit OnWithdraw(msg.sender, amount);
331         msg.sender.transfer(amount);
332     }
333 
334     function initFirstStage()
335     public
336     {
337         require(numberOfStages == 0);
338         CreateStage();
339     }
340 
341     function sendDivi()
342     private
343     {
344 
345         uint256 lsend = buyP3dFunds;
346         if (lsend > 0) {
347             buyP3dFunds = 0;
348             Divies.deposit.value(lsend)();
349         }
350     }
351 
352     function getStageDrawTime(uint256 _stage)
353     public
354     view
355     returns (uint256, uint256)
356     {
357         return (stages[_stage].nextDrawTime, stages[_stage].nextDrawBlock);
358     }
359 
360     function isCallNumberAvailable(uint256 _stage)
361     public
362     view
363     returns (bool, uint256, uint256)
364     {
365         if (stages[_stage].nextDrawBlock < block.number && stages[_stage].nextDrawTime < now)
366         {
367             return (true, 0, 0);
368         }
369         uint256 blocks = stages[_stage].nextDrawBlock.sub(block.number);
370         uint256 time = stages[_stage].nextDrawTime.sub(now);
371         return (false, blocks, time);
372     }
373 
374     function stageMoveDetail(uint256 _stage)
375     public
376     view
377     returns (uint, uint)
378     {
379         uint256 blocks = 0;
380         uint256 time = 0;
381 
382         if (stages[_stage].nextDrawBlock > block.number)
383         {
384             blocks = stages[_stage].nextDrawBlock.sub(block.number);
385             blocks.add(1);
386         }
387 
388         if (stages[_stage].nextDrawTime > now)
389         {
390             time = stages[_stage].nextDrawTime.sub(now);
391             time.add(1);
392         }
393 
394         return ( blocks, time );
395     }
396 
397     function getMegaballStatus()
398     public
399     view
400     returns (bool)
401     {
402         uint256 _stage = megaballContract.numberOfStages();
403         _stage = _stage.sub(1);
404         (uint256 sm1, uint256 sm2) = megaballContract.stageMoveDetail(_stage);
405         if (sm1.add(sm2) == 0) {
406             return true;
407         }
408         return false;
409     }
410 
411     function updateMegaballStatus()
412     private
413     {
414         uint256 _stage = megaballContract.numberOfStages();
415         _stage = _stage.sub(1);
416         (bool b1, bool b2, bool b3, bool b4) = megaballContract.getStageStatus(_stage);
417         require(b1 == false);
418         require(b3 == false);
419         if (b4 == true) {
420             if (megaballContract.getPlayerRaffleTickets() >= 10 && megaballContract.getRafflePlayerCount(_stage) > 7)
421             {
422                 megaballContract.addPlayerToRaffle(address(this));
423             }
424             megaballContract.setDrawBlocks(_stage);
425         }
426 
427         if (b4 == false && b2 == true) {
428             if (megaballContract.isFinalizeValid(_stage)) {
429                 megaballContract.finalizeStage(_stage);
430             }
431         }
432     }
433 
434     function callNumbers(uint256 _stage)
435     public
436     {
437         require(stages[_stage].nextDrawBlock < block.number);
438         require(stages[_stage].nextDrawTime <= now);
439         require(numberOfCardsThisStage >= 2);
440         require(stages[_stage].stageCompleted == false);
441 
442         if (numbersCalledThisStage == 0) {
443             stages[_stage].allowTicketPurchases = false;
444             stages[_stage].startBlock = stages[_stage].startBlock.add(block.number);
445             stages[_stage].endBlock = block.number.add(AGENT_END_BLOCK);
446         }
447 
448 
449         if (getMegaballStatus()) {
450             updateMegaballStatus();
451             paybackQueue.push(msg.sender);
452         }
453 
454 
455         lastCaller = msg.sender;
456 
457         numberCallers[_stage].push(msg.sender);
458 
459         uint8 n1 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock)) % 74));
460 
461         uint8 resetCounter = 0;
462         if (isNumberCalled(_stage, n1) == false) {
463             callNumber(_stage, n1);
464             resetCounter++;
465         }
466 
467         uint8 n2 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock.sub(1))) % 74));
468         if (isNumberCalled(_stage, n2) == false && resetCounter == 0) {
469             callNumber(_stage, n2);
470             resetCounter++;
471         }
472 
473         uint8 n3 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock.sub(2))) % 74));
474         if (isNumberCalled(_stage, n3) == false && resetCounter == 0) {
475             callNumber(_stage, n3);
476             resetCounter++;
477         }
478 
479         if (resetCounter == 0) {
480             resetDrawBlocks(_stage);
481             resetDirty = true;
482         }
483     }
484 
485 
486     function roundTimeout(uint256 _stage) public {
487         require(stages[_stage].endBlock < block.number);
488         require(stages[_stage].nextDrawTime < now);
489         require(stages[_stage].stageCompleted == false);
490         stages[_stage].stageCompleted = true;
491         CreateStage();
492     }
493 
494     function resetDrawBlocks(uint256 _stage)
495     private
496     {
497         prevDrawBlock = stages[_stage].nextDrawBlock;
498         stages[_stage].nextDrawBlock = block.number.add(3);
499         stages[_stage].nextDrawTime = now.add(30);
500     }
501 
502     function callNumber(uint256 _stage, uint8 num)
503     internal
504     {
505         require(num > 0);
506         require(num < 76);
507         stages[_stage].calledNumbers[num] = CallStatus(true, num);
508         numbersCalledThisStage = SafeMath.add2(numbersCalledThisStage, 1);
509         lastNumber = num;
510         resetDrawBlocks(_stage);
511         emit NumberCalled(num, numberOfStages.sub(1), numbersCalledThisStage);
512     }
513 
514     function getCalledNumbers(uint256 _stage, uint8 _position)
515     public
516     view
517     returns (uint8)
518     {
519         return (stages[_stage].calledNumbers[_position].num);
520     }
521 
522 
523     function isNumberCalled(uint256 _stage, uint8 num)
524     public
525     view
526     returns (bool)
527     {
528         return (stages[_stage].calledNumbers[num].isCalled);
529     }
530 
531     function CreateStage()
532     private
533     {
534 
535         if (numberOfStages > 20) {
536             DENOMINATION = megaballContract.DENOMINATION();
537         }
538 
539         uint256 ONE_PERCENT = calculateOnePercentTicketCostSplit(DENOMINATION);
540         uint256 INCOMING_FIFTYFIVE_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 55);
541         uint256 INCOMING_EIGHTEEN_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 18);
542         uint256 INCOMING_TEN_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 10);
543         uint256 INCOMING_SIX_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 6);
544         uint256 INCOMING_FIVE_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 5);
545         uint256 INCOMING_TWO_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 2);
546         uint256 INCOMING_ONE_PERCENT = calculatePayoutDenomination(ONE_PERCENT, 1);
547 
548         Splits memory stageSplits = Splits(
549         INCOMING_FIFTYFIVE_PERCENT,
550         INCOMING_EIGHTEEN_PERCENT,
551         INCOMING_TEN_PERCENT,
552         INCOMING_SIX_PERCENT,
553         INCOMING_FIVE_PERCENT,
554         INCOMING_TWO_PERCENT,
555         INCOMING_ONE_PERCENT,
556         DENOMINATION);
557 
558 
559         stages[numberOfStages] = Stage(
560         false,
561         true,
562         block.number.add(ICO_BLOCK),
563         block.number.add(AGENT_END_BLOCK),
564         block.number.add(ICO_BLOCK),
565         now.add(ICO_TIME),
566         stageSplits);
567 
568         numbersCalledThisStage = 0;
569         numberOfCardsThisStage = 0;
570         prevDrawBlock = block.number.add(ICO_BLOCK);
571 
572         if (numberOfStages > 0) {
573             uint256 value = nextRoundSeed;
574             nextRoundSeed = 0;
575             mainBingoPot = mainBingoPot.add(value);
576             processPaybackQueue(numberOfStages);
577        }
578 
579         withdrawFromMB();
580         seedMegball();
581         sendDivi();
582         numberOfStages = numberOfStages.add(1);
583         resetDirty = false;
584         emit StageCreated(numberOfStages);
585     }
586 
587     /* get stage blocks */
588     function getStageBlocks(uint256 _stage)
589     public
590     view
591     returns (uint, uint)
592     {
593         return (stages[_stage].startBlock, stages[_stage].endBlock);
594     }
595 
596     /*
597      this function is used for other things name it better
598     */
599     function calculatePayoutDenomination(uint256 _denomination, uint256 _multiple)
600     private
601     pure
602     returns (uint256)
603     {
604         return SafeMath.mul(_denomination, _multiple);
605     }
606 
607     /* 1% split of denomination */
608     function calculateOnePercentTicketCostSplit(uint256 _denomination)
609     private
610     pure
611     returns (uint256)
612     {
613         return SafeMath.div(_denomination, 100);
614     }
615 
616     function sort_array(uint8[5] arr_) internal pure returns (uint8[5] )
617     {
618         uint8 l = 5;
619         uint8[5] memory arr;
620 
621         for (uint8 i=0; i<l; i++)
622         {
623             arr[i] = arr_[i];
624         }
625 
626         for (i = 0; i < l; i++)
627         {
628             for (uint8 j=i+1; j < l; j++)
629             {
630                 if (arr[i] < arr[j])
631                 {
632                     uint8 temp = arr[j];
633                     arr[j] = arr[i];
634                     arr[i] = temp;
635                 }
636           }
637         }
638 
639         return arr;
640     }
641 
642     function random(uint8 startNumber, uint8 offset, uint256 _seed, uint8 blockOffset) private view returns (uint8) {
643         uint b = block.number.sub(blockOffset);
644         b = b.sub(offset);
645         uint256 seed = uint256(keccak256(abi.encodePacked(blockhash(b))));
646         seed.add(_seed);
647 
648         uint8 number = SafeMath.add2(startNumber, (uint8(uint256(keccak256(abi.encodePacked(seed))) % 14)));
649         return number;
650     }
651 
652     function referralSpot(uint256 _stage)
653     public
654     view
655     returns(uint)
656     {
657         uint b = block.number.sub(1);
658 
659         uint256 seed = uint256(keccak256(abi.encodePacked(
660             (block.timestamp).add
661             (block.difficulty).add
662             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
663             (block.gaslimit).add
664             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
665             (block.number)
666         )));
667 
668         uint256 number = (uint256(keccak256(abi.encodePacked(blockhash(b), seed))) % entrants[_stage].length);
669         return number;
670 
671     }
672 
673 
674     function randomArr(uint8 n1, uint256 _seed, uint8 blockOffset) private view returns (uint8[5]) {
675         uint8[5] memory arr = [0, 0, 0, 0, 0];
676 
677         uint8 count = 0;
678         arr[0] = random(n1, count, _seed, blockOffset);
679 
680         count = SafeMath.add2(count, 1);
681         while (arr[1] == 0) {
682             if (random(n1, count, _seed, blockOffset) != arr[0]) {
683                 arr[1] = random(n1, count, _seed, blockOffset);
684             }
685             count = SafeMath.add2(count, 1);
686         }
687 
688         while (arr[2] == 0) {
689             if (random(n1, count, _seed, blockOffset) != arr[0] && random(n1, count, _seed, blockOffset) != arr[1]) {
690                 arr[2] = random(n1, count, _seed, blockOffset);
691             }
692             count = SafeMath.add2(count, 1);
693         }
694 
695         while (arr[3] == 0) {
696             if (random(n1, count, _seed, blockOffset) != arr[0] && random(n1, count, _seed, blockOffset) != arr[1]) {
697                 if (random(n1, count, _seed, blockOffset) != arr[2]) {
698                     arr[3] = random(n1, count, _seed, blockOffset);
699                 }
700             }
701             count = SafeMath.add2(count, 1);
702         }
703 
704         while (arr[4] == 0) {
705             if (random(n1, count, _seed, blockOffset) != arr[0] && random(n1, count, _seed, blockOffset) != arr[1]) {
706                 if (random(n1, count, _seed, blockOffset) != arr[2] && random(n1, count, _seed, blockOffset) != arr[3]) {
707                     arr[4] = random(n1, count, _seed, blockOffset);
708                 }
709               }
710             count = SafeMath.add2(count, 1);
711         }
712         require(count < 60);
713         /**/
714         return arr;
715     }
716 
717 
718     function makeRow(uint8 n1, uint256 _seed, uint8 blockOffset) private view returns (Row) {
719         uint8[5] memory mem = randomArr(n1, _seed, blockOffset);
720         uint8[5] memory mem2 = sort_array(mem);
721 
722         return Row(mem2[4], mem2[3], mem2[2], mem2[1], mem2[0]);
723     }
724 
725     function makeCard(uint256 _seed) private view returns (Card) {
726 
727         return Card(
728         makeRow(1, _seed, 0),
729         makeRow(16, _seed, 15),
730         makeRow(31, _seed, 30),
731         makeRow(46, _seed, 45),
732         makeRow(61, _seed, 60),
733         msg.sender);
734     }
735 
736 
737     /* get stage denom */
738     function getStageDenomination(uint256 _stage)
739     public
740     view
741     returns (uint)
742     {
743         return stages[_stage].stageSplits.INCOMING_DENOMINATION;
744     }
745 
746     function getStageStatus(uint256 _stage)
747     public
748     view
749     returns (bool)
750     {
751         return (stages[_stage].allowTicketPurchases);
752     }
753 
754     function getEntrant(uint256 _stage, uint256 _pos)
755     public
756     view
757     returns (address)
758     {
759         return entrants[_stage][_pos];
760     }
761 
762     //entrants[_stage][_pos]
763 
764     function createCard(uint256 _stage, uint256 _seed, uint8 team)
765     external
766     payable
767     {
768         require(stages[_stage].allowTicketPurchases);
769         require(msg.value == stages[_stage].stageSplits.INCOMING_DENOMINATION);
770         require(_seed > 0);
771         require(team > 0);
772         require(team < 4);
773         numberOfCardsThisStage = numberOfCardsThisStage.add(1);
774 
775         /* alpha */
776         if (team == 1) {
777             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_FIFTYFIVE_PERCENT);
778             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_EIGHTEEN_PERCENT);
779             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_TEN_PERCENT);
780             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_SIX_PERCENT);
781             paybackPot = paybackPot.add(stages[_stage].stageSplits.INCOMING_FIVE_PERCENT);
782             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_TWO_PERCENT);
783             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_ONE_PERCENT);
784         }
785 
786         /* beta */
787         if (team == 2) {
788             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_FIFTYFIVE_PERCENT);
789             paybackPot = paybackPot.add(stages[_stage].stageSplits.INCOMING_EIGHTEEN_PERCENT);
790             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_TEN_PERCENT);
791             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_SIX_PERCENT);
792             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_FIVE_PERCENT);
793             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_TWO_PERCENT);
794             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_ONE_PERCENT);
795         }
796 
797         /* omega */
798         if (team == 3) {
799             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_FIFTYFIVE_PERCENT);
800             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_EIGHTEEN_PERCENT);
801             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_TEN_PERCENT);
802             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_TWO_PERCENT);
803             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_SIX_PERCENT);
804             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_FIVE_PERCENT);
805             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_ONE_PERCENT);
806         }
807 
808 
809           //THERES A MYSTERY 3% we assume and done store cuz of stack depth problems w/ struct
810 
811         if (entrants[_stage].length > 5) {
812         //    uint256 aa = 20;
813             address az = getEntrant(_stage, referralSpot(_stage));
814             lastRef = az;
815             payReferral(az, stages[_stage].stageSplits.INCOMING_TWO_PERCENT);
816             payReferral(az, stages[_stage].stageSplits.INCOMING_ONE_PERCENT);
817         }
818 
819         if (entrants[_stage].length <= 5) {
820             payReferral(msg.sender, stages[_stage].stageSplits.INCOMING_TWO_PERCENT);
821             payReferral(msg.sender, stages[_stage].stageSplits.INCOMING_ONE_PERCENT);
822         }
823 
824 
825         /* push ticket into users stage def */
826         stages[_stage].playerCards[msg.sender].push(makeCard(_seed));
827         entrants[_stage].push(msg.sender);
828         stages[_stage].nextDrawTime = stages[_stage].nextDrawTime.add(1);
829         emit CardCreated(msg.sender, stages[_stage].playerCards[msg.sender].length, numberOfStages);
830 
831     }
832 
833 
834     function payReferral(address _player, uint256 _amount)
835     private
836     {
837         bingoVault[_player] = bingoVault[_player].add(_amount);
838     }
839 
840     /* contract balance */
841     function getContractBalance() public view returns (uint) {
842         return address(this).balance;
843     }
844 
845     function claimBingo(uint256 _stage, uint256 _position)
846     external
847     {
848         require(stages[_stage].stageCompleted == false, "stage must be incomplete");
849         if (checkBingo(_stage, _position) == true) {
850             stages[_stage].stageCompleted = true;
851             stages[_stage].endBlock = block.number;
852             payTicket(_stage, msg.sender);
853             payProgressive(_stage, msg.sender);
854             payCaller(_stage);
855             repayment(_stage, msg.sender);
856             processPaybackQueue(_stage);
857             CreateStage();
858         }
859     }
860 
861     function processPaybackQueue(uint256 _stage)
862     private
863     {
864         uint256 paybackLength = paybackQueue.length;
865         uint256 value = paybackPot;
866         if (paybackLength > nextPayback) {
867             if (value > DENOMINATION) {
868                 paybackPot = paybackPot.sub(DENOMINATION);
869                 address _player = paybackQueue[nextPayback];
870                 nextPayback = nextPayback.add(1);
871                 bingoVault[_player] = bingoVault[_player].add(DENOMINATION);
872                 emit Payment(_player, _stage);
873             }
874         }
875     }
876 
877 
878     function payCaller(uint256 _stage)
879     private
880     {
881         if (numberCallerPot > 0) {
882             uint256 amount = numberCallerPot;
883             numberCallerPot = 0;
884             uint256 callerCount = numberCallers[_stage].length;
885             uint256 n1 = (uint256(blockhash(prevDrawBlock)) % callerCount);
886             address a1 = numberCallers[_stage][n1];
887             bingoVault[a1] = bingoVault[a1].add(amount);
888             emit Payment(a1, _stage);
889         }
890     }
891 
892     function payProgressive(uint256 _stage, address _player)
893     private
894     {
895         if (numbersCalledThisStage <= 10 && resetDirty == false) {
896             uint256 progressiveLocal = progressiveBingoPot;
897             uint256 ONE_PERCENT = calculateOnePercentTicketCostSplit(progressiveLocal);
898             uint256 amount = calculatePayoutDenomination(ONE_PERCENT, 50);
899             if (numbersCalledThisStage == 5) {
900                 amount = calculatePayoutDenomination(ONE_PERCENT, 100);
901             }
902             if (numbersCalledThisStage == 6) {
903                 amount = calculatePayoutDenomination(ONE_PERCENT, 90);
904             }
905             if (numbersCalledThisStage == 7) {
906                 amount = calculatePayoutDenomination(ONE_PERCENT, 80);
907             }
908             if (numbersCalledThisStage == 8) {
909                 amount = calculatePayoutDenomination(ONE_PERCENT, 70);
910             }
911             progressiveBingoPot = progressiveBingoPot.sub(amount);
912             bingoVault[_player] = bingoVault[_player].add(amount);
913             emit Payment(_player, _stage);
914         }
915     }
916 
917     function payTicket(uint256 _stage, address _player)
918     private
919     {
920         if (mainBingoPot > 0) {
921             uint256 amount = mainBingoPot;
922             mainBingoPot = 0;
923             bingoVault[_player] = bingoVault[_player].add(amount);
924             emit Payment(_player, _stage);
925         }
926     }
927 
928     function repayment(uint256 _stage, address _player)
929     private
930     {
931         if (numberOfCardsThisStage == 2) {
932             addToPaybacks(_stage, _player, 2);
933         }
934 
935         if (numberOfCardsThisStage == 3) {
936             addToPaybacks(_stage, _player, 3);
937         }
938 
939         if (numberOfCardsThisStage == 4) {
940             addToPaybacks(_stage, _player, 4);
941         }
942 
943         if (numberOfCardsThisStage == 5) {
944             addToPaybacks(_stage, _player, 5);
945         }
946 
947         if (numberOfCardsThisStage > 5) {
948             uint256 playerCount = entrants[_stage].length;
949             uint256 n1 = (uint256(blockhash(prevDrawBlock)) % playerCount);
950             paybackQueue.push(entrants[_stage][n1]);
951         }
952 
953     }
954 
955     function addToPaybacks(uint256 _stage, address _player, uint8 _max)
956     private
957     {
958         for (uint8 x = 0; x < _max; x++) {
959             if (entrants[_stage][x] != _player && entrants[_stage][x] != lastCaller) {paybackQueue.push(entrants[_stage][x]);}
960         }
961 
962     }
963 
964     /* get number of players in raffle drawing */
965 
966     function getNumberCallersCount(uint256 _stage)
967     public
968     view
969     returns (uint)
970     {
971         return numberCallers[_stage].length;
972     }
973 
974 
975     /* get number of players in raffle drawing */
976     function getPaybackPlayerCount()
977     public
978     view
979     returns (uint)
980     {
981         return paybackQueue.length;
982     }
983 
984     /* get number of players in raffle drawing */
985     function getEntrantsPlayerCount(uint256 _stage)
986     public
987     view
988     returns (uint)
989     {
990         return entrants[_stage].length;
991     }
992 
993     /*
994     *  balance functions
995     *  players main game balance
996     */
997     function getBingoBalance() public view returns (uint) {
998         return bingoVault[msg.sender];
999     }
1000 
1001 
1002     function checkBingo(uint256 _stage, uint256 _position)
1003     public
1004     view
1005     returns (bool)
1006     {
1007 
1008         if (checkB(_stage, _position) == 5) { return true;}
1009         if (checkI(_stage, _position) == 5) { return true;}
1010         if (checkN(_stage, _position) == 5) { return true;}
1011         if (checkG(_stage, _position) == 5) { return true;}
1012         if (checkO(_stage, _position) == 5) { return true;}
1013         if (checkH1(_stage, _position) == 5) { return true;}
1014         if (checkH2(_stage, _position) == 5) { return true;}
1015         if (checkH3(_stage, _position) == 5) { return true;}
1016         if (checkH4(_stage, _position) == 5) { return true;}
1017         if (checkH5(_stage, _position) == 5) { return true;}
1018         if (checkD1(_stage, _position) == 5) { return true;}
1019         if (checkD2(_stage, _position) == 5) { return true;}
1020         return false;
1021     }
1022 
1023     function checkD1(uint256 _stage, uint256 _position)
1024     internal
1025     view
1026     returns (uint8) {
1027         require(_stage <= SafeMath.sub(numberOfStages, 1));
1028         uint8 count = 0;
1029         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
1030         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
1031         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
1032         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
1033         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
1034         return count;
1035     }
1036 
1037     function checkD2(uint256 _stage, uint256 _position)
1038     internal
1039     view
1040     returns (uint8) {
1041         require(_stage <= SafeMath.sub(numberOfStages, 1));
1042         uint8 count = 0;
1043         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
1044         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
1045         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
1046         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
1047         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
1048         return count;
1049     }
1050 
1051     function checkB(uint256 _stage, uint256 _position)
1052     internal
1053     view
1054     returns (uint8) {
1055         require(_stage <= SafeMath.sub(numberOfStages, 1));
1056         uint8 count = 0;
1057         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
1058         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N2)) {count = SafeMath.add2(count, 1);}
1059         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N3)) {count = SafeMath.add2(count, 1);}
1060         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N4)) {count = SafeMath.add2(count, 1);}
1061         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
1062         return count;
1063     }
1064 
1065     function checkI(uint256 _stage, uint256 _position)
1066     internal
1067     view
1068     returns (uint8) {
1069         require(_stage <= SafeMath.sub(numberOfStages, 1));
1070         uint8 count = 0;
1071         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N1)) {count = SafeMath.add2(count, 1);}
1072         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
1073         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N3)) {count = SafeMath.add2(count, 1);}
1074         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
1075         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N5)) {count = SafeMath.add2(count, 1);}
1076         return count;
1077     }
1078 
1079     function checkN(uint256 _stage, uint256 _position)
1080     internal
1081     view
1082     returns (uint8)  {
1083         require(_stage <= SafeMath.sub(numberOfStages, 1));
1084         uint8 count = 0;
1085         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N1)) {count = SafeMath.add2(count, 1);}
1086         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N2)) {count = SafeMath.add2(count, 1);}
1087         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
1088         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N4)) {count = SafeMath.add2(count, 1);}
1089         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N5)) {count = SafeMath.add2(count, 1);}
1090         return count;
1091     }
1092 
1093     function checkG(uint256 _stage, uint256 _position) public view returns (uint8)  {
1094         require(_stage <= SafeMath.sub(numberOfStages, 1));
1095         uint8 count = 0;
1096         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N1)) {count = SafeMath.add2(count, 1);}
1097         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
1098         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N3)) {count = SafeMath.add2(count, 1);}
1099         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
1100         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N5)) {count = SafeMath.add2(count, 1);}
1101         return count;
1102     }
1103 
1104     function checkO(uint256 _stage, uint256 _position)
1105     internal
1106     view
1107     returns (uint8)  {
1108         require(_stage <= SafeMath.sub(numberOfStages, 1));
1109         uint8 count = 0;
1110         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
1111         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N2)) {count = SafeMath.add2(count, 1);}
1112         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N3)) {count = SafeMath.add2(count, 1);}
1113         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N4)) {count = SafeMath.add2(count, 1);}
1114         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
1115         return count;
1116     }
1117 
1118     function checkH1(uint256 _stage, uint256 _position)
1119     internal
1120     view
1121     returns (uint8) {
1122         require(_stage <= SafeMath.sub(numberOfStages, 1));
1123         uint8 count = 0;
1124         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
1125         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N1)) {count = SafeMath.add2(count, 1);}
1126         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N1)) {count = SafeMath.add2(count, 1);}
1127         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N1)) {count = SafeMath.add2(count, 1);}
1128         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
1129         return count;
1130     }
1131 
1132     function checkH2(uint256 _stage, uint256 _position)
1133     internal
1134     view
1135     returns (uint8) {
1136         require(_stage <= SafeMath.sub(numberOfStages, 1));
1137         uint8 count = 0;
1138         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N2)) {count = SafeMath.add2(count, 1);}
1139         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
1140         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N2)) {count = SafeMath.add2(count, 1);}
1141         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
1142         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N2)) {count = SafeMath.add2(count, 1);}
1143         return count;
1144     }
1145 
1146     function checkH3(uint256 _stage, uint256 _position)
1147     internal
1148     view
1149     returns (uint8) {
1150         require(_stage <= SafeMath.sub(numberOfStages, 1));
1151         uint8 count = 0;
1152         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N3)) {count = SafeMath.add2(count, 1);}
1153         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N3)) {count = SafeMath.add2(count, 1);}
1154         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
1155         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N3)) {count = SafeMath.add2(count, 1);}
1156         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N3)) {count = SafeMath.add2(count, 1);}
1157         return count;
1158     }
1159 
1160 
1161     function checkH4(uint256 _stage, uint256 _position)
1162     internal
1163     view
1164     returns (uint8) {
1165         require(_stage <= SafeMath.sub(numberOfStages, 1));
1166         uint8 count = 0;
1167         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N4)) {count = SafeMath.add2(count, 1);}
1168         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
1169         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N4)) {count = SafeMath.add2(count, 1);}
1170         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
1171         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N4)) {count = SafeMath.add2(count, 1);}
1172         return count;
1173     }
1174 
1175     function checkH5(uint256 _stage, uint256 _position)
1176     internal
1177     view
1178     returns (uint8) {
1179         require(_stage <= SafeMath.sub(numberOfStages, 1));
1180         uint8 count = 0;
1181         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
1182         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N5)) {count = SafeMath.add2(count, 1);}
1183         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N5)) {count = SafeMath.add2(count, 1);}
1184         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N5)) {count = SafeMath.add2(count, 1);}
1185         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
1186         return count;
1187     }
1188 
1189     function isWithinBounds(uint8 num, uint8 min, uint8 max) internal pure returns (bool) {
1190         if (num >= min && num <= max) {return true;}
1191         return false;
1192     }
1193 
1194     function getPlayerCardsThisStage(uint256 _stage)
1195     public
1196     view
1197     returns (uint)
1198     {
1199         return (stages[_stage].playerCards[msg.sender].length);
1200     }
1201 
1202     function nextPaybacks(uint256 offset)
1203     public
1204     view
1205     returns (address)
1206     {
1207         require(offset.add(nextPayback) < paybackQueue.length);
1208         return (paybackQueue[nextPayback.add(offset)]);
1209     }
1210 
1211     function getCardRowB(uint256 _stage, uint256 _position)
1212     public
1213     view
1214     returns (uint, uint, uint, uint, uint)
1215     {
1216         require(_stage <= SafeMath.sub(numberOfStages, 1));
1217         address _player = msg.sender;
1218         return (stages[_stage].playerCards[_player][_position].B.N1,
1219         stages[_stage].playerCards[_player][_position].B.N2,
1220         stages[_stage].playerCards[_player][_position].B.N3,
1221         stages[_stage].playerCards[_player][_position].B.N4,
1222         stages[_stage].playerCards[_player][_position].B.N5);
1223     }
1224 
1225     function getCardRowI(uint256 _stage, uint256 _position)
1226     public
1227     view
1228     returns (uint, uint, uint, uint, uint)
1229     {
1230         require(_stage <= SafeMath.sub(numberOfStages, 1));
1231         address _player = msg.sender;
1232         return (stages[_stage].playerCards[_player][_position].I.N1,
1233         stages[_stage].playerCards[_player][_position].I.N2,
1234         stages[_stage].playerCards[_player][_position].I.N3,
1235         stages[_stage].playerCards[_player][_position].I.N4,
1236         stages[_stage].playerCards[_player][_position].I.N5);
1237     }
1238 
1239     function getCardRowN(uint256 _stage, uint256 _position)
1240     public
1241     view
1242     returns (uint, uint, uint, uint, uint)
1243     {
1244         require(_stage <= SafeMath.sub(numberOfStages, 1));
1245         address _player = msg.sender;
1246         return (stages[_stage].playerCards[_player][_position].N.N1,
1247         stages[_stage].playerCards[_player][_position].N.N2,
1248         stages[_stage].playerCards[_player][_position].N.N3,
1249         stages[_stage].playerCards[_player][_position].N.N4,
1250         stages[_stage].playerCards[_player][_position].N.N5);
1251     }
1252 
1253     function getCardRowG(uint256 _stage, uint256 _position)
1254     public
1255     view
1256     returns (uint, uint, uint, uint, uint)
1257     {
1258         require(_stage <= SafeMath.sub(numberOfStages, 1));
1259         address _player = msg.sender;
1260         return (stages[_stage].playerCards[_player][_position].G.N1,
1261         stages[_stage].playerCards[_player][_position].G.N2,
1262         stages[_stage].playerCards[_player][_position].G.N3,
1263         stages[_stage].playerCards[_player][_position].G.N4,
1264         stages[_stage].playerCards[_player][_position].G.N5);
1265     }
1266 
1267     function getCardRowO(uint256 _stage, uint256 _position)
1268     public
1269     view
1270     returns (uint, uint, uint, uint, uint)
1271     {
1272         require(_stage <= SafeMath.sub(numberOfStages, 1));
1273         address _player = msg.sender;
1274         return (stages[_stage].playerCards[_player][_position].O.N1,
1275         stages[_stage].playerCards[_player][_position].O.N2,
1276         stages[_stage].playerCards[_player][_position].O.N3,
1277         stages[_stage].playerCards[_player][_position].O.N4,
1278         stages[_stage].playerCards[_player][_position].O.N5);
1279     }
1280 }
1281 
1282 interface MegaballInterface {
1283     function seedJackpot() external payable;
1284     function getMoneyballBalance() external view returns (uint);
1285     function withdraw() external;
1286     function getRafflePlayerCount(uint256 _stage) external view returns (uint);
1287     function setDrawBlocks(uint256 _stage) external;
1288     function isFinalizeValid(uint256 _stage) external view returns (bool);
1289     function finalizeStage(uint256 _stage) external;
1290     function numberOfStages() external view returns (uint);
1291     function stageMoveDetail(uint256 _stage) external view returns (uint, uint);
1292     function getPlayerRaffleTickets() external view returns (uint);
1293     function getStageStatus(uint256 _stage) external view returns (bool, bool, bool, bool);
1294     function addPlayerToRaffle(address _player) external;
1295     function DENOMINATION() external view returns(uint);
1296 }
1297 
1298 interface DiviesInterface {
1299     function deposit() external payable;
1300 }