1 pragma solidity 0.4.24;
2 pragma experimental ABIEncoderV2;
3 
4 contract IERC20Token {
5 
6     // solhint-disable no-simple-event-func-name
7     event Transfer(
8         address indexed _from,
9         address indexed _to,
10         uint256 _value
11     );
12 
13     event Approval(
14         address indexed _owner,
15         address indexed _spender,
16         uint256 _value
17     );
18 
19     /// @dev send `value` token to `to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return True if transfer was successful
23     function transfer(address _to, uint256 _value)
24         external
25         returns (bool);
26 
27     /// @dev send `value` token to `to` from `from` on the condition it is approved by `from`
28     /// @param _from The address of the sender
29     /// @param _to The address of the recipient
30     /// @param _value The amount of token to be transferred
31     /// @return True if transfer was successful
32     function transferFrom(
33         address _from,
34         address _to,
35         uint256 _value
36     )
37         external
38         returns (bool);
39 
40     /// @dev `msg.sender` approves `_spender` to spend `_value` tokens
41     /// @param _spender The address of the account able to transfer the tokens
42     /// @param _value The amount of wei to be approved for transfer
43     /// @return Always true if the call has enough gas to complete execution
44     function approve(address _spender, uint256 _value)
45         external
46         returns (bool);
47 
48     /// @dev Query total supply of token
49     /// @return Total supply of token
50     function totalSupply()
51         external
52         view
53         returns (uint256);
54 
55     /// @param _owner The address from which the balance will be retrieved
56     /// @return Balance of owner
57     function balanceOf(address _owner)
58         external
59         view
60         returns (uint256);
61 
62     /// @param _owner The address of the account owning tokens
63     /// @param _spender The address of the account able to transfer the tokens
64     /// @return Amount of remaining tokens allowed to spent
65     function allowance(address _owner, address _spender)
66         external
67         view
68         returns (uint256);
69 }
70 
71 
72 contract SafeMath {
73 
74     function safeMul(uint256 a, uint256 b)
75         internal
76         pure
77         returns (uint256)
78     {
79         if (a == 0) {
80             return 0;
81         }
82         uint256 c = a * b;
83         require(
84             c / a == b,
85             "UINT256_OVERFLOW"
86         );
87         return c;
88     }
89 
90     function safeDiv(uint256 a, uint256 b)
91         internal
92         pure
93         returns (uint256)
94     {
95         uint256 c = a / b;
96         return c;
97     }
98 
99     function safeSub(uint256 a, uint256 b)
100         internal
101         pure
102         returns (uint256)
103     {
104         require(
105             b <= a,
106             "UINT256_UNDERFLOW"
107         );
108         return a - b;
109     }
110 
111     function safeAdd(uint256 a, uint256 b)
112         internal
113         pure
114         returns (uint256)
115     {
116         uint256 c = a + b;
117         require(
118             c >= a,
119             "UINT256_OVERFLOW"
120         );
121         return c;
122     }
123 
124     function max64(uint64 a, uint64 b)
125         internal
126         pure
127         returns (uint256)
128     {
129         return a >= b ? a : b;
130     }
131 
132     function min64(uint64 a, uint64 b)
133         internal
134         pure
135         returns (uint256)
136     {
137         return a < b ? a : b;
138     }
139 
140     function max256(uint256 a, uint256 b)
141         internal
142         pure
143         returns (uint256)
144     {
145         return a >= b ? a : b;
146     }
147 
148     function min256(uint256 a, uint256 b)
149         internal
150         pure
151         returns (uint256)
152     {
153         return a < b ? a : b;
154     }
155 }
156 
157 /*
158 
159   Copyright 2018 ZeroEx Intl.
160 
161   Licensed under the Apache License, Version 2.0 (the "License");
162   you may not use this file except in compliance with the License.
163   You may obtain a copy of the License at
164 
165     http://www.apache.org/licenses/LICENSE-2.0
166 
167   Unless required by applicable law or agreed to in writing, software
168   distributed under the License is distributed on an "AS IS" BASIS,
169   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
170   See the License for the specific language governing permissions and
171   limitations under the License.
172 
173 */
174 
175 
176 contract LibMath is
177     SafeMath
178 {
179     /// @dev Calculates partial value given a numerator and denominator rounded down.
180     ///      Reverts if rounding error is >= 0.1%
181     /// @param numerator Numerator.
182     /// @param denominator Denominator.
183     /// @param target Value to calculate partial of.
184     /// @return Partial value of target rounded down.
185     function safeGetPartialAmountFloor(
186         uint256 numerator,
187         uint256 denominator,
188         uint256 target
189     )
190         internal
191         pure
192         returns (uint256 partialAmount)
193     {
194         require(
195             denominator > 0,
196             "DIVISION_BY_ZERO"
197         );
198 
199         require(
200             !isRoundingErrorFloor(
201                 numerator,
202                 denominator,
203                 target
204             ),
205             "ROUNDING_ERROR"
206         );
207 
208         partialAmount = safeDiv(
209             safeMul(numerator, target),
210             denominator
211         );
212         return partialAmount;
213     }
214 
215     /// @dev Calculates partial value given a numerator and denominator rounded down.
216     ///      Reverts if rounding error is >= 0.1%
217     /// @param numerator Numerator.
218     /// @param denominator Denominator.
219     /// @param target Value to calculate partial of.
220     /// @return Partial value of target rounded up.
221     function safeGetPartialAmountCeil(
222         uint256 numerator,
223         uint256 denominator,
224         uint256 target
225     )
226         internal
227         pure
228         returns (uint256 partialAmount)
229     {
230         require(
231             denominator > 0,
232             "DIVISION_BY_ZERO"
233         );
234 
235         require(
236             !isRoundingErrorCeil(
237                 numerator,
238                 denominator,
239                 target
240             ),
241             "ROUNDING_ERROR"
242         );
243 
244         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
245         //       ceil(a / b) = floor((a + b - 1) / b)
246         // To implement `ceil(a / b)` using safeDiv.
247         partialAmount = safeDiv(
248             safeAdd(
249                 safeMul(numerator, target),
250                 safeSub(denominator, 1)
251             ),
252             denominator
253         );
254         return partialAmount;
255     }
256 
257     /// @dev Calculates partial value given a numerator and denominator rounded down.
258     /// @param numerator Numerator.
259     /// @param denominator Denominator.
260     /// @param target Value to calculate partial of.
261     /// @return Partial value of target rounded down.
262     function getPartialAmountFloor(
263         uint256 numerator,
264         uint256 denominator,
265         uint256 target
266     )
267         internal
268         pure
269         returns (uint256 partialAmount)
270     {
271         require(
272             denominator > 0,
273             "DIVISION_BY_ZERO"
274         );
275 
276         partialAmount = safeDiv(
277             safeMul(numerator, target),
278             denominator
279         );
280         return partialAmount;
281     }
282 
283     /// @dev Calculates partial value given a numerator and denominator rounded down.
284     /// @param numerator Numerator.
285     /// @param denominator Denominator.
286     /// @param target Value to calculate partial of.
287     /// @return Partial value of target rounded up.
288     function getPartialAmountCeil(
289         uint256 numerator,
290         uint256 denominator,
291         uint256 target
292     )
293         internal
294         pure
295         returns (uint256 partialAmount)
296     {
297         require(
298             denominator > 0,
299             "DIVISION_BY_ZERO"
300         );
301 
302         // safeDiv computes `floor(a / b)`. We use the identity (a, b integer):
303         //       ceil(a / b) = floor((a + b - 1) / b)
304         // To implement `ceil(a / b)` using safeDiv.
305         partialAmount = safeDiv(
306             safeAdd(
307                 safeMul(numerator, target),
308                 safeSub(denominator, 1)
309             ),
310             denominator
311         );
312         return partialAmount;
313     }
314 
315     /// @dev Checks if rounding error >= 0.1% when rounding down.
316     /// @param numerator Numerator.
317     /// @param denominator Denominator.
318     /// @param target Value to multiply with numerator/denominator.
319     /// @return Rounding error is present.
320     function isRoundingErrorFloor(
321         uint256 numerator,
322         uint256 denominator,
323         uint256 target
324     )
325         internal
326         pure
327         returns (bool isError)
328     {
329         require(
330             denominator > 0,
331             "DIVISION_BY_ZERO"
332         );
333 
334         // The absolute rounding error is the difference between the rounded
335         // value and the ideal value. The relative rounding error is the
336         // absolute rounding error divided by the absolute value of the
337         // ideal value. This is undefined when the ideal value is zero.
338         //
339         // The ideal value is `numerator * target / denominator`.
340         // Let's call `numerator * target % denominator` the remainder.
341         // The absolute error is `remainder / denominator`.
342         //
343         // When the ideal value is zero, we require the absolute error to
344         // be zero. Fortunately, this is always the case. The ideal value is
345         // zero iff `numerator == 0` and/or `target == 0`. In this case the
346         // remainder and absolute error are also zero.
347         if (target == 0 || numerator == 0) {
348             return false;
349         }
350 
351         // Otherwise, we want the relative rounding error to be strictly
352         // less than 0.1%.
353         // The relative error is `remainder / (numerator * target)`.
354         // We want the relative error less than 1 / 1000:
355         //        remainder / (numerator * denominator)  <  1 / 1000
356         // or equivalently:
357         //        1000 * remainder  <  numerator * target
358         // so we have a rounding error iff:
359         //        1000 * remainder  >=  numerator * target
360         uint256 remainder = mulmod(
361             target,
362             numerator,
363             denominator
364         );
365         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
366         return isError;
367     }
368 
369     /// @dev Checks if rounding error >= 0.1% when rounding up.
370     /// @param numerator Numerator.
371     /// @param denominator Denominator.
372     /// @param target Value to multiply with numerator/denominator.
373     /// @return Rounding error is present.
374     function isRoundingErrorCeil(
375         uint256 numerator,
376         uint256 denominator,
377         uint256 target
378     )
379         internal
380         pure
381         returns (bool isError)
382     {
383         require(
384             denominator > 0,
385             "DIVISION_BY_ZERO"
386         );
387 
388         // See the comments in `isRoundingError`.
389         if (target == 0 || numerator == 0) {
390             // When either is zero, the ideal value and rounded value are zero
391             // and there is no rounding error. (Although the relative error
392             // is undefined.)
393             return false;
394         }
395         // Compute remainder as before
396         uint256 remainder = mulmod(
397             target,
398             numerator,
399             denominator
400         );
401         remainder = safeSub(denominator, remainder) % denominator;
402         isError = safeMul(1000, remainder) >= safeMul(numerator, target);
403         return isError;
404     }
405 }
406 
407 /*
408 
409   Copyright 2018 ZeroEx Intl.
410 
411   Licensed under the Apache License, Version 2.0 (the "License");
412   you may not use this file except in compliance with the License.
413   You may obtain a copy of the License at
414 
415     http://www.apache.org/licenses/LICENSE-2.0
416 
417   Unless required by applicable law or agreed to in writing, software
418   distributed under the License is distributed on an "AS IS" BASIS,
419   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
420   See the License for the specific language governing permissions and
421   limitations under the License.
422 
423 */
424 
425 
426 
427 library LibBytes {
428 
429     using LibBytes for bytes;
430 
431     /// @dev Gets the memory address for a byte array.
432     /// @param input Byte array to lookup.
433     /// @return memoryAddress Memory address of byte array. This
434     ///         points to the header of the byte array which contains
435     ///         the length.
436     function rawAddress(bytes memory input)
437         internal
438         pure
439         returns (uint256 memoryAddress)
440     {
441         assembly {
442             memoryAddress := input
443         }
444         return memoryAddress;
445     }
446 
447     /// @dev Gets the memory address for the contents of a byte array.
448     /// @param input Byte array to lookup.
449     /// @return memoryAddress Memory address of the contents of the byte array.
450     function contentAddress(bytes memory input)
451         internal
452         pure
453         returns (uint256 memoryAddress)
454     {
455         assembly {
456             memoryAddress := add(input, 32)
457         }
458         return memoryAddress;
459     }
460 
461     /// @dev Copies `length` bytes from memory location `source` to `dest`.
462     /// @param dest memory address to copy bytes to.
463     /// @param source memory address to copy bytes from.
464     /// @param length number of bytes to copy.
465     function memCopy(
466         uint256 dest,
467         uint256 source,
468         uint256 length
469     )
470         internal
471         pure
472     {
473         if (length < 32) {
474             // Handle a partial word by reading destination and masking
475             // off the bits we are interested in.
476             // This correctly handles overlap, zero lengths and source == dest
477             assembly {
478                 let mask := sub(exp(256, sub(32, length)), 1)
479                 let s := and(mload(source), not(mask))
480                 let d := and(mload(dest), mask)
481                 mstore(dest, or(s, d))
482             }
483         } else {
484             // Skip the O(length) loop when source == dest.
485             if (source == dest) {
486                 return;
487             }
488 
489             // For large copies we copy whole words at a time. The final
490             // word is aligned to the end of the range (instead of after the
491             // previous) to handle partial words. So a copy will look like this:
492             //
493             //  ####
494             //      ####
495             //          ####
496             //            ####
497             //
498             // We handle overlap in the source and destination range by
499             // changing the copying direction. This prevents us from
500             // overwriting parts of source that we still need to copy.
501             //
502             // This correctly handles source == dest
503             //
504             if (source > dest) {
505                 assembly {
506                     // We subtract 32 from `sEnd` and `dEnd` because it
507                     // is easier to compare with in the loop, and these
508                     // are also the addresses we need for copying the
509                     // last bytes.
510                     length := sub(length, 32)
511                     let sEnd := add(source, length)
512                     let dEnd := add(dest, length)
513 
514                     // Remember the last 32 bytes of source
515                     // This needs to be done here and not after the loop
516                     // because we may have overwritten the last bytes in
517                     // source already due to overlap.
518                     let last := mload(sEnd)
519 
520                     // Copy whole words front to back
521                     // Note: the first check is always true,
522                     // this could have been a do-while loop.
523                     // solhint-disable-next-line no-empty-blocks
524                     for {} lt(source, sEnd) {} {
525                         mstore(dest, mload(source))
526                         source := add(source, 32)
527                         dest := add(dest, 32)
528                     }
529 
530                     // Write the last 32 bytes
531                     mstore(dEnd, last)
532                 }
533             } else {
534                 assembly {
535                     // We subtract 32 from `sEnd` and `dEnd` because those
536                     // are the starting points when copying a word at the end.
537                     length := sub(length, 32)
538                     let sEnd := add(source, length)
539                     let dEnd := add(dest, length)
540 
541                     // Remember the first 32 bytes of source
542                     // This needs to be done here and not after the loop
543                     // because we may have overwritten the first bytes in
544                     // source already due to overlap.
545                     let first := mload(source)
546 
547                     // Copy whole words back to front
548                     // We use a signed comparisson here to allow dEnd to become
549                     // negative (happens when source and dest < 32). Valid
550                     // addresses in local memory will never be larger than
551                     // 2**255, so they can be safely re-interpreted as signed.
552                     // Note: the first check is always true,
553                     // this could have been a do-while loop.
554                     // solhint-disable-next-line no-empty-blocks
555                     for {} slt(dest, dEnd) {} {
556                         mstore(dEnd, mload(sEnd))
557                         sEnd := sub(sEnd, 32)
558                         dEnd := sub(dEnd, 32)
559                     }
560 
561                     // Write the first 32 bytes
562                     mstore(dest, first)
563                 }
564             }
565         }
566     }
567 
568     /// @dev Returns a slices from a byte array.
569     /// @param b The byte array to take a slice from.
570     /// @param from The starting index for the slice (inclusive).
571     /// @param to The final index for the slice (exclusive).
572     /// @return result The slice containing bytes at indices [from, to)
573     function slice(
574         bytes memory b,
575         uint256 from,
576         uint256 to
577     )
578         internal
579         pure
580         returns (bytes memory result)
581     {
582         require(
583             from <= to,
584             "FROM_LESS_THAN_TO_REQUIRED"
585         );
586         require(
587             to < b.length,
588             "TO_LESS_THAN_LENGTH_REQUIRED"
589         );
590 
591         // Create a new bytes structure and copy contents
592         result = new bytes(to - from);
593         memCopy(
594             result.contentAddress(),
595             b.contentAddress() + from,
596             result.length
597         );
598         return result;
599     }
600 
601     /// @dev Returns a slice from a byte array without preserving the input.
602     /// @param b The byte array to take a slice from. Will be destroyed in the process.
603     /// @param from The starting index for the slice (inclusive).
604     /// @param to The final index for the slice (exclusive).
605     /// @return result The slice containing bytes at indices [from, to)
606     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
607     function sliceDestructive(
608         bytes memory b,
609         uint256 from,
610         uint256 to
611     )
612         internal
613         pure
614         returns (bytes memory result)
615     {
616         require(
617             from <= to,
618             "FROM_LESS_THAN_TO_REQUIRED"
619         );
620         require(
621             to < b.length,
622             "TO_LESS_THAN_LENGTH_REQUIRED"
623         );
624 
625         // Create a new bytes structure around [from, to) in-place.
626         assembly {
627             result := add(b, from)
628             mstore(result, sub(to, from))
629         }
630         return result;
631     }
632 
633     /// @dev Pops the last byte off of a byte array by modifying its length.
634     /// @param b Byte array that will be modified.
635     /// @return The byte that was popped off.
636     function popLastByte(bytes memory b)
637         internal
638         pure
639         returns (bytes1 result)
640     {
641         require(
642             b.length > 0,
643             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
644         );
645 
646         // Store last byte.
647         result = b[b.length - 1];
648 
649         assembly {
650             // Decrement length of byte array.
651             let newLen := sub(mload(b), 1)
652             mstore(b, newLen)
653         }
654         return result;
655     }
656 
657     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
658     /// @param b Byte array that will be modified.
659     /// @return The 20 byte address that was popped off.
660     function popLast20Bytes(bytes memory b)
661         internal
662         pure
663         returns (address result)
664     {
665         require(
666             b.length >= 20,
667             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
668         );
669 
670         // Store last 20 bytes.
671         result = readAddress(b, b.length - 20);
672 
673         assembly {
674             // Subtract 20 from byte array length.
675             let newLen := sub(mload(b), 20)
676             mstore(b, newLen)
677         }
678         return result;
679     }
680 
681     /// @dev Tests equality of two byte arrays.
682     /// @param lhs First byte array to compare.
683     /// @param rhs Second byte array to compare.
684     /// @return True if arrays are the same. False otherwise.
685     function equals(
686         bytes memory lhs,
687         bytes memory rhs
688     )
689         internal
690         pure
691         returns (bool equal)
692     {
693         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
694         // We early exit on unequal lengths, but keccak would also correctly
695         // handle this.
696         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
697     }
698 
699     /// @dev Reads an address from a position in a byte array.
700     /// @param b Byte array containing an address.
701     /// @param index Index in byte array of address.
702     /// @return address from byte array.
703     function readAddress(
704         bytes memory b,
705         uint256 index
706     )
707         internal
708         pure
709         returns (address result)
710     {
711         require(
712             b.length >= index + 20,  // 20 is length of address
713             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
714         );
715 
716         // Add offset to index:
717         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
718         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
719         index += 20;
720 
721         // Read address from array memory
722         assembly {
723             // 1. Add index to address of bytes array
724             // 2. Load 32-byte word from memory
725             // 3. Apply 20-byte mask to obtain address
726             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
727         }
728         return result;
729     }
730 
731     /// @dev Writes an address into a specific position in a byte array.
732     /// @param b Byte array to insert address into.
733     /// @param index Index in byte array of address.
734     /// @param input Address to put into byte array.
735     function writeAddress(
736         bytes memory b,
737         uint256 index,
738         address input
739     )
740         internal
741         pure
742     {
743         require(
744             b.length >= index + 20,  // 20 is length of address
745             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
746         );
747 
748         // Add offset to index:
749         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
750         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
751         index += 20;
752 
753         // Store address into array memory
754         assembly {
755             // The address occupies 20 bytes and mstore stores 32 bytes.
756             // First fetch the 32-byte word where we'll be storing the address, then
757             // apply a mask so we have only the bytes in the word that the address will not occupy.
758             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
759 
760             // 1. Add index to address of bytes array
761             // 2. Load 32-byte word from memory
762             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
763             let neighbors := and(
764                 mload(add(b, index)),
765                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
766             )
767 
768             // Make sure input address is clean.
769             // (Solidity does not guarantee this)
770             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
771 
772             // Store the neighbors and address into memory
773             mstore(add(b, index), xor(input, neighbors))
774         }
775     }
776 
777     /// @dev Reads a bytes32 value from a position in a byte array.
778     /// @param b Byte array containing a bytes32 value.
779     /// @param index Index in byte array of bytes32 value.
780     /// @return bytes32 value from byte array.
781     function readBytes32(
782         bytes memory b,
783         uint256 index
784     )
785         internal
786         pure
787         returns (bytes32 result)
788     {
789         require(
790             b.length >= index + 32,
791             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
792         );
793 
794         // Arrays are prefixed by a 256 bit length parameter
795         index += 32;
796 
797         // Read the bytes32 from array memory
798         assembly {
799             result := mload(add(b, index))
800         }
801         return result;
802     }
803 
804     /// @dev Writes a bytes32 into a specific position in a byte array.
805     /// @param b Byte array to insert <input> into.
806     /// @param index Index in byte array of <input>.
807     /// @param input bytes32 to put into byte array.
808     function writeBytes32(
809         bytes memory b,
810         uint256 index,
811         bytes32 input
812     )
813         internal
814         pure
815     {
816         require(
817             b.length >= index + 32,
818             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
819         );
820 
821         // Arrays are prefixed by a 256 bit length parameter
822         index += 32;
823 
824         // Read the bytes32 from array memory
825         assembly {
826             mstore(add(b, index), input)
827         }
828     }
829 
830     /// @dev Reads a uint256 value from a position in a byte array.
831     /// @param b Byte array containing a uint256 value.
832     /// @param index Index in byte array of uint256 value.
833     /// @return uint256 value from byte array.
834     function readUint256(
835         bytes memory b,
836         uint256 index
837     )
838         internal
839         pure
840         returns (uint256 result)
841     {
842         result = uint256(readBytes32(b, index));
843         return result;
844     }
845 
846     /// @dev Writes a uint256 into a specific position in a byte array.
847     /// @param b Byte array to insert <input> into.
848     /// @param index Index in byte array of <input>.
849     /// @param input uint256 to put into byte array.
850     function writeUint256(
851         bytes memory b,
852         uint256 index,
853         uint256 input
854     )
855         internal
856         pure
857     {
858         writeBytes32(b, index, bytes32(input));
859     }
860 
861     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
862     /// @param b Byte array containing a bytes4 value.
863     /// @param index Index in byte array of bytes4 value.
864     /// @return bytes4 value from byte array.
865     function readBytes4(
866         bytes memory b,
867         uint256 index
868     )
869         internal
870         pure
871         returns (bytes4 result)
872     {
873         require(
874             b.length >= index + 4,
875             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
876         );
877 
878         // Arrays are prefixed by a 32 byte length field
879         index += 32;
880 
881         // Read the bytes4 from array memory
882         assembly {
883             result := mload(add(b, index))
884             // Solidity does not require us to clean the trailing bytes.
885             // We do it anyway
886             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
887         }
888         return result;
889     }
890 
891     /// @dev Reads nested bytes from a specific position.
892     /// @dev NOTE: the returned value overlaps with the input value.
893     ///            Both should be treated as immutable.
894     /// @param b Byte array containing nested bytes.
895     /// @param index Index of nested bytes.
896     /// @return result Nested bytes.
897     function readBytesWithLength(
898         bytes memory b,
899         uint256 index
900     )
901         internal
902         pure
903         returns (bytes memory result)
904     {
905         // Read length of nested bytes
906         uint256 nestedBytesLength = readUint256(b, index);
907         index += 32;
908 
909         // Assert length of <b> is valid, given
910         // length of nested bytes
911         require(
912             b.length >= index + nestedBytesLength,
913             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
914         );
915 
916         // Return a pointer to the byte array as it exists inside `b`
917         assembly {
918             result := add(b, index)
919         }
920         return result;
921     }
922 
923     /// @dev Inserts bytes at a specific position in a byte array.
924     /// @param b Byte array to insert <input> into.
925     /// @param index Index in byte array of <input>.
926     /// @param input bytes to insert.
927     function writeBytesWithLength(
928         bytes memory b,
929         uint256 index,
930         bytes memory input
931     )
932         internal
933         pure
934     {
935         // Assert length of <b> is valid, given
936         // length of input
937         require(
938             b.length >= index + 32 + input.length,  // 32 bytes to store length
939             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
940         );
941 
942         // Copy <input> into <b>
943         memCopy(
944             b.contentAddress() + index,
945             input.rawAddress(), // includes length of <input>
946             input.length + 32   // +32 bytes to store <input> length
947         );
948     }
949 
950     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
951     /// @param dest Byte array that will be overwritten with source bytes.
952     /// @param source Byte array to copy onto dest bytes.
953     function deepCopyBytes(
954         bytes memory dest,
955         bytes memory source
956     )
957         internal
958         pure
959     {
960         uint256 sourceLen = source.length;
961         // Dest length must be >= source length, or some bytes would not be copied.
962         require(
963             dest.length >= sourceLen,
964             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
965         );
966         memCopy(
967             dest.contentAddress(),
968             source.contentAddress(),
969             sourceLen
970         );
971     }
972 }
973 
974 /*
975 
976   Copyright 2018 ZeroEx Intl.
977 
978   Licensed under the Apache License, Version 2.0 (the "License");
979   you may not use this file except in compliance with the License.
980   You may obtain a copy of the License at
981 
982     http://www.apache.org/licenses/LICENSE-2.0
983 
984   Unless required by applicable law or agreed to in writing, software
985   distributed under the License is distributed on an "AS IS" BASIS,
986   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
987   See the License for the specific language governing permissions and
988   limitations under the License.
989 
990 */
991 
992 
993 
994 contract LibEIP712 {
995 
996     // EIP191 header for EIP712 prefix
997     string constant internal EIP191_HEADER = "\x19\x01";
998 
999     // EIP712 Domain Name value
1000     string constant internal EIP712_DOMAIN_NAME = "0x Protocol";
1001 
1002     // EIP712 Domain Version value
1003     string constant internal EIP712_DOMAIN_VERSION = "2";
1004 
1005     // Hash of the EIP712 Domain Separator Schema
1006     bytes32 constant internal EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
1007         "EIP712Domain(",
1008         "string name,",
1009         "string version,",
1010         "address verifyingContract",
1011         ")"
1012     ));
1013 
1014     // Hash of the EIP712 Domain Separator data
1015     // solhint-disable-next-line var-name-mixedcase
1016     bytes32 public EIP712_DOMAIN_HASH;
1017 
1018     constructor ()
1019         public
1020     {
1021         EIP712_DOMAIN_HASH = keccak256(abi.encodePacked(
1022             EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
1023             keccak256(bytes(EIP712_DOMAIN_NAME)),
1024             keccak256(bytes(EIP712_DOMAIN_VERSION)),
1025             bytes32(address(this))
1026         ));
1027     }
1028 
1029     /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
1030     /// @param hashStruct The EIP712 hash struct.
1031     /// @return EIP712 hash applied to this EIP712 Domain.
1032     function hashEIP712Message(bytes32 hashStruct)
1033         internal
1034         view
1035         returns (bytes32 result)
1036     {
1037         bytes32 eip712DomainHash = EIP712_DOMAIN_HASH;
1038 
1039         // Assembly for more efficient computing:
1040         // keccak256(abi.encodePacked(
1041         //     EIP191_HEADER,
1042         //     EIP712_DOMAIN_HASH,
1043         //     hashStruct
1044         // ));
1045 
1046         assembly {
1047             // Load free memory pointer
1048             let memPtr := mload(64)
1049 
1050             mstore(memPtr, 0x1901000000000000000000000000000000000000000000000000000000000000)  // EIP191 header
1051             mstore(add(memPtr, 2), eip712DomainHash)                                            // EIP712 domain hash
1052             mstore(add(memPtr, 34), hashStruct)                                                 // Hash of struct
1053 
1054             // Compute hash
1055             result := keccak256(memPtr, 66)
1056         }
1057         return result;
1058     }
1059 }
1060 
1061 /*
1062 
1063   Copyright 2018 ZeroEx Intl.
1064 
1065   Licensed under the Apache License, Version 2.0 (the "License");
1066   you may not use this file except in compliance with the License.
1067   You may obtain a copy of the License at
1068 
1069     http://www.apache.org/licenses/LICENSE-2.0
1070 
1071   Unless required by applicable law or agreed to in writing, software
1072   distributed under the License is distributed on an "AS IS" BASIS,
1073   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1074   See the License for the specific language governing permissions and
1075   limitations under the License.
1076 
1077 */
1078 
1079 
1080 contract LibOrder is
1081     LibEIP712
1082 {
1083     // Hash for the EIP712 Order Schema
1084     bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
1085         "Order(",
1086         "address makerAddress,",
1087         "address takerAddress,",
1088         "address feeRecipientAddress,",
1089         "address senderAddress,",
1090         "uint256 makerAssetAmount,",
1091         "uint256 takerAssetAmount,",
1092         "uint256 makerFee,",
1093         "uint256 takerFee,",
1094         "uint256 expirationTimeSeconds,",
1095         "uint256 salt,",
1096         "bytes makerAssetData,",
1097         "bytes takerAssetData",
1098         ")"
1099     ));
1100 
1101     // A valid order remains fillable until it is expired, fully filled, or cancelled.
1102     // An order's state is unaffected by external factors, like account balances.
1103     enum OrderStatus {
1104         INVALID,                     // Default value
1105         INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
1106         INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
1107         FILLABLE,                    // Order is fillable
1108         EXPIRED,                     // Order has already expired
1109         FULLY_FILLED,                // Order is fully filled
1110         CANCELLED                    // Order has been cancelled
1111     }
1112 
1113     // solhint-disable max-line-length
1114     struct Order {
1115         address makerAddress;           // Address that created the order.
1116         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
1117         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
1118         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
1119         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
1120         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
1121         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
1122         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
1123         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
1124         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
1125         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
1126         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
1127     }
1128     // solhint-enable max-line-length
1129 
1130     struct OrderInfo {
1131         uint8 orderStatus;                    // Status that describes order's validity and fillability.
1132         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
1133         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
1134     }
1135 
1136     /// @dev Calculates Keccak-256 hash of the order.
1137     /// @param order The order structure.
1138     /// @return Keccak-256 EIP712 hash of the order.
1139     function getOrderHash(Order memory order)
1140         internal
1141         view
1142         returns (bytes32 orderHash)
1143     {
1144         orderHash = hashEIP712Message(hashOrder(order));
1145         return orderHash;
1146     }
1147 
1148     /// @dev Calculates EIP712 hash of the order.
1149     /// @param order The order structure.
1150     /// @return EIP712 hash of the order.
1151     function hashOrder(Order memory order)
1152         internal
1153         pure
1154         returns (bytes32 result)
1155     {
1156         bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
1157         bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
1158         bytes32 takerAssetDataHash = keccak256(order.takerAssetData);
1159 
1160         // Assembly for more efficiently computing:
1161         // keccak256(abi.encodePacked(
1162         //     EIP712_ORDER_SCHEMA_HASH,
1163         //     bytes32(order.makerAddress),
1164         //     bytes32(order.takerAddress),
1165         //     bytes32(order.feeRecipientAddress),
1166         //     bytes32(order.senderAddress),
1167         //     order.makerAssetAmount,
1168         //     order.takerAssetAmount,
1169         //     order.makerFee,
1170         //     order.takerFee,
1171         //     order.expirationTimeSeconds,
1172         //     order.salt,
1173         //     keccak256(order.makerAssetData),
1174         //     keccak256(order.takerAssetData)
1175         // ));
1176 
1177         assembly {
1178             // Calculate memory addresses that will be swapped out before hashing
1179             let pos1 := sub(order, 32)
1180             let pos2 := add(order, 320)
1181             let pos3 := add(order, 352)
1182 
1183             // Backup
1184             let temp1 := mload(pos1)
1185             let temp2 := mload(pos2)
1186             let temp3 := mload(pos3)
1187 
1188             // Hash in place
1189             mstore(pos1, schemaHash)
1190             mstore(pos2, makerAssetDataHash)
1191             mstore(pos3, takerAssetDataHash)
1192             result := keccak256(pos1, 416)
1193 
1194             // Restore
1195             mstore(pos1, temp1)
1196             mstore(pos2, temp2)
1197             mstore(pos3, temp3)
1198         }
1199         return result;
1200     }
1201 }
1202 
1203 /*
1204 
1205   Copyright 2018 ZeroEx Intl.
1206 
1207   Licensed under the Apache License, Version 2.0 (the "License");
1208   you may not use this file except in compliance with the License.
1209   You may obtain a copy of the License at
1210 
1211     http://www.apache.org/licenses/LICENSE-2.0
1212 
1213   Unless required by applicable law or agreed to in writing, software
1214   distributed under the License is distributed on an "AS IS" BASIS,
1215   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1216   See the License for the specific language governing permissions and
1217   limitations under the License.
1218 
1219 */
1220 
1221 
1222 contract LibFillResults is
1223     SafeMath
1224 {
1225     struct FillResults {
1226         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
1227         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
1228         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
1229         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
1230     }
1231 
1232     struct MatchedFillResults {
1233         FillResults left;                    // Amounts filled and fees paid of left order.
1234         FillResults right;                   // Amounts filled and fees paid of right order.
1235         uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
1236     }
1237 
1238     /// @dev Adds properties of both FillResults instances.
1239     ///      Modifies the first FillResults instance specified.
1240     /// @param totalFillResults Fill results instance that will be added onto.
1241     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
1242     function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
1243         internal
1244         pure
1245     {
1246         totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
1247         totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
1248         totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
1249         totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
1250     }
1251 }
1252 
1253 /*
1254 
1255   Copyright 2018 ZeroEx Intl.
1256 
1257   Licensed under the Apache License, Version 2.0 (the "License");
1258   you may not use this file except in compliance with the License.
1259   You may obtain a copy of the License at
1260 
1261     http://www.apache.org/licenses/LICENSE-2.0
1262 
1263   Unless required by applicable law or agreed to in writing, software
1264   distributed under the License is distributed on an "AS IS" BASIS,
1265   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1266   See the License for the specific language governing permissions and
1267   limitations under the License.
1268 
1269 */
1270 
1271 
1272 contract IExchangeCore {
1273 
1274     /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
1275     ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
1276     /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
1277     function cancelOrdersUpTo(uint256 targetOrderEpoch)
1278         external;
1279 
1280     /// @dev Fills the input order.
1281     /// @param order Order struct containing order specifications.
1282     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1283     /// @param signature Proof that order has been created by maker.
1284     /// @return Amounts filled and fees paid by maker and taker.
1285     function fillOrder(
1286         LibOrder.Order memory order,
1287         uint256 takerAssetFillAmount,
1288         bytes memory signature
1289     )
1290         public
1291         returns (LibFillResults.FillResults memory fillResults);
1292 
1293     /// @dev After calling, the order can not be filled anymore.
1294     /// @param order Order struct containing order specifications.
1295     function cancelOrder(LibOrder.Order memory order)
1296         public;
1297 
1298     /// @dev Gets information about an order: status, hash, and amount filled.
1299     /// @param order Order to gather information on.
1300     /// @return OrderInfo Information about the order and its state.
1301     ///                   See LibOrder.OrderInfo for a complete description.
1302     function getOrderInfo(LibOrder.Order memory order)
1303         public
1304         view
1305         returns (LibOrder.OrderInfo memory orderInfo);
1306 }
1307 
1308 /*
1309 
1310   Copyright 2018 ZeroEx Intl.
1311 
1312   Licensed under the Apache License, Version 2.0 (the "License");
1313   you may not use this file except in compliance with the License.
1314   You may obtain a copy of the License at
1315 
1316     http://www.apache.org/licenses/LICENSE-2.0
1317 
1318   Unless required by applicable law or agreed to in writing, software
1319   distributed under the License is distributed on an "AS IS" BASIS,
1320   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1321   See the License for the specific language governing permissions and
1322   limitations under the License.
1323 
1324 */
1325 
1326 
1327 contract IMatchOrders {
1328 
1329     /// @dev Match two complementary orders that have a profitable spread.
1330     ///      Each order is filled at their respective price point. However, the calculations are
1331     ///      carried out as though the orders are both being filled at the right order's price point.
1332     ///      The profit made by the left order goes to the taker (who matched the two orders).
1333     /// @param leftOrder First order to match.
1334     /// @param rightOrder Second order to match.
1335     /// @param leftSignature Proof that order was created by the left maker.
1336     /// @param rightSignature Proof that order was created by the right maker.
1337     /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
1338     function matchOrders(
1339         LibOrder.Order memory leftOrder,
1340         LibOrder.Order memory rightOrder,
1341         bytes memory leftSignature,
1342         bytes memory rightSignature
1343     )
1344         public
1345         returns (LibFillResults.MatchedFillResults memory matchedFillResults);
1346 }
1347 
1348 /*
1349 
1350   Copyright 2018 ZeroEx Intl.
1351 
1352   Licensed under the Apache License, Version 2.0 (the "License");
1353   you may not use this file except in compliance with the License.
1354   You may obtain a copy of the License at
1355 
1356     http://www.apache.org/licenses/LICENSE-2.0
1357 
1358   Unless required by applicable law or agreed to in writing, software
1359   distributed under the License is distributed on an "AS IS" BASIS,
1360   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1361   See the License for the specific language governing permissions and
1362   limitations under the License.
1363 
1364 */
1365 
1366 
1367 
1368 contract ISignatureValidator {
1369 
1370     /// @dev Approves a hash on-chain using any valid signature type.
1371     ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
1372     /// @param signerAddress Address that should have signed the given hash.
1373     /// @param signature Proof that the hash has been signed by signer.
1374     function preSign(
1375         bytes32 hash,
1376         address signerAddress,
1377         bytes signature
1378     )
1379         external;
1380 
1381     /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
1382     /// @param validatorAddress Address of Validator contract.
1383     /// @param approval Approval or disapproval of  Validator contract.
1384     function setSignatureValidatorApproval(
1385         address validatorAddress,
1386         bool approval
1387     )
1388         external;
1389 
1390     /// @dev Verifies that a signature is valid.
1391     /// @param hash Message hash that is signed.
1392     /// @param signerAddress Address of signer.
1393     /// @param signature Proof of signing.
1394     /// @return Validity of order signature.
1395     function isValidSignature(
1396         bytes32 hash,
1397         address signerAddress,
1398         bytes memory signature
1399     )
1400         public
1401         view
1402         returns (bool isValid);
1403 }
1404 
1405 /*
1406 
1407   Copyright 2018 ZeroEx Intl.
1408 
1409   Licensed under the Apache License, Version 2.0 (the "License");
1410   you may not use this file except in compliance with the License.
1411   You may obtain a copy of the License at
1412 
1413     http://www.apache.org/licenses/LICENSE-2.0
1414 
1415   Unless required by applicable law or agreed to in writing, software
1416   distributed under the License is distributed on an "AS IS" BASIS,
1417   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1418   See the License for the specific language governing permissions and
1419   limitations under the License.
1420 
1421 */
1422 
1423 
1424 contract ITransactions {
1425 
1426     /// @dev Executes an exchange method call in the context of signer.
1427     /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
1428     /// @param signerAddress Address of transaction signer.
1429     /// @param data AbiV2 encoded calldata.
1430     /// @param signature Proof of signer transaction by signer.
1431     function executeTransaction(
1432         uint256 salt,
1433         address signerAddress,
1434         bytes data,
1435         bytes signature
1436     )
1437         external;
1438 }
1439 
1440 /*
1441 
1442   Copyright 2018 ZeroEx Intl.
1443 
1444   Licensed under the Apache License, Version 2.0 (the "License");
1445   you may not use this file except in compliance with the License.
1446   You may obtain a copy of the License at
1447 
1448     http://www.apache.org/licenses/LICENSE-2.0
1449 
1450   Unless required by applicable law or agreed to in writing, software
1451   distributed under the License is distributed on an "AS IS" BASIS,
1452   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1453   See the License for the specific language governing permissions and
1454   limitations under the License.
1455 
1456 */
1457 
1458 
1459 contract IAssetProxyDispatcher {
1460 
1461     /// @dev Registers an asset proxy to its asset proxy id.
1462     ///      Once an asset proxy is registered, it cannot be unregistered.
1463     /// @param assetProxy Address of new asset proxy to register.
1464     function registerAssetProxy(address assetProxy)
1465         external;
1466 
1467     /// @dev Gets an asset proxy.
1468     /// @param assetProxyId Id of the asset proxy.
1469     /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
1470     function getAssetProxy(bytes4 assetProxyId)
1471         external
1472         view
1473         returns (address);
1474 }
1475 
1476 /*
1477 
1478   Copyright 2018 ZeroEx Intl.
1479 
1480   Licensed under the Apache License, Version 2.0 (the "License");
1481   you may not use this file except in compliance with the License.
1482   You may obtain a copy of the License at
1483 
1484     http://www.apache.org/licenses/LICENSE-2.0
1485 
1486   Unless required by applicable law or agreed to in writing, software
1487   distributed under the License is distributed on an "AS IS" BASIS,
1488   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1489   See the License for the specific language governing permissions and
1490   limitations under the License.
1491 
1492 */
1493 
1494 
1495 contract IWrapperFunctions {
1496 
1497     /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
1498     /// @param order LibOrder.Order struct containing order specifications.
1499     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1500     /// @param signature Proof that order has been created by maker.
1501     function fillOrKillOrder(
1502         LibOrder.Order memory order,
1503         uint256 takerAssetFillAmount,
1504         bytes memory signature
1505     )
1506         public
1507         returns (LibFillResults.FillResults memory fillResults);
1508 
1509     /// @dev Fills an order with specified parameters and ECDSA signature.
1510     ///      Returns false if the transaction would otherwise revert.
1511     /// @param order LibOrder.Order struct containing order specifications.
1512     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1513     /// @param signature Proof that order has been created by maker.
1514     /// @return Amounts filled and fees paid by maker and taker.
1515     function fillOrderNoThrow(
1516         LibOrder.Order memory order,
1517         uint256 takerAssetFillAmount,
1518         bytes memory signature
1519     )
1520         public
1521         returns (LibFillResults.FillResults memory fillResults);
1522 
1523     /// @dev Synchronously executes multiple calls of fillOrder.
1524     /// @param orders Array of order specifications.
1525     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1526     /// @param signatures Proofs that orders have been created by makers.
1527     /// @return Amounts filled and fees paid by makers and taker.
1528     function batchFillOrders(
1529         LibOrder.Order[] memory orders,
1530         uint256[] memory takerAssetFillAmounts,
1531         bytes[] memory signatures
1532     )
1533         public
1534         returns (LibFillResults.FillResults memory totalFillResults);
1535 
1536     /// @dev Synchronously executes multiple calls of fillOrKill.
1537     /// @param orders Array of order specifications.
1538     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1539     /// @param signatures Proofs that orders have been created by makers.
1540     /// @return Amounts filled and fees paid by makers and taker.
1541     function batchFillOrKillOrders(
1542         LibOrder.Order[] memory orders,
1543         uint256[] memory takerAssetFillAmounts,
1544         bytes[] memory signatures
1545     )
1546         public
1547         returns (LibFillResults.FillResults memory totalFillResults);
1548 
1549     /// @dev Fills an order with specified parameters and ECDSA signature.
1550     ///      Returns false if the transaction would otherwise revert.
1551     /// @param orders Array of order specifications.
1552     /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
1553     /// @param signatures Proofs that orders have been created by makers.
1554     /// @return Amounts filled and fees paid by makers and taker.
1555     function batchFillOrdersNoThrow(
1556         LibOrder.Order[] memory orders,
1557         uint256[] memory takerAssetFillAmounts,
1558         bytes[] memory signatures
1559     )
1560         public
1561         returns (LibFillResults.FillResults memory totalFillResults);
1562 
1563     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1564     /// @param orders Array of order specifications.
1565     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1566     /// @param signatures Proofs that orders have been created by makers.
1567     /// @return Amounts filled and fees paid by makers and taker.
1568     function marketSellOrders(
1569         LibOrder.Order[] memory orders,
1570         uint256 takerAssetFillAmount,
1571         bytes[] memory signatures
1572     )
1573         public
1574         returns (LibFillResults.FillResults memory totalFillResults);
1575 
1576     /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
1577     ///      Returns false if the transaction would otherwise revert.
1578     /// @param orders Array of order specifications.
1579     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
1580     /// @param signatures Proofs that orders have been signed by makers.
1581     /// @return Amounts filled and fees paid by makers and taker.
1582     function marketSellOrdersNoThrow(
1583         LibOrder.Order[] memory orders,
1584         uint256 takerAssetFillAmount,
1585         bytes[] memory signatures
1586     )
1587         public
1588         returns (LibFillResults.FillResults memory totalFillResults);
1589 
1590     /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
1591     /// @param orders Array of order specifications.
1592     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1593     /// @param signatures Proofs that orders have been signed by makers.
1594     /// @return Amounts filled and fees paid by makers and taker.
1595     function marketBuyOrders(
1596         LibOrder.Order[] memory orders,
1597         uint256 makerAssetFillAmount,
1598         bytes[] memory signatures
1599     )
1600         public
1601         returns (LibFillResults.FillResults memory totalFillResults);
1602 
1603     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
1604     ///      Returns false if the transaction would otherwise revert.
1605     /// @param orders Array of order specifications.
1606     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
1607     /// @param signatures Proofs that orders have been signed by makers.
1608     /// @return Amounts filled and fees paid by makers and taker.
1609     function marketBuyOrdersNoThrow(
1610         LibOrder.Order[] memory orders,
1611         uint256 makerAssetFillAmount,
1612         bytes[] memory signatures
1613     )
1614         public
1615         returns (LibFillResults.FillResults memory totalFillResults);
1616 
1617     /// @dev Synchronously cancels multiple orders in a single transaction.
1618     /// @param orders Array of order specifications.
1619     function batchCancelOrders(LibOrder.Order[] memory orders)
1620         public;
1621 
1622     /// @dev Fetches information for all passed in orders
1623     /// @param orders Array of order specifications.
1624     /// @return Array of OrderInfo instances that correspond to each order.
1625     function getOrdersInfo(LibOrder.Order[] memory orders)
1626         public
1627         view
1628         returns (LibOrder.OrderInfo[] memory);
1629 }
1630 
1631 /*
1632 
1633   Copyright 2018 ZeroEx Intl.
1634 
1635   Licensed under the Apache License, Version 2.0 (the "License");
1636   you may not use this file except in compliance with the License.
1637   You may obtain a copy of the License at
1638 
1639     http://www.apache.org/licenses/LICENSE-2.0
1640 
1641   Unless required by applicable law or agreed to in writing, software
1642   distributed under the License is distributed on an "AS IS" BASIS,
1643   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1644   See the License for the specific language governing permissions and
1645   limitations under the License.
1646 
1647 */
1648 
1649 
1650 // solhint-disable no-empty-blocks
1651 contract IExchange is
1652     IExchangeCore,
1653     IMatchOrders,
1654     ISignatureValidator,
1655     ITransactions,
1656     IAssetProxyDispatcher,
1657     IWrapperFunctions
1658 {}
1659 
1660 /*
1661 
1662   Copyright 2018 ZeroEx Intl.
1663 
1664   Licensed under the Apache License, Version 2.0 (the "License");
1665   you may not use this file except in compliance with the License.
1666   You may obtain a copy of the License at
1667 
1668     http://www.apache.org/licenses/LICENSE-2.0
1669 
1670   Unless required by applicable law or agreed to in writing, software
1671   distributed under the License is distributed on an "AS IS" BASIS,
1672   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1673   See the License for the specific language governing permissions and
1674   limitations under the License.
1675 
1676 */
1677 
1678 
1679 /*
1680 
1681   Copyright 2018 ZeroEx Intl.
1682 
1683   Licensed under the Apache License, Version 2.0 (the "License");
1684   you may not use this file except in compliance with the License.
1685   You may obtain a copy of the License at
1686 
1687     http://www.apache.org/licenses/LICENSE-2.0
1688 
1689   Unless required by applicable law or agreed to in writing, software
1690   distributed under the License is distributed on an "AS IS" BASIS,
1691   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1692   See the License for the specific language governing permissions and
1693   limitations under the License.
1694 
1695 */
1696 
1697 
1698 contract IEtherToken is
1699     IERC20Token
1700 {
1701     function deposit()
1702         public
1703         payable;
1704 
1705     function withdraw(uint256 amount)
1706         public;
1707 }
1708 
1709 /*
1710 
1711   Copyright 2018 ZeroEx Intl.
1712 
1713   Licensed under the Apache License, Version 2.0 (the "License");
1714   you may not use this file except in compliance with the License.
1715   You may obtain a copy of the License at
1716 
1717     http://www.apache.org/licenses/LICENSE-2.0
1718 
1719   Unless required by applicable law or agreed to in writing, software
1720   distributed under the License is distributed on an "AS IS" BASIS,
1721   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1722   See the License for the specific language governing permissions and
1723   limitations under the License.
1724 
1725 */
1726 
1727 
1728 
1729 /*
1730 
1731   Copyright 2018 ZeroEx Intl.
1732 
1733   Licensed under the Apache License, Version 2.0 (the "License");
1734   you may not use this file except in compliance with the License.
1735   You may obtain a copy of the License at
1736 
1737     http://www.apache.org/licenses/LICENSE-2.0
1738 
1739   Unless required by applicable law or agreed to in writing, software
1740   distributed under the License is distributed on an "AS IS" BASIS,
1741   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1742   See the License for the specific language governing permissions and
1743   limitations under the License.
1744 
1745 */
1746 
1747 
1748 
1749 contract LibConstants {
1750 
1751     using LibBytes for bytes;
1752 
1753     bytes4 constant internal ERC20_DATA_ID = bytes4(keccak256("ERC20Token(address)"));
1754     bytes4 constant internal ERC721_DATA_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
1755     uint256 constant internal MAX_UINT = 2**256 - 1;
1756     uint256 constant internal PERCENTAGE_DENOMINATOR = 10**18;
1757     uint256 constant internal MAX_FEE_PERCENTAGE = 5 * PERCENTAGE_DENOMINATOR / 100;         // 5%
1758     uint256 constant internal MAX_WETH_FILL_PERCENTAGE = 95 * PERCENTAGE_DENOMINATOR / 100;  // 95%
1759 
1760      // solhint-disable var-name-mixedcase
1761     IExchange internal EXCHANGE;
1762     IEtherToken internal ETHER_TOKEN;
1763     IERC20Token internal ZRX_TOKEN;
1764     bytes internal ZRX_ASSET_DATA;
1765     bytes internal WETH_ASSET_DATA;
1766     // solhint-enable var-name-mixedcase
1767 
1768     constructor (
1769         address _exchange,
1770         bytes memory _zrxAssetData,
1771         bytes memory _wethAssetData
1772     )
1773         public
1774     {
1775         EXCHANGE = IExchange(_exchange);
1776         ZRX_ASSET_DATA = _zrxAssetData;
1777         WETH_ASSET_DATA = _wethAssetData;
1778 
1779         address etherToken = _wethAssetData.readAddress(16);
1780         address zrxToken = _zrxAssetData.readAddress(16);
1781         ETHER_TOKEN = IEtherToken(etherToken);
1782         ZRX_TOKEN = IERC20Token(zrxToken);
1783     }
1784 }
1785 
1786 /*
1787 
1788   Copyright 2018 ZeroEx Intl.
1789 
1790   Licensed under the Apache License, Version 2.0 (the "License");
1791   you may not use this file except in compliance with the License.
1792   You may obtain a copy of the License at
1793 
1794     http://www.apache.org/licenses/LICENSE-2.0
1795 
1796   Unless required by applicable law or agreed to in writing, software
1797   distributed under the License is distributed on an "AS IS" BASIS,
1798   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1799   See the License for the specific language governing permissions and
1800   limitations under the License.
1801 
1802 */
1803 
1804 
1805 contract MWeth {
1806 
1807     /// @dev Converts message call's ETH value into WETH.
1808     function convertEthToWeth()
1809         internal;
1810 
1811     /// @dev Transfers feePercentage of WETH spent on primary orders to feeRecipient.
1812     ///      Refunds any excess ETH to msg.sender.
1813     /// @param wethSoldExcludingFeeOrders Amount of WETH sold when filling primary orders.
1814     /// @param wethSoldForZrx Amount of WETH sold when purchasing ZRX required for primary order fees.
1815     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
1816     /// @param feeRecipient Address that will receive ETH when orders are filled.
1817     function transferEthFeeAndRefund(
1818         uint256 wethSoldExcludingFeeOrders,
1819         uint256 wethSoldForZrx,
1820         uint256 feePercentage,
1821         address feeRecipient
1822     )
1823         internal;
1824 }
1825 
1826 /*
1827 
1828   Copyright 2018 ZeroEx Intl.
1829 
1830   Licensed under the Apache License, Version 2.0 (the "License");
1831   you may not use this file except in compliance with the License.
1832   You may obtain a copy of the License at
1833 
1834     http://www.apache.org/licenses/LICENSE-2.0
1835 
1836   Unless required by applicable law or agreed to in writing, software
1837   distributed under the License is distributed on an "AS IS" BASIS,
1838   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1839   See the License for the specific language governing permissions and
1840   limitations under the License.
1841 
1842 */
1843 
1844 
1845 contract MixinWeth is
1846     LibMath,
1847     LibConstants,
1848     MWeth
1849 {
1850     /// @dev Default payabale function, this allows us to withdraw WETH
1851     function ()
1852         public
1853         payable
1854     {
1855         require(
1856             msg.sender == address(ETHER_TOKEN),
1857             "DEFAULT_FUNCTION_WETH_CONTRACT_ONLY"
1858         );
1859     }
1860 
1861     /// @dev Converts message call's ETH value into WETH.
1862     function convertEthToWeth()
1863         internal
1864     {
1865         require(
1866             msg.value > 0,
1867             "INVALID_MSG_VALUE"
1868         );
1869         ETHER_TOKEN.deposit.value(msg.value)();
1870     }
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
1884         internal
1885     {
1886         // Ensure feePercentage is less than 5%.
1887         require(
1888             feePercentage <= MAX_FEE_PERCENTAGE,
1889             "FEE_PERCENTAGE_TOO_LARGE"
1890         );
1891 
1892         // Ensure that no extra WETH owned by this contract has been sold.
1893         uint256 wethSold = safeAdd(wethSoldExcludingFeeOrders, wethSoldForZrx);
1894         require(
1895             wethSold <= msg.value,
1896             "OVERSOLD_WETH"
1897         );
1898 
1899         // Calculate amount of WETH that hasn't been sold.
1900         uint256 wethRemaining = safeSub(msg.value, wethSold);
1901 
1902         // Calculate ETH fee to pay to feeRecipient.
1903         uint256 ethFee = getPartialAmountFloor(
1904             feePercentage,
1905             PERCENTAGE_DENOMINATOR,
1906             wethSoldExcludingFeeOrders
1907         );
1908 
1909         // Ensure fee is less than amount of WETH remaining.
1910         require(
1911             ethFee <= wethRemaining,
1912             "INSUFFICIENT_ETH_REMAINING"
1913         );
1914 
1915         // Do nothing if no WETH remaining
1916         if (wethRemaining > 0) {
1917             // Convert remaining WETH to ETH
1918             ETHER_TOKEN.withdraw(wethRemaining);
1919 
1920             // Pay ETH to feeRecipient
1921             if (ethFee > 0) {
1922                 feeRecipient.transfer(ethFee);
1923             }
1924 
1925             // Refund remaining ETH to msg.sender.
1926             uint256 ethRefund = safeSub(wethRemaining, ethFee);
1927             if (ethRefund > 0) {
1928                 msg.sender.transfer(ethRefund);
1929             }
1930         }
1931     }
1932 }
1933 
1934 /*
1935 
1936   Copyright 2018 ZeroEx Intl.
1937 
1938   Licensed under the Apache License, Version 2.0 (the "License");
1939   you may not use this file except in compliance with the License.
1940   You may obtain a copy of the License at
1941 
1942     http://www.apache.org/licenses/LICENSE-2.0
1943 
1944   Unless required by applicable law or agreed to in writing, software
1945   distributed under the License is distributed on an "AS IS" BASIS,
1946   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1947   See the License for the specific language governing permissions and
1948   limitations under the License.
1949 
1950 */
1951 
1952 
1953 
1954 contract IAssets {
1955 
1956     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to
1957     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
1958     ///      used to withdraw assets that were accidentally sent to this contract.
1959     /// @param assetData Byte array encoded for the respective asset proxy.
1960     /// @param amount Amount of ERC20 token to withdraw.
1961     function withdrawAsset(
1962         bytes assetData,
1963         uint256 amount
1964     )
1965         external;
1966 }
1967 
1968 /*
1969 
1970   Copyright 2018 ZeroEx Intl.
1971 
1972   Licensed under the Apache License, Version 2.0 (the "License");
1973   you may not use this file except in compliance with the License.
1974   You may obtain a copy of the License at
1975 
1976     http://www.apache.org/licenses/LICENSE-2.0
1977 
1978   Unless required by applicable law or agreed to in writing, software
1979   distributed under the License is distributed on an "AS IS" BASIS,
1980   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1981   See the License for the specific language governing permissions and
1982   limitations under the License.
1983 
1984 */
1985 
1986 
1987 
1988 contract MAssets is
1989     IAssets
1990 {
1991     /// @dev Transfers given amount of asset to sender.
1992     /// @param assetData Byte array encoded for the respective asset proxy.
1993     /// @param amount Amount of asset to transfer to sender.
1994     function transferAssetToSender(
1995         bytes memory assetData,
1996         uint256 amount
1997     )
1998         internal;
1999 
2000     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2001     /// @param assetData Byte array encoded for the respective asset proxy.
2002     /// @param amount Amount of asset to transfer to sender.
2003     function transferERC20Token(
2004         bytes memory assetData,
2005         uint256 amount
2006     )
2007         internal;
2008 
2009     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2010     /// @param assetData Byte array encoded for the respective asset proxy.
2011     /// @param amount Amount of asset to transfer to sender.
2012     function transferERC721Token(
2013         bytes memory assetData,
2014         uint256 amount
2015     )
2016         internal;
2017 }
2018 
2019 /*
2020 
2021   Copyright 2018 ZeroEx Intl.
2022 
2023   Licensed under the Apache License, Version 2.0 (the "License");
2024   you may not use this file except in compliance with the License.
2025   You may obtain a copy of the License at
2026 
2027     http://www.apache.org/licenses/LICENSE-2.0
2028 
2029   Unless required by applicable law or agreed to in writing, software
2030   distributed under the License is distributed on an "AS IS" BASIS,
2031   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2032   See the License for the specific language governing permissions and
2033   limitations under the License.
2034 
2035 */
2036 
2037 
2038 contract MExchangeWrapper {
2039 
2040     /// @dev Fills the input order.
2041     ///      Returns false if the transaction would otherwise revert.
2042     /// @param order Order struct containing order specifications.
2043     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2044     /// @param signature Proof that order has been created by maker.
2045     /// @return Amounts filled and fees paid by maker and taker.
2046     function fillOrderNoThrow(
2047         LibOrder.Order memory order,
2048         uint256 takerAssetFillAmount,
2049         bytes memory signature
2050     )
2051         internal
2052         returns (LibFillResults.FillResults memory fillResults);
2053 
2054     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
2055     ///      Returns false if the transaction would otherwise revert.
2056     /// @param orders Array of order specifications.
2057     /// @param wethSellAmount Desired amount of WETH to sell.
2058     /// @param signatures Proofs that orders have been signed by makers.
2059     /// @return Amounts filled and fees paid by makers and taker.
2060     function marketSellWeth(
2061         LibOrder.Order[] memory orders,
2062         uint256 wethSellAmount,
2063         bytes[] memory signatures
2064     )
2065         internal
2066         returns (LibFillResults.FillResults memory totalFillResults);
2067 
2068     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
2069     ///      Returns false if the transaction would otherwise revert.
2070     ///      The asset being sold by taker must always be WETH.
2071     /// @param orders Array of order specifications.
2072     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
2073     /// @param signatures Proofs that orders have been signed by makers.
2074     /// @return Amounts filled and fees paid by makers and taker.
2075     function marketBuyExactAmountWithWeth(
2076         LibOrder.Order[] memory orders,
2077         uint256 makerAssetFillAmount,
2078         bytes[] memory signatures
2079     )
2080         internal
2081         returns (LibFillResults.FillResults memory totalFillResults);
2082 
2083     /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
2084     ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
2085     ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
2086     ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
2087     ///      The asset being sold by taker must always be WETH.
2088     /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
2089     /// @param zrxBuyAmount Desired amount of ZRX to buy.
2090     /// @param signatures Proofs that orders have been created by makers.
2091     /// @return totalFillResults Amounts filled and fees paid by maker and taker.
2092     function marketBuyExactZrxWithWeth(
2093         LibOrder.Order[] memory orders,
2094         uint256 zrxBuyAmount,
2095         bytes[] memory signatures
2096     )
2097         internal
2098         returns (LibFillResults.FillResults memory totalFillResults);
2099 }
2100 
2101 /*
2102 
2103   Copyright 2018 ZeroEx Intl.
2104 
2105   Licensed under the Apache License, Version 2.0 (the "License");
2106   you may not use this file except in compliance with the License.
2107   You may obtain a copy of the License at
2108 
2109     http://www.apache.org/licenses/LICENSE-2.0
2110 
2111   Unless required by applicable law or agreed to in writing, software
2112   distributed under the License is distributed on an "AS IS" BASIS,
2113   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2114   See the License for the specific language governing permissions and
2115   limitations under the License.
2116 
2117 */
2118 
2119 
2120 contract IForwarderCore {
2121 
2122     /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
2123     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2124     ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
2125     ///      Any ETH not spent will be refunded to sender.
2126     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
2127     /// @param signatures Proofs that orders have been created by makers.
2128     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2129     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2130     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2131     /// @param feeRecipient Address that will receive ETH when orders are filled.
2132     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2133     function marketSellOrdersWithEth(
2134         LibOrder.Order[] memory orders,
2135         bytes[] memory signatures,
2136         LibOrder.Order[] memory feeOrders,
2137         bytes[] memory feeSignatures,
2138         uint256  feePercentage,
2139         address feeRecipient
2140     )
2141         public
2142         payable
2143         returns (
2144             LibFillResults.FillResults memory orderFillResults,
2145             LibFillResults.FillResults memory feeOrderFillResults
2146         );
2147 
2148     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2149     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2150     ///      Any ETH not spent will be refunded to sender.
2151     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
2152     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2153     /// @param signatures Proofs that orders have been created by makers.
2154     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2155     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2156     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2157     /// @param feeRecipient Address that will receive ETH when orders are filled.
2158     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2159     function marketBuyOrdersWithEth(
2160         LibOrder.Order[] memory orders,
2161         uint256 makerAssetFillAmount,
2162         bytes[] memory signatures,
2163         LibOrder.Order[] memory feeOrders,
2164         bytes[] memory feeSignatures,
2165         uint256  feePercentage,
2166         address feeRecipient
2167     )
2168         public
2169         payable
2170         returns (
2171             LibFillResults.FillResults memory orderFillResults,
2172             LibFillResults.FillResults memory feeOrderFillResults
2173         );
2174 }
2175 
2176 /*
2177 
2178   Copyright 2018 ZeroEx Intl.
2179 
2180   Licensed under the Apache License, Version 2.0 (the "License");
2181   you may not use this file except in compliance with the License.
2182   You may obtain a copy of the License at
2183 
2184     http://www.apache.org/licenses/LICENSE-2.0
2185 
2186   Unless required by applicable law or agreed to in writing, software
2187   distributed under the License is distributed on an "AS IS" BASIS,
2188   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2189   See the License for the specific language governing permissions and
2190   limitations under the License.
2191 
2192 */
2193 
2194 
2195 contract MixinForwarderCore is
2196     LibFillResults,
2197     LibMath,
2198     LibConstants,
2199     MWeth,
2200     MAssets,
2201     MExchangeWrapper,
2202     IForwarderCore
2203 {
2204     using LibBytes for bytes;
2205 
2206     /// @dev Constructor approves ERC20 proxy to transfer ZRX and WETH on this contract's behalf.
2207     constructor ()
2208         public
2209     {
2210         address proxyAddress = EXCHANGE.getAssetProxy(ERC20_DATA_ID);
2211         require(
2212             proxyAddress != address(0),
2213             "UNREGISTERED_ASSET_PROXY"
2214         );
2215         ETHER_TOKEN.approve(proxyAddress, MAX_UINT);
2216         ZRX_TOKEN.approve(proxyAddress, MAX_UINT);
2217     }
2218 
2219     /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
2220     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2221     ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
2222     ///      Any ETH not spent will be refunded to sender.
2223     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
2224     /// @param signatures Proofs that orders have been created by makers.
2225     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2226     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2227     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2228     /// @param feeRecipient Address that will receive ETH when orders are filled.
2229     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2230     function marketSellOrdersWithEth(
2231         LibOrder.Order[] memory orders,
2232         bytes[] memory signatures,
2233         LibOrder.Order[] memory feeOrders,
2234         bytes[] memory feeSignatures,
2235         uint256  feePercentage,
2236         address feeRecipient
2237     )
2238         public
2239         payable
2240         returns (
2241             FillResults memory orderFillResults,
2242             FillResults memory feeOrderFillResults
2243         )
2244     {
2245         // Convert ETH to WETH.
2246         convertEthToWeth();
2247 
2248         uint256 wethSellAmount;
2249         uint256 zrxBuyAmount;
2250         uint256 makerAssetAmountPurchased;
2251         if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
2252             // Calculate amount of WETH that won't be spent on ETH fees.
2253             wethSellAmount = getPartialAmountFloor(
2254                 PERCENTAGE_DENOMINATOR,
2255                 safeAdd(PERCENTAGE_DENOMINATOR, feePercentage),
2256                 msg.value
2257             );
2258             // Market sell available WETH.
2259             // ZRX fees are paid with this contract's balance.
2260             orderFillResults = marketSellWeth(
2261                 orders,
2262                 wethSellAmount,
2263                 signatures
2264             );
2265             // The fee amount must be deducted from the amount transfered back to sender.
2266             makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
2267         } else {
2268             // 5% of WETH is reserved for filling feeOrders and paying feeRecipient.
2269             wethSellAmount = getPartialAmountFloor(
2270                 MAX_WETH_FILL_PERCENTAGE,
2271                 PERCENTAGE_DENOMINATOR,
2272                 msg.value
2273             );
2274             // Market sell 95% of WETH.
2275             // ZRX fees are payed with this contract's balance.
2276             orderFillResults = marketSellWeth(
2277                 orders,
2278                 wethSellAmount,
2279                 signatures
2280             );
2281             // Buy back all ZRX spent on fees.
2282             zrxBuyAmount = orderFillResults.takerFeePaid;
2283             feeOrderFillResults = marketBuyExactZrxWithWeth(
2284                 feeOrders,
2285                 zrxBuyAmount,
2286                 feeSignatures
2287             );
2288             makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2289         }
2290 
2291         // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
2292         // Refund remaining ETH to msg.sender.
2293         transferEthFeeAndRefund(
2294             orderFillResults.takerAssetFilledAmount,
2295             feeOrderFillResults.takerAssetFilledAmount,
2296             feePercentage,
2297             feeRecipient
2298         );
2299 
2300         // Transfer purchased assets to msg.sender.
2301         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2302     }
2303 
2304     /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
2305     ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
2306     ///      Any ETH not spent will be refunded to sender.
2307     /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset.
2308     /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
2309     /// @param signatures Proofs that orders have been created by makers.
2310     /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
2311     /// @param feeSignatures Proofs that feeOrders have been created by makers.
2312     /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
2313     /// @param feeRecipient Address that will receive ETH when orders are filled.
2314     /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
2315     function marketBuyOrdersWithEth(
2316         LibOrder.Order[] memory orders,
2317         uint256 makerAssetFillAmount,
2318         bytes[] memory signatures,
2319         LibOrder.Order[] memory feeOrders,
2320         bytes[] memory feeSignatures,
2321         uint256  feePercentage,
2322         address feeRecipient
2323     )
2324         public
2325         payable
2326         returns (
2327             FillResults memory orderFillResults,
2328             FillResults memory feeOrderFillResults
2329         )
2330     {
2331         // Convert ETH to WETH.
2332         convertEthToWeth();
2333 
2334         uint256 zrxBuyAmount;
2335         uint256 makerAssetAmountPurchased;
2336         if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
2337             // If the makerAsset is ZRX, it is not necessary to pay fees out of this
2338             // contracts's ZRX balance because fees are factored into the price of the order.
2339             orderFillResults = marketBuyExactZrxWithWeth(
2340                 orders,
2341                 makerAssetFillAmount,
2342                 signatures
2343             );
2344             // The fee amount must be deducted from the amount transfered back to sender.
2345             makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
2346         } else {
2347             // Attemp to purchase desired amount of makerAsset.
2348             // ZRX fees are payed with this contract's balance.
2349             orderFillResults = marketBuyExactAmountWithWeth(
2350                 orders,
2351                 makerAssetFillAmount,
2352                 signatures
2353             );
2354             // Buy back all ZRX spent on fees.
2355             zrxBuyAmount = orderFillResults.takerFeePaid;
2356             feeOrderFillResults = marketBuyExactZrxWithWeth(
2357                 feeOrders,
2358                 zrxBuyAmount,
2359                 feeSignatures
2360             );
2361             makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
2362         }
2363 
2364         // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
2365         // Refund remaining ETH to msg.sender.
2366         transferEthFeeAndRefund(
2367             orderFillResults.takerAssetFilledAmount,
2368             feeOrderFillResults.takerAssetFilledAmount,
2369             feePercentage,
2370             feeRecipient
2371         );
2372 
2373         // Transfer purchased assets to msg.sender.
2374         transferAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
2375     }
2376 }
2377 
2378 
2379 contract IOwnable {
2380 
2381     function transferOwnership(address newOwner)
2382         public;
2383 }
2384 
2385 
2386 contract Ownable is
2387     IOwnable
2388 {
2389     address public owner;
2390 
2391     constructor ()
2392         public
2393     {
2394         owner = msg.sender;
2395     }
2396 
2397     modifier onlyOwner() {
2398         require(
2399             msg.sender == owner,
2400             "ONLY_CONTRACT_OWNER"
2401         );
2402         _;
2403     }
2404 
2405     function transferOwnership(address newOwner)
2406         public
2407         onlyOwner
2408     {
2409         if (newOwner != address(0)) {
2410             owner = newOwner;
2411         }
2412     }
2413 }
2414 
2415 /*
2416 
2417   Copyright 2018 ZeroEx Intl.
2418 
2419   Licensed under the Apache License, Version 2.0 (the "License");
2420   you may not use this file except in compliance with the License.
2421   You may obtain a copy of the License at
2422 
2423     http://www.apache.org/licenses/LICENSE-2.0
2424 
2425   Unless required by applicable law or agreed to in writing, software
2426   distributed under the License is distributed on an "AS IS" BASIS,
2427   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2428   See the License for the specific language governing permissions and
2429   limitations under the License.
2430 
2431 */
2432 
2433 
2434 contract IERC721Token {
2435 
2436     /// @dev This emits when ownership of any NFT changes by any mechanism.
2437     ///      This event emits when NFTs are created (`from` == 0) and destroyed
2438     ///      (`to` == 0). Exception: during contract creation, any number of NFTs
2439     ///      may be created and assigned without emitting Transfer. At the time of
2440     ///      any transfer, the approved address for that NFT (if any) is reset to none.
2441     event Transfer(
2442         address indexed _from,
2443         address indexed _to,
2444         uint256 indexed _tokenId
2445     );
2446 
2447     /// @dev This emits when the approved address for an NFT is changed or
2448     ///      reaffirmed. The zero address indicates there is no approved address.
2449     ///      When a Transfer event emits, this also indicates that the approved
2450     ///      address for that NFT (if any) is reset to none.
2451     event Approval(
2452         address indexed _owner,
2453         address indexed _approved,
2454         uint256 indexed _tokenId
2455     );
2456 
2457     /// @dev This emits when an operator is enabled or disabled for an owner.
2458     ///      The operator can manage all NFTs of the owner.
2459     event ApprovalForAll(
2460         address indexed _owner,
2461         address indexed _operator,
2462         bool _approved
2463     );
2464 
2465     /// @notice Transfers the ownership of an NFT from one address to another address
2466     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2467     ///      perator, or the approved address for this NFT. Throws if `_from` is
2468     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2469     ///      `_tokenId` is not a valid NFT. When transfer is complete, this function
2470     ///      checks if `_to` is a smart contract (code size > 0). If so, it calls
2471     ///      `onERC721Received` on `_to` and throws if the return value is not
2472     ///      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
2473     /// @param _from The current owner of the NFT
2474     /// @param _to The new owner
2475     /// @param _tokenId The NFT to transfer
2476     /// @param _data Additional data with no specified format, sent in call to `_to`
2477     function safeTransferFrom(
2478         address _from,
2479         address _to,
2480         uint256 _tokenId,
2481         bytes _data
2482     )
2483         external;
2484 
2485     /// @notice Transfers the ownership of an NFT from one address to another address
2486     /// @dev This works identically to the other function with an extra data parameter,
2487     ///      except this function just sets data to "".
2488     /// @param _from The current owner of the NFT
2489     /// @param _to The new owner
2490     /// @param _tokenId The NFT to transfer
2491     function safeTransferFrom(
2492         address _from,
2493         address _to,
2494         uint256 _tokenId
2495     )
2496         external;
2497 
2498     /// @notice Change or reaffirm the approved address for an NFT
2499     /// @dev The zero address indicates there is no approved address.
2500     ///      Throws unless `msg.sender` is the current NFT owner, or an authorized
2501     ///      operator of the current owner.
2502     /// @param _approved The new approved NFT controller
2503     /// @param _tokenId The NFT to approve
2504     function approve(address _approved, uint256 _tokenId)
2505         external;
2506 
2507     /// @notice Enable or disable approval for a third party ("operator") to manage
2508     ///         all of `msg.sender`'s assets
2509     /// @dev Emits the ApprovalForAll event. The contract MUST allow
2510     ///      multiple operators per owner.
2511     /// @param _operator Address to add to the set of authorized operators
2512     /// @param _approved True if the operator is approved, false to revoke approval
2513     function setApprovalForAll(address _operator, bool _approved)
2514         external;
2515 
2516     /// @notice Count all NFTs assigned to an owner
2517     /// @dev NFTs assigned to the zero address are considered invalid, and this
2518     ///      function throws for queries about the zero address.
2519     /// @param _owner An address for whom to query the balance
2520     /// @return The number of NFTs owned by `_owner`, possibly zero
2521     function balanceOf(address _owner)
2522         external
2523         view
2524         returns (uint256);
2525 
2526     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
2527     ///         TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
2528     ///         THEY MAY BE PERMANENTLY LOST
2529     /// @dev Throws unless `msg.sender` is the current owner, an authorized
2530     ///      operator, or the approved address for this NFT. Throws if `_from` is
2531     ///      not the current owner. Throws if `_to` is the zero address. Throws if
2532     ///      `_tokenId` is not a valid NFT.
2533     /// @param _from The current owner of the NFT
2534     /// @param _to The new owner
2535     /// @param _tokenId The NFT to transfer
2536     function transferFrom(
2537         address _from,
2538         address _to,
2539         uint256 _tokenId
2540     )
2541         public;
2542 
2543     /// @notice Find the owner of an NFT
2544     /// @dev NFTs assigned to zero address are considered invalid, and queries
2545     ///      about them do throw.
2546     /// @param _tokenId The identifier for an NFT
2547     /// @return The address of the owner of the NFT
2548     function ownerOf(uint256 _tokenId)
2549         public
2550         view
2551         returns (address);
2552 
2553     /// @notice Get the approved address for a single NFT
2554     /// @dev Throws if `_tokenId` is not a valid NFT.
2555     /// @param _tokenId The NFT to find the approved address for
2556     /// @return The approved address for this NFT, or the zero address if there is none
2557     function getApproved(uint256 _tokenId)
2558         public
2559         view
2560         returns (address);
2561 
2562     /// @notice Query if an address is an authorized operator for another address
2563     /// @param _owner The address that owns the NFTs
2564     /// @param _operator The address that acts on behalf of the owner
2565     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
2566     function isApprovedForAll(address _owner, address _operator)
2567         public
2568         view
2569         returns (bool);
2570 }
2571 
2572 /*
2573 
2574   Copyright 2018 ZeroEx Intl.
2575 
2576   Licensed under the Apache License, Version 2.0 (the "License");
2577   you may not use this file except in compliance with the License.
2578   You may obtain a copy of the License at
2579 
2580     http://www.apache.org/licenses/LICENSE-2.0
2581 
2582   Unless required by applicable law or agreed to in writing, software
2583   distributed under the License is distributed on an "AS IS" BASIS,
2584   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2585   See the License for the specific language governing permissions and
2586   limitations under the License.
2587 
2588 */
2589 
2590 
2591 
2592 contract MixinAssets is
2593     Ownable,
2594     LibConstants,
2595     MAssets
2596 {
2597     using LibBytes for bytes;
2598 
2599     bytes4 constant internal ERC20_TRANSFER_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
2600 
2601     /// @dev Withdraws assets from this contract. The contract requires a ZRX balance in order to
2602     ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
2603     ///      used to withdraw assets that were accidentally sent to this contract.
2604     /// @param assetData Byte array encoded for the respective asset proxy.
2605     /// @param amount Amount of ERC20 token to withdraw.
2606     function withdrawAsset(
2607         bytes assetData,
2608         uint256 amount
2609     )
2610         external
2611         onlyOwner
2612     {
2613         transferAssetToSender(assetData, amount);
2614     }
2615 
2616     /// @dev Transfers given amount of asset to sender.
2617     /// @param assetData Byte array encoded for the respective asset proxy.
2618     /// @param amount Amount of asset to transfer to sender.
2619     function transferAssetToSender(
2620         bytes memory assetData,
2621         uint256 amount
2622     )
2623         internal
2624     {
2625         bytes4 proxyId = assetData.readBytes4(0);
2626 
2627         if (proxyId == ERC20_DATA_ID) {
2628             transferERC20Token(assetData, amount);
2629         } else if (proxyId == ERC721_DATA_ID) {
2630             transferERC721Token(assetData, amount);
2631         } else {
2632             revert("UNSUPPORTED_ASSET_PROXY");
2633         }
2634     }
2635 
2636     /// @dev Decodes ERC20 assetData and transfers given amount to sender.
2637     /// @param assetData Byte array encoded for the respective asset proxy.
2638     /// @param amount Amount of asset to transfer to sender.
2639     function transferERC20Token(
2640         bytes memory assetData,
2641         uint256 amount
2642     )
2643         internal
2644     {
2645         address token = assetData.readAddress(16);
2646 
2647         // Transfer tokens.
2648         // We do a raw call so we can check the success separate
2649         // from the return data.
2650         bool success = token.call(abi.encodeWithSelector(
2651             ERC20_TRANSFER_SELECTOR,
2652             msg.sender,
2653             amount
2654         ));
2655         require(
2656             success,
2657             "TRANSFER_FAILED"
2658         );
2659 
2660         // Check return data.
2661         // If there is no return data, we assume the token incorrectly
2662         // does not return a bool. In this case we expect it to revert
2663         // on failure, which was handled above.
2664         // If the token does return data, we require that it is a single
2665         // value that evaluates to true.
2666         assembly {
2667             if returndatasize {
2668                 success := 0
2669                 if eq(returndatasize, 32) {
2670                     // First 64 bytes of memory are reserved scratch space
2671                     returndatacopy(0, 0, 32)
2672                     success := mload(0)
2673                 }
2674             }
2675         }
2676         require(
2677             success,
2678             "TRANSFER_FAILED"
2679         );
2680     }
2681 
2682     /// @dev Decodes ERC721 assetData and transfers given amount to sender.
2683     /// @param assetData Byte array encoded for the respective asset proxy.
2684     /// @param amount Amount of asset to transfer to sender.
2685     function transferERC721Token(
2686         bytes memory assetData,
2687         uint256 amount
2688     )
2689         internal
2690     {
2691         require(
2692             amount == 1,
2693             "INVALID_AMOUNT"
2694         );
2695         // Decode asset data.
2696         address token = assetData.readAddress(16);
2697         uint256 tokenId = assetData.readUint256(36);
2698 
2699         // Perform transfer.
2700         IERC721Token(token).transferFrom(
2701             address(this),
2702             msg.sender,
2703             tokenId
2704         );
2705     }
2706 }
2707 
2708 /*
2709 
2710   Copyright 2018 ZeroEx Intl.
2711 
2712   Licensed under the Apache License, Version 2.0 (the "License");
2713   you may not use this file except in compliance with the License.
2714   You may obtain a copy of the License at
2715 
2716     http://www.apache.org/licenses/LICENSE-2.0
2717 
2718   Unless required by applicable law or agreed to in writing, software
2719   distributed under the License is distributed on an "AS IS" BASIS,
2720   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2721   See the License for the specific language governing permissions and
2722   limitations under the License.
2723 
2724 */
2725 
2726 
2727 
2728 /*
2729 
2730   Copyright 2018 ZeroEx Intl.
2731 
2732   Licensed under the Apache License, Version 2.0 (the "License");
2733   you may not use this file except in compliance with the License.
2734   You may obtain a copy of the License at
2735 
2736     http://www.apache.org/licenses/LICENSE-2.0
2737 
2738   Unless required by applicable law or agreed to in writing, software
2739   distributed under the License is distributed on an "AS IS" BASIS,
2740   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2741   See the License for the specific language governing permissions and
2742   limitations under the License.
2743 
2744 */
2745 
2746 
2747 
2748 contract LibAbiEncoder {
2749 
2750     /// @dev ABI encodes calldata for `fillOrder`.
2751     /// @param order Order struct containing order specifications.
2752     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2753     /// @param signature Proof that order has been created by maker.
2754     /// @return ABI encoded calldata for `fillOrder`.
2755     function abiEncodeFillOrder(
2756         LibOrder.Order memory order,
2757         uint256 takerAssetFillAmount,
2758         bytes memory signature
2759     )
2760         internal
2761         pure
2762         returns (bytes memory fillOrderCalldata)
2763     {
2764         // We need to call MExchangeCore.fillOrder using a delegatecall in
2765         // assembly so that we can intercept a call that throws. For this, we
2766         // need the input encoded in memory in the Ethereum ABIv2 format [1].
2767 
2768         // | Area     | Offset | Length  | Contents                                    |
2769         // | -------- |--------|---------|-------------------------------------------- |
2770         // | Header   | 0x00   | 4       | function selector                           |
2771         // | Params   |        | 3 * 32  | function parameters:                        |
2772         // |          | 0x00   |         |   1. offset to order (*)                    |
2773         // |          | 0x20   |         |   2. takerAssetFillAmount                   |
2774         // |          | 0x40   |         |   3. offset to signature (*)                |
2775         // | Data     |        | 12 * 32 | order:                                      |
2776         // |          | 0x000  |         |   1.  senderAddress                         |
2777         // |          | 0x020  |         |   2.  makerAddress                          |
2778         // |          | 0x040  |         |   3.  takerAddress                          |
2779         // |          | 0x060  |         |   4.  feeRecipientAddress                   |
2780         // |          | 0x080  |         |   5.  makerAssetAmount                      |
2781         // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
2782         // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
2783         // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
2784         // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
2785         // |          | 0x120  |         |   10. salt                                  |
2786         // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
2787         // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
2788         // |          | 0x180  | 32      | makerAssetData Length                       |
2789         // |          | 0x1A0  | **      | makerAssetData Contents                     |
2790         // |          | 0x1C0  | 32      | takerAssetData Length                       |
2791         // |          | 0x1E0  | **      | takerAssetData Contents                     |
2792         // |          | 0x200  | 32      | signature Length                            |
2793         // |          | 0x220  | **      | signature Contents                          |
2794 
2795         // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
2796         //     An offset stored in the Params area is calculated from the beginning of the Params section.
2797         //     An offset stored in the Data area is calculated from the beginning of the Data section.
2798 
2799         // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.
2800 
2801         // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html
2802 
2803         assembly {
2804 
2805             // Areas below may use the following variables:
2806             //   1. <area>Start   -- Start of this area in memory
2807             //   2. <area>End     -- End of this area in memory. This value may
2808             //                       be precomputed (before writing contents),
2809             //                       or it may be computed as contents are written.
2810             //   3. <area>Offset  -- Current offset into area. If an area's End
2811             //                       is precomputed, this variable tracks the
2812             //                       offsets of contents as they are written.
2813 
2814             /////// Setup Header Area ///////
2815             // Load free memory pointer
2816             fillOrderCalldata := mload(0x40)
2817             // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
2818             // = 0xb4be83d5
2819             // Leave 0x20 bytes to store the length
2820             mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
2821             let headerAreaEnd := add(fillOrderCalldata, 0x24)
2822 
2823             /////// Setup Params Area ///////
2824             // This area is preallocated and written to later.
2825             // This is because we need to fill in offsets that have not yet been calculated.
2826             let paramsAreaStart := headerAreaEnd
2827             let paramsAreaEnd := add(paramsAreaStart, 0x60)
2828             let paramsAreaOffset := paramsAreaStart
2829 
2830             /////// Setup Data Area ///////
2831             let dataAreaStart := paramsAreaEnd
2832             let dataAreaEnd := dataAreaStart
2833 
2834             // Offset from the source data we're reading from
2835             let sourceOffset := order
2836             // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
2837             let arrayLenBytes := 0
2838             let arrayLenWords := 0
2839 
2840             /////// Write order Struct ///////
2841             // Write memory location of Order, relative to the start of the
2842             // parameter list, then increment the paramsAreaOffset respectively.
2843             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2844             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2845 
2846             // Write values for each field in the order
2847             // It would be nice to use a loop, but we save on gas by writing
2848             // the stores sequentially.
2849             mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
2850             mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
2851             mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
2852             mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
2853             mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
2854             mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
2855             mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
2856             mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
2857             mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
2858             mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
2859             mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
2860             mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
2861             dataAreaEnd := add(dataAreaEnd, 0x180)
2862             sourceOffset := add(sourceOffset, 0x180)
2863 
2864             // Write offset to <order.makerAssetData>
2865             mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))
2866 
2867             // Calculate length of <order.makerAssetData>
2868             sourceOffset := mload(add(order, 0x140)) // makerAssetData
2869             arrayLenBytes := mload(sourceOffset)
2870             sourceOffset := add(sourceOffset, 0x20)
2871             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2872 
2873             // Write length of <order.makerAssetData>
2874             mstore(dataAreaEnd, arrayLenBytes)
2875             dataAreaEnd := add(dataAreaEnd, 0x20)
2876 
2877             // Write contents of <order.makerAssetData>
2878             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2879                 mstore(dataAreaEnd, mload(sourceOffset))
2880                 dataAreaEnd := add(dataAreaEnd, 0x20)
2881                 sourceOffset := add(sourceOffset, 0x20)
2882             }
2883 
2884             // Write offset to <order.takerAssetData>
2885             mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))
2886 
2887             // Calculate length of <order.takerAssetData>
2888             sourceOffset := mload(add(order, 0x160)) // takerAssetData
2889             arrayLenBytes := mload(sourceOffset)
2890             sourceOffset := add(sourceOffset, 0x20)
2891             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2892 
2893             // Write length of <order.takerAssetData>
2894             mstore(dataAreaEnd, arrayLenBytes)
2895             dataAreaEnd := add(dataAreaEnd, 0x20)
2896 
2897             // Write contents of  <order.takerAssetData>
2898             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2899                 mstore(dataAreaEnd, mload(sourceOffset))
2900                 dataAreaEnd := add(dataAreaEnd, 0x20)
2901                 sourceOffset := add(sourceOffset, 0x20)
2902             }
2903 
2904             /////// Write takerAssetFillAmount ///////
2905             mstore(paramsAreaOffset, takerAssetFillAmount)
2906             paramsAreaOffset := add(paramsAreaOffset, 0x20)
2907 
2908             /////// Write signature ///////
2909             // Write offset to paramsArea
2910             mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
2911 
2912             // Calculate length of signature
2913             sourceOffset := signature
2914             arrayLenBytes := mload(sourceOffset)
2915             sourceOffset := add(sourceOffset, 0x20)
2916             arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)
2917 
2918             // Write length of signature
2919             mstore(dataAreaEnd, arrayLenBytes)
2920             dataAreaEnd := add(dataAreaEnd, 0x20)
2921 
2922             // Write contents of signature
2923             for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
2924                 mstore(dataAreaEnd, mload(sourceOffset))
2925                 dataAreaEnd := add(dataAreaEnd, 0x20)
2926                 sourceOffset := add(sourceOffset, 0x20)
2927             }
2928 
2929             // Set length of calldata
2930             mstore(fillOrderCalldata, sub(dataAreaEnd, add(fillOrderCalldata, 0x20)))
2931 
2932             // Increment free memory pointer
2933             mstore(0x40, dataAreaEnd)
2934         }
2935 
2936         return fillOrderCalldata;
2937     }
2938 }
2939 
2940 /*
2941 
2942   Copyright 2018 ZeroEx Intl.
2943 
2944   Licensed under the Apache License, Version 2.0 (the "License");
2945   you may not use this file except in compliance with the License.
2946   You may obtain a copy of the License at
2947 
2948     http://www.apache.org/licenses/LICENSE-2.0
2949 
2950   Unless required by applicable law or agreed to in writing, software
2951   distributed under the License is distributed on an "AS IS" BASIS,
2952   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2953   See the License for the specific language governing permissions and
2954   limitations under the License.
2955 
2956 */
2957 
2958 
2959 contract MixinExchangeWrapper is
2960     LibAbiEncoder,
2961     LibFillResults,
2962     LibMath,
2963     LibConstants,
2964     MExchangeWrapper
2965 {
2966     /// @dev Fills the input order.
2967     ///      Returns false if the transaction would otherwise revert.
2968     /// @param order Order struct containing order specifications.
2969     /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
2970     /// @param signature Proof that order has been created by maker.
2971     /// @return Amounts filled and fees paid by maker and taker.
2972     function fillOrderNoThrow(
2973         LibOrder.Order memory order,
2974         uint256 takerAssetFillAmount,
2975         bytes memory signature
2976     )
2977         internal
2978         returns (FillResults memory fillResults)
2979     {
2980         // ABI encode calldata for `fillOrder`
2981         bytes memory fillOrderCalldata = abiEncodeFillOrder(
2982             order,
2983             takerAssetFillAmount,
2984             signature
2985         );
2986 
2987         address exchange = address(EXCHANGE);
2988 
2989         // Call `fillOrder` and handle any exceptions gracefully
2990         assembly {
2991             let success := call(
2992                 gas,                                // forward all gas
2993                 exchange,                           // call address of Exchange contract
2994                 0,                                  // transfer 0 wei
2995                 add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
2996                 mload(fillOrderCalldata),           // length of input
2997                 fillOrderCalldata,                  // write output over input
2998                 128                                 // output size is 128 bytes
2999             )
3000             if success {
3001                 mstore(fillResults, mload(fillOrderCalldata))
3002                 mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
3003                 mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
3004                 mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
3005             }
3006         }
3007         // fillResults values will be 0 by default if call was unsuccessful
3008         return fillResults;
3009     }
3010 
3011     /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
3012     ///      Returns false if the transaction would otherwise revert.
3013     /// @param orders Array of order specifications.
3014     /// @param wethSellAmount Desired amount of WETH to sell.
3015     /// @param signatures Proofs that orders have been signed by makers.
3016     /// @return Amounts filled and fees paid by makers and taker.
3017     function marketSellWeth(
3018         LibOrder.Order[] memory orders,
3019         uint256 wethSellAmount,
3020         bytes[] memory signatures
3021     )
3022         internal
3023         returns (FillResults memory totalFillResults)
3024     {
3025         bytes memory makerAssetData = orders[0].makerAssetData;
3026         bytes memory wethAssetData = WETH_ASSET_DATA;
3027 
3028         uint256 ordersLength = orders.length;
3029         for (uint256 i = 0; i != ordersLength; i++) {
3030 
3031             // We assume that asset being bought by taker is the same for each order.
3032             // We assume that asset being sold by taker is WETH for each order.
3033             orders[i].makerAssetData = makerAssetData;
3034             orders[i].takerAssetData = wethAssetData;
3035 
3036             // Calculate the remaining amount of WETH to sell
3037             uint256 remainingTakerAssetFillAmount = safeSub(wethSellAmount, totalFillResults.takerAssetFilledAmount);
3038 
3039             // Attempt to sell the remaining amount of WETH
3040             FillResults memory singleFillResults = fillOrderNoThrow(
3041                 orders[i],
3042                 remainingTakerAssetFillAmount,
3043                 signatures[i]
3044             );
3045 
3046             // Update amounts filled and fees paid by maker and taker
3047             addFillResults(totalFillResults, singleFillResults);
3048 
3049             // Stop execution if the entire amount of takerAsset has been sold
3050             if (totalFillResults.takerAssetFilledAmount >= wethSellAmount) {
3051                 break;
3052             }
3053         }
3054         return totalFillResults;
3055     }
3056 
3057     /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
3058     ///      Returns false if the transaction would otherwise revert.
3059     ///      The asset being sold by taker must always be WETH.
3060     /// @param orders Array of order specifications.
3061     /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
3062     /// @param signatures Proofs that orders have been signed by makers.
3063     /// @return Amounts filled and fees paid by makers and taker.
3064     function marketBuyExactAmountWithWeth(
3065         LibOrder.Order[] memory orders,
3066         uint256 makerAssetFillAmount,
3067         bytes[] memory signatures
3068     )
3069         internal
3070         returns (FillResults memory totalFillResults)
3071     {
3072         bytes memory makerAssetData = orders[0].makerAssetData;
3073         bytes memory wethAssetData = WETH_ASSET_DATA;
3074 
3075         uint256 ordersLength = orders.length;
3076         for (uint256 i = 0; i != ordersLength; i++) {
3077 
3078             // We assume that asset being bought by taker is the same for each order.
3079             // We assume that asset being sold by taker is WETH for each order.
3080             orders[i].makerAssetData = makerAssetData;
3081             orders[i].takerAssetData = wethAssetData;
3082 
3083             // Calculate the remaining amount of makerAsset to buy
3084             uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);
3085 
3086             // Convert the remaining amount of makerAsset to buy into remaining amount
3087             // of takerAsset to sell, assuming entire amount can be sold in the current order.
3088             // We round up because the exchange rate computed by fillOrder rounds in favor
3089             // of the Maker. In this case we want to overestimate the amount of takerAsset.
3090             uint256 remainingTakerAssetFillAmount = getPartialAmountCeil(
3091                 orders[i].takerAssetAmount,
3092                 orders[i].makerAssetAmount,
3093                 remainingMakerAssetFillAmount
3094             );
3095 
3096             // Attempt to sell the remaining amount of takerAsset
3097             FillResults memory singleFillResults = fillOrderNoThrow(
3098                 orders[i],
3099                 remainingTakerAssetFillAmount,
3100                 signatures[i]
3101             );
3102 
3103             // Update amounts filled and fees paid by maker and taker
3104             addFillResults(totalFillResults, singleFillResults);
3105 
3106             // Stop execution if the entire amount of makerAsset has been bought
3107             uint256 makerAssetFilledAmount = totalFillResults.makerAssetFilledAmount;
3108             if (makerAssetFilledAmount >= makerAssetFillAmount) {
3109                 break;
3110             }
3111         }
3112 
3113         require(
3114             makerAssetFilledAmount >= makerAssetFillAmount,
3115             "COMPLETE_FILL_FAILED"
3116         );
3117         return totalFillResults;
3118     }
3119 
3120     /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
3121     ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
3122     ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
3123     ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
3124     ///      The asset being sold by taker must always be WETH.
3125     /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
3126     /// @param zrxBuyAmount Desired amount of ZRX to buy.
3127     /// @param signatures Proofs that orders have been created by makers.
3128     /// @return totalFillResults Amounts filled and fees paid by maker and taker.
3129     function marketBuyExactZrxWithWeth(
3130         LibOrder.Order[] memory orders,
3131         uint256 zrxBuyAmount,
3132         bytes[] memory signatures
3133     )
3134         internal
3135         returns (FillResults memory totalFillResults)
3136     {
3137         // Do nothing if zrxBuyAmount == 0
3138         if (zrxBuyAmount == 0) {
3139             return totalFillResults;
3140         }
3141 
3142         bytes memory zrxAssetData = ZRX_ASSET_DATA;
3143         bytes memory wethAssetData = WETH_ASSET_DATA;
3144         uint256 zrxPurchased = 0;
3145 
3146         uint256 ordersLength = orders.length;
3147         for (uint256 i = 0; i != ordersLength; i++) {
3148 
3149             // All of these are ZRX/WETH, so we can drop the respective assetData from calldata.
3150             orders[i].makerAssetData = zrxAssetData;
3151             orders[i].takerAssetData = wethAssetData;
3152 
3153             // Calculate the remaining amount of ZRX to buy.
3154             uint256 remainingZrxBuyAmount = safeSub(zrxBuyAmount, zrxPurchased);
3155 
3156             // Convert the remaining amount of ZRX to buy into remaining amount
3157             // of WETH to sell, assuming entire amount can be sold in the current order.
3158             // We round up because the exchange rate computed by fillOrder rounds in favor
3159             // of the Maker. In this case we want to overestimate the amount of takerAsset.
3160             uint256 remainingWethSellAmount = getPartialAmountCeil(
3161                 orders[i].takerAssetAmount,
3162                 safeSub(orders[i].makerAssetAmount, orders[i].takerFee),  // our exchange rate after fees
3163                 remainingZrxBuyAmount
3164             );
3165 
3166             // Attempt to sell the remaining amount of WETH.
3167             FillResults memory singleFillResult = fillOrderNoThrow(
3168                 orders[i],
3169                 remainingWethSellAmount,
3170                 signatures[i]
3171             );
3172 
3173             // Update amounts filled and fees paid by maker and taker.
3174             addFillResults(totalFillResults, singleFillResult);
3175             zrxPurchased = safeSub(totalFillResults.makerAssetFilledAmount, totalFillResults.takerFeePaid);
3176 
3177             // Stop execution if the entire amount of ZRX has been bought.
3178             if (zrxPurchased >= zrxBuyAmount) {
3179                 break;
3180             }
3181         }
3182 
3183         require(
3184             zrxPurchased >= zrxBuyAmount,
3185             "COMPLETE_FILL_FAILED"
3186         );
3187         return totalFillResults;
3188     }
3189 }
3190 
3191 /*
3192 
3193   Copyright 2018 ZeroEx Intl.
3194 
3195   Licensed under the Apache License, Version 2.0 (the "License");
3196   you may not use this file except in compliance with the License.
3197   You may obtain a copy of the License at
3198 
3199     http://www.apache.org/licenses/LICENSE-2.0
3200 
3201   Unless required by applicable law or agreed to in writing, software
3202   distributed under the License is distributed on an "AS IS" BASIS,
3203   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
3204   See the License for the specific language governing permissions and
3205   limitations under the License.
3206 
3207 */
3208 
3209 
3210 
3211 // solhint-disable no-empty-blocks
3212 contract Forwarder is
3213     LibConstants,
3214     MixinWeth,
3215     MixinAssets,
3216     MixinExchangeWrapper,
3217     MixinForwarderCore
3218 {
3219     constructor (
3220         address _exchange,
3221         bytes memory _zrxAssetData,
3222         bytes memory _wethAssetData
3223     )
3224         public
3225         LibConstants(
3226             _exchange,
3227             _zrxAssetData,
3228             _wethAssetData
3229         )
3230         MixinForwarderCore()
3231     {}
3232 }