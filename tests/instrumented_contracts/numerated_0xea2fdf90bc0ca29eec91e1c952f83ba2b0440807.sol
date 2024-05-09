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
450     function canAddCharity() public view returns (bool);
451     function lastCharityAdded() public view returns (uint);
452     function getCharityName(address charity) public view returns (string);
453     function getCharityUrl(address charity) public view returns (string);
454     function dedicatedCharitySet() public view returns(bool);
455     function setDedicatedCharityForNextRound(address charity) public;
456     function dedicatedCharityAddress() public view returns(address);
457 
458     event MoneyDeposited(address indexed sender, uint value);
459     event MoneyWithdrawn(address indexed reciever, uint value);
460     event ProfitRecalculated(bool gameFinish, uint developerProfit, uint charityProfit, uint finalProfit, 
461     uint developerCount, uint charityCount, bool dedicated, address dedicatedCharity);
462     event CharityAdded(address charity, string name, string url);
463     event DedicatedCharitySelected(address charity);
464     event DeveloperAdded(address developer, string name, string url);
465 }
466 
467 contract MoneyContract is IMoneyContract {
468     uint public sm_developerShare;
469     uint public sm_charityShare;
470     uint public sm_finalShare;
471 
472     ProfitInfo[] public sm_developers;
473     uint public sm_maxDevelopers;
474     
475     ProfitInfo[] public sm_charity;
476     uint public sm_lastCharityAdded;
477     mapping(address => bool) public sm_reciever;
478     mapping(address => uint) public sm_profits;
479     address public sm_dedicatedCharity;
480     uint public sm_lastProfitSync;
481     uint public sm_profitSyncLength;
482     uint public sm_afterFinishLength;
483     uint public sm_lastBalance;
484     uint internal sm_reserved;
485 
486     struct ProfitInfo {
487         address receiver; 
488         string description;
489         string url;
490     }
491 
492     constructor(uint _developerShare, uint _maxDevelopers, 
493             uint _charityShare, uint _finalShare, uint _profitSyncLength, uint _afterFinishLength) public {
494         assert(_developerShare >= 0 && _developerShare <= 1 ether);
495         assert(_charityShare >= 0 && _charityShare <= 1 ether);
496         assert(_finalShare >= 0 && _finalShare <= 1 ether);
497         sm_developerShare = _developerShare;
498         sm_maxDevelopers = _maxDevelopers;
499         sm_charityShare = _charityShare;
500         sm_finalShare = _finalShare;
501         sm_profitSyncLength = _profitSyncLength;
502         sm_afterFinishLength = _afterFinishLength;
503         sm_lastProfitSync = block.number;
504         sm_lastCharityAdded = 0;
505     }
506 
507     function getDeveloperShare() public view returns(uint) {
508         return sm_developerShare;
509     }
510 
511     function getCharityShare() public view returns(uint) {
512         return sm_charityShare;
513     }
514 
515     function getFinalShare() public view returns(uint) {
516         return sm_finalShare;
517     }
518 
519     function getLastBalance() public view returns(uint) {
520         return sm_lastBalance;
521     }
522 
523     function getLastProfitSync() public view returns(uint) {
524         return sm_lastProfitSync;
525     }
526 
527     function canUpdatePayout() public view returns(bool) {
528         return developersAdded() && (gameFinished() || block.number >= sm_profitSyncLength + sm_lastProfitSync);
529     }
530 
531     function recalculatePayoutValue() public {
532         if (canUpdatePayout()) {
533             recalculatePayoutValueInternal();
534         } else {
535             revert();
536         }
537     }
538 
539     function recalculatePayoutValueInternal() internal {
540         uint d_profit = 0;
541         uint c_profit = 0;
542         uint o_profit = 0;
543         bool dedicated = dedicatedCharitySet();
544         address dedicated_charity = sm_dedicatedCharity;
545 
546         if (gameFinished()) {
547             o_profit = getFinalProfit();
548             c_profit = availableBalance() - o_profit;
549             distribute(o_profit, sm_developers);
550             distribute(c_profit, sm_charity);
551         } else {
552             d_profit = getDeveloperProfit();
553             c_profit = getCharityProfit();
554             distribute(d_profit, sm_developers);
555 
556             if (dedicated) {
557                 distributeTo(c_profit, sm_dedicatedCharity);
558             } else {
559                 distribute(c_profit, sm_charity);
560             }
561 
562             sm_lastProfitSync = block.number;
563             sm_dedicatedCharity = address(0);
564         }
565 
566         sm_lastBalance = availableBalance();
567         emit ProfitRecalculated(gameFinished(), d_profit, c_profit, o_profit, 
568             sm_developers.length, sm_charity.length, dedicated, dedicated_charity);
569     }
570 
571     function addDeveloper(address dev, string name, string url) admin public {
572         require(!sm_reciever[dev]);
573         require(!gameFinished());
574         require(sm_developers.length < sm_maxDevelopers);
575 
576         sm_developers.push(ProfitInfo(dev, name, url));
577         sm_reciever[dev] = true;
578         emit DeveloperAdded(dev, name, url);
579     }
580 
581     function developersAdded() public view returns (bool) {
582         return sm_maxDevelopers == sm_developers.length;
583     }
584 
585     function getDeveloperName(address dev) public view returns (string) {
586         for (uint i = 0; i < sm_developers.length; i++) {
587             if (sm_developers[i].receiver == dev) return sm_developers[i].description;
588         }
589 
590         return "";
591     }
592     function getDeveloperUrl(address dev) public view returns (string) {
593         for (uint i = 0; i < sm_developers.length; i++) {
594             if (sm_developers[i].receiver == dev) return sm_developers[i].url;
595         }
596 
597         return "";
598     }
599 
600     function addCharity(address charity, string name, string url) admin public {
601         require(!sm_reciever[charity]);
602         require(!gameFinished());
603         require(canAddCharity());
604 
605         sm_charity.push(ProfitInfo(charity, name, url));
606         sm_reciever[charity] = true;
607         sm_lastCharityAdded = block.number;
608         emit CharityAdded(charity, name, url);
609     }
610 
611     function canAddCharity() public view returns (bool) {
612         return sm_lastCharityAdded + sm_profitSyncLength <= block.number;
613     }
614 
615     function lastCharityAdded() public view returns (uint) {
616         return sm_lastCharityAdded;
617     }
618 
619     function getCharityName(address charity) public view returns (string) {
620         for (uint i = 0; i < sm_charity.length; i++) {
621             if (sm_charity[i].receiver == charity) return sm_charity[i].description;
622         }
623 
624         return "";
625     }
626     function getCharityUrl(address charity) public view returns (string) {
627         for (uint i = 0; i < sm_charity.length; i++) {
628             if (sm_charity[i].receiver == charity) return sm_charity[i].url;
629         }
630 
631         return "";
632     }
633 
634 
635     function charityIndex(address charity) view internal returns(int) {
636         for (uint i = 0; i < sm_charity.length; i++) {
637             if (sm_charity[i].receiver == charity) {
638                 return int(i);
639             }
640         }
641         
642         return -1;
643     }
644 
645     function charityExists(address charity) view internal returns(bool) {
646         return charityIndex(charity) >= 0;
647     }
648 
649     function setDedicatedCharityForNextRound(address charity) admin public {
650         require(charityExists(charity));
651         require(sm_dedicatedCharity == address(0));
652         sm_dedicatedCharity = charity;
653         emit DedicatedCharitySelected(sm_dedicatedCharity);
654     }
655 
656     function dedicatedCharitySet() public view returns(bool) {
657         return sm_dedicatedCharity != address(0);
658     }
659 
660     function dedicatedCharityAddress() public view returns(address) {
661         return sm_dedicatedCharity;
662     }
663     
664     function depositToBank() public payable {
665         require(!gameFinished());
666         require(msg.value > 0);
667         sm_lastBalance += msg.value;
668         emit MoneyDeposited(msg.sender, msg.value);
669     }
670 
671     function finishedWithdrawalTime() public view returns(bool) {
672         return gameFinished() && (block.number > finishedWithdrawalBlock());
673     }
674 
675     function finishedWithdrawalBlock() public view returns(uint) {
676         if (gameFinished()) {
677             return gameFinishedBlock() + sm_afterFinishLength;
678         } else {
679             return 0;
680         }
681     }
682 
683     function getTotalPayoutValue() public view returns(uint) {
684         uint payout = 0;
685 
686         for (uint i = 0; i < sm_developers.length; i++) {
687             payout += sm_profits[sm_developers[i].receiver];
688         }
689         for (i = 0; i < sm_charity.length; i++) {
690             payout += sm_profits[sm_charity[i].receiver];
691         }
692 
693         return payout;
694     }
695 
696     function getPayoutValue(address addr) public view returns(uint) {
697         return sm_profits[addr];
698     }
699 
700     function getPayoutValueSender() public view returns(uint) {
701         return getPayoutValue(msg.sender);
702     }
703 
704     function withdrawPayout() public {
705         if (finishedWithdrawalTime() && msg.sender == getGameAdmin()) {
706             getGameAdmin().transfer(address(this).balance);
707         } else {
708             withdraw2Address(msg.sender);
709         }
710     }
711 
712     function withdraw2Address(address addr) public {
713         require(sm_profits[addr] > 0);
714 
715         uint value = sm_profits[addr];
716         sm_profits[addr] = 0;
717 
718         freeBalance(value);
719         addr.transfer(value);
720         emit MoneyWithdrawn(addr, value);
721     }
722 
723     function profitValue() public view returns(uint) {
724         if (availableBalance() >= sm_lastBalance) {
725             return availableBalance() - sm_lastBalance;
726         } else {
727             return 0;
728         }
729     }
730 
731     function getDeveloperProfit() public view returns(uint) {
732         return (profitValue() * sm_developerShare) / (1 ether);
733     }
734 
735     function getCharityProfit() public view returns(uint) {
736         return (profitValue() * sm_charityShare) / (1 ether);
737     }
738 
739     function getFinalProfit() public view returns(uint) {
740         return (availableBalance() * sm_finalShare) / (1 ether);
741     }
742 
743     function distributeTo(uint value, address recv) internal {
744         sm_profits[recv] += value;
745         reserveBalance(value);
746     }
747 
748     function distribute(uint profit, ProfitInfo[] recvs) internal {
749         if (recvs.length > 0) {
750             uint each = profit / recvs.length;
751             uint total = 0;
752             for (uint i = 0; i < recvs.length; i++) {
753                 if (i == recvs.length - 1) {
754                     distributeTo(profit - total, recvs[i].receiver);
755                 } else {
756                     distributeTo(each, recvs[i].receiver);
757                     total += each;
758                 }
759             }
760         }
761     }
762 }
763 
764 contract ISignedContractId {
765     function getId() public view returns(string);
766     function getVersion() public view returns(uint);
767     function getIdHash() public view returns(bytes32);
768     function getDataHash() public view returns(bytes32);
769     function getBytes() public view returns(bytes);
770     function sign(uint8 v, bytes32 r, bytes32 s) public;
771     function getSignature() public view returns(uint8, bytes32, bytes32);
772     function isSigned() public view returns(bool);
773 }
774 
775 contract SignedContractId is ISignedContractId {
776     string public contract_id;
777     uint public contract_version;
778     bytes public contract_signature;
779     address public info_address;
780     address public info_admin;
781     uint8 public v; 
782     bytes32 public r; 
783     bytes32 public s;
784     bool public signed;
785 
786     constructor(string id, uint version, address info, address admin) public {
787         contract_id = id;
788         contract_version = version;
789         info_address = info;
790         info_admin = admin;
791         signed = false;
792     }
793     function getId() public view returns(string) {
794         return contract_id;
795     }
796     function getVersion() public view returns(uint) {
797         return contract_version;
798     }
799     function getIdHash() public view returns(bytes32) {
800         return keccak256(abi.encodePacked(contract_id));
801     }
802     function getBytes() public view returns(bytes) {
803         return abi.encodePacked(contract_id);
804     }
805 
806 
807     function getDataHash() public view returns(bytes32) {
808         return keccak256(abi.encodePacked(getIdHash(), getVersion(), info_address, address(this)));
809     }
810 
811     function sign(uint8 v_, bytes32 r_, bytes32 s_) public {
812         require(!signed);
813         bytes32 hsh = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", getDataHash()));
814         require(info_admin == ecrecover(hsh, v_, r_, s_));
815         v = v_;
816         r = r_;
817         s = s_;
818         signed = true;
819     }
820 
821     function getSignature() public view returns(uint8, bytes32, bytes32) {
822         return (v, r, s);
823     }
824 
825     function isSigned() public view returns(bool) {
826         return signed;
827     }
828 }
829 
830 contract IGameLengthLibrary is ICommonGame {
831     function getMinGameLength() public view returns(uint);
832     function getMaxGameLength() public view returns(uint);
833     function getMinGameAddon() public view returns(uint);
834     function getMaxGameAddon() public view returns(uint);
835 
836     function calcGameLength(uint number) public view returns (uint);
837     function calcGameAddon(uint number) public view returns (uint);
838 
839     event MinGameLengthAltered(uint newValue);
840     event MaxGameLengthAltered(uint newValue);
841     event AddonAltered(uint newValue);
842 
843     function alterMaxGameLength(uint _maxGameLength) public;
844     function alterMinGameLength(uint _minGameLength) public;
845     function alterAddon(uint _addon) public;
846 }
847 
848 contract LinearGameLibrary is IGameLengthLibrary {
849     uint public minLength;
850     uint public maxLength;
851     uint public addon;
852 
853     constructor(uint _minLength, uint _maxLength, uint _addon) public {
854         assert(_minLength <= _maxLength);
855 
856         minLength = _minLength;
857         maxLength = _maxLength;
858         addon = _addon;
859     }
860 
861     function calcGameLength(uint number) public view returns (uint) {
862         return minLength + ((maxLength - minLength) * ((number % totalVariants()) + 1)) / totalVariants();
863     }
864     
865     function calcGameAddon(uint) public view returns (uint) {
866         return addon;
867     }
868 
869     function getMinGameLength() public view returns(uint) {
870         return minLength;
871     }
872 
873     function getMaxGameLength() public view returns(uint) {
874         return maxLength;
875     }
876 
877     function getMinGameAddon() public view returns(uint) {
878         return addon;
879     }
880 
881     function getMaxGameAddon() public view returns(uint) {
882         return addon;
883     }
884      
885     function alterMaxGameLength(uint _maxGameLength) public admin {
886         require(_maxGameLength > 0, "Max game length should be not zero");
887         require(_maxGameLength >= minLength, "Max game length should be not more than min length");
888         maxLength = _maxGameLength;
889         emit MaxGameLengthAltered(maxLength);
890     }
891 
892     function alterMinGameLength(uint _minGameLength) public admin {
893         require(_minGameLength > 0, "Min game length should be not zero");
894         require(_minGameLength <= maxLength, "Min game length should be less than max length");
895         minLength = _minGameLength;
896         emit MinGameLengthAltered(minLength);
897     }
898 
899     function alterAddon(uint _addon) public admin {
900         addon = _addon;
901         emit AddonAltered(addon);
902     }
903 }
904  
905 contract IGameManager {
906     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal;
907     function betInGameInternal(uint gameId, uint bet) internal;
908 
909     function withdrawPrize(uint gameId) public;
910     function withdrawPrizeInternal(uint gameId, uint additional) internal;
911 
912     function gameExists(uint gameId) public view returns (bool);
913     function finishedGame(uint gameId) public view returns(bool);
914     function getWinner(uint gameId) public view returns(address);
915     function getBet(uint gameId, address better) public view returns(uint);
916     function payedOut(uint gameId) public view returns(bool);
917     function prize(uint gameId) public view returns(uint);
918     function endsIn(uint gameId) public view returns(uint);
919     function lastBetBlock(uint gameId) public view returns(uint);
920 
921     function addonEndsIn(uint gameId) public view returns(uint);
922     function totalBets(uint gameId) public view returns(uint);
923     function gameProfited(uint gameId) public view returns(bool);
924 
925     event GameStarted(uint indexed gameId, address indexed starter, uint blockNumber, uint finishBlock, uint prize);
926     event GameBet(uint indexed gameId, address indexed bidder, address indexed winner, uint highestBet, uint finishBlock, uint value);
927     event GamePrizeTaken(uint indexed gameId, address indexed winner);
928 }
929 
930 contract GameManager is IBalanceInfo, IGameManager {
931     mapping (uint => GameInfo) games;
932     mapping (uint => mapping (address => uint)) bets;
933 
934     struct GameInfo {
935         address highestBidder; // the person who made the highest bet in this game
936         address starter; // the person who started this game
937         uint blockFinish; // the block when the game will be finished
938         uint prize; // the prize, that will be awarded to the winner
939         uint totalBets; // the amount of total bets to this game
940         bool payedOut; // true, if the user has taken back his deposit
941         uint lastBetBlock;
942         uint addOn;
943     }
944 
945     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal {
946         require(!gameExists(gameId));
947         require(prize > 0);
948         require(length > 0);
949         games[gameId].starter = msg.sender;
950         games[gameId].prize = prize;
951         reserveBalance(prize);
952         games[gameId].blockFinish = block.number + length - 1;
953         games[gameId].addOn = addOn;
954         emit GameStarted(gameId, msg.sender, block.number, games[gameId].blockFinish, prize);
955     }
956 
957     function betInGameInternal(uint gameId, uint bet) internal {
958         require(bet > 0, "Bet should be not zero");
959         require(gameExists(gameId), "No such game");
960         require(!finishedGame(gameId), "Game is finished");
961         uint newBet = bets[gameId][msg.sender] + bet;
962         
963         if (newBet > bets[gameId][games[gameId].highestBidder]) {
964             games[gameId].highestBidder = msg.sender;
965             games[gameId].lastBetBlock = block.number;
966         } 
967 
968         bets[gameId][msg.sender] = newBet;
969         games[gameId].totalBets += bet;
970         emit GameBet(gameId, msg.sender, games[gameId].highestBidder, bets[gameId][games[gameId].highestBidder], addonEndsIn(gameId), newBet);
971     }
972 
973     function withdrawPrize(uint gameId) public {
974         withdrawPrizeInternal(gameId, 0);
975     }
976 
977     function withdrawPrizeInternal(uint gameId, uint additional) internal {
978         require(finishedGame(gameId), "Game not finished");
979         require(msg.sender == games[gameId].highestBidder, "You are not the winner");
980         require(!games[gameId].payedOut, "Game already payed");
981         games[gameId].payedOut = true;
982         freeBalance(games[gameId].prize);
983         msg.sender.transfer(games[gameId].prize + additional);
984         emit GamePrizeTaken(gameId, msg.sender);
985     }
986 
987     function gameExists(uint gameId) public view returns (bool) {
988         return games[gameId].blockFinish != 0;
989     }
990 
991     function getWinner(uint gameId) public view returns(address) {
992         return games[gameId].highestBidder;
993     }
994 
995     function finishedGame(uint gameId) public view returns(bool) {
996         if (!gameExists(gameId)) 
997             return false;
998         return addonEndsIn(gameId) < block.number;
999     }
1000 
1001     function payedOut(uint gameId) public view returns(bool) {
1002         return games[gameId].payedOut;
1003     }
1004 
1005     function prize(uint gameId) public view returns(uint) {
1006         return games[gameId].prize;
1007     }
1008 
1009     function lastBetBlock(uint gameId) public view returns(uint) {
1010         return games[gameId].lastBetBlock;
1011     }
1012 
1013     function getBet(uint gameId, address better) public view returns(uint) {
1014         return bets[gameId][better];
1015     }
1016 
1017     function endsIn(uint gameId) public view returns(uint) {
1018         return games[gameId].blockFinish;
1019     }
1020 
1021     function addonEndsIn(uint gameId) public view returns(uint) {
1022         uint addonB = games[gameId].lastBetBlock + games[gameId].addOn;
1023         if (addonB >= games[gameId].blockFinish) {
1024             return addonB;
1025         } else {
1026             return games[gameId].blockFinish;
1027         }
1028     }
1029 
1030     function totalBets(uint gameId) public view returns(uint) {
1031         return games[gameId].totalBets;
1032     }
1033 
1034     function gameProfited(uint gameId) public view returns(bool) {
1035         return games[gameId].totalBets >= games[gameId].prize;
1036     }
1037 }
1038 contract StartGame is IStartGame, ICommonGame, IPrizeLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IBlockRandomLibrary {
1039     bool internal previousCalcRegular;
1040 
1041     constructor(uint _repeatBlock, uint _addonBlock) public
1042     {
1043         assert(_repeatBlock <= 250);
1044         repeatBlock = _repeatBlock;
1045         addonBlock = _addonBlock;
1046         calcNextGameId();
1047         defaultId = nextGameId;
1048     }
1049 
1050     function startOwnFixed(uint gameId, uint length, uint addon, uint prize) public admin payable {
1051         require(msg.value > 0);
1052         require(!gameExists(gameId));
1053         require(gameId % 2 == 1);
1054         require(length >= getMinGameLength());
1055         require(prize >= getMinPrize() && prize <= getWholePrize());
1056 
1057         updateRandom();
1058         startGameInternal(gameId, length, addon, prize);
1059         profitedBet(gameId);
1060     }
1061 
1062     function randomValueWithMinPrize() internal view returns(uint) {
1063         if (!startOnlyMinPrizes() && isRandomAvailable()) {
1064             return getRandomValue();
1065         }
1066 
1067         return 0;
1068     }
1069 
1070     function startGameDetermine(uint gameId) internal {
1071         uint random = randomValueWithMinPrize();
1072         startGameInternal(gameId, calcGameLength(random), calcGameAddon(random), calculatePrize(random, getMinPrize(), getMaxPrize()));
1073     }
1074 
1075     function betInGame(uint gameId) public payable {
1076         require(msg.value > 0, "Bet should be not zero");
1077         updateRandom();
1078 
1079         if (!gameExists(gameId)) {
1080             require(canStartGame(), "Game cannot be started");
1081             require(startGameId() == gameId, "No such scheduled game");
1082             startGameDetermine(gameId);
1083             updateDefaultGame(gameId);
1084             calcNextGameId();
1085         }
1086 
1087         profitedBet(gameId);
1088     }
1089 
1090     function profitedBet(uint gameId) internal {
1091         bool profited = gameProfited(gameId);
1092         betInGameInternal(gameId, msg.value);
1093         if (profited != gameProfited(gameId)) {
1094             if (startProfitedGamesAllowed() && (gameId % 2 == 0 || autoCreationAfterOwnAllowed())) {
1095                 createFastGamesCount++;
1096                 if (!isRandomAvailable() && previousCalcRegular && createFastGamesCount == 1) {
1097                     calcNextGameId();
1098                 }
1099                 emit FastGamesChanged(createFastGamesCount);
1100             }
1101             profitedCount++;
1102             emit GameProfitedEvent(gameId);
1103         }
1104     }
1105         
1106     uint public repeatBlock;
1107     uint public addonBlock;
1108 
1109     function getRepeatBlock() public view returns(uint) {
1110         return repeatBlock;
1111     }
1112     function getAddonBlock() public view returns(uint) {
1113         return addonBlock;
1114     }
1115 
1116     function alterRepeatBlock(uint _repeatBlock) admin public {
1117         assert(_repeatBlock < 250);
1118         repeatBlock = _repeatBlock;
1119         emit RepeatBlockAltered(repeatBlock);
1120     }
1121 
1122     function alterAddonBlock(uint _addonBlock) admin public {
1123         addonBlock = _addonBlock;
1124         emit RepeatAddonBlockAltered(addonBlock);
1125     }
1126 
1127     uint internal nextGameId;
1128     uint internal defaultId;
1129     uint internal profitedCount;
1130     uint internal createFastGamesCount;
1131 
1132     function getProfitedCount() public view returns(uint) {
1133         return profitedCount;
1134     }
1135 
1136     function getCreateFastGamesCount() public view returns(uint) {
1137         return createFastGamesCount;
1138     }
1139 
1140     function setCreateFastGamesCount(uint count) public admin {
1141         createFastGamesCount = count;
1142         emit FastGamesChanged(createFastGamesCount);
1143     }
1144 
1145     function recalcNextGameId() public admin {
1146         if (!isRandomAvailable()) {
1147             calcNextGameId();
1148         } else {
1149             revert("You cannot recalculate, unless the prize has expired");
1150         }
1151     }
1152 
1153     function calcNextGameId() internal {
1154         uint ngi;
1155 
1156         previousCalcRegular = createFastGamesCount == 0;
1157 
1158         if (createFastGamesCount > 0) {
1159             ngi = block.number + addonBlock;
1160             createFastGamesCount--;
1161         } else {
1162             ngi = block.number + (repeatBlock - block.number % repeatBlock);
1163         }
1164 
1165         if (ngi % 2 == 1) {
1166             ngi++;
1167         }
1168 
1169         nextGameId = ngi;
1170         setRandomBlock(nextGameId);
1171         updateDefaultGame(nextGameId);
1172         emit NextGameIdCalculated(nextGameId);
1173     }
1174 
1175     function canStartGame() public view returns(bool) {
1176         return randomBlockPassed() && creationAllowed();
1177     }
1178 
1179     function startGameId() public view returns(uint) {
1180         return nextGameId;
1181     }
1182 
1183     function startPrizeValue() public view returns(uint) {
1184         return calculatePrize(randomValueWithMinPrize(), getMinPrize(), getMaxPrize());
1185     }
1186 
1187     function startGameLength() public view returns(uint) {
1188         return calcGameLength(randomValueWithMinPrize());
1189     }
1190 
1191     function startGameAddon() public view returns(uint) {
1192         return calcGameAddon(randomValueWithMinPrize());
1193     }
1194 
1195     function getStartGameStatus() public view returns(bool, uint, uint, uint, uint) {
1196         uint random = randomValueWithMinPrize();
1197         return (
1198             canStartGame(), 
1199             nextGameId, 
1200             calculatePrize(random, getMinPrize(), getMaxPrize()),
1201             calcGameLength(random),
1202             calcGameAddon(random));
1203     }
1204 
1205     function updateDefaultGame(uint gameId) internal {
1206         if (finishedGame(defaultId) || !gameExists(defaultId)) {
1207             defaultId = gameId;
1208             emit DefaultGameUpdated(defaultId);
1209         } 
1210     }
1211 
1212     function defaultGameId() public view returns(uint) {
1213         if (!finishedGame(defaultId) && gameExists(defaultId)) return defaultId;
1214         if (canStartGame()) return startGameId();
1215         return 0;
1216     }
1217 
1218     function defaultGameAvailable() public view returns(bool) {
1219         return !finishedGame(defaultId) && gameExists(defaultId) || canStartGame();
1220     }
1221 
1222     mapping (address => uint) transferGames;
1223 
1224     function getTransferProfitedGame(address participant) public view returns(uint) {
1225         if (finishedGame(transferGames[participant]) && getWinner(transferGames[participant]) == participant) {
1226             return transferGames[participant];
1227         }
1228 
1229         return 0;
1230     }
1231 
1232     function getTransferProfitedGame() internal view returns(uint) {
1233         return getTransferProfitedGame(msg.sender);
1234     }
1235 
1236     function processTransfer() internal {
1237         uint tpg = getTransferProfitedGame();
1238         if (tpg == 0) {
1239             if (!finishedGame(defaultId) && gameExists(defaultId)) {
1240                 betInGame(defaultId);
1241             } else {
1242                 betInGame(startGameId());
1243             }
1244             transferGames[msg.sender] = defaultId;
1245         } else {
1246             transferGames[msg.sender] = 0;
1247             withdrawPrizeInternal(tpg, msg.value);
1248         } 
1249 
1250         emit TransferBet(msg.sender, msg.value);
1251     }
1252 
1253     function processTransferInteraction() internal {
1254         if (transferInteractionsAllowed()) {
1255             processTransfer();
1256         } else {
1257             revert();
1258         }
1259     }
1260 }
1261 
1262 contract ICharbetto is IMoneyContract, IStartGame, IBalanceSharePrizeContract,
1263         IBlockRandomLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IFunctionPrize, IPrizeLibrary {
1264     function recalculatePayoutValueAdmin() public;
1265     function stopGameFast() public;
1266 }
1267 
1268 contract Charbetto is CommonGame, BlockRandomLibrary, BalanceInfo, PrizeLibrary, EllipticPrize16x, 
1269         MoneyContract, StartGame, GameManager, LinearGameLibrary, BalanceSharePrizeContract {
1270     constructor(address _admin) public
1271         CommonGame(_admin) 
1272         BlockRandomLibrary(250)
1273         BalanceInfo()
1274         PrizeLibrary()
1275         EllipticPrize16x()
1276         MoneyContract(
1277             10 finney /*1 percent*/, 
1278             5, /*5 developers at maximum*/
1279             100 finney /*10 percent*/, 
1280             100 finney /*10 percent*/, 
1281             20000, 200000)
1282         StartGame(5, 3)  
1283         GameManager()
1284         LinearGameLibrary(50, 1000, 3)
1285         BalanceSharePrizeContract(10 finney, 100 finney)
1286     {
1287         totalV = 1000;
1288         minLength = 20;
1289         maxLength = 30;
1290         transferInteractions = true;
1291     }
1292     function betInGame(uint gameId) public payable {
1293         bool exists = gameExists(gameId);
1294 
1295         if (!exists) {
1296             reserveBalance(msg.value);
1297         }
1298 
1299         super.betInGame(gameId);
1300 
1301         if (!exists) {
1302             freeBalance(msg.value);
1303         }
1304     }
1305 
1306     function isItReallyCharbetto() public pure returns (bool) {
1307         return true;
1308     }
1309 
1310     function () payable public {
1311         processTransferInteraction();
1312     }
1313 }
1314 
1315 contract ISignedCharbetto is ISignedContractId, ICharbetto {}
1316 
1317 contract SignedCharbetto is Charbetto, SignedContractId {
1318     constructor(address admin_, uint version_, address infoContract_, address infoAdminAddress_) public 
1319         Charbetto(admin_) 
1320         SignedContractId("charbetto", version_, infoContract_, infoAdminAddress_)
1321     {} 
1322 
1323     function recalculatePayoutValueAdmin() admin public {
1324         revert();
1325     }
1326 
1327     function stopGameFast() admin public {
1328         revert();
1329     }
1330 
1331     function () payable public {
1332         processTransferInteraction();
1333     }
1334 }