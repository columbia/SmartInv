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
29 // Copied from: https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d#code
30 
31 
32 // Copied from: https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d#code
33 
34 
35 
36 
37 
38 // Extend this library for child contracts
39 library SafeMath {
40 
41     /**
42     * @dev Multiplies two numbers, throws on overflow.
43     */
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         assert(c / a == b);
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers, truncating the quotient.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // assert(b > 0); // Solidity automatically throws when dividing by 0
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60         return c;
61     }
62 
63     /**
64     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
65     */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     /**
72     * @dev Adds two numbers, throws on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         assert(c >= a);
77         return c;
78     }
79 
80     /**
81     * @dev Compara two numbers, and return the bigger one.
82     */
83     function max(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a > b) {
85             return a;
86         } else {
87             return b;
88         }
89     }
90 
91     /**
92     * @dev Compara two numbers, and return the bigger one.
93     */
94     function min(uint256 a, uint256 b) internal pure returns (uint256) {
95         if (a < b) {
96             return a;
97         } else {
98             return b;
99         }
100     }
101 
102 
103 }
104 
105 /// @title Auction Core
106 /// @dev Contains models, variables, and internal methods for the auction.
107 /// @notice We omit a fallback function to prevent accidental sends to this contract.
108 contract ClockAuctionBase {
109 
110     // Represents an auction on an NFT
111     struct Auction {
112         // Current owner of NFT
113         address seller;
114         // Price (in wei) at beginning of auction
115         uint128 startingPrice;
116         // Price (in wei) at end of auction
117         uint128 endingPrice;
118         // Duration (in seconds) of auction
119         uint64 duration;
120         // Time when auction started
121         // NOTE: 0 if this auction has been concluded
122         uint64 startedAt;
123     }
124 
125     // Reference to contract tracking NFT ownership
126     ERC721 public nonFungibleContract;
127 
128     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
129     // Values 0-10,000 map to 0%-100%
130     uint256 public ownerCut;
131 
132     // Map from token ID to their corresponding auction.
133     mapping (uint256 => Auction) tokenIdToAuction;
134 
135     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
136     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
137     event AuctionCancelled(uint256 tokenId);
138 
139     /// @dev Returns true if the claimant owns the token.
140     /// @param _claimant - Address claiming to own the token.
141     /// @param _tokenId - ID of token whose ownership to verify.
142     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
143         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
144     }
145 
146     /// @dev Transfers an NFT owned by this contract to another address.
147     /// Returns true if the transfer succeeds.
148     /// @param _receiver - Address to transfer NFT to.
149     /// @param _tokenId - ID of token to transfer.
150     function _transfer(address _receiver, uint256 _tokenId) internal {
151         // it will throw if transfer fails
152         nonFungibleContract.transfer(_receiver, _tokenId);
153     }
154 
155     /// @dev Adds an auction to the list of open auctions. Also fires the
156     ///  AuctionCreated event.
157     /// @param _tokenId The ID of the token to be put on auction.
158     /// @param _auction Auction to add.
159     function _addAuction(uint256 _tokenId, Auction _auction) internal {
160         // Require that all auctions have a duration of
161         // at least one minute. (Keeps our math from getting hairy!)
162         require(_auction.duration >= 1 minutes);
163 
164         tokenIdToAuction[_tokenId] = _auction;
165 
166         AuctionCreated(
167             uint256(_tokenId),
168             uint256(_auction.startingPrice),
169             uint256(_auction.endingPrice),
170             uint256(_auction.duration)
171         );
172     }
173 
174     /// @dev Cancels an auction unconditionally.
175     function _cancelAuction(uint256 _tokenId, address _seller) internal {
176         _removeAuction(_tokenId);
177         _transfer(_seller, _tokenId);
178         AuctionCancelled(_tokenId);
179     }
180 
181     /// @dev Computes the price and transfers winnings.
182     /// Does NOT transfer ownership of token.
183     function _bid(uint256 _tokenId, uint256 _bidAmount)
184     internal
185     returns (uint256)
186     {
187         // Get a reference to the auction struct
188         Auction storage auction = tokenIdToAuction[_tokenId];
189 
190         // Explicitly check that this auction is currently live.
191         // (Because of how Ethereum mappings work, we can't just count
192         // on the lookup above failing. An invalid _tokenId will just
193         // return an auction object that is all zeros.)
194         require(_isOnAuction(auction));
195 
196         // Check that the bid is greater than or equal to the current price
197         uint256 price = _currentPrice(auction);
198         require(_bidAmount >= price);
199 
200         // Grab a reference to the seller before the auction struct
201         // gets deleted.
202         address seller = auction.seller;
203 
204         // The bid is good! Remove the auction before sending the fees
205         // to the sender so we can't have a reentrancy attack.
206         _removeAuction(_tokenId);
207 
208         // Transfer proceeds to seller (if there are any!)
209         if (price > 0) {
210             // Calculate the auctioneer's cut.
211             // (NOTE: _computeCut() is guaranteed to return a
212             // value <= price, so this subtraction can't go negative.)
213             uint256 auctioneerCut = _computeCut(price);
214             uint256 sellerProceeds = price - auctioneerCut;
215 
216             // NOTE: Doing a transfer() in the middle of a complex
217             // method like this is generally discouraged because of
218             // reentrancy attacks and DoS attacks if the seller is
219             // a contract with an invalid fallback function. We explicitly
220             // guard against reentrancy attacks by removing the auction
221             // before calling transfer(), and the only thing the seller
222             // can DoS is the sale of their own asset! (And if it's an
223             // accident, they can call cancelAuction(). )
224             seller.transfer(sellerProceeds);
225         }
226 
227         // Calculate any excess funds included with the bid. If the excess
228         // is anything worth worrying about, transfer it back to bidder.
229         // NOTE: We checked above that the bid amount is greater than or
230         // equal to the price so this cannot underflow.
231         uint256 bidExcess = _bidAmount - price;
232 
233         // Return the funds. Similar to the previous transfer, this is
234         // not susceptible to a re-entry attack because the auction is
235         // removed before any transfers occur.
236         msg.sender.transfer(bidExcess);
237 
238         // Tell the world!
239         AuctionSuccessful(_tokenId, price, msg.sender);
240 
241         return price;
242     }
243 
244     /// @dev Removes an auction from the list of open auctions.
245     /// @param _tokenId - ID of NFT on auction.
246     function _removeAuction(uint256 _tokenId) internal {
247         delete tokenIdToAuction[_tokenId];
248     }
249 
250     /// @dev Returns true if the NFT is on auction.
251     /// @param _auction - Auction to check.
252     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
253         return (_auction.startedAt > 0);
254     }
255 
256     /// @dev Returns current price of an NFT on auction. Broken into two
257     ///  functions (this one, that computes the duration from the auction
258     ///  structure, and the other that does the price computation) so we
259     ///  can easily test that the price computation works correctly.
260     function _currentPrice(Auction storage _auction)
261     internal
262     view
263     returns (uint256)
264     {
265         uint256 secondsPassed = 0;
266 
267         // A bit of insurance against negative values (or wraparound).
268         // Probably not necessary (since Ethereum guarnatees that the
269         // now variable doesn't ever go backwards).
270         if (now > _auction.startedAt) {
271             secondsPassed = now - _auction.startedAt;
272         }
273 
274         return _computeCurrentPrice(
275             _auction.startingPrice,
276             _auction.endingPrice,
277             _auction.duration,
278             secondsPassed
279         );
280     }
281 
282     /// @dev Computes the current price of an auction. Factored out
283     ///  from _currentPrice so we can run extensive unit tests.
284     ///  When testing, make this function public and turn on
285     ///  `Current price computation` test suite.
286     function _computeCurrentPrice(
287         uint256 _startingPrice,
288         uint256 _endingPrice,
289         uint256 _duration,
290         uint256 _secondsPassed
291     )
292     internal
293     pure
294     returns (uint256)
295     {
296         // NOTE: We don't use SafeMath (or similar) in this function because
297         //  all of our public functions carefully cap the maximum values for
298         //  time (at 64-bits) and currency (at 128-bits). _duration is
299         //  also known to be non-zero (see the require() statement in
300         //  _addAuction())
301         if (_secondsPassed >= _duration) {
302             // We've reached the end of the dynamic pricing portion
303             // of the auction, just return the end price.
304             return _endingPrice;
305         } else {
306             // Starting price can be higher than ending price (and often is!), so
307             // this delta can be negative.
308             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
309 
310             // This multiplication can't overflow, _secondsPassed will easily fit within
311             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
312             // will always fit within 256-bits.
313             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
314 
315             // currentPriceChange can be negative, but if so, will have a magnitude
316             // less that _startingPrice. Thus, this result will always end up positive.
317             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
318 
319             return uint256(currentPrice);
320         }
321     }
322 
323     /// @dev Computes owner's cut of a sale.
324     /// @param _price - Sale price of NFT.
325     function _computeCut(uint256 _price) internal view returns (uint256) {
326         // NOTE: We don't use SafeMath (or similar) in this function because
327         //  all of our entry functions carefully cap the maximum values for
328         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
329         //  statement in the ClockAuction constructor). The result of this
330         //  function is always guaranteed to be <= _price.
331         return SafeMath.mul(_price, SafeMath.div(ownerCut,10000));
332     }
333 
334 }
335 
336 
337 
338 
339 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
340 contract EthernautsBase {
341 
342     /*** CONSTANTS USED ACROSS CONTRACTS ***/
343 
344     /// @dev Used by all contracts that interfaces with Ethernauts
345     ///      The ERC-165 interface signature for ERC-721.
346     ///  Ref: https://github.com/ethereum/EIPs/issues/165
347     ///  Ref: https://github.com/ethereum/EIPs/issues/721
348     bytes4 constant InterfaceSignature_ERC721 =
349     bytes4(keccak256('name()')) ^
350     bytes4(keccak256('symbol()')) ^
351     bytes4(keccak256('totalSupply()')) ^
352     bytes4(keccak256('balanceOf(address)')) ^
353     bytes4(keccak256('ownerOf(uint256)')) ^
354     bytes4(keccak256('approve(address,uint256)')) ^
355     bytes4(keccak256('transfer(address,uint256)')) ^
356     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
357     bytes4(keccak256('takeOwnership(uint256)')) ^
358     bytes4(keccak256('tokensOfOwner(address)')) ^
359     bytes4(keccak256('tokenMetadata(uint256,string)'));
360 
361     /// @dev due solidity limitation we cannot return dynamic array from methods
362     /// so it creates incompability between functions across different contracts
363     uint8 public constant STATS_SIZE = 10;
364     uint8 public constant SHIP_SLOTS = 5;
365 
366     // Possible state of any asset
367     enum AssetState { Available, UpForLease, Used }
368 
369     // Possible state of any asset
370     // NotValid is to avoid 0 in places where category must be bigger than zero
371     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
372 
373     /// @dev Sector stats
374     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
375     /// @notice Possible attributes for each asset
376     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
377     /// 00000010 - Producible - Product of a factory and/or factory contract.
378     /// 00000100 - Explorable- Product of exploration.
379     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
380     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
381     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
382     /// 01000000 - Tradable - Buyable and sellable on the market.
383     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
384     bytes2 public ATTR_SEEDED     = bytes2(2**0);
385     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
386     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
387     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
388     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
389     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
390     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
391     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
392 }
393 
394 /// @title Inspired by https://github.com/axiomzen/cryptokitties-bounty/blob/master/contracts/KittyAccessControl.sol
395 /// @notice This contract manages the various addresses and constraints for operations
396 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
397 contract EthernautsAccessControl is EthernautsBase {
398 
399     // This facet controls access control for Ethernauts.
400     // All roles have same responsibilities and rights, but there is slight differences between them:
401     //
402     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
403     //       It is initially set to the address that created the smart contract.
404     //
405     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
406     //
407     //     - The COO: The COO can change contract address and add create assets.
408     //
409     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
410     /// @param newContract address pointing to new contract
411     event ContractUpgrade(address newContract);
412 
413     // The addresses of the accounts (or contracts) that can execute actions within each roles.
414     address public ceoAddress;
415     address public ctoAddress;
416     address public cooAddress;
417     address public oracleAddress;
418 
419     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
420     bool public paused = false;
421 
422     /// @dev Access modifier for CEO-only functionality
423     modifier onlyCEO() {
424         require(msg.sender == ceoAddress);
425         _;
426     }
427 
428     /// @dev Access modifier for CTO-only functionality
429     modifier onlyCTO() {
430         require(msg.sender == ctoAddress);
431         _;
432     }
433 
434     /// @dev Access modifier for CTO-only functionality
435     modifier onlyOracle() {
436         require(msg.sender == oracleAddress);
437         _;
438     }
439 
440     modifier onlyCLevel() {
441         require(
442             msg.sender == ceoAddress ||
443             msg.sender == ctoAddress ||
444             msg.sender == cooAddress
445         );
446         _;
447     }
448 
449     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
450     /// @param _newCEO The address of the new CEO
451     function setCEO(address _newCEO) external onlyCEO {
452         require(_newCEO != address(0));
453 
454         ceoAddress = _newCEO;
455     }
456 
457     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
458     /// @param _newCTO The address of the new CTO
459     function setCTO(address _newCTO) external {
460         require(
461             msg.sender == ceoAddress ||
462             msg.sender == ctoAddress
463         );
464         require(_newCTO != address(0));
465 
466         ctoAddress = _newCTO;
467     }
468 
469     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
470     /// @param _newCOO The address of the new COO
471     function setCOO(address _newCOO) external {
472         require(
473             msg.sender == ceoAddress ||
474             msg.sender == cooAddress
475         );
476         require(_newCOO != address(0));
477 
478         cooAddress = _newCOO;
479     }
480 
481     /// @dev Assigns a new address to act as oracle.
482     /// @param _newOracle The address of oracle
483     function setOracle(address _newOracle) external {
484         require(msg.sender == ctoAddress);
485         require(_newOracle != address(0));
486 
487         oracleAddress = _newOracle;
488     }
489 
490     /*** Pausable functionality adapted from OpenZeppelin ***/
491 
492     /// @dev Modifier to allow actions only when the contract IS NOT paused
493     modifier whenNotPaused() {
494         require(!paused);
495         _;
496     }
497 
498     /// @dev Modifier to allow actions only when the contract IS paused
499     modifier whenPaused {
500         require(paused);
501         _;
502     }
503 
504     /// @dev Called by any "C-level" role to pause the contract. Used only when
505     ///  a bug or exploit is detected and we need to limit damage.
506     function pause() external onlyCLevel whenNotPaused {
507         paused = true;
508     }
509 
510     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
511     ///  one reason we may pause the contract is when CTO account is compromised.
512     /// @notice This is public rather than external so it can be called by
513     ///  derived contracts.
514     function unpause() public onlyCEO whenPaused {
515         // can't unpause if contract was upgraded
516         paused = false;
517     }
518 
519 }
520 
521 
522 
523 
524 
525 
526 
527 
528 
529 /// @title Storage contract for Ethernauts Data. Common structs and constants.
530 /// @notice This is our main data storage, constants and data types, plus
531 //          internal functions for managing the assets. It is isolated and only interface with
532 //          a list of granted contracts defined by CTO
533 /// @author Ethernauts - Fernando Pauer
534 contract EthernautsStorage is EthernautsAccessControl {
535 
536     function EthernautsStorage() public {
537         // the creator of the contract is the initial CEO
538         ceoAddress = msg.sender;
539 
540         // the creator of the contract is the initial CTO as well
541         ctoAddress = msg.sender;
542 
543         // the creator of the contract is the initial CTO as well
544         cooAddress = msg.sender;
545 
546         // the creator of the contract is the initial Oracle as well
547         oracleAddress = msg.sender;
548     }
549 
550     /// @notice No tipping!
551     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
552     function() external payable {
553         require(msg.sender == address(this));
554     }
555 
556     /*** Mapping for Contracts with granted permission ***/
557     mapping (address => bool) public contractsGrantedAccess;
558 
559     /// @dev grant access for a contract to interact with this contract.
560     /// @param _v2Address The contract address to grant access
561     function grantAccess(address _v2Address) public onlyCTO {
562         // See README.md for updgrade plan
563         contractsGrantedAccess[_v2Address] = true;
564     }
565 
566     /// @dev remove access from a contract to interact with this contract.
567     /// @param _v2Address The contract address to be removed
568     function removeAccess(address _v2Address) public onlyCTO {
569         // See README.md for updgrade plan
570         delete contractsGrantedAccess[_v2Address];
571     }
572 
573     /// @dev Only allow permitted contracts to interact with this contract
574     modifier onlyGrantedContracts() {
575         require(contractsGrantedAccess[msg.sender] == true);
576         _;
577     }
578 
579     modifier validAsset(uint256 _tokenId) {
580         require(assets[_tokenId].ID > 0);
581         _;
582     }
583     /*** DATA TYPES ***/
584 
585     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
586     ///  of this structure. Note that the order of the members in this structure
587     ///  is important because of the byte-packing rules used by Ethereum.
588     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
589     struct Asset {
590 
591         // Asset ID is a identifier for look and feel in frontend
592         uint16 ID;
593 
594         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
595         uint8 category;
596 
597         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
598         uint8 state;
599 
600         // Attributes
601         // byte pos - Definition
602         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
603         // 00000010 - Producible - Product of a factory and/or factory contract.
604         // 00000100 - Explorable- Product of exploration.
605         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
606         // 00010000 - Permanent - Cannot be removed, always owned by a user.
607         // 00100000 - Consumable - Destroyed after N exploration expeditions.
608         // 01000000 - Tradable - Buyable and sellable on the market.
609         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
610         bytes2 attributes;
611 
612         // The timestamp from the block when this asset was created.
613         uint64 createdAt;
614 
615         // The minimum timestamp after which this asset can engage in exploring activities again.
616         uint64 cooldownEndBlock;
617 
618         // The Asset's stats can be upgraded or changed based on exploration conditions.
619         // It will be defined per child contract, but all stats have a range from 0 to 255
620         // Examples
621         // 0 = Ship Level
622         // 1 = Ship Attack
623         uint8[STATS_SIZE] stats;
624 
625         // Set to the cooldown time that represents exploration duration for this asset.
626         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
627         uint256 cooldown;
628 
629         // a reference to a super asset that manufactured the asset
630         uint256 builtBy;
631     }
632 
633     /*** CONSTANTS ***/
634 
635     // @dev Sanity check that allows us to ensure that we are pointing to the
636     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
637     bool public isEthernautsStorage = true;
638 
639     /*** STORAGE ***/
640 
641     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
642     ///  of each asset is actually an index into this array.
643     Asset[] public assets;
644 
645     /// @dev A mapping from Asset UniqueIDs to the price of the token.
646     /// stored outside Asset Struct to save gas, because price can change frequently
647     mapping (uint256 => uint256) internal assetIndexToPrice;
648 
649     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
650     mapping (uint256 => address) internal assetIndexToOwner;
651 
652     // @dev A mapping from owner address to count of tokens that address owns.
653     //  Used internally inside balanceOf() to resolve ownership count.
654     mapping (address => uint256) internal ownershipTokenCount;
655 
656     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
657     ///  transferFrom(). Each Asset can only have one approved address for transfer
658     ///  at any time. A zero value means no approval is outstanding.
659     mapping (uint256 => address) internal assetIndexToApproved;
660 
661 
662     /*** SETTERS ***/
663 
664     /// @dev set new asset price
665     /// @param _tokenId  asset UniqueId
666     /// @param _price    asset price
667     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
668         assetIndexToPrice[_tokenId] = _price;
669     }
670 
671     /// @dev Mark transfer as approved
672     /// @param _tokenId  asset UniqueId
673     /// @param _approved address approved
674     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
675         assetIndexToApproved[_tokenId] = _approved;
676     }
677 
678     /// @dev Assigns ownership of a specific Asset to an address.
679     /// @param _from    current owner address
680     /// @param _to      new owner address
681     /// @param _tokenId asset UniqueId
682     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
683         // Since the number of assets is capped to 2^32 we can't overflow this
684         ownershipTokenCount[_to]++;
685         // transfer ownership
686         assetIndexToOwner[_tokenId] = _to;
687         // When creating new assets _from is 0x0, but we can't account that address.
688         if (_from != address(0)) {
689             ownershipTokenCount[_from]--;
690             // clear any previously approved ownership exchange
691             delete assetIndexToApproved[_tokenId];
692         }
693     }
694 
695     /// @dev A public method that creates a new asset and stores it. This
696     ///  method does basic checking and should only be called from other contract when the
697     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
698     /// @param _creatorTokenID The asset who is father of this asset
699     /// @param _owner First owner of this asset
700     /// @param _price asset price
701     /// @param _ID asset ID
702     /// @param _category see Asset Struct description
703     /// @param _state see Asset Struct description
704     /// @param _attributes see Asset Struct description
705     /// @param _stats see Asset Struct description
706     function createAsset(
707         uint256 _creatorTokenID,
708         address _owner,
709         uint256 _price,
710         uint16 _ID,
711         uint8 _category,
712         uint8 _state,
713         uint8 _attributes,
714         uint8[STATS_SIZE] _stats,
715         uint256 _cooldown,
716         uint64 _cooldownEndBlock
717     )
718     public onlyGrantedContracts
719     returns (uint256)
720     {
721         // Ensure our data structures are always valid.
722         require(_ID > 0);
723         require(_category > 0);
724         require(_attributes != 0x0);
725         require(_stats.length > 0);
726 
727         Asset memory asset = Asset({
728             ID: _ID,
729             category: _category,
730             builtBy: _creatorTokenID,
731             attributes: bytes2(_attributes),
732             stats: _stats,
733             state: _state,
734             createdAt: uint64(now),
735             cooldownEndBlock: _cooldownEndBlock,
736             cooldown: _cooldown
737             });
738 
739         uint256 newAssetUniqueId = assets.push(asset) - 1;
740 
741         // Check it reached 4 billion assets but let's just be 100% sure.
742         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
743 
744         // store price
745         assetIndexToPrice[newAssetUniqueId] = _price;
746 
747         // This will assign ownership
748         transfer(address(0), _owner, newAssetUniqueId);
749 
750         return newAssetUniqueId;
751     }
752 
753     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
754     /// This method doesn't do any checking and should only be called when the
755     ///  input data is known to be valid.
756     /// @param _tokenId The token ID
757     /// @param _creatorTokenID The asset that create that token
758     /// @param _price asset price
759     /// @param _ID asset ID
760     /// @param _category see Asset Struct description
761     /// @param _state see Asset Struct description
762     /// @param _attributes see Asset Struct description
763     /// @param _stats see Asset Struct description
764     /// @param _cooldown asset cooldown index
765     function editAsset(
766         uint256 _tokenId,
767         uint256 _creatorTokenID,
768         uint256 _price,
769         uint16 _ID,
770         uint8 _category,
771         uint8 _state,
772         uint8 _attributes,
773         uint8[STATS_SIZE] _stats,
774         uint16 _cooldown
775     )
776     external validAsset(_tokenId) onlyCLevel
777     returns (uint256)
778     {
779         // Ensure our data structures are always valid.
780         require(_ID > 0);
781         require(_category > 0);
782         require(_attributes != 0x0);
783         require(_stats.length > 0);
784 
785         // store price
786         assetIndexToPrice[_tokenId] = _price;
787 
788         Asset storage asset = assets[_tokenId];
789         asset.ID = _ID;
790         asset.category = _category;
791         asset.builtBy = _creatorTokenID;
792         asset.attributes = bytes2(_attributes);
793         asset.stats = _stats;
794         asset.state = _state;
795         asset.cooldown = _cooldown;
796     }
797 
798     /// @dev Update only stats
799     /// @param _tokenId asset UniqueId
800     /// @param _stats asset state, see Asset Struct description
801     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
802         assets[_tokenId].stats = _stats;
803     }
804 
805     /// @dev Update only asset state
806     /// @param _tokenId asset UniqueId
807     /// @param _state asset state, see Asset Struct description
808     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
809         assets[_tokenId].state = _state;
810     }
811 
812     /// @dev Update Cooldown for a single asset
813     /// @param _tokenId asset UniqueId
814     /// @param _cooldown asset state, see Asset Struct description
815     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
816     public validAsset(_tokenId) onlyGrantedContracts {
817         assets[_tokenId].cooldown = _cooldown;
818         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
819     }
820 
821     /*** GETTERS ***/
822 
823     /// @notice Returns only stats data about a specific asset.
824     /// @dev it is necessary due solidity compiler limitations
825     ///      when we have large qty of parameters it throws StackTooDeepException
826     /// @param _tokenId The UniqueId of the asset of interest.
827     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
828         return assets[_tokenId].stats;
829     }
830 
831     /// @dev return current price of an asset
832     /// @param _tokenId asset UniqueId
833     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
834         return assetIndexToPrice[_tokenId];
835     }
836 
837     /// @notice Check if asset has all attributes passed by parameter
838     /// @param _tokenId The UniqueId of the asset of interest.
839     /// @param _attributes see Asset Struct description
840     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
841         return assets[_tokenId].attributes & _attributes == _attributes;
842     }
843 
844     /// @notice Check if asset has any attribute passed by parameter
845     /// @param _tokenId The UniqueId of the asset of interest.
846     /// @param _attributes see Asset Struct description
847     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
848         return assets[_tokenId].attributes & _attributes != 0x0;
849     }
850 
851     /// @notice Check if asset is in the state passed by parameter
852     /// @param _tokenId The UniqueId of the asset of interest.
853     /// @param _category see AssetCategory in EthernautsBase for possible states
854     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
855         return assets[_tokenId].category == _category;
856     }
857 
858     /// @notice Check if asset is in the state passed by parameter
859     /// @param _tokenId The UniqueId of the asset of interest.
860     /// @param _state see enum AssetState in EthernautsBase for possible states
861     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
862         return assets[_tokenId].state == _state;
863     }
864 
865     /// @notice Returns owner of a given Asset(Token).
866     /// @dev Required for ERC-721 compliance.
867     /// @param _tokenId asset UniqueId
868     function ownerOf(uint256 _tokenId) public view returns (address owner)
869     {
870         return assetIndexToOwner[_tokenId];
871     }
872 
873     /// @dev Required for ERC-721 compliance
874     /// @notice Returns the number of Assets owned by a specific address.
875     /// @param _owner The owner address to check.
876     function balanceOf(address _owner) public view returns (uint256 count) {
877         return ownershipTokenCount[_owner];
878     }
879 
880     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
881     /// @param _tokenId asset UniqueId
882     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
883         return assetIndexToApproved[_tokenId];
884     }
885 
886     /// @notice Returns the total number of Assets currently in existence.
887     /// @dev Required for ERC-721 compliance.
888     function totalSupply() public view returns (uint256) {
889         return assets.length;
890     }
891 
892     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
893     /// @param _owner filter all assets by owner
894     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
895         uint256[6][]
896     ) {
897         uint256 totalAssets = assets.length;
898 
899         if (totalAssets == 0) {
900             // Return an empty array
901             return new uint256[6][](0);
902         } else {
903             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
904             uint256 resultIndex = 0;
905             bytes2 hasAttributes  = bytes2(_withAttributes);
906             Asset memory asset;
907 
908             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
909                 asset = assets[tokenId];
910                 if (
911                     (asset.state != uint8(AssetState.Used)) &&
912                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
913                     (asset.attributes & hasAttributes == hasAttributes)
914                 ) {
915                     result[resultIndex][0] = tokenId;
916                     result[resultIndex][1] = asset.ID;
917                     result[resultIndex][2] = asset.category;
918                     result[resultIndex][3] = uint256(asset.attributes);
919                     result[resultIndex][4] = asset.cooldown;
920                     result[resultIndex][5] = assetIndexToPrice[tokenId];
921                     resultIndex++;
922                 }
923             }
924 
925             return result;
926         }
927     }
928 }
929 
930 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
931 /// @notice This provides the methods required for basic non-fungible token
932 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
933 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
934 //          reference to logic contracts as Auction, Explore and so on
935 /// @author Ethernatus - Fernando Pauer
936 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
937 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
938 
939     /// @dev Contract holding only data.
940     EthernautsStorage public ethernautsStorage;
941 
942     /*** CONSTANTS ***/
943     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
944     string public constant name = "Ethernauts";
945     string public constant symbol = "ETNT";
946 
947     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
948     /**********************************************************************/
949 
950     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
951 
952     /*** EVENTS ***/
953 
954     // Events as per ERC-721
955     event Transfer(address indexed from, address indexed to, uint256 tokens);
956     event Approval(address indexed owner, address indexed approved, uint256 tokens);
957 
958     /// @dev When a new asset is create it emits build event
959     /// @param owner The address of asset owner
960     /// @param tokenId Asset UniqueID
961     /// @param assetId ID that defines asset look and feel
962     /// @param price asset price
963     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
964 
965     function implementsERC721() public pure returns (bool) {
966         return true;
967     }
968 
969     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
970     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
971     /// @param _interfaceID interface signature ID
972     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
973     {
974         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
975     }
976 
977     /// @dev Checks if a given address is the current owner of a particular Asset.
978     /// @param _claimant the address we are validating against.
979     /// @param _tokenId asset UniqueId, only valid when > 0
980     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
981         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
982     }
983 
984     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
985     /// @param _claimant the address we are confirming asset is approved for.
986     /// @param _tokenId asset UniqueId, only valid when > 0
987     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
988         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
989     }
990 
991     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
992     ///  approval. Setting _approved to address(0) clears all transfer approval.
993     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
994     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
995     ///  there is no value in spamming the log with Approval events in that case.
996     function _approve(uint256 _tokenId, address _approved) internal {
997         ethernautsStorage.approve(_tokenId, _approved);
998     }
999 
1000     /// @notice Returns the number of Assets owned by a specific address.
1001     /// @param _owner The owner address to check.
1002     /// @dev Required for ERC-721 compliance
1003     function balanceOf(address _owner) public view returns (uint256 count) {
1004         return ethernautsStorage.balanceOf(_owner);
1005     }
1006 
1007     /// @dev Required for ERC-721 compliance.
1008     /// @notice Transfers a Asset to another address. If transferring to a smart
1009     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1010     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
1011     /// @param _to The address of the recipient, can be a user or contract.
1012     /// @param _tokenId The ID of the Asset to transfer.
1013     function transfer(
1014         address _to,
1015         uint256 _tokenId
1016     )
1017     external
1018     whenNotPaused
1019     {
1020         // Safety check to prevent against an unexpected 0x0 default.
1021         require(_to != address(0));
1022         // Disallow transfers to this contract to prevent accidental misuse.
1023         // The contract should never own any assets
1024         // (except very briefly after it is created and before it goes on auction).
1025         require(_to != address(this));
1026         // Disallow transfers to the storage contract to prevent accidental
1027         // misuse. Auction or Upgrade contracts should only take ownership of assets
1028         // through the allow + transferFrom flow.
1029         require(_to != address(ethernautsStorage));
1030 
1031         // You can only send your own asset.
1032         require(_owns(msg.sender, _tokenId));
1033 
1034         // Reassign ownership, clear pending approvals, emit Transfer event.
1035         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
1036     }
1037 
1038     /// @dev Required for ERC-721 compliance.
1039     /// @notice Grant another address the right to transfer a specific Asset via
1040     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1041     /// @param _to The address to be granted transfer approval. Pass address(0) to
1042     ///  clear all approvals.
1043     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
1044     function approve(
1045         address _to,
1046         uint256 _tokenId
1047     )
1048     external
1049     whenNotPaused
1050     {
1051         // Only an owner can grant transfer approval.
1052         require(_owns(msg.sender, _tokenId));
1053 
1054         // Register the approval (replacing any previous approval).
1055         _approve(_tokenId, _to);
1056 
1057         // Emit approval event.
1058         Approval(msg.sender, _to, _tokenId);
1059     }
1060 
1061 
1062     /// @notice Transfer a Asset owned by another address, for which the calling address
1063     ///  has previously been granted transfer approval by the owner.
1064     /// @param _from The address that owns the Asset to be transferred.
1065     /// @param _to The address that should take ownership of the Asset. Can be any address,
1066     ///  including the caller.
1067     /// @param _tokenId The ID of the Asset to be transferred.
1068     function _transferFrom(
1069         address _from,
1070         address _to,
1071         uint256 _tokenId
1072     )
1073     internal
1074     {
1075         // Safety check to prevent against an unexpected 0x0 default.
1076         require(_to != address(0));
1077         // Disallow transfers to this contract to prevent accidental misuse.
1078         // The contract should never own any assets (except for used assets).
1079         require(_owns(_from, _tokenId));
1080         // Check for approval and valid ownership
1081         require(_approvedFor(_to, _tokenId));
1082 
1083         // Reassign ownership (also clears pending approvals and emits Transfer event).
1084         ethernautsStorage.transfer(_from, _to, _tokenId);
1085     }
1086 
1087     /// @dev Required for ERC-721 compliance.
1088     /// @notice Transfer a Asset owned by another address, for which the calling address
1089     ///  has previously been granted transfer approval by the owner.
1090     /// @param _from The address that owns the Asset to be transfered.
1091     /// @param _to The address that should take ownership of the Asset. Can be any address,
1092     ///  including the caller.
1093     /// @param _tokenId The ID of the Asset to be transferred.
1094     function transferFrom(
1095         address _from,
1096         address _to,
1097         uint256 _tokenId
1098     )
1099     external
1100     whenNotPaused
1101     {
1102         _transferFrom(_from, _to, _tokenId);
1103     }
1104 
1105     /// @dev Required for ERC-721 compliance.
1106     /// @notice Allow pre-approved user to take ownership of a token
1107     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1108     function takeOwnership(uint256 _tokenId) public {
1109         address _from = ethernautsStorage.ownerOf(_tokenId);
1110 
1111         // Safety check to prevent against an unexpected 0x0 default.
1112         require(_from != address(0));
1113         _transferFrom(_from, msg.sender, _tokenId);
1114     }
1115 
1116     /// @notice Returns the total number of Assets currently in existence.
1117     /// @dev Required for ERC-721 compliance.
1118     function totalSupply() public view returns (uint256) {
1119         return ethernautsStorage.totalSupply();
1120     }
1121 
1122     /// @notice Returns owner of a given Asset(Token).
1123     /// @param _tokenId Token ID to get owner.
1124     /// @dev Required for ERC-721 compliance.
1125     function ownerOf(uint256 _tokenId)
1126     external
1127     view
1128     returns (address owner)
1129     {
1130         owner = ethernautsStorage.ownerOf(_tokenId);
1131 
1132         require(owner != address(0));
1133     }
1134 
1135     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
1136     /// @param _creatorTokenID The asset who is father of this asset
1137     /// @param _price asset price
1138     /// @param _assetID asset ID
1139     /// @param _category see Asset Struct description
1140     /// @param _attributes see Asset Struct description
1141     /// @param _stats see Asset Struct description
1142     function createNewAsset(
1143         uint256 _creatorTokenID,
1144         uint256 _price,
1145         uint16 _assetID,
1146         uint8 _category,
1147         uint8 _attributes,
1148         uint8[STATS_SIZE] _stats
1149     )
1150     external onlyCLevel
1151     returns (uint256)
1152     {
1153         // owner must be sender
1154         require(msg.sender != address(0));
1155 
1156         uint256 tokenID = ethernautsStorage.createAsset(
1157             _creatorTokenID,
1158             msg.sender,
1159             _price,
1160             _assetID,
1161             _category,
1162             uint8(AssetState.Available),
1163             _attributes,
1164             _stats,
1165             0,
1166             0
1167         );
1168 
1169         // emit the build event
1170         Build(
1171             msg.sender,
1172             tokenID,
1173             _assetID,
1174             _price
1175         );
1176 
1177         return tokenID;
1178     }
1179 
1180     /// @notice verify if token is in exploration time
1181     /// @param _tokenId The Token ID that can be upgraded
1182     function isExploring(uint256 _tokenId) public view returns (bool) {
1183         uint256 cooldown;
1184         uint64 cooldownEndBlock;
1185         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
1186         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
1187     }
1188 }
1189 
1190 
1191 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
1192 /// @author Ethernatus - Fernando Pauer
1193 contract EthernautsLogic is EthernautsOwnership {
1194 
1195     // Set in case the logic contract is broken and an upgrade is required
1196     address public newContractAddress;
1197 
1198     /// @dev Constructor
1199     function EthernautsLogic() public {
1200         // the creator of the contract is the initial CEO, COO, CTO
1201         ceoAddress = msg.sender;
1202         ctoAddress = msg.sender;
1203         cooAddress = msg.sender;
1204         oracleAddress = msg.sender;
1205 
1206         // Starts paused.
1207         paused = true;
1208     }
1209 
1210     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1211     ///  breaking bug. This method does nothing but keep track of the new contract and
1212     ///  emit a message indicating that the new address is set. It's up to clients of this
1213     ///  contract to update to the new contract address in that case. (This contract will
1214     ///  be paused indefinitely if such an upgrade takes place.)
1215     /// @param _v2Address new address
1216     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
1217         // See README.md for updgrade plan
1218         newContractAddress = _v2Address;
1219         ContractUpgrade(_v2Address);
1220     }
1221 
1222     /// @dev set a new reference to the NFT ownership contract
1223     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
1224     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
1225         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
1226         require(candidateContract.isEthernautsStorage());
1227         ethernautsStorage = candidateContract;
1228     }
1229 
1230     /// @dev Override unpause so it requires all external contract addresses
1231     ///  to be set before contract can be unpaused. Also, we can't have
1232     ///  newContractAddress set either, because then the contract was upgraded.
1233     /// @notice This is public rather than external so we can call super.unpause
1234     ///  without using an expensive CALL.
1235     function unpause() public onlyCEO whenPaused {
1236         require(ethernautsStorage != address(0));
1237         require(newContractAddress == address(0));
1238         // require this contract to have access to storage contract
1239         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1240 
1241         // Actually unpause the contract.
1242         super.unpause();
1243     }
1244 
1245     // @dev Allows the COO to capture the balance available to the contract.
1246     function withdrawBalances(address _to) public onlyCLevel {
1247         _to.transfer(this.balance);
1248     }
1249 
1250     /// return current contract balance
1251     function getBalance() public view onlyCLevel returns (uint256) {
1252         return this.balance;
1253     }
1254 }
1255 
1256 /// @title Clock auction for non-fungible tokens.
1257 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1258 ///         This provides public methods for Upgrade ship.
1259 ///
1260 ///      - UpgradeShip: This provides public methods for managing how and if a ship can upgrade.
1261 ///             The user can place a number of Ship Upgrades on the ship to affect the ship’s exploration.
1262 ///             Combining the Explore and Upgrade actions together limits the amount of gas the user has to pay.
1263 /// @author Ethernatus - Fernando Pauer
1264 contract EthernautsUpgrade is EthernautsLogic, ClockAuctionBase {
1265 
1266     /// @dev Constructor creates a reference to the NFT ownership contract
1267     ///  and verifies the owner cut is in the valid range.
1268     ///  and Delegate constructor to Nonfungible contract.
1269     function EthernautsUpgrade() public
1270     EthernautsLogic() {}
1271 
1272     /*** EVENTS ***/
1273     /// @dev The Upgrade event is fired whenever a ship is upgraded.
1274     event Upgrade(uint256 indexed tokenId);
1275 
1276     /*** CONSTANTS ***/
1277     uint8 STATS_CAPOUT = 2**8 - 1; // all stats have a range from 0 to 255
1278 
1279     // ************************* UPGRADE SHIP ****************************
1280 
1281     /// @notice Check and define how a ship can upgrade
1282     /// Example:
1283     /// User A wants to Upgrade Ship A. Ship A has 5 available upgrade slots.
1284     /// Thankfully, User A has 5 Ship Upgrades in their inventory.
1285     /// They have 1x Plasma Cannons (+1 Attack), Hardened Plates (+2 Defense),
1286     ///           1x Navigation Processor (+1 Range), 1x Engine Tune (+2 Speed), and Lucky Shamrock (+1 Luck) .
1287     /// User A drags the 5 Ship Upgrades into the appropriate slots and hits the Upgrade button.
1288     /// Ship A’s stats are now improved by +1 Attack, +2 Defense, +1 Range, +2 Speed, and +1 Luck, forever.
1289     /// The Ship Upgrades are consumed and disappear. The Ship then increases in level +1 to a total level of 2.
1290     /// @param _tokenId The Token ID that can be upgraded
1291     /// @param _objects List of objects to be used in the upgrade
1292     function upgradeShip(uint256 _tokenId, uint256[SHIP_SLOTS] _objects) external whenNotPaused {
1293         // Checking if Asset is a ship or not
1294         require(ethernautsStorage.isCategory(_tokenId, uint8(AssetCategory.Ship)));
1295 
1296         // Ensure the Ship is in available state, otherwise it cannot be upgraded
1297         require(ethernautsStorage.isState(_tokenId, uint8(AssetState.Available)));
1298 
1299         // only owner can upgrade his/her ship
1300         require(msg.sender == ethernautsStorage.ownerOf(_tokenId));
1301 
1302         // ship could not be in exploration
1303         require(!isExploring(_tokenId));
1304 
1305         // get ship and objects current stats
1306         uint i = 0;
1307         uint8[STATS_SIZE] memory _shipStats = ethernautsStorage.getStats(_tokenId);
1308         uint256 level = _shipStats[uint(ShipStats.Level)];
1309         uint8[STATS_SIZE][SHIP_SLOTS] memory _objectsStats;
1310 
1311         // check if level capped out, if yes no more upgrade is available
1312         require(level < 5);
1313 
1314         // a mapping to require upgrades should have different token ids
1315         uint256[] memory upgradesToTokenIndex = new uint256[](ethernautsStorage.totalSupply());
1316 
1317         // all objects must be available to use
1318         for(i = 0; i < _objects.length; i++) {
1319             // sender should owner all assets
1320             require(msg.sender == ethernautsStorage.ownerOf(_objects[i]));
1321             require(!isExploring(_objects[i]));
1322             require(ethernautsStorage.isCategory(_objects[i], uint8(AssetCategory.Object)));
1323             // avoiding duplicate keys
1324             require(upgradesToTokenIndex[_objects[i]] == 0);
1325 
1326             // mark token id as read and avoid duplicated token ids
1327             upgradesToTokenIndex[_objects[i]] = _objects[i];
1328             _objectsStats[i] = ethernautsStorage.getStats(_objects[i]);
1329         }
1330 
1331         // upgrading stats
1332         uint256 attack = _shipStats[uint(ShipStats.Attack)];
1333         uint256 defense = _shipStats[uint(ShipStats.Defense)];
1334         uint256 speed = _shipStats[uint(ShipStats.Speed)];
1335         uint256 range = _shipStats[uint(ShipStats.Range)];
1336         uint256 luck = _shipStats[uint(ShipStats.Luck)];
1337 
1338         for(i = 0; i < SHIP_SLOTS; i++) {
1339             // Only objects with upgrades are allowed
1340             require(_objectsStats[i][1] +
1341                     _objectsStats[i][2] +
1342                     _objectsStats[i][3] +
1343                     _objectsStats[i][4] +
1344                     _objectsStats[i][5] > 0);
1345 
1346             attack += _objectsStats[i][uint(ShipStats.Attack)];
1347             defense += _objectsStats[i][uint(ShipStats.Defense)];
1348             speed += _objectsStats[i][uint(ShipStats.Speed)];
1349             range += _objectsStats[i][uint(ShipStats.Range)];
1350             luck += _objectsStats[i][uint(ShipStats.Luck)];
1351         }
1352 
1353         if (attack > STATS_CAPOUT) {
1354             attack = STATS_CAPOUT;
1355         }
1356         if (defense > STATS_CAPOUT) {
1357             defense = STATS_CAPOUT;
1358         }
1359         if (speed > STATS_CAPOUT) {
1360             speed = STATS_CAPOUT;
1361         }
1362         if (range > STATS_CAPOUT) {
1363             range = STATS_CAPOUT;
1364         }
1365         if (luck > STATS_CAPOUT) {
1366             luck = STATS_CAPOUT;
1367         }
1368 
1369         // All stats must increase, even if its provided 5 upgrades in the slots
1370         require(attack > _shipStats[uint(ShipStats.Attack)]);
1371         require(defense > _shipStats[uint(ShipStats.Defense)]);
1372         require(speed > _shipStats[uint(ShipStats.Speed)]);
1373         require(range > _shipStats[uint(ShipStats.Range)]);
1374         require(luck > _shipStats[uint(ShipStats.Luck)]);
1375 
1376         _shipStats[uint(ShipStats.Level)] = uint8(level + 1);
1377         _shipStats[uint(ShipStats.Attack)] = uint8(attack);
1378         _shipStats[uint(ShipStats.Defense)] = uint8(defense);
1379         _shipStats[uint(ShipStats.Speed)] = uint8(speed);
1380         _shipStats[uint(ShipStats.Range)] = uint8(range);
1381         _shipStats[uint(ShipStats.Luck)] = uint8(luck);
1382 
1383         // only upgrade after confirmed transaction by Upgrade Ship Contract
1384         ethernautsStorage.updateStats(_tokenId, _shipStats);
1385 
1386         // mark all objects as used and change owner
1387         for(i = 0; i < _objects.length; i++) {
1388             ethernautsStorage.updateState(_objects[i], uint8(AssetState.Used));
1389 
1390             // Register the approval and transfer to upgrade ship contract
1391             _approve(_objects[i], address(this));
1392             _transferFrom(msg.sender, address(this), _objects[i]);
1393         }
1394 
1395         Upgrade(_tokenId);
1396     }
1397 
1398 }