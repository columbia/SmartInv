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
17   function Ownable() {
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
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
46 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
47 contract ERC721 {
48     // Required methods
49     function totalSupply() public view returns (uint256 total);
50     function balanceOf(address _owner) public view returns (uint256 balance);
51     function ownerOf(uint256 _tokenId) external view returns (address owner);
52     function approve(address _to, uint256 _tokenId) external;
53     function transfer(address _to, uint256 _tokenId) external;
54     function transferFrom(address _from, address _to, uint256 _tokenId) external;
55 
56     // Events
57     event Transfer(address from, address to, uint256 tokenId);
58     event Approval(address owner, address approved, uint256 tokenId);
59 
60     // Optional
61     // function name() public view returns (string name);
62     // function symbol() public view returns (string symbol);
63     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
64     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
65 
66     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
67     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
68 }
69 
70 
71 
72 
73 
74 
75 
76 
77 
78 /// @title Auction Core
79 /// @dev Contains models, variables, and internal methods for the auction.
80 /// @notice We omit a fallback function to prevent accidental sends to this contract.
81 contract ClockAuctionBase {
82 
83     // Represents an auction on an NFT
84     struct Auction {
85         // Current owner of NFT
86         address seller;
87         // Price (in wei) at beginning of auction
88         uint128 startingPrice;
89         // Price (in wei) at end of auction
90         uint128 endingPrice;
91         // Duration (in seconds) of auction
92         uint64 duration;
93         // Time when auction started
94         // NOTE: 0 if this auction has been concluded
95         uint64 startedAt;
96     }
97 
98     // Reference to contract tracking NFT ownership
99     ERC721 public nonFungibleContract;
100 
101     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
102     // Values 0-10,000 map to 0%-100%
103     uint256 public ownerCut;
104 
105     // Map from token ID to their corresponding auction.
106     mapping (uint256 => Auction) tokenIdToAuction;
107 
108     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
109     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
110     event AuctionCancelled(uint256 tokenId);
111 
112     /// @dev Returns true if the claimant owns the token.
113     /// @param _claimant - Address claiming to own the token.
114     /// @param _tokenId - ID of token whose ownership to verify.
115     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
116         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
117     }
118 
119     /// @dev Escrows the NFT, assigning ownership to this contract.
120     /// Throws if the escrow fails.
121     /// @param _owner - Current owner address of token to escrow.
122     /// @param _tokenId - ID of token whose approval to verify.
123     function _escrow(address _owner, uint256 _tokenId) internal {
124         // it will throw if transfer fails
125         nonFungibleContract.transferFrom(_owner, this, _tokenId);
126     }
127 
128     /// @dev Transfers an NFT owned by this contract to another address.
129     /// Returns true if the transfer succeeds.
130     /// @param _receiver - Address to transfer NFT to.
131     /// @param _tokenId - ID of token to transfer.
132     function _transfer(address _receiver, uint256 _tokenId) internal {
133         // it will throw if transfer fails
134         nonFungibleContract.transfer(_receiver, _tokenId);
135     }
136 
137     /// @dev Adds an auction to the list of open auctions. Also fires the
138     ///  AuctionCreated event.
139     /// @param _tokenId The ID of the token to be put on auction.
140     /// @param _auction Auction to add.
141     function _addAuction(uint256 _tokenId, Auction _auction) internal {
142         // Require that all auctions have a duration of
143         // at least one minute. (Keeps our math from getting hairy!)
144         require(_auction.duration >= 1 minutes);
145 
146         tokenIdToAuction[_tokenId] = _auction;
147 
148         AuctionCreated(
149             uint256(_tokenId),
150             uint256(_auction.startingPrice),
151             uint256(_auction.endingPrice),
152             uint256(_auction.duration)
153         );
154     }
155 
156     /// @dev Cancels an auction unconditionally.
157     function _cancelAuction(uint256 _tokenId, address _seller) internal {
158         _removeAuction(_tokenId);
159         _transfer(_seller, _tokenId);
160         AuctionCancelled(_tokenId);
161     }
162 
163     /// @dev Computes the price and transfers winnings.
164     /// Does NOT transfer ownership of token.
165     function _bid(uint256 _tokenId, uint256 _bidAmount)
166         internal
167         returns (uint256)
168     {
169         // Get a reference to the auction struct
170         Auction storage auction = tokenIdToAuction[_tokenId];
171 
172         // Explicitly check that this auction is currently live.
173         // (Because of how Ethereum mappings work, we can't just count
174         // on the lookup above failing. An invalid _tokenId will just
175         // return an auction object that is all zeros.)
176         require(_isOnAuction(auction));
177 
178         // Check that the bid is greater than or equal to the current price
179         uint256 price = _currentPrice(auction);
180         require(_bidAmount >= price);
181 
182         // Grab a reference to the seller before the auction struct
183         // gets deleted.
184         address seller = auction.seller;
185 
186         // The bid is good! Remove the auction before sending the fees
187         // to the sender so we can't have a reentrancy attack.
188         _removeAuction(_tokenId);
189 
190         // Transfer proceeds to seller (if there are any!)
191         if (price > 0) {
192             // Calculate the auctioneer's cut.
193             // (NOTE: _computeCut() is guaranteed to return a
194             // value <= price, so this subtraction can't go negative.)
195             uint256 auctioneerCut = _computeCut(price);
196             uint256 sellerProceeds = price - auctioneerCut;
197 
198             // NOTE: Doing a transfer() in the middle of a complex
199             // method like this is generally discouraged because of
200             // reentrancy attacks and DoS attacks if the seller is
201             // a contract with an invalid fallback function. We explicitly
202             // guard against reentrancy attacks by removing the auction
203             // before calling transfer(), and the only thing the seller
204             // can DoS is the sale of their own asset! (And if it's an
205             // accident, they can call cancelAuction(). )
206             seller.transfer(sellerProceeds);
207         }
208 
209         // Calculate any excess funds included with the bid. If the excess
210         // is anything worth worrying about, transfer it back to bidder.
211         // NOTE: We checked above that the bid amount is greater than or
212         // equal to the price so this cannot underflow.
213         uint256 bidExcess = _bidAmount - price;
214 
215         // Return the funds. Similar to the previous transfer, this is
216         // not susceptible to a re-entry attack because the auction is
217         // removed before any transfers occur.
218         msg.sender.transfer(bidExcess);
219 
220         // Tell the world!
221         AuctionSuccessful(_tokenId, price, msg.sender);
222 
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
318 
319 
320 
321 
322 
323 
324 /**
325  * @title Pausable
326  * @dev Base contract which allows children to implement an emergency stop mechanism.
327  */
328 contract Pausable is Ownable {
329   event Pause();
330   event Unpause();
331 
332   bool public paused = false;
333 
334 
335   /**
336    * @dev modifier to allow actions only when the contract IS paused
337    */
338   modifier whenNotPaused() {
339     require(!paused);
340     _;
341   }
342 
343   /**
344    * @dev modifier to allow actions only when the contract IS NOT paused
345    */
346   modifier whenPaused {
347     require(paused);
348     _;
349   }
350 
351   /**
352    * @dev called by the owner to pause, triggers stopped state
353    */
354   function pause() onlyOwner whenNotPaused returns (bool) {
355     paused = true;
356     Pause();
357     return true;
358   }
359 
360   /**
361    * @dev called by the owner to unpause, returns to normal state
362    */
363   function unpause() onlyOwner whenPaused returns (bool) {
364     paused = false;
365     Unpause();
366     return true;
367   }
368 }
369 
370 
371 /// @title Clock auction for non-fungible tokens.
372 /// @notice We omit a fallback function to prevent accidental sends to this contract.
373 contract ClockAuction is Pausable, ClockAuctionBase {
374 
375     /// @dev The ERC-165 interface signature for ERC-721.
376     ///  Ref: https://github.com/ethereum/EIPs/issues/165
377     ///  Ref: https://github.com/ethereum/EIPs/issues/721
378     bytes4 constant InterfaceSignature_ERC721 = bytes4(0x9a20483d);
379 
380     /// @dev Constructor creates a reference to the NFT ownership contract
381     ///  and verifies the owner cut is in the valid range.
382     /// @param _nftAddress - address of a deployed contract implementing
383     ///  the Nonfungible Interface.
384     /// @param _cut - percent cut the owner takes on each auction, must be
385     ///  between 0-10,000.
386     function ClockAuction(address _nftAddress, uint256 _cut) public {
387         require(_cut <= 10000);
388         ownerCut = _cut;
389 
390         ERC721 candidateContract = ERC721(_nftAddress);
391         require(candidateContract.supportsInterface(InterfaceSignature_ERC721));
392         nonFungibleContract = candidateContract;
393     }
394 
395     /// @dev Remove all Ether from the contract, which is the owner's cuts
396     ///  as well as any Ether sent directly to the contract address.
397     ///  Always transfers to the NFT contract, but can be called either by
398     ///  the owner or the NFT contract.
399     function withdrawBalance() external {
400         address nftAddress = address(nonFungibleContract);
401 
402         require(
403             msg.sender == owner ||
404             msg.sender == nftAddress
405         );
406         // We are using this boolean method to make sure that even if one fails it will still work
407         bool res = nftAddress.send(this.balance);
408     }
409 
410     /// @dev Creates and begins a new auction.
411     /// @param _tokenId - ID of token to auction, sender must be owner.
412     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
413     /// @param _endingPrice - Price of item (in wei) at end of auction.
414     /// @param _duration - Length of time to move between starting
415     ///  price and ending price (in seconds).
416     /// @param _seller - Seller, if not the message sender
417     function createAuction(
418         uint256 _tokenId,
419         uint256 _startingPrice,
420         uint256 _endingPrice,
421         uint256 _duration,
422         address _seller
423     )
424         external
425         whenNotPaused
426     {
427         // Sanity check that no inputs overflow how many bits we've allocated
428         // to store them in the auction struct.
429         require(_startingPrice == uint256(uint128(_startingPrice)));
430         require(_endingPrice == uint256(uint128(_endingPrice)));
431         require(_duration == uint256(uint64(_duration)));
432 
433         require(_owns(msg.sender, _tokenId));
434         _escrow(msg.sender, _tokenId);
435         Auction memory auction = Auction(
436             _seller,
437             uint128(_startingPrice),
438             uint128(_endingPrice),
439             uint64(_duration),
440             uint64(now)
441         );
442         _addAuction(_tokenId, auction);
443     }
444 
445     /// @dev Bids on an open auction, completing the auction and transferring
446     ///  ownership of the NFT if enough Ether is supplied.
447     /// @param _tokenId - ID of token to bid on.
448     function bid(uint256 _tokenId)
449         external
450         payable
451         whenNotPaused
452     {
453         // _bid will throw if the bid or funds transfer fails
454         _bid(_tokenId, msg.value);
455         _transfer(msg.sender, _tokenId);
456     }
457 
458     /// @dev Cancels an auction that hasn't been won yet.
459     ///  Returns the NFT to original owner.
460     /// @notice This is a state-modifying function that can
461     ///  be called while the contract is paused.
462     /// @param _tokenId - ID of token on auction
463     function cancelAuction(uint256 _tokenId)
464         external
465     {
466         Auction storage auction = tokenIdToAuction[_tokenId];
467         require(_isOnAuction(auction));
468         address seller = auction.seller;
469         require(msg.sender == seller);
470         _cancelAuction(_tokenId, seller);
471     }
472 
473     /// @dev Cancels an auction when the contract is paused.
474     ///  Only the owner may do this, and NFTs are returned to
475     ///  the seller. This should only be used in emergencies.
476     /// @param _tokenId - ID of the NFT on auction to cancel.
477     function cancelAuctionWhenPaused(uint256 _tokenId)
478         whenPaused
479         onlyOwner
480         external
481     {
482         Auction storage auction = tokenIdToAuction[_tokenId];
483         require(_isOnAuction(auction));
484         _cancelAuction(_tokenId, auction.seller);
485     }
486 
487     /// @dev Returns auction info for an NFT on auction.
488     /// @param _tokenId - ID of NFT on auction.
489     function getAuction(uint256 _tokenId)
490         external
491         view
492         returns
493     (
494         address seller,
495         uint256 startingPrice,
496         uint256 endingPrice,
497         uint256 duration,
498         uint256 startedAt
499     ) {
500         Auction storage auction = tokenIdToAuction[_tokenId];
501         require(_isOnAuction(auction));
502         return (
503             auction.seller,
504             auction.startingPrice,
505             auction.endingPrice,
506             auction.duration,
507             auction.startedAt
508         );
509     }
510 
511     /// @dev Returns the current price of an auction.
512     /// @param _tokenId - ID of the token price we are checking.
513     function getCurrentPrice(uint256 _tokenId)
514         external
515         view
516         returns (uint256)
517     {
518         Auction storage auction = tokenIdToAuction[_tokenId];
519         require(_isOnAuction(auction));
520         return _currentPrice(auction);
521     }
522 
523 }
524 
525 
526 /// @title Reverse auction modified for siring
527 /// @notice We omit a fallback function to prevent accidental sends to this contract.
528 contract SiringClockAuction is ClockAuction {
529 
530     // @dev Sanity check that allows us to ensure that we are pointing to the
531     //  right auction in our setSiringAuctionAddress() call.
532     bool public isSiringClockAuction = true;
533 
534     // Delegate constructor
535     function SiringClockAuction(address _nftAddr, uint256 _cut) public
536         ClockAuction(_nftAddr, _cut) {}
537 
538     /// @dev Creates and begins a new auction. Since this function is wrapped,
539     /// require sender to be KittyCore contract.
540     /// @param _tokenId - ID of token to auction, sender must be owner.
541     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
542     /// @param _endingPrice - Price of item (in wei) at end of auction.
543     /// @param _duration - Length of auction (in seconds).
544     /// @param _seller - Seller, if not the message sender
545     function createAuction(
546         uint256 _tokenId,
547         uint256 _startingPrice,
548         uint256 _endingPrice,
549         uint256 _duration,
550         address _seller
551     )
552         external
553     {
554         // Sanity check that no inputs overflow how many bits we've allocated
555         // to store them in the auction struct.
556         require(_startingPrice == uint256(uint128(_startingPrice)));
557         require(_endingPrice == uint256(uint128(_endingPrice)));
558         require(_duration == uint256(uint64(_duration)));
559 
560         require(msg.sender == address(nonFungibleContract));
561         _escrow(_seller, _tokenId);
562         Auction memory auction = Auction(
563             _seller,
564             uint128(_startingPrice),
565             uint128(_endingPrice),
566             uint64(_duration),
567             uint64(now)
568         );
569         _addAuction(_tokenId, auction);
570     }
571 
572     /// @dev Places a bid for siring. Requires the sender
573     /// is the KittyCore contract because all bid methods
574     /// should be wrapped. Also returns the kitty to the
575     /// seller rather than the winner.
576     function bid(uint256 _tokenId)
577         external
578         payable
579     {
580         require(msg.sender == address(nonFungibleContract));
581         address seller = tokenIdToAuction[_tokenId].seller;
582         // _bid checks that token ID is valid and will throw if bid fails
583         _bid(_tokenId, msg.value);
584         // We transfer the kitty back to the seller, the winner will get
585         // the offspring
586         _transfer(seller, _tokenId);
587     }
588 
589 }