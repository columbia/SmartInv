1 // SPDX-License-Identifier: Apache-2.0
2 // Copyright 2017 Loopring Technology Limited.
3 pragma solidity ^0.7.0;
4 
5 
6 /// @title Ownable
7 /// @author Brecht Devos - <brecht@loopring.org>
8 /// @dev The Ownable contract has an owner address, and provides basic
9 ///      authorization control functions, this simplifies the implementation of
10 ///      "user permissions".
11 contract Ownable
12 {
13     address public owner;
14 
15     event OwnershipTransferred(
16         address indexed previousOwner,
17         address indexed newOwner
18     );
19 
20     /// @dev The Ownable constructor sets the original `owner` of the contract
21     ///      to the sender.
22     constructor()
23     {
24         owner = msg.sender;
25     }
26 
27     /// @dev Throws if called by any account other than the owner.
28     modifier onlyOwner()
29     {
30         require(msg.sender == owner, "UNAUTHORIZED");
31         _;
32     }
33 
34     /// @dev Allows the current owner to transfer control of the contract to a
35     ///      new owner.
36     /// @param newOwner The address to transfer ownership to.
37     function transferOwnership(
38         address newOwner
39         )
40         public
41         virtual
42         onlyOwner
43     {
44         require(newOwner != address(0), "ZERO_ADDRESS");
45         emit OwnershipTransferred(owner, newOwner);
46         owner = newOwner;
47     }
48 
49     function renounceOwnership()
50         public
51         onlyOwner
52     {
53         emit OwnershipTransferred(owner, address(0));
54         owner = address(0);
55     }
56 }
57 
58 // Copyright 2017 Loopring Technology Limited.
59 
60 /// @title Claimable
61 /// @author Brecht Devos - <brecht@loopring.org>
62 /// @dev Extension for the Ownable contract, where the ownership needs
63 ///      to be claimed. This allows the new owner to accept the transfer.
64 contract Claimable is Ownable
65 {
66     address public pendingOwner;
67 
68     /// @dev Modifier throws if called by any account other than the pendingOwner.
69     modifier onlyPendingOwner() {
70         require(msg.sender == pendingOwner, "UNAUTHORIZED");
71         _;
72     }
73 
74     /// @dev Allows the current owner to set the pendingOwner address.
75     /// @param newOwner The address to transfer ownership to.
76     function transferOwnership(
77         address newOwner
78         )
79         public
80         override
81         onlyOwner
82     {
83         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
84         pendingOwner = newOwner;
85     }
86 
87     /// @dev Allows the pendingOwner address to finalize the transfer.
88     function claimOwnership()
89         public
90         onlyPendingOwner
91     {
92         emit OwnershipTransferred(owner, pendingOwner);
93         owner = pendingOwner;
94         pendingOwner = address(0);
95     }
96 }
97 
98 
99 // Copyright 2017 Loopring Technology Limited.
100 
101 
102 
103 
104 
105 /// @title DataStore
106 /// @dev Modules share states by accessing the same storage instance.
107 ///      Using ModuleStorage will achieve better module decoupling.
108 ///
109 /// @author Daniel Wang - <daniel@loopring.org>
110 ///
111 /// The design of this contract is inspired by Argent's contract codebase:
112 /// https://github.com/argentlabs/argent-contracts
113 abstract contract DataStore
114 {
115     modifier onlyWalletModule(address wallet)
116     {
117         require(Wallet(wallet).hasModule(msg.sender), "UNAUTHORIZED");
118         _;
119     }
120 }
121 // Taken from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/SafeCast.sol
122 
123 
124 
125 
126 /**
127  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
128  * checks.
129  *
130  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
131  * easily result in undesired exploitation or bugs, since developers usually
132  * assume that overflows raise errors. `SafeCast` restores this intuition by
133  * reverting the transaction when such an operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  *
138  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
139  * all math on `uint256` and `int256` and then downcasting.
140  */
141 library SafeCast {
142 
143     /**
144      * @dev Returns the downcasted uint128 from uint256, reverting on
145      * overflow (when the input is greater than largest uint128).
146      *
147      * Counterpart to Solidity's `uint128` operator.
148      *
149      * Requirements:
150      *
151      * - input must fit into 128 bits
152      */
153     function toUint128(uint256 value) internal pure returns (uint128) {
154         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
155         return uint128(value);
156     }
157 
158     /**
159      * @dev Returns the downcasted uint64 from uint256, reverting on
160      * overflow (when the input is greater than largest uint64).
161      *
162      * Counterpart to Solidity's `uint64` operator.
163      *
164      * Requirements:
165      *
166      * - input must fit into 64 bits
167      */
168     function toUint64(uint256 value) internal pure returns (uint64) {
169         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
170         return uint64(value);
171     }
172 
173     /**
174      * @dev Returns the downcasted uint32 from uint256, reverting on
175      * overflow (when the input is greater than largest uint32).
176      *
177      * Counterpart to Solidity's `uint32` operator.
178      *
179      * Requirements:
180      *
181      * - input must fit into 32 bits
182      */
183     function toUint32(uint256 value) internal pure returns (uint32) {
184         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
185         return uint32(value);
186     }
187 
188     /**
189      * @dev Returns the downcasted uint40 from uint256, reverting on
190      * overflow (when the input is greater than largest uint40).
191      *
192      * Counterpart to Solidity's `uint32` operator.
193      *
194      * Requirements:
195      *
196      * - input must fit into 40 bits
197      */
198     function toUint40(uint256 value) internal pure returns (uint40) {
199         require(value < 2**40, "SafeCast: value doesn\'t fit in 40 bits");
200         return uint40(value);
201     }
202 
203     /**
204      * @dev Returns the downcasted uint16 from uint256, reverting on
205      * overflow (when the input is greater than largest uint16).
206      *
207      * Counterpart to Solidity's `uint16` operator.
208      *
209      * Requirements:
210      *
211      * - input must fit into 16 bits
212      */
213     function toUint16(uint256 value) internal pure returns (uint16) {
214         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
215         return uint16(value);
216     }
217 
218     /**
219      * @dev Returns the downcasted uint8 from uint256, reverting on
220      * overflow (when the input is greater than largest uint8).
221      *
222      * Counterpart to Solidity's `uint8` operator.
223      *
224      * Requirements:
225      *
226      * - input must fit into 8 bits.
227      */
228     function toUint8(uint256 value) internal pure returns (uint8) {
229         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
230         return uint8(value);
231     }
232 
233     /**
234      * @dev Converts a signed int256 into an unsigned uint256.
235      *
236      * Requirements:
237      *
238      * - input must be greater than or equal to 0.
239      */
240     function toUint256(int256 value) internal pure returns (uint256) {
241         require(value >= 0, "SafeCast: value must be positive");
242         return uint256(value);
243     }
244 
245     /**
246      * @dev Returns the downcasted int128 from int256, reverting on
247      * overflow (when the input is less than smallest int128 or
248      * greater than largest int128).
249      *
250      * Counterpart to Solidity's `int128` operator.
251      *
252      * Requirements:
253      *
254      * - input must fit into 128 bits
255      *
256      * _Available since v3.1._
257      */
258     function toInt128(int256 value) internal pure returns (int128) {
259         require(value >= -2**127 && value < 2**127, "SafeCast: value doesn\'t fit in 128 bits");
260         return int128(value);
261     }
262 
263     /**
264      * @dev Returns the downcasted int64 from int256, reverting on
265      * overflow (when the input is less than smallest int64 or
266      * greater than largest int64).
267      *
268      * Counterpart to Solidity's `int64` operator.
269      *
270      * Requirements:
271      *
272      * - input must fit into 64 bits
273      *
274      * _Available since v3.1._
275      */
276     function toInt64(int256 value) internal pure returns (int64) {
277         require(value >= -2**63 && value < 2**63, "SafeCast: value doesn\'t fit in 64 bits");
278         return int64(value);
279     }
280 
281     /**
282      * @dev Returns the downcasted int32 from int256, reverting on
283      * overflow (when the input is less than smallest int32 or
284      * greater than largest int32).
285      *
286      * Counterpart to Solidity's `int32` operator.
287      *
288      * Requirements:
289      *
290      * - input must fit into 32 bits
291      *
292      * _Available since v3.1._
293      */
294     function toInt32(int256 value) internal pure returns (int32) {
295         require(value >= -2**31 && value < 2**31, "SafeCast: value doesn\'t fit in 32 bits");
296         return int32(value);
297     }
298 
299     /**
300      * @dev Returns the downcasted int16 from int256, reverting on
301      * overflow (when the input is less than smallest int16 or
302      * greater than largest int16).
303      *
304      * Counterpart to Solidity's `int16` operator.
305      *
306      * Requirements:
307      *
308      * - input must fit into 16 bits
309      *
310      * _Available since v3.1._
311      */
312     function toInt16(int256 value) internal pure returns (int16) {
313         require(value >= -2**15 && value < 2**15, "SafeCast: value doesn\'t fit in 16 bits");
314         return int16(value);
315     }
316 
317     /**
318      * @dev Returns the downcasted int8 from int256, reverting on
319      * overflow (when the input is less than smallest int8 or
320      * greater than largest int8).
321      *
322      * Counterpart to Solidity's `int8` operator.
323      *
324      * Requirements:
325      *
326      * - input must fit into 8 bits.
327      *
328      * _Available since v3.1._
329      */
330     function toInt8(int256 value) internal pure returns (int8) {
331         require(value >= -2**7 && value < 2**7, "SafeCast: value doesn\'t fit in 8 bits");
332         return int8(value);
333     }
334 
335     /**
336      * @dev Converts an unsigned uint256 into a signed int256.
337      *
338      * Requirements:
339      *
340      * - input must be less than or equal to maxInt256.
341      */
342     function toInt256(uint256 value) internal pure returns (int256) {
343         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
344         return int256(value);
345     }
346 }
347 // Copyright 2017 Loopring Technology Limited.
348 
349 
350 
351 library Data
352 {
353     // Optimized to fit into 32 bytes (1 slot)
354     struct Guardian
355     {
356         address addr;
357         uint16  group;
358         uint40  validSince;
359         uint40  validUntil;
360     }
361 }
362 
363 // Copyright 2017 Loopring Technology Limited.
364 
365 
366 
367 /// @title Utility Functions for uint
368 /// @author Daniel Wang - <daniel@loopring.org>
369 library MathUint
370 {
371     function mul(
372         uint a,
373         uint b
374         )
375         internal
376         pure
377         returns (uint c)
378     {
379         c = a * b;
380         require(a == 0 || c / a == b, "MUL_OVERFLOW");
381     }
382 
383     function sub(
384         uint a,
385         uint b
386         )
387         internal
388         pure
389         returns (uint)
390     {
391         require(b <= a, "SUB_UNDERFLOW");
392         return a - b;
393     }
394 
395     function add(
396         uint a,
397         uint b
398         )
399         internal
400         pure
401         returns (uint c)
402     {
403         c = a + b;
404         require(c >= a, "ADD_OVERFLOW");
405     }
406 }
407 
408 // Copyright 2017 Loopring Technology Limited.
409 
410 
411 
412 /// @title WalletRegistry
413 /// @dev A registry for wallets.
414 /// @author Daniel Wang - <daniel@loopring.org>
415 interface WalletRegistry
416 {
417     function registerWallet(address wallet) external;
418     function isWalletRegistered(address addr) external view returns (bool);
419     function numOfWallets() external view returns (uint);
420 }
421 
422 /*
423  * @title String & slice utility library for Solidity contracts.
424  * @author Nick Johnson <arachnid@notdot.net>
425  *
426  * @dev Functionality in this library is largely implemented using an
427  *      abstraction called a 'slice'. A slice represents a part of a string -
428  *      anything from the entire string to a single character, or even no
429  *      characters at all (a 0-length slice). Since a slice only has to specify
430  *      an offset and a length, copying and manipulating slices is a lot less
431  *      expensive than copying and manipulating the strings they reference.
432  *
433  *      To further reduce gas costs, most functions on slice that need to return
434  *      a slice modify the original one instead of allocating a new one; for
435  *      instance, `s.split(".")` will return the text up to the first '.',
436  *      modifying s to only contain the remainder of the string after the '.'.
437  *      In situations where you do not want to modify the original slice, you
438  *      can make a copy first with `.copy()`, for example:
439  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
440  *      Solidity has no memory management, it will result in allocating many
441  *      short-lived slices that are later discarded.
442  *
443  *      Functions that return two slices come in two versions: a non-allocating
444  *      version that takes the second slice as an argument, modifying it in
445  *      place, and an allocating version that allocates and returns the second
446  *      slice; see `nextRune` for example.
447  *
448  *      Functions that have to copy string data will return strings rather than
449  *      slices; these can be cast back to slices for further processing if
450  *      required.
451  *
452  *      For convenience, some functions are provided with non-modifying
453  *      variants that create a new slice and return both; for instance,
454  *      `s.splitNew('.')` leaves s unmodified, and returns two values
455  *      corresponding to the left and right parts of the string.
456  */
457 
458 
459 
460 /* solium-disable */
461 library strings {
462     struct slice {
463         uint _len;
464         uint _ptr;
465     }
466 
467     function memcpy(uint dest, uint src, uint len) private pure {
468         // Copy word-length chunks while possible
469         for(; len >= 32; len -= 32) {
470             assembly {
471                 mstore(dest, mload(src))
472             }
473             dest += 32;
474             src += 32;
475         }
476 
477         // Copy remaining bytes
478         uint mask = 256 ** (32 - len) - 1;
479         assembly {
480             let srcpart := and(mload(src), not(mask))
481             let destpart := and(mload(dest), mask)
482             mstore(dest, or(destpart, srcpart))
483         }
484     }
485 
486     /*
487      * @dev Returns a slice containing the entire string.
488      * @param self The string to make a slice from.
489      * @return A newly allocated slice containing the entire string.
490      */
491     function toSlice(string memory self) internal pure returns (slice memory) {
492         uint ptr;
493         assembly {
494             ptr := add(self, 0x20)
495         }
496         return slice(bytes(self).length, ptr);
497     }
498 
499     /*
500      * @dev Returns the length of a null-terminated bytes32 string.
501      * @param self The value to find the length of.
502      * @return The length of the string, from 0 to 32.
503      */
504     function len(bytes32 self) internal pure returns (uint) {
505         uint ret;
506         if (self == 0)
507             return 0;
508         if (uint256(self) & 0xffffffffffffffffffffffffffffffff == 0) {
509             ret += 16;
510             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
511         }
512         if (uint256(self) & 0xffffffffffffffff == 0) {
513             ret += 8;
514             self = bytes32(uint(self) / 0x10000000000000000);
515         }
516         if (uint256(self) & 0xffffffff == 0) {
517             ret += 4;
518             self = bytes32(uint(self) / 0x100000000);
519         }
520         if (uint256(self) & 0xffff == 0) {
521             ret += 2;
522             self = bytes32(uint(self) / 0x10000);
523         }
524         if (uint256(self) & 0xff == 0) {
525             ret += 1;
526         }
527         return 32 - ret;
528     }
529 
530     /*
531      * @dev Returns a slice containing the entire bytes32, interpreted as a
532      *      null-terminated utf-8 string.
533      * @param self The bytes32 value to convert to a slice.
534      * @return A new slice containing the value of the input argument up to the
535      *         first null.
536      */
537     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
538         // Allocate space for `self` in memory, copy it there, and point ret at it
539         assembly {
540             let ptr := mload(0x40)
541             mstore(0x40, add(ptr, 0x20))
542             mstore(ptr, self)
543             mstore(add(ret, 0x20), ptr)
544         }
545         ret._len = len(self);
546     }
547 
548     /*
549      * @dev Returns a new slice containing the same data as the current slice.
550      * @param self The slice to copy.
551      * @return A new slice containing the same data as `self`.
552      */
553     function copy(slice memory self) internal pure returns (slice memory) {
554         return slice(self._len, self._ptr);
555     }
556 
557     /*
558      * @dev Copies a slice to a new string.
559      * @param self The slice to copy.
560      * @return A newly allocated string containing the slice's text.
561      */
562     function toString(slice memory self) internal pure returns (string memory) {
563         string memory ret = new string(self._len);
564         uint retptr;
565         assembly { retptr := add(ret, 32) }
566 
567         memcpy(retptr, self._ptr, self._len);
568         return ret;
569     }
570 
571     /*
572      * @dev Returns the length in runes of the slice. Note that this operation
573      *      takes time proportional to the length of the slice; avoid using it
574      *      in loops, and call `slice.empty()` if you only need to kblock.timestamp whether
575      *      the slice is empty or not.
576      * @param self The slice to operate on.
577      * @return The length of the slice in runes.
578      */
579     function len(slice memory self) internal pure returns (uint l) {
580         // Starting at ptr-31 means the LSB will be the byte we care about
581         uint ptr = self._ptr - 31;
582         uint end = ptr + self._len;
583         for (l = 0; ptr < end; l++) {
584             uint8 b;
585             assembly { b := and(mload(ptr), 0xFF) }
586             if (b < 0x80) {
587                 ptr += 1;
588             } else if(b < 0xE0) {
589                 ptr += 2;
590             } else if(b < 0xF0) {
591                 ptr += 3;
592             } else if(b < 0xF8) {
593                 ptr += 4;
594             } else if(b < 0xFC) {
595                 ptr += 5;
596             } else {
597                 ptr += 6;
598             }
599         }
600     }
601 
602     /*
603      * @dev Returns true if the slice is empty (has a length of 0).
604      * @param self The slice to operate on.
605      * @return True if the slice is empty, False otherwise.
606      */
607     function empty(slice memory self) internal pure returns (bool) {
608         return self._len == 0;
609     }
610 
611     /*
612      * @dev Returns a positive number if `other` comes lexicographically after
613      *      `self`, a negative number if it comes before, or zero if the
614      *      contents of the two slices are equal. Comparison is done per-rune,
615      *      on unicode codepoints.
616      * @param self The first slice to compare.
617      * @param other The second slice to compare.
618      * @return The result of the comparison.
619      */
620     function compare(slice memory self, slice memory other) internal pure returns (int) {
621         uint shortest = self._len;
622         if (other._len < self._len)
623             shortest = other._len;
624 
625         uint selfptr = self._ptr;
626         uint otherptr = other._ptr;
627         for (uint idx = 0; idx < shortest; idx += 32) {
628             uint a;
629             uint b;
630             assembly {
631                 a := mload(selfptr)
632                 b := mload(otherptr)
633             }
634             if (a != b) {
635                 // Mask out irrelevant bytes and check again
636                 uint256 mask = uint256(-1); // 0xffff...
637                 if(shortest < 32) {
638                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
639                 }
640                 uint256 diff = (a & mask) - (b & mask);
641                 if (diff != 0)
642                     return int(diff);
643             }
644             selfptr += 32;
645             otherptr += 32;
646         }
647         return int(self._len) - int(other._len);
648     }
649 
650     /*
651      * @dev Returns true if the two slices contain the same text.
652      * @param self The first slice to compare.
653      * @param self The second slice to compare.
654      * @return True if the slices are equal, false otherwise.
655      */
656     function equals(slice memory self, slice memory other) internal pure returns (bool) {
657         return compare(self, other) == 0;
658     }
659 
660     /*
661      * @dev Extracts the first rune in the slice into `rune`, advancing the
662      *      slice to point to the next rune and returning `self`.
663      * @param self The slice to operate on.
664      * @param rune The slice that will contain the first rune.
665      * @return `rune`.
666      */
667     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
668         rune._ptr = self._ptr;
669 
670         if (self._len == 0) {
671             rune._len = 0;
672             return rune;
673         }
674 
675         uint l;
676         uint b;
677         // Load the first byte of the rune into the LSBs of b
678         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
679         if (b < 0x80) {
680             l = 1;
681         } else if(b < 0xE0) {
682             l = 2;
683         } else if(b < 0xF0) {
684             l = 3;
685         } else {
686             l = 4;
687         }
688 
689         // Check for truncated codepoints
690         if (l > self._len) {
691             rune._len = self._len;
692             self._ptr += self._len;
693             self._len = 0;
694             return rune;
695         }
696 
697         self._ptr += l;
698         self._len -= l;
699         rune._len = l;
700         return rune;
701     }
702 
703     /*
704      * @dev Returns the first rune in the slice, advancing the slice to point
705      *      to the next rune.
706      * @param self The slice to operate on.
707      * @return A slice containing only the first rune from `self`.
708      */
709     function nextRune(slice memory self) internal pure returns (slice memory ret) {
710         nextRune(self, ret);
711     }
712 
713     /*
714      * @dev Returns the number of the first codepoint in the slice.
715      * @param self The slice to operate on.
716      * @return The number of the first codepoint in the slice.
717      */
718     function ord(slice memory self) internal pure returns (uint ret) {
719         if (self._len == 0) {
720             return 0;
721         }
722 
723         uint word;
724         uint length;
725         uint divisor = 2 ** 248;
726 
727         // Load the rune into the MSBs of b
728         assembly { word:= mload(mload(add(self, 32))) }
729         uint b = word / divisor;
730         if (b < 0x80) {
731             ret = b;
732             length = 1;
733         } else if(b < 0xE0) {
734             ret = b & 0x1F;
735             length = 2;
736         } else if(b < 0xF0) {
737             ret = b & 0x0F;
738             length = 3;
739         } else {
740             ret = b & 0x07;
741             length = 4;
742         }
743 
744         // Check for truncated codepoints
745         if (length > self._len) {
746             return 0;
747         }
748 
749         for (uint i = 1; i < length; i++) {
750             divisor = divisor / 256;
751             b = (word / divisor) & 0xFF;
752             if (b & 0xC0 != 0x80) {
753                 // Invalid UTF-8 sequence
754                 return 0;
755             }
756             ret = (ret * 64) | (b & 0x3F);
757         }
758 
759         return ret;
760     }
761 
762     /*
763      * @dev Returns the keccak-256 hash of the slice.
764      * @param self The slice to hash.
765      * @return The hash of the slice.
766      */
767     function keccak(slice memory self) internal pure returns (bytes32 ret) {
768         assembly {
769             ret := keccak256(mload(add(self, 32)), mload(self))
770         }
771     }
772 
773     /*
774      * @dev Returns true if `self` starts with `needle`.
775      * @param self The slice to operate on.
776      * @param needle The slice to search for.
777      * @return True if the slice starts with the provided text, false otherwise.
778      */
779     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
780         if (self._len < needle._len) {
781             return false;
782         }
783 
784         if (self._ptr == needle._ptr) {
785             return true;
786         }
787 
788         bool equal;
789         assembly {
790             let length := mload(needle)
791             let selfptr := mload(add(self, 0x20))
792             let needleptr := mload(add(needle, 0x20))
793             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
794         }
795         return equal;
796     }
797 
798     /*
799      * @dev If `self` starts with `needle`, `needle` is removed from the
800      *      beginning of `self`. Otherwise, `self` is unmodified.
801      * @param self The slice to operate on.
802      * @param needle The slice to search for.
803      * @return `self`
804      */
805     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
806         if (self._len < needle._len) {
807             return self;
808         }
809 
810         bool equal = true;
811         if (self._ptr != needle._ptr) {
812             assembly {
813                 let length := mload(needle)
814                 let selfptr := mload(add(self, 0x20))
815                 let needleptr := mload(add(needle, 0x20))
816                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
817             }
818         }
819 
820         if (equal) {
821             self._len -= needle._len;
822             self._ptr += needle._len;
823         }
824 
825         return self;
826     }
827 
828     /*
829      * @dev Returns true if the slice ends with `needle`.
830      * @param self The slice to operate on.
831      * @param needle The slice to search for.
832      * @return True if the slice starts with the provided text, false otherwise.
833      */
834     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
835         if (self._len < needle._len) {
836             return false;
837         }
838 
839         uint selfptr = self._ptr + self._len - needle._len;
840 
841         if (selfptr == needle._ptr) {
842             return true;
843         }
844 
845         bool equal;
846         assembly {
847             let length := mload(needle)
848             let needleptr := mload(add(needle, 0x20))
849             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
850         }
851 
852         return equal;
853     }
854 
855     /*
856      * @dev If `self` ends with `needle`, `needle` is removed from the
857      *      end of `self`. Otherwise, `self` is unmodified.
858      * @param self The slice to operate on.
859      * @param needle The slice to search for.
860      * @return `self`
861      */
862     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
863         if (self._len < needle._len) {
864             return self;
865         }
866 
867         uint selfptr = self._ptr + self._len - needle._len;
868         bool equal = true;
869         if (selfptr != needle._ptr) {
870             assembly {
871                 let length := mload(needle)
872                 let needleptr := mload(add(needle, 0x20))
873                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
874             }
875         }
876 
877         if (equal) {
878             self._len -= needle._len;
879         }
880 
881         return self;
882     }
883 
884     // Returns the memory address of the first byte of the first occurrence of
885     // `needle` in `self`, or the first byte after `self` if not found.
886     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
887         uint ptr = selfptr;
888         uint idx;
889 
890         if (needlelen <= selflen) {
891             if (needlelen <= 32) {
892                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
893 
894                 bytes32 needledata;
895                 assembly { needledata := and(mload(needleptr), mask) }
896 
897                 uint end = selfptr + selflen - needlelen;
898                 bytes32 ptrdata;
899                 assembly { ptrdata := and(mload(ptr), mask) }
900 
901                 while (ptrdata != needledata) {
902                     if (ptr >= end)
903                         return selfptr + selflen;
904                     ptr++;
905                     assembly { ptrdata := and(mload(ptr), mask) }
906                 }
907                 return ptr;
908             } else {
909                 // For long needles, use hashing
910                 bytes32 hash;
911                 assembly { hash := keccak256(needleptr, needlelen) }
912 
913                 for (idx = 0; idx <= selflen - needlelen; idx++) {
914                     bytes32 testHash;
915                     assembly { testHash := keccak256(ptr, needlelen) }
916                     if (hash == testHash)
917                         return ptr;
918                     ptr += 1;
919                 }
920             }
921         }
922         return selfptr + selflen;
923     }
924 
925     // Returns the memory address of the first byte after the last occurrence of
926     // `needle` in `self`, or the address of `self` if not found.
927     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
928         uint ptr;
929 
930         if (needlelen <= selflen) {
931             if (needlelen <= 32) {
932                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
933 
934                 bytes32 needledata;
935                 assembly { needledata := and(mload(needleptr), mask) }
936 
937                 ptr = selfptr + selflen - needlelen;
938                 bytes32 ptrdata;
939                 assembly { ptrdata := and(mload(ptr), mask) }
940 
941                 while (ptrdata != needledata) {
942                     if (ptr <= selfptr)
943                         return selfptr;
944                     ptr--;
945                     assembly { ptrdata := and(mload(ptr), mask) }
946                 }
947                 return ptr + needlelen;
948             } else {
949                 // For long needles, use hashing
950                 bytes32 hash;
951                 assembly { hash := keccak256(needleptr, needlelen) }
952                 ptr = selfptr + (selflen - needlelen);
953                 while (ptr >= selfptr) {
954                     bytes32 testHash;
955                     assembly { testHash := keccak256(ptr, needlelen) }
956                     if (hash == testHash)
957                         return ptr + needlelen;
958                     ptr -= 1;
959                 }
960             }
961         }
962         return selfptr;
963     }
964 
965     /*
966      * @dev Modifies `self` to contain everything from the first occurrence of
967      *      `needle` to the end of the slice. `self` is set to the empty slice
968      *      if `needle` is not found.
969      * @param self The slice to search and modify.
970      * @param needle The text to search for.
971      * @return `self`.
972      */
973     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
974         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
975         self._len -= ptr - self._ptr;
976         self._ptr = ptr;
977         return self;
978     }
979 
980     /*
981      * @dev Modifies `self` to contain the part of the string from the start of
982      *      `self` to the end of the first occurrence of `needle`. If `needle`
983      *      is not found, `self` is set to the empty slice.
984      * @param self The slice to search and modify.
985      * @param needle The text to search for.
986      * @return `self`.
987      */
988     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
989         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
990         self._len = ptr - self._ptr;
991         return self;
992     }
993 
994     /*
995      * @dev Splits the slice, setting `self` to everything after the first
996      *      occurrence of `needle`, and `token` to everything before it. If
997      *      `needle` does not occur in `self`, `self` is set to the empty slice,
998      *      and `token` is set to the entirety of `self`.
999      * @param self The slice to split.
1000      * @param needle The text to search for in `self`.
1001      * @param token An output parameter to which the first token is written.
1002      * @return `token`.
1003      */
1004     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1005         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1006         token._ptr = self._ptr;
1007         token._len = ptr - self._ptr;
1008         if (ptr == self._ptr + self._len) {
1009             // Not found
1010             self._len = 0;
1011         } else {
1012             self._len -= token._len + needle._len;
1013             self._ptr = ptr + needle._len;
1014         }
1015         return token;
1016     }
1017 
1018     /*
1019      * @dev Splits the slice, setting `self` to everything after the first
1020      *      occurrence of `needle`, and returning everything before it. If
1021      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1022      *      and the entirety of `self` is returned.
1023      * @param self The slice to split.
1024      * @param needle The text to search for in `self`.
1025      * @return The part of `self` up to the first occurrence of `delim`.
1026      */
1027     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1028         split(self, needle, token);
1029     }
1030 
1031     /*
1032      * @dev Splits the slice, setting `self` to everything before the last
1033      *      occurrence of `needle`, and `token` to everything after it. If
1034      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1035      *      and `token` is set to the entirety of `self`.
1036      * @param self The slice to split.
1037      * @param needle The text to search for in `self`.
1038      * @param token An output parameter to which the first token is written.
1039      * @return `token`.
1040      */
1041     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1042         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1043         token._ptr = ptr;
1044         token._len = self._len - (ptr - self._ptr);
1045         if (ptr == self._ptr) {
1046             // Not found
1047             self._len = 0;
1048         } else {
1049             self._len -= token._len + needle._len;
1050         }
1051         return token;
1052     }
1053 
1054     /*
1055      * @dev Splits the slice, setting `self` to everything before the last
1056      *      occurrence of `needle`, and returning everything after it. If
1057      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1058      *      and the entirety of `self` is returned.
1059      * @param self The slice to split.
1060      * @param needle The text to search for in `self`.
1061      * @return The part of `self` after the last occurrence of `delim`.
1062      */
1063     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1064         rsplit(self, needle, token);
1065     }
1066 
1067     /*
1068      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1069      * @param self The slice to search.
1070      * @param needle The text to search for in `self`.
1071      * @return The number of occurrences of `needle` found in `self`.
1072      */
1073     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1074         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1075         while (ptr <= self._ptr + self._len) {
1076             cnt++;
1077             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1078         }
1079     }
1080 
1081     /*
1082      * @dev Returns True if `self` contains `needle`.
1083      * @param self The slice to search.
1084      * @param needle The text to search for in `self`.
1085      * @return True if `needle` is found in `self`, false otherwise.
1086      */
1087     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1088         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1089     }
1090 
1091     /*
1092      * @dev Returns a newly allocated string containing the concatenation of
1093      *      `self` and `other`.
1094      * @param self The first slice to concatenate.
1095      * @param other The second slice to concatenate.
1096      * @return The concatenation of the two strings.
1097      */
1098     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1099         string memory ret = new string(self._len + other._len);
1100         uint retptr;
1101         assembly { retptr := add(ret, 32) }
1102         memcpy(retptr, self._ptr, self._len);
1103         memcpy(retptr + self._len, other._ptr, other._len);
1104         return ret;
1105     }
1106 
1107     /*
1108      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1109      *      newly allocated string.
1110      * @param self The delimiter to use.
1111      * @param parts A list of slices to join.
1112      * @return A newly allocated string containing all the slices in `parts`,
1113      *         joined with `self`.
1114      */
1115     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1116         if (parts.length == 0)
1117             return "";
1118 
1119         uint length = self._len * (parts.length - 1);
1120         for(uint i = 0; i < parts.length; i++)
1121             length += parts[i]._len;
1122 
1123         string memory ret = new string(length);
1124         uint retptr;
1125         assembly { retptr := add(ret, 32) }
1126 
1127         for(uint i = 0; i < parts.length; i++) {
1128             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1129             retptr += parts[i]._len;
1130             if (i < parts.length - 1) {
1131                 memcpy(retptr, self._ptr, self._len);
1132                 retptr += self._len;
1133             }
1134         }
1135 
1136         return ret;
1137     }
1138 }
1139 
1140 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENS.sol
1141 // with few modifications.
1142 
1143 
1144 
1145 /**
1146  * ENS Registry interface.
1147  */
1148 interface ENSRegistry {
1149     // Logged when the owner of a node assigns a new owner to a subnode.
1150     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
1151 
1152     // Logged when the owner of a node transfers ownership to a new account.
1153     event Transfer(bytes32 indexed node, address owner);
1154 
1155     // Logged when the resolver for a node changes.
1156     event NewResolver(bytes32 indexed node, address resolver);
1157 
1158     // Logged when the TTL of a node changes
1159     event NewTTL(bytes32 indexed node, uint64 ttl);
1160 
1161     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
1162     function setResolver(bytes32 node, address resolver) external;
1163     function setOwner(bytes32 node, address owner) external;
1164     function setTTL(bytes32 node, uint64 ttl) external;
1165     function owner(bytes32 node) external view returns (address);
1166     function resolver(bytes32 node) external view returns (address);
1167     function ttl(bytes32 node) external view returns (uint64);
1168 }
1169 
1170 
1171 /**
1172  * ENS Resolver interface.
1173  */
1174 abstract contract ENSResolver {
1175     function addr(bytes32 _node) public view virtual returns (address);
1176     function setAddr(bytes32 _node, address _addr) public virtual;
1177     function name(bytes32 _node) public view virtual returns (string memory);
1178     function setName(bytes32 _node, string memory _name) public virtual;
1179 }
1180 
1181 /**
1182  * ENS Reverse Registrar interface.
1183  */
1184 abstract contract ENSReverseRegistrar {
1185     function claim(address _owner) public virtual returns (bytes32 _node);
1186     function claimWithResolver(address _owner, address _resolver) public virtual returns (bytes32);
1187     function setName(string memory _name) public virtual returns (bytes32);
1188     function node(address _addr) public view virtual returns (bytes32);
1189 }
1190 
1191 // Copyright 2017 Loopring Technology Limited.
1192 
1193 
1194 
1195 /// @title AddressSet
1196 /// @author Daniel Wang - <daniel@loopring.org>
1197 contract AddressSet
1198 {
1199     struct Set
1200     {
1201         address[] addresses;
1202         mapping (address => uint) positions;
1203         uint count;
1204     }
1205     mapping (bytes32 => Set) private sets;
1206 
1207     function addAddressToSet(
1208         bytes32 key,
1209         address addr,
1210         bool    maintainList
1211         ) internal
1212     {
1213         Set storage set = sets[key];
1214         require(set.positions[addr] == 0, "ALREADY_IN_SET");
1215 
1216         if (maintainList) {
1217             require(set.addresses.length == set.count, "PREVIOUSLY_NOT_MAINTAILED");
1218             set.addresses.push(addr);
1219         } else {
1220             require(set.addresses.length == 0, "MUST_MAINTAIN");
1221         }
1222 
1223         set.count += 1;
1224         set.positions[addr] = set.count;
1225     }
1226 
1227     function removeAddressFromSet(
1228         bytes32 key,
1229         address addr
1230         )
1231         internal
1232     {
1233         Set storage set = sets[key];
1234         uint pos = set.positions[addr];
1235         require(pos != 0, "NOT_IN_SET");
1236 
1237         delete set.positions[addr];
1238         set.count -= 1;
1239 
1240         if (set.addresses.length > 0) {
1241             address lastAddr = set.addresses[set.count];
1242             if (lastAddr != addr) {
1243                 set.addresses[pos - 1] = lastAddr;
1244                 set.positions[lastAddr] = pos;
1245             }
1246             set.addresses.pop();
1247         }
1248     }
1249 
1250     function removeSet(bytes32 key)
1251         internal
1252     {
1253         delete sets[key];
1254     }
1255 
1256     function isAddressInSet(
1257         bytes32 key,
1258         address addr
1259         )
1260         internal
1261         view
1262         returns (bool)
1263     {
1264         return sets[key].positions[addr] != 0;
1265     }
1266 
1267     function numAddressesInSet(bytes32 key)
1268         internal
1269         view
1270         returns (uint)
1271     {
1272         Set storage set = sets[key];
1273         return set.count;
1274     }
1275 
1276     function addressesInSet(bytes32 key)
1277         internal
1278         view
1279         returns (address[] memory)
1280     {
1281         Set storage set = sets[key];
1282         require(set.count == set.addresses.length, "NOT_MAINTAINED");
1283         return sets[key].addresses;
1284     }
1285 }
1286 //Mainly taken from https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
1287 
1288 
1289 library BytesUtil {
1290     function slice(
1291         bytes memory _bytes,
1292         uint _start,
1293         uint _length
1294     )
1295         internal
1296         pure
1297         returns (bytes memory)
1298     {
1299         require(_bytes.length >= (_start + _length));
1300 
1301         bytes memory tempBytes;
1302 
1303         assembly {
1304             switch iszero(_length)
1305             case 0 {
1306                 // Get a location of some free memory and store it in tempBytes as
1307                 // Solidity does for memory variables.
1308                 tempBytes := mload(0x40)
1309 
1310                 // The first word of the slice result is potentially a partial
1311                 // word read from the original array. To read it, we calculate
1312                 // the length of that partial word and start copying that many
1313                 // bytes into the array. The first word we copy will start with
1314                 // data we don't care about, but the last `lengthmod` bytes will
1315                 // land at the beginning of the contents of the new array. When
1316                 // we're done copying, we overwrite the full first word with
1317                 // the actual length of the slice.
1318                 let lengthmod := and(_length, 31)
1319 
1320                 // The multiplication in the next line is necessary
1321                 // because when slicing multiples of 32 bytes (lengthmod == 0)
1322                 // the following copy loop was copying the origin's length
1323                 // and then ending prematurely not copying everything it should.
1324                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
1325                 let end := add(mc, _length)
1326 
1327                 for {
1328                     // The multiplication in the next line has the same exact purpose
1329                     // as the one above.
1330                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
1331                 } lt(mc, end) {
1332                     mc := add(mc, 0x20)
1333                     cc := add(cc, 0x20)
1334                 } {
1335                     mstore(mc, mload(cc))
1336                 }
1337 
1338                 mstore(tempBytes, _length)
1339 
1340                 //update free-memory pointer
1341                 //allocating the array padded to 32 bytes like the compiler does now
1342                 mstore(0x40, and(add(mc, 31), not(31)))
1343             }
1344             //if we want a zero-length slice let's just return a zero-length array
1345             default {
1346                 tempBytes := mload(0x40)
1347 
1348                 mstore(0x40, add(tempBytes, 0x20))
1349             }
1350         }
1351 
1352         return tempBytes;
1353     }
1354 
1355     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
1356         require(_bytes.length >= (_start + 20));
1357         address tempAddress;
1358 
1359         assembly {
1360             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1361         }
1362 
1363         return tempAddress;
1364     }
1365 
1366     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
1367         require(_bytes.length >= (_start + 1));
1368         uint8 tempUint;
1369 
1370         assembly {
1371             tempUint := mload(add(add(_bytes, 0x1), _start))
1372         }
1373 
1374         return tempUint;
1375     }
1376 
1377     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
1378         require(_bytes.length >= (_start + 2));
1379         uint16 tempUint;
1380 
1381         assembly {
1382             tempUint := mload(add(add(_bytes, 0x2), _start))
1383         }
1384 
1385         return tempUint;
1386     }
1387 
1388     function toUint24(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
1389         require(_bytes.length >= (_start + 3));
1390         uint24 tempUint;
1391 
1392         assembly {
1393             tempUint := mload(add(add(_bytes, 0x3), _start))
1394         }
1395 
1396         return tempUint;
1397     }
1398 
1399     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
1400         require(_bytes.length >= (_start + 4));
1401         uint32 tempUint;
1402 
1403         assembly {
1404             tempUint := mload(add(add(_bytes, 0x4), _start))
1405         }
1406 
1407         return tempUint;
1408     }
1409 
1410     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
1411         require(_bytes.length >= (_start + 8));
1412         uint64 tempUint;
1413 
1414         assembly {
1415             tempUint := mload(add(add(_bytes, 0x8), _start))
1416         }
1417 
1418         return tempUint;
1419     }
1420 
1421     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
1422         require(_bytes.length >= (_start + 12));
1423         uint96 tempUint;
1424 
1425         assembly {
1426             tempUint := mload(add(add(_bytes, 0xc), _start))
1427         }
1428 
1429         return tempUint;
1430     }
1431 
1432     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
1433         require(_bytes.length >= (_start + 16));
1434         uint128 tempUint;
1435 
1436         assembly {
1437             tempUint := mload(add(add(_bytes, 0x10), _start))
1438         }
1439 
1440         return tempUint;
1441     }
1442 
1443     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
1444         require(_bytes.length >= (_start + 32));
1445         uint256 tempUint;
1446 
1447         assembly {
1448             tempUint := mload(add(add(_bytes, 0x20), _start))
1449         }
1450 
1451         return tempUint;
1452     }
1453 
1454     function toBytes4(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
1455         require(_bytes.length >= (_start + 4));
1456         bytes4 tempBytes4;
1457 
1458         assembly {
1459             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
1460         }
1461 
1462         return tempBytes4;
1463     }
1464 
1465     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
1466         require(_bytes.length >= (_start + 32));
1467         bytes32 tempBytes32;
1468 
1469         assembly {
1470             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
1471         }
1472 
1473         return tempBytes32;
1474     }
1475 
1476     function fastSHA256(
1477         bytes memory data
1478         )
1479         internal
1480         view
1481         returns (bytes32)
1482     {
1483         bytes32[] memory result = new bytes32[](1);
1484         bool success;
1485         assembly {
1486              let ptr := add(data, 32)
1487              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
1488         }
1489         require(success, "SHA256_FAILED");
1490         return result[0];
1491     }
1492 }
1493 
1494 // Copyright 2017 Loopring Technology Limited.
1495 
1496 
1497 
1498 /// @title Utility Functions for addresses
1499 /// @author Daniel Wang - <daniel@loopring.org>
1500 /// @author Brecht Devos - <brecht@loopring.org>
1501 library AddressUtil
1502 {
1503     using AddressUtil for *;
1504 
1505     function isContract(
1506         address addr
1507         )
1508         internal
1509         view
1510         returns (bool)
1511     {
1512         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1513         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1514         // for accounts without code, i.e. `keccak256('')`
1515         bytes32 codehash;
1516         // solhint-disable-next-line no-inline-assembly
1517         assembly { codehash := extcodehash(addr) }
1518         return (codehash != 0x0 &&
1519                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
1520     }
1521 
1522     function toPayable(
1523         address addr
1524         )
1525         internal
1526         pure
1527         returns (address payable)
1528     {
1529         return payable(addr);
1530     }
1531 
1532     // Works like address.send but with a customizable gas limit
1533     // Make sure your code is safe for reentrancy when using this function!
1534     function sendETH(
1535         address to,
1536         uint    amount,
1537         uint    gasLimit
1538         )
1539         internal
1540         returns (bool success)
1541     {
1542         if (amount == 0) {
1543             return true;
1544         }
1545         address payable recipient = to.toPayable();
1546         /* solium-disable-next-line */
1547         (success,) = recipient.call{value: amount, gas: gasLimit}("");
1548     }
1549 
1550     // Works like address.transfer but with a customizable gas limit
1551     // Make sure your code is safe for reentrancy when using this function!
1552     function sendETHAndVerify(
1553         address to,
1554         uint    amount,
1555         uint    gasLimit
1556         )
1557         internal
1558         returns (bool success)
1559     {
1560         success = to.sendETH(amount, gasLimit);
1561         require(success, "TRANSFER_FAILURE");
1562     }
1563 
1564     // Works like call but is slightly more efficient when data
1565     // needs to be copied from memory to do the call.
1566     function fastCall(
1567         address to,
1568         uint    gasLimit,
1569         uint    value,
1570         bytes   memory data
1571         )
1572         internal
1573         returns (bool success, bytes memory returnData)
1574     {
1575         if (to != address(0)) {
1576             assembly {
1577                 // Do the call
1578                 success := call(gasLimit, to, value, add(data, 32), mload(data), 0, 0)
1579                 // Copy the return data
1580                 let size := returndatasize()
1581                 returnData := mload(0x40)
1582                 mstore(returnData, size)
1583                 returndatacopy(add(returnData, 32), 0, size)
1584                 // Update free memory pointer
1585                 mstore(0x40, add(returnData, add(32, size)))
1586             }
1587         }
1588     }
1589 
1590     // Like fastCall, but throws when the call is unsuccessful.
1591     function fastCallAndVerify(
1592         address to,
1593         uint    gasLimit,
1594         uint    value,
1595         bytes   memory data
1596         )
1597         internal
1598         returns (bytes memory returnData)
1599     {
1600         bool success;
1601         (success, returnData) = fastCall(to, gasLimit, value, data);
1602         if (!success) {
1603             assembly {
1604                 revert(add(returnData, 32), mload(returnData))
1605             }
1606         }
1607     }
1608 }
1609 
1610 // Copyright 2017 Loopring Technology Limited.
1611 
1612 
1613 
1614 
1615 
1616 
1617 contract OwnerManagable is Claimable, AddressSet
1618 {
1619     bytes32 internal constant MANAGER = keccak256("__MANAGED__");
1620 
1621     event ManagerAdded  (address manager);
1622     event ManagerRemoved(address manager);
1623 
1624     modifier onlyManager
1625     {
1626         require(isManager(msg.sender), "NOT_MANAGER");
1627         _;
1628     }
1629 
1630     modifier onlyOwnerOrManager
1631     {
1632         require(msg.sender == owner || isManager(msg.sender), "NOT_OWNER_OR_MANAGER");
1633         _;
1634     }
1635 
1636     constructor() Claimable() {}
1637 
1638     /// @dev Gets the managers.
1639     /// @return The list of managers.
1640     function managers()
1641         public
1642         view
1643         returns (address[] memory)
1644     {
1645         return addressesInSet(MANAGER);
1646     }
1647 
1648     /// @dev Gets the number of managers.
1649     /// @return The numer of managers.
1650     function numManagers()
1651         public
1652         view
1653         returns (uint)
1654     {
1655         return numAddressesInSet(MANAGER);
1656     }
1657 
1658     /// @dev Checks if an address is a manger.
1659     /// @param addr The address to check.
1660     /// @return True if the address is a manager, False otherwise.
1661     function isManager(address addr)
1662         public
1663         view
1664         returns (bool)
1665     {
1666         return isAddressInSet(MANAGER, addr);
1667     }
1668 
1669     /// @dev Adds a new manager.
1670     /// @param manager The new address to add.
1671     function addManager(address manager)
1672         public
1673         onlyOwner
1674     {
1675         addManagerInternal(manager);
1676     }
1677 
1678     /// @dev Removes a manager.
1679     /// @param manager The manager to remove.
1680     function removeManager(address manager)
1681         public
1682         onlyOwner
1683     {
1684         removeAddressFromSet(MANAGER, manager);
1685         emit ManagerRemoved(manager);
1686     }
1687 
1688     function addManagerInternal(address manager)
1689         internal
1690     {
1691         addAddressToSet(MANAGER, manager, true);
1692         emit ManagerAdded(manager);
1693     }
1694 }
1695 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENSConsumer.sol
1696 // with few modifications.
1697 
1698 
1699 
1700 
1701 
1702 /**
1703  * @title ENSConsumer
1704  * @dev Helper contract to resolve ENS names.
1705  * @author Julien Niset - <julien@argent.im>
1706  */
1707 contract ENSConsumer {
1708 
1709     using strings for *;
1710 
1711     // namehash('addr.reverse')
1712     bytes32 constant public ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
1713 
1714     // the address of the ENS registry
1715     address ensRegistry;
1716 
1717     /**
1718     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The
1719     * contract will use the hardcoded value.
1720     */
1721     constructor(address _ensRegistry) {
1722         ensRegistry = _ensRegistry;
1723     }
1724 
1725     /**
1726     * @dev Resolves an ENS name to an address.
1727     * @param _node The namehash of the ENS name.
1728     */
1729     function resolveEns(bytes32 _node) public view returns (address) {
1730         address resolver = getENSRegistry().resolver(_node);
1731         return ENSResolver(resolver).addr(_node);
1732     }
1733 
1734     /**
1735     * @dev Gets the official ENS registry.
1736     */
1737     function getENSRegistry() public view returns (ENSRegistry) {
1738         return ENSRegistry(ensRegistry);
1739     }
1740 
1741     /**
1742     * @dev Gets the official ENS reverse registrar.
1743     */
1744     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
1745         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
1746     }
1747 }
1748 
1749 // Copyright 2017 Loopring Technology Limited.
1750 
1751 
1752 
1753 // Copyright 2017 Loopring Technology Limited.
1754 
1755 
1756 
1757 /// @title ModuleRegistry
1758 /// @dev A registry for modules.
1759 ///
1760 /// @author Daniel Wang - <daniel@loopring.org>
1761 interface ModuleRegistry
1762 {
1763     /// @dev Registers and enables a new module.
1764     function registerModule(address module) external;
1765 
1766     /// @dev Disables a module
1767     function disableModule(address module) external;
1768 
1769     /// @dev Returns true if the module is registered and enabled.
1770     function isModuleEnabled(address module) external view returns (bool);
1771 
1772     /// @dev Returns the list of enabled modules.
1773     function enabledModules() external view returns (address[] memory _modules);
1774 
1775     /// @dev Returns the number of enbaled modules.
1776     function numOfEnabledModules() external view returns (uint);
1777 
1778     /// @dev Returns true if the module is ever registered.
1779     function isModuleRegistered(address module) external view returns (bool);
1780 }
1781 
1782 
1783 
1784 
1785 /// @title Controller
1786 ///
1787 /// @author Daniel Wang - <daniel@loopring.org>
1788 abstract contract Controller
1789 {
1790     ModuleRegistry public moduleRegistry;
1791     WalletRegistry public walletRegistry;
1792     address        public walletFactory;
1793 }
1794 
1795 // Copyright 2017 Loopring Technology Limited.
1796 
1797 
1798 
1799 /// @title ReentrancyGuard
1800 /// @author Brecht Devos - <brecht@loopring.org>
1801 /// @dev Exposes a modifier that guards a function against reentrancy
1802 ///      Changing the value of the same storage value multiple times in a transaction
1803 ///      is cheap (starting from Istanbul) so there is no need to minimize
1804 ///      the number of times the value is changed
1805 contract ReentrancyGuard
1806 {
1807     //The default value must be 0 in order to work behind a proxy.
1808     uint private _guardValue;
1809 
1810     modifier nonReentrant()
1811     {
1812         require(_guardValue == 0, "REENTRANCY");
1813         _guardValue = 1;
1814         _;
1815         _guardValue = 0;
1816     }
1817 }
1818 
1819 // Copyright 2017 Loopring Technology Limited.
1820 
1821 
1822 
1823 /// @title ERC20 Token Interface
1824 /// @dev see https://github.com/ethereum/EIPs/issues/20
1825 /// @author Daniel Wang - <daniel@loopring.org>
1826 abstract contract ERC20
1827 {
1828     function totalSupply()
1829         public
1830         view
1831         virtual
1832         returns (uint);
1833 
1834     function balanceOf(
1835         address who
1836         )
1837         public
1838         view
1839         virtual
1840         returns (uint);
1841 
1842     function allowance(
1843         address owner,
1844         address spender
1845         )
1846         public
1847         view
1848         virtual
1849         returns (uint);
1850 
1851     function transfer(
1852         address to,
1853         uint value
1854         )
1855         public
1856         virtual
1857         returns (bool);
1858 
1859     function transferFrom(
1860         address from,
1861         address to,
1862         uint    value
1863         )
1864         public
1865         virtual
1866         returns (bool);
1867 
1868     function approve(
1869         address spender,
1870         uint    value
1871         )
1872         public
1873         virtual
1874         returns (bool);
1875 }
1876 
1877 // Copyright 2017 Loopring Technology Limited.
1878 
1879 
1880 
1881 /// @title Wallet
1882 /// @dev Base contract for smart wallets.
1883 ///      Sub-contracts must NOT use non-default constructor to initialize
1884 ///      wallet states, instead, `init` shall be used. This is to enable
1885 ///      proxies to be deployed in front of the real wallet contract for
1886 ///      saving gas.
1887 ///
1888 /// @author Daniel Wang - <daniel@loopring.org>
1889 ///
1890 /// The design of this contract is inspired by Argent's contract codebase:
1891 /// https://github.com/argentlabs/argent-contracts
1892 interface Wallet
1893 {
1894     function version() external pure returns (string memory);
1895 
1896     function owner() external view returns (address);
1897 
1898     /// @dev Set a new owner.
1899     function setOwner(address newOwner) external;
1900 
1901     /// @dev Adds a new module. The `init` method of the module
1902     ///      will be called with `address(this)` as the parameter.
1903     ///      This method must throw if the module has already been added.
1904     /// @param _module The module's address.
1905     function addModule(address _module) external;
1906 
1907     /// @dev Removes an existing module. This method must throw if the module
1908     ///      has NOT been added or the module is the wallet's only module.
1909     /// @param _module The module's address.
1910     function removeModule(address _module) external;
1911 
1912     /// @dev Checks if a module has been added to this wallet.
1913     /// @param _module The module to check.
1914     /// @return True if the module exists; False otherwise.
1915     function hasModule(address _module) external view returns (bool);
1916 
1917     /// @dev Binds a method from the given module to this
1918     ///      wallet so the method can be invoked using this wallet's default
1919     ///      function.
1920     ///      Note that this method must throw when the given module has
1921     ///      not been added to this wallet.
1922     /// @param _method The method's 4-byte selector.
1923     /// @param _module The module's address. Use address(0) to unbind the method.
1924     function bindMethod(bytes4 _method, address _module) external;
1925 
1926     /// @dev Returns the module the given method has been bound to.
1927     /// @param _method The method's 4-byte selector.
1928     /// @return _module The address of the bound module. If no binding exists,
1929     ///                 returns address(0) instead.
1930     function boundMethodModule(bytes4 _method) external view returns (address _module);
1931 
1932     /// @dev Performs generic transactions. Any module that has been added to this
1933     ///      wallet can use this method to transact on any third-party contract with
1934     ///      msg.sender as this wallet itself.
1935     ///
1936     ///      This method will emit `Transacted` event if it doesn't throw.
1937     ///
1938     ///      Note: this method must ONLY allow invocations from a module that has
1939     ///      been added to this wallet. The wallet owner shall NOT be permitted
1940     ///      to call this method directly.
1941     ///
1942     /// @param mode The transaction mode, 1 for CALL, 2 for DELEGATECALL.
1943     /// @param to The desitination address.
1944     /// @param value The amount of Ether to transfer.
1945     /// @param data The data to send over using `to.call{value: value}(data)`
1946     /// @return returnData The transaction's return value.
1947     function transact(
1948         uint8    mode,
1949         address  to,
1950         uint     value,
1951         bytes    calldata data
1952         )
1953         external
1954         returns (bytes memory returnData);
1955 }
1956 
1957 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ArgentENSManager.sol
1958 // with few modifications.
1959 
1960 
1961 
1962 
1963 
1964 
1965 
1966 
1967 /**
1968  * @dev Interface for an ENS Mananger.
1969  */
1970 interface IENSManager {
1971     function changeRootnodeOwner(address _newOwner) external;
1972 
1973     function isAvailable(bytes32 _subnode) external view returns (bool);
1974 
1975     function resolveName(address _wallet) external view returns (string memory);
1976 
1977     function register(
1978         address _wallet,
1979         address _owner,
1980         string  calldata _label,
1981         bytes   calldata _approval
1982     ) external;
1983 }
1984 
1985 /**
1986  * @title BaseENSManager
1987  * @dev Implementation of an ENS manager that orchestrates the complete
1988  * registration of subdomains for a single root (e.g. argent.eth).
1989  * The contract defines a manager role who is the only role that can trigger the registration of
1990  * a new subdomain.
1991  * @author Julien Niset - <julien@argent.im>
1992  */
1993 contract BaseENSManager is IENSManager, OwnerManagable, ENSConsumer {
1994 
1995     using strings for *;
1996     using BytesUtil     for bytes;
1997     using MathUint      for uint;
1998 
1999     // The managed root name
2000     string public rootName;
2001     // The managed root node
2002     bytes32 public rootNode;
2003     // The address of the ENS resolver
2004     address public ensResolver;
2005 
2006     // *************** Events *************************** //
2007 
2008     event RootnodeOwnerChange(bytes32 indexed _rootnode, address indexed _newOwner);
2009     event ENSResolverChanged(address addr);
2010     event Registered(address indexed _wallet, address _owner, string _ens);
2011     event Unregistered(string _ens);
2012 
2013     // *************** Constructor ********************** //
2014 
2015     /**
2016      * @dev Constructor that sets the ENS root name and root node to manage.
2017      * @param _rootName The root name (e.g. argentx.eth).
2018      * @param _rootNode The node of the root name (e.g. namehash(argentx.eth)).
2019      */
2020     constructor(string memory _rootName, bytes32 _rootNode, address _ensRegistry, address _ensResolver)
2021         ENSConsumer(_ensRegistry)
2022     {
2023         rootName = _rootName;
2024         rootNode = _rootNode;
2025         ensResolver = _ensResolver;
2026     }
2027 
2028     // *************** External Functions ********************* //
2029 
2030     /**
2031      * @dev This function must be called when the ENS Manager contract is replaced
2032      * and the address of the new Manager should be provided.
2033      * @param _newOwner The address of the new ENS manager that will manage the root node.
2034      */
2035     function changeRootnodeOwner(address _newOwner) external override onlyOwner {
2036         getENSRegistry().setOwner(rootNode, _newOwner);
2037         emit RootnodeOwnerChange(rootNode, _newOwner);
2038     }
2039 
2040     /**
2041      * @dev Lets the owner change the address of the ENS resolver contract.
2042      * @param _ensResolver The address of the ENS resolver contract.
2043      */
2044     function changeENSResolver(address _ensResolver) external onlyOwner {
2045         require(_ensResolver != address(0), "WF: address cannot be null");
2046         ensResolver = _ensResolver;
2047         emit ENSResolverChanged(_ensResolver);
2048     }
2049 
2050     /**
2051     * @dev Lets the manager assign an ENS subdomain of the root node to a target address.
2052     * Registers both the forward and reverse ENS.
2053     * @param _wallet The wallet which owns the subdomain.
2054     * @param _owner The wallet's owner.
2055     * @param _label The subdomain label.
2056     * @param _approval The signature of _wallet, _owner and _label by a manager.
2057     */
2058     function register(
2059         address _wallet,
2060         address _owner,
2061         string  calldata _label,
2062         bytes   calldata _approval
2063         )
2064         external
2065         override
2066         onlyManager
2067     {
2068         verifyApproval(_wallet, _owner, _label, _approval);
2069 
2070         bytes32 labelNode = keccak256(abi.encodePacked(_label));
2071         bytes32 node = keccak256(abi.encodePacked(rootNode, labelNode));
2072         address currentOwner = getENSRegistry().owner(node);
2073         require(currentOwner == address(0), "AEM: _label is alrealdy owned");
2074 
2075         // Forward ENS
2076         getENSRegistry().setSubnodeOwner(rootNode, labelNode, address(this));
2077         getENSRegistry().setResolver(node, ensResolver);
2078         getENSRegistry().setOwner(node, _wallet);
2079         ENSResolver(ensResolver).setAddr(node, _wallet);
2080 
2081         // Reverse ENS
2082         strings.slice[] memory parts = new strings.slice[](2);
2083         parts[0] = _label.toSlice();
2084         parts[1] = rootName.toSlice();
2085         string memory name = ".".toSlice().join(parts);
2086         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
2087         ENSResolver(ensResolver).setName(reverseNode, name);
2088 
2089         emit Registered(_wallet, _owner, name);
2090     }
2091 
2092     // *************** Public Functions ********************* //
2093 
2094     /**
2095     * @dev Resolves an address to an ENS name
2096     * @param _wallet The ENS owner address
2097     */
2098     function resolveName(address _wallet) public view override returns (string memory) {
2099         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
2100         return ENSResolver(ensResolver).name(reverseNode);
2101     }
2102 
2103     /**
2104      * @dev Returns true is a given subnode is available.
2105      * @param _subnode The target subnode.
2106      * @return true if the subnode is available.
2107      */
2108     function isAvailable(bytes32 _subnode) public view override returns (bool) {
2109         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
2110         address currentOwner = getENSRegistry().owner(node);
2111         if(currentOwner == address(0)) {
2112             return true;
2113         }
2114         return false;
2115     }
2116 
2117     function verifyApproval(
2118         address _wallet,
2119         address _owner,
2120         string  calldata _label,
2121         bytes   calldata _approval
2122         )
2123         internal
2124         view
2125     {
2126         bytes32 messageHash = keccak256(
2127             abi.encodePacked(
2128                 _wallet,
2129                 _owner,
2130                 _label
2131             )
2132         );
2133 
2134         bytes32 hash = keccak256(
2135             abi.encodePacked(
2136                 "\x19Ethereum Signed Message:\n32",
2137                 messageHash
2138             )
2139         );
2140 
2141         address signer = SignatureUtil.recoverECDSASigner(hash, _approval);
2142         require(isManager(signer), "UNAUTHORIZED");
2143     }
2144 
2145 }
2146 
2147 // Copyright 2017 Loopring Technology Limited.
2148 
2149 
2150 
2151 /// @title PriceOracle
2152 interface PriceOracle
2153 {
2154     // @dev Return's the token's value in ETH
2155     function tokenValue(address token, uint amount)
2156         external
2157         view
2158         returns (uint value);
2159 }
2160 // Copyright 2017 Loopring Technology Limited.
2161 
2162 
2163 
2164 
2165 
2166 // Copyright 2017 Loopring Technology Limited.
2167 
2168 
2169 
2170 
2171 
2172 
2173 
2174 
2175 
2176 
2177 /// @title DappAddressStore
2178 /// @dev This store maintains global whitelist dapps.
2179 contract DappAddressStore is DataStore, OwnerManagable
2180 {
2181     bytes32 internal constant DAPPS = keccak256("__DAPPS__");
2182 
2183     event Whitelisted(
2184         address addr,
2185         bool    whitelisted
2186     );
2187 
2188     constructor() DataStore() {}
2189 
2190     function addDapp(address addr)
2191         public
2192         onlyManager
2193     {
2194         addAddressToSet(DAPPS, addr, true);
2195         emit Whitelisted(addr, true);
2196     }
2197 
2198     function removeDapp(address addr)
2199         public
2200         onlyManager
2201     {
2202         removeAddressFromSet(DAPPS, addr);
2203         emit Whitelisted(addr, false);
2204     }
2205 
2206     function dapps()
2207         public
2208         view
2209         returns (
2210             address[] memory addresses
2211         )
2212     {
2213         return addressesInSet(DAPPS);
2214     }
2215 
2216     function isDapp(
2217         address addr
2218         )
2219         public
2220         view
2221         returns (bool)
2222     {
2223         return isAddressInSet(DAPPS, addr);
2224     }
2225 
2226     function numDapps()
2227         public
2228         view
2229         returns (uint)
2230     {
2231         return numAddressesInSet(DAPPS);
2232     }
2233 }
2234 
2235 // Copyright 2017 Loopring Technology Limited.
2236 
2237 
2238 
2239 
2240 
2241 
2242 /// @title HashStore
2243 /// @dev This store maintains all hashes for SignedRequest.
2244 contract HashStore is DataStore
2245 {
2246     // wallet => hash => consumed
2247     mapping(address => mapping(bytes32 => bool)) public hashes;
2248 
2249     constructor() {}
2250 
2251     function verifyAndUpdate(address wallet, bytes32 hash)
2252         public
2253         onlyWalletModule(wallet)
2254     {
2255         require(!hashes[wallet][hash], "HASH_EXIST");
2256         hashes[wallet][hash] = true;
2257     }
2258 }
2259 
2260 
2261 // Copyright 2017 Loopring Technology Limited.
2262 
2263 
2264 
2265 
2266 
2267 
2268 /// @title NonceStore
2269 /// @dev This store maintains all nonces for metaTx
2270 contract NonceStore is DataStore
2271 {
2272     mapping(address => uint) public nonces;
2273 
2274     constructor() DataStore() {}
2275 
2276     function lastNonce(address wallet)
2277         public
2278         view
2279         returns (uint)
2280     {
2281         return nonces[wallet];
2282     }
2283 
2284     function isNonceValid(address wallet, uint nonce)
2285         public
2286         view
2287         returns (bool)
2288     {
2289         return nonce > nonces[wallet] && (nonce >> 128) <= block.number;
2290     }
2291 
2292     function verifyAndUpdate(address wallet, uint nonce)
2293         public
2294         onlyWalletModule(wallet)
2295     {
2296         require(isNonceValid(wallet, nonce), "INVALID_NONCE");
2297         nonces[wallet] = nonce;
2298     }
2299 }
2300 
2301 
2302 // Copyright 2017 Loopring Technology Limited.
2303 
2304 
2305 
2306 
2307 
2308 
2309 
2310 /// @title QuotaStore
2311 /// @dev This store maintains daily spending quota for each wallet.
2312 ///      A rolling daily limit is used.
2313 contract QuotaStore is DataStore, Claimable
2314 {
2315     using MathUint for uint;
2316     using SafeCast for uint;
2317 
2318     uint128 public defaultQuota;
2319 
2320     // Optimized to fit into 64 bytes (2 slots)
2321     struct Quota
2322     {
2323         uint128 currentQuota; // 0 indicates default
2324         uint128 pendingQuota;
2325         uint128 spentAmount;
2326         uint64  spentTimestamp;
2327         uint64  pendingUntil;
2328     }
2329 
2330     mapping (address => Quota) public quotas;
2331 
2332     event DefaultQuotaChanged(
2333         uint prevValue,
2334         uint currentValue
2335     );
2336 
2337     event QuotaScheduled(
2338         address wallet,
2339         uint    pendingQuota,
2340         uint64  pendingUntil
2341     );
2342 
2343     constructor(uint128 _defaultQuota)
2344         DataStore()
2345     {
2346         defaultQuota = _defaultQuota;
2347     }
2348 
2349     function changeDefaultQuota(uint128 _defaultQuota)
2350         external
2351         onlyOwner
2352     {
2353         require(
2354             _defaultQuota != defaultQuota &&
2355             _defaultQuota >= 1 ether &&
2356             _defaultQuota <= 100 ether,
2357             "INVALID_DEFAULT_QUOTA"
2358         );
2359         emit DefaultQuotaChanged(defaultQuota, _defaultQuota);
2360         defaultQuota = _defaultQuota;
2361     }
2362 
2363     function changeQuota(
2364         address wallet,
2365         uint    newQuota,
2366         uint    effectiveTime
2367         )
2368         public
2369         onlyWalletModule(wallet)
2370     {
2371         quotas[wallet].currentQuota = currentQuota(wallet).toUint128();
2372         quotas[wallet].pendingQuota = newQuota.toUint128();
2373         quotas[wallet].pendingUntil = effectiveTime.toUint64();
2374 
2375         emit QuotaScheduled(
2376             wallet,
2377             newQuota,
2378             quotas[wallet].pendingUntil
2379         );
2380     }
2381 
2382     function checkAndAddToSpent(
2383         address wallet,
2384         uint    amount
2385         )
2386         public
2387         onlyWalletModule(wallet)
2388     {
2389         require(hasEnoughQuota(wallet, amount), "QUOTA_EXCEEDED");
2390         addToSpent(wallet, amount);
2391     }
2392 
2393     function addToSpent(
2394         address wallet,
2395         uint    amount
2396         )
2397         public
2398         onlyWalletModule(wallet)
2399     {
2400         Quota storage q = quotas[wallet];
2401         q.spentAmount = spentQuota(wallet).add(amount).toUint128();
2402         q.spentTimestamp = uint64(block.timestamp);
2403     }
2404 
2405     function currentQuota(address wallet)
2406         public
2407         view
2408         returns (uint)
2409     {
2410         Quota storage q = quotas[wallet];
2411         uint value = q.pendingUntil <= block.timestamp ?
2412             q.pendingQuota : q.currentQuota;
2413 
2414         return value == 0 ? defaultQuota : value;
2415     }
2416 
2417     function pendingQuota(address wallet)
2418         public
2419         view
2420         returns (
2421             uint _pendingQuota,
2422             uint _pendingUntil
2423         )
2424     {
2425         Quota storage q = quotas[wallet];
2426         if (q.pendingUntil > 0 && q.pendingUntil > block.timestamp) {
2427             _pendingQuota = q.pendingQuota > 0 ? q.pendingQuota : defaultQuota;
2428             _pendingUntil = q.pendingUntil;
2429         }
2430     }
2431 
2432     function spentQuota(address wallet)
2433         public
2434         view
2435         returns (uint)
2436     {
2437         Quota storage q = quotas[wallet];
2438         uint timeSinceLastSpent = block.timestamp.sub(q.spentTimestamp);
2439         if (timeSinceLastSpent < 1 days) {
2440             return uint(q.spentAmount).sub(timeSinceLastSpent.mul(q.spentAmount) / 1 days);
2441         } else {
2442             return 0;
2443         }
2444     }
2445 
2446     function availableQuota(address wallet)
2447         public
2448         view
2449         returns (uint)
2450     {
2451         uint quota = currentQuota(wallet);
2452         uint spent = spentQuota(wallet);
2453         return quota > spent ? quota - spent : 0;
2454     }
2455 
2456     function hasEnoughQuota(
2457         address wallet,
2458         uint    requiredAmount
2459         )
2460         public
2461         view
2462         returns (bool)
2463     {
2464         return availableQuota(wallet) >= requiredAmount;
2465     }
2466 }
2467 
2468 
2469 // Copyright 2017 Loopring Technology Limited.
2470 
2471 pragma experimental ABIEncoderV2;
2472 
2473 
2474 
2475 
2476 
2477 
2478 
2479 /// @title SecurityStore
2480 ///
2481 /// @author Daniel Wang - <daniel@loopring.org>
2482 ///
2483 /// The design of this contract is inspired by Argent's contract codebase:
2484 /// https://github.com/argentlabs/argent-contracts
2485 contract SecurityStore is DataStore
2486 {
2487     using MathUint for uint;
2488     using SafeCast for uint;
2489 
2490     struct Wallet
2491     {
2492         address    inheritor;
2493         uint64     lastActive; // the latest timestamp the owner is considered to be active
2494         address    lockedBy;   // the module that locked the wallet.
2495         uint64     lock;
2496 
2497         Data.Guardian[]            guardians;
2498         mapping (address => uint)  guardianIdx;
2499     }
2500 
2501     mapping (address => Wallet) public wallets;
2502 
2503     constructor() DataStore() {}
2504 
2505     function isGuardian(
2506         address wallet,
2507         address addr
2508         )
2509         public
2510         view
2511         returns (bool)
2512     {
2513         Data.Guardian memory guardian = getGuardian(wallet, addr);
2514         return guardian.addr != address(0) && isGuardianActive(guardian);
2515     }
2516 
2517     function isGuardianOrPendingAddition(
2518         address wallet,
2519         address addr
2520         )
2521         public
2522         view
2523         returns (bool)
2524     {
2525         Data.Guardian memory guardian = getGuardian(wallet, addr);
2526         return guardian.addr != address(0) &&
2527             (isGuardianActive(guardian) || isGuardianPendingAddition(guardian));
2528     }
2529 
2530     function getGuardian(
2531         address wallet,
2532         address guardianAddr
2533         )
2534         public
2535         view
2536         returns (Data.Guardian memory)
2537     {
2538         uint index = wallets[wallet].guardianIdx[guardianAddr];
2539         if (index > 0) {
2540             return wallets[wallet].guardians[index-1];
2541         }
2542     }
2543 
2544     // @dev Returns active guardians.
2545     function guardians(address wallet)
2546         public
2547         view
2548         returns (Data.Guardian[] memory _guardians)
2549     {
2550         Wallet storage w = wallets[wallet];
2551         _guardians = new Data.Guardian[](w.guardians.length);
2552         uint index = 0;
2553         for (uint i = 0; i < w.guardians.length; i++) {
2554             Data.Guardian memory g = w.guardians[i];
2555             if (isGuardianActive(g)) {
2556                 _guardians[index] = g;
2557                 index ++;
2558             }
2559         }
2560         assembly { mstore(_guardians, index) }
2561     }
2562 
2563     // @dev Returns the number of active guardians.
2564     function numGuardians(address wallet)
2565         public
2566         view
2567         returns (uint count)
2568     {
2569         Wallet storage w = wallets[wallet];
2570         for (uint i = 0; i < w.guardians.length; i++) {
2571             if (isGuardianActive(w.guardians[i])) {
2572                 count ++;
2573             }
2574         }
2575     }
2576 
2577     // @dev Returns guardians who are either active or pending addition.
2578     function guardiansWithPending(address wallet)
2579         public
2580         view
2581         returns (Data.Guardian[] memory _guardians)
2582     {
2583         Wallet storage w = wallets[wallet];
2584         _guardians = new Data.Guardian[](w.guardians.length);
2585         uint index = 0;
2586         for (uint i = 0; i < w.guardians.length; i++) {
2587             Data.Guardian memory g = w.guardians[i];
2588             if (isGuardianActive(g) || isGuardianPendingAddition(g)) {
2589                 _guardians[index] = g;
2590                 index ++;
2591             }
2592         }
2593         assembly { mstore(_guardians, index) }
2594     }
2595 
2596     // @dev Returns the number of guardians who are active or pending addition.
2597     function numGuardiansWithPending(address wallet)
2598         public
2599         view
2600         returns (uint count)
2601     {
2602         Wallet storage w = wallets[wallet];
2603         for (uint i = 0; i < w.guardians.length; i++) {
2604             Data.Guardian memory g = w.guardians[i];
2605             if (isGuardianActive(g) || isGuardianPendingAddition(g)) {
2606                 count ++;
2607             }
2608         }
2609     }
2610 
2611     function addGuardian(
2612         address wallet,
2613         address guardianAddr,
2614         uint    group,
2615         uint    validSince
2616         )
2617         public
2618         onlyWalletModule(wallet)
2619     {
2620         cleanRemovedGuardians(wallet);
2621 
2622         require(guardianAddr != address(0), "ZERO_ADDRESS");
2623         Wallet storage w = wallets[wallet];
2624 
2625         uint pos = w.guardianIdx[guardianAddr];
2626         require(pos == 0, "GUARDIAN_EXISTS");
2627 
2628         // Add the new guardian
2629         Data.Guardian memory g = Data.Guardian(
2630             guardianAddr,
2631             group.toUint16(),
2632             validSince.toUint40(),
2633             uint40(0)
2634         );
2635         w.guardians.push(g);
2636         w.guardianIdx[guardianAddr] = w.guardians.length;
2637     }
2638 
2639     function cancelGuardianAddition(
2640         address wallet,
2641         address guardianAddr
2642         )
2643         public
2644         onlyWalletModule(wallet)
2645     {
2646         cleanRemovedGuardians(wallet);
2647 
2648         Wallet storage w = wallets[wallet];
2649         uint idx = w.guardianIdx[guardianAddr];
2650         require(idx > 0, "GUARDIAN_NOT_EXISTS");
2651         require(
2652             isGuardianPendingAddition(w.guardians[idx - 1]),
2653             "NOT_PENDING_ADDITION"
2654         );
2655 
2656         Data.Guardian memory lastGuardian = w.guardians[w.guardians.length - 1];
2657         if (guardianAddr != lastGuardian.addr) {
2658             w.guardians[idx - 1] = lastGuardian;
2659             w.guardianIdx[lastGuardian.addr] = idx;
2660         }
2661         w.guardians.pop();
2662         delete w.guardianIdx[guardianAddr];
2663     }
2664 
2665     function removeGuardian(
2666         address wallet,
2667         address guardianAddr,
2668         uint    validUntil
2669         )
2670         public
2671         onlyWalletModule(wallet)
2672     {
2673         cleanRemovedGuardians(wallet);
2674 
2675         Wallet storage w = wallets[wallet];
2676         uint idx = w.guardianIdx[guardianAddr];
2677         require(idx > 0, "GUARDIAN_NOT_EXISTS");
2678 
2679         w.guardians[idx - 1].validUntil = validUntil.toUint40();
2680     }
2681 
2682     function removeAllGuardians(address wallet)
2683         public
2684         onlyWalletModule(wallet)
2685     {
2686         Wallet storage w = wallets[wallet];
2687         for (uint i = 0; i < w.guardians.length; i++) {
2688             delete w.guardianIdx[w.guardians[i].addr];
2689         }
2690         delete w.guardians;
2691     }
2692 
2693     function cancelGuardianRemoval(
2694         address wallet,
2695         address guardianAddr
2696         )
2697         public
2698         onlyWalletModule(wallet)
2699     {
2700         cleanRemovedGuardians(wallet);
2701 
2702         Wallet storage w = wallets[wallet];
2703         uint idx = w.guardianIdx[guardianAddr];
2704         require(idx > 0, "GUARDIAN_NOT_EXISTS");
2705 
2706         require(
2707             isGuardianPendingRemoval(w.guardians[idx - 1]),
2708             "NOT_PENDING_REMOVAL"
2709         );
2710 
2711         w.guardians[idx - 1].validUntil = 0;
2712     }
2713 
2714     function getLock(address wallet)
2715         public
2716         view
2717         returns (uint _lock, address _lockedBy)
2718     {
2719         _lock = wallets[wallet].lock;
2720         _lockedBy = wallets[wallet].lockedBy;
2721     }
2722 
2723     function setLock(
2724         address wallet,
2725         uint    lock
2726         )
2727         public
2728         onlyWalletModule(wallet)
2729     {
2730         require(lock == 0 || lock > block.timestamp, "INVALID_LOCK_TIME");
2731 
2732         wallets[wallet].lock = lock.toUint64();
2733         wallets[wallet].lockedBy = msg.sender;
2734     }
2735 
2736     function lastActive(address wallet)
2737         public
2738         view
2739         returns (uint)
2740     {
2741         return wallets[wallet].lastActive;
2742     }
2743 
2744     function touchLastActive(address wallet)
2745         public
2746         onlyWalletModule(wallet)
2747     {
2748         wallets[wallet].lastActive = uint64(block.timestamp);
2749     }
2750 
2751     function inheritor(address wallet)
2752         public
2753         view
2754         returns (
2755             address _who,
2756             uint    _lastActive
2757         )
2758     {
2759         _who = wallets[wallet].inheritor;
2760         _lastActive = wallets[wallet].lastActive;
2761     }
2762 
2763     function setInheritor(address wallet, address who)
2764         public
2765         onlyWalletModule(wallet)
2766     {
2767         wallets[wallet].inheritor = who;
2768         wallets[wallet].lastActive = uint64(block.timestamp);
2769     }
2770 
2771     function cleanRemovedGuardians(address wallet)
2772         private
2773     {
2774         Wallet storage w = wallets[wallet];
2775 
2776         for (int i = int(w.guardians.length) - 1; i >= 0; i--) {
2777             Data.Guardian memory g = w.guardians[uint(i)];
2778             if (isGuardianExpired(g)) {
2779                 Data.Guardian memory lastGuardian = w.guardians[w.guardians.length - 1];
2780 
2781                 if (g.addr != lastGuardian.addr) {
2782                     w.guardians[uint(i)] = lastGuardian;
2783                     w.guardianIdx[lastGuardian.addr] = uint(i) + 1;
2784                 }
2785                 w.guardians.pop();
2786                 delete w.guardianIdx[g.addr];
2787             }
2788         }
2789     }
2790 
2791     function isGuardianActive(Data.Guardian memory guardian)
2792         private
2793         view
2794         returns (bool)
2795     {
2796         return guardian.validSince > 0 && guardian.validSince <= block.timestamp &&
2797             !isGuardianExpired(guardian);
2798     }
2799 
2800     function isGuardianPendingAddition(Data.Guardian memory guardian)
2801         private
2802         view
2803         returns (bool)
2804     {
2805         return guardian.validSince > block.timestamp;
2806     }
2807 
2808     function isGuardianPendingRemoval(Data.Guardian memory guardian)
2809         private
2810         view
2811         returns (bool)
2812     {
2813         return guardian.validUntil > block.timestamp;
2814     }
2815 
2816     function isGuardianExpired(Data.Guardian memory guardian)
2817         private
2818         view
2819         returns (bool)
2820     {
2821         return guardian.validUntil > 0 &&
2822             guardian.validUntil <= block.timestamp;
2823     }
2824 }
2825 
2826 // Copyright 2017 Loopring Technology Limited.
2827 
2828 
2829 
2830 
2831 
2832 
2833 /// @title WhitelistStore
2834 /// @dev This store maintains a wallet's whitelisted addresses.
2835 contract WhitelistStore is DataStore, AddressSet
2836 {
2837     // wallet => whitelisted_addr => effective_since
2838     mapping(address => mapping(address => uint)) public effectiveTimeMap;
2839 
2840     event Whitelisted(
2841         address wallet,
2842         address addr,
2843         bool    whitelisted,
2844         uint    effectiveTime
2845     );
2846 
2847     constructor() DataStore() {}
2848 
2849     function addToWhitelist(
2850         address wallet,
2851         address addr,
2852         uint    effectiveTime
2853         )
2854         public
2855         onlyWalletModule(wallet)
2856     {
2857         addAddressToSet(walletKey(wallet), addr, true);
2858         uint effective = effectiveTime >= block.timestamp ? effectiveTime : block.timestamp;
2859         effectiveTimeMap[wallet][addr] = effective;
2860         emit Whitelisted(wallet, addr, true, effective);
2861     }
2862 
2863     function removeFromWhitelist(
2864         address wallet,
2865         address addr
2866         )
2867         public
2868         onlyWalletModule(wallet)
2869     {
2870         removeAddressFromSet(walletKey(wallet), addr);
2871         delete effectiveTimeMap[wallet][addr];
2872         emit Whitelisted(wallet, addr, false, 0);
2873     }
2874 
2875     function whitelist(address wallet)
2876         public
2877         view
2878         returns (
2879             address[] memory addresses,
2880             uint[]    memory effectiveTimes
2881         )
2882     {
2883         addresses = addressesInSet(walletKey(wallet));
2884         effectiveTimes = new uint[](addresses.length);
2885         for (uint i = 0; i < addresses.length; i++) {
2886             effectiveTimes[i] = effectiveTimeMap[wallet][addresses[i]];
2887         }
2888     }
2889 
2890     function isWhitelisted(
2891         address wallet,
2892         address addr
2893         )
2894         public
2895         view
2896         returns (
2897             bool isWhitelistedAndEffective,
2898             uint effectiveTime
2899         )
2900     {
2901         effectiveTime = effectiveTimeMap[wallet][addr];
2902         isWhitelistedAndEffective = effectiveTime > 0 && effectiveTime <= block.timestamp;
2903     }
2904 
2905     function whitelistSize(address wallet)
2906         public
2907         view
2908         returns (uint)
2909     {
2910         return numAddressesInSet(walletKey(wallet));
2911     }
2912 
2913     function walletKey(address addr)
2914         public
2915         pure
2916         returns (bytes32)
2917     {
2918         return keccak256(abi.encodePacked("__WHITELIST__", addr));
2919     }
2920 }
2921 
2922 
2923 
2924 
2925 /// @title ControllerImpl
2926 /// @dev Basic implementation of a Controller.
2927 ///
2928 /// @author Daniel Wang - <daniel@loopring.org>
2929 contract ControllerImpl is Claimable, Controller
2930 {
2931     address             public collectTo;
2932     uint                public defaultLockPeriod;
2933     BaseENSManager      public ensManager;
2934     PriceOracle         public priceOracle;
2935     DappAddressStore    public dappAddressStore;
2936     HashStore           public hashStore;
2937     NonceStore          public nonceStore;
2938     QuotaStore          public quotaStore;
2939     SecurityStore       public securityStore;
2940     WhitelistStore      public whitelistStore;
2941 
2942     // Make sure this value if false in production env.
2943     // Ideally we can use chainid(), but there is a bug in truffle so testing is buggy:
2944     // https://github.com/trufflesuite/ganache/issues/1643
2945     bool                public allowChangingWalletFactory;
2946 
2947     event AddressChanged(
2948         string   name,
2949         address  addr
2950     );
2951 
2952     constructor(
2953         ModuleRegistry    _moduleRegistry,
2954         WalletRegistry    _walletRegistry,
2955         uint              _defaultLockPeriod,
2956         address           _collectTo,
2957         BaseENSManager    _ensManager,
2958         PriceOracle       _priceOracle,
2959         bool              _allowChangingWalletFactory
2960         )
2961     {
2962         moduleRegistry = _moduleRegistry;
2963         walletRegistry = _walletRegistry;
2964 
2965         defaultLockPeriod = _defaultLockPeriod;
2966 
2967         require(_collectTo != address(0), "ZERO_ADDRESS");
2968         collectTo = _collectTo;
2969 
2970         ensManager = _ensManager;
2971         priceOracle = _priceOracle;
2972         allowChangingWalletFactory = _allowChangingWalletFactory;
2973     }
2974 
2975     function initStores(
2976         DappAddressStore  _dappAddressStore,
2977         HashStore         _hashStore,
2978         NonceStore        _nonceStore,
2979         QuotaStore        _quotaStore,
2980         SecurityStore     _securityStore,
2981         WhitelistStore    _whitelistStore
2982         )
2983         external
2984         onlyOwner
2985     {
2986         require(
2987             address(_dappAddressStore) != address(0),
2988             "ZERO_ADDRESS"
2989         );
2990 
2991         // Make sure this function can only invoked once.
2992         require(
2993             address(dappAddressStore) == address(0),
2994             "INITIALIZED_ALREADY"
2995         );
2996 
2997         dappAddressStore = _dappAddressStore;
2998         hashStore = _hashStore;
2999         nonceStore = _nonceStore;
3000         quotaStore = _quotaStore;
3001         securityStore = _securityStore;
3002         whitelistStore = _whitelistStore;
3003     }
3004 
3005     function initWalletFactory(address _walletFactory)
3006         external
3007         onlyOwner
3008     {
3009         require(
3010             allowChangingWalletFactory || walletFactory == address(0),
3011             "INITIALIZED_ALREADY"
3012         );
3013         require(_walletFactory != address(0), "ZERO_ADDRESS");
3014         walletFactory = _walletFactory;
3015         emit AddressChanged("WalletFactory", walletFactory);
3016     }
3017 
3018     function setCollectTo(address _collectTo)
3019         external
3020         onlyOwner
3021     {
3022         require(_collectTo != address(0), "ZERO_ADDRESS");
3023         collectTo = _collectTo;
3024         emit AddressChanged("CollectTo", collectTo);
3025     }
3026 
3027     function setPriceOracle(PriceOracle _priceOracle)
3028         external
3029         onlyOwner
3030     {
3031         priceOracle = _priceOracle;
3032         emit AddressChanged("PriceOracle", address(priceOracle));
3033     }
3034 
3035 }
3036 
3037 // Copyright 2017 Loopring Technology Limited.
3038 
3039 
3040 
3041 library EIP712
3042 {
3043     struct Domain {
3044         string  name;
3045         string  version;
3046         address verifyingContract;
3047     }
3048 
3049     bytes32 constant internal EIP712_DOMAIN_TYPEHASH = keccak256(
3050         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
3051     );
3052 
3053     string constant internal EIP191_HEADER = "\x19\x01";
3054 
3055     function hash(Domain memory domain)
3056         internal
3057         pure
3058         returns (bytes32)
3059     {
3060         uint _chainid;
3061         assembly { _chainid := chainid() }
3062 
3063         return keccak256(
3064             abi.encode(
3065                 EIP712_DOMAIN_TYPEHASH,
3066                 keccak256(bytes(domain.name)),
3067                 keccak256(bytes(domain.version)),
3068                 _chainid,
3069                 domain.verifyingContract
3070             )
3071         );
3072     }
3073 
3074     function hashPacked(
3075         bytes32 domainSeperator,
3076         bytes   memory encodedData
3077         )
3078         internal
3079         pure
3080         returns (bytes32)
3081     {
3082         return keccak256(
3083             abi.encodePacked(EIP191_HEADER, domainSeperator, keccak256(encodedData))
3084         );
3085     }
3086 }
3087 
3088 // Copyright 2017 Loopring Technology Limited.
3089 
3090 
3091 
3092 
3093 
3094 
3095 /// @title Module
3096 /// @dev Base contract for all smart wallet modules.
3097 ///
3098 /// @author Daniel Wang - <daniel@loopring.org>
3099 ///
3100 /// The design of this contract is inspired by Argent's contract codebase:
3101 /// https://github.com/argentlabs/argent-contracts
3102 interface Module
3103 {
3104     /// @dev Activates the module for the given wallet (msg.sender) after the module is added.
3105     ///      Warning: this method shall ONLY be callable by a wallet.
3106     function activate() external;
3107 
3108     /// @dev Deactivates the module for the given wallet (msg.sender) before the module is removed.
3109     ///      Warning: this method shall ONLY be callable by a wallet.
3110     function deactivate() external;
3111 }
3112 
3113 // Copyright 2017 Loopring Technology Limited.
3114 
3115 
3116 abstract contract ERC1271 {
3117     // bytes4(keccak256("isValidSignature(bytes32,bytes)")
3118     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
3119 
3120     function isValidSignature(
3121         bytes32      _hash,
3122         bytes memory _signature)
3123         public
3124         view
3125         virtual
3126         returns (bytes4 magicValueB32);
3127 }
3128 
3129 // Copyright 2017 Loopring Technology Limited.
3130 
3131 
3132 
3133 
3134 
3135 
3136 
3137 
3138 
3139 /// @title SignatureUtil
3140 /// @author Daniel Wang - <daniel@loopring.org>
3141 /// @dev This method supports multihash standard. Each signature's last byte indicates
3142 ///      the signature's type.
3143 library SignatureUtil
3144 {
3145     using BytesUtil     for bytes;
3146     using MathUint      for uint;
3147     using AddressUtil   for address;
3148 
3149     enum SignatureType {
3150         ILLEGAL,
3151         INVALID,
3152         EIP_712,
3153         ETH_SIGN,
3154         WALLET   // deprecated
3155     }
3156 
3157     bytes4 constant internal ERC1271_MAGICVALUE = 0x1626ba7e;
3158 
3159     function verifySignatures(
3160         bytes32          signHash,
3161         address[] memory signers,
3162         bytes[]   memory signatures
3163         )
3164         internal
3165         view
3166         returns (bool)
3167     {
3168         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
3169         address lastSigner;
3170         for (uint i = 0; i < signers.length; i++) {
3171             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
3172             lastSigner = signers[i];
3173             if (!verifySignature(signHash, signers[i], signatures[i])) {
3174                 return false;
3175             }
3176         }
3177         return true;
3178     }
3179 
3180     function verifySignature(
3181         bytes32        signHash,
3182         address        signer,
3183         bytes   memory signature
3184         )
3185         internal
3186         view
3187         returns (bool)
3188     {
3189         if (signer == address(0)) {
3190             return false;
3191         }
3192 
3193         return signer.isContract()?
3194             verifyERC1271Signature(signHash, signer, signature):
3195             verifyEOASignature(signHash, signer, signature);
3196     }
3197 
3198     function recoverECDSASigner(
3199         bytes32      signHash,
3200         bytes memory signature
3201         )
3202         internal
3203         pure
3204         returns (address)
3205     {
3206         if (signature.length != 65) {
3207             return address(0);
3208         }
3209 
3210         bytes32 r;
3211         bytes32 s;
3212         uint8   v;
3213         // we jump 32 (0x20) as the first slot of bytes contains the length
3214         // we jump 65 (0x41) per signature
3215         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
3216         assembly {
3217             r := mload(add(signature, 0x20))
3218             s := mload(add(signature, 0x40))
3219             v := and(mload(add(signature, 0x41)), 0xff)
3220         }
3221         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
3222         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
3223             return address(0);
3224         }
3225         if (v == 27 || v == 28) {
3226             return ecrecover(signHash, v, r, s);
3227         } else {
3228             return address(0);
3229         }
3230     }
3231 
3232     function verifyEOASignature(
3233         bytes32        signHash,
3234         address        signer,
3235         bytes   memory signature
3236         )
3237         private
3238         pure
3239         returns (bool success)
3240     {
3241         if (signer == address(0)) {
3242             return false;
3243         }
3244 
3245         uint signatureTypeOffset = signature.length.sub(1);
3246         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
3247 
3248         // Strip off the last byte of the signature by updating the length
3249         assembly {
3250             mstore(signature, signatureTypeOffset)
3251         }
3252 
3253         if (signatureType == SignatureType.EIP_712) {
3254             success = (signer == recoverECDSASigner(signHash, signature));
3255         } else if (signatureType == SignatureType.ETH_SIGN) {
3256             bytes32 hash = keccak256(
3257                 abi.encodePacked("\x19Ethereum Signed Message:\n32", signHash)
3258             );
3259             success = (signer == recoverECDSASigner(hash, signature));
3260         } else {
3261             success = false;
3262         }
3263 
3264         // Restore the signature length
3265         assembly {
3266             mstore(signature, add(signatureTypeOffset, 1))
3267         }
3268 
3269         return success;
3270     }
3271 
3272     function verifyERC1271Signature(
3273         bytes32 signHash,
3274         address signer,
3275         bytes   memory signature
3276         )
3277         private
3278         view
3279         returns (bool)
3280     {
3281         bytes memory callData = abi.encodeWithSelector(
3282             ERC1271.isValidSignature.selector,
3283             signHash,
3284             signature
3285         );
3286         (bool success, bytes memory result) = signer.staticcall(callData);
3287         return (
3288             success &&
3289             result.length == 32 &&
3290             result.toBytes4(0) == ERC1271_MAGICVALUE
3291         );
3292     }
3293 }
3294 
3295 // Copyright 2017 Loopring Technology Limited.
3296 
3297 
3298 
3299 
3300 // Copyright 2017 Loopring Technology Limited.
3301 
3302 
3303 
3304 
3305 
3306 
3307 
3308 
3309 
3310 // Copyright 2017 Loopring Technology Limited.
3311 
3312 
3313 
3314 
3315 
3316 
3317 
3318 
3319 
3320 
3321 
3322 
3323 /// @title BaseModule
3324 /// @dev This contract implements some common functions that are likely
3325 ///      be useful for all modules.
3326 ///
3327 /// @author Daniel Wang - <daniel@loopring.org>
3328 ///
3329 /// The design of this contract is inspired by Argent's contract codebase:
3330 /// https://github.com/argentlabs/argent-contracts
3331 abstract contract BaseModule is ReentrancyGuard, Module
3332 {
3333     using MathUint      for uint;
3334     using AddressUtil   for address;
3335 
3336     event Activated   (address wallet);
3337     event Deactivated (address wallet);
3338 
3339     function logicalSender()
3340         internal
3341         view
3342         virtual
3343         returns (address payable)
3344     {
3345         return msg.sender;
3346     }
3347 
3348     modifier onlyWalletOwner(address wallet, address addr)
3349         virtual
3350     {
3351         require(Wallet(wallet).owner() == addr, "NOT_WALLET_OWNER");
3352         _;
3353     }
3354 
3355     modifier notWalletOwner(address wallet, address addr)
3356         virtual
3357     {
3358         require(Wallet(wallet).owner() != addr, "IS_WALLET_OWNER");
3359         _;
3360     }
3361 
3362     modifier eligibleWalletOwner(address addr)
3363     {
3364         require(addr != address(0) && !addr.isContract(), "INVALID_OWNER");
3365         _;
3366     }
3367 
3368     function controller()
3369         internal
3370         view
3371         virtual
3372         returns(ControllerImpl);
3373 
3374     /// @dev This method will cause an re-entry to the same module contract.
3375     function activate()
3376         external
3377         override
3378         virtual
3379     {
3380         address wallet = logicalSender();
3381         bindMethods(wallet);
3382         emit Activated(wallet);
3383     }
3384 
3385     /// @dev This method will cause an re-entry to the same module contract.
3386     function deactivate()
3387         external
3388         override
3389         virtual
3390     {
3391         address wallet = logicalSender();
3392         unbindMethods(wallet);
3393         emit Deactivated(wallet);
3394     }
3395 
3396     ///.@dev Gets the list of methods for binding to wallets.
3397     ///      Sub-contracts should override this method to provide methods for
3398     ///      wallet binding.
3399     /// @return methods A list of method selectors for binding to the wallet
3400     ///         when this module is activated for the wallet.
3401     function bindableMethods()
3402         public
3403         pure
3404         virtual
3405         returns (bytes4[] memory methods);
3406 
3407     // ===== internal & private methods =====
3408 
3409     /// @dev Binds all methods to the given wallet.
3410     function bindMethods(address wallet)
3411         internal
3412     {
3413         Wallet w = Wallet(wallet);
3414         bytes4[] memory methods = bindableMethods();
3415         for (uint i = 0; i < methods.length; i++) {
3416             w.bindMethod(methods[i], address(this));
3417         }
3418     }
3419 
3420     /// @dev Unbinds all methods from the given wallet.
3421     function unbindMethods(address wallet)
3422         internal
3423     {
3424         Wallet w = Wallet(wallet);
3425         bytes4[] memory methods = bindableMethods();
3426         for (uint i = 0; i < methods.length; i++) {
3427             w.bindMethod(methods[i], address(0));
3428         }
3429     }
3430 
3431     function transactCall(
3432         address wallet,
3433         address to,
3434         uint    value,
3435         bytes   memory data
3436         )
3437         internal
3438         returns (bytes memory)
3439     {
3440         return Wallet(wallet).transact(uint8(1), to, value, data);
3441     }
3442 
3443     // Special case for transactCall to support transfers on "bad" ERC20 tokens
3444     function transactTokenTransfer(
3445         address wallet,
3446         address token,
3447         address to,
3448         uint    amount
3449         )
3450         internal
3451     {
3452         if (token == address(0)) {
3453             transactCall(wallet, to, amount, "");
3454             return;
3455         }
3456 
3457         bytes memory txData = abi.encodeWithSelector(
3458             ERC20.transfer.selector,
3459             to,
3460             amount
3461         );
3462         bytes memory returnData = transactCall(wallet, token, 0, txData);
3463         // `transactCall` will revert if the call was unsuccessful.
3464         // The only extra check we have to do is verify if the return value (if there is any) is correct.
3465         bool success = returnData.length == 0 ? true :  abi.decode(returnData, (bool));
3466         require(success, "ERC20_TRANSFER_FAILED");
3467     }
3468 
3469     // Special case for transactCall to support approvals on "bad" ERC20 tokens
3470     function transactTokenApprove(
3471         address wallet,
3472         address token,
3473         address spender,
3474         uint    amount
3475         )
3476         internal
3477     {
3478         require(token != address(0), "INVALID_TOKEN");
3479         bytes memory txData = abi.encodeWithSelector(
3480             ERC20.approve.selector,
3481             spender,
3482             amount
3483         );
3484         bytes memory returnData = transactCall(wallet, token, 0, txData);
3485         // `transactCall` will revert if the call was unsuccessful.
3486         // The only extra check we have to do is verify if the return value (if there is any) is correct.
3487         bool success = returnData.length == 0 ? true :  abi.decode(returnData, (bool));
3488         require(success, "ERC20_APPROVE_FAILED");
3489     }
3490 
3491     function transactDelegateCall(
3492         address wallet,
3493         address to,
3494         uint    value,
3495         bytes   calldata data
3496         )
3497         internal
3498         returns (bytes memory)
3499     {
3500         return Wallet(wallet).transact(uint8(2), to, value, data);
3501     }
3502 
3503     function transactStaticCall(
3504         address wallet,
3505         address to,
3506         bytes   calldata data
3507         )
3508         internal
3509         returns (bytes memory)
3510     {
3511         return Wallet(wallet).transact(uint8(3), to, 0, data);
3512     }
3513 
3514     function reimburseGasFee(
3515         address     wallet,
3516         address     recipient,
3517         address     gasToken,
3518         uint        gasPrice,
3519         uint        gasAmount,
3520         bool        skipQuota
3521         )
3522         internal
3523     {
3524         uint gasCost = gasAmount.mul(gasPrice);
3525 
3526         if (!skipQuota) {
3527             uint value = controller().priceOracle().tokenValue(gasToken, gasCost);
3528             if (value > 0) {
3529               controller().quotaStore().checkAndAddToSpent(wallet, value);
3530             }
3531         }
3532 
3533         transactTokenTransfer(wallet, gasToken, recipient, gasCost);
3534     }
3535 }
3536 
3537 
3538 
3539 /// @title ERC1271Module
3540 /// @dev This module enables our smart wallets to message signers.
3541 /// @author Brecht Devos - <brecht@loopring.org>
3542 /// @author Daniel Wang - <daniel@loopring.org>
3543 abstract contract ERC1271Module is ERC1271, BaseModule
3544 {
3545     using SignatureUtil for bytes;
3546     using SignatureUtil for bytes32;
3547     using AddressUtil   for address;
3548 
3549     function bindableMethodsForERC1271()
3550         internal
3551         pure
3552         returns (bytes4[] memory methods)
3553     {
3554         methods = new bytes4[](1);
3555         methods[0] = ERC1271.isValidSignature.selector;
3556     }
3557 
3558     // Will use msg.sender to detect the wallet, so this function should be called through
3559     // the bounded method on the wallet itself, not directly on this module.
3560     //
3561     // Note that we allow chained wallet ownership:
3562     // Wallet1 owned by Wallet2, Wallet2 owned by Wallet3, ..., WaleltN owned by an EOA.
3563     // The verificaiton of Wallet1's signature will succeed if the final EOA's signature is
3564     // valid.
3565     function isValidSignature(
3566         bytes32      _signHash,
3567         bytes memory _signature
3568         )
3569         public
3570         view
3571         override
3572         returns (bytes4 magicValue)
3573     {
3574         address wallet = msg.sender;
3575         (uint _lock,) = controller().securityStore().getLock(wallet);
3576         if (_lock > block.timestamp) { // wallet locked
3577             return 0;
3578         }
3579 
3580         if (_signHash.verifySignature(Wallet(wallet).owner(), _signature)) {
3581             return ERC1271_MAGICVALUE;
3582         } else {
3583             return 0;
3584         }
3585     }
3586 }
3587 
3588 
3589 // Copyright 2017 Loopring Technology Limited.
3590 
3591 
3592 
3593 
3594 
3595 
3596 
3597 
3598 
3599 
3600 
3601 // Copyright 2017 Loopring Technology Limited.
3602 
3603 
3604 
3605 
3606 // Copyright 2017 Loopring Technology Limited.
3607 
3608 
3609 
3610 
3611 
3612 
3613 
3614 
3615 
3616 /// @title BaseWallet
3617 /// @dev This contract provides basic implementation for a Wallet.
3618 ///
3619 /// @author Daniel Wang - <daniel@loopring.org>
3620 ///
3621 /// The design of this contract is inspired by Argent's contract codebase:
3622 /// https://github.com/argentlabs/argent-contracts
3623 abstract contract BaseWallet is ReentrancyGuard, Wallet
3624 {
3625     // WARNING: do not delete wallet state data to make this implementation
3626     // compatible with early versions.
3627     //
3628     //  ----- DATA LAYOUT BEGINS -----
3629     address internal _owner;
3630 
3631     mapping (address => bool) private modules;
3632 
3633     Controller public controller;
3634 
3635     mapping (bytes4  => address) internal methodToModule;
3636     //  ----- DATA LAYOUT ENDS -----
3637 
3638     event OwnerChanged          (address newOwner);
3639     event ControllerChanged     (address newController);
3640     event ModuleAdded           (address module);
3641     event ModuleRemoved         (address module);
3642     event MethodBound           (bytes4  method, address module);
3643     event WalletSetup           (address owner);
3644 
3645     event Transacted(
3646         address module,
3647         address to,
3648         uint    value,
3649         bytes   data
3650     );
3651 
3652     modifier onlyFromModule
3653     {
3654         require(modules[msg.sender], "MODULE_UNAUTHORIZED");
3655         _;
3656     }
3657 
3658     modifier onlyFromFactory
3659     {
3660         require(
3661             msg.sender == controller.walletFactory(),
3662             "UNAUTHORIZED"
3663         );
3664         _;
3665     }
3666 
3667     /// @dev We need to make sure the Factory address cannot be changed without wallet owner's
3668     ///      explicit authorization.
3669     modifier onlyFromFactoryOrModule
3670     {
3671         require(
3672             modules[msg.sender] || msg.sender == controller.walletFactory(),
3673             "UNAUTHORIZED"
3674         );
3675         _;
3676     }
3677 
3678     /// @dev Set up this wallet by assigning an original owner
3679     ///
3680     ///      Note that calling this method more than once will throw.
3681     ///
3682     /// @param _initialOwner The owner of this wallet, must not be address(0).
3683     function initOwner(
3684         address _initialOwner
3685         )
3686         external
3687         onlyFromFactory
3688         nonReentrant
3689     {
3690         require(controller != Controller(0), "NO_CONTROLLER");
3691         require(_owner == address(0), "INITIALIZED_ALREADY");
3692         require(_initialOwner != address(0), "ZERO_ADDRESS");
3693 
3694         _owner = _initialOwner;
3695         emit WalletSetup(_initialOwner);
3696     }
3697 
3698     /// @dev Set up this wallet by assigning an controller.
3699     ///
3700     ///      Note that calling this method more than once will throw.
3701     ///      And this method must be invoked before owner is initialized
3702     ///
3703     /// @param _controller The Controller instance.
3704     function initController(
3705         Controller _controller
3706         )
3707         external
3708         nonReentrant
3709     {
3710         require(
3711             _owner == address(0) &&
3712             controller == Controller(0) &&
3713             _controller != Controller(0),
3714             "CONTROLLER_INIT_FAILED"
3715         );
3716 
3717         controller = _controller;
3718     }
3719 
3720     function owner()
3721         override
3722         external
3723         view
3724         returns (address)
3725     {
3726         return _owner;
3727     }
3728 
3729     function setOwner(address newOwner)
3730         external
3731         override
3732         nonReentrant
3733         onlyFromModule
3734     {
3735         require(newOwner != address(0), "ZERO_ADDRESS");
3736         require(newOwner != address(this), "PROHIBITED");
3737         require(newOwner != _owner, "SAME_ADDRESS");
3738         _owner = newOwner;
3739         emit OwnerChanged(newOwner);
3740     }
3741 
3742     function setController(Controller newController)
3743         external
3744         nonReentrant
3745         onlyFromModule
3746     {
3747         require(newController != controller, "SAME_CONTROLLER");
3748         require(newController != Controller(0), "INVALID_CONTROLLER");
3749         controller = newController;
3750         emit ControllerChanged(address(newController));
3751     }
3752 
3753     function addModule(address _module)
3754         external
3755         override
3756         onlyFromFactoryOrModule
3757     {
3758         addModuleInternal(_module);
3759     }
3760 
3761     function removeModule(address _module)
3762         external
3763         override
3764         onlyFromModule
3765     {
3766         // Allow deactivate to fail to make sure the module can be removed
3767         require(modules[_module], "MODULE_NOT_EXISTS");
3768         try Module(_module).deactivate() {} catch {}
3769         delete modules[_module];
3770         emit ModuleRemoved(_module);
3771     }
3772 
3773     function hasModule(address _module)
3774         external
3775         view
3776         override
3777         returns (bool)
3778     {
3779         return modules[_module];
3780     }
3781 
3782     function bindMethod(bytes4 _method, address _module)
3783         external
3784         override
3785         onlyFromModule
3786     {
3787         require(_method != bytes4(0), "BAD_METHOD");
3788         if (_module != address(0)) {
3789             require(modules[_module], "MODULE_UNAUTHORIZED");
3790         }
3791 
3792         methodToModule[_method] = _module;
3793         emit MethodBound(_method, _module);
3794     }
3795 
3796     function boundMethodModule(bytes4 _method)
3797         external
3798         view
3799         override
3800         returns (address)
3801     {
3802         return methodToModule[_method];
3803     }
3804 
3805     function transact(
3806         uint8    mode,
3807         address  to,
3808         uint     value,
3809         bytes    calldata data
3810         )
3811         external
3812         override
3813         onlyFromFactoryOrModule
3814         returns (bytes memory returnData)
3815     {
3816         require(
3817             !controller.moduleRegistry().isModuleRegistered(to),
3818             "TRANSACT_ON_MODULE_DISALLOWED"
3819         );
3820 
3821         bool success;
3822         (success, returnData) = nonReentrantCall(mode, to, value, data);
3823 
3824         if (!success) {
3825             assembly {
3826                 returndatacopy(0, 0, returndatasize())
3827                 revert(0, returndatasize())
3828             }
3829         }
3830         emit Transacted(msg.sender, to, value, data);
3831     }
3832 
3833     function addModuleInternal(address _module)
3834         internal
3835     {
3836         require(_module != address(0), "NULL_MODULE");
3837         require(modules[_module] == false, "MODULE_EXISTS");
3838         require(
3839             controller.moduleRegistry().isModuleEnabled(_module),
3840             "INVALID_MODULE"
3841         );
3842         modules[_module] = true;
3843         emit ModuleAdded(_module);
3844         Module(_module).activate();
3845     }
3846 
3847     receive()
3848         external
3849         payable
3850     {
3851     }
3852 
3853     /// @dev This default function can receive Ether or perform queries to modules
3854     ///      using bound methods.
3855     fallback()
3856         external
3857         payable
3858     {
3859         address module = methodToModule[msg.sig];
3860         require(modules[module], "MODULE_UNAUTHORIZED");
3861 
3862         (bool success, bytes memory returnData) = module.call{value: msg.value}(msg.data);
3863         assembly {
3864             switch success
3865             case 0 { revert(add(returnData, 32), mload(returnData)) }
3866             default { return(add(returnData, 32), mload(returnData)) }
3867         }
3868     }
3869 
3870     // This call is introduced to support reentrany check.
3871     // The caller shall NOT have the nonReentrant modifier.
3872     function nonReentrantCall(
3873         uint8          mode,
3874         address        target,
3875         uint           value,
3876         bytes calldata data
3877         )
3878         private
3879         nonReentrant
3880         returns (
3881             bool success,
3882             bytes memory returnData
3883         )
3884     {
3885         if (mode == 1) {
3886             // solium-disable-next-line security/no-call-value
3887             (success, returnData) = target.call{value: value}(data);
3888         } else if (mode == 2) {
3889             // solium-disable-next-line security/no-call-value
3890             (success, returnData) = target.delegatecall(data);
3891         } else if (mode == 3) {
3892             require(value == 0, "INVALID_VALUE");
3893             // solium-disable-next-line security/no-call-value
3894             (success, returnData) = target.staticcall(data);
3895         } else {
3896             revert("UNSUPPORTED_MODE");
3897         }
3898     }
3899 }
3900 
3901 
3902 
3903 
3904 
3905 // Copyright 2017 Loopring Technology Limited.
3906 
3907 
3908 
3909 // This code is taken from https://github.com/OpenZeppelin/openzeppelin-labs
3910 
3911 
3912 /**
3913  * @title Proxy
3914  * @dev Gives the possibility to delegate any call to a foreign implementation.
3915  */
3916 abstract contract Proxy {
3917   /**
3918   * @dev Tells the address of the implementation where every call will be delegated.
3919   * @return address of the implementation to which it will be delegated
3920   */
3921   function implementation() public view virtual returns (address);
3922 
3923   /**
3924   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
3925   * This function will return whatever the implementation call returns
3926   */
3927   fallback() payable external {
3928     address _impl = implementation();
3929     require(_impl != address(0));
3930 
3931     assembly {
3932       let ptr := mload(0x40)
3933       calldatacopy(ptr, 0, calldatasize())
3934       let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
3935       let size := returndatasize()
3936       returndatacopy(ptr, 0, size)
3937 
3938       switch result
3939       case 0 { revert(ptr, size) }
3940       default { return(ptr, size) }
3941     }
3942   }
3943 
3944   receive() payable external {}
3945 }
3946 
3947 
3948 
3949 /// @title SimpleProxy
3950 /// @author Daniel Wang  - <daniel@loopring.org>
3951 contract SimpleProxy is Proxy
3952 {
3953     bytes32 private constant implementationPosition = keccak256(
3954         "org.loopring.protocol.simple.proxy"
3955     );
3956 
3957     function setImplementation(address _implementation)
3958         public
3959     {
3960         address _impl = implementation();
3961         require(_impl == address(0), "INITIALIZED_ALREADY");
3962 
3963         bytes32 position = implementationPosition;
3964         assembly {sstore(position, _implementation) }
3965     }
3966 
3967     function implementation()
3968         public
3969         override
3970         view
3971         returns (address)
3972     {
3973         address impl;
3974         bytes32 position = implementationPosition;
3975         assembly { impl := sload(position) }
3976         return impl;
3977     }
3978 }
3979 
3980 
3981 
3982 
3983 
3984 // Taken from: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/970f687f04d20e01138a3e8ccf9278b1d4b3997b/contracts/utils/Create2.sol
3985 
3986 
3987 
3988 /**
3989  * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
3990  * `CREATE2` can be used to compute in advance the address where a smart
3991  * contract will be deployed, which allows for interesting new mechanisms known
3992  * as 'counterfactual interactions'.
3993  *
3994  * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
3995  * information.
3996  */
3997 library Create2 {
3998     /**
3999      * @dev Deploys a contract using `CREATE2`. The address where the contract
4000      * will be deployed can be known in advance via {computeAddress}. Note that
4001      * a contract cannot be deployed twice using the same salt.
4002      */
4003     function deploy(bytes32 salt, bytes memory bytecode) internal returns (address payable) {
4004         address payable addr;
4005         // solhint-disable-next-line no-inline-assembly
4006         assembly {
4007             addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
4008         }
4009         require(addr != address(0), "CREATE2_FAILED");
4010         return addr;
4011     }
4012 
4013     /**
4014      * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the `bytecode`
4015      * or `salt` will result in a new destination address.
4016      */
4017     function computeAddress(bytes32 salt, bytes memory bytecode) internal view returns (address) {
4018         return computeAddress(salt, bytecode, address(this));
4019     }
4020 
4021     /**
4022      * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
4023      * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
4024      */
4025     function computeAddress(bytes32 salt, bytes memory bytecodeHash, address deployer) internal pure returns (address) {
4026         bytes32 bytecodeHashHash = keccak256(bytecodeHash);
4027         bytes32 _data = keccak256(
4028             abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHashHash)
4029         );
4030         return address(bytes20(_data << 96));
4031     }
4032 }
4033 
4034 
4035 
4036 
4037 // Copyright 2017 Loopring Technology Limited.
4038 
4039 
4040 
4041 
4042 
4043 
4044 
4045 /// @title MetaTxAware
4046 /// @author Daniel Wang - <daniel@loopring.org>
4047 ///
4048 /// The design of this contract is inspired by GSN's contract codebase:
4049 /// https://github.com/opengsn/gsn/contracts
4050 ///
4051 /// @dev Inherit this abstract contract to make a module meta-transaction
4052 ///      aware. `msgSender()` shall be used to replace `msg.sender` for
4053 ///      verifying permissions.
4054 abstract contract MetaTxAware
4055 {
4056     using AddressUtil for address;
4057     using BytesUtil   for bytes;
4058 
4059     address public trustedForwarder;
4060 
4061     constructor(address _trustedForwarder)
4062     {
4063         trustedForwarder = _trustedForwarder;
4064     }
4065 
4066     modifier txAwareHashNotAllowed()
4067     {
4068         require(txAwareHash() == 0, "INVALID_TX_AWARE_HASH");
4069         _;
4070     }
4071 
4072     /// @dev Return's the function's logicial message sender. This method should be
4073     // used to replace `msg.sender` for all meta-tx enabled functions.
4074     function msgSender()
4075         internal
4076         view
4077         returns (address payable)
4078     {
4079         if (msg.data.length >= 56 && msg.sender == trustedForwarder) {
4080             return msg.data.toAddress(msg.data.length - 52).toPayable();
4081         } else {
4082             return msg.sender;
4083         }
4084     }
4085 
4086     function txAwareHash()
4087         internal
4088         view
4089         returns (bytes32)
4090     {
4091         if (msg.data.length >= 56 && msg.sender == trustedForwarder) {
4092             return msg.data.toBytes32(msg.data.length - 32);
4093         } else {
4094             return 0;
4095         }
4096     }
4097 }
4098 
4099 
4100 
4101 
4102 /// @title WalletFactory
4103 /// @dev A factory contract to create a new wallet by deploying a proxy
4104 ///      in front of a real wallet.
4105 ///
4106 /// @author Daniel Wang - <daniel@loopring.org>
4107 ///
4108 /// The design of this contract is inspired by Argent's contract codebase:
4109 /// https://github.com/argentlabs/argent-contracts
4110 contract WalletFactory is ReentrancyGuard, MetaTxAware
4111 {
4112     using AddressUtil for address;
4113     using SignatureUtil for bytes32;
4114 
4115     event BlankDeployed (address blank,  bytes32 version);
4116     event BlankConsumed (address blank);
4117     event WalletCreated (address wallet, string ensLabel, address owner, bool blankUsed);
4118 
4119     string constant public WALLET_CREATION = "WALLET_CREATION";
4120 
4121     bytes32 public constant CREATE_WALLET_TYPEHASH = keccak256(
4122         "createWallet(address owner,uint256 salt,address blankAddress,string ensLabel,bool ensRegisterReverse,address[] modules)"
4123     );
4124 
4125     mapping(address => bytes32) blanks;
4126 
4127     address        public walletImplementation;
4128     bool           public allowEmptyENS; // MUST be false in production
4129     ControllerImpl public controller;
4130     bytes32        public DOMAIN_SEPERATOR;
4131 
4132     constructor(
4133         ControllerImpl _controller,
4134         address        _walletImplementation,
4135         bool           _allowEmptyENS
4136         )
4137         MetaTxAware(address(0))
4138     {
4139         DOMAIN_SEPERATOR = EIP712.hash(
4140             EIP712.Domain("WalletFactory", "1.1.0", address(this))
4141         );
4142         controller = _controller;
4143         walletImplementation = _walletImplementation;
4144         allowEmptyENS = _allowEmptyENS;
4145     }
4146 
4147     function initTrustedForwarder(address _trustedForwarder)
4148         external
4149     {
4150         require(trustedForwarder == address(0), "INITIALIZED_ALREADY");
4151         require(_trustedForwarder != address(0), "INVALID_ADDRESS");
4152         trustedForwarder = _trustedForwarder;
4153     }
4154 
4155     /// @dev Create a set of new wallet blanks to be used in the future.
4156     /// @param modules The wallet's modules.
4157     /// @param salts The salts that can be used to generate nice addresses.
4158     function createBlanks(
4159         address[] calldata modules,
4160         uint[]    calldata salts
4161         )
4162         external
4163         nonReentrant
4164         txAwareHashNotAllowed()
4165     {
4166         for (uint i = 0; i < salts.length; i++) {
4167             createBlank_(modules, salts[i]);
4168         }
4169     }
4170 
4171     /// @dev Create a new wallet by deploying a proxy.
4172     /// @param _owner The wallet's owner.
4173     /// @param _salt A salt to adjust address.
4174     /// @param _ensLabel The ENS subdomain to register, use "" to skip.
4175     /// @param _ensApproval The signature for ENS subdomain approval.
4176     /// @param _ensRegisterReverse True to register reverse ENS.
4177     /// @param _modules The wallet's modules.
4178     /// @param _signature The wallet owner's signature.
4179     /// @return _wallet The new wallet address
4180     function createWallet(
4181         address            _owner,
4182         uint               _salt,
4183         string    calldata _ensLabel,
4184         bytes     calldata _ensApproval,
4185         bool               _ensRegisterReverse,
4186         address[] calldata _modules,
4187         bytes     calldata _signature
4188         )
4189         external
4190         payable
4191         nonReentrant
4192         // txAwareHashNotAllowed()
4193         returns (address _wallet)
4194     {
4195         validateRequest_(
4196             _owner,
4197             _salt,
4198             address(0),
4199             _ensLabel,
4200             _ensRegisterReverse,
4201             _modules,
4202             _signature
4203         );
4204 
4205         _wallet = createWallet_(_owner, _salt, _modules);
4206 
4207         initializeWallet_(
4208             _wallet,
4209             _owner,
4210             _ensLabel,
4211             _ensApproval,
4212             _ensRegisterReverse,
4213             false
4214         );
4215     }
4216 
4217     /// @dev Create a new wallet by using a pre-deployed blank.
4218     /// @param _owner The wallet's owner.
4219     /// @param _blank The address of the blank to use.
4220     /// @param _ensLabel The ENS subdomain to register, use "" to skip.
4221     /// @param _ensApproval The signature for ENS subdomain approval.
4222     /// @param _ensRegisterReverse True to register reverse ENS.
4223     /// @param _modules The wallet's modules.
4224     /// @param _signature The wallet owner's signature.
4225     /// @return _wallet The new wallet address
4226     function createWallet2(
4227         address            _owner,
4228         address            _blank,
4229         string    calldata _ensLabel,
4230         bytes     calldata _ensApproval,
4231         bool               _ensRegisterReverse,
4232         address[] calldata _modules,
4233         bytes     calldata _signature
4234         )
4235         external
4236         payable
4237         nonReentrant
4238         // txAwareHashNotAllowed()
4239         returns (address _wallet)
4240     {
4241         validateRequest_(
4242             _owner,
4243             0,
4244             _blank,
4245             _ensLabel,
4246             _ensRegisterReverse,
4247             _modules,
4248             _signature
4249         );
4250 
4251         _wallet = consumeBlank_(_blank, _modules);
4252 
4253         initializeWallet_(
4254             _wallet,
4255             _owner,
4256             _ensLabel,
4257             _ensApproval,
4258             _ensRegisterReverse,
4259             true
4260         );
4261     }
4262 
4263     function registerENS(
4264         address         _wallet,
4265         address         _owner,
4266         string calldata _ensLabel,
4267         bytes  calldata _ensApproval,
4268         bool            _ensRegisterReverse
4269         )
4270         external
4271         nonReentrant
4272         txAwareHashNotAllowed()
4273     {
4274         registerENS_(_wallet, _owner, _ensLabel, _ensApproval, _ensRegisterReverse);
4275     }
4276 
4277     function computeWalletAddress(address owner, uint salt)
4278         public
4279         view
4280         returns (address)
4281     {
4282         return computeAddress_(owner, salt);
4283     }
4284 
4285     function computeBlankAddress(uint salt)
4286         public
4287         view
4288         returns (address)
4289     {
4290         return computeAddress_(address(0), salt);
4291     }
4292 
4293     // ---- internal functions ---
4294 
4295     function consumeBlank_(
4296         address blank,
4297         address[] calldata modules
4298         )
4299         internal
4300         returns (address)
4301     {
4302         bytes32 version = keccak256(abi.encode(modules));
4303         require(blanks[blank] == version, "INVALID_ADOBE");
4304         delete blanks[blank];
4305         emit BlankConsumed(blank);
4306         return blank;
4307     }
4308 
4309     function createBlank_(
4310         address[] calldata modules,
4311         uint      salt
4312         )
4313         internal
4314         returns (address blank)
4315     {
4316         blank = deploy_(modules, address(0), salt);
4317         bytes32 version = keccak256(abi.encode(modules));
4318         blanks[blank] = version;
4319 
4320         emit BlankDeployed(blank, version);
4321     }
4322 
4323     function createWallet_(
4324         address   owner,
4325         uint      salt,
4326         address[] calldata modules
4327         )
4328         internal
4329         returns (address wallet)
4330     {
4331         return deploy_(modules, owner, salt);
4332     }
4333 
4334     function deploy_(
4335         address[] calldata modules,
4336         address            owner,
4337         uint               salt
4338         )
4339         internal
4340         returns (address payable wallet)
4341     {
4342         wallet = Create2.deploy(
4343             keccak256(abi.encodePacked(WALLET_CREATION, owner, salt)),
4344             type(SimpleProxy).creationCode
4345         );
4346 
4347         SimpleProxy proxy = SimpleProxy(wallet);
4348         proxy.setImplementation(walletImplementation);
4349 
4350         BaseWallet w = BaseWallet(wallet);
4351         w.initController(controller);
4352         for (uint i = 0; i < modules.length; i++) {
4353             w.addModule(modules[i]);
4354         }
4355     }
4356 
4357     function validateRequest_(
4358         address            _owner,
4359         uint               _salt,
4360         address            _blankAddress,
4361         string    memory   _ensLabel,
4362         bool               _ensRegisterReverse,
4363         address[] memory   _modules,
4364         bytes     memory   _signature
4365         )
4366         private
4367         view
4368     {
4369         require(_owner != address(0) && !_owner.isContract(), "INVALID_OWNER");
4370         require(_modules.length > 0, "EMPTY_MODULES");
4371 
4372         bytes memory encodedRequest = abi.encode(
4373             CREATE_WALLET_TYPEHASH,
4374             _owner,
4375             _salt,
4376             _blankAddress,
4377             keccak256(bytes(_ensLabel)),
4378             _ensRegisterReverse,
4379             keccak256(abi.encode(_modules))
4380         );
4381 
4382         bytes32 signHash = EIP712.hashPacked(DOMAIN_SEPERATOR, encodedRequest);
4383 
4384         bytes32 txAwareHash_ = txAwareHash();
4385         require(txAwareHash_ == 0 || txAwareHash_ == signHash, "INVALID_TX_AWARE_HASH");
4386 
4387         require(signHash.verifySignature(_owner, _signature), "INVALID_SIGNATURE");
4388     }
4389 
4390     function initializeWallet_(
4391         address       _wallet,
4392         address       _owner,
4393         string memory _ensLabel,
4394         bytes  memory _ensApproval,
4395         bool          _ensRegisterReverse,
4396         bool          _blankUsed
4397         )
4398         private
4399     {
4400         BaseWallet(_wallet.toPayable()).initOwner(_owner);
4401         controller.walletRegistry().registerWallet(_wallet);
4402 
4403         if (bytes(_ensLabel).length > 0) {
4404             registerENS_(_wallet, _owner, _ensLabel, _ensApproval, _ensRegisterReverse);
4405         } else {
4406             require(allowEmptyENS, "EMPTY_ENS_NOT_ALLOWED");
4407         }
4408 
4409         emit WalletCreated(_wallet, _ensLabel, _owner, _blankUsed);
4410     }
4411 
4412     function computeAddress_(
4413         address owner,
4414         uint    salt
4415         )
4416         internal
4417         view
4418         returns (address)
4419     {
4420         return Create2.computeAddress(
4421             keccak256(abi.encodePacked(WALLET_CREATION, owner, salt)),
4422             type(SimpleProxy).creationCode
4423         );
4424     }
4425 
4426     function registerENS_(
4427         address       wallet,
4428         address       owner,
4429         string memory ensLabel,
4430         bytes  memory ensApproval,
4431         bool          ensRegisterReverse
4432         )
4433         internal
4434     {
4435         require(
4436             bytes(ensLabel).length > 0 &&
4437             bytes(ensApproval).length > 0,
4438             "INVALID_LABEL_OR_SIGNATURE"
4439         );
4440 
4441         BaseENSManager ensManager = controller.ensManager();
4442         ensManager.register(wallet, owner, ensLabel, ensApproval);
4443 
4444         if (ensRegisterReverse) {
4445             bytes memory data = abi.encodeWithSelector(
4446                 ENSReverseRegistrar.claimWithResolver.selector,
4447                 address(0), // the owner of the reverse record
4448                 ensManager.ensResolver()
4449             );
4450 
4451             Wallet(wallet).transact(
4452                 uint8(1),
4453                 address(ensManager.getENSReverseRegistrar()),
4454                 0, // value
4455                 data
4456             );
4457         }
4458     }
4459 }
4460 
4461 
4462 /// @title ForwarderModule
4463 /// @dev A module to support wallet meta-transactions.
4464 ///
4465 /// @author Daniel Wang - <daniel@loopring.org>
4466 abstract contract ForwarderModule is BaseModule
4467 {
4468     using AddressUtil   for address;
4469     using BytesUtil     for bytes;
4470     using MathUint      for uint;
4471     using SignatureUtil for bytes32;
4472 
4473     uint    public constant MAX_REIMBURSTMENT_OVERHEAD = 165000;
4474     bytes32 public FORWARDER_DOMAIN_SEPARATOR;
4475 
4476     event MetaTxExecuted(
4477         address relayer,
4478         address from,
4479         uint    nonce,
4480         bytes32 txAwareHash,
4481         bool    success,
4482         address gasToken,
4483         uint    gasPrice,
4484         uint    gasLimit,
4485         uint    gasUsed
4486     );
4487 
4488     struct MetaTx {
4489         address from; // the wallet
4490         address to;
4491         uint    nonce;
4492         bytes32 txAwareHash;
4493         address gasToken;
4494         uint    gasPrice;
4495         uint    gasLimit;
4496         bytes   data;
4497     }
4498 
4499     bytes32 constant public META_TX_TYPEHASH = keccak256(
4500         "MetaTx(address from,address to,uint256 nonce,bytes32 txAwareHash,address gasToken,uint256 gasPrice,uint256 gasLimit,bytes data)"
4501     );
4502 
4503     function validateMetaTx(
4504         address from, // the wallet
4505         address to,
4506         uint    nonce,
4507         bytes32 txAwareHash,
4508         address gasToken,
4509         uint    gasPrice,
4510         uint    gasLimit,
4511         bytes   memory data,
4512         bytes   memory signature
4513         )
4514         public
4515         view
4516     {
4517         // Since this contract is a module, we need to prevent wallet from interacting with
4518         // Stores via this module. Therefore, we must carefully check the 'to' address as follows,
4519         // so no Store can be used as 'to'.
4520         require(
4521             (to != address(this)) &&
4522             controller().moduleRegistry().isModuleRegistered(to) ||
4523 
4524             // We only allow the wallet to call itself to addModule
4525             (to == from) &&
4526             data.toBytes4(0) == Wallet.addModule.selector &&
4527             controller().walletRegistry().isWalletRegistered(from) ||
4528 
4529             to == controller().walletFactory(),
4530             "INVALID_DESTINATION_OR_METHOD"
4531         );
4532         require(
4533             nonce == 0 && txAwareHash != 0 ||
4534             nonce != 0 && txAwareHash == 0,
4535             "INVALID_NONCE"
4536         );
4537 
4538         bytes memory data_ = txAwareHash == 0 ? data : data.slice(0, 4); // function selector
4539 
4540         bytes memory encoded = abi.encode(
4541             META_TX_TYPEHASH,
4542             from,
4543             to,
4544             nonce,
4545             txAwareHash,
4546             gasToken,
4547             gasPrice,
4548             gasLimit,
4549             keccak256(data_)
4550         );
4551 
4552         bytes32 metaTxHash = EIP712.hashPacked(FORWARDER_DOMAIN_SEPARATOR, encoded);
4553         require(metaTxHash.verifySignature(from, signature), "INVALID_SIGNATURE");
4554     }
4555 
4556     function executeMetaTx(
4557         MetaTx calldata metaTx,
4558         bytes  calldata signature
4559         )
4560         external
4561         nonReentrant
4562         returns (
4563             bool         success,
4564             bytes memory ret
4565         )
4566     {
4567         uint gasLeft = gasleft();
4568         checkSufficientGas(metaTx);
4569 
4570         // The trick is to append the really logical message sender and the
4571         // transaction-aware hash to the end of the call data.
4572         (success, ret) = metaTx.to.call{gas : metaTx.gasLimit, value : 0}(
4573             abi.encodePacked(metaTx.data, metaTx.from, metaTx.txAwareHash)
4574         );
4575 
4576         // It's ok to do the validation after the 'call'. This is also necessary
4577         // in the case of creating the wallet, otherwise, wallet signature validation
4578         // will fail before the wallet is created.
4579         validateMetaTx(
4580             metaTx.from,
4581             metaTx.to,
4582             metaTx.nonce,
4583             metaTx.txAwareHash,
4584             metaTx.gasToken,
4585             metaTx.gasPrice,
4586             metaTx.gasLimit,
4587             metaTx.data,
4588             signature
4589         );
4590 
4591         // Nonce update must come after the real transaction in case of new wallet creation.
4592         if (metaTx.nonce != 0) {
4593             controller().nonceStore().verifyAndUpdate(metaTx.from, metaTx.nonce);
4594         }
4595 
4596         uint gasUsed = gasLeft - gasleft() +
4597             (signature.length + metaTx.data.length + 7 * 32) * 16 + // data input cost
4598             447 +  // cost of MetaTxExecuted = 375 + 9 * 8
4599             23000; // transaction cost;
4600 
4601         // Fees are not to be charged by a relayer if the transaction fails with a
4602         // non-zero txAwareHash. The reason is that relayer can pick arbitrary 'data'
4603         // to make the transaction fail. Charging fees for such failures can drain
4604         // wallet funds.
4605         bool needReimburse = metaTx.gasPrice > 0 && (metaTx.txAwareHash == 0 || success);
4606 
4607         if (needReimburse) {
4608             gasUsed = gasUsed +
4609                 MAX_REIMBURSTMENT_OVERHEAD + // near-worst case cost
4610                 2300; // 2*SLOAD+1*CALL = 2*800+1*700=2300
4611 
4612             // Do not consume quota when call factory's createWallet function or
4613             // when a successful meta-tx's txAwareHash is non-zero (which means it will
4614             // be signed by at least a guardian). Therefor, even if the owner's
4615             // private key is leaked, the hacker won't be able to deplete ether/tokens
4616             // as high meta-tx fees.
4617             bool skipQuota = success && (
4618                 metaTx.txAwareHash != 0 || (
4619                     metaTx.data.toBytes4(0) == WalletFactory.createWallet.selector ||
4620                     metaTx.data.toBytes4(0) == WalletFactory.createWallet2.selector) &&
4621                 metaTx.to == controller().walletFactory()
4622             );
4623 
4624             // MAX_REIMBURSTMENT_OVERHEAD covers an ERC20 transfer and a quota update.
4625             if (skipQuota) {
4626                 gasUsed -= 48000;
4627             }
4628 
4629             if (metaTx.gasToken == address(0)) {
4630                 gasUsed -= 15000; // diff between an regular ERC20 transfer and an ETH send
4631             }
4632 
4633             uint gasToReimburse = gasUsed <= metaTx.gasLimit ? gasUsed : metaTx.gasLimit;
4634 
4635             reimburseGasFee(
4636                 metaTx.from,
4637                 controller().collectTo(),
4638                 metaTx.gasToken,
4639                 metaTx.gasPrice,
4640                 gasToReimburse,
4641                 skipQuota
4642             );
4643         }
4644 
4645         emit MetaTxExecuted(
4646             msg.sender,
4647             metaTx.from,
4648             metaTx.nonce,
4649             metaTx.txAwareHash,
4650             success,
4651             metaTx.gasToken,
4652             metaTx.gasPrice,
4653             metaTx.gasLimit,
4654             gasUsed
4655         );
4656     }
4657 
4658     function checkSufficientGas(
4659         MetaTx calldata metaTx
4660         )
4661         private
4662         view
4663     {
4664         // Check the relayer has enough Ether gas
4665         uint gasLimit = metaTx.gasLimit.mul(64) / 63;
4666 
4667         require(gasleft() >= gasLimit, "OPERATOR_INSUFFICIENT_GAS");
4668 
4669         // Check the wallet has enough meta tx gas
4670         if (metaTx.gasPrice > 0) {
4671             uint gasCost = metaTx.gasLimit.mul(metaTx.gasPrice);
4672 
4673             if (metaTx.gasToken == address(0)) {
4674                 require(
4675                     metaTx.from.balance >= gasCost,
4676                     "WALLET_INSUFFICIENT_ETH_GAS"
4677                 );
4678             } else {
4679                 require(
4680                     ERC20(metaTx.gasToken).balanceOf(metaTx.from) >= gasCost,
4681                     "WALLET_INSUFFICIENT_TOKEN_GAS"
4682                 );
4683             }
4684         }
4685     }
4686 }
4687 
4688 
4689 
4690 /// @title FinalCoreModule
4691 /// @dev This module combines multiple small modules to
4692 ///      minimize the number of modules to reduce gas used
4693 ///      by wallet creation.
4694 contract FinalCoreModule is
4695     ERC1271Module,
4696     ForwarderModule
4697 {
4698     ControllerImpl private controller_;
4699 
4700     constructor(ControllerImpl _controller)
4701     {
4702         FORWARDER_DOMAIN_SEPARATOR = EIP712.hash(
4703             EIP712.Domain("ForwarderModule", "1.1.0", address(this))
4704         );
4705 
4706         controller_ = _controller;
4707     }
4708 
4709     function controller()
4710         internal
4711         view
4712         override
4713         returns(ControllerImpl)
4714     {
4715         return ControllerImpl(controller_);
4716     }
4717 
4718     function bindableMethods()
4719         public
4720         pure
4721         override
4722         returns (bytes4[] memory)
4723     {
4724         return bindableMethodsForERC1271();
4725     }
4726 }