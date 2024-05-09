1 pragma solidity 0.4.24;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() public {owner = msg.sender;}
18 
19     /// @notice `owner` can step down and assign some other address to this role
20     /// @param _newOwner The address of the new owner. 0x0 can be used to create
21     ///  an unowned neutral vault, however that cannot be undone
22     function changeOwner(address _newOwner) public onlyOwner {
23         owner = _newOwner;
24     }
25 }
26 
27 contract Precondition is Owned {
28 
29     string public name;
30     uint public version;
31     bool public active = false;
32 
33     constructor(string _name, uint _version, bool _active) public {
34         name = _name;
35         version = _version;
36         active = _active;
37     }
38 
39     function setActive(bool _active) external onlyOwner {
40         active = _active;
41     }
42 
43     function isValid(bytes32 _platform, string _platformId, address _token, uint256 _value, address _funder) external view returns (bool valid);
44 }
45 
46 /*
47  * @title String & slice utility library for Solidity contracts.
48  * @author Nick Johnson <arachnid@notdot.net>
49  *
50  * @dev Functionality in this library is largely implemented using an
51  *      abstraction called a 'slice'. A slice represents a part of a string -
52  *      anything from the entire string to a single character, or even no
53  *      characters at all (a 0-length slice). Since a slice only has to specify
54  *      an offset and a length, copying and manipulating slices is a lot less
55  *      expensive than copying and manipulating the strings they reference.
56  *
57  *      To further reduce gas costs, most functions on slice that need to return
58  *      a slice modify the original one instead of allocating a new one; for
59  *      instance, `s.split(".")` will return the text up to the first '.',
60  *      modifying s to only contain the remainder of the string after the '.'.
61  *      In situations where you do not want to modify the original slice, you
62  *      can make a copy first with `.copy()`, for example:
63  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
64  *      Solidity has no memory management, it will result in allocating many
65  *      short-lived slices that are later discarded.
66  *
67  *      Functions that return two slices come in two versions: a non-allocating
68  *      version that takes the second slice as an argument, modifying it in
69  *      place, and an allocating version that allocates and returns the second
70  *      slice; see `nextRune` for example.
71  *
72  *      Functions that have to copy string data will return strings rather than
73  *      slices; these can be cast back to slices for further processing if
74  *      required.
75  *
76  *      For convenience, some functions are provided with non-modifying
77  *      variants that create a new slice and return both; for instance,
78  *      `s.splitNew('.')` leaves s unmodified, and returns two values
79  *      corresponding to the left and right parts of the string.
80  */
81 
82 
83 
84 library strings {
85     struct slice {
86         uint _len;
87         uint _ptr;
88     }
89 
90     function memcpy(uint dest, uint src, uint len) private pure {
91         // Copy word-length chunks while possible
92         for (; len >= 32; len -= 32) {
93             assembly {
94                 mstore(dest, mload(src))
95             }
96             dest += 32;
97             src += 32;
98         }
99 
100         // Copy remaining bytes
101         uint mask = 256 ** (32 - len) - 1;
102         assembly {
103             let srcpart := and(mload(src), not(mask))
104             let destpart := and(mload(dest), mask)
105             mstore(dest, or(destpart, srcpart))
106         }
107     }
108 
109     /*
110      * @dev Returns a slice containing the entire string.
111      * @param self The string to make a slice from.
112      * @return A newly allocated slice containing the entire string.
113      */
114     function toSlice(string self) internal pure returns (slice) {
115         uint ptr;
116         assembly {
117             ptr := add(self, 0x20)
118         }
119         return slice(bytes(self).length, ptr);
120     }
121 
122     /*
123      * @dev Returns the length of a null-terminated bytes32 string.
124      * @param self The value to find the length of.
125      * @return The length of the string, from 0 to 32.
126      */
127     function len(bytes32 self) internal pure returns (uint) {
128         uint ret;
129         if (self == 0)
130             return 0;
131         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
132             ret += 16;
133             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
134         }
135         if (self & 0xffffffffffffffff == 0) {
136             ret += 8;
137             self = bytes32(uint(self) / 0x10000000000000000);
138         }
139         if (self & 0xffffffff == 0) {
140             ret += 4;
141             self = bytes32(uint(self) / 0x100000000);
142         }
143         if (self & 0xffff == 0) {
144             ret += 2;
145             self = bytes32(uint(self) / 0x10000);
146         }
147         if (self & 0xff == 0) {
148             ret += 1;
149         }
150         return 32 - ret;
151     }
152 
153     /*
154      * @dev Returns a slice containing the entire bytes32, interpreted as a
155      *      null-termintaed utf-8 string.
156      * @param self The bytes32 value to convert to a slice.
157      * @return A new slice containing the value of the input argument up to the
158      *         first null.
159      */
160     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
161         // Allocate space for `self` in memory, copy it there, and point ret at it
162         assembly {
163             let ptr := mload(0x40)
164             mstore(0x40, add(ptr, 0x20))
165             mstore(ptr, self)
166             mstore(add(ret, 0x20), ptr)
167         }
168         ret._len = len(self);
169     }
170 
171     /*
172      * @dev Returns a new slice containing the same data as the current slice.
173      * @param self The slice to copy.
174      * @return A new slice containing the same data as `self`.
175      */
176     function copy(slice self) internal pure returns (slice) {
177         return slice(self._len, self._ptr);
178     }
179 
180     /*
181      * @dev Copies a slice to a new string.
182      * @param self The slice to copy.
183      * @return A newly allocated string containing the slice's text.
184      */
185     function toString(slice self) internal pure returns (string) {
186         string memory ret = new string(self._len);
187         uint retptr;
188         assembly {retptr := add(ret, 32)}
189 
190         memcpy(retptr, self._ptr, self._len);
191         return ret;
192     }
193 
194     /*
195      * @dev Returns the length in runes of the slice. Note that this operation
196      *      takes time proportional to the length of the slice; avoid using it
197      *      in loops, and call `slice.empty()` if you only need to know whether
198      *      the slice is empty or not.
199      * @param self The slice to operate on.
200      * @return The length of the slice in runes.
201      */
202     function len(slice self) internal pure returns (uint l) {
203         // Starting at ptr-31 means the LSB will be the byte we care about
204         uint ptr = self._ptr - 31;
205         uint end = ptr + self._len;
206         for (l = 0; ptr < end; l++) {
207             uint8 b;
208             assembly {b := and(mload(ptr), 0xFF)}
209             if (b < 0x80) {
210                 ptr += 1;
211             } else if (b < 0xE0) {
212                 ptr += 2;
213             } else if (b < 0xF0) {
214                 ptr += 3;
215             } else if (b < 0xF8) {
216                 ptr += 4;
217             } else if (b < 0xFC) {
218                 ptr += 5;
219             } else {
220                 ptr += 6;
221             }
222         }
223     }
224 
225     /*
226      * @dev Returns true if the slice is empty (has a length of 0).
227      * @param self The slice to operate on.
228      * @return True if the slice is empty, False otherwise.
229      */
230     function empty(slice self) internal pure returns (bool) {
231         return self._len == 0;
232     }
233 
234     /*
235      * @dev Returns a positive number if `other` comes lexicographically after
236      *      `self`, a negative number if it comes before, or zero if the
237      *      contents of the two slices are equal. Comparison is done per-rune,
238      *      on unicode codepoints.
239      * @param self The first slice to compare.
240      * @param other The second slice to compare.
241      * @return The result of the comparison.
242      */
243     function compare(slice self, slice other) internal pure returns (int) {
244         uint shortest = self._len;
245         if (other._len < self._len)
246             shortest = other._len;
247 
248         uint selfptr = self._ptr;
249         uint otherptr = other._ptr;
250         for (uint idx = 0; idx < shortest; idx += 32) {
251             uint a;
252             uint b;
253             assembly {
254                 a := mload(selfptr)
255                 b := mload(otherptr)
256             }
257             if (a != b) {
258                 // Mask out irrelevant bytes and check again
259                 uint256 mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
260                 uint256 diff = (a & mask) - (b & mask);
261                 if (diff != 0)
262                     return int(diff);
263             }
264             selfptr += 32;
265             otherptr += 32;
266         }
267         return int(self._len) - int(other._len);
268     }
269 
270     /*
271      * @dev Returns true if the two slices contain the same text.
272      * @param self The first slice to compare.
273      * @param self The second slice to compare.
274      * @return True if the slices are equal, false otherwise.
275      */
276     function equals(slice self, slice other) internal pure returns (bool) {
277         return compare(self, other) == 0;
278     }
279 
280     /*
281      * @dev Extracts the first rune in the slice into `rune`, advancing the
282      *      slice to point to the next rune and returning `self`.
283      * @param self The slice to operate on.
284      * @param rune The slice that will contain the first rune.
285      * @return `rune`.
286      */
287     function nextRune(slice self, slice rune) internal pure returns (slice) {
288         rune._ptr = self._ptr;
289 
290         if (self._len == 0) {
291             rune._len = 0;
292             return rune;
293         }
294 
295         uint l;
296         uint b;
297         // Load the first byte of the rune into the LSBs of b
298         assembly {b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF)}
299         if (b < 0x80) {
300             l = 1;
301         } else if (b < 0xE0) {
302             l = 2;
303         } else if (b < 0xF0) {
304             l = 3;
305         } else {
306             l = 4;
307         }
308 
309         // Check for truncated codepoints
310         if (l > self._len) {
311             rune._len = self._len;
312             self._ptr += self._len;
313             self._len = 0;
314             return rune;
315         }
316 
317         self._ptr += l;
318         self._len -= l;
319         rune._len = l;
320         return rune;
321     }
322 
323     /*
324      * @dev Returns the first rune in the slice, advancing the slice to point
325      *      to the next rune.
326      * @param self The slice to operate on.
327      * @return A slice containing only the first rune from `self`.
328      */
329     function nextRune(slice self) internal pure returns (slice ret) {
330         nextRune(self, ret);
331     }
332 
333     /*
334      * @dev Returns the number of the first codepoint in the slice.
335      * @param self The slice to operate on.
336      * @return The number of the first codepoint in the slice.
337      */
338     function ord(slice self) internal pure returns (uint ret) {
339         if (self._len == 0) {
340             return 0;
341         }
342 
343         uint word;
344         uint length;
345         uint divisor = 2 ** 248;
346 
347         // Load the rune into the MSBs of b
348         assembly {word := mload(mload(add(self, 32)))}
349         uint b = word / divisor;
350         if (b < 0x80) {
351             ret = b;
352             length = 1;
353         } else if (b < 0xE0) {
354             ret = b & 0x1F;
355             length = 2;
356         } else if (b < 0xF0) {
357             ret = b & 0x0F;
358             length = 3;
359         } else {
360             ret = b & 0x07;
361             length = 4;
362         }
363 
364         // Check for truncated codepoints
365         if (length > self._len) {
366             return 0;
367         }
368 
369         for (uint i = 1; i < length; i++) {
370             divisor = divisor / 256;
371             b = (word / divisor) & 0xFF;
372             if (b & 0xC0 != 0x80) {
373                 // Invalid UTF-8 sequence
374                 return 0;
375             }
376             ret = (ret * 64) | (b & 0x3F);
377         }
378 
379         return ret;
380     }
381 
382     /*
383      * @dev Returns the keccak-256 hash of the slice.
384      * @param self The slice to hash.
385      * @return The hash of the slice.
386      */
387     function keccak(slice self) internal pure returns (bytes32 ret) {
388         assembly {
389             ret := keccak256(mload(add(self, 32)), mload(self))
390         }
391     }
392 
393     /*
394      * @dev Returns true if `self` starts with `needle`.
395      * @param self The slice to operate on.
396      * @param needle The slice to search for.
397      * @return True if the slice starts with the provided text, false otherwise.
398      */
399     function startsWith(slice self, slice needle) internal pure returns (bool) {
400         if (self._len < needle._len) {
401             return false;
402         }
403 
404         if (self._ptr == needle._ptr) {
405             return true;
406         }
407 
408         bool equal;
409         assembly {
410             let length := mload(needle)
411             let selfptr := mload(add(self, 0x20))
412             let needleptr := mload(add(needle, 0x20))
413             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
414         }
415         return equal;
416     }
417 
418     /*
419      * @dev If `self` starts with `needle`, `needle` is removed from the
420      *      beginning of `self`. Otherwise, `self` is unmodified.
421      * @param self The slice to operate on.
422      * @param needle The slice to search for.
423      * @return `self`
424      */
425     function beyond(slice self, slice needle) internal pure returns (slice) {
426         if (self._len < needle._len) {
427             return self;
428         }
429 
430         bool equal = true;
431         if (self._ptr != needle._ptr) {
432             assembly {
433                 let length := mload(needle)
434                 let selfptr := mload(add(self, 0x20))
435                 let needleptr := mload(add(needle, 0x20))
436                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
437             }
438         }
439 
440         if (equal) {
441             self._len -= needle._len;
442             self._ptr += needle._len;
443         }
444 
445         return self;
446     }
447 
448     /*
449      * @dev Returns true if the slice ends with `needle`.
450      * @param self The slice to operate on.
451      * @param needle The slice to search for.
452      * @return True if the slice starts with the provided text, false otherwise.
453      */
454     function endsWith(slice self, slice needle) internal pure returns (bool) {
455         if (self._len < needle._len) {
456             return false;
457         }
458 
459         uint selfptr = self._ptr + self._len - needle._len;
460 
461         if (selfptr == needle._ptr) {
462             return true;
463         }
464 
465         bool equal;
466         assembly {
467             let length := mload(needle)
468             let needleptr := mload(add(needle, 0x20))
469             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
470         }
471 
472         return equal;
473     }
474 
475     /*
476      * @dev If `self` ends with `needle`, `needle` is removed from the
477      *      end of `self`. Otherwise, `self` is unmodified.
478      * @param self The slice to operate on.
479      * @param needle The slice to search for.
480      * @return `self`
481      */
482     function until(slice self, slice needle) internal pure returns (slice) {
483         if (self._len < needle._len) {
484             return self;
485         }
486 
487         uint selfptr = self._ptr + self._len - needle._len;
488         bool equal = true;
489         if (selfptr != needle._ptr) {
490             assembly {
491                 let length := mload(needle)
492                 let needleptr := mload(add(needle, 0x20))
493                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
494             }
495         }
496 
497         if (equal) {
498             self._len -= needle._len;
499         }
500 
501         return self;
502     }
503 
504     event log_bytemask(bytes32 mask);
505 
506     // Returns the memory address of the first byte of the first occurrence of
507     // `needle` in `self`, or the first byte after `self` if not found.
508     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
509         uint ptr = selfptr;
510         uint idx;
511 
512         if (needlelen <= selflen) {
513             if (needlelen <= 32) {
514                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
515 
516                 bytes32 needledata;
517                 assembly {needledata := and(mload(needleptr), mask)}
518 
519                 uint end = selfptr + selflen - needlelen;
520                 bytes32 ptrdata;
521                 assembly {ptrdata := and(mload(ptr), mask)}
522 
523                 while (ptrdata != needledata) {
524                     if (ptr >= end)
525                         return selfptr + selflen;
526                     ptr++;
527                     assembly {ptrdata := and(mload(ptr), mask)}
528                 }
529                 return ptr;
530             } else {
531                 // For long needles, use hashing
532                 bytes32 hash;
533                 assembly {hash := sha3(needleptr, needlelen)}
534 
535                 for (idx = 0; idx <= selflen - needlelen; idx++) {
536                     bytes32 testHash;
537                     assembly {testHash := sha3(ptr, needlelen)}
538                     if (hash == testHash)
539                         return ptr;
540                     ptr += 1;
541                 }
542             }
543         }
544         return selfptr + selflen;
545     }
546 
547     // Returns the memory address of the first byte after the last occurrence of
548     // `needle` in `self`, or the address of `self` if not found.
549     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
550         uint ptr;
551 
552         if (needlelen <= selflen) {
553             if (needlelen <= 32) {
554                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
555 
556                 bytes32 needledata;
557                 assembly {needledata := and(mload(needleptr), mask)}
558 
559                 ptr = selfptr + selflen - needlelen;
560                 bytes32 ptrdata;
561                 assembly {ptrdata := and(mload(ptr), mask)}
562 
563                 while (ptrdata != needledata) {
564                     if (ptr <= selfptr)
565                         return selfptr;
566                     ptr--;
567                     assembly {ptrdata := and(mload(ptr), mask)}
568                 }
569                 return ptr + needlelen;
570             } else {
571                 // For long needles, use hashing
572                 bytes32 hash;
573                 assembly {hash := sha3(needleptr, needlelen)}
574                 ptr = selfptr + (selflen - needlelen);
575                 while (ptr >= selfptr) {
576                     bytes32 testHash;
577                     assembly {testHash := sha3(ptr, needlelen)}
578                     if (hash == testHash)
579                         return ptr + needlelen;
580                     ptr -= 1;
581                 }
582             }
583         }
584         return selfptr;
585     }
586 
587     /*
588      * @dev Modifies `self` to contain everything from the first occurrence of
589      *      `needle` to the end of the slice. `self` is set to the empty slice
590      *      if `needle` is not found.
591      * @param self The slice to search and modify.
592      * @param needle The text to search for.
593      * @return `self`.
594      */
595     function find(slice self, slice needle) internal pure returns (slice) {
596         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
597         self._len -= ptr - self._ptr;
598         self._ptr = ptr;
599         return self;
600     }
601 
602     /*
603      * @dev Modifies `self` to contain the part of the string from the start of
604      *      `self` to the end of the first occurrence of `needle`. If `needle`
605      *      is not found, `self` is set to the empty slice.
606      * @param self The slice to search and modify.
607      * @param needle The text to search for.
608      * @return `self`.
609      */
610     function rfind(slice self, slice needle) internal pure returns (slice) {
611         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
612         self._len = ptr - self._ptr;
613         return self;
614     }
615 
616     /*
617      * @dev Splits the slice, setting `self` to everything after the first
618      *      occurrence of `needle`, and `token` to everything before it. If
619      *      `needle` does not occur in `self`, `self` is set to the empty slice,
620      *      and `token` is set to the entirety of `self`.
621      * @param self The slice to split.
622      * @param needle The text to search for in `self`.
623      * @param token An output parameter to which the first token is written.
624      * @return `token`.
625      */
626     function split(slice self, slice needle, slice token) internal pure returns (slice) {
627         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
628         token._ptr = self._ptr;
629         token._len = ptr - self._ptr;
630         if (ptr == self._ptr + self._len) {
631             // Not found
632             self._len = 0;
633         } else {
634             self._len -= token._len + needle._len;
635             self._ptr = ptr + needle._len;
636         }
637         return token;
638     }
639 
640     /*
641      * @dev Splits the slice, setting `self` to everything after the first
642      *      occurrence of `needle`, and returning everything before it. If
643      *      `needle` does not occur in `self`, `self` is set to the empty slice,
644      *      and the entirety of `self` is returned.
645      * @param self The slice to split.
646      * @param needle The text to search for in `self`.
647      * @return The part of `self` up to the first occurrence of `delim`.
648      */
649     function split(slice self, slice needle) internal pure returns (slice token) {
650         split(self, needle, token);
651     }
652 
653     /*
654      * @dev Splits the slice, setting `self` to everything before the last
655      *      occurrence of `needle`, and `token` to everything after it. If
656      *      `needle` does not occur in `self`, `self` is set to the empty slice,
657      *      and `token` is set to the entirety of `self`.
658      * @param self The slice to split.
659      * @param needle The text to search for in `self`.
660      * @param token An output parameter to which the first token is written.
661      * @return `token`.
662      */
663     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
664         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
665         token._ptr = ptr;
666         token._len = self._len - (ptr - self._ptr);
667         if (ptr == self._ptr) {
668             // Not found
669             self._len = 0;
670         } else {
671             self._len -= token._len + needle._len;
672         }
673         return token;
674     }
675 
676     /*
677      * @dev Splits the slice, setting `self` to everything before the last
678      *      occurrence of `needle`, and returning everything after it. If
679      *      `needle` does not occur in `self`, `self` is set to the empty slice,
680      *      and the entirety of `self` is returned.
681      * @param self The slice to split.
682      * @param needle The text to search for in `self`.
683      * @return The part of `self` after the last occurrence of `delim`.
684      */
685     function rsplit(slice self, slice needle) internal pure returns (slice token) {
686         rsplit(self, needle, token);
687     }
688 
689     /*
690      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
691      * @param self The slice to search.
692      * @param needle The text to search for in `self`.
693      * @return The number of occurrences of `needle` found in `self`.
694      */
695     function count(slice self, slice needle) internal pure returns (uint cnt) {
696         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
697         while (ptr <= self._ptr + self._len) {
698             cnt++;
699             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
700         }
701     }
702 
703     /*
704      * @dev Returns True if `self` contains `needle`.
705      * @param self The slice to search.
706      * @param needle The text to search for in `self`.
707      * @return True if `needle` is found in `self`, false otherwise.
708      */
709     function contains(slice self, slice needle) internal pure returns (bool) {
710         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
711     }
712 
713     /*
714      * @dev Returns a newly allocated string containing the concatenation of
715      *      `self` and `other`.
716      * @param self The first slice to concatenate.
717      * @param other The second slice to concatenate.
718      * @return The concatenation of the two strings.
719      */
720     function concat(slice self, slice other) internal pure returns (string) {
721         string memory ret = new string(self._len + other._len);
722         uint retptr;
723         assembly {retptr := add(ret, 32)}
724         memcpy(retptr, self._ptr, self._len);
725         memcpy(retptr + self._len, other._ptr, other._len);
726         return ret;
727     }
728 
729     /*
730      * @dev Joins an array of slices, using `self` as a delimiter, returning a
731      *      newly allocated string.
732      * @param self The delimiter to use.
733      * @param parts A list of slices to join.
734      * @return A newly allocated string containing all the slices in `parts`,
735      *         joined with `self`.
736      */
737     function join(slice self, slice[] parts) internal pure returns (string) {
738         if (parts.length == 0)
739             return "";
740 
741         uint length = self._len * (parts.length - 1);
742         for (uint i = 0; i < parts.length; i++)
743             length += parts[i]._len;
744 
745         string memory ret = new string(length);
746         uint retptr;
747         assembly {retptr := add(ret, 32)}
748 
749         for (i = 0; i < parts.length; i++) {
750             memcpy(retptr, parts[i]._ptr, parts[i]._len);
751             retptr += parts[i]._len;
752             if (i < parts.length - 1) {
753                 memcpy(retptr, self._ptr, self._len);
754                 retptr += self._len;
755             }
756         }
757 
758         return ret;
759     }
760 
761     /*
762     * Additions by the FundRequest Team
763     */
764 
765     function toBytes32(slice self) internal pure returns (bytes32 result) {
766         string memory source = toString(self);
767         bytes memory tempEmptyStringTest = bytes(source);
768         if (tempEmptyStringTest.length == 0) {
769             return 0x0;
770         }
771 
772         assembly {
773             result := mload(add(source, 32))
774         }
775     }
776 
777     function strConcat(string _a, string _b, string _c, string _d, string _e) pure internal returns (string){
778         bytes memory _ba = bytes(_a);
779         bytes memory _bb = bytes(_b);
780         bytes memory _bc = bytes(_c);
781         bytes memory _bd = bytes(_d);
782         bytes memory _be = bytes(_e);
783         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
784         bytes memory babcde = bytes(abcde);
785         uint k = 0;
786         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
787         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
788         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
789         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
790         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
791         return string(babcde);
792     }
793 
794     function strConcat(string _a, string _b, string _c, string _d) pure internal returns (string) {
795         return strConcat(_a, _b, _c, _d, "");
796     }
797 
798     function strConcat(string _a, string _b, string _c) pure internal returns (string) {
799         return strConcat(_a, _b, _c, "", "");
800     }
801 
802     function strConcat(string _a, string _b) pure internal returns (string) {
803         return strConcat(_a, _b, "", "", "");
804     }
805 
806     function addressToString(address x) internal pure returns (string) {
807         bytes memory s = new bytes(40);
808         for (uint i = 0; i < 20; i++) {
809             byte b = byte(uint8(uint(x) / (2 ** (8 * (19 - i)))));
810             byte hi = byte(uint8(b) / 16);
811             byte lo = byte(uint8(b) - 16 * uint8(hi));
812             s[2 * i] = charToByte(hi);
813             s[2 * i + 1] = charToByte(lo);
814         }
815         return strConcat("0x", string(s));
816     }
817 
818     function charToByte(byte b) internal pure returns (byte c) {
819         if (b < 10) return byte(uint8(b) + 0x30);
820         else return byte(uint8(b) + 0x57);
821     }
822 
823     function bytes32ToString(bytes32 x) internal pure returns (string) {
824         bytes memory bytesString = new bytes(32);
825         uint charCount = 0;
826         for (uint j = 0; j < 32; j++) {
827             byte ch = byte(bytes32(uint(x) * 2 ** (8 * j)));
828             if (ch != 0) {
829                 bytesString[charCount] = ch;
830                 charCount++;
831             }
832         }
833         bytes memory bytesStringTrimmed = new bytes(charCount);
834         for (j = 0; j < charCount; j++) {
835             bytesStringTrimmed[j] = bytesString[j];
836         }
837         return string(bytesStringTrimmed);
838     }
839 }
840 
841 contract TokenWhitelistPrecondition is Precondition {
842 
843     using strings for *;
844 
845     event Allowed(address indexed token, bool allowed);
846     event Allowed(address indexed token, bool allowed, bytes32 platform, string platformId);
847 
848     //platform -> platformId -> token => _allowed
849     mapping(bytes32 => mapping(string => mapping(address => bool))) tokenWhitelist;
850 
851     //token => _allowed
852     mapping(address => bool) defaultWhitelist;
853 
854     //all tokens that either got allowed or disallowed
855     address[] public tokens;
856     mapping(address => bool) existingToken;
857 
858     constructor(string _name, uint _version, bool _active) public Precondition(_name, _version, _active) {
859         //constructor
860     }
861 
862     function isValid(bytes32 _platform, string _platformId, address _token, uint256 /*_value */, address /* _funder */) external view returns (bool valid) {
863         return !active || (defaultWhitelist[_token] == true || tokenWhitelist[_platform][extractRepository(_platformId)][_token] == true);
864     }
865 
866     function allowDefaultToken(address _token, bool _allowed) public onlyOwner {
867         defaultWhitelist[_token] = _allowed;
868         if (!existingToken[_token]) {
869             existingToken[_token] = true;
870             tokens.push(_token);
871         }
872         emit Allowed(_token, _allowed);
873     }
874 
875     function allow(bytes32 _platform, string _platformId, address _token, bool _allowed) external onlyOwner {
876         tokenWhitelist[_platform][_platformId][_token] = _allowed;
877         if (!existingToken[_token]) {
878             existingToken[_token] = true;
879             tokens.push(_token);
880         }
881         emit Allowed(_token, _allowed, _platform, _platformId);
882     }
883 
884     function extractRepository(string _platformId) pure internal returns (string repository) {
885         var sliced = string(_platformId).toSlice();
886         var platform = sliced.split("|FR|".toSlice());
887         return platform.toString();
888     }
889 
890     function amountOfTokens() external view returns (uint) {
891         return tokens.length;
892     }
893 }