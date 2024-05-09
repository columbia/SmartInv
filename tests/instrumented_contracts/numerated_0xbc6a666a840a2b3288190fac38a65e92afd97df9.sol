1 pragma solidity ^0.4.18;
2 
3 contract Manager {
4     address public ceo;
5     address public cfo;
6     address public coo;
7     address public cao;
8 
9     event OwnershipTransferred(address previousCeo, address newCeo);
10     event Pause();
11     event Unpause();
12 
13 
14     /**
15     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16     * account.
17     */
18     function Manager() public {
19         coo = msg.sender; 
20         cfo = 0x7810704C6197aFA95e940eF6F719dF32657AD5af;
21         ceo = 0x96C0815aF056c5294Ad368e3FBDb39a1c9Ae4e2B;
22         cao = 0xC4888491B404FfD15cA7F599D624b12a9D845725;
23     }
24 
25     /**
26     * @dev Throws if called by any account other than the owner.
27     */
28     modifier onlyCEO() {
29         require(msg.sender == ceo);
30         _;
31     }
32 
33     modifier onlyCOO() {
34         require(msg.sender == coo);
35         _;
36     }
37 
38     modifier onlyCAO() {
39         require(msg.sender == cao);
40         _;
41     }
42     
43     bool allowTransfer = false;
44     
45     function changeAllowTransferState() public onlyCOO {
46         if (allowTransfer) {
47             allowTransfer = false;
48         } else {
49             allowTransfer = true;
50         }
51     }
52     
53     modifier whenTransferAllowed() {
54         require(allowTransfer);
55         _;
56     }
57 
58     /**
59     * @dev Allows the current owner to transfer control of the contract to a newCeo.
60     * @param newCeo The address to transfer ownership to.
61     */
62     function demiseCEO(address newCeo) public onlyCEO {
63         require(newCeo != address(0));
64         emit OwnershipTransferred(ceo, newCeo);
65         ceo = newCeo;
66     }
67 
68     function setCFO(address newCfo) public onlyCEO {
69         require(newCfo != address(0));
70         cfo = newCfo;
71     }
72 
73     function setCOO(address newCoo) public onlyCEO {
74         require(newCoo != address(0));
75         coo = newCoo;
76     }
77 
78     function setCAO(address newCao) public onlyCEO {
79         require(newCao != address(0));
80         cao = newCao;
81     }
82 
83     bool public paused = false;
84 
85 
86     /**
87     * @dev Modifier to make a function callable only when the contract is not paused.
88     */
89     modifier whenNotPaused() {
90         require(!paused);
91         _;
92     }
93 
94     /**
95     * @dev Modifier to make a function callable only when the contract is paused.
96     */
97     modifier whenPaused() {
98         require(paused);
99         _;
100     }
101 
102     /**
103     * @dev called by the owner to pause, triggers stopped state
104     */
105     function pause() onlyCAO whenNotPaused public {
106         paused = true;
107         emit Pause();
108     }
109 
110     /**
111     * @dev called by the owner to unpause, returns to normal state
112     */
113     function unpause() onlyCAO whenPaused public {
114         paused = false;
115         emit Unpause();
116     }
117 }
118 
119 contract AlchemyBase is Manager {
120 
121     // Assets of each account
122     mapping (address => bytes32[8]) assets;
123 
124     // Event
125     event Transfer(address from, address to);
126 
127     // Get all assets of a particular account
128     function assetOf(address account) public view returns(bytes32[8]) {
129         return assets[account];
130     }
131 
132     function _checkAndAdd(bytes32 x, bytes32 y) internal pure returns(bytes32) {
133         bytes32 mask = bytes32(255); // 0x11111111
134 
135         bytes32 result;
136 
137         uint maskedX;
138         uint maskedY;
139         uint maskedResult;
140 
141         for (uint i = 0; i < 31; i++) {
142             // Get current mask
143             if (i > 0) {
144                 mask = mask << 8;
145             }
146 
147             // Get masked values
148             maskedX = uint(x & mask);
149             maskedY = uint(y & mask);
150             maskedResult = maskedX + maskedY;
151 
152             // Prevent overflow
153             require(maskedResult < (2 ** (8 * (i + 1))));
154 
155             // Clear result digits in masked position
156             result = (result ^ mask) & result;
157 
158             // Write to result
159             result = result | bytes32(maskedResult);
160         }
161 
162         return result;
163     }
164 
165     function _checkAndSub(bytes32 x, bytes32 y) internal pure returns(bytes32) {
166         bytes32 mask = bytes32(255); // 0x11111111
167 
168         bytes32 result;
169 
170         uint maskedX;
171         uint maskedY;
172         uint maskedResult;
173 
174         for (uint i = 0; i < 31; i++) {
175             // Get current mask
176             if (i > 0) {
177                 mask = mask << 8;
178             }
179 
180             // Get masked values
181             maskedX = uint(x & mask);
182             maskedY = uint(y & mask);
183 
184             // Ensure x >= y
185             require(maskedX >= maskedY);
186 
187             // Calculate result
188             maskedResult = maskedX - maskedY;
189 
190             // Clear result digits in masked position
191             result = (result ^ mask) & result;
192 
193             // Write to result
194             result = result | bytes32(maskedResult);
195         }
196 
197         return result;
198     }
199 
200     // Transfer assets from one account to another
201     function transfer(address to, bytes32[8] value) public whenNotPaused whenTransferAllowed {
202         // One can not transfer assets to self
203         require(msg.sender != to);
204         bytes32[8] memory assetFrom = assets[msg.sender];
205         bytes32[8] memory assetTo = assets[to];
206 
207         for (uint256 i = 0; i < 8; i++) {
208             assetFrom[i] = _checkAndSub(assetFrom[i], value[i]);
209             assetTo[i] = _checkAndAdd(assetTo[i], value[i]);
210         }
211 
212         assets[msg.sender] = assetFrom;
213         assets[to] = assetTo;
214 
215         // Emit the transfer event
216         emit Transfer(msg.sender, to);
217     }
218 
219     // Withdraw ETH to the owner account. Ownable-->Pausable-->AlchemyBase
220     function withdrawETH() external onlyCAO {
221         cfo.transfer(address(this).balance);
222     }
223 }
224 
225 
226 contract AlchemyPatent is AlchemyBase {
227 
228     // patent struct
229     struct Patent {
230         // current patent owner
231         address patentOwner;
232         // the time when owner get the patent
233         uint256 beginTime;
234         // whether this patent is on sale
235         bool onSale; 
236         // the sale price
237         uint256 price;
238         // last deal price
239         uint256 lastPrice;
240         // the time when this sale is put on
241         uint256 sellTime;
242     }
243 
244     // Creator of each kind of asset
245     mapping (uint16 => Patent) public patents;
246 
247     // patent fee ratio
248     // Values 0-10,000 map to 0%-100%
249     uint256 public feeRatio = 9705;
250 
251     uint256 public patentValidTime = 2 days;
252     uint256 public patentSaleTimeDelay = 2 hours;
253 
254     // Event
255     event RegisterCreator(address account, uint16 kind);
256     event SellPatent(uint16 assetId, uint256 sellPrice);
257     event ChangePatentSale(uint16 assetId, uint256 newPrice);
258     event BuyPatent(uint16 assetId, address buyer);
259 
260     // set the patent fee ratio
261     function setPatentFee(uint256 newFeeRatio) external onlyCOO {
262         require(newFeeRatio <= 10000);
263         feeRatio = newFeeRatio;
264     }
265 
266     // sell the patent
267     function sellPatent(uint16 assetId, uint256 sellPrice) public whenNotPaused {
268         Patent memory patent = patents[assetId];
269         require(patent.patentOwner == msg.sender);
270         if (patent.lastPrice > 0) {
271             require(sellPrice <= 2 * patent.lastPrice);
272         } else {
273             require(sellPrice <= 1 ether);
274         }
275         
276         require(!patent.onSale);
277 
278         patent.onSale = true;
279         patent.price = sellPrice;
280         patent.sellTime = now;
281 
282         patents[assetId] = patent;
283 
284         // Emit the event
285         emit SellPatent(assetId, sellPrice);
286     }
287 
288     function publicSell(uint16 assetId) public whenNotPaused {
289         Patent memory patent = patents[assetId];
290         require(patent.patentOwner != address(0));  // this is a valid patent
291         require(!patent.onSale);
292         require(patent.beginTime + patentValidTime < now);
293 
294         patent.onSale = true;
295         patent.price = patent.lastPrice;
296         patent.sellTime = now;
297 
298         patents[assetId] = patent;
299 
300         // Emit the event
301         emit SellPatent(assetId, patent.lastPrice);
302     }
303 
304     // change sell price
305     function changePatentSale(uint16 assetId, uint256 newPrice) external whenNotPaused {
306         Patent memory patent = patents[assetId];
307         require(patent.patentOwner == msg.sender);
308         if (patent.lastPrice > 0) {
309             require(newPrice <= 2 * patent.lastPrice);
310         } else {
311             require(newPrice <= 1 ether);
312         }
313         require(patent.onSale == true);
314 
315         patent.price = newPrice;
316 
317         patents[assetId] = patent;
318 
319         // Emit the event
320         emit ChangePatentSale(assetId, newPrice);
321     }
322 
323     // buy patent
324     function buyPatent(uint16 assetId) external payable whenNotPaused {
325         Patent memory patent = patents[assetId];
326         require(patent.patentOwner != address(0));  // this is a valid patent
327         require(patent.patentOwner != msg.sender);
328         require(patent.onSale);
329         require(msg.value >= patent.price);
330         require(now >= patent.sellTime + patentSaleTimeDelay);
331 
332         patent.patentOwner.transfer(patent.price / 10000 * feeRatio);
333         patent.patentOwner = msg.sender;
334         patent.beginTime = now;
335         patent.onSale = false;
336         patent.lastPrice = patent.price;
337 
338         patents[assetId] = patent;
339 
340         //Emit the event
341         emit BuyPatent(assetId, msg.sender);
342     }
343 }
344 
345 
346 contract ChemistryInterface {
347     function isChemistry() public pure returns (bool);
348 
349     // function turnOnFurnace(bytes32 x0, bytes32 x1, bytes32 x2, bytes32 x3) public returns (bytes32 r0, bytes32 r1, bytes32 r2, bytes32 r3);
350     function turnOnFurnace(uint16[5] inputAssets, uint128 addition) public returns (uint16[5]);
351 
352     function computeCooldownTime(uint128 typeAdd, uint256 baseTime) public returns (uint256);
353 }
354 
355 
356 
357 contract SkinInterface {
358     function getActiveSkin(address account) public view returns (uint128);
359 }
360 
361 
362 
363 
364 contract AlchemySynthesize is AlchemyPatent {
365 
366     // Synthesize formula
367     ChemistryInterface public chemistry;
368     SkinInterface public skinContract;
369 
370     // Cooldown after submit a after submit a transformation request
371     uint256[9] public cooldownLevels = [
372         5 minutes,
373         10 minutes,
374         15 minutes,
375         20 minutes,
376         25 minutes,
377         30 minutes,
378         35 minutes,
379         40 minutes,
380         45 minutes
381     ];
382 
383     // patent fee for each level
384     uint256[9] public pFees = [
385         0,
386         2 finney,
387         4 finney,
388         8 finney,
389         12 finney,
390         18 finney,
391         26 finney,
392         36 finney,
393         48 finney
394     ];
395 
396     // alchemy furnace struct
397     struct Furnace {
398         // the pending assets for synthesize
399         uint16[5] pendingAssets;
400         // cooldown end time of synthesise
401         uint256 cooldownEndTime;
402         // whether this furnace is using
403         bool inSynthesization;
404         //
405         uint256 count;
406     }
407 
408     uint256 public maxSCount = 10;
409 
410     // furnace of each account
411     mapping (address => Furnace) public accountsToFurnace;
412 
413     // alchemy level of each asset
414     mapping (uint16 => uint256) public assetLevel;
415 
416     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
417     uint256 public prePaidFee = 1000000 * 3000000000; // (1million gas * 3 gwei)
418 
419     bool public isSynthesizeAllowed = false;
420 
421     // When a synthesization request starts, our daemon needs to call getSynthesizationResult() after cooldown.
422     // event SynthesizeStart(address account);
423     event AutoSynthesize(address account, uint256 cooldownEndTime);
424     event SynthesizeSuccess(address account);
425 
426     // Initialize the asset level
427     function initializeLevel() public onlyCOO {
428         // Level of assets
429         uint8[9] memory levelSplits = [4,     // end of level 0. start of level is 0
430                                           19,    // end of level 1
431                                           46,    // end of level 2
432                                           82,    // end of level 3
433                                           125,   // end of level 4
434                                           156,
435                                           180,
436                                           195,
437                                           198];  // end of level 8
438         uint256 currentLevel = 0;
439         for (uint8 i = 0; i < 198; i ++) {
440             if (i == levelSplits[currentLevel]) {
441                 currentLevel ++;
442             }
443             assetLevel[uint16(i)] = currentLevel;
444         }
445     }
446 
447     function setAssetLevel(uint16 assetId, uint256 level) public onlyCOO {
448         assetLevel[assetId] = level;
449     }
450 
451     function setMaxCount(uint256 max) external onlyCOO {
452         maxSCount = max;
453     }
454 
455     function setPatentFees(uint256[9] newFees) external onlyCOO {
456         for (uint256 i = 0; i < 9; i++) {
457             pFees[i] = newFees[i];
458         }
459     }
460 
461     function changeSynthesizeAllowed(bool newState) external onlyCOO {
462         isSynthesizeAllowed = newState;
463     }
464 
465     // Get furnace information
466     function getFurnace(address account) public view returns (uint16[5], uint256, bool, uint256) {
467         return (accountsToFurnace[account].pendingAssets, accountsToFurnace[account].cooldownEndTime, accountsToFurnace[account].inSynthesization, accountsToFurnace[account].count);
468     }
469 
470     // Set chemistry science contract address
471     function setChemistryAddress(address chemistryAddress) external onlyCOO {
472         ChemistryInterface candidateContract = ChemistryInterface(chemistryAddress);
473 
474         require(candidateContract.isChemistry());
475 
476         chemistry = candidateContract;
477     }
478 
479     // Set skin contract address
480     function setSkinContract(address skinAddress) external onlyCOO {
481         skinContract = SkinInterface(skinAddress);
482     }
483 
484     // setPrePaidFee: set advance amount, only owner can call this
485     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
486         prePaidFee = newPrePaidFee;
487     }
488 
489     // _isCooldownReady: check whether cooldown period has been passed
490     function _isCooldownReady(address account) internal view returns (bool) {
491         return (accountsToFurnace[account].cooldownEndTime <= now);
492     }
493 
494     // synthesize: call _isCooldownReady, pending assets, fire SynthesizeStart event
495     function synthesize(uint16[5] inputAssets, uint256 sCount) public payable whenNotPaused {
496         require(isSynthesizeAllowed == true);
497         // Check msg.sender is not in another synthesizing process
498         require(accountsToFurnace[msg.sender].inSynthesization == false);
499         //
500         require(sCount <= maxSCount && sCount > 0);
501 
502         // Check whether assets are valid
503         bytes32[8] memory asset = assets[msg.sender];
504 
505         bytes32 mask; // 0x11111111
506         uint256 maskedValue;
507         uint256 count;
508         bytes32 _asset;
509         uint256 pos;
510         uint256 maxLevel = 0;
511         uint256 totalFee = 0;
512         uint256 _assetLevel;
513         Patent memory _patent;
514         uint16 currentAsset;
515 
516         for (uint256 i = 0; i < 5; i++) {
517             currentAsset = inputAssets[i];
518             if (currentAsset < 248) {
519                 _asset = asset[currentAsset / 31];
520                 pos = currentAsset % 31;
521                 mask = bytes32(255) << (8 * pos);
522                 maskedValue = uint256(_asset & mask);
523 
524                 require(maskedValue >= (sCount << (8*pos)));
525                 maskedValue -= (sCount << (8*pos));
526                 _asset = ((_asset ^ mask) & _asset) | bytes32(maskedValue);
527                 asset[currentAsset / 31] = _asset;
528                 count += 1;
529 
530                 // handle patent fee
531                 _assetLevel = assetLevel[currentAsset];
532                 if (_assetLevel > maxLevel) {
533                     maxLevel = _assetLevel;
534                 }
535 
536                 if (_assetLevel > 0) {
537                     _patent = patents[currentAsset];
538                     if (_patent.patentOwner != address(0) && _patent.patentOwner != msg.sender && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
539                         maskedValue = pFees[_assetLevel] * sCount;
540                         _patent.patentOwner.transfer(maskedValue / 10000 * feeRatio);
541                         totalFee += maskedValue;
542                     }
543                 }
544             }
545         }
546 
547         require(msg.value >= prePaidFee + totalFee);
548 
549         require(count >= 2 && count <= 5);
550 
551         // Check whether cooldown has ends
552         require(_isCooldownReady(msg.sender));
553 
554         uint128 skinType = skinContract.getActiveSkin(msg.sender);
555         uint256 _cooldownTime = chemistry.computeCooldownTime(skinType, cooldownLevels[maxLevel]);
556 
557         accountsToFurnace[msg.sender].pendingAssets = inputAssets;
558         accountsToFurnace[msg.sender].cooldownEndTime = now + _cooldownTime;
559         accountsToFurnace[msg.sender].inSynthesization = true;
560         accountsToFurnace[msg.sender].count = sCount;
561         assets[msg.sender] = asset;
562 
563         // Emit SnthesizeStart event
564         // SynthesizeStart(msg.sender);
565         emit AutoSynthesize(msg.sender, accountsToFurnace[msg.sender].cooldownEndTime);
566     }
567 
568     function getPatentFee(address account, uint16[5] inputAssets, uint256 sCount) external view returns (uint256) {
569 
570         uint256 totalFee = 0;
571         uint256 _assetLevel;
572         Patent memory _patent;
573         uint16 currentAsset;
574 
575         for (uint256 i = 0; i < 5; i++) {
576             currentAsset = inputAssets[i];
577             if (currentAsset < 248) {
578 
579                 // handle patent fee
580                 _assetLevel = assetLevel[currentAsset];
581                 if (_assetLevel > 0) {
582                     _patent = patents[currentAsset];
583                     if (_patent.patentOwner != address(0) && _patent.patentOwner != account && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
584                         totalFee += pFees[_assetLevel] * sCount;
585                     }
586                 }
587             }
588         }
589         return totalFee;
590     }
591 
592     // getSynthesizationResult: auto synthesize daemin call this. if cooldown time has passed, give final result
593     // Anyone can call this function, if they are willing to pay the gas
594     function getSynthesizationResult(address account) external whenNotPaused {
595 
596         // Make sure this account is in synthesization
597         require(accountsToFurnace[account].inSynthesization);
598 
599         // Make sure the cooldown has ends
600         require(_isCooldownReady(account));
601 
602         // Get result using pending assets
603         uint16[5] memory _pendingAssets = accountsToFurnace[account].pendingAssets;
604         uint128 skinType = skinContract.getActiveSkin(account);
605         uint16[5] memory resultAssets; //= chemistry.turnOnFurnace(_pendingAssets, skinType);
606 
607         // Write result
608         bytes32[8] memory asset = assets[account];
609 
610         bytes32 mask; // 0x11111111
611         uint256 maskedValue;
612         uint256 j;
613         uint256 pos;
614 
615         for (uint256 k = 0; k < accountsToFurnace[account].count; k++) {
616             resultAssets = chemistry.turnOnFurnace(_pendingAssets, skinType);
617             for (uint256 i = 0; i < 5; i++) {
618                 if (resultAssets[i] < 248) {
619                     j = resultAssets[i] / 31;
620                     pos = resultAssets[i] % 31;
621                     mask = bytes32(255) << (8 * pos);
622                     maskedValue = uint256(asset[j] & mask);
623 
624                     require(maskedValue < (uint256(255) << (8*pos)));
625                     maskedValue += (uint256(1) << (8*pos));
626                     asset[j] = ((asset[j] ^ mask) & asset[j]) | bytes32(maskedValue);
627 
628                     // handle patent
629                     if (resultAssets[i] > 3 && patents[resultAssets[i]].patentOwner == address(0)) {
630                         patents[resultAssets[i]] = Patent({patentOwner: account,
631                                                         beginTime: now,
632                                                         onSale: false,
633                                                         price: 0,
634                                                         lastPrice: 100 finney,
635                                                         sellTime: 0});
636                         // Emit the event
637                         emit RegisterCreator(account, resultAssets[i]);
638                     }
639                 }
640             }
641         }
642 
643 
644         // Mark this synthesization as finished
645         accountsToFurnace[account].inSynthesization = false;
646         accountsToFurnace[account].count = 0;
647         assets[account] = asset;
648 
649         msg.sender.transfer(prePaidFee);
650 
651         emit SynthesizeSuccess(account);
652     }
653 }
654 
655 
656 contract AlchemyMinting is AlchemySynthesize {
657 
658     // Limit the nubmer of zero order assets the owner can create every day
659     uint256 public zoDailyLimit = 1000; // we can create 4 * 1000 = 4000 0-order asset each day
660     uint256[4] public zoCreated;
661 
662     // Limit the number each account can buy every day
663     mapping(address => bytes32) public accountsBoughtZoAsset;
664     mapping(address => uint256) public accountsZoLastRefreshTime;
665 
666     // Price of zero order assets
667     uint256 public zoPrice = 2500 szabo;
668 
669     // Last daily limit refresh time
670     uint256 public zoLastRefreshTime = now;
671 
672     // Event
673     event BuyZeroOrderAsset(address account, bytes32 values);
674 
675     // To ensure scarcity, we are unable to change the max numbers of zo assets every day.
676     // We are only able to modify the price
677     function setZoPrice(uint256 newPrice) external onlyCOO {
678         zoPrice = newPrice;
679     }
680 
681     // Buy zo assets from us
682     function buyZoAssets(bytes32 values) external payable whenNotPaused {
683         // Check whether we need to refresh the daily limit
684         bytes32 history = accountsBoughtZoAsset[msg.sender];
685         if (accountsZoLastRefreshTime[msg.sender] == uint256(0)) {
686             // This account's first time to buy zo asset, we do not need to clear accountsBoughtZoAsset
687             accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
688         } else {
689             if (accountsZoLastRefreshTime[msg.sender] < zoLastRefreshTime) {
690                 history = bytes32(0);
691                 accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
692             }
693         }
694 
695         uint256 currentCount = 0;
696         uint256 count = 0;
697 
698         bytes32 mask = bytes32(255); // 0x11111111
699         uint256 maskedValue;
700         uint256 maskedResult;
701 
702         bytes32 asset = assets[msg.sender][0];
703 
704         for (uint256 i = 0; i < 4; i++) {
705             if (i > 0) {
706                 mask = mask << 8;
707             }
708             maskedValue = uint256(values & mask);
709             currentCount = maskedValue / 2 ** (8 * i);
710             count += currentCount;
711 
712             // Check whether this account has bought too many assets
713             maskedResult = uint256(history & mask);
714             maskedResult += maskedValue;
715             require(maskedResult < (2 ** (8 * (i + 1))));
716 
717             // Update account bought history
718             history = ((history ^ mask) & history) | bytes32(maskedResult);
719 
720             // Check whether this account will have too many assets
721             maskedResult = uint256(asset & mask);
722             maskedResult += maskedValue;
723             require(maskedResult < (2 ** (8 * (i + 1))));
724 
725             // Update user asset
726             asset = ((asset ^ mask) & asset) | bytes32(maskedResult);
727 
728             // Check whether we have enough assets to sell
729             require(zoCreated[i] + currentCount <= zoDailyLimit);
730 
731             // Update our creation history
732             zoCreated[i] += currentCount;
733         }
734 
735         // Ensure this account buy at least one zo asset
736         require(count > 0);
737 
738         // Check whether there are enough money for payment
739         require(msg.value >= count * zoPrice);
740 
741         // Write updated user asset
742         assets[msg.sender][0] = asset;
743 
744         // Write updated history
745         accountsBoughtZoAsset[msg.sender] = history;
746 
747         // Emit BuyZeroOrderAsset event
748         emit BuyZeroOrderAsset(msg.sender, values);
749 
750     }
751 
752     // Our daemon will refresh daily limit
753     function clearZoDailyLimit() external onlyCOO {
754         uint256 nextDay = zoLastRefreshTime + 1 days;
755         if (now > nextDay) {
756             zoLastRefreshTime = nextDay;
757             for (uint256 i = 0; i < 4; i++) {
758                 zoCreated[i] =0;
759             }
760         }
761     }
762 }
763 
764 contract AlchemyMarket is AlchemyMinting {
765 
766     // Sale order struct
767     struct SaleOrder {
768         // Asset id to be sold
769         uint64 assetId;
770         // Sale amount
771         uint64 amount;
772         // Desired price
773         uint128 desiredPrice;
774         // Seller
775         address seller; 
776     }
777 
778     // Max number of sale orders of each account 
779     uint128 public maxSaleNum = 20;
780 
781     // Cut ratio for a transaction
782     // Values 0-10,000 map to 0%-100%
783     uint256 public trCut = 275;
784 
785     // Next sale id
786     uint256 public nextSaleId = 1;
787 
788     // Sale orders list 
789     mapping (uint256 => SaleOrder) public saleOrderList;
790 
791     // Sale information of each account
792     mapping (address => uint256) public accountToSaleNum;
793 
794     // events
795     event PutOnSale(address account, uint256 saleId);
796     event WithdrawSale(address account, uint256 saleId);
797     event ChangeSale(address account, uint256 saleId);
798     event BuyInMarket(address buyer, uint256 saleId, uint256 amount);
799     event SaleClear(uint256 saleId);
800 
801     // functions
802     function setTrCut(uint256 newCut) public onlyCOO {
803         trCut = newCut;
804     }
805 
806     // Put asset on sale
807     function putOnSale(uint256 assetId, uint256 amount, uint256 price) external whenNotPaused {
808         // One account can have no more than maxSaleNum sale orders
809         require(accountToSaleNum[msg.sender] < maxSaleNum);
810 
811         // check whether zero order asset is to be sold 
812         // which is not allowed
813         require(assetId > 3 && assetId < 248);
814         require(amount > 0 && amount < 256);
815 
816         uint256 assetFloor = assetId / 31;
817         uint256 assetPos = assetId - 31 * assetFloor;
818         bytes32 allAsset = assets[msg.sender][assetFloor];
819 
820         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
821         uint256 maskedValue;
822         uint256 maskedResult;
823         uint256 addAmount = amount << (8 * assetPos);
824 
825         // check whether there are enough unpending assets to sell
826         maskedValue = uint256(allAsset & mask);
827         require(addAmount <= maskedValue);
828 
829         // Remove assets to be sold from owner
830         maskedResult = maskedValue - addAmount;
831         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
832 
833         assets[msg.sender][assetFloor] = allAsset;
834 
835         // Put on sale
836         SaleOrder memory saleorder = SaleOrder(
837             uint64(assetId),
838             uint64(amount),
839             uint128(price),
840             msg.sender
841         );
842 
843         saleOrderList[nextSaleId] = saleorder;
844         nextSaleId += 1;
845 
846         accountToSaleNum[msg.sender] += 1;
847 
848         // Emit the Approval event
849         emit PutOnSale(msg.sender, nextSaleId-1);
850     }
851   
852     // Withdraw an sale order
853     function withdrawSale(uint256 saleId) external whenNotPaused {
854         // Can only withdraw self's sale order
855         require(saleOrderList[saleId].seller == msg.sender);
856 
857         uint256 assetId = uint256(saleOrderList[saleId].assetId);
858         uint256 assetFloor = assetId / 31;
859         uint256 assetPos = assetId - 31 * assetFloor;
860         bytes32 allAsset = assets[msg.sender][assetFloor];
861 
862         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
863         uint256 maskedValue;
864         uint256 maskedResult;
865         uint256 addAmount = uint256(saleOrderList[saleId].amount) << (8 * assetPos);
866 
867         // check whether this account will have too many assets
868         maskedValue = uint256(allAsset & mask);
869         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
870 
871         // Retransfer asset to be sold from owner
872         maskedResult = maskedValue + addAmount;
873         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
874 
875         assets[msg.sender][assetFloor] = allAsset;
876 
877         // Delete sale order
878         delete saleOrderList[saleId];
879 
880         accountToSaleNum[msg.sender] -= 1;
881 
882         // Emit the cancel event
883         emit WithdrawSale(msg.sender, saleId);
884     }
885  
886 //     // Change sale order
887 //     function changeSale(uint256 assetId, uint256 amount, uint256 price, uint256 saleId) external whenNotPaused {
888 //         // Check if msg sender is the seller
889 //         require(msg.sender == saleOrderList[saleId].seller);
890 // 
891 //     }
892  
893     // Buy assets in market
894     function buyInMarket(uint256 saleId, uint256 amount) external payable whenNotPaused {
895         address seller = saleOrderList[saleId].seller;
896         // Check whether the saleId is a valid sale order
897         require(seller != address(0));
898 
899         // Check the sender isn't the seller
900         require(msg.sender != seller);
901 
902         require(saleOrderList[saleId].amount >= uint64(amount));
903 
904         // Check whether pay value is enough
905         require(msg.value / saleOrderList[saleId].desiredPrice >= amount);
906 
907         uint256 totalprice = amount * saleOrderList[saleId].desiredPrice;
908 
909         uint64 assetId = saleOrderList[saleId].assetId;
910 
911         uint256 assetFloor = assetId / 31;
912         uint256 assetPos = assetId - 31 * assetFloor;
913         bytes32 allAsset = assets[msg.sender][assetFloor];
914 
915         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
916         uint256 maskedValue;
917         uint256 maskedResult;
918         uint256 addAmount = amount << (8 * assetPos);
919 
920         // check whether this account will have too many assets
921         maskedValue = uint256(allAsset & mask);
922         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
923 
924         // Transfer assets to buyer
925         maskedResult = maskedValue + addAmount;
926         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
927 
928         assets[msg.sender][assetFloor] = allAsset;
929 
930         saleOrderList[saleId].amount -= uint64(amount);
931 
932         // Cut and then send the proceeds to seller
933         uint256 sellerProceeds = totalprice - _computeCut(totalprice);
934 
935         seller.transfer(sellerProceeds);
936 
937         // Emit the buy event
938         emit BuyInMarket(msg.sender, saleId, amount);
939 
940         // If the sale has complete, clear this order
941         if (saleOrderList[saleId].amount == 0) {
942             accountToSaleNum[seller] -= 1;
943             delete saleOrderList[saleId];
944 
945             // Emit the clear event
946             emit SaleClear(saleId);
947         }
948     }
949 
950     // Compute the marketCut
951     function _computeCut(uint256 _price) internal view returns (uint256) {
952         return _price / 10000 * trCut;
953     }
954 }
955 
956 
957 contract AlchemyMove is AlchemyMarket {
958 
959     // 
960     bool public isMovingEnable = true;
961 
962     // 
963     function disableMoving() external onlyCOO {
964         isMovingEnable = false;
965     }
966 
967     // move data of player
968     function moveAccountData(address[] accounts, bytes32[] _assets, uint256[] saleNums) external onlyCOO {
969         require(isMovingEnable);
970 
971         uint256 j;
972         address account;
973         for (uint256 i = 0; i < accounts.length; i++) {
974             account = accounts[i];
975             for (j = 0; j < 8; j++) {
976                 assets[account][j] = _assets[j + 8*i];
977             }
978 
979             accountToSaleNum[account] = saleNums[i];
980         }
981     }
982 
983     function moveFurnaceData(address[] accounts, uint16[] _pendingAssets, uint256[] cooldownTimes, bool[] furnaceState, uint256[] counts) external onlyCOO {
984         require(isMovingEnable);
985 
986         Furnace memory _furnace;
987         uint256 j;
988         address account;
989         for (uint256 i = 0; i < accounts.length; i++) {
990             account = accounts[i];
991 
992             for (j = 0; j < 5; j++) {
993                 _furnace.pendingAssets[j] = _pendingAssets[j + 5*i];
994             }
995             _furnace.cooldownEndTime = cooldownTimes[i];
996             _furnace.inSynthesization = furnaceState[i];
997             _furnace.count = counts[i];
998 
999             accountsToFurnace[account] = _furnace;
1000         }
1001     }
1002 
1003 
1004     function movePatentData(uint16[] ids, address[] owners, uint256[] beginTimes, bool[] onsaleStates, uint256[] prices, uint256[] lastprices, uint256[] selltimes) external onlyCOO {
1005         require(isMovingEnable);
1006         
1007         //Patent memory _patent;
1008         uint16 id;
1009         for (uint256 i = 0; i < ids.length; i++) {
1010             id = ids[i];
1011             /*_patent.patentOwner = owners[i];
1012             _patent.beginTime = beginTimes[i];
1013             _patent.onSale = onsaleStates[i];
1014             _patent.price = prices[i];
1015             _patent.lastPrice = lastprices[i];
1016             _patent.sellTime = selltimes[i];*/
1017             patents[id] = Patent({patentOwner: owners[i], beginTime: beginTimes[i], onSale: onsaleStates[i], price: prices[i], lastPrice: lastprices[i], sellTime: selltimes[i]});
1018         }
1019     }
1020 
1021     function moveMarketData(uint256[] saleIds, uint64[] assetIds, uint64[] amounts, uint128[] desiredPrices, address[] sellers) external onlyCOO {
1022         require(isMovingEnable);
1023         
1024         SaleOrder memory _saleOrder;
1025         uint256 _saleId;
1026         for (uint256 i = 0; i < saleIds.length; i++) {
1027             _saleId = saleIds[i];
1028             _saleOrder.assetId = assetIds[i];
1029             _saleOrder.amount = amounts[i];
1030             _saleOrder.desiredPrice = desiredPrices[i];
1031             _saleOrder.seller = sellers[i];
1032             saleOrderList[_saleId] = _saleOrder;
1033         }
1034     }
1035 
1036     function writeNextId(uint256 _id) external onlyCOO {
1037         require(isMovingEnable);
1038         nextSaleId = _id;
1039     }
1040 }