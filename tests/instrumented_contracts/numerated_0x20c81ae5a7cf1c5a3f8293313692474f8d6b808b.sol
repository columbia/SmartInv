1 pragma solidity ^0.4.20;
2 
3 contract CutieCoreInterface
4 {
5     function isCutieCore() pure public returns (bool);
6 
7     function transferFrom(address _from, address _to, uint256 _cutieId) external;
8     function transfer(address _to, uint256 _cutieId) external;
9 
10     function ownerOf(uint256 _cutieId)
11         external
12         view
13         returns (address owner);
14 
15     function getCutie(uint40 _id)
16         external
17         view
18         returns (
19         uint256 genes,
20         uint40 birthTime,
21         uint40 cooldownEndTime,
22         uint40 momId,
23         uint40 dadId,
24         uint16 cooldownIndex,
25         uint16 generation
26     );
27 
28     function getGenes(uint40 _id)
29         public
30         view
31         returns (
32         uint256 genes
33     );
34 
35 
36     function getCooldownEndTime(uint40 _id)
37         public
38         view
39         returns (
40         uint40 cooldownEndTime
41     );
42 
43     function getCooldownIndex(uint40 _id)
44         public
45         view
46         returns (
47         uint16 cooldownIndex
48     );
49 
50 
51     function getGeneration(uint40 _id)
52         public
53         view
54         returns (
55         uint16 generation
56     );
57 
58     function getOptional(uint40 _id)
59         public
60         view
61         returns (
62         uint64 optional
63     );
64 
65 
66     function changeGenes(
67         uint40 _cutieId,
68         uint256 _genes)
69         public;
70 
71     function changeCooldownEndTime(
72         uint40 _cutieId,
73         uint40 _cooldownEndTime)
74         public;
75 
76     function changeCooldownIndex(
77         uint40 _cutieId,
78         uint16 _cooldownIndex)
79         public;
80 
81     function changeOptional(
82         uint40 _cutieId,
83         uint64 _optional)
84         public;
85 
86     function changeGeneration(
87         uint40 _cutieId,
88         uint16 _generation)
89         public;
90 }
91 
92 
93 
94 
95 
96 
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     emit OwnershipTransferred(owner, newOwner);
133     owner = newOwner;
134   }
135 
136 }
137 
138 
139 
140 /**
141  * @title Pausable
142  * @dev Base contract which allows children to implement an emergency stop mechanism.
143  */
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147 
148   bool public paused = false;
149 
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenNotPaused() {
155     require(!paused);
156     _;
157   }
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is paused.
161    */
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166 
167   /**
168    * @dev called by the owner to pause, triggers stopped state
169    */
170   function pause() onlyOwner whenNotPaused public {
171     paused = true;
172     emit Pause();
173   }
174 
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() onlyOwner whenPaused public {
179     paused = false;
180     emit Unpause();
181   }
182 }
183 
184 
185 
186 /// @title Auction Market for Blockchain Cuties.
187 /// @author https://BlockChainArchitect.io
188 contract MarketInterface 
189 {
190     function withdrawEthFromBalance() external;    
191 
192     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
193 
194     function bid(uint40 _cutieId) public payable;
195 
196     function cancelActiveAuctionWhenPaused(uint40 _cutieId) public;
197 
198 	function getAuctionInfo(uint40 _cutieId)
199         public
200         view
201         returns
202     (
203         address seller,
204         uint128 startPrice,
205         uint128 endPrice,
206         uint40 duration,
207         uint40 startedAt,
208         uint128 featuringFee
209     );
210 }
211 
212 
213 /// @title Auction Market for Blockchain Cuties.
214 /// @author https://BlockChainArchitect.io
215 contract Market is MarketInterface, Pausable
216 {
217     // Shows the auction on an Cutie Token
218     struct Auction {
219         // Price (in wei) at the beginning of auction
220         uint128 startPrice;
221         // Price (in wei) at the end of auction
222         uint128 endPrice;
223         // Current owner of Token
224         address seller;
225         // Auction duration in seconds
226         uint40 duration;
227         // Time when auction started
228         // NOTE: 0 if this auction has been concluded
229         uint40 startedAt;
230         // Featuring fee (in wei, optional)
231         uint128 featuringFee;
232     }
233 
234     // Reference to contract that tracks ownership
235     CutieCoreInterface public coreContract;
236 
237     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
238     // Values 0-10,000 map to 0%-100%
239     uint16 public ownerFee;
240 
241     // Map from token ID to their corresponding auction.
242     mapping (uint40 => Auction) public cutieIdToAuction;
243 
244     event AuctionCreated(uint40 cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee);
245     event AuctionSuccessful(uint40 cutieId, uint128 totalPrice, address winner);
246     event AuctionCancelled(uint40 cutieId);
247 
248     /// @dev disables sending fund to this contract
249     function() external {}
250 
251     modifier canBeStoredIn128Bits(uint256 _value) 
252     {
253         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
254         _;
255     }
256 
257     // @dev Adds to the list of open auctions and fires the
258     //  AuctionCreated event.
259     // @param _cutieId The token ID is to be put on auction.
260     // @param _auction To add an auction.
261     // @param _fee Amount of money to feature auction
262     function _addAuction(uint40 _cutieId, Auction _auction) internal
263     {
264         // Require that all auctions have a duration of
265         // at least one minute. (Keeps our math from getting hairy!)
266         require(_auction.duration >= 1 minutes);
267 
268         cutieIdToAuction[_cutieId] = _auction;
269         
270         emit AuctionCreated(
271             _cutieId,
272             _auction.startPrice,
273             _auction.endPrice,
274             _auction.duration,
275             _auction.featuringFee
276         );
277     }
278 
279     // @dev Returns true if the token is claimed by the claimant.
280     // @param _claimant - Address claiming to own the token.
281     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
282     {
283         return (coreContract.ownerOf(_cutieId) == _claimant);
284     }
285 
286     // @dev Transfers the token owned by this contract to another address.
287     // Returns true when the transfer succeeds.
288     // @param _receiver - Address to transfer token to.
289     // @param _cutieId - Token ID to transfer.
290     function _transfer(address _receiver, uint40 _cutieId) internal
291     {
292         // it will throw if transfer fails
293         coreContract.transfer(_receiver, _cutieId);
294     }
295 
296     // @dev Escrows the token and assigns ownership to this contract.
297     // Throws if the escrow fails.
298     // @param _owner - Current owner address of token to escrow.
299     // @param _cutieId - Token ID the approval of which is to be verified.
300     function _escrow(address _owner, uint40 _cutieId) internal
301     {
302         // it will throw if transfer fails
303         coreContract.transferFrom(_owner, this, _cutieId);
304     }
305 
306     // @dev just cancel auction.
307     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
308     {
309         _removeAuction(_cutieId);
310         _transfer(_seller, _cutieId);
311         emit AuctionCancelled(_cutieId);
312     }
313 
314     // @dev Calculates the price and transfers winnings.
315     // Does not transfer token ownership.
316     function _bid(uint40 _cutieId, uint128 _bidAmount)
317         internal
318         returns (uint128)
319     {
320         // Get a reference to the auction struct
321         Auction storage auction = cutieIdToAuction[_cutieId];
322 
323         require(_isOnAuction(auction));
324 
325         // Check that bid > current price
326         uint128 price = _currentPrice(auction);
327         require(_bidAmount >= price);
328 
329         // Provide a reference to the seller before the auction struct is deleted.
330         address seller = auction.seller;
331 
332         _removeAuction(_cutieId);
333 
334         // Transfer proceeds to seller (if there are any!)
335         if (price > 0) {
336             uint128 fee = _computeFee(price);
337             uint128 sellerValue = price - fee;
338 
339             seller.transfer(sellerValue);
340         }
341 
342         emit AuctionSuccessful(_cutieId, price, msg.sender);
343 
344         return price;
345     }
346 
347     // @dev Removes from the list of open auctions.
348     // @param _cutieId - ID of token on auction.
349     function _removeAuction(uint40 _cutieId) internal
350     {
351         delete cutieIdToAuction[_cutieId];
352     }
353 
354     // @dev Returns true if the token is on auction.
355     // @param _auction - Auction to check.
356     function _isOnAuction(Auction storage _auction) internal view returns (bool)
357     {
358         return (_auction.startedAt > 0);
359     }
360 
361     // @dev calculate current price of auction. 
362     //  When testing, make this function public and turn on
363     //  `Current price calculation` test suite.
364     function _computeCurrentPrice(
365         uint128 _startPrice,
366         uint128 _endPrice,
367         uint40 _duration,
368         uint40 _secondsPassed
369     )
370         internal
371         pure
372         returns (uint128)
373     {
374         if (_secondsPassed >= _duration) {
375             return _endPrice;
376         } else {
377             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
378             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
379             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
380             
381             return currentPrice;
382         }
383     }
384     // @dev return current price of token.
385     function _currentPrice(Auction storage _auction)
386         internal
387         view
388         returns (uint128)
389     {
390         uint40 secondsPassed = 0;
391 
392         uint40 timeNow = uint40(now);
393         if (timeNow > _auction.startedAt) {
394             secondsPassed = timeNow - _auction.startedAt;
395         }
396 
397         return _computeCurrentPrice(
398             _auction.startPrice,
399             _auction.endPrice,
400             _auction.duration,
401             secondsPassed
402         );
403     }
404 
405     // @dev Calculates owner's cut of a sale.
406     // @param _price - Sale price of cutie.
407     function _computeFee(uint128 _price) internal view returns (uint128)
408     {
409         return _price * ownerFee / 10000;
410     }
411 
412     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
413     //  Transfers to the token contract, but can be called by
414     //  the owner or the token contract.
415     function withdrawEthFromBalance() external
416     {
417         address coreAddress = address(coreContract);
418 
419         require(
420             msg.sender == owner ||
421             msg.sender == coreAddress
422         );
423         coreAddress.transfer(address(this).balance);
424     }
425 
426     // @dev create and begin new auction.
427     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
428         public whenNotPaused payable
429     {
430         require(_isOwner(msg.sender, _cutieId));
431         _escrow(msg.sender, _cutieId);
432         Auction memory auction = Auction(
433             _startPrice,
434             _endPrice,
435             _seller,
436             _duration,
437             uint40(now),
438             uint128(msg.value)
439         );
440         _addAuction(_cutieId, auction);
441     }
442 
443     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
444     //  @param fee should be between 0-10,000.
445     function setup(address _coreContractAddress, uint16 _fee) public onlyOwner
446     {
447         require(_fee <= 10000);
448 
449         ownerFee = _fee;
450         
451         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
452         require(candidateContract.isCutieCore());
453         coreContract = candidateContract;
454     }
455 
456     // @dev Set the owner's fee.
457     //  @param fee should be between 0-10,000.
458     function setFee(uint16 _fee) public onlyOwner
459     {
460         require(_fee <= 10000);
461 
462         ownerFee = _fee;
463     }
464 
465     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
466     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
467     {
468         // _bid throws if something failed.
469         _bid(_cutieId, uint128(msg.value));
470         _transfer(msg.sender, _cutieId);
471     }
472 
473     // @dev Returns auction info for a token on auction.
474     // @param _cutieId - ID of token on auction.
475     function getAuctionInfo(uint40 _cutieId)
476         public
477         view
478         returns
479     (
480         address seller,
481         uint128 startPrice,
482         uint128 endPrice,
483         uint40 duration,
484         uint40 startedAt,
485         uint128 featuringFee
486     ) {
487         Auction storage auction = cutieIdToAuction[_cutieId];
488         require(_isOnAuction(auction));
489         return (
490             auction.seller,
491             auction.startPrice,
492             auction.endPrice,
493             auction.duration,
494             auction.startedAt,
495             auction.featuringFee
496         );
497     }
498 
499     // @dev Returns auction info for a token on auction.
500     // @param _cutieId - ID of token on auction.
501     function isOnAuction(uint40 _cutieId)
502         public
503         view
504         returns (bool) 
505     {
506         return cutieIdToAuction[_cutieId].startedAt > 0;
507     }
508 
509 /*
510     /// @dev Import cuties from previous version of Core contract.
511     /// @param _oldAddress Old core contract address
512     /// @param _fromIndex (inclusive)
513     /// @param _toIndex (inclusive)
514     function migrate(address _oldAddress, uint40 _fromIndex, uint40 _toIndex) public onlyOwner whenPaused
515     {
516         Market old = Market(_oldAddress);
517 
518         for (uint40 i = _fromIndex; i <= _toIndex; i++)
519         {
520             if (coreContract.ownerOf(i) == _oldAddress)
521             {
522                 address seller;
523                 uint128 startPrice;
524                 uint128 endPrice;
525                 uint40 duration;
526                 uint40 startedAt;
527                 uint128 featuringFee;   
528                 (seller, startPrice, endPrice, duration, startedAt, featuringFee) = old.getAuctionInfo(i);
529 
530                 Auction memory auction = Auction({
531                     seller: seller, 
532                     startPrice: startPrice, 
533                     endPrice: endPrice, 
534                     duration: duration, 
535                     startedAt: startedAt, 
536                     featuringFee: featuringFee
537                 });
538                 _addAuction(i, auction);
539             }
540         }
541     }*/
542 
543     // @dev Returns the current price of an auction.
544     function getCurrentPrice(uint40 _cutieId)
545         public
546         view
547         returns (uint128)
548     {
549         Auction storage auction = cutieIdToAuction[_cutieId];
550         require(_isOnAuction(auction));
551         return _currentPrice(auction);
552     }
553 
554     // @dev Cancels unfinished auction and returns token to owner. 
555     // Can be called when contract is paused.
556     function cancelActiveAuction(uint40 _cutieId) public
557     {
558         Auction storage auction = cutieIdToAuction[_cutieId];
559         require(_isOnAuction(auction));
560         address seller = auction.seller;
561         require(msg.sender == seller);
562         _cancelActiveAuction(_cutieId, seller);
563     }
564 
565     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
566     //  Used on Core contract upgrade.
567     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
568     {
569         Auction storage auction = cutieIdToAuction[_cutieId];
570         require(_isOnAuction(auction));
571         _cancelActiveAuction(_cutieId, auction.seller);
572     }
573 }
574 
575 
576 /// @title Auction market for breeding
577 /// @author https://BlockChainArchitect.io
578 contract BreedingMarket is Market
579 {
580     bool public isBreedingMarket = true;
581 
582     // @dev Launches and starts a new auction.
583     function createAuction(
584         uint40 _cutieId,
585         uint128 _startPrice,
586         uint128 _endPrice,
587         uint40 _duration,
588         address _seller)
589         public payable
590     {
591         require(msg.sender == address(coreContract));
592         _escrow(_seller, _cutieId);
593         Auction memory auction = Auction(
594             _startPrice,
595             _endPrice,
596             _seller,
597             _duration,
598             uint40(now),
599             uint128(msg.value)
600         );
601         _addAuction(_cutieId, auction);
602     }
603 
604     /// @dev Places a bid for breeding. Requires the sender
605     /// is the BlockchainCutiesCore contract because all bid methods
606     /// should be wrapped. Also returns the cutie to the
607     /// seller rather than the winner.
608     function bid(uint40 _cutieId) public payable canBeStoredIn128Bits(msg.value) {
609         require(msg.sender == address(coreContract));
610         address seller = cutieIdToAuction[_cutieId].seller;
611         // _bid. is token ID valid?
612         _bid(_cutieId, uint128(msg.value));
613         // We transfer the cutie back to the seller, the winner will get
614         // the offspring
615         _transfer(seller, _cutieId);
616     }
617 }