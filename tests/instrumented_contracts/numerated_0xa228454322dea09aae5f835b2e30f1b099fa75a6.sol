1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6  */
7 contract ERC721 {
8   event Transfer(
9     address indexed from,
10     address indexed to,
11     uint256 indexed tokenId
12   );
13   event Approval(
14     address indexed owner,
15     address indexed approved,
16     uint256 indexed tokenId
17   );
18 
19   function implementsERC721() public pure returns (bool);
20   function totalSupply() public view returns (uint256 total);
21   function balanceOf(address _owner) public view returns (uint256 balance);
22   function ownerOf(uint256 _tokenId) external view returns (address owner);
23   function approve(address _to, uint256 _tokenId) external;
24   function transfer(address _to, uint256 _tokenId) external;
25   function transferFrom(address _from, address _to, uint256 _tokenId) external;
26 }
27 
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  *      functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    *      account.
42    */
43   constructor() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 
67 /**
68  * @title Pausable
69  * @dev Base contract which allows children to implement an emergency stop mechanism.
70  */
71 contract Pausable is Ownable {
72   event Pause();
73   event Unpause();
74 
75   bool public paused = false;
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev Called by the owner to pause, triggers stopped state.
95    */
96   function pause() onlyOwner whenNotPaused public {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev Called by the owner to unpause, returns to normal state.
103    */
104   function unpause() onlyOwner whenPaused public {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 
111 /**
112  * @title CurioAuction
113  * @dev CurioAuction contract implements clock auction for tokens sale.
114  */
115 contract CurioAuction is Pausable {
116   event AuctionCreated(
117     uint256 indexed tokenId,
118     uint256 startingPrice,
119     uint256 endingPrice,
120     uint256 duration
121   );
122   event AuctionSuccessful(
123     uint256 indexed tokenId,
124     uint256 totalPrice,
125     address indexed winner
126   );
127   event AuctionCancelled(uint256 indexed tokenId);
128 
129   // Represents an auction on a token
130   struct Auction {
131     // Current owner of token
132     address seller;
133     // Price (in wei) at beginning of auction
134     uint128 startingPrice;
135     // Price (in wei) at end of auction
136     uint128 endingPrice;
137     // Duration (in seconds) of auction
138     uint64 duration;
139     // Time when auction started (0 if this auction has been concluded)
140     uint64 startedAt;
141   }
142 
143   // Check that this contract is correct for Curio main contract
144   bool public isCurioAuction = true;
145 
146   // Reference to token contract
147   ERC721 public tokenContract;
148 
149   // Value of fee (1/100 of a percent; 0-10,000 map to 0%-100%)
150   uint256 public feePercent;
151 
152   // Map from token ID to auction
153   mapping (uint256 => Auction) tokenIdToAuction;
154 
155   // Count of release tokens sold by auction
156   uint256 public releaseTokensSaleCount;
157 
158   // Limit of start and end prices in wei
159   uint256 public auctionPriceLimit;
160 
161   /**
162    * @dev Constructor function
163    * @param _tokenAddress Address of ERC721 token contract (Curio core contract)
164    * @param _fee Percent of fee (0-10,000)
165    * @param _auctionPriceLimit Limit of start and end price in auction (in wei)
166    */
167   constructor(
168     address _tokenAddress,
169     uint256 _fee,
170     uint256 _auctionPriceLimit
171   )
172     public
173   {
174     require(_fee <= 10000);
175     feePercent = _fee;
176 
177     ERC721 candidateContract = ERC721(_tokenAddress);
178     require(candidateContract.implementsERC721());
179 
180     tokenContract = candidateContract;
181 
182     require(_auctionPriceLimit == uint256(uint128(_auctionPriceLimit)));
183     auctionPriceLimit = _auctionPriceLimit;
184   }
185 
186 
187   // -----------------------------------------
188   // External interface
189   // -----------------------------------------
190 
191 
192   /**
193    * @dev Creates a new auction.
194    * @param _tokenId ID of token to auction, sender must be owner
195    * @param _startingPrice Price of item (in wei) at beginning of auction
196    * @param _endingPrice Price of item (in wei) at end of auction
197    * @param _duration Length of auction (in seconds)
198    * @param _seller Seller address
199    */
200   function createAuction(
201     uint256 _tokenId,
202     uint256 _startingPrice,
203     uint256 _endingPrice,
204     uint256 _duration,
205     address _seller
206   )
207     whenNotPaused
208     external
209   {
210     // Overflow and limitation input check
211     require(_startingPrice == uint256(uint128(_startingPrice)));
212     require(_startingPrice < auctionPriceLimit);
213 
214     require(_endingPrice == uint256(uint128(_endingPrice)));
215     require(_endingPrice < auctionPriceLimit);
216 
217     require(_duration == uint256(uint64(_duration)));
218 
219     // Check call from token contract
220     require(msg.sender == address(tokenContract));
221 
222     // Transfer token from seller to this contract
223     _deposit(_seller, _tokenId);
224 
225     // Create an auction
226     Auction memory auction = Auction(
227       _seller,
228       uint128(_startingPrice),
229       uint128(_endingPrice),
230       uint64(_duration),
231       uint64(now)
232     );
233     _addAuction(_tokenId, auction);
234   }
235 
236   /**
237    * @dev Returns auction info for a token on auction.
238    * @param _tokenId ID of token on auction
239    */
240   function getAuction(uint256 _tokenId) external view
241   returns
242   (
243     address seller,
244     uint256 startingPrice,
245     uint256 endingPrice,
246     uint256 duration,
247     uint256 startedAt
248   ) {
249     // Check token on auction
250     Auction storage auction = tokenIdToAuction[_tokenId];
251     require(_isOnAuction(auction));
252 
253     return (
254       auction.seller,
255       auction.startingPrice,
256       auction.endingPrice,
257       auction.duration,
258       auction.startedAt
259     );
260   }
261 
262   /**
263    * @dev Returns the current price of an auction.
264    * @param _tokenId ID of the token price we are checking
265    */
266   function getCurrentPrice(uint256 _tokenId) external view returns (uint256) {
267     // Check token on auction
268     Auction storage auction = tokenIdToAuction[_tokenId];
269     require(_isOnAuction(auction));
270 
271     return _currentPrice(auction);
272   }
273 
274   /**
275    * @dev Bids on an open auction, completing the auction and transferring
276    *      ownership of the token if enough Ether is supplied.
277    * @param _tokenId ID of token to bid on
278    */
279   function bid(uint256 _tokenId) external payable whenNotPaused {
280     address seller = tokenIdToAuction[_tokenId].seller;
281 
282     // Check auction conditions and transfer Ether to seller
283     // _bid verifies token ID size
284     _bid(_tokenId, msg.value);
285 
286     // Transfer token from this contract to msg.sender after successful bid
287     _transfer(msg.sender, _tokenId);
288 
289     // If seller is tokenContract then increase counter of release tokens
290     if (seller == address(tokenContract)) {
291       releaseTokensSaleCount++;
292     }
293   }
294 
295   /**
296    * @dev Cancels an auction. Returns the token to original owner.
297    *      This is a state-modifying function that can
298    *      be called while the contract is paused.
299    * @param _tokenId ID of token on auction
300    */
301   function cancelAuction(uint256 _tokenId) external {
302     // Check token on auction
303     Auction storage auction = tokenIdToAuction[_tokenId];
304     require(_isOnAuction(auction));
305 
306     // Check sender as seller
307     address seller = auction.seller;
308     require(msg.sender == seller);
309 
310     _cancelAuction(_tokenId, seller);
311   }
312 
313   /**
314    * @dev Cancels an auction when the contract is paused. Only owner.
315    *      Returns the token to seller. This should only be used in emergencies.
316    * @param _tokenId ID of the NFT on auction to cancel
317    */
318   function cancelAuctionWhenPaused(uint256 _tokenId) whenPaused onlyOwner external {
319     // Check token on auction
320     Auction storage auction = tokenIdToAuction[_tokenId];
321     require(_isOnAuction(auction));
322 
323     _cancelAuction(_tokenId, auction.seller);
324   }
325 
326   /**
327    * @dev Withdraw all Ether (fee) from auction contract to token contract.
328    *      Only auction contract owner.
329    */
330   function withdrawBalance() external {
331     address tokenAddress = address(tokenContract);
332 
333     // Check sender as owner or token contract
334     require(msg.sender == owner || msg.sender == tokenAddress);
335 
336     // Send Ether on this contract to token contract
337     // Boolean method make sure that even if one fails it will still work
338     bool res = tokenAddress.send(address(this).balance);
339   }
340 
341   /**
342    * @dev Set new auction price limit.
343    * @param _newAuctionPriceLimit Start and end price limit
344    */
345   function setAuctionPriceLimit(uint256 _newAuctionPriceLimit) external {
346     address tokenAddress = address(tokenContract);
347 
348     // Check sender as owner or token contract
349     require(msg.sender == owner || msg.sender == tokenAddress);
350 
351     // Check overflow
352     require(_newAuctionPriceLimit == uint256(uint128(_newAuctionPriceLimit)));
353 
354     // Set new auction price limit
355     auctionPriceLimit = _newAuctionPriceLimit;
356   }
357 
358 
359   // -----------------------------------------
360   // Internal interface
361   // -----------------------------------------
362 
363 
364   /**
365    * @dev Returns true if the claimant owns the token.
366    * @param _claimant Address claiming to own the token
367    * @param _tokenId ID of token whose ownership to verify
368    */
369   function _owns(
370     address _claimant,
371     uint256 _tokenId
372   )
373     internal
374     view
375     returns (bool)
376   {
377     return (tokenContract.ownerOf(_tokenId) == _claimant);
378   }
379 
380   /**
381    * @dev Transfer token from owner to this contract.
382    * @param _owner Current owner address of token to escrow
383    * @param _tokenId ID of token whose approval to verify
384    */
385   function _deposit(
386     address _owner,
387     uint256 _tokenId
388   )
389     internal
390   {
391     tokenContract.transferFrom(_owner, this, _tokenId);
392   }
393 
394   /**
395    * @dev Transfers token owned by this contract to another address.
396    *      Returns true if the transfer succeeds.
397    * @param _receiver Address to transfer token to
398    * @param _tokenId ID of token to transfer
399    */
400   function _transfer(
401     address _receiver,
402     uint256 _tokenId
403   )
404     internal
405   {
406     tokenContract.transfer(_receiver, _tokenId);
407   }
408 
409   /**
410    * @dev Adds an auction to the list of open auctions.
411    * @param _tokenId The ID of the token to be put on auction
412    * @param _auction Auction to add
413    */
414   function _addAuction(
415     uint256 _tokenId,
416     Auction _auction
417   )
418     internal
419   {
420     // Require that all auctions have a duration of at least one minute.
421     require(_auction.duration >= 1 minutes);
422 
423     tokenIdToAuction[_tokenId] = _auction;
424 
425     emit AuctionCreated(
426       uint256(_tokenId),
427       uint256(_auction.startingPrice),
428       uint256(_auction.endingPrice),
429       uint256(_auction.duration)
430     );
431   }
432 
433   /**
434    * @dev Removes an auction from the list of open auctions.
435    * @param _tokenId ID of token on auction
436    */
437   function _removeAuction(uint256 _tokenId) internal {
438     delete tokenIdToAuction[_tokenId];
439   }
440 
441   /**
442    * @dev Remove an auction and transfer token from this contract to seller address.
443    * @param _tokenId The ID of the token
444    * @param _seller Seller address
445    */
446   function _cancelAuction(
447     uint256 _tokenId,
448     address _seller
449   )
450     internal
451   {
452     // Remove auction from list
453     _removeAuction(_tokenId);
454 
455     // Transfer token to seller
456     _transfer(_seller, _tokenId);
457 
458     emit AuctionCancelled(_tokenId);
459   }
460 
461   /**
462    * @dev Check token is on auction.
463    * @param _auction Auction to check
464    */
465   function _isOnAuction(Auction storage _auction) internal view returns (bool) {
466     return (_auction.startedAt > 0);
467   }
468 
469   /**
470    * @dev Calculates fee of a sale.
471    * @param _price Token price
472    */
473   function _calculateFee(uint256 _price) internal view returns (uint256) {
474     return _price * feePercent / 10000;
475   }
476 
477   /**
478    * @dev Returns current price of a token on auction.
479    * @param _auction Auction for calculate current price
480    */
481   function _currentPrice(Auction storage _auction) internal view returns (uint256) {
482     uint256 secondsPassed = 0;
483 
484     // Check that auction were started
485     // Variable secondsPassed is positive
486     if (now > _auction.startedAt) {
487       secondsPassed = now - _auction.startedAt;
488     }
489 
490     return _calculateCurrentPrice(
491       _auction.startingPrice,
492       _auction.endingPrice,
493       _auction.duration,
494       secondsPassed
495     );
496   }
497 
498   /**
499    * @dev Calculate the current price of an auction.
500    * @param _startingPrice Price of item (in wei) at beginning of auction
501    * @param _endingPrice Price of item (in wei) at end of auction
502    * @param _duration Length of auction (in seconds)
503    * @param _secondsPassed Seconds passed after auction start
504    */
505   function _calculateCurrentPrice(
506     uint256 _startingPrice,
507     uint256 _endingPrice,
508     uint256 _duration,
509     uint256 _secondsPassed
510   )
511     internal
512     pure
513     returns (uint256)
514   {
515     if (_secondsPassed >= _duration) {
516       // The auction lasts longer duration
517       // Return end price
518       return _endingPrice;
519     } else {
520       // totalPriceChange can be negative
521       int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
522 
523       // This multiplication can't overflow, _secondsPassed will easily fit within
524       // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
525       // will always fit within 256-bits.
526       int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
527 
528       // currentPriceChange can be negative, but if so, will have a magnitude
529       // less that _startingPrice. Thus, this result will always end up positive.
530       int256 currentPrice = int256(_startingPrice) + currentPriceChange;
531 
532       return uint256(currentPrice);
533     }
534   }
535 
536   /**
537    * @dev Calculate auction price and transfers winnings. Does NOT transfer ownership of token.
538    * @param _tokenId The ID of the token
539    * @param _bidAmount Amount (in wei) offered for auction
540    */
541   function _bid(
542     uint256 _tokenId,
543     uint256 _bidAmount
544   )
545     internal
546     returns (uint256)
547   {
548     Auction storage auction = tokenIdToAuction[_tokenId];
549 
550     // Check that this auction is currently live
551     require(_isOnAuction(auction));
552 
553     // Check that the incoming bid is higher than the current price
554     uint256 price = _currentPrice(auction);
555     require(_bidAmount >= price);
556 
557     address seller = auction.seller;
558 
559     _removeAuction(_tokenId);
560 
561     // Transfer proceeds to seller
562     if (price > 0) {
563       uint256 fee = _calculateFee(price);
564 
565       uint256 sellerProceeds = price - fee;
566 
567       // Transfer proceeds to seller
568       seller.transfer(sellerProceeds);
569     }
570 
571     // Calculate excess funds and transfer it back to bidder
572     uint256 bidExcess = _bidAmount - price;
573     msg.sender.transfer(bidExcess);
574 
575     emit AuctionSuccessful(_tokenId, price, msg.sender);
576 
577     return price;
578   }
579 }