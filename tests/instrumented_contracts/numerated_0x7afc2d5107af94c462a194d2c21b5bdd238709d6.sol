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
22 /*
23 
24   Copyright 2018 ZeroEx Intl.
25 
26   Licensed under the Apache License, Version 2.0 (the "License");
27   you may not use this file except in compliance with the License.
28   You may obtain a copy of the License at
29 
30     http://www.apache.org/licenses/LICENSE-2.0
31 
32   Unless required by applicable law or agreed to in writing, software
33   distributed under the License is distributed on an "AS IS" BASIS,
34   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
35   See the License for the specific language governing permissions and
36   limitations under the License.
37 
38 */
39 
40 pragma solidity 0.4.24;
41 
42 /*
43 
44   Copyright 2018 ZeroEx Intl.
45 
46   Licensed under the Apache License, Version 2.0 (the "License");
47   you may not use this file except in compliance with the License.
48   You may obtain a copy of the License at
49 
50     http://www.apache.org/licenses/LICENSE-2.0
51 
52   Unless required by applicable law or agreed to in writing, software
53   distributed under the License is distributed on an "AS IS" BASIS,
54   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
55   See the License for the specific language governing permissions and
56   limitations under the License.
57 
58 */
59 
60 pragma solidity 0.4.24;
61 
62 pragma solidity 0.4.24;
63 
64 
65 contract SafeMath {
66 
67     function safeMul(uint256 a, uint256 b)
68         internal
69         pure
70         returns (uint256)
71     {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(
77             c / a == b,
78             "UINT256_OVERFLOW"
79         );
80         return c;
81     }
82 
83     function safeDiv(uint256 a, uint256 b)
84         internal
85         pure
86         returns (uint256)
87     {
88         uint256 c = a / b;
89         return c;
90     }
91 
92     function safeSub(uint256 a, uint256 b)
93         internal
94         pure
95         returns (uint256)
96     {
97         require(
98             b <= a,
99             "UINT256_UNDERFLOW"
100         );
101         return a - b;
102     }
103 
104     function safeAdd(uint256 a, uint256 b)
105         internal
106         pure
107         returns (uint256)
108     {
109         uint256 c = a + b;
110         require(
111             c >= a,
112             "UINT256_OVERFLOW"
113         );
114         return c;
115     }
116 
117     function max64(uint64 a, uint64 b)
118         internal
119         pure
120         returns (uint256)
121     {
122         return a >= b ? a : b;
123     }
124 
125     function min64(uint64 a, uint64 b)
126         internal
127         pure
128         returns (uint256)
129     {
130         return a < b ? a : b;
131     }
132 
133     function max256(uint256 a, uint256 b)
134         internal
135         pure
136         returns (uint256)
137     {
138         return a >= b ? a : b;
139     }
140 
141     function min256(uint256 a, uint256 b)
142         internal
143         pure
144         returns (uint256)
145     {
146         return a < b ? a : b;
147     }
148 }
149 
150 
151 
152 contract LibMath is
153     SafeMath
154 {
155     /// @dev Calculates partial value given a numerator and denominator rounded down.
156     ///      Reverts if rounding error is >= 0.1%
157     /// @param numerator Numerator.
158     /// @param denominator Denominator.
159     /// @param target Value to calculate partial of.
160     /// @return Partial value of target rounded down.
161     function safeGetPartialAmountFloor(
162         uint256 numerator,
163         uint256 denominator,
164         uint256 target
165     )
166         internal
167         pure
168         returns (uint256 partialAmount)
169     {
170         require(
171             denominator > 0,
172             "DIVISION_BY_ZERO"
173         );
174 
175         require(
176             !isRoundingErrorFloor(
177                 numerator,
178                 denominator,
179                 target
180             ),
181             "ROUNDING_ERROR"
182         );
183         
184         partialAmount = safeDiv(
185             safeMul(numerator, target),
186             denominator
187         );
188         return partialAmount;
189     }
190 
191     /// @dev Calculates partial value given a numerator and denominator rounded down.
192     ///      Reverts if rounding error is >= 0.1%
193     /// @param numerator Numerator.
194     /// @param denominator Denominator.
195     /// @param target Value to calculate partial of.
196     /// @return Partial value of target rounded up.
197     function safeGetPartialAmountCeil(
198         uint256 numerator,
199         uint256 denominator,
200         uint256 target
201     )
202         internal
203         pure
204         returns (uint256 partialAmount)
205     {
206         require(
207             denominator > 0,
208             "DIVISION_BY_ZERO"
209         );
210 
211         require(
212             !isRoundingErrorCeil(
213                 numerator,
214                 denominator,
215                 target
216             ),
217             "ROUNDING_ERROR"
218         );
219         
220         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
221         //       ceil(a / b) = floor((a + b - 1) / b)
222         // To implement `ceil(a / b)` using safeDiv.
223         partialAmount = safeDiv(
224             safeAdd(
225                 safeMul(numerator, target),
226                 safeSub(denominator, 1)
227             ),
228             denominator
229         );
230         return partialAmount;
231     }
232 
233     /// @dev Calculates partial value given a numerator and denominator rounded down.
234     /// @param numerator Numerator.
235     /// @param denominator Denominator.
236     /// @param target Value to calculate partial of.
237     /// @return Partial value of target rounded down.
238     function getPartialAmountFloor(
239         uint256 numerator,
240         uint256 denominator,
241         uint256 target
242     )
243         internal
244         pure
245         returns (uint256 partialAmount)
246     {
247         require(
248             denominator > 0,
249             "DIVISION_BY_ZERO"
250         );
251 
252         partialAmount = safeDiv(
253             safeMul(numerator, target),
254             denominator
255         );
256         return partialAmount;
257     }
258     
259     /// @dev Calculates partial value given a numerator and denominator rounded down.
260     /// @param numerator Numerator.
261     /// @param denominator Denominator.
262     /// @param target Value to calculate partial of.
263     /// @return Partial value of target rounded up.
264     function getPartialAmountCeil(
265         uint256 numerator,
266         uint256 denominator,
267         uint256 target
268     )
269         internal
270         pure
271         returns (uint256 partialAmount)
272     {
273         require(
274             denominator > 0,
275             "DIVISION_BY_ZERO"
276         );
277 
278         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
279         //       ceil(a / b) = floor((a + b - 1) / b)
280         // To implement `ceil(a / b)` using safeDiv.
281         partialAmount = safeDiv(
282             safeAdd(
283                 safeMul(numerator, target),
284                 safeSub(denominator, 1)
285             ),
286             denominator
287         );
288         return partialAmount;
289     }
290     
291     /// @dev Checks if rounding error >= 0.1% when rounding down.
292     /// @param numerator Numerator.
293     /// @param denominator Denominator.
294     /// @param target Value to multiply with numerator/denominator.
295     /// @return Rounding error is present.
296     function isRoundingErrorFloor(
297         uint256 numerator,
298         uint256 denominator,
299         uint256 target
300     )
301         internal
302         pure
303         returns (bool isError)
304     {
305         require(
306             denominator > 0,
307             "DIVISION_BY_ZERO"
308         );
309         
310         // The absolute rounding error is the difference between the rounded
311         // value and the ideal value. The relative rounding error is the
312         // absolute rounding error divided by the absolute value of the
313         // ideal value. This is undefined when the ideal value is zero.
314         //
315         // The ideal value is `numerator * target / denominator`.
316         // Let's call `numerator * target % denominator` the remainder.
317         // The absolute error is `remainder / denominator`.
318         //
319         // When the ideal value is zero, we require the absolute error to
320         // be zero. Fortunately, this is always the case. The ideal value is
321         // zero iff `numerator == 0` and/or `target == 0`. In this case the
322         // remainder and absolute error are also zero. 
323         if (target == 0 || numerator == 0) {
324             return false;
325         }
326         
327         // Otherwise, we want the relative rounding error to be strictly
328         // less than 0.1%.
329         // The relative error is `remainder / (numerator * target)`.
330         // We want the relative error less than 1 / 1000:
331         //        remainder / (numerator * denominator)  <  1 / 1000
332         // or equivalently:
333         //        1000 * remainder  <  numerator * target
334         // so we have a rounding error iff:
335         //        1000 * remainder  >=  numerator * target
336         uint256 remainder = mulmod(
337             target,
338             numerator,
339             denominator
340         );
341         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
342         return isError;
343     }
344     
345     /// @dev Checks if rounding error >= 0.1% when rounding up.
346     /// @param numerator Numerator.
347     /// @param denominator Denominator.
348     /// @param target Value to multiply with numerator/denominator.
349     /// @return Rounding error is present.
350     function isRoundingErrorCeil(
351         uint256 numerator,
352         uint256 denominator,
353         uint256 target
354     )
355         internal
356         pure
357         returns (bool isError)
358     {
359         require(
360             denominator > 0,
361             "DIVISION_BY_ZERO"
362         );
363         
364         // See the comments in `isRoundingError`.
365         if (target == 0 || numerator == 0) {
366             // When either is zero, the ideal value and rounded value are zero
367             // and there is no rounding error. (Although the relative error
368             // is undefined.)
369             return false;
370         }
371         // Compute remainder as before
372         uint256 remainder = mulmod(
373             target,
374             numerator,
375             denominator
376         );
377         remainder = safeSub(denominator, remainder) % denominator;
378         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
379         return isError;
380     }
381 }
382 
383 /*
384 
385   Copyright 2018 ZeroEx Intl.
386 
387   Licensed under the Apache License, Version 2.0 (the "License");
388   you may not use this file except in compliance with the License.
389   You may obtain a copy of the License at
390 
391     http://www.apache.org/licenses/LICENSE-2.0
392 
393   Unless required by applicable law or agreed to in writing, software
394   distributed under the License is distributed on an "AS IS" BASIS,
395   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
396   See the License for the specific language governing permissions and
397   limitations under the License.
398 
399 */
400 
401 pragma solidity 0.4.24;
402 
403 /*
404 
405   Copyright 2018 ZeroEx Intl.
406 
407   Licensed under the Apache License, Version 2.0 (the "License");
408   you may not use this file except in compliance with the License.
409   You may obtain a copy of the License at
410 
411     http://www.apache.org/licenses/LICENSE-2.0
412 
413   Unless required by applicable law or agreed to in writing, software
414   distributed under the License is distributed on an "AS IS" BASIS,
415   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
416   See the License for the specific language governing permissions and
417   limitations under the License.
418 
419 */
420 
421 pragma solidity 0.4.24;
422 
423 
424 library LibBytes {
425 
426     using LibBytes for bytes;
427 
428     /// @dev Gets the memory address for a byte array.
429     /// @param input Byte array to lookup.
430     /// @return memoryAddress Memory address of byte array. This
431     ///         points to the header of the byte array which contains
432     ///         the length.
433     function rawAddress(bytes memory input)
434         internal
435         pure
436         returns (uint256 memoryAddress)
437     {
438         assembly {
439             memoryAddress := input
440         }
441         return memoryAddress;
442     }
443     
444     /// @dev Gets the memory address for the contents of a byte array.
445     /// @param input Byte array to lookup.
446     /// @return memoryAddress Memory address of the contents of the byte array.
447     function contentAddress(bytes memory input)
448         internal
449         pure
450         returns (uint256 memoryAddress)
451     {
452         assembly {
453             memoryAddress := add(input, 32)
454         }
455         return memoryAddress;
456     }
457 
458     /// @dev Copies `length` bytes from memory location `source` to `dest`.
459     /// @param dest memory address to copy bytes to.
460     /// @param source memory address to copy bytes from.
461     /// @param length number of bytes to copy.
462     function memCopy(
463         uint256 dest,
464         uint256 source,
465         uint256 length
466     )
467         internal
468         pure
469     {
470         if (length < 32) {
471             // Handle a partial word by reading destination and masking
472             // off the bits we are interested in.
473             // This correctly handles overlap, zero lengths and source == dest
474             assembly {
475                 let mask := sub(exp(256, sub(32, length)), 1)
476                 let s := and(mload(source), not(mask))
477                 let d := and(mload(dest), mask)
478                 mstore(dest, or(s, d))
479             }
480         } else {
481             // Skip the O(length) loop when source == dest.
482             if (source == dest) {
483                 return;
484             }
485 
486             // For large copies we copy whole words at a time. The final
487             // word is aligned to the end of the range (instead of after the
488             // previous) to handle partial words. So a copy will look like this:
489             //
490             //  ####
491             //      ####
492             //          ####
493             //            ####
494             //
495             // We handle overlap in the source and destination range by
496             // changing the copying direction. This prevents us from
497             // overwriting parts of source that we still need to copy.
498             //
499             // This correctly handles source == dest
500             //
501             if (source > dest) {
502                 assembly {
503                     // We subtract 32 from `sEnd` and `dEnd` because it
504                     // is easier to compare with in the loop, and these
505                     // are also the addresses we need for copying the
506                     // last bytes.
507                     length := sub(length, 32)
508                     let sEnd := add(source, length)
509                     let dEnd := add(dest, length)
510 
511                     // Remember the last 32 bytes of source
512                     // This needs to be done here and not after the loop
513                     // because we may have overwritten the last bytes in
514                     // source already due to overlap.
515                     let last := mload(sEnd)
516 
517                     // Copy whole words front to back
518                     // Note: the first check is always true,
519                     // this could have been a do-while loop.
520                     // solhint-disable-next-line no-empty-blocks
521                     for {} lt(source, sEnd) {} {
522                         mstore(dest, mload(source))
523                         source := add(source, 32)
524                         dest := add(dest, 32)
525                     }
526                     
527                     // Write the last 32 bytes
528                     mstore(dEnd, last)
529                 }
530             } else {
531                 assembly {
532                     // We subtract 32 from `sEnd` and `dEnd` because those
533                     // are the starting points when copying a word at the end.
534                     length := sub(length, 32)
535                     let sEnd := add(source, length)
536                     let dEnd := add(dest, length)
537 
538                     // Remember the first 32 bytes of source
539                     // This needs to be done here and not after the loop
540                     // because we may have overwritten the first bytes in
541                     // source already due to overlap.
542                     let first := mload(source)
543 
544                     // Copy whole words back to front
545                     // We use a signed comparisson here to allow dEnd to become
546                     // negative (happens when source and dest < 32). Valid
547                     // addresses in local memory will never be larger than
548                     // 2**255, so they can be safely re-interpreted as signed.
549                     // Note: the first check is always true,
550                     // this could have been a do-while loop.
551                     // solhint-disable-next-line no-empty-blocks
552                     for {} slt(dest, dEnd) {} {
553                         mstore(dEnd, mload(sEnd))
554                         sEnd := sub(sEnd, 32)
555                         dEnd := sub(dEnd, 32)
556                     }
557                     
558                     // Write the first 32 bytes
559                     mstore(dest, first)
560                 }
561             }
562         }
563     }
564 
565     /// @dev Returns a slices from a byte array.
566     /// @param b The byte array to take a slice from.
567     /// @param from The starting index for the slice (inclusive).
568     /// @param to The final index for the slice (exclusive).
569     /// @return result The slice containing bytes at indices [from, to)
570     function slice(
571         bytes memory b,
572         uint256 from,
573         uint256 to
574     )
575         internal
576         pure
577         returns (bytes memory result)
578     {
579         require(
580             from <= to,
581             "FROM_LESS_THAN_TO_REQUIRED"
582         );
583         require(
584             to < b.length,
585             "TO_LESS_THAN_LENGTH_REQUIRED"
586         );
587         
588         // Create a new bytes structure and copy contents
589         result = new bytes(to - from);
590         memCopy(
591             result.contentAddress(),
592             b.contentAddress() + from,
593             result.length
594         );
595         return result;
596     }
597     
598     /// @dev Returns a slice from a byte array without preserving the input.
599     /// @param b The byte array to take a slice from. Will be destroyed in the process.
600     /// @param from The starting index for the slice (inclusive).
601     /// @param to The final index for the slice (exclusive).
602     /// @return result The slice containing bytes at indices [from, to)
603     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
604     function sliceDestructive(
605         bytes memory b,
606         uint256 from,
607         uint256 to
608     )
609         internal
610         pure
611         returns (bytes memory result)
612     {
613         require(
614             from <= to,
615             "FROM_LESS_THAN_TO_REQUIRED"
616         );
617         require(
618             to < b.length,
619             "TO_LESS_THAN_LENGTH_REQUIRED"
620         );
621         
622         // Create a new bytes structure around [from, to) in-place.
623         assembly {
624             result := add(b, from)
625             mstore(result, sub(to, from))
626         }
627         return result;
628     }
629 
630     /// @dev Pops the last byte off of a byte array by modifying its length.
631     /// @param b Byte array that will be modified.
632     /// @return The byte that was popped off.
633     function popLastByte(bytes memory b)
634         internal
635         pure
636         returns (bytes1 result)
637     {
638         require(
639             b.length > 0,
640             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
641         );
642 
643         // Store last byte.
644         result = b[b.length - 1];
645 
646         assembly {
647             // Decrement length of byte array.
648             let newLen := sub(mload(b), 1)
649             mstore(b, newLen)
650         }
651         return result;
652     }
653 
654     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
655     /// @param b Byte array that will be modified.
656     /// @return The 20 byte address that was popped off.
657     function popLast20Bytes(bytes memory b)
658         internal
659         pure
660         returns (address result)
661     {
662         require(
663             b.length >= 20,
664             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
665         );
666 
667         // Store last 20 bytes.
668         result = readAddress(b, b.length - 20);
669 
670         assembly {
671             // Subtract 20 from byte array length.
672             let newLen := sub(mload(b), 20)
673             mstore(b, newLen)
674         }
675         return result;
676     }
677 
678     /// @dev Tests equality of two byte arrays.
679     /// @param lhs First byte array to compare.
680     /// @param rhs Second byte array to compare.
681     /// @return True if arrays are the same. False otherwise.
682     function equals(
683         bytes memory lhs,
684         bytes memory rhs
685     )
686         internal
687         pure
688         returns (bool equal)
689     {
690         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
691         // We early exit on unequal lengths, but keccak would also correctly
692         // handle this.
693         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
694     }
695 
696     /// @dev Reads an address from a position in a byte array.
697     /// @param b Byte array containing an address.
698     /// @param index Index in byte array of address.
699     /// @return address from byte array.
700     function readAddress(
701         bytes memory b,
702         uint256 index
703     )
704         internal
705         pure
706         returns (address result)
707     {
708         require(
709             b.length >= index + 20,  // 20 is length of address
710             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
711         );
712 
713         // Add offset to index:
714         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
715         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
716         index += 20;
717 
718         // Read address from array memory
719         assembly {
720             // 1. Add index to address of bytes array
721             // 2. Load 32-byte word from memory
722             // 3. Apply 20-byte mask to obtain address
723             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
724         }
725         return result;
726     }
727 
728     /// @dev Writes an address into a specific position in a byte array.
729     /// @param b Byte array to insert address into.
730     /// @param index Index in byte array of address.
731     /// @param input Address to put into byte array.
732     function writeAddress(
733         bytes memory b,
734         uint256 index,
735         address input
736     )
737         internal
738         pure
739     {
740         require(
741             b.length >= index + 20,  // 20 is length of address
742             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
743         );
744 
745         // Add offset to index:
746         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
747         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
748         index += 20;
749 
750         // Store address into array memory
751         assembly {
752             // The address occupies 20 bytes and mstore stores 32 bytes.
753             // First fetch the 32-byte word where we'll be storing the address, then
754             // apply a mask so we have only the bytes in the word that the address will not occupy.
755             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
756 
757             // 1. Add index to address of bytes array
758             // 2. Load 32-byte word from memory
759             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
760             let neighbors := and(
761                 mload(add(b, index)),
762                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
763             )
764             
765             // Make sure input address is clean.
766             // (Solidity does not guarantee this)
767             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
768 
769             // Store the neighbors and address into memory
770             mstore(add(b, index), xor(input, neighbors))
771         }
772     }
773 
774     /// @dev Reads a bytes32 value from a position in a byte array.
775     /// @param b Byte array containing a bytes32 value.
776     /// @param index Index in byte array of bytes32 value.
777     /// @return bytes32 value from byte array.
778     function readBytes32(
779         bytes memory b,
780         uint256 index
781     )
782         internal
783         pure
784         returns (bytes32 result)
785     {
786         require(
787             b.length >= index + 32,
788             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
789         );
790 
791         // Arrays are prefixed by a 256 bit length parameter
792         index += 32;
793 
794         // Read the bytes32 from array memory
795         assembly {
796             result := mload(add(b, index))
797         }
798         return result;
799     }
800 
801     /// @dev Writes a bytes32 into a specific position in a byte array.
802     /// @param b Byte array to insert <input> into.
803     /// @param index Index in byte array of <input>.
804     /// @param input bytes32 to put into byte array.
805     function writeBytes32(
806         bytes memory b,
807         uint256 index,
808         bytes32 input
809     )
810         internal
811         pure
812     {
813         require(
814             b.length >= index + 32,
815             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
816         );
817 
818         // Arrays are prefixed by a 256 bit length parameter
819         index += 32;
820 
821         // Read the bytes32 from array memory
822         assembly {
823             mstore(add(b, index), input)
824         }
825     }
826 
827     /// @dev Reads a uint256 value from a position in a byte array.
828     /// @param b Byte array containing a uint256 value.
829     /// @param index Index in byte array of uint256 value.
830     /// @return uint256 value from byte array.
831     function readUint256(
832         bytes memory b,
833         uint256 index
834     )
835         internal
836         pure
837         returns (uint256 result)
838     {
839         result = uint256(readBytes32(b, index));
840         return result;
841     }
842 
843     /// @dev Writes a uint256 into a specific position in a byte array.
844     /// @param b Byte array to insert <input> into.
845     /// @param index Index in byte array of <input>.
846     /// @param input uint256 to put into byte array.
847     function writeUint256(
848         bytes memory b,
849         uint256 index,
850         uint256 input
851     )
852         internal
853         pure
854     {
855         writeBytes32(b, index, bytes32(input));
856     }
857 
858     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
859     /// @param b Byte array containing a bytes4 value.
860     /// @param index Index in byte array of bytes4 value.
861     /// @return bytes4 value from byte array.
862     function readBytes4(
863         bytes memory b,
864         uint256 index
865     )
866         internal
867         pure
868         returns (bytes4 result)
869     {
870         require(
871             b.length >= index + 4,
872             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
873         );
874 
875         // Arrays are prefixed by a 32 byte length field
876         index += 32;
877 
878         // Read the bytes4 from array memory
879         assembly {
880             result := mload(add(b, index))
881             // Solidity does not require us to clean the trailing bytes.
882             // We do it anyway
883             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
884         }
885         return result;
886     }
887 
888     /// @dev Reads nested bytes from a specific position.
889     /// @dev NOTE: the returned value overlaps with the input value.
890     ///            Both should be treated as immutable.
891     /// @param b Byte array containing nested bytes.
892     /// @param index Index of nested bytes.
893     /// @return result Nested bytes.
894     function readBytesWithLength(
895         bytes memory b,
896         uint256 index
897     )
898         internal
899         pure
900         returns (bytes memory result)
901     {
902         // Read length of nested bytes
903         uint256 nestedBytesLength = readUint256(b, index);
904         index += 32;
905 
906         // Assert length of <b> is valid, given
907         // length of nested bytes
908         require(
909             b.length >= index + nestedBytesLength,
910             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
911         );
912         
913         // Return a pointer to the byte array as it exists inside `b`
914         assembly {
915             result := add(b, index)
916         }
917         return result;
918     }
919 
920     /// @dev Inserts bytes at a specific position in a byte array.
921     /// @param b Byte array to insert <input> into.
922     /// @param index Index in byte array of <input>.
923     /// @param input bytes to insert.
924     function writeBytesWithLength(
925         bytes memory b,
926         uint256 index,
927         bytes memory input
928     )
929         internal
930         pure
931     {
932         // Assert length of <b> is valid, given
933         // length of input
934         require(
935             b.length >= index + 32 + input.length,  // 32 bytes to store length
936             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
937         );
938 
939         // Copy <input> into <b>
940         memCopy(
941             b.contentAddress() + index,
942             input.rawAddress(), // includes length of <input>
943             input.length + 32   // +32 bytes to store <input> length
944         );
945     }
946 
947     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
948     /// @param dest Byte array that will be overwritten with source bytes.
949     /// @param source Byte array to copy onto dest bytes.
950     function deepCopyBytes(
951         bytes memory dest,
952         bytes memory source
953     )
954         internal
955         pure
956     {
957         uint256 sourceLen = source.length;
958         // Dest length must be >= source length, or some bytes would not be copied.
959         require(
960             dest.length >= sourceLen,
961             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
962         );
963         memCopy(
964             dest.contentAddress(),
965             source.contentAddress(),
966             sourceLen
967         );
968     }
969 }
970 
971 /*
972 
973   Copyright 2018 ZeroEx Intl.
974 
975   Licensed under the Apache License, Version 2.0 (the "License");
976   you may not use this file except in compliance with the License.
977   You may obtain a copy of the License at
978 
979     http://www.apache.org/licenses/LICENSE-2.0
980 
981   Unless required by applicable law or agreed to in writing, software
982   distributed under the License is distributed on an "AS IS" BASIS,
983   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
984   See the License for the specific language governing permissions and
985   limitations under the License.
986 
987 */
988 
989 pragma solidity 0.4.24;
990 
991 /*
992 
993   Copyright 2018 ZeroEx Intl.
994 
995   Licensed under the Apache License, Version 2.0 (the "License");
996   you may not use this file except in compliance with the License.
997   You may obtain a copy of the License at
998 
999     http://www.apache.org/licenses/LICENSE-2.0
1000 
1001   Unless required by applicable law or agreed to in writing, software
1002   distributed under the License is distributed on an "AS IS" BASIS,
1003   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1004   See the License for the specific language governing permissions and
1005   limitations under the License.
1006 
1007 */
1008 
1009 pragma solidity 0.4.24;
1010 
1011 /*
1012 
1013   Copyright 2018 ZeroEx Intl.
1014 
1015   Licensed under the Apache License, Version 2.0 (the "License");
1016   you may not use this file except in compliance with the License.
1017   You may obtain a copy of the License at
1018 
1019     http://www.apache.org/licenses/LICENSE-2.0
1020 
1021   Unless required by applicable law or agreed to in writing, software
1022   distributed under the License is distributed on an "AS IS" BASIS,
1023   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1024   See the License for the specific language governing permissions and
1025   limitations under the License.
1026 
1027 */
1028 
1029 pragma solidity 0.4.24;
1030 
1031 /*
1032 
1033   Copyright 2018 ZeroEx Intl.
1034 
1035   Licensed under the Apache License, Version 2.0 (the "License");
1036   you may not use this file except in compliance with the License.
1037   You may obtain a copy of the License at
1038 
1039     http://www.apache.org/licenses/LICENSE-2.0
1040 
1041   Unless required by applicable law or agreed to in writing, software
1042   distributed under the License is distributed on an "AS IS" BASIS,
1043   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1044   See the License for the specific language governing permissions and
1045   limitations under the License.
1046 
1047 */
1048 
1049 pragma solidity 0.4.24;
1050 
1051 
1052 contract LibEIP712 {
1053 
1054     // EIP191 header for EIP712 prefix
1055     string constant internal EIP191_HEADER = "\x19\x01";
1056 
1057     // EIP712 Domain Name value
1058     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
1059 
1060     // EIP712 Domain Version value
1061     string constant internal EIP712_DOMAIN_VERSION = "2";
1062 
1063     // Hash of the EIP712 Domain Separator Schema
1064     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
1065         "EIP712Domain(",
1066         "string name,",
1067         "string version,",
1068         "address verifyingContract",
1069         ")"
1070     ));
1071 
1072     // Hash of the EIP712 Domain Separator data
1073     // solhint-disable-next-line var-name-mixedcase
1074     bytes32 public EIP712_DOMAIN_HASH;
1075 
1076     constructor ()
1077         public
1078     {
1079         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
1080             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1081             keccak256(bytes(EIP712_DOMAIN_NAME)),
1082             keccak256(bytes(EIP712_DOMAIN_VERSION)),
1083             bytes32(address(this))
1084         ));
1085     }
1086 
1087     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
1088     /// @param hashStruct The EIP712 hash struct.
1089     /// @return EIP712 hash applied to this EIP712 Domain.
1090     function hashEIP712Message(bytes32 hashStruct)
1091         internal
1092         view
1093         returns (bytes32 result)
1094     {
1095         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
1096 
1097         // Assembly for more efficient computing:
1098         // keccak256(abi.encodePacked(
1099         //     EIP191_HEADER,
1100         //     EIP712_DOMAIN_HASH,
1101         //     hashStruct    
1102         // ));
1103 
1104         assembly {
1105             // Load free memory pointer
1106             let memPtr := mload(64)
1107 
1108             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1109             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1110             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1111 
1112             // Compute hash
1113             result := keccak256(memPtr, 66)
1114         }
1115         return result;
1116     }
1117 }
1118 
1119 
1120 
1121 contract LibOrder is
1122     LibEIP712
1123 {
1124     // Hash for the EIP712 Order Schema
1125     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
1126         "Order(",
1127         "address makerAddress,",
1128         "address takerAddress,",
1129         "address feeRecipientAddress,",
1130         "address senderAddress,",
1131         "uint256 makerAssetAmount,",
1132         "uint256 takerAssetAmount,",
1133         "uint256 makerFee,",
1134         "uint256 takerFee,",
1135         "uint256 expirationTimeSeconds,",
1136         "uint256 salt,",
1137         "bytes makerAssetData,",
1138         "bytes takerAssetData",
1139         ")"
1140     ));
1141 
1142     // A valid order remains fillable until it is expired, fully filled, or cancelled.
1143     // An order's state is unaffected by external factors, like account balances.
1144     enum OrderStatus {
1145         INVALID,                     // Default value
1146         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
1147         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
1148         FILLABLE,                    // Order is fillable
1149         EXPIRED,                     // Order has already expired
1150         FULLY_FILLED,                // Order is fully filled
1151         CANCELLED                    // Order has been cancelled
1152     }
1153 
1154     // solhint-disable max-line-length
1155     struct Order {
1156         address makerAddress;           // Address that created the order.      
1157         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
1158         address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
1159         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1160         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
1161         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
1162         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1163         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1164         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
1165         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
1166         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1167         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1168     }
1169     // solhint-enable max-line-length
1170 
1171     struct OrderInfo {
1172         uint8 orderStatus;                    // Status that describes order's validity and fillability.
1173         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
1174         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
1175     }
1176 
1177     /// @dev Calculates Keccak-256 hash of the order.
1178     /// @param order The order structure.
1179     /// @return Keccak-256 EIP712 hash of the order.
1180     function getOrderHash(Order memory order)
1181         internal
1182         view
1183         returns (bytes32 orderHash)
1184     {
1185         orderHash = hashEIP712Message(hashOrder(order));
1186         return orderHash;
1187     }
1188 
1189     /// @dev Calculates EIP712 hash of the order.
1190     /// @param order The order structure.
1191     /// @return EIP712 hash of the order.
1192     function hashOrder(Order memory order)
1193         internal
1194         pure
1195         returns (bytes32 result)
1196     {
1197         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
1198         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
1199         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
1200 
1201         // Assembly for more efficiently computing:
1202         // keccak256(abi.encodePacked(
1203         //     EIP712_ORDER_SCHEMA_HASH,
1204         //     bytes32(order.makerAddress),
1205         //     bytes32(order.takerAddress),
1206         //     bytes32(order.feeRecipientAddress),
1207         //     bytes32(order.senderAddress),
1208         //     order.makerAssetAmount,
1209         //     order.takerAssetAmount,
1210         //     order.makerFee,
1211         //     order.takerFee,
1212         //     order.expirationTimeSeconds,
1213         //     order.salt,
1214         //     keccak256(order.makerAssetData),
1215         //     keccak256(order.takerAssetData)
1216         // ));
1217 
1218         assembly {
1219             // Calculate memory addresses that will be swapped out before hashing
1220             let pos1 := sub(order, 32)
1221             let pos2 := add(order, 320)
1222             let pos3 := add(order, 352)
1223 
1224             // Backup
1225             let temp1 := mload(pos1)
1226             let temp2 := mload(pos2)
1227             let temp3 := mload(pos3)
1228             
1229             // Hash in place
1230             mstore(pos1, schemaHash)
1231             mstore(pos2, makerAssetDataHash)
1232             mstore(pos3, takerAssetDataHash)
1233             result := keccak256(pos1, 416)
1234             
1235             // Restore
1236             mstore(pos1, temp1)
1237             mstore(pos2, temp2)
1238             mstore(pos3, temp3)
1239         }
1240         return result;
1241     }
1242 }
1243 
1244 /*
1245 
1246   Copyright 2018 ZeroEx Intl.
1247 
1248   Licensed under the Apache License, Version 2.0 (the "License");
1249   you may not use this file except in compliance with the License.
1250   You may obtain a copy of the License at
1251 
1252     http://www.apache.org/licenses/LICENSE-2.0
1253 
1254   Unless required by applicable law or agreed to in writing, software
1255   distributed under the License is distributed on an "AS IS" BASIS,
1256   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1257   See the License for the specific language governing permissions and
1258   limitations under the License.
1259 
1260 */
1261 
1262 pragma solidity 0.4.24;
1263 
1264 
1265 
1266 
1267 contract LibFillResults is
1268     SafeMath
1269 {
1270     struct FillResults {
1271         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
1272         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
1273         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
1274         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
1275     }
1276 
1277     struct MatchedFillResults {
1278         FillResults left;                    // Amounts filled and fees paid of left order.
1279         FillResults right;                   // Amounts filled and fees paid of right order.
1280         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
1281     }
1282 
1283     /// @dev Adds properties of both FillResults instances.
1284     ///      Modifies the first FillResults instance specified.
1285     /// @param totalFillResults Fill results instance that will be added onto.
1286     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
1287     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
1288         internal
1289         pure
1290     {
1291         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
1292         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
1293         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
1294         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
1295     }
1296 }
1297 
1298 
1299 
1300 contract IExchangeCore {
1301 
1302     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1303     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1304     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1305     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1306         external;
1307 
1308     /// @dev Fills the input order.
1309     /// @param order Order struct containing order specifications.
1310     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1311     /// @param signature Proof that order has been created by maker.
1312     /// @return Amounts filled and fees paid by maker and taker.
1313     function fillOrder(
1314         LibOrder.Order memory order,
1315         uint256 takerAssetFillAmount,
1316         bytes memory signature
1317     )
1318         public
1319         returns (LibFillResults.FillResults memory fillResults);
1320 
1321     /// @dev After calling, the order can not be filled anymore.
1322     /// @param order Order struct containing order specifications.
1323     function cancelOrder(LibOrder.Order memory order)
1324         public;
1325 
1326     /// @dev Gets information about an order: status, hash, and amount filled.
1327     /// @param order Order to gather information on.
1328     /// @return OrderInfo Information about the order and its state.
1329     ///                   See LibOrder.OrderInfo for a complete description.
1330     function getOrderInfo(LibOrder.Order memory order)
1331         public
1332         view
1333         returns (LibOrder.OrderInfo memory orderInfo);
1334 }
1335 
1336 /*
1337 
1338   Copyright 2018 ZeroEx Intl.
1339 
1340   Licensed under the Apache License, Version 2.0 (the "License");
1341   you may not use this file except in compliance with the License.
1342   You may obtain a copy of the License at
1343 
1344     http://www.apache.org/licenses/LICENSE-2.0
1345 
1346   Unless required by applicable law or agreed to in writing, software
1347   distributed under the License is distributed on an "AS IS" BASIS,
1348   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1349   See the License for the specific language governing permissions and
1350   limitations under the License.
1351 
1352 */
1353 pragma solidity 0.4.24;
1354 
1355 
1356 
1357 
1358 
1359 contract IMatchOrders {
1360 
1361     /// @dev Match two complementary orders that have a profitable spread.
1362     ///      Each order is filled at their respective price point. However, the calculations are
1363     ///      carried out as though the orders are both being filled at the right order's price point.
1364     ///      The profit made by the left order goes to the taker (who matched the two orders).
1365     /// @param leftOrder First order to match.
1366     /// @param rightOrder Second order to match.
1367     /// @param leftSignature Proof that order was created by the left maker.
1368     /// @param rightSignature Proof that order was created by the right maker.
1369     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
1370     function matchOrders(
1371         LibOrder.Order memory leftOrder,
1372         LibOrder.Order memory rightOrder,
1373         bytes memory leftSignature,
1374         bytes memory rightSignature
1375     )
1376         public
1377         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1378 }
1379 
1380 /*
1381 
1382   Copyright 2018 ZeroEx Intl.
1383 
1384   Licensed under the Apache License, Version 2.0 (the "License");
1385   you may not use this file except in compliance with the License.
1386   You may obtain a copy of the License at
1387 
1388     http://www.apache.org/licenses/LICENSE-2.0
1389 
1390   Unless required by applicable law or agreed to in writing, software
1391   distributed under the License is distributed on an "AS IS" BASIS,
1392   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1393   See the License for the specific language governing permissions and
1394   limitations under the License.
1395 
1396 */
1397 
1398 pragma solidity 0.4.24;
1399 
1400 
1401 contract ISignatureValidator {
1402 
1403     /// @dev Approves a hash on-chain using any valid signature type.
1404     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1405     /// @param signerAddress Address that should have signed the given hash.
1406     /// @param signature Proof that the hash has been signed by signer.
1407     function preSign(
1408         bytes32 hash,
1409         address signerAddress,
1410         bytes signature
1411     )
1412         external;
1413     
1414     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1415     /// @param validatorAddress Address of Validator contract.
1416     /// @param approval Approval or disapproval of  Validator contract.
1417     function setSignatureValidatorApproval(
1418         address validatorAddress,
1419         bool approval
1420     )
1421         external;
1422 
1423     /// @dev Verifies that a signature is valid.
1424     /// @param hash Message hash that is signed.
1425     /// @param signerAddress Address of signer.
1426     /// @param signature Proof of signing.
1427     /// @return Validity of order signature.
1428     function isValidSignature(
1429         bytes32 hash,
1430         address signerAddress,
1431         bytes memory signature
1432     )
1433         public
1434         view
1435         returns (bool isValid);
1436 }
1437 
1438 /*
1439 
1440   Copyright 2018 ZeroEx Intl.
1441 
1442   Licensed under the Apache License, Version 2.0 (the "License");
1443   you may not use this file except in compliance with the License.
1444   You may obtain a copy of the License at
1445 
1446     http://www.apache.org/licenses/LICENSE-2.0
1447 
1448   Unless required by applicable law or agreed to in writing, software
1449   distributed under the License is distributed on an "AS IS" BASIS,
1450   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1451   See the License for the specific language governing permissions and
1452   limitations under the License.
1453 
1454 */
1455 pragma solidity 0.4.24;
1456 
1457 
1458 contract ITransactions {
1459 
1460     /// @dev Executes an exchange method call in the context of signer.
1461     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1462     /// @param signerAddress Address of transaction signer.
1463     /// @param data AbiV2 encoded calldata.
1464     /// @param signature Proof of signer transaction by signer.
1465     function executeTransaction(
1466         uint256 salt,
1467         address signerAddress,
1468         bytes data,
1469         bytes signature
1470     )
1471         external;
1472 }
1473 
1474 /*
1475 
1476   Copyright 2018 ZeroEx Intl.
1477 
1478   Licensed under the Apache License, Version 2.0 (the "License");
1479   you may not use this file except in compliance with the License.
1480   You may obtain a copy of the License at
1481 
1482     http://www.apache.org/licenses/LICENSE-2.0
1483 
1484   Unless required by applicable law or agreed to in writing, software
1485   distributed under the License is distributed on an "AS IS" BASIS,
1486   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1487   See the License for the specific language governing permissions and
1488   limitations under the License.
1489 
1490 */
1491 
1492 pragma solidity 0.4.24;
1493 
1494 
1495 contract IAssetProxyDispatcher {
1496 
1497     /// @dev Registers an asset proxy to its asset proxy id.
1498     ///      Once an asset proxy is registered, it cannot be unregistered.
1499     /// @param assetProxy Address of new asset proxy to register.
1500     function registerAssetProxy(address assetProxy)
1501         external;
1502 
1503     /// @dev Gets an asset proxy.
1504     /// @param assetProxyId Id of the asset proxy.
1505     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1506     function getAssetProxy(bytes4 assetProxyId)
1507         external
1508         view
1509         returns (address);
1510 }
1511 
1512 /*
1513 
1514   Copyright 2018 ZeroEx Intl.
1515 
1516   Licensed under the Apache License, Version 2.0 (the "License");
1517   you may not use this file except in compliance with the License.
1518   You may obtain a copy of the License at
1519 
1520     http://www.apache.org/licenses/LICENSE-2.0
1521 
1522   Unless required by applicable law or agreed to in writing, software
1523   distributed under the License is distributed on an "AS IS" BASIS,
1524   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1525   See the License for the specific language governing permissions and
1526   limitations under the License.
1527 
1528 */
1529 
1530 pragma solidity 0.4.24;
1531 
1532 
1533 
1534 
1535 
1536 contract IWrapperFunctions {
1537 
1538     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1539     /// @param order LibOrder.Order struct containing order specifications.
1540     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1541     /// @param signature Proof that order has been created by maker.
1542     function fillOrKillOrder(
1543         LibOrder.Order memory order,
1544         uint256 takerAssetFillAmount,
1545         bytes memory signature
1546     )
1547         public
1548         returns (LibFillResults.FillResults memory fillResults);
1549 
1550     /// @dev Fills an order with specified parameters and ECDSA signature.
1551     ///      Returns false if the transaction would otherwise revert.
1552     /// @param order LibOrder.Order struct containing order specifications.
1553     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1554     /// @param signature Proof that order has been created by maker.
1555     /// @return Amounts filled and fees paid by maker and taker.
1556     function fillOrderNoThrow(
1557         LibOrder.Order memory order,
1558         uint256 takerAssetFillAmount,
1559         bytes memory signature
1560     )
1561         public
1562         returns (LibFillResults.FillResults memory fillResults);
1563 
1564     /// @dev Synchronously executes multiple calls of fillOrder.
1565     /// @param orders Array of order specifications.
1566     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1567     /// @param signatures Proofs that orders have been created by makers.
1568     /// @return Amounts filled and fees paid by makers and taker.
1569     function batchFillOrders(
1570         LibOrder.Order[] memory orders,
1571         uint256[] memory takerAssetFillAmounts,
1572         bytes[] memory signatures
1573     )
1574         public
1575         returns (LibFillResults.FillResults memory totalFillResults);
1576 
1577     /// @dev Synchronously executes multiple calls of fillOrKill.
1578     /// @param orders Array of order specifications.
1579     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1580     /// @param signatures Proofs that orders have been created by makers.
1581     /// @return Amounts filled and fees paid by makers and taker.
1582     function batchFillOrKillOrders(
1583         LibOrder.Order[] memory orders,
1584         uint256[] memory takerAssetFillAmounts,
1585         bytes[] memory signatures
1586     )
1587         public
1588         returns (LibFillResults.FillResults memory totalFillResults);
1589 
1590     /// @dev Fills an order with specified parameters and ECDSA signature.
1591     ///      Returns false if the transaction would otherwise revert.
1592     /// @param orders Array of order specifications.
1593     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1594     /// @param signatures Proofs that orders have been created by makers.
1595     /// @return Amounts filled and fees paid by makers and taker.
1596     function batchFillOrdersNoThrow(
1597         LibOrder.Order[] memory orders,
1598         uint256[] memory takerAssetFillAmounts,
1599         bytes[] memory signatures
1600     )
1601         public
1602         returns (LibFillResults.FillResults memory totalFillResults);
1603 
1604     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1605     /// @param orders Array of order specifications.
1606     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1607     /// @param signatures Proofs that orders have been created by makers.
1608     /// @return Amounts filled and fees paid by makers and taker.
1609     function marketSellOrders(
1610         LibOrder.Order[] memory orders,
1611         uint256 takerAssetFillAmount,
1612         bytes[] memory signatures
1613     )
1614         public
1615         returns (LibFillResults.FillResults memory totalFillResults);
1616 
1617     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1618     ///      Returns false if the transaction would otherwise revert.
1619     /// @param orders Array of order specifications.
1620     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1621     /// @param signatures Proofs that orders have been signed by makers.
1622     /// @return Amounts filled and fees paid by makers and taker.
1623     function marketSellOrdersNoThrow(
1624         LibOrder.Order[] memory orders,
1625         uint256 takerAssetFillAmount,
1626         bytes[] memory signatures
1627     )
1628         public
1629         returns (LibFillResults.FillResults memory totalFillResults);
1630 
1631     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
1632     /// @param orders Array of order specifications.
1633     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1634     /// @param signatures Proofs that orders have been signed by makers.
1635     /// @return Amounts filled and fees paid by makers and taker.
1636     function marketBuyOrders(
1637         LibOrder.Order[] memory orders,
1638         uint256 makerAssetFillAmount,
1639         bytes[] memory signatures
1640     )
1641         public
1642         returns (LibFillResults.FillResults memory totalFillResults);
1643 
1644     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
1645     ///      Returns false if the transaction would otherwise revert.
1646     /// @param orders Array of order specifications.
1647     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1648     /// @param signatures Proofs that orders have been signed by makers.
1649     /// @return Amounts filled and fees paid by makers and taker.
1650     function marketBuyOrdersNoThrow(
1651         LibOrder.Order[] memory orders,
1652         uint256 makerAssetFillAmount,
1653         bytes[] memory signatures
1654     )
1655         public
1656         returns (LibFillResults.FillResults memory totalFillResults);
1657 
1658     /// @dev Synchronously cancels multiple orders in a single transaction.
1659     /// @param orders Array of order specifications.
1660     function batchCancelOrders(LibOrder.Order[] memory orders)
1661         public;
1662 
1663     /// @dev Fetches information for all passed in orders
1664     /// @param orders Array of order specifications.
1665     /// @return Array of OrderInfo instances that correspond to each order.
1666     function getOrdersInfo(LibOrder.Order[] memory orders)
1667         public
1668         view
1669         returns (LibOrder.OrderInfo[] memory);
1670 }
1671 
1672 
1673 
1674 // solhint-disable no-empty-blocks
1675 contract IExchange is
1676     IExchangeCore,
1677     IMatchOrders,
1678     ISignatureValidator,
1679     ITransactions,
1680     IAssetProxyDispatcher,
1681     IWrapperFunctions
1682 {}
1683 
1684 /*
1685 
1686   Copyright 2018 ZeroEx Intl.
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
1702 pragma solidity 0.4.24;
1703 
1704 /*
1705 
1706   Copyright 2018 ZeroEx Intl.
1707 
1708   Licensed under the Apache License, Version 2.0 (the "License");
1709   you may not use this file except in compliance with the License.
1710   You may obtain a copy of the License at
1711 
1712     http://www.apache.org/licenses/LICENSE-2.0
1713 
1714   Unless required by applicable law or agreed to in writing, software
1715   distributed under the License is distributed on an "AS IS" BASIS,
1716   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1717   See the License for the specific language governing permissions and
1718   limitations under the License.
1719 
1720 */
1721 
1722 pragma solidity 0.4.24;
1723 
1724 
1725 contract IERC20Token {
1726 
1727     // solhint-disable no-simple-event-func-name
1728     event Transfer(
1729         address indexed _from,
1730         address indexed _to,
1731         uint256 _value
1732     );
1733 
1734     event Approval(
1735         address indexed _owner,
1736         address indexed _spender,
1737         uint256 _value
1738     );
1739 
1740     /// @dev send `value` token to `to` from `msg.sender`
1741     /// @param _to The address of the recipient
1742     /// @param _value The amount of token to be transferred
1743     /// @return True if transfer was successful
1744     function transfer(address _to, uint256 _value)
1745         external
1746         returns (bool);
1747 
1748     /// @dev send `value` token to `to` from `from` on the condition it is approved by `from`
1749     /// @param _from The address of the sender
1750     /// @param _to The address of the recipient
1751     /// @param _value The amount of token to be transferred
1752     /// @return True if transfer was successful
1753     function transferFrom(
1754         address _from,
1755         address _to,
1756         uint256 _value
1757     )
1758         external
1759         returns (bool);
1760     
1761     /// @dev `msg.sender` approves `_spender` to spend `_value` tokens
1762     /// @param _spender The address of the account able to transfer the tokens
1763     /// @param _value The amount of wei to be approved for transfer
1764     /// @return Always true if the call has enough gas to complete execution
1765     function approve(address _spender, uint256 _value)
1766         external
1767         returns (bool);
1768 
1769     /// @dev Query total supply of token
1770     /// @return Total supply of token
1771     function totalSupply()
1772         external
1773         view
1774         returns (uint256);
1775     
1776     /// @param _owner The address from which the balance will be retrieved
1777     /// @return Balance of owner
1778     function balanceOf(address _owner)
1779         external
1780         view
1781         returns (uint256);
1782 
1783     /// @param _owner The address of the account owning tokens
1784     /// @param _spender The address of the account able to transfer the tokens
1785     /// @return Amount of remaining tokens allowed to spent
1786     function allowance(address _owner, address _spender)
1787         external
1788         view
1789         returns (uint256);
1790 }
1791 
1792 
1793 
1794 contract IEtherToken is
1795     IERC20Token
1796 {
1797     function deposit()
1798         public
1799         payable;
1800     
1801     function withdraw(uint256 amount)
1802         public;
1803 }
1804 
1805 
1806 
1807 
1808 contract LibConstants {
1809 
1810     using LibBytes for bytes;
1811 
1812     bytes4 constant internal ERC20_DATA_ID = bytes4(keccak256("ERC20Token(address)"));
1813     bytes4 constant internal ERC721_DATA_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
1814     uint256 constant internal MAX_UINT = 2**256 - 1;
1815     uint256 constant internal PERCENTAGE_DENOMINATOR = 10**18; 
1816     uint256 constant internal MAX_FEE_PERCENTAGE = 5 * PERCENTAGE_DENOMINATOR / 100;         // 5%
1817     uint256 constant internal MAX_WETH_FILL_PERCENTAGE = 95 * PERCENTAGE_DENOMINATOR / 100;  // 95%
1818  
1819      // solhint-disable var-name-mixedcase
1820     IExchange internal EXCHANGE;
1821     IEtherToken internal ETHER_TOKEN;
1822     IERC20Token internal ZRX_TOKEN;
1823     bytes internal ZRX_ASSET_DATA;
1824     bytes internal WETH_ASSET_DATA;
1825     // solhint-enable var-name-mixedcase
1826 
1827     constructor (
1828         address _exchange,
1829         bytes memory _zrxAssetData,
1830         bytes memory _wethAssetData
1831     )
1832         public
1833     {
1834         EXCHANGE = IExchange(_exchange);
1835         ZRX_ASSET_DATA = _zrxAssetData;
1836         WETH_ASSET_DATA = _wethAssetData;
1837 
1838         address etherToken = _wethAssetData.readAddress(16);
1839         address zrxToken = _zrxAssetData.readAddress(16);
1840         ETHER_TOKEN = IEtherToken(etherToken);
1841         ZRX_TOKEN = IERC20Token(zrxToken);
1842     }
1843 }
1844 
1845 /*
1846 
1847   Copyright 2018 ZeroEx Intl.
1848 
1849   Licensed under the Apache License, Version 2.0 (the "License");
1850   you may not use this file except in compliance with the License.
1851   You may obtain a copy of the License at
1852 
1853     http://www.apache.org/licenses/LICENSE-2.0
1854 
1855   Unless required by applicable law or agreed to in writing, software
1856   distributed under the License is distributed on an "AS IS" BASIS,
1857   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1858   See the License for the specific language governing permissions and
1859   limitations under the License.
1860 
1861 */
1862 
1863 pragma solidity 0.4.24;
1864 
1865 
1866 contract MWeth {
1867 
1868     /// @dev Converts message call's ETH value into WETH.
1869     function convertEthToWeth()
1870         internal;
1871 
1872     /// @dev Transfers feePercentage of WETH spent on primary orders to feeRecipient.
1873     ///      Refunds any excess ETH to msg.sender.
1874     /// @param wethSoldExcludingFeeOrders Amount of WETH sold when filling primary orders.
1875     /// @param wethSoldForZrx Amount of WETH sold when purchasing ZRX required for primary order fees.
1876     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
1877     /// @param feeRecipient Address that will receive ETH when orders are filled.
1878     function transferEthFeeAndRefund(
1879         uint256 wethSoldExcludingFeeOrders,
1880         uint256 wethSoldForZrx,
1881         uint256 feePercentage,
1882         address feeRecipient
1883     )
1884         internal;
1885 }
1886 
1887 
1888 
1889 contract MixinWeth is
1890     LibMath,
1891     LibConstants,
1892     MWeth
1893 {
1894     /// @dev Default payabale function, this allows us to withdraw WETH
1895     function ()
1896         public
1897         payable
1898     {
1899         require(
1900             msg.sender == address(ETHER_TOKEN),
1901             "DEFAULT_FUNCTION_WETH_CONTRACT_ONLY"
1902         );
1903     }
1904 
1905     /// @dev Converts message call's ETH value into WETH.
1906     function convertEthToWeth()
1907         internal
1908     {
1909         require(
1910             msg.value > 0,
1911             "INVALID_MSG_VALUE"
1912         );
1913         ETHER_TOKEN.deposit.value(msg.value)();
1914     }
1915 
1916     /// @dev Transfers feePercentage of WETH spent on primary orders to feeRecipient.
1917     ///      Refunds any excess ETH to msg.sender.
1918     /// @param wethSoldExcludingFeeOrders Amount of WETH sold when filling primary orders.
1919     /// @param wethSoldForZrx Amount of WETH sold when purchasing ZRX required for primary order fees.
1920     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
1921     /// @param feeRecipient Address that will receive ETH when orders are filled.
1922     function transferEthFeeAndRefund(
1923         uint256 wethSoldExcludingFeeOrders,
1924         uint256 wethSoldForZrx,
1925         uint256 feePercentage,
1926         address feeRecipient
1927     )
1928         internal
1929     {
1930         // Ensure feePercentage is less than 5%.
1931         require(
1932             feePercentage <= MAX_FEE_PERCENTAGE,
1933             "FEE_PERCENTAGE_TOO_LARGE"
1934         );
1935 
1936         // Ensure that no extra WETH owned by this contract has been sold.
1937         uint256 wethSold = safeAdd(wethSoldExcludingFeeOrders, wethSoldForZrx);
1938         require(
1939             wethSold <= msg.value,
1940             "OVERSOLD_WETH"
1941         );
1942 
1943         // Calculate amount of WETH that hasn't been sold.
1944         uint256 wethRemaining = safeSub(msg.value, wethSold);
1945 
1946         // Calculate ETH fee to pay to feeRecipient.
1947         uint256 ethFee = getPartialAmountFloor(
1948             feePercentage,
1949             PERCENTAGE_DENOMINATOR,
1950             wethSoldExcludingFeeOrders
1951         );
1952 
1953         // Ensure fee is less than amount of WETH remaining.
1954         require(
1955             ethFee <= wethRemaining,
1956             "INSUFFICIENT_ETH_REMAINING"
1957         );
1958     
1959         // Do nothing if no WETH remaining
1960         if (wethRemaining > 0) {
1961             // Convert remaining WETH to ETH
1962             ETHER_TOKEN.withdraw(wethRemaining);
1963 
1964             // Pay ETH to feeRecipient
1965             if (ethFee > 0) {
1966                 feeRecipient.transfer(ethFee);
1967             }
1968 
1969             // Refund remaining ETH to msg.sender.
1970             uint256 ethRefund = safeSub(wethRemaining, ethFee);
1971             if (ethRefund > 0) {
1972                 msg.sender.transfer(ethRefund);
1973             }
1974         }
1975     }
1976 }
1977 
1978 /*
1979 
1980   Copyright 2018 ZeroEx Intl.
1981 
1982   Licensed under the Apache License, Version 2.0 (the "License");
1983   you may not use this file except in compliance with the License.
1984   You may obtain a copy of the License at
1985 
1986     http://www.apache.org/licenses/LICENSE-2.0
1987 
1988   Unless required by applicable law or agreed to in writing, software
1989   distributed under the License is distributed on an "AS IS" BASIS,
1990   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1991   See the License for the specific language governing permissions and
1992   limitations under the License.
1993 
1994 */
1995 
1996 pragma solidity 0.4.24;
1997 
1998 
1999 
2000 /*
2001 
2002   Copyright 2018 ZeroEx Intl.
2003 
2004   Licensed under the Apache License, Version 2.0 (the "License");
2005   you may not use this file except in compliance with the License.
2006   You may obtain a copy of the License at
2007 
2008     http://www.apache.org/licenses/LICENSE-2.0
2009 
2010   Unless required by applicable law or agreed to in writing, software
2011   distributed under the License is distributed on an "AS IS" BASIS,
2012   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2013   See the License for the specific language governing permissions and
2014   limitations under the License.
2015 
2016 */
2017 
2018 pragma solidity 0.4.24;
2019 
2020 /*
2021 
2022   Copyright 2018 ZeroEx Intl.
2023 
2024   Licensed under the Apache License, Version 2.0 (the "License");
2025   you may not use this file except in compliance with the License.
2026   You may obtain a copy of the License at
2027 
2028     http://www.apache.org/licenses/LICENSE-2.0
2029 
2030   Unless required by applicable law or agreed to in writing, software
2031   distributed under the License is distributed on an "AS IS" BASIS,
2032   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2033   See the License for the specific language governing permissions and
2034   limitations under the License.
2035 
2036 */
2037 
2038 pragma solidity 0.4.24;
2039 
2040 
2041 contract IAssets {
2042 
2043     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to 
2044     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
2045     ///      used to withdraw assets that were accidentally sent to this contract.
2046     /// @param assetData Byte array encoded for the respective asset proxy.
2047     /// @param amount Amount of ERC20 token to withdraw.
2048     function withdrawAsset(
2049         bytes assetData,
2050         uint256 amount
2051     )
2052         external;
2053 }
2054 
2055 
2056 
2057 contract MAssets is
2058     IAssets
2059 {
2060     /// @dev Transfers given amount of asset to sender.
2061     /// @param assetData Byte array encoded for the respective asset proxy.
2062     /// @param amount Amount of asset to transfer to sender.
2063     function transferAssetToSender(
2064         bytes memory assetData,
2065         uint256 amount
2066     )
2067         internal;
2068 
2069     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2070     /// @param assetData Byte array encoded for the respective asset proxy.
2071     /// @param amount Amount of asset to transfer to sender.
2072     function transferERC20Token(
2073         bytes memory assetData,
2074         uint256 amount
2075     )
2076         internal;
2077 
2078     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2079     /// @param assetData Byte array encoded for the respective asset proxy.
2080     /// @param amount Amount of asset to transfer to sender.
2081     function transferERC721Token(
2082         bytes memory assetData,
2083         uint256 amount
2084     )
2085         internal;
2086 }
2087 
2088 /*
2089 
2090   Copyright 2018 ZeroEx Intl.
2091 
2092   Licensed under the Apache License, Version 2.0 (the "License");
2093   you may not use this file except in compliance with the License.
2094   You may obtain a copy of the License at
2095 
2096     http://www.apache.org/licenses/LICENSE-2.0
2097 
2098   Unless required by applicable law or agreed to in writing, software
2099   distributed under the License is distributed on an "AS IS" BASIS,
2100   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2101   See the License for the specific language governing permissions and
2102   limitations under the License.
2103 
2104 */
2105 
2106 pragma solidity 0.4.24;
2107 
2108 
2109 
2110 
2111 
2112 contract MExchangeWrapper {
2113 
2114     /// @dev Fills the input order.
2115     ///      Returns false if the transaction would otherwise revert.
2116     /// @param order Order struct containing order specifications.
2117     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2118     /// @param signature Proof that order has been created by maker.
2119     /// @return Amounts filled and fees paid by maker and taker.
2120     function fillOrderNoThrow(
2121         LibOrder.Order memory order,
2122         uint256 takerAssetFillAmount,
2123         bytes memory signature
2124     )
2125         internal
2126         returns (LibFillResults.FillResults memory fillResults);
2127 
2128     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
2129     ///      Returns false if the transaction would otherwise revert.
2130     /// @param orders Array of order specifications.
2131     /// @param wethSellAmount Desired amount of WETH to sell.
2132     /// @param signatures Proofs that orders have been signed by makers.
2133     /// @return Amounts filled and fees paid by makers and taker.
2134     function marketSellWeth(
2135         LibOrder.Order[] memory orders,
2136         uint256 wethSellAmount,
2137         bytes[] memory signatures
2138     )
2139         internal
2140         returns (LibFillResults.FillResults memory totalFillResults);
2141 
2142     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
2143     ///      Returns false if the transaction would otherwise revert.
2144     ///      The asset being sold by taker must always be WETH.
2145     /// @param orders Array of order specifications.
2146     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
2147     /// @param signatures Proofs that orders have been signed by makers.
2148     /// @return Amounts filled and fees paid by makers and taker.
2149     function marketBuyExactAmountWithWeth(
2150         LibOrder.Order[] memory orders,
2151         uint256 makerAssetFillAmount,
2152         bytes[] memory signatures
2153     )
2154         internal
2155         returns (LibFillResults.FillResults memory totalFillResults);
2156 
2157     /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
2158     ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
2159     ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
2160     ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
2161     ///      The asset being sold by taker must always be WETH. 
2162     /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
2163     /// @param zrxBuyAmount Desired amount of ZRX to buy.
2164     /// @param signatures Proofs that orders have been created by makers.
2165     /// @return totalFillResults Amounts filled and fees paid by maker and taker.
2166     function marketBuyExactZrxWithWeth(
2167         LibOrder.Order[] memory orders,
2168         uint256 zrxBuyAmount,
2169         bytes[] memory signatures
2170     )
2171         internal
2172         returns (LibFillResults.FillResults memory totalFillResults);
2173 }
2174 
2175 /*
2176 
2177   Copyright 2018 ZeroEx Intl.
2178 
2179   Licensed under the Apache License, Version 2.0 (the "License");
2180   you may not use this file except in compliance with the License.
2181   You may obtain a copy of the License at
2182 
2183     http://www.apache.org/licenses/LICENSE-2.0
2184 
2185   Unless required by applicable law or agreed to in writing, software
2186   distributed under the License is distributed on an "AS IS" BASIS,
2187   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2188   See the License for the specific language governing permissions and
2189   limitations under the License.
2190 
2191 */
2192 
2193 pragma solidity 0.4.24;
2194 
2195 
2196 
2197 
2198 
2199 contract IForwarderCore {
2200 
2201     /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
2202     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2203     ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
2204     ///      Any ETH not spent will be refunded to sender.
2205     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2206     /// @param signatures Proofs that orders have been created by makers.
2207     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2208     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2209     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2210     /// @param feeRecipient Address that will receive ETH when orders are filled.
2211     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2212     function marketSellOrdersWithEth(
2213         LibOrder.Order[] memory orders,
2214         bytes[] memory signatures,
2215         LibOrder.Order[] memory feeOrders,
2216         bytes[] memory feeSignatures,
2217         uint256  feePercentage,
2218         address feeRecipient
2219     )
2220         public
2221         payable
2222         returns (
2223             LibFillResults.FillResults memory orderFillResults,
2224             LibFillResults.FillResults memory feeOrderFillResults
2225         );
2226 
2227     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2228     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2229     ///      Any ETH not spent will be refunded to sender.
2230     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2231     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2232     /// @param signatures Proofs that orders have been created by makers.
2233     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2234     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2235     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2236     /// @param feeRecipient Address that will receive ETH when orders are filled.
2237     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2238     function marketBuyOrdersWithEth(
2239         LibOrder.Order[] memory orders,
2240         uint256 makerAssetFillAmount,
2241         bytes[] memory signatures,
2242         LibOrder.Order[] memory feeOrders,
2243         bytes[] memory feeSignatures,
2244         uint256  feePercentage,
2245         address feeRecipient
2246     )
2247         public
2248         payable
2249         returns (
2250             LibFillResults.FillResults memory orderFillResults,
2251             LibFillResults.FillResults memory feeOrderFillResults
2252         );
2253 }
2254 
2255 
2256 
2257 
2258 
2259 
2260 
2261 contract MixinForwarderCore is
2262     LibFillResults,
2263     LibMath,
2264     LibConstants,
2265     MWeth,
2266     MAssets,
2267     MExchangeWrapper,
2268     IForwarderCore
2269 {
2270     using LibBytes for bytes;
2271 
2272     /// @dev Constructor approves ERC20 proxy to transfer ZRX and WETH on this contract's behalf.
2273     constructor ()
2274         public
2275     {
2276         address proxyAddress = EXCHANGE.getAssetProxy(ERC20_DATA_ID);
2277         require(
2278             proxyAddress != address(0),
2279             "UNREGISTERED_ASSET_PROXY"
2280         );
2281         ETHER_TOKEN.approve(proxyAddress, MAX_UINT);
2282         ZRX_TOKEN.approve(proxyAddress, MAX_UINT);
2283     }
2284 
2285     /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
2286     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2287     ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
2288     ///      Any ETH not spent will be refunded to sender.
2289     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2290     /// @param signatures Proofs that orders have been created by makers.
2291     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2292     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2293     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2294     /// @param feeRecipient Address that will receive ETH when orders are filled.
2295     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2296     function marketSellOrdersWithEth(
2297         LibOrder.Order[] memory orders,
2298         bytes[] memory signatures,
2299         LibOrder.Order[] memory feeOrders,
2300         bytes[] memory feeSignatures,
2301         uint256  feePercentage,
2302         address feeRecipient
2303     )
2304         public
2305         payable
2306         returns (
2307             FillResults memory orderFillResults,
2308             FillResults memory feeOrderFillResults
2309         )
2310     {
2311         // Convert ETH to WETH.
2312         convertEthToWeth();
2313 
2314         uint256 wethSellAmount;
2315         uint256 zrxBuyAmount;
2316         uint256 makerAssetAmountPurchased;
2317         if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
2318             // Calculate amount of WETH that won't be spent on ETH fees.
2319             wethSellAmount = getPartialAmountFloor(
2320                 PERCENTAGE_DENOMINATOR,
2321                 safeAdd(PERCENTAGE_DENOMINATOR, feePercentage),
2322                 msg.value
2323             );
2324             // Market sell available WETH.
2325             // ZRX fees are paid with this contract's balance.
2326             orderFillResults = marketSellWeth(
2327                 orders,
2328                 wethSellAmount,
2329                 signatures
2330             );
2331             // The fee amount must be deducted from the amount transfered back to sender.
2332             makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
2333         } else {
2334             // 5% of WETH is reserved for filling feeOrders and paying feeRecipient.
2335             wethSellAmount = getPartialAmountFloor(
2336                 MAX_WETH_FILL_PERCENTAGE,
2337                 PERCENTAGE_DENOMINATOR,
2338                 msg.value
2339             );
2340             // Market sell 95% of WETH.
2341             // ZRX fees are payed with this contract's balance.
2342             orderFillResults = marketSellWeth(
2343                 orders,
2344                 wethSellAmount,
2345                 signatures
2346             );
2347             // Buy back all ZRX spent on fees.
2348             zrxBuyAmount = orderFillResults.takerFeePaid;
2349             feeOrderFillResults = marketBuyExactZrxWithWeth(
2350                 feeOrders,
2351                 zrxBuyAmount,
2352                 feeSignatures
2353             );
2354             makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2355         }
2356 
2357         // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
2358         // Refund remaining ETH to msg.sender.
2359         transferEthFeeAndRefund(
2360             orderFillResults.takerAssetFilledAmount,
2361             feeOrderFillResults.takerAssetFilledAmount,
2362             feePercentage,
2363             feeRecipient
2364         );
2365 
2366         // Transfer purchased assets to msg.sender.
2367         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2368     }
2369 
2370     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2371     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2372     ///      Any ETH not spent will be refunded to sender.
2373     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
2374     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2375     /// @param signatures Proofs that orders have been created by makers.
2376     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2377     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2378     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2379     /// @param feeRecipient Address that will receive ETH when orders are filled.
2380     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2381     function marketBuyOrdersWithEth(
2382         LibOrder.Order[] memory orders,
2383         uint256 makerAssetFillAmount,
2384         bytes[] memory signatures,
2385         LibOrder.Order[] memory feeOrders,
2386         bytes[] memory feeSignatures,
2387         uint256  feePercentage,
2388         address feeRecipient
2389     )
2390         public
2391         payable
2392         returns (
2393             FillResults memory orderFillResults,
2394             FillResults memory feeOrderFillResults
2395         )
2396     {
2397         // Convert ETH to WETH.
2398         convertEthToWeth();
2399 
2400         uint256 zrxBuyAmount;
2401         uint256 makerAssetAmountPurchased;
2402         if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
2403             // If the makerAsset is ZRX, it is not necessary to pay fees out of this
2404             // contracts's ZRX balance because fees are factored into the price of the order.
2405             orderFillResults = marketBuyExactZrxWithWeth(
2406                 orders,
2407                 makerAssetFillAmount,
2408                 signatures
2409             );
2410             // The fee amount must be deducted from the amount transfered back to sender.
2411             makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
2412         } else {
2413             // Attemp to purchase desired amount of makerAsset.
2414             // ZRX fees are payed with this contract's balance.
2415             orderFillResults = marketBuyExactAmountWithWeth(
2416                 orders,
2417                 makerAssetFillAmount,
2418                 signatures
2419             );
2420             // Buy back all ZRX spent on fees.
2421             zrxBuyAmount = orderFillResults.takerFeePaid;
2422             feeOrderFillResults = marketBuyExactZrxWithWeth(
2423                 feeOrders,
2424                 zrxBuyAmount,
2425                 feeSignatures
2426             );
2427             makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2428         }
2429 
2430         // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
2431         // Refund remaining ETH to msg.sender.
2432         transferEthFeeAndRefund(
2433             orderFillResults.takerAssetFilledAmount,
2434             feeOrderFillResults.takerAssetFilledAmount,
2435             feePercentage,
2436             feeRecipient
2437         );
2438 
2439         // Transfer purchased assets to msg.sender.
2440         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2441     }
2442 }
2443 
2444 
2445 /*
2446 
2447   Copyright 2018 ZeroEx Intl.
2448 
2449   Licensed under the Apache License, Version 2.0 (the "License");
2450   you may not use this file except in compliance with the License.
2451   You may obtain a copy of the License at
2452 
2453     http://www.apache.org/licenses/LICENSE-2.0
2454 
2455   Unless required by applicable law or agreed to in writing, software
2456   distributed under the License is distributed on an "AS IS" BASIS,
2457   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2458   See the License for the specific language governing permissions and
2459   limitations under the License.
2460 
2461 */
2462 
2463 pragma solidity 0.4.24;
2464 
2465 
2466 pragma solidity 0.4.24;
2467 
2468 pragma solidity 0.4.24;
2469 
2470 
2471 contract IOwnable {
2472 
2473     function transferOwnership(address newOwner)
2474         public;
2475 }
2476 
2477 
2478 
2479 contract Ownable is
2480     IOwnable
2481 {
2482     address public owner;
2483 
2484     constructor ()
2485         public
2486     {
2487         owner = msg.sender;
2488     }
2489 
2490     modifier onlyOwner() {
2491         require(
2492             msg.sender == owner,
2493             "ONLY_CONTRACT_OWNER"
2494         );
2495         _;
2496     }
2497 
2498     function transferOwnership(address newOwner)
2499         public
2500         onlyOwner
2501     {
2502         if (newOwner != address(0)) {
2503             owner = newOwner;
2504         }
2505     }
2506 }
2507 
2508 
2509 /*
2510 
2511   Copyright 2018 ZeroEx Intl.
2512 
2513   Licensed under the Apache License, Version 2.0 (the "License");
2514   you may not use this file except in compliance with the License.
2515   You may obtain a copy of the License at
2516 
2517     http://www.apache.org/licenses/LICENSE-2.0
2518 
2519   Unless required by applicable law or agreed to in writing, software
2520   distributed under the License is distributed on an "AS IS" BASIS,
2521   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2522   See the License for the specific language governing permissions and
2523   limitations under the License.
2524 
2525 */
2526 
2527 pragma solidity 0.4.24;
2528 
2529 
2530 contract IERC721Token {
2531 
2532     /// @dev This emits when ownership of any NFT changes by any mechanism.
2533     ///      This event emits when NFTs are created (`from` == 0) and destroyed
2534     ///      (`to` == 0). Exception: during contract creation, any number of NFTs
2535     ///      may be created and assigned without emitting Transfer. At the time of
2536     ///      any transfer, the approved address for that NFT (if any) is reset to none.
2537     event Transfer(
2538         address indexed _from,
2539         address indexed _to,
2540         uint256 indexed _tokenId
2541     );
2542 
2543     /// @dev This emits when the approved address for an NFT is changed or
2544     ///      reaffirmed. The zero address indicates there is no approved address.
2545     ///      When a Transfer event emits, this also indicates that the approved
2546     ///      address for that NFT (if any) is reset to none.
2547     event Approval(
2548         address indexed _owner,
2549         address indexed _approved,
2550         uint256 indexed _tokenId
2551     );
2552 
2553     /// @dev This emits when an operator is enabled or disabled for an owner.
2554     ///      The operator can manage all NFTs of the owner.
2555     event ApprovalForAll(
2556         address indexed _owner,
2557         address indexed _operator,
2558         bool _approved
2559     );
2560 
2561     /// @notice Transfers the ownership of an NFT from one address to another address
2562     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2563     ///      perator, or the approved address for this NFT. Throws if `_from` is
2564     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2565     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
2566     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
2567     ///      `onERC721Received` on `_to` and throws if the return value is not
2568     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
2569     /// @param _from The current owner of the NFT
2570     /// @param _to The new owner
2571     /// @param _tokenId The NFT to transfer
2572     /// @param _data Additional data with no specified format, sent in call to `_to`
2573     function safeTransferFrom(
2574         address _from,
2575         address _to,
2576         uint256 _tokenId,
2577         bytes _data
2578     )
2579         external;
2580 
2581     /// @notice Transfers the ownership of an NFT from one address to another address
2582     /// @dev This works identically to the other function with an extra data parameter,
2583     ///      except this function just sets data to "".
2584     /// @param _from The current owner of the NFT
2585     /// @param _to The new owner
2586     /// @param _tokenId The NFT to transfer
2587     function safeTransferFrom(
2588         address _from,
2589         address _to,
2590         uint256 _tokenId
2591     )
2592         external;
2593 
2594     /// @notice Change or reaffirm the approved address for an NFT
2595     /// @dev The zero address indicates there is no approved address.
2596     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
2597     ///      operator of the current owner.
2598     /// @param _approved The new approved NFT controller
2599     /// @param _tokenId The NFT to approve
2600     function approve(address _approved, uint256 _tokenId)
2601         external;
2602 
2603     /// @notice Enable or disable approval for a third party ("operator") to manage
2604     ///         all of `msg.sender`'s assets
2605     /// @dev Emits the ApprovalForAll event. The contract MUST allow
2606     ///      multiple operators per owner.
2607     /// @param _operator Address to add to the set of authorized operators
2608     /// @param _approved True if the operator is approved, false to revoke approval
2609     function setApprovalForAll(address _operator, bool _approved)
2610         external;
2611 
2612     /// @notice Count all NFTs assigned to an owner
2613     /// @dev NFTs assigned to the zero address are considered invalid, and this
2614     ///      function throws for queries about the zero address.
2615     /// @param _owner An address for whom to query the balance
2616     /// @return The number of NFTs owned by `_owner`, possibly zero
2617     function balanceOf(address _owner)
2618         external
2619         view
2620         returns (uint256);
2621 
2622     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
2623     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
2624     ///         THEY MAY BE PERMANENTLY LOST
2625     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2626     ///      operator, or the approved address for this NFT. Throws if `_from` is
2627     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2628     ///      `_tokenId` is not a valid NFT.
2629     /// @param _from The current owner of the NFT
2630     /// @param _to The new owner
2631     /// @param _tokenId The NFT to transfer
2632     function transferFrom(
2633         address _from,
2634         address _to,
2635         uint256 _tokenId
2636     )
2637         public;
2638 
2639     /// @notice Find the owner of an NFT
2640     /// @dev NFTs assigned to zero address are considered invalid, and queries
2641     ///      about them do throw.
2642     /// @param _tokenId The identifier for an NFT
2643     /// @return The address of the owner of the NFT
2644     function ownerOf(uint256 _tokenId)
2645         public
2646         view
2647         returns (address);
2648 
2649     /// @notice Get the approved address for a single NFT
2650     /// @dev Throws if `_tokenId` is not a valid NFT.
2651     /// @param _tokenId The NFT to find the approved address for
2652     /// @return The approved address for this NFT, or the zero address if there is none
2653     function getApproved(uint256 _tokenId) 
2654         public
2655         view
2656         returns (address);
2657     
2658     /// @notice Query if an address is an authorized operator for another address
2659     /// @param _owner The address that owns the NFTs
2660     /// @param _operator The address that acts on behalf of the owner
2661     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
2662     function isApprovedForAll(address _owner, address _operator)
2663         public
2664         view
2665         returns (bool);
2666 }
2667 
2668 
2669 
2670 
2671 
2672 contract MixinAssets is
2673     Ownable,
2674     LibConstants,
2675     MAssets
2676 {
2677     using LibBytes for bytes;
2678 
2679     bytes4 constant internal ERC20_TRANSFER_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
2680 
2681     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to 
2682     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
2683     ///      used to withdraw assets that were accidentally sent to this contract.
2684     /// @param assetData Byte array encoded for the respective asset proxy.
2685     /// @param amount Amount of ERC20 token to withdraw.
2686     function withdrawAsset(
2687         bytes assetData,
2688         uint256 amount
2689     )
2690         external
2691         onlyOwner
2692     {
2693         transferAssetToSender(assetData, amount);
2694     }
2695 
2696     /// @dev Transfers given amount of asset to sender.
2697     /// @param assetData Byte array encoded for the respective asset proxy.
2698     /// @param amount Amount of asset to transfer to sender.
2699     function transferAssetToSender(
2700         bytes memory assetData,
2701         uint256 amount
2702     )
2703         internal
2704     {
2705         bytes4 proxyId = assetData.readBytes4(0);
2706 
2707         if (proxyId == ERC20_DATA_ID) {
2708             transferERC20Token(assetData, amount);
2709         } else if (proxyId == ERC721_DATA_ID) {
2710             transferERC721Token(assetData, amount);
2711         } else {
2712             revert("UNSUPPORTED_ASSET_PROXY");
2713         }
2714     }
2715 
2716     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2717     /// @param assetData Byte array encoded for the respective asset proxy.
2718     /// @param amount Amount of asset to transfer to sender.
2719     function transferERC20Token(
2720         bytes memory assetData,
2721         uint256 amount
2722     )
2723         internal
2724     {
2725         address token = assetData.readAddress(16);
2726 
2727         // Transfer tokens.
2728         // We do a raw call so we can check the success separate
2729         // from the return data.
2730         bool success = token.call(abi.encodeWithSelector(
2731             ERC20_TRANSFER_SELECTOR,
2732             msg.sender,
2733             amount
2734         ));
2735         require(
2736             success,
2737             "TRANSFER_FAILED"
2738         );
2739         
2740         // Check return data.
2741         // If there is no return data, we assume the token incorrectly
2742         // does not return a bool. In this case we expect it to revert
2743         // on failure, which was handled above.
2744         // If the token does return data, we require that it is a single
2745         // value that evaluates to true.
2746         assembly {
2747             if returndatasize {
2748                 success := 0
2749                 if eq(returndatasize, 32) {
2750                     // First 64 bytes of memory are reserved scratch space
2751                     returndatacopy(0, 0, 32)
2752                     success := mload(0)
2753                 }
2754             }
2755         }
2756         require(
2757             success,
2758             "TRANSFER_FAILED"
2759         );
2760     }
2761 
2762     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2763     /// @param assetData Byte array encoded for the respective asset proxy.
2764     /// @param amount Amount of asset to transfer to sender.
2765     function transferERC721Token(
2766         bytes memory assetData,
2767         uint256 amount
2768     )
2769         internal
2770     {
2771         require(
2772             amount == 1,
2773             "INVALID_AMOUNT"
2774         );
2775         // Decode asset data.
2776         address token = assetData.readAddress(16);
2777         uint256 tokenId = assetData.readUint256(36);
2778 
2779         // Perform transfer.
2780         IERC721Token(token).transferFrom(
2781             address(this),
2782             msg.sender,
2783             tokenId
2784         );
2785     }
2786 }
2787 
2788 /*
2789 
2790   Copyright 2018 ZeroEx Intl.
2791 
2792   Licensed under the Apache License, Version 2.0 (the "License");
2793   you may not use this file except in compliance with the License.
2794   You may obtain a copy of the License at
2795 
2796     http://www.apache.org/licenses/LICENSE-2.0
2797 
2798   Unless required by applicable law or agreed to in writing, software
2799   distributed under the License is distributed on an "AS IS" BASIS,
2800   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2801   See the License for the specific language governing permissions and
2802   limitations under the License.
2803 
2804 */
2805 
2806 pragma solidity 0.4.24;
2807 
2808 
2809 
2810 /*
2811 
2812   Copyright 2018 ZeroEx Intl.
2813 
2814   Licensed under the Apache License, Version 2.0 (the "License");
2815   you may not use this file except in compliance with the License.
2816   You may obtain a copy of the License at
2817 
2818     http://www.apache.org/licenses/LICENSE-2.0
2819 
2820   Unless required by applicable law or agreed to in writing, software
2821   distributed under the License is distributed on an "AS IS" BASIS,
2822   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2823   See the License for the specific language governing permissions and
2824   limitations under the License.
2825 
2826 */
2827 
2828 pragma solidity 0.4.24;
2829 
2830 
2831 
2832 
2833 contract LibAbiEncoder {
2834 
2835     /// @dev ABI encodes calldata for `fillOrder`.
2836     /// @param order Order struct containing order specifications.
2837     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2838     /// @param signature Proof that order has been created by maker.
2839     /// @return ABI encoded calldata for `fillOrder`.
2840     function abiEncodeFillOrder(
2841         LibOrder.Order memory order,
2842         uint256 takerAssetFillAmount,
2843         bytes memory signature
2844     )
2845         internal
2846         pure
2847         returns (bytes memory fillOrderCalldata)
2848     {
2849         // We need to call MExchangeCore.fillOrder using a delegatecall in
2850         // assembly so that we can intercept a call that throws. For this, we
2851         // need the input encoded in memory in the Ethereum ABIv2 format [1].
2852 
2853         // | Area     | Offset | Length  | Contents                                    |
2854         // | -------- |--------|---------|-------------------------------------------- |
2855         // | Header   | 0x00   | 4       | function selector                           |
2856         // | Params   |        | 3 * 32  | function parameters:                        |
2857         // |          | 0x00   |         |   1. offset to order (*)                    |
2858         // |          | 0x20   |         |   2. takerAssetFillAmount                   |
2859         // |          | 0x40   |         |   3. offset to signature (*)                |
2860         // | Data     |        | 12 * 32 | order:                                      |
2861         // |          | 0x000  |         |   1.  senderAddress                         |
2862         // |          | 0x020  |         |   2.  makerAddress                          |
2863         // |          | 0x040  |         |   3.  takerAddress                          |
2864         // |          | 0x060  |         |   4.  feeRecipientAddress                   |
2865         // |          | 0x080  |         |   5.  makerAssetAmount                      |
2866         // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
2867         // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
2868         // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
2869         // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
2870         // |          | 0x120  |         |   10. salt                                  |
2871         // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
2872         // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
2873         // |          | 0x180  | 32      | makerAssetData Length                       |
2874         // |          | 0x1A0  | **      | makerAssetData Contents                     |
2875         // |          | 0x1C0  | 32      | takerAssetData Length                       |
2876         // |          | 0x1E0  | **      | takerAssetData Contents                     |
2877         // |          | 0x200  | 32      | signature Length                            |
2878         // |          | 0x220  | **      | signature Contents                          |
2879 
2880         // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
2881         //     An offset stored in the Params area is calculated from the beginning of the Params section.
2882         //     An offset stored in the Data area is calculated from the beginning of the Data section.
2883 
2884         // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.
2885 
2886         // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html
2887 
2888         assembly {
2889 
2890             // Areas below may use the following variables:
2891             //   1. <area>Start   -- Start of this area in memory
2892             //   2. <area>End     -- End of this area in memory. This value may
2893             //                       be precomputed (before writing contents),
2894             //                       or it may be computed as contents are written.
2895             //   3. <area>Offset  -- Current offset into area. If an area's End
2896             //                       is precomputed, this variable tracks the
2897             //                       offsets of contents as they are written.
2898 
2899             /////// Setup Header Area ///////
2900             // Load free memory pointer
2901             fillOrderCalldata := mload(0x40)
2902             // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
2903             // = 0xb4be83d5
2904             // Leave 0x20 bytes to store the length
2905             mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
2906             let headerAreaEnd := add(fillOrderCalldata, 0x24)
2907 
2908             /////// Setup Params Area ///////
2909             // This area is preallocated and written to later.
2910             // This is because we need to fill in offsets that have not yet been calculated.
2911             let paramsAreaStart := headerAreaEnd
2912             let paramsAreaEnd := add(paramsAreaStart, 0x60)
2913             let paramsAreaOffset := paramsAreaStart
2914 
2915             /////// Setup Data Area ///////
2916             let dataAreaStart := paramsAreaEnd
2917             let dataAreaEnd := dataAreaStart
2918 
2919             // Offset from the source data we're reading from
2920             let sourceOffset := order
2921             // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
2922             let arrayLenBytes := 0
2923             let arrayLenWords := 0
2924 
2925             /////// Write order Struct ///////
2926             // Write memory location of Order, relative to the start of the
2927             // parameter list, then increment the paramsAreaOffset respectively.
2928             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2929             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2930 
2931             // Write values for each field in the order
2932             // It would be nice to use a loop, but we save on gas by writing
2933             // the stores sequentially.
2934             mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
2935             mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
2936             mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
2937             mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
2938             mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
2939             mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
2940             mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
2941             mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
2942             mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
2943             mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
2944             mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
2945             mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
2946             dataAreaEnd := add(dataAreaEnd, 0x180)
2947             sourceOffset := add(sourceOffset, 0x180)
2948 
2949             // Write offset to <order.makerAssetData>
2950             mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))
2951 
2952             // Calculate length of <order.makerAssetData>
2953             sourceOffset := mload(add(order, 0x140)) // makerAssetData
2954             arrayLenBytes := mload(sourceOffset)
2955             sourceOffset := add(sourceOffset, 0x20)
2956             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2957 
2958             // Write length of <order.makerAssetData>
2959             mstore(dataAreaEnd, arrayLenBytes)
2960             dataAreaEnd := add(dataAreaEnd, 0x20)
2961 
2962             // Write contents of <order.makerAssetData>
2963             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2964                 mstore(dataAreaEnd, mload(sourceOffset))
2965                 dataAreaEnd := add(dataAreaEnd, 0x20)
2966                 sourceOffset := add(sourceOffset, 0x20)
2967             }
2968 
2969             // Write offset to <order.takerAssetData>
2970             mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))
2971 
2972             // Calculate length of <order.takerAssetData>
2973             sourceOffset := mload(add(order, 0x160)) // takerAssetData
2974             arrayLenBytes := mload(sourceOffset)
2975             sourceOffset := add(sourceOffset, 0x20)
2976             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2977 
2978             // Write length of <order.takerAssetData>
2979             mstore(dataAreaEnd, arrayLenBytes)
2980             dataAreaEnd := add(dataAreaEnd, 0x20)
2981 
2982             // Write contents of  <order.takerAssetData>
2983             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2984                 mstore(dataAreaEnd, mload(sourceOffset))
2985                 dataAreaEnd := add(dataAreaEnd, 0x20)
2986                 sourceOffset := add(sourceOffset, 0x20)
2987             }
2988 
2989             /////// Write takerAssetFillAmount ///////
2990             mstore(paramsAreaOffset, takerAssetFillAmount)
2991             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2992 
2993             /////// Write signature ///////
2994             // Write offset to paramsArea
2995             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2996 
2997             // Calculate length of signature
2998             sourceOffset := signature
2999             arrayLenBytes := mload(sourceOffset)
3000             sourceOffset := add(sourceOffset, 0x20)
3001             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
3002 
3003             // Write length of signature
3004             mstore(dataAreaEnd, arrayLenBytes)
3005             dataAreaEnd := add(dataAreaEnd, 0x20)
3006 
3007             // Write contents of signature
3008             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
3009                 mstore(dataAreaEnd, mload(sourceOffset))
3010                 dataAreaEnd := add(dataAreaEnd, 0x20)
3011                 sourceOffset := add(sourceOffset, 0x20)
3012             }
3013 
3014             // Set length of calldata
3015             mstore(fillOrderCalldata, sub(dataAreaEnd, add(fillOrderCalldata, 0x20)))
3016 
3017             // Increment free memory pointer
3018             mstore(0x40, dataAreaEnd)
3019         }
3020 
3021         return fillOrderCalldata;
3022     }
3023 }
3024 
3025 
3026 
3027 
3028 
3029 
3030 contract MixinExchangeWrapper is
3031     LibAbiEncoder,
3032     LibFillResults,
3033     LibMath,
3034     LibConstants,
3035     MExchangeWrapper
3036 {
3037     /// @dev Fills the input order.
3038     ///      Returns false if the transaction would otherwise revert.
3039     /// @param order Order struct containing order specifications.
3040     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
3041     /// @param signature Proof that order has been created by maker.
3042     /// @return Amounts filled and fees paid by maker and taker.
3043     function fillOrderNoThrow(
3044         LibOrder.Order memory order,
3045         uint256 takerAssetFillAmount,
3046         bytes memory signature
3047     )
3048         internal
3049         returns (FillResults memory fillResults)
3050     {
3051         // ABI encode calldata for `fillOrder`
3052         bytes memory fillOrderCalldata = abiEncodeFillOrder(
3053             order,
3054             takerAssetFillAmount,
3055             signature
3056         );
3057 
3058         address exchange = address(EXCHANGE);
3059 
3060         // Call `fillOrder` and handle any exceptions gracefully
3061         assembly {
3062             let success := call(
3063                 gas,                                // forward all gas
3064                 exchange,                           // call address of Exchange contract
3065                 0,                                  // transfer 0 wei
3066                 add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
3067                 mload(fillOrderCalldata),           // length of input
3068                 fillOrderCalldata,                  // write output over input
3069                 128                                 // output size is 128 bytes
3070             )
3071             if success {
3072                 mstore(fillResults, mload(fillOrderCalldata))
3073                 mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
3074                 mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
3075                 mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
3076             }
3077         }
3078         // fillResults values will be 0 by default if call was unsuccessful
3079         return fillResults;
3080     }
3081 
3082     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
3083     ///      Returns false if the transaction would otherwise revert.
3084     /// @param orders Array of order specifications.
3085     /// @param wethSellAmount Desired amount of WETH to sell.
3086     /// @param signatures Proofs that orders have been signed by makers.
3087     /// @return Amounts filled and fees paid by makers and taker.
3088     function marketSellWeth(
3089         LibOrder.Order[] memory orders,
3090         uint256 wethSellAmount,
3091         bytes[] memory signatures
3092     )
3093         internal
3094         returns (FillResults memory totalFillResults)
3095     {
3096         bytes memory makerAssetData = orders[0].makerAssetData;
3097         bytes memory wethAssetData = WETH_ASSET_DATA;
3098 
3099         uint256 ordersLength = orders.length;
3100         for (uint256 i = 0; i != ordersLength; i++) {
3101 
3102             // We assume that asset being bought by taker is the same for each order.
3103             // We assume that asset being sold by taker is WETH for each order.
3104             orders[i].makerAssetData = makerAssetData;
3105             orders[i].takerAssetData = wethAssetData;
3106 
3107             // Calculate the remaining amount of WETH to sell
3108             uint256 remainingTakerAssetFillAmount = safeSub(wethSellAmount, totalFillResults.takerAssetFilledAmount);
3109 
3110             // Attempt to sell the remaining amount of WETH
3111             FillResults memory singleFillResults = fillOrderNoThrow(
3112                 orders[i],
3113                 remainingTakerAssetFillAmount,
3114                 signatures[i]
3115             );
3116 
3117             // Update amounts filled and fees paid by maker and taker
3118             addFillResults(totalFillResults, singleFillResults);
3119 
3120             // Stop execution if the entire amount of takerAsset has been sold
3121             if (totalFillResults.takerAssetFilledAmount >= wethSellAmount) {
3122                 break;
3123             }
3124         }
3125         return totalFillResults;
3126     }
3127 
3128     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
3129     ///      Returns false if the transaction would otherwise revert.
3130     ///      The asset being sold by taker must always be WETH.
3131     /// @param orders Array of order specifications.
3132     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3133     /// @param signatures Proofs that orders have been signed by makers.
3134     /// @return Amounts filled and fees paid by makers and taker.
3135     function marketBuyExactAmountWithWeth(
3136         LibOrder.Order[] memory orders,
3137         uint256 makerAssetFillAmount,
3138         bytes[] memory signatures
3139     )
3140         internal
3141         returns (FillResults memory totalFillResults)
3142     {
3143         bytes memory makerAssetData = orders[0].makerAssetData;
3144         bytes memory wethAssetData = WETH_ASSET_DATA;
3145 
3146         uint256 ordersLength = orders.length;
3147         for (uint256 i = 0; i != ordersLength; i++) {
3148 
3149             // We assume that asset being bought by taker is the same for each order.
3150             // We assume that asset being sold by taker is WETH for each order.
3151             orders[i].makerAssetData = makerAssetData;
3152             orders[i].takerAssetData = wethAssetData;
3153 
3154             // Calculate the remaining amount of makerAsset to buy
3155             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3156 
3157             // Convert the remaining amount of makerAsset to buy into remaining amount
3158             // of takerAsset to sell, assuming entire amount can be sold in the current order
3159             uint256 remainingTakerAssetFillAmount = getPartialAmountFloor(
3160                 orders[i].takerAssetAmount,
3161                 orders[i].makerAssetAmount,
3162                 remainingMakerAssetFillAmount
3163             );
3164 
3165             // Attempt to sell the remaining amount of takerAsset
3166             FillResults memory singleFillResults = fillOrderNoThrow(
3167                 orders[i],
3168                 remainingTakerAssetFillAmount,
3169                 signatures[i]
3170             );
3171 
3172             // Update amounts filled and fees paid by maker and taker
3173             addFillResults(totalFillResults, singleFillResults);
3174 
3175             // Stop execution if the entire amount of makerAsset has been bought
3176             uint256 makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount;
3177             if (makerAssetFilledAmount >= makerAssetFillAmount) {
3178                 break;
3179             }
3180         }
3181 
3182         require(
3183             makerAssetFilledAmount >= makerAssetFillAmount,
3184             "COMPLETE_FILL_FAILED"
3185         );
3186         return totalFillResults;
3187     }
3188 
3189     /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
3190     ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
3191     ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
3192     ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
3193     ///      The asset being sold by taker must always be WETH. 
3194     /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
3195     /// @param zrxBuyAmount Desired amount of ZRX to buy.
3196     /// @param signatures Proofs that orders have been created by makers.
3197     /// @return totalFillResults Amounts filled and fees paid by maker and taker.
3198     function marketBuyExactZrxWithWeth(
3199         LibOrder.Order[] memory orders,
3200         uint256 zrxBuyAmount,
3201         bytes[] memory signatures
3202     )
3203         internal
3204         returns (FillResults memory totalFillResults)
3205     {
3206         // Do nothing if zrxBuyAmount == 0
3207         if (zrxBuyAmount == 0) {
3208             return totalFillResults;
3209         }
3210 
3211         bytes memory zrxAssetData = ZRX_ASSET_DATA;
3212         bytes memory wethAssetData = WETH_ASSET_DATA;
3213         uint256 zrxPurchased = 0;
3214 
3215         uint256 ordersLength = orders.length;
3216         for (uint256 i = 0; i != ordersLength; i++) {
3217 
3218             // All of these are ZRX/WETH, so we can drop the respective assetData from calldata.
3219             orders[i].makerAssetData = zrxAssetData;
3220             orders[i].takerAssetData = wethAssetData;
3221 
3222             // Calculate the remaining amount of ZRX to buy.
3223             uint256 remainingZrxBuyAmount = safeSub(zrxBuyAmount, zrxPurchased);
3224 
3225             // Convert the remaining amount of ZRX to buy into remaining amount
3226             // of WETH to sell, assuming entire amount can be sold in the current order.
3227             uint256 remainingWethSellAmount = getPartialAmountFloor(
3228                 orders[i].takerAssetAmount,
3229                 safeSub(orders[i].makerAssetAmount, orders[i].takerFee),  // our exchange rate after fees 
3230                 remainingZrxBuyAmount
3231             );
3232 
3233             // Attempt to sell the remaining amount of WETH.
3234             FillResults memory singleFillResult = fillOrderNoThrow(
3235                 orders[i],
3236                 safeAdd(remainingWethSellAmount, 1),  // we add 1 wei to the fill amount to make up for rounding errors
3237                 signatures[i]
3238             );
3239 
3240             // Update amounts filled and fees paid by maker and taker.
3241             addFillResults(totalFillResults, singleFillResult);
3242             zrxPurchased = safeSub(totalFillResults.makerAssetFilledAmount, totalFillResults.takerFeePaid);
3243 
3244             // Stop execution if the entire amount of ZRX has been bought.
3245             if (zrxPurchased >= zrxBuyAmount) {
3246                 break;
3247             }
3248         }
3249 
3250         require(
3251             zrxPurchased >= zrxBuyAmount,
3252             "COMPLETE_FILL_FAILED"
3253         );
3254         return totalFillResults;
3255     }
3256 }
3257 
3258 
3259 
3260 // solhint-disable no-empty-blocks
3261 contract Forwarder is
3262     LibConstants,
3263     MixinWeth,
3264     MixinAssets,
3265     MixinExchangeWrapper,
3266     MixinForwarderCore
3267 {
3268     constructor (
3269         address _exchange,
3270         bytes memory _zrxAssetData,
3271         bytes memory _wethAssetData
3272     )
3273         public
3274         LibConstants(
3275             _exchange,
3276             _zrxAssetData,
3277             _wethAssetData
3278         )
3279         MixinForwarderCore()
3280     {}
3281 }