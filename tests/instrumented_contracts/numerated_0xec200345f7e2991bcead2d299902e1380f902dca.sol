1 /*
2 
3   Copyright 2018 ZeroEx Intl.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9     http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 
19 pragma solidity 0.4.24;
20 pragma experimental ABIEncoderV2;
21 
22 library LibBytes {
23 
24     using LibBytes for bytes;
25 
26     /// @dev Gets the memory address for a byte array.
27     /// @param input Byte array to lookup.
28     /// @return memoryAddress Memory address of byte array. This
29     ///         points to the header of the byte array which contains
30     ///         the length.
31     function rawAddress(bytes memory input)
32         internal
33         pure
34         returns (uint256 memoryAddress)
35     {
36         assembly {
37             memoryAddress := input
38         }
39         return memoryAddress;
40     }
41     
42     /// @dev Gets the memory address for the contents of a byte array.
43     /// @param input Byte array to lookup.
44     /// @return memoryAddress Memory address of the contents of the byte array.
45     function contentAddress(bytes memory input)
46         internal
47         pure
48         returns (uint256 memoryAddress)
49     {
50         assembly {
51             memoryAddress := add(input, 32)
52         }
53         return memoryAddress;
54     }
55 
56     /// @dev Copies `length` bytes from memory location `source` to `dest`.
57     /// @param dest memory address to copy bytes to.
58     /// @param source memory address to copy bytes from.
59     /// @param length number of bytes to copy.
60     function memCopy(
61         uint256 dest,
62         uint256 source,
63         uint256 length
64     )
65         internal
66         pure
67     {
68         if (length < 32) {
69             // Handle a partial word by reading destination and masking
70             // off the bits we are interested in.
71             // This correctly handles overlap, zero lengths and source == dest
72             assembly {
73                 let mask := sub(exp(256, sub(32, length)), 1)
74                 let s := and(mload(source), not(mask))
75                 let d := and(mload(dest), mask)
76                 mstore(dest, or(s, d))
77             }
78         } else {
79             // Skip the O(length) loop when source == dest.
80             if (source == dest) {
81                 return;
82             }
83 
84             // For large copies we copy whole words at a time. The final
85             // word is aligned to the end of the range (instead of after the
86             // previous) to handle partial words. So a copy will look like this:
87             //
88             //  ####
89             //      ####
90             //          ####
91             //            ####
92             //
93             // We handle overlap in the source and destination range by
94             // changing the copying direction. This prevents us from
95             // overwriting parts of source that we still need to copy.
96             //
97             // This correctly handles source == dest
98             //
99             if (source > dest) {
100                 assembly {
101                     // We subtract 32 from `sEnd` and `dEnd` because it
102                     // is easier to compare with in the loop, and these
103                     // are also the addresses we need for copying the
104                     // last bytes.
105                     length := sub(length, 32)
106                     let sEnd := add(source, length)
107                     let dEnd := add(dest, length)
108 
109                     // Remember the last 32 bytes of source
110                     // This needs to be done here and not after the loop
111                     // because we may have overwritten the last bytes in
112                     // source already due to overlap.
113                     let last := mload(sEnd)
114 
115                     // Copy whole words front to back
116                     // Note: the first check is always true,
117                     // this could have been a do-while loop.
118                     // solhint-disable-next-line no-empty-blocks
119                     for {} lt(source, sEnd) {} {
120                         mstore(dest, mload(source))
121                         source := add(source, 32)
122                         dest := add(dest, 32)
123                     }
124                     
125                     // Write the last 32 bytes
126                     mstore(dEnd, last)
127                 }
128             } else {
129                 assembly {
130                     // We subtract 32 from `sEnd` and `dEnd` because those
131                     // are the starting points when copying a word at the end.
132                     length := sub(length, 32)
133                     let sEnd := add(source, length)
134                     let dEnd := add(dest, length)
135 
136                     // Remember the first 32 bytes of source
137                     // This needs to be done here and not after the loop
138                     // because we may have overwritten the first bytes in
139                     // source already due to overlap.
140                     let first := mload(source)
141 
142                     // Copy whole words back to front
143                     // We use a signed comparisson here to allow dEnd to become
144                     // negative (happens when source and dest < 32). Valid
145                     // addresses in local memory will never be larger than
146                     // 2**255, so they can be safely re-interpreted as signed.
147                     // Note: the first check is always true,
148                     // this could have been a do-while loop.
149                     // solhint-disable-next-line no-empty-blocks
150                     for {} slt(dest, dEnd) {} {
151                         mstore(dEnd, mload(sEnd))
152                         sEnd := sub(sEnd, 32)
153                         dEnd := sub(dEnd, 32)
154                     }
155                     
156                     // Write the first 32 bytes
157                     mstore(dest, first)
158                 }
159             }
160         }
161     }
162 
163     /// @dev Returns a slices from a byte array.
164     /// @param b The byte array to take a slice from.
165     /// @param from The starting index for the slice (inclusive).
166     /// @param to The final index for the slice (exclusive).
167     /// @return result The slice containing bytes at indices [from, to)
168     function slice(
169         bytes memory b,
170         uint256 from,
171         uint256 to
172     )
173         internal
174         pure
175         returns (bytes memory result)
176     {
177         require(
178             from <= to,
179             "FROM_LESS_THAN_TO_REQUIRED"
180         );
181         require(
182             to < b.length,
183             "TO_LESS_THAN_LENGTH_REQUIRED"
184         );
185         
186         // Create a new bytes structure and copy contents
187         result = new bytes(to - from);
188         memCopy(
189             result.contentAddress(),
190             b.contentAddress() + from,
191             result.length
192         );
193         return result;
194     }
195     
196     /// @dev Returns a slice from a byte array without preserving the input.
197     /// @param b The byte array to take a slice from. Will be destroyed in the process.
198     /// @param from The starting index for the slice (inclusive).
199     /// @param to The final index for the slice (exclusive).
200     /// @return result The slice containing bytes at indices [from, to)
201     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
202     function sliceDestructive(
203         bytes memory b,
204         uint256 from,
205         uint256 to
206     )
207         internal
208         pure
209         returns (bytes memory result)
210     {
211         require(
212             from <= to,
213             "FROM_LESS_THAN_TO_REQUIRED"
214         );
215         require(
216             to < b.length,
217             "TO_LESS_THAN_LENGTH_REQUIRED"
218         );
219         
220         // Create a new bytes structure around [from, to) in-place.
221         assembly {
222             result := add(b, from)
223             mstore(result, sub(to, from))
224         }
225         return result;
226     }
227 
228     /// @dev Pops the last byte off of a byte array by modifying its length.
229     /// @param b Byte array that will be modified.
230     /// @return The byte that was popped off.
231     function popLastByte(bytes memory b)
232         internal
233         pure
234         returns (bytes1 result)
235     {
236         require(
237             b.length > 0,
238             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
239         );
240 
241         // Store last byte.
242         result = b[b.length - 1];
243 
244         assembly {
245             // Decrement length of byte array.
246             let newLen := sub(mload(b), 1)
247             mstore(b, newLen)
248         }
249         return result;
250     }
251 
252     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
253     /// @param b Byte array that will be modified.
254     /// @return The 20 byte address that was popped off.
255     function popLast20Bytes(bytes memory b)
256         internal
257         pure
258         returns (address result)
259     {
260         require(
261             b.length >= 20,
262             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
263         );
264 
265         // Store last 20 bytes.
266         result = readAddress(b, b.length - 20);
267 
268         assembly {
269             // Subtract 20 from byte array length.
270             let newLen := sub(mload(b), 20)
271             mstore(b, newLen)
272         }
273         return result;
274     }
275 
276     /// @dev Tests equality of two byte arrays.
277     /// @param lhs First byte array to compare.
278     /// @param rhs Second byte array to compare.
279     /// @return True if arrays are the same. False otherwise.
280     function equals(
281         bytes memory lhs,
282         bytes memory rhs
283     )
284         internal
285         pure
286         returns (bool equal)
287     {
288         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
289         // We early exit on unequal lengths, but keccak would also correctly
290         // handle this.
291         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
292     }
293 
294     /// @dev Reads an address from a position in a byte array.
295     /// @param b Byte array containing an address.
296     /// @param index Index in byte array of address.
297     /// @return address from byte array.
298     function readAddress(
299         bytes memory b,
300         uint256 index
301     )
302         internal
303         pure
304         returns (address result)
305     {
306         require(
307             b.length >= index + 20,  // 20 is length of address
308             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
309         );
310 
311         // Add offset to index:
312         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
313         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
314         index += 20;
315 
316         // Read address from array memory
317         assembly {
318             // 1. Add index to address of bytes array
319             // 2. Load 32-byte word from memory
320             // 3. Apply 20-byte mask to obtain address
321             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
322         }
323         return result;
324     }
325 
326     /// @dev Writes an address into a specific position in a byte array.
327     /// @param b Byte array to insert address into.
328     /// @param index Index in byte array of address.
329     /// @param input Address to put into byte array.
330     function writeAddress(
331         bytes memory b,
332         uint256 index,
333         address input
334     )
335         internal
336         pure
337     {
338         require(
339             b.length >= index + 20,  // 20 is length of address
340             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
341         );
342 
343         // Add offset to index:
344         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
345         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
346         index += 20;
347 
348         // Store address into array memory
349         assembly {
350             // The address occupies 20 bytes and mstore stores 32 bytes.
351             // First fetch the 32-byte word where we'll be storing the address, then
352             // apply a mask so we have only the bytes in the word that the address will not occupy.
353             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
354 
355             // 1. Add index to address of bytes array
356             // 2. Load 32-byte word from memory
357             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
358             let neighbors := and(
359                 mload(add(b, index)),
360                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
361             )
362             
363             // Make sure input address is clean.
364             // (Solidity does not guarantee this)
365             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
366 
367             // Store the neighbors and address into memory
368             mstore(add(b, index), xor(input, neighbors))
369         }
370     }
371 
372     /// @dev Reads a bytes32 value from a position in a byte array.
373     /// @param b Byte array containing a bytes32 value.
374     /// @param index Index in byte array of bytes32 value.
375     /// @return bytes32 value from byte array.
376     function readBytes32(
377         bytes memory b,
378         uint256 index
379     )
380         internal
381         pure
382         returns (bytes32 result)
383     {
384         require(
385             b.length >= index + 32,
386             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
387         );
388 
389         // Arrays are prefixed by a 256 bit length parameter
390         index += 32;
391 
392         // Read the bytes32 from array memory
393         assembly {
394             result := mload(add(b, index))
395         }
396         return result;
397     }
398 
399     /// @dev Writes a bytes32 into a specific position in a byte array.
400     /// @param b Byte array to insert <input> into.
401     /// @param index Index in byte array of <input>.
402     /// @param input bytes32 to put into byte array.
403     function writeBytes32(
404         bytes memory b,
405         uint256 index,
406         bytes32 input
407     )
408         internal
409         pure
410     {
411         require(
412             b.length >= index + 32,
413             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
414         );
415 
416         // Arrays are prefixed by a 256 bit length parameter
417         index += 32;
418 
419         // Read the bytes32 from array memory
420         assembly {
421             mstore(add(b, index), input)
422         }
423     }
424 
425     /// @dev Reads a uint256 value from a position in a byte array.
426     /// @param b Byte array containing a uint256 value.
427     /// @param index Index in byte array of uint256 value.
428     /// @return uint256 value from byte array.
429     function readUint256(
430         bytes memory b,
431         uint256 index
432     )
433         internal
434         pure
435         returns (uint256 result)
436     {
437         result = uint256(readBytes32(b, index));
438         return result;
439     }
440 
441     /// @dev Writes a uint256 into a specific position in a byte array.
442     /// @param b Byte array to insert <input> into.
443     /// @param index Index in byte array of <input>.
444     /// @param input uint256 to put into byte array.
445     function writeUint256(
446         bytes memory b,
447         uint256 index,
448         uint256 input
449     )
450         internal
451         pure
452     {
453         writeBytes32(b, index, bytes32(input));
454     }
455 
456     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
457     /// @param b Byte array containing a bytes4 value.
458     /// @param index Index in byte array of bytes4 value.
459     /// @return bytes4 value from byte array.
460     function readBytes4(
461         bytes memory b,
462         uint256 index
463     )
464         internal
465         pure
466         returns (bytes4 result)
467     {
468         require(
469             b.length >= index + 4,
470             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
471         );
472 
473         // Arrays are prefixed by a 32 byte length field
474         index += 32;
475 
476         // Read the bytes4 from array memory
477         assembly {
478             result := mload(add(b, index))
479             // Solidity does not require us to clean the trailing bytes.
480             // We do it anyway
481             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
482         }
483         return result;
484     }
485 
486     /// @dev Reads nested bytes from a specific position.
487     /// @dev NOTE: the returned value overlaps with the input value.
488     ///            Both should be treated as immutable.
489     /// @param b Byte array containing nested bytes.
490     /// @param index Index of nested bytes.
491     /// @return result Nested bytes.
492     function readBytesWithLength(
493         bytes memory b,
494         uint256 index
495     )
496         internal
497         pure
498         returns (bytes memory result)
499     {
500         // Read length of nested bytes
501         uint256 nestedBytesLength = readUint256(b, index);
502         index += 32;
503 
504         // Assert length of <b> is valid, given
505         // length of nested bytes
506         require(
507             b.length >= index + nestedBytesLength,
508             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
509         );
510         
511         // Return a pointer to the byte array as it exists inside `b`
512         assembly {
513             result := add(b, index)
514         }
515         return result;
516     }
517 
518     /// @dev Inserts bytes at a specific position in a byte array.
519     /// @param b Byte array to insert <input> into.
520     /// @param index Index in byte array of <input>.
521     /// @param input bytes to insert.
522     function writeBytesWithLength(
523         bytes memory b,
524         uint256 index,
525         bytes memory input
526     )
527         internal
528         pure
529     {
530         // Assert length of <b> is valid, given
531         // length of input
532         require(
533             b.length >= index + 32 + input.length,  // 32 bytes to store length
534             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
535         );
536 
537         // Copy <input> into <b>
538         memCopy(
539             b.contentAddress() + index,
540             input.rawAddress(), // includes length of <input>
541             input.length + 32   // +32 bytes to store <input> length
542         );
543     }
544 
545     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
546     /// @param dest Byte array that will be overwritten with source bytes.
547     /// @param source Byte array to copy onto dest bytes.
548     function deepCopyBytes(
549         bytes memory dest,
550         bytes memory source
551     )
552         internal
553         pure
554     {
555         uint256 sourceLen = source.length;
556         // Dest length must be >= source length, or some bytes would not be copied.
557         require(
558             dest.length >= sourceLen,
559             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
560         );
561         memCopy(
562             dest.contentAddress(),
563             source.contentAddress(),
564             sourceLen
565         );
566     }
567 }
568 
569 contract ReentrancyGuard {
570 
571     // Locked state of mutex
572     bool private locked = false;
573 
574     /// @dev Functions with this modifer cannot be reentered. The mutex will be locked
575     ///      before function execution and unlocked after.
576     modifier nonReentrant() {
577         // Ensure mutex is unlocked
578         require(
579             !locked,
580             "REENTRANCY_ILLEGAL"
581         );
582 
583         // Lock mutex before function call
584         locked = true;
585 
586         // Perform function call
587         _;
588 
589         // Unlock mutex after function call
590         locked = false;
591     }
592 }
593 
594 contract SafeMath {
595 
596     function safeMul(uint256 a, uint256 b)
597         internal
598         pure
599         returns (uint256)
600     {
601         if (a == 0) {
602             return 0;
603         }
604         uint256 c = a * b;
605         require(
606             c / a == b,
607             "UINT256_OVERFLOW"
608         );
609         return c;
610     }
611 
612     function safeDiv(uint256 a, uint256 b)
613         internal
614         pure
615         returns (uint256)
616     {
617         uint256 c = a / b;
618         return c;
619     }
620 
621     function safeSub(uint256 a, uint256 b)
622         internal
623         pure
624         returns (uint256)
625     {
626         require(
627             b <= a,
628             "UINT256_UNDERFLOW"
629         );
630         return a - b;
631     }
632 
633     function safeAdd(uint256 a, uint256 b)
634         internal
635         pure
636         returns (uint256)
637     {
638         uint256 c = a + b;
639         require(
640             c >= a,
641             "UINT256_OVERFLOW"
642         );
643         return c;
644     }
645 
646     function max64(uint64 a, uint64 b)
647         internal
648         pure
649         returns (uint256)
650     {
651         return a >= b ? a : b;
652     }
653 
654     function min64(uint64 a, uint64 b)
655         internal
656         pure
657         returns (uint256)
658     {
659         return a < b ? a : b;
660     }
661 
662     function max256(uint256 a, uint256 b)
663         internal
664         pure
665         returns (uint256)
666     {
667         return a >= b ? a : b;
668     }
669 
670     function min256(uint256 a, uint256 b)
671         internal
672         pure
673         returns (uint256)
674     {
675         return a < b ? a : b;
676     }
677 }
678 
679 // solhint-disable max-line-length
680 contract LibConstants {
681     // Lootex wants fee be paid by WETH, so we change ZRX address to 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
682     // Mainnet WETH address is 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2.
683     // The ABI encoded proxyId and address is 0xf47261b0000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
684     bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x2a\xaa\x39\xb2\x23\xfe\x8d\x0a\x0e\x5c\x4f\x27\xea\xd9\x08\x3c\x75\x6c\xc2";
685 }
686 // solhint-enable max-line-length
687 
688 contract LibEIP712 {
689 
690     // EIP191 header for EIP712 prefix
691     string constant internal EIP191_HEADER = "\x19\x01";
692 
693     // EIP712 Domain Name value
694     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
695 
696     // EIP712 Domain Version value
697     string constant internal EIP712_DOMAIN_VERSION = "2";
698 
699     // Hash of the EIP712 Domain Separator Schema
700     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
701         "EIP712Domain(",
702         "string name,",
703         "string version,",
704         "address verifyingContract",
705         ")"
706     ));
707 
708     // Hash of the EIP712 Domain Separator data
709     // solhint-disable-next-line var-name-mixedcase
710     bytes32 public EIP712_DOMAIN_HASH;
711 
712     constructor ()
713         public
714     {
715         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
716             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
717             keccak256(bytes(EIP712_DOMAIN_NAME)),
718             keccak256(bytes(EIP712_DOMAIN_VERSION)),
719             bytes32(address(this))
720         ));
721     }
722 
723     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
724     /// @param hashStruct The EIP712 hash struct.
725     /// @return EIP712 hash applied to this EIP712 Domain.
726     function hashEIP712Message(bytes32 hashStruct)
727         internal
728         view
729         returns (bytes32 result)
730     {
731         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
732 
733         // Assembly for more efficient computing:
734         // keccak256(abi.encodePacked(
735         //     EIP191_HEADER,
736         //     EIP712_DOMAIN_HASH,
737         //     hashStruct    
738         // ));
739 
740         assembly {
741             // Load free memory pointer
742             let memPtr := mload(64)
743 
744             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
745             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
746             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
747 
748             // Compute hash
749             result := keccak256(memPtr, 66)
750         }
751         return result;
752     }
753 }
754 
755 contract LibFillResults is
756     SafeMath
757 {
758     struct FillResults {
759         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
760         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
761         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
762         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
763     }
764 
765     struct MatchedFillResults {
766         FillResults left;                    // Amounts filled and fees paid of left order.
767         FillResults right;                   // Amounts filled and fees paid of right order.
768         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
769     }
770 
771     /// @dev Adds properties of both FillResults instances.
772     ///      Modifies the first FillResults instance specified.
773     /// @param totalFillResults Fill results instance that will be added onto.
774     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
775     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
776         internal
777         pure
778     {
779         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
780         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
781         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
782         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
783     }
784 }
785 
786 contract LibMath is
787     SafeMath
788 {
789     /// @dev Calculates partial value given a numerator and denominator rounded down.
790     ///      Reverts if rounding error is >= 0.1%
791     /// @param numerator Numerator.
792     /// @param denominator Denominator.
793     /// @param target Value to calculate partial of.
794     /// @return Partial value of target rounded down.
795     function safeGetPartialAmountFloor(
796         uint256 numerator,
797         uint256 denominator,
798         uint256 target
799     )
800         internal
801         pure
802         returns (uint256 partialAmount)
803     {
804         require(
805             denominator > 0,
806             "DIVISION_BY_ZERO"
807         );
808 
809         require(
810             !isRoundingErrorFloor(
811                 numerator,
812                 denominator,
813                 target
814             ),
815             "ROUNDING_ERROR"
816         );
817         
818         partialAmount = safeDiv(
819             safeMul(numerator, target),
820             denominator
821         );
822         return partialAmount;
823     }
824 
825     /// @dev Calculates partial value given a numerator and denominator rounded down.
826     ///      Reverts if rounding error is >= 0.1%
827     /// @param numerator Numerator.
828     /// @param denominator Denominator.
829     /// @param target Value to calculate partial of.
830     /// @return Partial value of target rounded up.
831     function safeGetPartialAmountCeil(
832         uint256 numerator,
833         uint256 denominator,
834         uint256 target
835     )
836         internal
837         pure
838         returns (uint256 partialAmount)
839     {
840         require(
841             denominator > 0,
842             "DIVISION_BY_ZERO"
843         );
844 
845         require(
846             !isRoundingErrorCeil(
847                 numerator,
848                 denominator,
849                 target
850             ),
851             "ROUNDING_ERROR"
852         );
853         
854         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
855         //       ceil(a / b) = floor((a + b - 1) / b)
856         // To implement `ceil(a / b)` using safeDiv.
857         partialAmount = safeDiv(
858             safeAdd(
859                 safeMul(numerator, target),
860                 safeSub(denominator, 1)
861             ),
862             denominator
863         );
864         return partialAmount;
865     }
866 
867     /// @dev Calculates partial value given a numerator and denominator rounded down.
868     /// @param numerator Numerator.
869     /// @param denominator Denominator.
870     /// @param target Value to calculate partial of.
871     /// @return Partial value of target rounded down.
872     function getPartialAmountFloor(
873         uint256 numerator,
874         uint256 denominator,
875         uint256 target
876     )
877         internal
878         pure
879         returns (uint256 partialAmount)
880     {
881         require(
882             denominator > 0,
883             "DIVISION_BY_ZERO"
884         );
885 
886         partialAmount = safeDiv(
887             safeMul(numerator, target),
888             denominator
889         );
890         return partialAmount;
891     }
892     
893     /// @dev Calculates partial value given a numerator and denominator rounded down.
894     /// @param numerator Numerator.
895     /// @param denominator Denominator.
896     /// @param target Value to calculate partial of.
897     /// @return Partial value of target rounded up.
898     function getPartialAmountCeil(
899         uint256 numerator,
900         uint256 denominator,
901         uint256 target
902     )
903         internal
904         pure
905         returns (uint256 partialAmount)
906     {
907         require(
908             denominator > 0,
909             "DIVISION_BY_ZERO"
910         );
911 
912         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
913         //       ceil(a / b) = floor((a + b - 1) / b)
914         // To implement `ceil(a / b)` using safeDiv.
915         partialAmount = safeDiv(
916             safeAdd(
917                 safeMul(numerator, target),
918                 safeSub(denominator, 1)
919             ),
920             denominator
921         );
922         return partialAmount;
923     }
924     
925     /// @dev Checks if rounding error >= 0.1% when rounding down.
926     /// @param numerator Numerator.
927     /// @param denominator Denominator.
928     /// @param target Value to multiply with numerator/denominator.
929     /// @return Rounding error is present.
930     function isRoundingErrorFloor(
931         uint256 numerator,
932         uint256 denominator,
933         uint256 target
934     )
935         internal
936         pure
937         returns (bool isError)
938     {
939         require(
940             denominator > 0,
941             "DIVISION_BY_ZERO"
942         );
943         
944         // The absolute rounding error is the difference between the rounded
945         // value and the ideal value. The relative rounding error is the
946         // absolute rounding error divided by the absolute value of the
947         // ideal value. This is undefined when the ideal value is zero.
948         //
949         // The ideal value is `numerator * target / denominator`.
950         // Let's call `numerator * target % denominator` the remainder.
951         // The absolute error is `remainder / denominator`.
952         //
953         // When the ideal value is zero, we require the absolute error to
954         // be zero. Fortunately, this is always the case. The ideal value is
955         // zero iff `numerator == 0` and/or `target == 0`. In this case the
956         // remainder and absolute error are also zero. 
957         if (target == 0 || numerator == 0) {
958             return false;
959         }
960         
961         // Otherwise, we want the relative rounding error to be strictly
962         // less than 0.1%.
963         // The relative error is `remainder / (numerator * target)`.
964         // We want the relative error less than 1 / 1000:
965         //        remainder / (numerator * denominator)  <  1 / 1000
966         // or equivalently:
967         //        1000 * remainder  <  numerator * target
968         // so we have a rounding error iff:
969         //        1000 * remainder  >=  numerator * target
970         uint256 remainder = mulmod(
971             target,
972             numerator,
973             denominator
974         );
975         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
976         return isError;
977     }
978     
979     /// @dev Checks if rounding error >= 0.1% when rounding up.
980     /// @param numerator Numerator.
981     /// @param denominator Denominator.
982     /// @param target Value to multiply with numerator/denominator.
983     /// @return Rounding error is present.
984     function isRoundingErrorCeil(
985         uint256 numerator,
986         uint256 denominator,
987         uint256 target
988     )
989         internal
990         pure
991         returns (bool isError)
992     {
993         require(
994             denominator > 0,
995             "DIVISION_BY_ZERO"
996         );
997         
998         // See the comments in `isRoundingError`.
999         if (target == 0 || numerator == 0) {
1000             // When either is zero, the ideal value and rounded value are zero
1001             // and there is no rounding error. (Although the relative error
1002             // is undefined.)
1003             return false;
1004         }
1005         // Compute remainder as before
1006         uint256 remainder = mulmod(
1007             target,
1008             numerator,
1009             denominator
1010         );
1011         remainder = safeSub(denominator, remainder) % denominator;
1012         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
1013         return isError;
1014     }
1015 }
1016 
1017 contract LibOrder is
1018     LibEIP712
1019 {
1020     // Hash for the EIP712 Order Schema
1021     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
1022         "Order(",
1023         "address makerAddress,",
1024         "address takerAddress,",
1025         "address feeRecipientAddress,",
1026         "address senderAddress,",
1027         "uint256 makerAssetAmount,",
1028         "uint256 takerAssetAmount,",
1029         "uint256 makerFee,",
1030         "uint256 takerFee,",
1031         "uint256 expirationTimeSeconds,",
1032         "uint256 salt,",
1033         "bytes makerAssetData,",
1034         "bytes takerAssetData",
1035         ")"
1036     ));
1037 
1038     // A valid order remains fillable until it is expired, fully filled, or cancelled.
1039     // An order's state is unaffected by external factors, like account balances.
1040     enum OrderStatus {
1041         INVALID,                     // Default value
1042         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
1043         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
1044         FILLABLE,                    // Order is fillable
1045         EXPIRED,                     // Order has already expired
1046         FULLY_FILLED,                // Order is fully filled
1047         CANCELLED                    // Order has been cancelled
1048     }
1049 
1050     // solhint-disable max-line-length
1051     struct Order {
1052         address makerAddress;           // Address that created the order.      
1053         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
1054         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
1055         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1056         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
1057         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
1058         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1059         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1060         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
1061         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
1062         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1063         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1064     }
1065     // solhint-enable max-line-length
1066 
1067     struct OrderInfo {
1068         uint8 orderStatus;                    // Status that describes order's validity and fillability.
1069         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
1070         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
1071     }
1072 
1073     /// @dev Calculates Keccak-256 hash of the order.
1074     /// @param order The order structure.
1075     /// @return Keccak-256 EIP712 hash of the order.
1076     function getOrderHash(Order memory order)
1077         internal
1078         view
1079         returns (bytes32 orderHash)
1080     {
1081         orderHash = hashEIP712Message(hashOrder(order));
1082         return orderHash;
1083     }
1084 
1085     /// @dev Calculates EIP712 hash of the order.
1086     /// @param order The order structure.
1087     /// @return EIP712 hash of the order.
1088     function hashOrder(Order memory order)
1089         internal
1090         pure
1091         returns (bytes32 result)
1092     {
1093         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
1094         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
1095         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
1096 
1097         // Assembly for more efficiently computing:
1098         // keccak256(abi.encodePacked(
1099         //     EIP712_ORDER_SCHEMA_HASH,
1100         //     bytes32(order.makerAddress),
1101         //     bytes32(order.takerAddress),
1102         //     bytes32(order.feeRecipientAddress),
1103         //     bytes32(order.senderAddress),
1104         //     order.makerAssetAmount,
1105         //     order.takerAssetAmount,
1106         //     order.makerFee,
1107         //     order.takerFee,
1108         //     order.expirationTimeSeconds,
1109         //     order.salt,
1110         //     keccak256(order.makerAssetData),
1111         //     keccak256(order.takerAssetData)
1112         // ));
1113 
1114         assembly {
1115             // Calculate memory addresses that will be swapped out before hashing
1116             let pos1 := sub(order, 32)
1117             let pos2 := add(order, 320)
1118             let pos3 := add(order, 352)
1119 
1120             // Backup
1121             let temp1 := mload(pos1)
1122             let temp2 := mload(pos2)
1123             let temp3 := mload(pos3)
1124             
1125             // Hash in place
1126             mstore(pos1, schemaHash)
1127             mstore(pos2, makerAssetDataHash)
1128             mstore(pos3, takerAssetDataHash)
1129             result := keccak256(pos1, 416)
1130             
1131             // Restore
1132             mstore(pos1, temp1)
1133             mstore(pos2, temp2)
1134             mstore(pos3, temp3)
1135         }
1136         return result;
1137     }
1138 }
1139 
1140 contract LibAbiEncoder {
1141 
1142     /// @dev ABI encodes calldata for `fillOrder`.
1143     /// @param order Order struct containing order specifications.
1144     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1145     /// @param signature Proof that order has been created by maker.
1146     /// @return ABI encoded calldata for `fillOrder`.
1147     function abiEncodeFillOrder(
1148         LibOrder.Order memory order,
1149         uint256 takerAssetFillAmount,
1150         bytes memory signature
1151     )
1152         internal
1153         pure
1154         returns (bytes memory fillOrderCalldata)
1155     {
1156         // We need to call MExchangeCore.fillOrder using a delegatecall in
1157         // assembly so that we can intercept a call that throws. For this, we
1158         // need the input encoded in memory in the Ethereum ABIv2 format [1].
1159 
1160         // | Area     | Offset | Length  | Contents                                    |
1161         // | -------- |--------|---------|-------------------------------------------- |
1162         // | Header   | 0x00   | 4       | function selector                           |
1163         // | Params   |        | 3 * 32  | function parameters:                        |
1164         // |          | 0x00   |         |   1. offset to order (*)                    |
1165         // |          | 0x20   |         |   2. takerAssetFillAmount                   |
1166         // |          | 0x40   |         |   3. offset to signature (*)                |
1167         // | Data     |        | 12 * 32 | order:                                      |
1168         // |          | 0x000  |         |   1.  senderAddress                         |
1169         // |          | 0x020  |         |   2.  makerAddress                          |
1170         // |          | 0x040  |         |   3.  takerAddress                          |
1171         // |          | 0x060  |         |   4.  feeRecipientAddress                   |
1172         // |          | 0x080  |         |   5.  makerAssetAmount                      |
1173         // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
1174         // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
1175         // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
1176         // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
1177         // |          | 0x120  |         |   10. salt                                  |
1178         // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
1179         // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
1180         // |          | 0x180  | 32      | makerAssetData Length                       |
1181         // |          | 0x1A0  | **      | makerAssetData Contents                     |
1182         // |          | 0x1C0  | 32      | takerAssetData Length                       |
1183         // |          | 0x1E0  | **      | takerAssetData Contents                     |
1184         // |          | 0x200  | 32      | signature Length                            |
1185         // |          | 0x220  | **      | signature Contents                          |
1186 
1187         // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
1188         //     An offset stored in the Params area is calculated from the beginning of the Params section.
1189         //     An offset stored in the Data area is calculated from the beginning of the Data section.
1190 
1191         // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.
1192 
1193         // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html
1194 
1195         assembly {
1196 
1197             // Areas below may use the following variables:
1198             //   1. <area>Start   -- Start of this area in memory
1199             //   2. <area>End     -- End of this area in memory. This value may
1200             //                       be precomputed (before writing contents),
1201             //                       or it may be computed as contents are written.
1202             //   3. <area>Offset  -- Current offset into area. If an area's End
1203             //                       is precomputed, this variable tracks the
1204             //                       offsets of contents as they are written.
1205 
1206             /////// Setup Header Area ///////
1207             // Load free memory pointer
1208             fillOrderCalldata := mload(0x40)
1209             // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
1210             // = 0xb4be83d5
1211             // Leave 0x20 bytes to store the length
1212             mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
1213             let headerAreaEnd := add(fillOrderCalldata, 0x24)
1214 
1215             /////// Setup Params Area ///////
1216             // This area is preallocated and written to later.
1217             // This is because we need to fill in offsets that have not yet been calculated.
1218             let paramsAreaStart := headerAreaEnd
1219             let paramsAreaEnd := add(paramsAreaStart, 0x60)
1220             let paramsAreaOffset := paramsAreaStart
1221 
1222             /////// Setup Data Area ///////
1223             let dataAreaStart := paramsAreaEnd
1224             let dataAreaEnd := dataAreaStart
1225 
1226             // Offset from the source data we're reading from
1227             let sourceOffset := order
1228             // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
1229             let arrayLenBytes := 0
1230             let arrayLenWords := 0
1231 
1232             /////// Write order Struct ///////
1233             // Write memory location of Order, relative to the start of the
1234             // parameter list, then increment the paramsAreaOffset respectively.
1235             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
1236             paramsAreaOffset := add(paramsAreaOffset, 0x20)
1237 
1238             // Write values for each field in the order
1239             // It would be nice to use a loop, but we save on gas by writing
1240             // the stores sequentially.
1241             mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
1242             mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
1243             mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
1244             mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
1245             mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
1246             mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
1247             mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
1248             mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
1249             mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
1250             mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
1251             mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
1252             mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
1253             dataAreaEnd := add(dataAreaEnd, 0x180)
1254             sourceOffset := add(sourceOffset, 0x180)
1255 
1256             // Write offset to <order.makerAssetData>
1257             mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))
1258 
1259             // Calculate length of <order.makerAssetData>
1260             sourceOffset := mload(add(order, 0x140)) // makerAssetData
1261             arrayLenBytes := mload(sourceOffset)
1262             sourceOffset := add(sourceOffset, 0x20)
1263             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1264 
1265             // Write length of <order.makerAssetData>
1266             mstore(dataAreaEnd, arrayLenBytes)
1267             dataAreaEnd := add(dataAreaEnd, 0x20)
1268 
1269             // Write contents of <order.makerAssetData>
1270             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1271                 mstore(dataAreaEnd, mload(sourceOffset))
1272                 dataAreaEnd := add(dataAreaEnd, 0x20)
1273                 sourceOffset := add(sourceOffset, 0x20)
1274             }
1275 
1276             // Write offset to <order.takerAssetData>
1277             mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))
1278 
1279             // Calculate length of <order.takerAssetData>
1280             sourceOffset := mload(add(order, 0x160)) // takerAssetData
1281             arrayLenBytes := mload(sourceOffset)
1282             sourceOffset := add(sourceOffset, 0x20)
1283             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1284 
1285             // Write length of <order.takerAssetData>
1286             mstore(dataAreaEnd, arrayLenBytes)
1287             dataAreaEnd := add(dataAreaEnd, 0x20)
1288 
1289             // Write contents of  <order.takerAssetData>
1290             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1291                 mstore(dataAreaEnd, mload(sourceOffset))
1292                 dataAreaEnd := add(dataAreaEnd, 0x20)
1293                 sourceOffset := add(sourceOffset, 0x20)
1294             }
1295 
1296             /////// Write takerAssetFillAmount ///////
1297             mstore(paramsAreaOffset, takerAssetFillAmount)
1298             paramsAreaOffset := add(paramsAreaOffset, 0x20)
1299 
1300             /////// Write signature ///////
1301             // Write offset to paramsArea
1302             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
1303 
1304             // Calculate length of signature
1305             sourceOffset := signature
1306             arrayLenBytes := mload(sourceOffset)
1307             sourceOffset := add(sourceOffset, 0x20)
1308             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1309 
1310             // Write length of signature
1311             mstore(dataAreaEnd, arrayLenBytes)
1312             dataAreaEnd := add(dataAreaEnd, 0x20)
1313 
1314             // Write contents of signature
1315             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1316                 mstore(dataAreaEnd, mload(sourceOffset))
1317                 dataAreaEnd := add(dataAreaEnd, 0x20)
1318                 sourceOffset := add(sourceOffset, 0x20)
1319             }
1320 
1321             // Set length of calldata
1322             mstore(fillOrderCalldata, sub(dataAreaEnd, add(fillOrderCalldata, 0x20)))
1323 
1324             // Increment free memory pointer
1325             mstore(0x40, dataAreaEnd)
1326         }
1327 
1328         return fillOrderCalldata;
1329     }
1330 }
1331 
1332 contract IOwnable {
1333 
1334     function transferOwnership(address newOwner)
1335         public;
1336 }
1337 
1338 contract IAuthorizable is
1339     IOwnable
1340 {
1341     /// @dev Authorizes an address.
1342     /// @param target Address to authorize.
1343     function addAuthorizedAddress(address target)
1344         external;
1345 
1346     /// @dev Removes authorizion of an address.
1347     /// @param target Address to remove authorization from.
1348     function removeAuthorizedAddress(address target)
1349         external;
1350 
1351     /// @dev Removes authorizion of an address.
1352     /// @param target Address to remove authorization from.
1353     /// @param index Index of target in authorities array.
1354     function removeAuthorizedAddressAtIndex(
1355         address target,
1356         uint256 index
1357     )
1358         external;
1359     
1360     /// @dev Gets all authorized addresses.
1361     /// @return Array of authorized addresses.
1362     function getAuthorizedAddresses()
1363         external
1364         view
1365         returns (address[] memory);
1366 }
1367 
1368 contract IAssetProxy is
1369     IAuthorizable
1370 {
1371     /// @dev Transfers assets. Either succeeds or throws.
1372     /// @param assetData Byte array encoded for the respective asset proxy.
1373     /// @param from Address to transfer asset from.
1374     /// @param to Address to transfer asset to.
1375     /// @param amount Amount of asset to transfer.
1376     function transferFrom(
1377         bytes assetData,
1378         address from,
1379         address to,
1380         uint256 amount
1381     )
1382         external;
1383     
1384     /// @dev Gets the proxy id associated with the proxy address.
1385     /// @return Proxy id.
1386     function getProxyId()
1387         external
1388         pure
1389         returns (bytes4);
1390 }
1391 
1392 contract IValidator {
1393 
1394     /// @dev Verifies that a signature is valid.
1395     /// @param hash Message hash that is signed.
1396     /// @param signerAddress Address that should have signed the given hash.
1397     /// @param signature Proof of signing.
1398     /// @return Validity of order signature.
1399     function isValidSignature(
1400         bytes32 hash,
1401         address signerAddress,
1402         bytes signature
1403     )
1404         external
1405         view
1406         returns (bool isValid);
1407 }
1408 
1409 contract IWallet {
1410 
1411     /// @dev Verifies that a signature is valid.
1412     /// @param hash Message hash that is signed.
1413     /// @param signature Proof of signing.
1414     /// @return Validity of order signature.
1415     function isValidSignature(
1416         bytes32 hash,
1417         bytes signature
1418     )
1419         external
1420         view
1421         returns (bool isValid);
1422 }
1423 
1424 contract IExchangeCore {
1425 
1426     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1427     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1428     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1429     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1430         external;
1431 
1432     /// @dev Fills the input order.
1433     /// @param order Order struct containing order specifications.
1434     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1435     /// @param signature Proof that order has been created by maker.
1436     /// @return Amounts filled and fees paid by maker and taker.
1437     function fillOrder(
1438         LibOrder.Order memory order,
1439         uint256 takerAssetFillAmount,
1440         bytes memory signature
1441     )
1442         public
1443         returns (LibFillResults.FillResults memory fillResults);
1444 
1445     /// @dev After calling, the order can not be filled anymore.
1446     /// @param order Order struct containing order specifications.
1447     function cancelOrder(LibOrder.Order memory order)
1448         public;
1449 
1450     /// @dev Gets information about an order: status, hash, and amount filled.
1451     /// @param order Order to gather information on.
1452     /// @return OrderInfo Information about the order and its state.
1453     ///                   See LibOrder.OrderInfo for a complete description.
1454     function getOrderInfo(LibOrder.Order memory order)
1455         public
1456         view
1457         returns (LibOrder.OrderInfo memory orderInfo);
1458 }
1459 
1460 contract IAssetProxyDispatcher {
1461 
1462     /// @dev Registers an asset proxy to its asset proxy id.
1463     ///      Once an asset proxy is registered, it cannot be unregistered.
1464     /// @param assetProxy Address of new asset proxy to register.
1465     function registerAssetProxy(address assetProxy)
1466         external;
1467 
1468     /// @dev Gets an asset proxy.
1469     /// @param assetProxyId Id of the asset proxy.
1470     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1471     function getAssetProxy(bytes4 assetProxyId)
1472         external
1473         view
1474         returns (address);
1475 }
1476 
1477 contract IMatchOrders {
1478 
1479     /// @dev Match two complementary orders that have a profitable spread.
1480     ///      Each order is filled at their respective price point. However, the calculations are
1481     ///      carried out as though the orders are both being filled at the right order's price point.
1482     ///      The profit made by the left order goes to the taker (who matched the two orders).
1483     /// @param leftOrder First order to match.
1484     /// @param rightOrder Second order to match.
1485     /// @param leftSignature Proof that order was created by the left maker.
1486     /// @param rightSignature Proof that order was created by the right maker.
1487     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
1488     function matchOrders(
1489         LibOrder.Order memory leftOrder,
1490         LibOrder.Order memory rightOrder,
1491         bytes memory leftSignature,
1492         bytes memory rightSignature
1493     )
1494         public
1495         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1496 }
1497 
1498 contract ISignatureValidator {
1499 
1500     /// @dev Approves a hash on-chain using any valid signature type.
1501     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1502     /// @param signerAddress Address that should have signed the given hash.
1503     /// @param signature Proof that the hash has been signed by signer.
1504     function preSign(
1505         bytes32 hash,
1506         address signerAddress,
1507         bytes signature
1508     )
1509         external;
1510     
1511     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1512     /// @param validatorAddress Address of Validator contract.
1513     /// @param approval Approval or disapproval of  Validator contract.
1514     function setSignatureValidatorApproval(
1515         address validatorAddress,
1516         bool approval
1517     )
1518         external;
1519 
1520     /// @dev Verifies that a signature is valid.
1521     /// @param hash Message hash that is signed.
1522     /// @param signerAddress Address of signer.
1523     /// @param signature Proof of signing.
1524     /// @return Validity of order signature.
1525     function isValidSignature(
1526         bytes32 hash,
1527         address signerAddress,
1528         bytes memory signature
1529     )
1530         public
1531         view
1532         returns (bool isValid);
1533 }
1534 
1535 contract ITransactions {
1536 
1537     /// @dev Executes an exchange method call in the context of signer.
1538     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1539     /// @param signerAddress Address of transaction signer.
1540     /// @param data AbiV2 encoded calldata.
1541     /// @param signature Proof of signer transaction by signer.
1542     function executeTransaction(
1543         uint256 salt,
1544         address signerAddress,
1545         bytes data,
1546         bytes signature
1547     )
1548         external;
1549 }
1550 
1551 contract IWrapperFunctions {
1552 
1553     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1554     /// @param order LibOrder.Order struct containing order specifications.
1555     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1556     /// @param signature Proof that order has been created by maker.
1557     function fillOrKillOrder(
1558         LibOrder.Order memory order,
1559         uint256 takerAssetFillAmount,
1560         bytes memory signature
1561     )
1562         public
1563         returns (LibFillResults.FillResults memory fillResults);
1564 
1565     /// @dev Fills an order with specified parameters and ECDSA signature.
1566     ///      Returns false if the transaction would otherwise revert.
1567     /// @param order LibOrder.Order struct containing order specifications.
1568     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1569     /// @param signature Proof that order has been created by maker.
1570     /// @return Amounts filled and fees paid by maker and taker.
1571     function fillOrderNoThrow(
1572         LibOrder.Order memory order,
1573         uint256 takerAssetFillAmount,
1574         bytes memory signature
1575     )
1576         public
1577         returns (LibFillResults.FillResults memory fillResults);
1578 
1579     /// @dev Synchronously executes multiple calls of fillOrder.
1580     /// @param orders Array of order specifications.
1581     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1582     /// @param signatures Proofs that orders have been created by makers.
1583     /// @return Amounts filled and fees paid by makers and taker.
1584     function batchFillOrders(
1585         LibOrder.Order[] memory orders,
1586         uint256[] memory takerAssetFillAmounts,
1587         bytes[] memory signatures
1588     )
1589         public
1590         returns (LibFillResults.FillResults memory totalFillResults);
1591 
1592     /// @dev Synchronously executes multiple calls of fillOrKill.
1593     /// @param orders Array of order specifications.
1594     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1595     /// @param signatures Proofs that orders have been created by makers.
1596     /// @return Amounts filled and fees paid by makers and taker.
1597     function batchFillOrKillOrders(
1598         LibOrder.Order[] memory orders,
1599         uint256[] memory takerAssetFillAmounts,
1600         bytes[] memory signatures
1601     )
1602         public
1603         returns (LibFillResults.FillResults memory totalFillResults);
1604 
1605     /// @dev Fills an order with specified parameters and ECDSA signature.
1606     ///      Returns false if the transaction would otherwise revert.
1607     /// @param orders Array of order specifications.
1608     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1609     /// @param signatures Proofs that orders have been created by makers.
1610     /// @return Amounts filled and fees paid by makers and taker.
1611     function batchFillOrdersNoThrow(
1612         LibOrder.Order[] memory orders,
1613         uint256[] memory takerAssetFillAmounts,
1614         bytes[] memory signatures
1615     )
1616         public
1617         returns (LibFillResults.FillResults memory totalFillResults);
1618 
1619     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1620     /// @param orders Array of order specifications.
1621     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1622     /// @param signatures Proofs that orders have been created by makers.
1623     /// @return Amounts filled and fees paid by makers and taker.
1624     function marketSellOrders(
1625         LibOrder.Order[] memory orders,
1626         uint256 takerAssetFillAmount,
1627         bytes[] memory signatures
1628     )
1629         public
1630         returns (LibFillResults.FillResults memory totalFillResults);
1631 
1632     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1633     ///      Returns false if the transaction would otherwise revert.
1634     /// @param orders Array of order specifications.
1635     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1636     /// @param signatures Proofs that orders have been signed by makers.
1637     /// @return Amounts filled and fees paid by makers and taker.
1638     function marketSellOrdersNoThrow(
1639         LibOrder.Order[] memory orders,
1640         uint256 takerAssetFillAmount,
1641         bytes[] memory signatures
1642     )
1643         public
1644         returns (LibFillResults.FillResults memory totalFillResults);
1645 
1646     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
1647     /// @param orders Array of order specifications.
1648     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1649     /// @param signatures Proofs that orders have been signed by makers.
1650     /// @return Amounts filled and fees paid by makers and taker.
1651     function marketBuyOrders(
1652         LibOrder.Order[] memory orders,
1653         uint256 makerAssetFillAmount,
1654         bytes[] memory signatures
1655     )
1656         public
1657         returns (LibFillResults.FillResults memory totalFillResults);
1658 
1659     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
1660     ///      Returns false if the transaction would otherwise revert.
1661     /// @param orders Array of order specifications.
1662     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1663     /// @param signatures Proofs that orders have been signed by makers.
1664     /// @return Amounts filled and fees paid by makers and taker.
1665     function marketBuyOrdersNoThrow(
1666         LibOrder.Order[] memory orders,
1667         uint256 makerAssetFillAmount,
1668         bytes[] memory signatures
1669     )
1670         public
1671         returns (LibFillResults.FillResults memory totalFillResults);
1672 
1673     /// @dev Synchronously cancels multiple orders in a single transaction.
1674     /// @param orders Array of order specifications.
1675     function batchCancelOrders(LibOrder.Order[] memory orders)
1676         public;
1677 
1678     /// @dev Fetches information for all passed in orders
1679     /// @param orders Array of order specifications.
1680     /// @return Array of OrderInfo instances that correspond to each order.
1681     function getOrdersInfo(LibOrder.Order[] memory orders)
1682         public
1683         view
1684         returns (LibOrder.OrderInfo[] memory);
1685 }
1686 
1687 // solhint-disable no-empty-blocks
1688 contract IExchange is
1689     IExchangeCore,
1690     IMatchOrders,
1691     ISignatureValidator,
1692     ITransactions,
1693     IAssetProxyDispatcher,
1694     IWrapperFunctions
1695 {}
1696 
1697 contract MExchangeCore is
1698     IExchangeCore
1699 {
1700     // Fill event is emitted whenever an order is filled.
1701     event Fill(
1702         address indexed makerAddress,         // Address that created the order.      
1703         address indexed feeRecipientAddress,  // Address that received fees.
1704         address takerAddress,                 // Address that filled the order.
1705         address senderAddress,                // Address that called the Exchange contract (msg.sender).
1706         uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker. 
1707         uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
1708         uint256 makerFeePaid,                 // Amount of ZRX paid to feeRecipient by maker.
1709         uint256 takerFeePaid,                 // Amount of ZRX paid to feeRecipient by taker.
1710         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
1711         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
1712         bytes takerAssetData                  // Encoded data specific to takerAsset.
1713     );
1714 
1715     // Cancel event is emitted whenever an individual order is cancelled.
1716     event Cancel(
1717         address indexed makerAddress,         // Address that created the order.      
1718         address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.   
1719         address senderAddress,                // Address that called the Exchange contract (msg.sender).
1720         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
1721         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
1722         bytes takerAssetData                  // Encoded data specific to takerAsset.
1723     );
1724 
1725     // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
1726     event CancelUpTo(
1727         address indexed makerAddress,         // Orders cancelled must have been created by this address.
1728         address indexed senderAddress,        // Orders cancelled must have a `senderAddress` equal to this address.
1729         uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.
1730     );
1731 
1732     /// @dev Fills the input order.
1733     /// @param order Order struct containing order specifications.
1734     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1735     /// @param signature Proof that order has been created by maker.
1736     /// @return Amounts filled and fees paid by maker and taker.
1737     function fillOrderInternal(
1738         LibOrder.Order memory order,
1739         uint256 takerAssetFillAmount,
1740         bytes memory signature
1741     )
1742         internal
1743         returns (LibFillResults.FillResults memory fillResults);
1744 
1745     /// @dev After calling, the order can not be filled anymore.
1746     /// @param order Order struct containing order specifications.
1747     function cancelOrderInternal(LibOrder.Order memory order)
1748         internal;
1749 
1750     /// @dev Updates state with results of a fill order.
1751     /// @param order that was filled.
1752     /// @param takerAddress Address of taker who filled the order.
1753     /// @param orderTakerAssetFilledAmount Amount of order already filled.
1754     /// @return fillResults Amounts filled and fees paid by maker and taker.
1755     function updateFilledState(
1756         LibOrder.Order memory order,
1757         address takerAddress,
1758         bytes32 orderHash,
1759         uint256 orderTakerAssetFilledAmount,
1760         LibFillResults.FillResults memory fillResults
1761     )
1762         internal;
1763 
1764     /// @dev Updates state with results of cancelling an order.
1765     ///      State is only updated if the order is currently fillable.
1766     ///      Otherwise, updating state would have no effect.
1767     /// @param order that was cancelled.
1768     /// @param orderHash Hash of order that was cancelled.
1769     function updateCancelledState(
1770         LibOrder.Order memory order,
1771         bytes32 orderHash
1772     )
1773         internal;
1774     
1775     /// @dev Validates context for fillOrder. Succeeds or throws.
1776     /// @param order to be filled.
1777     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1778     /// @param takerAddress Address of order taker.
1779     /// @param signature Proof that the orders was created by its maker.
1780     function assertFillableOrder(
1781         LibOrder.Order memory order,
1782         LibOrder.OrderInfo memory orderInfo,
1783         address takerAddress,
1784         bytes memory signature
1785     )
1786         internal
1787         view;
1788     
1789     /// @dev Validates context for fillOrder. Succeeds or throws.
1790     /// @param order to be filled.
1791     /// @param orderInfo Status, orderHash, and amount already filled of order.
1792     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
1793     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
1794     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
1795     function assertValidFill(
1796         LibOrder.Order memory order,
1797         LibOrder.OrderInfo memory orderInfo,
1798         uint256 takerAssetFillAmount,
1799         uint256 takerAssetFilledAmount,
1800         uint256 makerAssetFilledAmount
1801     )
1802         internal
1803         view;
1804 
1805     /// @dev Validates context for cancelOrder. Succeeds or throws.
1806     /// @param order to be cancelled.
1807     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1808     function assertValidCancel(
1809         LibOrder.Order memory order,
1810         LibOrder.OrderInfo memory orderInfo
1811     )
1812         internal
1813         view;
1814 
1815     /// @dev Calculates amounts filled and fees paid by maker and taker.
1816     /// @param order to be filled.
1817     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
1818     /// @return fillResults Amounts filled and fees paid by maker and taker.
1819     function calculateFillResults(
1820         LibOrder.Order memory order,
1821         uint256 takerAssetFilledAmount
1822     )
1823         internal
1824         pure
1825         returns (LibFillResults.FillResults memory fillResults);
1826 
1827 }
1828 
1829 contract MAssetProxyDispatcher is
1830     IAssetProxyDispatcher
1831 {
1832     // Logs registration of new asset proxy
1833     event AssetProxyRegistered(
1834         bytes4 id,              // Id of new registered AssetProxy.
1835         address assetProxy      // Address of new registered AssetProxy.
1836     );
1837 
1838     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
1839     /// @param assetData Byte array encoded for the asset.
1840     /// @param from Address to transfer token from.
1841     /// @param to Address to transfer token to.
1842     /// @param amount Amount of token to transfer.
1843     function dispatchTransferFrom(
1844         bytes memory assetData,
1845         address from,
1846         address to,
1847         uint256 amount
1848     )
1849         internal;
1850 }
1851 
1852 contract MMatchOrders is
1853     IMatchOrders
1854 {
1855     /// @dev Validates context for matchOrders. Succeeds or throws.
1856     /// @param leftOrder First order to match.
1857     /// @param rightOrder Second order to match.
1858     function assertValidMatch(
1859         LibOrder.Order memory leftOrder,
1860         LibOrder.Order memory rightOrder
1861     )
1862         internal
1863         pure;
1864 
1865     /// @dev Calculates fill amounts for the matched orders.
1866     ///      Each order is filled at their respective price point. However, the calculations are
1867     ///      carried out as though the orders are both being filled at the right order's price point.
1868     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
1869     /// @param leftOrder First order to match.
1870     /// @param rightOrder Second order to match.
1871     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
1872     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
1873     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
1874     function calculateMatchedFillResults(
1875         LibOrder.Order memory leftOrder,
1876         LibOrder.Order memory rightOrder,
1877         uint256 leftOrderTakerAssetFilledAmount,
1878         uint256 rightOrderTakerAssetFilledAmount
1879     )
1880         internal
1881         pure
1882         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1883 
1884 }
1885 
1886 contract MSignatureValidator is
1887     ISignatureValidator
1888 {
1889     event SignatureValidatorApproval(
1890         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
1891         address indexed validatorAddress,  // Address of signature validator contract.
1892         bool approved                      // Approval or disapproval of validator contract.
1893     );
1894 
1895     // Allowed signature types.
1896     enum SignatureType {
1897         Illegal,         // 0x00, default value
1898         Invalid,         // 0x01
1899         EIP712,          // 0x02
1900         EthSign,         // 0x03
1901         Wallet,          // 0x04
1902         Validator,       // 0x05
1903         PreSigned,       // 0x06
1904         NSignatureTypes  // 0x07, number of signature types. Always leave at end.
1905     }
1906 
1907     /// @dev Verifies signature using logic defined by Wallet contract.
1908     /// @param hash Any 32 byte hash.
1909     /// @param walletAddress Address that should have signed the given hash
1910     ///                      and defines its own signature verification method.
1911     /// @param signature Proof that the hash has been signed by signer.
1912     /// @return True if the address recovered from the provided signature matches the input signer address.
1913     function isValidWalletSignature(
1914         bytes32 hash,
1915         address walletAddress,
1916         bytes signature
1917     )
1918         internal
1919         view
1920         returns (bool isValid);
1921 
1922     /// @dev Verifies signature using logic defined by Validator contract.
1923     /// @param validatorAddress Address of validator contract.
1924     /// @param hash Any 32 byte hash.
1925     /// @param signerAddress Address that should have signed the given hash.
1926     /// @param signature Proof that the hash has been signed by signer.
1927     /// @return True if the address recovered from the provided signature matches the input signer address.
1928     function isValidValidatorSignature(
1929         address validatorAddress,
1930         bytes32 hash,
1931         address signerAddress,
1932         bytes signature
1933     )
1934         internal
1935         view
1936         returns (bool isValid);
1937 }
1938 
1939 contract MTransactions is
1940     ITransactions
1941 {
1942     // Hash for the EIP712 ZeroEx Transaction Schema
1943     bytes32 constant internal EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = keccak256(abi.encodePacked(
1944         "ZeroExTransaction(",
1945         "uint256 salt,",
1946         "address signerAddress,",
1947         "bytes data",
1948         ")"
1949     ));
1950 
1951     /// @dev Calculates EIP712 hash of the Transaction.
1952     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1953     /// @param signerAddress Address of transaction signer.
1954     /// @param data AbiV2 encoded calldata.
1955     /// @return EIP712 hash of the Transaction.
1956     function hashZeroExTransaction(
1957         uint256 salt,
1958         address signerAddress,
1959         bytes memory data
1960     )
1961         internal
1962         pure
1963         returns (bytes32 result);
1964 
1965     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
1966     ///      If calling a fill function, this address will represent the taker.
1967     ///      If calling a cancel function, this address will represent the maker.
1968     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
1969     ///         `msg.sender` if entry point is any other function.
1970     function getCurrentContextAddress()
1971         internal
1972         view
1973         returns (address);
1974 }
1975 
1976 contract MWrapperFunctions is 
1977     IWrapperFunctions
1978 {
1979     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1980     /// @param order LibOrder.Order struct containing order specifications.
1981     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1982     /// @param signature Proof that order has been created by maker.
1983     function fillOrKillOrderInternal(
1984         LibOrder.Order memory order,
1985         uint256 takerAssetFillAmount,
1986         bytes memory signature
1987     )
1988         internal
1989         returns (LibFillResults.FillResults memory fillResults);
1990 }
1991 
1992 contract Ownable is
1993     IOwnable
1994 {
1995     address public owner;
1996 
1997     constructor ()
1998         public
1999     {
2000         owner = msg.sender;
2001     }
2002 
2003     modifier onlyOwner() {
2004         require(
2005             msg.sender == owner,
2006             "ONLY_CONTRACT_OWNER"
2007         );
2008         _;
2009     }
2010 
2011     function transferOwnership(address newOwner)
2012         public
2013         onlyOwner
2014     {
2015         if (newOwner != address(0)) {
2016             owner = newOwner;
2017         }
2018     }
2019 }
2020 
2021 contract MixinExchangeCore is
2022     ReentrancyGuard,
2023     LibConstants,
2024     LibMath,
2025     LibOrder,
2026     LibFillResults,
2027     MAssetProxyDispatcher,
2028     MExchangeCore,
2029     MSignatureValidator,
2030     MTransactions
2031 {
2032     // Mapping of orderHash => amount of takerAsset already bought by maker
2033     mapping (bytes32 => uint256) public filled;
2034 
2035     // Mapping of orderHash => cancelled
2036     mapping (bytes32 => bool) public cancelled;
2037 
2038     // Mapping of makerAddress => senderAddress => lowest salt an order can have in order to be fillable
2039     // Orders with specified senderAddress and with a salt less than their epoch are considered cancelled
2040     mapping (address => mapping (address => uint256)) public orderEpoch;
2041 
2042     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
2043     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
2044     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
2045     function cancelOrdersUpTo(uint256 targetOrderEpoch)
2046         external
2047         nonReentrant
2048     {
2049         address makerAddress = getCurrentContextAddress();
2050         // If this function is called via `executeTransaction`, we only update the orderEpoch for the makerAddress/msg.sender combination.
2051         // This allows external filter contracts to add rules to how orders are cancelled via this function.
2052         address senderAddress = makerAddress == msg.sender ? address(0) : msg.sender;
2053 
2054         // orderEpoch is initialized to 0, so to cancelUpTo we need salt + 1
2055         uint256 newOrderEpoch = targetOrderEpoch + 1;  
2056         uint256 oldOrderEpoch = orderEpoch[makerAddress][senderAddress];
2057 
2058         // Ensure orderEpoch is monotonically increasing
2059         require(
2060             newOrderEpoch > oldOrderEpoch, 
2061             "INVALID_NEW_ORDER_EPOCH"
2062         );
2063 
2064         // Update orderEpoch
2065         orderEpoch[makerAddress][senderAddress] = newOrderEpoch;
2066         emit CancelUpTo(
2067             makerAddress,
2068             senderAddress,
2069             newOrderEpoch
2070         );
2071     }
2072 
2073     /// @dev Fills the input order.
2074     /// @param order Order struct containing order specifications.
2075     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2076     /// @param signature Proof that order has been created by maker.
2077     /// @return Amounts filled and fees paid by maker and taker.
2078     function fillOrder(
2079         Order memory order,
2080         uint256 takerAssetFillAmount,
2081         bytes memory signature
2082     )
2083         public
2084         nonReentrant
2085         returns (FillResults memory fillResults)
2086     {
2087         fillResults = fillOrderInternal(
2088             order,
2089             takerAssetFillAmount,
2090             signature
2091         );
2092         return fillResults;
2093     }
2094 
2095     /// @dev After calling, the order can not be filled anymore.
2096     ///      Throws if order is invalid or sender does not have permission to cancel.
2097     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
2098     function cancelOrder(Order memory order)
2099         public
2100         nonReentrant
2101     {
2102         cancelOrderInternal(order);
2103     }
2104 
2105     /// @dev Gets information about an order: status, hash, and amount filled.
2106     /// @param order Order to gather information on.
2107     /// @return OrderInfo Information about the order and its state.
2108     ///         See LibOrder.OrderInfo for a complete description.
2109     function getOrderInfo(Order memory order)
2110         public
2111         view
2112         returns (OrderInfo memory orderInfo)
2113     {
2114         // Compute the order hash
2115         orderInfo.orderHash = getOrderHash(order);
2116 
2117         // Fetch filled amount
2118         orderInfo.orderTakerAssetFilledAmount = filled[orderInfo.orderHash];
2119 
2120         // If order.makerAssetAmount is zero, we also reject the order.
2121         // While the Exchange contract handles them correctly, they create
2122         // edge cases in the supporting infrastructure because they have
2123         // an 'infinite' price when computed by a simple division.
2124         if (order.makerAssetAmount == 0) {
2125             orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_ASSET_AMOUNT);
2126             return orderInfo;
2127         }
2128 
2129         // If order.takerAssetAmount is zero, then the order will always
2130         // be considered filled because 0 == takerAssetAmount == orderTakerAssetFilledAmount
2131         // Instead of distinguishing between unfilled and filled zero taker
2132         // amount orders, we choose not to support them.
2133         if (order.takerAssetAmount == 0) {
2134             orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_ASSET_AMOUNT);
2135             return orderInfo;
2136         }
2137 
2138         // Validate order availability
2139         if (orderInfo.orderTakerAssetFilledAmount >= order.takerAssetAmount) {
2140             orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
2141             return orderInfo;
2142         }
2143 
2144         // Validate order expiration
2145         // solhint-disable-next-line not-rely-on-time
2146         if (block.timestamp >= order.expirationTimeSeconds) {
2147             orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
2148             return orderInfo;
2149         }
2150 
2151         // Check if order has been cancelled
2152         if (cancelled[orderInfo.orderHash]) {
2153             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
2154             return orderInfo;
2155         }
2156         if (orderEpoch[order.makerAddress][order.senderAddress] > order.salt) {
2157             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
2158             return orderInfo;
2159         }
2160 
2161         // All other statuses are ruled out: order is Fillable
2162         orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
2163         return orderInfo;
2164     }
2165 
2166     /// @dev Fills the input order.
2167     /// @param order Order struct containing order specifications.
2168     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2169     /// @param signature Proof that order has been created by maker.
2170     /// @return Amounts filled and fees paid by maker and taker.
2171     function fillOrderInternal(
2172         Order memory order,
2173         uint256 takerAssetFillAmount,
2174         bytes memory signature
2175     )
2176         internal
2177         returns (FillResults memory fillResults)
2178     {
2179         // Fetch order info
2180         OrderInfo memory orderInfo = getOrderInfo(order);
2181 
2182         // Fetch taker address
2183         address takerAddress = getCurrentContextAddress();
2184         
2185         // Assert that the order is fillable by taker
2186         assertFillableOrder(
2187             order,
2188             orderInfo,
2189             takerAddress,
2190             signature
2191         );
2192         
2193         // Get amount of takerAsset to fill
2194         uint256 remainingTakerAssetAmount = safeSub(order.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount);
2195         uint256 takerAssetFilledAmount = min256(takerAssetFillAmount, remainingTakerAssetAmount);
2196 
2197         // Validate context
2198         assertValidFill(
2199             order,
2200             orderInfo,
2201             takerAssetFillAmount,
2202             takerAssetFilledAmount,
2203             fillResults.makerAssetFilledAmount
2204         );
2205 
2206         // Compute proportional fill amounts
2207         fillResults = calculateFillResults(order, takerAssetFilledAmount);
2208 
2209         // Update exchange internal state
2210         updateFilledState(
2211             order,
2212             takerAddress,
2213             orderInfo.orderHash,
2214             orderInfo.orderTakerAssetFilledAmount,
2215             fillResults
2216         );
2217     
2218         // Settle order
2219         settleOrder(
2220             order,
2221             takerAddress,
2222             fillResults
2223         );
2224 
2225         return fillResults;
2226     }
2227 
2228     /// @dev After calling, the order can not be filled anymore.
2229     ///      Throws if order is invalid or sender does not have permission to cancel.
2230     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
2231     function cancelOrderInternal(Order memory order)
2232         internal
2233     {
2234         // Fetch current order status
2235         OrderInfo memory orderInfo = getOrderInfo(order);
2236 
2237         // Validate context
2238         assertValidCancel(order, orderInfo);
2239 
2240         // Perform cancel
2241         updateCancelledState(order, orderInfo.orderHash);
2242     }
2243 
2244     /// @dev Updates state with results of a fill order.
2245     /// @param order that was filled.
2246     /// @param takerAddress Address of taker who filled the order.
2247     /// @param orderTakerAssetFilledAmount Amount of order already filled.
2248     function updateFilledState(
2249         Order memory order,
2250         address takerAddress,
2251         bytes32 orderHash,
2252         uint256 orderTakerAssetFilledAmount,
2253         FillResults memory fillResults
2254     )
2255         internal
2256     {
2257         // Update state
2258         filled[orderHash] = safeAdd(orderTakerAssetFilledAmount, fillResults.takerAssetFilledAmount);
2259 
2260         // Log order
2261         emit Fill(
2262             order.makerAddress,
2263             order.feeRecipientAddress,
2264             takerAddress,
2265             msg.sender,
2266             fillResults.makerAssetFilledAmount,
2267             fillResults.takerAssetFilledAmount,
2268             fillResults.makerFeePaid,
2269             fillResults.takerFeePaid,
2270             orderHash,
2271             order.makerAssetData,
2272             order.takerAssetData
2273         );
2274     }
2275 
2276     /// @dev Updates state with results of cancelling an order.
2277     ///      State is only updated if the order is currently fillable.
2278     ///      Otherwise, updating state would have no effect.
2279     /// @param order that was cancelled.
2280     /// @param orderHash Hash of order that was cancelled.
2281     function updateCancelledState(
2282         Order memory order,
2283         bytes32 orderHash
2284     )
2285         internal
2286     {
2287         // Perform cancel
2288         cancelled[orderHash] = true;
2289 
2290         // Log cancel
2291         emit Cancel(
2292             order.makerAddress,
2293             order.feeRecipientAddress,
2294             msg.sender,
2295             orderHash,
2296             order.makerAssetData,
2297             order.takerAssetData
2298         );
2299     }
2300     
2301     /// @dev Validates context for fillOrder. Succeeds or throws.
2302     /// @param order to be filled.
2303     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2304     /// @param takerAddress Address of order taker.
2305     /// @param signature Proof that the orders was created by its maker.
2306     function assertFillableOrder(
2307         Order memory order,
2308         OrderInfo memory orderInfo,
2309         address takerAddress,
2310         bytes memory signature
2311     )
2312         internal
2313         view
2314     {
2315         // An order can only be filled if its status is FILLABLE.
2316         require(
2317             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2318             "ORDER_UNFILLABLE"
2319         );
2320         
2321         // Validate sender is allowed to fill this order
2322         if (order.senderAddress != address(0)) {
2323             require(
2324                 order.senderAddress == msg.sender,
2325                 "INVALID_SENDER"
2326             );
2327         }
2328         
2329         // Validate taker is allowed to fill this order
2330         if (order.takerAddress != address(0)) {
2331             require(
2332                 order.takerAddress == takerAddress,
2333                 "INVALID_TAKER"
2334             );
2335         }
2336         
2337         // Validate Maker signature (check only if first time seen)
2338         if (orderInfo.orderTakerAssetFilledAmount == 0) {
2339             require(
2340                 isValidSignature(
2341                     orderInfo.orderHash,
2342                     order.makerAddress,
2343                     signature
2344                 ),
2345                 "INVALID_ORDER_SIGNATURE"
2346             );
2347         }
2348     }
2349     
2350     /// @dev Validates context for fillOrder. Succeeds or throws.
2351     /// @param order to be filled.
2352     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2353     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
2354     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2355     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
2356     function assertValidFill(
2357         Order memory order,
2358         OrderInfo memory orderInfo,
2359         uint256 takerAssetFillAmount,  // TODO: use FillResults
2360         uint256 takerAssetFilledAmount,
2361         uint256 makerAssetFilledAmount
2362     )
2363         internal
2364         view
2365     {
2366         // Revert if fill amount is invalid
2367         // TODO: reconsider necessity for v2.1
2368         require(
2369             takerAssetFillAmount != 0,
2370             "INVALID_TAKER_AMOUNT"
2371         );
2372         
2373         // Make sure taker does not pay more than desired amount
2374         // NOTE: This assertion should never fail, it is here
2375         //       as an extra defence against potential bugs.
2376         require(
2377             takerAssetFilledAmount <= takerAssetFillAmount,
2378             "TAKER_OVERPAY"
2379         );
2380         
2381         // Make sure order is not overfilled
2382         // NOTE: This assertion should never fail, it is here
2383         //       as an extra defence against potential bugs.
2384         require(
2385             safeAdd(orderInfo.orderTakerAssetFilledAmount, takerAssetFilledAmount) <= order.takerAssetAmount,
2386             "ORDER_OVERFILL"
2387         );
2388         
2389         // Make sure order is filled at acceptable price.
2390         // The order has an implied price from the makers perspective:
2391         //    order price = order.makerAssetAmount / order.takerAssetAmount
2392         // i.e. the number of makerAsset maker is paying per takerAsset. The
2393         // maker is guaranteed to get this price or a better (lower) one. The
2394         // actual price maker is getting in this fill is:
2395         //    fill price = makerAssetFilledAmount / takerAssetFilledAmount
2396         // We need `fill price <= order price` for the fill to be fair to maker.
2397         // This amounts to:
2398         //     makerAssetFilledAmount        order.makerAssetAmount
2399         //    ------------------------  <=  -----------------------
2400         //     takerAssetFilledAmount        order.takerAssetAmount
2401         // or, equivalently:
2402         //     makerAssetFilledAmount * order.takerAssetAmount <=
2403         //     order.makerAssetAmount * takerAssetFilledAmount
2404         // NOTE: This assertion should never fail, it is here
2405         //       as an extra defence against potential bugs.
2406         require(
2407             safeMul(makerAssetFilledAmount, order.takerAssetAmount)
2408             <= 
2409             safeMul(order.makerAssetAmount, takerAssetFilledAmount),
2410             "INVALID_FILL_PRICE"
2411         );
2412     }
2413 
2414     /// @dev Validates context for cancelOrder. Succeeds or throws.
2415     /// @param order to be cancelled.
2416     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2417     function assertValidCancel(
2418         Order memory order,
2419         OrderInfo memory orderInfo
2420     )
2421         internal
2422         view
2423     {
2424         // Ensure order is valid
2425         // An order can only be cancelled if its status is FILLABLE.
2426         require(
2427             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2428             "ORDER_UNFILLABLE"
2429         );
2430 
2431         // Validate sender is allowed to cancel this order
2432         if (order.senderAddress != address(0)) {
2433             require(
2434                 order.senderAddress == msg.sender,
2435                 "INVALID_SENDER"
2436             );
2437         }
2438 
2439         // Validate transaction signed by maker
2440         address makerAddress = getCurrentContextAddress();
2441         require(
2442             order.makerAddress == makerAddress,
2443             "INVALID_MAKER"
2444         );
2445     }
2446 
2447     /// @dev Calculates amounts filled and fees paid by maker and taker.
2448     /// @param order to be filled.
2449     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2450     /// @return fillResults Amounts filled and fees paid by maker and taker.
2451     function calculateFillResults(
2452         Order memory order,
2453         uint256 takerAssetFilledAmount
2454     )
2455         internal
2456         pure
2457         returns (FillResults memory fillResults)
2458     {
2459         // Compute proportional transfer amounts
2460         fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
2461         fillResults.makerAssetFilledAmount = safeGetPartialAmountFloor(
2462             takerAssetFilledAmount,
2463             order.takerAssetAmount,
2464             order.makerAssetAmount
2465         );
2466         fillResults.makerFeePaid = safeGetPartialAmountFloor(
2467             fillResults.makerAssetFilledAmount,
2468             order.makerAssetAmount,
2469             order.makerFee
2470         );
2471         fillResults.takerFeePaid = safeGetPartialAmountFloor(
2472             takerAssetFilledAmount,
2473             order.takerAssetAmount,
2474             order.takerFee
2475         );
2476 
2477         return fillResults;
2478     }
2479 
2480     /// @dev Settles an order by transferring assets between counterparties.
2481     /// @param order Order struct containing order specifications.
2482     /// @param takerAddress Address selling takerAsset and buying makerAsset.
2483     /// @param fillResults Amounts to be filled and fees paid by maker and taker.
2484     function settleOrder(
2485         LibOrder.Order memory order,
2486         address takerAddress,
2487         LibFillResults.FillResults memory fillResults
2488     )
2489         private
2490     {
2491         bytes memory zrxAssetData = ZRX_ASSET_DATA;
2492         dispatchTransferFrom(
2493             order.makerAssetData,
2494             order.makerAddress,
2495             takerAddress,
2496             fillResults.makerAssetFilledAmount
2497         );
2498         dispatchTransferFrom(
2499             order.takerAssetData,
2500             takerAddress,
2501             order.makerAddress,
2502             fillResults.takerAssetFilledAmount
2503         );
2504         dispatchTransferFrom(
2505             zrxAssetData,
2506             order.makerAddress,
2507             order.feeRecipientAddress,
2508             fillResults.makerFeePaid
2509         );
2510         dispatchTransferFrom(
2511             zrxAssetData,
2512             takerAddress,
2513             order.feeRecipientAddress,
2514             fillResults.takerFeePaid
2515         );
2516     }
2517 }
2518 
2519 contract MixinSignatureValidator is
2520     ReentrancyGuard,
2521     MSignatureValidator,
2522     MTransactions
2523 {
2524     using LibBytes for bytes;
2525     
2526     // Mapping of hash => signer => signed
2527     mapping (bytes32 => mapping (address => bool)) public preSigned;
2528 
2529     // Mapping of signer => validator => approved
2530     mapping (address => mapping (address => bool)) public allowedValidators;
2531 
2532     /// @dev Approves a hash on-chain using any valid signature type.
2533     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
2534     /// @param signerAddress Address that should have signed the given hash.
2535     /// @param signature Proof that the hash has been signed by signer.
2536     function preSign(
2537         bytes32 hash,
2538         address signerAddress,
2539         bytes signature
2540     )
2541         external
2542     {
2543         if (signerAddress != msg.sender) {
2544             require(
2545                 isValidSignature(
2546                     hash,
2547                     signerAddress,
2548                     signature
2549                 ),
2550                 "INVALID_SIGNATURE"
2551             );
2552         }
2553         preSigned[hash][signerAddress] = true;
2554     }
2555 
2556     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
2557     /// @param validatorAddress Address of Validator contract.
2558     /// @param approval Approval or disapproval of  Validator contract.
2559     function setSignatureValidatorApproval(
2560         address validatorAddress,
2561         bool approval
2562     )
2563         external
2564         nonReentrant
2565     {
2566         address signerAddress = getCurrentContextAddress();
2567         allowedValidators[signerAddress][validatorAddress] = approval;
2568         emit SignatureValidatorApproval(
2569             signerAddress,
2570             validatorAddress,
2571             approval
2572         );
2573     }
2574 
2575     /// @dev Verifies that a hash has been signed by the given signer.
2576     /// @param hash Any 32 byte hash.
2577     /// @param signerAddress Address that should have signed the given hash.
2578     /// @param signature Proof that the hash has been signed by signer.
2579     /// @return True if the address recovered from the provided signature matches the input signer address.
2580     function isValidSignature(
2581         bytes32 hash,
2582         address signerAddress,
2583         bytes memory signature
2584     )
2585         public
2586         view
2587         returns (bool isValid)
2588     {
2589         require(
2590             signature.length > 0,
2591             "LENGTH_GREATER_THAN_0_REQUIRED"
2592         );
2593 
2594         // Pop last byte off of signature byte array.
2595         uint8 signatureTypeRaw = uint8(signature.popLastByte());
2596 
2597         // Ensure signature is supported
2598         require(
2599             signatureTypeRaw < uint8(SignatureType.NSignatureTypes),
2600             "SIGNATURE_UNSUPPORTED"
2601         );
2602 
2603         SignatureType signatureType = SignatureType(signatureTypeRaw);
2604 
2605         // Variables are not scoped in Solidity.
2606         uint8 v;
2607         bytes32 r;
2608         bytes32 s;
2609         address recovered;
2610 
2611         // Always illegal signature.
2612         // This is always an implicit option since a signer can create a
2613         // signature array with invalid type or length. We may as well make
2614         // it an explicit option. This aids testing and analysis. It is
2615         // also the initialization value for the enum type.
2616         if (signatureType == SignatureType.Illegal) {
2617             revert("SIGNATURE_ILLEGAL");
2618 
2619         // Always invalid signature.
2620         // Like Illegal, this is always implicitly available and therefore
2621         // offered explicitly. It can be implicitly created by providing
2622         // a correctly formatted but incorrect signature.
2623         } else if (signatureType == SignatureType.Invalid) {
2624             require(
2625                 signature.length == 0,
2626                 "LENGTH_0_REQUIRED"
2627             );
2628             isValid = false;
2629             return isValid;
2630 
2631         // Signature using EIP712
2632         } else if (signatureType == SignatureType.EIP712) {
2633             require(
2634                 signature.length == 65,
2635                 "LENGTH_65_REQUIRED"
2636             );
2637             v = uint8(signature[0]);
2638             r = signature.readBytes32(1);
2639             s = signature.readBytes32(33);
2640             recovered = ecrecover(
2641                 hash,
2642                 v,
2643                 r,
2644                 s
2645             );
2646             isValid = signerAddress == recovered;
2647             return isValid;
2648 
2649         // Signed using web3.eth_sign
2650         } else if (signatureType == SignatureType.EthSign) {
2651             require(
2652                 signature.length == 65,
2653                 "LENGTH_65_REQUIRED"
2654             );
2655             v = uint8(signature[0]);
2656             r = signature.readBytes32(1);
2657             s = signature.readBytes32(33);
2658             recovered = ecrecover(
2659                 keccak256(abi.encodePacked(
2660                     "\x19Ethereum Signed Message:\n32",
2661                     hash
2662                 )),
2663                 v,
2664                 r,
2665                 s
2666             );
2667             isValid = signerAddress == recovered;
2668             return isValid;
2669 
2670         // Signature verified by wallet contract.
2671         // If used with an order, the maker of the order is the wallet contract.
2672         } else if (signatureType == SignatureType.Wallet) {
2673             isValid = isValidWalletSignature(
2674                 hash,
2675                 signerAddress,
2676                 signature
2677             );
2678             return isValid;
2679 
2680         // Signature verified by validator contract.
2681         // If used with an order, the maker of the order can still be an EOA.
2682         // A signature using this type should be encoded as:
2683         // | Offset   | Length | Contents                        |
2684         // | 0x00     | x      | Signature to validate           |
2685         // | 0x00 + x | 20     | Address of validator contract   |
2686         // | 0x14 + x | 1      | Signature type is always "\x06" |
2687         } else if (signatureType == SignatureType.Validator) {
2688             // Pop last 20 bytes off of signature byte array.
2689             address validatorAddress = signature.popLast20Bytes();
2690             
2691             // Ensure signer has approved validator.
2692             if (!allowedValidators[signerAddress][validatorAddress]) {
2693                 return false;
2694             }
2695             isValid = isValidValidatorSignature(
2696                 validatorAddress,
2697                 hash,
2698                 signerAddress,
2699                 signature
2700             );
2701             return isValid;
2702 
2703         // Signer signed hash previously using the preSign function.
2704         } else if (signatureType == SignatureType.PreSigned) {
2705             isValid = preSigned[hash][signerAddress];
2706             return isValid;
2707         }
2708 
2709         // Anything else is illegal (We do not return false because
2710         // the signature may actually be valid, just not in a format
2711         // that we currently support. In this case returning false
2712         // may lead the caller to incorrectly believe that the
2713         // signature was invalid.)
2714         revert("SIGNATURE_UNSUPPORTED");
2715     }
2716 
2717     /// @dev Verifies signature using logic defined by Wallet contract.
2718     /// @param hash Any 32 byte hash.
2719     /// @param walletAddress Address that should have signed the given hash
2720     ///                      and defines its own signature verification method.
2721     /// @param signature Proof that the hash has been signed by signer.
2722     /// @return True if signature is valid for given wallet..
2723     function isValidWalletSignature(
2724         bytes32 hash,
2725         address walletAddress,
2726         bytes signature
2727     )
2728         internal
2729         view
2730         returns (bool isValid)
2731     {
2732         bytes memory calldata = abi.encodeWithSelector(
2733             IWallet(walletAddress).isValidSignature.selector,
2734             hash,
2735             signature
2736         );
2737         assembly {
2738             let cdStart := add(calldata, 32)
2739             let success := staticcall(
2740                 gas,              // forward all gas
2741                 walletAddress,    // address of Wallet contract
2742                 cdStart,          // pointer to start of input
2743                 mload(calldata),  // length of input
2744                 cdStart,          // write output over input
2745                 32                // output size is 32 bytes
2746             )
2747 
2748             switch success
2749             case 0 {
2750                 // Revert with `Error("WALLET_ERROR")`
2751                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
2752                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
2753                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
2754                 mstore(96, 0)
2755                 revert(0, 100)
2756             }
2757             case 1 {
2758                 // Signature is valid if call did not revert and returned true
2759                 isValid := mload(cdStart)
2760             }
2761         }
2762         return isValid;
2763     }
2764 
2765     /// @dev Verifies signature using logic defined by Validator contract.
2766     /// @param validatorAddress Address of validator contract.
2767     /// @param hash Any 32 byte hash.
2768     /// @param signerAddress Address that should have signed the given hash.
2769     /// @param signature Proof that the hash has been signed by signer.
2770     /// @return True if the address recovered from the provided signature matches the input signer address.
2771     function isValidValidatorSignature(
2772         address validatorAddress,
2773         bytes32 hash,
2774         address signerAddress,
2775         bytes signature
2776     )
2777         internal
2778         view
2779         returns (bool isValid)
2780     {
2781         bytes memory calldata = abi.encodeWithSelector(
2782             IValidator(signerAddress).isValidSignature.selector,
2783             hash,
2784             signerAddress,
2785             signature
2786         );
2787         assembly {
2788             let cdStart := add(calldata, 32)
2789             let success := staticcall(
2790                 gas,               // forward all gas
2791                 validatorAddress,  // address of Validator contract
2792                 cdStart,           // pointer to start of input
2793                 mload(calldata),   // length of input
2794                 cdStart,           // write output over input
2795                 32                 // output size is 32 bytes
2796             )
2797 
2798             switch success
2799             case 0 {
2800                 // Revert with `Error("VALIDATOR_ERROR")`
2801                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
2802                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
2803                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
2804                 mstore(96, 0)
2805                 revert(0, 100)
2806             }
2807             case 1 {
2808                 // Signature is valid if call did not revert and returned true
2809                 isValid := mload(cdStart)
2810             }
2811         }
2812         return isValid;
2813     }
2814 }
2815 
2816 contract MixinWrapperFunctions is
2817     ReentrancyGuard,
2818     LibMath,
2819     LibFillResults,
2820     LibAbiEncoder,
2821     MExchangeCore,
2822     MWrapperFunctions
2823 {
2824     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
2825     /// @param order Order struct containing order specifications.
2826     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2827     /// @param signature Proof that order has been created by maker.
2828     function fillOrKillOrder(
2829         LibOrder.Order memory order,
2830         uint256 takerAssetFillAmount,
2831         bytes memory signature
2832     )
2833         public
2834         nonReentrant
2835         returns (FillResults memory fillResults)
2836     {
2837         fillResults = fillOrKillOrderInternal(
2838             order,
2839             takerAssetFillAmount,
2840             signature
2841         );
2842         return fillResults;
2843     }
2844 
2845     /// @dev Fills the input order.
2846     ///      Returns false if the transaction would otherwise revert.
2847     /// @param order Order struct containing order specifications.
2848     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2849     /// @param signature Proof that order has been created by maker.
2850     /// @return Amounts filled and fees paid by maker and taker.
2851     function fillOrderNoThrow(
2852         LibOrder.Order memory order,
2853         uint256 takerAssetFillAmount,
2854         bytes memory signature
2855     )
2856         public
2857         returns (FillResults memory fillResults)
2858     {
2859         // ABI encode calldata for `fillOrder`
2860         bytes memory fillOrderCalldata = abiEncodeFillOrder(
2861             order,
2862             takerAssetFillAmount,
2863             signature
2864         );
2865 
2866         // Delegate to `fillOrder` and handle any exceptions gracefully
2867         assembly {
2868             let success := delegatecall(
2869                 gas,                                // forward all gas
2870                 address,                            // call address of this contract
2871                 add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
2872                 mload(fillOrderCalldata),           // length of input
2873                 fillOrderCalldata,                  // write output over input
2874                 128                                 // output size is 128 bytes
2875             )
2876             if success {
2877                 mstore(fillResults, mload(fillOrderCalldata))
2878                 mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
2879                 mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
2880                 mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
2881             }
2882         }
2883         // fillResults values will be 0 by default if call was unsuccessful
2884         return fillResults;
2885     }
2886 
2887     /// @dev Synchronously executes multiple calls of fillOrder.
2888     /// @param orders Array of order specifications.
2889     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2890     /// @param signatures Proofs that orders have been created by makers.
2891     /// @return Amounts filled and fees paid by makers and taker.
2892     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2893     function batchFillOrders(
2894         LibOrder.Order[] memory orders,
2895         uint256[] memory takerAssetFillAmounts,
2896         bytes[] memory signatures
2897     )
2898         public
2899         nonReentrant
2900         returns (FillResults memory totalFillResults)
2901     {
2902         uint256 ordersLength = orders.length;
2903         for (uint256 i = 0; i != ordersLength; i++) {
2904             FillResults memory singleFillResults = fillOrderInternal(
2905                 orders[i],
2906                 takerAssetFillAmounts[i],
2907                 signatures[i]
2908             );
2909             addFillResults(totalFillResults, singleFillResults);
2910         }
2911         return totalFillResults;
2912     }
2913 
2914     /// @dev Synchronously executes multiple calls of fillOrKill.
2915     /// @param orders Array of order specifications.
2916     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2917     /// @param signatures Proofs that orders have been created by makers.
2918     /// @return Amounts filled and fees paid by makers and taker.
2919     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2920     function batchFillOrKillOrders(
2921         LibOrder.Order[] memory orders,
2922         uint256[] memory takerAssetFillAmounts,
2923         bytes[] memory signatures
2924     )
2925         public
2926         nonReentrant
2927         returns (FillResults memory totalFillResults)
2928     {
2929         uint256 ordersLength = orders.length;
2930         for (uint256 i = 0; i != ordersLength; i++) {
2931             FillResults memory singleFillResults = fillOrKillOrderInternal(
2932                 orders[i],
2933                 takerAssetFillAmounts[i],
2934                 signatures[i]
2935             );
2936             addFillResults(totalFillResults, singleFillResults);
2937         }
2938         return totalFillResults;
2939     }
2940 
2941     /// @dev Fills an order with specified parameters and ECDSA signature.
2942     ///      Returns false if the transaction would otherwise revert.
2943     /// @param orders Array of order specifications.
2944     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2945     /// @param signatures Proofs that orders have been created by makers.
2946     /// @return Amounts filled and fees paid by makers and taker.
2947     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2948     function batchFillOrdersNoThrow(
2949         LibOrder.Order[] memory orders,
2950         uint256[] memory takerAssetFillAmounts,
2951         bytes[] memory signatures
2952     )
2953         public
2954         returns (FillResults memory totalFillResults)
2955     {
2956         uint256 ordersLength = orders.length;
2957         for (uint256 i = 0; i != ordersLength; i++) {
2958             FillResults memory singleFillResults = fillOrderNoThrow(
2959                 orders[i],
2960                 takerAssetFillAmounts[i],
2961                 signatures[i]
2962             );
2963             addFillResults(totalFillResults, singleFillResults);
2964         }
2965         return totalFillResults;
2966     }
2967 
2968     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
2969     /// @param orders Array of order specifications.
2970     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2971     /// @param signatures Proofs that orders have been created by makers.
2972     /// @return Amounts filled and fees paid by makers and taker.
2973     function marketSellOrders(
2974         LibOrder.Order[] memory orders,
2975         uint256 takerAssetFillAmount,
2976         bytes[] memory signatures
2977     )
2978         public
2979         nonReentrant
2980         returns (FillResults memory totalFillResults)
2981     {
2982         bytes memory takerAssetData = orders[0].takerAssetData;
2983     
2984         uint256 ordersLength = orders.length;
2985         for (uint256 i = 0; i != ordersLength; i++) {
2986 
2987             // We assume that asset being sold by taker is the same for each order.
2988             // Rather than passing this in as calldata, we use the takerAssetData from the first order in all later orders.
2989             orders[i].takerAssetData = takerAssetData;
2990 
2991             // Calculate the remaining amount of takerAsset to sell
2992             uint256 remainingTakerAssetFillAmount = safeSub(takerAssetFillAmount, totalFillResults.takerAssetFilledAmount);
2993 
2994             // Attempt to sell the remaining amount of takerAsset
2995             FillResults memory singleFillResults = fillOrderInternal(
2996                 orders[i],
2997                 remainingTakerAssetFillAmount,
2998                 signatures[i]
2999             );
3000 
3001             // Update amounts filled and fees paid by maker and taker
3002             addFillResults(totalFillResults, singleFillResults);
3003 
3004             // Stop execution if the entire amount of takerAsset has been sold
3005             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
3006                 break;
3007             }
3008         }
3009         return totalFillResults;
3010     }
3011 
3012     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
3013     ///      Returns false if the transaction would otherwise revert.
3014     /// @param orders Array of order specifications.
3015     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3016     /// @param signatures Proofs that orders have been signed by makers.
3017     /// @return Amounts filled and fees paid by makers and taker.
3018     function marketSellOrdersNoThrow(
3019         LibOrder.Order[] memory orders,
3020         uint256 takerAssetFillAmount,
3021         bytes[] memory signatures
3022     )
3023         public
3024         returns (FillResults memory totalFillResults)
3025     {
3026         bytes memory takerAssetData = orders[0].takerAssetData;
3027 
3028         uint256 ordersLength = orders.length;
3029         for (uint256 i = 0; i != ordersLength; i++) {
3030 
3031             // We assume that asset being sold by taker is the same for each order.
3032             // Rather than passing this in as calldata, we use the takerAssetData from the first order in all later orders.
3033             orders[i].takerAssetData = takerAssetData;
3034 
3035             // Calculate the remaining amount of takerAsset to sell
3036             uint256 remainingTakerAssetFillAmount = safeSub(takerAssetFillAmount, totalFillResults.takerAssetFilledAmount);
3037 
3038             // Attempt to sell the remaining amount of takerAsset
3039             FillResults memory singleFillResults = fillOrderNoThrow(
3040                 orders[i],
3041                 remainingTakerAssetFillAmount,
3042                 signatures[i]
3043             );
3044 
3045             // Update amounts filled and fees paid by maker and taker
3046             addFillResults(totalFillResults, singleFillResults);
3047 
3048             // Stop execution if the entire amount of takerAsset has been sold
3049             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
3050                 break;
3051             }
3052         }
3053         return totalFillResults;
3054     }
3055 
3056     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
3057     /// @param orders Array of order specifications.
3058     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3059     /// @param signatures Proofs that orders have been signed by makers.
3060     /// @return Amounts filled and fees paid by makers and taker.
3061     function marketBuyOrders(
3062         LibOrder.Order[] memory orders,
3063         uint256 makerAssetFillAmount,
3064         bytes[] memory signatures
3065     )
3066         public
3067         nonReentrant
3068         returns (FillResults memory totalFillResults)
3069     {
3070         bytes memory makerAssetData = orders[0].makerAssetData;
3071 
3072         uint256 ordersLength = orders.length;
3073         for (uint256 i = 0; i != ordersLength; i++) {
3074 
3075             // We assume that asset being bought by taker is the same for each order.
3076             // Rather than passing this in as calldata, we copy the makerAssetData from the first order onto all later orders.
3077             orders[i].makerAssetData = makerAssetData;
3078 
3079             // Calculate the remaining amount of makerAsset to buy
3080             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3081 
3082             // Convert the remaining amount of makerAsset to buy into remaining amount
3083             // of takerAsset to sell, assuming entire amount can be sold in the current order
3084             uint256 remainingTakerAssetFillAmount = getPartialAmountFloor(
3085                 orders[i].takerAssetAmount,
3086                 orders[i].makerAssetAmount,
3087                 remainingMakerAssetFillAmount
3088             );
3089 
3090             // Attempt to sell the remaining amount of takerAsset
3091             FillResults memory singleFillResults = fillOrderInternal(
3092                 orders[i],
3093                 remainingTakerAssetFillAmount,
3094                 signatures[i]
3095             );
3096 
3097             // Update amounts filled and fees paid by maker and taker
3098             addFillResults(totalFillResults, singleFillResults);
3099 
3100             // Stop execution if the entire amount of makerAsset has been bought
3101             if (totalFillResults.makerAssetFilledAmount >= makerAssetFillAmount) {
3102                 break;
3103             }
3104         }
3105         return totalFillResults;
3106     }
3107 
3108     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
3109     ///      Returns false if the transaction would otherwise revert.
3110     /// @param orders Array of order specifications.
3111     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3112     /// @param signatures Proofs that orders have been signed by makers.
3113     /// @return Amounts filled and fees paid by makers and taker.
3114     function marketBuyOrdersNoThrow(
3115         LibOrder.Order[] memory orders,
3116         uint256 makerAssetFillAmount,
3117         bytes[] memory signatures
3118     )
3119         public
3120         returns (FillResults memory totalFillResults)
3121     {
3122         bytes memory makerAssetData = orders[0].makerAssetData;
3123 
3124         uint256 ordersLength = orders.length;
3125         for (uint256 i = 0; i != ordersLength; i++) {
3126 
3127             // We assume that asset being bought by taker is the same for each order.
3128             // Rather than passing this in as calldata, we copy the makerAssetData from the first order onto all later orders.
3129             orders[i].makerAssetData = makerAssetData;
3130 
3131             // Calculate the remaining amount of makerAsset to buy
3132             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3133 
3134             // Convert the remaining amount of makerAsset to buy into remaining amount
3135             // of takerAsset to sell, assuming entire amount can be sold in the current order
3136             uint256 remainingTakerAssetFillAmount = getPartialAmountFloor(
3137                 orders[i].takerAssetAmount,
3138                 orders[i].makerAssetAmount,
3139                 remainingMakerAssetFillAmount
3140             );
3141 
3142             // Attempt to sell the remaining amount of takerAsset
3143             FillResults memory singleFillResults = fillOrderNoThrow(
3144                 orders[i],
3145                 remainingTakerAssetFillAmount,
3146                 signatures[i]
3147             );
3148 
3149             // Update amounts filled and fees paid by maker and taker
3150             addFillResults(totalFillResults, singleFillResults);
3151 
3152             // Stop execution if the entire amount of makerAsset has been bought
3153             if (totalFillResults.makerAssetFilledAmount >= makerAssetFillAmount) {
3154                 break;
3155             }
3156         }
3157         return totalFillResults;
3158     }
3159 
3160     /// @dev Synchronously cancels multiple orders in a single transaction.
3161     /// @param orders Array of order specifications.
3162     function batchCancelOrders(LibOrder.Order[] memory orders)
3163         public
3164         nonReentrant
3165     {
3166         uint256 ordersLength = orders.length;
3167         for (uint256 i = 0; i != ordersLength; i++) {
3168             cancelOrderInternal(orders[i]);
3169         }
3170     }
3171 
3172     /// @dev Fetches information for all passed in orders.
3173     /// @param orders Array of order specifications.
3174     /// @return Array of OrderInfo instances that correspond to each order.
3175     function getOrdersInfo(LibOrder.Order[] memory orders)
3176         public
3177         view
3178         returns (LibOrder.OrderInfo[] memory)
3179     {
3180         uint256 ordersLength = orders.length;
3181         LibOrder.OrderInfo[] memory ordersInfo = new LibOrder.OrderInfo[](ordersLength);
3182         for (uint256 i = 0; i != ordersLength; i++) {
3183             ordersInfo[i] = getOrderInfo(orders[i]);
3184         }
3185         return ordersInfo;
3186     }
3187 
3188     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
3189     /// @param order Order struct containing order specifications.
3190     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3191     /// @param signature Proof that order has been created by maker.
3192     function fillOrKillOrderInternal(
3193         LibOrder.Order memory order,
3194         uint256 takerAssetFillAmount,
3195         bytes memory signature
3196     )
3197         internal
3198         returns (FillResults memory fillResults)
3199     {
3200         fillResults = fillOrderInternal(
3201             order,
3202             takerAssetFillAmount,
3203             signature
3204         );
3205         require(
3206             fillResults.takerAssetFilledAmount == takerAssetFillAmount,
3207             "COMPLETE_FILL_FAILED"
3208         );
3209         return fillResults;
3210     }
3211 }
3212 
3213 contract MixinTransactions is
3214     LibEIP712,
3215     MSignatureValidator,
3216     MTransactions
3217 {
3218     // Mapping of transaction hash => executed
3219     // This prevents transactions from being executed more than once.
3220     mapping (bytes32 => bool) public transactions;
3221 
3222     // Address of current transaction signer
3223     address public currentContextAddress;
3224 
3225     /// @dev Executes an exchange method call in the context of signer.
3226     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3227     /// @param signerAddress Address of transaction signer.
3228     /// @param data AbiV2 encoded calldata.
3229     /// @param signature Proof of signer transaction by signer.
3230     function executeTransaction(
3231         uint256 salt,
3232         address signerAddress,
3233         bytes data,
3234         bytes signature
3235     )
3236         external
3237     {
3238         // Prevent reentrancy
3239         require(
3240             currentContextAddress == address(0),
3241             "REENTRANCY_ILLEGAL"
3242         );
3243 
3244         bytes32 transactionHash = hashEIP712Message(hashZeroExTransaction(
3245             salt,
3246             signerAddress,
3247             data
3248         ));
3249 
3250         // Validate transaction has not been executed
3251         require(
3252             !transactions[transactionHash],
3253             "INVALID_TX_HASH"
3254         );
3255 
3256         // Transaction always valid if signer is sender of transaction
3257         if (signerAddress != msg.sender) {
3258             // Validate signature
3259             require(
3260                 isValidSignature(
3261                     transactionHash,
3262                     signerAddress,
3263                     signature
3264                 ),
3265                 "INVALID_TX_SIGNATURE"
3266             );
3267 
3268             // Set the current transaction signer
3269             currentContextAddress = signerAddress;
3270         }
3271 
3272         // Execute transaction
3273         transactions[transactionHash] = true;
3274         require(
3275             address(this).delegatecall(data),
3276             "FAILED_EXECUTION"
3277         );
3278 
3279         // Reset current transaction signer if it was previously updated
3280         if (signerAddress != msg.sender) {
3281             currentContextAddress = address(0);
3282         }
3283     }
3284 
3285     /// @dev Calculates EIP712 hash of the Transaction.
3286     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3287     /// @param signerAddress Address of transaction signer.
3288     /// @param data AbiV2 encoded calldata.
3289     /// @return EIP712 hash of the Transaction.
3290     function hashZeroExTransaction(
3291         uint256 salt,
3292         address signerAddress,
3293         bytes memory data
3294     )
3295         internal
3296         pure
3297         returns (bytes32 result)
3298     {
3299         bytes32 schemaHash = EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
3300         bytes32 dataHash = keccak256(data);
3301 
3302         // Assembly for more efficiently computing:
3303         // keccak256(abi.encodePacked(
3304         //     EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH,
3305         //     salt,
3306         //     bytes32(signerAddress),
3307         //     keccak256(data)
3308         // ));
3309 
3310         assembly {
3311             // Load free memory pointer
3312             let memPtr := mload(64)
3313 
3314             mstore(memPtr, schemaHash)                                                               // hash of schema
3315             mstore(add(memPtr, 32), salt)                                                            // salt
3316             mstore(add(memPtr, 64), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
3317             mstore(add(memPtr, 96), dataHash)                                                        // hash of data
3318 
3319             // Compute hash
3320             result := keccak256(memPtr, 128)
3321         }
3322         return result;
3323     }
3324 
3325     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
3326     ///      If calling a fill function, this address will represent the taker.
3327     ///      If calling a cancel function, this address will represent the maker.
3328     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
3329     ///         `msg.sender` if entry point is any other function.
3330     function getCurrentContextAddress()
3331         internal
3332         view
3333         returns (address)
3334     {
3335         address currentContextAddress_ = currentContextAddress;
3336         address contextAddress = currentContextAddress_ == address(0) ? msg.sender : currentContextAddress_;
3337         return contextAddress;
3338     }
3339 }
3340 
3341 contract MixinAssetProxyDispatcher is
3342     Ownable,
3343     MAssetProxyDispatcher
3344 {
3345     // Mapping from Asset Proxy Id's to their respective Asset Proxy
3346     mapping (bytes4 => IAssetProxy) public assetProxies;
3347 
3348     /// @dev Registers an asset proxy to its asset proxy id.
3349     ///      Once an asset proxy is registered, it cannot be unregistered.
3350     /// @param assetProxy Address of new asset proxy to register.
3351     function registerAssetProxy(address assetProxy)
3352         external
3353         onlyOwner
3354     {
3355         IAssetProxy assetProxyContract = IAssetProxy(assetProxy);
3356 
3357         // Ensure that no asset proxy exists with current id.
3358         bytes4 assetProxyId = assetProxyContract.getProxyId();
3359         address currentAssetProxy = assetProxies[assetProxyId];
3360         require(
3361             currentAssetProxy == address(0),
3362             "ASSET_PROXY_ALREADY_EXISTS"
3363         );
3364 
3365         // Add asset proxy and log registration.
3366         assetProxies[assetProxyId] = assetProxyContract;
3367         emit AssetProxyRegistered(
3368             assetProxyId,
3369             assetProxy
3370         );
3371     }
3372 
3373     /// @dev Gets an asset proxy.
3374     /// @param assetProxyId Id of the asset proxy.
3375     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
3376     function getAssetProxy(bytes4 assetProxyId)
3377         external
3378         view
3379         returns (address)
3380     {
3381         return assetProxies[assetProxyId];
3382     }
3383 
3384     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
3385     /// @param assetData Byte array encoded for the asset.
3386     /// @param from Address to transfer token from.
3387     /// @param to Address to transfer token to.
3388     /// @param amount Amount of token to transfer.
3389     function dispatchTransferFrom(
3390         bytes memory assetData,
3391         address from,
3392         address to,
3393         uint256 amount
3394     )
3395         internal
3396     {
3397         // Do nothing if no amount should be transferred.
3398         if (amount > 0 && from != to) {
3399             // Ensure assetData length is valid
3400             require(
3401                 assetData.length > 3,
3402                 "LENGTH_GREATER_THAN_3_REQUIRED"
3403             );
3404             
3405             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
3406             bytes4 assetProxyId;
3407             assembly {
3408                 assetProxyId := and(mload(
3409                     add(assetData, 32)),
3410                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
3411                 )
3412             }
3413             address assetProxy = assetProxies[assetProxyId];
3414 
3415             // Ensure that assetProxy exists
3416             require(
3417                 assetProxy != address(0),
3418                 "ASSET_PROXY_DOES_NOT_EXIST"
3419             );
3420             
3421             // We construct calldata for the `assetProxy.transferFrom` ABI.
3422             // The layout of this calldata is in the table below.
3423             // 
3424             // | Area     | Offset | Length  | Contents                                    |
3425             // | -------- |--------|---------|-------------------------------------------- |
3426             // | Header   | 0      | 4       | function selector                           |
3427             // | Params   |        | 4 * 32  | function parameters:                        |
3428             // |          | 4      |         |   1. offset to assetData (*)                |
3429             // |          | 36     |         |   2. from                                   |
3430             // |          | 68     |         |   3. to                                     |
3431             // |          | 100    |         |   4. amount                                 |
3432             // | Data     |        |         | assetData:                                  |
3433             // |          | 132    | 32      | assetData Length                            |
3434             // |          | 164    | **      | assetData Contents                          |
3435 
3436             assembly {
3437                 /////// Setup State ///////
3438                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
3439                 let cdStart := mload(64)
3440                 // `dataAreaLength` is the total number of words needed to store `assetData`
3441                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
3442                 //  and includes 32-bytes for length.
3443                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
3444                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
3445                 let cdEnd := add(cdStart, add(132, dataAreaLength))
3446 
3447                 
3448                 /////// Setup Header Area ///////
3449                 // This area holds the 4-byte `transferFromSelector`.
3450                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
3451                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
3452                 
3453                 /////// Setup Params Area ///////
3454                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
3455                 // Notes:
3456                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
3457                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
3458                 mstore(add(cdStart, 4), 128)
3459                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
3460                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
3461                 mstore(add(cdStart, 100), amount)
3462                 
3463                 /////// Setup Data Area ///////
3464                 // This area holds `assetData`.
3465                 let dataArea := add(cdStart, 132)
3466                 // solhint-disable-next-line no-empty-blocks
3467                 for {} lt(dataArea, cdEnd) {} {
3468                     mstore(dataArea, mload(assetData))
3469                     dataArea := add(dataArea, 32)
3470                     assetData := add(assetData, 32)
3471                 }
3472 
3473                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
3474                 let success := call(
3475                     gas,                    // forward all gas
3476                     assetProxy,             // call address of asset proxy
3477                     0,                      // don't send any ETH
3478                     cdStart,                // pointer to start of input
3479                     sub(cdEnd, cdStart),    // length of input  
3480                     cdStart,                // write output over input
3481                     512                     // reserve 512 bytes for output
3482                 )
3483                 if iszero(success) {
3484                     revert(cdStart, returndatasize())
3485                 }
3486             }
3487         }
3488     }
3489 }
3490 
3491 contract MixinMatchOrders is
3492     ReentrancyGuard,
3493     LibConstants,
3494     LibMath,
3495     MAssetProxyDispatcher,
3496     MExchangeCore,
3497     MMatchOrders,
3498     MTransactions
3499 {
3500     /// @dev Match two complementary orders that have a profitable spread.
3501     ///      Each order is filled at their respective price point. However, the calculations are
3502     ///      carried out as though the orders are both being filled at the right order's price point.
3503     ///      The profit made by the left order goes to the taker (who matched the two orders).
3504     /// @param leftOrder First order to match.
3505     /// @param rightOrder Second order to match.
3506     /// @param leftSignature Proof that order was created by the left maker.
3507     /// @param rightSignature Proof that order was created by the right maker.
3508     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
3509     function matchOrders(
3510         LibOrder.Order memory leftOrder,
3511         LibOrder.Order memory rightOrder,
3512         bytes memory leftSignature,
3513         bytes memory rightSignature
3514     )
3515         public
3516         nonReentrant
3517         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
3518     {
3519         // We assume that rightOrder.takerAssetData == leftOrder.makerAssetData and rightOrder.makerAssetData == leftOrder.takerAssetData.
3520         // If this assumption isn't true, the match will fail at signature validation.
3521         rightOrder.makerAssetData = leftOrder.takerAssetData;
3522         rightOrder.takerAssetData = leftOrder.makerAssetData;
3523 
3524         // Get left & right order info
3525         LibOrder.OrderInfo memory leftOrderInfo = getOrderInfo(leftOrder);
3526         LibOrder.OrderInfo memory rightOrderInfo = getOrderInfo(rightOrder);
3527 
3528         // Fetch taker address
3529         address takerAddress = getCurrentContextAddress();
3530         
3531         // Either our context is valid or we revert
3532         assertFillableOrder(
3533             leftOrder,
3534             leftOrderInfo,
3535             takerAddress,
3536             leftSignature
3537         );
3538         assertFillableOrder(
3539             rightOrder,
3540             rightOrderInfo,
3541             takerAddress,
3542             rightSignature
3543         );
3544         assertValidMatch(leftOrder, rightOrder);
3545 
3546         // Compute proportional fill amounts
3547         matchedFillResults = calculateMatchedFillResults(
3548             leftOrder,
3549             rightOrder,
3550             leftOrderInfo.orderTakerAssetFilledAmount,
3551             rightOrderInfo.orderTakerAssetFilledAmount
3552         );
3553 
3554         // Validate fill contexts
3555         assertValidFill(
3556             leftOrder,
3557             leftOrderInfo,
3558             matchedFillResults.left.takerAssetFilledAmount,
3559             matchedFillResults.left.takerAssetFilledAmount,
3560             matchedFillResults.left.makerAssetFilledAmount
3561         );
3562         assertValidFill(
3563             rightOrder,
3564             rightOrderInfo,
3565             matchedFillResults.right.takerAssetFilledAmount,
3566             matchedFillResults.right.takerAssetFilledAmount,
3567             matchedFillResults.right.makerAssetFilledAmount
3568         );
3569         
3570         // Update exchange state
3571         updateFilledState(
3572             leftOrder,
3573             takerAddress,
3574             leftOrderInfo.orderHash,
3575             leftOrderInfo.orderTakerAssetFilledAmount,
3576             matchedFillResults.left
3577         );
3578         updateFilledState(
3579             rightOrder,
3580             takerAddress,
3581             rightOrderInfo.orderHash,
3582             rightOrderInfo.orderTakerAssetFilledAmount,
3583             matchedFillResults.right
3584         );
3585 
3586         // Settle matched orders. Succeeds or throws.
3587         settleMatchedOrders(
3588             leftOrder,
3589             rightOrder,
3590             takerAddress,
3591             matchedFillResults
3592         );
3593 
3594         return matchedFillResults;
3595     }
3596 
3597     /// @dev Validates context for matchOrders. Succeeds or throws.
3598     /// @param leftOrder First order to match.
3599     /// @param rightOrder Second order to match.
3600     function assertValidMatch(
3601         LibOrder.Order memory leftOrder,
3602         LibOrder.Order memory rightOrder
3603     )
3604         internal
3605         pure
3606     {
3607         // Make sure there is a profitable spread.
3608         // There is a profitable spread iff the cost per unit bought (OrderA.MakerAmount/OrderA.TakerAmount) for each order is greater
3609         // than the profit per unit sold of the matched order (OrderB.TakerAmount/OrderB.MakerAmount).
3610         // This is satisfied by the equations below:
3611         // <leftOrder.makerAssetAmount> / <leftOrder.takerAssetAmount> >= <rightOrder.takerAssetAmount> / <rightOrder.makerAssetAmount>
3612         // AND
3613         // <rightOrder.makerAssetAmount> / <rightOrder.takerAssetAmount> >= <leftOrder.takerAssetAmount> / <leftOrder.makerAssetAmount>
3614         // These equations can be combined to get the following:
3615         require(
3616             safeMul(leftOrder.makerAssetAmount, rightOrder.makerAssetAmount) >=
3617             safeMul(leftOrder.takerAssetAmount, rightOrder.takerAssetAmount),
3618             "NEGATIVE_SPREAD_REQUIRED"
3619         );
3620     }
3621 
3622     /// @dev Calculates fill amounts for the matched orders.
3623     ///      Each order is filled at their respective price point. However, the calculations are
3624     ///      carried out as though the orders are both being filled at the right order's price point.
3625     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
3626     /// @param leftOrder First order to match.
3627     /// @param rightOrder Second order to match.
3628     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
3629     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
3630     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
3631     function calculateMatchedFillResults(
3632         LibOrder.Order memory leftOrder,
3633         LibOrder.Order memory rightOrder,
3634         uint256 leftOrderTakerAssetFilledAmount,
3635         uint256 rightOrderTakerAssetFilledAmount
3636     )
3637         internal
3638         pure
3639         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
3640     {
3641         // Derive maker asset amounts for left & right orders, given store taker assert amounts
3642         uint256 leftTakerAssetAmountRemaining = safeSub(leftOrder.takerAssetAmount, leftOrderTakerAssetFilledAmount);
3643         uint256 leftMakerAssetAmountRemaining = safeGetPartialAmountFloor(
3644             leftOrder.makerAssetAmount,
3645             leftOrder.takerAssetAmount,
3646             leftTakerAssetAmountRemaining
3647         );
3648         uint256 rightTakerAssetAmountRemaining = safeSub(rightOrder.takerAssetAmount, rightOrderTakerAssetFilledAmount);
3649         uint256 rightMakerAssetAmountRemaining = safeGetPartialAmountFloor(
3650             rightOrder.makerAssetAmount,
3651             rightOrder.takerAssetAmount,
3652             rightTakerAssetAmountRemaining
3653         );
3654 
3655         // Calculate fill results for maker and taker assets: at least one order will be fully filled.
3656         // The maximum amount the left maker can buy is `leftTakerAssetAmountRemaining`
3657         // The maximum amount the right maker can sell is `rightMakerAssetAmountRemaining`
3658         // We have two distinct cases for calculating the fill results:
3659         // Case 1.
3660         //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.
3661         //   If the left maker can buy exactly what the right maker can sell, then both orders are fully filled.
3662         // Case 2.
3663         //   If the left maker cannot buy more than the right maker can sell, then only the left order is fully filled.
3664         if (leftTakerAssetAmountRemaining >= rightMakerAssetAmountRemaining) {
3665             // Case 1: Right order is fully filled
3666             matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;
3667             matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;
3668             matchedFillResults.left.takerAssetFilledAmount = matchedFillResults.right.makerAssetFilledAmount;
3669             // Round down to ensure the maker's exchange rate does not exceed the price specified by the order. 
3670             // We favor the maker when the exchange rate must be rounded.
3671             matchedFillResults.left.makerAssetFilledAmount = safeGetPartialAmountFloor(
3672                 leftOrder.makerAssetAmount,
3673                 leftOrder.takerAssetAmount,
3674                 matchedFillResults.left.takerAssetFilledAmount
3675             );
3676         } else {
3677             // Case 2: Left order is fully filled
3678             matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
3679             matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
3680             matchedFillResults.right.makerAssetFilledAmount = matchedFillResults.left.takerAssetFilledAmount;
3681             // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.
3682             // We favor the maker when the exchange rate must be rounded.
3683             matchedFillResults.right.takerAssetFilledAmount = safeGetPartialAmountCeil(
3684                 rightOrder.takerAssetAmount,
3685                 rightOrder.makerAssetAmount,
3686                 matchedFillResults.right.makerAssetFilledAmount
3687             );
3688         }
3689 
3690         // Calculate amount given to taker
3691         matchedFillResults.leftMakerAssetSpreadAmount = safeSub(
3692             matchedFillResults.left.makerAssetFilledAmount,
3693             matchedFillResults.right.takerAssetFilledAmount
3694         );
3695 
3696         // Compute fees for left order
3697         matchedFillResults.left.makerFeePaid = safeGetPartialAmountFloor(
3698             matchedFillResults.left.makerAssetFilledAmount,
3699             leftOrder.makerAssetAmount,
3700             leftOrder.makerFee
3701         );
3702         matchedFillResults.left.takerFeePaid = safeGetPartialAmountFloor(
3703             matchedFillResults.left.takerAssetFilledAmount,
3704             leftOrder.takerAssetAmount,
3705             leftOrder.takerFee
3706         );
3707 
3708         // Compute fees for right order
3709         matchedFillResults.right.makerFeePaid = safeGetPartialAmountFloor(
3710             matchedFillResults.right.makerAssetFilledAmount,
3711             rightOrder.makerAssetAmount,
3712             rightOrder.makerFee
3713         );
3714         matchedFillResults.right.takerFeePaid = safeGetPartialAmountFloor(
3715             matchedFillResults.right.takerAssetFilledAmount,
3716             rightOrder.takerAssetAmount,
3717             rightOrder.takerFee
3718         );
3719 
3720         // Return fill results
3721         return matchedFillResults;
3722     }
3723 
3724     /// @dev Settles matched order by transferring appropriate funds between order makers, taker, and fee recipient.
3725     /// @param leftOrder First matched order.
3726     /// @param rightOrder Second matched order.
3727     /// @param takerAddress Address that matched the orders. The taker receives the spread between orders as profit.
3728     /// @param matchedFillResults Struct holding amounts to transfer between makers, taker, and fee recipients.
3729     function settleMatchedOrders(
3730         LibOrder.Order memory leftOrder,
3731         LibOrder.Order memory rightOrder,
3732         address takerAddress,
3733         LibFillResults.MatchedFillResults memory matchedFillResults
3734     )
3735         private
3736     {
3737         bytes memory zrxAssetData = ZRX_ASSET_DATA;
3738         // Order makers and taker
3739         dispatchTransferFrom(
3740             leftOrder.makerAssetData,
3741             leftOrder.makerAddress,
3742             rightOrder.makerAddress,
3743             matchedFillResults.right.takerAssetFilledAmount
3744         );
3745         dispatchTransferFrom(
3746             rightOrder.makerAssetData,
3747             rightOrder.makerAddress,
3748             leftOrder.makerAddress,
3749             matchedFillResults.left.takerAssetFilledAmount
3750         );
3751         dispatchTransferFrom(
3752             leftOrder.makerAssetData,
3753             leftOrder.makerAddress,
3754             takerAddress,
3755             matchedFillResults.leftMakerAssetSpreadAmount
3756         );
3757 
3758         // Maker fees
3759         dispatchTransferFrom(
3760             zrxAssetData,
3761             leftOrder.makerAddress,
3762             leftOrder.feeRecipientAddress,
3763             matchedFillResults.left.makerFeePaid
3764         );
3765         dispatchTransferFrom(
3766             zrxAssetData,
3767             rightOrder.makerAddress,
3768             rightOrder.feeRecipientAddress,
3769             matchedFillResults.right.makerFeePaid
3770         );
3771 
3772         // Taker fees
3773         if (leftOrder.feeRecipientAddress == rightOrder.feeRecipientAddress) {
3774             dispatchTransferFrom(
3775                 zrxAssetData,
3776                 takerAddress,
3777                 leftOrder.feeRecipientAddress,
3778                 safeAdd(
3779                     matchedFillResults.left.takerFeePaid,
3780                     matchedFillResults.right.takerFeePaid
3781                 )
3782             );
3783         } else {
3784             dispatchTransferFrom(
3785                 zrxAssetData,
3786                 takerAddress,
3787                 leftOrder.feeRecipientAddress,
3788                 matchedFillResults.left.takerFeePaid
3789             );
3790             dispatchTransferFrom(
3791                 zrxAssetData,
3792                 takerAddress,
3793                 rightOrder.feeRecipientAddress,
3794                 matchedFillResults.right.takerFeePaid
3795             );
3796         }
3797     }
3798 }
3799 
3800 // solhint-disable no-empty-blocks
3801 contract Exchange is
3802     MixinExchangeCore,
3803     MixinMatchOrders,
3804     MixinSignatureValidator,
3805     MixinTransactions,
3806     MixinAssetProxyDispatcher,
3807     MixinWrapperFunctions
3808 {
3809     string constant public VERSION = "2.0.0";
3810 
3811     // Mixins are instantiated in the order they are inherited
3812     constructor ()
3813         public
3814         MixinExchangeCore()
3815         MixinMatchOrders()
3816         MixinSignatureValidator()
3817         MixinTransactions()
3818         MixinAssetProxyDispatcher()
3819         MixinWrapperFunctions()
3820     {}
3821 }