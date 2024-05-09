1 pragma solidity ^0.4.18;
2 
3 // File: contracts-origin/ERC721Draft.sol
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     function implementsERC721() public pure returns (bool);
9     function totalSupply() public view returns (uint256 total);
10     function balanceOf(address _owner) public view returns (uint256 balance);
11     function ownerOf(uint256 _tokenId) public view returns (address owner);
12     function approve(address _to, uint256 _tokenId) public;
13     function transferFrom(address _from, address _to, uint256 _tokenId) public;
14     function transfer(address _to, uint256 _tokenId) public;
15     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
16     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
17 
18     // Optional
19     // function name() public view returns (string name);
20     // function symbol() public view returns (string symbol);
21     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
22     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
23 }
24 
25 // File: contracts-origin/Auction/ClockAuctionBase.sol
26 
27 /// @title Auction Core
28 /// @dev Contains models, variables, and internal methods for the auction.
29 contract ClockAuctionBase {
30 
31     // Represents an auction on an NFT
32     struct Auction {
33         // Current owner of NFT
34         address seller;
35         // Price (in wei) at beginning of auction
36         uint128 startingPrice;
37         // Price (in wei) at end of auction
38         uint128 endingPrice;
39         // Duration (in seconds) of auction
40         uint64 duration;
41         // Time when auction started
42         // NOTE: 0 if this auction has been concluded
43         uint64 startedAt;
44     }
45 
46     // Reference to contract tracking NFT ownership
47     ERC721 public nonFungibleContract;
48 
49     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
50     // Values 0-10,000 map to 0%-100%
51     uint256 public ownerCut;
52 
53     // Map from token ID to their corresponding auction.
54     mapping (uint256 => Auction) tokenIdToAuction;
55 
56     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
57     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
58     event AuctionCancelled(uint256 tokenId);
59 
60     /// @dev DON'T give me your money.
61     function() external {}
62 
63     // Modifiers to check that inputs can be safely stored with a certain
64     // number of bits. We use constants and multiple modifiers to save gas.
65     modifier canBeStoredWith64Bits(uint256 _value) {
66         require(_value <= 18446744073709551615);
67         _;
68     }
69 
70     modifier canBeStoredWith128Bits(uint256 _value) {
71         require(_value < 340282366920938463463374607431768211455);
72         _;
73     }
74 
75     /// @dev Returns true if the claimant owns the token.
76     /// @param _claimant - Address claiming to own the token.
77     /// @param _tokenId - ID of token whose ownership to verify.
78     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
79         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
80     }
81 
82     /// @dev Escrows the NFT, assigning ownership to this contract.
83     /// Throws if the escrow fails.
84     /// @param _owner - Current owner address of token to escrow.
85     /// @param _tokenId - ID of token whose approval to verify.
86     function _escrow(address _owner, uint256 _tokenId) internal {
87         // it will throw if transfer fails
88         nonFungibleContract.transferFrom(_owner, this, _tokenId);
89     }
90 
91     /// @dev Transfers an NFT owned by this contract to another address.
92     /// Returns true if the transfer succeeds.
93     /// @param _receiver - Address to transfer NFT to.
94     /// @param _tokenId - ID of token to transfer.
95     function _transfer(address _receiver, uint256 _tokenId) internal {
96         // it will throw if transfer fails
97         nonFungibleContract.transfer(_receiver, _tokenId);
98     }
99 
100     /// @dev Adds an auction to the list of open auctions. Also fires the
101     ///  AuctionCreated event.
102     /// @param _tokenId The ID of the token to be put on auction.
103     /// @param _auction Auction to add.
104     function _addAuction(uint256 _tokenId, Auction _auction) internal {
105         // Require that all auctions have a duration of
106         // at least one minute. (Keeps our math from getting hairy!)
107         require(_auction.duration >= 1 minutes);
108 
109         tokenIdToAuction[_tokenId] = _auction;
110 
111         AuctionCreated(
112             uint256(_tokenId),
113             uint256(_auction.startingPrice),
114             uint256(_auction.endingPrice),
115             uint256(_auction.duration)
116         );
117     }
118 
119     /// @dev Cancels an auction unconditionally.
120     function _cancelAuction(uint256 _tokenId, address _seller) internal {
121         _removeAuction(_tokenId);
122         _transfer(_seller, _tokenId);
123         AuctionCancelled(_tokenId);
124     }
125 
126     /// @dev Computes the price and transfers winnings.
127     /// Does NOT transfer ownership of token.
128     function _bid(uint256 _tokenId, uint256 _bidAmount)
129         internal
130         returns (uint256)
131     {
132         // Get a reference to the auction struct
133         Auction storage auction = tokenIdToAuction[_tokenId];
134 
135         // Explicitly check that this auction is currently live.
136         // (Because of how Ethereum mappings work, we can't just count
137         // on the lookup above failing. An invalid _tokenId will just
138         // return an auction object that is all zeros.)
139         require(_isOnAuction(auction));
140 
141         // Check that the incoming bid is higher than the current
142         // price
143         uint256 price = _currentPrice(auction);
144         require(_bidAmount >= price);
145 
146         // Grab a reference to the seller before the auction struct
147         // gets deleted.
148         address seller = auction.seller;
149 
150         // The bid is good! Remove the auction before sending the fees
151         // to the sender so we can't have a reentrancy attack.
152         _removeAuction(_tokenId);
153 
154         // Transfer proceeds to seller (if there are any!)
155         if (price > 0) {
156             //  Calculate the auctioneer's cut.
157             // (NOTE: _computeCut() is guaranteed to return a
158             //  value <= price, so this subtraction can't go negative.)
159             uint256 auctioneerCut = _computeCut(price);
160             uint256 sellerProceeds = price - auctioneerCut;
161 
162             // NOTE: Doing a transfer() in the middle of a complex
163             // method like this is generally discouraged because of
164             // reentrancy attacks and DoS attacks if the seller is
165             // a contract with an invalid fallback function. We explicitly
166             // guard against reentrancy attacks by removing the auction
167             // before calling transfer(), and the only thing the seller
168             // can DoS is the sale of their own asset! (And if it's an
169             // accident, they can call cancelAuction(). )
170             seller.transfer(sellerProceeds);
171         }
172 
173         // Tell the world!
174         AuctionSuccessful(_tokenId, price, msg.sender);
175 
176         return price;
177     }
178 
179     /// @dev Removes an auction from the list of open auctions.
180     /// @param _tokenId - ID of NFT on auction.
181     function _removeAuction(uint256 _tokenId) internal {
182         delete tokenIdToAuction[_tokenId];
183     }
184 
185     /// @dev Returns true if the NFT is on auction.
186     /// @param _auction - Auction to check.
187     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
188         return (_auction.startedAt > 0);
189     }
190 
191     /// @dev Returns current price of an NFT on auction. Broken into two
192     ///  functions (this one, that computes the duration from the auction
193     ///  structure, and the other that does the price computation) so we
194     ///  can easily test that the price computation works correctly.
195     function _currentPrice(Auction storage _auction)
196         internal
197         view
198         returns (uint256)
199     {
200         uint256 secondsPassed = 0;
201 
202         // A bit of insurance against negative values (or wraparound).
203         // Probably not necessary (since Ethereum guarnatees that the
204         // now variable doesn't ever go backwards).
205         if (now > _auction.startedAt) {
206             secondsPassed = now - _auction.startedAt;
207         }
208 
209         return _computeCurrentPrice(
210             _auction.startingPrice,
211             _auction.endingPrice,
212             _auction.duration,
213             secondsPassed
214         );
215     }
216 
217     /// @dev Computes the current price of an auction. Factored out
218     ///  from _currentPrice so we can run extensive unit tests.
219     ///  When testing, make this function public and turn on
220     ///  `Current price computation` test suite.
221     function _computeCurrentPrice(
222         uint256 _startingPrice,
223         uint256 _endingPrice,
224         uint256 _duration,
225         uint256 _secondsPassed
226     )
227         internal
228         pure
229         returns (uint256)
230     {
231         // NOTE: We don't use SafeMath (or similar) in this function because
232         //  all of our public functions carefully cap the maximum values for
233         //  time (at 64-bits) and currency (at 128-bits). _duration is
234         //  also known to be non-zero (see the require() statement in
235         //  _addAuction())
236         if (_secondsPassed >= _duration) {
237             // We've reached the end of the dynamic pricing portion
238             // of the auction, just return the end price.
239             return _endingPrice;
240         } else {
241             // Starting price can be higher than ending price (and often is!), so
242             // this delta can be negative.
243             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
244 
245             // This multiplication can't overflow, _secondsPassed will easily fit within
246             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
247             // will always fit within 256-bits.
248             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
249 
250             // currentPriceChange can be negative, but if so, will have a magnitude
251             // less that _startingPrice. Thus, this result will always end up positive.
252             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
253 
254             return uint256(currentPrice);
255         }
256     }
257 
258     /// @dev Computes owner's cut of a sale.
259     /// @param _price - Sale price of NFT.
260     function _computeCut(uint256 _price) internal view returns (uint256) {
261         // NOTE: We don't use SafeMath (or similar) in this function because
262         //  all of our entry functions carefully cap the maximum values for
263         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
264         //  statement in the ClockAuction constructor). The result of this
265         //  function is always guaranteed to be <= _price.
266         return _price * ownerCut / 10000;
267     }
268 
269 }
270 
271 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
272 
273 /**
274  * @title Ownable
275  * @dev The Ownable contract has an owner address, and provides basic authorization control
276  * functions, this simplifies the implementation of "user permissions".
277  */
278 contract Ownable {
279   address public owner;
280 
281 
282   /**
283    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
284    * account.
285    */
286   function Ownable() {
287     owner = msg.sender;
288   }
289 
290 
291   /**
292    * @dev Throws if called by any account other than the owner.
293    */
294   modifier onlyOwner() {
295     require(msg.sender == owner);
296     _;
297   }
298 
299 
300   /**
301    * @dev Allows the current owner to transfer control of the contract to a newOwner.
302    * @param newOwner The address to transfer ownership to.
303    */
304   function transferOwnership(address newOwner) onlyOwner {
305     if (newOwner != address(0)) {
306       owner = newOwner;
307     }
308   }
309 
310 }
311 
312 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
313 
314 /**
315  * @title Pausable
316  * @dev Base contract which allows children to implement an emergency stop mechanism.
317  */
318 contract Pausable is Ownable {
319   event Pause();
320   event Unpause();
321 
322   bool public paused = false;
323 
324 
325   /**
326    * @dev modifier to allow actions only when the contract IS paused
327    */
328   modifier whenNotPaused() {
329     require(!paused);
330     _;
331   }
332 
333   /**
334    * @dev modifier to allow actions only when the contract IS NOT paused
335    */
336   modifier whenPaused {
337     require(paused);
338     _;
339   }
340 
341   /**
342    * @dev called by the owner to pause, triggers stopped state
343    */
344   function pause() onlyOwner whenNotPaused returns (bool) {
345     paused = true;
346     Pause();
347     return true;
348   }
349 
350   /**
351    * @dev called by the owner to unpause, returns to normal state
352    */
353   function unpause() onlyOwner whenPaused returns (bool) {
354     paused = false;
355     Unpause();
356     return true;
357   }
358 }
359 
360 // File: contracts-origin/Auction/ClockAuction.sol
361 
362 /// @title Clock auction for non-fungible tokens.
363 contract ClockAuction is Pausable, ClockAuctionBase {
364 
365     /// @dev Constructor creates a reference to the NFT ownership contract
366     ///  and verifies the owner cut is in the valid range.
367     /// @param _nftAddress - address of a deployed contract implementing
368     ///  the Nonfungible Interface.
369     /// @param _cut - percent cut the owner takes on each auction, must be
370     ///  between 0-10,000.
371     function ClockAuction(address _nftAddress, uint256 _cut) public {
372         require(_cut <= 10000);
373         ownerCut = _cut;
374         
375         ERC721 candidateContract = ERC721(_nftAddress);
376         require(candidateContract.implementsERC721());
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
391         nftAddress.transfer(this.balance);
392     }
393 
394     /// @dev Creates and begins a new auction.
395     /// @param _tokenId - ID of token to auction, sender must be owner.
396     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
397     /// @param _endingPrice - Price of item (in wei) at end of auction.
398     /// @param _duration - Length of time to move between starting
399     ///  price and ending price (in seconds).
400     /// @param _seller - Seller, if not the message sender
401     function createAuction(
402         uint256 _tokenId,
403         uint256 _startingPrice,
404         uint256 _endingPrice,
405         uint256 _duration,
406         address _seller
407     )
408         public
409         whenNotPaused
410         canBeStoredWith128Bits(_startingPrice)
411         canBeStoredWith128Bits(_endingPrice)
412         canBeStoredWith64Bits(_duration)
413     {
414         require(_owns(msg.sender, _tokenId));
415         _escrow(msg.sender, _tokenId);
416         Auction memory auction = Auction(
417             _seller,
418             uint128(_startingPrice),
419             uint128(_endingPrice),
420             uint64(_duration),
421             uint64(now)
422         );
423         _addAuction(_tokenId, auction);
424     }
425 
426     /// @dev Bids on an open auction, completing the auction and transferring
427     ///  ownership of the NFT if enough Ether is supplied.
428     /// @param _tokenId - ID of token to bid on.
429     function bid(uint256 _tokenId)
430         public
431         payable
432         whenNotPaused
433     {
434         // _bid will throw if the bid or funds transfer fails
435         _bid(_tokenId, msg.value);
436         _transfer(msg.sender, _tokenId);
437     }
438 
439     /// @dev Cancels an auction that hasn't been won yet.
440     ///  Returns the NFT to original owner.
441     /// @notice This is a state-modifying function that can
442     ///  be called while the contract is paused.
443     /// @param _tokenId - ID of token on auction
444     function cancelAuction(uint256 _tokenId)
445         public
446     {
447         Auction storage auction = tokenIdToAuction[_tokenId];
448         require(_isOnAuction(auction));
449         address seller = auction.seller;
450         require(msg.sender == seller);
451         _cancelAuction(_tokenId, seller);
452     }
453 
454     /// @dev Cancels an auction when the contract is paused.
455     ///  Only the owner may do this, and NFTs are returned to
456     ///  the seller. This should only be used in emergencies.
457     /// @param _tokenId - ID of the NFT on auction to cancel.
458     function cancelAuctionWhenPaused(uint256 _tokenId)
459         whenPaused
460         onlyOwner
461         public
462     {
463         Auction storage auction = tokenIdToAuction[_tokenId];
464         require(_isOnAuction(auction));
465         _cancelAuction(_tokenId, auction.seller);
466     }
467 
468     /// @dev Returns auction info for an NFT on auction.
469     /// @param _tokenId - ID of NFT on auction.
470     function getAuction(uint256 _tokenId)
471         public
472         view
473         returns
474     (
475         address seller,
476         uint256 startingPrice,
477         uint256 endingPrice,
478         uint256 duration,
479         uint256 startedAt
480     ) {
481         Auction storage auction = tokenIdToAuction[_tokenId];
482         require(_isOnAuction(auction));
483         return (
484             auction.seller,
485             auction.startingPrice,
486             auction.endingPrice,
487             auction.duration,
488             auction.startedAt
489         );
490     }
491 
492     /// @dev Returns the current price of an auction.
493     /// @param _tokenId - ID of the token price we are checking.
494     function getCurrentPrice(uint256 _tokenId)
495         public
496         view
497         returns (uint256)
498     {
499         Auction storage auction = tokenIdToAuction[_tokenId];
500         require(_isOnAuction(auction));
501         return _currentPrice(auction);
502     }
503 
504 }
505 
506 // File: contracts-origin/Auction/AetherClockAuction.sol
507 
508 /// @title Clock auction modified for sale of property
509 contract AetherClockAuction is ClockAuction {
510 
511     // @dev Sanity check that allows us to ensure that we are pointing to the
512     //  right auction in our setSaleAuctionAddress() call.
513     bool public isAetherClockAuction = true;
514 
515     // Tracks last 5 sale price of gen0 property sales
516     uint256 public saleCount;
517     uint256[5] public lastSalePrices;
518 
519     // Delegate constructor
520     function AetherClockAuction(address _nftAddr, uint256 _cut) public
521       ClockAuction(_nftAddr, _cut) {}
522 
523 
524     /// @dev Creates and begins a new auction.
525     /// @param _tokenId - ID of token to auction, sender must be owner.
526     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
527     /// @param _endingPrice - Price of item (in wei) at end of auction.
528     /// @param _duration - Length of auction (in seconds).
529     /// @param _seller - Seller, if not the message sender
530     function createAuction(
531         uint256 _tokenId,
532         uint256 _startingPrice,
533         uint256 _endingPrice,
534         uint256 _duration,
535         address _seller
536     )
537         public
538         canBeStoredWith128Bits(_startingPrice)
539         canBeStoredWith128Bits(_endingPrice)
540         canBeStoredWith64Bits(_duration)
541     {
542         require(msg.sender == address(nonFungibleContract));
543         _escrow(_seller, _tokenId);
544         Auction memory auction = Auction(
545             _seller,
546             uint128(_startingPrice),
547             uint128(_endingPrice),
548             uint64(_duration),
549             uint64(now)
550         );
551         _addAuction(_tokenId, auction);
552     }
553 
554     /// @dev Updates lastSalePrice if seller is the nft contract
555     /// Otherwise, works the same as default bid method.
556     function bid(uint256 _tokenId)
557         public
558         payable
559     {
560         // _bid verifies token ID size
561         address seller = tokenIdToAuction[_tokenId].seller;
562         uint256 price = _bid(_tokenId, msg.value);
563         _transfer(msg.sender, _tokenId);
564 
565         // If not a gen0 auction, exit
566         if (seller == address(nonFungibleContract)) {
567             // Track gen0 sale prices
568             lastSalePrices[saleCount % 5] = price;
569             saleCount++;
570         }
571     }
572 
573     function averageSalePrice() public view returns (uint256) {
574         uint256 sum = 0;
575         for (uint256 i = 0; i < 5; i++) {
576             sum += lastSalePrices[i];
577         }
578         return sum / 5;
579     }
580 }