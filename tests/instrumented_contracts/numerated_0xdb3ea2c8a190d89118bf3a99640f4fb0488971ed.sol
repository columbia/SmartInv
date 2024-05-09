1 pragma solidity 0.4.24;
2 
3 contract IAdminContract {
4     function getGameAdmin() public view returns (address);
5 
6     modifier admin() {
7         require(msg.sender == getGameAdmin());
8         _;
9     }
10 }
11 
12 contract IBlockRandomLibrary {
13     function setRandomBlock(uint blockNumber) internal;
14     function updateRandom() public;
15     function isRandomAvailable() public view returns(bool);
16     function randomBlockPassed() public view returns(bool); 
17     function getRandomValue() public view returns(uint);
18     function canStoreRandom() public view returns(bool);
19     function isRandomStored() public view returns(bool);
20 }
21 
22 contract IStartGame {
23     function startOwnFixed(uint gameId, uint length, uint addon, uint prize) public payable;
24     function betInGame(uint gameId) public payable;
25     function recalcNextGameId() public;
26     function getProfitedCount() public view returns(uint);
27     function getCreateFastGamesCount() public view returns(uint);
28     function setCreateFastGamesCount(uint count) public;
29     function canStartGame() public view returns(bool);
30     function startGameId() public view returns(uint);
31     function startPrizeValue() public view returns(uint);
32     function startGameLength() public view returns(uint);
33     function startGameAddon() public view returns(uint);
34     function getStartGameStatus() public view returns(bool, uint, uint, uint, uint);
35     function getTransferProfitedGame(address participant) public view returns(uint);
36     function defaultGameAvailable() public view returns(bool);
37     function defaultGameId() public view returns(uint);
38     function getRepeatBlock() public view returns(uint);
39     function getAddonBlock() public view returns(uint);
40     function alterRepeatBlock(uint _repeatBlock) public;
41     function alterAddonBlock(uint _addonBlock) public;
42 
43     event RepeatBlockAltered(uint newValue);
44     event RepeatAddonBlockAltered(uint newValue);
45     event NextGameIdCalculated(uint gameId);
46     event DefaultGameUpdated(uint gameId);
47     event TransferBet(address better, uint value);
48     event GameProfitedEvent(uint gameId);
49     event FastGamesChanged(uint faseGamesCreate);
50 }
51 
52 contract ICommonGame is IAdminContract {
53     function gameFinishing() public view returns(bool);
54     function stopGame() public;
55     function totalVariants() public view returns(uint);
56     function alterTotalVariants(uint _newVariants) public;
57     function autoCreationAllowed() public view returns(bool);
58     function setAutoCreation(bool allowed) public;
59     function autoCreationAfterOwnAllowed() public view returns(bool);
60     function setAutoCreationAfterOwn(bool allowed) public;
61     function transferInteractionsAllowed() public view returns(bool); 
62     function setTransferInteractions(bool allowed) public; 
63     function startOnlyMinPrizes() public view returns (bool);
64     function setStartOnlyMinPrizes(bool minPrizes) public;
65     function startProfitedGamesAllowed() public view returns (bool);
66     function setStartProfitedGamesAllowed(bool games) public;
67     function gameFinished() public view returns(bool);
68     function gameFinishedBlock() public view returns(uint);
69 
70     function creationAllowed() public view returns(bool) {
71         return autoCreationAllowed() && !gameFinishing();
72     }
73 
74     event GameStopInitiated(uint finishingBlock);
75     event TransferInteractionsChanged(bool newValue);
76     event StartOnlyMinPrizesChanged(bool newValue);
77     event StartProfitedGamesAllowedChanged(bool newValue);
78 
79     event AutoCreationChanged(bool newValue);
80     event AutoCreationAfterOwnChanged(bool newValue);
81     event TotalVariantsChanged(uint newTotalVariants);
82 }
83 
84 contract IFunctionPrize {
85     function calcPrizeX(uint x, uint maxX, uint maxPrize)  public view returns (uint);
86     function prizeFunctionName() public view returns (string);
87 }
88 
89 contract IPrizeLibrary is ICommonGame {
90     function calculatePrize(uint number, uint minPrize, uint maxPrize) public view returns(uint);
91     function prizeName() public view returns (string);    
92 }
93 
94 contract IBalanceSharePrizeContract {
95     function getMaxPrizeShare() public view returns (uint);
96     function alterPrizeShare(uint _maxPrizeShare) public;
97     event MaxPrizeShareAltered(uint share);
98 }
99 
100 contract IMinMaxPrize {
101     function getMaxPrize() public view returns(uint);
102     function getWholePrize() public view returns(uint);
103     function getMinPrize() public view returns(uint);
104     function alterMinPrize(uint _minPrize) public;
105     function alterMaxPrize(uint _maxPrize) public;
106 
107     event MinPrizeAltered(uint prize);
108     event MaxPrizeAltered(uint prize);
109 }
110 
111 contract IBalanceInfo {
112     function totalBalance() public view returns(uint);
113     function availableBalance() public view returns(uint);
114     function reserveBalance(uint value) internal returns(uint);
115     function reservedBalance() public view returns(uint);
116     function freeBalance(uint value) internal returns(uint);
117 
118     event BalanceReserved(uint value, uint total);
119     event BalanceFreed(uint value, uint total);
120 }
121 
122 contract BlockRandomLibrary is IBlockRandomLibrary {
123     uint public randomBlock;
124     uint public randomValue;
125     uint public maxBlocks;
126 
127     constructor(uint _maxBlocks) public 
128         IBlockRandomLibrary()
129     {
130         assert(_maxBlocks <= 250);
131         randomValue = 0;
132         randomBlock = 0;
133         maxBlocks = _maxBlocks;
134     }
135 
136     function setRandomBlock(uint blockNumber) internal {
137         randomBlock = blockNumber;
138         if (canStoreRandom()) {
139             randomValue = uint(blockhash(randomBlock));
140             emit RandomValueCalculated(randomValue, randomBlock);
141         } else {
142             randomValue = 0;
143         }
144     }
145 
146     event RandomValueCalculated(uint value, uint randomBlock);
147     
148     function updateRandom() public {
149         if (!isRandomStored() && canStoreRandom()) {
150             randomValue = uint(blockhash(randomBlock));
151             emit RandomValueCalculated(randomValue, randomBlock);
152         }
153     }
154 
155     function isRandomAvailable() public view returns(bool) {
156         return isRandomStored() || canStoreRandom();
157     }
158 
159     function getRandomValue() public view returns(uint) {
160         if (isRandomStored()) {
161             return randomValue;
162         } else if (canStoreRandom()) {
163             return uint(blockhash(randomBlock));
164         } 
165 
166         return 0;
167     }
168 
169     function canStoreRandom() public view returns(bool) {
170         return !blockExpired() && randomBlockPassed();
171     }
172     function randomBlockPassed() public view returns(bool) {
173         return block.number > randomBlock;
174     }
175     function blockExpired() public view returns(bool) {
176         return block.number > randomBlock + maxBlocks;
177     }
178     function isRandomStored() public view returns (bool) {
179         return randomValue != 0;
180     }
181 }
182 
183 contract EllipticPrize16x is IFunctionPrize {
184     function calcModulo(uint fMax) internal pure returns (uint) {
185         uint sqr = fMax * fMax * fMax * fMax;
186         return sqr * sqr * sqr * sqr;
187     }
188 
189     function calcPrizeX(uint x, uint fMax, uint maxPrize) public view returns (uint) {
190         uint xsq = (x + 1) * (x + 1);
191         uint xq = xsq * xsq;
192         uint xspt = xq * xq;
193         return (xspt * xspt * maxPrize) / calcModulo(fMax);
194     }
195 
196     function prizeFunctionName() public view returns (string) {
197         return "E16x";
198     }
199 } 
200 
201 contract BalanceSharePrizeContract is IBalanceSharePrizeContract, ICommonGame, IMinMaxPrize, IBalanceInfo {
202     uint public minPrize;
203     uint public maxPrizeShare;
204 
205     constructor(uint _minPrize, uint _maxPrizeShare) public {
206         assert(_minPrize >= 0);
207         assert(_maxPrizeShare > 0 && _maxPrizeShare <= 1 ether);
208 
209         minPrize = _minPrize;
210         maxPrizeShare = _maxPrizeShare;
211     }
212 
213     function getMaxPrizeShare() public view returns (uint) {
214         return maxPrizeShare;
215     }
216 
217     function alterPrizeShare(uint _maxPrizeShare) admin public {
218         require(_maxPrizeShare > 0 && _maxPrizeShare <= 1 ether, "Prize share should be between 0 and 100%");
219         maxPrizeShare = _maxPrizeShare;
220         emit MaxPrizeShareAltered(maxPrizeShare);
221     }
222 
223     function alterMinPrize(uint _minPrize) admin public {
224         minPrize = _minPrize;
225         emit MinPrizeAltered(minPrize);
226     }
227 
228     function alterMaxPrize(uint) admin public {
229     }
230 
231     function getMaxPrize() public view returns(uint) {
232         return (availableBalance() * maxPrizeShare) / (1 ether);        
233     }
234 
235     function getWholePrize() public view returns(uint) {
236         return availableBalance();
237     }
238 
239     function getMinPrize() public view returns(uint) {
240         return minPrize;
241     }
242 }
243 
244 contract PrizeLibrary is IPrizeLibrary, IFunctionPrize {
245     constructor() public {}
246 
247     function prizeName() public view returns (string) {
248         return prizeFunctionName();
249     }
250 
251     function calculatePrize(uint number, uint minPrize, uint maxPrize) public view returns(uint) {
252         uint prize = calcPrizeX(number % totalVariants(), totalVariants(), maxPrize);
253         uint minP = minPrize;
254         uint maxP = maxPrize;
255 
256         if (maxP < minP) {
257             return maxP;
258         } else if (prize < minP) {
259             return minP;
260         } else {
261             return prize;
262         }
263     }
264 }
265 
266 contract CommonGame is ICommonGame {
267     address public gameAdmin;
268     uint public blocks2Finish;
269     uint internal totalV;
270     uint internal sm_reserved;
271     bool internal finishing;
272     uint internal finishingBlock;
273     bool internal autoCreation;
274     bool internal autoCreationAfterOwn;
275     bool internal transferInteractions;
276     bool internal startMinPrizes;
277     bool internal profitedGames;
278 
279     constructor(address _gameAdmin) public {
280         assert(_gameAdmin != 0);
281         
282         gameAdmin = _gameAdmin;
283         blocks2Finish = 50000;
284         totalV = 1000;
285         autoCreation = true;
286         autoCreationAfterOwn = true;
287         transferInteractions = false;
288         startMinPrizes = false;
289         profitedGames = false;
290     }
291 
292     function getGameAdmin() public view returns (address) {
293         return gameAdmin;
294     }
295 
296     function gameFinished() public view returns(bool) {
297         return gameFinishing() && gameFinishedBlock() < block.number;
298     }
299 
300     function gameFinishing() public view returns(bool) {
301         return finishing;
302     }
303 
304     function stopGame() admin public {
305         stopGameInternal(blocks2Finish);
306     }
307 
308     function totalVariants() public view returns(uint) {
309         return totalV;
310     }
311 
312     function alterTotalVariants(uint _newVariants) admin public {
313         totalV = _newVariants;
314         emit TotalVariantsChanged(totalV);
315     }
316 
317     function stopGameInternal(uint blocks2add) internal {
318         require(!finishing);
319 
320         finishing = true;
321         finishingBlock = block.number + blocks2add;
322         emit GameStopInitiated(finishingBlock);
323     }
324 
325 
326     function gameFinishedBlock() public view returns(uint) {
327         return finishingBlock;
328     }
329 
330     function autoCreationAllowed() public view returns(bool) {
331         return autoCreation;
332     }
333 
334     function setAutoCreation(bool allowed) public admin {
335         autoCreation = allowed;
336         emit AutoCreationChanged(autoCreation);
337     }
338 
339     function autoCreationAfterOwnAllowed() public view returns(bool) {
340         return autoCreationAfterOwn;
341     }
342 
343     function setAutoCreationAfterOwn(bool allowed) public admin {
344         autoCreationAfterOwn = allowed;
345         emit AutoCreationAfterOwnChanged(autoCreation);
346     }
347 
348 
349     function transferInteractionsAllowed() public view returns(bool) {
350         return transferInteractions;
351     }
352     function setTransferInteractions(bool allowed) public admin {
353         transferInteractions = allowed;
354         emit TransferInteractionsChanged(transferInteractions);
355     }
356 
357     function startOnlyMinPrizes() public view returns (bool) {
358         return startMinPrizes;
359     }
360 
361     function setStartOnlyMinPrizes(bool minPrizes) public admin {
362         startMinPrizes = minPrizes;
363         emit StartOnlyMinPrizesChanged(startMinPrizes);
364     }
365 
366     function startProfitedGamesAllowed() public view returns (bool) {
367         return profitedGames;
368     }
369 
370     function setStartProfitedGamesAllowed(bool games) public admin {
371         profitedGames = games;
372         emit StartProfitedGamesAllowedChanged(profitedGames);
373     }
374 }
375 
376 contract BalanceInfo is IBalanceInfo {
377     uint internal sm_reserved;
378 
379     function totalBalance() public view returns(uint) {
380         return address(this).balance;
381     } 
382 
383     function reservedBalance() public view returns(uint) {
384         return sm_reserved;
385     }
386 
387     function availableBalance() public view returns(uint) {
388         if (totalBalance() >= sm_reserved) {
389             return totalBalance() - sm_reserved;
390         } else {
391             return 0;
392         }
393     } 
394 
395     function reserveBalance(uint value) internal returns (uint) {
396         uint balance = availableBalance();
397 
398         if (value > balance) {
399             sm_reserved += balance;
400             emit BalanceReserved(balance, sm_reserved);
401             return balance;
402         } else {
403             sm_reserved += value;
404             emit BalanceReserved(value, sm_reserved);
405             return value;
406         }
407     }
408 
409     function freeBalance(uint value) internal returns(uint) {
410         uint toReturn;
411 
412         if (value > sm_reserved) {
413             toReturn = sm_reserved;
414             sm_reserved = 0;
415         } else {
416             toReturn = value;
417             sm_reserved -= value;
418         }
419 
420         emit BalanceFreed(toReturn, sm_reserved);
421         return toReturn;
422     }
423 }
424 
425 contract IMoneyContract is ICommonGame, IBalanceInfo {
426     function profitValue() public view returns(uint);
427     function getDeveloperProfit() public view returns(uint);
428     function getCharityProfit() public view returns(uint);
429     function getFinalProfit() public view returns(uint);
430     function getLastBalance() public view returns(uint);
431     function getLastProfitSync() public view returns(uint);
432     function getDeveloperShare() public view returns(uint);
433     function getCharityShare() public view returns(uint);
434     function getFinalShare() public view returns(uint);
435     function depositToBank() public payable;
436     function canUpdatePayout() public view returns(bool);
437     function recalculatePayoutValue() public;
438     function withdrawPayout() public;
439     function withdraw2Address(address addr) public;
440     function finishedWithdrawalTime() public view returns(bool);
441     function finishedWithdrawalBlock() public view returns(uint);
442     function getTotalPayoutValue() public view returns(uint);
443     function getPayoutValue(address addr) public view returns(uint);
444     function getPayoutValueSender() public view returns(uint);
445     function addDeveloper(address dev, string name, string url) public;
446     function getDeveloperName(address dev) public view returns (string);
447     function getDeveloperUrl(address dev) public view returns (string);
448     function developersAdded() public view returns (bool);
449     function addCharity(address charity, string name, string url) public;
450     function getCharityName(address charity) public view returns (string);
451     function getCharityUrl(address charity) public view returns (string);
452     function dedicatedCharitySet() public view returns(bool);
453     function setDedicatedCharityForNextRound(address charity) public;
454     function dedicatedCharityAddress() public view returns(address);
455 
456     event MoneyDeposited(address indexed sender, uint value);
457     event MoneyWithdrawn(address indexed reciever, uint value);
458     event ProfitRecalculated(bool gameFinish, uint developerProfit, uint charityProfit, uint finalProfit, 
459     uint developerCount, uint charityCount, bool dedicated, address dedicatedCharity);
460     event CharityAdded(address charity, string name, string url);
461     event DedicatedCharitySelected(address charity);
462     event DeveloperAdded(address developer, string name, string url);
463 }
464 
465 contract MoneyContract is IMoneyContract {
466     uint public sm_developerShare; 
467     uint public sm_charityShare;
468     uint public sm_finalShare;
469 
470     ProfitInfo[] public sm_developers;
471     uint public sm_maxDevelopers;
472     
473     ProfitInfo[] public sm_charity;
474     mapping(address => bool) public sm_reciever;
475     mapping(address => uint) public sm_profits;
476     address public sm_dedicatedCharity;
477 
478     uint public sm_lastProfitSync;
479     uint public sm_profitSyncLength;
480     uint public sm_afterFinishLength;
481     uint public sm_lastBalance; 
482     uint internal sm_reserved;
483 
484     struct ProfitInfo {
485         address receiver; 
486         string description;
487         string url;
488     }
489 
490     constructor(uint _developerShare, uint _maxDevelopers, 
491             uint _charityShare, uint _finalShare, uint _profitSyncLength, uint _afterFinishLength) public {
492         assert(_developerShare >= 0 && _developerShare <= 1 ether);
493         assert(_charityShare >= 0 && _charityShare <= 1 ether);
494         assert(_finalShare >= 0 && _finalShare <= 1 ether);
495 
496         sm_developerShare = _developerShare;
497         sm_maxDevelopers = _maxDevelopers;
498         sm_charityShare = _charityShare;
499         sm_finalShare = _finalShare;
500         sm_profitSyncLength = _profitSyncLength;
501         sm_afterFinishLength = _afterFinishLength;
502         sm_lastProfitSync = block.number;
503     }
504 
505     function getDeveloperShare() public view returns(uint) {
506         return sm_developerShare;
507     }
508 
509     function getCharityShare() public view returns(uint) {
510         return sm_charityShare;
511     }
512 
513     function getFinalShare() public view returns(uint) {
514         return sm_finalShare;
515     }
516 
517     function getLastBalance() public view returns(uint) {
518         return sm_lastBalance;
519     }
520 
521     function getLastProfitSync() public view returns(uint) {
522         return sm_lastProfitSync;
523     }
524 
525     function canUpdatePayout() public view returns(bool) {
526         return developersAdded() && (gameFinished() || block.number >= sm_profitSyncLength + sm_lastProfitSync);
527     }
528 
529     function recalculatePayoutValue() public {
530         if (canUpdatePayout()) {
531             recalculatePayoutValueInternal();
532         } else {
533             revert();
534         }
535     }
536 
537     function recalculatePayoutValueInternal() internal {
538         uint d_profit = 0;
539         uint c_profit = 0;
540         uint o_profit = 0;
541         bool dedicated = dedicatedCharitySet();
542         address dedicated_charity = sm_dedicatedCharity;
543 
544         if (gameFinished()) {
545             o_profit = getFinalProfit();
546             c_profit = availableBalance() - o_profit;
547             distribute(o_profit, sm_developers);
548             distribute(c_profit, sm_charity);
549         } else {
550             d_profit = getDeveloperProfit();
551             c_profit = getCharityProfit();
552             distribute(d_profit, sm_developers);
553 
554             if (dedicated) {
555                 distributeTo(c_profit, sm_dedicatedCharity);
556             } else {
557                 distribute(c_profit, sm_charity);
558             }
559 
560             sm_lastProfitSync = block.number;
561             sm_dedicatedCharity = address(0);
562         }
563 
564         sm_lastBalance = availableBalance();
565         emit ProfitRecalculated(gameFinished(), d_profit, c_profit, o_profit, 
566             sm_developers.length, sm_charity.length, dedicated, dedicated_charity);
567     }
568 
569     function addDeveloper(address dev, string name, string url) admin public {
570         require(!sm_reciever[dev]);
571         require(!gameFinished());
572         require(sm_developers.length < sm_maxDevelopers);
573 
574         sm_developers.push(ProfitInfo(dev, name, url));
575         sm_reciever[dev] = true;
576         emit DeveloperAdded(dev, name, url);
577     }
578 
579     function developersAdded() public view returns (bool) {
580         return sm_maxDevelopers == sm_developers.length;
581     }
582 
583     function getDeveloperName(address dev) public view returns (string) {
584         for (uint i = 0; i < sm_developers.length; i++) {
585             if (sm_developers[i].receiver == dev) return sm_developers[i].description;
586         }
587 
588         return "";
589     }
590     function getDeveloperUrl(address dev) public view returns (string) {
591         for (uint i = 0; i < sm_developers.length; i++) {
592             if (sm_developers[i].receiver == dev) return sm_developers[i].url;
593         }
594 
595         return "";
596     }
597 
598     function addCharity(address charity, string name, string url) admin public {
599         require(!sm_reciever[charity]);
600         require(!gameFinished());
601 
602         sm_charity.push(ProfitInfo(charity, name, url));
603         sm_reciever[charity] = true;
604         emit CharityAdded(charity, name, url);
605     }
606 
607     function getCharityName(address charity) public view returns (string) {
608         for (uint i = 0; i < sm_charity.length; i++) {
609             if (sm_charity[i].receiver == charity) return sm_charity[i].description;
610         }
611 
612         return "";
613     }
614     function getCharityUrl(address charity) public view returns (string) {
615         for (uint i = 0; i < sm_charity.length; i++) {
616             if (sm_charity[i].receiver == charity) return sm_charity[i].url;
617         }
618 
619         return "";
620     }
621 
622 
623     function charityIndex(address charity) view internal returns(int) {
624         for (uint i = 0; i < sm_charity.length; i++) {
625             if (sm_charity[i].receiver == charity) {
626                 return int(i);
627             }
628         }
629         
630         return -1;
631     }
632 
633     function charityExists(address charity) view internal returns(bool) {
634         return charityIndex(charity) >= 0;
635     }
636 
637     function setDedicatedCharityForNextRound(address charity) admin public {
638         require(charityExists(charity));
639         require(sm_dedicatedCharity == address(0));
640         sm_dedicatedCharity = charity;
641         emit DedicatedCharitySelected(sm_dedicatedCharity);
642     }
643 
644     function dedicatedCharitySet() public view returns(bool) {
645         return sm_dedicatedCharity != address(0);
646     }
647 
648     function dedicatedCharityAddress() public view returns(address) {
649         return sm_dedicatedCharity;
650     }
651     
652     function depositToBank() public payable {
653         require(!gameFinished());
654         require(msg.value > 0);
655         sm_lastBalance += msg.value;
656         emit MoneyDeposited(msg.sender, msg.value);
657     }
658 
659     function finishedWithdrawalTime() public view returns(bool) {
660         return gameFinished() && (block.number > finishedWithdrawalBlock());
661     }
662 
663     function finishedWithdrawalBlock() public view returns(uint) {
664         if (gameFinished()) {
665             return gameFinishedBlock() + sm_afterFinishLength;
666         } else {
667             return 0;
668         }
669     }
670 
671     function getTotalPayoutValue() public view returns(uint) {
672         uint payout = 0;
673 
674         for (uint i = 0; i < sm_developers.length; i++) {
675             payout += sm_profits[sm_developers[i].receiver];
676         }
677         for (i = 0; i < sm_charity.length; i++) {
678             payout += sm_profits[sm_charity[i].receiver];
679         }
680 
681         return payout;
682     }
683 
684     function getPayoutValue(address addr) public view returns(uint) {
685         return sm_profits[addr];
686     }
687 
688     function getPayoutValueSender() public view returns(uint) {
689         return getPayoutValue(msg.sender);
690     }
691 
692     function withdrawPayout() public {
693         if (finishedWithdrawalTime() && msg.sender == getGameAdmin()) {
694             getGameAdmin().transfer(address(this).balance);
695         } else {
696             withdraw2Address(msg.sender);
697         }
698     }
699 
700     function withdraw2Address(address addr) public {
701         require(sm_profits[addr] > 0);
702 
703         uint value = sm_profits[addr];
704         sm_profits[addr] = 0;
705 
706         freeBalance(value);
707         addr.transfer(value);
708         emit MoneyWithdrawn(addr, value);
709     }
710 
711     function profitValue() public view returns(uint) {
712         if (availableBalance() >= sm_lastBalance) {
713             return availableBalance() - sm_lastBalance;
714         } else {
715             return 0;
716         }
717     }
718 
719     function getDeveloperProfit() public view returns(uint) {
720         return (profitValue() * sm_developerShare) / (1 ether);
721     }
722 
723     function getCharityProfit() public view returns(uint) {
724         return (profitValue() * sm_charityShare) / (1 ether);
725     }
726 
727     function getFinalProfit() public view returns(uint) {
728         return (availableBalance() * sm_finalShare) / (1 ether);
729     }
730 
731     function distributeTo(uint value, address recv) internal {
732         sm_profits[recv] += value;
733         reserveBalance(value);
734     }
735 
736     function distribute(uint profit, ProfitInfo[] recvs) internal {
737         if (recvs.length > 0) {
738             uint each = profit / recvs.length;
739             uint total = 0;
740             for (uint i = 0; i < recvs.length; i++) {
741                 if (i == recvs.length - 1) {
742                     distributeTo(profit - total, recvs[i].receiver);
743                 } else {
744                     distributeTo(each, recvs[i].receiver);
745                     total += each;
746                 }
747             }
748         }
749     }
750 }
751 
752 contract ISignedContractId {
753     function getId() public view returns(string);
754     function getVersion() public view returns(uint);
755     function getIdHash() public view returns(bytes32);
756     function getDataHash() public view returns(bytes32);
757     function getBytes() public view returns(bytes);
758     function sign(uint8 v, bytes32 r, bytes32 s) public;
759     function getSignature() public view returns(uint8, bytes32, bytes32);
760     function isSigned() public view returns(bool);
761 }
762 
763 
764 contract SignedContractId is ISignedContractId {
765     string public contract_id;
766     uint public contract_version;
767     bytes public contract_signature;
768     address public info_address;
769     address public info_admin;
770     uint8 public v; 
771     bytes32 public r; 
772     bytes32 public s;
773     bool public signed;
774 
775     constructor(string id, uint version, address info, address admin) public {
776         contract_id = id;
777         contract_version = version;
778         info_address = info;
779         info_admin = admin;
780         signed = false;
781     }
782     function getId() public view returns(string) {
783         return contract_id;
784     }
785     function getVersion() public view returns(uint) {
786         return contract_version;
787     }
788     function getIdHash() public view returns(bytes32) {
789         return keccak256(abi.encodePacked(contract_id));
790     }
791     function getBytes() public view returns(bytes) {
792         return abi.encodePacked(contract_id);
793     }
794 
795 
796     function getDataHash() public view returns(bytes32) {
797         return keccak256(abi.encodePacked(getIdHash(), getVersion(), info_address, address(this)));
798     }
799 
800     function sign(uint8 v_, bytes32 r_, bytes32 s_) public {
801         require(!signed);
802         bytes32 hsh = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", getDataHash()));
803         require(info_admin == ecrecover(hsh, v_, r_, s_));
804         v = v_;
805         r = r_;
806         s = s_;
807         signed = true;
808     }
809 
810     function getSignature() public view returns(uint8, bytes32, bytes32) {
811         return (v, r, s);
812     }
813 
814     function isSigned() public view returns(bool) {
815         return signed;
816     }
817 }
818 
819 contract IGameLengthLibrary is ICommonGame {
820     function getMinGameLength() public view returns(uint);
821     function getMaxGameLength() public view returns(uint);
822     function getMinGameAddon() public view returns(uint);
823     function getMaxGameAddon() public view returns(uint);
824 
825     function calcGameLength(uint number) public view returns (uint);
826     function calcGameAddon(uint number) public view returns (uint);
827 
828     event MinGameLengthAltered(uint newValue);
829     event MaxGameLengthAltered(uint newValue);
830     event AddonAltered(uint newValue);
831 
832     function alterMaxGameLength(uint _maxGameLength) public;
833     function alterMinGameLength(uint _minGameLength) public;
834     function alterAddon(uint _addon) public;
835 }
836 
837 contract LinearGameLibrary is IGameLengthLibrary {
838     uint public minLength;
839     uint public maxLength;
840     uint public addon;
841 
842     constructor(uint _minLength, uint _maxLength, uint _addon) public {
843         assert(_minLength <= _maxLength);
844 
845         minLength = _minLength;
846         maxLength = _maxLength;
847         addon = _addon;
848     }
849 
850     function calcGameLength(uint number) public view returns (uint) {
851         return minLength + ((maxLength - minLength) * ((number % totalVariants()) + 1)) / totalVariants();
852     }
853     
854     function calcGameAddon(uint) public view returns (uint) {
855         return addon;
856     }
857 
858     function getMinGameLength() public view returns(uint) {
859         return minLength;
860     }
861 
862     function getMaxGameLength() public view returns(uint) {
863         return maxLength;
864     }
865 
866     function getMinGameAddon() public view returns(uint) {
867         return addon;
868     }
869 
870     function getMaxGameAddon() public view returns(uint) {
871         return addon;
872     }
873      
874     function alterMaxGameLength(uint _maxGameLength) public admin {
875         require(_maxGameLength > 0, "Max game length should be not zero");
876         require(_maxGameLength >= minLength, "Max game length should be not more than min length");
877         maxLength = _maxGameLength;
878         emit MaxGameLengthAltered(maxLength);
879     }
880 
881     function alterMinGameLength(uint _minGameLength) public admin {
882         require(_minGameLength > 0, "Min game length should be not zero");
883         require(_minGameLength <= maxLength, "Min game length should be less than max length");
884         minLength = _minGameLength;
885         emit MinGameLengthAltered(minLength);
886     }
887 
888     function alterAddon(uint _addon) public admin {
889         addon = _addon;
890         emit AddonAltered(addon);
891     }
892 }
893  
894 contract IGameManager {
895     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal;
896     function betInGameInternal(uint gameId, uint bet) internal;
897 
898     function withdrawPrize(uint gameId) public;
899     function withdrawPrizeInternal(uint gameId, uint additional) internal;
900 
901     function gameExists(uint gameId) public view returns (bool);
902     function finishedGame(uint gameId) public view returns(bool);
903     function getWinner(uint gameId) public view returns(address);
904     function getBet(uint gameId, address better) public view returns(uint);
905     function payedOut(uint gameId) public view returns(bool);
906     function prize(uint gameId) public view returns(uint);
907     function endsIn(uint gameId) public view returns(uint);
908     function lastBetBlock(uint gameId) public view returns(uint);
909 
910     function addonEndsIn(uint gameId) public view returns(uint);
911     function totalBets(uint gameId) public view returns(uint);
912     function gameProfited(uint gameId) public view returns(bool);
913 
914     event GameStarted(uint indexed gameId, address indexed starter, uint blockNumber, uint finishBlock, uint prize);
915     event GameBet(uint indexed gameId, address indexed bidder, address indexed winner, uint highestBet, uint finishBlock, uint value);
916     event GamePrizeTaken(uint indexed gameId, address indexed winner);
917 }
918 
919 contract GameManager is IBalanceInfo, IGameManager {
920     mapping (uint => GameInfo) games;
921     mapping (uint => mapping (address => uint)) bets;
922 
923     struct GameInfo {
924         address highestBidder; // the person who made the highest bet in this game
925         address starter; // the person who started this game
926         uint blockFinish; // the block when the game will be finished
927         uint prize; // the prize, that will be awarded to the winner
928         uint totalBets; // the amount of total bets to this game
929         bool payedOut; // true, if the user has taken back his deposit
930         uint lastBetBlock;
931         uint addOn;
932     }
933 
934     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal {
935         require(!gameExists(gameId));
936         require(prize > 0);
937         require(length > 0);
938         games[gameId].starter = msg.sender;
939         games[gameId].prize = prize;
940         reserveBalance(prize);
941         games[gameId].blockFinish = block.number + length - 1;
942         games[gameId].addOn = addOn;
943         emit GameStarted(gameId, msg.sender, block.number, games[gameId].blockFinish, prize);
944     }
945 
946     function betInGameInternal(uint gameId, uint bet) internal {
947         require(bet > 0, "Bet should be not zero");
948         require(gameExists(gameId), "No such game");
949         require(!finishedGame(gameId), "Game is finished");
950         uint newBet = bets[gameId][msg.sender] + bet;
951         
952         if (newBet > bets[gameId][games[gameId].highestBidder]) {
953             games[gameId].highestBidder = msg.sender;
954             games[gameId].lastBetBlock = block.number;
955         } 
956 
957         bets[gameId][msg.sender] = newBet;
958         games[gameId].totalBets += bet;
959         emit GameBet(gameId, msg.sender, games[gameId].highestBidder, bets[gameId][games[gameId].highestBidder], addonEndsIn(gameId), newBet);
960     }
961 
962     function withdrawPrize(uint gameId) public {
963         withdrawPrizeInternal(gameId, 0);
964     }
965 
966     function withdrawPrizeInternal(uint gameId, uint additional) internal {
967         require(finishedGame(gameId), "Game not finished");
968         require(msg.sender == games[gameId].highestBidder, "You are not the winner");
969         require(!games[gameId].payedOut, "Game already payed");
970         games[gameId].payedOut = true;
971         freeBalance(games[gameId].prize);
972         msg.sender.transfer(games[gameId].prize + additional);
973         emit GamePrizeTaken(gameId, msg.sender);
974     }
975 
976     function gameExists(uint gameId) public view returns (bool) {
977         return games[gameId].blockFinish != 0;
978     }
979 
980     function getWinner(uint gameId) public view returns(address) {
981         return games[gameId].highestBidder;
982     }
983 
984     function finishedGame(uint gameId) public view returns(bool) {
985         if (!gameExists(gameId)) 
986             return false;
987         return addonEndsIn(gameId) < block.number;
988     }
989 
990     function payedOut(uint gameId) public view returns(bool) {
991         return games[gameId].payedOut;
992     }
993 
994     function prize(uint gameId) public view returns(uint) {
995         return games[gameId].prize;
996     }
997 
998     function lastBetBlock(uint gameId) public view returns(uint) {
999         return games[gameId].lastBetBlock;
1000     }
1001 
1002     function getBet(uint gameId, address better) public view returns(uint) {
1003         return bets[gameId][better];
1004     }
1005 
1006     function endsIn(uint gameId) public view returns(uint) {
1007         return games[gameId].blockFinish;
1008     }
1009 
1010     function addonEndsIn(uint gameId) public view returns(uint) {
1011         uint addonB = games[gameId].lastBetBlock + games[gameId].addOn;
1012         if (addonB >= games[gameId].blockFinish) {
1013             return addonB;
1014         } else {
1015             return games[gameId].blockFinish;
1016         }
1017     }
1018 
1019     function totalBets(uint gameId) public view returns(uint) {
1020         return games[gameId].totalBets;
1021     }
1022 
1023     function gameProfited(uint gameId) public view returns(bool) {
1024         return games[gameId].totalBets >= games[gameId].prize;
1025     }
1026 }
1027 contract StartGame is IStartGame, ICommonGame, IPrizeLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IBlockRandomLibrary {
1028     bool internal previousCalcRegular;
1029 
1030     constructor(uint _repeatBlock, uint _addonBlock) public
1031     {
1032         assert(_repeatBlock <= 250);
1033         repeatBlock = _repeatBlock;
1034         addonBlock = _addonBlock;
1035         calcNextGameId();
1036         defaultId = nextGameId;
1037     }
1038 
1039     function startOwnFixed(uint gameId, uint length, uint addon, uint prize) public admin payable {
1040         require(msg.value > 0);
1041         require(!gameExists(gameId));
1042         require(gameId % 2 == 1);
1043         require(length >= getMinGameLength());
1044         require(prize >= getMinPrize() && prize <= getWholePrize());
1045 
1046         updateRandom();
1047         startGameInternal(gameId, length, addon, prize);
1048         profitedBet(gameId);
1049     }
1050 
1051     function randomValueWithMinPrize() internal view returns(uint) {
1052         if (!startOnlyMinPrizes() && isRandomAvailable()) {
1053             return getRandomValue();
1054         }
1055 
1056         return 0;
1057     }
1058 
1059     function startGameDetermine(uint gameId) internal {
1060         uint random = randomValueWithMinPrize();
1061         startGameInternal(gameId, calcGameLength(random), calcGameAddon(random), calculatePrize(random, getMinPrize(), getMaxPrize()));
1062     }
1063 
1064     function betInGame(uint gameId) public payable {
1065         require(msg.value > 0, "Bet should be not zero");
1066         updateRandom();
1067 
1068         if (!gameExists(gameId)) {
1069             require(canStartGame(), "Game cannot be started");
1070             require(startGameId() == gameId, "No such scheduled game");
1071             startGameDetermine(gameId);
1072             updateDefaultGame(gameId);
1073             calcNextGameId();
1074         }
1075 
1076         profitedBet(gameId);
1077     }
1078 
1079     function profitedBet(uint gameId) internal {
1080         bool profited = gameProfited(gameId);
1081         betInGameInternal(gameId, msg.value);
1082         if (profited != gameProfited(gameId)) {
1083             if (startProfitedGamesAllowed() && (gameId % 2 == 0 || autoCreationAfterOwnAllowed())) {
1084                 createFastGamesCount++;
1085                 if (!isRandomAvailable() && previousCalcRegular && createFastGamesCount == 1) {
1086                     calcNextGameId();
1087                 }
1088                 emit FastGamesChanged(createFastGamesCount);
1089             }
1090             profitedCount++;
1091             emit GameProfitedEvent(gameId);
1092         }
1093     }
1094         
1095     uint public repeatBlock;
1096     uint public addonBlock;
1097 
1098     function getRepeatBlock() public view returns(uint) {
1099         return repeatBlock;
1100     }
1101     function getAddonBlock() public view returns(uint) {
1102         return addonBlock;
1103     }
1104 
1105     function alterRepeatBlock(uint _repeatBlock) admin public {
1106         assert(_repeatBlock < 250);
1107         repeatBlock = _repeatBlock;
1108         emit RepeatBlockAltered(repeatBlock);
1109     }
1110 
1111     function alterAddonBlock(uint _addonBlock) admin public {
1112         addonBlock = _addonBlock;
1113         emit RepeatAddonBlockAltered(addonBlock);
1114     }
1115 
1116     uint internal nextGameId;
1117     uint internal defaultId;
1118     uint internal profitedCount;
1119     uint internal createFastGamesCount;
1120 
1121     function getProfitedCount() public view returns(uint) {
1122         return profitedCount;
1123     }
1124 
1125     function getCreateFastGamesCount() public view returns(uint) {
1126         return createFastGamesCount;
1127     }
1128 
1129     function setCreateFastGamesCount(uint count) public admin {
1130         createFastGamesCount = count;
1131         emit FastGamesChanged(createFastGamesCount);
1132     }
1133 
1134     function recalcNextGameId() public admin {
1135         if (!isRandomAvailable()) {
1136             calcNextGameId();
1137         } else {
1138             revert("You cannot recalculate, unless the prize has expired");
1139         }
1140     }
1141 
1142     function calcNextGameId() internal {
1143         uint ngi;
1144 
1145         previousCalcRegular = createFastGamesCount == 0;
1146 
1147         if (createFastGamesCount > 0) {
1148             ngi = block.number + addonBlock;
1149             createFastGamesCount--;
1150         } else {
1151             ngi = block.number + (repeatBlock - block.number % repeatBlock);
1152         }
1153 
1154         if (ngi % 2 == 1) {
1155             ngi++;
1156         }
1157 
1158         nextGameId = ngi;
1159         setRandomBlock(nextGameId);
1160         updateDefaultGame(nextGameId);
1161         emit NextGameIdCalculated(nextGameId);
1162     }
1163 
1164     function canStartGame() public view returns(bool) {
1165         return randomBlockPassed() && creationAllowed();
1166     }
1167 
1168     function startGameId() public view returns(uint) {
1169         return nextGameId;
1170     }
1171 
1172     function startPrizeValue() public view returns(uint) {
1173         return calculatePrize(randomValueWithMinPrize(), getMinPrize(), getMaxPrize());
1174     }
1175 
1176     function startGameLength() public view returns(uint) {
1177         return calcGameLength(randomValueWithMinPrize());
1178     }
1179 
1180     function startGameAddon() public view returns(uint) {
1181         return calcGameAddon(randomValueWithMinPrize());
1182     }
1183 
1184     function getStartGameStatus() public view returns(bool, uint, uint, uint, uint) {
1185         uint random = randomValueWithMinPrize();
1186         return (
1187             canStartGame(), 
1188             nextGameId, 
1189             calculatePrize(random, getMinPrize(), getMaxPrize()),
1190             calcGameLength(random),
1191             calcGameAddon(random));
1192     }
1193 
1194     function updateDefaultGame(uint gameId) internal {
1195         if (finishedGame(defaultId) || !gameExists(defaultId)) {
1196             defaultId = gameId;
1197             emit DefaultGameUpdated(defaultId);
1198         } 
1199     }
1200 
1201     function defaultGameId() public view returns(uint) {
1202         if (!finishedGame(defaultId) && gameExists(defaultId)) return defaultId;
1203         if (canStartGame()) return startGameId();
1204         return 0;
1205     }
1206 
1207     function defaultGameAvailable() public view returns(bool) {
1208         return !finishedGame(defaultId) && gameExists(defaultId) || canStartGame();
1209     }
1210 
1211     mapping (address => uint) transferGames;
1212 
1213     function getTransferProfitedGame(address participant) public view returns(uint) {
1214         if (finishedGame(transferGames[participant]) && getWinner(transferGames[participant]) == participant) {
1215             return transferGames[participant];
1216         }
1217 
1218         return 0;
1219     }
1220 
1221     function getTransferProfitedGame() internal view returns(uint) {
1222         return getTransferProfitedGame(msg.sender);
1223     }
1224 
1225     function processTransfer() internal {
1226         uint tpg = getTransferProfitedGame();
1227         if (tpg == 0) {
1228             if (!finishedGame(defaultId) && gameExists(defaultId)) {
1229                 betInGame(defaultId);
1230             } else {
1231                 betInGame(startGameId());
1232             }
1233             transferGames[msg.sender] = defaultId;
1234         } else {
1235             transferGames[msg.sender] = 0;
1236             withdrawPrizeInternal(tpg, msg.value);
1237         } 
1238 
1239         emit TransferBet(msg.sender, msg.value);
1240     }
1241 
1242     function processTransferInteraction() internal {
1243         if (transferInteractionsAllowed()) {
1244             processTransfer();
1245         } else {
1246             revert();
1247         }
1248     }
1249 }
1250 
1251 contract ICharbetto is IMoneyContract, IStartGame, IBalanceSharePrizeContract,
1252         IBlockRandomLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IFunctionPrize, IPrizeLibrary {
1253     function recalculatePayoutValueAdmin() public;
1254     function stopGameFast() public;
1255 }
1256 
1257 contract Charbetto is CommonGame, BlockRandomLibrary, BalanceInfo, PrizeLibrary, EllipticPrize16x, 
1258         MoneyContract, StartGame, GameManager, LinearGameLibrary, BalanceSharePrizeContract {
1259     constructor(address _admin) public
1260         CommonGame(_admin) 
1261         BlockRandomLibrary(250)
1262         BalanceInfo()
1263         PrizeLibrary()
1264         EllipticPrize16x()
1265         MoneyContract(
1266             10 finney /*1 percent*/, 
1267             5, /*5 developers at maximum*/
1268             100 finney /*10 percent*/, 
1269             100 finney /*10 percent*/, 
1270             20000, 200000)
1271         StartGame(5, 3)  
1272         GameManager()
1273         LinearGameLibrary(50, 1000, 3)
1274         BalanceSharePrizeContract(10 finney, 100 finney)
1275     {
1276         totalV = 1000;
1277         minLength = 20;
1278         maxLength = 30;
1279         transferInteractions = true;
1280     }
1281     function betInGame(uint gameId) public payable {
1282         bool exists = gameExists(gameId);
1283 
1284         if (!exists) {
1285             reserveBalance(msg.value);
1286         }
1287 
1288         super.betInGame(gameId);
1289 
1290         if (!exists) {
1291             freeBalance(msg.value);
1292         }
1293     }
1294 
1295     function isItReallyCharbetto() public pure returns (bool) {
1296         return true;
1297     }
1298 
1299     function () payable public {
1300         processTransferInteraction();
1301     }
1302 }
1303 
1304 contract ISignedCharbetto is ISignedContractId, ICharbetto {}
1305 
1306 contract SignedCharbetto is Charbetto, SignedContractId {
1307     constructor(address admin_, uint version_, address infoContract_, address infoAdminAddress_) public 
1308         Charbetto(admin_) 
1309         SignedContractId("charbetto", version_, infoContract_, infoAdminAddress_)
1310     {} 
1311 
1312     function recalculatePayoutValueAdmin() admin public {
1313         revert();
1314     }
1315 
1316     function stopGameFast() admin public {
1317         revert();
1318     }
1319 
1320     function () payable public {
1321         processTransferInteraction();
1322     }
1323 }