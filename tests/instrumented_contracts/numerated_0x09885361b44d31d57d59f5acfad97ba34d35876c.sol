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
28      function getGenes(uint40 _id)
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
195 }
196 
197 
198 /// @title Auction Market for Blockchain Cuties.
199 /// @author https://BlockChainArchitect.io
200 contract Market is MarketInterface, Pausable
201 {
202     // Shows the auction on an Cutie Token
203     struct Auction {
204         // Price (in wei) at the beginning of auction
205         uint128 startPrice;
206         // Price (in wei) at the end of auction
207         uint128 endPrice;
208         // Current owner of Token
209         address seller;
210         // Auction duration in seconds
211         uint40 duration;
212         // Time when auction started
213         // NOTE: 0 if this auction has been concluded
214         uint40 startedAt;
215         // Featuring fee (in wei, optional)
216         uint128 featuringFee;
217     }
218 
219     // Reference to contract that tracks ownership
220     CutieCoreInterface public coreContract;
221 
222     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
223     // Values 0-10,000 map to 0%-100%
224     uint16 public ownerFee;
225 
226     // Map from token ID to their corresponding auction.
227     mapping (uint40 => Auction) cutieIdToAuction;
228 
229     event AuctionCreated(uint40 cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint128 fee);
230     event AuctionSuccessful(uint40 cutieId, uint128 totalPrice, address winner);
231     event AuctionCancelled(uint40 cutieId);
232 
233     /// @dev disables sending fund to this contract
234     function() external {}
235 
236     modifier canBeStoredIn128Bits(uint256 _value) 
237     {
238         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
239         _;
240     }
241 
242     // @dev Adds to the list of open auctions and fires the
243     //  AuctionCreated event.
244     // @param _cutieId The token ID is to be put on auction.
245     // @param _auction To add an auction.
246     // @param _fee Amount of money to feature auction
247     function _addAuction(uint40 _cutieId, Auction _auction) internal
248     {
249         // Require that all auctions have a duration of
250         // at least one minute. (Keeps our math from getting hairy!)
251         require(_auction.duration >= 1 minutes);
252 
253         cutieIdToAuction[_cutieId] = _auction;
254         
255         emit AuctionCreated(
256             _cutieId,
257             _auction.startPrice,
258             _auction.endPrice,
259             _auction.duration,
260             _auction.featuringFee
261         );
262     }
263 
264     // @dev Returns true if the token is claimed by the claimant.
265     // @param _claimant - Address claiming to own the token.
266     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
267     {
268         return (coreContract.ownerOf(_cutieId) == _claimant);
269     }
270 
271     // @dev Transfers the token owned by this contract to another address.
272     // Returns true when the transfer succeeds.
273     // @param _receiver - Address to transfer token to.
274     // @param _cutieId - Token ID to transfer.
275     function _transfer(address _receiver, uint40 _cutieId) internal
276     {
277         // it will throw if transfer fails
278         coreContract.transfer(_receiver, _cutieId);
279     }
280 
281     // @dev Escrows the token and assigns ownership to this contract.
282     // Throws if the escrow fails.
283     // @param _owner - Current owner address of token to escrow.
284     // @param _cutieId - Token ID the approval of which is to be verified.
285     function _escrow(address _owner, uint40 _cutieId) internal
286     {
287         // it will throw if transfer fails
288         coreContract.transferFrom(_owner, this, _cutieId);
289     }
290 
291 
292     // @dev just cancel auction.
293     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
294     {
295         _removeAuction(_cutieId);
296         _transfer(_seller, _cutieId);
297         emit AuctionCancelled(_cutieId);
298     }
299 
300     // @dev Calculates the price and transfers winnings.
301     // Does not transfer token ownership.
302     function _bid(uint40 _cutieId, uint128 _bidAmount)
303         internal
304         returns (uint128)
305     {
306         // Get a reference to the auction struct
307         Auction storage auction = cutieIdToAuction[_cutieId];
308 
309         require(_isOnAuction(auction));
310 
311         // Check that bid > current price
312         uint128 price = _currentPrice(auction);
313         require(_bidAmount >= price);
314 
315         // Provide a reference to the seller before the auction struct is deleted.
316         address seller = auction.seller;
317 
318         _removeAuction(_cutieId);
319 
320         // Transfer proceeds to seller (if there are any!)
321         if (price > 0) {
322             uint128 fee = _computeFee(price);
323             uint128 sellerValue = price - fee;
324 
325             seller.transfer(sellerValue);
326         }
327 
328         emit AuctionSuccessful(_cutieId, price, msg.sender);
329 
330         return price;
331     }
332 
333     // @dev Removes from the list of open auctions.
334     // @param _cutieId - ID of token on auction.
335     function _removeAuction(uint40 _cutieId) internal
336     {
337         delete cutieIdToAuction[_cutieId];
338     }
339 
340     // @dev Returns true if the token is on auction.
341     // @param _auction - Auction to check.
342     function _isOnAuction(Auction storage _auction) internal view returns (bool)
343     {
344         return (_auction.startedAt > 0);
345     }
346 
347 
348     // @dev calculate current price of auction. 
349     //  When testing, make this function public and turn on
350     //  `Current price calculation` test suite.
351     function _computeCurrentPrice(
352         uint128 _startPrice,
353         uint128 _endPrice,
354         uint40 _duration,
355         uint40 _secondsPassed
356     )
357         internal
358         pure
359         returns (uint128)
360     {
361         if (_secondsPassed >= _duration) {
362             return _endPrice;
363         } else {
364             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
365             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
366             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
367             
368             return currentPrice;
369         }
370     }
371     // @dev return current price of token.
372     function _currentPrice(Auction storage _auction)
373         internal
374         view
375         returns (uint128)
376     {
377         uint40 secondsPassed = 0;
378 
379         uint40 timeNow = uint40(now);
380         if (timeNow > _auction.startedAt) {
381             secondsPassed = timeNow - _auction.startedAt;
382         }
383 
384         return _computeCurrentPrice(
385             _auction.startPrice,
386             _auction.endPrice,
387             _auction.duration,
388             secondsPassed
389         );
390     }
391 
392     // @dev Calculates owner's cut of a sale.
393     // @param _price - Sale price of cutie.
394     function _computeFee(uint128 _price) internal view returns (uint128)
395     {
396         return _price * ownerFee / 10000;
397     }
398 
399 
400     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
401     //  Transfers to the token contract, but can be called by
402     //  the owner or the token contract.
403     function withdrawEthFromBalance() external
404     {
405         address coreAddress = address(coreContract);
406 
407         require(
408             msg.sender == owner ||
409             msg.sender == coreAddress
410         );
411         coreAddress.transfer(address(this).balance);
412     }
413 
414     // @dev create and begin new auction.
415     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller)
416         public whenNotPaused payable
417     {
418         require(_isOwner(msg.sender, _cutieId));
419         _escrow(msg.sender, _cutieId);
420         Auction memory auction = Auction(
421             _startPrice,
422             _endPrice,
423             _seller,
424             _duration,
425             uint40(now),
426             uint128(msg.value)
427         );
428         _addAuction(_cutieId, auction);
429     }
430 
431     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
432     //  @param fee should be between 0-10,000.
433     function setup(address _coreContractAddress, uint16 _fee) public
434     {
435         require(coreContract == address(0));
436         require(_fee <= 10000);
437         require(msg.sender == owner);
438 
439         ownerFee = _fee;
440         
441         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
442         require(candidateContract.isCutieCore());
443         coreContract = candidateContract;
444     }
445 
446     // @dev Set the owner's fee.
447     //  @param fee should be between 0-10,000.
448     function setFee(uint16 _fee) public
449     {
450         require(_fee <= 10000);
451         require(msg.sender == owner);
452 
453         ownerFee = _fee;
454     }
455 
456     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
457     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
458     {
459         // _bid throws if something failed.
460         _bid(_cutieId, uint128(msg.value));
461         _transfer(msg.sender, _cutieId);
462     }
463 
464     // @dev Returns auction info for a token on auction.
465     // @param _cutieId - ID of token on auction.
466     function getAuctionInfo(uint40 _cutieId)
467         public
468         view
469         returns
470     (
471         address seller,
472         uint128 startPrice,
473         uint128 endPrice,
474         uint40 duration,
475         uint40 startedAt,
476         uint128 featuringFee
477     ) {
478         Auction storage auction = cutieIdToAuction[_cutieId];
479         require(_isOnAuction(auction));
480         return (
481             auction.seller,
482             auction.startPrice,
483             auction.endPrice,
484             auction.duration,
485             auction.startedAt,
486             auction.featuringFee
487         );
488     }
489 
490     // @dev Returns the current price of an auction.
491     function getCurrentPrice(uint40 _cutieId)
492         public
493         view
494         returns (uint128)
495     {
496         Auction storage auction = cutieIdToAuction[_cutieId];
497         require(_isOnAuction(auction));
498         return _currentPrice(auction);
499     }
500 
501     // @dev Cancels unfinished auction and returns token to owner. 
502     // Can be called when contract is paused.
503     function cancelActiveAuction(uint40 _cutieId) public
504     {
505         Auction storage auction = cutieIdToAuction[_cutieId];
506         require(_isOnAuction(auction));
507         address seller = auction.seller;
508         require(msg.sender == seller);
509         _cancelActiveAuction(_cutieId, seller);
510     }
511 
512     // @dev Cancels auction when contract is on pause. Option is available only to owners in urgent situations. Tokens returned to seller.
513     //  Used on Core contract upgrade.
514     function cancelActiveAuctionWhenPaused(uint40 _cutieId) whenPaused onlyOwner public
515     {
516         Auction storage auction = cutieIdToAuction[_cutieId];
517         require(_isOnAuction(auction));
518         _cancelActiveAuction(_cutieId, auction.seller);
519     }
520 }
521 
522 
523 /// @title Auction market for breeding
524 /// @author https://BlockChainArchitect.io
525 contract BreedingMarket is Market
526 {
527     bool public isBreedingMarket = true;
528 
529     // @dev Launches and starts a new auction.
530     function createAuction(
531         uint40 _cutieId,
532         uint128 _startPrice,
533         uint128 _endPrice,
534         uint40 _duration,
535         address _seller)
536         public payable
537     {
538         require(msg.sender == address(coreContract));
539         _escrow(_seller, _cutieId);
540         Auction memory auction = Auction(
541             _startPrice,
542             _endPrice,
543             _seller,
544             _duration,
545             uint40(now),
546             uint128(msg.value)
547         );
548         _addAuction(_cutieId, auction);
549     }
550 
551     /// @dev Places a bid for breeding. Requires the sender
552     /// is the BlockchainCutiesCore contract because all bid methods
553     /// should be wrapped. Also returns the cutie to the
554     /// seller rather than the winner.
555     function bid(uint40 _cutieId) public payable canBeStoredIn128Bits(msg.value) {
556         require(msg.sender == address(coreContract));
557         address seller = cutieIdToAuction[_cutieId].seller;
558         // _bid. is token ID valid?
559         _bid(_cutieId, uint128(msg.value));
560         // We transfer the cutie back to the seller, the winner will get
561         // the offspring
562         _transfer(seller, _cutieId);
563     }
564 }