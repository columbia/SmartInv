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
60 
61 
62 /// @title AddressSet
63 /// @author Daniel Wang - <daniel@loopring.org>
64 contract AddressSet
65 {
66     struct Set
67     {
68         address[] addresses;
69         mapping (address => uint) positions;
70         uint count;
71     }
72     mapping (bytes32 => Set) private sets;
73 
74     function addAddressToSet(
75         bytes32 key,
76         address addr,
77         bool    maintainList
78         ) internal
79     {
80         Set storage set = sets[key];
81         require(set.positions[addr] == 0, "ALREADY_IN_SET");
82 
83         if (maintainList) {
84             require(set.addresses.length == set.count, "PREVIOUSLY_NOT_MAINTAILED");
85             set.addresses.push(addr);
86         } else {
87             require(set.addresses.length == 0, "MUST_MAINTAIN");
88         }
89 
90         set.count += 1;
91         set.positions[addr] = set.count;
92     }
93 
94     function removeAddressFromSet(
95         bytes32 key,
96         address addr
97         )
98         internal
99     {
100         Set storage set = sets[key];
101         uint pos = set.positions[addr];
102         require(pos != 0, "NOT_IN_SET");
103 
104         delete set.positions[addr];
105         set.count -= 1;
106 
107         if (set.addresses.length > 0) {
108             address lastAddr = set.addresses[set.count];
109             if (lastAddr != addr) {
110                 set.addresses[pos - 1] = lastAddr;
111                 set.positions[lastAddr] = pos;
112             }
113             set.addresses.pop();
114         }
115     }
116 
117     function removeSet(bytes32 key)
118         internal
119     {
120         delete sets[key];
121     }
122 
123     function isAddressInSet(
124         bytes32 key,
125         address addr
126         )
127         internal
128         view
129         returns (bool)
130     {
131         return sets[key].positions[addr] != 0;
132     }
133 
134     function numAddressesInSet(bytes32 key)
135         internal
136         view
137         returns (uint)
138     {
139         Set storage set = sets[key];
140         return set.count;
141     }
142 
143     function addressesInSet(bytes32 key)
144         internal
145         view
146         returns (address[] memory)
147     {
148         Set storage set = sets[key];
149         require(set.count == set.addresses.length, "NOT_MAINTAINED");
150         return sets[key].addresses;
151     }
152 }
153 /*
154  * @title String & slice utility library for Solidity contracts.
155  * @author Nick Johnson <arachnid@notdot.net>
156  *
157  * @dev Functionality in this library is largely implemented using an
158  *      abstraction called a 'slice'. A slice represents a part of a string -
159  *      anything from the entire string to a single character, or even no
160  *      characters at all (a 0-length slice). Since a slice only has to specify
161  *      an offset and a length, copying and manipulating slices is a lot less
162  *      expensive than copying and manipulating the strings they reference.
163  *
164  *      To further reduce gas costs, most functions on slice that need to return
165  *      a slice modify the original one instead of allocating a new one; for
166  *      instance, `s.split(".")` will return the text up to the first '.',
167  *      modifying s to only contain the remainder of the string after the '.'.
168  *      In situations where you do not want to modify the original slice, you
169  *      can make a copy first with `.copy()`, for example:
170  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
171  *      Solidity has no memory management, it will result in allocating many
172  *      short-lived slices that are later discarded.
173  *
174  *      Functions that return two slices come in two versions: a non-allocating
175  *      version that takes the second slice as an argument, modifying it in
176  *      place, and an allocating version that allocates and returns the second
177  *      slice; see `nextRune` for example.
178  *
179  *      Functions that have to copy string data will return strings rather than
180  *      slices; these can be cast back to slices for further processing if
181  *      required.
182  *
183  *      For convenience, some functions are provided with non-modifying
184  *      variants that create a new slice and return both; for instance,
185  *      `s.splitNew('.')` leaves s unmodified, and returns two values
186  *      corresponding to the left and right parts of the string.
187  */
188 
189 
190 
191 /* solium-disable */
192 library strings {
193     struct slice {
194         uint _len;
195         uint _ptr;
196     }
197 
198     function memcpy(uint dest, uint src, uint len) private pure {
199         // Copy word-length chunks while possible
200         for(; len >= 32; len -= 32) {
201             assembly {
202                 mstore(dest, mload(src))
203             }
204             dest += 32;
205             src += 32;
206         }
207 
208         // Copy remaining bytes
209         uint mask = 256 ** (32 - len) - 1;
210         assembly {
211             let srcpart := and(mload(src), not(mask))
212             let destpart := and(mload(dest), mask)
213             mstore(dest, or(destpart, srcpart))
214         }
215     }
216 
217     /*
218      * @dev Returns a slice containing the entire string.
219      * @param self The string to make a slice from.
220      * @return A newly allocated slice containing the entire string.
221      */
222     function toSlice(string memory self) internal pure returns (slice memory) {
223         uint ptr;
224         assembly {
225             ptr := add(self, 0x20)
226         }
227         return slice(bytes(self).length, ptr);
228     }
229 
230     /*
231      * @dev Returns the length of a null-terminated bytes32 string.
232      * @param self The value to find the length of.
233      * @return The length of the string, from 0 to 32.
234      */
235     function len(bytes32 self) internal pure returns (uint) {
236         uint ret;
237         if (self == 0)
238             return 0;
239         if (uint256(self) & 0xffffffffffffffffffffffffffffffff == 0) {
240             ret += 16;
241             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
242         }
243         if (uint256(self) & 0xffffffffffffffff == 0) {
244             ret += 8;
245             self = bytes32(uint(self) / 0x10000000000000000);
246         }
247         if (uint256(self) & 0xffffffff == 0) {
248             ret += 4;
249             self = bytes32(uint(self) / 0x100000000);
250         }
251         if (uint256(self) & 0xffff == 0) {
252             ret += 2;
253             self = bytes32(uint(self) / 0x10000);
254         }
255         if (uint256(self) & 0xff == 0) {
256             ret += 1;
257         }
258         return 32 - ret;
259     }
260 
261     /*
262      * @dev Returns a slice containing the entire bytes32, interpreted as a
263      *      null-terminated utf-8 string.
264      * @param self The bytes32 value to convert to a slice.
265      * @return A new slice containing the value of the input argument up to the
266      *         first null.
267      */
268     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
269         // Allocate space for `self` in memory, copy it there, and point ret at it
270         assembly {
271             let ptr := mload(0x40)
272             mstore(0x40, add(ptr, 0x20))
273             mstore(ptr, self)
274             mstore(add(ret, 0x20), ptr)
275         }
276         ret._len = len(self);
277     }
278 
279     /*
280      * @dev Returns a new slice containing the same data as the current slice.
281      * @param self The slice to copy.
282      * @return A new slice containing the same data as `self`.
283      */
284     function copy(slice memory self) internal pure returns (slice memory) {
285         return slice(self._len, self._ptr);
286     }
287 
288     /*
289      * @dev Copies a slice to a new string.
290      * @param self The slice to copy.
291      * @return A newly allocated string containing the slice's text.
292      */
293     function toString(slice memory self) internal pure returns (string memory) {
294         string memory ret = new string(self._len);
295         uint retptr;
296         assembly { retptr := add(ret, 32) }
297 
298         memcpy(retptr, self._ptr, self._len);
299         return ret;
300     }
301 
302     /*
303      * @dev Returns the length in runes of the slice. Note that this operation
304      *      takes time proportional to the length of the slice; avoid using it
305      *      in loops, and call `slice.empty()` if you only need to kblock.timestamp whether
306      *      the slice is empty or not.
307      * @param self The slice to operate on.
308      * @return The length of the slice in runes.
309      */
310     function len(slice memory self) internal pure returns (uint l) {
311         // Starting at ptr-31 means the LSB will be the byte we care about
312         uint ptr = self._ptr - 31;
313         uint end = ptr + self._len;
314         for (l = 0; ptr < end; l++) {
315             uint8 b;
316             assembly { b := and(mload(ptr), 0xFF) }
317             if (b < 0x80) {
318                 ptr += 1;
319             } else if(b < 0xE0) {
320                 ptr += 2;
321             } else if(b < 0xF0) {
322                 ptr += 3;
323             } else if(b < 0xF8) {
324                 ptr += 4;
325             } else if(b < 0xFC) {
326                 ptr += 5;
327             } else {
328                 ptr += 6;
329             }
330         }
331     }
332 
333     /*
334      * @dev Returns true if the slice is empty (has a length of 0).
335      * @param self The slice to operate on.
336      * @return True if the slice is empty, False otherwise.
337      */
338     function empty(slice memory self) internal pure returns (bool) {
339         return self._len == 0;
340     }
341 
342     /*
343      * @dev Returns a positive number if `other` comes lexicographically after
344      *      `self`, a negative number if it comes before, or zero if the
345      *      contents of the two slices are equal. Comparison is done per-rune,
346      *      on unicode codepoints.
347      * @param self The first slice to compare.
348      * @param other The second slice to compare.
349      * @return The result of the comparison.
350      */
351     function compare(slice memory self, slice memory other) internal pure returns (int) {
352         uint shortest = self._len;
353         if (other._len < self._len)
354             shortest = other._len;
355 
356         uint selfptr = self._ptr;
357         uint otherptr = other._ptr;
358         for (uint idx = 0; idx < shortest; idx += 32) {
359             uint a;
360             uint b;
361             assembly {
362                 a := mload(selfptr)
363                 b := mload(otherptr)
364             }
365             if (a != b) {
366                 // Mask out irrelevant bytes and check again
367                 uint256 mask = uint256(-1); // 0xffff...
368                 if(shortest < 32) {
369                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
370                 }
371                 uint256 diff = (a & mask) - (b & mask);
372                 if (diff != 0)
373                     return int(diff);
374             }
375             selfptr += 32;
376             otherptr += 32;
377         }
378         return int(self._len) - int(other._len);
379     }
380 
381     /*
382      * @dev Returns true if the two slices contain the same text.
383      * @param self The first slice to compare.
384      * @param self The second slice to compare.
385      * @return True if the slices are equal, false otherwise.
386      */
387     function equals(slice memory self, slice memory other) internal pure returns (bool) {
388         return compare(self, other) == 0;
389     }
390 
391     /*
392      * @dev Extracts the first rune in the slice into `rune`, advancing the
393      *      slice to point to the next rune and returning `self`.
394      * @param self The slice to operate on.
395      * @param rune The slice that will contain the first rune.
396      * @return `rune`.
397      */
398     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
399         rune._ptr = self._ptr;
400 
401         if (self._len == 0) {
402             rune._len = 0;
403             return rune;
404         }
405 
406         uint l;
407         uint b;
408         // Load the first byte of the rune into the LSBs of b
409         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
410         if (b < 0x80) {
411             l = 1;
412         } else if(b < 0xE0) {
413             l = 2;
414         } else if(b < 0xF0) {
415             l = 3;
416         } else {
417             l = 4;
418         }
419 
420         // Check for truncated codepoints
421         if (l > self._len) {
422             rune._len = self._len;
423             self._ptr += self._len;
424             self._len = 0;
425             return rune;
426         }
427 
428         self._ptr += l;
429         self._len -= l;
430         rune._len = l;
431         return rune;
432     }
433 
434     /*
435      * @dev Returns the first rune in the slice, advancing the slice to point
436      *      to the next rune.
437      * @param self The slice to operate on.
438      * @return A slice containing only the first rune from `self`.
439      */
440     function nextRune(slice memory self) internal pure returns (slice memory ret) {
441         nextRune(self, ret);
442     }
443 
444     /*
445      * @dev Returns the number of the first codepoint in the slice.
446      * @param self The slice to operate on.
447      * @return The number of the first codepoint in the slice.
448      */
449     function ord(slice memory self) internal pure returns (uint ret) {
450         if (self._len == 0) {
451             return 0;
452         }
453 
454         uint word;
455         uint length;
456         uint divisor = 2 ** 248;
457 
458         // Load the rune into the MSBs of b
459         assembly { word:= mload(mload(add(self, 32))) }
460         uint b = word / divisor;
461         if (b < 0x80) {
462             ret = b;
463             length = 1;
464         } else if(b < 0xE0) {
465             ret = b & 0x1F;
466             length = 2;
467         } else if(b < 0xF0) {
468             ret = b & 0x0F;
469             length = 3;
470         } else {
471             ret = b & 0x07;
472             length = 4;
473         }
474 
475         // Check for truncated codepoints
476         if (length > self._len) {
477             return 0;
478         }
479 
480         for (uint i = 1; i < length; i++) {
481             divisor = divisor / 256;
482             b = (word / divisor) & 0xFF;
483             if (b & 0xC0 != 0x80) {
484                 // Invalid UTF-8 sequence
485                 return 0;
486             }
487             ret = (ret * 64) | (b & 0x3F);
488         }
489 
490         return ret;
491     }
492 
493     /*
494      * @dev Returns the keccak-256 hash of the slice.
495      * @param self The slice to hash.
496      * @return The hash of the slice.
497      */
498     function keccak(slice memory self) internal pure returns (bytes32 ret) {
499         assembly {
500             ret := keccak256(mload(add(self, 32)), mload(self))
501         }
502     }
503 
504     /*
505      * @dev Returns true if `self` starts with `needle`.
506      * @param self The slice to operate on.
507      * @param needle The slice to search for.
508      * @return True if the slice starts with the provided text, false otherwise.
509      */
510     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
511         if (self._len < needle._len) {
512             return false;
513         }
514 
515         if (self._ptr == needle._ptr) {
516             return true;
517         }
518 
519         bool equal;
520         assembly {
521             let length := mload(needle)
522             let selfptr := mload(add(self, 0x20))
523             let needleptr := mload(add(needle, 0x20))
524             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
525         }
526         return equal;
527     }
528 
529     /*
530      * @dev If `self` starts with `needle`, `needle` is removed from the
531      *      beginning of `self`. Otherwise, `self` is unmodified.
532      * @param self The slice to operate on.
533      * @param needle The slice to search for.
534      * @return `self`
535      */
536     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
537         if (self._len < needle._len) {
538             return self;
539         }
540 
541         bool equal = true;
542         if (self._ptr != needle._ptr) {
543             assembly {
544                 let length := mload(needle)
545                 let selfptr := mload(add(self, 0x20))
546                 let needleptr := mload(add(needle, 0x20))
547                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
548             }
549         }
550 
551         if (equal) {
552             self._len -= needle._len;
553             self._ptr += needle._len;
554         }
555 
556         return self;
557     }
558 
559     /*
560      * @dev Returns true if the slice ends with `needle`.
561      * @param self The slice to operate on.
562      * @param needle The slice to search for.
563      * @return True if the slice starts with the provided text, false otherwise.
564      */
565     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
566         if (self._len < needle._len) {
567             return false;
568         }
569 
570         uint selfptr = self._ptr + self._len - needle._len;
571 
572         if (selfptr == needle._ptr) {
573             return true;
574         }
575 
576         bool equal;
577         assembly {
578             let length := mload(needle)
579             let needleptr := mload(add(needle, 0x20))
580             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
581         }
582 
583         return equal;
584     }
585 
586     /*
587      * @dev If `self` ends with `needle`, `needle` is removed from the
588      *      end of `self`. Otherwise, `self` is unmodified.
589      * @param self The slice to operate on.
590      * @param needle The slice to search for.
591      * @return `self`
592      */
593     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
594         if (self._len < needle._len) {
595             return self;
596         }
597 
598         uint selfptr = self._ptr + self._len - needle._len;
599         bool equal = true;
600         if (selfptr != needle._ptr) {
601             assembly {
602                 let length := mload(needle)
603                 let needleptr := mload(add(needle, 0x20))
604                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
605             }
606         }
607 
608         if (equal) {
609             self._len -= needle._len;
610         }
611 
612         return self;
613     }
614 
615     // Returns the memory address of the first byte of the first occurrence of
616     // `needle` in `self`, or the first byte after `self` if not found.
617     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
618         uint ptr = selfptr;
619         uint idx;
620 
621         if (needlelen <= selflen) {
622             if (needlelen <= 32) {
623                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
624 
625                 bytes32 needledata;
626                 assembly { needledata := and(mload(needleptr), mask) }
627 
628                 uint end = selfptr + selflen - needlelen;
629                 bytes32 ptrdata;
630                 assembly { ptrdata := and(mload(ptr), mask) }
631 
632                 while (ptrdata != needledata) {
633                     if (ptr >= end)
634                         return selfptr + selflen;
635                     ptr++;
636                     assembly { ptrdata := and(mload(ptr), mask) }
637                 }
638                 return ptr;
639             } else {
640                 // For long needles, use hashing
641                 bytes32 hash;
642                 assembly { hash := keccak256(needleptr, needlelen) }
643 
644                 for (idx = 0; idx <= selflen - needlelen; idx++) {
645                     bytes32 testHash;
646                     assembly { testHash := keccak256(ptr, needlelen) }
647                     if (hash == testHash)
648                         return ptr;
649                     ptr += 1;
650                 }
651             }
652         }
653         return selfptr + selflen;
654     }
655 
656     // Returns the memory address of the first byte after the last occurrence of
657     // `needle` in `self`, or the address of `self` if not found.
658     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
659         uint ptr;
660 
661         if (needlelen <= selflen) {
662             if (needlelen <= 32) {
663                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
664 
665                 bytes32 needledata;
666                 assembly { needledata := and(mload(needleptr), mask) }
667 
668                 ptr = selfptr + selflen - needlelen;
669                 bytes32 ptrdata;
670                 assembly { ptrdata := and(mload(ptr), mask) }
671 
672                 while (ptrdata != needledata) {
673                     if (ptr <= selfptr)
674                         return selfptr;
675                     ptr--;
676                     assembly { ptrdata := and(mload(ptr), mask) }
677                 }
678                 return ptr + needlelen;
679             } else {
680                 // For long needles, use hashing
681                 bytes32 hash;
682                 assembly { hash := keccak256(needleptr, needlelen) }
683                 ptr = selfptr + (selflen - needlelen);
684                 while (ptr >= selfptr) {
685                     bytes32 testHash;
686                     assembly { testHash := keccak256(ptr, needlelen) }
687                     if (hash == testHash)
688                         return ptr + needlelen;
689                     ptr -= 1;
690                 }
691             }
692         }
693         return selfptr;
694     }
695 
696     /*
697      * @dev Modifies `self` to contain everything from the first occurrence of
698      *      `needle` to the end of the slice. `self` is set to the empty slice
699      *      if `needle` is not found.
700      * @param self The slice to search and modify.
701      * @param needle The text to search for.
702      * @return `self`.
703      */
704     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
705         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
706         self._len -= ptr - self._ptr;
707         self._ptr = ptr;
708         return self;
709     }
710 
711     /*
712      * @dev Modifies `self` to contain the part of the string from the start of
713      *      `self` to the end of the first occurrence of `needle`. If `needle`
714      *      is not found, `self` is set to the empty slice.
715      * @param self The slice to search and modify.
716      * @param needle The text to search for.
717      * @return `self`.
718      */
719     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
720         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
721         self._len = ptr - self._ptr;
722         return self;
723     }
724 
725     /*
726      * @dev Splits the slice, setting `self` to everything after the first
727      *      occurrence of `needle`, and `token` to everything before it. If
728      *      `needle` does not occur in `self`, `self` is set to the empty slice,
729      *      and `token` is set to the entirety of `self`.
730      * @param self The slice to split.
731      * @param needle The text to search for in `self`.
732      * @param token An output parameter to which the first token is written.
733      * @return `token`.
734      */
735     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
736         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
737         token._ptr = self._ptr;
738         token._len = ptr - self._ptr;
739         if (ptr == self._ptr + self._len) {
740             // Not found
741             self._len = 0;
742         } else {
743             self._len -= token._len + needle._len;
744             self._ptr = ptr + needle._len;
745         }
746         return token;
747     }
748 
749     /*
750      * @dev Splits the slice, setting `self` to everything after the first
751      *      occurrence of `needle`, and returning everything before it. If
752      *      `needle` does not occur in `self`, `self` is set to the empty slice,
753      *      and the entirety of `self` is returned.
754      * @param self The slice to split.
755      * @param needle The text to search for in `self`.
756      * @return The part of `self` up to the first occurrence of `delim`.
757      */
758     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
759         split(self, needle, token);
760     }
761 
762     /*
763      * @dev Splits the slice, setting `self` to everything before the last
764      *      occurrence of `needle`, and `token` to everything after it. If
765      *      `needle` does not occur in `self`, `self` is set to the empty slice,
766      *      and `token` is set to the entirety of `self`.
767      * @param self The slice to split.
768      * @param needle The text to search for in `self`.
769      * @param token An output parameter to which the first token is written.
770      * @return `token`.
771      */
772     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
773         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
774         token._ptr = ptr;
775         token._len = self._len - (ptr - self._ptr);
776         if (ptr == self._ptr) {
777             // Not found
778             self._len = 0;
779         } else {
780             self._len -= token._len + needle._len;
781         }
782         return token;
783     }
784 
785     /*
786      * @dev Splits the slice, setting `self` to everything before the last
787      *      occurrence of `needle`, and returning everything after it. If
788      *      `needle` does not occur in `self`, `self` is set to the empty slice,
789      *      and the entirety of `self` is returned.
790      * @param self The slice to split.
791      * @param needle The text to search for in `self`.
792      * @return The part of `self` after the last occurrence of `delim`.
793      */
794     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
795         rsplit(self, needle, token);
796     }
797 
798     /*
799      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
800      * @param self The slice to search.
801      * @param needle The text to search for in `self`.
802      * @return The number of occurrences of `needle` found in `self`.
803      */
804     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
805         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
806         while (ptr <= self._ptr + self._len) {
807             cnt++;
808             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
809         }
810     }
811 
812     /*
813      * @dev Returns True if `self` contains `needle`.
814      * @param self The slice to search.
815      * @param needle The text to search for in `self`.
816      * @return True if `needle` is found in `self`, false otherwise.
817      */
818     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
819         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
820     }
821 
822     /*
823      * @dev Returns a newly allocated string containing the concatenation of
824      *      `self` and `other`.
825      * @param self The first slice to concatenate.
826      * @param other The second slice to concatenate.
827      * @return The concatenation of the two strings.
828      */
829     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
830         string memory ret = new string(self._len + other._len);
831         uint retptr;
832         assembly { retptr := add(ret, 32) }
833         memcpy(retptr, self._ptr, self._len);
834         memcpy(retptr + self._len, other._ptr, other._len);
835         return ret;
836     }
837 
838     /*
839      * @dev Joins an array of slices, using `self` as a delimiter, returning a
840      *      newly allocated string.
841      * @param self The delimiter to use.
842      * @param parts A list of slices to join.
843      * @return A newly allocated string containing all the slices in `parts`,
844      *         joined with `self`.
845      */
846     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
847         if (parts.length == 0)
848             return "";
849 
850         uint length = self._len * (parts.length - 1);
851         for(uint i = 0; i < parts.length; i++)
852             length += parts[i]._len;
853 
854         string memory ret = new string(length);
855         uint retptr;
856         assembly { retptr := add(ret, 32) }
857 
858         for(uint i = 0; i < parts.length; i++) {
859             memcpy(retptr, parts[i]._ptr, parts[i]._len);
860             retptr += parts[i]._len;
861             if (i < parts.length - 1) {
862                 memcpy(retptr, self._ptr, self._len);
863                 retptr += self._len;
864             }
865         }
866 
867         return ret;
868     }
869 }
870 
871 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENS.sol
872 // with few modifications.
873 
874 
875 
876 /**
877  * ENS Registry interface.
878  */
879 interface ENSRegistry {
880     // Logged when the owner of a node assigns a new owner to a subnode.
881     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
882 
883     // Logged when the owner of a node transfers ownership to a new account.
884     event Transfer(bytes32 indexed node, address owner);
885 
886     // Logged when the resolver for a node changes.
887     event NewResolver(bytes32 indexed node, address resolver);
888 
889     // Logged when the TTL of a node changes
890     event NewTTL(bytes32 indexed node, uint64 ttl);
891 
892     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
893     function setResolver(bytes32 node, address resolver) external;
894     function setOwner(bytes32 node, address owner) external;
895     function setTTL(bytes32 node, uint64 ttl) external;
896     function owner(bytes32 node) external view returns (address);
897     function resolver(bytes32 node) external view returns (address);
898     function ttl(bytes32 node) external view returns (uint64);
899 }
900 
901 
902 /**
903  * ENS Resolver interface.
904  */
905 abstract contract ENSResolver {
906     function addr(bytes32 _node) public view virtual returns (address);
907     function setAddr(bytes32 _node, address _addr) public virtual;
908     function name(bytes32 _node) public view virtual returns (string memory);
909     function setName(bytes32 _node, string memory _name) public virtual;
910 }
911 
912 /**
913  * ENS Reverse Registrar interface.
914  */
915 abstract contract ENSReverseRegistrar {
916     function claim(address _owner) public virtual returns (bytes32 _node);
917     function claimWithResolver(address _owner, address _resolver) public virtual returns (bytes32);
918     function setName(string memory _name) public virtual returns (bytes32);
919     function node(address _addr) public view virtual returns (bytes32);
920 }
921 
922 // Copyright 2017 Loopring Technology Limited.
923 
924 
925 
926 /// @title Utility Functions for uint
927 /// @author Daniel Wang - <daniel@loopring.org>
928 library MathUint
929 {
930     function mul(
931         uint a,
932         uint b
933         )
934         internal
935         pure
936         returns (uint c)
937     {
938         c = a * b;
939         require(a == 0 || c / a == b, "MUL_OVERFLOW");
940     }
941 
942     function sub(
943         uint a,
944         uint b
945         )
946         internal
947         pure
948         returns (uint)
949     {
950         require(b <= a, "SUB_UNDERFLOW");
951         return a - b;
952     }
953 
954     function add(
955         uint a,
956         uint b
957         )
958         internal
959         pure
960         returns (uint c)
961     {
962         c = a + b;
963         require(c >= a, "ADD_OVERFLOW");
964     }
965 }
966 
967 // Copyright 2017 Loopring Technology Limited.
968 
969 pragma experimental ABIEncoderV2;
970 
971 
972 //Mainly taken from https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
973 
974 
975 library BytesUtil {
976     function slice(
977         bytes memory _bytes,
978         uint _start,
979         uint _length
980     )
981         internal
982         pure
983         returns (bytes memory)
984     {
985         require(_bytes.length >= (_start + _length));
986 
987         bytes memory tempBytes;
988 
989         assembly {
990             switch iszero(_length)
991             case 0 {
992                 // Get a location of some free memory and store it in tempBytes as
993                 // Solidity does for memory variables.
994                 tempBytes := mload(0x40)
995 
996                 // The first word of the slice result is potentially a partial
997                 // word read from the original array. To read it, we calculate
998                 // the length of that partial word and start copying that many
999                 // bytes into the array. The first word we copy will start with
1000                 // data we don't care about, but the last `lengthmod` bytes will
1001                 // land at the beginning of the contents of the new array. When
1002                 // we're done copying, we overwrite the full first word with
1003                 // the actual length of the slice.
1004                 let lengthmod := and(_length, 31)
1005 
1006                 // The multiplication in the next line is necessary
1007                 // because when slicing multiples of 32 bytes (lengthmod == 0)
1008                 // the following copy loop was copying the origin's length
1009                 // and then ending prematurely not copying everything it should.
1010                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
1011                 let end := add(mc, _length)
1012 
1013                 for {
1014                     // The multiplication in the next line has the same exact purpose
1015                     // as the one above.
1016                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
1017                 } lt(mc, end) {
1018                     mc := add(mc, 0x20)
1019                     cc := add(cc, 0x20)
1020                 } {
1021                     mstore(mc, mload(cc))
1022                 }
1023 
1024                 mstore(tempBytes, _length)
1025 
1026                 //update free-memory pointer
1027                 //allocating the array padded to 32 bytes like the compiler does now
1028                 mstore(0x40, and(add(mc, 31), not(31)))
1029             }
1030             //if we want a zero-length slice let's just return a zero-length array
1031             default {
1032                 tempBytes := mload(0x40)
1033 
1034                 mstore(0x40, add(tempBytes, 0x20))
1035             }
1036         }
1037 
1038         return tempBytes;
1039     }
1040 
1041     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
1042         require(_bytes.length >= (_start + 20));
1043         address tempAddress;
1044 
1045         assembly {
1046             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
1047         }
1048 
1049         return tempAddress;
1050     }
1051 
1052     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
1053         require(_bytes.length >= (_start + 1));
1054         uint8 tempUint;
1055 
1056         assembly {
1057             tempUint := mload(add(add(_bytes, 0x1), _start))
1058         }
1059 
1060         return tempUint;
1061     }
1062 
1063     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
1064         require(_bytes.length >= (_start + 2));
1065         uint16 tempUint;
1066 
1067         assembly {
1068             tempUint := mload(add(add(_bytes, 0x2), _start))
1069         }
1070 
1071         return tempUint;
1072     }
1073 
1074     function toUint24(bytes memory _bytes, uint _start) internal  pure returns (uint24) {
1075         require(_bytes.length >= (_start + 3));
1076         uint24 tempUint;
1077 
1078         assembly {
1079             tempUint := mload(add(add(_bytes, 0x3), _start))
1080         }
1081 
1082         return tempUint;
1083     }
1084 
1085     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
1086         require(_bytes.length >= (_start + 4));
1087         uint32 tempUint;
1088 
1089         assembly {
1090             tempUint := mload(add(add(_bytes, 0x4), _start))
1091         }
1092 
1093         return tempUint;
1094     }
1095 
1096     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
1097         require(_bytes.length >= (_start + 8));
1098         uint64 tempUint;
1099 
1100         assembly {
1101             tempUint := mload(add(add(_bytes, 0x8), _start))
1102         }
1103 
1104         return tempUint;
1105     }
1106 
1107     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
1108         require(_bytes.length >= (_start + 12));
1109         uint96 tempUint;
1110 
1111         assembly {
1112             tempUint := mload(add(add(_bytes, 0xc), _start))
1113         }
1114 
1115         return tempUint;
1116     }
1117 
1118     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
1119         require(_bytes.length >= (_start + 16));
1120         uint128 tempUint;
1121 
1122         assembly {
1123             tempUint := mload(add(add(_bytes, 0x10), _start))
1124         }
1125 
1126         return tempUint;
1127     }
1128 
1129     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
1130         require(_bytes.length >= (_start + 32));
1131         uint256 tempUint;
1132 
1133         assembly {
1134             tempUint := mload(add(add(_bytes, 0x20), _start))
1135         }
1136 
1137         return tempUint;
1138     }
1139 
1140     function toBytes4(bytes memory _bytes, uint _start) internal  pure returns (bytes4) {
1141         require(_bytes.length >= (_start + 4));
1142         bytes4 tempBytes4;
1143 
1144         assembly {
1145             tempBytes4 := mload(add(add(_bytes, 0x20), _start))
1146         }
1147 
1148         return tempBytes4;
1149     }
1150 
1151     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
1152         require(_bytes.length >= (_start + 32));
1153         bytes32 tempBytes32;
1154 
1155         assembly {
1156             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
1157         }
1158 
1159         return tempBytes32;
1160     }
1161 
1162     function fastSHA256(
1163         bytes memory data
1164         )
1165         internal
1166         view
1167         returns (bytes32)
1168     {
1169         bytes32[] memory result = new bytes32[](1);
1170         bool success;
1171         assembly {
1172              let ptr := add(data, 32)
1173              success := staticcall(sub(gas(), 2000), 2, ptr, mload(data), add(result, 32), 32)
1174         }
1175         require(success, "SHA256_FAILED");
1176         return result[0];
1177     }
1178 }
1179 
1180 
1181 // Copyright 2017 Loopring Technology Limited.
1182 
1183 
1184 
1185 /// @title Utility Functions for addresses
1186 /// @author Daniel Wang - <daniel@loopring.org>
1187 /// @author Brecht Devos - <brecht@loopring.org>
1188 library AddressUtil
1189 {
1190     using AddressUtil for *;
1191 
1192     function isContract(
1193         address addr
1194         )
1195         internal
1196         view
1197         returns (bool)
1198     {
1199         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1200         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1201         // for accounts without code, i.e. `keccak256('')`
1202         bytes32 codehash;
1203         // solhint-disable-next-line no-inline-assembly
1204         assembly { codehash := extcodehash(addr) }
1205         return (codehash != 0x0 &&
1206                 codehash != 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470);
1207     }
1208 
1209     function toPayable(
1210         address addr
1211         )
1212         internal
1213         pure
1214         returns (address payable)
1215     {
1216         return address(uint160(addr));
1217     }
1218 
1219     // Works like address.send but with a customizable gas limit
1220     // Make sure your code is safe for reentrancy when using this function!
1221     function sendETH(
1222         address to,
1223         uint    amount,
1224         uint    gasLimit
1225         )
1226         internal
1227         returns (bool success)
1228     {
1229         if (amount == 0) {
1230             return true;
1231         }
1232         address payable recipient = to.toPayable();
1233         /* solium-disable-next-line */
1234         (success,) = recipient.call{value: amount, gas: gasLimit}("");
1235     }
1236 
1237     // Works like address.transfer but with a customizable gas limit
1238     // Make sure your code is safe for reentrancy when using this function!
1239     function sendETHAndVerify(
1240         address to,
1241         uint    amount,
1242         uint    gasLimit
1243         )
1244         internal
1245         returns (bool success)
1246     {
1247         success = to.sendETH(amount, gasLimit);
1248         require(success, "TRANSFER_FAILURE");
1249     }
1250 }
1251 
1252 
1253 
1254 
1255 /// @title SignatureUtil
1256 /// @author Daniel Wang - <daniel@loopring.org>
1257 /// @dev This method supports multihash standard. Each signature's first byte indicates
1258 ///      the signature's type, the second byte indicates the signature's length, therefore,
1259 ///      each signature will have 2 extra bytes prefix. Mulitple signatures are concatenated
1260 ///      together.
1261 library SignatureUtil
1262 {
1263     using BytesUtil     for bytes;
1264     using MathUint      for uint;
1265     using AddressUtil   for address;
1266 
1267     enum SignatureType {
1268         ILLEGAL,
1269         INVALID,
1270         EIP_712,
1271         ETH_SIGN,
1272         WALLET   // deprecated
1273     }
1274 
1275     bytes4 constant internal ERC1271_MAGICVALUE = 0x20c13b0b;
1276 
1277     bytes4 constant internal ERC1271_FUNCTION_WITH_BYTES_SELECTOR = bytes4(
1278         keccak256(bytes("isValidSignature(bytes,bytes)"))
1279     );
1280 
1281     bytes4 constant internal ERC1271_FUNCTION_WITH_BYTES32_SELECTOR = bytes4(
1282         keccak256(bytes("isValidSignature(bytes32,bytes)"))
1283     );
1284 
1285     function verifySignatures(
1286         bytes32          signHash,
1287         address[] memory signers,
1288         bytes[]   memory signatures
1289         )
1290         internal
1291         view
1292         returns (bool)
1293     {
1294         return verifySignatures(abi.encodePacked(signHash), signers, signatures);
1295     }
1296 
1297     function verifySignatures(
1298         bytes     memory data,
1299         address[] memory signers,
1300         bytes[]   memory signatures
1301         )
1302         internal
1303         view
1304         returns (bool)
1305     {
1306         require(signers.length == signatures.length, "BAD_SIGNATURE_DATA");
1307         address lastSigner;
1308         for (uint i = 0; i < signers.length; i++) {
1309             require(signers[i] > lastSigner, "INVALID_SIGNERS_ORDER");
1310             lastSigner = signers[i];
1311             if (!verifySignature(data, signers[i], signatures[i])) {
1312                 return false;
1313             }
1314         }
1315         return true;
1316     }
1317 
1318     function verifySignature(
1319         bytes   memory data,
1320         address        signer,
1321         bytes   memory signature
1322         )
1323         internal
1324         view
1325         returns (bool)
1326     {
1327         return signer.isContract() ?
1328             verifyERC1271Signature(data, signer, signature) :
1329             verifyEOASignature(data, signer, signature);
1330     }
1331 
1332     function verifySignature(
1333         bytes32        signHash,
1334         address        signer,
1335         bytes   memory signature
1336         )
1337         internal
1338         view
1339         returns (bool)
1340     {
1341         return verifySignature(abi.encodePacked(signHash), signer, signature);
1342     }
1343 
1344     function recoverECDSASigner(
1345         bytes32      signHash,
1346         bytes memory signature
1347         )
1348         internal
1349         pure
1350         returns (address)
1351     {
1352         if (signature.length != 65) {
1353             return address(0);
1354         }
1355 
1356         bytes32 r;
1357         bytes32 s;
1358         uint8   v;
1359         // we jump 32 (0x20) as the first slot of bytes contains the length
1360         // we jump 65 (0x41) per signature
1361         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
1362         assembly {
1363             r := mload(add(signature, 0x20))
1364             s := mload(add(signature, 0x40))
1365             v := and(mload(add(signature, 0x41)), 0xff)
1366         }
1367         // See https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol
1368         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1369             return address(0);
1370         }
1371         if (v == 27 || v == 28) {
1372             return ecrecover(signHash, v, r, s);
1373         } else {
1374             return address(0);
1375         }
1376     }
1377 
1378     function recoverECDSASigner(
1379         bytes memory data,
1380         bytes memory signature
1381         )
1382         internal
1383         pure
1384         returns (address addr1, address addr2)
1385     {
1386         if (data.length == 32) {
1387             addr1 = recoverECDSASigner(data.toBytes32(0), signature);
1388         }
1389         addr2 = recoverECDSASigner(keccak256(data), signature);
1390     }
1391 
1392     function verifyEOASignature(
1393         bytes   memory data,
1394         address        signer,
1395         bytes   memory signature
1396         )
1397         private
1398         pure
1399         returns (bool)
1400     {
1401         if (signer == address(0)) {
1402             return false;
1403         }
1404 
1405         uint signatureTypeOffset = signature.length.sub(1);
1406         SignatureType signatureType = SignatureType(signature.toUint8(signatureTypeOffset));
1407 
1408         bytes memory stripped = signature.slice(0, signatureTypeOffset);
1409 
1410         if (signatureType == SignatureType.EIP_712) {
1411             (address addr1, address addr2) = recoverECDSASigner(data, stripped);
1412             return addr1 == signer || addr2 == signer;
1413         } else if (signatureType == SignatureType.ETH_SIGN) {
1414             if (data.length == 32) {
1415                 bytes32 hash = keccak256(
1416                     abi.encodePacked("\x19Ethereum Signed Message:\n32", data.toBytes32(0))
1417                 );
1418                 if (recoverECDSASigner(hash, stripped) == signer) {
1419                     return true;
1420                 }
1421             }
1422             bytes32 hash = keccak256(
1423                 abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(data))
1424             );
1425             return recoverECDSASigner(hash, stripped) == signer;
1426         } else {
1427             return false;
1428         }
1429     }
1430 
1431     function verifyERC1271Signature(
1432         bytes   memory data,
1433         address signer,
1434         bytes   memory signature
1435         )
1436         private
1437         view
1438         returns (bool)
1439     {
1440         return data.length == 32 &&
1441             verifyERC1271WithBytes32(data.toBytes32(0), signer, signature) ||
1442             verifyERC1271WithBytes(data, signer, signature);
1443     }
1444 
1445     function verifyERC1271WithBytes(
1446         bytes   memory data,
1447         address signer,
1448         bytes   memory signature
1449         )
1450         private
1451         view
1452         returns (bool)
1453     {
1454         bytes memory callData = abi.encodeWithSelector(
1455             ERC1271_FUNCTION_WITH_BYTES_SELECTOR,
1456             data,
1457             signature
1458         );
1459         (bool success, bytes memory result) = signer.staticcall(callData);
1460         return (
1461             success &&
1462             result.length == 32 &&
1463             result.toBytes4(0) == ERC1271_MAGICVALUE
1464         );
1465     }
1466 
1467     function verifyERC1271WithBytes32(
1468         bytes32 hash,
1469         address signer,
1470         bytes   memory signature
1471         )
1472         private
1473         view
1474         returns (bool)
1475     {
1476         bytes memory callData = abi.encodeWithSelector(
1477             ERC1271_FUNCTION_WITH_BYTES32_SELECTOR,
1478             hash,
1479             signature
1480         );
1481         (bool success, bytes memory result) = signer.staticcall(callData);
1482         return (
1483             success &&
1484             result.length == 32 &&
1485             result.toBytes4(0) == ERC1271_MAGICVALUE
1486         );
1487     }
1488 }
1489 
1490 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ENSConsumer.sol
1491 // with few modifications.
1492 
1493 
1494 
1495 
1496 
1497 /**
1498  * @title ENSConsumer
1499  * @dev Helper contract to resolve ENS names.
1500  * @author Julien Niset - <julien@argent.im>
1501  */
1502 contract ENSConsumer {
1503 
1504     using strings for *;
1505 
1506     // namehash('addr.reverse')
1507     bytes32 constant public ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
1508 
1509     // the address of the ENS registry
1510     address ensRegistry;
1511 
1512     /**
1513     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The
1514     * contract will use the hardcoded value.
1515     */
1516     constructor(address _ensRegistry) {
1517         ensRegistry = _ensRegistry;
1518     }
1519 
1520     /**
1521     * @dev Resolves an ENS name to an address.
1522     * @param _node The namehash of the ENS name.
1523     */
1524     function resolveEns(bytes32 _node) public view returns (address) {
1525         address resolver = getENSRegistry().resolver(_node);
1526         return ENSResolver(resolver).addr(_node);
1527     }
1528 
1529     /**
1530     * @dev Gets the official ENS registry.
1531     */
1532     function getENSRegistry() public view returns (ENSRegistry) {
1533         return ENSRegistry(ensRegistry);
1534     }
1535 
1536     /**
1537     * @dev Gets the official ENS reverse registrar.
1538     */
1539     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
1540         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
1541     }
1542 }
1543 
1544 // Taken from Argent's code base - https://github.com/argentlabs/argent-contracts/blob/develop/contracts/ens/ArgentENSManager.sol
1545 // with few modifications.
1546 
1547 
1548 
1549 
1550 
1551 
1552 // Copyright 2017 Loopring Technology Limited.
1553 
1554 
1555 
1556 
1557 // Copyright 2017 Loopring Technology Limited.
1558 
1559 
1560 
1561 
1562 
1563 /// @title Claimable
1564 /// @author Brecht Devos - <brecht@loopring.org>
1565 /// @dev Extension for the Ownable contract, where the ownership needs
1566 ///      to be claimed. This allows the new owner to accept the transfer.
1567 contract Claimable is Ownable
1568 {
1569     address public pendingOwner;
1570 
1571     /// @dev Modifier throws if called by any account other than the pendingOwner.
1572     modifier onlyPendingOwner() {
1573         require(msg.sender == pendingOwner, "UNAUTHORIZED");
1574         _;
1575     }
1576 
1577     /// @dev Allows the current owner to set the pendingOwner address.
1578     /// @param newOwner The address to transfer ownership to.
1579     function transferOwnership(
1580         address newOwner
1581         )
1582         public
1583         override
1584         onlyOwner
1585     {
1586         require(newOwner != address(0) && newOwner != owner, "INVALID_ADDRESS");
1587         pendingOwner = newOwner;
1588     }
1589 
1590     /// @dev Allows the pendingOwner address to finalize the transfer.
1591     function claimOwnership()
1592         public
1593         onlyPendingOwner
1594     {
1595         emit OwnershipTransferred(owner, pendingOwner);
1596         owner = pendingOwner;
1597         pendingOwner = address(0);
1598     }
1599 }
1600 
1601 
1602 
1603 contract OwnerManagable is Claimable, AddressSet
1604 {
1605     bytes32 internal constant MANAGER = keccak256("__MANAGED__");
1606 
1607     event ManagerAdded  (address manager);
1608     event ManagerRemoved(address manager);
1609 
1610     modifier onlyManager
1611     {
1612         require(isManager(msg.sender), "NOT_MANAGER");
1613         _;
1614     }
1615 
1616     modifier onlyOwnerOrManager
1617     {
1618         require(msg.sender == owner || isManager(msg.sender), "NOT_OWNER_OR_MANAGER");
1619         _;
1620     }
1621 
1622     constructor() Claimable() {}
1623 
1624     /// @dev Gets the managers.
1625     /// @return The list of managers.
1626     function managers()
1627         public
1628         view
1629         returns (address[] memory)
1630     {
1631         return addressesInSet(MANAGER);
1632     }
1633 
1634     /// @dev Gets the number of managers.
1635     /// @return The numer of managers.
1636     function numManagers()
1637         public
1638         view
1639         returns (uint)
1640     {
1641         return numAddressesInSet(MANAGER);
1642     }
1643 
1644     /// @dev Checks if an address is a manger.
1645     /// @param addr The address to check.
1646     /// @return True if the address is a manager, False otherwise.
1647     function isManager(address addr)
1648         public
1649         view
1650         returns (bool)
1651     {
1652         return isAddressInSet(MANAGER, addr);
1653     }
1654 
1655     /// @dev Adds a new manager.
1656     /// @param manager The new address to add.
1657     function addManager(address manager)
1658         public
1659         onlyOwner
1660     {
1661         addManagerInternal(manager);
1662     }
1663 
1664     /// @dev Removes a manager.
1665     /// @param manager The manager to remove.
1666     function removeManager(address manager)
1667         public
1668         onlyOwner
1669     {
1670         removeAddressFromSet(MANAGER, manager);
1671         emit ManagerRemoved(manager);
1672     }
1673 
1674     function addManagerInternal(address manager)
1675         internal
1676     {
1677         addAddressToSet(MANAGER, manager, true);
1678         emit ManagerAdded(manager);
1679     }
1680 }
1681 
1682 
1683 /**
1684  * @dev Interface for an ENS Mananger.
1685  */
1686 interface IENSManager {
1687     function changeRootnodeOwner(address _newOwner) external;
1688 
1689     function isAvailable(bytes32 _subnode) external view returns (bool);
1690 
1691     function resolveName(address _wallet) external view returns (string memory);
1692 
1693     function register(
1694         address _wallet,
1695         address _owner,
1696         string  calldata _label,
1697         bytes   calldata _approval
1698     ) external;
1699 }
1700 
1701 /**
1702  * @title BaseENSManager
1703  * @dev Implementation of an ENS manager that orchestrates the complete
1704  * registration of subdomains for a single root (e.g. argent.eth).
1705  * The contract defines a manager role who is the only role that can trigger the registration of
1706  * a new subdomain.
1707  * @author Julien Niset - <julien@argent.im>
1708  */
1709 contract BaseENSManager is IENSManager, OwnerManagable, ENSConsumer {
1710 
1711     using strings for *;
1712     using BytesUtil     for bytes;
1713     using MathUint      for uint;
1714 
1715     // The managed root name
1716     string public rootName;
1717     // The managed root node
1718     bytes32 public rootNode;
1719     // The address of the ENS resolver
1720     address public ensResolver;
1721 
1722     // *************** Events *************************** //
1723 
1724     event RootnodeOwnerChange(bytes32 indexed _rootnode, address indexed _newOwner);
1725     event ENSResolverChanged(address addr);
1726     event Registered(address indexed _wallet, address _owner, string _ens);
1727     event Unregistered(string _ens);
1728 
1729     // *************** Constructor ********************** //
1730 
1731     /**
1732      * @dev Constructor that sets the ENS root name and root node to manage.
1733      * @param _rootName The root name (e.g. argentx.eth).
1734      * @param _rootNode The node of the root name (e.g. namehash(argentx.eth)).
1735      */
1736     constructor(string memory _rootName, bytes32 _rootNode, address _ensRegistry, address _ensResolver)
1737         ENSConsumer(_ensRegistry)
1738     {
1739         rootName = _rootName;
1740         rootNode = _rootNode;
1741         ensResolver = _ensResolver;
1742     }
1743 
1744     // *************** External Functions ********************* //
1745 
1746     /**
1747      * @dev This function must be called when the ENS Manager contract is replaced
1748      * and the address of the new Manager should be provided.
1749      * @param _newOwner The address of the new ENS manager that will manage the root node.
1750      */
1751     function changeRootnodeOwner(address _newOwner) external override onlyOwner {
1752         getENSRegistry().setOwner(rootNode, _newOwner);
1753         emit RootnodeOwnerChange(rootNode, _newOwner);
1754     }
1755 
1756     /**
1757      * @dev Lets the owner change the address of the ENS resolver contract.
1758      * @param _ensResolver The address of the ENS resolver contract.
1759      */
1760     function changeENSResolver(address _ensResolver) external onlyOwner {
1761         require(_ensResolver != address(0), "WF: address cannot be null");
1762         ensResolver = _ensResolver;
1763         emit ENSResolverChanged(_ensResolver);
1764     }
1765 
1766     /**
1767     * @dev Lets the manager assign an ENS subdomain of the root node to a target address.
1768     * Registers both the forward and reverse ENS.
1769     * @param _wallet The wallet which owns the subdomain.
1770     * @param _owner The wallet's owner.
1771     * @param _label The subdomain label.
1772     * @param _approval The signature of _wallet, _owner and _label by a manager.
1773     */
1774     function register(
1775         address _wallet,
1776         address _owner,
1777         string  calldata _label,
1778         bytes   calldata _approval
1779         )
1780         external
1781         override
1782         onlyManager
1783     {
1784         verifyApproval(_wallet, _owner, _label, _approval);
1785 
1786         bytes32 labelNode = keccak256(abi.encodePacked(_label));
1787         bytes32 node = keccak256(abi.encodePacked(rootNode, labelNode));
1788         address currentOwner = getENSRegistry().owner(node);
1789         require(currentOwner == address(0), "AEM: _label is alrealdy owned");
1790 
1791         // Forward ENS
1792         getENSRegistry().setSubnodeOwner(rootNode, labelNode, address(this));
1793         getENSRegistry().setResolver(node, ensResolver);
1794         getENSRegistry().setOwner(node, _wallet);
1795         ENSResolver(ensResolver).setAddr(node, _wallet);
1796 
1797         // Reverse ENS
1798         strings.slice[] memory parts = new strings.slice[](2);
1799         parts[0] = _label.toSlice();
1800         parts[1] = rootName.toSlice();
1801         string memory name = ".".toSlice().join(parts);
1802         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
1803         ENSResolver(ensResolver).setName(reverseNode, name);
1804 
1805         emit Registered(_wallet, _owner, name);
1806     }
1807 
1808     // *************** Public Functions ********************* //
1809 
1810     /**
1811     * @dev Resolves an address to an ENS name
1812     * @param _wallet The ENS owner address
1813     */
1814     function resolveName(address _wallet) public view override returns (string memory) {
1815         bytes32 reverseNode = getENSReverseRegistrar().node(_wallet);
1816         return ENSResolver(ensResolver).name(reverseNode);
1817     }
1818 
1819     /**
1820      * @dev Returns true is a given subnode is available.
1821      * @param _subnode The target subnode.
1822      * @return true if the subnode is available.
1823      */
1824     function isAvailable(bytes32 _subnode) public view override returns (bool) {
1825         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
1826         address currentOwner = getENSRegistry().owner(node);
1827         if(currentOwner == address(0)) {
1828             return true;
1829         }
1830         return false;
1831     }
1832 
1833     function verifyApproval(
1834         address _wallet,
1835         address _owner,
1836         string  memory _label,
1837         bytes   memory _approval
1838         )
1839         internal
1840         view
1841     {
1842         bytes32 messageHash = keccak256(
1843             abi.encodePacked(
1844                 _wallet,
1845                 _owner,
1846                 _label
1847             )
1848         );
1849 
1850         bytes32 hash = keccak256(
1851             abi.encodePacked(
1852                 "\x19Ethereum Signed Message:\n32",
1853                 messageHash
1854             )
1855         );
1856 
1857         address signer = SignatureUtil.recoverECDSASigner(hash, _approval);
1858         require(isManager(signer), "UNAUTHORIZED");
1859     }
1860 
1861 }