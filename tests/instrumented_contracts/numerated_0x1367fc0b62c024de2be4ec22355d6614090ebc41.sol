1 pragma solidity ^0.4.18;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/strings.sol
46 
47 /*
48  * @title String & slice utility library for Solidity contracts.
49  * @author Nick Johnson <arachnid@notdot.net>
50  *
51  * @dev Functionality in this library is largely implemented using an
52  *      abstraction called a 'slice'. A slice represents a part of a string -
53  *      anything from the entire string to a single character, or even no
54  *      characters at all (a 0-length slice). Since a slice only has to specify
55  *      an offset and a length, copying and manipulating slices is a lot less
56  *      expensive than copying and manipulating the strings they reference.
57  *
58  *      To further reduce gas costs, most functions on slice that need to return
59  *      a slice modify the original one instead of allocating a new one; for
60  *      instance, `s.split(".")` will return the text up to the first '.',
61  *      modifying s to only contain the remainder of the string after the '.'.
62  *      In situations where you do not want to modify the original slice, you
63  *      can make a copy first with `.copy()`, for example:
64  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
65  *      Solidity has no memory management, it will result in allocating many
66  *      short-lived slices that are later discarded.
67  *
68  *      Functions that return two slices come in two versions: a non-allocating
69  *      version that takes the second slice as an argument, modifying it in
70  *      place, and an allocating version that allocates and returns the second
71  *      slice; see `nextRune` for example.
72  *
73  *      Functions that have to copy string data will return strings rather than
74  *      slices; these can be cast back to slices for further processing if
75  *      required.
76  *
77  *      For convenience, some functions are provided with non-modifying
78  *      variants that create a new slice and return both; for instance,
79  *      `s.splitNew('.')` leaves s unmodified, and returns two values
80  *      corresponding to the left and right parts of the string.
81  */
82 
83 pragma solidity ^0.4.14;
84 
85 library strings {
86     struct slice {
87         uint _len;
88         uint _ptr;
89     }
90 
91     function memcpy(uint dest, uint src, uint len) private pure {
92         // Copy word-length chunks while possible
93         for(; len >= 32; len -= 32) {
94             assembly {
95                 mstore(dest, mload(src))
96             }
97             dest += 32;
98             src += 32;
99         }
100 
101         // Copy remaining bytes
102         uint mask = 256 ** (32 - len) - 1;
103         assembly {
104             let srcpart := and(mload(src), not(mask))
105             let destpart := and(mload(dest), mask)
106             mstore(dest, or(destpart, srcpart))
107         }
108     }
109 
110     /*
111      * @dev Returns a slice containing the entire string.
112      * @param self The string to make a slice from.
113      * @return A newly allocated slice containing the entire string.
114      */
115     function toSlice(string self) internal pure returns (slice) {
116         uint ptr;
117         assembly {
118             ptr := add(self, 0x20)
119         }
120         return slice(bytes(self).length, ptr);
121     }
122 
123     /*
124      * @dev Returns the length of a null-terminated bytes32 string.
125      * @param self The value to find the length of.
126      * @return The length of the string, from 0 to 32.
127      */
128     function len(bytes32 self) internal pure returns (uint) {
129         uint ret;
130         if (self == 0)
131             return 0;
132         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
133             ret += 16;
134             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
135         }
136         if (self & 0xffffffffffffffff == 0) {
137             ret += 8;
138             self = bytes32(uint(self) / 0x10000000000000000);
139         }
140         if (self & 0xffffffff == 0) {
141             ret += 4;
142             self = bytes32(uint(self) / 0x100000000);
143         }
144         if (self & 0xffff == 0) {
145             ret += 2;
146             self = bytes32(uint(self) / 0x10000);
147         }
148         if (self & 0xff == 0) {
149             ret += 1;
150         }
151         return 32 - ret;
152     }
153 
154     /*
155      * @dev Returns a slice containing the entire bytes32, interpreted as a
156      *      null-terminated utf-8 string.
157      * @param self The bytes32 value to convert to a slice.
158      * @return A new slice containing the value of the input argument up to the
159      *         first null.
160      */
161     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
162         // Allocate space for `self` in memory, copy it there, and point ret at it
163         assembly {
164             let ptr := mload(0x40)
165             mstore(0x40, add(ptr, 0x20))
166             mstore(ptr, self)
167             mstore(add(ret, 0x20), ptr)
168         }
169         ret._len = len(self);
170     }
171 
172     /*
173      * @dev Returns a new slice containing the same data as the current slice.
174      * @param self The slice to copy.
175      * @return A new slice containing the same data as `self`.
176      */
177     function copy(slice self) internal pure returns (slice) {
178         return slice(self._len, self._ptr);
179     }
180 
181     /*
182      * @dev Copies a slice to a new string.
183      * @param self The slice to copy.
184      * @return A newly allocated string containing the slice's text.
185      */
186     function toString(slice self) internal pure returns (string) {
187         string memory ret = new string(self._len);
188         uint retptr;
189         assembly { retptr := add(ret, 32) }
190 
191         memcpy(retptr, self._ptr, self._len);
192         return ret;
193     }
194 
195     /*
196      * @dev Returns the length in runes of the slice. Note that this operation
197      *      takes time proportional to the length of the slice; avoid using it
198      *      in loops, and call `slice.empty()` if you only need to know whether
199      *      the slice is empty or not.
200      * @param self The slice to operate on.
201      * @return The length of the slice in runes.
202      */
203     function len(slice self) internal pure returns (uint l) {
204         // Starting at ptr-31 means the LSB will be the byte we care about
205         uint ptr = self._ptr - 31;
206         uint end = ptr + self._len;
207         for (l = 0; ptr < end; l++) {
208             uint8 b;
209             assembly { b := and(mload(ptr), 0xFF) }
210             if (b < 0x80) {
211                 ptr += 1;
212             } else if(b < 0xE0) {
213                 ptr += 2;
214             } else if(b < 0xF0) {
215                 ptr += 3;
216             } else if(b < 0xF8) {
217                 ptr += 4;
218             } else if(b < 0xFC) {
219                 ptr += 5;
220             } else {
221                 ptr += 6;
222             }
223         }
224     }
225 
226     /*
227      * @dev Returns true if the slice is empty (has a length of 0).
228      * @param self The slice to operate on.
229      * @return True if the slice is empty, False otherwise.
230      */
231     function empty(slice self) internal pure returns (bool) {
232         return self._len == 0;
233     }
234 
235     /*
236      * @dev Returns a positive number if `other` comes lexicographically after
237      *      `self`, a negative number if it comes before, or zero if the
238      *      contents of the two slices are equal. Comparison is done per-rune,
239      *      on unicode codepoints.
240      * @param self The first slice to compare.
241      * @param other The second slice to compare.
242      * @return The result of the comparison.
243      */
244     function compare(slice self, slice other) internal pure returns (int) {
245         uint shortest = self._len;
246         if (other._len < self._len)
247             shortest = other._len;
248 
249         uint selfptr = self._ptr;
250         uint otherptr = other._ptr;
251         for (uint idx = 0; idx < shortest; idx += 32) {
252             uint a;
253             uint b;
254             assembly {
255                 a := mload(selfptr)
256                 b := mload(otherptr)
257             }
258             if (a != b) {
259                 // Mask out irrelevant bytes and check again
260                 uint256 mask = uint256(-1); // 0xffff...
261                 if(shortest < 32) {
262                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
263                 }
264                 uint256 diff = (a & mask) - (b & mask);
265                 if (diff != 0)
266                     return int(diff);
267             }
268             selfptr += 32;
269             otherptr += 32;
270         }
271         return int(self._len) - int(other._len);
272     }
273 
274     /*
275      * @dev Returns true if the two slices contain the same text.
276      * @param self The first slice to compare.
277      * @param self The second slice to compare.
278      * @return True if the slices are equal, false otherwise.
279      */
280     function equals(slice self, slice other) internal pure returns (bool) {
281         return compare(self, other) == 0;
282     }
283 
284     /*
285      * @dev Extracts the first rune in the slice into `rune`, advancing the
286      *      slice to point to the next rune and returning `self`.
287      * @param self The slice to operate on.
288      * @param rune The slice that will contain the first rune.
289      * @return `rune`.
290      */
291     function nextRune(slice self, slice rune) internal pure returns (slice) {
292         rune._ptr = self._ptr;
293 
294         if (self._len == 0) {
295             rune._len = 0;
296             return rune;
297         }
298 
299         uint l;
300         uint b;
301         // Load the first byte of the rune into the LSBs of b
302         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
303         if (b < 0x80) {
304             l = 1;
305         } else if(b < 0xE0) {
306             l = 2;
307         } else if(b < 0xF0) {
308             l = 3;
309         } else {
310             l = 4;
311         }
312 
313         // Check for truncated codepoints
314         if (l > self._len) {
315             rune._len = self._len;
316             self._ptr += self._len;
317             self._len = 0;
318             return rune;
319         }
320 
321         self._ptr += l;
322         self._len -= l;
323         rune._len = l;
324         return rune;
325     }
326 
327     /*
328      * @dev Returns the first rune in the slice, advancing the slice to point
329      *      to the next rune.
330      * @param self The slice to operate on.
331      * @return A slice containing only the first rune from `self`.
332      */
333     function nextRune(slice self) internal pure returns (slice ret) {
334         nextRune(self, ret);
335     }
336 
337     /*
338      * @dev Returns the number of the first codepoint in the slice.
339      * @param self The slice to operate on.
340      * @return The number of the first codepoint in the slice.
341      */
342     function ord(slice self) internal pure returns (uint ret) {
343         if (self._len == 0) {
344             return 0;
345         }
346 
347         uint word;
348         uint length;
349         uint divisor = 2 ** 248;
350 
351         // Load the rune into the MSBs of b
352         assembly { word:= mload(mload(add(self, 32))) }
353         uint b = word / divisor;
354         if (b < 0x80) {
355             ret = b;
356             length = 1;
357         } else if(b < 0xE0) {
358             ret = b & 0x1F;
359             length = 2;
360         } else if(b < 0xF0) {
361             ret = b & 0x0F;
362             length = 3;
363         } else {
364             ret = b & 0x07;
365             length = 4;
366         }
367 
368         // Check for truncated codepoints
369         if (length > self._len) {
370             return 0;
371         }
372 
373         for (uint i = 1; i < length; i++) {
374             divisor = divisor / 256;
375             b = (word / divisor) & 0xFF;
376             if (b & 0xC0 != 0x80) {
377                 // Invalid UTF-8 sequence
378                 return 0;
379             }
380             ret = (ret * 64) | (b & 0x3F);
381         }
382 
383         return ret;
384     }
385 
386     /*
387      * @dev Returns the keccak-256 hash of the slice.
388      * @param self The slice to hash.
389      * @return The hash of the slice.
390      */
391     function keccak(slice self) internal pure returns (bytes32 ret) {
392         assembly {
393             ret := keccak256(mload(add(self, 32)), mload(self))
394         }
395     }
396 
397     /*
398      * @dev Returns true if `self` starts with `needle`.
399      * @param self The slice to operate on.
400      * @param needle The slice to search for.
401      * @return True if the slice starts with the provided text, false otherwise.
402      */
403     function startsWith(slice self, slice needle) internal pure returns (bool) {
404         if (self._len < needle._len) {
405             return false;
406         }
407 
408         if (self._ptr == needle._ptr) {
409             return true;
410         }
411 
412         bool equal;
413         assembly {
414             let length := mload(needle)
415             let selfptr := mload(add(self, 0x20))
416             let needleptr := mload(add(needle, 0x20))
417             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
418         }
419         return equal;
420     }
421 
422     /*
423      * @dev If `self` starts with `needle`, `needle` is removed from the
424      *      beginning of `self`. Otherwise, `self` is unmodified.
425      * @param self The slice to operate on.
426      * @param needle The slice to search for.
427      * @return `self`
428      */
429     function beyond(slice self, slice needle) internal pure returns (slice) {
430         if (self._len < needle._len) {
431             return self;
432         }
433 
434         bool equal = true;
435         if (self._ptr != needle._ptr) {
436             assembly {
437                 let length := mload(needle)
438                 let selfptr := mload(add(self, 0x20))
439                 let needleptr := mload(add(needle, 0x20))
440                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
441             }
442         }
443 
444         if (equal) {
445             self._len -= needle._len;
446             self._ptr += needle._len;
447         }
448 
449         return self;
450     }
451 
452     /*
453      * @dev Returns true if the slice ends with `needle`.
454      * @param self The slice to operate on.
455      * @param needle The slice to search for.
456      * @return True if the slice starts with the provided text, false otherwise.
457      */
458     function endsWith(slice self, slice needle) internal pure returns (bool) {
459         if (self._len < needle._len) {
460             return false;
461         }
462 
463         uint selfptr = self._ptr + self._len - needle._len;
464 
465         if (selfptr == needle._ptr) {
466             return true;
467         }
468 
469         bool equal;
470         assembly {
471             let length := mload(needle)
472             let needleptr := mload(add(needle, 0x20))
473             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
474         }
475 
476         return equal;
477     }
478 
479     /*
480      * @dev If `self` ends with `needle`, `needle` is removed from the
481      *      end of `self`. Otherwise, `self` is unmodified.
482      * @param self The slice to operate on.
483      * @param needle The slice to search for.
484      * @return `self`
485      */
486     function until(slice self, slice needle) internal pure returns (slice) {
487         if (self._len < needle._len) {
488             return self;
489         }
490 
491         uint selfptr = self._ptr + self._len - needle._len;
492         bool equal = true;
493         if (selfptr != needle._ptr) {
494             assembly {
495                 let length := mload(needle)
496                 let needleptr := mload(add(needle, 0x20))
497                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
498             }
499         }
500 
501         if (equal) {
502             self._len -= needle._len;
503         }
504 
505         return self;
506     }
507 
508     event log_bytemask(bytes32 mask);
509 
510     // Returns the memory address of the first byte of the first occurrence of
511     // `needle` in `self`, or the first byte after `self` if not found.
512     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
513         uint ptr = selfptr;
514         uint idx;
515 
516         if (needlelen <= selflen) {
517             if (needlelen <= 32) {
518                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
519 
520                 bytes32 needledata;
521                 assembly { needledata := and(mload(needleptr), mask) }
522 
523                 uint end = selfptr + selflen - needlelen;
524                 bytes32 ptrdata;
525                 assembly { ptrdata := and(mload(ptr), mask) }
526 
527                 while (ptrdata != needledata) {
528                     if (ptr >= end)
529                         return selfptr + selflen;
530                     ptr++;
531                     assembly { ptrdata := and(mload(ptr), mask) }
532                 }
533                 return ptr;
534             } else {
535                 // For long needles, use hashing
536                 bytes32 hash;
537                 assembly { hash := sha3(needleptr, needlelen) }
538 
539                 for (idx = 0; idx <= selflen - needlelen; idx++) {
540                     bytes32 testHash;
541                     assembly { testHash := sha3(ptr, needlelen) }
542                     if (hash == testHash)
543                         return ptr;
544                     ptr += 1;
545                 }
546             }
547         }
548         return selfptr + selflen;
549     }
550 
551     // Returns the memory address of the first byte after the last occurrence of
552     // `needle` in `self`, or the address of `self` if not found.
553     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
554         uint ptr;
555 
556         if (needlelen <= selflen) {
557             if (needlelen <= 32) {
558                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
559 
560                 bytes32 needledata;
561                 assembly { needledata := and(mload(needleptr), mask) }
562 
563                 ptr = selfptr + selflen - needlelen;
564                 bytes32 ptrdata;
565                 assembly { ptrdata := and(mload(ptr), mask) }
566 
567                 while (ptrdata != needledata) {
568                     if (ptr <= selfptr)
569                         return selfptr;
570                     ptr--;
571                     assembly { ptrdata := and(mload(ptr), mask) }
572                 }
573                 return ptr + needlelen;
574             } else {
575                 // For long needles, use hashing
576                 bytes32 hash;
577                 assembly { hash := sha3(needleptr, needlelen) }
578                 ptr = selfptr + (selflen - needlelen);
579                 while (ptr >= selfptr) {
580                     bytes32 testHash;
581                     assembly { testHash := sha3(ptr, needlelen) }
582                     if (hash == testHash)
583                         return ptr + needlelen;
584                     ptr -= 1;
585                 }
586             }
587         }
588         return selfptr;
589     }
590 
591     /*
592      * @dev Modifies `self` to contain everything from the first occurrence of
593      *      `needle` to the end of the slice. `self` is set to the empty slice
594      *      if `needle` is not found.
595      * @param self The slice to search and modify.
596      * @param needle The text to search for.
597      * @return `self`.
598      */
599     function find(slice self, slice needle) internal pure returns (slice) {
600         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
601         self._len -= ptr - self._ptr;
602         self._ptr = ptr;
603         return self;
604     }
605 
606     /*
607      * @dev Modifies `self` to contain the part of the string from the start of
608      *      `self` to the end of the first occurrence of `needle`. If `needle`
609      *      is not found, `self` is set to the empty slice.
610      * @param self The slice to search and modify.
611      * @param needle The text to search for.
612      * @return `self`.
613      */
614     function rfind(slice self, slice needle) internal pure returns (slice) {
615         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
616         self._len = ptr - self._ptr;
617         return self;
618     }
619 
620     /*
621      * @dev Splits the slice, setting `self` to everything after the first
622      *      occurrence of `needle`, and `token` to everything before it. If
623      *      `needle` does not occur in `self`, `self` is set to the empty slice,
624      *      and `token` is set to the entirety of `self`.
625      * @param self The slice to split.
626      * @param needle The text to search for in `self`.
627      * @param token An output parameter to which the first token is written.
628      * @return `token`.
629      */
630     function split(slice self, slice needle, slice token) internal pure returns (slice) {
631         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
632         token._ptr = self._ptr;
633         token._len = ptr - self._ptr;
634         if (ptr == self._ptr + self._len) {
635             // Not found
636             self._len = 0;
637         } else {
638             self._len -= token._len + needle._len;
639             self._ptr = ptr + needle._len;
640         }
641         return token;
642     }
643 
644     /*
645      * @dev Splits the slice, setting `self` to everything after the first
646      *      occurrence of `needle`, and returning everything before it. If
647      *      `needle` does not occur in `self`, `self` is set to the empty slice,
648      *      and the entirety of `self` is returned.
649      * @param self The slice to split.
650      * @param needle The text to search for in `self`.
651      * @return The part of `self` up to the first occurrence of `delim`.
652      */
653     function split(slice self, slice needle) internal pure returns (slice token) {
654         split(self, needle, token);
655     }
656 
657     /*
658      * @dev Splits the slice, setting `self` to everything before the last
659      *      occurrence of `needle`, and `token` to everything after it. If
660      *      `needle` does not occur in `self`, `self` is set to the empty slice,
661      *      and `token` is set to the entirety of `self`.
662      * @param self The slice to split.
663      * @param needle The text to search for in `self`.
664      * @param token An output parameter to which the first token is written.
665      * @return `token`.
666      */
667     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
668         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
669         token._ptr = ptr;
670         token._len = self._len - (ptr - self._ptr);
671         if (ptr == self._ptr) {
672             // Not found
673             self._len = 0;
674         } else {
675             self._len -= token._len + needle._len;
676         }
677         return token;
678     }
679 
680     /*
681      * @dev Splits the slice, setting `self` to everything before the last
682      *      occurrence of `needle`, and returning everything after it. If
683      *      `needle` does not occur in `self`, `self` is set to the empty slice,
684      *      and the entirety of `self` is returned.
685      * @param self The slice to split.
686      * @param needle The text to search for in `self`.
687      * @return The part of `self` after the last occurrence of `delim`.
688      */
689     function rsplit(slice self, slice needle) internal pure returns (slice token) {
690         rsplit(self, needle, token);
691     }
692 
693     /*
694      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
695      * @param self The slice to search.
696      * @param needle The text to search for in `self`.
697      * @return The number of occurrences of `needle` found in `self`.
698      */
699     function count(slice self, slice needle) internal pure returns (uint cnt) {
700         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
701         while (ptr <= self._ptr + self._len) {
702             cnt++;
703             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
704         }
705     }
706 
707     /*
708      * @dev Returns True if `self` contains `needle`.
709      * @param self The slice to search.
710      * @param needle The text to search for in `self`.
711      * @return True if `needle` is found in `self`, false otherwise.
712      */
713     function contains(slice self, slice needle) internal pure returns (bool) {
714         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
715     }
716 
717     /*
718      * @dev Returns a newly allocated string containing the concatenation of
719      *      `self` and `other`.
720      * @param self The first slice to concatenate.
721      * @param other The second slice to concatenate.
722      * @return The concatenation of the two strings.
723      */
724     function concat(slice self, slice other) internal pure returns (string) {
725         string memory ret = new string(self._len + other._len);
726         uint retptr;
727         assembly { retptr := add(ret, 32) }
728         memcpy(retptr, self._ptr, self._len);
729         memcpy(retptr + self._len, other._ptr, other._len);
730         return ret;
731     }
732 
733     /*
734      * @dev Joins an array of slices, using `self` as a delimiter, returning a
735      *      newly allocated string.
736      * @param self The delimiter to use.
737      * @param parts A list of slices to join.
738      * @return A newly allocated string containing all the slices in `parts`,
739      *         joined with `self`.
740      */
741     function join(slice self, slice[] parts) internal pure returns (string) {
742         if (parts.length == 0)
743             return "";
744 
745         uint length = self._len * (parts.length - 1);
746         for(uint i = 0; i < parts.length; i++)
747             length += parts[i]._len;
748 
749         string memory ret = new string(length);
750         uint retptr;
751         assembly { retptr := add(ret, 32) }
752 
753         for(i = 0; i < parts.length; i++) {
754             memcpy(retptr, parts[i]._ptr, parts[i]._len);
755             retptr += parts[i]._len;
756             if (i < parts.length - 1) {
757                 memcpy(retptr, self._ptr, self._len);
758                 retptr += self._len;
759             }
760         }
761 
762         return ret;
763     }
764 }
765 
766 // File: contracts/usingOraclize.sol
767 
768 // <ORACLIZE_API>
769 /*
770 Copyright (c) 2015-2016 Oraclize SRL
771 Copyright (c) 2016 Oraclize LTD
772 
773 
774 
775 Permission is hereby granted, free of charge, to any person obtaining a copy
776 of this software and associated documentation files (the "Software"), to deal
777 in the Software without restriction, including without limitation the rights
778 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
779 copies of the Software, and to permit persons to whom the Software is
780 furnished to do so, subject to the following conditions:
781 
782 
783 
784 The above copyright notice and this permission notice shall be included in
785 all copies or substantial portions of the Software.
786 
787 
788 
789 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
790 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
791 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
792 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
793 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
794 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
795 THE SOFTWARE.
796 */
797 
798 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
799 pragma solidity ^0.4.18;
800 
801 contract OraclizeI {
802     address public cbAddress;
803     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
804     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
805     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
806     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
807     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
808     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
809     function getPrice(string _datasource) public returns (uint _dsprice);
810     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
811     function setProofType(byte _proofType) external;
812     function setCustomGasPrice(uint _gasPrice) external;
813     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
814 }
815 contract OraclizeAddrResolverI {
816     function getAddress() public returns (address _addr);
817 }
818 contract usingOraclize {
819     uint constant day = 60*60*24;
820     uint constant week = 60*60*24*7;
821     uint constant month = 60*60*24*30;
822     byte constant proofType_NONE = 0x00;
823     byte constant proofType_TLSNotary = 0x10;
824     byte constant proofType_Android = 0x20;
825     byte constant proofType_Ledger = 0x30;
826     byte constant proofType_Native = 0xF0;
827     byte constant proofStorage_IPFS = 0x01;
828     uint8 constant networkID_auto = 0;
829     uint8 constant networkID_mainnet = 1;
830     uint8 constant networkID_testnet = 2;
831     uint8 constant networkID_morden = 2;
832     uint8 constant networkID_consensys = 161;
833 
834     OraclizeAddrResolverI OAR;
835 
836     OraclizeI oraclize;
837     modifier oraclizeAPI {
838         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
839             oraclize_setNetwork(networkID_auto);
840 
841         if(address(oraclize) != OAR.getAddress())
842             oraclize = OraclizeI(OAR.getAddress());
843 
844         _;
845     }
846     modifier coupon(string code){
847         oraclize = OraclizeI(OAR.getAddress());
848         _;
849     }
850 
851     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
852       return oraclize_setNetwork();
853       networkID; // silence the warning and remain backwards compatible
854     }
855     function oraclize_setNetwork() internal returns(bool){
856         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
857             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
858             oraclize_setNetworkName("eth_mainnet");
859             return true;
860         }
861         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
862             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
863             oraclize_setNetworkName("eth_ropsten3");
864             return true;
865         }
866         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
867             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
868             oraclize_setNetworkName("eth_kovan");
869             return true;
870         }
871         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
872             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
873             oraclize_setNetworkName("eth_rinkeby");
874             return true;
875         }
876         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
877             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
878             return true;
879         }
880         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
881             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
882             return true;
883         }
884         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
885             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
886             return true;
887         }
888         return false;
889     }
890 
891     function __callback(bytes32 myid, string result) public {
892         __callback(myid, result, new bytes(0));
893     }
894     function __callback(bytes32 myid, string result, bytes proof) public {
895       return;
896       myid; result; proof; // Silence compiler warnings
897     }
898 
899     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
900         return oraclize.getPrice(datasource);
901     }
902 
903     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
904         return oraclize.getPrice(datasource, gaslimit);
905     }
906 
907     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
908         uint price = oraclize.getPrice(datasource);
909         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
910         return oraclize.query.value(price)(0, datasource, arg);
911     }
912     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
913         uint price = oraclize.getPrice(datasource);
914         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
915         return oraclize.query.value(price)(timestamp, datasource, arg);
916     }
917     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
918         uint price = oraclize.getPrice(datasource, gaslimit);
919         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
920         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
921     }
922     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
923         uint price = oraclize.getPrice(datasource, gaslimit);
924         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
925         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
926     }
927     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
928         uint price = oraclize.getPrice(datasource);
929         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
930         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
931     }
932     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
933         uint price = oraclize.getPrice(datasource);
934         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
935         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
936     }
937     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
938         uint price = oraclize.getPrice(datasource, gaslimit);
939         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
940         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
941     }
942     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
943         uint price = oraclize.getPrice(datasource, gaslimit);
944         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
945         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
946     }
947     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
948         uint price = oraclize.getPrice(datasource);
949         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
950         bytes memory args = stra2cbor(argN);
951         return oraclize.queryN.value(price)(0, datasource, args);
952     }
953     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
954         uint price = oraclize.getPrice(datasource);
955         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
956         bytes memory args = stra2cbor(argN);
957         return oraclize.queryN.value(price)(timestamp, datasource, args);
958     }
959     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
960         uint price = oraclize.getPrice(datasource, gaslimit);
961         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
962         bytes memory args = stra2cbor(argN);
963         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
964     }
965     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
966         uint price = oraclize.getPrice(datasource, gaslimit);
967         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
968         bytes memory args = stra2cbor(argN);
969         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
970     }
971     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
972         string[] memory dynargs = new string[](1);
973         dynargs[0] = args[0];
974         return oraclize_query(datasource, dynargs);
975     }
976     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
977         string[] memory dynargs = new string[](1);
978         dynargs[0] = args[0];
979         return oraclize_query(timestamp, datasource, dynargs);
980     }
981     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
982         string[] memory dynargs = new string[](1);
983         dynargs[0] = args[0];
984         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
985     }
986     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
987         string[] memory dynargs = new string[](1);
988         dynargs[0] = args[0];
989         return oraclize_query(datasource, dynargs, gaslimit);
990     }
991 
992     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
993         string[] memory dynargs = new string[](2);
994         dynargs[0] = args[0];
995         dynargs[1] = args[1];
996         return oraclize_query(datasource, dynargs);
997     }
998     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
999         string[] memory dynargs = new string[](2);
1000         dynargs[0] = args[0];
1001         dynargs[1] = args[1];
1002         return oraclize_query(timestamp, datasource, dynargs);
1003     }
1004     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1005         string[] memory dynargs = new string[](2);
1006         dynargs[0] = args[0];
1007         dynargs[1] = args[1];
1008         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1009     }
1010     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1011         string[] memory dynargs = new string[](2);
1012         dynargs[0] = args[0];
1013         dynargs[1] = args[1];
1014         return oraclize_query(datasource, dynargs, gaslimit);
1015     }
1016     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1017         string[] memory dynargs = new string[](3);
1018         dynargs[0] = args[0];
1019         dynargs[1] = args[1];
1020         dynargs[2] = args[2];
1021         return oraclize_query(datasource, dynargs);
1022     }
1023     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1024         string[] memory dynargs = new string[](3);
1025         dynargs[0] = args[0];
1026         dynargs[1] = args[1];
1027         dynargs[2] = args[2];
1028         return oraclize_query(timestamp, datasource, dynargs);
1029     }
1030     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1031         string[] memory dynargs = new string[](3);
1032         dynargs[0] = args[0];
1033         dynargs[1] = args[1];
1034         dynargs[2] = args[2];
1035         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1036     }
1037     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1038         string[] memory dynargs = new string[](3);
1039         dynargs[0] = args[0];
1040         dynargs[1] = args[1];
1041         dynargs[2] = args[2];
1042         return oraclize_query(datasource, dynargs, gaslimit);
1043     }
1044 
1045     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1046         string[] memory dynargs = new string[](4);
1047         dynargs[0] = args[0];
1048         dynargs[1] = args[1];
1049         dynargs[2] = args[2];
1050         dynargs[3] = args[3];
1051         return oraclize_query(datasource, dynargs);
1052     }
1053     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1054         string[] memory dynargs = new string[](4);
1055         dynargs[0] = args[0];
1056         dynargs[1] = args[1];
1057         dynargs[2] = args[2];
1058         dynargs[3] = args[3];
1059         return oraclize_query(timestamp, datasource, dynargs);
1060     }
1061     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1062         string[] memory dynargs = new string[](4);
1063         dynargs[0] = args[0];
1064         dynargs[1] = args[1];
1065         dynargs[2] = args[2];
1066         dynargs[3] = args[3];
1067         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1068     }
1069     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1070         string[] memory dynargs = new string[](4);
1071         dynargs[0] = args[0];
1072         dynargs[1] = args[1];
1073         dynargs[2] = args[2];
1074         dynargs[3] = args[3];
1075         return oraclize_query(datasource, dynargs, gaslimit);
1076     }
1077     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1078         string[] memory dynargs = new string[](5);
1079         dynargs[0] = args[0];
1080         dynargs[1] = args[1];
1081         dynargs[2] = args[2];
1082         dynargs[3] = args[3];
1083         dynargs[4] = args[4];
1084         return oraclize_query(datasource, dynargs);
1085     }
1086     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1087         string[] memory dynargs = new string[](5);
1088         dynargs[0] = args[0];
1089         dynargs[1] = args[1];
1090         dynargs[2] = args[2];
1091         dynargs[3] = args[3];
1092         dynargs[4] = args[4];
1093         return oraclize_query(timestamp, datasource, dynargs);
1094     }
1095     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1096         string[] memory dynargs = new string[](5);
1097         dynargs[0] = args[0];
1098         dynargs[1] = args[1];
1099         dynargs[2] = args[2];
1100         dynargs[3] = args[3];
1101         dynargs[4] = args[4];
1102         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1103     }
1104     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1105         string[] memory dynargs = new string[](5);
1106         dynargs[0] = args[0];
1107         dynargs[1] = args[1];
1108         dynargs[2] = args[2];
1109         dynargs[3] = args[3];
1110         dynargs[4] = args[4];
1111         return oraclize_query(datasource, dynargs, gaslimit);
1112     }
1113     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1114         uint price = oraclize.getPrice(datasource);
1115         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1116         bytes memory args = ba2cbor(argN);
1117         return oraclize.queryN.value(price)(0, datasource, args);
1118     }
1119     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1120         uint price = oraclize.getPrice(datasource);
1121         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1122         bytes memory args = ba2cbor(argN);
1123         return oraclize.queryN.value(price)(timestamp, datasource, args);
1124     }
1125     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1126         uint price = oraclize.getPrice(datasource, gaslimit);
1127         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1128         bytes memory args = ba2cbor(argN);
1129         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1130     }
1131     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1132         uint price = oraclize.getPrice(datasource, gaslimit);
1133         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1134         bytes memory args = ba2cbor(argN);
1135         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1136     }
1137     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1138         bytes[] memory dynargs = new bytes[](1);
1139         dynargs[0] = args[0];
1140         return oraclize_query(datasource, dynargs);
1141     }
1142     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1143         bytes[] memory dynargs = new bytes[](1);
1144         dynargs[0] = args[0];
1145         return oraclize_query(timestamp, datasource, dynargs);
1146     }
1147     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1148         bytes[] memory dynargs = new bytes[](1);
1149         dynargs[0] = args[0];
1150         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1151     }
1152     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1153         bytes[] memory dynargs = new bytes[](1);
1154         dynargs[0] = args[0];
1155         return oraclize_query(datasource, dynargs, gaslimit);
1156     }
1157 
1158     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1159         bytes[] memory dynargs = new bytes[](2);
1160         dynargs[0] = args[0];
1161         dynargs[1] = args[1];
1162         return oraclize_query(datasource, dynargs);
1163     }
1164     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1165         bytes[] memory dynargs = new bytes[](2);
1166         dynargs[0] = args[0];
1167         dynargs[1] = args[1];
1168         return oraclize_query(timestamp, datasource, dynargs);
1169     }
1170     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1171         bytes[] memory dynargs = new bytes[](2);
1172         dynargs[0] = args[0];
1173         dynargs[1] = args[1];
1174         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1175     }
1176     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1177         bytes[] memory dynargs = new bytes[](2);
1178         dynargs[0] = args[0];
1179         dynargs[1] = args[1];
1180         return oraclize_query(datasource, dynargs, gaslimit);
1181     }
1182     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1183         bytes[] memory dynargs = new bytes[](3);
1184         dynargs[0] = args[0];
1185         dynargs[1] = args[1];
1186         dynargs[2] = args[2];
1187         return oraclize_query(datasource, dynargs);
1188     }
1189     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1190         bytes[] memory dynargs = new bytes[](3);
1191         dynargs[0] = args[0];
1192         dynargs[1] = args[1];
1193         dynargs[2] = args[2];
1194         return oraclize_query(timestamp, datasource, dynargs);
1195     }
1196     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1197         bytes[] memory dynargs = new bytes[](3);
1198         dynargs[0] = args[0];
1199         dynargs[1] = args[1];
1200         dynargs[2] = args[2];
1201         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1202     }
1203     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1204         bytes[] memory dynargs = new bytes[](3);
1205         dynargs[0] = args[0];
1206         dynargs[1] = args[1];
1207         dynargs[2] = args[2];
1208         return oraclize_query(datasource, dynargs, gaslimit);
1209     }
1210 
1211     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1212         bytes[] memory dynargs = new bytes[](4);
1213         dynargs[0] = args[0];
1214         dynargs[1] = args[1];
1215         dynargs[2] = args[2];
1216         dynargs[3] = args[3];
1217         return oraclize_query(datasource, dynargs);
1218     }
1219     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1220         bytes[] memory dynargs = new bytes[](4);
1221         dynargs[0] = args[0];
1222         dynargs[1] = args[1];
1223         dynargs[2] = args[2];
1224         dynargs[3] = args[3];
1225         return oraclize_query(timestamp, datasource, dynargs);
1226     }
1227     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1228         bytes[] memory dynargs = new bytes[](4);
1229         dynargs[0] = args[0];
1230         dynargs[1] = args[1];
1231         dynargs[2] = args[2];
1232         dynargs[3] = args[3];
1233         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1234     }
1235     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1236         bytes[] memory dynargs = new bytes[](4);
1237         dynargs[0] = args[0];
1238         dynargs[1] = args[1];
1239         dynargs[2] = args[2];
1240         dynargs[3] = args[3];
1241         return oraclize_query(datasource, dynargs, gaslimit);
1242     }
1243     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1244         bytes[] memory dynargs = new bytes[](5);
1245         dynargs[0] = args[0];
1246         dynargs[1] = args[1];
1247         dynargs[2] = args[2];
1248         dynargs[3] = args[3];
1249         dynargs[4] = args[4];
1250         return oraclize_query(datasource, dynargs);
1251     }
1252     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1253         bytes[] memory dynargs = new bytes[](5);
1254         dynargs[0] = args[0];
1255         dynargs[1] = args[1];
1256         dynargs[2] = args[2];
1257         dynargs[3] = args[3];
1258         dynargs[4] = args[4];
1259         return oraclize_query(timestamp, datasource, dynargs);
1260     }
1261     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1262         bytes[] memory dynargs = new bytes[](5);
1263         dynargs[0] = args[0];
1264         dynargs[1] = args[1];
1265         dynargs[2] = args[2];
1266         dynargs[3] = args[3];
1267         dynargs[4] = args[4];
1268         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1269     }
1270     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1271         bytes[] memory dynargs = new bytes[](5);
1272         dynargs[0] = args[0];
1273         dynargs[1] = args[1];
1274         dynargs[2] = args[2];
1275         dynargs[3] = args[3];
1276         dynargs[4] = args[4];
1277         return oraclize_query(datasource, dynargs, gaslimit);
1278     }
1279 
1280     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1281         return oraclize.cbAddress();
1282     }
1283     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1284         return oraclize.setProofType(proofP);
1285     }
1286     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1287         return oraclize.setCustomGasPrice(gasPrice);
1288     }
1289 
1290     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1291         return oraclize.randomDS_getSessionPubKeyHash();
1292     }
1293 
1294     function getCodeSize(address _addr) constant internal returns(uint _size) {
1295         assembly {
1296             _size := extcodesize(_addr)
1297         }
1298     }
1299 
1300     function parseAddr(string _a) internal pure returns (address){
1301         bytes memory tmp = bytes(_a);
1302         uint160 iaddr = 0;
1303         uint160 b1;
1304         uint160 b2;
1305         for (uint i=2; i<2+2*20; i+=2){
1306             iaddr *= 256;
1307             b1 = uint160(tmp[i]);
1308             b2 = uint160(tmp[i+1]);
1309             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1310             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1311             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1312             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1313             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1314             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1315             iaddr += (b1*16+b2);
1316         }
1317         return address(iaddr);
1318     }
1319 
1320     function strCompare(string _a, string _b) internal pure returns (int) {
1321         bytes memory a = bytes(_a);
1322         bytes memory b = bytes(_b);
1323         uint minLength = a.length;
1324         if (b.length < minLength) minLength = b.length;
1325         for (uint i = 0; i < minLength; i ++)
1326             if (a[i] < b[i])
1327                 return -1;
1328             else if (a[i] > b[i])
1329                 return 1;
1330         if (a.length < b.length)
1331             return -1;
1332         else if (a.length > b.length)
1333             return 1;
1334         else
1335             return 0;
1336     }
1337 
1338     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1339         bytes memory h = bytes(_haystack);
1340         bytes memory n = bytes(_needle);
1341         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1342             return -1;
1343         else if(h.length > (2**128 -1))
1344             return -1;
1345         else
1346         {
1347             uint subindex = 0;
1348             for (uint i = 0; i < h.length; i ++)
1349             {
1350                 if (h[i] == n[0])
1351                 {
1352                     subindex = 1;
1353                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1354                     {
1355                         subindex++;
1356                     }
1357                     if(subindex == n.length)
1358                         return int(i);
1359                 }
1360             }
1361             return -1;
1362         }
1363     }
1364 
1365     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1366         bytes memory _ba = bytes(_a);
1367         bytes memory _bb = bytes(_b);
1368         bytes memory _bc = bytes(_c);
1369         bytes memory _bd = bytes(_d);
1370         bytes memory _be = bytes(_e);
1371         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1372         bytes memory babcde = bytes(abcde);
1373         uint k = 0;
1374         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1375         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1376         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1377         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1378         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1379         return string(babcde);
1380     }
1381 
1382     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1383         return strConcat(_a, _b, _c, _d, "");
1384     }
1385 
1386     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1387         return strConcat(_a, _b, _c, "", "");
1388     }
1389 
1390     function strConcat(string _a, string _b) internal pure returns (string) {
1391         return strConcat(_a, _b, "", "", "");
1392     }
1393 
1394     // parseInt
1395     function parseInt(string _a) internal pure returns (uint) {
1396         return parseInt(_a, 0);
1397     }
1398 
1399     // parseInt(parseFloat*10^_b)
1400     function parseInt(string _a, uint _b) internal pure returns (uint) {
1401         bytes memory bresult = bytes(_a);
1402         uint mint = 0;
1403         bool decimals = false;
1404         for (uint i=0; i<bresult.length; i++){
1405             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1406                 if (decimals){
1407                    if (_b == 0) break;
1408                     else _b--;
1409                 }
1410                 mint *= 10;
1411                 mint += uint(bresult[i]) - 48;
1412             } else if (bresult[i] == 46) decimals = true;
1413         }
1414         if (_b > 0) mint *= 10**_b;
1415         return mint;
1416     }
1417 
1418     function uint2str(uint i) internal pure returns (string){
1419         if (i == 0) return "0";
1420         uint j = i;
1421         uint len;
1422         while (j != 0){
1423             len++;
1424             j /= 10;
1425         }
1426         bytes memory bstr = new bytes(len);
1427         uint k = len - 1;
1428         while (i != 0){
1429             bstr[k--] = byte(48 + i % 10);
1430             i /= 10;
1431         }
1432         return string(bstr);
1433     }
1434 
1435     function stra2cbor(string[] arr) internal pure returns (bytes) {
1436             uint arrlen = arr.length;
1437 
1438             // get correct cbor output length
1439             uint outputlen = 0;
1440             bytes[] memory elemArray = new bytes[](arrlen);
1441             for (uint i = 0; i < arrlen; i++) {
1442                 elemArray[i] = (bytes(arr[i]));
1443                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1444             }
1445             uint ctr = 0;
1446             uint cborlen = arrlen + 0x80;
1447             outputlen += byte(cborlen).length;
1448             bytes memory res = new bytes(outputlen);
1449 
1450             while (byte(cborlen).length > ctr) {
1451                 res[ctr] = byte(cborlen)[ctr];
1452                 ctr++;
1453             }
1454             for (i = 0; i < arrlen; i++) {
1455                 res[ctr] = 0x5F;
1456                 ctr++;
1457                 for (uint x = 0; x < elemArray[i].length; x++) {
1458                     // if there's a bug with larger strings, this may be the culprit
1459                     if (x % 23 == 0) {
1460                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1461                         elemcborlen += 0x40;
1462                         uint lctr = ctr;
1463                         while (byte(elemcborlen).length > ctr - lctr) {
1464                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1465                             ctr++;
1466                         }
1467                     }
1468                     res[ctr] = elemArray[i][x];
1469                     ctr++;
1470                 }
1471                 res[ctr] = 0xFF;
1472                 ctr++;
1473             }
1474             return res;
1475         }
1476 
1477     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1478             uint arrlen = arr.length;
1479 
1480             // get correct cbor output length
1481             uint outputlen = 0;
1482             bytes[] memory elemArray = new bytes[](arrlen);
1483             for (uint i = 0; i < arrlen; i++) {
1484                 elemArray[i] = (bytes(arr[i]));
1485                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1486             }
1487             uint ctr = 0;
1488             uint cborlen = arrlen + 0x80;
1489             outputlen += byte(cborlen).length;
1490             bytes memory res = new bytes(outputlen);
1491 
1492             while (byte(cborlen).length > ctr) {
1493                 res[ctr] = byte(cborlen)[ctr];
1494                 ctr++;
1495             }
1496             for (i = 0; i < arrlen; i++) {
1497                 res[ctr] = 0x5F;
1498                 ctr++;
1499                 for (uint x = 0; x < elemArray[i].length; x++) {
1500                     // if there's a bug with larger strings, this may be the culprit
1501                     if (x % 23 == 0) {
1502                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1503                         elemcborlen += 0x40;
1504                         uint lctr = ctr;
1505                         while (byte(elemcborlen).length > ctr - lctr) {
1506                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1507                             ctr++;
1508                         }
1509                     }
1510                     res[ctr] = elemArray[i][x];
1511                     ctr++;
1512                 }
1513                 res[ctr] = 0xFF;
1514                 ctr++;
1515             }
1516             return res;
1517         }
1518 
1519 
1520     string oraclize_network_name;
1521     function oraclize_setNetworkName(string _network_name) internal {
1522         oraclize_network_name = _network_name;
1523     }
1524 
1525     function oraclize_getNetworkName() internal view returns (string) {
1526         return oraclize_network_name;
1527     }
1528 
1529     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1530         require((_nbytes > 0) && (_nbytes <= 32));
1531         // Convert from seconds to ledger timer ticks
1532         _delay *= 10; 
1533         bytes memory nbytes = new bytes(1);
1534         nbytes[0] = byte(_nbytes);
1535         bytes memory unonce = new bytes(32);
1536         bytes memory sessionKeyHash = new bytes(32);
1537         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1538         assembly {
1539             mstore(unonce, 0x20)
1540             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1541             mstore(sessionKeyHash, 0x20)
1542             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1543         }
1544         bytes memory delay = new bytes(32);
1545         assembly { 
1546             mstore(add(delay, 0x20), _delay) 
1547         }
1548         
1549         bytes memory delay_bytes8 = new bytes(8);
1550         copyBytes(delay, 24, 8, delay_bytes8, 0);
1551 
1552         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1553         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1554         
1555         bytes memory delay_bytes8_left = new bytes(8);
1556         
1557         assembly {
1558             let x := mload(add(delay_bytes8, 0x20))
1559             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1560             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1561             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1562             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1563             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1564             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1565             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1566             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1567 
1568         }
1569         
1570         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1571         return queryId;
1572     }
1573     
1574     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1575         oraclize_randomDS_args[queryId] = commitment;
1576     }
1577 
1578     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1579     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1580 
1581     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1582         bool sigok;
1583         address signer;
1584 
1585         bytes32 sigr;
1586         bytes32 sigs;
1587 
1588         bytes memory sigr_ = new bytes(32);
1589         uint offset = 4+(uint(dersig[3]) - 0x20);
1590         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1591         bytes memory sigs_ = new bytes(32);
1592         offset += 32 + 2;
1593         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1594 
1595         assembly {
1596             sigr := mload(add(sigr_, 32))
1597             sigs := mload(add(sigs_, 32))
1598         }
1599 
1600 
1601         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1602         if (address(keccak256(pubkey)) == signer) return true;
1603         else {
1604             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1605             return (address(keccak256(pubkey)) == signer);
1606         }
1607     }
1608 
1609     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1610         bool sigok;
1611 
1612         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1613         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1614         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1615 
1616         bytes memory appkey1_pubkey = new bytes(64);
1617         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1618 
1619         bytes memory tosign2 = new bytes(1+65+32);
1620         tosign2[0] = byte(1); //role
1621         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1622         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1623         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1624         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1625 
1626         if (sigok == false) return false;
1627 
1628 
1629         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1630         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1631 
1632         bytes memory tosign3 = new bytes(1+65);
1633         tosign3[0] = 0xFE;
1634         copyBytes(proof, 3, 65, tosign3, 1);
1635 
1636         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1637         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1638 
1639         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1640 
1641         return sigok;
1642     }
1643 
1644     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1645         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1646         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1647 
1648         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1649         require(proofVerified);
1650 
1651         _;
1652     }
1653 
1654     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1655         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1656         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1657 
1658         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1659         if (proofVerified == false) return 2;
1660 
1661         return 0;
1662     }
1663 
1664     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1665         bool match_ = true;
1666         
1667         require(prefix.length == n_random_bytes);
1668 
1669         for (uint256 i=0; i< n_random_bytes; i++) {
1670             if (content[i] != prefix[i]) match_ = false;
1671         }
1672 
1673         return match_;
1674     }
1675 
1676     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1677 
1678         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1679         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1680         bytes memory keyhash = new bytes(32);
1681         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1682         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1683 
1684         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1685         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1686 
1687         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1688         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1689 
1690         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1691         // This is to verify that the computed args match with the ones specified in the query.
1692         bytes memory commitmentSlice1 = new bytes(8+1+32);
1693         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1694 
1695         bytes memory sessionPubkey = new bytes(64);
1696         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1697         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1698 
1699         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1700         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1701             delete oraclize_randomDS_args[queryId];
1702         } else return false;
1703 
1704 
1705         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1706         bytes memory tosign1 = new bytes(32+8+1+32);
1707         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1708         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1709 
1710         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1711         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1712             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1713         }
1714 
1715         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1716     }
1717 
1718     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1719     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1720         uint minLength = length + toOffset;
1721 
1722         // Buffer too small
1723         require(to.length >= minLength); // Should be a better way?
1724 
1725         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1726         uint i = 32 + fromOffset;
1727         uint j = 32 + toOffset;
1728 
1729         while (i < (32 + fromOffset + length)) {
1730             assembly {
1731                 let tmp := mload(add(from, i))
1732                 mstore(add(to, j), tmp)
1733             }
1734             i += 32;
1735             j += 32;
1736         }
1737 
1738         return to;
1739     }
1740 
1741     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1742     // Duplicate Solidity's ecrecover, but catching the CALL return value
1743     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1744         // We do our own memory management here. Solidity uses memory offset
1745         // 0x40 to store the current end of memory. We write past it (as
1746         // writes are memory extensions), but don't update the offset so
1747         // Solidity will reuse it. The memory used here is only needed for
1748         // this context.
1749 
1750         // FIXME: inline assembly can't access return values
1751         bool ret;
1752         address addr;
1753 
1754         assembly {
1755             let size := mload(0x40)
1756             mstore(size, hash)
1757             mstore(add(size, 32), v)
1758             mstore(add(size, 64), r)
1759             mstore(add(size, 96), s)
1760 
1761             // NOTE: we can reuse the request memory because we deal with
1762             //       the return code
1763             ret := call(3000, 1, 0, size, 128, size, 32)
1764             addr := mload(size)
1765         }
1766 
1767         return (ret, addr);
1768     }
1769 
1770     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1771     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1772         bytes32 r;
1773         bytes32 s;
1774         uint8 v;
1775 
1776         if (sig.length != 65)
1777           return (false, 0);
1778 
1779         // The signature format is a compact form of:
1780         //   {bytes32 r}{bytes32 s}{uint8 v}
1781         // Compact means, uint8 is not padded to 32 bytes.
1782         assembly {
1783             r := mload(add(sig, 32))
1784             s := mload(add(sig, 64))
1785 
1786             // Here we are loading the last 32 bytes. We exploit the fact that
1787             // 'mload' will pad with zeroes if we overread.
1788             // There is no 'mload8' to do this, but that would be nicer.
1789             v := byte(0, mload(add(sig, 96)))
1790 
1791             // Alternative solution:
1792             // 'byte' is not working due to the Solidity parser, so lets
1793             // use the second best option, 'and'
1794             // v := and(mload(add(sig, 65)), 255)
1795         }
1796 
1797         // albeit non-transactional signatures are not specified by the YP, one would expect it
1798         // to match the YP range of [27, 28]
1799         //
1800         // geth uses [0, 1] and some clients have followed. This might change, see:
1801         //  https://github.com/ethereum/go-ethereum/issues/2053
1802         if (v < 27)
1803           v += 27;
1804 
1805         if (v != 27 && v != 28)
1806             return (false, 0);
1807 
1808         return safer_ecrecover(hash, v, r, s);
1809     }
1810 
1811 }
1812 // </ORACLIZE_API>
1813 
1814 // File: contracts/WorldCupBroker.sol
1815 
1816 /*
1817  * @title String & slice utility library for Solidity contracts.
1818  * @author Daniel Bennett <dbennett18@protonmail.com>
1819  *
1820  * @dev This is a solitidy contract that facilitates betting for the 2018
1821         world cup. The contract on does not act as a counter party 
1822         to any bets placed and thus users bet on a decision pool for a match
1823         (win, lose, draw), and based on the results of users will be credited winnings
1824         proportional to their contributions to the winning pool.
1825     */
1826 
1827 
1828 pragma solidity ^0.4.4;
1829 
1830 
1831 
1832 
1833 contract WorldCupBroker is Ownable, usingOraclize {
1834 
1835     using strings for *;
1836 
1837     struct Bet {
1838         bool    cancelled;
1839         bool    claimed;
1840         uint    amount;
1841         uint8   option; // 1 - teamA, 2 - teamB, 3 - Draw
1842         address better;
1843     }
1844     
1845     struct Match {
1846         bool   locked; // match will be locked after payout or all bets returned
1847         bool   cancelled;
1848         uint8  teamA;
1849         uint8  teamB;
1850         uint8  winner; // 0 - not set, 1 - teamA, 2 - teamB, 3- Draw, 4 - no winner
1851         uint   start;
1852         uint   closeBettingTime; // since this the close delay is constant 
1853         // this will always be the same, save gas for betters and just set the close time once
1854         uint   totalTeamABets;
1855         uint   totalTeamBBets;
1856         uint   totalDrawBets;
1857         uint   numBets;
1858         string fixtureId;
1859         string secondaryFixtureId;
1860         bool   inverted; // inverted if the secondary api has the home team and away teams inverted
1861         string name;
1862         mapping(uint => Bet) bets;
1863     }
1864 
1865     event MatchCreated(uint8);
1866 
1867     event MatchUpdated(uint8);
1868 
1869     event MatchFailedPayoutRelease(uint8);
1870 
1871     event BetPlaced(
1872         uint8   matchId,
1873         uint8   outcome,
1874         uint    betId,
1875         uint    amount,
1876         address better
1877     );
1878 
1879     event BetClaimed(
1880         uint8   matchId,
1881         uint    betId
1882     );
1883 
1884     event BetCancelled(
1885         uint8   matchId,
1886         uint    betId
1887     );
1888     
1889     string[32] public TEAMS = [
1890         "Russia", 
1891         "Saudi Arabia", 
1892         "Egypt", 
1893         "Uruguay", 
1894         "Morocco", 
1895         "Iran", 
1896         "Portugal", 
1897         "Spain", 
1898         "France", 
1899         "Australia", 
1900         "Argentina", 
1901         "Iceland", 
1902         "Peru", 
1903         "Denmark", 
1904         "Croatia", 
1905         "Nigeria", 
1906         "Costa Rica", 
1907         "Serbia", 
1908         "Germany", 
1909         "Mexico", 
1910         "Brazil", 
1911         "Switzerland", 
1912         "Sweden", 
1913         "South Korea", 
1914         "Belgium", 
1915         "Panama", 
1916         "Tunisia", 
1917         "England", 
1918         "Poland", 
1919         "Senegal", 
1920         "Colombia", 
1921         "Japan"
1922     ];
1923     uint public constant MAX_NUM_PAYOUT_ATTEMPTS = 3; // after 3 consecutive failed payout attempts, lock the match
1924     uint public constant PAYOUT_ATTEMPT_INTERVAL = 3 minutes; // try every 3 minutes to release payout
1925     uint public  commission_rate = 7;
1926     uint public  minimum_bet = 0.01 ether;
1927     uint private commissions = 0;
1928     uint public  primaryGasLimit = 225000;
1929     uint public  secondaryGasLimit = 250000;
1930     
1931 
1932     Match[] matches;
1933     mapping(bytes32 => uint8) oraclizeIds;
1934     mapping(uint8 => uint8) payoutAttempts;
1935     mapping(uint8 => bool) firstStepVerified;
1936     mapping(uint8 => uint8) pendingWinner;
1937 
1938      /*
1939      * @dev Ensures a matchId points to a legitimate match
1940      * @param _matchId the uint to check if it points to a valid match.
1941      */
1942     modifier validMatch(uint8 _matchId) {
1943         require(_matchId < uint8(matches.length));
1944         _;
1945     }
1946 
1947     /*
1948      * @dev the validBet modifier does as it's name implies and ensures that a bet
1949      * is valid before proceeding with any methods called on the contract
1950      * that would require access to such a bet
1951      * @param _matchId the uint to check if it points to a valid match.
1952      * @param _betId the uint to check if it points to a valid bet for a match.
1953      */
1954     modifier validBet(uint8 _matchId, uint _betId) {
1955         // short circuit to save gas
1956         require(_matchId < uint8(matches.length) && _betId < matches[_matchId].numBets);
1957         _;
1958     }
1959 
1960     /*
1961      * @dev Adds a new match to the smart contract and schedules an oraclize query call
1962      *      to determine the winner of a match within 3 hours. Additionally emits an event
1963      *      signifying a match was created.
1964      * @param _name      the unique identifier of the match, should be of format Stage:Team A vs Team B
1965      * @param _fixture   the fixtureId for the football-data.org endpoint
1966      * @param _secondary the fixtureId for the sportsmonk.com endpoint
1967      * @param _inverted  should be set to true if the teams are inverted on either of the API 
1968      *                   that is if the hometeam and localteam are swapped
1969      * @param _teamA     index of the homeTeam from the TEAMS array
1970      * @param _teamB     index of the awayTeam from the TEAMS array
1971      * @param _start     the unix timestamp for when the match is scheduled to begin
1972      * @return `uint`     the Id of the match in the matches array
1973      */ 
1974     function addMatch(string _name, string _fixture, string _secondary, bool _invert, uint8 _teamA, uint8 _teamB, uint _start) public onlyOwner returns (uint8) {
1975         // Check that there's at least 15 minutes until the match starts
1976         require(_teamA < 32 && _teamB < 32 && _teamA != _teamB);
1977         Match memory newMatch = Match({
1978             locked: false, 
1979             cancelled: false, 
1980             teamA: _teamA,
1981             teamB: _teamB, 
1982             winner: 0,
1983             fixtureId: _fixture, // The primary fixtureId that will be used to query the football-data API
1984             secondaryFixtureId: _secondary, // The secondary fixtureID used to query sports monk
1985             inverted: _invert,
1986             start: _start, 
1987             closeBettingTime: _start - 3 minutes, // betting closes 3 minutes before a match starts
1988             totalTeamABets: 0, 
1989             totalTeamBBets: 0, 
1990             totalDrawBets: 0, 
1991             numBets: 0,
1992             name: _name
1993         });
1994         uint8 matchId = uint8(matches.push(newMatch)) - 1;
1995         // concatinate oraclize query
1996         string memory url = strConcat(
1997             "[URL] json(https://soccer.sportmonks.com/api/v2.0/fixtures/",
1998             newMatch.secondaryFixtureId,
1999             "?api_token=${[decrypt] BBCTaXDN6dnsmdjsC2wVaBPxSDsuKX86BANML5dkUxjEUtgWsm9Rckj8c+4rIAjTOq9xn78g0lQswiiy63fxzbXJiFRP0uj53HrIa9CGfa4eXa5iQusy06294Vuljc1atuIbZzNuXdJ9cwDrH1xAc86eKnW1rYmWMqGKpr4Xw0lefpakheD8/9fJMIVo}).data.scores[localteam_score,visitorteam_score]");
2000         // store the oraclize query id for later use
2001         // use hours to over estimate the amount of time it would take to safely get a correct result
2002         // 90 minutes of regulation play time + potential 30 minutes of extra time + 15 minutes break
2003         // + potential 10 minutes of stoppage time + potential 10 minutes of penalties
2004         // + 25 minutes of time for any APIs to correct and ensure their information is correct
2005         uint start = (_start + 3 hours);
2006         if (start <= now) {
2007             start = 1 minutes;
2008         }
2009         bytes32 oraclizeId = oraclize_query(start, "nested", url, primaryGasLimit);
2010         oraclizeIds[oraclizeId] = matchId;
2011         emit MatchCreated(matchId);
2012         return matchId;
2013     }
2014 
2015     function cancelMatch(uint8 _matchId) public onlyOwner validMatch(_matchId) returns (bool) {
2016         Match storage mtch = matches[_matchId];
2017         require(!mtch.cancelled && now < mtch.closeBettingTime);
2018         mtch.cancelled = true;
2019         mtch.locked = true;
2020         emit MatchUpdated(_matchId);
2021         return true;
2022     }
2023 
2024     /*
2025      * @dev returns the number of matches on the contract
2026      */ 
2027     function getNumMatches() public view returns (uint) {
2028         return matches.length;
2029     }
2030 
2031     
2032     /*
2033      * @dev Returns some of the properties of a match. Functionality had to be seperated
2034      *      into 2 function calls to prevent stack too deep errors
2035      * @param _matchId   the index of that match in the matches array
2036      * @return `string`  the match name
2037      * @return `string`  the fixutre Id of the match for the football-data endpoint
2038      * @return `string`  the fixture Id fo the match for the sports monk endpoint
2039      * @return `uint8`   the index of the home team
2040      * @return `uint8`   the index of the away team
2041      * @return `uint8`   the winner of the match
2042      * @return `uint`    the unix timestamp for the match start time
2043      * @return `bool`    Match cancelled boolean
2044      * @return `bool`    Match locked boolean which is set to true if the match is payed out or bets are returned
2045      */ 
2046     function getMatch(uint8 _matchId) public view validMatch(_matchId) returns (string, string, string, bool, uint8, uint8, uint8, uint, bool, bool) {
2047         Match memory mtch = matches[_matchId];
2048         return (
2049             mtch.name,
2050             mtch.fixtureId, 
2051             mtch.secondaryFixtureId,
2052             mtch.inverted,
2053             mtch.teamA, 
2054             mtch.teamB,
2055             mtch.winner, 
2056             mtch.start,
2057             mtch.cancelled,
2058             mtch.locked
2059         );
2060     }
2061 
2062     /*
2063      * @dev Returns remaining of the properties of a match. Functionality had to be seperated
2064      *      into 2 function calls to prevent stack too deep errors
2065      * @param _matchId   the index of that match in the matches array
2066      * @return `uint`  timestamp for when betting for the match closes
2067      * @return `uint`  total size of the home team bet pool
2068      * @return `uint`  total size of the away team bet pool
2069      * @return `uint`  total size of the draw bet pool
2070      * @return `uint`  the total number of bets
2071      * @return `uint8` the number of payout attempts for the match
2072      */ 
2073     function getMatchBettingDetails(uint8 _matchId) public view validMatch(_matchId) returns (uint, uint, uint, uint, uint, uint8) {
2074         Match memory mtch = matches[_matchId];
2075         return (
2076             mtch.closeBettingTime,
2077             mtch.totalTeamABets, 
2078             mtch.totalTeamBBets, 
2079             mtch.totalDrawBets,
2080             mtch.numBets,
2081             payoutAttempts[_matchId]
2082         );
2083     }
2084 
2085     /*
2086      * @dev Adds a new bet to a match with the outcome passed where there are 3 possible outcomes
2087      *      homeTeam wins(1), awayTeam wins(2), draw(3). While it is possible for some matches
2088      *      to end in a draw, not all matches will have the possibility of ending in a draw
2089      *      this functionality will be added in front end code to prevent betting on invalid decisions.
2090      *      Emits a BetPlaced event.
2091      * @param _matchId   the index of the match in matches that the bet is for
2092      * @param _outcome   the possible outcome for the match that this bet is betting on 
2093      * @return `uint`    the Id of the bet in a match's bet array
2094      */ 
2095     function placeBet(uint8 _matchId, uint8 _outcome) public payable validMatch(_matchId) returns (uint) {
2096         Match storage mtch = matches[_matchId];
2097         // A bet must be a valid option, 1, 2, or 3, and cannot be less that the minimum bet amount
2098         require(
2099             !mtch.locked &&
2100             !mtch.cancelled &&
2101             now < mtch.closeBettingTime &&
2102             _outcome > 0 && 
2103             _outcome < 4 && 
2104             msg.value >= minimum_bet
2105         );
2106         Bet memory bet = Bet(false, false, msg.value, _outcome, msg.sender);
2107         uint betId = mtch.numBets;
2108         mtch.bets[betId] = bet;
2109         mtch.numBets++;
2110         if (_outcome == 1) {
2111             mtch.totalTeamABets += msg.value;
2112             // a bit of safe math checking here
2113             assert(mtch.totalTeamABets >= msg.value);
2114         } else if (_outcome == 2) {
2115             mtch.totalTeamBBets += msg.value;
2116             assert(mtch.totalTeamBBets >= msg.value);
2117         } else {
2118             mtch.totalDrawBets += msg.value;
2119             assert(mtch.totalDrawBets >= msg.value);
2120         }
2121         // emit bet placed event
2122         emit BetPlaced(_matchId, _outcome, betId, msg.value, msg.sender);
2123         return (betId);
2124     }
2125 
2126     /*
2127      * @dev Returns the properties of a bet for a match
2128      * @param _matchId   the index of that match in the matches array
2129      * @param _betId     the index of that bet in the match bets array
2130      * @return `address` the address that placed the bet and thus it's owner
2131      * @return `uint`    the amount that was bet
2132      * @return `uint`    the option that was bet on
2133      * @return `bool`    wether or not the bet had been cancelled
2134      */ 
2135     function getBet(uint8 _matchId, uint _betId) public view validBet(_matchId, _betId) returns (address, uint, uint, bool, bool) {
2136         Bet memory bet = matches[_matchId].bets[_betId];
2137         // Don't return matchId and betId since you had to know them in the first place
2138         return (bet.better, bet.amount, bet.option, bet.cancelled, bet.claimed);
2139     } 
2140 
2141     /*
2142      * @dev Cancel's a bet and returns the amount - commission fee. Emits a BetCancelled event
2143      * @param _matchId   the index of that match in the matches array
2144      * @param _betId     the index of that bet in the match bets array
2145      */ 
2146     function cancelBet(uint8 _matchId, uint _betId) public validBet(_matchId, _betId) {
2147         Match memory mtch = matches[_matchId];
2148         require(!mtch.locked && now < mtch.closeBettingTime);
2149         Bet storage bet = matches[_matchId].bets[_betId];
2150         // only the person who made this bet can cancel it
2151         require(!bet.cancelled && !bet.claimed && bet.better == msg.sender );
2152         // stop re-entry just in case of malicious attack to withdraw all contract eth
2153         bet.cancelled = true;
2154         uint commission = bet.amount / 100 * commission_rate;
2155         commissions += commission;
2156         assert(commissions >= commission);
2157         if (bet.option == 1) {
2158             matches[_matchId].totalTeamABets -= bet.amount;
2159         } else if (bet.option == 2) {
2160             matches[_matchId].totalTeamBBets -= bet.amount;
2161         } else if (bet.option == 3) {
2162             matches[_matchId].totalDrawBets -= bet.amount;
2163         }
2164         bet.better.transfer(bet.amount - commission);
2165         emit BetCancelled(_matchId, _betId);
2166     }
2167 
2168     /*
2169      * @dev Betters can claim there winnings using this method or reclaim their bet
2170      *      if the match was cancelled
2171      * @param _matchId   the index of the match in the matches array
2172      * @param _betId     the bet being claimed
2173      */ 
2174     function claimBet(uint8 _matchId, uint8 _betId) public validBet(_matchId, _betId) {
2175         Match storage mtch = matches[_matchId];
2176         Bet storage bet = mtch.bets[_betId];
2177         // ensures the match has been locked (payout either done or bets returned)
2178         // dead man's switch to prevent bets from ever getting locked in the contrat
2179         // from insufficient funds during an oracalize query
2180         // if the match isn't locked or cancelled, then you can claim your bet after
2181         // the world cup is over (noon July 16)
2182         require((mtch.locked || now >= 1531742400) &&
2183             !bet.claimed &&
2184             !bet.cancelled &&
2185             msg.sender == bet.better
2186         );
2187         bet.claimed = true;
2188         if (mtch.winner == 0) {
2189             // If the match is locked with no winner set
2190             // then either it was cancelled or a winner couldn't be determined
2191             // transfer better back their bet amount
2192             bet.better.transfer(bet.amount);
2193         } else {
2194             if (bet.option != mtch.winner) {
2195                 return;
2196             }
2197             uint totalPool;
2198             uint winPool;
2199             if (mtch.winner == 1) {
2200                 totalPool = mtch.totalTeamBBets + mtch.totalDrawBets;
2201                 // once again do some safe math
2202                 assert(totalPool >= mtch.totalTeamBBets);
2203                 winPool = mtch.totalTeamABets;
2204             } else if (mtch.winner == 2) {
2205                 totalPool = mtch.totalTeamABets + mtch.totalDrawBets;
2206                 assert(totalPool >= mtch.totalTeamABets);
2207                 winPool = mtch.totalTeamBBets;
2208             } else {
2209                 totalPool = mtch.totalTeamABets + mtch.totalTeamBBets;
2210                 assert(totalPool >= mtch.totalTeamABets);
2211                 winPool = mtch.totalDrawBets;
2212             }
2213             uint winnings = totalPool * bet.amount / winPool;
2214             // calculate commissions percentage
2215             uint commission = winnings / 100 * commission_rate;
2216             commissions += commission;
2217             assert(commissions >= commission);
2218             // return original bet amount + winnings - commission
2219             bet.better.transfer(winnings + bet.amount - commission);
2220         }
2221         emit BetClaimed(_matchId, _betId);
2222     }
2223 
2224     /*
2225      * @dev Change the commission fee for the contract. The fee can never exceed 7%
2226      * @param _newCommission  the new fee rate to be charged in wei
2227      */ 
2228     function changeFees(uint8 _newCommission) public onlyOwner {
2229         // Max commission is 7%, but it can be FREE!!
2230         require(_newCommission <= 7);
2231         commission_rate = _newCommission;
2232     }
2233 
2234     /*
2235      * @dev Withdraw a portion of the commission from the commission pool.
2236      * @param _amount  the amount of commission to be withdrawn
2237      */ 
2238     function withdrawCommissions(uint _amount) public onlyOwner {
2239         require(_amount <= commissions);
2240         commissions -= _amount;
2241         owner.transfer(_amount);
2242     }
2243 
2244     /*
2245      * @dev Destroy the contract but only after the world cup is over for a month
2246      */ 
2247     function withdrawBalance() public onlyOwner {
2248         // World cup is over for a full month withdraw the full balance of the contract
2249         // and destroy it to free space on the blockchain
2250         require(now >= 1534291200); // This is 12am August 15, 2018
2251         selfdestruct(owner);
2252     }
2253 
2254     
2255     /*
2256      * @dev Change the minimum bet amount. Just in case the price of eth skyrockets or drops.
2257      * @param _newMin   the new minimum bet amount
2258      */ 
2259     function changeMiniumBet(uint _newMin) public onlyOwner {
2260         minimum_bet = _newMin;
2261     }
2262 
2263     /*
2264      * @dev sets the gas price to be used for oraclize quries in the contract
2265      * @param _price          the price of each gas
2266      */ 
2267     function setGasPrice(uint _price) public onlyOwner {
2268         require(_price >= 20000000000 wei);
2269         oraclize_setCustomGasPrice(_price);
2270     }
2271 
2272 
2273      /*
2274      * @dev Oraclize query callback to determine the winner of the match.
2275      * @param _myid    the id for the oraclize query that is being returned
2276      * @param _result  the result of the query
2277      */ 
2278     function __callback(bytes32 _myid, string _result) public {
2279         // only oraclize can call this method
2280         if (msg.sender != oraclize_cbAddress()) revert();
2281         uint8 matchId = oraclizeIds[_myid];
2282         Match storage mtch = matches[matchId];
2283         require(!mtch.locked && !mtch.cancelled);
2284         bool firstVerification = firstStepVerified[matchId];
2285         // If there is no result or the result is null we want to do the following
2286         if (bytes(_result).length == 0 || (keccak256(_result) == keccak256("[null, null]"))) {
2287             // If max number of attempts has been reached then return all bets
2288             if (++payoutAttempts[matchId] >= MAX_NUM_PAYOUT_ATTEMPTS) {
2289                 mtch.locked = true;
2290                 emit MatchFailedPayoutRelease(matchId);
2291             } else {
2292                 emit MatchUpdated(matchId);
2293                 string memory url;
2294                 string memory querytype;
2295                 uint limit;
2296                 // if the contract has already verified the sportsmonks api
2297                 // use football-data.org as a secondary source of truth
2298                 if (firstVerification) {
2299                     url = strConcat(
2300                         "json(https://api.football-data.org/v1/fixtures/", 
2301                         matches[matchId].fixtureId,
2302                         ").fixture.result.[goalsHomeTeam,goalsAwayTeam]");
2303                     querytype = "URL";
2304                     limit = secondaryGasLimit;
2305                 } else {                
2306                     url = strConcat(
2307                         "[URL] json(https://soccer.sportmonks.com/api/v2.0/fixtures/",
2308                         matches[matchId].secondaryFixtureId,
2309                         "?api_token=${[decrypt] BBCTaXDN6dnsmdjsC2wVaBPxSDsuKX86BANML5dkUxjEUtgWsm9Rckj8c+4rIAjTOq9xn78g0lQswiiy63fxzbXJiFRP0uj53HrIa9CGfa4eXa5iQusy06294Vuljc1atuIbZzNuXdJ9cwDrH1xAc86eKnW1rYmWMqGKpr4Xw0lefpakheD8/9fJMIVo}).data.scores[localteam_score,visitorteam_score]");
2310                     querytype = "nested";
2311                     // use primary gas limit since that query won't payout winners on callback
2312                     limit = primaryGasLimit;
2313                 }
2314                 bytes32 oraclizeId = oraclize_query(PAYOUT_ATTEMPT_INTERVAL, querytype, url, limit);
2315                 oraclizeIds[oraclizeId] = matchId;
2316             }
2317         } else {
2318             payoutAttempts[matchId] = 0;
2319             // eg. result = "[2, 4]"
2320             strings.slice memory s = _result.toSlice();
2321             // remove the braces from the result
2322             s = s.beyond("[".toSlice());
2323             s = s.until("]".toSlice());
2324             // split the string to get the two string encoded ints
2325             strings.slice memory x = s.split(", ".toSlice());
2326             // parse them to int to get the scores
2327             uint awayScore = parseInt(s.toString()); 
2328             uint homeScore = parseInt(x.toString());
2329             uint8 matchResult;
2330             // determine the winner
2331             if (homeScore > awayScore) {
2332                 matchResult = 1;
2333             } else if (homeScore < awayScore) {
2334                 matchResult = 2;
2335             } else {
2336                 matchResult = 3;
2337             }
2338             // if this is the query to sportsmonks
2339             if (!firstVerification) {
2340                 // set pending winner and call the second source of truth
2341                 pendingWinner[matchId] = matchResult;
2342                 firstStepVerified[matchId] = true;
2343                 url = strConcat(
2344                     "json(https://api.football-data.org/v1/fixtures/", 
2345                     matches[matchId].fixtureId,
2346                     ").fixture.result.[goalsHomeTeam,goalsAwayTeam]");
2347                 oraclizeId = oraclize_query("nested", url, secondaryGasLimit);
2348                 oraclizeIds[oraclizeId] = matchId;
2349             } else {
2350                 mtch.locked = true;
2351                 // if one of the APIs has the teams inverted then flip the result
2352                 if (matches[matchId].inverted) {
2353                     if (matchResult == 1) {
2354                         matchResult = 2;
2355                     } else if (matchResult == 2) {
2356                         matchResult = 1;
2357                     }
2358                 }
2359                 // if the both APIs confirm the same winner then payout the winners
2360                 if (pendingWinner[matchId] == matchResult) {
2361                     mtch.winner = matchResult;
2362                     emit MatchUpdated(matchId);
2363                 } else {
2364                     // else don't set a winner because a source of truth couldn't be verified
2365                     // this way users can still reclaim their original bet amount
2366                     emit MatchFailedPayoutRelease(matchId);
2367                 }
2368             }
2369         }
2370     }
2371     
2372     function() public payable {}
2373 }