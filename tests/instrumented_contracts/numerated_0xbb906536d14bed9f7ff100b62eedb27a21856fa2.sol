1 pragma solidity ^0.4.19;
2 
3 
4 
5 
6 
7 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
8 contract EthernautsBase {
9 
10     /*** CONSTANTS USED ACROSS CONTRACTS ***/
11 
12     /// @dev Used by all contracts that interfaces with Ethernauts
13     ///      The ERC-165 interface signature for ERC-721.
14     ///  Ref: https://github.com/ethereum/EIPs/issues/165
15     ///  Ref: https://github.com/ethereum/EIPs/issues/721
16     bytes4 constant InterfaceSignature_ERC721 =
17     bytes4(keccak256('name()')) ^
18     bytes4(keccak256('symbol()')) ^
19     bytes4(keccak256('totalSupply()')) ^
20     bytes4(keccak256('balanceOf(address)')) ^
21     bytes4(keccak256('ownerOf(uint256)')) ^
22     bytes4(keccak256('approve(address,uint256)')) ^
23     bytes4(keccak256('transfer(address,uint256)')) ^
24     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
25     bytes4(keccak256('takeOwnership(uint256)')) ^
26     bytes4(keccak256('tokensOfOwner(address)')) ^
27     bytes4(keccak256('tokenMetadata(uint256,string)'));
28 
29     /// @dev due solidity limitation we cannot return dynamic array from methods
30     /// so it creates incompability between functions across different contracts
31     uint8 public constant STATS_SIZE = 10;
32     uint8 public constant SHIP_SLOTS = 5;
33 
34     // Possible state of any asset
35     enum AssetState { Available, UpForLease, Used }
36 
37     // Possible state of any asset
38     // NotValid is to avoid 0 in places where category must be bigger than zero
39     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
40 
41     /// @dev Sector stats
42     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
43     /// @notice Possible attributes for each asset
44     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
45     /// 00000010 - Producible - Product of a factory and/or factory contract.
46     /// 00000100 - Explorable- Product of exploration.
47     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
48     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
49     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
50     /// 01000000 - Tradable - Buyable and sellable on the market.
51     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
52     bytes2 public ATTR_SEEDED     = bytes2(2**0);
53     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
54     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
55     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
56     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
57     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
58     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
59     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
60 }
61 
62 /// @title Inspired by https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
63 /// @notice This contract manages the various addresses and constraints for operations
64 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
65 contract EthernautsAccessControl is EthernautsBase {
66 
67     // This facet controls access control for Ethernauts.
68     // All roles have same responsibilities and rights, but there is slight differences between them:
69     //
70     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
71     //       It is initially set to the address that created the smart contract.
72     //
73     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
74     //
75     //     - The COO: The COO can change contract address and add create assets.
76     //
77     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
78     /// @param newContract address pointing to new contract
79     event ContractUpgrade(address newContract);
80 
81     // The addresses of the accounts (or contracts) that can execute actions within each roles.
82     address public ceoAddress;
83     address public ctoAddress;
84     address public cooAddress;
85     address public oracleAddress;
86 
87     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
88     bool public paused = false;
89 
90     /// @dev Access modifier for CEO-only functionality
91     modifier onlyCEO() {
92         require(msg.sender == ceoAddress);
93         _;
94     }
95 
96     /// @dev Access modifier for CTO-only functionality
97     modifier onlyCTO() {
98         require(msg.sender == ctoAddress);
99         _;
100     }
101 
102     /// @dev Access modifier for CTO-only functionality
103     modifier onlyOracle() {
104         require(msg.sender == oracleAddress);
105         _;
106     }
107 
108     modifier onlyCLevel() {
109         require(
110             msg.sender == ceoAddress ||
111             msg.sender == ctoAddress ||
112             msg.sender == cooAddress
113         );
114         _;
115     }
116 
117     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
118     /// @param _newCEO The address of the new CEO
119     function setCEO(address _newCEO) external onlyCEO {
120         require(_newCEO != address(0));
121 
122         ceoAddress = _newCEO;
123     }
124 
125     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
126     /// @param _newCTO The address of the new CTO
127     function setCTO(address _newCTO) external {
128         require(
129             msg.sender == ceoAddress ||
130             msg.sender == ctoAddress
131         );
132         require(_newCTO != address(0));
133 
134         ctoAddress = _newCTO;
135     }
136 
137     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
138     /// @param _newCOO The address of the new COO
139     function setCOO(address _newCOO) external {
140         require(
141             msg.sender == ceoAddress ||
142             msg.sender == cooAddress
143         );
144         require(_newCOO != address(0));
145 
146         cooAddress = _newCOO;
147     }
148 
149     /// @dev Assigns a new address to act as oracle.
150     /// @param _newOracle The address of oracle
151     function setOracle(address _newOracle) external {
152         require(msg.sender == ctoAddress);
153         require(_newOracle != address(0));
154 
155         oracleAddress = _newOracle;
156     }
157 
158     /*** Pausable functionality adapted from OpenZeppelin ***/
159 
160     /// @dev Modifier to allow actions only when the contract IS NOT paused
161     modifier whenNotPaused() {
162         require(!paused);
163         _;
164     }
165 
166     /// @dev Modifier to allow actions only when the contract IS paused
167     modifier whenPaused {
168         require(paused);
169         _;
170     }
171 
172     /// @dev Called by any "C-level" role to pause the contract. Used only when
173     ///  a bug or exploit is detected and we need to limit damage.
174     function pause() external onlyCLevel whenNotPaused {
175         paused = true;
176     }
177 
178     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
179     ///  one reason we may pause the contract is when CTO account is compromised.
180     /// @notice This is public rather than external so it can be called by
181     ///  derived contracts.
182     function unpause() public onlyCEO whenPaused {
183         // can't unpause if contract was upgraded
184         paused = false;
185     }
186 
187 }
188 
189 /// @title Storage contract for Ethernauts Data. Common structs and constants.
190 /// @notice This is our main data storage, constants and data types, plus
191 //          internal functions for managing the assets. It is isolated and only interface with
192 //          a list of granted contracts defined by CTO
193 /// @author Ethernauts - Fernando Pauer
194 contract EthernautsStorage is EthernautsAccessControl {
195 
196     function EthernautsStorage() public {
197         // the creator of the contract is the initial CEO
198         ceoAddress = msg.sender;
199 
200         // the creator of the contract is the initial CTO as well
201         ctoAddress = msg.sender;
202 
203         // the creator of the contract is the initial CTO as well
204         cooAddress = msg.sender;
205 
206         // the creator of the contract is the initial Oracle as well
207         oracleAddress = msg.sender;
208     }
209 
210     /// @notice No tipping!
211     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
212     function() external payable {
213         require(msg.sender == address(this));
214     }
215 
216     /*** Mapping for Contracts with granted permission ***/
217     mapping (address => bool) public contractsGrantedAccess;
218 
219     /// @dev grant access for a contract to interact with this contract.
220     /// @param _v2Address The contract address to grant access
221     function grantAccess(address _v2Address) public onlyCTO {
222         // See README.md for updgrade plan
223         contractsGrantedAccess[_v2Address] = true;
224     }
225 
226     /// @dev remove access from a contract to interact with this contract.
227     /// @param _v2Address The contract address to be removed
228     function removeAccess(address _v2Address) public onlyCTO {
229         // See README.md for updgrade plan
230         delete contractsGrantedAccess[_v2Address];
231     }
232 
233     /// @dev Only allow permitted contracts to interact with this contract
234     modifier onlyGrantedContracts() {
235         require(contractsGrantedAccess[msg.sender] == true);
236         _;
237     }
238 
239     modifier validAsset(uint256 _tokenId) {
240         require(assets[_tokenId].ID > 0);
241         _;
242     }
243     /*** DATA TYPES ***/
244 
245     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
246     ///  of this structure. Note that the order of the members in this structure
247     ///  is important because of the byte-packing rules used by Ethereum.
248     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
249     struct Asset {
250 
251         // Asset ID is a identifier for look and feel in frontend
252         uint16 ID;
253 
254         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
255         uint8 category;
256 
257         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
258         uint8 state;
259 
260         // Attributes
261         // byte pos - Definition
262         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
263         // 00000010 - Producible - Product of a factory and/or factory contract.
264         // 00000100 - Explorable- Product of exploration.
265         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
266         // 00010000 - Permanent - Cannot be removed, always owned by a user.
267         // 00100000 - Consumable - Destroyed after N exploration expeditions.
268         // 01000000 - Tradable - Buyable and sellable on the market.
269         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
270         bytes2 attributes;
271 
272         // The timestamp from the block when this asset was created.
273         uint64 createdAt;
274 
275         // The minimum timestamp after which this asset can engage in exploring activities again.
276         uint64 cooldownEndBlock;
277 
278         // The Asset's stats can be upgraded or changed based on exploration conditions.
279         // It will be defined per child contract, but all stats have a range from 0 to 255
280         // Examples
281         // 0 = Ship Level
282         // 1 = Ship Attack
283         uint8[STATS_SIZE] stats;
284 
285         // Set to the cooldown time that represents exploration duration for this asset.
286         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
287         uint256 cooldown;
288 
289         // a reference to a super asset that manufactured the asset
290         uint256 builtBy;
291     }
292 
293     /*** CONSTANTS ***/
294 
295     // @dev Sanity check that allows us to ensure that we are pointing to the
296     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
297     bool public isEthernautsStorage = true;
298 
299     /*** STORAGE ***/
300 
301     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
302     ///  of each asset is actually an index into this array.
303     Asset[] public assets;
304 
305     /// @dev A mapping from Asset UniqueIDs to the price of the token.
306     /// stored outside Asset Struct to save gas, because price can change frequently
307     mapping (uint256 => uint256) internal assetIndexToPrice;
308 
309     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
310     mapping (uint256 => address) internal assetIndexToOwner;
311 
312     // @dev A mapping from owner address to count of tokens that address owns.
313     //  Used internally inside balanceOf() to resolve ownership count.
314     mapping (address => uint256) internal ownershipTokenCount;
315 
316     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
317     ///  transferFrom(). Each Asset can only have one approved address for transfer
318     ///  at any time. A zero value means no approval is outstanding.
319     mapping (uint256 => address) internal assetIndexToApproved;
320 
321 
322     /*** SETTERS ***/
323 
324     /// @dev set new asset price
325     /// @param _tokenId  asset UniqueId
326     /// @param _price    asset price
327     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
328         assetIndexToPrice[_tokenId] = _price;
329     }
330 
331     /// @dev Mark transfer as approved
332     /// @param _tokenId  asset UniqueId
333     /// @param _approved address approved
334     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
335         assetIndexToApproved[_tokenId] = _approved;
336     }
337 
338     /// @dev Assigns ownership of a specific Asset to an address.
339     /// @param _from    current owner address
340     /// @param _to      new owner address
341     /// @param _tokenId asset UniqueId
342     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
343         // Since the number of assets is capped to 2^32 we can't overflow this
344         ownershipTokenCount[_to]++;
345         // transfer ownership
346         assetIndexToOwner[_tokenId] = _to;
347         // When creating new assets _from is 0x0, but we can't account that address.
348         if (_from != address(0)) {
349             ownershipTokenCount[_from]--;
350             // clear any previously approved ownership exchange
351             delete assetIndexToApproved[_tokenId];
352         }
353     }
354 
355     /// @dev A public method that creates a new asset and stores it. This
356     ///  method does basic checking and should only be called from other contract when the
357     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
358     /// @param _creatorTokenID The asset who is father of this asset
359     /// @param _owner First owner of this asset
360     /// @param _price asset price
361     /// @param _ID asset ID
362     /// @param _category see Asset Struct description
363     /// @param _state see Asset Struct description
364     /// @param _attributes see Asset Struct description
365     /// @param _stats see Asset Struct description
366     function createAsset(
367         uint256 _creatorTokenID,
368         address _owner,
369         uint256 _price,
370         uint16 _ID,
371         uint8 _category,
372         uint8 _state,
373         uint8 _attributes,
374         uint8[STATS_SIZE] _stats,
375         uint256 _cooldown,
376         uint64 _cooldownEndBlock
377     )
378     public onlyGrantedContracts
379     returns (uint256)
380     {
381         // Ensure our data structures are always valid.
382         require(_ID > 0);
383         require(_category > 0);
384         require(_attributes != 0x0);
385         require(_stats.length > 0);
386 
387         Asset memory asset = Asset({
388             ID: _ID,
389             category: _category,
390             builtBy: _creatorTokenID,
391             attributes: bytes2(_attributes),
392             stats: _stats,
393             state: _state,
394             createdAt: uint64(now),
395             cooldownEndBlock: _cooldownEndBlock,
396             cooldown: _cooldown
397         });
398 
399         uint256 newAssetUniqueId = assets.push(asset) - 1;
400 
401         // Check it reached 4 billion assets but let's just be 100% sure.
402         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
403 
404         // store price
405         assetIndexToPrice[newAssetUniqueId] = _price;
406 
407         // This will assign ownership
408         transfer(address(0), _owner, newAssetUniqueId);
409 
410         return newAssetUniqueId;
411     }
412 
413     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
414     /// This method doesn't do any checking and should only be called when the
415     ///  input data is known to be valid.
416     /// @param _tokenId The token ID
417     /// @param _creatorTokenID The asset that create that token
418     /// @param _price asset price
419     /// @param _ID asset ID
420     /// @param _category see Asset Struct description
421     /// @param _state see Asset Struct description
422     /// @param _attributes see Asset Struct description
423     /// @param _stats see Asset Struct description
424     /// @param _cooldown asset cooldown index
425     function editAsset(
426         uint256 _tokenId,
427         uint256 _creatorTokenID,
428         uint256 _price,
429         uint16 _ID,
430         uint8 _category,
431         uint8 _state,
432         uint8 _attributes,
433         uint8[STATS_SIZE] _stats,
434         uint16 _cooldown
435     )
436     external validAsset(_tokenId) onlyCLevel
437     returns (uint256)
438     {
439         // Ensure our data structures are always valid.
440         require(_ID > 0);
441         require(_category > 0);
442         require(_attributes != 0x0);
443         require(_stats.length > 0);
444 
445         // store price
446         assetIndexToPrice[_tokenId] = _price;
447 
448         Asset storage asset = assets[_tokenId];
449         asset.ID = _ID;
450         asset.category = _category;
451         asset.builtBy = _creatorTokenID;
452         asset.attributes = bytes2(_attributes);
453         asset.stats = _stats;
454         asset.state = _state;
455         asset.cooldown = _cooldown;
456     }
457 
458     /// @dev Update only stats
459     /// @param _tokenId asset UniqueId
460     /// @param _stats asset state, see Asset Struct description
461     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
462         assets[_tokenId].stats = _stats;
463     }
464 
465     /// @dev Update only asset state
466     /// @param _tokenId asset UniqueId
467     /// @param _state asset state, see Asset Struct description
468     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
469         assets[_tokenId].state = _state;
470     }
471 
472     /// @dev Update Cooldown for a single asset
473     /// @param _tokenId asset UniqueId
474     /// @param _cooldown asset state, see Asset Struct description
475     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
476     public validAsset(_tokenId) onlyGrantedContracts {
477         assets[_tokenId].cooldown = _cooldown;
478         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
479     }
480 
481     /*** GETTERS ***/
482 
483     /// @notice Returns only stats data about a specific asset.
484     /// @dev it is necessary due solidity compiler limitations
485     ///      when we have large qty of parameters it throws StackTooDeepException
486     /// @param _tokenId The UniqueId of the asset of interest.
487     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
488         return assets[_tokenId].stats;
489     }
490 
491     /// @dev return current price of an asset
492     /// @param _tokenId asset UniqueId
493     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
494         return assetIndexToPrice[_tokenId];
495     }
496 
497     /// @notice Check if asset has all attributes passed by parameter
498     /// @param _tokenId The UniqueId of the asset of interest.
499     /// @param _attributes see Asset Struct description
500     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
501         return assets[_tokenId].attributes & _attributes == _attributes;
502     }
503 
504     /// @notice Check if asset has any attribute passed by parameter
505     /// @param _tokenId The UniqueId of the asset of interest.
506     /// @param _attributes see Asset Struct description
507     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
508         return assets[_tokenId].attributes & _attributes != 0x0;
509     }
510 
511     /// @notice Check if asset is in the state passed by parameter
512     /// @param _tokenId The UniqueId of the asset of interest.
513     /// @param _category see AssetCategory in EthernautsBase for possible states
514     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
515         return assets[_tokenId].category == _category;
516     }
517 
518     /// @notice Check if asset is in the state passed by parameter
519     /// @param _tokenId The UniqueId of the asset of interest.
520     /// @param _state see enum AssetState in EthernautsBase for possible states
521     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
522         return assets[_tokenId].state == _state;
523     }
524 
525     /// @notice Returns owner of a given Asset(Token).
526     /// @dev Required for ERC-721 compliance.
527     /// @param _tokenId asset UniqueId
528     function ownerOf(uint256 _tokenId) public view returns (address owner)
529     {
530         return assetIndexToOwner[_tokenId];
531     }
532 
533     /// @dev Required for ERC-721 compliance
534     /// @notice Returns the number of Assets owned by a specific address.
535     /// @param _owner The owner address to check.
536     function balanceOf(address _owner) public view returns (uint256 count) {
537         return ownershipTokenCount[_owner];
538     }
539 
540     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
541     /// @param _tokenId asset UniqueId
542     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
543         return assetIndexToApproved[_tokenId];
544     }
545 
546     /// @notice Returns the total number of Assets currently in existence.
547     /// @dev Required for ERC-721 compliance.
548     function totalSupply() public view returns (uint256) {
549         return assets.length;
550     }
551 
552     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
553     /// @param _owner filter all assets by owner
554     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
555         uint256[6][]
556     ) {
557         uint256 totalAssets = assets.length;
558 
559         if (totalAssets == 0) {
560             // Return an empty array
561             return new uint256[6][](0);
562         } else {
563             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
564             uint256 resultIndex = 0;
565             bytes2 hasAttributes  = bytes2(_withAttributes);
566             Asset memory asset;
567 
568             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
569                 asset = assets[tokenId];
570                 if (
571                     (asset.state != uint8(AssetState.Used)) &&
572                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
573                     (asset.attributes & hasAttributes == hasAttributes)
574                 ) {
575                     result[resultIndex][0] = tokenId;
576                     result[resultIndex][1] = asset.ID;
577                     result[resultIndex][2] = asset.category;
578                     result[resultIndex][3] = uint256(asset.attributes);
579                     result[resultIndex][4] = asset.cooldown;
580                     result[resultIndex][5] = assetIndexToPrice[tokenId];
581                     resultIndex++;
582                 }
583             }
584 
585             return result;
586         }
587     }
588 }