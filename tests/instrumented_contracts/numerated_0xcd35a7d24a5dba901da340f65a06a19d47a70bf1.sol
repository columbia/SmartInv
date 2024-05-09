1 // File: contracts/lib/LibMath.sol
2 
3 pragma solidity ^0.5.7;
4 
5 contract LibMath {
6     // Copied from openzeppelin Math
7     /**
8     * @dev Returns the largest of two numbers.
9     */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15     * @dev Returns the smallest of two numbers.
16     */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22     * @dev Calculates the average of two numbers. Since these are integers,
23     * averages of an even and odd number cannot be represented, and will be
24     * rounded down.
25     */
26     function average(uint256 a, uint256 b) internal pure returns (uint256) {
27         // (a + b) / 2 can overflow, so we distribute
28         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
29     }
30 
31     // Modified from openzeppelin SafeMath
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51     */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63     */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72     * @dev Adds two unsigned integers, reverts on overflow.
73     */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a);
77 
78         return c;
79     }
80 
81     /**
82     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83     * reverts when dividing by zero.
84     */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0);
87         return a % b;
88     }
89 
90     // Copied from 0x LibMath
91     /*
92       Copyright 2018 ZeroEx Intl.
93       Licensed under the Apache License, Version 2.0 (the "License");
94       you may not use this file except in compliance with the License.
95       You may obtain a copy of the License at
96         http://www.apache.org/licenses/LICENSE-2.0
97       Unless required by applicable law or agreed to in writing, software
98       distributed under the License is distributed on an "AS IS" BASIS,
99       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
100       See the License for the specific language governing permissions and
101       limitations under the License.
102     */
103     /// @dev Calculates partial value given a numerator and denominator rounded down.
104     ///      Reverts if rounding error is >= 0.1%
105     /// @param numerator Numerator.
106     /// @param denominator Denominator.
107     /// @param target Value to calculate partial of.
108     /// @return Partial value of target rounded down.
109     function safeGetPartialAmountFloor(
110         uint256 numerator,
111         uint256 denominator,
112         uint256 target
113     )
114     internal
115     pure
116     returns (uint256 partialAmount)
117     {
118         require(
119             denominator > 0,
120             "DIVISION_BY_ZERO"
121         );
122 
123         require(
124             !isRoundingErrorFloor(
125             numerator,
126             denominator,
127             target
128         ),
129             "ROUNDING_ERROR"
130         );
131 
132         partialAmount = div(
133             mul(numerator, target),
134             denominator
135         );
136         return partialAmount;
137     }
138 
139     /// @dev Calculates partial value given a numerator and denominator rounded down.
140     ///      Reverts if rounding error is >= 0.1%
141     /// @param numerator Numerator.
142     /// @param denominator Denominator.
143     /// @param target Value to calculate partial of.
144     /// @return Partial value of target rounded up.
145     function safeGetPartialAmountCeil(
146         uint256 numerator,
147         uint256 denominator,
148         uint256 target
149     )
150     internal
151     pure
152     returns (uint256 partialAmount)
153     {
154         require(
155             denominator > 0,
156             "DIVISION_BY_ZERO"
157         );
158 
159         require(
160             !isRoundingErrorCeil(
161             numerator,
162             denominator,
163             target
164         ),
165             "ROUNDING_ERROR"
166         );
167 
168         partialAmount = div(
169             add(
170                 mul(numerator, target),
171                 sub(denominator, 1)
172             ),
173             denominator
174         );
175         return partialAmount;
176     }
177 
178     /// @dev Calculates partial value given a numerator and denominator rounded down.
179     /// @param numerator Numerator.
180     /// @param denominator Denominator.
181     /// @param target Value to calculate partial of.
182     /// @return Partial value of target rounded down.
183     function getPartialAmountFloor(
184         uint256 numerator,
185         uint256 denominator,
186         uint256 target
187     )
188     internal
189     pure
190     returns (uint256 partialAmount)
191     {
192         require(
193             denominator > 0,
194             "DIVISION_BY_ZERO"
195         );
196 
197         partialAmount = div(
198             mul(numerator, target),
199             denominator
200         );
201         return partialAmount;
202     }
203 
204     /// @dev Calculates partial value given a numerator and denominator rounded down.
205     /// @param numerator Numerator.
206     /// @param denominator Denominator.
207     /// @param target Value to calculate partial of.
208     /// @return Partial value of target rounded up.
209     function getPartialAmountCeil(
210         uint256 numerator,
211         uint256 denominator,
212         uint256 target
213     )
214     internal
215     pure
216     returns (uint256 partialAmount)
217     {
218         require(
219             denominator > 0,
220             "DIVISION_BY_ZERO"
221         );
222 
223         partialAmount = div(
224             add(
225                 mul(numerator, target),
226                 sub(denominator, 1)
227             ),
228             denominator
229         );
230         return partialAmount;
231     }
232 
233     /// @dev Checks if rounding error >= 0.1% when rounding down.
234     /// @param numerator Numerator.
235     /// @param denominator Denominator.
236     /// @param target Value to multiply with numerator/denominator.
237     /// @return Rounding error is present.
238     function isRoundingErrorFloor(
239         uint256 numerator,
240         uint256 denominator,
241         uint256 target
242     )
243     internal
244     pure
245     returns (bool isError)
246     {
247         require(
248             denominator > 0,
249             "DIVISION_BY_ZERO"
250         );
251 
252         // The absolute rounding error is the difference between the rounded
253         // value and the ideal value. The relative rounding error is the
254         // absolute rounding error divided by the absolute value of the
255         // ideal value. This is undefined when the ideal value is zero.
256         //
257         // The ideal value is `numerator * target / denominator`.
258         // Let's call `numerator * target % denominator` the remainder.
259         // The absolute error is `remainder / denominator`.
260         //
261         // When the ideal value is zero, we require the absolute error to
262         // be zero. Fortunately, this is always the case. The ideal value is
263         // zero iff `numerator == 0` and/or `target == 0`. In this case the
264         // remainder and absolute error are also zero.
265         if (target == 0 || numerator == 0) {
266             return false;
267         }
268 
269         // Otherwise, we want the relative rounding error to be strictly
270         // less than 0.1%.
271         // The relative error is `remainder / (numerator * target)`.
272         // We want the relative error less than 1 / 1000:
273         //        remainder / (numerator * denominator)  <  1 / 1000
274         // or equivalently:
275         //        1000 * remainder  <  numerator * target
276         // so we have a rounding error iff:
277         //        1000 * remainder  >=  numerator * target
278         uint256 remainder = mulmod(
279             target,
280             numerator,
281             denominator
282         );
283         isError = mul(1000, remainder) >= mul(numerator, target);
284         return isError;
285     }
286 
287     /// @dev Checks if rounding error >= 0.1% when rounding up.
288     /// @param numerator Numerator.
289     /// @param denominator Denominator.
290     /// @param target Value to multiply with numerator/denominator.
291     /// @return Rounding error is present.
292     function isRoundingErrorCeil(
293         uint256 numerator,
294         uint256 denominator,
295         uint256 target
296     )
297     internal
298     pure
299     returns (bool isError)
300     {
301         require(
302             denominator > 0,
303             "DIVISION_BY_ZERO"
304         );
305 
306         // See the comments in `isRoundingError`.
307         if (target == 0 || numerator == 0) {
308             // When either is zero, the ideal value and rounded value are zero
309             // and there is no rounding error. (Although the relative error
310             // is undefined.)
311             return false;
312         }
313         // Compute remainder as before
314         uint256 remainder = mulmod(
315             target,
316             numerator,
317             denominator
318         );
319         remainder = sub(denominator, remainder) % denominator;
320         isError = mul(1000, remainder) >= mul(numerator, target);
321         return isError;
322     }
323 }
324 
325 // File: contracts/lib/Ownable.sol
326 
327 pragma solidity ^0.5.0;
328 
329 /**
330  * @title Ownable
331  * @dev The Ownable contract has an owner address, and provides basic authorization control
332  * functions, this simplifies the implementation of "user permissions".
333  */
334 contract Ownable {
335     address private _owner;
336 
337     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
338 
339     /**
340      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
341      * account.
342      */
343     constructor () internal {
344         _owner = msg.sender;
345         emit OwnershipTransferred(address(0), _owner);
346     }
347 
348     /**
349      * @return the address of the owner.
350      */
351     function owner() public view returns (address) {
352         return _owner;
353     }
354 
355     /**
356      * @dev Throws if called by any account other than the owner.
357      */
358     modifier onlyOwner() {
359         require(isOwner());
360         _;
361     }
362 
363     /**
364      * @return true if `msg.sender` is the owner of the contract.
365      */
366     function isOwner() public view returns (bool) {
367         return msg.sender == _owner;
368     }
369 
370     /**
371      * @dev Allows the current owner to relinquish control of the contract.
372      * @notice Renouncing to ownership will leave the contract without an owner.
373      * It will not be possible to call the functions with the `onlyOwner`
374      * modifier anymore.
375      */
376     function renounceOwnership() public onlyOwner {
377         emit OwnershipTransferred(_owner, address(0));
378         _owner = address(0);
379     }
380 
381     /**
382      * @dev Allows the current owner to transfer control of the contract to a newOwner.
383      * @param newOwner The address to transfer ownership to.
384      */
385     function transferOwnership(address newOwner) public onlyOwner {
386         _transferOwnership(newOwner);
387     }
388 
389     /**
390      * @dev Transfers control of the contract to a newOwner.
391      * @param newOwner The address to transfer ownership to.
392      */
393     function _transferOwnership(address newOwner) internal {
394         require(newOwner != address(0));
395         emit OwnershipTransferred(_owner, newOwner);
396         _owner = newOwner;
397     }
398 }
399 
400 // File: contracts/lib/ReentrancyGuard.sol
401 
402 pragma solidity ^0.5.0;
403 
404 /**
405  * @title Helps contracts guard against reentrancy attacks.
406  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
407  * @dev If you mark a function `nonReentrant`, you should also
408  * mark it `external`.
409  */
410 contract ReentrancyGuard {
411     /// @dev counter to allow mutex lock with only one SSTORE operation
412     uint256 private _guardCounter;
413 
414     constructor () internal {
415         // The counter starts at one to prevent changing it from zero to a non-zero
416         // value, which is a more expensive operation.
417         _guardCounter = 1;
418     }
419 
420     /**
421      * @dev Prevents a contract from calling itself, directly or indirectly.
422      * Calling a `nonReentrant` function from another `nonReentrant`
423      * function is not supported. It is possible to prevent this from happening
424      * by making the `nonReentrant` function external, and make it call a
425      * `private` function that does the actual work.
426      */
427     modifier nonReentrant() {
428         _guardCounter += 1;
429         uint256 localCounter = _guardCounter;
430         _;
431         require(localCounter == _guardCounter);
432     }
433 }
434 
435 // File: contracts/bank/IBank.sol
436 
437 pragma solidity ^0.5.7;
438 
439 /// Bank Interface.
440 interface IBank {
441 
442     /// Modifies authorization of an address. Only contract owner can call this function.
443     /// @param target Address to authorize / deauthorize.
444     /// @param allowed Whether the target address is authorized.
445     function authorize(address target, bool allowed) external;
446 
447     /// Modifies user approvals of an address.
448     /// @param target Address to approve / unapprove.
449     /// @param allowed Whether the target address is user approved.
450     function userApprove(address target, bool allowed) external;
451 
452     /// Batch modifies user approvals.
453     /// @param targetList Array of addresses to approve / unapprove.
454     /// @param allowedList Array of booleans indicating whether the target address is user approved.
455     function batchUserApprove(address[] calldata targetList, bool[] calldata allowedList) external;
456 
457     /// Gets all authorized addresses.
458     /// @return Array of authorized addresses.
459     function getAuthorizedAddresses() external view returns (address[] memory);
460 
461     /// Gets all user approved addresses.
462     /// @return Array of user approved addresses.
463     function getUserApprovedAddresses() external view returns (address[] memory);
464 
465     /// Checks whether the user has enough deposit.
466     /// @param token Token address.
467     /// @param user User address.
468     /// @param amount Token amount.
469     /// @param data Additional token data (e.g. tokenId for ERC721).
470     /// @return Whether the user has enough deposit.
471     function hasDeposit(address token, address user, uint256 amount, bytes calldata data) external view returns (bool);
472 
473     /// Checks token balance available to use (including user deposit amount + user approved allowance amount).
474     /// @param token Token address.
475     /// @param user User address.
476     /// @param data Additional token data (e.g. tokenId for ERC721).
477     /// @return Token amount available.
478     function getAvailable(address token, address user, bytes calldata data) external view returns (uint256);
479 
480     /// Gets balance of user's deposit.
481     /// @param token Token address.
482     /// @param user User address.
483     /// @return Token deposit amount.
484     function balanceOf(address token, address user) external view returns (uint256);
485 
486     /// Deposits token from user wallet to bank.
487     /// @param token Token address.
488     /// @param user User address (allows third-party give tokens to any users).
489     /// @param amount Token amount.
490     /// @param data Additional token data (e.g. tokenId for ERC721).
491     function deposit(address token, address user, uint256 amount, bytes calldata data) external payable;
492 
493     /// Withdraws token from bank to user wallet.
494     /// @param token Token address.
495     /// @param amount Token amount.
496     /// @param data Additional token data (e.g. tokenId for ERC721).
497     function withdraw(address token, uint256 amount, bytes calldata data) external;
498 
499     /// Transfers token from one address to another address.
500     /// Only caller who are double-approved by both bank owner and token owner can invoke this function.
501     /// @param token Token address.
502     /// @param from The current token owner address.
503     /// @param to The new token owner address.
504     /// @param amount Token amount.
505     /// @param data Additional token data (e.g. tokenId for ERC721).
506     /// @param fromDeposit True if use fund from bank deposit. False if use fund from user wallet.
507     /// @param toDeposit True if deposit fund to bank deposit. False if send fund to user wallet.
508     function transferFrom(
509         address token,
510         address from,
511         address to,
512         uint256 amount,
513         bytes calldata data,
514         bool fromDeposit,
515         bool toDeposit
516     )
517     external;
518 }
519 
520 // File: contracts/router/IExchangeHandler.sol
521 
522 pragma solidity ^0.5.7;
523 
524 /// Interface of exchange handler.
525 interface IExchangeHandler {
526 
527     /// Gets maximum available amount can be spent on order (fee not included).
528     /// @param data General order data.
529     /// @return availableToFill Amount can be spent on order.
530     /// @return feePercentage Fee percentage of order.
531     function getAvailableToFill(
532         bytes calldata data
533     )
534     external
535     view
536     returns (uint256 availableToFill, uint256 feePercentage);
537 
538     /// Fills an order on the target exchange.
539     /// NOTE: The required funds must be transferred to this contract in the same transaction of calling this function.
540     /// @param data General order data.
541     /// @param takerAmountToFill Taker token amount to spend on order (fee not included).
542     /// @return makerAmountReceived Amount received from trade.
543     function fillOrder(
544         bytes calldata data,
545         uint256 takerAmountToFill
546     )
547     external
548     payable
549     returns (uint256 makerAmountReceived);
550 }
551 
552 // File: contracts/router/RouterCommon.sol
553 
554 pragma solidity ^0.5.7;
555 
556 contract RouterCommon {
557     struct GeneralOrder {
558         address handler;
559         address makerToken;
560         address takerToken;
561         uint256 makerAmount;
562         uint256 takerAmount;
563         bytes data;
564     }
565 
566     struct FillResults {
567         uint256 makerAmountReceived;
568         uint256 takerAmountSpentOnOrder;
569         uint256 takerAmountSpentOnFee;
570     }
571 }
572 
573 // File: contracts/router/ExchangeRouter.sol
574 
575 pragma solidity ^0.5.7;
576 pragma experimental ABIEncoderV2;
577 
578 
579 
580 
581 
582 
583 
584 // Interface of ERC20 approve function.
585 interface IERC20 {
586     function approve(address spender, uint256 value) external returns (bool);
587 }
588 
589 /// Router contract to support orders from different decentralized exchanges.
590 contract ExchangeRouter is Ownable, ReentrancyGuard, LibMath {
591 
592     IBank public bank;
593     mapping(address => bool) public handlerWhitelist;
594 
595     event Handler(address handler, bool allowed);
596     event FillOrder(
597         bytes orderData,
598         uint256 makerAmountReceived,
599         uint256 takerAmountSpentOnOrder,
600         uint256 takerAmountSpentOnFee
601     );
602 
603     constructor(
604         address _bank
605     )
606     public
607     {
608         bank = IBank(_bank);
609     }
610 
611     /// Fallback function to receive ETH.
612     function() external payable {}
613 
614     /// Sets a handler. Only contract owner can call this function.
615     /// @param handler Handler address.
616     /// @param allowed allowed Whether the handler address is trusted.
617     function setHandler(
618         address handler,
619         bool allowed
620     )
621     external
622     onlyOwner
623     {
624         handlerWhitelist[handler] = allowed;
625         emit Handler(handler, allowed);
626     }
627 
628     /// Fills an order.
629     /// @param order General order object.
630     /// @param takerAmountToFill Taker token amount to spend on order.
631     /// @param allowInsufficient Whether insufficient order remaining is allowed to fill.
632     /// @return results Amounts paid and received.
633     function fillOrder(
634         RouterCommon.GeneralOrder memory order,
635         uint256 takerAmountToFill,
636         bool allowInsufficient
637     )
638     public
639     nonReentrant
640     returns (RouterCommon.FillResults memory results)
641     {
642         results = fillOrderInternal(
643             order,
644                 takerAmountToFill,
645             allowInsufficient
646         );
647     }
648 
649     /// Fills multiple orders by batch.
650     /// @param orderList Array of general order objects.
651     /// @param takerAmountToFillList Array of taker token amounts to spend on order.
652     /// @param allowInsufficientList Array of booleans that whether insufficient order remaining is allowed to fill.
653     function fillOrders(
654         RouterCommon.GeneralOrder[] memory orderList,
655         uint256[] memory takerAmountToFillList,
656         bool[] memory allowInsufficientList
657     )
658     public
659     nonReentrant
660     {
661         for (uint256 i = 0; i < orderList.length; i++) {
662             fillOrderInternal(
663                 orderList[i],
664                 takerAmountToFillList[i],
665                 allowInsufficientList[i]
666             );
667         }
668     }
669 
670     /// Given a list of orders, fill them in sequence until total taker amount is reached.
671     /// NOTE: All orders should be in the same token pair.
672     /// @param orderList Array of general order objects.
673     /// @param totalTakerAmountToFill Stop filling when the total taker amount is reached.
674     /// @return totalFillResults Total amounts paid and received.
675     function marketTakerOrders(
676         RouterCommon.GeneralOrder[] memory orderList,
677         uint256 totalTakerAmountToFill
678     )
679     public
680     returns (RouterCommon.FillResults memory totalFillResults)
681     {
682         for (uint256 i = 0; i < orderList.length; i++) {
683             RouterCommon.FillResults memory singleFillResults = fillOrderInternal(
684                 orderList[i],
685                 sub(totalTakerAmountToFill, totalFillResults.takerAmountSpentOnOrder),
686                 true
687             );
688             addFillResults(totalFillResults, singleFillResults);
689             if (totalFillResults.takerAmountSpentOnOrder >= totalTakerAmountToFill) {
690                 break;
691             }
692         }
693         return totalFillResults;
694     }
695 
696     /// Given a list of orders, fill them in sequence until total maker amount is reached.
697     /// NOTE: All orders should be in the same token pair.
698     /// @param orderList Array of general order objects.
699     /// @param totalMakerAmountToFill Stop filling when the total maker amount is reached.
700     /// @return totalFillResults Total amounts paid and received.
701     function marketMakerOrders(
702         RouterCommon.GeneralOrder[] memory orderList,
703         uint256 totalMakerAmountToFill
704     )
705     public
706     returns (RouterCommon.FillResults memory totalFillResults)
707     {
708         for (uint256 i = 0; i < orderList.length; i++) {
709             RouterCommon.FillResults memory singleFillResults = fillOrderInternal(
710                 orderList[i],
711                 getPartialAmountFloor(
712                     orderList[i].takerAmount,
713                     orderList[i].makerAmount,
714                     sub(totalMakerAmountToFill, totalFillResults.makerAmountReceived)
715                 ),
716                 true
717             );
718             addFillResults(totalFillResults, singleFillResults);
719             if (totalFillResults.makerAmountReceived >= totalMakerAmountToFill) {
720                 break;
721             }
722         }
723         return totalFillResults;
724     }
725 
726     /// Fills an order.
727     /// @param order General order object.
728     /// @param takerAmountToFill Taker token amount to spend on order.
729     /// @param allowInsufficient Whether insufficient order remaining is allowed to fill.
730     /// @return results Amounts paid and received.
731     function fillOrderInternal(
732         RouterCommon.GeneralOrder memory order,
733         uint256 takerAmountToFill,
734         bool allowInsufficient
735     )
736     internal
737     returns (RouterCommon.FillResults memory results)
738     {
739         // Check if the handler is trusted.
740         require(handlerWhitelist[order.handler], "HANDLER_IN_WHITELIST_REQUIRED");
741         // Check order's availability.
742         (uint256 availableToFill, uint256 feePercentage) = IExchangeHandler(order.handler).getAvailableToFill(order.data);
743 
744         if (allowInsufficient) {
745             results.takerAmountSpentOnOrder = min(takerAmountToFill, availableToFill);
746         } else {
747             require(takerAmountToFill <= availableToFill, "INSUFFICIENT_ORDER_REMAINING");
748             results.takerAmountSpentOnOrder = takerAmountToFill;
749         }
750         results.takerAmountSpentOnFee = mul(results.takerAmountSpentOnOrder, feePercentage) / (1 ether);
751         if (results.takerAmountSpentOnOrder > 0) {
752             // Transfer funds from bank deposit to corresponding handler.
753             bank.transferFrom(
754                 order.takerToken,
755                 msg.sender,
756                 order.handler,
757                 add(results.takerAmountSpentOnOrder, results.takerAmountSpentOnFee),
758                 "",
759                 true,
760                 false
761             );
762             // Fill the order via handler.
763             results.makerAmountReceived = IExchangeHandler(order.handler).fillOrder(
764                 order.data,
765                 results.takerAmountSpentOnOrder
766             );
767             if (results.makerAmountReceived > 0) {
768                 if (order.makerToken == address(0)) {
769                     bank.deposit.value(results.makerAmountReceived)(
770                         address(0),
771                         msg.sender,
772                         results.makerAmountReceived,
773                         ""
774                     );
775                 } else {
776                     require(IERC20(order.makerToken).approve(address(bank), results.makerAmountReceived));
777                     bank.deposit(
778                         order.makerToken,
779                         msg.sender,
780                         results.makerAmountReceived,
781                         ""
782                     );
783                 }
784             }
785             emit FillOrder(
786                 order.data,
787                 results.makerAmountReceived,
788                 results.takerAmountSpentOnOrder,
789                 results.takerAmountSpentOnFee
790             );
791         }
792     }
793 
794     /// @dev Adds properties of a single FillResults to total FillResults.
795     /// @param totalFillResults Fill results instance that will be added onto.
796     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
797     function addFillResults(
798         RouterCommon.FillResults memory totalFillResults,
799         RouterCommon.FillResults memory singleFillResults
800     )
801     internal
802     pure
803     {
804         totalFillResults.makerAmountReceived = add(totalFillResults.makerAmountReceived, singleFillResults.makerAmountReceived);
805         totalFillResults.takerAmountSpentOnOrder = add(totalFillResults.takerAmountSpentOnOrder, singleFillResults.takerAmountSpentOnOrder);
806         totalFillResults.takerAmountSpentOnFee = add(totalFillResults.takerAmountSpentOnFee, singleFillResults.takerAmountSpentOnFee);
807     }
808 }