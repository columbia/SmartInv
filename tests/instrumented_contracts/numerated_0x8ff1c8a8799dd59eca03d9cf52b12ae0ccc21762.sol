1 pragma solidity ^0.4.18;
2 
3 contract Manager {
4     address public ceo;
5     address public cfo;
6     address public coo;
7     address public cao;
8 
9     event OwnershipTransferred(address indexed previousCeo, address indexed newCeo);
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
20         cfo = 0x447870C2f334Fcda68e644aE53Db3471A9f7302D;
21         ceo = 0x6EC9C6fcE15DB982521eA2087474291fA5Ad6d31;
22         cao = 0x391Ef2cB0c81A2C47D659c3e3e6675F550e4b183;
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
64         OwnershipTransferred(ceo, newCeo);
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
107         Pause();
108     }
109 
110     /**
111     * @dev called by the owner to unpause, returns to normal state
112     */
113     function unpause() onlyCAO whenPaused public {
114         paused = false;
115         Unpause();
116     }
117 }
118 
119 
120 contract SkinBase is Manager {
121 
122     struct Skin {
123         uint128 appearance;
124         uint64 cooldownEndTime;
125         uint64 mixingWithId;
126     }
127 
128     // All skins, mapping from skin id to skin apprance
129     mapping (uint256 => Skin) skins;
130 
131     // Mapping from skin id to owner
132     mapping (uint256 => address) public skinIdToOwner;
133 
134     // Whether a skin is on sale
135     mapping (uint256 => bool) public isOnSale;
136 
137     // Number of all total valid skins
138     // skinId 0 should not correspond to any skin, because skin.mixingWithId==0 indicates not mixing
139     uint256 public nextSkinId = 1;  
140 
141     // Number of skins an account owns
142     mapping (address => uint256) public numSkinOfAccounts;
143 
144     event SkinTransfer(address from, address to, uint256 skinId);
145     
146     // // Give some skins to init account for unit tests
147     // function SkinBase() public {
148     //     address account0 = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
149     //     address account1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
150 
151     //     // Create simple skins
152     //     Skin memory skin = Skin({appearance: 0, cooldownEndTime:0, mixingWithId: 0});
153     //     for (uint256 i = 1; i <= 15; i++) {
154     //         if (i < 10) {
155     //             skin.appearance = uint128(i);
156     //             if (i < 7) { 
157     //                 skinIdToOwner[i] = account0;
158     //                 numSkinOfAccounts[account0] += 1;
159     //             } else {  
160     //                 skinIdToOwner[i] = account1;
161     //                 numSkinOfAccounts[account1] += 1;
162     //             }
163     //         } else {  
164     //             skin.appearance = uint128(block.blockhash(block.number - i + 9));
165     //             skinIdToOwner[i] = account1;
166     //             numSkinOfAccounts[account1] += 1;
167     //         }
168     //         skins[i] = skin;
169     //         isOnSale[i] = false;
170     //         nextSkinId += 1;
171     //     }
172     // } 
173 
174     // Get the i-th skin an account owns, for off-chain usage only
175     function skinOfAccountById(address account, uint256 id) external view returns (uint256) {
176        uint256 count = 0;
177        uint256 numSkinOfAccount = numSkinOfAccounts[account];
178        require(numSkinOfAccount > 0);
179        require(id < numSkinOfAccount);
180        for (uint256 i = 1; i < nextSkinId; i++) {
181            if (skinIdToOwner[i] == account) {
182                // This skin belongs to current account
183                if (count == id) {
184                    // This is the id-th skin of current account, a.k.a, what we need
185                     return i;
186                } 
187                count++;
188            }
189         }
190         revert();
191     }
192 
193     // Get skin by id
194     function getSkin(uint256 id) public view returns (uint128, uint64, uint64) {
195         require(id > 0);
196         require(id < nextSkinId);
197         Skin storage skin = skins[id];
198         return (skin.appearance, skin.cooldownEndTime, skin.mixingWithId);
199     }
200 
201     function withdrawETH() external onlyCAO {
202         cfo.transfer(this.balance);
203     }
204     
205     function transferP2P(uint256 id, address targetAccount) whenTransferAllowed public {
206         require(skinIdToOwner[id] == msg.sender);
207         require(msg.sender != targetAccount);
208         skinIdToOwner[id] = targetAccount;
209         
210         numSkinOfAccounts[msg.sender] -= 1;
211         numSkinOfAccounts[targetAccount] += 1;
212         
213         // emit event
214         SkinTransfer(msg.sender, targetAccount, id);
215     }
216 }
217 
218 
219 contract MixFormulaInterface {
220     function calcNewSkinAppearance(uint128 x, uint128 y) public returns (uint128);
221 
222     // create random appearance
223     function randomSkinAppearance(uint256 externalNum) public returns (uint128);
224 
225     // bleach
226     function bleachAppearance(uint128 appearance, uint128 attributes) public returns (uint128);
227 
228     // recycle
229     function recycleAppearance(uint128[5] appearances, uint256 preference) public returns (uint128);
230 
231     // summon10
232     function summon10SkinAppearance(uint256 externalNum) public returns (uint128);
233 }
234 
235 contract SkinMix is SkinBase {
236 
237     // Mix formula
238     MixFormulaInterface public mixFormula;
239 
240 
241     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
242     uint256 public prePaidFee = 150000 * 5000000000; // (15w gas * 5 gwei)
243 
244     // Events
245     event MixStart(address account, uint256 skinAId, uint256 skinBId);
246     event AutoMix(address account, uint256 skinAId, uint256 skinBId, uint64 cooldownEndTime);
247     event MixSuccess(address account, uint256 skinId, uint256 skinAId, uint256 skinBId);
248 
249     // Set mix formula contract address 
250     function setMixFormulaAddress(address mixFormulaAddress) external onlyCOO {
251         mixFormula = MixFormulaInterface(mixFormulaAddress);
252     }
253 
254     // setPrePaidFee: set advance amount, only owner can call this
255     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
256         prePaidFee = newPrePaidFee;
257     }
258 
259     // _isCooldownReady: check whether cooldown period has been passed
260     function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {
261         return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));
262     }
263 
264     // _isNotMixing: check whether two skins are in another mixing process
265     function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {
266         return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);
267     }
268 
269     // _setCooldownTime: set new cooldown time
270     function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {
271         uint256 end = now + 5 minutes;
272         // uint256 end = now;
273         skins[skinAId].cooldownEndTime = uint64(end);
274         skins[skinBId].cooldownEndTime = uint64(end);
275     }
276 
277     // _isValidSkin: whether an account can mix using these skins
278     // Make sure two things:
279     // 1. these two skins do exist
280     // 2. this account owns these skins
281     function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {
282         // Make sure those two skins belongs to this account
283         if (skinAId == skinBId) {
284             return false;
285         }
286         if ((skinAId == 0) || (skinBId == 0)) {
287             return false;
288         }
289         if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {
290             return false;
291         }
292         return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);
293     }
294 
295     // _isNotOnSale: whether a skin is not on sale
296     function _isNotOnSale(uint256 skinId) private view returns (bool) {
297         return (isOnSale[skinId] == false);
298     }
299 
300     // mix  
301     function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {
302 
303         // Check whether skins are valid
304         require(_isValidSkin(msg.sender, skinAId, skinBId));
305 
306         // Check whether skins are neither on sale
307         require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));
308 
309         // Check cooldown
310         require(_isCooldownReady(skinAId, skinBId));
311 
312         // Check these skins are not in another process
313         require(_isNotMixing(skinAId, skinBId));
314 
315         // Set new cooldown time
316         _setCooldownEndTime(skinAId, skinBId);
317 
318         // Mark skins as in mixing
319         skins[skinAId].mixingWithId = uint64(skinBId);
320         skins[skinBId].mixingWithId = uint64(skinAId);
321 
322         // Emit MixStart event
323         MixStart(msg.sender, skinAId, skinBId);
324     }
325 
326     // Mixing auto
327     function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {
328         require(msg.value >= prePaidFee);
329 
330         mix(skinAId, skinBId);
331 
332         Skin storage skin = skins[skinAId];
333 
334         AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);
335     }
336 
337     // Get mixing result, return the resulted skin id
338     function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {
339         // Check these two skins belongs to the same account
340         address account = skinIdToOwner[skinAId];
341         require(account == skinIdToOwner[skinBId]);
342 
343         // Check these two skins are in the same mixing process
344         Skin storage skinA = skins[skinAId];
345         Skin storage skinB = skins[skinBId];
346         require(skinA.mixingWithId == uint64(skinBId));
347         require(skinB.mixingWithId == uint64(skinAId));
348 
349         // Check cooldown
350         require(_isCooldownReady(skinAId, skinBId));
351 
352         // Create new skin
353         uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance);
354         Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
355         skins[nextSkinId] = newSkin;
356         skinIdToOwner[nextSkinId] = account;
357         isOnSale[nextSkinId] = false;
358         nextSkinId++;
359 
360         // Clear old skins
361         skinA.mixingWithId = 0;
362         skinB.mixingWithId = 0;
363 
364         // In order to distinguish created skins in minting with destroyed skins
365         // skinIdToOwner[skinAId] = owner;
366         // skinIdToOwner[skinBId] = owner;
367         delete skinIdToOwner[skinAId];
368         delete skinIdToOwner[skinBId];
369         // require(numSkinOfAccounts[account] >= 2);
370         numSkinOfAccounts[account] -= 1;
371 
372         MixSuccess(account, nextSkinId - 1, skinAId, skinBId);
373     }
374 }
375 
376 contract SkinMarket is SkinMix {
377 
378     // Cut ratio for a transaction
379     // Values 0-10,000 map to 0%-100%
380     uint128 public trCut = 400;
381 
382     // Sale orders list 
383     mapping (uint256 => uint256) public desiredPrice;
384 
385     // events
386     event PutOnSale(address account, uint256 skinId);
387     event WithdrawSale(address account, uint256 skinId);
388     event BuyInMarket(address buyer, uint256 skinId);
389 
390     // functions
391 
392     function setTrCut(uint256 newCut) external onlyCOO {
393         trCut = uint128(newCut);
394     }
395 
396     // Put asset on sale
397     function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {
398         // Only owner of skin pass
399         require(skinIdToOwner[skinId] == msg.sender);
400 
401         // Check whether skin is mixing 
402         require(skins[skinId].mixingWithId == 0);
403 
404         // Check whether skin is already on sale
405         require(isOnSale[skinId] == false);
406 
407         require(price > 0); 
408 
409         // Put on sale
410         desiredPrice[skinId] = price;
411         isOnSale[skinId] = true;
412 
413         // Emit the Approval event
414         PutOnSale(msg.sender, skinId);
415     }
416   
417     // Withdraw an sale order
418     function withdrawSale(uint256 skinId) external whenNotPaused {
419         // Check whether this skin is on sale
420         require(isOnSale[skinId] == true);
421         
422         // Can only withdraw self's sale
423         require(skinIdToOwner[skinId] == msg.sender);
424 
425         // Withdraw
426         isOnSale[skinId] = false;
427         desiredPrice[skinId] = 0;
428 
429         // Emit the cancel event
430         WithdrawSale(msg.sender, skinId);
431     }
432  
433     // Buy skin in market
434     function buyInMarket(uint256 skinId) external payable whenNotPaused {
435         // Check whether this skin is on sale
436         require(isOnSale[skinId] == true);
437 
438         address seller = skinIdToOwner[skinId];
439 
440         // Check the sender isn't the seller
441         require(msg.sender != seller);
442 
443         uint256 _price = desiredPrice[skinId];
444         // Check whether pay value is enough
445         require(msg.value >= _price);
446 
447         // Cut and then send the proceeds to seller
448         uint256 sellerProceeds = _price - _computeCut(_price);
449 
450         seller.transfer(sellerProceeds);
451 
452         // Transfer skin from seller to buyer
453         numSkinOfAccounts[seller] -= 1;
454         skinIdToOwner[skinId] = msg.sender;
455         numSkinOfAccounts[msg.sender] += 1;
456         isOnSale[skinId] = false;
457         desiredPrice[skinId] = 0;
458 
459         // Emit the buy event
460         BuyInMarket(msg.sender, skinId);
461     }
462 
463     // Compute the marketCut
464     function _computeCut(uint256 _price) internal view returns (uint256) {
465         return _price * trCut / 10000;
466     }
467 }
468 
469 contract SkinMinting is SkinMarket {
470 
471     // Limits the number of skins the contract owner can ever create.
472     uint256 public skinCreatedLimit = 50000;
473     uint256 public skinCreatedNum;
474 
475     // The summon and bleach numbers of each accounts: will be cleared every day
476     mapping (address => uint256) public accountToSummonNum;
477     mapping (address => uint256) public accountToBleachNum;
478 
479     // Pay level of each accounts
480     mapping (address => uint256) public accountToPayLevel;
481     mapping (address => uint256) public accountLastClearTime;
482 
483     // Free bleach number donated
484     mapping (address => uint256) public freeBleachNum;
485     bool isBleachAllowed = true;
486 
487     uint256 public levelClearTime = now;
488 
489     // price and limit
490     uint256 public bleachDailyLimit = 3;
491     uint256 public baseSummonPrice = 1 finney;
492     uint256 public bleachPrice = 300 finney;  // do not call this
493 
494     // Pay level
495     uint256[5] public levelSplits = [10,
496                                      20,
497                                      50,
498                                      100,
499                                      200];
500     
501     uint256[6] public payMultiple = [10,
502                                      12,
503                                      15,
504                                      20,
505                                      30,
506                                      40];
507 
508 
509     // events
510     event CreateNewSkin(uint256 skinId, address account);
511     event Bleach(uint256 skinId, uint128 newAppearance);
512 
513     // functions
514 
515     // Set price 
516     function setBaseSummonPrice(uint256 newPrice) external onlyCOO {
517         baseSummonPrice = newPrice;
518     }
519 
520     function setBleachPrice(uint256 newPrice) external onlyCOO {
521         bleachPrice = newPrice;
522     }
523 
524     function setBleachDailyLimit(uint256 limit) external onlyCOO {
525         bleachDailyLimit = limit;
526     }
527 
528     function switchBleachAllowed(bool newBleachAllowed) external onlyCOO {
529         isBleachAllowed = newBleachAllowed;
530     }
531 
532     // Create base skin for sell. Only owner can create
533     function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyCOO {
534         require(skinCreatedNum < skinCreatedLimit);
535 
536         // Create specified skin
537         // uint128 randomAppearance = mixFormula.randomSkinAppearance();
538         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
539         skins[nextSkinId] = newSkin;
540         skinIdToOwner[nextSkinId] = coo;
541         isOnSale[nextSkinId] = false;
542 
543         // Emit the create event
544         CreateNewSkin(nextSkinId, coo);
545 
546         // Put this skin on sale
547         putOnSale(nextSkinId, salePrice);
548 
549         nextSkinId++;
550         numSkinOfAccounts[coo] += 1;   
551         skinCreatedNum += 1;
552     }
553 
554     // Donate a skin to player. Only COO can operate
555     function donateSkin(uint128 specifiedAppearance, address donee) external whenNotPaused onlyCOO {
556         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
557         skins[nextSkinId] = newSkin;
558         skinIdToOwner[nextSkinId] = donee;
559         isOnSale[nextSkinId] = false;
560 
561         // Emit the create event
562         CreateNewSkin(nextSkinId, donee);
563 
564         nextSkinId++;
565         numSkinOfAccounts[donee] += 1;   
566         skinCreatedNum += 1;
567     }
568 
569     // 
570     function moveData(uint128[] legacyAppearance, address[] legacyOwner, bool[] legacyIsOnSale, uint256[] legacyDesiredPrice) external onlyCOO {
571         Skin memory newSkin = Skin({appearance: 0, cooldownEndTime: 0, mixingWithId: 0});
572         for (uint256 i = 0; i < legacyOwner.length; i++) {
573             newSkin.appearance = legacyAppearance[i];
574             newSkin.cooldownEndTime = uint64(now);
575             newSkin.mixingWithId = 0;
576             
577             skins[nextSkinId] = newSkin;
578             skinIdToOwner[nextSkinId] = legacyOwner[i];
579             isOnSale[nextSkinId] = legacyIsOnSale[i];
580             desiredPrice[nextSkinId] = legacyDesiredPrice[i];
581     
582             // Emit the create event
583             CreateNewSkin(nextSkinId, legacyOwner[i]);
584     
585             nextSkinId++;
586             numSkinOfAccounts[legacyOwner[i]] += 1;
587             if (numSkinOfAccounts[legacyOwner[i]] > freeBleachNum[legacyOwner[i]]*10 || freeBleachNum[legacyOwner[i]] == 0) {
588                 freeBleachNum[legacyOwner[i]] += 1;
589             }   
590             skinCreatedNum += 1;
591         }
592     }
593 
594     // Summon
595     function summon() external payable whenNotPaused {
596         // Clear daily summon numbers
597         if (accountLastClearTime[msg.sender] == uint256(0)) {
598             // This account's first time to summon, we do not need to clear summon numbers
599             accountLastClearTime[msg.sender] = now;
600         } else {
601             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
602                 accountToSummonNum[msg.sender] = 0;
603                 accountToPayLevel[msg.sender] = 0;
604                 accountLastClearTime[msg.sender] = now;
605             }
606         }
607 
608         uint256 payLevel = accountToPayLevel[msg.sender];
609         uint256 price = payMultiple[payLevel] * baseSummonPrice;
610         require(msg.value >= price);
611 
612         // Create random skin
613         uint128 randomAppearance = mixFormula.randomSkinAppearance(nextSkinId);
614         // uint128 randomAppearance = 0;
615         Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
616         skins[nextSkinId] = newSkin;
617         skinIdToOwner[nextSkinId] = msg.sender;
618         isOnSale[nextSkinId] = false;
619 
620         // Emit the create event
621         CreateNewSkin(nextSkinId, msg.sender);
622 
623         nextSkinId++;
624         numSkinOfAccounts[msg.sender] += 1;
625         
626         accountToSummonNum[msg.sender] += 1;
627         
628         // Handle the paylevel        
629         if (payLevel < 5) {
630             if (accountToSummonNum[msg.sender] >= levelSplits[payLevel]) {
631                 accountToPayLevel[msg.sender] = payLevel + 1;
632             }
633         }
634     }
635 
636     // Summon10
637     function summon10() external payable whenNotPaused {
638         // Clear daily summon numbers
639         if (accountLastClearTime[msg.sender] == uint256(0)) {
640             // This account's first time to summon, we do not need to clear summon numbers
641             accountLastClearTime[msg.sender] = now;
642         } else {
643             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
644                 accountToSummonNum[msg.sender] = 0;
645                 accountToPayLevel[msg.sender] = 0;
646                 accountLastClearTime[msg.sender] = now;
647             }
648         }
649 
650         uint256 payLevel = accountToPayLevel[msg.sender];
651         uint256 price = payMultiple[payLevel] * baseSummonPrice;
652         require(msg.value >= price*10);
653 
654         Skin memory newSkin;
655         uint128 randomAppearance;
656         // Create random skin
657         for (uint256 i = 0; i < 10; i++) {
658             randomAppearance = mixFormula.randomSkinAppearance(nextSkinId);
659             newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
660             skins[nextSkinId] = newSkin;
661             skinIdToOwner[nextSkinId] = msg.sender;
662             isOnSale[nextSkinId] = false;
663             // Emit the create event
664             CreateNewSkin(nextSkinId, msg.sender);
665             nextSkinId++;
666         }  
667 
668         // Give additional skin
669         randomAppearance = mixFormula.summon10SkinAppearance(nextSkinId);
670         newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
671         skins[nextSkinId] = newSkin;
672         skinIdToOwner[nextSkinId] = msg.sender;
673         isOnSale[nextSkinId] = false;
674         // Emit the create event
675         CreateNewSkin(nextSkinId, msg.sender);
676         nextSkinId++;
677 
678         numSkinOfAccounts[msg.sender] += 11;
679         accountToSummonNum[msg.sender] += 10;
680         
681         // Handle the paylevel        
682         if (payLevel < 5) {
683             if (accountToSummonNum[msg.sender] >= levelSplits[payLevel]) {
684                 accountToPayLevel[msg.sender] = payLevel + 1;
685             }
686         }
687     }
688 
689     // Recycle bin
690     function recycleSkin(uint256[5] wasteSkins, uint256 preferIndex) external whenNotPaused {
691         for (uint256 i = 0; i < 5; i++) {
692             require(skinIdToOwner[wasteSkins[i]] == msg.sender);
693             skinIdToOwner[wasteSkins[i]] = address(0);
694         }
695 
696         uint128[5] memory apps;
697         for (i = 0; i < 5; i++) {
698             apps[i] = skins[wasteSkins[i]].appearance;
699         }
700         // Create random skin
701         uint128 recycleApp = mixFormula.recycleAppearance(apps, preferIndex);
702         Skin memory newSkin = Skin({appearance: recycleApp, cooldownEndTime: uint64(now), mixingWithId: 0});
703         skins[nextSkinId] = newSkin;
704         skinIdToOwner[nextSkinId] = msg.sender;
705         isOnSale[nextSkinId] = false;
706 
707         // Emit the create event
708         CreateNewSkin(nextSkinId, msg.sender);
709 
710         nextSkinId++;
711         numSkinOfAccounts[msg.sender] -= 4;
712     }
713 
714     // Bleach some attributes
715     function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {
716         require(isBleachAllowed);
717 
718         // Clear daily summon numbers
719         if (accountLastClearTime[msg.sender] == uint256(0)) {
720             // This account's first time to summon, we do not need to clear bleach numbers
721             accountLastClearTime[msg.sender] = now;
722         } else {
723             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
724                 accountToBleachNum[msg.sender] = 0;
725                 accountLastClearTime[msg.sender] = now;
726             }
727         }
728 
729         require(accountToBleachNum[msg.sender] < bleachDailyLimit);
730         accountToBleachNum[msg.sender] += 1;
731 
732         // Check whether msg.sender is owner of the skin 
733         require(msg.sender == skinIdToOwner[skinId]);
734 
735         // Check whether this skin is on sale 
736         require(isOnSale[skinId] == false);
737 
738         uint256 bleachNum = 0;
739         for (uint256 i = 0; i < 8; i++) {
740             if ((attributes & (uint128(1) << i)) > 0) {
741                 if (freeBleachNum[msg.sender] > 0) {
742                     freeBleachNum[msg.sender]--;
743                 } else {
744                     bleachNum++;
745                 }
746             }
747         }
748         // Check whether there is enough money
749         require(msg.value >= bleachNum * bleachPrice);
750 
751         Skin storage originSkin = skins[skinId];
752         // Check whether this skin is in mixing 
753         require(originSkin.mixingWithId == 0);
754         
755         uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);
756         originSkin.appearance = newAppearance;
757 
758         // Emit bleach event
759         Bleach(skinId, newAppearance);
760     }
761 
762     // Our daemon will clear daily summon numbers
763     function clearSummonNum() external onlyCOO {
764         uint256 nextDay = levelClearTime + 1 days;
765         if (now > nextDay) {
766             levelClearTime = nextDay;
767         }
768     }
769 }