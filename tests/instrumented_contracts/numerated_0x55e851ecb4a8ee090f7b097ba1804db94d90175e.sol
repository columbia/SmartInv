1 pragma solidity ^0.4.20;
2 
3 
4 
5 contract CutieCoreInterface
6 {
7     function isCutieCore() pure public returns (bool);
8 
9     function transferFrom(address _from, address _to, uint256 _cutieId) external;
10     function transfer(address _to, uint256 _cutieId) external;
11 
12     function ownerOf(uint256 _cutieId)
13         external
14         view
15         returns (address owner);
16 
17     function getCutie(uint40 _id)
18         external
19         view
20         returns (
21         uint256 genes,
22         uint40 birthTime,
23         uint40 cooldownEndTime,
24         uint40 momId,
25         uint40 dadId,
26         uint16 cooldownIndex,
27         uint16 generation
28     );
29 
30     function getGenes(uint40 _id)
31         public
32         view
33         returns (
34         uint256 genes
35     );
36 
37 
38     function getCooldownEndTime(uint40 _id)
39         public
40         view
41         returns (
42         uint40 cooldownEndTime
43     );
44 
45     function getCooldownIndex(uint40 _id)
46         public
47         view
48         returns (
49         uint16 cooldownIndex
50     );
51 
52 
53     function getGeneration(uint40 _id)
54         public
55         view
56         returns (
57         uint16 generation
58     );
59 
60     function getOptional(uint40 _id)
61         public
62         view
63         returns (
64         uint64 optional
65     );
66 
67 
68     function changeGenes(
69         uint40 _cutieId,
70         uint256 _genes)
71         public;
72 
73     function changeCooldownEndTime(
74         uint40 _cutieId,
75         uint40 _cooldownEndTime)
76         public;
77 
78     function changeCooldownIndex(
79         uint40 _cutieId,
80         uint16 _cooldownIndex)
81         public;
82 
83     function changeOptional(
84         uint40 _cutieId,
85         uint64 _optional)
86         public;
87 
88     function changeGeneration(
89         uint40 _cutieId,
90         uint16 _generation)
91         public;
92 }
93 
94 
95 
96 
97 
98 
99 
100 /**
101  * @title Ownable
102  * @dev The Ownable contract has an owner address, and provides basic authorization control
103  * functions, this simplifies the implementation of "user permissions".
104  */
105 contract Ownable {
106   address public owner;
107 
108 
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111 
112   /**
113    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
114    * account.
115    */
116   function Ownable() public {
117     owner = msg.sender;
118   }
119 
120   /**
121    * @dev Throws if called by any account other than the owner.
122    */
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   /**
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address newOwner) public onlyOwner {
133     require(newOwner != address(0));
134     emit OwnershipTransferred(owner, newOwner);
135     owner = newOwner;
136   }
137 
138 }
139 
140 
141 
142 /**
143  * @title Pausable
144  * @dev Base contract which allows children to implement an emergency stop mechanism.
145  */
146 contract Pausable is Ownable {
147   event Pause();
148   event Unpause();
149 
150   bool public paused = false;
151 
152 
153   /**
154    * @dev Modifier to make a function callable only when the contract is not paused.
155    */
156   modifier whenNotPaused() {
157     require(!paused);
158     _;
159   }
160 
161   /**
162    * @dev Modifier to make a function callable only when the contract is paused.
163    */
164   modifier whenPaused() {
165     require(paused);
166     _;
167   }
168 
169   /**
170    * @dev called by the owner to pause, triggers stopped state
171    */
172   function pause() onlyOwner whenNotPaused public {
173     paused = true;
174     emit Pause();
175   }
176 
177   /**
178    * @dev called by the owner to unpause, returns to normal state
179    */
180   function unpause() onlyOwner whenPaused public {
181     paused = false;
182     emit Unpause();
183   }
184 }
185 
186 
187 
188 /// @title Auction Market for Blockchain Cuties.
189 /// @author https://BlockChainArchitect.io
190 contract MarketInterface 
191 {
192     function withdrawEthFromBalance() external;    
193 
194     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
195 
196     function bid(uint40 _cutieId) public payable;
197 
198     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
199 
200 	function getAuctionInfo(uint40 _cutieId)
201         public
202         view
203         returns
204     (
205         address seller,
206         uint128 startPrice,
207         uint128 endPrice,
208         uint40 duration,
209         uint40 startedAt,
210         uint128 featuringFee
211     );
212 }
213 
214 
215 /// @title Auction Market for Blockchain Cuties.
216 /// @author https://BlockChainArchitect.io
217 contract Market is MarketInterface, Pausable
218 {
219     // Shows the auction on an Cutie Token
220     struct Auction {
221         // Price (in wei) at the beginning of auction
222         uint128 startPrice;
223         // Price (in wei) at the end of auction
224         uint128 endPrice;
225         // Current owner of Token
226         address seller;
227         // Auction duration in seconds
228         uint40 duration;
229         // Time when auction started
230         // NOTE: 0 if this auction has been concluded
231         uint40 startedAt;
232         // Featuring fee (in wei, optional)
233         uint128 featuringFee;
234     }
235 
236     // Reference to contract that tracks ownership
237     CutieCoreInterface public coreContract;
238 
239     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
240     // Values 0-10,000 map to 0%-100%
241     uint16 public ownerFee;
242 
243     // Map from token ID to their corresponding auction.
244     mapping (uint40 => Auction) public cutieIdToAuction;
245 
246     event AuctionCreated(uint40 cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee);
247     event AuctionSuccessful(uint40 cutieId, uint128 totalPrice, address winner);
248     event AuctionCancelled(uint40 cutieId);
249 
250     /// @dev disables sending fund to this contract
251     function() external {}
252 
253     modifier canBeStoredIn128Bits(uint256 _value) 
254     {
255         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
256         _;
257     }
258 
259     // @dev Adds to the list of open auctions and fires the
260     //  AuctionCreated event.
261     // @param _cutieId The token ID is to be put on auction.
262     // @param _auction To add an auction.
263     // @param _fee Amount of money to feature auction
264     function _addAuction(uint40 _cutieId, Auction _auction) internal
265     {
266         // Require that all auctions have a duration of
267         // at least one minute. (Keeps our math from getting hairy!)
268         require(_auction.duration >= 1 minutes);
269 
270         cutieIdToAuction[_cutieId] = _auction;
271         
272         emit AuctionCreated(
273             _cutieId,
274             _auction.startPrice,
275             _auction.endPrice,
276             _auction.duration,
277             _auction.featuringFee
278         );
279     }
280 
281     // @dev Returns true if the token is claimed by the claimant.
282     // @param _claimant - Address claiming to own the token.
283     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
284     {
285         return (coreContract.ownerOf(_cutieId) == _claimant);
286     }
287 
288     // @dev Transfers the token owned by this contract to another address.
289     // Returns true when the transfer succeeds.
290     // @param _receiver - Address to transfer token to.
291     // @param _cutieId - Token ID to transfer.
292     function _transfer(address _receiver, uint40 _cutieId) internal
293     {
294         // it will throw if transfer fails
295         coreContract.transfer(_receiver, _cutieId);
296     }
297 
298     // @dev Escrows the token and assigns ownership to this contract.
299     // Throws if the escrow fails.
300     // @param _owner - Current owner address of token to escrow.
301     // @param _cutieId - Token ID the approval of which is to be verified.
302     function _escrow(address _owner, uint40 _cutieId) internal
303     {
304         // it will throw if transfer fails
305         coreContract.transferFrom(_owner, this, _cutieId);
306     }
307 
308     // @dev just cancel auction.
309     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
310     {
311         _removeAuction(_cutieId);
312         _transfer(_seller, _cutieId);
313         emit AuctionCancelled(_cutieId);
314     }
315 
316     // @dev Calculates the price and transfers winnings.
317     // Does not transfer token ownership.
318     function _bid(uint40 _cutieId, uint128 _bidAmount)
319         internal
320         returns (uint128)
321     {
322         // Get a reference to the auction struct
323         Auction storage auction = cutieIdToAuction[_cutieId];
324 
325         require(_isOnAuction(auction));
326 
327         // Check that bid > current price
328         uint128 price = _currentPrice(auction);
329         require(_bidAmount >= price);
330 
331         // Provide a reference to the seller before the auction struct is deleted.
332         address seller = auction.seller;
333 
334         _removeAuction(_cutieId);
335 
336         // Transfer proceeds to seller (if there are any!)
337         if (price > 0) {
338             uint128 fee = _computeFee(price);
339             uint128 sellerValue = price - fee;
340 
341             seller.transfer(sellerValue);
342         }
343 
344         emit AuctionSuccessful(_cutieId, price, msg.sender);
345 
346         return price;
347     }
348 
349     // @dev Removes from the list of open auctions.
350     // @param _cutieId - ID of token on auction.
351     function _removeAuction(uint40 _cutieId) internal
352     {
353         delete cutieIdToAuction[_cutieId];
354     }
355 
356     // @dev Returns true if the token is on auction.
357     // @param _auction - Auction to check.
358     function _isOnAuction(Auction storage _auction) internal view returns (bool)
359     {
360         return (_auction.startedAt > 0);
361     }
362 
363     // @dev calculate current price of auction. 
364     //  When testing, make this function public and turn on
365     //  `Current price calculation` test suite.
366     function _computeCurrentPrice(
367         uint128 _startPrice,
368         uint128 _endPrice,
369         uint40 _duration,
370         uint40 _secondsPassed
371     )
372         internal
373         pure
374         returns (uint128)
375     {
376         if (_secondsPassed >= _duration) {
377             return _endPrice;
378         } else {
379             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
380             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
381             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
382             
383             return currentPrice;
384         }
385     }
386     // @dev return current price of token.
387     function _currentPrice(Auction storage _auction)
388         internal
389         view
390         returns (uint128)
391     {
392         uint40 secondsPassed = 0;
393 
394         uint40 timeNow = uint40(now);
395         if (timeNow > _auction.startedAt) {
396             secondsPassed = timeNow - _auction.startedAt;
397         }
398 
399         return _computeCurrentPrice(
400             _auction.startPrice,
401             _auction.endPrice,
402             _auction.duration,
403             secondsPassed
404         );
405     }
406 
407     // @dev Calculates owner's cut of a sale.
408     // @param _price - Sale price of cutie.
409     function _computeFee(uint128 _price) internal view returns (uint128)
410     {
411         return _price * ownerFee / 10000;
412     }
413 
414     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
415     //  Transfers to the token contract, but can be called by
416     //  the owner or the token contract.
417     function withdrawEthFromBalance() external
418     {
419         address coreAddress = address(coreContract);
420 
421         require(
422             msg.sender == owner ||
423             msg.sender == coreAddress
424         );
425         coreAddress.transfer(address(this).balance);
426     }
427 
428     // @dev create and begin new auction.
429     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
430         public whenNotPaused payable
431     {
432         require(_isOwner(msg.sender, _cutieId));
433         _escrow(msg.sender, _cutieId);
434         Auction memory auction = Auction(
435             _startPrice,
436             _endPrice,
437             _seller,
438             _duration,
439             uint40(now),
440             uint128(msg.value)
441         );
442         _addAuction(_cutieId, auction);
443     }
444 
445     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
446     //  @param fee should be between 0-10,000.
447     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
448     {
449         require(_fee <= 10000);
450 
451         ownerFee = _fee;
452         
453         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
454         require(candidateContract.isCutieCore());
455         coreContract = candidateContract;
456     }
457 
458     // @dev Set the owner's fee.
459     //  @param fee should be between 0-10,000.
460     function setFee(uint16 _fee) public onlyOwner
461     {
462         require(_fee <= 10000);
463 
464         ownerFee = _fee;
465     }
466 
467     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
468     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
469     {
470         // _bid throws if something failed.
471         _bid(_cutieId, uint128(msg.value));
472         _transfer(msg.sender, _cutieId);
473     }
474 
475     // @dev Returns auction info for a token on auction.
476     // @param _cutieId - ID of token on auction.
477     function getAuctionInfo(uint40 _cutieId)
478         public
479         view
480         returns
481     (
482         address seller,
483         uint128 startPrice,
484         uint128 endPrice,
485         uint40 duration,
486         uint40 startedAt,
487         uint128 featuringFee
488     ) {
489         Auction storage auction = cutieIdToAuction[_cutieId];
490         require(_isOnAuction(auction));
491         return (
492             auction.seller,
493             auction.startPrice,
494             auction.endPrice,
495             auction.duration,
496             auction.startedAt,
497             auction.featuringFee
498         );
499     }
500 
501     // @dev Returns auction info for a token on auction.
502     // @param _cutieId - ID of token on auction.
503     function isOnAuction(uint40 _cutieId)
504         public
505         view
506         returns (bool) 
507     {
508         return cutieIdToAuction[_cutieId].startedAt > 0;
509     }
510 
511 /*
512     /// @dev Import cuties from previous version of Core contract.
513     /// @param _oldAddress Old core contract address
514     /// @param _fromIndex (inclusive)
515     /// @param _toIndex (inclusive)
516     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
517     {
518         Market old = Market(_oldAddress);
519 
520         for (uint40 i = _fromIndex; i <= _toIndex; i++)
521         {
522             if (coreContract.ownerOf(i) == _oldAddress)
523             {
524                 address seller;
525                 uint128 startPrice;
526                 uint128 endPrice;
527                 uint40 duration;
528                 uint40 startedAt;
529                 uint128 featuringFee;   
530                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
531 
532                 Auction memory auction = Auction({
533                     seller: seller, 
534                     startPrice: startPrice, 
535                     endPrice: endPrice, 
536                     duration: duration, 
537                     startedAt: startedAt, 
538                     featuringFee: featuringFee
539                 });
540                 _addAuction(i, auction);
541             }
542         }
543     }*/
544 
545     // @dev Returns the current price of an auction.
546     function getCurrentPrice(uint40 _cutieId)
547         public
548         view
549         returns (uint128)
550     {
551         Auction storage auction = cutieIdToAuction[_cutieId];
552         require(_isOnAuction(auction));
553         return _currentPrice(auction);
554     }
555 
556     // @dev Cancels unfinished auction and returns token to owner. 
557     // Can be called when contract is paused.
558     function cancelActiveAuction(uint40 _cutieId) public
559     {
560         Auction storage auction = cutieIdToAuction[_cutieId];
561         require(_isOnAuction(auction));
562         address seller = auction.seller;
563         require(msg.sender == seller);
564         _cancelActiveAuction(_cutieId, seller);
565     }
566 
567     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
568     //  Used on Core contract upgrade.
569     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
570     {
571         Auction storage auction = cutieIdToAuction[_cutieId];
572         require(_isOnAuction(auction));
573         _cancelActiveAuction(_cutieId, auction.seller);
574     }
575 }
576 
577 
578 /// @title Auction market for cuties sale 
579 /// @author https://BlockChainArchitect.io
580 contract SaleMarket is Market
581 {
582     // @dev Sanity check reveals that the
583     //  auction in our setSaleAuctionAddress() call is right.
584     bool public isSaleMarket = true;
585     
586 
587     // @dev create and start a new auction
588     // @param _cutieId - ID of cutie to auction, sender must be owner.
589     // @param _startPrice - Price of item (in wei) at the beginning of auction.
590     // @param _endPrice - Price of item (in wei) at the end of auction.
591     // @param _duration - Length of auction (in seconds).
592     // @param _seller - Seller
593     function createAuction(
594         uint40 _cutieId,
595         uint128 _startPrice,
596         uint128 _endPrice,
597         uint40 _duration,
598         address _seller
599     )
600         public
601         payable
602     {
603         require(msg.sender == address(coreContract));
604         _escrow(_seller, _cutieId);
605         Auction memory auction = Auction(
606             _startPrice,
607             _endPrice,
608             _seller,
609             _duration,
610             uint40(now),
611             uint128(msg.value)
612         );
613         _addAuction(_cutieId, auction);
614     }
615 
616     // @dev LastSalePrice is updated if seller is the token contract.
617     // Otherwise, default bid method is used.
618     function bid(uint40 _cutieId)
619         public
620         payable
621         canBeStoredIn128Bits(msg.value)
622     {
623         // _bid verifies token ID size
624         _bid(_cutieId, uint128(msg.value));
625         _transfer(msg.sender, _cutieId);
626 
627     }
628 }