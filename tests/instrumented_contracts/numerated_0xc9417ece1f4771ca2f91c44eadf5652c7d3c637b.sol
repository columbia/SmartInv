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
119 
120 contract AlchemyBase is Manager {
121 
122     // Assets of each account
123     mapping (address => bytes32[8]) assets;
124 
125     // Event
126     event Transfer(address from, address to);
127 
128     // Get all assets of a particular account
129     function assetOf(address account) public view returns(bytes32[8]) {
130         return assets[account];
131     }
132 
133     function _checkAndAdd(bytes32 x, bytes32 y) internal pure returns(bytes32) {
134         bytes32 mask = bytes32(255); // 0x11111111
135 
136         bytes32 result;
137 
138         uint maskedX;
139         uint maskedY;
140         uint maskedResult;
141 
142         for (uint i = 0; i < 31; i++) {
143             // Get current mask
144             if (i > 0) {
145                 mask = mask << 8;
146             }
147 
148             // Get masked values
149             maskedX = uint(x & mask);
150             maskedY = uint(y & mask);
151             maskedResult = maskedX + maskedY;
152 
153             // Prevent overflow
154             require(maskedResult < (2 ** (8 * (i + 1))));
155 
156             // Clear result digits in masked position
157             result = (result ^ mask) & result;
158 
159             // Write to result
160             result = result | bytes32(maskedResult);
161         }
162 
163         return result;
164     }
165 
166     function _checkAndSub(bytes32 x, bytes32 y) internal pure returns(bytes32) {
167         bytes32 mask = bytes32(255); // 0x11111111
168 
169         bytes32 result;
170 
171         uint maskedX;
172         uint maskedY;
173         uint maskedResult;
174 
175         for (uint i = 0; i < 31; i++) {
176             // Get current mask
177             if (i > 0) {
178                 mask = mask << 8;
179             }
180 
181             // Get masked values
182             maskedX = uint(x & mask);
183             maskedY = uint(y & mask);
184 
185             // Ensure x >= y
186             require(maskedX >= maskedY);
187 
188             // Calculate result
189             maskedResult = maskedX - maskedY;
190 
191             // Clear result digits in masked position
192             result = (result ^ mask) & result;
193 
194             // Write to result
195             result = result | bytes32(maskedResult);
196         }
197 
198         return result;
199     }
200 
201     // Transfer assets from one account to another
202     function transfer(address to, bytes32[8] value) public whenNotPaused whenTransferAllowed {
203         // One can not transfer assets to self
204         require(msg.sender != to);
205         bytes32[8] memory assetFrom = assets[msg.sender];
206         bytes32[8] memory assetTo = assets[to];
207 
208         for (uint256 i = 0; i < 8; i++) {
209             assetFrom[i] = _checkAndSub(assetFrom[i], value[i]);
210             assetTo[i] = _checkAndAdd(assetTo[i], value[i]);
211         }
212 
213         assets[msg.sender] = assetFrom;
214         assets[to] = assetTo;
215 
216         // Emit the transfer event
217         emit Transfer(msg.sender, to);
218     }
219 
220     // Withdraw ETH to the owner account. Ownable-->Pausable-->AlchemyBase
221     function withdrawETH() external onlyCAO {
222         cfo.transfer(address(this).balance);
223     }
224 }
225 
226 
227 contract AlchemyPatent is AlchemyBase {
228 
229     // patent struct
230     struct Patent {
231         // current patent owner
232         address patentOwner;
233         // the time when owner get the patent
234         uint256 beginTime;
235         // whether this patent is on sale
236         bool onSale; 
237         // the sale price
238         uint256 price;
239         // last deal price
240         uint256 lastPrice;
241         // the time when this sale is put on
242         uint256 sellTime;
243     }
244 
245     // Creator of each kind of asset
246     mapping (uint16 => Patent) public patents;
247 
248     // patent fee ratio
249     // Values 0-10,000 map to 0%-100%
250     uint256 public feeRatio = 9705;
251 
252     uint256 public patentValidTime = 2 days;
253     uint256 public patentSaleTimeDelay = 2 hours;
254 
255     // Event
256     event RegisterCreator(address account, uint16 kind);
257     event SellPatent(uint16 assetId, uint256 sellPrice);
258     event ChangePatentSale(uint16 assetId, uint256 newPrice);
259     event BuyPatent(uint16 assetId, address buyer);
260 
261     // set the patent fee ratio
262     function setPatentFee(uint256 newFeeRatio) external onlyCOO {
263         require(newFeeRatio <= 10000);
264         feeRatio = newFeeRatio;
265     }
266 
267     // sell the patent
268     function sellPatent(uint16 assetId, uint256 sellPrice) public whenNotPaused {
269         Patent memory patent = patents[assetId];
270         require(patent.patentOwner == msg.sender);
271         require(sellPrice <= 2 * patent.lastPrice);
272         require(!patent.onSale);
273 
274         patent.onSale = true;
275         patent.price = sellPrice;
276         patent.sellTime = now;
277 
278         patents[assetId] = patent;
279 
280         // Emit the event
281         emit SellPatent(assetId, sellPrice);
282     }
283 
284     function publicSell(uint16 assetId) public whenNotPaused {
285         Patent memory patent = patents[assetId];
286         require(patent.patentOwner != address(0));  // this is a valid patent
287         require(!patent.onSale);
288         require(patent.beginTime + patentValidTime < now);
289 
290         patent.onSale = true;
291         patent.price = patent.lastPrice;
292         patent.sellTime = now;
293 
294         patents[assetId] = patent;
295 
296         // Emit the event
297         emit SellPatent(assetId, patent.lastPrice);
298     }
299 
300     // change sell price
301     function changePatentSale(uint16 assetId, uint256 newPrice) external whenNotPaused {
302         Patent memory patent = patents[assetId];
303         require(patent.patentOwner == msg.sender);
304         require(newPrice <= 2 * patent.lastPrice);
305         require(patent.onSale == true);
306 
307         patent.price = newPrice;
308 
309         patents[assetId] = patent;
310 
311         // Emit the event
312         emit ChangePatentSale(assetId, newPrice);
313     }
314 
315     // buy patent
316     function buyPatent(uint16 assetId) external payable whenNotPaused {
317         Patent memory patent = patents[assetId];
318         require(patent.patentOwner != address(0));  // this is a valid patent
319         require(patent.patentOwner != msg.sender);
320         require(patent.onSale);
321         require(msg.value >= patent.price);
322         require(now >= patent.sellTime + patentSaleTimeDelay);
323 
324         patent.patentOwner.transfer(patent.price / 10000 * feeRatio);
325         patent.patentOwner = msg.sender;
326         patent.beginTime = now;
327         patent.onSale = false;
328         patent.lastPrice = patent.price;
329 
330         patents[assetId] = patent;
331 
332         //Emit the event
333         emit BuyPatent(assetId, msg.sender);
334     }
335 }
336 
337 contract ChemistryInterface {
338     function isChemistry() public pure returns (bool);
339 
340     // function turnOnFurnace(bytes32 x0, bytes32 x1, bytes32 x2, bytes32 x3) public returns (bytes32 r0, bytes32 r1, bytes32 r2, bytes32 r3);
341     function turnOnFurnace(uint16[5] inputAssets, uint128 addition) public returns (uint16[5]);
342 
343     function computeCooldownTime(uint128 typeAdd, uint256 baseTime) public returns (uint256);
344 }
345 
346 
347 
348 contract SkinInterface {
349     function getActiveSkin(address account) public view returns (uint128);
350 }
351 
352 
353 
354 contract AlchemySynthesize is AlchemyPatent {
355 
356     // Synthesize formula
357     ChemistryInterface public chemistry;
358     SkinInterface public skinContract;
359 
360     // Cooldown after submit a after submit a transformation request
361     uint256[9] public cooldownLevels = [
362         5 minutes,
363         10 minutes,
364         15 minutes,
365         20 minutes,
366         25 minutes,
367         30 minutes,
368         35 minutes,
369         40 minutes,
370         45 minutes
371     ];
372 
373     // patent fee for each level 
374     uint256[9] public pFees = [
375         0,
376         10 finney,
377         15 finney,
378         20 finney,
379         25 finney,
380         30 finney,
381         35 finney,
382         40 finney,
383         45 finney
384     ];
385 
386     // alchemy furnace struct
387     struct Furnace {
388         // the pending assets for synthesize
389         uint16[5] pendingAssets;
390         // cooldown end time of synthesise
391         uint256 cooldownEndTime;
392         // whether this furnace is using
393         bool inSynthesization;
394     }
395 
396     // furnace of each account
397     mapping (address => Furnace) public accountsToFurnace;
398 
399     // alchemy level of each asset
400     mapping (uint16 => uint256) public assetLevel;
401 
402     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
403     uint256 public prePaidFee = 1000000 * 3000000000; // (1million gas * 3 gwei)
404 
405     bool public isSynthesizeAllowed = false;
406 
407     // When a synthesization request starts, our daemon needs to call getSynthesizationResult() after cooldown.
408     // event SynthesizeStart(address account);
409     event AutoSynthesize(address account, uint256 cooldownEndTime);
410     event SynthesizeSuccess(address account);
411 
412     // Initialize the asset level
413     function initializeLevel() public onlyCOO {
414         // Level of assets
415         uint8[9] memory levelSplits = [4,     // end of level 0. start of level is 0
416                                           19,    // end of level 1
417                                           46,    // end of level 2
418                                           82,    // end of level 3
419                                           125,   // end of level 4
420                                           156,
421                                           180,
422                                           195,
423                                           198];  // end of level 8
424         uint256 currentLevel = 0;
425         for (uint8 i = 0; i < 198; i ++) {
426             if (i == levelSplits[currentLevel]) {
427                 currentLevel ++;
428             }
429             assetLevel[uint16(i)] = currentLevel;
430         }
431     }
432 
433     function setAssetLevel(uint16 assetId, uint256 level) public onlyCOO {
434         assetLevel[assetId] = level;
435     }
436 
437     function changeSynthesizeAllowed(bool newState) external onlyCOO {
438         isSynthesizeAllowed = newState;
439     }
440 
441     // Get furnace information
442     function getFurnace(address account) public view returns (uint16[5], uint256, bool) {
443         return (accountsToFurnace[account].pendingAssets, accountsToFurnace[account].cooldownEndTime, accountsToFurnace[account].inSynthesization);
444     }
445 
446     // Set chemistry science contract address
447     function setChemistryAddress(address chemistryAddress) external onlyCOO {
448         ChemistryInterface candidateContract = ChemistryInterface(chemistryAddress);
449 
450         require(candidateContract.isChemistry());
451 
452         chemistry = candidateContract;
453     }
454 
455     // Set skin contract address
456     function setSkinContract(address skinAddress) external onlyCOO {
457         skinContract = SkinInterface(skinAddress);
458     }
459 
460     // setPrePaidFee: set advance amount, only owner can call this
461     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
462         prePaidFee = newPrePaidFee;
463     }
464 
465     // _isCooldownReady: check whether cooldown period has been passed
466     function _isCooldownReady(address account) internal view returns (bool) {
467         return (accountsToFurnace[account].cooldownEndTime <= now);
468     }
469 
470     // synthesize: call _isCooldownReady, pending assets, fire SynthesizeStart event
471     function synthesize(uint16[5] inputAssets) public payable whenNotPaused {
472         require(isSynthesizeAllowed == true);
473         // Check msg.sender is not in another synthesizing process
474         require(accountsToFurnace[msg.sender].inSynthesization == false);
475 
476         // Check whether assets are valid
477         bytes32[8] memory asset = assets[msg.sender];
478 
479         bytes32 mask; // 0x11111111
480         uint256 maskedValue;
481         uint256 count;
482         bytes32 _asset;
483         uint256 pos;
484         uint256 maxLevel = 0;
485         uint256 totalFee = 0;
486         uint256 _assetLevel;
487         Patent memory _patent;
488         uint16 currentAsset;
489         
490         for (uint256 i = 0; i < 5; i++) {
491             currentAsset = inputAssets[i];
492             if (currentAsset < 248) {
493                 _asset = asset[currentAsset / 31];
494                 pos = currentAsset % 31;
495                 mask = bytes32(255) << (8 * pos);
496                 maskedValue = uint256(_asset & mask);
497 
498                 require(maskedValue >= (uint256(1) << (8*pos)));
499                 maskedValue -= (uint256(1) << (8*pos));
500                 _asset = ((_asset ^ mask) & _asset) | bytes32(maskedValue); 
501                 asset[currentAsset / 31] = _asset;
502                 count += 1;
503 
504                 // handle patent fee
505                 _assetLevel = assetLevel[currentAsset];
506                 if (_assetLevel > maxLevel) {
507                     maxLevel = _assetLevel;
508                 }
509 
510                 if (_assetLevel > 0) {
511                     _patent = patents[currentAsset];
512                     if (_patent.patentOwner != address(0) && _patent.patentOwner != msg.sender && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
513                         _patent.patentOwner.transfer(pFees[_assetLevel] / 10000 * feeRatio);
514                         totalFee += pFees[_assetLevel];
515                     }
516                 }
517             }
518         }
519 
520         require(msg.value >= prePaidFee + totalFee); 
521 
522         require(count >= 2 && count <= 5);
523 
524         // Check whether cooldown has ends
525         require(_isCooldownReady(msg.sender));
526 
527         uint128 skinType = skinContract.getActiveSkin(msg.sender);
528         uint256 _cooldownTime = chemistry.computeCooldownTime(skinType, cooldownLevels[maxLevel]);
529 
530         accountsToFurnace[msg.sender].pendingAssets = inputAssets;
531         accountsToFurnace[msg.sender].cooldownEndTime = now + _cooldownTime;
532         accountsToFurnace[msg.sender].inSynthesization = true;         
533         assets[msg.sender] = asset;
534 
535         // Emit SnthesizeStart event
536         // SynthesizeStart(msg.sender);
537         emit AutoSynthesize(msg.sender, accountsToFurnace[msg.sender].cooldownEndTime);
538     }
539 
540     function getPatentFee(address account, uint16[5] inputAssets) external view returns (uint256) {
541 
542         uint256 totalFee = 0;
543         uint256 _assetLevel;
544         Patent memory _patent;
545         uint16 currentAsset;
546         
547         for (uint256 i = 0; i < 5; i++) {
548             currentAsset = inputAssets[i];
549             if (currentAsset < 248) {
550 
551                 // handle patent fee
552                 _assetLevel = assetLevel[currentAsset];
553                 if (_assetLevel > 0) {
554                     _patent = patents[currentAsset];
555                     if (_patent.patentOwner != address(0) && _patent.patentOwner != account && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
556                         totalFee += pFees[_assetLevel];
557                     }
558                 }
559             }
560         }
561         return totalFee;
562     }
563 
564     // getSynthesizationResult: auto synthesize daemin call this. if cooldown time has passed, give final result
565     // Anyone can call this function, if they are willing to pay the gas
566     function getSynthesizationResult(address account) external whenNotPaused {
567 
568         // Make sure this account is in synthesization
569         require(accountsToFurnace[account].inSynthesization);
570 
571         // Make sure the cooldown has ends
572         require(_isCooldownReady(account));
573 
574         // Get result using pending assets        
575         uint16[5] memory _pendingAssets = accountsToFurnace[account].pendingAssets;
576         uint128 skinType = skinContract.getActiveSkin(account);
577         uint16[5] memory resultAssets = chemistry.turnOnFurnace(_pendingAssets, skinType);
578 
579         // Write result
580         bytes32[8] memory asset = assets[account];
581 
582         bytes32 mask; // 0x11111111
583         uint256 maskedValue;
584         uint256 j;
585         uint256 pos;   
586 
587         for (uint256 i = 0; i < 5; i++) {
588             if (resultAssets[i] < 248) {
589                 j = resultAssets[i] / 31;
590                 pos = resultAssets[i] % 31;
591                 mask = bytes32(255) << (8 * pos);
592                 maskedValue = uint256(asset[j] & mask);
593 
594                 require(maskedValue < (uint256(255) << (8*pos)));
595                 maskedValue += (uint256(1) << (8*pos));
596                 asset[j] = ((asset[j] ^ mask) & asset[j]) | bytes32(maskedValue); 
597 
598                 // handle patent
599                 if (resultAssets[i] > 3 && patents[resultAssets[i]].patentOwner == address(0)) {
600                     patents[resultAssets[i]] = Patent({patentOwner: account,
601                                                        beginTime: now,
602                                                        onSale: false,
603                                                        price: 0,
604                                                        lastPrice: 10 finney,
605                                                        sellTime: 0});
606                     // Emit the event
607                     emit RegisterCreator(account, resultAssets[i]);
608                 }
609             }
610         }
611 
612         // Mark this synthesization as finished
613         accountsToFurnace[account].inSynthesization = false;
614         assets[account] = asset;
615 
616         emit SynthesizeSuccess(account);
617     }
618 }
619 
620 contract AlchemyMinting is AlchemySynthesize {
621 
622     // Limit the nubmer of zero order assets the owner can create every day
623     uint256 public zoDailyLimit = 2500; // we can create 4 * 2500 = 10000 0-order asset each day
624     uint256[4] public zoCreated;
625     
626     // Limit the number each account can buy every day
627     mapping(address => bytes32) public accountsBoughtZoAsset;
628     mapping(address => uint256) public accountsZoLastRefreshTime;
629 
630     // Price of zero order assets
631     uint256 public zoPrice = 1 finney;
632 
633     // Last daily limit refresh time
634     uint256 public zoLastRefreshTime = now;
635 
636     // Event
637     event BuyZeroOrderAsset(address account, bytes32 values);
638 
639     // To ensure scarcity, we are unable to change the max numbers of zo assets every day.
640     // We are only able to modify the price
641     function setZoPrice(uint256 newPrice) external onlyCOO {
642         zoPrice = newPrice;
643     }
644 
645     // Buy zo assets from us
646     function buyZoAssets(bytes32 values) external payable whenNotPaused {
647         // Check whether we need to refresh the daily limit
648         bytes32 history = accountsBoughtZoAsset[msg.sender];
649         if (accountsZoLastRefreshTime[msg.sender] == uint256(0)) {
650             // This account's first time to buy zo asset, we do not need to clear accountsBoughtZoAsset
651             accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
652         } else {
653             if (accountsZoLastRefreshTime[msg.sender] < zoLastRefreshTime) {
654                 history = bytes32(0);
655                 accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
656             }
657         }
658  
659         uint256 currentCount = 0;
660         uint256 count = 0;
661 
662         bytes32 mask = bytes32(255); // 0x11111111
663         uint256 maskedValue;
664         uint256 maskedResult;
665 
666         bytes32 asset = assets[msg.sender][0];
667 
668         for (uint256 i = 0; i < 4; i++) {
669             if (i > 0) {
670                 mask = mask << 8;
671             }
672             maskedValue = uint256(values & mask);
673             currentCount = maskedValue / 2 ** (8 * i);
674             count += currentCount;
675 
676             // Check whether this account has bought too many assets
677             maskedResult = uint256(history & mask); 
678             maskedResult += maskedValue;
679             require(maskedResult < (2 ** (8 * (i + 1))));
680 
681             // Update account bought history
682             history = ((history ^ mask) & history) | bytes32(maskedResult);
683 
684             // Check whether this account will have too many assets
685             maskedResult = uint256(asset & mask);
686             maskedResult += maskedValue;
687             require(maskedResult < (2 ** (8 * (i + 1))));
688 
689             // Update user asset
690             asset = ((asset ^ mask) & asset) | bytes32(maskedResult);
691 
692             // Check whether we have enough assets to sell
693             require(zoCreated[i] + currentCount <= zoDailyLimit);
694 
695             // Update our creation history
696             zoCreated[i] += currentCount;
697         }
698 
699         // Ensure this account buy at least one zo asset
700         require(count > 0);
701 
702         // Check whether there are enough money for payment
703         require(msg.value >= count * zoPrice);
704 
705         // Write updated user asset
706         assets[msg.sender][0] = asset;
707 
708         // Write updated history
709         accountsBoughtZoAsset[msg.sender] = history;
710         
711         // Emit BuyZeroOrderAsset event
712         emit BuyZeroOrderAsset(msg.sender, values);
713 
714     }
715 
716     // Our daemon will refresh daily limit
717     function clearZoDailyLimit() external onlyCOO {
718         uint256 nextDay = zoLastRefreshTime + 1 days;
719         if (now > nextDay) {
720             zoLastRefreshTime = nextDay;
721             for (uint256 i = 0; i < 4; i++) {
722                 zoCreated[i] =0;
723             }
724         }
725     }
726 }
727 
728 
729 contract AlchemyMarket is AlchemyMinting {
730 
731     // Sale order struct
732     struct SaleOrder {
733         // Asset id to be sold
734         uint64 assetId;
735         // Sale amount
736         uint64 amount;
737         // Desired price
738         uint128 desiredPrice;
739         // Seller
740         address seller; 
741     }
742 
743     // Max number of sale orders of each account 
744     uint128 public maxSaleNum = 20;
745 
746     // Cut ratio for a transaction
747     // Values 0-10,000 map to 0%-100%
748     uint256 public trCut = 275;
749 
750     // Next sale id
751     uint256 public nextSaleId = 1;
752 
753     // Sale orders list 
754     mapping (uint256 => SaleOrder) public saleOrderList;
755 
756     // Sale information of each account
757     mapping (address => uint256) public accountToSaleNum;
758 
759     // events
760     event PutOnSale(address account, uint256 saleId);
761     event WithdrawSale(address account, uint256 saleId);
762     event ChangeSale(address account, uint256 saleId);
763     event BuyInMarket(address buyer, uint256 saleId, uint256 amount);
764     event SaleClear(uint256 saleId);
765 
766     // functions
767     function setTrCut(uint256 newCut) public onlyCOO {
768         trCut = newCut;
769     }
770 
771     // Put asset on sale
772     function putOnSale(uint256 assetId, uint256 amount, uint256 price) external whenNotPaused {
773         // One account can have no more than maxSaleNum sale orders
774         require(accountToSaleNum[msg.sender] < maxSaleNum);
775 
776         // check whether zero order asset is to be sold 
777         // which is not allowed
778         require(assetId > 3 && assetId < 248);
779         require(amount > 0 && amount < 256);
780 
781         uint256 assetFloor = assetId / 31;
782         uint256 assetPos = assetId - 31 * assetFloor;
783         bytes32 allAsset = assets[msg.sender][assetFloor];
784 
785         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
786         uint256 maskedValue;
787         uint256 maskedResult;
788         uint256 addAmount = amount << (8 * assetPos);
789 
790         // check whether there are enough unpending assets to sell
791         maskedValue = uint256(allAsset & mask);
792         require(addAmount <= maskedValue);
793 
794         // Remove assets to be sold from owner
795         maskedResult = maskedValue - addAmount;
796         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
797 
798         assets[msg.sender][assetFloor] = allAsset;
799 
800         // Put on sale
801         SaleOrder memory saleorder = SaleOrder(
802             uint64(assetId),
803             uint64(amount),
804             uint128(price),
805             msg.sender
806         );
807 
808         saleOrderList[nextSaleId] = saleorder;
809         nextSaleId += 1;
810 
811         accountToSaleNum[msg.sender] += 1;
812 
813         // Emit the Approval event
814         emit PutOnSale(msg.sender, nextSaleId-1);
815     }
816   
817     // Withdraw an sale order
818     function withdrawSale(uint256 saleId) external whenNotPaused {
819         // Can only withdraw self's sale order
820         require(saleOrderList[saleId].seller == msg.sender);
821 
822         uint256 assetId = uint256(saleOrderList[saleId].assetId);
823         uint256 assetFloor = assetId / 31;
824         uint256 assetPos = assetId - 31 * assetFloor;
825         bytes32 allAsset = assets[msg.sender][assetFloor];
826 
827         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
828         uint256 maskedValue;
829         uint256 maskedResult;
830         uint256 addAmount = uint256(saleOrderList[saleId].amount) << (8 * assetPos);
831 
832         // check whether this account will have too many assets
833         maskedValue = uint256(allAsset & mask);
834         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
835 
836         // Retransfer asset to be sold from owner
837         maskedResult = maskedValue + addAmount;
838         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
839 
840         assets[msg.sender][assetFloor] = allAsset;
841 
842         // Delete sale order
843         delete saleOrderList[saleId];
844 
845         accountToSaleNum[msg.sender] -= 1;
846 
847         // Emit the cancel event
848         emit WithdrawSale(msg.sender, saleId);
849     }
850  
851 //     // Change sale order
852 //     function changeSale(uint256 assetId, uint256 amount, uint256 price, uint256 saleId) external whenNotPaused {
853 //         // Check if msg sender is the seller
854 //         require(msg.sender == saleOrderList[saleId].seller);
855 // 
856 //     }
857  
858     // Buy assets in market
859     function buyInMarket(uint256 saleId, uint256 amount) external payable whenNotPaused {
860         address seller = saleOrderList[saleId].seller;
861         // Check whether the saleId is a valid sale order
862         require(seller != address(0));
863 
864         // Check the sender isn't the seller
865         require(msg.sender != seller);
866 
867         require(saleOrderList[saleId].amount >= uint64(amount));
868 
869         // Check whether pay value is enough
870         require(msg.value / saleOrderList[saleId].desiredPrice >= amount);
871 
872         uint256 totalprice = amount * saleOrderList[saleId].desiredPrice;
873 
874         uint64 assetId = saleOrderList[saleId].assetId;
875 
876         uint256 assetFloor = assetId / 31;
877         uint256 assetPos = assetId - 31 * assetFloor;
878         bytes32 allAsset = assets[msg.sender][assetFloor];
879 
880         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
881         uint256 maskedValue;
882         uint256 maskedResult;
883         uint256 addAmount = amount << (8 * assetPos);
884 
885         // check whether this account will have too many assets
886         maskedValue = uint256(allAsset & mask);
887         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
888 
889         // Transfer assets to buyer
890         maskedResult = maskedValue + addAmount;
891         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
892 
893         assets[msg.sender][assetFloor] = allAsset;
894 
895         saleOrderList[saleId].amount -= uint64(amount);
896 
897         // Cut and then send the proceeds to seller
898         uint256 sellerProceeds = totalprice - _computeCut(totalprice);
899 
900         seller.transfer(sellerProceeds);
901 
902         // Emit the buy event
903         emit BuyInMarket(msg.sender, saleId, amount);
904 
905         // If the sale has complete, clear this order
906         if (saleOrderList[saleId].amount == 0) {
907             accountToSaleNum[seller] -= 1;
908             delete saleOrderList[saleId];
909 
910             // Emit the clear event
911             emit SaleClear(saleId);
912         }
913     }
914 
915     // Compute the marketCut
916     function _computeCut(uint256 _price) internal view returns (uint256) {
917         return _price / 10000 * trCut;
918     }
919 }