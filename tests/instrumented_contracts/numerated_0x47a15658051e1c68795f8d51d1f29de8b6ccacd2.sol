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
30 // Extend this library for child contracts
31 library SafeMath {
32 
33     /**
34     * @dev Multiplies two numbers, throws on overflow.
35     */
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     /**
46     * @dev Integer division of two numbers, truncating the quotient.
47     */
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         // assert(b > 0); // Solidity automatically throws when dividing by 0
50         uint256 c = a / b;
51         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52         return c;
53     }
54 
55     /**
56     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         assert(b <= a);
60         return a - b;
61     }
62 
63     /**
64     * @dev Adds two numbers, throws on overflow.
65     */
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         assert(c >= a);
69         return c;
70     }
71 
72     /**
73     * @dev Compara two numbers, and return the bigger one.
74     */
75     function max(int256 a, int256 b) internal pure returns (int256) {
76         if (a > b) {
77             return a;
78         } else {
79             return b;
80         }
81     }
82 
83     /**
84     * @dev Compara two numbers, and return the bigger one.
85     */
86     function min(int256 a, int256 b) internal pure returns (int256) {
87         if (a < b) {
88             return a;
89         } else {
90             return b;
91         }
92     }
93 
94 
95 }
96 
97 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
98 contract EthernautsBase {
99 
100     /*** CONSTANTS USED ACROSS CONTRACTS ***/
101 
102     /// @dev Used by all contracts that interfaces with Ethernauts
103     ///      The ERC-165 interface signature for ERC-721.
104     ///  Ref: https://github.com/ethereum/EIPs/issues/165
105     ///  Ref: https://github.com/ethereum/EIPs/issues/721
106     bytes4 constant InterfaceSignature_ERC721 =
107     bytes4(keccak256('name()')) ^
108     bytes4(keccak256('symbol()')) ^
109     bytes4(keccak256('totalSupply()')) ^
110     bytes4(keccak256('balanceOf(address)')) ^
111     bytes4(keccak256('ownerOf(uint256)')) ^
112     bytes4(keccak256('approve(address,uint256)')) ^
113     bytes4(keccak256('transfer(address,uint256)')) ^
114     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
115     bytes4(keccak256('takeOwnership(uint256)')) ^
116     bytes4(keccak256('tokensOfOwner(address)')) ^
117     bytes4(keccak256('tokenMetadata(uint256,string)'));
118 
119     /// @dev due solidity limitation we cannot return dynamic array from methods
120     /// so it creates incompability between functions across different contracts
121     uint8 public constant STATS_SIZE = 10;
122     uint8 public constant SHIP_SLOTS = 5;
123 
124     // Possible state of any asset
125     enum AssetState { Available, UpForLease, Used }
126 
127     // Possible state of any asset
128     // NotValid is to avoid 0 in places where category must be bigger than zero
129     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
130 
131     /// @dev Sector stats
132     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
133     /// @notice Possible attributes for each asset
134     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
135     /// 00000010 - Producible - Product of a factory and/or factory contract.
136     /// 00000100 - Explorable- Product of exploration.
137     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
138     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
139     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
140     /// 01000000 - Tradable - Buyable and sellable on the market.
141     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
142     bytes2 public ATTR_SEEDED     = bytes2(2**0);
143     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
144     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
145     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
146     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
147     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
148     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
149     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
150 }
151 
152 
153 /// @notice This contract manages the various addresses and constraints for operations
154 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
155 contract EthernautsAccessControl is EthernautsBase {
156 
157     // This facet controls access control for Ethernauts.
158     // All roles have same responsibilities and rights, but there is slight differences between them:
159     //
160     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
161     //       It is initially set to the address that created the smart contract.
162     //
163     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
164     //
165     //     - The COO: The COO can change contract address and add create assets.
166     //
167     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
168     /// @param newContract address pointing to new contract
169     event ContractUpgrade(address newContract);
170 
171     // The addresses of the accounts (or contracts) that can execute actions within each roles.
172     address public ceoAddress;
173     address public ctoAddress;
174     address public cooAddress;
175     address public oracleAddress;
176 
177     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
178     bool public paused = false;
179 
180     /// @dev Access modifier for CEO-only functionality
181     modifier onlyCEO() {
182         require(msg.sender == ceoAddress);
183         _;
184     }
185 
186     /// @dev Access modifier for CTO-only functionality
187     modifier onlyCTO() {
188         require(msg.sender == ctoAddress);
189         _;
190     }
191 
192     /// @dev Access modifier for CTO-only functionality
193     modifier onlyOracle() {
194         require(msg.sender == oracleAddress);
195         _;
196     }
197 
198     modifier onlyCLevel() {
199         require(
200             msg.sender == ceoAddress ||
201             msg.sender == ctoAddress ||
202             msg.sender == cooAddress
203         );
204         _;
205     }
206 
207     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
208     /// @param _newCEO The address of the new CEO
209     function setCEO(address _newCEO) external onlyCEO {
210         require(_newCEO != address(0));
211 
212         ceoAddress = _newCEO;
213     }
214 
215     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
216     /// @param _newCTO The address of the new CTO
217     function setCTO(address _newCTO) external {
218         require(
219             msg.sender == ceoAddress ||
220             msg.sender == ctoAddress
221         );
222         require(_newCTO != address(0));
223 
224         ctoAddress = _newCTO;
225     }
226 
227     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
228     /// @param _newCOO The address of the new COO
229     function setCOO(address _newCOO) external {
230         require(
231             msg.sender == ceoAddress ||
232             msg.sender == cooAddress
233         );
234         require(_newCOO != address(0));
235 
236         cooAddress = _newCOO;
237     }
238 
239     /// @dev Assigns a new address to act as oracle.
240     /// @param _newOracle The address of oracle
241     function setOracle(address _newOracle) external {
242         require(msg.sender == ctoAddress);
243         require(_newOracle != address(0));
244 
245         oracleAddress = _newOracle;
246     }
247 
248     /*** Pausable functionality adapted from OpenZeppelin ***/
249 
250     /// @dev Modifier to allow actions only when the contract IS NOT paused
251     modifier whenNotPaused() {
252         require(!paused);
253         _;
254     }
255 
256     /// @dev Modifier to allow actions only when the contract IS paused
257     modifier whenPaused {
258         require(paused);
259         _;
260     }
261 
262     /// @dev Called by any "C-level" role to pause the contract. Used only when
263     ///  a bug or exploit is detected and we need to limit damage.
264     function pause() external onlyCLevel whenNotPaused {
265         paused = true;
266     }
267 
268     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
269     ///  one reason we may pause the contract is when CTO account is compromised.
270     /// @notice This is public rather than external so it can be called by
271     ///  derived contracts.
272     function unpause() public onlyCEO whenPaused {
273         // can't unpause if contract was upgraded
274         paused = false;
275     }
276 
277 }
278 
279 
280 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
281 /// @notice This provides the methods required for basic non-fungible token
282 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
283 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
284 //          reference to logic contracts as Auction, Explore and so on
285 /// @author Ethernatus - Fernando Pauer
286 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
287 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
288 
289     /// @dev Contract holding only data.
290     EthernautsStorage public ethernautsStorage;
291 
292     /*** CONSTANTS ***/
293     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
294     string public constant name = "Ethernauts";
295     string public constant symbol = "ETNT";
296 
297     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
298     /**********************************************************************/
299 
300     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
301 
302     /*** EVENTS ***/
303 
304     // Events as per ERC-721
305     event Transfer(address indexed from, address indexed to, uint256 tokens);
306     event Approval(address indexed owner, address indexed approved, uint256 tokens);
307 
308     /// @dev When a new asset is create it emits build event
309     /// @param owner The address of asset owner
310     /// @param tokenId Asset UniqueID
311     /// @param assetId ID that defines asset look and feel
312     /// @param price asset price
313     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
314 
315     function implementsERC721() public pure returns (bool) {
316         return true;
317     }
318 
319     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
320     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
321     /// @param _interfaceID interface signature ID
322     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
323     {
324         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
325     }
326 
327     /// @dev Checks if a given address is the current owner of a particular Asset.
328     /// @param _claimant the address we are validating against.
329     /// @param _tokenId asset UniqueId, only valid when > 0
330     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
331         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
332     }
333 
334     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
335     /// @param _claimant the address we are confirming asset is approved for.
336     /// @param _tokenId asset UniqueId, only valid when > 0
337     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
338         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
339     }
340 
341     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
342     ///  approval. Setting _approved to address(0) clears all transfer approval.
343     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
344     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
345     ///  there is no value in spamming the log with Approval events in that case.
346     function _approve(uint256 _tokenId, address _approved) internal {
347         ethernautsStorage.approve(_tokenId, _approved);
348     }
349 
350     /// @notice Returns the number of Assets owned by a specific address.
351     /// @param _owner The owner address to check.
352     /// @dev Required for ERC-721 compliance
353     function balanceOf(address _owner) public view returns (uint256 count) {
354         return ethernautsStorage.balanceOf(_owner);
355     }
356 
357     /// @dev Required for ERC-721 compliance.
358     /// @notice Transfers a Asset to another address. If transferring to a smart
359     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
360     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
361     /// @param _to The address of the recipient, can be a user or contract.
362     /// @param _tokenId The ID of the Asset to transfer.
363     function transfer(
364         address _to,
365         uint256 _tokenId
366     )
367     external
368     whenNotPaused
369     {
370         // Safety check to prevent against an unexpected 0x0 default.
371         require(_to != address(0));
372         // Disallow transfers to this contract to prevent accidental misuse.
373         // The contract should never own any assets
374         // (except very briefly after it is created and before it goes on auction).
375         require(_to != address(this));
376         // Disallow transfers to the storage contract to prevent accidental
377         // misuse. Auction or Upgrade contracts should only take ownership of assets
378         // through the allow + transferFrom flow.
379         require(_to != address(ethernautsStorage));
380 
381         // You can only send your own asset.
382         require(_owns(msg.sender, _tokenId));
383 
384         // Reassign ownership, clear pending approvals, emit Transfer event.
385         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
386     }
387 
388     /// @dev Required for ERC-721 compliance.
389     /// @notice Grant another address the right to transfer a specific Asset via
390     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
391     /// @param _to The address to be granted transfer approval. Pass address(0) to
392     ///  clear all approvals.
393     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
394     function approve(
395         address _to,
396         uint256 _tokenId
397     )
398     external
399     whenNotPaused
400     {
401         // Only an owner can grant transfer approval.
402         require(_owns(msg.sender, _tokenId));
403 
404         // Register the approval (replacing any previous approval).
405         _approve(_tokenId, _to);
406 
407         // Emit approval event.
408         Approval(msg.sender, _to, _tokenId);
409     }
410 
411 
412     /// @notice Transfer a Asset owned by another address, for which the calling address
413     ///  has previously been granted transfer approval by the owner.
414     /// @param _from The address that owns the Asset to be transferred.
415     /// @param _to The address that should take ownership of the Asset. Can be any address,
416     ///  including the caller.
417     /// @param _tokenId The ID of the Asset to be transferred.
418     function _transferFrom(
419         address _from,
420         address _to,
421         uint256 _tokenId
422     )
423     internal
424     {
425         // Safety check to prevent against an unexpected 0x0 default.
426         require(_to != address(0));
427         // Disallow transfers to this contract to prevent accidental misuse.
428         // The contract should never own any assets (except for used assets).
429         require(_owns(_from, _tokenId));
430         // Check for approval and valid ownership
431         require(_approvedFor(_to, _tokenId));
432 
433         // Reassign ownership (also clears pending approvals and emits Transfer event).
434         ethernautsStorage.transfer(_from, _to, _tokenId);
435     }
436 
437     /// @dev Required for ERC-721 compliance.
438     /// @notice Transfer a Asset owned by another address, for which the calling address
439     ///  has previously been granted transfer approval by the owner.
440     /// @param _from The address that owns the Asset to be transfered.
441     /// @param _to The address that should take ownership of the Asset. Can be any address,
442     ///  including the caller.
443     /// @param _tokenId The ID of the Asset to be transferred.
444     function transferFrom(
445         address _from,
446         address _to,
447         uint256 _tokenId
448     )
449     external
450     whenNotPaused
451     {
452         _transferFrom(_from, _to, _tokenId);
453     }
454 
455     /// @dev Required for ERC-721 compliance.
456     /// @notice Allow pre-approved user to take ownership of a token
457     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
458     function takeOwnership(uint256 _tokenId) public {
459         address _from = ethernautsStorage.ownerOf(_tokenId);
460 
461         // Safety check to prevent against an unexpected 0x0 default.
462         require(_from != address(0));
463         _transferFrom(_from, msg.sender, _tokenId);
464     }
465 
466     /// @notice Returns the total number of Assets currently in existence.
467     /// @dev Required for ERC-721 compliance.
468     function totalSupply() public view returns (uint256) {
469         return ethernautsStorage.totalSupply();
470     }
471 
472     /// @notice Returns owner of a given Asset(Token).
473     /// @param _tokenId Token ID to get owner.
474     /// @dev Required for ERC-721 compliance.
475     function ownerOf(uint256 _tokenId)
476     external
477     view
478     returns (address owner)
479     {
480         owner = ethernautsStorage.ownerOf(_tokenId);
481 
482         require(owner != address(0));
483     }
484 
485     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
486     /// @param _creatorTokenID The asset who is father of this asset
487     /// @param _price asset price
488     /// @param _assetID asset ID
489     /// @param _category see Asset Struct description
490     /// @param _attributes see Asset Struct description
491     /// @param _stats see Asset Struct description
492     function createNewAsset(
493         uint256 _creatorTokenID,
494         address _owner,
495         uint256 _price,
496         uint16 _assetID,
497         uint8 _category,
498         uint8 _attributes,
499         uint8[STATS_SIZE] _stats
500     )
501     external onlyCLevel
502     returns (uint256)
503     {
504         // owner must be sender
505         require(_owner != address(0));
506 
507         uint256 tokenID = ethernautsStorage.createAsset(
508             _creatorTokenID,
509             _owner,
510             _price,
511             _assetID,
512             _category,
513             uint8(AssetState.Available),
514             _attributes,
515             _stats,
516             0,
517             0
518         );
519 
520         // emit the build event
521         Build(
522             _owner,
523             tokenID,
524             _assetID,
525             _price
526         );
527 
528         return tokenID;
529     }
530 
531     /// @notice verify if token is in exploration time
532     /// @param _tokenId The Token ID that can be upgraded
533     function isExploring(uint256 _tokenId) public view returns (bool) {
534         uint256 cooldown;
535         uint64 cooldownEndBlock;
536         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
537         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
538     }
539 }
540 
541 
542 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
543 /// @author Ethernatus - Fernando Pauer
544 contract EthernautsLogic is EthernautsOwnership {
545 
546     // Set in case the logic contract is broken and an upgrade is required
547     address public newContractAddress;
548 
549     /// @dev Constructor
550     function EthernautsLogic() public {
551         // the creator of the contract is the initial CEO, COO, CTO
552         ceoAddress = msg.sender;
553         ctoAddress = msg.sender;
554         cooAddress = msg.sender;
555         oracleAddress = msg.sender;
556 
557         // Starts paused.
558         paused = true;
559     }
560 
561     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
562     ///  breaking bug. This method does nothing but keep track of the new contract and
563     ///  emit a message indicating that the new address is set. It's up to clients of this
564     ///  contract to update to the new contract address in that case. (This contract will
565     ///  be paused indefinitely if such an upgrade takes place.)
566     /// @param _v2Address new address
567     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
568         // See README.md for updgrade plan
569         newContractAddress = _v2Address;
570         ContractUpgrade(_v2Address);
571     }
572 
573     /// @dev set a new reference to the NFT ownership contract
574     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
575     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
576         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
577         require(candidateContract.isEthernautsStorage());
578         ethernautsStorage = candidateContract;
579     }
580 
581     /// @dev Override unpause so it requires all external contract addresses
582     ///  to be set before contract can be unpaused. Also, we can't have
583     ///  newContractAddress set either, because then the contract was upgraded.
584     /// @notice This is public rather than external so we can call super.unpause
585     ///  without using an expensive CALL.
586     function unpause() public onlyCEO whenPaused {
587         require(ethernautsStorage != address(0));
588         require(newContractAddress == address(0));
589         // require this contract to have access to storage contract
590         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
591 
592         // Actually unpause the contract.
593         super.unpause();
594     }
595 
596     // @dev Allows the COO to capture the balance available to the contract.
597     function withdrawBalances(address _to) public onlyCLevel {
598         _to.transfer(this.balance);
599     }
600 
601     /// return current contract balance
602     function getBalance() public view onlyCLevel returns (uint256) {
603         return this.balance;
604     }
605 }
606 
607 /// @title Storage contract for Ethernauts Data. Common structs and constants.
608 /// @notice This is our main data storage, constants and data types, plus
609 //          internal functions for managing the assets. It is isolated and only interface with
610 //          a list of granted contracts defined by CTO
611 /// @author Ethernauts - Fernando Pauer
612 contract EthernautsStorage is EthernautsAccessControl {
613 
614     function EthernautsStorage() public {
615         // the creator of the contract is the initial CEO
616         ceoAddress = msg.sender;
617 
618         // the creator of the contract is the initial CTO as well
619         ctoAddress = msg.sender;
620 
621         // the creator of the contract is the initial CTO as well
622         cooAddress = msg.sender;
623 
624         // the creator of the contract is the initial Oracle as well
625         oracleAddress = msg.sender;
626     }
627 
628     /// @notice No tipping!
629     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
630     function() external payable {
631         require(msg.sender == address(this));
632     }
633 
634     /*** Mapping for Contracts with granted permission ***/
635     mapping (address => bool) public contractsGrantedAccess;
636 
637     /// @dev grant access for a contract to interact with this contract.
638     /// @param _v2Address The contract address to grant access
639     function grantAccess(address _v2Address) public onlyCTO {
640         // See README.md for updgrade plan
641         contractsGrantedAccess[_v2Address] = true;
642     }
643 
644     /// @dev remove access from a contract to interact with this contract.
645     /// @param _v2Address The contract address to be removed
646     function removeAccess(address _v2Address) public onlyCTO {
647         // See README.md for updgrade plan
648         delete contractsGrantedAccess[_v2Address];
649     }
650 
651     /// @dev Only allow permitted contracts to interact with this contract
652     modifier onlyGrantedContracts() {
653         require(contractsGrantedAccess[msg.sender] == true);
654         _;
655     }
656 
657     modifier validAsset(uint256 _tokenId) {
658         require(assets[_tokenId].ID > 0);
659         _;
660     }
661     /*** DATA TYPES ***/
662 
663     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
664     ///  of this structure. Note that the order of the members in this structure
665     ///  is important because of the byte-packing rules used by Ethereum.
666     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
667     struct Asset {
668 
669         // Asset ID is a identifier for look and feel in frontend
670         uint16 ID;
671 
672         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
673         uint8 category;
674 
675         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
676         uint8 state;
677 
678         // Attributes
679         // byte pos - Definition
680         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
681         // 00000010 - Producible - Product of a factory and/or factory contract.
682         // 00000100 - Explorable- Product of exploration.
683         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
684         // 00010000 - Permanent - Cannot be removed, always owned by a user.
685         // 00100000 - Consumable - Destroyed after N exploration expeditions.
686         // 01000000 - Tradable - Buyable and sellable on the market.
687         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
688         bytes2 attributes;
689 
690         // The timestamp from the block when this asset was created.
691         uint64 createdAt;
692 
693         // The minimum timestamp after which this asset can engage in exploring activities again.
694         uint64 cooldownEndBlock;
695 
696         // The Asset's stats can be upgraded or changed based on exploration conditions.
697         // It will be defined per child contract, but all stats have a range from 0 to 255
698         // Examples
699         // 0 = Ship Level
700         // 1 = Ship Attack
701         uint8[STATS_SIZE] stats;
702 
703         // Set to the cooldown time that represents exploration duration for this asset.
704         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
705         uint256 cooldown;
706 
707         // a reference to a super asset that manufactured the asset
708         uint256 builtBy;
709     }
710 
711     /*** CONSTANTS ***/
712 
713     // @dev Sanity check that allows us to ensure that we are pointing to the
714     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
715     bool public isEthernautsStorage = true;
716 
717     /*** STORAGE ***/
718 
719     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
720     ///  of each asset is actually an index into this array.
721     Asset[] public assets;
722 
723     /// @dev A mapping from Asset UniqueIDs to the price of the token.
724     /// stored outside Asset Struct to save gas, because price can change frequently
725     mapping (uint256 => uint256) internal assetIndexToPrice;
726 
727     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
728     mapping (uint256 => address) internal assetIndexToOwner;
729 
730     // @dev A mapping from owner address to count of tokens that address owns.
731     //  Used internally inside balanceOf() to resolve ownership count.
732     mapping (address => uint256) internal ownershipTokenCount;
733 
734     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
735     ///  transferFrom(). Each Asset can only have one approved address for transfer
736     ///  at any time. A zero value means no approval is outstanding.
737     mapping (uint256 => address) internal assetIndexToApproved;
738 
739 
740     /*** SETTERS ***/
741 
742     /// @dev set new asset price
743     /// @param _tokenId  asset UniqueId
744     /// @param _price    asset price
745     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
746         assetIndexToPrice[_tokenId] = _price;
747     }
748 
749     /// @dev Mark transfer as approved
750     /// @param _tokenId  asset UniqueId
751     /// @param _approved address approved
752     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
753         assetIndexToApproved[_tokenId] = _approved;
754     }
755 
756     /// @dev Assigns ownership of a specific Asset to an address.
757     /// @param _from    current owner address
758     /// @param _to      new owner address
759     /// @param _tokenId asset UniqueId
760     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
761         // Since the number of assets is capped to 2^32 we can't overflow this
762         ownershipTokenCount[_to]++;
763         // transfer ownership
764         assetIndexToOwner[_tokenId] = _to;
765         // When creating new assets _from is 0x0, but we can't account that address.
766         if (_from != address(0)) {
767             ownershipTokenCount[_from]--;
768             // clear any previously approved ownership exchange
769             delete assetIndexToApproved[_tokenId];
770         }
771     }
772 
773     /// @dev A public method that creates a new asset and stores it. This
774     ///  method does basic checking and should only be called from other contract when the
775     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
776     /// @param _creatorTokenID The asset who is father of this asset
777     /// @param _owner First owner of this asset
778     /// @param _price asset price
779     /// @param _ID asset ID
780     /// @param _category see Asset Struct description
781     /// @param _state see Asset Struct description
782     /// @param _attributes see Asset Struct description
783     /// @param _stats see Asset Struct description
784     function createAsset(
785         uint256 _creatorTokenID,
786         address _owner,
787         uint256 _price,
788         uint16 _ID,
789         uint8 _category,
790         uint8 _state,
791         uint8 _attributes,
792         uint8[STATS_SIZE] _stats,
793         uint256 _cooldown,
794         uint64 _cooldownEndBlock
795     )
796     public onlyGrantedContracts
797     returns (uint256)
798     {
799         // Ensure our data structures are always valid.
800         require(_ID > 0);
801         require(_category > 0);
802         require(_attributes != 0x0);
803         require(_stats.length > 0);
804 
805         Asset memory asset = Asset({
806             ID: _ID,
807             category: _category,
808             builtBy: _creatorTokenID,
809             attributes: bytes2(_attributes),
810             stats: _stats,
811             state: _state,
812             createdAt: uint64(now),
813             cooldownEndBlock: _cooldownEndBlock,
814             cooldown: _cooldown
815         });
816 
817         uint256 newAssetUniqueId = assets.push(asset) - 1;
818 
819         // Check it reached 4 billion assets but let's just be 100% sure.
820         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
821 
822         // store price
823         assetIndexToPrice[newAssetUniqueId] = _price;
824 
825         // This will assign ownership
826         transfer(address(0), _owner, newAssetUniqueId);
827 
828         return newAssetUniqueId;
829     }
830 
831     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
832     /// This method doesn't do any checking and should only be called when the
833     ///  input data is known to be valid.
834     /// @param _tokenId The token ID
835     /// @param _creatorTokenID The asset that create that token
836     /// @param _price asset price
837     /// @param _ID asset ID
838     /// @param _category see Asset Struct description
839     /// @param _state see Asset Struct description
840     /// @param _attributes see Asset Struct description
841     /// @param _stats see Asset Struct description
842     /// @param _cooldown asset cooldown index
843     function editAsset(
844         uint256 _tokenId,
845         uint256 _creatorTokenID,
846         uint256 _price,
847         uint16 _ID,
848         uint8 _category,
849         uint8 _state,
850         uint8 _attributes,
851         uint8[STATS_SIZE] _stats,
852         uint16 _cooldown
853     )
854     external validAsset(_tokenId) onlyCLevel
855     returns (uint256)
856     {
857         // Ensure our data structures are always valid.
858         require(_ID > 0);
859         require(_category > 0);
860         require(_attributes != 0x0);
861         require(_stats.length > 0);
862 
863         // store price
864         assetIndexToPrice[_tokenId] = _price;
865 
866         Asset storage asset = assets[_tokenId];
867         asset.ID = _ID;
868         asset.category = _category;
869         asset.builtBy = _creatorTokenID;
870         asset.attributes = bytes2(_attributes);
871         asset.stats = _stats;
872         asset.state = _state;
873         asset.cooldown = _cooldown;
874     }
875 
876     /// @dev Update only stats
877     /// @param _tokenId asset UniqueId
878     /// @param _stats asset state, see Asset Struct description
879     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
880         assets[_tokenId].stats = _stats;
881     }
882 
883     /// @dev Update only asset state
884     /// @param _tokenId asset UniqueId
885     /// @param _state asset state, see Asset Struct description
886     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
887         assets[_tokenId].state = _state;
888     }
889 
890     /// @dev Update Cooldown for a single asset
891     /// @param _tokenId asset UniqueId
892     /// @param _cooldown asset state, see Asset Struct description
893     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
894     public validAsset(_tokenId) onlyGrantedContracts {
895         assets[_tokenId].cooldown = _cooldown;
896         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
897     }
898 
899     /*** GETTERS ***/
900 
901     /// @notice Returns only stats data about a specific asset.
902     /// @dev it is necessary due solidity compiler limitations
903     ///      when we have large qty of parameters it throws StackTooDeepException
904     /// @param _tokenId The UniqueId of the asset of interest.
905     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
906         return assets[_tokenId].stats;
907     }
908 
909     /// @dev return current price of an asset
910     /// @param _tokenId asset UniqueId
911     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
912         return assetIndexToPrice[_tokenId];
913     }
914 
915     /// @notice Check if asset has all attributes passed by parameter
916     /// @param _tokenId The UniqueId of the asset of interest.
917     /// @param _attributes see Asset Struct description
918     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
919         return assets[_tokenId].attributes & _attributes == _attributes;
920     }
921 
922     /// @notice Check if asset has any attribute passed by parameter
923     /// @param _tokenId The UniqueId of the asset of interest.
924     /// @param _attributes see Asset Struct description
925     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
926         return assets[_tokenId].attributes & _attributes != 0x0;
927     }
928 
929     /// @notice Check if asset is in the state passed by parameter
930     /// @param _tokenId The UniqueId of the asset of interest.
931     /// @param _category see AssetCategory in EthernautsBase for possible states
932     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
933         return assets[_tokenId].category == _category;
934     }
935 
936     /// @notice Check if asset is in the state passed by parameter
937     /// @param _tokenId The UniqueId of the asset of interest.
938     /// @param _state see enum AssetState in EthernautsBase for possible states
939     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
940         return assets[_tokenId].state == _state;
941     }
942 
943     /// @notice Returns owner of a given Asset(Token).
944     /// @dev Required for ERC-721 compliance.
945     /// @param _tokenId asset UniqueId
946     function ownerOf(uint256 _tokenId) public view returns (address owner)
947     {
948         return assetIndexToOwner[_tokenId];
949     }
950 
951     /// @dev Required for ERC-721 compliance
952     /// @notice Returns the number of Assets owned by a specific address.
953     /// @param _owner The owner address to check.
954     function balanceOf(address _owner) public view returns (uint256 count) {
955         return ownershipTokenCount[_owner];
956     }
957 
958     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
959     /// @param _tokenId asset UniqueId
960     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
961         return assetIndexToApproved[_tokenId];
962     }
963 
964     /// @notice Returns the total number of Assets currently in existence.
965     /// @dev Required for ERC-721 compliance.
966     function totalSupply() public view returns (uint256) {
967         return assets.length;
968     }
969 
970     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
971     /// @param _owner filter all assets by owner
972     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
973         uint256[6][]
974     ) {
975         uint256 totalAssets = assets.length;
976 
977         if (totalAssets == 0) {
978             // Return an empty array
979             return new uint256[6][](0);
980         } else {
981             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
982             uint256 resultIndex = 0;
983             bytes2 hasAttributes  = bytes2(_withAttributes);
984             Asset memory asset;
985 
986             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
987                 asset = assets[tokenId];
988                 if (
989                     (asset.state != uint8(AssetState.Used)) &&
990                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
991                     (asset.attributes & hasAttributes == hasAttributes)
992                 ) {
993                     result[resultIndex][0] = tokenId;
994                     result[resultIndex][1] = asset.ID;
995                     result[resultIndex][2] = asset.category;
996                     result[resultIndex][3] = uint256(asset.attributes);
997                     result[resultIndex][4] = asset.cooldown;
998                     result[resultIndex][5] = assetIndexToPrice[tokenId];
999                     resultIndex++;
1000                 }
1001             }
1002 
1003             return result;
1004         }
1005     }
1006 }
1007 
1008 
1009 /// @title The facet of the Ethernauts Explore contract that send a ship to explore the deep space.
1010 /// @notice An owned ship can be send on an expedition. Exploration takes time
1011 //          and will always result in “success”. This means the ship can never be destroyed
1012 //          and always returns with a collection of loot. The degree of success is dependent
1013 //          on different factors as sector stats, gamma ray burst number and ship stats.
1014 //          While the ship is exploring it cannot be acted on in any way until the expedition completes.
1015 //          After the ship returns from an expedition the user is then rewarded with a number of objects (assets).
1016 /// @author Ethernatus - Fernando Pauer
1017 contract EthernautsExplore is EthernautsLogic {
1018 
1019     /// @dev Delegate constructor to Nonfungible contract.
1020     function EthernautsExplore() public
1021     EthernautsLogic() {}
1022 
1023     /*** EVENTS ***/
1024     /// emit signal to anyone listening in the universe
1025     event Explore(uint256 indexed shipId, uint256 indexed sectorID, uint256 time);
1026 
1027     event Result(uint256 indexed shipId, uint256 indexed sectorID);
1028 
1029     /*** CONSTANTS ***/
1030 
1031     // An approximation of currently how many seconds are in between blocks.
1032     uint256 public secondsPerBlock = 15;
1033 
1034     uint256 public TICK_TIME = 15; // time is always in minutes
1035 
1036     // exploration fee
1037     uint256 public percentageCut  = 90;
1038     uint256 public oracleFee      = 2000000; // wei
1039     uint256 public sectorOwnerCut = 0.01 ether;
1040 
1041     int256 public SPEED_STAT_MAX = 30;
1042     int256 public RANGE_STAT_MAX = 20;
1043     int256 public MIN_TIME_EXPLORE = 60;
1044     int256 public MAX_TIME_EXPLORE = 2160;
1045     int256 public RANGE_SCALE = 2;
1046 
1047     /// @dev Sector stats
1048     enum SectorStats {Volume, Threat, Difficulty}
1049 
1050     /// @dev hold all ships in exploration
1051     uint256[] explorers;
1052 
1053     /// @dev A mapping from Asset UniqueIDs to the exploration index.
1054     mapping (uint256 => uint256) internal tokenIndexToExplore;
1055 
1056     /// @dev A mapping from Asset UniqueIDs to the sector token id.
1057     mapping (uint256 => uint256) internal tokenIndexToSector;
1058 
1059     /// @dev Get a list of ship exploring our universe
1060     function getExplorerList() public view returns(
1061         uint256[4][]
1062     ) {
1063         uint256[4][] memory tokens = new uint256[4][](explorers.length);
1064         uint256 index = 0;
1065         uint16 ID;
1066         uint8 state;
1067 
1068         for(uint256 i = 0; i < explorers.length; i++) {
1069             if (explorers[i] != 0) {
1070                 (ID,,state,,,,,) = ethernautsStorage.assets(explorers[i]);
1071                 tokens[index][0] = explorers[i];
1072                 tokens[index][1] = ID;
1073                 tokens[index][2] = state;
1074                 tokens[index][3] = tokenIndexToSector[explorers[i]];
1075 
1076                 index++;
1077             }
1078         }
1079 
1080         if (index == 0) {
1081             // Return an empty array
1082             return new uint256[4][](0);
1083         } else {
1084             return tokens;
1085         }
1086     }
1087 
1088     function setTickTime(uint256 _tickTime) external onlyCLevel {
1089         TICK_TIME = _tickTime;
1090     }
1091 
1092     function setSectorOwnerCut(uint256 _sectorOwnerCut) external onlyCLevel {
1093         sectorOwnerCut = _sectorOwnerCut;
1094     }
1095 
1096     function setOracleFee(uint256 _oracleFee) external onlyCLevel {
1097         oracleFee = _oracleFee;
1098     }
1099 
1100     function setPercentageCut(uint256 _percentageCut) external onlyCLevel {
1101         percentageCut = _percentageCut;
1102     }
1103 
1104 
1105     /// @notice Explore a sector with a defined ship. Sectors contain a list of Objects that can be given to the players
1106     /// when exploring. Each entry has a Drop Rate and are sorted by Sector ID and Drop rate.
1107     /// The drop rate is a whole number between 0 and 1,000,000. 0 is 0% and 1,000,000 is 100%.
1108     /// Every time a Sector is explored a random number between 0 and 1,000,000 is calculated for each available Object.
1109     /// If the final result is lower than the Drop Rate of the Object, that Object will be rewarded to the player once
1110     /// Exploration is complete. Only 1 to 5 Objects maximum can be dropped during one exploration.
1111     /// (FUTURE VERSIONS) The final number will be affected by the user’s Ship Stats.
1112     /// @param _shipTokenId The Token ID that represents a ship and can explore
1113     /// @param _sectorTokenId The Token ID that represents a sector and can be explored
1114     function explore(uint256 _shipTokenId, uint256 _sectorTokenId) payable external whenNotPaused {
1115         // charge a fee for each exploration when the results are ready
1116         require(msg.value >= sectorOwnerCut);
1117 
1118         // check if Asset is a ship or not
1119         require(ethernautsStorage.isCategory(_shipTokenId, uint8(AssetCategory.Ship)));
1120 
1121         // check if _sectorTokenId is a sector or not
1122         require(ethernautsStorage.isCategory(_sectorTokenId, uint8(AssetCategory.Sector)));
1123 
1124         // Ensure the Ship is in available state, otherwise it cannot explore
1125         require(ethernautsStorage.isState(_shipTokenId, uint8(AssetState.Available)));
1126 
1127         // ship could not be in exploration
1128         require(!isExploring(_shipTokenId));
1129 
1130         // check if explorer is ship owner
1131         require(msg.sender == ethernautsStorage.ownerOf(_shipTokenId));
1132 
1133         // check if owner sector is not empty
1134         address sectorOwner = ethernautsStorage.ownerOf(_sectorTokenId);
1135         require(sectorOwner != address(0));
1136 
1137         /// mark as exploring
1138         tokenIndexToExplore[_shipTokenId] = explorers.push(_shipTokenId) - 1;
1139         tokenIndexToSector[_shipTokenId] = _sectorTokenId;
1140 
1141         uint8[STATS_SIZE] memory _shipStats = ethernautsStorage.getStats(_shipTokenId);
1142         uint8[STATS_SIZE] memory _sectorStats = ethernautsStorage.getStats(_sectorTokenId);
1143 
1144         /// set exploration time
1145         uint256 time = uint256(_explorationTime(
1146                 _shipStats[uint256(ShipStats.Range)],
1147                 _shipStats[uint256(ShipStats.Speed)],
1148                 _sectorStats[uint256(SectorStats.Volume)]
1149             ));
1150         // exploration time in minutes converted to seconds
1151         time *= 60;
1152 
1153         uint64 _cooldownEndBlock = uint64((time/secondsPerBlock) + block.number);
1154         ethernautsStorage.setAssetCooldown(_shipTokenId, now + time, _cooldownEndBlock);
1155 
1156         // to avoid mistakes and charge unnecessary extra fees
1157         uint256 feeExcess = SafeMath.sub(msg.value, sectorOwnerCut);
1158         uint256 payment = uint256(SafeMath.div(SafeMath.mul(msg.value, percentageCut), 100)) - oracleFee;
1159 
1160         /// emit signal to anyone listening in the universe
1161         Explore(_shipTokenId, _sectorTokenId, now + time);
1162 
1163         // keeping oracle accounts with balance
1164         oracleAddress.transfer(oracleFee);
1165 
1166         // paying sector owner
1167         sectorOwner.transfer(payment);
1168 
1169         // send excess back to explorer
1170         msg.sender.transfer(feeExcess);
1171     }
1172 
1173     /// @notice Exploration is complete and 5 Objects maximum will be dropped during one exploration.
1174     /// @param _shipTokenId The Token ID that represents a ship and can explore
1175     /// @param _sectorTokenId The Token ID that represents a sector and can be explored
1176     /// @param _IDs that represents a object returned from exploration
1177     /// @param _attributes that represents attributes for each object returned from exploration
1178     /// @param _stats that represents all stats for each object returned from exploration
1179     function explorationResults(
1180         uint256 _shipTokenId,
1181         uint256 _sectorTokenId,
1182         uint16[5] _IDs,
1183         uint8[5] _attributes,
1184         uint8[STATS_SIZE][5] _stats
1185     )
1186     external onlyOracle
1187     {
1188         uint256 cooldown;
1189         uint64 cooldownEndBlock;
1190         uint256 builtBy;
1191         (,,,,,cooldownEndBlock, cooldown, builtBy) = ethernautsStorage.assets(_shipTokenId);
1192 
1193         address owner = ethernautsStorage.ownerOf(_shipTokenId);
1194         require(owner != address(0));
1195 
1196         /// create objects returned from exploration
1197         for (uint256 i = 0; i < 5; i++) {
1198             _buildAsset(
1199                 _sectorTokenId,
1200                 owner,
1201                 0,
1202                 _IDs[i],
1203                 uint8(AssetCategory.Object),
1204                 uint8(_attributes[i]),
1205                 _stats[i],
1206                 cooldown,
1207                 cooldownEndBlock
1208             );
1209         }
1210 
1211         /// remove from explore list
1212         delete explorers[tokenIndexToExplore[_shipTokenId]];
1213         delete tokenIndexToSector[_shipTokenId];
1214 
1215         /// emit signal to anyone listening in the universe
1216         Result(_shipTokenId, _sectorTokenId);
1217     }
1218 
1219     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
1220     /// @param _creatorTokenID The asset who is father of this asset
1221     /// @param _price asset price
1222     /// @param _assetID asset ID
1223     /// @param _category see Asset Struct description
1224     /// @param _attributes see Asset Struct description
1225     /// @param _stats see Asset Struct description
1226     /// @param _cooldown see Asset Struct description
1227     /// @param _cooldownEndBlock see Asset Struct description
1228     function _buildAsset(
1229         uint256 _creatorTokenID,
1230         address _owner,
1231         uint256 _price,
1232         uint16 _assetID,
1233         uint8 _category,
1234         uint8 _attributes,
1235         uint8[STATS_SIZE] _stats,
1236         uint256 _cooldown,
1237         uint64 _cooldownEndBlock
1238     )
1239     private returns (uint256)
1240     {
1241         uint256 tokenID = ethernautsStorage.createAsset(
1242             _creatorTokenID,
1243             _owner,
1244             _price,
1245             _assetID,
1246             _category,
1247             uint8(AssetState.Available),
1248             _attributes,
1249             _stats,
1250             _cooldown,
1251             _cooldownEndBlock
1252         );
1253 
1254         // emit the build event
1255         Build(
1256             _owner,
1257             tokenID,
1258             _assetID,
1259             _price
1260         );
1261 
1262         return tokenID;
1263     }
1264 
1265     /// @notice Exploration Time: The time it takes to explore a Sector is dependent on the Sector Volume
1266     ///         along with the Ship’s Range and Speed.
1267     /// @param _shipRange ship range
1268     /// @param _shipSpeed ship speed
1269     /// @param _sectorVolume sector volume
1270     function _explorationTime(
1271         uint8 _shipRange,
1272         uint8 _shipSpeed,
1273         uint8 _sectorVolume
1274     ) private view returns (int256) {
1275         int256 minToExplore = 0;
1276 
1277         minToExplore = SafeMath.min(_shipSpeed, SPEED_STAT_MAX) - 1;
1278         minToExplore = -72 * minToExplore;
1279         minToExplore += MAX_TIME_EXPLORE;
1280 
1281         uint256 minRange = uint256(SafeMath.min(_shipRange, RANGE_STAT_MAX));
1282         uint256 scaledRange = uint256(RANGE_STAT_MAX * RANGE_SCALE);
1283         int256 minExplore = (minToExplore - MIN_TIME_EXPLORE);
1284 
1285         minToExplore -= fraction(minExplore, int256(minRange), int256(scaledRange));
1286         minToExplore += fraction(minToExplore, (_sectorVolume - 10), 10);
1287         minToExplore = SafeMath.max(minToExplore, MIN_TIME_EXPLORE);
1288 
1289         return minToExplore;
1290     }
1291 
1292     /// @notice calcs a perc without float or double :(
1293     function fraction(int256 _subject, int256 _numerator, int256 _denominator)
1294     private pure returns (int256) {
1295         int256 division = _subject * _numerator - _subject * _denominator;
1296         int256 total = _subject * _denominator + division;
1297         return total / _denominator;
1298     }
1299 
1300     /// @notice Any C-level can fix how many seconds per blocks are currently observed.
1301     /// @param _secs The seconds per block
1302     function setSecondsPerBlock(uint256 _secs) external onlyCLevel {
1303         require(_secs > 0);
1304         secondsPerBlock = _secs;
1305     }
1306 }