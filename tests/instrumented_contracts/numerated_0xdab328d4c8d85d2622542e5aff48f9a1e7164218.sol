1 pragma solidity ^0.4.19;
2 
3 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
4 /// @author Ethernauts
5 contract ERC721 {
6     // Required methods
7     function totalSupply() public view returns (uint256 total);
8     function balanceOf(address _owner) public view returns (uint256 balance);
9     function ownerOf(uint256 _tokenId) external view returns (address owner);
10     function approve(address _to, uint256 _tokenId) external;
11     function transfer(address _to, uint256 _tokenId) external;
12     function transferFrom(address _from, address _to, uint256 _tokenId) external;
13     function takeOwnership(uint256 _tokenId) public;
14     function implementsERC721() public pure returns (bool);
15 
16     // Events
17     event Transfer(address from, address to, uint256 tokenId);
18     event Approval(address owner, address approved, uint256 tokenId);
19 
20     // Optional
21     // function name() public view returns (string name);
22     // function symbol() public view returns (string symbol);
23     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
24     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
25 
26     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
27     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
28 }
29 
30 
31 
32 
33 
34 
35 
36 // Extend this library for child contracts
37 library SafeMath {
38 
39     /**
40     * @dev Multiplies two numbers, throws on overflow.
41     */
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         assert(c / a == b);
48         return c;
49     }
50 
51     /**
52     * @dev Integer division of two numbers, truncating the quotient.
53     */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // assert(b > 0); // Solidity automatically throws when dividing by 0
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58         return c;
59     }
60 
61     /**
62     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
63     */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         assert(b <= a);
66         return a - b;
67     }
68 
69     /**
70     * @dev Adds two numbers, throws on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 
78     /**
79     * @dev Compara two numbers, and return the bigger one.
80     */
81     function max(int256 a, int256 b) internal pure returns (int256) {
82         if (a > b) {
83             return a;
84         } else {
85             return b;
86         }
87     }
88 
89     /**
90     * @dev Compara two numbers, and return the bigger one.
91     */
92     function min(int256 a, int256 b) internal pure returns (int256) {
93         if (a < b) {
94             return a;
95         } else {
96             return b;
97         }
98     }
99 
100 
101 }
102 
103 
104 
105 
106 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
107 contract EthernautsBase {
108 
109     /*** CONSTANTS USED ACROSS CONTRACTS ***/
110 
111     /// @dev Used by all contracts that interfaces with Ethernauts
112     ///      The ERC-165 interface signature for ERC-721.
113     ///  Ref: https://github.com/ethereum/EIPs/issues/165
114     ///  Ref: https://github.com/ethereum/EIPs/issues/721
115     bytes4 constant InterfaceSignature_ERC721 =
116     bytes4(keccak256('name()')) ^
117     bytes4(keccak256('symbol()')) ^
118     bytes4(keccak256('totalSupply()')) ^
119     bytes4(keccak256('balanceOf(address)')) ^
120     bytes4(keccak256('ownerOf(uint256)')) ^
121     bytes4(keccak256('approve(address,uint256)')) ^
122     bytes4(keccak256('transfer(address,uint256)')) ^
123     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
124     bytes4(keccak256('takeOwnership(uint256)')) ^
125     bytes4(keccak256('tokensOfOwner(address)')) ^
126     bytes4(keccak256('tokenMetadata(uint256,string)'));
127 
128     /// @dev due solidity limitation we cannot return dynamic array from methods
129     /// so it creates incompability between functions across different contracts
130     uint8 public constant STATS_SIZE = 10;
131     uint8 public constant SHIP_SLOTS = 5;
132 
133     // Possible state of any asset
134     enum AssetState { Available, UpForLease, Used }
135 
136     // Possible state of any asset
137     // NotValid is to avoid 0 in places where category must be bigger than zero
138     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
139 
140     /// @dev Sector stats
141     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
142     /// @notice Possible attributes for each asset
143     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
144     /// 00000010 - Producible - Product of a factory and/or factory contract.
145     /// 00000100 - Explorable- Product of exploration.
146     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
147     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
148     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
149     /// 01000000 - Tradable - Buyable and sellable on the market.
150     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
151     bytes2 public ATTR_SEEDED     = bytes2(2**0);
152     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
153     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
154     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
155     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
156     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
157     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
158     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
159 }
160 
161 /// @notice This contract manages the various addresses and constraints for operations
162 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
163 contract EthernautsAccessControl is EthernautsBase {
164 
165     // This facet controls access control for Ethernauts.
166     // All roles have same responsibilities and rights, but there is slight differences between them:
167     //
168     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
169     //       It is initially set to the address that created the smart contract.
170     //
171     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
172     //
173     //     - The COO: The COO can change contract address and add create assets.
174     //
175     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
176     /// @param newContract address pointing to new contract
177     event ContractUpgrade(address newContract);
178 
179     // The addresses of the accounts (or contracts) that can execute actions within each roles.
180     address public ceoAddress;
181     address public ctoAddress;
182     address public cooAddress;
183     address public oracleAddress;
184 
185     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
186     bool public paused = false;
187 
188     /// @dev Access modifier for CEO-only functionality
189     modifier onlyCEO() {
190         require(msg.sender == ceoAddress);
191         _;
192     }
193 
194     /// @dev Access modifier for CTO-only functionality
195     modifier onlyCTO() {
196         require(msg.sender == ctoAddress);
197         _;
198     }
199 
200     /// @dev Access modifier for CTO-only functionality
201     modifier onlyOracle() {
202         require(msg.sender == oracleAddress);
203         _;
204     }
205 
206     modifier onlyCLevel() {
207         require(
208             msg.sender == ceoAddress ||
209             msg.sender == ctoAddress ||
210             msg.sender == cooAddress
211         );
212         _;
213     }
214 
215     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
216     /// @param _newCEO The address of the new CEO
217     function setCEO(address _newCEO) external onlyCEO {
218         require(_newCEO != address(0));
219 
220         ceoAddress = _newCEO;
221     }
222 
223     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
224     /// @param _newCTO The address of the new CTO
225     function setCTO(address _newCTO) external {
226         require(
227             msg.sender == ceoAddress ||
228             msg.sender == ctoAddress
229         );
230         require(_newCTO != address(0));
231 
232         ctoAddress = _newCTO;
233     }
234 
235     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
236     /// @param _newCOO The address of the new COO
237     function setCOO(address _newCOO) external {
238         require(
239             msg.sender == ceoAddress ||
240             msg.sender == cooAddress
241         );
242         require(_newCOO != address(0));
243 
244         cooAddress = _newCOO;
245     }
246 
247     /// @dev Assigns a new address to act as oracle.
248     /// @param _newOracle The address of oracle
249     function setOracle(address _newOracle) external {
250         require(msg.sender == ctoAddress);
251         require(_newOracle != address(0));
252 
253         oracleAddress = _newOracle;
254     }
255 
256     /*** Pausable functionality adapted from OpenZeppelin ***/
257 
258     /// @dev Modifier to allow actions only when the contract IS NOT paused
259     modifier whenNotPaused() {
260         require(!paused);
261         _;
262     }
263 
264     /// @dev Modifier to allow actions only when the contract IS paused
265     modifier whenPaused {
266         require(paused);
267         _;
268     }
269 
270     /// @dev Called by any "C-level" role to pause the contract. Used only when
271     ///  a bug or exploit is detected and we need to limit damage.
272     function pause() external onlyCLevel whenNotPaused {
273         paused = true;
274     }
275 
276     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
277     ///  one reason we may pause the contract is when CTO account is compromised.
278     /// @notice This is public rather than external so it can be called by
279     ///  derived contracts.
280     function unpause() public onlyCEO whenPaused {
281         // can't unpause if contract was upgraded
282         paused = false;
283     }
284 
285 }
286 
287 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
288 /// @notice This provides the methods required for basic non-fungible token
289 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
290 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
291 //          reference to logic contracts as Auction, Explore and so on
292 /// @author Ethernatus - Fernando Pauer
293 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
294 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
295 
296     /// @dev Contract holding only data.
297     EthernautsStorage public ethernautsStorage;
298 
299     /*** CONSTANTS ***/
300     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
301     string public constant name = "Ethernauts";
302     string public constant symbol = "ETNT";
303 
304     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
305     /**********************************************************************/
306 
307     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
308 
309     /*** EVENTS ***/
310 
311     // Events as per ERC-721
312     event Transfer(address indexed from, address indexed to, uint256 tokens);
313     event Approval(address indexed owner, address indexed approved, uint256 tokens);
314 
315     /// @dev When a new asset is create it emits build event
316     /// @param owner The address of asset owner
317     /// @param tokenId Asset UniqueID
318     /// @param assetId ID that defines asset look and feel
319     /// @param price asset price
320     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
321 
322     function implementsERC721() public pure returns (bool) {
323         return true;
324     }
325 
326     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
327     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
328     /// @param _interfaceID interface signature ID
329     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
330     {
331         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
332     }
333 
334     /// @dev Checks if a given address is the current owner of a particular Asset.
335     /// @param _claimant the address we are validating against.
336     /// @param _tokenId asset UniqueId, only valid when > 0
337     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
338         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
339     }
340 
341     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
342     /// @param _claimant the address we are confirming asset is approved for.
343     /// @param _tokenId asset UniqueId, only valid when > 0
344     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
345         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
346     }
347 
348     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
349     ///  approval. Setting _approved to address(0) clears all transfer approval.
350     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
351     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
352     ///  there is no value in spamming the log with Approval events in that case.
353     function _approve(uint256 _tokenId, address _approved) internal {
354         ethernautsStorage.approve(_tokenId, _approved);
355     }
356 
357     /// @notice Returns the number of Assets owned by a specific address.
358     /// @param _owner The owner address to check.
359     /// @dev Required for ERC-721 compliance
360     function balanceOf(address _owner) public view returns (uint256 count) {
361         return ethernautsStorage.balanceOf(_owner);
362     }
363 
364     /// @dev Required for ERC-721 compliance.
365     /// @notice Transfers a Asset to another address. If transferring to a smart
366     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
367     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
368     /// @param _to The address of the recipient, can be a user or contract.
369     /// @param _tokenId The ID of the Asset to transfer.
370     function transfer(
371         address _to,
372         uint256 _tokenId
373     )
374     external
375     whenNotPaused
376     {
377         // Safety check to prevent against an unexpected 0x0 default.
378         require(_to != address(0));
379         // Disallow transfers to this contract to prevent accidental misuse.
380         // The contract should never own any assets
381         // (except very briefly after it is created and before it goes on auction).
382         require(_to != address(this));
383         // Disallow transfers to the storage contract to prevent accidental
384         // misuse. Auction or Upgrade contracts should only take ownership of assets
385         // through the allow + transferFrom flow.
386         require(_to != address(ethernautsStorage));
387 
388         // You can only send your own asset.
389         require(_owns(msg.sender, _tokenId));
390 
391         // Reassign ownership, clear pending approvals, emit Transfer event.
392         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
393     }
394 
395     /// @dev Required for ERC-721 compliance.
396     /// @notice Grant another address the right to transfer a specific Asset via
397     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
398     /// @param _to The address to be granted transfer approval. Pass address(0) to
399     ///  clear all approvals.
400     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
401     function approve(
402         address _to,
403         uint256 _tokenId
404     )
405     external
406     whenNotPaused
407     {
408         // Only an owner can grant transfer approval.
409         require(_owns(msg.sender, _tokenId));
410 
411         // Register the approval (replacing any previous approval).
412         _approve(_tokenId, _to);
413 
414         // Emit approval event.
415         Approval(msg.sender, _to, _tokenId);
416     }
417 
418 
419     /// @notice Transfer a Asset owned by another address, for which the calling address
420     ///  has previously been granted transfer approval by the owner.
421     /// @param _from The address that owns the Asset to be transferred.
422     /// @param _to The address that should take ownership of the Asset. Can be any address,
423     ///  including the caller.
424     /// @param _tokenId The ID of the Asset to be transferred.
425     function _transferFrom(
426         address _from,
427         address _to,
428         uint256 _tokenId
429     )
430     internal
431     {
432         // Safety check to prevent against an unexpected 0x0 default.
433         require(_to != address(0));
434         // Disallow transfers to this contract to prevent accidental misuse.
435         // The contract should never own any assets (except for used assets).
436         require(_owns(_from, _tokenId));
437         // Check for approval and valid ownership
438         require(_approvedFor(_to, _tokenId));
439 
440         // Reassign ownership (also clears pending approvals and emits Transfer event).
441         ethernautsStorage.transfer(_from, _to, _tokenId);
442     }
443 
444     /// @dev Required for ERC-721 compliance.
445     /// @notice Transfer a Asset owned by another address, for which the calling address
446     ///  has previously been granted transfer approval by the owner.
447     /// @param _from The address that owns the Asset to be transfered.
448     /// @param _to The address that should take ownership of the Asset. Can be any address,
449     ///  including the caller.
450     /// @param _tokenId The ID of the Asset to be transferred.
451     function transferFrom(
452         address _from,
453         address _to,
454         uint256 _tokenId
455     )
456     external
457     whenNotPaused
458     {
459         _transferFrom(_from, _to, _tokenId);
460     }
461 
462     /// @dev Required for ERC-721 compliance.
463     /// @notice Allow pre-approved user to take ownership of a token
464     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
465     function takeOwnership(uint256 _tokenId) public {
466         address _from = ethernautsStorage.ownerOf(_tokenId);
467 
468         // Safety check to prevent against an unexpected 0x0 default.
469         require(_from != address(0));
470         _transferFrom(_from, msg.sender, _tokenId);
471     }
472 
473     /// @notice Returns the total number of Assets currently in existence.
474     /// @dev Required for ERC-721 compliance.
475     function totalSupply() public view returns (uint256) {
476         return ethernautsStorage.totalSupply();
477     }
478 
479     /// @notice Returns owner of a given Asset(Token).
480     /// @param _tokenId Token ID to get owner.
481     /// @dev Required for ERC-721 compliance.
482     function ownerOf(uint256 _tokenId)
483     external
484     view
485     returns (address owner)
486     {
487         owner = ethernautsStorage.ownerOf(_tokenId);
488 
489         require(owner != address(0));
490     }
491 
492     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
493     /// @param _creatorTokenID The asset who is father of this asset
494     /// @param _price asset price
495     /// @param _assetID asset ID
496     /// @param _category see Asset Struct description
497     /// @param _attributes see Asset Struct description
498     /// @param _stats see Asset Struct description
499     function createNewAsset(
500         uint256 _creatorTokenID,
501         address _owner,
502         uint256 _price,
503         uint16 _assetID,
504         uint8 _category,
505         uint8 _attributes,
506         uint8[STATS_SIZE] _stats
507     )
508     external onlyCLevel
509     returns (uint256)
510     {
511         // owner must be sender
512         require(_owner != address(0));
513 
514         uint256 tokenID = ethernautsStorage.createAsset(
515             _creatorTokenID,
516             _owner,
517             _price,
518             _assetID,
519             _category,
520             uint8(AssetState.Available),
521             _attributes,
522             _stats,
523             0,
524             0
525         );
526 
527         // emit the build event
528         Build(
529             _owner,
530             tokenID,
531             _assetID,
532             _price
533         );
534 
535         return tokenID;
536     }
537 
538     /// @notice verify if token is in exploration time
539     /// @param _tokenId The Token ID that can be upgraded
540     function isExploring(uint256 _tokenId) public view returns (bool) {
541         uint256 cooldown;
542         uint64 cooldownEndBlock;
543         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
544         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
545     }
546 }
547 
548 
549 
550 
551 
552 
553 
554 
555 
556 /// @title Storage contract for Ethernauts Data. Common structs and constants.
557 /// @notice This is our main data storage, constants and data types, plus
558 //          internal functions for managing the assets. It is isolated and only interface with
559 //          a list of granted contracts defined by CTO
560 /// @author Ethernauts - Fernando Pauer
561 contract EthernautsStorage is EthernautsAccessControl {
562 
563     function EthernautsStorage() public {
564         // the creator of the contract is the initial CEO
565         ceoAddress = msg.sender;
566 
567         // the creator of the contract is the initial CTO as well
568         ctoAddress = msg.sender;
569 
570         // the creator of the contract is the initial CTO as well
571         cooAddress = msg.sender;
572 
573         // the creator of the contract is the initial Oracle as well
574         oracleAddress = msg.sender;
575     }
576 
577     /// @notice No tipping!
578     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
579     function() external payable {
580         require(msg.sender == address(this));
581     }
582 
583     /*** Mapping for Contracts with granted permission ***/
584     mapping (address => bool) public contractsGrantedAccess;
585 
586     /// @dev grant access for a contract to interact with this contract.
587     /// @param _v2Address The contract address to grant access
588     function grantAccess(address _v2Address) public onlyCTO {
589         // See README.md for updgrade plan
590         contractsGrantedAccess[_v2Address] = true;
591     }
592 
593     /// @dev remove access from a contract to interact with this contract.
594     /// @param _v2Address The contract address to be removed
595     function removeAccess(address _v2Address) public onlyCTO {
596         // See README.md for updgrade plan
597         delete contractsGrantedAccess[_v2Address];
598     }
599 
600     /// @dev Only allow permitted contracts to interact with this contract
601     modifier onlyGrantedContracts() {
602         require(contractsGrantedAccess[msg.sender] == true);
603         _;
604     }
605 
606     modifier validAsset(uint256 _tokenId) {
607         require(assets[_tokenId].ID > 0);
608         _;
609     }
610     /*** DATA TYPES ***/
611 
612     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
613     ///  of this structure. Note that the order of the members in this structure
614     ///  is important because of the byte-packing rules used by Ethereum.
615     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
616     struct Asset {
617 
618         // Asset ID is a identifier for look and feel in frontend
619         uint16 ID;
620 
621         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
622         uint8 category;
623 
624         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
625         uint8 state;
626 
627         // Attributes
628         // byte pos - Definition
629         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
630         // 00000010 - Producible - Product of a factory and/or factory contract.
631         // 00000100 - Explorable- Product of exploration.
632         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
633         // 00010000 - Permanent - Cannot be removed, always owned by a user.
634         // 00100000 - Consumable - Destroyed after N exploration expeditions.
635         // 01000000 - Tradable - Buyable and sellable on the market.
636         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
637         bytes2 attributes;
638 
639         // The timestamp from the block when this asset was created.
640         uint64 createdAt;
641 
642         // The minimum timestamp after which this asset can engage in exploring activities again.
643         uint64 cooldownEndBlock;
644 
645         // The Asset's stats can be upgraded or changed based on exploration conditions.
646         // It will be defined per child contract, but all stats have a range from 0 to 255
647         // Examples
648         // 0 = Ship Level
649         // 1 = Ship Attack
650         uint8[STATS_SIZE] stats;
651 
652         // Set to the cooldown time that represents exploration duration for this asset.
653         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
654         uint256 cooldown;
655 
656         // a reference to a super asset that manufactured the asset
657         uint256 builtBy;
658     }
659 
660     /*** CONSTANTS ***/
661 
662     // @dev Sanity check that allows us to ensure that we are pointing to the
663     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
664     bool public isEthernautsStorage = true;
665 
666     /*** STORAGE ***/
667 
668     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
669     ///  of each asset is actually an index into this array.
670     Asset[] public assets;
671 
672     /// @dev A mapping from Asset UniqueIDs to the price of the token.
673     /// stored outside Asset Struct to save gas, because price can change frequently
674     mapping (uint256 => uint256) internal assetIndexToPrice;
675 
676     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
677     mapping (uint256 => address) internal assetIndexToOwner;
678 
679     // @dev A mapping from owner address to count of tokens that address owns.
680     //  Used internally inside balanceOf() to resolve ownership count.
681     mapping (address => uint256) internal ownershipTokenCount;
682 
683     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
684     ///  transferFrom(). Each Asset can only have one approved address for transfer
685     ///  at any time. A zero value means no approval is outstanding.
686     mapping (uint256 => address) internal assetIndexToApproved;
687 
688 
689     /*** SETTERS ***/
690 
691     /// @dev set new asset price
692     /// @param _tokenId  asset UniqueId
693     /// @param _price    asset price
694     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
695         assetIndexToPrice[_tokenId] = _price;
696     }
697 
698     /// @dev Mark transfer as approved
699     /// @param _tokenId  asset UniqueId
700     /// @param _approved address approved
701     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
702         assetIndexToApproved[_tokenId] = _approved;
703     }
704 
705     /// @dev Assigns ownership of a specific Asset to an address.
706     /// @param _from    current owner address
707     /// @param _to      new owner address
708     /// @param _tokenId asset UniqueId
709     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
710         // Since the number of assets is capped to 2^32 we can't overflow this
711         ownershipTokenCount[_to]++;
712         // transfer ownership
713         assetIndexToOwner[_tokenId] = _to;
714         // When creating new assets _from is 0x0, but we can't account that address.
715         if (_from != address(0)) {
716             ownershipTokenCount[_from]--;
717             // clear any previously approved ownership exchange
718             delete assetIndexToApproved[_tokenId];
719         }
720     }
721 
722     /// @dev A public method that creates a new asset and stores it. This
723     ///  method does basic checking and should only be called from other contract when the
724     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
725     /// @param _creatorTokenID The asset who is father of this asset
726     /// @param _owner First owner of this asset
727     /// @param _price asset price
728     /// @param _ID asset ID
729     /// @param _category see Asset Struct description
730     /// @param _state see Asset Struct description
731     /// @param _attributes see Asset Struct description
732     /// @param _stats see Asset Struct description
733     function createAsset(
734         uint256 _creatorTokenID,
735         address _owner,
736         uint256 _price,
737         uint16 _ID,
738         uint8 _category,
739         uint8 _state,
740         uint8 _attributes,
741         uint8[STATS_SIZE] _stats,
742         uint256 _cooldown,
743         uint64 _cooldownEndBlock
744     )
745     public onlyGrantedContracts
746     returns (uint256)
747     {
748         // Ensure our data structures are always valid.
749         require(_ID > 0);
750         require(_category > 0);
751         require(_attributes != 0x0);
752         require(_stats.length > 0);
753 
754         Asset memory asset = Asset({
755             ID: _ID,
756             category: _category,
757             builtBy: _creatorTokenID,
758             attributes: bytes2(_attributes),
759             stats: _stats,
760             state: _state,
761             createdAt: uint64(now),
762             cooldownEndBlock: _cooldownEndBlock,
763             cooldown: _cooldown
764             });
765 
766         uint256 newAssetUniqueId = assets.push(asset) - 1;
767 
768         // Check it reached 4 billion assets but let's just be 100% sure.
769         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
770 
771         // store price
772         assetIndexToPrice[newAssetUniqueId] = _price;
773 
774         // This will assign ownership
775         transfer(address(0), _owner, newAssetUniqueId);
776 
777         return newAssetUniqueId;
778     }
779 
780     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
781     /// This method doesn't do any checking and should only be called when the
782     ///  input data is known to be valid.
783     /// @param _tokenId The token ID
784     /// @param _creatorTokenID The asset that create that token
785     /// @param _price asset price
786     /// @param _ID asset ID
787     /// @param _category see Asset Struct description
788     /// @param _state see Asset Struct description
789     /// @param _attributes see Asset Struct description
790     /// @param _stats see Asset Struct description
791     /// @param _cooldown asset cooldown index
792     function editAsset(
793         uint256 _tokenId,
794         uint256 _creatorTokenID,
795         uint256 _price,
796         uint16 _ID,
797         uint8 _category,
798         uint8 _state,
799         uint8 _attributes,
800         uint8[STATS_SIZE] _stats,
801         uint16 _cooldown
802     )
803     external validAsset(_tokenId) onlyCLevel
804     returns (uint256)
805     {
806         // Ensure our data structures are always valid.
807         require(_ID > 0);
808         require(_category > 0);
809         require(_attributes != 0x0);
810         require(_stats.length > 0);
811 
812         // store price
813         assetIndexToPrice[_tokenId] = _price;
814 
815         Asset storage asset = assets[_tokenId];
816         asset.ID = _ID;
817         asset.category = _category;
818         asset.builtBy = _creatorTokenID;
819         asset.attributes = bytes2(_attributes);
820         asset.stats = _stats;
821         asset.state = _state;
822         asset.cooldown = _cooldown;
823     }
824 
825     /// @dev Update only stats
826     /// @param _tokenId asset UniqueId
827     /// @param _stats asset state, see Asset Struct description
828     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
829         assets[_tokenId].stats = _stats;
830     }
831 
832     /// @dev Update only asset state
833     /// @param _tokenId asset UniqueId
834     /// @param _state asset state, see Asset Struct description
835     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
836         assets[_tokenId].state = _state;
837     }
838 
839     /// @dev Update Cooldown for a single asset
840     /// @param _tokenId asset UniqueId
841     /// @param _cooldown asset state, see Asset Struct description
842     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
843     public validAsset(_tokenId) onlyGrantedContracts {
844         assets[_tokenId].cooldown = _cooldown;
845         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
846     }
847 
848     /*** GETTERS ***/
849 
850     /// @notice Returns only stats data about a specific asset.
851     /// @dev it is necessary due solidity compiler limitations
852     ///      when we have large qty of parameters it throws StackTooDeepException
853     /// @param _tokenId The UniqueId of the asset of interest.
854     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
855         return assets[_tokenId].stats;
856     }
857 
858     /// @dev return current price of an asset
859     /// @param _tokenId asset UniqueId
860     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
861         return assetIndexToPrice[_tokenId];
862     }
863 
864     /// @notice Check if asset has all attributes passed by parameter
865     /// @param _tokenId The UniqueId of the asset of interest.
866     /// @param _attributes see Asset Struct description
867     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
868         return assets[_tokenId].attributes & _attributes == _attributes;
869     }
870 
871     /// @notice Check if asset has any attribute passed by parameter
872     /// @param _tokenId The UniqueId of the asset of interest.
873     /// @param _attributes see Asset Struct description
874     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
875         return assets[_tokenId].attributes & _attributes != 0x0;
876     }
877 
878     /// @notice Check if asset is in the state passed by parameter
879     /// @param _tokenId The UniqueId of the asset of interest.
880     /// @param _category see AssetCategory in EthernautsBase for possible states
881     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
882         return assets[_tokenId].category == _category;
883     }
884 
885     /// @notice Check if asset is in the state passed by parameter
886     /// @param _tokenId The UniqueId of the asset of interest.
887     /// @param _state see enum AssetState in EthernautsBase for possible states
888     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
889         return assets[_tokenId].state == _state;
890     }
891 
892     /// @notice Returns owner of a given Asset(Token).
893     /// @dev Required for ERC-721 compliance.
894     /// @param _tokenId asset UniqueId
895     function ownerOf(uint256 _tokenId) public view returns (address owner)
896     {
897         return assetIndexToOwner[_tokenId];
898     }
899 
900     /// @dev Required for ERC-721 compliance
901     /// @notice Returns the number of Assets owned by a specific address.
902     /// @param _owner The owner address to check.
903     function balanceOf(address _owner) public view returns (uint256 count) {
904         return ownershipTokenCount[_owner];
905     }
906 
907     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
908     /// @param _tokenId asset UniqueId
909     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
910         return assetIndexToApproved[_tokenId];
911     }
912 
913     /// @notice Returns the total number of Assets currently in existence.
914     /// @dev Required for ERC-721 compliance.
915     function totalSupply() public view returns (uint256) {
916         return assets.length;
917     }
918 
919     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
920     /// @param _owner filter all assets by owner
921     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
922         uint256[6][]
923     ) {
924         uint256 totalAssets = assets.length;
925 
926         if (totalAssets == 0) {
927             // Return an empty array
928             return new uint256[6][](0);
929         } else {
930             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
931             uint256 resultIndex = 0;
932             bytes2 hasAttributes  = bytes2(_withAttributes);
933             Asset memory asset;
934 
935             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
936                 asset = assets[tokenId];
937                 if (
938                     (asset.state != uint8(AssetState.Used)) &&
939                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
940                     (asset.attributes & hasAttributes == hasAttributes)
941                 ) {
942                     result[resultIndex][0] = tokenId;
943                     result[resultIndex][1] = asset.ID;
944                     result[resultIndex][2] = asset.category;
945                     result[resultIndex][3] = uint256(asset.attributes);
946                     result[resultIndex][4] = asset.cooldown;
947                     result[resultIndex][5] = assetIndexToPrice[tokenId];
948                     resultIndex++;
949                 }
950             }
951 
952             return result;
953         }
954     }
955 }
956 
957 
958 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
959 /// @author Ethernatus - Fernando Pauer
960 contract EthernautsLogic is EthernautsOwnership {
961 
962     // Set in case the logic contract is broken and an upgrade is required
963     address public newContractAddress;
964 
965     /// @dev Constructor
966     function EthernautsLogic() public {
967         // the creator of the contract is the initial CEO, COO, CTO
968         ceoAddress = msg.sender;
969         ctoAddress = msg.sender;
970         cooAddress = msg.sender;
971         oracleAddress = msg.sender;
972 
973         // Starts paused.
974         paused = true;
975     }
976 
977     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
978     ///  breaking bug. This method does nothing but keep track of the new contract and
979     ///  emit a message indicating that the new address is set. It's up to clients of this
980     ///  contract to update to the new contract address in that case. (This contract will
981     ///  be paused indefinitely if such an upgrade takes place.)
982     /// @param _v2Address new address
983     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
984         // See README.md for updgrade plan
985         newContractAddress = _v2Address;
986         ContractUpgrade(_v2Address);
987     }
988 
989     /// @dev set a new reference to the NFT ownership contract
990     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
991     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
992         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
993         require(candidateContract.isEthernautsStorage());
994         ethernautsStorage = candidateContract;
995     }
996 
997     /// @dev Override unpause so it requires all external contract addresses
998     ///  to be set before contract can be unpaused. Also, we can't have
999     ///  newContractAddress set either, because then the contract was upgraded.
1000     /// @notice This is public rather than external so we can call super.unpause
1001     ///  without using an expensive CALL.
1002     function unpause() public onlyCEO whenPaused {
1003         require(ethernautsStorage != address(0));
1004         require(newContractAddress == address(0));
1005         // require this contract to have access to storage contract
1006         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1007 
1008         // Actually unpause the contract.
1009         super.unpause();
1010     }
1011 
1012     // @dev Allows the COO to capture the balance available to the contract.
1013     function withdrawBalances(address _to) public onlyCLevel {
1014         _to.transfer(this.balance);
1015     }
1016 
1017     /// return current contract balance
1018     function getBalance() public view onlyCLevel returns (uint256) {
1019         return this.balance;
1020     }
1021 }
1022 
1023 /// @title Clock auction for non-fungible tokens.
1024 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1025 ///         This provides public methods for Upgrade ship.
1026 ///
1027 ///      - UpgradeShip: This provides public methods for managing how and if a ship can upgrade.
1028 ///             The user can place a number of Ship Upgrades on the ship to affect the ship’s exploration.
1029 ///             Combining the Explore and Upgrade actions together limits the amount of gas the user has to pay.
1030 /// @author Ethernatus - Fernando Pauer
1031 contract EthernautsUpgrade is EthernautsLogic {
1032 
1033     /// @dev Constructor creates a reference to the NFT ownership contract
1034     ///  and verifies the owner cut is in the valid range.
1035     ///  and Delegate constructor to Nonfungible contract.
1036     function EthernautsUpgrade() public
1037     EthernautsLogic() {}
1038 
1039     /*** EVENTS ***/
1040     /// @dev The Upgrade event is fired whenever a ship is upgraded.
1041     event Upgrade(uint256 indexed tokenId);
1042 
1043     /*** CONSTANTS ***/
1044     uint8 STATS_CAPOUT = 2**8 - 1; // all stats have a range from 0 to 255
1045 
1046     // ************************* UPGRADE SHIP ****************************
1047 
1048     /// @notice Check and define how a ship can upgrade
1049     /// Example:
1050     /// User A wants to Upgrade Ship A. Ship A has 5 available upgrade slots.
1051     /// Thankfully, User A has 5 Ship Upgrades in their inventory.
1052     /// They have 1x Plasma Cannons (+1 Attack), Hardened Plates (+2 Defense),
1053     ///           1x Navigation Processor (+1 Range), 1x Engine Tune (+2 Speed), and Lucky Shamrock (+1 Luck) .
1054     /// User A drags the 5 Ship Upgrades into the appropriate slots and hits the Upgrade button.
1055     /// Ship A’s stats are now improved by +1 Attack, +2 Defense, +1 Range, +2 Speed, and +1 Luck, forever.
1056     /// The Ship Upgrades are consumed and disappear. The Ship then increases in level +1 to a total level of 2.
1057     /// @param _tokenId The Token ID that can be upgraded
1058     /// @param _objects List of objects to be used in the upgrade
1059     function upgradeShip(uint256 _tokenId, uint256[SHIP_SLOTS] _objects) external whenNotPaused {
1060         // Checking if Asset is a ship or not
1061         require(ethernautsStorage.isCategory(_tokenId, uint8(AssetCategory.Ship)));
1062 
1063         // Ensure the Ship is in available state, otherwise it cannot be upgraded
1064         require(ethernautsStorage.isState(_tokenId, uint8(AssetState.Available)));
1065 
1066         // only owner can upgrade his/her ship
1067         require(msg.sender == ethernautsStorage.ownerOf(_tokenId));
1068 
1069         // ship could not be in exploration
1070         require(!isExploring(_tokenId));
1071 
1072         // get ship and objects current stats
1073         uint i = 0;
1074         uint8[STATS_SIZE] memory _shipStats = ethernautsStorage.getStats(_tokenId);
1075         uint256 level = _shipStats[uint(ShipStats.Level)];
1076         uint8[STATS_SIZE][SHIP_SLOTS] memory _objectsStats;
1077 
1078         // check if level capped out, if yes no more upgrade is available
1079         require(level < 5);
1080 
1081         // a mapping to require upgrades should have different token ids
1082         uint256[] memory upgradesToTokenIndex = new uint256[](ethernautsStorage.totalSupply());
1083 
1084         // all objects must be available to use
1085         for(i = 0; i < _objects.length; i++) {
1086             // sender should owner all assets
1087             require(msg.sender == ethernautsStorage.ownerOf(_objects[i]));
1088             require(!isExploring(_objects[i]));
1089             require(ethernautsStorage.isCategory(_objects[i], uint8(AssetCategory.Object)));
1090             // avoiding duplicate keys
1091             require(upgradesToTokenIndex[_objects[i]] == 0);
1092 
1093             // mark token id as read and avoid duplicated token ids
1094             upgradesToTokenIndex[_objects[i]] = _objects[i];
1095             _objectsStats[i] = ethernautsStorage.getStats(_objects[i]);
1096         }
1097 
1098         // upgrading stats
1099         uint256 attack = _shipStats[uint(ShipStats.Attack)];
1100         uint256 defense = _shipStats[uint(ShipStats.Defense)];
1101         uint256 speed = _shipStats[uint(ShipStats.Speed)];
1102         uint256 range = _shipStats[uint(ShipStats.Range)];
1103         uint256 luck = _shipStats[uint(ShipStats.Luck)];
1104 
1105         for(i = 0; i < SHIP_SLOTS; i++) {
1106             // Only objects with upgrades are allowed
1107             require(_objectsStats[i][1] +
1108                     _objectsStats[i][2] +
1109                     _objectsStats[i][3] +
1110                     _objectsStats[i][4] +
1111                     _objectsStats[i][5] > 0);
1112 
1113             attack += _objectsStats[i][uint(ShipStats.Attack)];
1114             defense += _objectsStats[i][uint(ShipStats.Defense)];
1115             speed += _objectsStats[i][uint(ShipStats.Speed)];
1116             range += _objectsStats[i][uint(ShipStats.Range)];
1117             luck += _objectsStats[i][uint(ShipStats.Luck)];
1118         }
1119 
1120         if (attack > STATS_CAPOUT) {
1121             attack = STATS_CAPOUT;
1122         }
1123         if (defense > STATS_CAPOUT) {
1124             defense = STATS_CAPOUT;
1125         }
1126         if (speed > STATS_CAPOUT) {
1127             speed = STATS_CAPOUT;
1128         }
1129         if (range > STATS_CAPOUT) {
1130             range = STATS_CAPOUT;
1131         }
1132         if (luck > STATS_CAPOUT) {
1133             luck = STATS_CAPOUT;
1134         }
1135 
1136         // All stats must increase, even if its provided 5 upgrades in the slots
1137         require(attack > _shipStats[uint(ShipStats.Attack)]);
1138         require(defense > _shipStats[uint(ShipStats.Defense)]);
1139         require(speed > _shipStats[uint(ShipStats.Speed)]);
1140         require(range > _shipStats[uint(ShipStats.Range)]);
1141         require(luck > _shipStats[uint(ShipStats.Luck)]);
1142 
1143         _shipStats[uint(ShipStats.Level)] = uint8(level + 1);
1144         _shipStats[uint(ShipStats.Attack)] = uint8(attack);
1145         _shipStats[uint(ShipStats.Defense)] = uint8(defense);
1146         _shipStats[uint(ShipStats.Speed)] = uint8(speed);
1147         _shipStats[uint(ShipStats.Range)] = uint8(range);
1148         _shipStats[uint(ShipStats.Luck)] = uint8(luck);
1149 
1150         // only upgrade after confirmed transaction by Upgrade Ship Contract
1151         ethernautsStorage.updateStats(_tokenId, _shipStats);
1152 
1153         // mark all objects as used and change owner
1154         for(i = 0; i < _objects.length; i++) {
1155             ethernautsStorage.updateState(_objects[i], uint8(AssetState.Used));
1156 
1157             // Register the approval and transfer to upgrade ship contract
1158             _approve(_objects[i], address(this));
1159             _transferFrom(msg.sender, address(this), _objects[i]);
1160         }
1161 
1162         Upgrade(_tokenId);
1163     }
1164 
1165     function transfer(
1166         address _to,
1167         uint256 _tokenId
1168     )
1169     external onlyOracle whenNotPaused
1170     {
1171         // Safety check to prevent against an unexpected 0x0 default.
1172         require(_to != address(0));
1173         // Disallow transfers to this contract to prevent accidental misuse.
1174         // The contract should never own any assets
1175         // (except very briefly after it is created and before it goes on auction).
1176         require(_to != address(this));
1177         // Disallow transfers to the storage contract to prevent accidental
1178         // misuse. Auction or Upgrade contracts should only take ownership of assets
1179         // through the allow + transferFrom flow.
1180         require(_to != address(ethernautsStorage));
1181 
1182         // Contract needs to own asset.
1183         require(_owns(address(this), _tokenId));
1184 
1185         // Reassign ownership, clear pending approvals, emit Transfer event.
1186         _approve(_tokenId, _to);
1187         ethernautsStorage.transfer(address(this), _to, _tokenId);
1188     }
1189 
1190 }