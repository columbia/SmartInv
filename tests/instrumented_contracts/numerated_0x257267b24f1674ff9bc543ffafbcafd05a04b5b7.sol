1 pragma solidity ^0.4.24;
2 
3 // File: @0x/contracts-utils/contracts/utils/SafeMath/SafeMath.sol
4 
5 contract SafeMath {
6 
7     function safeMul(uint256 a, uint256 b)
8         internal
9         pure
10         returns (uint256)
11     {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         require(
17             c / a == b,
18             "UINT256_OVERFLOW"
19         );
20         return c;
21     }
22 
23     function safeDiv(uint256 a, uint256 b)
24         internal
25         pure
26         returns (uint256)
27     {
28         uint256 c = a / b;
29         return c;
30     }
31 
32     function safeSub(uint256 a, uint256 b)
33         internal
34         pure
35         returns (uint256)
36     {
37         require(
38             b <= a,
39             "UINT256_UNDERFLOW"
40         );
41         return a - b;
42     }
43 
44     function safeAdd(uint256 a, uint256 b)
45         internal
46         pure
47         returns (uint256)
48     {
49         uint256 c = a + b;
50         require(
51             c >= a,
52             "UINT256_OVERFLOW"
53         );
54         return c;
55     }
56 
57     function max64(uint64 a, uint64 b)
58         internal
59         pure
60         returns (uint256)
61     {
62         return a >= b ? a : b;
63     }
64 
65     function min64(uint64 a, uint64 b)
66         internal
67         pure
68         returns (uint256)
69     {
70         return a < b ? a : b;
71     }
72 
73     function max256(uint256 a, uint256 b)
74         internal
75         pure
76         returns (uint256)
77     {
78         return a >= b ? a : b;
79     }
80 
81     function min256(uint256 a, uint256 b)
82         internal
83         pure
84         returns (uint256)
85     {
86         return a < b ? a : b;
87     }
88 }
89 
90 // File: @0x/contracts-libs/contracts/libs/LibMath.sol
91 
92 /*
93 
94   Copyright 2018 ZeroEx Intl.
95 
96   Licensed under the Apache License, Version 2.0 (the "License");
97   you may not use this file except in compliance with the License.
98   You may obtain a copy of the License at
99 
100     http://www.apache.org/licenses/LICENSE-2.0
101 
102   Unless required by applicable law or agreed to in writing, software
103   distributed under the License is distributed on an "AS IS" BASIS,
104   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
105   See the License for the specific language governing permissions and
106   limitations under the License.
107 
108 */
109 
110 pragma solidity ^0.4.24;
111 
112 
113 
114 contract LibMath is
115     SafeMath
116 {
117     /// @dev Calculates partial value given a numerator and denominator rounded down.
118     ///      Reverts if rounding error is >= 0.1%
119     /// @param numerator Numerator.
120     /// @param denominator Denominator.
121     /// @param target Value to calculate partial of.
122     /// @return Partial value of target rounded down.
123     function safeGetPartialAmountFloor(
124         uint256 numerator,
125         uint256 denominator,
126         uint256 target
127     )
128         internal
129         pure
130         returns (uint256 partialAmount)
131     {
132         require(
133             denominator > 0,
134             "DIVISION_BY_ZERO"
135         );
136 
137         require(
138             !isRoundingErrorFloor(
139                 numerator,
140                 denominator,
141                 target
142             ),
143             "ROUNDING_ERROR"
144         );
145         
146         partialAmount = safeDiv(
147             safeMul(numerator, target),
148             denominator
149         );
150         return partialAmount;
151     }
152 
153     /// @dev Calculates partial value given a numerator and denominator rounded down.
154     ///      Reverts if rounding error is >= 0.1%
155     /// @param numerator Numerator.
156     /// @param denominator Denominator.
157     /// @param target Value to calculate partial of.
158     /// @return Partial value of target rounded up.
159     function safeGetPartialAmountCeil(
160         uint256 numerator,
161         uint256 denominator,
162         uint256 target
163     )
164         internal
165         pure
166         returns (uint256 partialAmount)
167     {
168         require(
169             denominator > 0,
170             "DIVISION_BY_ZERO"
171         );
172 
173         require(
174             !isRoundingErrorCeil(
175                 numerator,
176                 denominator,
177                 target
178             ),
179             "ROUNDING_ERROR"
180         );
181         
182         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
183         //       ceil(a / b) = floor((a + b - 1) / b)
184         // To implement `ceil(a / b)` using safeDiv.
185         partialAmount = safeDiv(
186             safeAdd(
187                 safeMul(numerator, target),
188                 safeSub(denominator, 1)
189             ),
190             denominator
191         );
192         return partialAmount;
193     }
194 
195     /// @dev Calculates partial value given a numerator and denominator rounded down.
196     /// @param numerator Numerator.
197     /// @param denominator Denominator.
198     /// @param target Value to calculate partial of.
199     /// @return Partial value of target rounded down.
200     function getPartialAmountFloor(
201         uint256 numerator,
202         uint256 denominator,
203         uint256 target
204     )
205         internal
206         pure
207         returns (uint256 partialAmount)
208     {
209         require(
210             denominator > 0,
211             "DIVISION_BY_ZERO"
212         );
213 
214         partialAmount = safeDiv(
215             safeMul(numerator, target),
216             denominator
217         );
218         return partialAmount;
219     }
220     
221     /// @dev Calculates partial value given a numerator and denominator rounded down.
222     /// @param numerator Numerator.
223     /// @param denominator Denominator.
224     /// @param target Value to calculate partial of.
225     /// @return Partial value of target rounded up.
226     function getPartialAmountCeil(
227         uint256 numerator,
228         uint256 denominator,
229         uint256 target
230     )
231         internal
232         pure
233         returns (uint256 partialAmount)
234     {
235         require(
236             denominator > 0,
237             "DIVISION_BY_ZERO"
238         );
239 
240         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
241         //       ceil(a / b) = floor((a + b - 1) / b)
242         // To implement `ceil(a / b)` using safeDiv.
243         partialAmount = safeDiv(
244             safeAdd(
245                 safeMul(numerator, target),
246                 safeSub(denominator, 1)
247             ),
248             denominator
249         );
250         return partialAmount;
251     }
252     
253     /// @dev Checks if rounding error >= 0.1% when rounding down.
254     /// @param numerator Numerator.
255     /// @param denominator Denominator.
256     /// @param target Value to multiply with numerator/denominator.
257     /// @return Rounding error is present.
258     function isRoundingErrorFloor(
259         uint256 numerator,
260         uint256 denominator,
261         uint256 target
262     )
263         internal
264         pure
265         returns (bool isError)
266     {
267         require(
268             denominator > 0,
269             "DIVISION_BY_ZERO"
270         );
271         
272         // The absolute rounding error is the difference between the rounded
273         // value and the ideal value. The relative rounding error is the
274         // absolute rounding error divided by the absolute value of the
275         // ideal value. This is undefined when the ideal value is zero.
276         //
277         // The ideal value is `numerator * target / denominator`.
278         // Let's call `numerator * target % denominator` the remainder.
279         // The absolute error is `remainder / denominator`.
280         //
281         // When the ideal value is zero, we require the absolute error to
282         // be zero. Fortunately, this is always the case. The ideal value is
283         // zero iff `numerator == 0` and/or `target == 0`. In this case the
284         // remainder and absolute error are also zero. 
285         if (target == 0 || numerator == 0) {
286             return false;
287         }
288         
289         // Otherwise, we want the relative rounding error to be strictly
290         // less than 0.1%.
291         // The relative error is `remainder / (numerator * target)`.
292         // We want the relative error less than 1 / 1000:
293         //        remainder / (numerator * denominator)  <  1 / 1000
294         // or equivalently:
295         //        1000 * remainder  <  numerator * target
296         // so we have a rounding error iff:
297         //        1000 * remainder  >=  numerator * target
298         uint256 remainder = mulmod(
299             target,
300             numerator,
301             denominator
302         );
303         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
304         return isError;
305     }
306     
307     /// @dev Checks if rounding error >= 0.1% when rounding up.
308     /// @param numerator Numerator.
309     /// @param denominator Denominator.
310     /// @param target Value to multiply with numerator/denominator.
311     /// @return Rounding error is present.
312     function isRoundingErrorCeil(
313         uint256 numerator,
314         uint256 denominator,
315         uint256 target
316     )
317         internal
318         pure
319         returns (bool isError)
320     {
321         require(
322             denominator > 0,
323             "DIVISION_BY_ZERO"
324         );
325         
326         // See the comments in `isRoundingError`.
327         if (target == 0 || numerator == 0) {
328             // When either is zero, the ideal value and rounded value are zero
329             // and there is no rounding error. (Although the relative error
330             // is undefined.)
331             return false;
332         }
333         // Compute remainder as before
334         uint256 remainder = mulmod(
335             target,
336             numerator,
337             denominator
338         );
339         remainder = safeSub(denominator, remainder) % denominator;
340         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
341         return isError;
342     }
343 }
344 
345 // File: @0x/contracts-utils/contracts/utils/LibBytes/LibBytes.sol
346 
347 /*
348 
349   Copyright 2018 ZeroEx Intl.
350 
351   Licensed under the Apache License, Version 2.0 (the "License");
352   you may not use this file except in compliance with the License.
353   You may obtain a copy of the License at
354 
355     http://www.apache.org/licenses/LICENSE-2.0
356 
357   Unless required by applicable law or agreed to in writing, software
358   distributed under the License is distributed on an "AS IS" BASIS,
359   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
360   See the License for the specific language governing permissions and
361   limitations under the License.
362 
363 */
364 
365 pragma solidity ^0.4.24;
366 
367 
368 library LibBytes {
369 
370     using LibBytes for bytes;
371 
372     /// @dev Gets the memory address for a byte array.
373     /// @param input Byte array to lookup.
374     /// @return memoryAddress Memory address of byte array. This
375     ///         points to the header of the byte array which contains
376     ///         the length.
377     function rawAddress(bytes memory input)
378         internal
379         pure
380         returns (uint256 memoryAddress)
381     {
382         assembly {
383             memoryAddress := input
384         }
385         return memoryAddress;
386     }
387     
388     /// @dev Gets the memory address for the contents of a byte array.
389     /// @param input Byte array to lookup.
390     /// @return memoryAddress Memory address of the contents of the byte array.
391     function contentAddress(bytes memory input)
392         internal
393         pure
394         returns (uint256 memoryAddress)
395     {
396         assembly {
397             memoryAddress := add(input, 32)
398         }
399         return memoryAddress;
400     }
401 
402     /// @dev Copies `length` bytes from memory location `source` to `dest`.
403     /// @param dest memory address to copy bytes to.
404     /// @param source memory address to copy bytes from.
405     /// @param length number of bytes to copy.
406     function memCopy(
407         uint256 dest,
408         uint256 source,
409         uint256 length
410     )
411         internal
412         pure
413     {
414         if (length < 32) {
415             // Handle a partial word by reading destination and masking
416             // off the bits we are interested in.
417             // This correctly handles overlap, zero lengths and source == dest
418             assembly {
419                 let mask := sub(exp(256, sub(32, length)), 1)
420                 let s := and(mload(source), not(mask))
421                 let d := and(mload(dest), mask)
422                 mstore(dest, or(s, d))
423             }
424         } else {
425             // Skip the O(length) loop when source == dest.
426             if (source == dest) {
427                 return;
428             }
429 
430             // For large copies we copy whole words at a time. The final
431             // word is aligned to the end of the range (instead of after the
432             // previous) to handle partial words. So a copy will look like this:
433             //
434             //  ####
435             //      ####
436             //          ####
437             //            ####
438             //
439             // We handle overlap in the source and destination range by
440             // changing the copying direction. This prevents us from
441             // overwriting parts of source that we still need to copy.
442             //
443             // This correctly handles source == dest
444             //
445             if (source > dest) {
446                 assembly {
447                     // We subtract 32 from `sEnd` and `dEnd` because it
448                     // is easier to compare with in the loop, and these
449                     // are also the addresses we need for copying the
450                     // last bytes.
451                     length := sub(length, 32)
452                     let sEnd := add(source, length)
453                     let dEnd := add(dest, length)
454 
455                     // Remember the last 32 bytes of source
456                     // This needs to be done here and not after the loop
457                     // because we may have overwritten the last bytes in
458                     // source already due to overlap.
459                     let last := mload(sEnd)
460 
461                     // Copy whole words front to back
462                     // Note: the first check is always true,
463                     // this could have been a do-while loop.
464                     // solhint-disable-next-line no-empty-blocks
465                     for {} lt(source, sEnd) {} {
466                         mstore(dest, mload(source))
467                         source := add(source, 32)
468                         dest := add(dest, 32)
469                     }
470                     
471                     // Write the last 32 bytes
472                     mstore(dEnd, last)
473                 }
474             } else {
475                 assembly {
476                     // We subtract 32 from `sEnd` and `dEnd` because those
477                     // are the starting points when copying a word at the end.
478                     length := sub(length, 32)
479                     let sEnd := add(source, length)
480                     let dEnd := add(dest, length)
481 
482                     // Remember the first 32 bytes of source
483                     // This needs to be done here and not after the loop
484                     // because we may have overwritten the first bytes in
485                     // source already due to overlap.
486                     let first := mload(source)
487 
488                     // Copy whole words back to front
489                     // We use a signed comparisson here to allow dEnd to become
490                     // negative (happens when source and dest < 32). Valid
491                     // addresses in local memory will never be larger than
492                     // 2**255, so they can be safely re-interpreted as signed.
493                     // Note: the first check is always true,
494                     // this could have been a do-while loop.
495                     // solhint-disable-next-line no-empty-blocks
496                     for {} slt(dest, dEnd) {} {
497                         mstore(dEnd, mload(sEnd))
498                         sEnd := sub(sEnd, 32)
499                         dEnd := sub(dEnd, 32)
500                     }
501                     
502                     // Write the first 32 bytes
503                     mstore(dest, first)
504                 }
505             }
506         }
507     }
508 
509     /// @dev Returns a slices from a byte array.
510     /// @param b The byte array to take a slice from.
511     /// @param from The starting index for the slice (inclusive).
512     /// @param to The final index for the slice (exclusive).
513     /// @return result The slice containing bytes at indices [from, to)
514     function slice(
515         bytes memory b,
516         uint256 from,
517         uint256 to
518     )
519         internal
520         pure
521         returns (bytes memory result)
522     {
523         require(
524             from <= to,
525             "FROM_LESS_THAN_TO_REQUIRED"
526         );
527         require(
528             to < b.length,
529             "TO_LESS_THAN_LENGTH_REQUIRED"
530         );
531         
532         // Create a new bytes structure and copy contents
533         result = new bytes(to - from);
534         memCopy(
535             result.contentAddress(),
536             b.contentAddress() + from,
537             result.length
538         );
539         return result;
540     }
541     
542     /// @dev Returns a slice from a byte array without preserving the input.
543     /// @param b The byte array to take a slice from. Will be destroyed in the process.
544     /// @param from The starting index for the slice (inclusive).
545     /// @param to The final index for the slice (exclusive).
546     /// @return result The slice containing bytes at indices [from, to)
547     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
548     function sliceDestructive(
549         bytes memory b,
550         uint256 from,
551         uint256 to
552     )
553         internal
554         pure
555         returns (bytes memory result)
556     {
557         require(
558             from <= to,
559             "FROM_LESS_THAN_TO_REQUIRED"
560         );
561         require(
562             to < b.length,
563             "TO_LESS_THAN_LENGTH_REQUIRED"
564         );
565         
566         // Create a new bytes structure around [from, to) in-place.
567         assembly {
568             result := add(b, from)
569             mstore(result, sub(to, from))
570         }
571         return result;
572     }
573 
574     /// @dev Pops the last byte off of a byte array by modifying its length.
575     /// @param b Byte array that will be modified.
576     /// @return The byte that was popped off.
577     function popLastByte(bytes memory b)
578         internal
579         pure
580         returns (bytes1 result)
581     {
582         require(
583             b.length > 0,
584             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
585         );
586 
587         // Store last byte.
588         result = b[b.length - 1];
589 
590         assembly {
591             // Decrement length of byte array.
592             let newLen := sub(mload(b), 1)
593             mstore(b, newLen)
594         }
595         return result;
596     }
597 
598     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
599     /// @param b Byte array that will be modified.
600     /// @return The 20 byte address that was popped off.
601     function popLast20Bytes(bytes memory b)
602         internal
603         pure
604         returns (address result)
605     {
606         require(
607             b.length >= 20,
608             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
609         );
610 
611         // Store last 20 bytes.
612         result = readAddress(b, b.length - 20);
613 
614         assembly {
615             // Subtract 20 from byte array length.
616             let newLen := sub(mload(b), 20)
617             mstore(b, newLen)
618         }
619         return result;
620     }
621 
622     /// @dev Tests equality of two byte arrays.
623     /// @param lhs First byte array to compare.
624     /// @param rhs Second byte array to compare.
625     /// @return True if arrays are the same. False otherwise.
626     function equals(
627         bytes memory lhs,
628         bytes memory rhs
629     )
630         internal
631         pure
632         returns (bool equal)
633     {
634         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
635         // We early exit on unequal lengths, but keccak would also correctly
636         // handle this.
637         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
638     }
639 
640     /// @dev Reads an address from a position in a byte array.
641     /// @param b Byte array containing an address.
642     /// @param index Index in byte array of address.
643     /// @return address from byte array.
644     function readAddress(
645         bytes memory b,
646         uint256 index
647     )
648         internal
649         pure
650         returns (address result)
651     {
652         require(
653             b.length >= index + 20,  // 20 is length of address
654             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
655         );
656 
657         // Add offset to index:
658         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
659         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
660         index += 20;
661 
662         // Read address from array memory
663         assembly {
664             // 1. Add index to address of bytes array
665             // 2. Load 32-byte word from memory
666             // 3. Apply 20-byte mask to obtain address
667             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
668         }
669         return result;
670     }
671 
672     /// @dev Writes an address into a specific position in a byte array.
673     /// @param b Byte array to insert address into.
674     /// @param index Index in byte array of address.
675     /// @param input Address to put into byte array.
676     function writeAddress(
677         bytes memory b,
678         uint256 index,
679         address input
680     )
681         internal
682         pure
683     {
684         require(
685             b.length >= index + 20,  // 20 is length of address
686             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
687         );
688 
689         // Add offset to index:
690         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
691         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
692         index += 20;
693 
694         // Store address into array memory
695         assembly {
696             // The address occupies 20 bytes and mstore stores 32 bytes.
697             // First fetch the 32-byte word where we'll be storing the address, then
698             // apply a mask so we have only the bytes in the word that the address will not occupy.
699             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
700 
701             // 1. Add index to address of bytes array
702             // 2. Load 32-byte word from memory
703             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
704             let neighbors := and(
705                 mload(add(b, index)),
706                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
707             )
708             
709             // Make sure input address is clean.
710             // (Solidity does not guarantee this)
711             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
712 
713             // Store the neighbors and address into memory
714             mstore(add(b, index), xor(input, neighbors))
715         }
716     }
717 
718     /// @dev Reads a bytes32 value from a position in a byte array.
719     /// @param b Byte array containing a bytes32 value.
720     /// @param index Index in byte array of bytes32 value.
721     /// @return bytes32 value from byte array.
722     function readBytes32(
723         bytes memory b,
724         uint256 index
725     )
726         internal
727         pure
728         returns (bytes32 result)
729     {
730         require(
731             b.length >= index + 32,
732             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
733         );
734 
735         // Arrays are prefixed by a 256 bit length parameter
736         index += 32;
737 
738         // Read the bytes32 from array memory
739         assembly {
740             result := mload(add(b, index))
741         }
742         return result;
743     }
744 
745     /// @dev Writes a bytes32 into a specific position in a byte array.
746     /// @param b Byte array to insert <input> into.
747     /// @param index Index in byte array of <input>.
748     /// @param input bytes32 to put into byte array.
749     function writeBytes32(
750         bytes memory b,
751         uint256 index,
752         bytes32 input
753     )
754         internal
755         pure
756     {
757         require(
758             b.length >= index + 32,
759             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
760         );
761 
762         // Arrays are prefixed by a 256 bit length parameter
763         index += 32;
764 
765         // Read the bytes32 from array memory
766         assembly {
767             mstore(add(b, index), input)
768         }
769     }
770 
771     /// @dev Reads a uint256 value from a position in a byte array.
772     /// @param b Byte array containing a uint256 value.
773     /// @param index Index in byte array of uint256 value.
774     /// @return uint256 value from byte array.
775     function readUint256(
776         bytes memory b,
777         uint256 index
778     )
779         internal
780         pure
781         returns (uint256 result)
782     {
783         result = uint256(readBytes32(b, index));
784         return result;
785     }
786 
787     /// @dev Writes a uint256 into a specific position in a byte array.
788     /// @param b Byte array to insert <input> into.
789     /// @param index Index in byte array of <input>.
790     /// @param input uint256 to put into byte array.
791     function writeUint256(
792         bytes memory b,
793         uint256 index,
794         uint256 input
795     )
796         internal
797         pure
798     {
799         writeBytes32(b, index, bytes32(input));
800     }
801 
802     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
803     /// @param b Byte array containing a bytes4 value.
804     /// @param index Index in byte array of bytes4 value.
805     /// @return bytes4 value from byte array.
806     function readBytes4(
807         bytes memory b,
808         uint256 index
809     )
810         internal
811         pure
812         returns (bytes4 result)
813     {
814         require(
815             b.length >= index + 4,
816             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
817         );
818 
819         // Arrays are prefixed by a 32 byte length field
820         index += 32;
821 
822         // Read the bytes4 from array memory
823         assembly {
824             result := mload(add(b, index))
825             // Solidity does not require us to clean the trailing bytes.
826             // We do it anyway
827             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
828         }
829         return result;
830     }
831 
832     /// @dev Reads nested bytes from a specific position.
833     /// @dev NOTE: the returned value overlaps with the input value.
834     ///            Both should be treated as immutable.
835     /// @param b Byte array containing nested bytes.
836     /// @param index Index of nested bytes.
837     /// @return result Nested bytes.
838     function readBytesWithLength(
839         bytes memory b,
840         uint256 index
841     )
842         internal
843         pure
844         returns (bytes memory result)
845     {
846         // Read length of nested bytes
847         uint256 nestedBytesLength = readUint256(b, index);
848         index += 32;
849 
850         // Assert length of <b> is valid, given
851         // length of nested bytes
852         require(
853             b.length >= index + nestedBytesLength,
854             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
855         );
856         
857         // Return a pointer to the byte array as it exists inside `b`
858         assembly {
859             result := add(b, index)
860         }
861         return result;
862     }
863 
864     /// @dev Inserts bytes at a specific position in a byte array.
865     /// @param b Byte array to insert <input> into.
866     /// @param index Index in byte array of <input>.
867     /// @param input bytes to insert.
868     function writeBytesWithLength(
869         bytes memory b,
870         uint256 index,
871         bytes memory input
872     )
873         internal
874         pure
875     {
876         // Assert length of <b> is valid, given
877         // length of input
878         require(
879             b.length >= index + 32 + input.length,  // 32 bytes to store length
880             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
881         );
882 
883         // Copy <input> into <b>
884         memCopy(
885             b.contentAddress() + index,
886             input.rawAddress(), // includes length of <input>
887             input.length + 32   // +32 bytes to store <input> length
888         );
889     }
890 
891     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
892     /// @param dest Byte array that will be overwritten with source bytes.
893     /// @param source Byte array to copy onto dest bytes.
894     function deepCopyBytes(
895         bytes memory dest,
896         bytes memory source
897     )
898         internal
899         pure
900     {
901         uint256 sourceLen = source.length;
902         // Dest length must be >= source length, or some bytes would not be copied.
903         require(
904             dest.length >= sourceLen,
905             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
906         );
907         memCopy(
908             dest.contentAddress(),
909             source.contentAddress(),
910             sourceLen
911         );
912     }
913 }
914 
915 // File: @0x/contracts-libs/contracts/libs/LibEIP712.sol
916 
917 /*
918 
919   Copyright 2018 ZeroEx Intl.
920 
921   Licensed under the Apache License, Version 2.0 (the "License");
922   you may not use this file except in compliance with the License.
923   You may obtain a copy of the License at
924 
925     http://www.apache.org/licenses/LICENSE-2.0
926 
927   Unless required by applicable law or agreed to in writing, software
928   distributed under the License is distributed on an "AS IS" BASIS,
929   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
930   See the License for the specific language governing permissions and
931   limitations under the License.
932 
933 */
934 
935 pragma solidity ^0.4.24;
936 
937 
938 contract LibEIP712 {
939 
940     // EIP191 header for EIP712 prefix
941     string constant internal EIP191_HEADER = "\x19\x01";
942 
943     // EIP712 Domain Name value
944     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
945 
946     // EIP712 Domain Version value
947     string constant internal EIP712_DOMAIN_VERSION = "2";
948 
949     // Hash of the EIP712 Domain Separator Schema
950     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
951         "EIP712Domain(",
952         "string name,",
953         "string version,",
954         "address verifyingContract",
955         ")"
956     ));
957 
958     // Hash of the EIP712 Domain Separator data
959     // solhint-disable-next-line var-name-mixedcase
960     bytes32 public EIP712_DOMAIN_HASH;
961 
962     constructor ()
963         public
964     {
965         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
966             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
967             keccak256(bytes(EIP712_DOMAIN_NAME)),
968             keccak256(bytes(EIP712_DOMAIN_VERSION)),
969             bytes32(address(this))
970         ));
971     }
972 
973     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
974     /// @param hashStruct The EIP712 hash struct.
975     /// @return EIP712 hash applied to this EIP712 Domain.
976     function hashEIP712Message(bytes32 hashStruct)
977         internal
978         view
979         returns (bytes32 result)
980     {
981         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
982 
983         // Assembly for more efficient computing:
984         // keccak256(abi.encodePacked(
985         //     EIP191_HEADER,
986         //     EIP712_DOMAIN_HASH,
987         //     hashStruct    
988         // ));
989 
990         assembly {
991             // Load free memory pointer
992             let memPtr := mload(64)
993 
994             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
995             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
996             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
997 
998             // Compute hash
999             result := keccak256(memPtr, 66)
1000         }
1001         return result;
1002     }
1003 }
1004 
1005 // File: @0x/contracts-libs/contracts/libs/LibOrder.sol
1006 
1007 /*
1008 
1009   Copyright 2018 ZeroEx Intl.
1010 
1011   Licensed under the Apache License, Version 2.0 (the "License");
1012   you may not use this file except in compliance with the License.
1013   You may obtain a copy of the License at
1014 
1015     http://www.apache.org/licenses/LICENSE-2.0
1016 
1017   Unless required by applicable law or agreed to in writing, software
1018   distributed under the License is distributed on an "AS IS" BASIS,
1019   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1020   See the License for the specific language governing permissions and
1021   limitations under the License.
1022 
1023 */
1024 
1025 pragma solidity ^0.4.24;
1026 
1027 
1028 
1029 contract LibOrder is
1030     LibEIP712
1031 {
1032     // Hash for the EIP712 Order Schema
1033     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
1034         "Order(",
1035         "address makerAddress,",
1036         "address takerAddress,",
1037         "address feeRecipientAddress,",
1038         "address senderAddress,",
1039         "uint256 makerAssetAmount,",
1040         "uint256 takerAssetAmount,",
1041         "uint256 makerFee,",
1042         "uint256 takerFee,",
1043         "uint256 expirationTimeSeconds,",
1044         "uint256 salt,",
1045         "bytes makerAssetData,",
1046         "bytes takerAssetData",
1047         ")"
1048     ));
1049 
1050     // A valid order remains fillable until it is expired, fully filled, or cancelled.
1051     // An order's state is unaffected by external factors, like account balances.
1052     enum OrderStatus {
1053         INVALID,                     // Default value
1054         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
1055         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
1056         FILLABLE,                    // Order is fillable
1057         EXPIRED,                     // Order has already expired
1058         FULLY_FILLED,                // Order is fully filled
1059         CANCELLED                    // Order has been cancelled
1060     }
1061 
1062     // solhint-disable max-line-length
1063     struct Order {
1064         address makerAddress;           // Address that created the order.      
1065         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
1066         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
1067         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1068         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
1069         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
1070         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1071         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1072         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
1073         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
1074         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1075         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1076     }
1077     // solhint-enable max-line-length
1078 
1079     struct OrderInfo {
1080         uint8 orderStatus;                    // Status that describes order's validity and fillability.
1081         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
1082         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
1083     }
1084 
1085     /// @dev Calculates Keccak-256 hash of the order.
1086     /// @param order The order structure.
1087     /// @return Keccak-256 EIP712 hash of the order.
1088     function getOrderHash(Order memory order)
1089         internal
1090         view
1091         returns (bytes32 orderHash)
1092     {
1093         orderHash = hashEIP712Message(hashOrder(order));
1094         return orderHash;
1095     }
1096 
1097     /// @dev Calculates EIP712 hash of the order.
1098     /// @param order The order structure.
1099     /// @return EIP712 hash of the order.
1100     function hashOrder(Order memory order)
1101         internal
1102         pure
1103         returns (bytes32 result)
1104     {
1105         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
1106         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
1107         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
1108 
1109         // Assembly for more efficiently computing:
1110         // keccak256(abi.encodePacked(
1111         //     EIP712_ORDER_SCHEMA_HASH,
1112         //     bytes32(order.makerAddress),
1113         //     bytes32(order.takerAddress),
1114         //     bytes32(order.feeRecipientAddress),
1115         //     bytes32(order.senderAddress),
1116         //     order.makerAssetAmount,
1117         //     order.takerAssetAmount,
1118         //     order.makerFee,
1119         //     order.takerFee,
1120         //     order.expirationTimeSeconds,
1121         //     order.salt,
1122         //     keccak256(order.makerAssetData),
1123         //     keccak256(order.takerAssetData)
1124         // ));
1125 
1126         assembly {
1127             // Calculate memory addresses that will be swapped out before hashing
1128             let pos1 := sub(order, 32)
1129             let pos2 := add(order, 320)
1130             let pos3 := add(order, 352)
1131 
1132             // Backup
1133             let temp1 := mload(pos1)
1134             let temp2 := mload(pos2)
1135             let temp3 := mload(pos3)
1136             
1137             // Hash in place
1138             mstore(pos1, schemaHash)
1139             mstore(pos2, makerAssetDataHash)
1140             mstore(pos3, takerAssetDataHash)
1141             result := keccak256(pos1, 416)
1142             
1143             // Restore
1144             mstore(pos1, temp1)
1145             mstore(pos2, temp2)
1146             mstore(pos3, temp3)
1147         }
1148         return result;
1149     }
1150 }
1151 
1152 // File: @0x/contracts-libs/contracts/libs/LibFillResults.sol
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
1172 pragma solidity ^0.4.24;
1173 
1174 
1175 
1176 contract LibFillResults is
1177     SafeMath
1178 {
1179     struct FillResults {
1180         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
1181         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
1182         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
1183         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
1184     }
1185 
1186     struct MatchedFillResults {
1187         FillResults left;                    // Amounts filled and fees paid of left order.
1188         FillResults right;                   // Amounts filled and fees paid of right order.
1189         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
1190     }
1191 
1192     /// @dev Adds properties of both FillResults instances.
1193     ///      Modifies the first FillResults instance specified.
1194     /// @param totalFillResults Fill results instance that will be added onto.
1195     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
1196     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
1197         internal
1198         pure
1199     {
1200         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
1201         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
1202         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
1203         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
1204     }
1205 }
1206 
1207 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IExchangeCore.sol
1208 
1209 /*
1210 
1211   Copyright 2018 ZeroEx Intl.
1212 
1213   Licensed under the Apache License, Version 2.0 (the "License");
1214   you may not use this file except in compliance with the License.
1215   You may obtain a copy of the License at
1216 
1217     http://www.apache.org/licenses/LICENSE-2.0
1218 
1219   Unless required by applicable law or agreed to in writing, software
1220   distributed under the License is distributed on an "AS IS" BASIS,
1221   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1222   See the License for the specific language governing permissions and
1223   limitations under the License.
1224 
1225 */
1226 
1227 pragma solidity ^0.4.24;
1228 pragma experimental ABIEncoderV2;
1229 
1230 
1231 
1232 
1233 contract IExchangeCore {
1234 
1235     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1236     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1237     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1238     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1239         external;
1240 
1241     /// @dev Fills the input order.
1242     /// @param order Order struct containing order specifications.
1243     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1244     /// @param signature Proof that order has been created by maker.
1245     /// @return Amounts filled and fees paid by maker and taker.
1246     function fillOrder(
1247         LibOrder.Order memory order,
1248         uint256 takerAssetFillAmount,
1249         bytes memory signature
1250     )
1251         public
1252         returns (LibFillResults.FillResults memory fillResults);
1253 
1254     /// @dev After calling, the order can not be filled anymore.
1255     /// @param order Order struct containing order specifications.
1256     function cancelOrder(LibOrder.Order memory order)
1257         public;
1258 
1259     /// @dev Gets information about an order: status, hash, and amount filled.
1260     /// @param order Order to gather information on.
1261     /// @return OrderInfo Information about the order and its state.
1262     ///                   See LibOrder.OrderInfo for a complete description.
1263     function getOrderInfo(LibOrder.Order memory order)
1264         public
1265         view
1266         returns (LibOrder.OrderInfo memory orderInfo);
1267 }
1268 
1269 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IMatchOrders.sol
1270 
1271 /*
1272 
1273   Copyright 2018 ZeroEx Intl.
1274 
1275   Licensed under the Apache License, Version 2.0 (the "License");
1276   you may not use this file except in compliance with the License.
1277   You may obtain a copy of the License at
1278 
1279     http://www.apache.org/licenses/LICENSE-2.0
1280 
1281   Unless required by applicable law or agreed to in writing, software
1282   distributed under the License is distributed on an "AS IS" BASIS,
1283   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1284   See the License for the specific language governing permissions and
1285   limitations under the License.
1286 
1287 */
1288 pragma solidity ^0.4.24;
1289 
1290 
1291 
1292 
1293 contract IMatchOrders {
1294 
1295     /// @dev Match two complementary orders that have a profitable spread.
1296     ///      Each order is filled at their respective price point. However, the calculations are
1297     ///      carried out as though the orders are both being filled at the right order's price point.
1298     ///      The profit made by the left order goes to the taker (who matched the two orders).
1299     /// @param leftOrder First order to match.
1300     /// @param rightOrder Second order to match.
1301     /// @param leftSignature Proof that order was created by the left maker.
1302     /// @param rightSignature Proof that order was created by the right maker.
1303     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
1304     function matchOrders(
1305         LibOrder.Order memory leftOrder,
1306         LibOrder.Order memory rightOrder,
1307         bytes memory leftSignature,
1308         bytes memory rightSignature
1309     )
1310         public
1311         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1312 }
1313 
1314 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/ISignatureValidator.sol
1315 
1316 /*
1317 
1318   Copyright 2018 ZeroEx Intl.
1319 
1320   Licensed under the Apache License, Version 2.0 (the "License");
1321   you may not use this file except in compliance with the License.
1322   You may obtain a copy of the License at
1323 
1324     http://www.apache.org/licenses/LICENSE-2.0
1325 
1326   Unless required by applicable law or agreed to in writing, software
1327   distributed under the License is distributed on an "AS IS" BASIS,
1328   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1329   See the License for the specific language governing permissions and
1330   limitations under the License.
1331 
1332 */
1333 
1334 pragma solidity ^0.4.24;
1335 
1336 
1337 contract ISignatureValidator {
1338 
1339     /// @dev Approves a hash on-chain using any valid signature type.
1340     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1341     /// @param signerAddress Address that should have signed the given hash.
1342     /// @param signature Proof that the hash has been signed by signer.
1343     function preSign(
1344         bytes32 hash,
1345         address signerAddress,
1346         bytes signature
1347     )
1348         external;
1349     
1350     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1351     /// @param validatorAddress Address of Validator contract.
1352     /// @param approval Approval or disapproval of  Validator contract.
1353     function setSignatureValidatorApproval(
1354         address validatorAddress,
1355         bool approval
1356     )
1357         external;
1358 
1359     /// @dev Verifies that a signature is valid.
1360     /// @param hash Message hash that is signed.
1361     /// @param signerAddress Address of signer.
1362     /// @param signature Proof of signing.
1363     /// @return Validity of order signature.
1364     function isValidSignature(
1365         bytes32 hash,
1366         address signerAddress,
1367         bytes memory signature
1368     )
1369         public
1370         view
1371         returns (bool isValid);
1372 }
1373 
1374 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/ITransactions.sol
1375 
1376 /*
1377 
1378   Copyright 2018 ZeroEx Intl.
1379 
1380   Licensed under the Apache License, Version 2.0 (the "License");
1381   you may not use this file except in compliance with the License.
1382   You may obtain a copy of the License at
1383 
1384     http://www.apache.org/licenses/LICENSE-2.0
1385 
1386   Unless required by applicable law or agreed to in writing, software
1387   distributed under the License is distributed on an "AS IS" BASIS,
1388   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1389   See the License for the specific language governing permissions and
1390   limitations under the License.
1391 
1392 */
1393 pragma solidity ^0.4.24;
1394 
1395 
1396 contract ITransactions {
1397 
1398     /// @dev Executes an exchange method call in the context of signer.
1399     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1400     /// @param signerAddress Address of transaction signer.
1401     /// @param data AbiV2 encoded calldata.
1402     /// @param signature Proof of signer transaction by signer.
1403     function executeTransaction(
1404         uint256 salt,
1405         address signerAddress,
1406         bytes data,
1407         bytes signature
1408     )
1409         external;
1410 }
1411 
1412 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IAssetProxyDispatcher.sol
1413 
1414 /*
1415 
1416   Copyright 2018 ZeroEx Intl.
1417 
1418   Licensed under the Apache License, Version 2.0 (the "License");
1419   you may not use this file except in compliance with the License.
1420   You may obtain a copy of the License at
1421 
1422     http://www.apache.org/licenses/LICENSE-2.0
1423 
1424   Unless required by applicable law or agreed to in writing, software
1425   distributed under the License is distributed on an "AS IS" BASIS,
1426   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1427   See the License for the specific language governing permissions and
1428   limitations under the License.
1429 
1430 */
1431 
1432 pragma solidity ^0.4.24;
1433 
1434 
1435 contract IAssetProxyDispatcher {
1436 
1437     /// @dev Registers an asset proxy to its asset proxy id.
1438     ///      Once an asset proxy is registered, it cannot be unregistered.
1439     /// @param assetProxy Address of new asset proxy to register.
1440     function registerAssetProxy(address assetProxy)
1441         external;
1442 
1443     /// @dev Gets an asset proxy.
1444     /// @param assetProxyId Id of the asset proxy.
1445     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1446     function getAssetProxy(bytes4 assetProxyId)
1447         external
1448         view
1449         returns (address);
1450 }
1451 
1452 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IWrapperFunctions.sol
1453 
1454 /*
1455 
1456   Copyright 2018 ZeroEx Intl.
1457 
1458   Licensed under the Apache License, Version 2.0 (the "License");
1459   you may not use this file except in compliance with the License.
1460   You may obtain a copy of the License at
1461 
1462     http://www.apache.org/licenses/LICENSE-2.0
1463 
1464   Unless required by applicable law or agreed to in writing, software
1465   distributed under the License is distributed on an "AS IS" BASIS,
1466   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1467   See the License for the specific language governing permissions and
1468   limitations under the License.
1469 
1470 */
1471 
1472 pragma solidity ^0.4.24;
1473 
1474 
1475 
1476 
1477 contract IWrapperFunctions {
1478 
1479     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1480     /// @param order LibOrder.Order struct containing order specifications.
1481     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1482     /// @param signature Proof that order has been created by maker.
1483     function fillOrKillOrder(
1484         LibOrder.Order memory order,
1485         uint256 takerAssetFillAmount,
1486         bytes memory signature
1487     )
1488         public
1489         returns (LibFillResults.FillResults memory fillResults);
1490 
1491     /// @dev Fills an order with specified parameters and ECDSA signature.
1492     ///      Returns false if the transaction would otherwise revert.
1493     /// @param order LibOrder.Order struct containing order specifications.
1494     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1495     /// @param signature Proof that order has been created by maker.
1496     /// @return Amounts filled and fees paid by maker and taker.
1497     function fillOrderNoThrow(
1498         LibOrder.Order memory order,
1499         uint256 takerAssetFillAmount,
1500         bytes memory signature
1501     )
1502         public
1503         returns (LibFillResults.FillResults memory fillResults);
1504 
1505     /// @dev Synchronously executes multiple calls of fillOrder.
1506     /// @param orders Array of order specifications.
1507     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1508     /// @param signatures Proofs that orders have been created by makers.
1509     /// @return Amounts filled and fees paid by makers and taker.
1510     function batchFillOrders(
1511         LibOrder.Order[] memory orders,
1512         uint256[] memory takerAssetFillAmounts,
1513         bytes[] memory signatures
1514     )
1515         public
1516         returns (LibFillResults.FillResults memory totalFillResults);
1517 
1518     /// @dev Synchronously executes multiple calls of fillOrKill.
1519     /// @param orders Array of order specifications.
1520     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1521     /// @param signatures Proofs that orders have been created by makers.
1522     /// @return Amounts filled and fees paid by makers and taker.
1523     function batchFillOrKillOrders(
1524         LibOrder.Order[] memory orders,
1525         uint256[] memory takerAssetFillAmounts,
1526         bytes[] memory signatures
1527     )
1528         public
1529         returns (LibFillResults.FillResults memory totalFillResults);
1530 
1531     /// @dev Fills an order with specified parameters and ECDSA signature.
1532     ///      Returns false if the transaction would otherwise revert.
1533     /// @param orders Array of order specifications.
1534     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1535     /// @param signatures Proofs that orders have been created by makers.
1536     /// @return Amounts filled and fees paid by makers and taker.
1537     function batchFillOrdersNoThrow(
1538         LibOrder.Order[] memory orders,
1539         uint256[] memory takerAssetFillAmounts,
1540         bytes[] memory signatures
1541     )
1542         public
1543         returns (LibFillResults.FillResults memory totalFillResults);
1544 
1545     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1546     /// @param orders Array of order specifications.
1547     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1548     /// @param signatures Proofs that orders have been created by makers.
1549     /// @return Amounts filled and fees paid by makers and taker.
1550     function marketSellOrders(
1551         LibOrder.Order[] memory orders,
1552         uint256 takerAssetFillAmount,
1553         bytes[] memory signatures
1554     )
1555         public
1556         returns (LibFillResults.FillResults memory totalFillResults);
1557 
1558     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1559     ///      Returns false if the transaction would otherwise revert.
1560     /// @param orders Array of order specifications.
1561     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1562     /// @param signatures Proofs that orders have been signed by makers.
1563     /// @return Amounts filled and fees paid by makers and taker.
1564     function marketSellOrdersNoThrow(
1565         LibOrder.Order[] memory orders,
1566         uint256 takerAssetFillAmount,
1567         bytes[] memory signatures
1568     )
1569         public
1570         returns (LibFillResults.FillResults memory totalFillResults);
1571 
1572     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
1573     /// @param orders Array of order specifications.
1574     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1575     /// @param signatures Proofs that orders have been signed by makers.
1576     /// @return Amounts filled and fees paid by makers and taker.
1577     function marketBuyOrders(
1578         LibOrder.Order[] memory orders,
1579         uint256 makerAssetFillAmount,
1580         bytes[] memory signatures
1581     )
1582         public
1583         returns (LibFillResults.FillResults memory totalFillResults);
1584 
1585     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
1586     ///      Returns false if the transaction would otherwise revert.
1587     /// @param orders Array of order specifications.
1588     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1589     /// @param signatures Proofs that orders have been signed by makers.
1590     /// @return Amounts filled and fees paid by makers and taker.
1591     function marketBuyOrdersNoThrow(
1592         LibOrder.Order[] memory orders,
1593         uint256 makerAssetFillAmount,
1594         bytes[] memory signatures
1595     )
1596         public
1597         returns (LibFillResults.FillResults memory totalFillResults);
1598 
1599     /// @dev Synchronously cancels multiple orders in a single transaction.
1600     /// @param orders Array of order specifications.
1601     function batchCancelOrders(LibOrder.Order[] memory orders)
1602         public;
1603 
1604     /// @dev Fetches information for all passed in orders
1605     /// @param orders Array of order specifications.
1606     /// @return Array of OrderInfo instances that correspond to each order.
1607     function getOrdersInfo(LibOrder.Order[] memory orders)
1608         public
1609         view
1610         returns (LibOrder.OrderInfo[] memory);
1611 }
1612 
1613 // File: @0x/contracts-interfaces/contracts/protocol/Exchange/IExchange.sol
1614 
1615 /*
1616 
1617   Copyright 2018 ZeroEx Intl.
1618 
1619   Licensed under the Apache License, Version 2.0 (the "License");
1620   you may not use this file except in compliance with the License.
1621   You may obtain a copy of the License at
1622 
1623     http://www.apache.org/licenses/LICENSE-2.0
1624 
1625   Unless required by applicable law or agreed to in writing, software
1626   distributed under the License is distributed on an "AS IS" BASIS,
1627   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1628   See the License for the specific language governing permissions and
1629   limitations under the License.
1630 
1631 */
1632 
1633 pragma solidity ^0.4.24;
1634 
1635 
1636 
1637 
1638 
1639 
1640 
1641 
1642 // solhint-disable no-empty-blocks
1643 contract IExchange is
1644     IExchangeCore,
1645     IMatchOrders,
1646     ISignatureValidator,
1647     ITransactions,
1648     IAssetProxyDispatcher,
1649     IWrapperFunctions
1650 {}
1651 
1652 // File: @0x/contracts-tokens/contracts/tokens/ERC20Token/IERC20Token.sol
1653 
1654 /*
1655 
1656   Copyright 2018 ZeroEx Intl.
1657 
1658   Licensed under the Apache License, Version 2.0 (the "License");
1659   you may not use this file except in compliance with the License.
1660   You may obtain a copy of the License at
1661 
1662     http://www.apache.org/licenses/LICENSE-2.0
1663 
1664   Unless required by applicable law or agreed to in writing, software
1665   distributed under the License is distributed on an "AS IS" BASIS,
1666   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1667   See the License for the specific language governing permissions and
1668   limitations under the License.
1669 
1670 */
1671 
1672 pragma solidity ^0.4.24;
1673 
1674 
1675 contract IERC20Token {
1676 
1677     // solhint-disable no-simple-event-func-name
1678     event Transfer(
1679         address indexed _from,
1680         address indexed _to,
1681         uint256 _value
1682     );
1683 
1684     event Approval(
1685         address indexed _owner,
1686         address indexed _spender,
1687         uint256 _value
1688     );
1689 
1690     /// @dev send `value` token to `to` from `msg.sender`
1691     /// @param _to The address of the recipient
1692     /// @param _value The amount of token to be transferred
1693     /// @return True if transfer was successful
1694     function transfer(address _to, uint256 _value)
1695         external
1696         returns (bool);
1697 
1698     /// @dev send `value` token to `to` from `from` on the condition it is approved by `from`
1699     /// @param _from The address of the sender
1700     /// @param _to The address of the recipient
1701     /// @param _value The amount of token to be transferred
1702     /// @return True if transfer was successful
1703     function transferFrom(
1704         address _from,
1705         address _to,
1706         uint256 _value
1707     )
1708         external
1709         returns (bool);
1710     
1711     /// @dev `msg.sender` approves `_spender` to spend `_value` tokens
1712     /// @param _spender The address of the account able to transfer the tokens
1713     /// @param _value The amount of wei to be approved for transfer
1714     /// @return Always true if the call has enough gas to complete execution
1715     function approve(address _spender, uint256 _value)
1716         external
1717         returns (bool);
1718 
1719     /// @dev Query total supply of token
1720     /// @return Total supply of token
1721     function totalSupply()
1722         external
1723         view
1724         returns (uint256);
1725     
1726     /// @param _owner The address from which the balance will be retrieved
1727     /// @return Balance of owner
1728     function balanceOf(address _owner)
1729         external
1730         view
1731         returns (uint256);
1732 
1733     /// @param _owner The address of the account owning tokens
1734     /// @param _spender The address of the account able to transfer the tokens
1735     /// @return Amount of remaining tokens allowed to spent
1736     function allowance(address _owner, address _spender)
1737         external
1738         view
1739         returns (uint256);
1740 }
1741 
1742 // File: @0x/contracts-tokens/contracts/tokens/EtherToken/IEtherToken.sol
1743 
1744 /*
1745 
1746   Copyright 2018 ZeroEx Intl.
1747 
1748   Licensed under the Apache License, Version 2.0 (the "License");
1749   you may not use this file except in compliance with the License.
1750   You may obtain a copy of the License at
1751 
1752     http://www.apache.org/licenses/LICENSE-2.0
1753 
1754   Unless required by applicable law or agreed to in writing, software
1755   distributed under the License is distributed on an "AS IS" BASIS,
1756   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1757   See the License for the specific language governing permissions and
1758   limitations under the License.
1759 
1760 */
1761 
1762 pragma solidity ^0.4.24;
1763 
1764 
1765 
1766 contract IEtherToken is
1767     IERC20Token
1768 {
1769     function deposit()
1770         public
1771         payable;
1772     
1773     function withdraw(uint256 amount)
1774         public;
1775 }
1776 
1777 // File: contracts/Forwarder/libs/LibConstants.sol
1778 
1779 /*
1780 
1781   Copyright 2018 ZeroEx Intl.
1782 
1783   Licensed under the Apache License, Version 2.0 (the "License");
1784   you may not use this file except in compliance with the License.
1785   You may obtain a copy of the License at
1786 
1787     http://www.apache.org/licenses/LICENSE-2.0
1788 
1789   Unless required by applicable law or agreed to in writing, software
1790   distributed under the License is distributed on an "AS IS" BASIS,
1791   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1792   See the License for the specific language governing permissions and
1793   limitations under the License.
1794 
1795 */
1796 
1797 pragma solidity ^0.4.24;
1798 
1799 
1800 
1801 
1802 
1803 
1804 contract LibConstants {
1805 
1806     using LibBytes for bytes;
1807 
1808     bytes4 constant internal ERC20_DATA_ID = bytes4(keccak256("ERC20Token(address)"));
1809     bytes4 constant internal ERC721_DATA_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
1810     uint256 constant internal MAX_UINT = 2**256 - 1;
1811  
1812      // solhint-disable var-name-mixedcase
1813     IExchange internal EXCHANGE;
1814     IEtherToken internal ETHER_TOKEN;
1815     bytes internal WETH_ASSET_DATA;
1816     // solhint-enable var-name-mixedcase
1817 
1818     constructor (
1819         address _exchange,
1820         bytes memory _wethAssetData
1821     )
1822         public
1823     {
1824         EXCHANGE = IExchange(_exchange);
1825         WETH_ASSET_DATA = _wethAssetData;
1826 
1827         address etherToken = _wethAssetData.readAddress(16);
1828         ETHER_TOKEN = IEtherToken(etherToken);
1829     }
1830 }
1831 
1832 // File: contracts/Forwarder/mixins/MWeth.sol
1833 
1834 /*
1835 
1836   Copyright 2018 ZeroEx Intl.
1837 
1838   Licensed under the Apache License, Version 2.0 (the "License");
1839   you may not use this file except in compliance with the License.
1840   You may obtain a copy of the License at
1841 
1842     http://www.apache.org/licenses/LICENSE-2.0
1843 
1844   Unless required by applicable law or agreed to in writing, software
1845   distributed under the License is distributed on an "AS IS" BASIS,
1846   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1847   See the License for the specific language governing permissions and
1848   limitations under the License.
1849 
1850 */
1851 
1852 pragma solidity ^0.4.24;
1853 
1854 
1855 contract MWeth {
1856 
1857     /// @dev Converts message call's ETH value into WETH.
1858     function convertEthToWeth()
1859         internal;
1860 
1861     /// @dev Refunds any excess ETH to msg.sender.
1862     /// @param wethSoldExcludingOrderFees Amount of WETH sold when filling primary orders.
1863     /// @param wethForOrderFees Amount of WETH for primary order fees.
1864     function refundEth(
1865         uint256 wethSoldExcludingOrderFees,
1866         uint256 wethForOrderFees
1867     )
1868         internal;
1869 }
1870 
1871 // File: contracts/Forwarder/MixinWeth.sol
1872 
1873 /*
1874 
1875   Copyright 2018 ZeroEx Intl.
1876 
1877   Licensed under the Apache License, Version 2.0 (the "License");
1878   you may not use this file except in compliance with the License.
1879   You may obtain a copy of the License at
1880 
1881     http://www.apache.org/licenses/LICENSE-2.0
1882 
1883   Unless required by applicable law or agreed to in writing, software
1884   distributed under the License is distributed on an "AS IS" BASIS,
1885   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1886   See the License for the specific language governing permissions and
1887   limitations under the License.
1888 
1889 */
1890 
1891 pragma solidity ^0.4.24;
1892 
1893 
1894 
1895 
1896 
1897 contract MixinWeth is
1898     LibMath,
1899     LibConstants,
1900     MWeth
1901 {
1902     /// @dev Default payabale function, this allows us to withdraw WETH
1903     function ()
1904         public
1905         payable
1906     {
1907         require(
1908             msg.sender == address(ETHER_TOKEN),
1909             "DEFAULT_FUNCTION_WETH_CONTRACT_ONLY"
1910         );
1911     }
1912 
1913     /// @dev Converts message call's ETH value into WETH.
1914     function convertEthToWeth()
1915         internal
1916     {
1917         require(
1918             msg.value > 0,
1919             "INVALID_MSG_VALUE"
1920         );
1921         ETHER_TOKEN.deposit.value(msg.value)();
1922     }
1923 
1924     /// @dev Refunds any excess ETH to msg.sender.
1925     /// @param wethSoldExcludingOrderFees Amount of WETH sold when filling primary orders.
1926     /// @param wethForOrderFees Amount of WETH for primary order fees.
1927     function refundEth(
1928         uint256 wethSoldExcludingOrderFees,
1929         uint256 wethForOrderFees
1930     )
1931         internal
1932     {
1933         // Ensure that no extra WETH owned by this contract has been sold.
1934         uint256 wethSold = safeAdd(wethSoldExcludingOrderFees, wethForOrderFees);
1935         require(
1936             wethSold <= msg.value,
1937             "OVERSOLD_WETH"
1938         );
1939 
1940         // Calculate amount of WETH that hasn't been sold.
1941         uint256 wethRemaining = safeSub(msg.value, wethSold);
1942     
1943         // Do nothing if no WETH remaining
1944         if (wethRemaining > 0) {
1945             // Convert remaining WETH to ETH
1946             ETHER_TOKEN.withdraw(wethRemaining);
1947             // Refund remaining ETH to msg.sender.
1948             msg.sender.transfer(wethRemaining);
1949         }
1950     }
1951 }
1952 
1953 // File: contracts/Forwarder/interfaces/IAssets.sol
1954 
1955 /*
1956 
1957   Copyright 2018 ZeroEx Intl.
1958 
1959   Licensed under the Apache License, Version 2.0 (the "License");
1960   you may not use this file except in compliance with the License.
1961   You may obtain a copy of the License at
1962 
1963     http://www.apache.org/licenses/LICENSE-2.0
1964 
1965   Unless required by applicable law or agreed to in writing, software
1966   distributed under the License is distributed on an "AS IS" BASIS,
1967   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1968   See the License for the specific language governing permissions and
1969   limitations under the License.
1970 
1971 */
1972 
1973 pragma solidity ^0.4.24;
1974 
1975 
1976 contract IAssets {
1977 
1978     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to 
1979     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
1980     ///      used to withdraw assets that were accidentally sent to this contract.
1981     /// @param assetData Byte array encoded for the respective asset proxy.
1982     /// @param amount Amount of ERC20 token to withdraw.
1983     function withdrawAsset(
1984         bytes assetData,
1985         uint256 amount
1986     )
1987         external;
1988 }
1989 
1990 // File: contracts/Forwarder/mixins/MAssets.sol
1991 
1992 /*
1993 
1994   Copyright 2018 ZeroEx Intl.
1995 
1996   Licensed under the Apache License, Version 2.0 (the "License");
1997   you may not use this file except in compliance with the License.
1998   You may obtain a copy of the License at
1999 
2000     http://www.apache.org/licenses/LICENSE-2.0
2001 
2002   Unless required by applicable law or agreed to in writing, software
2003   distributed under the License is distributed on an "AS IS" BASIS,
2004   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2005   See the License for the specific language governing permissions and
2006   limitations under the License.
2007 
2008 */
2009 
2010 pragma solidity ^0.4.24;
2011 
2012 
2013 
2014 contract MAssets is
2015     IAssets
2016 {
2017     /// @dev Transfers given amount of asset to sender.
2018     /// @param assetData Byte array encoded for the respective asset proxy.
2019     /// @param amount Amount of asset to transfer to sender.
2020     function transferAssetToSender(
2021         bytes memory assetData,
2022         uint256 amount
2023     )
2024         internal;
2025 
2026     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2027     /// @param assetData Byte array encoded for the respective asset proxy.
2028     /// @param amount Amount of asset to transfer to sender.
2029     function transferERC20Token(
2030         bytes memory assetData,
2031         uint256 amount
2032     )
2033         internal;
2034 
2035     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2036     /// @param assetData Byte array encoded for the respective asset proxy.
2037     /// @param amount Amount of asset to transfer to sender.
2038     function transferERC721Token(
2039         bytes memory assetData,
2040         uint256 amount
2041     )
2042         internal;
2043 }
2044 
2045 // File: contracts/Forwarder/mixins/MExchangeWrapper.sol
2046 
2047 /*
2048 
2049   Copyright 2018 ZeroEx Intl.
2050 
2051   Licensed under the Apache License, Version 2.0 (the "License");
2052   you may not use this file except in compliance with the License.
2053   You may obtain a copy of the License at
2054 
2055     http://www.apache.org/licenses/LICENSE-2.0
2056 
2057   Unless required by applicable law or agreed to in writing, software
2058   distributed under the License is distributed on an "AS IS" BASIS,
2059   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2060   See the License for the specific language governing permissions and
2061   limitations under the License.
2062 
2063 */
2064 
2065 pragma solidity ^0.4.24;
2066 
2067 
2068 
2069 
2070 contract MExchangeWrapper {
2071 
2072     /// @dev Fills the input order.
2073     ///      Returns false if the transaction would otherwise revert.
2074     /// @param order Order struct containing order specifications.
2075     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2076     /// @param signature Proof that order has been created by maker.
2077     /// @return Amounts filled and fees paid by maker and taker.
2078     function fillOrderNoThrow(
2079         LibOrder.Order memory order,
2080         uint256 takerAssetFillAmount,
2081         bytes memory signature
2082     )
2083         internal
2084         returns (LibFillResults.FillResults memory fillResults);
2085 
2086     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
2087     ///      Returns false if the transaction would otherwise revert.
2088     /// @param orders Array of order specifications.
2089     /// @param wethSellAmount Desired amount of WETH to sell.
2090     /// @param signatures Proofs that orders have been signed by makers.
2091     /// @return Amounts filled and fees paid by makers and taker.
2092     function marketSellWeth(
2093         LibOrder.Order[] memory orders,
2094         uint256 wethSellAmount,
2095         bytes[] memory signatures
2096     )
2097         internal
2098         returns (LibFillResults.FillResults memory totalFillResults);
2099 
2100     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
2101     ///      Returns false if the transaction would otherwise revert.
2102     ///      The asset being sold by taker must always be WETH.
2103     /// @param orders Array of order specifications.
2104     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
2105     /// @param signatures Proofs that orders have been signed by makers.
2106     /// @return Amounts filled and fees paid by makers and taker.
2107     function marketBuyExactAmountWithWeth(
2108         LibOrder.Order[] memory orders,
2109         uint256 makerAssetFillAmount,
2110         bytes[] memory signatures
2111     )
2112         internal
2113         returns (LibFillResults.FillResults memory totalFillResults);
2114 }
2115 
2116 // File: contracts/Forwarder/interfaces/IForwarderCore.sol
2117 
2118 /*
2119 
2120   Copyright 2018 ZeroEx Intl.
2121 
2122   Licensed under the Apache License, Version 2.0 (the "License");
2123   you may not use this file except in compliance with the License.
2124   You may obtain a copy of the License at
2125 
2126     http://www.apache.org/licenses/LICENSE-2.0
2127 
2128   Unless required by applicable law or agreed to in writing, software
2129   distributed under the License is distributed on an "AS IS" BASIS,
2130   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2131   See the License for the specific language governing permissions and
2132   limitations under the License.
2133 
2134 */
2135 
2136 pragma solidity ^0.4.24;
2137 
2138 
2139 
2140 
2141 contract IForwarderCore {
2142 
2143     /// @dev Purchases as much of orders' makerAssets as possible by selling transaction's ETH value.
2144     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2145     /// @param signatures Proofs that orders have been created by makers.
2146     /// @return Amounts filled and fees paid by makers and taker.
2147     function marketSellOrdersWithEth(
2148         LibOrder.Order[] memory orders,
2149         bytes[] memory signatures
2150     )
2151         public payable
2152         returns (LibFillResults.FillResults memory orderFillResults);
2153 
2154     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2155     ///      Any ETH not spent will be refunded to sender.
2156     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2157     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2158     /// @param signatures Proofs that orders have been created by makers.
2159     /// @return Amounts filled and fees paid by makers and taker.
2160     function marketBuyOrdersWithEth(
2161         LibOrder.Order[] memory orders,
2162         uint256 makerAssetFillAmount,
2163         bytes[] memory signatures
2164     )
2165         public payable
2166         returns (LibFillResults.FillResults memory orderFillResults);
2167 }
2168 
2169 // File: contracts/Forwarder/MixinForwarderCore.sol
2170 
2171 /*
2172 
2173   Copyright 2018 ZeroEx Intl.
2174 
2175   Licensed under the Apache License, Version 2.0 (the "License");
2176   you may not use this file except in compliance with the License.
2177   You may obtain a copy of the License at
2178 
2179     http://www.apache.org/licenses/LICENSE-2.0
2180 
2181   Unless required by applicable law or agreed to in writing, software
2182   distributed under the License is distributed on an "AS IS" BASIS,
2183   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2184   See the License for the specific language governing permissions and
2185   limitations under the License.
2186 
2187 */
2188 
2189 pragma solidity ^0.4.24;
2190 
2191 
2192 
2193 
2194 
2195 
2196 
2197 
2198 
2199 
2200 
2201 contract MixinForwarderCore is
2202     LibFillResults,
2203     LibMath,
2204     LibConstants,
2205     MWeth,
2206     MAssets,
2207     MExchangeWrapper,
2208     IForwarderCore
2209 {
2210     using LibBytes for bytes;
2211 
2212     /// @dev Constructor approves ERC20 proxy to transfer ZRX and WETH on this contract's behalf.
2213     constructor ()
2214         public
2215     {
2216         address proxyAddress = EXCHANGE.getAssetProxy(ERC20_DATA_ID);
2217         require(
2218             proxyAddress != address(0),
2219             "UNREGISTERED_ASSET_PROXY"
2220         );
2221         ETHER_TOKEN.approve(proxyAddress, MAX_UINT);
2222     }
2223 
2224     /// @dev Purchases as much of orders' makerAssets as possible by selling transaction's ETH value.
2225     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2226     /// @param signatures Proofs that orders have been created by makers.
2227     /// @return Amounts filled and fees paid by makers and taker.
2228     function marketSellOrdersWithEth(
2229         LibOrder.Order[] memory orders,
2230         bytes[] memory signatures
2231     )
2232         public payable
2233         returns (FillResults memory orderFillResults)
2234     {
2235         // Convert ETH to WETH.
2236         convertEthToWeth();
2237 
2238         uint256 makerAssetAmountPurchased;
2239 
2240         // Market sell.
2241         orderFillResults = marketSellWeth(
2242             orders,
2243             msg.value,
2244             signatures
2245         );
2246         makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2247 
2248         // Refund remaining ETH to msg.sender.
2249         refundEth(
2250             orderFillResults.takerAssetFilledAmount,
2251             orderFillResults.takerFeePaid
2252         );
2253 
2254         // Transfer purchased assets to msg.sender.
2255         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2256     }
2257 
2258     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2259     ///      Any ETH not spent will be refunded to sender.
2260     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2261     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2262     /// @param signatures Proofs that orders have been created by makers.
2263     /// @return Amounts filled and fees paid by makers and taker.
2264     function marketBuyOrdersWithEth(
2265         LibOrder.Order[] memory orders,
2266         uint256 makerAssetFillAmount,
2267         bytes[] memory signatures
2268     )
2269         public payable
2270         returns (FillResults memory orderFillResults)
2271     {
2272         // Convert ETH to WETH.
2273         convertEthToWeth();
2274 
2275         uint256 makerAssetAmountPurchased;
2276         
2277         // Attemp to purchase desired amount of makerAsset.
2278         orderFillResults = marketBuyExactAmountWithWeth(
2279             orders,
2280             makerAssetFillAmount,
2281             signatures
2282         );
2283         makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2284 
2285         // Refund remaining ETH to msg.sender.
2286         refundEth(
2287             orderFillResults.takerAssetFilledAmount,
2288             orderFillResults.takerFeePaid
2289         );
2290 
2291         // Transfer purchased assets to msg.sender.
2292         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2293     }
2294 }
2295 
2296 // File: @0x/contracts-utils/contracts/utils/Ownable/IOwnable.sol
2297 
2298 contract IOwnable {
2299 
2300     function transferOwnership(address newOwner)
2301         public;
2302 }
2303 
2304 // File: @0x/contracts-utils/contracts/utils/Ownable/Ownable.sol
2305 
2306 contract Ownable is
2307     IOwnable
2308 {
2309     address public owner;
2310 
2311     constructor ()
2312         public
2313     {
2314         owner = msg.sender;
2315     }
2316 
2317     modifier onlyOwner() {
2318         require(
2319             msg.sender == owner,
2320             "ONLY_CONTRACT_OWNER"
2321         );
2322         _;
2323     }
2324 
2325     function transferOwnership(address newOwner)
2326         public
2327         onlyOwner
2328     {
2329         if (newOwner != address(0)) {
2330             owner = newOwner;
2331         }
2332     }
2333 }
2334 
2335 // File: @0x/contracts-tokens/contracts/tokens/ERC721Token/IERC721Token.sol
2336 
2337 /*
2338 
2339   Copyright 2018 ZeroEx Intl.
2340 
2341   Licensed under the Apache License, Version 2.0 (the "License");
2342   you may not use this file except in compliance with the License.
2343   You may obtain a copy of the License at
2344 
2345     http://www.apache.org/licenses/LICENSE-2.0
2346 
2347   Unless required by applicable law or agreed to in writing, software
2348   distributed under the License is distributed on an "AS IS" BASIS,
2349   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2350   See the License for the specific language governing permissions and
2351   limitations under the License.
2352 
2353 */
2354 
2355 pragma solidity ^0.4.24;
2356 
2357 
2358 contract IERC721Token {
2359 
2360     /// @dev This emits when ownership of any NFT changes by any mechanism.
2361     ///      This event emits when NFTs are created (`from` == 0) and destroyed
2362     ///      (`to` == 0). Exception: during contract creation, any number of NFTs
2363     ///      may be created and assigned without emitting Transfer. At the time of
2364     ///      any transfer, the approved address for that NFT (if any) is reset to none.
2365     event Transfer(
2366         address indexed _from,
2367         address indexed _to,
2368         uint256 indexed _tokenId
2369     );
2370 
2371     /// @dev This emits when the approved address for an NFT is changed or
2372     ///      reaffirmed. The zero address indicates there is no approved address.
2373     ///      When a Transfer event emits, this also indicates that the approved
2374     ///      address for that NFT (if any) is reset to none.
2375     event Approval(
2376         address indexed _owner,
2377         address indexed _approved,
2378         uint256 indexed _tokenId
2379     );
2380 
2381     /// @dev This emits when an operator is enabled or disabled for an owner.
2382     ///      The operator can manage all NFTs of the owner.
2383     event ApprovalForAll(
2384         address indexed _owner,
2385         address indexed _operator,
2386         bool _approved
2387     );
2388 
2389     /// @notice Transfers the ownership of an NFT from one address to another address
2390     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2391     ///      perator, or the approved address for this NFT. Throws if `_from` is
2392     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2393     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
2394     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
2395     ///      `onERC721Received` on `_to` and throws if the return value is not
2396     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
2397     /// @param _from The current owner of the NFT
2398     /// @param _to The new owner
2399     /// @param _tokenId The NFT to transfer
2400     /// @param _data Additional data with no specified format, sent in call to `_to`
2401     function safeTransferFrom(
2402         address _from,
2403         address _to,
2404         uint256 _tokenId,
2405         bytes _data
2406     )
2407         external;
2408 
2409     /// @notice Transfers the ownership of an NFT from one address to another address
2410     /// @dev This works identically to the other function with an extra data parameter,
2411     ///      except this function just sets data to "".
2412     /// @param _from The current owner of the NFT
2413     /// @param _to The new owner
2414     /// @param _tokenId The NFT to transfer
2415     function safeTransferFrom(
2416         address _from,
2417         address _to,
2418         uint256 _tokenId
2419     )
2420         external;
2421 
2422     /// @notice Change or reaffirm the approved address for an NFT
2423     /// @dev The zero address indicates there is no approved address.
2424     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
2425     ///      operator of the current owner.
2426     /// @param _approved The new approved NFT controller
2427     /// @param _tokenId The NFT to approve
2428     function approve(address _approved, uint256 _tokenId)
2429         external;
2430 
2431     /// @notice Enable or disable approval for a third party ("operator") to manage
2432     ///         all of `msg.sender`'s assets
2433     /// @dev Emits the ApprovalForAll event. The contract MUST allow
2434     ///      multiple operators per owner.
2435     /// @param _operator Address to add to the set of authorized operators
2436     /// @param _approved True if the operator is approved, false to revoke approval
2437     function setApprovalForAll(address _operator, bool _approved)
2438         external;
2439 
2440     /// @notice Count all NFTs assigned to an owner
2441     /// @dev NFTs assigned to the zero address are considered invalid, and this
2442     ///      function throws for queries about the zero address.
2443     /// @param _owner An address for whom to query the balance
2444     /// @return The number of NFTs owned by `_owner`, possibly zero
2445     function balanceOf(address _owner)
2446         external
2447         view
2448         returns (uint256);
2449 
2450     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
2451     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
2452     ///         THEY MAY BE PERMANENTLY LOST
2453     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2454     ///      operator, or the approved address for this NFT. Throws if `_from` is
2455     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2456     ///      `_tokenId` is not a valid NFT.
2457     /// @param _from The current owner of the NFT
2458     /// @param _to The new owner
2459     /// @param _tokenId The NFT to transfer
2460     function transferFrom(
2461         address _from,
2462         address _to,
2463         uint256 _tokenId
2464     )
2465         public;
2466 
2467     /// @notice Find the owner of an NFT
2468     /// @dev NFTs assigned to zero address are considered invalid, and queries
2469     ///      about them do throw.
2470     /// @param _tokenId The identifier for an NFT
2471     /// @return The address of the owner of the NFT
2472     function ownerOf(uint256 _tokenId)
2473         public
2474         view
2475         returns (address);
2476 
2477     /// @notice Get the approved address for a single NFT
2478     /// @dev Throws if `_tokenId` is not a valid NFT.
2479     /// @param _tokenId The NFT to find the approved address for
2480     /// @return The approved address for this NFT, or the zero address if there is none
2481     function getApproved(uint256 _tokenId) 
2482         public
2483         view
2484         returns (address);
2485     
2486     /// @notice Query if an address is an authorized operator for another address
2487     /// @param _owner The address that owns the NFTs
2488     /// @param _operator The address that acts on behalf of the owner
2489     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
2490     function isApprovedForAll(address _owner, address _operator)
2491         public
2492         view
2493         returns (bool);
2494 }
2495 
2496 // File: contracts/Forwarder/MixinAssets.sol
2497 
2498 /*
2499 
2500   Copyright 2018 ZeroEx Intl.
2501 
2502   Licensed under the Apache License, Version 2.0 (the "License");
2503   you may not use this file except in compliance with the License.
2504   You may obtain a copy of the License at
2505 
2506     http://www.apache.org/licenses/LICENSE-2.0
2507 
2508   Unless required by applicable law or agreed to in writing, software
2509   distributed under the License is distributed on an "AS IS" BASIS,
2510   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2511   See the License for the specific language governing permissions and
2512   limitations under the License.
2513 
2514 */
2515 
2516 pragma solidity ^0.4.24;
2517 
2518 
2519 
2520 
2521 
2522 
2523 
2524 
2525 contract MixinAssets is
2526     Ownable,
2527     LibConstants,
2528     MAssets
2529 {
2530     using LibBytes for bytes;
2531 
2532     bytes4 constant internal ERC20_TRANSFER_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
2533 
2534     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to 
2535     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
2536     ///      used to withdraw assets that were accidentally sent to this contract.
2537     /// @param assetData Byte array encoded for the respective asset proxy.
2538     /// @param amount Amount of ERC20 token to withdraw.
2539     function withdrawAsset(
2540         bytes assetData,
2541         uint256 amount
2542     )
2543         external
2544         onlyOwner
2545     {
2546         transferAssetToSender(assetData, amount);
2547     }
2548 
2549     /// @dev Transfers given amount of asset to sender.
2550     /// @param assetData Byte array encoded for the respective asset proxy.
2551     /// @param amount Amount of asset to transfer to sender.
2552     function transferAssetToSender(
2553         bytes memory assetData,
2554         uint256 amount
2555     )
2556         internal
2557     {
2558         bytes4 proxyId = assetData.readBytes4(0);
2559 
2560         if (proxyId == ERC20_DATA_ID) {
2561             transferERC20Token(assetData, amount);
2562         } else if (proxyId == ERC721_DATA_ID) {
2563             transferERC721Token(assetData, amount);
2564         } else {
2565             revert("UNSUPPORTED_ASSET_PROXY");
2566         }
2567     }
2568 
2569     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2570     /// @param assetData Byte array encoded for the respective asset proxy.
2571     /// @param amount Amount of asset to transfer to sender.
2572     function transferERC20Token(
2573         bytes memory assetData,
2574         uint256 amount
2575     )
2576         internal
2577     {
2578         address token = assetData.readAddress(16);
2579 
2580         // Transfer tokens.
2581         // We do a raw call so we can check the success separate
2582         // from the return data.
2583         bool success = token.call(abi.encodeWithSelector(
2584             ERC20_TRANSFER_SELECTOR,
2585             msg.sender,
2586             amount
2587         ));
2588         require(
2589             success,
2590             "TRANSFER_FAILED"
2591         );
2592         
2593         // Check return data.
2594         // If there is no return data, we assume the token incorrectly
2595         // does not return a bool. In this case we expect it to revert
2596         // on failure, which was handled above.
2597         // If the token does return data, we require that it is a single
2598         // value that evaluates to true.
2599         assembly {
2600             if returndatasize {
2601                 success := 0
2602                 if eq(returndatasize, 32) {
2603                     // First 64 bytes of memory are reserved scratch space
2604                     returndatacopy(0, 0, 32)
2605                     success := mload(0)
2606                 }
2607             }
2608         }
2609         require(
2610             success,
2611             "TRANSFER_FAILED"
2612         );
2613     }
2614 
2615     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2616     /// @param assetData Byte array encoded for the respective asset proxy.
2617     /// @param amount Amount of asset to transfer to sender.
2618     function transferERC721Token(
2619         bytes memory assetData,
2620         uint256 amount
2621     )
2622         internal
2623     {
2624         require(
2625             amount == 1,
2626             "INVALID_AMOUNT"
2627         );
2628         // Decode asset data.
2629         address token = assetData.readAddress(16);
2630         uint256 tokenId = assetData.readUint256(36);
2631 
2632         // Perform transfer.
2633         IERC721Token(token).transferFrom(
2634             address(this),
2635             msg.sender,
2636             tokenId
2637         );
2638     }
2639 }
2640 
2641 // File: @0x/contracts-libs/contracts/libs/LibAbiEncoder.sol
2642 
2643 /*
2644 
2645   Copyright 2018 ZeroEx Intl.
2646 
2647   Licensed under the Apache License, Version 2.0 (the "License");
2648   you may not use this file except in compliance with the License.
2649   You may obtain a copy of the License at
2650 
2651     http://www.apache.org/licenses/LICENSE-2.0
2652 
2653   Unless required by applicable law or agreed to in writing, software
2654   distributed under the License is distributed on an "AS IS" BASIS,
2655   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2656   See the License for the specific language governing permissions and
2657   limitations under the License.
2658 
2659 */
2660 
2661 pragma solidity ^0.4.24;
2662 
2663 
2664 
2665 contract LibAbiEncoder {
2666 
2667     /// @dev ABI encodes calldata for `fillOrder`.
2668     /// @param order Order struct containing order specifications.
2669     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2670     /// @param signature Proof that order has been created by maker.
2671     /// @return ABI encoded calldata for `fillOrder`.
2672     function abiEncodeFillOrder(
2673         LibOrder.Order memory order,
2674         uint256 takerAssetFillAmount,
2675         bytes memory signature
2676     )
2677         internal
2678         pure
2679         returns (bytes memory fillOrderCalldata)
2680     {
2681         // We need to call MExchangeCore.fillOrder using a delegatecall in
2682         // assembly so that we can intercept a call that throws. For this, we
2683         // need the input encoded in memory in the Ethereum ABIv2 format [1].
2684 
2685         // | Area     | Offset | Length  | Contents                                    |
2686         // | -------- |--------|---------|-------------------------------------------- |
2687         // | Header   | 0x00   | 4       | function selector                           |
2688         // | Params   |        | 3 * 32  | function parameters:                        |
2689         // |          | 0x00   |         |   1. offset to order (*)                    |
2690         // |          | 0x20   |         |   2. takerAssetFillAmount                   |
2691         // |          | 0x40   |         |   3. offset to signature (*)                |
2692         // | Data     |        | 12 * 32 | order:                                      |
2693         // |          | 0x000  |         |   1.  senderAddress                         |
2694         // |          | 0x020  |         |   2.  makerAddress                          |
2695         // |          | 0x040  |         |   3.  takerAddress                          |
2696         // |          | 0x060  |         |   4.  feeRecipientAddress                   |
2697         // |          | 0x080  |         |   5.  makerAssetAmount                      |
2698         // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
2699         // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
2700         // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
2701         // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
2702         // |          | 0x120  |         |   10. salt                                  |
2703         // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
2704         // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
2705         // |          | 0x180  | 32      | makerAssetData Length                       |
2706         // |          | 0x1A0  | **      | makerAssetData Contents                     |
2707         // |          | 0x1C0  | 32      | takerAssetData Length                       |
2708         // |          | 0x1E0  | **      | takerAssetData Contents                     |
2709         // |          | 0x200  | 32      | signature Length                            |
2710         // |          | 0x220  | **      | signature Contents                          |
2711 
2712         // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
2713         //     An offset stored in the Params area is calculated from the beginning of the Params section.
2714         //     An offset stored in the Data area is calculated from the beginning of the Data section.
2715 
2716         // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.
2717 
2718         // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html
2719 
2720         assembly {
2721 
2722             // Areas below may use the following variables:
2723             //   1. <area>Start   -- Start of this area in memory
2724             //   2. <area>End     -- End of this area in memory. This value may
2725             //                       be precomputed (before writing contents),
2726             //                       or it may be computed as contents are written.
2727             //   3. <area>Offset  -- Current offset into area. If an area's End
2728             //                       is precomputed, this variable tracks the
2729             //                       offsets of contents as they are written.
2730 
2731             /////// Setup Header Area ///////
2732             // Load free memory pointer
2733             fillOrderCalldata := mload(0x40)
2734             // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
2735             // = 0xb4be83d5
2736             // Leave 0x20 bytes to store the length
2737             mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
2738             let headerAreaEnd := add(fillOrderCalldata, 0x24)
2739 
2740             /////// Setup Params Area ///////
2741             // This area is preallocated and written to later.
2742             // This is because we need to fill in offsets that have not yet been calculated.
2743             let paramsAreaStart := headerAreaEnd
2744             let paramsAreaEnd := add(paramsAreaStart, 0x60)
2745             let paramsAreaOffset := paramsAreaStart
2746 
2747             /////// Setup Data Area ///////
2748             let dataAreaStart := paramsAreaEnd
2749             let dataAreaEnd := dataAreaStart
2750 
2751             // Offset from the source data we're reading from
2752             let sourceOffset := order
2753             // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
2754             let arrayLenBytes := 0
2755             let arrayLenWords := 0
2756 
2757             /////// Write order Struct ///////
2758             // Write memory location of Order, relative to the start of the
2759             // parameter list, then increment the paramsAreaOffset respectively.
2760             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2761             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2762 
2763             // Write values for each field in the order
2764             // It would be nice to use a loop, but we save on gas by writing
2765             // the stores sequentially.
2766             mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
2767             mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
2768             mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
2769             mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
2770             mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
2771             mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
2772             mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
2773             mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
2774             mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
2775             mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
2776             mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
2777             mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
2778             dataAreaEnd := add(dataAreaEnd, 0x180)
2779             sourceOffset := add(sourceOffset, 0x180)
2780 
2781             // Write offset to <order.makerAssetData>
2782             mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))
2783 
2784             // Calculate length of <order.makerAssetData>
2785             sourceOffset := mload(add(order, 0x140)) // makerAssetData
2786             arrayLenBytes := mload(sourceOffset)
2787             sourceOffset := add(sourceOffset, 0x20)
2788             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2789 
2790             // Write length of <order.makerAssetData>
2791             mstore(dataAreaEnd, arrayLenBytes)
2792             dataAreaEnd := add(dataAreaEnd, 0x20)
2793 
2794             // Write contents of <order.makerAssetData>
2795             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2796                 mstore(dataAreaEnd, mload(sourceOffset))
2797                 dataAreaEnd := add(dataAreaEnd, 0x20)
2798                 sourceOffset := add(sourceOffset, 0x20)
2799             }
2800 
2801             // Write offset to <order.takerAssetData>
2802             mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))
2803 
2804             // Calculate length of <order.takerAssetData>
2805             sourceOffset := mload(add(order, 0x160)) // takerAssetData
2806             arrayLenBytes := mload(sourceOffset)
2807             sourceOffset := add(sourceOffset, 0x20)
2808             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2809 
2810             // Write length of <order.takerAssetData>
2811             mstore(dataAreaEnd, arrayLenBytes)
2812             dataAreaEnd := add(dataAreaEnd, 0x20)
2813 
2814             // Write contents of  <order.takerAssetData>
2815             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2816                 mstore(dataAreaEnd, mload(sourceOffset))
2817                 dataAreaEnd := add(dataAreaEnd, 0x20)
2818                 sourceOffset := add(sourceOffset, 0x20)
2819             }
2820 
2821             /////// Write takerAssetFillAmount ///////
2822             mstore(paramsAreaOffset, takerAssetFillAmount)
2823             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2824 
2825             /////// Write signature ///////
2826             // Write offset to paramsArea
2827             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2828 
2829             // Calculate length of signature
2830             sourceOffset := signature
2831             arrayLenBytes := mload(sourceOffset)
2832             sourceOffset := add(sourceOffset, 0x20)
2833             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2834 
2835             // Write length of signature
2836             mstore(dataAreaEnd, arrayLenBytes)
2837             dataAreaEnd := add(dataAreaEnd, 0x20)
2838 
2839             // Write contents of signature
2840             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2841                 mstore(dataAreaEnd, mload(sourceOffset))
2842                 dataAreaEnd := add(dataAreaEnd, 0x20)
2843                 sourceOffset := add(sourceOffset, 0x20)
2844             }
2845 
2846             // Set length of calldata
2847             mstore(fillOrderCalldata, sub(dataAreaEnd, add(fillOrderCalldata, 0x20)))
2848 
2849             // Increment free memory pointer
2850             mstore(0x40, dataAreaEnd)
2851         }
2852 
2853         return fillOrderCalldata;
2854     }
2855 }
2856 
2857 // File: contracts/Forwarder/MixinExchangeWrapper.sol
2858 
2859 /*
2860 
2861   Copyright 2018 ZeroEx Intl.
2862 
2863   Licensed under the Apache License, Version 2.0 (the "License");
2864   you may not use this file except in compliance with the License.
2865   You may obtain a copy of the License at
2866 
2867     http://www.apache.org/licenses/LICENSE-2.0
2868 
2869   Unless required by applicable law or agreed to in writing, software
2870   distributed under the License is distributed on an "AS IS" BASIS,
2871   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2872   See the License for the specific language governing permissions and
2873   limitations under the License.
2874 
2875 */
2876 
2877 pragma solidity ^0.4.24;
2878 
2879 
2880 
2881 
2882 
2883 
2884 
2885 
2886 contract MixinExchangeWrapper is
2887     LibAbiEncoder,
2888     LibFillResults,
2889     LibMath,
2890     LibConstants,
2891     MExchangeWrapper
2892 {
2893     /// @dev Fills the input order.
2894     ///      Returns false if the transaction would otherwise revert.
2895     /// @param order Order struct containing order specifications.
2896     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2897     /// @param signature Proof that order has been created by maker.
2898     /// @return Amounts filled and fees paid by maker and taker.
2899     function fillOrderNoThrow(
2900         LibOrder.Order memory order,
2901         uint256 takerAssetFillAmount,
2902         bytes memory signature
2903     )
2904         internal
2905         returns (FillResults memory fillResults)
2906     {
2907         // ABI encode calldata for `fillOrder`
2908         bytes memory fillOrderCalldata = abiEncodeFillOrder(
2909             order,
2910             takerAssetFillAmount,
2911             signature
2912         );
2913 
2914         address exchange = address(EXCHANGE);
2915 
2916         // Call `fillOrder` and handle any exceptions gracefully
2917         assembly {
2918             let success := call(
2919                 gas,                                // forward all gas
2920                 exchange,                           // call address of Exchange contract
2921                 0,                                  // transfer 0 wei
2922                 add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
2923                 mload(fillOrderCalldata),           // length of input
2924                 fillOrderCalldata,                  // write output over input
2925                 128                                 // output size is 128 bytes
2926             )
2927             if success {
2928                 mstore(fillResults, mload(fillOrderCalldata))
2929                 mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
2930                 mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
2931                 mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
2932             }
2933         }
2934         // fillResults values will be 0 by default if call was unsuccessful
2935         return fillResults;
2936     }
2937 
2938     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
2939     ///      Returns false if the transaction would otherwise revert.
2940     /// @param orders Array of order specifications.
2941     /// @param wethSellAmount Desired amount of WETH to sell.
2942     /// @param signatures Proofs that orders have been signed by makers.
2943     /// @return Amounts filled and fees paid by makers and taker.
2944     function marketSellWeth(
2945         LibOrder.Order[] memory orders,
2946         uint256 wethSellAmount,
2947         bytes[] memory signatures
2948     )
2949         internal
2950         returns (FillResults memory totalFillResults)
2951     {
2952         bytes memory makerAssetData = orders[0].makerAssetData;
2953         bytes memory wethAssetData = WETH_ASSET_DATA;
2954 
2955         uint256 ordersLength = orders.length;
2956         for (uint256 i = 0; i != ordersLength; i++) {
2957 
2958             // We assume that asset being bought by taker is the same for each order.
2959             // We assume that asset being sold by taker is WETH for each order.
2960             orders[i].makerAssetData = makerAssetData;
2961             orders[i].takerAssetData = wethAssetData;
2962 
2963             // Calculate the remaining amount of WETH to sell
2964             uint256 remainingTakerAssetFillAmount = safeSub(wethSellAmount, totalFillResults.takerAssetFilledAmount);
2965 
2966             // Attempt to sell the remaining amount of WETH
2967             FillResults memory singleFillResults = fillOrderNoThrow(
2968                 orders[i],
2969                 remainingTakerAssetFillAmount,
2970                 signatures[i]
2971             );
2972 
2973             // Update amounts filled and fees paid by maker and taker
2974             addFillResults(totalFillResults, singleFillResults);
2975 
2976             // Stop execution if the entire amount of takerAsset has been sold
2977             if (totalFillResults.takerAssetFilledAmount >= wethSellAmount) {
2978                 break;
2979             }
2980         }
2981         return totalFillResults;
2982     }
2983 
2984     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
2985     ///      Returns false if the transaction would otherwise revert.
2986     ///      The asset being sold by taker must always be WETH.
2987     /// @param orders Array of order specifications.
2988     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
2989     /// @param signatures Proofs that orders have been signed by makers.
2990     /// @return Amounts filled and fees paid by makers and taker.
2991     function marketBuyExactAmountWithWeth(
2992         LibOrder.Order[] memory orders,
2993         uint256 makerAssetFillAmount,
2994         bytes[] memory signatures
2995     )
2996         internal
2997         returns (FillResults memory totalFillResults)
2998     {
2999         bytes memory makerAssetData = orders[0].makerAssetData;
3000         bytes memory wethAssetData = WETH_ASSET_DATA;
3001 
3002         uint256 ordersLength = orders.length;
3003         for (uint256 i = 0; i != ordersLength; i++) {
3004 
3005             // We assume that asset being bought by taker is the same for each order.
3006             // We assume that asset being sold by taker is WETH for each order.
3007             orders[i].makerAssetData = makerAssetData;
3008             orders[i].takerAssetData = wethAssetData;
3009 
3010             // Calculate the remaining amount of makerAsset to buy
3011             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3012 
3013             // Convert the remaining amount of makerAsset to buy into remaining amount
3014             // of takerAsset to sell, assuming entire amount can be sold in the current order.
3015             // We round up because the exchange rate computed by fillOrder rounds in favor
3016             // of the Maker. In this case we want to overestimate the amount of takerAsset.
3017             uint256 remainingTakerAssetFillAmount = getPartialAmountCeil(
3018                 orders[i].takerAssetAmount,
3019                 orders[i].makerAssetAmount,
3020                 remainingMakerAssetFillAmount
3021             );
3022 
3023             // Attempt to sell the remaining amount of takerAsset
3024             FillResults memory singleFillResults = fillOrderNoThrow(
3025                 orders[i],
3026                 remainingTakerAssetFillAmount,
3027                 signatures[i]
3028             );
3029 
3030             // Update amounts filled and fees paid by maker and taker
3031             addFillResults(totalFillResults, singleFillResults);
3032 
3033             // Stop execution if the entire amount of makerAsset has been bought
3034             uint256 makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount;
3035             if (makerAssetFilledAmount >= makerAssetFillAmount) {
3036                 break;
3037             }
3038         }
3039 
3040         require(
3041             makerAssetFilledAmount >= makerAssetFillAmount,
3042             "COMPLETE_FILL_FAILED"
3043         );
3044         return totalFillResults;
3045     }
3046 }
3047 
3048 // File: contracts/Forwarder/Forwarder.sol
3049 
3050 /*
3051 
3052   Copyright 2018 ZeroEx Intl.
3053 
3054   Licensed under the Apache License, Version 2.0 (the "License");
3055   you may not use this file except in compliance with the License.
3056   You may obtain a copy of the License at
3057 
3058     http://www.apache.org/licenses/LICENSE-2.0
3059 
3060   Unless required by applicable law or agreed to in writing, software
3061   distributed under the License is distributed on an "AS IS" BASIS,
3062   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3063   See the License for the specific language governing permissions and
3064   limitations under the License.
3065 
3066 */
3067 
3068 pragma solidity 0.4.24;
3069 
3070 
3071 
3072 
3073 
3074 
3075 
3076 // solhint-disable no-empty-blocks
3077 contract Forwarder is
3078     LibConstants,
3079     MixinWeth,
3080     MixinAssets,
3081     MixinExchangeWrapper,
3082     MixinForwarderCore
3083 {
3084     constructor (
3085         address _exchange,
3086         bytes memory _wethAssetData
3087     )
3088         public
3089         LibConstants(
3090             _exchange,
3091             _wethAssetData
3092         )
3093         MixinForwarderCore()
3094     {}
3095 }