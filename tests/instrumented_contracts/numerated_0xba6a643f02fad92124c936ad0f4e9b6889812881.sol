1 pragma solidity ^0.4.20;
2 
3 
4 
5 
6 
7 contract CutieCoreInterface
8 {
9     function isCutieCore() pure public returns (bool);
10 
11     function transferFrom(address _from, address _to, uint256 _cutieId) external;
12     function transfer(address _to, uint256 _cutieId) external;
13 
14     function ownerOf(uint256 _cutieId)
15         external
16         view
17         returns (address owner);
18 
19     function getCutie(uint40 _id)
20         external
21         view
22         returns (
23         uint256 genes,
24         uint40 birthTime,
25         uint40 cooldownEndTime,
26         uint40 momId,
27         uint40 dadId,
28         uint16 cooldownIndex,
29         uint16 generation
30     );
31 
32      function getGenes(uint40 _id)
33         public
34         view
35         returns (
36         uint256 genes
37     );
38 
39 
40     function getCooldownEndTime(uint40 _id)
41         public
42         view
43         returns (
44         uint40 cooldownEndTime
45     );
46 
47     function getCooldownIndex(uint40 _id)
48         public
49         view
50         returns (
51         uint16 cooldownIndex
52     );
53 
54 
55     function getGeneration(uint40 _id)
56         public
57         view
58         returns (
59         uint16 generation
60     );
61 
62     function getOptional(uint40 _id)
63         public
64         view
65         returns (
66         uint64 optional
67     );
68 
69 
70     function changeGenes(
71         uint40 _cutieId,
72         uint256 _genes)
73         public;
74 
75     function changeCooldownEndTime(
76         uint40 _cutieId,
77         uint40 _cooldownEndTime)
78         public;
79 
80     function changeCooldownIndex(
81         uint40 _cutieId,
82         uint16 _cooldownIndex)
83         public;
84 
85     function changeOptional(
86         uint40 _cutieId,
87         uint64 _optional)
88         public;
89 
90     function changeGeneration(
91         uint40 _cutieId,
92         uint16 _generation)
93         public;
94 }
95 
96 
97 
98 
99 
100 
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 
114   /**
115    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
116    * account.
117    */
118   function Ownable() public {
119     owner = msg.sender;
120   }
121 
122   /**
123    * @dev Throws if called by any account other than the owner.
124    */
125   modifier onlyOwner() {
126     require(msg.sender == owner);
127     _;
128   }
129 
130   /**
131    * @dev Allows the current owner to transfer control of the contract to a newOwner.
132    * @param newOwner The address to transfer ownership to.
133    */
134   function transferOwnership(address newOwner) public onlyOwner {
135     require(newOwner != address(0));
136     emit OwnershipTransferred(owner, newOwner);
137     owner = newOwner;
138   }
139 
140 }
141 
142 
143 
144 /**
145  * @title Pausable
146  * @dev Base contract which allows children to implement an emergency stop mechanism.
147  */
148 contract Pausable is Ownable {
149   event Pause();
150   event Unpause();
151 
152   bool public paused = false;
153 
154 
155   /**
156    * @dev Modifier to make a function callable only when the contract is not paused.
157    */
158   modifier whenNotPaused() {
159     require(!paused);
160     _;
161   }
162 
163   /**
164    * @dev Modifier to make a function callable only when the contract is paused.
165    */
166   modifier whenPaused() {
167     require(paused);
168     _;
169   }
170 
171   /**
172    * @dev called by the owner to pause, triggers stopped state
173    */
174   function pause() onlyOwner whenNotPaused public {
175     paused = true;
176     emit Pause();
177   }
178 
179   /**
180    * @dev called by the owner to unpause, returns to normal state
181    */
182   function unpause() onlyOwner whenPaused public {
183     paused = false;
184     emit Unpause();
185   }
186 }
187 
188 
189 
190 /// @title Auction Market for Blockchain Cuties.
191 /// @author https://BlockChainArchitect.io
192 contract MarketInterface 
193 {
194     function withdrawEthFromBalance() external;    
195 
196     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) public payable;
197 
198     function bid(uint40 _cutieId) public payable;
199 }
200 
201 
202 /// @title Auction Market for Blockchain Cuties.
203 /// @author https://BlockChainArchitect.io
204 contract Market is MarketInterface, Pausable
205 {
206     // Shows the auction on an Cutie Token
207     struct Auction {
208         // Price (in wei) at the beginning of auction
209         uint128 startPrice;
210         // Price (in wei) at the end of auction
211         uint128 endPrice;
212         // Current owner of Token
213         address seller;
214         // Auction duration in seconds
215         uint40 duration;
216         // Time when auction started
217         // NOTE: 0 if this auction has been concluded
218         uint40 startedAt;
219     }
220 
221     // Reference to contract that tracks ownership
222     CutieCoreInterface public coreContract;
223 
224     // Cut owner takes on each auction, in basis points - 1/100 of a per cent.
225     // Values 0-10,000 map to 0%-100%
226     uint16 public ownerFee;
227 
228     // Map from token ID to their corresponding auction.
229     mapping (uint40 => Auction) cutieIdToAuction;
230 
231     event AuctionCreated(uint40 cutieId, uint128 startPrice, uint128 endPrice, uint40 duration, uint256 fee);
232     event AuctionSuccessful(uint40 cutieId, uint128 totalPrice, address winner);
233     event AuctionCancelled(uint40 cutieId);
234 
235     /// @dev disables sending fund to this contract
236     function() external {}
237 
238     modifier canBeStoredIn128Bits(uint256 _value) 
239     {
240         require(_value <= 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
241         _;
242     }
243 
244     // @dev Adds to the list of open auctions and fires the
245     //  AuctionCreated event.
246     // @param _cutieId The token ID is to be put on auction.
247     // @param _auction To add an auction.
248     // @param _fee Amount of money to feature auction
249     function _addAuction(uint40 _cutieId, Auction _auction, uint256 _fee) internal
250     {
251         // Require that all auctions have a duration of
252         // at least one minute. (Keeps our math from getting hairy!)
253         require(_auction.duration >= 1 minutes);
254 
255         cutieIdToAuction[_cutieId] = _auction;
256         
257         emit AuctionCreated(
258             _cutieId,
259             _auction.startPrice,
260             _auction.endPrice,
261             _auction.duration,
262             _fee
263         );
264     }
265 
266     // @dev Returns true if the token is claimed by the claimant.
267     // @param _claimant - Address claiming to own the token.
268     function _isOwner(address _claimant, uint256 _cutieId) internal view returns (bool)
269     {
270         return (coreContract.ownerOf(_cutieId) == _claimant);
271     }
272 
273     // @dev Transfers the token owned by this contract to another address.
274     // Returns true when the transfer succeeds.
275     // @param _receiver - Address to transfer token to.
276     // @param _cutieId - Token ID to transfer.
277     function _transfer(address _receiver, uint40 _cutieId) internal
278     {
279         // it will throw if transfer fails
280         coreContract.transfer(_receiver, _cutieId);
281     }
282 
283     // @dev Escrows the token and assigns ownership to this contract.
284     // Throws if the escrow fails.
285     // @param _owner - Current owner address of token to escrow.
286     // @param _cutieId - Token ID the approval of which is to be verified.
287     function _escrow(address _owner, uint40 _cutieId) internal
288     {
289         // it will throw if transfer fails
290         coreContract.transferFrom(_owner, this, _cutieId);
291     }
292 
293 
294     // @dev just cancel auction.
295     function _cancelActiveAuction(uint40 _cutieId, address _seller) internal
296     {
297         _removeAuction(_cutieId);
298         _transfer(_seller, _cutieId);
299         emit AuctionCancelled(_cutieId);
300     }
301 
302     // @dev Calculates the price and transfers winnings.
303     // Does not transfer token ownership.
304     function _bid(uint40 _cutieId, uint128 _bidAmount)
305         internal
306         returns (uint128)
307     {
308         // Get a reference to the auction struct
309         Auction storage auction = cutieIdToAuction[_cutieId];
310 
311         require(_isOnAuction(auction));
312 
313         // Check that bid > current price
314         uint128 price = _currentPrice(auction);
315         require(_bidAmount >= price);
316 
317         // Provide a reference to the seller before the auction struct is deleted.
318         address seller = auction.seller;
319 
320         _removeAuction(_cutieId);
321 
322         // Transfer proceeds to seller (if there are any!)
323         if (price > 0) {
324             uint128 fee = _computeFee(price);
325             uint128 sellerValue = price - fee;
326 
327             seller.transfer(sellerValue);
328         }
329 
330         emit AuctionSuccessful(_cutieId, price, msg.sender);
331 
332         return price;
333     }
334 
335     // @dev Removes from the list of open auctions.
336     // @param _cutieId - ID of token on auction.
337     function _removeAuction(uint40 _cutieId) internal
338     {
339         delete cutieIdToAuction[_cutieId];
340     }
341 
342     // @dev Returns true if the token is on auction.
343     // @param _auction - Auction to check.
344     function _isOnAuction(Auction storage _auction) internal view returns (bool)
345     {
346         return (_auction.startedAt > 0);
347     }
348 
349 
350     // @dev calculate current price of auction. 
351     //  When testing, make this function public and turn on
352     //  `Current price calculation` test suite.
353     function _computeCurrentPrice(
354         uint128 _startPrice,
355         uint128 _endPrice,
356         uint40 _duration,
357         uint40 _secondsPassed
358     )
359         internal
360         pure
361         returns (uint128)
362     {
363         if (_secondsPassed >= _duration) {
364             return _endPrice;
365         } else {
366             int256 totalPriceChange = int256(_endPrice) - int256(_startPrice);
367             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
368             uint128 currentPrice = _startPrice + uint128(currentPriceChange);
369             
370             return currentPrice;
371         }
372     }
373     // @dev return current price of token.
374     function _currentPrice(Auction storage _auction)
375         internal
376         view
377         returns (uint128)
378     {
379         uint40 secondsPassed = 0;
380 
381         uint40 timeNow = uint40(now);
382         if (timeNow > _auction.startedAt) {
383             secondsPassed = timeNow - _auction.startedAt;
384         }
385 
386         return _computeCurrentPrice(
387             _auction.startPrice,
388             _auction.endPrice,
389             _auction.duration,
390             secondsPassed
391         );
392     }
393 
394     // @dev Calculates owner's cut of a sale.
395     // @param _price - Sale price of cutie.
396     function _computeFee(uint128 _price) internal view returns (uint128)
397     {
398         return _price * ownerFee / 10000;
399     }
400 
401 
402     // @dev Remove all Ether from the contract with the owner's cuts. Also, remove any Ether sent directly to the contract address.
403     //  Transfers to the token contract, but can be called by
404     //  the owner or the token contract.
405     function withdrawEthFromBalance() external
406     {
407         address coreAddress = address(coreContract);
408 
409         require(
410             msg.sender == owner ||
411             msg.sender == coreAddress
412         );
413         coreAddress.transfer(address(this).balance);
414     }
415 
416 
417     // @dev create and begin new auction.
418     function createAuction(uint40 _cutieId, uint128 _startPrice, uint128 _endPrice, uint40 _duration, address _seller) 
419         public whenNotPaused payable
420     {
421         require(_isOwner(msg.sender, _cutieId));
422         _escrow(msg.sender, _cutieId);
423         Auction memory auction = Auction(
424             _startPrice,
425             _endPrice,
426             _seller,
427             _duration,
428             uint40(now)
429         );
430         _addAuction(_cutieId, auction, msg.value);
431     }
432 
433     // @dev Set the reference to cutie ownership contract. Verify the owner's fee.
434     //  @param fee should be between 0-10,000.
435     function setup(address _coreContractAddress, uint16 _fee) public
436     {
437         require(coreContract == address(0));
438         require(_fee <= 10000);
439         require(msg.sender == owner);
440 
441         ownerFee = _fee;
442         
443         CutieCoreInterface candidateContract = CutieCoreInterface(_coreContractAddress);
444         require(candidateContract.isCutieCore());
445         coreContract = candidateContract;
446     }
447 
448     // @dev Set the owner's fee.
449     //  @param fee should be between 0-10,000.
450     function setFee(uint16 _fee) public
451     {
452         require(_fee <= 10000);
453         require(msg.sender == owner);
454 
455         ownerFee = _fee;
456     }
457 
458     // @dev bid on auction. Complete it and transfer ownership of cutie if enough ether was given.
459     function bid(uint40 _cutieId) public payable whenNotPaused canBeStoredIn128Bits(msg.value)
460     {
461         // _bid throws if something failed.
462         _bid(_cutieId, uint128(msg.value));
463         _transfer(msg.sender, _cutieId);
464     }
465 
466     // @dev Returns auction info for a token on auction.
467     // @param _cutieId - ID of token on auction.
468     function getAuctionInfo(uint40 _cutieId)
469         public
470         view
471         returns
472     (
473         address seller,
474         uint128 startPrice,
475         uint128 endPrice,
476         uint40 duration,
477         uint40 startedAt
478     ) {
479         Auction storage auction = cutieIdToAuction[_cutieId];
480         require(_isOnAuction(auction));
481         return (
482             auction.seller,
483             auction.startPrice,
484             auction.endPrice,
485             auction.duration,
486             auction.startedAt
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
523 /// @title Auction market for cuties sale 
524 /// @author https://BlockChainArchitect.io
525 contract SaleMarket is Market
526 {
527     // @dev Sanity check reveals that the
528     //  auction in our setSaleAuctionAddress() call is right.
529     bool public isSaleMarket = true;
530     
531 
532     // @dev create and start a new auction
533     // @param _cutieId - ID of cutie to auction, sender must be owner.
534     // @param _startPrice - Price of item (in wei) at the beginning of auction.
535     // @param _endPrice - Price of item (in wei) at the end of auction.
536     // @param _duration - Length of auction (in seconds).
537     // @param _seller - Seller
538     function createAuction(
539         uint40 _cutieId,
540         uint128 _startPrice,
541         uint128 _endPrice,
542         uint40 _duration,
543         address _seller
544     )
545         public
546         payable
547     {
548         require(msg.sender == address(coreContract));
549         _escrow(_seller, _cutieId);
550         Auction memory auction = Auction(
551             _startPrice,
552             _endPrice,
553             _seller,
554             _duration,
555             uint40(now)
556         );
557         _addAuction(_cutieId, auction, msg.value);
558     }
559 
560     // @dev LastSalePrice is updated if seller is the token contract.
561     // Otherwise, default bid method is used.
562     function bid(uint40 _cutieId)
563         public
564         payable
565         canBeStoredIn128Bits(msg.value)
566     {
567         // _bid verifies token ID size
568         _bid(_cutieId, uint128(msg.value));
569         _transfer(msg.sender, _cutieId);
570 
571     }
572 }