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
103 /// @title Auction Core
104 /// @dev Contains models, variables, and internal methods for the auction.
105 /// @notice We omit a fallback function to prevent accidental sends to this contract.
106 contract ClockAuctionBase {
107 
108     // Represents an auction on an NFT
109     struct Auction {
110         // Current owner of NFT
111         address seller;
112         // Price (in wei) at beginning of auction
113         uint128 startingPrice;
114         // Price (in wei) at end of auction
115         uint128 endingPrice;
116         // Duration (in seconds) of auction
117         uint64 duration;
118         // Time when auction started
119         // NOTE: 0 if this auction has been concluded
120         uint64 startedAt;
121     }
122 
123     // Reference to contract tracking NFT ownership
124     ERC721 public nonFungibleContract;
125 
126     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
127     // Values 0-10,000 map to 0%-100%
128     uint256 public ownerCut;
129 
130     // Map from token ID to their corresponding auction.
131     mapping (uint256 => Auction) tokenIdToAuction;
132 
133     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
134     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
135     event AuctionCancelled(uint256 tokenId);
136 
137     /// @dev Returns true if the claimant owns the token.
138     /// @param _claimant - Address claiming to own the token.
139     /// @param _tokenId - ID of token whose ownership to verify.
140     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
141         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
142     }
143 
144     /// @dev Transfers an NFT owned by this contract to another address.
145     /// Returns true if the transfer succeeds.
146     /// @param _receiver - Address to transfer NFT to.
147     /// @param _tokenId - ID of token to transfer.
148     function _transfer(address _receiver, uint256 _tokenId) internal {
149         // it will throw if transfer fails
150         nonFungibleContract.transfer(_receiver, _tokenId);
151     }
152 
153     /// @dev Adds an auction to the list of open auctions. Also fires the
154     ///  AuctionCreated event.
155     /// @param _tokenId The ID of the token to be put on auction.
156     /// @param _auction Auction to add.
157     function _addAuction(uint256 _tokenId, Auction _auction) internal {
158         // Require that all auctions have a duration of
159         // at least one minute. (Keeps our math from getting hairy!)
160         require(_auction.duration >= 1 minutes);
161 
162         tokenIdToAuction[_tokenId] = _auction;
163 
164         AuctionCreated(
165             uint256(_tokenId),
166             uint256(_auction.startingPrice),
167             uint256(_auction.endingPrice),
168             uint256(_auction.duration)
169         );
170     }
171 
172     /// @dev Cancels an auction unconditionally.
173     function _cancelAuction(uint256 _tokenId, address _seller) internal {
174         _removeAuction(_tokenId);
175         _transfer(_seller, _tokenId);
176         AuctionCancelled(_tokenId);
177     }
178 
179     /// @dev Computes the price and transfers winnings.
180     /// Does NOT transfer ownership of token.
181     function _bid(uint256 _tokenId, uint256 _bidAmount)
182     internal
183     returns (uint256)
184     {
185         // Get a reference to the auction struct
186         Auction storage auction = tokenIdToAuction[_tokenId];
187 
188         // Explicitly check that this auction is currently live.
189         // (Because of how Ethereum mappings work, we can't just count
190         // on the lookup above failing. An invalid _tokenId will just
191         // return an auction object that is all zeros.)
192         require(_isOnAuction(auction));
193 
194         // Check that the bid is greater than or equal to the current price
195         uint256 price = _currentPrice(auction);
196         require(_bidAmount >= price);
197 
198         // Grab a reference to the seller before the auction struct
199         // gets deleted.
200         address seller = auction.seller;
201 
202         // The bid is good! Remove the auction before sending the fees
203         // to the sender so we can't have a reentrancy attack.
204         _removeAuction(_tokenId);
205 
206         // Transfer proceeds to seller (if there are any!)
207         if (price > 0) {
208             // Calculate the auctioneer's cut.
209             // (NOTE: _computeCut() is guaranteed to return a
210             // value <= price, so this subtraction can't go negative.)
211             uint256 auctioneerCut = _computeCut(price);
212             uint256 sellerProceeds = price - auctioneerCut;
213 
214             // NOTE: Doing a transfer() in the middle of a complex
215             // method like this is generally discouraged because of
216             // reentrancy attacks and DoS attacks if the seller is
217             // a contract with an invalid fallback function. We explicitly
218             // guard against reentrancy attacks by removing the auction
219             // before calling transfer(), and the only thing the seller
220             // can DoS is the sale of their own asset! (And if it's an
221             // accident, they can call cancelAuction(). )
222             seller.transfer(sellerProceeds);
223         }
224 
225         // Calculate any excess funds included with the bid. If the excess
226         // is anything worth worrying about, transfer it back to bidder.
227         // NOTE: We checked above that the bid amount is greater than or
228         // equal to the price so this cannot underflow.
229         uint256 bidExcess = _bidAmount - price;
230 
231         // Return the funds. Similar to the previous transfer, this is
232         // not susceptible to a re-entry attack because the auction is
233         // removed before any transfers occur.
234         msg.sender.transfer(bidExcess);
235 
236         // Tell the world!
237         AuctionSuccessful(_tokenId, price, msg.sender);
238 
239         return price;
240     }
241 
242     /// @dev Removes an auction from the list of open auctions.
243     /// @param _tokenId - ID of NFT on auction.
244     function _removeAuction(uint256 _tokenId) internal {
245         delete tokenIdToAuction[_tokenId];
246     }
247 
248     /// @dev Returns true if the NFT is on auction.
249     /// @param _auction - Auction to check.
250     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
251         return (_auction.startedAt > 0);
252     }
253 
254     /// @dev Returns current price of an NFT on auction. Broken into two
255     ///  functions (this one, that computes the duration from the auction
256     ///  structure, and the other that does the price computation) so we
257     ///  can easily test that the price computation works correctly.
258     function _currentPrice(Auction storage _auction)
259     internal
260     view
261     returns (uint256)
262     {
263         uint256 secondsPassed = 0;
264 
265         // A bit of insurance against negative values (or wraparound).
266         // Probably not necessary (since Ethereum guarnatees that the
267         // now variable doesn't ever go backwards).
268         if (now > _auction.startedAt) {
269             secondsPassed = now - _auction.startedAt;
270         }
271 
272         return _computeCurrentPrice(
273             _auction.startingPrice,
274             _auction.endingPrice,
275             _auction.duration,
276             secondsPassed
277         );
278     }
279 
280     /// @dev Computes the current price of an auction. Factored out
281     ///  from _currentPrice so we can run extensive unit tests.
282     ///  When testing, make this function public and turn on
283     ///  `Current price computation` test suite.
284     function _computeCurrentPrice(
285         uint256 _startingPrice,
286         uint256 _endingPrice,
287         uint256 _duration,
288         uint256 _secondsPassed
289     )
290     internal
291     pure
292     returns (uint256)
293     {
294         // NOTE: We don't use SafeMath (or similar) in this function because
295         //  all of our public functions carefully cap the maximum values for
296         //  time (at 64-bits) and currency (at 128-bits). _duration is
297         //  also known to be non-zero (see the require() statement in
298         //  _addAuction())
299         if (_secondsPassed >= _duration) {
300             // We've reached the end of the dynamic pricing portion
301             // of the auction, just return the end price.
302             return _endingPrice;
303         } else {
304             // Starting price can be higher than ending price (and often is!), so
305             // this delta can be negative.
306             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
307 
308             // This multiplication can't overflow, _secondsPassed will easily fit within
309             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
310             // will always fit within 256-bits.
311             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
312 
313             // currentPriceChange can be negative, but if so, will have a magnitude
314             // less that _startingPrice. Thus, this result will always end up positive.
315             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
316 
317             return uint256(currentPrice);
318         }
319     }
320 
321     /// @dev Computes owner's cut of a sale.
322     /// @param _price - Sale price of NFT.
323     function _computeCut(uint256 _price) internal view returns (uint256) {
324         // NOTE: We don't use SafeMath (or similar) in this function because
325         //  all of our entry functions carefully cap the maximum values for
326         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
327         //  statement in the EhternautsMarket constructor). The result of this
328         //  function is always guaranteed to be <= _price.
329         return SafeMath.div(SafeMath.mul(_price, ownerCut), 10000);
330     }
331 
332 }
333 
334 
335 
336 
337 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
338 contract EthernautsBase {
339 
340     /*** CONSTANTS USED ACROSS CONTRACTS ***/
341 
342     /// @dev Used by all contracts that interfaces with Ethernauts
343     ///      The ERC-165 interface signature for ERC-721.
344     ///  Ref: https://github.com/ethereum/EIPs/issues/165
345     ///  Ref: https://github.com/ethereum/EIPs/issues/721
346     bytes4 constant InterfaceSignature_ERC721 =
347     bytes4(keccak256('name()')) ^
348     bytes4(keccak256('symbol()')) ^
349     bytes4(keccak256('totalSupply()')) ^
350     bytes4(keccak256('balanceOf(address)')) ^
351     bytes4(keccak256('ownerOf(uint256)')) ^
352     bytes4(keccak256('approve(address,uint256)')) ^
353     bytes4(keccak256('transfer(address,uint256)')) ^
354     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
355     bytes4(keccak256('takeOwnership(uint256)')) ^
356     bytes4(keccak256('tokensOfOwner(address)')) ^
357     bytes4(keccak256('tokenMetadata(uint256,string)'));
358 
359     /// @dev due solidity limitation we cannot return dynamic array from methods
360     /// so it creates incompability between functions across different contracts
361     uint8 public constant STATS_SIZE = 10;
362     uint8 public constant SHIP_SLOTS = 5;
363 
364     // Possible state of any asset
365     enum AssetState { Available, UpForLease, Used }
366 
367     // Possible state of any asset
368     // NotValid is to avoid 0 in places where category must be bigger than zero
369     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
370 
371     /// @dev Sector stats
372     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
373     /// @notice Possible attributes for each asset
374     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
375     /// 00000010 - Producible - Product of a factory and/or factory contract.
376     /// 00000100 - Explorable- Product of exploration.
377     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
378     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
379     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
380     /// 01000000 - Tradable - Buyable and sellable on the market.
381     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
382     bytes2 public ATTR_SEEDED     = bytes2(2**0);
383     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
384     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
385     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
386     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
387     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
388     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
389     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
390 }
391 
392 /// @notice This contract manages the various addresses and constraints for operations
393 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
394 contract EthernautsAccessControl is EthernautsBase {
395 
396     // This facet controls access control for Ethernauts.
397     // All roles have same responsibilities and rights, but there is slight differences between them:
398     //
399     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
400     //       It is initially set to the address that created the smart contract.
401     //
402     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
403     //
404     //     - The COO: The COO can change contract address and add create assets.
405     //
406     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
407     /// @param newContract address pointing to new contract
408     event ContractUpgrade(address newContract);
409 
410     // The addresses of the accounts (or contracts) that can execute actions within each roles.
411     address public ceoAddress;
412     address public ctoAddress;
413     address public cooAddress;
414     address public oracleAddress;
415 
416     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
417     bool public paused = false;
418 
419     /// @dev Access modifier for CEO-only functionality
420     modifier onlyCEO() {
421         require(msg.sender == ceoAddress);
422         _;
423     }
424 
425     /// @dev Access modifier for CTO-only functionality
426     modifier onlyCTO() {
427         require(msg.sender == ctoAddress);
428         _;
429     }
430 
431     /// @dev Access modifier for CTO-only functionality
432     modifier onlyOracle() {
433         require(msg.sender == oracleAddress);
434         _;
435     }
436 
437     modifier onlyCLevel() {
438         require(
439             msg.sender == ceoAddress ||
440             msg.sender == ctoAddress ||
441             msg.sender == cooAddress
442         );
443         _;
444     }
445 
446     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
447     /// @param _newCEO The address of the new CEO
448     function setCEO(address _newCEO) external onlyCEO {
449         require(_newCEO != address(0));
450 
451         ceoAddress = _newCEO;
452     }
453 
454     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
455     /// @param _newCTO The address of the new CTO
456     function setCTO(address _newCTO) external {
457         require(
458             msg.sender == ceoAddress ||
459             msg.sender == ctoAddress
460         );
461         require(_newCTO != address(0));
462 
463         ctoAddress = _newCTO;
464     }
465 
466     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
467     /// @param _newCOO The address of the new COO
468     function setCOO(address _newCOO) external {
469         require(
470             msg.sender == ceoAddress ||
471             msg.sender == cooAddress
472         );
473         require(_newCOO != address(0));
474 
475         cooAddress = _newCOO;
476     }
477 
478     /// @dev Assigns a new address to act as oracle.
479     /// @param _newOracle The address of oracle
480     function setOracle(address _newOracle) external {
481         require(msg.sender == ctoAddress);
482         require(_newOracle != address(0));
483 
484         oracleAddress = _newOracle;
485     }
486 
487     /*** Pausable functionality adapted from OpenZeppelin ***/
488 
489     /// @dev Modifier to allow actions only when the contract IS NOT paused
490     modifier whenNotPaused() {
491         require(!paused);
492         _;
493     }
494 
495     /// @dev Modifier to allow actions only when the contract IS paused
496     modifier whenPaused {
497         require(paused);
498         _;
499     }
500 
501     /// @dev Called by any "C-level" role to pause the contract. Used only when
502     ///  a bug or exploit is detected and we need to limit damage.
503     function pause() external onlyCLevel whenNotPaused {
504         paused = true;
505     }
506 
507     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
508     ///  one reason we may pause the contract is when CTO account is compromised.
509     /// @notice This is public rather than external so it can be called by
510     ///  derived contracts.
511     function unpause() public onlyCEO whenPaused {
512         // can't unpause if contract was upgraded
513         paused = false;
514     }
515 
516 }
517 
518 
519 
520 
521 
522 
523 
524 
525 
526 /// @title Storage contract for Ethernauts Data. Common structs and constants.
527 /// @notice This is our main data storage, constants and data types, plus
528 //          internal functions for managing the assets. It is isolated and only interface with
529 //          a list of granted contracts defined by CTO
530 /// @author Ethernauts - Fernando Pauer
531 contract EthernautsStorage is EthernautsAccessControl {
532 
533     function EthernautsStorage() public {
534         // the creator of the contract is the initial CEO
535         ceoAddress = msg.sender;
536 
537         // the creator of the contract is the initial CTO as well
538         ctoAddress = msg.sender;
539 
540         // the creator of the contract is the initial CTO as well
541         cooAddress = msg.sender;
542 
543         // the creator of the contract is the initial Oracle as well
544         oracleAddress = msg.sender;
545     }
546 
547     /// @notice No tipping!
548     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
549     function() external payable {
550         require(msg.sender == address(this));
551     }
552 
553     /*** Mapping for Contracts with granted permission ***/
554     mapping (address => bool) public contractsGrantedAccess;
555 
556     /// @dev grant access for a contract to interact with this contract.
557     /// @param _v2Address The contract address to grant access
558     function grantAccess(address _v2Address) public onlyCTO {
559         // See README.md for updgrade plan
560         contractsGrantedAccess[_v2Address] = true;
561     }
562 
563     /// @dev remove access from a contract to interact with this contract.
564     /// @param _v2Address The contract address to be removed
565     function removeAccess(address _v2Address) public onlyCTO {
566         // See README.md for updgrade plan
567         delete contractsGrantedAccess[_v2Address];
568     }
569 
570     /// @dev Only allow permitted contracts to interact with this contract
571     modifier onlyGrantedContracts() {
572         require(contractsGrantedAccess[msg.sender] == true);
573         _;
574     }
575 
576     modifier validAsset(uint256 _tokenId) {
577         require(assets[_tokenId].ID > 0);
578         _;
579     }
580     /*** DATA TYPES ***/
581 
582     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
583     ///  of this structure. Note that the order of the members in this structure
584     ///  is important because of the byte-packing rules used by Ethereum.
585     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
586     struct Asset {
587 
588         // Asset ID is a identifier for look and feel in frontend
589         uint16 ID;
590 
591         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
592         uint8 category;
593 
594         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
595         uint8 state;
596 
597         // Attributes
598         // byte pos - Definition
599         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
600         // 00000010 - Producible - Product of a factory and/or factory contract.
601         // 00000100 - Explorable- Product of exploration.
602         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
603         // 00010000 - Permanent - Cannot be removed, always owned by a user.
604         // 00100000 - Consumable - Destroyed after N exploration expeditions.
605         // 01000000 - Tradable - Buyable and sellable on the market.
606         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
607         bytes2 attributes;
608 
609         // The timestamp from the block when this asset was created.
610         uint64 createdAt;
611 
612         // The minimum timestamp after which this asset can engage in exploring activities again.
613         uint64 cooldownEndBlock;
614 
615         // The Asset's stats can be upgraded or changed based on exploration conditions.
616         // It will be defined per child contract, but all stats have a range from 0 to 255
617         // Examples
618         // 0 = Ship Level
619         // 1 = Ship Attack
620         uint8[STATS_SIZE] stats;
621 
622         // Set to the cooldown time that represents exploration duration for this asset.
623         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
624         uint256 cooldown;
625 
626         // a reference to a super asset that manufactured the asset
627         uint256 builtBy;
628     }
629 
630     /*** CONSTANTS ***/
631 
632     // @dev Sanity check that allows us to ensure that we are pointing to the
633     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
634     bool public isEthernautsStorage = true;
635 
636     /*** STORAGE ***/
637 
638     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
639     ///  of each asset is actually an index into this array.
640     Asset[] public assets;
641 
642     /// @dev A mapping from Asset UniqueIDs to the price of the token.
643     /// stored outside Asset Struct to save gas, because price can change frequently
644     mapping (uint256 => uint256) internal assetIndexToPrice;
645 
646     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
647     mapping (uint256 => address) internal assetIndexToOwner;
648 
649     // @dev A mapping from owner address to count of tokens that address owns.
650     //  Used internally inside balanceOf() to resolve ownership count.
651     mapping (address => uint256) internal ownershipTokenCount;
652 
653     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
654     ///  transferFrom(). Each Asset can only have one approved address for transfer
655     ///  at any time. A zero value means no approval is outstanding.
656     mapping (uint256 => address) internal assetIndexToApproved;
657 
658 
659     /*** SETTERS ***/
660 
661     /// @dev set new asset price
662     /// @param _tokenId  asset UniqueId
663     /// @param _price    asset price
664     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
665         assetIndexToPrice[_tokenId] = _price;
666     }
667 
668     /// @dev Mark transfer as approved
669     /// @param _tokenId  asset UniqueId
670     /// @param _approved address approved
671     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
672         assetIndexToApproved[_tokenId] = _approved;
673     }
674 
675     /// @dev Assigns ownership of a specific Asset to an address.
676     /// @param _from    current owner address
677     /// @param _to      new owner address
678     /// @param _tokenId asset UniqueId
679     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
680         // Since the number of assets is capped to 2^32 we can't overflow this
681         ownershipTokenCount[_to]++;
682         // transfer ownership
683         assetIndexToOwner[_tokenId] = _to;
684         // When creating new assets _from is 0x0, but we can't account that address.
685         if (_from != address(0)) {
686             ownershipTokenCount[_from]--;
687             // clear any previously approved ownership exchange
688             delete assetIndexToApproved[_tokenId];
689         }
690     }
691 
692     /// @dev A public method that creates a new asset and stores it. This
693     ///  method does basic checking and should only be called from other contract when the
694     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
695     /// @param _creatorTokenID The asset who is father of this asset
696     /// @param _owner First owner of this asset
697     /// @param _price asset price
698     /// @param _ID asset ID
699     /// @param _category see Asset Struct description
700     /// @param _state see Asset Struct description
701     /// @param _attributes see Asset Struct description
702     /// @param _stats see Asset Struct description
703     function createAsset(
704         uint256 _creatorTokenID,
705         address _owner,
706         uint256 _price,
707         uint16 _ID,
708         uint8 _category,
709         uint8 _state,
710         uint8 _attributes,
711         uint8[STATS_SIZE] _stats,
712         uint256 _cooldown,
713         uint64 _cooldownEndBlock
714     )
715     public onlyGrantedContracts
716     returns (uint256)
717     {
718         // Ensure our data structures are always valid.
719         require(_ID > 0);
720         require(_category > 0);
721         require(_attributes != 0x0);
722         require(_stats.length > 0);
723 
724         Asset memory asset = Asset({
725             ID: _ID,
726             category: _category,
727             builtBy: _creatorTokenID,
728             attributes: bytes2(_attributes),
729             stats: _stats,
730             state: _state,
731             createdAt: uint64(now),
732             cooldownEndBlock: _cooldownEndBlock,
733             cooldown: _cooldown
734             });
735 
736         uint256 newAssetUniqueId = assets.push(asset) - 1;
737 
738         // Check it reached 4 billion assets but let's just be 100% sure.
739         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
740 
741         // store price
742         assetIndexToPrice[newAssetUniqueId] = _price;
743 
744         // This will assign ownership
745         transfer(address(0), _owner, newAssetUniqueId);
746 
747         return newAssetUniqueId;
748     }
749 
750     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
751     /// This method doesn't do any checking and should only be called when the
752     ///  input data is known to be valid.
753     /// @param _tokenId The token ID
754     /// @param _creatorTokenID The asset that create that token
755     /// @param _price asset price
756     /// @param _ID asset ID
757     /// @param _category see Asset Struct description
758     /// @param _state see Asset Struct description
759     /// @param _attributes see Asset Struct description
760     /// @param _stats see Asset Struct description
761     /// @param _cooldown asset cooldown index
762     function editAsset(
763         uint256 _tokenId,
764         uint256 _creatorTokenID,
765         uint256 _price,
766         uint16 _ID,
767         uint8 _category,
768         uint8 _state,
769         uint8 _attributes,
770         uint8[STATS_SIZE] _stats,
771         uint16 _cooldown
772     )
773     external validAsset(_tokenId) onlyCLevel
774     returns (uint256)
775     {
776         // Ensure our data structures are always valid.
777         require(_ID > 0);
778         require(_category > 0);
779         require(_attributes != 0x0);
780         require(_stats.length > 0);
781 
782         // store price
783         assetIndexToPrice[_tokenId] = _price;
784 
785         Asset storage asset = assets[_tokenId];
786         asset.ID = _ID;
787         asset.category = _category;
788         asset.builtBy = _creatorTokenID;
789         asset.attributes = bytes2(_attributes);
790         asset.stats = _stats;
791         asset.state = _state;
792         asset.cooldown = _cooldown;
793     }
794 
795     /// @dev Update only stats
796     /// @param _tokenId asset UniqueId
797     /// @param _stats asset state, see Asset Struct description
798     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
799         assets[_tokenId].stats = _stats;
800     }
801 
802     /// @dev Update only asset state
803     /// @param _tokenId asset UniqueId
804     /// @param _state asset state, see Asset Struct description
805     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
806         assets[_tokenId].state = _state;
807     }
808 
809     /// @dev Update Cooldown for a single asset
810     /// @param _tokenId asset UniqueId
811     /// @param _cooldown asset state, see Asset Struct description
812     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
813     public validAsset(_tokenId) onlyGrantedContracts {
814         assets[_tokenId].cooldown = _cooldown;
815         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
816     }
817 
818     /*** GETTERS ***/
819 
820     /// @notice Returns only stats data about a specific asset.
821     /// @dev it is necessary due solidity compiler limitations
822     ///      when we have large qty of parameters it throws StackTooDeepException
823     /// @param _tokenId The UniqueId of the asset of interest.
824     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
825         return assets[_tokenId].stats;
826     }
827 
828     /// @dev return current price of an asset
829     /// @param _tokenId asset UniqueId
830     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
831         return assetIndexToPrice[_tokenId];
832     }
833 
834     /// @notice Check if asset has all attributes passed by parameter
835     /// @param _tokenId The UniqueId of the asset of interest.
836     /// @param _attributes see Asset Struct description
837     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
838         return assets[_tokenId].attributes & _attributes == _attributes;
839     }
840 
841     /// @notice Check if asset has any attribute passed by parameter
842     /// @param _tokenId The UniqueId of the asset of interest.
843     /// @param _attributes see Asset Struct description
844     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
845         return assets[_tokenId].attributes & _attributes != 0x0;
846     }
847 
848     /// @notice Check if asset is in the state passed by parameter
849     /// @param _tokenId The UniqueId of the asset of interest.
850     /// @param _category see AssetCategory in EthernautsBase for possible states
851     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
852         return assets[_tokenId].category == _category;
853     }
854 
855     /// @notice Check if asset is in the state passed by parameter
856     /// @param _tokenId The UniqueId of the asset of interest.
857     /// @param _state see enum AssetState in EthernautsBase for possible states
858     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
859         return assets[_tokenId].state == _state;
860     }
861 
862     /// @notice Returns owner of a given Asset(Token).
863     /// @dev Required for ERC-721 compliance.
864     /// @param _tokenId asset UniqueId
865     function ownerOf(uint256 _tokenId) public view returns (address owner)
866     {
867         return assetIndexToOwner[_tokenId];
868     }
869 
870     /// @dev Required for ERC-721 compliance
871     /// @notice Returns the number of Assets owned by a specific address.
872     /// @param _owner The owner address to check.
873     function balanceOf(address _owner) public view returns (uint256 count) {
874         return ownershipTokenCount[_owner];
875     }
876 
877     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
878     /// @param _tokenId asset UniqueId
879     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
880         return assetIndexToApproved[_tokenId];
881     }
882 
883     /// @notice Returns the total number of Assets currently in existence.
884     /// @dev Required for ERC-721 compliance.
885     function totalSupply() public view returns (uint256) {
886         return assets.length;
887     }
888 
889     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
890     /// @param _owner filter all assets by owner
891     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
892         uint256[6][]
893     ) {
894         uint256 totalAssets = assets.length;
895 
896         if (totalAssets == 0) {
897             // Return an empty array
898             return new uint256[6][](0);
899         } else {
900             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
901             uint256 resultIndex = 0;
902             bytes2 hasAttributes  = bytes2(_withAttributes);
903             Asset memory asset;
904 
905             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
906                 asset = assets[tokenId];
907                 if (
908                     (asset.state != uint8(AssetState.Used)) &&
909                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
910                     (asset.attributes & hasAttributes == hasAttributes)
911                 ) {
912                     result[resultIndex][0] = tokenId;
913                     result[resultIndex][1] = asset.ID;
914                     result[resultIndex][2] = asset.category;
915                     result[resultIndex][3] = uint256(asset.attributes);
916                     result[resultIndex][4] = asset.cooldown;
917                     result[resultIndex][5] = assetIndexToPrice[tokenId];
918                     resultIndex++;
919                 }
920             }
921 
922             return result;
923         }
924     }
925 }
926 
927 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
928 /// @notice This provides the methods required for basic non-fungible token
929 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
930 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
931 //          reference to logic contracts as Auction, Explore and so on
932 /// @author Ethernatus - Fernando Pauer
933 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
934 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
935 
936     /// @dev Contract holding only data.
937     EthernautsStorage public ethernautsStorage;
938 
939     /*** CONSTANTS ***/
940     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
941     string public constant name = "Ethernauts";
942     string public constant symbol = "ETNT";
943 
944     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
945     /**********************************************************************/
946 
947     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
948 
949     /*** EVENTS ***/
950 
951     // Events as per ERC-721
952     event Transfer(address indexed from, address indexed to, uint256 tokens);
953     event Approval(address indexed owner, address indexed approved, uint256 tokens);
954 
955     /// @dev When a new asset is create it emits build event
956     /// @param owner The address of asset owner
957     /// @param tokenId Asset UniqueID
958     /// @param assetId ID that defines asset look and feel
959     /// @param price asset price
960     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
961 
962     function implementsERC721() public pure returns (bool) {
963         return true;
964     }
965 
966     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
967     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
968     /// @param _interfaceID interface signature ID
969     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
970     {
971         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
972     }
973 
974     /// @dev Checks if a given address is the current owner of a particular Asset.
975     /// @param _claimant the address we are validating against.
976     /// @param _tokenId asset UniqueId, only valid when > 0
977     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
978         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
979     }
980 
981     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
982     /// @param _claimant the address we are confirming asset is approved for.
983     /// @param _tokenId asset UniqueId, only valid when > 0
984     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
985         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
986     }
987 
988     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
989     ///  approval. Setting _approved to address(0) clears all transfer approval.
990     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
991     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
992     ///  there is no value in spamming the log with Approval events in that case.
993     function _approve(uint256 _tokenId, address _approved) internal {
994         ethernautsStorage.approve(_tokenId, _approved);
995     }
996 
997     /// @notice Returns the number of Assets owned by a specific address.
998     /// @param _owner The owner address to check.
999     /// @dev Required for ERC-721 compliance
1000     function balanceOf(address _owner) public view returns (uint256 count) {
1001         return ethernautsStorage.balanceOf(_owner);
1002     }
1003 
1004     /// @dev Required for ERC-721 compliance.
1005     /// @notice Transfers a Asset to another address. If transferring to a smart
1006     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1007     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
1008     /// @param _to The address of the recipient, can be a user or contract.
1009     /// @param _tokenId The ID of the Asset to transfer.
1010     function transfer(
1011         address _to,
1012         uint256 _tokenId
1013     )
1014     external
1015     whenNotPaused
1016     {
1017         // Safety check to prevent against an unexpected 0x0 default.
1018         require(_to != address(0));
1019         // Disallow transfers to this contract to prevent accidental misuse.
1020         // The contract should never own any assets
1021         // (except very briefly after it is created and before it goes on auction).
1022         require(_to != address(this));
1023         // Disallow transfers to the storage contract to prevent accidental
1024         // misuse. Auction or Upgrade contracts should only take ownership of assets
1025         // through the allow + transferFrom flow.
1026         require(_to != address(ethernautsStorage));
1027 
1028         // You can only send your own asset.
1029         require(_owns(msg.sender, _tokenId));
1030 
1031         // Reassign ownership, clear pending approvals, emit Transfer event.
1032         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
1033     }
1034 
1035     /// @dev Required for ERC-721 compliance.
1036     /// @notice Grant another address the right to transfer a specific Asset via
1037     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1038     /// @param _to The address to be granted transfer approval. Pass address(0) to
1039     ///  clear all approvals.
1040     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
1041     function approve(
1042         address _to,
1043         uint256 _tokenId
1044     )
1045     external
1046     whenNotPaused
1047     {
1048         // Only an owner can grant transfer approval.
1049         require(_owns(msg.sender, _tokenId));
1050 
1051         // Register the approval (replacing any previous approval).
1052         _approve(_tokenId, _to);
1053 
1054         // Emit approval event.
1055         Approval(msg.sender, _to, _tokenId);
1056     }
1057 
1058 
1059     /// @notice Transfer a Asset owned by another address, for which the calling address
1060     ///  has previously been granted transfer approval by the owner.
1061     /// @param _from The address that owns the Asset to be transferred.
1062     /// @param _to The address that should take ownership of the Asset. Can be any address,
1063     ///  including the caller.
1064     /// @param _tokenId The ID of the Asset to be transferred.
1065     function _transferFrom(
1066         address _from,
1067         address _to,
1068         uint256 _tokenId
1069     )
1070     internal
1071     {
1072         // Safety check to prevent against an unexpected 0x0 default.
1073         require(_to != address(0));
1074         // Disallow transfers to this contract to prevent accidental misuse.
1075         // The contract should never own any assets (except for used assets).
1076         require(_owns(_from, _tokenId));
1077         // Check for approval and valid ownership
1078         require(_approvedFor(_to, _tokenId));
1079 
1080         // Reassign ownership (also clears pending approvals and emits Transfer event).
1081         ethernautsStorage.transfer(_from, _to, _tokenId);
1082     }
1083 
1084     /// @dev Required for ERC-721 compliance.
1085     /// @notice Transfer a Asset owned by another address, for which the calling address
1086     ///  has previously been granted transfer approval by the owner.
1087     /// @param _from The address that owns the Asset to be transfered.
1088     /// @param _to The address that should take ownership of the Asset. Can be any address,
1089     ///  including the caller.
1090     /// @param _tokenId The ID of the Asset to be transferred.
1091     function transferFrom(
1092         address _from,
1093         address _to,
1094         uint256 _tokenId
1095     )
1096     external
1097     whenNotPaused
1098     {
1099         _transferFrom(_from, _to, _tokenId);
1100     }
1101 
1102     /// @dev Required for ERC-721 compliance.
1103     /// @notice Allow pre-approved user to take ownership of a token
1104     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1105     function takeOwnership(uint256 _tokenId) public {
1106         address _from = ethernautsStorage.ownerOf(_tokenId);
1107 
1108         // Safety check to prevent against an unexpected 0x0 default.
1109         require(_from != address(0));
1110         _transferFrom(_from, msg.sender, _tokenId);
1111     }
1112 
1113     /// @notice Returns the total number of Assets currently in existence.
1114     /// @dev Required for ERC-721 compliance.
1115     function totalSupply() public view returns (uint256) {
1116         return ethernautsStorage.totalSupply();
1117     }
1118 
1119     /// @notice Returns owner of a given Asset(Token).
1120     /// @param _tokenId Token ID to get owner.
1121     /// @dev Required for ERC-721 compliance.
1122     function ownerOf(uint256 _tokenId)
1123     external
1124     view
1125     returns (address owner)
1126     {
1127         owner = ethernautsStorage.ownerOf(_tokenId);
1128 
1129         require(owner != address(0));
1130     }
1131 
1132     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
1133     /// @param _creatorTokenID The asset who is father of this asset
1134     /// @param _price asset price
1135     /// @param _assetID asset ID
1136     /// @param _category see Asset Struct description
1137     /// @param _attributes see Asset Struct description
1138     /// @param _stats see Asset Struct description
1139     function createNewAsset(
1140         uint256 _creatorTokenID,
1141         address _owner,
1142         uint256 _price,
1143         uint16 _assetID,
1144         uint8 _category,
1145         uint8 _attributes,
1146         uint8[STATS_SIZE] _stats
1147     )
1148     external onlyCLevel
1149     returns (uint256)
1150     {
1151         // owner must be sender
1152         require(_owner != address(0));
1153 
1154         uint256 tokenID = ethernautsStorage.createAsset(
1155             _creatorTokenID,
1156             _owner,
1157             _price,
1158             _assetID,
1159             _category,
1160             uint8(AssetState.Available),
1161             _attributes,
1162             _stats,
1163             0,
1164             0
1165         );
1166 
1167         // emit the build event
1168         Build(
1169             _owner,
1170             tokenID,
1171             _assetID,
1172             _price
1173         );
1174 
1175         return tokenID;
1176     }
1177 
1178     /// @notice verify if token is in exploration time
1179     /// @param _tokenId The Token ID that can be upgraded
1180     function isExploring(uint256 _tokenId) public view returns (bool) {
1181         uint256 cooldown;
1182         uint64 cooldownEndBlock;
1183         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
1184         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
1185     }
1186 }
1187 
1188 
1189 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
1190 /// @author Ethernatus - Fernando Pauer
1191 contract EthernautsLogic is EthernautsOwnership {
1192 
1193     // Set in case the logic contract is broken and an upgrade is required
1194     address public newContractAddress;
1195 
1196     /// @dev Constructor
1197     function EthernautsLogic() public {
1198         // the creator of the contract is the initial CEO, COO, CTO
1199         ceoAddress = msg.sender;
1200         ctoAddress = msg.sender;
1201         cooAddress = msg.sender;
1202         oracleAddress = msg.sender;
1203 
1204         // Starts paused.
1205         paused = true;
1206     }
1207 
1208     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1209     ///  breaking bug. This method does nothing but keep track of the new contract and
1210     ///  emit a message indicating that the new address is set. It's up to clients of this
1211     ///  contract to update to the new contract address in that case. (This contract will
1212     ///  be paused indefinitely if such an upgrade takes place.)
1213     /// @param _v2Address new address
1214     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
1215         // See README.md for updgrade plan
1216         newContractAddress = _v2Address;
1217         ContractUpgrade(_v2Address);
1218     }
1219 
1220     /// @dev set a new reference to the NFT ownership contract
1221     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
1222     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
1223         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
1224         require(candidateContract.isEthernautsStorage());
1225         ethernautsStorage = candidateContract;
1226     }
1227 
1228     /// @dev Override unpause so it requires all external contract addresses
1229     ///  to be set before contract can be unpaused. Also, we can't have
1230     ///  newContractAddress set either, because then the contract was upgraded.
1231     /// @notice This is public rather than external so we can call super.unpause
1232     ///  without using an expensive CALL.
1233     function unpause() public onlyCEO whenPaused {
1234         require(ethernautsStorage != address(0));
1235         require(newContractAddress == address(0));
1236         // require this contract to have access to storage contract
1237         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1238 
1239         // Actually unpause the contract.
1240         super.unpause();
1241     }
1242 
1243     // @dev Allows the COO to capture the balance available to the contract.
1244     function withdrawBalances(address _to) public onlyCLevel {
1245         _to.transfer(this.balance);
1246     }
1247 
1248     /// return current contract balance
1249     function getBalance() public view onlyCLevel returns (uint256) {
1250         return this.balance;
1251     }
1252 }
1253 
1254 /// @title Clock auction for non-fungible tokens.
1255 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1256 ///         This provides public methods for auctioning or bidding on assets, purchase (GoldenGoose) and Upgrade ship.
1257 ///
1258 ///      - Auctions/Bidding: This provides public methods for auctioning or bidding on assets.
1259 ///             Auction creation is mostly mediated through this facet of the logic contract.
1260 ///
1261 ///      - Purchase: This provides public methods for buying GoldenGoose assets.
1262 /// @author Ethernatus - Fernando Pauer
1263 contract EthernautsMarket is EthernautsLogic, ClockAuctionBase {
1264 
1265     /// @dev Constructor creates a reference to the NFT ownership contract
1266     ///  and verifies the owner cut is in the valid range.
1267     ///  and Delegate constructor to EthernautsUpgrade contract.
1268     /// @param _cut - percent cut the owner takes on each auction, must be
1269     ///  between 0-10,000.
1270     function EthernautsMarket(uint256 _cut) public
1271     EthernautsLogic() {
1272         require(_cut <= 10000);
1273         ownerCut = _cut;
1274         nonFungibleContract = this;
1275     }
1276 
1277     /*** EVENTS ***/
1278     /// @dev The Purchase event is fired whenever a token is sold.
1279     event Purchase(uint256 indexed tokenId, uint256 oldPrice, uint256 newPrice, address indexed prevOwner, address indexed winner);
1280 
1281     /*** CONSTANTS ***/
1282     uint8 private percentageFee1Step = 95;
1283     uint8 private percentageFee2Step = 95;
1284     uint8 private percentageFeeSteps = 98;
1285     uint8 private percentageBase = 100;
1286     uint8 private percentage1Step = 200;
1287     uint8 private percentage2Step = 125;
1288     uint8 private percentageSteps = 115;
1289     uint256 private firstStepLimit =  0.05 ether;
1290     uint256 private secondStepLimit = 5 ether;
1291 
1292     // ************************* AUCTION AND BIDDING ****************************
1293     /// @dev Bids on an open auction, completing the auction and transferring
1294     ///  ownership of the NFT if enough Ether is supplied.
1295     /// @param _tokenId - ID of token to bid on.
1296     function bid(uint256 _tokenId)
1297     external
1298     payable
1299     whenNotPaused
1300     {
1301         // _bid will throw if the bid or funds transfer fails
1302         uint256 newPrice = _bid(_tokenId, msg.value);
1303         _transfer(msg.sender, _tokenId);
1304 
1305         // only set new price after transfer
1306         ethernautsStorage.setPrice(_tokenId, newPrice);
1307     }
1308 
1309     /// @dev Cancels an auction that hasn't been won yet.
1310     ///  Returns the NFT to original owner.
1311     /// @notice This is a state-modifying function that can
1312     ///  be called while the contract is paused.
1313     /// @param _tokenId - ID of token on auction
1314     function cancelAuction(uint256 _tokenId)
1315     external
1316     {
1317         Auction storage auction = tokenIdToAuction[_tokenId];
1318         require(_isOnAuction(auction));
1319         address seller = auction.seller;
1320         require(msg.sender == seller);
1321         _cancelAuction(_tokenId, seller);
1322     }
1323 
1324     /// @dev Cancels an auction when the contract is paused.
1325     ///  Only the owner may do this, and NFTs are returned to
1326     ///  the seller. This should only be used in emergencies.
1327     /// @param _tokenId - ID of the NFT on auction to cancel.
1328     function cancelAuctionWhenPaused(uint256 _tokenId)
1329     whenPaused
1330     onlyCLevel
1331     external
1332     {
1333         Auction storage auction = tokenIdToAuction[_tokenId];
1334         require(_isOnAuction(auction));
1335         _cancelAuction(_tokenId, auction.seller);
1336     }
1337 
1338     /// @dev Create an auction when the contract is paused to
1339     ///  recreate pending bids from last contract.
1340     ///  This should only be used in emergencies.
1341     /// @param _contract - previous contract
1342     /// @param _seller - original seller of previous contract
1343     /// @param _tokenId - ID of token to auction, sender must be owner.
1344     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1345     /// @param _endingPrice - Price of item (in wei) at end of auction.
1346     /// @param _duration - Length of time to move between starting
1347     function createAuctionWhenPaused(
1348         address _contract,
1349         address _seller,
1350         uint256 _tokenId,
1351         uint256 _startingPrice,
1352         uint256 _endingPrice,
1353         uint256 _duration
1354     )
1355     whenPaused
1356     onlyCLevel
1357     external
1358     {
1359         // Sanity check that no inputs overflow how many bits we've allocated
1360         // to store them in the auction struct.
1361         require(_startingPrice == uint256(uint128(_startingPrice)));
1362         require(_endingPrice == uint256(uint128(_endingPrice)));
1363         require(_duration == uint256(uint64(_duration)));
1364 
1365         // ensure this contract owns the auction
1366         require(_owns(_contract, _tokenId));
1367         require(_seller != address(0));
1368 
1369         ethernautsStorage.approve(_tokenId, address(this));
1370 
1371         /// Escrows the NFT, assigning ownership to this contract.
1372         /// Throws if the escrow fails.
1373         _transferFrom(_contract, this, _tokenId);
1374 
1375         Auction memory auction = Auction(
1376             _seller,
1377             uint128(_startingPrice),
1378             uint128(_endingPrice),
1379             uint64(_duration),
1380             uint64(now)
1381         );
1382 
1383         _addAuction(_tokenId, auction);
1384     }
1385 
1386     /// @dev Returns auction info for an NFT on auction.
1387     /// @param _tokenId - ID of NFT on auction.
1388     function getAuction(uint256 _tokenId)
1389     external
1390     view
1391     returns
1392     (
1393         address seller,
1394         uint256 startingPrice,
1395         uint256 endingPrice,
1396         uint256 duration,
1397         uint256 startedAt
1398     ) {
1399         Auction storage auction = tokenIdToAuction[_tokenId];
1400         require(_isOnAuction(auction));
1401         return (
1402         auction.seller,
1403         auction.startingPrice,
1404         auction.endingPrice,
1405         auction.duration,
1406         auction.startedAt
1407         );
1408     }
1409 
1410     /// @dev Returns the current price of an auction.
1411     /// @param _tokenId - ID of the token price we are checking.
1412     function getCurrentPrice(uint256 _tokenId)
1413     external
1414     view
1415     returns (uint256)
1416     {
1417         Auction storage auction = tokenIdToAuction[_tokenId];
1418         require(_isOnAuction(auction));
1419         return _currentPrice(auction);
1420     }
1421 
1422     /// @dev Creates and begins a new auction. Does some ownership trickery to create auctions in one tx.
1423     /// @param _tokenId - ID of token to auction, sender must be owner.
1424     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1425     /// @param _endingPrice - Price of item (in wei) at end of auction.
1426     /// @param _duration - Length of time to move between starting
1427     ///  price and ending price (in seconds).
1428     function createSaleAuction(
1429         uint256 _tokenId,
1430         uint256 _startingPrice,
1431         uint256 _endingPrice,
1432         uint256 _duration
1433     )
1434     external
1435     whenNotPaused
1436     {
1437         // Sanity check that no inputs overflow how many bits we've allocated
1438         // to store them in the auction struct.
1439         require(_startingPrice == uint256(uint128(_startingPrice)));
1440         require(_endingPrice == uint256(uint128(_endingPrice)));
1441         require(_duration == uint256(uint64(_duration)));
1442 
1443         // Auction contract checks input sizes
1444         // If asset is already on any auction, this will throw
1445         // because it will be owned by the auction contract.
1446         require(_owns(msg.sender, _tokenId));
1447         // Ensure the asset is Tradeable and not GoldenGoose to prevent the auction
1448         // contract accidentally receiving ownership of the child.
1449         require(ethernautsStorage.hasAllAttrs(_tokenId, ATTR_TRADABLE));
1450         require(!ethernautsStorage.hasAllAttrs(_tokenId, ATTR_GOLDENGOOSE));
1451 
1452         // Ensure the asset is in available state, otherwise it cannot be sold
1453         require(ethernautsStorage.isState(_tokenId, uint8(AssetState.Available)));
1454 
1455         // asset or object could not be in exploration
1456         require(!isExploring(_tokenId));
1457 
1458         ethernautsStorage.approve(_tokenId, address(this));
1459 
1460         /// Escrows the NFT, assigning ownership to this contract.
1461         /// Throws if the escrow fails.
1462         _transferFrom(msg.sender, this, _tokenId);
1463 
1464         Auction memory auction = Auction(
1465             msg.sender,
1466             uint128(_startingPrice),
1467             uint128(_endingPrice),
1468             uint64(_duration),
1469             uint64(now)
1470         );
1471 
1472         _addAuction(_tokenId, auction);
1473     }
1474 
1475     /// @notice Any C-level can change sales cut.
1476     function setOwnerCut(uint256 _ownerCut) public onlyCLevel {
1477         ownerCut = _ownerCut;
1478     }
1479 
1480 
1481     // ************************* PURCHASE ****************************
1482 
1483     /// @notice Allows someone buy obtain an GoldenGoose asset token
1484     /// @param _tokenId The Token ID that can be purchased if Token is a GoldenGoose asset.
1485     function purchase(uint256 _tokenId) external payable whenNotPaused {
1486         // Checking if Asset is a GoldenGoose, if not this purchase is not allowed
1487         require(ethernautsStorage.hasAnyAttrs(_tokenId, ATTR_GOLDENGOOSE));
1488 
1489         address oldOwner = ethernautsStorage.ownerOf(_tokenId);
1490         address newOwner = msg.sender;
1491         uint256 sellingPrice = ethernautsStorage.priceOf(_tokenId);
1492 
1493         // Making sure token owner is not sending to self
1494         // it guarantees a fair market
1495         require(oldOwner != newOwner);
1496 
1497         // Safety check to prevent against an unexpected 0x0 default.
1498         require(newOwner != address(0));
1499 
1500         // Making sure sent amount is greater than or equal to the sellingPrice
1501         require(msg.value >= sellingPrice);
1502 
1503         uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFee1Step), 100));
1504         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
1505         uint256 newPrice = sellingPrice;
1506 
1507         // Update prices
1508         if (sellingPrice < firstStepLimit) {
1509             // first stage
1510             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentage1Step), percentageBase);
1511         } else if (sellingPrice < secondStepLimit) {
1512             // redefining fees
1513             payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFee2Step), 100));
1514 
1515             // second stage
1516             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentage2Step), percentageBase);
1517         } else {
1518             // redefining fees
1519             payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFeeSteps), 100));
1520 
1521             // last stage
1522             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentageSteps), percentageBase);
1523         }
1524 
1525         // Pay previous tokenOwner if owner is not contract
1526         if (oldOwner != address(this)) {
1527             oldOwner.transfer(payment); //(1-0.06)
1528         }
1529 
1530         // only transfer token after confirmed transaction
1531         ethernautsStorage.transfer(oldOwner, newOwner, _tokenId);
1532 
1533         // only set new price after confirmed transaction
1534         ethernautsStorage.setPrice(_tokenId, newPrice);
1535 
1536         Purchase(_tokenId, sellingPrice, newPrice, oldOwner, newOwner);
1537 
1538         // send excess back to buyer
1539         msg.sender.transfer(purchaseExcess);
1540     }
1541 
1542     /// @notice Any C-level can change first Step Limit.
1543     function setStepLimits(
1544         uint256 _firstStepLimit,
1545         uint256 _secondStepLimit
1546     ) public onlyCLevel {
1547         firstStepLimit = _firstStepLimit;
1548         secondStepLimit = _secondStepLimit;
1549     }
1550 
1551     /// @notice Any C-level can change percentage values
1552     function setPercentages(
1553         uint8 _Fee1,
1554         uint8 _Fee2,
1555         uint8 _Fees,
1556         uint8 _1Step,
1557         uint8 _2Step,
1558         uint8 _Steps
1559     ) public onlyCLevel {
1560         percentageFee1Step = _Fee1;
1561         percentageFee2Step = _Fee2;
1562         percentageFeeSteps = _Fees;
1563         percentage1Step = _1Step;
1564         percentage2Step = _2Step;
1565         percentageSteps = _Steps;
1566     }
1567 
1568 }