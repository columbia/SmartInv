1 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 
101 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.3
102 
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module which allows children to implement an emergency stop
108  * mechanism that can be triggered by an authorized account.
109  *
110  * This module is used through inheritance. It will make available the
111  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
112  * the functions of your contract. Note that they will not be pausable by
113  * simply including this module, only once the modifiers are put in place.
114  */
115 abstract contract Pausable is Context {
116     /**
117      * @dev Emitted when the pause is triggered by `account`.
118      */
119     event Paused(address account);
120 
121     /**
122      * @dev Emitted when the pause is lifted by `account`.
123      */
124     event Unpaused(address account);
125 
126     bool private _paused;
127 
128     /**
129      * @dev Initializes the contract in unpaused state.
130      */
131     constructor() {
132         _paused = false;
133     }
134 
135     /**
136      * @dev Returns true if the contract is paused, and false otherwise.
137      */
138     function paused() public view virtual returns (bool) {
139         return _paused;
140     }
141 
142     /**
143      * @dev Modifier to make a function callable only when the contract is not paused.
144      *
145      * Requirements:
146      *
147      * - The contract must not be paused.
148      */
149     modifier whenNotPaused() {
150         require(!paused(), "Pausable: paused");
151         _;
152     }
153 
154     /**
155      * @dev Modifier to make a function callable only when the contract is paused.
156      *
157      * Requirements:
158      *
159      * - The contract must be paused.
160      */
161     modifier whenPaused() {
162         require(paused(), "Pausable: not paused");
163         _;
164     }
165 
166     /**
167      * @dev Triggers stopped state.
168      *
169      * Requirements:
170      *
171      * - The contract must not be paused.
172      */
173     function _pause() internal virtual whenNotPaused {
174         _paused = true;
175         emit Paused(_msgSender());
176     }
177 
178     /**
179      * @dev Returns to normal state.
180      *
181      * Requirements:
182      *
183      * - The contract must be paused.
184      */
185     function _unpause() internal virtual whenPaused {
186         _paused = false;
187         emit Unpaused(_msgSender());
188     }
189 }
190 
191 
192 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.3
193 
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title Counters
200  * @author Matt Condon (@shrugs)
201  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
202  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
203  *
204  * Include with `using Counters for Counters.Counter;`
205  */
206 library Counters {
207     struct Counter {
208         // This variable should never be directly accessed by users of the library: interactions must be restricted to
209         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
210         // this feature: see https://github.com/ethereum/solidity/issues/4637
211         uint256 _value; // default: 0
212     }
213 
214     function current(Counter storage counter) internal view returns (uint256) {
215         return counter._value;
216     }
217 
218     function increment(Counter storage counter) internal {
219         unchecked {
220             counter._value += 1;
221         }
222     }
223 
224     function decrement(Counter storage counter) internal {
225         uint256 value = counter._value;
226         require(value > 0, "Counter: decrement overflow");
227         unchecked {
228             counter._value = value - 1;
229         }
230     }
231 
232     function reset(Counter storage counter) internal {
233         counter._value = 0;
234     }
235 }
236 
237 
238 
239 pragma solidity 0.8.7;
240 contract Auction is Ownable, Pausable {
241   using Counters for Counters.Counter;
242 
243   uint256[] public minimumUnitPrice;
244   uint256 public immutable minimumBidIncrement;
245   uint256 public immutable unitPriceStepSize;
246   uint256 public immutable minimumQuantity;
247   uint256 public immutable maximumQuantity;
248   uint256 public immutable numberOfAuctions;
249   uint256[] public itemsPerDay;
250   address payable public immutable beneficiaryAddress;
251 
252   Counters.Counter private _auctionIDCounter;
253   Counters.Counter private _bidPlacedCounter;
254 
255   bool private _allowWithdrawals;
256 
257   event AuctionStarted(uint256 auctionID);
258   event AuctionEnded(uint256 auctionID);
259   event BidPlaced(uint256 indexed auctionID, address indexed bidder, uint256 bidIndex, uint256 unitPrice, uint256 quantity);
260   event WinnerSelected(uint256 indexed auctionID, address indexed bidder, uint256 unitPrice, uint256 quantity);
261   event BidderRefunded(address indexed bidder, uint256 refundAmount);
262 
263   struct Bid {
264     uint256 unitPrice;
265     uint256 quantity;
266   }
267 
268   struct AuctionStatus {
269     bool started;
270     bool ended;
271   }
272 
273 
274   mapping (uint256 => AuctionStatus) private _auctionStatus;
275 
276   mapping (address => Bid) private _bids;
277 
278   mapping (uint256 => uint256) private _remainingItemsPerAuction;
279 
280 
281   constructor(
282     address _contractOwner,
283     address payable _beneficiaryAddress,
284 
285     uint256 _minimumBidIncrement,
286     uint256 _unitPriceStepSize,
287     uint256 _minimumQuantity,
288     uint256 _maximumQuantity,
289     uint256 _numberOfAuctions,
290     uint256[] memory _itemsPerDay
291   ) {
292     beneficiaryAddress = _beneficiaryAddress;
293     transferOwnership(_contractOwner);
294     
295     minimumBidIncrement = _minimumBidIncrement;
296     unitPriceStepSize = _unitPriceStepSize;
297     minimumQuantity = _minimumQuantity;
298     maximumQuantity = _maximumQuantity;
299     numberOfAuctions = _numberOfAuctions;
300 
301     for(uint256 i = 0; i < _numberOfAuctions; i++) {
302       itemsPerDay.push(_itemsPerDay[i]);
303       _remainingItemsPerAuction[i] = _itemsPerDay[i];
304     }
305     minimumUnitPrice = [40000000000000000,60000000000000000,80000000000000000];
306     pause();
307   }
308 
309   modifier whenAuctionActive() {
310     require(!currentAuctionStatus().ended, "Auction has already ended.");
311     require(currentAuctionStatus().started, "Auction hasn't started yet.");
312     _;
313   }
314 
315   modifier whenPreAuction() {
316     require(!currentAuctionStatus().ended, "Auction has already ended.");
317     require(!currentAuctionStatus().started, "Auction has already started.");
318     _;
319   }
320 
321   modifier whenAuctionEnded() {
322     require(currentAuctionStatus().ended, "Auction hasn't ended yet.");
323     require(currentAuctionStatus().started, "Auction hasn't started yet.");
324     _;
325   }
326 
327   function pause() public onlyOwner {
328     _pause();
329   }
330 
331   function unpause() public onlyOwner {
332     _unpause();
333   }
334 
335   function setAllowWithdrawals(bool allowWithdrawals_) public onlyOwner {
336     _allowWithdrawals = allowWithdrawals_;
337   }
338 
339   function getAllowWithdrawals() public view returns (bool) {
340     return _allowWithdrawals;
341   }
342 
343   function auctionStatus(uint256 _auctionID) public view returns (AuctionStatus memory) {
344     return _auctionStatus[_auctionID];
345   }
346 
347   function currentAuctionStatus() public view returns (AuctionStatus memory) {
348     return _auctionStatus[getCurrentAuctionID()];
349   }
350 
351 
352   function contractBalance() external view returns (uint256) {
353     return address(this).balance;
354   }
355 
356   function bidsPlacedCount() external view returns (uint256) {
357     return _bidPlacedCounter.current();
358   }
359 
360   function getCurrentAuctionID() public view returns (uint) {
361     return _auctionIDCounter.current();
362   }
363 
364   function incrementAuctionID() public onlyOwner whenPaused whenAuctionEnded {
365     _auctionIDCounter.increment();
366     require(_auctionIDCounter.current() < numberOfAuctions, "Max number of auctions reached.");
367   }
368   
369   function finalizeAuctions() public onlyOwner whenPaused whenAuctionEnded {
370     require(_auctionIDCounter.current() == numberOfAuctions - 1, "Auctions not over");      
371     _auctionIDCounter.increment();
372     _auctionStatus[numberOfAuctions].started = true;
373     _auctionStatus[numberOfAuctions].ended = true;
374   }
375 
376 
377   function decrementAuctionID() public onlyOwner whenPaused {
378     _auctionIDCounter.decrement();
379   }
380 
381   function startAuction() external onlyOwner whenPreAuction {
382     uint256 currentAuctionID = getCurrentAuctionID();
383     _auctionStatus[currentAuctionID].started = true;
384     if (paused()) {
385       unpause();
386     }
387     emit AuctionStarted(currentAuctionID);
388   }
389 
390   function endAuction() external onlyOwner whenAuctionActive {
391     uint256 currentAuctionID = getCurrentAuctionID();
392     _auctionStatus[currentAuctionID].ended = true;
393     if (!paused()) {
394       pause();
395     }
396     emit AuctionEnded(currentAuctionID);
397   }
398 
399   function getBid(address bidder) external view returns (Bid memory) {
400     return _bids[bidder];
401   }
402 
403   function getRemainingItemsForAuction(uint256 auctionID) external view returns (uint256) {
404     require(auctionID < numberOfAuctions, "Invalid auctionID.");
405     return _remainingItemsPerAuction[auctionID];
406   }
407 
408 
409   function selectWinners(address[] calldata bidders) external onlyOwner whenPaused whenAuctionEnded {
410     uint256 auctionID = getCurrentAuctionID();
411 
412     for(uint256 i = 0; i < bidders.length; i++) {
413       address bidder = bidders[i];
414       uint256 bidUnitPrice = _bids[bidder].unitPrice;
415       uint256 bidQuantity = _bids[bidder].quantity;
416 
417 
418       if (bidUnitPrice == 0 || bidQuantity == 0) {
419         continue;
420       }
421 
422       if (_remainingItemsPerAuction[auctionID] == bidQuantity) {
423 
424         _bids[bidder] = Bid(0,0);
425         emit WinnerSelected(auctionID, bidder, bidUnitPrice, bidQuantity);
426         _remainingItemsPerAuction[auctionID] = 0;
427         break;
428       } else if (_remainingItemsPerAuction[auctionID] < bidQuantity) {
429 
430         emit WinnerSelected(auctionID, bidder, bidUnitPrice, _remainingItemsPerAuction[auctionID]);
431 
432         _bids[bidder].quantity -= _remainingItemsPerAuction[auctionID];
433         _remainingItemsPerAuction[auctionID] = 0;
434         break;
435       } else {
436         
437         _bids[bidder] = Bid(0,0);
438         emit WinnerSelected(auctionID, bidder, bidUnitPrice, bidQuantity);
439         _remainingItemsPerAuction[auctionID] -= bidQuantity;
440       }
441     }
442   }
443 
444 
445   function refundBidders(address payable[] calldata bidders) external onlyOwner whenPaused whenAuctionEnded {
446     uint256 totalRefundAmount = 0;
447     for(uint256 i = 0; i < bidders.length; i++) {
448       address payable bidder = bidders[i];
449       uint256 refundAmount = _bids[bidder].unitPrice * _bids[bidder].quantity;
450 
451   
452       if (refundAmount == 0) {
453         continue;
454       }
455 
456       _bids[bidder] = Bid(0,0);
457       (bool success, ) = bidder.call{ value: refundAmount }("");
458       require(success, "Transfer failed.");
459       totalRefundAmount += refundAmount;
460       emit BidderRefunded(bidder, refundAmount);
461     }
462   }
463 
464   function withdrawContractBalance() external onlyOwner {
465     (bool success, ) = beneficiaryAddress.call{value: address(this).balance}("");
466     require(success, "Transfer failed.");
467   }
468   
469   function withdrawPartialContractBalance(uint256 amount) external onlyOwner {
470     require(amount <= address(this).balance, "More than balance");
471     (bool success, ) = beneficiaryAddress.call{value: amount}("");
472     require(success, "Transfer failed.");
473   }
474 
475 
476   function claimRefund() external whenPaused whenAuctionEnded {
477 
478     require(_allowWithdrawals, "Withdrawals are not allowed right now.");
479     uint256 refundAmount = _bids[msg.sender].unitPrice * _bids[msg.sender].quantity;
480     require(refundAmount > 0, "Refund amount is 0.");
481     _bids[msg.sender] = Bid(0,0);
482     (bool success, ) = msg.sender.call{ value: refundAmount }("");
483     require(success, "Transfer failed.");
484     emit BidderRefunded(msg.sender, refundAmount);
485   }
486 
487 
488   function placeBid(uint256 quantity, uint256 unitPrice) external payable whenNotPaused whenAuctionActive {
489 
490     if (msg.value > 0 && msg.value < minimumBidIncrement) {
491       revert("Bid lower than minimum bid increment.");
492     }
493 
494 
495     uint256 initialUnitPrice = _bids[msg.sender].unitPrice;
496     uint256 initialQuantity = _bids[msg.sender].quantity;
497     uint256 initialTotalValue = initialUnitPrice * initialQuantity;
498 
499 
500     uint256 finalUnitPrice = unitPrice;
501     uint256 finalQuantity = quantity;
502     uint256 finalTotalValue = initialTotalValue + msg.value;
503 
504 
505     require(finalUnitPrice % unitPriceStepSize == 0, "Unit price step too small.");
506 
507 
508     require(finalQuantity >= minimumQuantity, "Quantity too low.");
509     require(finalQuantity <= maximumQuantity, "Quantity too high.");
510 
511 
512     require(finalTotalValue >= initialTotalValue, "Total value can't be lowered.");
513 
514 
515     require(finalUnitPrice >= initialUnitPrice, "Unit price can't be lowered.");
516 
517 
518     require(finalQuantity * finalUnitPrice == finalTotalValue, "Quantity * Unit Price != Total Value");
519 
520 
521     require(finalUnitPrice >= minimumUnitPrice[_auctionIDCounter.current()], "Bid unit price too low.");
522 
523 
524     if (initialUnitPrice == finalUnitPrice && initialQuantity == finalQuantity) {
525       revert("This bid doesn't change anything.");
526     }
527 
528 
529     _bids[msg.sender].unitPrice = finalUnitPrice;
530     _bids[msg.sender].quantity = finalQuantity;
531 
532     emit BidPlaced(_auctionIDCounter.current(), msg.sender, _bidPlacedCounter.current(), finalUnitPrice, finalQuantity);
533 
534     _bidPlacedCounter.increment();
535   }
536 
537 
538   receive() external payable {
539     require(msg.value > 0, "No ether was sent.");
540     require(msg.sender == beneficiaryAddress || msg.sender == owner(), "Only owner or beneficiary can fund contract.");
541   }
542 }