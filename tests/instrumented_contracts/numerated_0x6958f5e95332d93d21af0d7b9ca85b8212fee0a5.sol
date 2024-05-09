1 pragma solidity ^0.5.9;
2 pragma experimental ABIEncoderV2;
3 
4 /*
5 
6   Copyright 2019 ZeroEx Intl.
7 
8   Licensed under the Apache License, Version 2.0 (the "License");
9   you may not use this file except in compliance with the License.
10   You may obtain a copy of the License at
11 
12     http://www.apache.org/licenses/LICENSE-2.0
13 
14   Unless required by applicable law or agreed to in writing, software
15   distributed under the License is distributed on an "AS IS" BASIS,
16   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
17   See the License for the specific language governing permissions and
18   limitations under the License.
19 
20 */
21 
22 // solhint-disable
23 
24 // @dev Interface of the asset proxy's assetData.
25 // The asset proxies take an ABI encoded `bytes assetData` as argument.
26 // This argument is ABI encoded as one of the methods of this interface.
27 interface IAssetData {
28 
29     /// @dev Function signature for encoding ERC20 assetData.
30     /// @param tokenAddress Address of ERC20Token contract.
31     function ERC20Token(address tokenAddress)
32         external;
33 
34     /// @dev Function signature for encoding ERC721 assetData.
35     /// @param tokenAddress Address of ERC721 token contract.
36     /// @param tokenId Id of ERC721 token to be transferred.
37     function ERC721Token(
38         address tokenAddress,
39         uint256 tokenId
40     )
41         external;
42 
43     /// @dev Function signature for encoding ERC1155 assetData.
44     /// @param tokenAddress Address of ERC1155 token contract.
45     /// @param tokenIds Array of ids of tokens to be transferred.
46     /// @param values Array of values that correspond to each token id to be transferred.
47     ///        Note that each value will be multiplied by the amount being filled in the order before transferring.
48     /// @param callbackData Extra data to be passed to receiver's `onERC1155Received` callback function.
49     function ERC1155Assets(
50         address tokenAddress,
51         uint256[] calldata tokenIds,
52         uint256[] calldata values,
53         bytes calldata callbackData
54     )
55         external;
56 
57     /// @dev Function signature for encoding MultiAsset assetData.
58     /// @param values Array of amounts that correspond to each asset to be transferred.
59     ///        Note that each value will be multiplied by the amount being filled in the order before transferring.
60     /// @param nestedAssetData Array of assetData fields that will be be dispatched to their correspnding AssetProxy contract.
61     function MultiAsset(
62         uint256[] calldata values,
63         bytes[] calldata nestedAssetData
64     )
65         external;
66 
67     /// @dev Function signature for encoding StaticCall assetData.
68     /// @param staticCallTargetAddress Address that will execute the staticcall.
69     /// @param staticCallData Data that will be executed via staticcall on the staticCallTargetAddress.
70     /// @param expectedReturnDataHash Keccak-256 hash of the expected staticcall return data.
71     function StaticCall(
72         address staticCallTargetAddress,
73         bytes calldata staticCallData,
74         bytes32 expectedReturnDataHash
75     )
76         external;
77 
78     /// @dev Function signature for encoding ERC20Bridge assetData.
79     /// @param tokenAddress Address of token to transfer.
80     /// @param bridgeAddress Address of the bridge contract.
81     /// @param bridgeData Arbitrary data to be passed to the bridge contract.
82     function ERC20Bridge(
83         address tokenAddress,
84         address bridgeAddress,
85         bytes calldata bridgeData
86     )
87         external;
88 }
89 
90 /*
91 
92   Copyright 2019 ZeroEx Intl.
93 
94   Licensed under the Apache License, Version 2.0 (the "License");
95   you may not use this file except in compliance with the License.
96   You may obtain a copy of the License at
97 
98     http://www.apache.org/licenses/LICENSE-2.0
99 
100   Unless required by applicable law or agreed to in writing, software
101   distributed under the License is distributed on an "AS IS" BASIS,
102   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
103   See the License for the specific language governing permissions and
104   limitations under the License.
105 
106 */
107 
108 /*
109 
110   Copyright 2019 ZeroEx Intl.
111 
112   Licensed under the Apache License, Version 2.0 (the "License");
113   you may not use this file except in compliance with the License.
114   You may obtain a copy of the License at
115 
116     http://www.apache.org/licenses/LICENSE-2.0
117 
118   Unless required by applicable law or agreed to in writing, software
119   distributed under the License is distributed on an "AS IS" BASIS,
120   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
121   See the License for the specific language governing permissions and
122   limitations under the License.
123 
124 */
125 
126 library LibEIP712 {
127 
128     // Hash of the EIP712 Domain Separator Schema
129     // keccak256(abi.encodePacked(
130     //     "EIP712Domain(",
131     //     "string name,",
132     //     "string version,",
133     //     "uint256 chainId,",
134     //     "address verifyingContract",
135     //     ")"
136     // ))
137     bytes32 constant internal _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f;
138 
139     /// @dev Calculates a EIP712 domain separator.
140     /// @param name The EIP712 domain name.
141     /// @param version The EIP712 domain version.
142     /// @param verifyingContract The EIP712 verifying contract.
143     /// @return EIP712 domain separator.
144     function hashEIP712Domain(
145         string memory name,
146         string memory version,
147         uint256 chainId,
148         address verifyingContract
149     )
150         internal
151         pure
152         returns (bytes32 result)
153     {
154         bytes32 schemaHash = _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH;
155 
156         // Assembly for more efficient computing:
157         // keccak256(abi.encodePacked(
158         //     _EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
159         //     keccak256(bytes(name)),
160         //     keccak256(bytes(version)),
161         //     chainId,
162         //     uint256(verifyingContract)
163         // ))
164 
165         assembly {
166             // Calculate hashes of dynamic data
167             let nameHash := keccak256(add(name, 32), mload(name))
168             let versionHash := keccak256(add(version, 32), mload(version))
169 
170             // Load free memory pointer
171             let memPtr := mload(64)
172 
173             // Store params in memory
174             mstore(memPtr, schemaHash)
175             mstore(add(memPtr, 32), nameHash)
176             mstore(add(memPtr, 64), versionHash)
177             mstore(add(memPtr, 96), chainId)
178             mstore(add(memPtr, 128), verifyingContract)
179 
180             // Compute hash
181             result := keccak256(memPtr, 160)
182         }
183         return result;
184     }
185 
186     /// @dev Calculates EIP712 encoding for a hash struct with a given domain hash.
187     /// @param eip712DomainHash Hash of the domain domain separator data, computed
188     ///                         with getDomainHash().
189     /// @param hashStruct The EIP712 hash struct.
190     /// @return EIP712 hash applied to the given EIP712 Domain.
191     function hashEIP712Message(bytes32 eip712DomainHash, bytes32 hashStruct)
192         internal
193         pure
194         returns (bytes32 result)
195     {
196         // Assembly for more efficient computing:
197         // keccak256(abi.encodePacked(
198         //     EIP191_HEADER,
199         //     EIP712_DOMAIN_HASH,
200         //     hashStruct
201         // ));
202 
203         assembly {
204             // Load free memory pointer
205             let memPtr := mload(64)
206 
207             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
208             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
209             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
210 
211             // Compute hash
212             result := keccak256(memPtr, 66)
213         }
214         return result;
215     }
216 }
217 
218 library LibOrder {
219 
220     using LibOrder for Order;
221 
222     // Hash for the EIP712 Order Schema:
223     // keccak256(abi.encodePacked(
224     //     "Order(",
225     //     "address makerAddress,",
226     //     "address takerAddress,",
227     //     "address feeRecipientAddress,",
228     //     "address senderAddress,",
229     //     "uint256 makerAssetAmount,",
230     //     "uint256 takerAssetAmount,",
231     //     "uint256 makerFee,",
232     //     "uint256 takerFee,",
233     //     "uint256 expirationTimeSeconds,",
234     //     "uint256 salt,",
235     //     "bytes makerAssetData,",
236     //     "bytes takerAssetData,",
237     //     "bytes makerFeeAssetData,",
238     //     "bytes takerFeeAssetData",
239     //     ")"
240     // ))
241     bytes32 constant internal _EIP712_ORDER_SCHEMA_HASH =
242         0xf80322eb8376aafb64eadf8f0d7623f22130fd9491a221e902b713cb984a7534;
243 
244     // A valid order remains fillable until it is expired, fully filled, or cancelled.
245     // An order's status is unaffected by external factors, like account balances.
246     enum OrderStatus {
247         INVALID,                     // Default value
248         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
249         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
250         FILLABLE,                    // Order is fillable
251         EXPIRED,                     // Order has already expired
252         FULLY_FILLED,                // Order is fully filled
253         CANCELLED                    // Order has been cancelled
254     }
255 
256     // solhint-disable max-line-length
257     /// @dev Canonical order structure.
258     struct Order {
259         address makerAddress;           // Address that created the order.
260         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
261         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
262         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
263         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
264         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
265         uint256 makerFee;               // Fee paid to feeRecipient by maker when order is filled.
266         uint256 takerFee;               // Fee paid to feeRecipient by taker when order is filled.
267         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
268         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
269         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The leading bytes4 references the id of the asset proxy.
270         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The leading bytes4 references the id of the asset proxy.
271         bytes makerFeeAssetData;        // Encoded data that can be decoded by a specified proxy contract when transferring makerFeeAsset. The leading bytes4 references the id of the asset proxy.
272         bytes takerFeeAssetData;        // Encoded data that can be decoded by a specified proxy contract when transferring takerFeeAsset. The leading bytes4 references the id of the asset proxy.
273     }
274     // solhint-enable max-line-length
275 
276     /// @dev Order information returned by `getOrderInfo()`.
277     struct OrderInfo {
278         OrderStatus orderStatus;                    // Status that describes order's validity and fillability.
279         bytes32 orderHash;                    // EIP712 typed data hash of the order (see LibOrder.getTypedDataHash).
280         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
281     }
282 
283     /// @dev Calculates the EIP712 typed data hash of an order with a given domain separator.
284     /// @param order The order structure.
285     /// @return EIP712 typed data hash of the order.
286     function getTypedDataHash(Order memory order, bytes32 eip712ExchangeDomainHash)
287         internal
288         pure
289         returns (bytes32 orderHash)
290     {
291         orderHash = LibEIP712.hashEIP712Message(
292             eip712ExchangeDomainHash,
293             order.getStructHash()
294         );
295         return orderHash;
296     }
297 
298     /// @dev Calculates EIP712 hash of the order struct.
299     /// @param order The order structure.
300     /// @return EIP712 hash of the order struct.
301     function getStructHash(Order memory order)
302         internal
303         pure
304         returns (bytes32 result)
305     {
306         bytes32 schemaHash = _EIP712_ORDER_SCHEMA_HASH;
307         bytes memory makerAssetData = order.makerAssetData;
308         bytes memory takerAssetData = order.takerAssetData;
309         bytes memory makerFeeAssetData = order.makerFeeAssetData;
310         bytes memory takerFeeAssetData = order.takerFeeAssetData;
311 
312         // Assembly for more efficiently computing:
313         // keccak256(abi.encodePacked(
314         //     EIP712_ORDER_SCHEMA_HASH,
315         //     uint256(order.makerAddress),
316         //     uint256(order.takerAddress),
317         //     uint256(order.feeRecipientAddress),
318         //     uint256(order.senderAddress),
319         //     order.makerAssetAmount,
320         //     order.takerAssetAmount,
321         //     order.makerFee,
322         //     order.takerFee,
323         //     order.expirationTimeSeconds,
324         //     order.salt,
325         //     keccak256(order.makerAssetData),
326         //     keccak256(order.takerAssetData),
327         //     keccak256(order.makerFeeAssetData),
328         //     keccak256(order.takerFeeAssetData)
329         // ));
330 
331         assembly {
332             // Assert order offset (this is an internal error that should never be triggered)
333             if lt(order, 32) {
334                 invalid()
335             }
336 
337             // Calculate memory addresses that will be swapped out before hashing
338             let pos1 := sub(order, 32)
339             let pos2 := add(order, 320)
340             let pos3 := add(order, 352)
341             let pos4 := add(order, 384)
342             let pos5 := add(order, 416)
343 
344             // Backup
345             let temp1 := mload(pos1)
346             let temp2 := mload(pos2)
347             let temp3 := mload(pos3)
348             let temp4 := mload(pos4)
349             let temp5 := mload(pos5)
350 
351             // Hash in place
352             mstore(pos1, schemaHash)
353             mstore(pos2, keccak256(add(makerAssetData, 32), mload(makerAssetData)))        // store hash of makerAssetData
354             mstore(pos3, keccak256(add(takerAssetData, 32), mload(takerAssetData)))        // store hash of takerAssetData
355             mstore(pos4, keccak256(add(makerFeeAssetData, 32), mload(makerFeeAssetData)))  // store hash of makerFeeAssetData
356             mstore(pos5, keccak256(add(takerFeeAssetData, 32), mload(takerFeeAssetData)))  // store hash of takerFeeAssetData
357             result := keccak256(pos1, 480)
358 
359             // Restore
360             mstore(pos1, temp1)
361             mstore(pos2, temp2)
362             mstore(pos3, temp3)
363             mstore(pos4, temp4)
364             mstore(pos5, temp5)
365         }
366         return result;
367     }
368 }
369 
370 /*
371 
372   Copyright 2019 ZeroEx Intl.
373 
374   Licensed under the Apache License, Version 2.0 (the "License");
375   you may not use this file except in compliance with the License.
376   You may obtain a copy of the License at
377 
378     http://www.apache.org/licenses/LICENSE-2.0
379 
380   Unless required by applicable law or agreed to in writing, software
381   distributed under the License is distributed on an "AS IS" BASIS,
382   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
383   See the License for the specific language governing permissions and
384   limitations under the License.
385 
386 */
387 
388 /*
389 
390   Copyright 2019 ZeroEx Intl.
391 
392   Licensed under the Apache License, Version 2.0 (the "License");
393   you may not use this file except in compliance with the License.
394   You may obtain a copy of the License at
395 
396     http://www.apache.org/licenses/LICENSE-2.0
397 
398   Unless required by applicable law or agreed to in writing, software
399   distributed under the License is distributed on an "AS IS" BASIS,
400   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
401   See the License for the specific language governing permissions and
402   limitations under the License.
403 
404 */
405 
406 library LibRichErrors {
407 
408     // bytes4(keccak256("Error(string)"))
409     bytes4 internal constant STANDARD_ERROR_SELECTOR =
410         0x08c379a0;
411 
412     // solhint-disable func-name-mixedcase
413     /// @dev ABI encode a standard, string revert error payload.
414     ///      This is the same payload that would be included by a `revert(string)`
415     ///      solidity statement. It has the function signature `Error(string)`.
416     /// @param message The error string.
417     /// @return The ABI encoded error.
418     function StandardError(
419         string memory message
420     )
421         internal
422         pure
423         returns (bytes memory)
424     {
425         return abi.encodeWithSelector(
426             STANDARD_ERROR_SELECTOR,
427             bytes(message)
428         );
429     }
430     // solhint-enable func-name-mixedcase
431 
432     /// @dev Reverts an encoded rich revert reason `errorData`.
433     /// @param errorData ABI encoded error data.
434     function rrevert(bytes memory errorData)
435         internal
436         pure
437     {
438         assembly {
439             revert(add(errorData, 0x20), mload(errorData))
440         }
441     }
442 }
443 
444 library LibSafeMathRichErrors {
445 
446     // bytes4(keccak256("Uint256BinOpError(uint8,uint256,uint256)"))
447     bytes4 internal constant UINT256_BINOP_ERROR_SELECTOR =
448         0xe946c1bb;
449 
450     // bytes4(keccak256("Uint256DowncastError(uint8,uint256)"))
451     bytes4 internal constant UINT256_DOWNCAST_ERROR_SELECTOR =
452         0xc996af7b;
453 
454     enum BinOpErrorCodes {
455         ADDITION_OVERFLOW,
456         MULTIPLICATION_OVERFLOW,
457         SUBTRACTION_UNDERFLOW,
458         DIVISION_BY_ZERO
459     }
460 
461     enum DowncastErrorCodes {
462         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT32,
463         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT64,
464         VALUE_TOO_LARGE_TO_DOWNCAST_TO_UINT96
465     }
466 
467     // solhint-disable func-name-mixedcase
468     function Uint256BinOpError(
469         BinOpErrorCodes errorCode,
470         uint256 a,
471         uint256 b
472     )
473         internal
474         pure
475         returns (bytes memory)
476     {
477         return abi.encodeWithSelector(
478             UINT256_BINOP_ERROR_SELECTOR,
479             errorCode,
480             a,
481             b
482         );
483     }
484 
485     function Uint256DowncastError(
486         DowncastErrorCodes errorCode,
487         uint256 a
488     )
489         internal
490         pure
491         returns (bytes memory)
492     {
493         return abi.encodeWithSelector(
494             UINT256_DOWNCAST_ERROR_SELECTOR,
495             errorCode,
496             a
497         );
498     }
499 }
500 
501 library LibSafeMath {
502 
503     function safeMul(uint256 a, uint256 b)
504         internal
505         pure
506         returns (uint256)
507     {
508         if (a == 0) {
509             return 0;
510         }
511         uint256 c = a * b;
512         if (c / a != b) {
513             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
514                 LibSafeMathRichErrors.BinOpErrorCodes.MULTIPLICATION_OVERFLOW,
515                 a,
516                 b
517             ));
518         }
519         return c;
520     }
521 
522     function safeDiv(uint256 a, uint256 b)
523         internal
524         pure
525         returns (uint256)
526     {
527         if (b == 0) {
528             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
529                 LibSafeMathRichErrors.BinOpErrorCodes.DIVISION_BY_ZERO,
530                 a,
531                 b
532             ));
533         }
534         uint256 c = a / b;
535         return c;
536     }
537 
538     function safeSub(uint256 a, uint256 b)
539         internal
540         pure
541         returns (uint256)
542     {
543         if (b > a) {
544             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
545                 LibSafeMathRichErrors.BinOpErrorCodes.SUBTRACTION_UNDERFLOW,
546                 a,
547                 b
548             ));
549         }
550         return a - b;
551     }
552 
553     function safeAdd(uint256 a, uint256 b)
554         internal
555         pure
556         returns (uint256)
557     {
558         uint256 c = a + b;
559         if (c < a) {
560             LibRichErrors.rrevert(LibSafeMathRichErrors.Uint256BinOpError(
561                 LibSafeMathRichErrors.BinOpErrorCodes.ADDITION_OVERFLOW,
562                 a,
563                 b
564             ));
565         }
566         return c;
567     }
568 
569     function max256(uint256 a, uint256 b)
570         internal
571         pure
572         returns (uint256)
573     {
574         return a >= b ? a : b;
575     }
576 
577     function min256(uint256 a, uint256 b)
578         internal
579         pure
580         returns (uint256)
581     {
582         return a < b ? a : b;
583     }
584 }
585 
586 library LibMathRichErrors {
587 
588     // bytes4(keccak256("DivisionByZeroError()"))
589     bytes internal constant DIVISION_BY_ZERO_ERROR =
590         hex"a791837c";
591 
592     // bytes4(keccak256("RoundingError(uint256,uint256,uint256)"))
593     bytes4 internal constant ROUNDING_ERROR_SELECTOR =
594         0x339f3de2;
595 
596     // solhint-disable func-name-mixedcase
597     function DivisionByZeroError()
598         internal
599         pure
600         returns (bytes memory)
601     {
602         return DIVISION_BY_ZERO_ERROR;
603     }
604 
605     function RoundingError(
606         uint256 numerator,
607         uint256 denominator,
608         uint256 target
609     )
610         internal
611         pure
612         returns (bytes memory)
613     {
614         return abi.encodeWithSelector(
615             ROUNDING_ERROR_SELECTOR,
616             numerator,
617             denominator,
618             target
619         );
620     }
621 }
622 
623 library LibMath {
624 
625     using LibSafeMath for uint256;
626 
627     /// @dev Calculates partial value given a numerator and denominator rounded down.
628     ///      Reverts if rounding error is >= 0.1%
629     /// @param numerator Numerator.
630     /// @param denominator Denominator.
631     /// @param target Value to calculate partial of.
632     /// @return Partial value of target rounded down.
633     function safeGetPartialAmountFloor(
634         uint256 numerator,
635         uint256 denominator,
636         uint256 target
637     )
638         internal
639         pure
640         returns (uint256 partialAmount)
641     {
642         if (isRoundingErrorFloor(
643                 numerator,
644                 denominator,
645                 target
646         )) {
647             LibRichErrors.rrevert(LibMathRichErrors.RoundingError(
648                 numerator,
649                 denominator,
650                 target
651             ));
652         }
653 
654         partialAmount = numerator.safeMul(target).safeDiv(denominator);
655         return partialAmount;
656     }
657 
658     /// @dev Calculates partial value given a numerator and denominator rounded down.
659     ///      Reverts if rounding error is >= 0.1%
660     /// @param numerator Numerator.
661     /// @param denominator Denominator.
662     /// @param target Value to calculate partial of.
663     /// @return Partial value of target rounded up.
664     function safeGetPartialAmountCeil(
665         uint256 numerator,
666         uint256 denominator,
667         uint256 target
668     )
669         internal
670         pure
671         returns (uint256 partialAmount)
672     {
673         if (isRoundingErrorCeil(
674                 numerator,
675                 denominator,
676                 target
677         )) {
678             LibRichErrors.rrevert(LibMathRichErrors.RoundingError(
679                 numerator,
680                 denominator,
681                 target
682             ));
683         }
684 
685         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
686         //       ceil(a / b) = floor((a + b - 1) / b)
687         // To implement `ceil(a / b)` using safeDiv.
688         partialAmount = numerator.safeMul(target)
689             .safeAdd(denominator.safeSub(1))
690             .safeDiv(denominator);
691 
692         return partialAmount;
693     }
694 
695     /// @dev Calculates partial value given a numerator and denominator rounded down.
696     /// @param numerator Numerator.
697     /// @param denominator Denominator.
698     /// @param target Value to calculate partial of.
699     /// @return Partial value of target rounded down.
700     function getPartialAmountFloor(
701         uint256 numerator,
702         uint256 denominator,
703         uint256 target
704     )
705         internal
706         pure
707         returns (uint256 partialAmount)
708     {
709         partialAmount = numerator.safeMul(target).safeDiv(denominator);
710         return partialAmount;
711     }
712 
713     /// @dev Calculates partial value given a numerator and denominator rounded down.
714     /// @param numerator Numerator.
715     /// @param denominator Denominator.
716     /// @param target Value to calculate partial of.
717     /// @return Partial value of target rounded up.
718     function getPartialAmountCeil(
719         uint256 numerator,
720         uint256 denominator,
721         uint256 target
722     )
723         internal
724         pure
725         returns (uint256 partialAmount)
726     {
727         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
728         //       ceil(a / b) = floor((a + b - 1) / b)
729         // To implement `ceil(a / b)` using safeDiv.
730         partialAmount = numerator.safeMul(target)
731             .safeAdd(denominator.safeSub(1))
732             .safeDiv(denominator);
733 
734         return partialAmount;
735     }
736 
737     /// @dev Checks if rounding error >= 0.1% when rounding down.
738     /// @param numerator Numerator.
739     /// @param denominator Denominator.
740     /// @param target Value to multiply with numerator/denominator.
741     /// @return Rounding error is present.
742     function isRoundingErrorFloor(
743         uint256 numerator,
744         uint256 denominator,
745         uint256 target
746     )
747         internal
748         pure
749         returns (bool isError)
750     {
751         if (denominator == 0) {
752             LibRichErrors.rrevert(LibMathRichErrors.DivisionByZeroError());
753         }
754 
755         // The absolute rounding error is the difference between the rounded
756         // value and the ideal value. The relative rounding error is the
757         // absolute rounding error divided by the absolute value of the
758         // ideal value. This is undefined when the ideal value is zero.
759         //
760         // The ideal value is `numerator * target / denominator`.
761         // Let's call `numerator * target % denominator` the remainder.
762         // The absolute error is `remainder / denominator`.
763         //
764         // When the ideal value is zero, we require the absolute error to
765         // be zero. Fortunately, this is always the case. The ideal value is
766         // zero iff `numerator == 0` and/or `target == 0`. In this case the
767         // remainder and absolute error are also zero.
768         if (target == 0 || numerator == 0) {
769             return false;
770         }
771 
772         // Otherwise, we want the relative rounding error to be strictly
773         // less than 0.1%.
774         // The relative error is `remainder / (numerator * target)`.
775         // We want the relative error less than 1 / 1000:
776         //        remainder / (numerator * denominator)  <  1 / 1000
777         // or equivalently:
778         //        1000 * remainder  <  numerator * target
779         // so we have a rounding error iff:
780         //        1000 * remainder  >=  numerator * target
781         uint256 remainder = mulmod(
782             target,
783             numerator,
784             denominator
785         );
786         isError = remainder.safeMul(1000) >= numerator.safeMul(target);
787         return isError;
788     }
789 
790     /// @dev Checks if rounding error >= 0.1% when rounding up.
791     /// @param numerator Numerator.
792     /// @param denominator Denominator.
793     /// @param target Value to multiply with numerator/denominator.
794     /// @return Rounding error is present.
795     function isRoundingErrorCeil(
796         uint256 numerator,
797         uint256 denominator,
798         uint256 target
799     )
800         internal
801         pure
802         returns (bool isError)
803     {
804         if (denominator == 0) {
805             LibRichErrors.rrevert(LibMathRichErrors.DivisionByZeroError());
806         }
807 
808         // See the comments in `isRoundingError`.
809         if (target == 0 || numerator == 0) {
810             // When either is zero, the ideal value and rounded value are zero
811             // and there is no rounding error. (Although the relative error
812             // is undefined.)
813             return false;
814         }
815         // Compute remainder as before
816         uint256 remainder = mulmod(
817             target,
818             numerator,
819             denominator
820         );
821         remainder = denominator.safeSub(remainder) % denominator;
822         isError = remainder.safeMul(1000) >= numerator.safeMul(target);
823         return isError;
824     }
825 }
826 
827 /*
828 
829   Copyright 2019 ZeroEx Intl.
830 
831   Licensed under the Apache License, Version 2.0 (the "License");
832   you may not use this file except in compliance with the License.
833   You may obtain a copy of the License at
834 
835     http://www.apache.org/licenses/LICENSE-2.0
836 
837   Unless required by applicable law or agreed to in writing, software
838   distributed under the License is distributed on an "AS IS" BASIS,
839   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
840   See the License for the specific language governing permissions and
841   limitations under the License.
842 
843 */
844 
845 /*
846 
847   Copyright 2019 ZeroEx Intl.
848 
849   Licensed under the Apache License, Version 2.0 (the "License");
850   you may not use this file except in compliance with the License.
851   You may obtain a copy of the License at
852 
853     http://www.apache.org/licenses/LICENSE-2.0
854 
855   Unless required by applicable law or agreed to in writing, software
856   distributed under the License is distributed on an "AS IS" BASIS,
857   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
858   See the License for the specific language governing permissions and
859   limitations under the License.
860 
861 */
862 
863 /*
864 
865   Copyright 2019 ZeroEx Intl.
866 
867   Licensed under the Apache License, Version 2.0 (the "License");
868   you may not use this file except in compliance with the License.
869   You may obtain a copy of the License at
870 
871     http://www.apache.org/licenses/LICENSE-2.0
872 
873   Unless required by applicable law or agreed to in writing, software
874   distributed under the License is distributed on an "AS IS" BASIS,
875   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
876   See the License for the specific language governing permissions and
877   limitations under the License.
878 
879 */
880 
881 library LibBytesRichErrors {
882 
883     enum InvalidByteOperationErrorCodes {
884         FromLessThanOrEqualsToRequired,
885         ToLessThanOrEqualsLengthRequired,
886         LengthGreaterThanZeroRequired,
887         LengthGreaterThanOrEqualsFourRequired,
888         LengthGreaterThanOrEqualsTwentyRequired,
889         LengthGreaterThanOrEqualsThirtyTwoRequired,
890         LengthGreaterThanOrEqualsNestedBytesLengthRequired,
891         DestinationLengthGreaterThanOrEqualSourceLengthRequired
892     }
893 
894     // bytes4(keccak256("InvalidByteOperationError(uint8,uint256,uint256)"))
895     bytes4 internal constant INVALID_BYTE_OPERATION_ERROR_SELECTOR =
896         0x28006595;
897 
898     // solhint-disable func-name-mixedcase
899     function InvalidByteOperationError(
900         InvalidByteOperationErrorCodes errorCode,
901         uint256 offset,
902         uint256 required
903     )
904         internal
905         pure
906         returns (bytes memory)
907     {
908         return abi.encodeWithSelector(
909             INVALID_BYTE_OPERATION_ERROR_SELECTOR,
910             errorCode,
911             offset,
912             required
913         );
914     }
915 }
916 
917 library LibBytes {
918 
919     using LibBytes for bytes;
920 
921     /// @dev Gets the memory address for a byte array.
922     /// @param input Byte array to lookup.
923     /// @return memoryAddress Memory address of byte array. This
924     ///         points to the header of the byte array which contains
925     ///         the length.
926     function rawAddress(bytes memory input)
927         internal
928         pure
929         returns (uint256 memoryAddress)
930     {
931         assembly {
932             memoryAddress := input
933         }
934         return memoryAddress;
935     }
936 
937     /// @dev Gets the memory address for the contents of a byte array.
938     /// @param input Byte array to lookup.
939     /// @return memoryAddress Memory address of the contents of the byte array.
940     function contentAddress(bytes memory input)
941         internal
942         pure
943         returns (uint256 memoryAddress)
944     {
945         assembly {
946             memoryAddress := add(input, 32)
947         }
948         return memoryAddress;
949     }
950 
951     /// @dev Copies `length` bytes from memory location `source` to `dest`.
952     /// @param dest memory address to copy bytes to.
953     /// @param source memory address to copy bytes from.
954     /// @param length number of bytes to copy.
955     function memCopy(
956         uint256 dest,
957         uint256 source,
958         uint256 length
959     )
960         internal
961         pure
962     {
963         if (length < 32) {
964             // Handle a partial word by reading destination and masking
965             // off the bits we are interested in.
966             // This correctly handles overlap, zero lengths and source == dest
967             assembly {
968                 let mask := sub(exp(256, sub(32, length)), 1)
969                 let s := and(mload(source), not(mask))
970                 let d := and(mload(dest), mask)
971                 mstore(dest, or(s, d))
972             }
973         } else {
974             // Skip the O(length) loop when source == dest.
975             if (source == dest) {
976                 return;
977             }
978 
979             // For large copies we copy whole words at a time. The final
980             // word is aligned to the end of the range (instead of after the
981             // previous) to handle partial words. So a copy will look like this:
982             //
983             //  ####
984             //      ####
985             //          ####
986             //            ####
987             //
988             // We handle overlap in the source and destination range by
989             // changing the copying direction. This prevents us from
990             // overwriting parts of source that we still need to copy.
991             //
992             // This correctly handles source == dest
993             //
994             if (source > dest) {
995                 assembly {
996                     // We subtract 32 from `sEnd` and `dEnd` because it
997                     // is easier to compare with in the loop, and these
998                     // are also the addresses we need for copying the
999                     // last bytes.
1000                     length := sub(length, 32)
1001                     let sEnd := add(source, length)
1002                     let dEnd := add(dest, length)
1003 
1004                     // Remember the last 32 bytes of source
1005                     // This needs to be done here and not after the loop
1006                     // because we may have overwritten the last bytes in
1007                     // source already due to overlap.
1008                     let last := mload(sEnd)
1009 
1010                     // Copy whole words front to back
1011                     // Note: the first check is always true,
1012                     // this could have been a do-while loop.
1013                     // solhint-disable-next-line no-empty-blocks
1014                     for {} lt(source, sEnd) {} {
1015                         mstore(dest, mload(source))
1016                         source := add(source, 32)
1017                         dest := add(dest, 32)
1018                     }
1019 
1020                     // Write the last 32 bytes
1021                     mstore(dEnd, last)
1022                 }
1023             } else {
1024                 assembly {
1025                     // We subtract 32 from `sEnd` and `dEnd` because those
1026                     // are the starting points when copying a word at the end.
1027                     length := sub(length, 32)
1028                     let sEnd := add(source, length)
1029                     let dEnd := add(dest, length)
1030 
1031                     // Remember the first 32 bytes of source
1032                     // This needs to be done here and not after the loop
1033                     // because we may have overwritten the first bytes in
1034                     // source already due to overlap.
1035                     let first := mload(source)
1036 
1037                     // Copy whole words back to front
1038                     // We use a signed comparisson here to allow dEnd to become
1039                     // negative (happens when source and dest < 32). Valid
1040                     // addresses in local memory will never be larger than
1041                     // 2**255, so they can be safely re-interpreted as signed.
1042                     // Note: the first check is always true,
1043                     // this could have been a do-while loop.
1044                     // solhint-disable-next-line no-empty-blocks
1045                     for {} slt(dest, dEnd) {} {
1046                         mstore(dEnd, mload(sEnd))
1047                         sEnd := sub(sEnd, 32)
1048                         dEnd := sub(dEnd, 32)
1049                     }
1050 
1051                     // Write the first 32 bytes
1052                     mstore(dest, first)
1053                 }
1054             }
1055         }
1056     }
1057 
1058     /// @dev Returns a slices from a byte array.
1059     /// @param b The byte array to take a slice from.
1060     /// @param from The starting index for the slice (inclusive).
1061     /// @param to The final index for the slice (exclusive).
1062     /// @return result The slice containing bytes at indices [from, to)
1063     function slice(
1064         bytes memory b,
1065         uint256 from,
1066         uint256 to
1067     )
1068         internal
1069         pure
1070         returns (bytes memory result)
1071     {
1072         // Ensure that the from and to positions are valid positions for a slice within
1073         // the byte array that is being used.
1074         if (from > to) {
1075             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1076                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
1077                 from,
1078                 to
1079             ));
1080         }
1081         if (to > b.length) {
1082             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1083                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
1084                 to,
1085                 b.length
1086             ));
1087         }
1088 
1089         // Create a new bytes structure and copy contents
1090         result = new bytes(to - from);
1091         memCopy(
1092             result.contentAddress(),
1093             b.contentAddress() + from,
1094             result.length
1095         );
1096         return result;
1097     }
1098 
1099     /// @dev Returns a slice from a byte array without preserving the input.
1100     /// @param b The byte array to take a slice from. Will be destroyed in the process.
1101     /// @param from The starting index for the slice (inclusive).
1102     /// @param to The final index for the slice (exclusive).
1103     /// @return result The slice containing bytes at indices [from, to)
1104     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
1105     function sliceDestructive(
1106         bytes memory b,
1107         uint256 from,
1108         uint256 to
1109     )
1110         internal
1111         pure
1112         returns (bytes memory result)
1113     {
1114         // Ensure that the from and to positions are valid positions for a slice within
1115         // the byte array that is being used.
1116         if (from > to) {
1117             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1118                 LibBytesRichErrors.InvalidByteOperationErrorCodes.FromLessThanOrEqualsToRequired,
1119                 from,
1120                 to
1121             ));
1122         }
1123         if (to > b.length) {
1124             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1125                 LibBytesRichErrors.InvalidByteOperationErrorCodes.ToLessThanOrEqualsLengthRequired,
1126                 to,
1127                 b.length
1128             ));
1129         }
1130 
1131         // Create a new bytes structure around [from, to) in-place.
1132         assembly {
1133             result := add(b, from)
1134             mstore(result, sub(to, from))
1135         }
1136         return result;
1137     }
1138 
1139     /// @dev Pops the last byte off of a byte array by modifying its length.
1140     /// @param b Byte array that will be modified.
1141     /// @return The byte that was popped off.
1142     function popLastByte(bytes memory b)
1143         internal
1144         pure
1145         returns (bytes1 result)
1146     {
1147         if (b.length == 0) {
1148             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1149                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanZeroRequired,
1150                 b.length,
1151                 0
1152             ));
1153         }
1154 
1155         // Store last byte.
1156         result = b[b.length - 1];
1157 
1158         assembly {
1159             // Decrement length of byte array.
1160             let newLen := sub(mload(b), 1)
1161             mstore(b, newLen)
1162         }
1163         return result;
1164     }
1165 
1166     /// @dev Tests equality of two byte arrays.
1167     /// @param lhs First byte array to compare.
1168     /// @param rhs Second byte array to compare.
1169     /// @return True if arrays are the same. False otherwise.
1170     function equals(
1171         bytes memory lhs,
1172         bytes memory rhs
1173     )
1174         internal
1175         pure
1176         returns (bool equal)
1177     {
1178         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
1179         // We early exit on unequal lengths, but keccak would also correctly
1180         // handle this.
1181         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
1182     }
1183 
1184     /// @dev Reads an address from a position in a byte array.
1185     /// @param b Byte array containing an address.
1186     /// @param index Index in byte array of address.
1187     /// @return address from byte array.
1188     function readAddress(
1189         bytes memory b,
1190         uint256 index
1191     )
1192         internal
1193         pure
1194         returns (address result)
1195     {
1196         if (b.length < index + 20) {
1197             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1198                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
1199                 b.length,
1200                 index + 20 // 20 is length of address
1201             ));
1202         }
1203 
1204         // Add offset to index:
1205         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
1206         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
1207         index += 20;
1208 
1209         // Read address from array memory
1210         assembly {
1211             // 1. Add index to address of bytes array
1212             // 2. Load 32-byte word from memory
1213             // 3. Apply 20-byte mask to obtain address
1214             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1215         }
1216         return result;
1217     }
1218 
1219     /// @dev Writes an address into a specific position in a byte array.
1220     /// @param b Byte array to insert address into.
1221     /// @param index Index in byte array of address.
1222     /// @param input Address to put into byte array.
1223     function writeAddress(
1224         bytes memory b,
1225         uint256 index,
1226         address input
1227     )
1228         internal
1229         pure
1230     {
1231         if (b.length < index + 20) {
1232             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1233                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsTwentyRequired,
1234                 b.length,
1235                 index + 20 // 20 is length of address
1236             ));
1237         }
1238 
1239         // Add offset to index:
1240         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
1241         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
1242         index += 20;
1243 
1244         // Store address into array memory
1245         assembly {
1246             // The address occupies 20 bytes and mstore stores 32 bytes.
1247             // First fetch the 32-byte word where we'll be storing the address, then
1248             // apply a mask so we have only the bytes in the word that the address will not occupy.
1249             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
1250 
1251             // 1. Add index to address of bytes array
1252             // 2. Load 32-byte word from memory
1253             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
1254             let neighbors := and(
1255                 mload(add(b, index)),
1256                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
1257             )
1258 
1259             // Make sure input address is clean.
1260             // (Solidity does not guarantee this)
1261             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
1262 
1263             // Store the neighbors and address into memory
1264             mstore(add(b, index), xor(input, neighbors))
1265         }
1266     }
1267 
1268     /// @dev Reads a bytes32 value from a position in a byte array.
1269     /// @param b Byte array containing a bytes32 value.
1270     /// @param index Index in byte array of bytes32 value.
1271     /// @return bytes32 value from byte array.
1272     function readBytes32(
1273         bytes memory b,
1274         uint256 index
1275     )
1276         internal
1277         pure
1278         returns (bytes32 result)
1279     {
1280         if (b.length < index + 32) {
1281             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1282                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
1283                 b.length,
1284                 index + 32
1285             ));
1286         }
1287 
1288         // Arrays are prefixed by a 256 bit length parameter
1289         index += 32;
1290 
1291         // Read the bytes32 from array memory
1292         assembly {
1293             result := mload(add(b, index))
1294         }
1295         return result;
1296     }
1297 
1298     /// @dev Writes a bytes32 into a specific position in a byte array.
1299     /// @param b Byte array to insert <input> into.
1300     /// @param index Index in byte array of <input>.
1301     /// @param input bytes32 to put into byte array.
1302     function writeBytes32(
1303         bytes memory b,
1304         uint256 index,
1305         bytes32 input
1306     )
1307         internal
1308         pure
1309     {
1310         if (b.length < index + 32) {
1311             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1312                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsThirtyTwoRequired,
1313                 b.length,
1314                 index + 32
1315             ));
1316         }
1317 
1318         // Arrays are prefixed by a 256 bit length parameter
1319         index += 32;
1320 
1321         // Read the bytes32 from array memory
1322         assembly {
1323             mstore(add(b, index), input)
1324         }
1325     }
1326 
1327     /// @dev Reads a uint256 value from a position in a byte array.
1328     /// @param b Byte array containing a uint256 value.
1329     /// @param index Index in byte array of uint256 value.
1330     /// @return uint256 value from byte array.
1331     function readUint256(
1332         bytes memory b,
1333         uint256 index
1334     )
1335         internal
1336         pure
1337         returns (uint256 result)
1338     {
1339         result = uint256(readBytes32(b, index));
1340         return result;
1341     }
1342 
1343     /// @dev Writes a uint256 into a specific position in a byte array.
1344     /// @param b Byte array to insert <input> into.
1345     /// @param index Index in byte array of <input>.
1346     /// @param input uint256 to put into byte array.
1347     function writeUint256(
1348         bytes memory b,
1349         uint256 index,
1350         uint256 input
1351     )
1352         internal
1353         pure
1354     {
1355         writeBytes32(b, index, bytes32(input));
1356     }
1357 
1358     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
1359     /// @param b Byte array containing a bytes4 value.
1360     /// @param index Index in byte array of bytes4 value.
1361     /// @return bytes4 value from byte array.
1362     function readBytes4(
1363         bytes memory b,
1364         uint256 index
1365     )
1366         internal
1367         pure
1368         returns (bytes4 result)
1369     {
1370         if (b.length < index + 4) {
1371             LibRichErrors.rrevert(LibBytesRichErrors.InvalidByteOperationError(
1372                 LibBytesRichErrors.InvalidByteOperationErrorCodes.LengthGreaterThanOrEqualsFourRequired,
1373                 b.length,
1374                 index + 4
1375             ));
1376         }
1377 
1378         // Arrays are prefixed by a 32 byte length field
1379         index += 32;
1380 
1381         // Read the bytes4 from array memory
1382         assembly {
1383             result := mload(add(b, index))
1384             // Solidity does not require us to clean the trailing bytes.
1385             // We do it anyway
1386             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
1387         }
1388         return result;
1389     }
1390 
1391     /// @dev Writes a new length to a byte array.
1392     ///      Decreasing length will lead to removing the corresponding lower order bytes from the byte array.
1393     ///      Increasing length may lead to appending adjacent in-memory bytes to the end of the byte array.
1394     /// @param b Bytes array to write new length to.
1395     /// @param length New length of byte array.
1396     function writeLength(bytes memory b, uint256 length)
1397         internal
1398         pure
1399     {
1400         assembly {
1401             mstore(b, length)
1402         }
1403     }
1404 }
1405 
1406 /*
1407 
1408   Copyright 2019 ZeroEx Intl.
1409 
1410   Licensed under the Apache License, Version 2.0 (the "License");
1411   you may not use this file except in compliance with the License.
1412   You may obtain a copy of the License at
1413 
1414     http://www.apache.org/licenses/LICENSE-2.0
1415 
1416   Unless required by applicable law or agreed to in writing, software
1417   distributed under the License is distributed on an "AS IS" BASIS,
1418   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1419   See the License for the specific language governing permissions and
1420   limitations under the License.
1421 
1422 */
1423 
1424 /*
1425 
1426   Copyright 2019 ZeroEx Intl.
1427 
1428   Licensed under the Apache License, Version 2.0 (the "License");
1429   you may not use this file except in compliance with the License.
1430   You may obtain a copy of the License at
1431 
1432     http://www.apache.org/licenses/LICENSE-2.0
1433 
1434   Unless required by applicable law or agreed to in writing, software
1435   distributed under the License is distributed on an "AS IS" BASIS,
1436   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1437   See the License for the specific language governing permissions and
1438   limitations under the License.
1439 
1440 */
1441 
1442 contract IERC20Token {
1443 
1444     // solhint-disable no-simple-event-func-name
1445     event Transfer(
1446         address indexed _from,
1447         address indexed _to,
1448         uint256 _value
1449     );
1450 
1451     event Approval(
1452         address indexed _owner,
1453         address indexed _spender,
1454         uint256 _value
1455     );
1456 
1457     /// @dev send `value` token to `to` from `msg.sender`
1458     /// @param _to The address of the recipient
1459     /// @param _value The amount of token to be transferred
1460     /// @return True if transfer was successful
1461     function transfer(address _to, uint256 _value)
1462         external
1463         returns (bool);
1464 
1465     /// @dev send `value` token to `to` from `from` on the condition it is approved by `from`
1466     /// @param _from The address of the sender
1467     /// @param _to The address of the recipient
1468     /// @param _value The amount of token to be transferred
1469     /// @return True if transfer was successful
1470     function transferFrom(
1471         address _from,
1472         address _to,
1473         uint256 _value
1474     )
1475         external
1476         returns (bool);
1477 
1478     /// @dev `msg.sender` approves `_spender` to spend `_value` tokens
1479     /// @param _spender The address of the account able to transfer the tokens
1480     /// @param _value The amount of wei to be approved for transfer
1481     /// @return Always true if the call has enough gas to complete execution
1482     function approve(address _spender, uint256 _value)
1483         external
1484         returns (bool);
1485 
1486     /// @dev Query total supply of token
1487     /// @return Total supply of token
1488     function totalSupply()
1489         external
1490         view
1491         returns (uint256);
1492 
1493     /// @param _owner The address from which the balance will be retrieved
1494     /// @return Balance of owner
1495     function balanceOf(address _owner)
1496         external
1497         view
1498         returns (uint256);
1499 
1500     /// @param _owner The address of the account owning tokens
1501     /// @param _spender The address of the account able to transfer the tokens
1502     /// @return Amount of remaining tokens allowed to spent
1503     function allowance(address _owner, address _spender)
1504         external
1505         view
1506         returns (uint256);
1507 }
1508 
1509 library LibERC20Token {
1510     bytes constant private DECIMALS_CALL_DATA = hex"313ce567";
1511 
1512     /// @dev Calls `IERC20Token(token).approve()`.
1513     ///      Reverts if `false` is returned or if the return
1514     ///      data length is nonzero and not 32 bytes.
1515     /// @param token The address of the token contract.
1516     /// @param spender The address that receives an allowance.
1517     /// @param allowance The allowance to set.
1518     function approve(
1519         address token,
1520         address spender,
1521         uint256 allowance
1522     )
1523         internal
1524     {
1525         bytes memory callData = abi.encodeWithSelector(
1526             IERC20Token(0).approve.selector,
1527             spender,
1528             allowance
1529         );
1530         _callWithOptionalBooleanResult(token, callData);
1531     }
1532 
1533     /// @dev Calls `IERC20Token(token).approve()` and sets the allowance to the
1534     ///      maximum if the current approval is not already >= an amount.
1535     ///      Reverts if `false` is returned or if the return
1536     ///      data length is nonzero and not 32 bytes.
1537     /// @param token The address of the token contract.
1538     /// @param spender The address that receives an allowance.
1539     /// @param amount The minimum allowance needed.
1540     function approveIfBelow(
1541         address token,
1542         address spender,
1543         uint256 amount
1544     )
1545         internal
1546     {
1547         if (IERC20Token(token).allowance(address(this), spender) < amount) {
1548             approve(token, spender, uint256(-1));
1549         }
1550     }
1551 
1552     /// @dev Calls `IERC20Token(token).transfer()`.
1553     ///      Reverts if `false` is returned or if the return
1554     ///      data length is nonzero and not 32 bytes.
1555     /// @param token The address of the token contract.
1556     /// @param to The address that receives the tokens
1557     /// @param amount Number of tokens to transfer.
1558     function transfer(
1559         address token,
1560         address to,
1561         uint256 amount
1562     )
1563         internal
1564     {
1565         bytes memory callData = abi.encodeWithSelector(
1566             IERC20Token(0).transfer.selector,
1567             to,
1568             amount
1569         );
1570         _callWithOptionalBooleanResult(token, callData);
1571     }
1572 
1573     /// @dev Calls `IERC20Token(token).transferFrom()`.
1574     ///      Reverts if `false` is returned or if the return
1575     ///      data length is nonzero and not 32 bytes.
1576     /// @param token The address of the token contract.
1577     /// @param from The owner of the tokens.
1578     /// @param to The address that receives the tokens
1579     /// @param amount Number of tokens to transfer.
1580     function transferFrom(
1581         address token,
1582         address from,
1583         address to,
1584         uint256 amount
1585     )
1586         internal
1587     {
1588         bytes memory callData = abi.encodeWithSelector(
1589             IERC20Token(0).transferFrom.selector,
1590             from,
1591             to,
1592             amount
1593         );
1594         _callWithOptionalBooleanResult(token, callData);
1595     }
1596 
1597     /// @dev Retrieves the number of decimals for a token.
1598     ///      Returns `18` if the call reverts.
1599     /// @param token The address of the token contract.
1600     /// @return tokenDecimals The number of decimals places for the token.
1601     function decimals(address token)
1602         internal
1603         view
1604         returns (uint8 tokenDecimals)
1605     {
1606         tokenDecimals = 18;
1607         (bool didSucceed, bytes memory resultData) = token.staticcall(DECIMALS_CALL_DATA);
1608         if (didSucceed && resultData.length == 32) {
1609             tokenDecimals = uint8(LibBytes.readUint256(resultData, 0));
1610         }
1611     }
1612 
1613     /// @dev Retrieves the allowance for a token, owner, and spender.
1614     ///      Returns `0` if the call reverts.
1615     /// @param token The address of the token contract.
1616     /// @param owner The owner of the tokens.
1617     /// @param spender The address the spender.
1618     /// @return allowance The allowance for a token, owner, and spender.
1619     function allowance(address token, address owner, address spender)
1620         internal
1621         view
1622         returns (uint256 allowance_)
1623     {
1624         (bool didSucceed, bytes memory resultData) = token.staticcall(
1625             abi.encodeWithSelector(
1626                 IERC20Token(0).allowance.selector,
1627                 owner,
1628                 spender
1629             )
1630         );
1631         if (didSucceed && resultData.length == 32) {
1632             allowance_ = LibBytes.readUint256(resultData, 0);
1633         }
1634     }
1635 
1636     /// @dev Retrieves the balance for a token owner.
1637     ///      Returns `0` if the call reverts.
1638     /// @param token The address of the token contract.
1639     /// @param owner The owner of the tokens.
1640     /// @return balance The token balance of an owner.
1641     function balanceOf(address token, address owner)
1642         internal
1643         view
1644         returns (uint256 balance)
1645     {
1646         (bool didSucceed, bytes memory resultData) = token.staticcall(
1647             abi.encodeWithSelector(
1648                 IERC20Token(0).balanceOf.selector,
1649                 owner
1650             )
1651         );
1652         if (didSucceed && resultData.length == 32) {
1653             balance = LibBytes.readUint256(resultData, 0);
1654         }
1655     }
1656 
1657     /// @dev Executes a call on address `target` with calldata `callData`
1658     ///      and asserts that either nothing was returned or a single boolean
1659     ///      was returned equal to `true`.
1660     /// @param target The call target.
1661     /// @param callData The abi-encoded call data.
1662     function _callWithOptionalBooleanResult(
1663         address target,
1664         bytes memory callData
1665     )
1666         private
1667     {
1668         (bool didSucceed, bytes memory resultData) = target.call(callData);
1669         if (didSucceed) {
1670             if (resultData.length == 0) {
1671                 return;
1672             }
1673             if (resultData.length == 32) {
1674                 uint256 result = LibBytes.readUint256(resultData, 0);
1675                 if (result == 1) {
1676                     return;
1677                 }
1678             }
1679         }
1680         LibRichErrors.rrevert(resultData);
1681     }
1682 }
1683 
1684 /*
1685 
1686   Copyright 2019 ZeroEx Intl.
1687 
1688   Licensed under the Apache License, Version 2.0 (the "License");
1689   you may not use this file except in compliance with the License.
1690   You may obtain a copy of the License at
1691 
1692     http://www.apache.org/licenses/LICENSE-2.0
1693 
1694   Unless required by applicable law or agreed to in writing, software
1695   distributed under the License is distributed on an "AS IS" BASIS,
1696   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1697   See the License for the specific language governing permissions and
1698   limitations under the License.
1699 
1700 */
1701 
1702 contract IERC721Token {
1703 
1704     /// @dev This emits when ownership of any NFT changes by any mechanism.
1705     ///      This event emits when NFTs are created (`from` == 0) and destroyed
1706     ///      (`to` == 0). Exception: during contract creation, any number of NFTs
1707     ///      may be created and assigned without emitting Transfer. At the time of
1708     ///      any transfer, the approved address for that NFT (if any) is reset to none.
1709     event Transfer(
1710         address indexed _from,
1711         address indexed _to,
1712         uint256 indexed _tokenId
1713     );
1714 
1715     /// @dev This emits when the approved address for an NFT is changed or
1716     ///      reaffirmed. The zero address indicates there is no approved address.
1717     ///      When a Transfer event emits, this also indicates that the approved
1718     ///      address for that NFT (if any) is reset to none.
1719     event Approval(
1720         address indexed _owner,
1721         address indexed _approved,
1722         uint256 indexed _tokenId
1723     );
1724 
1725     /// @dev This emits when an operator is enabled or disabled for an owner.
1726     ///      The operator can manage all NFTs of the owner.
1727     event ApprovalForAll(
1728         address indexed _owner,
1729         address indexed _operator,
1730         bool _approved
1731     );
1732 
1733     /// @notice Transfers the ownership of an NFT from one address to another address
1734     /// @dev Throws unless `msg.sender` is the current owner, an authorized
1735     ///      perator, or the approved address for this NFT. Throws if `_from` is
1736     ///      not the current owner. Throws if `_to` is the zero address. Throws if
1737     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
1738     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
1739     ///      `onERC721Received` on `_to` and throws if the return value is not
1740     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
1741     /// @param _from The current owner of the NFT
1742     /// @param _to The new owner
1743     /// @param _tokenId The NFT to transfer
1744     /// @param _data Additional data with no specified format, sent in call to `_to`
1745     function safeTransferFrom(
1746         address _from,
1747         address _to,
1748         uint256 _tokenId,
1749         bytes calldata _data
1750     )
1751         external;
1752 
1753     /// @notice Transfers the ownership of an NFT from one address to another address
1754     /// @dev This works identically to the other function with an extra data parameter,
1755     ///      except this function just sets data to "".
1756     /// @param _from The current owner of the NFT
1757     /// @param _to The new owner
1758     /// @param _tokenId The NFT to transfer
1759     function safeTransferFrom(
1760         address _from,
1761         address _to,
1762         uint256 _tokenId
1763     )
1764         external;
1765 
1766     /// @notice Change or reaffirm the approved address for an NFT
1767     /// @dev The zero address indicates there is no approved address.
1768     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
1769     ///      operator of the current owner.
1770     /// @param _approved The new approved NFT controller
1771     /// @param _tokenId The NFT to approve
1772     function approve(address _approved, uint256 _tokenId)
1773         external;
1774 
1775     /// @notice Enable or disable approval for a third party ("operator") to manage
1776     ///         all of `msg.sender`'s assets
1777     /// @dev Emits the ApprovalForAll event. The contract MUST allow
1778     ///      multiple operators per owner.
1779     /// @param _operator Address to add to the set of authorized operators
1780     /// @param _approved True if the operator is approved, false to revoke approval
1781     function setApprovalForAll(address _operator, bool _approved)
1782         external;
1783 
1784     /// @notice Count all NFTs assigned to an owner
1785     /// @dev NFTs assigned to the zero address are considered invalid, and this
1786     ///      function throws for queries about the zero address.
1787     /// @param _owner An address for whom to query the balance
1788     /// @return The number of NFTs owned by `_owner`, possibly zero
1789     function balanceOf(address _owner)
1790         external
1791         view
1792         returns (uint256);
1793 
1794     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
1795     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
1796     ///         THEY MAY BE PERMANENTLY LOST
1797     /// @dev Throws unless `msg.sender` is the current owner, an authorized
1798     ///      operator, or the approved address for this NFT. Throws if `_from` is
1799     ///      not the current owner. Throws if `_to` is the zero address. Throws if
1800     ///      `_tokenId` is not a valid NFT.
1801     /// @param _from The current owner of the NFT
1802     /// @param _to The new owner
1803     /// @param _tokenId The NFT to transfer
1804     function transferFrom(
1805         address _from,
1806         address _to,
1807         uint256 _tokenId
1808     )
1809         public;
1810 
1811     /// @notice Find the owner of an NFT
1812     /// @dev NFTs assigned to zero address are considered invalid, and queries
1813     ///      about them do throw.
1814     /// @param _tokenId The identifier for an NFT
1815     /// @return The address of the owner of the NFT
1816     function ownerOf(uint256 _tokenId)
1817         public
1818         view
1819         returns (address);
1820 
1821     /// @notice Get the approved address for a single NFT
1822     /// @dev Throws if `_tokenId` is not a valid NFT.
1823     /// @param _tokenId The NFT to find the approved address for
1824     /// @return The approved address for this NFT, or the zero address if there is none
1825     function getApproved(uint256 _tokenId)
1826         public
1827         view
1828         returns (address);
1829 
1830     /// @notice Query if an address is an authorized operator for another address
1831     /// @param _owner The address that owns the NFTs
1832     /// @param _operator The address that acts on behalf of the owner
1833     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
1834     function isApprovedForAll(address _owner, address _operator)
1835         public
1836         view
1837         returns (bool);
1838 }
1839 
1840 /*
1841 
1842   Copyright 2019 ZeroEx Intl.
1843 
1844   Licensed under the Apache License, Version 2.0 (the "License");
1845   you may not use this file except in compliance with the License.
1846   You may obtain a copy of the License at
1847 
1848     http://www.apache.org/licenses/LICENSE-2.0
1849 
1850   Unless required by applicable law or agreed to in writing, software
1851   distributed under the License is distributed on an "AS IS" BASIS,
1852   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1853   See the License for the specific language governing permissions and
1854   limitations under the License.
1855 
1856 */
1857 
1858 /// @title ERC-1155 Multi Token Standard
1859 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md
1860 /// Note: The ERC-165 identifier for this interface is 0xd9b67a26.
1861 interface IERC1155 {
1862 
1863     /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
1864     ///      including zero value transfers as well as minting or burning.
1865     /// Operator will always be msg.sender.
1866     /// Either event from address `0x0` signifies a minting operation.
1867     /// An event to address `0x0` signifies a burning or melting operation.
1868     /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
1869     /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
1870     /// To define a token ID with no initial balance, the contract SHOULD emit the TransferSingle event
1871     /// from `0x0` to `0x0`, with the token creator as `_operator`.
1872     event TransferSingle(
1873         address indexed operator,
1874         address indexed from,
1875         address indexed to,
1876         uint256 id,
1877         uint256 value
1878     );
1879 
1880     /// @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred,
1881     ///      including zero value transfers as well as minting or burning.
1882     ///Operator will always be msg.sender.
1883     /// Either event from address `0x0` signifies a minting operation.
1884     /// An event to address `0x0` signifies a burning or melting operation.
1885     /// The total value transferred from address 0x0 minus the total value transferred to 0x0 may
1886     /// be used by clients and exchanges to be added to the "circulating supply" for a given token ID.
1887     /// To define multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event
1888     /// from `0x0` to `0x0`, with the token creator as `_operator`.
1889     event TransferBatch(
1890         address indexed operator,
1891         address indexed from,
1892         address indexed to,
1893         uint256[] ids,
1894         uint256[] values
1895     );
1896 
1897     /// @dev MUST emit when an approval is updated.
1898     event ApprovalForAll(
1899         address indexed owner,
1900         address indexed operator,
1901         bool approved
1902     );
1903 
1904     /// @dev MUST emit when the URI is updated for a token ID.
1905     /// URIs are defined in RFC 3986.
1906     /// The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema".
1907     event URI(
1908         string value,
1909         uint256 indexed id
1910     );
1911 
1912     /// @notice Transfers value amount of an _id from the _from address to the _to address specified.
1913     /// @dev MUST emit TransferSingle event on success.
1914     /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
1915     /// MUST throw if `_to` is the zero address.
1916     /// MUST throw if balance of sender for token `_id` is lower than the `_value` sent.
1917     /// MUST throw on any other error.
1918     /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
1919     /// If so, it MUST call `onERC1155Received` on `_to` and revert if the return value
1920     /// is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`.
1921     /// @param from    Source address
1922     /// @param to      Target address
1923     /// @param id      ID of the token type
1924     /// @param value   Transfer amount
1925     /// @param data    Additional data with no specified format, sent in call to `_to`
1926     function safeTransferFrom(
1927         address from,
1928         address to,
1929         uint256 id,
1930         uint256 value,
1931         bytes calldata data
1932     )
1933         external;
1934 
1935     /// @notice Send multiple types of Tokens from a 3rd party in one transfer (with safety call).
1936     /// @dev MUST emit TransferBatch event on success.
1937     /// Caller must be approved to manage the _from account's tokens (see isApprovedForAll).
1938     /// MUST throw if `_to` is the zero address.
1939     /// MUST throw if length of `_ids` is not the same as length of `_values`.
1940     ///  MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_values` sent.
1941     /// MUST throw on any other error.
1942     /// When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0).
1943     /// If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return value
1944     /// is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`.
1945     /// @param from    Source addresses
1946     /// @param to      Target addresses
1947     /// @param ids     IDs of each token type
1948     /// @param values  Transfer amounts per token type
1949     /// @param data    Additional data with no specified format, sent in call to `_to`
1950     function safeBatchTransferFrom(
1951         address from,
1952         address to,
1953         uint256[] calldata ids,
1954         uint256[] calldata values,
1955         bytes calldata data
1956     )
1957         external;
1958 
1959     /// @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
1960     /// @dev MUST emit the ApprovalForAll event on success.
1961     /// @param operator  Address to add to the set of authorized operators
1962     /// @param approved  True if the operator is approved, false to revoke approval
1963     function setApprovalForAll(address operator, bool approved) external;
1964 
1965     /// @notice Queries the approval status of an operator for a given owner.
1966     /// @param owner     The owner of the Tokens
1967     /// @param operator  Address of authorized operator
1968     /// @return           True if the operator is approved, false if not
1969     function isApprovedForAll(address owner, address operator) external view returns (bool);
1970 
1971     /// @notice Get the balance of an account's Tokens.
1972     /// @param owner  The address of the token holder
1973     /// @param id     ID of the Token
1974     /// @return        The _owner's balance of the Token type requested
1975     function balanceOf(address owner, uint256 id) external view returns (uint256);
1976 
1977     /// @notice Get the balance of multiple account/token pairs
1978     /// @param owners The addresses of the token holders
1979     /// @param ids    ID of the Tokens
1980     /// @return        The _owner's balance of the Token types requested
1981     function balanceOfBatch(
1982         address[] calldata owners,
1983         uint256[] calldata ids
1984     )
1985         external
1986         view
1987         returns (uint256[] memory balances_);
1988 }
1989 
1990 /*
1991 
1992   Copyright 2019 ZeroEx Intl.
1993 
1994   Licensed under the Apache License, Version 2.0 (the "License");
1995   you may not use this file except in compliance with the License.
1996   You may obtain a copy of the License at
1997 
1998     http://www.apache.org/licenses/LICENSE-2.0
1999 
2000   Unless required by applicable law or agreed to in writing, software
2001   distributed under the License is distributed on an "AS IS" BASIS,
2002   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2003   See the License for the specific language governing permissions and
2004   limitations under the License.
2005 
2006 */
2007 
2008 library LibAssetDataTransferRichErrors {
2009 
2010     // bytes4(keccak256("UnsupportedAssetProxyError(bytes4)"))
2011     bytes4 internal constant UNSUPPORTED_ASSET_PROXY_ERROR_SELECTOR =
2012         0x7996a271;
2013 
2014     // bytes4(keccak256("Erc721AmountMustEqualOneError(uint256)"))
2015     bytes4 internal constant ERC721_AMOUNT_MUST_EQUAL_ONE_ERROR_SELECTOR =
2016         0xbaffa474;
2017 
2018     // solhint-disable func-name-mixedcase
2019     function UnsupportedAssetProxyError(
2020         bytes4 proxyId
2021     )
2022         internal
2023         pure
2024         returns (bytes memory)
2025     {
2026         return abi.encodeWithSelector(
2027             UNSUPPORTED_ASSET_PROXY_ERROR_SELECTOR,
2028             proxyId
2029         );
2030     }
2031 
2032     function Erc721AmountMustEqualOneError(
2033         uint256 amount
2034     )
2035         internal
2036         pure
2037         returns (bytes memory)
2038     {
2039         return abi.encodeWithSelector(
2040             ERC721_AMOUNT_MUST_EQUAL_ONE_ERROR_SELECTOR,
2041             amount
2042         );
2043     }
2044 }
2045 
2046 library LibAssetDataTransfer {
2047 
2048     using LibBytes for bytes;
2049     using LibSafeMath for uint256;
2050     using LibAssetDataTransfer for bytes;
2051 
2052     /// @dev Transfers given amount of asset to sender.
2053     /// @param assetData Byte array encoded for the respective asset proxy.
2054     /// @param from Address to transfer asset from.
2055     /// @param to Address to transfer asset to.
2056     /// @param amount Amount of asset to transfer to sender.
2057     function transferFrom(
2058         bytes memory assetData,
2059         address from,
2060         address to,
2061         uint256 amount
2062     )
2063         internal
2064     {
2065         if (amount == 0) {
2066             return;
2067         }
2068 
2069         bytes4 proxyId = assetData.readBytes4(0);
2070 
2071         if (
2072             proxyId == IAssetData(address(0)).ERC20Token.selector ||
2073             proxyId == IAssetData(address(0)).ERC20Bridge.selector
2074         ) {
2075             assetData.transferERC20Token(
2076                 from,
2077                 to,
2078                 amount
2079             );
2080         } else if (proxyId == IAssetData(address(0)).ERC721Token.selector) {
2081             assetData.transferERC721Token(
2082                 from,
2083                 to,
2084                 amount
2085             );
2086         } else if (proxyId == IAssetData(address(0)).ERC1155Assets.selector) {
2087             assetData.transferERC1155Assets(
2088                 from,
2089                 to,
2090                 amount
2091             );
2092         } else if (proxyId == IAssetData(address(0)).MultiAsset.selector) {
2093             assetData.transferMultiAsset(
2094                 from,
2095                 to,
2096                 amount
2097             );
2098         } else if (proxyId != IAssetData(address(0)).StaticCall.selector) {
2099             LibRichErrors.rrevert(LibAssetDataTransferRichErrors.UnsupportedAssetProxyError(
2100                 proxyId
2101             ));
2102         }
2103     }
2104 
2105     ///@dev Transfer asset from sender to this contract.
2106     /// @param assetData Byte array encoded for the respective asset proxy.
2107     /// @param amount Amount of asset to transfer to sender.
2108     function transferIn(
2109         bytes memory assetData,
2110         uint256 amount
2111     )
2112         internal
2113     {
2114         assetData.transferFrom(
2115             msg.sender,
2116             address(this),
2117             amount
2118         );
2119     }
2120 
2121     ///@dev Transfer asset from this contract to sender.
2122     /// @param assetData Byte array encoded for the respective asset proxy.
2123     /// @param amount Amount of asset to transfer to sender.
2124     function transferOut(
2125         bytes memory assetData,
2126         uint256 amount
2127     )
2128         internal
2129     {
2130         assetData.transferFrom(
2131             address(this),
2132             msg.sender,
2133             amount
2134         );
2135     }
2136 
2137     /// @dev Decodes ERC20 or ERC20Bridge assetData and transfers given amount to sender.
2138     /// @param assetData Byte array encoded for the respective asset proxy.
2139     /// @param from Address to transfer asset from.
2140     /// @param to Address to transfer asset to.
2141     /// @param amount Amount of asset to transfer to sender.
2142     function transferERC20Token(
2143         bytes memory assetData,
2144         address from,
2145         address to,
2146         uint256 amount
2147     )
2148         internal
2149     {
2150         address token = assetData.readAddress(16);
2151         // Transfer tokens.
2152         if (from == address(this)) {
2153             LibERC20Token.transfer(
2154                 token,
2155                 to,
2156                 amount
2157             );
2158         } else {
2159             LibERC20Token.transferFrom(
2160                 token,
2161                 from,
2162                 to,
2163                 amount
2164             );
2165         }
2166     }
2167 
2168     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2169     /// @param assetData Byte array encoded for the respective asset proxy.
2170     /// @param from Address to transfer asset from.
2171     /// @param to Address to transfer asset to.
2172     /// @param amount Amount of asset to transfer to sender.
2173     function transferERC721Token(
2174         bytes memory assetData,
2175         address from,
2176         address to,
2177         uint256 amount
2178     )
2179         internal
2180     {
2181         if (amount != 1) {
2182             LibRichErrors.rrevert(LibAssetDataTransferRichErrors.Erc721AmountMustEqualOneError(
2183                 amount
2184             ));
2185         }
2186         // Decode asset data.
2187         address token = assetData.readAddress(16);
2188         uint256 tokenId = assetData.readUint256(36);
2189 
2190         // Perform transfer.
2191         IERC721Token(token).transferFrom(
2192             from,
2193             to,
2194             tokenId
2195         );
2196     }
2197 
2198     /// @dev Decodes ERC1155 assetData and transfers given amounts to sender.
2199     /// @param assetData Byte array encoded for the respective asset proxy.
2200     /// @param from Address to transfer asset from.
2201     /// @param to Address to transfer asset to.
2202     /// @param amount Amount of asset to transfer to sender.
2203     function transferERC1155Assets(
2204         bytes memory assetData,
2205         address from,
2206         address to,
2207         uint256 amount
2208     )
2209         internal
2210     {
2211         // Decode assetData
2212         // solhint-disable
2213         (
2214             address token,
2215             uint256[] memory ids,
2216             uint256[] memory values,
2217             bytes memory data
2218         ) = abi.decode(
2219             assetData.slice(4, assetData.length),
2220             (address, uint256[], uint256[], bytes)
2221         );
2222         // solhint-enable
2223 
2224         // Scale up values by `amount`
2225         uint256 length = values.length;
2226         uint256[] memory scaledValues = new uint256[](length);
2227         for (uint256 i = 0; i != length; i++) {
2228             scaledValues[i] = values[i].safeMul(amount);
2229         }
2230 
2231         // Execute `safeBatchTransferFrom` call
2232         // Either succeeds or throws
2233         IERC1155(token).safeBatchTransferFrom(
2234             from,
2235             to,
2236             ids,
2237             scaledValues,
2238             data
2239         );
2240     }
2241 
2242     /// @dev Decodes MultiAsset assetData and recursively transfers assets to sender.
2243     /// @param assetData Byte array encoded for the respective asset proxy.
2244     /// @param from Address to transfer asset from.
2245     /// @param to Address to transfer asset to.
2246     /// @param amount Amount of asset to transfer to sender.
2247     function transferMultiAsset(
2248         bytes memory assetData,
2249         address from,
2250         address to,
2251         uint256 amount
2252     )
2253         internal
2254     {
2255         // solhint-disable indent
2256         (uint256[] memory nestedAmounts, bytes[] memory nestedAssetData) = abi.decode(
2257             assetData.slice(4, assetData.length),
2258             (uint256[], bytes[])
2259         );
2260         // solhint-enable indent
2261 
2262         uint256 numNestedAssets = nestedAssetData.length;
2263         for (uint256 i = 0; i != numNestedAssets; i++) {
2264             transferFrom(
2265                 nestedAssetData[i],
2266                 from,
2267                 to,
2268                 amount.safeMul(nestedAmounts[i])
2269             );
2270         }
2271     }
2272 }
2273 
2274 /*
2275 
2276   Copyright 2019 ZeroEx Intl.
2277 
2278   Licensed under the Apache License, Version 2.0 (the "License");
2279   you may not use this file except in compliance with the License.
2280   You may obtain a copy of the License at
2281 
2282     http://www.apache.org/licenses/LICENSE-2.0
2283 
2284   Unless required by applicable law or agreed to in writing, software
2285   distributed under the License is distributed on an "AS IS" BASIS,
2286   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2287   See the License for the specific language governing permissions and
2288   limitations \under the License.
2289 
2290 */
2291 
2292 /*
2293 
2294   Copyright 2019 ZeroEx Intl.
2295 
2296   Licensed under the Apache License, Version 2.0 (the "License");
2297   you may not use this file except in compliance with the License.
2298   You may obtain a copy of the License at
2299 
2300     http://www.apache.org/licenses/LICENSE-2.0
2301 
2302   Unless required by applicable law or agreed to in writing, software
2303   distributed under the License is distributed on an "AS IS" BASIS,
2304   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2305   See the License for the specific language governing permissions and
2306   limitations under the License.
2307 
2308 */
2309 
2310 contract IEtherToken is
2311     IERC20Token
2312 {
2313     function deposit()
2314         public
2315         payable;
2316 
2317     function withdraw(uint256 amount)
2318         public;
2319 }
2320 
2321 /*
2322 
2323   Copyright 2019 ZeroEx Intl.
2324 
2325   Licensed under the Apache License, Version 2.0 (the "License");
2326   you may not use this file except in compliance with the License.
2327   You may obtain a copy of the License at
2328 
2329     http://www.apache.org/licenses/LICENSE-2.0
2330 
2331   Unless required by applicable law or agreed to in writing, software
2332   distributed under the License is distributed on an "AS IS" BASIS,
2333   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2334   See the License for the specific language governing permissions and
2335   limitations under the License.
2336 
2337 */
2338 
2339 /*
2340 
2341   Copyright 2019 ZeroEx Intl.
2342 
2343   Licensed under the Apache License, Version 2.0 (the "License");
2344   you may not use this file except in compliance with the License.
2345   You may obtain a copy of the License at
2346 
2347     http://www.apache.org/licenses/LICENSE-2.0
2348 
2349   Unless required by applicable law or agreed to in writing, software
2350   distributed under the License is distributed on an "AS IS" BASIS,
2351   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2352   See the License for the specific language governing permissions and
2353   limitations under the License.
2354 
2355 */
2356 
2357 /*
2358 
2359   Copyright 2019 ZeroEx Intl.
2360 
2361   Licensed under the Apache License, Version 2.0 (the "License");
2362   you may not use this file except in compliance with the License.
2363   You may obtain a copy of the License at
2364 
2365     http://www.apache.org/licenses/LICENSE-2.0
2366 
2367   Unless required by applicable law or agreed to in writing, software
2368   distributed under the License is distributed on an "AS IS" BASIS,
2369   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2370   See the License for the specific language governing permissions and
2371   limitations under the License.
2372 
2373 */
2374 
2375 library LibFillResults {
2376 
2377     using LibSafeMath for uint256;
2378 
2379     struct BatchMatchedFillResults {
2380         FillResults[] left;              // Fill results for left orders
2381         FillResults[] right;             // Fill results for right orders
2382         uint256 profitInLeftMakerAsset;  // Profit taken from left makers
2383         uint256 profitInRightMakerAsset; // Profit taken from right makers
2384     }
2385 
2386     struct FillResults {
2387         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
2388         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
2389         uint256 makerFeePaid;            // Total amount of fees paid by maker(s) to feeRecipient(s).
2390         uint256 takerFeePaid;            // Total amount of fees paid by taker to feeRecipients(s).
2391         uint256 protocolFeePaid;         // Total amount of fees paid by taker to the staking contract.
2392     }
2393 
2394     struct MatchedFillResults {
2395         FillResults left;                // Amounts filled and fees paid of left order.
2396         FillResults right;               // Amounts filled and fees paid of right order.
2397         uint256 profitInLeftMakerAsset;  // Profit taken from the left maker
2398         uint256 profitInRightMakerAsset; // Profit taken from the right maker
2399     }
2400 
2401     /// @dev Calculates amounts filled and fees paid by maker and taker.
2402     /// @param order to be filled.
2403     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2404     /// @param protocolFeeMultiplier The current protocol fee of the exchange contract.
2405     /// @param gasPrice The gasprice of the transaction. This is provided so that the function call can continue
2406     ///        to be pure rather than view.
2407     /// @return fillResults Amounts filled and fees paid by maker and taker.
2408     function calculateFillResults(
2409         LibOrder.Order memory order,
2410         uint256 takerAssetFilledAmount,
2411         uint256 protocolFeeMultiplier,
2412         uint256 gasPrice
2413     )
2414         internal
2415         pure
2416         returns (FillResults memory fillResults)
2417     {
2418         // Compute proportional transfer amounts
2419         fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
2420         fillResults.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(
2421             takerAssetFilledAmount,
2422             order.takerAssetAmount,
2423             order.makerAssetAmount
2424         );
2425         fillResults.makerFeePaid = LibMath.safeGetPartialAmountFloor(
2426             takerAssetFilledAmount,
2427             order.takerAssetAmount,
2428             order.makerFee
2429         );
2430         fillResults.takerFeePaid = LibMath.safeGetPartialAmountFloor(
2431             takerAssetFilledAmount,
2432             order.takerAssetAmount,
2433             order.takerFee
2434         );
2435 
2436         // Compute the protocol fee that should be paid for a single fill.
2437         fillResults.protocolFeePaid = gasPrice.safeMul(protocolFeeMultiplier);
2438 
2439         return fillResults;
2440     }
2441 
2442     /// @dev Calculates fill amounts for the matched orders.
2443     ///      Each order is filled at their respective price point. However, the calculations are
2444     ///      carried out as though the orders are both being filled at the right order's price point.
2445     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
2446     /// @param leftOrder First order to match.
2447     /// @param rightOrder Second order to match.
2448     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
2449     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
2450     /// @param protocolFeeMultiplier The current protocol fee of the exchange contract.
2451     /// @param gasPrice The gasprice of the transaction. This is provided so that the function call can continue
2452     ///        to be pure rather than view.
2453     /// @param shouldMaximallyFillOrders A value that indicates whether or not this calculation should use
2454     ///                                  the maximal fill order matching strategy.
2455     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
2456     function calculateMatchedFillResults(
2457         LibOrder.Order memory leftOrder,
2458         LibOrder.Order memory rightOrder,
2459         uint256 leftOrderTakerAssetFilledAmount,
2460         uint256 rightOrderTakerAssetFilledAmount,
2461         uint256 protocolFeeMultiplier,
2462         uint256 gasPrice,
2463         bool shouldMaximallyFillOrders
2464     )
2465         internal
2466         pure
2467         returns (MatchedFillResults memory matchedFillResults)
2468     {
2469         // Derive maker asset amounts for left & right orders, given store taker assert amounts
2470         uint256 leftTakerAssetAmountRemaining = leftOrder.takerAssetAmount.safeSub(leftOrderTakerAssetFilledAmount);
2471         uint256 leftMakerAssetAmountRemaining = LibMath.safeGetPartialAmountFloor(
2472             leftOrder.makerAssetAmount,
2473             leftOrder.takerAssetAmount,
2474             leftTakerAssetAmountRemaining
2475         );
2476         uint256 rightTakerAssetAmountRemaining = rightOrder.takerAssetAmount.safeSub(rightOrderTakerAssetFilledAmount);
2477         uint256 rightMakerAssetAmountRemaining = LibMath.safeGetPartialAmountFloor(
2478             rightOrder.makerAssetAmount,
2479             rightOrder.takerAssetAmount,
2480             rightTakerAssetAmountRemaining
2481         );
2482 
2483         // Maximally fill the orders and pay out profits to the matcher in one or both of the maker assets.
2484         if (shouldMaximallyFillOrders) {
2485             matchedFillResults = _calculateMatchedFillResultsWithMaximalFill(
2486                 leftOrder,
2487                 rightOrder,
2488                 leftMakerAssetAmountRemaining,
2489                 leftTakerAssetAmountRemaining,
2490                 rightMakerAssetAmountRemaining,
2491                 rightTakerAssetAmountRemaining
2492             );
2493         } else {
2494             matchedFillResults = _calculateMatchedFillResults(
2495                 leftOrder,
2496                 rightOrder,
2497                 leftMakerAssetAmountRemaining,
2498                 leftTakerAssetAmountRemaining,
2499                 rightMakerAssetAmountRemaining,
2500                 rightTakerAssetAmountRemaining
2501             );
2502         }
2503 
2504         // Compute fees for left order
2505         matchedFillResults.left.makerFeePaid = LibMath.safeGetPartialAmountFloor(
2506             matchedFillResults.left.makerAssetFilledAmount,
2507             leftOrder.makerAssetAmount,
2508             leftOrder.makerFee
2509         );
2510         matchedFillResults.left.takerFeePaid = LibMath.safeGetPartialAmountFloor(
2511             matchedFillResults.left.takerAssetFilledAmount,
2512             leftOrder.takerAssetAmount,
2513             leftOrder.takerFee
2514         );
2515 
2516         // Compute fees for right order
2517         matchedFillResults.right.makerFeePaid = LibMath.safeGetPartialAmountFloor(
2518             matchedFillResults.right.makerAssetFilledAmount,
2519             rightOrder.makerAssetAmount,
2520             rightOrder.makerFee
2521         );
2522         matchedFillResults.right.takerFeePaid = LibMath.safeGetPartialAmountFloor(
2523             matchedFillResults.right.takerAssetFilledAmount,
2524             rightOrder.takerAssetAmount,
2525             rightOrder.takerFee
2526         );
2527 
2528         // Compute the protocol fee that should be paid for a single fill. In this
2529         // case this should be made the protocol fee for both the left and right orders.
2530         uint256 protocolFee = gasPrice.safeMul(protocolFeeMultiplier);
2531         matchedFillResults.left.protocolFeePaid = protocolFee;
2532         matchedFillResults.right.protocolFeePaid = protocolFee;
2533 
2534         // Return fill results
2535         return matchedFillResults;
2536     }
2537 
2538     /// @dev Adds properties of both FillResults instances.
2539     /// @param fillResults1 The first FillResults.
2540     /// @param fillResults2 The second FillResults.
2541     /// @return The sum of both fill results.
2542     function addFillResults(
2543         FillResults memory fillResults1,
2544         FillResults memory fillResults2
2545     )
2546         internal
2547         pure
2548         returns (FillResults memory totalFillResults)
2549     {
2550         totalFillResults.makerAssetFilledAmount = fillResults1.makerAssetFilledAmount.safeAdd(fillResults2.makerAssetFilledAmount);
2551         totalFillResults.takerAssetFilledAmount = fillResults1.takerAssetFilledAmount.safeAdd(fillResults2.takerAssetFilledAmount);
2552         totalFillResults.makerFeePaid = fillResults1.makerFeePaid.safeAdd(fillResults2.makerFeePaid);
2553         totalFillResults.takerFeePaid = fillResults1.takerFeePaid.safeAdd(fillResults2.takerFeePaid);
2554         totalFillResults.protocolFeePaid = fillResults1.protocolFeePaid.safeAdd(fillResults2.protocolFeePaid);
2555 
2556         return totalFillResults;
2557     }
2558 
2559     /// @dev Calculates part of the matched fill results for a given situation using the fill strategy that only
2560     ///      awards profit denominated in the left maker asset.
2561     /// @param leftOrder The left order in the order matching situation.
2562     /// @param rightOrder The right order in the order matching situation.
2563     /// @param leftMakerAssetAmountRemaining The amount of the left order maker asset that can still be filled.
2564     /// @param leftTakerAssetAmountRemaining The amount of the left order taker asset that can still be filled.
2565     /// @param rightMakerAssetAmountRemaining The amount of the right order maker asset that can still be filled.
2566     /// @param rightTakerAssetAmountRemaining The amount of the right order taker asset that can still be filled.
2567     /// @return MatchFillResults struct that does not include fees paid.
2568     function _calculateMatchedFillResults(
2569         LibOrder.Order memory leftOrder,
2570         LibOrder.Order memory rightOrder,
2571         uint256 leftMakerAssetAmountRemaining,
2572         uint256 leftTakerAssetAmountRemaining,
2573         uint256 rightMakerAssetAmountRemaining,
2574         uint256 rightTakerAssetAmountRemaining
2575     )
2576         private
2577         pure
2578         returns (MatchedFillResults memory matchedFillResults)
2579     {
2580         // Calculate fill results for maker and taker assets: at least one order will be fully filled.
2581         // The maximum amount the left maker can buy is `leftTakerAssetAmountRemaining`
2582         // The maximum amount the right maker can sell is `rightMakerAssetAmountRemaining`
2583         // We have two distinct cases for calculating the fill results:
2584         // Case 1.
2585         //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.
2586         //   If the left maker can buy exactly what the right maker can sell, then both orders are fully filled.
2587         // Case 2.
2588         //   If the left maker cannot buy more than the right maker can sell, then only the left order is fully filled.
2589         // Case 3.
2590         //   If the left maker can buy exactly as much as the right maker can sell, then both orders are fully filled.
2591         if (leftTakerAssetAmountRemaining > rightMakerAssetAmountRemaining) {
2592             // Case 1: Right order is fully filled
2593             matchedFillResults = _calculateCompleteRightFill(
2594                 leftOrder,
2595                 rightMakerAssetAmountRemaining,
2596                 rightTakerAssetAmountRemaining
2597             );
2598         } else if (leftTakerAssetAmountRemaining < rightMakerAssetAmountRemaining) {
2599             // Case 2: Left order is fully filled
2600             matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
2601             matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
2602             matchedFillResults.right.makerAssetFilledAmount = leftTakerAssetAmountRemaining;
2603             // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.
2604             // We favor the maker when the exchange rate must be rounded.
2605             matchedFillResults.right.takerAssetFilledAmount = LibMath.safeGetPartialAmountCeil(
2606                 rightOrder.takerAssetAmount,
2607                 rightOrder.makerAssetAmount,
2608                 leftTakerAssetAmountRemaining // matchedFillResults.right.makerAssetFilledAmount
2609             );
2610         } else {
2611             // leftTakerAssetAmountRemaining == rightMakerAssetAmountRemaining
2612             // Case 3: Both orders are fully filled. Technically, this could be captured by the above cases, but
2613             //         this calculation will be more precise since it does not include rounding.
2614             matchedFillResults = _calculateCompleteFillBoth(
2615                 leftMakerAssetAmountRemaining,
2616                 leftTakerAssetAmountRemaining,
2617                 rightMakerAssetAmountRemaining,
2618                 rightTakerAssetAmountRemaining
2619             );
2620         }
2621 
2622         // Calculate amount given to taker
2623         matchedFillResults.profitInLeftMakerAsset = matchedFillResults.left.makerAssetFilledAmount.safeSub(
2624             matchedFillResults.right.takerAssetFilledAmount
2625         );
2626 
2627         return matchedFillResults;
2628     }
2629 
2630     /// @dev Calculates part of the matched fill results for a given situation using the maximal fill order matching
2631     ///      strategy.
2632     /// @param leftOrder The left order in the order matching situation.
2633     /// @param rightOrder The right order in the order matching situation.
2634     /// @param leftMakerAssetAmountRemaining The amount of the left order maker asset that can still be filled.
2635     /// @param leftTakerAssetAmountRemaining The amount of the left order taker asset that can still be filled.
2636     /// @param rightMakerAssetAmountRemaining The amount of the right order maker asset that can still be filled.
2637     /// @param rightTakerAssetAmountRemaining The amount of the right order taker asset that can still be filled.
2638     /// @return MatchFillResults struct that does not include fees paid.
2639     function _calculateMatchedFillResultsWithMaximalFill(
2640         LibOrder.Order memory leftOrder,
2641         LibOrder.Order memory rightOrder,
2642         uint256 leftMakerAssetAmountRemaining,
2643         uint256 leftTakerAssetAmountRemaining,
2644         uint256 rightMakerAssetAmountRemaining,
2645         uint256 rightTakerAssetAmountRemaining
2646     )
2647         private
2648         pure
2649         returns (MatchedFillResults memory matchedFillResults)
2650     {
2651         // If a maker asset is greater than the opposite taker asset, than there will be a spread denominated in that maker asset.
2652         bool doesLeftMakerAssetProfitExist = leftMakerAssetAmountRemaining > rightTakerAssetAmountRemaining;
2653         bool doesRightMakerAssetProfitExist = rightMakerAssetAmountRemaining > leftTakerAssetAmountRemaining;
2654 
2655         // Calculate the maximum fill results for the maker and taker assets. At least one of the orders will be fully filled.
2656         //
2657         // The maximum that the left maker can possibly buy is the amount that the right order can sell.
2658         // The maximum that the right maker can possibly buy is the amount that the left order can sell.
2659         //
2660         // If the left order is fully filled, profit will be paid out in the left maker asset. If the right order is fully filled,
2661         // the profit will be out in the right maker asset.
2662         //
2663         // There are three cases to consider:
2664         // Case 1.
2665         //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.
2666         // Case 2.
2667         //   If the right maker can buy more than the left maker can sell, then only the right order is fully filled.
2668         // Case 3.
2669         //   If the right maker can sell the max of what the left maker can buy and the left maker can sell the max of
2670         //   what the right maker can buy, then both orders are fully filled.
2671         if (leftTakerAssetAmountRemaining > rightMakerAssetAmountRemaining) {
2672             // Case 1: Right order is fully filled with the profit paid in the left makerAsset
2673             matchedFillResults = _calculateCompleteRightFill(
2674                 leftOrder,
2675                 rightMakerAssetAmountRemaining,
2676                 rightTakerAssetAmountRemaining
2677             );
2678         } else if (rightTakerAssetAmountRemaining > leftMakerAssetAmountRemaining) {
2679             // Case 2: Left order is fully filled with the profit paid in the right makerAsset.
2680             matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
2681             matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
2682             // Round down to ensure the right maker's exchange rate does not exceed the price specified by the order.
2683             // We favor the right maker when the exchange rate must be rounded and the profit is being paid in the
2684             // right maker asset.
2685             matchedFillResults.right.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(
2686                 rightOrder.makerAssetAmount,
2687                 rightOrder.takerAssetAmount,
2688                 leftMakerAssetAmountRemaining
2689             );
2690             matchedFillResults.right.takerAssetFilledAmount = leftMakerAssetAmountRemaining;
2691         } else {
2692             // Case 3: The right and left orders are fully filled
2693             matchedFillResults = _calculateCompleteFillBoth(
2694                 leftMakerAssetAmountRemaining,
2695                 leftTakerAssetAmountRemaining,
2696                 rightMakerAssetAmountRemaining,
2697                 rightTakerAssetAmountRemaining
2698             );
2699         }
2700 
2701         // Calculate amount given to taker in the left order's maker asset if the left spread will be part of the profit.
2702         if (doesLeftMakerAssetProfitExist) {
2703             matchedFillResults.profitInLeftMakerAsset = matchedFillResults.left.makerAssetFilledAmount.safeSub(
2704                 matchedFillResults.right.takerAssetFilledAmount
2705             );
2706         }
2707 
2708         // Calculate amount given to taker in the right order's maker asset if the right spread will be part of the profit.
2709         if (doesRightMakerAssetProfitExist) {
2710             matchedFillResults.profitInRightMakerAsset = matchedFillResults.right.makerAssetFilledAmount.safeSub(
2711                 matchedFillResults.left.takerAssetFilledAmount
2712             );
2713         }
2714 
2715         return matchedFillResults;
2716     }
2717 
2718     /// @dev Calculates the fill results for the maker and taker in the order matching and writes the results
2719     ///      to the fillResults that are being collected on the order. Both orders will be fully filled in this
2720     ///      case.
2721     /// @param leftMakerAssetAmountRemaining The amount of the left maker asset that is remaining to be filled.
2722     /// @param leftTakerAssetAmountRemaining The amount of the left taker asset that is remaining to be filled.
2723     /// @param rightMakerAssetAmountRemaining The amount of the right maker asset that is remaining to be filled.
2724     /// @param rightTakerAssetAmountRemaining The amount of the right taker asset that is remaining to be filled.
2725     /// @return MatchFillResults struct that does not include fees paid or spreads taken.
2726     function _calculateCompleteFillBoth(
2727         uint256 leftMakerAssetAmountRemaining,
2728         uint256 leftTakerAssetAmountRemaining,
2729         uint256 rightMakerAssetAmountRemaining,
2730         uint256 rightTakerAssetAmountRemaining
2731     )
2732         private
2733         pure
2734         returns (MatchedFillResults memory matchedFillResults)
2735     {
2736         // Calculate the fully filled results for both orders.
2737         matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
2738         matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
2739         matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;
2740         matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;
2741 
2742         return matchedFillResults;
2743     }
2744 
2745     /// @dev Calculates the fill results for the maker and taker in the order matching and writes the results
2746     ///      to the fillResults that are being collected on the order.
2747     /// @param leftOrder The left order that is being maximally filled. All of the information about fill amounts
2748     ///                  can be derived from this order and the right asset remaining fields.
2749     /// @param rightMakerAssetAmountRemaining The amount of the right maker asset that is remaining to be filled.
2750     /// @param rightTakerAssetAmountRemaining The amount of the right taker asset that is remaining to be filled.
2751     /// @return MatchFillResults struct that does not include fees paid or spreads taken.
2752     function _calculateCompleteRightFill(
2753         LibOrder.Order memory leftOrder,
2754         uint256 rightMakerAssetAmountRemaining,
2755         uint256 rightTakerAssetAmountRemaining
2756     )
2757         private
2758         pure
2759         returns (MatchedFillResults memory matchedFillResults)
2760     {
2761         matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;
2762         matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;
2763         matchedFillResults.left.takerAssetFilledAmount = rightMakerAssetAmountRemaining;
2764         // Round down to ensure the left maker's exchange rate does not exceed the price specified by the order.
2765         // We favor the left maker when the exchange rate must be rounded and the profit is being paid in the
2766         // left maker asset.
2767         matchedFillResults.left.makerAssetFilledAmount = LibMath.safeGetPartialAmountFloor(
2768             leftOrder.makerAssetAmount,
2769             leftOrder.takerAssetAmount,
2770             rightMakerAssetAmountRemaining
2771         );
2772 
2773         return matchedFillResults;
2774     }
2775 }
2776 
2777 contract IExchangeCore {
2778 
2779     // Fill event is emitted whenever an order is filled.
2780     event Fill(
2781         address indexed makerAddress,         // Address that created the order.
2782         address indexed feeRecipientAddress,  // Address that received fees.
2783         bytes makerAssetData,                 // Encoded data specific to makerAsset.
2784         bytes takerAssetData,                 // Encoded data specific to takerAsset.
2785         bytes makerFeeAssetData,              // Encoded data specific to makerFeeAsset.
2786         bytes takerFeeAssetData,              // Encoded data specific to takerFeeAsset.
2787         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getTypedDataHash).
2788         address takerAddress,                 // Address that filled the order.
2789         address senderAddress,                // Address that called the Exchange contract (msg.sender).
2790         uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker.
2791         uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
2792         uint256 makerFeePaid,                 // Amount of makerFeeAssetData paid to feeRecipient by maker.
2793         uint256 takerFeePaid,                 // Amount of takerFeeAssetData paid to feeRecipient by taker.
2794         uint256 protocolFeePaid               // Amount of eth or weth paid to the staking contract.
2795     );
2796 
2797     // Cancel event is emitted whenever an individual order is cancelled.
2798     event Cancel(
2799         address indexed makerAddress,         // Address that created the order.
2800         address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.
2801         bytes makerAssetData,                 // Encoded data specific to makerAsset.
2802         bytes takerAssetData,                 // Encoded data specific to takerAsset.
2803         address senderAddress,                // Address that called the Exchange contract (msg.sender).
2804         bytes32 indexed orderHash             // EIP712 hash of order (see LibOrder.getTypedDataHash).
2805     );
2806 
2807     // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
2808     event CancelUpTo(
2809         address indexed makerAddress,         // Orders cancelled must have been created by this address.
2810         address indexed orderSenderAddress,   // Orders cancelled must have a `senderAddress` equal to this address.
2811         uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.
2812     );
2813 
2814     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
2815     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
2816     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
2817     function cancelOrdersUpTo(uint256 targetOrderEpoch)
2818         external
2819         payable;
2820 
2821     /// @dev Fills the input order.
2822     /// @param order Order struct containing order specifications.
2823     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2824     /// @param signature Proof that order has been created by maker.
2825     /// @return Amounts filled and fees paid by maker and taker.
2826     function fillOrder(
2827         LibOrder.Order memory order,
2828         uint256 takerAssetFillAmount,
2829         bytes memory signature
2830     )
2831         public
2832         payable
2833         returns (LibFillResults.FillResults memory fillResults);
2834 
2835     /// @dev After calling, the order can not be filled anymore.
2836     /// @param order Order struct containing order specifications.
2837     function cancelOrder(LibOrder.Order memory order)
2838         public
2839         payable;
2840 
2841     /// @dev Gets information about an order: status, hash, and amount filled.
2842     /// @param order Order to gather information on.
2843     /// @return OrderInfo Information about the order and its state.
2844     ///                   See LibOrder.OrderInfo for a complete description.
2845     function getOrderInfo(LibOrder.Order memory order)
2846         public
2847         view
2848         returns (LibOrder.OrderInfo memory orderInfo);
2849 }
2850 
2851 /*
2852 
2853   Copyright 2019 ZeroEx Intl.
2854 
2855   Licensed under the Apache License, Version 2.0 (the "License");
2856   you may not use this file except in compliance with the License.
2857   You may obtain a copy of the License at
2858 
2859     http://www.apache.org/licenses/LICENSE-2.0
2860 
2861   Unless required by applicable law or agreed to in writing, software
2862   distributed under the License is distributed on an "AS IS" BASIS,
2863   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2864   See the License for the specific language governing permissions and
2865   limitations under the License.
2866 
2867 */
2868 
2869 contract IProtocolFees {
2870 
2871     // Logs updates to the protocol fee multiplier.
2872     event ProtocolFeeMultiplier(uint256 oldProtocolFeeMultiplier, uint256 updatedProtocolFeeMultiplier);
2873 
2874     // Logs updates to the protocolFeeCollector address.
2875     event ProtocolFeeCollectorAddress(address oldProtocolFeeCollector, address updatedProtocolFeeCollector);
2876 
2877     /// @dev Allows the owner to update the protocol fee multiplier.
2878     /// @param updatedProtocolFeeMultiplier The updated protocol fee multiplier.
2879     function setProtocolFeeMultiplier(uint256 updatedProtocolFeeMultiplier)
2880         external;
2881 
2882     /// @dev Allows the owner to update the protocolFeeCollector address.
2883     /// @param updatedProtocolFeeCollector The updated protocolFeeCollector contract address.
2884     function setProtocolFeeCollectorAddress(address updatedProtocolFeeCollector)
2885         external;
2886 
2887     /// @dev Returns the protocolFeeMultiplier
2888     function protocolFeeMultiplier()
2889         external
2890         view
2891         returns (uint256);
2892 
2893     /// @dev Returns the protocolFeeCollector address
2894     function protocolFeeCollector()
2895         external
2896         view
2897         returns (address);
2898 }
2899 
2900 /*
2901 
2902   Copyright 2019 ZeroEx Intl.
2903 
2904   Licensed under the Apache License, Version 2.0 (the "License");
2905   you may not use this file except in compliance with the License.
2906   You may obtain a copy of the License at
2907 
2908     http://www.apache.org/licenses/LICENSE-2.0
2909 
2910   Unless required by applicable law or agreed to in writing, software
2911   distributed under the License is distributed on an "AS IS" BASIS,
2912   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2913   See the License for the specific language governing permissions and
2914   limitations under the License.
2915 
2916 */
2917 
2918 contract IMatchOrders {
2919 
2920     /// @dev Match complementary orders that have a profitable spread.
2921     ///      Each order is filled at their respective price point, and
2922     ///      the matcher receives a profit denominated in the left maker asset.
2923     /// @param leftOrders Set of orders with the same maker / taker asset.
2924     /// @param rightOrders Set of orders to match against `leftOrders`
2925     /// @param leftSignatures Proof that left orders were created by the left makers.
2926     /// @param rightSignatures Proof that right orders were created by the right makers.
2927     /// @return batchMatchedFillResults Amounts filled and profit generated.
2928     function batchMatchOrders(
2929         LibOrder.Order[] memory leftOrders,
2930         LibOrder.Order[] memory rightOrders,
2931         bytes[] memory leftSignatures,
2932         bytes[] memory rightSignatures
2933     )
2934         public
2935         payable
2936         returns (LibFillResults.BatchMatchedFillResults memory batchMatchedFillResults);
2937 
2938     /// @dev Match complementary orders that have a profitable spread.
2939     ///      Each order is maximally filled at their respective price point, and
2940     ///      the matcher receives a profit denominated in either the left maker asset,
2941     ///      right maker asset, or a combination of both.
2942     /// @param leftOrders Set of orders with the same maker / taker asset.
2943     /// @param rightOrders Set of orders to match against `leftOrders`
2944     /// @param leftSignatures Proof that left orders were created by the left makers.
2945     /// @param rightSignatures Proof that right orders were created by the right makers.
2946     /// @return batchMatchedFillResults Amounts filled and profit generated.
2947     function batchMatchOrdersWithMaximalFill(
2948         LibOrder.Order[] memory leftOrders,
2949         LibOrder.Order[] memory rightOrders,
2950         bytes[] memory leftSignatures,
2951         bytes[] memory rightSignatures
2952     )
2953         public
2954         payable
2955         returns (LibFillResults.BatchMatchedFillResults memory batchMatchedFillResults);
2956 
2957     /// @dev Match two complementary orders that have a profitable spread.
2958     ///      Each order is filled at their respective price point. However, the calculations are
2959     ///      carried out as though the orders are both being filled at the right order's price point.
2960     ///      The profit made by the left order goes to the taker (who matched the two orders).
2961     /// @param leftOrder First order to match.
2962     /// @param rightOrder Second order to match.
2963     /// @param leftSignature Proof that order was created by the left maker.
2964     /// @param rightSignature Proof that order was created by the right maker.
2965     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
2966     function matchOrders(
2967         LibOrder.Order memory leftOrder,
2968         LibOrder.Order memory rightOrder,
2969         bytes memory leftSignature,
2970         bytes memory rightSignature
2971     )
2972         public
2973         payable
2974         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
2975 
2976     /// @dev Match two complementary orders that have a profitable spread.
2977     ///      Each order is maximally filled at their respective price point, and
2978     ///      the matcher receives a profit denominated in either the left maker asset,
2979     ///      right maker asset, or a combination of both.
2980     /// @param leftOrder First order to match.
2981     /// @param rightOrder Second order to match.
2982     /// @param leftSignature Proof that order was created by the left maker.
2983     /// @param rightSignature Proof that order was created by the right maker.
2984     /// @return matchedFillResults Amounts filled by maker and taker of matched orders.
2985     function matchOrdersWithMaximalFill(
2986         LibOrder.Order memory leftOrder,
2987         LibOrder.Order memory rightOrder,
2988         bytes memory leftSignature,
2989         bytes memory rightSignature
2990     )
2991         public
2992         payable
2993         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
2994 }
2995 
2996 /*
2997 
2998   Copyright 2019 ZeroEx Intl.
2999 
3000   Licensed under the Apache License, Version 2.0 (the "License");
3001   you may not use this file except in compliance with the License.
3002   You may obtain a copy of the License at
3003 
3004     http://www.apache.org/licenses/LICENSE-2.0
3005 
3006   Unless required by applicable law or agreed to in writing, software
3007   distributed under the License is distributed on an "AS IS" BASIS,
3008   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3009   See the License for the specific language governing permissions and
3010   limitations under the License.
3011 
3012 */
3013 
3014 /*
3015 
3016   Copyright 2019 ZeroEx Intl.
3017 
3018   Licensed under the Apache License, Version 2.0 (the "License");
3019   you may not use this file except in compliance with the License.
3020   You may obtain a copy of the License at
3021 
3022     http://www.apache.org/licenses/LICENSE-2.0
3023 
3024   Unless required by applicable law or agreed to in writing, software
3025   distributed under the License is distributed on an "AS IS" BASIS,
3026   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3027   See the License for the specific language governing permissions and
3028   limitations under the License.
3029 
3030 */
3031 
3032 library LibZeroExTransaction {
3033 
3034     using LibZeroExTransaction for ZeroExTransaction;
3035 
3036     // Hash for the EIP712 0x transaction schema
3037     // keccak256(abi.encodePacked(
3038     //    "ZeroExTransaction(",
3039     //    "uint256 salt,",
3040     //    "uint256 expirationTimeSeconds,",
3041     //    "uint256 gasPrice,",
3042     //    "address signerAddress,",
3043     //    "bytes data",
3044     //    ")"
3045     // ));
3046     bytes32 constant internal _EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = 0xec69816980a3a3ca4554410e60253953e9ff375ba4536a98adfa15cc71541508;
3047 
3048     struct ZeroExTransaction {
3049         uint256 salt;                   // Arbitrary number to ensure uniqueness of transaction hash.
3050         uint256 expirationTimeSeconds;  // Timestamp in seconds at which transaction expires.
3051         uint256 gasPrice;               // gasPrice that transaction is required to be executed with.
3052         address signerAddress;          // Address of transaction signer.
3053         bytes data;                     // AbiV2 encoded calldata.
3054     }
3055 
3056     /// @dev Calculates the EIP712 typed data hash of a transaction with a given domain separator.
3057     /// @param transaction 0x transaction structure.
3058     /// @return EIP712 typed data hash of the transaction.
3059     function getTypedDataHash(ZeroExTransaction memory transaction, bytes32 eip712ExchangeDomainHash)
3060         internal
3061         pure
3062         returns (bytes32 transactionHash)
3063     {
3064         // Hash the transaction with the domain separator of the Exchange contract.
3065         transactionHash = LibEIP712.hashEIP712Message(
3066             eip712ExchangeDomainHash,
3067             transaction.getStructHash()
3068         );
3069         return transactionHash;
3070     }
3071 
3072     /// @dev Calculates EIP712 hash of the 0x transaction struct.
3073     /// @param transaction 0x transaction structure.
3074     /// @return EIP712 hash of the transaction struct.
3075     function getStructHash(ZeroExTransaction memory transaction)
3076         internal
3077         pure
3078         returns (bytes32 result)
3079     {
3080         bytes32 schemaHash = _EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
3081         bytes memory data = transaction.data;
3082         uint256 salt = transaction.salt;
3083         uint256 expirationTimeSeconds = transaction.expirationTimeSeconds;
3084         uint256 gasPrice = transaction.gasPrice;
3085         address signerAddress = transaction.signerAddress;
3086 
3087         // Assembly for more efficiently computing:
3088         // result = keccak256(abi.encodePacked(
3089         //     schemaHash,
3090         //     salt,
3091         //     expirationTimeSeconds,
3092         //     gasPrice,
3093         //     uint256(signerAddress),
3094         //     keccak256(data)
3095         // ));
3096 
3097         assembly {
3098             // Compute hash of data
3099             let dataHash := keccak256(add(data, 32), mload(data))
3100 
3101             // Load free memory pointer
3102             let memPtr := mload(64)
3103 
3104             mstore(memPtr, schemaHash)                                                                // hash of schema
3105             mstore(add(memPtr, 32), salt)                                                             // salt
3106             mstore(add(memPtr, 64), expirationTimeSeconds)                                            // expirationTimeSeconds
3107             mstore(add(memPtr, 96), gasPrice)                                                         // gasPrice
3108             mstore(add(memPtr, 128), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
3109             mstore(add(memPtr, 160), dataHash)                                                        // hash of data
3110 
3111             // Compute hash
3112             result := keccak256(memPtr, 192)
3113         }
3114         return result;
3115     }
3116 }
3117 
3118 contract ISignatureValidator {
3119 
3120    // Allowed signature types.
3121     enum SignatureType {
3122         Illegal,                     // 0x00, default value
3123         Invalid,                     // 0x01
3124         EIP712,                      // 0x02
3125         EthSign,                     // 0x03
3126         Wallet,                      // 0x04
3127         Validator,                   // 0x05
3128         PreSigned,                   // 0x06
3129         EIP1271Wallet,               // 0x07
3130         NSignatureTypes              // 0x08, number of signature types. Always leave at end.
3131     }
3132 
3133     event SignatureValidatorApproval(
3134         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
3135         address indexed validatorAddress,  // Address of signature validator contract.
3136         bool isApproved                    // Approval or disapproval of validator contract.
3137     );
3138 
3139     /// @dev Approves a hash on-chain.
3140     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
3141     /// @param hash Any 32-byte hash.
3142     function preSign(bytes32 hash)
3143         external
3144         payable;
3145 
3146     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
3147     /// @param validatorAddress Address of Validator contract.
3148     /// @param approval Approval or disapproval of  Validator contract.
3149     function setSignatureValidatorApproval(
3150         address validatorAddress,
3151         bool approval
3152     )
3153         external
3154         payable;
3155 
3156     /// @dev Verifies that a hash has been signed by the given signer.
3157     /// @param hash Any 32-byte hash.
3158     /// @param signature Proof that the hash has been signed by signer.
3159     /// @return isValid `true` if the signature is valid for the given hash and signer.
3160     function isValidHashSignature(
3161         bytes32 hash,
3162         address signerAddress,
3163         bytes memory signature
3164     )
3165         public
3166         view
3167         returns (bool isValid);
3168 
3169     /// @dev Verifies that a signature for an order is valid.
3170     /// @param order The order.
3171     /// @param signature Proof that the order has been signed by signer.
3172     /// @return isValid true if the signature is valid for the given order and signer.
3173     function isValidOrderSignature(
3174         LibOrder.Order memory order,
3175         bytes memory signature
3176     )
3177         public
3178         view
3179         returns (bool isValid);
3180 
3181     /// @dev Verifies that a signature for a transaction is valid.
3182     /// @param transaction The transaction.
3183     /// @param signature Proof that the order has been signed by signer.
3184     /// @return isValid true if the signature is valid for the given transaction and signer.
3185     function isValidTransactionSignature(
3186         LibZeroExTransaction.ZeroExTransaction memory transaction,
3187         bytes memory signature
3188     )
3189         public
3190         view
3191         returns (bool isValid);
3192 
3193     /// @dev Verifies that an order, with provided order hash, has been signed
3194     ///      by the given signer.
3195     /// @param order The order.
3196     /// @param orderHash The hash of the order.
3197     /// @param signature Proof that the hash has been signed by signer.
3198     /// @return isValid True if the signature is valid for the given order and signer.
3199     function _isValidOrderWithHashSignature(
3200         LibOrder.Order memory order,
3201         bytes32 orderHash,
3202         bytes memory signature
3203     )
3204         internal
3205         view
3206         returns (bool isValid);
3207 
3208     /// @dev Verifies that a transaction, with provided order hash, has been signed
3209     ///      by the given signer.
3210     /// @param transaction The transaction.
3211     /// @param transactionHash The hash of the transaction.
3212     /// @param signature Proof that the hash has been signed by signer.
3213     /// @return isValid True if the signature is valid for the given transaction and signer.
3214     function _isValidTransactionWithHashSignature(
3215         LibZeroExTransaction.ZeroExTransaction memory transaction,
3216         bytes32 transactionHash,
3217         bytes memory signature
3218     )
3219         internal
3220         view
3221         returns (bool isValid);
3222 }
3223 
3224 /*
3225 
3226   Copyright 2019 ZeroEx Intl.
3227 
3228   Licensed under the Apache License, Version 2.0 (the "License");
3229   you may not use this file except in compliance with the License.
3230   You may obtain a copy of the License at
3231 
3232     http://www.apache.org/licenses/LICENSE-2.0
3233 
3234   Unless required by applicable law or agreed to in writing, software
3235   distributed under the License is distributed on an "AS IS" BASIS,
3236   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3237   See the License for the specific language governing permissions and
3238   limitations under the License.
3239 
3240 */
3241 
3242 contract ITransactions {
3243 
3244     // TransactionExecution event is emitted when a ZeroExTransaction is executed.
3245     event TransactionExecution(bytes32 indexed transactionHash);
3246 
3247     /// @dev Executes an Exchange method call in the context of signer.
3248     /// @param transaction 0x transaction containing salt, signerAddress, and data.
3249     /// @param signature Proof that transaction has been signed by signer.
3250     /// @return ABI encoded return data of the underlying Exchange function call.
3251     function executeTransaction(
3252         LibZeroExTransaction.ZeroExTransaction memory transaction,
3253         bytes memory signature
3254     )
3255         public
3256         payable
3257         returns (bytes memory);
3258 
3259     /// @dev Executes a batch of Exchange method calls in the context of signer(s).
3260     /// @param transactions Array of 0x transactions containing salt, signerAddress, and data.
3261     /// @param signatures Array of proofs that transactions have been signed by signer(s).
3262     /// @return Array containing ABI encoded return data for each of the underlying Exchange function calls.
3263     function batchExecuteTransactions(
3264         LibZeroExTransaction.ZeroExTransaction[] memory transactions,
3265         bytes[] memory signatures
3266     )
3267         public
3268         payable
3269         returns (bytes[] memory);
3270 
3271     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
3272     ///      If calling a fill function, this address will represent the taker.
3273     ///      If calling a cancel function, this address will represent the maker.
3274     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
3275     ///         `msg.sender` if entry point is any other function.
3276     function _getCurrentContextAddress()
3277         internal
3278         view
3279         returns (address);
3280 }
3281 
3282 /*
3283 
3284   Copyright 2019 ZeroEx Intl.
3285 
3286   Licensed under the Apache License, Version 2.0 (the "License");
3287   you may not use this file except in compliance with the License.
3288   You may obtain a copy of the License at
3289 
3290     http://www.apache.org/licenses/LICENSE-2.0
3291 
3292   Unless required by applicable law or agreed to in writing, software
3293   distributed under the License is distributed on an "AS IS" BASIS,
3294   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3295   See the License for the specific language governing permissions and
3296   limitations under the License.
3297 
3298 */
3299 
3300 contract IAssetProxyDispatcher {
3301 
3302     // Logs registration of new asset proxy
3303     event AssetProxyRegistered(
3304         bytes4 id,              // Id of new registered AssetProxy.
3305         address assetProxy      // Address of new registered AssetProxy.
3306     );
3307 
3308     /// @dev Registers an asset proxy to its asset proxy id.
3309     ///      Once an asset proxy is registered, it cannot be unregistered.
3310     /// @param assetProxy Address of new asset proxy to register.
3311     function registerAssetProxy(address assetProxy)
3312         external;
3313 
3314     /// @dev Gets an asset proxy.
3315     /// @param assetProxyId Id of the asset proxy.
3316     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
3317     function getAssetProxy(bytes4 assetProxyId)
3318         external
3319         view
3320         returns (address);
3321 }
3322 
3323 /*
3324 
3325   Copyright 2019 ZeroEx Intl.
3326 
3327   Licensed under the Apache License, Version 2.0 (the "License");
3328   you may not use this file except in compliance with the License.
3329   You may obtain a copy of the License at
3330 
3331     http://www.apache.org/licenses/LICENSE-2.0
3332 
3333   Unless required by applicable law or agreed to in writing, software
3334   distributed under the License is distributed on an "AS IS" BASIS,
3335   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3336   See the License for the specific language governing permissions and
3337   limitations under the License.
3338 
3339 */
3340 
3341 contract IWrapperFunctions {
3342 
3343     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
3344     /// @param order Order struct containing order specifications.
3345     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3346     /// @param signature Proof that order has been created by maker.
3347     function fillOrKillOrder(
3348         LibOrder.Order memory order,
3349         uint256 takerAssetFillAmount,
3350         bytes memory signature
3351     )
3352         public
3353         payable
3354         returns (LibFillResults.FillResults memory fillResults);
3355 
3356     /// @dev Executes multiple calls of fillOrder.
3357     /// @param orders Array of order specifications.
3358     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
3359     /// @param signatures Proofs that orders have been created by makers.
3360     /// @return Array of amounts filled and fees paid by makers and taker.
3361     function batchFillOrders(
3362         LibOrder.Order[] memory orders,
3363         uint256[] memory takerAssetFillAmounts,
3364         bytes[] memory signatures
3365     )
3366         public
3367         payable
3368         returns (LibFillResults.FillResults[] memory fillResults);
3369 
3370     /// @dev Executes multiple calls of fillOrKillOrder.
3371     /// @param orders Array of order specifications.
3372     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
3373     /// @param signatures Proofs that orders have been created by makers.
3374     /// @return Array of amounts filled and fees paid by makers and taker.
3375     function batchFillOrKillOrders(
3376         LibOrder.Order[] memory orders,
3377         uint256[] memory takerAssetFillAmounts,
3378         bytes[] memory signatures
3379     )
3380         public
3381         payable
3382         returns (LibFillResults.FillResults[] memory fillResults);
3383 
3384     /// @dev Executes multiple calls of fillOrder. If any fill reverts, the error is caught and ignored.
3385     /// @param orders Array of order specifications.
3386     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
3387     /// @param signatures Proofs that orders have been created by makers.
3388     /// @return Array of amounts filled and fees paid by makers and taker.
3389     function batchFillOrdersNoThrow(
3390         LibOrder.Order[] memory orders,
3391         uint256[] memory takerAssetFillAmounts,
3392         bytes[] memory signatures
3393     )
3394         public
3395         payable
3396         returns (LibFillResults.FillResults[] memory fillResults);
3397 
3398     /// @dev Executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
3399     ///      If any fill reverts, the error is caught and ignored.
3400     ///      NOTE: This function does not enforce that the takerAsset is the same for each order.
3401     /// @param orders Array of order specifications.
3402     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3403     /// @param signatures Proofs that orders have been signed by makers.
3404     /// @return Amounts filled and fees paid by makers and taker.
3405     function marketSellOrdersNoThrow(
3406         LibOrder.Order[] memory orders,
3407         uint256 takerAssetFillAmount,
3408         bytes[] memory signatures
3409     )
3410         public
3411         payable
3412         returns (LibFillResults.FillResults memory fillResults);
3413 
3414     /// @dev Executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
3415     ///      If any fill reverts, the error is caught and ignored.
3416     ///      NOTE: This function does not enforce that the makerAsset is the same for each order.
3417     /// @param orders Array of order specifications.
3418     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3419     /// @param signatures Proofs that orders have been signed by makers.
3420     /// @return Amounts filled and fees paid by makers and taker.
3421     function marketBuyOrdersNoThrow(
3422         LibOrder.Order[] memory orders,
3423         uint256 makerAssetFillAmount,
3424         bytes[] memory signatures
3425     )
3426         public
3427         payable
3428         returns (LibFillResults.FillResults memory fillResults);
3429 
3430     /// @dev Calls marketSellOrdersNoThrow then reverts if < takerAssetFillAmount has been sold.
3431     ///      NOTE: This function does not enforce that the takerAsset is the same for each order.
3432     /// @param orders Array of order specifications.
3433     /// @param takerAssetFillAmount Minimum amount of takerAsset to sell.
3434     /// @param signatures Proofs that orders have been signed by makers.
3435     /// @return Amounts filled and fees paid by makers and taker.
3436     function marketSellOrdersFillOrKill(
3437         LibOrder.Order[] memory orders,
3438         uint256 takerAssetFillAmount,
3439         bytes[] memory signatures
3440     )
3441         public
3442         payable
3443         returns (LibFillResults.FillResults memory fillResults);
3444 
3445     /// @dev Calls marketBuyOrdersNoThrow then reverts if < makerAssetFillAmount has been bought.
3446     ///      NOTE: This function does not enforce that the makerAsset is the same for each order.
3447     /// @param orders Array of order specifications.
3448     /// @param makerAssetFillAmount Minimum amount of makerAsset to buy.
3449     /// @param signatures Proofs that orders have been signed by makers.
3450     /// @return Amounts filled and fees paid by makers and taker.
3451     function marketBuyOrdersFillOrKill(
3452         LibOrder.Order[] memory orders,
3453         uint256 makerAssetFillAmount,
3454         bytes[] memory signatures
3455     )
3456         public
3457         payable
3458         returns (LibFillResults.FillResults memory fillResults);
3459 
3460     /// @dev Executes multiple calls of cancelOrder.
3461     /// @param orders Array of order specifications.
3462     function batchCancelOrders(LibOrder.Order[] memory orders)
3463         public
3464         payable;
3465 }
3466 
3467 /*
3468 
3469   Copyright 2019 ZeroEx Intl.
3470 
3471   Licensed under the Apache License, Version 2.0 (the "License");
3472   you may not use this file except in compliance with the License.
3473   You may obtain a copy of the License at
3474 
3475     http://www.apache.org/licenses/LICENSE-2.0
3476 
3477   Unless required by applicable law or agreed to in writing, software
3478   distributed under the License is distributed on an "AS IS" BASIS,
3479   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3480   See the License for the specific language governing permissions and
3481   limitations under the License.
3482 
3483 */
3484 
3485 contract ITransferSimulator {
3486 
3487     /// @dev This function may be used to simulate any amount of transfers
3488     /// As they would occur through the Exchange contract. Note that this function
3489     /// will always revert, even if all transfers are successful. However, it may
3490     /// be used with eth_call or with a try/catch pattern in order to simulate
3491     /// the results of the transfers.
3492     /// @param assetData Array of asset details, each encoded per the AssetProxy contract specification.
3493     /// @param fromAddresses Array containing the `from` addresses that correspond with each transfer.
3494     /// @param toAddresses Array containing the `to` addresses that correspond with each transfer.
3495     /// @param amounts Array containing the amounts that correspond to each transfer.
3496     /// @return This function does not return a value. However, it will always revert with
3497     /// `Error("TRANSFERS_SUCCESSFUL")` if all of the transfers were successful.
3498     function simulateDispatchTransferFromCalls(
3499         bytes[] memory assetData,
3500         address[] memory fromAddresses,
3501         address[] memory toAddresses,
3502         uint256[] memory amounts
3503     )
3504         public;
3505 }
3506 
3507 // solhint-disable no-empty-blocks
3508 contract IExchange is
3509     IProtocolFees,
3510     IExchangeCore,
3511     IMatchOrders,
3512     ISignatureValidator,
3513     ITransactions,
3514     IAssetProxyDispatcher,
3515     ITransferSimulator,
3516     IWrapperFunctions
3517 {}
3518 
3519 /*
3520 
3521   Copyright 2019 ZeroEx Intl.
3522 
3523   Licensed under the Apache License, Version 2.0 (the "License");
3524   you may not use this file except in compliance with the License.
3525   You may obtain a copy of the License at
3526 
3527     http://www.apache.org/licenses/LICENSE-2.0
3528 
3529   Unless required by applicable law or agreed to in writing, software
3530   distributed under the License is distributed on an "AS IS" BASIS,
3531   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3532   See the License for the specific language governing permissions and
3533   limitations under the License.
3534 
3535 */
3536 
3537 library LibWethUtilsRichErrors {
3538 
3539     // bytes4(keccak256("UnregisteredAssetProxyError()"))
3540     bytes4 internal constant UNREGISTERED_ASSET_PROXY_ERROR_SELECTOR =
3541         0xf3b96b8d;
3542 
3543     // bytes4(keccak256("InsufficientEthForFeeError(uint256,uint256)"))
3544     bytes4 internal constant INSUFFICIENT_ETH_FOR_FEE_ERROR_SELECTOR =
3545         0xecf40fd9;
3546 
3547     // bytes4(keccak256("DefaultFunctionWethContractOnlyError(address)"))
3548     bytes4 internal constant DEFAULT_FUNCTION_WETH_CONTRACT_ONLY_ERROR_SELECTOR =
3549         0x08b18698;
3550 
3551     // bytes4(keccak256("EthFeeLengthMismatchError(uint256,uint256)"))
3552     bytes4 internal constant ETH_FEE_LENGTH_MISMATCH_ERROR_SELECTOR =
3553         0x3ecb6ceb;
3554 
3555     // solhint-disable func-name-mixedcase
3556     function UnregisteredAssetProxyError()
3557         internal
3558         pure
3559         returns (bytes memory)
3560     {
3561         return abi.encodeWithSelector(UNREGISTERED_ASSET_PROXY_ERROR_SELECTOR);
3562     }
3563 
3564     function InsufficientEthForFeeError(
3565         uint256 ethFeeRequired,
3566         uint256 ethAvailable
3567     )
3568         internal
3569         pure
3570         returns (bytes memory)
3571     {
3572         return abi.encodeWithSelector(
3573             INSUFFICIENT_ETH_FOR_FEE_ERROR_SELECTOR,
3574             ethFeeRequired,
3575             ethAvailable
3576         );
3577     }
3578 
3579     function DefaultFunctionWethContractOnlyError(
3580         address senderAddress
3581     )
3582         internal
3583         pure
3584         returns (bytes memory)
3585     {
3586         return abi.encodeWithSelector(
3587             DEFAULT_FUNCTION_WETH_CONTRACT_ONLY_ERROR_SELECTOR,
3588             senderAddress
3589         );
3590     }
3591 
3592     function EthFeeLengthMismatchError(
3593         uint256 ethFeesLength,
3594         uint256 feeRecipientsLength
3595     )
3596         internal
3597         pure
3598         returns (bytes memory)
3599     {
3600         return abi.encodeWithSelector(
3601             ETH_FEE_LENGTH_MISMATCH_ERROR_SELECTOR,
3602             ethFeesLength,
3603             feeRecipientsLength
3604         );
3605     }
3606 }
3607 
3608 contract MixinWethUtils {
3609 
3610     uint256 constant internal MAX_UINT256 = uint256(-1);
3611 
3612      // solhint-disable var-name-mixedcase
3613     IEtherToken internal WETH;
3614     bytes internal WETH_ASSET_DATA;
3615     // solhint-enable var-name-mixedcase
3616 
3617     using LibSafeMath for uint256;
3618 
3619     constructor (
3620         address exchange,
3621         address weth
3622     )
3623         public
3624     {
3625         WETH = IEtherToken(weth);
3626         WETH_ASSET_DATA = abi.encodeWithSelector(
3627             IAssetData(address(0)).ERC20Token.selector,
3628             weth
3629         );
3630 
3631         address proxyAddress = IExchange(exchange).getAssetProxy(IAssetData(address(0)).ERC20Token.selector);
3632         if (proxyAddress == address(0)) {
3633             LibRichErrors.rrevert(LibWethUtilsRichErrors.UnregisteredAssetProxyError());
3634         }
3635         WETH.approve(proxyAddress, MAX_UINT256);
3636 
3637         address protocolFeeCollector = IExchange(exchange).protocolFeeCollector();
3638         if (protocolFeeCollector != address(0)) {
3639             WETH.approve(protocolFeeCollector, MAX_UINT256);
3640         }
3641     }
3642 
3643     /// @dev Default payable function, this allows us to withdraw WETH
3644     function ()
3645         external
3646         payable
3647     {
3648         if (msg.sender != address(WETH)) {
3649             LibRichErrors.rrevert(LibWethUtilsRichErrors.DefaultFunctionWethContractOnlyError(
3650                 msg.sender
3651             ));
3652         }
3653     }
3654 
3655     /// @dev Transfers ETH denominated fees to all feeRecipient addresses
3656     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
3657     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
3658     /// @return ethRemaining msg.value minus the amount of ETH spent on affiliate fees.
3659     function _transferEthFeesAndWrapRemaining(
3660         uint256[] memory ethFeeAmounts,
3661         address payable[] memory feeRecipients
3662     )
3663         internal
3664         returns (uint256 ethRemaining)
3665     {
3666         uint256 feesLen = ethFeeAmounts.length;
3667         // ethFeeAmounts len must equal feeRecipients len
3668         if (feesLen != feeRecipients.length) {
3669             LibRichErrors.rrevert(LibWethUtilsRichErrors.EthFeeLengthMismatchError(
3670                 feesLen,
3671                 feeRecipients.length
3672             ));
3673         }
3674 
3675         // This function is always called before any other function, so we assume that
3676         // the ETH remaining is the entire msg.value.
3677         ethRemaining = msg.value;
3678 
3679         for (uint256 i = 0; i != feesLen; i++) {
3680             uint256 ethFeeAmount = ethFeeAmounts[i];
3681             // Ensure there is enough ETH to pay the fee
3682             if (ethRemaining < ethFeeAmount) {
3683                 LibRichErrors.rrevert(LibWethUtilsRichErrors.InsufficientEthForFeeError(
3684                     ethFeeAmount,
3685                     ethRemaining
3686                 ));
3687             }
3688             // Decrease ethRemaining and transfer fee to corresponding feeRecipient
3689             ethRemaining = ethRemaining.safeSub(ethFeeAmount);
3690             feeRecipients[i].transfer(ethFeeAmount);
3691         }
3692 
3693         // Convert remaining ETH to WETH.
3694         WETH.deposit.value(ethRemaining)();
3695 
3696         return ethRemaining;
3697     }
3698 
3699     /// @dev Unwraps WETH and transfers ETH to msg.sender.
3700     /// @param transferAmount Amount of WETH balance to unwrap and transfer.
3701     function _unwrapAndTransferEth(
3702         uint256 transferAmount
3703     )
3704         internal
3705     {
3706         // Do nothing if amount is zero
3707         if (transferAmount > 0) {
3708             // Convert WETH to ETH
3709             WETH.withdraw(transferAmount);
3710             // Transfer ETH to sender
3711             msg.sender.transfer(transferAmount);
3712         }
3713     }
3714 }
3715 
3716 /*
3717 
3718   Copyright 2019 ZeroEx Intl.
3719 
3720   Licensed under the Apache License, Version 2.0 (the "License");
3721   you may not use this file except in compliance with the License.
3722   You may obtain a copy of the License at
3723 
3724     http://www.apache.org/licenses/LICENSE-2.0
3725 
3726   Unless required by applicable law or agreed to in writing, software
3727   distributed under the License is distributed on an "AS IS" BASIS,
3728   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3729   See the License for the specific language governing permissions and
3730   limitations under the License.
3731 
3732 */
3733 
3734 /*
3735 
3736   Copyright 2019 ZeroEx Intl.
3737 
3738   Licensed under the Apache License, Version 2.0 (the "License");
3739   you may not use this file except in compliance with the License.
3740   You may obtain a copy of the License at
3741 
3742     http://www.apache.org/licenses/LICENSE-2.0
3743 
3744   Unless required by applicable law or agreed to in writing, software
3745   distributed under the License is distributed on an "AS IS" BASIS,
3746   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3747   See the License for the specific language governing permissions and
3748   limitations under the License.
3749 
3750 */
3751 
3752 contract IOwnable {
3753 
3754     /// @dev Emitted by Ownable when ownership is transferred.
3755     /// @param previousOwner The previous owner of the contract.
3756     /// @param newOwner The new owner of the contract.
3757     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3758 
3759     /// @dev Transfers ownership of the contract to a new address.
3760     /// @param newOwner The address that will become the owner.
3761     function transferOwnership(address newOwner)
3762         public;
3763 }
3764 
3765 library LibOwnableRichErrors {
3766 
3767     // bytes4(keccak256("OnlyOwnerError(address,address)"))
3768     bytes4 internal constant ONLY_OWNER_ERROR_SELECTOR =
3769         0x1de45ad1;
3770 
3771     // bytes4(keccak256("TransferOwnerToZeroError()"))
3772     bytes internal constant TRANSFER_OWNER_TO_ZERO_ERROR_BYTES =
3773         hex"e69edc3e";
3774 
3775     // solhint-disable func-name-mixedcase
3776     function OnlyOwnerError(
3777         address sender,
3778         address owner
3779     )
3780         internal
3781         pure
3782         returns (bytes memory)
3783     {
3784         return abi.encodeWithSelector(
3785             ONLY_OWNER_ERROR_SELECTOR,
3786             sender,
3787             owner
3788         );
3789     }
3790 
3791     function TransferOwnerToZeroError()
3792         internal
3793         pure
3794         returns (bytes memory)
3795     {
3796         return TRANSFER_OWNER_TO_ZERO_ERROR_BYTES;
3797     }
3798 }
3799 
3800 contract Ownable is
3801     IOwnable
3802 {
3803     /// @dev The owner of this contract.
3804     /// @return 0 The owner address.
3805     address public owner;
3806 
3807     constructor ()
3808         public
3809     {
3810         owner = msg.sender;
3811     }
3812 
3813     modifier onlyOwner() {
3814         _assertSenderIsOwner();
3815         _;
3816     }
3817 
3818     /// @dev Change the owner of this contract.
3819     /// @param newOwner New owner address.
3820     function transferOwnership(address newOwner)
3821         public
3822         onlyOwner
3823     {
3824         if (newOwner == address(0)) {
3825             LibRichErrors.rrevert(LibOwnableRichErrors.TransferOwnerToZeroError());
3826         } else {
3827             owner = newOwner;
3828             emit OwnershipTransferred(msg.sender, newOwner);
3829         }
3830     }
3831 
3832     function _assertSenderIsOwner()
3833         internal
3834         view
3835     {
3836         if (msg.sender != owner) {
3837             LibRichErrors.rrevert(LibOwnableRichErrors.OnlyOwnerError(
3838                 msg.sender,
3839                 owner
3840             ));
3841         }
3842     }
3843 }
3844 
3845 /*
3846 
3847   Copyright 2019 ZeroEx Intl.
3848 
3849   Licensed under the Apache License, Version 2.0 (the "License");
3850   you may not use this file except in compliance with the License.
3851   You may obtain a copy of the License at
3852 
3853     http://www.apache.org/licenses/LICENSE-2.0
3854 
3855   Unless required by applicable law or agreed to in writing, software
3856   distributed under the License is distributed on an "AS IS" BASIS,
3857   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3858   See the License for the specific language governing permissions and
3859   limitations under the License.
3860 
3861 */
3862 
3863 library LibForwarderRichErrors {
3864 
3865     // bytes4(keccak256("UnregisteredAssetProxyError()"))
3866     bytes4 internal constant UNREGISTERED_ASSET_PROXY_ERROR_SELECTOR =
3867         0xf3b96b8d;
3868 
3869     // bytes4(keccak256("CompleteBuyFailedError(uint256,uint256)"))
3870     bytes4 internal constant COMPLETE_BUY_FAILED_ERROR_SELECTOR =
3871         0x91353a0c;
3872 
3873     // bytes4(keccak256("CompleteSellFailedError(uint256,uint256)"))
3874     bytes4 internal constant COMPLETE_SELL_FAILED_ERROR_SELECTOR =
3875         0x450a0219;
3876 
3877     // bytes4(keccak256("UnsupportedFeeError(bytes)"))
3878     bytes4 internal constant UNSUPPORTED_FEE_ERROR_SELECTOR =
3879         0x31360af1;
3880 
3881     // bytes4(keccak256("OverspentWethError(uint256,uint256)"))
3882     bytes4 internal constant OVERSPENT_WETH_ERROR_SELECTOR =
3883         0xcdcbed5d;
3884 
3885     // solhint-disable func-name-mixedcase
3886     function UnregisteredAssetProxyError()
3887         internal
3888         pure
3889         returns (bytes memory)
3890     {
3891         return abi.encodeWithSelector(UNREGISTERED_ASSET_PROXY_ERROR_SELECTOR);
3892     }
3893 
3894     function CompleteBuyFailedError(
3895         uint256 expectedAssetBuyAmount,
3896         uint256 actualAssetBuyAmount
3897     )
3898         internal
3899         pure
3900         returns (bytes memory)
3901     {
3902         return abi.encodeWithSelector(
3903             COMPLETE_BUY_FAILED_ERROR_SELECTOR,
3904             expectedAssetBuyAmount,
3905             actualAssetBuyAmount
3906         );
3907     }
3908 
3909     function CompleteSellFailedError(
3910         uint256 expectedAssetSellAmount,
3911         uint256 actualAssetSellAmount
3912     )
3913         internal
3914         pure
3915         returns (bytes memory)
3916     {
3917         return abi.encodeWithSelector(
3918             COMPLETE_SELL_FAILED_ERROR_SELECTOR,
3919             expectedAssetSellAmount,
3920             actualAssetSellAmount
3921         );
3922     }
3923 
3924     function UnsupportedFeeError(
3925         bytes memory takerFeeAssetData
3926     )
3927         internal
3928         pure
3929         returns (bytes memory)
3930     {
3931         return abi.encodeWithSelector(
3932             UNSUPPORTED_FEE_ERROR_SELECTOR,
3933             takerFeeAssetData
3934         );
3935     }
3936 
3937     function OverspentWethError(
3938         uint256 wethSpent,
3939         uint256 msgValue
3940     )
3941         internal
3942         pure
3943         returns (bytes memory)
3944     {
3945         return abi.encodeWithSelector(
3946             OVERSPENT_WETH_ERROR_SELECTOR,
3947             wethSpent,
3948             msgValue
3949         );
3950     }
3951 }
3952 
3953 /*
3954 
3955   Copyright 2019 ZeroEx Intl.
3956 
3957   Licensed under the Apache License, Version 2.0 (the "License");
3958   you may not use this file except in compliance with the License.
3959   You may obtain a copy of the License at
3960 
3961     http://www.apache.org/licenses/LICENSE-2.0
3962 
3963   Unless required by applicable law or agreed to in writing, software
3964   distributed under the License is distributed on an "AS IS" BASIS,
3965   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3966   See the License for the specific language governing permissions and
3967   limitations under the License.
3968 
3969 */
3970 
3971 /*
3972 
3973   Copyright 2019 ZeroEx Intl.
3974 
3975   Licensed under the Apache License, Version 2.0 (the "License");
3976   you may not use this file except in compliance with the License.
3977   You may obtain a copy of the License at
3978 
3979     http://www.apache.org/licenses/LICENSE-2.0
3980 
3981   Unless required by applicable law or agreed to in writing, software
3982   distributed under the License is distributed on an "AS IS" BASIS,
3983   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3984   See the License for the specific language governing permissions and
3985   limitations under the License.
3986 
3987 */
3988 
3989 contract IExchangeV2 {
3990 
3991     // solhint-disable max-line-length
3992     struct Order {
3993         address makerAddress;           // Address that created the order.
3994         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
3995         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
3996         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
3997         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
3998         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
3999         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
4000         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
4001         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
4002         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
4003         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
4004         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
4005     }
4006     // solhint-enable max-line-length
4007 
4008     struct FillResults {
4009         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
4010         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
4011         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
4012         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
4013     }
4014 
4015     struct OrderInfo {
4016         uint8 orderStatus;                    // Status that describes order's validity and fillability.
4017         bytes32 orderHash;                    // EIP712 typed data hash of the order (see LibOrder.getTypedDataHash).
4018         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
4019     }
4020 
4021     /// @dev Fills the input order.
4022     /// @param order Order struct containing order specifications.
4023     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
4024     /// @param signature Proof that order has been created by maker.
4025     /// @return Amounts filled and fees paid by maker and taker.
4026     function fillOrder(
4027         Order memory order,
4028         uint256 takerAssetFillAmount,
4029         bytes memory signature
4030     )
4031         public
4032         returns (FillResults memory fillResults);
4033 
4034     /// @dev Gets information about an order: status, hash, and amount filled.
4035     /// @param order Order to gather information on.
4036     /// @return OrderInfo Information about the order and its state.
4037     ///         See LibOrder.OrderInfo for a complete description.
4038     function getOrderInfo(Order memory order)
4039         public
4040         returns (OrderInfo memory orderInfo);
4041 }
4042 
4043 contract MixinExchangeWrapper {
4044 
4045     // The v2 order id is the first 4 bytes of the ExchangeV2 order schema hash.
4046     // bytes4(keccak256(abi.encodePacked(
4047     //     "Order(",
4048     //     "address makerAddress,",
4049     //     "address takerAddress,",
4050     //     "address feeRecipientAddress,",
4051     //     "address senderAddress,",
4052     //     "uint256 makerAssetAmount,",
4053     //     "uint256 takerAssetAmount,",
4054     //     "uint256 makerFee,",
4055     //     "uint256 takerFee,",
4056     //     "uint256 expirationTimeSeconds,",
4057     //     "uint256 salt,",
4058     //     "bytes makerAssetData,",
4059     //     "bytes takerAssetData",
4060     //     ")"
4061     // )));
4062     bytes4 constant public EXCHANGE_V2_ORDER_ID = 0x770501f8;
4063     bytes4 constant internal ERC20_BRIDGE_PROXY_ID = 0xdc1600f3;
4064 
4065      // solhint-disable var-name-mixedcase
4066     IExchange internal EXCHANGE;
4067     IExchangeV2 internal EXCHANGE_V2;
4068     // solhint-enable var-name-mixedcase
4069 
4070     using LibBytes for bytes;
4071     using LibAssetDataTransfer for bytes;
4072     using LibSafeMath for uint256;
4073 
4074     constructor (
4075         address _exchange,
4076         address _exchangeV2
4077     )
4078         public
4079     {
4080         EXCHANGE = IExchange(_exchange);
4081         EXCHANGE_V2 = IExchangeV2(_exchangeV2);
4082     }
4083 
4084     struct SellFillResults {
4085         uint256 wethSpentAmount;
4086         uint256 makerAssetAcquiredAmount;
4087         uint256 protocolFeePaid;
4088     }
4089 
4090     /// @dev Fills the input order.
4091     ///      Returns false if the transaction would otherwise revert.
4092     /// @param order Order struct containing order specifications.
4093     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
4094     /// @param signature Proof that order has been created by maker.
4095     /// @return Amounts filled and fees paid by maker and taker.
4096     function _fillOrderNoThrow(
4097         LibOrder.Order memory order,
4098         uint256 takerAssetFillAmount,
4099         bytes memory signature
4100     )
4101         internal
4102         returns (LibFillResults.FillResults memory fillResults)
4103     {
4104         if (_isV2Order(order)) {
4105             return _fillV2OrderNoThrow(
4106                 order,
4107                 takerAssetFillAmount,
4108                 signature
4109             );
4110         }
4111 
4112         return _fillV3OrderNoThrow(
4113             order,
4114             takerAssetFillAmount,
4115             signature
4116         );
4117     }
4118 
4119     /// @dev Executes a single call of fillOrder according to the wethSellAmount and
4120     ///      the amount already sold.
4121     /// @param order A single order specification.
4122     /// @param signature Signature for the given order.
4123     /// @param remainingTakerAssetFillAmount Remaining amount of WETH to sell.
4124     /// @return wethSpentAmount Amount of WETH spent on the given order.
4125     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given order.
4126     function _marketSellSingleOrder(
4127         LibOrder.Order memory order,
4128         bytes memory signature,
4129         uint256 remainingTakerAssetFillAmount
4130     )
4131         internal
4132         returns (SellFillResults memory sellFillResults)
4133     {
4134         // If the maker asset is ERC20Bridge, take a snapshot of the Forwarder contract's balance.
4135         bytes4 makerAssetProxyId = order.makerAssetData.readBytes4(0);
4136         address tokenAddress;
4137         uint256 balanceBefore;
4138         if (makerAssetProxyId == ERC20_BRIDGE_PROXY_ID) {
4139             tokenAddress = order.makerAssetData.readAddress(16);
4140             balanceBefore = IERC20Token(tokenAddress).balanceOf(address(this));
4141         }
4142         // No taker fee or percentage fee
4143         if (
4144             order.takerFee == 0 ||
4145             _areUnderlyingAssetsEqual(order.takerFeeAssetData, order.makerAssetData)
4146         ) {
4147             // Attempt to sell the remaining amount of WETH
4148             LibFillResults.FillResults memory singleFillResults = _fillOrderNoThrow(
4149                 order,
4150                 remainingTakerAssetFillAmount,
4151                 signature
4152             );
4153 
4154             sellFillResults.wethSpentAmount = singleFillResults.takerAssetFilledAmount;
4155             sellFillResults.protocolFeePaid = singleFillResults.protocolFeePaid;
4156 
4157             // Subtract fee from makerAssetFilledAmount for the net amount acquired.
4158             sellFillResults.makerAssetAcquiredAmount = singleFillResults.makerAssetFilledAmount
4159                 .safeSub(singleFillResults.takerFeePaid);
4160 
4161         // WETH fee
4162         } else if (_areUnderlyingAssetsEqual(order.takerFeeAssetData, order.takerAssetData)) {
4163 
4164             // We will first sell WETH as the takerAsset, then use it to pay the takerFee.
4165             // This ensures that we reserve enough to pay the taker and protocol fees.
4166             uint256 takerAssetFillAmount = LibMath.getPartialAmountCeil(
4167                 order.takerAssetAmount,
4168                 order.takerAssetAmount.safeAdd(order.takerFee),
4169                 remainingTakerAssetFillAmount
4170             );
4171 
4172             LibFillResults.FillResults memory singleFillResults = _fillOrderNoThrow(
4173                 order,
4174                 takerAssetFillAmount,
4175                 signature
4176             );
4177 
4178             // WETH is also spent on the taker fee, so we add it here.
4179             sellFillResults.wethSpentAmount = singleFillResults.takerAssetFilledAmount
4180                 .safeAdd(singleFillResults.takerFeePaid);
4181             sellFillResults.makerAssetAcquiredAmount = singleFillResults.makerAssetFilledAmount;
4182             sellFillResults.protocolFeePaid = singleFillResults.protocolFeePaid;
4183 
4184         // Unsupported fee
4185         } else {
4186             LibRichErrors.rrevert(LibForwarderRichErrors.UnsupportedFeeError(order.takerFeeAssetData));
4187         }
4188 
4189         // Account for the ERC20Bridge transfering more of the maker asset than expected.
4190         if (makerAssetProxyId == ERC20_BRIDGE_PROXY_ID) {
4191             uint256 balanceAfter = IERC20Token(tokenAddress).balanceOf(address(this));
4192             sellFillResults.makerAssetAcquiredAmount = LibSafeMath.max256(
4193                 balanceAfter.safeSub(balanceBefore),
4194                 sellFillResults.makerAssetAcquiredAmount
4195             );
4196         }
4197 
4198         order.makerAssetData.transferOut(sellFillResults.makerAssetAcquiredAmount);
4199         return sellFillResults;
4200     }
4201 
4202     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
4203     /// @param orders Array of order specifications.
4204     /// @param wethSellAmount Desired amount of WETH to sell.
4205     /// @param signatures Proofs that orders have been signed by makers.
4206     /// @return totalWethSpentAmount Total amount of WETH spent on the given orders.
4207     /// @return totalMakerAssetAcquiredAmount Total amount of maker asset acquired from the given orders.
4208     function _marketSellNoThrow(
4209         LibOrder.Order[] memory orders,
4210         uint256 wethSellAmount,
4211         bytes[] memory signatures
4212     )
4213         internal
4214         returns (
4215             uint256 totalWethSpentAmount,
4216             uint256 totalMakerAssetAcquiredAmount
4217         )
4218     {
4219         uint256 protocolFee = tx.gasprice.safeMul(EXCHANGE.protocolFeeMultiplier());
4220 
4221         for (uint256 i = 0; i != orders.length; i++) {
4222             // Preemptively skip to avoid division by zero in _marketSellSingleOrder
4223             if (orders[i].makerAssetAmount == 0 || orders[i].takerAssetAmount == 0) {
4224                 continue;
4225             }
4226 
4227             // The remaining amount of WETH to sell
4228             uint256 remainingTakerAssetFillAmount = wethSellAmount
4229                 .safeSub(totalWethSpentAmount);
4230             uint256 currentProtocolFee = _isV2Order(orders[i]) ? 0 : protocolFee;
4231             if (remainingTakerAssetFillAmount > currentProtocolFee) {
4232                 // Do not count the protocol fee as part of the fill amount.
4233                 remainingTakerAssetFillAmount = remainingTakerAssetFillAmount.safeSub(currentProtocolFee);
4234             } else {
4235                 // Stop if we don't have at least enough ETH to pay another protocol fee.
4236                 break;
4237             }
4238 
4239             SellFillResults memory sellFillResults = _marketSellSingleOrder(
4240                 orders[i],
4241                 signatures[i],
4242                 remainingTakerAssetFillAmount
4243             );
4244 
4245             totalWethSpentAmount = totalWethSpentAmount
4246                 .safeAdd(sellFillResults.wethSpentAmount)
4247                 .safeAdd(sellFillResults.protocolFeePaid);
4248             totalMakerAssetAcquiredAmount = totalMakerAssetAcquiredAmount
4249                 .safeAdd(sellFillResults.makerAssetAcquiredAmount);
4250 
4251             // Stop execution if the entire amount of WETH has been sold
4252             if (totalWethSpentAmount >= wethSellAmount) {
4253                 break;
4254             }
4255         }
4256     }
4257 
4258     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH (exclusive of protocol fee)
4259     ///      has been sold by taker.
4260     /// @param orders Array of order specifications.
4261     /// @param wethSellAmount Desired amount of WETH to sell.
4262     /// @param signatures Proofs that orders have been signed by makers.
4263     /// @return totalWethSpentAmount Total amount of WETH spent on the given orders.
4264     /// @return totalMakerAssetAcquiredAmount Total amount of maker asset acquired from the given orders.
4265     function _marketSellExactAmountNoThrow(
4266         LibOrder.Order[] memory orders,
4267         uint256 wethSellAmount,
4268         bytes[] memory signatures
4269     )
4270         internal
4271         returns (
4272             uint256 totalWethSpentAmount,
4273             uint256 totalMakerAssetAcquiredAmount
4274         )
4275     {
4276         uint256 totalProtocolFeePaid;
4277 
4278         for (uint256 i = 0; i != orders.length; i++) {
4279             // Preemptively skip to avoid division by zero in _marketSellSingleOrder
4280             if (orders[i].makerAssetAmount == 0 || orders[i].takerAssetAmount == 0) {
4281                 continue;
4282             }
4283 
4284             // The remaining amount of WETH to sell
4285             uint256 remainingTakerAssetFillAmount = wethSellAmount
4286                 .safeSub(totalWethSpentAmount);
4287 
4288             SellFillResults memory sellFillResults = _marketSellSingleOrder(
4289                 orders[i],
4290                 signatures[i],
4291                 remainingTakerAssetFillAmount
4292             );
4293 
4294             totalWethSpentAmount = totalWethSpentAmount
4295                 .safeAdd(sellFillResults.wethSpentAmount);
4296             totalMakerAssetAcquiredAmount = totalMakerAssetAcquiredAmount
4297                 .safeAdd(sellFillResults.makerAssetAcquiredAmount);
4298             totalProtocolFeePaid = totalProtocolFeePaid.safeAdd(sellFillResults.protocolFeePaid);
4299 
4300             // Stop execution if the entire amount of WETH has been sold
4301             if (totalWethSpentAmount >= wethSellAmount) {
4302                 break;
4303             }
4304         }
4305         totalWethSpentAmount = totalWethSpentAmount.safeAdd(totalProtocolFeePaid);
4306     }
4307 
4308     /// @dev Executes a single call of fillOrder according to the makerAssetBuyAmount and
4309     ///      the amount already bought.
4310     /// @param order A single order specification.
4311     /// @param signature Signature for the given order.
4312     /// @param remainingMakerAssetFillAmount Remaining amount of maker asset to buy.
4313     /// @return wethSpentAmount Amount of WETH spent on the given order.
4314     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given order.
4315     function _marketBuySingleOrder(
4316         LibOrder.Order memory order,
4317         bytes memory signature,
4318         uint256 remainingMakerAssetFillAmount
4319     )
4320         internal
4321         returns (
4322             uint256 wethSpentAmount,
4323             uint256 makerAssetAcquiredAmount
4324         )
4325     {
4326         // No taker fee or WETH fee
4327         if (
4328             order.takerFee == 0 ||
4329             _areUnderlyingAssetsEqual(order.takerFeeAssetData, order.takerAssetData)
4330         ) {
4331             // Calculate the remaining amount of takerAsset to sell
4332             uint256 remainingTakerAssetFillAmount = LibMath.getPartialAmountCeil(
4333                 order.takerAssetAmount,
4334                 order.makerAssetAmount,
4335                 remainingMakerAssetFillAmount
4336             );
4337 
4338             // Attempt to sell the remaining amount of takerAsset
4339             LibFillResults.FillResults memory singleFillResults = _fillOrderNoThrow(
4340                 order,
4341                 remainingTakerAssetFillAmount,
4342                 signature
4343             );
4344 
4345             // WETH is also spent on the protocol and taker fees, so we add it here.
4346             wethSpentAmount = singleFillResults.takerAssetFilledAmount
4347                 .safeAdd(singleFillResults.takerFeePaid)
4348                 .safeAdd(singleFillResults.protocolFeePaid);
4349 
4350             makerAssetAcquiredAmount = singleFillResults.makerAssetFilledAmount;
4351 
4352         // Percentage fee
4353         } else if (_areUnderlyingAssetsEqual(order.takerFeeAssetData, order.makerAssetData)) {
4354             // Calculate the remaining amount of takerAsset to sell
4355             uint256 remainingTakerAssetFillAmount = LibMath.getPartialAmountCeil(
4356                 order.takerAssetAmount,
4357                 order.makerAssetAmount.safeSub(order.takerFee),
4358                 remainingMakerAssetFillAmount
4359             );
4360 
4361             // Attempt to sell the remaining amount of takerAsset
4362             LibFillResults.FillResults memory singleFillResults = _fillOrderNoThrow(
4363                 order,
4364                 remainingTakerAssetFillAmount,
4365                 signature
4366             );
4367 
4368             wethSpentAmount = singleFillResults.takerAssetFilledAmount
4369                 .safeAdd(singleFillResults.protocolFeePaid);
4370 
4371             // Subtract fee from makerAssetFilledAmount for the net amount acquired.
4372             makerAssetAcquiredAmount = singleFillResults.makerAssetFilledAmount
4373                 .safeSub(singleFillResults.takerFeePaid);
4374 
4375         // Unsupported fee
4376         } else {
4377             LibRichErrors.rrevert(LibForwarderRichErrors.UnsupportedFeeError(order.takerFeeAssetData));
4378         }
4379 
4380         return (wethSpentAmount, makerAssetAcquiredAmount);
4381     }
4382 
4383     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is acquired.
4384     ///      Note that the Forwarder may fill more than the makerAssetBuyAmount so that, after percentage fees
4385     ///      are paid, the net amount acquired after fees is equal to makerAssetBuyAmount (modulo rounding).
4386     ///      The asset being sold by taker must always be WETH.
4387     /// @param orders Array of order specifications.
4388     /// @param makerAssetBuyAmount Desired amount of makerAsset to fill.
4389     /// @param signatures Proofs that orders have been signed by makers.
4390     /// @return totalWethSpentAmount Total amount of WETH spent on the given orders.
4391     /// @return totalMakerAssetAcquiredAmount Total amount of maker asset acquired from the given orders.
4392     function _marketBuyFillOrKill(
4393         LibOrder.Order[] memory orders,
4394         uint256 makerAssetBuyAmount,
4395         bytes[] memory signatures
4396     )
4397         internal
4398         returns (
4399             uint256 totalWethSpentAmount,
4400             uint256 totalMakerAssetAcquiredAmount
4401         )
4402     {
4403         uint256 ordersLength = orders.length;
4404         for (uint256 i = 0; i != ordersLength; i++) {
4405             // Preemptively skip to avoid division by zero in _marketBuySingleOrder
4406             if (orders[i].makerAssetAmount == 0 || orders[i].takerAssetAmount == 0) {
4407                 continue;
4408             }
4409 
4410             uint256 remainingMakerAssetFillAmount = makerAssetBuyAmount
4411                 .safeSub(totalMakerAssetAcquiredAmount);
4412 
4413             // If the maker asset is ERC20Bridge, take a snapshot of the Forwarder contract's balance.
4414             bytes4 makerAssetProxyId = orders[i].makerAssetData.readBytes4(0);
4415             address tokenAddress;
4416             uint256 balanceBefore;
4417             if (makerAssetProxyId == ERC20_BRIDGE_PROXY_ID) {
4418                 tokenAddress = orders[i].makerAssetData.readAddress(16);
4419                 balanceBefore = IERC20Token(tokenAddress).balanceOf(address(this));
4420             }
4421 
4422             (
4423                 uint256 wethSpentAmount,
4424                 uint256 makerAssetAcquiredAmount
4425             ) = _marketBuySingleOrder(
4426                 orders[i],
4427                 signatures[i],
4428                 remainingMakerAssetFillAmount
4429             );
4430 
4431             // Account for the ERC20Bridge transfering more of the maker asset than expected.
4432             if (makerAssetProxyId == ERC20_BRIDGE_PROXY_ID) {
4433                 uint256 balanceAfter = IERC20Token(tokenAddress).balanceOf(address(this));
4434                 makerAssetAcquiredAmount = LibSafeMath.max256(
4435                     balanceAfter.safeSub(balanceBefore),
4436                     makerAssetAcquiredAmount
4437                 );
4438             }
4439 
4440             orders[i].makerAssetData.transferOut(makerAssetAcquiredAmount);
4441 
4442             totalWethSpentAmount = totalWethSpentAmount
4443                 .safeAdd(wethSpentAmount);
4444             totalMakerAssetAcquiredAmount = totalMakerAssetAcquiredAmount
4445                 .safeAdd(makerAssetAcquiredAmount);
4446 
4447             // Stop execution if the entire amount of makerAsset has been bought
4448             if (totalMakerAssetAcquiredAmount >= makerAssetBuyAmount) {
4449                 break;
4450             }
4451         }
4452 
4453         if (totalMakerAssetAcquiredAmount < makerAssetBuyAmount) {
4454             LibRichErrors.rrevert(LibForwarderRichErrors.CompleteBuyFailedError(
4455                 makerAssetBuyAmount,
4456                 totalMakerAssetAcquiredAmount
4457             ));
4458         }
4459     }
4460 
4461     /// @dev Fills the input ExchangeV2 order. The `makerFeeAssetData` must be
4462     //       equal to EXCHANGE_V2_ORDER_ID (0x770501f8).
4463     ///      Returns false if the transaction would otherwise revert.
4464     /// @param order Order struct containing order specifications.
4465     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
4466     /// @param signature Proof that order has been created by maker.
4467     /// @return Amounts filled and fees paid by maker and taker.
4468     function _fillV2OrderNoThrow(
4469         LibOrder.Order memory order,
4470         uint256 takerAssetFillAmount,
4471         bytes memory signature
4472     )
4473         internal
4474         returns (LibFillResults.FillResults memory fillResults)
4475     {
4476         // Strip v3 specific fields from order
4477         IExchangeV2.Order memory v2Order = IExchangeV2.Order({
4478             makerAddress: order.makerAddress,
4479             takerAddress: order.takerAddress,
4480             feeRecipientAddress: order.feeRecipientAddress,
4481             senderAddress: order.senderAddress,
4482             makerAssetAmount: order.makerAssetAmount,
4483             takerAssetAmount: order.takerAssetAmount,
4484             // NOTE: We assume fees are 0 for all v2 orders. Orders with non-zero fees will fail to be filled.
4485             makerFee: 0,
4486             takerFee: 0,
4487             expirationTimeSeconds: order.expirationTimeSeconds,
4488             salt: order.salt,
4489             makerAssetData: order.makerAssetData,
4490             takerAssetData: order.takerAssetData
4491         });
4492 
4493         // ABI encode calldata for `fillOrder`
4494         bytes memory fillOrderCalldata = abi.encodeWithSelector(
4495             IExchangeV2(address(0)).fillOrder.selector,
4496             v2Order,
4497             takerAssetFillAmount,
4498             signature
4499         );
4500 
4501         address exchange = address(EXCHANGE_V2);
4502         (bool didSucceed, bytes memory returnData) = exchange.call(fillOrderCalldata);
4503         if (didSucceed) {
4504             assert(returnData.length == 128);
4505             // NOTE: makerFeePaid, takerFeePaid, and protocolFeePaid will always be 0 for v2 orders
4506             (fillResults.makerAssetFilledAmount, fillResults.takerAssetFilledAmount) = abi.decode(returnData, (uint256, uint256));
4507         }
4508 
4509         // fillResults values will be 0 by default if call was unsuccessful
4510         return fillResults;
4511     }
4512 
4513     /// @dev Fills the input ExchangeV3 order.
4514     ///      Returns false if the transaction would otherwise revert.
4515     /// @param order Order struct containing order specifications.
4516     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
4517     /// @param signature Proof that order has been created by maker.
4518     /// @return Amounts filled and fees paid by maker and taker.
4519     function _fillV3OrderNoThrow(
4520         LibOrder.Order memory order,
4521         uint256 takerAssetFillAmount,
4522         bytes memory signature
4523     )
4524         internal
4525         returns (LibFillResults.FillResults memory fillResults)
4526     {
4527         // ABI encode calldata for `fillOrder`
4528         bytes memory fillOrderCalldata = abi.encodeWithSelector(
4529             IExchange(address(0)).fillOrder.selector,
4530             order,
4531             takerAssetFillAmount,
4532             signature
4533         );
4534 
4535         address exchange = address(EXCHANGE);
4536         (bool didSucceed, bytes memory returnData) = exchange.call(fillOrderCalldata);
4537         if (didSucceed) {
4538             assert(returnData.length == 160);
4539             fillResults = abi.decode(returnData, (LibFillResults.FillResults));
4540         }
4541 
4542         // fillResults values will be 0 by default if call was unsuccessful
4543         return fillResults;
4544     }
4545 
4546     /// @dev Checks whether one asset is effectively equal to another asset.
4547     ///      This is the case if they have the same ERC20Proxy/ERC20BridgeProxy asset data, or if
4548     ///      one is the ERC20Bridge equivalent of the other.
4549     /// @param assetData1 Byte array encoded for the takerFee asset proxy.
4550     /// @param assetData2 Byte array encoded for the maker asset proxy.
4551     /// @return areEqual Whether or not the underlying assets are equal.
4552     function _areUnderlyingAssetsEqual(
4553         bytes memory assetData1,
4554         bytes memory assetData2
4555     )
4556         internal
4557         pure
4558         returns (bool)
4559     {
4560         bytes4 assetProxyId1 = assetData1.readBytes4(0);
4561         bytes4 assetProxyId2 = assetData2.readBytes4(0);
4562         bytes4 erc20ProxyId = IAssetData(address(0)).ERC20Token.selector;
4563         bytes4 erc20BridgeProxyId = IAssetData(address(0)).ERC20Bridge.selector;
4564 
4565         if (
4566             (assetProxyId1 == erc20ProxyId || assetProxyId1 == erc20BridgeProxyId) &&
4567             (assetProxyId2 == erc20ProxyId || assetProxyId2 == erc20BridgeProxyId)
4568         ) {
4569             // Compare the underlying token addresses.
4570             address token1 = assetData1.readAddress(16);
4571             address token2 = assetData2.readAddress(16);
4572             return (token1 == token2);
4573         } else {
4574             return assetData1.equals(assetData2);
4575         }
4576     }
4577 
4578     /// @dev Checks whether an order is a v2 order.
4579     /// @param order Order struct containing order specifications.
4580     /// @return True if the order's `makerFeeAssetData` is set to the v2 order id.
4581     function _isV2Order(LibOrder.Order memory order)
4582         internal
4583         pure
4584         returns (bool)
4585     {
4586         return order.makerFeeAssetData.length > 3 && order.makerFeeAssetData.readBytes4(0) == EXCHANGE_V2_ORDER_ID;
4587     }
4588 }
4589 
4590 /*
4591 
4592   Copyright 2019 ZeroEx Intl.
4593 
4594   Licensed under the Apache License, Version 2.0 (the "License");
4595   you may not use this file except in compliance with the License.
4596   You may obtain a copy of the License at
4597 
4598     http://www.apache.org/licenses/LICENSE-2.0
4599 
4600   Unless required by applicable law or agreed to in writing, software
4601   distributed under the License is distributed on an "AS IS" BASIS,
4602   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
4603   See the License for the specific language governing permissions and
4604   limitations under the License.
4605 
4606 */
4607 
4608 contract MixinReceiver {
4609 
4610     bytes4 constant public ERC1155_RECEIVED       = 0xf23a6e61;
4611     bytes4 constant public ERC1155_BATCH_RECEIVED = 0xbc197c81;
4612 
4613     /// @notice Handle the receipt of a single ERC1155 token type
4614     /// @dev The smart contract calls this function on the recipient
4615     /// after a `safeTransferFrom`. This function MAY throw to revert and reject the
4616     /// transfer. Return of other than the magic value MUST result in the
4617     ///transaction being reverted
4618     /// Note: the contract address is always the message sender
4619     /// @param operator  The address which called `safeTransferFrom` function
4620     /// @param from      The address which previously owned the token
4621     /// @param id        An array containing the ids of the token being transferred
4622     /// @param value     An array containing the amount of tokens being transferred
4623     /// @param data      Additional data with no specified format
4624     /// @return          `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
4625     function onERC1155Received(
4626         address operator,
4627         address from,
4628         uint256 id,
4629         uint256 value,
4630         bytes calldata data
4631     )
4632         external
4633         returns (bytes4)
4634     {
4635         return ERC1155_RECEIVED;
4636     }
4637 
4638     /// @notice Handle the receipt of multiple ERC1155 token types
4639     /// @dev The smart contract calls this function on the recipient
4640     /// after a `safeTransferFrom`. This function MAY throw to revert and reject the
4641     /// transfer. Return of other than the magic value MUST result in the
4642     /// transaction being reverted
4643     /// Note: the contract address is always the message sender
4644     /// @param operator  The address which called `safeTransferFrom` function
4645     /// @param from      The address which previously owned the token
4646     /// @param ids       An array containing ids of each token being transferred
4647     /// @param values    An array containing amounts of each token being transferred
4648     /// @param data      Additional data with no specified format
4649     /// @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
4650     function onERC1155BatchReceived(
4651         address operator,
4652         address from,
4653         uint256[] calldata ids,
4654         uint256[] calldata values,
4655         bytes calldata data
4656     )
4657         external
4658         returns (bytes4)
4659     {
4660         return ERC1155_BATCH_RECEIVED;
4661     }
4662 }
4663 /*
4664 
4665   Copyright 2019 ZeroEx Intl.
4666 
4667   Licensed under the Apache License, Version 2.0 (the "License");
4668   you may not use this file except in compliance with the License.
4669   You may obtain a copy of the License at
4670 
4671     http://www.apache.org/licenses/LICENSE-2.0
4672 
4673   Unless required by applicable law or agreed to in writing, software
4674   distributed under the License is distributed on an "AS IS" BASIS,
4675   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
4676   See the License for the specific language governing permissions and
4677   limitations under the License.
4678 
4679 */
4680 
4681 contract IForwarder {
4682 
4683     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to
4684     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
4685     ///      used to withdraw assets that were accidentally sent to this contract.
4686     /// @param assetData Byte array encoded for the respective asset proxy.
4687     /// @param amount Amount of ERC20 token to withdraw.
4688     function withdrawAsset(
4689         bytes calldata assetData,
4690         uint256 amount
4691     )
4692         external;
4693 
4694         /// @dev Approves the respective proxy for a given asset to transfer tokens on the Forwarder contract's behalf.
4695         ///      This is necessary because an order fee denominated in the maker asset (i.e. a percentage fee) is sent by the
4696         ///      Forwarder contract to the fee recipient.
4697         ///      This method needs to be called before forwarding orders of a maker asset that hasn't
4698         ///      previously been approved.
4699         /// @param assetData Byte array encoded for the respective asset proxy.
4700     function approveMakerAssetProxy(
4701         bytes calldata assetData
4702     )
4703         external;
4704 
4705     /// @dev Purchases as much of orders' makerAssets as possible by selling as much of the ETH value sent
4706     ///      as possible, accounting for order and forwarder fees.
4707     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
4708     /// @param signatures Proofs that orders have been created by makers.
4709     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
4710     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
4711     /// @return wethSpentAmount Amount of WETH spent on the given set of orders.
4712     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given set of orders.
4713     function marketSellOrdersWithEth(
4714         LibOrder.Order[] memory orders,
4715         bytes[] memory signatures,
4716         uint256[] memory ethFeeAmounts,
4717         address payable[] memory feeRecipients
4718     )
4719         public
4720         payable
4721         returns (
4722             uint256 wethSpentAmount,
4723             uint256 makerAssetAcquiredAmount
4724         );
4725 
4726     /// @dev Attempt to buy makerAssetBuyAmount of makerAsset by selling ETH provided with transaction.
4727     ///      The Forwarder may *fill* more than makerAssetBuyAmount of the makerAsset so that it can
4728     ///      pay takerFees where takerFeeAssetData == makerAssetData (i.e. percentage fees).
4729     ///      Any ETH not spent will be refunded to sender.
4730     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
4731     /// @param makerAssetBuyAmount Desired amount of makerAsset to purchase.
4732     /// @param signatures Proofs that orders have been created by makers.
4733     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
4734     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
4735     /// @return wethSpentAmount Amount of WETH spent on the given set of orders.
4736     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given set of orders.
4737     function marketBuyOrdersWithEth(
4738         LibOrder.Order[] memory orders,
4739         uint256 makerAssetBuyAmount,
4740         bytes[] memory signatures,
4741         uint256[] memory ethFeeAmounts,
4742         address payable[] memory feeRecipients
4743     )
4744         public
4745         payable
4746         returns (
4747             uint256 wethSpentAmount,
4748             uint256 makerAssetAcquiredAmount
4749         );
4750 }
4751 
4752 contract Forwarder is
4753     IForwarder,
4754     Ownable,
4755     MixinWethUtils,
4756     MixinExchangeWrapper,
4757     MixinReceiver
4758 {
4759     using LibBytes for bytes;
4760     using LibAssetDataTransfer for bytes;
4761     using LibSafeMath for uint256;
4762 
4763     constructor (
4764         address _exchange,
4765         address _exchangeV2,
4766         address _weth
4767     )
4768         public
4769         Ownable()
4770         MixinWethUtils(
4771             _exchange,
4772             _weth
4773         )
4774         MixinExchangeWrapper(
4775             _exchange,
4776             _exchangeV2
4777         )
4778     {} // solhint-disable-line no-empty-blocks
4779 
4780     /// @dev Withdraws assets from this contract. It may be used by the owner to withdraw assets
4781     ///      that were accidentally sent to this contract.
4782     /// @param assetData Byte array encoded for the respective asset proxy.
4783     /// @param amount Amount of the asset to withdraw.
4784     function withdrawAsset(
4785         bytes calldata assetData,
4786         uint256 amount
4787     )
4788         external
4789         onlyOwner
4790     {
4791         assetData.transferOut(amount);
4792     }
4793 
4794     /// @dev Approves the respective proxy for a given asset to transfer tokens on the Forwarder contract's behalf.
4795     ///      This is necessary because an order fee denominated in the maker asset (i.e. a percentage fee) is sent by the
4796     ///      Forwarder contract to the fee recipient.
4797     ///      This method needs to be called before forwarding orders of a maker asset that hasn't
4798     ///      previously been approved.
4799     /// @param assetData Byte array encoded for the respective asset proxy.
4800     function approveMakerAssetProxy(bytes calldata assetData)
4801         external
4802     {
4803         bytes4 proxyId = assetData.readBytes4(0);
4804         bytes4 erc20ProxyId = IAssetData(address(0)).ERC20Token.selector;
4805 
4806         // For now we only care about ERC20, since percentage fees on ERC721 tokens are invalid.
4807         if (proxyId == erc20ProxyId) {
4808             address proxyAddress = EXCHANGE.getAssetProxy(erc20ProxyId);
4809             if (proxyAddress == address(0)) {
4810                 LibRichErrors.rrevert(LibForwarderRichErrors.UnregisteredAssetProxyError());
4811             }
4812             address token = assetData.readAddress(16);
4813             LibERC20Token.approve(token, proxyAddress, MAX_UINT256);
4814         }
4815     }
4816 
4817     /// @dev Purchases as much of orders' makerAssets as possible by selling as much of the ETH value sent
4818     ///      as possible, accounting for order and forwarder fees.
4819     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
4820     /// @param signatures Proofs that orders have been created by makers.
4821     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
4822     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
4823     /// @return wethSpentAmount Amount of WETH spent on the given set of orders.
4824     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given set of orders.
4825     function marketSellOrdersWithEth(
4826         LibOrder.Order[] memory orders,
4827         bytes[] memory signatures,
4828         uint256[] memory ethFeeAmounts,
4829         address payable[] memory feeRecipients
4830     )
4831         public
4832         payable
4833         returns (
4834             uint256 wethSpentAmount,
4835             uint256 makerAssetAcquiredAmount
4836         )
4837     {
4838         // Pay ETH affiliate fees to all feeRecipient addresses
4839         uint256 wethRemaining = _transferEthFeesAndWrapRemaining(
4840             ethFeeAmounts,
4841             feeRecipients
4842         );
4843         // Spends up to wethRemaining to fill orders, transfers purchased assets to msg.sender,
4844         // and pays WETH order fees.
4845         (
4846             wethSpentAmount,
4847             makerAssetAcquiredAmount
4848         ) = _marketSellNoThrow(
4849             orders,
4850             wethRemaining,
4851             signatures
4852         );
4853 
4854         // Ensure that no extra WETH owned by this contract has been spent.
4855         if (wethSpentAmount > wethRemaining) {
4856             LibRichErrors.rrevert(LibForwarderRichErrors.OverspentWethError(
4857                 wethSpentAmount,
4858                 msg.value
4859             ));
4860         }
4861 
4862         // Calculate amount of WETH that hasn't been spent.
4863         wethRemaining = wethRemaining.safeSub(wethSpentAmount);
4864 
4865         // Refund remaining ETH to msg.sender.
4866         _unwrapAndTransferEth(wethRemaining);
4867     }
4868 
4869     /// @dev Purchases as much of orders' makerAssets as possible by selling the specified amount of ETH
4870     ///      accounting for order and forwarder fees. This functions throws if ethSellAmount was not reached.
4871     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
4872     /// @param ethSellAmount Desired amount of ETH to sell.
4873     /// @param signatures Proofs that orders have been created by makers.
4874     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
4875     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
4876     /// @return wethSpentAmount Amount of WETH spent on the given set of orders.
4877     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given set of orders.
4878     function marketSellAmountWithEth(
4879         LibOrder.Order[] memory orders,
4880         uint256 ethSellAmount,
4881         bytes[] memory signatures,
4882         uint256[] memory ethFeeAmounts,
4883         address payable[] memory feeRecipients
4884     )
4885         public
4886         payable
4887         returns (
4888             uint256 wethSpentAmount,
4889             uint256 makerAssetAcquiredAmount
4890         )
4891     {
4892         if (ethSellAmount > msg.value) {
4893             LibRichErrors.rrevert(LibForwarderRichErrors.CompleteSellFailedError(
4894                 ethSellAmount,
4895                 msg.value
4896             ));
4897         }
4898         // Pay ETH affiliate fees to all feeRecipient addresses
4899         uint256 wethRemaining = _transferEthFeesAndWrapRemaining(
4900             ethFeeAmounts,
4901             feeRecipients
4902         );
4903         // Need enough remaining to ensure we can sell ethSellAmount
4904         if (wethRemaining < ethSellAmount) {
4905             LibRichErrors.rrevert(LibForwarderRichErrors.OverspentWethError(
4906                 wethRemaining,
4907                 ethSellAmount
4908             ));
4909         }
4910         // Spends up to ethSellAmount to fill orders, transfers purchased assets to msg.sender,
4911         // and pays WETH order fees.
4912         (
4913             wethSpentAmount,
4914             makerAssetAcquiredAmount
4915         ) = _marketSellExactAmountNoThrow(
4916             orders,
4917             ethSellAmount,
4918             signatures
4919         );
4920         // Ensure we sold the specified amount (note: wethSpentAmount includes fees)
4921         if (wethSpentAmount < ethSellAmount) {
4922             LibRichErrors.rrevert(LibForwarderRichErrors.CompleteSellFailedError(
4923                 ethSellAmount,
4924                 wethSpentAmount
4925             ));
4926         }
4927 
4928         // Calculate amount of WETH that hasn't been spent.
4929         wethRemaining = wethRemaining.safeSub(wethSpentAmount);
4930 
4931         // Refund remaining ETH to msg.sender.
4932         _unwrapAndTransferEth(wethRemaining);
4933     }
4934 
4935     /// @dev Attempt to buy makerAssetBuyAmount of makerAsset by selling ETH provided with transaction.
4936     ///      The Forwarder may *fill* more than makerAssetBuyAmount of the makerAsset so that it can
4937     ///      pay takerFees where takerFeeAssetData == makerAssetData (i.e. percentage fees).
4938     ///      Any ETH not spent will be refunded to sender.
4939     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
4940     /// @param makerAssetBuyAmount Desired amount of makerAsset to purchase.
4941     /// @param signatures Proofs that orders have been created by makers.
4942     /// @param ethFeeAmounts Amounts of ETH, denominated in Wei, that are paid to corresponding feeRecipients.
4943     /// @param feeRecipients Addresses that will receive ETH when orders are filled.
4944     /// @return wethSpentAmount Amount of WETH spent on the given set of orders.
4945     /// @return makerAssetAcquiredAmount Amount of maker asset acquired from the given set of orders.
4946     function marketBuyOrdersWithEth(
4947         LibOrder.Order[] memory orders,
4948         uint256 makerAssetBuyAmount,
4949         bytes[] memory signatures,
4950         uint256[] memory ethFeeAmounts,
4951         address payable[] memory feeRecipients
4952     )
4953         public
4954         payable
4955         returns (
4956             uint256 wethSpentAmount,
4957             uint256 makerAssetAcquiredAmount
4958         )
4959     {
4960         // Pay ETH affiliate fees to all feeRecipient addresses
4961         uint256 wethRemaining = _transferEthFeesAndWrapRemaining(
4962             ethFeeAmounts,
4963             feeRecipients
4964         );
4965 
4966         // Attempts to fill the desired amount of makerAsset and trasnfer purchased assets to msg.sender.
4967         (
4968             wethSpentAmount,
4969             makerAssetAcquiredAmount
4970         ) = _marketBuyFillOrKill(
4971             orders,
4972             makerAssetBuyAmount,
4973             signatures
4974         );
4975 
4976         // Ensure that no extra WETH owned by this contract has been spent.
4977         if (wethSpentAmount > wethRemaining) {
4978             LibRichErrors.rrevert(LibForwarderRichErrors.OverspentWethError(
4979                 wethSpentAmount,
4980                 msg.value
4981             ));
4982         }
4983 
4984         // Calculate amount of WETH that hasn't been spent.
4985         wethRemaining = wethRemaining.safeSub(wethSpentAmount);
4986 
4987         // Refund remaining ETH to msg.sender.
4988         _unwrapAndTransferEth(wethRemaining);
4989     }
4990 }