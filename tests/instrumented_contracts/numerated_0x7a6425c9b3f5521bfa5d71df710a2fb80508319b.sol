1 // File: @0x/contracts-utils/contracts/src/SafeMath.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 contract SafeMath {
7 
8     function safeMul(uint256 a, uint256 b)
9         internal
10         pure
11         returns (uint256)
12     {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         require(
18             c / a == b,
19             "UINT256_OVERFLOW"
20         );
21         return c;
22     }
23 
24     function safeDiv(uint256 a, uint256 b)
25         internal
26         pure
27         returns (uint256)
28     {
29         uint256 c = a / b;
30         return c;
31     }
32 
33     function safeSub(uint256 a, uint256 b)
34         internal
35         pure
36         returns (uint256)
37     {
38         require(
39             b <= a,
40             "UINT256_UNDERFLOW"
41         );
42         return a - b;
43     }
44 
45     function safeAdd(uint256 a, uint256 b)
46         internal
47         pure
48         returns (uint256)
49     {
50         uint256 c = a + b;
51         require(
52             c >= a,
53             "UINT256_OVERFLOW"
54         );
55         return c;
56     }
57 
58     function max64(uint64 a, uint64 b)
59         internal
60         pure
61         returns (uint256)
62     {
63         return a >= b ? a : b;
64     }
65 
66     function min64(uint64 a, uint64 b)
67         internal
68         pure
69         returns (uint256)
70     {
71         return a < b ? a : b;
72     }
73 
74     function max256(uint256 a, uint256 b)
75         internal
76         pure
77         returns (uint256)
78     {
79         return a >= b ? a : b;
80     }
81 
82     function min256(uint256 a, uint256 b)
83         internal
84         pure
85         returns (uint256)
86     {
87         return a < b ? a : b;
88     }
89 }
90 
91 // File: @0x/contracts-exchange-libs/contracts/src/LibFillResults.sol
92 
93 /*
94 
95   Copyright 2018 ZeroEx Intl.
96 
97   Licensed under the Apache License, Version 2.0 (the "License");
98   you may not use this file except in compliance with the License.
99   You may obtain a copy of the License at
100 
101     http://www.apache.org/licenses/LICENSE-2.0
102 
103   Unless required by applicable law or agreed to in writing, software
104   distributed under the License is distributed on an "AS IS" BASIS,
105   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
106   See the License for the specific language governing permissions and
107   limitations under the License.
108 
109 */
110 
111 pragma solidity ^0.4.24;
112 
113 
114 
115 contract LibFillResults is
116     SafeMath
117 {
118     struct FillResults {
119         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
120         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
121         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
122         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
123     }
124 
125     struct MatchedFillResults {
126         FillResults left;                    // Amounts filled and fees paid of left order.
127         FillResults right;                   // Amounts filled and fees paid of right order.
128         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
129     }
130 
131     /// @dev Adds properties of both FillResults instances.
132     ///      Modifies the first FillResults instance specified.
133     /// @param totalFillResults Fill results instance that will be added onto.
134     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
135     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
136         internal
137         pure
138     {
139         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
140         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
141         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
142         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
143     }
144 }
145 
146 // File: @0x/contracts-exchange-libs/contracts/src/LibEIP712.sol
147 
148 /*
149 
150   Copyright 2018 ZeroEx Intl.
151 
152   Licensed under the Apache License, Version 2.0 (the "License");
153   you may not use this file except in compliance with the License.
154   You may obtain a copy of the License at
155 
156     http://www.apache.org/licenses/LICENSE-2.0
157 
158   Unless required by applicable law or agreed to in writing, software
159   distributed under the License is distributed on an "AS IS" BASIS,
160   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
161   See the License for the specific language governing permissions and
162   limitations under the License.
163 
164 */
165 
166 pragma solidity ^0.4.24;
167 
168 
169 contract LibEIP712 {
170 
171     // EIP191 header for EIP712 prefix
172     string constant internal EIP191_HEADER = "\x19\x01";
173 
174     // EIP712 Domain Name value
175     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
176 
177     // EIP712 Domain Version value
178     string constant internal EIP712_DOMAIN_VERSION = "2";
179 
180     // Hash of the EIP712 Domain Separator Schema
181     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
182         "EIP712Domain(",
183         "string name,",
184         "string version,",
185         "address verifyingContract",
186         ")"
187     ));
188 
189     // Hash of the EIP712 Domain Separator data
190     // solhint-disable-next-line var-name-mixedcase
191     bytes32 public EIP712_DOMAIN_HASH;
192 
193     constructor ()
194         public
195     {
196         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
197             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
198             keccak256(bytes(EIP712_DOMAIN_NAME)),
199             keccak256(bytes(EIP712_DOMAIN_VERSION)),
200             bytes32(address(this))
201         ));
202     }
203 
204     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
205     /// @param hashStruct The EIP712 hash struct.
206     /// @return EIP712 hash applied to this EIP712 Domain.
207     function hashEIP712Message(bytes32 hashStruct)
208         internal
209         view
210         returns (bytes32 result)
211     {
212         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
213 
214         // Assembly for more efficient computing:
215         // keccak256(abi.encodePacked(
216         //     EIP191_HEADER,
217         //     EIP712_DOMAIN_HASH,
218         //     hashStruct    
219         // ));
220 
221         assembly {
222             // Load free memory pointer
223             let memPtr := mload(64)
224 
225             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
226             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
227             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
228 
229             // Compute hash
230             result := keccak256(memPtr, 66)
231         }
232         return result;
233     }
234 }
235 
236 // File: @0x/contracts-exchange-libs/contracts/src/LibOrder.sol
237 
238 /*
239 
240   Copyright 2018 ZeroEx Intl.
241 
242   Licensed under the Apache License, Version 2.0 (the "License");
243   you may not use this file except in compliance with the License.
244   You may obtain a copy of the License at
245 
246     http://www.apache.org/licenses/LICENSE-2.0
247 
248   Unless required by applicable law or agreed to in writing, software
249   distributed under the License is distributed on an "AS IS" BASIS,
250   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
251   See the License for the specific language governing permissions and
252   limitations under the License.
253 
254 */
255 
256 pragma solidity ^0.4.24;
257 
258 
259 
260 contract LibOrder is
261     LibEIP712
262 {
263     // Hash for the EIP712 Order Schema
264     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
265         "Order(",
266         "address makerAddress,",
267         "address takerAddress,",
268         "address feeRecipientAddress,",
269         "address senderAddress,",
270         "uint256 makerAssetAmount,",
271         "uint256 takerAssetAmount,",
272         "uint256 makerFee,",
273         "uint256 takerFee,",
274         "uint256 expirationTimeSeconds,",
275         "uint256 salt,",
276         "bytes makerAssetData,",
277         "bytes takerAssetData",
278         ")"
279     ));
280 
281     // A valid order remains fillable until it is expired, fully filled, or cancelled.
282     // An order's state is unaffected by external factors, like account balances.
283     enum OrderStatus {
284         INVALID,                     // Default value
285         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
286         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
287         FILLABLE,                    // Order is fillable
288         EXPIRED,                     // Order has already expired
289         FULLY_FILLED,                // Order is fully filled
290         CANCELLED                    // Order has been cancelled
291     }
292 
293     // solhint-disable max-line-length
294     struct Order {
295         address makerAddress;           // Address that created the order.      
296         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
297         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
298         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
299         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
300         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
301         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
302         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
303         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
304         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
305         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
306         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
307     }
308     // solhint-enable max-line-length
309 
310     struct OrderInfo {
311         uint8 orderStatus;                    // Status that describes order's validity and fillability.
312         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
313         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
314     }
315 
316     /// @dev Calculates Keccak-256 hash of the order.
317     /// @param order The order structure.
318     /// @return Keccak-256 EIP712 hash of the order.
319     function getOrderHash(Order memory order)
320         internal
321         view
322         returns (bytes32 orderHash)
323     {
324         orderHash = hashEIP712Message(hashOrder(order));
325         return orderHash;
326     }
327 
328     /// @dev Calculates EIP712 hash of the order.
329     /// @param order The order structure.
330     /// @return EIP712 hash of the order.
331     function hashOrder(Order memory order)
332         internal
333         pure
334         returns (bytes32 result)
335     {
336         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
337         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
338         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
339 
340         // Assembly for more efficiently computing:
341         // keccak256(abi.encodePacked(
342         //     EIP712_ORDER_SCHEMA_HASH,
343         //     bytes32(order.makerAddress),
344         //     bytes32(order.takerAddress),
345         //     bytes32(order.feeRecipientAddress),
346         //     bytes32(order.senderAddress),
347         //     order.makerAssetAmount,
348         //     order.takerAssetAmount,
349         //     order.makerFee,
350         //     order.takerFee,
351         //     order.expirationTimeSeconds,
352         //     order.salt,
353         //     keccak256(order.makerAssetData),
354         //     keccak256(order.takerAssetData)
355         // ));
356 
357         assembly {
358             // Calculate memory addresses that will be swapped out before hashing
359             let pos1 := sub(order, 32)
360             let pos2 := add(order, 320)
361             let pos3 := add(order, 352)
362 
363             // Backup
364             let temp1 := mload(pos1)
365             let temp2 := mload(pos2)
366             let temp3 := mload(pos3)
367             
368             // Hash in place
369             mstore(pos1, schemaHash)
370             mstore(pos2, makerAssetDataHash)
371             mstore(pos3, takerAssetDataHash)
372             result := keccak256(pos1, 416)
373             
374             // Restore
375             mstore(pos1, temp1)
376             mstore(pos2, temp2)
377             mstore(pos3, temp3)
378         }
379         return result;
380     }
381 }
382 
383 // File: @0x/contracts-exchange-libs/contracts/src/LibMath.sol
384 
385 /*
386 
387   Copyright 2018 ZeroEx Intl.
388 
389   Licensed under the Apache License, Version 2.0 (the "License");
390   you may not use this file except in compliance with the License.
391   You may obtain a copy of the License at
392 
393     http://www.apache.org/licenses/LICENSE-2.0
394 
395   Unless required by applicable law or agreed to in writing, software
396   distributed under the License is distributed on an "AS IS" BASIS,
397   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
398   See the License for the specific language governing permissions and
399   limitations under the License.
400 
401 */
402 
403 pragma solidity ^0.4.24;
404 
405 
406 
407 contract LibMath is
408     SafeMath
409 {
410     /// @dev Calculates partial value given a numerator and denominator rounded down.
411     ///      Reverts if rounding error is >= 0.1%
412     /// @param numerator Numerator.
413     /// @param denominator Denominator.
414     /// @param target Value to calculate partial of.
415     /// @return Partial value of target rounded down.
416     function safeGetPartialAmountFloor(
417         uint256 numerator,
418         uint256 denominator,
419         uint256 target
420     )
421         internal
422         pure
423         returns (uint256 partialAmount)
424     {
425         require(
426             denominator > 0,
427             "DIVISION_BY_ZERO"
428         );
429 
430         require(
431             !isRoundingErrorFloor(
432                 numerator,
433                 denominator,
434                 target
435             ),
436             "ROUNDING_ERROR"
437         );
438         
439         partialAmount = safeDiv(
440             safeMul(numerator, target),
441             denominator
442         );
443         return partialAmount;
444     }
445 
446     /// @dev Calculates partial value given a numerator and denominator rounded down.
447     ///      Reverts if rounding error is >= 0.1%
448     /// @param numerator Numerator.
449     /// @param denominator Denominator.
450     /// @param target Value to calculate partial of.
451     /// @return Partial value of target rounded up.
452     function safeGetPartialAmountCeil(
453         uint256 numerator,
454         uint256 denominator,
455         uint256 target
456     )
457         internal
458         pure
459         returns (uint256 partialAmount)
460     {
461         require(
462             denominator > 0,
463             "DIVISION_BY_ZERO"
464         );
465 
466         require(
467             !isRoundingErrorCeil(
468                 numerator,
469                 denominator,
470                 target
471             ),
472             "ROUNDING_ERROR"
473         );
474         
475         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
476         //       ceil(a / b) = floor((a + b - 1) / b)
477         // To implement `ceil(a / b)` using safeDiv.
478         partialAmount = safeDiv(
479             safeAdd(
480                 safeMul(numerator, target),
481                 safeSub(denominator, 1)
482             ),
483             denominator
484         );
485         return partialAmount;
486     }
487 
488     /// @dev Calculates partial value given a numerator and denominator rounded down.
489     /// @param numerator Numerator.
490     /// @param denominator Denominator.
491     /// @param target Value to calculate partial of.
492     /// @return Partial value of target rounded down.
493     function getPartialAmountFloor(
494         uint256 numerator,
495         uint256 denominator,
496         uint256 target
497     )
498         internal
499         pure
500         returns (uint256 partialAmount)
501     {
502         require(
503             denominator > 0,
504             "DIVISION_BY_ZERO"
505         );
506 
507         partialAmount = safeDiv(
508             safeMul(numerator, target),
509             denominator
510         );
511         return partialAmount;
512     }
513     
514     /// @dev Calculates partial value given a numerator and denominator rounded down.
515     /// @param numerator Numerator.
516     /// @param denominator Denominator.
517     /// @param target Value to calculate partial of.
518     /// @return Partial value of target rounded up.
519     function getPartialAmountCeil(
520         uint256 numerator,
521         uint256 denominator,
522         uint256 target
523     )
524         internal
525         pure
526         returns (uint256 partialAmount)
527     {
528         require(
529             denominator > 0,
530             "DIVISION_BY_ZERO"
531         );
532 
533         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
534         //       ceil(a / b) = floor((a + b - 1) / b)
535         // To implement `ceil(a / b)` using safeDiv.
536         partialAmount = safeDiv(
537             safeAdd(
538                 safeMul(numerator, target),
539                 safeSub(denominator, 1)
540             ),
541             denominator
542         );
543         return partialAmount;
544     }
545     
546     /// @dev Checks if rounding error >= 0.1% when rounding down.
547     /// @param numerator Numerator.
548     /// @param denominator Denominator.
549     /// @param target Value to multiply with numerator/denominator.
550     /// @return Rounding error is present.
551     function isRoundingErrorFloor(
552         uint256 numerator,
553         uint256 denominator,
554         uint256 target
555     )
556         internal
557         pure
558         returns (bool isError)
559     {
560         require(
561             denominator > 0,
562             "DIVISION_BY_ZERO"
563         );
564         
565         // The absolute rounding error is the difference between the rounded
566         // value and the ideal value. The relative rounding error is the
567         // absolute rounding error divided by the absolute value of the
568         // ideal value. This is undefined when the ideal value is zero.
569         //
570         // The ideal value is `numerator * target / denominator`.
571         // Let's call `numerator * target % denominator` the remainder.
572         // The absolute error is `remainder / denominator`.
573         //
574         // When the ideal value is zero, we require the absolute error to
575         // be zero. Fortunately, this is always the case. The ideal value is
576         // zero iff `numerator == 0` and/or `target == 0`. In this case the
577         // remainder and absolute error are also zero. 
578         if (target == 0 || numerator == 0) {
579             return false;
580         }
581         
582         // Otherwise, we want the relative rounding error to be strictly
583         // less than 0.1%.
584         // The relative error is `remainder / (numerator * target)`.
585         // We want the relative error less than 1 / 1000:
586         //        remainder / (numerator * denominator)  <  1 / 1000
587         // or equivalently:
588         //        1000 * remainder  <  numerator * target
589         // so we have a rounding error iff:
590         //        1000 * remainder  >=  numerator * target
591         uint256 remainder = mulmod(
592             target,
593             numerator,
594             denominator
595         );
596         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
597         return isError;
598     }
599     
600     /// @dev Checks if rounding error >= 0.1% when rounding up.
601     /// @param numerator Numerator.
602     /// @param denominator Denominator.
603     /// @param target Value to multiply with numerator/denominator.
604     /// @return Rounding error is present.
605     function isRoundingErrorCeil(
606         uint256 numerator,
607         uint256 denominator,
608         uint256 target
609     )
610         internal
611         pure
612         returns (bool isError)
613     {
614         require(
615             denominator > 0,
616             "DIVISION_BY_ZERO"
617         );
618         
619         // See the comments in `isRoundingError`.
620         if (target == 0 || numerator == 0) {
621             // When either is zero, the ideal value and rounded value are zero
622             // and there is no rounding error. (Although the relative error
623             // is undefined.)
624             return false;
625         }
626         // Compute remainder as before
627         uint256 remainder = mulmod(
628             target,
629             numerator,
630             denominator
631         );
632         remainder = safeSub(denominator, remainder) % denominator;
633         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
634         return isError;
635     }
636 }
637 
638 // File: contracts/exchange/interfaces/IExchangeCore.sol
639 
640 /*
641 
642   Modified by Metaps Alpha Inc.
643 
644   Copyright 2018 ZeroEx Intl.
645 
646   Licensed under the Apache License, Version 2.0 (the "License");
647   you may not use this file except in compliance with the License.
648   You may obtain a copy of the License at
649 
650     http://www.apache.org/licenses/LICENSE-2.0
651 
652   Unless required by applicable law or agreed to in writing, software
653   distributed under the License is distributed on an "AS IS" BASIS,
654   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
655   See the License for the specific language governing permissions and
656   limitations under the License.
657 
658 */
659 
660 pragma solidity 0.4.24;
661 pragma experimental ABIEncoderV2;
662 
663 
664 contract IExchangeCore {
665 
666     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
667     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
668     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
669     function cancelOrdersUpTo(uint256 targetOrderEpoch)
670         external;
671 
672     /// @dev Fills the input order.
673     /// @param order Order struct containing order specifications.
674     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
675     /// @param signature Proof that order has been created by maker.
676     /// @return Amounts filled and fees paid by maker and taker.
677     function fillOrder(
678         LibOrder.Order memory order,
679         uint256 takerAssetFillAmount,
680         bytes memory signature
681     )
682         public
683         payable
684         returns (LibFillResults.FillResults memory fillResults);
685 
686     /// @dev After calling, the order can not be filled anymore.
687     /// @param order Order struct containing order specifications.
688     function cancelOrder(LibOrder.Order memory order)
689         public;
690 
691     /// @dev Gets information about an order: status, hash, and amount filled.
692     /// @param order Order to gather information on.
693     /// @return OrderInfo Information about the order and its state.
694     ///                   See LibOrder.OrderInfo for a complete description.
695     function getOrderInfo(LibOrder.Order memory order)
696         public
697         view
698         returns (LibOrder.OrderInfo memory orderInfo);
699 
700     /// @dev miime - Update order (Cancel order and then update deposit for new order).
701     /// @param newOrderHash New orderHash for deposit.
702     /// @param newOfferAmount New offer amount.
703     /// @param orderToBeCanceled Order to be canceled.
704     function updateOrder(
705         bytes32 newOrderHash,
706         uint256 newOfferAmount,
707         LibOrder.Order memory orderToBeCanceled
708     )
709         public
710         payable;
711 }
712 
713 // File: contracts/exchange/mixins/MExchangeCore.sol
714 
715 /*
716 
717   Modified by Metaps Alpha Inc.
718 
719   Copyright 2018 ZeroEx Intl.
720 
721   Licensed under the Apache License, Version 2.0 (the "License");
722   you may not use this file except in compliance with the License.
723   You may obtain a copy of the License at
724 
725     http://www.apache.org/licenses/LICENSE-2.0
726 
727   Unless required by applicable law or agreed to in writing, software
728   distributed under the License is distributed on an "AS IS" BASIS,
729   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
730   See the License for the specific language governing permissions and
731   limitations under the License.
732 
733 */
734 
735 pragma solidity 0.4.24;
736 
737 
738 contract MExchangeCore is
739     IExchangeCore
740 {
741     // Fill event is emitted whenever an order is filled.
742     event Fill(
743         address indexed makerAddress,         // Address that created the order.      
744         address indexed feeRecipientAddress,  // Address that received fees.
745         address takerAddress,                 // Address that filled the order.
746         address senderAddress,                // Address that called the Exchange contract (msg.sender).
747         uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker. 
748         uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
749         uint256 makerFeePaid,                 // Amount of ZRX paid to feeRecipient by maker.
750         uint256 takerFeePaid,                 // Amount of ZRX paid to feeRecipient by taker.
751         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
752         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
753         bytes takerAssetData                  // Encoded data specific to takerAsset.
754     );
755 
756     // Cancel event is emitted whenever an individual order is cancelled.
757     event Cancel(
758         address indexed makerAddress,         // Address that created the order.      
759         address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.   
760         address senderAddress,                // Address that called the Exchange contract (msg.sender).
761         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
762         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
763         bytes takerAssetData                  // Encoded data specific to takerAsset.
764     );
765 
766     // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
767     event CancelUpTo(
768         address indexed makerAddress,         // Orders cancelled must have been created by this address.
769         address indexed senderAddress,        // Orders cancelled must have a `senderAddress` equal to this address.
770         uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.
771     );
772 
773     // miime: Transfer event is emitted whenever `transfer` is executed succesfully.
774     event Transfer(
775         address indexed toAddress,
776         uint256 indexed amount
777     );
778 
779     /// @dev Fills the input order.
780     /// @param order Order struct containing order specifications.
781     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
782     /// @param signature Proof that order has been created by maker.
783     /// @return Amounts filled and fees paid by maker and taker.
784     function fillOrderInternal(
785         LibOrder.Order memory order,
786         uint256 takerAssetFillAmount,
787         bytes memory signature
788     )
789         internal
790         returns (LibFillResults.FillResults memory fillResults);
791 
792     /// @dev After calling, the order can not be filled anymore.
793     /// @param order Order struct containing order specifications.
794     function cancelOrderInternal(LibOrder.Order memory order)
795         internal
796         returns (LibOrder.OrderInfo);
797 
798     /// @dev Updates state with results of a fill order.
799     /// @param order that was filled.
800     /// @param takerAddress Address of taker who filled the order.
801     /// @param orderTakerAssetFilledAmount Amount of order already filled.
802     /// @return fillResults Amounts filled and fees paid by maker and taker.
803     function updateFilledState(
804         LibOrder.Order memory order,
805         address takerAddress,
806         bytes32 orderHash,
807         uint256 orderTakerAssetFilledAmount,
808         LibFillResults.FillResults memory fillResults
809     )
810         internal;
811 
812     /// @dev Updates state with results of cancelling an order.
813     ///      State is only updated if the order is currently fillable.
814     ///      Otherwise, updating state would have no effect.
815     /// @param order that was cancelled.
816     /// @param orderHash Hash of order that was cancelled.
817     function updateCancelledState(
818         LibOrder.Order memory order,
819         bytes32 orderHash
820     )
821         internal;
822     
823     /// @dev Validates context for fillOrder. Succeeds or throws.
824     /// @param order to be filled.
825     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
826     /// @param takerAddress Address of order taker.
827     /// @param signature Proof that the orders was created by its maker.
828     function assertFillableOrder(
829         LibOrder.Order memory order,
830         LibOrder.OrderInfo memory orderInfo,
831         address takerAddress,
832         bytes memory signature
833     )
834         internal
835         view;
836     
837     /// @dev Validates context for fillOrder. Succeeds or throws.
838     /// @param order to be filled.
839     /// @param orderInfo Status, orderHash, and amount already filled of order.
840     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
841     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
842     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
843     function assertValidFill(
844         LibOrder.Order memory order,
845         LibOrder.OrderInfo memory orderInfo,
846         uint256 takerAssetFillAmount,
847         uint256 takerAssetFilledAmount,
848         uint256 makerAssetFilledAmount
849     )
850         internal
851         view;
852 
853     /// @dev Validates context for cancelOrder. Succeeds or throws.
854     /// @param order to be cancelled.
855     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
856     function assertValidCancel(
857         LibOrder.Order memory order,
858         LibOrder.OrderInfo memory orderInfo
859     )
860         internal
861         view;
862 
863     /// @dev Calculates amounts filled and fees paid by maker and taker.
864     /// @param order to be filled.
865     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
866     /// @return fillResults Amounts filled and fees paid by maker and taker.
867     function calculateFillResults(
868         LibOrder.Order memory order,
869         uint256 takerAssetFilledAmount
870     )
871         internal
872         pure
873         returns (LibFillResults.FillResults memory fillResults);
874 
875 }
876 
877 // File: contracts/exchange/interfaces/ISignatureValidator.sol
878 
879 /*
880 
881   Copyright 2018 ZeroEx Intl.
882 
883   Licensed under the Apache License, Version 2.0 (the "License");
884   you may not use this file except in compliance with the License.
885   You may obtain a copy of the License at
886 
887     http://www.apache.org/licenses/LICENSE-2.0
888 
889   Unless required by applicable law or agreed to in writing, software
890   distributed under the License is distributed on an "AS IS" BASIS,
891   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
892   See the License for the specific language governing permissions and
893   limitations under the License.
894 
895 */
896 
897 pragma solidity 0.4.24;
898 
899 
900 contract ISignatureValidator {
901 
902     /// @dev Approves a hash on-chain using any valid signature type.
903     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
904     /// @param signerAddress Address that should have signed the given hash.
905     /// @param signature Proof that the hash has been signed by signer.
906     function preSign(
907         bytes32 hash,
908         address signerAddress,
909         bytes signature
910     )
911         external;
912     
913     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
914     /// @param validatorAddress Address of Validator contract.
915     /// @param approval Approval or disapproval of  Validator contract.
916     function setSignatureValidatorApproval(
917         address validatorAddress,
918         bool approval
919     )
920         external;
921 
922     /// @dev Verifies that a signature is valid.
923     /// @param hash Message hash that is signed.
924     /// @param signerAddress Address of signer.
925     /// @param signature Proof of signing.
926     /// @return Validity of order signature.
927     function isValidSignature(
928         bytes32 hash,
929         address signerAddress,
930         bytes memory signature
931     )
932         public
933         view
934         returns (bool isValid);
935 }
936 
937 // File: contracts/exchange/mixins/MSignatureValidator.sol
938 
939 /*
940 
941   Copyright 2018 ZeroEx Intl.
942 
943   Licensed under the Apache License, Version 2.0 (the "License");
944   you may not use this file except in compliance with the License.
945   You may obtain a copy of the License at
946 
947     http://www.apache.org/licenses/LICENSE-2.0
948 
949   Unless required by applicable law or agreed to in writing, software
950   distributed under the License is distributed on an "AS IS" BASIS,
951   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
952   See the License for the specific language governing permissions and
953   limitations under the License.
954 
955 */
956 
957 pragma solidity 0.4.24;
958 
959 
960 contract MSignatureValidator is
961     ISignatureValidator
962 {
963     event SignatureValidatorApproval(
964         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
965         address indexed validatorAddress,  // Address of signature validator contract.
966         bool approved                      // Approval or disapproval of validator contract.
967     );
968 
969     // Allowed signature types.
970     enum SignatureType {
971         Illegal,         // 0x00, default value
972         Invalid,         // 0x01
973         EIP712,          // 0x02
974         EthSign,         // 0x03
975         Wallet,          // 0x04
976         Validator,       // 0x05
977         PreSigned,       // 0x06
978         NSignatureTypes  // 0x07, number of signature types. Always leave at end.
979     }
980 
981     /// @dev Verifies signature using logic defined by Wallet contract.
982     /// @param hash Any 32 byte hash.
983     /// @param walletAddress Address that should have signed the given hash
984     ///                      and defines its own signature verification method.
985     /// @param signature Proof that the hash has been signed by signer.
986     /// @return True if the address recovered from the provided signature matches the input signer address.
987     function isValidWalletSignature(
988         bytes32 hash,
989         address walletAddress,
990         bytes signature
991     )
992         internal
993         view
994         returns (bool isValid);
995 
996     /// @dev Verifies signature using logic defined by Validator contract.
997     /// @param validatorAddress Address of validator contract.
998     /// @param hash Any 32 byte hash.
999     /// @param signerAddress Address that should have signed the given hash.
1000     /// @param signature Proof that the hash has been signed by signer.
1001     /// @return True if the address recovered from the provided signature matches the input signer address.
1002     function isValidValidatorSignature(
1003         address validatorAddress,
1004         bytes32 hash,
1005         address signerAddress,
1006         bytes signature
1007     )
1008         internal
1009         view
1010         returns (bool isValid);
1011 }
1012 
1013 // File: contracts/exchange/interfaces/ITransactions.sol
1014 
1015 /*
1016 
1017   Copyright 2018 ZeroEx Intl.
1018 
1019   Licensed under the Apache License, Version 2.0 (the "License");
1020   you may not use this file except in compliance with the License.
1021   You may obtain a copy of the License at
1022 
1023     http://www.apache.org/licenses/LICENSE-2.0
1024 
1025   Unless required by applicable law or agreed to in writing, software
1026   distributed under the License is distributed on an "AS IS" BASIS,
1027   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1028   See the License for the specific language governing permissions and
1029   limitations under the License.
1030 
1031 */
1032 
1033 pragma solidity 0.4.24;
1034 
1035 
1036 contract ITransactions {
1037 
1038     /// @dev Executes an exchange method call in the context of signer.
1039     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1040     /// @param signerAddress Address of transaction signer.
1041     /// @param data AbiV2 encoded calldata.
1042     /// @param signature Proof of signer transaction by signer.
1043     function executeTransaction(
1044         uint256 salt,
1045         address signerAddress,
1046         bytes data,
1047         bytes signature
1048     )
1049         external;
1050 }
1051 
1052 // File: contracts/exchange/mixins/MTransactions.sol
1053 
1054 /*
1055 
1056   Copyright 2018 ZeroEx Intl.
1057 
1058   Licensed under the Apache License, Version 2.0 (the "License");
1059   you may not use this file except in compliance with the License.
1060   You may obtain a copy of the License at
1061 
1062     http://www.apache.org/licenses/LICENSE-2.0
1063 
1064   Unless required by applicable law or agreed to in writing, software
1065   distributed under the License is distributed on an "AS IS" BASIS,
1066   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1067   See the License for the specific language governing permissions and
1068   limitations under the License.
1069 
1070 */
1071 
1072 pragma solidity 0.4.24;
1073 
1074 
1075 contract MTransactions is
1076     ITransactions
1077 {
1078     // Hash for the EIP712 ZeroEx Transaction Schema
1079     bytes32 constant internal EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = keccak256(abi.encodePacked(
1080         "ZeroExTransaction(",
1081         "uint256 salt,",
1082         "address signerAddress,",
1083         "bytes data",
1084         ")"
1085     ));
1086 
1087     /// @dev Calculates EIP712 hash of the Transaction.
1088     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1089     /// @param signerAddress Address of transaction signer.
1090     /// @param data AbiV2 encoded calldata.
1091     /// @return EIP712 hash of the Transaction.
1092     function hashZeroExTransaction(
1093         uint256 salt,
1094         address signerAddress,
1095         bytes memory data
1096     )
1097         internal
1098         pure
1099         returns (bytes32 result);
1100 
1101     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
1102     ///      If calling a fill function, this address will represent the taker.
1103     ///      If calling a cancel function, this address will represent the maker.
1104     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
1105     ///         `msg.sender` if entry point is any other function.
1106     function getCurrentContextAddress()
1107         internal
1108         view
1109         returns (address);
1110 }
1111 
1112 // File: contracts/exchange/interfaces/IAssetProxyDispatcher.sol
1113 
1114 /*
1115 
1116   Copyright 2018 ZeroEx Intl.
1117 
1118   Licensed under the Apache License, Version 2.0 (the "License");
1119   you may not use this file except in compliance with the License.
1120   You may obtain a copy of the License at
1121 
1122     http://www.apache.org/licenses/LICENSE-2.0
1123 
1124   Unless required by applicable law or agreed to in writing, software
1125   distributed under the License is distributed on an "AS IS" BASIS,
1126   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1127   See the License for the specific language governing permissions and
1128   limitations under the License.
1129 
1130 */
1131 
1132 pragma solidity 0.4.24;
1133 
1134 
1135 contract IAssetProxyDispatcher {
1136 
1137     /// @dev Registers an asset proxy to its asset proxy id.
1138     ///      Once an asset proxy is registered, it cannot be unregistered.
1139     /// @param assetProxy Address of new asset proxy to register.
1140     function registerAssetProxy(address assetProxy)
1141         external;
1142 
1143     /// @dev Gets an asset proxy.
1144     /// @param assetProxyId Id of the asset proxy.
1145     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1146     function getAssetProxy(bytes4 assetProxyId)
1147         external
1148         view
1149         returns (address);
1150 }
1151 
1152 // File: contracts/exchange/mixins/MAssetProxyDispatcher.sol
1153 
1154 /*
1155 
1156   Copyright 2018 ZeroEx Intl.
1157 
1158   Licensed under the Apache License, Version 2.0 (the "License");
1159   you may not use this file except in compliance with the License.
1160   You may obtain a copy of the License at
1161 
1162     http://www.apache.org/licenses/LICENSE-2.0
1163 
1164   Unless required by applicable law or agreed to in writing, software
1165   distributed under the License is distributed on an "AS IS" BASIS,
1166   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1167   See the License for the specific language governing permissions and
1168   limitations under the License.
1169 
1170 */
1171 
1172 pragma solidity 0.4.24;
1173 
1174 
1175 contract MAssetProxyDispatcher is
1176     IAssetProxyDispatcher
1177 {
1178     // Logs registration of new asset proxy
1179     event AssetProxyRegistered(
1180         bytes4 id,              // Id of new registered AssetProxy.
1181         address assetProxy      // Address of new registered AssetProxy.
1182     );
1183 
1184     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
1185     /// @param assetData Byte array encoded for the asset.
1186     /// @param from Address to transfer token from.
1187     /// @param to Address to transfer token to.
1188     /// @param amount Amount of token to transfer.
1189     function dispatchTransferFrom(
1190         bytes memory assetData,
1191         address from,
1192         address to,
1193         uint256 amount
1194     )
1195         internal;
1196 }
1197 
1198 // File: @0x/contracts-utils/contracts/src/ReentrancyGuard.sol
1199 
1200 /*
1201 
1202   Copyright 2018 ZeroEx Intl.
1203 
1204   Licensed under the Apache License, Version 2.0 (the "License");
1205   you may not use this file except in compliance with the License.
1206   You may obtain a copy of the License at
1207 
1208     http://www.apache.org/licenses/LICENSE-2.0
1209 
1210   Unless required by applicable law or agreed to in writing, software
1211   distributed under the License is distributed on an "AS IS" BASIS,
1212   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1213   See the License for the specific language governing permissions and
1214   limitations under the License.
1215 
1216 */
1217 
1218 pragma solidity ^0.4.24;
1219 
1220 
1221 contract ReentrancyGuard {
1222 
1223     // Locked state of mutex
1224     bool private locked = false;
1225 
1226     /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
1227     ///      before function execution and unlocked after.
1228     modifier nonReentrant() {
1229         // Ensure mutex is unlocked
1230         require(
1231             !locked,
1232             "REENTRANCY_ILLEGAL"
1233         );
1234 
1235         // Lock mutex before function call
1236         locked = true;
1237 
1238         // Perform function call
1239         _;
1240 
1241         // Unlock mutex after function call
1242         locked = false;
1243     }
1244 }
1245 
1246 // File: contracts/exchange/libs/Operational.sol
1247 
1248 /*
1249 
1250   Copyright 2019 Metaps Alpha Inc.
1251 
1252   Licensed under the Apache License, Version 2.0 (the "License");
1253   you may not use this file except in compliance with the License.
1254   You may obtain a copy of the License at
1255 
1256     http://www.apache.org/licenses/LICENSE-2.0
1257 
1258   Unless required by applicable law or agreed to in writing, software
1259   distributed under the License is distributed on an "AS IS" BASIS,
1260   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1261   See the License for the specific language governing permissions and
1262   limitations under the License.
1263 
1264 */
1265 
1266 pragma solidity 0.4.24;
1267 
1268 
1269 contract Operational
1270 {
1271     address public owner;
1272     address[] public withdrawOperators; // It is mainly responsible for the withdraw of deposit on cancelling.
1273     mapping (address => bool) public isWithdrawOperator;
1274 
1275     event OwnershipTransferred(
1276         address indexed previousOwner,
1277         address indexed newOwner
1278     );
1279 
1280     event WithdrawOperatorAdded(
1281         address indexed target,
1282         address indexed caller
1283     );
1284 
1285     event WithdrawOperatorRemoved(
1286         address indexed target,
1287         address indexed caller
1288     );
1289 
1290     constructor ()
1291         public
1292     {
1293         owner = msg.sender;
1294     }
1295 
1296     modifier onlyOwner() {
1297         require(
1298             msg.sender == owner,
1299             "ONLY_CONTRACT_OWNER"
1300         );
1301         _;
1302     }
1303 
1304     modifier withdrawable(address toAddress) {
1305         require(
1306             isWithdrawOperator[msg.sender] || toAddress == msg.sender,
1307             "SENDER_IS_NOT_WITHDRAWABLE"
1308         );
1309         _;
1310     }
1311 
1312     function transferOwnership(address newOwner)
1313         public
1314         onlyOwner
1315     {
1316         require(
1317             newOwner != address(0),
1318             "INVALID_OWNER"
1319         );
1320         emit OwnershipTransferred(owner, newOwner);
1321         owner = newOwner;
1322     }
1323 
1324     function addWithdrawOperator(address target)
1325         external
1326         onlyOwner
1327     {
1328         require(
1329             !isWithdrawOperator[target],
1330             "TARGET_IS_ALREADY_WITHDRAW_OPERATOR"
1331         );
1332 
1333         isWithdrawOperator[target] = true;
1334         withdrawOperators.push(target);
1335         emit WithdrawOperatorAdded(target, msg.sender);
1336     }
1337 
1338     function removeWithdrawOperator(address target)
1339         external
1340         onlyOwner
1341     {
1342         require(
1343             isWithdrawOperator[target],
1344             "TARGET_IS_NOT_WITHDRAW_OPERATOR"
1345         );
1346 
1347         delete isWithdrawOperator[target];
1348         for (uint256 i = 0; i < withdrawOperators.length; i++) {
1349             if (withdrawOperators[i] == target) {
1350                 withdrawOperators[i] = withdrawOperators[withdrawOperators.length - 1];
1351                 withdrawOperators.length -= 1;
1352                 break;
1353             }
1354         }
1355         emit WithdrawOperatorRemoved(target, msg.sender);
1356     }
1357 }
1358 
1359 // File: contracts/exchange/libs/DepositManager.sol
1360 
1361 /*
1362 
1363   Copyright 2019 Metaps Alpha Inc.
1364 
1365   Licensed under the Apache License, Version 2.0 (the "License");
1366   you may not use this file except in compliance with the License.
1367   You may obtain a copy of the License at
1368 
1369     http://www.apache.org/licenses/LICENSE-2.0
1370 
1371   Unless required by applicable law or agreed to in writing, software
1372   distributed under the License is distributed on an "AS IS" BASIS,
1373   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1374   See the License for the specific language governing permissions and
1375   limitations under the License.
1376 
1377 */
1378 
1379 pragma solidity 0.4.24;
1380 
1381 
1382 contract DepositManager is
1383     Operational,
1384     ReentrancyGuard,
1385     SafeMath
1386 {
1387     // Mapping from user to deposit amount
1388     mapping (address => uint256) public depositAmount;
1389     // Mapping from order and user to deposit amount for withdraw
1390     mapping (bytes32 => mapping (address => uint256)) public orderToDepositAmount;
1391 
1392     // Deposit event is emitted whenever `deposit` is executed succesfully.
1393     event Deposit(
1394         bytes32 indexed orderHash,
1395         address indexed senderAddress,
1396         uint256 amount
1397     );
1398 
1399     // DepositChanged event is emitted whenever `updateOrder` is executed succesfully.
1400     event DepositChanged(
1401         bytes32 indexed newOrderHash,
1402         uint256 newAmount,
1403         bytes32 indexed oldOrderHash,
1404         uint256 oldAmount,
1405         address indexed senderAddress
1406     );
1407 
1408     // Withdraw event is emitted whenever `withdraw` (it may be called in `cancelOrder`) is executed succesfully.
1409     event Withdraw(
1410         bytes32 indexed orderHash,
1411         address indexed toAddress,
1412         uint256 amount
1413     );
1414 
1415     /// @dev Deposit for offer.
1416     /// @param orderHash orderHash of the order.
1417     function deposit(bytes32 orderHash)
1418         public
1419         payable
1420         nonReentrant
1421     {
1422         depositInternal(orderHash, msg.sender, msg.value);
1423     }
1424 
1425     /// @dev Withdraw deposit.
1426     /// @param orderHash orderHash of the order.
1427     /// @param toAddress Address to be refund.
1428     function withdraw(bytes32 orderHash, address toAddress)
1429         public
1430         nonReentrant
1431         withdrawable(toAddress)
1432     {
1433         withdrawInternal(orderHash, toAddress);
1434     }
1435 
1436     function depositInternal(bytes32 orderHash, address sender, uint256 amount)
1437         internal
1438     {
1439         depositAmount[sender] = safeAdd(depositAmount[sender], amount);
1440         orderToDepositAmount[orderHash][sender] = safeAdd(orderToDepositAmount[orderHash][sender], amount);
1441         emit Deposit(orderHash, sender, amount);
1442     }
1443 
1444     function withdrawInternal(bytes32 orderHash, address toAddress)
1445         internal
1446     {
1447         if (orderToDepositAmount[orderHash][toAddress] > 0) {
1448             uint256 amount = orderToDepositAmount[orderHash][toAddress];
1449             depositAmount[toAddress] = safeSub(depositAmount[toAddress], amount);
1450             delete orderToDepositAmount[orderHash][toAddress];
1451             toAddress.transfer(amount);
1452             emit Withdraw(orderHash, toAddress, amount);
1453         }
1454     }
1455 
1456     function changeDeposit(
1457         bytes32 newOrderHash,
1458         uint256 newOfferAmount,
1459         bytes32 oldOrderHash,
1460         uint256 oldOfferAmount,
1461         address sender
1462     )
1463         internal
1464     {
1465         if (msg.value > 0) {
1466             depositAmount[sender] = safeAdd(depositAmount[sender], msg.value);
1467             orderToDepositAmount[newOrderHash][sender] = safeAdd(orderToDepositAmount[newOrderHash][sender], msg.value);
1468         }
1469         uint256 oldOrderToDepositAmount = orderToDepositAmount[oldOrderHash][sender];
1470         moveDeposit(oldOrderHash, newOrderHash, sender);
1471         if (oldOrderToDepositAmount > newOfferAmount) {
1472             uint256 refundAmount = safeSub(orderToDepositAmount[newOrderHash][sender], newOfferAmount);
1473             orderToDepositAmount[newOrderHash][sender] = safeSub(orderToDepositAmount[newOrderHash][sender], refundAmount);
1474             depositAmount[sender] = safeSub(depositAmount[sender], refundAmount);
1475             sender.transfer(refundAmount);
1476         }
1477         emit DepositChanged(newOrderHash, newOfferAmount, oldOrderHash, oldOfferAmount, sender);
1478     }
1479 
1480     function moveDeposit(
1481         bytes32 fromOrderHash,
1482         bytes32 toOrderHash,
1483         address sender
1484     )
1485         internal
1486     {
1487         uint256 amount = orderToDepositAmount[fromOrderHash][sender];
1488         delete orderToDepositAmount[fromOrderHash][sender];
1489         orderToDepositAmount[toOrderHash][sender] = safeAdd(orderToDepositAmount[toOrderHash][sender], amount);
1490     }
1491 
1492     function deductOrderToDepositAmount(
1493         bytes32 orderHash,
1494         address target,
1495         uint256 amount
1496     )
1497         internal
1498     {
1499         orderToDepositAmount[orderHash][target] = safeSub(orderToDepositAmount[orderHash][target], amount);
1500     }
1501 }
1502 
1503 // File: contracts/exchange/libs/LibConstants.sol
1504 
1505 /*
1506 
1507   Copyright 2019 Metaps Alpha Inc.
1508 
1509   Licensed under the Apache License, Version 2.0 (the "License");
1510   you may not use this file except in compliance with the License.
1511   You may obtain a copy of the License at
1512 
1513     http://www.apache.org/licenses/LICENSE-2.0
1514 
1515   Unless required by applicable law or agreed to in writing, software
1516   distributed under the License is distributed on an "AS IS" BASIS,
1517   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1518   See the License for the specific language governing permissions and
1519   limitations under the License.
1520 
1521 */
1522 
1523 pragma solidity 0.4.24;
1524 
1525 
1526 // solhint-disable max-line-length
1527 contract LibConstants {
1528     // miime - The special asset data for ETH
1529     // ETH_ASSET_DATA = bytes4(keccak256("ERC20Token(address)")); + 0 padding
1530     //                = 0xf47261b00000000000000000000000000000000000000000000000000000000000000000
1531     bytes constant public ETH_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
1532     bytes32 constant public KECCAK256_ETH_ASSET_DATA = keccak256(ETH_ASSET_DATA);
1533     uint256 constant public TRANSFER_GAS_LIMIT = 300000; // Gas limit for ETH sending
1534 }
1535 // solhint-enable max-line-length
1536 
1537 // File: contracts/exchange/MixinExchangeCore.sol
1538 
1539 /*
1540 
1541   Modified by Metaps Alpha Inc.
1542 
1543   Copyright 2018 ZeroEx Intl.
1544 
1545   Licensed under the Apache License, Version 2.0 (the "License");
1546   you may not use this file except in compliance with the License.
1547   You may obtain a copy of the License at
1548 
1549     http://www.apache.org/licenses/LICENSE-2.0
1550 
1551   Unless required by applicable law or agreed to in writing, software
1552   distributed under the License is distributed on an "AS IS" BASIS,
1553   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1554   See the License for the specific language governing permissions and
1555   limitations under the License.
1556 
1557 */
1558 
1559 pragma solidity 0.4.24;
1560 
1561 
1562 contract MixinExchangeCore is
1563     DepositManager,
1564     LibConstants,
1565     LibMath,
1566     LibOrder,
1567     LibFillResults,
1568     MAssetProxyDispatcher,
1569     MExchangeCore,
1570     MSignatureValidator,
1571     MTransactions
1572 {
1573     // Mapping of orderHash => amount of takerAsset already bought by maker
1574     mapping (bytes32 => uint256) public filled;
1575 
1576     // Mapping of orderHash => cancelled
1577     mapping (bytes32 => bool) public cancelled;
1578 
1579     // Mapping of makerAddress => senderAddress => lowest salt an order can have in order to be fillable
1580     // Orders with specified senderAddress and with a salt less than their epoch are considered cancelled
1581     mapping (address => mapping (address => uint256)) public orderEpoch;
1582 
1583     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1584     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1585     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1586     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1587         external
1588         nonReentrant
1589     {
1590         address makerAddress = getCurrentContextAddress();
1591         // If this function is called via `executeTransaction`, we only update the orderEpoch for the makerAddress/msg.sender combination.
1592         // This allows external filter contracts to add rules to how orders are cancelled via this function.
1593         address senderAddress = makerAddress == msg.sender ? address(0) : msg.sender;
1594 
1595         // orderEpoch is initialized to 0, so to cancelUpTo we need salt + 1
1596         uint256 newOrderEpoch = targetOrderEpoch + 1;
1597         uint256 oldOrderEpoch = orderEpoch[makerAddress][senderAddress];
1598 
1599         // Ensure orderEpoch is monotonically increasing
1600         require(
1601             newOrderEpoch > oldOrderEpoch,
1602             "INVALID_NEW_ORDER_EPOCH"
1603         );
1604 
1605         // Update orderEpoch
1606         orderEpoch[makerAddress][senderAddress] = newOrderEpoch;
1607         emit CancelUpTo(
1608             makerAddress,
1609             senderAddress,
1610             newOrderEpoch
1611         );
1612     }
1613 
1614     /// @dev Fills the input order.
1615     /// @param order Order struct containing order specifications.
1616     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1617     /// @param signature Proof that order has been created by maker.
1618     /// @return Amounts filled and fees paid by maker and taker.
1619     function fillOrder(
1620         Order memory order,
1621         uint256 takerAssetFillAmount,
1622         bytes memory signature
1623     )
1624         public
1625         payable
1626         nonReentrant
1627         returns (FillResults memory fillResults)
1628     {
1629         fillResults = fillOrderInternal(
1630             order,
1631             takerAssetFillAmount,
1632             signature
1633         );
1634         return fillResults;
1635     }
1636 
1637     /// @dev After calling, the order can not be filled anymore.
1638     ///      Throws if order is invalid or sender does not have permission to cancel.
1639     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
1640     function cancelOrder(Order memory order)
1641         public
1642         nonReentrant
1643     {
1644         OrderInfo memory orderInfo = cancelOrderInternal(order);
1645         withdrawInternal(orderInfo.orderHash, msg.sender);
1646     }
1647 
1648     /// @dev Gets information about an order: status, hash, and amount filled.
1649     /// @param order Order to gather information on.
1650     /// @return OrderInfo Information about the order and its state.
1651     ///         See LibOrder.OrderInfo for a complete description.
1652     function getOrderInfo(Order memory order)
1653         public
1654         view
1655         returns (OrderInfo memory orderInfo)
1656     {
1657         // Compute the order hash
1658         orderInfo.orderHash = getOrderHash(order);
1659 
1660         // Fetch filled amount
1661         orderInfo.orderTakerAssetFilledAmount = filled[orderInfo.orderHash];
1662 
1663         // If order.makerAssetAmount is zero, we also reject the order.
1664         // While the Exchange contract handles them correctly, they create
1665         // edge cases in the supporting infrastructure because they have
1666         // an 'infinite' price when computed by a simple division.
1667         if (order.makerAssetAmount == 0) {
1668             orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_ASSET_AMOUNT);
1669             return orderInfo;
1670         }
1671 
1672         // If order.takerAssetAmount is zero, then the order will always
1673         // be considered filled because 0 == takerAssetAmount == orderTakerAssetFilledAmount
1674         // Instead of distinguishing between unfilled and filled zero taker
1675         // amount orders, we choose not to support them.
1676         if (order.takerAssetAmount == 0) {
1677             orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_ASSET_AMOUNT);
1678             return orderInfo;
1679         }
1680 
1681         // Validate order availability
1682         if (orderInfo.orderTakerAssetFilledAmount >= order.takerAssetAmount) {
1683             orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
1684             return orderInfo;
1685         }
1686 
1687         // Validate order expiration
1688         // solhint-disable-next-line not-rely-on-time
1689         if (block.timestamp >= order.expirationTimeSeconds) {
1690             orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
1691             return orderInfo;
1692         }
1693 
1694         // Check if order has been cancelled
1695         if (cancelled[orderInfo.orderHash]) {
1696             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
1697             return orderInfo;
1698         }
1699         if (orderEpoch[order.makerAddress][order.senderAddress] > order.salt) {
1700             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
1701             return orderInfo;
1702         }
1703 
1704         // All other statuses are ruled out: order is Fillable
1705         orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
1706         return orderInfo;
1707     }
1708 
1709     /// @dev miime - Cancel order and then update deposit for new order.
1710     /// @param newOrderHash New orderHash for deposit.
1711     /// @param newOfferAmount New offer amount.
1712     /// @param orderToBeCanceled Order to be canceled.
1713     function updateOrder(
1714         bytes32 newOrderHash,
1715         uint256 newOfferAmount,
1716         Order memory orderToBeCanceled
1717     )
1718         public
1719         payable
1720         nonReentrant
1721     {
1722         OrderInfo memory orderInfo = cancelOrderInternal(orderToBeCanceled);
1723         uint256 oldOfferAmount = safeAdd(orderToBeCanceled.makerAssetAmount, orderToBeCanceled.makerFee);
1724         changeDeposit(newOrderHash, newOfferAmount, orderInfo.orderHash, oldOfferAmount, msg.sender);
1725     }
1726 
1727     /// @dev Fills the input order.
1728     /// @param order Order struct containing order specifications.
1729     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1730     /// @param signature Proof that order has been created by maker.
1731     /// @return Amounts filled and fees paid by maker and taker.
1732     function fillOrderInternal(
1733         Order memory order,
1734         uint256 takerAssetFillAmount,
1735         bytes memory signature
1736     )
1737         internal
1738         returns (FillResults memory fillResults)
1739     {
1740         // Fetch order info
1741         OrderInfo memory orderInfo = getOrderInfo(order);
1742 
1743         // Fetch taker address
1744         address takerAddress = getCurrentContextAddress();
1745 
1746         // miime: Deposit the sending ETH on buying
1747         // Hash calculation is expensive, so it is implemented here.
1748         if (msg.value > 0) {
1749             depositInternal(orderInfo.orderHash, takerAddress, msg.value);
1750         }
1751 
1752         // Assert that the order is fillable by taker
1753         assertFillableOrder(
1754             order,
1755             orderInfo,
1756             takerAddress,
1757             signature
1758         );
1759 
1760         // Get amount of takerAsset to fill
1761         uint256 remainingTakerAssetAmount = safeSub(order.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount);
1762         uint256 takerAssetFilledAmount = min256(takerAssetFillAmount, remainingTakerAssetAmount);
1763 
1764         // Compute proportional fill amounts
1765         fillResults = calculateFillResults(order, takerAssetFilledAmount);
1766 
1767         // Validate context
1768         assertValidFill(
1769             order,
1770             orderInfo,
1771             takerAssetFillAmount,
1772             takerAssetFilledAmount,
1773             fillResults.makerAssetFilledAmount
1774         );
1775 
1776         // Update exchange internal state
1777         updateFilledState(
1778             order,
1779             takerAddress,
1780             orderInfo.orderHash,
1781             orderInfo.orderTakerAssetFilledAmount,
1782             fillResults
1783         );
1784 
1785         // Settle order
1786         settleOrder(
1787             order,
1788             takerAddress,
1789             fillResults
1790         );
1791 
1792         // miime: Deduct deposit of this order
1793         if (keccak256(order.makerAssetData) == KECCAK256_ETH_ASSET_DATA) {
1794             deductOrderToDepositAmount(
1795                 orderInfo.orderHash,
1796                 order.makerAddress,
1797                 safeAdd(fillResults.makerAssetFilledAmount, fillResults.makerFeePaid)
1798             );
1799         }
1800         if (keccak256(order.takerAssetData) == KECCAK256_ETH_ASSET_DATA) {
1801             deductOrderToDepositAmount(
1802                 orderInfo.orderHash,
1803                 takerAddress,
1804                 safeAdd(fillResults.takerAssetFilledAmount, fillResults.takerFeePaid)
1805             );
1806         }
1807 
1808         return fillResults;
1809     }
1810 
1811     /// @dev After calling, the order can not be filled anymore.
1812     ///      Throws if order is invalid or sender does not have permission to cancel.
1813     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
1814     /// @return orderInfo
1815     function cancelOrderInternal(Order memory order)
1816         internal
1817         returns (OrderInfo)
1818     {
1819         // Fetch current order status
1820         OrderInfo memory orderInfo = getOrderInfo(order);
1821 
1822         // Validate context
1823         assertValidCancel(order, orderInfo);
1824 
1825         // Perform cancel
1826         updateCancelledState(order, orderInfo.orderHash);
1827 
1828         return orderInfo;
1829     }
1830 
1831     /// @dev Updates state with results of a fill order.
1832     /// @param order that was filled.
1833     /// @param takerAddress Address of taker who filled the order.
1834     /// @param orderTakerAssetFilledAmount Amount of order already filled.
1835     function updateFilledState(
1836         Order memory order,
1837         address takerAddress,
1838         bytes32 orderHash,
1839         uint256 orderTakerAssetFilledAmount,
1840         FillResults memory fillResults
1841     )
1842         internal
1843     {
1844         // Update state
1845         filled[orderHash] = safeAdd(orderTakerAssetFilledAmount, fillResults.takerAssetFilledAmount);
1846 
1847         // Log order
1848         emit Fill(
1849             order.makerAddress,
1850             order.feeRecipientAddress,
1851             takerAddress,
1852             msg.sender,
1853             fillResults.makerAssetFilledAmount,
1854             fillResults.takerAssetFilledAmount,
1855             fillResults.makerFeePaid,
1856             fillResults.takerFeePaid,
1857             orderHash,
1858             order.makerAssetData,
1859             order.takerAssetData
1860         );
1861     }
1862 
1863     /// @dev Updates state with results of cancelling an order.
1864     ///      State is only updated if the order is currently fillable.
1865     ///      Otherwise, updating state would have no effect.
1866     /// @param order that was cancelled.
1867     /// @param orderHash Hash of order that was cancelled.
1868     function updateCancelledState(
1869         Order memory order,
1870         bytes32 orderHash
1871     )
1872         internal
1873     {
1874         // Perform cancel
1875         cancelled[orderHash] = true;
1876 
1877         // Log cancel
1878         emit Cancel(
1879             order.makerAddress,
1880             order.feeRecipientAddress,
1881             msg.sender,
1882             orderHash,
1883             order.makerAssetData,
1884             order.takerAssetData
1885         );
1886     }
1887 
1888     /// @dev Validates context for fillOrder. Succeeds or throws.
1889     /// @param order to be filled.
1890     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1891     /// @param takerAddress Address of order taker.
1892     /// @param signature Proof that the orders was created by its maker.
1893     function assertFillableOrder(
1894         Order memory order,
1895         OrderInfo memory orderInfo,
1896         address takerAddress,
1897         bytes memory signature
1898     )
1899         internal
1900         view
1901     {
1902         // An order can only be filled if its status is FILLABLE.
1903         require(
1904             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
1905             "ORDER_UNFILLABLE"
1906         );
1907 
1908         // Validate sender is allowed to fill this order
1909         if (order.senderAddress != address(0)) {
1910             require(
1911                 order.senderAddress == msg.sender,
1912                 "INVALID_SENDER"
1913             );
1914         }
1915 
1916         // Validate taker is allowed to fill this order
1917         if (order.takerAddress != address(0)) {
1918             require(
1919                 order.takerAddress == takerAddress,
1920                 "INVALID_TAKER"
1921             );
1922         }
1923 
1924         // Validate Maker signature (check only if first time seen)
1925         if (orderInfo.orderTakerAssetFilledAmount == 0) {
1926             require(
1927                 isValidSignature(
1928                     orderInfo.orderHash,
1929                     order.makerAddress,
1930                     signature
1931                 ),
1932                 "INVALID_ORDER_SIGNATURE"
1933             );
1934         }
1935     }
1936 
1937     /// @dev Validates context for fillOrder. Succeeds or throws.
1938     /// @param order to be filled.
1939     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1940     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
1941     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
1942     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
1943     function assertValidFill(
1944         Order memory order,
1945         OrderInfo memory orderInfo,
1946         uint256 takerAssetFillAmount,  // TODO: use FillResults
1947         uint256 takerAssetFilledAmount,
1948         uint256 makerAssetFilledAmount
1949     )
1950         internal
1951         view
1952     {
1953         // Revert if fill amount is invalid
1954         // TODO: reconsider necessity for v2.1
1955         require(
1956             takerAssetFillAmount != 0,
1957             "INVALID_TAKER_AMOUNT"
1958         );
1959 
1960         // Make sure taker does not pay more than desired amount
1961         // NOTE: This assertion should never fail, it is here
1962         //       as an extra defence against potential bugs.
1963         require(
1964             takerAssetFilledAmount <= takerAssetFillAmount,
1965             "TAKER_OVERPAY"
1966         );
1967 
1968         // Make sure order is not overfilled
1969         // NOTE: This assertion should never fail, it is here
1970         //       as an extra defence against potential bugs.
1971         require(
1972             safeAdd(orderInfo.orderTakerAssetFilledAmount, takerAssetFilledAmount) <= order.takerAssetAmount,
1973             "ORDER_OVERFILL"
1974         );
1975 
1976         // Make sure order is filled at acceptable price.
1977         // The order has an implied price from the makers perspective:
1978         //    order price = order.makerAssetAmount / order.takerAssetAmount
1979         // i.e. the number of makerAsset maker is paying per takerAsset. The
1980         // maker is guaranteed to get this price or a better (lower) one. The
1981         // actual price maker is getting in this fill is:
1982         //    fill price = makerAssetFilledAmount / takerAssetFilledAmount
1983         // We need `fill price <= order price` for the fill to be fair to maker.
1984         // This amounts to:
1985         //     makerAssetFilledAmount        order.makerAssetAmount
1986         //    ------------------------  <=  -----------------------
1987         //     takerAssetFilledAmount        order.takerAssetAmount
1988         // or, equivalently:
1989         //     makerAssetFilledAmount * order.takerAssetAmount <=
1990         //     order.makerAssetAmount * takerAssetFilledAmount
1991         // NOTE: This assertion should never fail, it is here
1992         //       as an extra defence against potential bugs.
1993         require(
1994             safeMul(makerAssetFilledAmount, order.takerAssetAmount)
1995             <=
1996             safeMul(order.makerAssetAmount, takerAssetFilledAmount),
1997             "INVALID_FILL_PRICE"
1998         );
1999     }
2000 
2001     /// @dev Validates context for cancelOrder. Succeeds or throws.
2002     /// @param order to be cancelled.
2003     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2004     function assertValidCancel(
2005         Order memory order,
2006         OrderInfo memory orderInfo
2007     )
2008         internal
2009         view
2010     {
2011         // Ensure order is valid
2012         // An order can only be cancelled if its status is FILLABLE.
2013         require(
2014             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2015             "ORDER_UNFILLABLE"
2016         );
2017 
2018         // Validate sender is allowed to cancel this order
2019         if (order.senderAddress != address(0)) {
2020             require(
2021                 order.senderAddress == msg.sender,
2022                 "INVALID_SENDER"
2023             );
2024         }
2025 
2026         // Validate transaction signed by maker
2027         address makerAddress = getCurrentContextAddress();
2028         require(
2029             order.makerAddress == makerAddress,
2030             "INVALID_MAKER"
2031         );
2032     }
2033 
2034     /// @dev Calculates amounts filled and fees paid by maker and taker.
2035     /// @param order to be filled.
2036     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2037     /// @return fillResults Amounts filled and fees paid by maker and taker.
2038     function calculateFillResults(
2039         Order memory order,
2040         uint256 takerAssetFilledAmount
2041     )
2042         internal
2043         pure
2044         returns (FillResults memory fillResults)
2045     {
2046         // Compute proportional transfer amounts
2047         fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
2048         fillResults.makerAssetFilledAmount = safeGetPartialAmountFloor(
2049             takerAssetFilledAmount,
2050             order.takerAssetAmount,
2051             order.makerAssetAmount
2052         );
2053         fillResults.makerFeePaid = safeGetPartialAmountFloor(
2054             fillResults.makerAssetFilledAmount,
2055             order.makerAssetAmount,
2056             order.makerFee
2057         );
2058         fillResults.takerFeePaid = safeGetPartialAmountFloor(
2059             takerAssetFilledAmount,
2060             order.takerAssetAmount,
2061             order.takerFee
2062         );
2063 
2064         return fillResults;
2065     }
2066 
2067     /// @dev Settles an order by transferring assets between counterparties.
2068     /// @param order Order struct containing order specifications.
2069     /// @param takerAddress Address selling takerAsset and buying makerAsset.
2070     /// @param fillResults Amounts to be filled and fees paid by maker and taker.
2071     function settleOrder(
2072         LibOrder.Order memory order,
2073         address takerAddress,
2074         LibFillResults.FillResults memory fillResults
2075     )
2076         private
2077     {
2078         bytes memory ethAssetData = ETH_ASSET_DATA;
2079         dispatchTransferFrom(
2080             order.makerAssetData,
2081             order.makerAddress,
2082             takerAddress,
2083             fillResults.makerAssetFilledAmount
2084         );
2085         dispatchTransferFrom(
2086             order.takerAssetData,
2087             takerAddress,
2088             order.makerAddress,
2089             fillResults.takerAssetFilledAmount
2090         );
2091         dispatchTransferFrom(
2092             ethAssetData,
2093             order.makerAddress,
2094             order.feeRecipientAddress,
2095             fillResults.makerFeePaid
2096         );
2097         dispatchTransferFrom(
2098             ethAssetData,
2099             takerAddress,
2100             order.feeRecipientAddress,
2101             fillResults.takerFeePaid
2102         );
2103     }
2104 }
2105 
2106 // File: @0x/contracts-utils/contracts/src/LibBytes.sol
2107 
2108 /*
2109 
2110   Copyright 2018 ZeroEx Intl.
2111 
2112   Licensed under the Apache License, Version 2.0 (the "License");
2113   you may not use this file except in compliance with the License.
2114   You may obtain a copy of the License at
2115 
2116     http://www.apache.org/licenses/LICENSE-2.0
2117 
2118   Unless required by applicable law or agreed to in writing, software
2119   distributed under the License is distributed on an "AS IS" BASIS,
2120   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2121   See the License for the specific language governing permissions and
2122   limitations under the License.
2123 
2124 */
2125 
2126 pragma solidity ^0.4.24;
2127 
2128 
2129 library LibBytes {
2130 
2131     using LibBytes for bytes;
2132 
2133     /// @dev Gets the memory address for a byte array.
2134     /// @param input Byte array to lookup.
2135     /// @return memoryAddress Memory address of byte array. This
2136     ///         points to the header of the byte array which contains
2137     ///         the length.
2138     function rawAddress(bytes memory input)
2139         internal
2140         pure
2141         returns (uint256 memoryAddress)
2142     {
2143         assembly {
2144             memoryAddress := input
2145         }
2146         return memoryAddress;
2147     }
2148     
2149     /// @dev Gets the memory address for the contents of a byte array.
2150     /// @param input Byte array to lookup.
2151     /// @return memoryAddress Memory address of the contents of the byte array.
2152     function contentAddress(bytes memory input)
2153         internal
2154         pure
2155         returns (uint256 memoryAddress)
2156     {
2157         assembly {
2158             memoryAddress := add(input, 32)
2159         }
2160         return memoryAddress;
2161     }
2162 
2163     /// @dev Copies `length` bytes from memory location `source` to `dest`.
2164     /// @param dest memory address to copy bytes to.
2165     /// @param source memory address to copy bytes from.
2166     /// @param length number of bytes to copy.
2167     function memCopy(
2168         uint256 dest,
2169         uint256 source,
2170         uint256 length
2171     )
2172         internal
2173         pure
2174     {
2175         if (length < 32) {
2176             // Handle a partial word by reading destination and masking
2177             // off the bits we are interested in.
2178             // This correctly handles overlap, zero lengths and source == dest
2179             assembly {
2180                 let mask := sub(exp(256, sub(32, length)), 1)
2181                 let s := and(mload(source), not(mask))
2182                 let d := and(mload(dest), mask)
2183                 mstore(dest, or(s, d))
2184             }
2185         } else {
2186             // Skip the O(length) loop when source == dest.
2187             if (source == dest) {
2188                 return;
2189             }
2190 
2191             // For large copies we copy whole words at a time. The final
2192             // word is aligned to the end of the range (instead of after the
2193             // previous) to handle partial words. So a copy will look like this:
2194             //
2195             //  ####
2196             //      ####
2197             //          ####
2198             //            ####
2199             //
2200             // We handle overlap in the source and destination range by
2201             // changing the copying direction. This prevents us from
2202             // overwriting parts of source that we still need to copy.
2203             //
2204             // This correctly handles source == dest
2205             //
2206             if (source > dest) {
2207                 assembly {
2208                     // We subtract 32 from `sEnd` and `dEnd` because it
2209                     // is easier to compare with in the loop, and these
2210                     // are also the addresses we need for copying the
2211                     // last bytes.
2212                     length := sub(length, 32)
2213                     let sEnd := add(source, length)
2214                     let dEnd := add(dest, length)
2215 
2216                     // Remember the last 32 bytes of source
2217                     // This needs to be done here and not after the loop
2218                     // because we may have overwritten the last bytes in
2219                     // source already due to overlap.
2220                     let last := mload(sEnd)
2221 
2222                     // Copy whole words front to back
2223                     // Note: the first check is always true,
2224                     // this could have been a do-while loop.
2225                     // solhint-disable-next-line no-empty-blocks
2226                     for {} lt(source, sEnd) {} {
2227                         mstore(dest, mload(source))
2228                         source := add(source, 32)
2229                         dest := add(dest, 32)
2230                     }
2231                     
2232                     // Write the last 32 bytes
2233                     mstore(dEnd, last)
2234                 }
2235             } else {
2236                 assembly {
2237                     // We subtract 32 from `sEnd` and `dEnd` because those
2238                     // are the starting points when copying a word at the end.
2239                     length := sub(length, 32)
2240                     let sEnd := add(source, length)
2241                     let dEnd := add(dest, length)
2242 
2243                     // Remember the first 32 bytes of source
2244                     // This needs to be done here and not after the loop
2245                     // because we may have overwritten the first bytes in
2246                     // source already due to overlap.
2247                     let first := mload(source)
2248 
2249                     // Copy whole words back to front
2250                     // We use a signed comparisson here to allow dEnd to become
2251                     // negative (happens when source and dest < 32). Valid
2252                     // addresses in local memory will never be larger than
2253                     // 2**255, so they can be safely re-interpreted as signed.
2254                     // Note: the first check is always true,
2255                     // this could have been a do-while loop.
2256                     // solhint-disable-next-line no-empty-blocks
2257                     for {} slt(dest, dEnd) {} {
2258                         mstore(dEnd, mload(sEnd))
2259                         sEnd := sub(sEnd, 32)
2260                         dEnd := sub(dEnd, 32)
2261                     }
2262                     
2263                     // Write the first 32 bytes
2264                     mstore(dest, first)
2265                 }
2266             }
2267         }
2268     }
2269 
2270     /// @dev Returns a slices from a byte array.
2271     /// @param b The byte array to take a slice from.
2272     /// @param from The starting index for the slice (inclusive).
2273     /// @param to The final index for the slice (exclusive).
2274     /// @return result The slice containing bytes at indices [from, to)
2275     function slice(
2276         bytes memory b,
2277         uint256 from,
2278         uint256 to
2279     )
2280         internal
2281         pure
2282         returns (bytes memory result)
2283     {
2284         require(
2285             from <= to,
2286             "FROM_LESS_THAN_TO_REQUIRED"
2287         );
2288         require(
2289             to < b.length,
2290             "TO_LESS_THAN_LENGTH_REQUIRED"
2291         );
2292         
2293         // Create a new bytes structure and copy contents
2294         result = new bytes(to - from);
2295         memCopy(
2296             result.contentAddress(),
2297             b.contentAddress() + from,
2298             result.length
2299         );
2300         return result;
2301     }
2302     
2303     /// @dev Returns a slice from a byte array without preserving the input.
2304     /// @param b The byte array to take a slice from. Will be destroyed in the process.
2305     /// @param from The starting index for the slice (inclusive).
2306     /// @param to The final index for the slice (exclusive).
2307     /// @return result The slice containing bytes at indices [from, to)
2308     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
2309     function sliceDestructive(
2310         bytes memory b,
2311         uint256 from,
2312         uint256 to
2313     )
2314         internal
2315         pure
2316         returns (bytes memory result)
2317     {
2318         require(
2319             from <= to,
2320             "FROM_LESS_THAN_TO_REQUIRED"
2321         );
2322         require(
2323             to < b.length,
2324             "TO_LESS_THAN_LENGTH_REQUIRED"
2325         );
2326         
2327         // Create a new bytes structure around [from, to) in-place.
2328         assembly {
2329             result := add(b, from)
2330             mstore(result, sub(to, from))
2331         }
2332         return result;
2333     }
2334 
2335     /// @dev Pops the last byte off of a byte array by modifying its length.
2336     /// @param b Byte array that will be modified.
2337     /// @return The byte that was popped off.
2338     function popLastByte(bytes memory b)
2339         internal
2340         pure
2341         returns (bytes1 result)
2342     {
2343         require(
2344             b.length > 0,
2345             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
2346         );
2347 
2348         // Store last byte.
2349         result = b[b.length - 1];
2350 
2351         assembly {
2352             // Decrement length of byte array.
2353             let newLen := sub(mload(b), 1)
2354             mstore(b, newLen)
2355         }
2356         return result;
2357     }
2358 
2359     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
2360     /// @param b Byte array that will be modified.
2361     /// @return The 20 byte address that was popped off.
2362     function popLast20Bytes(bytes memory b)
2363         internal
2364         pure
2365         returns (address result)
2366     {
2367         require(
2368             b.length >= 20,
2369             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
2370         );
2371 
2372         // Store last 20 bytes.
2373         result = readAddress(b, b.length - 20);
2374 
2375         assembly {
2376             // Subtract 20 from byte array length.
2377             let newLen := sub(mload(b), 20)
2378             mstore(b, newLen)
2379         }
2380         return result;
2381     }
2382 
2383     /// @dev Tests equality of two byte arrays.
2384     /// @param lhs First byte array to compare.
2385     /// @param rhs Second byte array to compare.
2386     /// @return True if arrays are the same. False otherwise.
2387     function equals(
2388         bytes memory lhs,
2389         bytes memory rhs
2390     )
2391         internal
2392         pure
2393         returns (bool equal)
2394     {
2395         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
2396         // We early exit on unequal lengths, but keccak would also correctly
2397         // handle this.
2398         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
2399     }
2400 
2401     /// @dev Reads an address from a position in a byte array.
2402     /// @param b Byte array containing an address.
2403     /// @param index Index in byte array of address.
2404     /// @return address from byte array.
2405     function readAddress(
2406         bytes memory b,
2407         uint256 index
2408     )
2409         internal
2410         pure
2411         returns (address result)
2412     {
2413         require(
2414             b.length >= index + 20,  // 20 is length of address
2415             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
2416         );
2417 
2418         // Add offset to index:
2419         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
2420         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
2421         index += 20;
2422 
2423         // Read address from array memory
2424         assembly {
2425             // 1. Add index to address of bytes array
2426             // 2. Load 32-byte word from memory
2427             // 3. Apply 20-byte mask to obtain address
2428             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
2429         }
2430         return result;
2431     }
2432 
2433     /// @dev Writes an address into a specific position in a byte array.
2434     /// @param b Byte array to insert address into.
2435     /// @param index Index in byte array of address.
2436     /// @param input Address to put into byte array.
2437     function writeAddress(
2438         bytes memory b,
2439         uint256 index,
2440         address input
2441     )
2442         internal
2443         pure
2444     {
2445         require(
2446             b.length >= index + 20,  // 20 is length of address
2447             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
2448         );
2449 
2450         // Add offset to index:
2451         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
2452         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
2453         index += 20;
2454 
2455         // Store address into array memory
2456         assembly {
2457             // The address occupies 20 bytes and mstore stores 32 bytes.
2458             // First fetch the 32-byte word where we'll be storing the address, then
2459             // apply a mask so we have only the bytes in the word that the address will not occupy.
2460             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
2461 
2462             // 1. Add index to address of bytes array
2463             // 2. Load 32-byte word from memory
2464             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
2465             let neighbors := and(
2466                 mload(add(b, index)),
2467                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
2468             )
2469             
2470             // Make sure input address is clean.
2471             // (Solidity does not guarantee this)
2472             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
2473 
2474             // Store the neighbors and address into memory
2475             mstore(add(b, index), xor(input, neighbors))
2476         }
2477     }
2478 
2479     /// @dev Reads a bytes32 value from a position in a byte array.
2480     /// @param b Byte array containing a bytes32 value.
2481     /// @param index Index in byte array of bytes32 value.
2482     /// @return bytes32 value from byte array.
2483     function readBytes32(
2484         bytes memory b,
2485         uint256 index
2486     )
2487         internal
2488         pure
2489         returns (bytes32 result)
2490     {
2491         require(
2492             b.length >= index + 32,
2493             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
2494         );
2495 
2496         // Arrays are prefixed by a 256 bit length parameter
2497         index += 32;
2498 
2499         // Read the bytes32 from array memory
2500         assembly {
2501             result := mload(add(b, index))
2502         }
2503         return result;
2504     }
2505 
2506     /// @dev Writes a bytes32 into a specific position in a byte array.
2507     /// @param b Byte array to insert <input> into.
2508     /// @param index Index in byte array of <input>.
2509     /// @param input bytes32 to put into byte array.
2510     function writeBytes32(
2511         bytes memory b,
2512         uint256 index,
2513         bytes32 input
2514     )
2515         internal
2516         pure
2517     {
2518         require(
2519             b.length >= index + 32,
2520             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
2521         );
2522 
2523         // Arrays are prefixed by a 256 bit length parameter
2524         index += 32;
2525 
2526         // Read the bytes32 from array memory
2527         assembly {
2528             mstore(add(b, index), input)
2529         }
2530     }
2531 
2532     /// @dev Reads a uint256 value from a position in a byte array.
2533     /// @param b Byte array containing a uint256 value.
2534     /// @param index Index in byte array of uint256 value.
2535     /// @return uint256 value from byte array.
2536     function readUint256(
2537         bytes memory b,
2538         uint256 index
2539     )
2540         internal
2541         pure
2542         returns (uint256 result)
2543     {
2544         result = uint256(readBytes32(b, index));
2545         return result;
2546     }
2547 
2548     /// @dev Writes a uint256 into a specific position in a byte array.
2549     /// @param b Byte array to insert <input> into.
2550     /// @param index Index in byte array of <input>.
2551     /// @param input uint256 to put into byte array.
2552     function writeUint256(
2553         bytes memory b,
2554         uint256 index,
2555         uint256 input
2556     )
2557         internal
2558         pure
2559     {
2560         writeBytes32(b, index, bytes32(input));
2561     }
2562 
2563     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
2564     /// @param b Byte array containing a bytes4 value.
2565     /// @param index Index in byte array of bytes4 value.
2566     /// @return bytes4 value from byte array.
2567     function readBytes4(
2568         bytes memory b,
2569         uint256 index
2570     )
2571         internal
2572         pure
2573         returns (bytes4 result)
2574     {
2575         require(
2576             b.length >= index + 4,
2577             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
2578         );
2579 
2580         // Arrays are prefixed by a 32 byte length field
2581         index += 32;
2582 
2583         // Read the bytes4 from array memory
2584         assembly {
2585             result := mload(add(b, index))
2586             // Solidity does not require us to clean the trailing bytes.
2587             // We do it anyway
2588             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
2589         }
2590         return result;
2591     }
2592 
2593     /// @dev Reads nested bytes from a specific position.
2594     /// @dev NOTE: the returned value overlaps with the input value.
2595     ///            Both should be treated as immutable.
2596     /// @param b Byte array containing nested bytes.
2597     /// @param index Index of nested bytes.
2598     /// @return result Nested bytes.
2599     function readBytesWithLength(
2600         bytes memory b,
2601         uint256 index
2602     )
2603         internal
2604         pure
2605         returns (bytes memory result)
2606     {
2607         // Read length of nested bytes
2608         uint256 nestedBytesLength = readUint256(b, index);
2609         index += 32;
2610 
2611         // Assert length of <b> is valid, given
2612         // length of nested bytes
2613         require(
2614             b.length >= index + nestedBytesLength,
2615             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
2616         );
2617         
2618         // Return a pointer to the byte array as it exists inside `b`
2619         assembly {
2620             result := add(b, index)
2621         }
2622         return result;
2623     }
2624 
2625     /// @dev Inserts bytes at a specific position in a byte array.
2626     /// @param b Byte array to insert <input> into.
2627     /// @param index Index in byte array of <input>.
2628     /// @param input bytes to insert.
2629     function writeBytesWithLength(
2630         bytes memory b,
2631         uint256 index,
2632         bytes memory input
2633     )
2634         internal
2635         pure
2636     {
2637         // Assert length of <b> is valid, given
2638         // length of input
2639         require(
2640             b.length >= index + 32 + input.length,  // 32 bytes to store length
2641             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
2642         );
2643 
2644         // Copy <input> into <b>
2645         memCopy(
2646             b.contentAddress() + index,
2647             input.rawAddress(), // includes length of <input>
2648             input.length + 32   // +32 bytes to store <input> length
2649         );
2650     }
2651 
2652     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
2653     /// @param dest Byte array that will be overwritten with source bytes.
2654     /// @param source Byte array to copy onto dest bytes.
2655     function deepCopyBytes(
2656         bytes memory dest,
2657         bytes memory source
2658     )
2659         internal
2660         pure
2661     {
2662         uint256 sourceLen = source.length;
2663         // Dest length must be >= source length, or some bytes would not be copied.
2664         require(
2665             dest.length >= sourceLen,
2666             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
2667         );
2668         memCopy(
2669             dest.contentAddress(),
2670             source.contentAddress(),
2671             sourceLen
2672         );
2673     }
2674 }
2675 
2676 // File: contracts/exchange/interfaces/IWallet.sol
2677 
2678 /*
2679 
2680   Copyright 2018 ZeroEx Intl.
2681 
2682   Licensed under the Apache License, Version 2.0 (the "License");
2683   you may not use this file except in compliance with the License.
2684   You may obtain a copy of the License at
2685 
2686     http://www.apache.org/licenses/LICENSE-2.0
2687 
2688   Unless required by applicable law or agreed to in writing, software
2689   distributed under the License is distributed on an "AS IS" BASIS,
2690   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2691   See the License for the specific language governing permissions and
2692   limitations under the License.
2693 
2694 */
2695 
2696 pragma solidity 0.4.24;
2697 
2698 
2699 contract IWallet {
2700 
2701     /// @dev Verifies that a signature is valid.
2702     /// @param hash Message hash that is signed.
2703     /// @param signature Proof of signing.
2704     /// @return Validity of order signature.
2705     function isValidSignature(
2706         bytes32 hash,
2707         bytes signature
2708     )
2709         external
2710         view
2711         returns (bool isValid);
2712 }
2713 
2714 // File: contracts/exchange/interfaces/IValidator.sol
2715 
2716 /*
2717 
2718   Copyright 2018 ZeroEx Intl.
2719 
2720   Licensed under the Apache License, Version 2.0 (the "License");
2721   you may not use this file except in compliance with the License.
2722   You may obtain a copy of the License at
2723 
2724     http://www.apache.org/licenses/LICENSE-2.0
2725 
2726   Unless required by applicable law or agreed to in writing, software
2727   distributed under the License is distributed on an "AS IS" BASIS,
2728   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2729   See the License for the specific language governing permissions and
2730   limitations under the License.
2731 
2732 */
2733 
2734 pragma solidity 0.4.24;
2735 
2736 
2737 contract IValidator {
2738 
2739     /// @dev Verifies that a signature is valid.
2740     /// @param hash Message hash that is signed.
2741     /// @param signerAddress Address that should have signed the given hash.
2742     /// @param signature Proof of signing.
2743     /// @return Validity of order signature.
2744     function isValidSignature(
2745         bytes32 hash,
2746         address signerAddress,
2747         bytes signature
2748     )
2749         external
2750         view
2751         returns (bool isValid);
2752 }
2753 
2754 // File: contracts/exchange/MixinSignatureValidator.sol
2755 
2756 /*
2757 
2758   Copyright 2018 ZeroEx Intl.
2759 
2760   Licensed under the Apache License, Version 2.0 (the "License");
2761   you may not use this file except in compliance with the License.
2762   You may obtain a copy of the License at
2763 
2764     http://www.apache.org/licenses/LICENSE-2.0
2765 
2766   Unless required by applicable law or agreed to in writing, software
2767   distributed under the License is distributed on an "AS IS" BASIS,
2768   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2769   See the License for the specific language governing permissions and
2770   limitations under the License.
2771 
2772 */
2773 
2774 pragma solidity 0.4.24;
2775 
2776 
2777 contract MixinSignatureValidator is
2778     ReentrancyGuard,
2779     MSignatureValidator,
2780     MTransactions
2781 {
2782     using LibBytes for bytes;
2783 
2784     // Mapping of hash => signer => signed
2785     mapping (bytes32 => mapping (address => bool)) public preSigned;
2786 
2787     // Mapping of signer => validator => approved
2788     mapping (address => mapping (address => bool)) public allowedValidators;
2789 
2790     /// @dev Approves a hash on-chain using any valid signature type.
2791     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
2792     /// @param signerAddress Address that should have signed the given hash.
2793     /// @param signature Proof that the hash has been signed by signer.
2794     function preSign(
2795         bytes32 hash,
2796         address signerAddress,
2797         bytes signature
2798     )
2799         external
2800     {
2801         if (signerAddress != msg.sender) {
2802             require(
2803                 isValidSignature(
2804                     hash,
2805                     signerAddress,
2806                     signature
2807                 ),
2808                 "INVALID_SIGNATURE"
2809             );
2810         }
2811         preSigned[hash][signerAddress] = true;
2812     }
2813 
2814     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
2815     /// @param validatorAddress Address of Validator contract.
2816     /// @param approval Approval or disapproval of  Validator contract.
2817     function setSignatureValidatorApproval(
2818         address validatorAddress,
2819         bool approval
2820     )
2821         external
2822         nonReentrant
2823     {
2824         address signerAddress = getCurrentContextAddress();
2825         allowedValidators[signerAddress][validatorAddress] = approval;
2826         emit SignatureValidatorApproval(
2827             signerAddress,
2828             validatorAddress,
2829             approval
2830         );
2831     }
2832 
2833     /// @dev Verifies that a hash has been signed by the given signer.
2834     /// @param hash Any 32 byte hash.
2835     /// @param signerAddress Address that should have signed the given hash.
2836     /// @param signature Proof that the hash has been signed by signer.
2837     /// @return True if the address recovered from the provided signature matches the input signer address.
2838     function isValidSignature(
2839         bytes32 hash,
2840         address signerAddress,
2841         bytes memory signature
2842     )
2843         public
2844         view
2845         returns (bool isValid)
2846     {
2847         require(
2848             signature.length > 0,
2849             "LENGTH_GREATER_THAN_0_REQUIRED"
2850         );
2851 
2852         // Pop last byte off of signature byte array.
2853         uint8 signatureTypeRaw = uint8(signature.popLastByte());
2854 
2855         // Ensure signature is supported
2856         require(
2857             signatureTypeRaw < uint8(SignatureType.NSignatureTypes),
2858             "SIGNATURE_UNSUPPORTED"
2859         );
2860 
2861         SignatureType signatureType = SignatureType(signatureTypeRaw);
2862 
2863         // Variables are not scoped in Solidity.
2864         uint8 v;
2865         bytes32 r;
2866         bytes32 s;
2867         address recovered;
2868 
2869         // Always illegal signature.
2870         // This is always an implicit option since a signer can create a
2871         // signature array with invalid type or length. We may as well make
2872         // it an explicit option. This aids testing and analysis. It is
2873         // also the initialization value for the enum type.
2874         if (signatureType == SignatureType.Illegal) {
2875             revert("SIGNATURE_ILLEGAL");
2876 
2877         // Always invalid signature.
2878         // Like Illegal, this is always implicitly available and therefore
2879         // offered explicitly. It can be implicitly created by providing
2880         // a correctly formatted but incorrect signature.
2881         } else if (signatureType == SignatureType.Invalid) {
2882             require(
2883                 signature.length == 0,
2884                 "LENGTH_0_REQUIRED"
2885             );
2886             isValid = false;
2887             return isValid;
2888 
2889         // Signature using EIP712
2890         } else if (signatureType == SignatureType.EIP712) {
2891             require(
2892                 signature.length == 65,
2893                 "LENGTH_65_REQUIRED"
2894             );
2895             v = uint8(signature[0]);
2896             r = signature.readBytes32(1);
2897             s = signature.readBytes32(33);
2898             recovered = ecrecover(
2899                 hash,
2900                 v,
2901                 r,
2902                 s
2903             );
2904             isValid = signerAddress == recovered;
2905             return isValid;
2906 
2907         // Signed using web3.eth_sign
2908         } else if (signatureType == SignatureType.EthSign) {
2909             require(
2910                 signature.length == 65,
2911                 "LENGTH_65_REQUIRED"
2912             );
2913             v = uint8(signature[0]);
2914             r = signature.readBytes32(1);
2915             s = signature.readBytes32(33);
2916             recovered = ecrecover(
2917                 keccak256(abi.encodePacked(
2918                     "\x19Ethereum Signed Message:\n32",
2919                     hash
2920                 )),
2921                 v,
2922                 r,
2923                 s
2924             );
2925             isValid = signerAddress == recovered;
2926             return isValid;
2927 
2928         // Signature verified by wallet contract.
2929         // If used with an order, the maker of the order is the wallet contract.
2930         } else if (signatureType == SignatureType.Wallet) {
2931             isValid = isValidWalletSignature(
2932                 hash,
2933                 signerAddress,
2934                 signature
2935             );
2936             return isValid;
2937 
2938         // Signature verified by validator contract.
2939         // If used with an order, the maker of the order can still be an EOA.
2940         // A signature using this type should be encoded as:
2941         // | Offset   | Length | Contents                        |
2942         // | 0x00     | x      | Signature to validate           |
2943         // | 0x00 + x | 20     | Address of validator contract   |
2944         // | 0x14 + x | 1      | Signature type is always "\x06" |
2945         } else if (signatureType == SignatureType.Validator) {
2946             // Pop last 20 bytes off of signature byte array.
2947             address validatorAddress = signature.popLast20Bytes();
2948 
2949             // Ensure signer has approved validator.
2950             if (!allowedValidators[signerAddress][validatorAddress]) {
2951                 return false;
2952             }
2953             isValid = isValidValidatorSignature(
2954                 validatorAddress,
2955                 hash,
2956                 signerAddress,
2957                 signature
2958             );
2959             return isValid;
2960 
2961         // Signer signed hash previously using the preSign function.
2962         } else if (signatureType == SignatureType.PreSigned) {
2963             isValid = preSigned[hash][signerAddress];
2964             return isValid;
2965         }
2966 
2967         // Anything else is illegal (We do not return false because
2968         // the signature may actually be valid, just not in a format
2969         // that we currently support. In this case returning false
2970         // may lead the caller to incorrectly believe that the
2971         // signature was invalid.)
2972         revert("SIGNATURE_UNSUPPORTED");
2973     }
2974 
2975     /// @dev Verifies signature using logic defined by Wallet contract.
2976     /// @param hash Any 32 byte hash.
2977     /// @param walletAddress Address that should have signed the given hash
2978     ///                      and defines its own signature verification method.
2979     /// @param signature Proof that the hash has been signed by signer.
2980     /// @return True if signature is valid for given wallet..
2981     function isValidWalletSignature(
2982         bytes32 hash,
2983         address walletAddress,
2984         bytes signature
2985     )
2986         internal
2987         view
2988         returns (bool isValid)
2989     {
2990         bytes memory calldata = abi.encodeWithSelector(
2991             IWallet(walletAddress).isValidSignature.selector,
2992             hash,
2993             signature
2994         );
2995         bytes32 magic_salt = bytes32(bytes4(keccak256("isValidWalletSignature(bytes32,address,bytes)")));
2996         assembly {
2997             if iszero(extcodesize(walletAddress)) {
2998                 // Revert with `Error("WALLET_ERROR")`
2999                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3000                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3001                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3002                 mstore(96, 0)
3003                 revert(0, 100)
3004             }
3005 
3006             let cdStart := add(calldata, 32)
3007             let success := staticcall(
3008                 gas,              // forward all gas
3009                 walletAddress,    // address of Wallet contract
3010                 cdStart,          // pointer to start of input
3011                 mload(calldata),  // length of input
3012                 cdStart,          // write output over input
3013                 32                // output size is 32 bytes
3014             )
3015 
3016             if iszero(eq(returndatasize(), 32)) {
3017                 // Revert with `Error("WALLET_ERROR")`
3018                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3019                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3020                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3021                 mstore(96, 0)
3022                 revert(0, 100)
3023             }
3024 
3025             switch success
3026             case 0 {
3027                 // Revert with `Error("WALLET_ERROR")`
3028                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3029                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3030                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3031                 mstore(96, 0)
3032                 revert(0, 100)
3033             }
3034             case 1 {
3035                 // Signature is valid if call did not revert and returned true
3036                 isValid := eq(
3037                     and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3038                     and(magic_salt, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3039                 )
3040             }
3041         }
3042         return isValid;
3043     }
3044 
3045     /// @dev Verifies signature using logic defined by Validator contract.
3046     /// @param validatorAddress Address of validator contract.
3047     /// @param hash Any 32 byte hash.
3048     /// @param signerAddress Address that should have signed the given hash.
3049     /// @param signature Proof that the hash has been signed by signer.
3050     /// @return True if the address recovered from the provided signature matches the input signer address.
3051     function isValidValidatorSignature(
3052         address validatorAddress,
3053         bytes32 hash,
3054         address signerAddress,
3055         bytes signature
3056     )
3057         internal
3058         view
3059         returns (bool isValid)
3060     {
3061         bytes memory calldata = abi.encodeWithSelector(
3062             IValidator(signerAddress).isValidSignature.selector,
3063             hash,
3064             signerAddress,
3065             signature
3066         );
3067         bytes32 magic_salt = bytes32(bytes4(keccak256("isValidValidatorSignature(address,bytes32,address,bytes)")));
3068         assembly {
3069             if iszero(extcodesize(validatorAddress)) {
3070                 // Revert with `Error("VALIDATOR_ERROR")`
3071                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3072                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3073                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3074                 mstore(96, 0)
3075                 revert(0, 100)
3076             }
3077 
3078             let cdStart := add(calldata, 32)
3079             let success := staticcall(
3080                 gas,               // forward all gas
3081                 validatorAddress,  // address of Validator contract
3082                 cdStart,           // pointer to start of input
3083                 mload(calldata),   // length of input
3084                 cdStart,           // write output over input
3085                 32                 // output size is 32 bytes
3086             )
3087 
3088             if iszero(eq(returndatasize(), 32)) {
3089                 // Revert with `Error("VALIDATOR_ERROR")`
3090                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3091                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3092                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3093                 mstore(96, 0)
3094                 revert(0, 100)
3095             }
3096 
3097             switch success
3098             case 0 {
3099                 // Revert with `Error("VALIDATOR_ERROR")`
3100                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3101                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3102                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3103                 mstore(96, 0)
3104                 revert(0, 100)
3105             }
3106             case 1 {
3107                 // Signature is valid if call did not revert and returned true
3108                 isValid := eq(
3109                     and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3110                     and(magic_salt, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3111                 )
3112             }
3113         }
3114         return isValid;
3115     }
3116 }
3117 
3118 // File: contracts/exchange/MixinWrapperFunctions.sol
3119 
3120 /*
3121 
3122   Copyright 2018 ZeroEx Intl.
3123 
3124   Licensed under the Apache License, Version 2.0 (the "License");
3125   you may not use this file except in compliance with the License.
3126   You may obtain a copy of the License at
3127 
3128     http://www.apache.org/licenses/LICENSE-2.0
3129 
3130   Unless required by applicable law or agreed to in writing, software
3131   distributed under the License is distributed on an "AS IS" BASIS,
3132   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3133   See the License for the specific language governing permissions and
3134   limitations under the License.
3135 
3136 */
3137 
3138 pragma solidity 0.4.24;
3139 
3140 
3141 contract MixinWrapperFunctions is
3142     ReentrancyGuard,
3143     LibMath,
3144     MExchangeCore
3145 {
3146     /// @dev Synchronously cancels multiple orders in a single transaction.
3147     /// @param orders Array of order specifications.
3148     function batchCancelOrders(LibOrder.Order[] memory orders)
3149         public
3150         nonReentrant
3151     {
3152         uint256 ordersLength = orders.length;
3153         for (uint256 i = 0; i != ordersLength; i++) {
3154             cancelOrderInternal(orders[i]);
3155         }
3156     }
3157 
3158     /// @dev Fetches information for all passed in orders.
3159     /// @param orders Array of order specifications.
3160     /// @return Array of OrderInfo instances that correspond to each order.
3161     function getOrdersInfo(LibOrder.Order[] memory orders)
3162         public
3163         view
3164         returns (LibOrder.OrderInfo[] memory)
3165     {
3166         uint256 ordersLength = orders.length;
3167         LibOrder.OrderInfo[] memory ordersInfo = new LibOrder.OrderInfo[](ordersLength);
3168         for (uint256 i = 0; i != ordersLength; i++) {
3169             ordersInfo[i] = getOrderInfo(orders[i]);
3170         }
3171         return ordersInfo;
3172     }
3173 
3174 }
3175 
3176 // File: @0x/contracts-utils/contracts/src/interfaces/IOwnable.sol
3177 
3178 pragma solidity ^0.4.24;
3179 
3180 
3181 contract IOwnable {
3182 
3183     function transferOwnership(address newOwner)
3184         public;
3185 }
3186 
3187 // File: @0x/contracts-asset-proxy/contracts/src/interfaces/IAuthorizable.sol
3188 
3189 /*
3190 
3191   Copyright 2018 ZeroEx Intl.
3192 
3193   Licensed under the Apache License, Version 2.0 (the "License");
3194   you may not use this file except in compliance with the License.
3195   You may obtain a copy of the License at
3196 
3197     http://www.apache.org/licenses/LICENSE-2.0
3198 
3199   Unless required by applicable law or agreed to in writing, software
3200   distributed under the License is distributed on an "AS IS" BASIS,
3201   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3202   See the License for the specific language governing permissions and
3203   limitations under the License.
3204 
3205 */
3206 
3207 pragma solidity ^0.4.24;
3208 
3209 
3210 
3211 contract IAuthorizable is
3212     IOwnable
3213 {
3214     /// @dev Authorizes an address.
3215     /// @param target Address to authorize.
3216     function addAuthorizedAddress(address target)
3217         external;
3218 
3219     /// @dev Removes authorizion of an address.
3220     /// @param target Address to remove authorization from.
3221     function removeAuthorizedAddress(address target)
3222         external;
3223 
3224     /// @dev Removes authorizion of an address.
3225     /// @param target Address to remove authorization from.
3226     /// @param index Index of target in authorities array.
3227     function removeAuthorizedAddressAtIndex(
3228         address target,
3229         uint256 index
3230     )
3231         external;
3232     
3233     /// @dev Gets all authorized addresses.
3234     /// @return Array of authorized addresses.
3235     function getAuthorizedAddresses()
3236         external
3237         view
3238         returns (address[] memory);
3239 }
3240 
3241 // File: @0x/contracts-asset-proxy/contracts/src/interfaces/IAssetProxy.sol
3242 
3243 /*
3244 
3245   Copyright 2018 ZeroEx Intl.
3246 
3247   Licensed under the Apache License, Version 2.0 (the "License");
3248   you may not use this file except in compliance with the License.
3249   You may obtain a copy of the License at
3250 
3251     http://www.apache.org/licenses/LICENSE-2.0
3252 
3253   Unless required by applicable law or agreed to in writing, software
3254   distributed under the License is distributed on an "AS IS" BASIS,
3255   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3256   See the License for the specific language governing permissions and
3257   limitations under the License.
3258 
3259 */
3260 
3261 pragma solidity ^0.4.24;
3262 
3263 
3264 
3265 contract IAssetProxy is
3266     IAuthorizable
3267 {
3268     /// @dev Transfers assets. Either succeeds or throws.
3269     /// @param assetData Byte array encoded for the respective asset proxy.
3270     /// @param from Address to transfer asset from.
3271     /// @param to Address to transfer asset to.
3272     /// @param amount Amount of asset to transfer.
3273     function transferFrom(
3274         bytes assetData,
3275         address from,
3276         address to,
3277         uint256 amount
3278     )
3279         external;
3280     
3281     /// @dev Gets the proxy id associated with the proxy address.
3282     /// @return Proxy id.
3283     function getProxyId()
3284         external
3285         pure
3286         returns (bytes4);
3287 }
3288 
3289 // File: contracts/exchange/MixinAssetProxyDispatcher.sol
3290 
3291 /*
3292 
3293   Modified by Metaps Alpha Inc.
3294 
3295   Copyright 2018 ZeroEx Intl.
3296 
3297   Licensed under the Apache License, Version 2.0 (the "License");
3298   you may not use this file except in compliance with the License.
3299   You may obtain a copy of the License at
3300 
3301     http://www.apache.org/licenses/LICENSE-2.0
3302 
3303   Unless required by applicable law or agreed to in writing, software
3304   distributed under the License is distributed on an "AS IS" BASIS,
3305   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3306   See the License for the specific language governing permissions and
3307   limitations under the License.
3308 
3309 */
3310 
3311 pragma solidity 0.4.24;
3312 
3313 
3314 contract MixinAssetProxyDispatcher is
3315     DepositManager,
3316     LibConstants,
3317     MAssetProxyDispatcher
3318 {
3319     // Mapping from Asset Proxy Id's to their respective Asset Proxy
3320     mapping (bytes4 => IAssetProxy) public assetProxies;
3321 
3322     /// @dev Registers an asset proxy to its asset proxy id.
3323     ///      Once an asset proxy is registered, it cannot be unregistered.
3324     /// @param assetProxy Address of new asset proxy to register.
3325     function registerAssetProxy(address assetProxy)
3326         external
3327         onlyOwner
3328     {
3329         IAssetProxy assetProxyContract = IAssetProxy(assetProxy);
3330 
3331         // Ensure that no asset proxy exists with current id.
3332         bytes4 assetProxyId = assetProxyContract.getProxyId();
3333         address currentAssetProxy = assetProxies[assetProxyId];
3334         require(
3335             currentAssetProxy == address(0),
3336             "ASSET_PROXY_ALREADY_EXISTS"
3337         );
3338 
3339         // Add asset proxy and log registration.
3340         assetProxies[assetProxyId] = assetProxyContract;
3341         emit AssetProxyRegistered(
3342             assetProxyId,
3343             assetProxy
3344         );
3345     }
3346 
3347     /// @dev Gets an asset proxy.
3348     /// @param assetProxyId Id of the asset proxy.
3349     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
3350     function getAssetProxy(bytes4 assetProxyId)
3351         external
3352         view
3353         returns (address)
3354     {
3355         return assetProxies[assetProxyId];
3356     }
3357 
3358     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
3359     /// @param assetData Byte array encoded for the asset.
3360     /// @param from Address to transfer token from.
3361     /// @param to Address to transfer token to.
3362     /// @param amount Amount of token to transfer.
3363     function dispatchTransferFrom(
3364         bytes memory assetData,
3365         address from,
3366         address to,
3367         uint256 amount
3368     )
3369         internal
3370     {
3371         // Do nothing if no amount should be transferred.
3372         if (amount > 0 && from != to) {
3373             // Ensure assetData length is valid
3374             require(
3375                 assetData.length > 3,
3376                 "LENGTH_GREATER_THAN_3_REQUIRED"
3377             );
3378 
3379             // miime - If assetData is for ETH, send ETH from deposit.
3380             if (keccak256(assetData) == KECCAK256_ETH_ASSET_DATA) {
3381                 require(
3382                     depositAmount[from] >= amount,
3383                     "DEPOSIT_AMOUNT_IS_INSUFFICIENT"
3384                 );
3385                 uint256 afterBalance = safeSub(depositAmount[from], amount);
3386                 depositAmount[from] = afterBalance;
3387                 if (to != address(this)) {
3388                     if (!to.call.gas(TRANSFER_GAS_LIMIT).value(amount)()) {
3389                         revert("ETH_SENDING_FAILED");
3390                     }
3391                 }
3392                 return;
3393             }
3394 
3395             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
3396             bytes4 assetProxyId;
3397             assembly {
3398                 assetProxyId := and(mload(
3399                     add(assetData, 32)),
3400                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
3401                 )
3402             }
3403             address assetProxy = assetProxies[assetProxyId];
3404 
3405             // Ensure that assetProxy exists
3406             require(
3407                 assetProxy != address(0),
3408                 "ASSET_PROXY_DOES_NOT_EXIST"
3409             );
3410             
3411             // We construct calldata for the `assetProxy.transferFrom` ABI.
3412             // The layout of this calldata is in the table below.
3413             // 
3414             // | Area     | Offset | Length  | Contents                                    |
3415             // | -------- |--------|---------|-------------------------------------------- |
3416             // | Header   | 0      | 4       | function selector                           |
3417             // | Params   |        | 4 * 32  | function parameters:                        |
3418             // |          | 4      |         |   1. offset to assetData (*)                |
3419             // |          | 36     |         |   2. from                                   |
3420             // |          | 68     |         |   3. to                                     |
3421             // |          | 100    |         |   4. amount                                 |
3422             // | Data     |        |         | assetData:                                  |
3423             // |          | 132    | 32      | assetData Length                            |
3424             // |          | 164    | **      | assetData Contents                          |
3425 
3426             assembly {
3427                 /////// Setup State ///////
3428                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
3429                 let cdStart := mload(64)
3430                 // `dataAreaLength` is the total number of words needed to store `assetData`
3431                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
3432                 //  and includes 32-bytes for length.
3433                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
3434                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
3435                 let cdEnd := add(cdStart, add(132, dataAreaLength))
3436 
3437                 
3438                 /////// Setup Header Area ///////
3439                 // This area holds the 4-byte `transferFromSelector`.
3440                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
3441                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
3442                 
3443                 /////// Setup Params Area ///////
3444                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
3445                 // Notes:
3446                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
3447                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
3448                 mstore(add(cdStart, 4), 128)
3449                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
3450                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
3451                 mstore(add(cdStart, 100), amount)
3452                 
3453                 /////// Setup Data Area ///////
3454                 // This area holds `assetData`.
3455                 let dataArea := add(cdStart, 132)
3456                 // solhint-disable-next-line no-empty-blocks
3457                 for {} lt(dataArea, cdEnd) {} {
3458                     mstore(dataArea, mload(assetData))
3459                     dataArea := add(dataArea, 32)
3460                     assetData := add(assetData, 32)
3461                 }
3462 
3463                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
3464                 let success := call(
3465                     gas,                    // forward all gas
3466                     assetProxy,             // call address of asset proxy
3467                     0,                      // don't send any ETH
3468                     cdStart,                // pointer to start of input
3469                     sub(cdEnd, cdStart),    // length of input  
3470                     cdStart,                // write output over input
3471                     512                     // reserve 512 bytes for output
3472                 )
3473                 if iszero(success) {
3474                     revert(cdStart, returndatasize())
3475                 }
3476             }
3477         }
3478     }
3479 }
3480 
3481 // File: @0x/contracts-exchange-libs/contracts/src/LibExchangeErrors.sol
3482 
3483 /*
3484 
3485   Copyright 2018 ZeroEx Intl.
3486 
3487   Licensed under the Apache License, Version 2.0 (the "License");
3488   you may not use this file except in compliance with the License.
3489   You may obtain a copy of the License at
3490 
3491     http://www.apache.org/licenses/LICENSE-2.0
3492 
3493   Unless required by applicable law or agreed to in writing, software
3494   distributed under the License is distributed on an "AS IS" BASIS,
3495   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3496   See the License for the specific language governing permissions and
3497   limitations under the License.
3498 
3499 */
3500 
3501 // solhint-disable
3502 pragma solidity ^0.4.24;
3503 
3504 
3505 /// @dev This contract documents the revert reasons used in the Exchange contract.
3506 /// This contract is intended to serve as a reference, but is not actually used for efficiency reasons.
3507 contract LibExchangeErrors {
3508 
3509     /// Order validation errors ///
3510     string constant ORDER_UNFILLABLE = "ORDER_UNFILLABLE";                              // Order cannot be filled.
3511     string constant INVALID_MAKER = "INVALID_MAKER";                                    // Invalid makerAddress.
3512     string constant INVALID_TAKER = "INVALID_TAKER";                                    // Invalid takerAddress.
3513     string constant INVALID_SENDER = "INVALID_SENDER";                                  // Invalid `msg.sender`.
3514     string constant INVALID_ORDER_SIGNATURE = "INVALID_ORDER_SIGNATURE";                // Signature validation failed. 
3515     
3516     /// fillOrder validation errors ///
3517     string constant INVALID_TAKER_AMOUNT = "INVALID_TAKER_AMOUNT";                      // takerAssetFillAmount cannot equal 0.
3518     string constant ROUNDING_ERROR = "ROUNDING_ERROR";                                  // Rounding error greater than 0.1% of takerAssetFillAmount. 
3519     
3520     /// Signature validation errors ///
3521     string constant INVALID_SIGNATURE = "INVALID_SIGNATURE";                            // Signature validation failed. 
3522     string constant SIGNATURE_ILLEGAL = "SIGNATURE_ILLEGAL";                            // Signature type is illegal.
3523     string constant SIGNATURE_UNSUPPORTED = "SIGNATURE_UNSUPPORTED";                    // Signature type unsupported.
3524     
3525     /// cancelOrdersUptTo errors ///
3526     string constant INVALID_NEW_ORDER_EPOCH = "INVALID_NEW_ORDER_EPOCH";                // Specified salt must be greater than or equal to existing orderEpoch.
3527 
3528     /// fillOrKillOrder errors ///
3529     string constant COMPLETE_FILL_FAILED = "COMPLETE_FILL_FAILED";                      // Desired takerAssetFillAmount could not be completely filled. 
3530 
3531     /// matchOrders errors ///
3532     string constant NEGATIVE_SPREAD_REQUIRED = "NEGATIVE_SPREAD_REQUIRED";              // Matched orders must have a negative spread.
3533 
3534     /// Transaction errors ///
3535     string constant REENTRANCY_ILLEGAL = "REENTRANCY_ILLEGAL";                          // Recursive reentrancy is not allowed. 
3536     string constant INVALID_TX_HASH = "INVALID_TX_HASH";                                // Transaction has already been executed. 
3537     string constant INVALID_TX_SIGNATURE = "INVALID_TX_SIGNATURE";                      // Signature validation failed. 
3538     string constant FAILED_EXECUTION = "FAILED_EXECUTION";                              // Transaction execution failed. 
3539     
3540     /// registerAssetProxy errors ///
3541     string constant ASSET_PROXY_ALREADY_EXISTS = "ASSET_PROXY_ALREADY_EXISTS";          // AssetProxy with same id already exists.
3542 
3543     /// dispatchTransferFrom errors ///
3544     string constant ASSET_PROXY_DOES_NOT_EXIST = "ASSET_PROXY_DOES_NOT_EXIST";          // No assetProxy registered at given id.
3545     string constant TRANSFER_FAILED = "TRANSFER_FAILED";                                // Asset transfer unsuccesful.
3546 
3547     /// Length validation errors ///
3548     string constant LENGTH_GREATER_THAN_0_REQUIRED = "LENGTH_GREATER_THAN_0_REQUIRED";  // Byte array must have a length greater than 0.
3549     string constant LENGTH_GREATER_THAN_3_REQUIRED = "LENGTH_GREATER_THAN_3_REQUIRED";  // Byte array must have a length greater than 3.
3550     string constant LENGTH_0_REQUIRED = "LENGTH_0_REQUIRED";                            // Byte array must have a length of 0.
3551     string constant LENGTH_65_REQUIRED = "LENGTH_65_REQUIRED";                          // Byte array must have a length of 65.
3552 }
3553 
3554 // File: contracts/exchange/MixinTransactions.sol
3555 
3556 /*
3557 
3558   Copyright 2018 ZeroEx Intl.
3559 
3560   Licensed under the Apache License, Version 2.0 (the "License");
3561   you may not use this file except in compliance with the License.
3562   You may obtain a copy of the License at
3563 
3564     http://www.apache.org/licenses/LICENSE-2.0
3565 
3566   Unless required by applicable law or agreed to in writing, software
3567   distributed under the License is distributed on an "AS IS" BASIS,
3568   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3569   See the License for the specific language governing permissions and
3570   limitations under the License.
3571 
3572 */
3573 
3574 pragma solidity 0.4.24;
3575 
3576 
3577 contract MixinTransactions is
3578     LibEIP712,
3579     MSignatureValidator,
3580     MTransactions
3581 {
3582     // Mapping of transaction hash => executed
3583     // This prevents transactions from being executed more than once.
3584     mapping (bytes32 => bool) public transactions;
3585 
3586     // Address of current transaction signer
3587     address public currentContextAddress;
3588 
3589     /// @dev Executes an exchange method call in the context of signer.
3590     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3591     /// @param signerAddress Address of transaction signer.
3592     /// @param data AbiV2 encoded calldata.
3593     /// @param signature Proof of signer transaction by signer.
3594     function executeTransaction(
3595         uint256 salt,
3596         address signerAddress,
3597         bytes data,
3598         bytes signature
3599     )
3600         external
3601     {
3602         // Prevent reentrancy
3603         require(
3604             currentContextAddress == address(0),
3605             "REENTRANCY_ILLEGAL"
3606         );
3607 
3608         bytes32 transactionHash = hashEIP712Message(hashZeroExTransaction(
3609             salt,
3610             signerAddress,
3611             data
3612         ));
3613 
3614         // Validate transaction has not been executed
3615         require(
3616             !transactions[transactionHash],
3617             "INVALID_TX_HASH"
3618         );
3619 
3620         // Transaction always valid if signer is sender of transaction
3621         if (signerAddress != msg.sender) {
3622             // Validate signature
3623             require(
3624                 isValidSignature(
3625                     transactionHash,
3626                     signerAddress,
3627                     signature
3628                 ),
3629                 "INVALID_TX_SIGNATURE"
3630             );
3631 
3632             // Set the current transaction signer
3633             currentContextAddress = signerAddress;
3634         }
3635 
3636         // Execute transaction
3637         transactions[transactionHash] = true;
3638         require(
3639             address(this).delegatecall(data),
3640             "FAILED_EXECUTION"
3641         );
3642 
3643         // Reset current transaction signer if it was previously updated
3644         if (signerAddress != msg.sender) {
3645             currentContextAddress = address(0);
3646         }
3647     }
3648 
3649     /// @dev Calculates EIP712 hash of the Transaction.
3650     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3651     /// @param signerAddress Address of transaction signer.
3652     /// @param data AbiV2 encoded calldata.
3653     /// @return EIP712 hash of the Transaction.
3654     function hashZeroExTransaction(
3655         uint256 salt,
3656         address signerAddress,
3657         bytes memory data
3658     )
3659         internal
3660         pure
3661         returns (bytes32 result)
3662     {
3663         bytes32 schemaHash = EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
3664         bytes32 dataHash = keccak256(data);
3665 
3666         // Assembly for more efficiently computing:
3667         // keccak256(abi.encodePacked(
3668         //     EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH,
3669         //     salt,
3670         //     bytes32(signerAddress),
3671         //     keccak256(data)
3672         // ));
3673 
3674         assembly {
3675             // Load free memory pointer
3676             let memPtr := mload(64)
3677 
3678             mstore(memPtr, schemaHash)                                                               // hash of schema
3679             mstore(add(memPtr, 32), salt)                                                            // salt
3680             mstore(add(memPtr, 64), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
3681             mstore(add(memPtr, 96), dataHash)                                                        // hash of data
3682 
3683             // Compute hash
3684             result := keccak256(memPtr, 128)
3685         }
3686         return result;
3687     }
3688 
3689     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
3690     ///      If calling a fill function, this address will represent the taker.
3691     ///      If calling a cancel function, this address will represent the maker.
3692     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
3693     ///         `msg.sender` if entry point is any other function.
3694     function getCurrentContextAddress()
3695         internal
3696         view
3697         returns (address)
3698     {
3699         address currentContextAddress_ = currentContextAddress;
3700         address contextAddress = currentContextAddress_ == address(0) ? msg.sender : currentContextAddress_;
3701         return contextAddress;
3702     }
3703 }
3704 
3705 // File: contracts/exchange/Exchange.sol
3706 
3707 /*
3708 
3709   Modified by Metaps Alpha Inc.
3710 
3711   Copyright 2018 ZeroEx Intl.
3712 
3713   Licensed under the Apache License, Version 2.0 (the "License");
3714   you may not use this file except in compliance with the License.
3715   You may obtain a copy of the License at
3716 
3717     http://www.apache.org/licenses/LICENSE-2.0
3718 
3719   Unless required by applicable law or agreed to in writing, software
3720   distributed under the License is distributed on an "AS IS" BASIS,
3721   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3722   See the License for the specific language governing permissions and
3723   limitations under the License.
3724 
3725 */
3726 
3727 pragma solidity 0.4.24;
3728 
3729 
3730 // solhint-disable no-empty-blocks
3731 contract Exchange is
3732     MixinExchangeCore,
3733     MixinSignatureValidator,
3734     MixinTransactions,
3735     MixinWrapperFunctions,
3736     MixinAssetProxyDispatcher
3737 {
3738     string constant public VERSION = "2.0.1-alpha-miime";
3739 
3740     // Mixins are instantiated in the order they are inherited
3741     constructor ()
3742         public
3743         MixinExchangeCore()
3744         MixinSignatureValidator()
3745         MixinTransactions()
3746         MixinAssetProxyDispatcher()
3747         MixinWrapperFunctions()
3748     {}
3749 }