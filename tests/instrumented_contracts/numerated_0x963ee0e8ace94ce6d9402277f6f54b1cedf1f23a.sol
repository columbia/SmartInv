1 pragma solidity ^0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 // File: contracts/lib/ERC20SafeTransfer.sol
5 
6 /*
7 
8   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
9 
10   Licensed under the Apache License, Version 2.0 (the "License");
11   you may not use this file except in compliance with the License.
12   You may obtain a copy of the License at
13 
14   http://www.apache.org/licenses/LICENSE-2.0
15 
16   Unless required by applicable law or agreed to in writing, software
17   distributed under the License is distributed on an "AS IS" BASIS,
18   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
19   See the License for the specific language governing permissions and
20   limitations under the License.
21 */
22 
23 /// @title ERC20 safe transfer
24 /// @dev see https://github.com/sec-bit/badERC20Fix
25 /// @author Brecht Devos - <brecht@loopring.org>
26 library ERC20SafeTransfer {
27 
28     function safeTransfer(
29         address token,
30         address to,
31         uint256 value)
32     internal
33     returns (bool success)
34     {
35         // A transfer is successful when 'call' is successful and depending on the token:
36         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
37         // - A single boolean is returned: this boolean needs to be true (non-zero)
38 
39         // bytes4(keccak256("transfer(address,uint256)")) = 0xa9059cbb
40         bytes memory callData = abi.encodeWithSelector(
41             bytes4(0xa9059cbb),
42             to,
43             value
44         );
45         (success, ) = token.call(callData);
46         return checkReturnValue(success);
47     }
48 
49     function safeTransferFrom(
50         address token,
51         address from,
52         address to,
53         uint256 value)
54     internal
55     returns (bool success)
56     {
57         // A transferFrom is successful when 'call' is successful and depending on the token:
58         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
59         // - A single boolean is returned: this boolean needs to be true (non-zero)
60 
61         // bytes4(keccak256("transferFrom(address,address,uint256)")) = 0x23b872dd
62         bytes memory callData = abi.encodeWithSelector(
63             bytes4(0x23b872dd),
64             from,
65             to,
66             value
67         );
68         (success, ) = token.call(callData);
69         return checkReturnValue(success);
70     }
71 
72     function checkReturnValue(
73         bool success
74     )
75     internal
76     pure
77     returns (bool)
78     {
79         // A transfer/transferFrom is successful when 'call' is successful and depending on the token:
80         // - No value is returned: we assume a revert when the transfer failed (i.e. 'call' returns false)
81         // - A single boolean is returned: this boolean needs to be true (non-zero)
82         if (success) {
83             assembly {
84                 switch returndatasize()
85                 // Non-standard ERC20: nothing is returned so if 'call' was successful we assume the transfer succeeded
86                 case 0 {
87                     success := 1
88                 }
89                 // Standard ERC20: a single boolean value is returned which needs to be true
90                 case 32 {
91                     returndatacopy(0, 0, 32)
92                     success := mload(0)
93                 }
94                 // None of the above: not successful
95                 default {
96                     success := 0
97                 }
98             }
99         }
100         return success;
101     }
102 
103 }
104 
105 // File: contracts/lib/LibBytes.sol
106 
107 // Modified from 0x LibBytes
108 /*
109 
110   Copyright 2018 ZeroEx Intl.
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
125 library LibBytes {
126 
127     using LibBytes for bytes;
128 
129     /// @dev Gets the memory address for the contents of a byte array.
130     /// @param input Byte array to lookup.
131     /// @return memoryAddress Memory address of the contents of the byte array.
132     function contentAddress(bytes memory input)
133     internal
134     pure
135     returns (uint256 memoryAddress)
136     {
137         assembly {
138             memoryAddress := add(input, 32)
139         }
140         return memoryAddress;
141     }
142 
143     /// @dev Copies `length` bytes from memory location `source` to `dest`.
144     /// @param dest memory address to copy bytes to.
145     /// @param source memory address to copy bytes from.
146     /// @param length number of bytes to copy.
147     function memCopy(
148         uint256 dest,
149         uint256 source,
150         uint256 length
151     )
152     internal
153     pure
154     {
155         if (length < 32) {
156             // Handle a partial word by reading destination and masking
157             // off the bits we are interested in.
158             // This correctly handles overlap, zero lengths and source == dest
159             assembly {
160                 let mask := sub(exp(256, sub(32, length)), 1)
161                 let s := and(mload(source), not(mask))
162                 let d := and(mload(dest), mask)
163                 mstore(dest, or(s, d))
164             }
165         } else {
166             // Skip the O(length) loop when source == dest.
167             if (source == dest) {
168                 return;
169             }
170 
171             // For large copies we copy whole words at a time. The final
172             // word is aligned to the end of the range (instead of after the
173             // previous) to handle partial words. So a copy will look like this:
174             //
175             //  ####
176             //      ####
177             //          ####
178             //            ####
179             //
180             // We handle overlap in the source and destination range by
181             // changing the copying direction. This prevents us from
182             // overwriting parts of source that we still need to copy.
183             //
184             // This correctly handles source == dest
185             //
186             if (source > dest) {
187                 assembly {
188                 // We subtract 32 from `sEnd` and `dEnd` because it
189                 // is easier to compare with in the loop, and these
190                 // are also the addresses we need for copying the
191                 // last bytes.
192                     length := sub(length, 32)
193                     let sEnd := add(source, length)
194                     let dEnd := add(dest, length)
195 
196                 // Remember the last 32 bytes of source
197                 // This needs to be done here and not after the loop
198                 // because we may have overwritten the last bytes in
199                 // source already due to overlap.
200                     let last := mload(sEnd)
201 
202                 // Copy whole words front to back
203                 // Note: the first check is always true,
204                 // this could have been a do-while loop.
205                 // solhint-disable-next-line no-empty-blocks
206                     for {} lt(source, sEnd) {} {
207                         mstore(dest, mload(source))
208                         source := add(source, 32)
209                         dest := add(dest, 32)
210                     }
211 
212                 // Write the last 32 bytes
213                     mstore(dEnd, last)
214                 }
215             } else {
216                 assembly {
217                 // We subtract 32 from `sEnd` and `dEnd` because those
218                 // are the starting points when copying a word at the end.
219                     length := sub(length, 32)
220                     let sEnd := add(source, length)
221                     let dEnd := add(dest, length)
222 
223                 // Remember the first 32 bytes of source
224                 // This needs to be done here and not after the loop
225                 // because we may have overwritten the first bytes in
226                 // source already due to overlap.
227                     let first := mload(source)
228 
229                 // Copy whole words back to front
230                 // We use a signed comparisson here to allow dEnd to become
231                 // negative (happens when source and dest < 32). Valid
232                 // addresses in local memory will never be larger than
233                 // 2**255, so they can be safely re-interpreted as signed.
234                 // Note: the first check is always true,
235                 // this could have been a do-while loop.
236                 // solhint-disable-next-line no-empty-blocks
237                     for {} slt(dest, dEnd) {} {
238                         mstore(dEnd, mload(sEnd))
239                         sEnd := sub(sEnd, 32)
240                         dEnd := sub(dEnd, 32)
241                     }
242 
243                 // Write the first 32 bytes
244                     mstore(dest, first)
245                 }
246             }
247         }
248     }
249 
250     /// @dev Returns a slices from a byte array.
251     /// @param b The byte array to take a slice from.
252     /// @param from The starting index for the slice (inclusive).
253     /// @param to The final index for the slice (exclusive).
254     /// @return result The slice containing bytes at indices [from, to)
255     function slice(
256         bytes memory b,
257         uint256 from,
258         uint256 to
259     )
260     internal
261     pure
262     returns (bytes memory result)
263     {
264         if (from > to || to > b.length) {
265             return "";
266         }
267 
268         // Create a new bytes structure and copy contents
269         result = new bytes(to - from);
270         memCopy(
271             result.contentAddress(),
272             b.contentAddress() + from,
273             result.length
274         );
275         return result;
276     }
277 
278     /// @dev Reads an address from a position in a byte array.
279     /// @param b Byte array containing an address.
280     /// @param index Index in byte array of address.
281     /// @return address from byte array.
282     function readAddress(
283         bytes memory b,
284         uint256 index
285     )
286     internal
287     pure
288     returns (address result)
289     {
290         require(
291             b.length >= index + 20,  // 20 is length of address
292             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
293         );
294 
295         // Add offset to index:
296         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
297         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
298         index += 20;
299 
300         // Read address from array memory
301         assembly {
302         // 1. Add index to address of bytes array
303         // 2. Load 32-byte word from memory
304         // 3. Apply 20-byte mask to obtain address
305             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
306         }
307         return result;
308     }
309 
310     /// @dev Reads a bytes32 value from a position in a byte array.
311     /// @param b Byte array containing a bytes32 value.
312     /// @param index Index in byte array of bytes32 value.
313     /// @return bytes32 value from byte array.
314     function readBytes32(
315         bytes memory b,
316         uint256 index
317     )
318     internal
319     pure
320     returns (bytes32 result)
321     {
322         require(
323             b.length >= index + 32,
324             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
325         );
326 
327         // Arrays are prefixed by a 256 bit length parameter
328         index += 32;
329 
330         // Read the bytes32 from array memory
331         assembly {
332             result := mload(add(b, index))
333         }
334         return result;
335     }
336 
337     /// @dev Reads a uint256 value from a position in a byte array.
338     /// @param b Byte array containing a uint256 value.
339     /// @param index Index in byte array of uint256 value.
340     /// @return uint256 value from byte array.
341     function readUint256(
342         bytes memory b,
343         uint256 index
344     )
345     internal
346     pure
347     returns (uint256 result)
348     {
349         result = uint256(readBytes32(b, index));
350         return result;
351     }
352 
353     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
354     /// @param b Byte array containing a bytes4 value.
355     /// @param index Index in byte array of bytes4 value.
356     /// @return bytes4 value from byte array.
357     function readBytes4(
358         bytes memory b,
359         uint256 index
360     )
361     internal
362     pure
363     returns (bytes4 result)
364     {
365         require(
366             b.length >= index + 4,
367             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
368         );
369 
370         // Arrays are prefixed by a 32 byte length field
371         index += 32;
372 
373         // Read the bytes4 from array memory
374         assembly {
375             result := mload(add(b, index))
376         // Solidity does not require us to clean the trailing bytes.
377         // We do it anyway
378             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
379         }
380         return result;
381     }
382 }
383 
384 // File: contracts/lib/LibMath.sol
385 
386 contract LibMath {
387     // Copied from openzeppelin Math
388     /**
389     * @dev Returns the largest of two numbers.
390     */
391     function max(uint256 a, uint256 b) internal pure returns (uint256) {
392         return a >= b ? a : b;
393     }
394 
395     /**
396     * @dev Returns the smallest of two numbers.
397     */
398     function min(uint256 a, uint256 b) internal pure returns (uint256) {
399         return a < b ? a : b;
400     }
401 
402     /**
403     * @dev Calculates the average of two numbers. Since these are integers,
404     * averages of an even and odd number cannot be represented, and will be
405     * rounded down.
406     */
407     function average(uint256 a, uint256 b) internal pure returns (uint256) {
408         // (a + b) / 2 can overflow, so we distribute
409         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
410     }
411 
412     // Modified from openzeppelin SafeMath
413     /**
414     * @dev Multiplies two unsigned integers, reverts on overflow.
415     */
416     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
417         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
418         // benefit is lost if 'b' is also tested.
419         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
420         if (a == 0) {
421             return 0;
422         }
423 
424         uint256 c = a * b;
425         require(c / a == b);
426 
427         return c;
428     }
429 
430     /**
431     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
432     */
433     function div(uint256 a, uint256 b) internal pure returns (uint256) {
434         // Solidity only automatically asserts when dividing by 0
435         require(b > 0);
436         uint256 c = a / b;
437         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
438 
439         return c;
440     }
441 
442     /**
443     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
444     */
445     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
446         require(b <= a);
447         uint256 c = a - b;
448 
449         return c;
450     }
451 
452     /**
453     * @dev Adds two unsigned integers, reverts on overflow.
454     */
455     function add(uint256 a, uint256 b) internal pure returns (uint256) {
456         uint256 c = a + b;
457         require(c >= a);
458 
459         return c;
460     }
461 
462     /**
463     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
464     * reverts when dividing by zero.
465     */
466     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
467         require(b != 0);
468         return a % b;
469     }
470 
471     // Copied from 0x LibMath
472     /*
473       Copyright 2018 ZeroEx Intl.
474       Licensed under the Apache License, Version 2.0 (the "License");
475       you may not use this file except in compliance with the License.
476       You may obtain a copy of the License at
477         http://www.apache.org/licenses/LICENSE-2.0
478       Unless required by applicable law or agreed to in writing, software
479       distributed under the License is distributed on an "AS IS" BASIS,
480       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
481       See the License for the specific language governing permissions and
482       limitations under the License.
483     */
484     /// @dev Calculates partial value given a numerator and denominator rounded down.
485     ///      Reverts if rounding error is >= 0.1%
486     /// @param numerator Numerator.
487     /// @param denominator Denominator.
488     /// @param target Value to calculate partial of.
489     /// @return Partial value of target rounded down.
490     function safeGetPartialAmountFloor(
491         uint256 numerator,
492         uint256 denominator,
493         uint256 target
494     )
495     internal
496     pure
497     returns (uint256 partialAmount)
498     {
499         require(
500             denominator > 0,
501             "DIVISION_BY_ZERO"
502         );
503 
504         require(
505             !isRoundingErrorFloor(
506             numerator,
507             denominator,
508             target
509         ),
510             "ROUNDING_ERROR"
511         );
512 
513         partialAmount = div(
514             mul(numerator, target),
515             denominator
516         );
517         return partialAmount;
518     }
519 
520     /// @dev Calculates partial value given a numerator and denominator rounded down.
521     ///      Reverts if rounding error is >= 0.1%
522     /// @param numerator Numerator.
523     /// @param denominator Denominator.
524     /// @param target Value to calculate partial of.
525     /// @return Partial value of target rounded up.
526     function safeGetPartialAmountCeil(
527         uint256 numerator,
528         uint256 denominator,
529         uint256 target
530     )
531     internal
532     pure
533     returns (uint256 partialAmount)
534     {
535         require(
536             denominator > 0,
537             "DIVISION_BY_ZERO"
538         );
539 
540         require(
541             !isRoundingErrorCeil(
542             numerator,
543             denominator,
544             target
545         ),
546             "ROUNDING_ERROR"
547         );
548 
549         partialAmount = div(
550             add(
551                 mul(numerator, target),
552                 sub(denominator, 1)
553             ),
554             denominator
555         );
556         return partialAmount;
557     }
558 
559     /// @dev Calculates partial value given a numerator and denominator rounded down.
560     /// @param numerator Numerator.
561     /// @param denominator Denominator.
562     /// @param target Value to calculate partial of.
563     /// @return Partial value of target rounded down.
564     function getPartialAmountFloor(
565         uint256 numerator,
566         uint256 denominator,
567         uint256 target
568     )
569     internal
570     pure
571     returns (uint256 partialAmount)
572     {
573         require(
574             denominator > 0,
575             "DIVISION_BY_ZERO"
576         );
577 
578         partialAmount = div(
579             mul(numerator, target),
580             denominator
581         );
582         return partialAmount;
583     }
584 
585     /// @dev Calculates partial value given a numerator and denominator rounded down.
586     /// @param numerator Numerator.
587     /// @param denominator Denominator.
588     /// @param target Value to calculate partial of.
589     /// @return Partial value of target rounded up.
590     function getPartialAmountCeil(
591         uint256 numerator,
592         uint256 denominator,
593         uint256 target
594     )
595     internal
596     pure
597     returns (uint256 partialAmount)
598     {
599         require(
600             denominator > 0,
601             "DIVISION_BY_ZERO"
602         );
603 
604         partialAmount = div(
605             add(
606                 mul(numerator, target),
607                 sub(denominator, 1)
608             ),
609             denominator
610         );
611         return partialAmount;
612     }
613 
614     /// @dev Checks if rounding error >= 0.1% when rounding down.
615     /// @param numerator Numerator.
616     /// @param denominator Denominator.
617     /// @param target Value to multiply with numerator/denominator.
618     /// @return Rounding error is present.
619     function isRoundingErrorFloor(
620         uint256 numerator,
621         uint256 denominator,
622         uint256 target
623     )
624     internal
625     pure
626     returns (bool isError)
627     {
628         require(
629             denominator > 0,
630             "DIVISION_BY_ZERO"
631         );
632 
633         // The absolute rounding error is the difference between the rounded
634         // value and the ideal value. The relative rounding error is the
635         // absolute rounding error divided by the absolute value of the
636         // ideal value. This is undefined when the ideal value is zero.
637         //
638         // The ideal value is `numerator * target / denominator`.
639         // Let's call `numerator * target % denominator` the remainder.
640         // The absolute error is `remainder / denominator`.
641         //
642         // When the ideal value is zero, we require the absolute error to
643         // be zero. Fortunately, this is always the case. The ideal value is
644         // zero iff `numerator == 0` and/or `target == 0`. In this case the
645         // remainder and absolute error are also zero.
646         if (target == 0 || numerator == 0) {
647             return false;
648         }
649 
650         // Otherwise, we want the relative rounding error to be strictly
651         // less than 0.1%.
652         // The relative error is `remainder / (numerator * target)`.
653         // We want the relative error less than 1 / 1000:
654         //        remainder / (numerator * denominator)  <  1 / 1000
655         // or equivalently:
656         //        1000 * remainder  <  numerator * target
657         // so we have a rounding error iff:
658         //        1000 * remainder  >=  numerator * target
659         uint256 remainder = mulmod(
660             target,
661             numerator,
662             denominator
663         );
664         isError = mul(1000, remainder) >= mul(numerator, target);
665         return isError;
666     }
667 
668     /// @dev Checks if rounding error >= 0.1% when rounding up.
669     /// @param numerator Numerator.
670     /// @param denominator Denominator.
671     /// @param target Value to multiply with numerator/denominator.
672     /// @return Rounding error is present.
673     function isRoundingErrorCeil(
674         uint256 numerator,
675         uint256 denominator,
676         uint256 target
677     )
678     internal
679     pure
680     returns (bool isError)
681     {
682         require(
683             denominator > 0,
684             "DIVISION_BY_ZERO"
685         );
686 
687         // See the comments in `isRoundingError`.
688         if (target == 0 || numerator == 0) {
689             // When either is zero, the ideal value and rounded value are zero
690             // and there is no rounding error. (Although the relative error
691             // is undefined.)
692             return false;
693         }
694         // Compute remainder as before
695         uint256 remainder = mulmod(
696             target,
697             numerator,
698             denominator
699         );
700         remainder = sub(denominator, remainder) % denominator;
701         isError = mul(1000, remainder) >= mul(numerator, target);
702         return isError;
703     }
704 }
705 
706 // File: contracts/lib/Ownable.sol
707 
708 /**
709  * @title Ownable
710  * @dev The Ownable contract has an owner address, and provides basic authorization control
711  * functions, this simplifies the implementation of "user permissions".
712  */
713 contract Ownable {
714     address private _owner;
715 
716     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
717 
718     /**
719      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
720      * account.
721      */
722     constructor () internal {
723         _owner = msg.sender;
724         emit OwnershipTransferred(address(0), _owner);
725     }
726 
727     /**
728      * @return the address of the owner.
729      */
730     function owner() public view returns (address) {
731         return _owner;
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         require(isOwner());
739         _;
740     }
741 
742     /**
743      * @return true if `msg.sender` is the owner of the contract.
744      */
745     function isOwner() public view returns (bool) {
746         return msg.sender == _owner;
747     }
748 
749     /**
750      * @dev Allows the current owner to relinquish control of the contract.
751      * @notice Renouncing to ownership will leave the contract without an owner.
752      * It will not be possible to call the functions with the `onlyOwner`
753      * modifier anymore.
754      */
755     function renounceOwnership() public onlyOwner {
756         emit OwnershipTransferred(_owner, address(0));
757         _owner = address(0);
758     }
759 
760     /**
761      * @dev Allows the current owner to transfer control of the contract to a newOwner.
762      * @param newOwner The address to transfer ownership to.
763      */
764     function transferOwnership(address newOwner) public onlyOwner {
765         _transferOwnership(newOwner);
766     }
767 
768     /**
769      * @dev Transfers control of the contract to a newOwner.
770      * @param newOwner The address to transfer ownership to.
771      */
772     function _transferOwnership(address newOwner) internal {
773         require(newOwner != address(0));
774         emit OwnershipTransferred(_owner, newOwner);
775         _owner = newOwner;
776     }
777 }
778 
779 // File: contracts/router/IExchangeHandler.sol
780 
781 /// Interface of exchange handler.
782 interface IExchangeHandler {
783 
784     /// Gets maximum available amount can be spent on order (fee not included).
785     /// @param data General order data.
786     /// @return availableToFill Amount can be spent on order.
787     /// @return feePercentage Fee percentage of order.
788     function getAvailableToFill(
789         bytes calldata data
790     )
791     external
792     view
793     returns (uint256 availableToFill, uint256 feePercentage);
794 
795     /// Fills an order on the target exchange.
796     /// NOTE: The required funds must be transferred to this contract in the same transaction of calling this function.
797     /// @param data General order data.
798     /// @param takerAmountToFill Taker token amount to spend on order (fee not included).
799     /// @return makerAmountReceived Amount received from trade.
800     function fillOrder(
801         bytes calldata data,
802         uint256 takerAmountToFill
803     )
804     external
805     payable
806     returns (uint256 makerAmountReceived);
807 }
808 
809 // File: contracts/router/RouterCommon.sol
810 
811 contract RouterCommon {
812     struct GeneralOrder {
813         address handler;
814         address makerToken;
815         address takerToken;
816         uint256 makerAmount;
817         uint256 takerAmount;
818         bytes data;
819     }
820 
821     struct FillResults {
822         uint256 makerAmountReceived;
823         uint256 takerAmountSpentOnOrder;
824         uint256 takerAmountSpentOnFee;
825     }
826 }
827 
828 // File: contracts/router/ZeroExV2Handler.sol
829 
830 /// Abstract contract of core 0x v2 contract.
831 contract ZeroExV2Exchange {
832     struct Order {
833         address makerAddress;           // Address that created the order.
834         address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.
835         address feeRecipientAddress;    // Address that will recieve fees when order is filled.
836         address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
837         uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.
838         uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.
839         uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
840         uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
841         uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.
842         uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.
843         bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
844         bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
845     }
846 
847     struct OrderInfo {
848         uint8 orderStatus;                    // Status that describes order's validity and fillability.
849         bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
850         uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
851     }
852 
853     struct FillResults {
854         uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
855         uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
856         uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
857         uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
858     }
859 
860     function getAssetProxy(bytes4 assetProxyId)
861     external
862     view
863     returns (address);
864 
865     function isValidSignature(
866         bytes32 hash,
867         address signerAddress,
868         bytes calldata signature
869     )
870     external
871     view
872     returns (bool isValid);
873 
874     function fillOrder(
875         Order calldata order,
876         uint256 takerAssetFillAmount,
877         bytes calldata signature
878     )
879     external
880     returns (FillResults memory fillResults);
881 
882     function getOrderInfo(Order calldata order)
883     external
884     view
885     returns (OrderInfo memory orderInfo);
886 }
887 
888 /// Interface of ERC20 approve function.
889 interface IERC20 {
890     function approve(address spender, uint256 value) external returns (bool);
891 }
892 
893 // Simple WETH interface to wrap ETH.
894 interface IWETH {
895     function deposit() external payable;
896 }
897 
898 /// 0x v2 implementation of exchange handler. ERC721 orders are not currently supported.
899 contract ZeroExV2Handler is IExchangeHandler, LibMath, Ownable {
900 
901     using LibBytes for bytes;
902 
903     ZeroExV2Exchange constant public EXCHANGE = ZeroExV2Exchange(0x4F833a24e1f95D70F028921e27040Ca56E09AB0b);
904     address constant public WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
905     address public ROUTER;
906     address payable public FEE_ACCOUNT;
907     uint256 public PROCESSING_FEE_PERCENTAGE;
908 
909     constructor(
910         address router,
911         address payable feeAccount,
912         uint256 processingFeePercentage
913     ) public {
914         ROUTER = router;
915         FEE_ACCOUNT = feeAccount;
916         PROCESSING_FEE_PERCENTAGE = processingFeePercentage;
917     }
918 
919     /// Fallback function to receive ETH.
920     function() external payable {}
921 
922     /// Sets fee account. Only contract owner can call this function.
923     /// @param feeAccount Fee account address.
924     function setFeeAccount(
925         address payable feeAccount
926     )
927     external
928     onlyOwner
929     {
930         FEE_ACCOUNT = feeAccount;
931     }
932 
933     /// Gets maximum available amount can be spent on order (fee not included).
934     /// @param data General order data.
935     /// @return availableToFill Amount can be spent on order.
936     /// @return feePercentage Fee percentage of order.
937     function getAvailableToFill(
938         bytes calldata data
939     )
940     external
941     view
942     returns (uint256 availableToFill, uint256 feePercentage)
943     {
944         (ZeroExV2Exchange.Order memory order, bytes memory signature) = getOrder(data);
945         ZeroExV2Exchange.OrderInfo memory orderInfo = EXCHANGE.getOrderInfo(order);
946         if ((order.takerAddress == address(0) || order.takerAddress == address(this)) &&
947             (order.senderAddress == address(0) || order.senderAddress == address(this)) &&
948             order.takerFee == 0 &&
949             orderInfo.orderStatus == 3 &&
950             EXCHANGE.isValidSignature(orderInfo.orderHash, order.makerAddress, signature)
951         ) {
952             availableToFill = sub(order.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount);
953         }
954         feePercentage = PROCESSING_FEE_PERCENTAGE;
955     }
956 
957     /// Fills an order on the target exchange.
958     /// NOTE: The required funds must be transferred to this contract in the same transaction of calling this function.
959     /// @param data General order data.
960     /// @param takerAmountToFill Taker token amount to spend on order (fee not included).
961     /// @return makerAmountReceived Amount received from trade.
962     function fillOrder(
963         bytes calldata data,
964         uint256 takerAmountToFill
965     )
966     external
967     payable
968     returns (uint256 makerAmountReceived)
969     {
970         require(msg.sender == ROUTER, "SENDER_NOT_ROUTER");
971         (ZeroExV2Exchange.Order memory order, bytes memory signature) = getOrder(data);
972         address makerToken = order.makerAssetData.readAddress(16);
973         address takerToken = order.takerAssetData.readAddress(16);
974         uint256 processingFee = mul(takerAmountToFill, PROCESSING_FEE_PERCENTAGE) / (1 ether);
975         if (takerToken == WETH) {
976             IWETH(WETH).deposit.value(takerAmountToFill)();
977             if (processingFee > 0) {
978                 require(FEE_ACCOUNT.send(processingFee), "FAILED_SEND_ETH_TO_FEE_ACCOUNT");
979             }
980         } else if (processingFee > 0) {
981             require(ERC20SafeTransfer.safeTransfer(takerToken, FEE_ACCOUNT, processingFee), "FAILED_SEND_ERC20_TO_FEE_ACCOUNT");
982         }
983         require(IERC20(takerToken).approve(EXCHANGE.getAssetProxy(order.takerAssetData.readBytes4(0)), takerAmountToFill));
984         ZeroExV2Exchange.FillResults memory results = EXCHANGE.fillOrder(
985             order,
986             takerAmountToFill,
987             signature
988         );
989         makerAmountReceived = results.makerAssetFilledAmount;
990         if (makerAmountReceived > 0) {
991             require(ERC20SafeTransfer.safeTransfer(makerToken, msg.sender, makerAmountReceived), "FAILED_SEND_ERC20_TO_ROUTER");
992         }
993     }
994 
995     /// Assembles order object in 0x format.
996     /// @param data General order data.
997     /// @return order Order object in 0x format.
998     /// @return signature Signature object in 0x format.
999     function getOrder(
1000         bytes memory data
1001     )
1002     internal
1003     pure
1004     returns (ZeroExV2Exchange.Order memory order, bytes memory signature)
1005     {
1006         uint256 makerAssetDataOffset = data.readUint256(320);
1007         uint256 takerAssetDataOffset = data.readUint256(352);
1008         uint256 signatureOffset = data.readUint256(384);
1009         order.makerAddress = data.readAddress(12);
1010         order.takerAddress = data.readAddress(44);
1011         order.feeRecipientAddress = data.readAddress(76);
1012         order.senderAddress = data.readAddress(108);
1013         order.makerAssetAmount = data.readUint256(128);
1014         order.takerAssetAmount = data.readUint256(160);
1015         order.makerFee = data.readUint256(192);
1016         order.takerFee = data.readUint256(224);
1017         order.expirationTimeSeconds = data.readUint256(256);
1018         order.salt = data.readUint256(288);
1019         order.makerAssetData = data.slice(makerAssetDataOffset + 32, makerAssetDataOffset + 32 + data.readUint256(makerAssetDataOffset));
1020         order.takerAssetData = data.slice(takerAssetDataOffset + 32, takerAssetDataOffset + 32 + data.readUint256(takerAssetDataOffset));
1021         signature = data.slice(signatureOffset + 32, signatureOffset + 32 + data.readUint256(signatureOffset));
1022     }
1023 
1024 }