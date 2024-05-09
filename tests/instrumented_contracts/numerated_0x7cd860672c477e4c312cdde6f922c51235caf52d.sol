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
55 contract IWeth {
56     function deposit() public payable;
57     function withdraw(uint256 amount) public;
58 }
59 
60 contract LibWeth 
61 {
62     function convertETHtoWeth(address wethAddr, uint256 amount) internal {
63         IWeth weth = IWeth(wethAddr);
64         weth.deposit.value(amount)();
65     }
66 
67     function convertWethtoETH(address wethAddr, uint256 amount) internal {
68         IWeth weth = IWeth(wethAddr);
69         weth.withdraw(amount);
70     }
71 }
72 
73 contract ITokenlonExchange {
74     function transactions(bytes32 executeTxHash) external returns (address);
75 }
76 
77 // File: contract-utils/Zerox/LibEIP712.sol
78 
79 /*
80 
81   Copyright 2018 ZeroEx Intl.
82 
83   Licensed under the Apache License, Version 2.0 (the "License");
84   you may not use this file except in compliance with the License.
85   You may obtain a copy of the License at
86 
87     http://www.apache.org/licenses/LICENSE-2.0
88 
89   Unless required by applicable law or agreed to in writing, software
90   distributed under the License is distributed on an "AS IS" BASIS,
91   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
92   See the License for the specific language governing permissions and
93   limitations under the License.
94 
95 */
96 
97 contract LibEIP712 {
98 
99     // EIP191 header for EIP712 prefix
100     string constant internal EIP191_HEADER = "\x19\x01";
101 
102     // EIP712 Domain Name value
103     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
104 
105     // EIP712 Domain Version value
106     string constant internal EIP712_DOMAIN_VERSION = "2";
107 
108     // Hash of the EIP712 Domain Separator Schema
109     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
110         "EIP712Domain(",
111         "string name,",
112         "string version,",
113         "address verifyingContract",
114         ")"
115     ));
116 
117     // Hash of the EIP712 Domain Separator data
118     // solhint-disable-next-line var-name-mixedcase
119     bytes32 public EIP712_DOMAIN_HASH;
120 
121     constructor ()
122         public
123     {
124         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
125             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
126             keccak256(bytes(EIP712_DOMAIN_NAME)),
127             keccak256(bytes(EIP712_DOMAIN_VERSION)),
128             bytes12(0),
129             address(this)
130         ));
131     }
132 
133     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
134     /// @param hashStruct The EIP712 hash struct.
135     /// @return EIP712 hash applied to this EIP712 Domain.
136     function hashEIP712Message(bytes32 hashStruct)
137         internal
138         view
139         returns (bytes32 result)
140     {
141         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
142 
143         // Assembly for more efficient computing:
144         // keccak256(abi.encodePacked(
145         //     EIP191_HEADER,
146         //     EIP712_DOMAIN_HASH,
147         //     hashStruct    
148         // ));
149 
150         assembly {
151             // Load free memory pointer
152             let memPtr := mload(64)
153 
154             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
155             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
156             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
157 
158             // Compute hash
159             result := keccak256(memPtr, 66)
160         }
161         return result;
162     }
163 }
164 
165 // File: contract-utils/Zerox/LibOrder.sol
166 
167 /*
168 
169   Copyright 2018 ZeroEx Intl.
170 
171   Licensed under the Apache License, Version 2.0 (the "License");
172   you may not use this file except in compliance with the License.
173   You may obtain a copy of the License at
174 
175     http://www.apache.org/licenses/LICENSE-2.0
176 
177   Unless required by applicable law or agreed to in writing, software
178   distributed under the License is distributed on an "AS IS" BASIS,
179   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
180   See the License for the specific language governing permissions and
181   limitations under the License.
182 
183 */
184 
185 contract LibOrder is
186     LibEIP712
187 {
188     // Hash for the EIP712 Order Schema
189     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
190         "Order(",
191         "address makerAddress,",
192         "address takerAddress,",
193         "address feeRecipientAddress,",
194         "address senderAddress,",
195         "uint256 makerAssetAmount,",
196         "uint256 takerAssetAmount,",
197         "uint256 makerFee,",
198         "uint256 takerFee,",
199         "uint256 expirationTimeSeconds,",
200         "uint256 salt,",
201         "bytes makerAssetData,",
202         "bytes takerAssetData",
203         ")"
204     ));
205 
206     // A valid order remains fillable until it is expired, fully filled, or cancelled.
207     // An order's state is unaffected by external factors, like account balances.
208     enum OrderStatus {
209         INVALID,                     // Default value
210         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
211         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
212         FILLABLE,                    // Order is fillable
213         EXPIRED,                     // Order has already expired
214         FULLY_FILLED,                // Order is fully filled
215         CANCELLED                    // Order has been cancelled
216     }
217 
218     // solhint-disable max-line-length
219     struct Order {
220         address makerAddress;           // Address that created the order.      
221         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
222         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
223         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
224         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
225         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
226         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
227         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
228         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
229         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
230         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
231         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
232     }
233     // solhint-enable max-line-length
234 
235     struct OrderInfo {
236         uint8 orderStatus;                    // Status that describes order's validity and fillability.
237         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
238         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
239     }
240 
241     /// @dev Calculates Keccak-256 hash of the order.
242     /// @param order The order structure.
243     /// @return Keccak-256 EIP712 hash of the order.
244     function getOrderHash(Order memory order)
245         internal
246         view
247         returns (bytes32 orderHash)
248     {
249         orderHash = hashEIP712Message(hashOrder(order));
250         return orderHash;
251     }
252 
253     /// @dev Calculates EIP712 hash of the order.
254     /// @param order The order structure.
255     /// @return EIP712 hash of the order.
256     function hashOrder(Order memory order)
257         internal
258         pure
259         returns (bytes32 result)
260     {
261         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
262         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
263         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
264 
265         // Assembly for more efficiently computing:
266         // keccak256(abi.encodePacked(
267         //     EIP712_ORDER_SCHEMA_HASH,
268         //     bytes32(order.makerAddress),
269         //     bytes32(order.takerAddress),
270         //     bytes32(order.feeRecipientAddress),
271         //     bytes32(order.senderAddress),
272         //     order.makerAssetAmount,
273         //     order.takerAssetAmount,
274         //     order.makerFee,
275         //     order.takerFee,
276         //     order.expirationTimeSeconds,
277         //     order.salt,
278         //     keccak256(order.makerAssetData),
279         //     keccak256(order.takerAssetData)
280         // ));
281 
282         assembly {
283             // Calculate memory addresses that will be swapped out before hashing
284             let pos1 := sub(order, 32)
285             let pos2 := add(order, 320)
286             let pos3 := add(order, 352)
287 
288             // Backup
289             let temp1 := mload(pos1)
290             let temp2 := mload(pos2)
291             let temp3 := mload(pos3)
292             
293             // Hash in place
294             mstore(pos1, schemaHash)
295             mstore(pos2, makerAssetDataHash)
296             mstore(pos3, takerAssetDataHash)
297             result := keccak256(pos1, 416)
298             
299             // Restore
300             mstore(pos1, temp1)
301             mstore(pos2, temp2)
302             mstore(pos3, temp3)
303         }
304         return result;
305     }
306 }
307 
308 /*
309 
310   Copyright 2018 ZeroEx Intl.
311 
312   Licensed under the Apache License, Version 2.0 (the "License");
313   you may not use this file except in compliance with the License.
314   You may obtain a copy of the License at
315 
316     http://www.apache.org/licenses/LICENSE-2.0
317 
318   Unless required by applicable law or agreed to in writing, software
319   distributed under the License is distributed on an "AS IS" BASIS,
320   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
321   See the License for the specific language governing permissions and
322   limitations under the License.
323 
324 */
325 
326 library LibBytes {
327 
328     using LibBytes for bytes;
329 
330     /// @dev Gets the memory address for a byte array.
331     /// @param input Byte array to lookup.
332     /// @return memoryAddress Memory address of byte array. This
333     ///         points to the header of the byte array which contains
334     ///         the length.
335     function rawAddress(bytes memory input)
336         internal
337         pure
338         returns (uint256 memoryAddress)
339     {
340         assembly {
341             memoryAddress := input
342         }
343         return memoryAddress;
344     }
345     
346     /// @dev Gets the memory address for the contents of a byte array.
347     /// @param input Byte array to lookup.
348     /// @return memoryAddress Memory address of the contents of the byte array.
349     function contentAddress(bytes memory input)
350         internal
351         pure
352         returns (uint256 memoryAddress)
353     {
354         assembly {
355             memoryAddress := add(input, 32)
356         }
357         return memoryAddress;
358     }
359 
360     /// @dev Copies `length` bytes from memory location `source` to `dest`.
361     /// @param dest memory address to copy bytes to.
362     /// @param source memory address to copy bytes from.
363     /// @param length number of bytes to copy.
364     function memCopy(
365         uint256 dest,
366         uint256 source,
367         uint256 length
368     )
369         internal
370         pure
371     {
372         if (length < 32) {
373             // Handle a partial word by reading destination and masking
374             // off the bits we are interested in.
375             // This correctly handles overlap, zero lengths and source == dest
376             assembly {
377                 let mask := sub(exp(256, sub(32, length)), 1)
378                 let s := and(mload(source), not(mask))
379                 let d := and(mload(dest), mask)
380                 mstore(dest, or(s, d))
381             }
382         } else {
383             // Skip the O(length) loop when source == dest.
384             if (source == dest) {
385                 return;
386             }
387 
388             // For large copies we copy whole words at a time. The final
389             // word is aligned to the end of the range (instead of after the
390             // previous) to handle partial words. So a copy will look like this:
391             //
392             //  ####
393             //      ####
394             //          ####
395             //            ####
396             //
397             // We handle overlap in the source and destination range by
398             // changing the copying direction. This prevents us from
399             // overwriting parts of source that we still need to copy.
400             //
401             // This correctly handles source == dest
402             //
403             if (source > dest) {
404                 assembly {
405                     // We subtract 32 from `sEnd` and `dEnd` because it
406                     // is easier to compare with in the loop, and these
407                     // are also the addresses we need for copying the
408                     // last bytes.
409                     length := sub(length, 32)
410                     let sEnd := add(source, length)
411                     let dEnd := add(dest, length)
412 
413                     // Remember the last 32 bytes of source
414                     // This needs to be done here and not after the loop
415                     // because we may have overwritten the last bytes in
416                     // source already due to overlap.
417                     let last := mload(sEnd)
418 
419                     // Copy whole words front to back
420                     // Note: the first check is always true,
421                     // this could have been a do-while loop.
422                     // solhint-disable-next-line no-empty-blocks
423                     for {} lt(source, sEnd) {} {
424                         mstore(dest, mload(source))
425                         source := add(source, 32)
426                         dest := add(dest, 32)
427                     }
428                     
429                     // Write the last 32 bytes
430                     mstore(dEnd, last)
431                 }
432             } else {
433                 assembly {
434                     // We subtract 32 from `sEnd` and `dEnd` because those
435                     // are the starting points when copying a word at the end.
436                     length := sub(length, 32)
437                     let sEnd := add(source, length)
438                     let dEnd := add(dest, length)
439 
440                     // Remember the first 32 bytes of source
441                     // This needs to be done here and not after the loop
442                     // because we may have overwritten the first bytes in
443                     // source already due to overlap.
444                     let first := mload(source)
445 
446                     // Copy whole words back to front
447                     // We use a signed comparisson here to allow dEnd to become
448                     // negative (happens when source and dest < 32). Valid
449                     // addresses in local memory will never be larger than
450                     // 2**255, so they can be safely re-interpreted as signed.
451                     // Note: the first check is always true,
452                     // this could have been a do-while loop.
453                     // solhint-disable-next-line no-empty-blocks
454                     for {} slt(dest, dEnd) {} {
455                         mstore(dEnd, mload(sEnd))
456                         sEnd := sub(sEnd, 32)
457                         dEnd := sub(dEnd, 32)
458                     }
459                     
460                     // Write the first 32 bytes
461                     mstore(dest, first)
462                 }
463             }
464         }
465     }
466 
467     /// @dev Returns a slices from a byte array.
468     /// @param b The byte array to take a slice from.
469     /// @param from The starting index for the slice (inclusive).
470     /// @param to The final index for the slice (exclusive).
471     /// @return result The slice containing bytes at indices [from, to)
472     function slice(
473         bytes memory b,
474         uint256 from,
475         uint256 to
476     )
477         internal
478         pure
479         returns (bytes memory result)
480     {
481         require(
482             from <= to,
483             "FROM_LESS_THAN_TO_REQUIRED"
484         );
485         require(
486             to < b.length,
487             "TO_LESS_THAN_LENGTH_REQUIRED"
488         );
489         
490         // Create a new bytes structure and copy contents
491         result = new bytes(to - from);
492         memCopy(
493             result.contentAddress(),
494             b.contentAddress() + from,
495             result.length
496         );
497         return result;
498     }
499     
500     /// @dev Returns a slice from a byte array without preserving the input.
501     /// @param b The byte array to take a slice from. Will be destroyed in the process.
502     /// @param from The starting index for the slice (inclusive).
503     /// @param to The final index for the slice (exclusive).
504     /// @return result The slice containing bytes at indices [from, to)
505     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
506     function sliceDestructive(
507         bytes memory b,
508         uint256 from,
509         uint256 to
510     )
511         internal
512         pure
513         returns (bytes memory result)
514     {
515         require(
516             from <= to,
517             "FROM_LESS_THAN_TO_REQUIRED"
518         );
519         require(
520             to < b.length,
521             "TO_LESS_THAN_LENGTH_REQUIRED"
522         );
523         
524         // Create a new bytes structure around [from, to) in-place.
525         assembly {
526             result := add(b, from)
527             mstore(result, sub(to, from))
528         }
529         return result;
530     }
531 
532     /// @dev Pops the last byte off of a byte array by modifying its length.
533     /// @param b Byte array that will be modified.
534     /// @return The byte that was popped off.
535     function popLastByte(bytes memory b)
536         internal
537         pure
538         returns (bytes1 result)
539     {
540         require(
541             b.length > 0,
542             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
543         );
544 
545         // Store last byte.
546         result = b[b.length - 1];
547 
548         assembly {
549             // Decrement length of byte array.
550             let newLen := sub(mload(b), 1)
551             mstore(b, newLen)
552         }
553         return result;
554     }
555 
556     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
557     /// @param b Byte array that will be modified.
558     /// @return The 20 byte address that was popped off.
559     function popLast20Bytes(bytes memory b)
560         internal
561         pure
562         returns (address result)
563     {
564         require(
565             b.length >= 20,
566             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
567         );
568 
569         // Store last 20 bytes.
570         result = readAddress(b, b.length - 20);
571 
572         assembly {
573             // Subtract 20 from byte array length.
574             let newLen := sub(mload(b), 20)
575             mstore(b, newLen)
576         }
577         return result;
578     }
579 
580     /// @dev Tests equality of two byte arrays.
581     /// @param lhs First byte array to compare.
582     /// @param rhs Second byte array to compare.
583     /// @return True if arrays are the same. False otherwise.
584     function equals(
585         bytes memory lhs,
586         bytes memory rhs
587     )
588         internal
589         pure
590         returns (bool equal)
591     {
592         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
593         // We early exit on unequal lengths, but keccak would also correctly
594         // handle this.
595         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
596     }
597 
598     /// @dev Reads an address from a position in a byte array.
599     /// @param b Byte array containing an address.
600     /// @param index Index in byte array of address.
601     /// @return address from byte array.
602     function readAddress(
603         bytes memory b,
604         uint256 index
605     )
606         internal
607         pure
608         returns (address result)
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
620         // Read address from array memory
621         assembly {
622             // 1. Add index to address of bytes array
623             // 2. Load 32-byte word from memory
624             // 3. Apply 20-byte mask to obtain address
625             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
626         }
627         return result;
628     }
629 
630     /// @dev Writes an address into a specific position in a byte array.
631     /// @param b Byte array to insert address into.
632     /// @param index Index in byte array of address.
633     /// @param input Address to put into byte array.
634     function writeAddress(
635         bytes memory b,
636         uint256 index,
637         address input
638     )
639         internal
640         pure
641     {
642         require(
643             b.length >= index + 20,  // 20 is length of address
644             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
645         );
646 
647         // Add offset to index:
648         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
649         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
650         index += 20;
651 
652         // Store address into array memory
653         assembly {
654             // The address occupies 20 bytes and mstore stores 32 bytes.
655             // First fetch the 32-byte word where we'll be storing the address, then
656             // apply a mask so we have only the bytes in the word that the address will not occupy.
657             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
658 
659             // 1. Add index to address of bytes array
660             // 2. Load 32-byte word from memory
661             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
662             let neighbors := and(
663                 mload(add(b, index)),
664                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
665             )
666             
667             // Make sure input address is clean.
668             // (Solidity does not guarantee this)
669             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
670 
671             // Store the neighbors and address into memory
672             mstore(add(b, index), xor(input, neighbors))
673         }
674     }
675 
676     /// @dev Reads a bytes32 value from a position in a byte array.
677     /// @param b Byte array containing a bytes32 value.
678     /// @param index Index in byte array of bytes32 value.
679     /// @return bytes32 value from byte array.
680     function readBytes32(
681         bytes memory b,
682         uint256 index
683     )
684         internal
685         pure
686         returns (bytes32 result)
687     {
688         require(
689             b.length >= index + 32,
690             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
691         );
692 
693         // Arrays are prefixed by a 256 bit length parameter
694         index += 32;
695 
696         // Read the bytes32 from array memory
697         assembly {
698             result := mload(add(b, index))
699         }
700         return result;
701     }
702 
703     /// @dev Writes a bytes32 into a specific position in a byte array.
704     /// @param b Byte array to insert <input> into.
705     /// @param index Index in byte array of <input>.
706     /// @param input bytes32 to put into byte array.
707     function writeBytes32(
708         bytes memory b,
709         uint256 index,
710         bytes32 input
711     )
712         internal
713         pure
714     {
715         require(
716             b.length >= index + 32,
717             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
718         );
719 
720         // Arrays are prefixed by a 256 bit length parameter
721         index += 32;
722 
723         // Read the bytes32 from array memory
724         assembly {
725             mstore(add(b, index), input)
726         }
727     }
728 
729     /// @dev Reads a uint256 value from a position in a byte array.
730     /// @param b Byte array containing a uint256 value.
731     /// @param index Index in byte array of uint256 value.
732     /// @return uint256 value from byte array.
733     function readUint256(
734         bytes memory b,
735         uint256 index
736     )
737         internal
738         pure
739         returns (uint256 result)
740     {
741         result = uint256(readBytes32(b, index));
742         return result;
743     }
744 
745     /// @dev Writes a uint256 into a specific position in a byte array.
746     /// @param b Byte array to insert <input> into.
747     /// @param index Index in byte array of <input>.
748     /// @param input uint256 to put into byte array.
749     function writeUint256(
750         bytes memory b,
751         uint256 index,
752         uint256 input
753     )
754         internal
755         pure
756     {
757         writeBytes32(b, index, bytes32(input));
758     }
759 
760     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
761     /// @param b Byte array containing a bytes4 value.
762     /// @param index Index in byte array of bytes4 value.
763     /// @return bytes4 value from byte array.
764     function readBytes4(
765         bytes memory b,
766         uint256 index
767     )
768         internal
769         pure
770         returns (bytes4 result)
771     {
772         require(
773             b.length >= index + 4,
774             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
775         );
776 
777         // Arrays are prefixed by a 32 byte length field
778         index += 32;
779 
780         // Read the bytes4 from array memory
781         assembly {
782             result := mload(add(b, index))
783             // Solidity does not require us to clean the trailing bytes.
784             // We do it anyway
785             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
786         }
787         return result;
788     }
789 
790     function readBytes2(
791         bytes memory b,
792         uint256 index
793     )
794         internal
795         pure
796         returns (bytes2 result)
797     {
798         require(
799             b.length >= index + 2,
800             "GREATER_OR_EQUAL_TO_2_LENGTH_REQUIRED"
801         );
802 
803         // Arrays are prefixed by a 32 byte length field
804         index += 32;
805 
806         // Read the bytes4 from array memory
807         assembly {
808             result := mload(add(b, index))
809             // Solidity does not require us to clean the trailing bytes.
810             // We do it anyway
811             result := and(result, 0xFFFF000000000000000000000000000000000000000000000000000000000000)
812         }
813         return result;
814     }
815 
816     /// @dev Reads nested bytes from a specific position.
817     /// @dev NOTE: the returned value overlaps with the input value.
818     ///            Both should be treated as immutable.
819     /// @param b Byte array containing nested bytes.
820     /// @param index Index of nested bytes.
821     /// @return result Nested bytes.
822     function readBytesWithLength(
823         bytes memory b,
824         uint256 index
825     )
826         internal
827         pure
828         returns (bytes memory result)
829     {
830         // Read length of nested bytes
831         uint256 nestedBytesLength = readUint256(b, index);
832         index += 32;
833 
834         // Assert length of <b> is valid, given
835         // length of nested bytes
836         require(
837             b.length >= index + nestedBytesLength,
838             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
839         );
840         
841         // Return a pointer to the byte array as it exists inside `b`
842         assembly {
843             result := add(b, index)
844         }
845         return result;
846     }
847 
848     /// @dev Inserts bytes at a specific position in a byte array.
849     /// @param b Byte array to insert <input> into.
850     /// @param index Index in byte array of <input>.
851     /// @param input bytes to insert.
852     function writeBytesWithLength(
853         bytes memory b,
854         uint256 index,
855         bytes memory input
856     )
857         internal
858         pure
859     {
860         // Assert length of <b> is valid, given
861         // length of input
862         require(
863             b.length >= index + 32 + input.length,  // 32 bytes to store length
864             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
865         );
866 
867         // Copy <input> into <b>
868         memCopy(
869             b.contentAddress() + index,
870             input.rawAddress(), // includes length of <input>
871             input.length + 32   // +32 bytes to store <input> length
872         );
873     }
874 
875     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
876     /// @param dest Byte array that will be overwritten with source bytes.
877     /// @param source Byte array to copy onto dest bytes.
878     function deepCopyBytes(
879         bytes memory dest,
880         bytes memory source
881     )
882         internal
883         pure
884     {
885         uint256 sourceLen = source.length;
886         // Dest length must be >= source length, or some bytes would not be copied.
887         require(
888             dest.length >= sourceLen,
889             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
890         );
891         memCopy(
892             dest.contentAddress(),
893             source.contentAddress(),
894             sourceLen
895         );
896     }
897 }
898 
899 contract LibDecoder {
900     using LibBytes for bytes;
901 
902     function decodeFillOrder(bytes memory data) internal pure returns(LibOrder.Order memory order, uint256 takerFillAmount, bytes memory mmSignature) {
903         require(
904             data.length > 800,
905             "LENGTH_LESS_800"
906         );
907 
908         // compare method_id
909         // 0x64a3bc15 is fillOrKillOrder's method id.
910         require(
911             data.readBytes4(0) == 0x64a3bc15,
912             "WRONG_METHOD_ID"
913         );
914         
915         bytes memory dataSlice;
916         assembly {
917             dataSlice := add(data, 4)
918         }
919         //return (order, takerFillAmount, data);
920         return abi.decode(dataSlice, (LibOrder.Order, uint256, bytes));
921 
922     }
923 
924     function decodeMmSignatureWithoutSign(bytes memory signature) internal pure returns(address user, uint16 feeFactor) {
925         require(
926             signature.length == 87 || signature.length == 88,
927             "LENGTH_87_REQUIRED"
928         );
929 
930         user = signature.readAddress(65);
931         feeFactor = uint16(signature.readBytes2(85));
932         
933         require(
934             feeFactor < 10000,
935             "FEE_FACTOR_MORE_THEN_10000"
936         );
937 
938         return (user, feeFactor);
939     }
940 
941     function decodeMmSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address user, uint16 feeFactor) {
942         (user, feeFactor) = decodeMmSignatureWithoutSign(signature);
943 
944         v = uint8(signature[0]);
945         r = signature.readBytes32(1);
946         s = signature.readBytes32(33);
947 
948         return (v, r, s, user, feeFactor);
949     }
950 
951     function decodeUserSignatureWithoutSign(bytes memory signature) internal pure returns(address receiver) {
952         require(
953             signature.length == 85 || signature.length == 86,
954             "LENGTH_85_REQUIRED"
955         );
956         receiver = signature.readAddress(65);
957 
958         return receiver;
959     }
960 
961     function decodeUserSignature(bytes memory signature) internal pure returns(uint8 v, bytes32 r, bytes32 s, address receiver) {
962         receiver = decodeUserSignatureWithoutSign(signature);
963 
964         v = uint8(signature[0]);
965         r = signature.readBytes32(1);
966         s = signature.readBytes32(33);
967 
968         return (v, r, s, receiver);
969     }
970 
971     function decodeERC20Asset(bytes memory assetData) internal pure returns(address) {
972         require(
973             assetData.length == 36,
974             "LENGTH_65_REQUIRED"
975         );
976 
977         return assetData.readAddress(16);
978     }
979 }
980 
981 /**
982  * Version of ERC20 with no return values for `transfer` and `transferFrom
983  * https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
984  */
985 interface IERC20NonStandard {
986     function transfer(address to, uint256 value) external;
987 
988     function approve(address spender, uint256 value) external;
989 
990     function transferFrom(address from, address to, uint256 value) external;
991 
992     function totalSupply() external view returns (uint256);
993 
994     function balanceOf(address who) external view returns (uint256);
995 
996     function allowance(address owner, address spender) external view returns (uint256);
997 
998     event Transfer(address indexed from, address indexed to, uint256 value);
999 
1000     event Approval(address indexed owner, address indexed spender, uint256 value);
1001 }
1002 
1003 contract SafeToken {
1004     function doApprove(address token, address spender, uint256 amount) internal {
1005         bool result;
1006 
1007         IERC20NonStandard(token).approve(spender, amount);
1008 
1009         assembly {
1010             switch returndatasize()
1011                 case 0 {                      // This is a non-standard ERC-20
1012                     result := not(0)          // set result to true
1013                 }
1014                 case 32 {                     // This is a complaint ERC-20
1015                     returndatacopy(0, 0, 32)
1016                     result := mload(0)        // Set `result = returndata` of external call
1017                 }
1018                 default {                     // This is an excessively non-compliant ERC-20, revert.
1019                     revert(0, 0)
1020                 }
1021         }
1022 
1023         require(
1024             result,
1025             "APPROVE_FAILED"
1026         );
1027     }
1028 
1029     function doTransferFrom(address token, address from, address to, uint256 amount) internal {
1030         bool result;
1031 
1032         IERC20NonStandard(token).transferFrom(from, to, amount);
1033 
1034         assembly {
1035             switch returndatasize()
1036                 case 0 {                      // This is a non-standard ERC-20
1037                     result := not(0)          // set result to true
1038                 }
1039                 case 32 {                     // This is a complaint ERC-20
1040                     returndatacopy(0, 0, 32)
1041                     result := mload(0)        // Set `result = returndata` of external call
1042                 }
1043                 default {                     // This is an excessively non-compliant ERC-20, revert.
1044                     revert(0, 0)
1045                 }
1046         }
1047 
1048         require(
1049             result,
1050             "TRANSFER_FROM_FAILED"
1051         );
1052     }
1053 }
1054 
1055 contract MarketMakerProxy is 
1056     Ownable,
1057     LibWeth,
1058     LibDecoder,
1059     SafeToken
1060 {
1061     string public version = "0.0.5";
1062 
1063     uint256 constant MAX_UINT = 2**256 - 1;
1064     address internal SIGNER;
1065 
1066     // auto withdraw weth to eth
1067     address internal WETH_ADDR;
1068     address public withdrawer;
1069     mapping (address => bool) public isWithdrawWhitelist;
1070 
1071     modifier onlyWithdrawer() {
1072         require(
1073             msg.sender == withdrawer,
1074             "ONLY_CONTRACT_WITHDRAWER"
1075         );
1076         _;
1077     }
1078     
1079     constructor () public {
1080         owner = msg.sender;
1081         operator = msg.sender;
1082     }
1083 
1084     function() external payable {}
1085 
1086     // Manage
1087     function setSigner(address _signer) public onlyOperator {
1088         SIGNER = _signer;
1089     }
1090 
1091     function setWeth(address _weth) public onlyOperator {
1092         WETH_ADDR = _weth;
1093     }
1094 
1095     function setWithdrawer(address _withdrawer) public onlyOperator {
1096         withdrawer = _withdrawer;
1097     }
1098 
1099     function setAllowance(address[] memory token_addrs, address spender) public onlyOperator {
1100         for (uint i = 0; i < token_addrs.length; i++) {
1101             address token = token_addrs[i];
1102             doApprove(token, spender, MAX_UINT);
1103             doApprove(token, address(this), MAX_UINT);
1104         }
1105     }
1106 
1107     function closeAllowance(address[] memory token_addrs, address spender) public onlyOperator {
1108         for (uint i = 0; i < token_addrs.length; i++) {
1109             address token = token_addrs[i];
1110             doApprove(token, spender, 0);
1111             doApprove(token, address(this), 0);
1112         }
1113     }
1114 
1115     function registerWithdrawWhitelist(address _addr, bool _add) public onlyOperator {
1116         isWithdrawWhitelist[_addr] = _add;
1117     }
1118 
1119     function withdraw(address token, address payable to, uint256 amount) public onlyWithdrawer {
1120         require(
1121             isWithdrawWhitelist[to],
1122             "NOT_WITHDRAW_WHITELIST"
1123         );
1124         if(token == WETH_ADDR) {
1125             convertWethtoETH(token, amount);
1126             to.transfer(amount);
1127         } else {
1128             doTransferFrom(token, address(this), to , amount);
1129         }
1130     }
1131 
1132     function withdrawETH(address payable to, uint256 amount) public onlyWithdrawer {
1133         require(
1134             isWithdrawWhitelist[to],
1135             "NOT_WITHDRAW_WHITELIST"
1136         );
1137         to.transfer(amount);
1138     }
1139 
1140     function isValidSignature(bytes32 orderHash, bytes memory signature) public view returns (bytes32) {
1141         require(
1142             SIGNER == ecrecoverAddress(orderHash, signature),
1143             "INVALID_SIGNATURE"
1144         );
1145         return keccak256("isValidWalletSignature(bytes32,address,bytes)");
1146     }
1147 
1148     function ecrecoverAddress(bytes32 orderHash, bytes memory signature) internal pure returns (address) {
1149         (uint8 v, bytes32 r, bytes32 s, address user, uint16 feeFactor) = decodeMmSignature(signature);
1150         
1151         return ecrecover(
1152             keccak256(
1153                 abi.encodePacked(
1154                     "\x19Ethereum Signed Message:\n54",
1155                     orderHash,
1156                     user,
1157                     feeFactor
1158                 )),
1159             v, r, s
1160         );
1161     }
1162 }