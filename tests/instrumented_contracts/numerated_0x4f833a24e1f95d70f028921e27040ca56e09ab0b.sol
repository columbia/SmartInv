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
681    
682     // Asset data for ZRX token. Used for fee transfers.
683 
684     // The proxyId for ZRX_ASSET_DATA is bytes4(keccak256("ERC20Token(address)")) = 0xf47261b0
685     
686     // Kovan ZRX address is 0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570.
687     // The ABI encoded proxyId and address is 0xf47261b00000000000000000000000006ff6c0ff1d68b964901f986d4c9fa3ac68346570
688     // bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6f\xf6\xc0\xff\x1d\x68\xb9\x64\x90\x1f\x98\x6d\x4c\x9f\xa3\xac\x68\x34\x65\x70";
689     
690     // Mainnet ZRX address is 0xe41d2489571d322189246dafa5ebde1f4699f498.
691     // The ABI encoded proxyId and address is 0xf47261b0000000000000000000000000e41d2489571d322189246dafa5ebde1f4699f498
692     bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x1d\x24\x89\x57\x1d\x32\x21\x89\x24\x6d\xaf\xa5\xeb\xde\x1f\x46\x99\xf4\x98";
693 }
694 // solhint-enable max-line-length
695 
696 contract LibEIP712 {
697 
698     // EIP191 header for EIP712 prefix
699     string constant internal EIP191_HEADER = "\x19\x01";
700 
701     // EIP712 Domain Name value
702     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
703 
704     // EIP712 Domain Version value
705     string constant internal EIP712_DOMAIN_VERSION = "2";
706 
707     // Hash of the EIP712 Domain Separator Schema
708     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
709         "EIP712Domain(",
710         "string name,",
711         "string version,",
712         "address verifyingContract",
713         ")"
714     ));
715 
716     // Hash of the EIP712 Domain Separator data
717     // solhint-disable-next-line var-name-mixedcase
718     bytes32 public EIP712_DOMAIN_HASH;
719 
720     constructor ()
721         public
722     {
723         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
724             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
725             keccak256(bytes(EIP712_DOMAIN_NAME)),
726             keccak256(bytes(EIP712_DOMAIN_VERSION)),
727             bytes32(address(this))
728         ));
729     }
730 
731     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
732     /// @param hashStruct The EIP712 hash struct.
733     /// @return EIP712 hash applied to this EIP712 Domain.
734     function hashEIP712Message(bytes32 hashStruct)
735         internal
736         view
737         returns (bytes32 result)
738     {
739         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
740 
741         // Assembly for more efficient computing:
742         // keccak256(abi.encodePacked(
743         //     EIP191_HEADER,
744         //     EIP712_DOMAIN_HASH,
745         //     hashStruct    
746         // ));
747 
748         assembly {
749             // Load free memory pointer
750             let memPtr := mload(64)
751 
752             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
753             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
754             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
755 
756             // Compute hash
757             result := keccak256(memPtr, 66)
758         }
759         return result;
760     }
761 }
762 
763 contract LibFillResults is
764     SafeMath
765 {
766     struct FillResults {
767         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
768         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
769         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
770         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
771     }
772 
773     struct MatchedFillResults {
774         FillResults left;                    // Amounts filled and fees paid of left order.
775         FillResults right;                   // Amounts filled and fees paid of right order.
776         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
777     }
778 
779     /// @dev Adds properties of both FillResults instances.
780     ///      Modifies the first FillResults instance specified.
781     /// @param totalFillResults Fill results instance that will be added onto.
782     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
783     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
784         internal
785         pure
786     {
787         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
788         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
789         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
790         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
791     }
792 }
793 
794 contract LibMath is
795     SafeMath
796 {
797     /// @dev Calculates partial value given a numerator and denominator rounded down.
798     ///      Reverts if rounding error is >= 0.1%
799     /// @param numerator Numerator.
800     /// @param denominator Denominator.
801     /// @param target Value to calculate partial of.
802     /// @return Partial value of target rounded down.
803     function safeGetPartialAmountFloor(
804         uint256 numerator,
805         uint256 denominator,
806         uint256 target
807     )
808         internal
809         pure
810         returns (uint256 partialAmount)
811     {
812         require(
813             denominator > 0,
814             "DIVISION_BY_ZERO"
815         );
816 
817         require(
818             !isRoundingErrorFloor(
819                 numerator,
820                 denominator,
821                 target
822             ),
823             "ROUNDING_ERROR"
824         );
825         
826         partialAmount = safeDiv(
827             safeMul(numerator, target),
828             denominator
829         );
830         return partialAmount;
831     }
832 
833     /// @dev Calculates partial value given a numerator and denominator rounded down.
834     ///      Reverts if rounding error is >= 0.1%
835     /// @param numerator Numerator.
836     /// @param denominator Denominator.
837     /// @param target Value to calculate partial of.
838     /// @return Partial value of target rounded up.
839     function safeGetPartialAmountCeil(
840         uint256 numerator,
841         uint256 denominator,
842         uint256 target
843     )
844         internal
845         pure
846         returns (uint256 partialAmount)
847     {
848         require(
849             denominator > 0,
850             "DIVISION_BY_ZERO"
851         );
852 
853         require(
854             !isRoundingErrorCeil(
855                 numerator,
856                 denominator,
857                 target
858             ),
859             "ROUNDING_ERROR"
860         );
861         
862         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
863         //       ceil(a / b) = floor((a + b - 1) / b)
864         // To implement `ceil(a / b)` using safeDiv.
865         partialAmount = safeDiv(
866             safeAdd(
867                 safeMul(numerator, target),
868                 safeSub(denominator, 1)
869             ),
870             denominator
871         );
872         return partialAmount;
873     }
874 
875     /// @dev Calculates partial value given a numerator and denominator rounded down.
876     /// @param numerator Numerator.
877     /// @param denominator Denominator.
878     /// @param target Value to calculate partial of.
879     /// @return Partial value of target rounded down.
880     function getPartialAmountFloor(
881         uint256 numerator,
882         uint256 denominator,
883         uint256 target
884     )
885         internal
886         pure
887         returns (uint256 partialAmount)
888     {
889         require(
890             denominator > 0,
891             "DIVISION_BY_ZERO"
892         );
893 
894         partialAmount = safeDiv(
895             safeMul(numerator, target),
896             denominator
897         );
898         return partialAmount;
899     }
900     
901     /// @dev Calculates partial value given a numerator and denominator rounded down.
902     /// @param numerator Numerator.
903     /// @param denominator Denominator.
904     /// @param target Value to calculate partial of.
905     /// @return Partial value of target rounded up.
906     function getPartialAmountCeil(
907         uint256 numerator,
908         uint256 denominator,
909         uint256 target
910     )
911         internal
912         pure
913         returns (uint256 partialAmount)
914     {
915         require(
916             denominator > 0,
917             "DIVISION_BY_ZERO"
918         );
919 
920         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
921         //       ceil(a / b) = floor((a + b - 1) / b)
922         // To implement `ceil(a / b)` using safeDiv.
923         partialAmount = safeDiv(
924             safeAdd(
925                 safeMul(numerator, target),
926                 safeSub(denominator, 1)
927             ),
928             denominator
929         );
930         return partialAmount;
931     }
932     
933     /// @dev Checks if rounding error >= 0.1% when rounding down.
934     /// @param numerator Numerator.
935     /// @param denominator Denominator.
936     /// @param target Value to multiply with numerator/denominator.
937     /// @return Rounding error is present.
938     function isRoundingErrorFloor(
939         uint256 numerator,
940         uint256 denominator,
941         uint256 target
942     )
943         internal
944         pure
945         returns (bool isError)
946     {
947         require(
948             denominator > 0,
949             "DIVISION_BY_ZERO"
950         );
951         
952         // The absolute rounding error is the difference between the rounded
953         // value and the ideal value. The relative rounding error is the
954         // absolute rounding error divided by the absolute value of the
955         // ideal value. This is undefined when the ideal value is zero.
956         //
957         // The ideal value is `numerator * target / denominator`.
958         // Let's call `numerator * target % denominator` the remainder.
959         // The absolute error is `remainder / denominator`.
960         //
961         // When the ideal value is zero, we require the absolute error to
962         // be zero. Fortunately, this is always the case. The ideal value is
963         // zero iff `numerator == 0` and/or `target == 0`. In this case the
964         // remainder and absolute error are also zero. 
965         if (target == 0 || numerator == 0) {
966             return false;
967         }
968         
969         // Otherwise, we want the relative rounding error to be strictly
970         // less than 0.1%.
971         // The relative error is `remainder / (numerator * target)`.
972         // We want the relative error less than 1 / 1000:
973         //        remainder / (numerator * denominator)  <  1 / 1000
974         // or equivalently:
975         //        1000 * remainder  <  numerator * target
976         // so we have a rounding error iff:
977         //        1000 * remainder  >=  numerator * target
978         uint256 remainder = mulmod(
979             target,
980             numerator,
981             denominator
982         );
983         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
984         return isError;
985     }
986     
987     /// @dev Checks if rounding error >= 0.1% when rounding up.
988     /// @param numerator Numerator.
989     /// @param denominator Denominator.
990     /// @param target Value to multiply with numerator/denominator.
991     /// @return Rounding error is present.
992     function isRoundingErrorCeil(
993         uint256 numerator,
994         uint256 denominator,
995         uint256 target
996     )
997         internal
998         pure
999         returns (bool isError)
1000     {
1001         require(
1002             denominator > 0,
1003             "DIVISION_BY_ZERO"
1004         );
1005         
1006         // See the comments in `isRoundingError`.
1007         if (target == 0 || numerator == 0) {
1008             // When either is zero, the ideal value and rounded value are zero
1009             // and there is no rounding error. (Although the relative error
1010             // is undefined.)
1011             return false;
1012         }
1013         // Compute remainder as before
1014         uint256 remainder = mulmod(
1015             target,
1016             numerator,
1017             denominator
1018         );
1019         remainder = safeSub(denominator, remainder) % denominator;
1020         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
1021         return isError;
1022     }
1023 }
1024 
1025 contract LibOrder is
1026     LibEIP712
1027 {
1028     // Hash for the EIP712 Order Schema
1029     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
1030         "Order(",
1031         "address makerAddress,",
1032         "address takerAddress,",
1033         "address feeRecipientAddress,",
1034         "address senderAddress,",
1035         "uint256 makerAssetAmount,",
1036         "uint256 takerAssetAmount,",
1037         "uint256 makerFee,",
1038         "uint256 takerFee,",
1039         "uint256 expirationTimeSeconds,",
1040         "uint256 salt,",
1041         "bytes makerAssetData,",
1042         "bytes takerAssetData",
1043         ")"
1044     ));
1045 
1046     // A valid order remains fillable until it is expired, fully filled, or cancelled.
1047     // An order's state is unaffected by external factors, like account balances.
1048     enum OrderStatus {
1049         INVALID,                     // Default value
1050         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
1051         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
1052         FILLABLE,                    // Order is fillable
1053         EXPIRED,                     // Order has already expired
1054         FULLY_FILLED,                // Order is fully filled
1055         CANCELLED                    // Order has been cancelled
1056     }
1057 
1058     // solhint-disable max-line-length
1059     struct Order {
1060         address makerAddress;           // Address that created the order.      
1061         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
1062         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
1063         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1064         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
1065         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
1066         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1067         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1068         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
1069         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
1070         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1071         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1072     }
1073     // solhint-enable max-line-length
1074 
1075     struct OrderInfo {
1076         uint8 orderStatus;                    // Status that describes order's validity and fillability.
1077         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
1078         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
1079     }
1080 
1081     /// @dev Calculates Keccak-256 hash of the order.
1082     /// @param order The order structure.
1083     /// @return Keccak-256 EIP712 hash of the order.
1084     function getOrderHash(Order memory order)
1085         internal
1086         view
1087         returns (bytes32 orderHash)
1088     {
1089         orderHash = hashEIP712Message(hashOrder(order));
1090         return orderHash;
1091     }
1092 
1093     /// @dev Calculates EIP712 hash of the order.
1094     /// @param order The order structure.
1095     /// @return EIP712 hash of the order.
1096     function hashOrder(Order memory order)
1097         internal
1098         pure
1099         returns (bytes32 result)
1100     {
1101         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
1102         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
1103         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
1104 
1105         // Assembly for more efficiently computing:
1106         // keccak256(abi.encodePacked(
1107         //     EIP712_ORDER_SCHEMA_HASH,
1108         //     bytes32(order.makerAddress),
1109         //     bytes32(order.takerAddress),
1110         //     bytes32(order.feeRecipientAddress),
1111         //     bytes32(order.senderAddress),
1112         //     order.makerAssetAmount,
1113         //     order.takerAssetAmount,
1114         //     order.makerFee,
1115         //     order.takerFee,
1116         //     order.expirationTimeSeconds,
1117         //     order.salt,
1118         //     keccak256(order.makerAssetData),
1119         //     keccak256(order.takerAssetData)
1120         // ));
1121 
1122         assembly {
1123             // Calculate memory addresses that will be swapped out before hashing
1124             let pos1 := sub(order, 32)
1125             let pos2 := add(order, 320)
1126             let pos3 := add(order, 352)
1127 
1128             // Backup
1129             let temp1 := mload(pos1)
1130             let temp2 := mload(pos2)
1131             let temp3 := mload(pos3)
1132             
1133             // Hash in place
1134             mstore(pos1, schemaHash)
1135             mstore(pos2, makerAssetDataHash)
1136             mstore(pos3, takerAssetDataHash)
1137             result := keccak256(pos1, 416)
1138             
1139             // Restore
1140             mstore(pos1, temp1)
1141             mstore(pos2, temp2)
1142             mstore(pos3, temp3)
1143         }
1144         return result;
1145     }
1146 }
1147 
1148 contract LibAbiEncoder {
1149 
1150     /// @dev ABI encodes calldata for `fillOrder`.
1151     /// @param order Order struct containing order specifications.
1152     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1153     /// @param signature Proof that order has been created by maker.
1154     /// @return ABI encoded calldata for `fillOrder`.
1155     function abiEncodeFillOrder(
1156         LibOrder.Order memory order,
1157         uint256 takerAssetFillAmount,
1158         bytes memory signature
1159     )
1160         internal
1161         pure
1162         returns (bytes memory fillOrderCalldata)
1163     {
1164         // We need to call MExchangeCore.fillOrder using a delegatecall in
1165         // assembly so that we can intercept a call that throws. For this, we
1166         // need the input encoded in memory in the Ethereum ABIv2 format [1].
1167 
1168         // | Area     | Offset | Length  | Contents                                    |
1169         // | -------- |--------|---------|-------------------------------------------- |
1170         // | Header   | 0x00   | 4       | function selector                           |
1171         // | Params   |        | 3 * 32  | function parameters:                        |
1172         // |          | 0x00   |         |   1. offset to order (*)                    |
1173         // |          | 0x20   |         |   2. takerAssetFillAmount                   |
1174         // |          | 0x40   |         |   3. offset to signature (*)                |
1175         // | Data     |        | 12 * 32 | order:                                      |
1176         // |          | 0x000  |         |   1.  senderAddress                         |
1177         // |          | 0x020  |         |   2.  makerAddress                          |
1178         // |          | 0x040  |         |   3.  takerAddress                          |
1179         // |          | 0x060  |         |   4.  feeRecipientAddress                   |
1180         // |          | 0x080  |         |   5.  makerAssetAmount                      |
1181         // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
1182         // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
1183         // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
1184         // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
1185         // |          | 0x120  |         |   10. salt                                  |
1186         // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
1187         // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
1188         // |          | 0x180  | 32      | makerAssetData Length                       |
1189         // |          | 0x1A0  | **      | makerAssetData Contents                     |
1190         // |          | 0x1C0  | 32      | takerAssetData Length                       |
1191         // |          | 0x1E0  | **      | takerAssetData Contents                     |
1192         // |          | 0x200  | 32      | signature Length                            |
1193         // |          | 0x220  | **      | signature Contents                          |
1194 
1195         // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
1196         //     An offset stored in the Params area is calculated from the beginning of the Params section.
1197         //     An offset stored in the Data area is calculated from the beginning of the Data section.
1198 
1199         // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.
1200 
1201         // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html
1202 
1203         assembly {
1204 
1205             // Areas below may use the following variables:
1206             //   1. <area>Start   -- Start of this area in memory
1207             //   2. <area>End     -- End of this area in memory. This value may
1208             //                       be precomputed (before writing contents),
1209             //                       or it may be computed as contents are written.
1210             //   3. <area>Offset  -- Current offset into area. If an area's End
1211             //                       is precomputed, this variable tracks the
1212             //                       offsets of contents as they are written.
1213 
1214             /////// Setup Header Area ///////
1215             // Load free memory pointer
1216             fillOrderCalldata := mload(0x40)
1217             // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
1218             // = 0xb4be83d5
1219             // Leave 0x20 bytes to store the length
1220             mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
1221             let headerAreaEnd := add(fillOrderCalldata, 0x24)
1222 
1223             /////// Setup Params Area ///////
1224             // This area is preallocated and written to later.
1225             // This is because we need to fill in offsets that have not yet been calculated.
1226             let paramsAreaStart := headerAreaEnd
1227             let paramsAreaEnd := add(paramsAreaStart, 0x60)
1228             let paramsAreaOffset := paramsAreaStart
1229 
1230             /////// Setup Data Area ///////
1231             let dataAreaStart := paramsAreaEnd
1232             let dataAreaEnd := dataAreaStart
1233 
1234             // Offset from the source data we're reading from
1235             let sourceOffset := order
1236             // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
1237             let arrayLenBytes := 0
1238             let arrayLenWords := 0
1239 
1240             /////// Write order Struct ///////
1241             // Write memory location of Order, relative to the start of the
1242             // parameter list, then increment the paramsAreaOffset respectively.
1243             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
1244             paramsAreaOffset := add(paramsAreaOffset, 0x20)
1245 
1246             // Write values for each field in the order
1247             // It would be nice to use a loop, but we save on gas by writing
1248             // the stores sequentially.
1249             mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
1250             mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
1251             mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
1252             mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
1253             mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
1254             mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
1255             mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
1256             mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
1257             mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
1258             mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
1259             mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
1260             mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
1261             dataAreaEnd := add(dataAreaEnd, 0x180)
1262             sourceOffset := add(sourceOffset, 0x180)
1263 
1264             // Write offset to <order.makerAssetData>
1265             mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))
1266 
1267             // Calculate length of <order.makerAssetData>
1268             sourceOffset := mload(add(order, 0x140)) // makerAssetData
1269             arrayLenBytes := mload(sourceOffset)
1270             sourceOffset := add(sourceOffset, 0x20)
1271             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1272 
1273             // Write length of <order.makerAssetData>
1274             mstore(dataAreaEnd, arrayLenBytes)
1275             dataAreaEnd := add(dataAreaEnd, 0x20)
1276 
1277             // Write contents of <order.makerAssetData>
1278             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1279                 mstore(dataAreaEnd, mload(sourceOffset))
1280                 dataAreaEnd := add(dataAreaEnd, 0x20)
1281                 sourceOffset := add(sourceOffset, 0x20)
1282             }
1283 
1284             // Write offset to <order.takerAssetData>
1285             mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))
1286 
1287             // Calculate length of <order.takerAssetData>
1288             sourceOffset := mload(add(order, 0x160)) // takerAssetData
1289             arrayLenBytes := mload(sourceOffset)
1290             sourceOffset := add(sourceOffset, 0x20)
1291             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1292 
1293             // Write length of <order.takerAssetData>
1294             mstore(dataAreaEnd, arrayLenBytes)
1295             dataAreaEnd := add(dataAreaEnd, 0x20)
1296 
1297             // Write contents of  <order.takerAssetData>
1298             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1299                 mstore(dataAreaEnd, mload(sourceOffset))
1300                 dataAreaEnd := add(dataAreaEnd, 0x20)
1301                 sourceOffset := add(sourceOffset, 0x20)
1302             }
1303 
1304             /////// Write takerAssetFillAmount ///////
1305             mstore(paramsAreaOffset, takerAssetFillAmount)
1306             paramsAreaOffset := add(paramsAreaOffset, 0x20)
1307 
1308             /////// Write signature ///////
1309             // Write offset to paramsArea
1310             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
1311 
1312             // Calculate length of signature
1313             sourceOffset := signature
1314             arrayLenBytes := mload(sourceOffset)
1315             sourceOffset := add(sourceOffset, 0x20)
1316             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
1317 
1318             // Write length of signature
1319             mstore(dataAreaEnd, arrayLenBytes)
1320             dataAreaEnd := add(dataAreaEnd, 0x20)
1321 
1322             // Write contents of signature
1323             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
1324                 mstore(dataAreaEnd, mload(sourceOffset))
1325                 dataAreaEnd := add(dataAreaEnd, 0x20)
1326                 sourceOffset := add(sourceOffset, 0x20)
1327             }
1328 
1329             // Set length of calldata
1330             mstore(fillOrderCalldata, sub(dataAreaEnd, add(fillOrderCalldata, 0x20)))
1331 
1332             // Increment free memory pointer
1333             mstore(0x40, dataAreaEnd)
1334         }
1335 
1336         return fillOrderCalldata;
1337     }
1338 }
1339 
1340 contract IOwnable {
1341 
1342     function transferOwnership(address newOwner)
1343         public;
1344 }
1345 
1346 contract IAuthorizable is
1347     IOwnable
1348 {
1349     /// @dev Authorizes an address.
1350     /// @param target Address to authorize.
1351     function addAuthorizedAddress(address target)
1352         external;
1353 
1354     /// @dev Removes authorizion of an address.
1355     /// @param target Address to remove authorization from.
1356     function removeAuthorizedAddress(address target)
1357         external;
1358 
1359     /// @dev Removes authorizion of an address.
1360     /// @param target Address to remove authorization from.
1361     /// @param index Index of target in authorities array.
1362     function removeAuthorizedAddressAtIndex(
1363         address target,
1364         uint256 index
1365     )
1366         external;
1367     
1368     /// @dev Gets all authorized addresses.
1369     /// @return Array of authorized addresses.
1370     function getAuthorizedAddresses()
1371         external
1372         view
1373         returns (address[] memory);
1374 }
1375 
1376 contract IAssetProxy is
1377     IAuthorizable
1378 {
1379     /// @dev Transfers assets. Either succeeds or throws.
1380     /// @param assetData Byte array encoded for the respective asset proxy.
1381     /// @param from Address to transfer asset from.
1382     /// @param to Address to transfer asset to.
1383     /// @param amount Amount of asset to transfer.
1384     function transferFrom(
1385         bytes assetData,
1386         address from,
1387         address to,
1388         uint256 amount
1389     )
1390         external;
1391     
1392     /// @dev Gets the proxy id associated with the proxy address.
1393     /// @return Proxy id.
1394     function getProxyId()
1395         external
1396         pure
1397         returns (bytes4);
1398 }
1399 
1400 contract IValidator {
1401 
1402     /// @dev Verifies that a signature is valid.
1403     /// @param hash Message hash that is signed.
1404     /// @param signerAddress Address that should have signed the given hash.
1405     /// @param signature Proof of signing.
1406     /// @return Validity of order signature.
1407     function isValidSignature(
1408         bytes32 hash,
1409         address signerAddress,
1410         bytes signature
1411     )
1412         external
1413         view
1414         returns (bool isValid);
1415 }
1416 
1417 contract IWallet {
1418 
1419     /// @dev Verifies that a signature is valid.
1420     /// @param hash Message hash that is signed.
1421     /// @param signature Proof of signing.
1422     /// @return Validity of order signature.
1423     function isValidSignature(
1424         bytes32 hash,
1425         bytes signature
1426     )
1427         external
1428         view
1429         returns (bool isValid);
1430 }
1431 
1432 contract IExchangeCore {
1433 
1434     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1435     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1436     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1437     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1438         external;
1439 
1440     /// @dev Fills the input order.
1441     /// @param order Order struct containing order specifications.
1442     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1443     /// @param signature Proof that order has been created by maker.
1444     /// @return Amounts filled and fees paid by maker and taker.
1445     function fillOrder(
1446         LibOrder.Order memory order,
1447         uint256 takerAssetFillAmount,
1448         bytes memory signature
1449     )
1450         public
1451         returns (LibFillResults.FillResults memory fillResults);
1452 
1453     /// @dev After calling, the order can not be filled anymore.
1454     /// @param order Order struct containing order specifications.
1455     function cancelOrder(LibOrder.Order memory order)
1456         public;
1457 
1458     /// @dev Gets information about an order: status, hash, and amount filled.
1459     /// @param order Order to gather information on.
1460     /// @return OrderInfo Information about the order and its state.
1461     ///                   See LibOrder.OrderInfo for a complete description.
1462     function getOrderInfo(LibOrder.Order memory order)
1463         public
1464         view
1465         returns (LibOrder.OrderInfo memory orderInfo);
1466 }
1467 
1468 contract IAssetProxyDispatcher {
1469 
1470     /// @dev Registers an asset proxy to its asset proxy id.
1471     ///      Once an asset proxy is registered, it cannot be unregistered.
1472     /// @param assetProxy Address of new asset proxy to register.
1473     function registerAssetProxy(address assetProxy)
1474         external;
1475 
1476     /// @dev Gets an asset proxy.
1477     /// @param assetProxyId Id of the asset proxy.
1478     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1479     function getAssetProxy(bytes4 assetProxyId)
1480         external
1481         view
1482         returns (address);
1483 }
1484 
1485 contract IMatchOrders {
1486 
1487     /// @dev Match two complementary orders that have a profitable spread.
1488     ///      Each order is filled at their respective price point. However, the calculations are
1489     ///      carried out as though the orders are both being filled at the right order's price point.
1490     ///      The profit made by the left order goes to the taker (who matched the two orders).
1491     /// @param leftOrder First order to match.
1492     /// @param rightOrder Second order to match.
1493     /// @param leftSignature Proof that order was created by the left maker.
1494     /// @param rightSignature Proof that order was created by the right maker.
1495     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
1496     function matchOrders(
1497         LibOrder.Order memory leftOrder,
1498         LibOrder.Order memory rightOrder,
1499         bytes memory leftSignature,
1500         bytes memory rightSignature
1501     )
1502         public
1503         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1504 }
1505 
1506 contract ISignatureValidator {
1507 
1508     /// @dev Approves a hash on-chain using any valid signature type.
1509     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1510     /// @param signerAddress Address that should have signed the given hash.
1511     /// @param signature Proof that the hash has been signed by signer.
1512     function preSign(
1513         bytes32 hash,
1514         address signerAddress,
1515         bytes signature
1516     )
1517         external;
1518     
1519     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1520     /// @param validatorAddress Address of Validator contract.
1521     /// @param approval Approval or disapproval of  Validator contract.
1522     function setSignatureValidatorApproval(
1523         address validatorAddress,
1524         bool approval
1525     )
1526         external;
1527 
1528     /// @dev Verifies that a signature is valid.
1529     /// @param hash Message hash that is signed.
1530     /// @param signerAddress Address of signer.
1531     /// @param signature Proof of signing.
1532     /// @return Validity of order signature.
1533     function isValidSignature(
1534         bytes32 hash,
1535         address signerAddress,
1536         bytes memory signature
1537     )
1538         public
1539         view
1540         returns (bool isValid);
1541 }
1542 
1543 contract ITransactions {
1544 
1545     /// @dev Executes an exchange method call in the context of signer.
1546     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1547     /// @param signerAddress Address of transaction signer.
1548     /// @param data AbiV2 encoded calldata.
1549     /// @param signature Proof of signer transaction by signer.
1550     function executeTransaction(
1551         uint256 salt,
1552         address signerAddress,
1553         bytes data,
1554         bytes signature
1555     )
1556         external;
1557 }
1558 
1559 contract IWrapperFunctions {
1560 
1561     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1562     /// @param order LibOrder.Order struct containing order specifications.
1563     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1564     /// @param signature Proof that order has been created by maker.
1565     function fillOrKillOrder(
1566         LibOrder.Order memory order,
1567         uint256 takerAssetFillAmount,
1568         bytes memory signature
1569     )
1570         public
1571         returns (LibFillResults.FillResults memory fillResults);
1572 
1573     /// @dev Fills an order with specified parameters and ECDSA signature.
1574     ///      Returns false if the transaction would otherwise revert.
1575     /// @param order LibOrder.Order struct containing order specifications.
1576     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1577     /// @param signature Proof that order has been created by maker.
1578     /// @return Amounts filled and fees paid by maker and taker.
1579     function fillOrderNoThrow(
1580         LibOrder.Order memory order,
1581         uint256 takerAssetFillAmount,
1582         bytes memory signature
1583     )
1584         public
1585         returns (LibFillResults.FillResults memory fillResults);
1586 
1587     /// @dev Synchronously executes multiple calls of fillOrder.
1588     /// @param orders Array of order specifications.
1589     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1590     /// @param signatures Proofs that orders have been created by makers.
1591     /// @return Amounts filled and fees paid by makers and taker.
1592     function batchFillOrders(
1593         LibOrder.Order[] memory orders,
1594         uint256[] memory takerAssetFillAmounts,
1595         bytes[] memory signatures
1596     )
1597         public
1598         returns (LibFillResults.FillResults memory totalFillResults);
1599 
1600     /// @dev Synchronously executes multiple calls of fillOrKill.
1601     /// @param orders Array of order specifications.
1602     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1603     /// @param signatures Proofs that orders have been created by makers.
1604     /// @return Amounts filled and fees paid by makers and taker.
1605     function batchFillOrKillOrders(
1606         LibOrder.Order[] memory orders,
1607         uint256[] memory takerAssetFillAmounts,
1608         bytes[] memory signatures
1609     )
1610         public
1611         returns (LibFillResults.FillResults memory totalFillResults);
1612 
1613     /// @dev Fills an order with specified parameters and ECDSA signature.
1614     ///      Returns false if the transaction would otherwise revert.
1615     /// @param orders Array of order specifications.
1616     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1617     /// @param signatures Proofs that orders have been created by makers.
1618     /// @return Amounts filled and fees paid by makers and taker.
1619     function batchFillOrdersNoThrow(
1620         LibOrder.Order[] memory orders,
1621         uint256[] memory takerAssetFillAmounts,
1622         bytes[] memory signatures
1623     )
1624         public
1625         returns (LibFillResults.FillResults memory totalFillResults);
1626 
1627     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1628     /// @param orders Array of order specifications.
1629     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1630     /// @param signatures Proofs that orders have been created by makers.
1631     /// @return Amounts filled and fees paid by makers and taker.
1632     function marketSellOrders(
1633         LibOrder.Order[] memory orders,
1634         uint256 takerAssetFillAmount,
1635         bytes[] memory signatures
1636     )
1637         public
1638         returns (LibFillResults.FillResults memory totalFillResults);
1639 
1640     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1641     ///      Returns false if the transaction would otherwise revert.
1642     /// @param orders Array of order specifications.
1643     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1644     /// @param signatures Proofs that orders have been signed by makers.
1645     /// @return Amounts filled and fees paid by makers and taker.
1646     function marketSellOrdersNoThrow(
1647         LibOrder.Order[] memory orders,
1648         uint256 takerAssetFillAmount,
1649         bytes[] memory signatures
1650     )
1651         public
1652         returns (LibFillResults.FillResults memory totalFillResults);
1653 
1654     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
1655     /// @param orders Array of order specifications.
1656     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1657     /// @param signatures Proofs that orders have been signed by makers.
1658     /// @return Amounts filled and fees paid by makers and taker.
1659     function marketBuyOrders(
1660         LibOrder.Order[] memory orders,
1661         uint256 makerAssetFillAmount,
1662         bytes[] memory signatures
1663     )
1664         public
1665         returns (LibFillResults.FillResults memory totalFillResults);
1666 
1667     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
1668     ///      Returns false if the transaction would otherwise revert.
1669     /// @param orders Array of order specifications.
1670     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1671     /// @param signatures Proofs that orders have been signed by makers.
1672     /// @return Amounts filled and fees paid by makers and taker.
1673     function marketBuyOrdersNoThrow(
1674         LibOrder.Order[] memory orders,
1675         uint256 makerAssetFillAmount,
1676         bytes[] memory signatures
1677     )
1678         public
1679         returns (LibFillResults.FillResults memory totalFillResults);
1680 
1681     /// @dev Synchronously cancels multiple orders in a single transaction.
1682     /// @param orders Array of order specifications.
1683     function batchCancelOrders(LibOrder.Order[] memory orders)
1684         public;
1685 
1686     /// @dev Fetches information for all passed in orders
1687     /// @param orders Array of order specifications.
1688     /// @return Array of OrderInfo instances that correspond to each order.
1689     function getOrdersInfo(LibOrder.Order[] memory orders)
1690         public
1691         view
1692         returns (LibOrder.OrderInfo[] memory);
1693 }
1694 
1695 // solhint-disable no-empty-blocks
1696 contract IExchange is
1697     IExchangeCore,
1698     IMatchOrders,
1699     ISignatureValidator,
1700     ITransactions,
1701     IAssetProxyDispatcher,
1702     IWrapperFunctions
1703 {}
1704 
1705 contract MExchangeCore is
1706     IExchangeCore
1707 {
1708     // Fill event is emitted whenever an order is filled.
1709     event Fill(
1710         address indexed makerAddress,         // Address that created the order.      
1711         address indexed feeRecipientAddress,  // Address that received fees.
1712         address takerAddress,                 // Address that filled the order.
1713         address senderAddress,                // Address that called the Exchange contract (msg.sender).
1714         uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker. 
1715         uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
1716         uint256 makerFeePaid,                 // Amount of ZRX paid to feeRecipient by maker.
1717         uint256 takerFeePaid,                 // Amount of ZRX paid to feeRecipient by taker.
1718         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
1719         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
1720         bytes takerAssetData                  // Encoded data specific to takerAsset.
1721     );
1722 
1723     // Cancel event is emitted whenever an individual order is cancelled.
1724     event Cancel(
1725         address indexed makerAddress,         // Address that created the order.      
1726         address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.   
1727         address senderAddress,                // Address that called the Exchange contract (msg.sender).
1728         bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
1729         bytes makerAssetData,                 // Encoded data specific to makerAsset. 
1730         bytes takerAssetData                  // Encoded data specific to takerAsset.
1731     );
1732 
1733     // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
1734     event CancelUpTo(
1735         address indexed makerAddress,         // Orders cancelled must have been created by this address.
1736         address indexed senderAddress,        // Orders cancelled must have a `senderAddress` equal to this address.
1737         uint256 orderEpoch                    // Orders with specified makerAddress and senderAddress with a salt less than this value are considered cancelled.
1738     );
1739 
1740     /// @dev Fills the input order.
1741     /// @param order Order struct containing order specifications.
1742     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1743     /// @param signature Proof that order has been created by maker.
1744     /// @return Amounts filled and fees paid by maker and taker.
1745     function fillOrderInternal(
1746         LibOrder.Order memory order,
1747         uint256 takerAssetFillAmount,
1748         bytes memory signature
1749     )
1750         internal
1751         returns (LibFillResults.FillResults memory fillResults);
1752 
1753     /// @dev After calling, the order can not be filled anymore.
1754     /// @param order Order struct containing order specifications.
1755     function cancelOrderInternal(LibOrder.Order memory order)
1756         internal;
1757 
1758     /// @dev Updates state with results of a fill order.
1759     /// @param order that was filled.
1760     /// @param takerAddress Address of taker who filled the order.
1761     /// @param orderTakerAssetFilledAmount Amount of order already filled.
1762     /// @return fillResults Amounts filled and fees paid by maker and taker.
1763     function updateFilledState(
1764         LibOrder.Order memory order,
1765         address takerAddress,
1766         bytes32 orderHash,
1767         uint256 orderTakerAssetFilledAmount,
1768         LibFillResults.FillResults memory fillResults
1769     )
1770         internal;
1771 
1772     /// @dev Updates state with results of cancelling an order.
1773     ///      State is only updated if the order is currently fillable.
1774     ///      Otherwise, updating state would have no effect.
1775     /// @param order that was cancelled.
1776     /// @param orderHash Hash of order that was cancelled.
1777     function updateCancelledState(
1778         LibOrder.Order memory order,
1779         bytes32 orderHash
1780     )
1781         internal;
1782     
1783     /// @dev Validates context for fillOrder. Succeeds or throws.
1784     /// @param order to be filled.
1785     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1786     /// @param takerAddress Address of order taker.
1787     /// @param signature Proof that the orders was created by its maker.
1788     function assertFillableOrder(
1789         LibOrder.Order memory order,
1790         LibOrder.OrderInfo memory orderInfo,
1791         address takerAddress,
1792         bytes memory signature
1793     )
1794         internal
1795         view;
1796     
1797     /// @dev Validates context for fillOrder. Succeeds or throws.
1798     /// @param order to be filled.
1799     /// @param orderInfo Status, orderHash, and amount already filled of order.
1800     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
1801     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
1802     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
1803     function assertValidFill(
1804         LibOrder.Order memory order,
1805         LibOrder.OrderInfo memory orderInfo,
1806         uint256 takerAssetFillAmount,
1807         uint256 takerAssetFilledAmount,
1808         uint256 makerAssetFilledAmount
1809     )
1810         internal
1811         view;
1812 
1813     /// @dev Validates context for cancelOrder. Succeeds or throws.
1814     /// @param order to be cancelled.
1815     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
1816     function assertValidCancel(
1817         LibOrder.Order memory order,
1818         LibOrder.OrderInfo memory orderInfo
1819     )
1820         internal
1821         view;
1822 
1823     /// @dev Calculates amounts filled and fees paid by maker and taker.
1824     /// @param order to be filled.
1825     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
1826     /// @return fillResults Amounts filled and fees paid by maker and taker.
1827     function calculateFillResults(
1828         LibOrder.Order memory order,
1829         uint256 takerAssetFilledAmount
1830     )
1831         internal
1832         pure
1833         returns (LibFillResults.FillResults memory fillResults);
1834 
1835 }
1836 
1837 contract MAssetProxyDispatcher is
1838     IAssetProxyDispatcher
1839 {
1840     // Logs registration of new asset proxy
1841     event AssetProxyRegistered(
1842         bytes4 id,              // Id of new registered AssetProxy.
1843         address assetProxy      // Address of new registered AssetProxy.
1844     );
1845 
1846     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
1847     /// @param assetData Byte array encoded for the asset.
1848     /// @param from Address to transfer token from.
1849     /// @param to Address to transfer token to.
1850     /// @param amount Amount of token to transfer.
1851     function dispatchTransferFrom(
1852         bytes memory assetData,
1853         address from,
1854         address to,
1855         uint256 amount
1856     )
1857         internal;
1858 }
1859 
1860 contract MMatchOrders is
1861     IMatchOrders
1862 {
1863     /// @dev Validates context for matchOrders. Succeeds or throws.
1864     /// @param leftOrder First order to match.
1865     /// @param rightOrder Second order to match.
1866     function assertValidMatch(
1867         LibOrder.Order memory leftOrder,
1868         LibOrder.Order memory rightOrder
1869     )
1870         internal
1871         pure;
1872 
1873     /// @dev Calculates fill amounts for the matched orders.
1874     ///      Each order is filled at their respective price point. However, the calculations are
1875     ///      carried out as though the orders are both being filled at the right order's price point.
1876     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
1877     /// @param leftOrder First order to match.
1878     /// @param rightOrder Second order to match.
1879     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
1880     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
1881     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
1882     function calculateMatchedFillResults(
1883         LibOrder.Order memory leftOrder,
1884         LibOrder.Order memory rightOrder,
1885         uint256 leftOrderTakerAssetFilledAmount,
1886         uint256 rightOrderTakerAssetFilledAmount
1887     )
1888         internal
1889         pure
1890         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1891 
1892 }
1893 
1894 contract MSignatureValidator is
1895     ISignatureValidator
1896 {
1897     event SignatureValidatorApproval(
1898         address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
1899         address indexed validatorAddress,  // Address of signature validator contract.
1900         bool approved                      // Approval or disapproval of validator contract.
1901     );
1902 
1903     // Allowed signature types.
1904     enum SignatureType {
1905         Illegal,         // 0x00, default value
1906         Invalid,         // 0x01
1907         EIP712,          // 0x02
1908         EthSign,         // 0x03
1909         Wallet,          // 0x04
1910         Validator,       // 0x05
1911         PreSigned,       // 0x06
1912         NSignatureTypes  // 0x07, number of signature types. Always leave at end.
1913     }
1914 
1915     /// @dev Verifies signature using logic defined by Wallet contract.
1916     /// @param hash Any 32 byte hash.
1917     /// @param walletAddress Address that should have signed the given hash
1918     ///                      and defines its own signature verification method.
1919     /// @param signature Proof that the hash has been signed by signer.
1920     /// @return True if the address recovered from the provided signature matches the input signer address.
1921     function isValidWalletSignature(
1922         bytes32 hash,
1923         address walletAddress,
1924         bytes signature
1925     )
1926         internal
1927         view
1928         returns (bool isValid);
1929 
1930     /// @dev Verifies signature using logic defined by Validator contract.
1931     /// @param validatorAddress Address of validator contract.
1932     /// @param hash Any 32 byte hash.
1933     /// @param signerAddress Address that should have signed the given hash.
1934     /// @param signature Proof that the hash has been signed by signer.
1935     /// @return True if the address recovered from the provided signature matches the input signer address.
1936     function isValidValidatorSignature(
1937         address validatorAddress,
1938         bytes32 hash,
1939         address signerAddress,
1940         bytes signature
1941     )
1942         internal
1943         view
1944         returns (bool isValid);
1945 }
1946 
1947 contract MTransactions is
1948     ITransactions
1949 {
1950     // Hash for the EIP712 ZeroEx Transaction Schema
1951     bytes32 constant internal EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH = keccak256(abi.encodePacked(
1952         "ZeroExTransaction(",
1953         "uint256 salt,",
1954         "address signerAddress,",
1955         "bytes data",
1956         ")"
1957     ));
1958 
1959     /// @dev Calculates EIP712 hash of the Transaction.
1960     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1961     /// @param signerAddress Address of transaction signer.
1962     /// @param data AbiV2 encoded calldata.
1963     /// @return EIP712 hash of the Transaction.
1964     function hashZeroExTransaction(
1965         uint256 salt,
1966         address signerAddress,
1967         bytes memory data
1968     )
1969         internal
1970         pure
1971         returns (bytes32 result);
1972 
1973     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
1974     ///      If calling a fill function, this address will represent the taker.
1975     ///      If calling a cancel function, this address will represent the maker.
1976     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
1977     ///         `msg.sender` if entry point is any other function.
1978     function getCurrentContextAddress()
1979         internal
1980         view
1981         returns (address);
1982 }
1983 
1984 contract MWrapperFunctions is 
1985     IWrapperFunctions
1986 {
1987     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1988     /// @param order LibOrder.Order struct containing order specifications.
1989     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1990     /// @param signature Proof that order has been created by maker.
1991     function fillOrKillOrderInternal(
1992         LibOrder.Order memory order,
1993         uint256 takerAssetFillAmount,
1994         bytes memory signature
1995     )
1996         internal
1997         returns (LibFillResults.FillResults memory fillResults);
1998 }
1999 
2000 contract Ownable is
2001     IOwnable
2002 {
2003     address public owner;
2004 
2005     constructor ()
2006         public
2007     {
2008         owner = msg.sender;
2009     }
2010 
2011     modifier onlyOwner() {
2012         require(
2013             msg.sender == owner,
2014             "ONLY_CONTRACT_OWNER"
2015         );
2016         _;
2017     }
2018 
2019     function transferOwnership(address newOwner)
2020         public
2021         onlyOwner
2022     {
2023         if (newOwner != address(0)) {
2024             owner = newOwner;
2025         }
2026     }
2027 }
2028 
2029 contract MixinExchangeCore is
2030     ReentrancyGuard,
2031     LibConstants,
2032     LibMath,
2033     LibOrder,
2034     LibFillResults,
2035     MAssetProxyDispatcher,
2036     MExchangeCore,
2037     MSignatureValidator,
2038     MTransactions
2039 {
2040     // Mapping of orderHash => amount of takerAsset already bought by maker
2041     mapping (bytes32 => uint256) public filled;
2042 
2043     // Mapping of orderHash => cancelled
2044     mapping (bytes32 => bool) public cancelled;
2045 
2046     // Mapping of makerAddress => senderAddress => lowest salt an order can have in order to be fillable
2047     // Orders with specified senderAddress and with a salt less than their epoch are considered cancelled
2048     mapping (address => mapping (address => uint256)) public orderEpoch;
2049 
2050     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
2051     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
2052     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
2053     function cancelOrdersUpTo(uint256 targetOrderEpoch)
2054         external
2055         nonReentrant
2056     {
2057         address makerAddress = getCurrentContextAddress();
2058         // If this function is called via `executeTransaction`, we only update the orderEpoch for the makerAddress/msg.sender combination.
2059         // This allows external filter contracts to add rules to how orders are cancelled via this function.
2060         address senderAddress = makerAddress == msg.sender ? address(0) : msg.sender;
2061 
2062         // orderEpoch is initialized to 0, so to cancelUpTo we need salt + 1
2063         uint256 newOrderEpoch = targetOrderEpoch + 1;  
2064         uint256 oldOrderEpoch = orderEpoch[makerAddress][senderAddress];
2065 
2066         // Ensure orderEpoch is monotonically increasing
2067         require(
2068             newOrderEpoch > oldOrderEpoch, 
2069             "INVALID_NEW_ORDER_EPOCH"
2070         );
2071 
2072         // Update orderEpoch
2073         orderEpoch[makerAddress][senderAddress] = newOrderEpoch;
2074         emit CancelUpTo(
2075             makerAddress,
2076             senderAddress,
2077             newOrderEpoch
2078         );
2079     }
2080 
2081     /// @dev Fills the input order.
2082     /// @param order Order struct containing order specifications.
2083     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2084     /// @param signature Proof that order has been created by maker.
2085     /// @return Amounts filled and fees paid by maker and taker.
2086     function fillOrder(
2087         Order memory order,
2088         uint256 takerAssetFillAmount,
2089         bytes memory signature
2090     )
2091         public
2092         nonReentrant
2093         returns (FillResults memory fillResults)
2094     {
2095         fillResults = fillOrderInternal(
2096             order,
2097             takerAssetFillAmount,
2098             signature
2099         );
2100         return fillResults;
2101     }
2102 
2103     /// @dev After calling, the order can not be filled anymore.
2104     ///      Throws if order is invalid or sender does not have permission to cancel.
2105     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
2106     function cancelOrder(Order memory order)
2107         public
2108         nonReentrant
2109     {
2110         cancelOrderInternal(order);
2111     }
2112 
2113     /// @dev Gets information about an order: status, hash, and amount filled.
2114     /// @param order Order to gather information on.
2115     /// @return OrderInfo Information about the order and its state.
2116     ///         See LibOrder.OrderInfo for a complete description.
2117     function getOrderInfo(Order memory order)
2118         public
2119         view
2120         returns (OrderInfo memory orderInfo)
2121     {
2122         // Compute the order hash
2123         orderInfo.orderHash = getOrderHash(order);
2124 
2125         // Fetch filled amount
2126         orderInfo.orderTakerAssetFilledAmount = filled[orderInfo.orderHash];
2127 
2128         // If order.makerAssetAmount is zero, we also reject the order.
2129         // While the Exchange contract handles them correctly, they create
2130         // edge cases in the supporting infrastructure because they have
2131         // an 'infinite' price when computed by a simple division.
2132         if (order.makerAssetAmount == 0) {
2133             orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_ASSET_AMOUNT);
2134             return orderInfo;
2135         }
2136 
2137         // If order.takerAssetAmount is zero, then the order will always
2138         // be considered filled because 0 == takerAssetAmount == orderTakerAssetFilledAmount
2139         // Instead of distinguishing between unfilled and filled zero taker
2140         // amount orders, we choose not to support them.
2141         if (order.takerAssetAmount == 0) {
2142             orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_ASSET_AMOUNT);
2143             return orderInfo;
2144         }
2145 
2146         // Validate order availability
2147         if (orderInfo.orderTakerAssetFilledAmount >= order.takerAssetAmount) {
2148             orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
2149             return orderInfo;
2150         }
2151 
2152         // Validate order expiration
2153         // solhint-disable-next-line not-rely-on-time
2154         if (block.timestamp >= order.expirationTimeSeconds) {
2155             orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
2156             return orderInfo;
2157         }
2158 
2159         // Check if order has been cancelled
2160         if (cancelled[orderInfo.orderHash]) {
2161             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
2162             return orderInfo;
2163         }
2164         if (orderEpoch[order.makerAddress][order.senderAddress] > order.salt) {
2165             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
2166             return orderInfo;
2167         }
2168 
2169         // All other statuses are ruled out: order is Fillable
2170         orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
2171         return orderInfo;
2172     }
2173 
2174     /// @dev Fills the input order.
2175     /// @param order Order struct containing order specifications.
2176     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2177     /// @param signature Proof that order has been created by maker.
2178     /// @return Amounts filled and fees paid by maker and taker.
2179     function fillOrderInternal(
2180         Order memory order,
2181         uint256 takerAssetFillAmount,
2182         bytes memory signature
2183     )
2184         internal
2185         returns (FillResults memory fillResults)
2186     {
2187         // Fetch order info
2188         OrderInfo memory orderInfo = getOrderInfo(order);
2189 
2190         // Fetch taker address
2191         address takerAddress = getCurrentContextAddress();
2192         
2193         // Assert that the order is fillable by taker
2194         assertFillableOrder(
2195             order,
2196             orderInfo,
2197             takerAddress,
2198             signature
2199         );
2200         
2201         // Get amount of takerAsset to fill
2202         uint256 remainingTakerAssetAmount = safeSub(order.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount);
2203         uint256 takerAssetFilledAmount = min256(takerAssetFillAmount, remainingTakerAssetAmount);
2204 
2205         // Validate context
2206         assertValidFill(
2207             order,
2208             orderInfo,
2209             takerAssetFillAmount,
2210             takerAssetFilledAmount,
2211             fillResults.makerAssetFilledAmount
2212         );
2213 
2214         // Compute proportional fill amounts
2215         fillResults = calculateFillResults(order, takerAssetFilledAmount);
2216 
2217         // Update exchange internal state
2218         updateFilledState(
2219             order,
2220             takerAddress,
2221             orderInfo.orderHash,
2222             orderInfo.orderTakerAssetFilledAmount,
2223             fillResults
2224         );
2225     
2226         // Settle order
2227         settleOrder(
2228             order,
2229             takerAddress,
2230             fillResults
2231         );
2232 
2233         return fillResults;
2234     }
2235 
2236     /// @dev After calling, the order can not be filled anymore.
2237     ///      Throws if order is invalid or sender does not have permission to cancel.
2238     /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
2239     function cancelOrderInternal(Order memory order)
2240         internal
2241     {
2242         // Fetch current order status
2243         OrderInfo memory orderInfo = getOrderInfo(order);
2244 
2245         // Validate context
2246         assertValidCancel(order, orderInfo);
2247 
2248         // Perform cancel
2249         updateCancelledState(order, orderInfo.orderHash);
2250     }
2251 
2252     /// @dev Updates state with results of a fill order.
2253     /// @param order that was filled.
2254     /// @param takerAddress Address of taker who filled the order.
2255     /// @param orderTakerAssetFilledAmount Amount of order already filled.
2256     function updateFilledState(
2257         Order memory order,
2258         address takerAddress,
2259         bytes32 orderHash,
2260         uint256 orderTakerAssetFilledAmount,
2261         FillResults memory fillResults
2262     )
2263         internal
2264     {
2265         // Update state
2266         filled[orderHash] = safeAdd(orderTakerAssetFilledAmount, fillResults.takerAssetFilledAmount);
2267 
2268         // Log order
2269         emit Fill(
2270             order.makerAddress,
2271             order.feeRecipientAddress,
2272             takerAddress,
2273             msg.sender,
2274             fillResults.makerAssetFilledAmount,
2275             fillResults.takerAssetFilledAmount,
2276             fillResults.makerFeePaid,
2277             fillResults.takerFeePaid,
2278             orderHash,
2279             order.makerAssetData,
2280             order.takerAssetData
2281         );
2282     }
2283 
2284     /// @dev Updates state with results of cancelling an order.
2285     ///      State is only updated if the order is currently fillable.
2286     ///      Otherwise, updating state would have no effect.
2287     /// @param order that was cancelled.
2288     /// @param orderHash Hash of order that was cancelled.
2289     function updateCancelledState(
2290         Order memory order,
2291         bytes32 orderHash
2292     )
2293         internal
2294     {
2295         // Perform cancel
2296         cancelled[orderHash] = true;
2297 
2298         // Log cancel
2299         emit Cancel(
2300             order.makerAddress,
2301             order.feeRecipientAddress,
2302             msg.sender,
2303             orderHash,
2304             order.makerAssetData,
2305             order.takerAssetData
2306         );
2307     }
2308     
2309     /// @dev Validates context for fillOrder. Succeeds or throws.
2310     /// @param order to be filled.
2311     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2312     /// @param takerAddress Address of order taker.
2313     /// @param signature Proof that the orders was created by its maker.
2314     function assertFillableOrder(
2315         Order memory order,
2316         OrderInfo memory orderInfo,
2317         address takerAddress,
2318         bytes memory signature
2319     )
2320         internal
2321         view
2322     {
2323         // An order can only be filled if its status is FILLABLE.
2324         require(
2325             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2326             "ORDER_UNFILLABLE"
2327         );
2328         
2329         // Validate sender is allowed to fill this order
2330         if (order.senderAddress != address(0)) {
2331             require(
2332                 order.senderAddress == msg.sender,
2333                 "INVALID_SENDER"
2334             );
2335         }
2336         
2337         // Validate taker is allowed to fill this order
2338         if (order.takerAddress != address(0)) {
2339             require(
2340                 order.takerAddress == takerAddress,
2341                 "INVALID_TAKER"
2342             );
2343         }
2344         
2345         // Validate Maker signature (check only if first time seen)
2346         if (orderInfo.orderTakerAssetFilledAmount == 0) {
2347             require(
2348                 isValidSignature(
2349                     orderInfo.orderHash,
2350                     order.makerAddress,
2351                     signature
2352                 ),
2353                 "INVALID_ORDER_SIGNATURE"
2354             );
2355         }
2356     }
2357     
2358     /// @dev Validates context for fillOrder. Succeeds or throws.
2359     /// @param order to be filled.
2360     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2361     /// @param takerAssetFillAmount Desired amount of order to fill by taker.
2362     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2363     /// @param makerAssetFilledAmount Amount of makerAsset that will be transfered.
2364     function assertValidFill(
2365         Order memory order,
2366         OrderInfo memory orderInfo,
2367         uint256 takerAssetFillAmount,  // TODO: use FillResults
2368         uint256 takerAssetFilledAmount,
2369         uint256 makerAssetFilledAmount
2370     )
2371         internal
2372         view
2373     {
2374         // Revert if fill amount is invalid
2375         // TODO: reconsider necessity for v2.1
2376         require(
2377             takerAssetFillAmount != 0,
2378             "INVALID_TAKER_AMOUNT"
2379         );
2380         
2381         // Make sure taker does not pay more than desired amount
2382         // NOTE: This assertion should never fail, it is here
2383         //       as an extra defence against potential bugs.
2384         require(
2385             takerAssetFilledAmount <= takerAssetFillAmount,
2386             "TAKER_OVERPAY"
2387         );
2388         
2389         // Make sure order is not overfilled
2390         // NOTE: This assertion should never fail, it is here
2391         //       as an extra defence against potential bugs.
2392         require(
2393             safeAdd(orderInfo.orderTakerAssetFilledAmount, takerAssetFilledAmount) <= order.takerAssetAmount,
2394             "ORDER_OVERFILL"
2395         );
2396         
2397         // Make sure order is filled at acceptable price.
2398         // The order has an implied price from the makers perspective:
2399         //    order price = order.makerAssetAmount / order.takerAssetAmount
2400         // i.e. the number of makerAsset maker is paying per takerAsset. The
2401         // maker is guaranteed to get this price or a better (lower) one. The
2402         // actual price maker is getting in this fill is:
2403         //    fill price = makerAssetFilledAmount / takerAssetFilledAmount
2404         // We need `fill price <= order price` for the fill to be fair to maker.
2405         // This amounts to:
2406         //     makerAssetFilledAmount        order.makerAssetAmount
2407         //    ------------------------  <=  -----------------------
2408         //     takerAssetFilledAmount        order.takerAssetAmount
2409         // or, equivalently:
2410         //     makerAssetFilledAmount * order.takerAssetAmount <=
2411         //     order.makerAssetAmount * takerAssetFilledAmount
2412         // NOTE: This assertion should never fail, it is here
2413         //       as an extra defence against potential bugs.
2414         require(
2415             safeMul(makerAssetFilledAmount, order.takerAssetAmount)
2416             <= 
2417             safeMul(order.makerAssetAmount, takerAssetFilledAmount),
2418             "INVALID_FILL_PRICE"
2419         );
2420     }
2421 
2422     /// @dev Validates context for cancelOrder. Succeeds or throws.
2423     /// @param order to be cancelled.
2424     /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
2425     function assertValidCancel(
2426         Order memory order,
2427         OrderInfo memory orderInfo
2428     )
2429         internal
2430         view
2431     {
2432         // Ensure order is valid
2433         // An order can only be cancelled if its status is FILLABLE.
2434         require(
2435             orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
2436             "ORDER_UNFILLABLE"
2437         );
2438 
2439         // Validate sender is allowed to cancel this order
2440         if (order.senderAddress != address(0)) {
2441             require(
2442                 order.senderAddress == msg.sender,
2443                 "INVALID_SENDER"
2444             );
2445         }
2446 
2447         // Validate transaction signed by maker
2448         address makerAddress = getCurrentContextAddress();
2449         require(
2450             order.makerAddress == makerAddress,
2451             "INVALID_MAKER"
2452         );
2453     }
2454 
2455     /// @dev Calculates amounts filled and fees paid by maker and taker.
2456     /// @param order to be filled.
2457     /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
2458     /// @return fillResults Amounts filled and fees paid by maker and taker.
2459     function calculateFillResults(
2460         Order memory order,
2461         uint256 takerAssetFilledAmount
2462     )
2463         internal
2464         pure
2465         returns (FillResults memory fillResults)
2466     {
2467         // Compute proportional transfer amounts
2468         fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
2469         fillResults.makerAssetFilledAmount = safeGetPartialAmountFloor(
2470             takerAssetFilledAmount,
2471             order.takerAssetAmount,
2472             order.makerAssetAmount
2473         );
2474         fillResults.makerFeePaid = safeGetPartialAmountFloor(
2475             fillResults.makerAssetFilledAmount,
2476             order.makerAssetAmount,
2477             order.makerFee
2478         );
2479         fillResults.takerFeePaid = safeGetPartialAmountFloor(
2480             takerAssetFilledAmount,
2481             order.takerAssetAmount,
2482             order.takerFee
2483         );
2484 
2485         return fillResults;
2486     }
2487 
2488     /// @dev Settles an order by transferring assets between counterparties.
2489     /// @param order Order struct containing order specifications.
2490     /// @param takerAddress Address selling takerAsset and buying makerAsset.
2491     /// @param fillResults Amounts to be filled and fees paid by maker and taker.
2492     function settleOrder(
2493         LibOrder.Order memory order,
2494         address takerAddress,
2495         LibFillResults.FillResults memory fillResults
2496     )
2497         private
2498     {
2499         bytes memory zrxAssetData = ZRX_ASSET_DATA;
2500         dispatchTransferFrom(
2501             order.makerAssetData,
2502             order.makerAddress,
2503             takerAddress,
2504             fillResults.makerAssetFilledAmount
2505         );
2506         dispatchTransferFrom(
2507             order.takerAssetData,
2508             takerAddress,
2509             order.makerAddress,
2510             fillResults.takerAssetFilledAmount
2511         );
2512         dispatchTransferFrom(
2513             zrxAssetData,
2514             order.makerAddress,
2515             order.feeRecipientAddress,
2516             fillResults.makerFeePaid
2517         );
2518         dispatchTransferFrom(
2519             zrxAssetData,
2520             takerAddress,
2521             order.feeRecipientAddress,
2522             fillResults.takerFeePaid
2523         );
2524     }
2525 }
2526 
2527 contract MixinSignatureValidator is
2528     ReentrancyGuard,
2529     MSignatureValidator,
2530     MTransactions
2531 {
2532     using LibBytes for bytes;
2533     
2534     // Mapping of hash => signer => signed
2535     mapping (bytes32 => mapping (address => bool)) public preSigned;
2536 
2537     // Mapping of signer => validator => approved
2538     mapping (address => mapping (address => bool)) public allowedValidators;
2539 
2540     /// @dev Approves a hash on-chain using any valid signature type.
2541     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
2542     /// @param signerAddress Address that should have signed the given hash.
2543     /// @param signature Proof that the hash has been signed by signer.
2544     function preSign(
2545         bytes32 hash,
2546         address signerAddress,
2547         bytes signature
2548     )
2549         external
2550     {
2551         if (signerAddress != msg.sender) {
2552             require(
2553                 isValidSignature(
2554                     hash,
2555                     signerAddress,
2556                     signature
2557                 ),
2558                 "INVALID_SIGNATURE"
2559             );
2560         }
2561         preSigned[hash][signerAddress] = true;
2562     }
2563 
2564     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
2565     /// @param validatorAddress Address of Validator contract.
2566     /// @param approval Approval or disapproval of  Validator contract.
2567     function setSignatureValidatorApproval(
2568         address validatorAddress,
2569         bool approval
2570     )
2571         external
2572         nonReentrant
2573     {
2574         address signerAddress = getCurrentContextAddress();
2575         allowedValidators[signerAddress][validatorAddress] = approval;
2576         emit SignatureValidatorApproval(
2577             signerAddress,
2578             validatorAddress,
2579             approval
2580         );
2581     }
2582 
2583     /// @dev Verifies that a hash has been signed by the given signer.
2584     /// @param hash Any 32 byte hash.
2585     /// @param signerAddress Address that should have signed the given hash.
2586     /// @param signature Proof that the hash has been signed by signer.
2587     /// @return True if the address recovered from the provided signature matches the input signer address.
2588     function isValidSignature(
2589         bytes32 hash,
2590         address signerAddress,
2591         bytes memory signature
2592     )
2593         public
2594         view
2595         returns (bool isValid)
2596     {
2597         require(
2598             signature.length > 0,
2599             "LENGTH_GREATER_THAN_0_REQUIRED"
2600         );
2601 
2602         // Pop last byte off of signature byte array.
2603         uint8 signatureTypeRaw = uint8(signature.popLastByte());
2604 
2605         // Ensure signature is supported
2606         require(
2607             signatureTypeRaw < uint8(SignatureType.NSignatureTypes),
2608             "SIGNATURE_UNSUPPORTED"
2609         );
2610 
2611         SignatureType signatureType = SignatureType(signatureTypeRaw);
2612 
2613         // Variables are not scoped in Solidity.
2614         uint8 v;
2615         bytes32 r;
2616         bytes32 s;
2617         address recovered;
2618 
2619         // Always illegal signature.
2620         // This is always an implicit option since a signer can create a
2621         // signature array with invalid type or length. We may as well make
2622         // it an explicit option. This aids testing and analysis. It is
2623         // also the initialization value for the enum type.
2624         if (signatureType == SignatureType.Illegal) {
2625             revert("SIGNATURE_ILLEGAL");
2626 
2627         // Always invalid signature.
2628         // Like Illegal, this is always implicitly available and therefore
2629         // offered explicitly. It can be implicitly created by providing
2630         // a correctly formatted but incorrect signature.
2631         } else if (signatureType == SignatureType.Invalid) {
2632             require(
2633                 signature.length == 0,
2634                 "LENGTH_0_REQUIRED"
2635             );
2636             isValid = false;
2637             return isValid;
2638 
2639         // Signature using EIP712
2640         } else if (signatureType == SignatureType.EIP712) {
2641             require(
2642                 signature.length == 65,
2643                 "LENGTH_65_REQUIRED"
2644             );
2645             v = uint8(signature[0]);
2646             r = signature.readBytes32(1);
2647             s = signature.readBytes32(33);
2648             recovered = ecrecover(
2649                 hash,
2650                 v,
2651                 r,
2652                 s
2653             );
2654             isValid = signerAddress == recovered;
2655             return isValid;
2656 
2657         // Signed using web3.eth_sign
2658         } else if (signatureType == SignatureType.EthSign) {
2659             require(
2660                 signature.length == 65,
2661                 "LENGTH_65_REQUIRED"
2662             );
2663             v = uint8(signature[0]);
2664             r = signature.readBytes32(1);
2665             s = signature.readBytes32(33);
2666             recovered = ecrecover(
2667                 keccak256(abi.encodePacked(
2668                     "\x19Ethereum Signed Message:\n32",
2669                     hash
2670                 )),
2671                 v,
2672                 r,
2673                 s
2674             );
2675             isValid = signerAddress == recovered;
2676             return isValid;
2677 
2678         // Signature verified by wallet contract.
2679         // If used with an order, the maker of the order is the wallet contract.
2680         } else if (signatureType == SignatureType.Wallet) {
2681             isValid = isValidWalletSignature(
2682                 hash,
2683                 signerAddress,
2684                 signature
2685             );
2686             return isValid;
2687 
2688         // Signature verified by validator contract.
2689         // If used with an order, the maker of the order can still be an EOA.
2690         // A signature using this type should be encoded as:
2691         // | Offset   | Length | Contents                        |
2692         // | 0x00     | x      | Signature to validate           |
2693         // | 0x00 + x | 20     | Address of validator contract   |
2694         // | 0x14 + x | 1      | Signature type is always "\x06" |
2695         } else if (signatureType == SignatureType.Validator) {
2696             // Pop last 20 bytes off of signature byte array.
2697             address validatorAddress = signature.popLast20Bytes();
2698             
2699             // Ensure signer has approved validator.
2700             if (!allowedValidators[signerAddress][validatorAddress]) {
2701                 return false;
2702             }
2703             isValid = isValidValidatorSignature(
2704                 validatorAddress,
2705                 hash,
2706                 signerAddress,
2707                 signature
2708             );
2709             return isValid;
2710 
2711         // Signer signed hash previously using the preSign function.
2712         } else if (signatureType == SignatureType.PreSigned) {
2713             isValid = preSigned[hash][signerAddress];
2714             return isValid;
2715         }
2716 
2717         // Anything else is illegal (We do not return false because
2718         // the signature may actually be valid, just not in a format
2719         // that we currently support. In this case returning false
2720         // may lead the caller to incorrectly believe that the
2721         // signature was invalid.)
2722         revert("SIGNATURE_UNSUPPORTED");
2723     }
2724 
2725     /// @dev Verifies signature using logic defined by Wallet contract.
2726     /// @param hash Any 32 byte hash.
2727     /// @param walletAddress Address that should have signed the given hash
2728     ///                      and defines its own signature verification method.
2729     /// @param signature Proof that the hash has been signed by signer.
2730     /// @return True if signature is valid for given wallet..
2731     function isValidWalletSignature(
2732         bytes32 hash,
2733         address walletAddress,
2734         bytes signature
2735     )
2736         internal
2737         view
2738         returns (bool isValid)
2739     {
2740         bytes memory calldata = abi.encodeWithSelector(
2741             IWallet(walletAddress).isValidSignature.selector,
2742             hash,
2743             signature
2744         );
2745         assembly {
2746             let cdStart := add(calldata, 32)
2747             let success := staticcall(
2748                 gas,              // forward all gas
2749                 walletAddress,    // address of Wallet contract
2750                 cdStart,          // pointer to start of input
2751                 mload(calldata),  // length of input
2752                 cdStart,          // write output over input
2753                 32                // output size is 32 bytes
2754             )
2755 
2756             switch success
2757             case 0 {
2758                 // Revert with `Error("WALLET_ERROR")`
2759                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
2760                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
2761                 mstore(64, 0x0000000c57414c4c45545f4552524f5200000000000000000000000000000000)
2762                 mstore(96, 0)
2763                 revert(0, 100)
2764             }
2765             case 1 {
2766                 // Signature is valid if call did not revert and returned true
2767                 isValid := mload(cdStart)
2768             }
2769         }
2770         return isValid;
2771     }
2772 
2773     /// @dev Verifies signature using logic defined by Validator contract.
2774     /// @param validatorAddress Address of validator contract.
2775     /// @param hash Any 32 byte hash.
2776     /// @param signerAddress Address that should have signed the given hash.
2777     /// @param signature Proof that the hash has been signed by signer.
2778     /// @return True if the address recovered from the provided signature matches the input signer address.
2779     function isValidValidatorSignature(
2780         address validatorAddress,
2781         bytes32 hash,
2782         address signerAddress,
2783         bytes signature
2784     )
2785         internal
2786         view
2787         returns (bool isValid)
2788     {
2789         bytes memory calldata = abi.encodeWithSelector(
2790             IValidator(signerAddress).isValidSignature.selector,
2791             hash,
2792             signerAddress,
2793             signature
2794         );
2795         assembly {
2796             let cdStart := add(calldata, 32)
2797             let success := staticcall(
2798                 gas,               // forward all gas
2799                 validatorAddress,  // address of Validator contract
2800                 cdStart,           // pointer to start of input
2801                 mload(calldata),   // length of input
2802                 cdStart,           // write output over input
2803                 32                 // output size is 32 bytes
2804             )
2805 
2806             switch success
2807             case 0 {
2808                 // Revert with `Error("VALIDATOR_ERROR")`
2809                 mstore(0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
2810                 mstore(32, 0x0000002000000000000000000000000000000000000000000000000000000000)
2811                 mstore(64, 0x0000000f56414c494441544f525f4552524f5200000000000000000000000000)
2812                 mstore(96, 0)
2813                 revert(0, 100)
2814             }
2815             case 1 {
2816                 // Signature is valid if call did not revert and returned true
2817                 isValid := mload(cdStart)
2818             }
2819         }
2820         return isValid;
2821     }
2822 }
2823 
2824 contract MixinWrapperFunctions is
2825     ReentrancyGuard,
2826     LibMath,
2827     LibFillResults,
2828     LibAbiEncoder,
2829     MExchangeCore,
2830     MWrapperFunctions
2831 {
2832     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
2833     /// @param order Order struct containing order specifications.
2834     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2835     /// @param signature Proof that order has been created by maker.
2836     function fillOrKillOrder(
2837         LibOrder.Order memory order,
2838         uint256 takerAssetFillAmount,
2839         bytes memory signature
2840     )
2841         public
2842         nonReentrant
2843         returns (FillResults memory fillResults)
2844     {
2845         fillResults = fillOrKillOrderInternal(
2846             order,
2847             takerAssetFillAmount,
2848             signature
2849         );
2850         return fillResults;
2851     }
2852 
2853     /// @dev Fills the input order.
2854     ///      Returns false if the transaction would otherwise revert.
2855     /// @param order Order struct containing order specifications.
2856     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2857     /// @param signature Proof that order has been created by maker.
2858     /// @return Amounts filled and fees paid by maker and taker.
2859     function fillOrderNoThrow(
2860         LibOrder.Order memory order,
2861         uint256 takerAssetFillAmount,
2862         bytes memory signature
2863     )
2864         public
2865         returns (FillResults memory fillResults)
2866     {
2867         // ABI encode calldata for `fillOrder`
2868         bytes memory fillOrderCalldata = abiEncodeFillOrder(
2869             order,
2870             takerAssetFillAmount,
2871             signature
2872         );
2873 
2874         // Delegate to `fillOrder` and handle any exceptions gracefully
2875         assembly {
2876             let success := delegatecall(
2877                 gas,                                // forward all gas
2878                 address,                            // call address of this contract
2879                 add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
2880                 mload(fillOrderCalldata),           // length of input
2881                 fillOrderCalldata,                  // write output over input
2882                 128                                 // output size is 128 bytes
2883             )
2884             if success {
2885                 mstore(fillResults, mload(fillOrderCalldata))
2886                 mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
2887                 mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
2888                 mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
2889             }
2890         }
2891         // fillResults values will be 0 by default if call was unsuccessful
2892         return fillResults;
2893     }
2894 
2895     /// @dev Synchronously executes multiple calls of fillOrder.
2896     /// @param orders Array of order specifications.
2897     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2898     /// @param signatures Proofs that orders have been created by makers.
2899     /// @return Amounts filled and fees paid by makers and taker.
2900     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2901     function batchFillOrders(
2902         LibOrder.Order[] memory orders,
2903         uint256[] memory takerAssetFillAmounts,
2904         bytes[] memory signatures
2905     )
2906         public
2907         nonReentrant
2908         returns (FillResults memory totalFillResults)
2909     {
2910         uint256 ordersLength = orders.length;
2911         for (uint256 i = 0; i != ordersLength; i++) {
2912             FillResults memory singleFillResults = fillOrderInternal(
2913                 orders[i],
2914                 takerAssetFillAmounts[i],
2915                 signatures[i]
2916             );
2917             addFillResults(totalFillResults, singleFillResults);
2918         }
2919         return totalFillResults;
2920     }
2921 
2922     /// @dev Synchronously executes multiple calls of fillOrKill.
2923     /// @param orders Array of order specifications.
2924     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2925     /// @param signatures Proofs that orders have been created by makers.
2926     /// @return Amounts filled and fees paid by makers and taker.
2927     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2928     function batchFillOrKillOrders(
2929         LibOrder.Order[] memory orders,
2930         uint256[] memory takerAssetFillAmounts,
2931         bytes[] memory signatures
2932     )
2933         public
2934         nonReentrant
2935         returns (FillResults memory totalFillResults)
2936     {
2937         uint256 ordersLength = orders.length;
2938         for (uint256 i = 0; i != ordersLength; i++) {
2939             FillResults memory singleFillResults = fillOrKillOrderInternal(
2940                 orders[i],
2941                 takerAssetFillAmounts[i],
2942                 signatures[i]
2943             );
2944             addFillResults(totalFillResults, singleFillResults);
2945         }
2946         return totalFillResults;
2947     }
2948 
2949     /// @dev Fills an order with specified parameters and ECDSA signature.
2950     ///      Returns false if the transaction would otherwise revert.
2951     /// @param orders Array of order specifications.
2952     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
2953     /// @param signatures Proofs that orders have been created by makers.
2954     /// @return Amounts filled and fees paid by makers and taker.
2955     ///         NOTE: makerAssetFilledAmount and takerAssetFilledAmount may include amounts filled of different assets.
2956     function batchFillOrdersNoThrow(
2957         LibOrder.Order[] memory orders,
2958         uint256[] memory takerAssetFillAmounts,
2959         bytes[] memory signatures
2960     )
2961         public
2962         returns (FillResults memory totalFillResults)
2963     {
2964         uint256 ordersLength = orders.length;
2965         for (uint256 i = 0; i != ordersLength; i++) {
2966             FillResults memory singleFillResults = fillOrderNoThrow(
2967                 orders[i],
2968                 takerAssetFillAmounts[i],
2969                 signatures[i]
2970             );
2971             addFillResults(totalFillResults, singleFillResults);
2972         }
2973         return totalFillResults;
2974     }
2975 
2976     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
2977     /// @param orders Array of order specifications.
2978     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2979     /// @param signatures Proofs that orders have been created by makers.
2980     /// @return Amounts filled and fees paid by makers and taker.
2981     function marketSellOrders(
2982         LibOrder.Order[] memory orders,
2983         uint256 takerAssetFillAmount,
2984         bytes[] memory signatures
2985     )
2986         public
2987         nonReentrant
2988         returns (FillResults memory totalFillResults)
2989     {
2990         bytes memory takerAssetData = orders[0].takerAssetData;
2991     
2992         uint256 ordersLength = orders.length;
2993         for (uint256 i = 0; i != ordersLength; i++) {
2994 
2995             // We assume that asset being sold by taker is the same for each order.
2996             // Rather than passing this in as calldata, we use the takerAssetData from the first order in all later orders.
2997             orders[i].takerAssetData = takerAssetData;
2998 
2999             // Calculate the remaining amount of takerAsset to sell
3000             uint256 remainingTakerAssetFillAmount = safeSub(takerAssetFillAmount, totalFillResults.takerAssetFilledAmount);
3001 
3002             // Attempt to sell the remaining amount of takerAsset
3003             FillResults memory singleFillResults = fillOrderInternal(
3004                 orders[i],
3005                 remainingTakerAssetFillAmount,
3006                 signatures[i]
3007             );
3008 
3009             // Update amounts filled and fees paid by maker and taker
3010             addFillResults(totalFillResults, singleFillResults);
3011 
3012             // Stop execution if the entire amount of takerAsset has been sold
3013             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
3014                 break;
3015             }
3016         }
3017         return totalFillResults;
3018     }
3019 
3020     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
3021     ///      Returns false if the transaction would otherwise revert.
3022     /// @param orders Array of order specifications.
3023     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3024     /// @param signatures Proofs that orders have been signed by makers.
3025     /// @return Amounts filled and fees paid by makers and taker.
3026     function marketSellOrdersNoThrow(
3027         LibOrder.Order[] memory orders,
3028         uint256 takerAssetFillAmount,
3029         bytes[] memory signatures
3030     )
3031         public
3032         returns (FillResults memory totalFillResults)
3033     {
3034         bytes memory takerAssetData = orders[0].takerAssetData;
3035 
3036         uint256 ordersLength = orders.length;
3037         for (uint256 i = 0; i != ordersLength; i++) {
3038 
3039             // We assume that asset being sold by taker is the same for each order.
3040             // Rather than passing this in as calldata, we use the takerAssetData from the first order in all later orders.
3041             orders[i].takerAssetData = takerAssetData;
3042 
3043             // Calculate the remaining amount of takerAsset to sell
3044             uint256 remainingTakerAssetFillAmount = safeSub(takerAssetFillAmount, totalFillResults.takerAssetFilledAmount);
3045 
3046             // Attempt to sell the remaining amount of takerAsset
3047             FillResults memory singleFillResults = fillOrderNoThrow(
3048                 orders[i],
3049                 remainingTakerAssetFillAmount,
3050                 signatures[i]
3051             );
3052 
3053             // Update amounts filled and fees paid by maker and taker
3054             addFillResults(totalFillResults, singleFillResults);
3055 
3056             // Stop execution if the entire amount of takerAsset has been sold
3057             if (totalFillResults.takerAssetFilledAmount >= takerAssetFillAmount) {
3058                 break;
3059             }
3060         }
3061         return totalFillResults;
3062     }
3063 
3064     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
3065     /// @param orders Array of order specifications.
3066     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3067     /// @param signatures Proofs that orders have been signed by makers.
3068     /// @return Amounts filled and fees paid by makers and taker.
3069     function marketBuyOrders(
3070         LibOrder.Order[] memory orders,
3071         uint256 makerAssetFillAmount,
3072         bytes[] memory signatures
3073     )
3074         public
3075         nonReentrant
3076         returns (FillResults memory totalFillResults)
3077     {
3078         bytes memory makerAssetData = orders[0].makerAssetData;
3079 
3080         uint256 ordersLength = orders.length;
3081         for (uint256 i = 0; i != ordersLength; i++) {
3082 
3083             // We assume that asset being bought by taker is the same for each order.
3084             // Rather than passing this in as calldata, we copy the makerAssetData from the first order onto all later orders.
3085             orders[i].makerAssetData = makerAssetData;
3086 
3087             // Calculate the remaining amount of makerAsset to buy
3088             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3089 
3090             // Convert the remaining amount of makerAsset to buy into remaining amount
3091             // of takerAsset to sell, assuming entire amount can be sold in the current order
3092             uint256 remainingTakerAssetFillAmount = getPartialAmountFloor(
3093                 orders[i].takerAssetAmount,
3094                 orders[i].makerAssetAmount,
3095                 remainingMakerAssetFillAmount
3096             );
3097 
3098             // Attempt to sell the remaining amount of takerAsset
3099             FillResults memory singleFillResults = fillOrderInternal(
3100                 orders[i],
3101                 remainingTakerAssetFillAmount,
3102                 signatures[i]
3103             );
3104 
3105             // Update amounts filled and fees paid by maker and taker
3106             addFillResults(totalFillResults, singleFillResults);
3107 
3108             // Stop execution if the entire amount of makerAsset has been bought
3109             if (totalFillResults.makerAssetFilledAmount >= makerAssetFillAmount) {
3110                 break;
3111             }
3112         }
3113         return totalFillResults;
3114     }
3115 
3116     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
3117     ///      Returns false if the transaction would otherwise revert.
3118     /// @param orders Array of order specifications.
3119     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3120     /// @param signatures Proofs that orders have been signed by makers.
3121     /// @return Amounts filled and fees paid by makers and taker.
3122     function marketBuyOrdersNoThrow(
3123         LibOrder.Order[] memory orders,
3124         uint256 makerAssetFillAmount,
3125         bytes[] memory signatures
3126     )
3127         public
3128         returns (FillResults memory totalFillResults)
3129     {
3130         bytes memory makerAssetData = orders[0].makerAssetData;
3131 
3132         uint256 ordersLength = orders.length;
3133         for (uint256 i = 0; i != ordersLength; i++) {
3134 
3135             // We assume that asset being bought by taker is the same for each order.
3136             // Rather than passing this in as calldata, we copy the makerAssetData from the first order onto all later orders.
3137             orders[i].makerAssetData = makerAssetData;
3138 
3139             // Calculate the remaining amount of makerAsset to buy
3140             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3141 
3142             // Convert the remaining amount of makerAsset to buy into remaining amount
3143             // of takerAsset to sell, assuming entire amount can be sold in the current order
3144             uint256 remainingTakerAssetFillAmount = getPartialAmountFloor(
3145                 orders[i].takerAssetAmount,
3146                 orders[i].makerAssetAmount,
3147                 remainingMakerAssetFillAmount
3148             );
3149 
3150             // Attempt to sell the remaining amount of takerAsset
3151             FillResults memory singleFillResults = fillOrderNoThrow(
3152                 orders[i],
3153                 remainingTakerAssetFillAmount,
3154                 signatures[i]
3155             );
3156 
3157             // Update amounts filled and fees paid by maker and taker
3158             addFillResults(totalFillResults, singleFillResults);
3159 
3160             // Stop execution if the entire amount of makerAsset has been bought
3161             if (totalFillResults.makerAssetFilledAmount >= makerAssetFillAmount) {
3162                 break;
3163             }
3164         }
3165         return totalFillResults;
3166     }
3167 
3168     /// @dev Synchronously cancels multiple orders in a single transaction.
3169     /// @param orders Array of order specifications.
3170     function batchCancelOrders(LibOrder.Order[] memory orders)
3171         public
3172         nonReentrant
3173     {
3174         uint256 ordersLength = orders.length;
3175         for (uint256 i = 0; i != ordersLength; i++) {
3176             cancelOrderInternal(orders[i]);
3177         }
3178     }
3179 
3180     /// @dev Fetches information for all passed in orders.
3181     /// @param orders Array of order specifications.
3182     /// @return Array of OrderInfo instances that correspond to each order.
3183     function getOrdersInfo(LibOrder.Order[] memory orders)
3184         public
3185         view
3186         returns (LibOrder.OrderInfo[] memory)
3187     {
3188         uint256 ordersLength = orders.length;
3189         LibOrder.OrderInfo[] memory ordersInfo = new LibOrder.OrderInfo[](ordersLength);
3190         for (uint256 i = 0; i != ordersLength; i++) {
3191             ordersInfo[i] = getOrderInfo(orders[i]);
3192         }
3193         return ordersInfo;
3194     }
3195 
3196     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
3197     /// @param order Order struct containing order specifications.
3198     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3199     /// @param signature Proof that order has been created by maker.
3200     function fillOrKillOrderInternal(
3201         LibOrder.Order memory order,
3202         uint256 takerAssetFillAmount,
3203         bytes memory signature
3204     )
3205         internal
3206         returns (FillResults memory fillResults)
3207     {
3208         fillResults = fillOrderInternal(
3209             order,
3210             takerAssetFillAmount,
3211             signature
3212         );
3213         require(
3214             fillResults.takerAssetFilledAmount == takerAssetFillAmount,
3215             "COMPLETE_FILL_FAILED"
3216         );
3217         return fillResults;
3218     }
3219 }
3220 
3221 contract MixinTransactions is
3222     LibEIP712,
3223     MSignatureValidator,
3224     MTransactions
3225 {
3226     // Mapping of transaction hash => executed
3227     // This prevents transactions from being executed more than once.
3228     mapping (bytes32 => bool) public transactions;
3229 
3230     // Address of current transaction signer
3231     address public currentContextAddress;
3232 
3233     /// @dev Executes an exchange method call in the context of signer.
3234     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3235     /// @param signerAddress Address of transaction signer.
3236     /// @param data AbiV2 encoded calldata.
3237     /// @param signature Proof of signer transaction by signer.
3238     function executeTransaction(
3239         uint256 salt,
3240         address signerAddress,
3241         bytes data,
3242         bytes signature
3243     )
3244         external
3245     {
3246         // Prevent reentrancy
3247         require(
3248             currentContextAddress == address(0),
3249             "REENTRANCY_ILLEGAL"
3250         );
3251 
3252         bytes32 transactionHash = hashEIP712Message(hashZeroExTransaction(
3253             salt,
3254             signerAddress,
3255             data
3256         ));
3257 
3258         // Validate transaction has not been executed
3259         require(
3260             !transactions[transactionHash],
3261             "INVALID_TX_HASH"
3262         );
3263 
3264         // Transaction always valid if signer is sender of transaction
3265         if (signerAddress != msg.sender) {
3266             // Validate signature
3267             require(
3268                 isValidSignature(
3269                     transactionHash,
3270                     signerAddress,
3271                     signature
3272                 ),
3273                 "INVALID_TX_SIGNATURE"
3274             );
3275 
3276             // Set the current transaction signer
3277             currentContextAddress = signerAddress;
3278         }
3279 
3280         // Execute transaction
3281         transactions[transactionHash] = true;
3282         require(
3283             address(this).delegatecall(data),
3284             "FAILED_EXECUTION"
3285         );
3286 
3287         // Reset current transaction signer if it was previously updated
3288         if (signerAddress != msg.sender) {
3289             currentContextAddress = address(0);
3290         }
3291     }
3292 
3293     /// @dev Calculates EIP712 hash of the Transaction.
3294     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
3295     /// @param signerAddress Address of transaction signer.
3296     /// @param data AbiV2 encoded calldata.
3297     /// @return EIP712 hash of the Transaction.
3298     function hashZeroExTransaction(
3299         uint256 salt,
3300         address signerAddress,
3301         bytes memory data
3302     )
3303         internal
3304         pure
3305         returns (bytes32 result)
3306     {
3307         bytes32 schemaHash = EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH;
3308         bytes32 dataHash = keccak256(data);
3309 
3310         // Assembly for more efficiently computing:
3311         // keccak256(abi.encodePacked(
3312         //     EIP712_ZEROEX_TRANSACTION_SCHEMA_HASH,
3313         //     salt,
3314         //     bytes32(signerAddress),
3315         //     keccak256(data)
3316         // ));
3317 
3318         assembly {
3319             // Load free memory pointer
3320             let memPtr := mload(64)
3321 
3322             mstore(memPtr, schemaHash)                                                               // hash of schema
3323             mstore(add(memPtr, 32), salt)                                                            // salt
3324             mstore(add(memPtr, 64), and(signerAddress, 0xffffffffffffffffffffffffffffffffffffffff))  // signerAddress
3325             mstore(add(memPtr, 96), dataHash)                                                        // hash of data
3326 
3327             // Compute hash
3328             result := keccak256(memPtr, 128)
3329         }
3330         return result;
3331     }
3332 
3333     /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
3334     ///      If calling a fill function, this address will represent the taker.
3335     ///      If calling a cancel function, this address will represent the maker.
3336     /// @return Signer of 0x transaction if entry point is `executeTransaction`.
3337     ///         `msg.sender` if entry point is any other function.
3338     function getCurrentContextAddress()
3339         internal
3340         view
3341         returns (address)
3342     {
3343         address currentContextAddress_ = currentContextAddress;
3344         address contextAddress = currentContextAddress_ == address(0) ? msg.sender : currentContextAddress_;
3345         return contextAddress;
3346     }
3347 }
3348 
3349 contract MixinAssetProxyDispatcher is
3350     Ownable,
3351     MAssetProxyDispatcher
3352 {
3353     // Mapping from Asset Proxy Id's to their respective Asset Proxy
3354     mapping (bytes4 => IAssetProxy) public assetProxies;
3355 
3356     /// @dev Registers an asset proxy to its asset proxy id.
3357     ///      Once an asset proxy is registered, it cannot be unregistered.
3358     /// @param assetProxy Address of new asset proxy to register.
3359     function registerAssetProxy(address assetProxy)
3360         external
3361         onlyOwner
3362     {
3363         IAssetProxy assetProxyContract = IAssetProxy(assetProxy);
3364 
3365         // Ensure that no asset proxy exists with current id.
3366         bytes4 assetProxyId = assetProxyContract.getProxyId();
3367         address currentAssetProxy = assetProxies[assetProxyId];
3368         require(
3369             currentAssetProxy == address(0),
3370             "ASSET_PROXY_ALREADY_EXISTS"
3371         );
3372 
3373         // Add asset proxy and log registration.
3374         assetProxies[assetProxyId] = assetProxyContract;
3375         emit AssetProxyRegistered(
3376             assetProxyId,
3377             assetProxy
3378         );
3379     }
3380 
3381     /// @dev Gets an asset proxy.
3382     /// @param assetProxyId Id of the asset proxy.
3383     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
3384     function getAssetProxy(bytes4 assetProxyId)
3385         external
3386         view
3387         returns (address)
3388     {
3389         return assetProxies[assetProxyId];
3390     }
3391 
3392     /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
3393     /// @param assetData Byte array encoded for the asset.
3394     /// @param from Address to transfer token from.
3395     /// @param to Address to transfer token to.
3396     /// @param amount Amount of token to transfer.
3397     function dispatchTransferFrom(
3398         bytes memory assetData,
3399         address from,
3400         address to,
3401         uint256 amount
3402     )
3403         internal
3404     {
3405         // Do nothing if no amount should be transferred.
3406         if (amount > 0 && from != to) {
3407             // Ensure assetData length is valid
3408             require(
3409                 assetData.length > 3,
3410                 "LENGTH_GREATER_THAN_3_REQUIRED"
3411             );
3412             
3413             // Lookup assetProxy. We do not use `LibBytes.readBytes4` for gas efficiency reasons.
3414             bytes4 assetProxyId;
3415             assembly {
3416                 assetProxyId := and(mload(
3417                     add(assetData, 32)),
3418                     0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
3419                 )
3420             }
3421             address assetProxy = assetProxies[assetProxyId];
3422 
3423             // Ensure that assetProxy exists
3424             require(
3425                 assetProxy != address(0),
3426                 "ASSET_PROXY_DOES_NOT_EXIST"
3427             );
3428             
3429             // We construct calldata for the `assetProxy.transferFrom` ABI.
3430             // The layout of this calldata is in the table below.
3431             // 
3432             // | Area     | Offset | Length  | Contents                                    |
3433             // | -------- |--------|---------|-------------------------------------------- |
3434             // | Header   | 0      | 4       | function selector                           |
3435             // | Params   |        | 4 * 32  | function parameters:                        |
3436             // |          | 4      |         |   1. offset to assetData (*)                |
3437             // |          | 36     |         |   2. from                                   |
3438             // |          | 68     |         |   3. to                                     |
3439             // |          | 100    |         |   4. amount                                 |
3440             // | Data     |        |         | assetData:                                  |
3441             // |          | 132    | 32      | assetData Length                            |
3442             // |          | 164    | **      | assetData Contents                          |
3443 
3444             assembly {
3445                 /////// Setup State ///////
3446                 // `cdStart` is the start of the calldata for `assetProxy.transferFrom` (equal to free memory ptr).
3447                 let cdStart := mload(64)
3448                 // `dataAreaLength` is the total number of words needed to store `assetData`
3449                 //  As-per the ABI spec, this value is padded up to the nearest multiple of 32,
3450                 //  and includes 32-bytes for length.
3451                 let dataAreaLength := and(add(mload(assetData), 63), 0xFFFFFFFFFFFE0)
3452                 // `cdEnd` is the end of the calldata for `assetProxy.transferFrom`.
3453                 let cdEnd := add(cdStart, add(132, dataAreaLength))
3454 
3455                 
3456                 /////// Setup Header Area ///////
3457                 // This area holds the 4-byte `transferFromSelector`.
3458                 // bytes4(keccak256("transferFrom(bytes,address,address,uint256)")) = 0xa85e59e4
3459                 mstore(cdStart, 0xa85e59e400000000000000000000000000000000000000000000000000000000)
3460                 
3461                 /////// Setup Params Area ///////
3462                 // Each parameter is padded to 32-bytes. The entire Params Area is 128 bytes.
3463                 // Notes:
3464                 //   1. The offset to `assetData` is the length of the Params Area (128 bytes).
3465                 //   2. A 20-byte mask is applied to addresses to zero-out the unused bytes.
3466                 mstore(add(cdStart, 4), 128)
3467                 mstore(add(cdStart, 36), and(from, 0xffffffffffffffffffffffffffffffffffffffff))
3468                 mstore(add(cdStart, 68), and(to, 0xffffffffffffffffffffffffffffffffffffffff))
3469                 mstore(add(cdStart, 100), amount)
3470                 
3471                 /////// Setup Data Area ///////
3472                 // This area holds `assetData`.
3473                 let dataArea := add(cdStart, 132)
3474                 // solhint-disable-next-line no-empty-blocks
3475                 for {} lt(dataArea, cdEnd) {} {
3476                     mstore(dataArea, mload(assetData))
3477                     dataArea := add(dataArea, 32)
3478                     assetData := add(assetData, 32)
3479                 }
3480 
3481                 /////// Call `assetProxy.transferFrom` using the constructed calldata ///////
3482                 let success := call(
3483                     gas,                    // forward all gas
3484                     assetProxy,             // call address of asset proxy
3485                     0,                      // don't send any ETH
3486                     cdStart,                // pointer to start of input
3487                     sub(cdEnd, cdStart),    // length of input  
3488                     cdStart,                // write output over input
3489                     512                     // reserve 512 bytes for output
3490                 )
3491                 if iszero(success) {
3492                     revert(cdStart, returndatasize())
3493                 }
3494             }
3495         }
3496     }
3497 }
3498 
3499 contract MixinMatchOrders is
3500     ReentrancyGuard,
3501     LibConstants,
3502     LibMath,
3503     MAssetProxyDispatcher,
3504     MExchangeCore,
3505     MMatchOrders,
3506     MTransactions
3507 {
3508     /// @dev Match two complementary orders that have a profitable spread.
3509     ///      Each order is filled at their respective price point. However, the calculations are
3510     ///      carried out as though the orders are both being filled at the right order's price point.
3511     ///      The profit made by the left order goes to the taker (who matched the two orders).
3512     /// @param leftOrder First order to match.
3513     /// @param rightOrder Second order to match.
3514     /// @param leftSignature Proof that order was created by the left maker.
3515     /// @param rightSignature Proof that order was created by the right maker.
3516     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
3517     function matchOrders(
3518         LibOrder.Order memory leftOrder,
3519         LibOrder.Order memory rightOrder,
3520         bytes memory leftSignature,
3521         bytes memory rightSignature
3522     )
3523         public
3524         nonReentrant
3525         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
3526     {
3527         // We assume that rightOrder.takerAssetData == leftOrder.makerAssetData and rightOrder.makerAssetData == leftOrder.takerAssetData.
3528         // If this assumption isn't true, the match will fail at signature validation.
3529         rightOrder.makerAssetData = leftOrder.takerAssetData;
3530         rightOrder.takerAssetData = leftOrder.makerAssetData;
3531 
3532         // Get left & right order info
3533         LibOrder.OrderInfo memory leftOrderInfo = getOrderInfo(leftOrder);
3534         LibOrder.OrderInfo memory rightOrderInfo = getOrderInfo(rightOrder);
3535 
3536         // Fetch taker address
3537         address takerAddress = getCurrentContextAddress();
3538         
3539         // Either our context is valid or we revert
3540         assertFillableOrder(
3541             leftOrder,
3542             leftOrderInfo,
3543             takerAddress,
3544             leftSignature
3545         );
3546         assertFillableOrder(
3547             rightOrder,
3548             rightOrderInfo,
3549             takerAddress,
3550             rightSignature
3551         );
3552         assertValidMatch(leftOrder, rightOrder);
3553 
3554         // Compute proportional fill amounts
3555         matchedFillResults = calculateMatchedFillResults(
3556             leftOrder,
3557             rightOrder,
3558             leftOrderInfo.orderTakerAssetFilledAmount,
3559             rightOrderInfo.orderTakerAssetFilledAmount
3560         );
3561 
3562         // Validate fill contexts
3563         assertValidFill(
3564             leftOrder,
3565             leftOrderInfo,
3566             matchedFillResults.left.takerAssetFilledAmount,
3567             matchedFillResults.left.takerAssetFilledAmount,
3568             matchedFillResults.left.makerAssetFilledAmount
3569         );
3570         assertValidFill(
3571             rightOrder,
3572             rightOrderInfo,
3573             matchedFillResults.right.takerAssetFilledAmount,
3574             matchedFillResults.right.takerAssetFilledAmount,
3575             matchedFillResults.right.makerAssetFilledAmount
3576         );
3577         
3578         // Update exchange state
3579         updateFilledState(
3580             leftOrder,
3581             takerAddress,
3582             leftOrderInfo.orderHash,
3583             leftOrderInfo.orderTakerAssetFilledAmount,
3584             matchedFillResults.left
3585         );
3586         updateFilledState(
3587             rightOrder,
3588             takerAddress,
3589             rightOrderInfo.orderHash,
3590             rightOrderInfo.orderTakerAssetFilledAmount,
3591             matchedFillResults.right
3592         );
3593 
3594         // Settle matched orders. Succeeds or throws.
3595         settleMatchedOrders(
3596             leftOrder,
3597             rightOrder,
3598             takerAddress,
3599             matchedFillResults
3600         );
3601 
3602         return matchedFillResults;
3603     }
3604 
3605     /// @dev Validates context for matchOrders. Succeeds or throws.
3606     /// @param leftOrder First order to match.
3607     /// @param rightOrder Second order to match.
3608     function assertValidMatch(
3609         LibOrder.Order memory leftOrder,
3610         LibOrder.Order memory rightOrder
3611     )
3612         internal
3613         pure
3614     {
3615         // Make sure there is a profitable spread.
3616         // There is a profitable spread iff the cost per unit bought (OrderA.MakerAmount/OrderA.TakerAmount) for each order is greater
3617         // than the profit per unit sold of the matched order (OrderB.TakerAmount/OrderB.MakerAmount).
3618         // This is satisfied by the equations below:
3619         // <leftOrder.makerAssetAmount> / <leftOrder.takerAssetAmount> >= <rightOrder.takerAssetAmount> / <rightOrder.makerAssetAmount>
3620         // AND
3621         // <rightOrder.makerAssetAmount> / <rightOrder.takerAssetAmount> >= <leftOrder.takerAssetAmount> / <leftOrder.makerAssetAmount>
3622         // These equations can be combined to get the following:
3623         require(
3624             safeMul(leftOrder.makerAssetAmount, rightOrder.makerAssetAmount) >=
3625             safeMul(leftOrder.takerAssetAmount, rightOrder.takerAssetAmount),
3626             "NEGATIVE_SPREAD_REQUIRED"
3627         );
3628     }
3629 
3630     /// @dev Calculates fill amounts for the matched orders.
3631     ///      Each order is filled at their respective price point. However, the calculations are
3632     ///      carried out as though the orders are both being filled at the right order's price point.
3633     ///      The profit made by the leftOrder order goes to the taker (who matched the two orders).
3634     /// @param leftOrder First order to match.
3635     /// @param rightOrder Second order to match.
3636     /// @param leftOrderTakerAssetFilledAmount Amount of left order already filled.
3637     /// @param rightOrderTakerAssetFilledAmount Amount of right order already filled.
3638     /// @param matchedFillResults Amounts to fill and fees to pay by maker and taker of matched orders.
3639     function calculateMatchedFillResults(
3640         LibOrder.Order memory leftOrder,
3641         LibOrder.Order memory rightOrder,
3642         uint256 leftOrderTakerAssetFilledAmount,
3643         uint256 rightOrderTakerAssetFilledAmount
3644     )
3645         internal
3646         pure
3647         returns (LibFillResults.MatchedFillResults memory matchedFillResults)
3648     {
3649         // Derive maker asset amounts for left & right orders, given store taker assert amounts
3650         uint256 leftTakerAssetAmountRemaining = safeSub(leftOrder.takerAssetAmount, leftOrderTakerAssetFilledAmount);
3651         uint256 leftMakerAssetAmountRemaining = safeGetPartialAmountFloor(
3652             leftOrder.makerAssetAmount,
3653             leftOrder.takerAssetAmount,
3654             leftTakerAssetAmountRemaining
3655         );
3656         uint256 rightTakerAssetAmountRemaining = safeSub(rightOrder.takerAssetAmount, rightOrderTakerAssetFilledAmount);
3657         uint256 rightMakerAssetAmountRemaining = safeGetPartialAmountFloor(
3658             rightOrder.makerAssetAmount,
3659             rightOrder.takerAssetAmount,
3660             rightTakerAssetAmountRemaining
3661         );
3662 
3663         // Calculate fill results for maker and taker assets: at least one order will be fully filled.
3664         // The maximum amount the left maker can buy is `leftTakerAssetAmountRemaining`
3665         // The maximum amount the right maker can sell is `rightMakerAssetAmountRemaining`
3666         // We have two distinct cases for calculating the fill results:
3667         // Case 1.
3668         //   If the left maker can buy more than the right maker can sell, then only the right order is fully filled.
3669         //   If the left maker can buy exactly what the right maker can sell, then both orders are fully filled.
3670         // Case 2.
3671         //   If the left maker cannot buy more than the right maker can sell, then only the left order is fully filled.
3672         if (leftTakerAssetAmountRemaining >= rightMakerAssetAmountRemaining) {
3673             // Case 1: Right order is fully filled
3674             matchedFillResults.right.makerAssetFilledAmount = rightMakerAssetAmountRemaining;
3675             matchedFillResults.right.takerAssetFilledAmount = rightTakerAssetAmountRemaining;
3676             matchedFillResults.left.takerAssetFilledAmount = matchedFillResults.right.makerAssetFilledAmount;
3677             // Round down to ensure the maker's exchange rate does not exceed the price specified by the order. 
3678             // We favor the maker when the exchange rate must be rounded.
3679             matchedFillResults.left.makerAssetFilledAmount = safeGetPartialAmountFloor(
3680                 leftOrder.makerAssetAmount,
3681                 leftOrder.takerAssetAmount,
3682                 matchedFillResults.left.takerAssetFilledAmount
3683             );
3684         } else {
3685             // Case 2: Left order is fully filled
3686             matchedFillResults.left.makerAssetFilledAmount = leftMakerAssetAmountRemaining;
3687             matchedFillResults.left.takerAssetFilledAmount = leftTakerAssetAmountRemaining;
3688             matchedFillResults.right.makerAssetFilledAmount = matchedFillResults.left.takerAssetFilledAmount;
3689             // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.
3690             // We favor the maker when the exchange rate must be rounded.
3691             matchedFillResults.right.takerAssetFilledAmount = safeGetPartialAmountCeil(
3692                 rightOrder.takerAssetAmount,
3693                 rightOrder.makerAssetAmount,
3694                 matchedFillResults.right.makerAssetFilledAmount
3695             );
3696         }
3697 
3698         // Calculate amount given to taker
3699         matchedFillResults.leftMakerAssetSpreadAmount = safeSub(
3700             matchedFillResults.left.makerAssetFilledAmount,
3701             matchedFillResults.right.takerAssetFilledAmount
3702         );
3703 
3704         // Compute fees for left order
3705         matchedFillResults.left.makerFeePaid = safeGetPartialAmountFloor(
3706             matchedFillResults.left.makerAssetFilledAmount,
3707             leftOrder.makerAssetAmount,
3708             leftOrder.makerFee
3709         );
3710         matchedFillResults.left.takerFeePaid = safeGetPartialAmountFloor(
3711             matchedFillResults.left.takerAssetFilledAmount,
3712             leftOrder.takerAssetAmount,
3713             leftOrder.takerFee
3714         );
3715 
3716         // Compute fees for right order
3717         matchedFillResults.right.makerFeePaid = safeGetPartialAmountFloor(
3718             matchedFillResults.right.makerAssetFilledAmount,
3719             rightOrder.makerAssetAmount,
3720             rightOrder.makerFee
3721         );
3722         matchedFillResults.right.takerFeePaid = safeGetPartialAmountFloor(
3723             matchedFillResults.right.takerAssetFilledAmount,
3724             rightOrder.takerAssetAmount,
3725             rightOrder.takerFee
3726         );
3727 
3728         // Return fill results
3729         return matchedFillResults;
3730     }
3731 
3732     /// @dev Settles matched order by transferring appropriate funds between order makers, taker, and fee recipient.
3733     /// @param leftOrder First matched order.
3734     /// @param rightOrder Second matched order.
3735     /// @param takerAddress Address that matched the orders. The taker receives the spread between orders as profit.
3736     /// @param matchedFillResults Struct holding amounts to transfer between makers, taker, and fee recipients.
3737     function settleMatchedOrders(
3738         LibOrder.Order memory leftOrder,
3739         LibOrder.Order memory rightOrder,
3740         address takerAddress,
3741         LibFillResults.MatchedFillResults memory matchedFillResults
3742     )
3743         private
3744     {
3745         bytes memory zrxAssetData = ZRX_ASSET_DATA;
3746         // Order makers and taker
3747         dispatchTransferFrom(
3748             leftOrder.makerAssetData,
3749             leftOrder.makerAddress,
3750             rightOrder.makerAddress,
3751             matchedFillResults.right.takerAssetFilledAmount
3752         );
3753         dispatchTransferFrom(
3754             rightOrder.makerAssetData,
3755             rightOrder.makerAddress,
3756             leftOrder.makerAddress,
3757             matchedFillResults.left.takerAssetFilledAmount
3758         );
3759         dispatchTransferFrom(
3760             leftOrder.makerAssetData,
3761             leftOrder.makerAddress,
3762             takerAddress,
3763             matchedFillResults.leftMakerAssetSpreadAmount
3764         );
3765 
3766         // Maker fees
3767         dispatchTransferFrom(
3768             zrxAssetData,
3769             leftOrder.makerAddress,
3770             leftOrder.feeRecipientAddress,
3771             matchedFillResults.left.makerFeePaid
3772         );
3773         dispatchTransferFrom(
3774             zrxAssetData,
3775             rightOrder.makerAddress,
3776             rightOrder.feeRecipientAddress,
3777             matchedFillResults.right.makerFeePaid
3778         );
3779 
3780         // Taker fees
3781         if (leftOrder.feeRecipientAddress == rightOrder.feeRecipientAddress) {
3782             dispatchTransferFrom(
3783                 zrxAssetData,
3784                 takerAddress,
3785                 leftOrder.feeRecipientAddress,
3786                 safeAdd(
3787                     matchedFillResults.left.takerFeePaid,
3788                     matchedFillResults.right.takerFeePaid
3789                 )
3790             );
3791         } else {
3792             dispatchTransferFrom(
3793                 zrxAssetData,
3794                 takerAddress,
3795                 leftOrder.feeRecipientAddress,
3796                 matchedFillResults.left.takerFeePaid
3797             );
3798             dispatchTransferFrom(
3799                 zrxAssetData,
3800                 takerAddress,
3801                 rightOrder.feeRecipientAddress,
3802                 matchedFillResults.right.takerFeePaid
3803             );
3804         }
3805     }
3806 }
3807 
3808 // solhint-disable no-empty-blocks
3809 contract Exchange is
3810     MixinExchangeCore,
3811     MixinMatchOrders,
3812     MixinSignatureValidator,
3813     MixinTransactions,
3814     MixinAssetProxyDispatcher,
3815     MixinWrapperFunctions
3816 {
3817     string constant public VERSION = "2.0.0";
3818 
3819     // Mixins are instantiated in the order they are inherited
3820     constructor ()
3821         public
3822         MixinExchangeCore()
3823         MixinMatchOrders()
3824         MixinSignatureValidator()
3825         MixinTransactions()
3826         MixinAssetProxyDispatcher()
3827         MixinWrapperFunctions()
3828     {}
3829 }