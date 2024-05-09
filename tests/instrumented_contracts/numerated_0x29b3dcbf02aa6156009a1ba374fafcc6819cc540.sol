1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   constructor() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 
46 /**
47  * @title Pausable
48  * @dev Base contract which allows children to implement an emergency stop mechanism.
49  */
50 contract Pausable is Ownable {
51   event Pause();
52   event Unpause();
53 
54   bool public paused = false;
55 
56 
57   /**
58    * @dev modifier to allow actions only when the contract IS paused
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev modifier to allow actions only when the contract IS NOT paused
67    */
68   modifier whenPaused {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public returns (bool) {
77     paused = true;
78     emit Pause();
79     return true;
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public returns (bool) {
86     paused = false;
87     emit Unpause();
88     return true;
89   }
90 }
91 
92 
93 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
94 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
95 contract ERC721 {
96     // Required methods
97     function totalSupply() public view returns (uint256 total);
98     function balanceOf(address _owner) public view returns (uint256 balance);
99     function ownerOf(uint256 _tokenId) external view returns (address owner);
100     function approve(address _to, uint256 _tokenId) external;
101     function transfer(address _to, uint256 _tokenId) external;
102     function transferFrom(address _from, address _to, uint256 _tokenId) external;
103 
104     // Events
105     event Transfer(address from, address to, uint256 tokenId);
106     event Approval(address owner, address approved, uint256 tokenId);
107 }
108 
109 
110 /// @title Auction Core
111 /// @dev Contains models, variables, and internal methods for the auction.
112 /// @notice We omit a fallback function to prevent accidental sends to this contract.
113 contract ClockAuctionBase {
114 
115     // Represents an auction on an NFT
116     struct Auction {
117         // Current owner of NFT
118         address seller;
119         // Price (in wei) at beginning of auction
120         uint128 startingPrice;
121         // Price (in wei) at end of auction
122         uint128 endingPrice;
123         // Duration (in seconds) of auction
124         uint64 duration;
125         // Time when auction started
126         // NOTE: 0 if this auction has been concluded
127         uint64 startedAt;
128     }
129 
130     // Reference to contract tracking NFT ownership
131     ERC721 public nonFungibleContract;
132 
133     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
134     // Values 0-10,000 map to 0%-100%
135     uint256 public ownerCut;
136 
137     // Map from token ID to their corresponding auction.
138     mapping (uint256 => Auction) tokenIdToAuction;
139 
140     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
141     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
142     event AuctionCancelled(uint256 tokenId);
143 
144     /// @dev Returns true if the claimant owns the token.
145     /// @param _claimant - Address claiming to own the token.
146     /// @param _tokenId - ID of token whose ownership to verify.
147     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
148         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
149     }
150 
151     /// @dev Escrows the NFT, assigning ownership to this contract.
152     /// Throws if the escrow fails.
153     /// @param _owner - Current owner address of token to escrow.
154     /// @param _tokenId - ID of token whose approval to verify.
155     function _escrow(address _owner, uint256 _tokenId) internal {
156         // it will throw if transfer fails
157         nonFungibleContract.transferFrom(_owner, this, _tokenId);
158     }
159 
160     /// @dev Transfers an NFT owned by this contract to another address.
161     /// Returns true if the transfer succeeds.
162     /// @param _receiver - Address to transfer NFT to.
163     /// @param _tokenId - ID of token to transfer.
164     function _transfer(address _receiver, uint256 _tokenId) internal {
165         // it will throw if transfer fails
166         nonFungibleContract.transfer(_receiver, _tokenId);
167     }
168 
169     /// @dev Adds an auction to the list of open auctions. Also fires the
170     ///  AuctionCreated event.
171     /// @param _tokenId The ID of the token to be put on auction.
172     /// @param _auction Auction to add.
173     function _addAuction(uint256 _tokenId, Auction _auction) internal {
174         // Require that all auctions have a duration of
175         // at least one minute. (Keeps our math from getting hairy!)
176         require(_auction.duration >= 1 minutes);
177 
178         tokenIdToAuction[_tokenId] = _auction;
179 
180         emit AuctionCreated(
181             uint256(_tokenId),
182             uint256(_auction.startingPrice),
183             uint256(_auction.endingPrice),
184             uint256(_auction.duration)
185         );
186     }
187 
188     /// @dev Cancels an auction unconditionally.
189     function _cancelAuction(uint256 _tokenId, address _seller) internal {
190         _removeAuction(_tokenId);
191         _transfer(_seller, _tokenId);
192         emit AuctionCancelled(_tokenId);
193     }
194 
195     /// @dev Computes the price and transfers winnings.
196     /// Does NOT transfer ownership of token.
197     function _bid(uint256 _tokenId, uint256 _bidAmount)
198         internal
199         returns (uint256)
200     {
201         // Get a reference to the auction struct
202         Auction storage auction = tokenIdToAuction[_tokenId];
203 
204         // Explicitly check that this auction is currently live.
205         // (Because of how Ethereum mappings work, we can't just count
206         // on the lookup above failing. An invalid _tokenId will just
207         // return an auction object that is all zeros.)
208         require(_isOnAuction(auction));
209 
210         // Check that the bid is greater than or equal to the current price
211         uint256 price = _currentPrice(auction);
212         require(_bidAmount >= price);
213 
214         // Grab a reference to the seller before the auction struct
215         // gets deleted.
216         address seller = auction.seller;
217 
218         // The bid is good! Remove the auction before sending the fees
219         // to the sender so we can't have a reentrancy attack.
220         _removeAuction(_tokenId);
221 
222         // Transfer proceeds to seller (if there are any!)
223         if (price > 0) {
224             // Calculate the auctioneer's cut.
225             // (NOTE: _computeCut() is guaranteed to return a
226             // value <= price, so this subtraction can't go negative.)
227             uint256 auctioneerCut = _computeCut(price);
228             uint256 sellerProceeds = price - auctioneerCut;
229 
230             // NOTE: Doing a transfer() in the middle of a complex
231             // method like this is generally discouraged because of
232             // reentrancy attacks and DoS attacks if the seller is
233             // a contract with an invalid fallback function. We explicitly
234             // guard against reentrancy attacks by removing the auction
235             // before calling transfer(), and the only thing the seller
236             // can DoS is the sale of their own asset! (And if it's an
237             // accident, they can call cancelAuction(). )
238             seller.transfer(sellerProceeds);
239         }
240 
241         // Calculate any excess funds included with the bid. If the excess
242         // is anything worth worrying about, transfer it back to bidder.
243         // NOTE: We checked above that the bid amount is greater than or
244         // equal to the price so this cannot underflow.
245         uint256 bidExcess = _bidAmount - price;
246 
247         // Return the funds. Similar to the previous transfer, this is
248         // not susceptible to a re-entry attack because the auction is
249         // removed before any transfers occur.
250         msg.sender.transfer(bidExcess);
251 
252         // Tell the world!
253         emit AuctionSuccessful(_tokenId, price, msg.sender);
254 
255         return price;
256     }
257 
258     /// @dev Removes an auction from the list of open auctions.
259     /// @param _tokenId - ID of NFT on auction.
260     function _removeAuction(uint256 _tokenId) internal {
261         delete tokenIdToAuction[_tokenId];
262     }
263 
264     /// @dev Returns true if the NFT is on auction.
265     /// @param _auction - Auction to check.
266     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
267         return (_auction.startedAt > 0);
268     }
269 
270     /// @dev Returns current price of an NFT on auction. Broken into two
271     ///  functions (this one, that computes the duration from the auction
272     ///  structure, and the other that does the price computation) so we
273     ///  can easily test that the price computation works correctly.
274     function _currentPrice(Auction storage _auction)
275         internal
276         view
277         returns (uint256)
278     {
279         uint256 secondsPassed = 0;
280 
281         // A bit of insurance against negative values (or wraparound).
282         // Probably not necessary (since Ethereum guarnatees that the
283         // now variable doesn't ever go backwards).
284         if (now > _auction.startedAt) {
285             secondsPassed = now - _auction.startedAt;
286         }
287 
288         return _computeCurrentPrice(
289             _auction.startingPrice,
290             _auction.endingPrice,
291             _auction.duration,
292             secondsPassed
293         );
294     }
295 
296     /// @dev Computes the current price of an auction. Factored out
297     ///  from _currentPrice so we can run extensive unit tests.
298     ///  When testing, make this function public and turn on
299     ///  `Current price computation` test suite.
300     function _computeCurrentPrice(
301         uint256 _startingPrice,
302         uint256 _endingPrice,
303         uint256 _duration,
304         uint256 _secondsPassed
305     )
306         internal
307         pure
308         returns (uint256)
309     {
310         // NOTE: We don't use SafeMath (or similar) in this function because
311         //  all of our public functions carefully cap the maximum values for
312         //  time (at 64-bits) and currency (at 128-bits). _duration is
313         //  also known to be non-zero (see the require() statement in
314         //  _addAuction())
315         if (_secondsPassed >= _duration) {
316             // We've reached the end of the dynamic pricing portion
317             // of the auction, just return the end price.
318             return _endingPrice;
319         } else {
320             // Starting price can be higher than ending price (and often is!), so
321             // this delta can be negative.
322             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
323 
324             // This multiplication can't overflow, _secondsPassed will easily fit within
325             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
326             // will always fit within 256-bits.
327             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
328 
329             // currentPriceChange can be negative, but if so, will have a magnitude
330             // less that _startingPrice. Thus, this result will always end up positive.
331             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
332 
333             return uint256(currentPrice);
334         }
335     }
336 
337     /// @dev Computes owner's cut of a sale.
338     /// @param _price - Sale price of NFT.
339     function _computeCut(uint256 _price) internal view returns (uint256) {
340         // NOTE: We don't use SafeMath (or similar) in this function because
341         //  all of our entry functions carefully cap the maximum values for
342         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
343         //  statement in the ClockAuction constructor). The result of this
344         //  function is always guaranteed to be <= _price.
345         return _price * ownerCut / 10000;
346     }
347 
348 }
349 
350 
351 
352 
353 /// @title Clock auction for non-fungible tokens.
354 /// @notice We omit a fallback function to prevent accidental sends to this contract.
355 contract ClockAuction is Pausable, ClockAuctionBase {
356 
357     
358     /// @dev Constructor creates a reference to the NFT ownership contract
359     ///  and verifies the owner cut is in the valid range.
360     /// @param _nftAddress - address of a deployed contract implementing
361     ///  the Nonfungible Interface.
362     /// @param _cut - percent cut the owner takes on each auction, must be
363     ///  between 0-10,000.
364     constructor(address _nftAddress, uint256 _cut) public {
365         require(_cut <= 10000);
366         ownerCut = _cut;
367 
368         ERC721 candidateContract = ERC721(_nftAddress);
369         nonFungibleContract = candidateContract;
370     }
371     
372     function setAuctionParameters(address _nftAddress, uint256 _cut) external onlyOwner {
373          require(_cut <= 10000);
374         ownerCut = _cut;
375 
376         ERC721 candidateContract = ERC721(_nftAddress);
377         nonFungibleContract = candidateContract;
378     }
379 
380     /// @dev Remove all Ether from the contract, which is the owner's cuts
381     ///  as well as any Ether sent directly to the contract address.
382     ///  Always transfers to the NFT contract, but can be called either by
383     ///  the owner or the NFT contract.
384     function withdrawBalance() external {
385         address nftAddress = address(nonFungibleContract);
386 
387         require(
388             msg.sender == owner ||
389             msg.sender == nftAddress
390         );
391         // We are using this boolean method to make sure that even if one fails it will still work
392         nftAddress.transfer(address(this).balance);
393     }
394 
395     /// @dev Creates and begins a new auction.
396     /// @param _tokenId - ID of token to auction, sender must be owner.
397     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
398     /// @param _endingPrice - Price of item (in wei) at end of auction.
399     /// @param _duration - Length of time to move between starting
400     ///  price and ending price (in seconds).
401     /// @param _seller - Seller, if not the message sender
402     function createAuction(
403         uint256 _tokenId,
404         uint256 _startingPrice,
405         uint256 _endingPrice,
406         uint256 _duration,
407         address _seller
408     )
409         external
410         whenNotPaused
411     {
412         // Sanity check that no inputs overflow how many bits we've allocated
413         // to store them in the auction struct.
414         require(_startingPrice == uint256(uint128(_startingPrice)));
415         require(_endingPrice == uint256(uint128(_endingPrice)));
416         require(_duration == uint256(uint64(_duration)));
417 
418         require(_owns(msg.sender, _tokenId));
419         _escrow(msg.sender, _tokenId);
420         Auction memory auction = Auction(
421             _seller,
422             uint128(_startingPrice),
423             uint128(_endingPrice),
424             uint64(_duration),
425             uint64(now)
426         );
427         _addAuction(_tokenId, auction);
428     }
429 
430     /// @dev Bids on an open auction, completing the auction and transferring
431     ///  ownership of the NFT if enough Ether is supplied.
432     /// @param _tokenId - ID of token to bid on.
433     function bid(uint256 _tokenId)
434         external
435         payable
436         whenNotPaused
437     {
438         // _bid will throw if the bid or funds transfer fails
439         _bid(_tokenId, msg.value);
440         _transfer(msg.sender, _tokenId);
441     }
442 
443     /// @dev Cancels an auction that hasn't been won yet.
444     ///  Returns the NFT to original owner.
445     /// @notice This is a state-modifying function that can
446     ///  be called while the contract is paused.
447     /// @param _tokenId - ID of token on auction
448     function cancelAuction(uint256 _tokenId)
449         external
450     {
451         Auction storage auction = tokenIdToAuction[_tokenId];
452         require(_isOnAuction(auction));
453         address seller = auction.seller;
454         require(msg.sender == seller);
455         _cancelAuction(_tokenId, seller);
456     }
457 
458     /// @dev Cancels an auction when the contract is paused.
459     ///  Only the owner may do this, and NFTs are returned to
460     ///  the seller. This should only be used in emergencies.
461     /// @param _tokenId - ID of the NFT on auction to cancel.
462     function cancelAuctionWhenPaused(uint256 _tokenId)
463         whenPaused
464         onlyOwner
465         external
466     {
467         Auction storage auction = tokenIdToAuction[_tokenId];
468         require(_isOnAuction(auction));
469         _cancelAuction(_tokenId, auction.seller);
470     }
471 
472     /// @dev Returns auction info for an NFT on auction.
473     /// @param _tokenId - ID of NFT on auction.
474     function getAuction(uint256 _tokenId)
475         external
476         view
477         returns
478     (
479         address seller,
480         uint256 startingPrice,
481         uint256 endingPrice,
482         uint256 duration,
483         uint256 startedAt
484     ) {
485         Auction storage auction = tokenIdToAuction[_tokenId];
486         require(_isOnAuction(auction));
487         return (
488             auction.seller,
489             auction.startingPrice,
490             auction.endingPrice,
491             auction.duration,
492             auction.startedAt
493         );
494     }
495 
496     /// @dev Returns the current price of an auction.
497     /// @param _tokenId - ID of the token price we are checking.
498     function getCurrentPrice(uint256 _tokenId)
499         external
500         view
501         returns (uint256)
502     {
503         Auction storage auction = tokenIdToAuction[_tokenId];
504         require(_isOnAuction(auction));
505         return _currentPrice(auction);
506     }
507     
508     uint public bumpFee = 1 finney;
509     
510     function setBumpFee(uint val) external onlyOwner {
511         bumpFee = val;
512     }
513     
514     event AuctionBumped(uint256 tokenId);
515     
516     function bumpAuction(uint tokenId) external payable {
517         require(msg.value >= bumpFee);
518         Auction storage auction = tokenIdToAuction[tokenId];
519         require(_isOnAuction(auction));
520         emit AuctionBumped(tokenId);
521         msg.sender.transfer(msg.value - bumpFee);
522     }
523 
524 }
525 
526 
527 
528 
529 /// @title Clock auction modified for sale of monsters
530 /// @notice We omit a fallback function to prevent accidental sends to this contract.
531 contract SaleClockAuction is ClockAuction {
532 
533     // @dev Sanity check that allows us to ensure that we are pointing to the
534     //  right auction in our setSaleAuctionAddress() call.
535     bool public isSaleClockAuction = true;
536     
537     
538     // Delegate constructor
539     constructor(address _nftAddr, uint256 _cut) public
540         ClockAuction(_nftAddr, _cut) {}
541 
542     /// @dev Creates and begins a new auction.
543     /// @param _tokenId - ID of token to auction, sender must be owner.
544     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
545     /// @param _endingPrice - Price of item (in wei) at end of auction.
546     /// @param _duration - Length of auction (in seconds).
547     /// @param _seller - Seller, if not the message sender
548     function createAuction(
549         uint256 _tokenId,
550         uint256 _startingPrice,
551         uint256 _endingPrice,
552         uint256 _duration,
553         address _seller
554     )
555         external
556     {
557         // Sanity check that no inputs overflow how many bits we've allocated
558         // to store them in the auction struct.
559         require(_startingPrice == uint256(uint128(_startingPrice)));
560         require(_endingPrice == uint256(uint128(_endingPrice)));
561         require(_duration == uint256(uint64(_duration)));
562 
563         require(msg.sender == address(nonFungibleContract));
564         _escrow(_seller, _tokenId);
565         Auction memory auction = Auction(
566             _seller,
567             uint128(_startingPrice),
568             uint128(_endingPrice),
569             uint64(_duration),
570             uint64(now)
571         );
572         _addAuction(_tokenId, auction);
573     }
574 
575     /// @dev Updates lastSalePrice if seller is the nft contract
576     /// Otherwise, works the same as default bid method.
577     function bid(uint256 _tokenId)
578         external
579         payable
580     {
581         // _bid verifies token ID size
582         _bid(_tokenId, msg.value);
583         _transfer(msg.sender, _tokenId);
584     }
585 
586 }
587 
588 
589 /// @title Reverse auction modified for siring
590 /// @notice We omit a fallback function to prevent accidental sends to this contract.
591 contract SiringClockAuction is ClockAuction {
592 
593     // @dev Sanity check that allows us to ensure that we are pointing to the
594     //  right auction in our setSiringAuctionAddress() call.
595     bool public isSiringClockAuction = true;
596 
597     // Delegate constructor
598     constructor(address _nftAddr, uint256 _cut) public
599         ClockAuction(_nftAddr, _cut) {}
600 
601     /// @dev Creates and begins a new auction. Since this function is wrapped,
602     /// require sender to be MonsterBitCore contract.
603     /// @param _tokenId - ID of token to auction, sender must be owner.
604     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
605     /// @param _endingPrice - Price of item (in wei) at end of auction.
606     /// @param _duration - Length of auction (in seconds).
607     /// @param _seller - Seller, if not the message sender
608     function createAuction(
609         uint256 _tokenId,
610         uint256 _startingPrice,
611         uint256 _endingPrice,
612         uint256 _duration,
613         address _seller
614     )
615         external
616     {
617         // Sanity check that no inputs overflow how many bits we've allocated
618         // to store them in the auction struct.
619         require(_startingPrice == uint256(uint128(_startingPrice)));
620         require(_endingPrice == uint256(uint128(_endingPrice)));
621         require(_duration == uint256(uint64(_duration)));
622 
623         require(msg.sender == address(nonFungibleContract));
624         _escrow(_seller, _tokenId);
625         Auction memory auction = Auction(
626             _seller,
627             uint128(_startingPrice),
628             uint128(_endingPrice),
629             uint64(_duration),
630             uint64(now)
631         );
632         _addAuction(_tokenId, auction);
633     }
634 
635     /// @dev Places a bid for siring. Requires the sender
636     /// is the MonsterCore contract because all bid methods
637     /// should be wrapped. Also returns the monster to the
638     /// seller rather than the winner.
639     function bid(uint256 _tokenId)
640         external
641         payable
642     {
643         require(msg.sender == address(nonFungibleContract));
644         address seller = tokenIdToAuction[_tokenId].seller;
645         // _bid checks that token ID is valid and will throw if bid fails
646         _bid(_tokenId, msg.value);
647         // We transfer the monster back to the seller, the winner will get
648         // the offspring
649         _transfer(seller, _tokenId);
650     }
651 
652 }