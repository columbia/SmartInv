1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title ERC721 interface
50  * @dev see https://github.com/ethereum/eips/issues/721
51  */
52 contract ERC721 {
53   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
54   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
55 
56   function balanceOf(address _owner) public view returns (uint256 _balance);
57   function ownerOf(uint256 _tokenId) public view returns (address _owner);
58   function transfer(address _to, uint256 _tokenId) public;
59   function approve(address _to, uint256 _tokenId) public;
60   function takeOwnership(uint256 _tokenId) public;
61 }
62 
63 /**
64  * @title ERC721Token
65  * Generic implementation for the required functionality of the ERC721 standard
66  */
67 contract ERC721Token is ERC721 {
68   using SafeMath for uint256;
69 
70   // Total amount of tokens
71   uint256 internal totalTokens;
72 
73   // Mapping from token ID to owner
74   mapping (uint256 => address) internal tokenOwner;
75 
76   // Mapping from token ID to approved address
77   mapping (uint256 => address) internal tokenApprovals;
78 
79   // Mapping from owner to list of owned token IDs
80   mapping (address => uint256[]) internal ownedTokens;
81 
82   // Mapping from token ID to index of the owner tokens list
83   mapping(uint256 => uint256) internal ownedTokensIndex;
84 
85   /**
86   * @dev Guarantees msg.sender is owner of the given token
87   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
88   */
89   modifier onlyOwnerOf(uint256 _tokenId) {
90     require(ownerOf(_tokenId) == msg.sender);
91     _;
92   }
93 
94   /**
95   * @dev Gets the total amount of tokens stored by the contract
96   * @return uint256 representing the total amount of tokens
97   */
98   function totalSupply() public view returns (uint256) {
99     return totalTokens;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address
104   * @param _owner address to query the balance of
105   * @return uint256 representing the amount owned by the passed address
106   */
107   function balanceOf(address _owner) public view returns (uint256) {
108     return ownedTokens[_owner].length;
109   }
110 
111   /**
112   * @dev Gets the list of tokens owned by a given address
113   * @param _owner address to query the tokens of
114   * @return uint256[] representing the list of tokens owned by the passed address
115   */
116   function tokensOf(address _owner) public view returns (uint256[]) {
117     return ownedTokens[_owner];
118   }
119 
120   /**
121   * @dev Gets the owner of the specified token ID
122   * @param _tokenId uint256 ID of the token to query the owner of
123   * @return owner address currently marked as the owner of the given token ID
124   */
125   function ownerOf(uint256 _tokenId) public view returns (address) {
126     address owner = tokenOwner[_tokenId];
127     require(owner != address(0));
128     return owner;
129   }
130 
131   /**
132    * @dev Gets the approved address to take ownership of a given token ID
133    * @param _tokenId uint256 ID of the token to query the approval of
134    * @return address currently approved to take ownership of the given token ID
135    */
136   function approvedFor(uint256 _tokenId) public view returns (address) {
137     return tokenApprovals[_tokenId];
138   }
139 
140   /**
141   * @dev Transfers the ownership of a given token ID to another address
142   * @param _to address to receive the ownership of the given token ID
143   * @param _tokenId uint256 ID of the token to be transferred
144   */
145   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
146     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
147   }
148 
149   /**
150   * @dev Approves another address to claim for the ownership of the given token ID
151   * @param _to address to be approved for the given token ID
152   * @param _tokenId uint256 ID of the token to be approved
153   */
154   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
155     address owner = ownerOf(_tokenId);
156     require(_to != owner);
157     if (approvedFor(_tokenId) != 0 || _to != 0) {
158       tokenApprovals[_tokenId] = _to;
159       Approval(owner, _to, _tokenId);
160     }
161   }
162 
163   /**
164   * @dev Claims the ownership of a given token ID
165   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
166   */
167   function takeOwnership(uint256 _tokenId) public {
168     require(isApprovedFor(msg.sender, _tokenId));
169     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
170   }
171 
172   /**
173   * @dev Mint token function
174   * @param _to The address that will own the minted token
175   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
176   */
177   function _mint(address _to, uint256 _tokenId) internal {
178     require(_to != address(0));
179     addToken(_to, _tokenId);
180     Transfer(0x0, _to, _tokenId);
181   }
182 
183   /**
184   * @dev Burns a specific token
185   * @param _tokenId uint256 ID of the token being burned by the msg.sender
186   */
187   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
188     if (approvedFor(_tokenId) != 0) {
189       clearApproval(msg.sender, _tokenId);
190     }
191     removeToken(msg.sender, _tokenId);
192     Transfer(msg.sender, 0x0, _tokenId);
193   }
194 
195   /**
196    * @dev Tells whether the msg.sender is approved for the given token ID or not
197    * This function is not private so it can be extended in further implementations like the operatable ERC721
198    * @param _owner address of the owner to query the approval of
199    * @param _tokenId uint256 ID of the token to query the approval of
200    * @return bool whether the msg.sender is approved for the given token ID or not
201    */
202   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
203     return approvedFor(_tokenId) == _owner;
204   }
205 
206   /**
207   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
208   * @param _from address which you want to send tokens from
209   * @param _to address which you want to transfer the token to
210   * @param _tokenId uint256 ID of the token to be transferred
211   */
212   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
213     require(_to != address(0));
214     require(_to != ownerOf(_tokenId));
215     require(ownerOf(_tokenId) == _from);
216 
217     clearApproval(_from, _tokenId);
218     removeToken(_from, _tokenId);
219     addToken(_to, _tokenId);
220     Transfer(_from, _to, _tokenId);
221   }
222 
223   /**
224   * @dev Internal function to clear current approval of a given token ID
225   * @param _tokenId uint256 ID of the token to be transferred
226   */
227   function clearApproval(address _owner, uint256 _tokenId) private {
228     require(ownerOf(_tokenId) == _owner);
229     tokenApprovals[_tokenId] = 0;
230     Approval(_owner, 0, _tokenId);
231   }
232 
233   /**
234   * @dev Internal function to add a token ID to the list of a given address
235   * @param _to address representing the new owner of the given token ID
236   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
237   */
238   function addToken(address _to, uint256 _tokenId) private {
239     require(tokenOwner[_tokenId] == address(0));
240     tokenOwner[_tokenId] = _to;
241     uint256 length = balanceOf(_to);
242     ownedTokens[_to].push(_tokenId);
243     ownedTokensIndex[_tokenId] = length;
244     totalTokens = totalTokens.add(1);
245   }
246 
247   /**
248   * @dev Internal function to remove a token ID from the list of a given address
249   * @param _from address representing the previous owner of the given token ID
250   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
251   */
252   function removeToken(address _from, uint256 _tokenId) private {
253     require(ownerOf(_tokenId) == _from);
254 
255     uint256 tokenIndex = ownedTokensIndex[_tokenId];
256     uint256 lastTokenIndex = balanceOf(_from).sub(1);
257     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
258 
259     tokenOwner[_tokenId] = 0;
260     ownedTokens[_from][tokenIndex] = lastToken;
261     ownedTokens[_from][lastTokenIndex] = 0;
262     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
263     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
264     // the lastToken to the first position, and then dropping the element placed in the last position of the list
265 
266     ownedTokens[_from].length--;
267     ownedTokensIndex[_tokenId] = 0;
268     ownedTokensIndex[lastToken] = tokenIndex;
269     totalTokens = totalTokens.sub(1);
270   }
271 }
272 
273 
274 contract AuctionHouse {
275     address owner;
276 
277     function AuctionHouse() {
278         owner = msg.sender;
279     }
280 
281     // Represents an auction on an NFT
282     struct Auction {
283         // Current owner of NFT
284         address seller;
285         // Price (in wei) at beginning of auction
286         uint128 startingPrice;
287         // Price (in wei) at end of auction
288         uint128 endingPrice;
289         // Duration (in seconds) of auction
290         uint64 duration;
291         // Time when auction started
292         // NOTE: 0 if this auction has been concluded
293         uint64 startedAt;
294     }
295 
296     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
297     // Values 0-10,000 map to 0%-100%
298     uint256 public ownerCut = 375; // Default is 3.75%
299 
300     // Map from token ID to their corresponding auction.
301     mapping (address => mapping (uint256 => Auction)) tokenIdToAuction;
302 
303     // Allowed tokens
304     mapping (address => bool) supportedTokens;
305 
306     event AuctionCreated(address indexed tokenAddress, uint256 indexed tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration, address seller);
307     event AuctionSuccessful(address indexed tokenAddress, uint256 indexed tokenId, uint256 totalPrice, address winner);
308     event AuctionCancelled(address indexed tokenAddress, uint256 indexed tokenId, address seller);
309 
310     // Admin
311 
312     // Change owner of the contract
313     function changeOwner(address newOwner) external {
314         require(msg.sender == owner);
315         owner = newOwner;
316     }
317 
318     // Add or remove supported tokens
319     function setSupportedToken(address tokenAddress, bool supported) external {
320         require(msg.sender == owner);
321         supportedTokens[tokenAddress] = supported;
322     }
323 
324     // Set the owner cut for auctions
325     function setOwnerCut(uint256 cut) external {
326         require(msg.sender == owner);
327         require(cut <= 10000);
328         ownerCut = cut;
329     }
330 
331     // Withdraw sales fees
332     function withdraw() external {
333       require(msg.sender == owner);
334       owner.transfer(this.balance);
335     }
336 
337     /// @dev Returns true if the claimant owns the token.
338     /// @param _claimant - Address claiming to own the token.
339     /// @param _tokenId - ID of token whose ownership to verify.
340     function _owns(address _tokenAddress, address _claimant, uint256 _tokenId) internal view returns (bool) {
341         return (ERC721Token(_tokenAddress).ownerOf(_tokenId) == _claimant);
342     }
343 
344     /// @dev Escrows the NFT, assigning ownership to this contract.
345     /// Throws if the escrow fails.
346     /// @param _tokenId - ID of token whose approval to verify.
347     function _escrow(address _tokenAddress, uint256 _tokenId) internal {
348         // it will throw if transfer fails
349         ERC721Token token = ERC721Token(_tokenAddress);
350         if (token.ownerOf(_tokenId) != address(this)) {
351           token.takeOwnership(_tokenId);
352         }
353     }
354 
355     /// @dev Transfers an NFT owned by this contract to another address.
356     /// Returns true if the transfer succeeds.
357     /// @param _receiver - Address to transfer NFT to.
358     /// @param _tokenId - ID of token to transfer.
359     function _transfer(address _tokenAddress, address _receiver, uint256 _tokenId) internal {
360         // it will throw if transfer fails
361         ERC721Token(_tokenAddress).transfer(_receiver, _tokenId);
362     }
363 
364     /// @dev Adds an auction to the list of open auctions. Also fires the
365     ///  AuctionCreated event.
366     /// @param _tokenId The ID of the token to be put on auction.
367     /// @param _auction Auction to add.
368     function _addAuction(address _tokenAddress, uint256 _tokenId, Auction _auction) internal {
369         // Require that all auctions have a duration of
370         // at least one minute. (Keeps our math from getting hairy!)
371         require(_auction.duration >= 1 minutes);
372 
373         tokenIdToAuction[_tokenAddress][_tokenId] = _auction;
374 
375         AuctionCreated(
376             address(_tokenAddress),
377             uint256(_tokenId),
378             uint256(_auction.startingPrice),
379             uint256(_auction.endingPrice),
380             uint256(_auction.duration),
381             address(_auction.seller)
382         );
383     }
384 
385     /// @dev Cancels an auction unconditionally.
386     function _cancelAuction(address _tokenAddress, uint256 _tokenId, address _seller) internal {
387         _removeAuction(_tokenAddress, _tokenId);
388         _transfer(_tokenAddress, _seller, _tokenId);
389         AuctionCancelled(_tokenAddress, _tokenId, _seller);
390     }
391 
392     /// @dev Computes the price and transfers winnings.
393     /// Does NOT transfer ownership of token.
394     function _bid(address _tokenAddress, uint256 _tokenId, uint256 _bidAmount)
395         internal
396         returns (uint256)
397     {
398         // Get a reference to the auction struct
399         Auction storage auction = tokenIdToAuction[_tokenAddress][_tokenId];
400 
401         // Explicitly check that this auction is currently live.
402         // (Because of how Ethereum mappings work, we can't just count
403         // on the lookup above failing. An invalid _tokenId will just
404         // return an auction object that is all zeros.)
405         require(_isOnAuction(auction));
406 
407         // Check that the bid is greater than or equal to the current price
408         uint256 price = _currentPrice(auction);
409         require(_bidAmount >= price);
410 
411         // Grab a reference to the seller before the auction struct
412         // gets deleted.
413         address seller = auction.seller;
414 
415         // The bid is good! Remove the auction before sending the fees
416         // to the sender so we can't have a reentrancy attack.
417         _removeAuction(_tokenAddress, _tokenId);
418 
419         // Transfer proceeds to seller (if there are any!)
420         if (price > 0) {
421             // Calculate the auctioneer's cut.
422             // (NOTE: _computeCut() is guaranteed to return a
423             // value <= price, so this subtraction can't go negative.)
424             uint256 auctioneerCut = _computeCut(price);
425             uint256 sellerProceeds = price - auctioneerCut;
426 
427             // NOTE: Doing a transfer() in the middle of a complex
428             // method like this is generally discouraged because of
429             // reentrancy attacks and DoS attacks if the seller is
430             // a contract with an invalid fallback function. We explicitly
431             // guard against reentrancy attacks by removing the auction
432             // before calling transfer(), and the only thing the seller
433             // can DoS is the sale of their own asset! (And if it's an
434             // accident, they can call cancelAuction(). )
435             seller.transfer(sellerProceeds);
436         }
437 
438         // Calculate any excess funds included with the bid. If the excess
439         // is anything worth worrying about, transfer it back to bidder.
440         // NOTE: We checked above that the bid amount is greater than or
441         // equal to the price so this cannot underflow.
442         uint256 bidExcess = _bidAmount - price;
443 
444         // Return the funds. Similar to the previous transfer, this is
445         // not susceptible to a re-entry attack because the auction is
446         // removed before any transfers occur.
447         msg.sender.transfer(bidExcess);
448 
449         // Tell the world!
450         AuctionSuccessful(_tokenAddress, _tokenId, price, msg.sender);
451 
452         return price;
453     }
454 
455     /// @dev Removes an auction from the list of open auctions.
456     /// @param _tokenId - ID of NFT on auction.
457     function _removeAuction(address _tokenAddress, uint256 _tokenId) internal {
458         delete tokenIdToAuction[_tokenAddress][_tokenId];
459     }
460 
461     /// @dev Returns true if the NFT is on auction.
462     /// @param _auction - Auction to check.
463     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
464         return (_auction.startedAt > 0);
465     }
466 
467     /// @dev Returns current price of an NFT on auction. Broken into two
468     ///  functions (this one, that computes the duration from the auction
469     ///  structure, and the other that does the price computation) so we
470     ///  can easily test that the price computation works correctly.
471     function _currentPrice(Auction storage _auction)
472         internal
473         view
474         returns (uint256)
475     {
476         uint256 secondsPassed = 0;
477 
478         // A bit of insurance against negative values (or wraparound).
479         // Probably not necessary (since Ethereum guarnatees that the
480         // now variable doesn't ever go backwards).
481         if (now > _auction.startedAt) {
482             secondsPassed = now - _auction.startedAt;
483         }
484 
485         return _computeCurrentPrice(
486             _auction.startingPrice,
487             _auction.endingPrice,
488             _auction.duration,
489             secondsPassed
490         );
491     }
492 
493     /// @dev Computes the current price of an auction. Factored out
494     ///  from _currentPrice so we can run extensive unit tests.
495     ///  When testing, make this function public and turn on
496     ///  `Current price computation` test suite.
497     function _computeCurrentPrice(
498         uint256 _startingPrice,
499         uint256 _endingPrice,
500         uint256 _duration,
501         uint256 _secondsPassed
502     )
503         internal
504         pure
505         returns (uint256)
506     {
507         // NOTE: We don't use SafeMath (or similar) in this function because
508         //  all of our public functions carefully cap the maximum values for
509         //  time (at 64-bits) and currency (at 128-bits). _duration is
510         //  also known to be non-zero (see the require() statement in
511         //  _addAuction())
512         if (_secondsPassed >= _duration) {
513             // We've reached the end of the dynamic pricing portion
514             // of the auction, just return the end price.
515             return _endingPrice;
516         } else {
517             // Starting price can be higher than ending price (and often is!), so
518             // this delta can be negative.
519             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
520 
521             // This multiplication can't overflow, _secondsPassed will easily fit within
522             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
523             // will always fit within 256-bits.
524             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
525 
526             // currentPriceChange can be negative, but if so, will have a magnitude
527             // less that _startingPrice. Thus, this result will always end up positive.
528             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
529 
530             return uint256(currentPrice);
531         }
532     }
533 
534     /// @dev Computes owner's cut of a sale.
535     /// @param _price - Sale price of NFT.
536     function _computeCut(uint256 _price) internal view returns (uint256) {
537         // NOTE: We don't use SafeMath (or similar) in this function because
538         //  all of our entry functions carefully cap the maximum values for
539         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
540         //  statement in the ClockAuction constructor). The result of this
541         //  function is always guaranteed to be <= _price.
542         return _price * ownerCut / 10000;
543     }
544 
545     /// @dev Creates and begins a new auction.
546     /// @param _tokenId - ID of token to auction, sender must be owner.
547     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
548     /// @param _endingPrice - Price of item (in wei) at end of auction.
549     /// @param _duration - Length of time to move between starting
550     ///  price and ending price (in seconds).
551     /// @param _seller - Seller, if not the message sender
552     function createAuction(
553         address _tokenAddress,
554         uint256 _tokenId,
555         uint256 _startingPrice,
556         uint256 _endingPrice,
557         uint256 _duration,
558         address _seller
559     )
560         public
561     {
562         // Check this token is supported
563         require(supportedTokens[_tokenAddress]);
564 
565         // Auctions must be made by the token contract or the token owner
566         require(msg.sender == _tokenAddress || _owns(_tokenAddress, msg.sender, _tokenId));
567 
568         // Sanity check that no inputs overflow how many bits we've allocated
569         // to store them in the auction struct.
570         require(_startingPrice == uint256(uint128(_startingPrice)));
571         require(_endingPrice == uint256(uint128(_endingPrice)));
572         require(_duration == uint256(uint64(_duration)));
573 
574         _escrow(_tokenAddress, _tokenId);
575         Auction memory auction = Auction(
576             _seller,
577             uint128(_startingPrice),
578             uint128(_endingPrice),
579             uint64(_duration),
580             uint64(now)
581         );
582         _addAuction(_tokenAddress, _tokenId, auction);
583     }
584 
585     /// @dev Bids on an open auction, completing the auction and transferring
586     ///  ownership of the NFT if enough Ether is supplied.
587     /// @param _tokenId - ID of token to bid on.
588     function bid(address _tokenAddress, uint256 _tokenId)
589         external
590         payable
591     {
592         // Check this token is supported
593         require(supportedTokens[_tokenAddress]);
594         // _bid will throw if the bid or funds transfer fails
595         _bid(_tokenAddress, _tokenId, msg.value);
596         _transfer(_tokenAddress, msg.sender, _tokenId);
597     }
598 
599     /// @dev Cancels an auction that hasn't been won yet.
600     ///  Returns the NFT to original owner.
601     /// @notice This is a state-modifying function that can
602     ///  be called while the contract is paused.
603     /// @param _tokenId - ID of token on auction
604     function cancelAuction(address _tokenAddress, uint256 _tokenId)
605         external
606     {
607         // We don't check if a token is supported here because we may remove supported
608         // This allows users to cancel auctions for tokens that have been removed
609         Auction storage auction = tokenIdToAuction[_tokenAddress][_tokenId];
610         require(_isOnAuction(auction));
611         address seller = auction.seller;
612         require(msg.sender == seller);
613         _cancelAuction(_tokenAddress, _tokenId, seller);
614     }
615 
616     /// @dev Returns auction info for an NFT on auction.
617     /// @param _tokenId - ID of NFT on auction.
618     function getAuction(address _tokenAddress, uint256 _tokenId)
619         external
620         view
621         returns
622     (
623         address seller,
624         uint256 startingPrice,
625         uint256 endingPrice,
626         uint256 duration,
627         uint256 startedAt
628     ) {
629         // Check this token is supported
630         require(supportedTokens[_tokenAddress]);
631         Auction storage auction = tokenIdToAuction[_tokenAddress][_tokenId];
632         require(_isOnAuction(auction));
633         return (
634             auction.seller,
635             auction.startingPrice,
636             auction.endingPrice,
637             auction.duration,
638             auction.startedAt
639         );
640     }
641 
642     /// @dev Returns the current price of an auction.
643     /// @param _tokenId - ID of the token price we are checking.
644     function getCurrentPrice(address _tokenAddress, uint256 _tokenId)
645         external
646         view
647         returns (uint256)
648     {
649         // Check this token is supported
650         require(supportedTokens[_tokenAddress]);
651         Auction storage auction = tokenIdToAuction[_tokenAddress][_tokenId];
652         require(_isOnAuction(auction));
653         return _currentPrice(auction);
654     }
655 }
656 
657 contract CryptoHandles is ERC721Token {
658 
659     address public owner;
660     uint256 public defaultBuyNowPrice = 100 finney;
661     uint256 public defaultAuctionPrice = 1 ether;
662     uint256 public defaultAuctionDuration = 1 days;
663 
664     AuctionHouse public auctions;
665 
666     mapping (uint => bytes32) handles;
667     mapping (bytes32 => uint) reverse;
668 
669     event SetRecord(bytes32 indexed handle, string indexed key, string value);
670 
671     function CryptoHandles(address auctionAddress) {
672       owner = msg.sender;
673       auctions = AuctionHouse(auctionAddress);
674     }
675 
676     /**
677     * @dev Change owner of the contract
678     */
679     function changeOwner(address newOwner) external {
680       require(msg.sender == owner);
681       owner = newOwner;
682     }
683 
684     /**
685     * @dev Withdraw funds
686     */
687     function withdraw() external {
688       require(msg.sender == owner);
689       owner.transfer(this.balance);
690     }
691 
692     /**
693     * @dev Set buy now price
694     */
695     function setBuyNowPrice(uint price) external {
696       require(msg.sender == owner);
697       defaultBuyNowPrice = price;
698     }
699 
700     /**
701     * @dev Set buy now price
702     */
703     function setAuctionPrice(uint price) external {
704       require(msg.sender == owner);
705       defaultAuctionPrice = price;
706     }
707 
708     /**
709     * @dev Set duration
710     */
711     function setAuctionDuration(uint duration) external {
712       require(msg.sender == owner);
713       defaultAuctionDuration = duration;
714     }
715 
716     /**
717     * @dev Accept proceeds from auction sales
718     */
719     function() public payable {}
720 
721     /**
722     * @dev Create a new handle if the handle is valid and not owned
723     * @param _handle bytes32 handle to register
724     */
725     function create(bytes32 _handle) external payable {
726         require(isHandleValid(_handle));
727         require(isHandleAvailable(_handle));
728         uint _tokenId = totalTokens;
729         handles[_tokenId] = _handle;
730         reverse[_handle] = _tokenId;
731 
732         // handle buy now
733         if (msg.value == defaultBuyNowPrice) {
734           _mint(msg.sender, _tokenId);
735         } else {
736           // otherwise start an auction
737           require(msg.value == 0);
738           // mint the token to the address
739           _mint(address(auctions), _tokenId);
740           auctions.createAuction(
741               address(this),
742               _tokenId,
743               defaultAuctionPrice,
744               0,
745               defaultAuctionDuration,
746               address(this)
747           );
748         }
749     }
750 
751     /**
752     * @dev Checks if a handle is valid: a-z, 0-9, _
753     * @param _handle bytes32 to check validity
754     */
755     function isHandleValid(bytes32 _handle) public pure returns (bool) {
756         if (_handle == 0x0) {
757             return false;
758         }
759         bool padded;
760         for (uint i = 0; i < 32; i++) {
761             byte char = byte(bytes32(uint(_handle) * 2 ** (8 * i)));
762             // null for padding
763             if (char == 0x0) {
764                 padded = true;
765                 continue;
766             }
767             // numbers 0-9
768             if (char >= 0x30  && char <= 0x39 && !padded) {
769                 continue;
770             }
771             // lowercase letters a-z
772             if (char >= 0x61  && char <= 0x7A && !padded) {
773                 continue;
774             }
775             // underscores _
776             if (char == 0x5F && !padded) {
777                 continue;
778             }
779             return false;
780         }
781         return true;
782     }
783 
784     /**
785     * @dev Checks if a handle is available
786     * @param _handle bytes32 handle to check availability
787     */
788     function isHandleAvailable(bytes32 _handle) public view returns (bool) {
789         // Get the tokenId for a given handle
790         uint tokenId = reverse[_handle];
791         if (handles[tokenId] != _handle) {
792           return true;
793         }
794     }
795 
796     /**
797     * @dev Approve the AuctionHouse and start an auction
798     * @param _tokenId uint256
799     * @param _startingPrice uint256
800     * @param _endingPrice uint256
801     * @param _duration uint256
802     */
803     function approveAndAuction(uint256 _tokenId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external {
804         require(ownerOf(_tokenId) == msg.sender);
805         tokenApprovals[_tokenId] = address(auctions);
806         auctions.createAuction(
807             address(this),
808             _tokenId,
809             _startingPrice,
810             _endingPrice,
811             _duration,
812             msg.sender
813         );
814     }
815 
816     /**
817     * @dev Get tokenId for a given handle
818     * @param _handle bytes32 handle
819     */
820     function tokenIdForHandle(bytes32 _handle) public view returns (uint) {
821         // Handle 0 index
822         uint tokenId = reverse[_handle];
823         require(handles[tokenId] == _handle);
824         return tokenId;
825     }
826 
827     /**
828     * @dev Get handle for a given tokenId
829     * @param _tokenId uint
830     */
831     function handleForTokenId(uint _tokenId) public view returns (bytes32) {
832         bytes32 handle = handles[_tokenId];
833         require(handle != 0x0);
834         return handle;
835     }
836 
837     /**
838     * @dev Get the handle owner
839     * @param _handle bytes32 handle to check availability
840     */
841     function getHandleOwner(bytes32 _handle) public view returns (address) {
842         // Handle 0 index
843         uint tokenId = reverse[_handle];
844         require(handles[tokenId] == _handle);
845         return ownerOf(tokenId);
846     }
847 
848     /// Records for a handle
849     mapping(bytes32 => mapping(string => string)) internal records;
850 
851     function setRecord(bytes32 _handle, string _key, string _value) external {
852         uint tokenId = reverse[_handle];
853         require(ownerOf(tokenId) == msg.sender);
854         records[_handle][_key] = _value;
855         SetRecord(_handle, _key, _value);
856     }
857 
858     function getRecord(bytes32 _handle, string _key) external view returns (string) {
859         return records[_handle][_key];
860     }
861 }