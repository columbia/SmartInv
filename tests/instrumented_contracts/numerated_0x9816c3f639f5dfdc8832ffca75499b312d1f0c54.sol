1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6     function add(uint256 a, uint256 b) internal pure returns (uint256) {
7         uint256 c = a + b;
8         require(c >= a, "SafeMath: addition overflow");
9 
10         return c;
11     }
12 
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
15         return sub(a, b, "SafeMath: subtraction overflow");
16     }
17 
18 
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22 
23         return c;
24     }
25 
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b > 0, errorMessage);
44         uint256 c = a / b;
45 
46         return c;
47     }
48 
49     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
50         return mod(a, b, "SafeMath: modulo by zero");
51     }
52 
53     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b != 0, errorMessage);
55         return a % b;
56     }
57 }
58 
59 pragma solidity 0.4.25;
60 
61     library DappDatasets {
62 
63         struct Player {
64 
65             uint withdrawalAmount;
66 
67             uint wallet;
68 
69             uint fomoTotalRevenue;
70 
71             uint lotteryTotalRevenue;
72 
73             uint dynamicIncome;
74 
75             uint rechargeAmount;
76 
77             uint staticIncome;
78 
79             uint shareholderLevel;
80 
81             uint underUmbrellaLevel;
82 
83             uint subbordinateTotalPerformance;
84 
85             bool isExist;
86 
87             bool superior;
88 
89             address superiorAddr;
90 
91             address[] subordinates;
92         }
93 
94 
95         struct Fomo {
96 
97             bool whetherToEnd;
98 
99             uint endTime;
100 
101             uint fomoPrizePool;
102 
103             address[] participant;
104         }
105 
106         struct Lottery {
107 
108             bool whetherToEnd;
109 
110             uint lotteryPool;
111 
112             uint unopenedBonus;
113 
114             uint number;
115 
116             uint todayAmountTotal;
117 
118             uint totayLotteryAmountTotal;
119 
120             uint[] grandPrizeNum;
121 
122             uint[] firstPrizeNum;
123 
124             uint[] secondPrizeNum;
125 
126             uint[] thirdPrizeNum;
127 
128             mapping(address => uint[]) lotteryMap;
129 
130             mapping(uint => address) numToAddr;
131 
132             mapping(address => uint) personalAmount;
133 
134             mapping(uint => uint) awardAmount;
135         }
136 
137 
138         function getNowTime() internal view returns(uint) {
139             return now;
140         }
141 
142 
143         function rand(uint256 _length, uint num) internal view returns(uint256) {
144             uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, now - num)));
145             return random%_length;
146         }
147 
148         function returnArray(uint len, uint range, uint number) internal view returns(uint[]) {
149             uint[] memory numberArray = new uint[](len);
150             uint i = 0;
151             while(true) {
152                 number = number + 9;
153                 uint temp = rand(range, number);
154                 if(temp == 0) {
155                     continue;
156                 }
157                 numberArray[i] = temp;
158                 i++;
159                 if(i == len) {
160                     break;
161                 }
162             }
163             return numberArray;
164         }
165     }
166 
167 pragma solidity 0.4.25;
168 
169     contract AWMain {
170 
171 
172         address owner;
173 
174 
175         address specifyAddr;
176 
177 
178         address technologyAddr;
179 
180         address gameAddr;
181 
182         address[] temp = new address[](0);
183 
184         uint staticDividendUsdt;
185 
186         uint public staticPrizePool;
187 
188         uint public staticTotalRecharge;
189 
190         address[] allPlayer;
191 
192         address[] shareholdersV1;
193 
194         address[] shareholdersV2;
195 
196         address[] shareholdersV3;
197 
198         address[] shareholdersV4;
199 
200         uint public usdtPool;
201 
202         TetherToken tether;
203         AWToken awToken;
204 
205         AWGame game;
206 
207         mapping(address => DappDatasets.Player) public playerMap;
208 
209         constructor(
210             address _owner,
211             address _tetherAddr,
212             address _awAddr,
213             address _gameAddr,
214             address _technologyAddr,
215             address _specifyAddr
216         )  public {
217             owner = _owner;
218             DappDatasets.Player memory player = DappDatasets.Player(
219                 {
220                     withdrawalAmount : 0,
221                     wallet : 0,
222                     fomoTotalRevenue : 0,
223                     lotteryTotalRevenue : 0,
224                     dynamicIncome : 0,
225                     rechargeAmount : 0,
226                     staticIncome : 0,
227                     shareholderLevel : 0,
228                     underUmbrellaLevel : 0,
229                     subbordinateTotalPerformance : 0,
230                     isExist : true,
231                     superior : false,
232                     superiorAddr : address(0x0),
233                     subordinates : temp
234                 }
235             );
236             specifyAddr = _specifyAddr;
237             playerMap[owner] = player;
238             tether = TetherToken(_tetherAddr);
239             awToken = AWToken(_awAddr);
240             game = AWGame(_gameAddr);
241             gameAddr = _gameAddr;
242             technologyAddr = _technologyAddr;
243             allPlayer.push(owner);
244             if(owner != technologyAddr) {
245                 playerMap[technologyAddr] = player;
246                 allPlayer.push(technologyAddr);
247             }
248         }
249 
250         function() public payable {
251             withdrawImpl(msg.sender);
252         }
253 
254         function resetNodePool() external {
255             require(owner == msg.sender, "Insufficient permissions");
256             usdtPool = 0;
257         }
258 
259         function addWalletAndDynamicIncome(address addr, uint num) internal {
260             playerMap[addr].wallet = SafeMath.add(playerMap[addr].wallet, num);
261             playerMap[addr].dynamicIncome = SafeMath.add(playerMap[addr].dynamicIncome, num);
262         }
263 
264         function usdtNode(uint start, uint count) external {
265             require(owner == msg.sender, "Insufficient permissions");
266             if(shareholdersV4.length < 1) {
267                 staticPrizePool = SafeMath.add(staticPrizePool, usdtPool);
268                 return;
269             }
270             uint award = SafeMath.div(usdtPool, shareholdersV4.length);
271             uint index = 0;
272             for(uint i = start; i < shareholdersV4.length; i++) {
273                 fosterInteraction(shareholdersV4[i], award);
274                 index++;
275                 if(index == count) {
276                     break;
277                 }
278 
279             }
280         }
281 
282         function getShareholder() external view returns(uint, uint, uint, uint, uint) {
283             return (
284                 shareholdersV1.length,
285                 shareholdersV2.length,
286                 shareholdersV3.length,
287                 shareholdersV4.length,
288                 allPlayer.length
289             );
290         }
291 
292         function getStatistics() external view returns(
293             uint level,
294             uint destroyedQuantity,
295             uint fomoTotalRevenue,
296             uint lotteryTotalRevenue,
297             uint difference
298         ) {
299             return (
300                 playerMap[msg.sender].shareholderLevel,
301                 awToken.balanceOf(address(0x0)),
302                 playerMap[msg.sender].fomoTotalRevenue,
303                 playerMap[msg.sender].lotteryTotalRevenue,
304                 SafeMath.sub(
305                     SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3),
306                     playerMap[msg.sender].staticIncome
307                 )
308             );
309         }
310 
311         function getSubordinatesAndPerformanceByAddr(address addr) external view returns(address[], uint[], uint[]) {
312             DappDatasets.Player storage player = playerMap[addr];
313             uint[] memory performance = new uint[](player.subordinates.length);
314             uint[] memory numberArray = new uint[](player.subordinates.length);
315             for(uint i = 0; i < player.subordinates.length; i++) {
316                 performance[i] = SafeMath.add(
317                     playerMap[player.subordinates[i]].subbordinateTotalPerformance,
318                     playerMap[player.subordinates[i]].rechargeAmount
319                 );
320                 numberArray[i] = playerMap[player.subordinates[i]].subordinates.length;
321             }
322             return (player.subordinates, performance, numberArray);
323         }
324 
325         function getPlayerInfo() external view returns(address superiorAddr, address ownerAddr, uint numberOfInvitations, bool exist) {
326             return (playerMap[msg.sender].superiorAddr,  msg.sender, playerMap[msg.sender].subordinates.length, playerMap[msg.sender].isExist);
327         }
328 
329         function getRevenueAndPerformance() external view returns(
330             uint withdrawalAmount,
331             uint subbordinateTotalPerformance,
332             uint dynamicIncome,
333             uint staticIncome,
334             uint withdrawn,
335             uint outboundDifference
336         ) {
337             uint number = 0;
338             uint motionAndStaticAmount = SafeMath.add(playerMap[msg.sender].staticIncome, playerMap[msg.sender].dynamicIncome);
339             uint withdrawableBalance = SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3);
340             if(motionAndStaticAmount > withdrawableBalance) {
341                 number = SafeMath.sub(motionAndStaticAmount, withdrawableBalance);
342             }
343             uint value = SafeMath.add(playerMap[msg.sender].dynamicIncome, playerMap[msg.sender].staticIncome);
344             uint difference = 0;
345             if(value > SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3)) {
346                 difference = 0;
347             }else {
348                 difference = SafeMath.sub(SafeMath.mul(playerMap[msg.sender].rechargeAmount, 3), value);
349             }
350             return (
351                 SafeMath.sub(playerMap[msg.sender].wallet, number),
352                 playerMap[msg.sender].subbordinateTotalPerformance,
353                 playerMap[msg.sender].dynamicIncome,
354                 playerMap[msg.sender].staticIncome,
355                 playerMap[msg.sender].withdrawalAmount,
356                 difference
357             );
358         }
359 
360         function withdrawImpl(address addr) internal {
361             require(playerMap[addr].wallet > 0, "Insufficient wallet balance");
362 
363             uint number = 0;
364             uint motionAndStaticAmount = SafeMath.add(playerMap[addr].staticIncome, playerMap[addr].dynamicIncome);
365             uint withdrawableBalance = SafeMath.mul(playerMap[addr].rechargeAmount, 3);
366 
367             if(motionAndStaticAmount > withdrawableBalance) {
368                 number = SafeMath.sub(motionAndStaticAmount, withdrawableBalance);
369             }
370             uint amount = SafeMath.sub(playerMap[addr].wallet, number);
371             uint value = amount;
372             if(amount > 1000 * 10 ** 6) {
373                 value = 1000 * 10 ** 6;
374             }
375             playerMap[addr].wallet = SafeMath.sub(playerMap[addr].wallet, value);
376             playerMap[addr].withdrawalAmount = SafeMath.add(playerMap[addr].withdrawalAmount, value);
377 
378             uint handlingFee = SafeMath.div(value, 10);
379             game.buyLotto(handlingFee, addr);
380             staticPrizePool = SafeMath.add(staticPrizePool, handlingFee);
381             tether.transfer(addr, SafeMath.sub(value, handlingFee));
382         }
383 
384         function withdrawService() external {
385             withdrawImpl(msg.sender);
386         }
387 
388         function afterStaticPayment() external {
389             require(owner == msg.sender, "Insufficient permissions");
390             staticPrizePool = SafeMath.sub(staticPrizePool, staticDividendUsdt);
391             staticDividendUsdt = 0;
392         }
393 
394         function staticDividend(uint index) external {
395             require(owner == msg.sender, "Insufficient permissions");
396             uint count = 0;
397             for(uint i = index; i < allPlayer.length; i++) {
398                 if(
399                     playerMap[allPlayer[i]].rechargeAmount == 0 ||
400                     SafeMath.add(playerMap[allPlayer[i]].staticIncome, playerMap[allPlayer[i]].dynamicIncome) >=
401                     SafeMath.mul(playerMap[allPlayer[i]].rechargeAmount, 3)
402                 ) {
403                     continue;
404                 }
405 
406                 uint proportionOfInvestment = SafeMath.div(
407                     SafeMath.mul(playerMap[allPlayer[i]].rechargeAmount, 10 ** 6),
408                     staticTotalRecharge
409                 );
410 
411                 uint personalAmount = SafeMath.div(
412                     SafeMath.div(SafeMath.mul(staticPrizePool, proportionOfInvestment), 120),
413                     10 ** 6
414                 );
415                 playerMap[allPlayer[i]].wallet = SafeMath.add(
416                     playerMap[allPlayer[i]].wallet,
417                     personalAmount
418                 );
419                 playerMap[allPlayer[i]].staticIncome = SafeMath.add(
420                     playerMap[allPlayer[i]].staticIncome,
421                     personalAmount
422                 );
423                 staticDividendUsdt += personalAmount;
424                 count++;
425                 if(count == 100) {
426                     break;
427                 }
428             }
429         }
430 
431         function participateFomo(uint usdtVal, address superiorAddr) external {
432             require(usdtVal >= 10 * 10 ** 6, "Less than the minimum amount");
433             register(msg.sender, superiorAddr);
434 
435             DappDatasets.Player storage player = playerMap[msg.sender];
436             player.rechargeAmount = SafeMath.add(player.rechargeAmount, usdtVal);
437             staticTotalRecharge = SafeMath.add(staticTotalRecharge, usdtVal);
438 
439             uint amount = SafeMath.div(SafeMath.mul(usdtVal, 3), 100);
440             playerMap[technologyAddr].wallet = SafeMath.add(playerMap[technologyAddr].wallet, amount);
441             usdtPool = SafeMath.add(usdtPool, amount);
442 
443             increasePerformance(usdtVal);
444 
445             uint remaining = game.deposit(usdtVal, msg.sender);
446             staticPrizePool = SafeMath.add(staticPrizePool, remaining);
447 
448             tether.transferFrom(msg.sender, this, usdtVal);
449         }
450 
451         function increasePerformance(uint usdtVal) internal {
452             DappDatasets.Player storage player = playerMap[msg.sender];
453             uint length = 0;
454             while(player.superior) {
455                 address tempAddr = player.superiorAddr;
456                 player = playerMap[player.superiorAddr];
457                 player.subbordinateTotalPerformance = SafeMath.add(player.subbordinateTotalPerformance, usdtVal);
458                 promotionMechanisms(tempAddr);
459                 length++;
460                 if(length == 50) {
461                     break;
462                 }
463             }
464         }
465 
466         function promotionMechanisms(address addr) internal {
467             DappDatasets.Player storage player = playerMap[addr];
468             if(player.subbordinateTotalPerformance >= 10 * 10 ** 10) {
469                 uint length = player.subordinates.length;
470                 if(player.subordinates.length > 30) {
471                     length = 30;
472                 }
473                 for(uint i = 0; i < 4; i++) {
474                     if(player.shareholderLevel == i) {
475                         uint levelCount = 0;
476                         for(uint j = 0; j < length; j++) {
477                             if(i == 0 && player.rechargeAmount >= 1000 * 10 ** 6) {
478                                 uint areaTotal = SafeMath.add(
479                                             playerMap[player.subordinates[j]].subbordinateTotalPerformance,
480                                             playerMap[player.subordinates[j]].rechargeAmount
481                                 );
482                                 if(areaTotal >= 3 * 10 ** 10) {
483                                     levelCount++;
484                                 }
485                             }else if(i == 1 && player.rechargeAmount >= 3000 * 10 ** 6) {
486                                 if(playerMap[player.subordinates[j]].shareholderLevel >= 1 || playerMap[player.subordinates[j]].underUmbrellaLevel >= 1) {
487                                     levelCount++;
488                                 }
489                             }else if(i == 2 && player.rechargeAmount >= 5000 * 10 ** 6) {
490                                 if(playerMap[player.subordinates[j]].shareholderLevel >= 2 || playerMap[player.subordinates[j]].underUmbrellaLevel >= 2) {
491                                     levelCount++;
492                                 }
493                             }else if(i == 3 && player.rechargeAmount >= 10000 * 10 ** 6) {
494                                 if(playerMap[player.subordinates[j]].shareholderLevel >= 3 || playerMap[player.subordinates[j]].underUmbrellaLevel >= 3) {
495                                     levelCount++;
496                                 }
497                             }
498 
499                             if(levelCount >= 2) {
500                                 player.shareholderLevel = i + 1;
501                                 if(i == 0 ) {
502                                     shareholdersV1.push(addr);
503                                 }else if(i == 1) {
504                                     shareholdersV2.push(addr);
505                                 }else if(i == 2) {
506                                     shareholdersV3.push(addr);
507                                 }else if(i == 3) {
508                                     shareholdersV4.push(addr);
509                                 }
510                                 
511                                 DappDatasets.Player storage tempPlayer = player;
512                                 uint count = 0;
513                                 while(tempPlayer.superior) {
514                                     tempPlayer = playerMap[tempPlayer.superiorAddr];
515                                     if(tempPlayer.underUmbrellaLevel < i + 1) {
516                                         tempPlayer.underUmbrellaLevel = i + 1;
517                                     }else {
518                                         break;
519                                     }
520                                     count++;
521                                     if(count == 49) {
522                                         break;
523                                     }
524                                 }
525                                 break;
526                             }
527                         }
528                     }
529                 }
530 
531             }
532         }
533 
534         function rewardDistribution(address addr, uint amount) external returns(uint) {
535             require(gameAddr == msg.sender, "Insufficient permissions");
536             return fosterInteraction(addr, amount);
537         }
538 
539 
540         function fosterInteraction(address addr, uint amount) internal returns(uint) {
541             DappDatasets.Player storage player = playerMap[addr];
542             addWalletAndDynamicIncome(addr, amount);
543             uint number = amount;
544             uint reward = SafeMath.div(amount, 10);
545             if(player.superior) {
546                 addWalletAndDynamicIncome(player.superiorAddr, reward);
547                 number = SafeMath.add(number, reward);
548             }
549             if(player.subordinates.length > 0) {
550                 uint length = player.subordinates.length;
551                 if(player.subordinates.length > 30) {
552                     length = 30;
553                 }
554                 uint splitEqually = SafeMath.div(reward, length);
555                 for(uint i = 0; i < length; i++) {
556                     addWalletAndDynamicIncome(player.subordinates[i], splitEqually);
557                 }
558                 number = SafeMath.add(number, reward);
559             }
560             return number;
561         }
562 
563         function releaseStaticPoolAndV4(uint usdtVal) external {
564             require(gameAddr == msg.sender, "Insufficient permissions");
565             uint staticPool60 = SafeMath.div(SafeMath.mul(usdtVal, 6), 10);
566             staticPrizePool = SafeMath.add(staticPrizePool, staticPool60);
567 
568             uint amount = SafeMath.sub(usdtVal, staticPool60);
569             if(shareholdersV4.length > 0) {
570                 uint length = 0;
571                 if(shareholdersV4.length > 100) {
572                     length = 100;
573                 }else {
574                     length = shareholdersV4.length;
575                 }
576                 uint splitEqually = SafeMath.div(amount, length);
577                 for(uint i = 0; i < length; i++) {
578                     addWalletAndDynamicIncome(shareholdersV4[i], splitEqually);
579                 }
580             }else {
581                 staticPrizePool = SafeMath.add(staticPrizePool, amount);
582             }
583 
584         }
585 
586         function updateRevenue(address addr, uint amount, bool flag) external {
587             require(gameAddr == msg.sender, "Insufficient permissions");
588             DappDatasets.Player storage player = playerMap[addr];
589             if(flag) {
590                 player.wallet = SafeMath.add(player.wallet, amount);
591                 player.fomoTotalRevenue = SafeMath.add(player.fomoTotalRevenue, amount);
592             }else {
593                 player.wallet = SafeMath.add(player.wallet, amount);
594                 player.lotteryTotalRevenue = SafeMath.add(player.lotteryTotalRevenue, amount);
595             }
596         }
597 
598         function participateLottery(uint usdtVal, address superiorAddr) external {
599             require(usdtVal <= 300 * 10 ** 6 && usdtVal >= 10 ** 6, "Purchase value between 1-300");
600             register(msg.sender, superiorAddr);
601             game.buyLotto(usdtVal, msg.sender);
602             staticPrizePool = SafeMath.add(staticPrizePool, usdtVal);
603             tether.transferFrom(msg.sender, this, usdtVal);
604         }
605 
606         function getPlayer(address addr) external view returns(uint, address, address[]) {
607             DappDatasets.Player storage player = playerMap[addr];
608             return (playerMap[player.superiorAddr].shareholderLevel, player.superiorAddr, player.subordinates);
609         }
610 
611         function exchange(uint usdtVal, address superiorAddr) external {
612             require(usdtVal >= 10 ** 6, "Redeem at least 1USDT");
613             register(msg.sender, superiorAddr);
614 
615             uint usdtPrice = awToken.usdtPrice();
616 
617             game.redeemAW(usdtVal, usdtPrice, msg.sender);
618             uint staticAmount = SafeMath.div(SafeMath.mul(usdtVal, 4), 10);
619             staticPrizePool = SafeMath.add(staticPrizePool, staticAmount);
620 
621             tether.transferFrom(msg.sender, this, staticAmount);
622 
623             tether.transferFrom(msg.sender, specifyAddr, SafeMath.sub(usdtVal, staticAmount));
624         }
625 
626         function register(address addr, address superiorAddr) internal{
627             if(playerMap[addr].isExist == true) {
628                 return;
629             }
630             DappDatasets.Player memory player;
631             if(superiorAddr == address(0x0) || playerMap[superiorAddr].isExist == false) {
632                 player = DappDatasets.Player(
633                     {
634                         withdrawalAmount : 0,
635                         wallet : 0,
636                         fomoTotalRevenue : 0,
637                         lotteryTotalRevenue : 0,
638                         dynamicIncome : 0,
639                         rechargeAmount : 0,
640                         staticIncome : 0,
641                         shareholderLevel : 0,
642                         underUmbrellaLevel : 0,
643                         subbordinateTotalPerformance : 0,
644                         isExist : true,
645                         superior : false,
646                         superiorAddr : address(0x0),
647                         subordinates : temp
648                     }
649                 );
650                 playerMap[addr] = player;
651             }else {
652                 player = DappDatasets.Player(
653                     {
654                         withdrawalAmount : 0,
655                         wallet : 0,
656                         fomoTotalRevenue : 0,
657                         lotteryTotalRevenue : 0,
658                         dynamicIncome : 0,
659                         rechargeAmount : 0,
660                         staticIncome : 0,
661                         shareholderLevel : 0,
662                         underUmbrellaLevel : 0,
663                         subbordinateTotalPerformance : 0,
664                         isExist : true,
665                         superior : true,
666                         superiorAddr : superiorAddr,
667                         subordinates : temp
668                     }
669                 );
670                 DappDatasets.Player storage superiorPlayer = playerMap[superiorAddr];
671                 superiorPlayer.subordinates.push(addr);
672                 playerMap[addr] = player;
673             }
674             allPlayer.push(addr);
675         }
676 
677     }
678 
679     contract TetherToken {
680        function transfer(address to, uint value) public;
681        function transferFrom(address from, address to, uint value) public;
682     }
683 
684     contract AWToken {
685        function burn(address addr, uint value) public;
686        function balanceOf(address who) external view returns (uint);
687        function calculationNeedAW(uint usdtVal) external view returns(uint);
688        function usdtPrice() external view returns(uint);
689     }
690 
691     contract AWGame {
692         function deposit(uint usdtVal, address addr) external returns(uint);
693         function updateLotteryPoolAndTodayAmountTotal(uint usdtVal, uint lotteryPool) external;
694         function redeemAW(uint usdtVal, uint usdtPrice, address addr) external;
695         function buyLotto(uint usdtVal, address addr) external;
696     }