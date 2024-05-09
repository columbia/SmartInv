1 // File: @0x/contracts-utils/contracts/src/LibRichErrors.sol
2 
3 /*
4 
5   Copyright 2019 ZeroEx Intl.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11     http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 
19 */
20 
21 pragma solidity ^0.5.9;
22 pragma experimental ABIEncoderV2;
23 
24 
25 library LibRichErrors {
26 
27     // bytes4(keccak256("Error(string)"))
28     bytes4 internal constant STANDARD_ERROR_SELECTOR =
29         0x08c379a0;
30 
31     // solhint-disable func-name-mixedcase
32     /// @dev ABI encode a standard, string revert error payload.
33     ///      This is the same payload that would be included by a `revert(string)`
34     ///      solidity statement. It has the function signature `Error(string)`.
35     /// @param message The error string.
36     /// @return The ABI encoded error.
37     function StandardError(
38         string memory message
39     )
40         internal
41         pure
42         returns (bytes memory)
43     {
44         return abi.encodeWithSelector(
45             STANDARD_ERROR_SELECTOR,
46             bytes(message)
47         );
48     }
49     // solhint-enable func-name-mixedcase
50 
51     /// @dev Reverts an encoded rich revert reason `errorData`.
52     /// @param errorData ABI encoded error data.
53     function rrevert(bytes memory errorData)
54         internal
55         pure
56     {
57         assembly {
58             revert(add(errorData, 0x20), mload(errorData))
59         }
60     }
61 }
62 
63 // File: @0x/contracts-utils/contracts/src/LibSafeMathRichErrors.sol
64 
65 pragma solidity ^0.5.9;
66 
67 
68 library LibSafeMathRichErrors {
69 
70     // bytes4(keccak256("Uint256BinOpError(uint8,uint256,uint256)"))
71     bytes4 internal constant UINT256_BINOP_ERROR_SELECTOR =
72         0xe946c1bb;
73 
74     // bytes4(keccak256("Uint256DowncastError(uint8,uint256)"))
75     bytes4 internal constant UINT256_DOWNCAST_ERROR_SELECTOR =
76         0xc996af7b;
77 
78     enum BinOpErrorCodes {
79         ADDITION_OVERFLOW,
80         MULTIPLICATION_OVERFLOW,
81         SUBTRACTION_UNDERFLOW,
82         DIVISION_BY_ZERO
83     }
84 
85     enum DowncastErrorCodes {
86         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT32,
87         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT64,
88         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT96
89     }
90 
91     // solhint-disable func-name-mixedcase
92     function Uint256BinOpError(
93         BinOpErrorCodes errorCode,
94         uint256 a,
95         uint256 b
96     )
97         internal
98         pure
99         returns (bytes memory)
100     {
101         return abi.encodeWithSelector(
102             UINT256_BINOP_ERROR_SELECTOR,
103             errorCode,
104             a,
105             b
106         );
107     }
108 
109     function Uint256DowncastError(
110         DowncastErrorCodes errorCode,
111         uint256 a
112     )
113         internal
114         pure
115         returns (bytes memory)
116     {
117         return abi.encodeWithSelector(
118             UINT256_DOWNCAST_ERROR_SELECTOR,
119             errorCode,
120             a
121         );
122     }
123 }
124 
125 // File: @0x/contracts-utils/contracts/src/LibSafeMath.sol
126 
127 pragma solidity ^0.5.9;
128 
129 
130 library LibSafeMath {
131 
132     function safeMul(uint256 a, uint256 b)
133         internal
134         pure
135         returns (uint256)
136     {
137         if (a == 0) {
138             return 0;
139         }
140         uint256 c = a * b;
141         if (c / a != b) {
142             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
143                 LibSafeMathRichErrors.BinOpErrorCodes.MULTIPLICATION_OVERFLOW,
144                 a,
145                 b
146             ));
147         }
148         return c;
149     }
150 
151     function safeDiv(uint256 a, uint256 b)
152         internal
153         pure
154         returns (uint256)
155     {
156         if (b == 0) {
157             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
158                 LibSafeMathRichErrors.BinOpErrorCodes.DIVISION_BY_ZERO,
159                 a,
160                 b
161             ));
162         }
163         uint256 c = a / b;
164         return c;
165     }
166 
167     function safeSub(uint256 a, uint256 b)
168         internal
169         pure
170         returns (uint256)
171     {
172         if (b > a) {
173             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
174                 LibSafeMathRichErrors.BinOpErrorCodes.SUBTRACTION_UNDERFLOW,
175                 a,
176                 b
177             ));
178         }
179         return a - b;
180     }
181 
182     function safeAdd(uint256 a, uint256 b)
183         internal
184         pure
185         returns (uint256)
186     {
187         uint256 c = a + b;
188         if (c < a) {
189             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
190                 LibSafeMathRichErrors.BinOpErrorCodes.ADDITION_OVERFLOW,
191                 a,
192                 b
193             ));
194         }
195         return c;
196     }
197 
198     function max256(uint256 a, uint256 b)
199         internal
200         pure
201         returns (uint256)
202     {
203         return a >= b ? a : b;
204     }
205 
206     function min256(uint256 a, uint256 b)
207         internal
208         pure
209         returns (uint256)
210     {
211         return a < b ? a : b;
212     }
213 }
214 
215 
216 // File: contracts/exchange/libs/LibMath.sol
217 
218 /*
219   Copyright 2018 ZeroEx Intl.
220   Licensed under the Apache License, Version 2.0 (the "License");
221   you may not use this file except in compliance with the License.
222   You may obtain a copy of the License at
223     http://www.apache.org/licenses/LICENSE-2.0
224   Unless required by applicable law or agreed to in writing, software
225   distributed under the License is distributed on an "AS IS" BASIS,
226   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
227   See the License for the specific language governing permissions and
228   limitations under the License.
229 */
230 
231 pragma solidity 0.5.16;
232 
233 
234 contract LibMath  {
235     using LibSafeMath for uint256;
236 
237     /// @dev Calculates partial value given a numerator and denominator rounded down.
238     ///      Reverts if rounding error is >= 0.1%
239     /// @param numerator Numerator.
240     /// @param denominator Denominator.
241     /// @param target Value to calculate partial of.
242     /// @return Partial value of target rounded down.
243     function safeGetPartialAmountFloor(
244         uint256 numerator,
245         uint256 denominator,
246         uint256 target
247     )
248         internal
249         pure
250         returns (uint256 partialAmount)
251     {
252         require(
253             denominator > 0,
254             "DIVISION_BY_ZERO"
255         );
256 
257         require(
258             !isRoundingErrorFloor(
259                 numerator,
260                 denominator,
261                 target
262             ),
263             "ROUNDING_ERROR"
264         );
265 
266         partialAmount = numerator.safeMul(target).safeDiv(denominator);
267         return partialAmount;
268     }
269 
270     /// @dev Calculates partial value given a numerator and denominator rounded down.
271     ///      Reverts if rounding error is >= 0.1%
272     /// @param numerator Numerator.
273     /// @param denominator Denominator.
274     /// @param target Value to calculate partial of.
275     /// @return Partial value of target rounded up.
276     function safeGetPartialAmountCeil(
277         uint256 numerator,
278         uint256 denominator,
279         uint256 target
280     )
281         internal
282         pure
283         returns (uint256 partialAmount)
284     {
285         require(
286             denominator > 0,
287             "DIVISION_BY_ZERO"
288         );
289 
290         require(
291             !isRoundingErrorCeil(
292                 numerator,
293                 denominator,
294                 target
295             ),
296             "ROUNDING_ERROR"
297         );
298 
299         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
300         //       ceil(a / b) = floor((a + b - 1) / b)
301         // To implement `ceil(a / b)` using safeDiv.
302         partialAmount = numerator.safeMul(target).safeAdd(denominator.safeSub(1)).safeDiv(denominator);
303         return partialAmount;
304     }
305 
306     /// @dev Calculates partial value given a numerator and denominator rounded down.
307     /// @param numerator Numerator.
308     /// @param denominator Denominator.
309     /// @param target Value to calculate partial of.
310     /// @return Partial value of target rounded down.
311     function getPartialAmountFloor(
312         uint256 numerator,
313         uint256 denominator,
314         uint256 target
315     )
316         internal
317         pure
318         returns (uint256 partialAmount)
319     {
320         require(
321             denominator > 0,
322             "DIVISION_BY_ZERO"
323         );
324 
325         partialAmount = numerator.safeMul(target).safeDiv(denominator);
326         return partialAmount;
327     }
328 
329     /// @dev Calculates partial value given a numerator and denominator rounded down.
330     /// @param numerator Numerator.
331     /// @param denominator Denominator.
332     /// @param target Value to calculate partial of.
333     /// @return Partial value of target rounded up.
334     function getPartialAmountCeil(
335         uint256 numerator,
336         uint256 denominator,
337         uint256 target
338     )
339         internal
340         pure
341         returns (uint256 partialAmount)
342     {
343         require(
344             denominator > 0,
345             "DIVISION_BY_ZERO"
346         );
347 
348         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
349         //       ceil(a / b) = floor((a + b - 1) / b)
350         // To implement `ceil(a / b)` using safeDiv.
351         partialAmount = numerator.safeMul(target).safeAdd(denominator.safeSub(1)).safeDiv(denominator);
352         return partialAmount;
353     }
354 
355     /// @dev Checks if rounding error >= 0.1% when rounding down.
356     /// @param numerator Numerator.
357     /// @param denominator Denominator.
358     /// @param target Value to multiply with numerator/denominator.
359     /// @return Rounding error is present.
360     function isRoundingErrorFloor(
361         uint256 numerator,
362         uint256 denominator,
363         uint256 target
364     )
365         internal
366         pure
367         returns (bool isError)
368     {
369         require(
370             denominator > 0,
371             "DIVISION_BY_ZERO"
372         );
373 
374         // The absolute rounding error is the difference between the rounded
375         // value and the ideal value. The relative rounding error is the
376         // absolute rounding error divided by the absolute value of the
377         // ideal value. This is undefined when the ideal value is zero.
378         //
379         // The ideal value is `numerator * target / denominator`.
380         // Let's call `numerator * target % denominator` the remainder.
381         // The absolute error is `remainder / denominator`.
382         //
383         // When the ideal value is zero, we require the absolute error to
384         // be zero. Fortunately, this is always the case. The ideal value is
385         // zero iff `numerator == 0` and/or `target == 0`. In this case the
386         // remainder and absolute error are also zero.
387         if (target == 0 || numerator == 0) {
388             return false;
389         }
390 
391         // Otherwise, we want the relative rounding error to be strictly
392         // less than 0.1%.
393         // The relative error is `remainder / (numerator * target)`.
394         // We want the relative error less than 1 / 1000:
395         //        remainder / (numerator * denominator)  <  1 / 1000
396         // or equivalently:
397         //        1000 * remainder  <  numerator * target
398         // so we have a rounding error iff:
399         //        1000 * remainder  >=  numerator * target
400         uint256 remainder = mulmod(
401             target,
402             numerator,
403             denominator
404         );
405         isError = remainder.safeMul(1000) >= numerator.safeMul(target);
406         return isError;
407     }
408 
409     /// @dev Checks if rounding error >= 0.1% when rounding up.
410     /// @param numerator Numerator.
411     /// @param denominator Denominator.
412     /// @param target Value to multiply with numerator/denominator.
413     /// @return Rounding error is present.
414     function isRoundingErrorCeil(
415         uint256 numerator,
416         uint256 denominator,
417         uint256 target
418     )
419         internal
420         pure
421         returns (bool isError)
422     {
423         require(
424             denominator > 0,
425             "DIVISION_BY_ZERO"
426         );
427 
428         // See the comments in `isRoundingError`.
429         if (target == 0 || numerator == 0) {
430             // When either is zero, the ideal value and rounded value are zero
431             // and there is no rounding error. (Although the relative error
432             // is undefined.)
433             return false;
434         }
435         // Compute remainder as before
436         uint256 remainder = mulmod(
437             target,
438             numerator,
439             denominator
440         );
441         remainder = denominator.safeSub(remainder) % denominator;
442         isError = remainder.safeMul(1000) >= numerator.safeMul(target);
443         return isError;
444     }
445 }
446 
447 
448 // File: contracts/exchange/libs/LibFillResults.sol
449 
450 /*
451   Copyright 2018 ZeroEx Intl.
452   Licensed under the Apache License, Version 2.0 (the "License");
453   you may not use this file except in compliance with the License.
454   You may obtain a copy of the License at
455     http://www.apache.org/licenses/LICENSE-2.0
456   Unless required by applicable law or agreed to in writing, software
457   distributed under the License is distributed on an "AS IS" BASIS,
458   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
459   See the License for the specific language governing permissions and
460   limitations under the License.
461 */
462 
463 pragma solidity 0.5.16;
464 
465 
466 contract LibFillResults {
467     using LibSafeMath for uint256;
468 
469     struct FillResults {
470         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
471         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
472         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
473         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
474     }
475 
476     struct MatchedFillResults {
477         FillResults left;                    // Amounts filled and fees paid of left order.
478         FillResults right;                   // Amounts filled and fees paid of right order.
479         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
480     }
481 
482     /// @dev Adds properties of both FillResults instances.
483     ///      Modifies the first FillResults instance specified.
484     /// @param totalFillResults Fill results instance that will be added onto.
485     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
486     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
487         internal
488         pure
489     {
490         totalFillResults.makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount.safeAdd(singleFillResults.makerAssetFilledAmount);
491         totalFillResults.takerAssetFilledAmount = totalFillResults.takerAssetFilledAmount.safeAdd(singleFillResults.takerAssetFilledAmount);
492         totalFillResults.makerFeePaid = totalFillResults.makerFeePaid.safeAdd(singleFillResults.makerFeePaid);
493         totalFillResults.takerFeePaid = totalFillResults.takerFeePaid.safeAdd(singleFillResults.takerFeePaid);
494     }
495 }
496 
497 
498 // File: contracts/exchange/libs/LibEIP712.sol
499 
500 /*
501 
502   Copyright 2018 ZeroEx Intl.
503 
504   Licensed under the Apache License, Version 2.0 (the "License");
505   you may not use this file except in compliance with the License.
506   You may obtain a copy of the License at
507 
508     http://www.apache.org/licenses/LICENSE-2.0
509 
510   Unless required by applicable law or agreed to in writing, software
511   distributed under the License is distributed on an "AS IS" BASIS,
512   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
513   See the License for the specific language governing permissions and
514   limitations under the License.
515 
516 */
517 
518 pragma solidity 0.5.16;
519 
520 
521 contract LibEIP712 {
522 
523     // EIP191 header for EIP712 prefix
524     string constant internal EIP191_HEADER = "\x19\x01";
525 
526     // EIP712 Domain Name value
527     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
528 
529     // EIP712 Domain Version value
530     string constant internal EIP712_DOMAIN_VERSION = "2";
531 
532     // Hash of the EIP712 Domain Separator Schema
533     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
534         "EIP712Domain(",
535         "string name,",
536         "string version,",
537         "address verifyingContract",
538         ")"
539     ));
540 
541     // Hash of the EIP712 Domain Separator data
542     // solhint-disable-next-line var-name-mixedcase
543     bytes32 public EIP712_DOMAIN_HASH;
544 
545     constructor ()
546         public
547     {
548         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
549             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
550             keccak256(bytes(EIP712_DOMAIN_NAME)),
551             keccak256(bytes(EIP712_DOMAIN_VERSION)),
552             uint256(address(this))
553         ));
554     }
555 
556     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
557     /// @param hashStruct The EIP712 hash struct.
558     /// @return EIP712 hash applied to this EIP712 Domain.
559     function hashEIP712Message(bytes32 hashStruct)
560         internal
561         view
562         returns (bytes32 result)
563     {
564         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
565 
566         // Assembly for more efficient computing:
567         // keccak256(abi.encodePacked(
568         //     EIP191_HEADER,
569         //     EIP712_DOMAIN_HASH,
570         //     hashStruct
571         // ));
572 
573         assembly {
574             // Load free memory pointer
575             let memPtr := mload(64)
576 
577             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
578             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
579             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
580 
581             // Compute hash
582             result := keccak256(memPtr, 66)
583         }
584         return result;
585     }
586 }
587 
588 
589 // File: contracts/exchange/libs/LibOrder.sol
590 
591 /*
592 
593   Copyright 2018 ZeroEx Intl.
594 
595   Licensed under the Apache License, Version 2.0 (the "License");
596   you may not use this file except in compliance with the License.
597   You may obtain a copy of the License at
598 
599     http://www.apache.org/licenses/LICENSE-2.0
600 
601   Unless required by applicable law or agreed to in writing, software
602   distributed under the License is distributed on an "AS IS" BASIS,
603   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
604   See the License for the specific language governing permissions and
605   limitations under the License.
606 
607 */
608 
609 pragma solidity 0.5.16;
610 
611 
612 contract LibOrder is
613     LibEIP712
614 {
615     // Hash for the EIP712 Order Schema
616     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
617         "Order(",
618         "address makerAddress,",
619         "address takerAddress,",
620         "address feeRecipientAddress,",
621         "address senderAddress,",
622         "uint256 makerAssetAmount,",
623         "uint256 takerAssetAmount,",
624         "uint256 makerFee,",
625         "uint256 takerFee,",
626         "uint256 expirationTimeSeconds,",
627         "uint256 salt,",
628         "bytes makerAssetData,",
629         "bytes takerAssetData",
630         ")"
631     ));
632 
633     // A valid order remains fillable until it is expired, fully filled, or cancelled.
634     // An order's state is unaffected by external factors, like account balances.
635     enum OrderStatus {
636         INVALID,                     // Default value
637         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
638         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
639         FILLABLE,                    // Order is fillable
640         EXPIRED,                     // Order has already expired
641         FULLY_FILLED,                // Order is fully filled
642         CANCELLED                    // Order has been cancelled
643     }
644 
645     // solhint-disable max-line-length
646     struct Order {
647         address payable makerAddress;           // Address that created the order.      
648         address payable takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
649         address payable feeRecipientAddress;    // Address that will recieve fees when order is filled.      
650         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
651         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
652         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
653         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
654         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
655         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
656         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
657         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
658         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
659     }
660     // solhint-enable max-line-length
661 
662     struct OrderInfo {
663         uint8 orderStatus;                    // Status that describes order's validity and fillability.
664         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
665         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
666     }
667 
668     /// @dev Calculates Keccak-256 hash of the order.
669     /// @param order The order structure.
670     /// @return Keccak-256 EIP712 hash of the order.
671     function getOrderHash(Order memory order)
672         internal
673         view
674         returns (bytes32 orderHash)
675     {
676         orderHash = hashEIP712Message(hashOrder(order));
677         return orderHash;
678     }
679 
680     /// @dev Calculates EIP712 hash of the order.
681     /// @param order The order structure.
682     /// @return EIP712 hash of the order.
683     function hashOrder(Order memory order)
684         internal
685         pure
686         returns (bytes32 result)
687     {
688         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
689         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
690         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
691 
692         // Assembly for more efficiently computing:
693         // keccak256(abi.encodePacked(
694         //     EIP712_ORDER_SCHEMA_HASH,
695         //     bytes32(order.makerAddress),
696         //     bytes32(order.takerAddress),
697         //     bytes32(order.feeRecipientAddress),
698         //     bytes32(order.senderAddress),
699         //     order.makerAssetAmount,
700         //     order.takerAssetAmount,
701         //     order.makerFee,
702         //     order.takerFee,
703         //     order.expirationTimeSeconds,
704         //     order.salt,
705         //     keccak256(order.makerAssetData),
706         //     keccak256(order.takerAssetData)
707         // ));
708 
709         assembly {
710             // Calculate memory addresses that will be swapped out before hashing
711             let pos1 := sub(order, 32)
712             let pos2 := add(order, 320)
713             let pos3 := add(order, 352)
714 
715             // Backup
716             let temp1 := mload(pos1)
717             let temp2 := mload(pos2)
718             let temp3 := mload(pos3)
719             
720             // Hash in place
721             mstore(pos1, schemaHash)
722             mstore(pos2, makerAssetDataHash)
723             mstore(pos3, takerAssetDataHash)
724             result := keccak256(pos1, 416)
725             
726             // Restore
727             mstore(pos1, temp1)
728             mstore(pos2, temp2)
729             mstore(pos3, temp3)
730         }
731         return result;
732     }
733 }
734 
735 
736 // File: contracts/exchange/interfaces/IExchangeCore.sol
737 
738 /*
739 
740   Modified by Metaps Alpha Inc.
741 
742   Copyright 2018 ZeroEx Intl.
743 
744   Licensed under the Apache License, Version 2.0 (the "License");
745   you may not use this file except in compliance with the License.
746   You may obtain a copy of the License at
747 
748     http://www.apache.org/licenses/LICENSE-2.0
749 
750   Unless required by applicable law or agreed to in writing, software
751   distributed under the License is distributed on an "AS IS" BASIS,
752   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
753   See the License for the specific language governing permissions and
754   limitations under the License.
755 
756 */
757 
758 pragma solidity 0.5.16;
759 
760 
761 contract IExchangeCore {
762 
763     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
764     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
765     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
766     function cancelOrdersUpTo(uint256 targetOrderEpoch)
767         external;
768 
769     /// @dev Fills the input order.
770     /// @param order Order struct containing order specifications.
771     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
772     /// @param signature Proof that order has been created by maker.
773     /// @return Amounts filled and fees paid by maker and taker.
774     function fillOrder(
775         LibOrder.Order memory order,
776         uint256 takerAssetFillAmount,
777         bytes memory signature
778     )
779         public
780         payable
781         returns (LibFillResults.FillResults memory fillResults);
782 
783     /// @dev After calling, the order can not be filled anymore.
784     /// @param order Order struct containing order specifications.
785     function cancelOrder(LibOrder.Order memory order)
786         public;
787 
788     /// @dev Gets information about an order: status, hash, and amount filled.
789     /// @param order Order to gather information on.
790     /// @return OrderInfo Information about the order and its state.
791     ///                   See LibOrder.OrderInfo for a complete description.
792     function getOrderInfo(LibOrder.Order memory order)
793         public
794         view
795         returns (LibOrder.OrderInfo memory orderInfo);
796 
797     /// @dev miime - Update order (Cancel order and then update deposit for new order).
798     /// @param newOrderHash New orderHash for deposit.
799     /// @param newOfferAmount New offer amount.
800     /// @param orderToBeCanceled Order to be canceled.
801     function updateOrder(
802         bytes32 newOrderHash,
803         uint256 newOfferAmount,
804         LibOrder.Order memory orderToBeCanceled
805     )
806         public
807         payable;
808 }
809 
810 
811 // File: contracts/exchange/mixins/MExchangeCore.sol
812 
813 /*
814 
815   Modified by Metaps Alpha Inc.
816 
817   Copyright 2018 ZeroEx Intl.
818 
819   Licensed under the Apache License, Version 2.0 (the "License");
820   you may not use this file except in compliance with the License.
821   You may obtain a copy of the License at
822 
823     http://www.apache.org/licenses/LICENSE-2.0
824 
825   Unless required by applicable law or agreed to in writing, software
826   distributed under the License is distributed on an "AS IS" BASIS,
827   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
828   See the License for the specific language governing permissions and
829   limitations under the License.
830 
831 */
832 
833 pragma solidity 0.5.16;
834 
835 
836 contract MExchangeCore is
837     IExchangeCore
838 {
839     // Fill event is emitted whenever an order is filled.
840     event Fill(
841         address indexed makerAddress,         // Address that created the order.      
842         address indexed feeRecipientAddress,  // Address that received fees.
843         address takerAddress,                 // Address that filled the order.
844         address senderAddress,                // Address that called the Exchange contract (msg.sender).
845         uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker. 
846         uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
847         uint256 makerFeePaid,                 // Amount of ZRX paid to feeRecipient by maker.
848         uint256 takerFeePaid,                 // Amount of ZRX paid to feeRecipient by taker.
849         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
850         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
851         bytes takerAssetData                  // Encoded data specific to takerAsset.
852     );
853 
854     // Cancel event is emitted whenever an individual order is cancelled.
855     event Cancel(
856         address indexed makerAddress,         // Address that created the order.      
857         address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.   
858         address senderAddress,                // Address that called the Exchange contract (msg.sender).
859         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
860         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
861         bytes takerAssetData                  // Encoded data specific to takerAsset.
862     );
863 
864     // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
865     event CancelUpTo(
866         address indexed makerAddress,         // Orders cancelled must have been created by this address.
867         address indexed senderAddress,        // Orders cancelled must have a `senderAddress` equal to this address.
868         uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.
869     );
870 
871     // miime: Transfer event is emitted whenever `transfer` is executed succesfully.
872     event Transfer(
873         address indexed toAddress,
874         uint256 indexed amount
875     );
876 
877     /// @dev Fills the input order.
878     /// @param order Order struct containing order specifications.
879     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
880     /// @param signature Proof that order has been created by maker.
881     /// @return Amounts filled and fees paid by maker and taker.
882     function fillOrderInternal(
883         LibOrder.Order memory order,
884         uint256 takerAssetFillAmount,
885         bytes memory signature
886     )
887         internal
888         returns (LibFillResults.FillResults memory fillResults);
889 
890     /// @dev After calling, the order can not be filled anymore.
891     /// @param order Order struct containing order specifications.
892     function cancelOrderInternal(LibOrder.Order memory order)
893         internal
894         returns (LibOrder.OrderInfo memory);
895 
896     /// @dev Updates state with results of a fill order.
897     /// @param order that was filled.
898     /// @param takerAddress Address of taker who filled the order.
899     /// @param orderTakerAssetFilledAmount Amount of order already filled.
900     /// @return fillResults Amounts filled and fees paid by maker and taker.
901     function updateFilledState(
902         LibOrder.Order memory order,
903         address takerAddress,
904         bytes32 orderHash,
905         uint256 orderTakerAssetFilledAmount,
906         LibFillResults.FillResults memory fillResults
907     )
908         internal;
909 
910     /// @dev Updates state with results of cancelling an order.
911     ///      State is only updated if the order is currently fillable.
912     ///      Otherwise, updating state would have no effect.
913     /// @param order that was cancelled.
914     /// @param orderHash Hash of order that was cancelled.
915     function updateCancelledState(
916         LibOrder.Order memory order,
917         bytes32 orderHash
918     )
919         internal;
920     
921     /// @dev Validates context for fillOrder. Succeeds or throws.
922     /// @param order to be filled.
923     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
924     /// @param takerAddress Address of order taker.
925     /// @param signature Proof that the orders was created by its maker.
926     function assertFillableOrder(
927         LibOrder.Order memory order,
928         LibOrder.OrderInfo memory orderInfo,
929         address takerAddress,
930         bytes memory signature
931     )
932         internal
933         view;
934     
935     /// @dev Validates context for fillOrder. Succeeds or throws.
936     /// @param order to be filled.
937     /// @param orderInfo Status, orderHash, and amount already filled of order.
938     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
939     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
940     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
941     function assertValidFill(
942         LibOrder.Order memory order,
943         LibOrder.OrderInfo memory orderInfo,
944         uint256 takerAssetFillAmount,
945         uint256 takerAssetFilledAmount,
946         uint256 makerAssetFilledAmount
947     )
948         internal
949         view;
950 
951     /// @dev Validates context for cancelOrder. Succeeds or throws.
952     /// @param order to be cancelled.
953     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
954     function assertValidCancel(
955         LibOrder.Order memory order,
956         LibOrder.OrderInfo memory orderInfo
957     )
958         internal
959         view;
960 
961     /// @dev Calculates amounts filled and fees paid by maker and taker.
962     /// @param order to be filled.
963     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
964     /// @return fillResults Amounts filled and fees paid by maker and taker.
965     function calculateFillResults(
966         LibOrder.Order memory order,
967         uint256 takerAssetFilledAmount
968     )
969         internal
970         pure
971         returns (LibFillResults.FillResults memory fillResults);
972 
973 }
974 
975 // File: contracts/exchange/interfaces/ISignatureValidator.sol
976 
977 /*
978 
979   Copyright 2018 ZeroEx Intl.
980 
981   Licensed under the Apache License, Version 2.0 (the "License");
982   you may not use this file except in compliance with the License.
983   You may obtain a copy of the License at
984 
985     http://www.apache.org/licenses/LICENSE-2.0
986 
987   Unless required by applicable law or agreed to in writing, software
988   distributed under the License is distributed on an "AS IS" BASIS,
989   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
990   See the License for the specific language governing permissions and
991   limitations under the License.
992 
993 */
994 
995 pragma solidity 0.5.16;
996 
997 
998 contract ISignatureValidator {
999 
1000     /// @dev Approves a hash on-chain using any valid signature type.
1001     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1002     /// @param signerAddress Address that should have signed the given hash.
1003     /// @param signature Proof that the hash has been signed by signer.
1004     function preSign(
1005         bytes32 hash,
1006         address signerAddress,
1007         bytes calldata signature
1008     )
1009         external;
1010     
1011     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1012     /// @param validatorAddress Address of Validator contract.
1013     /// @param approval Approval or disapproval of  Validator contract.
1014     function setSignatureValidatorApproval(
1015         address validatorAddress,
1016         bool approval
1017     )
1018         external;
1019 
1020     /// @dev Verifies that a signature is valid.
1021     /// @param hash Message hash that is signed.
1022     /// @param signerAddress Address of signer.
1023     /// @param signature Proof of signing.
1024     /// @return Validity of order signature.
1025     function isValidSignature(
1026         bytes32 hash,
1027         address signerAddress,
1028         bytes memory signature
1029     )
1030         public
1031         view
1032         returns (bool isValid);
1033 }
1034 
1035 // File: contracts/exchange/mixins/MSignatureValidator.sol
1036 
1037 /*
1038 
1039   Copyright 2018 ZeroEx Intl.
1040 
1041   Licensed under the Apache License, Version 2.0 (the "License");
1042   you may not use this file except in compliance with the License.
1043   You may obtain a copy of the License at
1044 
1045     http://www.apache.org/licenses/LICENSE-2.0
1046 
1047   Unless required by applicable law or agreed to in writing, software
1048   distributed under the License is distributed on an "AS IS" BASIS,
1049   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1050   See the License for the specific language governing permissions and
1051   limitations under the License.
1052 
1053 */
1054 
1055 pragma solidity 0.5.16;
1056 
1057 
1058 contract MSignatureValidator is
1059     ISignatureValidator
1060 {
1061     event SignatureValidatorApproval(
1062         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
1063         address indexed validatorAddress,  // Address of signature validator contract.
1064         bool approved                      // Approval or disapproval of validator contract.
1065     );
1066 
1067     // Allowed signature types.
1068     enum SignatureType {
1069         Illegal,         // 0x00, default value
1070         Invalid,         // 0x01
1071         EIP712,          // 0x02
1072         EthSign,         // 0x03
1073         Wallet,          // 0x04
1074         Validator,       // 0x05
1075         PreSigned,       // 0x06
1076         NSignatureTypes  // 0x07, number of signature types. Always leave at end.
1077     }
1078 
1079     /// @dev Verifies signature using logic defined by Wallet contract.
1080     /// @param hash Any 32 byte hash.
1081     /// @param walletAddress Address that should have signed the given hash
1082     ///                      and defines its own signature verification method.
1083     /// @param signature Proof that the hash has been signed by signer.
1084     /// @return True if the address recovered from the provided signature matches the input signer address.
1085     function isValidWalletSignature(
1086         bytes32 hash,
1087         address walletAddress,
1088         bytes memory signature
1089     )
1090         internal
1091         view
1092         returns (bool isValid);
1093 
1094     /// @dev Verifies signature using logic defined by Validator contract.
1095     /// @param validatorAddress Address of validator contract.
1096     /// @param hash Any 32 byte hash.
1097     /// @param signerAddress Address that should have signed the given hash.
1098     /// @param signature Proof that the hash has been signed by signer.
1099     /// @return True if the address recovered from the provided signature matches the input signer address.
1100     function isValidValidatorSignature(
1101         address validatorAddress,
1102         bytes32 hash,
1103         address signerAddress,
1104         bytes memory signature
1105     )
1106         internal
1107         view
1108         returns (bool isValid);
1109 }
1110 
1111 // File: contracts/exchange/interfaces/ITransactions.sol
1112 
1113 /*
1114 
1115   Copyright 2018 ZeroEx Intl.
1116 
1117   Licensed under the Apache License, Version 2.0 (the "License");
1118   you may not use this file except in compliance with the License.
1119   You may obtain a copy of the License at
1120 
1121     http://www.apache.org/licenses/LICENSE-2.0
1122 
1123   Unless required by applicable law or agreed to in writing, software
1124   distributed under the License is distributed on an "AS IS" BASIS,
1125   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1126   See the License for the specific language governing permissions and
1127   limitations under the License.
1128 
1129 */
1130 pragma solidity 0.5.16;
1131 
1132 
1133 contract ITransactions {
1134 
1135     /// @dev Executes an exchange method call in the context of signer.
1136     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1137     /// @param signerAddress Address of transaction signer.
1138     /// @param data AbiV2 encoded calldata.
1139     /// @param signature Proof of signer transaction by signer.
1140     function executeTransaction(
1141         uint256 salt,
1142         address payable signerAddress,
1143         bytes calldata data,
1144         bytes calldata signature
1145     )
1146         external;
1147 }
1148 
1149 // File: contracts/exchange/mixins/MTransactions.sol
1150 
1151 /*
1152 
1153   Copyright 2018 ZeroEx Intl.
1154 
1155   Licensed under the Apache License, Version 2.0 (the "License");
1156   you may not use this file except in compliance with the License.
1157   You may obtain a copy of the License at
1158 
1159     http://www.apache.org/licenses/LICENSE-2.0
1160 
1161   Unless required by applicable law or agreed to in writing, software
1162   distributed under the License is distributed on an "AS IS" BASIS,
1163   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1164   See the License for the specific language governing permissions and
1165   limitations under the License.
1166 
1167 */
1168 pragma solidity 0.5.16;
1169 
1170 
1171 contract MTransactions is
1172     ITransactions
1173 {
1174     // Hash for the EIP712 ZeroEx Transaction Schema
1175     bytes32 constant internal EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = keccak256(abi.encodePacked(
1176         "ZeroExTransaction(",
1177         "uint256 salt,",
1178         "address signerAddress,",
1179         "bytes data",
1180         ")"
1181     ));
1182 
1183     /// @dev Calculates EIP712 hash of the Transaction.
1184     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1185     /// @param signerAddress Address of transaction signer.
1186     /// @param data AbiV2 encoded calldata.
1187     /// @return EIP712 hash of the Transaction.
1188     function hashZeroExTransaction(
1189         uint256 salt,
1190         address signerAddress,
1191         bytes memory data
1192     )
1193         internal
1194         pure
1195         returns (bytes32 result);
1196 
1197     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
1198     ///      If calling a fill function, this address will represent the taker.
1199     ///      If calling a cancel function, this address will represent the maker.
1200     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
1201     ///         `msg.sender` if entry point is any other function.
1202     function getCurrentContextAddress()
1203         internal
1204         view
1205         returns (address payable);
1206 }
1207 
1208 // File: contracts/exchange/interfaces/IAssetProxyDispatcher.sol
1209 
1210 /*
1211 
1212   Copyright 2018 ZeroEx Intl.
1213 
1214   Licensed under the Apache License, Version 2.0 (the "License");
1215   you may not use this file except in compliance with the License.
1216   You may obtain a copy of the License at
1217 
1218     http://www.apache.org/licenses/LICENSE-2.0
1219 
1220   Unless required by applicable law or agreed to in writing, software
1221   distributed under the License is distributed on an "AS IS" BASIS,
1222   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1223   See the License for the specific language governing permissions and
1224   limitations under the License.
1225 
1226 */
1227 
1228 pragma solidity 0.5.16;
1229 
1230 
1231 contract IAssetProxyDispatcher {
1232 
1233     /// @dev Registers an asset proxy to its asset proxy id.
1234     ///      Once an asset proxy is registered, it cannot be unregistered.
1235     /// @param assetProxy Address of new asset proxy to register.
1236     function registerAssetProxy(address assetProxy)
1237         external;
1238 
1239     /// @dev Gets an asset proxy.
1240     /// @param assetProxyId Id of the asset proxy.
1241     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1242     function getAssetProxy(bytes4 assetProxyId)
1243         external
1244         view
1245         returns (address);
1246 }
1247 
1248 // File: contracts/exchange/mixins/MAssetProxyDispatcher.sol
1249 
1250 /*
1251 
1252   Copyright 2018 ZeroEx Intl.
1253 
1254   Licensed under the Apache License, Version 2.0 (the "License");
1255   you may not use this file except in compliance with the License.
1256   You may obtain a copy of the License at
1257 
1258     http://www.apache.org/licenses/LICENSE-2.0
1259 
1260   Unless required by applicable law or agreed to in writing, software
1261   distributed under the License is distributed on an "AS IS" BASIS,
1262   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1263   See the License for the specific language governing permissions and
1264   limitations under the License.
1265 
1266 */
1267 
1268 pragma solidity 0.5.16;
1269 
1270 
1271 contract MAssetProxyDispatcher is
1272     IAssetProxyDispatcher
1273 {
1274     // Logs registration of new asset proxy
1275     event AssetProxyRegistered(
1276         bytes4 id,              // Id of new registered AssetProxy.
1277         address assetProxy      // Address of new registered AssetProxy.
1278     );
1279 
1280     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
1281     /// @param assetData Byte array encoded for the asset.
1282     /// @param from Address to transfer token from.
1283     /// @param to Address to transfer token to.
1284     /// @param amount Amount of token to transfer.
1285     function dispatchTransferFrom(
1286         bytes memory assetData,
1287         address from,
1288         address payable to,
1289         uint256 amount
1290     )
1291         internal;
1292 }
1293 
1294 // File: @0x/contracts-utils/contracts/src/LibReentrancyGuardRichErrors.sol
1295 
1296 /*
1297 
1298   Copyright 2019 ZeroEx Intl.
1299 
1300   Licensed under the Apache License, Version 2.0 (the "License");
1301   you may not use this file except in compliance with the License.
1302   You may obtain a copy of the License at
1303 
1304     http://www.apache.org/licenses/LICENSE-2.0
1305 
1306   Unless required by applicable law or agreed to in writing, software
1307   distributed under the License is distributed on an "AS IS" BASIS,
1308   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1309   See the License for the specific language governing permissions and
1310   limitations under the License.
1311 
1312 */
1313 
1314 pragma solidity ^0.5.9;
1315 
1316 
1317 library LibReentrancyGuardRichErrors {
1318 
1319     // bytes4(keccak256("IllegalReentrancyError()"))
1320     bytes internal constant ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES =
1321         hex"0c3b823f";
1322 
1323     // solhint-disable func-name-mixedcase
1324     function IllegalReentrancyError()
1325         internal
1326         pure
1327         returns (bytes memory)
1328     {
1329         return ILLEGAL_REENTRANCY_ERROR_SELECTOR_BYTES;
1330     }
1331 }
1332 
1333 // File: @0x/contracts-utils/contracts/src/ReentrancyGuard.sol
1334 
1335 /*
1336 
1337   Copyright 2019 ZeroEx Intl.
1338 
1339   Licensed under the Apache License, Version 2.0 (the "License");
1340   you may not use this file except in compliance with the License.
1341   You may obtain a copy of the License at
1342 
1343     http://www.apache.org/licenses/LICENSE-2.0
1344 
1345   Unless required by applicable law or agreed to in writing, software
1346   distributed under the License is distributed on an "AS IS" BASIS,
1347   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1348   See the License for the specific language governing permissions and
1349   limitations under the License.
1350 
1351 */
1352 
1353 pragma solidity ^0.5.9;
1354 
1355 
1356 contract ReentrancyGuard {
1357 
1358     // Locked state of mutex.
1359     bool private _locked = false;
1360 
1361     /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
1362     ///      before function execution and unlocked after.
1363     modifier nonReentrant() {
1364         _lockMutexOrThrowIfAlreadyLocked();
1365         _;
1366         _unlockMutex();
1367     }
1368 
1369     function _lockMutexOrThrowIfAlreadyLocked()
1370         internal
1371     {
1372         // Ensure mutex is unlocked.
1373         if (_locked) {
1374             LibRichErrors.rrevert(
1375                 LibReentrancyGuardRichErrors.IllegalReentrancyError()
1376             );
1377         }
1378         // Lock mutex.
1379         _locked = true;
1380     }
1381 
1382     function _unlockMutex()
1383         internal
1384     {
1385         // Unlock mutex.
1386         _locked = false;
1387     }
1388 }
1389 
1390 // File: contracts/exchange/libs/Operational.sol
1391 
1392 /*
1393 
1394   Copyright 2019 Metaps Alpha Inc.
1395 
1396   Licensed under the Apache License, Version 2.0 (the "License");
1397   you may not use this file except in compliance with the License.
1398   You may obtain a copy of the License at
1399 
1400     http://www.apache.org/licenses/LICENSE-2.0
1401 
1402   Unless required by applicable law or agreed to in writing, software
1403   distributed under the License is distributed on an "AS IS" BASIS,
1404   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1405   See the License for the specific language governing permissions and
1406   limitations under the License.
1407 
1408 */
1409 
1410 pragma solidity 0.5.16;
1411 
1412 
1413 contract Operational
1414 {
1415     address public owner;
1416 
1417     address[] public withdrawOperators; // It is mainly responsible for the withdraw of deposit on cancelling.
1418     mapping (address => bool) public isWithdrawOperator;
1419 
1420     address[] public depositOperators; // It is mainly responsible for the deposit / transfer on dutch auction buying.
1421     mapping (address => bool) public isDepositOperator;
1422 
1423     event OwnershipTransferred(
1424         address indexed previousOwner,
1425         address indexed newOwner
1426     );
1427 
1428     event WithdrawOperatorAdded(
1429         address indexed target,
1430         address indexed caller
1431     );
1432 
1433     event WithdrawOperatorRemoved(
1434         address indexed target,
1435         address indexed caller
1436     );
1437 
1438     event DepositOperatorAdded(
1439         address indexed target,
1440         address indexed caller
1441     );
1442 
1443     event DepositOperatorRemoved(
1444         address indexed target,
1445         address indexed caller
1446     );
1447 
1448     constructor ()
1449         public
1450     {
1451         owner = msg.sender;
1452     }
1453 
1454     modifier onlyOwner() {
1455         require(
1456             msg.sender == owner,
1457             "ONLY_CONTRACT_OWNER"
1458         );
1459         _;
1460     }
1461 
1462     modifier onlyDepositOperator() {
1463         require(
1464             isDepositOperator[msg.sender],
1465             "SENDER_IS_NOT_DEPOSIT_OPERATOR"
1466         );
1467         _;
1468     }
1469 
1470     modifier withdrawable(address toAddress) {
1471         require(
1472             isWithdrawOperator[msg.sender] || toAddress == msg.sender,
1473             "SENDER_IS_NOT_WITHDRAWABLE"
1474         );
1475         _;
1476     }
1477 
1478     function transferOwnership(address newOwner)
1479         public
1480         onlyOwner
1481     {
1482         require(
1483             newOwner != address(0),
1484             "INVALID_OWNER"
1485         );
1486         emit OwnershipTransferred(owner, newOwner);
1487         owner = newOwner;
1488     }
1489 
1490     function addWithdrawOperator(address target)
1491         external
1492         onlyOwner
1493     {
1494         require(
1495             !isWithdrawOperator[target],
1496             "TARGET_IS_ALREADY_WITHDRAW_OPERATOR"
1497         );
1498 
1499         isWithdrawOperator[target] = true;
1500         withdrawOperators.push(target);
1501         emit WithdrawOperatorAdded(target, msg.sender);
1502     }
1503 
1504     function removeWithdrawOperator(address target)
1505         external
1506         onlyOwner
1507     {
1508         require(
1509             isWithdrawOperator[target],
1510             "TARGET_IS_NOT_WITHDRAW_OPERATOR"
1511         );
1512 
1513         delete isWithdrawOperator[target];
1514         for (uint256 i = 0; i < withdrawOperators.length; i++) {
1515             if (withdrawOperators[i] == target) {
1516                 withdrawOperators[i] = withdrawOperators[withdrawOperators.length - 1];
1517                 withdrawOperators.length -= 1;
1518                 break;
1519             }
1520         }
1521         emit WithdrawOperatorRemoved(target, msg.sender);
1522     }
1523 
1524     function addDepositOperator(address target)
1525         external
1526         onlyOwner
1527     {
1528         require(
1529             !isDepositOperator[target],
1530             "TARGET_IS_ALREADY_DEPOSIT_OPERATOR"
1531         );
1532 
1533         isDepositOperator[target] = true;
1534         depositOperators.push(target);
1535         emit DepositOperatorAdded(target, msg.sender);
1536     }
1537 
1538     function removeDepositOperator(address target)
1539         external
1540         onlyOwner
1541     {
1542         require(
1543             isDepositOperator[target],
1544             "TARGET_IS_NOT_DEPOSIT_OPERATOR"
1545         );
1546 
1547         delete isDepositOperator[target];
1548         for (uint256 i = 0; i < depositOperators.length; i++) {
1549             if (depositOperators[i] == target) {
1550                 depositOperators[i] = depositOperators[depositOperators.length - 1];
1551                 depositOperators.length -= 1;
1552                 break;
1553             }
1554         }
1555         emit DepositOperatorRemoved(target, msg.sender);
1556     }
1557 }
1558 
1559 // File: contracts/exchange/libs/DepositManager.sol
1560 
1561 /*
1562 
1563   Copyright 2019 Metaps Alpha Inc.
1564 
1565   Licensed under the Apache License, Version 2.0 (the "License");
1566   you may not use this file except in compliance with the License.
1567   You may obtain a copy of the License at
1568 
1569     http://www.apache.org/licenses/LICENSE-2.0
1570 
1571   Unless required by applicable law or agreed to in writing, software
1572   distributed under the License is distributed on an "AS IS" BASIS,
1573   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1574   See the License for the specific language governing permissions and
1575   limitations under the License.
1576 
1577 */
1578 
1579 pragma solidity 0.5.16;
1580 
1581 
1582 contract DepositManager is
1583     Operational,
1584     ReentrancyGuard
1585 {
1586     using LibSafeMath for uint256;
1587 
1588     // Mapping from user to deposit amount
1589     mapping (address => uint256) public depositAmount;
1590     // Mapping from order and user to deposit amount for withdraw
1591     mapping (bytes32 => mapping (address => uint256)) public orderToDepositAmount;
1592 
1593     // Deposit event is emitted whenever `deposit` is executed succesfully.
1594     event Deposit(
1595         bytes32 indexed orderHash,
1596         address indexed senderAddress,
1597         uint256 amount
1598     );
1599 
1600     // DepositChanged event is emitted whenever `updateOrder` is executed succesfully.
1601     event DepositChanged(
1602         bytes32 indexed newOrderHash,
1603         uint256 newAmount,
1604         bytes32 indexed oldOrderHash,
1605         uint256 oldAmount,
1606         address indexed senderAddress
1607     );
1608 
1609     // Withdraw event is emitted whenever `withdraw` (it may be called in `cancelOrder`) is executed succesfully.
1610     event Withdraw(
1611         bytes32 indexed orderHash,
1612         address indexed toAddress,
1613         uint256 amount
1614     );
1615 
1616     /// @dev Deposit for offer.
1617     /// @param orderHash orderHash of the order.
1618     function deposit(bytes32 orderHash)
1619         public
1620         payable
1621         nonReentrant
1622     {
1623         depositInternal(orderHash, msg.sender, msg.value);
1624     }
1625 
1626     /// @dev Withdraw deposit.
1627     /// @param orderHash orderHash of the order.
1628     /// @param toAddress Address to be refund.
1629     function withdraw(bytes32 orderHash, address payable toAddress)
1630         public
1631         nonReentrant
1632         withdrawable(toAddress)
1633     {
1634         withdrawInternal(orderHash, toAddress);
1635     }
1636 
1637     /// @dev Deposit by operator for dutch auction buying.
1638     /// @param orderHash orderHash of the order.
1639     /// @param toAddress Address of deposit target.
1640     function depositByOperator(bytes32 orderHash, address toAddress)
1641         public
1642         payable
1643         nonReentrant
1644         onlyDepositOperator
1645     {
1646         depositInternal(orderHash, toAddress, msg.value);
1647     }
1648 
1649     function depositInternal(bytes32 orderHash, address sender, uint256 amount)
1650         internal
1651     {
1652         depositAmount[sender] = depositAmount[sender].safeAdd(amount);
1653         orderToDepositAmount[orderHash][sender] = orderToDepositAmount[orderHash][sender].safeAdd(amount);
1654         emit Deposit(orderHash, sender, amount);
1655     }
1656 
1657     function withdrawInternal(bytes32 orderHash, address payable toAddress)
1658         internal
1659     {
1660         if (orderToDepositAmount[orderHash][toAddress] > 0) {
1661             uint256 amount = orderToDepositAmount[orderHash][toAddress];
1662             depositAmount[toAddress] = depositAmount[toAddress].safeSub(amount);
1663             delete orderToDepositAmount[orderHash][toAddress];
1664             toAddress.transfer(amount);
1665             emit Withdraw(orderHash, toAddress, amount);
1666         }
1667     }
1668 
1669     function changeDeposit(
1670         bytes32 newOrderHash,
1671         uint256 newOfferAmount,
1672         bytes32 oldOrderHash,
1673         uint256 oldOfferAmount,
1674         address payable sender
1675     )
1676         internal
1677     {
1678         if (msg.value > 0) {
1679             depositAmount[sender] = depositAmount[sender].safeAdd(msg.value);
1680             orderToDepositAmount[newOrderHash][sender] = orderToDepositAmount[newOrderHash][sender].safeAdd(msg.value);
1681         }
1682         uint256 oldOrderToDepositAmount = orderToDepositAmount[oldOrderHash][sender];
1683         moveDeposit(oldOrderHash, newOrderHash, sender);
1684         if (oldOrderToDepositAmount > newOfferAmount) {
1685             uint256 refundAmount = orderToDepositAmount[newOrderHash][sender].safeSub(newOfferAmount);
1686             orderToDepositAmount[newOrderHash][sender] = orderToDepositAmount[newOrderHash][sender].safeSub(refundAmount);
1687             depositAmount[sender] = depositAmount[sender].safeSub(refundAmount);
1688             sender.transfer(refundAmount);
1689         }
1690         emit DepositChanged(newOrderHash, newOfferAmount, oldOrderHash, oldOfferAmount, sender);
1691     }
1692 
1693     function moveDeposit(
1694         bytes32 fromOrderHash,
1695         bytes32 toOrderHash,
1696         address sender
1697     )
1698         internal
1699     {
1700         uint256 amount = orderToDepositAmount[fromOrderHash][sender];
1701         delete orderToDepositAmount[fromOrderHash][sender];
1702         orderToDepositAmount[toOrderHash][sender] = orderToDepositAmount[toOrderHash][sender].safeAdd(amount);
1703     }
1704 
1705     function deductOrderToDepositAmount(
1706         bytes32 orderHash,
1707         address target,
1708         uint256 amount
1709     )
1710         internal
1711     {
1712         orderToDepositAmount[orderHash][target] = orderToDepositAmount[orderHash][target].safeSub(amount);
1713     }
1714 }
1715 
1716 // File: contracts/exchange/libs/LibConstants.sol
1717 
1718 /*
1719 
1720   Copyright 2019 Metaps Alpha Inc.
1721 
1722   Licensed under the Apache License, Version 2.0 (the "License");
1723   you may not use this file except in compliance with the License.
1724   You may obtain a copy of the License at
1725 
1726     http://www.apache.org/licenses/LICENSE-2.0
1727 
1728   Unless required by applicable law or agreed to in writing, software
1729   distributed under the License is distributed on an "AS IS" BASIS,
1730   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1731   See the License for the specific language governing permissions and
1732   limitations under the License.
1733 
1734 */
1735 
1736 pragma solidity 0.5.16;
1737 
1738 
1739 // solhint-disable max-line-length
1740 contract LibConstants {
1741     // miime - The special asset data for ETH
1742     // ETH_ASSET_DATA = bytes4(keccak256("ERC20Token(address)")); + 0 padding
1743     //                = 0xf47261b00000000000000000000000000000000000000000000000000000000000000000
1744     bytes constant public ETH_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00";
1745     bytes32 constant public KECCAK256_ETH_ASSET_DATA = keccak256(ETH_ASSET_DATA);
1746     uint256 constant public TRANSFER_GAS_LIMIT = 300000; // Gas limit for ETH sending
1747 }
1748 // solhint-enable max-line-length
1749 
1750 // File: contracts/exchange/MixinExchangeCore.sol
1751 
1752 /*
1753 
1754   Modified by Metaps Alpha Inc.
1755 
1756   Copyright 2018 ZeroEx Intl.
1757 
1758   Licensed under the Apache License, Version 2.0 (the "License");
1759   you may not use this file except in compliance with the License.
1760   You may obtain a copy of the License at
1761 
1762     http://www.apache.org/licenses/LICENSE-2.0
1763 
1764   Unless required by applicable law or agreed to in writing, software
1765   distributed under the License is distributed on an "AS IS" BASIS,
1766   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1767   See the License for the specific language governing permissions and
1768   limitations under the License.
1769 
1770 */
1771 
1772 pragma solidity 0.5.16;
1773 
1774 
1775 contract MixinExchangeCore is
1776     DepositManager,
1777     LibConstants,
1778     LibMath,
1779     LibOrder,
1780     LibFillResults,
1781     MAssetProxyDispatcher,
1782     MExchangeCore,
1783     MSignatureValidator,
1784     MTransactions
1785 {
1786     // Mapping of orderHash => amount of takerAsset already bought by maker
1787     mapping (bytes32 => uint256) public filled;
1788 
1789     // Mapping of orderHash => cancelled
1790     mapping (bytes32 => bool) public cancelled;
1791 
1792     // Mapping of makerAddress => senderAddress => lowest salt an order can have in order to be fillable
1793     // Orders with specified senderAddress and with a salt less than their epoch are considered cancelled
1794     mapping (address => mapping (address => uint256)) public orderEpoch;
1795 
1796     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1797     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1798     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1799     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1800         external
1801         nonReentrant
1802     {
1803         address makerAddress = getCurrentContextAddress();
1804         // If this function is called via `executeTransaction`, we only update the orderEpoch for the makerAddress/msg.sender combination.
1805         // This allows external filter contracts to add rules to how orders are cancelled via this function.
1806         address senderAddress = makerAddress == msg.sender ? address(0) : msg.sender;
1807 
1808         // orderEpoch is initialized to 0, so to cancelUpTo we need salt + 1
1809         uint256 newOrderEpoch = targetOrderEpoch + 1;
1810         uint256 oldOrderEpoch = orderEpoch[makerAddress][senderAddress];
1811 
1812         // Ensure orderEpoch is monotonically increasing
1813         require(
1814             newOrderEpoch > oldOrderEpoch,
1815             "INVALID_NEW_ORDER_EPOCH"
1816         );
1817 
1818         // Update orderEpoch
1819         orderEpoch[makerAddress][senderAddress] = newOrderEpoch;
1820         emit CancelUpTo(
1821             makerAddress,
1822             senderAddress,
1823             newOrderEpoch
1824         );
1825     }
1826 
1827     /// @dev Fills the input order.
1828     /// @param order Order struct containing order specifications.
1829     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1830     /// @param signature Proof that order has been created by maker.
1831     /// @return Amounts filled and fees paid by maker and taker.
1832     function fillOrder(
1833         Order memory order,
1834         uint256 takerAssetFillAmount,
1835         bytes memory signature
1836     )
1837         public
1838         payable
1839         nonReentrant
1840         returns (FillResults memory fillResults)
1841     {
1842         fillResults = fillOrderInternal(
1843             order,
1844             takerAssetFillAmount,
1845             signature
1846         );
1847         return fillResults;
1848     }
1849 
1850     /// @dev After calling, the order can not be filled anymore.
1851     ///      Throws if order is invalid or sender does not have permission to cancel.
1852     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
1853     function cancelOrder(Order memory order)
1854         public
1855         nonReentrant
1856     {
1857         OrderInfo memory orderInfo = cancelOrderInternal(order);
1858         withdrawInternal(orderInfo.orderHash, msg.sender);
1859     }
1860 
1861     /// @dev Gets information about an order: status, hash, and amount filled.
1862     /// @param order Order to gather information on.
1863     /// @return OrderInfo Information about the order and its state.
1864     ///         See LibOrder.OrderInfo for a complete description.
1865     function getOrderInfo(Order memory order)
1866         public
1867         view
1868         returns (OrderInfo memory orderInfo)
1869     {
1870         // Compute the order hash
1871         orderInfo.orderHash = getOrderHash(order);
1872 
1873         // Fetch filled amount
1874         orderInfo.orderTakerAssetFilledAmount = filled[orderInfo.orderHash];
1875 
1876         // If order.makerAssetAmount is zero, we also reject the order.
1877         // While the Exchange contract handles them correctly, they create
1878         // edge cases in the supporting infrastructure because they have
1879         // an 'infinite' price when computed by a simple division.
1880         if (order.makerAssetAmount == 0) {
1881             orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_ASSET_AMOUNT);
1882             return orderInfo;
1883         }
1884 
1885         // If order.takerAssetAmount is zero, then the order will always
1886         // be considered filled because 0 == takerAssetAmount == orderTakerAssetFilledAmount
1887         // Instead of distinguishing between unfilled and filled zero taker
1888         // amount orders, we choose not to support them.
1889         if (order.takerAssetAmount == 0) {
1890             orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_ASSET_AMOUNT);
1891             return orderInfo;
1892         }
1893 
1894         // Validate order availability
1895         if (orderInfo.orderTakerAssetFilledAmount >= order.takerAssetAmount) {
1896             orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
1897             return orderInfo;
1898         }
1899 
1900         // Validate order expiration
1901         // solhint-disable-next-line not-rely-on-time
1902         if (block.timestamp >= order.expirationTimeSeconds) {
1903             orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
1904             return orderInfo;
1905         }
1906 
1907         // Check if order has been cancelled
1908         if (cancelled[orderInfo.orderHash]) {
1909             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
1910             return orderInfo;
1911         }
1912         if (orderEpoch[order.makerAddress][order.senderAddress] > order.salt) {
1913             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
1914             return orderInfo;
1915         }
1916 
1917         // All other statuses are ruled out: order is Fillable
1918         orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
1919         return orderInfo;
1920     }
1921 
1922     /// @dev miime - Cancel order and then update deposit for new order.
1923     /// @param newOrderHash New orderHash for deposit.
1924     /// @param newOfferAmount New offer amount.
1925     /// @param orderToBeCanceled Order to be canceled.
1926     function updateOrder(
1927         bytes32 newOrderHash,
1928         uint256 newOfferAmount,
1929         Order memory orderToBeCanceled
1930     )
1931         public
1932         payable
1933         nonReentrant
1934     {
1935         OrderInfo memory orderInfo = cancelOrderInternal(orderToBeCanceled);
1936         uint256 oldOfferAmount = orderToBeCanceled.makerAssetAmount.safeAdd(orderToBeCanceled.makerFee);
1937         changeDeposit(newOrderHash, newOfferAmount, orderInfo.orderHash, oldOfferAmount, msg.sender);
1938     }
1939 
1940     /// @dev Fills the input order.
1941     /// @param order Order struct containing order specifications.
1942     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1943     /// @param signature Proof that order has been created by maker.
1944     /// @return Amounts filled and fees paid by maker and taker.
1945     function fillOrderInternal(
1946         Order memory order,
1947         uint256 takerAssetFillAmount,
1948         bytes memory signature
1949     )
1950         internal
1951         returns (FillResults memory fillResults)
1952     {
1953         // Fetch order info
1954         OrderInfo memory orderInfo = getOrderInfo(order);
1955 
1956         // Fetch taker address
1957         address payable takerAddress = getCurrentContextAddress();
1958 
1959         // miime: Deposit the sending ETH on buying
1960         // Hash calculation is expensive, so it is implemented here.
1961         if (msg.value > 0) {
1962             depositInternal(orderInfo.orderHash, takerAddress, msg.value);
1963         }
1964 
1965         // Assert that the order is fillable by taker
1966         assertFillableOrder(
1967             order,
1968             orderInfo,
1969             takerAddress,
1970             signature
1971         );
1972 
1973         // Get amount of takerAsset to fill
1974         uint256 remainingTakerAssetAmount = order.takerAssetAmount.safeSub(orderInfo.orderTakerAssetFilledAmount);
1975         uint256 takerAssetFilledAmount = LibSafeMath.min256(takerAssetFillAmount, remainingTakerAssetAmount);
1976 
1977         // Compute proportional fill amounts
1978         fillResults = calculateFillResults(order, takerAssetFilledAmount);
1979 
1980         // Validate context
1981         assertValidFill(
1982             order,
1983             orderInfo,
1984             takerAssetFillAmount,
1985             takerAssetFilledAmount,
1986             fillResults.makerAssetFilledAmount
1987         );
1988 
1989         // Update exchange internal state
1990         updateFilledState(
1991             order,
1992             takerAddress,
1993             orderInfo.orderHash,
1994             orderInfo.orderTakerAssetFilledAmount,
1995             fillResults
1996         );
1997 
1998         // Settle order
1999         settleOrder(
2000             order,
2001             takerAddress,
2002             fillResults
2003         );
2004 
2005         // miime: Deduct deposit of this order
2006         if (keccak256(order.makerAssetData) == KECCAK256_ETH_ASSET_DATA) {
2007             deductOrderToDepositAmount(
2008                 orderInfo.orderHash,
2009                 order.makerAddress,
2010                 fillResults.makerAssetFilledAmount.safeAdd(fillResults.makerFeePaid)
2011             );
2012         }
2013         if (keccak256(order.takerAssetData) == KECCAK256_ETH_ASSET_DATA) {
2014             deductOrderToDepositAmount(
2015                 orderInfo.orderHash,
2016                 takerAddress,
2017                 fillResults.takerAssetFilledAmount.safeAdd(fillResults.takerFeePaid)
2018             );
2019         }
2020 
2021         return fillResults;
2022     }
2023 
2024     /// @dev After calling, the order can not be filled anymore.
2025     ///      Throws if order is invalid or sender does not have permission to cancel.
2026     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
2027     /// @return orderInfo
2028     function cancelOrderInternal(Order memory order)
2029         internal
2030         returns (OrderInfo memory)
2031     {
2032         // Fetch current order status
2033         OrderInfo memory orderInfo = getOrderInfo(order);
2034 
2035         // Validate context
2036         assertValidCancel(order, orderInfo);
2037 
2038         // Perform cancel
2039         updateCancelledState(order, orderInfo.orderHash);
2040 
2041         return orderInfo;
2042     }
2043 
2044     /// @dev Updates state with results of a fill order.
2045     /// @param order that was filled.
2046     /// @param takerAddress Address of taker who filled the order.
2047     /// @param orderTakerAssetFilledAmount Amount of order already filled.
2048     function updateFilledState(
2049         Order memory order,
2050         address takerAddress,
2051         bytes32 orderHash,
2052         uint256 orderTakerAssetFilledAmount,
2053         FillResults memory fillResults
2054     )
2055         internal
2056     {
2057         // Update state
2058         filled[orderHash] = orderTakerAssetFilledAmount.safeAdd(fillResults.takerAssetFilledAmount);
2059 
2060         // Log order
2061         emit Fill(
2062             order.makerAddress,
2063             order.feeRecipientAddress,
2064             takerAddress,
2065             msg.sender,
2066             fillResults.makerAssetFilledAmount,
2067             fillResults.takerAssetFilledAmount,
2068             fillResults.makerFeePaid,
2069             fillResults.takerFeePaid,
2070             orderHash,
2071             order.makerAssetData,
2072             order.takerAssetData
2073         );
2074     }
2075 
2076     /// @dev Updates state with results of cancelling an order.
2077     ///      State is only updated if the order is currently fillable.
2078     ///      Otherwise, updating state would have no effect.
2079     /// @param order that was cancelled.
2080     /// @param orderHash Hash of order that was cancelled.
2081     function updateCancelledState(
2082         Order memory order,
2083         bytes32 orderHash
2084     )
2085         internal
2086     {
2087         // Perform cancel
2088         cancelled[orderHash] = true;
2089 
2090         // Log cancel
2091         emit Cancel(
2092             order.makerAddress,
2093             order.feeRecipientAddress,
2094             msg.sender,
2095             orderHash,
2096             order.makerAssetData,
2097             order.takerAssetData
2098         );
2099     }
2100 
2101     /// @dev Validates context for fillOrder. Succeeds or throws.
2102     /// @param order to be filled.
2103     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2104     /// @param takerAddress Address of order taker.
2105     /// @param signature Proof that the orders was created by its maker.
2106     function assertFillableOrder(
2107         Order memory order,
2108         OrderInfo memory orderInfo,
2109         address takerAddress,
2110         bytes memory signature
2111     )
2112         internal
2113         view
2114     {
2115         // An order can only be filled if its status is FILLABLE.
2116         require(
2117             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2118             "ORDER_UNFILLABLE"
2119         );
2120 
2121         // Validate sender is allowed to fill this order
2122         if (order.senderAddress != address(0)) {
2123             require(
2124                 order.senderAddress == msg.sender,
2125                 "INVALID_SENDER"
2126             );
2127         }
2128 
2129         // Validate taker is allowed to fill this order
2130         if (order.takerAddress != address(0)) {
2131             require(
2132                 order.takerAddress == takerAddress,
2133                 "INVALID_TAKER"
2134             );
2135         }
2136 
2137         // Validate Maker signature (check only if first time seen)
2138         if (orderInfo.orderTakerAssetFilledAmount == 0) {
2139             require(
2140                 isValidSignature(
2141                     orderInfo.orderHash,
2142                     order.makerAddress,
2143                     signature
2144                 ),
2145                 "INVALID_ORDER_SIGNATURE"
2146             );
2147         }
2148     }
2149 
2150     /// @dev Validates context for fillOrder. Succeeds or throws.
2151     /// @param order to be filled.
2152     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2153     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
2154     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2155     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
2156     function assertValidFill(
2157         Order memory order,
2158         OrderInfo memory orderInfo,
2159         uint256 takerAssetFillAmount,  // TODO: use FillResults
2160         uint256 takerAssetFilledAmount,
2161         uint256 makerAssetFilledAmount
2162     )
2163         internal
2164         view
2165     {
2166         // Revert if fill amount is invalid
2167         // TODO: reconsider necessity for v2.1
2168         require(
2169             takerAssetFillAmount != 0,
2170             "INVALID_TAKER_AMOUNT"
2171         );
2172 
2173         // Make sure taker does not pay more than desired amount
2174         // NOTE: This assertion should never fail, it is here
2175         //       as an extra defence against potential bugs.
2176         require(
2177             takerAssetFilledAmount <= takerAssetFillAmount,
2178             "TAKER_OVERPAY"
2179         );
2180 
2181         // Make sure order is not overfilled
2182         // NOTE: This assertion should never fail, it is here
2183         //       as an extra defence against potential bugs.
2184         require(
2185             orderInfo.orderTakerAssetFilledAmount.safeAdd(takerAssetFilledAmount) <= order.takerAssetAmount,
2186             "ORDER_OVERFILL"
2187         );
2188 
2189         // Make sure order is filled at acceptable price.
2190         // The order has an implied price from the makers perspective:
2191         //    order price = order.makerAssetAmount / order.takerAssetAmount
2192         // i.e. the number of makerAsset maker is paying per takerAsset. The
2193         // maker is guaranteed to get this price or a better (lower) one. The
2194         // actual price maker is getting in this fill is:
2195         //    fill price = makerAssetFilledAmount / takerAssetFilledAmount
2196         // We need `fill price <= order price` for the fill to be fair to maker.
2197         // This amounts to:
2198         //     makerAssetFilledAmount        order.makerAssetAmount
2199         //    ------------------------  <=  -----------------------
2200         //     takerAssetFilledAmount        order.takerAssetAmount
2201         // or, equivalently:
2202         //     makerAssetFilledAmount * order.takerAssetAmount <=
2203         //     order.makerAssetAmount * takerAssetFilledAmount
2204         // NOTE: This assertion should never fail, it is here
2205         //       as an extra defence against potential bugs.
2206         require(
2207             makerAssetFilledAmount.safeMul(order.takerAssetAmount) <=
2208             order.makerAssetAmount.safeMul(takerAssetFilledAmount),
2209             "INVALID_FILL_PRICE"
2210         );
2211     }
2212 
2213     /// @dev Validates context for cancelOrder. Succeeds or throws.
2214     /// @param order to be cancelled.
2215     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2216     function assertValidCancel(
2217         Order memory order,
2218         OrderInfo memory orderInfo
2219     )
2220         internal
2221         view
2222     {
2223         // Ensure order is valid
2224         // An order can only be cancelled if its status is FILLABLE.
2225         require(
2226             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2227             "ORDER_UNFILLABLE"
2228         );
2229 
2230         // Validate sender is allowed to cancel this order
2231         if (order.senderAddress != address(0)) {
2232             require(
2233                 order.senderAddress == msg.sender,
2234                 "INVALID_SENDER"
2235             );
2236         }
2237 
2238         // Validate transaction signed by maker
2239         address makerAddress = getCurrentContextAddress();
2240         require(
2241             order.makerAddress == makerAddress,
2242             "INVALID_MAKER"
2243         );
2244     }
2245 
2246     /// @dev Calculates amounts filled and fees paid by maker and taker.
2247     /// @param order to be filled.
2248     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2249     /// @return fillResults Amounts filled and fees paid by maker and taker.
2250     function calculateFillResults(
2251         Order memory order,
2252         uint256 takerAssetFilledAmount
2253     )
2254         internal
2255         pure
2256         returns (FillResults memory fillResults)
2257     {
2258         // Compute proportional transfer amounts
2259         fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
2260         fillResults.makerAssetFilledAmount = safeGetPartialAmountFloor(
2261             takerAssetFilledAmount,
2262             order.takerAssetAmount,
2263             order.makerAssetAmount
2264         );
2265         fillResults.makerFeePaid = safeGetPartialAmountFloor(
2266             fillResults.makerAssetFilledAmount,
2267             order.makerAssetAmount,
2268             order.makerFee
2269         );
2270         fillResults.takerFeePaid = safeGetPartialAmountFloor(
2271             takerAssetFilledAmount,
2272             order.takerAssetAmount,
2273             order.takerFee
2274         );
2275 
2276         return fillResults;
2277     }
2278 
2279     /// @dev Settles an order by transferring assets between counterparties.
2280     /// @param order Order struct containing order specifications.
2281     /// @param takerAddress Address selling takerAsset and buying makerAsset.
2282     /// @param fillResults Amounts to be filled and fees paid by maker and taker.
2283     function settleOrder(
2284         LibOrder.Order memory order,
2285         address payable takerAddress,
2286         LibFillResults.FillResults memory fillResults
2287     )
2288         private
2289     {
2290         bytes memory ethAssetData = ETH_ASSET_DATA;
2291         dispatchTransferFrom(
2292             order.makerAssetData,
2293             order.makerAddress,
2294             takerAddress,
2295             fillResults.makerAssetFilledAmount
2296         );
2297         dispatchTransferFrom(
2298             order.takerAssetData,
2299             takerAddress,
2300             order.makerAddress,
2301             fillResults.takerAssetFilledAmount
2302         );
2303         dispatchTransferFrom(
2304             ethAssetData,
2305             order.makerAddress,
2306             order.feeRecipientAddress,
2307             fillResults.makerFeePaid
2308         );
2309         dispatchTransferFrom(
2310             ethAssetData,
2311             takerAddress,
2312             order.feeRecipientAddress,
2313             fillResults.takerFeePaid
2314         );
2315     }
2316 }
2317 
2318 // File: @0x/contracts-utils/contracts/src/LibBytesRichErrors.sol
2319 
2320 /*
2321 
2322   Copyright 2019 ZeroEx Intl.
2323 
2324   Licensed under the Apache License, Version 2.0 (the "License");
2325   you may not use this file except in compliance with the License.
2326   You may obtain a copy of the License at
2327 
2328     http://www.apache.org/licenses/LICENSE-2.0
2329 
2330   Unless required by applicable law or agreed to in writing, software
2331   distributed under the License is distributed on an "AS IS" BASIS,
2332   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2333   See the License for the specific language governing permissions and
2334   limitations under the License.
2335 
2336 */
2337 
2338 pragma solidity ^0.5.9;
2339 
2340 
2341 library LibBytesRichErrors {
2342 
2343     enum InvalidByteOperationErrorCodes {
2344         FromLessThanOrEqualsToRequired,
2345         ToLessThanOrEqualsLengthRequired,
2346         LengthGreaterThanZeroRequired,
2347         LengthGreaterThanOrEqualsFourRequired,
2348         LengthGreaterThanOrEqualsTwentyRequired,
2349         LengthGreaterThanOrEqualsThirtyTwoRequired,
2350         LengthGreaterThanOrEqualsNestedBytesLengthRequired,
2351         DestinationLengthGreaterThanOrEqualSourceLengthRequired
2352     }
2353 
2354     // bytes4(keccak256("InvalidByteOperationError(uint8,uint256,uint256)"))
2355     bytes4 internal constant INVALID_BYTE_OPERATION_ERROR_SELECTOR =
2356         0x28006595;
2357 
2358     // solhint-disable func-name-mixedcase
2359     function InvalidByteOperationError(
2360         InvalidByteOperationErrorCodes errorCode,
2361         uint256 offset,
2362         uint256 required
2363     )
2364         internal
2365         pure
2366         returns (bytes memory)
2367     {
2368         return abi.encodeWithSelector(
2369             INVALID_BYTE_OPERATION_ERROR_SELECTOR,
2370             errorCode,
2371             offset,
2372             required
2373         );
2374     }
2375 }
2376 
2377 // File: @0x/contracts-utils/contracts/src/LibBytes.sol
2378 
2379 /*
2380 
2381   Copyright 2019 ZeroEx Intl.
2382 
2383   Licensed under the Apache License, Version 2.0 (the "License");
2384   you may not use this file except in compliance with the License.
2385   You may obtain a copy of the License at
2386 
2387     http://www.apache.org/licenses/LICENSE-2.0
2388 
2389   Unless required by applicable law or agreed to in writing, software
2390   distributed under the License is distributed on an "AS IS" BASIS,
2391   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2392   See the License for the specific language governing permissions and
2393   limitations under the License.
2394 
2395 */
2396 
2397 pragma solidity ^0.5.9;
2398 
2399 
2400 library LibBytes {
2401 
2402     using LibBytes for bytes;
2403 
2404     /// @dev Gets the memory address for a byte array.
2405     /// @param input Byte array to lookup.
2406     /// @return memoryAddress Memory address of byte array. This
2407     ///         points to the header of the byte array which contains
2408     ///         the length.
2409     function rawAddress(bytes memory input)
2410         internal
2411         pure
2412         returns (uint256 memoryAddress)
2413     {
2414         assembly {
2415             memoryAddress := input
2416         }
2417         return memoryAddress;
2418     }
2419 
2420     /// @dev Gets the memory address for the contents of a byte array.
2421     /// @param input Byte array to lookup.
2422     /// @return memoryAddress Memory address of the contents of the byte array.
2423     function contentAddress(bytes memory input)
2424         internal
2425         pure
2426         returns (uint256 memoryAddress)
2427     {
2428         assembly {
2429             memoryAddress := add(input, 32)
2430         }
2431         return memoryAddress;
2432     }
2433 
2434     /// @dev Copies `length` bytes from memory location `source` to `dest`.
2435     /// @param dest memory address to copy bytes to.
2436     /// @param source memory address to copy bytes from.
2437     /// @param length number of bytes to copy.
2438     function memCopy(
2439         uint256 dest,
2440         uint256 source,
2441         uint256 length
2442     )
2443         internal
2444         pure
2445     {
2446         if (length < 32) {
2447             // Handle a partial word by reading destination and masking
2448             // off the bits we are interested in.
2449             // This correctly handles overlap, zero lengths and source == dest
2450             assembly {
2451                 let mask := sub(exp(256, sub(32, length)), 1)
2452                 let s := and(mload(source), not(mask))
2453                 let d := and(mload(dest), mask)
2454                 mstore(dest, or(s, d))
2455             }
2456         } else {
2457             // Skip the O(length) loop when source == dest.
2458             if (source == dest) {
2459                 return;
2460             }
2461 
2462             // For large copies we copy whole words at a time. The final
2463             // word is aligned to the end of the range (instead of after the
2464             // previous) to handle partial words. So a copy will look like this:
2465             //
2466             //  ####
2467             //      ####
2468             //          ####
2469             //            ####
2470             //
2471             // We handle overlap in the source and destination range by
2472             // changing the copying direction. This prevents us from
2473             // overwriting parts of source that we still need to copy.
2474             //
2475             // This correctly handles source == dest
2476             //
2477             if (source > dest) {
2478                 assembly {
2479                     // We subtract 32 from `sEnd` and `dEnd` because it
2480                     // is easier to compare with in the loop, and these
2481                     // are also the addresses we need for copying the
2482                     // last bytes.
2483                     length := sub(length, 32)
2484                     let sEnd := add(source, length)
2485                     let dEnd := add(dest, length)
2486 
2487                     // Remember the last 32 bytes of source
2488                     // This needs to be done here and not after the loop
2489                     // because we may have overwritten the last bytes in
2490                     // source already due to overlap.
2491                     let last := mload(sEnd)
2492 
2493                     // Copy whole words front to back
2494                     // Note: the first check is always true,
2495                     // this could have been a do-while loop.
2496                     // solhint-disable-next-line no-empty-blocks
2497                     for {} lt(source, sEnd) {} {
2498                         mstore(dest, mload(source))
2499                         source := add(source, 32)
2500                         dest := add(dest, 32)
2501                     }
2502 
2503                     // Write the last 32 bytes
2504                     mstore(dEnd, last)
2505                 }
2506             } else {
2507                 assembly {
2508                     // We subtract 32 from `sEnd` and `dEnd` because those
2509                     // are the starting points when copying a word at the end.
2510                     length := sub(length, 32)
2511                     let sEnd := add(source, length)
2512                     let dEnd := add(dest, length)
2513 
2514                     // Remember the first 32 bytes of source
2515                     // This needs to be done here and not after the loop
2516                     // because we may have overwritten the first bytes in
2517                     // source already due to overlap.
2518                     let first := mload(source)
2519 
2520                     // Copy whole words back to front
2521                     // We use a signed comparisson here to allow dEnd to become
2522                     // negative (happens when source and dest < 32). Valid
2523                     // addresses in local memory will never be larger than
2524                     // 2**255, so they can be safely re-interpreted as signed.
2525                     // Note: the first check is always true,
2526                     // this could have been a do-while loop.
2527                     // solhint-disable-next-line no-empty-blocks
2528                     for {} slt(dest, dEnd) {} {
2529                         mstore(dEnd, mload(sEnd))
2530                         sEnd := sub(sEnd, 32)
2531                         dEnd := sub(dEnd, 32)
2532                     }
2533 
2534                     // Write the first 32 bytes
2535                     mstore(dest, first)
2536                 }
2537             }
2538         }
2539     }
2540 
2541     /// @dev Returns a slices from a byte array.
2542     /// @param b The byte array to take a slice from.
2543     /// @param from The starting index for the slice (inclusive).
2544     /// @param to The final index for the slice (exclusive).
2545     /// @return result The slice containing bytes at indices [from, to)
2546     function slice(
2547         bytes memory b,
2548         uint256 from,
2549         uint256 to
2550     )
2551         internal
2552         pure
2553         returns (bytes memory result)
2554     {
2555         // Ensure that the from and to positions are valid positions for a slice within
2556         // the byte array that is being used.
2557         if (from > to) {
2558             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2559                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
2560                 from,
2561                 to
2562             ));
2563         }
2564         if (to > b.length) {
2565             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2566                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
2567                 to,
2568                 b.length
2569             ));
2570         }
2571 
2572         // Create a new bytes structure and copy contents
2573         result = new bytes(to - from);
2574         memCopy(
2575             result.contentAddress(),
2576             b.contentAddress() + from,
2577             result.length
2578         );
2579         return result;
2580     }
2581 
2582     /// @dev Returns a slice from a byte array without preserving the input.
2583     /// @param b The byte array to take a slice from. Will be destroyed in the process.
2584     /// @param from The starting index for the slice (inclusive).
2585     /// @param to The final index for the slice (exclusive).
2586     /// @return result The slice containing bytes at indices [from, to)
2587     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
2588     function sliceDestructive(
2589         bytes memory b,
2590         uint256 from,
2591         uint256 to
2592     )
2593         internal
2594         pure
2595         returns (bytes memory result)
2596     {
2597         // Ensure that the from and to positions are valid positions for a slice within
2598         // the byte array that is being used.
2599         if (from > to) {
2600             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2601                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
2602                 from,
2603                 to
2604             ));
2605         }
2606         if (to > b.length) {
2607             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2608                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
2609                 to,
2610                 b.length
2611             ));
2612         }
2613 
2614         // Create a new bytes structure around [from, to) in-place.
2615         assembly {
2616             result := add(b, from)
2617             mstore(result, sub(to, from))
2618         }
2619         return result;
2620     }
2621 
2622     /// @dev Pops the last byte off of a byte array by modifying its length.
2623     /// @param b Byte array that will be modified.
2624     /// @return The byte that was popped off.
2625     function popLastByte(bytes memory b)
2626         internal
2627         pure
2628         returns (bytes1 result)
2629     {
2630         if (b.length == 0) {
2631             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2632                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanZeroRequired,
2633                 b.length,
2634                 0
2635             ));
2636         }
2637 
2638         // Store last byte.
2639         result = b[b.length - 1];
2640 
2641         assembly {
2642             // Decrement length of byte array.
2643             let newLen := sub(mload(b), 1)
2644             mstore(b, newLen)
2645         }
2646         return result;
2647     }
2648 
2649     /// @dev Tests equality of two byte arrays.
2650     /// @param lhs First byte array to compare.
2651     /// @param rhs Second byte array to compare.
2652     /// @return True if arrays are the same. False otherwise.
2653     function equals(
2654         bytes memory lhs,
2655         bytes memory rhs
2656     )
2657         internal
2658         pure
2659         returns (bool equal)
2660     {
2661         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
2662         // We early exit on unequal lengths, but keccak would also correctly
2663         // handle this.
2664         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
2665     }
2666 
2667     /// @dev Reads an address from a position in a byte array.
2668     /// @param b Byte array containing an address.
2669     /// @param index Index in byte array of address.
2670     /// @return address from byte array.
2671     function readAddress(
2672         bytes memory b,
2673         uint256 index
2674     )
2675         internal
2676         pure
2677         returns (address result)
2678     {
2679         if (b.length < index + 20) {
2680             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2681                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
2682                 b.length,
2683                 index + 20 // 20 is length of address
2684             ));
2685         }
2686 
2687         // Add offset to index:
2688         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
2689         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
2690         index += 20;
2691 
2692         // Read address from array memory
2693         assembly {
2694             // 1. Add index to address of bytes array
2695             // 2. Load 32-byte word from memory
2696             // 3. Apply 20-byte mask to obtain address
2697             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
2698         }
2699         return result;
2700     }
2701 
2702     /// @dev Writes an address into a specific position in a byte array.
2703     /// @param b Byte array to insert address into.
2704     /// @param index Index in byte array of address.
2705     /// @param input Address to put into byte array.
2706     function writeAddress(
2707         bytes memory b,
2708         uint256 index,
2709         address input
2710     )
2711         internal
2712         pure
2713     {
2714         if (b.length < index + 20) {
2715             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2716                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
2717                 b.length,
2718                 index + 20 // 20 is length of address
2719             ));
2720         }
2721 
2722         // Add offset to index:
2723         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
2724         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
2725         index += 20;
2726 
2727         // Store address into array memory
2728         assembly {
2729             // The address occupies 20 bytes and mstore stores 32 bytes.
2730             // First fetch the 32-byte word where we'll be storing the address, then
2731             // apply a mask so we have only the bytes in the word that the address will not occupy.
2732             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
2733 
2734             // 1. Add index to address of bytes array
2735             // 2. Load 32-byte word from memory
2736             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
2737             let neighbors := and(
2738                 mload(add(b, index)),
2739                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
2740             )
2741 
2742             // Make sure input address is clean.
2743             // (Solidity does not guarantee this)
2744             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
2745 
2746             // Store the neighbors and address into memory
2747             mstore(add(b, index), xor(input, neighbors))
2748         }
2749     }
2750 
2751     /// @dev Reads a bytes32 value from a position in a byte array.
2752     /// @param b Byte array containing a bytes32 value.
2753     /// @param index Index in byte array of bytes32 value.
2754     /// @return bytes32 value from byte array.
2755     function readBytes32(
2756         bytes memory b,
2757         uint256 index
2758     )
2759         internal
2760         pure
2761         returns (bytes32 result)
2762     {
2763         if (b.length < index + 32) {
2764             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2765                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
2766                 b.length,
2767                 index + 32
2768             ));
2769         }
2770 
2771         // Arrays are prefixed by a 256 bit length parameter
2772         index += 32;
2773 
2774         // Read the bytes32 from array memory
2775         assembly {
2776             result := mload(add(b, index))
2777         }
2778         return result;
2779     }
2780 
2781     /// @dev Writes a bytes32 into a specific position in a byte array.
2782     /// @param b Byte array to insert <input> into.
2783     /// @param index Index in byte array of <input>.
2784     /// @param input bytes32 to put into byte array.
2785     function writeBytes32(
2786         bytes memory b,
2787         uint256 index,
2788         bytes32 input
2789     )
2790         internal
2791         pure
2792     {
2793         if (b.length < index + 32) {
2794             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2795                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
2796                 b.length,
2797                 index + 32
2798             ));
2799         }
2800 
2801         // Arrays are prefixed by a 256 bit length parameter
2802         index += 32;
2803 
2804         // Read the bytes32 from array memory
2805         assembly {
2806             mstore(add(b, index), input)
2807         }
2808     }
2809 
2810     /// @dev Reads a uint256 value from a position in a byte array.
2811     /// @param b Byte array containing a uint256 value.
2812     /// @param index Index in byte array of uint256 value.
2813     /// @return uint256 value from byte array.
2814     function readUint256(
2815         bytes memory b,
2816         uint256 index
2817     )
2818         internal
2819         pure
2820         returns (uint256 result)
2821     {
2822         result = uint256(readBytes32(b, index));
2823         return result;
2824     }
2825 
2826     /// @dev Writes a uint256 into a specific position in a byte array.
2827     /// @param b Byte array to insert <input> into.
2828     /// @param index Index in byte array of <input>.
2829     /// @param input uint256 to put into byte array.
2830     function writeUint256(
2831         bytes memory b,
2832         uint256 index,
2833         uint256 input
2834     )
2835         internal
2836         pure
2837     {
2838         writeBytes32(b, index, bytes32(input));
2839     }
2840 
2841     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
2842     /// @param b Byte array containing a bytes4 value.
2843     /// @param index Index in byte array of bytes4 value.
2844     /// @return bytes4 value from byte array.
2845     function readBytes4(
2846         bytes memory b,
2847         uint256 index
2848     )
2849         internal
2850         pure
2851         returns (bytes4 result)
2852     {
2853         if (b.length < index + 4) {
2854             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
2855                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsFourRequired,
2856                 b.length,
2857                 index + 4
2858             ));
2859         }
2860 
2861         // Arrays are prefixed by a 32 byte length field
2862         index += 32;
2863 
2864         // Read the bytes4 from array memory
2865         assembly {
2866             result := mload(add(b, index))
2867             // Solidity does not require us to clean the trailing bytes.
2868             // We do it anyway
2869             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
2870         }
2871         return result;
2872     }
2873 
2874     /// @dev Writes a new length to a byte array.
2875     ///      Decreasing length will lead to removing the corresponding lower order bytes from the byte array.
2876     ///      Increasing length may lead to appending adjacent in-memory bytes to the end of the byte array.
2877     /// @param b Bytes array to write new length to.
2878     /// @param length New length of byte array.
2879     function writeLength(bytes memory b, uint256 length)
2880         internal
2881         pure
2882     {
2883         assembly {
2884             mstore(b, length)
2885         }
2886     }
2887 }
2888 
2889 // File: contracts/exchange/interfaces/IWallet.sol
2890 
2891 /*
2892 
2893   Copyright 2018 ZeroEx Intl.
2894 
2895   Licensed under the Apache License, Version 2.0 (the "License");
2896   you may not use this file except in compliance with the License.
2897   You may obtain a copy of the License at
2898 
2899     http://www.apache.org/licenses/LICENSE-2.0
2900 
2901   Unless required by applicable law or agreed to in writing, software
2902   distributed under the License is distributed on an "AS IS" BASIS,
2903   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2904   See the License for the specific language governing permissions and
2905   limitations under the License.
2906 
2907 */
2908 
2909 pragma solidity 0.5.16;
2910 
2911 
2912 contract IWallet {
2913 
2914     /// @dev Verifies that a signature is valid.
2915     /// @param hash Message hash that is signed.
2916     /// @param signature Proof of signing.
2917     /// @return Magic bytes4 value if the signature is valid.
2918     ///         Magic value is bytes4(keccak256("isValidWalletSignature(bytes32,address,bytes)"))
2919     function isValidSignature(
2920         bytes32 hash,
2921         bytes calldata signature
2922     )
2923         external
2924         view
2925         returns (bytes4);
2926 }
2927 
2928 // File: contracts/exchange/interfaces/IValidator.sol
2929 
2930 /*
2931 
2932   Copyright 2018 ZeroEx Intl.
2933 
2934   Licensed under the Apache License, Version 2.0 (the "License");
2935   you may not use this file except in compliance with the License.
2936   You may obtain a copy of the License at
2937 
2938     http://www.apache.org/licenses/LICENSE-2.0
2939 
2940   Unless required by applicable law or agreed to in writing, software
2941   distributed under the License is distributed on an "AS IS" BASIS,
2942   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2943   See the License for the specific language governing permissions and
2944   limitations under the License.
2945 
2946 */
2947 
2948 pragma solidity 0.5.16;
2949 
2950 
2951 contract IValidator {
2952 
2953     /// @dev Verifies that a signature is valid.
2954     /// @param hash Message hash that is signed.
2955     /// @param signerAddress Address that should have signed the given hash.
2956     /// @param signature Proof of signing.
2957     /// @return Magic bytes4 value if the signature is valid.
2958     ///         Magic value is bytes4(keccak256("isValidValidatorSignature(address,bytes32,address,bytes)"))
2959     function isValidSignature(
2960         bytes32 hash,
2961         address signerAddress,
2962         bytes calldata signature
2963     )
2964         external
2965         view
2966         returns (bytes4);
2967 }
2968 
2969 // File: contracts/exchange/MixinSignatureValidator.sol
2970 
2971 /*
2972 
2973   Copyright 2018 ZeroEx Intl.
2974 
2975   Licensed under the Apache License, Version 2.0 (the "License");
2976   you may not use this file except in compliance with the License.
2977   You may obtain a copy of the License at
2978 
2979     http://www.apache.org/licenses/LICENSE-2.0
2980 
2981   Unless required by applicable law or agreed to in writing, software
2982   distributed under the License is distributed on an "AS IS" BASIS,
2983   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2984   See the License for the specific language governing permissions and
2985   limitations under the License.
2986 
2987 */
2988 
2989 pragma solidity 0.5.16;
2990 
2991 
2992 contract MixinSignatureValidator is
2993     ReentrancyGuard,
2994     MSignatureValidator,
2995     MTransactions
2996 {
2997     using LibBytes for bytes;
2998 
2999     // Mapping of hash => signer => signed
3000     mapping (bytes32 => mapping (address => bool)) public preSigned;
3001 
3002     // Mapping of signer => validator => approved
3003     mapping (address => mapping (address => bool)) public allowedValidators;
3004 
3005     /// @dev Approves a hash on-chain using any valid signature type.
3006     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
3007     /// @param signerAddress Address that should have signed the given hash.
3008     /// @param signature Proof that the hash has been signed by signer.
3009     function preSign(
3010         bytes32 hash,
3011         address signerAddress,
3012         bytes calldata signature
3013     )
3014         external
3015     {
3016         if (signerAddress != msg.sender) {
3017             require(
3018                 isValidSignature(
3019                     hash,
3020                     signerAddress,
3021                     signature
3022                 ),
3023                 "INVALID_SIGNATURE"
3024             );
3025         }
3026         preSigned[hash][signerAddress] = true;
3027     }
3028 
3029     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
3030     /// @param validatorAddress Address of Validator contract.
3031     /// @param approval Approval or disapproval of  Validator contract.
3032     function setSignatureValidatorApproval(
3033         address validatorAddress,
3034         bool approval
3035     )
3036         external
3037         nonReentrant
3038     {
3039         address signerAddress = getCurrentContextAddress();
3040         allowedValidators[signerAddress][validatorAddress] = approval;
3041         emit SignatureValidatorApproval(
3042             signerAddress,
3043             validatorAddress,
3044             approval
3045         );
3046     }
3047 
3048     /// @dev Verifies that a hash has been signed by the given signer.
3049     /// @param hash Any 32 byte hash.
3050     /// @param signerAddress Address that should have signed the given hash.
3051     /// @param signature Proof that the hash has been signed by signer.
3052     /// @return True if the address recovered from the provided signature matches the input signer address.
3053     function isValidSignature(
3054         bytes32 hash,
3055         address signerAddress,
3056         bytes memory signature
3057     )
3058         public
3059         view
3060         returns (bool isValid)
3061     {
3062         require(
3063             signature.length > 0,
3064             "LENGTH_GREATER_THAN_0_REQUIRED"
3065         );
3066 
3067         // Pop last byte off of signature byte array.
3068         uint8 signatureTypeRaw = uint8(signature.popLastByte());
3069 
3070         // Ensure signature is supported
3071         require(
3072             signatureTypeRaw < uint8(SignatureType.NSignatureTypes),
3073             "SIGNATURE_UNSUPPORTED"
3074         );
3075 
3076         SignatureType signatureType = SignatureType(signatureTypeRaw);
3077 
3078         // Variables are not scoped in Solidity.
3079         uint8 v;
3080         bytes32 r;
3081         bytes32 s;
3082         address recovered;
3083 
3084         // Always illegal signature.
3085         // This is always an implicit option since a signer can create a
3086         // signature array with invalid type or length. We may as well make
3087         // it an explicit option. This aids testing and analysis. It is
3088         // also the initialization value for the enum type.
3089         if (signatureType == SignatureType.Illegal) {
3090             revert("SIGNATURE_ILLEGAL");
3091 
3092         // Always invalid signature.
3093         // Like Illegal, this is always implicitly available and therefore
3094         // offered explicitly. It can be implicitly created by providing
3095         // a correctly formatted but incorrect signature.
3096         } else if (signatureType == SignatureType.Invalid) {
3097             require(
3098                 signature.length == 0,
3099                 "LENGTH_0_REQUIRED"
3100             );
3101             isValid = false;
3102             return isValid;
3103 
3104         // Signature using EIP712
3105         } else if (signatureType == SignatureType.EIP712) {
3106             require(
3107                 signature.length == 65,
3108                 "LENGTH_65_REQUIRED"
3109             );
3110             v = uint8(signature[0]);
3111             r = signature.readBytes32(1);
3112             s = signature.readBytes32(33);
3113             recovered = ecrecover(
3114                 hash,
3115                 v,
3116                 r,
3117                 s
3118             );
3119             isValid = signerAddress == recovered;
3120             return isValid;
3121 
3122         // Signed using web3.eth_sign
3123         } else if (signatureType == SignatureType.EthSign) {
3124             require(
3125                 signature.length == 65,
3126                 "LENGTH_65_REQUIRED"
3127             );
3128             v = uint8(signature[0]);
3129             r = signature.readBytes32(1);
3130             s = signature.readBytes32(33);
3131             recovered = ecrecover(
3132                 keccak256(abi.encodePacked(
3133                     "\x19Ethereum Signed Message:\n32",
3134                     hash
3135                 )),
3136                 v,
3137                 r,
3138                 s
3139             );
3140             isValid = signerAddress == recovered;
3141             return isValid;
3142 
3143         // Signature verified by wallet contract.
3144         // If used with an order, the maker of the order is the wallet contract.
3145         } else if (signatureType == SignatureType.Wallet) {
3146             isValid = isValidWalletSignature(
3147                 hash,
3148                 signerAddress,
3149                 signature
3150             );
3151             return isValid;
3152 
3153         // Signature verified by validator contract.
3154         // If used with an order, the maker of the order can still be an EOA.
3155         // A signature using this type should be encoded as:
3156         // | Offset   | Length | Contents                        |
3157         // | 0x00     | x      | Signature to validate           |
3158         // | 0x00 + x | 20     | Address of validator contract   |
3159         // | 0x14 + x | 1      | Signature type is always "\x06" |
3160         } else if (signatureType == SignatureType.Validator) {
3161             // Pop last 20 bytes off of signature byte array.
3162             uint256 signatureLength = signature.length;
3163             address validatorAddress = signature.readAddress(signatureLength - 20);
3164 
3165             // Ensure signer has approved validator.
3166             if (!allowedValidators[signerAddress][validatorAddress]) {
3167                 return false;
3168             }
3169             isValid = isValidValidatorSignature(
3170                 validatorAddress,
3171                 hash,
3172                 signerAddress,
3173                 signature
3174             );
3175             return isValid;
3176 
3177         // Signer signed hash previously using the preSign function.
3178         } else if (signatureType == SignatureType.PreSigned) {
3179             isValid = preSigned[hash][signerAddress];
3180             return isValid;
3181         }
3182 
3183         // Anything else is illegal (We do not return false because
3184         // the signature may actually be valid, just not in a format
3185         // that we currently support. In this case returning false
3186         // may lead the caller to incorrectly believe that the
3187         // signature was invalid.)
3188         revert("SIGNATURE_UNSUPPORTED");
3189     }
3190 
3191     /// @dev Verifies signature using logic defined by Wallet contract. Wallet contract
3192     ///      must return `bytes4(keccak256("isValidWalletSignature(bytes32,address,bytes)"))`
3193     ///      miime:   or `bytes4(keccak256("isValidSignature(bytes32,bytes)"))`
3194     ///      miime:   or `bytes4(keccak256("isValidSignature(bytes,bytes)")`
3195     /// @param hash Any 32 byte hash.
3196     /// @param walletAddress Address that should have signed the given hash
3197     ///                      and defines its own signature verification method.
3198     /// @param signature Proof that the hash has been signed by signer.
3199     /// @return True if signature is valid for given wallet..
3200     function isValidWalletSignature(
3201         bytes32 hash,
3202         address walletAddress,
3203         bytes memory signature
3204     )
3205         internal
3206         view
3207         returns (bool isValid)
3208     {
3209         bytes memory callData = abi.encodeWithSelector(
3210             IWallet(walletAddress).isValidSignature.selector,
3211             hash,
3212             signature
3213         );
3214         // bytes4 0xb0671381
3215         bytes32 magicValue = bytes32(bytes4(keccak256("isValidWalletSignature(bytes32,address,bytes)")));
3216         // miime: bytes4 0x20c13b0b for EIP-1271
3217         bytes32 magicValueEIP1271 = bytes32(bytes4(keccak256("isValidSignature(bytes,bytes)")));
3218         // miime: bytes4 0x1626ba7e for Dapper contract wallet https://github.com/dapperlabs/dapper-contracts/blob/2ccb26e/contracts/ERC1271/ERC1271.sol#L6
3219         bytes32 magicValueEIP1271Old = bytes32(bytes4(keccak256("isValidSignature(bytes32,bytes)")));
3220         assembly {
3221             // extcodesize added as an extra safety measure
3222             if iszero(extcodesize(walletAddress)) {
3223                 // Revert with `Error("WALLET_ERROR")`
3224                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3225                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3226                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3227                 mstore(96, 0)
3228                 revert(0, 100)
3229             }
3230 
3231             let cdStart := add(callData, 32)
3232             let success := staticcall(
3233                 gas,              // forward all gas
3234                 walletAddress,    // address of Wallet contract
3235                 cdStart,          // pointer to start of input
3236                 mload(callData),  // length of input
3237                 cdStart,          // write output over input
3238                 32                // output size is 32 bytes
3239             )
3240 
3241             if iszero(eq(returndatasize(), 32)) {
3242                 // Revert with `Error("WALLET_ERROR")`
3243                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3244                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3245                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3246                 mstore(96, 0)
3247                 revert(0, 100)
3248             }
3249 
3250             switch success
3251             case 0 {
3252                 // Revert with `Error("WALLET_ERROR")`
3253                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3254                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3255                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
3256                 mstore(96, 0)
3257                 revert(0, 100)
3258             }
3259             case 1 {
3260                 // miime: Added EIP1271
3261                 // Signature is valid if call did not revert and returned true
3262                 isValid := or(
3263                     eq(
3264                         and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3265                         and(magicValue, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3266                     ),
3267                     or(
3268                         eq(
3269                             and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3270                             and(magicValueEIP1271, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3271                         ),
3272                         eq(
3273                             and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3274                             and(magicValueEIP1271Old, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3275                         )
3276                     )
3277                 )
3278             }
3279         }
3280         return isValid;
3281     }
3282 
3283     /// @dev Verifies signature using logic defined by Validator contract.
3284     ///      Validator must return `bytes4(keccak256("isValidValidatorSignature(address,bytes32,address,bytes)"))`
3285     /// @param validatorAddress Address of validator contract.
3286     /// @param hash Any 32 byte hash.
3287     /// @param signerAddress Address that should have signed the given hash.
3288     /// @param signature Proof that the hash has been signed by signer.
3289     /// @return True if the address recovered from the provided signature matches the input signer address.
3290     function isValidValidatorSignature(
3291         address validatorAddress,
3292         bytes32 hash,
3293         address signerAddress,
3294         bytes memory signature
3295     )
3296         internal
3297         view
3298         returns (bool isValid)
3299     {
3300         bytes memory callData = abi.encodeWithSelector(
3301             IValidator(signerAddress).isValidSignature.selector,
3302             hash,
3303             signerAddress,
3304             signature
3305         );
3306         // bytes4 0x42b38674
3307         bytes32 magicValue = bytes32(bytes4(keccak256("isValidValidatorSignature(address,bytes32,address,bytes)")));
3308         assembly {
3309             // extcodesize added as an extra safety measure
3310             if iszero(extcodesize(validatorAddress)) {
3311                 // Revert with `Error("VALIDATOR_ERROR")`
3312                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3313                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3314                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3315                 mstore(96, 0)
3316                 revert(0, 100)
3317             }
3318 
3319             let cdStart := add(callData, 32)
3320             let success := staticcall(
3321                 gas,               // forward all gas
3322                 validatorAddress,  // address of Validator contract
3323                 cdStart,           // pointer to start of input
3324                 mload(callData),   // length of input
3325                 cdStart,           // write output over input
3326                 32                 // output size is 32 bytes
3327             )
3328 
3329             if iszero(eq(returndatasize(), 32)) {
3330                 // Revert with `Error("VALIDATOR_ERROR")`
3331                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3332                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3333                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3334                 mstore(96, 0)
3335                 revert(0, 100)
3336             }
3337 
3338             switch success
3339             case 0 {
3340                 // Revert with `Error("VALIDATOR_ERROR")`
3341                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
3342                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
3343                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
3344                 mstore(96, 0)
3345                 revert(0, 100)
3346             }
3347             case 1 {
3348                 // Signature is valid if call did not revert and returned true
3349                 isValid := eq(
3350                     and(mload(cdStart), 0xffffffff00000000000000000000000000000000000000000000000000000000),
3351                     and(magicValue, 0xffffffff00000000000000000000000000000000000000000000000000000000)
3352                 )
3353             }
3354         }
3355         return isValid;
3356     }
3357 }
3358 
3359 // File: contracts/exchange/MixinWrapperFunctions.sol
3360 
3361 /*
3362 
3363   Copyright 2018 ZeroEx Intl.
3364 
3365   Licensed under the Apache License, Version 2.0 (the "License");
3366   you may not use this file except in compliance with the License.
3367   You may obtain a copy of the License at
3368 
3369     http://www.apache.org/licenses/LICENSE-2.0
3370 
3371   Unless required by applicable law or agreed to in writing, software
3372   distributed under the License is distributed on an "AS IS" BASIS,
3373   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3374   See the License for the specific language governing permissions and
3375   limitations under the License.
3376 
3377 */
3378 
3379 pragma solidity 0.5.16;
3380 
3381 
3382 contract MixinWrapperFunctions is
3383     ReentrancyGuard,
3384     LibMath,
3385     MExchangeCore
3386 {
3387     /// @dev Synchronously cancels multiple orders in a single transaction.
3388     /// @param orders Array of order specifications.
3389     function batchCancelOrders(LibOrder.Order[] memory orders)
3390         public
3391         nonReentrant
3392     {
3393         uint256 ordersLength = orders.length;
3394         for (uint256 i = 0; i != ordersLength; i++) {
3395             cancelOrderInternal(orders[i]);
3396         }
3397     }
3398 
3399     /// @dev Fetches information for all passed in orders.
3400     /// @param orders Array of order specifications.
3401     /// @return Array of OrderInfo instances that correspond to each order.
3402     function getOrdersInfo(LibOrder.Order[] memory orders)
3403         public
3404         view
3405         returns (LibOrder.OrderInfo[] memory)
3406     {
3407         uint256 ordersLength = orders.length;
3408         LibOrder.OrderInfo[] memory ordersInfo = new LibOrder.OrderInfo[](ordersLength);
3409         for (uint256 i = 0; i != ordersLength; i++) {
3410             ordersInfo[i] = getOrderInfo(orders[i]);
3411         }
3412         return ordersInfo;
3413     }
3414 
3415 }
3416 
3417 // File: contracts/exchange/interfaces/IAssetProxy.sol
3418 
3419 /*
3420 
3421   Copyright 2018 ZeroEx Intl.
3422 
3423   Licensed under the Apache License, Version 2.0 (the "License");
3424   you may not use this file except in compliance with the License.
3425   You may obtain a copy of the License at
3426 
3427     http://www.apache.org/licenses/LICENSE-2.0
3428 
3429   Unless required by applicable law or agreed to in writing, software
3430   distributed under the License is distributed on an "AS IS" BASIS,
3431   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3432   See the License for the specific language governing permissions and
3433   limitations under the License.
3434 
3435 */
3436 
3437 pragma solidity 0.5.16;
3438 
3439 
3440 contract IAssetProxy {
3441     /// @dev Transfers assets. Either succeeds or throws.
3442     /// @param assetData Byte array encoded for the respective asset proxy.
3443     /// @param from Address to transfer asset from.
3444     /// @param to Address to transfer asset to.
3445     /// @param amount Amount of asset to transfer.
3446     function transferFrom(
3447         bytes calldata assetData,
3448         address from,
3449         address to,
3450         uint256 amount
3451     )
3452         external;
3453     
3454     /// @dev Gets the proxy id associated with the proxy address.
3455     /// @return Proxy id.
3456     function getProxyId()
3457         external
3458         pure
3459         returns (bytes4);
3460 }
3461 
3462 // File: contracts/exchange/MixinAssetProxyDispatcher.sol
3463 
3464 /*
3465 
3466   Modified by Metaps Alpha Inc.
3467 
3468   Copyright 2018 ZeroEx Intl.
3469 
3470   Licensed under the Apache License, Version 2.0 (the "License");
3471   you may not use this file except in compliance with the License.
3472   You may obtain a copy of the License at
3473 
3474     http://www.apache.org/licenses/LICENSE-2.0
3475 
3476   Unless required by applicable law or agreed to in writing, software
3477   distributed under the License is distributed on an "AS IS" BASIS,
3478   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3479   See the License for the specific language governing permissions and
3480   limitations under the License.
3481 
3482 */
3483 
3484 pragma solidity 0.5.16;
3485 
3486 
3487 contract MixinAssetProxyDispatcher is
3488     DepositManager,
3489     LibConstants,
3490     MAssetProxyDispatcher
3491 {
3492     // Mapping from Asset Proxy Id's to their respective Asset Proxy
3493     mapping (bytes4 => address) public assetProxies;
3494 
3495     /// @dev Registers an asset proxy to its asset proxy id.
3496     ///      Once an asset proxy is registered, it cannot be unregistered.
3497     /// @param assetProxy Address of new asset proxy to register.
3498     function registerAssetProxy(address assetProxy)
3499         external
3500         onlyOwner
3501     {
3502         // Ensure that no asset proxy exists with current id.
3503         bytes4 assetProxyId = IAssetProxy(assetProxy).getProxyId();
3504         address currentAssetProxy = assetProxies[assetProxyId];
3505         require(
3506             currentAssetProxy == address(0),
3507             "ASSET_PROXY_ALREADY_EXISTS"
3508         );
3509 
3510         // Add asset proxy and log registration.
3511         assetProxies[assetProxyId] = assetProxy;
3512         emit AssetProxyRegistered(
3513             assetProxyId,
3514             assetProxy
3515         );
3516     }
3517 
3518     /// @dev Gets an asset proxy.
3519     /// @param assetProxyId Id of the asset proxy.
3520     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
3521     function getAssetProxy(bytes4 assetProxyId)
3522         external
3523         view
3524         returns (address)
3525     {
3526         return assetProxies[assetProxyId];
3527     }
3528 
3529     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
3530     /// @param assetData Byte array encoded for the asset.
3531     /// @param from Address to transfer token from.
3532     /// @param to Address to transfer token to.
3533     /// @param amount Amount of token to transfer.
3534     function dispatchTransferFrom(
3535         bytes memory assetData,
3536         address from,
3537         address payable to,
3538         uint256 amount
3539     )
3540         internal
3541     {
3542         // Do nothing if no amount should be transferred.
3543         if (amount > 0 && from != to) {
3544             // Ensure assetData length is valid
3545             require(
3546                 assetData.length > 3,
3547                 "LENGTH_GREATER_THAN_3_REQUIRED"
3548             );
3549 
3550             // miime - If assetData is for ETH, send ETH from deposit.
3551             if (keccak256(assetData) == KECCAK256_ETH_ASSET_DATA) {
3552                 require(
3553                     depositAmount[from] >= amount,
3554                     "DEPOSIT_AMOUNT_IS_INSUFFICIENT"
3555                 );
3556                 uint256 afterBalance = depositAmount[from].safeSub(amount);
3557                 depositAmount[from] = afterBalance;
3558                 if (to != address(this)) {
3559                     (bool success, bytes memory _data) = to.call.gas(TRANSFER_GAS_LIMIT).value(amount)("");
3560                     require(success, "ETH_SENDING_FAILED");
3561                 }
3562                 return;
3563             }
3564 
3565             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
3566             bytes4 assetProxyId;
3567             assembly {
3568                 assetProxyId := and(mload(
3569                     add(assetData, 32)),
3570                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
3571                 )
3572             }
3573             address assetProxy = assetProxies[assetProxyId];
3574 
3575             // Ensure that assetProxy exists
3576             require(
3577                 assetProxy != address(0),
3578                 "ASSET_PROXY_DOES_NOT_EXIST"
3579             );
3580             
3581             // We construct calldata for the `assetProxy.transferFrom` ABI.
3582             // The layout of this calldata is in the table below.
3583             // 
3584             // | Area     | Offset | Length  | Contents                                    |
3585             // | -------- |--------|---------|-------------------------------------------- |
3586             // | Header   | 0      | 4       | function selector                           |
3587             // | Params   |        | 4 * 32  | function parameters:                        |
3588             // |          | 4      |         |   1. offset to assetData (*)                |
3589             // |          | 36     |         |   2. from                                   |
3590             // |          | 68     |         |   3. to                                     |
3591             // |          | 100    |         |   4. amount                                 |
3592             // | Data     |        |         | assetData:                                  |
3593             // |          | 132    | 32      | assetData Length                            |
3594             // |          | 164    | **      | assetData Contents                          |
3595 
3596             assembly {
3597                 /////// Setup State ///////
3598                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
3599                 let cdStart := mload(64)
3600                 // `dataAreaLength` is the total number of words needed to store `assetData`
3601                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
3602                 //  and includes 32-bytes for length.
3603                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
3604                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
3605                 let cdEnd := add(cdStart, add(132, dataAreaLength))
3606 
3607                 
3608                 /////// Setup Header Area ///////
3609                 // This area holds the 4-byte `transferFromSelector`.
3610                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
3611                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
3612                 
3613                 /////// Setup Params Area ///////
3614                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
3615                 // Notes:
3616                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
3617                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
3618                 mstore(add(cdStart, 4), 128)
3619                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
3620                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
3621                 mstore(add(cdStart, 100), amount)
3622                 
3623                 /////// Setup Data Area ///////
3624                 // This area holds `assetData`.
3625                 let dataArea := add(cdStart, 132)
3626                 // solhint-disable-next-line no-empty-blocks
3627                 for {} lt(dataArea, cdEnd) {} {
3628                     mstore(dataArea, mload(assetData))
3629                     dataArea := add(dataArea, 32)
3630                     assetData := add(assetData, 32)
3631                 }
3632 
3633                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
3634                 let success := call(
3635                     gas,                    // forward all gas
3636                     assetProxy,             // call address of asset proxy
3637                     0,                      // don't send any ETH
3638                     cdStart,                // pointer to start of input
3639                     sub(cdEnd, cdStart),    // length of input  
3640                     cdStart,                // write output over input
3641                     512                     // reserve 512 bytes for output
3642                 )
3643                 if iszero(success) {
3644                     revert(cdStart, returndatasize())
3645                 }
3646             }
3647         }
3648     }
3649 }
3650 
3651 // File: contracts/exchange/MixinTransactions.sol
3652 
3653 /*
3654 
3655   Copyright 2018 ZeroEx Intl.
3656 
3657   Licensed under the Apache License, Version 2.0 (the "License");
3658   you may not use this file except in compliance with the License.
3659   You may obtain a copy of the License at
3660 
3661     http://www.apache.org/licenses/LICENSE-2.0
3662 
3663   Unless required by applicable law or agreed to in writing, software
3664   distributed under the License is distributed on an "AS IS" BASIS,
3665   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3666   See the License for the specific language governing permissions and
3667   limitations under the License.
3668 
3669 */
3670 pragma solidity 0.5.16;
3671 
3672 
3673 contract MixinTransactions is
3674     LibEIP712,
3675     MSignatureValidator,
3676     MTransactions
3677 {
3678     // Mapping of transaction hash => executed
3679     // This prevents transactions from being executed more than once.
3680     mapping (bytes32 => bool) public transactions;
3681 
3682     // Address of current transaction signer
3683     address payable public currentContextAddress;
3684 
3685     /// @dev Executes an exchange method call in the context of signer.
3686     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3687     /// @param signerAddress Address of transaction signer.
3688     /// @param data AbiV2 encoded calldata.
3689     /// @param signature Proof of signer transaction by signer.
3690     function executeTransaction(
3691         uint256 salt,
3692         address payable signerAddress,
3693         bytes calldata data,
3694         bytes calldata signature
3695     )
3696         external
3697     {
3698         // Prevent reentrancy
3699         require(
3700             currentContextAddress == address(0),
3701             "REENTRANCY_ILLEGAL"
3702         );
3703 
3704         bytes32 transactionHash = hashEIP712Message(hashZeroExTransaction(
3705             salt,
3706             signerAddress,
3707             data
3708         ));
3709 
3710         // Validate transaction has not been executed
3711         require(
3712             !transactions[transactionHash],
3713             "INVALID_TX_HASH"
3714         );
3715 
3716         // Transaction always valid if signer is sender of transaction
3717         if (signerAddress != msg.sender) {
3718             // Validate signature
3719             require(
3720                 isValidSignature(
3721                     transactionHash,
3722                     signerAddress,
3723                     signature
3724                 ),
3725                 "INVALID_TX_SIGNATURE"
3726             );
3727 
3728             // Set the current transaction signer
3729             currentContextAddress = signerAddress;
3730         }
3731 
3732         // Execute transaction
3733         transactions[transactionHash] = true;
3734         (bool success,) = address(this).delegatecall(data);
3735         require(
3736             success,
3737             "FAILED_EXECUTION"
3738         );
3739 
3740         // Reset current transaction signer if it was previously updated
3741         if (signerAddress != msg.sender) {
3742             currentContextAddress = address(0);
3743         }
3744     }
3745 
3746     /// @dev Calculates EIP712 hash of the Transaction.
3747     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3748     /// @param signerAddress Address of transaction signer.
3749     /// @param data AbiV2 encoded calldata.
3750     /// @return EIP712 hash of the Transaction.
3751     function hashZeroExTransaction(
3752         uint256 salt,
3753         address signerAddress,
3754         bytes memory data
3755     )
3756         internal
3757         pure
3758         returns (bytes32 result)
3759     {
3760         bytes32 schemaHash = EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
3761         bytes32 dataHash = keccak256(data);
3762 
3763         // Assembly for more efficiently computing:
3764         // keccak256(abi.encodePacked(
3765         //     EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH,
3766         //     salt,
3767         //     bytes32(signerAddress),
3768         //     keccak256(data)
3769         // ));
3770 
3771         assembly {
3772             // Load free memory pointer
3773             let memPtr := mload(64)
3774 
3775             mstore(memPtr, schemaHash)                                                               // hash of schema
3776             mstore(add(memPtr, 32), salt)                                                            // salt
3777             mstore(add(memPtr, 64), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
3778             mstore(add(memPtr, 96), dataHash)                                                        // hash of data
3779 
3780             // Compute hash
3781             result := keccak256(memPtr, 128)
3782         }
3783         return result;
3784     }
3785 
3786     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
3787     ///      If calling a fill function, this address will represent the taker.
3788     ///      If calling a cancel function, this address will represent the maker.
3789     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
3790     ///         `msg.sender` if entry point is any other function.
3791     function getCurrentContextAddress()
3792         internal
3793         view
3794         returns (address payable)
3795     {
3796         address payable currentContextAddress_ = currentContextAddress;
3797         address payable contextAddress = currentContextAddress_ == address(0) ? msg.sender : currentContextAddress_;
3798         return contextAddress;
3799     }
3800 }
3801 
3802 // File: contracts/exchange/interfaces/IMatchOrders.sol
3803 
3804 /*
3805 
3806   Copyright 2018 ZeroEx Intl.
3807 
3808   Licensed under the Apache License, Version 2.0 (the "License");
3809   you may not use this file except in compliance with the License.
3810   You may obtain a copy of the License at
3811 
3812     http://www.apache.org/licenses/LICENSE-2.0
3813 
3814   Unless required by applicable law or agreed to in writing, software
3815   distributed under the License is distributed on an "AS IS" BASIS,
3816   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3817   See the License for the specific language governing permissions and
3818   limitations under the License.
3819 
3820 */
3821 pragma solidity 0.5.16;
3822 
3823 
3824 contract IMatchOrders {
3825 
3826     /// @dev Match two complementary orders that have a profitable spread.
3827     ///      Each order is filled at their respective price point. However, the calculations are
3828     ///      carried out as though the orders are both being filled at the right order's price point.
3829     ///      The profit made by the left order goes to the taker (who matched the two orders).
3830     /// @param leftOrder First order to match.
3831     /// @param rightOrder Second order to match.
3832     /// @param leftSignature Proof that order was created by the left maker.
3833     /// @param rightSignature Proof that order was created by the right maker.
3834     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
3835     function matchOrders(
3836         LibOrder.Order memory leftOrder,
3837         LibOrder.Order memory rightOrder,
3838         bytes memory leftSignature,
3839         bytes memory rightSignature
3840     )
3841         public
3842         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
3843 }
3844 
3845 // File: contracts/exchange/mixins/MMatchOrders.sol
3846 
3847 /*
3848 
3849   Copyright 2018 ZeroEx Intl.
3850 
3851   Licensed under the Apache License, Version 2.0 (the "License");
3852   you may not use this file except in compliance with the License.
3853   You may obtain a copy of the License at
3854 
3855     http://www.apache.org/licenses/LICENSE-2.0
3856 
3857   Unless required by applicable law or agreed to in writing, software
3858   distributed under the License is distributed on an "AS IS" BASIS,
3859   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3860   See the License for the specific language governing permissions and
3861   limitations under the License.
3862 
3863 */
3864 
3865 pragma solidity 0.5.16;
3866 
3867 
3868 contract MMatchOrders is
3869     IMatchOrders
3870 {
3871     /// @dev Validates context for matchOrders. Succeeds or throws.
3872     /// @param leftOrder First order to match.
3873     /// @param rightOrder Second order to match.
3874     function assertValidMatch(
3875         LibOrder.Order memory leftOrder,
3876         LibOrder.Order memory rightOrder
3877     )
3878         internal
3879         pure;
3880 
3881     /// @dev Calculates fill amounts for the matched orders.
3882     ///      Each order is filled at their respective price point. However, the calculations are
3883     ///      carried out as though the orders are both being filled at the right order's price point.
3884     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
3885     /// @param leftOrder First order to match.
3886     /// @param rightOrder Second order to match.
3887     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
3888     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
3889     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
3890     function calculateMatchedFillResults(
3891         LibOrder.Order memory leftOrder,
3892         LibOrder.Order memory rightOrder,
3893         uint256 leftOrderTakerAssetFilledAmount,
3894         uint256 rightOrderTakerAssetFilledAmount
3895     )
3896         internal
3897         pure
3898         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
3899 
3900 }
3901 
3902 // File: contracts/exchange/MixinMatchOrders.sol
3903 
3904 /*
3905   Modified by Metaps Alpha Inc.
3906 
3907   Copyright 2018 ZeroEx Intl.
3908   Licensed under the Apache License, Version 2.0 (the "License");
3909   you may not use this file except in compliance with the License.
3910   You may obtain a copy of the License at
3911     http://www.apache.org/licenses/LICENSE-2.0
3912   Unless required by applicable law or agreed to in writing, software
3913   distributed under the License is distributed on an "AS IS" BASIS,
3914   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3915   See the License for the specific language governing permissions and
3916   limitations under the License.
3917 */
3918 
3919 pragma solidity 0.5.16;
3920 
3921 
3922 contract MixinMatchOrders is
3923     DepositManager,
3924     LibConstants,
3925     LibMath,
3926     MAssetProxyDispatcher,
3927     MExchangeCore,
3928     MMatchOrders,
3929     MTransactions
3930 {
3931     /// @dev Match two complementary orders that have a profitable spread.
3932     ///      Each order is filled at their respective price point. However, the calculations are
3933     ///      carried out as though the orders are both being filled at the right order's price point.
3934     ///      The profit made by the left order goes to the taker (who matched the two orders).
3935     /// @param leftOrder First order to match.
3936     /// @param rightOrder Second order to match.
3937     /// @param leftSignature Proof that order was created by the left maker.
3938     /// @param rightSignature Proof that order was created by the right maker.
3939     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
3940     function matchOrders(
3941         LibOrder.Order memory leftOrder,
3942         LibOrder.Order memory rightOrder,
3943         bytes memory leftSignature,
3944         bytes memory rightSignature
3945     )
3946         public
3947         nonReentrant
3948         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
3949     {
3950         // We assume that rightOrder.takerAssetData == leftOrder.makerAssetData and rightOrder.makerAssetData == leftOrder.takerAssetData.
3951         // If this assumption isn't true, the match will fail at signature validation.
3952         rightOrder.makerAssetData = leftOrder.takerAssetData;
3953         rightOrder.takerAssetData = leftOrder.makerAssetData;
3954 
3955         // Get left & right order info
3956         LibOrder.OrderInfo memory leftOrderInfo = getOrderInfo(leftOrder);
3957         LibOrder.OrderInfo memory rightOrderInfo = getOrderInfo(rightOrder);
3958 
3959         // Fetch taker address
3960         address payable takerAddress = getCurrentContextAddress();
3961         
3962         // Either our context is valid or we revert
3963         assertFillableOrder(
3964             leftOrder,
3965             leftOrderInfo,
3966             takerAddress,
3967             leftSignature
3968         );
3969         assertFillableOrder(
3970             rightOrder,
3971             rightOrderInfo,
3972             takerAddress,
3973             rightSignature
3974         );
3975         assertValidMatch(leftOrder, rightOrder);
3976 
3977         // Compute proportional fill amounts
3978         matchedFillResults = calculateMatchedFillResults(
3979             leftOrder,
3980             rightOrder,
3981             leftOrderInfo.orderTakerAssetFilledAmount,
3982             rightOrderInfo.orderTakerAssetFilledAmount
3983         );
3984 
3985         // Validate fill contexts
3986         assertValidFill(
3987             leftOrder,
3988             leftOrderInfo,
3989             matchedFillResults.left.takerAssetFilledAmount,
3990             matchedFillResults.left.takerAssetFilledAmount,
3991             matchedFillResults.left.makerAssetFilledAmount
3992         );
3993         assertValidFill(
3994             rightOrder,
3995             rightOrderInfo,
3996             matchedFillResults.right.takerAssetFilledAmount,
3997             matchedFillResults.right.takerAssetFilledAmount,
3998             matchedFillResults.right.makerAssetFilledAmount
3999         );
4000         
4001         // Update exchange state
4002         updateFilledState(
4003             leftOrder,
4004             takerAddress,
4005             leftOrderInfo.orderHash,
4006             leftOrderInfo.orderTakerAssetFilledAmount,
4007             matchedFillResults.left
4008         );
4009         updateFilledState(
4010             rightOrder,
4011             takerAddress,
4012             rightOrderInfo.orderHash,
4013             rightOrderInfo.orderTakerAssetFilledAmount,
4014             matchedFillResults.right
4015         );
4016 
4017         // Settle matched orders. Succeeds or throws.
4018         settleMatchedOrders(
4019             leftOrder,
4020             rightOrder,
4021             takerAddress,
4022             matchedFillResults
4023         );
4024 
4025         // miime: Deduct deposit of this order
4026         if (keccak256(leftOrder.makerAssetData) == KECCAK256_ETH_ASSET_DATA) {
4027             deductOrderToDepositAmount(
4028                 leftOrderInfo.orderHash,
4029                 leftOrder.makerAddress,
4030                 matchedFillResults.right.takerAssetFilledAmount.safeAdd(matchedFillResults.leftMakerAssetSpreadAmount).safeAdd(matchedFillResults.left.makerFeePaid)
4031             );
4032         }
4033         if (keccak256(rightOrder.makerAssetData) == KECCAK256_ETH_ASSET_DATA) {
4034             deductOrderToDepositAmount(
4035                 rightOrderInfo.orderHash,
4036                 rightOrder.makerAddress,
4037                 matchedFillResults.left.takerAssetFilledAmount.safeAdd(matchedFillResults.right.makerFeePaid)
4038             );
4039         }
4040         if (keccak256(leftOrder.takerAssetData) == KECCAK256_ETH_ASSET_DATA) {
4041             deductOrderToDepositAmount(
4042                 leftOrderInfo.orderHash,
4043                 takerAddress,
4044                 matchedFillResults.left.takerFeePaid
4045             );
4046         }
4047         if (keccak256(rightOrder.takerAssetData) == KECCAK256_ETH_ASSET_DATA) {
4048             deductOrderToDepositAmount(
4049                 rightOrderInfo.orderHash,
4050                 takerAddress,
4051                 matchedFillResults.right.takerFeePaid
4052             );
4053         }
4054 
4055         return matchedFillResults;
4056     }
4057 
4058     /// @dev Validates context for matchOrders. Succeeds or throws.
4059     /// @param leftOrder First order to match.
4060     /// @param rightOrder Second order to match.
4061     function assertValidMatch(
4062         LibOrder.Order memory leftOrder,
4063         LibOrder.Order memory rightOrder
4064     )
4065         internal
4066         pure
4067     {
4068         // Make sure there is a profitable spread.
4069         // There is a profitable spread iff the cost per unit bought (OrderA.MakerAmount/OrderA.TakerAmount) for each order is greater
4070         // than the profit per unit sold of the matched order (OrderB.TakerAmount/OrderB.MakerAmount).
4071         // This is satisfied by the equations below:
4072         // <leftOrder.makerAssetAmount> / <leftOrder.takerAssetAmount> >= <rightOrder.takerAssetAmount> / <rightOrder.makerAssetAmount>
4073         // AND
4074         // <rightOrder.makerAssetAmount> / <rightOrder.takerAssetAmount> >= <leftOrder.takerAssetAmount> / <leftOrder.makerAssetAmount>
4075         // These equations can be combined to get the following:
4076         require(
4077             leftOrder.makerAssetAmount.safeMul(rightOrder.makerAssetAmount) >=
4078             leftOrder.takerAssetAmount.safeMul(rightOrder.takerAssetAmount),
4079             "NEGATIVE_SPREAD_REQUIRED"
4080         );
4081     }
4082 
4083     /// @dev Calculates fill amounts for the matched orders.
4084     ///      Each order is filled at their respective price point. However, the calculations are
4085     ///      carried out as though the orders are both being filled at the right order's price point.
4086     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
4087     /// @param leftOrder First order to match.
4088     /// @param rightOrder Second order to match.
4089     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
4090     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
4091     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
4092     function calculateMatchedFillResults(
4093         LibOrder.Order memory leftOrder,
4094         LibOrder.Order memory rightOrder,
4095         uint256 leftOrderTakerAssetFilledAmount,
4096         uint256 rightOrderTakerAssetFilledAmount
4097     )
4098         internal
4099         pure
4100         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
4101     {
4102         // Derive maker asset amounts for left & right orders, given store taker assert amounts
4103         uint256 leftTakerAssetAmountRemaining = leftOrder.takerAssetAmount.safeSub(leftOrderTakerAssetFilledAmount);
4104         uint256 leftMakerAssetAmountRemaining = safeGetPartialAmountFloor(
4105             leftOrder.makerAssetAmount,
4106             leftOrder.takerAssetAmount,
4107             leftTakerAssetAmountRemaining
4108         );
4109         uint256 rightTakerAssetAmountRemaining = rightOrder.takerAssetAmount.safeSub(rightOrderTakerAssetFilledAmount);
4110         uint256 rightMakerAssetAmountRemaining = safeGetPartialAmountFloor(
4111             rightOrder.makerAssetAmount,
4112             rightOrder.takerAssetAmount,
4113             rightTakerAssetAmountRemaining
4114         );
4115 
4116         // Calculate fill results for maker and taker assets: at least one order will be fully filled.
4117         // The maximum amount the left maker can buy is `leftTakerAssetAmountRemaining`
4118         // The maximum amount the right maker can sell is `rightMakerAssetAmountRemaining`
4119         // We have two distinct cases for calculating the fill results:
4120         // Case 1.
4121         //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.
4122         //   If the left maker can buy exactly what the right maker can sell, then both orders are fully filled.
4123         // Case 2.
4124         //   If the left maker cannot buy more than the right maker can sell, then only the left order is fully filled.
4125         if (leftTakerAssetAmountRemaining >= rightMakerAssetAmountRemaining) {
4126             // Case 1: Right order is fully filled
4127             matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;
4128             matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;
4129             matchedFillResults.left.takerAssetFilledAmount = matchedFillResults.right.makerAssetFilledAmount;
4130             // Round down to ensure the maker's exchange rate does not exceed the price specified by the order. 
4131             // We favor the maker when the exchange rate must be rounded.
4132             matchedFillResults.left.makerAssetFilledAmount = safeGetPartialAmountFloor(
4133                 leftOrder.makerAssetAmount,
4134                 leftOrder.takerAssetAmount,
4135                 matchedFillResults.left.takerAssetFilledAmount
4136             );
4137         } else {
4138             // Case 2: Left order is fully filled
4139             matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
4140             matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
4141             matchedFillResults.right.makerAssetFilledAmount = matchedFillResults.left.takerAssetFilledAmount;
4142             // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.
4143             // We favor the maker when the exchange rate must be rounded.
4144             matchedFillResults.right.takerAssetFilledAmount = safeGetPartialAmountCeil(
4145                 rightOrder.takerAssetAmount,
4146                 rightOrder.makerAssetAmount,
4147                 matchedFillResults.right.makerAssetFilledAmount
4148             );
4149         }
4150 
4151         // Calculate amount given to taker
4152         matchedFillResults.leftMakerAssetSpreadAmount = matchedFillResults.left.makerAssetFilledAmount.safeSub(
4153             matchedFillResults.right.takerAssetFilledAmount
4154         );
4155 
4156         // Compute fees for left order
4157         matchedFillResults.left.makerFeePaid = safeGetPartialAmountFloor(
4158             matchedFillResults.left.makerAssetFilledAmount,
4159             leftOrder.makerAssetAmount,
4160             leftOrder.makerFee
4161         );
4162         matchedFillResults.left.takerFeePaid = safeGetPartialAmountFloor(
4163             matchedFillResults.left.takerAssetFilledAmount,
4164             leftOrder.takerAssetAmount,
4165             leftOrder.takerFee
4166         );
4167 
4168         // Compute fees for right order
4169         matchedFillResults.right.makerFeePaid = safeGetPartialAmountFloor(
4170             matchedFillResults.right.makerAssetFilledAmount,
4171             rightOrder.makerAssetAmount,
4172             rightOrder.makerFee
4173         );
4174         matchedFillResults.right.takerFeePaid = safeGetPartialAmountFloor(
4175             matchedFillResults.right.takerAssetFilledAmount,
4176             rightOrder.takerAssetAmount,
4177             rightOrder.takerFee
4178         );
4179 
4180         // Return fill results
4181         return matchedFillResults;
4182     }
4183 
4184     /// @dev Settles matched order by transferring appropriate funds between order makers, taker, and fee recipient.
4185     /// @param leftOrder First matched order.
4186     /// @param rightOrder Second matched order.
4187     /// @param takerAddress Address that matched the orders. The taker receives the spread between orders as profit.
4188     /// @param matchedFillResults Struct holding amounts to transfer between makers, taker, and fee recipients.
4189     function settleMatchedOrders(
4190         LibOrder.Order memory leftOrder,
4191         LibOrder.Order memory rightOrder,
4192         address payable takerAddress,
4193         LibFillResults.MatchedFillResults memory matchedFillResults
4194     )
4195         private
4196     {
4197         bytes memory ethAssetData = ETH_ASSET_DATA;
4198 
4199         // Order makers and taker
4200         dispatchTransferFrom(
4201             leftOrder.makerAssetData,
4202             leftOrder.makerAddress,
4203             rightOrder.makerAddress,
4204             matchedFillResults.right.takerAssetFilledAmount
4205         );
4206         dispatchTransferFrom(
4207             rightOrder.makerAssetData,
4208             rightOrder.makerAddress,
4209             leftOrder.makerAddress,
4210             matchedFillResults.left.takerAssetFilledAmount
4211         );
4212         dispatchTransferFrom(
4213             leftOrder.makerAssetData,
4214             leftOrder.makerAddress,
4215             takerAddress,
4216             matchedFillResults.leftMakerAssetSpreadAmount
4217         );
4218 
4219         // Maker fees
4220         dispatchTransferFrom(
4221             ethAssetData,
4222             leftOrder.makerAddress,
4223             leftOrder.feeRecipientAddress,
4224             matchedFillResults.left.makerFeePaid
4225         );
4226         dispatchTransferFrom(
4227             ethAssetData,
4228             rightOrder.makerAddress,
4229             rightOrder.feeRecipientAddress,
4230             matchedFillResults.right.makerFeePaid
4231         );
4232 
4233         // Taker fees
4234         if (leftOrder.feeRecipientAddress == rightOrder.feeRecipientAddress) {
4235             dispatchTransferFrom(
4236                 ethAssetData,
4237                 takerAddress,
4238                 leftOrder.feeRecipientAddress,
4239                 matchedFillResults.left.takerFeePaid.safeAdd(
4240                     matchedFillResults.right.takerFeePaid
4241                 )
4242             );
4243         } else {
4244             dispatchTransferFrom(
4245                 ethAssetData,
4246                 takerAddress,
4247                 leftOrder.feeRecipientAddress,
4248                 matchedFillResults.left.takerFeePaid
4249             );
4250             dispatchTransferFrom(
4251                 ethAssetData,
4252                 takerAddress,
4253                 rightOrder.feeRecipientAddress,
4254                 matchedFillResults.right.takerFeePaid
4255             );
4256         }
4257     }
4258 }
4259 
4260 // File: contracts/exchange/Exchange.sol
4261 
4262 /*
4263 
4264   Modified by Metaps Alpha Inc.
4265 
4266   Copyright 2018 ZeroEx Intl.
4267 
4268   Licensed under the Apache License, Version 2.0 (the "License");
4269   you may not use this file except in compliance with the License.
4270   You may obtain a copy of the License at
4271 
4272     http://www.apache.org/licenses/LICENSE-2.0
4273 
4274   Unless required by applicable law or agreed to in writing, software
4275   distributed under the License is distributed on an "AS IS" BASIS,
4276   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
4277   See the License for the specific language governing permissions and
4278   limitations under the License.
4279 
4280 */
4281 
4282 pragma solidity 0.5.16;
4283 
4284 
4285 // solhint-disable no-empty-blocks
4286 contract Exchange is
4287     MixinExchangeCore,
4288     MixinMatchOrders,
4289     MixinSignatureValidator,
4290     MixinTransactions,
4291     MixinWrapperFunctions,
4292     MixinAssetProxyDispatcher
4293 {
4294     string constant public VERSION = "2.1.0-alpha-miime";
4295 
4296     // Mixins are instantiated in the order they are inherited
4297     constructor ()
4298         public
4299         MixinExchangeCore()
4300         MixinMatchOrders()
4301         MixinSignatureValidator()
4302         MixinTransactions()
4303         MixinAssetProxyDispatcher()
4304         MixinWrapperFunctions()
4305     {}
4306 }