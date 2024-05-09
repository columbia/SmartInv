1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37 
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41 
42         return c;
43     }
44 
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48 
49     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b != 0, errorMessage);
51         return a % b;
52     }
53 }
54 
55 pragma solidity 0.4.25;
56 
57     library DappDatasets {
58 
59         struct Player {
60 
61             uint withdrawalAmount;
62 
63             uint wallet;
64 
65             uint fomoTotalRevenue;
66 
67             uint lotteryTotalRevenue;
68 
69             uint dynamicIncome;
70 
71             uint rechargeAmount;
72 
73             uint staticIncome;
74 
75             uint shareholderLevel;
76 
77             uint underUmbrellaLevel;
78 
79             uint subbordinateTotalPerformance;
80 
81             bool isExist;
82 
83             bool superior;
84 
85             address superiorAddr;
86 
87             address[] subordinates;
88         }
89 
90         struct Fomo {
91 
92             bool whetherToEnd;
93 
94             uint endTime;
95 
96             uint fomoPrizePool;
97 
98             address[] participant;
99         }
100 
101         struct Lottery {
102 
103             bool whetherToEnd;
104 
105             uint lotteryPool;
106 
107             uint unopenedBonus;
108 
109             uint number;
110 
111             uint todayAmountTotal;
112 
113             uint totayLotteryAmountTotal;
114 
115             uint grandPrizeNum;
116 
117             uint[] firstPrizeNum;
118 
119             uint[] secondPrizeNum;
120 
121             uint[] thirdPrizeNum;
122 
123             mapping(address => uint[]) lotteryMap;
124 
125             mapping(uint => address) numToAddr;
126 
127             mapping(address => uint) personalAmount;
128 
129             mapping(uint => uint) awardAmount;
130         }
131 
132 
133         function getNowTime() internal view returns(uint) {
134             return now;
135         }
136 
137         function rand(uint256 _length, uint num) internal view returns(uint256) {
138             uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, now - num)));
139             return random%_length;
140         }
141         
142         function returnArray(uint len, uint range, uint number) internal view returns(uint[]) {
143             uint[] memory numberArray = new uint[](len);
144             uint i = 0;
145             while(true) {
146                 number = number + 9;
147                 uint temp = rand(range, number);
148                 if(temp == 0) {
149                     continue;
150                 }
151                 numberArray[i] = temp;
152                 i++;
153                 if(i == len) {
154                     break;
155                 }
156             }
157             return numberArray;
158         }
159     }
160 
161 pragma solidity 0.4.25;
162 
163     contract GODGame {
164 
165         address owner;
166 
167         address technologyAddr;
168 
169         address themisAddr;
170 
171         address lotteryAddr;
172 
173         address[] allPlayer;
174 
175         address[] temp = new address[](0);
176 
177         struct GlobalShareholder {
178 
179             address[] shareholdersV1;
180 
181             address[] shareholdersV2;
182 
183             address[] shareholdersV3;
184 
185             address[] shareholdersV4;
186         }
187 
188         uint fomoSession;
189 
190         uint depositBalance;
191 
192         GODThemis themis;
193 
194         GODToken godToken;
195 
196         TetherToken tether;
197 
198         GODLottery lottery;
199 
200         mapping(uint => DappDatasets.Fomo) fomoGame;  
201 
202         mapping(address => DappDatasets.Player) playerMap;
203 
204         mapping(address => GlobalShareholder) globalShareholder;
205 
206 
207         constructor(
208                 address _owner,
209                 address _tetherAddr,
210                 address _godAddr,
211                 address _themisAddr,
212                 address _lotteryAddr,
213                 address _technologyAddr
214         )  public {
215             owner = _owner;
216             tether = TetherToken(_tetherAddr);
217             godToken = GODToken(_godAddr);
218             themis = GODThemis(_themisAddr);
219             lotteryAddr = _lotteryAddr;
220             lottery = GODLottery(_lotteryAddr);
221             DappDatasets.Player memory player = DappDatasets.Player(
222                 {
223                     withdrawalAmount : 0,
224                     wallet : 0,
225                     fomoTotalRevenue : 0,
226                     lotteryTotalRevenue : 0,
227                     dynamicIncome : 0,
228                     rechargeAmount : 0,
229                     staticIncome : 0,
230                     shareholderLevel : 0,
231                     underUmbrellaLevel : 0,
232                     subbordinateTotalPerformance : 0,
233                     isExist : true,
234                     superior : false,
235                     superiorAddr : address(0x0),
236                     subordinates : temp
237                 }
238             );
239             playerMap[owner] = player;
240             allPlayer.push(owner);
241             technologyAddr = _technologyAddr;
242             themisAddr = _themisAddr;
243             if(owner != technologyAddr) {
244                 playerMap[technologyAddr] = player;
245                 allPlayer.push(technologyAddr);
246             }
247             globalShareholder[owner] = GlobalShareholder(
248                 {
249                     shareholdersV1 : temp,
250                     shareholdersV2 : temp,
251                     shareholdersV3 : temp,
252                     shareholdersV4 : temp
253                 }
254             );
255         }
256 
257         function() public payable {
258             withdrawImpl(msg.sender);
259         }
260 
261         function redeemGod(uint usdtVal, address superiorAddr) external {
262             register(msg.sender, superiorAddr);
263             lottery.exchange(usdtVal, msg.sender);
264             tether.transferFrom(msg.sender, this, usdtVal);
265         }
266 
267         function buyLotto(uint usdtVal, address superiorAddr) external {
268             register(msg.sender, superiorAddr);
269             lottery.participateLottery(usdtVal, msg.sender);
270             tether.transferFrom(msg.sender, this, usdtVal);
271         }
272 
273         function interactive(address addr, uint amount) internal {
274             DappDatasets.Player storage player = playerMap[addr];
275             if(player.subordinates.length > 0) {
276                 uint length = player.subordinates.length;
277                 if(player.subordinates.length > 30) {
278                     length = 30;
279                 }
280                 uint splitEqually = SafeMath.div(amount, length);
281                 for(uint i = 0; i < length; i++) {
282                     playerMap[player.subordinates[i]].wallet = SafeMath.add(
283                         playerMap[player.subordinates[i]].wallet,
284                         splitEqually
285                     );
286                     playerMap[player.subordinates[i]].dynamicIncome = SafeMath.add(
287                         playerMap[player.subordinates[i]].dynamicIncome,
288                         splitEqually
289                     );
290                 }
291             }
292         }
293 
294         function withdrawImpl(address addr) internal {
295             require(owner != addr, "admin no allow withdraw");
296             require(playerMap[addr].wallet > 0, "Insufficient wallet balance");
297             require(lottery.getLotteryIsEnd() == false,"Game over");
298 
299             uint number = 0;
300             uint motionAndStaticAmount = SafeMath.add(playerMap[addr].staticIncome, playerMap[addr].dynamicIncome);
301             uint withdrawableBalance = SafeMath.mul(playerMap[addr].rechargeAmount, 3);
302 
303             if(motionAndStaticAmount > withdrawableBalance) {
304                 number = SafeMath.sub(motionAndStaticAmount, withdrawableBalance);
305             }
306             uint amount = SafeMath.sub(playerMap[addr].wallet, number);
307             uint value = amount;
308             if(amount > 1000 * 10 ** 6) {
309                 value = 1000 * 10 ** 6;
310             }
311             playerMap[addr].wallet = SafeMath.sub(playerMap[addr].wallet, value);
312             playerMap[addr].withdrawalAmount = SafeMath.add(playerMap[addr].withdrawalAmount, value);
313 
314             uint lotteryPool = SafeMath.div(value, 10);
315             uint count = SafeMath.div(lotteryPool, 10 ** 6);
316             lottery.getLottoCodeByGameAddr(addr, count);
317             tether.transfer(addr, SafeMath.sub(value, count * 10 ** 6));
318         }
319 
320         function withdraw() external {
321             withdrawImpl(msg.sender);
322         }
323 
324         function startFomoGame() external {
325             require(owner == msg.sender, "Insufficient permissions");
326             fomoSession++;
327             if(fomoSession > 1) {
328                 require(fomoGame[fomoSession - 1].whetherToEnd == true, "The game is not over yet");
329             }
330             fomoGame[fomoSession] = DappDatasets.Fomo(
331                 {
332                     whetherToEnd : false,
333                     endTime : now + 48 * 60 * 60,
334                     fomoPrizePool : 0,
335                     participant : temp
336                 }
337             );
338         }
339 
340         function participateFomo(uint usdtVal, address superiorAddr) external {
341             require(usdtVal >= 10 ** 6, "Redeem at least 1USDT");
342             require(fomoSession > 0, "fomo game has not started yet");
343             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
344             require(fomo.whetherToEnd == false,"fomo game has not started yet");
345             require(lottery.lotterySession() > 0, "Big Lotto game has not started yet");
346             require(lottery.getLotteryIsEnd() == false,"Big Lotto game has not started yet");
347             register(msg.sender, superiorAddr);
348             depositBalance = usdtVal;
349 
350             uint needGOD = godToken.calculationNeedGOD(usdtVal);
351             godToken.burn(msg.sender, needGOD);
352 
353             fomo.participant.push(msg.sender);
354 
355             DappDatasets.Player storage player = playerMap[msg.sender];
356             player.rechargeAmount = SafeMath.add(player.rechargeAmount, usdtVal);
357 
358             uint lotteryPool = SafeMath.div(usdtVal, 10);
359             depositBalance = SafeMath.sub(depositBalance, lotteryPool);
360             lottery.updateLotteryPoolAndTodayAmountTotal(usdtVal, lotteryPool);
361 
362             increasePerformance(msg.sender, usdtVal);
363 
364             fomoPenny(msg.sender, usdtVal);
365 
366             uint fomoPool = SafeMath.div(SafeMath.mul(usdtVal, 8), 100);
367             depositBalance = SafeMath.sub(depositBalance, fomoPool);
368 
369             if(SafeMath.add(fomo.fomoPrizePool, fomoPool) > 2100 * 10 ** 4 * 10 ** 6 ) {
370                 if(fomo.fomoPrizePool < 2100 * 10 ** 4 * 10 ** 6) {
371                     uint n = SafeMath.sub(2100 * 10 ** 4 * 10 ** 6, fomo.fomoPrizePool);
372                     fomo.fomoPrizePool = SafeMath.add(fomo.fomoPrizePool, n);
373                     uint issue = SafeMath.sub(fomoPool, n);
374                     releaseStaticPoolAndV4(issue);
375                 }else {
376                     releaseStaticPoolAndV4(fomoPool);
377                 }
378             }else {
379                 fomo.fomoPrizePool = SafeMath.add(fomo.fomoPrizePool, fomoPool);
380             }
381 
382             timeExtended(usdtVal);
383             themis.addStaticTotalRechargeAndStaticPool(usdtVal, depositBalance);
384             tether.transferFrom(msg.sender, this, usdtVal);
385         }
386 		
387 
388         function timeExtended(uint usdtVal) internal {
389             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
390             uint count = SafeMath.div(usdtVal, SafeMath.mul(10, 10 ** 6));
391             uint nowTime = DappDatasets.getNowTime();
392             uint laveTime = SafeMath.sub(fomo.endTime, nowTime);
393             uint day = 48 * 60 * 60;
394             uint hour = 2 * 60 * 60;
395             if(count > 0) {
396                 laveTime = SafeMath.add(laveTime, SafeMath.mul(hour, count));
397                 if(laveTime <= day) {
398                     fomo.endTime = SafeMath.add(nowTime, laveTime);
399                 }else {
400                     fomo.endTime = SafeMath.add(nowTime, day);
401                 }
402             }
403         }
404 
405         function fomoPenny(address addr, uint usdtVal) internal {
406             DappDatasets.Player storage player = playerMap[addr];
407             uint num = 9;
408             for(uint i = 0; i < 3; i++) {
409                 if(player.superior) {
410                     uint usdt = SafeMath.div(SafeMath.mul(usdtVal, num), 100);
411                     playerMap[player.superiorAddr].wallet = SafeMath.add(
412                         playerMap[player.superiorAddr].wallet,
413                         usdt
414                     );
415                     playerMap[player.superiorAddr].dynamicIncome = SafeMath.add(
416                         playerMap[player.superiorAddr].dynamicIncome,
417                         usdt
418                     );
419                     depositBalance = SafeMath.sub(depositBalance, usdt);
420                     uint reward = SafeMath.div(usdt, 10);
421                     interactive(player.superiorAddr, reward);
422                     if(playerMap[player.superiorAddr].superior) {
423                         playerMap[playerMap[player.superiorAddr].superiorAddr].wallet = SafeMath.add(
424                             playerMap[playerMap[player.superiorAddr].superiorAddr].wallet,
425                             reward
426                         );
427                         playerMap[playerMap[player.superiorAddr].superiorAddr].dynamicIncome = SafeMath.add(
428                             playerMap[playerMap[player.superiorAddr].superiorAddr].dynamicIncome,
429                             reward
430                         );
431                     }else {
432                         break;
433                     }
434                     num -= 3;
435                     player = playerMap[player.superiorAddr];
436                 }else {
437                     break;
438                 }
439                 
440             }
441 
442             uint technicalRewards = SafeMath.div(SafeMath.mul(usdtVal, 3), 100);
443             depositBalance = SafeMath.sub(depositBalance, technicalRewards);
444             playerMap[technologyAddr].wallet = SafeMath.add(playerMap[technologyAddr].wallet, technicalRewards);
445 
446             uint vUsdt = SafeMath.div(SafeMath.mul(usdtVal, 4), 100);
447             uint vUsdt4 = SafeMath.div(SafeMath.mul(usdtVal, 3), 100);
448             depositBalance = SafeMath.sub(depositBalance, SafeMath.mul(vUsdt, 3));
449             depositBalance = SafeMath.sub(depositBalance, vUsdt4);
450             themis.addUsdtPool(vUsdt, vUsdt4);
451         }
452 
453 
454         function increasePerformance(address addr, uint usdtVal) internal {
455             DappDatasets.Player storage player = playerMap[addr];
456             uint length = 0;
457             while(player.superior) {
458                 address tempAddr = player.superiorAddr;
459                 player = playerMap[player.superiorAddr];
460                 player.subbordinateTotalPerformance = SafeMath.add(player.subbordinateTotalPerformance, usdtVal);
461                 promotionMechanisms(tempAddr);
462                 length++;
463                 if(length == 50) {
464                     break;
465                 }
466             }
467         }
468 
469         function promotionMechanisms(address addr) internal {
470             DappDatasets.Player storage player = playerMap[addr];
471             if(player.subbordinateTotalPerformance >= 10 * 10 ** 4 * 10 ** 6) {
472                 uint len = player.subordinates.length;
473                 if(player.subordinates.length > 30) {
474                     len = 30;
475                 }
476                 for(uint i = 0; i < 4; i++) {
477                     if(player.shareholderLevel == i) {
478                         uint levelCount = 0;
479                         for(uint j = 0; j < len; j++) {
480                             if(i == 0) {
481                                 uint areaTotal = SafeMath.add(
482                                             playerMap[player.subordinates[j]].subbordinateTotalPerformance,
483                                             playerMap[player.subordinates[j]].rechargeAmount
484                                 );
485                                 if(areaTotal >= 3 * 10 ** 4 * 10 ** 6) {
486                                     levelCount++;
487                                 }
488                             }else {
489                                 if(playerMap[player.subordinates[j]].shareholderLevel >= i || playerMap[player.subordinates[j]].underUmbrellaLevel >= i) {
490                                     levelCount++;
491                                 }
492                             }
493 
494                             if(levelCount >= 2) {
495                                 player.shareholderLevel = i + 1;
496                                 if(i == 0) {
497                                     globalShareholder[owner].shareholdersV1.push(addr);
498                                 }else if(i == 1) {
499                                     globalShareholder[owner].shareholdersV2.push(addr);
500                                 }else if(i == 2) {
501                                     globalShareholder[owner].shareholdersV3.push(addr);
502                                 }else if(i == 3) {
503                                     globalShareholder[owner].shareholdersV4.push(addr);
504                                 }
505                                 
506                                 DappDatasets.Player storage tempPlayer = player;
507                                 uint count = 0;
508                                 while(tempPlayer.superior) {
509                                     tempPlayer = playerMap[tempPlayer.superiorAddr];
510                                     if(tempPlayer.underUmbrellaLevel < i + 1) {
511                                         tempPlayer.underUmbrellaLevel = i + 1;
512                                     }else {
513                                         break;
514                                     }
515                                     count++;
516                                     if(count == 49) {
517                                         break;
518                                     }
519                                 }
520                                 break;
521                             }
522                             
523                         }
524                     }
525                 }
526 
527             }
528         }
529 
530         function releaseStaticPoolAndV4(uint usdtVal) internal {
531             uint staticPool60 = SafeMath.div(SafeMath.mul(usdtVal, 6), 10);
532             themis.addStaticPrizePool(staticPool60);
533 
534             if(globalShareholder[owner].shareholdersV4.length > 0) {
535                 uint length = globalShareholder[owner].shareholdersV4.length;
536                 if(globalShareholder[owner].shareholdersV4.length > 100) {
537                     length = 100;
538                 }
539                 uint splitEqually = SafeMath.div(SafeMath.sub(usdtVal, staticPool60), length);
540                 for(uint i = 0; i < length; i++) {
541                     playerMap[globalShareholder[owner].shareholdersV4[i]].wallet = SafeMath.add(
542                         playerMap[globalShareholder[owner].shareholdersV4[i]].wallet,
543                         splitEqually
544                     );
545                 }
546             }else{
547 				themis.addStaticPrizePool(SafeMath.sub(usdtVal, staticPool60));
548 			}
549 
550         }
551 
552         function register(address addr, address superiorAddr) internal{
553             if(playerMap[addr].isExist == true) {
554                 return;
555             }
556             DappDatasets.Player memory player;
557             if(superiorAddr == address(0x0) || playerMap[superiorAddr].isExist == false) {
558                 player = DappDatasets.Player(
559                     {
560                         withdrawalAmount : 0,
561                         wallet : 0,
562                         fomoTotalRevenue : 0,
563                         lotteryTotalRevenue : 0,
564                         dynamicIncome : 0,
565                         rechargeAmount : 0,
566                         staticIncome : 0,
567                         shareholderLevel : 0,
568                         underUmbrellaLevel : 0,
569                         subbordinateTotalPerformance : 0,
570                         isExist : true,
571                         superior : false,
572                         superiorAddr : address(0x0),
573                         subordinates : temp
574                     }
575                 );
576                 playerMap[addr] = player;
577             }else {
578                 player = DappDatasets.Player(
579                     {
580                         withdrawalAmount : 0,
581                         wallet : 0,
582                         fomoTotalRevenue : 0,
583                         lotteryTotalRevenue : 0,
584                         dynamicIncome : 0,
585                         rechargeAmount : 0,
586                         staticIncome : 0,
587                         shareholderLevel : 0,
588                         underUmbrellaLevel : 0,
589                         subbordinateTotalPerformance : 0,
590                         isExist : true,
591                         superior : true,
592                         superiorAddr : superiorAddr,
593                         subordinates : temp
594                     }
595                 );
596                 DappDatasets.Player storage superiorPlayer = playerMap[superiorAddr];
597                 superiorPlayer.subordinates.push(addr);
598                 playerMap[addr] = player;
599             }
600             allPlayer.push(addr);
601         }
602         function endFomoGame() external {
603             require(owner == msg.sender, "Insufficient permissions");
604             require(fomoSession > 0, "The game has not started");
605             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
606             require(fomo.whetherToEnd == false,"Game over");
607             require(DappDatasets.getNowTime() >= fomo.endTime, "The game is not over");
608             fomo.whetherToEnd = true;
609         }
610 
611         function getFomoParticpantLength() external view returns(uint) {
612             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
613             return fomo.participant.length;
614         }
615 
616         function fomoBatchDistribution(uint number, uint frequency, uint index) external {
617             require(owner == msg.sender, "Insufficient permissions");
618             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
619             require(fomo.whetherToEnd == true,"fomo is not over");
620             require(fomo.fomoPrizePool > 0, "fomo pool no bonus");
621 
622             uint fomoPool = SafeMath.div(SafeMath.mul(fomo.fomoPrizePool, number), 10);
623 
624             uint length = frequency;
625             if(fomo.participant.length < frequency) {
626                 length = fomo.participant.length;
627             }
628             uint personalAmount = SafeMath.div(fomoPool, length);
629             uint num = 0;
630             for(uint i = fomo.participant.length - index; i > 0; i--) {
631                 DappDatasets.Player storage player = playerMap[fomo.participant[i - 1]];
632                 player.wallet = SafeMath.add(
633                     player.wallet,
634                     personalAmount
635                 );
636                 player.fomoTotalRevenue = SafeMath.add(
637                     player.fomoTotalRevenue,
638                     personalAmount
639                 );
640                 num++;
641                 if(num == 100 || num == length) {
642                     break;
643                 }
644             }
645         }
646 
647         function getFOMOInfo() external view returns(uint session, uint nowTime, uint endTime, uint prizePool, bool isEnd) {
648             DappDatasets.Fomo storage fomo = fomoGame[fomoSession];
649             return (fomoSession, DappDatasets.getNowTime(), fomo.endTime, fomo.fomoPrizePool, fomo.whetherToEnd);
650         }
651 
652         function getSubordinatesAndPerformanceByAddr(address addr) external view returns(address[], uint[], uint[]) {
653             DappDatasets.Player storage player = playerMap[addr];
654             uint[] memory performance = new uint[](player.subordinates.length);
655             uint[] memory numberArray = new uint[](player.subordinates.length);
656             for(uint i = 0; i < player.subordinates.length; i++) {
657                 performance[i] = SafeMath.add(
658                     playerMap[player.subordinates[i]].subbordinateTotalPerformance,
659                     playerMap[player.subordinates[i]].rechargeAmount
660                 );
661                 numberArray[i] = playerMap[player.subordinates[i]].subordinates.length;
662             }
663             return (player.subordinates, performance, numberArray);
664         }
665 
666         function getPlayerInfo() external view returns(address superiorAddr, address ownerAddr, uint numberOfInvitations, bool exist) {
667             return (playerMap[msg.sender].superiorAddr,  msg.sender, playerMap[msg.sender].subordinates.length, playerMap[msg.sender].isExist);
668         }
669 
670         function getStatistics() external view returns(
671             uint level,
672             uint destroyedQuantity,
673             uint fomoTotalRevenue,
674             uint lotteryTotalRevenue,
675             uint difference
676         ) {
677             return (
678                 playerMap[msg.sender].shareholderLevel,
679                 godToken.balanceOf(address(0x0)),
680                 playerMap[msg.sender].fomoTotalRevenue,
681                 playerMap[msg.sender].lotteryTotalRevenue,
682                 SafeMath.sub(
683                     SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3),
684                     playerMap[msg.sender].staticIncome
685                 )
686             );
687         }
688 
689         function getRevenueAndPerformance() external view returns(
690             uint withdrawalAmount,
691             uint subbordinateTotalPerformance,
692             uint dynamicIncome,
693             uint staticIncome,
694             uint withdrawn,
695             uint outboundDifference
696         ) {
697             uint number = 0;
698             uint motionAndStaticAmount = SafeMath.add(playerMap[msg.sender].staticIncome, playerMap[msg.sender].dynamicIncome);
699             uint withdrawableBalance = SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3);
700             if(motionAndStaticAmount > withdrawableBalance) {
701                 number = SafeMath.sub(motionAndStaticAmount, withdrawableBalance);
702             }
703             uint difference = 0;
704             if(motionAndStaticAmount < withdrawableBalance) {
705                 difference = SafeMath.sub(withdrawableBalance, motionAndStaticAmount);
706             }
707             return (
708                 SafeMath.sub(playerMap[msg.sender].wallet, number),
709                 playerMap[msg.sender].subbordinateTotalPerformance,
710                 playerMap[msg.sender].dynamicIncome,
711                 playerMap[msg.sender].staticIncome,
712                 playerMap[msg.sender].withdrawalAmount,
713                 difference
714             );
715         }
716         function getAllPlayer() external view returns(address[]) {
717             return allPlayer;
718         }
719         function getAllPlayerLength() external view returns(uint) {
720             return allPlayer.length;
721         }
722 
723         function getShareholder() external view returns(uint, uint, uint, uint) {
724             return (
725                 globalShareholder[owner].shareholdersV1.length,
726                 globalShareholder[owner].shareholdersV2.length,
727                 globalShareholder[owner].shareholdersV3.length,
728                 globalShareholder[owner].shareholdersV4.length
729             );
730         }
731 
732         function getGlobalShareholder() external view returns(address[], address[], address[], address[]) {
733             return (
734                 globalShareholder[owner].shareholdersV1,
735                 globalShareholder[owner].shareholdersV2,
736                 globalShareholder[owner].shareholdersV3,
737                 globalShareholder[owner].shareholdersV4
738             );
739         }
740 
741         function getPlayer(address addr) external view returns(uint, uint, uint, address, address[]) {
742             DappDatasets.Player storage player = playerMap[addr];
743             return(
744                 player.rechargeAmount,
745                 player.staticIncome,
746                 player.dynamicIncome,
747                 player.superiorAddr,
748                 player.subordinates
749             );
750         }
751 
752         function updatePlayer(address addr, uint amount, bool flag) external {
753             require(themisAddr == msg.sender, "Insufficient permissions");
754             DappDatasets.Player storage player = playerMap[addr];
755             player.wallet = SafeMath.add(player.wallet, amount);
756             if(flag) {
757                 player.staticIncome = SafeMath.add(player.staticIncome, amount);
758             }else {
759                 player.dynamicIncome = SafeMath.add(player.dynamicIncome, amount);
760             }
761         }
762 
763         function updatePlayer(address addr, uint amount) external {
764             require(lotteryAddr == msg.sender, "Insufficient permissions");
765             DappDatasets.Player storage player = playerMap[addr];
766             player.wallet = SafeMath.add(player.wallet, amount);
767             player.lotteryTotalRevenue = SafeMath.add(player.lotteryTotalRevenue, amount);
768         }
769     }
770 
771     contract GODThemis {
772         function addStaticPrizePool(uint usdtVal) external;
773         function addStaticTotalRechargeAndStaticPool(uint usdtVal, uint depositBalance) external;
774         function addUsdtPool(uint vUsdt, uint vUsdt4) external;
775     }
776 
777     contract GODToken {
778         function burn(address addr, uint value) public;
779         function usdtPrice() public view returns(uint);
780         function balanceOf(address who) external view returns (uint);
781         function calculationNeedGOD(uint usdtVal) external view returns(uint);
782     }
783 
784     contract TetherToken {
785         function transferFrom(address from, address to, uint value) public;
786         function transfer(address to, uint value) public;
787     }
788 
789     contract GODLottery {
790         function getLottoCodeByGameAddr(address addr, uint count) external;
791         function lotterySession() public view returns(uint);
792         function getLotteryIsEnd() external view returns(bool);
793         function updateLotteryPoolAndTodayAmountTotal(uint usdtVal, uint lotteryPool) external;
794         function exchange(uint usdtVal, address addr) external;
795         function participateLottery(uint usdtVal, address addr) external;
796     }