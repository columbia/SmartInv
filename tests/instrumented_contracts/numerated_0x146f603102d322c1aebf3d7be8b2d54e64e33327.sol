1 // File: contracts/lib/LibBytes.sol
2 
3 pragma solidity ^0.5.7;
4 
5 // Modified from 0x LibBytes
6 /*
7 
8   Copyright 2018 ZeroEx Intl.
9 
10   Licensed under the Apache License, Version 2.0 (the "License");
11   you may not use this file except in compliance with the License.
12   You may obtain a copy of the License at
13 
14     http://www.apache.org/licenses/LICENSE-2.0
15 
16   Unless required by applicable law or agreed to in writing, software
17   distributed under the License is distributed on an "AS IS" BASIS,
18   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
19   See the License for the specific language governing permissions and
20   limitations under the License.
21 
22 */
23 library LibBytes {
24 
25     using LibBytes for bytes;
26 
27     /// @dev Gets the memory address for the contents of a byte array.
28     /// @param input Byte array to lookup.
29     /// @return memoryAddress Memory address of the contents of the byte array.
30     function contentAddress(bytes memory input)
31     internal
32     pure
33     returns (uint256 memoryAddress)
34     {
35         assembly {
36             memoryAddress := add(input, 32)
37         }
38         return memoryAddress;
39     }
40 
41     /// @dev Copies `length` bytes from memory location `source` to `dest`.
42     /// @param dest memory address to copy bytes to.
43     /// @param source memory address to copy bytes from.
44     /// @param length number of bytes to copy.
45     function memCopy(
46         uint256 dest,
47         uint256 source,
48         uint256 length
49     )
50     internal
51     pure
52     {
53         if (length < 32) {
54             // Handle a partial word by reading destination and masking
55             // off the bits we are interested in.
56             // This correctly handles overlap, zero lengths and source == dest
57             assembly {
58                 let mask := sub(exp(256, sub(32, length)), 1)
59                 let s := and(mload(source), not(mask))
60                 let d := and(mload(dest), mask)
61                 mstore(dest, or(s, d))
62             }
63         } else {
64             // Skip the O(length) loop when source == dest.
65             if (source == dest) {
66                 return;
67             }
68 
69             // For large copies we copy whole words at a time. The final
70             // word is aligned to the end of the range (instead of after the
71             // previous) to handle partial words. So a copy will look like this:
72             //
73             //  ####
74             //      ####
75             //          ####
76             //            ####
77             //
78             // We handle overlap in the source and destination range by
79             // changing the copying direction. This prevents us from
80             // overwriting parts of source that we still need to copy.
81             //
82             // This correctly handles source == dest
83             //
84             if (source > dest) {
85                 assembly {
86                 // We subtract 32 from `sEnd` and `dEnd` because it
87                 // is easier to compare with in the loop, and these
88                 // are also the addresses we need for copying the
89                 // last bytes.
90                     length := sub(length, 32)
91                     let sEnd := add(source, length)
92                     let dEnd := add(dest, length)
93 
94                 // Remember the last 32 bytes of source
95                 // This needs to be done here and not after the loop
96                 // because we may have overwritten the last bytes in
97                 // source already due to overlap.
98                     let last := mload(sEnd)
99 
100                 // Copy whole words front to back
101                 // Note: the first check is always true,
102                 // this could have been a do-while loop.
103                 // solhint-disable-next-line no-empty-blocks
104                     for {} lt(source, sEnd) {} {
105                         mstore(dest, mload(source))
106                         source := add(source, 32)
107                         dest := add(dest, 32)
108                     }
109 
110                 // Write the last 32 bytes
111                     mstore(dEnd, last)
112                 }
113             } else {
114                 assembly {
115                 // We subtract 32 from `sEnd` and `dEnd` because those
116                 // are the starting points when copying a word at the end.
117                     length := sub(length, 32)
118                     let sEnd := add(source, length)
119                     let dEnd := add(dest, length)
120 
121                 // Remember the first 32 bytes of source
122                 // This needs to be done here and not after the loop
123                 // because we may have overwritten the first bytes in
124                 // source already due to overlap.
125                     let first := mload(source)
126 
127                 // Copy whole words back to front
128                 // We use a signed comparisson here to allow dEnd to become
129                 // negative (happens when source and dest < 32). Valid
130                 // addresses in local memory will never be larger than
131                 // 2**255, so they can be safely re-interpreted as signed.
132                 // Note: the first check is always true,
133                 // this could have been a do-while loop.
134                 // solhint-disable-next-line no-empty-blocks
135                     for {} slt(dest, dEnd) {} {
136                         mstore(dEnd, mload(sEnd))
137                         sEnd := sub(sEnd, 32)
138                         dEnd := sub(dEnd, 32)
139                     }
140 
141                 // Write the first 32 bytes
142                     mstore(dest, first)
143                 }
144             }
145         }
146     }
147 
148     /// @dev Returns a slices from a byte array.
149     /// @param b The byte array to take a slice from.
150     /// @param from The starting index for the slice (inclusive).
151     /// @param to The final index for the slice (exclusive).
152     /// @return result The slice containing bytes at indices [from, to)
153     function slice(
154         bytes memory b,
155         uint256 from,
156         uint256 to
157     )
158     internal
159     pure
160     returns (bytes memory result)
161     {
162         if (from > to || to > b.length) {
163             return "";
164         }
165 
166         // Create a new bytes structure and copy contents
167         result = new bytes(to - from);
168         memCopy(
169             result.contentAddress(),
170             b.contentAddress() + from,
171             result.length
172         );
173         return result;
174     }
175 
176     /// @dev Reads an address from a position in a byte array.
177     /// @param b Byte array containing an address.
178     /// @param index Index in byte array of address.
179     /// @return address from byte array.
180     function readAddress(
181         bytes memory b,
182         uint256 index
183     )
184     internal
185     pure
186     returns (address result)
187     {
188         require(
189             b.length >= index + 20,  // 20 is length of address
190             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
191         );
192 
193         // Add offset to index:
194         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
195         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
196         index += 20;
197 
198         // Read address from array memory
199         assembly {
200         // 1. Add index to address of bytes array
201         // 2. Load 32-byte word from memory
202         // 3. Apply 20-byte mask to obtain address
203             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
204         }
205         return result;
206     }
207 
208     /// @dev Reads a bytes32 value from a position in a byte array.
209     /// @param b Byte array containing a bytes32 value.
210     /// @param index Index in byte array of bytes32 value.
211     /// @return bytes32 value from byte array.
212     function readBytes32(
213         bytes memory b,
214         uint256 index
215     )
216     internal
217     pure
218     returns (bytes32 result)
219     {
220         require(
221             b.length >= index + 32,
222             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
223         );
224 
225         // Arrays are prefixed by a 256 bit length parameter
226         index += 32;
227 
228         // Read the bytes32 from array memory
229         assembly {
230             result := mload(add(b, index))
231         }
232         return result;
233     }
234 
235     /// @dev Reads a uint256 value from a position in a byte array.
236     /// @param b Byte array containing a uint256 value.
237     /// @param index Index in byte array of uint256 value.
238     /// @return uint256 value from byte array.
239     function readUint256(
240         bytes memory b,
241         uint256 index
242     )
243     internal
244     pure
245     returns (uint256 result)
246     {
247         result = uint256(readBytes32(b, index));
248         return result;
249     }
250 
251     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
252     /// @param b Byte array containing a bytes4 value.
253     /// @param index Index in byte array of bytes4 value.
254     /// @return bytes4 value from byte array.
255     function readBytes4(
256         bytes memory b,
257         uint256 index
258     )
259     internal
260     pure
261     returns (bytes4 result)
262     {
263         require(
264             b.length >= index + 4,
265             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
266         );
267 
268         // Arrays are prefixed by a 32 byte length field
269         index += 32;
270 
271         // Read the bytes4 from array memory
272         assembly {
273             result := mload(add(b, index))
274         // Solidity does not require us to clean the trailing bytes.
275         // We do it anyway
276             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
277         }
278         return result;
279     }
280 }
281 
282 // File: contracts/lib/LibMath.sol
283 
284 pragma solidity ^0.5.7;
285 
286 contract LibMath {
287     // Copied from openzeppelin Math
288     /**
289     * @dev Returns the largest of two numbers.
290     */
291     function max(uint256 a, uint256 b) internal pure returns (uint256) {
292         return a >= b ? a : b;
293     }
294 
295     /**
296     * @dev Returns the smallest of two numbers.
297     */
298     function min(uint256 a, uint256 b) internal pure returns (uint256) {
299         return a < b ? a : b;
300     }
301 
302     /**
303     * @dev Calculates the average of two numbers. Since these are integers,
304     * averages of an even and odd number cannot be represented, and will be
305     * rounded down.
306     */
307     function average(uint256 a, uint256 b) internal pure returns (uint256) {
308         // (a + b) / 2 can overflow, so we distribute
309         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
310     }
311 
312     // Modified from openzeppelin SafeMath
313     /**
314     * @dev Multiplies two unsigned integers, reverts on overflow.
315     */
316     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
318         // benefit is lost if 'b' is also tested.
319         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
320         if (a == 0) {
321             return 0;
322         }
323 
324         uint256 c = a * b;
325         require(c / a == b);
326 
327         return c;
328     }
329 
330     /**
331     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
332     */
333     function div(uint256 a, uint256 b) internal pure returns (uint256) {
334         // Solidity only automatically asserts when dividing by 0
335         require(b > 0);
336         uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338 
339         return c;
340     }
341 
342     /**
343     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
344     */
345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
346         require(b <= a);
347         uint256 c = a - b;
348 
349         return c;
350     }
351 
352     /**
353     * @dev Adds two unsigned integers, reverts on overflow.
354     */
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         require(c >= a);
358 
359         return c;
360     }
361 
362     /**
363     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
364     * reverts when dividing by zero.
365     */
366     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
367         require(b != 0);
368         return a % b;
369     }
370 
371     // Copied from 0x LibMath
372     /*
373       Copyright 2018 ZeroEx Intl.
374       Licensed under the Apache License, Version 2.0 (the "License");
375       you may not use this file except in compliance with the License.
376       You may obtain a copy of the License at
377         http://www.apache.org/licenses/LICENSE-2.0
378       Unless required by applicable law or agreed to in writing, software
379       distributed under the License is distributed on an "AS IS" BASIS,
380       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
381       See the License for the specific language governing permissions and
382       limitations under the License.
383     */
384     /// @dev Calculates partial value given a numerator and denominator rounded down.
385     ///      Reverts if rounding error is >= 0.1%
386     /// @param numerator Numerator.
387     /// @param denominator Denominator.
388     /// @param target Value to calculate partial of.
389     /// @return Partial value of target rounded down.
390     function safeGetPartialAmountFloor(
391         uint256 numerator,
392         uint256 denominator,
393         uint256 target
394     )
395     internal
396     pure
397     returns (uint256 partialAmount)
398     {
399         require(
400             denominator > 0,
401             "DIVISION_BY_ZERO"
402         );
403 
404         require(
405             !isRoundingErrorFloor(
406             numerator,
407             denominator,
408             target
409         ),
410             "ROUNDING_ERROR"
411         );
412 
413         partialAmount = div(
414             mul(numerator, target),
415             denominator
416         );
417         return partialAmount;
418     }
419 
420     /// @dev Calculates partial value given a numerator and denominator rounded down.
421     ///      Reverts if rounding error is >= 0.1%
422     /// @param numerator Numerator.
423     /// @param denominator Denominator.
424     /// @param target Value to calculate partial of.
425     /// @return Partial value of target rounded up.
426     function safeGetPartialAmountCeil(
427         uint256 numerator,
428         uint256 denominator,
429         uint256 target
430     )
431     internal
432     pure
433     returns (uint256 partialAmount)
434     {
435         require(
436             denominator > 0,
437             "DIVISION_BY_ZERO"
438         );
439 
440         require(
441             !isRoundingErrorCeil(
442             numerator,
443             denominator,
444             target
445         ),
446             "ROUNDING_ERROR"
447         );
448 
449         partialAmount = div(
450             add(
451                 mul(numerator, target),
452                 sub(denominator, 1)
453             ),
454             denominator
455         );
456         return partialAmount;
457     }
458 
459     /// @dev Calculates partial value given a numerator and denominator rounded down.
460     /// @param numerator Numerator.
461     /// @param denominator Denominator.
462     /// @param target Value to calculate partial of.
463     /// @return Partial value of target rounded down.
464     function getPartialAmountFloor(
465         uint256 numerator,
466         uint256 denominator,
467         uint256 target
468     )
469     internal
470     pure
471     returns (uint256 partialAmount)
472     {
473         require(
474             denominator > 0,
475             "DIVISION_BY_ZERO"
476         );
477 
478         partialAmount = div(
479             mul(numerator, target),
480             denominator
481         );
482         return partialAmount;
483     }
484 
485     /// @dev Calculates partial value given a numerator and denominator rounded down.
486     /// @param numerator Numerator.
487     /// @param denominator Denominator.
488     /// @param target Value to calculate partial of.
489     /// @return Partial value of target rounded up.
490     function getPartialAmountCeil(
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
504         partialAmount = div(
505             add(
506                 mul(numerator, target),
507                 sub(denominator, 1)
508             ),
509             denominator
510         );
511         return partialAmount;
512     }
513 
514     /// @dev Checks if rounding error >= 0.1% when rounding down.
515     /// @param numerator Numerator.
516     /// @param denominator Denominator.
517     /// @param target Value to multiply with numerator/denominator.
518     /// @return Rounding error is present.
519     function isRoundingErrorFloor(
520         uint256 numerator,
521         uint256 denominator,
522         uint256 target
523     )
524     internal
525     pure
526     returns (bool isError)
527     {
528         require(
529             denominator > 0,
530             "DIVISION_BY_ZERO"
531         );
532 
533         // The absolute rounding error is the difference between the rounded
534         // value and the ideal value. The relative rounding error is the
535         // absolute rounding error divided by the absolute value of the
536         // ideal value. This is undefined when the ideal value is zero.
537         //
538         // The ideal value is `numerator * target / denominator`.
539         // Let's call `numerator * target % denominator` the remainder.
540         // The absolute error is `remainder / denominator`.
541         //
542         // When the ideal value is zero, we require the absolute error to
543         // be zero. Fortunately, this is always the case. The ideal value is
544         // zero iff `numerator == 0` and/or `target == 0`. In this case the
545         // remainder and absolute error are also zero.
546         if (target == 0 || numerator == 0) {
547             return false;
548         }
549 
550         // Otherwise, we want the relative rounding error to be strictly
551         // less than 0.1%.
552         // The relative error is `remainder / (numerator * target)`.
553         // We want the relative error less than 1 / 1000:
554         //        remainder / (numerator * denominator)  <  1 / 1000
555         // or equivalently:
556         //        1000 * remainder  <  numerator * target
557         // so we have a rounding error iff:
558         //        1000 * remainder  >=  numerator * target
559         uint256 remainder = mulmod(
560             target,
561             numerator,
562             denominator
563         );
564         isError = mul(1000, remainder) >= mul(numerator, target);
565         return isError;
566     }
567 
568     /// @dev Checks if rounding error >= 0.1% when rounding up.
569     /// @param numerator Numerator.
570     /// @param denominator Denominator.
571     /// @param target Value to multiply with numerator/denominator.
572     /// @return Rounding error is present.
573     function isRoundingErrorCeil(
574         uint256 numerator,
575         uint256 denominator,
576         uint256 target
577     )
578     internal
579     pure
580     returns (bool isError)
581     {
582         require(
583             denominator > 0,
584             "DIVISION_BY_ZERO"
585         );
586 
587         // See the comments in `isRoundingError`.
588         if (target == 0 || numerator == 0) {
589             // When either is zero, the ideal value and rounded value are zero
590             // and there is no rounding error. (Although the relative error
591             // is undefined.)
592             return false;
593         }
594         // Compute remainder as before
595         uint256 remainder = mulmod(
596             target,
597             numerator,
598             denominator
599         );
600         remainder = sub(denominator, remainder) % denominator;
601         isError = mul(1000, remainder) >= mul(numerator, target);
602         return isError;
603     }
604 }
605 
606 // File: contracts/lib/Ownable.sol
607 
608 pragma solidity ^0.5.0;
609 
610 /**
611  * @title Ownable
612  * @dev The Ownable contract has an owner address, and provides basic authorization control
613  * functions, this simplifies the implementation of "user permissions".
614  */
615 contract Ownable {
616     address private _owner;
617 
618     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
619 
620     /**
621      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
622      * account.
623      */
624     constructor () internal {
625         _owner = msg.sender;
626         emit OwnershipTransferred(address(0), _owner);
627     }
628 
629     /**
630      * @return the address of the owner.
631      */
632     function owner() public view returns (address) {
633         return _owner;
634     }
635 
636     /**
637      * @dev Throws if called by any account other than the owner.
638      */
639     modifier onlyOwner() {
640         require(isOwner());
641         _;
642     }
643 
644     /**
645      * @return true if `msg.sender` is the owner of the contract.
646      */
647     function isOwner() public view returns (bool) {
648         return msg.sender == _owner;
649     }
650 
651     /**
652      * @dev Allows the current owner to relinquish control of the contract.
653      * @notice Renouncing to ownership will leave the contract without an owner.
654      * It will not be possible to call the functions with the `onlyOwner`
655      * modifier anymore.
656      */
657     function renounceOwnership() public onlyOwner {
658         emit OwnershipTransferred(_owner, address(0));
659         _owner = address(0);
660     }
661 
662     /**
663      * @dev Allows the current owner to transfer control of the contract to a newOwner.
664      * @param newOwner The address to transfer ownership to.
665      */
666     function transferOwnership(address newOwner) public onlyOwner {
667         _transferOwnership(newOwner);
668     }
669 
670     /**
671      * @dev Transfers control of the contract to a newOwner.
672      * @param newOwner The address to transfer ownership to.
673      */
674     function _transferOwnership(address newOwner) internal {
675         require(newOwner != address(0));
676         emit OwnershipTransferred(_owner, newOwner);
677         _owner = newOwner;
678     }
679 }
680 
681 // File: contracts/lib/ReentrancyGuard.sol
682 
683 pragma solidity ^0.5.0;
684 
685 /**
686  * @title Helps contracts guard against reentrancy attacks.
687  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
688  * @dev If you mark a function `nonReentrant`, you should also
689  * mark it `external`.
690  */
691 contract ReentrancyGuard {
692     /// @dev counter to allow mutex lock with only one SSTORE operation
693     uint256 private _guardCounter;
694 
695     constructor () internal {
696         // The counter starts at one to prevent changing it from zero to a non-zero
697         // value, which is a more expensive operation.
698         _guardCounter = 1;
699     }
700 
701     /**
702      * @dev Prevents a contract from calling itself, directly or indirectly.
703      * Calling a `nonReentrant` function from another `nonReentrant`
704      * function is not supported. It is possible to prevent this from happening
705      * by making the `nonReentrant` function external, and make it call a
706      * `private` function that does the actual work.
707      */
708     modifier nonReentrant() {
709         _guardCounter += 1;
710         uint256 localCounter = _guardCounter;
711         _;
712         require(localCounter == _guardCounter);
713     }
714 }
715 
716 // File: contracts/bank/IBank.sol
717 
718 pragma solidity ^0.5.7;
719 
720 /// Bank Interface.
721 interface IBank {
722 
723     /// Modifies authorization of an address. Only contract owner can call this function.
724     /// @param target Address to authorize / deauthorize.
725     /// @param allowed Whether the target address is authorized.
726     function authorize(address target, bool allowed) external;
727 
728     /// Modifies user approvals of an address.
729     /// @param target Address to approve / unapprove.
730     /// @param allowed Whether the target address is user approved.
731     function userApprove(address target, bool allowed) external;
732 
733     /// Batch modifies user approvals.
734     /// @param targetList Array of addresses to approve / unapprove.
735     /// @param allowedList Array of booleans indicating whether the target address is user approved.
736     function batchUserApprove(address[] calldata targetList, bool[] calldata allowedList) external;
737 
738     /// Gets all authorized addresses.
739     /// @return Array of authorized addresses.
740     function getAuthorizedAddresses() external view returns (address[] memory);
741 
742     /// Gets all user approved addresses.
743     /// @return Array of user approved addresses.
744     function getUserApprovedAddresses() external view returns (address[] memory);
745 
746     /// Checks whether the user has enough deposit.
747     /// @param token Token address.
748     /// @param user User address.
749     /// @param amount Token amount.
750     /// @param data Additional token data (e.g. tokenId for ERC721).
751     /// @return Whether the user has enough deposit.
752     function hasDeposit(address token, address user, uint256 amount, bytes calldata data) external view returns (bool);
753 
754     /// Checks token balance available to use (including user deposit amount + user approved allowance amount).
755     /// @param token Token address.
756     /// @param user User address.
757     /// @param data Additional token data (e.g. tokenId for ERC721).
758     /// @return Token amount available.
759     function getAvailable(address token, address user, bytes calldata data) external view returns (uint256);
760 
761     /// Gets balance of user's deposit.
762     /// @param token Token address.
763     /// @param user User address.
764     /// @return Token deposit amount.
765     function balanceOf(address token, address user) external view returns (uint256);
766 
767     /// Deposits token from user wallet to bank.
768     /// @param token Token address.
769     /// @param user User address (allows third-party give tokens to any users).
770     /// @param amount Token amount.
771     /// @param data Additional token data (e.g. tokenId for ERC721).
772     function deposit(address token, address user, uint256 amount, bytes calldata data) external payable;
773 
774     /// Withdraws token from bank to user wallet.
775     /// @param token Token address.
776     /// @param amount Token amount.
777     /// @param data Additional token data (e.g. tokenId for ERC721).
778     function withdraw(address token, uint256 amount, bytes calldata data) external;
779 
780     /// Transfers token from one address to another address.
781     /// Only caller who are double-approved by both bank owner and token owner can invoke this function.
782     /// @param token Token address.
783     /// @param from The current token owner address.
784     /// @param to The new token owner address.
785     /// @param amount Token amount.
786     /// @param data Additional token data (e.g. tokenId for ERC721).
787     /// @param fromDeposit True if use fund from bank deposit. False if use fund from user wallet.
788     /// @param toDeposit True if deposit fund to bank deposit. False if send fund to user wallet.
789     function transferFrom(
790         address token,
791         address from,
792         address to,
793         uint256 amount,
794         bytes calldata data,
795         bool fromDeposit,
796         bool toDeposit
797     )
798     external;
799 }
800 
801 // File: contracts/Common.sol
802 
803 pragma solidity ^0.5.7;
804 
805 contract Common {
806     struct Order {
807         address maker;
808         address taker;
809         address makerToken;
810         address takerToken;
811         address makerTokenBank;
812         address takerTokenBank;
813         address reseller;
814         address verifier;
815         uint256 makerAmount;
816         uint256 takerAmount;
817         uint256 expires;
818         uint256 nonce;
819         uint256 minimumTakerAmount;
820         bytes makerData;
821         bytes takerData;
822         bytes signature;
823     }
824 
825     struct OrderInfo {
826         uint8 orderStatus;
827         bytes32 orderHash;
828         uint256 filledTakerAmount;
829     }
830 
831     struct FillResults {
832         uint256 makerFilledAmount;
833         uint256 makerFeeExchange;
834         uint256 makerFeeReseller;
835         uint256 takerFilledAmount;
836         uint256 takerFeeExchange;
837         uint256 takerFeeReseller;
838     }
839 
840     struct MatchedFillResults {
841         FillResults left;
842         FillResults right;
843         uint256 spreadAmount;
844     }
845 }
846 
847 // File: contracts/verifier/Verifier.sol
848 
849 pragma solidity ^0.5.7;
850 
851 
852 /// An abstract Contract of Verifier.
853 contract Verifier is Common {
854 
855     /// Verifies trade for KYC purposes.
856     /// @param order Order object.
857     /// @param takerAmountToFill Desired amount of takerToken to sell.
858     /// @param taker Taker address.
859     /// @return Whether the trade is valid.
860     function verify(
861         Order memory order,
862         uint256 takerAmountToFill,
863         address taker
864     )
865     public
866     view
867     returns (bool);
868 
869     /// Verifies user address for KYC purposes.
870     /// @param user User address.
871     /// @return Whether the user address is valid.
872     function verifyUser(address user)
873     external
874     view
875     returns (bool);
876 }
877 
878 // File: contracts/EverbloomExchange.sol
879 
880 pragma solidity ^0.5.7;
881 pragma experimental ABIEncoderV2;
882 
883 
884 
885 
886 
887 
888 
889 
890 /// Everbloom core exchange contract.
891 contract EverbloomExchange is Ownable, ReentrancyGuard, LibMath {
892 
893     using LibBytes for bytes;
894 
895     // All fees cannot beyond this percentage.
896     uint256 public constant MAX_FEE_PERCENTAGE = 0.005 * 10 ** 18; // 0.5%
897 
898     // Exchange fee account.
899     address public feeAccount;
900 
901     // Exchange fee schedule.
902     // fees[reseller][0] is maker fee charged by exchange.
903     // fees[reseller][1] is maker fee charged by reseller.
904     // fees[reseller][2] is taker fee charged by exchange.
905     // fees[reseller][3] is taker fee charged by reseller.
906     // fees[0][0] is default maker fee charged by exchange if no reseller.
907     // fees[0][1] is always 0 if no reseller.
908     // fees[0][2] is default taker fee charged by exchange if no reseller.
909     // fees[0][3] is always 0 if no reseller.
910     mapping(address => uint256[4]) public fees;
911 
912     // Mapping of order filled amounts.
913     // filled[orderHash] = filledAmount
914     mapping(bytes32 => uint256) filled;
915 
916     // Mapping of cancelled orders.
917     // cancelled[orderHash] = isCancelled
918     mapping(bytes32 => bool) cancelled;
919 
920     // Mapping of different types of whitelists.
921     // whitelists[whitelistType][address] = isAllowed
922     mapping(uint8 => mapping(address => bool)) whitelists;
923 
924     enum WhitelistType {
925         BANK,
926         FEE_EXEMPT_BANK, // No percentage fees for non-dividable tokens.
927         RESELLER,
928         VERIFIER
929     }
930 
931     enum OrderStatus {
932         INVALID,
933         INVALID_SIGNATURE,
934         INVALID_MAKER_AMOUNT,
935         INVALID_TAKER_AMOUNT,
936         FILLABLE,
937         EXPIRED,
938         FULLY_FILLED,
939         CANCELLED
940     }
941 
942     event SetFeeAccount(address feeAccount);
943     event SetFee(address reseller, uint256 makerFee, uint256 takerFee);
944     event SetWhitelist(uint8 wlType, address addr, bool allowed);
945     event CancelOrder(
946         bytes32 indexed orderHash,
947         address indexed maker,
948         address makerToken,
949         address takerToken,
950         address indexed reseller,
951         uint256 makerAmount,
952         uint256 takerAmount,
953         bytes makerData,
954         bytes takerData
955     );
956     event FillOrder(
957         bytes32 indexed orderHash,
958         address indexed maker,
959         address taker,
960         address makerToken,
961         address takerToken,
962         address indexed reseller,
963         uint256 makerFilledAmount,
964         uint256 makerFeeExchange,
965         uint256 makerFeeReseller,
966         uint256 takerFilledAmount,
967         uint256 takerFeeExchange,
968         uint256 takerFeeReseller,
969         bytes makerData,
970         bytes takerData
971     );
972 
973     /// Sets fee account. Only contract owner can call this function.
974     /// @param _feeAccount Fee account address.
975     function setFeeAccount(
976         address _feeAccount
977     )
978     public
979     onlyOwner
980     {
981         feeAccount = _feeAccount;
982         emit SetFeeAccount(_feeAccount);
983     }
984 
985     /// Sets fee schedule. Only contract owner can call this function.
986     /// Each fee is a fraction of 1 ETH in wei.
987     /// @param reseller Reseller address.
988     /// @param _fees Array of four fees: makerFeeExchange, makerFeeReseller, takerFeeExchange, takerFeeReseller.
989     function setFee(
990         address reseller,
991         uint256[4] calldata _fees
992     )
993     external
994     onlyOwner
995     {
996         if (reseller == address(0)) {
997             // If reseller is not set, reseller fee should not be set.
998             require(_fees[1] == 0 && _fees[3] == 0, "INVALID_NULL_RESELLER_FEE");
999         }
1000         uint256 makerFee = add(_fees[0], _fees[1]);
1001         uint256 takerFee = add(_fees[2], _fees[3]);
1002         // Total fees of an order should not beyond MAX_FEE_PERCENTAGE.
1003         require(add(makerFee, takerFee) <= MAX_FEE_PERCENTAGE, "FEE_TOO_HIGH");
1004         fees[reseller] = _fees;
1005         emit SetFee(reseller, makerFee, takerFee);
1006     }
1007 
1008     /// Sets address whitelist. Only contract owner can call this function.
1009     /// @param wlType Whitelist type (defined in enum WhitelistType, e.g. BANK).
1010     /// @param addr An address (e.g. a trusted bank address).
1011     /// @param allowed Whether the address is trusted.
1012     function setWhitelist(
1013         WhitelistType wlType,
1014         address addr,
1015         bool allowed
1016     )
1017     external
1018     onlyOwner
1019     {
1020         whitelists[uint8(wlType)][addr] = allowed;
1021         emit SetWhitelist(uint8(wlType), addr, allowed);
1022     }
1023 
1024     /// Cancels an order. Only order maker can call this function.
1025     /// @param order Order object.
1026     function cancelOrder(
1027         Common.Order memory order
1028     )
1029     public
1030     nonReentrant
1031     {
1032         cancelOrderInternal(order);
1033     }
1034 
1035     /// Cancels multiple orders by batch. Only order maker can call this function.
1036     /// @param orderList Array of order objects.
1037     function cancelOrders(
1038         Common.Order[] memory orderList
1039     )
1040     public
1041     nonReentrant
1042     {
1043         for (uint256 i = 0; i < orderList.length; i++) {
1044             cancelOrderInternal(orderList[i]);
1045         }
1046     }
1047 
1048     /// Fills an order.
1049     /// @param order Order object.
1050     /// @param takerAmountToFill Desired amount of takerToken to sell.
1051     /// @param allowInsufficient Whether insufficient order remaining is allowed to fill.
1052     /// @return results Amounts filled and fees paid by maker and taker.
1053     function fillOrder(
1054         Common.Order memory order,
1055         uint256 takerAmountToFill,
1056         bool allowInsufficient
1057     )
1058     public
1059     nonReentrant
1060     returns (Common.FillResults memory results)
1061     {
1062         results = fillOrderInternal(
1063             order,
1064             takerAmountToFill,
1065             allowInsufficient
1066         );
1067         return results;
1068     }
1069 
1070     /// Fills an order without throwing an exception.
1071     /// @param order Order object.
1072     /// @param takerAmountToFill Desired amount of takerToken to sell.
1073     /// @param allowInsufficient Whether insufficient order remaining is allowed to fill.
1074     /// @return results Amounts filled and fees paid by maker and taker.
1075     function fillOrderNoThrow(
1076         Common.Order memory order,
1077         uint256 takerAmountToFill,
1078         bool allowInsufficient
1079     )
1080     public
1081     returns (Common.FillResults memory results)
1082     {
1083         bytes memory callData = abi.encodeWithSelector(
1084             this.fillOrder.selector,
1085             order,
1086             takerAmountToFill,
1087             allowInsufficient
1088         );
1089         assembly {
1090             // Use raw assembly call to fill order and avoid EVM reverts.
1091             let success := delegatecall(
1092                 gas,                // forward all gas.
1093                 address,            // call address of this contract.
1094                 add(callData, 32),  // pointer to start of input (skip array length in first 32 bytes).
1095                 mload(callData),    // length of input.
1096                 callData,           // write output over input.
1097                 192                 // output size is 192 bytes.
1098             )
1099             // Copy output data.
1100             if success {
1101                 mstore(results, mload(callData))
1102                 mstore(add(results, 32), mload(add(callData, 32)))
1103                 mstore(add(results, 64), mload(add(callData, 64)))
1104                 mstore(add(results, 96), mload(add(callData, 96)))
1105                 mstore(add(results, 128), mload(add(callData, 128)))
1106                 mstore(add(results, 160), mload(add(callData, 160)))
1107             }
1108         }
1109         return results;
1110     }
1111 
1112     /// Fills multiple orders by batch.
1113     /// @param orderList Array of order objects.
1114     /// @param takerAmountToFillList Array of desired amounts of takerToken to sell.
1115     /// @param allowInsufficientList Array of booleans that whether insufficient order remaining is allowed to fill.
1116     function fillOrders(
1117         Common.Order[] memory orderList,
1118         uint256[] memory takerAmountToFillList,
1119         bool[] memory allowInsufficientList
1120     )
1121     public
1122     nonReentrant
1123     {
1124         for (uint256 i = 0; i < orderList.length; i++) {
1125             fillOrderInternal(
1126                 orderList[i],
1127                 takerAmountToFillList[i],
1128                 allowInsufficientList[i]
1129             );
1130         }
1131     }
1132 
1133     /// Fills multiple orders by batch without throwing an exception.
1134     /// @param orderList Array of order objects.
1135     /// @param takerAmountToFillList Array of desired amounts of takerToken to sell.
1136     /// @param allowInsufficientList Array of booleans that whether insufficient order remaining is allowed to fill.
1137     function fillOrdersNoThrow(
1138         Common.Order[] memory orderList,
1139         uint256[] memory takerAmountToFillList,
1140         bool[] memory allowInsufficientList
1141     )
1142     public
1143     nonReentrant
1144     {
1145         for (uint256 i = 0; i < orderList.length; i++) {
1146             fillOrderNoThrow(
1147                 orderList[i],
1148                 takerAmountToFillList[i],
1149                 allowInsufficientList[i]
1150             );
1151         }
1152     }
1153 
1154     /// Match two complementary orders that have a profitable spread.
1155     /// NOTE: (leftOrder.makerAmount / leftOrder.takerAmount) should be always greater than or equal to
1156     /// (rightOrder.takerAmount / rightOrder.makerAmount).
1157     /// @param leftOrder First order object to match.
1158     /// @param rightOrder Second order object to match.
1159     /// @param spreadReceiver Address to receive a profitable spread.
1160     /// @param results Fill results of matched orders and spread amount.
1161     function matchOrders(
1162         Common.Order memory leftOrder,
1163         Common.Order memory rightOrder,
1164         address spreadReceiver
1165     )
1166     public
1167     nonReentrant
1168     returns (Common.MatchedFillResults memory results)
1169     {
1170         // Matching orders pre-check.
1171         require(
1172             leftOrder.makerToken == rightOrder.takerToken &&
1173             leftOrder.takerToken == rightOrder.makerToken &&
1174             mul(leftOrder.makerAmount, rightOrder.makerAmount) >= mul(leftOrder.takerAmount, rightOrder.takerAmount),
1175             "UNMATCHED_ORDERS"
1176         );
1177         Common.OrderInfo memory leftOrderInfo = getOrderInfo(leftOrder);
1178         Common.OrderInfo memory rightOrderInfo = getOrderInfo(rightOrder);
1179         results = calculateMatchedFillResults(
1180             leftOrder,
1181             rightOrder,
1182             leftOrderInfo.filledTakerAmount,
1183             rightOrderInfo.filledTakerAmount
1184         );
1185         assertFillableOrder(
1186             leftOrder,
1187             leftOrderInfo,
1188             msg.sender,
1189             results.left.takerFilledAmount
1190         );
1191         assertFillableOrder(
1192             rightOrder,
1193             rightOrderInfo,
1194             msg.sender,
1195             results.right.takerFilledAmount
1196         );
1197         settleMatchedOrders(leftOrder, rightOrder, results, spreadReceiver);
1198         filled[leftOrderInfo.orderHash] = add(leftOrderInfo.filledTakerAmount, results.left.takerFilledAmount);
1199         filled[rightOrderInfo.orderHash] = add(rightOrderInfo.filledTakerAmount, results.right.takerFilledAmount);
1200         emitFillOrderEvent(leftOrderInfo.orderHash, leftOrder, results.left);
1201         emitFillOrderEvent(rightOrderInfo.orderHash, rightOrder, results.right);
1202         return results;
1203     }
1204 
1205     /// Given a list of orders, fill them in sequence until total taker amount is reached.
1206     /// NOTE: All orders should be in the same token pair.
1207     /// @param orderList Array of order objects.
1208     /// @param totalTakerAmountToFill Stop filling when the total taker amount is reached.
1209     /// @return totalFillResults Total amounts filled and fees paid by maker and taker.
1210     function marketTakerOrders(
1211         Common.Order[] memory orderList,
1212         uint256 totalTakerAmountToFill
1213     )
1214     public
1215     returns (Common.FillResults memory totalFillResults)
1216     {
1217         for (uint256 i = 0; i < orderList.length; i++) {
1218             Common.FillResults memory singleFillResults = fillOrderNoThrow(
1219                 orderList[i],
1220                 sub(totalTakerAmountToFill, totalFillResults.takerFilledAmount),
1221                 true
1222             );
1223             addFillResults(totalFillResults, singleFillResults);
1224             if (totalFillResults.takerFilledAmount >= totalTakerAmountToFill) {
1225                 break;
1226             }
1227         }
1228         return totalFillResults;
1229     }
1230 
1231     /// Given a list of orders, fill them in sequence until total maker amount is reached.
1232     /// NOTE: All orders should be in the same token pair.
1233     /// @param orderList Array of order objects.
1234     /// @param totalMakerAmountToFill Stop filling when the total maker amount is reached.
1235     /// @return totalFillResults Total amounts filled and fees paid by maker and taker.
1236     function marketMakerOrders(
1237         Common.Order[] memory orderList,
1238         uint256 totalMakerAmountToFill
1239     )
1240     public
1241     returns (Common.FillResults memory totalFillResults)
1242     {
1243         for (uint256 i = 0; i < orderList.length; i++) {
1244             Common.FillResults memory singleFillResults = fillOrderNoThrow(
1245                 orderList[i],
1246                 getPartialAmountFloor(
1247                     orderList[i].takerAmount, orderList[i].makerAmount,
1248                     sub(totalMakerAmountToFill, totalFillResults.makerFilledAmount)
1249                 ),
1250                 true
1251             );
1252             addFillResults(totalFillResults, singleFillResults);
1253             if (totalFillResults.makerFilledAmount >= totalMakerAmountToFill) {
1254                 break;
1255             }
1256         }
1257         return totalFillResults;
1258     }
1259 
1260     /// Gets information about an order.
1261     /// @param order Order object.
1262     /// @return orderInfo Information about the order status, order hash, and filled amount.
1263     function getOrderInfo(Common.Order memory order)
1264     public
1265     view
1266     returns (Common.OrderInfo memory orderInfo)
1267     {
1268         orderInfo.orderHash = getOrderHash(order);
1269         orderInfo.filledTakerAmount = filled[orderInfo.orderHash];
1270         if (
1271             !whitelists[uint8(WhitelistType.RESELLER)][order.reseller] ||
1272             !whitelists[uint8(WhitelistType.VERIFIER)][order.verifier] ||
1273             !whitelists[uint8(WhitelistType.BANK)][order.makerTokenBank] ||
1274             !whitelists[uint8(WhitelistType.BANK)][order.takerTokenBank]
1275         ) {
1276             orderInfo.orderStatus = uint8(OrderStatus.INVALID);
1277             return orderInfo;
1278         }
1279 
1280         if (!isValidSignature(orderInfo.orderHash, order.maker, order.signature)) {
1281             orderInfo.orderStatus = uint8(OrderStatus.INVALID_SIGNATURE);
1282             return orderInfo;
1283         }
1284 
1285         if (order.makerAmount == 0) {
1286             orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_AMOUNT);
1287             return orderInfo;
1288         }
1289         if (order.takerAmount == 0) {
1290             orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_AMOUNT);
1291             return orderInfo;
1292         }
1293         if (orderInfo.filledTakerAmount >= order.takerAmount) {
1294             orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
1295             return orderInfo;
1296         }
1297         // solhint-disable-next-line not-rely-on-time
1298         if (block.timestamp >= order.expires) {
1299             orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
1300             return orderInfo;
1301         }
1302         if (cancelled[orderInfo.orderHash]) {
1303             orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
1304             return orderInfo;
1305         }
1306         orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
1307         return orderInfo;
1308     }
1309 
1310     /// Calculates hash of an order.
1311     /// @param order Order object.
1312     /// @return Hash of order.
1313     function getOrderHash(Common.Order memory order)
1314     public
1315     view
1316     returns (bytes32)
1317     {
1318         bytes memory part1 = abi.encodePacked(
1319             address(this),
1320             order.maker,
1321             order.taker,
1322             order.makerToken,
1323             order.takerToken,
1324             order.makerTokenBank,
1325             order.takerTokenBank,
1326             order.reseller,
1327             order.verifier
1328         );
1329         bytes memory part2 = abi.encodePacked(
1330             order.makerAmount,
1331             order.takerAmount,
1332             order.expires,
1333             order.nonce,
1334             order.minimumTakerAmount,
1335             order.makerData,
1336             order.takerData
1337         );
1338         return keccak256(abi.encodePacked(part1, part2));
1339     }
1340 
1341     /// Cancels an order.
1342     /// @param order Order object.
1343     function cancelOrderInternal(
1344         Common.Order memory order
1345     )
1346     internal
1347     {
1348         Common.OrderInfo memory orderInfo = getOrderInfo(order);
1349         require(orderInfo.orderStatus == uint8(OrderStatus.FILLABLE), "ORDER_UNFILLABLE");
1350         require(order.maker == msg.sender, "INVALID_MAKER");
1351         cancelled[orderInfo.orderHash] = true;
1352         emit CancelOrder(
1353             orderInfo.orderHash,
1354             order.maker,
1355             order.makerToken,
1356             order.takerToken,
1357             order.reseller,
1358             order.makerAmount,
1359             order.takerAmount,
1360             order.makerData,
1361             order.takerData
1362         );
1363     }
1364 
1365     /// Fills an order.
1366     /// @param order Order object.
1367     /// @param takerAmountToFill Desired amount of takerToken to sell.
1368     /// @param allowInsufficient Whether insufficient order remaining is allowed to fill.
1369     /// @return results Amounts filled and fees paid by maker and taker.
1370     function fillOrderInternal(
1371         Common.Order memory order,
1372         uint256 takerAmountToFill,
1373         bool allowInsufficient
1374     )
1375     internal
1376     returns (Common.FillResults memory results)
1377     {
1378         require(takerAmountToFill > 0, "INVALID_TAKER_AMOUNT");
1379         Common.OrderInfo memory orderInfo = getOrderInfo(order);
1380         uint256 remainingTakerAmount = sub(order.takerAmount, orderInfo.filledTakerAmount);
1381         if (allowInsufficient) {
1382             takerAmountToFill = min(takerAmountToFill, remainingTakerAmount);
1383         } else {
1384             require(takerAmountToFill <= remainingTakerAmount, "INSUFFICIENT_ORDER_REMAINING");
1385         }
1386         assertFillableOrder(
1387             order,
1388             orderInfo,
1389             msg.sender,
1390             takerAmountToFill
1391         );
1392         results = settleOrder(order, takerAmountToFill);
1393         filled[orderInfo.orderHash] = add(orderInfo.filledTakerAmount, results.takerFilledAmount);
1394         emitFillOrderEvent(orderInfo.orderHash, order, results);
1395         return results;
1396     }
1397 
1398     /// Emits a FillOrder event.
1399     /// @param orderHash Hash of order.
1400     /// @param order Order object.
1401     /// @param results Order fill results.
1402     function emitFillOrderEvent(
1403         bytes32 orderHash,
1404         Common.Order memory order,
1405         Common.FillResults memory results
1406     )
1407     internal
1408     {
1409         emit FillOrder(
1410             orderHash,
1411             order.maker,
1412             msg.sender,
1413             order.makerToken,
1414             order.takerToken,
1415             order.reseller,
1416             results.makerFilledAmount,
1417             results.makerFeeExchange,
1418             results.makerFeeReseller,
1419             results.takerFilledAmount,
1420             results.takerFeeExchange,
1421             results.takerFeeReseller,
1422             order.makerData,
1423             order.takerData
1424         );
1425     }
1426 
1427     /// Validates context for fillOrder. Succeeds or throws.
1428     /// @param order Order object to be filled.
1429     /// @param orderInfo Information about the order status, order hash, and amount already filled of order.
1430     /// @param taker Address of order taker.
1431     /// @param takerAmountToFill Desired amount of takerToken to sell.
1432     function assertFillableOrder(
1433         Common.Order memory order,
1434         Common.OrderInfo memory orderInfo,
1435         address taker,
1436         uint256 takerAmountToFill
1437     )
1438     view
1439     internal
1440     {
1441         // An order can only be filled if its status is FILLABLE.
1442         require(orderInfo.orderStatus == uint8(OrderStatus.FILLABLE), "ORDER_UNFILLABLE");
1443 
1444         // Validate taker is allowed to fill this order.
1445         if (order.taker != address(0)) {
1446             require(order.taker == taker, "INVALID_TAKER");
1447         }
1448 
1449         // Validate minimum taker amount.
1450         if (order.minimumTakerAmount > 0) {
1451             require(takerAmountToFill >= order.minimumTakerAmount, "ORDER_MINIMUM_UNREACHED");
1452         }
1453 
1454         // Go through Verifier.
1455         if (order.verifier != address(0)) {
1456             require(Verifier(order.verifier).verify(order, takerAmountToFill, msg.sender), "FAILED_VALIDATION");
1457         }
1458     }
1459 
1460     /// Verifies that an order signature is valid.
1461     /// @param hash Message hash that is signed.
1462     /// @param signer Address of signer.
1463     /// @param signature Order signature.
1464     /// @return Validity of order signature.
1465     function isValidSignature(
1466         bytes32 hash,
1467         address signer,
1468         bytes memory signature
1469     )
1470     internal
1471     pure
1472     returns (bool)
1473     {
1474         uint8 v = uint8(signature[0]);
1475         bytes32 r = signature.readBytes32(1);
1476         bytes32 s = signature.readBytes32(33);
1477         return signer == ecrecover(
1478             keccak256(abi.encodePacked(
1479                 "\x19Ethereum Signed Message:\n32",
1480                 hash
1481             )),
1482             v,
1483             r,
1484             s
1485         );
1486     }
1487 
1488     /// Adds properties of a single FillResults to total FillResults.
1489     /// @param totalFillResults Fill results instance that will be added onto.
1490     /// @param singleFillResults Fill results instance that will be added to totalFillResults.
1491     function addFillResults(
1492         Common.FillResults memory totalFillResults,
1493         Common.FillResults memory singleFillResults
1494     )
1495     internal
1496     pure
1497     {
1498         totalFillResults.makerFilledAmount = add(totalFillResults.makerFilledAmount, singleFillResults.makerFilledAmount);
1499         totalFillResults.makerFeeExchange = add(totalFillResults.makerFeeExchange, singleFillResults.makerFeeExchange);
1500         totalFillResults.makerFeeReseller = add(totalFillResults.makerFeeReseller, singleFillResults.makerFeeReseller);
1501         totalFillResults.takerFilledAmount = add(totalFillResults.takerFilledAmount, singleFillResults.takerFilledAmount);
1502         totalFillResults.takerFeeExchange = add(totalFillResults.takerFeeExchange, singleFillResults.takerFeeExchange);
1503         totalFillResults.takerFeeReseller = add(totalFillResults.takerFeeReseller, singleFillResults.takerFeeReseller);
1504     }
1505 
1506     /// Settles an order by swapping funds and paying fees.
1507     /// @param order Order object.
1508     /// @param takerAmountToFill Desired amount of takerToken to sell.
1509     /// @param results Amounts to be filled and fees paid by maker and taker.
1510     function settleOrder(
1511         Common.Order memory order,
1512         uint256 takerAmountToFill
1513     )
1514     internal
1515     returns (Common.FillResults memory results)
1516     {
1517         results.takerFilledAmount = takerAmountToFill;
1518         results.makerFilledAmount = safeGetPartialAmountFloor(order.makerAmount, order.takerAmount, results.takerFilledAmount);
1519         // Calculate maker fees if makerTokenBank is non-fee-exempt.
1520         if (!whitelists[uint8(WhitelistType.FEE_EXEMPT_BANK)][order.makerTokenBank]) {
1521             if (fees[order.reseller][0] > 0) {
1522                 results.makerFeeExchange = mul(results.makerFilledAmount, fees[order.reseller][0]) / (1 ether);
1523             }
1524             if (fees[order.reseller][1] > 0) {
1525                 results.makerFeeReseller = mul(results.makerFilledAmount, fees[order.reseller][1]) / (1 ether);
1526             }
1527         }
1528         // Calculate taker fees if takerTokenBank is non-fee-exempt.
1529         if (!whitelists[uint8(WhitelistType.FEE_EXEMPT_BANK)][order.takerTokenBank]) {
1530             if (fees[order.reseller][2] > 0) {
1531                 results.takerFeeExchange = mul(results.takerFilledAmount, fees[order.reseller][2]) / (1 ether);
1532             }
1533             if (fees[order.reseller][3] > 0) {
1534                 results.takerFeeReseller = mul(results.takerFilledAmount, fees[order.reseller][3]) / (1 ether);
1535             }
1536         }
1537         if (results.makerFeeExchange > 0) {
1538             // Transfer maker fee to exchange fee account.
1539             IBank(order.makerTokenBank).transferFrom(
1540                 order.makerToken,
1541                 order.maker,
1542                 feeAccount,
1543                 results.makerFeeExchange,
1544                 order.makerData,
1545                 true,
1546                 false
1547             );
1548         }
1549         if (results.makerFeeReseller > 0) {
1550             // Transfer maker fee to reseller fee account.
1551             IBank(order.makerTokenBank).transferFrom(
1552                 order.makerToken,
1553                 order.maker,
1554                 order.reseller,
1555                 results.makerFeeReseller,
1556                 order.makerData,
1557                 true,
1558                 false
1559             );
1560         }
1561         if (results.takerFeeExchange > 0) {
1562             // Transfer taker fee to exchange fee account.
1563             IBank(order.takerTokenBank).transferFrom(
1564                 order.takerToken,
1565                 msg.sender,
1566                 feeAccount,
1567                 results.takerFeeExchange,
1568                 order.takerData,
1569                 true,
1570                 false
1571             );
1572         }
1573         if (results.takerFeeReseller > 0) {
1574             // Transfer taker fee to reseller fee account.
1575             IBank(order.takerTokenBank).transferFrom(
1576                 order.takerToken,
1577                 msg.sender,
1578                 order.reseller,
1579                 results.takerFeeReseller,
1580                 order.takerData,
1581                 true,
1582                 false
1583             );
1584         }
1585         // Transfer tokens from maker to taker.
1586         IBank(order.makerTokenBank).transferFrom(
1587             order.makerToken,
1588             order.maker,
1589             msg.sender,
1590             results.makerFilledAmount,
1591             order.makerData,
1592             true,
1593             true
1594         );
1595         // Transfer tokens from taker to maker.
1596         IBank(order.takerTokenBank).transferFrom(
1597             order.takerToken,
1598             msg.sender,
1599             order.maker,
1600             results.takerFilledAmount,
1601             order.takerData,
1602             true,
1603             true
1604         );
1605     }
1606 
1607     /// Calculates fill amounts for matched orders that have a profitable spread.
1608     /// NOTE: (leftOrder.makerAmount / leftOrder.takerAmount) should be always greater than or equal to
1609     /// (rightOrder.takerAmount / rightOrder.makerAmount).
1610     /// @param leftOrder First order object to match.
1611     /// @param rightOrder Second order object to match.
1612     /// @param leftFilledTakerAmount Amount of left order already filled.
1613     /// @param rightFilledTakerAmount Amount of right order already filled.
1614     /// @param results Fill results of matched orders and spread amount.
1615     function calculateMatchedFillResults(
1616         Common.Order memory leftOrder,
1617         Common.Order memory rightOrder,
1618         uint256 leftFilledTakerAmount,
1619         uint256 rightFilledTakerAmount
1620     )
1621     internal
1622     view
1623     returns (Common.MatchedFillResults memory results)
1624     {
1625         uint256 leftRemainingTakerAmount = sub(leftOrder.takerAmount, leftFilledTakerAmount);
1626         uint256 leftRemainingMakerAmount = safeGetPartialAmountFloor(
1627             leftOrder.makerAmount,
1628             leftOrder.takerAmount,
1629             leftRemainingTakerAmount
1630         );
1631         uint256 rightRemainingTakerAmount = sub(rightOrder.takerAmount, rightFilledTakerAmount);
1632         uint256 rightRemainingMakerAmount = safeGetPartialAmountFloor(
1633             rightOrder.makerAmount,
1634             rightOrder.takerAmount,
1635             rightRemainingTakerAmount
1636         );
1637 
1638         if (leftRemainingTakerAmount >= rightRemainingMakerAmount) {
1639             // Case 1: Right order is fully filled.
1640             results.right.makerFilledAmount = rightRemainingMakerAmount;
1641             results.right.takerFilledAmount = rightRemainingTakerAmount;
1642             results.left.takerFilledAmount = results.right.makerFilledAmount;
1643             // Round down to ensure the maker's exchange rate does not exceed the price specified by the order.
1644             // We favor the maker when the exchange rate must be rounded.
1645             results.left.makerFilledAmount = safeGetPartialAmountFloor(
1646                 leftOrder.makerAmount,
1647                 leftOrder.takerAmount,
1648                 results.left.takerFilledAmount
1649             );
1650         } else {
1651             // Case 2: Left order is fully filled.
1652             results.left.makerFilledAmount = leftRemainingMakerAmount;
1653             results.left.takerFilledAmount = leftRemainingTakerAmount;
1654             results.right.makerFilledAmount = results.left.takerFilledAmount;
1655             // Round up to ensure the maker's exchange rate does not exceed the price specified by the order.
1656             // We favor the maker when the exchange rate must be rounded.
1657             results.right.takerFilledAmount = safeGetPartialAmountCeil(
1658                 rightOrder.takerAmount,
1659                 rightOrder.makerAmount,
1660                 results.right.makerFilledAmount
1661             );
1662         }
1663         results.spreadAmount = sub(
1664             results.left.makerFilledAmount,
1665             results.right.takerFilledAmount
1666         );
1667         if (!whitelists[uint8(WhitelistType.FEE_EXEMPT_BANK)][leftOrder.makerTokenBank]) {
1668             if (fees[leftOrder.reseller][0] > 0) {
1669                 results.left.makerFeeExchange = mul(results.left.makerFilledAmount, fees[leftOrder.reseller][0]) / (1 ether);
1670             }
1671             if (fees[leftOrder.reseller][1] > 0) {
1672                 results.left.makerFeeReseller = mul(results.left.makerFilledAmount, fees[leftOrder.reseller][1]) / (1 ether);
1673             }
1674         }
1675         if (!whitelists[uint8(WhitelistType.FEE_EXEMPT_BANK)][rightOrder.makerTokenBank]) {
1676             if (fees[rightOrder.reseller][2] > 0) {
1677                 results.right.makerFeeExchange = mul(results.right.makerFilledAmount, fees[rightOrder.reseller][2]) / (1 ether);
1678             }
1679             if (fees[rightOrder.reseller][3] > 0) {
1680                 results.right.makerFeeReseller = mul(results.right.makerFilledAmount, fees[rightOrder.reseller][3]) / (1 ether);
1681             }
1682         }
1683         return results;
1684     }
1685 
1686     /// Settles matched order by swapping funds, paying fees and transferring spread.
1687     /// @param leftOrder First matched order object.
1688     /// @param rightOrder Second matched order object.
1689     /// @param results Fill results of matched orders and spread amount.
1690     /// @param spreadReceiver Address to receive a profitable spread.
1691     function settleMatchedOrders(
1692         Common.Order memory leftOrder,
1693         Common.Order memory rightOrder,
1694         Common.MatchedFillResults memory results,
1695         address spreadReceiver
1696     )
1697     internal
1698     {
1699         if (results.left.makerFeeExchange > 0) {
1700             // Transfer left maker fee to exchange fee account.
1701             IBank(leftOrder.makerTokenBank).transferFrom(
1702                 leftOrder.makerToken,
1703                 leftOrder.maker,
1704                 feeAccount,
1705                 results.left.makerFeeExchange,
1706                 leftOrder.makerData,
1707                 true,
1708                 false
1709             );
1710         }
1711         if (results.left.makerFeeReseller > 0) {
1712             // Transfer left maker fee to reseller fee account.
1713             IBank(leftOrder.makerTokenBank).transferFrom(
1714                 leftOrder.makerToken,
1715                 leftOrder.maker,
1716                 leftOrder.reseller,
1717                 results.left.makerFeeReseller,
1718                 leftOrder.makerData,
1719                 true,
1720                 false
1721             );
1722         }
1723         if (results.right.makerFeeExchange > 0) {
1724             // Transfer right maker fee to exchange fee account.
1725             IBank(rightOrder.makerTokenBank).transferFrom(
1726                 rightOrder.makerToken,
1727                 rightOrder.maker,
1728                 feeAccount,
1729                 results.right.makerFeeExchange,
1730                 rightOrder.makerData,
1731                 true,
1732                 false
1733             );
1734         }
1735         if (results.right.makerFeeReseller > 0) {
1736             // Transfer right maker fee to reseller fee account.
1737             IBank(rightOrder.makerTokenBank).transferFrom(
1738                 rightOrder.makerToken,
1739                 rightOrder.maker,
1740                 rightOrder.reseller,
1741                 results.right.makerFeeReseller,
1742                 rightOrder.makerData,
1743                 true,
1744                 false
1745             );
1746         }
1747         // Note that there's no taker fees for matched orders.
1748 
1749         // Transfer tokens from left order maker to right order maker.
1750         IBank(leftOrder.makerTokenBank).transferFrom(
1751             leftOrder.makerToken,
1752             leftOrder.maker,
1753             rightOrder.maker,
1754             results.right.takerFilledAmount,
1755             leftOrder.makerData,
1756             true,
1757             true
1758         );
1759         // Transfer tokens from right order maker to left order maker.
1760         IBank(rightOrder.makerTokenBank).transferFrom(
1761             rightOrder.makerToken,
1762             rightOrder.maker,
1763             leftOrder.maker,
1764             results.left.takerFilledAmount,
1765             rightOrder.makerData,
1766             true,
1767             true
1768         );
1769         if (results.spreadAmount > 0) {
1770             // Transfer spread to spread receiver.
1771             IBank(leftOrder.makerTokenBank).transferFrom(
1772                 leftOrder.makerToken,
1773                 leftOrder.maker,
1774                 spreadReceiver,
1775                 results.spreadAmount,
1776                 leftOrder.makerData,
1777                 true,
1778                 false
1779             );
1780         }
1781     }
1782 }