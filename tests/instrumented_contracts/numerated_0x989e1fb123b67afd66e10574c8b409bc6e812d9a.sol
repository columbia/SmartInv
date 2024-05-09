1 // File: contracts/Ownable.sol
2 
3 pragma solidity ^0.5.10;
4 
5 contract Ownable {
6     address public owner;
7 
8 
9     /**
10      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
11      * account.
12      */
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17 
18     /**
19      * @dev Throws if called by any account other than the owner.
20      */
21     modifier onlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26 
27     /**
28      * @dev Allows the current owner to transfer control of the contract to a newOwner.
29      * @param newOwner The address to transfer ownership to.
30      */
31     function transferOwnership(address newOwner) public onlyOwner {
32         if (newOwner != address(0)) {
33             owner = newOwner;
34         }
35     }
36 
37 }
38 
39 // File: contracts/Pausable.sol
40 
41 pragma solidity ^0.5.10;
42 
43 
44 contract Pausable is Ownable {
45     event Pause();
46     event Unpause();
47 
48     bool public paused = false;
49 
50 
51     /**
52      * @dev modifier to allow actions only when the contract IS paused
53      */
54     modifier whenNotPaused() {
55         require(!paused);
56         _;
57     }
58 
59     /**
60      * @dev modifier to allow actions only when the contract IS NOT paused
61      */
62     modifier whenPaused {
63         require(paused);
64         _;
65     }
66 
67     /**
68      * @dev called by the owner to pause, triggers stopped state
69      */
70     function pause() public onlyOwner whenNotPaused returns (bool) {
71         paused = true;
72         emit Pause();
73         return true;
74     }
75 
76     /**
77      * @dev called by the owner to unpause, returns to normal state
78      */
79     function unpause() public onlyOwner whenPaused returns (bool) {
80         paused = false;
81         emit Unpause();
82         return true;
83     }
84 }
85 
86 // File: contracts/DragonAccessControl.sol
87 
88 pragma solidity ^0.5.10;
89 
90 
91 
92 contract DragonAccessControl {
93     /// @dev Emited when contract is upgraded - See README.md for updgrade plan
94     event ContractUpgrade(address newContract);
95 
96     // The addresses of the accounts (or contracts) that can execute actions within each roles.
97     address payable public ceoAddress;
98     address payable public cioAddress;
99     address payable public cmoAddress;
100     address payable public cooAddress;
101     address payable public cfoAddress;
102 
103     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
104     bool public paused = false;
105 
106     /// @dev Access modifier for CEO-only functionality
107     modifier onlyCEO() {
108         require(msg.sender == ceoAddress);
109         _;
110     }
111 
112     /// @dev Access modifier for CIO-only functionality
113     modifier onlyCIO() {
114         require(msg.sender == cioAddress);
115         _;
116     }
117 
118     /// @dev Access modifier for CMO-only functionality
119     modifier onlyCMO() {
120         require(msg.sender == cmoAddress);
121         _;
122     }
123 
124     /// @dev Access modifier for COO-only functionality
125     modifier onlyCOO() {
126         require(msg.sender == cooAddress);
127         _;
128     }
129 
130     /// @dev Access modifier for CFO-only functionality
131     modifier onlyCFO() {
132         require(msg.sender == cfoAddress);
133         _;
134     }
135 
136     modifier onlyCLevel() {
137         require(
138             msg.sender == ceoAddress ||
139             msg.sender == cioAddress ||
140             msg.sender == cmoAddress ||
141             msg.sender == cooAddress ||
142             msg.sender == cfoAddress
143         );
144         _;
145     }
146 
147     /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
148     /// @param _newCEO The address of the new CEO
149     function setCEO(address payable _newCEO) external onlyCEO {
150         require(_newCEO != address(0));
151 
152         ceoAddress = _newCEO;
153     }
154 
155     /// @dev Assigns a new address to act as the CIO. Only available to the current CEO.
156     /// @param _newCIO The address of the new CIO
157     function setCIO(address payable _newCIO) external onlyCEO {
158         require(_newCIO != address(0));
159 
160         cioAddress = _newCIO;
161     }
162 
163     /// @dev Assigns a new address to act as the CMO. Only available to the current CEO.
164     /// @param _newCMO The address of the new CMO
165     function setCMO(address payable _newCMO) external onlyCEO {
166         require(_newCMO != address(0));
167 
168         cmoAddress = _newCMO;
169     }
170 
171     /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
172     /// @param _newCOO The address of the new COO
173     function setCOO(address payable _newCOO) external onlyCEO {
174         require(_newCOO != address(0));
175 
176         cooAddress = _newCOO;
177     }
178 
179     /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
180     /// @param _newCFO The address of the new CFO
181     function setCFO(address payable _newCFO) external onlyCEO {
182         require(_newCFO != address(0));
183 
184         cfoAddress = _newCFO;
185     }
186 
187     /// @dev Modifier to allow actions only when the contract IS NOT paused
188     modifier whenNotPaused() {
189         require(!paused);
190         _;
191     }
192 
193     /// @dev Modifier to allow actions only when the contract IS paused
194     modifier whenPaused {
195         require(paused);
196         _;
197     }
198 
199     /// @dev Called by any "C-level" role to pause the contract. Used only when
200     ///  a bug or exploit is detected and we need to limit damage.
201     function pause() external onlyCLevel whenNotPaused {
202         paused = true;
203     }
204 
205     /// @dev Unpauses the smart contract. Can only be called by the CEO, since
206     ///  one reason we may pause the contract is when CIO or CMO accounts are
207     ///  compromised.
208     /// @notice This is public rather than external so it can be called by
209     ///  derived contracts.
210     function unpause() public onlyCEO whenPaused {
211         // can't unpause if contract was upgraded
212         paused = false;
213     }
214 }
215 
216 // File: contracts/DragonERC721.sol
217 
218 pragma solidity ^0.5.10;
219 
220 
221 /// @title ERC-721 Non-Fungible Token Standard
222 /// @dev See https://eips.ethereum.org/EIPS/eip-721
223 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
224 interface ERC721 /* is ERC165 */ {
225     /// @dev This emits when ownership of any NFT changes by any mechanism.
226     ///  This event emits when NFTs are created (`from` == 0) and destroyed
227     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
228     ///  may be created and assigned without emitting Transfer. At the time of
229     ///  any transfer, the approved address for that NFT (if any) is reset to none.
230     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
231 
232     /// @dev This emits when the approved address for an NFT is changed or
233     ///  reaffirmed. The zero address indicates there is no approved address.
234     ///  When a Transfer event emits, this also indicates that the approved
235     ///  address for that NFT (if any) is reset to none.
236     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
237 
238     /// @dev This emits when an operator is enabled or disabled for an owner.
239     ///  The operator can manage all NFTs of the owner.
240     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
241 
242     /// @notice Count all NFTs assigned to an owner
243     /// @dev NFTs assigned to the zero address are considered invalid, and this
244     ///  function throws for queries about the zero address.
245     /// @param _owner An address for whom to query the balance
246     /// @return The number of NFTs owned by `_owner`, possibly zero
247     function balanceOf(address _owner) external view returns (uint256);
248 
249     /// @notice Find the owner of an NFT
250     /// @dev NFTs assigned to zero address are considered invalid, and queries
251     ///  about them do throw.
252     /// @param _tokenId The identifier for an NFT
253     /// @return The address of the owner of the NFT
254     function ownerOf(uint256 _tokenId) external view returns (address);
255 
256     /// @notice Transfers the ownership of an NFT from one address to another address
257     /// @dev Throws unless `msg.sender` is the current owner, an authorized
258     ///  operator, or the approved address for this NFT. Throws if `_from` is
259     ///  not the current owner. Throws if `_to` is the zero address. Throws if
260     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
261     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
262     ///  `onERC721Received` on `_to` and throws if the return value is not
263     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
264     /// @param _from The current owner of the NFT
265     /// @param _to The new owner
266     /// @param _tokenId The NFT to transfer
267     /// @param data Additional data with no specified format, sent in call to `_to`
268     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
269 
270     /// @notice Transfers the ownership of an NFT from one address to another address
271     /// @dev This works identically to the other function with an extra data parameter,
272     ///  except this function just sets data to "".
273     /// @param _from The current owner of the NFT
274     /// @param _to The new owner
275     /// @param _tokenId The NFT to transfer
276     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
277 
278     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
279     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
280     ///  THEY MAY BE PERMANENTLY LOST
281     /// @dev Throws unless `msg.sender` is the current owner, an authorized
282     ///  operator, or the approved address for this NFT. Throws if `_from` is
283     ///  not the current owner. Throws if `_to` is the zero address. Throws if
284     ///  `_tokenId` is not a valid NFT.
285     /// @param _from The current owner of the NFT
286     /// @param _to The new owner
287     /// @param _tokenId The NFT to transfer
288     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
289 
290     /// @notice Change or reaffirm the approved address for an NFT
291     /// @dev The zero address indicates there is no approved address.
292     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
293     ///  operator of the current owner.
294     /// @param _approved The new approved NFT controller
295     /// @param _tokenId The NFT to approve
296     function approve(address _approved, uint256 _tokenId) external payable;
297 
298     /// @notice Enable or disable approval for a third party ("operator") to manage
299     ///  all of `msg.sender`'s assets
300     /// @dev Emits the ApprovalForAll event. The contract MUST allow
301     ///  multiple operators per owner.
302     /// @param _operator Address to add to the set of authorized operators
303     /// @param _approved True if the operator is approved, false to revoke approval
304     function setApprovalForAll(address _operator, bool _approved) external;
305 
306     /// @notice Get the approved address for a single NFT
307     /// @dev Throws if `_tokenId` is not a valid NFT.
308     /// @param _tokenId The NFT to find the approved address for
309     /// @return The approved address for this NFT, or the zero address if there is none
310     function getApproved(uint256 _tokenId) external view returns (address);
311 
312     /// @notice Query if an address is an authorized operator for another address
313     /// @param _owner The address that owns the NFTs
314     /// @param _operator The address that acts on behalf of the owner
315     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
316     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
317 }
318 
319 interface ERC165 {
320     /// @notice Query if a contract implements an interface
321     /// @param interfaceID The interface identifier, as specified in ERC-165
322     /// @dev Interface identification is specified in ERC-165. This function
323     ///  uses less than 30,000 gas.
324     /// @return `true` if the contract implements `interfaceID` and
325     ///  `interfaceID` is not 0xffffffff, `false` otherwise
326     function supportsInterface(bytes4 interfaceID) external view returns (bool);
327 }
328 
329 interface ERC721TokenReceiver {
330     /// @notice Handle the receipt of an NFT
331     /// @dev The ERC721 smart contract calls this function on the recipient
332     ///  after a `transfer`. This function MAY throw to revert and reject the
333     ///  transfer. Return of other than the magic value MUST result in the
334     ///  transaction being reverted.
335     ///  Note: the contract address is always the message sender.
336     /// @param _operator The address which called `safeTransferFrom` function
337     /// @param _from The address which previously owned the token
338     /// @param _tokenId The NFT identifier which is being transferred
339     /// @param _data Additional data with no specified format
340     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
341     ///  unless throwing
342     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
343 }
344 
345 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
346 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
347 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
348 interface ERC721Metadata /* is IERC721Base */ {
349   /// @notice A descriptive name for a collection of NFTs in this contract
350   function name() external pure returns (string memory _name);
351 
352   /// @notice An abbreviated name for NFTs in this contract
353   function symbol() external pure returns (string memory _symbol);
354 
355   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
356   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
357   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
358   ///  Metadata JSON Schema".
359   function tokenURI(uint256 _tokenId) external view returns (string memory);
360 }
361 
362 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
363 /// @dev See https://eips.ethereum.org/EIPS/eip-721
364 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
365 interface ERC721Enumerable /* is ERC721 */ {
366     /// @notice Count NFTs tracked by this contract
367     /// @return A count of valid NFTs tracked by this contract, where each one of
368     ///  them has an assigned and queryable owner not equal to the zero address
369     function totalSupply() external view returns (uint256);
370 
371     /// @notice Enumerate valid NFTs
372     /// @dev Throws if `_index` >= `totalSupply()`.
373     /// @param _index A counter less than `totalSupply()`
374     /// @return The token identifier for the `_index`th NFT,
375     ///  (sort order not specified)
376     function tokenByIndex(uint256 _index) external view returns (uint256);
377 
378     /// @notice Enumerate NFTs assigned to an owner
379     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
380     ///  `_owner` is the zero address, representing invalid NFTs.
381     /// @param _owner An address where we are interested in NFTs owned by them
382     /// @param _index A counter less than `balanceOf(_owner)`
383     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
384     ///   (sort order not specified)
385     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
386 }
387 
388 //contract DragonERC721 is IERC721, ERC721Metadata, ERC721TokenReceiver, ERC721Enumerable {
389 contract DragonERC721 is ERC165, ERC721, ERC721Metadata, ERC721TokenReceiver, ERC721Enumerable {
390 
391     mapping (bytes4 => bool) internal supportedInterfaces;
392 
393     string public tokenURIPrefix = "https://www.drakons.io/server/api/dragon/metadata/";
394     string public tokenURISuffix = "";
395 
396     function name() external pure returns (string memory) {
397       return "Drakons";
398     }
399 
400     function symbol() external pure returns (string memory) {
401       return "DRKNS";
402     }
403 
404     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
405         return supportedInterfaces[interfaceID];
406     }
407 
408     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4){
409         return bytes4(keccak256("onERC721Received(address,uint256,bytes)"));
410     }
411 
412 }
413 
414 // File: contracts/ClockAuctionBase.sol
415 
416 pragma solidity ^0.5.10;
417 
418 
419 contract ClockAuctionBase {
420 
421     // Represents an auction on an NFT
422     struct Auction {
423         // Current owner of NFT
424         address payable seller;
425         // Price (in wei) at beginning of auction
426         uint128 startingPrice;
427         // Price (in wei) at end of auction
428         uint128 endingPrice;
429         // Duration (in seconds) of auction
430         uint64 duration;
431         // Time when auction started
432         // NOTE: 0 if this auction has been concluded
433         uint64 startedAt;
434     }
435 
436     // Reference to contract tracking NFT ownership
437     DragonERC721 public nonFungibleContract;
438 
439     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
440     // Values 0-10,000 map to 0%-100%
441     uint256 public ownerCut;
442 
443     address payable public ceoAddress;
444     address payable public cfoAddress;
445 
446     modifier onlyCEOCFO() {
447         require(
448             msg.sender == ceoAddress ||
449             msg.sender == cfoAddress
450         );
451         _;
452     }
453 
454     modifier onlyCEO() {
455         require(msg.sender == ceoAddress);
456         _;
457     }
458 
459     // Map from token ID to their corresponding auction.
460     mapping (uint256 => Auction) tokenIdToAuction;
461 
462     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
463     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address buyer, address seller);
464     event AuctionCancelled(uint256 tokenId);
465 
466 
467     function setCEO(address payable _newCEO) external onlyCEO {
468         require(_newCEO != address(0));
469 
470         ceoAddress = _newCEO;
471     }
472 
473     function setCFO(address payable _newCFO) external onlyCEO {
474         require(_newCFO != address(0));
475 
476         cfoAddress = _newCFO;
477     }
478 
479     /// @dev Returns true if the claimant owns the token.
480     /// @param _claimant - Address claiming to own the token.
481     /// @param _tokenId - ID of token whose ownership to verify.
482     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
483         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
484     }
485 
486     /// @dev Escrows the NFT, assigning ownership to this contract.
487     /// Throws if the escrow fails.
488     /// @param _owner - Current owner address of token to escrow.
489     /// @param _tokenId - ID of token whose approval to verify.
490     function _escrow(address _owner, uint256 _tokenId) internal {
491         // it will throw if transfer fails
492         nonFungibleContract.transferFrom(_owner, address(this), _tokenId);
493     }
494 
495     /// @dev Transfers an NFT owned by this contract to another address.
496     /// Returns true if the transfer succeeds.
497     /// @param _receiver - Address to transfer NFT to.
498     /// @param _tokenId - ID of token to transfer.
499     function _transfer(address _receiver, uint256 _tokenId) internal {
500         // it will throw if transfer fails
501         //nonFungibleContract.transfer(_receiver, _tokenId);
502         nonFungibleContract.transferFrom(address(this), _receiver, _tokenId);
503     }
504 
505     /// @dev Adds an auction to the list of open auctions. Also fires the
506     ///  AuctionCreated event.
507     /// @param _tokenId The ID of the token to be put on auction.
508     /// @param _auction Auction to add.
509     function _addAuction(uint256 _tokenId, Auction memory _auction) internal {
510         // Require that all auctions have a duration of
511         // at least one minute. (Keeps our math from getting hairy!)
512         require(_auction.duration >= 1 minutes);
513 
514         tokenIdToAuction[_tokenId] = _auction;
515 
516         //cpt added emit
517         emit AuctionCreated(
518             uint256(_tokenId),
519             uint256(_auction.startingPrice),
520             uint256(_auction.endingPrice),
521             uint256(_auction.duration)
522         );
523     }
524 
525     /// @dev Cancels an auction unconditionally.
526     function _cancelAuction(uint256 _tokenId, address _seller) internal {
527         _removeAuction(_tokenId);
528         _transfer(_seller, _tokenId);
529         emit AuctionCancelled(_tokenId);
530     }
531 
532     /// @dev Computes the price and transfers winnings.
533     /// Does NOT transfer ownership of token.
534     function _bid(uint256 _tokenId, uint256 _bidAmount)
535     internal
536     returns (uint256)
537     {
538         // Get a reference to the auction struct
539         Auction storage auction = tokenIdToAuction[_tokenId];
540 
541         // Explicitly check that this auction is currently live.
542         // (Because of how Ethereum mappings work, we can't just count
543         // on the lookup above failing. An invalid _tokenId will just
544         // return an auction object that is all zeros.)
545         require(_isOnAuction(auction));
546 
547         // Check that the bid is greater than or equal to the current price
548         uint256 price = _currentPrice(auction);
549         require(_bidAmount >= price);
550 
551         // Grab a reference to the seller before the auction struct
552         // gets deleted.
553         address payable seller = auction.seller;
554 
555         // The bid is good! Remove the auction before sending the fees
556         // to the sender so we can't have a reentrancy attack.
557         _removeAuction(_tokenId);
558 
559         // Transfer proceeds to seller (if there are any!)
560         if (price > 0) {
561             // Calculate the auctioneer's cut.
562             // (NOTE: _computeCut() is guaranteed to return a
563             // value <= price, so this subtraction can't go negative.)
564             uint256 auctioneerCut = _computeCut(price);
565             uint256 sellerProceeds = price - auctioneerCut;
566 
567             // NOTE: Doing a transfer() in the middle of a complex
568             // method like this is generally discouraged because of
569             // reentrancy attacks and DoS attacks if the seller is
570             // a contract with an invalid fallback function. We explicitly
571             // guard against reentrancy attacks by removing the auction
572             // before calling transfer(), and the only thing the seller
573             // can DoS is the sale of their own asset! (And if it's an
574             // accident, they can call cancelAuction(). )
575             seller.transfer(sellerProceeds);
576         }
577 
578         // Calculate any excess funds included with the bid. If the excess
579         // is anything worth worrying about, transfer it back to bidder.
580         // NOTE: We checked above that the bid amount is greater than or
581         // equal to the price so this cannot underflow.
582         uint256 bidExcess = _bidAmount - price;
583 
584         // Return the funds. Similar to the previous transfer, this is
585         // not susceptible to a re-entry attack because the auction is
586         // removed before any transfers occur.
587         msg.sender.transfer(bidExcess);
588 
589         // Tell the world!
590         emit AuctionSuccessful(_tokenId, price, msg.sender, seller);
591 
592         return price;
593     }
594 
595     /// @dev Removes an auction from the list of open auctions.
596     /// @param _tokenId - ID of NFT on auction.
597     function _removeAuction(uint256 _tokenId) internal {
598         delete tokenIdToAuction[_tokenId];
599     }
600 
601     /// @dev Returns true if the NFT is on auction.
602     /// @param _auction - Auction to check.
603     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
604         return (_auction.startedAt > 0);
605     }
606 
607     /// @dev Returns current price of an NFT on auction. Broken into two
608     ///  functions (this one, that computes the duration from the auction
609     ///  structure, and the other that does the price computation) so we
610     ///  can easily test that the price computation works correctly.
611     function _currentPrice(Auction storage _auction)
612     internal
613     view
614     returns (uint256)
615     {
616         uint256 secondsPassed = 0;
617 
618         // A bit of insurance against negative values (or wraparound).
619         // Probably not necessary (since Ethereum guarnatees that the
620         // now variable doesn't ever go backwards).
621         if (now > _auction.startedAt) {
622             secondsPassed = now - _auction.startedAt;
623         }
624 
625         return _computeCurrentPrice(
626             _auction.startingPrice,
627             _auction.endingPrice,
628             _auction.duration,
629             secondsPassed
630         );
631     }
632 
633     /// @dev Computes the current price of an auction. Factored out
634     ///  from _currentPrice so we can run extensive unit tests.
635     ///  When testing, make this function public and turn on
636     ///  `Current price computation` test suite.
637     function _computeCurrentPrice(
638         uint256 _startingPrice,
639         uint256 _endingPrice,
640         uint256 _duration,
641         uint256 _secondsPassed
642     )
643     internal
644     pure
645     returns (uint256)
646     {
647         // NOTE: We don't use SafeMath (or similar) in this function because
648         //  all of our public functions carefully cap the maximum values for
649         //  time (at 64-bits) and currency (at 128-bits). _duration is
650         //  also known to be non-zero (see the require() statement in
651         //  _addAuction())
652         if (_secondsPassed >= _duration) {
653             // We've reached the end of the dynamic pricing portion
654             // of the auction, just return the end price.
655             return _endingPrice;
656         } else {
657             // Starting price can be higher than ending price (and often is!), so
658             // this delta can be negative.
659             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
660 
661             // This multiplication can't overflow, _secondsPassed will easily fit within
662             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
663             // will always fit within 256-bits.
664             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
665 
666             // currentPriceChange can be negative, but if so, will have a magnitude
667             // less that _startingPrice. Thus, this result will always end up positive.
668             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
669 
670             return uint256(currentPrice);
671         }
672     }
673 
674     /// @dev Computes owner's cut of a sale.
675     /// @param _price - Sale price of NFT.
676     function _computeCut(uint256 _price) internal view returns (uint256) {
677         // NOTE: We don't use SafeMath (or similar) in this function because
678         //  all of our entry functions carefully cap the maximum values for
679         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
680         //  statement in the ClockAuction constructor). The result of this
681         //  function is always guaranteed to be <= _price.
682         return _price * ownerCut / 10000;
683     }
684 }
685 
686 // File: contracts/ClockAuction.sol
687 
688 pragma solidity ^0.5.10;
689 
690 
691 
692 contract ClockAuction is Pausable, ClockAuctionBase {
693 
694     /// @dev The ERC-165 interface signature for ERC-721.
695     ///  Ref: https://github.com/ethereum/EIPs/issues/165
696     ///  Ref: https://github.com/ethereum/EIPs/issues/721
697     //bytes4 constant InterfaceSignature_ERC721 = bytes4(0x5b5e139f);
698     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x80ac58cd);
699 
700     /// @dev Constructor creates a reference to the NFT ownership contract
701     ///  and verifies the owner cut is in the valid range.
702     /// @param _nftAddress - address of a deployed contract implementing
703     ///  the Nonfungible Interface.
704     /// @param _cut - percent cut the owner takes on each auction, must be
705     ///  between 0-10,000.
706     constructor (address _nftAddress, uint256 _cut) public {
707         require(_cut <= 10000);
708         ownerCut = _cut;
709 
710         ceoAddress = msg.sender;
711         cfoAddress = msg.sender;
712 
713         DragonERC721 candidateContract = DragonERC721(_nftAddress);
714         //require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
715         nonFungibleContract = candidateContract;
716     }
717 
718 
719     /// @dev Remove all Ether from the contract, which is the owner's cuts
720     ///  as well as any Ether sent directly to the contract address.
721     ///  Always transfers to the NFT contract, but can be called either by
722     ///  the owner or the NFT contract.
723     function withdrawBalance() external {
724         address payable nftAddress = address(uint160(address(nonFungibleContract)));
725 
726         require(
727             msg.sender == owner ||
728             msg.sender == nftAddress
729         );
730         // We are using this boolean method to make sure that even if one fails it will still work
731         //bool res = nftAddress.send(address(this).balance);
732         nftAddress.transfer(address(this).balance);
733     }
734 
735     /// @dev Creates and begins a new auction.
736     /// @param _tokenId - ID of token to auction, sender must be owner.
737     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
738     /// @param _endingPrice - Price of item (in wei) at end of auction.
739     /// @param _duration - Length of time to move between starting
740     ///  price and ending price (in seconds).
741     /// @param _seller - Seller, if not the message sender
742     function createAuction(
743         uint256 _tokenId,
744         uint256 _startingPrice,
745         uint256 _endingPrice,
746         uint256 _duration,
747         address payable _seller
748     )
749     external
750     whenNotPaused
751     {
752         // Sanity check that no inputs overflow how many bits we've allocated
753         // to store them in the auction struct.
754         require(_startingPrice == uint256(uint128(_startingPrice)));
755         require(_endingPrice == uint256(uint128(_endingPrice)));
756         require(_duration == uint256(uint64(_duration)));
757 
758         require(_owns(msg.sender, _tokenId));
759         _escrow(msg.sender, _tokenId);
760         Auction memory auction = Auction(
761             _seller,
762             uint128(_startingPrice),
763             uint128(_endingPrice),
764             uint64(_duration),
765             uint64(now)
766         );
767         _addAuction(_tokenId, auction);
768     }
769 
770     /// @dev Bids on an open auction, completing the auction and transferring
771     ///  ownership of the NFT if enough Ether is supplied.
772     /// @param _tokenId - ID of token to bid on.
773     function bid(uint256 _tokenId)
774     external
775     payable
776     whenNotPaused
777     {
778         // _bid will throw if the bid or funds transfer fails
779         _bid(_tokenId, msg.value);
780         _transfer(msg.sender, _tokenId);
781     }
782 
783     /// @dev Cancels an auction that hasn't been won yet.
784     ///  Returns the NFT to original owner.
785     /// @notice This is a state-modifying function that can
786     ///  be called while the contract is paused.
787     /// @param _tokenId - ID of token on auction
788     function cancelAuction(uint256 _tokenId)
789     external
790     {
791         Auction storage auction = tokenIdToAuction[_tokenId];
792         require(_isOnAuction(auction));
793         address seller = auction.seller;
794         require(msg.sender == seller || msg.sender == address(nonFungibleContract));
795         _cancelAuction(_tokenId, seller);
796     }
797 
798     /// @dev Cancels an auction when the contract is paused.
799     ///  Only the owner may do this, and NFTs are returned to
800     ///  the seller. This should only be used in emergencies.
801     /// @param _tokenId - ID of the NFT on auction to cancel.
802     function cancelAuctionWhenPaused(uint256 _tokenId)
803     whenPaused
804     onlyOwner
805     external
806     {
807         Auction storage auction = tokenIdToAuction[_tokenId];
808         require(_isOnAuction(auction));
809         _cancelAuction(_tokenId, auction.seller);
810     }
811 
812     /// @dev Returns auction info for an NFT on auction.
813     /// @param _tokenId - ID of NFT on auction.
814     function getAuction(uint256 _tokenId)
815     external
816     view
817     returns
818     (
819         address payable seller,
820         uint256 startingPrice,
821         uint256 endingPrice,
822         uint256 duration,
823         uint256 startedAt
824     ) {
825         Auction storage auction = tokenIdToAuction[_tokenId];
826         require(_isOnAuction(auction));
827         return (
828         auction.seller,
829         auction.startingPrice,
830         auction.endingPrice,
831         auction.duration,
832         auction.startedAt
833         );
834     }
835 
836     /// @dev Returns the current price of an auction.
837     /// @param _tokenId - ID of the token price we are checking.
838     function getCurrentPrice(uint256 _tokenId)
839     external
840     view
841     returns (uint256)
842     {
843         Auction storage auction = tokenIdToAuction[_tokenId];
844         require(_isOnAuction(auction));
845         return _currentPrice(auction);
846     }
847 }
848 
849 // File: contracts/SaleClockAuction.sol
850 
851 pragma solidity ^0.5.10;
852 
853 
854 contract SaleClockAuction is ClockAuction {
855 
856     // @dev Sanity check that allows us to ensure that we are pointing to the
857     //  right auction in our setSaleAuctionAddress() call.
858     bool public isSaleClockAuction = true;
859 
860     // Delegate constructor
861     constructor(address _nftAddr, uint256 _cut) public
862     ClockAuction(_nftAddr, _cut) {}
863 
864     /// @dev Creates and begins a new auction.
865     /// @param _tokenId - ID of token to auction, sender must be owner.
866     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
867     /// @param _endingPrice - Price of item (in wei) at end of auction.
868     /// @param _duration - Length of auction (in seconds).
869     /// @param _seller - Seller, if not the message sender
870     function createAuction(
871         uint256 _tokenId,
872         uint256 _startingPrice,
873         uint256 _endingPrice,
874         uint256 _duration,
875         address payable _seller
876     )
877     external
878     {
879         // Sanity check that no inputs overflow how many bits we've allocated
880         // to store them in the auction struct.
881         require(_startingPrice == uint256(uint128(_startingPrice)));
882         require(_endingPrice == uint256(uint128(_endingPrice)));
883         require(_duration == uint256(uint64(_duration)));
884 
885         require(msg.sender == address(nonFungibleContract));
886         _escrow(_seller, _tokenId);
887 
888         Auction memory auction = Auction(
889             _seller,
890             uint128(_startingPrice),
891             uint128(_endingPrice),
892             uint64(_duration),
893             uint64(now)
894         );
895         _addAuction(_tokenId, auction);
896     }
897 
898     /// @dev Updates lastSalePrice if seller is the nft contract
899     /// Otherwise, works the same as default bid method.
900     function bid(uint256 _tokenId)
901     external
902     payable
903     {
904         // _bid verifies token ID size
905         _bid(_tokenId, msg.value);
906         _transfer(msg.sender, _tokenId);
907     }
908 
909     function setOwnerCut(uint256 val) external onlyCEOCFO {
910         ownerCut = val;
911     }
912 }
913 
914 // File: contracts/SiringClockAuction.sol
915 
916 pragma solidity ^0.5.10;
917 
918 
919 contract SiringClockAuction is ClockAuction {
920 
921     // @dev Sanity check that allows us to ensure that we are pointing to the
922     //  right auction in our setSiringAuctionAddress() call.
923     bool public isSiringClockAuction = true;
924 
925     // Delegate constructor
926     constructor(address _nftAddr, uint256 _cut) public
927     ClockAuction(_nftAddr, _cut) {}
928 
929     /// @dev Creates and begins a new auction. Since this function is wrapped,
930     /// require sender to be DragonCore contract.
931     /// @param _tokenId - ID of token to auction, sender must be owner.
932     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
933     /// @param _endingPrice - Price of item (in wei) at end of auction.
934     /// @param _duration - Length of auction (in seconds).
935     /// @param _seller - Seller, if not the message sender
936     function createAuction(
937         uint256 _tokenId,
938         uint256 _startingPrice,
939         uint256 _endingPrice,
940         uint256 _duration,
941         address payable _seller
942     )
943     external
944     {
945         // Sanity check that no inputs overflow how many bits we've allocated
946         // to store them in the auction struct.
947         require(_startingPrice == uint256(uint128(_startingPrice)));
948         require(_endingPrice == uint256(uint128(_endingPrice)));
949         require(_duration == uint256(uint64(_duration)));
950 
951         require(msg.sender == address(nonFungibleContract));
952         _escrow(_seller, _tokenId);
953         Auction memory auction = Auction(
954             _seller,
955             uint128(_startingPrice),
956             uint128(_endingPrice),
957             uint64(_duration),
958             uint64(now)
959         );
960         _addAuction(_tokenId, auction);
961     }
962 
963     /// @dev Places a bid for siring. Requires the sender
964     /// is the DragonCore contract because all bid methods
965     /// should be wrapped. Also returns the Dragon to the
966     /// seller rather than the winner.
967     function bid(uint256 _tokenId)
968     external
969     payable
970     {
971         require(msg.sender == address(nonFungibleContract));
972         address seller = tokenIdToAuction[_tokenId].seller;
973         // _bid checks that token ID is valid and will throw if bid fails
974         _bid(_tokenId, msg.value);
975         // We transfer the dragon back to the seller, the winner will get
976         // the offspring
977         _transfer(seller, _tokenId);
978     }
979 
980     function setOwnerCut(uint256 val) external onlyCEOCFO {
981         ownerCut = val;
982     }
983 
984 }
985 
986 // File: contracts/DragonBase.sol
987 
988 pragma solidity ^0.5.10;
989 
990 
991 
992 
993 
994 contract DragonBase is DragonAccessControl, DragonERC721 {
995 
996     event Birth(address owner, uint256 dragonId, uint256 matronId, uint256 sireId, uint256 dna, uint32 generation, uint64 runeLevel);
997     event DragonAssetsUpdated(uint256 _dragonId, uint64 _rune, uint64 _agility, uint64 _strength, uint64 _intelligence);
998     event DragonAssetRequest(uint256 _dragonId);
999     //event Transfer(address from, address to, uint256 tokenId, uint32 generation);
1000 
1001     struct Dragon {
1002         // The Dragon's genetic code is packed into these 256-bits.
1003         uint256 dna;
1004         uint64 birthTime;
1005         uint64 breedTime;
1006         uint32 matronId;
1007         uint32 sireId;
1008         uint32 siringWithId;
1009         uint32 generation;
1010     }
1011 
1012     struct DragonAssets {
1013         uint64 runeLevel;
1014         uint64 agility;
1015         uint64 strength;
1016         uint64 intelligence;
1017     }
1018 
1019     Dragon[] dragons;
1020     mapping (uint256 => address) public dragonIndexToOwner;
1021     mapping (address => uint256) ownershipTokenCount;
1022     mapping (uint256 => address) public dragonIndexToApproved;
1023     mapping (uint256 => address) public sireAllowedToAddress;
1024     mapping (uint256 => DragonAssets) public dragonAssets;
1025 
1026     mapping (address => mapping (address => bool)) internal authorised;
1027 
1028     uint256 public updateAssetFee = 8 finney;
1029 
1030     SaleClockAuction public saleAuction;
1031     SiringClockAuction public siringAuction;
1032 
1033     modifier isValidToken(uint256 _tokenId) {
1034         require(dragonIndexToOwner[_tokenId] != address(0));
1035         _;
1036     }
1037 
1038     /// @dev Assigns ownership of a specific Dragon to an address.
1039     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1040         // Since the number of dragons is capped to 2^32 we can't overflow this
1041         // Declaration: mapping (address => uint256) ownershipTokenCount;
1042         ownershipTokenCount[_to]++;
1043         // transfer ownership
1044         // Declaration: mapping (uint256 => address) public dragonIndexToOwner;
1045         dragonIndexToOwner[_tokenId] = _to;
1046         // When creating new dragons _from is 0x0, but we can't account that address.
1047         if (_from != address(0)) {
1048             ownershipTokenCount[_from]--;
1049             // once the dragon is transferred also clear sire allowances
1050             delete sireAllowedToAddress[_tokenId];
1051             // clear any previously approved ownership exchange
1052             delete dragonIndexToApproved[_tokenId];
1053         }
1054 
1055         //Dragon storage dragon = dragons[_tokenId];
1056 
1057         // Emit the transfer event.
1058         emit Transfer(_from, _to, _tokenId);
1059     }
1060 
1061     /// @dev An internal method that creates a new dragon and stores it. This
1062     ///  method doesn't do any checking and should only be called when the
1063     ///  input data is known to be valid. Will generate both a Birth event
1064     ///  and a Transfer event.
1065     /// @param _matronId The dragon ID of the matron of this dragon (zero for firstGen)
1066     /// @param _sireId The dragon ID of the sire of this dragon (zero for firstGen)
1067     /// @param _generation The generation number of this dragon, must be computed by caller.
1068     /// @param _dna The dragon's genetic code.
1069     /// @param _agility The dragon's agility
1070     /// @param _strength The dragon's strength
1071     /// @param _intelligence The dragon's intelligence
1072     /// @param _runelevel The dragon's rune level
1073     /// @param _owner The inital owner of this dragon, must be non-zero (except for the mythical beast, ID 0)
1074     function _createDragon(
1075         uint256 _matronId,
1076         uint256 _sireId,
1077         uint256 _generation,
1078         uint256 _dna,
1079         uint64 _agility,
1080         uint64 _strength,
1081         uint64 _intelligence,
1082         uint64 _runelevel,
1083         address _owner
1084     )
1085     internal
1086     returns (uint)
1087     {
1088         require(_matronId == uint256(uint32(_matronId)));
1089         require(_sireId == uint256(uint32(_sireId)));
1090         require(_generation == uint256(uint32(_generation)));
1091 
1092         Dragon memory _dragon = Dragon({
1093             dna: _dna,
1094             birthTime: uint64(now),
1095             breedTime: 0,
1096             matronId: uint32(_matronId),
1097             sireId: uint32(_sireId),
1098             siringWithId: 0,
1099             generation: uint32(_generation)
1100             });
1101 
1102         DragonAssets memory _dragonAssets = DragonAssets({
1103             runeLevel: _runelevel,
1104             agility: _agility,
1105             strength: _strength,
1106             intelligence: _intelligence
1107             });
1108 
1109         uint256 newDragonId = dragons.push(_dragon) - 1;
1110 
1111         dragonAssets[newDragonId] = _dragonAssets;
1112 
1113         // It's probably never going to happen, 4 billion dragons is A LOT, but
1114         // let's just be 100% sure we never let this happen.
1115         require(newDragonId == uint256(uint32(newDragonId)));
1116 
1117         // emit the birth event
1118         emit Birth(
1119             _owner,
1120             newDragonId,
1121             uint256(_dragon.matronId),
1122             uint256(_dragon.sireId),
1123             _dragon.dna,
1124             _dragon.generation,
1125             _runelevel
1126         );
1127 
1128         // This will assign ownership, and also emit the Transfer event as
1129         // per ERC721 draft
1130         _transfer(address(0), _owner, newDragonId);
1131 
1132         return newDragonId;
1133     }
1134 
1135     function setUpdateAssetFee(uint256 newFee) external onlyCLevel {
1136         updateAssetFee = newFee;
1137     }
1138 
1139 
1140     function updateDragonAsset(uint256 _dragonId, uint64 _rune, uint64 _agility, uint64 _strength, uint64 _intelligence)
1141     external
1142     whenNotPaused
1143     onlyCOO
1144     {
1145 
1146         DragonAssets storage currentDragonAsset = dragonAssets[_dragonId];
1147 
1148         require(_rune > currentDragonAsset.runeLevel);
1149         require(_agility >= currentDragonAsset.agility);
1150         require(_strength >= currentDragonAsset.strength);
1151         require(_intelligence >= currentDragonAsset.intelligence);
1152 
1153         DragonAssets memory _dragonAsset = DragonAssets({
1154             runeLevel: _rune,
1155             agility: _agility,
1156             strength: _strength,
1157             intelligence: _intelligence
1158             });
1159 
1160         dragonAssets[_dragonId] = _dragonAsset;
1161         msg.sender.transfer(updateAssetFee);
1162         emit DragonAssetsUpdated(_dragonId, _rune, _agility, _strength, _intelligence);
1163 
1164     }
1165 
1166     function requestAssetUpdate(uint256 _dragonId, uint256 _rune)
1167     external
1168     payable
1169     whenNotPaused
1170     {
1171         require(msg.value >= updateAssetFee);
1172 
1173         DragonAssets storage currentDragonAsset = dragonAssets[_dragonId];
1174         require(_rune > currentDragonAsset.runeLevel);
1175 
1176         emit DragonAssetRequest(_dragonId);
1177 
1178         //assetManagement.requestAssetUpdate.value(msg.value)(_dragonId);
1179     }
1180 
1181     /// @notice Query if an address is an authorized operator for another address
1182     /// @param _owner The address that owns the NFTs
1183     /// @param _operator The address that acts on behalf of the owner
1184     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
1185     function isApprovedForAll(address _owner, address _operator) external view returns (bool)
1186     {
1187         return authorised[_owner][_operator];
1188     }
1189 
1190     /// @notice Enable or disable approval for a third party ("operator") to manage
1191     ///  all of `msg.sender`'s assets
1192     /// @dev Emits the ApprovalForAll event. The contract MUST allow
1193     ///  multiple operators per owner.
1194     /// @param _operator Address to add to the set of authorized operators
1195     /// @param _approved True if the operator is approved, false to revoke approval
1196     function setApprovalForAll(address _operator, bool _approved) external
1197     {
1198         emit ApprovalForAll(msg.sender,_operator, _approved);
1199         authorised[msg.sender][_operator] = _approved;
1200     }
1201 
1202     function tokenURI(uint256 _tokenId) external view isValidToken(_tokenId) returns (string memory)
1203     {
1204         uint maxlength = 78;
1205         bytes memory reversed = new bytes(maxlength);
1206         uint i = 0;
1207         uint _tmpTokenId = _tokenId;
1208         uint _offset = 48;
1209 
1210         bytes memory _uriBase;
1211         _uriBase = bytes(tokenURIPrefix);
1212 
1213         while (_tmpTokenId != 0) {
1214             uint remainder = _tmpTokenId % 10;
1215             _tmpTokenId = _tmpTokenId / 10;
1216             reversed[i++] = byte(uint8(_offset + remainder));
1217         }
1218 
1219         bytes memory s = new bytes(_uriBase.length + i);
1220         uint j;
1221 
1222         //add the base to the final array
1223         for (j = 0; j < _uriBase.length; j++) {
1224             s[j] = _uriBase[j];
1225         }
1226         //add the tokenId to the final array
1227         for (j = 0; j < i; j++) {
1228             s[j + _uriBase.length] = reversed[i - 1 - j];
1229         }
1230         //turn it into a string and return it
1231         return string(s);
1232     }
1233 }
1234 
1235 // File: contracts/DragonOwnership.sol
1236 
1237 pragma solidity ^0.5.10;
1238 
1239 
1240 /// @title The facet of the BlockDragons core contract that manages ownership, ERC-721 (draft) compliant.
1241 /// @author Zynappse Corporation (https://www.zynapse.com)
1242 /// @dev Ref: https://github.com/ethereum/EIPs/issues/721
1243 ///  @dev Refer to the Dragon contract documentation for details in contract interactions.
1244 contract DragonOwnership is DragonBase {
1245 
1246     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
1247     string public constant name = "Drakons";
1248     string public constant symbol = "DRKNS";
1249 
1250     //bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
1251 
1252     //bytes4 constant InterfaceSignature_ERC721 =
1253     //bytes4(keccak256('name()')) ^
1254     //bytes4(keccak256('symbol()')) ^
1255     //bytes4(keccak256('totalSupply()')) ^
1256     //bytes4(keccak256('balanceOf(address)')) ^
1257     //bytes4(keccak256('ownerOf(uint256)')) ^
1258     //bytes4(keccak256('approve(address,uint256)')) ^
1259     //bytes4(keccak256('transfer(address,uint256)')) ^
1260     //bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1261     //bytes4(keccak256('tokensOfOwner(address)')) ^
1262     //bytes4(keccak256('tokenMetadata(uint256,string)'));
1263 
1264     /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
1265     ///  Returns true for any standardized interfaces implemented by this contract. We implement
1266     ///  ERC-165 (obviously!) and ERC-721.
1267     //function supportsInterface(bytes4 _interfaceID) external view returns (bool)
1268     //{
1269     //    return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
1270     //}
1271 
1272     function setTokenURIAffixes(string calldata _prefix, string calldata _suffix) external onlyCEO {
1273         tokenURIPrefix = _prefix;
1274         tokenURISuffix = _suffix;
1275     }
1276 
1277     /// @dev Checks if a given address is the current owner of a particular Dragon.
1278     /// @param _claimant the address we are validating against.
1279     /// @param _tokenId dragon id, only valid when > 0
1280     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
1281         return dragonIndexToOwner[_tokenId] == _claimant;
1282     }
1283 
1284     /// @dev Checks if a given address currently has transferApproval for a particular Dragon.
1285     /// @param _claimant the address we are confirming dragon is approved for.
1286     /// @param _tokenId dragon id, only valid when > 0
1287     function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
1288         return dragonIndexToApproved[_tokenId] == _claimant;
1289     }
1290 
1291     /// @dev Marks an address as being approved for transferFrom(), overwriting any previous
1292     ///  approval. Setting _approved to address(0) clears all transfer approval.
1293     ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
1294     ///  _approve() and transferFrom() are used together for putting Dragons on auction, and
1295     ///  there is no value in spamming the log with Approval events in that case.
1296     function _approve(uint256 _tokenId, address _approved) internal {
1297         dragonIndexToApproved[_tokenId] = _approved;
1298     }
1299 
1300     /// @notice Returns the number of Dragons owned by a specific address.
1301     /// @param _owner The owner address to check.
1302     /// @dev Required for ERC-721 compliance
1303     function balanceOf(address _owner) public view returns (uint256 count) {
1304         return ownershipTokenCount[_owner];
1305     }
1306 
1307     /// @notice Transfers the ownership of an NFT from one address to another address
1308     /// @dev Throws unless `msg.sender` is the current owner, an authorized
1309     ///  operator, or the approved address for this NFT. Throws if `_from` is
1310     ///  not the current owner. Throws if `_to` is the zero address. Throws if
1311     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
1312     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
1313     ///  `onERC721Received` on `_to` and throws if the return value is not
1314     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1315     /// @param _from The current owner of the NFT
1316     /// @param _to The new owner
1317     /// @param _tokenId The NFT to transfer
1318     /// @param data Additional data with no specified format, sent in call to `_to`
1319     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public payable
1320     {
1321         require(_to != address(0));
1322         require(_to != address(this));
1323         require(_to != address(saleAuction));
1324         require(_to != address(siringAuction));
1325 
1326         // Check for approval and valid ownership
1327         //require(_approvedFor(msg.sender, _tokenId));
1328         //require(_owns(_from, _tokenId));
1329         address owner = ownerOf(_tokenId);
1330         require(owner == _from);
1331         require (owner == msg.sender || dragonIndexToApproved[_tokenId] == msg.sender || authorised[owner][msg.sender]);
1332 
1333         // Reassign ownership, clearing pending approvals and emitting Transfer event.
1334         _transfer(_from, _to, _tokenId);
1335 
1336         uint32 size;
1337         assembly {
1338             size := extcodesize(_to)
1339         }
1340 
1341         if(size > 0) {
1342             ERC721TokenReceiver receiver = ERC721TokenReceiver(_to);
1343             require(receiver.onERC721Received(msg.sender,_from,_tokenId,data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")));
1344         }
1345     }
1346 
1347     /// @notice Transfers the ownership of an NFT from one address to another address
1348     /// @dev This works identically to the other function with an extra data parameter,
1349     ///  except this function just sets data to "".
1350     /// @param _from The current owner of the NFT
1351     /// @param _to The new owner
1352     /// @param _tokenId The NFT to transfer
1353     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable
1354     {
1355         safeTransferFrom(_from, _to, _tokenId, "");
1356     }
1357 
1358     /// @notice Transfers a Dragon to another address. If transferring to a smart
1359     ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
1360     ///  BlockDragonz specifically) or your Dragon may be lost forever. Seriously.
1361     /// @param _to The address of the recipient, can be a user or contract.
1362     /// @param _tokenId The ID of the Dragon to transfer.
1363     function transfer(
1364         address _to,
1365         uint256 _tokenId
1366     )
1367     external
1368     whenNotPaused
1369     {
1370         // Safety check to prevent against an unexpected 0x0 default.
1371         require(_to != address(0));
1372         // Disallow transfers to this contract to prevent accidental misuse.
1373         // The contract should never own any dragons (except very briefly
1374         // after a firstGen dragon is created and before it goes on auction).
1375         require(_to != address(this));
1376         // Disallow transfers to the auction contracts to prevent accidental
1377         // misuse. Auction contracts should only take ownership of dragons
1378         // through the allow + transferFrom flow.
1379         require(_to != address(saleAuction));
1380         require(_to != address(siringAuction));
1381 
1382         // You can only send your own dragon.
1383         require(_owns(msg.sender, _tokenId));
1384 
1385         // Reassign ownership, clear pending approvals, emit Transfer event.
1386         _transfer(msg.sender, _to, _tokenId);
1387     }
1388 
1389     /// @notice Returns the address currently assigned ownership of a given Dragon.
1390     /// @dev Required for ERC-721 compliance.
1391     function ownerOf(uint256 _tokenId) public view isValidToken(_tokenId) returns (address)
1392     {
1393         return dragonIndexToOwner[_tokenId];
1394     }
1395 
1396     /// @notice Grant another address the right to transfer a specific Dragon via
1397     ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
1398     /// @param _approved The address to be granted transfer approval. Pass address(0) to
1399     ///  clear all approvals.
1400     /// @param _tokenId The ID of the Dragon that can be transferred if this call succeeds.
1401     /// @dev Required for ERC-721 compliance.
1402     //function approve( address _to, uint256 _tokenId) external whenNotPaused {
1403     function approve(address _approved, uint256 _tokenId) external payable whenNotPaused {
1404         // Only an owner can grant transfer approval.
1405         //require(_owns(msg.sender, _tokenId) || authorised[owner][msg.sender]);
1406         address owner = dragonIndexToOwner[_tokenId];
1407         require(owner == msg.sender || authorised[owner][msg.sender]);
1408 
1409         // Register the approval (replacing any previous approval).
1410         _approve(_tokenId, _approved);
1411 
1412         // Emit approval event.
1413         //emit Approval(msg.sender, _approved, _tokenId);
1414         emit Approval(owner, _approved, _tokenId);
1415     }
1416 
1417     /// @notice Get the approved address for a single NFT
1418     /// @dev Throws if `_tokenId` is not a valid NFT.
1419     /// @param _tokenId The NFT to find the approved address for
1420     /// @return The approved address for this NFT, or the zero address if there is none
1421     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address)
1422     {
1423         return dragonIndexToApproved[_tokenId];
1424     }
1425 
1426 
1427     /// @notice Transfer a Dragon owned by another address, for which the calling address
1428     ///  has previously been granted transfer approval by the owner.
1429     /// @param _from The address that owns the Dragon to be transfered.
1430     /// @param _to The address that should take ownership of the Dragon. Can be any address,
1431     ///  including the caller.
1432     /// @param _tokenId The ID of the Dragon to be transferred.
1433     /// @dev Required for ERC-721 compliance.
1434     function transferFrom(address _from, address _to, uint256 _tokenId) external payable whenNotPaused
1435     {
1436         // Safety check to prevent against an unexpected 0x0 default.
1437         require(_to != address(0));
1438         // Disallow transfers to this contract to prevent accidental misuse.
1439         // The contract should never own any dragons (except very briefly
1440         // after a firstGen dragon is created and before it goes on auction).
1441         require(_to != address(this));
1442         // Check for approval and valid ownership
1443         //require(_approvedFor(msg.sender, _tokenId));
1444         //require(_owns(_from, _tokenId));
1445         address owner = ownerOf(_tokenId);
1446         require(owner == _from);
1447         require (owner == msg.sender || dragonIndexToApproved[_tokenId] == msg.sender || authorised[owner][msg.sender]);
1448 
1449         // Reassign ownership (also clears pending approvals and emits Transfer event).
1450         _transfer(_from, _to, _tokenId);
1451     }
1452 
1453     /// @notice Returns the total number of Dragons currently in existence.
1454     /// @dev Required for ERC-721 compliance.
1455     function totalSupply() public view returns (uint) {
1456         return dragons.length - 1;
1457     }
1458 
1459     /// @notice Returns a list of all Dragon IDs assigned to an address.
1460     /// @param _owner The owner whose Dragons we are interested in.
1461     /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1462     ///  expensive (it walks the entire Dragon array looking for dragons belonging to owner),
1463     ///  but it also returns a dynamic array, which is only supported for web3 calls, and
1464     ///  not contract-to-contract calls.
1465     function tokensOfOwner(address _owner) external view returns(uint256[] memory ownerTokens) {
1466         uint256 tokenCount = balanceOf(_owner);
1467 
1468         if (tokenCount == 0) {
1469             // Return an empty array
1470             return new uint256[](0);
1471         } else {
1472             uint256[] memory result = new uint256[](tokenCount);
1473             uint256 totalDragons = totalSupply();
1474             uint256 resultIndex = 0;
1475 
1476             // We count on the fact that all dragons have IDs starting at 1 and increasing
1477             // sequentially up to the totalDragon count.
1478             uint256 dragonId;
1479 
1480             for (dragonId = 1; dragonId <= totalDragons; dragonId++) {
1481                 if (dragonIndexToOwner[dragonId] == _owner) {
1482                     result[resultIndex] = dragonId;
1483                     resultIndex++;
1484                 }
1485             }
1486 
1487             return result;
1488         }
1489     }
1490 
1491     /// @notice Enumerate valid NFTs
1492     /// @dev Throws if `_index` >= `totalSupply()`.
1493     /// @param _index A counter less than `totalSupply()`
1494     /// @return The token identifier for the `_index`th NFT,
1495     ///  (sort order not specified)
1496     function tokenByIndex(uint256 _index) external view returns (uint256)
1497     {
1498         return _index;
1499     }
1500 
1501     /// @notice Enumerate NFTs assigned to an owner
1502     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
1503     ///  `_owner` is the zero address, representing invalid NFTs.
1504     /// @param _owner An address where we are interested in NFTs owned by them
1505     /// @param _index A counter less than `balanceOf(_owner)`
1506     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
1507     ///   (sort order not specified)
1508     //function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256)
1509     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 dragonId)
1510     {
1511         uint256 count = 0;
1512         for (uint256 i = 1; i <= totalSupply(); ++i) {
1513             if (dragonIndexToOwner[i] == _owner) {
1514                 if (count == _index) {
1515                     return i;
1516                 } else {
1517                     count++;
1518                 }
1519             }
1520         }
1521         revert();
1522     }
1523 }
1524 
1525 // File: contracts/DragonBreeding.sol
1526 
1527 pragma solidity ^0.5.10;
1528 
1529 
1530 /// @title DragonCore that manages Dragon siring, gestation, and birth.
1531 /// @author Zynappse Corporation (https://www.zynapse.com)
1532 /// @dev See the DragonCore contract documentation to understand how the various contract facets are arranged.
1533 contract DragonBreeding is DragonOwnership {
1534 
1535     /// @dev The Pregnant event is fired when two dragons successfully breed and the pregnancy timer begins for the matron.
1536     event Pregnant(address owner, uint256 matronId, uint256 sireId);
1537 
1538     /// @notice The minimum payment required to use breedWithAuto(). This fee goes towards
1539     ///  the gas cost paid by whatever calls giveBirth(), and can be dynamically updated by
1540     ///  the CIO role as the gas price changes.
1541     uint256 public autoBirthFee = 2 finney;
1542 
1543     // Keeps track of number of pregnant dragons.
1544     uint256 public pregnantDragons;
1545 
1546     uint32 public BREEDING_LIMIT = 3;
1547     mapping(uint256 => uint64) breeding;
1548 
1549     /// @dev The address of the sibling contract that is used to implement the sooper-sekret genetic combination algorithm.
1550     //GeneScienceInterface public geneScience;
1551 
1552     /// @dev Update the address of the genetic contract, can only be called by the CEO.
1553     /// @param _address An address of a GeneScience contract instance to be used from this point forward.
1554     //function setGeneScienceAddress(address _address) external onlyCEO {
1555     //    GeneScienceInterface candidateContract = GeneScienceInterface(_address);
1556 
1557     // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1558     //    require(candidateContract.isGeneScience());
1559 
1560     // Set the new contract address
1561     //    geneScience = candidateContract;
1562     //}
1563 
1564     /// @dev Checks that a given Dragon is able to breed. Requires that the
1565     ///  current cooldown is finished (for sires) and also checks that there is
1566     ///  no pending pregnancy.
1567     function _isReadyToBreed(Dragon storage _dragon) internal view returns (bool) {
1568         // In addition to checking the cooldownEndBlock, we also need to check to see if
1569         // the dragon has a pending birth; there can be some period of time between the end
1570         // of the pregnacy timer and the birth event.
1571         return (_dragon.siringWithId == 0);
1572     }
1573 
1574     /// @dev Check if a sire has authorized breeding with this matron. True if both sire
1575     ///  and matron have the same owner, or if the sire has given siring permission to
1576     ///  the matron's owner (via approveSiring()).
1577     function _isSiringPermitted(uint256 _sireId, uint256 _matronId) internal view returns (bool) {
1578         address matronOwner = dragonIndexToOwner[_matronId];
1579         address sireOwner = dragonIndexToOwner[_sireId];
1580 
1581         // Siring is okay if they have same owner, or if the matron's owner was given
1582         // permission to breed with this sire.
1583         return (matronOwner == sireOwner || sireAllowedToAddress[_sireId] == matronOwner);
1584     }
1585 
1586 
1587 
1588     /// @notice Grants approval to another user to sire with one of your Dragons.
1589     /// @param _addr The address that will be able to sire with your Dragon. Set to
1590     ///  address(0) to clear all siring approvals for this Dragon.
1591     /// @param _sireId A Dragon that you own that _addr will now be able to sire with.
1592     function approveSiring(address _addr, uint256 _sireId)
1593     external
1594     whenNotPaused
1595     {
1596         require(_owns(msg.sender, _sireId));
1597         sireAllowedToAddress[_sireId] = _addr;
1598     }
1599 
1600     /// @dev Updates the minimum payment required for calling giveBirthAuto(). Can only
1601     ///  be called by the CMO address. (This fee is used to offset the gas cost incurred
1602     ///  by the autobirth daemon).
1603     function setAutoBirthFee(uint256 val) external onlyCLevel {
1604         autoBirthFee = val;
1605     }
1606 
1607     /// @dev Checks to see if a given Dragon is pregnant and (if so) if the gestation period has passed.
1608     function _isReadyToGiveBirth(Dragon storage _matron) private view returns (bool) {
1609         return (_matron.siringWithId != 0);
1610     }
1611 
1612     /// @notice Checks that a given dragon is able to breed (i.e. it is not pregnant or
1613     ///  in the middle of a siring cooldown).
1614     /// @param _dragonId reference the id of the dragon, any user can inquire about it
1615     function isReadyToBreed(uint256 _dragonId)
1616     public
1617     view
1618     returns (bool)
1619     {
1620         require(_dragonId > 0);
1621         Dragon storage dragon = dragons[_dragonId];
1622         return _isReadyToBreed(dragon);
1623     }
1624 
1625     /// @dev Checks whether a dragon is currently pregnant.
1626     /// @param _dragonId reference the id of the dragon, any user can inquire about it
1627     function isPregnant(uint256 _dragonId)
1628     public
1629     view
1630     returns (bool)
1631     {
1632         require(_dragonId > 0);
1633         // A dragon is pregnant if and only if this field is set
1634         return dragons[_dragonId].siringWithId != 0;
1635     }
1636 
1637     /// @dev Internal check to see if a given sire and matron are a valid mating pair. DOES NOT
1638     /// check ownership permissions (that is up to the caller).
1639     /// @param _matron A reference to the Dragon struct of the potential matron.
1640     /// @param _matronId The matron's ID.
1641     /// @param _sire A reference to the Dragon struct of the potential sire.
1642     /// @param _sireId The sire's ID
1643     function _isValidMatingPair(
1644         Dragon storage _matron,
1645         uint256 _matronId,
1646         Dragon storage _sire,
1647         uint256 _sireId
1648     )
1649     private
1650     view
1651     returns(bool)
1652     {
1653         if(breeding[_matronId] >= BREEDING_LIMIT) {
1654             return false;
1655         }
1656 
1657         uint256 sireElement = _sire.dna / 1e34;
1658         uint256 matronElement = _matron.dna / 1e34;
1659 
1660         if (sireElement != matronElement) {
1661           return false;
1662         }
1663 
1664         // A Dragon can't breed with itself!
1665         if (_matronId == _sireId) {
1666             return false;
1667         }
1668 
1669         // Dragons can't breed with their parents.
1670         if (_matron.matronId == _sireId || _matron.sireId == _sireId) {
1671             return false;
1672         }
1673 
1674         if (_sire.matronId == _matronId || _sire.sireId == _matronId) {
1675             return false;
1676         }
1677 
1678         // We can short circuit the sibling check (below) if either dragon is first generation (has a matron ID of zero).
1679         if (_sire.matronId == 0 || _matron.matronId == 0) {
1680             return true;
1681         }
1682 
1683         // Dragons can't breed with full or half siblings.
1684         if (_sire.matronId == _matron.matronId || _sire.matronId == _matron.sireId) {
1685             return false;
1686         }
1687         if (_sire.sireId == _matron.matronId || _sire.sireId == _matron.sireId) {
1688             return false;
1689         }
1690 
1691         // Everything seems cool! Let's get DTF.
1692         return true;
1693     }
1694 
1695     /// @dev Internal check to see if a given sire and matron are a valid mating pair for
1696     ///  breeding via auction (i.e. skips ownership and siring approval checks).
1697     function _canBreedWithViaAuction(uint256 _matronId, uint256 _sireId)
1698     internal
1699     view
1700     returns (bool)
1701     {
1702         Dragon storage matron = dragons[_matronId];
1703         Dragon storage sire = dragons[_sireId];
1704         return _isValidMatingPair(matron, _matronId, sire, _sireId);
1705     }
1706 
1707     /// @notice Checks to see if two dragons can breed together, including checks for
1708     ///  ownership and siring approvals. Does NOT check that both dragons are ready for
1709     ///  breeding (i.e. breedWith could still fail until the cooldowns are finished).
1710     ///  TODO: Shouldn't this check pregnancy and cooldowns?!?
1711     /// @param _matronId The ID of the proposed matron.
1712     /// @param _sireId The ID of the proposed sire.
1713     function canBreedWith(uint256 _matronId, uint256 _sireId)
1714     external
1715     view
1716     returns(bool)
1717     {
1718         require(_matronId > 0);
1719         require(_sireId > 0);
1720         Dragon storage matron = dragons[_matronId];
1721         Dragon storage sire = dragons[_sireId];
1722         return _isValidMatingPair(matron, _matronId, sire, _sireId) &&
1723         _isSiringPermitted(_sireId, _matronId);
1724     }
1725 
1726     /// @dev Internal utility function to initiate breeding, assumes that all breeding
1727     ///  requirements have been checked.
1728     function _breedWith(uint256 _matronId, uint256 _sireId) internal {
1729         // Grab a reference to the Dragons from storage.
1730         // Dragon storage sire = dragons[_sireId];
1731         Dragon storage matron = dragons[_matronId];
1732 
1733         // Mark the matron as pregnant, keeping track of who the sire is.
1734         matron.siringWithId = uint32(_sireId);
1735 
1736         // Trigger the cooldown for both parents.
1737         // _triggerCooldown(sire);
1738         // _triggerCooldown(matron);
1739 
1740         // Clear siring permission for both parents. This may not be strictly necessary but it's likely to avoid confusion!
1741         delete sireAllowedToAddress[_matronId];
1742         delete sireAllowedToAddress[_sireId];
1743 
1744         // Every time a dragon gets pregnant, counter is incremented.
1745         pregnantDragons++;
1746 
1747         // Emit the pregnancy event.
1748         emit Pregnant(dragonIndexToOwner[_matronId], _matronId, _sireId);
1749     }
1750 
1751     /// @notice Breed a Dragon you own (as matron) with a sire that you own, or for which you
1752     ///  have previously been given Siring approval. Will either make your dragon pregnant, or will
1753     ///  fail entirely. Requires a pre-payment of the fee given out to the first caller of giveBirth()
1754     /// @param _matronId The ID of the Dragon acting as matron (will end up pregnant if successful)
1755     /// @param _sireId The ID of the Dragon acting as sire (will begin its siring cooldown if successful)
1756     function breedWithAuto(uint256 _matronId, uint256 _sireId)
1757     external
1758     payable
1759     whenNotPaused
1760     {
1761         // Checks for payment.
1762         require(msg.value >= autoBirthFee);
1763 
1764         // Caller must own the matron.
1765         require(_owns(msg.sender, _matronId));
1766 
1767         // Neither sire nor matron are allowed to be on auction during a normal
1768         // breeding operation, but we don't need to check that explicitly.
1769         // For matron: The caller of this function can't be the owner of the matron
1770         //   because the owner of a Dragon on auction is the auction house, and the
1771         //   auction house will never call breedWith().
1772         // For sire: Similarly, a sire on auction will be owned by the auction house
1773         //   and the act of transferring ownership will have cleared any oustanding
1774         //   siring approval.
1775         // Thus we don't need to spend gas explicitly checking to see if either dragon
1776         // is on auction.
1777 
1778         // Check that matron and sire are both owned by caller, or that the sire
1779         // has given siring permission to caller (i.e. matron's owner).
1780         // Will fail for _sireId = 0
1781         require(_isSiringPermitted(_sireId, _matronId));
1782 
1783         // Grab a reference to the potential matron
1784         Dragon storage matron = dragons[_matronId];
1785 
1786         // Make sure matron isn't pregnant, or in the middle of a siring cooldown
1787         require(_isReadyToBreed(matron));
1788 
1789         // Grab a reference to the potential sire
1790         Dragon storage sire = dragons[_sireId];
1791 
1792         // Make sure sire isn't pregnant, or in the middle of a siring cooldown
1793         require(_isReadyToBreed(sire));
1794 
1795         // Update the breedTime
1796         matron.breedTime = uint64(now);
1797 
1798         // Test that these dragons are a valid mating pair.
1799         require(_isValidMatingPair(
1800                 matron,
1801                 _matronId,
1802                 sire,
1803                 _sireId
1804             ));
1805 
1806 
1807         // All checks passed, dragon gets pregnant!
1808         _breedWith(_matronId, _sireId);
1809     }
1810 
1811     /// @notice Have a pregnant Dragon give birth!
1812     /// @param _matronId A Dragon ready to give birth.
1813     /// @param _dna Dragon's DNA
1814     /// @param _agility Dragon's agility initial value
1815     /// @param _strength Dragon's Strenght initial value
1816     /// @param _intelligence Dragon's Intelligence initial value
1817     /// @param _runelevel Dragon's Rune Level initial value
1818     /// @return The Dragon ID of the new dragon.
1819     /// @dev Looks at a given Dragon and, if pregnant and if the gestation period has passed,
1820     ///  combines the genes of the two parents to create a new dragon. The new Dragon is assigned
1821     ///  to the current owner of the matron. Upon successful completion, both the matron and the
1822     ///  new dragon will be ready to breed again. Note that anyone can call this function (if they
1823     ///  are willing to pay the gas!), but the new dragon always goes to the mother's owner.
1824     function giveBirth(uint256 _matronId, uint256 _dna, uint64 _agility, uint64 _strength, uint64 _intelligence, uint64 _runelevel)
1825     external
1826     whenNotPaused
1827     onlyCOO
1828     returns(uint256)
1829     {
1830         // Grab a reference to the matron in storage.
1831         Dragon storage matron = dragons[_matronId];
1832 
1833         // Check that the dragon is a valid dragon.
1834         require(matron.birthTime != 0);
1835 
1836         // Check that the matron is pregnant, and that its time has come!
1837         require(_isReadyToGiveBirth(matron));
1838 
1839         // Grab a reference to the sire in storage.
1840         uint256 sireId = matron.siringWithId;
1841         Dragon storage sire = dragons[sireId];
1842 
1843         // Determine the higher generation number of the two parents
1844         uint32 parentGen = matron.generation;
1845         if (sire.generation > matron.generation) {
1846             parentGen = sire.generation;
1847         }
1848 
1849         // Call the sooper-sekret gene mixing operation.
1850         uint256 matronId = _matronId;
1851         uint64 agility = _agility;
1852         uint64 strength = _strength;
1853         uint64 intelligence = _intelligence;
1854         uint64 runelevel = _runelevel;
1855 
1856         uint256 childDNA = _dna;
1857 
1858         // Make the new dragon!
1859         address owner = dragonIndexToOwner[matronId];
1860         //uint256 dragonId = _createDragon(_matronId, matron.siringWithId, parentGen + 1, childDNA, _agility, _strength, _intelligence, _runelevel, owner);
1861         uint256 dragonId = _createDragon(matronId, sireId, parentGen + 1, childDNA, agility, strength, intelligence, runelevel, owner);
1862 
1863         //increment the breeding for the matron
1864         breeding[matronId]++;
1865 
1866         // Clear the reference to sire from the matron (REQUIRED! Having siringWithId
1867         // set is what marks a matron as being pregnant.)
1868         delete matron.siringWithId;
1869 
1870         // Every time a dragon gives birth counter is decremented.
1871         pregnantDragons--;
1872 
1873         // Send the balance fee to the person who made birth happen.
1874         //msg.sender.send(autoBirthFee);
1875         msg.sender.transfer(autoBirthFee);
1876 
1877         // return the new dragon's ID
1878         return dragonId;
1879     }
1880 
1881     function getPregnantDragons() external view returns(uint256[] memory pregnantDragonsList) {
1882 
1883         if (pregnantDragons == 0) {
1884             return new uint256[](0);
1885         } else {
1886             uint256[] memory result = new uint256[](pregnantDragons);
1887             uint256 totalDragons = totalSupply();
1888             uint256 resultIndex = 0;
1889 
1890              uint256 dragonId;
1891 
1892             for (dragonId = 1; dragonId <= totalDragons; dragonId++) {
1893                 if (isPregnant(dragonId)) {
1894                     result[resultIndex] = dragonId;
1895                     resultIndex++;
1896                 }
1897             }
1898 
1899             return result;
1900         }
1901     }
1902 
1903     function setBreedingLimit(uint32 _value) external onlyCLevel {
1904         BREEDING_LIMIT = _value;
1905     }
1906 }
1907 
1908 // File: contracts/DragonAuction.sol
1909 
1910 pragma solidity ^0.5.10;
1911 
1912 
1913 /// @title Handles creating auctions for sale and siring of dragons.
1914 /// @author Zynappse Corporation (https://www.zynapse.com)
1915 ///  This wrapper of ReverseAuction exists only so that users can create
1916 ///  auctions with only one transaction.
1917 contract DragonAuction is DragonBreeding {
1918 
1919     // @notice The auction contract variables are defined in DragonBase to allow
1920     //  us to refer to them in DragonOwnership to prevent accidental transfers.
1921     // `saleAuction` refers to the auction for gen0 and p2p sale of dragons.
1922     // `siringAuction` refers to the auction for siring rights of dragons.
1923 
1924     /// @dev Sets the reference to the sale auction.
1925     /// @param _address - Address of sale contract.
1926     function setSaleAuctionAddress(address _address) external onlyCEO {
1927         SaleClockAuction candidateContract = SaleClockAuction(_address);
1928 
1929         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1930         require(candidateContract.isSaleClockAuction());
1931 
1932         // Set the new contract address
1933         saleAuction = candidateContract;
1934     }
1935 
1936     /// @dev Sets the reference to the siring auction.
1937     /// @param _address - Address of siring contract.
1938     function setSiringAuctionAddress(address _address) external onlyCEO {
1939         SiringClockAuction candidateContract = SiringClockAuction(_address);
1940 
1941         // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
1942         require(candidateContract.isSiringClockAuction());
1943 
1944         // Set the new contract address
1945         siringAuction = candidateContract;
1946     }
1947 
1948     /// @dev Put a dragon up for auction.
1949     ///  Does some ownership trickery to create auctions in one tx.
1950     function createSaleAuction(
1951         uint256 _dragonId,
1952         uint256 _startingPrice,
1953         uint256 _endingPrice,
1954         uint256 _duration
1955     )
1956     external
1957     whenNotPaused
1958     {
1959         // Auction contract checks input sizes
1960         // If dragon is already on any auction, this will throw
1961         // because it will be owned by the auction contract.
1962         require(_owns(msg.sender, _dragonId));
1963         // Ensure the dragon is not pregnant to prevent the auction
1964         // contract accidentally receiving ownership of the child.
1965         // NOTE: the dragon IS allowed to be in a cooldown.
1966         require(!isPregnant(_dragonId));
1967         _approve(_dragonId, address(saleAuction));
1968         // Sale auction throws if inputs are invalid and clears
1969         // transfer and sire approval after escrowing the dragon.
1970         saleAuction.createAuction(
1971             _dragonId,
1972             _startingPrice,
1973             _endingPrice,
1974             _duration,
1975             msg.sender
1976         );
1977     }
1978 
1979     /// @dev Put a dragon up for auction to be sire.
1980     ///  Performs checks to ensure the dragon can be sired, then
1981     ///  delegates to reverse auction.
1982     function createSiringAuction(
1983         uint256 _dragonId,
1984         uint256 _startingPrice,
1985         uint256 _endingPrice,
1986         uint256 _duration
1987     )
1988     external
1989     whenNotPaused
1990     {
1991         // Auction contract checks input sizes
1992         // If dragon is already on any auction, this will throw
1993         // because it will be owned by the auction contract.
1994         require(_owns(msg.sender, _dragonId));
1995         require(isReadyToBreed(_dragonId));
1996         _approve(_dragonId, address(siringAuction));
1997         // Siring auction throws if inputs are invalid and clears
1998         // transfer and sire approval after escrowing the dragon.
1999         siringAuction.createAuction(
2000             _dragonId,
2001             _startingPrice,
2002             _endingPrice,
2003             _duration,
2004             msg.sender
2005         );
2006     }
2007 
2008 
2009     /// @dev Completes a siring auction by bidding.
2010     ///  Immediately breeds the winning matron with the sire on auction.
2011     /// @param _sireId - ID of the sire on auction.
2012     /// @param _matronId - ID of the matron owned by the bidder.
2013     function bidOnSiringAuction(
2014         uint256 _sireId,
2015         uint256 _matronId
2016     )
2017     external
2018     payable
2019     whenNotPaused
2020     {
2021         // Auction contract checks input sizes
2022         require(_owns(msg.sender, _matronId));
2023         require(isReadyToBreed(_matronId));
2024         require(_canBreedWithViaAuction(_matronId, _sireId));
2025 
2026         // Define the current price of the auction.
2027         uint256 currentPrice = siringAuction.getCurrentPrice(_sireId);
2028         require(msg.value >= currentPrice + autoBirthFee);
2029 
2030         // Siring auction will throw if the bid fails.
2031         siringAuction.bid.value(msg.value - autoBirthFee)(_sireId);
2032         _breedWith(uint32(_matronId), uint32(_sireId));
2033     }
2034 
2035     /// @dev Transfers the balance of the sale auction contract
2036     /// to the DragonCore contract. We use two-step withdrawal to
2037     /// prevent two transfer calls in the auction bid function.
2038     function withdrawAuctionBalances() external onlyCLevel {
2039         saleAuction.withdrawBalance();
2040         siringAuction.withdrawBalance();
2041     }
2042 
2043     /// @dev Shows the balance of the auction contracts.
2044     function getAuctionBalances() external view onlyCLevel returns (uint256, uint256) {
2045         return (
2046             address(saleAuction).balance,
2047             address(siringAuction).balance
2048         );
2049     }
2050 }
2051 
2052 // File: contracts/DragonMinting.sol
2053 
2054 pragma solidity ^0.5.10;
2055 
2056 
2057 /// @title all functions related to creating dragons
2058 contract DragonMinting is DragonAuction {
2059 
2060     /// @dev we can create promo dragons, up to a limit. Only callable by CMO
2061     /// @param _dna the encoded genes of the dragons to be created, any value is accepted
2062     /// @param _owner the future owner of the created dragons. Default to contract CMO
2063     function createPromoDragon(
2064         uint256 _dna,
2065         uint64 _agility,
2066         uint64 _strength,
2067         uint64 _intelligence,
2068         uint64 _runelevel,
2069         address _owner)
2070         external onlyCLevel {
2071 
2072         address dragonOwner = _owner;
2073         if (dragonOwner == address(0)) {
2074             dragonOwner = cmoAddress;
2075         }
2076 
2077         _createDragon(0, 0, 0, _dna, _agility, _strength, _intelligence, _runelevel, dragonOwner);
2078     }
2079 
2080     /// @dev Creates a new gen0 dragon with the given dna and
2081     ///  creates an auction for it.
2082     function createGen0Auction(
2083         uint256 _dna,
2084         uint256 _startingPrice,
2085         uint256 _endingPrice,
2086         uint64 _agility,
2087         uint64 _strength,
2088         uint64 _intelligence,
2089         uint256 _duration )
2090         external onlyCLevel {
2091 
2092         //require(gen0CreatedCount < GEN0_CREATION_LIMIT);
2093 
2094 
2095         uint256 dragonId = _createDragon(0, 0, 0, _dna, _agility, _strength, _intelligence, 0, address(this));
2096         _approve(dragonId, address(saleAuction));
2097 
2098         saleAuction.createAuction(
2099             dragonId,
2100             _startingPrice,
2101             _endingPrice,
2102             _duration,
2103             address(uint160(address(this)))
2104         );
2105 
2106         //gen0CreatedCount++;
2107     }
2108 }
2109 
2110 // File: contracts/DragonCore.sol
2111 
2112 pragma solidity ^0.5.10;
2113 
2114 
2115 contract DragonCore is DragonMinting {
2116 
2117     // Set in case the core contract is broken and an upgrade is required
2118     address public newContractAddress;
2119 
2120     /// @notice Creates the main BlockDragonz smart contract instance.
2121     constructor () public {
2122         // Starts paused.
2123         paused = true;
2124 
2125         // the creator of the contract is the initial CEO
2126         ceoAddress = msg.sender;
2127 
2128         // the creator of the contract is also the initial CMO
2129         cmoAddress = msg.sender;
2130 
2131         // the creator of the contract is also the initial CIO
2132         cioAddress = msg.sender;
2133 
2134         // the creator of the contract is also the initial CFO
2135         cfoAddress = msg.sender;
2136 
2137         // the creator of the contract is also the initial COO
2138         cooAddress = msg.sender;
2139 
2140         // ERC-165 Base
2141         supportedInterfaces[0x01ffc9a7] = true;
2142 
2143         // ERC-721 Base
2144         supportedInterfaces[0x80ac58cd] = true;
2145 
2146         // ERC-721 Metadata
2147         supportedInterfaces[0x5b5e139f] = true;
2148 
2149         // ERC-721 Enumerable
2150         supportedInterfaces[0x780e9d63] = true;
2151 
2152         //ERC-721 Receiver
2153         supportedInterfaces[0x150b7a02] = true;
2154 
2155         // start with the mythical dragon 0 - so we don't have generation-0 parent issues
2156         _createDragon(0, 0, 0, uint256(-1), 0,0,0,0,  address(0));
2157     }
2158 
2159     function setNewAddress(address _newAddress) external onlyCEO whenPaused {
2160         newContractAddress = _newAddress;
2161         emit ContractUpgrade(_newAddress);
2162     }
2163 
2164     /// @notice No tipping!
2165     /// @dev Reject all Ether from being sent here, unless it's from one of the
2166     ///  two auction contracts. (Hopefully, we can prevent user accidents.)
2167     function() external payable {
2168         require(
2169             msg.sender == address(saleAuction) ||
2170             msg.sender == address(siringAuction)
2171         );
2172     }
2173     /// @notice Returns all the relevant information about a specific dragon.
2174     /// @param _id The ID of the dragon of interest.
2175     function getDragon(uint256 _id)
2176     external
2177     view
2178     returns (
2179         uint256 dna,
2180         uint256 birthTime,
2181         uint256 breedTime,
2182         uint256 matronId,
2183         uint256 sireId,
2184         uint256 siringWithId,
2185         uint256 generation,
2186         uint256 runeLevel,
2187         uint256 agility,
2188         uint256 strength,
2189         uint256 intelligence
2190     ) {
2191         Dragon storage dragon = dragons[_id];
2192         DragonAssets storage dragonAsset = dragonAssets[_id];
2193 
2194         dna = dragon.dna;
2195         birthTime = uint256(dragon.birthTime);
2196         breedTime = uint256(dragon.breedTime);
2197         matronId = uint256(dragon.matronId);
2198         sireId = uint256(dragon.sireId);
2199         siringWithId = uint256(dragon.siringWithId);
2200         generation = uint256(dragon.generation);
2201         runeLevel = dragonAsset.runeLevel;
2202         agility = dragonAsset.agility;
2203         strength = dragonAsset.strength;
2204         intelligence = dragonAsset.intelligence;
2205     }
2206 
2207     /// @dev Override unpause so it requires all external contract addresses
2208     ///  to be set before contract can be unpaused. Also, we can't have
2209     ///  newContractAddress set either, because then the contract was upgraded.
2210     /// @notice This is public rather than external so we can call super.unpause
2211     ///  without using an expensive CALL.
2212     function unpause() public onlyCEO whenPaused {
2213         require(address(saleAuction) != address(0));
2214         require(address(siringAuction) != address(0));
2215         require(newContractAddress == address(0));
2216 
2217         // Actually unpause the contract.
2218         super.unpause();
2219     }
2220 
2221     // @dev Allows the CIO to capture the balance available to the contract.
2222     function withdrawBalance() external onlyCLevel {
2223         uint256 balance = address(this).balance;
2224         // Subtract all the currently pregnant dragons we have, plus 1 of margin.
2225         uint256 subtractFees = (pregnantDragons + 1) * autoBirthFee;
2226 
2227         if (balance > subtractFees) {
2228             //cioAddress.send(balance - subtractFees);
2229             cfoAddress.transfer(balance - subtractFees);
2230         }
2231     }
2232 
2233     /// @dev Shows the contract's current balance.
2234     function getBalance() external view onlyCLevel returns (uint256) {
2235         return address(this).balance;
2236     }
2237 }