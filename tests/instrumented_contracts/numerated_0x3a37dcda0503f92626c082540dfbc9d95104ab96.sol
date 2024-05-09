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
33 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
34 contract EthernautsBase {
35 
36     /*** CONSTANTS USED ACROSS CONTRACTS ***/
37 
38     /// @dev Used by all contracts that interfaces with Ethernauts
39     ///      The ERC-165 interface signature for ERC-721.
40     ///  Ref: https://github.com/ethereum/EIPs/issues/165
41     ///  Ref: https://github.com/ethereum/EIPs/issues/721
42     bytes4 constant InterfaceSignature_ERC721 =
43     bytes4(keccak256('name()')) ^
44     bytes4(keccak256('symbol()')) ^
45     bytes4(keccak256('totalSupply()')) ^
46     bytes4(keccak256('balanceOf(address)')) ^
47     bytes4(keccak256('ownerOf(uint256)')) ^
48     bytes4(keccak256('approve(address,uint256)')) ^
49     bytes4(keccak256('transfer(address,uint256)')) ^
50     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
51     bytes4(keccak256('takeOwnership(uint256)')) ^
52     bytes4(keccak256('tokensOfOwner(address)')) ^
53     bytes4(keccak256('tokenMetadata(uint256,string)'));
54 
55     /// @dev due solidity limitation we cannot return dynamic array from methods
56     /// so it creates incompability between functions across different contracts
57     uint8 public constant STATS_SIZE = 10;
58     uint8 public constant SHIP_SLOTS = 5;
59 
60     // Possible state of any asset
61     enum AssetState { Available, UpForLease, Used }
62 
63     // Possible state of any asset
64     // NotValid is to avoid 0 in places where category must be bigger than zero
65     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
66 
67     /// @dev Sector stats
68     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
69     /// @notice Possible attributes for each asset
70     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
71     /// 00000010 - Producible - Product of a factory and/or factory contract.
72     /// 00000100 - Explorable- Product of exploration.
73     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
74     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
75     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
76     /// 01000000 - Tradable - Buyable and sellable on the market.
77     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
78     bytes2 public ATTR_SEEDED     = bytes2(2**0);
79     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
80     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
81     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
82     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
83     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
84     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
85     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
86 }
87 
88 /// @notice This contract manages the various addresses and constraints for operations
89 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
90 contract EthernautsAccessControl is EthernautsBase {
91 
92     // This facet controls access control for Ethernauts.
93     // All roles have same responsibilities and rights, but there is slight differences between them:
94     //
95     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
96     //       It is initially set to the address that created the smart contract.
97     //
98     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
99     //
100     //     - The COO: The COO can change contract address and add create assets.
101     //
102     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
103     /// @param newContract address pointing to new contract
104     event ContractUpgrade(address newContract);
105 
106     // The addresses of the accounts (or contracts) that can execute actions within each roles.
107     address public ceoAddress;
108     address public ctoAddress;
109     address public cooAddress;
110     address public oracleAddress;
111 
112     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
113     bool public paused = false;
114 
115     /// @dev Access modifier for CEO-only functionality
116     modifier onlyCEO() {
117         require(msg.sender == ceoAddress);
118         _;
119     }
120 
121     /// @dev Access modifier for CTO-only functionality
122     modifier onlyCTO() {
123         require(msg.sender == ctoAddress);
124         _;
125     }
126 
127     /// @dev Access modifier for CTO-only functionality
128     modifier onlyOracle() {
129         require(msg.sender == oracleAddress);
130         _;
131     }
132 
133     modifier onlyCLevel() {
134         require(
135             msg.sender == ceoAddress ||
136             msg.sender == ctoAddress ||
137             msg.sender == cooAddress
138         );
139         _;
140     }
141 
142     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
143     /// @param _newCEO The address of the new CEO
144     function setCEO(address _newCEO) external onlyCEO {
145         require(_newCEO != address(0));
146 
147         ceoAddress = _newCEO;
148     }
149 
150     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
151     /// @param _newCTO The address of the new CTO
152     function setCTO(address _newCTO) external {
153         require(
154             msg.sender == ceoAddress ||
155             msg.sender == ctoAddress
156         );
157         require(_newCTO != address(0));
158 
159         ctoAddress = _newCTO;
160     }
161 
162     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
163     /// @param _newCOO The address of the new COO
164     function setCOO(address _newCOO) external {
165         require(
166             msg.sender == ceoAddress ||
167             msg.sender == cooAddress
168         );
169         require(_newCOO != address(0));
170 
171         cooAddress = _newCOO;
172     }
173 
174     /// @dev Assigns a new address to act as oracle.
175     /// @param _newOracle The address of oracle
176     function setOracle(address _newOracle) external {
177         require(msg.sender == ctoAddress);
178         require(_newOracle != address(0));
179 
180         oracleAddress = _newOracle;
181     }
182 
183     /*** Pausable functionality adapted from OpenZeppelin ***/
184 
185     /// @dev Modifier to allow actions only when the contract IS NOT paused
186     modifier whenNotPaused() {
187         require(!paused);
188         _;
189     }
190 
191     /// @dev Modifier to allow actions only when the contract IS paused
192     modifier whenPaused {
193         require(paused);
194         _;
195     }
196 
197     /// @dev Called by any "C-level" role to pause the contract. Used only when
198     ///  a bug or exploit is detected and we need to limit damage.
199     function pause() external onlyCLevel whenNotPaused {
200         paused = true;
201     }
202 
203     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
204     ///  one reason we may pause the contract is when CTO account is compromised.
205     /// @notice This is public rather than external so it can be called by
206     ///  derived contracts.
207     function unpause() public onlyCEO whenPaused {
208         // can't unpause if contract was upgraded
209         paused = false;
210     }
211 
212 }
213 
214 
215 
216 
217 
218 
219 
220 
221 
222 
223 
224 /// @title Storage contract for Ethernauts Data. Common structs and constants.
225 /// @notice This is our main data storage, constants and data types, plus
226 //          internal functions for managing the assets. It is isolated and only interface with
227 //          a list of granted contracts defined by CTO
228 /// @author Ethernauts - Fernando Pauer
229 contract EthernautsStorage is EthernautsAccessControl {
230 
231     function EthernautsStorage() public {
232         // the creator of the contract is the initial CEO
233         ceoAddress = msg.sender;
234 
235         // the creator of the contract is the initial CTO as well
236         ctoAddress = msg.sender;
237 
238         // the creator of the contract is the initial CTO as well
239         cooAddress = msg.sender;
240 
241         // the creator of the contract is the initial Oracle as well
242         oracleAddress = msg.sender;
243     }
244 
245     /// @notice No tipping!
246     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
247     function() external payable {
248         require(msg.sender == address(this));
249     }
250 
251     /*** Mapping for Contracts with granted permission ***/
252     mapping (address => bool) public contractsGrantedAccess;
253 
254     /// @dev grant access for a contract to interact with this contract.
255     /// @param _v2Address The contract address to grant access
256     function grantAccess(address _v2Address) public onlyCTO {
257         // See README.md for updgrade plan
258         contractsGrantedAccess[_v2Address] = true;
259     }
260 
261     /// @dev remove access from a contract to interact with this contract.
262     /// @param _v2Address The contract address to be removed
263     function removeAccess(address _v2Address) public onlyCTO {
264         // See README.md for updgrade plan
265         delete contractsGrantedAccess[_v2Address];
266     }
267 
268     /// @dev Only allow permitted contracts to interact with this contract
269     modifier onlyGrantedContracts() {
270         require(contractsGrantedAccess[msg.sender] == true);
271         _;
272     }
273 
274     modifier validAsset(uint256 _tokenId) {
275         require(assets[_tokenId].ID > 0);
276         _;
277     }
278     /*** DATA TYPES ***/
279 
280     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
281     ///  of this structure. Note that the order of the members in this structure
282     ///  is important because of the byte-packing rules used by Ethereum.
283     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
284     struct Asset {
285 
286         // Asset ID is a identifier for look and feel in frontend
287         uint16 ID;
288 
289         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
290         uint8 category;
291 
292         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
293         uint8 state;
294 
295         // Attributes
296         // byte pos - Definition
297         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
298         // 00000010 - Producible - Product of a factory and/or factory contract.
299         // 00000100 - Explorable- Product of exploration.
300         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
301         // 00010000 - Permanent - Cannot be removed, always owned by a user.
302         // 00100000 - Consumable - Destroyed after N exploration expeditions.
303         // 01000000 - Tradable - Buyable and sellable on the market.
304         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
305         bytes2 attributes;
306 
307         // The timestamp from the block when this asset was created.
308         uint64 createdAt;
309 
310         // The minimum timestamp after which this asset can engage in exploring activities again.
311         uint64 cooldownEndBlock;
312 
313         // The Asset's stats can be upgraded or changed based on exploration conditions.
314         // It will be defined per child contract, but all stats have a range from 0 to 255
315         // Examples
316         // 0 = Ship Level
317         // 1 = Ship Attack
318         uint8[STATS_SIZE] stats;
319 
320         // Set to the cooldown time that represents exploration duration for this asset.
321         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
322         uint256 cooldown;
323 
324         // a reference to a super asset that manufactured the asset
325         uint256 builtBy;
326     }
327 
328     /*** CONSTANTS ***/
329 
330     // @dev Sanity check that allows us to ensure that we are pointing to the
331     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
332     bool public isEthernautsStorage = true;
333 
334     /*** STORAGE ***/
335 
336     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
337     ///  of each asset is actually an index into this array.
338     Asset[] public assets;
339 
340     /// @dev A mapping from Asset UniqueIDs to the price of the token.
341     /// stored outside Asset Struct to save gas, because price can change frequently
342     mapping (uint256 => uint256) internal assetIndexToPrice;
343 
344     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
345     mapping (uint256 => address) internal assetIndexToOwner;
346 
347     // @dev A mapping from owner address to count of tokens that address owns.
348     //  Used internally inside balanceOf() to resolve ownership count.
349     mapping (address => uint256) internal ownershipTokenCount;
350 
351     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
352     ///  transferFrom(). Each Asset can only have one approved address for transfer
353     ///  at any time. A zero value means no approval is outstanding.
354     mapping (uint256 => address) internal assetIndexToApproved;
355 
356 
357     /*** SETTERS ***/
358 
359     /// @dev set new asset price
360     /// @param _tokenId  asset UniqueId
361     /// @param _price    asset price
362     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
363         assetIndexToPrice[_tokenId] = _price;
364     }
365 
366     /// @dev Mark transfer as approved
367     /// @param _tokenId  asset UniqueId
368     /// @param _approved address approved
369     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
370         assetIndexToApproved[_tokenId] = _approved;
371     }
372 
373     /// @dev Assigns ownership of a specific Asset to an address.
374     /// @param _from    current owner address
375     /// @param _to      new owner address
376     /// @param _tokenId asset UniqueId
377     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
378         // Since the number of assets is capped to 2^32 we can't overflow this
379         ownershipTokenCount[_to]++;
380         // transfer ownership
381         assetIndexToOwner[_tokenId] = _to;
382         // When creating new assets _from is 0x0, but we can't account that address.
383         if (_from != address(0)) {
384             ownershipTokenCount[_from]--;
385             // clear any previously approved ownership exchange
386             delete assetIndexToApproved[_tokenId];
387         }
388     }
389 
390     /// @dev A public method that creates a new asset and stores it. This
391     ///  method does basic checking and should only be called from other contract when the
392     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
393     /// @param _creatorTokenID The asset who is father of this asset
394     /// @param _owner First owner of this asset
395     /// @param _price asset price
396     /// @param _ID asset ID
397     /// @param _category see Asset Struct description
398     /// @param _state see Asset Struct description
399     /// @param _attributes see Asset Struct description
400     /// @param _stats see Asset Struct description
401     function createAsset(
402         uint256 _creatorTokenID,
403         address _owner,
404         uint256 _price,
405         uint16 _ID,
406         uint8 _category,
407         uint8 _state,
408         uint8 _attributes,
409         uint8[STATS_SIZE] _stats,
410         uint256 _cooldown,
411         uint64 _cooldownEndBlock
412     )
413     public onlyGrantedContracts
414     returns (uint256)
415     {
416         // Ensure our data structures are always valid.
417         require(_ID > 0);
418         require(_category > 0);
419         require(_attributes != 0x0);
420         require(_stats.length > 0);
421 
422         Asset memory asset = Asset({
423             ID: _ID,
424             category: _category,
425             builtBy: _creatorTokenID,
426             attributes: bytes2(_attributes),
427             stats: _stats,
428             state: _state,
429             createdAt: uint64(now),
430             cooldownEndBlock: _cooldownEndBlock,
431             cooldown: _cooldown
432             });
433 
434         uint256 newAssetUniqueId = assets.push(asset) - 1;
435 
436         // Check it reached 4 billion assets but let's just be 100% sure.
437         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
438 
439         // store price
440         assetIndexToPrice[newAssetUniqueId] = _price;
441 
442         // This will assign ownership
443         transfer(address(0), _owner, newAssetUniqueId);
444 
445         return newAssetUniqueId;
446     }
447 
448     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
449     /// This method doesn't do any checking and should only be called when the
450     ///  input data is known to be valid.
451     /// @param _tokenId The token ID
452     /// @param _creatorTokenID The asset that create that token
453     /// @param _price asset price
454     /// @param _ID asset ID
455     /// @param _category see Asset Struct description
456     /// @param _state see Asset Struct description
457     /// @param _attributes see Asset Struct description
458     /// @param _stats see Asset Struct description
459     /// @param _cooldown asset cooldown index
460     function editAsset(
461         uint256 _tokenId,
462         uint256 _creatorTokenID,
463         uint256 _price,
464         uint16 _ID,
465         uint8 _category,
466         uint8 _state,
467         uint8 _attributes,
468         uint8[STATS_SIZE] _stats,
469         uint16 _cooldown
470     )
471     external validAsset(_tokenId) onlyCLevel
472     returns (uint256)
473     {
474         // Ensure our data structures are always valid.
475         require(_ID > 0);
476         require(_category > 0);
477         require(_attributes != 0x0);
478         require(_stats.length > 0);
479 
480         // store price
481         assetIndexToPrice[_tokenId] = _price;
482 
483         Asset storage asset = assets[_tokenId];
484         asset.ID = _ID;
485         asset.category = _category;
486         asset.builtBy = _creatorTokenID;
487         asset.attributes = bytes2(_attributes);
488         asset.stats = _stats;
489         asset.state = _state;
490         asset.cooldown = _cooldown;
491     }
492 
493     /// @dev Update only stats
494     /// @param _tokenId asset UniqueId
495     /// @param _stats asset state, see Asset Struct description
496     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
497         assets[_tokenId].stats = _stats;
498     }
499 
500     /// @dev Update only asset state
501     /// @param _tokenId asset UniqueId
502     /// @param _state asset state, see Asset Struct description
503     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
504         assets[_tokenId].state = _state;
505     }
506 
507     /// @dev Update Cooldown for a single asset
508     /// @param _tokenId asset UniqueId
509     /// @param _cooldown asset state, see Asset Struct description
510     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
511     public validAsset(_tokenId) onlyGrantedContracts {
512         assets[_tokenId].cooldown = _cooldown;
513         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
514     }
515 
516     /*** GETTERS ***/
517 
518     /// @notice Returns only stats data about a specific asset.
519     /// @dev it is necessary due solidity compiler limitations
520     ///      when we have large qty of parameters it throws StackTooDeepException
521     /// @param _tokenId The UniqueId of the asset of interest.
522     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
523         return assets[_tokenId].stats;
524     }
525 
526     /// @dev return current price of an asset
527     /// @param _tokenId asset UniqueId
528     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
529         return assetIndexToPrice[_tokenId];
530     }
531 
532     /// @notice Check if asset has all attributes passed by parameter
533     /// @param _tokenId The UniqueId of the asset of interest.
534     /// @param _attributes see Asset Struct description
535     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
536         return assets[_tokenId].attributes & _attributes == _attributes;
537     }
538 
539     /// @notice Check if asset has any attribute passed by parameter
540     /// @param _tokenId The UniqueId of the asset of interest.
541     /// @param _attributes see Asset Struct description
542     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
543         return assets[_tokenId].attributes & _attributes != 0x0;
544     }
545 
546     /// @notice Check if asset is in the state passed by parameter
547     /// @param _tokenId The UniqueId of the asset of interest.
548     /// @param _category see AssetCategory in EthernautsBase for possible states
549     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
550         return assets[_tokenId].category == _category;
551     }
552 
553     /// @notice Check if asset is in the state passed by parameter
554     /// @param _tokenId The UniqueId of the asset of interest.
555     /// @param _state see enum AssetState in EthernautsBase for possible states
556     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
557         return assets[_tokenId].state == _state;
558     }
559 
560     /// @notice Returns owner of a given Asset(Token).
561     /// @dev Required for ERC-721 compliance.
562     /// @param _tokenId asset UniqueId
563     function ownerOf(uint256 _tokenId) public view returns (address owner)
564     {
565         return assetIndexToOwner[_tokenId];
566     }
567 
568     /// @dev Required for ERC-721 compliance
569     /// @notice Returns the number of Assets owned by a specific address.
570     /// @param _owner The owner address to check.
571     function balanceOf(address _owner) public view returns (uint256 count) {
572         return ownershipTokenCount[_owner];
573     }
574 
575     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
576     /// @param _tokenId asset UniqueId
577     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
578         return assetIndexToApproved[_tokenId];
579     }
580 
581     /// @notice Returns the total number of Assets currently in existence.
582     /// @dev Required for ERC-721 compliance.
583     function totalSupply() public view returns (uint256) {
584         return assets.length;
585     }
586 
587     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
588     /// @param _owner filter all assets by owner
589     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
590         uint256[6][]
591     ) {
592         uint256 totalAssets = assets.length;
593 
594         if (totalAssets == 0) {
595             // Return an empty array
596             return new uint256[6][](0);
597         } else {
598             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
599             uint256 resultIndex = 0;
600             bytes2 hasAttributes  = bytes2(_withAttributes);
601             Asset memory asset;
602 
603             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
604                 asset = assets[tokenId];
605                 if (
606                     (asset.state != uint8(AssetState.Used)) &&
607                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
608                     (asset.attributes & hasAttributes == hasAttributes)
609                 ) {
610                     result[resultIndex][0] = tokenId;
611                     result[resultIndex][1] = asset.ID;
612                     result[resultIndex][2] = asset.category;
613                     result[resultIndex][3] = uint256(asset.attributes);
614                     result[resultIndex][4] = asset.cooldown;
615                     result[resultIndex][5] = assetIndexToPrice[tokenId];
616                     resultIndex++;
617                 }
618             }
619 
620             return result;
621         }
622     }
623 }
624 
625 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
626 /// @notice This provides the methods required for basic non-fungible token
627 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
628 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
629 //          reference to logic contracts as Auction, Explore and so on
630 /// @author Ethernatus - Fernando Pauer
631 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
632 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
633 
634     /// @dev Contract holding only data.
635     EthernautsStorage public ethernautsStorage;
636 
637     /*** CONSTANTS ***/
638     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
639     string public constant name = "Ethernauts";
640     string public constant symbol = "ETNT";
641 
642     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
643     /**********************************************************************/
644 
645     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
646 
647     /*** EVENTS ***/
648 
649     // Events as per ERC-721
650     event Transfer(address indexed from, address indexed to, uint256 tokens);
651     event Approval(address indexed owner, address indexed approved, uint256 tokens);
652 
653     /// @dev When a new asset is create it emits build event
654     /// @param owner The address of asset owner
655     /// @param tokenId Asset UniqueID
656     /// @param assetId ID that defines asset look and feel
657     /// @param price asset price
658     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
659 
660     function implementsERC721() public pure returns (bool) {
661         return true;
662     }
663 
664     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
665     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
666     /// @param _interfaceID interface signature ID
667     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
668     {
669         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
670     }
671 
672     /// @dev Checks if a given address is the current owner of a particular Asset.
673     /// @param _claimant the address we are validating against.
674     /// @param _tokenId asset UniqueId, only valid when > 0
675     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
676         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
677     }
678 
679     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
680     /// @param _claimant the address we are confirming asset is approved for.
681     /// @param _tokenId asset UniqueId, only valid when > 0
682     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
683         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
684     }
685 
686     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
687     ///  approval. Setting _approved to address(0) clears all transfer approval.
688     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
689     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
690     ///  there is no value in spamming the log with Approval events in that case.
691     function _approve(uint256 _tokenId, address _approved) internal {
692         ethernautsStorage.approve(_tokenId, _approved);
693     }
694 
695     /// @notice Returns the number of Assets owned by a specific address.
696     /// @param _owner The owner address to check.
697     /// @dev Required for ERC-721 compliance
698     function balanceOf(address _owner) public view returns (uint256 count) {
699         return ethernautsStorage.balanceOf(_owner);
700     }
701 
702     /// @dev Required for ERC-721 compliance.
703     /// @notice Transfers a Asset to another address. If transferring to a smart
704     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
705     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
706     /// @param _to The address of the recipient, can be a user or contract.
707     /// @param _tokenId The ID of the Asset to transfer.
708     function transfer(
709         address _to,
710         uint256 _tokenId
711     )
712     external
713     whenNotPaused
714     {
715         // Safety check to prevent against an unexpected 0x0 default.
716         require(_to != address(0));
717         // Disallow transfers to this contract to prevent accidental misuse.
718         // The contract should never own any assets
719         // (except very briefly after it is created and before it goes on auction).
720         require(_to != address(this));
721         // Disallow transfers to the storage contract to prevent accidental
722         // misuse. Auction or Upgrade contracts should only take ownership of assets
723         // through the allow + transferFrom flow.
724         require(_to != address(ethernautsStorage));
725 
726         // You can only send your own asset.
727         require(_owns(msg.sender, _tokenId));
728 
729         // Reassign ownership, clear pending approvals, emit Transfer event.
730         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
731     }
732 
733     /// @dev Required for ERC-721 compliance.
734     /// @notice Grant another address the right to transfer a specific Asset via
735     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
736     /// @param _to The address to be granted transfer approval. Pass address(0) to
737     ///  clear all approvals.
738     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
739     function approve(
740         address _to,
741         uint256 _tokenId
742     )
743     external
744     whenNotPaused
745     {
746         // Only an owner can grant transfer approval.
747         require(_owns(msg.sender, _tokenId));
748 
749         // Register the approval (replacing any previous approval).
750         _approve(_tokenId, _to);
751 
752         // Emit approval event.
753         Approval(msg.sender, _to, _tokenId);
754     }
755 
756 
757     /// @notice Transfer a Asset owned by another address, for which the calling address
758     ///  has previously been granted transfer approval by the owner.
759     /// @param _from The address that owns the Asset to be transferred.
760     /// @param _to The address that should take ownership of the Asset. Can be any address,
761     ///  including the caller.
762     /// @param _tokenId The ID of the Asset to be transferred.
763     function _transferFrom(
764         address _from,
765         address _to,
766         uint256 _tokenId
767     )
768     internal
769     {
770         // Safety check to prevent against an unexpected 0x0 default.
771         require(_to != address(0));
772         // Disallow transfers to this contract to prevent accidental misuse.
773         // The contract should never own any assets (except for used assets).
774         require(_owns(_from, _tokenId));
775         // Check for approval and valid ownership
776         require(_approvedFor(_to, _tokenId));
777 
778         // Reassign ownership (also clears pending approvals and emits Transfer event).
779         ethernautsStorage.transfer(_from, _to, _tokenId);
780     }
781 
782     /// @dev Required for ERC-721 compliance.
783     /// @notice Transfer a Asset owned by another address, for which the calling address
784     ///  has previously been granted transfer approval by the owner.
785     /// @param _from The address that owns the Asset to be transfered.
786     /// @param _to The address that should take ownership of the Asset. Can be any address,
787     ///  including the caller.
788     /// @param _tokenId The ID of the Asset to be transferred.
789     function transferFrom(
790         address _from,
791         address _to,
792         uint256 _tokenId
793     )
794     external
795     whenNotPaused
796     {
797         _transferFrom(_from, _to, _tokenId);
798     }
799 
800     /// @dev Required for ERC-721 compliance.
801     /// @notice Allow pre-approved user to take ownership of a token
802     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
803     function takeOwnership(uint256 _tokenId) public {
804         address _from = ethernautsStorage.ownerOf(_tokenId);
805 
806         // Safety check to prevent against an unexpected 0x0 default.
807         require(_from != address(0));
808         _transferFrom(_from, msg.sender, _tokenId);
809     }
810 
811     /// @notice Returns the total number of Assets currently in existence.
812     /// @dev Required for ERC-721 compliance.
813     function totalSupply() public view returns (uint256) {
814         return ethernautsStorage.totalSupply();
815     }
816 
817     /// @notice Returns owner of a given Asset(Token).
818     /// @param _tokenId Token ID to get owner.
819     /// @dev Required for ERC-721 compliance.
820     function ownerOf(uint256 _tokenId)
821     external
822     view
823     returns (address owner)
824     {
825         owner = ethernautsStorage.ownerOf(_tokenId);
826 
827         require(owner != address(0));
828     }
829 
830     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
831     /// @param _creatorTokenID The asset who is father of this asset
832     /// @param _price asset price
833     /// @param _assetID asset ID
834     /// @param _category see Asset Struct description
835     /// @param _attributes see Asset Struct description
836     /// @param _stats see Asset Struct description
837     function createNewAsset(
838         uint256 _creatorTokenID,
839         address _owner,
840         uint256 _price,
841         uint16 _assetID,
842         uint8 _category,
843         uint8 _attributes,
844         uint8[STATS_SIZE] _stats
845     )
846     external onlyCLevel
847     returns (uint256)
848     {
849         // owner must be sender
850         require(_owner != address(0));
851 
852         uint256 tokenID = ethernautsStorage.createAsset(
853             _creatorTokenID,
854             _owner,
855             _price,
856             _assetID,
857             _category,
858             uint8(AssetState.Available),
859             _attributes,
860             _stats,
861             0,
862             0
863         );
864 
865         // emit the build event
866         Build(
867             _owner,
868             tokenID,
869             _assetID,
870             _price
871         );
872 
873         return tokenID;
874     }
875 
876     /// @notice verify if token is in exploration time
877     /// @param _tokenId The Token ID that can be upgraded
878     function isExploring(uint256 _tokenId) public view returns (bool) {
879         uint256 cooldown;
880         uint64 cooldownEndBlock;
881         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
882         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
883     }
884 }
885 
886 
887 // Extend this library for child contracts
888 library SafeMath {
889 
890     /**
891     * @dev Multiplies two numbers, throws on overflow.
892     */
893     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
894         if (a == 0) {
895             return 0;
896         }
897         uint256 c = a * b;
898         assert(c / a == b);
899         return c;
900     }
901 
902     /**
903     * @dev Integer division of two numbers, truncating the quotient.
904     */
905     function div(uint256 a, uint256 b) internal pure returns (uint256) {
906         // assert(b > 0); // Solidity automatically throws when dividing by 0
907         uint256 c = a / b;
908         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
909         return c;
910     }
911 
912     /**
913     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
914     */
915     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
916         assert(b <= a);
917         return a - b;
918     }
919 
920     /**
921     * @dev Adds two numbers, throws on overflow.
922     */
923     function add(uint256 a, uint256 b) internal pure returns (uint256) {
924         uint256 c = a + b;
925         assert(c >= a);
926         return c;
927     }
928 
929     /**
930     * @dev Compara two numbers, and return the bigger one.
931     */
932     function max(int256 a, int256 b) internal pure returns (int256) {
933         if (a > b) {
934             return a;
935         } else {
936             return b;
937         }
938     }
939 
940     /**
941     * @dev Compara two numbers, and return the bigger one.
942     */
943     function min(int256 a, int256 b) internal pure returns (int256) {
944         if (a < b) {
945             return a;
946         } else {
947             return b;
948         }
949     }
950 
951 
952 }
953 
954 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
955 /// @author Ethernatus - Fernando Pauer
956 contract EthernautsLogic is EthernautsOwnership {
957 
958     // Set in case the logic contract is broken and an upgrade is required
959     address public newContractAddress;
960 
961     /// @dev Constructor
962     function EthernautsLogic() public {
963         // the creator of the contract is the initial CEO, COO, CTO
964         ceoAddress = msg.sender;
965         ctoAddress = msg.sender;
966         cooAddress = msg.sender;
967         oracleAddress = msg.sender;
968 
969         // Starts paused.
970         paused = true;
971     }
972 
973     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
974     ///  breaking bug. This method does nothing but keep track of the new contract and
975     ///  emit a message indicating that the new address is set. It's up to clients of this
976     ///  contract to update to the new contract address in that case. (This contract will
977     ///  be paused indefinitely if such an upgrade takes place.)
978     /// @param _v2Address new address
979     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
980         // See README.md for updgrade plan
981         newContractAddress = _v2Address;
982         ContractUpgrade(_v2Address);
983     }
984 
985     /// @dev set a new reference to the NFT ownership contract
986     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
987     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
988         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
989         require(candidateContract.isEthernautsStorage());
990         ethernautsStorage = candidateContract;
991     }
992 
993     /// @dev Override unpause so it requires all external contract addresses
994     ///  to be set before contract can be unpaused. Also, we can't have
995     ///  newContractAddress set either, because then the contract was upgraded.
996     /// @notice This is public rather than external so we can call super.unpause
997     ///  without using an expensive CALL.
998     function unpause() public onlyCEO whenPaused {
999         require(ethernautsStorage != address(0));
1000         require(newContractAddress == address(0));
1001         // require this contract to have access to storage contract
1002         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1003 
1004         // Actually unpause the contract.
1005         super.unpause();
1006     }
1007 
1008     // @dev Allows the COO to capture the balance available to the contract.
1009     function withdrawBalances(address _to) public onlyCLevel {
1010         _to.transfer(this.balance);
1011     }
1012 
1013     /// return current contract balance
1014     function getBalance() public view onlyCLevel returns (uint256) {
1015         return this.balance;
1016     }
1017 }
1018 
1019 /// @title Clock auction for non-fungible tokens.
1020 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1021 ///         This provides public methods for Upgrade ship.
1022 ///
1023 ///      - UpgradeShip: This provides public methods for managing how and if a ship can upgrade.
1024 ///             The user can place a number of Ship Upgrades on the ship to affect the ship’s exploration.
1025 ///             Combining the Explore and Upgrade actions together limits the amount of gas the user has to pay.
1026 /// @author Ethernatus - Fernando Pauer
1027 contract EthernautsUpgrade is EthernautsLogic {
1028 
1029     /// @dev Constructor creates a reference to the NFT ownership contract
1030     ///  and verifies the owner cut is in the valid range.
1031     ///  and Delegate constructor to Nonfungible contract.
1032     function EthernautsUpgrade() public
1033     EthernautsLogic() {}
1034 
1035     /*** EVENTS ***/
1036     /// @dev The Upgrade event is fired whenever a ship is upgraded.
1037     event Upgrade(uint256 indexed tokenId);
1038 
1039     /*** CONSTANTS ***/
1040     uint8 STATS_CAPOUT = 2**8 - 1; // all stats have a range from 0 to 255
1041 
1042     // The max level a ship can upgrade
1043     uint8 public MAX_LEVEL = 6;
1044 
1045     // ************************* UPGRADE SHIP ****************************
1046 
1047     function setMaxLevel(uint8 _max) public onlyCLevel {
1048         MAX_LEVEL = _max;
1049     }
1050 
1051     /// @notice Check and define how a ship can upgrade
1052     /// Example:
1053     /// User A wants to Upgrade Ship A. Ship A has 5 available upgrade slots.
1054     /// Thankfully, User A has 5 Ship Upgrades in their inventory.
1055     /// They have 1x Plasma Cannons (+1 Attack), Hardened Plates (+2 Defense),
1056     ///           1x Navigation Processor (+1 Range), 1x Engine Tune (+2 Speed), and Lucky Shamrock (+1 Luck) .
1057     /// User A drags the 5 Ship Upgrades into the appropriate slots and hits the Upgrade button.
1058     /// Ship A’s stats are now improved by +1 Attack, +2 Defense, +1 Range, +2 Speed, and +1 Luck, forever.
1059     /// The Ship Upgrades are consumed and disappear. The Ship then increases in level +1 to a total level of 2.
1060     /// @param _tokenId The Token ID that can be upgraded
1061     /// @param _objects List of objects to be used in the upgrade
1062     function upgradeShip(uint256 _tokenId, uint256[SHIP_SLOTS] _objects) external whenNotPaused {
1063         // Checking if Asset is a ship or not
1064         require(ethernautsStorage.isCategory(_tokenId, uint8(AssetCategory.Ship)));
1065 
1066         // Ensure the Ship is in available state, otherwise it cannot be upgraded
1067         require(ethernautsStorage.isState(_tokenId, uint8(AssetState.Available)));
1068 
1069         // only owner can upgrade his/her ship
1070         require(msg.sender == ethernautsStorage.ownerOf(_tokenId));
1071 
1072         // ship could not be in exploration
1073         require(!isExploring(_tokenId));
1074 
1075         // get ship and objects current stats
1076         uint i = 0;
1077         uint8[STATS_SIZE] memory _shipStats = ethernautsStorage.getStats(_tokenId);
1078         uint256 level = _shipStats[uint(ShipStats.Level)];
1079         uint8[STATS_SIZE][SHIP_SLOTS] memory _objectsStats;
1080 
1081         // check if level capped out, if yes no more upgrade is available
1082         require(level < MAX_LEVEL);
1083 
1084         // a mapping to require upgrades should have different token ids
1085         uint256[] memory upgradesToTokenIndex = new uint256[](ethernautsStorage.totalSupply());
1086 
1087         // all objects must be available to use
1088         for(i = 0; i < _objects.length; i++) {
1089             // sender should owner all assets
1090             require(msg.sender == ethernautsStorage.ownerOf(_objects[i]));
1091             require(!isExploring(_objects[i]));
1092             require(ethernautsStorage.isCategory(_objects[i], uint8(AssetCategory.Object)));
1093             // avoiding duplicate keys
1094             require(upgradesToTokenIndex[_objects[i]] == 0);
1095 
1096             // mark token id as read and avoid duplicated token ids
1097             upgradesToTokenIndex[_objects[i]] = _objects[i];
1098             _objectsStats[i] = ethernautsStorage.getStats(_objects[i]);
1099         }
1100 
1101         // upgrading stats
1102         uint256 attack = _shipStats[uint(ShipStats.Attack)];
1103         uint256 defense = _shipStats[uint(ShipStats.Defense)];
1104         uint256 speed = _shipStats[uint(ShipStats.Speed)];
1105         uint256 range = _shipStats[uint(ShipStats.Range)];
1106         uint256 luck = _shipStats[uint(ShipStats.Luck)];
1107 
1108         for(i = 0; i < SHIP_SLOTS; i++) {
1109             // Only objects with upgrades are allowed
1110             require(_objectsStats[i][1] +
1111                     _objectsStats[i][2] +
1112                     _objectsStats[i][3] +
1113                     _objectsStats[i][4] +
1114                     _objectsStats[i][5] > 0);
1115 
1116             attack += _objectsStats[i][uint(ShipStats.Attack)];
1117             defense += _objectsStats[i][uint(ShipStats.Defense)];
1118             speed += _objectsStats[i][uint(ShipStats.Speed)];
1119             range += _objectsStats[i][uint(ShipStats.Range)];
1120             luck += _objectsStats[i][uint(ShipStats.Luck)];
1121         }
1122 
1123         if (attack > STATS_CAPOUT) {
1124             attack = STATS_CAPOUT;
1125         }
1126         if (defense > STATS_CAPOUT) {
1127             defense = STATS_CAPOUT;
1128         }
1129         if (speed > STATS_CAPOUT) {
1130             speed = STATS_CAPOUT;
1131         }
1132         if (range > STATS_CAPOUT) {
1133             range = STATS_CAPOUT;
1134         }
1135         if (luck > STATS_CAPOUT) {
1136             luck = STATS_CAPOUT;
1137         }
1138 
1139         // All stats must increase, even if its provided 5 upgrades in the slots
1140         require(attack > _shipStats[uint(ShipStats.Attack)]);
1141         require(defense > _shipStats[uint(ShipStats.Defense)]);
1142         require(speed > _shipStats[uint(ShipStats.Speed)]);
1143         require(range > _shipStats[uint(ShipStats.Range)]);
1144         require(luck > _shipStats[uint(ShipStats.Luck)]);
1145 
1146         _shipStats[uint(ShipStats.Level)] = uint8(level + 1);
1147         _shipStats[uint(ShipStats.Attack)] = uint8(attack);
1148         _shipStats[uint(ShipStats.Defense)] = uint8(defense);
1149         _shipStats[uint(ShipStats.Speed)] = uint8(speed);
1150         _shipStats[uint(ShipStats.Range)] = uint8(range);
1151         _shipStats[uint(ShipStats.Luck)] = uint8(luck);
1152 
1153         // only upgrade after confirmed transaction by Upgrade Ship Contract
1154         ethernautsStorage.updateStats(_tokenId, _shipStats);
1155 
1156         // mark all objects as used and change owner
1157         for(i = 0; i < _objects.length; i++) {
1158             ethernautsStorage.updateState(_objects[i], uint8(AssetState.Used));
1159 
1160             // Register the approval and transfer to upgrade ship contract
1161             _approve(_objects[i], address(this));
1162             _transferFrom(msg.sender, address(this), _objects[i]);
1163         }
1164 
1165         Upgrade(_tokenId);
1166     }
1167 
1168     function transfer(
1169         address _to,
1170         uint256 _tokenId
1171     )
1172     external onlyOracle whenNotPaused
1173     {
1174         // Safety check to prevent against an unexpected 0x0 default.
1175         require(_to != address(0));
1176         // Disallow transfers to this contract to prevent accidental misuse.
1177         // The contract should never own any assets
1178         // (except very briefly after it is created and before it goes on auction).
1179         require(_to != address(this));
1180         // Disallow transfers to the storage contract to prevent accidental
1181         // misuse. Auction or Upgrade contracts should only take ownership of assets
1182         // through the allow + transferFrom flow.
1183         require(_to != address(ethernautsStorage));
1184 
1185         // Contract needs to own asset.
1186         require(_owns(address(this), _tokenId));
1187 
1188         // Reassign ownership, clear pending approvals, emit Transfer event.
1189         _approve(_tokenId, _to);
1190         ethernautsStorage.transfer(address(this), _to, _tokenId);
1191     }
1192 
1193 }