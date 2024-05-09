1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract IOwnable {
5   function transferOwnership(address newOwner) public;
6 
7   function setOperator(address newOwner) public;
8 }
9 
10 contract Ownable is
11   IOwnable
12 {
13   address public owner;
14   address public operator;
15 
16   constructor ()
17     public
18   {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     require(
24       msg.sender == owner,
25       "ONLY_CONTRACT_OWNER"
26     );
27     _;
28   }
29 
30   modifier onlyOperator() {
31     require(
32       msg.sender == operator,
33       "ONLY_CONTRACT_OPERATOR"
34     );
35     _;
36   }
37 
38   function transferOwnership(address newOwner)
39     public
40     onlyOwner
41   {
42     if (newOwner != address(0)) {
43       owner = newOwner;
44     }
45   }
46 
47   function setOperator(address newOperator)
48     public
49     onlyOwner 
50   {
51     operator = newOperator;
52   }
53 }
54 
55 contract ITokenlonExchange {
56     function transactions(bytes32 executeTxHash) external returns (address);
57 }
58 
59 /*
60 
61   Copyright 2018 ZeroEx Intl.
62 
63   Licensed under the Apache License, Version 2.0 (the "License");
64   you may not use this file except in compliance with the License.
65   You may obtain a copy of the License at
66 
67     http://www.apache.org/licenses/LICENSE-2.0
68 
69   Unless required by applicable law or agreed to in writing, software
70   distributed under the License is distributed on an "AS IS" BASIS,
71   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
72   See the License for the specific language governing permissions and
73   limitations under the License.
74 
75 */
76 
77 contract LibEIP712 {
78 
79     // EIP191 header for EIP712 prefix
80     string constant internal EIP191_HEADER = "\x19\x01";
81 
82     // EIP712 Domain Name value
83     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
84 
85     // EIP712 Domain Version value
86     string constant internal EIP712_DOMAIN_VERSION = "2";
87 
88     // Hash of the EIP712 Domain Separator Schema
89     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
90         "EIP712Domain(",
91         "string name,",
92         "string version,",
93         "address verifyingContract",
94         ")"
95     ));
96 
97     // Hash of the EIP712 Domain Separator data
98     // solhint-disable-next-line var-name-mixedcase
99     bytes32 public EIP712_DOMAIN_HASH;
100 
101     constructor ()
102         public
103     {
104         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
105             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
106             keccak256(bytes(EIP712_DOMAIN_NAME)),
107             keccak256(bytes(EIP712_DOMAIN_VERSION)),
108             bytes12(0),
109             address(this)
110         ));
111     }
112 
113     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
114     /// @param hashStruct The EIP712 hash struct.
115     /// @return EIP712 hash applied to this EIP712 Domain.
116     function hashEIP712Message(bytes32 hashStruct)
117         internal
118         view
119         returns (bytes32 result)
120     {
121         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
122 
123         // Assembly for more efficient computing:
124         // keccak256(abi.encodePacked(
125         //     EIP191_HEADER,
126         //     EIP712_DOMAIN_HASH,
127         //     hashStruct    
128         // ));
129 
130         assembly {
131             // Load free memory pointer
132             let memPtr := mload(64)
133 
134             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
135             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
136             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
137 
138             // Compute hash
139             result := keccak256(memPtr, 66)
140         }
141         return result;
142     }
143 }
144 
145 /*
146 
147   Copyright 2018 ZeroEx Intl.
148 
149   Licensed under the Apache License, Version 2.0 (the "License");
150   you may not use this file except in compliance with the License.
151   You may obtain a copy of the License at
152 
153     http://www.apache.org/licenses/LICENSE-2.0
154 
155   Unless required by applicable law or agreed to in writing, software
156   distributed under the License is distributed on an "AS IS" BASIS,
157   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
158   See the License for the specific language governing permissions and
159   limitations under the License.
160 
161 */
162 
163 contract LibOrder is
164     LibEIP712
165 {
166     // Hash for the EIP712 Order Schema
167     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
168         "Order(",
169         "address makerAddress,",
170         "address takerAddress,",
171         "address feeRecipientAddress,",
172         "address senderAddress,",
173         "uint256 makerAssetAmount,",
174         "uint256 takerAssetAmount,",
175         "uint256 makerFee,",
176         "uint256 takerFee,",
177         "uint256 expirationTimeSeconds,",
178         "uint256 salt,",
179         "bytes makerAssetData,",
180         "bytes takerAssetData",
181         ")"
182     ));
183 
184     // A valid order remains fillable until it is expired, fully filled, or cancelled.
185     // An order's state is unaffected by external factors, like account balances.
186     enum OrderStatus {
187         INVALID,                     // Default value
188         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
189         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
190         FILLABLE,                    // Order is fillable
191         EXPIRED,                     // Order has already expired
192         FULLY_FILLED,                // Order is fully filled
193         CANCELLED                    // Order has been cancelled
194     }
195 
196     // solhint-disable max-line-length
197     struct Order {
198         address makerAddress;           // Address that created the order.      
199         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
200         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
201         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
202         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
203         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
204         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
205         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
206         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
207         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
208         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
209         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
210     }
211     // solhint-enable max-line-length
212 
213     struct OrderInfo {
214         uint8 orderStatus;                    // Status that describes order's validity and fillability.
215         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
216         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
217     }
218 
219     /// @dev Calculates Keccak-256 hash of the order.
220     /// @param order The order structure.
221     /// @return Keccak-256 EIP712 hash of the order.
222     function getOrderHash(Order memory order)
223         internal
224         view
225         returns (bytes32 orderHash)
226     {
227         orderHash = hashEIP712Message(hashOrder(order));
228         return orderHash;
229     }
230 
231     /// @dev Calculates EIP712 hash of the order.
232     /// @param order The order structure.
233     /// @return EIP712 hash of the order.
234     function hashOrder(Order memory order)
235         internal
236         pure
237         returns (bytes32 result)
238     {
239         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
240         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
241         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
242 
243         // Assembly for more efficiently computing:
244         // keccak256(abi.encodePacked(
245         //     EIP712_ORDER_SCHEMA_HASH,
246         //     bytes32(order.makerAddress),
247         //     bytes32(order.takerAddress),
248         //     bytes32(order.feeRecipientAddress),
249         //     bytes32(order.senderAddress),
250         //     order.makerAssetAmount,
251         //     order.takerAssetAmount,
252         //     order.makerFee,
253         //     order.takerFee,
254         //     order.expirationTimeSeconds,
255         //     order.salt,
256         //     keccak256(order.makerAssetData),
257         //     keccak256(order.takerAssetData)
258         // ));
259 
260         assembly {
261             // Calculate memory addresses that will be swapped out before hashing
262             let pos1 := sub(order, 32)
263             let pos2 := add(order, 320)
264             let pos3 := add(order, 352)
265 
266             // Backup
267             let temp1 := mload(pos1)
268             let temp2 := mload(pos2)
269             let temp3 := mload(pos3)
270             
271             // Hash in place
272             mstore(pos1, schemaHash)
273             mstore(pos2, makerAssetDataHash)
274             mstore(pos3, takerAssetDataHash)
275             result := keccak256(pos1, 416)
276             
277             // Restore
278             mstore(pos1, temp1)
279             mstore(pos2, temp2)
280             mstore(pos3, temp3)
281         }
282         return result;
283     }
284 }
285 
286 /*
287 
288   Copyright 2018 ZeroEx Intl.
289 
290   Licensed under the Apache License, Version 2.0 (the "License");
291   you may not use this file except in compliance with the License.
292   You may obtain a copy of the License at
293 
294     http://www.apache.org/licenses/LICENSE-2.0
295 
296   Unless required by applicable law or agreed to in writing, software
297   distributed under the License is distributed on an "AS IS" BASIS,
298   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
299   See the License for the specific language governing permissions and
300   limitations under the License.
301 
302 */
303 
304 library LibBytes {
305 
306     using LibBytes for bytes;
307 
308     /// @dev Gets the memory address for a byte array.
309     /// @param input Byte array to lookup.
310     /// @return memoryAddress Memory address of byte array. This
311     ///         points to the header of the byte array which contains
312     ///         the length.
313     function rawAddress(bytes memory input)
314         internal
315         pure
316         returns (uint256 memoryAddress)
317     {
318         assembly {
319             memoryAddress := input
320         }
321         return memoryAddress;
322     }
323     
324     /// @dev Gets the memory address for the contents of a byte array.
325     /// @param input Byte array to lookup.
326     /// @return memoryAddress Memory address of the contents of the byte array.
327     function contentAddress(bytes memory input)
328         internal
329         pure
330         returns (uint256 memoryAddress)
331     {
332         assembly {
333             memoryAddress := add(input, 32)
334         }
335         return memoryAddress;
336     }
337 
338     /// @dev Copies `length` bytes from memory location `source` to `dest`.
339     /// @param dest memory address to copy bytes to.
340     /// @param source memory address to copy bytes from.
341     /// @param length number of bytes to copy.
342     function memCopy(
343         uint256 dest,
344         uint256 source,
345         uint256 length
346     )
347         internal
348         pure
349     {
350         if (length < 32) {
351             // Handle a partial word by reading destination and masking
352             // off the bits we are interested in.
353             // This correctly handles overlap, zero lengths and source == dest
354             assembly {
355                 let mask := sub(exp(256, sub(32, length)), 1)
356                 let s := and(mload(source), not(mask))
357                 let d := and(mload(dest), mask)
358                 mstore(dest, or(s, d))
359             }
360         } else {
361             // Skip the O(length) loop when source == dest.
362             if (source == dest) {
363                 return;
364             }
365 
366             // For large copies we copy whole words at a time. The final
367             // word is aligned to the end of the range (instead of after the
368             // previous) to handle partial words. So a copy will look like this:
369             //
370             //  ####
371             //      ####
372             //          ####
373             //            ####
374             //
375             // We handle overlap in the source and destination range by
376             // changing the copying direction. This prevents us from
377             // overwriting parts of source that we still need to copy.
378             //
379             // This correctly handles source == dest
380             //
381             if (source > dest) {
382                 assembly {
383                     // We subtract 32 from `sEnd` and `dEnd` because it
384                     // is easier to compare with in the loop, and these
385                     // are also the addresses we need for copying the
386                     // last bytes.
387                     length := sub(length, 32)
388                     let sEnd := add(source, length)
389                     let dEnd := add(dest, length)
390 
391                     // Remember the last 32 bytes of source
392                     // This needs to be done here and not after the loop
393                     // because we may have overwritten the last bytes in
394                     // source already due to overlap.
395                     let last := mload(sEnd)
396 
397                     // Copy whole words front to back
398                     // Note: the first check is always true,
399                     // this could have been a do-while loop.
400                     // solhint-disable-next-line no-empty-blocks
401                     for {} lt(source, sEnd) {} {
402                         mstore(dest, mload(source))
403                         source := add(source, 32)
404                         dest := add(dest, 32)
405                     }
406                     
407                     // Write the last 32 bytes
408                     mstore(dEnd, last)
409                 }
410             } else {
411                 assembly {
412                     // We subtract 32 from `sEnd` and `dEnd` because those
413                     // are the starting points when copying a word at the end.
414                     length := sub(length, 32)
415                     let sEnd := add(source, length)
416                     let dEnd := add(dest, length)
417 
418                     // Remember the first 32 bytes of source
419                     // This needs to be done here and not after the loop
420                     // because we may have overwritten the first bytes in
421                     // source already due to overlap.
422                     let first := mload(source)
423 
424                     // Copy whole words back to front
425                     // We use a signed comparisson here to allow dEnd to become
426                     // negative (happens when source and dest < 32). Valid
427                     // addresses in local memory will never be larger than
428                     // 2**255, so they can be safely re-interpreted as signed.
429                     // Note: the first check is always true,
430                     // this could have been a do-while loop.
431                     // solhint-disable-next-line no-empty-blocks
432                     for {} slt(dest, dEnd) {} {
433                         mstore(dEnd, mload(sEnd))
434                         sEnd := sub(sEnd, 32)
435                         dEnd := sub(dEnd, 32)
436                     }
437                     
438                     // Write the first 32 bytes
439                     mstore(dest, first)
440                 }
441             }
442         }
443     }
444 
445     /// @dev Returns a slices from a byte array.
446     /// @param b The byte array to take a slice from.
447     /// @param from The starting index for the slice (inclusive).
448     /// @param to The final index for the slice (exclusive).
449     /// @return result The slice containing bytes at indices [from, to)
450     function slice(
451         bytes memory b,
452         uint256 from,
453         uint256 to
454     )
455         internal
456         pure
457         returns (bytes memory result)
458     {
459         require(
460             from <= to,
461             "FROM_LESS_THAN_TO_REQUIRED"
462         );
463         require(
464             to < b.length,
465             "TO_LESS_THAN_LENGTH_REQUIRED"
466         );
467         
468         // Create a new bytes structure and copy contents
469         result = new bytes(to - from);
470         memCopy(
471             result.contentAddress(),
472             b.contentAddress() + from,
473             result.length
474         );
475         return result;
476     }
477     
478     /// @dev Returns a slice from a byte array without preserving the input.
479     /// @param b The byte array to take a slice from. Will be destroyed in the process.
480     /// @param from The starting index for the slice (inclusive).
481     /// @param to The final index for the slice (exclusive).
482     /// @return result The slice containing bytes at indices [from, to)
483     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
484     function sliceDestructive(
485         bytes memory b,
486         uint256 from,
487         uint256 to
488     )
489         internal
490         pure
491         returns (bytes memory result)
492     {
493         require(
494             from <= to,
495             "FROM_LESS_THAN_TO_REQUIRED"
496         );
497         require(
498             to < b.length,
499             "TO_LESS_THAN_LENGTH_REQUIRED"
500         );
501         
502         // Create a new bytes structure around [from, to) in-place.
503         assembly {
504             result := add(b, from)
505             mstore(result, sub(to, from))
506         }
507         return result;
508     }
509 
510     /// @dev Pops the last byte off of a byte array by modifying its length.
511     /// @param b Byte array that will be modified.
512     /// @return The byte that was popped off.
513     function popLastByte(bytes memory b)
514         internal
515         pure
516         returns (bytes1 result)
517     {
518         require(
519             b.length > 0,
520             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
521         );
522 
523         // Store last byte.
524         result = b[b.length - 1];
525 
526         assembly {
527             // Decrement length of byte array.
528             let newLen := sub(mload(b), 1)
529             mstore(b, newLen)
530         }
531         return result;
532     }
533 
534     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
535     /// @param b Byte array that will be modified.
536     /// @return The 20 byte address that was popped off.
537     function popLast20Bytes(bytes memory b)
538         internal
539         pure
540         returns (address result)
541     {
542         require(
543             b.length >= 20,
544             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
545         );
546 
547         // Store last 20 bytes.
548         result = readAddress(b, b.length - 20);
549 
550         assembly {
551             // Subtract 20 from byte array length.
552             let newLen := sub(mload(b), 20)
553             mstore(b, newLen)
554         }
555         return result;
556     }
557 
558     /// @dev Tests equality of two byte arrays.
559     /// @param lhs First byte array to compare.
560     /// @param rhs Second byte array to compare.
561     /// @return True if arrays are the same. False otherwise.
562     function equals(
563         bytes memory lhs,
564         bytes memory rhs
565     )
566         internal
567         pure
568         returns (bool equal)
569     {
570         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
571         // We early exit on unequal lengths, but keccak would also correctly
572         // handle this.
573         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
574     }
575 
576     /// @dev Reads an address from a position in a byte array.
577     /// @param b Byte array containing an address.
578     /// @param index Index in byte array of address.
579     /// @return address from byte array.
580     function readAddress(
581         bytes memory b,
582         uint256 index
583     )
584         internal
585         pure
586         returns (address result)
587     {
588         require(
589             b.length >= index + 20,  // 20 is length of address
590             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
591         );
592 
593         // Add offset to index:
594         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
595         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
596         index += 20;
597 
598         // Read address from array memory
599         assembly {
600             // 1. Add index to address of bytes array
601             // 2. Load 32-byte word from memory
602             // 3. Apply 20-byte mask to obtain address
603             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
604         }
605         return result;
606     }
607 
608     /// @dev Writes an address into a specific position in a byte array.
609     /// @param b Byte array to insert address into.
610     /// @param index Index in byte array of address.
611     /// @param input Address to put into byte array.
612     function writeAddress(
613         bytes memory b,
614         uint256 index,
615         address input
616     )
617         internal
618         pure
619     {
620         require(
621             b.length >= index + 20,  // 20 is length of address
622             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
623         );
624 
625         // Add offset to index:
626         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
627         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
628         index += 20;
629 
630         // Store address into array memory
631         assembly {
632             // The address occupies 20 bytes and mstore stores 32 bytes.
633             // First fetch the 32-byte word where we'll be storing the address, then
634             // apply a mask so we have only the bytes in the word that the address will not occupy.
635             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
636 
637             // 1. Add index to address of bytes array
638             // 2. Load 32-byte word from memory
639             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
640             let neighbors := and(
641                 mload(add(b, index)),
642                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
643             )
644             
645             // Make sure input address is clean.
646             // (Solidity does not guarantee this)
647             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
648 
649             // Store the neighbors and address into memory
650             mstore(add(b, index), xor(input, neighbors))
651         }
652     }
653 
654     /// @dev Reads a bytes32 value from a position in a byte array.
655     /// @param b Byte array containing a bytes32 value.
656     /// @param index Index in byte array of bytes32 value.
657     /// @return bytes32 value from byte array.
658     function readBytes32(
659         bytes memory b,
660         uint256 index
661     )
662         internal
663         pure
664         returns (bytes32 result)
665     {
666         require(
667             b.length >= index + 32,
668             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
669         );
670 
671         // Arrays are prefixed by a 256 bit length parameter
672         index += 32;
673 
674         // Read the bytes32 from array memory
675         assembly {
676             result := mload(add(b, index))
677         }
678         return result;
679     }
680 
681     /// @dev Writes a bytes32 into a specific position in a byte array.
682     /// @param b Byte array to insert <input> into.
683     /// @param index Index in byte array of <input>.
684     /// @param input bytes32 to put into byte array.
685     function writeBytes32(
686         bytes memory b,
687         uint256 index,
688         bytes32 input
689     )
690         internal
691         pure
692     {
693         require(
694             b.length >= index + 32,
695             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
696         );
697 
698         // Arrays are prefixed by a 256 bit length parameter
699         index += 32;
700 
701         // Read the bytes32 from array memory
702         assembly {
703             mstore(add(b, index), input)
704         }
705     }
706 
707     /// @dev Reads a uint256 value from a position in a byte array.
708     /// @param b Byte array containing a uint256 value.
709     /// @param index Index in byte array of uint256 value.
710     /// @return uint256 value from byte array.
711     function readUint256(
712         bytes memory b,
713         uint256 index
714     )
715         internal
716         pure
717         returns (uint256 result)
718     {
719         result = uint256(readBytes32(b, index));
720         return result;
721     }
722 
723     /// @dev Writes a uint256 into a specific position in a byte array.
724     /// @param b Byte array to insert <input> into.
725     /// @param index Index in byte array of <input>.
726     /// @param input uint256 to put into byte array.
727     function writeUint256(
728         bytes memory b,
729         uint256 index,
730         uint256 input
731     )
732         internal
733         pure
734     {
735         writeBytes32(b, index, bytes32(input));
736     }
737 
738     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
739     /// @param b Byte array containing a bytes4 value.
740     /// @param index Index in byte array of bytes4 value.
741     /// @return bytes4 value from byte array.
742     function readBytes4(
743         bytes memory b,
744         uint256 index
745     )
746         internal
747         pure
748         returns (bytes4 result)
749     {
750         require(
751             b.length >= index + 4,
752             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
753         );
754 
755         // Arrays are prefixed by a 32 byte length field
756         index += 32;
757 
758         // Read the bytes4 from array memory
759         assembly {
760             result := mload(add(b, index))
761             // Solidity does not require us to clean the trailing bytes.
762             // We do it anyway
763             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
764         }
765         return result;
766     }
767 
768     function readBytes2(
769         bytes memory b,
770         uint256 index
771     )
772         internal
773         pure
774         returns (bytes2 result)
775     {
776         require(
777             b.length >= index + 2,
778             "GREATER_OR_EQUAL_TO_2_LENGTH_REQUIRED"
779         );
780 
781         // Arrays are prefixed by a 32 byte length field
782         index += 32;
783 
784         // Read the bytes4 from array memory
785         assembly {
786             result := mload(add(b, index))
787             // Solidity does not require us to clean the trailing bytes.
788             // We do it anyway
789             result := and(result, 0xFFFF000000000000000000000000000000000000000000000000000000000000)
790         }
791         return result;
792     }
793 
794     /// @dev Reads nested bytes from a specific position.
795     /// @dev NOTE: the returned value overlaps with the input value.
796     ///            Both should be treated as immutable.
797     /// @param b Byte array containing nested bytes.
798     /// @param index Index of nested bytes.
799     /// @return result Nested bytes.
800     function readBytesWithLength(
801         bytes memory b,
802         uint256 index
803     )
804         internal
805         pure
806         returns (bytes memory result)
807     {
808         // Read length of nested bytes
809         uint256 nestedBytesLength = readUint256(b, index);
810         index += 32;
811 
812         // Assert length of <b> is valid, given
813         // length of nested bytes
814         require(
815             b.length >= index + nestedBytesLength,
816             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
817         );
818         
819         // Return a pointer to the byte array as it exists inside `b`
820         assembly {
821             result := add(b, index)
822         }
823         return result;
824     }
825 
826     /// @dev Inserts bytes at a specific position in a byte array.
827     /// @param b Byte array to insert <input> into.
828     /// @param index Index in byte array of <input>.
829     /// @param input bytes to insert.
830     function writeBytesWithLength(
831         bytes memory b,
832         uint256 index,
833         bytes memory input
834     )
835         internal
836         pure
837     {
838         // Assert length of <b> is valid, given
839         // length of input
840         require(
841             b.length >= index + 32 + input.length,  // 32 bytes to store length
842             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
843         );
844 
845         // Copy <input> into <b>
846         memCopy(
847             b.contentAddress() + index,
848             input.rawAddress(), // includes length of <input>
849             input.length + 32   // +32 bytes to store <input> length
850         );
851     }
852 
853     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
854     /// @param dest Byte array that will be overwritten with source bytes.
855     /// @param source Byte array to copy onto dest bytes.
856     function deepCopyBytes(
857         bytes memory dest,
858         bytes memory source
859     )
860         internal
861         pure
862     {
863         uint256 sourceLen = source.length;
864         // Dest length must be >= source length, or some bytes would not be copied.
865         require(
866             dest.length >= sourceLen,
867             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
868         );
869         memCopy(
870             dest.contentAddress(),
871             source.contentAddress(),
872             sourceLen
873         );
874     }
875 }
876 
877 contract LibDecoder {
878     using LibBytes for bytes;
879 
880     function decodeFillOrder(bytes memory data) internal pure returns(LibOrder.Order memory order, uint256 takerFillAmount, bytes memory mmSignature) {
881         require(
882             data.length > 800,
883             "LENGTH_LESS_800"
884         );
885 
886         // compare method_id
887         // 0x64a3bc15 is fillOrKillOrder's method id.
888         require(
889             data.readBytes4(0) == 0x64a3bc15,
890             "WRONG_METHOD_ID"
891         );
892         
893         bytes memory dataSlice;
894         assembly {
895             dataSlice := add(data, 4)
896         }
897         //return (order, takerFillAmount, data);
898         return abi.decode(dataSlice, (LibOrder.Order, uint256, bytes));
899 
900     }
901 
902     function decodeMmSignatureWithoutSign(bytes memory signature) internal pure returns(address user, uint16 feeFactor) {
903         require(
904             signature.length == 87 || signature.length == 88,
905             "LENGTH_87_REQUIRED"
906         );
907 
908         user = signature.readAddress(65);
909         feeFactor = uint16(signature.readBytes2(85));
910         
911         require(
912             feeFactor < 10000,
913             "FEE_FACTOR_MORE_THEN_10000"
914         );
915 
916         return (user, feeFactor);
917     }
918 
919     function decodeMmSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address user, uint16 feeFactor) {
920         (user, feeFactor) = decodeMmSignatureWithoutSign(signature);
921 
922         v = uint8(signature[0]);
923         r = signature.readBytes32(1);
924         s = signature.readBytes32(33);
925 
926         return (v, r, s, user, feeFactor);
927     }
928 
929     function decodeUserSignatureWithoutSign(bytes memory signature) internal pure returns(address receiver) {
930         require(
931             signature.length == 85 || signature.length == 86,
932             "LENGTH_85_REQUIRED"
933         );
934         receiver = signature.readAddress(65);
935 
936         return receiver;
937     }
938 
939     function decodeUserSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address receiver) {
940         receiver = decodeUserSignatureWithoutSign(signature);
941 
942         v = uint8(signature[0]);
943         r = signature.readBytes32(1);
944         s = signature.readBytes32(33);
945 
946         return (v, r, s, receiver);
947     }
948 
949     function decodeERC20Asset(bytes memory assetData) internal pure returns(address) {
950         require(
951             assetData.length == 36,
952             "LENGTH_65_REQUIRED"
953         );
954 
955         return assetData.readAddress(16);
956     }
957 }
958 
959 /**
960  * Version of ERC20 with no return values for `transfer` and `transferFrom
961  * https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
962  */
963 interface IERC20NonStandard {
964     function transfer(address to, uint256 value) external;
965 
966     function approve(address spender, uint256 value) external;
967 
968     function transferFrom(address from, address to, uint256 value) external;
969 
970     function totalSupply() external view returns (uint256);
971 
972     function balanceOf(address who) external view returns (uint256);
973 
974     function allowance(address owner, address spender) external view returns (uint256);
975 
976     event Transfer(address indexed from, address indexed to, uint256 value);
977 
978     event Approval(address indexed owner, address indexed spender, uint256 value);
979 }
980 
981 contract SafeToken {
982     function doApprove(address token, address spender, uint256 amount) internal {
983         bool result;
984 
985         IERC20NonStandard(token).approve(spender, amount);
986 
987         assembly {
988             switch returndatasize()
989                 case 0 {                      // This is a non-standard ERC-20
990                     result := not(0)          // set result to true
991                 }
992                 case 32 {                     // This is a complaint ERC-20
993                     returndatacopy(0, 0, 32)
994                     result := mload(0)        // Set `result = returndata` of external call
995                 }
996                 default {                     // This is an excessively non-compliant ERC-20, revert.
997                     revert(0, 0)
998                 }
999         }
1000 
1001         require(
1002             result,
1003             "APPROVE_FAILED"
1004         );
1005     }
1006 
1007     function doTransferFrom(address token, address from, address to, uint256 amount) internal {
1008         bool result;
1009 
1010         IERC20NonStandard(token).transferFrom(from, to, amount);
1011 
1012         assembly {
1013             switch returndatasize()
1014                 case 0 {                      // This is a non-standard ERC-20
1015                     result := not(0)          // set result to true
1016                 }
1017                 case 32 {                     // This is a complaint ERC-20
1018                     returndatacopy(0, 0, 32)
1019                     result := mload(0)        // Set `result = returndata` of external call
1020                 }
1021                 default {                     // This is an excessively non-compliant ERC-20, revert.
1022                     revert(0, 0)
1023                 }
1024         }
1025 
1026         require(
1027             result,
1028             "TRANSFER_FROM_FAILED"
1029         );
1030     }
1031 }
1032 
1033 
1034 contract MarketMakerProxy is 
1035     Ownable,
1036     LibDecoder,
1037     SafeToken
1038 {
1039     string public version = "0.0.4";
1040 
1041     uint256 constant MAX_UINT = 2**256 - 1;
1042     address internal SIGNER;
1043     
1044     constructor () public {
1045         owner = msg.sender;
1046         operator = msg.sender;
1047     }
1048 
1049     // Manage
1050     function setSigner(address _signer) public onlyOperator {
1051         SIGNER = _signer;
1052     }
1053 
1054     function setAllowance(address[] memory token_addrs, address spender) public onlyOperator {
1055         for (uint i = 0; i < token_addrs.length; i++) {
1056             address token = token_addrs[i];
1057             doApprove(token, spender, MAX_UINT);
1058             doApprove(token, address(this), MAX_UINT);
1059         }
1060     }
1061 
1062     function closeAllowance(address[] memory token_addrs, address spender) public onlyOperator {
1063         for (uint i = 0; i < token_addrs.length; i++) {
1064             address token = token_addrs[i];
1065             doApprove(token, spender, 0);
1066             doApprove(token, address(this), 0);
1067         }
1068     }
1069 
1070     function withdraw(address token, address to, uint256 amount) public onlyOperator {
1071         doTransferFrom(token, address(this), to , amount);
1072     }
1073 
1074     function isValidSignature(bytes32 orderHash, bytes memory signature) public view returns (bytes32) {
1075         require(
1076             SIGNER == ecrecoverAddress(orderHash, signature),
1077             "INVALID_SIGNATURE"
1078         );
1079         return keccak256("isValidWalletSignature(bytes32,address,bytes)");
1080     }
1081 
1082     function ecrecoverAddress(bytes32 orderHash, bytes memory signature) internal pure returns (address) {
1083         (uint8 v, bytes32 r, bytes32 s, address user, uint16 feeFactor) = decodeMmSignature(signature);
1084         
1085         return ecrecover(
1086             keccak256(
1087                 abi.encodePacked(
1088                     "\x19Ethereum Signed Message:\n54",
1089                     orderHash,
1090                     user,
1091                     feeFactor
1092                 )),
1093             v, r, s
1094         );
1095     }
1096 }