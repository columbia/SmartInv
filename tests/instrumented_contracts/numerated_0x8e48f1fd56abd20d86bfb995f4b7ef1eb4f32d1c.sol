1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev Throws if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 
36 }
37 
38 /**
39  * @title Pausable
40  * @dev Base contract which allows children to implement an emergency stop mechanism.
41  */
42 contract Pausable is Ownable {
43   event Pause();
44   event Unpause();
45 
46   bool public paused = false;
47 
48 
49   /**
50    * @dev Modifier to make a function callable only when the contract is not paused.
51    */
52   modifier whenNotPaused() {
53     require(!paused);
54     _;
55   }
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is paused.
59    */
60   modifier whenPaused() {
61     require(paused);
62     _;
63   }
64 
65   /**
66    * @dev called by the owner to pause, triggers stopped state
67    */
68   function pause() onlyOwner whenNotPaused public {
69     paused = true;
70     Pause();
71   }
72 
73   /**
74    * @dev called by the owner to unpause, returns to normal state
75    */
76   function unpause() onlyOwner whenPaused public {
77     paused = false;
78     Unpause();
79   }
80 }
81 
82 contract SkinBase is Pausable {
83 
84     struct Skin {
85         uint128 appearance;
86         uint64 cooldownEndTime;
87         uint64 mixingWithId;
88     }
89 
90     // All skins, mapping from skin id to skin apprance
91     mapping (uint256 => Skin) skins;
92 
93     // Mapping from skin id to owner
94     mapping (uint256 => address) public skinIdToOwner;
95 
96     // Whether a skin is on sale
97     mapping (uint256 => bool) public isOnSale;
98 
99     // Number of all total valid skins
100     // skinId 0 should not correspond to any skin, because skin.mixingWithId==0 indicates not mixing
101     uint256 public nextSkinId = 1;  
102 
103     // Number of skins an account owns
104     mapping (address => uint256) public numSkinOfAccounts;
105 
106     // // Give some skins to init account for unit tests
107     // function SkinBase() public {
108     //     address account0 = 0x627306090abaB3A6e1400e9345bC60c78a8BEf57;
109     //     address account1 = 0xf17f52151EbEF6C7334FAD080c5704D77216b732;
110 
111     //     // Create simple skins
112     //     Skin memory skin = Skin({appearance: 0, cooldownEndTime:0, mixingWithId: 0});
113     //     for (uint256 i = 1; i <= 15; i++) {
114     //         if (i < 10) {
115     //             skin.appearance = uint128(i);
116     //             if (i < 7) { 
117     //                 skinIdToOwner[i] = account0;
118     //                 numSkinOfAccounts[account0] += 1;
119     //             } else {  
120     //                 skinIdToOwner[i] = account1;
121     //                 numSkinOfAccounts[account1] += 1;
122     //             }
123     //         } else {  
124     //             skin.appearance = uint128(block.blockhash(block.number - i + 9));
125     //             skinIdToOwner[i] = account1;
126     //             numSkinOfAccounts[account1] += 1;
127     //         }
128     //         skins[i] = skin;
129     //         isOnSale[i] = false;
130     //         nextSkinId += 1;
131     //     }
132     // } 
133 
134     // Get the i-th skin an account owns, for off-chain usage only
135     function skinOfAccountById(address account, uint256 id) external view returns (uint256) {
136        uint256 count = 0;
137        uint256 numSkinOfAccount = numSkinOfAccounts[account];
138        require(numSkinOfAccount > 0);
139        require(id < numSkinOfAccount);
140        for (uint256 i = 1; i < nextSkinId; i++) {
141            if (skinIdToOwner[i] == account) {
142                // This skin belongs to current account
143                if (count == id) {
144                    // This is the id-th skin of current account, a.k.a, what we need
145                     return i;
146                } 
147                count++;
148            }
149         }
150         revert();
151     }
152 
153     // Get skin by id
154     function getSkin(uint256 id) public view returns (uint128, uint64, uint64) {
155         require(id > 0);
156         require(id < nextSkinId);
157         Skin storage skin = skins[id];
158         return (skin.appearance, skin.cooldownEndTime, skin.mixingWithId);
159     }
160 
161     function withdrawETH() external onlyOwner {
162         owner.transfer(this.balance);
163     }
164 }
165 contract MixFormulaInterface {
166     function calcNewSkinAppearance(uint128 x, uint128 y) public pure returns (uint128);
167 
168     // create random appearance
169     function randomSkinAppearance() public view returns (uint128);
170 
171     // bleach
172     function bleachAppearance(uint128 appearance, uint128 attributes) public pure returns (uint128);
173 }
174 contract SkinMix is SkinBase {
175 
176     // Mix formula
177     MixFormulaInterface public mixFormula;
178 
179 
180     // Pre-paid ether for synthesization, will be returned to user if the synthesization failed (minus gas).
181     uint256 public prePaidFee = 2500000 * 5000000000; // (0.15million gas * 5 gwei)
182 
183     // Events
184     event MixStart(address account, uint256 skinAId, uint256 skinBId);
185     event AutoMix(address account, uint256 skinAId, uint256 skinBId, uint64 cooldownEndTime);
186     event MixSuccess(address account, uint256 skinId, uint256 skinAId, uint256 skinBId);
187 
188     // Set mix formula contract address 
189     function setMixFormulaAddress(address mixFormulaAddress) external onlyOwner {
190         mixFormula = MixFormulaInterface(mixFormulaAddress);
191     }
192 
193     // setPrePaidFee: set advance amount, only owner can call this
194     function setPrePaidFee(uint256 newPrePaidFee) external onlyOwner {
195         prePaidFee = newPrePaidFee;
196     }
197 
198     // _isCooldownReady: check whether cooldown period has been passed
199     function _isCooldownReady(uint256 skinAId, uint256 skinBId) private view returns (bool) {
200         return (skins[skinAId].cooldownEndTime <= uint64(now)) && (skins[skinBId].cooldownEndTime <= uint64(now));
201     }
202 
203     // _isNotMixing: check whether two skins are in another mixing process
204     function _isNotMixing(uint256 skinAId, uint256 skinBId) private view returns (bool) {
205         return (skins[skinAId].mixingWithId == 0) && (skins[skinBId].mixingWithId == 0);
206     }
207 
208     // _setCooldownTime: set new cooldown time
209     function _setCooldownEndTime(uint256 skinAId, uint256 skinBId) private {
210         uint256 end = now + 5 minutes;
211         // uint256 end = now;
212         skins[skinAId].cooldownEndTime = uint64(end);
213         skins[skinBId].cooldownEndTime = uint64(end);
214     }
215 
216     // _isValidSkin: whether an account can mix using these skins
217     // Make sure two things:
218     // 1. these two skins do exist
219     // 2. this account owns these skins
220     function _isValidSkin(address account, uint256 skinAId, uint256 skinBId) private view returns (bool) {
221         // Make sure those two skins belongs to this account
222         if (skinAId == skinBId) {
223             return false;
224         }
225         if ((skinAId == 0) || (skinBId == 0)) {
226             return false;
227         }
228         if ((skinAId >= nextSkinId) || (skinBId >= nextSkinId)) {
229             return false;
230         }
231         return (skinIdToOwner[skinAId] == account) && (skinIdToOwner[skinBId] == account);
232     }
233 
234     // _isNotOnSale: whether a skin is not on sale
235     function _isNotOnSale(uint256 skinId) private view returns (bool) {
236         return (isOnSale[skinId] == false);
237     }
238 
239     // mix  
240     function mix(uint256 skinAId, uint256 skinBId) public whenNotPaused {
241 
242         // Check whether skins are valid
243         require(_isValidSkin(msg.sender, skinAId, skinBId));
244 
245         // Check whether skins are neither on sale
246         require(_isNotOnSale(skinAId) && _isNotOnSale(skinBId));
247 
248         // Check cooldown
249         require(_isCooldownReady(skinAId, skinBId));
250 
251         // Check these skins are not in another process
252         require(_isNotMixing(skinAId, skinBId));
253 
254         // Set new cooldown time
255         _setCooldownEndTime(skinAId, skinBId);
256 
257         // Mark skins as in mixing
258         skins[skinAId].mixingWithId = uint64(skinBId);
259         skins[skinBId].mixingWithId = uint64(skinAId);
260 
261         // Emit MixStart event
262         MixStart(msg.sender, skinAId, skinBId);
263     }
264 
265     // Mixing auto
266     function mixAuto(uint256 skinAId, uint256 skinBId) public payable whenNotPaused {
267         require(msg.value >= prePaidFee);
268 
269         mix(skinAId, skinBId);
270 
271         Skin storage skin = skins[skinAId];
272 
273         AutoMix(msg.sender, skinAId, skinBId, skin.cooldownEndTime);
274     }
275 
276     // Get mixing result, return the resulted skin id
277     function getMixingResult(uint256 skinAId, uint256 skinBId) public whenNotPaused {
278         // Check these two skins belongs to the same account
279         address account = skinIdToOwner[skinAId];
280         require(account == skinIdToOwner[skinBId]);
281 
282         // Check these two skins are in the same mixing process
283         Skin storage skinA = skins[skinAId];
284         Skin storage skinB = skins[skinBId];
285         require(skinA.mixingWithId == uint64(skinBId));
286         require(skinB.mixingWithId == uint64(skinAId));
287 
288         // Check cooldown
289         require(_isCooldownReady(skinAId, skinBId));
290 
291         // Create new skin
292         uint128 newSkinAppearance = mixFormula.calcNewSkinAppearance(skinA.appearance, skinB.appearance);
293         Skin memory newSkin = Skin({appearance: newSkinAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
294         skins[nextSkinId] = newSkin;
295         skinIdToOwner[nextSkinId] = account;
296         isOnSale[nextSkinId] = false;
297         nextSkinId++;
298 
299         // Clear old skins
300         skinA.mixingWithId = 0;
301         skinB.mixingWithId = 0;
302 
303         // In order to distinguish created skins in minting with destroyed skins
304         // skinIdToOwner[skinAId] = owner;
305         // skinIdToOwner[skinBId] = owner;
306         delete skinIdToOwner[skinAId];
307         delete skinIdToOwner[skinBId];
308         // require(numSkinOfAccounts[account] >= 2);
309         numSkinOfAccounts[account] -= 1;
310 
311         MixSuccess(account, nextSkinId - 1, skinAId, skinBId);
312     }
313 }
314 contract SkinMarket is SkinMix {
315 
316     // Cut ratio for a transaction
317     // Values 0-10,000 map to 0%-100%
318     uint128 public trCut = 290;
319 
320     // Sale orders list 
321     mapping (uint256 => uint256) public desiredPrice;
322 
323     // events
324     event PutOnSale(address account, uint256 skinId);
325     event WithdrawSale(address account, uint256 skinId);
326     event BuyInMarket(address buyer, uint256 skinId);
327 
328     // functions
329 
330     // Put asset on sale
331     function putOnSale(uint256 skinId, uint256 price) public whenNotPaused {
332         // Only owner of skin pass
333         require(skinIdToOwner[skinId] == msg.sender);
334 
335         // Check whether skin is mixing 
336         require(skins[skinId].mixingWithId == 0);
337 
338         // Check whether skin is already on sale
339         require(isOnSale[skinId] == false);
340 
341         require(price > 0); 
342 
343         // Put on sale
344         desiredPrice[skinId] = price;
345         isOnSale[skinId] = true;
346 
347         // Emit the Approval event
348         PutOnSale(msg.sender, skinId);
349     }
350   
351     // Withdraw an sale order
352     function withdrawSale(uint256 skinId) external whenNotPaused {
353         // Check whether this skin is on sale
354         require(isOnSale[skinId] == true);
355         
356         // Can only withdraw self's sale
357         require(skinIdToOwner[skinId] == msg.sender);
358 
359         // Withdraw
360         isOnSale[skinId] = false;
361         desiredPrice[skinId] = 0;
362 
363         // Emit the cancel event
364         WithdrawSale(msg.sender, skinId);
365     }
366  
367     // Buy skin in market
368     function buyInMarket(uint256 skinId) external payable whenNotPaused {
369         // Check whether this skin is on sale
370         require(isOnSale[skinId] == true);
371 
372         address seller = skinIdToOwner[skinId];
373 
374         // Check the sender isn't the seller
375         require(msg.sender != seller);
376 
377         uint256 _price = desiredPrice[skinId];
378         // Check whether pay value is enough
379         require(msg.value >= _price);
380 
381         // Cut and then send the proceeds to seller
382         uint256 sellerProceeds = _price - _computeCut(_price);
383 
384         seller.transfer(sellerProceeds);
385 
386         // Transfer skin from seller to buyer
387         numSkinOfAccounts[seller] -= 1;
388         skinIdToOwner[skinId] = msg.sender;
389         numSkinOfAccounts[msg.sender] += 1;
390         isOnSale[skinId] = false;
391         desiredPrice[skinId] = 0;
392 
393         // Emit the buy event
394         BuyInMarket(msg.sender, skinId);
395     }
396 
397     // Compute the marketCut
398     function _computeCut(uint256 _price) internal view returns (uint256) {
399         return _price * trCut / 10000;
400     }
401 }
402 contract SkinMinting is SkinMarket {
403 
404     // Limits the number of skins the contract owner can ever create.
405     uint256 public skinCreatedLimit = 50000;
406 
407     // The summon numbers of each accouts: will be cleared every day
408     mapping (address => uint256) public accoutToSummonNum;
409 
410     // Pay level of each accouts
411     mapping (address => uint256) public accoutToPayLevel;
412     mapping (address => uint256) public accountsLastClearTime;
413 
414     uint256 public levelClearTime = now;
415 
416     // price
417     uint256 public baseSummonPrice = 3 finney;
418     uint256 public bleachPrice = 30 finney;
419 
420     // Pay level
421     uint256[5] public levelSplits = [10,
422                                      20,
423                                      50,
424                                      100,
425                                      200];
426     
427     uint256[6] public payMultiple = [1,
428                                      2,
429                                      4,
430                                      8,
431                                      20,
432                                      100];
433 
434 
435     // events
436     event CreateNewSkin(uint256 skinId, address account);
437     event Bleach(uint256 skinId, uint128 newAppearance);
438 
439     // functions
440 
441     // Set price 
442     function setBaseSummonPrice(uint256 newPrice) external onlyOwner {
443         baseSummonPrice = newPrice;
444     }
445 
446     function setBleachPrice(uint256 newPrice) external onlyOwner {
447         bleachPrice = newPrice;
448     }
449 
450     // Create base skin for sell. Only owner can create
451     function createSkin(uint128 specifiedAppearance, uint256 salePrice) external onlyOwner whenNotPaused {
452         require(numSkinOfAccounts[owner] < skinCreatedLimit);
453 
454         // Create specified skin
455         // uint128 randomAppearance = mixFormula.randomSkinAppearance();
456         Skin memory newSkin = Skin({appearance: specifiedAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
457         skins[nextSkinId] = newSkin;
458         skinIdToOwner[nextSkinId] = owner;
459         isOnSale[nextSkinId] = false;
460 
461         // Emit the create event
462         CreateNewSkin(nextSkinId, owner);
463 
464         // Put this skin on sale
465         putOnSale(nextSkinId, salePrice);
466 
467         nextSkinId++;
468         numSkinOfAccounts[owner] += 1;   
469     }
470 
471     // Summon
472     function summon() external payable whenNotPaused {
473         // Clear daily summon numbers
474         if (accountsLastClearTime[msg.sender] == uint256(0)) {
475             // This account's first time to summon, we do not need to clear summon numbers
476             accountsLastClearTime[msg.sender] = now;
477         } else {
478             if (accountsLastClearTime[msg.sender] < levelClearTime && now > levelClearTime) {
479                 accoutToSummonNum[msg.sender] = 0;
480                 accoutToPayLevel[msg.sender] = 0;
481                 accountsLastClearTime[msg.sender] = now;
482             }
483         }
484 
485         uint256 payLevel = accoutToPayLevel[msg.sender];
486         uint256 price = payMultiple[payLevel] * baseSummonPrice;
487         require(msg.value >= price);
488 
489         // Create random skin
490         uint128 randomAppearance = mixFormula.randomSkinAppearance();
491         // uint128 randomAppearance = 0;
492         Skin memory newSkin = Skin({appearance: randomAppearance, cooldownEndTime: uint64(now), mixingWithId: 0});
493         skins[nextSkinId] = newSkin;
494         skinIdToOwner[nextSkinId] = msg.sender;
495         isOnSale[nextSkinId] = false;
496 
497         // Emit the create event
498         CreateNewSkin(nextSkinId, msg.sender);
499 
500         nextSkinId++;
501         numSkinOfAccounts[msg.sender] += 1;
502         
503         accoutToSummonNum[msg.sender] += 1;
504         
505         // Handle the paylevel        
506         if (payLevel < 5) {
507             if (accoutToSummonNum[msg.sender] >= levelSplits[payLevel]) {
508                 accoutToPayLevel[msg.sender] = payLevel + 1;
509             }
510         }
511     }
512 
513     // Bleach some attributes
514     function bleach(uint128 skinId, uint128 attributes) external payable whenNotPaused {
515         // Check whether msg.sender is owner of the skin 
516         require(msg.sender == skinIdToOwner[skinId]);
517 
518         // Check whether this skin is on sale 
519         require(isOnSale[skinId] == false);
520 
521         // Check whether there is enough money
522         require(msg.value >= bleachPrice);
523 
524         Skin storage originSkin = skins[skinId];
525         // Check whether this skin is in mixing 
526         require(originSkin.mixingWithId == 0);
527 
528         uint128 newAppearance = mixFormula.bleachAppearance(originSkin.appearance, attributes);
529         originSkin.appearance = newAppearance;
530 
531         // Emit bleach event
532         Bleach(skinId, newAppearance);
533     }
534 
535     // Our daemon will clear daily summon numbers
536     function clearSummonNum() external onlyOwner {
537         uint256 nextDay = levelClearTime + 1 days;
538         if (now > nextDay) {
539             levelClearTime = nextDay;
540         }
541     }
542 }