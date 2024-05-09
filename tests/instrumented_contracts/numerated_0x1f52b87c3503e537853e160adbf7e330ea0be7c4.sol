1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * Interface for required functionality in the ERC721 standard
6  * for non-fungible tokens.
7  *
8  * Author: Nadav Hollander (nadav at dharma.io)
9  */
10 contract ERC721 {
11     // Function
12     function totalSupply() public view returns (uint256 _totalSupply);
13     function balanceOf(address _owner) public view returns (uint256 _balance);
14     function ownerOf(uint _tokenId) public view returns (address _owner);
15     function approve(address _to, uint _tokenId) public;
16     function transferFrom(address _from, address _to, uint _tokenId) public;
17     function transfer(address _to, uint _tokenId) public;
18     function implementsERC721() public view returns (bool _implementsERC721);
19 
20     // Events
21     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
22     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
23 }
24 
25 /// @title Auction Core
26 /// @dev Contains models, variables, and internal methods for the auction.
27 contract ClockAuctionBase {
28 
29     // Represents an auction on an NFT
30     struct Auction {
31         // Address of the NFT
32         address nftAddress;
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
46     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
47     // Values 0-10,000 map to 0%-100%
48     uint256 public ownerCut;
49 
50     // Map from token ID to their corresponding auction.
51     mapping (address => mapping(uint256 => Auction)) nftToTokenIdToAuction;
52 
53     event AuctionCreated(address nftAddress, uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
54     event AuctionSuccessful(address nftAddress, uint256 tokenId, uint256 totalPrice, address winner);
55     event AuctionCancelled(address nftAddress, uint256 tokenId);
56 
57     /// @dev DON'T give me your money.
58     function() external {}
59 
60     // Modifiers to check that inputs can be safely stored with a certain
61     // number of bits. We use constants and multiple modifiers to save gas.
62     modifier canBeStoredWith64Bits(uint256 _value) {
63         require(_value <= 18446744073709551615);
64         _;
65     }
66 
67     modifier canBeStoredWith128Bits(uint256 _value) {
68         require(_value < 340282366920938463463374607431768211455);
69         _;
70     }
71 
72     /// @dev Returns true if the claimant owns the token.
73     /// @param _nft - The address of the NFT.
74     /// @param _claimant - Address claiming to own the token.
75     /// @param _tokenId - ID of token whose ownership to verify.
76     function _owns(address _nft, address _claimant, uint256 _tokenId) internal view returns (bool) {
77         ERC721 nonFungibleContract = _getNft(_nft);
78         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
79     }
80 
81     /// @dev Escrows the NFT, assigning ownership to this contract.
82     /// Throws if the escrow fails.
83     /// @param _nft - The address of the NFT.
84     /// @param _owner - Current owner address of token to escrow.
85     /// @param _tokenId - ID of token whose approval to verify.
86     function _escrow(address _nft, address _owner, uint256 _tokenId) internal {
87         ERC721 nonFungibleContract = _getNft(_nft);
88 
89         // it will throw if transfer fails
90         nonFungibleContract.transferFrom(_owner, this, _tokenId);
91     }
92 
93     /// @dev Transfers an NFT owned by this contract to another address.
94     /// Returns true if the transfer succeeds.
95     /// @param _nft - The address of the NFT.
96     /// @param _receiver - Address to transfer NFT to.
97     /// @param _tokenId - ID of token to transfer.
98     function _transfer(address _nft, address _receiver, uint256 _tokenId) internal {
99         ERC721 nonFungibleContract = _getNft(_nft);
100 
101         // it will throw if transfer fails
102         nonFungibleContract.transfer(_receiver, _tokenId);
103     }
104 
105     /// @dev Adds an auction to the list of open auctions. Also fires the
106     ///  AuctionCreated event.
107     /// @param _tokenId The ID of the token to be put on auction.
108     /// @param _auction Auction to add.
109     function _addAuction(address _nft, uint256 _tokenId, Auction _auction) internal {
110         // Require that all auctions have a duration of
111         // at least one minute. (Keeps our math from getting hairy!)
112         require(_auction.duration >= 1 minutes);
113 
114         nftToTokenIdToAuction[_nft][_tokenId] = _auction;
115         
116         AuctionCreated(
117             address(_nft),
118             uint256(_tokenId),
119             uint256(_auction.startingPrice),
120             uint256(_auction.endingPrice),
121             uint256(_auction.duration)
122         );
123     }
124 
125     /// @dev Cancels an auction unconditionally.
126     function _cancelAuction(address _nft, uint256 _tokenId, address _seller) internal {
127         _removeAuction(_nft, _tokenId);
128         _transfer(_nft, _seller, _tokenId);
129         AuctionCancelled(_nft, _tokenId);
130     }
131 
132     /// @dev Computes the price and transfers winnings.
133     /// Does NOT transfer ownership of token.
134     function _bid(address _nft, uint256 _tokenId, uint256 _bidAmount)
135         internal
136         returns (uint256)
137     {
138         // Get a reference to the auction struct
139         Auction storage auction = nftToTokenIdToAuction[_nft][_tokenId];
140 
141         // Explicitly check that this auction is currently live.
142         // (Because of how Ethereum mappings work, we can't just count
143         // on the lookup above failing. An invalid _tokenId will just
144         // return an auction object that is all zeros.)
145         require(_isOnAuction(auction));
146 
147         // Check that the incoming bid is higher than the current
148         // price
149         uint256 price = _currentPrice(auction);
150         require(_bidAmount >= price);
151 
152         // Grab a reference to the seller before the auction struct
153         // gets deleted.
154         address seller = auction.seller;
155 
156         // The bid is good! Remove the auction before sending the fees
157         // to the sender so we can't have a reentrancy attack.
158         _removeAuction(_nft, _tokenId);
159 
160         // Transfer proceeds to seller (if there are any!)
161         if (price > 0) {
162             //  Calculate the auctioneer's cut.
163             // (NOTE: _computeCut() is guaranteed to return a
164             //  value <= price, so this subtraction can't go negative.)
165             uint256 auctioneerCut = _computeCut(price);
166             uint256 sellerProceeds = price - auctioneerCut;
167 
168             // NOTE: Doing a transfer() in the middle of a complex
169             // method like this is generally discouraged because of
170             // reentrancy attacks and DoS attacks if the seller is
171             // a contract with an invalid fallback function. We explicitly
172             // guard against reentrancy attacks by removing the auction
173             // before calling transfer(), and the only thing the seller
174             // can DoS is the sale of their own asset! (And if it's an
175             // accident, they can call cancelAuction(). )
176             seller.transfer(sellerProceeds);
177         }
178 
179         // Tell the world!
180         AuctionSuccessful(_nft, _tokenId, price, msg.sender);
181 
182         return price;
183     }
184 
185     /// @dev Removes an auction from the list of open auctions.
186     /// @param _tokenId - ID of NFT on auction.
187     function _removeAuction(address _nft, uint256 _tokenId) internal {
188         delete nftToTokenIdToAuction[_nft][_tokenId];
189     }
190 
191     /// @dev Returns true if the NFT is on auction.
192     /// @param _auction - Auction to check.
193     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
194         return (_auction.startedAt > 0);
195     }
196 
197     /// @dev Returns current price of an NFT on auction. Broken into two
198     ///  functions (this one, that computes the duration from the auction
199     ///  structure, and the other that does the price computation) so we
200     ///  can easily test that the price computation works correctly.
201     function _currentPrice(Auction storage _auction)
202         internal
203         view
204         returns (uint256)
205     {
206         uint256 secondsPassed = 0;
207         
208         // A bit of insurance against negative values (or wraparound).
209         // Probably not necessary (since Ethereum guarnatees that the
210         // now variable doesn't ever go backwards).
211         if (now > _auction.startedAt) {
212             secondsPassed = now - _auction.startedAt;
213         }
214 
215         return _computeCurrentPrice(
216             _auction.startingPrice,
217             _auction.endingPrice,
218             _auction.duration,
219             secondsPassed
220         );
221     }
222 
223     /// @dev Computes the current price of an auction. Factored out
224     ///  from _currentPrice so we can run extensive unit tests.
225     ///  When testing, make this function public and turn on
226     ///  `Current price computation` test suite.
227     function _computeCurrentPrice(
228         uint256 _startingPrice,
229         uint256 _endingPrice,
230         uint256 _duration,
231         uint256 _secondsPassed
232     )
233         internal
234         pure
235         returns (uint256)
236     {
237         // NOTE: We don't use SafeMath (or similar) in this function because
238         //  all of our public functions carefully cap the maximum values for
239         //  time (at 64-bits) and currency (at 128-bits). _duration is
240         //  also known to be non-zero (see the require() statement in
241         //  _addAuction())
242         if (_secondsPassed >= _duration) {
243             // We've reached the end of the dynamic pricing portion
244             // of the auction, just return the end price.
245             return _endingPrice;
246         } else {
247             // Starting price can be higher than ending price (and often is!), so
248             // this delta can be negative.
249             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
250             
251             // This multiplication can't overflow, _secondsPassed will easily fit within
252             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
253             // will always fit within 256-bits.
254             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
255             
256             // currentPriceChange can be negative, but if so, will have a magnitude
257             // less that _startingPrice. Thus, this result will always end up positive.
258             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
259             
260             return uint256(currentPrice);
261         }
262     }
263 
264     /// @dev Computes owner's cut of a sale.
265     /// @param _price - Sale price of NFT.
266     function _computeCut(uint256 _price) internal view returns (uint256) {
267         // NOTE: We don't use SafeMath (or similar) in this function because
268         //  all of our entry functions carefully cap the maximum values for
269         //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
270         //  statement in the ClockAuction constructor). The result of this
271         //  function is always guaranteed to be <= _price.
272         return _price * ownerCut / 10000;
273     }
274 
275     /// @dev Gets the NFT object from an address, validating that implementsERC721 is true.
276     /// @param _nft - Address of the NFT.
277     function _getNft(address _nft) internal view returns (ERC721) {
278         ERC721 candidateContract = ERC721(_nft);
279         //require(candidateContract.implementsERC721());
280         return candidateContract;
281     }
282 
283 }
284 
285 /**
286  * @title Ownable
287  * @dev The Ownable contract has an owner address, and provides basic authorization control
288  * functions, this simplifies the implementation of "user permissions".
289  */
290 contract Ownable {
291   address public owner;
292 
293 
294   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296 
297   /**
298    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
299    * account.
300    */
301   function Ownable() public {
302     owner = msg.sender;
303   }
304 
305 
306   /**
307    * @dev Throws if called by any account other than the owner.
308    */
309   modifier onlyOwner() {
310     require(msg.sender == owner);
311     _;
312   }
313 
314 
315   /**
316    * @dev Allows the current owner to transfer control of the contract to a newOwner.
317    * @param newOwner The address to transfer ownership to.
318    */
319   function transferOwnership(address newOwner) public onlyOwner {
320     require(newOwner != address(0));
321     OwnershipTransferred(owner, newOwner);
322     owner = newOwner;
323   }
324 
325 }
326 
327 /**
328  * @title Pausable
329  * @dev Base contract which allows children to implement an emergency stop mechanism.
330  */
331 contract Pausable is Ownable {
332   event Pause();
333   event Unpause();
334 
335   bool public paused = false;
336 
337 
338   /**
339    * @dev Modifier to make a function callable only when the contract is not paused.
340    */
341   modifier whenNotPaused() {
342     require(!paused);
343     _;
344   }
345 
346   /**
347    * @dev Modifier to make a function callable only when the contract is paused.
348    */
349   modifier whenPaused() {
350     require(paused);
351     _;
352   }
353 
354   /**
355    * @dev called by the owner to pause, triggers stopped state
356    */
357   function pause() onlyOwner whenNotPaused public {
358     paused = true;
359     Pause();
360   }
361 
362   /**
363    * @dev called by the owner to unpause, returns to normal state
364    */
365   function unpause() onlyOwner whenPaused public {
366     paused = false;
367     Unpause();
368   }
369 }
370 
371 /// @title Clock auction for non-fungible tokens.
372 contract ClockAuction is Pausable, ClockAuctionBase {
373 
374     /// @dev Constructor creates a reference to the NFT ownership contract
375     ///  and verifies the owner cut is in the valid range.
376     /// @param _cut - percent cut the owner takes on each auction, must be
377     ///  between 0-10,000.
378     function ClockAuction(uint256 _cut) public {
379         require(_cut <= 10000);
380         ownerCut = _cut;
381     }
382 
383     /// @dev Remove all Ether from the contract, which is the owner's cuts
384     ///  as well as any Ether sent directly to the contract address.
385     ///  Always transfers to the NFT contract, but can be called either by
386     ///  the owner or the NFT contract.
387     function withdrawBalance() external {
388         require(
389             msg.sender == owner
390         );
391         msg.sender.transfer(this.balance);
392     }
393 
394     /// @dev Creates and begins a new auction.
395     /// @param _nftAddress - address of a deployed contract implementing
396     ///  the Nonfungible Interface.
397     /// @param _tokenId - ID of token to auction, sender must be owner.
398     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
399     /// @param _endingPrice - Price of item (in wei) at end of auction.
400     /// @param _duration - Length of time to move between starting
401     ///  price and ending price (in seconds).
402     /// @param _seller - Seller, if not the message sender
403     function createAuction(
404         address _nftAddress,
405         uint256 _tokenId,
406         uint256 _startingPrice,
407         uint256 _endingPrice,
408         uint256 _duration,
409         address _seller
410     )
411         public
412         whenNotPaused
413         canBeStoredWith128Bits(_startingPrice)
414         canBeStoredWith128Bits(_endingPrice)
415         canBeStoredWith64Bits(_duration)
416     {
417         require(_owns(_nftAddress, msg.sender, _tokenId));
418         _escrow(_nftAddress, msg.sender, _tokenId);
419         Auction memory auction = Auction(
420             _nftAddress,
421             _seller,
422             uint128(_startingPrice),
423             uint128(_endingPrice),
424             uint64(_duration),
425             uint64(now)
426         );
427         _addAuction(_nftAddress, _tokenId, auction);
428     }
429 
430     /// @dev Bids on an open auction, completing the auction and transferring
431     ///  ownership of the NFT if enough Ether is supplied.
432     /// @param _nftAddress - address of a deployed contract implementing
433     ///  the Nonfungible Interface.
434     /// @param _tokenId - ID of token to bid on.
435     function bid(address _nftAddress, uint256 _tokenId)
436         public
437         payable
438         whenNotPaused
439     {
440         // _bid will throw if the bid or funds transfer fails
441         _bid(_nftAddress, _tokenId, msg.value);
442         _transfer(_nftAddress, msg.sender, _tokenId);
443     }
444 
445     /// @dev Cancels an auction that hasn't been won yet.
446     ///  Returns the NFT to original owner.
447     /// @notice This is a state-modifying function that can
448     ///  be called while the contract is paused.
449     /// @param _nftAddress - Address of the NFT.
450     /// @param _tokenId - ID of token on auction
451     function cancelAuction(address _nftAddress, uint256 _tokenId)
452         public
453     {
454         Auction storage auction = nftToTokenIdToAuction[_nftAddress][_tokenId];
455         require(_isOnAuction(auction));
456         address seller = auction.seller;
457         require(msg.sender == seller);
458         _cancelAuction(_nftAddress, _tokenId, seller);
459     }
460 
461     /// @dev Cancels an auction when the contract is paused.
462     ///  Only the owner may do this, and NFTs are returned to
463     ///  the seller. This should only be used in emergencies.
464     /// @param _nftAddress - Address of the NFT.
465     /// @param _tokenId - ID of the NFT on auction to cancel.
466     function cancelAuctionWhenPaused(address _nftAddress, uint256 _tokenId)
467         whenPaused
468         onlyOwner
469         public
470     {
471         Auction storage auction = nftToTokenIdToAuction[_nftAddress][_tokenId];
472         require(_isOnAuction(auction));
473         _cancelAuction(_nftAddress, _tokenId, auction.seller);
474     }
475 
476     /// @dev Returns auction info for an NFT on auction.
477     /// @param _nftAddress - Address of the NFT.
478     /// @param _tokenId - ID of NFT on auction.
479     function getAuction(address _nftAddress, uint256 _tokenId)
480         public
481         view
482         returns
483     (
484         address seller,
485         uint256 startingPrice,
486         uint256 endingPrice,
487         uint256 duration,
488         uint256 startedAt
489     ) {
490         Auction storage auction = nftToTokenIdToAuction[_nftAddress][_tokenId];
491         require(_isOnAuction(auction));
492         return (
493             auction.seller,
494             auction.startingPrice,
495             auction.endingPrice,
496             auction.duration,
497             auction.startedAt
498         );
499     }
500 
501     /// @dev Returns the current price of an auction.
502     /// @param _nftAddress - Address of the NFT.
503     /// @param _tokenId - ID of the token price we are checking.
504     function getCurrentPrice(address _nftAddress, uint256 _tokenId)
505         public
506         view
507         returns (uint256)
508     {
509         Auction storage auction = nftToTokenIdToAuction[_nftAddress][_tokenId];
510         require(_isOnAuction(auction));
511         return _currentPrice(auction);
512     }
513 
514 }
515 
516 /// @title Clock auction modified for sale of kitties
517 contract SaleClockAuction is ClockAuction {
518 
519     // Delegate constructor
520     function SaleClockAuction(uint256 _cut) public
521         ClockAuction(_cut) {}
522 
523     /// @dev Creates and begins a new auction.
524     /// @param _nftAddress - The address of the NFT.
525     /// @param _tokenId - ID of token to auction, sender must be owner.
526     /// @param _startingPrice - Price of item (in wei) at beginning of auction.
527     /// @param _endingPrice - Price of item (in wei) at end of auction.
528     /// @param _duration - Length of auction (in seconds).
529     function createAuction(
530         address _nftAddress,
531         uint256 _tokenId,
532         uint256 _startingPrice,
533         uint256 _endingPrice,
534         uint256 _duration
535     )
536         public
537         canBeStoredWith128Bits(_startingPrice)
538         canBeStoredWith128Bits(_endingPrice)
539         canBeStoredWith64Bits(_duration)
540     {
541         address seller = msg.sender;
542         _escrow(_nftAddress, seller, _tokenId);
543         Auction memory auction = Auction(
544             _nftAddress,
545             seller,
546             uint128(_startingPrice),
547             uint128(_endingPrice),
548             uint64(_duration),
549             uint64(now)
550         );
551         _addAuction(_nftAddress, _tokenId, auction);
552     }
553 
554     /// @dev Updates lastSalePrice if seller is the nft contract
555     /// Otherwise, works the same as default bid method.
556     function bid(address _nftAddress, uint256 _tokenId)
557         public
558         payable
559     {
560         // _bid verifies token ID size
561         address seller = nftToTokenIdToAuction[_nftAddress][_tokenId].seller;
562         uint256 price = _bid(_nftAddress, _tokenId, msg.value);
563         _transfer(_nftAddress, msg.sender, _tokenId);
564     }
565 }