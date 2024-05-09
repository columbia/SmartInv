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
43     /**
44     * @dev Allows the current owner to transfer control of the contract to a newCeo.
45     * @param newCeo The address to transfer ownership to.
46     */
47     function demiseCEO(address newCeo) public onlyCEO {
48         require(newCeo != address(0));
49         OwnershipTransferred(ceo, newCeo);
50         ceo = newCeo;
51     }
52 
53     function setCFO(address newCfo) public onlyCEO {
54         require(newCfo != address(0));
55         cfo = newCfo;
56     }
57 
58     function setCOO(address newCoo) public onlyCEO {
59         require(newCoo != address(0));
60         coo = newCoo;
61     }
62 
63     function setCAO(address newCao) public onlyCEO {
64         require(newCao != address(0));
65         cao = newCao;
66     }
67 
68     bool public paused = false;
69 
70 
71     /**
72     * @dev Modifier to make a function callable only when the contract is not paused.
73     */
74     modifier whenNotPaused() {
75         require(!paused);
76         _;
77     }
78 
79     /**
80     * @dev Modifier to make a function callable only when the contract is paused.
81     */
82     modifier whenPaused() {
83         require(paused);
84         _;
85     }
86 
87     /**
88     * @dev called by the owner to pause, triggers stopped state
89     */
90     function pause() onlyCAO whenNotPaused public {
91         paused = true;
92         Pause();
93     }
94 
95     /**
96     * @dev called by the owner to unpause, returns to normal state
97     */
98     function unpause() onlyCAO whenPaused public {
99         paused = false;
100         Unpause();
101     }
102 }
103 
104 
105 contract SkinBase is Manager {
106 
107     struct Skin {
108         uint128 appearance;
109         uint64 cooldownEndTime;
110         uint64 mixingWithId;
111     }
112 
113     // All skins, mapping from skin id to skin apprance
114     mapping (uint256 => Skin) skins;
115 
116     // Mapping from skin id to owner
117     mapping (uint256 => address) public skinIdToOwner;
118 
119     // Whether a skin is on sale
120     mapping (uint256 => bool) public isOnSale;
121 
122     // Number of all total valid skins
123     // skinId 0 should not correspond to any skin, because skin.mixingWithId==0 indicates not mixing
124     uint256 public nextSkinId = 1;  
125 
126     // Number of skins an account owns
127     mapping (address => uint256) public numSkinOfAccounts;
128 
129     // // Give some skins to init account for unit tests
130     // function SkinBase() public {
131     //     address account0 = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
132     //     address account1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
133 
134     //     // Create simple skins
135     //     Skin memory skin = Skin({appearance: 0, cooldownEndTime:0, mixingWithId: 0});
136     //     for (uint256 i = 1; i <= 15; i++) {
137     //         if (i < 10) {
138     //             skin.appearance = uint128(i);
139     //             if (i < 7) { 
140     //                 skinIdToOwner[i] = account0;
141     //                 numSkinOfAccounts[account0] += 1;
142     //             } else {  
143     //                 skinIdToOwner[i] = account1;
144     //                 numSkinOfAccounts[account1] += 1;
145     //             }
146     //         } else {  
147     //             skin.appearance = uint128(block.blockhash(block.number - i + 9));
148     //             skinIdToOwner[i] = account1;
149     //             numSkinOfAccounts[account1] += 1;
150     //         }
151     //         skins[i] = skin;
152     //         isOnSale[i] = false;
153     //         nextSkinId += 1;
154     //     }
155     // } 
156 
157     // Get the i-th skin an account owns, for off-chain usage only
158     function skinOfAccountById(address account, uint256 id) external view returns (uint256) {
159        uint256 count = 0;
160        uint256 numSkinOfAccount = numSkinOfAccounts[account];
161        require(numSkinOfAccount > 0);
162        require(id < numSkinOfAccount);
163        for (uint256 i = 1; i < nextSkinId; i++) {
164            if (skinIdToOwner[i] == account) {
165                // This skin belongs to current account
166                if (count == id) {
167                    // This is the id-th skin of current account, a.k.a, what we need
168                     return i;
169                } 
170                count++;
171            }
172         }
173         revert();
174     }
175 
176     // Get skin by id
177     function getSkin(uint256 id) public view returns (uint128, uint64, uint64) {
178         require(id > 0);
179         require(id < nextSkinId);
180         Skin storage skin = skins[id];
181         return (skin.appearance, skin.cooldownEndTime, skin.mixingWithId);
182     }
183 
184     function withdrawETH() external onlyCAO {
185         cfo.transfer(this.balance);
186     }
187 }
188 
189 
190 contract MixFormulaInterface {
191     function calcNewSkinAppearance(uint128 x, uint128 y) public pure returns (uint128);
192 
193     // create random appearance
194     function randomSkinAppearance(uint256 externalNum) public view returns (uint128);
195 
196     // bleach
197     function bleachAppearance(uint128 appearance, uint128 attributes) public pure returns (uint128);
198 }
199 
200 contract SkinMix is SkinBase {
201 
202     // Mix formula
203     MixFormulaInterface public mixFormula;
204 
205 
206     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
207     uint256 public prePaidFee = 150000 * 5000000000; // (15w gas * 5 gwei)
208 
209     // Events
210     event MixStart(address account, uint256 skinAId, uint256 skinBId);
211     event AutoMix(address account, uint256 skinAId, uint256 skinBId, uint64 cooldownEndTime);
212     event MixSuccess(address account, uint256 skinId, uint256 skinAId, uint256 skinBId);
213 
214     // Set mix formula contract address 
215     function setMixFormulaAddress(address mixFormulaAddress) external onlyCOO {
216         mixFormula = MixFormulaInterface(mixFormulaAddress);
217     }
218 
219     // setPrePaidFee: set advance amount, only owner can call this
220     function setPrePaidFee(uint256 newPrePaidFee) external onlyCOO {
221         prePaidFee = newPrePaidFee;
222     }
223 
224     // _isCooldownReady: check whether cooldown period has been passed
225     function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {
226         return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));
227     }
228 
229     // _isNotMixing: check whether two skins are in another mixing process
230     function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {
231         return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);
232     }
233 
234     // _setCooldownTime: set new cooldown time
235     function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {
236         uint256 end = now + 5 minutes;
237         // uint256 end = now;
238         skins[skinAId].cooldownEndTime = uint64(end);
239         skins[skinBId].cooldownEndTime = uint64(end);
240     }
241 
242     // _isValidSkin: whether an account can mix using these skins
243     // Make sure two things:
244     // 1. these two skins do exist
245     // 2. this account owns these skins
246     function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {
247         // Make sure those two skins belongs to this account
248         if (skinAId == skinBId) {
249             return false;
250         }
251         if ((skinAId == 0) || (skinBId == 0)) {
252             return false;
253         }
254         if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {
255             return false;
256         }
257         return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);
258     }
259 
260     // _isNotOnSale: whether a skin is not on sale
261     function _isNotOnSale(uint256 skinId) private view returns (bool) {
262         return (isOnSale[skinId] == false);
263     }
264 
265     // mix  
266     function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {
267 
268         // Check whether skins are valid
269         require(_isValidSkin(msg.sender, skinAId, skinBId));
270 
271         // Check whether skins are neither on sale
272         require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));
273 
274         // Check cooldown
275         require(_isCooldownReady(skinAId, skinBId));
276 
277         // Check these skins are not in another process
278         require(_isNotMixing(skinAId, skinBId));
279 
280         // Set new cooldown time
281         _setCooldownEndTime(skinAId, skinBId);
282 
283         // Mark skins as in mixing
284         skins[skinAId].mixingWithId = uint64(skinBId);
285         skins[skinBId].mixingWithId = uint64(skinAId);
286 
287         // Emit MixStart event
288         MixStart(msg.sender, skinAId, skinBId);
289     }
290 
291     // Mixing auto
292     function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {
293         require(msg.value >= prePaidFee);
294 
295         mix(skinAId, skinBId);
296 
297         Skin storage skin = skins[skinAId];
298 
299         AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);
300     }
301 
302     // Get mixing result, return the resulted skin id
303     function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {
304         // Check these two skins belongs to the same account
305         address account = skinIdToOwner[skinAId];
306         require(account == skinIdToOwner[skinBId]);
307 
308         // Check these two skins are in the same mixing process
309         Skin storage skinA = skins[skinAId];
310         Skin storage skinB = skins[skinBId];
311         require(skinA.mixingWithId == uint64(skinBId));
312         require(skinB.mixingWithId == uint64(skinAId));
313 
314         // Check cooldown
315         require(_isCooldownReady(skinAId, skinBId));
316 
317         // Create new skin
318         uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance);
319         Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
320         skins[nextSkinId] = newSkin;
321         skinIdToOwner[nextSkinId] = account;
322         isOnSale[nextSkinId] = false;
323         nextSkinId++;
324 
325         // Clear old skins
326         skinA.mixingWithId = 0;
327         skinB.mixingWithId = 0;
328 
329         // In order to distinguish created skins in minting with destroyed skins
330         // skinIdToOwner[skinAId] = owner;
331         // skinIdToOwner[skinBId] = owner;
332         delete skinIdToOwner[skinAId];
333         delete skinIdToOwner[skinBId];
334         // require(numSkinOfAccounts[account] >= 2);
335         numSkinOfAccounts[account] -= 1;
336 
337         MixSuccess(account, nextSkinId - 1, skinAId, skinBId);
338     }
339 }
340 
341 contract SkinMarket is SkinMix {
342 
343     // Cut ratio for a transaction
344     // Values 0-10,000 map to 0%-100%
345     uint128 public trCut = 400;
346 
347     // Sale orders list 
348     mapping (uint256 => uint256) public desiredPrice;
349 
350     // events
351     event PutOnSale(address account, uint256 skinId);
352     event WithdrawSale(address account, uint256 skinId);
353     event BuyInMarket(address buyer, uint256 skinId);
354 
355     // functions
356 
357     function setTrCut(uint256 newCut) external onlyCOO {
358         trCut = uint128(newCut);
359     }
360 
361     // Put asset on sale
362     function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {
363         // Only owner of skin pass
364         require(skinIdToOwner[skinId] == msg.sender);
365 
366         // Check whether skin is mixing 
367         require(skins[skinId].mixingWithId == 0);
368 
369         // Check whether skin is already on sale
370         require(isOnSale[skinId] == false);
371 
372         require(price > 0); 
373 
374         // Put on sale
375         desiredPrice[skinId] = price;
376         isOnSale[skinId] = true;
377 
378         // Emit the Approval event
379         PutOnSale(msg.sender, skinId);
380     }
381   
382     // Withdraw an sale order
383     function withdrawSale(uint256 skinId) external whenNotPaused {
384         // Check whether this skin is on sale
385         require(isOnSale[skinId] == true);
386         
387         // Can only withdraw self's sale
388         require(skinIdToOwner[skinId] == msg.sender);
389 
390         // Withdraw
391         isOnSale[skinId] = false;
392         desiredPrice[skinId] = 0;
393 
394         // Emit the cancel event
395         WithdrawSale(msg.sender, skinId);
396     }
397  
398     // Buy skin in market
399     function buyInMarket(uint256 skinId) external payable whenNotPaused {
400         // Check whether this skin is on sale
401         require(isOnSale[skinId] == true);
402 
403         address seller = skinIdToOwner[skinId];
404 
405         // Check the sender isn't the seller
406         require(msg.sender != seller);
407 
408         uint256 _price = desiredPrice[skinId];
409         // Check whether pay value is enough
410         require(msg.value >= _price);
411 
412         // Cut and then send the proceeds to seller
413         uint256 sellerProceeds = _price - _computeCut(_price);
414 
415         seller.transfer(sellerProceeds);
416 
417         // Transfer skin from seller to buyer
418         numSkinOfAccounts[seller] -= 1;
419         skinIdToOwner[skinId] = msg.sender;
420         numSkinOfAccounts[msg.sender] += 1;
421         isOnSale[skinId] = false;
422         desiredPrice[skinId] = 0;
423 
424         // Emit the buy event
425         BuyInMarket(msg.sender, skinId);
426     }
427 
428     // Compute the marketCut
429     function _computeCut(uint256 _price) internal view returns (uint256) {
430         return _price * trCut / 10000;
431     }
432 }
433 
434 contract SkinMinting is SkinMarket {
435 
436     // Limits the number of skins the contract owner can ever create.
437     uint256 public skinCreatedLimit = 50000;
438     uint256 public skinCreatedNum;
439 
440     // The summon numbers of each accouts: will be cleared every day
441     mapping (address => uint256) public accoutToSummonNum;
442 
443     // Pay level of each accouts
444     mapping (address => uint256) public accoutToPayLevel;
445     mapping (address => uint256) public accountsLastClearTime;
446 
447     uint256 public levelClearTime = now;
448 
449     // price
450     uint256 public baseSummonPrice = 1 finney;
451     uint256 public bleachPrice = 300 finney;  // do not call this
452 
453     // Pay level
454     uint256[5] public levelSplits = [10,
455                                      20,
456                                      50,
457                                      100,
458                                      200];
459     
460     uint256[6] public payMultiple = [10,
461                                      12,
462                                      15,
463                                      20,
464                                      30,
465                                      40];
466 
467 
468     // events
469     event CreateNewSkin(uint256 skinId, address account);
470     event Bleach(uint256 skinId, uint128 newAppearance);
471 
472     // functions
473 
474     // Set price 
475     function setBaseSummonPrice(uint256 newPrice) external onlyCOO {
476         baseSummonPrice = newPrice;
477     }
478 
479     function setBleachPrice(uint256 newPrice) external onlyCOO {
480         bleachPrice = newPrice;
481     }
482 
483     // Create base skin for sell. Only owner can create
484     function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyCOO {
485         require(skinCreatedNum < skinCreatedLimit);
486 
487         // Create specified skin
488         // uint128 randomAppearance = mixFormula.randomSkinAppearance();
489         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
490         skins[nextSkinId] = newSkin;
491         skinIdToOwner[nextSkinId] = coo;
492         isOnSale[nextSkinId] = false;
493 
494         // Emit the create event
495         CreateNewSkin(nextSkinId, coo);
496 
497         // Put this skin on sale
498         putOnSale(nextSkinId, salePrice);
499 
500         nextSkinId++;
501         numSkinOfAccounts[coo] += 1;   
502         skinCreatedNum += 1;
503     }
504 
505     // Donate a skin to player. Only COO can operate
506     function donateSkin(uint128 specifiedAppearance, address donee) external onlyCOO {
507         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
508         skins[nextSkinId] = newSkin;
509         skinIdToOwner[nextSkinId] = donee;
510         isOnSale[nextSkinId] = false;
511 
512         // Emit the create event
513         CreateNewSkin(nextSkinId, donee);
514 
515         nextSkinId++;
516         numSkinOfAccounts[donee] += 1;   
517         skinCreatedNum += 1;
518     }
519 
520     // Summon
521     function summon() external payable whenNotPaused {
522         // Clear daily summon numbers
523         if (accountsLastClearTime[msg.sender] == uint256(0)) {
524             // This account's first time to summon, we do not need to clear summon numbers
525             accountsLastClearTime[msg.sender] = now;
526         } else {
527             if (accountsLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
528                 accoutToSummonNum[msg.sender] = 0;
529                 accoutToPayLevel[msg.sender] = 0;
530                 accountsLastClearTime[msg.sender] = now;
531             }
532         }
533 
534         uint256 payLevel = accoutToPayLevel[msg.sender];
535         uint256 price = payMultiple[payLevel] * baseSummonPrice;
536         require(msg.value >= price);
537 
538         // Create random skin
539         uint128 randomAppearance = mixFormula.randomSkinAppearance(nextSkinId);
540         // uint128 randomAppearance = 0;
541         Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
542         skins[nextSkinId] = newSkin;
543         skinIdToOwner[nextSkinId] = msg.sender;
544         isOnSale[nextSkinId] = false;
545 
546         // Emit the create event
547         CreateNewSkin(nextSkinId, msg.sender);
548 
549         nextSkinId++;
550         numSkinOfAccounts[msg.sender] += 1;
551         
552         accoutToSummonNum[msg.sender] += 1;
553         
554         // Handle the paylevel        
555         if (payLevel < 5) {
556             if (accoutToSummonNum[msg.sender] >= levelSplits[payLevel]) {
557                 accoutToPayLevel[msg.sender] = payLevel + 1;
558             }
559         }
560     }
561 
562     // Bleach some attributes
563     function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {
564         // Check whether msg.sender is owner of the skin 
565         require(msg.sender == skinIdToOwner[skinId]);
566 
567         // Check whether this skin is on sale 
568         require(isOnSale[skinId] == false);
569 
570         // Check whether there is enough money
571         require(msg.value >= bleachPrice);
572 
573         Skin storage originSkin = skins[skinId];
574         // Check whether this skin is in mixing 
575         require(originSkin.mixingWithId == 0);
576 
577         uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);
578         originSkin.appearance = newAppearance;
579 
580         // Emit bleach event
581         Bleach(skinId, newAppearance);
582     }
583 
584     // Our daemon will clear daily summon numbers
585     function clearSummonNum() external onlyCOO {
586         uint256 nextDay = levelClearTime + 1 days;
587         if (now > nextDay) {
588             levelClearTime = nextDay;
589         }
590     }
591 }