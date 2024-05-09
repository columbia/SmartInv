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
33 // Extend this library for child contracts
34 library SafeMath {
35 
36     /**
37     * @dev Multiplies two numbers, throws on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         assert(c / a == b);
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers, truncating the quotient.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // assert(b > 0); // Solidity automatically throws when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55         return c;
56     }
57 
58     /**
59     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         assert(b <= a);
63         return a - b;
64     }
65 
66     /**
67     * @dev Adds two numbers, throws on overflow.
68     */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 
75     /**
76     * @dev Compara two numbers, and return the bigger one.
77     */
78     function max(int256 a, int256 b) internal pure returns (int256) {
79         if (a > b) {
80             return a;
81         } else {
82             return b;
83         }
84     }
85 
86     /**
87     * @dev Compara two numbers, and return the bigger one.
88     */
89     function min(int256 a, int256 b) internal pure returns (int256) {
90         if (a < b) {
91             return a;
92         } else {
93             return b;
94         }
95     }
96 
97 
98 }
99 
100 
101 
102 
103 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
104 contract EthernautsBase {
105 
106     /*** CONSTANTS USED ACROSS CONTRACTS ***/
107 
108     /// @dev Used by all contracts that interfaces with Ethernauts
109     ///      The ERC-165 interface signature for ERC-721.
110     ///  Ref: https://github.com/ethereum/EIPs/issues/165
111     ///  Ref: https://github.com/ethereum/EIPs/issues/721
112     bytes4 constant InterfaceSignature_ERC721 =
113     bytes4(keccak256('name()')) ^
114     bytes4(keccak256('symbol()')) ^
115     bytes4(keccak256('totalSupply()')) ^
116     bytes4(keccak256('balanceOf(address)')) ^
117     bytes4(keccak256('ownerOf(uint256)')) ^
118     bytes4(keccak256('approve(address,uint256)')) ^
119     bytes4(keccak256('transfer(address,uint256)')) ^
120     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
121     bytes4(keccak256('takeOwnership(uint256)')) ^
122     bytes4(keccak256('tokensOfOwner(address)')) ^
123     bytes4(keccak256('tokenMetadata(uint256,string)'));
124 
125     /// @dev due solidity limitation we cannot return dynamic array from methods
126     /// so it creates incompability between functions across different contracts
127     uint8 public constant STATS_SIZE = 10;
128     uint8 public constant SHIP_SLOTS = 5;
129 
130     // Possible state of any asset
131     enum AssetState { Available, UpForLease, Used }
132 
133     // Possible state of any asset
134     // NotValid is to avoid 0 in places where category must be bigger than zero
135     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
136 
137     /// @dev Sector stats
138     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
139     /// @notice Possible attributes for each asset
140     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
141     /// 00000010 - Producible - Product of a factory and/or factory contract.
142     /// 00000100 - Explorable- Product of exploration.
143     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
144     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
145     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
146     /// 01000000 - Tradable - Buyable and sellable on the market.
147     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
148     bytes2 public ATTR_SEEDED     = bytes2(2**0);
149     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
150     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
151     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
152     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
153     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
154     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
155     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
156 }
157 
158 /// @notice This contract manages the various addresses and constraints for operations
159 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
160 contract EthernautsAccessControl is EthernautsBase {
161 
162     // This facet controls access control for Ethernauts.
163     // All roles have same responsibilities and rights, but there is slight differences between them:
164     //
165     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
166     //       It is initially set to the address that created the smart contract.
167     //
168     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
169     //
170     //     - The COO: The COO can change contract address and add create assets.
171     //
172     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
173     /// @param newContract address pointing to new contract
174     event ContractUpgrade(address newContract);
175 
176     // The addresses of the accounts (or contracts) that can execute actions within each roles.
177     address public ceoAddress;
178     address public ctoAddress;
179     address public cooAddress;
180     address public oracleAddress;
181 
182     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
183     bool public paused = false;
184 
185     /// @dev Access modifier for CEO-only functionality
186     modifier onlyCEO() {
187         require(msg.sender == ceoAddress);
188         _;
189     }
190 
191     /// @dev Access modifier for CTO-only functionality
192     modifier onlyCTO() {
193         require(msg.sender == ctoAddress);
194         _;
195     }
196 
197     /// @dev Access modifier for CTO-only functionality
198     modifier onlyOracle() {
199         require(msg.sender == oracleAddress);
200         _;
201     }
202 
203     modifier onlyCLevel() {
204         require(
205             msg.sender == ceoAddress ||
206             msg.sender == ctoAddress ||
207             msg.sender == cooAddress
208         );
209         _;
210     }
211 
212     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
213     /// @param _newCEO The address of the new CEO
214     function setCEO(address _newCEO) external onlyCEO {
215         require(_newCEO != address(0));
216 
217         ceoAddress = _newCEO;
218     }
219 
220     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
221     /// @param _newCTO The address of the new CTO
222     function setCTO(address _newCTO) external {
223         require(
224             msg.sender == ceoAddress ||
225             msg.sender == ctoAddress
226         );
227         require(_newCTO != address(0));
228 
229         ctoAddress = _newCTO;
230     }
231 
232     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
233     /// @param _newCOO The address of the new COO
234     function setCOO(address _newCOO) external {
235         require(
236             msg.sender == ceoAddress ||
237             msg.sender == cooAddress
238         );
239         require(_newCOO != address(0));
240 
241         cooAddress = _newCOO;
242     }
243 
244     /// @dev Assigns a new address to act as oracle.
245     /// @param _newOracle The address of oracle
246     function setOracle(address _newOracle) external {
247         require(msg.sender == ctoAddress);
248         require(_newOracle != address(0));
249 
250         oracleAddress = _newOracle;
251     }
252 
253     /*** Pausable functionality adapted from OpenZeppelin ***/
254 
255     /// @dev Modifier to allow actions only when the contract IS NOT paused
256     modifier whenNotPaused() {
257         require(!paused);
258         _;
259     }
260 
261     /// @dev Modifier to allow actions only when the contract IS paused
262     modifier whenPaused {
263         require(paused);
264         _;
265     }
266 
267     /// @dev Called by any "C-level" role to pause the contract. Used only when
268     ///  a bug or exploit is detected and we need to limit damage.
269     function pause() external onlyCLevel whenNotPaused {
270         paused = true;
271     }
272 
273     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
274     ///  one reason we may pause the contract is when CTO account is compromised.
275     /// @notice This is public rather than external so it can be called by
276     ///  derived contracts.
277     function unpause() public onlyCEO whenPaused {
278         // can't unpause if contract was upgraded
279         paused = false;
280     }
281 
282 }
283 
284 
285 
286 
287 
288 
289 
290 
291 
292 /// @title Storage contract for Ethernauts Data. Common structs and constants.
293 /// @notice This is our main data storage, constants and data types, plus
294 //          internal functions for managing the assets. It is isolated and only interface with
295 //          a list of granted contracts defined by CTO
296 /// @author Ethernauts - Fernando Pauer
297 contract EthernautsStorage is EthernautsAccessControl {
298 
299     function EthernautsStorage() public {
300         // the creator of the contract is the initial CEO
301         ceoAddress = msg.sender;
302 
303         // the creator of the contract is the initial CTO as well
304         ctoAddress = msg.sender;
305 
306         // the creator of the contract is the initial CTO as well
307         cooAddress = msg.sender;
308 
309         // the creator of the contract is the initial Oracle as well
310         oracleAddress = msg.sender;
311     }
312 
313     /// @notice No tipping!
314     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
315     function() external payable {
316         require(msg.sender == address(this));
317     }
318 
319     /*** Mapping for Contracts with granted permission ***/
320     mapping (address => bool) public contractsGrantedAccess;
321 
322     /// @dev grant access for a contract to interact with this contract.
323     /// @param _v2Address The contract address to grant access
324     function grantAccess(address _v2Address) public onlyCTO {
325         // See README.md for updgrade plan
326         contractsGrantedAccess[_v2Address] = true;
327     }
328 
329     /// @dev remove access from a contract to interact with this contract.
330     /// @param _v2Address The contract address to be removed
331     function removeAccess(address _v2Address) public onlyCTO {
332         // See README.md for updgrade plan
333         delete contractsGrantedAccess[_v2Address];
334     }
335 
336     /// @dev Only allow permitted contracts to interact with this contract
337     modifier onlyGrantedContracts() {
338         require(contractsGrantedAccess[msg.sender] == true);
339         _;
340     }
341 
342     modifier validAsset(uint256 _tokenId) {
343         require(assets[_tokenId].ID > 0);
344         _;
345     }
346     /*** DATA TYPES ***/
347 
348     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
349     ///  of this structure. Note that the order of the members in this structure
350     ///  is important because of the byte-packing rules used by Ethereum.
351     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
352     struct Asset {
353 
354         // Asset ID is a identifier for look and feel in frontend
355         uint16 ID;
356 
357         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
358         uint8 category;
359 
360         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
361         uint8 state;
362 
363         // Attributes
364         // byte pos - Definition
365         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
366         // 00000010 - Producible - Product of a factory and/or factory contract.
367         // 00000100 - Explorable- Product of exploration.
368         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
369         // 00010000 - Permanent - Cannot be removed, always owned by a user.
370         // 00100000 - Consumable - Destroyed after N exploration expeditions.
371         // 01000000 - Tradable - Buyable and sellable on the market.
372         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
373         bytes2 attributes;
374 
375         // The timestamp from the block when this asset was created.
376         uint64 createdAt;
377 
378         // The minimum timestamp after which this asset can engage in exploring activities again.
379         uint64 cooldownEndBlock;
380 
381         // The Asset's stats can be upgraded or changed based on exploration conditions.
382         // It will be defined per child contract, but all stats have a range from 0 to 255
383         // Examples
384         // 0 = Ship Level
385         // 1 = Ship Attack
386         uint8[STATS_SIZE] stats;
387 
388         // Set to the cooldown time that represents exploration duration for this asset.
389         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
390         uint256 cooldown;
391 
392         // a reference to a super asset that manufactured the asset
393         uint256 builtBy;
394     }
395 
396     /*** CONSTANTS ***/
397 
398     // @dev Sanity check that allows us to ensure that we are pointing to the
399     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
400     bool public isEthernautsStorage = true;
401 
402     /*** STORAGE ***/
403 
404     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
405     ///  of each asset is actually an index into this array.
406     Asset[] public assets;
407 
408     /// @dev A mapping from Asset UniqueIDs to the price of the token.
409     /// stored outside Asset Struct to save gas, because price can change frequently
410     mapping (uint256 => uint256) internal assetIndexToPrice;
411 
412     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
413     mapping (uint256 => address) internal assetIndexToOwner;
414 
415     // @dev A mapping from owner address to count of tokens that address owns.
416     //  Used internally inside balanceOf() to resolve ownership count.
417     mapping (address => uint256) internal ownershipTokenCount;
418 
419     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
420     ///  transferFrom(). Each Asset can only have one approved address for transfer
421     ///  at any time. A zero value means no approval is outstanding.
422     mapping (uint256 => address) internal assetIndexToApproved;
423 
424 
425     /*** SETTERS ***/
426 
427     /// @dev set new asset price
428     /// @param _tokenId  asset UniqueId
429     /// @param _price    asset price
430     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
431         assetIndexToPrice[_tokenId] = _price;
432     }
433 
434     /// @dev Mark transfer as approved
435     /// @param _tokenId  asset UniqueId
436     /// @param _approved address approved
437     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
438         assetIndexToApproved[_tokenId] = _approved;
439     }
440 
441     /// @dev Assigns ownership of a specific Asset to an address.
442     /// @param _from    current owner address
443     /// @param _to      new owner address
444     /// @param _tokenId asset UniqueId
445     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
446         // Since the number of assets is capped to 2^32 we can't overflow this
447         ownershipTokenCount[_to]++;
448         // transfer ownership
449         assetIndexToOwner[_tokenId] = _to;
450         // When creating new assets _from is 0x0, but we can't account that address.
451         if (_from != address(0)) {
452             ownershipTokenCount[_from]--;
453             // clear any previously approved ownership exchange
454             delete assetIndexToApproved[_tokenId];
455         }
456     }
457 
458     /// @dev A public method that creates a new asset and stores it. This
459     ///  method does basic checking and should only be called from other contract when the
460     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
461     /// @param _creatorTokenID The asset who is father of this asset
462     /// @param _owner First owner of this asset
463     /// @param _price asset price
464     /// @param _ID asset ID
465     /// @param _category see Asset Struct description
466     /// @param _state see Asset Struct description
467     /// @param _attributes see Asset Struct description
468     /// @param _stats see Asset Struct description
469     function createAsset(
470         uint256 _creatorTokenID,
471         address _owner,
472         uint256 _price,
473         uint16 _ID,
474         uint8 _category,
475         uint8 _state,
476         uint8 _attributes,
477         uint8[STATS_SIZE] _stats,
478         uint256 _cooldown,
479         uint64 _cooldownEndBlock
480     )
481     public onlyGrantedContracts
482     returns (uint256)
483     {
484         // Ensure our data structures are always valid.
485         require(_ID > 0);
486         require(_category > 0);
487         require(_attributes != 0x0);
488         require(_stats.length > 0);
489 
490         Asset memory asset = Asset({
491             ID: _ID,
492             category: _category,
493             builtBy: _creatorTokenID,
494             attributes: bytes2(_attributes),
495             stats: _stats,
496             state: _state,
497             createdAt: uint64(now),
498             cooldownEndBlock: _cooldownEndBlock,
499             cooldown: _cooldown
500             });
501 
502         uint256 newAssetUniqueId = assets.push(asset) - 1;
503 
504         // Check it reached 4 billion assets but let's just be 100% sure.
505         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
506 
507         // store price
508         assetIndexToPrice[newAssetUniqueId] = _price;
509 
510         // This will assign ownership
511         transfer(address(0), _owner, newAssetUniqueId);
512 
513         return newAssetUniqueId;
514     }
515 
516     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
517     /// This method doesn't do any checking and should only be called when the
518     ///  input data is known to be valid.
519     /// @param _tokenId The token ID
520     /// @param _creatorTokenID The asset that create that token
521     /// @param _price asset price
522     /// @param _ID asset ID
523     /// @param _category see Asset Struct description
524     /// @param _state see Asset Struct description
525     /// @param _attributes see Asset Struct description
526     /// @param _stats see Asset Struct description
527     /// @param _cooldown asset cooldown index
528     function editAsset(
529         uint256 _tokenId,
530         uint256 _creatorTokenID,
531         uint256 _price,
532         uint16 _ID,
533         uint8 _category,
534         uint8 _state,
535         uint8 _attributes,
536         uint8[STATS_SIZE] _stats,
537         uint16 _cooldown
538     )
539     external validAsset(_tokenId) onlyCLevel
540     returns (uint256)
541     {
542         // Ensure our data structures are always valid.
543         require(_ID > 0);
544         require(_category > 0);
545         require(_attributes != 0x0);
546         require(_stats.length > 0);
547 
548         // store price
549         assetIndexToPrice[_tokenId] = _price;
550 
551         Asset storage asset = assets[_tokenId];
552         asset.ID = _ID;
553         asset.category = _category;
554         asset.builtBy = _creatorTokenID;
555         asset.attributes = bytes2(_attributes);
556         asset.stats = _stats;
557         asset.state = _state;
558         asset.cooldown = _cooldown;
559     }
560 
561     /// @dev Update only stats
562     /// @param _tokenId asset UniqueId
563     /// @param _stats asset state, see Asset Struct description
564     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
565         assets[_tokenId].stats = _stats;
566     }
567 
568     /// @dev Update only asset state
569     /// @param _tokenId asset UniqueId
570     /// @param _state asset state, see Asset Struct description
571     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
572         assets[_tokenId].state = _state;
573     }
574 
575     /// @dev Update Cooldown for a single asset
576     /// @param _tokenId asset UniqueId
577     /// @param _cooldown asset state, see Asset Struct description
578     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
579     public validAsset(_tokenId) onlyGrantedContracts {
580         assets[_tokenId].cooldown = _cooldown;
581         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
582     }
583 
584     /*** GETTERS ***/
585 
586     /// @notice Returns only stats data about a specific asset.
587     /// @dev it is necessary due solidity compiler limitations
588     ///      when we have large qty of parameters it throws StackTooDeepException
589     /// @param _tokenId The UniqueId of the asset of interest.
590     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
591         return assets[_tokenId].stats;
592     }
593 
594     /// @dev return current price of an asset
595     /// @param _tokenId asset UniqueId
596     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
597         return assetIndexToPrice[_tokenId];
598     }
599 
600     /// @notice Check if asset has all attributes passed by parameter
601     /// @param _tokenId The UniqueId of the asset of interest.
602     /// @param _attributes see Asset Struct description
603     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
604         return assets[_tokenId].attributes & _attributes == _attributes;
605     }
606 
607     /// @notice Check if asset has any attribute passed by parameter
608     /// @param _tokenId The UniqueId of the asset of interest.
609     /// @param _attributes see Asset Struct description
610     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
611         return assets[_tokenId].attributes & _attributes != 0x0;
612     }
613 
614     /// @notice Check if asset is in the state passed by parameter
615     /// @param _tokenId The UniqueId of the asset of interest.
616     /// @param _category see AssetCategory in EthernautsBase for possible states
617     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
618         return assets[_tokenId].category == _category;
619     }
620 
621     /// @notice Check if asset is in the state passed by parameter
622     /// @param _tokenId The UniqueId of the asset of interest.
623     /// @param _state see enum AssetState in EthernautsBase for possible states
624     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
625         return assets[_tokenId].state == _state;
626     }
627 
628     /// @notice Returns owner of a given Asset(Token).
629     /// @dev Required for ERC-721 compliance.
630     /// @param _tokenId asset UniqueId
631     function ownerOf(uint256 _tokenId) public view returns (address owner)
632     {
633         return assetIndexToOwner[_tokenId];
634     }
635 
636     /// @dev Required for ERC-721 compliance
637     /// @notice Returns the number of Assets owned by a specific address.
638     /// @param _owner The owner address to check.
639     function balanceOf(address _owner) public view returns (uint256 count) {
640         return ownershipTokenCount[_owner];
641     }
642 
643     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
644     /// @param _tokenId asset UniqueId
645     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
646         return assetIndexToApproved[_tokenId];
647     }
648 
649     /// @notice Returns the total number of Assets currently in existence.
650     /// @dev Required for ERC-721 compliance.
651     function totalSupply() public view returns (uint256) {
652         return assets.length;
653     }
654 
655     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
656     /// @param _owner filter all assets by owner
657     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
658         uint256[6][]
659     ) {
660         uint256 totalAssets = assets.length;
661 
662         if (totalAssets == 0) {
663             // Return an empty array
664             return new uint256[6][](0);
665         } else {
666             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
667             uint256 resultIndex = 0;
668             bytes2 hasAttributes  = bytes2(_withAttributes);
669             Asset memory asset;
670 
671             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
672                 asset = assets[tokenId];
673                 if (
674                     (asset.state != uint8(AssetState.Used)) &&
675                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
676                     (asset.attributes & hasAttributes == hasAttributes)
677                 ) {
678                     result[resultIndex][0] = tokenId;
679                     result[resultIndex][1] = asset.ID;
680                     result[resultIndex][2] = asset.category;
681                     result[resultIndex][3] = uint256(asset.attributes);
682                     result[resultIndex][4] = asset.cooldown;
683                     result[resultIndex][5] = assetIndexToPrice[tokenId];
684                     resultIndex++;
685                 }
686             }
687 
688             return result;
689         }
690     }
691 }
692 
693 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
694 /// @notice This provides the methods required for basic non-fungible token
695 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
696 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
697 //          reference to logic contracts as Auction, Explore and so on
698 /// @author Ethernatus - Fernando Pauer
699 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
700 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
701 
702     /// @dev Contract holding only data.
703     EthernautsStorage public ethernautsStorage;
704 
705     /*** CONSTANTS ***/
706     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
707     string public constant name = "Ethernauts";
708     string public constant symbol = "ETNT";
709 
710     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
711     /**********************************************************************/
712 
713     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
714 
715     /*** EVENTS ***/
716 
717     // Events as per ERC-721
718     event Transfer(address indexed from, address indexed to, uint256 tokens);
719     event Approval(address indexed owner, address indexed approved, uint256 tokens);
720 
721     /// @dev When a new asset is create it emits build event
722     /// @param owner The address of asset owner
723     /// @param tokenId Asset UniqueID
724     /// @param assetId ID that defines asset look and feel
725     /// @param price asset price
726     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
727 
728     function implementsERC721() public pure returns (bool) {
729         return true;
730     }
731 
732     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
733     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
734     /// @param _interfaceID interface signature ID
735     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
736     {
737         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
738     }
739 
740     /// @dev Checks if a given address is the current owner of a particular Asset.
741     /// @param _claimant the address we are validating against.
742     /// @param _tokenId asset UniqueId, only valid when > 0
743     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
744         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
745     }
746 
747     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
748     /// @param _claimant the address we are confirming asset is approved for.
749     /// @param _tokenId asset UniqueId, only valid when > 0
750     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
751         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
752     }
753 
754     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
755     ///  approval. Setting _approved to address(0) clears all transfer approval.
756     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
757     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
758     ///  there is no value in spamming the log with Approval events in that case.
759     function _approve(uint256 _tokenId, address _approved) internal {
760         ethernautsStorage.approve(_tokenId, _approved);
761     }
762 
763     /// @notice Returns the number of Assets owned by a specific address.
764     /// @param _owner The owner address to check.
765     /// @dev Required for ERC-721 compliance
766     function balanceOf(address _owner) public view returns (uint256 count) {
767         return ethernautsStorage.balanceOf(_owner);
768     }
769 
770     /// @dev Required for ERC-721 compliance.
771     /// @notice Transfers a Asset to another address. If transferring to a smart
772     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
773     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
774     /// @param _to The address of the recipient, can be a user or contract.
775     /// @param _tokenId The ID of the Asset to transfer.
776     function transfer(
777         address _to,
778         uint256 _tokenId
779     )
780     external
781     whenNotPaused
782     {
783         // Safety check to prevent against an unexpected 0x0 default.
784         require(_to != address(0));
785         // Disallow transfers to this contract to prevent accidental misuse.
786         // The contract should never own any assets
787         // (except very briefly after it is created and before it goes on auction).
788         require(_to != address(this));
789         // Disallow transfers to the storage contract to prevent accidental
790         // misuse. Auction or Upgrade contracts should only take ownership of assets
791         // through the allow + transferFrom flow.
792         require(_to != address(ethernautsStorage));
793 
794         // You can only send your own asset.
795         require(_owns(msg.sender, _tokenId));
796 
797         // Reassign ownership, clear pending approvals, emit Transfer event.
798         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
799     }
800 
801     /// @dev Required for ERC-721 compliance.
802     /// @notice Grant another address the right to transfer a specific Asset via
803     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
804     /// @param _to The address to be granted transfer approval. Pass address(0) to
805     ///  clear all approvals.
806     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
807     function approve(
808         address _to,
809         uint256 _tokenId
810     )
811     external
812     whenNotPaused
813     {
814         // Only an owner can grant transfer approval.
815         require(_owns(msg.sender, _tokenId));
816 
817         // Register the approval (replacing any previous approval).
818         _approve(_tokenId, _to);
819 
820         // Emit approval event.
821         Approval(msg.sender, _to, _tokenId);
822     }
823 
824 
825     /// @notice Transfer a Asset owned by another address, for which the calling address
826     ///  has previously been granted transfer approval by the owner.
827     /// @param _from The address that owns the Asset to be transferred.
828     /// @param _to The address that should take ownership of the Asset. Can be any address,
829     ///  including the caller.
830     /// @param _tokenId The ID of the Asset to be transferred.
831     function _transferFrom(
832         address _from,
833         address _to,
834         uint256 _tokenId
835     )
836     internal
837     {
838         // Safety check to prevent against an unexpected 0x0 default.
839         require(_to != address(0));
840         // Disallow transfers to this contract to prevent accidental misuse.
841         // The contract should never own any assets (except for used assets).
842         require(_owns(_from, _tokenId));
843         // Check for approval and valid ownership
844         require(_approvedFor(_to, _tokenId));
845 
846         // Reassign ownership (also clears pending approvals and emits Transfer event).
847         ethernautsStorage.transfer(_from, _to, _tokenId);
848     }
849 
850     /// @dev Required for ERC-721 compliance.
851     /// @notice Transfer a Asset owned by another address, for which the calling address
852     ///  has previously been granted transfer approval by the owner.
853     /// @param _from The address that owns the Asset to be transfered.
854     /// @param _to The address that should take ownership of the Asset. Can be any address,
855     ///  including the caller.
856     /// @param _tokenId The ID of the Asset to be transferred.
857     function transferFrom(
858         address _from,
859         address _to,
860         uint256 _tokenId
861     )
862     external
863     whenNotPaused
864     {
865         _transferFrom(_from, _to, _tokenId);
866     }
867 
868     /// @dev Required for ERC-721 compliance.
869     /// @notice Allow pre-approved user to take ownership of a token
870     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
871     function takeOwnership(uint256 _tokenId) public {
872         address _from = ethernautsStorage.ownerOf(_tokenId);
873 
874         // Safety check to prevent against an unexpected 0x0 default.
875         require(_from != address(0));
876         _transferFrom(_from, msg.sender, _tokenId);
877     }
878 
879     /// @notice Returns the total number of Assets currently in existence.
880     /// @dev Required for ERC-721 compliance.
881     function totalSupply() public view returns (uint256) {
882         return ethernautsStorage.totalSupply();
883     }
884 
885     /// @notice Returns owner of a given Asset(Token).
886     /// @param _tokenId Token ID to get owner.
887     /// @dev Required for ERC-721 compliance.
888     function ownerOf(uint256 _tokenId)
889     external
890     view
891     returns (address owner)
892     {
893         owner = ethernautsStorage.ownerOf(_tokenId);
894 
895         require(owner != address(0));
896     }
897 
898     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
899     /// @param _creatorTokenID The asset who is father of this asset
900     /// @param _price asset price
901     /// @param _assetID asset ID
902     /// @param _category see Asset Struct description
903     /// @param _attributes see Asset Struct description
904     /// @param _stats see Asset Struct description
905     function createNewAsset(
906         uint256 _creatorTokenID,
907         address _owner,
908         uint256 _price,
909         uint16 _assetID,
910         uint8 _category,
911         uint8 _attributes,
912         uint8[STATS_SIZE] _stats
913     )
914     external onlyCLevel
915     returns (uint256)
916     {
917         // owner must be sender
918         require(_owner != address(0));
919 
920         uint256 tokenID = ethernautsStorage.createAsset(
921             _creatorTokenID,
922             _owner,
923             _price,
924             _assetID,
925             _category,
926             uint8(AssetState.Available),
927             _attributes,
928             _stats,
929             0,
930             0
931         );
932 
933         // emit the build event
934         Build(
935             _owner,
936             tokenID,
937             _assetID,
938             _price
939         );
940 
941         return tokenID;
942     }
943 
944     /// @notice verify if token is in exploration time
945     /// @param _tokenId The Token ID that can be upgraded
946     function isExploring(uint256 _tokenId) public view returns (bool) {
947         uint256 cooldown;
948         uint64 cooldownEndBlock;
949         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
950         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
951     }
952 }
953 
954 
955 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
956 /// @author Ethernatus - Fernando Pauer
957 contract EthernautsLogic is EthernautsOwnership {
958 
959     // Set in case the logic contract is broken and an upgrade is required
960     address public newContractAddress;
961 
962     /// @dev Constructor
963     function EthernautsLogic() public {
964         // the creator of the contract is the initial CEO, COO, CTO
965         ceoAddress = msg.sender;
966         ctoAddress = msg.sender;
967         cooAddress = msg.sender;
968         oracleAddress = msg.sender;
969 
970         // Starts paused.
971         paused = true;
972     }
973 
974     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
975     ///  breaking bug. This method does nothing but keep track of the new contract and
976     ///  emit a message indicating that the new address is set. It's up to clients of this
977     ///  contract to update to the new contract address in that case. (This contract will
978     ///  be paused indefinitely if such an upgrade takes place.)
979     /// @param _v2Address new address
980     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
981         // See README.md for updgrade plan
982         newContractAddress = _v2Address;
983         ContractUpgrade(_v2Address);
984     }
985 
986     /// @dev set a new reference to the NFT ownership contract
987     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
988     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
989         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
990         require(candidateContract.isEthernautsStorage());
991         ethernautsStorage = candidateContract;
992     }
993 
994     /// @dev Override unpause so it requires all external contract addresses
995     ///  to be set before contract can be unpaused. Also, we can't have
996     ///  newContractAddress set either, because then the contract was upgraded.
997     /// @notice This is public rather than external so we can call super.unpause
998     ///  without using an expensive CALL.
999     function unpause() public onlyCEO whenPaused {
1000         require(ethernautsStorage != address(0));
1001         require(newContractAddress == address(0));
1002         // require this contract to have access to storage contract
1003         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1004 
1005         // Actually unpause the contract.
1006         super.unpause();
1007     }
1008 
1009     // @dev Allows the COO to capture the balance available to the contract.
1010     function withdrawBalances(address _to) public onlyCLevel {
1011         _to.transfer(this.balance);
1012     }
1013 
1014     /// return current contract balance
1015     function getBalance() public view onlyCLevel returns (uint256) {
1016         return this.balance;
1017     }
1018 }
1019 
1020 /// @title The facet of the Ethernauts Explore contract that send a ship to explore the deep space.
1021 /// @notice An owned ship can be send on an expedition. Exploration takes time
1022 //          and will always result in “success”. This means the ship can never be destroyed
1023 //          and always returns with a collection of loot. The degree of success is dependent
1024 //          on different factors as sector stats, gamma ray burst number and ship stats.
1025 //          While the ship is exploring it cannot be acted on in any way until the expedition completes.
1026 //          After the ship returns from an expedition the user is then rewarded with a number of objects (assets).
1027 /// @author Ethernatus - Fernando Pauer
1028 contract EthernautsExplore is EthernautsLogic {
1029 
1030     /// @dev Delegate constructor to Nonfungible contract.
1031     function EthernautsExplore() public
1032     EthernautsLogic() {}
1033 
1034     /*** EVENTS ***/
1035     /// emit signal to anyone listening in the universe
1036     event Explore(uint256 shipId, uint256 sectorID, uint256 crewId, uint256 time);
1037 
1038     event Result(uint256 shipId, uint256 sectorID);
1039 
1040     /*** CONSTANTS ***/
1041     uint8 constant STATS_CAPOUT = 2**8 - 1; // all stats have a range from 0 to 255
1042 
1043     // @dev Sanity check that allows us to ensure that we are pointing to the
1044     //  right explore contract in our EthernautsCrewMember(address _CExploreAddress) call.
1045     bool public isEthernautsExplore = true;
1046 
1047     // An approximation of currently how many seconds are in between blocks.
1048     uint256 public secondsPerBlock = 15;
1049 
1050     uint256 public TICK_TIME = 15; // time is always in minutes
1051 
1052     // exploration fee
1053     uint256 public percentageCut  = 90;
1054 
1055     int256 public SPEED_STAT_MAX = 30;
1056     int256 public RANGE_STAT_MAX = 20;
1057     int256 public MIN_TIME_EXPLORE = 60;
1058     int256 public MAX_TIME_EXPLORE = 2160;
1059     int256 public RANGE_SCALE = 2;
1060 
1061     /// @dev Sector stats
1062     enum SectorStats {Size, Threat, Difficulty, Slots}
1063 
1064     /// @dev hold all ships in exploration
1065     uint256[] explorers;
1066 
1067     /// @dev A mapping from Ship token to the exploration index.
1068     mapping (uint256 => uint256) internal tokenIndexToExplore;
1069 
1070     /// @dev A mapping from Asset UniqueIDs to the sector token id.
1071     mapping (uint256 => uint256) internal tokenIndexToSector;
1072 
1073     /// @dev A mapping from exploration index to the crew token id.
1074     mapping (uint256 => uint256) internal exploreIndexToCrew;
1075 
1076     /// @dev A mission counter for crew.
1077     mapping (uint256 => uint16) public missions;
1078 
1079     /// @dev A mapping from Owner Cut (wei) to the sector token id.
1080     mapping (uint256 => uint256) public sectorToOwnerCut;
1081     mapping (uint256 => uint256) public sectorToOracleFee;
1082 
1083     /// @dev Get a list of ship exploring our universe
1084     function getExplorerList() public view returns(
1085         uint256[3][]
1086     ) {
1087         uint256[3][] memory tokens = new uint256[3][](explorers.length < 50 ? explorers.length : 50);
1088         uint256 index = 0;
1089 
1090         for(uint256 i = 0; i < explorers.length && index < 50; i++) {
1091             if (explorers[i] != 0) {
1092                 tokens[index][0] = explorers[i];
1093                 tokens[index][1] = tokenIndexToSector[explorers[i]];
1094                 tokens[index][2] = exploreIndexToCrew[i];
1095                 index++;
1096             }
1097         }
1098 
1099         if (index == 0) {
1100             // Return an empty array
1101             return new uint256[3][](0);
1102         } else {
1103             return tokens;
1104         }
1105     }
1106 
1107     function setOwnerCut(uint256 _sectorId, uint256 _ownerCut) external onlyCLevel {
1108         sectorToOwnerCut[_sectorId] = _ownerCut;
1109     }
1110 
1111     function setOracleFee(uint256 _sectorId, uint256 _oracleFee) external onlyCLevel {
1112         sectorToOracleFee[_sectorId] = _oracleFee;
1113     }
1114 
1115     function setTickTime(uint256 _tickTime) external onlyCLevel {
1116         TICK_TIME = _tickTime;
1117     }
1118 
1119     function setPercentageCut(uint256 _percentageCut) external onlyCLevel {
1120         percentageCut = _percentageCut;
1121     }
1122 
1123     function setMissions(uint256 _tokenId, uint16 _total) public onlyCLevel {
1124         missions[_tokenId] = _total;
1125     }
1126 
1127     /// @notice Explore a sector with a defined ship. Sectors contain a list of Objects that can be given to the players
1128     /// when exploring. Each entry has a Drop Rate and are sorted by Sector ID and Drop rate.
1129     /// The drop rate is a whole number between 0 and 1,000,000. 0 is 0% and 1,000,000 is 100%.
1130     /// Every time a Sector is explored a random number between 0 and 1,000,000 is calculated for each available Object.
1131     /// If the final result is lower than the Drop Rate of the Object, that Object will be rewarded to the player once
1132     /// Exploration is complete. Only 1 to 5 Objects maximum can be dropped during one exploration.
1133     /// (FUTURE VERSIONS) The final number will be affected by the user’s Ship Stats.
1134     /// @param _shipTokenId The Token ID that represents a ship
1135     /// @param _sectorTokenId The Token ID that represents a sector
1136     /// @param _crewTokenId The Token ID that represents a crew
1137     function explore(uint256 _shipTokenId, uint256 _sectorTokenId, uint256 _crewTokenId) payable external whenNotPaused {
1138         // charge a fee for each exploration when the results are ready
1139         require(msg.value >= sectorToOwnerCut[_sectorTokenId]);
1140 
1141         // check if Asset is a ship or not
1142         require(ethernautsStorage.isCategory(_shipTokenId, uint8(AssetCategory.Ship)));
1143 
1144         // check if _sectorTokenId is a sector or not
1145         require(ethernautsStorage.isCategory(_sectorTokenId, uint8(AssetCategory.Sector)));
1146 
1147         // Ensure the Ship is in available state, otherwise it cannot explore
1148         require(ethernautsStorage.isState(_shipTokenId, uint8(AssetState.Available)));
1149 
1150         // ship could not be in exploration
1151         require(!isExploring(_shipTokenId));
1152 
1153         // check if explorer is ship owner
1154         require(msg.sender == ethernautsStorage.ownerOf(_shipTokenId));
1155 
1156         // check if owner sector is not empty
1157         address sectorOwner = ethernautsStorage.ownerOf(_sectorTokenId);
1158         require(sectorOwner != address(0));
1159 
1160         // check if there is a crew and validating crew member
1161         if (_crewTokenId > 0) {
1162             // crew member should not be in exploration
1163             require(!isExploring(_crewTokenId));
1164 
1165             // check if Asset is a crew or not
1166             require(ethernautsStorage.isCategory(_crewTokenId, uint8(AssetCategory.CrewMember)));
1167 
1168             // check if crew member is same owner
1169             require(msg.sender == ethernautsStorage.ownerOf(_crewTokenId));
1170         }
1171 
1172         /// store exploration data
1173         tokenIndexToExplore[_shipTokenId] = explorers.push(_shipTokenId) - 1;
1174         tokenIndexToSector[_shipTokenId] = _sectorTokenId;
1175 
1176         uint8[STATS_SIZE] memory _shipStats = ethernautsStorage.getStats(_shipTokenId);
1177         uint8[STATS_SIZE] memory _sectorStats = ethernautsStorage.getStats(_sectorTokenId);
1178 
1179         // check if there is a crew and store data and change ship stats
1180         if (_crewTokenId > 0) {
1181             /// store crew exploration data
1182             exploreIndexToCrew[tokenIndexToExplore[_shipTokenId]] = _crewTokenId;
1183             missions[_crewTokenId]++;
1184 
1185             //// grab crew stats and merge with ship
1186             uint8[STATS_SIZE] memory _crewStats = ethernautsStorage.getStats(_crewTokenId);
1187             _shipStats[uint256(ShipStats.Range)] += _crewStats[uint256(ShipStats.Range)];
1188             _shipStats[uint256(ShipStats.Speed)] += _crewStats[uint256(ShipStats.Speed)];
1189 
1190             if (_shipStats[uint256(ShipStats.Range)] > STATS_CAPOUT) {
1191                 _shipStats[uint256(ShipStats.Range)] = STATS_CAPOUT;
1192             }
1193             if (_shipStats[uint256(ShipStats.Speed)] > STATS_CAPOUT) {
1194                 _shipStats[uint256(ShipStats.Speed)] = STATS_CAPOUT;
1195             }
1196         }
1197 
1198         /// set exploration time
1199         uint256 time = uint256(_explorationTime(
1200                 _shipStats[uint256(ShipStats.Range)],
1201                 _shipStats[uint256(ShipStats.Speed)],
1202                 _sectorStats[uint256(SectorStats.Size)]
1203             ));
1204         // exploration time in minutes converted to seconds
1205         time *= 60;
1206 
1207         uint64 _cooldownEndBlock = uint64((time/secondsPerBlock) + block.number);
1208         ethernautsStorage.setAssetCooldown(_shipTokenId, now + time, _cooldownEndBlock);
1209 
1210         // check if there is a crew store data and set crew exploration time
1211         if (_crewTokenId > 0) {
1212             /// store crew exploration time
1213             ethernautsStorage.setAssetCooldown(_crewTokenId, now + time, _cooldownEndBlock);
1214         }
1215 
1216         // to avoid mistakes and charge unnecessary extra fees
1217         uint256 feeExcess = SafeMath.sub(msg.value, sectorToOwnerCut[_sectorTokenId]);
1218         uint256 payment = uint256(SafeMath.div(SafeMath.mul(msg.value, percentageCut), 100)) - sectorToOracleFee[_sectorTokenId];
1219 
1220         /// emit signal to anyone listening in the universe
1221         Explore(_shipTokenId, _sectorTokenId, _crewTokenId, now + time);
1222 
1223         // keeping oracle accounts with balance
1224         oracleAddress.transfer(sectorToOracleFee[_sectorTokenId]);
1225 
1226         // paying sector owner
1227         sectorOwner.transfer(payment);
1228 
1229         // send excess back to explorer
1230         msg.sender.transfer(feeExcess);
1231     }
1232 
1233     /// @notice Exploration is complete and at most 10 Objects will return during one exploration.
1234     /// @param _shipTokenId The Token ID that represents a ship and can explore
1235     /// @param _sectorTokenId The Token ID that represents a sector and can be explored
1236     /// @param _IDs that represents a object returned from exploration
1237     /// @param _attributes that represents attributes for each object returned from exploration
1238     /// @param _stats that represents all stats for each object returned from exploration
1239     function explorationResults(
1240         uint256 _shipTokenId,
1241         uint256 _sectorTokenId,
1242         uint16[10] _IDs,
1243         uint8[10] _attributes,
1244         uint8[STATS_SIZE][10] _stats
1245     )
1246     external onlyOracle
1247     {
1248         uint256 cooldown;
1249         uint64 cooldownEndBlock;
1250         uint256 builtBy;
1251         (,,,,,cooldownEndBlock, cooldown, builtBy) = ethernautsStorage.assets(_shipTokenId);
1252 
1253         address owner = ethernautsStorage.ownerOf(_shipTokenId);
1254         require(owner != address(0));
1255 
1256         /// create objects returned from exploration
1257         uint256 i = 0;
1258         for (i = 0; i < 10 && _IDs[i] > 0; i++) {
1259             _buildAsset(
1260                 _sectorTokenId,
1261                 owner,
1262                 0,
1263                 _IDs[i],
1264                 uint8(AssetCategory.Object),
1265                 uint8(_attributes[i]),
1266                 _stats[i],
1267                 cooldown,
1268                 cooldownEndBlock
1269             );
1270         }
1271 
1272         // to guarantee at least 1 result per exploration
1273         require(i > 0);
1274 
1275         /// remove from explore list
1276         delete explorers[tokenIndexToExplore[_shipTokenId]];
1277         delete tokenIndexToSector[_shipTokenId];
1278 
1279         /// emit signal to anyone listening in the universe
1280         Result(_shipTokenId, _sectorTokenId);
1281     }
1282 
1283     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
1284     /// @param _creatorTokenID The asset who is father of this asset
1285     /// @param _price asset price
1286     /// @param _assetID asset ID
1287     /// @param _category see Asset Struct description
1288     /// @param _attributes see Asset Struct description
1289     /// @param _stats see Asset Struct description
1290     /// @param _cooldown see Asset Struct description
1291     /// @param _cooldownEndBlock see Asset Struct description
1292     function _buildAsset(
1293         uint256 _creatorTokenID,
1294         address _owner,
1295         uint256 _price,
1296         uint16 _assetID,
1297         uint8 _category,
1298         uint8 _attributes,
1299         uint8[STATS_SIZE] _stats,
1300         uint256 _cooldown,
1301         uint64 _cooldownEndBlock
1302     )
1303     private returns (uint256)
1304     {
1305         uint256 tokenID = ethernautsStorage.createAsset(
1306             _creatorTokenID,
1307             _owner,
1308             _price,
1309             _assetID,
1310             _category,
1311             uint8(AssetState.Available),
1312             _attributes,
1313             _stats,
1314             _cooldown,
1315             _cooldownEndBlock
1316         );
1317 
1318         // emit the build event
1319         Build(
1320             _owner,
1321             tokenID,
1322             _assetID,
1323             _price
1324         );
1325 
1326         return tokenID;
1327     }
1328 
1329     /// @notice Exploration Time: The time it takes to explore a Sector is dependent on the Sector Size
1330     ///         along with the Ship’s Range and Speed.
1331     /// @param _shipRange ship range
1332     /// @param _shipSpeed ship speed
1333     /// @param _sectorSize sector size
1334     function _explorationTime(
1335         uint8 _shipRange,
1336         uint8 _shipSpeed,
1337         uint8 _sectorSize
1338     ) private view returns (int256) {
1339         int256 minToExplore = 0;
1340 
1341         minToExplore = SafeMath.min(_shipSpeed, SPEED_STAT_MAX) - 1;
1342         minToExplore = -72 * minToExplore;
1343         minToExplore += MAX_TIME_EXPLORE;
1344 
1345         uint256 minRange = uint256(SafeMath.min(_shipRange, RANGE_STAT_MAX));
1346         uint256 scaledRange = uint256(RANGE_STAT_MAX * RANGE_SCALE);
1347         int256 minExplore = (minToExplore - MIN_TIME_EXPLORE);
1348 
1349         minToExplore -= fraction(minExplore, int256(minRange), int256(scaledRange));
1350         minToExplore += fraction(minToExplore, (_sectorSize - 10), 10);
1351         minToExplore = SafeMath.max(minToExplore, MIN_TIME_EXPLORE);
1352 
1353         return minToExplore;
1354     }
1355 
1356     /// @notice calcs a perc without float or double :(
1357     function fraction(int256 _subject, int256 _numerator, int256 _denominator)
1358     private pure returns (int256) {
1359         int256 division = _subject * _numerator - _subject * _denominator;
1360         int256 total = _subject * _denominator + division;
1361         return total / _denominator;
1362     }
1363 
1364     /// @notice Any C-level can fix how many seconds per blocks are currently observed.
1365     /// @param _secs The seconds per block
1366     function setSecondsPerBlock(uint256 _secs) external onlyCLevel {
1367         require(_secs > 0);
1368         secondsPerBlock = _secs;
1369     }
1370 }