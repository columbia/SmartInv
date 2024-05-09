1 pragma solidity ^0.4.18;
2 
3 // File: contracts-origin/AetherAccessControl.sol
4 
5 /// @title A facet of AetherCore that manages special access privileges.
6 /// @dev See the AetherCore contract documentation to understand how the various contract facets are arranged.
7 contract AetherAccessControl {
8     // This facet controls access control for Laputa. There are four roles managed here:
9     //
10     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
11     //         contracts. It is also the only role that can unpause the smart contract. It is initially
12     //         set to the address that created the smart contract in the AetherCore constructor.
13     //
14     //     - The CFO: The CFO can withdraw funds from AetherCore and its auction contracts.
15     //
16     //     - The COO: The COO can release properties to auction.
17     //
18     // It should be noted that these roles are distinct without overlap in their access abilities, the
19     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
20     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
21     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
22     // convenience. The less we use an address, the less likely it is that we somehow compromise the
23     // account.
24 
25     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
26     event ContractUpgrade(address newContract);
27 
28     // The addresses of the accounts (or contracts) that can execute actions within each roles.
29     address public ceoAddress;
30     address public cfoAddress;
31     address public cooAddress;
32 
33     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
34     bool public paused = false;
35 
36     /// @dev Access modifier for CEO-only functionality
37     modifier onlyCEO() {
38         require(msg.sender == ceoAddress);
39         _;
40     }
41 
42     /// @dev Access modifier for CFO-only functionality
43     modifier onlyCFO() {
44         require(msg.sender == cfoAddress);
45         _;
46     }
47 
48     /// @dev Access modifier for COO-only functionality
49     modifier onlyCOO() {
50         require(msg.sender == cooAddress);
51         _;
52     }
53 
54     modifier onlyCLevel() {
55         require(
56             msg.sender == cooAddress ||
57             msg.sender == ceoAddress ||
58             msg.sender == cfoAddress
59         );
60         _;
61     }
62 
63     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
64     /// @param _newCEO The address of the new CEO
65     function setCEO(address _newCEO) public onlyCEO {
66         require(_newCEO != address(0));
67 
68         ceoAddress = _newCEO;
69     }
70 
71     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
72     /// @param _newCFO The address of the new CFO
73     function setCFO(address _newCFO) public onlyCEO {
74         require(_newCFO != address(0));
75 
76         cfoAddress = _newCFO;
77     }
78 
79     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
80     /// @param _newCOO The address of the new COO
81     function setCOO(address _newCOO) public onlyCEO {
82         require(_newCOO != address(0));
83 
84         cooAddress = _newCOO;
85     }
86 
87     function withdrawBalance() external onlyCFO {
88         cfoAddress.transfer(this.balance);
89     }
90 
91 
92     /*** Pausable functionality adapted from OpenZeppelin ***/
93 
94     /// @dev Modifier to allow actions only when the contract IS NOT paused
95     modifier whenNotPaused() {
96         require(!paused);
97         _;
98     }
99 
100     /// @dev Modifier to allow actions only when the contract IS paused
101     modifier whenPaused {
102         require(paused);
103         _;
104     }
105 
106     /// @dev Called by any "C-level" role to pause the contract. Used only when
107     ///  a bug or exploit is detected and we need to limit damage.
108     function pause() public onlyCLevel whenNotPaused {
109         paused = true;
110     }
111 
112     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
113     ///  one reason we may pause the contract is when CFO or COO accounts are
114     ///  compromised.
115     function unpause() public onlyCEO whenPaused {
116         // can't unpause if contract was upgraded
117         paused = false;
118     }
119 }
120 
121 // File: contracts-origin/AetherBase.sol
122 
123 /// @title Base contract for Aether. Holds all common structs, events and base variables.
124 /// @author Project Aether (https://www.aether.city)
125 /// @dev See the PropertyCore contract documentation to understand how the various contract facets are arranged.
126 contract AetherBase is AetherAccessControl {
127     /*** EVENTS ***/
128 
129     /// @dev The Construct event is fired whenever a property updates.
130     event Construct (
131       address indexed owner,
132       uint256 propertyId,
133       PropertyClass class,
134       uint8 x,
135       uint8 y,
136       uint8 z,
137       uint8 dx,
138       uint8 dz,
139       string data
140     );
141 
142     /// @dev Transfer event as defined in current draft of ERC721. Emitted every
143     ///  time a property ownership is assigned.
144     event Transfer(
145       address indexed from,
146       address indexed to,
147       uint256 indexed tokenId
148     );
149 
150     /*** DATA ***/
151 
152     enum PropertyClass { DISTRICT, BUILDING, UNIT }
153 
154     /// @dev The main Property struct. Every property in Aether is represented
155     ///  by a variant of this structure.
156     struct Property {
157         uint32 parent;
158         PropertyClass class;
159         uint8 x;
160         uint8 y;
161         uint8 z;
162         uint8 dx;
163         uint8 dz;
164     }
165 
166     /*** STORAGE ***/
167 
168     /// @dev Ensures that property occupies unique part of the universe.
169     bool[100][100][100] public world;
170 
171     /// @dev An array containing the Property struct for all properties in existence. The ID
172     ///  of each property is actually an index into this array.
173     Property[] properties;
174 
175     /// @dev An array containing the district addresses in existence.
176     uint256[] districts;
177 
178     /// @dev A measure of world progression.
179     uint256 public progress;
180 
181     /// @dev The fee associated with constructing a unit property.
182     uint256 public unitCreationFee = 0.05 ether;
183 
184     /// @dev Keeps track whether updating data is paused.
185     bool public updateEnabled = true;
186 
187     /// @dev A mapping from property IDs to the address that owns them. All properties have
188     ///  some valid owner address, even gen0 properties are created with a non-zero owner.
189     mapping (uint256 => address) public propertyIndexToOwner;
190 
191     /// @dev A mapping from property IDs to the data that is stored on them.
192     mapping (uint256 => string) public propertyIndexToData;
193 
194     /// @dev A mapping from owner address to count of tokens that address owns.
195     ///  Used internally inside balanceOf() to resolve ownership count.
196     mapping (address => uint256) ownershipTokenCount;
197 
198     /// @dev Mappings between property nodes.
199     mapping (uint256 => uint256) public districtToBuildingsCount;
200     mapping (uint256 => uint256[]) public districtToBuildings;
201     mapping (uint256 => uint256) public buildingToUnitCount;
202     mapping (uint256 => uint256[]) public buildingToUnits;
203 
204     /// @dev A mapping from building propertyId to unit construction privacy.
205     mapping (uint256 => bool) public buildingIsPublic;
206 
207     /// @dev A mapping from PropertyIDs to an address that has been approved to call
208     ///  transferFrom(). Each Property can only have one approved address for transfer
209     ///  at any time. A zero value means no approval is outstanding.
210     mapping (uint256 => address) public propertyIndexToApproved;
211 
212     /// @dev Assigns ownership of a specific Property to an address.
213     function _transfer(address _from, address _to, uint256 _tokenId) internal {
214       // since the number of properties is capped to 2^32
215       // there is no way to overflow this
216       ownershipTokenCount[_to]++;
217       // transfer ownership
218       propertyIndexToOwner[_tokenId] = _to;
219       // When creating new properties _from is 0x0, but we can't account that address.
220       if (_from != address(0)) {
221           ownershipTokenCount[_from]--;
222           // clear any previously approved ownership exchange
223           delete propertyIndexToApproved[_tokenId];
224       }
225       // Emit the transfer event.
226       Transfer(_from, _to, _tokenId);
227     }
228 
229     function _createUnit(
230       uint256 _parent,
231       uint256 _x,
232       uint256 _y,
233       uint256 _z,
234       address _owner
235     )
236         internal
237         returns (uint)
238     {
239       require(_x == uint256(uint8(_x)));
240       require(_y == uint256(uint8(_y)));
241       require(_z == uint256(uint8(_z)));
242       require(!world[_x][_y][_z]);
243       world[_x][_y][_z] = true;
244       return _createProperty(
245         _parent,
246         PropertyClass.UNIT,
247         _x,
248         _y,
249         _z,
250         0,
251         0,
252         _owner
253       );
254     }
255 
256     function _createBuilding(
257       uint256 _parent,
258       uint256 _x,
259       uint256 _y,
260       uint256 _z,
261       uint256 _dx,
262       uint256 _dz,
263       address _owner,
264       bool _public
265     )
266         internal
267         returns (uint)
268     {
269       require(_x == uint256(uint8(_x)));
270       require(_y == uint256(uint8(_y)));
271       require(_z == uint256(uint8(_z)));
272       require(_dx == uint256(uint8(_dx)));
273       require(_dz == uint256(uint8(_dz)));
274 
275       // Looping over world space.
276       for(uint256 i = 0; i < _dx; i++) {
277           for(uint256 j = 0; j <_dz; j++) {
278               if (world[_x + i][0][_z + j]) {
279                   revert();
280               }
281               world[_x + i][0][_z + j] = true;
282           }
283       }
284 
285       uint propertyId = _createProperty(
286         _parent,
287         PropertyClass.BUILDING,
288         _x,
289         _y,
290         _z,
291         _dx,
292         _dz,
293         _owner
294       );
295 
296       districtToBuildingsCount[_parent]++;
297       districtToBuildings[_parent].push(propertyId);
298       buildingIsPublic[propertyId] = _public;
299       return propertyId;
300     }
301 
302     function _createDistrict(
303       uint256 _x,
304       uint256 _z,
305       uint256 _dx,
306       uint256 _dz
307     )
308         internal
309         returns (uint)
310     {
311       require(_x == uint256(uint8(_x)));
312       require(_z == uint256(uint8(_z)));
313       require(_dx == uint256(uint8(_dx)));
314       require(_dz == uint256(uint8(_dz)));
315 
316       uint propertyId = _createProperty(
317         districts.length,
318         PropertyClass.DISTRICT,
319         _x,
320         0,
321         _z,
322         _dx,
323         _dz,
324         cooAddress
325       );
326 
327       districts.push(propertyId);
328       return propertyId;
329 
330     }
331 
332 
333     /// @dev An internal method that creates a new property and stores it. This
334     ///  method doesn't do any checking and should only be called when the
335     ///  input data is known to be valid. Will generate both a Construct event
336     ///  and a Transfer event.
337     function _createProperty(
338         uint256 _parent,
339         PropertyClass _class,
340         uint256 _x,
341         uint256 _y,
342         uint256 _z,
343         uint256 _dx,
344         uint256 _dz,
345         address _owner
346     )
347         internal
348         returns (uint)
349     {
350         require(_x == uint256(uint8(_x)));
351         require(_y == uint256(uint8(_y)));
352         require(_z == uint256(uint8(_z)));
353         require(_dx == uint256(uint8(_dx)));
354         require(_dz == uint256(uint8(_dz)));
355         require(_parent == uint256(uint32(_parent)));
356         require(uint256(_class) <= 3);
357 
358         Property memory _property = Property({
359             parent: uint32(_parent),
360             class: _class,
361             x: uint8(_x),
362             y: uint8(_y),
363             z: uint8(_z),
364             dx: uint8(_dx),
365             dz: uint8(_dz)
366         });
367         uint256 _tokenId = properties.push(_property) - 1;
368 
369         // It's never going to happen, 4 billion properties is A LOT, but
370         // let's just be 100% sure we never let this happen.
371         require(_tokenId <= 4294967295);
372 
373         Construct(
374             _owner,
375             _tokenId,
376             _property.class,
377             _property.x,
378             _property.y,
379             _property.z,
380             _property.dx,
381             _property.dz,
382             ""
383         );
384 
385         // This will assign ownership, and also emit the Transfer event as
386         // per ERC721 draft
387         _transfer(0, _owner, _tokenId);
388 
389         return _tokenId;
390     }
391 
392     /// @dev Computing height of a building with respect to city progression.
393     function _computeHeight(
394       uint256 _x,
395       uint256 _z,
396       uint256 _height
397     ) internal view returns (uint256) {
398         uint256 x = _x < 50 ? 50 - _x : _x - 50;
399         uint256 z = _z < 50 ? 50 - _z : _z - 50;
400         uint256 distance = x > z ? x : z;
401         if (distance > progress) {
402           return 1;
403         }
404         uint256 scale = 100 - (distance * 100) / progress ;
405         uint256 height = 2 * progress * _height * scale / 10000;
406         return height > 0 ? height : 1;
407     }
408 
409     /// @dev Convenience function to see if this building has room for a unit.
410     function canCreateUnit(uint256 _buildingId)
411         public
412         view
413         returns(bool)
414     {
415       Property storage _property = properties[_buildingId];
416       if (_property.class == PropertyClass.BUILDING &&
417             (buildingIsPublic[_buildingId] ||
418               propertyIndexToOwner[_buildingId] == msg.sender)
419       ) {
420         uint256 totalVolume = _property.dx * _property.dz *
421           (_computeHeight(_property.x, _property.z, _property.y) - 1);
422         uint256 totalUnits = buildingToUnitCount[_buildingId];
423         return totalUnits < totalVolume;
424       }
425       return false;
426     }
427 
428     /// @dev This internal function skips all validation checks. Ensure that
429     //   canCreateUnit() is required before calling this method.
430     function _createUnitHelper(uint256 _buildingId, address _owner)
431         internal
432         returns(uint256)
433     {
434         // Grab a reference to the property in storage.
435         Property storage _property = properties[_buildingId];
436         uint256 totalArea = _property.dx * _property.dz;
437         uint256 index = buildingToUnitCount[_buildingId];
438 
439         // Calculate next location.
440         uint256 y = index / totalArea + 1;
441         uint256 intermediate = index % totalArea;
442         uint256 z = intermediate / _property.dx;
443         uint256 x = intermediate % _property.dx;
444 
445         uint256 unitId = _createUnit(
446           _buildingId,
447           x + _property.x,
448           y,
449           z + _property.z,
450           _owner
451         );
452 
453         buildingToUnitCount[_buildingId]++;
454         buildingToUnits[_buildingId].push(unitId);
455 
456         // Return the new unit's ID.
457         return unitId;
458     }
459 
460     /// @dev Update allows for setting a building privacy.
461     function updateBuildingPrivacy(uint _tokenId, bool _public) public {
462         require(propertyIndexToOwner[_tokenId] == msg.sender);
463         buildingIsPublic[_tokenId] = _public;
464     }
465 
466     /// @dev Update allows for setting the data associated to a property.
467     function updatePropertyData(uint _tokenId, string _data) public {
468         require(updateEnabled);
469         address _owner = propertyIndexToOwner[_tokenId];
470         require(msg.sender == _owner);
471         propertyIndexToData[_tokenId] = _data;
472         Property memory _property = properties[_tokenId];
473         Construct(
474             _owner,
475             _tokenId,
476             _property.class,
477             _property.x,
478             _property.y,
479             _property.z,
480             _property.dx,
481             _property.dz,
482             _data
483         );
484     }
485 }
486 
487 // File: contracts-origin/ERC721Draft.sol
488 
489 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
490 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
491 contract ERC721 {
492     function implementsERC721() public pure returns (bool);
493     function totalSupply() public view returns (uint256 total);
494     function balanceOf(address _owner) public view returns (uint256 balance);
495     function ownerOf(uint256 _tokenId) public view returns (address owner);
496     function approve(address _to, uint256 _tokenId) public;
497     function transferFrom(address _from, address _to, uint256 _tokenId) public;
498     function transfer(address _to, uint256 _tokenId) public;
499     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
500     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
501 
502     // Optional
503     // function name() public view returns (string name);
504     // function symbol() public view returns (string symbol);
505     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
506     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
507 }
508 
509 // File: contracts-origin/AetherOwnership.sol
510 
511 /// @title The facet of the Aether core contract that manages ownership, ERC-721 (draft) compliant.
512 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
513 ///  See the PropertyCore contract documentation to understand how the various contract facets are arranged.
514 contract AetherOwnership is AetherBase, ERC721 {
515 
516     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
517     string public name = "Aether";
518     string public symbol = "AETH";
519 
520     function implementsERC721() public pure returns (bool)
521     {
522         return true;
523     }
524 
525     // Internal utility functions: These functions all assume that their input arguments
526     // are valid. We leave it to public methods to sanitize their inputs and follow
527     // the required logic.
528 
529     /// @dev Checks if a given address is the current owner of a particular Property.
530     /// @param _claimant the address we are validating against.
531     /// @param _tokenId property id, only valid when > 0
532     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
533         return propertyIndexToOwner[_tokenId] == _claimant;
534     }
535 
536     /// @dev Checks if a given address currently has transferApproval for a particular Property.
537     /// @param _claimant the address we are confirming property is approved for.
538     /// @param _tokenId property id, only valid when > 0
539     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
540         return propertyIndexToApproved[_tokenId] == _claimant;
541     }
542 
543     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
544     ///  approval. Setting _approved to address(0) clears all transfer approval.
545     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
546     ///  _approve() and transferFrom() are used together for putting Properties on auction, and
547     ///  there is no value in spamming the log with Approval events in that case.
548     function _approve(uint256 _tokenId, address _approved) internal {
549         propertyIndexToApproved[_tokenId] = _approved;
550     }
551 
552     /// @dev Transfers a property owned by this contract to the specified address.
553     ///  Used to rescue lost properties. (There is no "proper" flow where this contract
554     ///  should be the owner of any Property. This function exists for us to reassign
555     ///  the ownership of Properties that users may have accidentally sent to our address.)
556     /// @param _propertyId - ID of property
557     /// @param _recipient - Address to send the property to
558     function rescueLostProperty(uint256 _propertyId, address _recipient) public onlyCOO whenNotPaused {
559         require(_owns(this, _propertyId));
560         _transfer(this, _recipient, _propertyId);
561     }
562 
563     /// @notice Returns the number of Properties owned by a specific address.
564     /// @param _owner The owner address to check.
565     /// @dev Required for ERC-721 compliance
566     function balanceOf(address _owner) public view returns (uint256 count) {
567         return ownershipTokenCount[_owner];
568     }
569 
570     /// @notice Transfers a Property to another address. If transferring to a smart
571     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
572     ///  Laputa specifically) or your Property may be lost forever. Seriously.
573     /// @param _to The address of the recipient, can be a user or contract.
574     /// @param _tokenId The ID of the Property to transfer.
575     /// @dev Required for ERC-721 compliance.
576     function transfer(
577         address _to,
578         uint256 _tokenId
579     )
580         public
581         whenNotPaused
582     {
583         // Safety check to prevent against an unexpected 0x0 default.
584         require(_to != address(0));
585         // You can only send your own property.
586         require(_owns(msg.sender, _tokenId));
587 
588         // Reassign ownership, clear pending approvals, emit Transfer event.
589         _transfer(msg.sender, _to, _tokenId);
590     }
591 
592     /// @notice Grant another address the right to transfer a specific Property via
593     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
594     /// @param _to The address to be granted transfer approval. Pass address(0) to
595     ///  clear all approvals.
596     /// @param _tokenId The ID of the Property that can be transferred if this call succeeds.
597     /// @dev Required for ERC-721 compliance.
598     function approve(
599         address _to,
600         uint256 _tokenId
601     )
602         public
603         whenNotPaused
604     {
605         // Only an owner can grant transfer approval.
606         require(_owns(msg.sender, _tokenId));
607 
608         // Register the approval (replacing any previous approval).
609         _approve(_tokenId, _to);
610 
611         // Emit approval event.
612         Approval(msg.sender, _to, _tokenId);
613     }
614 
615     /// @notice Transfer a Property owned by another address, for which the calling address
616     ///  has previously been granted transfer approval by the owner.
617     /// @param _from The address that owns the Property to be transfered.
618     /// @param _to The address that should take ownership of the Property. Can be any address,
619     ///  including the caller.
620     /// @param _tokenId The ID of the Property to be transferred.
621     /// @dev Required for ERC-721 compliance.
622     function transferFrom(
623         address _from,
624         address _to,
625         uint256 _tokenId
626     )
627         public
628         whenNotPaused
629     {
630         // Check for approval and valid ownership
631         require(_approvedFor(msg.sender, _tokenId));
632         require(_owns(_from, _tokenId));
633 
634         // Reassign ownership (also clears pending approvals and emits Transfer event).
635         _transfer(_from, _to, _tokenId);
636     }
637 
638     /// @notice Returns the total number of Properties currently in existence.
639     /// @dev Required for ERC-721 compliance.
640     function totalSupply() public view returns (uint) {
641         return properties.length;
642     }
643 
644     function totalDistrictSupply() public view returns(uint count) {
645         return districts.length;
646     }
647 
648     /// @notice Returns the address currently assigned ownership of a given Property.
649     /// @dev Required for ERC-721 compliance.
650     function ownerOf(uint256 _tokenId)
651         public
652         view
653         returns (address owner)
654     {
655         owner = propertyIndexToOwner[_tokenId];
656 
657         require(owner != address(0));
658     }
659 
660 
661     /// @notice Returns a list of all Property IDs assigned to an address.
662     /// @param _owner The owner whose Properties we are interested in.
663     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
664     ///  expensive (it walks the entire Kitty array looking for cats belonging to owner),
665     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
666     ///  not contract-to-contract calls.
667     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
668         uint256 tokenCount = balanceOf(_owner);
669 
670         if (tokenCount == 0) {
671             // Return an empty array
672             return new uint256[](0);
673         } else {
674             uint256[] memory result = new uint256[](tokenCount);
675             uint256 totalProperties = totalSupply();
676             uint256 resultIndex = 0;
677 
678             // We count on the fact that all properties have IDs starting at 1 and increasing
679             // sequentially up to the totalProperties count.
680             uint256 tokenId;
681 
682             for (tokenId = 1; tokenId <= totalProperties; tokenId++) {
683                 if (propertyIndexToOwner[tokenId] == _owner) {
684                     result[resultIndex] = tokenId;
685                     resultIndex++;
686                 }
687             }
688 
689             return result;
690         }
691     }
692 }
693 
694 // File: contracts-origin/Auction/ClockAuctionBase.sol
695 
696 /// @title Auction Core
697 /// @dev Contains models, variables, and internal methods for the auction.
698 contract ClockAuctionBase {
699 
700     // Represents an auction on an NFT
701     struct Auction {
702         // Current owner of NFT
703         address seller;
704         // Price (in wei) at beginning of auction
705         uint128 startingPrice;
706         // Price (in wei) at end of auction
707         uint128 endingPrice;
708         // Duration (in seconds) of auction
709         uint64 duration;
710         // Time when auction started
711         // NOTE: 0 if this auction has been concluded
712         uint64 startedAt;
713     }
714 
715     // Reference to contract tracking NFT ownership
716     ERC721 public nonFungibleContract;
717 
718     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
719     // Values 0-10,000 map to 0%-100%
720     uint256 public ownerCut;
721 
722     // Map from token ID to their corresponding auction.
723     mapping (uint256 => Auction) tokenIdToAuction;
724 
725     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
726     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
727     event AuctionCancelled(uint256 tokenId);
728 
729     /// @dev DON'T give me your money.
730     function() external {}
731 
732     // Modifiers to check that inputs can be safely stored with a certain
733     // number of bits. We use constants and multiple modifiers to save gas.
734     modifier canBeStoredWith64Bits(uint256 _value) {
735         require(_value <= 18446744073709551615);
736         _;
737     }
738 
739     modifier canBeStoredWith128Bits(uint256 _value) {
740         require(_value < 340282366920938463463374607431768211455);
741         _;
742     }
743 
744     /// @dev Returns true if the claimant owns the token.
745     /// @param _claimant - Address claiming to own the token.
746     /// @param _tokenId - ID of token whose ownership to verify.
747     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
748         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
749     }
750 
751     /// @dev Escrows the NFT, assigning ownership to this contract.
752     /// Throws if the escrow fails.
753     /// @param _owner - Current owner address of token to escrow.
754     /// @param _tokenId - ID of token whose approval to verify.
755     function _escrow(address _owner, uint256 _tokenId) internal {
756         // it will throw if transfer fails
757         nonFungibleContract.transferFrom(_owner, this, _tokenId);
758     }
759 
760     /// @dev Transfers an NFT owned by this contract to another address.
761     /// Returns true if the transfer succeeds.
762     /// @param _receiver - Address to transfer NFT to.
763     /// @param _tokenId - ID of token to transfer.
764     function _transfer(address _receiver, uint256 _tokenId) internal {
765         // it will throw if transfer fails
766         nonFungibleContract.transfer(_receiver, _tokenId);
767     }
768 
769     /// @dev Adds an auction to the list of open auctions. Also fires the
770     ///  AuctionCreated event.
771     /// @param _tokenId The ID of the token to be put on auction.
772     /// @param _auction Auction to add.
773     function _addAuction(uint256 _tokenId, Auction _auction) internal {
774         // Require that all auctions have a duration of
775         // at least one minute. (Keeps our math from getting hairy!)
776         require(_auction.duration >= 1 minutes);
777 
778         tokenIdToAuction[_tokenId] = _auction;
779 
780         AuctionCreated(
781             uint256(_tokenId),
782             uint256(_auction.startingPrice),
783             uint256(_auction.endingPrice),
784             uint256(_auction.duration)
785         );
786     }
787 
788     /// @dev Cancels an auction unconditionally.
789     function _cancelAuction(uint256 _tokenId, address _seller) internal {
790         _removeAuction(_tokenId);
791         _transfer(_seller, _tokenId);
792         AuctionCancelled(_tokenId);
793     }
794 
795     /// @dev Computes the price and transfers winnings.
796     /// Does NOT transfer ownership of token.
797     function _bid(uint256 _tokenId, uint256 _bidAmount)
798         internal
799         returns (uint256)
800     {
801         // Get a reference to the auction struct
802         Auction storage auction = tokenIdToAuction[_tokenId];
803 
804         // Explicitly check that this auction is currently live.
805         // (Because of how Ethereum mappings work, we can't just count
806         // on the lookup above failing. An invalid _tokenId will just
807         // return an auction object that is all zeros.)
808         require(_isOnAuction(auction));
809 
810         // Check that the incoming bid is higher than the current
811         // price
812         uint256 price = _currentPrice(auction);
813         require(_bidAmount >= price);
814 
815         // Grab a reference to the seller before the auction struct
816         // gets deleted.
817         address seller = auction.seller;
818 
819         // The bid is good! Remove the auction before sending the fees
820         // to the sender so we can't have a reentrancy attack.
821         _removeAuction(_tokenId);
822 
823         // Transfer proceeds to seller (if there are any!)
824         if (price > 0) {
825             //  Calculate the auctioneer's cut.
826             // (NOTE: _computeCut() is guaranteed to return a
827             //  value <= price, so this subtraction can't go negative.)
828             uint256 auctioneerCut = _computeCut(price);
829             uint256 sellerProceeds = price - auctioneerCut;
830 
831             // NOTE: Doing a transfer() in the middle of a complex
832             // method like this is generally discouraged because of
833             // reentrancy attacks and DoS attacks if the seller is
834             // a contract with an invalid fallback function. We explicitly
835             // guard against reentrancy attacks by removing the auction
836             // before calling transfer(), and the only thing the seller
837             // can DoS is the sale of their own asset! (And if it's an
838             // accident, they can call cancelAuction(). )
839             seller.transfer(sellerProceeds);
840         }
841 
842         // Tell the world!
843         AuctionSuccessful(_tokenId, price, msg.sender);
844 
845         return price;
846     }
847 
848     /// @dev Removes an auction from the list of open auctions.
849     /// @param _tokenId - ID of NFT on auction.
850     function _removeAuction(uint256 _tokenId) internal {
851         delete tokenIdToAuction[_tokenId];
852     }
853 
854     /// @dev Returns true if the NFT is on auction.
855     /// @param _auction - Auction to check.
856     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
857         return (_auction.startedAt > 0);
858     }
859 
860     /// @dev Returns current price of an NFT on auction. Broken into two
861     ///  functions (this one, that computes the duration from the auction
862     ///  structure, and the other that does the price computation) so we
863     ///  can easily test that the price computation works correctly.
864     function _currentPrice(Auction storage _auction)
865         internal
866         view
867         returns (uint256)
868     {
869         uint256 secondsPassed = 0;
870 
871         // A bit of insurance against negative values (or wraparound).
872         // Probably not necessary (since Ethereum guarnatees that the
873         // now variable doesn't ever go backwards).
874         if (now > _auction.startedAt) {
875             secondsPassed = now - _auction.startedAt;
876         }
877 
878         return _computeCurrentPrice(
879             _auction.startingPrice,
880             _auction.endingPrice,
881             _auction.duration,
882             secondsPassed
883         );
884     }
885 
886     /// @dev Computes the current price of an auction. Factored out
887     ///  from _currentPrice so we can run extensive unit tests.
888     ///  When testing, make this function public and turn on
889     ///  `Current price computation` test suite.
890     function _computeCurrentPrice(
891         uint256 _startingPrice,
892         uint256 _endingPrice,
893         uint256 _duration,
894         uint256 _secondsPassed
895     )
896         internal
897         pure
898         returns (uint256)
899     {
900         // NOTE: We don't use SafeMath (or similar) in this function because
901         //  all of our public functions carefully cap the maximum values for
902         //  time (at 64-bits) and currency (at 128-bits). _duration is
903         //  also known to be non-zero (see the require() statement in
904         //  _addAuction())
905         if (_secondsPassed >= _duration) {
906             // We've reached the end of the dynamic pricing portion
907             // of the auction, just return the end price.
908             return _endingPrice;
909         } else {
910             // Starting price can be higher than ending price (and often is!), so
911             // this delta can be negative.
912             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
913 
914             // This multiplication can't overflow, _secondsPassed will easily fit within
915             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
916             // will always fit within 256-bits.
917             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
918 
919             // currentPriceChange can be negative, but if so, will have a magnitude
920             // less that _startingPrice. Thus, this result will always end up positive.
921             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
922 
923             return uint256(currentPrice);
924         }
925     }
926 
927     /// @dev Computes owner's cut of a sale.
928     /// @param _price - Sale price of NFT.
929     function _computeCut(uint256 _price) internal view returns (uint256) {
930         // NOTE: We don't use SafeMath (or similar) in this function because
931         //  all of our entry functions carefully cap the maximum values for
932         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
933         //  statement in the ClockAuction constructor). The result of this
934         //  function is always guaranteed to be <= _price.
935         return _price * ownerCut / 10000;
936     }
937 
938 }
939 
940 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
941 
942 /**
943  * @title Ownable
944  * @dev The Ownable contract has an owner address, and provides basic authorization control
945  * functions, this simplifies the implementation of "user permissions".
946  */
947 contract Ownable {
948   address public owner;
949 
950 
951   /**
952    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
953    * account.
954    */
955   function Ownable() {
956     owner = msg.sender;
957   }
958 
959 
960   /**
961    * @dev Throws if called by any account other than the owner.
962    */
963   modifier onlyOwner() {
964     require(msg.sender == owner);
965     _;
966   }
967 
968 
969   /**
970    * @dev Allows the current owner to transfer control of the contract to a newOwner.
971    * @param newOwner The address to transfer ownership to.
972    */
973   function transferOwnership(address newOwner) onlyOwner {
974     if (newOwner != address(0)) {
975       owner = newOwner;
976     }
977   }
978 
979 }
980 
981 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
982 
983 /**
984  * @title Pausable
985  * @dev Base contract which allows children to implement an emergency stop mechanism.
986  */
987 contract Pausable is Ownable {
988   event Pause();
989   event Unpause();
990 
991   bool public paused = false;
992 
993 
994   /**
995    * @dev modifier to allow actions only when the contract IS paused
996    */
997   modifier whenNotPaused() {
998     require(!paused);
999     _;
1000   }
1001 
1002   /**
1003    * @dev modifier to allow actions only when the contract IS NOT paused
1004    */
1005   modifier whenPaused {
1006     require(paused);
1007     _;
1008   }
1009 
1010   /**
1011    * @dev called by the owner to pause, triggers stopped state
1012    */
1013   function pause() onlyOwner whenNotPaused returns (bool) {
1014     paused = true;
1015     Pause();
1016     return true;
1017   }
1018 
1019   /**
1020    * @dev called by the owner to unpause, returns to normal state
1021    */
1022   function unpause() onlyOwner whenPaused returns (bool) {
1023     paused = false;
1024     Unpause();
1025     return true;
1026   }
1027 }
1028 
1029 // File: contracts-origin/Auction/ClockAuction.sol
1030 
1031 /// @title Clock auction for non-fungible tokens.
1032 contract ClockAuction is Pausable, ClockAuctionBase {
1033 
1034     /// @dev Constructor creates a reference to the NFT ownership contract
1035     ///  and verifies the owner cut is in the valid range.
1036     /// @param _nftAddress - address of a deployed contract implementing
1037     ///  the Nonfungible Interface.
1038     /// @param _cut - percent cut the owner takes on each auction, must be
1039     ///  between 0-10,000.
1040     function ClockAuction(address _nftAddress, uint256 _cut) public {
1041         require(_cut <= 10000);
1042         ownerCut = _cut;
1043         
1044         ERC721 candidateContract = ERC721(_nftAddress);
1045         require(candidateContract.implementsERC721());
1046         nonFungibleContract = candidateContract;
1047     }
1048 
1049     /// @dev Remove all Ether from the contract, which is the owner's cuts
1050     ///  as well as any Ether sent directly to the contract address.
1051     ///  Always transfers to the NFT contract, but can be called either by
1052     ///  the owner or the NFT contract.
1053     function withdrawBalance() external {
1054         address nftAddress = address(nonFungibleContract);
1055 
1056         require(
1057             msg.sender == owner ||
1058             msg.sender == nftAddress
1059         );
1060         nftAddress.transfer(this.balance);
1061     }
1062 
1063     /// @dev Creates and begins a new auction.
1064     /// @param _tokenId - ID of token to auction, sender must be owner.
1065     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1066     /// @param _endingPrice - Price of item (in wei) at end of auction.
1067     /// @param _duration - Length of time to move between starting
1068     ///  price and ending price (in seconds).
1069     /// @param _seller - Seller, if not the message sender
1070     function createAuction(
1071         uint256 _tokenId,
1072         uint256 _startingPrice,
1073         uint256 _endingPrice,
1074         uint256 _duration,
1075         address _seller
1076     )
1077         public
1078         whenNotPaused
1079         canBeStoredWith128Bits(_startingPrice)
1080         canBeStoredWith128Bits(_endingPrice)
1081         canBeStoredWith64Bits(_duration)
1082     {
1083         require(_owns(msg.sender, _tokenId));
1084         _escrow(msg.sender, _tokenId);
1085         Auction memory auction = Auction(
1086             _seller,
1087             uint128(_startingPrice),
1088             uint128(_endingPrice),
1089             uint64(_duration),
1090             uint64(now)
1091         );
1092         _addAuction(_tokenId, auction);
1093     }
1094 
1095     /// @dev Bids on an open auction, completing the auction and transferring
1096     ///  ownership of the NFT if enough Ether is supplied.
1097     /// @param _tokenId - ID of token to bid on.
1098     function bid(uint256 _tokenId)
1099         public
1100         payable
1101         whenNotPaused
1102     {
1103         // _bid will throw if the bid or funds transfer fails
1104         _bid(_tokenId, msg.value);
1105         _transfer(msg.sender, _tokenId);
1106     }
1107 
1108     /// @dev Cancels an auction that hasn't been won yet.
1109     ///  Returns the NFT to original owner.
1110     /// @notice This is a state-modifying function that can
1111     ///  be called while the contract is paused.
1112     /// @param _tokenId - ID of token on auction
1113     function cancelAuction(uint256 _tokenId)
1114         public
1115     {
1116         Auction storage auction = tokenIdToAuction[_tokenId];
1117         require(_isOnAuction(auction));
1118         address seller = auction.seller;
1119         require(msg.sender == seller);
1120         _cancelAuction(_tokenId, seller);
1121     }
1122 
1123     /// @dev Cancels an auction when the contract is paused.
1124     ///  Only the owner may do this, and NFTs are returned to
1125     ///  the seller. This should only be used in emergencies.
1126     /// @param _tokenId - ID of the NFT on auction to cancel.
1127     function cancelAuctionWhenPaused(uint256 _tokenId)
1128         whenPaused
1129         onlyOwner
1130         public
1131     {
1132         Auction storage auction = tokenIdToAuction[_tokenId];
1133         require(_isOnAuction(auction));
1134         _cancelAuction(_tokenId, auction.seller);
1135     }
1136 
1137     /// @dev Returns auction info for an NFT on auction.
1138     /// @param _tokenId - ID of NFT on auction.
1139     function getAuction(uint256 _tokenId)
1140         public
1141         view
1142         returns
1143     (
1144         address seller,
1145         uint256 startingPrice,
1146         uint256 endingPrice,
1147         uint256 duration,
1148         uint256 startedAt
1149     ) {
1150         Auction storage auction = tokenIdToAuction[_tokenId];
1151         require(_isOnAuction(auction));
1152         return (
1153             auction.seller,
1154             auction.startingPrice,
1155             auction.endingPrice,
1156             auction.duration,
1157             auction.startedAt
1158         );
1159     }
1160 
1161     /// @dev Returns the current price of an auction.
1162     /// @param _tokenId - ID of the token price we are checking.
1163     function getCurrentPrice(uint256 _tokenId)
1164         public
1165         view
1166         returns (uint256)
1167     {
1168         Auction storage auction = tokenIdToAuction[_tokenId];
1169         require(_isOnAuction(auction));
1170         return _currentPrice(auction);
1171     }
1172 
1173 }
1174 
1175 // File: contracts-origin/Auction/AetherClockAuction.sol
1176 
1177 /// @title Clock auction modified for sale of property
1178 contract AetherClockAuction is ClockAuction {
1179 
1180     // @dev Sanity check that allows us to ensure that we are pointing to the
1181     //  right auction in our setSaleAuctionAddress() call.
1182     bool public isAetherClockAuction = true;
1183 
1184     // Tracks last 5 sale price of gen0 property sales
1185     uint256 public saleCount;
1186     uint256[5] public lastSalePrices;
1187 
1188     // Delegate constructor
1189     function AetherClockAuction(address _nftAddr, uint256 _cut) public
1190       ClockAuction(_nftAddr, _cut) {}
1191 
1192 
1193     /// @dev Creates and begins a new auction.
1194     /// @param _tokenId - ID of token to auction, sender must be owner.
1195     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1196     /// @param _endingPrice - Price of item (in wei) at end of auction.
1197     /// @param _duration - Length of auction (in seconds).
1198     /// @param _seller - Seller, if not the message sender
1199     function createAuction(
1200         uint256 _tokenId,
1201         uint256 _startingPrice,
1202         uint256 _endingPrice,
1203         uint256 _duration,
1204         address _seller
1205     )
1206         public
1207         canBeStoredWith128Bits(_startingPrice)
1208         canBeStoredWith128Bits(_endingPrice)
1209         canBeStoredWith64Bits(_duration)
1210     {
1211         require(msg.sender == address(nonFungibleContract));
1212         _escrow(_seller, _tokenId);
1213         Auction memory auction = Auction(
1214             _seller,
1215             uint128(_startingPrice),
1216             uint128(_endingPrice),
1217             uint64(_duration),
1218             uint64(now)
1219         );
1220         _addAuction(_tokenId, auction);
1221     }
1222 
1223     /// @dev Updates lastSalePrice if seller is the nft contract
1224     /// Otherwise, works the same as default bid method.
1225     function bid(uint256 _tokenId)
1226         public
1227         payable
1228     {
1229         // _bid verifies token ID size
1230         address seller = tokenIdToAuction[_tokenId].seller;
1231         uint256 price = _bid(_tokenId, msg.value);
1232         _transfer(msg.sender, _tokenId);
1233 
1234         // If not a gen0 auction, exit
1235         if (seller == address(nonFungibleContract)) {
1236             // Track gen0 sale prices
1237             lastSalePrices[saleCount % 5] = price;
1238             saleCount++;
1239         }
1240     }
1241 
1242     function averageSalePrice() public view returns (uint256) {
1243         uint256 sum = 0;
1244         for (uint256 i = 0; i < 5; i++) {
1245             sum += lastSalePrices[i];
1246         }
1247         return sum / 5;
1248     }
1249 }
1250 
1251 // File: contracts-origin/AetherAuction.sol
1252 
1253 /// @title Handles creating auctions for sale and siring of properties.
1254 ///  This wrapper of ReverseAuction exists only so that users can create
1255 ///  auctions with only one transaction.
1256 contract AetherAuction is AetherOwnership{
1257 
1258     /// @dev The address of the ClockAuction contract that handles sales of Aether. This
1259     ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
1260     ///  initiated every 15 minutes.
1261     AetherClockAuction public saleAuction;
1262 
1263     /// @dev Sets the reference to the sale auction.
1264     /// @param _address - Address of sale contract.
1265     function setSaleAuctionAddress(address _address) public onlyCEO {
1266         AetherClockAuction candidateContract = AetherClockAuction(_address);
1267 
1268         // NOTE: verify that a contract is what we expect
1269         require(candidateContract.isAetherClockAuction());
1270 
1271         // Set the new contract address
1272         saleAuction = candidateContract;
1273     }
1274 
1275     /// @dev Put a property up for auction.
1276     ///  Does some ownership trickery to create auctions in one tx.
1277     function createSaleAuction(
1278         uint256 _propertyId,
1279         uint256 _startingPrice,
1280         uint256 _endingPrice,
1281         uint256 _duration
1282     )
1283         public
1284         whenNotPaused
1285     {
1286         // Auction contract checks input sizes
1287         // If property is already on any auction, this will throw
1288         // because it will be owned by the auction contract.
1289         require(_owns(msg.sender, _propertyId));
1290         _approve(_propertyId, saleAuction);
1291         // Sale auction throws if inputs are invalid and clears
1292         // transfer and sire approval after escrowing the property.
1293         saleAuction.createAuction(
1294             _propertyId,
1295             _startingPrice,
1296             _endingPrice,
1297             _duration,
1298             msg.sender
1299         );
1300     }
1301 
1302     /// @dev Transfers the balance of the sale auction contract
1303     /// to the AetherCore contract. We use two-step withdrawal to
1304     /// prevent two transfer calls in the auction bid function.
1305     function withdrawAuctionBalances() external onlyCOO {
1306         saleAuction.withdrawBalance();
1307     }
1308 }
1309 
1310 // File: contracts-origin/AetherConstruct.sol
1311 
1312 // Auction wrapper functions
1313 
1314 
1315 /// @title all functions related to creating property
1316 contract AetherConstruct is AetherAuction {
1317 
1318     uint256 public districtLimit = 16;
1319     uint256 public startingPrice = 1 ether;
1320     uint256 public auctionDuration = 1 days;
1321 
1322     /// @dev Units can be contructed within public and owned buildings.
1323     function createUnit(uint256 _buildingId)
1324         public
1325         payable
1326         returns(uint256)
1327     {
1328         require(canCreateUnit(_buildingId));
1329         require(msg.value >= unitCreationFee);
1330         if (msg.value > unitCreationFee)
1331             msg.sender.transfer(msg.value - unitCreationFee);
1332         uint256 propertyId = _createUnitHelper(_buildingId, msg.sender);
1333         return propertyId;
1334     }
1335 
1336     /// @dev Creation of unit properties. Only callable by COO
1337     function createUnitOmni(
1338       uint32 _buildingId,
1339       address _owner
1340     )
1341       public
1342       onlyCOO
1343     {
1344         if (_owner == address(0)) {
1345              _owner = cooAddress;
1346         }
1347         require(canCreateUnit(_buildingId));
1348         _createUnitHelper(_buildingId, _owner);
1349     }
1350 
1351     /// @dev Creation of building properties. Only callable by COO
1352     function createBuildingOmni(
1353       uint32 _districtId,
1354       uint8 _x,
1355       uint8 _y,
1356       uint8 _z,
1357       uint8 _dx,
1358       uint8 _dz,
1359       address _owner,
1360       bool _open
1361     )
1362       public
1363       onlyCOO
1364     {
1365         if (_owner == address(0)) {
1366              _owner = cooAddress;
1367         }
1368         _createBuilding(_districtId, _x, _y, _z, _dx, _dz, _owner, _open);
1369     }
1370 
1371     /// @dev Creation of district properties, up to a limit. Only callable by COO
1372     function createDistrictOmni(
1373       uint8 _x,
1374       uint8 _z,
1375       uint8 _dx,
1376       uint8 _dz
1377     )
1378       public
1379       onlyCOO
1380     {
1381       require(districts.length < districtLimit);
1382       _createDistrict(_x, _z, _dx, _dz);
1383     }
1384 
1385 
1386     /// @dev Creates a new property with the given details and
1387     ///  creates an auction for it. Only callable by COO.
1388     function createBuildingAuction(
1389       uint32 _districtId,
1390       uint8 _x,
1391       uint8 _y,
1392       uint8 _z,
1393       uint8 _dx,
1394       uint8 _dz,
1395       bool _open
1396     ) public onlyCOO {
1397         uint256 propertyId = _createBuilding(_districtId, _x, _y, _z, _dx, _dz, address(this), _open);
1398         _approve(propertyId, saleAuction);
1399 
1400         saleAuction.createAuction(
1401             propertyId,
1402             _computeNextPrice(),
1403             0,
1404             auctionDuration,
1405             address(this)
1406         );
1407     }
1408 
1409     /// @dev Updates the minimum payment required for calling createUnit(). Can only
1410     ///  be called by the COO address.
1411     function setUnitCreationFee(uint256 _value) public onlyCOO {
1412         unitCreationFee = _value;
1413     }
1414 
1415     /// @dev Update world progression factor allowing for buildings to grow taller
1416     //   as the city expands. Only callable by COO.
1417     function setProgress(uint256 _progress) public onlyCOO {
1418         require(_progress <= 100);
1419         require(_progress > progress);
1420         progress = _progress;
1421     }
1422 
1423     /// @dev Set property data updates flag. Only callable by COO.
1424     function setUpdateState(bool _updateEnabled) public onlyCOO {
1425         updateEnabled = _updateEnabled;
1426     }
1427 
1428     /// @dev Computes the next auction starting price, given the average of the past
1429     ///  5 prices + 50%.
1430     function _computeNextPrice() internal view returns (uint256) {
1431         uint256 avePrice = saleAuction.averageSalePrice();
1432 
1433         // sanity check to ensure we don't overflow arithmetic (this big number is 2^128-1).
1434         require(avePrice < 340282366920938463463374607431768211455);
1435 
1436         uint256 nextPrice = avePrice + (avePrice / 2);
1437 
1438         // We never auction for less than starting price
1439         if (nextPrice < startingPrice) {
1440             nextPrice = startingPrice;
1441         }
1442 
1443         return nextPrice;
1444     }
1445 }
1446 
1447 // File: contracts-origin/AetherCore.sol
1448 
1449 /// @title Aether: A city on the Ethereum blockchain.
1450 /// @author Axiom Zen (https://www.axiomzen.co)
1451 contract AetherCore is AetherConstruct {
1452 
1453     // This is the main Aether contract. In order to keep our code seperated into logical sections,
1454     // we've broken it up in two ways.  The auctions are seperate since their logic is somewhat complex
1455     // and there's always a risk of subtle bugs. By keeping them in their own contracts, we can upgrade
1456     // them without disrupting the main contract that tracks property ownership.
1457     //
1458     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1459     // facet of functionality of Aether. This allows us to keep related code bundled together while still
1460     // avoiding a single giant file with everything in it. The breakdown is as follows:
1461     //
1462     //      - AetherBase: This is where we define the most fundamental code shared throughout the core
1463     //             functionality. This includes our main data storage, constants and data types, plus
1464     //             internal functions for managing these items.
1465     //
1466     //      - AetherAccessControl: This contract manages the various addresses and constraints for operations
1467     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1468     //
1469     //      - AetherOwnership: This provides the methods required for basic non-fungible token
1470     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1471     //
1472     //      - AetherAuction: Here we have the public methods for auctioning or bidding on property.
1473     //             The actual auction functionality is handled in two sibling contracts while auction
1474     //             creation and bidding is mostly mediated through this facet of the core contract.
1475     //
1476     //      - AetherConstruct: This final facet contains the functionality we use for creating new gen0 cats.
1477 
1478     //             the community is new).
1479 
1480     // Set in case the core contract is broken and an upgrade is required
1481     address public newContractAddress;
1482 
1483     /// @notice Creates the main Aether smart contract instance.
1484     function AetherCore() public {
1485         // Starts paused.
1486         paused = true;
1487 
1488         // the creator of the contract is the initial CEO
1489         ceoAddress = msg.sender;
1490 
1491         // the creator of the contract is also the initial COO
1492         cooAddress = msg.sender;
1493     }
1494 
1495     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1496     ///  breaking bug. This method does nothing but keep track of the new contract and
1497     ///  emit a message indicating that the new address is set. It's up to clients of this
1498     ///  contract to update to the new contract address in that case. (This contract will
1499     ///  be paused indefinitely if such an upgrade takes place.)
1500     /// @param _v2Address new address
1501     function setNewAddress(address _v2Address) public onlyCEO whenPaused {
1502         // See README.md for updgrade plan
1503         newContractAddress = _v2Address;
1504         ContractUpgrade(_v2Address);
1505     }
1506 
1507     /// @notice No tipping!
1508     /// @dev Reject all Ether from being sent here, unless it's from one of the
1509     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1510     function() external payable {
1511         require(
1512             msg.sender == address(saleAuction)
1513         );
1514     }
1515 
1516     /// @notice Returns all the relevant information about a specific property.
1517     /// @param _id The ID of the property of interest.
1518     function getProperty(uint256 _id)
1519         public
1520         view
1521         returns (
1522         uint32 parent,
1523         uint8 class,
1524         uint8 x,
1525         uint8 y,
1526         uint8 z,
1527         uint8 dx,
1528         uint8 dz,
1529         uint8 height
1530     ) {
1531         Property storage property = properties[_id];
1532         parent = uint32(property.parent);
1533         class = uint8(property.class);
1534 
1535         height = uint8(property.y);
1536         if (property.class == PropertyClass.BUILDING) {
1537           y = uint8(_computeHeight(property.x, property.z, property.y));
1538         } else {
1539           y = uint8(property.y);
1540         }
1541 
1542         x = uint8(property.x);
1543         z = uint8(property.z);
1544         dx = uint8(property.dx);
1545         dz = uint8(property.dz);
1546     }
1547 
1548     /// @dev Override unpause so it requires all external contract addresses
1549     ///  to be set before contract can be unpaused. Also, we can't have
1550     ///  newContractAddress set either, because then the contract was upgraded.
1551     function unpause() public onlyCEO whenPaused {
1552         require(saleAuction != address(0));
1553         require(newContractAddress == address(0));
1554         // Actually unpause the contract.
1555         super.unpause();
1556     }
1557 }