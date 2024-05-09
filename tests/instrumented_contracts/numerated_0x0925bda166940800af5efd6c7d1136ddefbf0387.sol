1 pragma solidity ^0.4.25;
2 
3 /// @title ERC-721 Non-Fungible Token Standard
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
5 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd.
6 interface ERC721 /* is ERC165 */ {
7     /// @dev This emits when ownership of any NFT changes by any mechanism.
8     ///  This event emits when NFTs are created (`from` == 0) and destroyed
9     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
10     ///  may be created and assigned without emitting Transfer. At the time of
11     ///  any transfer, the approved address for that NFT (if any) is reset to none.
12     ///
13     /// MOVED THIS TO CSportsBase because of how class structure is derived.
14     ///
15     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
16 
17     /// @dev This emits when the approved address for an NFT is changed or
18     ///  reaffirmed. The zero address indicates there is no approved address.
19     ///  When a Transfer event emits, this also indicates that the approved
20     ///  address for that NFT (if any) is reset to none.
21     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
22 
23     /// @dev This emits when an operator is enabled or disabled for an owner.
24     ///  The operator can manage all NFTs of the owner.
25     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
26 
27     /// @notice Count all NFTs assigned to an owner
28     /// @dev NFTs assigned to the zero address are considered invalid, and this
29     ///  function throws for queries about the zero address.
30     /// @param _owner An address for whom to query the balance
31     /// @return The number of NFTs owned by `_owner`, possibly zero
32     function balanceOf(address _owner) external view returns (uint256);
33 
34     /// @notice Find the owner of an NFT
35     /// @dev NFTs assigned to zero address are considered invalid, and queries
36     ///  about them do throw.
37     /// @param _tokenId The identifier for an NFT
38     /// @return The address of the owner of the NFT
39     function ownerOf(uint256 _tokenId) external view returns (address);
40 
41     /// @notice Transfers the ownership of an NFT from one address to another address
42     /// @dev Throws unless `msg.sender` is the current owner, an authorized
43     ///  operator, or the approved address for this NFT. Throws if `_from` is
44     ///  not the current owner. Throws if `_to` is the zero address. Throws if
45     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
46     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
47     ///  `onERC721Received` on `_to` and throws if the return value is not
48     ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
49     /// @param _from The current owner of the NFT
50     /// @param _to The new owner
51     /// @param _tokenId The NFT to transfer
52     /// @param data Additional data with no specified format, sent in call to `_to`
53     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
54 
55     /// @notice Transfers the ownership of an NFT from one address to another address
56     /// @dev This works identically to the other function with an extra data parameter,
57     ///  except this function just sets data to "".
58     /// @param _from The current owner of the NFT
59     /// @param _to The new owner
60     /// @param _tokenId The NFT to transfer
61     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
62 
63     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
64     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
65     ///  THEY MAY BE PERMANENTLY LOST
66     /// @dev Throws unless `msg.sender` is the current owner, an authorized
67     ///  operator, or the approved address for this NFT. Throws if `_from` is
68     ///  not the current owner. Throws if `_to` is the zero address. Throws if
69     ///  `_tokenId` is not a valid NFT.
70     /// @param _from The current owner of the NFT
71     /// @param _to The new owner
72     /// @param _tokenId The NFT to transfer
73     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
74 
75     /// @notice Change or reaffirm the approved address for an NFT
76     /// @dev The zero address indicates there is no approved address.
77     ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
78     ///  operator of the current owner.
79     /// @param _approved The new approved NFT controller
80     /// @param _tokenId The NFT to approve
81     function approve(address _approved, uint256 _tokenId) external payable;
82 
83     /// @notice Enable or disable approval for a third party ("operator") to manage
84     ///  all of `msg.sender`'s assets
85     /// @dev Emits the ApprovalForAll event. The contract MUST allow
86     ///  multiple operators per owner.
87     /// @param _operator Address to add to the set of authorized operators
88     /// @param _approved True if the operator is approved, false to revoke approval
89     function setApprovalForAll(address _operator, bool _approved) external;
90 
91     /// @notice Get the approved address for a single NFT
92     /// @dev Throws if `_tokenId` is not a valid NFT.
93     /// @param _tokenId The NFT to find the approved address for
94     /// @return The approved address for this NFT, or the zero address if there is none
95     function getApproved(uint256 _tokenId) external view returns (address);
96 
97     /// @notice Query if an address is an authorized operator for another address
98     /// @param _owner The address that owns the NFTs
99     /// @param _operator The address that acts on behalf of the owner
100     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
101     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
102 }
103 
104 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
105 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
106 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f.
107 interface ERC721Metadata /* is ERC721 */ {
108     /// @notice A descriptive name for a collection of NFTs in this contract
109     function name() external view returns (string _name);
110 
111     /// @notice An abbreviated name for NFTs in this contract
112     function symbol() external view returns (string _symbol);
113 
114     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
115     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
116     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
117     ///  Metadata JSON Schema".
118     function tokenURI(uint256 _tokenId) external view returns (string);
119 }
120 
121 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
122 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
123 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
124 interface ERC721Enumerable /* is ERC721 */ {
125     /// @notice Count NFTs tracked by this contract
126     /// @return A count of valid NFTs tracked by this contract, where each one of
127     ///  them has an assigned and queryable owner not equal to the zero address
128     function totalSupply() external view returns (uint256);
129 
130     /// @notice Enumerate valid NFTs
131     /// @dev Throws if `_index` >= `totalSupply()`.
132     /// @param _index A counter less than `totalSupply()`
133     /// @return The token identifier for the `_index`th NFT,
134     ///  (sort order not specified)
135     function tokenByIndex(uint256 _index) external view returns (uint256);
136 
137     /// @notice Enumerate NFTs assigned to an owner
138     /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
139     ///  `_owner` is the zero address, representing invalid NFTs.
140     /// @param _owner An address where we are interested in NFTs owned by them
141     /// @param _index A counter less than `balanceOf(_owner)`
142     /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
143     ///   (sort order not specified)
144     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
145 }
146 
147 /// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
148 interface ERC721TokenReceiver {
149     /// @notice Handle the receipt of an NFT
150     /// @dev The ERC721 smart contract calls this function on the recipient
151     ///  after a `transfer`. This function MAY throw to revert and reject the
152     ///  transfer. Return of other than the magic value MUST result in the
153     ///  transaction being reverted.
154     ///  Note: the contract address is always the message sender.
155     /// @param _operator The address which called `safeTransferFrom` function
156     /// @param _from The address which previously owned the token
157     /// @param _tokenId The NFT identifier which is being transferred
158     /// @param _data Additional data with no specified format
159     /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
160     ///  unless throwing
161     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
162 }
163 
164 interface ERC165 {
165     /// @notice Query if a contract implements an interface
166     /// @param interfaceID The interface identifier, as specified in ERC-165
167     /// @dev Interface identification is specified in ERC-165. This function
168     ///  uses less than 30,000 gas.
169     /// @return `true` if the contract implements `interfaceID` and
170     ///  `interfaceID` is not 0xffffffff, `false` otherwise
171     function supportsInterface(bytes4 interfaceID) external view returns (bool);
172 }
173 
174 /// @title Auction Core
175 /// @dev Contains models, variables, and internal methods for the auction.
176 contract TimeAuctionBase {
177 
178     // Represents an auction on an NFT
179     struct Auction {
180         // Current owner of NFT
181         address seller;
182         // Price (in wei) at beginning of auction
183         uint128 startingPrice;
184         // Price (in wei) at end of auction
185         uint128 endingPrice;
186         // Duration (in seconds) of auction
187         uint64 duration;
188         // Time when auction started
189         // NOTE: 0 if this auction has been concluded
190         uint64 startedAt;
191     }
192 
193     // Reference to contract tracking NFT ownership
194     ERC721 public nonFungibleContract;
195 
196     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
197     // Values 0-10,000 map to 0%-100%
198     uint256 public ownerCut;
199 
200     // Map from token ID to their corresponding auction.
201     mapping (uint256 => Auction) tokenIdToAuction;
202 
203     event AuctionCreated(uint256 tokenId, address seller, uint256 startingPrice, uint256 endingPrice, uint256 duration);
204     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
205     event AuctionCancelled(uint256 tokenId);
206     event AuctionSettled(uint256 tokenId, uint256 price, uint256 sellerProceeds, address seller, address buyer);
207     event AuctionRepriced(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint64 duration, uint64 startedAt);
208 
209     /// @dev DON'T give me your money.
210     function() external {}
211 
212     // Modifiers to check that inputs can be safely stored with a certain
213     // number of bits. We use constants and multiple modifiers to save gas.
214     modifier canBeStoredWith32Bits(uint256 _value) {
215         require(_value <= 4294967295);
216         _;
217     }
218 
219     // Modifiers to check that inputs can be safely stored with a certain
220     // number of bits. We use constants and multiple modifiers to save gas.
221     modifier canBeStoredWith64Bits(uint256 _value) {
222         require(_value <= 18446744073709551615);
223         _;
224     }
225 
226     modifier canBeStoredWith128Bits(uint256 _value) {
227         require(_value < 340282366920938463463374607431768211455);
228         _;
229     }
230 
231     /// @dev Returns true if the claimant owns the token.
232     /// @param _claimant - Address claiming to own the token.
233     /// @param _tokenId - ID of token whose ownership to verify.
234     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
235         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
236     }
237 
238     /// @dev Escrows the NFT, assigning ownership to this contract.
239     /// Throws if the escrow fails.
240     /// @param _owner - Current owner address of token to escrow.
241     /// @param _tokenId - ID of token whose approval to verify.
242     function _escrow(address _owner, uint256 _tokenId) internal {
243         // it will throw if transfer fails
244         nonFungibleContract.transferFrom(_owner, this, _tokenId);
245     }
246 
247     /// @dev Transfers an NFT owned by this contract to another address.
248     /// Returns true if the transfer succeeds.
249     /// @param _receiver - Address to transfer NFT to.
250     /// @param _tokenId - ID of token to transfer.
251     function _transfer(address _receiver, uint256 _tokenId) internal {
252         // it will throw if transfer fails
253         nonFungibleContract.approve(_receiver, _tokenId);
254         nonFungibleContract.transferFrom(address(this), _receiver, _tokenId);
255     }
256 
257     /// @dev Adds an auction to the list of open auctions. Also fires the
258     ///  AuctionCreated event.
259     /// @param _tokenId The ID of the token to be put on auction.
260     /// @param _auction Auction to add.
261     function _addAuction(uint256 _tokenId, Auction _auction) internal {
262         // Require that all auctions have a duration of
263         // at least one minute. (Keeps our math from getting hairy!)
264         require(_auction.duration >= 1 minutes);
265 
266         tokenIdToAuction[_tokenId] = _auction;
267 
268         emit AuctionCreated(
269             uint256(_tokenId),
270             address(_auction.seller),
271             uint256(_auction.startingPrice),
272             uint256(_auction.endingPrice),
273             uint256(_auction.duration)
274         );
275     }
276 
277     /// @dev Cancels an auction unconditionally.
278     function _cancelAuction(uint256 _tokenId, address _seller) internal {
279         _removeAuction(_tokenId);
280         _transfer(_seller, _tokenId);
281         emit AuctionCancelled(_tokenId);
282     }
283 
284     /// @dev Computes the price and transfers winnings.
285     /// Does NOT transfer ownership of token.
286     function _bid(uint256 _tokenId, uint256 _bidAmount)
287         internal
288         returns (uint256)
289     {
290         // Get a reference to the auction struct
291         Auction storage auction = tokenIdToAuction[_tokenId];
292 
293         // Explicitly check that this auction is currently live.
294         // (Because of how Ethereum mappings work, we can't just count
295         // on the lookup above failing. An invalid _tokenId will just
296         // return an auction object that is all zeros.)
297         require(_isOnAuction(auction));
298 
299         // Check that the incoming bid is higher than the current
300         // price
301         uint256 price = _currentPrice(auction);
302         require(_bidAmount >= price);
303 
304         // Grab a reference to the seller before the auction struct
305         // gets deleted.
306         address seller = auction.seller;
307 
308         // The bid is good! Remove the auction before sending the fees
309         // to the sender so we can't have a reentrancy attack.
310         _removeAuction(_tokenId);
311 
312         // Transfer proceeds to seller (if there are any!)
313         if (price > 0) {
314             //  Calculate the auctioneer's cut.
315             // (NOTE: _computeCut() is guaranteed to return a
316             //  value <= price, so this subtraction can't go negative.)
317             uint256 auctioneerCut = _computeCut(price);
318             uint256 sellerProceeds = price - auctioneerCut;
319 
320             // NOTE: Doing a transfer() in the middle of a complex
321             // method like this is generally discouraged because of
322             // reentrancy attacks and DoS attacks if the seller is
323             // a contract with an invalid fallback function. We explicitly
324             // guard against reentrancy attacks by removing the auction
325             // before calling transfer(), and the only thing the seller
326             // can DoS is the sale of their own asset! (And if it's an
327             // accident, they can call cancelAuction(). )
328             seller.transfer(sellerProceeds);
329             emit AuctionSettled(_tokenId, price, sellerProceeds, seller, msg.sender);
330         }
331 
332         // Tell the world!
333         emit AuctionSuccessful(_tokenId, price, msg.sender);
334 
335         return price;
336     }
337 
338     /// @dev Removes an auction from the list of open auctions.
339     /// @param _tokenId - ID of NFT on auction.
340     function _removeAuction(uint256 _tokenId) internal {
341         delete tokenIdToAuction[_tokenId];
342     }
343 
344     /// @dev Returns true if the NFT is on auction.
345     /// @param _auction - Auction to check.
346     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
347         return (_auction.startedAt > 0);
348     }
349 
350     /// @dev Returns current price of an NFT on auction. Broken into two
351     ///  functions (this one, that computes the duration from the auction
352     ///  structure, and the other that does the price computation) so we
353     ///  can easily test that the price computation works correctly.
354     function _currentPrice(Auction storage _auction)
355         internal
356         view
357         returns (uint256)
358     {
359         uint256 secondsPassed = 0;
360 
361         // A bit of insurance against negative values (or wraparound).
362         // Probably not necessary (since Ethereum guarnatees that the
363         // now variable doesn't ever go backwards).
364         if (now > _auction.startedAt) {
365             secondsPassed = now - _auction.startedAt;
366         }
367 
368         return _computeCurrentPrice(
369             _auction.startingPrice,
370             _auction.endingPrice,
371             _auction.duration,
372             secondsPassed
373         );
374     }
375 
376     /// @dev Computes the current price of an auction. Factored out
377     ///  from _currentPrice so we can run extensive unit tests.
378     ///  When testing, make this function public and turn on
379     ///  `Current price computation` test suite.
380     function _computeCurrentPrice(
381         uint256 _startingPrice,
382         uint256 _endingPrice,
383         uint256 _duration,
384         uint256 _secondsPassed
385     )
386         internal
387         pure
388         returns (uint256)
389     {
390         // NOTE: We don't use SafeMath (or similar) in this function because
391         //  all of our public functions carefully cap the maximum values for
392         //  time (at 64-bits) and currency (at 128-bits). _duration is
393         //  also known to be non-zero (see the require() statement in
394         //  _addAuction())
395         if (_secondsPassed >= _duration) {
396             // We've reached the end of the dynamic pricing portion
397             // of the auction, just return the end price.
398             return _endingPrice;
399         } else {
400             // Starting price can be higher than ending price (and often is!), so
401             // this delta can be negative.
402             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
403 
404             // This multiplication can't overflow, _secondsPassed will easily fit within
405             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
406             // will always fit within 256-bits.
407             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
408 
409             // currentPriceChange can be negative, but if so, will have a magnitude
410             // less that _startingPrice. Thus, this result will always end up positive.
411             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
412 
413             return uint256(currentPrice);
414         }
415     }
416 
417     /// @dev Computes owner's cut of a sale.
418     /// @param _price - Sale price of NFT.
419     function _computeCut(uint256 _price) internal view returns (uint256) {
420         // NOTE: We don't use SafeMath (or similar) in this function because
421         //  all of our entry functions carefully cap the maximum values for
422         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
423         //  statement in the TimeAuction constructor). The result of this
424         //  function is always guaranteed to be <= _price.
425         return _price * ownerCut / 10000;
426     }
427 
428 }
429 
430 /**
431  * @title Ownable
432  * @dev The Ownable contract has an owner address, and provides basic authorization control
433  * functions, this simplifies the implementation of "user permissions".
434  */
435 contract Ownable {
436   address public owner;
437 
438   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440   /**
441    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
442    * account.
443    */
444   constructor() public {
445     owner = msg.sender;
446   }
447 
448   /**
449    * @dev Throws if called by any account other than the owner.
450    */
451   modifier onlyOwner() {
452     require(msg.sender == owner);
453     _;
454   }
455 
456   /**
457    * @dev Allows the current owner to transfer control of the contract to a newOwner.
458    * @param newOwner The address to transfer ownership to.
459    */
460   function transferOwnership(address newOwner) public onlyOwner {
461     require(newOwner != address(0));
462     emit OwnershipTransferred(owner, newOwner);
463     owner = newOwner;
464   }
465 
466 }
467 
468 /**
469  * @title Pausable
470  * @dev Base contract which allows children to implement an emergency stop mechanism.
471  */
472 contract Pausable is Ownable {
473   event Pause();
474   event Unpause();
475 
476   bool public paused = false;
477 
478   /**
479    * @dev Modifier to make a function callable only when the contract is not paused.
480    */
481   modifier whenNotPaused() {
482     require(!paused);
483     _;
484   }
485 
486   /**
487    * @dev Modifier to make a function callable only when the contract is paused.
488    */
489   modifier whenPaused() {
490     require(paused);
491     _;
492   }
493 
494   /**
495    * @dev called by the owner to pause, triggers stopped state
496    */
497   function pause() onlyOwner whenNotPaused public {
498     paused = true;
499     emit Pause();
500   }
501 
502   /**
503    * @dev called by the owner to unpause, returns to normal state
504    */
505   function unpause() onlyOwner whenPaused public {
506     paused = false;
507     emit Unpause();
508   }
509 }
510 
511 /// @title Clock auction for non-fungible tokens.
512 contract TimeAuction is Pausable, TimeAuctionBase {
513 
514     /// @dev Constructor creates a reference to the NFT ownership contract
515     ///  and verifies the owner cut is in the valid range.
516     /// @param _nftAddress - address of a deployed contract implementing
517     ///  the Nonfungible Interface.
518     /// @param _cut - 100*(percent cut) the owner takes on each auction, must be
519     ///  between 0-10,000.
520     constructor(address _nftAddress, uint256 _cut) public {
521         require(_cut <= 10000);
522         ownerCut = _cut;
523 
524         ERC721 candidateContract = ERC721(_nftAddress);
525         nonFungibleContract = candidateContract;
526     }
527 
528     /// @dev Remove all Ether from the contract, which is the owner's cuts
529     ///  as well as any Ether sent directly to the contract address.
530     ///  Always transfers to the NFT contract, and can only be called from
531     ///  the NFT contract.
532     function withdrawBalance() external {
533         address nftAddress = address(nonFungibleContract);
534         require(msg.sender == nftAddress);
535         nftAddress.transfer(address(this).balance);
536     }
537 
538     /// @dev Creates and begins a new auction.
539     /// @param _tokenId - ID of token to auction, sender must be owner.
540     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
541     /// @param _endingPrice - Price of item (in wei) at end of auction.
542     /// @param _duration - Length of time to move between starting
543     ///  price and ending price (in seconds).
544     /// @param _seller - Seller, if not the message sender
545     function createAuction(
546         uint256 _tokenId,
547         uint256 _startingPrice,
548         uint256 _endingPrice,
549         uint256 _duration,
550         address _seller
551     )
552         public
553         whenNotPaused
554         canBeStoredWith128Bits(_startingPrice)
555         canBeStoredWith128Bits(_endingPrice)
556         canBeStoredWith64Bits(_duration)
557     {
558         require(_owns(msg.sender, _tokenId));
559         _escrow(msg.sender, _tokenId);
560         Auction memory auction = Auction(
561             _seller,
562             uint128(_startingPrice),
563             uint128(_endingPrice),
564             uint64(_duration),
565             uint64(now)
566         );
567         _addAuction(_tokenId, auction);
568     }
569 
570     /// @dev Bids on an open auction, completing the auction and transferring
571     ///  ownership of the NFT if enough Ether is supplied.
572     /// @param _tokenId - ID of token to bid on.
573     function bid(uint256 _tokenId)
574         public
575         payable
576         whenNotPaused
577     {
578         // _bid will throw if the bid or funds transfer fails
579         _bid(_tokenId, msg.value);
580         _transfer(msg.sender, _tokenId);
581     }
582 
583     /// @dev Cancels an auction that hasn't been won yet.
584     ///  Returns the NFT to original owner.
585     /// @notice This is a state-modifying function that can
586     ///  be called while the contract is paused. An auction can
587     ///  only be cancelled by the seller.
588     /// @param _tokenId - ID of token on auction
589     function cancelAuction(uint256 _tokenId)
590         public
591     {
592         Auction storage auction = tokenIdToAuction[_tokenId];
593         require(_isOnAuction(auction));
594         address seller = auction.seller;
595         require(msg.sender == seller);
596         _cancelAuction(_tokenId, seller);
597     }
598 
599     /// @dev Cancels an auction when the contract is paused.
600     ///  Only the owner (account that created the contract)
601     ///  may do this, and NFTs are returned to
602     ///  the seller. This should only be used in emergencies.
603     /// @param _tokenId - ID of the NFT on auction to cancel.
604     function cancelAuctionWhenPaused(uint256 _tokenId)
605         whenPaused
606         onlyOwner
607         public
608     {
609         Auction storage auction = tokenIdToAuction[_tokenId];
610         require(_isOnAuction(auction));
611         _cancelAuction(_tokenId, auction.seller);
612     }
613 
614     /// @dev Returns auction info for an NFT on auction.
615     /// @param _tokenId - ID of NFT on auction.
616     function getAuction(uint256 _tokenId)
617         public
618         view
619         returns
620     (
621         address seller,
622         uint256 startingPrice,
623         uint256 endingPrice,
624         uint256 currentPrice,
625         uint256 duration,
626         uint256 startedAt
627     ) {
628         Auction storage auction = tokenIdToAuction[_tokenId];
629         require(_isOnAuction(auction));
630         uint256 price = _currentPrice(auction);
631         return (
632             auction.seller,
633             auction.startingPrice,
634             auction.endingPrice,
635             price,
636             auction.duration,
637             auction.startedAt
638         );
639     }
640 
641     /// @dev Returns current auction prices for up to 50 auctions
642     /// @param _tokenIds - up to 50 IDs of NFT on auction that we want the prices of
643     function getCurrentAuctionPrices(uint128[] _tokenIds) public view returns (uint128[50]) {
644 
645         require (_tokenIds.length <= 50);
646 
647         /// @dev A fixed array we can return current auction price information in.
648         uint128[50] memory currentPricesArray;
649 
650         for (uint8 i = 0; i < _tokenIds.length; i++) {
651           Auction storage auction = tokenIdToAuction[_tokenIds[i]];
652           if (_isOnAuction(auction)) {
653             uint256 price = _currentPrice(auction);
654             currentPricesArray[i] = uint128(price);
655           }
656         }
657 
658         return currentPricesArray;
659     }
660 
661     /// @dev Returns the current price of an auction.
662     /// @param _tokenId - ID of the token price we are checking.
663     function getCurrentPrice(uint256 _tokenId)
664         public
665         view
666         returns (uint256)
667     {
668         Auction storage auction = tokenIdToAuction[_tokenId];
669         require(_isOnAuction(auction));
670         return _currentPrice(auction);
671     }
672 
673 }
674 
675 /// @title Interface to allow a contract to listen to auction events.
676 contract SaleClockAuctionListener {
677     function implementsSaleClockAuctionListener() public pure returns (bool);
678     function auctionCreated(uint256 tokenId, address seller, uint128 startingPrice, uint128 endingPrice, uint64 duration) public;
679     function auctionSuccessful(uint256 tokenId, uint128 totalPrice, address seller, address buyer) public;
680     function auctionCancelled(uint256 tokenId, address seller) public;
681 }
682 
683 /// @title Clock auction modified for sale of kitties
684 contract SaleClockAuction is TimeAuction {
685 
686     // @dev A listening contract that wants notifications of auction creation,
687     //  completion, and cancellation
688     SaleClockAuctionListener public listener;
689 
690     // Delegate constructor
691     constructor(address _nftAddr, uint256 _cut) public TimeAuction(_nftAddr, _cut) {
692 
693     }
694 
695     /// @dev Sanity check that allows us to ensure that we are pointing to the
696     ///  right auction in our setSaleAuctionAddress() call.
697     function isSaleClockAuction() public pure returns (bool) {
698         return true;
699     }
700 
701     // @dev Method used to add a listener for auction events. This can only be called
702     //  if the listener has not already been set (i.e. once). This limitation is in place to prevent
703     //  malicious attempt to hijack the listening contract and perhaps try to do
704     //  something bad (like throw). Since the listener methods are called inline with our
705     //  createAuction(...), bid(...), and cancelAuction(...) methods, we need to make
706     //  sure none of the listener methods causes a revert/throw/out of gas/etc.
707     // @param _listener - Address of a SaleClockAuctionListener compatible contract
708     function setListener(address _listener) public {
709       require(listener == address(0));
710       SaleClockAuctionListener candidateContract = SaleClockAuctionListener(_listener);
711       require(candidateContract.implementsSaleClockAuctionListener());
712       listener = candidateContract;
713     }
714 
715     /// @dev Creates and begins a new auction. We override the base class
716     ///   so we can add the listener capability.
717     ///
718     /// CALLABLE ONLY BY NFT CONTRACT
719     ///
720     /// @param _tokenId - ID of token to auction, sender must be owner.
721     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
722     /// @param _endingPrice - Price of item (in wei) at end of auction.
723     /// @param _duration - Length of auction (in seconds).
724     /// @param _seller - Seller, if not the message sender
725     function createAuction(
726         uint256 _tokenId,
727         uint256 _startingPrice,
728         uint256 _endingPrice,
729         uint256 _duration,
730         address _seller
731     )
732         public
733         canBeStoredWith128Bits(_startingPrice)
734         canBeStoredWith128Bits(_endingPrice)
735         canBeStoredWith64Bits(_duration)
736     {
737         require(msg.sender == address(nonFungibleContract));
738         _escrow(_seller, _tokenId);
739         Auction memory auction = Auction(
740             _seller,
741             uint128(_startingPrice),
742             uint128(_endingPrice),
743             uint64(_duration),
744             uint64(now)
745         );
746         _addAuction(_tokenId, auction);
747 
748         if (listener != address(0)) {
749           listener.auctionCreated(_tokenId, _seller, uint128(_startingPrice), uint128(_endingPrice), uint64(_duration));
750         }
751     }
752 
753     /// @dev Reprices (and updates duration) of an array of tokens that are currently
754     /// being auctioned by this contract.
755     ///
756     /// CALLABLE ONLY BY NFT CONTRACT
757     ///
758     /// @param _tokenIds Array of tokenIds corresponding to auctions being updated
759     /// @param _startingPrices New starting prices
760     /// @param _endingPrices New ending prices
761     /// @param _duration New duration
762     /// @param _seller Address of the seller in all specified auctions to be updated
763     function repriceAuctions(
764         uint256[] _tokenIds,
765         uint256[] _startingPrices,
766         uint256[] _endingPrices,
767         uint256 _duration,
768         address _seller
769     )
770     public
771     canBeStoredWith64Bits(_duration)
772     {
773         require(msg.sender == address(nonFungibleContract));
774 
775         uint64 timeNow = uint64(now);
776         for (uint32 i = 0; i < _tokenIds.length; i++) {
777             uint256 _tokenId = _tokenIds[i];
778             uint256 _startingPrice = _startingPrices[i];
779             uint256 _endingPrice = _endingPrices[i];
780 
781             // Must be able to be stored in 128 bits
782             require(_startingPrice < 340282366920938463463374607431768211455);
783             require(_endingPrice < 340282366920938463463374607431768211455);
784 
785             Auction storage auction = tokenIdToAuction[_tokenId];
786 
787             // Here is where we make sure the seller in the auction is correct.
788             // Since this method can only be called by the NFT, the NFT controls
789             // what happens here by passing in the _seller we are to require.
790             if (auction.seller == _seller) {
791                 // Update the auction parameters
792                 auction.startingPrice = uint128(_startingPrice);
793                 auction.endingPrice = uint128(_endingPrice);
794                 auction.duration = uint64(_duration);
795                 auction.startedAt = timeNow;
796                 emit AuctionRepriced(_tokenId, _startingPrice, _endingPrice, uint64(_duration), timeNow);
797             }
798         }
799     }
800 
801     /// @dev Place a bid to purchase multiple tokens in a single call.
802     /// @param _tokenIds Array of IDs of tokens to bid on.
803     function batchBid(uint256[] _tokenIds) public payable whenNotPaused
804     {
805         // Check to make sure the bid amount is sufficient to purchase
806         // all of the auctions specified.
807         uint256 totalPrice = 0;
808         for (uint32 i = 0; i < _tokenIds.length; i++) {
809           uint256 _tokenId = _tokenIds[i];
810           Auction storage auction = tokenIdToAuction[_tokenId];
811           totalPrice += _currentPrice(auction);
812         }
813         require(msg.value >= totalPrice);
814 
815         // Loop through auctions, placing bids to buy
816         //
817         for (i = 0; i < _tokenIds.length; i++) {
818 
819           _tokenId = _tokenIds[i];
820           auction = tokenIdToAuction[_tokenId];
821 
822           // Need to store this before the _bid & _transfer calls
823           // so we can fire our auctionSuccessful events
824           address seller = auction.seller;
825 
826           uint256 bid = _currentPrice(auction);
827           uint256 price = _bid(_tokenId, bid);
828           _transfer(msg.sender, _tokenId);
829 
830           if (listener != address(0)) {
831             listener.auctionSuccessful(_tokenId, uint128(price), seller, msg.sender);
832           }
833         }
834     }
835 
836     /// @dev Does exactly what the parent does, but also notifies any
837     ///   listener of the successful bid.
838     /// @param _tokenId - ID of token to bid on.
839     function bid(uint256 _tokenId) public payable whenNotPaused
840     {
841         Auction storage auction = tokenIdToAuction[_tokenId];
842 
843         // Need to store this before the _bid & _transfer calls
844         // so we can fire our auctionSuccessful events
845         address seller = auction.seller;
846 
847         // _bid will throw if the bid or funds transfer fails
848         uint256 price = _bid(_tokenId, msg.value);
849         _transfer(msg.sender, _tokenId);
850 
851         if (listener != address(0)) {
852           listener.auctionSuccessful(_tokenId, uint128(price), seller, msg.sender);
853         }
854     }
855 
856     /// @dev Cancels an auction that hasn't been won yet by calling
857     ///   the super(...) and then notifying any listener.
858     /// @param _tokenId - ID of token on auction
859     function cancelAuction(uint256 _tokenId) public
860     {
861       super.cancelAuction(_tokenId);
862       if (listener != address(0)) {
863         listener.auctionCancelled(_tokenId, msg.sender);
864       }
865     }
866 
867 }