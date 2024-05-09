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
78     function max(uint256 a, uint256 b) internal pure returns (uint256) {
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
89     function min(uint256 a, uint256 b) internal pure returns (uint256) {
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
100 /// @title Auction Core
101 /// @dev Contains models, variables, and internal methods for the auction.
102 /// @notice We omit a fallback function to prevent accidental sends to this contract.
103 contract ClockAuctionBase {
104 
105     // Represents an auction on an NFT
106     struct Auction {
107         // Current owner of NFT
108         address seller;
109         // Price (in wei) at beginning of auction
110         uint128 startingPrice;
111         // Price (in wei) at end of auction
112         uint128 endingPrice;
113         // Duration (in seconds) of auction
114         uint64 duration;
115         // Time when auction started
116         // NOTE: 0 if this auction has been concluded
117         uint64 startedAt;
118     }
119 
120     // Reference to contract tracking NFT ownership
121     ERC721 public nonFungibleContract;
122 
123     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
124     // Values 0-10,000 map to 0%-100%
125     uint256 public ownerCut;
126 
127     // Map from token ID to their corresponding auction.
128     mapping (uint256 => Auction) tokenIdToAuction;
129 
130     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
131     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
132     event AuctionCancelled(uint256 tokenId);
133 
134     /// @dev Returns true if the claimant owns the token.
135     /// @param _claimant - Address claiming to own the token.
136     /// @param _tokenId - ID of token whose ownership to verify.
137     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
138         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
139     }
140 
141     /// @dev Transfers an NFT owned by this contract to another address.
142     /// Returns true if the transfer succeeds.
143     /// @param _receiver - Address to transfer NFT to.
144     /// @param _tokenId - ID of token to transfer.
145     function _transfer(address _receiver, uint256 _tokenId) internal {
146         // it will throw if transfer fails
147         nonFungibleContract.transfer(_receiver, _tokenId);
148     }
149 
150     /// @dev Adds an auction to the list of open auctions. Also fires the
151     ///  AuctionCreated event.
152     /// @param _tokenId The ID of the token to be put on auction.
153     /// @param _auction Auction to add.
154     function _addAuction(uint256 _tokenId, Auction _auction) internal {
155         // Require that all auctions have a duration of
156         // at least one minute. (Keeps our math from getting hairy!)
157         require(_auction.duration >= 1 minutes);
158 
159         tokenIdToAuction[_tokenId] = _auction;
160 
161         AuctionCreated(
162             uint256(_tokenId),
163             uint256(_auction.startingPrice),
164             uint256(_auction.endingPrice),
165             uint256(_auction.duration)
166         );
167     }
168 
169     /// @dev Cancels an auction unconditionally.
170     function _cancelAuction(uint256 _tokenId, address _seller) internal {
171         _removeAuction(_tokenId);
172         _transfer(_seller, _tokenId);
173         AuctionCancelled(_tokenId);
174     }
175 
176     /// @dev Computes the price and transfers winnings.
177     /// Does NOT transfer ownership of token.
178     function _bid(uint256 _tokenId, uint256 _bidAmount)
179     internal
180     returns (uint256)
181     {
182         // Get a reference to the auction struct
183         Auction storage auction = tokenIdToAuction[_tokenId];
184 
185         // Explicitly check that this auction is currently live.
186         // (Because of how Ethereum mappings work, we can't just count
187         // on the lookup above failing. An invalid _tokenId will just
188         // return an auction object that is all zeros.)
189         require(_isOnAuction(auction));
190 
191         // Check that the bid is greater than or equal to the current price
192         uint256 price = _currentPrice(auction);
193         require(_bidAmount >= price);
194 
195         // Grab a reference to the seller before the auction struct
196         // gets deleted.
197         address seller = auction.seller;
198 
199         // The bid is good! Remove the auction before sending the fees
200         // to the sender so we can't have a reentrancy attack.
201         _removeAuction(_tokenId);
202 
203         // Transfer proceeds to seller (if there are any!)
204         if (price > 0) {
205             // Calculate the auctioneer's cut.
206             // (NOTE: _computeCut() is guaranteed to return a
207             // value <= price, so this subtraction can't go negative.)
208             uint256 auctioneerCut = _computeCut(price);
209             uint256 sellerProceeds = price - auctioneerCut;
210 
211             // NOTE: Doing a transfer() in the middle of a complex
212             // method like this is generally discouraged because of
213             // reentrancy attacks and DoS attacks if the seller is
214             // a contract with an invalid fallback function. We explicitly
215             // guard against reentrancy attacks by removing the auction
216             // before calling transfer(), and the only thing the seller
217             // can DoS is the sale of their own asset! (And if it's an
218             // accident, they can call cancelAuction(). )
219             seller.transfer(sellerProceeds);
220         }
221 
222         // Calculate any excess funds included with the bid. If the excess
223         // is anything worth worrying about, transfer it back to bidder.
224         // NOTE: We checked above that the bid amount is greater than or
225         // equal to the price so this cannot underflow.
226         uint256 bidExcess = _bidAmount - price;
227 
228         // Return the funds. Similar to the previous transfer, this is
229         // not susceptible to a re-entry attack because the auction is
230         // removed before any transfers occur.
231         msg.sender.transfer(bidExcess);
232 
233         // Tell the world!
234         AuctionSuccessful(_tokenId, price, msg.sender);
235 
236         return price;
237     }
238 
239     /// @dev Removes an auction from the list of open auctions.
240     /// @param _tokenId - ID of NFT on auction.
241     function _removeAuction(uint256 _tokenId) internal {
242         delete tokenIdToAuction[_tokenId];
243     }
244 
245     /// @dev Returns true if the NFT is on auction.
246     /// @param _auction - Auction to check.
247     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
248         return (_auction.startedAt > 0);
249     }
250 
251     /// @dev Returns current price of an NFT on auction. Broken into two
252     ///  functions (this one, that computes the duration from the auction
253     ///  structure, and the other that does the price computation) so we
254     ///  can easily test that the price computation works correctly.
255     function _currentPrice(Auction storage _auction)
256     internal
257     view
258     returns (uint256)
259     {
260         uint256 secondsPassed = 0;
261 
262         // A bit of insurance against negative values (or wraparound).
263         // Probably not necessary (since Ethereum guarnatees that the
264         // now variable doesn't ever go backwards).
265         if (now > _auction.startedAt) {
266             secondsPassed = now - _auction.startedAt;
267         }
268 
269         return _computeCurrentPrice(
270             _auction.startingPrice,
271             _auction.endingPrice,
272             _auction.duration,
273             secondsPassed
274         );
275     }
276 
277     /// @dev Computes the current price of an auction. Factored out
278     ///  from _currentPrice so we can run extensive unit tests.
279     ///  When testing, make this function public and turn on
280     ///  `Current price computation` test suite.
281     function _computeCurrentPrice(
282         uint256 _startingPrice,
283         uint256 _endingPrice,
284         uint256 _duration,
285         uint256 _secondsPassed
286     )
287     internal
288     pure
289     returns (uint256)
290     {
291         // NOTE: We don't use SafeMath (or similar) in this function because
292         //  all of our public functions carefully cap the maximum values for
293         //  time (at 64-bits) and currency (at 128-bits). _duration is
294         //  also known to be non-zero (see the require() statement in
295         //  _addAuction())
296         if (_secondsPassed >= _duration) {
297             // We've reached the end of the dynamic pricing portion
298             // of the auction, just return the end price.
299             return _endingPrice;
300         } else {
301             // Starting price can be higher than ending price (and often is!), so
302             // this delta can be negative.
303             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
304 
305             // This multiplication can't overflow, _secondsPassed will easily fit within
306             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
307             // will always fit within 256-bits.
308             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
309 
310             // currentPriceChange can be negative, but if so, will have a magnitude
311             // less that _startingPrice. Thus, this result will always end up positive.
312             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
313 
314             return uint256(currentPrice);
315         }
316     }
317 
318     /// @dev Computes owner's cut of a sale.
319     /// @param _price - Sale price of NFT.
320     function _computeCut(uint256 _price) internal view returns (uint256) {
321         // NOTE: We don't use SafeMath (or similar) in this function because
322         //  all of our entry functions carefully cap the maximum values for
323         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
324         //  statement in the ClockAuction constructor). The result of this
325         //  function is always guaranteed to be <= _price.
326         return SafeMath.mul(_price, SafeMath.div(ownerCut,10000));
327     }
328 
329 }
330 
331 
332 
333 
334 /// @dev Base contract for all Ethernauts contracts holding global constants and functions.
335 contract EthernautsBase {
336 
337     /*** CONSTANTS USED ACROSS CONTRACTS ***/
338 
339     /// @dev Used by all contracts that interfaces with Ethernauts
340     ///      The ERC-165 interface signature for ERC-721.
341     ///  Ref: https://github.com/ethereum/EIPs/issues/165
342     ///  Ref: https://github.com/ethereum/EIPs/issues/721
343     bytes4 constant InterfaceSignature_ERC721 =
344     bytes4(keccak256('name()')) ^
345     bytes4(keccak256('symbol()')) ^
346     bytes4(keccak256('totalSupply()')) ^
347     bytes4(keccak256('balanceOf(address)')) ^
348     bytes4(keccak256('ownerOf(uint256)')) ^
349     bytes4(keccak256('approve(address,uint256)')) ^
350     bytes4(keccak256('transfer(address,uint256)')) ^
351     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
352     bytes4(keccak256('takeOwnership(uint256)')) ^
353     bytes4(keccak256('tokensOfOwner(address)')) ^
354     bytes4(keccak256('tokenMetadata(uint256,string)'));
355 
356     /// @dev due solidity limitation we cannot return dynamic array from methods
357     /// so it creates incompability between functions across different contracts
358     uint8 public constant STATS_SIZE = 10;
359     uint8 public constant SHIP_SLOTS = 5;
360 
361     // Possible state of any asset
362     enum AssetState { Available, UpForLease, Used }
363 
364     // Possible state of any asset
365     // NotValid is to avoid 0 in places where category must be bigger than zero
366     enum AssetCategory { NotValid, Sector, Manufacturer, Ship, Object, Factory, CrewMember }
367 
368     /// @dev Sector stats
369     enum ShipStats {Level, Attack, Defense, Speed, Range, Luck}
370     /// @notice Possible attributes for each asset
371     /// 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
372     /// 00000010 - Producible - Product of a factory and/or factory contract.
373     /// 00000100 - Explorable- Product of exploration.
374     /// 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
375     /// 00010000 - Permanent - Cannot be removed, always owned by a user.
376     /// 00100000 - Consumable - Destroyed after N exploration expeditions.
377     /// 01000000 - Tradable - Buyable and sellable on the market.
378     /// 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
379     bytes2 public ATTR_SEEDED     = bytes2(2**0);
380     bytes2 public ATTR_PRODUCIBLE = bytes2(2**1);
381     bytes2 public ATTR_EXPLORABLE = bytes2(2**2);
382     bytes2 public ATTR_LEASABLE   = bytes2(2**3);
383     bytes2 public ATTR_PERMANENT  = bytes2(2**4);
384     bytes2 public ATTR_CONSUMABLE = bytes2(2**5);
385     bytes2 public ATTR_TRADABLE   = bytes2(2**6);
386     bytes2 public ATTR_GOLDENGOOSE = bytes2(2**7);
387 }
388 
389 /// @notice This contract manages the various addresses and constraints for operations
390 //          that can be executed only by specific roles. Namely CEO and CTO. it also includes pausable pattern.
391 contract EthernautsAccessControl is EthernautsBase {
392 
393     // This facet controls access control for Ethernauts.
394     // All roles have same responsibilities and rights, but there is slight differences between them:
395     //
396     //     - The CEO: The CEO can reassign other roles and only role that can unpause the smart contract.
397     //       It is initially set to the address that created the smart contract.
398     //
399     //     - The CTO: The CTO can change contract address, oracle address and plan for upgrades.
400     //
401     //     - The COO: The COO can change contract address and add create assets.
402     //
403     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
404     /// @param newContract address pointing to new contract
405     event ContractUpgrade(address newContract);
406 
407     // The addresses of the accounts (or contracts) that can execute actions within each roles.
408     address public ceoAddress;
409     address public ctoAddress;
410     address public cooAddress;
411     address public oracleAddress;
412 
413     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
414     bool public paused = false;
415 
416     /// @dev Access modifier for CEO-only functionality
417     modifier onlyCEO() {
418         require(msg.sender == ceoAddress);
419         _;
420     }
421 
422     /// @dev Access modifier for CTO-only functionality
423     modifier onlyCTO() {
424         require(msg.sender == ctoAddress);
425         _;
426     }
427 
428     /// @dev Access modifier for CTO-only functionality
429     modifier onlyOracle() {
430         require(msg.sender == oracleAddress);
431         _;
432     }
433 
434     modifier onlyCLevel() {
435         require(
436             msg.sender == ceoAddress ||
437             msg.sender == ctoAddress ||
438             msg.sender == cooAddress
439         );
440         _;
441     }
442 
443     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
444     /// @param _newCEO The address of the new CEO
445     function setCEO(address _newCEO) external onlyCEO {
446         require(_newCEO != address(0));
447 
448         ceoAddress = _newCEO;
449     }
450 
451     /// @dev Assigns a new address to act as the CTO. Only available to the current CTO or CEO.
452     /// @param _newCTO The address of the new CTO
453     function setCTO(address _newCTO) external {
454         require(
455             msg.sender == ceoAddress ||
456             msg.sender == ctoAddress
457         );
458         require(_newCTO != address(0));
459 
460         ctoAddress = _newCTO;
461     }
462 
463     /// @dev Assigns a new address to act as the COO. Only available to the current COO or CEO.
464     /// @param _newCOO The address of the new COO
465     function setCOO(address _newCOO) external {
466         require(
467             msg.sender == ceoAddress ||
468             msg.sender == cooAddress
469         );
470         require(_newCOO != address(0));
471 
472         cooAddress = _newCOO;
473     }
474 
475     /// @dev Assigns a new address to act as oracle.
476     /// @param _newOracle The address of oracle
477     function setOracle(address _newOracle) external {
478         require(msg.sender == ctoAddress);
479         require(_newOracle != address(0));
480 
481         oracleAddress = _newOracle;
482     }
483 
484     /*** Pausable functionality adapted from OpenZeppelin ***/
485 
486     /// @dev Modifier to allow actions only when the contract IS NOT paused
487     modifier whenNotPaused() {
488         require(!paused);
489         _;
490     }
491 
492     /// @dev Modifier to allow actions only when the contract IS paused
493     modifier whenPaused {
494         require(paused);
495         _;
496     }
497 
498     /// @dev Called by any "C-level" role to pause the contract. Used only when
499     ///  a bug or exploit is detected and we need to limit damage.
500     function pause() external onlyCLevel whenNotPaused {
501         paused = true;
502     }
503 
504     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
505     ///  one reason we may pause the contract is when CTO account is compromised.
506     /// @notice This is public rather than external so it can be called by
507     ///  derived contracts.
508     function unpause() public onlyCEO whenPaused {
509         // can't unpause if contract was upgraded
510         paused = false;
511     }
512 
513 }
514 
515 
516 
517 
518 
519 
520 
521 
522 
523 /// @title Storage contract for Ethernauts Data. Common structs and constants.
524 /// @notice This is our main data storage, constants and data types, plus
525 //          internal functions for managing the assets. It is isolated and only interface with
526 //          a list of granted contracts defined by CTO
527 /// @author Ethernauts - Fernando Pauer
528 contract EthernautsStorage is EthernautsAccessControl {
529 
530     function EthernautsStorage() public {
531         // the creator of the contract is the initial CEO
532         ceoAddress = msg.sender;
533 
534         // the creator of the contract is the initial CTO as well
535         ctoAddress = msg.sender;
536 
537         // the creator of the contract is the initial CTO as well
538         cooAddress = msg.sender;
539 
540         // the creator of the contract is the initial Oracle as well
541         oracleAddress = msg.sender;
542     }
543 
544     /// @notice No tipping!
545     /// @dev Reject all Ether from being sent here. Hopefully, we can prevent user accidents.
546     function() external payable {
547         require(msg.sender == address(this));
548     }
549 
550     /*** Mapping for Contracts with granted permission ***/
551     mapping (address => bool) public contractsGrantedAccess;
552 
553     /// @dev grant access for a contract to interact with this contract.
554     /// @param _v2Address The contract address to grant access
555     function grantAccess(address _v2Address) public onlyCTO {
556         // See README.md for updgrade plan
557         contractsGrantedAccess[_v2Address] = true;
558     }
559 
560     /// @dev remove access from a contract to interact with this contract.
561     /// @param _v2Address The contract address to be removed
562     function removeAccess(address _v2Address) public onlyCTO {
563         // See README.md for updgrade plan
564         delete contractsGrantedAccess[_v2Address];
565     }
566 
567     /// @dev Only allow permitted contracts to interact with this contract
568     modifier onlyGrantedContracts() {
569         require(contractsGrantedAccess[msg.sender] == true);
570         _;
571     }
572 
573     modifier validAsset(uint256 _tokenId) {
574         require(assets[_tokenId].ID > 0);
575         _;
576     }
577     /*** DATA TYPES ***/
578 
579     /// @dev The main Ethernauts asset struct. Every asset in Ethernauts is represented by a copy
580     ///  of this structure. Note that the order of the members in this structure
581     ///  is important because of the byte-packing rules used by Ethereum.
582     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
583     struct Asset {
584 
585         // Asset ID is a identifier for look and feel in frontend
586         uint16 ID;
587 
588         // Category = Sectors, Manufacturers, Ships, Objects (Upgrades/Misc), Factories and CrewMembers
589         uint8 category;
590 
591         // The State of an asset: Available, On sale, Up for lease, Cooldown, Exploring
592         uint8 state;
593 
594         // Attributes
595         // byte pos - Definition
596         // 00000001 - Seeded - Offered to the economy by us, the developers. Potentially at regular intervals.
597         // 00000010 - Producible - Product of a factory and/or factory contract.
598         // 00000100 - Explorable- Product of exploration.
599         // 00001000 - Leasable - Can be rented to other users and will return to the original owner once the action is complete.
600         // 00010000 - Permanent - Cannot be removed, always owned by a user.
601         // 00100000 - Consumable - Destroyed after N exploration expeditions.
602         // 01000000 - Tradable - Buyable and sellable on the market.
603         // 10000000 - Hot Potato - Automatically gets put up for sale after acquiring.
604         bytes2 attributes;
605 
606         // The timestamp from the block when this asset was created.
607         uint64 createdAt;
608 
609         // The minimum timestamp after which this asset can engage in exploring activities again.
610         uint64 cooldownEndBlock;
611 
612         // The Asset's stats can be upgraded or changed based on exploration conditions.
613         // It will be defined per child contract, but all stats have a range from 0 to 255
614         // Examples
615         // 0 = Ship Level
616         // 1 = Ship Attack
617         uint8[STATS_SIZE] stats;
618 
619         // Set to the cooldown time that represents exploration duration for this asset.
620         // Defined by a successful exploration action, regardless of whether this asset is acting as ship or a part.
621         uint256 cooldown;
622 
623         // a reference to a super asset that manufactured the asset
624         uint256 builtBy;
625     }
626 
627     /*** CONSTANTS ***/
628 
629     // @dev Sanity check that allows us to ensure that we are pointing to the
630     //  right storage contract in our EthernautsLogic(address _CStorageAddress) call.
631     bool public isEthernautsStorage = true;
632 
633     /*** STORAGE ***/
634 
635     /// @dev An array containing the Asset struct for all assets in existence. The Asset UniqueId
636     ///  of each asset is actually an index into this array.
637     Asset[] public assets;
638 
639     /// @dev A mapping from Asset UniqueIDs to the price of the token.
640     /// stored outside Asset Struct to save gas, because price can change frequently
641     mapping (uint256 => uint256) internal assetIndexToPrice;
642 
643     /// @dev A mapping from asset UniqueIDs to the address that owns them. All assets have some valid owner address.
644     mapping (uint256 => address) internal assetIndexToOwner;
645 
646     // @dev A mapping from owner address to count of tokens that address owns.
647     //  Used internally inside balanceOf() to resolve ownership count.
648     mapping (address => uint256) internal ownershipTokenCount;
649 
650     /// @dev A mapping from AssetUniqueIDs to an address that has been approved to call
651     ///  transferFrom(). Each Asset can only have one approved address for transfer
652     ///  at any time. A zero value means no approval is outstanding.
653     mapping (uint256 => address) internal assetIndexToApproved;
654 
655 
656     /*** SETTERS ***/
657 
658     /// @dev set new asset price
659     /// @param _tokenId  asset UniqueId
660     /// @param _price    asset price
661     function setPrice(uint256 _tokenId, uint256 _price) public onlyGrantedContracts {
662         assetIndexToPrice[_tokenId] = _price;
663     }
664 
665     /// @dev Mark transfer as approved
666     /// @param _tokenId  asset UniqueId
667     /// @param _approved address approved
668     function approve(uint256 _tokenId, address _approved) public onlyGrantedContracts {
669         assetIndexToApproved[_tokenId] = _approved;
670     }
671 
672     /// @dev Assigns ownership of a specific Asset to an address.
673     /// @param _from    current owner address
674     /// @param _to      new owner address
675     /// @param _tokenId asset UniqueId
676     function transfer(address _from, address _to, uint256 _tokenId) public onlyGrantedContracts {
677         // Since the number of assets is capped to 2^32 we can't overflow this
678         ownershipTokenCount[_to]++;
679         // transfer ownership
680         assetIndexToOwner[_tokenId] = _to;
681         // When creating new assets _from is 0x0, but we can't account that address.
682         if (_from != address(0)) {
683             ownershipTokenCount[_from]--;
684             // clear any previously approved ownership exchange
685             delete assetIndexToApproved[_tokenId];
686         }
687     }
688 
689     /// @dev A public method that creates a new asset and stores it. This
690     ///  method does basic checking and should only be called from other contract when the
691     ///  input data is known to be valid. Will NOT generate any event it is delegate to business logic contracts.
692     /// @param _creatorTokenID The asset who is father of this asset
693     /// @param _owner First owner of this asset
694     /// @param _price asset price
695     /// @param _ID asset ID
696     /// @param _category see Asset Struct description
697     /// @param _state see Asset Struct description
698     /// @param _attributes see Asset Struct description
699     /// @param _stats see Asset Struct description
700     function createAsset(
701         uint256 _creatorTokenID,
702         address _owner,
703         uint256 _price,
704         uint16 _ID,
705         uint8 _category,
706         uint8 _state,
707         uint8 _attributes,
708         uint8[STATS_SIZE] _stats,
709         uint256 _cooldown,
710         uint64 _cooldownEndBlock
711     )
712     public onlyGrantedContracts
713     returns (uint256)
714     {
715         // Ensure our data structures are always valid.
716         require(_ID > 0);
717         require(_category > 0);
718         require(_attributes != 0x0);
719         require(_stats.length > 0);
720 
721         Asset memory asset = Asset({
722             ID: _ID,
723             category: _category,
724             builtBy: _creatorTokenID,
725             attributes: bytes2(_attributes),
726             stats: _stats,
727             state: _state,
728             createdAt: uint64(now),
729             cooldownEndBlock: _cooldownEndBlock,
730             cooldown: _cooldown
731             });
732 
733         uint256 newAssetUniqueId = assets.push(asset) - 1;
734 
735         // Check it reached 4 billion assets but let's just be 100% sure.
736         require(newAssetUniqueId == uint256(uint32(newAssetUniqueId)));
737 
738         // store price
739         assetIndexToPrice[newAssetUniqueId] = _price;
740 
741         // This will assign ownership
742         transfer(address(0), _owner, newAssetUniqueId);
743 
744         return newAssetUniqueId;
745     }
746 
747     /// @dev A public method that edit asset in case of any mistake is done during process of creation by the developer. This
748     /// This method doesn't do any checking and should only be called when the
749     ///  input data is known to be valid.
750     /// @param _tokenId The token ID
751     /// @param _creatorTokenID The asset that create that token
752     /// @param _price asset price
753     /// @param _ID asset ID
754     /// @param _category see Asset Struct description
755     /// @param _state see Asset Struct description
756     /// @param _attributes see Asset Struct description
757     /// @param _stats see Asset Struct description
758     /// @param _cooldown asset cooldown index
759     function editAsset(
760         uint256 _tokenId,
761         uint256 _creatorTokenID,
762         uint256 _price,
763         uint16 _ID,
764         uint8 _category,
765         uint8 _state,
766         uint8 _attributes,
767         uint8[STATS_SIZE] _stats,
768         uint16 _cooldown
769     )
770     external validAsset(_tokenId) onlyCLevel
771     returns (uint256)
772     {
773         // Ensure our data structures are always valid.
774         require(_ID > 0);
775         require(_category > 0);
776         require(_attributes != 0x0);
777         require(_stats.length > 0);
778 
779         // store price
780         assetIndexToPrice[_tokenId] = _price;
781 
782         Asset storage asset = assets[_tokenId];
783         asset.ID = _ID;
784         asset.category = _category;
785         asset.builtBy = _creatorTokenID;
786         asset.attributes = bytes2(_attributes);
787         asset.stats = _stats;
788         asset.state = _state;
789         asset.cooldown = _cooldown;
790     }
791 
792     /// @dev Update only stats
793     /// @param _tokenId asset UniqueId
794     /// @param _stats asset state, see Asset Struct description
795     function updateStats(uint256 _tokenId, uint8[STATS_SIZE] _stats) public validAsset(_tokenId) onlyGrantedContracts {
796         assets[_tokenId].stats = _stats;
797     }
798 
799     /// @dev Update only asset state
800     /// @param _tokenId asset UniqueId
801     /// @param _state asset state, see Asset Struct description
802     function updateState(uint256 _tokenId, uint8 _state) public validAsset(_tokenId) onlyGrantedContracts {
803         assets[_tokenId].state = _state;
804     }
805 
806     /// @dev Update Cooldown for a single asset
807     /// @param _tokenId asset UniqueId
808     /// @param _cooldown asset state, see Asset Struct description
809     function setAssetCooldown(uint256 _tokenId, uint256 _cooldown, uint64 _cooldownEndBlock)
810     public validAsset(_tokenId) onlyGrantedContracts {
811         assets[_tokenId].cooldown = _cooldown;
812         assets[_tokenId].cooldownEndBlock = _cooldownEndBlock;
813     }
814 
815     /*** GETTERS ***/
816 
817     /// @notice Returns only stats data about a specific asset.
818     /// @dev it is necessary due solidity compiler limitations
819     ///      when we have large qty of parameters it throws StackTooDeepException
820     /// @param _tokenId The UniqueId of the asset of interest.
821     function getStats(uint256 _tokenId) public view returns (uint8[STATS_SIZE]) {
822         return assets[_tokenId].stats;
823     }
824 
825     /// @dev return current price of an asset
826     /// @param _tokenId asset UniqueId
827     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
828         return assetIndexToPrice[_tokenId];
829     }
830 
831     /// @notice Check if asset has all attributes passed by parameter
832     /// @param _tokenId The UniqueId of the asset of interest.
833     /// @param _attributes see Asset Struct description
834     function hasAllAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
835         return assets[_tokenId].attributes & _attributes == _attributes;
836     }
837 
838     /// @notice Check if asset has any attribute passed by parameter
839     /// @param _tokenId The UniqueId of the asset of interest.
840     /// @param _attributes see Asset Struct description
841     function hasAnyAttrs(uint256 _tokenId, bytes2 _attributes) public view returns (bool) {
842         return assets[_tokenId].attributes & _attributes != 0x0;
843     }
844 
845     /// @notice Check if asset is in the state passed by parameter
846     /// @param _tokenId The UniqueId of the asset of interest.
847     /// @param _category see AssetCategory in EthernautsBase for possible states
848     function isCategory(uint256 _tokenId, uint8 _category) public view returns (bool) {
849         return assets[_tokenId].category == _category;
850     }
851 
852     /// @notice Check if asset is in the state passed by parameter
853     /// @param _tokenId The UniqueId of the asset of interest.
854     /// @param _state see enum AssetState in EthernautsBase for possible states
855     function isState(uint256 _tokenId, uint8 _state) public view returns (bool) {
856         return assets[_tokenId].state == _state;
857     }
858 
859     /// @notice Returns owner of a given Asset(Token).
860     /// @dev Required for ERC-721 compliance.
861     /// @param _tokenId asset UniqueId
862     function ownerOf(uint256 _tokenId) public view returns (address owner)
863     {
864         return assetIndexToOwner[_tokenId];
865     }
866 
867     /// @dev Required for ERC-721 compliance
868     /// @notice Returns the number of Assets owned by a specific address.
869     /// @param _owner The owner address to check.
870     function balanceOf(address _owner) public view returns (uint256 count) {
871         return ownershipTokenCount[_owner];
872     }
873 
874     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
875     /// @param _tokenId asset UniqueId
876     function approvedFor(uint256 _tokenId) public view onlyGrantedContracts returns (address) {
877         return assetIndexToApproved[_tokenId];
878     }
879 
880     /// @notice Returns the total number of Assets currently in existence.
881     /// @dev Required for ERC-721 compliance.
882     function totalSupply() public view returns (uint256) {
883         return assets.length;
884     }
885 
886     /// @notice List all existing tokens. It can be filtered by attributes or assets with owner
887     /// @param _owner filter all assets by owner
888     function getTokenList(address _owner, uint8 _withAttributes, uint256 start, uint256 count) external view returns(
889         uint256[6][]
890     ) {
891         uint256 totalAssets = assets.length;
892 
893         if (totalAssets == 0) {
894             // Return an empty array
895             return new uint256[6][](0);
896         } else {
897             uint256[6][] memory result = new uint256[6][](totalAssets > count ? count : totalAssets);
898             uint256 resultIndex = 0;
899             bytes2 hasAttributes  = bytes2(_withAttributes);
900             Asset memory asset;
901 
902             for (uint256 tokenId = start; tokenId < totalAssets && resultIndex < count; tokenId++) {
903                 asset = assets[tokenId];
904                 if (
905                     (asset.state != uint8(AssetState.Used)) &&
906                     (assetIndexToOwner[tokenId] == _owner || _owner == address(0)) &&
907                     (asset.attributes & hasAttributes == hasAttributes)
908                 ) {
909                     result[resultIndex][0] = tokenId;
910                     result[resultIndex][1] = asset.ID;
911                     result[resultIndex][2] = asset.category;
912                     result[resultIndex][3] = uint256(asset.attributes);
913                     result[resultIndex][4] = asset.cooldown;
914                     result[resultIndex][5] = assetIndexToPrice[tokenId];
915                     resultIndex++;
916                 }
917             }
918 
919             return result;
920         }
921     }
922 }
923 
924 /// @title The facet of the Ethernauts contract that manages ownership, ERC-721 compliant.
925 /// @notice This provides the methods required for basic non-fungible token
926 //          transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
927 //          It interfaces with EthernautsStorage provinding basic functions as create and list, also holds
928 //          reference to logic contracts as Auction, Explore and so on
929 /// @author Ethernatus - Fernando Pauer
930 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
931 contract EthernautsOwnership is EthernautsAccessControl, ERC721 {
932 
933     /// @dev Contract holding only data.
934     EthernautsStorage public ethernautsStorage;
935 
936     /*** CONSTANTS ***/
937     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
938     string public constant name = "Ethernauts";
939     string public constant symbol = "ETNT";
940 
941     /********* ERC 721 - COMPLIANCE CONSTANTS AND FUNCTIONS ***************/
942     /**********************************************************************/
943 
944     bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
945 
946     /*** EVENTS ***/
947 
948     // Events as per ERC-721
949     event Transfer(address indexed from, address indexed to, uint256 tokens);
950     event Approval(address indexed owner, address indexed approved, uint256 tokens);
951 
952     /// @dev When a new asset is create it emits build event
953     /// @param owner The address of asset owner
954     /// @param tokenId Asset UniqueID
955     /// @param assetId ID that defines asset look and feel
956     /// @param price asset price
957     event Build(address owner, uint256 tokenId, uint16 assetId, uint256 price);
958 
959     function implementsERC721() public pure returns (bool) {
960         return true;
961     }
962 
963     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
964     ///  Returns true for any standardized interfaces implemented by this contract. ERC-165 and ERC-721.
965     /// @param _interfaceID interface signature ID
966     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
967     {
968         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
969     }
970 
971     /// @dev Checks if a given address is the current owner of a particular Asset.
972     /// @param _claimant the address we are validating against.
973     /// @param _tokenId asset UniqueId, only valid when > 0
974     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
975         return ethernautsStorage.ownerOf(_tokenId) == _claimant;
976     }
977 
978     /// @dev Checks if a given address currently has transferApproval for a particular Asset.
979     /// @param _claimant the address we are confirming asset is approved for.
980     /// @param _tokenId asset UniqueId, only valid when > 0
981     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
982         return ethernautsStorage.approvedFor(_tokenId) == _claimant;
983     }
984 
985     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
986     ///  approval. Setting _approved to address(0) clears all transfer approval.
987     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
988     ///  _approve() and transferFrom() are used together for putting Assets on auction, and
989     ///  there is no value in spamming the log with Approval events in that case.
990     function _approve(uint256 _tokenId, address _approved) internal {
991         ethernautsStorage.approve(_tokenId, _approved);
992     }
993 
994     /// @notice Returns the number of Assets owned by a specific address.
995     /// @param _owner The owner address to check.
996     /// @dev Required for ERC-721 compliance
997     function balanceOf(address _owner) public view returns (uint256 count) {
998         return ethernautsStorage.balanceOf(_owner);
999     }
1000 
1001     /// @dev Required for ERC-721 compliance.
1002     /// @notice Transfers a Asset to another address. If transferring to a smart
1003     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1004     ///  Ethernauts specifically) or your Asset may be lost forever. Seriously.
1005     /// @param _to The address of the recipient, can be a user or contract.
1006     /// @param _tokenId The ID of the Asset to transfer.
1007     function transfer(
1008         address _to,
1009         uint256 _tokenId
1010     )
1011     external
1012     whenNotPaused
1013     {
1014         // Safety check to prevent against an unexpected 0x0 default.
1015         require(_to != address(0));
1016         // Disallow transfers to this contract to prevent accidental misuse.
1017         // The contract should never own any assets
1018         // (except very briefly after it is created and before it goes on auction).
1019         require(_to != address(this));
1020         // Disallow transfers to the storage contract to prevent accidental
1021         // misuse. Auction or Upgrade contracts should only take ownership of assets
1022         // through the allow + transferFrom flow.
1023         require(_to != address(ethernautsStorage));
1024 
1025         // You can only send your own asset.
1026         require(_owns(msg.sender, _tokenId));
1027 
1028         // Reassign ownership, clear pending approvals, emit Transfer event.
1029         ethernautsStorage.transfer(msg.sender, _to, _tokenId);
1030     }
1031 
1032     /// @dev Required for ERC-721 compliance.
1033     /// @notice Grant another address the right to transfer a specific Asset via
1034     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1035     /// @param _to The address to be granted transfer approval. Pass address(0) to
1036     ///  clear all approvals.
1037     /// @param _tokenId The ID of the Asset that can be transferred if this call succeeds.
1038     function approve(
1039         address _to,
1040         uint256 _tokenId
1041     )
1042     external
1043     whenNotPaused
1044     {
1045         // Only an owner can grant transfer approval.
1046         require(_owns(msg.sender, _tokenId));
1047 
1048         // Register the approval (replacing any previous approval).
1049         _approve(_tokenId, _to);
1050 
1051         // Emit approval event.
1052         Approval(msg.sender, _to, _tokenId);
1053     }
1054 
1055 
1056     /// @notice Transfer a Asset owned by another address, for which the calling address
1057     ///  has previously been granted transfer approval by the owner.
1058     /// @param _from The address that owns the Asset to be transferred.
1059     /// @param _to The address that should take ownership of the Asset. Can be any address,
1060     ///  including the caller.
1061     /// @param _tokenId The ID of the Asset to be transferred.
1062     function _transferFrom(
1063         address _from,
1064         address _to,
1065         uint256 _tokenId
1066     )
1067     internal
1068     {
1069         // Safety check to prevent against an unexpected 0x0 default.
1070         require(_to != address(0));
1071         // Disallow transfers to this contract to prevent accidental misuse.
1072         // The contract should never own any assets (except for used assets).
1073         require(_owns(_from, _tokenId));
1074         // Check for approval and valid ownership
1075         require(_approvedFor(_to, _tokenId));
1076 
1077         // Reassign ownership (also clears pending approvals and emits Transfer event).
1078         ethernautsStorage.transfer(_from, _to, _tokenId);
1079     }
1080 
1081     /// @dev Required for ERC-721 compliance.
1082     /// @notice Transfer a Asset owned by another address, for which the calling address
1083     ///  has previously been granted transfer approval by the owner.
1084     /// @param _from The address that owns the Asset to be transfered.
1085     /// @param _to The address that should take ownership of the Asset. Can be any address,
1086     ///  including the caller.
1087     /// @param _tokenId The ID of the Asset to be transferred.
1088     function transferFrom(
1089         address _from,
1090         address _to,
1091         uint256 _tokenId
1092     )
1093     external
1094     whenNotPaused
1095     {
1096         _transferFrom(_from, _to, _tokenId);
1097     }
1098 
1099     /// @dev Required for ERC-721 compliance.
1100     /// @notice Allow pre-approved user to take ownership of a token
1101     /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1102     function takeOwnership(uint256 _tokenId) public {
1103         address _from = ethernautsStorage.ownerOf(_tokenId);
1104 
1105         // Safety check to prevent against an unexpected 0x0 default.
1106         require(_from != address(0));
1107         _transferFrom(_from, msg.sender, _tokenId);
1108     }
1109 
1110     /// @notice Returns the total number of Assets currently in existence.
1111     /// @dev Required for ERC-721 compliance.
1112     function totalSupply() public view returns (uint256) {
1113         return ethernautsStorage.totalSupply();
1114     }
1115 
1116     /// @notice Returns owner of a given Asset(Token).
1117     /// @param _tokenId Token ID to get owner.
1118     /// @dev Required for ERC-721 compliance.
1119     function ownerOf(uint256 _tokenId)
1120     external
1121     view
1122     returns (address owner)
1123     {
1124         owner = ethernautsStorage.ownerOf(_tokenId);
1125 
1126         require(owner != address(0));
1127     }
1128 
1129     /// @dev Creates a new Asset with the given fields. ONly available for C Levels
1130     /// @param _creatorTokenID The asset who is father of this asset
1131     /// @param _price asset price
1132     /// @param _assetID asset ID
1133     /// @param _category see Asset Struct description
1134     /// @param _attributes see Asset Struct description
1135     /// @param _stats see Asset Struct description
1136     function createNewAsset(
1137         uint256 _creatorTokenID,
1138         uint256 _price,
1139         uint16 _assetID,
1140         uint8 _category,
1141         uint8 _attributes,
1142         uint8[STATS_SIZE] _stats
1143     )
1144     external onlyCLevel
1145     returns (uint256)
1146     {
1147         // owner must be sender
1148         require(msg.sender != address(0));
1149 
1150         uint256 tokenID = ethernautsStorage.createAsset(
1151             _creatorTokenID,
1152             msg.sender,
1153             _price,
1154             _assetID,
1155             _category,
1156             uint8(AssetState.Available),
1157             _attributes,
1158             _stats,
1159             0,
1160             0
1161         );
1162 
1163         // emit the build event
1164         Build(
1165             msg.sender,
1166             tokenID,
1167             _assetID,
1168             _price
1169         );
1170 
1171         return tokenID;
1172     }
1173 
1174     /// @notice verify if token is in exploration time
1175     /// @param _tokenId The Token ID that can be upgraded
1176     function isExploring(uint256 _tokenId) public view returns (bool) {
1177         uint256 cooldown;
1178         uint64 cooldownEndBlock;
1179         (,,,,,cooldownEndBlock, cooldown,) = ethernautsStorage.assets(_tokenId);
1180         return (cooldown > now) || (cooldownEndBlock > uint64(block.number));
1181     }
1182 }
1183 
1184 
1185 /// @title The facet of the Ethernauts Logic contract handle all common code for logic/business contracts
1186 /// @author Ethernatus - Fernando Pauer
1187 contract EthernautsLogic is EthernautsOwnership {
1188 
1189     // Set in case the logic contract is broken and an upgrade is required
1190     address public newContractAddress;
1191 
1192     /// @dev Constructor
1193     function EthernautsLogic() public {
1194         // the creator of the contract is the initial CEO, COO, CTO
1195         ceoAddress = msg.sender;
1196         ctoAddress = msg.sender;
1197         cooAddress = msg.sender;
1198         oracleAddress = msg.sender;
1199 
1200         // Starts paused.
1201         paused = true;
1202     }
1203 
1204     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1205     ///  breaking bug. This method does nothing but keep track of the new contract and
1206     ///  emit a message indicating that the new address is set. It's up to clients of this
1207     ///  contract to update to the new contract address in that case. (This contract will
1208     ///  be paused indefinitely if such an upgrade takes place.)
1209     /// @param _v2Address new address
1210     function setNewAddress(address _v2Address) external onlyCTO whenPaused {
1211         // See README.md for updgrade plan
1212         newContractAddress = _v2Address;
1213         ContractUpgrade(_v2Address);
1214     }
1215 
1216     /// @dev set a new reference to the NFT ownership contract
1217     /// @param _CStorageAddress - address of a deployed contract implementing EthernautsStorage.
1218     function setEthernautsStorageContract(address _CStorageAddress) public onlyCLevel whenPaused {
1219         EthernautsStorage candidateContract = EthernautsStorage(_CStorageAddress);
1220         require(candidateContract.isEthernautsStorage());
1221         ethernautsStorage = candidateContract;
1222     }
1223 
1224     /// @dev Override unpause so it requires all external contract addresses
1225     ///  to be set before contract can be unpaused. Also, we can't have
1226     ///  newContractAddress set either, because then the contract was upgraded.
1227     /// @notice This is public rather than external so we can call super.unpause
1228     ///  without using an expensive CALL.
1229     function unpause() public onlyCEO whenPaused {
1230         require(ethernautsStorage != address(0));
1231         require(newContractAddress == address(0));
1232         // require this contract to have access to storage contract
1233         require(ethernautsStorage.contractsGrantedAccess(address(this)) == true);
1234 
1235         // Actually unpause the contract.
1236         super.unpause();
1237     }
1238 
1239     // @dev Allows the COO to capture the balance available to the contract.
1240     function withdrawBalances(address _to) public onlyCLevel {
1241         _to.transfer(this.balance);
1242     }
1243 
1244     /// return current contract balance
1245     function getBalance() public view onlyCLevel returns (uint256) {
1246         return this.balance;
1247     }
1248 }
1249 
1250 /// @title Clock auction for non-fungible tokens.
1251 /// @notice We omit a fallback function to prevent accidental sends to this contract.
1252 ///         This provides public methods for auctioning or bidding on assets, purchase (GoldenGoose) and Upgrade ship.
1253 ///
1254 ///      - Auctions/Bidding: This provides public methods for auctioning or bidding on assets.
1255 ///             Auction creation is mostly mediated through this facet of the logic contract.
1256 ///
1257 ///      - Purchase: This provides public methods for buying GoldenGoose assets.
1258 /// @author Ethernatus - Fernando Pauer
1259 contract EthernautsMarket is EthernautsLogic, ClockAuctionBase {
1260 
1261     /// @dev Constructor creates a reference to the NFT ownership contract
1262     ///  and verifies the owner cut is in the valid range.
1263     ///  and Delegate constructor to EthernautsUpgrade contract.
1264     /// @param _cut - percent cut the owner takes on each auction, must be
1265     ///  between 0-10,000.
1266     function EthernautsMarket(uint256 _cut) public
1267     EthernautsLogic() {
1268         require(_cut <= 10000);
1269         ownerCut = _cut;
1270         nonFungibleContract = this;
1271     }
1272 
1273     /*** EVENTS ***/
1274     /// @dev The Purchase event is fired whenever a token is sold.
1275     event Purchase(uint256 indexed tokenId, uint256 oldPrice, uint256 newPrice, address indexed prevOwner, address indexed winner);
1276 
1277     /*** CONSTANTS ***/
1278     uint8 private percentageFee1Step = 95;
1279     uint8 private percentageFee2Step = 95;
1280     uint8 private percentageFeeSteps = 98;
1281     uint8 private percentageBase = 100;
1282     uint8 private percentage1Step = 200;
1283     uint8 private percentage2Step = 125;
1284     uint8 private percentageSteps = 115;
1285     uint256 private firstStepLimit =  0.05 ether;
1286     uint256 private secondStepLimit = 5 ether;
1287 
1288     // ************************* AUCTION AND BIDDING ****************************
1289     /// @dev Bids on an open auction, completing the auction and transferring
1290     ///  ownership of the NFT if enough Ether is supplied.
1291     /// @param _tokenId - ID of token to bid on.
1292     function bid(uint256 _tokenId)
1293     external
1294     payable
1295     whenNotPaused
1296     {
1297         // _bid will throw if the bid or funds transfer fails
1298         uint256 newPrice = _bid(_tokenId, msg.value);
1299         _transfer(msg.sender, _tokenId);
1300 
1301         // only set new price after transfer
1302         ethernautsStorage.setPrice(_tokenId, newPrice);
1303     }
1304 
1305     /// @dev Cancels an auction that hasn't been won yet.
1306     ///  Returns the NFT to original owner.
1307     /// @notice This is a state-modifying function that can
1308     ///  be called while the contract is paused.
1309     /// @param _tokenId - ID of token on auction
1310     function cancelAuction(uint256 _tokenId)
1311     external
1312     {
1313         Auction storage auction = tokenIdToAuction[_tokenId];
1314         require(_isOnAuction(auction));
1315         address seller = auction.seller;
1316         require(msg.sender == seller);
1317         _cancelAuction(_tokenId, seller);
1318     }
1319 
1320     /// @dev Cancels an auction when the contract is paused.
1321     ///  Only the owner may do this, and NFTs are returned to
1322     ///  the seller. This should only be used in emergencies.
1323     /// @param _tokenId - ID of the NFT on auction to cancel.
1324     function cancelAuctionWhenPaused(uint256 _tokenId)
1325     whenPaused
1326     onlyCLevel
1327     external
1328     {
1329         Auction storage auction = tokenIdToAuction[_tokenId];
1330         require(_isOnAuction(auction));
1331         _cancelAuction(_tokenId, auction.seller);
1332     }
1333 
1334     /// @dev Returns auction info for an NFT on auction.
1335     /// @param _tokenId - ID of NFT on auction.
1336     function getAuction(uint256 _tokenId)
1337     external
1338     view
1339     returns
1340     (
1341         address seller,
1342         uint256 startingPrice,
1343         uint256 endingPrice,
1344         uint256 duration,
1345         uint256 startedAt
1346     ) {
1347         Auction storage auction = tokenIdToAuction[_tokenId];
1348         require(_isOnAuction(auction));
1349         return (
1350         auction.seller,
1351         auction.startingPrice,
1352         auction.endingPrice,
1353         auction.duration,
1354         auction.startedAt
1355         );
1356     }
1357 
1358     /// @dev Returns the current price of an auction.
1359     /// @param _tokenId - ID of the token price we are checking.
1360     function getCurrentPrice(uint256 _tokenId)
1361     external
1362     view
1363     returns (uint256)
1364     {
1365         Auction storage auction = tokenIdToAuction[_tokenId];
1366         require(_isOnAuction(auction));
1367         return _currentPrice(auction);
1368     }
1369 
1370     /// @dev Creates and begins a new auction. Does some ownership trickery to create auctions in one tx.
1371     /// @param _tokenId - ID of token to auction, sender must be owner.
1372     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
1373     /// @param _endingPrice - Price of item (in wei) at end of auction.
1374     /// @param _duration - Length of time to move between starting
1375     ///  price and ending price (in seconds).
1376     function createSaleAuction(
1377         uint256 _tokenId,
1378         uint256 _startingPrice,
1379         uint256 _endingPrice,
1380         uint256 _duration
1381     )
1382     external
1383     whenNotPaused
1384     {
1385         // Sanity check that no inputs overflow how many bits we've allocated
1386         // to store them in the auction struct.
1387         require(_startingPrice == uint256(uint128(_startingPrice)));
1388         require(_endingPrice == uint256(uint128(_endingPrice)));
1389         require(_duration == uint256(uint64(_duration)));
1390 
1391         // Auction contract checks input sizes
1392         // If asset is already on any auction, this will throw
1393         // because it will be owned by the auction contract.
1394         require(_owns(msg.sender, _tokenId));
1395         // Ensure the asset is Tradeable and not GoldenGoose to prevent the auction
1396         // contract accidentally receiving ownership of the child.
1397         require(ethernautsStorage.hasAllAttrs(_tokenId, ATTR_TRADABLE));
1398         require(!ethernautsStorage.hasAllAttrs(_tokenId, ATTR_GOLDENGOOSE));
1399 
1400         // Ensure the asset is in available state, otherwise it cannot be sold
1401         require(ethernautsStorage.isState(_tokenId, uint8(AssetState.Available)));
1402 
1403         // asset or object could not be in exploration
1404         require(!isExploring(_tokenId));
1405 
1406         ethernautsStorage.approve(_tokenId, address(this));
1407 
1408         /// Escrows the NFT, assigning ownership to this contract.
1409         /// Throws if the escrow fails.
1410         _transferFrom(msg.sender, this, _tokenId);
1411 
1412         Auction memory auction = Auction(
1413             msg.sender,
1414             uint128(_startingPrice),
1415             uint128(_endingPrice),
1416             uint64(_duration),
1417             uint64(now)
1418         );
1419 
1420         _addAuction(_tokenId, auction);
1421     }
1422 
1423     /// @notice Any C-level can change sales cut.
1424     function setOwnerCut(uint256 _ownerCut) public onlyCLevel {
1425         ownerCut = _ownerCut;
1426     }
1427 
1428 
1429     // ************************* PURCHASE ****************************
1430 
1431     /// @notice Allows someone buy obtain an GoldenGoose asset token
1432     /// @param _tokenId The Token ID that can be purchased if Token is a GoldenGoose asset.
1433     function purchase(uint256 _tokenId) external payable whenNotPaused {
1434         // Checking if Asset is a GoldenGoose, if not this purchase is not allowed
1435         require(ethernautsStorage.hasAnyAttrs(_tokenId, ATTR_GOLDENGOOSE));
1436 
1437         // asset could not be in exploration
1438         require(!isExploring(_tokenId));
1439 
1440         address oldOwner = ethernautsStorage.ownerOf(_tokenId);
1441         address newOwner = msg.sender;
1442         uint256 sellingPrice = ethernautsStorage.priceOf(_tokenId);
1443 
1444         // Making sure token owner is not sending to self
1445         // it guarantees a fair market
1446         require(oldOwner != newOwner);
1447 
1448         // Safety check to prevent against an unexpected 0x0 default.
1449         require(newOwner != address(0));
1450 
1451         // Making sure sent amount is greater than or equal to the sellingPrice
1452         require(msg.value >= sellingPrice);
1453 
1454         uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFee1Step), 100));
1455         uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
1456         uint256 newPrice = sellingPrice;
1457 
1458         // Update prices
1459         if (sellingPrice < firstStepLimit) {
1460             // first stage
1461             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentage1Step), percentageBase);
1462         } else if (sellingPrice < secondStepLimit) {
1463             // redefining fees
1464             payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFee2Step), 100));
1465 
1466             // second stage
1467             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentage2Step), percentageBase);
1468         } else {
1469             // redefining fees
1470             payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentageFeeSteps), 100));
1471 
1472             // last stage
1473             newPrice = SafeMath.div(SafeMath.mul(sellingPrice, percentageSteps), percentageBase);
1474         }
1475 
1476         // Pay previous tokenOwner if owner is not contract
1477         if (oldOwner != address(this)) {
1478             oldOwner.transfer(payment); //(1-0.06)
1479         }
1480 
1481         // only transfer token after confirmed transaction
1482         ethernautsStorage.transfer(oldOwner, newOwner, _tokenId);
1483 
1484         // only set new price after confirmed transaction
1485         ethernautsStorage.setPrice(_tokenId, newPrice);
1486 
1487         Purchase(_tokenId, sellingPrice, newPrice, oldOwner, newOwner);
1488 
1489         // send excess back to buyer
1490         msg.sender.transfer(purchaseExcess);
1491     }
1492 
1493     /// @notice Any C-level can change first Step Limit.
1494     function setStepLimits(
1495         uint256 _firstStepLimit,
1496         uint256 _secondStepLimit
1497     ) public onlyCLevel {
1498         firstStepLimit = _firstStepLimit;
1499         secondStepLimit = _secondStepLimit;
1500     }
1501 
1502     /// @notice Any C-level can change percentage values
1503     function setPercentages(
1504         uint8 _Fee1,
1505         uint8 _Fee2,
1506         uint8 _Fees,
1507         uint8 _1Step,
1508         uint8 _2Step,
1509         uint8 _Steps
1510     ) public onlyCLevel {
1511         percentageFee1Step = _Fee1;
1512         percentageFee2Step = _Fee2;
1513         percentageFeeSteps = _Fees;
1514         percentage1Step = _1Step;
1515         percentage2Step = _2Step;
1516         percentageSteps = _Steps;
1517     }
1518 
1519 }