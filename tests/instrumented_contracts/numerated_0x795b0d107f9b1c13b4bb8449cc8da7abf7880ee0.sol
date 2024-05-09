1 pragma solidity 0.5.4;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title Helps contracts guard against reentrancy attacks.
76  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
77  * @dev If you mark a function `nonReentrant`, you should also
78  * mark it `external`.
79  */
80 contract ReentrancyGuard {
81     /// @dev counter to allow mutex lock with only one SSTORE operation
82     uint256 private _guardCounter;
83 
84     constructor () internal {
85         // The counter starts at one to prevent changing it from zero to a non-zero
86         // value, which is a more expensive operation.
87         _guardCounter = 1;
88     }
89 
90     /**
91      * @dev Prevents a contract from calling itself, directly or indirectly.
92      * Calling a `nonReentrant` function from another `nonReentrant`
93      * function is not supported. It is possible to prevent this from happening
94      * by making the `nonReentrant` function external, and make it call a
95      * `private` function that does the actual work.
96      */
97     modifier nonReentrant() {
98         _guardCounter += 1;
99         uint256 localCounter = _guardCounter;
100         _;
101         require(localCounter == _guardCounter);
102     }
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Unsigned math operations with safety checks that revert on error
108  */
109 library SafeMath {
110     /**
111     * @dev Multiplies two unsigned integers, reverts on overflow.
112     */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b);
123 
124         return c;
125     }
126 
127     /**
128     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
129     */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Solidity only automatically asserts when dividing by 0
132         require(b > 0);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141     */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150     * @dev Adds two unsigned integers, reverts on overflow.
151     */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a);
155 
156         return c;
157     }
158 
159     /**
160     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
161     * reverts when dividing by zero.
162     */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b != 0);
165         return a % b;
166     }
167 }
168 
169 
170 
171 // ==========================================================
172 // Copyright 2018 Confideal Ltd. All rights reserved.
173 // ==========================================================
174 
175 contract OTCDeal is ReentrancyGuard {
176     using SafeMath for uint256;
177 
178     uint8 constant public version = 1;
179 
180     enum Status {
181         Running,
182         CloseoutProposed,
183         ClosedOut,
184         Terminated,
185         Arbitration,
186         Resolved
187     }
188 
189     Status public status = Status.Running;
190     uint32 public statusTime = uint32(now);
191     uint32 public paymentDeadline; // timestamp
192 
193     bytes32[] public dataHashes;
194 
195     address payable public seller;
196     address payable public buyer;
197     address public sellerPartner;
198     address public buyerPartner;
199 
200     uint256 public price;
201     uint256 public deskFee;
202     uint256 public closeoutCredit;
203 
204     bool public isRefundBySellerSet;
205     bool public isRefundByBuyerSet;
206     bool public sellerAssetSent;
207     bool public buyerAssetSent;
208     uint256 public refundBySeller;
209     uint256 public refundByBuyer;
210     uint256 public sellerAsset;
211     uint256 public buyerAsset;
212 
213     bytes32 public claimHash;
214 
215     OTCDesk private desk;
216 
217     event PaymentDeadlineProlongation();
218     event CloseoutProposition();
219     event Closeout();
220     event Termination();
221     event Arbitration();
222     event DisputeResolution();
223     event SellerAssetWithdrawal();
224     event BuyerAssetWithdrawal();
225 
226     constructor(
227         bytes32 _dataHash,
228         address payable _seller,
229         address payable _buyer,
230         address _sellerPartner,
231         address _buyerPartner,
232         uint256 _price,
233         uint32 _paymentWindow,
234         bool _buyerIsTaker
235     )
236     public
237     payable
238     {
239         deskFee = _price.div(100);
240 
241         if (_buyerIsTaker) {
242             require(msg.value == _price.add(deskFee));
243         } else {
244             require(msg.value == _price);
245         }
246 
247         desk = OTCDesk(msg.sender);
248 
249         dataHashes.push(_dataHash);
250         seller = _seller;
251         buyer = _buyer;
252         sellerPartner = _sellerPartner;
253         buyerPartner = _buyerPartner;
254         price = _price;
255         paymentDeadline = uint32(now.add(_paymentWindow));
256     }
257 
258     function transferCloseoutCredit()
259     external
260     payable
261     nonReentrant
262     {
263         require(msg.sender == address(desk));
264         closeoutCredit = closeoutCredit.add(msg.value);
265         require(buyer.send(closeoutCredit));
266     }
267 
268     function prolong(uint32 _paymentWindow, bytes32 _dataHash)
269     external
270     {
271         require(status == Status.Running);
272         require(msg.sender == seller);
273 
274         uint32 newDeadline = uint32(now.add(_paymentWindow));
275         require(newDeadline >= paymentDeadline);
276 
277         dataHashes.push(_dataHash);
278         paymentDeadline = newDeadline;
279         emit PaymentDeadlineProlongation();
280     }
281 
282     function terminate()
283     external
284     nonReentrant
285     {
286         if (msg.sender == buyer) {
287             require(status == Status.Running || status == Status.CloseoutProposed);
288         } else {
289             require(msg.sender == seller);
290             require(status == Status.Running);
291             require(paymentDeadline < now);
292         }
293 
294         emit Termination();
295         status = Status.Terminated;
296         statusTime = uint32(now);
297 
298         sellerAsset = address(this).balance;
299         sellerAssetSent = seller.send(sellerAsset);
300     }
301 
302     function closeOut(uint256 _refund)
303     external
304     nonReentrant
305     {
306         require(status == Status.Running || status == Status.CloseoutProposed);
307         require(_refund <= address(this).balance.sub(deskFee));
308 
309         if (msg.sender == seller) {
310             if (_refund > 0) {
311                 require(!isRefundBySellerSet || _refund != refundBySeller);
312                 isRefundBySellerSet = true;
313                 refundBySeller = _refund;
314             }
315         } else {
316             require(msg.sender == buyer);
317             require(!isRefundByBuyerSet || _refund != refundByBuyer);
318             isRefundByBuyerSet = true;
319             refundByBuyer = _refund;
320         }
321 
322         if (msg.sender == buyer || _refund > 0) {
323             emit CloseoutProposition();
324             if (status == Status.Running) {
325                 status = Status.CloseoutProposed;
326                 statusTime = uint32(now);
327             }
328         }
329 
330         if ((isRefundBySellerSet && isRefundByBuyerSet && refundBySeller == refundByBuyer)
331             || (_refund == 0 && msg.sender == seller)) {
332             emit Closeout();
333             status = Status.ClosedOut;
334             statusTime = uint32(now);
335 
336             transferAssets(_refund);
337         }
338     }
339 
340 
341     function escalate(bytes32 _claimHash)
342     external
343     {
344         require(msg.sender == seller || msg.sender == buyer);
345         require(status == Status.Running || status == Status.CloseoutProposed);
346 
347         // paymentDeadline + 2 hours
348         require(now >= uint256(paymentDeadline).add(7200));
349 
350         claimHash = _claimHash;
351 
352         emit Arbitration();
353         status = Status.Arbitration;
354         statusTime = uint32(now);
355 
356         desk.assignArbitratorFromPool();
357     }
358 
359     function resolveDispute(
360         bytes32 _dataHash,
361         uint256 _sellerAsset
362     )
363     external
364     nonReentrant
365     {
366         require(status == Status.Arbitration);
367         require(msg.sender == address(desk));
368         require(_sellerAsset <= address(this).balance.sub(deskFee));
369 
370         emit DisputeResolution();
371         status = Status.Resolved;
372         statusTime = uint32(now);
373 
374         dataHashes.push(_dataHash);
375 
376         transferAssets(_sellerAsset);
377     }
378 
379     function withdrawSellerAsset()
380     external
381     nonReentrant
382     {
383         require(status == Status.ClosedOut || status == Status.Terminated || status == Status.Resolved);
384         require(msg.sender == seller && sellerAsset > 0 && !sellerAssetSent);
385 
386         sellerAssetSent = unsafeTransfer(seller, sellerAsset);
387         if (sellerAssetSent) {
388             emit SellerAssetWithdrawal();
389         }
390     }
391 
392     function withdrawBuyerAsset()
393     external
394     nonReentrant
395     {
396         require(status == Status.ClosedOut || status == Status.Resolved);
397         require(msg.sender == buyer && buyerAsset > 0 && !buyerAssetSent);
398 
399         buyerAssetSent = unsafeTransfer(buyer, buyerAsset);
400         if (buyerAssetSent) {
401             emit BuyerAssetWithdrawal();
402         }
403     }
404 
405     function()
406     external
407     {
408         revert();
409     }
410 
411     function transferAssets(uint256 _sellerAsset)
412     private
413     {
414         sellerAsset = _sellerAsset;
415         buyerAsset = address(this).balance.sub(deskFee).sub(sellerAsset);
416 
417         uint256 closeoutCreditReturn;
418         if (closeoutCredit > 0) {
419             if (buyerAsset <= closeoutCredit) {
420                 closeoutCreditReturn = buyerAsset;
421             } else {
422                 closeoutCreditReturn = closeoutCredit;
423             }
424             buyerAsset = buyerAsset.sub(closeoutCreditReturn);
425         }
426 
427         desk.collectFee.value(deskFee.add(closeoutCreditReturn))(closeoutCreditReturn);
428 
429         if (sellerAsset > 0) {
430             sellerAssetSent = seller.send(sellerAsset);
431         }
432         if (buyerAsset > 0) {
433             buyerAssetSent = buyer.send(buyerAsset);
434         }
435     }
436 
437     function unsafeTransfer(address _recipient, uint256 _amount)
438     private
439     returns (bool success)
440     {
441         (success,) = _recipient.call.value(_amount)("");
442         return success;
443     }
444 }
445 
446 
447 contract OTCDesk is Ownable, ReentrancyGuard {
448     using SafeMath for uint256;
449 
450     uint8 constant public version = 1;
451 
452     address public beneficiary = msg.sender;
453     address public arbitrationManager = msg.sender;
454 
455     uint256 public confidealFund;
456 
457     uint256 public closeoutCredit = 0.0017 ether;
458 
459     address[] public arbitratorsPool;
460 
461     mapping(address => address) public arbitrators; // deal => arbitrator
462 
463     event DealCreation(address deal);
464     event FeePayment(address deal, uint256 amount);
465     event CloseoutCreditIssuance(address deal, uint256 amount);
466     event CloseoutCreditCollection(address deal, uint256 amount);
467     event ArbitratorAssignment(address deal, address arbitrator);
468 
469     function newDeal(
470         bytes32 _dataHash,
471         address payable _buyer,
472         address _sellerPartner,
473         address _buyerPartner,
474         uint256 _price,
475         uint32 _paymentWindow,
476         bool _buyerIsTaker
477     )
478     public
479     payable
480     {
481         OTCDeal _deal = (new OTCDeal).value(msg.value)(
482             _dataHash,
483             msg.sender,
484             _buyer,
485             _sellerPartner,
486             _buyerPartner,
487             _price,
488             _paymentWindow,
489             _buyerIsTaker
490         );
491 
492         emit DealCreation(address(_deal));
493 
494         if (_buyer.balance < closeoutCredit) {
495             uint256 _closeoutCredit = closeoutCredit.sub(_buyer.balance);
496             if (confidealFund >= _closeoutCredit) {
497                 confidealFund = confidealFund.sub(_closeoutCredit);
498                 _deal.transferCloseoutCredit.value(_closeoutCredit)();
499                 emit CloseoutCreditIssuance(address(_deal), _closeoutCredit);
500             }
501         }
502     }
503 
504     function setBeneficiary(address _beneficiary)
505     external
506     onlyOwner
507     {
508         beneficiary = _beneficiary;
509     }
510 
511     function setArbitrationManager(address _arbitrationManager)
512     external
513     onlyOwner
514     {
515         arbitrationManager = _arbitrationManager;
516     }
517 
518     function setCloseoutCredit(uint256 _closeoutCredit)
519     external
520     onlyOwner
521     {
522         closeoutCredit = _closeoutCredit;
523     }
524 
525     function collectFee(uint256 _closeoutCreditReturn)
526     external
527     payable
528     {
529         uint256 fee = msg.value.sub(_closeoutCreditReturn);
530         confidealFund = confidealFund.add(fee);
531         emit FeePayment(msg.sender, fee);
532 
533         if (_closeoutCreditReturn > 0) {
534             confidealFund = confidealFund.add(_closeoutCreditReturn);
535             emit CloseoutCreditCollection(msg.sender, _closeoutCreditReturn);
536         }
537     }
538 
539     function arbitratorsPoolSize()
540     external
541     view
542     returns (uint)
543     {
544         return arbitratorsPool.length;
545     }
546 
547     function addArbitratorToPool(address _arbitrator)
548     external
549     {
550         require(msg.sender == arbitrationManager);
551 
552         arbitratorsPool.push(_arbitrator);
553     }
554 
555     function removeArbitratorFromPool(uint _index)
556     external
557     {
558         require(msg.sender == arbitrationManager);
559         require(arbitratorsPool.length > 0);
560 
561         arbitratorsPool[_index] = arbitratorsPool[arbitratorsPool.length - 1];
562         arbitratorsPool.pop();
563     }
564 
565     function assignArbitratorFromPool()
566     external
567     {
568         if (arbitratorsPool.length == 0) {
569             return;
570         }
571 
572         address _arbitrator = arbitratorsPool[block.number % arbitratorsPool.length];
573         arbitrators[msg.sender] = _arbitrator;
574         emit ArbitratorAssignment(msg.sender, _arbitrator);
575     }
576 
577     function assignArbitrator(address _deal, address _arbitrator)
578     external
579     {
580         require(msg.sender == arbitrationManager);
581 
582         arbitrators[_deal] = _arbitrator;
583         emit ArbitratorAssignment(_deal, _arbitrator);
584     }
585 
586     function resolveDispute(address _deal, bytes32 _dataHash, uint256 _sellerAsset)
587     external
588     {
589         require(msg.sender == arbitrators[_deal]);
590         OTCDeal(_deal).resolveDispute(_dataHash, _sellerAsset);
591     }
592 
593     function withdraw(uint256 _rest)
594     external
595     {
596         require(msg.sender == beneficiary);
597 
598         uint256 _amount = confidealFund.sub(_rest);
599         require(_amount > 0);
600 
601         confidealFund = confidealFund.sub(_amount);
602         (bool _successfulTransfer,) = beneficiary.call.value(_amount)("");
603         require(_successfulTransfer);
604     }
605 
606     function contribute()
607     external
608     payable
609     {
610         confidealFund = confidealFund.add(msg.value);
611     }
612 
613     function()
614     external
615     {
616         revert();
617     }
618 }