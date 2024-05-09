1 // SPDX-License-Identifier: AGPL-3.0
2 
3 pragma solidity 0.8.1;
4 
5 interface IMoonCatAcclimator {
6     function getApproved(uint256 tokenId) external view returns (address);
7     function isApprovedForAll(address owner, address operator) external view returns (bool);
8     function ownerOf(uint256 tokenId) external view returns (address);
9 }
10 
11 interface IMoonCatRescue {
12     function rescueOrder(uint256 tokenId) external view returns (bytes5);
13     function catOwners(bytes5 catId) external view returns (address);
14 }
15 
16 interface IReverseResolver {
17     function claim(address owner) external returns (bytes32);
18 }
19 
20 interface IERC20 {
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 }
24 interface IERC721 {
25     function safeTransferFrom(address from, address to, uint256 tokenId) external;
26 }
27 
28 /**
29  * @dev Derived from OpenZeppelin standard template
30  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol
31  * b0cf6fbb7a70f31527f36579ad644e1cf12fdf4e
32  */
33 library EnumerableSet {
34     struct Set {
35         uint256[] _values;
36         mapping (uint256 => uint256) _indexes;
37     }
38 
39     function at(Set storage set, uint256 index) internal view returns (uint256) {
40         return set._values[index];
41     }
42 
43     function contains(Set storage set, uint256 value) internal view returns (bool) {
44         return set._indexes[value] != 0;
45     }
46 
47     function length(Set storage set) internal view returns (uint256) {
48         return set._values.length;
49     }
50 
51     function add(Set storage set, uint256 value) internal returns (bool) {
52         if (!contains(set, value)) {
53             set._values.push(value);
54             // The value is stored at length-1, but we add 1 to all indexes
55             // and use 0 as a sentinel value
56             set._indexes[value] = set._values.length;
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     function remove(Set storage set, uint256 value) internal returns (bool) {
64         // We read and store the value's index to prevent multiple reads from the same storage slot
65         uint256 valueIndex = set._indexes[value];
66         if (valueIndex != 0) { // Equivalent to contains(set, value)
67             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
68             // the array, and then remove the last element (sometimes called as 'swap and pop').
69             // This modifies the order of the array, as noted in {at}.
70             uint256 toDeleteIndex = valueIndex - 1;
71             uint256 lastIndex = set._values.length - 1;
72             if (lastIndex != toDeleteIndex) {
73                 uint256 lastvalue = set._values[lastIndex];
74                 // Move the last value to the index where the value to delete is
75                 set._values[toDeleteIndex] = lastvalue;
76                 // Update the index for the moved value
77                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
78             }
79 
80             // Delete the slot where the moved value was stored
81             set._values.pop();
82             // Delete the index for the deleted slot
83             delete set._indexes[value];
84             return true;
85         } else {
86             return false;
87         }
88     }
89 }
90 
91 library MoonCatBitSet {
92 
93     bytes32 constant Mask =  0x0000000000000000000000000000000000000000000000000000000000000001;
94 
95     function activate(bytes32[100] storage set)
96         internal
97     {
98         set[99] |= Mask;
99     }
100 
101     function deactivate(bytes32[100] storage set)
102         internal
103     {
104         set[99] &= ~Mask;
105     }
106 
107     function setBit(bytes32[100] storage set, uint16 index)
108         internal
109     {
110         uint16 wordIndex = index / 256;
111         uint16 bitIndex = index % 256;
112         bytes32 mask = Mask << (255 - bitIndex);
113         set[wordIndex] |= mask;
114     }
115 
116     function clearBit(bytes32[100] storage set, uint16 index)
117         internal
118     {
119         uint16 wordIndex = index / 256;
120         uint16 bitIndex = index % 256;
121         bytes32 mask = ~(Mask << (255 - bitIndex));
122         set[wordIndex] &= mask;
123     }
124 
125     function checkBit(bytes32[100] memory set, uint256 index)
126         internal
127         pure
128         returns (bool)
129     {
130         uint256 wordIndex = index / 256;
131         uint256 bitIndex = index % 256;
132         bytes32 mask = Mask << (255 - bitIndex);
133         return (mask & set[wordIndex]) != 0;
134     }
135 
136     function isActive(bytes32[100] memory set)
137         internal
138         pure
139         returns (bool)
140     {
141         return (Mask & set[99]) == Mask;
142     }
143 }
144 
145 
146 /**
147  * @title MoonCat​Accessories
148  * @notice Public MoonCat Wearables infrastructure/protocols
149  * @dev Allows wearable-designers to create accessories for sale and gifting.
150  */
151 contract MoonCatAccessories {
152 
153     /* External Contracts */
154 
155     IMoonCatAcclimator MCA = IMoonCatAcclimator(0xc3f733ca98E0daD0386979Eb96fb1722A1A05E69);
156     IMoonCatRescue MCR = IMoonCatRescue(0x60cd862c9C687A9dE49aecdC3A99b74A4fc54aB6);
157 
158     /* Events */
159 
160     event AccessoryCreated(uint256 accessoryId, address creator, uint256 price, uint16 totalSupply, bytes30 name);
161     event AccessoryManagementTransferred(uint256 accessoryId, address newManager);
162     event AccessoryPriceChanged(uint256 accessoryId, uint256 price);
163     event AccessoryPurchased(uint256 accessoryId, uint256 rescueOrder, uint256 price);
164     event AccessoryApplied(uint256 accessoryId, uint256 rescueOrder, uint8 paletteIndex, uint16 zIndex);
165     event AccessoryDiscontinued(uint256 accessoryId);
166 
167     event EligibleListSet(uint256 accessoryId);
168     event EligibleListCleared(uint256 accessoryId);
169 
170     /* Structs */
171 
172     struct Accessory {            // Accessory Definition
173         address payable manager;  // initially creator; payee for sales
174         uint8 width;              // image width
175         uint8 height;             // image height
176         uint8 meta;               // metadata flags [Reserved 3b, Audience 2b, MirrorPlacement 1b, MirrorAccessory 1b, Background 1b]
177         uint72 price;             // price at which accessory can be purchased (MAX ~4,722 ETH)
178                                   // if set to max value, the accessory is not for sale
179 
180         uint16 totalSupply;      // total number of a given accessory that will ever exist; can only be changed by discontinuing the accessory
181         uint16 availableSupply;  // number of given accessory still available for sale; decremented on each sale
182         bytes28 name;            // unicode name of accessory, can only be set on creation
183 
184         bytes8[7] palettes;     // color palettes, each palette is an array of uint8 offsets into the global palette
185         bytes2[4] positions;    // offsets for all 4 MoonCat poses, an offset pair of 0xffff indicates the pose is not supported
186                                 // position order is [standing, sleeping, pouncing, stalking]
187 
188         bytes IDAT;            // PNG IDAT chunk data for image reconstruction
189     }
190 
191     struct OwnedAccessory {   // Accessory owned by an AcclimatedMoonCat
192         uint232 accessoryId;  // index into AllAccessories Array
193         uint8 paletteIndex;   // index into Accessory.palettes Array
194         uint16 zIndex;        // drawing order indicator (lower numbers are closer to MoonCat)
195                               // zIndex == 0 indicates the MoonCat is not wearing the accessory
196                               // if the accessory meta `Background` bit is 1 the zIndex is interpreted as negative
197     }
198 
199     struct AccessoryBatchData {   // Used for batch accessory alterations and purchases
200         uint256 rescueOrder;
201         uint232 ownedIndexOrAccessoryId;
202         uint8 paletteIndex;
203         uint16 zIndex;
204     }
205 
206     using EnumerableSet for EnumerableSet.Set;
207 
208     /* State */
209 
210     bool public frozen = true;
211 
212     Accessory[] internal AllAccessories; //  Array of all Accessories that have been created
213     mapping (uint256 => bytes32[100]) internal AllEligibleLists; // Accessory ID => BitSet
214                                                                  // Each bit represents the eligbility of an AcclimatedMoonCat
215                                                                  // An eligibleList is active when the final bit == 1
216 
217     mapping (address => EnumerableSet.Set) internal AccessoriesByManager; // Manager address => accessoryId Set
218 
219     mapping (uint256 => mapping(uint256 => bool)) internal OwnedAccessoriesByMoonCat; // AcclimatedMoonCat rescueOrder => Accessory ID => isOwned?
220     mapping (uint256 => OwnedAccessory[]) public AccessoriesByMoonCat; // AcclimatedMoonCat rescueOrder => Array of AppliedAccessory structs
221 
222     mapping (bytes32 => bool) public accessoryHashes; // used to check if the image data for an accessory has already been submitted
223 
224     address payable public owner;
225 
226     uint72 constant NOT_FOR_SALE = 0xffffffffffffffffff;
227 
228     uint256 public feeDenominator = 5;
229     uint256 public referralDenominator = 0;
230 
231     /* Modifiers */
232 
233     modifier onlyOwner () {
234         require(msg.sender == owner, "Only Owner");
235         _;
236     }
237 
238     modifier accessoryExists (uint256 accessoryId){
239         require(accessoryId < AllAccessories.length, "Accessory Not Found");
240         _;
241     }
242 
243     modifier onlyAccessoryManager (uint256 accessoryId) {
244         require(msg.sender == AllAccessories[accessoryId].manager, "Not Accessory Manager");
245         _;
246     }
247 
248     modifier onlyAMCOwner (uint256 rescueOrder) {
249         require(MCR.catOwners(MCR.rescueOrder(rescueOrder)) == 0xc3f733ca98E0daD0386979Eb96fb1722A1A05E69,
250                 "Not Acclimated");
251         address moonCatOwner = MCA.ownerOf(rescueOrder);
252         require((msg.sender == moonCatOwner)
253             || (msg.sender == MCA.getApproved(rescueOrder))
254             || (MCA.isApprovedForAll(moonCatOwner, msg.sender)),
255             "Not AMC Owner or Approved"
256         );
257         _;
258     }
259 
260     modifier notZeroAddress (address a){
261         require(a != address(0), "Zero Address");
262         _;
263     }
264 
265     modifier notFrozen () {
266         require(!frozen, "Frozen");
267         _;
268     }
269 
270     modifier validPrice(uint256 price) {
271         require(price <= NOT_FOR_SALE, "Invalid Price");
272         _;
273     }
274 
275     /* Admin */
276 
277     constructor(){
278         owner = payable(msg.sender);
279 
280         // https://docs.ens.domains/contract-api-reference/reverseregistrar#claim-address
281         IReverseResolver(0x084b1c3C81545d370f3634392De611CaaBFf8148)
282             .claim(msg.sender);
283     }
284 
285     /**
286      * @dev Transfer funds from the contract's wallet to an external wallet, minus a fee
287      */
288     function sendPayment (address payable target, uint256 amount, address payable referrer)
289         internal
290     {
291         uint256 fee = (feeDenominator > 0) ? (amount / feeDenominator) : 0;
292         uint256 referral = (referralDenominator > 0) ? (fee / referralDenominator) : 0;
293         fee = fee - referral;
294         uint256 payment = amount - fee - referral;
295         owner.transfer(fee);
296         referrer.transfer(referral);
297         target.transfer(payment);
298     }
299 
300     /**
301      * @dev Update the amount of fee taken from each sale
302      */
303     function setFee (uint256 denominator)
304         public
305         onlyOwner
306     {
307         feeDenominator = denominator;
308     }
309 
310     /**
311      * @dev Update the amount of referral fee taken from each sale
312      */
313     function setReferralFee (uint256 denominator)
314         public
315         onlyOwner
316     {
317         referralDenominator = denominator;
318     }
319 
320     /**
321      * @dev Allow current `owner` to transfer ownership to another address
322      */
323     function transferOwnership (address payable newOwner)
324         public
325         onlyOwner
326     {
327         owner = newOwner;
328     }
329 
330     /**
331      * @dev Prevent creating and applying accessories
332      */
333     function freeze ()
334         public
335         onlyOwner
336         notFrozen
337     {
338         frozen = true;
339     }
340 
341     /**
342      * @dev Enable creating and applying accessories
343      */
344     function unfreeze ()
345         public
346         onlyOwner
347     {
348         frozen = false;
349     }
350 
351     /**
352      * @dev Update the metadata flags for an accessory
353      */
354     function setMetaByte (uint256 accessoryId, uint8 metabyte)
355         public
356         onlyOwner
357         accessoryExists(accessoryId)
358     {
359         Accessory storage accessory = AllAccessories[accessoryId];
360         accessory.meta = metabyte;
361     }
362 
363     /**
364      * @dev Batch-update metabytes for accessories, by ensuring given bits are on
365      */
366     function batchOrMetaByte (uint8 value, uint256[] calldata accessoryIds)
367         public
368         onlyOwner
369     {
370         uint256 id;
371         Accessory storage accessory;
372         for(uint256 i = 0; i < accessoryIds.length; i++){
373             id = accessoryIds[i];
374             if(i < AllAccessories.length){
375                 accessory = AllAccessories[id];
376                 accessory.meta = accessory.meta | value;
377             }
378         }
379     }
380 
381     /**
382      * @dev Batch-update metabytes for accessories, by ensuring given bits are off
383      */
384     function batchAndMetaByte (uint8 value, uint256[] calldata accessoryIds)
385         public
386         onlyOwner
387     {
388         uint256 id;
389         Accessory storage accessory;
390         for(uint256 i = 0; i < accessoryIds.length; i++){
391             id = accessoryIds[i];
392             if(i < AllAccessories.length){
393                 accessory = AllAccessories[id];
394                 accessory.meta = accessory.meta & value;
395             }
396         }
397     }
398 
399     /**
400      * @dev Rescue ERC20 assets sent directly to this contract.
401      */
402     function withdrawForeignERC20(address tokenContract)
403         public
404         onlyOwner
405     {
406         IERC20 token = IERC20(tokenContract);
407         token.transfer(owner, token.balanceOf(address(this)));
408     }
409 
410     /**
411      * @dev Rescue ERC721 assets sent directly to this contract.
412      */
413     function withdrawForeignERC721(address tokenContract, uint256 tokenId)
414         public
415         onlyOwner
416     {
417         IERC721(tokenContract).safeTransferFrom(address(this), owner, tokenId);
418     }
419 
420     /**
421      * @dev Check if a MoonCat is eligible to purchase an accessory
422      */
423     function isEligible(uint256 rescueOrder, uint256 accessoryId)
424         public
425         view
426         returns (bool)
427     {
428         if(MoonCatBitSet.isActive(AllEligibleLists[accessoryId])) {
429             return MoonCatBitSet.checkBit(AllEligibleLists[accessoryId], rescueOrder);
430         }
431         return true;
432     }
433 
434     /* Helpers */
435 
436     /**
437      * @dev Mark an accessory as owned by a specific MoonCat, and put it on
438      *
439      * This is an internal function that only does sanity-checking (prevent double-buying an accessory, and prevent picking an invalid palette).
440      * All methods that use this function check permissions before calling this function.
441      */
442     function applyAccessory (uint256 rescueOrder, uint256 accessoryId, uint8 paletteIndex, uint16 zIndex)
443         private
444         accessoryExists(accessoryId)
445         notFrozen
446         returns (uint256)
447     {
448         require(OwnedAccessoriesByMoonCat[rescueOrder][accessoryId] == false, "Already Owned");
449         require(uint64(AllAccessories[accessoryId].palettes[paletteIndex]) != 0, "Invalid Palette");
450         OwnedAccessory[] storage ownedAccessories = AccessoriesByMoonCat[rescueOrder];
451         uint256 ownedAccessoryIndex = ownedAccessories.length;
452         ownedAccessories.push(OwnedAccessory(uint232(accessoryId), paletteIndex, zIndex));
453         OwnedAccessoriesByMoonCat[rescueOrder][accessoryId] = true;
454         emit AccessoryApplied(accessoryId, rescueOrder, paletteIndex, zIndex);
455         return ownedAccessoryIndex;
456     }
457 
458     /**
459      * @dev Ensure an accessory's image data has not been submitted before
460      */
461     function verifyAccessoryUniqueness(bytes calldata IDAT)
462         internal
463     {
464         bytes32 accessoryHash = keccak256(IDAT);
465         require(!accessoryHashes[accessoryHash], "Duplicate");
466         accessoryHashes[accessoryHash] = true;
467     }
468 
469     /* Creator */
470 
471     /**
472      * @dev Create an accessory, as the contract owner
473      *
474      * This method allows the contract owner to deploy accessories on behalf of others. It also allows deploying
475      * accessories that break some of the rules:
476      *
477      * This method can be called when frozen, so the owner can add to the store even when others cannot.
478      * This method does not check for duplicates, so if an accessory creator wants to make a literal duplicate, that can be facilitated.
479      */
480     function ownerCreateAccessory(address payable manager, uint8[3] calldata WHM, uint256 priceWei, uint16 totalSupply, bytes28 name, bytes2[4] calldata positions, bytes8[7] calldata initialPalettes, bytes calldata IDAT)
481         public
482         onlyOwner
483         returns (uint256)
484     {
485         uint256 accessoryId = AllAccessories.length;
486         AllAccessories.push(Accessory(manager, WHM[0], WHM[1], WHM[2], uint72(priceWei), totalSupply, totalSupply, name, initialPalettes, positions, IDAT));
487 
488         bytes32 accessoryHash = keccak256(IDAT);
489         accessoryHashes[accessoryHash] = true;
490 
491         emit AccessoryCreated(accessoryId, manager, priceWei, totalSupply, name);
492         AccessoriesByManager[manager].add(accessoryId);
493         return accessoryId;
494     }
495 
496     /**
497      * @dev Create an accessory with an eligible list, as the contract owner
498      */
499     function ownerCreateAccessory(address payable manager, uint8[3] calldata WHM, uint256 priceWei, uint16 totalSupply, bytes28 name, bytes2[4] calldata positions, bytes8[7] calldata initialPalettes, bytes calldata IDAT, bytes32[100] calldata eligibleList)
500         public
501         onlyOwner
502         returns (uint256)
503     {
504         uint256 accessoryId = ownerCreateAccessory(manager, WHM, priceWei, totalSupply, name, positions, initialPalettes, IDAT);
505         AllEligibleLists[accessoryId] = eligibleList;
506         MoonCatBitSet.activate(AllEligibleLists[accessoryId]);
507         return accessoryId;
508     }
509 
510     /**
511      * @dev Create an accessory
512      */
513     function createAccessory (uint8[3] calldata WHM, uint256 priceWei, uint16 totalSupply, bytes28 name, bytes2[4] calldata positions, bytes8[] calldata palettes, bytes calldata IDAT)
514         public
515         notFrozen
516         validPrice(priceWei)
517         returns (uint256)
518     {
519         require(palettes.length <= 7 && palettes.length > 0, "Invalid Palette Count");
520         require(totalSupply > 0 && totalSupply <= 25440, "Invalid Supply");
521         require(WHM[0] > 0 && WHM[1] > 0, "Invalid Dimensions");
522         verifyAccessoryUniqueness(IDAT);
523         uint256 accessoryId = AllAccessories.length;
524         bytes8[7] memory initialPalettes;
525         for(uint i = 0; i < palettes.length; i++){
526             require(uint64(palettes[i]) != 0, "Invalid Palette");
527             initialPalettes[i] = palettes[i];
528         }
529         AllAccessories.push(Accessory(payable(msg.sender), WHM[0], WHM[1], WHM[2] & 0x1f, uint72(priceWei), totalSupply, totalSupply, name, initialPalettes, positions, IDAT));
530         //                                                                        ^ Clear reserved bits
531         emit AccessoryCreated(accessoryId, msg.sender, priceWei, totalSupply, name);
532         AccessoriesByManager[msg.sender].add(accessoryId);
533         return accessoryId;
534     }
535 
536     /**
537      * @dev Create an accessory with an eligible list
538      */
539     function createAccessory (uint8[3] calldata WHM, uint256 priceWei, uint16 totalSupply, bytes28 name, bytes2[4] calldata positions, bytes8[] calldata palettes, bytes calldata IDAT, bytes32[100] calldata eligibleList)
540         public
541         returns (uint256)
542     {
543         uint256 accessoryId = createAccessory(WHM, priceWei, totalSupply, name, positions, palettes, IDAT);
544         AllEligibleLists[accessoryId] = eligibleList;
545         MoonCatBitSet.activate(AllEligibleLists[accessoryId]);
546         return accessoryId;
547     }
548 
549     /**
550      * @dev Add a color palette variant to an existing accessory
551      */
552     function addAccessoryPalette (uint256 accessoryId, bytes8 newPalette)
553         public
554         onlyAccessoryManager(accessoryId)
555     {
556         require(uint64(newPalette) != 0, "Invalid Palette");
557         Accessory storage accessory = AllAccessories[accessoryId];
558         bytes8[7] storage accessoryPalettes = accessory.palettes;
559 
560         require(uint64(accessoryPalettes[6]) == 0, "Palette Limit Exceeded");
561         uint paletteIndex = 1;
562         while(uint64(accessoryPalettes[paletteIndex]) > 0){
563             paletteIndex++;
564         }
565         accessoryPalettes[paletteIndex] = newPalette;
566     }
567 
568     /**
569      * @dev Give ownership of an accessory to someone else
570      */
571     function transferAccessoryManagement (uint256 accessoryId, address payable newManager)
572         public
573         onlyAccessoryManager(accessoryId)
574         notZeroAddress(newManager)
575     {
576         Accessory storage accessory = AllAccessories[accessoryId];
577         AccessoriesByManager[accessory.manager].remove(accessoryId);
578         AccessoriesByManager[newManager].add(accessoryId);
579         accessory.manager = newManager;
580         emit AccessoryManagementTransferred(accessoryId, newManager);
581     }
582 
583     /**
584      * @dev Set accessory to have a new price
585      */
586     function setAccessoryPrice (uint256 accessoryId, uint256 newPriceWei)
587         public
588         onlyAccessoryManager(accessoryId)
589         validPrice(newPriceWei)
590     {
591         Accessory storage accessory = AllAccessories[accessoryId];
592 
593         if(accessory.price != newPriceWei){
594             accessory.price = uint72(newPriceWei);
595             emit AccessoryPriceChanged(accessoryId, newPriceWei);
596         }
597     }
598 
599     /**
600      * @dev Set accessory eligible list
601      */
602     function setEligibleList (uint256 accessoryId, bytes32[100] calldata eligibleList)
603         public
604         onlyAccessoryManager(accessoryId)
605     {
606         AllEligibleLists[accessoryId] = eligibleList;
607         MoonCatBitSet.activate(AllEligibleLists[accessoryId]);
608         emit EligibleListSet(accessoryId);
609     }
610 
611     /**
612      * @dev Clear accessory eligible list
613      */
614     function clearEligibleList (uint256 accessoryId)
615         public
616         onlyAccessoryManager(accessoryId)
617     {
618         delete AllEligibleLists[accessoryId];
619         emit EligibleListCleared(accessoryId);
620     }
621 
622     /**
623      * @dev Turns eligible list on or off without setting/clearing
624      */
625     function toggleEligibleList (uint256 accessoryId, bool active)
626         public
627         onlyAccessoryManager(accessoryId)
628     {
629         bool isActive = MoonCatBitSet.isActive(AllEligibleLists[accessoryId]);
630         if(isActive && !active) {
631             MoonCatBitSet.deactivate(AllEligibleLists[accessoryId]);
632             emit EligibleListCleared(accessoryId);
633         } else if (!isActive && active){
634             MoonCatBitSet.activate(AllEligibleLists[accessoryId]);
635             emit EligibleListSet(accessoryId);
636         }
637     }
638 
639     /**
640      * @dev Add/Remove individual rescueOrders from an eligibleSet
641      */
642     function editEligibleMoonCats(uint256 accessoryId, bool targetState, uint16[] calldata rescueOrders)
643         public
644         onlyAccessoryManager(accessoryId)
645     {
646         bytes32[100] storage eligibleList = AllEligibleLists[accessoryId];
647         for(uint i = 0; i < rescueOrders.length; i++){
648             require(rescueOrders[i] < 25440, "Out of bounds");
649             if(targetState) {
650                 MoonCatBitSet.setBit(eligibleList, rescueOrders[i]);
651             } else {
652                 MoonCatBitSet.clearBit(eligibleList, rescueOrders[i]);
653             }
654         }
655         if(MoonCatBitSet.isActive(eligibleList)){
656             emit EligibleListSet(accessoryId);
657         }
658     }
659 
660     /**
661      * @dev Buy an accessory as the manager of that accessory
662      *
663      * Accessory managers always get charged zero cost for buying/applying their own accessories,
664      * and always bypass the EligibleList (if there is any).
665      *
666      * A purchase by the accessory manager still reduces the available supply of an accessory, and
667      * the Manager must be the owner of or be granted access to the MoonCat to which the accessory
668      * is being applied.
669      */
670     function managerApplyAccessory (uint256 rescueOrder, uint256 accessoryId, uint8 paletteIndex, uint16 zIndex)
671         public
672         onlyAccessoryManager(accessoryId)
673         onlyAMCOwner(rescueOrder)
674         returns (uint256)
675     {
676         require(AllAccessories[accessoryId].availableSupply > 0, "Supply Exhausted");
677         AllAccessories[accessoryId].availableSupply--;
678         return applyAccessory(rescueOrder, accessoryId, paletteIndex, zIndex);
679     }
680 
681     /**
682      * @dev Remove accessory from the market forever by transferring
683      * management to the zero address, setting it as not for sale, and
684      * setting the total supply to the current existing quantity.
685      */
686     function discontinueAccessory (uint256 accessoryId)
687         public
688         onlyAccessoryManager(accessoryId)
689     {
690         Accessory storage accessory = AllAccessories[accessoryId];
691         accessory.price = NOT_FOR_SALE;
692         AccessoriesByManager[accessory.manager].remove(accessoryId);
693         AccessoriesByManager[address(0)].add(accessoryId);
694         accessory.manager = payable(address(0));
695         accessory.totalSupply = accessory.totalSupply - accessory.availableSupply;
696         accessory.availableSupply = 0;
697         emit AccessoryDiscontinued(accessoryId);
698     }
699 
700     /* User */
701 
702     /**
703      * @dev Purchase and apply an accessory in a standard manner.
704      *
705      * This method is an internal method for doing standard permission checks before calling the applyAccessory function.
706      * This method checks that an accessory is set to be allowed for sale (not set to the max price), that there's enough supply left,
707      * and that the buyer has supplied enough ETH to satisfy the price of the accessory.
708      *
709      * In addition, it checks to ensure that the MoonCat receiving the accessory is owned by the address making this purchase,
710      * and that the MoonCat purchasing the accessory is on the Eligible List for that accessory.
711      */
712     function buyAndApplyAccessory (uint256 rescueOrder, uint256 accessoryId, uint8 paletteIndex, uint16 zIndex, address payable referrer)
713         private
714         onlyAMCOwner(rescueOrder)
715         notZeroAddress(referrer)
716         accessoryExists(accessoryId)
717         returns (uint256)
718     {
719         require(isEligible(rescueOrder, accessoryId), "Ineligible");
720         Accessory storage accessory = AllAccessories[accessoryId];
721         require(accessory.price != NOT_FOR_SALE, "Not For Sale");
722         require(accessory.availableSupply > 0, "Supply Exhausted");
723         accessory.availableSupply--;
724         require(address(this).balance >= accessory.price, "Insufficient Value");
725         emit AccessoryPurchased(accessoryId, rescueOrder, accessory.price);
726         uint256 ownedAccessoryId = applyAccessory(rescueOrder, accessoryId, paletteIndex, zIndex);
727         if(accessory.price > 0) {
728             sendPayment(accessory.manager, accessory.price, referrer);
729         }
730         return ownedAccessoryId;
731     }
732 
733     /**
734      * @dev Buy an accessory that is up for sale by its owner
735      *
736      * This method is the typical purchase method used by storefronts;
737      * it allows the storefront to claim a referral fee for the purchase.
738      *
739      * Passing a z-index value of zero to this method just purchases the accessory,
740      * but does not make it an active part of the MoonCat's appearance.
741      */
742     function buyAccessory (uint256 rescueOrder, uint256 accessoryId, uint8 paletteIndex, uint16 zIndex, address payable referrer)
743         public
744         payable
745         returns (uint256)
746     {
747         uint256 ownedAccessoryId = buyAndApplyAccessory(rescueOrder, accessoryId, paletteIndex, zIndex, referrer);
748         if(address(this).balance > 0){
749             // The buyer over-paid; transfer their funds back to them
750             payable(msg.sender).transfer(address(this).balance);
751         }
752         return ownedAccessoryId;
753     }
754 
755     /**
756      * @dev Buy an accessory that is up for sale by its owner
757      *
758      * This method is a generic fallback method if no referrer address is given for a purchase.
759      * Defaults to the owner of the contract to receive the referral fee in this case.
760      */
761     function buyAccessory (uint256 rescueOrder, uint256 accessoryId, uint8 paletteIndex, uint16 zIndex)
762         public
763         payable
764         returns (uint256)
765     {
766         return buyAccessory(rescueOrder, accessoryId, paletteIndex, zIndex, owner);
767     }
768 
769     /**
770      * @dev Buy multiple accessories at once; setting a palette and z-index for each one
771      */
772     function buyAccessories (AccessoryBatchData[] calldata orders, address payable referrer)
773         public
774         payable
775     {
776         for (uint256 i = 0; i < orders.length; i++) {
777             AccessoryBatchData memory order = orders[i];
778             buyAndApplyAccessory(order.rescueOrder, order.ownedIndexOrAccessoryId, order.paletteIndex, order.zIndex, referrer);
779         }
780         if(address(this).balance > 0){
781             // The buyer over-paid; transfer their funds back to them
782             payable(msg.sender).transfer(address(this).balance);
783         }
784     }
785 
786     /**
787      * @dev Buy multiple accessories at once; setting a palette and z-index for each one (setting the contract owner as the referrer)
788      */
789     function buyAccessories (AccessoryBatchData[] calldata orders)
790         public
791         payable
792     {
793         buyAccessories(orders, owner);
794     }
795 
796     /**
797      * @dev Change the status of an owned accessory (worn or not, z-index ordering, color palette variant)
798      */
799     function alterAccessory (uint256 rescueOrder, uint256 ownedAccessoryIndex, uint8 paletteIndex, uint16 zIndex)
800         public
801         onlyAMCOwner(rescueOrder)
802     {
803         OwnedAccessory[] storage ownedAccessories = AccessoriesByMoonCat[rescueOrder];
804         require(ownedAccessoryIndex < ownedAccessories.length, "Owned Accessory Not Found");
805         OwnedAccessory storage ownedAccessory = ownedAccessories[ownedAccessoryIndex];
806         require((paletteIndex <= 7) && (uint64(AllAccessories[ownedAccessory.accessoryId].palettes[paletteIndex]) != 0), "Palette Not Found");
807         ownedAccessory.paletteIndex = paletteIndex;
808         ownedAccessory.zIndex = zIndex;
809         emit AccessoryApplied(ownedAccessory.accessoryId, rescueOrder, paletteIndex, zIndex);
810     }
811 
812     /**
813     * @dev Change the status of multiple accessories at once
814     */
815     function alterAccessories (AccessoryBatchData[] calldata alterations)
816         public
817     {
818         for(uint i = 0; i < alterations.length; i++ ){
819             AccessoryBatchData memory alteration = alterations[i];
820             alterAccessory(alteration.rescueOrder, alteration.ownedIndexOrAccessoryId, alteration.paletteIndex, alteration.zIndex);
821         }
822     }
823 
824     /* View - Accessories */
825 
826     /**
827      * @dev How many accessories exist in this contract?
828      */
829     function totalAccessories ()
830         public
831         view
832         returns (uint256)
833     {
834         return AllAccessories.length;
835     }
836 
837     /**
838      * @dev Checks if there is an accessory with same IDAT data
839      */
840     function isAccessoryUnique(bytes calldata IDAT)
841         public
842         view
843         returns (bool)
844     {
845         bytes32 accessoryHash = keccak256(IDAT);
846         return (!accessoryHashes[accessoryHash]);
847     }
848 
849     /**
850      * @dev How many palettes are defined for an accessory?
851      */
852     function accessoryPaletteCount (uint256 accessoryId)
853         public
854         view
855         accessoryExists(accessoryId)
856         returns (uint8)
857     {
858         bytes8[7] memory accessoryPalettes = AllAccessories[accessoryId].palettes;
859         for(uint8 i = 0; i < accessoryPalettes.length; i++) {
860             if (uint64(accessoryPalettes[i]) == 0) {
861                 return i;
862             }
863         }
864         return uint8(accessoryPalettes.length);
865     }
866 
867     /**
868      * @dev Fetch a specific palette for a given accessory
869      */
870     function accessoryPalette (uint256 accessoryId, uint256 paletteIndex)
871         public
872         view
873         returns (bytes8)
874     {
875         return AllAccessories[accessoryId].palettes[paletteIndex];
876     }
877 
878     /**
879      * @dev Fetch data about a given accessory
880      */
881     function accessoryInfo (uint256 accessoryId)
882         public
883         view
884         accessoryExists(accessoryId)
885         returns (uint16 totalSupply, uint16 availableSupply, bytes28 name, address manager, uint8 metabyte, uint8 availablePalettes, bytes2[4] memory positions, bool availableForPurchase, uint256 price)
886     {
887         Accessory memory accessory = AllAccessories[accessoryId];
888         availablePalettes = accessoryPaletteCount(accessoryId);
889         bool available = accessory.price != NOT_FOR_SALE && accessory.availableSupply > 0;
890         return (accessory.totalSupply, accessory.availableSupply, accessory.name, accessory.manager, accessory.meta, availablePalettes, accessory.positions, available, accessory.price);
891     }
892 
893     /**
894      * @dev Fetch image data about a given accessory
895      */
896     function accessoryImageData (uint256 accessoryId)
897         public
898         view
899         accessoryExists(accessoryId)
900         returns (bytes2[4] memory positions, bytes8[7] memory palettes, uint8 width, uint8 height, uint8 meta, bytes memory IDAT)
901     {
902         Accessory memory accessory = AllAccessories[accessoryId];
903         return (accessory.positions, accessory.palettes, accessory.width, accessory.height, accessory.meta, accessory.IDAT);
904     }
905 
906     /**
907      * @dev Fetch EligibleList for a given accessory
908      */
909     function accessoryEligibleList(uint256 accessoryId)
910         public
911         view
912         accessoryExists(accessoryId)
913         returns (bytes32[100] memory)
914     {
915         return AllEligibleLists[accessoryId];
916     }
917 
918     /*  View - Manager */
919 
920     /**
921      * @dev Which address manages a specific accessory?
922      */
923     function managerOf (uint256 accessoryId)
924         public
925         view
926         accessoryExists(accessoryId)
927         returns (address)
928     {
929         return AllAccessories[accessoryId].manager;
930     }
931 
932     /**
933      * @dev How many accessories does a given address manage?
934      */
935     function balanceOf (address manager)
936         public
937         view
938         returns (uint256)
939     {
940         return AccessoriesByManager[manager].length();
941     }
942 
943     /**
944      * @dev Iterate through a given address's managed accessories
945      */
946     function managedAccessoryByIndex (address manager, uint256 managedAccessoryIndex)
947         public
948         view
949         returns (uint256)
950     {
951         return AccessoriesByManager[manager].at(managedAccessoryIndex);
952     }
953 
954     /*  View - AcclimatedMoonCat */
955 
956     /**
957      * @dev How many accessories does a given MoonCat own?
958      */
959     function balanceOf (uint256 rescueOrder)
960         public
961         view
962         returns (uint256)
963     {
964         return AccessoriesByMoonCat[rescueOrder].length;
965     }
966 
967     /**
968      * @dev Iterate through a given MoonCat's accessories
969      */
970     function ownedAccessoryByIndex (uint256 rescueOrder, uint256 ownedAccessoryIndex)
971         public
972         view
973         returns (OwnedAccessory memory)
974     {
975         require(ownedAccessoryIndex < AccessoriesByMoonCat[rescueOrder].length, "Index out of bounds");
976         return AccessoriesByMoonCat[rescueOrder][ownedAccessoryIndex];
977     }
978 
979     /**
980      * @dev Lookup function to see if this MoonCat has already purchased a given accessory
981      */
982     function doesMoonCatOwnAccessory (uint256 rescueOrder, uint256 accessoryId)
983         public
984         view
985         returns (bool)
986     {
987         return OwnedAccessoriesByMoonCat[rescueOrder][accessoryId];
988     }
989 
990 }