1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /*
50  * @title String & slice utility library for Solidity contracts.
51  * @author Nick Johnson <arachnid@notdot.net>
52  *
53  * @dev Functionality in this library is largely implemented using an
54  *      abstraction called a 'slice'. A slice represents a part of a string -
55  *      anything from the entire string to a single character, or even no
56  *      characters at all (a 0-length slice). Since a slice only has to specify
57  *      an offset and a length, copying and manipulating slices is a lot less
58  *      expensive than copying and manipulating the strings they reference.
59  *
60  *      To further reduce gas costs, most functions on slice that need to return
61  *      a slice modify the original one instead of allocating a new one; for
62  *      instance, `s.split(".")` will return the text up to the first '.',
63  *      modifying s to only contain the remainder of the string after the '.'.
64  *      In situations where you do not want to modify the original slice, you
65  *      can make a copy first with `.copy()`, for example:
66  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
67  *      Solidity has no memory management, it will result in allocating many
68  *      short-lived slices that are later discarded.
69  *
70  *      Functions that return two slices come in two versions: a non-allocating
71  *      version that takes the second slice as an argument, modifying it in
72  *      place, and an allocating version that allocates and returns the second
73  *      slice; see `nextRune` for example.
74  *
75  *      Functions that have to copy string data will return strings rather than
76  *      slices; these can be cast back to slices for further processing if
77  *      required.
78  *
79  *      For convenience, some functions are provided with non-modifying
80  *      variants that create a new slice and return both; for instance,
81  *      `s.splitNew('.')` leaves s unmodified, and returns two values
82  *      corresponding to the left and right parts of the string.
83  */
84 library strings {
85     struct slice {
86         uint _len;
87         uint _ptr;
88     }
89 
90     function memcpy(uint dest, uint src, uint len) private {
91         // Copy word-length chunks while possible
92         for(; len >= 32; len -= 32) {
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
114     function toSlice(string self) internal returns (slice) {
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
127     function len(bytes32 self) internal returns (uint) {
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
160     function toSliceB32(bytes32 self) internal returns (slice ret) {
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
176     function copy(slice self) internal returns (slice) {
177         return slice(self._len, self._ptr);
178     }
179 
180     /*
181      * @dev Copies a slice to a new string.
182      * @param self The slice to copy.
183      * @return A newly allocated string containing the slice's text.
184      */
185     function toString(slice self) internal returns (string) {
186         var ret = new string(self._len);
187         uint retptr;
188         assembly { retptr := add(ret, 32) }
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
202     function len(slice self) internal returns (uint l) {
203         // Starting at ptr-31 means the LSB will be the byte we care about
204         var ptr = self._ptr - 31;
205         var end = ptr + self._len;
206         for (l = 0; ptr < end; l++) {
207             uint8 b;
208             assembly { b := and(mload(ptr), 0xFF) }
209             if (b < 0x80) {
210                 ptr += 1;
211             } else if(b < 0xE0) {
212                 ptr += 2;
213             } else if(b < 0xF0) {
214                 ptr += 3;
215             } else if(b < 0xF8) {
216                 ptr += 4;
217             } else if(b < 0xFC) {
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
230     function empty(slice self) internal returns (bool) {
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
243     function compare(slice self, slice other) internal returns (int) {
244         uint shortest = self._len;
245         if (other._len < self._len)
246             shortest = other._len;
247 
248         var selfptr = self._ptr;
249         var otherptr = other._ptr;
250         for (uint idx = 0; idx < shortest; idx += 32) {
251             uint a;
252             uint b;
253             assembly {
254                 a := mload(selfptr)
255                 b := mload(otherptr)
256             }
257             if (a != b) {
258                 // Mask out irrelevant bytes and check again
259                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
260                 var diff = (a & mask) - (b & mask);
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
276     function equals(slice self, slice other) internal returns (bool) {
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
287     function nextRune(slice self, slice rune) internal returns (slice) {
288         rune._ptr = self._ptr;
289 
290         if (self._len == 0) {
291             rune._len = 0;
292             return rune;
293         }
294 
295         uint len;
296         uint b;
297         // Load the first byte of the rune into the LSBs of b
298         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
299         if (b < 0x80) {
300             len = 1;
301         } else if(b < 0xE0) {
302             len = 2;
303         } else if(b < 0xF0) {
304             len = 3;
305         } else {
306             len = 4;
307         }
308 
309         // Check for truncated codepoints
310         if (len > self._len) {
311             rune._len = self._len;
312             self._ptr += self._len;
313             self._len = 0;
314             return rune;
315         }
316 
317         self._ptr += len;
318         self._len -= len;
319         rune._len = len;
320         return rune;
321     }
322 
323     /*
324      * @dev Returns the first rune in the slice, advancing the slice to point
325      *      to the next rune.
326      * @param self The slice to operate on.
327      * @return A slice containing only the first rune from `self`.
328      */
329     function nextRune(slice self) internal returns (slice ret) {
330         nextRune(self, ret);
331     }
332 
333     /*
334      * @dev Returns the number of the first codepoint in the slice.
335      * @param self The slice to operate on.
336      * @return The number of the first codepoint in the slice.
337      */
338     function ord(slice self) internal returns (uint ret) {
339         if (self._len == 0) {
340             return 0;
341         }
342 
343         uint word;
344         uint length;
345         uint divisor = 2 ** 248;
346 
347         // Load the rune into the MSBs of b
348         assembly { word:= mload(mload(add(self, 32))) }
349         var b = word / divisor;
350         if (b < 0x80) {
351             ret = b;
352             length = 1;
353         } else if(b < 0xE0) {
354             ret = b & 0x1F;
355             length = 2;
356         } else if(b < 0xF0) {
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
387     function keccak(slice self) internal returns (bytes32 ret) {
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
399     function startsWith(slice self, slice needle) internal returns (bool) {
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
425     function beyond(slice self, slice needle) internal returns (slice) {
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
454     function endsWith(slice self, slice needle) internal returns (bool) {
455         if (self._len < needle._len) {
456             return false;
457         }
458 
459         var selfptr = self._ptr + self._len - needle._len;
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
482     function until(slice self, slice needle) internal returns (slice) {
483         if (self._len < needle._len) {
484             return self;
485         }
486 
487         var selfptr = self._ptr + self._len - needle._len;
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
504     // Returns the memory address of the first byte of the first occurrence of
505     // `needle` in `self`, or the first byte after `self` if not found.
506     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
507         uint ptr;
508         uint idx;
509 
510         if (needlelen <= selflen) {
511             if (needlelen <= 32) {
512                 // Optimized assembly for 68 gas per byte on short strings
513                 assembly {
514                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
515                     let needledata := and(mload(needleptr), mask)
516                     let end := add(selfptr, sub(selflen, needlelen))
517                     ptr := selfptr
518                     loop:
519                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
520                     ptr := add(ptr, 1)
521                     jumpi(loop, lt(sub(ptr, 1), end))
522                     ptr := add(selfptr, selflen)
523                     exit:
524                 }
525                 return ptr;
526             } else {
527                 // For long needles, use hashing
528                 bytes32 hash;
529                 assembly { hash := sha3(needleptr, needlelen) }
530                 ptr = selfptr;
531                 for (idx = 0; idx <= selflen - needlelen; idx++) {
532                     bytes32 testHash;
533                     assembly { testHash := sha3(ptr, needlelen) }
534                     if (hash == testHash)
535                         return ptr;
536                     ptr += 1;
537                 }
538             }
539         }
540         return selfptr + selflen;
541     }
542 
543     // Returns the memory address of the first byte after the last occurrence of
544     // `needle` in `self`, or the address of `self` if not found.
545     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
546         uint ptr;
547 
548         if (needlelen <= selflen) {
549             if (needlelen <= 32) {
550                 // Optimized assembly for 69 gas per byte on short strings
551                 assembly {
552                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
553                     let needledata := and(mload(needleptr), mask)
554                     ptr := add(selfptr, sub(selflen, needlelen))
555                     loop:
556                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
557                     ptr := sub(ptr, 1)
558                     jumpi(loop, gt(add(ptr, 1), selfptr))
559                     ptr := selfptr
560                     jump(exit)
561                     ret:
562                     ptr := add(ptr, needlelen)
563                     exit:
564                 }
565                 return ptr;
566             } else {
567                 // For long needles, use hashing
568                 bytes32 hash;
569                 assembly { hash := sha3(needleptr, needlelen) }
570                 ptr = selfptr + (selflen - needlelen);
571                 while (ptr >= selfptr) {
572                     bytes32 testHash;
573                     assembly { testHash := sha3(ptr, needlelen) }
574                     if (hash == testHash)
575                         return ptr + needlelen;
576                     ptr -= 1;
577                 }
578             }
579         }
580         return selfptr;
581     }
582 
583     /*
584      * @dev Modifies `self` to contain everything from the first occurrence of
585      *      `needle` to the end of the slice. `self` is set to the empty slice
586      *      if `needle` is not found.
587      * @param self The slice to search and modify.
588      * @param needle The text to search for.
589      * @return `self`.
590      */
591     function find(slice self, slice needle) internal returns (slice) {
592         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
593         self._len -= ptr - self._ptr;
594         self._ptr = ptr;
595         return self;
596     }
597 
598     /*
599      * @dev Modifies `self` to contain the part of the string from the start of
600      *      `self` to the end of the first occurrence of `needle`. If `needle`
601      *      is not found, `self` is set to the empty slice.
602      * @param self The slice to search and modify.
603      * @param needle The text to search for.
604      * @return `self`.
605      */
606     function rfind(slice self, slice needle) internal returns (slice) {
607         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
608         self._len = ptr - self._ptr;
609         return self;
610     }
611 
612     /*
613      * @dev Splits the slice, setting `self` to everything after the first
614      *      occurrence of `needle`, and `token` to everything before it. If
615      *      `needle` does not occur in `self`, `self` is set to the empty slice,
616      *      and `token` is set to the entirety of `self`.
617      * @param self The slice to split.
618      * @param needle The text to search for in `self`.
619      * @param token An output parameter to which the first token is written.
620      * @return `token`.
621      */
622     function split(slice self, slice needle, slice token) internal returns (slice) {
623         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
624         token._ptr = self._ptr;
625         token._len = ptr - self._ptr;
626         if (ptr == self._ptr + self._len) {
627             // Not found
628             self._len = 0;
629         } else {
630             self._len -= token._len + needle._len;
631             self._ptr = ptr + needle._len;
632         }
633         return token;
634     }
635 
636     /*
637      * @dev Splits the slice, setting `self` to everything after the first
638      *      occurrence of `needle`, and returning everything before it. If
639      *      `needle` does not occur in `self`, `self` is set to the empty slice,
640      *      and the entirety of `self` is returned.
641      * @param self The slice to split.
642      * @param needle The text to search for in `self`.
643      * @return The part of `self` up to the first occurrence of `delim`.
644      */
645     function split(slice self, slice needle) internal returns (slice token) {
646         split(self, needle, token);
647     }
648 
649     /*
650      * @dev Splits the slice, setting `self` to everything before the last
651      *      occurrence of `needle`, and `token` to everything after it. If
652      *      `needle` does not occur in `self`, `self` is set to the empty slice,
653      *      and `token` is set to the entirety of `self`.
654      * @param self The slice to split.
655      * @param needle The text to search for in `self`.
656      * @param token An output parameter to which the first token is written.
657      * @return `token`.
658      */
659     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
660         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
661         token._ptr = ptr;
662         token._len = self._len - (ptr - self._ptr);
663         if (ptr == self._ptr) {
664             // Not found
665             self._len = 0;
666         } else {
667             self._len -= token._len + needle._len;
668         }
669         return token;
670     }
671 
672     /*
673      * @dev Splits the slice, setting `self` to everything before the last
674      *      occurrence of `needle`, and returning everything after it. If
675      *      `needle` does not occur in `self`, `self` is set to the empty slice,
676      *      and the entirety of `self` is returned.
677      * @param self The slice to split.
678      * @param needle The text to search for in `self`.
679      * @return The part of `self` after the last occurrence of `delim`.
680      */
681     function rsplit(slice self, slice needle) internal returns (slice token) {
682         rsplit(self, needle, token);
683     }
684 
685     /*
686      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
687      * @param self The slice to search.
688      * @param needle The text to search for in `self`.
689      * @return The number of occurrences of `needle` found in `self`.
690      */
691     function count(slice self, slice needle) internal returns (uint cnt) {
692         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
693         while (ptr <= self._ptr + self._len) {
694             cnt++;
695             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
696         }
697     }
698 
699     /*
700      * @dev Returns True if `self` contains `needle`.
701      * @param self The slice to search.
702      * @param needle The text to search for in `self`.
703      * @return True if `needle` is found in `self`, false otherwise.
704      */
705     function contains(slice self, slice needle) internal returns (bool) {
706         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
707     }
708 
709     /*
710      * @dev Returns a newly allocated string containing the concatenation of
711      *      `self` and `other`.
712      * @param self The first slice to concatenate.
713      * @param other The second slice to concatenate.
714      * @return The concatenation of the two strings.
715      */
716     function concat(slice self, slice other) internal returns (string) {
717         var ret = new string(self._len + other._len);
718         uint retptr;
719         assembly { retptr := add(ret, 32) }
720         memcpy(retptr, self._ptr, self._len);
721         memcpy(retptr + self._len, other._ptr, other._len);
722         return ret;
723     }
724 
725     /*
726      * @dev Joins an array of slices, using `self` as a delimiter, returning a
727      *      newly allocated string.
728      * @param self The delimiter to use.
729      * @param parts A list of slices to join.
730      * @return A newly allocated string containing all the slices in `parts`,
731      *         joined with `self`.
732      */
733     function join(slice self, slice[] parts) internal returns (string) {
734         if (parts.length == 0)
735             return "";
736 
737         uint length = self._len * (parts.length - 1);
738         for (uint i = 0; i < parts.length; i++) {
739             length += parts[i]._len;
740         }
741 
742         var ret = new string(length);
743         uint retptr;
744         assembly { retptr := add(ret, 32) }
745 
746         for(i = 0; i < parts.length; i++) {
747             memcpy(retptr, parts[i]._ptr, parts[i]._len);
748             retptr += parts[i]._len;
749             if (i < parts.length - 1) {
750                 memcpy(retptr, self._ptr, self._len);
751                 retptr += self._len;
752             }
753         }
754 
755         return ret;
756     }
757 }
758 
759 /**
760  * @title Ownable
761  * @dev The Ownable contract has an owner address, and provides basic authorization control
762  * functions, this simplifies the implementation of "user permissions".
763  */
764 contract Ownable {
765   address public owner;
766 
767 
768   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
769 
770 
771   /**
772    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
773    * account.
774    */
775   function Ownable() public {
776     owner = msg.sender;
777   }
778 
779   /**
780    * @dev Throws if called by any account other than the owner.
781    */
782   modifier onlyOwner() {
783     require(msg.sender == owner);
784     _;
785   }
786 
787   /**
788    * @dev Allows the current owner to transfer control of the contract to a newOwner.
789    * @param newOwner The address to transfer ownership to.
790    */
791   function transferOwnership(address newOwner) public onlyOwner {
792     require(newOwner != address(0));
793     OwnershipTransferred(owner, newOwner);
794     owner = newOwner;
795   }
796 
797 }
798 
799 /**
800  * @title Roles
801  * @author Francisco Giordano (@frangio)
802  * @dev Library for managing addresses assigned to a Role.
803  *      See RBAC.sol for example usage.
804  */
805 library Roles {
806     struct Role {
807         mapping (address => bool) bearer;
808     }
809 
810     /**
811     * @dev give an address access to this role
812     */
813     function add(Role storage role, address addr) internal {
814         role.bearer[addr] = true;
815     }
816 
817     /**
818     * @dev remove an address' access to this role
819     */
820     function remove(Role storage role, address addr) internal {
821         role.bearer[addr] = false;
822     }
823 
824     /**
825     * @dev check if an address has this role
826     * // reverts
827     */
828     function check(Role storage role, address addr) view internal {
829         require(has(role, addr));
830     }
831 
832     /**
833     * @dev check if an address has this role
834     * @return bool
835     */
836     function has(Role storage role, address addr) view internal returns (bool) {
837         return role.bearer[addr];
838     }
839 }
840 
841 /**
842  * @title RBAC (Role-Based Access Control)
843  * @author Matt Condon (@Shrugs)
844  * @dev Stores and provides setters and getters for roles and addresses.
845  *      Supports unlimited numbers of roles and addresses.
846  *      See //contracts/mocks/RBACMock.sol for an example of usage.
847  * This RBAC method uses strings to key roles. It may be beneficial
848  *  for you to write your own implementation of this interface using Enums or similar.
849  * It's also recommended that you define constants in the contract, like ROLE_ADMIN below,
850  *  to avoid typos.
851  */
852 contract RBAC is Ownable {
853     using Roles for Roles.Role;
854 
855     mapping (string => Roles.Role) private roles;
856 
857     event RoleAdded(address addr, string roleName);
858     event RoleRemoved(address addr, string roleName);
859 
860     /**
861     * @dev constructor. Sets msg.sender as admin by default
862     */
863     function RBAC() public {
864     }
865 
866     /**
867     * @dev reverts if addr does not have role
868     * @param addr address
869     * @param roleName the name of the role
870     * // reverts
871     */
872     function checkRole(address addr, string roleName) view public {
873         roles[roleName].check(addr);
874     }
875 
876     /**
877     * @dev determine if addr has role
878     * @param addr address
879     * @param roleName the name of the role
880     * @return bool
881     */
882     function hasRole(address addr, string roleName) view public returns (bool) {
883         return roles[roleName].has(addr);
884     }
885 
886     /**
887     * @dev add a role to an address
888     * @param addr address
889     * @param roleName the name of the role
890     */
891     function adminAddRole(address addr, string roleName) onlyOwner public {
892         roles[roleName].add(addr);
893         RoleAdded(addr, roleName);
894     }
895 
896     /**
897     * @dev remove a role from an address
898     * @param addr address
899     * @param roleName the name of the role
900     */
901     function adminRemoveRole(address addr, string roleName) onlyOwner public {
902         roles[roleName].remove(addr);
903         RoleRemoved(addr, roleName);
904     }
905 
906     /**
907     * @dev modifier to scope access to a single role (uses msg.sender as addr)
908     * @param roleName the name of the role
909     * // reverts
910     */
911     modifier onlyRole(string roleName) {
912         checkRole(msg.sender, roleName);
913         _;
914     }
915 
916     modifier onlyOwnerOr(string roleName) {
917         require(msg.sender == owner || roles[roleName].has(msg.sender));
918         _;
919     }    
920 }
921 
922 /**
923  * @title Heritable
924  * @dev The Heritable contract provides ownership transfer capabilities, in the
925  * case that the current owner stops "heartbeating". Only the heir can pronounce the
926  * owner's death.
927  */
928 contract Heritable is RBAC {
929   address private heir_;
930 
931   // Time window the owner has to notify they are alive.
932   uint256 private heartbeatTimeout_;
933 
934   // Timestamp of the owner's death, as pronounced by the heir.
935   uint256 private timeOfDeath_;
936 
937   event HeirChanged(address indexed owner, address indexed newHeir);
938   event OwnerHeartbeated(address indexed owner);
939   event OwnerProclaimedDead(address indexed owner, address indexed heir, uint256 timeOfDeath);
940   event HeirOwnershipClaimed(address indexed previousOwner, address indexed newOwner);
941 
942 
943   /**
944    * @dev Throw an exception if called by any account other than the heir's.
945    */
946   modifier onlyHeir() {
947     require(msg.sender == heir_);
948     _;
949   }
950 
951 
952   /**
953    * @notice Create a new Heritable Contract with heir address 0x0.
954    * @param _heartbeatTimeout time available for the owner to notify they are alive,
955    * before the heir can take ownership.
956    */
957   function Heritable(uint256 _heartbeatTimeout) public {
958     setHeartbeatTimeout(_heartbeatTimeout);
959   }
960 
961   function setHeir(address newHeir) public onlyOwner {
962     require(newHeir != owner);
963     heartbeat();
964     HeirChanged(owner, newHeir);
965     heir_ = newHeir;
966   }
967 
968   /**
969    * @dev Use these getter functions to access the internal variables in
970    * an inherited contract.
971    */
972   function heir() public view returns(address) {
973     return heir_;
974   }
975 
976   function heartbeatTimeout() public view returns(uint256) {
977     return heartbeatTimeout_;
978   }
979   
980   function timeOfDeath() public view returns(uint256) {
981     return timeOfDeath_;
982   }
983 
984   /**
985    * @dev set heir = 0x0
986    */
987   function removeHeir() public onlyOwner {
988     heartbeat();
989     heir_ = 0;
990   }
991 
992   /**
993    * @dev Heir can pronounce the owners death. To claim the ownership, they will
994    * have to wait for `heartbeatTimeout` seconds.
995    */
996   function proclaimDeath() public onlyHeir {
997     require(ownerLives());
998     OwnerProclaimedDead(owner, heir_, timeOfDeath_);
999     timeOfDeath_ = block.timestamp;
1000   }
1001 
1002   /**
1003    * @dev Owner can send a heartbeat if they were mistakenly pronounced dead.
1004    */
1005   function heartbeat() public onlyOwner {
1006     OwnerHeartbeated(owner);
1007     timeOfDeath_ = 0;
1008   }
1009 
1010   /**
1011    * @dev Allows heir to transfer ownership only if heartbeat has timed out.
1012    */
1013   function claimHeirOwnership() public onlyHeir {
1014     require(!ownerLives());
1015     require(block.timestamp >= timeOfDeath_ + heartbeatTimeout_);
1016     OwnershipTransferred(owner, heir_);
1017     HeirOwnershipClaimed(owner, heir_);
1018     owner = heir_;
1019     timeOfDeath_ = 0;
1020   }
1021 
1022   function setHeartbeatTimeout(uint256 newHeartbeatTimeout) internal onlyOwner {
1023     require(ownerLives());
1024     heartbeatTimeout_ = newHeartbeatTimeout;
1025   }
1026 
1027   function ownerLives() internal view returns (bool) {
1028     return timeOfDeath_ == 0;
1029   }
1030 }
1031 
1032 contract BettingBase {
1033     enum BetStatus {
1034         None,
1035         Won
1036     }
1037 
1038     enum LineStages {
1039         OpenedUntilStart,
1040         ResultSubmitted,
1041         Cancelled,
1042         Refunded,
1043         Paid
1044     }    
1045 
1046     enum LineType {
1047         ThreeWay,
1048         TwoWay,
1049         DoubleChance,
1050         SomeOfMany
1051     }
1052 
1053     enum TwoWayLineType {
1054         Standart,
1055         YesNo,
1056         OverUnder,
1057         AsianHandicap,
1058         HeadToHead
1059     }
1060 
1061     enum PaymentType {
1062         No,
1063         Gain, 
1064         Refund
1065     }
1066 }
1067 
1068 contract AbstractBetStorage is BettingBase {
1069     function addBet(uint lineId, uint betId, address player, uint amount) external;
1070     function addLine(uint lineId, LineType lineType, uint start, uint resultCount) external;
1071     function cancelLine(uint lineId) external;
1072     function getBetPool(uint lineId, uint betId) external view returns (BetStatus status, uint sum);
1073     function getLineData(uint lineId) external view returns (uint startTime, uint resultCount, LineType lineType, LineStages stage);
1074     function getLineData2(uint lineId) external view returns (uint resultCount, LineStages stage);
1075     function getLineSum(uint lineId) external view returns (uint sum);
1076     function getPlayerBet(uint lineId, uint betId, address player) external view returns (uint result);
1077     function getSumOfPlayerBetsById(uint lineId, uint playerId, PaymentType paymentType) external view returns (address player, uint amount);
1078     function isBetStorage() external pure returns (bool);
1079     function setLineStartTime(uint lineId, uint time) external;    
1080     function startPayments(uint lineId, uint chunkSize) external returns (PaymentType paymentType, uint startId, uint endId, uint luckyPool, uint unluckyPool);
1081     function submitResult(uint lineId, uint[] results) external;
1082     function transferOwnership(address newOwner) public;
1083     function tryCloseLine(uint lineId, uint lastPlayerId, PaymentType paymentType) external returns (bool lineClosed);
1084 }
1085 
1086 contract BettingCore is BettingBase, Heritable {
1087     using SafeMath for uint;
1088     using strings for *;
1089 
1090     enum ActivityType{
1091         Soccer,
1092         IceHockey,
1093         Basketball,
1094         Tennis,
1095         BoxingAndMMA, 
1096         Formula1,               
1097         Volleyball,
1098         Chess,
1099         Athletics,
1100         Biathlon,
1101         Baseball,
1102         Rugby,
1103         AmericanFootball,
1104         Cycling,
1105         AutoMotorSports,        
1106         Other
1107     }    
1108     
1109     struct Activity {
1110         string title;
1111         ActivityType activityType;
1112     }
1113 
1114     struct Event {
1115         uint activityId;
1116         string title;
1117     }    
1118 
1119     struct Line {
1120         uint eventId;
1121         string title;
1122         string outcomes;
1123     }
1124 
1125     struct FeeDiscount {
1126         uint64 till;
1127         uint8 discount;
1128     }    
1129 
1130     // it's not possible to take off players bets
1131     bool public payoutToOwnerIsLimited;
1132     // total sum of bets
1133     uint public blockedSum; 
1134     uint public fee;
1135     uint public minBetAmount;
1136     string public contractMessage;
1137    
1138     Activity[] public activities;
1139     Event[] public events;
1140     Line[] private lines;
1141 
1142     mapping(address => FeeDiscount) private discounts;
1143 
1144     event NewActivity(uint indexed activityId, ActivityType activityType, string title);
1145     event NewEvent(uint indexed activityId, uint indexed eventId, string title);
1146     event NewLine(uint indexed eventId, uint indexed lineId, string title, LineType lineType, uint start, string outcomes);     
1147     event BetMade(uint indexed lineId, uint betId, address indexed player, uint amount);
1148     event PlayerPaid(uint indexed lineId, address indexed player, uint amount);
1149     event ResultSubmitted(uint indexed lineId, uint[] results);
1150     event LineCanceled(uint indexed lineId, string comment);
1151     event LineClosed(uint indexed lineId, PaymentType paymentType, uint totalPool);
1152     event LineStartTimeChanged(uint indexed lineId, uint newTime);
1153 
1154     AbstractBetStorage private betStorage;
1155 
1156     function BettingCore() Heritable(2592000) public {
1157         minBetAmount = 5 finney; // 0.005 ETH
1158         fee = 200; // 2 %
1159         payoutToOwnerIsLimited = true;
1160         blockedSum = 1 wei;
1161         contractMessage = "betdapp.co";
1162     }
1163 
1164     function() external onlyOwner payable {
1165     }
1166 
1167     function addActivity(ActivityType activityType, string title) external onlyOwnerOr("Edit") returns (uint activityId) {
1168         Activity memory _activity = Activity({
1169             title: title, 
1170             activityType: activityType
1171         });
1172 
1173         activityId = activities.push(_activity) - 1;
1174         NewActivity(activityId, activityType, title);
1175     }
1176 
1177     function addDoubleChanceLine(uint eventId, string title, uint start) external onlyOwnerOr("Edit") {
1178         addLine(eventId, title, LineType.DoubleChance, start, "1X_12_X2");
1179     }
1180 
1181     function addEvent(uint activityId, string title) external onlyOwnerOr("Edit") returns (uint eventId) {
1182         Event memory _event = Event({
1183             activityId: activityId, 
1184             title: title
1185         });
1186 
1187         eventId = events.push(_event) - 1;
1188         NewEvent(activityId, eventId, title);      
1189     }
1190 
1191     function addThreeWayLine(uint eventId, string title, uint start) external onlyOwnerOr("Edit") {
1192         addLine(eventId, title, LineType.ThreeWay, start,  "1_X_2");
1193     }
1194 
1195     function addSomeOfManyLine(uint eventId, string title, uint start, string outcomes) external onlyOwnerOr("Edit") {
1196         addLine(eventId, title, LineType.SomeOfMany, start, outcomes);
1197     }
1198 
1199     function addTwoWayLine(uint eventId, string title, uint start, TwoWayLineType customType) external onlyOwnerOr("Edit") {
1200         string memory outcomes;
1201 
1202         if (customType == TwoWayLineType.YesNo) {
1203             outcomes = "Yes_No";
1204         } else if (customType == TwoWayLineType.OverUnder) {
1205             outcomes = "Over_Under";
1206         } else {
1207             outcomes = "1_2";
1208         }
1209         
1210         addLine(eventId, title, LineType.TwoWay, start, outcomes);
1211     }
1212 
1213     function bet(uint lineId, uint betId) external payable {
1214         uint amount = msg.value;
1215         require(amount >= minBetAmount);
1216         address player = msg.sender;
1217         betStorage.addBet(lineId, betId, player, amount);
1218         blockedSum = blockedSum.add(amount);
1219         BetMade(lineId, betId, player, amount);
1220     }
1221 
1222     function cancelLine(uint lineId, string comment) external onlyOwnerOr("Submit") {
1223         betStorage.cancelLine(lineId);
1224         LineCanceled(lineId, comment);
1225     }   
1226 
1227     function getMyBets(uint lineId) external view returns (uint[] result) {
1228         return getPlayerBets(lineId, msg.sender);
1229     }
1230 
1231     function getMyDiscount() external view returns (uint discount, uint till) {
1232         (discount, till) = getPlayerDiscount(msg.sender);
1233     }
1234 
1235     function getLineData(uint lineId) external view returns (uint eventId, string title, string outcomes, uint startTime, uint resultCount, LineType lineType, LineStages stage, BetStatus[] status, uint[] pool) {
1236         (startTime, resultCount, lineType, stage) = betStorage.getLineData(lineId);
1237 
1238         Line storage line = lines[lineId];
1239         eventId = line.eventId;
1240         title = line.title;
1241         outcomes = line.outcomes;
1242         status = new BetStatus[](resultCount);
1243         pool = new uint[](resultCount);
1244 
1245         for (uint i = 0; i < resultCount; i++) {
1246             (status[i], pool[i]) = betStorage.getBetPool(lineId, i);
1247         }
1248     }
1249 
1250     function getLineStat(uint lineId) external view returns (LineStages stage, BetStatus[] status, uint[] pool) {       
1251         uint resultCount;
1252         (resultCount, stage) = betStorage.getLineData2(lineId);
1253         status = new BetStatus[](resultCount);
1254         pool = new uint[](resultCount);
1255 
1256         for (uint i = 0; i < resultCount; i++) {
1257             (status[i], pool[i]) = betStorage.getBetPool(lineId, i);
1258         }
1259     }
1260 
1261     // emergency
1262     function kill() external onlyOwner {
1263         selfdestruct(msg.sender);
1264     }
1265 
1266     function payout(uint sum) external onlyOwner {
1267         require(sum > 0);
1268         require(!payoutToOwnerIsLimited || (this.balance - blockedSum) >= sum);
1269         msg.sender.transfer(sum);
1270     }    
1271 
1272     function payPlayers(uint lineId, uint chunkSize) external onlyOwnerOr("Pay") {
1273         uint startId;
1274         uint endId;
1275         PaymentType paymentType;
1276         uint luckyPool;
1277         uint unluckyPool;
1278 
1279         (paymentType, startId, endId, luckyPool, unluckyPool) = betStorage.startPayments(lineId, chunkSize);
1280 
1281         for (uint i = startId; i < endId; i++) {
1282             address player;
1283             uint amount; 
1284             (player, amount) = betStorage.getSumOfPlayerBetsById(lineId, i, paymentType);
1285 
1286             if (amount == 0) {
1287                 continue;
1288             }
1289 
1290             uint payment;            
1291             
1292             if (paymentType == PaymentType.Gain) {
1293                 payment = amount.add(amount.mul(unluckyPool).div(luckyPool)).div(10000).mul(10000 - getFee(player));
1294 
1295                 if (payment < amount) {
1296                     payment = amount;
1297                 }
1298             } else {
1299                 payment = amount;               
1300             }
1301 
1302             if (payment > 0) {
1303                 player.transfer(payment);
1304                 PlayerPaid(lineId, player, payment);
1305             }
1306         }
1307 
1308         if (betStorage.tryCloseLine(lineId, endId, paymentType)) {
1309             uint totalPool = betStorage.getLineSum(lineId);
1310             blockedSum = blockedSum.sub(totalPool);
1311             LineClosed(lineId, paymentType, totalPool);
1312         }
1313     }
1314     
1315     function setContractMessage(string value) external onlyOwner {
1316         contractMessage = value;
1317     }    
1318 
1319     function setDiscountForPlayer(address player, uint discount, uint till) external onlyOwner {
1320         require(till > now && discount > 0 && discount <= 100);
1321         discounts[player].till = uint64(till);
1322         discounts[player].discount = uint8(discount);
1323     }
1324 
1325     function setFee(uint value) external onlyOwner {
1326         // 100 = 1% fee;
1327         require(value >= 0 && value <= 500);
1328         fee = value;
1329     }
1330 
1331     function setLineStartTime(uint lineId, uint time) external onlyOwnerOr("Edit") {
1332         betStorage.setLineStartTime(lineId, time);
1333         LineStartTimeChanged(lineId, time);
1334     }    
1335 
1336     function setMinBetAmount(uint value) external onlyOwner {
1337         require(value > 0);
1338         minBetAmount = value;
1339     }
1340 
1341     // if something goes wrong with contract, we can turn on this function
1342     // and then withdraw balance and pay players by hand without need to kill contract
1343     function setPayoutLimit(bool value) external onlyOwner {
1344         payoutToOwnerIsLimited = value;
1345     }
1346 
1347     function setStorage(address contractAddress) external onlyOwner {        
1348         AbstractBetStorage candidateContract = AbstractBetStorage(contractAddress);
1349         require(candidateContract.isBetStorage());
1350         betStorage = candidateContract;
1351         // betStorage.transferOwnership(address(this));
1352     }
1353 
1354     function setStorageOwner(address newOwner) external onlyOwner {
1355         betStorage.transferOwnership(newOwner);
1356     }    
1357 
1358     function submitResult(uint lineId, uint[] results) external onlyOwnerOr("Submit") {
1359         betStorage.submitResult(lineId, results);
1360         ResultSubmitted(lineId, results);
1361     }    
1362 
1363     function addLine(uint eventId, string title, LineType lineType, uint start, string outcomes) private {
1364         require(start > now);
1365 
1366         Line memory line = Line({
1367             eventId: eventId, 
1368             title: title, 
1369             outcomes: outcomes
1370         });
1371 
1372         uint lineId = lines.push(line) - 1;
1373         uint resultCount;
1374 
1375         if (lineType == LineType.ThreeWay || lineType == LineType.DoubleChance) {
1376             resultCount = 3;           
1377         } else if (lineType == LineType.TwoWay) {
1378             resultCount = 2; 
1379         } else {
1380             resultCount = getSplitCount(outcomes);
1381         }       
1382 
1383         betStorage.addLine(lineId, lineType, start, resultCount);
1384         NewLine(eventId, lineId, title, lineType, start, outcomes);
1385     }
1386 
1387     function getFee(address player) private view returns (uint newFee) {
1388         var data = discounts[player];
1389 
1390         if (data.till > now) {
1391             return fee * (100 - data.discount) / 100;
1392         }
1393 
1394         return fee;
1395     }    
1396 
1397     function getPlayerBets(uint lineId, address player) private view returns (uint[] result) {
1398         Line storage line = lines[lineId];
1399         uint count = getSplitCount(line.outcomes);
1400         result = new uint[](count);
1401 
1402         for (uint i = 0; i < count; i++) {
1403             result[i] = betStorage.getPlayerBet(lineId, i, player);
1404         }
1405     }
1406 
1407     function getPlayerDiscount(address player) private view returns (uint discount, uint till) {
1408         FeeDiscount storage discountFee = discounts[player];
1409         discount = discountFee.discount;
1410         till = discountFee.till;
1411     }    
1412 
1413     function getSplitCount(string input) private returns (uint) { 
1414         var s = input.toSlice();
1415         var delim = "_".toSlice();
1416         var parts = new string[](s.count(delim) + 1);
1417 
1418         for (uint i = 0; i < parts.length; i++) {
1419             parts[i] = s.split(delim).toString();
1420         }
1421 
1422         return parts.length;
1423     }
1424 }