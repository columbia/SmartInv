1 // File: contract-utils/Zerox/IExchange.sol
2 
3 /*
4 
5   Copyright 2018 ZeroEx Intl.
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
21 pragma solidity ^0.5.0;
22 pragma experimental ABIEncoderV2;
23 
24 contract IExchange {
25   function executeTransaction(
26         uint256 salt,
27         address signerAddress,
28         bytes calldata data,
29         bytes calldata signature
30   ) external;
31 }
32 
33 // File: contract-utils/Zerox/LibEIP712.sol
34 
35 /*
36 
37   Copyright 2018 ZeroEx Intl.
38 
39   Licensed under the Apache License, Version 2.0 (the "License");
40   you may not use this file except in compliance with the License.
41   You may obtain a copy of the License at
42 
43     http://www.apache.org/licenses/LICENSE-2.0
44 
45   Unless required by applicable law or agreed to in writing, software
46   distributed under the License is distributed on an "AS IS" BASIS,
47   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
48   See the License for the specific language governing permissions and
49   limitations under the License.
50 
51 */
52 
53 
54 
55 
56 contract LibEIP712 {
57 
58     // EIP191 header for EIP712 prefix
59     string constant internal EIP191_HEADER = "\x19\x01";
60 
61     // EIP712 Domain Name value
62     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
63 
64     // EIP712 Domain Version value
65     string constant internal EIP712_DOMAIN_VERSION = "2";
66 
67     // Hash of the EIP712 Domain Separator Schema
68     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
69         "EIP712Domain(",
70         "string name,",
71         "string version,",
72         "address verifyingContract",
73         ")"
74     ));
75 
76     // Hash of the EIP712 Domain Separator data
77     // solhint-disable-next-line var-name-mixedcase
78     bytes32 public EIP712_DOMAIN_HASH;
79 
80     constructor ()
81         public
82     {
83         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
84             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
85             keccak256(bytes(EIP712_DOMAIN_NAME)),
86             keccak256(bytes(EIP712_DOMAIN_VERSION)),
87             bytes12(0),
88             address(this)
89         ));
90     }
91 
92     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
93     /// @param hashStruct The EIP712 hash struct.
94     /// @return EIP712 hash applied to this EIP712 Domain.
95     function hashEIP712Message(bytes32 hashStruct)
96         internal
97         view
98         returns (bytes32 result)
99     {
100         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
101 
102         // Assembly for more efficient computing:
103         // keccak256(abi.encodePacked(
104         //     EIP191_HEADER,
105         //     EIP712_DOMAIN_HASH,
106         //     hashStruct    
107         // ));
108 
109         assembly {
110             // Load free memory pointer
111             let memPtr := mload(64)
112 
113             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
114             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
115             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
116 
117             // Compute hash
118             result := keccak256(memPtr, 66)
119         }
120         return result;
121     }
122 }
123 
124 // File: contract-utils/Zerox/LibOrder.sol
125 
126 /*
127 
128   Copyright 2018 ZeroEx Intl.
129 
130   Licensed under the Apache License, Version 2.0 (the "License");
131   you may not use this file except in compliance with the License.
132   You may obtain a copy of the License at
133 
134     http://www.apache.org/licenses/LICENSE-2.0
135 
136   Unless required by applicable law or agreed to in writing, software
137   distributed under the License is distributed on an "AS IS" BASIS,
138   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
139   See the License for the specific language governing permissions and
140   limitations under the License.
141 
142 */
143 
144 
145 
146 
147 
148 contract LibOrder is
149     LibEIP712
150 {
151     // Hash for the EIP712 Order Schema
152     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
153         "Order(",
154         "address makerAddress,",
155         "address takerAddress,",
156         "address feeRecipientAddress,",
157         "address senderAddress,",
158         "uint256 makerAssetAmount,",
159         "uint256 takerAssetAmount,",
160         "uint256 makerFee,",
161         "uint256 takerFee,",
162         "uint256 expirationTimeSeconds,",
163         "uint256 salt,",
164         "bytes makerAssetData,",
165         "bytes takerAssetData",
166         ")"
167     ));
168 
169     // A valid order remains fillable until it is expired, fully filled, or cancelled.
170     // An order's state is unaffected by external factors, like account balances.
171     enum OrderStatus {
172         INVALID,                     // Default value
173         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
174         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
175         FILLABLE,                    // Order is fillable
176         EXPIRED,                     // Order has already expired
177         FULLY_FILLED,                // Order is fully filled
178         CANCELLED                    // Order has been cancelled
179     }
180 
181     // solhint-disable max-line-length
182     struct Order {
183         address makerAddress;           // Address that created the order.      
184         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
185         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
186         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
187         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
188         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
189         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
190         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
191         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
192         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
193         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
194         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
195     }
196     // solhint-enable max-line-length
197 
198     struct OrderInfo {
199         uint8 orderStatus;                    // Status that describes order's validity and fillability.
200         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
201         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
202     }
203 
204     /// @dev Calculates Keccak-256 hash of the order.
205     /// @param order The order structure.
206     /// @return Keccak-256 EIP712 hash of the order.
207     function getOrderHash(Order memory order)
208         internal
209         view
210         returns (bytes32 orderHash)
211     {
212         orderHash = hashEIP712Message(hashOrder(order));
213         return orderHash;
214     }
215 
216     /// @dev Calculates EIP712 hash of the order.
217     /// @param order The order structure.
218     /// @return EIP712 hash of the order.
219     function hashOrder(Order memory order)
220         internal
221         pure
222         returns (bytes32 result)
223     {
224         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
225         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
226         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
227 
228         // Assembly for more efficiently computing:
229         // keccak256(abi.encodePacked(
230         //     EIP712_ORDER_SCHEMA_HASH,
231         //     bytes32(order.makerAddress),
232         //     bytes32(order.takerAddress),
233         //     bytes32(order.feeRecipientAddress),
234         //     bytes32(order.senderAddress),
235         //     order.makerAssetAmount,
236         //     order.takerAssetAmount,
237         //     order.makerFee,
238         //     order.takerFee,
239         //     order.expirationTimeSeconds,
240         //     order.salt,
241         //     keccak256(order.makerAssetData),
242         //     keccak256(order.takerAssetData)
243         // ));
244 
245         assembly {
246             // Calculate memory addresses that will be swapped out before hashing
247             let pos1 := sub(order, 32)
248             let pos2 := add(order, 320)
249             let pos3 := add(order, 352)
250 
251             // Backup
252             let temp1 := mload(pos1)
253             let temp2 := mload(pos2)
254             let temp3 := mload(pos3)
255             
256             // Hash in place
257             mstore(pos1, schemaHash)
258             mstore(pos2, makerAssetDataHash)
259             mstore(pos3, takerAssetDataHash)
260             result := keccak256(pos1, 416)
261             
262             // Restore
263             mstore(pos1, temp1)
264             mstore(pos2, temp2)
265             mstore(pos3, temp3)
266         }
267         return result;
268     }
269 }
270 
271 // File: contract-utils/Zerox/LibBytes.sol
272 
273 /*
274 
275   Copyright 2018 ZeroEx Intl.
276 
277   Licensed under the Apache License, Version 2.0 (the "License");
278   you may not use this file except in compliance with the License.
279   You may obtain a copy of the License at
280 
281     http://www.apache.org/licenses/LICENSE-2.0
282 
283   Unless required by applicable law or agreed to in writing, software
284   distributed under the License is distributed on an "AS IS" BASIS,
285   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
286   See the License for the specific language governing permissions and
287   limitations under the License.
288 
289 */
290 
291 
292 
293 
294 library LibBytes {
295 
296     using LibBytes for bytes;
297 
298     /// @dev Gets the memory address for a byte array.
299     /// @param input Byte array to lookup.
300     /// @return memoryAddress Memory address of byte array. This
301     ///         points to the header of the byte array which contains
302     ///         the length.
303     function rawAddress(bytes memory input)
304         internal
305         pure
306         returns (uint256 memoryAddress)
307     {
308         assembly {
309             memoryAddress := input
310         }
311         return memoryAddress;
312     }
313     
314     /// @dev Gets the memory address for the contents of a byte array.
315     /// @param input Byte array to lookup.
316     /// @return memoryAddress Memory address of the contents of the byte array.
317     function contentAddress(bytes memory input)
318         internal
319         pure
320         returns (uint256 memoryAddress)
321     {
322         assembly {
323             memoryAddress := add(input, 32)
324         }
325         return memoryAddress;
326     }
327 
328     /// @dev Copies `length` bytes from memory location `source` to `dest`.
329     /// @param dest memory address to copy bytes to.
330     /// @param source memory address to copy bytes from.
331     /// @param length number of bytes to copy.
332     function memCopy(
333         uint256 dest,
334         uint256 source,
335         uint256 length
336     )
337         internal
338         pure
339     {
340         if (length < 32) {
341             // Handle a partial word by reading destination and masking
342             // off the bits we are interested in.
343             // This correctly handles overlap, zero lengths and source == dest
344             assembly {
345                 let mask := sub(exp(256, sub(32, length)), 1)
346                 let s := and(mload(source), not(mask))
347                 let d := and(mload(dest), mask)
348                 mstore(dest, or(s, d))
349             }
350         } else {
351             // Skip the O(length) loop when source == dest.
352             if (source == dest) {
353                 return;
354             }
355 
356             // For large copies we copy whole words at a time. The final
357             // word is aligned to the end of the range (instead of after the
358             // previous) to handle partial words. So a copy will look like this:
359             //
360             //  ####
361             //      ####
362             //          ####
363             //            ####
364             //
365             // We handle overlap in the source and destination range by
366             // changing the copying direction. This prevents us from
367             // overwriting parts of source that we still need to copy.
368             //
369             // This correctly handles source == dest
370             //
371             if (source > dest) {
372                 assembly {
373                     // We subtract 32 from `sEnd` and `dEnd` because it
374                     // is easier to compare with in the loop, and these
375                     // are also the addresses we need for copying the
376                     // last bytes.
377                     length := sub(length, 32)
378                     let sEnd := add(source, length)
379                     let dEnd := add(dest, length)
380 
381                     // Remember the last 32 bytes of source
382                     // This needs to be done here and not after the loop
383                     // because we may have overwritten the last bytes in
384                     // source already due to overlap.
385                     let last := mload(sEnd)
386 
387                     // Copy whole words front to back
388                     // Note: the first check is always true,
389                     // this could have been a do-while loop.
390                     // solhint-disable-next-line no-empty-blocks
391                     for {} lt(source, sEnd) {} {
392                         mstore(dest, mload(source))
393                         source := add(source, 32)
394                         dest := add(dest, 32)
395                     }
396                     
397                     // Write the last 32 bytes
398                     mstore(dEnd, last)
399                 }
400             } else {
401                 assembly {
402                     // We subtract 32 from `sEnd` and `dEnd` because those
403                     // are the starting points when copying a word at the end.
404                     length := sub(length, 32)
405                     let sEnd := add(source, length)
406                     let dEnd := add(dest, length)
407 
408                     // Remember the first 32 bytes of source
409                     // This needs to be done here and not after the loop
410                     // because we may have overwritten the first bytes in
411                     // source already due to overlap.
412                     let first := mload(source)
413 
414                     // Copy whole words back to front
415                     // We use a signed comparisson here to allow dEnd to become
416                     // negative (happens when source and dest < 32). Valid
417                     // addresses in local memory will never be larger than
418                     // 2**255, so they can be safely re-interpreted as signed.
419                     // Note: the first check is always true,
420                     // this could have been a do-while loop.
421                     // solhint-disable-next-line no-empty-blocks
422                     for {} slt(dest, dEnd) {} {
423                         mstore(dEnd, mload(sEnd))
424                         sEnd := sub(sEnd, 32)
425                         dEnd := sub(dEnd, 32)
426                     }
427                     
428                     // Write the first 32 bytes
429                     mstore(dest, first)
430                 }
431             }
432         }
433     }
434 
435     /// @dev Returns a slices from a byte array.
436     /// @param b The byte array to take a slice from.
437     /// @param from The starting index for the slice (inclusive).
438     /// @param to The final index for the slice (exclusive).
439     /// @return result The slice containing bytes at indices [from, to)
440     function slice(
441         bytes memory b,
442         uint256 from,
443         uint256 to
444     )
445         internal
446         pure
447         returns (bytes memory result)
448     {
449         require(
450             from <= to,
451             "FROM_LESS_THAN_TO_REQUIRED"
452         );
453         require(
454             to < b.length,
455             "TO_LESS_THAN_LENGTH_REQUIRED"
456         );
457         
458         // Create a new bytes structure and copy contents
459         result = new bytes(to - from);
460         memCopy(
461             result.contentAddress(),
462             b.contentAddress() + from,
463             result.length
464         );
465         return result;
466     }
467     
468     /// @dev Returns a slice from a byte array without preserving the input.
469     /// @param b The byte array to take a slice from. Will be destroyed in the process.
470     /// @param from The starting index for the slice (inclusive).
471     /// @param to The final index for the slice (exclusive).
472     /// @return result The slice containing bytes at indices [from, to)
473     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
474     function sliceDestructive(
475         bytes memory b,
476         uint256 from,
477         uint256 to
478     )
479         internal
480         pure
481         returns (bytes memory result)
482     {
483         require(
484             from <= to,
485             "FROM_LESS_THAN_TO_REQUIRED"
486         );
487         require(
488             to < b.length,
489             "TO_LESS_THAN_LENGTH_REQUIRED"
490         );
491         
492         // Create a new bytes structure around [from, to) in-place.
493         assembly {
494             result := add(b, from)
495             mstore(result, sub(to, from))
496         }
497         return result;
498     }
499 
500     /// @dev Pops the last byte off of a byte array by modifying its length.
501     /// @param b Byte array that will be modified.
502     /// @return The byte that was popped off.
503     function popLastByte(bytes memory b)
504         internal
505         pure
506         returns (bytes1 result)
507     {
508         require(
509             b.length > 0,
510             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
511         );
512 
513         // Store last byte.
514         result = b[b.length - 1];
515 
516         assembly {
517             // Decrement length of byte array.
518             let newLen := sub(mload(b), 1)
519             mstore(b, newLen)
520         }
521         return result;
522     }
523 
524     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
525     /// @param b Byte array that will be modified.
526     /// @return The 20 byte address that was popped off.
527     function popLast20Bytes(bytes memory b)
528         internal
529         pure
530         returns (address result)
531     {
532         require(
533             b.length >= 20,
534             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
535         );
536 
537         // Store last 20 bytes.
538         result = readAddress(b, b.length - 20);
539 
540         assembly {
541             // Subtract 20 from byte array length.
542             let newLen := sub(mload(b), 20)
543             mstore(b, newLen)
544         }
545         return result;
546     }
547 
548     /// @dev Tests equality of two byte arrays.
549     /// @param lhs First byte array to compare.
550     /// @param rhs Second byte array to compare.
551     /// @return True if arrays are the same. False otherwise.
552     function equals(
553         bytes memory lhs,
554         bytes memory rhs
555     )
556         internal
557         pure
558         returns (bool equal)
559     {
560         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
561         // We early exit on unequal lengths, but keccak would also correctly
562         // handle this.
563         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
564     }
565 
566     /// @dev Reads an address from a position in a byte array.
567     /// @param b Byte array containing an address.
568     /// @param index Index in byte array of address.
569     /// @return address from byte array.
570     function readAddress(
571         bytes memory b,
572         uint256 index
573     )
574         internal
575         pure
576         returns (address result)
577     {
578         require(
579             b.length >= index + 20,  // 20 is length of address
580             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
581         );
582 
583         // Add offset to index:
584         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
585         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
586         index += 20;
587 
588         // Read address from array memory
589         assembly {
590             // 1. Add index to address of bytes array
591             // 2. Load 32-byte word from memory
592             // 3. Apply 20-byte mask to obtain address
593             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
594         }
595         return result;
596     }
597 
598     /// @dev Writes an address into a specific position in a byte array.
599     /// @param b Byte array to insert address into.
600     /// @param index Index in byte array of address.
601     /// @param input Address to put into byte array.
602     function writeAddress(
603         bytes memory b,
604         uint256 index,
605         address input
606     )
607         internal
608         pure
609     {
610         require(
611             b.length >= index + 20,  // 20 is length of address
612             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
613         );
614 
615         // Add offset to index:
616         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
617         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
618         index += 20;
619 
620         // Store address into array memory
621         assembly {
622             // The address occupies 20 bytes and mstore stores 32 bytes.
623             // First fetch the 32-byte word where we'll be storing the address, then
624             // apply a mask so we have only the bytes in the word that the address will not occupy.
625             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
626 
627             // 1. Add index to address of bytes array
628             // 2. Load 32-byte word from memory
629             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
630             let neighbors := and(
631                 mload(add(b, index)),
632                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
633             )
634             
635             // Make sure input address is clean.
636             // (Solidity does not guarantee this)
637             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
638 
639             // Store the neighbors and address into memory
640             mstore(add(b, index), xor(input, neighbors))
641         }
642     }
643 
644     /// @dev Reads a bytes32 value from a position in a byte array.
645     /// @param b Byte array containing a bytes32 value.
646     /// @param index Index in byte array of bytes32 value.
647     /// @return bytes32 value from byte array.
648     function readBytes32(
649         bytes memory b,
650         uint256 index
651     )
652         internal
653         pure
654         returns (bytes32 result)
655     {
656         require(
657             b.length >= index + 32,
658             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
659         );
660 
661         // Arrays are prefixed by a 256 bit length parameter
662         index += 32;
663 
664         // Read the bytes32 from array memory
665         assembly {
666             result := mload(add(b, index))
667         }
668         return result;
669     }
670 
671     /// @dev Writes a bytes32 into a specific position in a byte array.
672     /// @param b Byte array to insert <input> into.
673     /// @param index Index in byte array of <input>.
674     /// @param input bytes32 to put into byte array.
675     function writeBytes32(
676         bytes memory b,
677         uint256 index,
678         bytes32 input
679     )
680         internal
681         pure
682     {
683         require(
684             b.length >= index + 32,
685             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
686         );
687 
688         // Arrays are prefixed by a 256 bit length parameter
689         index += 32;
690 
691         // Read the bytes32 from array memory
692         assembly {
693             mstore(add(b, index), input)
694         }
695     }
696 
697     /// @dev Reads a uint256 value from a position in a byte array.
698     /// @param b Byte array containing a uint256 value.
699     /// @param index Index in byte array of uint256 value.
700     /// @return uint256 value from byte array.
701     function readUint256(
702         bytes memory b,
703         uint256 index
704     )
705         internal
706         pure
707         returns (uint256 result)
708     {
709         result = uint256(readBytes32(b, index));
710         return result;
711     }
712 
713     /// @dev Writes a uint256 into a specific position in a byte array.
714     /// @param b Byte array to insert <input> into.
715     /// @param index Index in byte array of <input>.
716     /// @param input uint256 to put into byte array.
717     function writeUint256(
718         bytes memory b,
719         uint256 index,
720         uint256 input
721     )
722         internal
723         pure
724     {
725         writeBytes32(b, index, bytes32(input));
726     }
727 
728     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
729     /// @param b Byte array containing a bytes4 value.
730     /// @param index Index in byte array of bytes4 value.
731     /// @return bytes4 value from byte array.
732     function readBytes4(
733         bytes memory b,
734         uint256 index
735     )
736         internal
737         pure
738         returns (bytes4 result)
739     {
740         require(
741             b.length >= index + 4,
742             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
743         );
744 
745         // Arrays are prefixed by a 32 byte length field
746         index += 32;
747 
748         // Read the bytes4 from array memory
749         assembly {
750             result := mload(add(b, index))
751             // Solidity does not require us to clean the trailing bytes.
752             // We do it anyway
753             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
754         }
755         return result;
756     }
757 
758     function readBytes2(
759         bytes memory b,
760         uint256 index
761     )
762         internal
763         pure
764         returns (bytes2 result)
765     {
766         require(
767             b.length >= index + 2,
768             "GREATER_OR_EQUAL_TO_2_LENGTH_REQUIRED"
769         );
770 
771         // Arrays are prefixed by a 32 byte length field
772         index += 32;
773 
774         // Read the bytes4 from array memory
775         assembly {
776             result := mload(add(b, index))
777             // Solidity does not require us to clean the trailing bytes.
778             // We do it anyway
779             result := and(result, 0xFFFF000000000000000000000000000000000000000000000000000000000000)
780         }
781         return result;
782     }
783 
784     /// @dev Reads nested bytes from a specific position.
785     /// @dev NOTE: the returned value overlaps with the input value.
786     ///            Both should be treated as immutable.
787     /// @param b Byte array containing nested bytes.
788     /// @param index Index of nested bytes.
789     /// @return result Nested bytes.
790     function readBytesWithLength(
791         bytes memory b,
792         uint256 index
793     )
794         internal
795         pure
796         returns (bytes memory result)
797     {
798         // Read length of nested bytes
799         uint256 nestedBytesLength = readUint256(b, index);
800         index += 32;
801 
802         // Assert length of <b> is valid, given
803         // length of nested bytes
804         require(
805             b.length >= index + nestedBytesLength,
806             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
807         );
808         
809         // Return a pointer to the byte array as it exists inside `b`
810         assembly {
811             result := add(b, index)
812         }
813         return result;
814     }
815 
816     /// @dev Inserts bytes at a specific position in a byte array.
817     /// @param b Byte array to insert <input> into.
818     /// @param index Index in byte array of <input>.
819     /// @param input bytes to insert.
820     function writeBytesWithLength(
821         bytes memory b,
822         uint256 index,
823         bytes memory input
824     )
825         internal
826         pure
827     {
828         // Assert length of <b> is valid, given
829         // length of input
830         require(
831             b.length >= index + 32 + input.length,  // 32 bytes to store length
832             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
833         );
834 
835         // Copy <input> into <b>
836         memCopy(
837             b.contentAddress() + index,
838             input.rawAddress(), // includes length of <input>
839             input.length + 32   // +32 bytes to store <input> length
840         );
841     }
842 
843     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
844     /// @param dest Byte array that will be overwritten with source bytes.
845     /// @param source Byte array to copy onto dest bytes.
846     function deepCopyBytes(
847         bytes memory dest,
848         bytes memory source
849     )
850         internal
851         pure
852     {
853         uint256 sourceLen = source.length;
854         // Dest length must be >= source length, or some bytes would not be copied.
855         require(
856             dest.length >= sourceLen,
857             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
858         );
859         memCopy(
860             dest.contentAddress(),
861             source.contentAddress(),
862             sourceLen
863         );
864     }
865 }
866 
867 // File: contract-utils/Zerox/LibDecoder.sol
868 
869 
870 
871 
872 contract LibDecoder {
873     using LibBytes for bytes;
874 
875     function decodeFillOrder(bytes memory data) internal pure returns(LibOrder.Order memory order, uint256 takerFillAmount, bytes memory mmSignature) {
876         require(
877             data.length > 800,
878             "LENGTH_LESS_800"
879         );
880 
881         // compare method_id
882         // 0x64a3bc15 is fillOrKillOrder's method id.
883         require(
884             data.readBytes4(0) == 0x64a3bc15,
885             "WRONG_METHOD_ID"
886         );
887         
888         bytes memory dataSlice;
889         assembly {
890             dataSlice := add(data, 4)
891         }
892         //return (order, takerFillAmount, data);
893         return abi.decode(dataSlice, (LibOrder.Order, uint256, bytes));
894 
895     }
896 
897     function decodeMmSignatureWithoutSign(bytes memory signature) internal pure returns(address user, uint16 feeFactor) {
898         require(
899             signature.length == 87 || signature.length == 88,
900             "LENGTH_87_REQUIRED"
901         );
902 
903         user = signature.readAddress(65);
904         feeFactor = uint16(signature.readBytes2(85));
905         
906         require(
907             feeFactor < 10000,
908             "FEE_FACTOR_MORE_THEN_10000"
909         );
910 
911         return (user, feeFactor);
912     }
913 
914     function decodeMmSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address user, uint16 feeFactor) {
915         (user, feeFactor) = decodeMmSignatureWithoutSign(signature);
916 
917         v = uint8(signature[0]);
918         r = signature.readBytes32(1);
919         s = signature.readBytes32(33);
920 
921         return (v, r, s, user, feeFactor);
922     }
923 
924     function decodeUserSignatureWithoutSign(bytes memory signature) internal pure returns(address receiver) {
925         require(
926             signature.length == 85 || signature.length == 86,
927             "LENGTH_85_REQUIRED"
928         );
929         receiver = signature.readAddress(65);
930 
931         return receiver;
932     }
933 
934     function decodeUserSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address receiver) {
935         receiver = decodeUserSignatureWithoutSign(signature);
936 
937         v = uint8(signature[0]);
938         r = signature.readBytes32(1);
939         s = signature.readBytes32(33);
940 
941         return (v, r, s, receiver);
942     }
943 
944     function decodeERC20Asset(bytes memory assetData) internal pure returns(address) {
945         require(
946             assetData.length == 36,
947             "LENGTH_65_REQUIRED"
948         );
949 
950         return assetData.readAddress(16);
951     }
952 }
953 
954 // File: contract-utils/Zerox/LibEncoder.sol
955 
956 
957 
958 
959 contract LibEncoder is
960     LibEIP712
961 {
962     // Hash for the EIP712 ZeroEx Transaction Schema
963     bytes32 constant internal EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = keccak256(
964         abi.encodePacked(
965         "ZeroExTransaction(",
966         "uint256 salt,",
967         "address signerAddress,",
968         "bytes data",
969         ")"
970     ));
971 
972     function encodeTransactionHash(
973         uint256 salt,
974         address signerAddress,
975         bytes memory data
976     )
977         internal
978         view 
979         returns (bytes32 result)
980     {
981         bytes32 schemaHash = EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
982         bytes32 dataHash = keccak256(data);
983 
984         // Assembly for more efficiently computing:
985         // keccak256(abi.encodePacked(
986         //     EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH,
987         //     salt,
988         //     bytes32(signerAddress),
989         //     keccak256(data)
990         // ));
991 
992         assembly {
993             // Load free memory pointer
994             let memPtr := mload(64)
995 
996             mstore(memPtr, schemaHash)                                                               // hash of schema
997             mstore(add(memPtr, 32), salt)                                                            // salt
998             mstore(add(memPtr, 64), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
999             mstore(add(memPtr, 96), dataHash)                                                        // hash of data
1000 
1001             // Compute hash
1002             result := keccak256(memPtr, 128)
1003         }
1004         result = hashEIP712Message(result);
1005         return result;
1006     }
1007 }
1008 
1009 // File: contract-utils/Ownable/IOwnable.sol
1010 
1011 
1012 
1013 contract IOwnable {
1014   function transferOwnership(address newOwner) public;
1015 
1016   function setOperator(address newOwner) public;
1017 }
1018 
1019 // File: contract-utils/Ownable/Ownable.sol
1020 
1021 
1022 
1023 
1024 
1025 contract Ownable is
1026   IOwnable
1027 {
1028   address public owner;
1029   address public operator;
1030 
1031   constructor ()
1032     public
1033   {
1034     owner = msg.sender;
1035   }
1036 
1037   modifier onlyOwner() {
1038     require(
1039       msg.sender == owner,
1040       "ONLY_CONTRACT_OWNER"
1041     );
1042     _;
1043   }
1044 
1045   modifier onlyOperator() {
1046     require(
1047       msg.sender == operator,
1048       "ONLY_CONTRACT_OPERATOR"
1049     );
1050     _;
1051   }
1052 
1053   function transferOwnership(address newOwner)
1054     public
1055     onlyOwner
1056   {
1057     if (newOwner != address(0)) {
1058       owner = newOwner;
1059     }
1060   }
1061 
1062   function setOperator(address newOperator)
1063     public
1064     onlyOwner 
1065   {
1066     operator = newOperator;
1067   }
1068 }
1069 
1070 // File: contract-utils/Interface/IUserProxy.sol
1071 
1072 
1073 
1074 contract IUserProxy {
1075     function receiveToken(address tokenAddr, address userAddr, uint256 amount) external;
1076 
1077     function sendToken(address tokenAddr, address userAddr, uint256 amount) external;
1078 
1079     function receiveETH(address wethAddr) payable external;
1080 
1081     function sendETH(address wethAddr, address payable userAddr, uint256 amount) external;
1082 }
1083 
1084 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1085 
1086 
1087 
1088 /**
1089  * @title SafeMath
1090  * @dev Unsigned math operations with safety checks that revert on error
1091  */
1092 library SafeMath {
1093     /**
1094     * @dev Multiplies two unsigned integers, reverts on overflow.
1095     */
1096     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1097         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1098         // benefit is lost if 'b' is also tested.
1099         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1100         if (a == 0) {
1101             return 0;
1102         }
1103 
1104         uint256 c = a * b;
1105         require(c / a == b);
1106 
1107         return c;
1108     }
1109 
1110     /**
1111     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
1112     */
1113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1114         // Solidity only automatically asserts when dividing by 0
1115         require(b > 0);
1116         uint256 c = a / b;
1117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1118 
1119         return c;
1120     }
1121 
1122     /**
1123     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1124     */
1125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1126         require(b <= a);
1127         uint256 c = a - b;
1128 
1129         return c;
1130     }
1131 
1132     /**
1133     * @dev Adds two unsigned integers, reverts on overflow.
1134     */
1135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1136         uint256 c = a + b;
1137         require(c >= a);
1138 
1139         return c;
1140     }
1141 
1142     /**
1143     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
1144     * reverts when dividing by zero.
1145     */
1146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1147         require(b != 0);
1148         return a % b;
1149     }
1150 }
1151 
1152 // File: contracts/TokenlonExchange.sol
1153 
1154 
1155 
1156 contract TokenlonExchange is 
1157     Ownable,
1158     LibDecoder,
1159     LibEncoder
1160 {
1161     string public version = "0.0.3";
1162 
1163     IExchange internal ZX_EXCHANGE;
1164     IUserProxy internal USER_PROXY; 
1165     address internal WETH_ADDR;
1166 
1167     // exchange is enabled
1168     bool public isEnabled = false;
1169 
1170     // marketMakerProxy white list:
1171     mapping(address=>bool) public isMarketMakerProxy;
1172 
1173     // executeTxHash => user
1174     mapping(bytes32=>address) public transactions;
1175 
1176     constructor () public {
1177         owner = msg.sender;
1178         operator = msg.sender;
1179     }
1180 
1181     // events
1182     event FillOrder(
1183         bytes32 indexed executeTxHash,
1184         address indexed userAddr,
1185         address receiverAddr,
1186         uint256 filledAmount, 
1187         uint256 acutalMakerAssetAmount
1188     );
1189 
1190     // fillOrder with token
1191     // sender is any external accounts
1192     // 0x order successed send eth to user
1193     function fillOrderWithToken(
1194         uint256 userSalt,
1195         bytes memory data,
1196         bytes memory userSignature
1197     )
1198         public
1199     {
1200         require(isEnabled, "EXCHANGE_DISABLED");
1201 
1202         // decode & assert
1203         (LibOrder.Order memory order,
1204         address user,
1205         address receiver,
1206         uint16 feeFactor,
1207         address makerAssetAddr,
1208         address takerAssetAddr,
1209         bytes32 transactionHash) = assertTransaction(userSalt, data, userSignature);
1210 
1211         // saved transaction
1212         transactions[transactionHash] = user;
1213 
1214         // USER_PROXY transfer user's token
1215         USER_PROXY.receiveToken(takerAssetAddr, user, order.takerAssetAmount);
1216 
1217         // send tx to 0x
1218         ZX_EXCHANGE.executeTransaction(
1219             userSalt,
1220             address(USER_PROXY),
1221             data,
1222             userSignature
1223         );
1224 
1225         // settle token/ETH to user
1226         uint256 acutalMakerAssetAmount = settle(receiver, makerAssetAddr, order.makerAssetAmount, feeFactor);
1227 
1228         emit FillOrder(transactionHash, user, receiver, order.takerAssetAmount, acutalMakerAssetAmount);
1229     }
1230 
1231     function fillOrderWithETH(
1232         uint256 userSalt,
1233         bytes memory data,
1234         bytes memory userSignature
1235     )
1236         public
1237         payable
1238     {
1239         require(isEnabled, "EXCHANGE_DISABLED");
1240 
1241         // decode & assert
1242         (LibOrder.Order memory order,
1243         address user,
1244         address receiver,
1245         uint16 feeFactor,
1246         address makerAssetAddr,
1247         address takerAssetAddr,
1248         bytes32 transactionHash) = assertTransaction(userSalt, data, userSignature);
1249 
1250         require(
1251             msg.sender == user,
1252             "SENDER_IS_NOT_USER"
1253         );
1254 
1255         require(
1256             WETH_ADDR == takerAssetAddr,
1257             "USER_ASSET_NOT_WETH"
1258         );
1259 
1260         require(
1261             msg.value == order.takerAssetAmount,
1262             "ETH_NOT_ENOUGH"
1263         );
1264 
1265         // saved transaction
1266         transactions[transactionHash] = user;
1267 
1268         // USER_PROXY receive eth from TokenlonExchange
1269         USER_PROXY.receiveETH.value(msg.value)(WETH_ADDR);
1270 
1271         // send tx to 0x
1272         ZX_EXCHANGE.executeTransaction(
1273             userSalt,
1274             address(USER_PROXY),
1275             data,
1276             userSignature
1277         );
1278 
1279         // settle token/ETH to user
1280         uint256 acutalMakerAssetAmount = settle(receiver, makerAssetAddr, order.makerAssetAmount, feeFactor);
1281 
1282         emit FillOrder(transactionHash, user, receiver, order.takerAssetAmount, acutalMakerAssetAmount);
1283     }
1284 
1285     // assert & decode transaction
1286     function assertTransaction(uint256 userSalt, bytes memory data, bytes memory userSignature)
1287     public view returns(
1288         LibOrder.Order memory order,
1289         address user,
1290         address receiver,
1291         uint16 feeFactor,
1292         address makerAssetAddr,
1293         address takerAssetAddr,
1294         bytes32 transactionHash
1295     ){
1296         // decode fillOrder data
1297         uint256 takerFillAmount;
1298         bytes memory mmSignature;
1299         (order, takerFillAmount, mmSignature) = decodeFillOrder(data);
1300 
1301         require(
1302             this.isMarketMakerProxy(order.makerAddress),
1303             "MAKER_ADDRESS_ERROR"
1304         );
1305 
1306         require(
1307             order.takerAddress == address(USER_PROXY),
1308             "TAKER_ADDRESS_ERROR"
1309         );
1310         require(
1311             order.takerAssetAmount == takerFillAmount,
1312             "FIll_AMOUNT_ERROR"
1313         );
1314 
1315         // generate transactionHash
1316         transactionHash = encodeTransactionHash(
1317             userSalt,
1318             address(USER_PROXY),
1319             data
1320         );
1321 
1322         require(
1323             transactions[transactionHash] == address(0),
1324             "EXECUTED_TX_HASH"
1325         );
1326 
1327         // decode mmSignature
1328         (user, feeFactor) = decodeMmSignatureWithoutSign(mmSignature);
1329 
1330         require(
1331             feeFactor < 10000,
1332             "FEE_FACTOR_MORE_THEN_10000"
1333         );
1334 
1335         // decode userSignature
1336         receiver = decodeUserSignatureWithoutSign(userSignature);
1337 
1338         require(
1339             receiver != address(0),
1340             "INVALID_RECIVER"
1341         );
1342 
1343         // decode asset
1344         // just support ERC20
1345         makerAssetAddr = decodeERC20Asset(order.makerAssetData);
1346         takerAssetAddr = decodeERC20Asset(order.takerAssetData);
1347 
1348         return (
1349             order,
1350             user,
1351             receiver,
1352             feeFactor,
1353             makerAssetAddr,
1354             takerAssetAddr,
1355             transactionHash
1356         );        
1357     }
1358 
1359     // settle
1360     function settle(address receiver, address makerAssetAddr, uint256 makerAssetAmount, uint16 feeFactor) internal returns(uint256) {
1361         uint256 settleAmount = deductFee(makerAssetAmount, feeFactor);
1362 
1363         if (makerAssetAddr == WETH_ADDR){
1364             USER_PROXY.sendETH(WETH_ADDR, address(uint160(receiver)), settleAmount);
1365         } else {
1366             USER_PROXY.sendToken(makerAssetAddr, receiver, settleAmount);
1367         }
1368 
1369         return settleAmount;
1370     }
1371 
1372     // deduct fee
1373     function deductFee(uint256 makerAssetAmount, uint16 feeFactor) internal pure returns (uint256) {
1374         if(feeFactor == 0) {
1375             return makerAssetAmount;
1376         }
1377 
1378         uint256 fee = SafeMath.div(SafeMath.mul(makerAssetAmount, feeFactor), 10000);
1379         return SafeMath.sub(makerAssetAmount, fee);
1380     }
1381 
1382     // manage 
1383     function registerMMP(address _marketMakerProxy, bool _add) public onlyOperator {
1384         isMarketMakerProxy[_marketMakerProxy] = _add;
1385     }
1386 
1387     function setProxy(IExchange _exchange, IUserProxy _userProxy, address _weth) public onlyOperator {
1388         ZX_EXCHANGE = _exchange;
1389         USER_PROXY = _userProxy;
1390         WETH_ADDR = _weth;
1391 
1392         // this const follow ZX_EXCHANGE address
1393         // encodeTransactionHash depend ZX_EXCHANGE address
1394         EIP712_DOMAIN_HASH = keccak256(
1395             abi.encodePacked(
1396                 EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1397                 keccak256(bytes(EIP712_DOMAIN_NAME)),
1398                 keccak256(bytes(EIP712_DOMAIN_VERSION)),
1399                 bytes12(0),
1400                 address(ZX_EXCHANGE)
1401             )
1402         );
1403     }
1404 
1405     function setEnabled(bool _enable) public onlyOperator {
1406         isEnabled = _enable;
1407     }
1408 
1409 }