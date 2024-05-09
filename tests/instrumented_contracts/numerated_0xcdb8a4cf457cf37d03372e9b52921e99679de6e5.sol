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
346 contract AlchemySynthesize is AlchemyPatent {
347 
348     // Synthesize formula
349     ChemistryInterface public chemistry;
350     SkinInterface public skinContract;
351 
352     // Cooldown after submit a after submit a transformation request
353     uint256[9] public cooldownLevels = [
354         5 minutes,
355         10 minutes,
356         15 minutes,
357         20 minutes,
358         25 minutes,
359         30 minutes,
360         35 minutes,
361         40 minutes,
362         45 minutes
363     ];
364 
365     // patent fee for each level 
366     uint256[9] public pFees = [
367         0,
368         10 finney,
369         15 finney,
370         20 finney,
371         25 finney,
372         30 finney,
373         35 finney,
374         40 finney,
375         45 finney
376     ];
377 
378     // alchemy furnace struct
379     struct Furnace {
380         // the pending assets for synthesize
381         uint16[5] pendingAssets;
382         // cooldown end time of synthesise
383         uint256 cooldownEndTime;
384         // whether this furnace is using
385         bool inSynthesization;
386     }
387 
388     // furnace of each account
389     mapping (address => Furnace) public accountsToFurnace;
390 
391     // alchemy level of each asset
392     mapping (uint16 => uint256) public assetLevel;
393 
394     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
395     uint256 public prePaidFee = 1000000 * 3000000000; // (1million gas * 3 gwei)
396 
397     bool public isSynthesizeAllowed = false;
398 
399     // When a synthesization request starts, our daemon needs to call getSynthesizationResult() after cooldown.
400     // event SynthesizeStart(address account);
401     event AutoSynthesize(address account, uint256 cooldownEndTime);
402     event SynthesizeSuccess(address account);
403 
404     // Initialize the asset level
405     function initializeLevel() public onlyCOO {
406         // Level of assets
407         uint8[9] memory levelSplits = [4,     // end of level 0. start of level is 0
408                                           19,    // end of level 1
409                                           46,    // end of level 2
410                                           82,    // end of level 3
411                                           125,   // end of level 4
412                                           156,
413                                           180,
414                                           195,
415                                           198];  // end of level 8
416         uint256 currentLevel = 0;
417         for (uint8 i = 0; i < 198; i ++) {
418             if (i == levelSplits[currentLevel]) {
419                 currentLevel ++;
420             }
421             assetLevel[uint16(i)] = currentLevel;
422         }
423     }
424 
425     function setAssetLevel(uint16 assetId, uint256 level) public onlyCOO {
426         assetLevel[assetId] = level;
427     }
428 
429     function changeSynthesizeAllowed(bool newState) external onlyCOO {
430         isSynthesizeAllowed = newState;
431     }
432 
433     // Get furnace information
434     function getFurnace(address account) public view returns (uint16[5], uint256, bool) {
435         return (accountsToFurnace[account].pendingAssets, accountsToFurnace[account].cooldownEndTime, accountsToFurnace[account].inSynthesization);
436     }
437 
438     // Set chemistry science contract address
439     function setChemistryAddress(address chemistryAddress) external onlyCOO {
440         ChemistryInterface candidateContract = ChemistryInterface(chemistryAddress);
441 
442         require(candidateContract.isChemistry());
443 
444         chemistry = candidateContract;
445     }
446 
447     // Set skin contract address
448     function setSkinContract(address skinAddress) external onlyCOO {
449         skinContract = SkinInterface(skinAddress);
450     }
451 
452     // setPrePaidFee: set advance amount, only owner can call this
453     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
454         prePaidFee = newPrePaidFee;
455     }
456 
457     // _isCooldownReady: check whether cooldown period has been passed
458     function _isCooldownReady(address account) internal view returns (bool) {
459         return (accountsToFurnace[account].cooldownEndTime <= now);
460     }
461 
462     // synthesize: call _isCooldownReady, pending assets, fire SynthesizeStart event
463     function synthesize(uint16[5] inputAssets) public payable whenNotPaused {
464         require(isSynthesizeAllowed == true);
465         // Check msg.sender is not in another synthesizing process
466         require(accountsToFurnace[msg.sender].inSynthesization == false);
467 
468         // Check whether assets are valid
469         bytes32[8] memory asset = assets[msg.sender];
470 
471         bytes32 mask; // 0x11111111
472         uint256 maskedValue;
473         uint256 count;
474         bytes32 _asset;
475         uint256 pos;
476         uint256 maxLevel = 0;
477         uint256 totalFee = 0;
478         uint256 _assetLevel;
479         Patent memory _patent;
480         uint16 currentAsset;
481         
482         for (uint256 i = 0; i < 5; i++) {
483             currentAsset = inputAssets[i];
484             if (currentAsset < 248) {
485                 _asset = asset[currentAsset / 31];
486                 pos = currentAsset % 31;
487                 mask = bytes32(255) << (8 * pos);
488                 maskedValue = uint256(_asset & mask);
489 
490                 require(maskedValue >= (uint256(1) << (8*pos)));
491                 maskedValue -= (uint256(1) << (8*pos));
492                 _asset = ((_asset ^ mask) & _asset) | bytes32(maskedValue); 
493                 asset[currentAsset / 31] = _asset;
494                 count += 1;
495 
496                 // handle patent fee
497                 _assetLevel = assetLevel[currentAsset];
498                 if (_assetLevel > maxLevel) {
499                     maxLevel = _assetLevel;
500                 }
501 
502                 if (_assetLevel > 0) {
503                     _patent = patents[currentAsset];
504                     if (_patent.patentOwner != address(0) && _patent.patentOwner != msg.sender && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
505                         _patent.patentOwner.transfer(pFees[_assetLevel] / 10000 * feeRatio);
506                         totalFee += pFees[_assetLevel];
507                     }
508                 }
509             }
510         }
511 
512         require(msg.value >= prePaidFee + totalFee); 
513 
514         require(count >= 2 && count <= 5);
515 
516         // Check whether cooldown has ends
517         require(_isCooldownReady(msg.sender));
518 
519         uint128 skinType = skinContract.getActiveSkin(msg.sender);
520         uint256 _cooldownTime = chemistry.computeCooldownTime(skinType, cooldownLevels[maxLevel]);
521 
522         accountsToFurnace[msg.sender].pendingAssets = inputAssets;
523         accountsToFurnace[msg.sender].cooldownEndTime = now + _cooldownTime;
524         accountsToFurnace[msg.sender].inSynthesization = true;         
525         assets[msg.sender] = asset;
526 
527         // Emit SnthesizeStart event
528         // SynthesizeStart(msg.sender);
529         emit AutoSynthesize(msg.sender, accountsToFurnace[msg.sender].cooldownEndTime);
530     }
531 
532     function getPatentFee(address account, uint16[5] inputAssets) external view returns (uint256) {
533 
534         uint256 totalFee = 0;
535         uint256 _assetLevel;
536         Patent memory _patent;
537         uint16 currentAsset;
538         
539         for (uint256 i = 0; i < 5; i++) {
540             currentAsset = inputAssets[i];
541             if (currentAsset < 248) {
542 
543                 // handle patent fee
544                 _assetLevel = assetLevel[currentAsset];
545                 if (_assetLevel > 0) {
546                     _patent = patents[currentAsset];
547                     if (_patent.patentOwner != address(0) && _patent.patentOwner != account && !_patent.onSale && (_patent.beginTime + patentValidTime > now)) {
548                         totalFee += pFees[_assetLevel];
549                     }
550                 }
551             }
552         }
553         return totalFee;
554     }
555 
556     // getSynthesizationResult: auto synthesize daemin call this. if cooldown time has passed, give final result
557     // Anyone can call this function, if they are willing to pay the gas
558     function getSynthesizationResult(address account) external whenNotPaused {
559 
560         // Make sure this account is in synthesization
561         require(accountsToFurnace[account].inSynthesization);
562 
563         // Make sure the cooldown has ends
564         require(_isCooldownReady(account));
565 
566         // Get result using pending assets        
567         uint16[5] memory _pendingAssets = accountsToFurnace[account].pendingAssets;
568         uint128 skinType = skinContract.getActiveSkin(account);
569         uint16[5] memory resultAssets = chemistry.turnOnFurnace(_pendingAssets, skinType);
570 
571         // Write result
572         bytes32[8] memory asset = assets[account];
573 
574         bytes32 mask; // 0x11111111
575         uint256 maskedValue;
576         uint256 j;
577         uint256 pos;   
578 
579         for (uint256 i = 0; i < 5; i++) {
580             if (resultAssets[i] < 248) {
581                 j = resultAssets[i] / 31;
582                 pos = resultAssets[i] % 31;
583                 mask = bytes32(255) << (8 * pos);
584                 maskedValue = uint256(asset[j] & mask);
585 
586                 require(maskedValue < (uint256(255) << (8*pos)));
587                 maskedValue += (uint256(1) << (8*pos));
588                 asset[j] = ((asset[j] ^ mask) & asset[j]) | bytes32(maskedValue); 
589 
590                 // handle patent
591                 if (resultAssets[i] > 3 && patents[resultAssets[i]].patentOwner == address(0)) {
592                     patents[resultAssets[i]] = Patent({patentOwner: account,
593                                                        beginTime: now,
594                                                        onSale: false,
595                                                        price: 0,
596                                                        lastPrice: 10 finney,
597                                                        sellTime: 0});
598                     // Emit the event
599                     emit RegisterCreator(account, resultAssets[i]);
600                 }
601             }
602         }
603 
604         // Mark this synthesization as finished
605         accountsToFurnace[account].inSynthesization = false;
606         assets[account] = asset;
607 
608         emit SynthesizeSuccess(account);
609     }
610 }
611 
612 
613 
614 contract ChemistryInterface {
615     function isChemistry() public pure returns (bool);
616 
617     // function turnOnFurnace(bytes32 x0, bytes32 x1, bytes32 x2, bytes32 x3) public returns (bytes32 r0, bytes32 r1, bytes32 r2, bytes32 r3);
618     function turnOnFurnace(uint16[5] inputAssets, uint128 addition) public returns (uint16[5]);
619 
620     function computeCooldownTime(uint128 typeAdd, uint256 baseTime) public returns (uint256);
621 }
622 
623 
624 contract SkinInterface {
625     function getActiveSkin(address account) public view returns (uint128);
626 }
627 
628 
629 contract AlchemyMinting is AlchemySynthesize {
630 
631     // Limit the nubmer of zero order assets the owner can create every day
632     uint256 public zoDailyLimit = 2500; // we can create 4 * 2500 = 10000 0-order asset each day
633     uint256[4] public zoCreated;
634     
635     // Limit the number each account can buy every day
636     mapping(address => bytes32) public accountsBoughtZoAsset;
637     mapping(address => uint256) public accountsZoLastRefreshTime;
638 
639     // Price of zero order assets
640     uint256 public zoPrice = 1 finney;
641 
642     // Last daily limit refresh time
643     uint256 public zoLastRefreshTime = now;
644 
645     // Event
646     event BuyZeroOrderAsset(address account, bytes32 values);
647 
648     // To ensure scarcity, we are unable to change the max numbers of zo assets every day.
649     // We are only able to modify the price
650     function setZoPrice(uint256 newPrice) external onlyCOO {
651         zoPrice = newPrice;
652     }
653 
654     // Buy zo assets from us
655     function buyZoAssets(bytes32 values) external payable whenNotPaused {
656         // Check whether we need to refresh the daily limit
657         bytes32 history = accountsBoughtZoAsset[msg.sender];
658         if (accountsZoLastRefreshTime[msg.sender] == uint256(0)) {
659             // This account's first time to buy zo asset, we do not need to clear accountsBoughtZoAsset
660             accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
661         } else {
662             if (accountsZoLastRefreshTime[msg.sender] < zoLastRefreshTime) {
663                 history = bytes32(0);
664                 accountsZoLastRefreshTime[msg.sender] = zoLastRefreshTime;
665             }
666         }
667  
668         uint256 currentCount = 0;
669         uint256 count = 0;
670 
671         bytes32 mask = bytes32(255); // 0x11111111
672         uint256 maskedValue;
673         uint256 maskedResult;
674 
675         bytes32 asset = assets[msg.sender][0];
676 
677         for (uint256 i = 0; i < 4; i++) {
678             if (i > 0) {
679                 mask = mask << 8;
680             }
681             maskedValue = uint256(values & mask);
682             currentCount = maskedValue / 2 ** (8 * i);
683             count += currentCount;
684 
685             // Check whether this account has bought too many assets
686             maskedResult = uint256(history & mask); 
687             maskedResult += maskedValue;
688             require(maskedResult < (2 ** (8 * (i + 1))));
689 
690             // Update account bought history
691             history = ((history ^ mask) & history) | bytes32(maskedResult);
692 
693             // Check whether this account will have too many assets
694             maskedResult = uint256(asset & mask);
695             maskedResult += maskedValue;
696             require(maskedResult < (2 ** (8 * (i + 1))));
697 
698             // Update user asset
699             asset = ((asset ^ mask) & asset) | bytes32(maskedResult);
700 
701             // Check whether we have enough assets to sell
702             require(zoCreated[i] + currentCount <= zoDailyLimit);
703 
704             // Update our creation history
705             zoCreated[i] += currentCount;
706         }
707 
708         // Ensure this account buy at least one zo asset
709         require(count > 0);
710 
711         // Check whether there are enough money for payment
712         require(msg.value >= count * zoPrice);
713 
714         // Write updated user asset
715         assets[msg.sender][0] = asset;
716 
717         // Write updated history
718         accountsBoughtZoAsset[msg.sender] = history;
719         
720         // Emit BuyZeroOrderAsset event
721         emit BuyZeroOrderAsset(msg.sender, values);
722 
723     }
724 
725     // Our daemon will refresh daily limit
726     function clearZoDailyLimit() external onlyCOO {
727         uint256 nextDay = zoLastRefreshTime + 1 days;
728         if (now > nextDay) {
729             zoLastRefreshTime = nextDay;
730             for (uint256 i = 0; i < 4; i++) {
731                 zoCreated[i] =0;
732             }
733         }
734     }
735 }
736 
737 contract AlchemyMarket is AlchemyMinting {
738 
739     // Sale order struct
740     struct SaleOrder {
741         // Asset id to be sold
742         uint64 assetId;
743         // Sale amount
744         uint64 amount;
745         // Desired price
746         uint128 desiredPrice;
747         // Seller
748         address seller; 
749     }
750 
751     // Max number of sale orders of each account 
752     uint128 public maxSaleNum = 20;
753 
754     // Cut ratio for a transaction
755     // Values 0-10,000 map to 0%-100%
756     uint256 public trCut = 275;
757 
758     // Next sale id
759     uint256 public nextSaleId = 1;
760 
761     // Sale orders list 
762     mapping (uint256 => SaleOrder) public saleOrderList;
763 
764     // Sale information of each account
765     mapping (address => uint256) public accountToSaleNum;
766 
767     // events
768     event PutOnSale(address account, uint256 saleId);
769     event WithdrawSale(address account, uint256 saleId);
770     event ChangeSale(address account, uint256 saleId);
771     event BuyInMarket(address buyer, uint256 saleId, uint256 amount);
772     event SaleClear(uint256 saleId);
773 
774     // functions
775     function setTrCut(uint256 newCut) public onlyCOO {
776         trCut = newCut;
777     }
778 
779     // Put asset on sale
780     function putOnSale(uint256 assetId, uint256 amount, uint256 price) external whenNotPaused {
781         // One account can have no more than maxSaleNum sale orders
782         require(accountToSaleNum[msg.sender] < maxSaleNum);
783 
784         // check whether zero order asset is to be sold 
785         // which is not allowed
786         require(assetId > 3 && assetId < 248);
787         require(amount > 0 && amount < 256);
788 
789         uint256 assetFloor = assetId / 31;
790         uint256 assetPos = assetId - 31 * assetFloor;
791         bytes32 allAsset = assets[msg.sender][assetFloor];
792 
793         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
794         uint256 maskedValue;
795         uint256 maskedResult;
796         uint256 addAmount = amount << (8 * assetPos);
797 
798         // check whether there are enough unpending assets to sell
799         maskedValue = uint256(allAsset & mask);
800         require(addAmount <= maskedValue);
801 
802         // Remove assets to be sold from owner
803         maskedResult = maskedValue - addAmount;
804         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
805 
806         assets[msg.sender][assetFloor] = allAsset;
807 
808         // Put on sale
809         SaleOrder memory saleorder = SaleOrder(
810             uint64(assetId),
811             uint64(amount),
812             uint128(price),
813             msg.sender
814         );
815 
816         saleOrderList[nextSaleId] = saleorder;
817         nextSaleId += 1;
818 
819         accountToSaleNum[msg.sender] += 1;
820 
821         // Emit the Approval event
822         emit PutOnSale(msg.sender, nextSaleId-1);
823     }
824   
825     // Withdraw an sale order
826     function withdrawSale(uint256 saleId) external whenNotPaused {
827         // Can only withdraw self's sale order
828         require(saleOrderList[saleId].seller == msg.sender);
829 
830         uint256 assetId = uint256(saleOrderList[saleId].assetId);
831         uint256 assetFloor = assetId / 31;
832         uint256 assetPos = assetId - 31 * assetFloor;
833         bytes32 allAsset = assets[msg.sender][assetFloor];
834 
835         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
836         uint256 maskedValue;
837         uint256 maskedResult;
838         uint256 addAmount = uint256(saleOrderList[saleId].amount) << (8 * assetPos);
839 
840         // check whether this account will have too many assets
841         maskedValue = uint256(allAsset & mask);
842         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
843 
844         // Retransfer asset to be sold from owner
845         maskedResult = maskedValue + addAmount;
846         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
847 
848         assets[msg.sender][assetFloor] = allAsset;
849 
850         // Delete sale order
851         delete saleOrderList[saleId];
852 
853         accountToSaleNum[msg.sender] -= 1;
854 
855         // Emit the cancel event
856         emit WithdrawSale(msg.sender, saleId);
857     }
858  
859 //     // Change sale order
860 //     function changeSale(uint256 assetId, uint256 amount, uint256 price, uint256 saleId) external whenNotPaused {
861 //         // Check if msg sender is the seller
862 //         require(msg.sender == saleOrderList[saleId].seller);
863 // 
864 //     }
865  
866     // Buy assets in market
867     function buyInMarket(uint256 saleId, uint256 amount) external payable whenNotPaused {
868         address seller = saleOrderList[saleId].seller;
869         // Check whether the saleId is a valid sale order
870         require(seller != address(0));
871 
872         // Check the sender isn't the seller
873         require(msg.sender != seller);
874 
875         require(saleOrderList[saleId].amount >= uint64(amount));
876 
877         // Check whether pay value is enough
878         require(msg.value / saleOrderList[saleId].desiredPrice >= amount);
879 
880         uint256 totalprice = amount * saleOrderList[saleId].desiredPrice;
881 
882         uint64 assetId = saleOrderList[saleId].assetId;
883 
884         uint256 assetFloor = assetId / 31;
885         uint256 assetPos = assetId - 31 * assetFloor;
886         bytes32 allAsset = assets[msg.sender][assetFloor];
887 
888         bytes32 mask = bytes32(255) << (8 * assetPos); // 0x11111111
889         uint256 maskedValue;
890         uint256 maskedResult;
891         uint256 addAmount = amount << (8 * assetPos);
892 
893         // check whether this account will have too many assets
894         maskedValue = uint256(allAsset & mask);
895         require(addAmount + maskedValue < 2**(8 * (assetPos + 1)));
896 
897         // Transfer assets to buyer
898         maskedResult = maskedValue + addAmount;
899         allAsset = ((allAsset ^ mask) & allAsset) | bytes32(maskedResult);
900 
901         assets[msg.sender][assetFloor] = allAsset;
902 
903         saleOrderList[saleId].amount -= uint64(amount);
904 
905         // Cut and then send the proceeds to seller
906         uint256 sellerProceeds = totalprice - _computeCut(totalprice);
907 
908         seller.transfer(sellerProceeds);
909 
910         // Emit the buy event
911         emit BuyInMarket(msg.sender, saleId, amount);
912 
913         // If the sale has complete, clear this order
914         if (saleOrderList[saleId].amount == 0) {
915             accountToSaleNum[seller] -= 1;
916             delete saleOrderList[saleId];
917 
918             // Emit the clear event
919             emit SaleClear(saleId);
920         }
921     }
922 
923     // Compute the marketCut
924     function _computeCut(uint256 _price) internal view returns (uint256) {
925         return _price / 10000 * trCut;
926     }
927 }