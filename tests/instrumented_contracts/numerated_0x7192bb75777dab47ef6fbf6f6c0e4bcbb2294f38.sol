1 pragma solidity ^0.4.18;
2 
3 // File: contracts/ERC721Draft.sol
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 contract ERC721 {
7     function implementsERC721() public pure returns (bool);
8     function totalSupply() public view returns (uint256 total);
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function ownerOf(uint256 _tokenId) public view returns (address owner);
11     function approve(address _to, uint256 _tokenId) public;
12     function transferFrom(address _from, address _to, uint256 _tokenId) public;
13     function transfer(address _to, uint256 _tokenId) public;
14     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
15     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
16 
17     // Optional
18     // function name() public view returns (string name);
19     // function symbol() public view returns (string symbol);
20     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
21     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
22 }
23 
24 // File: contracts/Auction/ClockAuctionBase.sol
25 
26 /// @title Auction Core
27 /// @dev Contains models, variables, and internal methods for the auction.
28 contract ClockAuctionBase {
29 
30     // Represents an auction on an NFT
31     struct Auction {
32         // Current owner of NFT
33         address seller;
34         // Price (in wei) at beginning of auction
35         uint128 startingPrice;
36         // Price (in wei) at end of auction
37         uint128 endingPrice;
38         // Duration (in seconds) of auction
39         uint64 duration;
40         // Time when auction started
41         // NOTE: 0 if this auction has been concluded
42         uint64 startedAt;
43     }
44 
45     // Reference to contract tracking NFT ownership
46     ERC721 public nonFungibleContract;
47 
48     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
49     // Values 0-10,000 map to 0%-100%
50     uint256 public ownerCut;
51 
52     // Map from token ID to their corresponding auction.
53     mapping (uint256 => Auction) tokenIdToAuction;
54 
55     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
56     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
57     event AuctionCancelled(uint256 tokenId);
58 
59     /// @dev DON'T give me your money.
60     function() external {}
61 
62     // Modifiers to check that inputs can be safely stored with a certain
63     // number of bits. We use constants and multiple modifiers to save gas.
64     modifier canBeStoredWith64Bits(uint256 _value) {
65         require(_value <= 18446744073709551615);
66         _;
67     }
68 
69     modifier canBeStoredWith128Bits(uint256 _value) {
70         require(_value < 340282366920938463463374607431768211455);
71         _;
72     }
73 
74     /// @dev Returns true if the claimant owns the token.
75     /// @param _claimant - Address claiming to own the token.
76     /// @param _tokenId - ID of token whose ownership to verify.
77     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
78         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
79     }
80 
81     /// @dev Escrows the NFT, assigning ownership to this contract.
82     /// Throws if the escrow fails.
83     /// @param _owner - Current owner address of token to escrow.
84     /// @param _tokenId - ID of token whose approval to verify.
85     function _escrow(address _owner, uint256 _tokenId) internal {
86         // it will throw if transfer fails
87         nonFungibleContract.transferFrom(_owner, this, _tokenId);
88     }
89 
90     /// @dev Transfers an NFT owned by this contract to another address.
91     /// Returns true if the transfer succeeds.
92     /// @param _receiver - Address to transfer NFT to.
93     /// @param _tokenId - ID of token to transfer.
94     function _transfer(address _receiver, uint256 _tokenId) internal {
95         // it will throw if transfer fails
96         nonFungibleContract.transfer(_receiver, _tokenId);
97     }
98 
99     /// @dev Adds an auction to the list of open auctions. Also fires the
100     ///  AuctionCreated event.
101     /// @param _tokenId The ID of the token to be put on auction.
102     /// @param _auction Auction to add.
103     function _addAuction(uint256 _tokenId, Auction _auction) internal {
104         // Require that all auctions have a duration of
105         // at least one minute. (Keeps our math from getting hairy!)
106         require(_auction.duration >= 1 minutes);
107 
108         tokenIdToAuction[_tokenId] = _auction;
109 
110         AuctionCreated(
111             uint256(_tokenId),
112             uint256(_auction.startingPrice),
113             uint256(_auction.endingPrice),
114             uint256(_auction.duration)
115         );
116     }
117 
118     /// @dev Cancels an auction unconditionally.
119     function _cancelAuction(uint256 _tokenId, address _seller) internal {
120         _removeAuction(_tokenId);
121         _transfer(_seller, _tokenId);
122         AuctionCancelled(_tokenId);
123     }
124 
125     /// @dev Computes the price and transfers winnings.
126     /// Does NOT transfer ownership of token.
127     function _bid(uint256 _tokenId, uint256 _bidAmount)
128         internal
129         returns (uint256)
130     {
131         // Get a reference to the auction struct
132         Auction storage auction = tokenIdToAuction[_tokenId];
133 
134         // Explicitly check that this auction is currently live.
135         // (Because of how Ethereum mappings work, we can't just count
136         // on the lookup above failing. An invalid _tokenId will just
137         // return an auction object that is all zeros.)
138         require(_isOnAuction(auction));
139 
140         // Check that the incoming bid is higher than the current
141         // price
142         uint256 price = _currentPrice(auction);
143         require(_bidAmount >= price);
144 
145         // Grab a reference to the seller before the auction struct
146         // gets deleted.
147         address seller = auction.seller;
148 
149         // The bid is good! Remove the auction before sending the fees
150         // to the sender so we can't have a reentrancy attack.
151         _removeAuction(_tokenId);
152 
153         // Transfer proceeds to seller (if there are any!)
154         if (price > 0) {
155             //  Calculate the auctioneer's cut.
156             // (NOTE: _computeCut() is guaranteed to return a
157             //  value <= price, so this subtraction can't go negative.)
158             uint256 auctioneerCut = _computeCut(price);
159             uint256 sellerProceeds = price - auctioneerCut;
160 
161             // NOTE: Doing a transfer() in the middle of a complex
162             // method like this is generally discouraged because of
163             // reentrancy attacks and DoS attacks if the seller is
164             // a contract with an invalid fallback function. We explicitly
165             // guard against reentrancy attacks by removing the auction
166             // before calling transfer(), and the only thing the seller
167             // can DoS is the sale of their own asset! (And if it's an
168             // accident, they can call cancelAuction(). )
169             seller.transfer(sellerProceeds);
170         }
171 
172         // Tell the world!
173         AuctionSuccessful(_tokenId, price, msg.sender);
174 
175         return price;
176     }
177 
178     /// @dev Removes an auction from the list of open auctions.
179     /// @param _tokenId - ID of NFT on auction.
180     function _removeAuction(uint256 _tokenId) internal {
181         delete tokenIdToAuction[_tokenId];
182     }
183 
184     /// @dev Returns true if the NFT is on auction.
185     /// @param _auction - Auction to check.
186     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
187         return (_auction.startedAt > 0);
188     }
189 
190     /// @dev Returns current price of an NFT on auction. Broken into two
191     ///  functions (this one, that computes the duration from the auction
192     ///  structure, and the other that does the price computation) so we
193     ///  can easily test that the price computation works correctly.
194     function _currentPrice(Auction storage _auction)
195         internal
196         view
197         returns (uint256)
198     {
199         uint256 secondsPassed = 0;
200 
201         // A bit of insurance against negative values (or wraparound).
202         // Probably not necessary (since Ethereum guarnatees that the
203         // now variable doesn't ever go backwards).
204         if (now > _auction.startedAt) {
205             secondsPassed = now - _auction.startedAt;
206         }
207 
208         return _computeCurrentPrice(
209             _auction.startingPrice,
210             _auction.endingPrice,
211             _auction.duration,
212             secondsPassed
213         );
214     }
215 
216     /// @dev Computes the current price of an auction. Factored out
217     ///  from _currentPrice so we can run extensive unit tests.
218     ///  When testing, make this function public and turn on
219     ///  `Current price computation` test suite.
220     function _computeCurrentPrice(
221         uint256 _startingPrice,
222         uint256 _endingPrice,
223         uint256 _duration,
224         uint256 _secondsPassed
225     )
226         internal
227         pure
228         returns (uint256)
229     {
230         // NOTE: We don't use SafeMath (or similar) in this function because
231         //  all of our public functions carefully cap the maximum values for
232         //  time (at 64-bits) and currency (at 128-bits). _duration is
233         //  also known to be non-zero (see the require() statement in
234         //  _addAuction())
235         if (_secondsPassed >= _duration) {
236             // We've reached the end of the dynamic pricing portion
237             // of the auction, just return the end price.
238             return _endingPrice;
239         } else {
240             // Starting price can be higher than ending price (and often is!), so
241             // this delta can be negative.
242             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
243 
244             // This multiplication can't overflow, _secondsPassed will easily fit within
245             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
246             // will always fit within 256-bits.
247             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
248 
249             // currentPriceChange can be negative, but if so, will have a magnitude
250             // less that _startingPrice. Thus, this result will always end up positive.
251             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
252 
253             return uint256(currentPrice);
254         }
255     }
256 
257     /// @dev Computes owner's cut of a sale.
258     /// @param _price - Sale price of NFT.
259     function _computeCut(uint256 _price) internal view returns (uint256) {
260         // NOTE: We don't use SafeMath (or similar) in this function because
261         //  all of our entry functions carefully cap the maximum values for
262         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
263         //  statement in the ClockAuction constructor). The result of this
264         //  function is always guaranteed to be <= _price.
265         return _price * ownerCut / 10000;
266     }
267 
268 }
269 
270 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
271 
272 /**
273  * @title Ownable
274  * @dev The Ownable contract has an owner address, and provides basic authorization control
275  * functions, this simplifies the implementation of "user permissions".
276  */
277 contract Ownable {
278   address public owner;
279 
280 
281   /**
282    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
283    * account.
284    */
285   function Ownable() {
286     owner = msg.sender;
287   }
288 
289 
290   /**
291    * @dev Throws if called by any account other than the owner.
292    */
293   modifier onlyOwner() {
294     require(msg.sender == owner);
295     _;
296   }
297 
298 
299   /**
300    * @dev Allows the current owner to transfer control of the contract to a newOwner.
301    * @param newOwner The address to transfer ownership to.
302    */
303   function transferOwnership(address newOwner) onlyOwner {
304     if (newOwner != address(0)) {
305       owner = newOwner;
306     }
307   }
308 
309 }
310 
311 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
312 
313 /**
314  * @title Pausable
315  * @dev Base contract which allows children to implement an emergency stop mechanism.
316  */
317 contract Pausable is Ownable {
318   event Pause();
319   event Unpause();
320 
321   bool public paused = false;
322 
323 
324   /**
325    * @dev modifier to allow actions only when the contract IS paused
326    */
327   modifier whenNotPaused() {
328     require(!paused);
329     _;
330   }
331 
332   /**
333    * @dev modifier to allow actions only when the contract IS NOT paused
334    */
335   modifier whenPaused {
336     require(paused);
337     _;
338   }
339 
340   /**
341    * @dev called by the owner to pause, triggers stopped state
342    */
343   function pause() onlyOwner whenNotPaused returns (bool) {
344     paused = true;
345     Pause();
346     return true;
347   }
348 
349   /**
350    * @dev called by the owner to unpause, returns to normal state
351    */
352   function unpause() onlyOwner whenPaused returns (bool) {
353     paused = false;
354     Unpause();
355     return true;
356   }
357 }
358 
359 // File: contracts/Auction/ClockAuction.sol
360 
361 /// @title Clock auction for non-fungible tokens.
362 contract ClockAuction is Pausable, ClockAuctionBase {
363 
364     /// @dev Constructor creates a reference to the NFT ownership contract
365     ///  and verifies the owner cut is in the valid range.
366     /// @param _nftAddress - address of a deployed contract implementing
367     ///  the Nonfungible Interface.
368     /// @param _cut - percent cut the owner takes on each auction, must be
369     ///  between 0-10,000.
370     function ClockAuction(address _nftAddress, uint256 _cut) public {
371         require(_cut <= 10000);
372         ownerCut = _cut;
373 
374         ERC721 candidateContract = ERC721(_nftAddress);
375         require(candidateContract.implementsERC721());
376         nonFungibleContract = candidateContract;
377     }
378 
379     /// @dev Remove all Ether from the contract, which is the owner's cuts
380     ///  as well as any Ether sent directly to the contract address.
381     ///  Always transfers to the NFT contract, but can be called either by
382     ///  the owner or the NFT contract.
383     function withdrawBalance() external {
384         address nftAddress = address(nonFungibleContract);
385 
386         require(
387             msg.sender == owner ||
388             msg.sender == nftAddress
389         );
390         nftAddress.transfer(this.balance);
391     }
392 
393     /// @dev Creates and begins a new auction.
394     /// @param _tokenId - ID of token to auction, sender must be owner.
395     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
396     /// @param _endingPrice - Price of item (in wei) at end of auction.
397     /// @param _duration - Length of time to move between starting
398     ///  price and ending price (in seconds).
399     /// @param _seller - Seller, if not the message sender
400     function createAuction(
401         uint256 _tokenId,
402         uint256 _startingPrice,
403         uint256 _endingPrice,
404         uint256 _duration,
405         address _seller
406     )
407         public
408         whenNotPaused
409         canBeStoredWith128Bits(_startingPrice)
410         canBeStoredWith128Bits(_endingPrice)
411         canBeStoredWith64Bits(_duration)
412     {
413         require(_owns(msg.sender, _tokenId));
414         _escrow(msg.sender, _tokenId);
415         Auction memory auction = Auction(
416             _seller,
417             uint128(_startingPrice),
418             uint128(_endingPrice),
419             uint64(_duration),
420             uint64(now)
421         );
422         _addAuction(_tokenId, auction);
423     }
424 
425     /// @dev Bids on an open auction, completing the auction and transferring
426     ///  ownership of the NFT if enough Ether is supplied.
427     /// @param _tokenId - ID of token to bid on.
428     function bid(uint256 _tokenId)
429         public
430         payable
431         whenNotPaused
432     {
433         // _bid will throw if the bid or funds transfer fails
434         _bid(_tokenId, msg.value);
435         _transfer(msg.sender, _tokenId);
436     }
437 
438     /// @dev Cancels an auction that hasn't been won yet.
439     ///  Returns the NFT to original owner.
440     /// @notice This is a state-modifying function that can
441     ///  be called while the contract is paused.
442     /// @param _tokenId - ID of token on auction
443     function cancelAuction(uint256 _tokenId)
444         public
445     {
446         Auction storage auction = tokenIdToAuction[_tokenId];
447         require(_isOnAuction(auction));
448         address seller = auction.seller;
449         require(msg.sender == seller);
450         _cancelAuction(_tokenId, seller);
451     }
452 
453     /// @dev Cancels an auction when the contract is paused.
454     ///  Only the owner may do this, and NFTs are returned to
455     ///  the seller. This should only be used in emergencies.
456     /// @param _tokenId - ID of the NFT on auction to cancel.
457     function cancelAuctionWhenPaused(uint256 _tokenId)
458         whenPaused
459         onlyOwner
460         public
461     {
462         Auction storage auction = tokenIdToAuction[_tokenId];
463         require(_isOnAuction(auction));
464         _cancelAuction(_tokenId, auction.seller);
465     }
466 
467     /// @dev Returns auction info for an NFT on auction.
468     /// @param _tokenId - ID of NFT on auction.
469     function getAuction(uint256 _tokenId)
470         public
471         view
472         returns
473     (
474         address seller,
475         uint256 startingPrice,
476         uint256 endingPrice,
477         uint256 duration,
478         uint256 startedAt
479     ) {
480         Auction storage auction = tokenIdToAuction[_tokenId];
481         require(_isOnAuction(auction));
482         return (
483             auction.seller,
484             auction.startingPrice,
485             auction.endingPrice,
486             auction.duration,
487             auction.startedAt
488         );
489     }
490 
491     /// @dev Returns the current price of an auction.
492     /// @param _tokenId - ID of the token price we are checking.
493     function getCurrentPrice(uint256 _tokenId)
494         public
495         view
496         returns (uint256)
497     {
498         Auction storage auction = tokenIdToAuction[_tokenId];
499         require(_isOnAuction(auction));
500         return _currentPrice(auction);
501     }
502 
503 }
504 
505 // File: contracts/Auction/SaleClockAuction.sol
506 
507 /// @title Clock auction modified for sale of fighters
508 contract SaleClockAuction is ClockAuction {
509 
510     // @dev Sanity check that allows us to ensure that we are pointing to the
511     //  right auction in our setSaleAuctionAddress() call.
512     bool public isSaleClockAuction = true;
513 
514     // Tracks last 4 sale price of gen0 fighter sales
515     uint256 public gen0SaleCount;
516     uint256[4] public lastGen0SalePrices;
517 
518     // Delegate constructor
519     function SaleClockAuction(address _nftAddr, uint256 _cut) public
520         ClockAuction(_nftAddr, _cut) {}
521 
522     /// @dev Creates and begins a new auction.
523     /// @param _tokenId - ID of token to auction, sender must be owner.
524     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
525     /// @param _endingPrice - Price of item (in wei) at end of auction.
526     /// @param _duration - Length of auction (in seconds).
527     /// @param _seller - Seller, if not the message sender
528     function createAuction(
529         uint256 _tokenId,
530         uint256 _startingPrice,
531         uint256 _endingPrice,
532         uint256 _duration,
533         address _seller
534     )
535         public
536         canBeStoredWith128Bits(_startingPrice)
537         canBeStoredWith128Bits(_endingPrice)
538         canBeStoredWith64Bits(_duration)
539     {
540         require(msg.sender == address(nonFungibleContract));
541         _escrow(_seller, _tokenId);
542         Auction memory auction = Auction(
543             _seller,
544             uint128(_startingPrice),
545             uint128(_endingPrice),
546             uint64(_duration),
547             uint64(now)
548         );
549         _addAuction(_tokenId, auction);
550     }
551 
552     /// @dev Updates lastSalePrice if seller is the nft contract
553     /// Otherwise, works the same as default bid method.
554     function bid(uint256 _tokenId)
555         public
556         payable
557     {
558         // _bid verifies token ID size
559         address seller = tokenIdToAuction[_tokenId].seller;
560         uint256 price = _bid(_tokenId, msg.value);
561         _transfer(msg.sender, _tokenId);
562 
563         // If not a gen0 auction, exit
564         if (seller == address(nonFungibleContract)) {
565             // Track gen0 sale prices
566             lastGen0SalePrices[gen0SaleCount % 4] = price;
567             gen0SaleCount++;
568         }
569     }
570 
571     function averageGen0SalePrice() public view returns (uint256) {
572         uint256 sum = 0;
573         for (uint256 i = 0; i < 4; i++) {
574             sum += lastGen0SalePrices[i];
575         }
576         return sum / 4;
577     }
578 
579 }