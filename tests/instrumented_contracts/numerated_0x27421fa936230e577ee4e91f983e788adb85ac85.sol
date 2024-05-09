1 pragma solidity ^0.4.24;
2 
3 /* solhint-disable var-name-mixedcase */
4 /* solhint-disable const-name-snakecase */
5 /* solhint-disable code-complexity */
6 /* solhint-disable max-line-length */
7 /* solhint-disable func-name-mixedcase */
8 /* solhint-disable use-forbidden-name */
9 library SafeMath {
10 
11 /**
12 * @dev Multiplies two numbers, throws on overflow.
13 */
14     function mul(uint256 a, uint256 b)
15         internal
16         pure
17         returns (uint256 c)
18     {
19         if (a == 0) {
20             return 0;
21         }
22         c = a * b;
23         require(c / a == b);
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b)
31         internal
32         pure
33         returns (uint256)
34     {
35         require(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b)
43         internal
44         pure
45         returns (uint256 c)
46     {
47         c = a + b;
48         require(c >= a);
49         return c;
50     }
51 
52     /**
53     * @dev Adds two numbers, throws on overflow.
54     */
55     function add2(uint8 a, uint8 b)
56         internal
57         pure
58         returns (uint8 c)
59     {
60         c = a + b;
61         require(c >= a);
62         return c;
63     }
64 
65 
66     /**
67     * @dev Integer division of two numbers, truncating the quotient.
68     */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b > 0);
71       // assert(b > 0); // Solidity automatically throws when dividing by 0
72       // uint256 c = a / b;
73       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76 
77     /**
78     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79     * reverts when dividing by zero.
80     */
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0);
83         return a % b;
84     }
85     /**
86      * @dev gives square root of given x.
87      */
88     function sqrt(uint256 x)
89         internal
90         pure
91         returns (uint256 y)
92     {
93         uint256 z = ((add(x,1)) / 2);
94         y = x;
95         while (z < y)
96         {
97             y = z;
98             z = ((add((x / z),z)) / 2);
99         }
100     }
101 
102     /**
103      * @dev gives square. multiplies x by x
104      */
105     function sq(uint256 x)
106         internal
107         pure
108         returns (uint256)
109     {
110         return (mul(x,x));
111     }
112 
113     /**
114      * @dev x to the power of y
115      */
116     function pwr(uint256 x, uint256 y)
117         internal
118         pure
119         returns (uint256)
120     {
121         if (x==0)
122             return (0);
123         else if (y==0)
124             return (1);
125         else
126         {
127             uint256 z = x;
128             for (uint256 i=1; i < y; i++)
129                 z = mul(z,x);
130             return (z);
131         }
132     }
133 }
134 contract Bingo {
135     using SafeMath for uint;
136 
137     MegaballInterface constant public megaballContract = MegaballInterface(address(0x3Fe2B3e8FEB33ed523cE8F786c22Cb6556f8A33F));
138     DiviesInterface constant private Divies = DiviesInterface(address(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48));
139 
140     event CardCreated(address indexed ticketOwner, uint indexed playerTicket, uint indexed stage);
141     event Payment(address indexed customerAddress, uint indexed stage);
142     event NumberCalled(uint indexed number, uint indexed stage, uint indexed total);
143     /* user withdraw event */
144     event OnWithdraw(address indexed customerAddress, uint256 ethereumWithdrawn);
145     event StageCreated(uint indexed stageNumber);
146 
147     /* modifiers */
148     modifier hasBalance() {
149         require(bingoVault[msg.sender] > 0);
150         _;
151     }
152 
153     struct Splits {
154         uint256 INCOMING_TO_CALLER_POT;
155         uint256 INCOMING_TO_MAIN_POT;
156         uint256 INCOMING_TO_JACK_POT;
157         uint256 INCOMING_TO_PAYBACK_POT;
158         uint256 INCOMING_TO_MEGABALL;
159         uint256 INCOMING_FUNDS_P3D_SHARE;
160         uint256 INCOMING_TO_NEXT_ROUND;
161         uint256 INCOMING_DENOMINATION;
162     }
163 
164     /*
165     fund allocation
166     */
167     uint256 public numberCallerPot = 0;
168     uint256 public mainBingoPot = 0;
169     uint256 public progressiveBingoPot = 0;
170     uint256 public paybackPot = 0;
171     uint256 public outboundToMegaball = 0;
172     uint256 public buyP3dFunds = 0;
173     uint256 public nextRoundSeed = 0;
174     uint256 public prevDrawBlock = 0;
175 
176 /* stages manage drawings, tickets, and peg round denominations */
177     struct Stage {
178         bool stageCompleted;
179         bool allowTicketPurchases;
180         uint256 startBlock;
181         uint256 endBlock;
182         uint256 nextDrawBlock;
183         uint256 nextDrawTime;
184         Splits stageSplits;
185         address[] numberCallers;
186         mapping(uint8 => CallStatus) calledNumbers;
187         mapping(address => Card[]) playerCards;
188     }
189 
190     struct CallStatus {
191         bool isCalled;
192         uint8 num;
193     }
194 
195     struct Card {
196         Row B;
197         Row I;
198         Row N;
199         Row G;
200         Row O;
201         address owner;
202     }
203 
204     struct Row {
205         uint8 N1;
206         uint8 N2;
207         uint8 N3;
208         uint8 N4;
209         uint8 N5;
210     }
211 
212     mapping(uint256 => Stage) public stages;
213     address public owner;
214     uint256 public numberOfStages = 0;
215     uint8 public numbersCalledThisStage;
216     bool public resetDirty = false;
217     uint256 public numberOfCardsThisStage;
218 
219     mapping(uint256 => address[]) public entrants;
220 
221     uint256 public DENOMINATION = 7000000000000000;
222 
223     mapping (address => uint256) private bingoVault;
224 
225     address[] public paybackQueue;
226     uint256 public paybackQueueCount = 0;
227     uint256 public nextPayback = 0;
228 
229     address public lastCaller;
230 
231     constructor() public
232     {
233         owner = msg.sender;
234     }
235 
236     function seedMegball()
237     internal
238     {
239         if (outboundToMegaball > 100000000000000000) {
240             uint256 value = outboundToMegaball;
241             outboundToMegaball = 0;
242             megaballContract.seedJackpot.value(value)();
243         }
244 
245     }
246 
247     function withdrawFromMB()
248     internal
249     {
250         uint256 amount = megaballContract.getMoneyballBalance();
251         if (amount > 10000000000000000) {
252             mainBingoPot = mainBingoPot.add(amount);
253             megaballContract.withdraw();
254         }
255     }
256 
257 
258     function()
259     public
260     payable
261     {
262 
263     }
264 
265     function getMBbalance()
266     public
267     view
268     returns (uint)
269     {
270       return megaballContract.getMoneyballBalance();
271     }
272 
273 
274     function withdraw()
275     external
276     hasBalance
277     {
278         uint256 amount = bingoVault[msg.sender];
279         bingoVault[msg.sender] = 0;
280 
281         emit OnWithdraw(msg.sender, amount);
282         msg.sender.transfer(amount);
283     }
284 
285 
286 
287     function initFirstStage()
288     public
289     {
290         require(numberOfStages == 0);
291         CreateStage();
292     }
293 
294 
295     function sendDivi()
296     private
297     {
298 
299         uint256 lsend = buyP3dFunds;
300         if (lsend > 0) {
301             buyP3dFunds = 0;
302             Divies.deposit.value(lsend)();
303         }
304     }
305 
306     function getStageDrawTime(uint256 _stage)
307     public
308     view
309     returns (uint256, uint256)
310     {
311         return (stages[_stage].nextDrawTime, stages[_stage].nextDrawBlock);
312     }
313 
314     function isCallNumberAvailable(uint256 _stage)
315     public
316     view
317     returns (bool, uint256, uint256)
318     {
319         if (stages[_stage].nextDrawBlock < block.number && stages[_stage].nextDrawTime < now)
320         {
321             return (true, 0, 0);
322         }
323         uint256 blocks = stages[_stage].nextDrawBlock.sub(block.number);
324         uint256 time = stages[_stage].nextDrawTime.sub(now);
325         return (false, blocks, time);
326     }
327 
328     function stageMoveDetail(uint256 _stage)
329     public
330     view
331     returns (uint, uint)
332     {
333         uint256 blocks = 0;
334         uint256 time = 0;
335 
336         if (stages[_stage].nextDrawBlock > block.number)
337         {
338             blocks = stages[_stage].nextDrawBlock.sub(block.number);
339             blocks.add(1);
340         }
341 
342         if (stages[_stage].nextDrawTime > now)
343         {
344             time = stages[_stage].nextDrawTime.sub(now);
345             time.add(1);
346         }
347 
348         return ( blocks, time );
349     }
350 
351     function getMegaballStatus()
352     internal
353     returns (bool)
354     {
355         uint256 sm1 = 0;
356         uint256 sm2 = 0;
357         uint256 _stage = megaballContract.numberOfStages();
358         _stage = _stage.sub(1);
359         (sm1, sm2) = megaballContract.stageMoveDetail(_stage);
360         if (sm1 + sm2 == 0) {
361             bool b1 = true;
362             bool b2 = true;
363             bool b3 = true;
364             bool b4 = true;
365             (b1, b2, b3, b4) = megaballContract.getStageStatus(_stage);
366             if (b4 == true) {
367                 if (megaballContract.getPlayerRaffleTickets() >= 10 && megaballContract.getRafflePlayerCount(_stage) > 7)
368                 {
369                     megaballContract.addPlayerToRaffle(address(this));
370                     //megaballContract.setDrawBlocks(_stage);
371                     //return true;
372                 }
373                 megaballContract.setDrawBlocks(_stage);
374                 return true;
375             }
376 
377             if (b4 == false) {
378                 if (megaballContract.isFinalizeValid(_stage)) {
379                     megaballContract.finalizeStage(_stage);
380                     return true;
381                 }
382             }
383             return false;
384         }
385           return false;
386     }
387 
388     function callNumbers(uint256 _stage)
389     public
390     {
391         require(stages[_stage].nextDrawBlock < block.number);
392         require(stages[_stage].nextDrawTime <= now);
393         require(numberOfCardsThisStage >= 2);
394         require(stages[_stage].stageCompleted == false);
395 
396         if (numbersCalledThisStage == 0) {
397             stages[_stage].allowTicketPurchases = false;
398         }
399 
400         if (getMegaballStatus()) {
401             paybackQueue.push(msg.sender);
402         }
403 
404         lastCaller = msg.sender;
405         stages[_stage].numberCallers.push(msg.sender);
406 
407         uint8 n1 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock)) % 74));
408 
409         uint8 resetCounter = 0;
410         if (isNumberCalled(_stage, n1) == false) {
411             callNumber(_stage, n1);
412             resetCounter++;
413         }
414 
415         uint8 n2 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock.sub(1))) % 74));
416         if (isNumberCalled(_stage, n2) == false && resetCounter == 0) {
417             callNumber(_stage, n2);
418             resetCounter++;
419         }
420 
421         uint8 n3 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock.sub(2))) % 74));
422         if (isNumberCalled(_stage, n3) == false && resetCounter == 0) {
423             callNumber(_stage, n3);
424             resetCounter++;
425         }
426 
427         uint8 n4 = SafeMath.add2(1, (uint8(blockhash(stages[_stage].nextDrawBlock.sub(3))) % 74));
428         if (isNumberCalled(_stage, n4) == false && resetCounter == 0) {
429             callNumber(_stage, n4);
430             resetCounter++;
431         }
432 
433         if (resetCounter == 0) {
434             resetDrawBlocks(_stage);
435             resetDirty = true;
436         }
437 
438         uint256 blockoffset = (block.number.sub(stages[_stage].startBlock));
439         if (blockoffset > 1000 || numbersCalledThisStage >= 75) {
440             CreateStage();
441         }
442 
443     }
444 
445     function resetDrawBlocks(uint256 _stage)
446     private
447     {
448         prevDrawBlock = stages[_stage].nextDrawBlock;
449         stages[_stage].nextDrawBlock = block.number.add(3);
450         stages[_stage].nextDrawTime = now.add(30);
451     }
452 
453     function callNumber(uint256 _stage, uint8 num)
454     internal
455     {
456         require(num < 76, "bound limit");
457         require(num > 0, "bound limit");
458 
459         stages[_stage].calledNumbers[num] = CallStatus(true, num);
460         numbersCalledThisStage = SafeMath.add2(numbersCalledThisStage, 1);
461         resetDrawBlocks(_stage);
462         emit NumberCalled(num, numberOfStages.sub(1), numbersCalledThisStage);
463     }
464 
465     function isNumberCalled(uint256 _stage, uint8 num)
466     public
467     view
468     returns (bool)
469     {
470         return (stages[_stage].calledNumbers[num].isCalled);
471     }
472 
473     function CreateStage()
474     private
475     {
476         address[] storage callers;
477         uint256 blockStart = block.number.add(10);
478         uint256 firstBlockDraw = block.number.add(10);
479         uint256 firstTimeDraw = now.add(3600);
480 
481         DENOMINATION = megaballContract.DENOMINATION();
482         uint256 ONE_PERCENT = calculateOnePercentTicketCostSplit(DENOMINATION);
483         uint256 INCOMING_TO_CALLER_POT = calculatePayoutDenomination(ONE_PERCENT, 20);
484         uint256 INCOMING_TO_MAIN_POT = calculatePayoutDenomination(ONE_PERCENT, 56);
485         uint256 INCOMING_TO_JACK_POT = calculatePayoutDenomination(ONE_PERCENT, 10);
486         uint256 INCOMING_TO_PAYBACK_POT = calculatePayoutDenomination(ONE_PERCENT, 5);
487         uint256 INCOMING_TO_MEGABALL = calculatePayoutDenomination(ONE_PERCENT, 2);
488         uint256 INCOMING_TO_P3D = calculatePayoutDenomination(ONE_PERCENT, 1);
489         uint256 INCOMING_TO_NEXT_ROUND = calculatePayoutDenomination(ONE_PERCENT, 6);
490         Splits memory stageSplits = Splits(INCOMING_TO_CALLER_POT,
491         INCOMING_TO_MAIN_POT,
492         INCOMING_TO_JACK_POT,
493         INCOMING_TO_PAYBACK_POT,
494         INCOMING_TO_MEGABALL,
495         INCOMING_TO_P3D,
496         INCOMING_TO_NEXT_ROUND,
497         DENOMINATION);
498 
499 
500         stages[numberOfStages] = Stage(false,
501         true,
502         blockStart,
503         0,
504         firstBlockDraw,
505         firstTimeDraw, stageSplits, callers);
506 
507         numbersCalledThisStage = 0;
508         numberOfCardsThisStage = 0;
509         prevDrawBlock = blockStart;
510 
511         if (numberOfStages > 0) {
512             uint256 value = nextRoundSeed;
513             nextRoundSeed = 0;
514             mainBingoPot = mainBingoPot.add(value);
515         }
516 
517         withdrawFromMB();
518         seedMegball();
519         sendDivi();
520         processPaybackQueue(numberOfStages);
521         numberOfStages = numberOfStages.add(1);
522         resetDirty = false;
523         emit StageCreated(numberOfStages);
524     }
525 
526     /* get stage blocks */
527     function getStageBlocks(uint256 _stage)
528     public
529     view
530     returns (uint, uint)
531     {
532         return (stages[_stage].startBlock, stages[_stage].endBlock);
533     }
534 
535     /*
536      this function is used for other things name it better
537     */
538     function calculatePayoutDenomination(uint256 _denomination, uint256 _multiple)
539     private
540     pure
541     returns (uint256)
542     {
543         return SafeMath.mul(_denomination, _multiple);
544     }
545 
546     /* 1% split of denomination */
547     function calculateOnePercentTicketCostSplit(uint256 _denomination)
548     private
549     pure
550     returns (uint256)
551     {
552         return SafeMath.div(_denomination, 100);
553     }
554 
555     function sort_array(uint8[5] arr_) internal pure returns (uint8[5] )
556     {
557         uint8 l = 5;
558         uint8[5] memory arr;
559 
560         for (uint8 i=0; i<l; i++)
561         {
562             arr[i] = arr_[i];
563         }
564 
565         for (i = 0; i < l; i++)
566         {
567             for (uint8 j=i+1; j < l; j++)
568             {
569                 if (arr[i] < arr[j])
570                 {
571                     uint8 temp = arr[j];
572                     arr[j] = arr[i];
573                     arr[i] = temp;
574                 }
575           }
576         }
577 
578         return arr;
579     }
580 
581     function random(uint8 startNumber, uint8 offset, uint256 _seed) private view returns (uint8) {
582         uint b = block.number.sub(offset);
583         uint8 number = SafeMath.add2(startNumber, (uint8(uint256(keccak256(abi.encodePacked(blockhash(b), msg.sender, _seed))) % 14)));
584         require(isWithinBounds(number, 1, 75));
585         return number;
586     }
587 
588     function randomArr(uint8 n1, uint256 _seed) private view returns (uint8[5]) {
589         uint8[5] memory arr = [0, 0, 0, 0, 0];
590 
591         uint8 count = 1;
592         arr[0] = random(n1, count, _seed);
593 
594         count = SafeMath.add2(count, 1);
595         while (arr[1] == 0) {
596             if (random(n1, count, _seed) != arr[0]) {
597                 arr[1] = random(n1, count, _seed);
598             }
599             count = SafeMath.add2(count, 1);
600         }
601 
602         while (arr[2] == 0) {
603             if (random(n1, count, _seed) != arr[0] && random(n1, count, _seed) != arr[1]) {
604                 arr[2] = random(n1, count, _seed);
605             }
606             count = SafeMath.add2(count, 1);
607         }
608 
609         while (arr[3] == 0) {
610             if (random(n1, count, _seed) != arr[0] && random(n1, count, _seed) != arr[1]) {
611                 if (random(n1, count, _seed) != arr[2]) {
612                     arr[3] = random(n1, count, _seed);
613                 }
614             }
615             count = SafeMath.add2(count, 1);
616         }
617 
618         while (arr[4] == 0) {
619             if (random(n1, count, _seed) != arr[0] && random(n1, count, _seed) != arr[1]) {
620                 if (random(n1, count, _seed) != arr[2] && random(n1, count, _seed) != arr[3]) {
621                     arr[4] = random(n1, count, _seed);
622                 }
623               }
624             count = SafeMath.add2(count, 1);
625         }
626         /**/
627         return arr;
628     }
629 
630     function makeRow(uint8 n1, uint256 _seed) private view returns (Row) {
631         uint8[5] memory mem = randomArr(n1, _seed);
632         uint8[5] memory mem2 = sort_array(mem);
633 
634         return Row(mem2[4], mem2[3], mem2[2], mem2[1], mem2[0]);
635     }
636 
637     function makeCard(uint256 _seed) private view returns (Card) {
638 
639         return Card(makeRow(1, _seed), makeRow(16, _seed), makeRow(31, _seed), makeRow(46, _seed), makeRow(61, _seed), msg.sender);
640     }
641 
642     /* get stage denom */
643     function getStageDenomination(uint256 _stage)
644     public
645     view
646     returns (uint)
647     {
648         return stages[_stage].stageSplits.INCOMING_DENOMINATION;
649     }
650 
651     function getStageStatus(uint256 _stage)
652     public
653     view
654     returns (bool)
655     {
656         return (stages[_stage].allowTicketPurchases);
657     }
658 
659     function createCard(uint256 _stage, uint256 _seed, uint8 team)
660     external
661     payable
662     {
663         require(stages[_stage].allowTicketPurchases);
664         require(msg.value == stages[_stage].stageSplits.INCOMING_DENOMINATION);
665         require(team > 0);
666         require(team < 4);
667         numberOfCardsThisStage = numberOfCardsThisStage.add(1);
668 
669         /* alpha */
670         if (team == 1) {
671             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_TO_CALLER_POT);
672             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_MAIN_POT);
673 
674             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_JACK_POT);
675             paybackPot = paybackPot.add(stages[_stage].stageSplits.INCOMING_TO_PAYBACK_POT);
676             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_TO_MEGABALL);
677             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_FUNDS_P3D_SHARE);
678             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_TO_NEXT_ROUND);
679         }
680 
681         /* beta */
682         if (team == 2) {
683             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_TO_JACK_POT);
684             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_MAIN_POT);
685             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_NEXT_ROUND);
686             paybackPot = paybackPot.add(stages[_stage].stageSplits.INCOMING_TO_CALLER_POT);
687             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_TO_MEGABALL);
688             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_TO_PAYBACK_POT);
689             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_FUNDS_P3D_SHARE);
690         }
691 
692         /* omega */
693         if (team == 3) {
694             numberCallerPot = numberCallerPot.add(stages[_stage].stageSplits.INCOMING_TO_JACK_POT);
695             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_MAIN_POT);
696             mainBingoPot = mainBingoPot.add(stages[_stage].stageSplits.INCOMING_TO_CALLER_POT);
697             progressiveBingoPot = progressiveBingoPot.add(stages[_stage].stageSplits.INCOMING_FUNDS_P3D_SHARE);
698             outboundToMegaball = outboundToMegaball.add(stages[_stage].stageSplits.INCOMING_TO_NEXT_ROUND);
699             buyP3dFunds = buyP3dFunds.add(stages[_stage].stageSplits.INCOMING_TO_PAYBACK_POT);
700             nextRoundSeed = nextRoundSeed.add(stages[_stage].stageSplits.INCOMING_TO_MEGABALL);
701         }
702 
703         /* push ticket into users stage def */
704         stages[_stage].playerCards[msg.sender].push(makeCard(_seed));
705         entrants[_stage].push(msg.sender);
706         stages[_stage].nextDrawTime = stages[_stage].nextDrawTime.add(1);
707         emit CardCreated(msg.sender, stages[_stage].playerCards[msg.sender].length, numberOfStages);
708 
709     }
710 
711     function claimBingo(uint256 _stage, uint256 _position)
712     external
713     {
714         require(stages[_stage].stageCompleted == false, "stage must be incomplete");
715         if (checkBingo(_stage, _position) == true) {
716             stages[_stage].stageCompleted = true;
717             stages[_stage].endBlock = block.number;
718             payTicket(_stage, msg.sender);
719             payProgressive(_stage, msg.sender);
720             payCaller(_stage);
721             repayment(_stage, msg.sender);
722             processPaybackQueue(_stage);
723             CreateStage();
724         }
725     }
726 
727     function processPaybackQueue(uint256 _stage)
728     private
729     {
730         uint256 paybackLength = paybackQueue.length;
731         uint256 value = paybackPot;
732         if (paybackLength > nextPayback) {
733             if (value > DENOMINATION) {
734                 paybackPot = paybackPot.sub(DENOMINATION);
735                 address _player = paybackQueue[nextPayback];
736                 nextPayback = nextPayback.add(1);
737                 bingoVault[_player] = bingoVault[_player].add(DENOMINATION);
738                 emit Payment(_player, _stage);
739             }
740         }
741     }
742 
743     function payCaller(uint256 _stage)
744     private
745     {
746         if (numberCallerPot > 0) {
747             uint256 amount = numberCallerPot;
748             numberCallerPot = 0;
749             uint256 callerCount = stages[_stage].numberCallers.length;
750             uint256 n1 = (uint256(blockhash(prevDrawBlock)) % callerCount);
751             address a1 = stages[_stage].numberCallers[n1];
752             bingoVault[a1] = bingoVault[a1].add(amount);
753             emit Payment(a1, _stage);
754         }
755     }
756 
757     function payProgressive(uint256 _stage, address _player)
758     private
759     {
760         if (numbersCalledThisStage < 10 && resetDirty == false) {
761             uint256 progressiveLocal = progressiveBingoPot;
762             uint256 ONE_PERCENT = calculateOnePercentTicketCostSplit(progressiveLocal);
763             uint256 amount = calculatePayoutDenomination(ONE_PERCENT, 50);
764             if (numbersCalledThisStage == 5) {
765                 amount = calculatePayoutDenomination(ONE_PERCENT, 100);
766             }
767             if (numbersCalledThisStage == 6) {
768                 amount = calculatePayoutDenomination(ONE_PERCENT, 90);
769             }
770             if (numbersCalledThisStage == 7) {
771                 amount = calculatePayoutDenomination(ONE_PERCENT, 80);
772             }
773             if (numbersCalledThisStage == 8) {
774                 amount = calculatePayoutDenomination(ONE_PERCENT, 70);
775             }
776             progressiveBingoPot = progressiveBingoPot.sub(amount);
777             bingoVault[_player] = bingoVault[_player].add(amount);
778             emit Payment(_player, _stage);
779         }
780     }
781 
782     function payTicket(uint256 _stage, address _player)
783     private
784     {
785         if (mainBingoPot > 0) {
786             uint256 amount = mainBingoPot;
787             mainBingoPot = 0;
788             bingoVault[_player] = bingoVault[_player].add(amount);
789             emit Payment(_player, _stage);
790         }
791     }
792 
793     function repayment(uint256 _stage, address _player)
794     private
795     {
796         if (numberOfCardsThisStage == 2) {
797             addToPaybacks(_stage, _player, 2);
798         }
799 
800         if (numberOfCardsThisStage == 3) {
801             addToPaybacks(_stage, _player, 3);
802         }
803 
804         if (numberOfCardsThisStage == 4) {
805             addToPaybacks(_stage, _player, 4);
806         }
807 
808         if (numberOfCardsThisStage == 5) {
809             addToPaybacks(_stage, _player, 5);
810         }
811 
812         if (numberOfCardsThisStage == 6) {
813             addToPaybacks(_stage, _player, 6);
814         }
815 
816         if (numberOfCardsThisStage > 6) {
817             uint256 playerCount = entrants[_stage].length;
818             uint256 n1 = (uint256(blockhash(prevDrawBlock)) % playerCount);
819             paybackQueue.push(entrants[_stage][n1]);
820         }
821 
822     }
823 
824     function addToPaybacks(uint256 _stage, address _player, uint8 _max)
825     private
826     {
827         for (uint8 x = 0; x < _max; x++) {
828             if (entrants[_stage][x] != _player && entrants[_stage][x] != lastCaller) {paybackQueue.push(entrants[_stage][x]);}
829         }
830 
831     }
832 
833     /* get number of players in raffle drawing */
834     function getNumberCallersCount(uint256 _stage)
835     public
836     view
837     returns (uint)
838     {
839         return stages[_stage].numberCallers.length;
840     }
841 
842     /* get number of players in raffle drawing */
843     function getPaybackPlayerCount()
844     public
845     view
846     returns (uint)
847     {
848         return paybackQueue.length;
849     }
850 
851     /* get number of players in raffle drawing */
852     function getEntrantsPlayerCount(uint256 _stage)
853     public
854     view
855     returns (uint)
856     {
857         return entrants[_stage].length;
858     }
859 
860     /*
861     *  balance functions
862     *  players main game balance
863     */
864     function getBingoBalance() public view returns (uint) {
865         return bingoVault[msg.sender];
866     }
867 
868 
869     function checkBingo(uint256 _stage, uint256 _position)
870     public
871     view
872     returns (bool)
873     {
874 
875         if (checkB(_stage, _position) == 5) { return true;}
876         if (checkI(_stage, _position) == 5) { return true;}
877         if (checkN(_stage, _position) == 5) { return true;}
878         if (checkG(_stage, _position) == 5) { return true;}
879         if (checkO(_stage, _position) == 5) { return true;}
880         if (checkH1(_stage, _position) == 5) { return true;}
881         if (checkH2(_stage, _position) == 5) { return true;}
882         if (checkH3(_stage, _position) == 5) { return true;}
883         if (checkH4(_stage, _position) == 5) { return true;}
884         if (checkH5(_stage, _position) == 5) { return true;}
885         if (checkD1(_stage, _position) == 5) { return true;}
886         if (checkD2(_stage, _position) == 5) { return true;}
887         return false;
888     }
889 
890     function checkD1(uint256 _stage, uint256 _position)
891     internal
892     view
893     returns (uint8) {
894         require(_stage <= SafeMath.sub(numberOfStages, 1));
895         uint8 count = 0;
896         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
897         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
898         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
899         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
900         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
901         return count;
902     }
903 
904     function checkD2(uint256 _stage, uint256 _position)
905     internal
906     view
907     returns (uint8) {
908         require(_stage <= SafeMath.sub(numberOfStages, 1));
909         uint8 count = 0;
910         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
911         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
912         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
913         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
914         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
915         return count;
916     }
917 
918     function checkB(uint256 _stage, uint256 _position)
919     internal
920     view
921     returns (uint8) {
922         require(_stage <= SafeMath.sub(numberOfStages, 1));
923         uint8 count = 0;
924         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
925         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N2)) {count = SafeMath.add2(count, 1);}
926         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N3)) {count = SafeMath.add2(count, 1);}
927         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N4)) {count = SafeMath.add2(count, 1);}
928         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
929         return count;
930     }
931 
932     function checkI(uint256 _stage, uint256 _position)
933     internal
934     view
935     returns (uint8) {
936         require(_stage <= SafeMath.sub(numberOfStages, 1));
937         uint8 count = 0;
938         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N1)) {count = SafeMath.add2(count, 1);}
939         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
940         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N3)) {count = SafeMath.add2(count, 1);}
941         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
942         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N5)) {count = SafeMath.add2(count, 1);}
943         return count;
944     }
945 
946     function checkN(uint256 _stage, uint256 _position)
947     internal
948     view
949     returns (uint8)  {
950         require(_stage <= SafeMath.sub(numberOfStages, 1));
951         uint8 count = 0;
952         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N1)) {count = SafeMath.add2(count, 1);}
953         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N2)) {count = SafeMath.add2(count, 1);}
954         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
955         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N4)) {count = SafeMath.add2(count, 1);}
956         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N5)) {count = SafeMath.add2(count, 1);}
957         return count;
958     }
959 
960     function checkG(uint256 _stage, uint256 _position) public view returns (uint8)  {
961         require(_stage <= SafeMath.sub(numberOfStages, 1));
962         uint8 count = 0;
963         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N1)) {count = SafeMath.add2(count, 1);}
964         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
965         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N3)) {count = SafeMath.add2(count, 1);}
966         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
967         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N5)) {count = SafeMath.add2(count, 1);}
968         return count;
969     }
970 
971     function checkO(uint256 _stage, uint256 _position)
972     internal
973     view
974     returns (uint8)  {
975         require(_stage <= SafeMath.sub(numberOfStages, 1));
976         uint8 count = 0;
977         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
978         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N2)) {count = SafeMath.add2(count, 1);}
979         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N3)) {count = SafeMath.add2(count, 1);}
980         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N4)) {count = SafeMath.add2(count, 1);}
981         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
982         return count;
983     }
984 
985     function checkH1(uint256 _stage, uint256 _position)
986     internal
987     view
988     returns (uint8) {
989         require(_stage <= SafeMath.sub(numberOfStages, 1));
990         uint8 count = 0;
991         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N1)) {count = SafeMath.add2(count, 1);}
992         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N1)) {count = SafeMath.add2(count, 1);}
993         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N1)) {count = SafeMath.add2(count, 1);}
994         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N1)) {count = SafeMath.add2(count, 1);}
995         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N1)) {count = SafeMath.add2(count, 1);}
996         return count;
997     }
998 
999     function checkH2(uint256 _stage, uint256 _position)
1000     internal
1001     view
1002     returns (uint8) {
1003         require(_stage <= SafeMath.sub(numberOfStages, 1));
1004         uint8 count = 0;
1005         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N2)) {count = SafeMath.add2(count, 1);}
1006         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N2)) {count = SafeMath.add2(count, 1);}
1007         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N2)) {count = SafeMath.add2(count, 1);}
1008         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N2)) {count = SafeMath.add2(count, 1);}
1009         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N2)) {count = SafeMath.add2(count, 1);}
1010         return count;
1011     }
1012 
1013     function checkH3(uint256 _stage, uint256 _position)
1014     internal
1015     view
1016     returns (uint8) {
1017         require(_stage <= SafeMath.sub(numberOfStages, 1));
1018         uint8 count = 0;
1019         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N3)) {count = SafeMath.add2(count, 1);}
1020         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N3)) {count = SafeMath.add2(count, 1);}
1021         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N3)) {count = SafeMath.add2(count, 1);}
1022         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N3)) {count = SafeMath.add2(count, 1);}
1023         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N3)) {count = SafeMath.add2(count, 1);}
1024         return count;
1025     }
1026 
1027 
1028     function checkH4(uint256 _stage, uint256 _position)
1029     internal
1030     view
1031     returns (uint8) {
1032         require(_stage <= SafeMath.sub(numberOfStages, 1));
1033         uint8 count = 0;
1034         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N4)) {count = SafeMath.add2(count, 1);}
1035         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N4)) {count = SafeMath.add2(count, 1);}
1036         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N4)) {count = SafeMath.add2(count, 1);}
1037         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N4)) {count = SafeMath.add2(count, 1);}
1038         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N4)) {count = SafeMath.add2(count, 1);}
1039         return count;
1040     }
1041 
1042     function checkH5(uint256 _stage, uint256 _position)
1043     internal
1044     view
1045     returns (uint8) {
1046         require(_stage <= SafeMath.sub(numberOfStages, 1));
1047         uint8 count = 0;
1048         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].B.N5)) {count = SafeMath.add2(count, 1);}
1049         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].I.N5)) {count = SafeMath.add2(count, 1);}
1050         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].N.N5)) {count = SafeMath.add2(count, 1);}
1051         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].G.N5)) {count = SafeMath.add2(count, 1);}
1052         if (isNumberCalled(_stage, stages[_stage].playerCards[msg.sender][_position].O.N5)) {count = SafeMath.add2(count, 1);}
1053         return count;
1054     }
1055 
1056     function isWithinBounds(uint8 num, uint8 min, uint8 max) internal pure returns (bool) {
1057         if (num >= min && num <= max) {return true;}
1058         return false;
1059     }
1060 
1061     function getPlayerCardsThisStage(uint256 _stage)
1062     public
1063     view
1064     returns (uint)
1065     {
1066         return (stages[_stage].playerCards[msg.sender].length);
1067     }
1068 
1069     function nextPaybacks(uint256 offset)
1070     public
1071     view
1072     returns (address)
1073     {
1074         require(offset.add(nextPayback) < paybackQueue.length);
1075         return (paybackQueue[nextPayback.add(offset)]);
1076     }
1077 
1078     function getCardRowB(uint256 _stage, uint256 _position)
1079     public
1080     view
1081     returns (uint, uint, uint, uint, uint)
1082     {
1083         require(_stage <= SafeMath.sub(numberOfStages, 1));
1084         address _player = msg.sender;
1085         return (stages[_stage].playerCards[_player][_position].B.N1,
1086         stages[_stage].playerCards[_player][_position].B.N2,
1087         stages[_stage].playerCards[_player][_position].B.N3,
1088         stages[_stage].playerCards[_player][_position].B.N4,
1089         stages[_stage].playerCards[_player][_position].B.N5);
1090     }
1091 
1092     function getCardRowI(uint256 _stage, uint256 _position)
1093     public
1094     view
1095     returns (uint, uint, uint, uint, uint)
1096     {
1097         require(_stage <= SafeMath.sub(numberOfStages, 1));
1098         address _player = msg.sender;
1099         return (stages[_stage].playerCards[_player][_position].I.N1,
1100         stages[_stage].playerCards[_player][_position].I.N2,
1101         stages[_stage].playerCards[_player][_position].I.N3,
1102         stages[_stage].playerCards[_player][_position].I.N4,
1103         stages[_stage].playerCards[_player][_position].I.N5);
1104     }
1105 
1106     function getCardRowN(uint256 _stage, uint256 _position)
1107     public
1108     view
1109     returns (uint, uint, uint, uint, uint)
1110     {
1111         require(_stage <= SafeMath.sub(numberOfStages, 1));
1112         address _player = msg.sender;
1113         return (stages[_stage].playerCards[_player][_position].N.N1,
1114         stages[_stage].playerCards[_player][_position].N.N2,
1115         stages[_stage].playerCards[_player][_position].N.N3,
1116         stages[_stage].playerCards[_player][_position].N.N4,
1117         stages[_stage].playerCards[_player][_position].N.N5);
1118     }
1119 
1120     function getCardRowG(uint256 _stage, uint256 _position)
1121     public
1122     view
1123     returns (uint, uint, uint, uint, uint)
1124     {
1125         require(_stage <= SafeMath.sub(numberOfStages, 1));
1126         address _player = msg.sender;
1127         return (stages[_stage].playerCards[_player][_position].G.N1,
1128         stages[_stage].playerCards[_player][_position].G.N2,
1129         stages[_stage].playerCards[_player][_position].G.N3,
1130         stages[_stage].playerCards[_player][_position].G.N4,
1131         stages[_stage].playerCards[_player][_position].G.N5);
1132     }
1133 
1134     function getCardRowO(uint256 _stage, uint256 _position)
1135     public
1136     view
1137     returns (uint, uint, uint, uint, uint)
1138     {
1139         require(_stage <= SafeMath.sub(numberOfStages, 1));
1140         address _player = msg.sender;
1141         return (stages[_stage].playerCards[_player][_position].O.N1,
1142         stages[_stage].playerCards[_player][_position].O.N2,
1143         stages[_stage].playerCards[_player][_position].O.N3,
1144         stages[_stage].playerCards[_player][_position].O.N4,
1145         stages[_stage].playerCards[_player][_position].O.N5);
1146     }
1147 }
1148 
1149 interface MegaballInterface {
1150     function seedJackpot() external payable;
1151     function getMoneyballBalance() external view returns (uint);
1152     function withdraw() external;
1153     function getRafflePlayerCount(uint256 _stage) external view returns (uint);
1154     function setDrawBlocks(uint256 _stage) external;
1155     function isFinalizeValid(uint256 _stage) external view returns (bool);
1156     function finalizeStage(uint256 _stage) external;
1157     function numberOfStages() external view returns (uint);
1158     function stageMoveDetail(uint256 _stage) external view returns (uint, uint);
1159     function getPlayerRaffleTickets() external view returns (uint);
1160     function getStageStatus(uint256 _stage) external view returns (bool, bool, bool, bool);
1161     function addPlayerToRaffle(address _player) external;
1162     function DENOMINATION() external view returns(uint);
1163 }
1164 
1165 interface DiviesInterface {
1166     function deposit() external payable;
1167 }