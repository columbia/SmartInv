1 /**
2  *  The Consumer Contract Wallet
3  *  Copyright (C) 2019 The Contract Wallet Company Limited
4  *
5  *  This program is free software: you can redistribute it and/or modify
6  *  it under the terms of the GNU General Public License as published by
7  *  the Free Software Foundation, either version 3 of the License, or
8  *  (at your option) any later version.
9 
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14 
15  *  You should have received a copy of the GNU General Public License
16  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
17  */
18 
19 pragma solidity ^0.5.10;
20 
21 contract Ownable {
22     event TransferredOwnership(address _from, address _to);
23     event LockedOwnership(address _locked);
24 
25     address payable private _owner;
26     bool private _isTransferable;
27 
28     /// @notice Constructor sets the original owner of the contract and whether or not it is one time transferable.
29     constructor(address payable _account_, bool _transferable_) internal {
30         _owner = _account_;
31         _isTransferable = _transferable_;
32         // Emit the LockedOwnership event if no longer transferable.
33         if (!_isTransferable) {
34             emit LockedOwnership(_account_);
35         }
36         emit TransferredOwnership(address(0), _account_);
37     }
38 
39     /// @notice Reverts if called by any account other than the owner.
40     modifier onlyOwner() {
41         require(_isOwner(msg.sender), "sender is not an owner");
42         _;
43     }
44 
45     /// @notice Allows the current owner to transfer control of the contract to a new address.
46     /// @param _account address to transfer ownership to.
47     /// @param _transferable indicates whether to keep the ownership transferable.
48     function transferOwnership(address payable _account, bool _transferable) external onlyOwner {
49         // Require that the ownership is transferable.
50         require(_isTransferable, "ownership is not transferable");
51         // Require that the new owner is not the zero address.
52         require(_account != address(0), "owner cannot be set to zero address");
53         // Set the transferable flag to the value _transferable passed in.
54         _isTransferable = _transferable;
55         // Emit the LockedOwnership event if no longer transferable.
56         if (!_transferable) {
57             emit LockedOwnership(_account);
58         }
59         // Emit the ownership transfer event.
60         emit TransferredOwnership(_owner, _account);
61         // Set the owner to the provided address.
62         _owner = _account;
63     }
64 
65     /// @notice check if the ownership is transferable.
66     /// @return true if the ownership is transferable.
67     function isTransferable() external view returns (bool) {
68         return _isTransferable;
69     }
70 
71     /// @notice Allows the current owner to relinquish control of the contract.
72     /// @dev Renouncing to ownership will leave the contract without an owner and unusable.
73     /// @dev It will not be possible to call the functions with the `onlyOwner` modifier anymore.
74     function renounceOwnership() external onlyOwner {
75         // Require that the ownership is transferable.
76         require(_isTransferable, "ownership is not transferable");
77         // note that this could be terminal
78         _owner = address(0);
79 
80         emit TransferredOwnership(_owner, address(0));
81     }
82 
83     /// @notice Find out owner address
84     /// @return address of the owner.
85     function owner() public view returns (address payable) {
86         return _owner;
87     }
88 
89     /// @notice Check if owner address
90     /// @return true if sender is the owner of the contract.
91     function _isOwner(address _address) internal view returns (bool) {
92         return _address == _owner;
93     }
94 }
95 
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         require(b <= a, "SafeMath: subtraction overflow");
124         uint256 c = a - b;
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `*` operator.
134      *
135      * Requirements:
136      * - Multiplication cannot overflow.
137      */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers. Reverts on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator. Note: this function uses a
157      * `revert` opcode (which leaves remaining gas untouched) while Solidity
158      * uses an invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      * - The divisor cannot be zero.
162      */
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Solidity only automatically asserts when dividing by 0
165         require(b > 0, "SafeMath: division by zero");
166         uint256 c = a / b;
167         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
174      * Reverts when dividing by zero.
175      *
176      * Counterpart to Solidity's `%` operator. This function uses a `revert`
177      * opcode (which leaves remaining gas untouched) while Solidity uses an
178      * invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      * - The divisor cannot be zero.
182      */
183     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184         require(b != 0, "SafeMath: modulo by zero");
185         return a % b;
186     }
187 }
188 
189 contract ResolverBase {
190     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
191 
192     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
193         return interfaceID == INTERFACE_META_ID;
194     }
195 
196     function isAuthorised(bytes32 node) internal view returns(bool);
197 
198     modifier authorised(bytes32 node) {
199         require(isAuthorised(node));
200         _;
201     }
202 }
203 
204 library strings {
205     struct slice {
206         uint _len;
207         uint _ptr;
208     }
209 
210     function memcpy(uint dest, uint src, uint len) private pure {
211         // Copy word-length chunks while possible
212         for(; len >= 32; len -= 32) {
213             assembly {
214                 mstore(dest, mload(src))
215             }
216             dest += 32;
217             src += 32;
218         }
219 
220         // Copy remaining bytes
221         uint mask = 256 ** (32 - len) - 1;
222         assembly {
223             let srcpart := and(mload(src), not(mask))
224             let destpart := and(mload(dest), mask)
225             mstore(dest, or(destpart, srcpart))
226         }
227     }
228 
229     /*
230      * @dev Returns a slice containing the entire string.
231      * @param self The string to make a slice from.
232      * @return A newly allocated slice containing the entire string.
233      */
234     function toSlice(string memory self) internal pure returns (slice memory) {
235         uint ptr;
236         assembly {
237             ptr := add(self, 0x20)
238         }
239         return slice(bytes(self).length, ptr);
240     }
241 
242     /*
243      * @dev Returns the length of a null-terminated bytes32 string.
244      * @param self The value to find the length of.
245      * @return The length of the string, from 0 to 32.
246      */
247     function len(bytes32 self) internal pure returns (uint) {
248         uint ret;
249         if (self == 0)
250             return 0;
251         if (uint(self) & 0xffffffffffffffffffffffffffffffff == 0) {
252             ret += 16;
253             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
254         }
255         if (uint(self) & 0xffffffffffffffff == 0) {
256             ret += 8;
257             self = bytes32(uint(self) / 0x10000000000000000);
258         }
259         if (uint(self) & 0xffffffff == 0) {
260             ret += 4;
261             self = bytes32(uint(self) / 0x100000000);
262         }
263         if (uint(self) & 0xffff == 0) {
264             ret += 2;
265             self = bytes32(uint(self) / 0x10000);
266         }
267         if (uint(self) & 0xff == 0) {
268             ret += 1;
269         }
270         return 32 - ret;
271     }
272 
273     /*
274      * @dev Returns a slice containing the entire bytes32, interpreted as a
275      *      null-terminated utf-8 string.
276      * @param self The bytes32 value to convert to a slice.
277      * @return A new slice containing the value of the input argument up to the
278      *         first null.
279      */
280     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
281         // Allocate space for `self` in memory, copy it there, and point ret at it
282         assembly {
283             let ptr := mload(0x40)
284             mstore(0x40, add(ptr, 0x20))
285             mstore(ptr, self)
286             mstore(add(ret, 0x20), ptr)
287         }
288         ret._len = len(self);
289     }
290 
291     /*
292      * @dev Returns a new slice containing the same data as the current slice.
293      * @param self The slice to copy.
294      * @return A new slice containing the same data as `self`.
295      */
296     function copy(slice memory self) internal pure returns (slice memory) {
297         return slice(self._len, self._ptr);
298     }
299 
300     /*
301      * @dev Copies a slice to a new string.
302      * @param self The slice to copy.
303      * @return A newly allocated string containing the slice's text.
304      */
305     function toString(slice memory self) internal pure returns (string memory) {
306         string memory ret = new string(self._len);
307         uint retptr;
308         assembly { retptr := add(ret, 32) }
309 
310         memcpy(retptr, self._ptr, self._len);
311         return ret;
312     }
313 
314     /*
315      * @dev Returns the length in runes of the slice. Note that this operation
316      *      takes time proportional to the length of the slice; avoid using it
317      *      in loops, and call `slice.empty()` if you only need to know whether
318      *      the slice is empty or not.
319      * @param self The slice to operate on.
320      * @return The length of the slice in runes.
321      */
322     function len(slice memory self) internal pure returns (uint l) {
323         // Starting at ptr-31 means the LSB will be the byte we care about
324         uint ptr = self._ptr - 31;
325         uint end = ptr + self._len;
326         for (l = 0; ptr < end; l++) {
327             uint8 b;
328             assembly { b := and(mload(ptr), 0xFF) }
329             if (b < 0x80) {
330                 ptr += 1;
331             } else if (b < 0xE0) {
332                 ptr += 2;
333             } else if (b < 0xF0) {
334                 ptr += 3;
335             } else if (b < 0xF8) {
336                 ptr += 4;
337             } else if (b < 0xFC) {
338                 ptr += 5;
339             } else {
340                 ptr += 6;
341             }
342         }
343     }
344 
345     /*
346      * @dev Returns true if the slice is empty (has a length of 0).
347      * @param self The slice to operate on.
348      * @return True if the slice is empty, False otherwise.
349      */
350     function empty(slice memory self) internal pure returns (bool) {
351         return self._len == 0;
352     }
353 
354     /*
355      * @dev Returns a positive number if `other` comes lexicographically after
356      *      `self`, a negative number if it comes before, or zero if the
357      *      contents of the two slices are equal. Comparison is done per-rune,
358      *      on unicode codepoints.
359      * @param self The first slice to compare.
360      * @param other The second slice to compare.
361      * @return The result of the comparison.
362      */
363     function compare(slice memory self, slice memory other) internal pure returns (int) {
364         uint shortest = self._len;
365         if (other._len < self._len)
366             shortest = other._len;
367 
368         uint selfptr = self._ptr;
369         uint otherptr = other._ptr;
370         for (uint idx = 0; idx < shortest; idx += 32) {
371             uint a;
372             uint b;
373             assembly {
374                 a := mload(selfptr)
375                 b := mload(otherptr)
376             }
377             if (a != b) {
378                 // Mask out irrelevant bytes and check again
379                 uint256 mask = uint256(-1); // 0xffff...
380                 if (shortest < 32) {
381                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
382                 }
383                 uint256 diff = (a & mask) - (b & mask);
384                 if (diff != 0)
385                     return int(diff);
386             }
387             selfptr += 32;
388             otherptr += 32;
389         }
390         return int(self._len) - int(other._len);
391     }
392 
393     /*
394      * @dev Returns true if the two slices contain the same text.
395      * @param self The first slice to compare.
396      * @param self The second slice to compare.
397      * @return True if the slices are equal, false otherwise.
398      */
399     function equals(slice memory self, slice memory other) internal pure returns (bool) {
400         return compare(self, other) == 0;
401     }
402 
403     /*
404      * @dev Extracts the first rune in the slice into `rune`, advancing the
405      *      slice to point to the next rune and returning `self`.
406      * @param self The slice to operate on.
407      * @param rune The slice that will contain the first rune.
408      * @return `rune`.
409      */
410     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
411         rune._ptr = self._ptr;
412 
413         if (self._len == 0) {
414             rune._len = 0;
415             return rune;
416         }
417 
418         uint l;
419         uint b;
420         // Load the first byte of the rune into the LSBs of b
421         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
422         if (b < 0x80) {
423             l = 1;
424         } else if (b < 0xE0) {
425             l = 2;
426         } else if (b < 0xF0) {
427             l = 3;
428         } else {
429             l = 4;
430         }
431 
432         // Check for truncated codepoints
433         if (l > self._len) {
434             rune._len = self._len;
435             self._ptr += self._len;
436             self._len = 0;
437             return rune;
438         }
439 
440         self._ptr += l;
441         self._len -= l;
442         rune._len = l;
443         return rune;
444     }
445 
446     /*
447      * @dev Returns the first rune in the slice, advancing the slice to point
448      *      to the next rune.
449      * @param self The slice to operate on.
450      * @return A slice containing only the first rune from `self`.
451      */
452     function nextRune(slice memory self) internal pure returns (slice memory ret) {
453         nextRune(self, ret);
454     }
455 
456     /*
457      * @dev Returns the number of the first codepoint in the slice.
458      * @param self The slice to operate on.
459      * @return The number of the first codepoint in the slice.
460      */
461     function ord(slice memory self) internal pure returns (uint ret) {
462         if (self._len == 0) {
463             return 0;
464         }
465 
466         uint word;
467         uint length;
468         uint divisor = 2 ** 248;
469 
470         // Load the rune into the MSBs of b
471         assembly { word:= mload(mload(add(self, 32))) }
472         uint b = word / divisor;
473         if (b < 0x80) {
474             ret = b;
475             length = 1;
476         } else if (b < 0xE0) {
477             ret = b & 0x1F;
478             length = 2;
479         } else if (b < 0xF0) {
480             ret = b & 0x0F;
481             length = 3;
482         } else {
483             ret = b & 0x07;
484             length = 4;
485         }
486 
487         // Check for truncated codepoints
488         if (length > self._len) {
489             return 0;
490         }
491 
492         for (uint i = 1; i < length; i++) {
493             divisor = divisor / 256;
494             b = (word / divisor) & 0xFF;
495             if (b & 0xC0 != 0x80) {
496                 // Invalid UTF-8 sequence
497                 return 0;
498             }
499             ret = (ret * 64) | (b & 0x3F);
500         }
501 
502         return ret;
503     }
504 
505     /*
506      * @dev Returns the keccak-256 hash of the slice.
507      * @param self The slice to hash.
508      * @return The hash of the slice.
509      */
510     function keccak(slice memory self) internal pure returns (bytes32 ret) {
511         assembly {
512             ret := keccak256(mload(add(self, 32)), mload(self))
513         }
514     }
515 
516     /*
517      * @dev Returns true if `self` starts with `needle`.
518      * @param self The slice to operate on.
519      * @param needle The slice to search for.
520      * @return True if the slice starts with the provided text, false otherwise.
521      */
522     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
523         if (self._len < needle._len) {
524             return false;
525         }
526 
527         if (self._ptr == needle._ptr) {
528             return true;
529         }
530 
531         bool equal;
532         assembly {
533             let length := mload(needle)
534             let selfptr := mload(add(self, 0x20))
535             let needleptr := mload(add(needle, 0x20))
536             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
537         }
538         return equal;
539     }
540 
541     /*
542      * @dev If `self` starts with `needle`, `needle` is removed from the
543      *      beginning of `self`. Otherwise, `self` is unmodified.
544      * @param self The slice to operate on.
545      * @param needle The slice to search for.
546      * @return `self`
547      */
548     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
549         if (self._len < needle._len) {
550             return self;
551         }
552 
553         bool equal = true;
554         if (self._ptr != needle._ptr) {
555             assembly {
556                 let length := mload(needle)
557                 let selfptr := mload(add(self, 0x20))
558                 let needleptr := mload(add(needle, 0x20))
559                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
560             }
561         }
562 
563         if (equal) {
564             self._len -= needle._len;
565             self._ptr += needle._len;
566         }
567 
568         return self;
569     }
570 
571     /*
572      * @dev Returns true if the slice ends with `needle`.
573      * @param self The slice to operate on.
574      * @param needle The slice to search for.
575      * @return True if the slice starts with the provided text, false otherwise.
576      */
577     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
578         if (self._len < needle._len) {
579             return false;
580         }
581 
582         uint selfptr = self._ptr + self._len - needle._len;
583 
584         if (selfptr == needle._ptr) {
585             return true;
586         }
587 
588         bool equal;
589         assembly {
590             let length := mload(needle)
591             let needleptr := mload(add(needle, 0x20))
592             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
593         }
594 
595         return equal;
596     }
597 
598     /*
599      * @dev If `self` ends with `needle`, `needle` is removed from the
600      *      end of `self`. Otherwise, `self` is unmodified.
601      * @param self The slice to operate on.
602      * @param needle The slice to search for.
603      * @return `self`
604      */
605     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
606         if (self._len < needle._len) {
607             return self;
608         }
609 
610         uint selfptr = self._ptr + self._len - needle._len;
611         bool equal = true;
612         if (selfptr != needle._ptr) {
613             assembly {
614                 let length := mload(needle)
615                 let needleptr := mload(add(needle, 0x20))
616                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
617             }
618         }
619 
620         if (equal) {
621             self._len -= needle._len;
622         }
623 
624         return self;
625     }
626 
627     // Returns the memory address of the first byte of the first occurrence of
628     // `needle` in `self`, or the first byte after `self` if not found.
629     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
630         uint ptr = selfptr;
631         uint idx;
632 
633         if (needlelen <= selflen) {
634             if (needlelen <= 32) {
635                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
636 
637                 bytes32 needledata;
638                 assembly { needledata := and(mload(needleptr), mask) }
639 
640                 uint end = selfptr + selflen - needlelen;
641                 bytes32 ptrdata;
642                 assembly { ptrdata := and(mload(ptr), mask) }
643 
644                 while (ptrdata != needledata) {
645                     if (ptr >= end)
646                         return selfptr + selflen;
647                     ptr++;
648                     assembly { ptrdata := and(mload(ptr), mask) }
649                 }
650                 return ptr;
651             } else {
652                 // For long needles, use hashing
653                 bytes32 hash;
654                 assembly { hash := keccak256(needleptr, needlelen) }
655 
656                 for (idx = 0; idx <= selflen - needlelen; idx++) {
657                     bytes32 testHash;
658                     assembly { testHash := keccak256(ptr, needlelen) }
659                     if (hash == testHash)
660                         return ptr;
661                     ptr += 1;
662                 }
663             }
664         }
665         return selfptr + selflen;
666     }
667 
668     // Returns the memory address of the first byte after the last occurrence of
669     // `needle` in `self`, or the address of `self` if not found.
670     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
671         uint ptr;
672 
673         if (needlelen <= selflen) {
674             if (needlelen <= 32) {
675                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
676 
677                 bytes32 needledata;
678                 assembly { needledata := and(mload(needleptr), mask) }
679 
680                 ptr = selfptr + selflen - needlelen;
681                 bytes32 ptrdata;
682                 assembly { ptrdata := and(mload(ptr), mask) }
683 
684                 while (ptrdata != needledata) {
685                     if (ptr <= selfptr)
686                         return selfptr;
687                     ptr--;
688                     assembly { ptrdata := and(mload(ptr), mask) }
689                 }
690                 return ptr + needlelen;
691             } else {
692                 // For long needles, use hashing
693                 bytes32 hash;
694                 assembly { hash := keccak256(needleptr, needlelen) }
695                 ptr = selfptr + (selflen - needlelen);
696                 while (ptr >= selfptr) {
697                     bytes32 testHash;
698                     assembly { testHash := keccak256(ptr, needlelen) }
699                     if (hash == testHash)
700                         return ptr + needlelen;
701                     ptr -= 1;
702                 }
703             }
704         }
705         return selfptr;
706     }
707 
708     /*
709      * @dev Modifies `self` to contain everything from the first occurrence of
710      *      `needle` to the end of the slice. `self` is set to the empty slice
711      *      if `needle` is not found.
712      * @param self The slice to search and modify.
713      * @param needle The text to search for.
714      * @return `self`.
715      */
716     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
717         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
718         self._len -= ptr - self._ptr;
719         self._ptr = ptr;
720         return self;
721     }
722 
723     /*
724      * @dev Modifies `self` to contain the part of the string from the start of
725      *      `self` to the end of the first occurrence of `needle`. If `needle`
726      *      is not found, `self` is set to the empty slice.
727      * @param self The slice to search and modify.
728      * @param needle The text to search for.
729      * @return `self`.
730      */
731     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
732         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
733         self._len = ptr - self._ptr;
734         return self;
735     }
736 
737     /*
738      * @dev Splits the slice, setting `self` to everything after the first
739      *      occurrence of `needle`, and `token` to everything before it. If
740      *      `needle` does not occur in `self`, `self` is set to the empty slice,
741      *      and `token` is set to the entirety of `self`.
742      * @param self The slice to split.
743      * @param needle The text to search for in `self`.
744      * @param token An output parameter to which the first token is written.
745      * @return `token`.
746      */
747     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
748         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
749         token._ptr = self._ptr;
750         token._len = ptr - self._ptr;
751         if (ptr == self._ptr + self._len) {
752             // Not found
753             self._len = 0;
754         } else {
755             self._len -= token._len + needle._len;
756             self._ptr = ptr + needle._len;
757         }
758         return token;
759     }
760 
761     /*
762      * @dev Splits the slice, setting `self` to everything after the first
763      *      occurrence of `needle`, and returning everything before it. If
764      *      `needle` does not occur in `self`, `self` is set to the empty slice,
765      *      and the entirety of `self` is returned.
766      * @param self The slice to split.
767      * @param needle The text to search for in `self`.
768      * @return The part of `self` up to the first occurrence of `delim`.
769      */
770     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
771         split(self, needle, token);
772     }
773 
774     /*
775      * @dev Splits the slice, setting `self` to everything before the last
776      *      occurrence of `needle`, and `token` to everything after it. If
777      *      `needle` does not occur in `self`, `self` is set to the empty slice,
778      *      and `token` is set to the entirety of `self`.
779      * @param self The slice to split.
780      * @param needle The text to search for in `self`.
781      * @param token An output parameter to which the first token is written.
782      * @return `token`.
783      */
784     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
785         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
786         token._ptr = ptr;
787         token._len = self._len - (ptr - self._ptr);
788         if (ptr == self._ptr) {
789             // Not found
790             self._len = 0;
791         } else {
792             self._len -= token._len + needle._len;
793         }
794         return token;
795     }
796 
797     /*
798      * @dev Splits the slice, setting `self` to everything before the last
799      *      occurrence of `needle`, and returning everything after it. If
800      *      `needle` does not occur in `self`, `self` is set to the empty slice,
801      *      and the entirety of `self` is returned.
802      * @param self The slice to split.
803      * @param needle The text to search for in `self`.
804      * @return The part of `self` after the last occurrence of `delim`.
805      */
806     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
807         rsplit(self, needle, token);
808     }
809 
810     /*
811      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
812      * @param self The slice to search.
813      * @param needle The text to search for in `self`.
814      * @return The number of occurrences of `needle` found in `self`.
815      */
816     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
817         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
818         while (ptr <= self._ptr + self._len) {
819             cnt++;
820             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
821         }
822     }
823 
824     /*
825      * @dev Returns True if `self` contains `needle`.
826      * @param self The slice to search.
827      * @param needle The text to search for in `self`.
828      * @return True if `needle` is found in `self`, false otherwise.
829      */
830     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
831         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
832     }
833 
834     /*
835      * @dev Returns a newly allocated string containing the concatenation of
836      *      `self` and `other`.
837      * @param self The first slice to concatenate.
838      * @param other The second slice to concatenate.
839      * @return The concatenation of the two strings.
840      */
841     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
842         string memory ret = new string(self._len + other._len);
843         uint retptr;
844         assembly { retptr := add(ret, 32) }
845         memcpy(retptr, self._ptr, self._len);
846         memcpy(retptr + self._len, other._ptr, other._len);
847         return ret;
848     }
849 
850     /*
851      * @dev Joins an array of slices, using `self` as a delimiter, returning a
852      *      newly allocated string.
853      * @param self The delimiter to use.
854      * @param parts A list of slices to join.
855      * @return A newly allocated string containing all the slices in `parts`,
856      *         joined with `self`.
857      */
858     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
859         if (parts.length == 0)
860             return "";
861 
862         uint length = self._len * (parts.length - 1);
863         for (uint i = 0; i < parts.length; i++) {
864             length += parts[i]._len;
865         }
866 
867         string memory ret = new string(length);
868         uint retptr;
869         assembly { retptr := add(ret, 32) }
870 
871         for (uint i = 0; i < parts.length; i++) {
872             memcpy(retptr, parts[i]._ptr, parts[i]._len);
873             retptr += parts[i]._len;
874             if (i < parts.length - 1) {
875                 memcpy(retptr, self._ptr, self._len);
876                 retptr += self._len;
877             }
878         }
879 
880         return ret;
881     }
882 }
883 
884 interface ERC165 {
885     function supportsInterface(bytes4) external view returns (bool);
886 }
887 
888 interface ENS {
889 
890     // Logged when the owner of a node assigns a new owner to a subnode.
891     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
892 
893     // Logged when the owner of a node transfers ownership to a new account.
894     event Transfer(bytes32 indexed node, address owner);
895 
896     // Logged when the resolver for a node changes.
897     event NewResolver(bytes32 indexed node, address resolver);
898 
899     // Logged when the TTL of a node changes
900     event NewTTL(bytes32 indexed node, uint64 ttl);
901 
902 
903     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
904     function setResolver(bytes32 node, address resolver) external;
905     function setOwner(bytes32 node, address owner) external;
906     function setTTL(bytes32 node, uint64 ttl) external;
907     function owner(bytes32 node) external view returns (address);
908     function resolver(bytes32 node) external view returns (address);
909     function ttl(bytes32 node) external view returns (uint64);
910 
911 }
912 
913 library Address {
914     /**
915      * @dev Returns true if `account` is a contract.
916      *
917      * This test is non-exhaustive, and there may be false-negatives: during the
918      * execution of a contract's constructor, its address will be reported as
919      * not containing a contract.
920      *
921      * > It is unsafe to assume that an address for which this function returns
922      * false is an externally-owned account (EOA) and not a contract.
923      */
924     function isContract(address account) internal view returns (bool) {
925         // This method relies in extcodesize, which returns 0 for contracts in
926         // construction, since the code is only stored at the end of the
927         // constructor execution.
928 
929         uint256 size;
930         // solhint-disable-next-line no-inline-assembly
931         assembly { size := extcodesize(account) }
932         return size > 0;
933     }
934 }
935 
936 interface ERC20 {
937     function allowance(address _owner, address _spender) external view returns (uint256);
938     function approve(address _spender, uint256 _value) external returns (bool);
939     function balanceOf(address _who) external view returns (uint256);
940     function totalSupply() external view returns (uint256);
941     function transfer(address _to, uint256 _value) external returns (bool);
942     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
943 }
944 
945 contract AddrResolver is ResolverBase {
946     bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;
947 
948     event AddrChanged(bytes32 indexed node, address a);
949 
950     mapping(bytes32=>address) addresses;
951 
952     /**
953      * Sets the address associated with an ENS node.
954      * May only be called by the owner of that node in the ENS registry.
955      * @param node The node to update.
956      * @param addr The address to set.
957      */
958     function setAddr(bytes32 node, address addr) external authorised(node) {
959         addresses[node] = addr;
960         emit AddrChanged(node, addr);
961     }
962 
963     /**
964      * Returns the address associated with an ENS node.
965      * @param node The ENS node to query.
966      * @return The associated address.
967      */
968     function addr(bytes32 node) public view returns (address) {
969         return addresses[node];
970     }
971 
972     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
973         return interfaceID == ADDR_INTERFACE_ID || super.supportsInterface(interfaceID);
974     }
975 }
976 
977 contract ContentHashResolver is ResolverBase {
978     bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;
979 
980     event ContenthashChanged(bytes32 indexed node, bytes hash);
981 
982     mapping(bytes32=>bytes) hashes;
983 
984     /**
985      * Sets the contenthash associated with an ENS node.
986      * May only be called by the owner of that node in the ENS registry.
987      * @param node The node to update.
988      * @param hash The contenthash to set
989      */
990     function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {
991         hashes[node] = hash;
992         emit ContenthashChanged(node, hash);
993     }
994 
995     /**
996      * Returns the contenthash associated with an ENS node.
997      * @param node The ENS node to query.
998      * @return The associated contenthash.
999      */
1000     function contenthash(bytes32 node) external view returns (bytes memory) {
1001         return hashes[node];
1002     }
1003 
1004     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1005         return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);
1006     }
1007 }
1008 
1009 contract NameResolver is ResolverBase {
1010     bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;
1011 
1012     event NameChanged(bytes32 indexed node, string name);
1013 
1014     mapping(bytes32=>string) names;
1015 
1016     /**
1017      * Sets the name associated with an ENS node, for reverse records.
1018      * May only be called by the owner of that node in the ENS registry.
1019      * @param node The node to update.
1020      * @param name The name to set.
1021      */
1022     function setName(bytes32 node, string calldata name) external authorised(node) {
1023         names[node] = name;
1024         emit NameChanged(node, name);
1025     }
1026 
1027     /**
1028      * Returns the name associated with an ENS node, for reverse records.
1029      * Defined in EIP181.
1030      * @param node The ENS node to query.
1031      * @return The associated name.
1032      */
1033     function name(bytes32 node) external view returns (string memory) {
1034         return names[node];
1035     }
1036 
1037     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1038         return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);
1039     }
1040 }
1041 
1042 contract ABIResolver is ResolverBase {
1043     bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;
1044 
1045     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
1046 
1047     mapping(bytes32=>mapping(uint256=>bytes)) abis;
1048 
1049     /**
1050      * Sets the ABI associated with an ENS node.
1051      * Nodes may have one ABI of each content type. To remove an ABI, set it to
1052      * the empty string.
1053      * @param node The node to update.
1054      * @param contentType The content type of the ABI
1055      * @param data The ABI data.
1056      */
1057     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {
1058         // Content types must be powers of 2
1059         require(((contentType - 1) & contentType) == 0);
1060 
1061         abis[node][contentType] = data;
1062         emit ABIChanged(node, contentType);
1063     }
1064 
1065     /**
1066      * Returns the ABI associated with an ENS node.
1067      * Defined in EIP205.
1068      * @param node The ENS node to query
1069      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
1070      * @return contentType The content type of the return value
1071      * @return data The ABI data
1072      */
1073     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
1074         mapping(uint256=>bytes) storage abiset = abis[node];
1075 
1076         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
1077             if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {
1078                 return (contentType, abiset[contentType]);
1079             }
1080         }
1081 
1082         return (0, bytes(""));
1083     }
1084 
1085     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1086         return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);
1087     }
1088 }
1089 
1090 library SafeERC20 {
1091     using SafeMath for uint256;
1092     using Address for address;
1093 
1094     function safeTransfer(ERC20 token, address to, uint256 value) internal {
1095         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1096     }
1097 
1098     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
1099         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1100     }
1101 
1102     function safeApprove(ERC20 token, address spender, uint256 value) internal {
1103         // safeApprove should only be called when setting an initial allowance,
1104         // or when resetting it to zero. To increase and decrease it, use
1105         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1106         // solhint-disable-next-line max-line-length
1107         require((value == 0) || (token.allowance(address(this), spender) == 0),
1108             "SafeERC20: approve from non-zero to non-zero allowance"
1109         );
1110         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1111     }
1112 
1113     function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
1114         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1115         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1116     }
1117 
1118     function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
1119         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1120         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1121     }
1122 
1123     /**
1124      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1125      * on the return value: the return value is optional (but if data is returned, it must not be false).
1126      * @param token The token targeted by the call.
1127      * @param data The call data (encoded using abi.encode or one of its variants).
1128      */
1129     function callOptionalReturn(ERC20 token, bytes memory data) internal {
1130         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1131         // we're implementing it ourselves.
1132 
1133         // A Solidity high level call has three parts:
1134         //  1. The target address is checked to verify it contains contract code
1135         //  2. The call itself is made, and success asserted
1136         //  3. The return value is decoded, which in turn checks the size of the returned data.
1137         // solhint-disable-next-line max-line-length
1138         require(address(token).isContract(), "SafeERC20: call to non-contract");
1139 
1140         // solhint-disable-next-line avoid-low-level-calls
1141         (bool success, bytes memory returndata) = address(token).call(data);
1142         require(success, "SafeERC20: low-level call failed");
1143 
1144         if (returndata.length > 0) { // Return data is optional
1145             // solhint-disable-next-line max-line-length
1146             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1147         }
1148     }
1149 }
1150 
1151 library BytesUtils {
1152 
1153     using SafeMath for uint256;
1154 
1155     /// @dev This function converts to an address
1156     /// @param _bts bytes
1157     /// @param _from start position
1158     function _bytesToAddress(bytes memory _bts, uint _from) internal pure returns (address) {
1159 
1160         require(_bts.length >= _from.add(20), "slicing out of range");
1161 
1162         bytes20 convertedAddress;
1163         uint startByte = _from.add(32); //first 32 bytes denote the array length
1164 
1165         assembly {
1166             convertedAddress := mload(add(_bts, startByte))
1167         }
1168 
1169         return address(convertedAddress);
1170     }
1171 
1172     /// @dev This function slices bytes into bytes4
1173     /// @param _bts some bytes
1174     /// @param _from start position
1175     function _bytesToBytes4(bytes memory _bts, uint _from) internal pure returns (bytes4) {
1176         require(_bts.length >= _from.add(4), "slicing out of range");
1177 
1178         bytes4 slicedBytes4;
1179         uint startByte = _from.add(32); //first 32 bytes denote the array length
1180 
1181         assembly {
1182             slicedBytes4 := mload(add(_bts, startByte))
1183         }
1184 
1185         return slicedBytes4;
1186 
1187     }
1188 
1189     /// @dev This function slices a uint
1190     /// @param _bts some bytes
1191     /// @param _from start position
1192     // credit to https://ethereum.stackexchange.com/questions/51229/how-to-convert-bytes-to-uint-in-solidity
1193     // and Nick Johnson https://ethereum.stackexchange.com/questions/4170/how-to-convert-a-uint-to-bytes-in-solidity/4177#4177
1194     function _bytesToUint256(bytes memory _bts, uint _from) internal pure returns (uint) {
1195         require(_bts.length >= _from.add(32), "slicing out of range");
1196 
1197         uint convertedUint256;
1198         uint startByte = _from.add(32); //first 32 bytes denote the array length
1199         
1200         assembly {
1201             convertedUint256 := mload(add(_bts, startByte))
1202         }
1203 
1204         return convertedUint256;
1205     }
1206 }
1207 
1208 contract Balanceable {
1209 
1210     /// @dev This function is used to get a balance
1211     /// @param _address of which balance we are trying to ascertain
1212     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
1213     /// @return balance associated with an address, for any token, in the wei equivalent
1214     function _balance(address _address, address _asset) internal view returns (uint) {
1215         if (_asset != address(0)) {
1216             return ERC20(_asset).balanceOf(_address);
1217         } else {
1218             return _address.balance;
1219         }
1220     }
1221 }
1222 
1223 contract PubkeyResolver is ResolverBase {
1224     bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;
1225 
1226     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
1227 
1228     struct PublicKey {
1229         bytes32 x;
1230         bytes32 y;
1231     }
1232 
1233     mapping(bytes32=>PublicKey) pubkeys;
1234 
1235     /**
1236      * Sets the SECP256k1 public key associated with an ENS node.
1237      * @param node The ENS node to query
1238      * @param x the X coordinate of the curve point for the public key.
1239      * @param y the Y coordinate of the curve point for the public key.
1240      */
1241     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {
1242         pubkeys[node] = PublicKey(x, y);
1243         emit PubkeyChanged(node, x, y);
1244     }
1245 
1246     /**
1247      * Returns the SECP256k1 public key associated with an ENS node.
1248      * Defined in EIP 619.
1249      * @param node The ENS node to query
1250      * @return x, y the X and Y coordinates of the curve point for the public key.
1251      */
1252     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
1253         return (pubkeys[node].x, pubkeys[node].y);
1254     }
1255 
1256     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1257         return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);
1258     }
1259 }
1260 
1261 contract TextResolver is ResolverBase {
1262     bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;
1263 
1264     event TextChanged(bytes32 indexed node, string indexedKey, string key);
1265 
1266     mapping(bytes32=>mapping(string=>string)) texts;
1267 
1268     /**
1269      * Sets the text data associated with an ENS node and key.
1270      * May only be called by the owner of that node in the ENS registry.
1271      * @param node The node to update.
1272      * @param key The key to set.
1273      * @param value The text data value to set.
1274      */
1275     function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {
1276         texts[node][key] = value;
1277         emit TextChanged(node, key, key);
1278     }
1279 
1280     /**
1281      * Returns the text data associated with an ENS node and key.
1282      * @param node The ENS node to query.
1283      * @param key The text data key to query.
1284      * @return The associated text data.
1285      */
1286     function text(bytes32 node, string calldata key) external view returns (string memory) {
1287         return texts[node][key];
1288     }
1289 
1290     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1291         return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);
1292     }
1293 }
1294 
1295 contract Transferrable {
1296 
1297     using SafeERC20 for ERC20;
1298 
1299 
1300     /// @dev This function is used to move tokens sent accidentally to this contract method.
1301     /// @dev The owner can chose the new destination address
1302     /// @param _to is the recipient's address.
1303     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
1304     /// @param _amount is the amount to be transferred in base units.
1305     function _safeTransfer(address payable _to, address _asset, uint _amount) internal {
1306         // address(0) is used to denote ETH
1307         if (_asset == address(0)) {
1308             _to.transfer(_amount);
1309         } else {
1310             ERC20(_asset).safeTransfer(_to, _amount);
1311         }
1312     }
1313 }
1314 
1315 contract InterfaceResolver is ResolverBase, AddrResolver {
1316     bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));
1317     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
1318 
1319     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
1320 
1321     mapping(bytes32=>mapping(bytes4=>address)) interfaces;
1322 
1323     /**
1324      * Sets an interface associated with a name.
1325      * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.
1326      * @param node The node to update.
1327      * @param interfaceID The EIP 168 interface ID.
1328      * @param implementer The address of a contract that implements this interface for this node.
1329      */
1330     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {
1331         interfaces[node][interfaceID] = implementer;
1332         emit InterfaceChanged(node, interfaceID, implementer);
1333     }
1334 
1335     /**
1336      * Returns the address of a contract that implements the specified interface for this name.
1337      * If an implementer has not been set for this interfaceID and name, the resolver will query
1338      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
1339      * contract implements EIP168 and returns `true` for the specified interfaceID, its address
1340      * will be returned.
1341      * @param node The ENS node to query.
1342      * @param interfaceID The EIP 168 interface ID to check for.
1343      * @return The address that implements this interface, or 0 if the interface is unsupported.
1344      */
1345     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {
1346         address implementer = interfaces[node][interfaceID];
1347         if(implementer != address(0)) {
1348             return implementer;
1349         }
1350 
1351         address a = addr(node);
1352         if(a == address(0)) {
1353             return address(0);
1354         }
1355 
1356         (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));
1357         if(!success || returnData.length < 32 || returnData[31] == 0) {
1358             // EIP 168 not supported by target
1359             return address(0);
1360         }
1361 
1362         (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));
1363         if(!success || returnData.length < 32 || returnData[31] == 0) {
1364             // Specified interface not supported by target
1365             return address(0);
1366         }
1367 
1368         return a;
1369     }
1370 
1371     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
1372         return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);
1373     }
1374 }
1375 
1376 interface IController {
1377     function isController(address) external view returns (bool);
1378     function isAdmin(address) external view returns (bool);
1379 }
1380 
1381 
1382 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
1383 /// @notice The Controller implements a hierarchy of concepts, Owner, Admin, and the Controllers.
1384 /// @dev Owner can change the Admins
1385 /// @dev Admins and can the Controllers
1386 /// @dev Controllers are used by the application.
1387 contract Controller is IController, Ownable, Transferrable {
1388 
1389     event AddedController(address _sender, address _controller);
1390     event RemovedController(address _sender, address _controller);
1391 
1392     event AddedAdmin(address _sender, address _admin);
1393     event RemovedAdmin(address _sender, address _admin);
1394 
1395     event Claimed(address _to, address _asset, uint _amount);
1396 
1397     event Stopped(address _sender);
1398     event Started(address _sender);
1399 
1400     mapping (address => bool) private _isAdmin;
1401     uint private _adminCount;
1402 
1403     mapping (address => bool) private _isController;
1404     uint private _controllerCount;
1405 
1406     bool private _stopped;
1407 
1408     /// @notice Constructor initializes the owner with the provided address.
1409     /// @param _ownerAddress_ address of the owner.
1410     constructor(address payable _ownerAddress_) Ownable(_ownerAddress_, false) public {}
1411 
1412     /// @notice Checks if message sender is an admin.
1413     modifier onlyAdmin() {
1414         require(isAdmin(msg.sender), "sender is not an admin");
1415         _;
1416     }
1417 
1418     /// @notice Check if Owner or Admin
1419     modifier onlyAdminOrOwner() {
1420         require(_isOwner(msg.sender) || isAdmin(msg.sender), "sender is not an admin");
1421         _;
1422     }
1423 
1424     /// @notice Check if controller is stopped
1425     modifier notStopped() {
1426         require(!isStopped(), "controller is stopped");
1427         _;
1428     }
1429 
1430     /// @notice Add a new admin to the list of admins.
1431     /// @param _account address to add to the list of admins.
1432     function addAdmin(address _account) external onlyOwner notStopped {
1433         _addAdmin(_account);
1434     }
1435 
1436     /// @notice Remove a admin from the list of admins.
1437     /// @param _account address to remove from the list of admins.
1438     function removeAdmin(address _account) external onlyOwner {
1439         _removeAdmin(_account);
1440     }
1441 
1442     /// @return the current number of admins.
1443     function adminCount() external view returns (uint) {
1444         return _adminCount;
1445     }
1446 
1447     /// @notice Add a new controller to the list of controllers.
1448     /// @param _account address to add to the list of controllers.
1449     function addController(address _account) external onlyAdminOrOwner notStopped {
1450         _addController(_account);
1451     }
1452 
1453     /// @notice Remove a controller from the list of controllers.
1454     /// @param _account address to remove from the list of controllers.
1455     function removeController(address _account) external onlyAdminOrOwner {
1456         _removeController(_account);
1457     }
1458 
1459     /// @notice count the Controllers
1460     /// @return the current number of controllers.
1461     function controllerCount() external view returns (uint) {
1462         return _controllerCount;
1463     }
1464 
1465     /// @notice is an address an Admin?
1466     /// @return true if the provided account is an admin.
1467     function isAdmin(address _account) public view notStopped returns (bool) {
1468         return _isAdmin[_account];
1469     }
1470 
1471     /// @notice is an address a Controller?
1472     /// @return true if the provided account is a controller.
1473     function isController(address _account) public view notStopped returns (bool) {
1474         return _isController[_account];
1475     }
1476 
1477     /// @notice this function can be used to see if the controller has been stopped
1478     /// @return true is the Controller has been stopped
1479     function isStopped() public view returns (bool) {
1480         return _stopped;
1481     }
1482 
1483     /// @notice Internal-only function that adds a new admin.
1484     function _addAdmin(address _account) private {
1485         require(!_isAdmin[_account], "provided account is already an admin");
1486         require(!_isController[_account], "provided account is already a controller");
1487         require(!_isOwner(_account), "provided account is already the owner");
1488         require(_account != address(0), "provided account is the zero address");
1489         _isAdmin[_account] = true;
1490         _adminCount++;
1491         emit AddedAdmin(msg.sender, _account);
1492     }
1493 
1494     /// @notice Internal-only function that removes an existing admin.
1495     function _removeAdmin(address _account) private {
1496         require(_isAdmin[_account], "provided account is not an admin");
1497         _isAdmin[_account] = false;
1498         _adminCount--;
1499         emit RemovedAdmin(msg.sender, _account);
1500     }
1501 
1502     /// @notice Internal-only function that adds a new controller.
1503     function _addController(address _account) private {
1504         require(!_isAdmin[_account], "provided account is already an admin");
1505         require(!_isController[_account], "provided account is already a controller");
1506         require(!_isOwner(_account), "provided account is already the owner");
1507         require(_account != address(0), "provided account is the zero address");
1508         _isController[_account] = true;
1509         _controllerCount++;
1510         emit AddedController(msg.sender, _account);
1511     }
1512 
1513     /// @notice Internal-only function that removes an existing controller.
1514     function _removeController(address _account) private {
1515         require(_isController[_account], "provided account is not a controller");
1516         _isController[_account] = false;
1517         _controllerCount--;
1518         emit RemovedController(msg.sender, _account);
1519     }
1520 
1521     /// @notice stop our controllers and admins from being useable
1522     function stop() external onlyAdminOrOwner {
1523         _stopped = true;
1524         emit Stopped(msg.sender);
1525     }
1526 
1527     /// @notice start our controller again
1528     function start() external onlyOwner {
1529         _stopped = false;
1530         emit Started(msg.sender);
1531     }
1532 
1533     //// @notice Withdraw tokens from the smart contract to the specified account.
1534     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin notStopped {
1535         _safeTransfer(_to, _asset, _amount);
1536         emit Claimed(_to, _asset, _amount);
1537     }
1538 }
1539 
1540 contract PublicResolver is ABIResolver, AddrResolver, ContentHashResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {
1541     ENS ens;
1542 
1543     /**
1544      * A mapping of authorisations. An address that is authorised for a name
1545      * may make any changes to the name that the owner could, but may not update
1546      * the set of authorisations.
1547      * (node, owner, caller) => isAuthorised
1548      */
1549     mapping(bytes32=>mapping(address=>mapping(address=>bool))) public authorisations;
1550 
1551     event AuthorisationChanged(bytes32 indexed node, address indexed owner, address indexed target, bool isAuthorised);
1552 
1553     constructor(ENS _ens) public {
1554         ens = _ens;
1555     }
1556 
1557     /**
1558      * @dev Sets or clears an authorisation.
1559      * Authorisations are specific to the caller. Any account can set an authorisation
1560      * for any name, but the authorisation that is checked will be that of the
1561      * current owner of a name. Thus, transferring a name effectively clears any
1562      * existing authorisations, and new authorisations can be set in advance of
1563      * an ownership transfer if desired.
1564      *
1565      * @param node The name to change the authorisation on.
1566      * @param target The address that is to be authorised or deauthorised.
1567      * @param isAuthorised True if the address should be authorised, or false if it should be deauthorised.
1568      */
1569     function setAuthorisation(bytes32 node, address target, bool isAuthorised) external {
1570         authorisations[node][msg.sender][target] = isAuthorised;
1571         emit AuthorisationChanged(node, msg.sender, target, isAuthorised);
1572     }
1573 
1574     function isAuthorised(bytes32 node) internal view returns(bool) {
1575         address owner = ens.owner(node);
1576         return owner == msg.sender || authorisations[node][owner][msg.sender];
1577     }
1578 }
1579 
1580 contract ENSResolvable {
1581     /// @notice _ens is an instance of ENS
1582     ENS private _ens;
1583 
1584     /// @notice _ensRegistry points to the ENS registry smart contract.
1585     address private _ensRegistry;
1586 
1587     /// @param _ensReg_ is the ENS registry used
1588     constructor(address _ensReg_) internal {
1589         _ensRegistry = _ensReg_;
1590         _ens = ENS(_ensRegistry);
1591     }
1592 
1593     /// @notice this is used to that one can observe which ENS registry is being used
1594     function ensRegistry() external view returns (address) {
1595         return _ensRegistry;
1596     }
1597 
1598     /// @notice helper function used to get the address of a node
1599     /// @param _node of the ENS entry that needs resolving
1600     /// @return the address of the said node
1601     function _ensResolve(bytes32 _node) internal view returns (address) {
1602         return PublicResolver(_ens.resolver(_node)).addr(_node);
1603     }
1604 
1605 }
1606 
1607 contract Controllable is ENSResolvable {
1608     /// @dev Is the registered ENS node identifying the controller contract.
1609     bytes32 private _controllerNode;
1610 
1611     /// @notice Constructor initializes the controller contract object.
1612     /// @param _controllerNode_ is the ENS node of the Controller.
1613     constructor(bytes32 _controllerNode_) internal {
1614         _controllerNode = _controllerNode_;
1615     }
1616 
1617     /// @notice Checks if message sender is a controller.
1618     modifier onlyController() {
1619         require(_isController(msg.sender), "sender is not a controller");
1620         _;
1621     }
1622 
1623     /// @notice Checks if message sender is an admin.
1624     modifier onlyAdmin() {
1625         require(_isAdmin(msg.sender), "sender is not an admin");
1626         _;
1627     }
1628 
1629     /// @return the controller node registered in ENS.
1630     function controllerNode() external view returns (bytes32) {
1631         return _controllerNode;
1632     }
1633 
1634     /// @return true if the provided account is a controller.
1635     function _isController(address _account) internal view returns (bool) {
1636         return IController(_ensResolve(_controllerNode)).isController(_account);
1637     }
1638 
1639     /// @return true if the provided account is an admin.
1640     function _isAdmin(address _account) internal view returns (bool) {
1641         return IController(_ensResolve(_controllerNode)).isAdmin(_account);
1642     }
1643 
1644 }
1645 
1646 interface ILicence {
1647     function load(address, uint) external payable;
1648     function updateLicenceAmount(uint) external;
1649 }
1650 
1651 
1652 /// @title Licence loads the TokenCard and transfers the licence amout to the TKN Holder Contract.
1653 /// @notice the rest of the amount gets sent to the CryptoFloat
1654 contract Licence is Transferrable, ENSResolvable, Controllable {
1655 
1656     using SafeMath for uint256;
1657     using SafeERC20 for ERC20;
1658 
1659     /*******************/
1660     /*     Events     */
1661     /*****************/
1662 
1663     event UpdatedLicenceDAO(address _newDAO);
1664     event UpdatedCryptoFloat(address _newFloat);
1665     event UpdatedTokenHolder(address _newHolder);
1666     event UpdatedTKNContractAddress(address _newTKN);
1667     event UpdatedLicenceAmount(uint _newAmount);
1668 
1669     event TransferredToTokenHolder(address _from, address _to, address _asset, uint _amount);
1670     event TransferredToCryptoFloat(address _from, address _to, address _asset, uint _amount);
1671 
1672     event Claimed(address _to, address _asset, uint _amount);
1673 
1674     /// @notice This is 100% scaled up by a factor of 10 to give us an extra 1 decimal place of precision
1675     uint constant public MAX_AMOUNT_SCALE = 1000;
1676     uint constant public MIN_AMOUNT_SCALE = 1;
1677 
1678     address private _tknContractAddress = 0xaAAf91D9b90dF800Df4F55c205fd6989c977E73a; // solium-disable-line uppercase
1679 
1680     address payable private _cryptoFloat;
1681     address payable private _tokenHolder;
1682     address private _licenceDAO;
1683 
1684     bool private _lockedCryptoFloat;
1685     bool private _lockedTokenHolder;
1686     bool private _lockedLicenceDAO;
1687     bool private _lockedTKNContractAddress;
1688 
1689     /// @notice This is the _licenceAmountScaled by a factor of 10
1690     /// @dev i.e. 1% is 10 _licenceAmountScaled, 0.1% is 1 _licenceAmountScaled
1691     uint private _licenceAmountScaled;
1692 
1693     /// @notice Reverts if called by any address other than the DAO contract.
1694     modifier onlyDAO() {
1695         require(msg.sender == _licenceDAO, "the sender isn't the DAO");
1696         _;
1697     }
1698 
1699     /// @notice Constructor initializes the card licence contract.
1700     /// @param _licence_ is the initial card licence amount. this number is scaled 10 = 1%, 9 = 0.9%
1701     /// @param _float_ is the address of the multi-sig cryptocurrency float contract.
1702     /// @param _holder_ is the address of the token holder contract
1703     /// @param _tknAddress_ is the address of the TKN ERC20 contract
1704     /// @param _ens_ is the address of the ENS Registry
1705     /// @param _controllerNode_ is the ENS node corresponding to the controller
1706     constructor(uint _licence_, address payable _float_, address payable _holder_, address _tknAddress_, address _ens_, bytes32 _controllerNode_) ENSResolvable(_ens_) Controllable(_controllerNode_) public {
1707         require(MIN_AMOUNT_SCALE <= _licence_ && _licence_ <= MAX_AMOUNT_SCALE, "licence amount out of range");
1708         _licenceAmountScaled = _licence_;
1709         _cryptoFloat = _float_;
1710         _tokenHolder = _holder_;
1711         if (_tknAddress_ != address(0)) {
1712             _tknContractAddress = _tknAddress_;
1713         }
1714     }
1715 
1716     /// @notice Ether can be deposited from any source, so this contract should be payable by anyone.
1717     function() external payable {}
1718 
1719     /// @notice this allows for people to see the scaled licence amount
1720     /// @return the scaled licence amount, used to calculate the split when loading.
1721     function licenceAmountScaled() external view returns (uint) {
1722         return _licenceAmountScaled;
1723     }
1724 
1725     /// @notice allows one to see the address of the CryptoFloat
1726     /// @return the address of the multi-sig cryptocurrency float contract.
1727     function cryptoFloat() external view returns (address) {
1728         return _cryptoFloat;
1729     }
1730 
1731     /// @notice allows one to see the address TKN holder contract
1732     /// @return the address of the token holder contract.
1733     function tokenHolder() external view returns (address) {
1734         return _tokenHolder;
1735     }
1736 
1737     /// @notice allows one to see the address of the DAO
1738     /// @return the address of the DAO contract.
1739     function licenceDAO() external view returns (address) {
1740         return _licenceDAO;
1741     }
1742 
1743     /// @notice The address of the TKN token
1744     /// @return the address of the TKN contract.
1745     function tknContractAddress() external view returns (address) {
1746         return _tknContractAddress;
1747     }
1748 
1749     /// @notice This locks the cryptoFloat address
1750     /// @dev so that it can no longer be updated
1751     function lockFloat() external onlyAdmin {
1752         _lockedCryptoFloat = true;
1753     }
1754 
1755     /// @notice This locks the TokenHolder address
1756     /// @dev so that it can no longer be updated
1757     function lockHolder() external onlyAdmin {
1758         _lockedTokenHolder = true;
1759     }
1760 
1761     /// @notice This locks the DAO address
1762     /// @dev so that it can no longer be updated
1763     function lockLicenceDAO() external onlyAdmin {
1764         _lockedLicenceDAO = true;
1765     }
1766 
1767     /// @notice This locks the TKN address
1768     /// @dev so that it can no longer be updated
1769     function lockTKNContractAddress() external onlyAdmin {
1770         _lockedTKNContractAddress = true;
1771     }
1772 
1773     /// @notice Updates the address of the cyptoFloat.
1774     /// @param _newFloat This is the new address for the CryptoFloat
1775     function updateFloat(address payable _newFloat) external onlyAdmin {
1776         require(!floatLocked(), "float is locked");
1777         _cryptoFloat = _newFloat;
1778         emit UpdatedCryptoFloat(_newFloat);
1779     }
1780 
1781     /// @notice Updates the address of the Holder contract.
1782     /// @param _newHolder This is the new address for the TokenHolder
1783     function updateHolder(address payable _newHolder) external onlyAdmin {
1784         require(!holderLocked(), "holder contract is locked");
1785         _tokenHolder = _newHolder;
1786         emit UpdatedTokenHolder(_newHolder);
1787     }
1788 
1789     /// @notice Updates the address of the DAO contract.
1790     /// @param _newDAO This is the new address for the Licence DAO
1791     function updateLicenceDAO(address _newDAO) external onlyAdmin {
1792         require(!licenceDAOLocked(), "DAO is locked");
1793         _licenceDAO = _newDAO;
1794         emit UpdatedLicenceDAO(_newDAO);
1795     }
1796 
1797     /// @notice Updates the address of the TKN contract.
1798     /// @param _newTKN This is the new address for the TKN contract
1799     function updateTKNContractAddress(address _newTKN) external onlyAdmin {
1800         require(!tknContractAddressLocked(), "TKN is locked");
1801         _tknContractAddress = _newTKN;
1802         emit UpdatedTKNContractAddress(_newTKN);
1803     }
1804 
1805     /// @notice Updates the TKN licence amount
1806     /// @param _newAmount is a number between MIN_AMOUNT_SCALE (1) and MAX_AMOUNT_SCALE
1807     function updateLicenceAmount(uint _newAmount) external onlyDAO {
1808         require(MIN_AMOUNT_SCALE <= _newAmount && _newAmount <= MAX_AMOUNT_SCALE, "licence amount out of range");
1809         _licenceAmountScaled = _newAmount;
1810         emit UpdatedLicenceAmount(_newAmount);
1811     }
1812 
1813     /// @notice Load the holder and float contracts based on the licence amount and asset amount.
1814     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
1815     /// @param _amount is the amount of assets to be transferred including the licence amount.
1816     function load(address _asset, uint _amount) external payable {
1817         uint loadAmount = _amount;
1818         // If TKN then no licence to be paid
1819         if (_asset == _tknContractAddress) {
1820             ERC20(_asset).safeTransferFrom(msg.sender, _cryptoFloat, loadAmount);
1821         } else {
1822             loadAmount = _amount.mul(MAX_AMOUNT_SCALE).div(_licenceAmountScaled + MAX_AMOUNT_SCALE);
1823             uint licenceAmount = _amount.sub(loadAmount);
1824 
1825             if (_asset != address(0)) {
1826                 ERC20(_asset).safeTransferFrom(msg.sender, _tokenHolder, licenceAmount);
1827                 ERC20(_asset).safeTransferFrom(msg.sender, _cryptoFloat, loadAmount);
1828             } else {
1829                 require(msg.value == _amount, "ETH sent is not equal to amount");
1830                 _tokenHolder.transfer(licenceAmount);
1831                 _cryptoFloat.transfer(loadAmount);
1832             }
1833 
1834             emit TransferredToTokenHolder(msg.sender, _tokenHolder, _asset, licenceAmount);
1835         }
1836 
1837         emit TransferredToCryptoFloat(msg.sender, _cryptoFloat, _asset, loadAmount);
1838     }
1839 
1840     //// @notice Withdraw tokens from the smart contract to the specified account.
1841     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {
1842         _safeTransfer(_to, _asset, _amount);
1843         emit Claimed(_to, _asset, _amount);
1844     }
1845 
1846     /// @notice returns whether or not the CryptoFloat address is locked
1847     function floatLocked() public view returns (bool) {
1848         return _lockedCryptoFloat;
1849     }
1850 
1851     /// @notice returns whether or not the TokenHolder address is locked
1852     function holderLocked() public view returns (bool) {
1853         return _lockedTokenHolder;
1854     }
1855 
1856     /// @notice returns whether or not the Licence DAO address is locked
1857     function licenceDAOLocked() public view returns (bool) {
1858         return _lockedLicenceDAO;
1859     }
1860 
1861     /// @notice returns whether or not the TKN address is locked
1862     function tknContractAddressLocked() public view returns (bool) {
1863         return _lockedTKNContractAddress;
1864     }
1865 }
1866 
1867 interface ITokenWhitelist {
1868     function getTokenInfo(address) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);
1869     function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256);
1870     function tokenAddressArray() external view returns (address[] memory);
1871     function redeemableTokens() external view returns (address[] memory);
1872     function methodIdWhitelist(bytes4) external view returns (bool);
1873     function getERC20RecipientAndAmount(address, bytes calldata) external view returns (address, uint);
1874     function stablecoin() external view returns (address);
1875     function updateTokenRate(address, uint, uint) external;
1876 }
1877 
1878 
1879 /// @title TokenWhitelist stores a list of tokens used by the Consumer Contract Wallet, the Oracle, the TKN Holder and the TKN Licence Contract
1880 contract TokenWhitelist is ENSResolvable, Controllable, Transferrable {
1881     using strings for *;
1882     using SafeMath for uint256;
1883     using BytesUtils for bytes;
1884 
1885     event UpdatedTokenRate(address _sender, address _token, uint _rate);
1886 
1887     event UpdatedTokenLoadable(address _sender, address _token, bool _loadable);
1888     event UpdatedTokenRedeemable(address _sender, address _token, bool _redeemable);
1889 
1890     event AddedToken(address _sender, address _token, string _symbol, uint _magnitude, bool _loadable, bool _redeemable);
1891     event RemovedToken(address _sender, address _token);
1892 
1893     event AddedMethodId(bytes4 _methodId);
1894     event RemovedMethodId(bytes4 _methodId);
1895     event AddedExclusiveMethod(address _token, bytes4 _methodId);
1896     event RemovedExclusiveMethod(address _token, bytes4 _methodId);
1897 
1898     event Claimed(address _to, address _asset, uint _amount);
1899 
1900     /// @dev these are the methods whitelisted by default in executeTransaction() for protected tokens
1901     bytes4 private constant _APPROVE = 0x095ea7b3; // keccak256(approve(address,uint256)) => 0x095ea7b3
1902     bytes4 private constant _BURN = 0x42966c68; // keccak256(burn(uint256)) => 0x42966c68
1903     bytes4 private constant _TRANSFER= 0xa9059cbb; // keccak256(transfer(address,uint256)) => 0xa9059cbb
1904     bytes4 private constant _TRANSFER_FROM = 0x23b872dd; // keccak256(transferFrom(address,address,uint256)) => 0x23b872dd
1905 
1906     struct Token {
1907         string symbol;    // Token symbol
1908         uint magnitude;   // 10^decimals
1909         uint rate;        // Token exchange rate in wei
1910         bool available;   // Flags if the token is available or not
1911         bool loadable;    // Flags if token is loadable to the TokenCard
1912         bool redeemable;    // Flags if token is redeemable in the TKN Holder contract
1913         uint lastUpdate;  // Time of the last rate update
1914     }
1915 
1916     mapping(address => Token) private _tokenInfoMap;
1917 
1918     // @notice specifies whitelisted methodIds for protected tokens in wallet's excuteTranaction() e.g. keccak256(transfer(address,uint256)) => 0xa9059cbb
1919     mapping(bytes4 => bool) private _methodIdWhitelist;
1920 
1921     address[] private _tokenAddressArray;
1922 
1923     /// @notice keeping track of how many redeemable tokens are in the tokenWhitelist
1924     uint private _redeemableCounter;
1925 
1926     /// @notice Address of the stablecoin.
1927     address private _stablecoin;
1928 
1929     /// @notice is registered ENS node identifying the oracle contract.
1930     bytes32 private _oracleNode;
1931 
1932     /// @notice Constructor initializes ENSResolvable, and Controllable.
1933     /// @param _ens_ is the ENS registry address.
1934     /// @param _oracleNode_ is the ENS node of the Oracle.
1935     /// @param _controllerNode_ is our Controllers node.
1936     /// @param _stablecoinAddress_ is the address of the stablecoint used by the wallet for the card load limit.
1937     constructor(address _ens_, bytes32 _oracleNode_, bytes32 _controllerNode_, address _stablecoinAddress_) ENSResolvable(_ens_) Controllable(_controllerNode_) public {
1938         _oracleNode = _oracleNode_;
1939         _stablecoin = _stablecoinAddress_;
1940         //a priori ERC20 whitelisted methods
1941         _methodIdWhitelist[_APPROVE] = true;
1942         _methodIdWhitelist[_BURN] = true;
1943         _methodIdWhitelist[_TRANSFER] = true;
1944         _methodIdWhitelist[_TRANSFER_FROM] = true;
1945     }
1946 
1947     modifier onlyAdminOrOracle() {
1948         address oracleAddress = _ensResolve(_oracleNode);
1949         require (_isAdmin(msg.sender) || msg.sender == oracleAddress, "either oracle or admin");
1950         _;
1951     }
1952 
1953     /// @notice Add ERC20 tokens to the list of whitelisted tokens.
1954     /// @param _tokens ERC20 token contract addresses.
1955     /// @param _symbols ERC20 token names.
1956     /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
1957     /// @param _loadable is a bool that states whether or not a token is loadable to the TokenCard.
1958     /// @param _redeemable is a bool that states whether or not a token is redeemable in the TKN Holder Contract.
1959     /// @param _lastUpdate is a unit representing an ISO datetime e.g. 20180913153211.
1960     function addTokens(address[] calldata _tokens, bytes32[] calldata _symbols, uint[] calldata _magnitude, bool[] calldata _loadable, bool[] calldata _redeemable, uint _lastUpdate) external onlyAdmin {
1961         // Require that all parameters have the same length.
1962         require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length && _tokens.length == _loadable.length && _tokens.length == _loadable.length, "parameter lengths do not match");
1963         // Add each token to the list of supported tokens.
1964         for (uint i = 0; i < _tokens.length; i++) {
1965             // Require that the token isn't already available.
1966             require(!_tokenInfoMap[_tokens[i]].available, "token already available");
1967             // Store the intermediate values.
1968             string memory symbol = _symbols[i].toSliceB32().toString();
1969             // Add the token to the token list.
1970             _tokenInfoMap[_tokens[i]] = Token({
1971                 symbol : symbol,
1972                 magnitude : _magnitude[i],
1973                 rate : 0,
1974                 available : true,
1975                 loadable : _loadable[i],
1976                 redeemable: _redeemable[i],
1977                 lastUpdate : _lastUpdate
1978                 });
1979             // Add the token address to the address list.
1980             _tokenAddressArray.push(_tokens[i]);
1981             //if the token is redeemable increase the redeemableCounter
1982             if (_redeemable[i]){
1983                 _redeemableCounter = _redeemableCounter.add(1);
1984             }
1985             // Emit token addition event.
1986             emit AddedToken(msg.sender, _tokens[i], symbol, _magnitude[i], _loadable[i], _redeemable[i]);
1987         }
1988     }
1989 
1990     /// @notice Remove ERC20 tokens from the whitelist of tokens.
1991     /// @param _tokens ERC20 token contract addresses.
1992     function removeTokens(address[] calldata _tokens) external onlyAdmin {
1993         // Delete each token object from the list of supported tokens based on the addresses provided.
1994         for (uint i = 0; i < _tokens.length; i++) {
1995             // Store the token address.
1996             address token = _tokens[i];
1997             //token must be available, reverts on duplicates as well
1998             require(_tokenInfoMap[token].available, "token is not available");
1999             //if the token is redeemable decrease the redeemableCounter
2000             if (_tokenInfoMap[token].redeemable){
2001                 _redeemableCounter = _redeemableCounter.sub(1);
2002             }
2003             // Delete the token object.
2004             delete _tokenInfoMap[token];
2005             // Remove the token address from the address list.
2006             for (uint j = 0; j < _tokenAddressArray.length.sub(1); j++) {
2007                 if (_tokenAddressArray[j] == token) {
2008                     _tokenAddressArray[j] = _tokenAddressArray[_tokenAddressArray.length.sub(1)];
2009                     break;
2010                 }
2011             }
2012             _tokenAddressArray.length--;
2013             // Emit token removal event.
2014             emit RemovedToken(msg.sender, token);
2015         }
2016     }
2017 
2018     /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.
2019     /// @param _data is the transaction payload.
2020     function getERC20RecipientAndAmount(address _token, bytes calldata _data) external view returns (address, uint) {
2021         // Require that there exist enough bytes for encoding at least a method signature + data in the transaction payload:
2022         // 4 (signature)  + 32(address or uint256)
2023         require(_data.length >= 4 + 32, "not enough method-encoding bytes");
2024         // Get the method signature
2025         bytes4 signature = _data._bytesToBytes4(0);
2026         // Check if method Id is supported
2027         require(isERC20MethodSupported(_token, signature), "unsupported method");
2028         // returns the recipient's address and amount is the value to be transferred
2029         if (signature == _BURN) {
2030             // 4 (signature) + 32(uint256)
2031             return (_token, _data._bytesToUint256(4));
2032         } else if (signature == _TRANSFER_FROM) {
2033             // 4 (signature) + 32(address) + 32(address) + 32(uint256)
2034             require(_data.length >= 4 + 32 + 32 + 32, "not enough data for transferFrom");
2035             return ( _data._bytesToAddress(4 + 32 + 12), _data._bytesToUint256(4 + 32 + 32));
2036         } else { //transfer or approve
2037             // 4 (signature) + 32(address) + 32(uint)
2038             require(_data.length >= 4 + 32 + 32, "not enough data for transfer/appprove");
2039             return (_data._bytesToAddress(4 + 12), _data._bytesToUint256(4 + 32));
2040         }
2041     }
2042 
2043     /// @notice Toggles whether or not a token is loadable or not.
2044     function setTokenLoadable(address _token, bool _loadable) external onlyAdmin {
2045         // Require that the token exists.
2046         require(_tokenInfoMap[_token].available, "token is not available");
2047 
2048         // this sets the loadable flag to the value passed in
2049         _tokenInfoMap[_token].loadable = _loadable;
2050 
2051         emit UpdatedTokenLoadable(msg.sender, _token, _loadable);
2052     }
2053 
2054     /// @notice Toggles whether or not a token is redeemable or not.
2055     function setTokenRedeemable(address _token, bool _redeemable) external onlyAdmin {
2056         // Require that the token exists.
2057         require(_tokenInfoMap[_token].available, "token is not available");
2058 
2059         // this sets the redeemable flag to the value passed in
2060         _tokenInfoMap[_token].redeemable = _redeemable;
2061 
2062         emit UpdatedTokenRedeemable(msg.sender, _token, _redeemable);
2063     }
2064 
2065     /// @notice Update ERC20 token exchange rate.
2066     /// @param _token ERC20 token contract address.
2067     /// @param _rate ERC20 token exchange rate in wei.
2068     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2069     function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyAdminOrOracle {
2070         // Require that the token exists.
2071         require(_tokenInfoMap[_token].available, "token is not available");
2072         // Update the token's rate.
2073         _tokenInfoMap[_token].rate = _rate;
2074         // Update the token's last update timestamp.
2075         _tokenInfoMap[_token].lastUpdate = _updateDate;
2076         // Emit the rate update event.
2077         emit UpdatedTokenRate(msg.sender, _token, _rate);
2078     }
2079 
2080     //// @notice Withdraw tokens from the smart contract to the specified account.
2081     function claim(address payable _to, address _asset, uint _amount) external onlyAdmin {
2082         _safeTransfer(_to, _asset, _amount);
2083         emit Claimed(_to, _asset, _amount);
2084     }
2085 
2086     /// @notice This returns all of the fields for a given token.
2087     /// @param _a is the address of a given token.
2088     /// @return string of the token's symbol.
2089     /// @return uint of the token's magnitude.
2090     /// @return uint of the token's exchange rate to ETH.
2091     /// @return bool whether the token is available.
2092     /// @return bool whether the token is loadable to the TokenCard.
2093     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2094     /// @return uint of the lastUpdated time of the token's exchange rate.
2095     function getTokenInfo(address _a) external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2096         Token storage tokenInfo = _tokenInfoMap[_a];
2097         return (tokenInfo.symbol, tokenInfo.magnitude, tokenInfo.rate, tokenInfo.available, tokenInfo.loadable, tokenInfo.redeemable, tokenInfo.lastUpdate);
2098     }
2099 
2100     /// @notice This returns all of the fields for our StableCoin.
2101     /// @return string of the token's symbol.
2102     /// @return uint of the token's magnitude.
2103     /// @return uint of the token's exchange rate to ETH.
2104     /// @return bool whether the token is available.
2105     /// @return bool whether the token is loadable to the TokenCard.
2106     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2107     /// @return uint of the lastUpdated time of the token's exchange rate.
2108     function getStablecoinInfo() external view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2109         Token storage stablecoinInfo = _tokenInfoMap[_stablecoin];
2110         return (stablecoinInfo.symbol, stablecoinInfo.magnitude, stablecoinInfo.rate, stablecoinInfo.available, stablecoinInfo.loadable, stablecoinInfo.redeemable, stablecoinInfo.lastUpdate);
2111     }
2112 
2113     /// @notice This returns an array of all whitelisted token addresses.
2114     /// @return address[] of whitelisted tokens.
2115     function tokenAddressArray() external view returns (address[] memory) {
2116         return _tokenAddressArray;
2117     }
2118 
2119     /// @notice This returns an array of all redeemable token addresses.
2120     /// @return address[] of redeemable tokens.
2121     function redeemableTokens() external view returns (address[] memory) {
2122         address[] memory redeemableAddresses = new address[](_redeemableCounter);
2123         uint redeemableIndex = 0;
2124         for (uint i = 0; i < _tokenAddressArray.length; i++) {
2125             address token = _tokenAddressArray[i];
2126             if (_tokenInfoMap[token].redeemable){
2127                 redeemableAddresses[redeemableIndex] = token;
2128                 redeemableIndex += 1;
2129             }
2130         }
2131         return redeemableAddresses;
2132     }
2133 
2134 
2135     /// @notice This returns true if a method Id is supported for the specific token.
2136     /// @return true if _methodId is supported in general or just for the specific token.
2137     function isERC20MethodSupported(address _token, bytes4 _methodId) public view returns (bool) {
2138         require(_tokenInfoMap[_token].available, "non-existing token");
2139         return (_methodIdWhitelist[_methodId]);
2140     }
2141 
2142     /// @notice This returns true if the method is supported for all protected tokens.
2143     /// @return true if _methodId is in the method whitelist.
2144     function isERC20MethodWhitelisted(bytes4 _methodId) external view returns (bool) {
2145         return (_methodIdWhitelist[_methodId]);
2146     }
2147 
2148     /// @notice This returns the number of redeemable tokens.
2149     /// @return current # of redeemables.
2150     function redeemableCounter() external view returns (uint) {
2151         return _redeemableCounter;
2152     }
2153 
2154     /// @notice This returns the address of our stablecoin of choice.
2155     /// @return the address of the stablecoin contract.
2156     function stablecoin() external view returns (address) {
2157         return _stablecoin;
2158     }
2159 
2160     /// @notice this returns the node hash of our Oracle.
2161     /// @return the oracle node registered in ENS.
2162     function oracleNode() external view returns (bytes32) {
2163         return _oracleNode;
2164     }
2165 }
2166 
2167 contract TokenWhitelistable is ENSResolvable {
2168 
2169     /// @notice Is the registered ENS node identifying the tokenWhitelist contract
2170     bytes32 private _tokenWhitelistNode;
2171 
2172     /// @notice Constructor initializes the TokenWhitelistable object.
2173     /// @param _tokenWhitelistNode_ is the ENS node of the TokenWhitelist.
2174     constructor(bytes32 _tokenWhitelistNode_) internal {
2175         _tokenWhitelistNode = _tokenWhitelistNode_;
2176     }
2177 
2178     /// @notice This shows what TokenWhitelist is being used
2179     /// @return TokenWhitelist's node registered in ENS.
2180     function tokenWhitelistNode() external view returns (bytes32) {
2181         return _tokenWhitelistNode;
2182     }
2183 
2184     /// @notice This returns all of the fields for a given token.
2185     /// @param _a is the address of a given token.
2186     /// @return string of the token's symbol.
2187     /// @return uint of the token's magnitude.
2188     /// @return uint of the token's exchange rate to ETH.
2189     /// @return bool whether the token is available.
2190     /// @return bool whether the token is loadable to the TokenCard.
2191     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2192     /// @return uint of the lastUpdated time of the token's exchange rate.
2193     function _getTokenInfo(address _a) internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2194         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getTokenInfo(_a);
2195     }
2196 
2197     /// @notice This returns all of the fields for our stablecoin token.
2198     /// @return string of the token's symbol.
2199     /// @return uint of the token's magnitude.
2200     /// @return uint of the token's exchange rate to ETH.
2201     /// @return bool whether the token is available.
2202     /// @return bool whether the token is loadable to the TokenCard.
2203     /// @return bool whether the token is redeemable to the TKN Holder Contract.
2204     /// @return uint of the lastUpdated time of the token's exchange rate.
2205     function _getStablecoinInfo() internal view returns (string memory, uint256, uint256, bool, bool, bool, uint256) {
2206         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getStablecoinInfo();
2207     }
2208 
2209     /// @notice This returns an array of our whitelisted addresses.
2210     /// @return address[] of our whitelisted tokens.
2211     function _tokenAddressArray() internal view returns (address[] memory) {
2212         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).tokenAddressArray();
2213     }
2214 
2215     /// @notice This returns an array of all redeemable token addresses.
2216     /// @return address[] of redeemable tokens.
2217     function _redeemableTokens() internal view returns (address[] memory) {
2218         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).redeemableTokens();
2219     }
2220 
2221     /// @notice Update ERC20 token exchange rate.
2222     /// @param _token ERC20 token contract address.
2223     /// @param _rate ERC20 token exchange rate in wei.
2224     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2225     function _updateTokenRate(address _token, uint _rate, uint _updateDate) internal {
2226         ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).updateTokenRate(_token, _rate, _updateDate);
2227     }
2228 
2229     /// @notice based on the method it returns the recipient address and amount/value, ERC20 specific.
2230     /// @param _data is the transaction payload.
2231     function _getERC20RecipientAndAmount(address _destination, bytes memory _data) internal view returns (address, uint) {
2232         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).getERC20RecipientAndAmount(_destination, _data);
2233     }
2234 
2235     /// @notice Checks whether a token is available.
2236     /// @return bool available or not.
2237     function _isTokenAvailable(address _a) internal view returns (bool) {
2238         ( , , , bool available, , , ) = _getTokenInfo(_a);
2239         return available;
2240     }
2241 
2242     /// @notice Checks whether a token is redeemable.
2243     /// @return bool redeemable or not.
2244     function _isTokenRedeemable(address _a) internal view returns (bool) {
2245         ( , , , , , bool redeemable, ) = _getTokenInfo(_a);
2246         return redeemable;
2247     }
2248 
2249     /// @notice Checks whether a token is loadable.
2250     /// @return bool loadable or not.
2251     function _isTokenLoadable(address _a) internal view returns (bool) {
2252         ( , , , , bool loadable, , ) = _getTokenInfo(_a);
2253         return loadable;
2254     }
2255 
2256     /// @notice This gets the address of the stablecoin.
2257     /// @return the address of the stablecoin contract.
2258     function _stablecoin() internal view returns (address) {
2259         return ITokenWhitelist(_ensResolve(_tokenWhitelistNode)).stablecoin();
2260     }
2261 
2262 }
2263 
2264 contract ControllableOwnable is Controllable, Ownable {
2265     /// @dev Check if the sender is the Owner or one of the Controllers
2266     modifier onlyOwnerOrController() {
2267         require (_isOwner(msg.sender) || _isController(msg.sender), "either owner or controller");
2268         _;
2269     }
2270 }
2271 
2272 
2273 /// @title AddressWhitelist provides payee-whitelist functionality.
2274 /// @dev This contract will allow the user to maintain a whitelist of addresses
2275 /// @dev These addresses will live outside of the various spend limits
2276 contract AddressWhitelist is ControllableOwnable {
2277     using SafeMath for uint256;
2278 
2279     event AddedToWhitelist(address _sender, address[] _addresses);
2280     event SubmittedWhitelistAddition(address[] _addresses, bytes32 _hash);
2281     event CancelledWhitelistAddition(address _sender, bytes32 _hash);
2282 
2283     event RemovedFromWhitelist(address _sender, address[] _addresses);
2284     event SubmittedWhitelistRemoval(address[] _addresses, bytes32 _hash);
2285     event CancelledWhitelistRemoval(address _sender, bytes32 _hash);
2286 
2287     mapping(address => bool) public whitelistMap;
2288     address[] public whitelistArray;
2289     address[] private _pendingWhitelistAddition;
2290     address[] private _pendingWhitelistRemoval;
2291     bool public submittedWhitelistAddition;
2292     bool public submittedWhitelistRemoval;
2293     bool public isSetWhitelist;
2294 
2295     /// @dev Check if the provided addresses contain the owner or the zero-address address.
2296     modifier hasNoOwnerOrZeroAddress(address[] memory _addresses) {
2297         for (uint i = 0; i < _addresses.length; i++) {
2298             require(!_isOwner(_addresses[i]), "provided whitelist contains the owner address");
2299             require(_addresses[i] != address(0), "provided whitelist contains the zero address");
2300         }
2301         _;
2302     }
2303 
2304     /// @dev Check that neither addition nor removal operations have already been submitted.
2305     modifier noActiveSubmission() {
2306         require(!submittedWhitelistAddition && !submittedWhitelistRemoval, "whitelist operation has already been submitted");
2307         _;
2308     }
2309 
2310     /// @dev Getter for pending addition array.
2311     function pendingWhitelistAddition() external view returns (address[] memory) {
2312         return _pendingWhitelistAddition;
2313     }
2314 
2315     /// @dev Getter for pending removal array.
2316     function pendingWhitelistRemoval() external view returns (address[] memory) {
2317         return _pendingWhitelistRemoval;
2318     }
2319 
2320     /// @dev Add initial addresses to the whitelist.
2321     /// @param _addresses are the Ethereum addresses to be whitelisted.
2322     function setWhitelist(address[] calldata _addresses) external onlyOwner hasNoOwnerOrZeroAddress(_addresses) {
2323         // Require that the whitelist has not been initialized.
2324         require(!isSetWhitelist, "whitelist has already been initialized");
2325         // Add each of the provided addresses to the whitelist.
2326         for (uint i = 0; i < _addresses.length; i++) {
2327             // adds to the whitelist mapping
2328             whitelistMap[_addresses[i]] = true;
2329             // adds to the whitelist array
2330             whitelistArray.push(_addresses[i]);
2331         }
2332         isSetWhitelist = true;
2333         // Emit the addition event.
2334         emit AddedToWhitelist(msg.sender, _addresses);
2335     }
2336 
2337     /// @dev Add addresses to the whitelist.
2338     /// @param _addresses are the Ethereum addresses to be whitelisted.
2339     function submitWhitelistAddition(address[] calldata _addresses) external onlyOwner noActiveSubmission hasNoOwnerOrZeroAddress(_addresses) {
2340         // Require that the whitelist has been initialized.
2341         require(isSetWhitelist, "whitelist has not been initialized");
2342         // Require this array of addresses not empty
2343         require(_addresses.length > 0, "pending whitelist addition is empty");
2344         // Set the provided addresses to the pending addition addresses.
2345         _pendingWhitelistAddition = _addresses;
2346         // Flag the operation as submitted.
2347         submittedWhitelistAddition = true;
2348         // Emit the submission event.
2349         emit SubmittedWhitelistAddition(_addresses, calculateHash(_addresses));
2350     }
2351 
2352     /// @dev Confirm pending whitelist addition.
2353     /// @dev This will only ever be applied post 2FA, by one of the Controllers
2354     /// @param _hash is the hash of the pending whitelist array, a form of lamport lock
2355     function confirmWhitelistAddition(bytes32 _hash) external onlyController {
2356         // Require that the whitelist addition has been submitted.
2357         require(submittedWhitelistAddition, "whitelist addition has not been submitted");
2358         // Require that confirmation hash and the hash of the pending whitelist addition match
2359         require(_hash == calculateHash(_pendingWhitelistAddition), "hash of the pending whitelist addition do not match");
2360         // Whitelist pending addresses.
2361         for (uint i = 0; i < _pendingWhitelistAddition.length; i++) {
2362             // check if it doesn't exist already.
2363             if (!whitelistMap[_pendingWhitelistAddition[i]]) {
2364                 // add to the Map and the Array
2365                 whitelistMap[_pendingWhitelistAddition[i]] = true;
2366                 whitelistArray.push(_pendingWhitelistAddition[i]);
2367             }
2368         }
2369         // Emit the addition event.
2370         emit AddedToWhitelist(msg.sender, _pendingWhitelistAddition);
2371         // Reset pending addresses.
2372         delete _pendingWhitelistAddition;
2373         // Reset the submission flag.
2374         submittedWhitelistAddition = false;
2375     }
2376 
2377     /// @dev Cancel pending whitelist addition.
2378     function cancelWhitelistAddition(bytes32 _hash) external onlyOwnerOrController {
2379         // Check if operation has been submitted.
2380         require(submittedWhitelistAddition, "whitelist addition has not been submitted");
2381         // Require that confirmation hash and the hash of the pending whitelist addition match
2382         require(_hash == calculateHash(_pendingWhitelistAddition), "hash of the pending whitelist addition does not match");
2383         // Reset pending addresses.
2384         delete _pendingWhitelistAddition;
2385         // Reset the submitted operation flag.
2386         submittedWhitelistAddition = false;
2387         // Emit the cancellation event.
2388         emit CancelledWhitelistAddition(msg.sender, _hash);
2389     }
2390 
2391     /// @dev Remove addresses from the whitelist.
2392     /// @param _addresses are the Ethereum addresses to be removed.
2393     function submitWhitelistRemoval(address[] calldata _addresses) external onlyOwner noActiveSubmission {
2394         // Require that the whitelist has been initialized.
2395         require(isSetWhitelist, "whitelist has not been initialized");
2396         // Require that the array of addresses is not empty
2397         require(_addresses.length > 0, "pending whitelist removal is empty");
2398         // Add the provided addresses to the pending addition list.
2399         _pendingWhitelistRemoval = _addresses;
2400         // Flag the operation as submitted.
2401         submittedWhitelistRemoval = true;
2402         // Emit the submission event.
2403         emit SubmittedWhitelistRemoval(_addresses, calculateHash(_addresses));
2404     }
2405 
2406     /// @dev Confirm pending removal of whitelisted addresses.
2407     function confirmWhitelistRemoval(bytes32 _hash) external onlyController {
2408         // Require that the pending whitelist is not empty and the operation has been submitted.
2409         require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
2410         // Require that confirmation hash and the hash of the pending whitelist removal match
2411         require(_hash == calculateHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match the confirmed hash");
2412         // Remove pending addresses.
2413         for (uint i = 0; i < _pendingWhitelistRemoval.length; i++) {
2414             // check if it exists
2415             if (whitelistMap[_pendingWhitelistRemoval[i]]) {
2416                 whitelistMap[_pendingWhitelistRemoval[i]] = false;
2417                 for (uint j = 0; j < whitelistArray.length.sub(1); j++) {
2418                     if (whitelistArray[j] == _pendingWhitelistRemoval[i]) {
2419                         whitelistArray[j] = whitelistArray[whitelistArray.length - 1];
2420                         break;
2421                     }
2422                 }
2423                 whitelistArray.length--;
2424             }
2425         }
2426         // Emit the removal event.
2427         emit RemovedFromWhitelist(msg.sender, _pendingWhitelistRemoval);
2428         // Reset pending addresses.
2429         delete _pendingWhitelistRemoval;
2430         // Reset the submission flag.
2431         submittedWhitelistRemoval = false;
2432     }
2433 
2434     /// @dev Cancel pending removal of whitelisted addresses.
2435     function cancelWhitelistRemoval(bytes32 _hash) external onlyOwnerOrController {
2436         // Check if operation has been submitted.
2437         require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
2438         // Require that confirmation hash and the hash of the pending whitelist removal match
2439         require(_hash == calculateHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal do not match");
2440         // Reset pending addresses.
2441         delete _pendingWhitelistRemoval;
2442         // Reset pending addresses.
2443         submittedWhitelistRemoval = false;
2444         // Emit the cancellation event.
2445         emit CancelledWhitelistRemoval(msg.sender, _hash);
2446     }
2447 
2448     /// @dev Method used to hash our whitelist address arrays.
2449     function calculateHash(address[] memory _addresses) public pure returns (bytes32) {
2450         return keccak256(abi.encodePacked(_addresses));
2451     }
2452 }
2453 
2454 /// @title DailyLimitTrait This trait allows for daily limits to be included in other contracts.
2455 /// This contract will allow for a DailyLimit object to be instantiated and used.
2456 library DailyLimitTrait {
2457     using SafeMath for uint256;
2458 
2459     event UpdatedAvailableLimit();
2460 
2461     struct DailyLimit {
2462         uint value;
2463         uint available;
2464         uint limitTimestamp;
2465         uint pending;
2466         bool updateable;
2467     }
2468 
2469     /// @dev Returns the available daily balance - accounts for daily limit reset.
2470     /// @return amount of available to spend within the current day in base units.
2471     function _getAvailableLimit(DailyLimit storage self) internal view returns (uint) {
2472         if (now > self.limitTimestamp.add(24 hours)) {
2473             return self.value;
2474         } else {
2475             return self.available;
2476         }
2477     }
2478 
2479     /// @dev Use up amount within the daily limit. Will fail if amount is larger than daily limit.
2480     function _enforceLimit(DailyLimit storage self, uint _amount) internal {
2481         // Account for the spend limit daily reset.
2482         _updateAvailableLimit(self);
2483         require(self.available >= _amount, "available has to be greater or equal to use amount");
2484         self.available = self.available.sub(_amount);
2485     }
2486 
2487     /// @dev Set the daily limit.
2488     /// @param _amount is the daily limit amount in base units.
2489     function _setLimit(DailyLimit storage self, uint _amount) internal {
2490         // Require that the spend limit has not been set yet.
2491         require(!self.updateable, "daily limit not updateable");
2492         // Modify spend limit based on the provided value.
2493         _modifyLimit(self, _amount);
2494         // Flag the operation as set.
2495         self.updateable = true;
2496     }
2497 
2498     /// @dev Submit a daily limit update, needs to be confirmed.
2499     /// @param _amount is the daily limit amount in base units.
2500     function _submitLimitUpdate(DailyLimit storage self, uint _amount) internal {
2501         // Require that the spend limit has been set.
2502         require(self.updateable, "daily limit is still updateable");
2503         // Assign the provided amount to pending daily limit.
2504         self.pending = _amount;
2505     }
2506 
2507     /// @dev Confirm pending set daily limit operation.
2508     function _confirmLimitUpdate(DailyLimit storage self, uint _amount) internal {
2509         // Require that pending and confirmed spend limit are the same
2510         require(self.pending == _amount, "confirmed and submitted limits dont match");
2511         // Modify spend limit based on the pending value.
2512         _modifyLimit(self, self.pending);
2513     }
2514 
2515     /// @dev Update available spend limit based on the daily reset.
2516     function _updateAvailableLimit(DailyLimit storage self) private {
2517         if (now > self.limitTimestamp.add(24 hours)) {
2518             // Update the current timestamp.
2519             self.limitTimestamp = now;
2520             // Set the available limit to the current spend limit.
2521             self.available = self.value;
2522             emit UpdatedAvailableLimit();
2523         }
2524     }
2525 
2526     /// @dev Modify the spend limit and spend available based on the provided value.
2527     /// @dev _amount is the daily limit amount in wei.
2528     function _modifyLimit(DailyLimit storage self, uint _amount) private {
2529         // Account for the spend limit daily reset.
2530         _updateAvailableLimit(self);
2531         // Set the daily limit to the provided amount.
2532         self.value = _amount;
2533         // Lower the available limit if it's higher than the new daily limit.
2534         if (self.available > self.value) {
2535             self.available = self.value;
2536         }
2537     }
2538 }
2539 
2540 
2541 /// @title  it provides daily spend limit functionality.
2542 contract SpendLimit is ControllableOwnable {
2543     event SetSpendLimit(address _sender, uint _amount);
2544     event SubmittedSpendLimitUpdate(uint _amount);
2545 
2546     using DailyLimitTrait for DailyLimitTrait.DailyLimit;
2547 
2548     DailyLimitTrait.DailyLimit internal _spendLimit;
2549 
2550     /// @dev Constructor initializes the daily spend limit in wei.
2551     constructor(uint _limit_) internal {
2552         _spendLimit = DailyLimitTrait.DailyLimit(_limit_, _limit_, now, 0, false);
2553     }
2554 
2555     /// @dev Sets the initial daily spend (aka transfer) limit for non-whitelisted addresses.
2556     /// @param _amount is the daily limit amount in wei.
2557     function setSpendLimit(uint _amount) external onlyOwner {
2558         _spendLimit._setLimit(_amount);
2559         emit SetSpendLimit(msg.sender, _amount);
2560     }
2561 
2562     /// @dev Submit a daily transfer limit update for non-whitelisted addresses.
2563     /// @param _amount is the daily limit amount in wei.
2564     function submitSpendLimitUpdate(uint _amount) external onlyOwner {
2565         _spendLimit._submitLimitUpdate(_amount);
2566         emit SubmittedSpendLimitUpdate(_amount);
2567     }
2568 
2569     /// @dev Confirm pending set daily limit operation.
2570     function confirmSpendLimitUpdate(uint _amount) external onlyController {
2571         _spendLimit._confirmLimitUpdate(_amount);
2572         emit SetSpendLimit(msg.sender, _amount);
2573     }
2574 
2575     function spendLimitAvailable() external view returns (uint) {
2576         return _spendLimit._getAvailableLimit();
2577     }
2578 
2579     function spendLimitValue() external view returns (uint) {
2580         return _spendLimit.value;
2581     }
2582 
2583     function spendLimitUpdateable() external view returns (bool) {
2584         return _spendLimit.updateable;
2585     }
2586 
2587     function spendLimitPending() external view returns (uint) {
2588         return _spendLimit.pending;
2589     }
2590 }
2591 
2592 
2593 //// @title GasTopUpLimit provides daily limit functionality.
2594 contract GasTopUpLimit is ControllableOwnable {
2595 
2596     event SetGasTopUpLimit(address _sender, uint _amount);
2597     event SubmittedGasTopUpLimitUpdate(uint _amount);
2598 
2599     uint constant private _MINIMUM_GAS_TOPUP_LIMIT = 1 finney;
2600     uint constant private _MAXIMUM_GAS_TOPUP_LIMIT = 500 finney;
2601 
2602     using DailyLimitTrait for DailyLimitTrait.DailyLimit;
2603 
2604     DailyLimitTrait.DailyLimit internal _gasTopUpLimit;
2605 
2606     /// @dev Constructor initializes the daily gas topup limit in wei.
2607     constructor() internal {
2608         _gasTopUpLimit = DailyLimitTrait.DailyLimit(_MAXIMUM_GAS_TOPUP_LIMIT, _MAXIMUM_GAS_TOPUP_LIMIT, now, 0, false);
2609     }
2610 
2611     /// @dev Sets the daily gas top up limit.
2612     /// @param _amount is the gas top up amount in wei.
2613     function setGasTopUpLimit(uint _amount) external onlyOwner {
2614         require(_MINIMUM_GAS_TOPUP_LIMIT <= _amount && _amount <= _MAXIMUM_GAS_TOPUP_LIMIT, "gas top up amount is outside the min/max range");
2615         _gasTopUpLimit._setLimit(_amount);
2616         emit SetGasTopUpLimit(msg.sender, _amount);
2617     }
2618 
2619     /// @dev Submit a daily gas top up limit update.
2620     /// @param _amount is the daily top up gas limit amount in wei.
2621     function submitGasTopUpLimitUpdate(uint _amount) external onlyOwner {
2622         require(_MINIMUM_GAS_TOPUP_LIMIT <= _amount && _amount <= _MAXIMUM_GAS_TOPUP_LIMIT, "gas top up amount is outside the min/max range");
2623         _gasTopUpLimit._submitLimitUpdate(_amount);
2624         emit SubmittedGasTopUpLimitUpdate(_amount);
2625     }
2626 
2627     /// @dev Confirm pending set top up gas limit operation.
2628     function confirmGasTopUpLimitUpdate(uint _amount) external onlyController {
2629         _gasTopUpLimit._confirmLimitUpdate(_amount);
2630         emit SetGasTopUpLimit(msg.sender, _amount);
2631     }
2632 
2633     function gasTopUpLimitAvailable() external view returns (uint) {
2634         return _gasTopUpLimit._getAvailableLimit();
2635     }
2636 
2637     function gasTopUpLimitValue() external view returns (uint) {
2638         return _gasTopUpLimit.value;
2639     }
2640 
2641     function gasTopUpLimitUpdateable() external view returns (bool) {
2642         return _gasTopUpLimit.updateable;
2643     }
2644 
2645     function gasTopUpLimitPending() external view returns (uint) {
2646         return _gasTopUpLimit.pending;
2647     }
2648 }
2649 
2650 
2651 /// @title LoadLimit provides daily load limit functionality.
2652 contract LoadLimit is ControllableOwnable {
2653 
2654     event SetLoadLimit(address _sender, uint _amount);
2655     event SubmittedLoadLimitUpdate(uint _amount);
2656 
2657     uint constant private _MINIMUM_LOAD_LIMIT = 1 finney;
2658     uint private _maximumLoadLimit;
2659 
2660     using DailyLimitTrait for DailyLimitTrait.DailyLimit;
2661 
2662     DailyLimitTrait.DailyLimit internal _loadLimit;
2663 
2664     /// @dev Sets a daily card load limit.
2665     /// @param _amount is the card load amount in current stablecoin base units.
2666     function setLoadLimit(uint _amount) external onlyOwner {
2667         require(_MINIMUM_LOAD_LIMIT <= _amount && _amount <= _maximumLoadLimit, "card load amount is outside the min/max range");
2668         _loadLimit._setLimit(_amount);
2669         emit SetLoadLimit(msg.sender, _amount);
2670     }
2671 
2672     /// @dev Submit a daily load limit update.
2673     /// @param _amount is the daily load limit amount in wei.
2674     function submitLoadLimitUpdate(uint _amount) external onlyOwner {
2675         require(_MINIMUM_LOAD_LIMIT <= _amount && _amount <= _maximumLoadLimit, "card load amount is outside the min/max range");
2676         _loadLimit._submitLimitUpdate(_amount);
2677         emit SubmittedLoadLimitUpdate(_amount);
2678     }
2679 
2680     /// @dev Confirm pending set load limit operation.
2681     function confirmLoadLimitUpdate(uint _amount) external onlyController {
2682         _loadLimit._confirmLimitUpdate(_amount);
2683         emit SetLoadLimit(msg.sender, _amount);
2684     }
2685 
2686     function loadLimitAvailable() external view returns (uint) {
2687         return _loadLimit._getAvailableLimit();
2688     }
2689 
2690     function loadLimitValue() external view returns (uint) {
2691         return _loadLimit.value;
2692     }
2693 
2694     function loadLimitUpdateable() external view returns (bool) {
2695         return _loadLimit.updateable;
2696     }
2697 
2698     function loadLimitPending() external view returns (uint) {
2699         return _loadLimit.pending;
2700     }
2701 
2702     /// @dev initializes the daily load limit.
2703     /// @param _maxLimit is the maximum load limit amount in stablecoin base units.
2704     function _initializeLoadLimit(uint _maxLimit) internal {
2705         _maximumLoadLimit = _maxLimit;
2706         _loadLimit = DailyLimitTrait.DailyLimit(_maximumLoadLimit, _maximumLoadLimit, now, 0, false);
2707     }
2708 }
2709 
2710 
2711 //// @title Asset store with extra security features.
2712 contract Vault is AddressWhitelist, SpendLimit, ERC165, Transferrable, Balanceable, TokenWhitelistable {
2713 
2714     using SafeMath for uint256;
2715     using SafeERC20 for ERC20;
2716 
2717     event Received(address _from, uint _amount);
2718     event Transferred(address _to, address _asset, uint _amount);
2719     event BulkTransferred(address _to, address[] _assets);
2720 
2721     /// @dev Supported ERC165 interface ID.
2722     bytes4 private constant _ERC165_INTERFACE_ID = 0x01ffc9a7; // solium-disable-line uppercase
2723 
2724     /// @dev Constructor initializes the vault with an owner address and spend limit. It also sets up the controllable and tokenWhitelist contracts with the right name registered in ENS.
2725     /// @param _owner_ is the owner account of the wallet contract.
2726     /// @param _transferable_ indicates whether the contract ownership can be transferred.
2727     /// @param _tokenWhitelistNode_ is the ENS node of the Token whitelist.
2728     /// @param _controllerNode_ is the ENS name node of the controller.
2729     /// @param _spendLimit_ is the initial spend limit.
2730     constructor(address payable _owner_, bool _transferable_, bytes32 _tokenWhitelistNode_, bytes32 _controllerNode_, uint _spendLimit_) SpendLimit(_spendLimit_) Ownable(_owner_, _transferable_) Controllable(_controllerNode_) TokenWhitelistable(_tokenWhitelistNode_) public {}
2731 
2732     /// @dev Checks if the value is not zero.
2733     modifier isNotZero(uint _value) {
2734         require(_value != 0, "provided value cannot be zero");
2735         _;
2736     }
2737 
2738     /// @dev Ether can be deposited from any source, so this contract must be payable by anyone.
2739     function() external payable {
2740         emit Received(msg.sender, msg.value);
2741     }
2742 
2743     /// @dev Checks for interface support based on ERC165.
2744     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
2745         return _interfaceID == _ERC165_INTERFACE_ID;
2746     }
2747 
2748     /// @dev This is a bulk transfer convenience function, used to migrate contracts.
2749     /// @notice If any of the transfers fail, this will revert.
2750     /// @param _to is the recipient's address, can't be the zero (0x0) address: transfer() will revert.
2751     /// @param _assets is an array of addresses of ERC20 tokens or 0x0 for ether.
2752     function bulkTransfer(address payable _to, address[] calldata _assets) external onlyOwner {
2753         // check to make sure that _assets isn't empty
2754         require(_assets.length != 0, "asset array should be non-empty");
2755         // This loops through all of the transfers to be made
2756         for (uint i = 0; i < _assets.length; i++) {
2757             uint amount = _balance(address(this), _assets[i]);
2758             // use our safe, daily limit protected transfer
2759             transfer(_to, _assets[i], amount);
2760         }
2761 
2762         emit BulkTransferred(_to, _assets);
2763     }
2764 
2765     /// @dev Transfers the specified asset to the recipient's address.
2766     /// @param _to is the recipient's address.
2767     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
2768     /// @param _amount is the amount of assets to be transferred in base units.
2769     function transfer(address payable _to, address _asset, uint _amount) public onlyOwner isNotZero(_amount) {
2770         // Checks if the _to address is not the zero-address
2771         require(_to != address(0), "_to address cannot be set to 0x0");
2772 
2773         // If address is not whitelisted, take daily limit into account.
2774         if (!whitelistMap[_to]) {
2775             // initialize ether value in case the asset is ETH
2776             uint etherValue = _amount;
2777             // Convert token amount to ether value if asset is an ERC20 token.
2778             if (_asset != address(0)) {
2779                 etherValue = convertToEther(_asset, _amount);
2780             }
2781             // Check against the daily spent limit and update accordingly
2782             // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
2783             _spendLimit._enforceLimit(etherValue);
2784         }
2785         // Transfer token or ether based on the provided address.
2786         _safeTransfer(_to, _asset, _amount);
2787         // Emit the transfer event.
2788         emit Transferred(_to, _asset, _amount);
2789     }
2790 
2791     /// @dev Convert ERC20 token amount to the corresponding ether amount.
2792     /// @param _token ERC20 token contract address.
2793     /// @param _amount amount of token in base units.
2794     function convertToEther(address _token, uint _amount) public view returns (uint) {
2795         // Store the token in memory to save map entry lookup gas.
2796         (,uint256 magnitude, uint256 rate, bool available, , , ) = _getTokenInfo(_token);
2797         // If the token exists require that its rate is not zero.
2798         if (available) {
2799             require(rate != 0, "token rate is 0");
2800             // Safely convert the token amount to ether based on the exchange rate.
2801             return _amount.mul(rate).div(magnitude);
2802         }
2803         return 0;
2804     }
2805 }
2806 
2807 
2808 //// @title Asset wallet with extra security features, gas top up management and card integration.
2809 contract Wallet is ENSResolvable, Vault, GasTopUpLimit, LoadLimit {
2810 
2811     using SafeERC20 for ERC20;
2812     using Address for address;
2813 
2814     event ToppedUpGas(address _sender, address _owner, uint _amount);
2815     event LoadedTokenCard(address _asset, uint _amount);
2816     event ExecutedTransaction(address _destination, uint _value, bytes _data, bytes _returndata);
2817     event UpdatedAvailableLimit();
2818 
2819     string constant public WALLET_VERSION = "2.2.0";
2820     uint constant private _DEFAULT_MAX_STABLECOIN_LOAD_LIMIT = 10000; //10,000 USD
2821 
2822     /// @dev Is the registered ENS node identifying the licence contract.
2823     bytes32 private _licenceNode;
2824 
2825     /// @dev Constructor initializes the wallet top up limit and the vault contract.
2826     /// @param _owner_ is the owner account of the wallet contract.
2827     /// @param _transferable_ indicates whether the contract ownership can be transferred.
2828     /// @param _ens_ is the address of the ENS registry.
2829     /// @param _tokenWhitelistNode_ is the ENS name node of the Token whitelist.
2830     /// @param _controllerNode_ is the ENS name node of the Controller contract.
2831     /// @param _licenceNode_ is the ENS name node of the Licence contract.
2832     /// @param _spendLimit_ is the initial spend limit.
2833     constructor(address payable _owner_, bool _transferable_, address _ens_, bytes32 _tokenWhitelistNode_, bytes32 _controllerNode_, bytes32 _licenceNode_, uint _spendLimit_) ENSResolvable(_ens_) Vault(_owner_, _transferable_, _tokenWhitelistNode_, _controllerNode_, _spendLimit_) public {
2834         // Get the stablecoin's magnitude.
2835         ( ,uint256 stablecoinMagnitude, , , , , ) = _getStablecoinInfo();
2836         require(stablecoinMagnitude > 0, "stablecoin not set");
2837         _initializeLoadLimit(_DEFAULT_MAX_STABLECOIN_LOAD_LIMIT * stablecoinMagnitude);
2838         _licenceNode = _licenceNode_;
2839     }
2840 
2841     /// @dev Refill owner's gas balance, revert if the transaction amount is too large
2842     /// @param _amount is the amount of ether to transfer to the owner account in wei.
2843     function topUpGas(uint _amount) external isNotZero(_amount) onlyOwnerOrController {
2844         // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
2845         _gasTopUpLimit._enforceLimit(_amount);
2846         // Then perform the transfer
2847         owner().transfer(_amount);
2848         // Emit the gas top up event.
2849         emit ToppedUpGas(msg.sender, owner(), _amount);
2850     }
2851 
2852     /// @dev Load a token card with the specified asset amount.
2853     /// @dev the amount send should be inclusive of the percent licence.
2854     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
2855     /// @param _amount is the amount of assets to be transferred in base units.
2856     function loadTokenCard(address _asset, uint _amount) external payable onlyOwner {
2857         // check if token is allowed to be used for loading the card
2858         require(_isTokenLoadable(_asset), "token not loadable");
2859         // Convert token amount to stablecoin value.
2860         uint stablecoinValue = convertToStablecoin(_asset, _amount);
2861         // Check against the daily spent limit and update accordingly, require that the value is under remaining limit.
2862         _loadLimit._enforceLimit(stablecoinValue);
2863         // Get the TKN licenceAddress from ENS
2864         address licenceAddress = _ensResolve(_licenceNode);
2865         if (_asset != address(0)) {
2866             ERC20(_asset).safeApprove(licenceAddress, _amount);
2867             ILicence(licenceAddress).load(_asset, _amount);
2868         } else {
2869             ILicence(licenceAddress).load.value(_amount)(_asset, _amount);
2870         }
2871 
2872         emit LoadedTokenCard(_asset, _amount);
2873 
2874     }
2875 
2876     /// @dev This function allows for the owner to send transaction from the Wallet to arbitrary addresses
2877     /// @param _destination address of the transaction
2878     /// @param _value ETH amount in wei
2879     /// @param _data transaction payload binary
2880     function executeTransaction(address _destination, uint _value, bytes calldata _data) external onlyOwner returns (bytes memory) {
2881         // If value is send across as a part of this executeTransaction, this will be sent to any payable
2882         // destination. As a result enforceLimit if destination is not whitelisted.
2883         if (!whitelistMap[_destination]) {
2884             _spendLimit._enforceLimit(_value);
2885         }
2886         // Check if the destination is a Contract and it is one of our supported tokens
2887         if (address(_destination).isContract() && _isTokenAvailable(_destination)) {
2888             // to is the recipient's address and amount is the value to be transferred
2889             address to;
2890             uint amount;
2891             (to, amount) = _getERC20RecipientAndAmount(_destination, _data);
2892             if (!whitelistMap[to]) {
2893                 // If the address (of the token contract, e.g) is not in the TokenWhitelist used by the convert method...
2894                 // ...then etherValue will be zero
2895                 uint etherValue = convertToEther(_destination, amount);
2896                 _spendLimit._enforceLimit(etherValue);
2897             }
2898             // use callOptionalReturn provided in SafeERC20 in case the ERC20 method
2899             // returns flase instead of reverting!
2900             ERC20(_destination).callOptionalReturn(_data);
2901 
2902             // if ERC20 call completes, return a boolean "true" as bytes emulating ERC20
2903             bytes memory b = new bytes(32);
2904             b[31] = 0x01;
2905 
2906             emit ExecutedTransaction(_destination, _value, _data, b);
2907             return b;
2908         }
2909 
2910         (bool success, bytes memory returndata) = _destination.call.value(_value)(_data);
2911         require(success, "low-level call failed");
2912 
2913         emit ExecutedTransaction(_destination, _value, _data, returndata);
2914         // returns all of the bytes returned by _destination contract
2915         return returndata;
2916     }
2917 
2918     /// @return licence contract node registered in ENS.
2919     function licenceNode() external view returns (bytes32) {
2920         return _licenceNode;
2921     }
2922 
2923     /// @dev Convert ether or ERC20 token amount to the corresponding stablecoin amount.
2924     /// @param _token ERC20 token contract address.
2925     /// @param _amount amount of token in base units.
2926     function convertToStablecoin(address _token, uint _amount) public view returns (uint) {
2927         // avoid the unnecessary calculations if the token to be loaded is the stablecoin itself
2928         if (_token == _stablecoin()) {
2929             return _amount;
2930         }
2931         uint amountToSend = _amount;
2932 
2933         // 0x0 represents ether
2934         if (_token != address(0)) {
2935             // convert to eth first, same as convertToEther()
2936             // Store the token in memory to save map entry lookup gas.
2937             (,uint256 magnitude, uint256 rate, bool available, , , ) = _getTokenInfo(_token);
2938             // require that token both exists in the whitelist and its rate is not zero.
2939             require(available, "token is not available");
2940             require(rate != 0, "token rate is 0");
2941             // Safely convert the token amount to ether based on the exchange rate.
2942             amountToSend = _amount.mul(rate).div(magnitude);
2943         }
2944         // _amountToSend now is in ether
2945         // Get the stablecoin's magnitude and its current rate.
2946         ( ,uint256 stablecoinMagnitude, uint256 stablecoinRate, bool stablecoinAvailable, , , ) = _getStablecoinInfo();
2947         // Check if the stablecoin rate is set.
2948         require(stablecoinAvailable, "token is not available");
2949         require(stablecoinRate != 0, "stablecoin rate is 0");
2950         // Safely convert the token amount to stablecoin based on its exchange rate and the stablecoin exchange rate.
2951         return amountToSend.mul(stablecoinMagnitude).div(stablecoinRate);
2952     }
2953 
2954 }