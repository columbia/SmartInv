1 pragma solidity ^0.4.24;
2 
3 contract BasicAccessControl {
4     address public owner;
5     address[] moderatorsArray;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) moderators;
8     bool public isMaintaining = true;
9 
10     constructor() public {
11         owner = msg.sender;
12         AddModerator(msg.sender);
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyModerators() {
21         require(moderators[msg.sender] == true);
22         _;
23     }
24 
25     modifier isActive {
26         require(!isMaintaining);
27         _;
28     }
29 
30     function findInArray(address _address) internal view returns(uint8) {
31         uint8 i = 0;
32         while (moderatorsArray[i] != _address) {
33             i++;
34         }
35         return i;
36     }
37 
38     function ChangeOwner(address _newOwner) onlyOwner public {
39         if (_newOwner != address(0)) {
40             owner = _newOwner;
41         }
42     }
43 
44     function AddModerator(address _newModerator) onlyOwner public {
45         if (moderators[_newModerator] == false) {
46             moderators[_newModerator] = true;
47             moderatorsArray.push(_newModerator);
48             totalModerators += 1;
49         }
50     }
51 
52     function getModerators() public view returns(address[] memory) {
53         return moderatorsArray;
54     }
55 
56     function RemoveModerator(address _oldModerator) onlyOwner public {
57         if (moderators[_oldModerator] == true) {
58             moderators[_oldModerator] = false;
59             uint8 i = findInArray(_oldModerator);
60             while (i<moderatorsArray.length-1) {
61                 moderatorsArray[i] = moderatorsArray[i+1];
62                 i++;
63             }
64             moderatorsArray.length--;
65             totalModerators -= 1;
66         }
67     }
68 
69     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
70         isMaintaining = _isMaintaining;
71     }
72 
73     function isModerator(address _address) public view returns(bool, address) {
74         return (moderators[_address], _address);
75     }
76 }
77 
78 contract randomRange {
79     function getRandom(uint256 minRan, uint256 maxRan, uint8 index, address priAddress) view internal returns(uint) {
80         uint256 genNum = uint256(blockhash(block.number-1)) + uint256(priAddress) + uint256(keccak256(abi.encodePacked(block.timestamp, index)));
81         for (uint8 i = 0; i < index && i < 6; i ++) {
82             genNum /= 256;
83         }
84         return uint(genNum % (maxRan + 1 - minRan) + minRan);
85     }
86 }
87 
88 /*
89  * @title String & slice utility library for Solidity contracts.
90  * @author Nick Johnson <arachnid@notdot.net>
91  *
92  * @dev Functionality in this library is largely implemented using an
93  *      abstraction called a 'slice'. A slice represents a part of a string -
94  *      anything from the entire string to a single character, or even no
95  *      characters at all (a 0-length slice). Since a slice only has to specify
96  *      an offset and a length, copying and manipulating slices is a lot less
97  *      expensive than copying and manipulating the strings they reference.
98  *
99  *      To further reduce gas costs, most functions on slice that need to return
100  *      a slice modify the original one instead of allocating a new one; for
101  *      instance, `s.split(".")` will return the text up to the first '.',
102  *      modifying s to only contain the remainder of the string after the '.'.
103  *      In situations where you do not want to modify the original slice, you
104  *      can make a copy first with `.copy()`, for example:
105  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
106  *      Solidity has no memory management, it will result in allocating many
107  *      short-lived slices that are later discarded.
108  *
109  *      Functions that return two slices come in two versions: a non-allocating
110  *      version that takes the second slice as an argument, modifying it in
111  *      place, and an allocating version that allocates and returns the second
112  *      slice; see `nextRune` for example.
113  *
114  *      Functions that have to copy string data will return strings rather than
115  *      slices; these can be cast back to slices for further processing if
116  *      required.
117  *
118  *      For convenience, some functions are provided with non-modifying
119  *      variants that create a new slice and return both; for instance,
120  *      `s.splitNew('.')` leaves s unmodified, and returns two values
121  *      corresponding to the left and right parts of the string.
122  */
123 
124 
125 
126 library strings {
127     struct slice {
128         uint _len;
129         uint _ptr;
130     }
131 
132     function memcpy(uint dest, uint src, uint len) private pure {
133         // Copy word-length chunks while possible
134         for(; len >= 32; len -= 32) {
135             assembly {
136                 mstore(dest, mload(src))
137             }
138             dest += 32;
139             src += 32;
140         }
141 
142         // Copy remaining bytes
143         uint mask = 256 ** (32 - len) - 1;
144         assembly {
145             let srcpart := and(mload(src), not(mask))
146             let destpart := and(mload(dest), mask)
147             mstore(dest, or(destpart, srcpart))
148         }
149     }
150 
151     /*
152      * @dev Returns a slice containing the entire string.
153      * @param self The string to make a slice from.
154      * @return A newly allocated slice containing the entire string.
155      */
156     function toSlice(string memory self) internal pure returns (slice memory) {
157         uint ptr;
158         assembly {
159             ptr := add(self, 0x20)
160         }
161         return slice(bytes(self).length, ptr);
162     }
163 
164     /*
165      * @dev Returns the length of a null-terminated bytes32 string.
166      * @param self The value to find the length of.
167      * @return The length of the string, from 0 to 32.
168      */
169     function len(bytes32 self) internal pure returns (uint) {
170         uint ret;
171         if (self == 0)
172             return 0;
173         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
174             ret += 16;
175             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
176         }
177         if (self & 0xffffffffffffffff == 0) {
178             ret += 8;
179             self = bytes32(uint(self) / 0x10000000000000000);
180         }
181         if (self & 0xffffffff == 0) {
182             ret += 4;
183             self = bytes32(uint(self) / 0x100000000);
184         }
185         if (self & 0xffff == 0) {
186             ret += 2;
187             self = bytes32(uint(self) / 0x10000);
188         }
189         if (self & 0xff == 0) {
190             ret += 1;
191         }
192         return 32 - ret;
193     }
194 
195     /*
196      * @dev Returns a slice containing the entire bytes32, interpreted as a
197      *      null-terminated utf-8 string.
198      * @param self The bytes32 value to convert to a slice.
199      * @return A new slice containing the value of the input argument up to the
200      *         first null.
201      */
202     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
203         // Allocate space for `self` in memory, copy it there, and point ret at it
204         assembly {
205             let ptr := mload(0x40)
206             mstore(0x40, add(ptr, 0x20))
207             mstore(ptr, self)
208             mstore(add(ret, 0x20), ptr)
209         }
210         ret._len = len(self);
211     }
212 
213     /*
214      * @dev Returns a new slice containing the same data as the current slice.
215      * @param self The slice to copy.
216      * @return A new slice containing the same data as `self`.
217      */
218     function copy(slice memory self) internal pure returns (slice memory) {
219         return slice(self._len, self._ptr);
220     }
221 
222     /*
223      * @dev Copies a slice to a new string.
224      * @param self The slice to copy.
225      * @return A newly allocated string containing the slice's text.
226      */
227     function toString(slice memory self) internal pure returns (string memory) {
228         string memory ret = new string(self._len);
229         uint retptr;
230         assembly { retptr := add(ret, 32) }
231 
232         memcpy(retptr, self._ptr, self._len);
233         return ret;
234     }
235 
236     /*
237      * @dev Returns the length in runes of the slice. Note that this operation
238      *      takes time proportional to the length of the slice; avoid using it
239      *      in loops, and call `slice.empty()` if you only need to know whether
240      *      the slice is empty or not.
241      * @param self The slice to operate on.
242      * @return The length of the slice in runes.
243      */
244     function len(slice memory self) internal pure returns (uint l) {
245         // Starting at ptr-31 means the LSB will be the byte we care about
246         uint ptr = self._ptr - 31;
247         uint end = ptr + self._len;
248         for (l = 0; ptr < end; l++) {
249             uint8 b;
250             assembly { b := and(mload(ptr), 0xFF) }
251             if (b < 0x80) {
252                 ptr += 1;
253             } else if(b < 0xE0) {
254                 ptr += 2;
255             } else if(b < 0xF0) {
256                 ptr += 3;
257             } else if(b < 0xF8) {
258                 ptr += 4;
259             } else if(b < 0xFC) {
260                 ptr += 5;
261             } else {
262                 ptr += 6;
263             }
264         }
265     }
266 
267     /*
268      * @dev Returns true if the slice is empty (has a length of 0).
269      * @param self The slice to operate on.
270      * @return True if the slice is empty, False otherwise.
271      */
272     function empty(slice memory self) internal pure returns (bool) {
273         return self._len == 0;
274     }
275 
276     /*
277      * @dev Returns a positive number if `other` comes lexicographically after
278      *      `self`, a negative number if it comes before, or zero if the
279      *      contents of the two slices are equal. Comparison is done per-rune,
280      *      on unicode codepoints.
281      * @param self The first slice to compare.
282      * @param other The second slice to compare.
283      * @return The result of the comparison.
284      */
285     function compare(slice memory self, slice memory other) internal pure returns (int) {
286         uint shortest = self._len;
287         if (other._len < self._len)
288             shortest = other._len;
289 
290         uint selfptr = self._ptr;
291         uint otherptr = other._ptr;
292         for (uint idx = 0; idx < shortest; idx += 32) {
293             uint a;
294             uint b;
295             assembly {
296                 a := mload(selfptr)
297                 b := mload(otherptr)
298             }
299             if (a != b) {
300                 // Mask out irrelevant bytes and check again
301                 uint256 mask = uint256(-1); // 0xffff...
302                 if(shortest < 32) {
303                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
304                 }
305                 uint256 diff = (a & mask) - (b & mask);
306                 if (diff != 0)
307                     return int(diff);
308             }
309             selfptr += 32;
310             otherptr += 32;
311         }
312         return int(self._len) - int(other._len);
313     }
314 
315     /*
316      * @dev Returns true if the two slices contain the same text.
317      * @param self The first slice to compare.
318      * @param self The second slice to compare.
319      * @return True if the slices are equal, false otherwise.
320      */
321     function equals(slice memory self, slice memory other) internal pure returns (bool) {
322         return compare(self, other) == 0;
323     }
324 
325     /*
326      * @dev Extracts the first rune in the slice into `rune`, advancing the
327      *      slice to point to the next rune and returning `self`.
328      * @param self The slice to operate on.
329      * @param rune The slice that will contain the first rune.
330      * @return `rune`.
331      */
332     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
333         rune._ptr = self._ptr;
334 
335         if (self._len == 0) {
336             rune._len = 0;
337             return rune;
338         }
339 
340         uint l;
341         uint b;
342         // Load the first byte of the rune into the LSBs of b
343         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
344         if (b < 0x80) {
345             l = 1;
346         } else if(b < 0xE0) {
347             l = 2;
348         } else if(b < 0xF0) {
349             l = 3;
350         } else {
351             l = 4;
352         }
353 
354         // Check for truncated codepoints
355         if (l > self._len) {
356             rune._len = self._len;
357             self._ptr += self._len;
358             self._len = 0;
359             return rune;
360         }
361 
362         self._ptr += l;
363         self._len -= l;
364         rune._len = l;
365         return rune;
366     }
367 
368     /*
369      * @dev Returns the first rune in the slice, advancing the slice to point
370      *      to the next rune.
371      * @param self The slice to operate on.
372      * @return A slice containing only the first rune from `self`.
373      */
374     function nextRune(slice memory self) internal pure returns (slice memory ret) {
375         nextRune(self, ret);
376     }
377 
378     /*
379      * @dev Returns the number of the first codepoint in the slice.
380      * @param self The slice to operate on.
381      * @return The number of the first codepoint in the slice.
382      */
383     function ord(slice memory self) internal pure returns (uint ret) {
384         if (self._len == 0) {
385             return 0;
386         }
387 
388         uint word;
389         uint length;
390         uint divisor = 2 ** 248;
391 
392         // Load the rune into the MSBs of b
393         assembly { word:= mload(mload(add(self, 32))) }
394         uint b = word / divisor;
395         if (b < 0x80) {
396             ret = b;
397             length = 1;
398         } else if(b < 0xE0) {
399             ret = b & 0x1F;
400             length = 2;
401         } else if(b < 0xF0) {
402             ret = b & 0x0F;
403             length = 3;
404         } else {
405             ret = b & 0x07;
406             length = 4;
407         }
408 
409         // Check for truncated codepoints
410         if (length > self._len) {
411             return 0;
412         }
413 
414         for (uint i = 1; i < length; i++) {
415             divisor = divisor / 256;
416             b = (word / divisor) & 0xFF;
417             if (b & 0xC0 != 0x80) {
418                 // Invalid UTF-8 sequence
419                 return 0;
420             }
421             ret = (ret * 64) | (b & 0x3F);
422         }
423 
424         return ret;
425     }
426 
427     /*
428      * @dev Returns the keccak-256 hash of the slice.
429      * @param self The slice to hash.
430      * @return The hash of the slice.
431      */
432     function keccak(slice memory self) internal pure returns (bytes32 ret) {
433         assembly {
434             ret := keccak256(mload(add(self, 32)), mload(self))
435         }
436     }
437 
438     /*
439      * @dev Returns true if `self` starts with `needle`.
440      * @param self The slice to operate on.
441      * @param needle The slice to search for.
442      * @return True if the slice starts with the provided text, false otherwise.
443      */
444     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
445         if (self._len < needle._len) {
446             return false;
447         }
448 
449         if (self._ptr == needle._ptr) {
450             return true;
451         }
452 
453         bool equal;
454         assembly {
455             let length := mload(needle)
456             let selfptr := mload(add(self, 0x20))
457             let needleptr := mload(add(needle, 0x20))
458             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
459         }
460         return equal;
461     }
462 
463     /*
464      * @dev If `self` starts with `needle`, `needle` is removed from the
465      *      beginning of `self`. Otherwise, `self` is unmodified.
466      * @param self The slice to operate on.
467      * @param needle The slice to search for.
468      * @return `self`
469      */
470     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
471         if (self._len < needle._len) {
472             return self;
473         }
474 
475         bool equal = true;
476         if (self._ptr != needle._ptr) {
477             assembly {
478                 let length := mload(needle)
479                 let selfptr := mload(add(self, 0x20))
480                 let needleptr := mload(add(needle, 0x20))
481                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
482             }
483         }
484 
485         if (equal) {
486             self._len -= needle._len;
487             self._ptr += needle._len;
488         }
489 
490         return self;
491     }
492 
493     /*
494      * @dev Returns true if the slice ends with `needle`.
495      * @param self The slice to operate on.
496      * @param needle The slice to search for.
497      * @return True if the slice starts with the provided text, false otherwise.
498      */
499     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
500         if (self._len < needle._len) {
501             return false;
502         }
503 
504         uint selfptr = self._ptr + self._len - needle._len;
505 
506         if (selfptr == needle._ptr) {
507             return true;
508         }
509 
510         bool equal;
511         assembly {
512             let length := mload(needle)
513             let needleptr := mload(add(needle, 0x20))
514             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
515         }
516 
517         return equal;
518     }
519 
520     /*
521      * @dev If `self` ends with `needle`, `needle` is removed from the
522      *      end of `self`. Otherwise, `self` is unmodified.
523      * @param self The slice to operate on.
524      * @param needle The slice to search for.
525      * @return `self`
526      */
527     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
528         if (self._len < needle._len) {
529             return self;
530         }
531 
532         uint selfptr = self._ptr + self._len - needle._len;
533         bool equal = true;
534         if (selfptr != needle._ptr) {
535             assembly {
536                 let length := mload(needle)
537                 let needleptr := mload(add(needle, 0x20))
538                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
539             }
540         }
541 
542         if (equal) {
543             self._len -= needle._len;
544         }
545 
546         return self;
547     }
548 
549     // Returns the memory address of the first byte of the first occurrence of
550     // `needle` in `self`, or the first byte after `self` if not found.
551     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
552         uint ptr = selfptr;
553         uint idx;
554 
555         if (needlelen <= selflen) {
556             if (needlelen <= 32) {
557                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
558 
559                 bytes32 needledata;
560                 assembly { needledata := and(mload(needleptr), mask) }
561 
562                 uint end = selfptr + selflen - needlelen;
563                 bytes32 ptrdata;
564                 assembly { ptrdata := and(mload(ptr), mask) }
565 
566                 while (ptrdata != needledata) {
567                     if (ptr >= end)
568                         return selfptr + selflen;
569                     ptr++;
570                     assembly { ptrdata := and(mload(ptr), mask) }
571                 }
572                 return ptr;
573             } else {
574                 // For long needles, use hashing
575                 bytes32 hash;
576                 assembly { hash := keccak256(needleptr, needlelen) }
577 
578                 for (idx = 0; idx <= selflen - needlelen; idx++) {
579                     bytes32 testHash;
580                     assembly { testHash := keccak256(ptr, needlelen) }
581                     if (hash == testHash)
582                         return ptr;
583                     ptr += 1;
584                 }
585             }
586         }
587         return selfptr + selflen;
588     }
589 
590     // Returns the memory address of the first byte after the last occurrence of
591     // `needle` in `self`, or the address of `self` if not found.
592     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
593         uint ptr;
594 
595         if (needlelen <= selflen) {
596             if (needlelen <= 32) {
597                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
598 
599                 bytes32 needledata;
600                 assembly { needledata := and(mload(needleptr), mask) }
601 
602                 ptr = selfptr + selflen - needlelen;
603                 bytes32 ptrdata;
604                 assembly { ptrdata := and(mload(ptr), mask) }
605 
606                 while (ptrdata != needledata) {
607                     if (ptr <= selfptr)
608                         return selfptr;
609                     ptr--;
610                     assembly { ptrdata := and(mload(ptr), mask) }
611                 }
612                 return ptr + needlelen;
613             } else {
614                 // For long needles, use hashing
615                 bytes32 hash;
616                 assembly { hash := keccak256(needleptr, needlelen) }
617                 ptr = selfptr + (selflen - needlelen);
618                 while (ptr >= selfptr) {
619                     bytes32 testHash;
620                     assembly { testHash := keccak256(ptr, needlelen) }
621                     if (hash == testHash)
622                         return ptr + needlelen;
623                     ptr -= 1;
624                 }
625             }
626         }
627         return selfptr;
628     }
629 
630     /*
631      * @dev Modifies `self` to contain everything from the first occurrence of
632      *      `needle` to the end of the slice. `self` is set to the empty slice
633      *      if `needle` is not found.
634      * @param self The slice to search and modify.
635      * @param needle The text to search for.
636      * @return `self`.
637      */
638     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
639         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
640         self._len -= ptr - self._ptr;
641         self._ptr = ptr;
642         return self;
643     }
644 
645     /*
646      * @dev Modifies `self` to contain the part of the string from the start of
647      *      `self` to the end of the first occurrence of `needle`. If `needle`
648      *      is not found, `self` is set to the empty slice.
649      * @param self The slice to search and modify.
650      * @param needle The text to search for.
651      * @return `self`.
652      */
653     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
654         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
655         self._len = ptr - self._ptr;
656         return self;
657     }
658 
659     /*
660      * @dev Splits the slice, setting `self` to everything after the first
661      *      occurrence of `needle`, and `token` to everything before it. If
662      *      `needle` does not occur in `self`, `self` is set to the empty slice,
663      *      and `token` is set to the entirety of `self`.
664      * @param self The slice to split.
665      * @param needle The text to search for in `self`.
666      * @param token An output parameter to which the first token is written.
667      * @return `token`.
668      */
669     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
670         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
671         token._ptr = self._ptr;
672         token._len = ptr - self._ptr;
673         if (ptr == self._ptr + self._len) {
674             // Not found
675             self._len = 0;
676         } else {
677             self._len -= token._len + needle._len;
678             self._ptr = ptr + needle._len;
679         }
680         return token;
681     }
682 
683     /*
684      * @dev Splits the slice, setting `self` to everything after the first
685      *      occurrence of `needle`, and returning everything before it. If
686      *      `needle` does not occur in `self`, `self` is set to the empty slice,
687      *      and the entirety of `self` is returned.
688      * @param self The slice to split.
689      * @param needle The text to search for in `self`.
690      * @return The part of `self` up to the first occurrence of `delim`.
691      */
692     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
693         split(self, needle, token);
694     }
695 
696     /*
697      * @dev Splits the slice, setting `self` to everything before the last
698      *      occurrence of `needle`, and `token` to everything after it. If
699      *      `needle` does not occur in `self`, `self` is set to the empty slice,
700      *      and `token` is set to the entirety of `self`.
701      * @param self The slice to split.
702      * @param needle The text to search for in `self`.
703      * @param token An output parameter to which the first token is written.
704      * @return `token`.
705      */
706     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
707         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
708         token._ptr = ptr;
709         token._len = self._len - (ptr - self._ptr);
710         if (ptr == self._ptr) {
711             // Not found
712             self._len = 0;
713         } else {
714             self._len -= token._len + needle._len;
715         }
716         return token;
717     }
718 
719     /*
720      * @dev Splits the slice, setting `self` to everything before the last
721      *      occurrence of `needle`, and returning everything after it. If
722      *      `needle` does not occur in `self`, `self` is set to the empty slice,
723      *      and the entirety of `self` is returned.
724      * @param self The slice to split.
725      * @param needle The text to search for in `self`.
726      * @return The part of `self` after the last occurrence of `delim`.
727      */
728     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
729         rsplit(self, needle, token);
730     }
731 
732     /*
733      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
734      * @param self The slice to search.
735      * @param needle The text to search for in `self`.
736      * @return The number of occurrences of `needle` found in `self`.
737      */
738     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
739         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
740         while (ptr <= self._ptr + self._len) {
741             cnt++;
742             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
743         }
744     }
745 
746     /*
747      * @dev Returns True if `self` contains `needle`.
748      * @param self The slice to search.
749      * @param needle The text to search for in `self`.
750      * @return True if `needle` is found in `self`, false otherwise.
751      */
752     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
753         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
754     }
755 
756     /*
757      * @dev Returns a newly allocated string containing the concatenation of
758      *      `self` and `other`.
759      * @param self The first slice to concatenate.
760      * @param other The second slice to concatenate.
761      * @return The concatenation of the two strings.
762      */
763     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
764         string memory ret = new string(self._len + other._len);
765         uint retptr;
766         assembly { retptr := add(ret, 32) }
767         memcpy(retptr, self._ptr, self._len);
768         memcpy(retptr + self._len, other._ptr, other._len);
769         return ret;
770     }
771 
772     /*
773      * @dev Joins an array of slices, using `self` as a delimiter, returning a
774      *      newly allocated string.
775      * @param self The delimiter to use.
776      * @param parts A list of slices to join.
777      * @return A newly allocated string containing all the slices in `parts`,
778      *         joined with `self`.
779      */
780     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
781         if (parts.length == 0)
782             return "";
783 
784         uint length = self._len * (parts.length - 1);
785         for(uint i = 0; i < parts.length; i++)
786             length += parts[i]._len;
787 
788         string memory ret = new string(length);
789         uint retptr;
790         assembly { retptr := add(ret, 32) }
791 
792         for(i = 0; i < parts.length; i++) {
793             memcpy(retptr, parts[i]._ptr, parts[i]._len);
794             retptr += parts[i]._len;
795             if (i < parts.length - 1) {
796                 memcpy(retptr, self._ptr, self._len);
797                 retptr += self._len;
798             }
799         }
800 
801         return ret;
802     }
803 }
804 
805 /**
806  * @title ERC165
807  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
808  */
809 interface ERC165 {
810 
811   /**
812    * @notice Query if a contract implements an interface
813    * @param _interfaceId The interface identifier, as specified in ERC-165
814    * @dev Interface identification is specified in ERC-165. This function
815    * uses less than 30,000 gas.
816    */
817   function supportsInterface(bytes4 _interfaceId)
818     external
819     view
820     returns (bool);
821 }
822 
823 /**
824  * @title ERC721 Non-Fungible Token Standard basic interface
825  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
826  */
827 contract ERC721Basic is ERC165 {
828 
829   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
830   /*
831    * 0x80ac58cd ===
832    *   bytes4(keccak256('balanceOf(address)')) ^
833    *   bytes4(keccak256('ownerOf(uint256)')) ^
834    *   bytes4(keccak256('approve(address,uint256)')) ^
835    *   bytes4(keccak256('getApproved(uint256)')) ^
836    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
837    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
838    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
839    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
840    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
841    */
842 
843   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
844   /*
845    * 0x4f558e79 ===
846    *   bytes4(keccak256('exists(uint256)'))
847    */
848 
849   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
850   /**
851    * 0x780e9d63 ===
852    *   bytes4(keccak256('totalSupply()')) ^
853    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
854    *   bytes4(keccak256('tokenByIndex(uint256)'))
855    */
856 
857   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
858   /**
859    * 0x5b5e139f ===
860    *   bytes4(keccak256('name()')) ^
861    *   bytes4(keccak256('symbol()')) ^
862    *   bytes4(keccak256('tokenURI(uint256)'))
863    */
864 
865   event Transfer(
866     address indexed _from,
867     address indexed _to,
868     uint256 indexed _tokenId
869   );
870   event Approval(
871     address indexed _owner,
872     address indexed _approved,
873     uint256 indexed _tokenId
874   );
875   event ApprovalForAll(
876     address indexed _owner,
877     address indexed _operator,
878     bool _approved
879   );
880 
881   function balanceOf(address _owner) public view returns (uint256 _balance);
882   function ownerOf(uint256 _tokenId) public view returns (address _owner);
883   function exists(uint256 _tokenId) public view returns (bool _exists);
884 
885   function approve(address _to, uint256 _tokenId) public;
886   function getApproved(uint256 _tokenId)
887     public view returns (address _operator);
888 
889   function setApprovalForAll(address _operator, bool _approved) public;
890   function isApprovedForAll(address _owner, address _operator)
891     public view returns (bool);
892 
893   function transferFrom(address _from, address _to, uint256 _tokenId) public;
894   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
895     public;
896 
897   function safeTransferFrom(
898     address _from,
899     address _to,
900     uint256 _tokenId,
901     bytes _data
902   )
903     public;
904 }
905 
906 /**
907  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
908  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
909  */
910 contract ERC721Enumerable is ERC721Basic {
911   function totalSupply() public view returns (uint256);
912   function tokenOfOwnerByIndex(
913     address _owner,
914     uint256 _index
915   )
916     public
917     view
918     returns (uint256 _tokenId);
919 
920   function tokenByIndex(uint256 _index) public view returns (uint256);
921 }
922 
923 
924 /**
925  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
926  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
927  */
928 contract ERC721Metadata is ERC721Basic {
929   function name() external view returns (string _name);
930   function symbol() external view returns (string _symbol);
931   function tokenURI(uint256 _tokenId) public view returns (string);
932 }
933 
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
937  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
938  */
939 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
940 }
941 
942 /**
943  * @title ERC721 token receiver interface
944  * @dev Interface for any contract that wants to support safeTransfers
945  * from ERC721 asset contracts.
946  */
947 contract ERC721Receiver {
948   /**
949    * @dev Magic value to be returned upon successful reception of an NFT
950    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
951    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
952    */
953   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
954 
955   /**
956    * @notice Handle the receipt of an NFT
957    * @dev The ERC721 smart contract calls this function on the recipient
958    * after a `safetransfer`. This function MAY throw to revert and reject the
959    * transfer. Return of other than the magic value MUST result in the
960    * transaction being reverted.
961    * Note: the contract address is always the message sender.
962    * @param _operator The address which called `safeTransferFrom` function
963    * @param _from The address which previously owned the token
964    * @param _tokenId The NFT identifier which is being transferred
965    * @param _data Additional data with no specified format
966    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
967    */
968   function onERC721Received(
969     address _operator,
970     address _from,
971     uint256 _tokenId,
972     bytes _data
973   )
974     public
975     returns(bytes4);
976 }
977 
978 /**
979  * @title SafeMath
980  * @dev Math operations with safety checks that throw on error
981  */
982 library SafeMath {
983 
984   /**
985   * @dev Multiplies two numbers, throws on overflow.
986   */
987   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
988     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
989     // benefit is lost if 'b' is also tested.
990     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
991     if (_a == 0) {
992       return 0;
993     }
994 
995     c = _a * _b;
996     assert(c / _a == _b);
997     return c;
998   }
999 
1000   /**
1001   * @dev Integer division of two numbers, truncating the quotient.
1002   */
1003   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
1004     // assert(_b > 0); // Solidity automatically throws when dividing by 0
1005     // uint256 c = _a / _b;
1006     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
1007     return _a / _b;
1008   }
1009 
1010   /**
1011   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1012   */
1013   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
1014     assert(_b <= _a);
1015     return _a - _b;
1016   }
1017 
1018   /**
1019   * @dev Adds two numbers, throws on overflow.
1020   */
1021   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
1022     c = _a + _b;
1023     assert(c >= _a);
1024     return c;
1025   }
1026 }
1027 
1028 /**
1029  * Utility library of inline functions on addresses
1030  */
1031 library AddressUtils {
1032 
1033   /**
1034    * Returns whether the target address is a contract
1035    * @dev This function will return false if invoked during the constructor of a contract,
1036    * as the code is not actually created until after the constructor finishes.
1037    * @param _addr address to check
1038    * @return whether the target address is a contract
1039    */
1040   function isContract(address _addr) internal view returns (bool) {
1041     uint256 size;
1042     // XXX Currently there is no better way to check if there is a contract in an address
1043     // than to check the size of the code at that address.
1044     // See https://ethereum.stackexchange.com/a/14016/36603
1045     // for more details about how this works.
1046     // TODO Check this again before the Serenity release, because all addresses will be
1047     // contracts then.
1048     // solium-disable-next-line security/no-inline-assembly
1049     assembly { size := extcodesize(_addr) }
1050     return size > 0;
1051   }
1052 
1053 }
1054 
1055 /**
1056  * @title SupportsInterfaceWithLookup
1057  * @author Matt Condon (@shrugs)
1058  * @dev Implements ERC165 using a lookup table.
1059  */
1060 contract SupportsInterfaceWithLookup is ERC165 {
1061 
1062   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
1063   /**
1064    * 0x01ffc9a7 ===
1065    *   bytes4(keccak256('supportsInterface(bytes4)'))
1066    */
1067 
1068   /**
1069    * @dev a mapping of interface id to whether or not it's supported
1070    */
1071   mapping(bytes4 => bool) internal supportedInterfaces;
1072 
1073   /**
1074    * @dev A contract implementing SupportsInterfaceWithLookup
1075    * implement ERC165 itself
1076    */
1077   constructor()
1078     public
1079   {
1080     _registerInterface(InterfaceId_ERC165);
1081   }
1082 
1083   /**
1084    * @dev implement supportsInterface(bytes4) using a lookup table
1085    */
1086   function supportsInterface(bytes4 _interfaceId)
1087     external
1088     view
1089     returns (bool)
1090   {
1091     return supportedInterfaces[_interfaceId];
1092   }
1093 
1094   /**
1095    * @dev private method for registering an interface
1096    */
1097   function _registerInterface(bytes4 _interfaceId)
1098     internal
1099   {
1100     require(_interfaceId != 0xffffffff);
1101     supportedInterfaces[_interfaceId] = true;
1102   }
1103 }
1104 
1105 /**
1106  * @title ERC721 Non-Fungible Token Standard basic implementation
1107  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1108  */
1109 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
1110 
1111   using SafeMath for uint256;
1112   using AddressUtils for address;
1113 
1114   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1115   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1116   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
1117 
1118   // Mapping from token ID to owner
1119   mapping (uint256 => address) internal tokenOwner;
1120 
1121   // Mapping from token ID to approved address
1122   mapping (uint256 => address) internal tokenApprovals;
1123 
1124   // Mapping from owner to number of owned token
1125   mapping (address => uint256) internal ownedTokensCount;
1126 
1127   // Mapping from owner to operator approvals
1128   mapping (address => mapping (address => bool)) internal operatorApprovals;
1129 
1130   constructor()
1131     public
1132   {
1133     // register the supported interfaces to conform to ERC721 via ERC165
1134     _registerInterface(InterfaceId_ERC721);
1135     _registerInterface(InterfaceId_ERC721Exists);
1136   }
1137 
1138   /**
1139    * @dev Gets the balance of the specified address
1140    * @param _owner address to query the balance of
1141    * @return uint256 representing the amount owned by the passed address
1142    */
1143   function balanceOf(address _owner) public view returns (uint256) {
1144     require(_owner != address(0));
1145     return ownedTokensCount[_owner];
1146   }
1147 
1148   /**
1149    * @dev Gets the owner of the specified token ID
1150    * @param _tokenId uint256 ID of the token to query the owner of
1151    * @return owner address currently marked as the owner of the given token ID
1152    */
1153   function ownerOf(uint256 _tokenId) public view returns (address) {
1154     address owner = tokenOwner[_tokenId];
1155     require(owner != address(0));
1156     return owner;
1157   }
1158 
1159   /**
1160    * @dev Returns whether the specified token exists
1161    * @param _tokenId uint256 ID of the token to query the existence of
1162    * @return whether the token exists
1163    */
1164   function exists(uint256 _tokenId) public view returns (bool) {
1165     address owner = tokenOwner[_tokenId];
1166     return owner != address(0);
1167   }
1168 
1169   /**
1170    * @dev Approves another address to transfer the given token ID
1171    * The zero address indicates there is no approved address.
1172    * There can only be one approved address per token at a given time.
1173    * Can only be called by the token owner or an approved operator.
1174    * @param _to address to be approved for the given token ID
1175    * @param _tokenId uint256 ID of the token to be approved
1176    */
1177   function approve(address _to, uint256 _tokenId) public {
1178     address owner = ownerOf(_tokenId);
1179     require(_to != owner);
1180     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1181 
1182     tokenApprovals[_tokenId] = _to;
1183     emit Approval(owner, _to, _tokenId);
1184   }
1185 
1186   /**
1187    * @dev Gets the approved address for a token ID, or zero if no address set
1188    * @param _tokenId uint256 ID of the token to query the approval of
1189    * @return address currently approved for the given token ID
1190    */
1191   function getApproved(uint256 _tokenId) public view returns (address) {
1192     return tokenApprovals[_tokenId];
1193   }
1194 
1195   /**
1196    * @dev Sets or unsets the approval of a given operator
1197    * An operator is allowed to transfer all tokens of the sender on their behalf
1198    * @param _to operator address to set the approval
1199    * @param _approved representing the status of the approval to be set
1200    */
1201   function setApprovalForAll(address _to, bool _approved) public {
1202     require(_to != msg.sender);
1203     operatorApprovals[msg.sender][_to] = _approved;
1204     emit ApprovalForAll(msg.sender, _to, _approved);
1205   }
1206 
1207   /**
1208    * @dev Tells whether an operator is approved by a given owner
1209    * @param _owner owner address which you want to query the approval of
1210    * @param _operator operator address which you want to query the approval of
1211    * @return bool whether the given operator is approved by the given owner
1212    */
1213   function isApprovedForAll(
1214     address _owner,
1215     address _operator
1216   )
1217     public
1218     view
1219     returns (bool)
1220   {
1221     return operatorApprovals[_owner][_operator];
1222   }
1223 
1224   /**
1225    * @dev Transfers the ownership of a given token ID to another address
1226    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1227    * Requires the msg sender to be the owner, approved, or operator
1228    * @param _from current owner of the token
1229    * @param _to address to receive the ownership of the given token ID
1230    * @param _tokenId uint256 ID of the token to be transferred
1231   */
1232   function transferFrom(
1233     address _from,
1234     address _to,
1235     uint256 _tokenId
1236   )
1237     public
1238   {
1239     require(isApprovedOrOwner(msg.sender, _tokenId));
1240     require(_from != address(0));
1241     require(_to != address(0));
1242 
1243     clearApproval(_from, _tokenId);
1244     removeTokenFrom(_from, _tokenId);
1245     addTokenTo(_to, _tokenId);
1246 
1247     emit Transfer(_from, _to, _tokenId);
1248   }
1249 
1250   /**
1251    * @dev Safely transfers the ownership of a given token ID to another address
1252    * If the target address is a contract, it must implement `onERC721Received`,
1253    * which is called upon a safe transfer, and return the magic value
1254    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1255    * the transfer is reverted.
1256    *
1257    * Requires the msg sender to be the owner, approved, or operator
1258    * @param _from current owner of the token
1259    * @param _to address to receive the ownership of the given token ID
1260    * @param _tokenId uint256 ID of the token to be transferred
1261   */
1262   function safeTransferFrom(
1263     address _from,
1264     address _to,
1265     uint256 _tokenId
1266   )
1267     public
1268   {
1269     // solium-disable-next-line arg-overflow
1270     safeTransferFrom(_from, _to, _tokenId, "");
1271   }
1272 
1273   /**
1274    * @dev Safely transfers the ownership of a given token ID to another address
1275    * If the target address is a contract, it must implement `onERC721Received`,
1276    * which is called upon a safe transfer, and return the magic value
1277    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1278    * the transfer is reverted.
1279    * Requires the msg sender to be the owner, approved, or operator
1280    * @param _from current owner of the token
1281    * @param _to address to receive the ownership of the given token ID
1282    * @param _tokenId uint256 ID of the token to be transferred
1283    * @param _data bytes data to send along with a safe transfer check
1284    */
1285   function safeTransferFrom(
1286     address _from,
1287     address _to,
1288     uint256 _tokenId,
1289     bytes _data
1290   )
1291     public
1292   {
1293     transferFrom(_from, _to, _tokenId);
1294     // solium-disable-next-line arg-overflow
1295     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1296   }
1297 
1298   /**
1299    * @dev Returns whether the given spender can transfer a given token ID
1300    * @param _spender address of the spender to query
1301    * @param _tokenId uint256 ID of the token to be transferred
1302    * @return bool whether the msg.sender is approved for the given token ID,
1303    *  is an operator of the owner, or is the owner of the token
1304    */
1305   function isApprovedOrOwner(
1306     address _spender,
1307     uint256 _tokenId
1308   )
1309     internal
1310     view
1311     returns (bool)
1312   {
1313     address owner = ownerOf(_tokenId);
1314     // Disable solium check because of
1315     // https://github.com/duaraghav8/Solium/issues/175
1316     // solium-disable-next-line operator-whitespace
1317     return (
1318       _spender == owner ||
1319       getApproved(_tokenId) == _spender ||
1320       isApprovedForAll(owner, _spender)
1321     );
1322   }
1323 
1324   /**
1325    * @dev Internal function to mint a new token
1326    * Reverts if the given token ID already exists
1327    * @param _to The address that will own the minted token
1328    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1329    */
1330   function _mint(address _to, uint256 _tokenId) internal {
1331     require(_to != address(0));
1332     addTokenTo(_to, _tokenId);
1333     emit Transfer(address(0), _to, _tokenId);
1334   }
1335 
1336   /**
1337    * @dev Internal function to burn a specific token
1338    * Reverts if the token does not exist
1339    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1340    */
1341   function _burn(address _owner, uint256 _tokenId) internal {
1342     clearApproval(_owner, _tokenId);
1343     removeTokenFrom(_owner, _tokenId);
1344     emit Transfer(_owner, address(0), _tokenId);
1345   }
1346 
1347   /**
1348    * @dev Internal function to clear current approval of a given token ID
1349    * Reverts if the given address is not indeed the owner of the token
1350    * @param _owner owner of the token
1351    * @param _tokenId uint256 ID of the token to be transferred
1352    */
1353   function clearApproval(address _owner, uint256 _tokenId) internal {
1354     require(ownerOf(_tokenId) == _owner);
1355     if (tokenApprovals[_tokenId] != address(0)) {
1356       tokenApprovals[_tokenId] = address(0);
1357     }
1358   }
1359 
1360   /**
1361    * @dev Internal function to add a token ID to the list of a given address
1362    * @param _to address representing the new owner of the given token ID
1363    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1364    */
1365   function addTokenTo(address _to, uint256 _tokenId) internal {
1366     require(tokenOwner[_tokenId] == address(0));
1367     tokenOwner[_tokenId] = _to;
1368     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1369   }
1370 
1371   /**
1372    * @dev Internal function to remove a token ID from the list of a given address
1373    * @param _from address representing the previous owner of the given token ID
1374    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1375    */
1376   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1377     require(ownerOf(_tokenId) == _from);
1378     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1379     tokenOwner[_tokenId] = address(0);
1380   }
1381 
1382   /**
1383    * @dev Internal function to invoke `onERC721Received` on a target address
1384    * The call is not executed if the target address is not a contract
1385    * @param _from address representing the previous owner of the given token ID
1386    * @param _to target address that will receive the tokens
1387    * @param _tokenId uint256 ID of the token to be transferred
1388    * @param _data bytes optional data to send along with the call
1389    * @return whether the call correctly returned the expected magic value
1390    */
1391   function checkAndCallSafeTransfer(
1392     address _from,
1393     address _to,
1394     uint256 _tokenId,
1395     bytes _data
1396   )
1397     internal
1398     returns (bool)
1399   {
1400     if (!_to.isContract()) {
1401       return true;
1402     }
1403     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1404       msg.sender, _from, _tokenId, _data);
1405     return (retval == ERC721_RECEIVED);
1406   }
1407 }
1408 
1409 /**
1410  * @title Full ERC721 Token
1411  * This implementation includes all the required and some optional functionality of the ERC721 standard
1412  * Moreover, it includes approve all functionality using operator terminology
1413  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1414  */
1415 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1416 
1417   // Token name
1418   string internal name_;
1419 
1420   // Token symbol
1421   string internal symbol_;
1422 
1423   // Mapping from owner to list of owned token IDs
1424   mapping(address => uint256[]) internal ownedTokens;
1425 
1426   // Mapping from token ID to index of the owner tokens list
1427   mapping(uint256 => uint256) internal ownedTokensIndex;
1428 
1429   // Array with all token ids, used for enumeration
1430   uint256[] internal allTokens;
1431 
1432   // Mapping from token id to position in the allTokens array
1433   mapping(uint256 => uint256) internal allTokensIndex;
1434 
1435   // Optional mapping for token URIs
1436   mapping(uint256 => string) internal tokenURIs;
1437 
1438   /**
1439    * @dev Constructor function
1440    */
1441   constructor(string _name, string _symbol) public {
1442     name_ = _name;
1443     symbol_ = _symbol;
1444 
1445     // register the supported interfaces to conform to ERC721 via ERC165
1446     _registerInterface(InterfaceId_ERC721Enumerable);
1447     _registerInterface(InterfaceId_ERC721Metadata);
1448   }
1449 
1450   /**
1451    * @dev Gets the token name
1452    * @return string representing the token name
1453    */
1454   function name() external view returns (string) {
1455     return name_;
1456   }
1457 
1458   /**
1459    * @dev Gets the token symbol
1460    * @return string representing the token symbol
1461    */
1462   function symbol() external view returns (string) {
1463     return symbol_;
1464   }
1465 
1466   /**
1467    * @dev Returns an URI for a given token ID
1468    * Throws if the token ID does not exist. May return an empty string.
1469    * @param _tokenId uint256 ID of the token to query
1470    */
1471   function tokenURI(uint256 _tokenId) public view returns (string) {
1472     require(exists(_tokenId));
1473     return tokenURIs[_tokenId];
1474   }
1475 
1476   /**
1477    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1478    * @param _owner address owning the tokens list to be accessed
1479    * @param _index uint256 representing the index to be accessed of the requested tokens list
1480    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1481    */
1482   function tokenOfOwnerByIndex(
1483     address _owner,
1484     uint256 _index
1485   )
1486     public
1487     view
1488     returns (uint256)
1489   {
1490     require(_index < balanceOf(_owner));
1491     return ownedTokens[_owner][_index];
1492   }
1493 
1494   /**
1495    * @dev Gets the total amount of tokens stored by the contract
1496    * @return uint256 representing the total amount of tokens
1497    */
1498   function totalSupply() public view returns (uint256) {
1499     return allTokens.length;
1500   }
1501 
1502   /**
1503    * @dev Gets the token ID at a given index of all the tokens in this contract
1504    * Reverts if the index is greater or equal to the total number of tokens
1505    * @param _index uint256 representing the index to be accessed of the tokens list
1506    * @return uint256 token ID at the given index of the tokens list
1507    */
1508   function tokenByIndex(uint256 _index) public view returns (uint256) {
1509     require(_index < totalSupply());
1510     return allTokens[_index];
1511   }
1512 
1513   /**
1514    * @dev Internal function to set the token URI for a given token
1515    * Reverts if the token ID does not exist
1516    * @param _tokenId uint256 ID of the token to set its URI
1517    * @param _uri string URI to assign
1518    */
1519   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1520     require(exists(_tokenId));
1521     tokenURIs[_tokenId] = _uri;
1522   }
1523 
1524   /**
1525    * @dev Internal function to add a token ID to the list of a given address
1526    * @param _to address representing the new owner of the given token ID
1527    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1528    */
1529   function addTokenTo(address _to, uint256 _tokenId) internal {
1530     super.addTokenTo(_to, _tokenId);
1531     uint256 length = ownedTokens[_to].length;
1532     ownedTokens[_to].push(_tokenId);
1533     ownedTokensIndex[_tokenId] = length;
1534   }
1535 
1536   /**
1537    * @dev Internal function to remove a token ID from the list of a given address
1538    * @param _from address representing the previous owner of the given token ID
1539    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1540    */
1541   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1542     super.removeTokenFrom(_from, _tokenId);
1543 
1544     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1545     // then delete the last slot.
1546     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1547     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1548     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1549 
1550     ownedTokens[_from][tokenIndex] = lastToken;
1551     // This also deletes the contents at the last position of the array
1552     ownedTokens[_from].length--;
1553 
1554     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1555     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1556     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1557 
1558     ownedTokensIndex[_tokenId] = 0;
1559     ownedTokensIndex[lastToken] = tokenIndex;
1560   }
1561 
1562   /**
1563    * @dev Internal function to mint a new token
1564    * Reverts if the given token ID already exists
1565    * @param _to address the beneficiary that will own the minted token
1566    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1567    */
1568   function _mint(address _to, uint256 _tokenId) internal {
1569     super._mint(_to, _tokenId);
1570 
1571     allTokensIndex[_tokenId] = allTokens.length;
1572     allTokens.push(_tokenId);
1573   }
1574 
1575   /**
1576    * @dev Internal function to burn a specific token
1577    * Reverts if the token does not exist
1578    * @param _owner owner of the token to burn
1579    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1580    */
1581   function _burn(address _owner, uint256 _tokenId) internal {
1582     super._burn(_owner, _tokenId);
1583 
1584     // Clear metadata (if any)
1585     if (bytes(tokenURIs[_tokenId]).length != 0) {
1586       delete tokenURIs[_tokenId];
1587     }
1588 
1589     // Reorg all tokens array
1590     uint256 tokenIndex = allTokensIndex[_tokenId];
1591     uint256 lastTokenIndex = allTokens.length.sub(1);
1592     uint256 lastToken = allTokens[lastTokenIndex];
1593 
1594     allTokens[tokenIndex] = lastToken;
1595     allTokens[lastTokenIndex] = 0;
1596 
1597     allTokens.length--;
1598     allTokensIndex[_tokenId] = 0;
1599     allTokensIndex[lastToken] = tokenIndex;
1600   }
1601 
1602 }
1603 
1604 /// @title Contract for Chainbreakers Items (ERC721Token)
1605 /// @author Tobias Thiele - Qwellcode GmbH - www.qwellcode.de
1606 
1607 /*  HOSTFILE
1608 *   0 = 3D Model (*.glb)
1609 *   1 = Icon
1610 *   2 = Thumbnail
1611 *   3 = Transparent
1612 */
1613 
1614 /*  RARITY
1615 *   0 = Common
1616 *   1 = Uncommon
1617 *   2 = Rare
1618 *   3 = Epic
1619 *   4 = Legendary
1620 */
1621 
1622 /*  WEAPONS
1623 *   0 = Axe
1624 *   1 = Mace
1625 *   2 = Sword
1626 */
1627 
1628 /*  STATS
1629 *   0 = MQ - Motivational Quotient - Charisma
1630 *   1 = PQ - Physical Quotient - Vitality
1631 *   2 = IQ - Intelligence Quotient - Intellect
1632 *   3 = EQ - Experience Quotient - Wisdom
1633 *   4 = LQ - Learning Agility Quotient - Dexterity
1634 *   5 = TQ - Technical Quotient - Tactics
1635 */
1636 
1637 
1638 
1639 
1640 
1641 
1642 
1643 /** @dev used to manage payment in MANA */
1644 contract MANAInterface {
1645     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
1646     function approve(address _spender, uint256 _value) public returns (bool);
1647     function balanceOf(address _owner) public view returns (uint256);
1648     function transfer(address _to, uint256 _value) public returns (bool);
1649 }
1650 
1651 contract OwnableDelegateProxy { }
1652 
1653 contract ProxyRegistry {
1654     mapping(address => OwnableDelegateProxy) public proxies;
1655 }
1656 
1657 contract ChainbreakersItemsERC721 is ERC721Token("Chainbreakers Items", "CBI"), BasicAccessControl, randomRange {
1658 
1659     address proxyRegistryAddress;
1660 
1661     using SafeMath for uint256;
1662     using strings for *;
1663 
1664     uint256 public totalItems;
1665     uint256 public totalItemClass;
1666     uint256 public totalTokens;
1667     uint8 public currentGen;
1668 
1669     string _baseURI = "http://api.chainbreakers.io/api/v1/items/metadata?tokenId=";
1670 
1671 
1672     uint public presaleStart = 1541073600;
1673 
1674     // use as seed for random
1675     address private lastMinter;
1676 
1677     ItemClass[] private globalClasses;
1678 
1679     mapping(uint256 => ItemData) public tokenToData;
1680     mapping(uint256 => ItemClass) public classIdToClass;
1681 
1682     struct ItemClass {
1683         uint256 classId;
1684         string name;
1685         uint16 amount;
1686         string hostfile;
1687         uint16 minLevel;
1688         uint16 rarity;
1689         uint16 weapon;
1690         uint[] category;
1691         uint[] statsMin;
1692         uint[] statsMax;
1693         string desc;
1694         uint256 total;
1695         uint price;
1696         bool active;
1697     }
1698 
1699     struct ItemData {
1700         uint256 tokenId;
1701         uint256 classId;
1702         uint[] stats;
1703         uint8 gen;
1704     }
1705 
1706     event ItemMinted(uint classId, uint price, uint256 total, uint tokenId);
1707     event GenerationIncreased(uint8 currentGen);
1708     event OwnerPayed(uint amount);
1709     event OwnerPayedETH(uint amount);
1710 
1711     // declare interface for communication between smart contracts
1712     MANAInterface MANAContract;
1713 
1714     /* HELPER FUNCTIONS - START */
1715     /** @dev Concatenate two strings
1716       * @param _a The first string
1717       * @param _b The second string
1718       */
1719     function addToString(string _a, string _b) internal pure returns(string) {
1720         return _a.toSlice().concat(_b.toSlice());
1721     }
1722 
1723     /** @dev Converts an uint to a string
1724       * @notice used with addToString() to generate the tokenURI
1725       * @param i The uint you want to convert into a string
1726       */
1727     function uint2str(uint i) internal pure returns(string) {
1728         if (i == 0) return "0";
1729         uint j = i;
1730         uint length;
1731         while (j != 0){
1732             length++;
1733             j /= 10;
1734         }
1735         bytes memory bstr = new bytes(length);
1736         uint k = length - 1;
1737         while (i != 0){
1738             bstr[k--] = byte(48 + i % 10);
1739             i /= 10;
1740         }
1741         return string(bstr);
1742     }
1743     /* HELPER FUNCTIONS - END */
1744 
1745     constructor(address _proxyRegistryAddress) public {
1746         proxyRegistryAddress = _proxyRegistryAddress;
1747     }
1748 
1749     /** @dev changes the date of the start of the presale
1750       * @param _start Timestamp the presale starts
1751       */
1752     function changePresaleData(uint _start) public onlyModerators {
1753         presaleStart = _start;
1754     }
1755 
1756     /** @dev Used to init the communication between our contracts
1757       * @param _manaContractAddress The contract address for the currency you want to accept e.g. MANA
1758       */
1759     function setDatabase(address _manaContractAddress) public onlyModerators {
1760         MANAContract = MANAInterface(_manaContractAddress); // change to official MANA contract address alter (0x0f5d2fb29fb7d3cfee444a200298f468908cc942)
1761     }
1762 
1763     /** @dev changes the tokenURI of all minted items + the _baseURI value
1764       * @param _newBaseURI base url to the api which reads the meta data from the contract e.g. "http://api.chainbreakers.io/api/v1/items/metadata?tokenId="
1765       */
1766     function changeBaseURIAll(string _newBaseURI) public onlyModerators {
1767         _baseURI = _newBaseURI;
1768 
1769         for(uint a = 0; a < totalTokens; a++) {
1770             uint tokenId = tokenByIndex(a);
1771             _setTokenURI(tokenId, addToString(_newBaseURI, uint2str(tokenId)));
1772         }
1773     }
1774 
1775     /** @dev changes the _baseURI value
1776       * @param _newBaseURI base url to the api which reads the meta data from the contract e.g. "http://api.chainbreakers.io/api/v1/items/metadata?tokenId="
1777       */
1778     function changeBaseURI(string _newBaseURI) public onlyModerators {
1779         _baseURI = _newBaseURI;
1780     }
1781 
1782     /** @dev changes the active state of an item class by its class id
1783       * @param _classId calss id of the item class
1784       * @param _active active state of the item class
1785       */
1786     function editActiveFromClassId(uint256 _classId, bool _active) public onlyModerators {
1787         ItemClass storage _itemClass = classIdToClass[_classId];
1788         _itemClass.active = _active;
1789     }
1790 
1791     /** @dev Adds an item to the contract which can be minted by the user paying the selected currency (MANA)
1792       * @notice You will find a list of the meanings of the individual indexes on top of the document
1793       * @param _name The name of the item
1794       * @param _rarity Defines the rarity on an item
1795       * @param _weapon Defines which weapon this item is
1796       * @param _statsMin An array of integers of the lowest stats an item can have
1797       * @param _statsMax An array of integers of the highest stats an item can have
1798       * @param _amount Defines how many items can be minted in general
1799       * @param _hostfile A string contains links to the 3D object, the icon and the thumbnail
1800       * @notice All links inside the _hostfile string has to be seperated by commas. Use `.split(",")` to get an array in frontend
1801       * @param _minLevel The lowest level a unit has to be to equip this item
1802       * @param _desc An optional item description used for legendary items mostly
1803       * @param _price The price of the item
1804       */
1805     function addItemWithClassAndData(string _name, uint16 _rarity, uint16 _weapon, uint[] _statsMin, uint[] _statsMax, uint16 _amount, string _hostfile, uint16 _minLevel, string _desc, uint _price) public onlyModerators {
1806         ItemClass storage _itemClass = classIdToClass[totalItemClass];
1807         _itemClass.classId = totalItemClass;
1808         _itemClass.name = _name;
1809         _itemClass.amount = _amount;
1810         _itemClass.rarity = _rarity;
1811         _itemClass.weapon = _weapon;
1812         _itemClass.statsMin = _statsMin;
1813         _itemClass.statsMax = _statsMax;
1814         _itemClass.hostfile = _hostfile;
1815         _itemClass.minLevel = _minLevel;
1816         _itemClass.desc = _desc;
1817         _itemClass.total = 0;
1818         _itemClass.price = _price;
1819         _itemClass.active = true;
1820 
1821         totalItemClass = globalClasses.push(_itemClass);
1822 
1823         totalItems++;
1824     }
1825 
1826     /** @dev The function the user calls to buy the selected item for a given price
1827       * @notice The price of the items increases after each bought item by a given amount
1828       * @param _classId The class id of the item which the user wants to buy
1829       */
1830     function buyItem(uint256 _classId) public {
1831         require(now > presaleStart, "The presale is not started yet");
1832 
1833         ItemClass storage class = classIdToClass[_classId];
1834         require(class.active == true, "This item is not for sale");
1835         require(class.amount > 0);
1836 
1837         require(class.total < class.amount, "Sold out");
1838         require(class.statsMin.length == class.statsMax.length);
1839 
1840         if (class.price > 0) {
1841             require(MANAContract != address(0), "Invalid contract address for MANA. Please use the setDatabase() function first.");
1842             require(MANAContract.transferFrom(msg.sender, address(this), class.price) == true, "Failed transfering MANA");
1843         }
1844 
1845         _mintItem(_classId, msg.sender);
1846     }
1847 
1848     /** @dev This function mints the item on the blockchain and generates an ERC721 token
1849       * @notice All stats of the item are randomly generated by using the getRandom() function using min and max values
1850       * @param _classId The class id of the item which one will be minted
1851       * @param _address The address of the owner of the new item
1852       */
1853     function _mintItem(uint256 _classId, address _address) internal {
1854         ItemClass storage class = classIdToClass[_classId];
1855         uint[] memory stats = new uint[](6);
1856         for(uint j = 0; j < class.statsMin.length; j++) {
1857             if (class.statsMax[j] > 0) {
1858                 if (stats.length == class.statsMin.length) {
1859                     stats[j] = getRandom(class.statsMin[j], class.statsMax[j], uint8(j + _classId + class.total), lastMinter);
1860                 }
1861             } else {
1862                 if (stats.length == class.statsMin.length) {
1863                     stats[j] = 0;
1864                 }
1865             }
1866         }
1867 
1868         ItemData storage _itemData = tokenToData[totalTokens + 1];
1869         _itemData.tokenId = totalTokens + 1;
1870         _itemData.classId = _classId;
1871         _itemData.stats = stats;
1872         _itemData.gen = currentGen;
1873 
1874         class.total += 1;
1875         totalTokens += 1;
1876         _mint(_address, totalTokens);
1877         _setTokenURI(totalTokens, addToString(_baseURI, uint2str(totalTokens)));
1878 
1879         lastMinter = _address;
1880 
1881         emit ItemMinted(class.classId, class.price, class.total, totalTokens);
1882     }
1883 
1884     /** @dev Gets the min and the max range of stats a given class id can have
1885       * @param _classId The class id of the item you want to return the stats of
1886       * @return statsMin An array of the lowest stats the given item can have
1887       * @return statsMax An array of the highest stats the given item can have
1888       */
1889     function getStatsRange(uint256 _classId) public view returns(uint[] statsMin, uint[] statsMax) {
1890         return (classIdToClass[_classId].statsMin, classIdToClass[_classId].statsMax);
1891     }
1892 
1893     /** @dev Gets information about the item stands behind the given token
1894       * @param _tokenId The id of the token you want to get the item data from
1895       * @return tokenId The id of the token
1896       * @return classId The class id of the item behind the token
1897       * @return stats The randomly generated stats of the item behind the token
1898       * @return gen The generation of the item
1899       */
1900     function getItemDataByToken(uint256 _tokenId) public view returns(uint256 tokenId, uint256 classId, uint[] stats, uint8 gen) {
1901         return (tokenToData[_tokenId].tokenId, tokenToData[_tokenId].classId, tokenToData[_tokenId].stats, tokenToData[_tokenId].gen);
1902     }
1903 
1904     /** @dev Returns information about the item category of the given class id
1905       * @param _classId The class id of the item you want to return the stats of
1906       * @return classId The class id of the item
1907       * @return category An array contains information about the category of the item
1908       */
1909     function getItemCategory(uint256 _classId) public view returns(uint256 classId, uint[] category) {
1910         return (classIdToClass[_classId].classId, classIdToClass[_classId].category);
1911     }
1912 
1913     /** @dev Edits the item class
1914       * @param _classId The class id of the item you want to edit
1915       * @param _name The name of the item
1916       * @param _rarity Defines the rarity on an item
1917       * @param _weapon Defines which weapon this item is
1918       * @param _statsMin An array of integers of the lowest stats an item can have
1919       * @param _statsMax An array of integers of the highest stats an item can have
1920       * @param _amount Defines how many items can be minted in general
1921       * @param _hostfile A string contains links to the 3D object, the icon and the thumbnail
1922       * @notice All links inside the _hostfile string has to be seperated by commas. Use `.split(",")` to get an array in frontend
1923       * @param _minLevel The lowest level a unit has to be to equip this item
1924       * @param _desc An optional item description used for legendary items mostly
1925       * @param _price The price of the item
1926       */
1927     function editClass(uint256 _classId, string _name, uint16 _rarity, uint16 _weapon, uint[] _statsMin, uint[] _statsMax, uint16 _amount, string _hostfile, uint16 _minLevel, string _desc, uint _price) public onlyModerators {
1928         ItemClass storage _itemClass = classIdToClass[_classId];
1929         _itemClass.name = _name;
1930         _itemClass.rarity = _rarity;
1931         _itemClass.weapon = _weapon;
1932         _itemClass.statsMin = _statsMin;
1933         _itemClass.statsMax = _statsMax;
1934         _itemClass.amount = _amount;
1935         _itemClass.hostfile = _hostfile;
1936         _itemClass.minLevel = _minLevel;
1937         _itemClass.desc = _desc;
1938         _itemClass.price = _price;
1939     }
1940 
1941     /** @dev Returns a count of created item classes
1942       * @return totalClasses Integer of how many items are able to be minted
1943       */
1944     function countItemsByClass() public view returns(uint totalClasses) {
1945         return (globalClasses.length);
1946     }
1947 
1948     /** @dev This function mints an item as a quest reward. The quest contract needs to be added as a moderator
1949       * @param _classId The id of the item should be minted
1950       * @param _address The address of the future owner of the minted item
1951       */
1952     function mintItemFromQuest(uint256 _classId, address _address) public onlyModerators {
1953         _mintItem(_classId, _address);
1954     }
1955 
1956     /** @dev Changes the tokenURI from a minted item by its tokenId
1957       * @param _tokenId The id of the token
1958       * @param _uri The new URI of the token for metadata e.g. http://api.chainbreakers.io/api/v1/items/metadata?tokenId=TOKEN_ID
1959       */
1960     function changeURIFromTokenByTokenId(uint256 _tokenId, string _uri) public onlyModerators {
1961         _setTokenURI(_tokenId, _uri);
1962     }
1963 
1964     function increaseGen() public onlyModerators {
1965         currentGen += 1;
1966 
1967         emit GenerationIncreased(currentGen);
1968     }
1969 
1970     /** @dev Function to get a given amount of MANA from this contract.
1971       * @param _amount The amount of coins you want to get from this contract.
1972       */
1973     function payOwner(uint _amount) public onlyOwner {
1974         MANAContract.transfer(msg.sender, _amount);
1975         emit OwnerPayed(_amount);
1976     }
1977 
1978     /** @dev Returns all MANA from this contract to the owner of the contract. */
1979     function payOwnerAll() public onlyOwner {
1980         uint tokens = MANAContract.balanceOf(address(this));
1981         MANAContract.transfer(msg.sender, tokens);
1982         emit OwnerPayed(tokens);
1983     }
1984 
1985     /** @dev Function to get a given amount of ETH from this contract.
1986       * @param _amount The amount of coins you want to get from this contract.
1987       */
1988     function payOwnerETH(uint _amount) public onlyOwner {
1989         msg.sender.transfer(_amount);
1990         emit OwnerPayedETH(_amount);
1991     }
1992 
1993     /** @dev Returns all ETH from this contract to the owner of the contract. */
1994     function payOwnerAllETH() public onlyOwner {
1995         uint balance = address(this).balance;
1996         msg.sender.transfer(balance);
1997         emit OwnerPayedETH(balance);
1998     }
1999 
2000     function isApprovedForAll(address owner, address operator) public view returns (bool) {
2001         // Whitelist OpenSea proxy contract for easy trading.
2002         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
2003         if (proxyRegistry.proxies(owner) == operator) {
2004             return true;
2005         }
2006 
2007         return super.isApprovedForAll(owner, operator);
2008     }
2009 }