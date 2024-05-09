1 pragma solidity 0.4.24;
2 
3 contract IAdminContract {
4     // returns the administrator of the game
5     function getGameAdmin() public view returns (address);
6 
7     modifier admin() {
8         require(msg.sender == getGameAdmin());
9         _;
10     }
11 }
12 
13 
14 contract IBlockRandomLibrary {
15     function setRandomBlock(uint blockNumber) internal;
16     function updateRandom() public;
17     function isRandomAvailable() public view returns(bool);
18     function randomBlockPassed() public view returns(bool); 
19     function getRandomValue() public view returns(uint);
20     
21     function canStoreRandom() public view returns(bool);
22     function isRandomStored() public view returns(bool);
23 }
24 
25 contract IStartGame {
26     function startOwnFixed(uint gameId, uint length, uint addon, uint prize) public payable;
27     function betInGame(uint gameId) public payable;
28 
29     function recalcNextGameId() public;
30 
31     function getProfitedCount() public view returns(uint);
32     function getCreateFastGamesCount() public view returns(uint);
33     function setCreateFastGamesCount(uint count) public;
34 
35 
36     function canStartGame() public view returns(bool);
37     function startGameId() public view returns(uint);
38     function startPrizeValue() public view returns(uint);
39     function startGameLength() public view returns(uint);
40     function startGameAddon() public view returns(uint);
41     
42     function getStartGameStatus() public view returns(bool, uint, uint, uint, uint);
43 
44     function getTransferProfitedGame(address participant) public view returns(uint);
45 
46     function defaultGameAvailable() public view returns(bool);
47     function defaultGameId() public view returns(uint);
48     function getRepeatBlock() public view returns(uint);
49     function getAddonBlock() public view returns(uint);
50 
51     event RepeatBlockAltered(uint newValue);
52     event RepeatAddonBlockAltered(uint newValue);
53     event NextGameIdCalculated(uint gameId);
54     event DefaultGameUpdated(uint gameId);
55     event TransferBet(address better, uint value);
56     event GameProfitedEvent(uint gameId);
57     event FastGamesChanged(uint faseGamesCreate);
58 
59     function alterRepeatBlock(uint _repeatBlock) public;
60     function alterAddonBlock(uint _addonBlock) public;
61 }
62 
63 
64 contract ICommonGame is IAdminContract {
65     // true if the game is finishing
66     function gameFinishing() public view returns(bool);
67 
68     // stops the game
69     function stopGame() public;
70 
71     function totalVariants() public view returns(uint);
72     function alterTotalVariants(uint _newVariants) public;
73 
74     function autoCreationAllowed() public view returns(bool);
75     function setAutoCreation(bool allowed) public;
76 
77     function autoCreationAfterOwnAllowed() public view returns(bool);
78     function setAutoCreationAfterOwn(bool allowed) public;
79 
80     function creationAllowed() public view returns(bool) {
81         return autoCreationAllowed() && !gameFinishing();
82     }
83 
84     function transferInteractionsAllowed() public view returns(bool); 
85     function setTransferInteractions(bool allowed) public; 
86 
87     function startOnlyMinPrizes() public view returns (bool);
88     function setStartOnlyMinPrizes(bool minPrizes) public;
89  
90     function startProfitedGamesAllowed() public view returns (bool);
91     function setStartProfitedGamesAllowed(bool games) public;
92 
93     // returns true, when the experiment with this thing is finished
94     // so one can give back all of the money
95     function gameFinished() public view returns(bool);
96 
97     // the block when all of this experiment is finished
98     function gameFinishedBlock() public view returns(uint);
99 
100     event GameStopInitiated(uint finishingBlock);
101     event TransferInteractionsChanged(bool newValue);
102     event StartOnlyMinPrizesChanged(bool newValue);
103     event StartProfitedGamesAllowedChanged(bool newValue);
104 
105     event AutoCreationChanged(bool newValue);
106     event AutoCreationAfterOwnChanged(bool newValue);
107     event TotalVariantsChanged(uint newTotalVariants);
108 }
109 
110 contract IFunctionPrize {
111     function calcPrizeX(uint x, uint maxX, uint maxPrize)  public view returns (uint);
112     function prizeFunctionName() public view returns (string);
113 }
114 
115 
116 contract IPrizeLibrary is ICommonGame {
117     function calculatePrize(uint number, uint minPrize, uint maxPrize) public view returns(uint);
118     function prizeName() public view returns (string);    
119 }
120 
121 contract IBalanceSharePrizeContract {
122     function getMaxPrizeShare() public view returns (uint);
123     function alterPrizeShare(uint _maxPrizeShare) public;
124     event MaxPrizeShareAltered(uint share);
125 }
126 
127 contract IMinMaxPrize {
128     function getMaxPrize() public view returns(uint);
129     function getWholePrize() public view returns(uint);
130     function getMinPrize() public view returns(uint);
131     function alterMinPrize(uint _minPrize) public;
132     function alterMaxPrize(uint _maxPrize) public;
133 
134     event MinPrizeAltered(uint prize);
135     event MaxPrizeAltered(uint prize);
136 }
137 
138 contract IBalanceInfo {
139     function totalBalance() public view returns(uint);
140 
141     function availableBalance() public view returns(uint);
142 
143     // called when one needs to give some sum to some party. Strictly internal!
144     function reserveBalance(uint value) internal returns(uint);
145 
146     // the amount of reserved balance
147     function reservedBalance() public view returns(uint);
148 
149     // called during the withdrawal of money from contract. Strictly internal!
150     function freeBalance(uint value) internal returns(uint);
151 
152     event BalanceReserved(uint value, uint total);
153     event BalanceFreed(uint value, uint total);
154 }
155 
156 
157 contract BlockRandomLibrary is IBlockRandomLibrary {
158     uint public randomBlock;
159     uint public randomValue;
160     uint public maxBlocks;
161 
162     constructor(uint _maxBlocks) public 
163         IBlockRandomLibrary()
164     {
165         assert(_maxBlocks <= 250);
166         randomValue = 0;
167         randomBlock = 0;
168         maxBlocks = _maxBlocks;
169     }
170 
171     function setRandomBlock(uint blockNumber) internal {
172         randomBlock = blockNumber;
173         if (canStoreRandom()) {
174             randomValue = uint(blockhash(randomBlock));
175             emit RandomValueCalculated(randomValue, randomBlock);
176         } else {
177             randomValue = 0;
178         }
179     }
180 
181     event RandomValueCalculated(uint value, uint randomBlock);
182     
183     function updateRandom() public {
184         if (!isRandomStored() && canStoreRandom()) {
185             randomValue = uint(blockhash(randomBlock));
186             emit RandomValueCalculated(randomValue, randomBlock);
187         }
188     }
189 
190     function isRandomAvailable() public view returns(bool) {
191         return isRandomStored() || canStoreRandom();
192     }
193 
194     function getRandomValue() public view returns(uint) {
195         if (isRandomStored()) {
196             return randomValue;
197         } else if (canStoreRandom()) {
198             return uint(blockhash(randomBlock));
199         } 
200 
201         return 0;
202     }
203 
204     function canStoreRandom() public view returns(bool) {
205         return !blockExpired() && randomBlockPassed();
206     }
207     function randomBlockPassed() public view returns(bool) {
208         return block.number > randomBlock;
209     }
210     function blockExpired() public view returns(bool) {
211         return block.number > randomBlock + maxBlocks;
212     }
213     function isRandomStored() public view returns (bool) {
214         return randomValue != 0;
215     }
216 }
217 
218 contract EllipticPrize16x is IFunctionPrize {
219     function calcModulo(uint fMax) internal pure returns (uint) {
220         uint sqr = fMax * fMax * fMax * fMax;
221         return sqr * sqr * sqr * sqr;
222     }
223 
224     function calcPrizeX(uint x, uint fMax, uint maxPrize) public view returns (uint) {
225         uint xsq = (x + 1) * (x + 1);
226         uint xq = xsq * xsq;
227         uint xspt = xq * xq;
228         return (xspt * xspt * maxPrize) / calcModulo(fMax);
229     }
230 
231     function prizeFunctionName() public view returns (string) {
232         return "E16x";
233     }
234 } 
235 
236 
237 contract BalanceSharePrizeContract is IBalanceSharePrizeContract, ICommonGame, IMinMaxPrize, IBalanceInfo {
238     uint public minPrize;
239     uint public maxPrizeShare;
240 
241     constructor(uint _minPrize, uint _maxPrizeShare) public {
242         assert(_minPrize >= 0);
243         assert(_maxPrizeShare > 0 && _maxPrizeShare <= 1 ether);
244 
245         minPrize = _minPrize;
246         maxPrizeShare = _maxPrizeShare;
247     }
248 
249     function getMaxPrizeShare() public view returns (uint) {
250         return maxPrizeShare;
251     }
252 
253     function alterPrizeShare(uint _maxPrizeShare) admin public {
254         require(_maxPrizeShare > 0 && _maxPrizeShare <= 1 ether, "Prize share should be between 0 and 100%");
255         maxPrizeShare = _maxPrizeShare;
256         emit MaxPrizeShareAltered(maxPrizeShare);
257     }
258 
259     function alterMinPrize(uint _minPrize) admin public {
260         minPrize = _minPrize;
261         emit MinPrizeAltered(minPrize);
262     }
263 
264     function alterMaxPrize(uint) admin public {
265     }
266 
267     function getMaxPrize() public view returns(uint) {
268         return (availableBalance() * maxPrizeShare) / (1 ether);        
269     }
270 
271     function getWholePrize() public view returns(uint) {
272         return availableBalance();
273     }
274 
275     function getMinPrize() public view returns(uint) {
276         return minPrize;
277     }
278 }
279 
280 
281 contract PrizeLibrary is IPrizeLibrary, IFunctionPrize {
282     constructor() public {}
283 
284     function prizeName() public view returns (string) {
285         return prizeFunctionName();
286     }
287 
288     function calculatePrize(uint number, uint minPrize, uint maxPrize) public view returns(uint) {
289         uint prize = calcPrizeX(number % totalVariants(), totalVariants(), maxPrize);
290         uint minP = minPrize;
291         uint maxP = maxPrize;
292 
293         // a weird situation, but happens when we run out of balance
294         if (maxP < minP) {
295             return maxP;
296         } else if (prize < minP) {
297             return minP;
298         } else {
299             return prize;
300         }
301     }
302 }
303 
304 contract CommonGame is ICommonGame {
305     address public gameAdmin;
306     uint public blocks2Finish;
307     uint internal totalV;
308     uint internal sm_reserved;
309     bool internal finishing;
310     uint internal finishingBlock;
311     bool internal autoCreation;
312     bool internal autoCreationAfterOwn;
313     bool internal transferInteractions;
314     bool internal startMinPrizes;
315     bool internal profitedGames;
316 
317 
318     constructor(address _gameAdmin) public {
319         assert(_gameAdmin != 0);
320         
321         gameAdmin = _gameAdmin;
322         blocks2Finish = 50000;
323         totalV = 1000;
324         autoCreation = true;
325         autoCreationAfterOwn = true;
326         transferInteractions = false;
327         startMinPrizes = false;
328         profitedGames = false;
329     }
330 
331     function getGameAdmin() public view returns (address) {
332         return gameAdmin;
333     }
334 
335     function gameFinished() public view returns(bool) {
336         return gameFinishing() && gameFinishedBlock() < block.number;
337     }
338 
339     // true if the game is finishing
340     function gameFinishing() public view returns(bool) {
341         return finishing;
342     }
343 
344     // stops the game
345     function stopGame() admin public {
346         stopGameInternal(blocks2Finish);
347     }
348 
349     function totalVariants() public view returns(uint) {
350         return totalV;
351     }
352 
353     function alterTotalVariants(uint _newVariants) admin public {
354         totalV = _newVariants;
355         emit TotalVariantsChanged(totalV);
356     }
357 
358     function stopGameInternal(uint blocks2add) internal {
359         require(!finishing);
360 
361         finishing = true;
362         // about one month for finishing
363         finishingBlock = block.number + blocks2add;
364         emit GameStopInitiated(finishingBlock);
365     }
366 
367 
368     function gameFinishedBlock() public view returns(uint) {
369         return finishingBlock;
370     }
371 
372     function autoCreationAllowed() public view returns(bool) {
373         return autoCreation;
374     }
375 
376     function setAutoCreation(bool allowed) public admin {
377         autoCreation = allowed;
378         emit AutoCreationChanged(autoCreation);
379     }
380 
381     function autoCreationAfterOwnAllowed() public view returns(bool) {
382         return autoCreationAfterOwn;
383     }
384 
385     function setAutoCreationAfterOwn(bool allowed) public admin {
386         autoCreationAfterOwn = allowed;
387         emit AutoCreationAfterOwnChanged(autoCreation);
388     }
389 
390 
391     function transferInteractionsAllowed() public view returns(bool) {
392         return transferInteractions;
393     }
394     function setTransferInteractions(bool allowed) public admin {
395         transferInteractions = allowed;
396         emit TransferInteractionsChanged(transferInteractions);
397     }
398 
399     function startOnlyMinPrizes() public view returns (bool) {
400         return startMinPrizes;
401     }
402 
403     function setStartOnlyMinPrizes(bool minPrizes) public admin {
404         startMinPrizes = minPrizes;
405         emit StartOnlyMinPrizesChanged(startMinPrizes);
406     }
407 
408     function startProfitedGamesAllowed() public view returns (bool) {
409         return profitedGames;
410     }
411 
412     function setStartProfitedGamesAllowed(bool games) public admin {
413         profitedGames = games;
414         emit StartProfitedGamesAllowedChanged(profitedGames);
415     }
416 }
417 
418 contract BalanceInfo is IBalanceInfo {
419     uint internal sm_reserved;
420 
421     function totalBalance() public view returns(uint) {
422         return address(this).balance;
423     } 
424 
425     function reservedBalance() public view returns(uint) {
426         return sm_reserved;
427     }
428 
429     function availableBalance() public view returns(uint) {
430         // always positive ok
431         if (totalBalance() >= sm_reserved) {
432             return totalBalance() - sm_reserved;
433         } else {
434             return 0;
435         }
436     } 
437 
438     function reserveBalance(uint value) internal returns (uint) {
439         uint balance = availableBalance();
440 
441         // there is not enough ether to reserve for this contract
442         if (value > balance) {
443             sm_reserved += balance;
444             emit BalanceReserved(balance, sm_reserved);
445             return balance;
446         } else {
447             sm_reserved += value;
448             emit BalanceReserved(value, sm_reserved);
449             return value;
450         }
451     }
452 
453     function freeBalance(uint value) internal returns(uint) {
454         uint toReturn;
455 
456         if (value > sm_reserved) {
457             toReturn = sm_reserved;
458             sm_reserved = 0;
459         } else {
460             // always positive ok
461             toReturn = value;
462             sm_reserved -= value;
463         }
464 
465         emit BalanceFreed(toReturn, sm_reserved);
466         return toReturn;
467     }
468 }
469 
470 
471 contract IMoneyContract is ICommonGame, IBalanceInfo {
472     function profitValue() public view returns(uint);
473     function getDeveloperProfit() public view returns(uint);
474     function getCharityProfit() public view returns(uint);
475     function getFinalProfit() public view returns(uint);
476 
477     function getLastBalance() public view returns(uint);
478     function getLastProfitSync() public view returns(uint);
479 
480     function getDeveloperShare() public view returns(uint);
481     function getCharityShare() public view returns(uint);
482     function getFinalShare() public view returns(uint);
483 
484     // well anyone can deposit to the contract for the experiment
485     function depositToBank() public payable;
486 
487     function canUpdatePayout() public view returns(bool);
488     function recalculatePayoutValue() public;
489     function withdrawPayout() public;
490     function withdraw2Address(address addr) public;
491     function finishedWithdrawalTime() public view returns(bool);
492     function finishedWithdrawalBlock() public view returns(uint);
493 
494     function getTotalPayoutValue() public view returns(uint);
495     function getPayoutValue(address addr) public view returns(uint);
496     function getPayoutValueSender() public view returns(uint);
497 
498     // adds the developer to the contract
499     function addDeveloper(address dev, string name, string url) public;
500     function getDeveloperName(address dev) public view returns (string);
501     function getDeveloperUrl(address dev) public view returns (string);
502     function developersAdded() public view returns (bool);
503 
504     // adds the charity to the contract
505     function addCharity(address charity, string name, string url) public;
506     function getCharityName(address charity) public view returns (string);
507     function getCharityUrl(address charity) public view returns (string);
508 
509     function dedicatedCharitySet() public view returns(bool);
510     function setDedicatedCharityForNextRound(address charity) public;
511     function dedicatedCharityAddress() public view returns(address);
512 
513     event MoneyDeposited(address indexed sender, uint value);
514     event MoneyWithdrawn(address indexed reciever, uint value);
515 
516     event ProfitRecalculated(bool gameFinish, uint developerProfit, uint charityProfit, uint finalProfit, 
517     uint developerCount, uint charityCount, bool dedicated, address dedicatedCharity);
518 
519     event CharityAdded(address charity, string name, string url);
520     event DedicatedCharitySelected(address charity);
521 
522     event DeveloperAdded(address developer, string name, string url);
523 }
524 
525 contract MoneyContract is IMoneyContract {
526     uint public sm_developerShare; // the amount of profit, that is given to the developers
527     uint public sm_charityShare; // the amount of profit, that is given to the charity
528     uint public sm_finalShare;
529 
530     ProfitInfo[] public sm_developers; // the developers, that recieve the share
531     uint public sm_maxDevelopers;
532     
533     ProfitInfo[] public sm_charity; // the charity that recieve the share
534     mapping(address => bool) public sm_reciever; // the values that can be withdrawn
535     mapping(address => uint) public sm_profits; // the values that can be withdrawn
536     address public sm_dedicatedCharity; // the charity that received all the profit
537 
538 
539     uint public sm_lastProfitSync; // last time the profits were calculated
540     uint public sm_profitSyncLength; // the length of the synchronization period for profits
541     uint public sm_afterFinishLength; // the length of period, when the parties can withdraw their money
542     uint public sm_lastBalance; // the last balance 
543     uint internal sm_reserved; // the total money reserved for prizes and payouts
544 
545     struct ProfitInfo {
546         address receiver; 
547         string description;
548         string url;
549     }
550 
551     constructor(uint _developerShare, uint _maxDevelopers, 
552             uint _charityShare, uint _finalShare, uint _profitSyncLength, uint _afterFinishLength) public {
553         assert(_developerShare >= 0 && _developerShare <= 1 ether);
554         assert(_charityShare >= 0 && _charityShare <= 1 ether);
555         assert(_finalShare >= 0 && _finalShare <= 1 ether);
556         // assert(_profitSyncLength > 0 && _profitSyncLength <= 200000);
557         // assert(_afterFinishLength >= 200000);
558 
559         sm_developerShare = _developerShare;
560         sm_maxDevelopers = _maxDevelopers;
561         sm_charityShare = _charityShare;
562         sm_finalShare = _finalShare;
563         sm_profitSyncLength = _profitSyncLength; // 180000 is actually about a month
564         sm_afterFinishLength = _afterFinishLength;
565         sm_lastProfitSync = block.number;
566     }
567 
568     function getDeveloperShare() public view returns(uint) {
569         return sm_developerShare;
570     }
571 
572     function getCharityShare() public view returns(uint) {
573         return sm_charityShare;
574     }
575 
576     function getFinalShare() public view returns(uint) {
577         return sm_finalShare;
578     }
579 
580     function getLastBalance() public view returns(uint) {
581         return sm_lastBalance;
582     }
583 
584     function getLastProfitSync() public view returns(uint) {
585         return sm_lastProfitSync;
586     }
587 
588     function canUpdatePayout() public view returns(bool) {
589         return developersAdded() && (gameFinished() || block.number >= sm_profitSyncLength + sm_lastProfitSync);
590     }
591 
592     function recalculatePayoutValue() public {
593         if (canUpdatePayout()) {
594             recalculatePayoutValueInternal();
595         } else {
596             revert();
597         }
598     }
599 
600     function recalculatePayoutValueInternal() internal {
601         uint d_profit = 0;
602         uint c_profit = 0;
603         uint o_profit = 0;
604         bool dedicated = dedicatedCharitySet();
605         address dedicated_charity = sm_dedicatedCharity;
606 
607         if (gameFinished()) {
608             o_profit = getFinalProfit();
609             // always positive
610             c_profit = availableBalance() - o_profit;
611             distribute(o_profit, sm_developers);
612             distribute(c_profit, sm_charity);
613         } else {
614             d_profit = getDeveloperProfit();
615             c_profit = getCharityProfit();
616             distribute(d_profit, sm_developers);
617 
618             if (dedicated) {
619                 distributeTo(c_profit, sm_dedicatedCharity);
620             } else {
621                 distribute(c_profit, sm_charity);
622             }
623 
624             sm_lastProfitSync = block.number;
625             
626             // clear the dedicated charity
627             sm_dedicatedCharity = address(0);
628         }
629 
630         sm_lastBalance = availableBalance();
631         emit ProfitRecalculated(gameFinished(), d_profit, c_profit, o_profit, 
632             sm_developers.length, sm_charity.length, dedicated, dedicated_charity);
633     }
634 
635     function addDeveloper(address dev, string name, string url) admin public {
636         // no one should be added twice
637         require(!sm_reciever[dev]);
638         require(!gameFinished());
639         require(sm_developers.length < sm_maxDevelopers);
640 
641         sm_developers.push(ProfitInfo(dev, name, url));
642         sm_reciever[dev] = true;
643         emit DeveloperAdded(dev, name, url);
644     }
645 
646     function developersAdded() public view returns (bool) {
647         return sm_maxDevelopers == sm_developers.length;
648     }
649 
650     function getDeveloperName(address dev) public view returns (string) {
651         for (uint i = 0; i < sm_developers.length; i++) {
652             if (sm_developers[i].receiver == dev) return sm_developers[i].description;
653         }
654 
655         return "";
656     }
657     function getDeveloperUrl(address dev) public view returns (string) {
658         for (uint i = 0; i < sm_developers.length; i++) {
659             if (sm_developers[i].receiver == dev) return sm_developers[i].url;
660         }
661 
662         return "";
663     }
664 
665     function addCharity(address charity, string name, string url) admin public {
666         // no one should be added twice
667         require(!sm_reciever[charity]);
668         require(!gameFinished());
669 
670         sm_charity.push(ProfitInfo(charity, name, url));
671         sm_reciever[charity] = true;
672         emit CharityAdded(charity, name, url);
673     }
674 
675     function getCharityName(address charity) public view returns (string) {
676         for (uint i = 0; i < sm_charity.length; i++) {
677             if (sm_charity[i].receiver == charity) return sm_charity[i].description;
678         }
679 
680         return "";
681     }
682     function getCharityUrl(address charity) public view returns (string) {
683         for (uint i = 0; i < sm_charity.length; i++) {
684             if (sm_charity[i].receiver == charity) return sm_charity[i].url;
685         }
686 
687         return "";
688     }
689 
690 
691     function charityIndex(address charity) view internal returns(int) {
692         for (uint i = 0; i < sm_charity.length; i++) {
693             if (sm_charity[i].receiver == charity) {
694                 return int(i);
695             }
696         }
697         
698         return -1;
699     }
700 
701     function charityExists(address charity) view internal returns(bool) {
702         return charityIndex(charity) >= 0;
703     }
704 
705     function setDedicatedCharityForNextRound(address charity) admin public {
706         require(charityExists(charity));
707         // the charity should not be set up
708         require(sm_dedicatedCharity == address(0));
709         sm_dedicatedCharity = charity;
710         emit DedicatedCharitySelected(sm_dedicatedCharity);
711     }
712 
713     function dedicatedCharitySet() public view returns(bool) {
714         return sm_dedicatedCharity != address(0);
715     }
716 
717     function dedicatedCharityAddress() public view returns(address) {
718         return sm_dedicatedCharity;
719     }
720     
721     function depositToBank() public payable {
722         require(!gameFinished());
723         require(msg.value > 0);
724         // the profit should not be modified by deposits
725         sm_lastBalance += msg.value;
726         emit MoneyDeposited(msg.sender, msg.value);
727     }
728 
729     function finishedWithdrawalTime() public view returns(bool) {
730         return gameFinished() && (block.number > finishedWithdrawalBlock());
731     }
732 
733     function finishedWithdrawalBlock() public view returns(uint) {
734         if (gameFinished()) {
735             return gameFinishedBlock() + sm_afterFinishLength;
736         } else {
737             return 0;
738         }
739     }
740 
741     function getTotalPayoutValue() public view returns(uint) {
742         uint payout = 0;
743 
744         for (uint i = 0; i < sm_developers.length; i++) {
745             payout += sm_profits[sm_developers[i].receiver];
746         }
747         for (i = 0; i < sm_charity.length; i++) {
748             payout += sm_profits[sm_charity[i].receiver];
749         }
750 
751         return payout;
752     }
753 
754     function getPayoutValue(address addr) public view returns(uint) {
755         return sm_profits[addr];
756     }
757 
758     function getPayoutValueSender() public view returns(uint) {
759         return getPayoutValue(msg.sender);
760     }
761 
762     function withdrawPayout() public {
763         // after the withdrawal time is finished, admin takes all the money
764         if (finishedWithdrawalTime() && msg.sender == getGameAdmin()) {
765             getGameAdmin().transfer(address(this).balance);
766         } else {
767             withdraw2Address(msg.sender);
768         }
769     }
770 
771     function withdraw2Address(address addr) public {
772         require(sm_profits[addr] > 0);
773 
774         uint value = sm_profits[addr];
775         sm_profits[addr] = 0;
776 
777         freeBalance(value);
778         addr.transfer(value);
779         emit MoneyWithdrawn(addr, value);
780     }
781 
782     function profitValue() public view returns(uint) {
783         if (availableBalance() >= sm_lastBalance) {
784             // always positive ok
785             return availableBalance() - sm_lastBalance;
786         } else {
787             return 0;
788         }
789     }
790 
791     function getDeveloperProfit() public view returns(uint) {
792         return (profitValue() * sm_developerShare) / (1 ether);
793     }
794 
795     function getCharityProfit() public view returns(uint) {
796         return (profitValue() * sm_charityShare) / (1 ether);
797     }
798 
799     function getFinalProfit() public view returns(uint) {
800         // owner profit is calculated only on final state of contract
801         return (availableBalance() * sm_finalShare) / (1 ether);
802     }
803 
804     function distributeTo(uint value, address recv) internal {
805         sm_profits[recv] += value;
806         reserveBalance(value);
807     }
808 
809     function distribute(uint profit, ProfitInfo[] recvs) internal {
810         if (recvs.length > 0) {
811             uint each = profit / recvs.length;
812             uint total = 0;
813             for (uint i = 0; i < recvs.length; i++) {
814                 if (i == recvs.length - 1) {
815                     distributeTo(profit - total, recvs[i].receiver);
816                 } else {
817                     distributeTo(each, recvs[i].receiver);
818                     total += each;
819                 }
820             }
821         }
822     }
823 }
824 
825 contract ISignedContractId {
826     function getId() public view returns(string);
827     function getVersion() public view returns(uint);
828     function getIdHash() public view returns(bytes32);
829     function getDataHash() public view returns(bytes32);
830 
831     function getBytes() public view returns(bytes);
832 
833     // signs the contract with the specified v r and s
834     function sign(uint8 v, bytes32 r, bytes32 s) public;
835     function getSignature() public view returns(uint8, bytes32, bytes32);
836     function isSigned() public view returns(bool);
837 }
838 
839 
840 contract SignedContractId is ISignedContractId {
841     string public contract_id;
842     uint public contract_version;
843     bytes public contract_signature;
844     address public info_address;
845     address public info_admin;
846     uint8 public v; 
847     bytes32 public r; 
848     bytes32 public s;
849     bool public signed;
850 
851     constructor(string id, uint version, address info, address admin) public {
852         contract_id = id;
853         contract_version = version;
854         info_address = info;
855         info_admin = admin;
856         signed = false;
857     }
858     function getId() public view returns(string) {
859         return contract_id;
860     }
861     function getVersion() public view returns(uint) {
862         return contract_version;
863     }
864     function getIdHash() public view returns(bytes32) {
865         return keccak256(abi.encodePacked(contract_id));
866     }
867     function getBytes() public view returns(bytes) {
868         return abi.encodePacked(contract_id);
869     }
870 
871 
872     function getDataHash() public view returns(bytes32) {
873         return keccak256(abi.encodePacked(getIdHash(), getVersion(), info_address, address(this)));
874     }
875 
876     function sign(uint8 v_, bytes32 r_, bytes32 s_) public {
877         require(!signed);
878         bytes32 hsh = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", getDataHash()));
879         require(info_admin == ecrecover(hsh, v_, r_, s_));
880         v = v_;
881         r = r_;
882         s = s_;
883         signed = true;
884     }
885 
886     function getSignature() public view returns(uint8, bytes32, bytes32) {
887         return (v, r, s);
888     }
889 
890     function isSigned() public view returns(bool) {
891         return signed;
892     }
893 }
894 
895 
896 contract IGameLengthLibrary is ICommonGame {
897     function getMinGameLength() public view returns(uint);
898     function getMaxGameLength() public view returns(uint);
899     function getMinGameAddon() public view returns(uint);
900     function getMaxGameAddon() public view returns(uint);
901 
902     function calcGameLength(uint number) public view returns (uint);
903     function calcGameAddon(uint number) public view returns (uint);
904 
905     event MinGameLengthAltered(uint newValue);
906     event MaxGameLengthAltered(uint newValue);
907     event AddonAltered(uint newValue);
908 
909     function alterMaxGameLength(uint _maxGameLength) public;
910     function alterMinGameLength(uint _minGameLength) public;
911     function alterAddon(uint _addon) public;
912 }
913 
914 contract LinearGameLibrary is IGameLengthLibrary {
915     uint public minLength;
916     uint public maxLength;
917     uint public addon;
918 
919     constructor(uint _minLength, uint _maxLength, uint _addon) public {
920         assert(_minLength <= _maxLength);
921 
922         minLength = _minLength;
923         maxLength = _maxLength;
924         addon = _addon;
925     }
926 
927     function calcGameLength(uint number) public view returns (uint) {
928         // always positive ok
929         return minLength + ((maxLength - minLength) * ((number % totalVariants()) + 1)) / totalVariants();
930     }
931     
932     function calcGameAddon(uint) public view returns (uint) {
933         return addon;
934     }
935 
936     function getMinGameLength() public view returns(uint) {
937         return minLength;
938     }
939 
940     function getMaxGameLength() public view returns(uint) {
941         return maxLength;
942     }
943 
944     function getMinGameAddon() public view returns(uint) {
945         return addon;
946     }
947 
948     function getMaxGameAddon() public view returns(uint) {
949         return addon;
950     }
951      
952     function alterMaxGameLength(uint _maxGameLength) public admin {
953         require(_maxGameLength > 0, "Max game length should be not zero");
954         require(_maxGameLength >= minLength, "Max game length should be not more than min length");
955         maxLength = _maxGameLength;
956         emit MaxGameLengthAltered(maxLength);
957     }
958 
959     function alterMinGameLength(uint _minGameLength) public admin {
960         require(_minGameLength > 0, "Min game length should be not zero");
961         require(_minGameLength <= maxLength, "Min game length should be less than max length");
962         minLength = _minGameLength;
963         emit MinGameLengthAltered(minLength);
964     }
965 
966     function alterAddon(uint _addon) public admin {
967         addon = _addon;
968         emit AddonAltered(addon);
969     }
970 }
971  
972 contract IGameManager {
973     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal;
974     function betInGameInternal(uint gameId, uint bet) internal;
975 
976     function withdrawPrize(uint gameId) public;
977     function withdrawPrizeInternal(uint gameId, uint additional) internal;
978 
979     function gameExists(uint gameId) public view returns (bool);
980     function finishedGame(uint gameId) public view returns(bool);
981     function getWinner(uint gameId) public view returns(address);
982     function getBet(uint gameId, address better) public view returns(uint);
983     function payedOut(uint gameId) public view returns(bool);
984     function prize(uint gameId) public view returns(uint);
985     function endsIn(uint gameId) public view returns(uint);
986     function lastBetBlock(uint gameId) public view returns(uint);
987 
988     function addonEndsIn(uint gameId) public view returns(uint);
989     function totalBets(uint gameId) public view returns(uint);
990     function gameProfited(uint gameId) public view returns(bool);
991 
992     event GameStarted(uint indexed gameId, address indexed starter, uint blockNumber, uint finishBlock, uint prize);
993     event GameBet(uint indexed gameId, address indexed bidder, address indexed winner, uint highestBet, uint finishBlock, uint value);
994     event GamePrizeTaken(uint indexed gameId, address indexed winner);
995 }
996 
997 
998 contract GameManager is IBalanceInfo, IGameManager {
999     // all of the games 
1000     mapping (uint => GameInfo) games;
1001     // all of the bets in the games  
1002     mapping (uint => mapping (address => uint)) bets;
1003 
1004     struct GameInfo {
1005         address highestBidder; // the person who made the highest bet in this game
1006         address starter; // the person who started this game
1007         uint blockFinish; // the block when the game will be finished
1008         uint prize; // the prize, that will be awarded to the winner
1009         uint totalBets; // the amount of total bets to this game
1010         bool payedOut; // true, if the user has taken back his deposit
1011         uint lastBetBlock;
1012         uint addOn;
1013     }
1014 
1015     function startGameInternal(uint gameId, uint length, uint addOn, uint prize) internal {
1016         // there was no other game started
1017         require(!gameExists(gameId));
1018         
1019         // the prize should be present
1020         require(prize > 0);
1021 
1022         // the length should be nonzero
1023         require(length > 0);
1024 
1025         // calculate the prize for the game
1026         games[gameId].starter = msg.sender;
1027         games[gameId].prize = prize;
1028 
1029         // reserve the balance for this prize
1030         reserveBalance(prize);
1031 
1032         // the finishing block of the game
1033         // important question is that the actual start block of the game is the current number, and block passed is used by id
1034         games[gameId].blockFinish = block.number + length - 1;
1035         games[gameId].addOn = addOn;
1036 
1037         // generate an event
1038         emit GameStarted(gameId, msg.sender, block.number, games[gameId].blockFinish, prize);
1039     }
1040 
1041     /**
1042     Checks that this user can start round (due to nonce issues)
1043      */
1044     function betInGameInternal(uint gameId, uint bet) internal {
1045         require(bet > 0, "Bet should be not zero");
1046 
1047         // the game was started
1048         require(gameExists(gameId), "No such game");
1049         require(!finishedGame(gameId), "Game is finished");
1050         uint newBet = bets[gameId][msg.sender] + bet;
1051         
1052         // update the highest bidder
1053         if (newBet > bets[gameId][games[gameId].highestBidder]) {
1054             games[gameId].highestBidder = msg.sender;
1055             games[gameId].lastBetBlock = block.number;
1056         } 
1057 
1058         bets[gameId][msg.sender] = newBet;
1059         // update the total bets
1060         games[gameId].totalBets += bet;
1061         emit GameBet(gameId, msg.sender, games[gameId].highestBidder, bets[gameId][games[gameId].highestBidder], addonEndsIn(gameId), newBet);
1062     }
1063 
1064     function withdrawPrize(uint gameId) public {
1065         withdrawPrizeInternal(gameId, 0);
1066     }
1067 
1068     function withdrawPrizeInternal(uint gameId, uint additional) internal {
1069         require(finishedGame(gameId), "Game not finished");
1070         require(msg.sender == games[gameId].highestBidder, "You are not the winner");
1071         require(!games[gameId].payedOut, "Game already payed");
1072         games[gameId].payedOut = true;
1073 
1074         // the invariant stays the same
1075         freeBalance(games[gameId].prize);
1076         msg.sender.transfer(games[gameId].prize + additional);
1077         emit GamePrizeTaken(gameId, msg.sender);
1078     }
1079 
1080 
1081     function gameExists(uint gameId) public view returns (bool) {
1082         return games[gameId].blockFinish != 0;
1083     }
1084 
1085     function getWinner(uint gameId) public view returns(address) {
1086         return games[gameId].highestBidder;
1087     }
1088 
1089     function finishedGame(uint gameId) public view returns(bool) {
1090         if (!gameExists(gameId)) 
1091             return false;
1092         return addonEndsIn(gameId) < block.number;
1093     }
1094 
1095     // returns that the game is payed out
1096     function payedOut(uint gameId) public view returns(bool) {
1097         return games[gameId].payedOut;
1098     }
1099 
1100     // returns the prize for this game
1101     function prize(uint gameId) public view returns(uint) {
1102         return games[gameId].prize;
1103     }
1104 
1105     function lastBetBlock(uint gameId) public view returns(uint) {
1106         return games[gameId].lastBetBlock;
1107     }
1108 
1109     function getBet(uint gameId, address better) public view returns(uint) {
1110         return bets[gameId][better];
1111     }
1112 
1113     // returns the block number, when the game is finished
1114     function endsIn(uint gameId) public view returns(uint) {
1115         return games[gameId].blockFinish;
1116     }
1117 
1118     function addonEndsIn(uint gameId) public view returns(uint) {
1119         uint addonB = games[gameId].lastBetBlock + games[gameId].addOn;
1120         if (addonB >= games[gameId].blockFinish) {
1121             return addonB;
1122         } else {
1123             return games[gameId].blockFinish;
1124         }
1125     }
1126 
1127     // returns the total amount of bets in the game
1128     function totalBets(uint gameId) public view returns(uint) {
1129         return games[gameId].totalBets;
1130     }
1131 
1132     function gameProfited(uint gameId) public view returns(bool) {
1133         return games[gameId].totalBets >= games[gameId].prize;
1134     }
1135 }
1136 contract StartGame is IStartGame, ICommonGame, IPrizeLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IBlockRandomLibrary {
1137     bool internal previousCalcRegular;
1138 
1139     constructor(uint _repeatBlock, uint _addonBlock) public
1140     {
1141         assert(_repeatBlock <= 250);
1142         repeatBlock = _repeatBlock;
1143         addonBlock = _addonBlock;
1144         calcNextGameId();
1145         defaultId = nextGameId;
1146     }
1147 
1148     // The manual ones have odd ids
1149     function startOwnFixed(uint gameId, uint length, uint addon, uint prize) public admin payable {
1150         require(msg.value > 0);
1151         require(!gameExists(gameId));
1152         require(gameId % 2 == 1);
1153 
1154         // the game length can be of any value, but for our security it should not be too small
1155         require(length >= getMinGameLength());
1156         // addon should just be not too large
1157         // the prize should be in the desired ratio
1158         require(prize >= getMinPrize() && prize <= getWholePrize());
1159 
1160         updateRandom();
1161         startGameInternal(gameId, length, addon, prize);
1162         profitedBet(gameId);
1163     }
1164 
1165     function randomValueWithMinPrize() internal view returns(uint) {
1166         if (!startOnlyMinPrizes() && isRandomAvailable()) {
1167             return getRandomValue();
1168         }
1169 
1170         return 0;
1171     }
1172 
1173     function startGameDetermine(uint gameId) internal {
1174         uint random = randomValueWithMinPrize();
1175         startGameInternal(gameId, calcGameLength(random), calcGameAddon(random), calculatePrize(random, getMinPrize(), getMaxPrize()));
1176     }
1177 
1178     function betInGame(uint gameId) public payable {
1179         require(msg.value > 0, "Bet should be not zero");
1180         updateRandom();
1181 
1182         if (!gameExists(gameId)) {
1183             require(canStartGame(), "Game cannot be started");
1184             // well creation should be allowed
1185             // one can only launch the start game with the possible game id
1186             require(startGameId() == gameId, "No such scheduled game");
1187             // can only be started after the corresponding block has passed
1188 
1189             startGameDetermine(gameId);
1190             updateDefaultGame(gameId);
1191             calcNextGameId();
1192         }
1193 
1194         profitedBet(gameId);
1195     }
1196 
1197     function profitedBet(uint gameId) internal {
1198         bool profited = gameProfited(gameId);
1199         betInGameInternal(gameId, msg.value);
1200 
1201         // the profited status changed
1202         // the own games are not counted
1203         if (profited != gameProfited(gameId)) {
1204             if (startProfitedGamesAllowed() && (gameId % 2 == 0 || autoCreationAfterOwnAllowed())) {
1205                 createFastGamesCount++;
1206                 if (!isRandomAvailable() && previousCalcRegular && createFastGamesCount == 1) {
1207                     calcNextGameId();
1208                 }
1209                 emit FastGamesChanged(createFastGamesCount);
1210             }
1211             profitedCount++;
1212             emit GameProfitedEvent(gameId);
1213         }
1214     }
1215         
1216     uint public repeatBlock;
1217     uint public addonBlock;
1218 
1219     function getRepeatBlock() public view returns(uint) {
1220         return repeatBlock;
1221     }
1222     function getAddonBlock() public view returns(uint) {
1223         return addonBlock;
1224     }
1225 
1226     function alterRepeatBlock(uint _repeatBlock) admin public {
1227         assert(_repeatBlock < 250);
1228         repeatBlock = _repeatBlock;
1229         emit RepeatBlockAltered(repeatBlock);
1230     }
1231 
1232     function alterAddonBlock(uint _addonBlock) admin public {
1233         addonBlock = _addonBlock;
1234         emit RepeatAddonBlockAltered(addonBlock);
1235     }
1236 
1237     uint internal nextGameId;
1238     uint internal defaultId;
1239     uint internal profitedCount;
1240     uint internal createFastGamesCount;
1241 
1242     function getProfitedCount() public view returns(uint) {
1243         return profitedCount;
1244     }
1245 
1246     function getCreateFastGamesCount() public view returns(uint) {
1247         return createFastGamesCount;
1248     }
1249 
1250     function setCreateFastGamesCount(uint count) public admin {
1251         createFastGamesCount = count;
1252         emit FastGamesChanged(createFastGamesCount);
1253     }
1254 
1255     function recalcNextGameId() public admin {
1256         if (!isRandomAvailable()) {
1257             calcNextGameId();
1258         } else {
1259             revert("You cannot recalculate, unless the prize has expired");
1260         }
1261     }
1262 
1263     function calcNextGameId() internal {
1264         uint ngi;
1265 
1266         previousCalcRegular = createFastGamesCount == 0;
1267 
1268         if (createFastGamesCount > 0) {
1269             ngi = block.number + addonBlock;
1270             createFastGamesCount--;
1271         } else {
1272             // always positive. ok
1273             ngi = block.number + (repeatBlock - block.number % repeatBlock);
1274         }
1275 
1276         // The main idea is that the automatic tourneys have even ids.
1277         // The manual ones have odd ids
1278         if (ngi % 2 == 1) {
1279             ngi++;
1280         }
1281 
1282         nextGameId = ngi;
1283         setRandomBlock(nextGameId);
1284         updateDefaultGame(nextGameId);
1285         emit NextGameIdCalculated(nextGameId);
1286     }
1287 
1288     function canStartGame() public view returns(bool) {
1289         return randomBlockPassed() && creationAllowed();
1290     }
1291 
1292     function startGameId() public view returns(uint) {
1293         return nextGameId;
1294     }
1295 
1296     function startPrizeValue() public view returns(uint) {
1297         return calculatePrize(randomValueWithMinPrize(), getMinPrize(), getMaxPrize());
1298     }
1299 
1300     function startGameLength() public view returns(uint) {
1301         return calcGameLength(randomValueWithMinPrize());
1302     }
1303 
1304     function startGameAddon() public view returns(uint) {
1305         return calcGameAddon(randomValueWithMinPrize());
1306     }
1307 
1308     function getStartGameStatus() public view returns(bool, uint, uint, uint, uint) {
1309         uint random = randomValueWithMinPrize();
1310         return (
1311             canStartGame(), 
1312             nextGameId, 
1313             calculatePrize(random, getMinPrize(), getMaxPrize()),
1314             calcGameLength(random),
1315             calcGameAddon(random));
1316     }
1317 
1318     function updateDefaultGame(uint gameId) internal {
1319         if (finishedGame(defaultId) || !gameExists(defaultId)) {
1320             defaultId = gameId;
1321             emit DefaultGameUpdated(defaultId);
1322         } 
1323     }
1324 
1325     function defaultGameId() public view returns(uint) {
1326         if (!finishedGame(defaultId) && gameExists(defaultId)) return defaultId;
1327         if (canStartGame()) return startGameId();
1328         return 0;
1329     }
1330 
1331     function defaultGameAvailable() public view returns(bool) {
1332         return !finishedGame(defaultId) && gameExists(defaultId) || canStartGame();
1333     }
1334 
1335     mapping (address => uint) transferGames;
1336 
1337     function getTransferProfitedGame(address participant) public view returns(uint) {
1338         if (finishedGame(transferGames[participant]) && getWinner(transferGames[participant]) == participant) {
1339             return transferGames[participant];
1340         }
1341 
1342         return 0;
1343     }
1344 
1345     function getTransferProfitedGame() internal view returns(uint) {
1346         return getTransferProfitedGame(msg.sender);
1347     }
1348 
1349     function processTransfer() internal {
1350         uint tpg = getTransferProfitedGame();
1351         // there is no game to withdraw
1352         if (tpg == 0) {
1353             if (!finishedGame(defaultId) && gameExists(defaultId)) {
1354                 betInGame(defaultId);
1355             } else {
1356                 betInGame(startGameId());
1357             }
1358             transferGames[msg.sender] = defaultId;
1359         } else {
1360             transferGames[msg.sender] = 0;
1361             withdrawPrizeInternal(tpg, msg.value);
1362         } 
1363 
1364         emit TransferBet(msg.sender, msg.value);
1365     }
1366 
1367     function processTransferInteraction() internal {
1368         if (transferInteractionsAllowed()) {
1369             processTransfer();
1370         } else {
1371             revert();
1372         }
1373     }
1374 }
1375 
1376 contract ICharbetto is IMoneyContract, IStartGame, IBalanceSharePrizeContract,
1377         IBlockRandomLibrary, IMinMaxPrize, IGameLengthLibrary, IGameManager, IFunctionPrize, IPrizeLibrary {
1378     function recalculatePayoutValueAdmin() public;
1379     function stopGameFast() public;
1380 }
1381 
1382 contract Charbetto is CommonGame, BlockRandomLibrary, BalanceInfo, PrizeLibrary, EllipticPrize16x, 
1383         MoneyContract, StartGame, GameManager, LinearGameLibrary, BalanceSharePrizeContract {
1384     constructor(address _admin) public
1385         CommonGame(_admin) 
1386         BlockRandomLibrary(250)
1387         BalanceInfo()
1388         PrizeLibrary()
1389         EllipticPrize16x()
1390         MoneyContract(
1391             10 finney /*1 percent*/, 
1392             5, /*5 developers at maximum*/
1393             100 finney /*10 percent*/, 
1394             100 finney /*10 percent*/, 
1395             20000, 200000)
1396         StartGame(5, 3)  
1397         GameManager()
1398         LinearGameLibrary(50, 1000, 3)
1399         // from one dollar to 1/10 of the prize
1400         BalanceSharePrizeContract(10 finney, 100 finney)
1401     {
1402         // not using alter methods to prevent deployment only from admin acc
1403         totalV = 1000;
1404         minLength = 20;
1405         maxLength = 30;
1406         transferInteractions = true;
1407     }
1408 
1409     //Terrible ugly hack to prevent the balance share contract to calculate the prize in wrong way
1410     function betInGame(uint gameId) public payable {
1411         bool exists = gameExists(gameId);
1412 
1413         if (!exists) {
1414             reserveBalance(msg.value);
1415         }
1416 
1417         super.betInGame(gameId);
1418 
1419         if (!exists) {
1420             freeBalance(msg.value);
1421         }
1422     }
1423 
1424 
1425     function isItReallyCharbetto() public pure returns (bool) {
1426         return true;
1427     }
1428 
1429     // The default fallback function should be specified
1430     function () payable public {
1431         processTransferInteraction();
1432     }
1433 }
1434 
1435 contract ISignedCharbetto is ISignedContractId, ICharbetto {}
1436 
1437 contract SignedCharbetto is Charbetto, SignedContractId {
1438     constructor(address admin_, uint version_, address infoContract_, address infoAdminAddress_) public 
1439         Charbetto(admin_) 
1440         SignedContractId("charbetto", version_, infoContract_, infoAdminAddress_)
1441     {} 
1442 
1443     function recalculatePayoutValueAdmin() admin public {
1444         revert();
1445     }
1446 
1447     function stopGameFast() admin public {
1448         revert();
1449     }
1450 
1451     // The default fallback function should be specified
1452     function () payable public {
1453         processTransferInteraction();
1454     }
1455 }