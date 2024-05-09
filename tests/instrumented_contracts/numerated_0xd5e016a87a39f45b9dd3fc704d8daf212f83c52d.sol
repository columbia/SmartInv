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
119 contract SkinBase is Manager {
120 
121     struct Skin {
122         uint128 appearance;
123         uint64 cooldownEndTime;
124         uint64 mixingWithId;
125     }
126 
127     // All skins, mapping from skin id to skin apprance
128     mapping (uint256 => Skin) skins;
129 
130     // Mapping from skin id to owner
131     mapping (uint256 => address) public skinIdToOwner;
132 
133     // Whether a skin is on sale
134     mapping (uint256 => bool) public isOnSale;
135 
136     // Using 
137     mapping (address => uint256) public accountsToActiveSkin;
138 
139     // Number of all total valid skins
140     // skinId 0 should not correspond to any skin, because skin.mixingWithId==0 indicates not mixing
141     uint256 public nextSkinId = 1;  
142 
143     // Number of skins an account owns
144     mapping (address => uint256) public numSkinOfAccounts;
145 
146     event SkinTransfer(address from, address to, uint256 skinId);
147     event SetActiveSkin(address account, uint256 skinId);
148 
149     // Get the i-th skin an account owns, for off-chain usage only
150     function skinOfAccountById(address account, uint256 id) external view returns (uint256) {
151         uint256 count = 0;
152         uint256 numSkinOfAccount = numSkinOfAccounts[account];
153         require(numSkinOfAccount > 0);
154         require(id < numSkinOfAccount);
155         for (uint256 i = 1; i < nextSkinId; i++) {
156             if (skinIdToOwner[i] == account) {
157                 // This skin belongs to current account
158                 if (count == id) {
159                     // This is the id-th skin of current account, a.k.a, what we need
160                     return i;
161                 } 
162                 count++;
163             }
164         }
165         revert();
166     }
167 
168     // Get skin by id
169     function getSkin(uint256 id) public view returns (uint128, uint64, uint64) {
170         require(id > 0);
171         require(id < nextSkinId);
172         Skin storage skin = skins[id];
173         return (skin.appearance, skin.cooldownEndTime, skin.mixingWithId);
174     }
175 
176     function withdrawETH() external onlyCAO {
177         cfo.transfer(address(this).balance);
178     }
179     
180     function transferP2P(uint256 id, address targetAccount) whenTransferAllowed public {
181         require(skinIdToOwner[id] == msg.sender);
182         require(msg.sender != targetAccount);
183         skinIdToOwner[id] = targetAccount;
184         
185         numSkinOfAccounts[msg.sender] -= 1;
186         numSkinOfAccounts[targetAccount] += 1;
187         
188         // emit event
189         emit SkinTransfer(msg.sender, targetAccount, id);
190     }
191 
192     function _isComplete(uint256 id) internal view returns (bool) {
193         uint128 _appearance = skins[id].appearance;
194         uint128 mask = uint128(65535);
195         uint128 _type = _appearance & mask;
196         uint128 maskedValue;
197         for (uint256 i = 1; i < 8; i++) {
198             mask = mask << 16;
199             maskedValue = (_appearance & mask) >> (16*i);
200             if (maskedValue != _type) {
201                 return false;
202             }
203         } 
204         return true;
205     }
206 
207     function setActiveSkin(uint256 id) public {
208         require(skinIdToOwner[id] == msg.sender);
209         require(_isComplete(id));
210         require(isOnSale[id] == false);
211         require(skins[id].mixingWithId == 0);
212 
213         accountsToActiveSkin[msg.sender] = id;
214         emit SetActiveSkin(msg.sender, id);
215     }
216 
217     function getActiveSkin(address account) public view returns (uint128) {
218         uint256 activeId = accountsToActiveSkin[account];
219         if (activeId == 0) {
220             return uint128(0);
221         }
222         return (skins[activeId].appearance & uint128(65535));
223     }
224 }
225 
226 
227 contract SkinMix is SkinBase {
228 
229     // Mix formula
230     MixFormulaInterface public mixFormula;
231 
232 
233     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
234     uint256 public prePaidFee = 150000 * 5000000000; // (15w gas * 5 gwei)
235 
236     bool public enableMix = false;
237 
238     // Events
239     event MixStart(address account, uint256 skinAId, uint256 skinBId);
240     event AutoMix(address account, uint256 skinAId, uint256 skinBId, uint64 cooldownEndTime);
241     event MixSuccess(address account, uint256 skinId, uint256 skinAId, uint256 skinBId);
242 
243     // Set mix formula contract address 
244     function setMixFormulaAddress(address mixFormulaAddress) external onlyCOO {
245         mixFormula = MixFormulaInterface(mixFormulaAddress);
246     }
247 
248     // setPrePaidFee: set advance amount, only owner can call this
249     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
250         prePaidFee = newPrePaidFee;
251     }
252 
253     function changeMixEnable(bool newState) external onlyCOO {
254         enableMix = newState;
255     }
256 
257     // _isCooldownReady: check whether cooldown period has been passed
258     function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {
259         return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));
260     }
261 
262     // _isNotMixing: check whether two skins are in another mixing process
263     function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {
264         return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);
265     }
266 
267     // _setCooldownTime: set new cooldown time
268     function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {
269         uint256 end = now + 20 minutes;
270         // uint256 end = now;
271         skins[skinAId].cooldownEndTime = uint64(end);
272         skins[skinBId].cooldownEndTime = uint64(end);
273     }
274 
275     // _isValidSkin: whether an account can mix using these skins
276     // Make sure two things:
277     // 1. these two skins do exist
278     // 2. this account owns these skins
279     function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {
280         // Make sure those two skins belongs to this account
281         if (skinAId == skinBId) {
282             return false;
283         }
284         if ((skinAId == 0) || (skinBId == 0)) {
285             return false;
286         }
287         if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {
288             return false;
289         }
290         if (accountsToActiveSkin[account] == skinAId || accountsToActiveSkin[account] == skinBId) {
291             return false;
292         }
293         return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);
294     }
295 
296     // _isNotOnSale: whether a skin is not on sale
297     function _isNotOnSale(uint256 skinId) private view returns (bool) {
298         return (isOnSale[skinId] == false);
299     }
300 
301     // mix  
302     function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {
303 
304         require(enableMix == true);
305         // Check whether skins are valid
306         require(_isValidSkin(msg.sender, skinAId, skinBId));
307 
308         // Check whether skins are neither on sale
309         require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));
310 
311         // Check cooldown
312         require(_isCooldownReady(skinAId, skinBId));
313 
314         // Check these skins are not in another process
315         require(_isNotMixing(skinAId, skinBId));
316 
317         // Set new cooldown time
318         _setCooldownEndTime(skinAId, skinBId);
319 
320         // Mark skins as in mixing
321         skins[skinAId].mixingWithId = uint64(skinBId);
322         skins[skinBId].mixingWithId = uint64(skinAId);
323 
324         // Emit MixStart event
325         emit MixStart(msg.sender, skinAId, skinBId);
326     }
327 
328     // Mixing auto
329     function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {
330         require(msg.value >= prePaidFee);
331 
332         mix(skinAId, skinBId);
333 
334         Skin storage skin = skins[skinAId];
335 
336         emit AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);
337     }
338 
339     // Get mixing result, return the resulted skin id
340     function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {
341         // Check these two skins belongs to the same account
342         address account = skinIdToOwner[skinAId];
343         require(account == skinIdToOwner[skinBId]);
344 
345         // Check these two skins are in the same mixing process
346         Skin storage skinA = skins[skinAId];
347         Skin storage skinB = skins[skinBId];
348         require(skinA.mixingWithId == uint64(skinBId));
349         require(skinB.mixingWithId == uint64(skinAId));
350 
351         // Check cooldown
352         require(_isCooldownReady(skinAId, skinBId));
353 
354         // Create new skin
355         uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance, getActiveSkin(account));
356         Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
357         skins[nextSkinId] = newSkin;
358         skinIdToOwner[nextSkinId] = account;
359         isOnSale[nextSkinId] = false;
360         nextSkinId++;
361 
362         // Clear old skins
363         skinA.mixingWithId = 0;
364         skinB.mixingWithId = 0;
365 
366         // In order to distinguish created skins in minting with destroyed skins
367         // skinIdToOwner[skinAId] = owner;
368         // skinIdToOwner[skinBId] = owner;
369         delete skinIdToOwner[skinAId];
370         delete skinIdToOwner[skinBId];
371         // require(numSkinOfAccounts[account] >= 2);
372         numSkinOfAccounts[account] -= 1;
373 
374         emit MixSuccess(account, nextSkinId - 1, skinAId, skinBId);
375     }
376 }
377 
378 
379 contract MixFormulaInterface {
380     function calcNewSkinAppearance(uint128 x, uint128 y, uint128 addition) public returns (uint128);
381 
382     // create random appearance
383     function randomSkinAppearance(uint256 externalNum, uint128 addition) public returns (uint128);
384 
385     // bleach
386     function bleachAppearance(uint128 appearance, uint128 attributes) public returns (uint128);
387 
388     // recycle
389     function recycleAppearance(uint128[5] appearances, uint256 preference, uint128 addition) public returns (uint128);
390 
391     // summon10
392     function summon10SkinAppearance(uint256 externalNum, uint128 addition) public returns (uint128);
393 }
394 
395 
396 contract SkinMarket is SkinMix {
397 
398     // Cut ratio for a transaction
399     // Values 0-10,000 map to 0%-100%
400     uint128 public trCut = 400;
401 
402     // Sale orders list 
403     mapping (uint256 => uint256) public desiredPrice;
404 
405     // events
406     event PutOnSale(address account, uint256 skinId);
407     event WithdrawSale(address account, uint256 skinId);
408     event BuyInMarket(address buyer, uint256 skinId);
409 
410     // functions
411 
412     function setTrCut(uint256 newCut) external onlyCOO {
413         trCut = uint128(newCut);
414     }
415 
416     // Put asset on sale
417     function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {
418         // Only owner of skin pass
419         require(skinIdToOwner[skinId] == msg.sender);
420         require(accountsToActiveSkin[msg.sender] != skinId);
421 
422         // Check whether skin is mixing 
423         require(skins[skinId].mixingWithId == 0);
424 
425         // Check whether skin is already on sale
426         require(isOnSale[skinId] == false);
427 
428         require(price > 0); 
429 
430         // Put on sale
431         desiredPrice[skinId] = price;
432         isOnSale[skinId] = true;
433 
434         // Emit the Approval event
435         emit PutOnSale(msg.sender, skinId);
436     }
437   
438     // Withdraw an sale order
439     function withdrawSale(uint256 skinId) external whenNotPaused {
440         // Check whether this skin is on sale
441         require(isOnSale[skinId] == true);
442         
443         // Can only withdraw self's sale
444         require(skinIdToOwner[skinId] == msg.sender);
445 
446         // Withdraw
447         isOnSale[skinId] = false;
448         desiredPrice[skinId] = 0;
449 
450         // Emit the cancel event
451         emit WithdrawSale(msg.sender, skinId);
452     }
453  
454     // Buy skin in market
455     function buyInMarket(uint256 skinId) external payable whenNotPaused {
456         // Check whether this skin is on sale
457         require(isOnSale[skinId] == true);
458 
459         address seller = skinIdToOwner[skinId];
460 
461         // Check the sender isn't the seller
462         require(msg.sender != seller);
463 
464         uint256 _price = desiredPrice[skinId];
465         // Check whether pay value is enough
466         require(msg.value >= _price);
467 
468         // Cut and then send the proceeds to seller
469         uint256 sellerProceeds = _price - _computeCut(_price);
470 
471         seller.transfer(sellerProceeds);
472 
473         // Transfer skin from seller to buyer
474         numSkinOfAccounts[seller] -= 1;
475         skinIdToOwner[skinId] = msg.sender;
476         numSkinOfAccounts[msg.sender] += 1;
477         isOnSale[skinId] = false;
478         desiredPrice[skinId] = 0;
479 
480         // Emit the buy event
481         emit BuyInMarket(msg.sender, skinId);
482     }
483 
484     // Compute the marketCut
485     function _computeCut(uint256 _price) internal view returns (uint256) {
486         return _price / 10000 * trCut;
487     }
488 }
489 
490 
491 contract SkinMinting is SkinMarket {
492 
493     // Limits the number of skins the contract owner can ever create.
494     uint256 public skinCreatedLimit = 50000;
495     uint256 public skinCreatedNum;
496 
497     // The summon and bleach numbers of each accounts: will be cleared every day
498     mapping (address => uint256) public accountToSummonNum;
499     mapping (address => uint256) public accountToBleachNum;
500 
501     // Pay level of each accounts
502     mapping (address => uint256) public accountToPayLevel;
503     mapping (address => uint256) public accountLastClearTime;
504     mapping (address => uint256) public bleachLastClearTime;
505 
506     // Free bleach number donated
507     mapping (address => uint256) public freeBleachNum;
508     bool isBleachAllowed = false;
509     bool isRecycleAllowed = false;
510 
511     uint256 public levelClearTime = now;
512 
513     // price and limit
514     uint256 public bleachDailyLimit = 3;
515     uint256 public baseSummonPrice = 1 finney;
516     uint256 public bleachPrice = 100 ether;  // do not call this
517 
518     // Pay level
519     uint256[5] public levelSplits = [10,
520                                      20,
521                                      50,
522                                      100,
523                                      200];
524 
525     uint256[6] public payMultiple = [10,
526                                      12,
527                                      15,
528                                      20,
529                                      30,
530                                      40];
531 
532 
533     // events
534     event CreateNewSkin(uint256 skinId, address account);
535     event Bleach(uint256 skinId, uint128 newAppearance);
536     event Recycle(uint256 skinId0, uint256 skinId1, uint256 skinId2, uint256 skinId3, uint256 skinId4, uint256 newSkinId);
537 
538     // functions
539 
540     // Set price
541     function setBaseSummonPrice(uint256 newPrice) external onlyCOO {
542         baseSummonPrice = newPrice;
543     }
544 
545     function setBleachPrice(uint256 newPrice) external onlyCOO {
546         bleachPrice = newPrice;
547     }
548 
549     function setBleachDailyLimit(uint256 limit) external onlyCOO {
550         bleachDailyLimit = limit;
551     }
552 
553     function switchBleachAllowed(bool newBleachAllowed) external onlyCOO {
554         isBleachAllowed = newBleachAllowed;
555     }
556 
557     function switchRecycleAllowed(bool newRecycleAllowed) external onlyCOO {
558         isRecycleAllowed = newRecycleAllowed;
559     }
560 
561     // Create base skin for sell. Only owner can create
562     function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyCOO {
563         require(skinCreatedNum < skinCreatedLimit);
564 
565         // Create specified skin
566         // uint128 randomAppearance = mixFormula.randomSkinAppearance();
567         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
568         skins[nextSkinId] = newSkin;
569         skinIdToOwner[nextSkinId] = coo;
570         isOnSale[nextSkinId] = false;
571 
572         // Emit the create event
573         emit CreateNewSkin(nextSkinId, coo);
574 
575         // Put this skin on sale
576         putOnSale(nextSkinId, salePrice);
577 
578         nextSkinId++;
579         numSkinOfAccounts[coo] += 1;
580         skinCreatedNum += 1;
581     }
582 
583     // Donate a skin to player. Only COO can operate
584     function donateSkin(uint128 specifiedAppearance, address donee) external whenNotPaused onlyCOO {
585         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
586         skins[nextSkinId] = newSkin;
587         skinIdToOwner[nextSkinId] = donee;
588         isOnSale[nextSkinId] = false;
589 
590         // Emit the create event
591         emit CreateNewSkin(nextSkinId, donee);
592 
593         nextSkinId++;
594         numSkinOfAccounts[donee] += 1;
595         skinCreatedNum += 1;
596     }
597 
598     //
599     function moveData(uint128[] legacyAppearance, address[] legacyOwner, bool[] legacyIsOnSale, uint256[] legacyDesiredPrice) external onlyCOO {
600         Skin memory newSkin = Skin({appearance: 0, cooldownEndTime: 0, mixingWithId: 0});
601         for (uint256 i = 0; i < legacyOwner.length; i++) {
602             newSkin.appearance = legacyAppearance[i];
603             newSkin.cooldownEndTime = uint64(now);
604             newSkin.mixingWithId = 0;
605 
606             skins[nextSkinId] = newSkin;
607             skinIdToOwner[nextSkinId] = legacyOwner[i];
608             isOnSale[nextSkinId] = legacyIsOnSale[i];
609             desiredPrice[nextSkinId] = legacyDesiredPrice[i];
610 
611             // Emit the create event
612             emit CreateNewSkin(nextSkinId, legacyOwner[i]);
613 
614             nextSkinId++;
615             numSkinOfAccounts[legacyOwner[i]] += 1;
616             if (numSkinOfAccounts[legacyOwner[i]] > freeBleachNum[legacyOwner[i]]*10 || freeBleachNum[legacyOwner[i]] == 0) {
617                 freeBleachNum[legacyOwner[i]] += 1;
618             }
619             skinCreatedNum += 1;
620         }
621     }
622 
623     // Summon
624     function summon() external payable whenNotPaused {
625         // Clear daily summon numbers
626         if (accountLastClearTime[msg.sender] == uint256(0)) {
627             // This account's first time to summon, we do not need to clear summon numbers
628             accountLastClearTime[msg.sender] = now;
629         } else {
630             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
631                 accountToSummonNum[msg.sender] = 0;
632                 accountToPayLevel[msg.sender] = 0;
633                 accountLastClearTime[msg.sender] = now;
634             }
635         }
636 
637         uint256 payLevel = accountToPayLevel[msg.sender];
638         uint256 price = payMultiple[payLevel] * baseSummonPrice;
639         require(msg.value >= price);
640 
641         // Create random skin
642         uint128 randomAppearance = mixFormula.randomSkinAppearance(nextSkinId, getActiveSkin(msg.sender));
643         // uint128 randomAppearance = 0;
644         Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
645         skins[nextSkinId] = newSkin;
646         skinIdToOwner[nextSkinId] = msg.sender;
647         isOnSale[nextSkinId] = false;
648 
649         // Emit the create event
650         emit CreateNewSkin(nextSkinId, msg.sender);
651 
652         nextSkinId++;
653         numSkinOfAccounts[msg.sender] += 1;
654 
655         accountToSummonNum[msg.sender] += 1;
656 
657         // Handle the paylevel
658         if (payLevel < 5) {
659             if (accountToSummonNum[msg.sender] >= levelSplits[payLevel]) {
660                 accountToPayLevel[msg.sender] = payLevel + 1;
661             }
662         }
663     }
664 
665     // Summon10
666     function summon10() external payable whenNotPaused {
667         // Clear daily summon numbers
668         if (accountLastClearTime[msg.sender] == uint256(0)) {
669             // This account's first time to summon, we do not need to clear summon numbers
670             accountLastClearTime[msg.sender] = now;
671         } else {
672             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
673                 accountToSummonNum[msg.sender] = 0;
674                 accountToPayLevel[msg.sender] = 0;
675                 accountLastClearTime[msg.sender] = now;
676             }
677         }
678 
679         uint256 payLevel = accountToPayLevel[msg.sender];
680         uint256 price = payMultiple[payLevel] * baseSummonPrice;
681         require(msg.value >= price*10);
682 
683         Skin memory newSkin;
684         uint128 randomAppearance;
685         // Create random skin
686         for (uint256 i = 0; i < 10; i++) {
687             randomAppearance = mixFormula.randomSkinAppearance(nextSkinId, getActiveSkin(msg.sender));
688             newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
689             skins[nextSkinId] = newSkin;
690             skinIdToOwner[nextSkinId] = msg.sender;
691             isOnSale[nextSkinId] = false;
692             // Emit the create event
693             emit CreateNewSkin(nextSkinId, msg.sender);
694             nextSkinId++;
695         }
696 
697         // Give additional skin
698         randomAppearance = mixFormula.summon10SkinAppearance(nextSkinId, getActiveSkin(msg.sender));
699         newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
700         skins[nextSkinId] = newSkin;
701         skinIdToOwner[nextSkinId] = msg.sender;
702         isOnSale[nextSkinId] = false;
703         // Emit the create event
704         emit CreateNewSkin(nextSkinId, msg.sender);
705         nextSkinId++;
706 
707         numSkinOfAccounts[msg.sender] += 11;
708         accountToSummonNum[msg.sender] += 10;
709 
710         // Handle the paylevel
711         if (payLevel < 5) {
712             if (accountToSummonNum[msg.sender] >= levelSplits[payLevel]) {
713                 accountToPayLevel[msg.sender] = payLevel + 1;
714             }
715         }
716     }
717 
718     // Recycle bin
719     function recycleSkin(uint256[5] wasteSkins, uint256 preferIndex) external whenNotPaused {
720         require(isRecycleAllowed == true);
721         for (uint256 i = 0; i < 5; i++) {
722             require(skinIdToOwner[wasteSkins[i]] == msg.sender);
723             skinIdToOwner[wasteSkins[i]] = address(0);
724         }
725 
726         uint128[5] memory apps;
727         for (i = 0; i < 5; i++) {
728             apps[i] = skins[wasteSkins[i]].appearance;
729         }
730         // Create random skin
731         uint128 recycleApp = mixFormula.recycleAppearance(apps, preferIndex, getActiveSkin(msg.sender));
732         Skin memory newSkin = Skin({appearance: recycleApp, cooldownEndTime: uint64(now), mixingWithId: 0});
733         skins[nextSkinId] = newSkin;
734         skinIdToOwner[nextSkinId] = msg.sender;
735         isOnSale[nextSkinId] = false;
736 
737         // Emit event
738         emit Recycle(wasteSkins[0], wasteSkins[1], wasteSkins[2], wasteSkins[3], wasteSkins[4], nextSkinId);
739 
740         nextSkinId++;
741         numSkinOfAccounts[msg.sender] -= 4;
742     }
743 
744     // Bleach some attributes
745     function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {
746         require(isBleachAllowed);
747 
748         // Clear daily summon numbers
749         if (bleachLastClearTime[msg.sender] == uint256(0)) {
750             // This account's first time to summon, we do not need to clear bleach numbers
751             bleachLastClearTime[msg.sender] = now;
752         } else {
753             if (bleachLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
754                 accountToBleachNum[msg.sender] = 0;
755                 bleachLastClearTime[msg.sender] = now;
756             }
757         }
758 
759         require(accountToBleachNum[msg.sender] < bleachDailyLimit);
760         accountToBleachNum[msg.sender] += 1;
761 
762         // Check whether msg.sender is owner of the skin
763         require(msg.sender == skinIdToOwner[skinId]);
764 
765         // Check whether this skin is on sale
766         require(isOnSale[skinId] == false);
767 
768         uint256 bleachNum = 0;
769         for (uint256 i = 0; i < 8; i++) {
770             if ((attributes & (uint128(1) << i)) > 0) {
771                 if (freeBleachNum[msg.sender] > 0) {
772                     freeBleachNum[msg.sender]--;
773                 } else {
774                     bleachNum++;
775                 }
776             }
777         }
778         // Check whether there is enough money
779         require(msg.value >= bleachNum * bleachPrice);
780 
781         Skin storage originSkin = skins[skinId];
782         // Check whether this skin is in mixing
783         require(originSkin.mixingWithId == 0);
784 
785         uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);
786         originSkin.appearance = newAppearance;
787 
788         // Emit bleach event
789         emit Bleach(skinId, newAppearance);
790     }
791 
792     // Our daemon will clear daily summon numbers
793     function clearSummonNum() external onlyCOO {
794         uint256 nextDay = levelClearTime + 1 days;
795         if (now > nextDay) {
796             levelClearTime = nextDay;
797         }
798     }
799 }