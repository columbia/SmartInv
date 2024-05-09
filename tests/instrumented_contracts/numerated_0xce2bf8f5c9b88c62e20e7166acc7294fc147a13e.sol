1 pragma solidity ^0.4.24;
2 pragma experimental ABIEncoderV2;
3 // File: @0x/contracts-libs/contracts/libs/LibEIP712.sol
4 
5 /*
6 
7   Copyright 2018 ZeroEx Intl.
8 
9   Licensed under the Apache License, Version 2.0 (the "License");
10   you may not use this file except in compliance with the License.
11   You may obtain a copy of the License at
12 
13     http://www.apache.org/licenses/LICENSE-2.0
14 
15   Unless required by applicable law or agreed to in writing, software
16   distributed under the License is distributed on an "AS IS" BASIS,
17   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18   See the License for the specific language governing permissions and
19   limitations under the License.
20 
21 */
22 
23 
24 
25 contract LibEIP712 {
26 
27     // EIP191 header for EIP712 prefix
28     string constant internal EIP191_HEADER = "\x19\x01";
29 
30     // EIP712 Domain Name value
31     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
32 
33     // EIP712 Domain Version value
34     string constant internal EIP712_DOMAIN_VERSION = "2";
35 
36     // Hash of the EIP712 Domain Separator Schema
37     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
38         "EIP712Domain(",
39         "string name,",
40         "string version,",
41         "address verifyingContract",
42         ")"
43     ));
44 
45     // Hash of the EIP712 Domain Separator data
46     // solhint-disable-next-line var-name-mixedcase
47     bytes32 public EIP712_DOMAIN_HASH;
48 
49     constructor ()
50         public
51     {
52         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
53             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
54             keccak256(bytes(EIP712_DOMAIN_NAME)),
55             keccak256(bytes(EIP712_DOMAIN_VERSION)),
56             bytes32(address(this))
57         ));
58     }
59 
60     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
61     /// @param hashStruct The EIP712 hash struct.
62     /// @return EIP712 hash applied to this EIP712 Domain.
63     function hashEIP712Message(bytes32 hashStruct)
64         internal
65         view
66         returns (bytes32 result)
67     {
68         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
69 
70         // Assembly for more efficient computing:
71         // keccak256(abi.encodePacked(
72         //     EIP191_HEADER,
73         //     EIP712_DOMAIN_HASH,
74         //     hashStruct    
75         // ));
76 
77         assembly {
78             // Load free memory pointer
79             let memPtr := mload(64)
80 
81             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
82             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
83             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
84 
85             // Compute hash
86             result := keccak256(memPtr, 66)
87         }
88         return result;
89     }
90 }
91 
92 // File: @0x/contracts-libs/contracts/libs/LibOrder.sol
93 
94 /*
95 
96   Copyright 2018 ZeroEx Intl.
97 
98   Licensed under the Apache License, Version 2.0 (the "License");
99   you may not use this file except in compliance with the License.
100   You may obtain a copy of the License at
101 
102     http://www.apache.org/licenses/LICENSE-2.0
103 
104   Unless required by applicable law or agreed to in writing, software
105   distributed under the License is distributed on an "AS IS" BASIS,
106   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
107   See the License for the specific language governing permissions and
108   limitations under the License.
109 
110 */
111 
112 
113 
114 
115 contract LibOrder is
116     LibEIP712
117 {
118     // Hash for the EIP712 Order Schema
119     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
120         "Order(",
121         "address makerAddress,",
122         "address takerAddress,",
123         "address feeRecipientAddress,",
124         "address senderAddress,",
125         "uint256 makerAssetAmount,",
126         "uint256 takerAssetAmount,",
127         "uint256 makerFee,",
128         "uint256 takerFee,",
129         "uint256 expirationTimeSeconds,",
130         "uint256 salt,",
131         "bytes makerAssetData,",
132         "bytes takerAssetData",
133         ")"
134     ));
135 
136     // A valid order remains fillable until it is expired, fully filled, or cancelled.
137     // An order's state is unaffected by external factors, like account balances.
138     enum OrderStatus {
139         INVALID,                     // Default value
140         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
141         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
142         FILLABLE,                    // Order is fillable
143         EXPIRED,                     // Order has already expired
144         FULLY_FILLED,                // Order is fully filled
145         CANCELLED                    // Order has been cancelled
146     }
147 
148     // solhint-disable max-line-length
149     struct Order {
150         address makerAddress;           // Address that created the order.      
151         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
152         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
153         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
154         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
155         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
156         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
157         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
158         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
159         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
160         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
161         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
162     }
163     // solhint-enable max-line-length
164 
165     struct OrderInfo {
166         uint8 orderStatus;                    // Status that describes order's validity and fillability.
167         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
168         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
169     }
170 
171     /// @dev Calculates Keccak-256 hash of the order.
172     /// @param order The order structure.
173     /// @return Keccak-256 EIP712 hash of the order.
174     function getOrderHash(Order memory order)
175         internal
176         view
177         returns (bytes32 orderHash)
178     {
179         orderHash = hashEIP712Message(hashOrder(order));
180         return orderHash;
181     }
182 
183     /// @dev Calculates EIP712 hash of the order.
184     /// @param order The order structure.
185     /// @return EIP712 hash of the order.
186     function hashOrder(Order memory order)
187         internal
188         pure
189         returns (bytes32 result)
190     {
191         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
192         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
193         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
194 
195         // Assembly for more efficiently computing:
196         // keccak256(abi.encodePacked(
197         //     EIP712_ORDER_SCHEMA_HASH,
198         //     bytes32(order.makerAddress),
199         //     bytes32(order.takerAddress),
200         //     bytes32(order.feeRecipientAddress),
201         //     bytes32(order.senderAddress),
202         //     order.makerAssetAmount,
203         //     order.takerAssetAmount,
204         //     order.makerFee,
205         //     order.takerFee,
206         //     order.expirationTimeSeconds,
207         //     order.salt,
208         //     keccak256(order.makerAssetData),
209         //     keccak256(order.takerAssetData)
210         // ));
211 
212         assembly {
213             // Calculate memory addresses that will be swapped out before hashing
214             let pos1 := sub(order, 32)
215             let pos2 := add(order, 320)
216             let pos3 := add(order, 352)
217 
218             // Backup
219             let temp1 := mload(pos1)
220             let temp2 := mload(pos2)
221             let temp3 := mload(pos3)
222             
223             // Hash in place
224             mstore(pos1, schemaHash)
225             mstore(pos2, makerAssetDataHash)
226             mstore(pos3, takerAssetDataHash)
227             result := keccak256(pos1, 416)
228             
229             // Restore
230             mstore(pos1, temp1)
231             mstore(pos2, temp2)
232             mstore(pos3, temp3)
233         }
234         return result;
235     }
236 }
237 
238 // File: @0x/contracts-utils/contracts/utils/SafeMath/SafeMath.sol
239 
240 contract SafeMath {
241 
242     function safeMul(uint256 a, uint256 b)
243         internal
244         pure
245         returns (uint256)
246     {
247         if (a == 0) {
248             return 0;
249         }
250         uint256 c = a * b;
251         require(
252             c / a == b,
253             "UINT256_OVERFLOW"
254         );
255         return c;
256     }
257 
258     function safeDiv(uint256 a, uint256 b)
259         internal
260         pure
261         returns (uint256)
262     {
263         uint256 c = a / b;
264         return c;
265     }
266 
267     function safeSub(uint256 a, uint256 b)
268         internal
269         pure
270         returns (uint256)
271     {
272         require(
273             b <= a,
274             "UINT256_UNDERFLOW"
275         );
276         return a - b;
277     }
278 
279     function safeAdd(uint256 a, uint256 b)
280         internal
281         pure
282         returns (uint256)
283     {
284         uint256 c = a + b;
285         require(
286             c >= a,
287             "UINT256_OVERFLOW"
288         );
289         return c;
290     }
291 
292     function max64(uint64 a, uint64 b)
293         internal
294         pure
295         returns (uint256)
296     {
297         return a >= b ? a : b;
298     }
299 
300     function min64(uint64 a, uint64 b)
301         internal
302         pure
303         returns (uint256)
304     {
305         return a < b ? a : b;
306     }
307 
308     function max256(uint256 a, uint256 b)
309         internal
310         pure
311         returns (uint256)
312     {
313         return a >= b ? a : b;
314     }
315 
316     function min256(uint256 a, uint256 b)
317         internal
318         pure
319         returns (uint256)
320     {
321         return a < b ? a : b;
322     }
323 }
324 
325 // File: @0x/contracts-libs/contracts/libs/LibFillResults.sol
326 
327 /*
328 
329   Copyright 2018 ZeroEx Intl.
330 
331   Licensed under the Apache License, Version 2.0 (the "License");
332   you may not use this file except in compliance with the License.
333   You may obtain a copy of the License at
334 
335     http://www.apache.org/licenses/LICENSE-2.0
336 
337   Unless required by applicable law or agreed to in writing, software
338   distributed under the License is distributed on an "AS IS" BASIS,
339   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
340   See the License for the specific language governing permissions and
341   limitations under the License.
342 
343 */
344 
345 
346 
347 
348 contract LibFillResults is
349     SafeMath
350 {
351     struct FillResults {
352         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
353         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
354         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
355         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
356     }
357 
358     struct MatchedFillResults {
359         FillResults left;                    // Amounts filled and fees paid of left order.
360         FillResults right;                   // Amounts filled and fees paid of right order.
361         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
362     }
363 
364     /// @dev Adds properties of both FillResults instances.
365     ///      Modifies the first FillResults instance specified.
366     /// @param totalFillResults Fill results instance that will be added onto.
367     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
368     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
369         internal
370         pure
371     {
372         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
373         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
374         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
375         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
376     }
377 }
378 
379 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IExchangeCore.sol
380 
381 /*
382 
383   Copyright 2018 ZeroEx Intl.
384 
385   Licensed under the Apache License, Version 2.0 (the "License");
386   you may not use this file except in compliance with the License.
387   You may obtain a copy of the License at
388 
389     http://www.apache.org/licenses/LICENSE-2.0
390 
391   Unless required by applicable law or agreed to in writing, software
392   distributed under the License is distributed on an "AS IS" BASIS,
393   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
394   See the License for the specific language governing permissions and
395   limitations under the License.
396 
397 */
398 
399 
400 
401 
402 
403 contract IExchangeCore {
404 
405     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
406     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
407     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
408     function cancelOrdersUpTo(uint256 targetOrderEpoch)
409         external;
410 
411     /// @dev Fills the input order.
412     /// @param order Order struct containing order specifications.
413     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
414     /// @param signature Proof that order has been created by maker.
415     /// @return Amounts filled and fees paid by maker and taker.
416     function fillOrder(
417         LibOrder.Order memory order,
418         uint256 takerAssetFillAmount,
419         bytes memory signature
420     )
421         public
422         returns (LibFillResults.FillResults memory fillResults);
423 
424     /// @dev After calling, the order can not be filled anymore.
425     /// @param order Order struct containing order specifications.
426     function cancelOrder(LibOrder.Order memory order)
427         public;
428 
429     /// @dev Gets information about an order: status, hash, and amount filled.
430     /// @param order Order to gather information on.
431     /// @return OrderInfo Information about the order and its state.
432     ///                   See LibOrder.OrderInfo for a complete description.
433     function getOrderInfo(LibOrder.Order memory order)
434         public
435         view
436         returns (LibOrder.OrderInfo memory orderInfo);
437 }
438 
439 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IMatchOrders.sol
440 
441 /*
442 
443   Copyright 2018 ZeroEx Intl.
444 
445   Licensed under the Apache License, Version 2.0 (the "License");
446   you may not use this file except in compliance with the License.
447   You may obtain a copy of the License at
448 
449     http://www.apache.org/licenses/LICENSE-2.0
450 
451   Unless required by applicable law or agreed to in writing, software
452   distributed under the License is distributed on an "AS IS" BASIS,
453   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
454   See the License for the specific language governing permissions and
455   limitations under the License.
456 
457 */
458 
459 
460 
461 
462 
463 contract IMatchOrders {
464 
465     /// @dev Match two complementary orders that have a profitable spread.
466     ///      Each order is filled at their respective price point. However, the calculations are
467     ///      carried out as though the orders are both being filled at the right order's price point.
468     ///      The profit made by the left order goes to the taker (who matched the two orders).
469     /// @param leftOrder First order to match.
470     /// @param rightOrder Second order to match.
471     /// @param leftSignature Proof that order was created by the left maker.
472     /// @param rightSignature Proof that order was created by the right maker.
473     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
474     function matchOrders(
475         LibOrder.Order memory leftOrder,
476         LibOrder.Order memory rightOrder,
477         bytes memory leftSignature,
478         bytes memory rightSignature
479     )
480         public
481         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
482 }
483 
484 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/ISignatureValidator.sol
485 
486 /*
487 
488   Copyright 2018 ZeroEx Intl.
489 
490   Licensed under the Apache License, Version 2.0 (the "License");
491   you may not use this file except in compliance with the License.
492   You may obtain a copy of the License at
493 
494     http://www.apache.org/licenses/LICENSE-2.0
495 
496   Unless required by applicable law or agreed to in writing, software
497   distributed under the License is distributed on an "AS IS" BASIS,
498   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
499   See the License for the specific language governing permissions and
500   limitations under the License.
501 
502 */
503 
504 
505 
506 contract ISignatureValidator {
507 
508     /// @dev Approves a hash on-chain using any valid signature type.
509     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
510     /// @param signerAddress Address that should have signed the given hash.
511     /// @param signature Proof that the hash has been signed by signer.
512     function preSign(
513         bytes32 hash,
514         address signerAddress,
515         bytes signature
516     )
517         external;
518     
519     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
520     /// @param validatorAddress Address of Validator contract.
521     /// @param approval Approval or disapproval of  Validator contract.
522     function setSignatureValidatorApproval(
523         address validatorAddress,
524         bool approval
525     )
526         external;
527 
528     /// @dev Verifies that a signature is valid.
529     /// @param hash Message hash that is signed.
530     /// @param signerAddress Address of signer.
531     /// @param signature Proof of signing.
532     /// @return Validity of order signature.
533     function isValidSignature(
534         bytes32 hash,
535         address signerAddress,
536         bytes memory signature
537     )
538         public
539         view
540         returns (bool isValid);
541 }
542 
543 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/ITransactions.sol
544 
545 /*
546 
547   Copyright 2018 ZeroEx Intl.
548 
549   Licensed under the Apache License, Version 2.0 (the "License");
550   you may not use this file except in compliance with the License.
551   You may obtain a copy of the License at
552 
553     http://www.apache.org/licenses/LICENSE-2.0
554 
555   Unless required by applicable law or agreed to in writing, software
556   distributed under the License is distributed on an "AS IS" BASIS,
557   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
558   See the License for the specific language governing permissions and
559   limitations under the License.
560 
561 */
562 
563 
564 contract ITransactions {
565 
566     /// @dev Executes an exchange method call in the context of signer.
567     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
568     /// @param signerAddress Address of transaction signer.
569     /// @param data AbiV2 encoded calldata.
570     /// @param signature Proof of signer transaction by signer.
571     function executeTransaction(
572         uint256 salt,
573         address signerAddress,
574         bytes data,
575         bytes signature
576     )
577         external;
578 }
579 
580 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IAssetProxyDispatcher.sol
581 
582 /*
583 
584   Copyright 2018 ZeroEx Intl.
585 
586   Licensed under the Apache License, Version 2.0 (the "License");
587   you may not use this file except in compliance with the License.
588   You may obtain a copy of the License at
589 
590     http://www.apache.org/licenses/LICENSE-2.0
591 
592   Unless required by applicable law or agreed to in writing, software
593   distributed under the License is distributed on an "AS IS" BASIS,
594   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
595   See the License for the specific language governing permissions and
596   limitations under the License.
597 
598 */
599 
600 
601 
602 contract IAssetProxyDispatcher {
603 
604     /// @dev Registers an asset proxy to its asset proxy id.
605     ///      Once an asset proxy is registered, it cannot be unregistered.
606     /// @param assetProxy Address of new asset proxy to register.
607     function registerAssetProxy(address assetProxy)
608         external;
609 
610     /// @dev Gets an asset proxy.
611     /// @param assetProxyId Id of the asset proxy.
612     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
613     function getAssetProxy(bytes4 assetProxyId)
614         external
615         view
616         returns (address);
617 }
618 
619 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IWrapperFunctions.sol
620 
621 /*
622 
623   Copyright 2018 ZeroEx Intl.
624 
625   Licensed under the Apache License, Version 2.0 (the "License");
626   you may not use this file except in compliance with the License.
627   You may obtain a copy of the License at
628 
629     http://www.apache.org/licenses/LICENSE-2.0
630 
631   Unless required by applicable law or agreed to in writing, software
632   distributed under the License is distributed on an "AS IS" BASIS,
633   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
634   See the License for the specific language governing permissions and
635   limitations under the License.
636 
637 */
638 
639 
640 
641 
642 
643 contract IWrapperFunctions {
644 
645     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
646     /// @param order LibOrder.Order struct containing order specifications.
647     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
648     /// @param signature Proof that order has been created by maker.
649     function fillOrKillOrder(
650         LibOrder.Order memory order,
651         uint256 takerAssetFillAmount,
652         bytes memory signature
653     )
654         public
655         returns (LibFillResults.FillResults memory fillResults);
656 
657     /// @dev Fills an order with specified parameters and ECDSA signature.
658     ///      Returns false if the transaction would otherwise revert.
659     /// @param order LibOrder.Order struct containing order specifications.
660     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
661     /// @param signature Proof that order has been created by maker.
662     /// @return Amounts filled and fees paid by maker and taker.
663     function fillOrderNoThrow(
664         LibOrder.Order memory order,
665         uint256 takerAssetFillAmount,
666         bytes memory signature
667     )
668         public
669         returns (LibFillResults.FillResults memory fillResults);
670 
671     /// @dev Synchronously executes multiple calls of fillOrder.
672     /// @param orders Array of order specifications.
673     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
674     /// @param signatures Proofs that orders have been created by makers.
675     /// @return Amounts filled and fees paid by makers and taker.
676     function batchFillOrders(
677         LibOrder.Order[] memory orders,
678         uint256[] memory takerAssetFillAmounts,
679         bytes[] memory signatures
680     )
681         public
682         returns (LibFillResults.FillResults memory totalFillResults);
683 
684     /// @dev Synchronously executes multiple calls of fillOrKill.
685     /// @param orders Array of order specifications.
686     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
687     /// @param signatures Proofs that orders have been created by makers.
688     /// @return Amounts filled and fees paid by makers and taker.
689     function batchFillOrKillOrders(
690         LibOrder.Order[] memory orders,
691         uint256[] memory takerAssetFillAmounts,
692         bytes[] memory signatures
693     )
694         public
695         returns (LibFillResults.FillResults memory totalFillResults);
696 
697     /// @dev Fills an order with specified parameters and ECDSA signature.
698     ///      Returns false if the transaction would otherwise revert.
699     /// @param orders Array of order specifications.
700     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
701     /// @param signatures Proofs that orders have been created by makers.
702     /// @return Amounts filled and fees paid by makers and taker.
703     function batchFillOrdersNoThrow(
704         LibOrder.Order[] memory orders,
705         uint256[] memory takerAssetFillAmounts,
706         bytes[] memory signatures
707     )
708         public
709         returns (LibFillResults.FillResults memory totalFillResults);
710 
711     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
712     /// @param orders Array of order specifications.
713     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
714     /// @param signatures Proofs that orders have been created by makers.
715     /// @return Amounts filled and fees paid by makers and taker.
716     function marketSellOrders(
717         LibOrder.Order[] memory orders,
718         uint256 takerAssetFillAmount,
719         bytes[] memory signatures
720     )
721         public
722         returns (LibFillResults.FillResults memory totalFillResults);
723 
724     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
725     ///      Returns false if the transaction would otherwise revert.
726     /// @param orders Array of order specifications.
727     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
728     /// @param signatures Proofs that orders have been signed by makers.
729     /// @return Amounts filled and fees paid by makers and taker.
730     function marketSellOrdersNoThrow(
731         LibOrder.Order[] memory orders,
732         uint256 takerAssetFillAmount,
733         bytes[] memory signatures
734     )
735         public
736         returns (LibFillResults.FillResults memory totalFillResults);
737 
738     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
739     /// @param orders Array of order specifications.
740     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
741     /// @param signatures Proofs that orders have been signed by makers.
742     /// @return Amounts filled and fees paid by makers and taker.
743     function marketBuyOrders(
744         LibOrder.Order[] memory orders,
745         uint256 makerAssetFillAmount,
746         bytes[] memory signatures
747     )
748         public
749         returns (LibFillResults.FillResults memory totalFillResults);
750 
751     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
752     ///      Returns false if the transaction would otherwise revert.
753     /// @param orders Array of order specifications.
754     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
755     /// @param signatures Proofs that orders have been signed by makers.
756     /// @return Amounts filled and fees paid by makers and taker.
757     function marketBuyOrdersNoThrow(
758         LibOrder.Order[] memory orders,
759         uint256 makerAssetFillAmount,
760         bytes[] memory signatures
761     )
762         public
763         returns (LibFillResults.FillResults memory totalFillResults);
764 
765     /// @dev Synchronously cancels multiple orders in a single transaction.
766     /// @param orders Array of order specifications.
767     function batchCancelOrders(LibOrder.Order[] memory orders)
768         public;
769 
770     /// @dev Fetches information for all passed in orders
771     /// @param orders Array of order specifications.
772     /// @return Array of OrderInfo instances that correspond to each order.
773     function getOrdersInfo(LibOrder.Order[] memory orders)
774         public
775         view
776         returns (LibOrder.OrderInfo[] memory);
777 }
778 
779 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IExchange.sol
780 
781 /*
782 
783   Copyright 2018 ZeroEx Intl.
784 
785   Licensed under the Apache License, Version 2.0 (the "License");
786   you may not use this file except in compliance with the License.
787   You may obtain a copy of the License at
788 
789     http://www.apache.org/licenses/LICENSE-2.0
790 
791   Unless required by applicable law or agreed to in writing, software
792   distributed under the License is distributed on an "AS IS" BASIS,
793   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
794   See the License for the specific language governing permissions and
795   limitations under the License.
796 
797 */
798 
799 
800 
801 
802 
803 
804 
805 
806 
807 // solhint-disable no-empty-blocks
808 contract IExchange is
809     IExchangeCore,
810     IMatchOrders,
811     ISignatureValidator,
812     ITransactions,
813     IAssetProxyDispatcher,
814     IWrapperFunctions
815 {}
816 
817 // File: contracts/RequirementFilter/libs/LibConstants.sol
818 
819 /*
820 
821   Copyright 2018 ZeroEx Intl.
822 
823   Licensed under the Apache License, Version 2.0 (the "License");
824   you may not use this file except in compliance with the License.
825   You may obtain a copy of the License at
826 
827     http://www.apache.org/licenses/LICENSE-2.0
828 
829   Unless required by applicable law or agreed to in writing, software
830   distributed under the License is distributed on an "AS IS" BASIS,
831   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
832   See the License for the specific language governing permissions and
833   limitations under the License.
834 
835 */
836 
837 
838 
839 
840 contract LibConstants {
841 
842     bytes4 constant internal ERC20_DATA_ID = bytes4(keccak256("ERC20Token(address)"));
843     bytes4 constant internal ERC721_DATA_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
844     bytes4 constant internal BALANCE_THRESHOLD_DATA_ID = bytes4(keccak256("BalanceThreshold(address,uint256)"));
845     bytes4 constant internal OWNERSHIP_DATA_ID = bytes4(keccak256("Ownership(address,uint256)"));
846     bytes4 constant internal FILLED_TIMES_DATA_ID = bytes4(keccak256("FilledTimes(uint256)"));
847     uint256 constant internal MAX_UINT = 2**256 - 1;
848  
849     // solhint-disable var-name-mixedcase
850     IExchange internal EXCHANGE;
851     // solhint-enable var-name-mixedcase
852 
853     constructor (address exchange)
854         public
855     {
856         EXCHANGE = IExchange(exchange);
857     }
858 }
859 
860 // File: contracts/RequirementFilter/mixins/MExchangeCalldata.sol
861 
862 /*
863 
864   Copyright 2018 ZeroEx Intl.
865 
866   Licensed under the Apache License, Version 2.0 (the "License");
867   you may not use this file except in compliance with the License.
868   You may obtain a copy of the License at
869 
870     http://www.apache.org/licenses/LICENSE2.0
871 
872   Unless required by applicable law or agreed to in writing, software
873   distributed under the License is distributed on an "AS IS" BASIS,
874   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
875   See the License for the specific language governing permissions and
876   limitations under the License.
877 
878 */
879 
880 
881 
882 
883 contract MExchangeCalldata {
884 
885     /// @dev Emulates the `calldataload` opcode on the embedded Exchange calldata,
886     ///      which is accessed through `signedExchangeTransaction`.
887     /// @param offset  Offset into the Exchange calldata.
888     /// @return value  Corresponding 32 byte value stored at `offset`.
889     function exchangeCalldataload(uint256 offset)
890         internal pure
891         returns (bytes32 value);
892 
893     /// @dev Extracts the takerAssetData from an order stored in the Exchange calldata
894     ///      (which is embedded in `signedExchangeTransaction`).
895     /// @return takerAssetData The extracted takerAssetData.
896     function loadTakerAssetDataFromOrder()
897         internal pure
898         returns (uint256 takerAssetAmount, bytes memory takerAssetData);
899 
900     /// @dev Extracts the signature from an order stored in the Exchange calldata
901     ///      (which is embedded in `signedExchangeTransaction`).
902     /// @return signature The extracted signature.
903     function loadSignatureFromExchangeCalldata()
904         internal pure
905         returns (bytes memory signature);
906 }
907 
908 // File: contracts/RequirementFilter/MixinExchangeCalldata.sol
909 
910 /*
911 
912   Copyright 2018 ZeroEx Intl.
913 
914   Licensed under the Apache License, Version 2.0 (the "License");
915   you may not use this file except in compliance with the License.
916   You may obtain a copy of the License at
917 
918     http://www.apache.org/licenses/LICENSE2.0
919 
920   Unless required by applicable law or agreed to in writing, software
921   distributed under the License is distributed on an "AS IS" BASIS,
922   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
923   See the License for the specific language governing permissions and
924   limitations under the License.
925 
926 */
927 
928 
929 
930 
931 
932 contract MixinExchangeCalldata
933     is MExchangeCalldata
934 {
935 
936     /// @dev Emulates the `calldataload` opcode on the embedded Exchange calldata,
937     ///      which is accessed through `signedExchangeTransaction`.
938     /// @param offset  Offset into the Exchange calldata.
939     /// @return value  Corresponding 32 byte value stored at `offset`.
940     function exchangeCalldataload(uint256 offset)
941         internal pure
942         returns (bytes32 value)
943     {
944         assembly {
945             // Pointer to exchange transaction
946             // 0x04 for calldata selector
947             // 0x40 to access `signedExchangeTransaction`, which is the third parameter
948             let exchangeTxPtr := calldataload(0x44)
949 
950             // Offset into Exchange calldata
951             // We compute this by adding 0x24 to the `exchangeTxPtr` computed above.
952             // 0x04 for calldata selector
953             // 0x20 for length field of `signedExchangeTransaction`
954             let exchangeCalldataOffset := add(exchangeTxPtr, add(0x24, offset))
955             value := calldataload(exchangeCalldataOffset)
956         }
957         return value;
958     }
959 
960     /// @dev Extracts the takerAssetData from an order stored in the Exchange calldata
961     ///      (which is embedded in `signedExchangeTransaction`).
962     /// @return takerAssetData The extracted takerAssetData.
963     function loadTakerAssetDataFromOrder()
964         internal pure
965         returns (uint256 takerAssetAmount, bytes memory takerAssetData)
966     {
967         assembly {
968             takerAssetData := mload(0x40)
969             // Offset to exchange calldata
970             // 0x04 for calldata selector
971             // 0x40 to access `signedExchangeTransaction`, which is the third parameter
972             let exchangeCalldataOffset := add(0x28, calldataload(0x44))
973             // Offset to order
974             let orderOffset := add(exchangeCalldataOffset, calldataload(exchangeCalldataOffset))
975             // Offset to takerAssetData
976             takerAssetAmount := calldataload(add(orderOffset, 160))
977             let takerAssetDataOffset := add(orderOffset, calldataload(add(orderOffset, 352)))
978             let takerAssetDataLength := calldataload(takerAssetDataOffset)
979             // Locate new memory including padding
980             mstore(0x40, add(takerAssetData, and(add(add(takerAssetDataLength, 0x20), 0x1f), not(0x1f))))
981             mstore(takerAssetData, takerAssetDataLength)
982             // Copy takerAssetData
983             calldatacopy(add(takerAssetData, 32), add(takerAssetDataOffset, 32), takerAssetDataLength)
984         }
985 
986         return (takerAssetAmount, takerAssetData);
987     }
988 
989     /// @dev Extracts the signature from an order stored in the Exchange calldata
990     ///      (which is embedded in `signedExchangeTransaction`).
991     /// @return signature The extracted signature.
992     function loadSignatureFromExchangeCalldata()
993         internal pure
994         returns (bytes memory signature)
995     {
996         assembly {
997             signature := mload(0x40)
998             // Offset to exchange calldata
999             // 0x04 for calldata selector
1000             // 0x40 to access `signedExchangeTransaction`, which is the third parameter
1001             let exchangeCalldataOffset := add(0x28, calldataload(0x44))
1002             // Offset to signature
1003             // 0x40 to access `signature`, which is the third parameter of `fillOrder`
1004             let signatureOffset := add(exchangeCalldataOffset, calldataload(add(exchangeCalldataOffset, 0x40)))
1005             let signatureLength := calldataload(signatureOffset)
1006             // Locate new memory including padding
1007             mstore(0x40, add(signature, and(add(add(signatureLength, 0x20), 0x1f), not(0x1f))))
1008             mstore(signature, signatureLength)
1009             // Copy takerAssetData
1010             calldatacopy(add(signature, 32), add(signatureOffset, 32), signatureLength)
1011         }
1012 
1013         return signature;
1014     }
1015 }
1016 
1017 // File: contracts/RequirementFilter/MixinFakeERC20Token.sol
1018 
1019 contract MixinFakeERC20Token is
1020     LibConstants
1021 {
1022     /// @dev Fake `transferFrom` for scenorios like puzzle huting, airdrop, etc...
1023     /// @param from The address of the sender
1024     /// @param to The address of the recipient
1025     /// @param amount The amount of token to be transferred
1026     /// @return True if transfer was successful
1027     function transferFrom(address from, address to, uint256 amount)
1028         external returns (bool)
1029     {
1030         require(
1031             amount == 1,
1032             "INVALID_TAKER_ASSET_FILL_AMOUNT"
1033         );
1034         return true;
1035     }
1036 
1037     /// @dev Fake `allowance` for scenorios like puzzle huting, airdrop, etc...
1038     /// @param owner The address of the account owning tokens
1039     /// @param spender The address of the account able to transfer the tokens
1040     /// @return Amount of remaining tokens allowed to spent
1041     function allowance(address owner, address spender)
1042         external pure returns (uint256)
1043     {
1044         return MAX_UINT;
1045     }
1046 }
1047 
1048 // File: contracts/RequirementFilter/interfaces/IRequiredAsset.sol
1049 
1050 /*
1051 
1052   Copyright 2018 ZeroEx Intl.
1053 
1054   Licensed under the Apache License, Version 2.0 (the "License");
1055   you may not use this file except in compliance with the License.
1056   You may obtain a copy of the License at
1057 
1058     http://www.apache.org/licenses/LICENSE-2.0
1059 
1060   Unless required by applicable law or agreed to in writing, software
1061   distributed under the License is distributed on an "AS IS" BASIS,
1062   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1063   See the License for the specific language governing permissions and
1064   limitations under the License.
1065 
1066 */
1067 
1068 
1069 
1070 contract IRequiredAsset {
1071 
1072     /// @dev Check balanceOf owner
1073     /// @param owner The address from which the balance will be retrieved
1074     /// @return Balance of owner
1075     function balanceOf(address owner)
1076         external
1077         view
1078         returns (uint256);
1079 
1080     /// @dev Check ownerOf tokenId
1081     /// @param tokenId The token id from which the ownership will be checked
1082     /// @return Owner address of tokenId
1083     function ownerOf(uint256 tokenId)
1084         external
1085         view
1086         returns (address);
1087 }
1088 
1089 // File: contracts/RequirementFilter/interfaces/IRequirementFilterCore.sol
1090 
1091 contract IRequirementFilterCore {
1092 
1093     /// @dev Executes an Exchange transaction iff the maker and taker meet 
1094     ///      all requirements specified in `takerAssetData`
1095     ///      Supported Exchange functions:
1096     ///         - fillOrder
1097     ///      Trying to call any other exchange function will throw.
1098     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1099     /// @param signerAddress Address of transaction signer.
1100     /// @param signedExchangeTransaction AbiV2 encoded calldata.
1101     /// @param signature Proof of signer transaction by signer.
1102     function executeTransaction(
1103         uint256 salt,
1104         address signerAddress,
1105         bytes signedExchangeTransaction,
1106         bytes signature
1107     ) 
1108         external
1109         returns (bool success);
1110 
1111     /// @dev Chech whether input signerAddress has achieved all
1112     ///      requirements specified in `takerAssetData`. Return
1113     ///      array of boolean of requirements' achievement.
1114     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
1115     /// @param signerAddress Address of transaction signer.
1116     function getRequirementsAchieved(
1117         bytes memory takerAssetData,
1118         address signerAddress
1119     )
1120         public view
1121         returns (bool[] memory requirementsAchieved);
1122 }
1123 
1124 // File: contracts/RequirementFilter/mixins/MRequirementFilterCore.sol
1125 
1126 contract MRequirementFilterCore is
1127     IRequirementFilterCore
1128 {
1129     mapping(bytes32 => mapping(address => uint256)) internal filledTimes;
1130 
1131     /// @dev Validates signerAddress's filling times is in limitation. Succeeds or throws.
1132     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
1133     /// @param embeddedSignature Signature extracted from signedExchangeTransaction.
1134     /// @param signerAddress Signer of signedExchangeTransaction.
1135     function assertValidFilledTimes(bytes memory takerAssetData, bytes memory embeddedSignature, address signerAddress)
1136         internal
1137         returns (bool);
1138 
1139     /// @dev Validates all requirements' achievement. Succeeds or throws.
1140     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
1141     /// @param signerAddress Signer of signedExchangeTransaction.
1142     function assertRequirementsAchieved(bytes memory takerAssetData, address signerAddress)
1143         internal view
1144         returns (bool);
1145 }
1146 
1147 // File: @0x/contracts-libs/contracts/libs/LibExchangeSelectors.sol
1148 
1149 /*
1150 
1151   Copyright 2018 ZeroEx Intl.
1152 
1153   Licensed under the Apache License, Version 2.0 (the "License");
1154   you may not use this file except in compliance with the License.
1155   You may obtain a copy of the License at
1156 
1157     http://www.apache.org/licenses/LICENSE-2.0
1158 
1159   Unless required by applicable law or agreed to in writing, software
1160   distributed under the License is distributed on an "AS IS" BASIS,
1161   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1162   See the License for the specific language governing permissions and
1163   limitations under the License.
1164 
1165 */
1166 
1167 
1168 
1169 contract LibExchangeSelectors {
1170 
1171     // solhint-disable max-line-length
1172     // allowedValidators
1173     bytes4 constant public ALLOWED_VALIDATORS_SELECTOR = 0x7b8e3514;
1174     bytes4 constant public ALLOWED_VALIDATORS_SELECTOR_GENERATOR = bytes4(keccak256("allowedValidators(address,address)"));
1175 
1176     // assetProxies
1177     bytes4 constant public ASSET_PROXIES_SELECTOR = 0x3fd3c997;
1178     bytes4 constant public ASSET_PROXIES_SELECTOR_GENERATOR = bytes4(keccak256("assetProxies(bytes4)"));
1179 
1180     // batchCancelOrders
1181     bytes4 constant public BATCH_CANCEL_ORDERS_SELECTOR = 0x4ac14782;
1182     bytes4 constant public BATCH_CANCEL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchCancelOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[])"));
1183 
1184     // batchFillOrKillOrders
1185     bytes4 constant public BATCH_FILL_OR_KILL_ORDERS_SELECTOR = 0x4d0ae546;
1186     bytes4 constant public BATCH_FILL_OR_KILL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrKillOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));
1187 
1188     // batchFillOrders
1189     bytes4 constant public BATCH_FILL_ORDERS_SELECTOR = 0x297bb70b;
1190     bytes4 constant public BATCH_FILL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));
1191 
1192     // batchFillOrdersNoThrow
1193     bytes4 constant public BATCH_FILL_ORDERS_NO_THROW_SELECTOR = 0x50dde190;
1194     bytes4 constant public BATCH_FILL_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("batchFillOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256[],bytes[])"));
1195 
1196     // cancelOrder
1197     bytes4 constant public CANCEL_ORDER_SELECTOR = 0xd46b02c3;
1198     bytes4 constant public CANCEL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("cancelOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes))"));
1199 
1200     // cancelOrdersUpTo
1201     bytes4 constant public CANCEL_ORDERS_UP_TO_SELECTOR = 0x4f9559b1;
1202     bytes4 constant public CANCEL_ORDERS_UP_TO_SELECTOR_GENERATOR = bytes4(keccak256("cancelOrdersUpTo(uint256)"));
1203 
1204     // cancelled
1205     bytes4 constant public CANCELLED_SELECTOR = 0x2ac12622;
1206     bytes4 constant public CANCELLED_SELECTOR_GENERATOR = bytes4(keccak256("cancelled(bytes32)"));
1207 
1208     // currentContextAddress
1209     bytes4 constant public CURRENT_CONTEXT_ADDRESS_SELECTOR = 0xeea086ba;
1210     bytes4 constant public CURRENT_CONTEXT_ADDRESS_SELECTOR_GENERATOR = bytes4(keccak256("currentContextAddress()"));
1211 
1212     // executeTransaction
1213     bytes4 constant public EXECUTE_TRANSACTION_SELECTOR = 0xbfc8bfce;
1214     bytes4 constant public EXECUTE_TRANSACTION_SELECTOR_GENERATOR = bytes4(keccak256("executeTransaction(uint256,address,bytes,bytes)"));
1215 
1216     // fillOrKillOrder
1217     bytes4 constant public FILL_OR_KILL_ORDER_SELECTOR = 0x64a3bc15;
1218     bytes4 constant public FILL_OR_KILL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("fillOrKillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));
1219 
1220     // fillOrder
1221     bytes4 constant public FILL_ORDER_SELECTOR = 0xb4be83d5;
1222     bytes4 constant public FILL_ORDER_SELECTOR_GENERATOR = bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));
1223 
1224     // fillOrderNoThrow
1225     bytes4 constant public FILL_ORDER_NO_THROW_SELECTOR = 0x3e228bae;
1226     bytes4 constant public FILL_ORDER_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("fillOrderNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"));
1227 
1228     // filled
1229     bytes4 constant public FILLED_SELECTOR = 0x288cdc91;
1230     bytes4 constant public FILLED_SELECTOR_GENERATOR = bytes4(keccak256("filled(bytes32)"));
1231 
1232     // getAssetProxy
1233     bytes4 constant public GET_ASSET_PROXY_SELECTOR = 0x60704108;
1234     bytes4 constant public GET_ASSET_PROXY_SELECTOR_GENERATOR = bytes4(keccak256("getAssetProxy(bytes4)"));
1235 
1236     // getOrderInfo
1237     bytes4 constant public GET_ORDER_INFO_SELECTOR = 0xc75e0a81;
1238     bytes4 constant public GET_ORDER_INFO_SELECTOR_GENERATOR = bytes4(keccak256("getOrderInfo((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes))"));
1239 
1240     // getOrdersInfo
1241     bytes4 constant public GET_ORDERS_INFO_SELECTOR = 0x7e9d74dc;
1242     bytes4 constant public GET_ORDERS_INFO_SELECTOR_GENERATOR = bytes4(keccak256("getOrdersInfo((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[])"));
1243 
1244     // isValidSignature
1245     bytes4 constant public IS_VALID_SIGNATURE_SELECTOR = 0x93634702;
1246     bytes4 constant public IS_VALID_SIGNATURE_SELECTOR_GENERATOR = bytes4(keccak256("isValidSignature(bytes32,address,bytes)"));
1247 
1248     // marketBuyOrders
1249     bytes4 constant public MARKET_BUY_ORDERS_SELECTOR = 0xe5fa431b;
1250     bytes4 constant public MARKET_BUY_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("marketBuyOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));
1251 
1252     // marketBuyOrdersNoThrow
1253     bytes4 constant public MARKET_BUY_ORDERS_NO_THROW_SELECTOR = 0xa3e20380;
1254     bytes4 constant public MARKET_BUY_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("marketBuyOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));
1255 
1256     // marketSellOrders
1257     bytes4 constant public MARKET_SELL_ORDERS_SELECTOR = 0x7e1d9808;
1258     bytes4 constant public MARKET_SELL_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("marketSellOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));
1259 
1260     // marketSellOrdersNoThrow
1261     bytes4 constant public MARKET_SELL_ORDERS_NO_THROW_SELECTOR = 0xdd1c7d18;
1262     bytes4 constant public MARKET_SELL_ORDERS_NO_THROW_SELECTOR_GENERATOR = bytes4(keccak256("marketSellOrdersNoThrow((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes)[],uint256,bytes[])"));
1263 
1264     // matchOrders
1265     bytes4 constant public MATCH_ORDERS_SELECTOR = 0x3c28d861;
1266     bytes4 constant public MATCH_ORDERS_SELECTOR_GENERATOR = bytes4(keccak256("matchOrders((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),(address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes,bytes)"));
1267 
1268     // orderEpoch
1269     bytes4 constant public ORDER_EPOCH_SELECTOR = 0xd9bfa73e;
1270     bytes4 constant public ORDER_EPOCH_SELECTOR_GENERATOR = bytes4(keccak256("orderEpoch(address,address)"));
1271 
1272     // owner
1273     bytes4 constant public OWNER_SELECTOR = 0x8da5cb5b;
1274     bytes4 constant public OWNER_SELECTOR_GENERATOR = bytes4(keccak256("owner()"));
1275 
1276     // preSign
1277     bytes4 constant public PRE_SIGN_SELECTOR = 0x3683ef8e;
1278     bytes4 constant public PRE_SIGN_SELECTOR_GENERATOR = bytes4(keccak256("preSign(bytes32,address,bytes)"));
1279 
1280     // preSigned
1281     bytes4 constant public PRE_SIGNED_SELECTOR = 0x82c174d0;
1282     bytes4 constant public PRE_SIGNED_SELECTOR_GENERATOR = bytes4(keccak256("preSigned(bytes32,address)"));
1283 
1284     // registerAssetProxy
1285     bytes4 constant public REGISTER_ASSET_PROXY_SELECTOR = 0xc585bb93;
1286     bytes4 constant public REGISTER_ASSET_PROXY_SELECTOR_GENERATOR = bytes4(keccak256("registerAssetProxy(address)"));
1287 
1288     // setSignatureValidatorApproval
1289     bytes4 constant public SET_SIGNATURE_VALIDATOR_APPROVAL_SELECTOR = 0x77fcce68;
1290     bytes4 constant public SET_SIGNATURE_VALIDATOR_APPROVAL_SELECTOR_GENERATOR = bytes4(keccak256("setSignatureValidatorApproval(address,bool)"));
1291 
1292     // transactions
1293     bytes4 constant public TRANSACTIONS_SELECTOR = 0x642f2eaf;
1294     bytes4 constant public TRANSACTIONS_SELECTOR_GENERATOR = bytes4(keccak256("transactions(bytes32)"));
1295 
1296     // transferOwnership
1297     bytes4 constant public TRANSFER_OWNERSHIP_SELECTOR = 0xf2fde38b;
1298     bytes4 constant public TRANSFER_OWNERSHIP_SELECTOR_GENERATOR = bytes4(keccak256("transferOwnership(address)"));
1299 }
1300 
1301 // File: @0x/contracts-utils/contracts/utils/LibBytes/LibBytes.sol
1302 
1303 /*
1304 
1305   Copyright 2018 ZeroEx Intl.
1306 
1307   Licensed under the Apache License, Version 2.0 (the "License");
1308   you may not use this file except in compliance with the License.
1309   You may obtain a copy of the License at
1310 
1311     http://www.apache.org/licenses/LICENSE-2.0
1312 
1313   Unless required by applicable law or agreed to in writing, software
1314   distributed under the License is distributed on an "AS IS" BASIS,
1315   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1316   See the License for the specific language governing permissions and
1317   limitations under the License.
1318 
1319 */
1320 
1321 
1322 
1323 library LibBytes {
1324 
1325     using LibBytes for bytes;
1326 
1327     /// @dev Gets the memory address for a byte array.
1328     /// @param input Byte array to lookup.
1329     /// @return memoryAddress Memory address of byte array. This
1330     ///         points to the header of the byte array which contains
1331     ///         the length.
1332     function rawAddress(bytes memory input)
1333         internal
1334         pure
1335         returns (uint256 memoryAddress)
1336     {
1337         assembly {
1338             memoryAddress := input
1339         }
1340         return memoryAddress;
1341     }
1342     
1343     /// @dev Gets the memory address for the contents of a byte array.
1344     /// @param input Byte array to lookup.
1345     /// @return memoryAddress Memory address of the contents of the byte array.
1346     function contentAddress(bytes memory input)
1347         internal
1348         pure
1349         returns (uint256 memoryAddress)
1350     {
1351         assembly {
1352             memoryAddress := add(input, 32)
1353         }
1354         return memoryAddress;
1355     }
1356 
1357     /// @dev Copies `length` bytes from memory location `source` to `dest`.
1358     /// @param dest memory address to copy bytes to.
1359     /// @param source memory address to copy bytes from.
1360     /// @param length number of bytes to copy.
1361     function memCopy(
1362         uint256 dest,
1363         uint256 source,
1364         uint256 length
1365     )
1366         internal
1367         pure
1368     {
1369         if (length < 32) {
1370             // Handle a partial word by reading destination and masking
1371             // off the bits we are interested in.
1372             // This correctly handles overlap, zero lengths and source == dest
1373             assembly {
1374                 let mask := sub(exp(256, sub(32, length)), 1)
1375                 let s := and(mload(source), not(mask))
1376                 let d := and(mload(dest), mask)
1377                 mstore(dest, or(s, d))
1378             }
1379         } else {
1380             // Skip the O(length) loop when source == dest.
1381             if (source == dest) {
1382                 return;
1383             }
1384 
1385             // For large copies we copy whole words at a time. The final
1386             // word is aligned to the end of the range (instead of after the
1387             // previous) to handle partial words. So a copy will look like this:
1388             //
1389             //  ####
1390             //      ####
1391             //          ####
1392             //            ####
1393             //
1394             // We handle overlap in the source and destination range by
1395             // changing the copying direction. This prevents us from
1396             // overwriting parts of source that we still need to copy.
1397             //
1398             // This correctly handles source == dest
1399             //
1400             if (source > dest) {
1401                 assembly {
1402                     // We subtract 32 from `sEnd` and `dEnd` because it
1403                     // is easier to compare with in the loop, and these
1404                     // are also the addresses we need for copying the
1405                     // last bytes.
1406                     length := sub(length, 32)
1407                     let sEnd := add(source, length)
1408                     let dEnd := add(dest, length)
1409 
1410                     // Remember the last 32 bytes of source
1411                     // This needs to be done here and not after the loop
1412                     // because we may have overwritten the last bytes in
1413                     // source already due to overlap.
1414                     let last := mload(sEnd)
1415 
1416                     // Copy whole words front to back
1417                     // Note: the first check is always true,
1418                     // this could have been a do-while loop.
1419                     // solhint-disable-next-line no-empty-blocks
1420                     for {} lt(source, sEnd) {} {
1421                         mstore(dest, mload(source))
1422                         source := add(source, 32)
1423                         dest := add(dest, 32)
1424                     }
1425                     
1426                     // Write the last 32 bytes
1427                     mstore(dEnd, last)
1428                 }
1429             } else {
1430                 assembly {
1431                     // We subtract 32 from `sEnd` and `dEnd` because those
1432                     // are the starting points when copying a word at the end.
1433                     length := sub(length, 32)
1434                     let sEnd := add(source, length)
1435                     let dEnd := add(dest, length)
1436 
1437                     // Remember the first 32 bytes of source
1438                     // This needs to be done here and not after the loop
1439                     // because we may have overwritten the first bytes in
1440                     // source already due to overlap.
1441                     let first := mload(source)
1442 
1443                     // Copy whole words back to front
1444                     // We use a signed comparisson here to allow dEnd to become
1445                     // negative (happens when source and dest < 32). Valid
1446                     // addresses in local memory will never be larger than
1447                     // 2**255, so they can be safely re-interpreted as signed.
1448                     // Note: the first check is always true,
1449                     // this could have been a do-while loop.
1450                     // solhint-disable-next-line no-empty-blocks
1451                     for {} slt(dest, dEnd) {} {
1452                         mstore(dEnd, mload(sEnd))
1453                         sEnd := sub(sEnd, 32)
1454                         dEnd := sub(dEnd, 32)
1455                     }
1456                     
1457                     // Write the first 32 bytes
1458                     mstore(dest, first)
1459                 }
1460             }
1461         }
1462     }
1463 
1464     /// @dev Returns a slices from a byte array.
1465     /// @param b The byte array to take a slice from.
1466     /// @param from The starting index for the slice (inclusive).
1467     /// @param to The final index for the slice (exclusive).
1468     /// @return result The slice containing bytes at indices [from, to)
1469     function slice(
1470         bytes memory b,
1471         uint256 from,
1472         uint256 to
1473     )
1474         internal
1475         pure
1476         returns (bytes memory result)
1477     {
1478         require(
1479             from <= to,
1480             "FROM_LESS_THAN_TO_REQUIRED"
1481         );
1482         require(
1483             to < b.length,
1484             "TO_LESS_THAN_LENGTH_REQUIRED"
1485         );
1486         
1487         // Create a new bytes structure and copy contents
1488         result = new bytes(to - from);
1489         memCopy(
1490             result.contentAddress(),
1491             b.contentAddress() + from,
1492             result.length
1493         );
1494         return result;
1495     }
1496     
1497     /// @dev Returns a slice from a byte array without preserving the input.
1498     /// @param b The byte array to take a slice from. Will be destroyed in the process.
1499     /// @param from The starting index for the slice (inclusive).
1500     /// @param to The final index for the slice (exclusive).
1501     /// @return result The slice containing bytes at indices [from, to)
1502     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
1503     function sliceDestructive(
1504         bytes memory b,
1505         uint256 from,
1506         uint256 to
1507     )
1508         internal
1509         pure
1510         returns (bytes memory result)
1511     {
1512         require(
1513             from <= to,
1514             "FROM_LESS_THAN_TO_REQUIRED"
1515         );
1516         require(
1517             to < b.length,
1518             "TO_LESS_THAN_LENGTH_REQUIRED"
1519         );
1520         
1521         // Create a new bytes structure around [from, to) in-place.
1522         assembly {
1523             result := add(b, from)
1524             mstore(result, sub(to, from))
1525         }
1526         return result;
1527     }
1528 
1529     /// @dev Pops the last byte off of a byte array by modifying its length.
1530     /// @param b Byte array that will be modified.
1531     /// @return The byte that was popped off.
1532     function popLastByte(bytes memory b)
1533         internal
1534         pure
1535         returns (bytes1 result)
1536     {
1537         require(
1538             b.length > 0,
1539             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
1540         );
1541 
1542         // Store last byte.
1543         result = b[b.length - 1];
1544 
1545         assembly {
1546             // Decrement length of byte array.
1547             let newLen := sub(mload(b), 1)
1548             mstore(b, newLen)
1549         }
1550         return result;
1551     }
1552 
1553     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
1554     /// @param b Byte array that will be modified.
1555     /// @return The 20 byte address that was popped off.
1556     function popLast20Bytes(bytes memory b)
1557         internal
1558         pure
1559         returns (address result)
1560     {
1561         require(
1562             b.length >= 20,
1563             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
1564         );
1565 
1566         // Store last 20 bytes.
1567         result = readAddress(b, b.length - 20);
1568 
1569         assembly {
1570             // Subtract 20 from byte array length.
1571             let newLen := sub(mload(b), 20)
1572             mstore(b, newLen)
1573         }
1574         return result;
1575     }
1576 
1577     /// @dev Tests equality of two byte arrays.
1578     /// @param lhs First byte array to compare.
1579     /// @param rhs Second byte array to compare.
1580     /// @return True if arrays are the same. False otherwise.
1581     function equals(
1582         bytes memory lhs,
1583         bytes memory rhs
1584     )
1585         internal
1586         pure
1587         returns (bool equal)
1588     {
1589         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
1590         // We early exit on unequal lengths, but keccak would also correctly
1591         // handle this.
1592         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
1593     }
1594 
1595     /// @dev Reads an address from a position in a byte array.
1596     /// @param b Byte array containing an address.
1597     /// @param index Index in byte array of address.
1598     /// @return address from byte array.
1599     function readAddress(
1600         bytes memory b,
1601         uint256 index
1602     )
1603         internal
1604         pure
1605         returns (address result)
1606     {
1607         require(
1608             b.length >= index + 20,  // 20 is length of address
1609             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
1610         );
1611 
1612         // Add offset to index:
1613         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
1614         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
1615         index += 20;
1616 
1617         // Read address from array memory
1618         assembly {
1619             // 1. Add index to address of bytes array
1620             // 2. Load 32-byte word from memory
1621             // 3. Apply 20-byte mask to obtain address
1622             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
1623         }
1624         return result;
1625     }
1626 
1627     /// @dev Writes an address into a specific position in a byte array.
1628     /// @param b Byte array to insert address into.
1629     /// @param index Index in byte array of address.
1630     /// @param input Address to put into byte array.
1631     function writeAddress(
1632         bytes memory b,
1633         uint256 index,
1634         address input
1635     )
1636         internal
1637         pure
1638     {
1639         require(
1640             b.length >= index + 20,  // 20 is length of address
1641             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
1642         );
1643 
1644         // Add offset to index:
1645         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
1646         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
1647         index += 20;
1648 
1649         // Store address into array memory
1650         assembly {
1651             // The address occupies 20 bytes and mstore stores 32 bytes.
1652             // First fetch the 32-byte word where we'll be storing the address, then
1653             // apply a mask so we have only the bytes in the word that the address will not occupy.
1654             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
1655 
1656             // 1. Add index to address of bytes array
1657             // 2. Load 32-byte word from memory
1658             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
1659             let neighbors := and(
1660                 mload(add(b, index)),
1661                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
1662             )
1663             
1664             // Make sure input address is clean.
1665             // (Solidity does not guarantee this)
1666             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
1667 
1668             // Store the neighbors and address into memory
1669             mstore(add(b, index), xor(input, neighbors))
1670         }
1671     }
1672 
1673     /// @dev Reads a bytes32 value from a position in a byte array.
1674     /// @param b Byte array containing a bytes32 value.
1675     /// @param index Index in byte array of bytes32 value.
1676     /// @return bytes32 value from byte array.
1677     function readBytes32(
1678         bytes memory b,
1679         uint256 index
1680     )
1681         internal
1682         pure
1683         returns (bytes32 result)
1684     {
1685         require(
1686             b.length >= index + 32,
1687             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
1688         );
1689 
1690         // Arrays are prefixed by a 256 bit length parameter
1691         index += 32;
1692 
1693         // Read the bytes32 from array memory
1694         assembly {
1695             result := mload(add(b, index))
1696         }
1697         return result;
1698     }
1699 
1700     /// @dev Writes a bytes32 into a specific position in a byte array.
1701     /// @param b Byte array to insert <input> into.
1702     /// @param index Index in byte array of <input>.
1703     /// @param input bytes32 to put into byte array.
1704     function writeBytes32(
1705         bytes memory b,
1706         uint256 index,
1707         bytes32 input
1708     )
1709         internal
1710         pure
1711     {
1712         require(
1713             b.length >= index + 32,
1714             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
1715         );
1716 
1717         // Arrays are prefixed by a 256 bit length parameter
1718         index += 32;
1719 
1720         // Read the bytes32 from array memory
1721         assembly {
1722             mstore(add(b, index), input)
1723         }
1724     }
1725 
1726     /// @dev Reads a uint256 value from a position in a byte array.
1727     /// @param b Byte array containing a uint256 value.
1728     /// @param index Index in byte array of uint256 value.
1729     /// @return uint256 value from byte array.
1730     function readUint256(
1731         bytes memory b,
1732         uint256 index
1733     )
1734         internal
1735         pure
1736         returns (uint256 result)
1737     {
1738         result = uint256(readBytes32(b, index));
1739         return result;
1740     }
1741 
1742     /// @dev Writes a uint256 into a specific position in a byte array.
1743     /// @param b Byte array to insert <input> into.
1744     /// @param index Index in byte array of <input>.
1745     /// @param input uint256 to put into byte array.
1746     function writeUint256(
1747         bytes memory b,
1748         uint256 index,
1749         uint256 input
1750     )
1751         internal
1752         pure
1753     {
1754         writeBytes32(b, index, bytes32(input));
1755     }
1756 
1757     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
1758     /// @param b Byte array containing a bytes4 value.
1759     /// @param index Index in byte array of bytes4 value.
1760     /// @return bytes4 value from byte array.
1761     function readBytes4(
1762         bytes memory b,
1763         uint256 index
1764     )
1765         internal
1766         pure
1767         returns (bytes4 result)
1768     {
1769         require(
1770             b.length >= index + 4,
1771             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
1772         );
1773 
1774         // Arrays are prefixed by a 32 byte length field
1775         index += 32;
1776 
1777         // Read the bytes4 from array memory
1778         assembly {
1779             result := mload(add(b, index))
1780             // Solidity does not require us to clean the trailing bytes.
1781             // We do it anyway
1782             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
1783         }
1784         return result;
1785     }
1786 
1787     /// @dev Reads nested bytes from a specific position.
1788     /// @dev NOTE: the returned value overlaps with the input value.
1789     ///            Both should be treated as immutable.
1790     /// @param b Byte array containing nested bytes.
1791     /// @param index Index of nested bytes.
1792     /// @return result Nested bytes.
1793     function readBytesWithLength(
1794         bytes memory b,
1795         uint256 index
1796     )
1797         internal
1798         pure
1799         returns (bytes memory result)
1800     {
1801         // Read length of nested bytes
1802         uint256 nestedBytesLength = readUint256(b, index);
1803         index += 32;
1804 
1805         // Assert length of <b> is valid, given
1806         // length of nested bytes
1807         require(
1808             b.length >= index + nestedBytesLength,
1809             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
1810         );
1811         
1812         // Return a pointer to the byte array as it exists inside `b`
1813         assembly {
1814             result := add(b, index)
1815         }
1816         return result;
1817     }
1818 
1819     /// @dev Inserts bytes at a specific position in a byte array.
1820     /// @param b Byte array to insert <input> into.
1821     /// @param index Index in byte array of <input>.
1822     /// @param input bytes to insert.
1823     function writeBytesWithLength(
1824         bytes memory b,
1825         uint256 index,
1826         bytes memory input
1827     )
1828         internal
1829         pure
1830     {
1831         // Assert length of <b> is valid, given
1832         // length of input
1833         require(
1834             b.length >= index + 32 + input.length,  // 32 bytes to store length
1835             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
1836         );
1837 
1838         // Copy <input> into <b>
1839         memCopy(
1840             b.contentAddress() + index,
1841             input.rawAddress(), // includes length of <input>
1842             input.length + 32   // +32 bytes to store <input> length
1843         );
1844     }
1845 
1846     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
1847     /// @param dest Byte array that will be overwritten with source bytes.
1848     /// @param source Byte array to copy onto dest bytes.
1849     function deepCopyBytes(
1850         bytes memory dest,
1851         bytes memory source
1852     )
1853         internal
1854         pure
1855     {
1856         uint256 sourceLen = source.length;
1857         // Dest length must be >= source length, or some bytes would not be copied.
1858         require(
1859             dest.length >= sourceLen,
1860             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
1861         );
1862         memCopy(
1863             dest.contentAddress(),
1864             source.contentAddress(),
1865             sourceLen
1866         );
1867     }
1868 }
1869 
1870 // File: contracts/RequirementFilter/MixinRequirementFilterCore.sol
1871 
1872 contract MixinRequirementFilterCore is
1873     LibConstants,
1874     LibExchangeSelectors,
1875     MExchangeCalldata,
1876     MRequirementFilterCore
1877 {
1878     using LibBytes for bytes;
1879 
1880     /// @dev Executes an Exchange transaction iff the maker and taker meet 
1881     ///      all requirements specified in `takerAssetData`
1882     ///      Supported Exchange functions:
1883     ///         - fillOrder
1884     ///      Trying to call any other exchange function will throw.
1885     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1886     /// @param signerAddress Address of transaction signer.
1887     /// @param signedExchangeTransaction AbiV2 encoded calldata.
1888     /// @param signature Proof of signer transaction by signer.
1889     function executeTransaction(
1890         uint256 salt,
1891         address signerAddress,
1892         bytes signedExchangeTransaction,
1893         bytes signature
1894     ) 
1895         external
1896         returns (bool success)
1897     {
1898         bytes4 exchangeCalldataSelector = bytes4(exchangeCalldataload(0));
1899 
1900         require(
1901             exchangeCalldataSelector == LibExchangeSelectors.FILL_ORDER_SELECTOR,
1902             "INVALID_EXCHANGE_SELECTOR"
1903         );
1904 
1905         (uint256 takerAssetAmount, bytes memory takerAssetData) = loadTakerAssetDataFromOrder();
1906         bytes memory embeddedSignature = loadSignatureFromExchangeCalldata();
1907 
1908         // Assert valid filled times if takerAssetAmoun is larger than 1
1909         if (takerAssetAmount > 1) {
1910             assertValidFilledTimes(takerAssetData, embeddedSignature, signerAddress);
1911         }
1912         // Assert all requirements achieved
1913         assertRequirementsAchieved(takerAssetData, signerAddress);
1914 
1915         // All assertion passed. Execute exchange function.
1916         EXCHANGE.executeTransaction(
1917             salt,
1918             signerAddress,
1919             signedExchangeTransaction,
1920             signature
1921         );
1922 
1923         return true;
1924     }
1925 
1926     /// @dev Chech whether input signerAddress has achieved all
1927     ///      requirements specified in `takerAssetData`. Return
1928     ///      array of boolean of requirements' achievement.
1929     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
1930     /// @param signerAddress Address of transaction signer.
1931     function getRequirementsAchieved(bytes memory takerAssetData, address signerAddress)
1932         public view
1933         returns (bool[] memory requirementsAchieved)
1934     {
1935         uint256 index;
1936         bytes4 proxyId = takerAssetData.readBytes4(0);
1937 
1938         if (proxyId == ERC20_DATA_ID) {
1939             index = 36;
1940         } else if (proxyId == ERC721_DATA_ID) {
1941             index = 68;
1942         } else {
1943             revert("UNSUPPORTED_ASSET_PROXY");
1944         }
1945 
1946         uint256 requirementsNumber = 0;
1947         uint256 takerAssetDataLength = takerAssetData.length;
1948         requirementsAchieved = new bool[]((takerAssetDataLength - index) / 68);
1949 
1950         while (index < takerAssetDataLength) {
1951             bytes4 dataId = takerAssetData.readBytes4(index);
1952             address tokenAddress = takerAssetData.readAddress(index + 16);
1953             IRequiredAsset requiredToken = IRequiredAsset(tokenAddress);
1954 
1955             if (dataId == BALANCE_THRESHOLD_DATA_ID) {
1956                 uint256 balanceThreshold = takerAssetData.readUint256(index + 36);
1957                 requirementsAchieved[requirementsNumber] = requiredToken.balanceOf(signerAddress) >= balanceThreshold;
1958                 requirementsNumber += 1;
1959                 index += 68;
1960             } else if (dataId == OWNERSHIP_DATA_ID) {
1961                 uint256 tokenId = takerAssetData.readUint256(index + 36);
1962                 requirementsAchieved[requirementsNumber] = requiredToken.ownerOf(tokenId) == signerAddress;
1963                 requirementsNumber += 1;
1964                 index += 68;
1965             } else if (dataId == FILLED_TIMES_DATA_ID) {
1966                 index += 36;
1967             } else {
1968                 revert("UNSUPPORTED_METHOD");
1969             }
1970         }
1971 
1972         return requirementsAchieved;
1973     }
1974 
1975     /// @dev Validates signerAddress's filling times is in limitation. Succeeds or throws.
1976     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
1977     /// @param embeddedSignature Signature extracted from signedExchangeTransaction.
1978     /// @param signerAddress Signer of signedExchangeTransaction.
1979     function assertValidFilledTimes(bytes memory takerAssetData, bytes memory embeddedSignature, address signerAddress)
1980         internal
1981         returns (bool)
1982     {
1983         uint256 takerAssetDataLength = takerAssetData.length;
1984         bytes32 signatureHash = keccak256(embeddedSignature);
1985         uint256 filledTimesLimit = 1;
1986 
1987         if (takerAssetData.readBytes4(takerAssetDataLength - 36) == FILLED_TIMES_DATA_ID) {
1988             filledTimesLimit = takerAssetData.readUint256(takerAssetDataLength - 32);
1989         }
1990 
1991         require(
1992             filledTimes[signatureHash][signerAddress] < filledTimesLimit,
1993             "FILLED_TIMES_EXCEEDED"
1994         );
1995 
1996         filledTimes[signatureHash][signerAddress] += 1;
1997 
1998         return true;
1999     }
2000 
2001     /// @dev Validates all requirements' achievement. Succeeds or throws.
2002     /// @param takerAssetData TakerAssetData extracted from signedExchangeTransaction.
2003     /// @param signerAddress Signer of signedExchangeTransaction.
2004     function assertRequirementsAchieved(bytes memory takerAssetData, address signerAddress)
2005         internal view
2006         returns (bool)
2007     {
2008         bool[] memory requirementsAchieved = getRequirementsAchieved(takerAssetData, signerAddress);
2009         uint256 requirementsAchievedLength = requirementsAchieved.length;
2010 
2011         for (uint256 i = 0; i < requirementsAchievedLength; i += 1) {
2012             require(
2013                 requirementsAchieved[i],
2014                 "AT_LEAST_ONE_REQUIREMENT_NOT_ACHIEVED"
2015             );
2016         }
2017 
2018         return true;
2019     }
2020 }
2021 
2022 // File: contracts/RequirementFilter/RequirementFilter.sol
2023 
2024 contract RequirementFilter is
2025     LibConstants,
2026     MixinExchangeCalldata,
2027     MixinFakeERC20Token,
2028     MixinRequirementFilterCore
2029 {
2030     constructor (address exchange)
2031         public
2032         LibConstants(exchange)
2033     {}
2034 }