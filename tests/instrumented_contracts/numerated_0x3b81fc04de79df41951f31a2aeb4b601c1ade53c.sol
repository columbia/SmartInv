1 pragma solidity ^0.5.0;
2 
3 /**
4  * (E)t)h)e)x) Jackpot Contract 
5  *  This smart-contract is the part of Ethex Lottery fair game.
6  *  See latest version at https://github.com/ethex-bet/ethex-contracts 
7  *  http://ethex.bet
8  */
9 
10 contract EthexJackpot {
11     mapping(uint256 => address payable) public tickets;
12     uint256 public numberEnd;
13     uint256 public firstNumber;
14     uint256 public dailyAmount;
15     uint256 public weeklyAmount;
16     uint256 public monthlyAmount;
17     uint256 public seasonalAmount;
18     bool public dailyProcessed;
19     bool public weeklyProcessed;
20     bool public monthlyProcessed;
21     bool public seasonalProcessed;
22     address payable private owner;
23     address public lotoAddress;
24     address payable public newVersionAddress;
25     EthexJackpot previousContract;
26     uint256 public dailyNumberStartPrev;
27     uint256 public weeklyNumberStartPrev;
28     uint256 public monthlyNumberStartPrev;
29     uint256 public seasonalNumberStartPrev;
30     uint256 public dailyStart;
31     uint256 public weeklyStart;
32     uint256 public monthlyStart;
33     uint256 public seasonalStart;
34     uint256 public dailyEnd;
35     uint256 public weeklyEnd;
36     uint256 public monthlyEnd;
37     uint256 public seasonalEnd;
38     uint256 public dailyNumberStart;
39     uint256 public weeklyNumberStart;
40     uint256 public monthlyNumberStart;
41     uint256 public seasonalNumberStart;
42     uint256 public dailyNumberEndPrev;
43     uint256 public weeklyNumberEndPrev;
44     uint256 public monthlyNumberEndPrev;
45     uint256 public seasonalNumberEndPrev;
46     
47     event Jackpot (
48         uint256 number,
49         uint256 count,
50         uint256 amount,
51         byte jackpotType
52     );
53     
54     event Ticket (
55         bytes16 indexed id,
56         uint256 number
57     );
58     
59     event SuperPrize (
60         uint256 amount,
61         address winner
62     );
63     
64     uint256 constant DAILY = 5000;
65     uint256 constant WEEKLY = 35000;
66     uint256 constant MONTHLY = 150000;
67     uint256 constant SEASONAL = 450000;
68     uint256 constant PRECISION = 1 ether;
69     uint256 constant DAILY_PART = 84;
70     uint256 constant WEEKLY_PART = 12;
71     uint256 constant MONTHLY_PART = 3;
72     
73     constructor() public payable {
74         owner = msg.sender;
75     }
76     
77     function() external payable { }
78 
79     modifier onlyOwner {
80         require(msg.sender == owner);
81         _;
82     }
83     
84     modifier onlyOwnerOrNewVersion {
85         require(msg.sender == owner || msg.sender == newVersionAddress);
86         _;
87     }
88     
89     modifier onlyLoto {
90         require(msg.sender == lotoAddress, "Loto only");
91         _;
92     }
93     
94     function migrate() external onlyOwnerOrNewVersion {
95         newVersionAddress.transfer(address(this).balance);
96     }
97 
98     function registerTicket(bytes16 id, address payable gamer) external onlyLoto {
99         uint256 number = numberEnd + 1;
100         if (block.number >= dailyEnd) {
101             setDaily();
102             dailyNumberStart = number;
103         }
104         else
105             if (dailyNumberStart == dailyNumberStartPrev)
106                 dailyNumberStart = number;
107         if (block.number >= weeklyEnd) {
108             setWeekly();
109             weeklyNumberStart = number;
110         }
111         else
112             if (weeklyNumberStart == weeklyNumberStartPrev)
113                 weeklyNumberStart = number;
114         if (block.number >= monthlyEnd) {
115             setMonthly();
116             monthlyNumberStart = number;
117         }
118         else
119             if (monthlyNumberStart == monthlyNumberStartPrev)
120                 monthlyNumberStart = number;
121         if (block.number >= seasonalEnd) {
122             setSeasonal();
123             seasonalNumberStart = number;
124         }
125         else
126             if (seasonalNumberStart == seasonalNumberStartPrev)
127                 seasonalNumberStart = number;
128         numberEnd = number;
129         tickets[number] = gamer;
130         emit Ticket(id, number);
131     }
132     
133     function setLoto(address loto) external onlyOwner {
134         lotoAddress = loto;
135     }
136     
137     function setNewVersion(address payable newVersion) external onlyOwner {
138         newVersionAddress = newVersion;
139     }
140     
141     function payIn() external payable {
142         uint256 distributedAmount = dailyAmount + weeklyAmount + monthlyAmount + seasonalAmount;
143         if (distributedAmount < address(this).balance) {
144             uint256 amount = (address(this).balance - distributedAmount) / 4;
145             dailyAmount += amount;
146             weeklyAmount += amount;
147             monthlyAmount += amount;
148             seasonalAmount += amount;
149         }
150     }
151     
152     function settleJackpot() external {
153         if (block.number >= dailyEnd)
154             setDaily();
155         if (block.number >= weeklyEnd)
156             setWeekly();
157         if (block.number >= monthlyEnd)
158             setMonthly();
159         if (block.number >= seasonalEnd)
160             setSeasonal();
161         
162         if (block.number == dailyStart || (dailyStart < block.number - 256))
163             return;
164         
165         uint48 modulo = uint48(bytes6(blockhash(dailyStart) << 29));
166         
167         uint256 dailyPayAmount;
168         uint256 weeklyPayAmount;
169         uint256 monthlyPayAmount;
170         uint256 seasonalPayAmount;
171         uint256 dailyWin;
172         uint256 weeklyWin;
173         uint256 monthlyWin;
174         uint256 seasonalWin;
175         if (dailyProcessed == false) {
176             dailyPayAmount = dailyAmount * PRECISION / DAILY_PART / PRECISION;
177             dailyAmount -= dailyPayAmount;
178             dailyProcessed = true;
179             dailyWin = getNumber(dailyNumberStartPrev, dailyNumberEndPrev, modulo);
180             emit Jackpot(dailyWin, dailyNumberEndPrev - dailyNumberStartPrev + 1, dailyPayAmount, 0x01);
181         }
182         if (weeklyProcessed == false) {
183             weeklyPayAmount = weeklyAmount * PRECISION / WEEKLY_PART / PRECISION;
184             weeklyAmount -= weeklyPayAmount;
185             weeklyProcessed = true;
186             weeklyWin = getNumber(weeklyNumberStartPrev, weeklyNumberEndPrev, modulo);
187             emit Jackpot(weeklyWin, weeklyNumberEndPrev - weeklyNumberStartPrev + 1, weeklyPayAmount, 0x02);
188         }
189         if (monthlyProcessed == false) {
190             monthlyPayAmount = monthlyAmount * PRECISION / MONTHLY_PART / PRECISION;
191             monthlyAmount -= monthlyPayAmount;
192             monthlyProcessed = true;
193             monthlyWin = getNumber(monthlyNumberStartPrev, monthlyNumberEndPrev, modulo);
194             emit Jackpot(monthlyWin, monthlyNumberEndPrev - monthlyNumberStartPrev + 1, monthlyPayAmount, 0x04);
195         }
196         if (seasonalProcessed == false) {
197             seasonalPayAmount = seasonalAmount;
198             seasonalAmount -= seasonalPayAmount;
199             seasonalProcessed = true;
200             seasonalWin = getNumber(seasonalNumberStartPrev, seasonalNumberEndPrev, modulo);
201             emit Jackpot(seasonalWin, seasonalNumberEndPrev - seasonalNumberStartPrev + 1, seasonalPayAmount, 0x08);
202         }
203         if (dailyPayAmount > 0)
204             getAddress(dailyWin).transfer(dailyPayAmount);
205         if (weeklyPayAmount > 0)
206             getAddress(weeklyWin).transfer(weeklyPayAmount);
207         if (monthlyPayAmount > 0)
208             getAddress(monthlyWin).transfer(monthlyPayAmount);
209         if (seasonalPayAmount > 0)
210             getAddress(seasonalWin).transfer(seasonalPayAmount);
211     }
212 
213     function paySuperPrize(address payable winner) external onlyLoto {
214         uint256 superPrizeAmount = dailyAmount + weeklyAmount + monthlyAmount + seasonalAmount;
215         dailyAmount = 0;
216         weeklyAmount = 0;
217         monthlyAmount = 0;
218         seasonalAmount = 0;
219         emit SuperPrize(superPrizeAmount, winner);
220         winner.transfer(superPrizeAmount);
221     }
222     
223     function setOldVersion(address payable oldAddress) external onlyOwner {
224         previousContract = EthexJackpot(oldAddress);
225         dailyStart = previousContract.dailyStart();
226         dailyEnd = previousContract.dailyEnd();
227         dailyProcessed = previousContract.dailyProcessed();
228         weeklyStart = previousContract.weeklyStart();
229         weeklyEnd = previousContract.weeklyEnd();
230         weeklyProcessed = previousContract.weeklyProcessed();
231         monthlyStart = previousContract.monthlyStart();
232         monthlyEnd = previousContract.monthlyEnd();
233         monthlyProcessed = previousContract.monthlyProcessed();
234         seasonalStart = previousContract.seasonalStart();
235         seasonalEnd = previousContract.seasonalEnd();
236         seasonalProcessed = previousContract.seasonalProcessed();
237         dailyNumberStartPrev = previousContract.dailyNumberStartPrev();
238         weeklyNumberStartPrev = previousContract.weeklyNumberStartPrev();
239         monthlyNumberStartPrev = previousContract.monthlyNumberStartPrev();
240         seasonalNumberStartPrev = previousContract.seasonalNumberStartPrev();
241         dailyNumberStart = previousContract.dailyNumberStart();
242         weeklyNumberStart = previousContract.weeklyNumberStart();
243         monthlyNumberStart = previousContract.monthlyNumberStart();
244         seasonalNumberStart = previousContract.seasonalNumberStart();
245         dailyNumberEndPrev = previousContract.dailyNumberEndPrev();
246         weeklyNumberEndPrev = previousContract.weeklyNumberEndPrev();
247         monthlyNumberEndPrev = previousContract.monthlyNumberEndPrev();
248         seasonalNumberEndPrev = previousContract.seasonalNumberEndPrev();
249         numberEnd = previousContract.numberEnd();
250         dailyAmount = previousContract.dailyAmount();
251         weeklyAmount = previousContract.weeklyAmount();
252         monthlyAmount = previousContract.monthlyAmount();
253         seasonalAmount = previousContract.seasonalAmount();
254         firstNumber = weeklyNumberStart;
255         for (uint256 i = firstNumber; i <= numberEnd; i++)
256             tickets[i] = previousContract.getAddress(i);
257         previousContract.migrate();
258     }
259     
260     function getAddress(uint256 number) public returns (address payable) {
261         if (number <= firstNumber)
262             return previousContract.getAddress(number);
263         return tickets[number];
264     }
265     
266     function setDaily() private {
267         dailyProcessed = dailyNumberEndPrev == numberEnd;
268         dailyStart = dailyEnd;
269         dailyEnd = dailyStart + DAILY;
270         dailyNumberStartPrev = dailyNumberStart;
271         dailyNumberEndPrev = numberEnd;
272     }
273     
274     function setWeekly() private {
275         weeklyProcessed = weeklyNumberEndPrev == numberEnd;
276         weeklyStart = weeklyEnd;
277         weeklyEnd = weeklyStart + WEEKLY;
278         weeklyNumberStartPrev = weeklyNumberStart;
279         weeklyNumberEndPrev = numberEnd;
280     }
281     
282     function setMonthly() private {
283         monthlyProcessed = monthlyNumberEndPrev == numberEnd;
284         monthlyStart = monthlyEnd;
285         monthlyEnd = monthlyStart + MONTHLY;
286         monthlyNumberStartPrev = monthlyNumberStart;
287         monthlyNumberEndPrev = numberEnd;
288     }
289     
290     function setSeasonal() private {
291         seasonalProcessed = seasonalNumberEndPrev == numberEnd;
292         seasonalStart = seasonalEnd;
293         seasonalEnd = seasonalStart + SEASONAL;
294         seasonalNumberStartPrev = seasonalNumberStart;
295         seasonalNumberEndPrev = numberEnd;
296     }
297     
298     function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) pure private returns (uint256) {
299         return startNumber + modulo % (endNumber - startNumber + 1);
300     }
301 }
302 
303 /**
304  * (E)t)h)e)x) House Contract 
305  *  This smart-contract is the part of Ethex Lottery fair game.
306  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
307  *  http://ethex.bet
308  */
309  
310  contract EthexHouse {
311      address payable private owner;
312      
313      constructor() public {
314          owner = msg.sender;
315      }
316      
317      modifier onlyOwner {
318         require(msg.sender == owner);
319         _;
320     }
321     
322     function payIn() external payable {
323     }
324     
325     function withdraw() external onlyOwner {
326         owner.transfer(address(this).balance);
327     }
328  }
329 
330 /**
331  * (E)t)h)e)x) Superprize Contract 
332  *  This smart-contract is the part of Ethex Lottery fair game.
333  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
334  *  http://ethex.bet
335  */
336  
337  contract EthexSuperprize {
338     struct Payout {
339         uint256 index;
340         uint256 amount;
341         uint256 block;
342         address payable winnerAddress;
343         bytes16 betId;
344     }
345      
346     Payout[] public payouts;
347      
348     address payable private owner;
349     address public lotoAddress;
350     address payable public newVersionAddress;
351     EthexSuperprize previousContract;
352     uint256 public hold;
353     
354     event Superprize (
355         uint256 index,
356         uint256 amount,
357         address winner,
358         bytes16 betId,
359         byte state
360     );
361     
362     uint8 constant PARTS = 6;
363     uint256 constant PRECISION = 1 ether;
364     uint256 constant MONTHLY = 150000;
365      
366     constructor() public {
367         owner = msg.sender;
368     }
369      
370      modifier onlyOwner {
371         require(msg.sender == owner);
372         _;
373     }
374     
375     function() external payable { }
376     
377     function initSuperprize(address payable winner, bytes16 betId) external {
378         require(msg.sender == lotoAddress);
379         uint256 amount = address(this).balance - hold;
380         hold = address(this).balance;
381         uint256 sum;
382         uint256 temp;
383         for (uint256 i = 1; i < PARTS; i++) {
384             temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;
385             sum += temp;
386             payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));
387         }
388         payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));
389         emit Superprize(0, amount, winner, betId, 0);
390     }
391     
392     function paySuperprize() external onlyOwner {
393         if (payouts.length == 0)
394             return;
395         Payout[] memory payoutArray = new Payout[](payouts.length);
396         uint i = payouts.length;
397         while (i > 0) {
398             i--;
399             if (payouts[i].block <= block.number) {
400                 emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);
401                 hold -= payouts[i].amount;
402             }
403             payoutArray[i] = payouts[i];
404             payouts.pop();
405         }
406         for (i = 0; i < payoutArray.length; i++)
407             if (payoutArray[i].block > block.number)
408                 payouts.push(payoutArray[i]);
409         for (i = 0; i < payoutArray.length; i++)
410             if (payoutArray[i].block <= block.number)
411                 payoutArray[i].winnerAddress.transfer(payoutArray[i].amount);
412     }
413      
414     function setOldVersion(address payable oldAddress) external onlyOwner {
415         previousContract = EthexSuperprize(oldAddress);
416         lotoAddress = previousContract.lotoAddress();
417         hold = previousContract.hold();
418         uint256 index;
419         uint256 amount;
420         uint256 betBlock;
421         address payable winner;
422         bytes16 betId;
423         for (uint i = 0; i < previousContract.getPayoutsCount(); i++) {
424             (index, amount, betBlock, winner, betId) = previousContract.payouts(i);
425             payouts.push(Payout(index, amount, betBlock, winner, betId));
426         }
427         previousContract.migrate();
428     }
429     
430     function setNewVersion(address payable newVersion) external onlyOwner {
431         newVersionAddress = newVersion;
432     }
433     
434     function setLoto(address loto) external onlyOwner {
435         lotoAddress = loto;
436     }
437     
438     function migrate() external {
439         require(msg.sender == owner || msg.sender == newVersionAddress);
440         require(newVersionAddress != address(0));
441         newVersionAddress.transfer(address(this).balance);
442     }   
443 
444     function getPayoutsCount() view public returns (uint256) {
445         return payouts.length;
446     }
447 }
448 
449 /**
450  * (E)t)h)e)x) Loto Contract 
451  *  This smart-contract is the part of Ethex Lottery fair game.
452  *  See latest version at https://github.com/ethex-bet/ethex-contacts 
453  *  http://ethex.bet
454  */
455 
456 contract EthexLoto {
457     struct Bet {
458         uint256 blockNumber;
459         uint256 amount;
460         bytes16 id;
461         bytes6 bet;
462         address payable gamer;
463     }
464     
465     struct Transaction {
466         uint256 amount;
467         address payable gamer;
468     }
469     
470     struct Superprize {
471         uint256 amount;
472         bytes16 id;
473     }
474     
475     mapping(uint256 => uint256) public blockNumberQueue;
476     mapping(uint256 => uint256) public amountQueue;
477     mapping(uint256 => bytes16) public idQueue;
478     mapping(uint256 => bytes6) public betQueue;
479     mapping(uint256 => address payable) public gamerQueue;
480     uint256 public first = 2;
481     uint256 public last = 1;
482     uint256 public holdBalance;
483     
484     address payable public jackpotAddress;
485     address payable public houseAddress;
486     address payable public superprizeAddress;
487     address payable private owner;
488 
489     event PayoutBet (
490         uint256 amount,
491         bytes16 id,
492         address gamer
493     );
494     
495     event RefundBet (
496         uint256 amount,
497         bytes16 id,
498         address gamer
499     );
500     
501     uint8 constant N = 16;
502     uint256 constant MIN_BET = 0.01 ether;
503     uint256 constant PRECISION = 1 ether;
504     uint256 constant JACKPOT_PERCENT = 10;
505     uint256 constant HOUSE_EDGE = 10;
506     
507     constructor(address payable jackpot, address payable house, address payable superprize) public payable {
508         owner = msg.sender;
509         jackpotAddress = jackpot;
510         houseAddress = house;
511         superprizeAddress = superprize;
512     }
513     
514     function() external payable { }
515     
516     modifier onlyOwner {
517         require(msg.sender == owner);
518         _;
519     }
520     
521     function placeBet(bytes22 params) external payable {
522         require(msg.value >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
523         require(bytes16(params) != 0, "Id should not be 0");
524         
525         bytes16 id = bytes16(params);
526         bytes6 bet = bytes6(params << 128);
527         
528         uint256 coefficient = 0;
529         uint8 markedCount = 0;
530         uint256 holdAmount = 0;
531         uint256 jackpotFee = msg.value * JACKPOT_PERCENT * PRECISION / 100 / PRECISION;
532         uint256 houseEdgeFee = msg.value * HOUSE_EDGE * PRECISION / 100 / PRECISION;
533         uint256 betAmount = msg.value - jackpotFee - houseEdgeFee;
534         
535         (coefficient, markedCount, holdAmount) = getHold(betAmount, bet);
536         
537         require(msg.value * (100 - JACKPOT_PERCENT - HOUSE_EDGE) * (coefficient * 8 - 15 * markedCount) <= 9000 ether * markedCount);
538         
539         require(
540             msg.value * (800 * coefficient - (JACKPOT_PERCENT + HOUSE_EDGE) * (coefficient * 8 + 15 * markedCount)) <= 1500 * markedCount * (address(this).balance - holdBalance));
541         
542         holdBalance += holdAmount;
543         
544         enqueue(block.number, betAmount, id, bet, msg.sender);
545         
546         if (markedCount > 1)
547             EthexJackpot(jackpotAddress).registerTicket(id, msg.sender);
548         
549         EthexHouse(houseAddress).payIn.value(houseEdgeFee)();
550         EthexJackpot(jackpotAddress).payIn.value(jackpotFee)();
551     }
552     
553     function settleBets() external {
554         if (first > last)
555             return;
556         uint256 i = 0;
557         uint256 length = last - first + 1;
558         length = length > 10 ? 10 : length;
559         Transaction[] memory transactions = new Transaction[](length);
560         Superprize[] memory superprizes = new Superprize[](length);
561         uint256 balance = address(this).balance - holdBalance;
562         
563         for(; i < length; i++) {
564             Bet memory bet = dequeue();
565             if (bet.blockNumber >= block.number) {
566                 length = i;
567                 break;
568             }
569             else {
570                 uint256 coefficient = 0;
571                 uint8 markedCount = 0;
572                 uint256 holdAmount = 0;
573                 (coefficient, markedCount, holdAmount) = getHold(bet.amount, bet.bet);
574                 holdBalance -= holdAmount;
575                 balance += holdAmount;
576                 if (bet.blockNumber < block.number - 256) {
577                     transactions[i] = Transaction(bet.amount, bet.gamer);
578                     emit RefundBet(bet.amount, bet.id, bet.gamer);
579                     balance -= bet.amount;
580                 }
581                 else {
582                     bytes32 blockHash = blockhash(bet.blockNumber);
583                     coefficient = 0;
584                     uint8 matchesCount;
585                     bool isSuperPrize = true;
586                     for (uint8 j = 0; j < bet.bet.length; j++) {
587                         if (bet.bet[j] > 0x13) {
588                             isSuperPrize = false;
589                             continue;
590                         }
591                         byte field;
592                         if (j % 2 == 0)
593                             field = blockHash[29 + j / 2] >> 4;
594                         else
595                             field = blockHash[29 + j / 2] & 0x0F;
596                         if (bet.bet[j] < 0x10) {
597                             if (field == bet.bet[j]) {
598                                 matchesCount++;
599                                 coefficient += 30;
600                             }
601                             else
602                                 isSuperPrize = false;
603                             continue;
604                         }
605                         else
606                             isSuperPrize = false;
607                         if (bet.bet[j] == 0x10) {
608                             if (field > 0x09 && field < 0x10) {
609                                 matchesCount++;
610                                 coefficient += 5;
611                             }
612                             continue;
613                         }
614                         if (bet.bet[j] == 0x11) {
615                             if (field < 0x0A) {
616                                 matchesCount++;
617                                 coefficient += 3;
618                             }
619                             continue;
620                         }
621                         if (bet.bet[j] == 0x12) {
622                             if (field < 0x0A && field & 0x01 == 0x01) {
623                                 matchesCount++;
624                                 coefficient += 6;
625                             }
626                             continue;
627                         }
628                         if (bet.bet[j] == 0x13) {
629                             if (field < 0x0A && field & 0x01 == 0x0) {
630                                 matchesCount++;
631                                 coefficient += 6;
632                             }
633                             continue;
634                         }
635                     }
636                 
637                     if (matchesCount == 0) 
638                         coefficient = 0;
639                     else                    
640                         coefficient *= PRECISION * 8;
641                         
642                     uint256 payoutAmount = bet.amount * coefficient / (PRECISION * 15 * markedCount);
643                     if (payoutAmount == 0 && matchesCount > 0)
644                         payoutAmount = matchesCount;
645                     transactions[i] = Transaction(payoutAmount, bet.gamer);
646                     emit PayoutBet(payoutAmount, bet.id, bet.gamer);
647                     balance -= payoutAmount;
648                     
649                     if (isSuperPrize == true) {
650                         superprizes[i].amount = balance;
651                         superprizes[i].id = bet.id;
652                         balance = 0;
653                     }
654                 }
655             }
656         }
657         
658         for (i = 0; i < length; i++) {
659             transactions[i].gamer.transfer(transactions[i].amount);
660             if (superprizes[i].id != 0) {
661                 EthexSuperprize(superprizeAddress).initSuperprize(transactions[i].gamer, superprizes[i].id);
662                 EthexJackpot(jackpotAddress).paySuperPrize(transactions[i].gamer);
663                 transactions[i].gamer.transfer(superprizes[i].amount);
664             }
665         }
666     }
667     
668     function migrate(address payable newContract) external onlyOwner {
669         newContract.transfer(address(this).balance);
670     }
671 
672     function setJackpot(address payable jackpot) external onlyOwner {
673         jackpotAddress = jackpot;
674     }
675     
676     function setSuperprize(address payable superprize) external onlyOwner {
677         superprizeAddress = superprize;
678     }
679     
680     function length() public view returns (uint256) {
681         return 1 + last - first;
682     }
683     
684     function enqueue(uint256 blockNumber, uint256 amount, bytes16 id, bytes6 bet, address payable gamer) internal {
685         last += 1;
686         blockNumberQueue[last] = blockNumber;
687         amountQueue[last] = amount;
688         idQueue[last] = id;
689         betQueue[last] = bet;
690         gamerQueue[last] = gamer;
691     }
692 
693     function dequeue() internal returns (Bet memory bet) {
694         require(last >= first);
695 
696         bet = Bet(blockNumberQueue[first], amountQueue[first], idQueue[first], betQueue[first], gamerQueue[first]);
697 
698         delete blockNumberQueue[first];
699         delete amountQueue[first];
700         delete idQueue[first];
701         delete betQueue[first];
702         delete gamerQueue[first];
703         
704         if (first == last) {
705             first = 2;
706             last = 1;
707         }
708         else
709             first += 1;
710     }
711     
712     function getHold(uint256 amount, bytes6 bet) internal pure returns (uint256 coefficient, uint8 markedCount, uint256 holdAmount) {
713         for (uint8 i = 0; i < bet.length; i++) {
714             if (bet[i] > 0x13)
715                 continue;
716             markedCount++;
717             if (bet[i] < 0x10) {
718                 coefficient += 30;
719                 continue;
720             }
721             if (bet[i] == 0x10) {
722                 coefficient += 5;
723                 continue;
724             }
725             if (bet[i] == 0x11) {
726                 coefficient += 3;
727                 continue;
728             }
729             if (bet[i] == 0x12) {
730                 coefficient += 6;
731                 continue;
732             }
733             if (bet[i] == 0x13) {
734                 coefficient += 6;
735                 continue;
736             }
737         }
738         holdAmount = amount * (100 - JACKPOT_PERCENT - HOUSE_EDGE) * coefficient * 2 / 375 / markedCount;
739     }
740 }