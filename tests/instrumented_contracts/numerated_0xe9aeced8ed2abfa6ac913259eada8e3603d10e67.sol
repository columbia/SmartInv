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
220     function calcNewSkinAppearance(uint128 x, uint128 y) public pure returns (uint128);
221 
222     // create random appearance
223     function randomSkinAppearance(uint256 externalNum) public view returns (uint128);
224 
225     // bleach
226     function bleachAppearance(uint128 appearance, uint128 attributes) public pure returns (uint128);
227 }
228 
229 contract SkinMix is SkinBase {
230 
231     // Mix formula
232     MixFormulaInterface public mixFormula;
233 
234 
235     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
236     uint256 public prePaidFee = 150000 * 5000000000; // (15w gas * 5 gwei)
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
253     // _isCooldownReady: check whether cooldown period has been passed
254     function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {
255         return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));
256     }
257 
258     // _isNotMixing: check whether two skins are in another mixing process
259     function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {
260         return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);
261     }
262 
263     // _setCooldownTime: set new cooldown time
264     function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {
265         uint256 end = now + 5 minutes;
266         // uint256 end = now;
267         skins[skinAId].cooldownEndTime = uint64(end);
268         skins[skinBId].cooldownEndTime = uint64(end);
269     }
270 
271     // _isValidSkin: whether an account can mix using these skins
272     // Make sure two things:
273     // 1. these two skins do exist
274     // 2. this account owns these skins
275     function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {
276         // Make sure those two skins belongs to this account
277         if (skinAId == skinBId) {
278             return false;
279         }
280         if ((skinAId == 0) || (skinBId == 0)) {
281             return false;
282         }
283         if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {
284             return false;
285         }
286         return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);
287     }
288 
289     // _isNotOnSale: whether a skin is not on sale
290     function _isNotOnSale(uint256 skinId) private view returns (bool) {
291         return (isOnSale[skinId] == false);
292     }
293 
294     // mix  
295     function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {
296 
297         // Check whether skins are valid
298         require(_isValidSkin(msg.sender, skinAId, skinBId));
299 
300         // Check whether skins are neither on sale
301         require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));
302 
303         // Check cooldown
304         require(_isCooldownReady(skinAId, skinBId));
305 
306         // Check these skins are not in another process
307         require(_isNotMixing(skinAId, skinBId));
308 
309         // Set new cooldown time
310         _setCooldownEndTime(skinAId, skinBId);
311 
312         // Mark skins as in mixing
313         skins[skinAId].mixingWithId = uint64(skinBId);
314         skins[skinBId].mixingWithId = uint64(skinAId);
315 
316         // Emit MixStart event
317         MixStart(msg.sender, skinAId, skinBId);
318     }
319 
320     // Mixing auto
321     function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {
322         require(msg.value >= prePaidFee);
323 
324         mix(skinAId, skinBId);
325 
326         Skin storage skin = skins[skinAId];
327 
328         AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);
329     }
330 
331     // Get mixing result, return the resulted skin id
332     function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {
333         // Check these two skins belongs to the same account
334         address account = skinIdToOwner[skinAId];
335         require(account == skinIdToOwner[skinBId]);
336 
337         // Check these two skins are in the same mixing process
338         Skin storage skinA = skins[skinAId];
339         Skin storage skinB = skins[skinBId];
340         require(skinA.mixingWithId == uint64(skinBId));
341         require(skinB.mixingWithId == uint64(skinAId));
342 
343         // Check cooldown
344         require(_isCooldownReady(skinAId, skinBId));
345 
346         // Create new skin
347         uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance);
348         Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
349         skins[nextSkinId] = newSkin;
350         skinIdToOwner[nextSkinId] = account;
351         isOnSale[nextSkinId] = false;
352         nextSkinId++;
353 
354         // Clear old skins
355         skinA.mixingWithId = 0;
356         skinB.mixingWithId = 0;
357 
358         // In order to distinguish created skins in minting with destroyed skins
359         // skinIdToOwner[skinAId] = owner;
360         // skinIdToOwner[skinBId] = owner;
361         delete skinIdToOwner[skinAId];
362         delete skinIdToOwner[skinBId];
363         // require(numSkinOfAccounts[account] >= 2);
364         numSkinOfAccounts[account] -= 1;
365 
366         MixSuccess(account, nextSkinId - 1, skinAId, skinBId);
367     }
368 }
369 
370 contract SkinMarket is SkinMix {
371 
372     // Cut ratio for a transaction
373     // Values 0-10,000 map to 0%-100%
374     uint128 public trCut = 400;
375 
376     // Sale orders list 
377     mapping (uint256 => uint256) public desiredPrice;
378 
379     // events
380     event PutOnSale(address account, uint256 skinId);
381     event WithdrawSale(address account, uint256 skinId);
382     event BuyInMarket(address buyer, uint256 skinId);
383 
384     // functions
385 
386     function setTrCut(uint256 newCut) external onlyCOO {
387         trCut = uint128(newCut);
388     }
389 
390     // Put asset on sale
391     function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {
392         // Only owner of skin pass
393         require(skinIdToOwner[skinId] == msg.sender);
394 
395         // Check whether skin is mixing 
396         require(skins[skinId].mixingWithId == 0);
397 
398         // Check whether skin is already on sale
399         require(isOnSale[skinId] == false);
400 
401         require(price > 0); 
402 
403         // Put on sale
404         desiredPrice[skinId] = price;
405         isOnSale[skinId] = true;
406 
407         // Emit the Approval event
408         PutOnSale(msg.sender, skinId);
409     }
410   
411     // Withdraw an sale order
412     function withdrawSale(uint256 skinId) external whenNotPaused {
413         // Check whether this skin is on sale
414         require(isOnSale[skinId] == true);
415         
416         // Can only withdraw self's sale
417         require(skinIdToOwner[skinId] == msg.sender);
418 
419         // Withdraw
420         isOnSale[skinId] = false;
421         desiredPrice[skinId] = 0;
422 
423         // Emit the cancel event
424         WithdrawSale(msg.sender, skinId);
425     }
426  
427     // Buy skin in market
428     function buyInMarket(uint256 skinId) external payable whenNotPaused {
429         // Check whether this skin is on sale
430         require(isOnSale[skinId] == true);
431 
432         address seller = skinIdToOwner[skinId];
433 
434         // Check the sender isn't the seller
435         require(msg.sender != seller);
436 
437         uint256 _price = desiredPrice[skinId];
438         // Check whether pay value is enough
439         require(msg.value >= _price);
440 
441         // Cut and then send the proceeds to seller
442         uint256 sellerProceeds = _price - _computeCut(_price);
443 
444         seller.transfer(sellerProceeds);
445 
446         // Transfer skin from seller to buyer
447         numSkinOfAccounts[seller] -= 1;
448         skinIdToOwner[skinId] = msg.sender;
449         numSkinOfAccounts[msg.sender] += 1;
450         isOnSale[skinId] = false;
451         desiredPrice[skinId] = 0;
452 
453         // Emit the buy event
454         BuyInMarket(msg.sender, skinId);
455     }
456 
457     // Compute the marketCut
458     function _computeCut(uint256 _price) internal view returns (uint256) {
459         return _price * trCut / 10000;
460     }
461 }
462 
463 contract SkinMinting is SkinMarket {
464 
465     // Limits the number of skins the contract owner can ever create.
466     uint256 public skinCreatedLimit = 50000;
467     uint256 public skinCreatedNum;
468 
469     // The summon and bleach numbers of each accounts: will be cleared every day
470     mapping (address => uint256) public accountToSummonNum;
471     mapping (address => uint256) public accountToBleachNum;
472 
473     // Pay level of each accounts
474     mapping (address => uint256) public accountToPayLevel;
475     mapping (address => uint256) public accountLastClearTime;
476 
477     uint256 public levelClearTime = now;
478 
479     // price and limit
480     uint256 public bleachDailyLimit = 3;
481     uint256 public baseSummonPrice = 1 finney;
482     uint256 public bleachPrice = 300 finney;  // do not call this
483 
484     // Pay level
485     uint256[5] public levelSplits = [10,
486                                      20,
487                                      50,
488                                      100,
489                                      200];
490     
491     uint256[6] public payMultiple = [10,
492                                      12,
493                                      15,
494                                      20,
495                                      30,
496                                      40];
497 
498 
499     // events
500     event CreateNewSkin(uint256 skinId, address account);
501     event Bleach(uint256 skinId, uint128 newAppearance);
502 
503     // functions
504 
505     // Set price 
506     function setBaseSummonPrice(uint256 newPrice) external onlyCOO {
507         baseSummonPrice = newPrice;
508     }
509 
510     function setBleachPrice(uint256 newPrice) external onlyCOO {
511         bleachPrice = newPrice;
512     }
513 
514     function setBleachDailyLimit(uint256 limit) external onlyCOO {
515         bleachDailyLimit = limit;
516     }
517 
518     // Create base skin for sell. Only owner can create
519     function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyCOO {
520         require(skinCreatedNum < skinCreatedLimit);
521 
522         // Create specified skin
523         // uint128 randomAppearance = mixFormula.randomSkinAppearance();
524         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
525         skins[nextSkinId] = newSkin;
526         skinIdToOwner[nextSkinId] = coo;
527         isOnSale[nextSkinId] = false;
528 
529         // Emit the create event
530         CreateNewSkin(nextSkinId, coo);
531 
532         // Put this skin on sale
533         putOnSale(nextSkinId, salePrice);
534 
535         nextSkinId++;
536         numSkinOfAccounts[coo] += 1;   
537         skinCreatedNum += 1;
538     }
539 
540     // Donate a skin to player. Only COO can operate
541     function donateSkin(uint128[] legacyAppearance, address[] legacyOwner, bool[] legacyIsOnSale, uint256[] legacyDesiredPrice) external onlyCOO {
542         Skin memory newSkin = Skin({appearance: 0, cooldownEndTime: 0, mixingWithId: 0});
543         for (uint256 i = 0; i < legacyOwner.length; i++) {
544             newSkin.appearance = legacyAppearance[i];
545             newSkin.cooldownEndTime = uint64(now);
546             newSkin.mixingWithId = 0;
547             
548             skins[nextSkinId] = newSkin;
549             skinIdToOwner[nextSkinId] = legacyOwner[i];
550             isOnSale[nextSkinId] = legacyIsOnSale[i];
551             desiredPrice[nextSkinId] = legacyDesiredPrice[i];
552     
553             // Emit the create event
554             CreateNewSkin(nextSkinId, legacyOwner[i]);
555     
556             nextSkinId++;
557             numSkinOfAccounts[legacyOwner[i]] += 1;   
558             skinCreatedNum += 1;
559         }
560     }
561 
562     // Summon
563     function summon() external payable whenNotPaused {
564         // Clear daily summon numbers
565         if (accountLastClearTime[msg.sender] == uint256(0)) {
566             // This account's first time to summon, we do not need to clear summon numbers
567             accountLastClearTime[msg.sender] = now;
568         } else {
569             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
570                 accountToSummonNum[msg.sender] = 0;
571                 accountToPayLevel[msg.sender] = 0;
572                 accountLastClearTime[msg.sender] = now;
573             }
574         }
575 
576         uint256 payLevel = accountToPayLevel[msg.sender];
577         uint256 price = payMultiple[payLevel] * baseSummonPrice;
578         require(msg.value >= price);
579 
580         // Create random skin
581         uint128 randomAppearance = mixFormula.randomSkinAppearance(nextSkinId);
582         // uint128 randomAppearance = 0;
583         Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
584         skins[nextSkinId] = newSkin;
585         skinIdToOwner[nextSkinId] = msg.sender;
586         isOnSale[nextSkinId] = false;
587 
588         // Emit the create event
589         CreateNewSkin(nextSkinId, msg.sender);
590 
591         nextSkinId++;
592         numSkinOfAccounts[msg.sender] += 1;
593         
594         accountToSummonNum[msg.sender] += 1;
595         
596         // Handle the paylevel        
597         if (payLevel < 5) {
598             if (accountToSummonNum[msg.sender] >= levelSplits[payLevel]) {
599                 accountToPayLevel[msg.sender] = payLevel + 1;
600             }
601         }
602     }
603 
604     // Bleach some attributes
605     function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {
606         // Clear daily summon numbers
607         if (accountLastClearTime[msg.sender] == uint256(0)) {
608             // This account's first time to summon, we do not need to clear bleach numbers
609             accountLastClearTime[msg.sender] = now;
610         } else {
611             if (accountLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
612                 accountToBleachNum[msg.sender] = 0;
613                 accountLastClearTime[msg.sender] = now;
614             }
615         }
616 
617         require(accountToBleachNum[msg.sender] < bleachDailyLimit);
618         accountToBleachNum[msg.sender] += 1;
619 
620         // Check whether msg.sender is owner of the skin 
621         require(msg.sender == skinIdToOwner[skinId]);
622 
623         // Check whether this skin is on sale 
624         require(isOnSale[skinId] == false);
625 
626         // Check whether there is enough money
627         uint256 bleachNum = 0;
628         for (uint256 i = 0; i < 8; i++) {
629             if ((attributes & (uint128(1) << i)) > 0) {
630                 bleachNum++;
631             }
632         }
633         if (bleachNum == 0) {
634             bleachNum = 1;
635         }
636         require(msg.value >= bleachNum * bleachPrice);
637 
638         Skin storage originSkin = skins[skinId];
639         // Check whether this skin is in mixing 
640         require(originSkin.mixingWithId == 0);
641         
642         uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);
643         originSkin.appearance = newAppearance;
644 
645         // Emit bleach event
646         Bleach(skinId, newAppearance);
647     }
648 
649     // Our daemon will clear daily summon numbers
650     function clearSummonNum() external onlyCOO {
651         uint256 nextDay = levelClearTime + 1 days;
652         if (now > nextDay) {
653             levelClearTime = nextDay;
654         }
655     }
656 }