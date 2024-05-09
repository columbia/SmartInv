1 pragma solidity ^0.4.14;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8     address public owner;
9 
10     /**
11      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12      * account.
13      */
14     function Ownable() public {
15         owner = msg.sender;
16     }
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26   /**
27    * @dev Allows the current owner to transfer control of the contract to a newOwner.
28    * @param newOwner The address to transfer ownership to.
29    */
30     function transferOwnership(address newOwner) public onlyOwner {
31         if (newOwner != address(0)) {
32             owner = newOwner;
33         }
34     }
35 
36 }
37 
38 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
39 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
40 contract ERC721 {
41     // Required methods
42     function approve(address _to, uint256 _tokenId) external;
43     function transfer(address _to, uint256 _tokenId) external;
44     function transferFrom(address _from, address _to, uint256 _tokenId) external;
45     function ownerOf(uint256 _tokenId) external view returns (address owner);
46     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
47     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
48 
49     function totalSupply() public view returns (uint256 total);
50     function balanceOf(address _owner) public view returns (uint256 balance);
51 
52     // Events
53     event Transfer(address from, address to, uint256 tokenId);
54     event Approval(address owner, address approved, uint256 tokenId);
55 
56     // Optional
57     // function name() public view returns (string name);
58     // function symbol() public view returns (string symbol);
59     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
60     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
61 }
62 
63 /// @title The external contract that is responsible for generating metadata for the Artworks,
64 ///  it has one function that will return the data as bytes.
65 contract ERC721Metadata {
66     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
67     function getMetadata(uint256 _tokenId, string) public pure returns (bytes32[4] buffer, uint256 count) {
68         if (_tokenId == 1) {
69             buffer[0] = "Hello World! :D";
70             count = 15;
71         } else if (_tokenId == 2) {
72             buffer[0] = "I would definitely choose a medi";
73             buffer[1] = "um length string.";
74             count = 49;
75         } else if (_tokenId == 3) {
76             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
77             buffer[1] = "st accumsan dapibus augue lorem,";
78             buffer[2] = " tristique vestibulum id, libero";
79             buffer[3] = " suscipit varius sapien aliquam.";
80             count = 128;
81         }
82     }
83 }
84 
85 /// @title Auction Core
86 /// @dev Contains models, variables, and internal methods for the auction.
87 /// @notice We omit a fallback function to prevent accidental sends to this contract.
88 contract ClockAuctionBase {
89 
90     // Represents an auction on an NFT
91     struct Auction {
92         // Current owner of NFT
93         address seller;
94         // Price (in wei) at beginning of auction
95         uint128 startingPrice;
96         // Price (in wei) at end of auction
97         uint128 endingPrice;
98         // Duration (in seconds) of auction
99         uint64 duration;
100         // Time when auction started
101         // NOTE: 0 if this auction has been concluded
102         uint64 startedAt;
103     }
104 
105     // Reference to contract tracking NFT ownership
106     ERC721 public nonFungibleContract;
107 
108     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
109     // Values 0-10,000 map to 0%-100%
110     uint256 public ownerCut;
111 
112     // Map from token ID to their corresponding auction.
113     mapping (uint256 => Auction) internal tokenIdToAuction;
114 
115     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration, uint256 startedAt);
116     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
117     event AuctionCancelled(uint256 tokenId);
118 
119     /// @dev Returns true if the claimant owns the token.
120     /// @param _claimant - Address claiming to own the token.
121     /// @param _tokenId - ID of token whose ownership to verify.
122     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
123         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
124     }
125 
126     /// @dev Escrows the NFT, assigning ownership to this contract.
127     /// Throws if the escrow fails.
128     /// @param _owner - Current owner address of token to escrow.
129     /// @param _tokenId - ID of token whose approval to verify.
130     function _escrow(address _owner, uint256 _tokenId) internal {
131         // it will throw if transfer fails
132         nonFungibleContract.transferFrom(_owner, this, _tokenId);
133     }
134 
135     /// @dev Transfers an NFT owned by this contract to another address.
136     /// Returns true if the transfer succeeds.
137     /// @param _receiver - Address to transfer NFT to.
138     /// @param _tokenId - ID of token to transfer.
139     function _transfer(address _receiver, uint256 _tokenId) internal {
140         // it will throw if transfer fails
141         nonFungibleContract.transfer(_receiver, _tokenId);
142     }
143 
144     /// @dev Adds an auction to the list of open auctions. Also fires the
145     ///  AuctionCreated event.
146     /// @param _tokenId The ID of the token to be put on auction.
147     /// @param _auction Auction to add.
148     function _addAuction(uint256 _tokenId, Auction _auction) internal {
149         // Require that all auctions have a duration of
150         // at least one minute. (Keeps our math from getting hairy!)
151         require(_auction.duration >= 1 minutes);
152 
153         tokenIdToAuction[_tokenId] = _auction;
154 
155         AuctionCreated(
156             uint256(_tokenId),
157             uint256(_auction.startingPrice),
158             uint256(_auction.endingPrice),
159             uint256(_auction.duration),
160             uint256(_auction.startedAt)
161         );
162     }
163 
164     /// @dev Cancels an auction unconditionally.
165     function _cancelAuction(uint256 _tokenId, address _seller) internal {
166         _removeAuction(_tokenId);
167         _transfer(_seller, _tokenId);
168         AuctionCancelled(_tokenId);
169     }
170 
171     /// @dev Computes the price and transfers winnings.
172     /// Does NOT transfer ownership of token.
173     function _bid(uint256 _tokenId, uint256 _bidAmount) internal returns (uint256) {
174         // Get a reference to the auction struct
175         Auction storage auction = tokenIdToAuction[_tokenId];
176 
177         // Explicitly check that this auction is currently live.
178         //(Because of how Ethereum mappings work, we can't just count
179         // on the lookup above failing. An invalid _tokenId will just
180         // return an auction object that is all zeros.)
181         require(_isOnAuction(auction));
182 
183         // Check that the bid is greater than or equal to the current price
184         uint256 price = _currentPrice(auction);
185         require(_bidAmount >= price);
186 
187         // Grab a reference to the seller before the auction struct
188         // gets deleted.
189         address seller = auction.seller;
190 
191         // The bid is good! Remove the auction before sending the fees
192         // to the sender so we can't have a reentrancy attack.
193         _removeAuction(_tokenId);
194 
195         // Transfer proceeds to seller (if there are any!)
196         if (price > 0) {
197             // Calculate the auctioneer's cut. (NOTE: _computeCut() is guaranteed to return a
198             // value <= price, so this subtraction can't go negative.)
199             uint256 auctioneerCut = _computeCut(price);
200             uint256 sellerProceeds = price - auctioneerCut;
201             // NOTE: Doing a transfer() in the middle of a complex
202             // method like this is generally discouraged because of
203             // reentrancy attacks and DoS attacks if the seller is
204             // a contract with an invalid fallback function. We explicitly
205             // guard against reentrancy attacks by removing the auction
206             // before calling transfer(), and the only thing the seller
207             // can DoS is the sale of their own asset! (And if it's an
208             // accident, they can call cancelAuction(). )
209             seller.transfer(sellerProceeds);
210         }
211         // Calculate any excess funds included with the bid. If the excess
212         // is anything worth worrying about, transfer it back to bidder.
213         // NOTE: We checked above that the bid amount is greater than or
214         // equal to the price so this cannot underflow.
215         uint256 bidExcess = _bidAmount - price;
216 
217         // Return the funds. Similar to the previous transfer, this is
218         // not susceptible to a re-entry attack because the auction is
219         // removed before any transfers occur.
220         msg.sender.transfer(bidExcess);
221         // Tell the world!
222         AuctionSuccessful(_tokenId, price, msg.sender);
223         return price;
224     }
225 
226     /// @dev Removes an auction from the list of open auctions.
227     /// @param _tokenId - ID of NFT on auction.
228     function _removeAuction(uint256 _tokenId) internal {
229         delete tokenIdToAuction[_tokenId];
230     }
231 
232     /// @dev Returns true if the NFT is on auction.
233     /// @param _auction - Auction to check.
234     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
235         return (_auction.startedAt > 0);
236     }
237 
238     /// @dev Returns current price of an NFT on auction. Broken into two
239     ///  functions (this one, that computes the duration from the auction
240     ///  structure, and the other that does the price computation) so we
241     ///  can easily test that the price computation works correctly.
242     function _currentPrice(Auction storage _auction)
243         internal
244         view
245         returns (uint256)
246     {
247         uint256 secondsPassed = 0;
248 
249         // A bit of insurance against negative values (or wraparound).
250         // Probably not necessary (since Ethereum guarnatees that the
251         // now variable doesn't ever go backwards).
252         if (now > _auction.startedAt) {
253             secondsPassed = now - _auction.startedAt;
254         }
255 
256         return _computeCurrentPrice(
257             _auction.startingPrice,
258             _auction.endingPrice,
259             _auction.duration,
260             secondsPassed
261         );
262     }
263 
264     /// @dev Computes the current price of an auction. Factored out
265     ///  from _currentPrice so we can run extensive unit tests.
266     ///  When testing, make this function public and turn on
267     ///  `Current price computation` test suite.
268     function _computeCurrentPrice(
269         uint256 _startingPrice,
270         uint256 _endingPrice,
271         uint256 _duration,
272         uint256 _secondsPassed
273     )
274         internal
275         pure
276         returns (uint256)
277     {
278         // NOTE: We don't use SafeMath (or similar) in this function because
279         //  all of our public functions carefully cap the maximum values for
280         //  time (at 64-bits) and currency (at 128-bits). _duration is
281         //  also known to be non-zero (see the require() statement in
282         //  _addAuction())
283         if (_secondsPassed >= _duration) {
284             // We've reached the end of the dynamic pricing portion
285             // of the auction, just return the end price.
286             return _endingPrice;
287         } else {
288             // Starting price can be higher than ending price (and often is!), so
289             // this delta can be negative.
290             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
291 
292             // This multiplication can't overflow, _secondsPassed will easily fit within
293             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
294             // will always fit within 256-bits.
295             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
296 
297             // currentPriceChange can be negative, but if so, will have a magnitude
298             // less that _startingPrice. Thus, this result will always end up positive.
299             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
300 
301             return uint256(currentPrice);
302         }
303     }
304 
305     /// @dev Computes owner's cut of a sale.
306     /// @param _price - Sale price of NFT.
307     function _computeCut(uint256 _price) internal view returns (uint256) {
308         // NOTE: We don't use SafeMath (or similar) in this function because
309         //  all of our entry functions carefully cap the maximum values for
310         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
311         //  statement in the ClockAuction constructor). The result of this
312         //  function is always guaranteed to be <= _price.
313         return _price * ownerCut / 10000;
314     }
315 
316 }
317 
318 /// @title Clock auction for non-fungible tokens.
319 /// @notice We omit a fallback function to prevent accidental sends to this contract.
320 contract ClockAuction is Ownable, ClockAuctionBase {
321 
322     /// @dev The ERC-165 interface signature for ERC-721.
323     ///  Ref: https://github.com/ethereum/EIPs/issues/165
324     ///  Ref: https://github.com/ethereum/EIPs/issues/721
325     bytes4 public constant  INTERFACE_SIGNATURE_ERC721 = bytes4(0x9a20483d);
326 
327     /// @dev Constructor creates a reference to the NFT ownership contract
328     ///  and verifies the owner cut is in the valid range.
329     /// @param _nftAddress - address of a deployed contract implementing
330     ///  the Nonfungible Interface.
331     /// @param _cut - percent cut the owner takes on each auction, must be
332     ///  between 0-10,000.
333     function ClockAuction(address _nftAddress, uint256 _cut) public {
334         require(_cut <= 10000);
335         ownerCut = _cut;
336 
337         ERC721 candidateContract = ERC721(_nftAddress);
338         require(candidateContract.supportsInterface(INTERFACE_SIGNATURE_ERC721));
339         nonFungibleContract = candidateContract;
340     }
341 
342     /// @dev Remove all Ether from the contract, which is the owner's cuts
343     ///  as well as any Ether sent directly to the contract address.
344     ///  Always transfers to the NFT contract, but can be called either by
345     ///  the owner or the NFT contract.
346     function withdrawBalance() external {
347         address nftAddress = address(nonFungibleContract);
348 
349         require(
350             msg.sender == owner ||
351             msg.sender == nftAddress
352         );
353         // We are using this boolean method to make sure that even if one fails it will still work
354         bool res = nftAddress.send(this.balance);
355     }
356 
357     /// @dev Creates and begins a new auction.
358     /// @param _tokenId - ID of token to auction, sender must be owner.
359     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
360     /// @param _endingPrice - Price of item (in wei) at end of auction.
361     /// @param _duration - Length of time to move between starting
362     ///  price and ending price (in seconds).
363     /// @param _seller - Seller, if not the message sender
364     function createAuction(
365         uint256 _tokenId,
366         uint256 _startingPrice,
367         uint256 _endingPrice,
368         uint256 _duration,
369         address _seller
370     )
371         external
372     {
373         // Sanity check that no inputs overflow how many bits we've allocated
374         // to store them in the auction struct.
375         require(_startingPrice == uint256(uint128(_startingPrice)));
376         require(_endingPrice == uint256(uint128(_endingPrice)));
377         require(_duration == uint256(uint64(_duration)));
378 
379         require(_owns(msg.sender, _tokenId));
380         _escrow(msg.sender, _tokenId);
381         Auction memory auction = Auction(
382             _seller,
383             uint128(_startingPrice),
384             uint128(_endingPrice),
385             uint64(_duration),
386             uint64(now)
387         );
388         _addAuction(_tokenId, auction);
389     }
390 
391     /// @dev Bids on an open auction, completing the auction and transferring
392     ///  ownership of the NFT if enough Ether is supplied.
393     /// @param _tokenId - ID of token to bid on.
394     function bid(uint256 _tokenId)
395         external
396         payable
397     {
398         // _bid will throw if the bid or funds transfer fails
399         _bid(_tokenId, msg.value);
400         _transfer(msg.sender, _tokenId);
401     }
402 
403     /// @dev Cancels an auction that hasn't been won yet.
404     ///  Returns the NFT to original owner.
405     /// @notice This is a state-modifying function that can
406     ///  be called while the contract is paused.
407     /// @param _tokenId - ID of token on auction
408     function cancelAuction(uint256 _tokenId)
409         external
410     {
411         Auction storage auction = tokenIdToAuction[_tokenId];
412         require(_isOnAuction(auction));
413         address seller = auction.seller;
414         require(msg.sender == seller);
415         _cancelAuction(_tokenId, seller);
416     }
417 
418     /// @dev Returns auction info for an NFT on auction.
419     /// @param _tokenId - ID of NFT on auction.
420     function getAuction(uint256 _tokenId) external view returns (
421         address seller,
422         uint256 startingPrice,
423         uint256 endingPrice,
424         uint256 duration,
425         uint256 startedAt
426     ) {
427         Auction storage auction = tokenIdToAuction[_tokenId];
428         require(_isOnAuction(auction));
429         return (
430             auction.seller,
431             auction.startingPrice,
432             auction.endingPrice,
433             auction.duration,
434             auction.startedAt
435         );
436     }
437 
438     /// @dev Returns the current price of an auction.
439     /// @param _tokenId - ID of the token price we are checking.
440     function getCurrentPrice(uint256 _tokenId)
441         external
442         view
443         returns (uint256)
444     {
445         Auction storage auction = tokenIdToAuction[_tokenId];
446         require(_isOnAuction(auction));
447         return _currentPrice(auction);
448     }
449 
450 }
451 
452 /// @title Clock auction modified for sale of artworks
453 /// @notice We omit a fallback function to prevent accidental sends to this contract.
454 contract SaleClockAuction is ClockAuction {
455 
456     // @dev Sanity check that allows us to ensure that we are pointing to the
457     //  right auction in our setSaleAuctionAddress() call.
458     bool public isSaleClockAuction = true;
459 
460     // Tracks last 5 sale price of artwork sales
461     uint256 public artworkSaleCount;
462     uint256[5] public lastArtworkSalePrices;
463     uint256 internal value;
464 
465     // Delegate constructor
466     function SaleClockAuction(address _nftAddr, uint256 _cut) public ClockAuction(_nftAddr, _cut) {}
467 
468     /// @dev Creates and begins a new auction.
469     /// @param _tokenId - ID of token to auction, sender must be owner.
470     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
471     /// @param _endingPrice - Price of item (in wei) at end of auction.
472     /// @param _duration - Length of auction (in seconds).
473     /// @param _seller - Seller, if not the message sender
474     function createAuction(
475         uint256 _tokenId,
476         uint256 _startingPrice,
477         uint256 _endingPrice,
478         uint256 _duration,
479         address _seller
480     )
481         external
482     {
483         // Sanity check that no inputs overflow how many bits we've allocated
484         // to store them in the auction struct.
485         require(_startingPrice == uint256(uint128(_startingPrice)));
486         require(_endingPrice == uint256(uint128(_endingPrice)));
487         require(_duration == uint256(uint64(_duration)));
488         require(msg.sender == address(nonFungibleContract));
489 
490         _escrow(_seller, _tokenId);
491         Auction memory auction = Auction(
492             _seller,
493             uint128(_startingPrice),
494             uint128(_endingPrice),
495             uint64(_duration),
496             uint64(now)
497         );
498         _addAuction(_tokenId, auction);
499     }
500 
501     /// @dev Updates lastSalePrice if seller is the nft contract
502     /// Otherwise, works the same as default bid method.
503     function bid(uint256 _tokenId)
504         external
505         payable
506     {
507         // _bid verifies token ID size
508         address seller = tokenIdToAuction[_tokenId].seller;
509         uint256 price = _bid(_tokenId, msg.value);
510         _transfer(msg.sender, _tokenId);
511 
512         // If not a gen0 auction, exit
513         if (seller == address(nonFungibleContract)) {
514             // Track gen0 sale prices
515             lastArtworkSalePrices[artworkSaleCount % 5] = price;
516             value += price;
517             artworkSaleCount++;
518         }
519     }
520 
521     function averageArtworkSalePrice() external view returns (uint256) {
522         uint256 sum = 0;
523         for (uint256 i = 0; i < 5; i++) {
524             sum += lastArtworkSalePrices[i];
525         }
526         return sum / 5;
527     }
528 
529     function getValue() external view returns (uint256) {
530         return value;
531     }
532 
533 }
534 
535 
536 contract ArtworkAccessControl {
537     // This facet controls access control for CryptoArtworks. There are four roles managed here:
538     //
539     //     - The CEO: The CEO can reassign other roles and change the addresses of our dependent smart
540     //         contracts. It is also the only role that can unpause the smart contract. It is initially
541     //         set to the address that created the smart contract in the ArtworkCore constructor.
542     //
543     //     - The CFO: The CFO can withdraw funds from ArtworkCore and its auction contracts.
544     //
545     //     - The COO: The COO can release artworks to auction, and mint promo arts.
546     //
547     // It should be noted that these roles are distinct without overlap in their access abilities, the
548     // abilities listed for each role above are exhaustive. In particular, while the CEO can assign any
549     // address to any role, the CEO address itself doesn't have the ability to act in those roles. This
550     // restriction is intentional so that we aren't tempted to use the CEO address frequently out of
551     // convenience. The less we use an address, the less likely it is that we somehow compromise the
552     // account.
553 
554     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
555     event ContractUpgrade(address newContract);
556 
557     // The addresses of the accounts (or contracts) that can execute actions within each roles.
558     address public ceoAddress;
559     address public cfoAddress;
560     address public cooAddress;
561 
562     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
563     bool public paused = false;
564 
565     /// @dev Access modifier for CEO-only functionality
566     modifier onlyCEO() {
567         require(msg.sender == ceoAddress);
568         _;
569     }
570 
571     /// @dev Access modifier for CFO-only functionality
572     modifier onlyCFO() {
573         require(msg.sender == cfoAddress);
574         _;
575     }
576 
577     /// @dev Access modifier for COO-only functionality
578     modifier onlyCOO() {
579         require(msg.sender == cooAddress);
580         _;
581     }
582 
583     modifier onlyCLevel() {
584         require(
585             msg.sender == cooAddress ||
586             msg.sender == ceoAddress ||
587             msg.sender == cfoAddress
588         );
589         _;
590     }
591 
592     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
593     /// @param _newCEO The address of the new CEO
594     function setCEO(address _newCEO) external onlyCEO {
595         require(_newCEO != address(0));
596 
597         ceoAddress = _newCEO;
598     }
599 
600     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
601     /// @param _newCFO The address of the new CFO
602     function setCFO(address _newCFO) external onlyCEO {
603         require(_newCFO != address(0));
604 
605         cfoAddress = _newCFO;
606     }
607 
608     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
609     /// @param _newCOO The address of the new COO
610     function setCOO(address _newCOO) external onlyCEO {
611         require(_newCOO != address(0));
612 
613         cooAddress = _newCOO;
614     }
615 
616     /*** Pausable functionality adapted from OpenZeppelin ***/
617     /// @dev Modifier to allow actions only when the contract IS NOT paused
618     modifier whenNotPaused() {
619         require(!paused);
620         _;
621     }
622 
623     /// @dev Modifier to allow actions only when the contract IS paused
624     modifier whenPaused {
625         require(paused);
626         _;
627     }
628 
629     /// @notice This is public rather than external so it can be called by
630     ///  derived contracts.
631     function unpause() public onlyCEO whenPaused {
632         // can't unpause if contract was upgraded
633         paused = false;
634     }
635 }
636 
637 
638 /// @title Base contract for CryptoArtworks. Holds all common structs, events and base variables.
639 /// @dev See the ArtworkCore contract documentation to understand how the various contract facets are arranged.
640 contract ArtworkBase is ArtworkAccessControl {
641     /*** EVENTS ***/
642 
643     /// @dev The Birth event is fired whenever a new artwork comes into existence. This obviously
644     ///  includes any time a artwork is created through the giveBirth method, but it is also called
645     ///  when a new artwork is created.
646     event Birth(address owner, uint256 artworkId, string name, string author, uint32 series);
647 
648     /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a artwork
649     ///  ownership is assigned, including births.
650     event Transfer(address from, address to, uint256 tokenId);
651 
652     /*** DATA TYPES ***/
653     /// @dev The main Artwork struct. Every art in CryptoArtworks is represented by a copy
654     ///  of this structure, so great care was taken to ensure that it fits neatly into
655     ///  exactly two 256-bit words. Note that the order of the members in this structure
656     ///  is important because of the byte-packing rules used by Ethereum.
657     ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
658     struct Artwork {
659          // The timestamp from the block when this artwork came into existence.
660         uint64 birthTime;
661         // The name of the artwork
662         string name;
663         string author;
664         //sometimes artists produce a series of paintings with the same name
665         //in order to separate them from each other by introducing a variable series.
666         //Series with number 0 means that the picture was without series
667         uint32 series;
668     }
669 
670     // An approximation of currently how many seconds are in between blocks.
671     // uint256 public secondsPerBlock = 15;
672     /*** STORAGE ***/
673     /// @dev An array containing the Artwork struct for all Artworks in existence. The ID
674     ///  of each artwork is actually an index into this array.
675     ///  Artwork ID 0 is invalid... ;-)
676     Artwork[] internal artworks;
677     /// @dev A mapping from artwork IDs to the address that owns them. All artworks have
678     ///  some valid owner address.
679     mapping (uint256 => address) public artworkIndexToOwner;
680 
681     // @dev A mapping from owner address to count of tokens that address owns.
682     //  Used internally inside balanceOf() to resolve ownership count.
683     mapping (address => uint256) internal ownershipTokenCount;
684 
685     /// @dev A mapping from artworkIDs to an address that has been approved to call
686     ///  transferFrom(). Each Artwork can only have one approved address for transfer
687     ///  at any time. A zero value means no approval is outstanding.
688     mapping (uint256 => address) public artworkIndexToApproved;
689 
690 
691     /// @dev The address of the ClockAuction contract that handles sales of Artworks. This
692     ///  same contract handles both peer-to-peer sales as well as the initial sales which are
693     ///  initiated every 15 minutes.
694     SaleClockAuction public saleAuction;
695 
696     /// @dev Assigns ownership of a specific Artwork to an address.
697     function _transfer(address _from, address _to, uint256 _tokenId) internal {
698         // Since the number of artworks is capped to 2^32 we can't overflow this
699         ownershipTokenCount[_to]++;
700         // transfer ownership
701         artworkIndexToOwner[_tokenId] = _to;
702         // When creating new artworks _from is 0x0, but we can't account that address.
703         if (_from != address(0)) {
704             ownershipTokenCount[_from]--;
705             // clear any previously approved ownership exchange
706             delete artworkIndexToApproved[_tokenId];
707         }
708         // Emit the transfer event.
709         Transfer(_from, _to, _tokenId);
710     }
711 
712     /// @dev An internal method that creates a new artwork and stores it. This
713     ///  method doesn't do any checking and should only be called when the
714     ///  input data is known to be valid. Will generate both a Birth event
715     ///  and a Transfer event.
716     /// @param _id The artwork's genetic code.
717     /// @param _owner The inital owner of this art, must be non-zero (except for ID 0)
718          // The timestamp from the block when this artwork came into existence.
719     uint64 internal birthTime;
720     string internal author;
721     // The name of the artwork
722     string internal name;
723     uint32 internal series;
724 
725     function _createArtwork(string _name, string _author, uint32 _series, address _owner ) internal returns (uint) {
726         Artwork memory _artwork = Artwork({ birthTime: uint64(now), name: _name, author: _author, series: _series});
727         uint256 newArtworkId = artworks.push(_artwork) - 1;
728 
729         // It's probably never going to happen, 4 billion artworks is A LOT, but
730         // let's just be 100% sure we never let this happen.
731         require(newArtworkId == uint256(uint32(newArtworkId)));
732 
733         // emit the birth event
734         Birth(_owner, newArtworkId, _artwork.name, _artwork.author, _series);
735 
736         // This will assign ownership, and also emit the Transfer event as
737         // per ERC721 draft
738         _transfer(0, _owner, newArtworkId);
739 
740         return newArtworkId;
741     }
742 
743 }
744 
745 
746     // Creates dictionary with unique keys, if the key is already used then its value will be true.
747     // It is not possible to create a duplicate.
748 contract ArtworkUnique {
749 
750     //mapping with unique key
751     mapping  (bytes32 => bool) internal uniqueArtworks;
752     
753     //Creates a unique key based on the artwork name, author, and series
754     function getUniqueKey(string name, string author, uint32 _version)  internal pure returns(bytes32) {
755         string memory version = _uintToString(_version);
756         string memory main = _strConcat(name, author, version, "$%)");
757         string memory lowercased = _toLower(main);
758         return keccak256(lowercased);
759     }
760     
761     //https://gist.github.com/thomasmaclean/276cb6e824e48b7ca4372b194ec05b97
762     //transform to lowercase
763     function _toLower(string str) internal pure returns (string)  {
764 		bytes memory bStr = bytes(str);
765 		bytes memory bLower = new bytes(bStr.length);
766 		for (uint i = 0; i < bStr.length; i++) {
767 			// Uppercase character...
768 			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
769 				// So we add 32 to make it lowercase
770 				bLower[i] = bytes1(int(bStr[i]) + 32);
771 			} else {
772 				bLower[i] = bStr[i];
773 			}
774 		}
775 		return string(bLower);
776 	}
777 	
778     //creates a unique key from all variables
779     function _strConcat(string _a, string _b, string _c, string _separator) internal pure returns (string) {
780         bytes memory _ba = bytes(_a);
781         bytes memory _bb = bytes(_separator);
782         bytes memory _bc = bytes(_b);
783         bytes memory _bd = bytes(_separator);
784         bytes memory _be = bytes(_c);
785         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
786         bytes memory babcde = bytes(abcde);
787         uint k = 0;
788         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
789         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
790         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
791         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
792         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
793         return string(babcde);
794     }
795 
796     //convert uint To String
797     function _uintToString(uint v) internal pure returns (string) {
798         bytes32 data = _uintToBytes(v);
799         return _bytes32ToString(data);
800     }
801 
802     /// title String Utils - String utility functions
803     /// @author Piper Merriam - <pipermerriam@gmail.com>
804     ///https://github.com/pipermerriam/ethereum-string-utils
805     function _uintToBytes(uint v) private pure returns (bytes32 ret) {
806         if (v == 0) {
807             ret = "0";
808         } else {
809             while (v > 0) {
810                 ret = bytes32(uint(ret) / (2 ** 8));
811                 ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
812                 v /= 10;
813             }
814         }
815         return ret;
816     }
817 
818     function _bytes32ToString(bytes32 x) private pure returns (string) {
819         bytes memory bytesString = new bytes(32);
820         uint charCount = 0;
821         for (uint j = 0; j < 32; j++) {
822             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
823             if (char != 0) {
824                 bytesString[charCount] = char;
825                 charCount++;
826             }
827         }
828         bytes memory bytesStringTrimmed = new bytes(charCount);
829         for (j = 0; j < charCount; j++) {
830             bytesStringTrimmed[j] = bytesString[j];
831         }
832         return string(bytesStringTrimmed);
833     }
834 }
835 
836 
837 /// @title The facet of the CryptoArtworks core contract that manages ownership, ERC-721 (draft) compliant.
838 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
839 ///  See the ArtworkCore contract documentation to understand how the various contract facets are arranged.
840 contract ArtworkOwnership is ArtworkBase, ArtworkUnique, ERC721 {
841 
842     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
843     string public constant NAME = "CryptoArtworks";
844     string public constant SYMBOL = "CA";
845 
846     // The contract that will return artwork metadata
847     ERC721Metadata public erc721Metadata;
848 
849     bytes4 private constant INTERFACE_SIGNATURE_ERC165 =
850     bytes4(keccak256("supportsInterface(bytes4)"));
851 
852     bytes4 private constant INTERFACE_SIGNATURE_ERC721 =
853         bytes4(keccak256("name()")) ^
854         bytes4(keccak256("symbol()")) ^
855         bytes4(keccak256("totalSupply()")) ^
856         bytes4(keccak256("balanceOf(address)")) ^
857         bytes4(keccak256("ownerOf(uint256)")) ^
858         bytes4(keccak256("approve(address,uint256)")) ^
859         bytes4(keccak256("transfer(address,uint256)")) ^
860         bytes4(keccak256("transferFrom(address,address,uint256)")) ^
861         bytes4(keccak256("tokensOfOwner(address)")) ^
862     bytes4(keccak256("tokenMetadata(uint256,string)"));
863 
864     /// @notice Grant another address the right to transfer a specific Artwork via
865     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
866     /// @param _to The address to be granted transfer approval. Pass address(0) to
867     ///  clear all approvals.
868     /// @param _tokenId The ID of the Artwork that can be transferred if this call succeeds.
869     /// @dev Required for ERC-721 compliance.
870     function approve(
871         address _to,
872         uint256 _tokenId
873     )
874         external
875         whenNotPaused
876     {
877         // Only an owner can grant transfer approval.
878         require(_owns(msg.sender, _tokenId));
879 
880         // Register the approval (replacing any previous approval).
881         _approve(_tokenId, _to);
882 
883         // Emit approval event.
884         Approval(msg.sender, _to, _tokenId);
885     }
886 
887     /// @notice Transfer a Artwork owned by another address, for which the calling address
888     ///  has previously been granted transfer approval by the owner.
889     /// @param _from The address that owns the Artwork to be transfered.
890     /// @param _to The address that should take ownership of the Artwork. Can be any address,
891     ///  including the caller.
892     /// @param _tokenId The ID of the Artwork to be transferred.
893     /// @dev Required for ERC-721 compliance.
894     function transferFrom(
895         address _from,
896         address _to,
897         uint256 _tokenId
898     )
899         external
900         whenNotPaused
901     {
902         // Safety check to prevent against an unexpected 0x0 default.
903         require(_to != address(0));
904         // Disallow transfers to this contract to prevent accidental misuse.
905         // The contract should never own any artworks (except very briefly
906         // after a artwork is created and before it goes on auction).
907         require(_to != address(this));
908         // Check for approval and valid ownership
909         require(_approvedFor(msg.sender, _tokenId));
910         require(_owns(_from, _tokenId));
911 
912         // Reassign ownership (also clears pending approvals and emits Transfer event).
913         _transfer(_from, _to, _tokenId);
914     }
915 
916     /// @notice Transfers a Artwork to another address. If transferring to a smart
917     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
918     ///  CryptoArtworks specifically) or your Artwork may be lost forever. Seriously.
919     /// @param _to The address of the recipient, can be a user or contract.
920     /// @param _tokenId The ID of the Artwork to transfer.
921     /// @dev Required for ERC-721 compliance.
922     function transfer(address _to, uint256 _tokenId) external whenNotPaused {
923 
924         // Safety check to prevent against an unexpected 0x0 default.
925         require(_to != address(0));
926 
927         // Disallow transfers to this contract to prevent accidental misuse.
928         // The contract should never own any Artworks (except very briefly
929         // after a  artwork is created and before it goes on auction).
930         require(_to != address(this));
931 
932         // Disallow transfers to the auction contracts to prevent accidental
933         // misuse. Auction contracts should only take ownership of artworks
934         // through the allow + transferFrom flow.
935         require(_to != address(saleAuction));
936 
937         // You can only send your own artwork.
938         require(_owns(msg.sender, _tokenId));
939 
940         // Reassign ownership, clear pending approvals, emit Transfer event.
941         _transfer(msg.sender, _to, _tokenId);
942 
943     }
944 
945     /// @notice Returns a list of all Artwork IDs assigned to an address.
946     /// @param _owner The owner whose Artworks we are interested in.
947     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
948     ///  expensive (it walks the entire Artwork array looking for arts belonging to owner),
949     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
950     ///  not contract-to-contract calls.
951     function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
952         uint256 tokenCount = balanceOf(_owner);
953 
954         if (tokenCount == 0) {
955             // Return an empty array
956             return new uint256[](0);
957         } else {
958             uint256[] memory result = new uint256[](tokenCount);
959             uint256 totalArts = totalSupply();
960             uint256 resultIndex = 0;
961 
962             // We count on the fact that all arts have IDs starting at 1 and increasing
963             // sequentially up to the totalArt count.
964             uint256 artworkId;
965 
966             for (artworkId = 1; artworkId <= totalArts; artworkId++) {
967                 if (artworkIndexToOwner[artworkId] == _owner) {
968                     result[resultIndex] = artworkId;
969                     resultIndex++;
970                 }
971             }
972 
973             return result;
974         }
975     }
976 
977     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
978     ///  Returns true for any standardized interfaces implemented by this contract. We implement
979     ///  ERC-165 (obviously!) and ERC-721.
980     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
981         // DEBUG ONLY
982         //require((InterfaceSignature_ERC165 == 0x01ffc9a7) && (InterfaceSignature_ERC721 == 0x9a20483d));
983 
984         return ((_interfaceID == INTERFACE_SIGNATURE_ERC165) || (_interfaceID == INTERFACE_SIGNATURE_ERC721));
985     }
986 
987     /// @notice Returns a URI pointing to a metadata package for this token conforming to
988     ///  ERC-721 (https://github.com/ethereum/EIPs/issues/721)
989     /// @param _tokenId The ID number of the Artwork whose metadata should be returned.
990     function tokenMetadata(uint256 _tokenId, string _preferredTransport) external view returns (string infoUrl) {
991         require(erc721Metadata != address(0));
992         bytes32[4] memory buffer;
993         uint256 count;
994         (buffer, count) = erc721Metadata.getMetadata(_tokenId, _preferredTransport);
995 
996         return _toString(buffer, count);
997     }
998 
999     /// @notice Returns the address currently assigned ownership of a given Artwork.
1000     /// @dev Required for ERC-721 compliance.
1001     function ownerOf(uint256 _tokenId) external view returns (address owner) {
1002         owner = artworkIndexToOwner[_tokenId];
1003 
1004         require(owner != address(0));
1005     }
1006 
1007     /// @dev Set the address of the sibling contract that tracks metadata.
1008     ///  CEO only.
1009     function setMetadataAddress(address _contractAddress) public onlyCEO {
1010         erc721Metadata = ERC721Metadata(_contractAddress);
1011     }
1012 
1013     /// @notice Returns the total number of Artworks currently in existence.
1014     /// @dev Required for ERC-721 compliance.
1015     function totalSupply() public view returns (uint) {
1016         return artworks.length - 1;
1017     }
1018 
1019     /// @notice Returns the number of Artworks owned by a specific address.
1020     /// @param _owner The owner address to check.
1021     /// @dev Required for ERC-721 compliance
1022     function balanceOf(address _owner) public view returns (uint256 count) {
1023         return ownershipTokenCount[_owner];
1024     }
1025 
1026     // Internal utility functions: These functions all assume that their input arguments
1027     // are valid. We leave it to public methods to sanitize their inputs and follow
1028     // the required logic.
1029     /// @dev Checks if a given address is the current owner of a particular Artwork.
1030     /// @param _claimant the address we are validating against.
1031     /// @param _tokenId artwork id, only valid when > 0
1032     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1033         return artworkIndexToOwner[_tokenId] == _claimant;
1034     }
1035 
1036     /// @dev Checks if a given address currently has transferApproval for a particular Artwork.
1037     /// @param _claimant the address we are confirming artwork is approved for.
1038     /// @param _tokenId artwork id, only valid when > 0
1039     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1040         return artworkIndexToApproved[_tokenId] == _claimant;
1041     }
1042 
1043     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
1044     ///  approval. Setting _approved to address(0) clears all transfer approval.
1045     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
1046     ///  _approve() and transferFrom() are used together for putting Artworks on auction, and
1047     ///  there is no value in spamming the log with Approval events in that case.
1048     function _approve(uint256 _tokenId, address _approved) internal {
1049         artworkIndexToApproved[_tokenId] = _approved;
1050     }
1051 
1052     /// @dev Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
1053     ///  This method is licenced under the Apache License.
1054     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
1055     function _memcpy(uint _dest, uint _src, uint _len) private view {
1056         // Copy word-length chunks while possible
1057         for (; _len >= 32; _len -= 32) {
1058             assembly {
1059                 mstore(_dest, mload(_src))
1060             }
1061             _dest += 32;
1062             _src += 32;
1063         }
1064 
1065         // Copy remaining bytes
1066         uint256 mask = 256 ** (32 - _len) - 1;
1067         assembly {
1068             let srcpart := and(mload(_src), not(mask))
1069             let destpart := and(mload(_dest), mask)
1070             mstore(_dest, or(destpart, srcpart))
1071         }
1072     }
1073 
1074     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
1075     ///  This method is licenced under the Apache License.
1076     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
1077     function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private view returns (string) {
1078         var outputString = new string(_stringLength);
1079         uint256 outputPtr;
1080         uint256 bytesPtr;
1081 
1082         assembly {
1083             outputPtr := add(outputString, 32)
1084             bytesPtr := _rawBytes
1085         }
1086 
1087         _memcpy(outputPtr, bytesPtr, _stringLength);
1088 
1089         return outputString;
1090     }
1091 }
1092 
1093 
1094 /// @title Handles creating auctions for sale  artworks.
1095 ///  This wrapper of ReverseAuction exists only so that users can create
1096 ///  auctions with only one transaction.
1097 contract ArtworkAuction is ArtworkOwnership {
1098 
1099     // @notice The auction contract variables are defined in ArtworkBase to allow
1100     //  us to refer to _createArtworkthem in ArtworkOwnership to prevent accidental transfers.
1101     // `saleAuction` refers to the auction for created artworks and p2p sale of artworks.
1102 
1103 
1104     /// @dev Sets the reference to the sale auction.
1105     /// @param _address - Address of sale contract.
1106     function setSaleAuctionAddress(address _address) external onlyCEO {
1107         SaleClockAuction candidateContract = SaleClockAuction(_address);
1108 
1109         // NOTE: verify that a contract is what we expect -
1110         //https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1111         require(candidateContract.isSaleClockAuction());
1112 
1113         // Set the new contract address
1114         saleAuction = candidateContract;
1115     }
1116 
1117     /// @dev Put a artwork up for auction.
1118     ///  Does some ownership trickery to create auctions in one tx.
1119     function createSaleAuction(
1120         uint256 _artworkId,
1121         uint256 _startingPrice,
1122         uint256 _endingPrice,
1123         uint256 _duration
1124     )
1125         external
1126         whenNotPaused
1127     {
1128         // Auction contract checks input sizes
1129         // If artwork is already on any auction, this will throw
1130         // because it will be owned by the auction contract.
1131         require(_owns(msg.sender, _artworkId));
1132         _approve(_artworkId, saleAuction);
1133         // Sale auction throws if inputs are invalid and clears
1134         // transfer and sire approval after escrowing the artwork.
1135         saleAuction.createAuction(
1136             _artworkId,
1137             _startingPrice,
1138             _endingPrice,
1139             _duration,
1140             msg.sender
1141         );
1142     }
1143 
1144     /// @dev Transfers the balance of the sale auction contract
1145     /// to the ArtworkCore contract. We use two-step withdrawal to
1146     /// prevent two transfer calls in the auction bid function.
1147     function withdrawAuctionBalances() external onlyCLevel {
1148         saleAuction.withdrawBalance();
1149     }
1150 }
1151 
1152 
1153 /// @title all functions related to creating artworks
1154 contract ArtworkMinting is ArtworkAuction {
1155 
1156     // Limits the number of arts the contract owner can ever create.
1157     uint256 public constant PROMO_CREATION_LIMIT = 5000;
1158     uint256 public constant CREATION_LIMIT = 450000;
1159 
1160     // Constants for auctions.
1161     uint256 public constant ARTWORK_STARTING_PRICE = 10 finney;
1162     uint256 public constant ARTWORK_AUCTION_DURATION = 1 days;
1163 
1164     // Counts the number of arts the contract owner has created.
1165     uint256 public promoCreatedCount;
1166     uint256 public artsCreatedCount;
1167 
1168     /// @dev we can create promo artworks, up to a limit. Only callable by COO
1169     /// @param _owner the future owner of the created artworks. Default to contract COO
1170     function createPromoArtwork(string _name, string _author, uint32 _series, address _owner) external onlyCOO {
1171         bytes32 uniqueKey = getUniqueKey(_name, _author, _series);
1172         (require(!uniqueArtworks[uniqueKey]));
1173         if (_series != 0) {
1174             bytes32 uniqueKeyForZero = getUniqueKey(_name, _author, 0);
1175             (require(!uniqueArtworks[uniqueKeyForZero]));
1176         }
1177         address artworkOwner = _owner;
1178         if (artworkOwner == address(0)) {
1179             artworkOwner = cooAddress;
1180         }
1181         require(promoCreatedCount < PROMO_CREATION_LIMIT);
1182 
1183         promoCreatedCount++;
1184         _createArtwork(_name, _author, _series, artworkOwner);
1185         uniqueArtworks[uniqueKey] = true;
1186     }
1187 
1188     /// @dev Creates a new artwork with the given name and author and
1189     ///  creates an auction for it.
1190     function createArtworkAuction(string _name, string _author, uint32 _series) external onlyCOO {
1191         bytes32 uniqueKey = getUniqueKey(_name, _author, _series);
1192         (require(!uniqueArtworks[uniqueKey]));
1193         require(artsCreatedCount < CREATION_LIMIT);
1194         if (_series != 0) {
1195             bytes32 uniqueKeyForZero = getUniqueKey(_name, _author, 0);
1196             (require(!uniqueArtworks[uniqueKeyForZero]));
1197         }
1198         uint256 artworkId = _createArtwork(_name, _author, _series, address(this));
1199         _approve(artworkId, saleAuction);
1200         uint256 price = _computeNextArtworkPrice();
1201         saleAuction.createAuction(
1202             artworkId,
1203             price,
1204             0,
1205             ARTWORK_AUCTION_DURATION,
1206             address(this)
1207         );
1208         artsCreatedCount++;
1209         uniqueArtworks[uniqueKey] = true;
1210     }
1211 
1212     /// @dev Computes the next gen0 auction starting price, given
1213     ///  the average of the past 5 prices + 50%.
1214     function _computeNextArtworkPrice() internal view returns (uint256) {
1215         uint256 avePrice = saleAuction.averageArtworkSalePrice();
1216 
1217         // Sanity check to ensure we don't overflow arithmetic
1218         require(avePrice == uint256(uint128(avePrice)));
1219 
1220         uint256 nextPrice = avePrice + (avePrice / 2);
1221 
1222         // We never auction for less than starting price
1223         if (nextPrice < ARTWORK_STARTING_PRICE) {
1224             nextPrice = ARTWORK_STARTING_PRICE;
1225         }
1226 
1227         return nextPrice;
1228     }
1229 }
1230 
1231 
1232 /**
1233  * The contractName contract does this and that...
1234  */
1235 contract ArtworkQuestions is ArtworkMinting {
1236     string private constant QUESTION  = "What is the value? Nothing is ";
1237     string public constant MAIN_QUESTION = "What is a masterpiece? ";
1238     
1239     function getQuestion() public view returns (string) {
1240         uint256 value = saleAuction.getValue();
1241         string memory auctionValue = _uintToString(value);
1242         return _strConcat(QUESTION, auctionValue, "", "");
1243     }
1244 }
1245 
1246 
1247 /// @title CryptoArtworks: Collectible arts on the Ethereum blockchain.
1248 /// @author Axiom Zen (https://www.axiomzen.co)
1249 /// @dev The main CryptoArtworks contract, keeps track of artworks so they don't wander around and get lost.
1250 contract ArtworkCore is ArtworkQuestions {
1251 
1252     // This is the main CryptoArtworks contract. In order to keep our code seperated into logical sections,
1253     // we've broken it up in two ways. First, we have several seperately-instantiated sibling contracts
1254     // that handle auctions and our super-top-secret genetic combination algorithm. The auctions are
1255     // seperate since their logic is somewhat complex and there's always a risk of subtle bugs. By keeping
1256     // them in their own contracts, we can upgrade them without disrupting the main contract that tracks
1257     // artwork ownership. The genetic combination algorithm is kept seperate so we can open-source all of
1258     // the rest of our code without making it _too_ easy for folks to figure out how the genetics work.
1259     // Don't worry, I'm sure someone will reverse engineer it soon enough!
1260     //
1261     // Secondly, we break the core contract into multiple files using inheritence, one for each major
1262     // facet of functionality of CK. This allows us to keep related code bundled together while still
1263     // avoiding a single giant file with everything in it. The breakdown is as follows:
1264     //
1265     //      - ArtworkBase: This is where we define the most fundamental code shared throughout the core
1266     //             functionality. This includes our main data storage, constants and data types, plus
1267     //             internal functions for managing these items.
1268     //
1269     //      - ArtworkAccessControl: This contract manages the various addresses and constraints for operations
1270     //             that can be executed only by specific roles. Namely CEO, CFO and COO.
1271     //
1272     //      - ArtworkOwnership: This provides the methods required for basic non-fungible token
1273     //             transactions, following the draft ERC-721 spec (https://github.com/ethereum/EIPs/issues/721).
1274     //
1275     //      - ArtworkAuctions: Here we have the public methods for auctioning or bidding on arts.
1276     //             The actual auction functionality is handled in contract
1277     //             for sales, while auction creation and bidding is mostly mediated
1278     //             through this facet of the core contract.
1279     //
1280     //      - ArtworkMinting: This final facet contains the functionality we use for creating new arts.
1281     //             We can make up to 5000 "promo" arts that can be given away (especially important when
1282     //             the community is new), and all others can only be created and then immediately put up
1283     //             for auction via an algorithmically determined starting price. Regardless of how they
1284     //             are created, there is a hard limit of 450k arts.
1285 
1286     // Set in case the core contract is broken and an upgrade is required
1287     address public newContractAddress;
1288 
1289     /// @notice Creates the main CryptoArtworks smart contract instance.
1290     function ArtworkCore() public {
1291         // Starts paused.
1292         paused = true;
1293 
1294         // the creator of the contract is the initial CEO
1295         ceoAddress = msg.sender;
1296 
1297         // the creator of the contract is also the initial COO
1298         cooAddress = msg.sender;
1299 
1300         // start with the art
1301         _createArtwork("none", "none", 0, address(0));
1302     }
1303 
1304     /// @notice No tipping!
1305     /// @dev Reject all Ether from being sent here, unless it's from one of the
1306     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
1307     function() external payable {
1308         require(
1309             msg.sender == address(saleAuction)
1310         );
1311     }
1312 
1313     /// @dev Used to mark the smart contract as upgraded, in case there is a serious
1314     ///  breaking bug. This method does nothing but keep track of the new contract and
1315     ///  emit a message indicating that the new address is set. It's up to clients of this
1316     ///  contract to update to the new contract address in that case. (This contract will
1317     ///  be paused indefinitely if such an upgrade takes place.)
1318     /// @param _v2Address new address
1319     function setNewAddress(address _v2Address) external onlyCEO whenPaused {
1320         // See README.md for updgrade plan
1321         newContractAddress = _v2Address;
1322         ContractUpgrade(_v2Address);
1323     }
1324 
1325     // @dev Allows the CFO to capture the balance available to the contract.
1326     function withdrawBalance() external onlyCFO {
1327         uint256 balance = this.balance;
1328         cfoAddress.send(balance);
1329     }
1330 
1331     /// @notice Returns all the relevant information about a specific artwork.
1332     /// @param _id The ID of the artwork of interest.
1333     function getArtwork(uint256 _id)
1334         external
1335         view
1336         returns (
1337         uint256 birthTime,
1338         string name,
1339         string author,
1340         uint32 series
1341     ) {
1342         Artwork storage art = artworks[_id];
1343         birthTime = uint256(art.birthTime);
1344         name = string(art.name);
1345         author = string(art.author);
1346         series = uint32(art.series);
1347     }
1348 
1349     /// @dev Override unpause so it requires all external contract addresses
1350     ///  to be set before contract can be unpaused. Also, we can't have
1351     ///  newContractAddress set either, because then the contract was upgraded.
1352     /// @notice This is public rather than external so we can call super.unpause
1353     ///  without using an expensive CALL.
1354     function unpause() public onlyCEO whenPaused {
1355         require(saleAuction != address(0));
1356         require(newContractAddress == address(0));
1357         // Actually unpause the contract.
1358         super.unpause();
1359     }
1360 
1361 }