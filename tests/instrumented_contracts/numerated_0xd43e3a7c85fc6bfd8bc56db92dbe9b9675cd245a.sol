1 pragma solidity ^0.4.19;
2 
3 // DopeRaider SaleClockAuction Contract
4 // by gasmasters.io
5 // contact: team@doperaider.com
6 
7 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
8 contract ERC721 {
9     function implementsERC721() public pure returns (bool);
10     function totalSupply() public view returns (uint256 total);
11     function balanceOf(address _owner) public view returns (uint256 balance);
12     function ownerOf(uint256 _tokenId) public view returns (address owner);
13     function approve(address _to, uint256 _tokenId) public;
14     function transferFrom(address _from, address _to, uint256 _tokenId) public;
15     function transfer(address _to, uint256 _tokenId) public;
16     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
17     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
18 
19     // Optional
20     // function name() public view returns (string name);
21     // function symbol() public view returns (string symbol);
22     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
23     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
24 }
25 
26 // File: contracts/Auction/ClockAuctionBase.sol
27 
28 /// @title Auction Core
29 /// @dev Contains models, variables, and internal methods for the auction.
30 contract ClockAuctionBase {
31 
32     // Represents an auction on an NFT
33     struct Auction {
34         // Current owner of NFT
35         address seller;
36         // Price (in wei) at beginning of auction
37         uint128 startingPrice;
38         // Price (in wei) at end of auction
39         uint128 endingPrice;
40         // Duration (in seconds) of auction
41         uint64 duration;
42         // Time when auction started
43         // NOTE: 0 if this auction has been concluded
44         uint64 startedAt;
45     }
46 
47     // Reference to contract tracking NFT ownership
48     ERC721 public nonFungibleContract;
49 
50     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
51     // Values 0-10,000 map to 0%-100%
52     uint256 public ownerCut;
53 
54     // Map from token ID to their corresponding auction.
55     mapping (uint256 => Auction) tokenIdToAuction;
56 
57     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
58     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
59     event AuctionCancelled(uint256 tokenId);
60 
61     /// @dev DON'T give me your money.
62     function() external {}
63 
64     // Modifiers to check that inputs can be safely stored with a certain
65     // number of bits. We use constants and multiple modifiers to save gas.
66     modifier canBeStoredWith64Bits(uint256 _value) {
67         require(_value <= 18446744073709551615);
68         _;
69     }
70 
71     modifier canBeStoredWith128Bits(uint256 _value) {
72         require(_value < 340282366920938463463374607431768211455);
73         _;
74     }
75 
76     /// @dev Returns true if the claimant owns the token.
77     /// @param _claimant - Address claiming to own the token.
78     /// @param _tokenId - ID of token whose ownership to verify.
79     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
80         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
81     }
82 
83     /// @dev Escrows the NFT, assigning ownership to this contract.
84     /// Throws if the escrow fails.
85     /// @param _owner - Current owner address of token to escrow.
86     /// @param _tokenId - ID of token whose approval to verify.
87     function _escrow(address _owner, uint256 _tokenId) internal {
88         // it will throw if transfer fails
89         nonFungibleContract.transferFrom(_owner, this, _tokenId);
90     }
91 
92     /// @dev Transfers an NFT owned by this contract to another address.
93     /// Returns true if the transfer succeeds.
94     /// @param _receiver - Address to transfer NFT to.
95     /// @param _tokenId - ID of token to transfer.
96     function _transfer(address _receiver, uint256 _tokenId) internal {
97         // it will throw if transfer fails
98         nonFungibleContract.transfer(_receiver, _tokenId);
99     }
100 
101     /// @dev Adds an auction to the list of open auctions. Also fires the
102     ///  AuctionCreated event.
103     /// @param _tokenId The ID of the token to be put on auction.
104     /// @param _auction Auction to add.
105     function _addAuction(uint256 _tokenId, Auction _auction) internal {
106         // Require that all auctions have a duration of
107         // at least one minute. (Keeps our math from getting hairy!)
108         require(_auction.duration >= 1 minutes);
109 
110         tokenIdToAuction[_tokenId] = _auction;
111 
112         AuctionCreated(
113             uint256(_tokenId),
114             uint256(_auction.startingPrice),
115             uint256(_auction.endingPrice),
116             uint256(_auction.duration)
117         );
118     }
119 
120     /// @dev Cancels an auction unconditionally.
121     function _cancelAuction(uint256 _tokenId, address _seller) internal {
122         _removeAuction(_tokenId);
123         _transfer(_seller, _tokenId);
124         AuctionCancelled(_tokenId);
125     }
126 
127     /// @dev Computes the price and transfers winnings.
128     /// Does NOT transfer ownership of token.
129     function _bid(uint256 _tokenId, uint256 _bidAmount)
130         internal
131         returns (uint256)
132     {
133         // Get a reference to the auction struct
134         Auction storage auction = tokenIdToAuction[_tokenId];
135 
136         // Explicitly check that this auction is currently live.
137         // (Because of how Ethereum mappings work, we can't just count
138         // on the lookup above failing. An invalid _tokenId will just
139         // return an auction object that is all zeros.)
140         require(_isOnAuction(auction));
141 
142         // Check that the incoming bid is higher than the current
143         // price
144         uint256 price = _currentPrice(auction);
145         require(_bidAmount >= price);
146 
147         // Grab a reference to the seller before the auction struct
148         // gets deleted.
149         address seller = auction.seller;
150 
151         // The bid is good! Remove the auction before sending the fees
152         // to the sender so we can't have a reentrancy attack.
153         _removeAuction(_tokenId);
154 
155         // Transfer proceeds to seller (if there are any!)
156         if (price > 0) {
157             //  Calculate the auctioneer's cut.
158             // (NOTE: _computeCut() is guaranteed to return a
159             //  value <= price, so this subtraction can't go negative.)
160             uint256 auctioneerCut = _computeCut(price);
161             uint256 sellerProceeds = price - auctioneerCut;
162 
163             // NOTE: Doing a transfer() in the middle of a complex
164             // method like this is generally discouraged because of
165             // reentrancy attacks and DoS attacks if the seller is
166             // a contract with an invalid fallback function. We explicitly
167             // guard against reentrancy attacks by removing the auction
168             // before calling transfer(), and the only thing the seller
169             // can DoS is the sale of their own asset! (And if it's an
170             // accident, they can call cancelAuction(). )
171             seller.transfer(sellerProceeds);
172         }
173 
174         // Tell the world!
175         AuctionSuccessful(_tokenId, price, msg.sender);
176 
177         return price;
178     }
179 
180     /// @dev Removes an auction from the list of open auctions.
181     /// @param _tokenId - ID of NFT on auction.
182     function _removeAuction(uint256 _tokenId) internal {
183         delete tokenIdToAuction[_tokenId];
184     }
185 
186     /// @dev Returns true if the NFT is on auction.
187     /// @param _auction - Auction to check.
188     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
189         return (_auction.startedAt > 0);
190     }
191 
192     /// @dev Returns current price of an NFT on auction. Broken into two
193     ///  functions (this one, that computes the duration from the auction
194     ///  structure, and the other that does the price computation) so we
195     ///  can easily test that the price computation works correctly.
196     function _currentPrice(Auction storage _auction)
197         internal
198         view
199         returns (uint256)
200     {
201         uint256 secondsPassed = 0;
202 
203         // A bit of insurance against negative values (or wraparound).
204         // Probably not necessary (since Ethereum guarnatees that the
205         // now variable doesn't ever go backwards).
206         if (now > _auction.startedAt) {
207             secondsPassed = now - _auction.startedAt;
208         }
209 
210         return _computeCurrentPrice(
211             _auction.startingPrice,
212             _auction.endingPrice,
213             _auction.duration,
214             secondsPassed
215         );
216     }
217 
218     /// @dev Computes the current price of an auction. Factored out
219     ///  from _currentPrice so we can run extensive unit tests.
220     ///  When testing, make this function public and turn on
221     ///  `Current price computation` test suite.
222     function _computeCurrentPrice(
223         uint256 _startingPrice,
224         uint256 _endingPrice,
225         uint256 _duration,
226         uint256 _secondsPassed
227     )
228         internal
229         pure
230         returns (uint256)
231     {
232         // NOTE: We don't use SafeMath (or similar) in this function because
233         //  all of our public functions carefully cap the maximum values for
234         //  time (at 64-bits) and currency (at 128-bits). _duration is
235         //  also known to be non-zero (see the require() statement in
236         //  _addAuction())
237         if (_secondsPassed >= _duration) {
238             // We've reached the end of the dynamic pricing portion
239             // of the auction, just return the end price.
240             return _endingPrice;
241         } else {
242             // Starting price can be higher than ending price (and often is!), so
243             // this delta can be negative.
244             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
245 
246             // This multiplication can't overflow, _secondsPassed will easily fit within
247             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
248             // will always fit within 256-bits.
249             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
250 
251             // currentPriceChange can be negative, but if so, will have a magnitude
252             // less that _startingPrice. Thus, this result will always end up positive.
253             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
254 
255             return uint256(currentPrice);
256         }
257     }
258 
259     /// @dev Computes owner's cut of a sale.
260     /// @param _price - Sale price of NFT.
261     function _computeCut(uint256 _price) internal view returns (uint256) {
262         // NOTE: We don't use SafeMath (or similar) in this function because
263         //  all of our entry functions carefully cap the maximum values for
264         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
265         //  statement in the ClockAuction constructor). The result of this
266         //  function is always guaranteed to be <= _price.
267         return _price * ownerCut / 10000;
268     }
269 
270 }
271 
272 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
273 
274 /**
275  * @title Ownable
276  * @dev The Ownable contract has an owner address, and provides basic authorization control
277  * functions, this simplifies the implementation of "user permissions".
278  */
279 contract Ownable {
280   address public owner;
281 
282 
283   /**
284    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
285    * account.
286    */
287   function Ownable() public {
288     owner = msg.sender;
289   }
290 
291 
292   /**
293    * @dev Throws if called by any account other than the owner.
294    */
295   modifier onlyOwner() {
296     require(msg.sender == owner);
297     _;
298   }
299 
300 
301   /**
302    * @dev Allows the current owner to transfer control of the contract to a newOwner.
303    * @param newOwner The address to transfer ownership to.
304    */
305   function transferOwnership(address newOwner) public onlyOwner {
306     if (newOwner != address(0)) {
307       owner = newOwner;
308     }
309   }
310 
311 }
312 
313 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
314 
315 /**
316  * @title Pausable
317  * @dev Base contract which allows children to implement an emergency stop mechanism.
318  */
319 contract Pausable is Ownable {
320   event Pause();
321   event Unpause();
322 
323   bool public paused = false;
324 
325 
326   /**
327    * @dev modifier to allow actions only when the contract IS paused
328    */
329   modifier whenNotPaused() {
330     require(!paused);
331     _;
332   }
333 
334   /**
335    * @dev modifier to allow actions only when the contract IS NOT paused
336    */
337   modifier whenPaused {
338     require(paused);
339     _;
340   }
341 
342   /**
343    * @dev called by the owner to pause, triggers stopped state
344    */
345   function pause() public onlyOwner whenNotPaused returns (bool) {
346     paused = true;
347     Pause();
348     return true;
349   }
350 
351   /**
352    * @dev called by the owner to unpause, returns to normal state
353    */
354   function unpause() public onlyOwner whenPaused returns (bool) {
355     paused = false;
356     Unpause();
357     return true;
358   }
359 }
360 
361 // File: contracts/Auction/ClockAuction.sol
362 
363 /// @title Clock auction for non-fungible tokens.
364 contract ClockAuction is Pausable, ClockAuctionBase {
365 
366     /// @dev Constructor creates a reference to the NFT ownership contract
367     ///  and verifies the owner cut is in the valid range.
368     /// @param _nftAddress - address of a deployed contract implementing
369     ///  the Nonfungible Interface.
370     /// @param _cut - percent cut the owner takes on each auction, must be
371     ///  between 0-10,000.
372     /*
373     function ClockAuction(address _nftAddress, uint256 _cut) public {
374         require(_cut <= 10000);
375         ownerCut = _cut;
376 
377         ERC721 candidateContract = ERC721(_nftAddress);
378         require(candidateContract.implementsERC721());
379         nonFungibleContract = candidateContract;
380     }*/
381 
382     /// @dev Remove all Ether from the contract, which is the owner's cuts
383     ///  as well as any Ether sent directly to the contract address.
384     ///  Always transfers to the NFT contract, but can be called either by
385     ///  the owner or the NFT contract.
386     function withdrawBalance() external {
387         address nftAddress = address(nonFungibleContract);
388 
389         require(
390             msg.sender == owner ||
391             msg.sender == nftAddress
392         );
393         nftAddress.transfer(this.balance);
394     }
395 
396     /// @dev Creates and begins a new auction.
397     /// @param _tokenId - ID of token to auction, sender must be owner.
398     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
399     /// @param _endingPrice - Price of item (in wei) at end of auction.
400     /// @param _duration - Length of time to move between starting
401     ///  price and ending price (in seconds).
402     /// @param _seller - Seller, if not the message sender
403     function createAuction(
404         uint256 _tokenId,
405         uint256 _startingPrice,
406         uint256 _endingPrice,
407         uint256 _duration,
408         address _seller
409     )
410         public
411         whenNotPaused
412         canBeStoredWith128Bits(_startingPrice)
413         canBeStoredWith128Bits(_endingPrice)
414         canBeStoredWith64Bits(_duration)
415     {
416         require(_owns(msg.sender, _tokenId));
417         _escrow(msg.sender, _tokenId);
418         Auction memory auction = Auction(
419             _seller,
420             uint128(_startingPrice),
421             uint128(_endingPrice),
422             uint64(_duration),
423             uint64(now)
424         );
425         _addAuction(_tokenId, auction);
426     }
427 
428     /// @dev Bids on an open auction, completing the auction and transferring
429     ///  ownership of the NFT if enough Ether is supplied.
430     /// @param _tokenId - ID of token to bid on.
431     function bid(uint256 _tokenId)
432         public
433         payable
434         whenNotPaused
435     {
436         // _bid will throw if the bid or funds transfer fails
437         _bid(_tokenId, msg.value);
438         _transfer(msg.sender, _tokenId);
439     }
440 
441     /// @dev Cancels an auction that hasn't been won yet.
442     ///  Returns the NFT to original owner.
443     /// @notice This is a state-modifying function that can
444     ///  be called while the contract is paused.
445     /// @param _tokenId - ID of token on auction
446     function cancelAuction(uint256 _tokenId)
447         public
448     {
449         Auction storage auction = tokenIdToAuction[_tokenId];
450         require(_isOnAuction(auction));
451         address seller = auction.seller;
452         require(msg.sender == seller);
453         _cancelAuction(_tokenId, seller);
454     }
455 
456     /// @dev Cancels an auction when the contract is paused.
457     ///  Only the owner may do this, and NFTs are returned to
458     ///  the seller. This should only be used in emergencies.
459     /// @param _tokenId - ID of the NFT on auction to cancel.
460     function cancelAuctionWhenPaused(uint256 _tokenId)
461         whenPaused
462         onlyOwner
463         public
464     {
465         Auction storage auction = tokenIdToAuction[_tokenId];
466         require(_isOnAuction(auction));
467         _cancelAuction(_tokenId, auction.seller);
468     }
469 
470     /// @dev Returns auction info for an NFT on auction.
471     /// @param _tokenId - ID of NFT on auction.
472     function getAuction(uint256 _tokenId)
473         public
474         view
475         returns
476     (
477         address seller,
478         uint256 startingPrice,
479         uint256 endingPrice,
480         uint256 duration,
481         uint256 startedAt,
482         uint256 tokenId
483     ) {
484         Auction storage auction = tokenIdToAuction[_tokenId];
485         require(_isOnAuction(auction));
486         return (
487             auction.seller,
488             auction.startingPrice,
489             auction.endingPrice,
490             auction.duration,
491             auction.startedAt,
492             _tokenId
493         );
494     }
495 
496     /// @dev Returns the current price of an auction.
497     /// @param _tokenId - ID of the token price we are checking.
498     function getCurrentPrice(uint256 _tokenId)
499         public
500         view
501         returns (uint256)
502     {
503         Auction storage auction = tokenIdToAuction[_tokenId];
504         require(_isOnAuction(auction));
505         return _currentPrice(auction);
506     }
507 
508 }
509 
510 // File: contracts/Auction/SaleClockAuction.sol
511 
512 /// @title Clock auction modified for sale of narcos
513 contract SaleClockAuction is ClockAuction {
514 
515     // @dev Sanity check that allows us to ensure that we are pointing to the
516     //  right auction in our setSaleAuctionAddress() call.
517     bool public isSaleClockAuction = true;
518 
519     // Tracks last 4 sale price of gen0 narco sales
520     uint256 public gen0SaleCount;
521     uint256[4] public lastGen0SalePrices;
522 
523     function configureSaleClockAuction(address _nftAddr, uint256 _cut) public onlyOwner
524     {
525         require(_cut <= 10000);
526         ownerCut = _cut;
527         ERC721 candidateContract = ERC721(_nftAddr);
528         require(candidateContract.implementsERC721());
529         nonFungibleContract = candidateContract;
530     }
531 
532 
533     /// @dev Creates and begins a new auction.
534     /// @param _tokenId - ID of token to auction, sender must be owner.
535     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
536     /// @param _endingPrice - Price of item (in wei) at end of auction.
537     /// @param _duration - Length of auction (in seconds).
538     /// @param _seller - Seller, if not the message sender
539     function createAuction(
540         uint256 _tokenId,
541         uint256 _startingPrice,
542         uint256 _endingPrice,
543         uint256 _duration,
544         address _seller
545     )
546         public
547         canBeStoredWith128Bits(_startingPrice)
548         canBeStoredWith128Bits(_endingPrice)
549         canBeStoredWith64Bits(_duration)
550     {
551         require(msg.sender == address(nonFungibleContract));
552         _escrow(_seller, _tokenId);
553         Auction memory auction = Auction(
554             _seller,
555             uint128(_startingPrice),
556             uint128(_endingPrice),
557             uint64(_duration),
558             uint64(now)
559         );
560         _addAuction(_tokenId, auction);
561     }
562 
563     /// @dev Updates lastSalePrice if seller is the nft contract
564     /// Otherwise, works the same as default bid method.
565     function bid(uint256 _tokenId)
566         public
567         payable
568     {
569         // _bid verifies token ID size
570         address seller = tokenIdToAuction[_tokenId].seller;
571         uint256 price = _bid(_tokenId, msg.value);
572         _transfer(msg.sender, _tokenId);
573 
574         // If not a gen0 auction, exit
575         if (seller == address(nonFungibleContract)) {
576             // Track gen0 sale prices
577             lastGen0SalePrices[gen0SaleCount % 4] = price;
578             gen0SaleCount++;
579         }
580     }
581 
582     function averageGen0SalePrice() public view returns (uint256) {
583         uint256 sum = 0;
584         for (uint256 i = 0; i < 4; i++) {
585             sum += lastGen0SalePrices[i];
586         }
587         return sum / 4;
588     }
589 
590 }