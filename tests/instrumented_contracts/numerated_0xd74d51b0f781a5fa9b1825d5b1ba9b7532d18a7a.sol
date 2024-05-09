1 /*
2  * @title String & slice utility library for Solidity contracts.
3  * @author Nick Johnson <arachnid@notdot.net>
4  *
5  * @dev Functionality in this library is largely implemented using an
6  *      abstraction called a 'slice'. A slice represents a part of a string -
7  *      anything from the entire string to a single character, or even no
8  *      characters at all (a 0-length slice). Since a slice only has to specify
9  *      an offset and a length, copying and manipulating slices is a lot less
10  *      expensive than copying and manipulating the strings they reference.
11  *
12  *      To further reduce gas costs, most functions on slice that need to return
13  *      a slice modify the original one instead of allocating a new one; for
14  *      instance, `s.split(".")` will return the text up to the first '.',
15  *      modifying s to only contain the remainder of the string after the '.'.
16  *      In situations where you do not want to modify the original slice, you
17  *      can make a copy first with `.copy()`, for example:
18  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
19  *      Solidity has no memory management, it will result in allocating many
20  *      short-lived slices that are later discarded.
21  *
22  *      Functions that return two slices come in two versions: a non-allocating
23  *      version that takes the second slice as an argument, modifying it in
24  *      place, and an allocating version that allocates and returns the second
25  *      slice; see `nextRune` for example.
26  *
27  *      Functions that have to copy string data will return strings rather than
28  *      slices; these can be cast back to slices for further processing if
29  *      required.
30  *
31  *      For convenience, some functions are provided with non-modifying
32  *      variants that create a new slice and return both; for instance,
33  *      `s.splitNew('.')` leaves s unmodified, and returns two values
34  *      corresponding to the left and right parts of the string.
35  */
36 
37 pragma solidity ^0.4.7;
38 
39 library strings {
40     struct slice {
41         uint _len;
42         uint _ptr;
43     }
44 
45     function memcpy(uint dest, uint src, uint len) private {
46         // Copy word-length chunks while possible
47         for(; len >= 32; len -= 32) {
48             assembly {
49                 mstore(dest, mload(src))
50             }
51             dest += 32;
52             src += 32;
53         }
54 
55         // Copy remaining bytes
56         uint mask = 256 ** (32 - len) - 1;
57         assembly {
58             let srcpart := and(mload(src), not(mask))
59             let destpart := and(mload(dest), mask)
60             mstore(dest, or(destpart, srcpart))
61         }
62     }
63 
64     /*
65      * @dev Returns a slice containing the entire string.
66      * @param self The string to make a slice from.
67      * @return A newly allocated slice containing the entire string.
68      */
69     function toSlice(string self) internal returns (slice) {
70         uint ptr;
71         assembly {
72             ptr := add(self, 0x20)
73         }
74         return slice(bytes(self).length, ptr);
75     }
76 
77     /*
78      * @dev Returns the length of a null-terminated bytes32 string.
79      * @param self The value to find the length of.
80      * @return The length of the string, from 0 to 32.
81      */
82     function len(bytes32 self) internal returns (uint) {
83         uint ret;
84         if (self == 0)
85             return 0;
86         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
87             ret += 16;
88             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
89         }
90         if (self & 0xffffffffffffffff == 0) {
91             ret += 8;
92             self = bytes32(uint(self) / 0x10000000000000000);
93         }
94         if (self & 0xffffffff == 0) {
95             ret += 4;
96             self = bytes32(uint(self) / 0x100000000);
97         }
98         if (self & 0xffff == 0) {
99             ret += 2;
100             self = bytes32(uint(self) / 0x10000);
101         }
102         if (self & 0xff == 0) {
103             ret += 1;
104         }
105         return 32 - ret;
106     }
107 
108     /*
109      * @dev Returns a slice containing the entire bytes32, interpreted as a
110      *      null-termintaed utf-8 string.
111      * @param self The bytes32 value to convert to a slice.
112      * @return A new slice containing the value of the input argument up to the
113      *         first null.
114      */
115     function toSliceB32(bytes32 self) internal returns (slice ret) {
116         // Allocate space for `self` in memory, copy it there, and point ret at it
117         assembly {
118             let ptr := mload(0x40)
119             mstore(0x40, add(ptr, 0x20))
120             mstore(ptr, self)
121             mstore(add(ret, 0x20), ptr)
122         }
123         ret._len = len(self);
124     }
125 
126     /*
127      * @dev Returns a new slice containing the same data as the current slice.
128      * @param self The slice to copy.
129      * @return A new slice containing the same data as `self`.
130      */
131     function copy(slice self) internal returns (slice) {
132         return slice(self._len, self._ptr);
133     }
134 
135     /*
136      * @dev Copies a slice to a new string.
137      * @param self The slice to copy.
138      * @return A newly allocated string containing the slice's text.
139      */
140     function toString(slice self) internal returns (string) {
141         var ret = new string(self._len);
142         uint retptr;
143         assembly { retptr := add(ret, 32) }
144 
145         memcpy(retptr, self._ptr, self._len);
146         return ret;
147     }
148 
149     /*
150      * @dev Returns the length in runes of the slice. Note that this operation
151      *      takes time proportional to the length of the slice; avoid using it
152      *      in loops, and call `slice.empty()` if you only need to know whether
153      *      the slice is empty or not.
154      * @param self The slice to operate on.
155      * @return The length of the slice in runes.
156      */
157     function len(slice self) internal returns (uint) {
158         // Starting at ptr-31 means the LSB will be the byte we care about
159         var ptr = self._ptr - 31;
160         var end = ptr + self._len;
161         for (uint len = 0; ptr < end; len++) {
162             uint8 b;
163             assembly { b := and(mload(ptr), 0xFF) }
164             if (b < 0x80) {
165                 ptr += 1;
166             } else if(b < 0xE0) {
167                 ptr += 2;
168             } else if(b < 0xF0) {
169                 ptr += 3;
170             } else if(b < 0xF8) {
171                 ptr += 4;
172             } else if(b < 0xFC) {
173                 ptr += 5;
174             } else {
175                 ptr += 6;
176             }
177         }
178         return len;
179     }
180 
181     /*
182      * @dev Returns true if the slice is empty (has a length of 0).
183      * @param self The slice to operate on.
184      * @return True if the slice is empty, False otherwise.
185      */
186     function empty(slice self) internal returns (bool) {
187         return self._len == 0;
188     }
189 
190     /*
191      * @dev Returns a positive number if `other` comes lexicographically after
192      *      `self`, a negative number if it comes before, or zero if the
193      *      contents of the two slices are equal. Comparison is done per-rune,
194      *      on unicode codepoints.
195      * @param self The first slice to compare.
196      * @param other The second slice to compare.
197      * @return The result of the comparison.
198      */
199     function compare(slice self, slice other) internal returns (int) {
200         uint shortest = self._len;
201         if (other._len < self._len)
202             shortest = other._len;
203 
204         var selfptr = self._ptr;
205         var otherptr = other._ptr;
206         for (uint idx = 0; idx < shortest; idx += 32) {
207             uint a;
208             uint b;
209             assembly {
210                 a := mload(selfptr)
211                 b := mload(otherptr)
212             }
213             if (a != b) {
214                 // Mask out irrelevant bytes and check again
215                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
216                 var diff = (a & mask) - (b & mask);
217                 if (diff != 0)
218                     return int(diff);
219             }
220             selfptr += 32;
221             otherptr += 32;
222         }
223         return int(self._len) - int(other._len);
224     }
225 
226     /*
227      * @dev Returns true if the two slices contain the same text.
228      * @param self The first slice to compare.
229      * @param self The second slice to compare.
230      * @return True if the slices are equal, false otherwise.
231      */
232     function equals(slice self, slice other) internal returns (bool) {
233         return compare(self, other) == 0;
234     }
235 
236     /*
237      * @dev Extracts the first rune in the slice into `rune`, advancing the
238      *      slice to point to the next rune and returning `self`.
239      * @param self The slice to operate on.
240      * @param rune The slice that will contain the first rune.
241      * @return `rune`.
242      */
243     function nextRune(slice self, slice rune) internal returns (slice) {
244         rune._ptr = self._ptr;
245 
246         if (self._len == 0) {
247             rune._len = 0;
248             return rune;
249         }
250 
251         uint len;
252         uint b;
253         // Load the first byte of the rune into the LSBs of b
254         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
255         if (b < 0x80) {
256             len = 1;
257         } else if(b < 0xE0) {
258             len = 2;
259         } else if(b < 0xF0) {
260             len = 3;
261         } else {
262             len = 4;
263         }
264 
265         // Check for truncated codepoints
266         if (len > self._len) {
267             rune._len = self._len;
268             self._ptr += self._len;
269             self._len = 0;
270             return rune;
271         }
272 
273         self._ptr += len;
274         self._len -= len;
275         rune._len = len;
276         return rune;
277     }
278 
279     /*
280      * @dev Returns the first rune in the slice, advancing the slice to point
281      *      to the next rune.
282      * @param self The slice to operate on.
283      * @return A slice containing only the first rune from `self`.
284      */
285     function nextRune(slice self) internal returns (slice ret) {
286         nextRune(self, ret);
287     }
288 
289     /*
290      * @dev Returns the number of the first codepoint in the slice.
291      * @param self The slice to operate on.
292      * @return The number of the first codepoint in the slice.
293      */
294     function ord(slice self) internal returns (uint ret) {
295         if (self._len == 0) {
296             return 0;
297         }
298 
299         uint word;
300         uint len;
301         uint div = 2 ** 248;
302 
303         // Load the rune into the MSBs of b
304         assembly { word:= mload(mload(add(self, 32))) }
305         var b = word / div;
306         if (b < 0x80) {
307             ret = b;
308             len = 1;
309         } else if(b < 0xE0) {
310             ret = b & 0x1F;
311             len = 2;
312         } else if(b < 0xF0) {
313             ret = b & 0x0F;
314             len = 3;
315         } else {
316             ret = b & 0x07;
317             len = 4;
318         }
319 
320         // Check for truncated codepoints
321         if (len > self._len) {
322             return 0;
323         }
324 
325         for (uint i = 1; i < len; i++) {
326             div = div / 256;
327             b = (word / div) & 0xFF;
328             if (b & 0xC0 != 0x80) {
329                 // Invalid UTF-8 sequence
330                 return 0;
331             }
332             ret = (ret * 64) | (b & 0x3F);
333         }
334 
335         return ret;
336     }
337 
338     /*
339      * @dev Returns the keccak-256 hash of the slice.
340      * @param self The slice to hash.
341      * @return The hash of the slice.
342      */
343     function keccak(slice self) internal returns (bytes32 ret) {
344         assembly {
345             ret := sha3(mload(add(self, 32)), mload(self))
346         }
347     }
348 
349     /*
350      * @dev Returns true if `self` starts with `needle`.
351      * @param self The slice to operate on.
352      * @param needle The slice to search for.
353      * @return True if the slice starts with the provided text, false otherwise.
354      */
355     function startsWith(slice self, slice needle) internal returns (bool) {
356         if (self._len < needle._len) {
357             return false;
358         }
359 
360         if (self._ptr == needle._ptr) {
361             return true;
362         }
363 
364         bool equal;
365         assembly {
366             let len := mload(needle)
367             let selfptr := mload(add(self, 0x20))
368             let needleptr := mload(add(needle, 0x20))
369             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
370         }
371         return equal;
372     }
373 
374     /*
375      * @dev If `self` starts with `needle`, `needle` is removed from the
376      *      beginning of `self`. Otherwise, `self` is unmodified.
377      * @param self The slice to operate on.
378      * @param needle The slice to search for.
379      * @return `self`
380      */
381     function beyond(slice self, slice needle) internal returns (slice) {
382         if (self._len < needle._len) {
383             return self;
384         }
385 
386         bool equal = true;
387         if (self._ptr != needle._ptr) {
388             assembly {
389                 let len := mload(needle)
390                 let selfptr := mload(add(self, 0x20))
391                 let needleptr := mload(add(needle, 0x20))
392                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
393             }
394         }
395 
396         if (equal) {
397             self._len -= needle._len;
398             self._ptr += needle._len;
399         }
400 
401         return self;
402     }
403 
404     /*
405      * @dev Returns true if the slice ends with `needle`.
406      * @param self The slice to operate on.
407      * @param needle The slice to search for.
408      * @return True if the slice starts with the provided text, false otherwise.
409      */
410     function endsWith(slice self, slice needle) internal returns (bool) {
411         if (self._len < needle._len) {
412             return false;
413         }
414 
415         var selfptr = self._ptr + self._len - needle._len;
416 
417         if (selfptr == needle._ptr) {
418             return true;
419         }
420 
421         bool equal;
422         assembly {
423             let len := mload(needle)
424             let needleptr := mload(add(needle, 0x20))
425             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
426         }
427 
428         return equal;
429     }
430 
431     /*
432      * @dev If `self` ends with `needle`, `needle` is removed from the
433      *      end of `self`. Otherwise, `self` is unmodified.
434      * @param self The slice to operate on.
435      * @param needle The slice to search for.
436      * @return `self`
437      */
438     function until(slice self, slice needle) internal returns (slice) {
439         if (self._len < needle._len) {
440             return self;
441         }
442 
443         var selfptr = self._ptr + self._len - needle._len;
444         bool equal = true;
445         if (selfptr != needle._ptr) {
446             assembly {
447                 let len := mload(needle)
448                 let needleptr := mload(add(needle, 0x20))
449                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
450             }
451         }
452 
453         if (equal) {
454             self._len -= needle._len;
455         }
456 
457         return self;
458     }
459 
460     // Returns the memory address of the first byte of the first occurrence of
461     // `needle` in `self`, or the first byte after `self` if not found.
462     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
463         uint ptr;
464         uint idx;
465 
466         if (needlelen <= selflen) {
467             if (needlelen <= 32) {
468                 // Optimized assembly for 68 gas per byte on short strings
469                 assembly {
470                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
471                     let needledata := and(mload(needleptr), mask)
472                     let end := add(selfptr, sub(selflen, needlelen))
473                     ptr := selfptr
474                     loop:
475                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
476                     ptr := add(ptr, 1)
477                     jumpi(loop, lt(sub(ptr, 1), end))
478                     ptr := add(selfptr, selflen)
479                     exit:
480                 }
481                 return ptr;
482             } else {
483                 // For long needles, use hashing
484                 bytes32 hash;
485                 assembly { hash := sha3(needleptr, needlelen) }
486                 ptr = selfptr;
487                 for (idx = 0; idx <= selflen - needlelen; idx++) {
488                     bytes32 testHash;
489                     assembly { testHash := sha3(ptr, needlelen) }
490                     if (hash == testHash)
491                         return ptr;
492                     ptr += 1;
493                 }
494             }
495         }
496         return selfptr + selflen;
497     }
498 
499     // Returns the memory address of the first byte after the last occurrence of
500     // `needle` in `self`, or the address of `self` if not found.
501     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
502         uint ptr;
503 
504         if (needlelen <= selflen) {
505             if (needlelen <= 32) {
506                 // Optimized assembly for 69 gas per byte on short strings
507                 assembly {
508                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
509                     let needledata := and(mload(needleptr), mask)
510                     ptr := add(selfptr, sub(selflen, needlelen))
511                     loop:
512                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
513                     ptr := sub(ptr, 1)
514                     jumpi(loop, gt(add(ptr, 1), selfptr))
515                     ptr := selfptr
516                     jump(exit)
517                     ret:
518                     ptr := add(ptr, needlelen)
519                     exit:
520                 }
521                 return ptr;
522             } else {
523                 // For long needles, use hashing
524                 bytes32 hash;
525                 assembly { hash := sha3(needleptr, needlelen) }
526                 ptr = selfptr + (selflen - needlelen);
527                 while (ptr >= selfptr) {
528                     bytes32 testHash;
529                     assembly { testHash := sha3(ptr, needlelen) }
530                     if (hash == testHash)
531                         return ptr + needlelen;
532                     ptr -= 1;
533                 }
534             }
535         }
536         return selfptr;
537     }
538 
539     /*
540      * @dev Modifies `self` to contain everything from the first occurrence of
541      *      `needle` to the end of the slice. `self` is set to the empty slice
542      *      if `needle` is not found.
543      * @param self The slice to search and modify.
544      * @param needle The text to search for.
545      * @return `self`.
546      */
547     function find(slice self, slice needle) internal returns (slice) {
548         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
549         self._len -= ptr - self._ptr;
550         self._ptr = ptr;
551         return self;
552     }
553 
554     /*
555      * @dev Modifies `self` to contain the part of the string from the start of
556      *      `self` to the end of the first occurrence of `needle`. If `needle`
557      *      is not found, `self` is set to the empty slice.
558      * @param self The slice to search and modify.
559      * @param needle The text to search for.
560      * @return `self`.
561      */
562     function rfind(slice self, slice needle) internal returns (slice) {
563         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
564         self._len = ptr - self._ptr;
565         return self;
566     }
567 
568     /*
569      * @dev Splits the slice, setting `self` to everything after the first
570      *      occurrence of `needle`, and `token` to everything before it. If
571      *      `needle` does not occur in `self`, `self` is set to the empty slice,
572      *      and `token` is set to the entirety of `self`.
573      * @param self The slice to split.
574      * @param needle The text to search for in `self`.
575      * @param token An output parameter to which the first token is written.
576      * @return `token`.
577      */
578     function split(slice self, slice needle, slice token) internal returns (slice) {
579         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
580         token._ptr = self._ptr;
581         token._len = ptr - self._ptr;
582         if (ptr == self._ptr + self._len) {
583             // Not found
584             self._len = 0;
585         } else {
586             self._len -= token._len + needle._len;
587             self._ptr = ptr + needle._len;
588         }
589         return token;
590     }
591 
592     /*
593      * @dev Splits the slice, setting `self` to everything after the first
594      *      occurrence of `needle`, and returning everything before it. If
595      *      `needle` does not occur in `self`, `self` is set to the empty slice,
596      *      and the entirety of `self` is returned.
597      * @param self The slice to split.
598      * @param needle The text to search for in `self`.
599      * @return The part of `self` up to the first occurrence of `delim`.
600      */
601     function split(slice self, slice needle) internal returns (slice token) {
602         split(self, needle, token);
603     }
604 
605     /*
606      * @dev Splits the slice, setting `self` to everything before the last
607      *      occurrence of `needle`, and `token` to everything after it. If
608      *      `needle` does not occur in `self`, `self` is set to the empty slice,
609      *      and `token` is set to the entirety of `self`.
610      * @param self The slice to split.
611      * @param needle The text to search for in `self`.
612      * @param token An output parameter to which the first token is written.
613      * @return `token`.
614      */
615     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
616         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
617         token._ptr = ptr;
618         token._len = self._len - (ptr - self._ptr);
619         if (ptr == self._ptr) {
620             // Not found
621             self._len = 0;
622         } else {
623             self._len -= token._len + needle._len;
624         }
625         return token;
626     }
627 
628     /*
629      * @dev Splits the slice, setting `self` to everything before the last
630      *      occurrence of `needle`, and returning everything after it. If
631      *      `needle` does not occur in `self`, `self` is set to the empty slice,
632      *      and the entirety of `self` is returned.
633      * @param self The slice to split.
634      * @param needle The text to search for in `self`.
635      * @return The part of `self` after the last occurrence of `delim`.
636      */
637     function rsplit(slice self, slice needle) internal returns (slice token) {
638         rsplit(self, needle, token);
639     }
640 
641     /*
642      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
643      * @param self The slice to search.
644      * @param needle The text to search for in `self`.
645      * @return The number of occurrences of `needle` found in `self`.
646      */
647     function count(slice self, slice needle) internal returns (uint count) {
648         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
649         while (ptr <= self._ptr + self._len) {
650             count++;
651             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
652         }
653     }
654 
655     /*
656      * @dev Returns True if `self` contains `needle`.
657      * @param self The slice to search.
658      * @param needle The text to search for in `self`.
659      * @return True if `needle` is found in `self`, false otherwise.
660      */
661     function contains(slice self, slice needle) internal returns (bool) {
662         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
663     }
664 
665     /*
666      * @dev Returns a newly allocated string containing the concatenation of
667      *      `self` and `other`.
668      * @param self The first slice to concatenate.
669      * @param other The second slice to concatenate.
670      * @return The concatenation of the two strings.
671      */
672     function concat(slice self, slice other) internal returns (string) {
673         var ret = new string(self._len + other._len);
674         uint retptr;
675         assembly { retptr := add(ret, 32) }
676         memcpy(retptr, self._ptr, self._len);
677         memcpy(retptr + self._len, other._ptr, other._len);
678         return ret;
679     }
680 
681     /*
682      * @dev Joins an array of slices, using `self` as a delimiter, returning a
683      *      newly allocated string.
684      * @param self The delimiter to use.
685      * @param parts A list of slices to join.
686      * @return A newly allocated string containing all the slices in `parts`,
687      *         joined with `self`.
688      */
689     function join(slice self, slice[] parts) internal returns (string) {
690         if (parts.length == 0)
691             return "";
692 
693         uint len = self._len * (parts.length - 1);
694         for(uint i = 0; i < parts.length; i++)
695             len += parts[i]._len;
696 
697         var ret = new string(len);
698         uint retptr;
699         assembly { retptr := add(ret, 32) }
700 
701         for(i = 0; i < parts.length; i++) {
702             memcpy(retptr, parts[i]._ptr, parts[i]._len);
703             retptr += parts[i]._len;
704             if (i < parts.length - 1) {
705                 memcpy(retptr, self._ptr, self._len);
706                 retptr += self._len;
707             }
708         }
709 
710         return ret;
711     }
712 }
713 
714 // File: contracts/FlightDelayAccessControllerInterface.sol
715 
716 /**
717  * FlightDelay with Oraclized Underwriting and Payout
718  *
719  * @description	AccessControllerInterface
720  * @copyright (c) 2017 etherisc GmbH
721  * @author Christoph Mussenbrock
722  */
723 
724 pragma solidity ^0.4.11;
725 
726 
727 contract FlightDelayAccessControllerInterface {
728 
729     function setPermissionById(uint8 _perm, bytes32 _id) public;
730 
731     function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public;
732 
733     function setPermissionByAddress(uint8 _perm, address _addr) public;
734 
735     function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public;
736 
737     function checkPermission(uint8 _perm, address _addr) public returns (bool _success);
738 }
739 
740 // File: contracts/FlightDelayConstants.sol
741 
742 /**
743  * FlightDelay with Oraclized Underwriting and Payout
744  *
745  * @description	Events and Constants
746  * @copyright (c) 2017 etherisc GmbH
747  * @author Christoph Mussenbrock
748  */
749 
750 pragma solidity ^0.4.11;
751 
752 
753 contract FlightDelayConstants {
754 
755     /*
756     * General events
757     */
758 
759 // --> test-mode
760 //        event LogUint(string _message, uint _uint);
761 //        event LogUintEth(string _message, uint ethUint);
762 //        event LogUintTime(string _message, uint timeUint);
763 //        event LogInt(string _message, int _int);
764 //        event LogAddress(string _message, address _address);
765 //        event LogBytes32(string _message, bytes32 hexBytes32);
766 //        event LogBytes(string _message, bytes hexBytes);
767 //        event LogBytes32Str(string _message, bytes32 strBytes32);
768 //        event LogString(string _message, string _string);
769 //        event LogBool(string _message, bool _bool);
770 //        event Log(address);
771 // <-- test-mode
772 
773     event LogPolicyApplied(
774         uint _policyId,
775         address _customer,
776         bytes32 strCarrierFlightNumber,
777         uint ethPremium
778     );
779     event LogPolicyAccepted(
780         uint _policyId,
781         uint _statistics0,
782         uint _statistics1,
783         uint _statistics2,
784         uint _statistics3,
785         uint _statistics4,
786         uint _statistics5
787     );
788     event LogPolicyPaidOut(
789         uint _policyId,
790         uint ethAmount
791     );
792     event LogPolicyExpired(
793         uint _policyId
794     );
795     event LogPolicyDeclined(
796         uint _policyId,
797         bytes32 strReason
798     );
799     event LogPolicyManualPayout(
800         uint _policyId,
801         bytes32 strReason
802     );
803     event LogSendFunds(
804         address _recipient,
805         uint8 _from,
806         uint ethAmount
807     );
808     event LogReceiveFunds(
809         address _sender,
810         uint8 _to,
811         uint ethAmount
812     );
813     event LogSendFail(
814         uint _policyId,
815         bytes32 strReason
816     );
817     event LogOraclizeCall(
818         uint _policyId,
819         bytes32 hexQueryId,
820         string _oraclizeUrl,
821         uint256 _oraclizeTime
822     );
823     event LogOraclizeCallback(
824         uint _policyId,
825         bytes32 hexQueryId,
826         string _result,
827         bytes hexProof
828     );
829     event LogSetState(
830         uint _policyId,
831         uint8 _policyState,
832         uint _stateTime,
833         bytes32 _stateMessage
834     );
835     event LogExternal(
836         uint256 _policyId,
837         address _address,
838         bytes32 _externalId
839     );
840 
841     /*
842     * General constants
843     */
844 
845     // minimum observations for valid prediction
846     uint constant MIN_OBSERVATIONS = 10;
847     // minimum premium to cover costs
848     uint constant MIN_PREMIUM = 50 finney;
849     // maximum premium
850     uint constant MAX_PREMIUM = 1 ether;
851     // maximum payout
852     uint constant MAX_PAYOUT = 1100 finney;
853 
854     uint constant MIN_PREMIUM_EUR = 1500 wei;
855     uint constant MAX_PREMIUM_EUR = 29000 wei;
856     uint constant MAX_PAYOUT_EUR = 30000 wei;
857 
858     uint constant MIN_PREMIUM_USD = 1700 wei;
859     uint constant MAX_PREMIUM_USD = 34000 wei;
860     uint constant MAX_PAYOUT_USD = 35000 wei;
861 
862     uint constant MIN_PREMIUM_GBP = 1300 wei;
863     uint constant MAX_PREMIUM_GBP = 25000 wei;
864     uint constant MAX_PAYOUT_GBP = 270 wei;
865 
866     // maximum cumulated weighted premium per risk
867     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
868     // 1 percent for DAO, 1 percent for maintainer
869     uint8 constant REWARD_PERCENT = 2;
870     // reserve for tail risks
871     uint8 constant RESERVE_PERCENT = 1;
872     // the weight pattern; in future versions this may become part of the policy struct.
873     // currently can't be constant because of compiler restrictions
874     // WEIGHT_PATTERN[0] is not used, just to be consistent
875     uint8[6] WEIGHT_PATTERN = [
876         0,
877         10,
878         20,
879         30,
880         50,
881         50
882     ];
883 
884 // --> prod-mode
885     // DEFINITIONS FOR ROPSTEN AND MAINNET
886     // minimum time before departure for applying
887     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
888     // check for delay after .. minutes after scheduled arrival
889     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
890 // <-- prod-mode
891 
892 // --> test-mode
893 //        // DEFINITIONS FOR LOCAL TESTNET
894 //        // minimum time before departure for applying
895 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
896 //        // check for delay after .. minutes after scheduled arrival
897 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
898 // <-- test-mode
899 
900     // maximum duration of flight
901     uint constant MAX_FLIGHT_DURATION = 2 days;
902     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
903     uint constant CONTRACT_DEAD_LINE = 1922396399;
904 
905     // gas Constants for oraclize
906     uint constant ORACLIZE_GAS = 700000;
907     uint constant ORACLIZE_GASPRICE = 4000000000;
908 
909 
910     /*
911     * URLs and query strings for oraclize
912     */
913 
914 // --> prod-mode
915     // DEFINITIONS FOR ROPSTEN AND MAINNET
916     string constant ORACLIZE_RATINGS_BASE_URL =
917         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
918         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
919     string constant ORACLIZE_RATINGS_QUERY =
920         "?${[decrypt] BAr6Z9QolM2PQimF/pNC6zXldOvZ2qquOSKm/qJkJWnSGgAeRw21wBGnBbXiamr/ISC5SlcJB6wEPKthdc6F+IpqM/iXavKsalRUrGNuBsGfaMXr8fRQw6gLzqk0ecOFNeCa48/yqBvC/kas+jTKHiYxA3wTJrVZCq76Y03lZI2xxLaoniRk}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
921     string constant ORACLIZE_STATUS_BASE_URL =
922         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
923         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
924     string constant ORACLIZE_STATUS_QUERY =
925         // pattern:
926         "?${[decrypt] BJxpwRaHujYTT98qI5slQJplj/VbfV7vYkMOp/Mr5D/5+gkgJQKZb0gVSCa6aKx2Wogo/cG7yaWINR6vnuYzccQE5yVJSr7RQilRawxnAtZXt6JB70YpX4xlfvpipit4R+OmQTurJGGwb8Pgnr4LvotydCjup6wv2Bk/z3UdGA7Sl+FU5a+0}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
927 // <-- prod-mode
928 
929 // --> test-mode
930 //        // DEFINITIONS FOR LOCAL TESTNET
931 //        string constant ORACLIZE_RATINGS_BASE_URL =
932 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
933 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
934 //        string constant ORACLIZE_RATINGS_QUERY =
935 //            // for testrpc:
936 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
937 //        string constant ORACLIZE_STATUS_BASE_URL =
938 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
939 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
940 //        string constant ORACLIZE_STATUS_QUERY =
941 //            // for testrpc:
942 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
943 // <-- test-mode
944 }
945 
946 // File: contracts/FlightDelayControllerInterface.sol
947 
948 /**
949  * FlightDelay with Oraclized Underwriting and Payout
950  *
951  * @description Contract interface
952  * @copyright (c) 2017 etherisc GmbH
953  * @author Christoph Mussenbrock, Stephan Karpischek
954  */
955 
956 pragma solidity ^0.4.11;
957 
958 
959 contract FlightDelayControllerInterface {
960 
961     function isOwner(address _addr) public returns (bool _isOwner);
962 
963     function selfRegister(bytes32 _id) public returns (bool result);
964 
965     function getContract(bytes32 _id) public returns (address _addr);
966 }
967 
968 // File: contracts/FlightDelayDatabaseModel.sol
969 
970 /**
971  * FlightDelay with Oraclized Underwriting and Payout
972  *
973  * @description Database model
974  * @copyright (c) 2017 etherisc GmbH
975  * @author Christoph Mussenbrock, Stephan Karpischek
976  */
977 
978 pragma solidity ^0.4.11;
979 
980 
981 contract FlightDelayDatabaseModel {
982 
983     // Ledger accounts.
984     enum Acc {
985         Premium,      // 0
986         RiskFund,     // 1
987         Payout,       // 2
988         Balance,      // 3
989         Reward,       // 4
990         OraclizeCosts // 5
991     }
992 
993     // policy Status Codes and meaning:
994     //
995     // 00 = Applied:	  the customer has payed a premium, but the oracle has
996     //					        not yet checked and confirmed.
997     //					        The customer can still revoke the policy.
998     // 01 = Accepted:	  the oracle has checked and confirmed.
999     //					        The customer can still revoke the policy.
1000     // 02 = Revoked:	  The customer has revoked the policy.
1001     //					        The premium minus cancellation fee is payed back to the
1002     //					        customer by the oracle.
1003     // 03 = PaidOut:	  The flight has ended with delay.
1004     //					        The oracle has checked and payed out.
1005     // 04 = Expired:	  The flight has endet with <15min. delay.
1006     //					        No payout.
1007     // 05 = Declined:	  The application was invalid.
1008     //					        The premium minus cancellation fee is payed back to the
1009     //					        customer by the oracle.
1010     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
1011     //					        for unknown reasons.
1012     //					        The funds remain in the contracts RiskFund.
1013 
1014 
1015     //                   00       01        02       03        04      05           06
1016     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
1017 
1018     // oraclize callback types:
1019     enum oraclizeState { ForUnderwriting, ForPayout }
1020 
1021     //               00   01   02   03
1022     enum Currency { ETH, EUR, USD, GBP }
1023 
1024     // the policy structure: this structure keeps track of the individual parameters of a policy.
1025     // typically customer address, premium and some status information.
1026     struct Policy {
1027         // 0 - the customer
1028         address customer;
1029 
1030         // 1 - premium
1031         uint premium;
1032         // risk specific parameters:
1033         // 2 - pointer to the risk in the risks mapping
1034         bytes32 riskId;
1035         // custom payout pattern
1036         // in future versions, customer will be able to tamper with this array.
1037         // to keep things simple, we have decided to hard-code the array for all policies.
1038         // uint8[5] pattern;
1039         // 3 - probability weight. this is the central parameter
1040         uint weight;
1041         // 4 - calculated Payout
1042         uint calculatedPayout;
1043         // 5 - actual Payout
1044         uint actualPayout;
1045 
1046         // status fields:
1047         // 6 - the state of the policy
1048         policyState state;
1049         // 7 - time of last state change
1050         uint stateTime;
1051         // 8 - state change message/reason
1052         bytes32 stateMessage;
1053         // 9 - TLSNotary Proof
1054         bytes proof;
1055         // 10 - Currency
1056         Currency currency;
1057         // 10 - External customer id
1058         bytes32 customerExternalId;
1059     }
1060 
1061     // the risk structure; this structure keeps track of the risk-
1062     // specific parameters.
1063     // several policies can share the same risk structure (typically
1064     // some people flying with the same plane)
1065     struct Risk {
1066         // 0 - Airline Code + FlightNumber
1067         bytes32 carrierFlightNumber;
1068         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
1069         bytes32 departureYearMonthDay;
1070         // 2 - the inital arrival time
1071         uint arrivalTime;
1072         // 3 - the final delay in minutes
1073         uint delayInMinutes;
1074         // 4 - the determined delay category (0-5)
1075         uint8 delay;
1076         // 5 - we limit the cumulated weighted premium to avoid cluster risks
1077         uint cumulatedWeightedPremium;
1078         // 6 - max cumulated Payout for this risk
1079         uint premiumMultiplier;
1080     }
1081 
1082     // the oraclize callback structure: we use several oraclize calls.
1083     // all oraclize calls will result in a common callback to __callback(...).
1084     // to keep track of the different querys we have to introduce this struct.
1085     struct OraclizeCallback {
1086         // for which policy have we called?
1087         uint policyId;
1088         // for which purpose did we call? {ForUnderwrite | ForPayout}
1089         oraclizeState oState;
1090         // time
1091         uint oraclizeTime;
1092     }
1093 
1094     struct Customer {
1095         bytes32 customerExternalId;
1096         bool identityConfirmed;
1097     }
1098 }
1099 
1100 // File: contracts/FlightDelayControlledContract.sol
1101 
1102 /**
1103  * FlightDelay with Oraclized Underwriting and Payout
1104  *
1105  * @description Controlled contract Interface
1106  * @copyright (c) 2017 etherisc GmbH
1107  * @author Christoph Mussenbrock
1108  */
1109 
1110 pragma solidity ^0.4.11;
1111 
1112 
1113 
1114 
1115 
1116 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
1117 
1118     address public controller;
1119     FlightDelayControllerInterface FD_CI;
1120 
1121     modifier onlyController() {
1122         require(msg.sender == controller);
1123         _;
1124     }
1125 
1126     function setController(address _controller) internal returns (bool _result) {
1127         controller = _controller;
1128         FD_CI = FlightDelayControllerInterface(_controller);
1129         _result = true;
1130     }
1131 
1132     function destruct() public onlyController {
1133         selfdestruct(controller);
1134     }
1135 
1136     function setContracts() public onlyController {}
1137 
1138     function getContract(bytes32 _id) internal returns (address _addr) {
1139         _addr = FD_CI.getContract(_id);
1140     }
1141 }
1142 
1143 // File: contracts/FlightDelayDatabaseInterface.sol
1144 
1145 /**
1146  * FlightDelay with Oraclized Underwriting and Payout
1147  *
1148  * @description Database contract interface
1149  * @copyright (c) 2017 etherisc GmbH
1150  * @author Christoph Mussenbrock, Stephan Karpischek
1151  */
1152 
1153 pragma solidity ^0.4.11;
1154 
1155 
1156 
1157 
1158 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
1159 
1160     uint public MIN_DEPARTURE_LIM;
1161 
1162     uint public MAX_DEPARTURE_LIM;
1163 
1164     bytes32[] public validOrigins;
1165 
1166     bytes32[] public validDestinations;
1167 
1168     function countOrigins() public constant returns (uint256 _length);
1169 
1170     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);
1171 
1172     function countDestinations() public constant returns (uint256 _length);
1173 
1174     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);
1175 
1176     function setAccessControl(address _contract, address _caller, uint8 _perm) public;
1177 
1178     function setAccessControl(
1179         address _contract,
1180         address _caller,
1181         uint8 _perm,
1182         bool _access
1183     ) public;
1184 
1185     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;
1186 
1187     function setLedger(uint8 _index, int _value) public;
1188 
1189     function getLedger(uint8 _index) public returns (int _value) ;
1190 
1191     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;
1192 
1193     function getPolicyData(uint _policyId) public returns (address _customer, uint _premium, uint _weight) ;
1194 
1195     function getPolicyState(uint _policyId) public returns (policyState _state) ;
1196 
1197     function getRiskId(uint _policyId) public returns (bytes32 _riskId);
1198 
1199     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;
1200 
1201     function setState(
1202         uint _policyId,
1203         policyState _state,
1204         uint _stateTime,
1205         bytes32 _stateMessage
1206     ) public;
1207 
1208     function setWeight(uint _policyId, uint _weight, bytes _proof) public;
1209 
1210     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;
1211 
1212     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;
1213 
1214     function getRiskParameters(bytes32 _riskId)
1215         public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;
1216 
1217     function getPremiumFactors(bytes32 _riskId)
1218         public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
1219 
1220     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
1221         public returns (bytes32 _riskId);
1222 
1223     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;
1224 
1225     function getOraclizeCallback(bytes32 _queryId)
1226         public returns (uint _policyId, uint _oraclizeTime) ;
1227 
1228     function getOraclizePolicyId(bytes32 _queryId)
1229         public returns (uint _policyId) ;
1230 
1231     function createOraclizeCallback(
1232         bytes32 _queryId,
1233         uint _policyId,
1234         oraclizeState _oraclizeState,
1235         uint _oraclizeTime
1236     ) public;
1237 
1238     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
1239         public returns (bool _result) ;
1240 }
1241 
1242 // File: contracts/FlightDelayLedgerInterface.sol
1243 
1244 /**
1245  * FlightDelay with Oraclized Underwriting and Payout
1246  *
1247  * @description	Ledger contract interface
1248  * @copyright (c) 2017 etherisc GmbH
1249  * @author Christoph Mussenbrock, Stephan Karpischek
1250  */
1251 
1252 pragma solidity ^0.4.11;
1253 
1254 
1255 
1256 
1257 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
1258 
1259     function receiveFunds(Acc _to) public payable;
1260 
1261     function sendFunds(address _recipient, Acc _from, uint _amount) public returns (bool _success);
1262 
1263     function bookkeeping(Acc _from, Acc _to, uint amount) public;
1264 }
1265 
1266 // File: vendors/usingOraclize.sol
1267 
1268 // <ORACLIZE_API>
1269 /*
1270 Copyright (c) 2015-2016 Oraclize SRL
1271 Copyright (c) 2016 Oraclize LTD
1272 
1273 
1274 
1275 Permission is hereby granted, free of charge, to any person obtaining a copy
1276 of this software and associated documentation files (the "Software"), to deal
1277 in the Software without restriction, including without limitation the rights
1278 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1279 copies of the Software, and to permit persons to whom the Software is
1280 furnished to do so, subject to the following conditions:
1281 
1282 
1283 
1284 The above copyright notice and this permission notice shall be included in
1285 all copies or substantial portions of the Software.
1286 
1287 
1288 
1289 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1290 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1291 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1292 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1293 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1294 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1295 THE SOFTWARE.
1296 */
1297 
1298 
1299 
1300 contract OraclizeI {
1301     address public cbAddress;
1302     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
1303     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
1304     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
1305     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
1306     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
1307     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
1308     function getPrice(string _datasource) returns (uint _dsprice);
1309     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
1310     function useCoupon(string _coupon);
1311     function setProofType(byte _proofType);
1312     function setConfig(bytes32 _config);
1313     function setCustomGasPrice(uint _gasPrice);
1314     function randomDS_getSessionPubKeyHash() returns(bytes32);
1315 }
1316 contract OraclizeAddrResolverI {
1317     function getAddress() returns (address _addr);
1318 }
1319 contract usingOraclize {
1320     uint constant day = 60*60*24;
1321     uint constant week = 60*60*24*7;
1322     uint constant month = 60*60*24*30;
1323     byte constant proofType_NONE = 0x00;
1324     byte constant proofType_TLSNotary = 0x10;
1325     byte constant proofType_Android = 0x20;
1326     byte constant proofType_Ledger = 0x30;
1327     byte constant proofType_Native = 0xF0;
1328     byte constant proofStorage_IPFS = 0x01;
1329     uint8 constant networkID_auto = 0;
1330     uint8 constant networkID_mainnet = 1;
1331     uint8 constant networkID_testnet = 2;
1332     uint8 constant networkID_morden = 2;
1333     uint8 constant networkID_consensys = 161;
1334 
1335     OraclizeAddrResolverI OAR;
1336 
1337     OraclizeI oraclize;
1338     modifier oraclizeAPI {
1339         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
1340         oraclize = OraclizeI(OAR.getAddress());
1341         _;
1342     }
1343     modifier coupon(string code){
1344         oraclize = OraclizeI(OAR.getAddress());
1345         oraclize.useCoupon(code);
1346         _;
1347     }
1348 
1349     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1350         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1351             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1352             oraclize_setNetworkName("eth_mainnet");
1353             return true;
1354         }
1355         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1356             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1357             oraclize_setNetworkName("eth_ropsten3");
1358             return true;
1359         }
1360         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1361             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1362             oraclize_setNetworkName("eth_kovan");
1363             return true;
1364         }
1365         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1366             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1367             oraclize_setNetworkName("eth_rinkeby");
1368             return true;
1369         }
1370         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1371             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1372             return true;
1373         }
1374         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1375             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1376             return true;
1377         }
1378         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1379             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1380             return true;
1381         }
1382         return false;
1383     }
1384 
1385     function __callback(bytes32 myid, string result) {
1386         __callback(myid, result, new bytes(0));
1387     }
1388     function __callback(bytes32 myid, string result, bytes proof) {
1389     }
1390 
1391     function oraclize_useCoupon(string code) oraclizeAPI internal {
1392         oraclize.useCoupon(code);
1393     }
1394 
1395     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1396         return oraclize.getPrice(datasource);
1397     }
1398 
1399     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1400         return oraclize.getPrice(datasource, gaslimit);
1401     }
1402 
1403     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1404         uint price = oraclize.getPrice(datasource);
1405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1406         return oraclize.query.value(price)(0, datasource, arg);
1407     }
1408     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1409         uint price = oraclize.getPrice(datasource);
1410         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1411         return oraclize.query.value(price)(timestamp, datasource, arg);
1412     }
1413     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1414         uint price = oraclize.getPrice(datasource, gaslimit);
1415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1416         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1417     }
1418     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1419         uint price = oraclize.getPrice(datasource, gaslimit);
1420         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1421         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1422     }
1423     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1424         uint price = oraclize.getPrice(datasource);
1425         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1426         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1427     }
1428     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1429         uint price = oraclize.getPrice(datasource);
1430         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1431         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1432     }
1433     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1434         uint price = oraclize.getPrice(datasource, gaslimit);
1435         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1436         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1437     }
1438     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1439         uint price = oraclize.getPrice(datasource, gaslimit);
1440         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1441         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1442     }
1443     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1444         uint price = oraclize.getPrice(datasource);
1445         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1446         bytes memory args = stra2cbor(argN);
1447         return oraclize.queryN.value(price)(0, datasource, args);
1448     }
1449     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1450         uint price = oraclize.getPrice(datasource);
1451         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1452         bytes memory args = stra2cbor(argN);
1453         return oraclize.queryN.value(price)(timestamp, datasource, args);
1454     }
1455     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1456         uint price = oraclize.getPrice(datasource, gaslimit);
1457         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1458         bytes memory args = stra2cbor(argN);
1459         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1460     }
1461     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1462         uint price = oraclize.getPrice(datasource, gaslimit);
1463         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1464         bytes memory args = stra2cbor(argN);
1465         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1466     }
1467     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1468         string[] memory dynargs = new string[](1);
1469         dynargs[0] = args[0];
1470         return oraclize_query(datasource, dynargs);
1471     }
1472     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1473         string[] memory dynargs = new string[](1);
1474         dynargs[0] = args[0];
1475         return oraclize_query(timestamp, datasource, dynargs);
1476     }
1477     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1478         string[] memory dynargs = new string[](1);
1479         dynargs[0] = args[0];
1480         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1481     }
1482     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1483         string[] memory dynargs = new string[](1);
1484         dynargs[0] = args[0];
1485         return oraclize_query(datasource, dynargs, gaslimit);
1486     }
1487 
1488     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1489         string[] memory dynargs = new string[](2);
1490         dynargs[0] = args[0];
1491         dynargs[1] = args[1];
1492         return oraclize_query(datasource, dynargs);
1493     }
1494     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1495         string[] memory dynargs = new string[](2);
1496         dynargs[0] = args[0];
1497         dynargs[1] = args[1];
1498         return oraclize_query(timestamp, datasource, dynargs);
1499     }
1500     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1501         string[] memory dynargs = new string[](2);
1502         dynargs[0] = args[0];
1503         dynargs[1] = args[1];
1504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1505     }
1506     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1507         string[] memory dynargs = new string[](2);
1508         dynargs[0] = args[0];
1509         dynargs[1] = args[1];
1510         return oraclize_query(datasource, dynargs, gaslimit);
1511     }
1512     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1513         string[] memory dynargs = new string[](3);
1514         dynargs[0] = args[0];
1515         dynargs[1] = args[1];
1516         dynargs[2] = args[2];
1517         return oraclize_query(datasource, dynargs);
1518     }
1519     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1520         string[] memory dynargs = new string[](3);
1521         dynargs[0] = args[0];
1522         dynargs[1] = args[1];
1523         dynargs[2] = args[2];
1524         return oraclize_query(timestamp, datasource, dynargs);
1525     }
1526     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1527         string[] memory dynargs = new string[](3);
1528         dynargs[0] = args[0];
1529         dynargs[1] = args[1];
1530         dynargs[2] = args[2];
1531         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1532     }
1533     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1534         string[] memory dynargs = new string[](3);
1535         dynargs[0] = args[0];
1536         dynargs[1] = args[1];
1537         dynargs[2] = args[2];
1538         return oraclize_query(datasource, dynargs, gaslimit);
1539     }
1540 
1541     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1542         string[] memory dynargs = new string[](4);
1543         dynargs[0] = args[0];
1544         dynargs[1] = args[1];
1545         dynargs[2] = args[2];
1546         dynargs[3] = args[3];
1547         return oraclize_query(datasource, dynargs);
1548     }
1549     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1550         string[] memory dynargs = new string[](4);
1551         dynargs[0] = args[0];
1552         dynargs[1] = args[1];
1553         dynargs[2] = args[2];
1554         dynargs[3] = args[3];
1555         return oraclize_query(timestamp, datasource, dynargs);
1556     }
1557     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1558         string[] memory dynargs = new string[](4);
1559         dynargs[0] = args[0];
1560         dynargs[1] = args[1];
1561         dynargs[2] = args[2];
1562         dynargs[3] = args[3];
1563         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1564     }
1565     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1566         string[] memory dynargs = new string[](4);
1567         dynargs[0] = args[0];
1568         dynargs[1] = args[1];
1569         dynargs[2] = args[2];
1570         dynargs[3] = args[3];
1571         return oraclize_query(datasource, dynargs, gaslimit);
1572     }
1573     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1574         string[] memory dynargs = new string[](5);
1575         dynargs[0] = args[0];
1576         dynargs[1] = args[1];
1577         dynargs[2] = args[2];
1578         dynargs[3] = args[3];
1579         dynargs[4] = args[4];
1580         return oraclize_query(datasource, dynargs);
1581     }
1582     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1583         string[] memory dynargs = new string[](5);
1584         dynargs[0] = args[0];
1585         dynargs[1] = args[1];
1586         dynargs[2] = args[2];
1587         dynargs[3] = args[3];
1588         dynargs[4] = args[4];
1589         return oraclize_query(timestamp, datasource, dynargs);
1590     }
1591     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1592         string[] memory dynargs = new string[](5);
1593         dynargs[0] = args[0];
1594         dynargs[1] = args[1];
1595         dynargs[2] = args[2];
1596         dynargs[3] = args[3];
1597         dynargs[4] = args[4];
1598         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1599     }
1600     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1601         string[] memory dynargs = new string[](5);
1602         dynargs[0] = args[0];
1603         dynargs[1] = args[1];
1604         dynargs[2] = args[2];
1605         dynargs[3] = args[3];
1606         dynargs[4] = args[4];
1607         return oraclize_query(datasource, dynargs, gaslimit);
1608     }
1609     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1610         uint price = oraclize.getPrice(datasource);
1611         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1612         bytes memory args = ba2cbor(argN);
1613         return oraclize.queryN.value(price)(0, datasource, args);
1614     }
1615     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1616         uint price = oraclize.getPrice(datasource);
1617         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1618         bytes memory args = ba2cbor(argN);
1619         return oraclize.queryN.value(price)(timestamp, datasource, args);
1620     }
1621     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1622         uint price = oraclize.getPrice(datasource, gaslimit);
1623         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1624         bytes memory args = ba2cbor(argN);
1625         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1626     }
1627     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1628         uint price = oraclize.getPrice(datasource, gaslimit);
1629         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1630         bytes memory args = ba2cbor(argN);
1631         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1632     }
1633     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1634         bytes[] memory dynargs = new bytes[](1);
1635         dynargs[0] = args[0];
1636         return oraclize_query(datasource, dynargs);
1637     }
1638     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1639         bytes[] memory dynargs = new bytes[](1);
1640         dynargs[0] = args[0];
1641         return oraclize_query(timestamp, datasource, dynargs);
1642     }
1643     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1644         bytes[] memory dynargs = new bytes[](1);
1645         dynargs[0] = args[0];
1646         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1647     }
1648     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1649         bytes[] memory dynargs = new bytes[](1);
1650         dynargs[0] = args[0];
1651         return oraclize_query(datasource, dynargs, gaslimit);
1652     }
1653 
1654     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1655         bytes[] memory dynargs = new bytes[](2);
1656         dynargs[0] = args[0];
1657         dynargs[1] = args[1];
1658         return oraclize_query(datasource, dynargs);
1659     }
1660     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1661         bytes[] memory dynargs = new bytes[](2);
1662         dynargs[0] = args[0];
1663         dynargs[1] = args[1];
1664         return oraclize_query(timestamp, datasource, dynargs);
1665     }
1666     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1667         bytes[] memory dynargs = new bytes[](2);
1668         dynargs[0] = args[0];
1669         dynargs[1] = args[1];
1670         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1671     }
1672     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1673         bytes[] memory dynargs = new bytes[](2);
1674         dynargs[0] = args[0];
1675         dynargs[1] = args[1];
1676         return oraclize_query(datasource, dynargs, gaslimit);
1677     }
1678     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1679         bytes[] memory dynargs = new bytes[](3);
1680         dynargs[0] = args[0];
1681         dynargs[1] = args[1];
1682         dynargs[2] = args[2];
1683         return oraclize_query(datasource, dynargs);
1684     }
1685     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1686         bytes[] memory dynargs = new bytes[](3);
1687         dynargs[0] = args[0];
1688         dynargs[1] = args[1];
1689         dynargs[2] = args[2];
1690         return oraclize_query(timestamp, datasource, dynargs);
1691     }
1692     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1693         bytes[] memory dynargs = new bytes[](3);
1694         dynargs[0] = args[0];
1695         dynargs[1] = args[1];
1696         dynargs[2] = args[2];
1697         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1698     }
1699     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1700         bytes[] memory dynargs = new bytes[](3);
1701         dynargs[0] = args[0];
1702         dynargs[1] = args[1];
1703         dynargs[2] = args[2];
1704         return oraclize_query(datasource, dynargs, gaslimit);
1705     }
1706 
1707     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1708         bytes[] memory dynargs = new bytes[](4);
1709         dynargs[0] = args[0];
1710         dynargs[1] = args[1];
1711         dynargs[2] = args[2];
1712         dynargs[3] = args[3];
1713         return oraclize_query(datasource, dynargs);
1714     }
1715     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1716         bytes[] memory dynargs = new bytes[](4);
1717         dynargs[0] = args[0];
1718         dynargs[1] = args[1];
1719         dynargs[2] = args[2];
1720         dynargs[3] = args[3];
1721         return oraclize_query(timestamp, datasource, dynargs);
1722     }
1723     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1724         bytes[] memory dynargs = new bytes[](4);
1725         dynargs[0] = args[0];
1726         dynargs[1] = args[1];
1727         dynargs[2] = args[2];
1728         dynargs[3] = args[3];
1729         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1730     }
1731     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1732         bytes[] memory dynargs = new bytes[](4);
1733         dynargs[0] = args[0];
1734         dynargs[1] = args[1];
1735         dynargs[2] = args[2];
1736         dynargs[3] = args[3];
1737         return oraclize_query(datasource, dynargs, gaslimit);
1738     }
1739     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1740         bytes[] memory dynargs = new bytes[](5);
1741         dynargs[0] = args[0];
1742         dynargs[1] = args[1];
1743         dynargs[2] = args[2];
1744         dynargs[3] = args[3];
1745         dynargs[4] = args[4];
1746         return oraclize_query(datasource, dynargs);
1747     }
1748     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1749         bytes[] memory dynargs = new bytes[](5);
1750         dynargs[0] = args[0];
1751         dynargs[1] = args[1];
1752         dynargs[2] = args[2];
1753         dynargs[3] = args[3];
1754         dynargs[4] = args[4];
1755         return oraclize_query(timestamp, datasource, dynargs);
1756     }
1757     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1758         bytes[] memory dynargs = new bytes[](5);
1759         dynargs[0] = args[0];
1760         dynargs[1] = args[1];
1761         dynargs[2] = args[2];
1762         dynargs[3] = args[3];
1763         dynargs[4] = args[4];
1764         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1765     }
1766     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1767         bytes[] memory dynargs = new bytes[](5);
1768         dynargs[0] = args[0];
1769         dynargs[1] = args[1];
1770         dynargs[2] = args[2];
1771         dynargs[3] = args[3];
1772         dynargs[4] = args[4];
1773         return oraclize_query(datasource, dynargs, gaslimit);
1774     }
1775 
1776     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1777         return oraclize.cbAddress();
1778     }
1779     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1780         return oraclize.setProofType(proofP);
1781     }
1782     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1783         return oraclize.setCustomGasPrice(gasPrice);
1784     }
1785     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1786         return oraclize.setConfig(config);
1787     }
1788 
1789     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1790         return oraclize.randomDS_getSessionPubKeyHash();
1791     }
1792 
1793     function getCodeSize(address _addr) constant internal returns(uint _size) {
1794         assembly {
1795             _size := extcodesize(_addr)
1796         }
1797     }
1798 
1799     function parseAddr(string _a) internal returns (address){
1800         bytes memory tmp = bytes(_a);
1801         uint160 iaddr = 0;
1802         uint160 b1;
1803         uint160 b2;
1804         for (uint i=2; i<2+2*20; i+=2){
1805             iaddr *= 256;
1806             b1 = uint160(tmp[i]);
1807             b2 = uint160(tmp[i+1]);
1808             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1809             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1810             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1811             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1812             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1813             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1814             iaddr += (b1*16+b2);
1815         }
1816         return address(iaddr);
1817     }
1818 
1819     function strCompare(string _a, string _b) internal returns (int) {
1820         bytes memory a = bytes(_a);
1821         bytes memory b = bytes(_b);
1822         uint minLength = a.length;
1823         if (b.length < minLength) minLength = b.length;
1824         for (uint i = 0; i < minLength; i ++)
1825             if (a[i] < b[i])
1826                 return -1;
1827             else if (a[i] > b[i])
1828                 return 1;
1829         if (a.length < b.length)
1830             return -1;
1831         else if (a.length > b.length)
1832             return 1;
1833         else
1834             return 0;
1835     }
1836 
1837     function indexOf(string _haystack, string _needle) internal returns (int) {
1838         bytes memory h = bytes(_haystack);
1839         bytes memory n = bytes(_needle);
1840         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1841             return -1;
1842         else if(h.length > (2**128 -1))
1843             return -1;
1844         else
1845         {
1846             uint subindex = 0;
1847             for (uint i = 0; i < h.length; i ++)
1848             {
1849                 if (h[i] == n[0])
1850                 {
1851                     subindex = 1;
1852                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1853                     {
1854                         subindex++;
1855                     }
1856                     if(subindex == n.length)
1857                         return int(i);
1858                 }
1859             }
1860             return -1;
1861         }
1862     }
1863 
1864     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1865         bytes memory _ba = bytes(_a);
1866         bytes memory _bb = bytes(_b);
1867         bytes memory _bc = bytes(_c);
1868         bytes memory _bd = bytes(_d);
1869         bytes memory _be = bytes(_e);
1870         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1871         bytes memory babcde = bytes(abcde);
1872         uint k = 0;
1873         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1874         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1875         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1876         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1877         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1878         return string(babcde);
1879     }
1880 
1881     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1882         return strConcat(_a, _b, _c, _d, "");
1883     }
1884 
1885     function strConcat(string _a, string _b, string _c) internal returns (string) {
1886         return strConcat(_a, _b, _c, "", "");
1887     }
1888 
1889     function strConcat(string _a, string _b) internal returns (string) {
1890         return strConcat(_a, _b, "", "", "");
1891     }
1892 
1893     // parseInt
1894     function parseInt(string _a) internal returns (uint) {
1895         return parseInt(_a, 0);
1896     }
1897 
1898     // parseInt(parseFloat*10^_b)
1899     function parseInt(string _a, uint _b) internal returns (uint) {
1900         bytes memory bresult = bytes(_a);
1901         uint mint = 0;
1902         bool decimals = false;
1903         for (uint i=0; i<bresult.length; i++){
1904             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1905                 if (decimals){
1906                    if (_b == 0) break;
1907                     else _b--;
1908                 }
1909                 mint *= 10;
1910                 mint += uint(bresult[i]) - 48;
1911             } else if (bresult[i] == 46) decimals = true;
1912         }
1913         if (_b > 0) mint *= 10**_b;
1914         return mint;
1915     }
1916 
1917     function uint2str(uint i) internal returns (string){
1918         if (i == 0) return "0";
1919         uint j = i;
1920         uint len;
1921         while (j != 0){
1922             len++;
1923             j /= 10;
1924         }
1925         bytes memory bstr = new bytes(len);
1926         uint k = len - 1;
1927         while (i != 0){
1928             bstr[k--] = byte(48 + i % 10);
1929             i /= 10;
1930         }
1931         return string(bstr);
1932     }
1933 
1934     function stra2cbor(string[] arr) internal returns (bytes) {
1935             uint arrlen = arr.length;
1936 
1937             // get correct cbor output length
1938             uint outputlen = 0;
1939             bytes[] memory elemArray = new bytes[](arrlen);
1940             for (uint i = 0; i < arrlen; i++) {
1941                 elemArray[i] = (bytes(arr[i]));
1942                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1943             }
1944             uint ctr = 0;
1945             uint cborlen = arrlen + 0x80;
1946             outputlen += byte(cborlen).length;
1947             bytes memory res = new bytes(outputlen);
1948 
1949             while (byte(cborlen).length > ctr) {
1950                 res[ctr] = byte(cborlen)[ctr];
1951                 ctr++;
1952             }
1953             for (i = 0; i < arrlen; i++) {
1954                 res[ctr] = 0x5F;
1955                 ctr++;
1956                 for (uint x = 0; x < elemArray[i].length; x++) {
1957                     // if there's a bug with larger strings, this may be the culprit
1958                     if (x % 23 == 0) {
1959                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1960                         elemcborlen += 0x40;
1961                         uint lctr = ctr;
1962                         while (byte(elemcborlen).length > ctr - lctr) {
1963                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1964                             ctr++;
1965                         }
1966                     }
1967                     res[ctr] = elemArray[i][x];
1968                     ctr++;
1969                 }
1970                 res[ctr] = 0xFF;
1971                 ctr++;
1972             }
1973             return res;
1974         }
1975 
1976     function ba2cbor(bytes[] arr) internal returns (bytes) {
1977             uint arrlen = arr.length;
1978 
1979             // get correct cbor output length
1980             uint outputlen = 0;
1981             bytes[] memory elemArray = new bytes[](arrlen);
1982             for (uint i = 0; i < arrlen; i++) {
1983                 elemArray[i] = (bytes(arr[i]));
1984                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1985             }
1986             uint ctr = 0;
1987             uint cborlen = arrlen + 0x80;
1988             outputlen += byte(cborlen).length;
1989             bytes memory res = new bytes(outputlen);
1990 
1991             while (byte(cborlen).length > ctr) {
1992                 res[ctr] = byte(cborlen)[ctr];
1993                 ctr++;
1994             }
1995             for (i = 0; i < arrlen; i++) {
1996                 res[ctr] = 0x5F;
1997                 ctr++;
1998                 for (uint x = 0; x < elemArray[i].length; x++) {
1999                     // if there's a bug with larger strings, this may be the culprit
2000                     if (x % 23 == 0) {
2001                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
2002                         elemcborlen += 0x40;
2003                         uint lctr = ctr;
2004                         while (byte(elemcborlen).length > ctr - lctr) {
2005                             res[ctr] = byte(elemcborlen)[ctr - lctr];
2006                             ctr++;
2007                         }
2008                     }
2009                     res[ctr] = elemArray[i][x];
2010                     ctr++;
2011                 }
2012                 res[ctr] = 0xFF;
2013                 ctr++;
2014             }
2015             return res;
2016         }
2017 
2018 
2019     string oraclize_network_name;
2020     function oraclize_setNetworkName(string _network_name) internal {
2021         oraclize_network_name = _network_name;
2022     }
2023 
2024     function oraclize_getNetworkName() internal returns (string) {
2025         return oraclize_network_name;
2026     }
2027 
2028     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
2029         if ((_nbytes == 0)||(_nbytes > 32)) throw;
2030         bytes memory nbytes = new bytes(1);
2031         nbytes[0] = byte(_nbytes);
2032         bytes memory unonce = new bytes(32);
2033         bytes memory sessionKeyHash = new bytes(32);
2034         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
2035         assembly {
2036             mstore(unonce, 0x20)
2037             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
2038             mstore(sessionKeyHash, 0x20)
2039             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
2040         }
2041         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
2042         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
2043         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
2044         return queryId;
2045     }
2046 
2047     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
2048         oraclize_randomDS_args[queryId] = commitment;
2049     }
2050 
2051     mapping(bytes32=>bytes32) oraclize_randomDS_args;
2052     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
2053 
2054     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
2055         bool sigok;
2056         address signer;
2057 
2058         bytes32 sigr;
2059         bytes32 sigs;
2060 
2061         bytes memory sigr_ = new bytes(32);
2062         uint offset = 4+(uint(dersig[3]) - 0x20);
2063         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
2064         bytes memory sigs_ = new bytes(32);
2065         offset += 32 + 2;
2066         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
2067 
2068         assembly {
2069             sigr := mload(add(sigr_, 32))
2070             sigs := mload(add(sigs_, 32))
2071         }
2072 
2073 
2074         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
2075         if (address(sha3(pubkey)) == signer) return true;
2076         else {
2077             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
2078             return (address(sha3(pubkey)) == signer);
2079         }
2080     }
2081 
2082     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
2083         bool sigok;
2084 
2085         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
2086         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
2087         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
2088 
2089         bytes memory appkey1_pubkey = new bytes(64);
2090         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
2091 
2092         bytes memory tosign2 = new bytes(1+65+32);
2093         tosign2[0] = 1; //role
2094         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
2095         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
2096         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
2097         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
2098 
2099         if (sigok == false) return false;
2100 
2101 
2102         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
2103         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
2104 
2105         bytes memory tosign3 = new bytes(1+65);
2106         tosign3[0] = 0xFE;
2107         copyBytes(proof, 3, 65, tosign3, 1);
2108 
2109         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
2110         copyBytes(proof, 3+65, sig3.length, sig3, 0);
2111 
2112         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2113 
2114         return sigok;
2115     }
2116 
2117     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
2118         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2119         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
2120 
2121         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2122         if (proofVerified == false) throw;
2123 
2124         _;
2125     }
2126 
2127     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
2128         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2129         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
2130 
2131         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2132         if (proofVerified == false) return 2;
2133 
2134         return 0;
2135     }
2136 
2137     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
2138         bool match_ = true;
2139 
2140         for (var i=0; i<prefix.length; i++){
2141             if (content[i] != prefix[i]) match_ = false;
2142         }
2143 
2144         return match_;
2145     }
2146 
2147     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
2148         bool checkok;
2149 
2150 
2151         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
2152         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
2153         bytes memory keyhash = new bytes(32);
2154         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
2155         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
2156         if (checkok == false) return false;
2157 
2158         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
2159         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
2160 
2161 
2162         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
2163         checkok = matchBytes32Prefix(sha256(sig1), result);
2164         if (checkok == false) return false;
2165 
2166 
2167         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2168         // This is to verify that the computed args match with the ones specified in the query.
2169         bytes memory commitmentSlice1 = new bytes(8+1+32);
2170         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
2171 
2172         bytes memory sessionPubkey = new bytes(64);
2173         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
2174         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
2175 
2176         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2177         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
2178             delete oraclize_randomDS_args[queryId];
2179         } else return false;
2180 
2181 
2182         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
2183         bytes memory tosign1 = new bytes(32+8+1+32);
2184         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
2185         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
2186         if (checkok == false) return false;
2187 
2188         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
2189         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
2190             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
2191         }
2192 
2193         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2194     }
2195 
2196 
2197     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2198     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
2199         uint minLength = length + toOffset;
2200 
2201         if (to.length < minLength) {
2202             // Buffer too small
2203             throw; // Should be a better way?
2204         }
2205 
2206         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2207         uint i = 32 + fromOffset;
2208         uint j = 32 + toOffset;
2209 
2210         while (i < (32 + fromOffset + length)) {
2211             assembly {
2212                 let tmp := mload(add(from, i))
2213                 mstore(add(to, j), tmp)
2214             }
2215             i += 32;
2216             j += 32;
2217         }
2218 
2219         return to;
2220     }
2221 
2222     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2223     // Duplicate Solidity's ecrecover, but catching the CALL return value
2224     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
2225         // We do our own memory management here. Solidity uses memory offset
2226         // 0x40 to store the current end of memory. We write past it (as
2227         // writes are memory extensions), but don't update the offset so
2228         // Solidity will reuse it. The memory used here is only needed for
2229         // this context.
2230 
2231         // FIXME: inline assembly can't access return values
2232         bool ret;
2233         address addr;
2234 
2235         assembly {
2236             let size := mload(0x40)
2237             mstore(size, hash)
2238             mstore(add(size, 32), v)
2239             mstore(add(size, 64), r)
2240             mstore(add(size, 96), s)
2241 
2242             // NOTE: we can reuse the request memory because we deal with
2243             //       the return code
2244             ret := call(3000, 1, 0, size, 128, size, 32)
2245             addr := mload(size)
2246         }
2247 
2248         return (ret, addr);
2249     }
2250 
2251     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2252     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2253         bytes32 r;
2254         bytes32 s;
2255         uint8 v;
2256 
2257         if (sig.length != 65)
2258           return (false, 0);
2259 
2260         // The signature format is a compact form of:
2261         //   {bytes32 r}{bytes32 s}{uint8 v}
2262         // Compact means, uint8 is not padded to 32 bytes.
2263         assembly {
2264             r := mload(add(sig, 32))
2265             s := mload(add(sig, 64))
2266 
2267             // Here we are loading the last 32 bytes. We exploit the fact that
2268             // 'mload' will pad with zeroes if we overread.
2269             // There is no 'mload8' to do this, but that would be nicer.
2270             v := byte(0, mload(add(sig, 96)))
2271 
2272             // Alternative solution:
2273             // 'byte' is not working due to the Solidity parser, so lets
2274             // use the second best option, 'and'
2275             // v := and(mload(add(sig, 65)), 255)
2276         }
2277 
2278         // albeit non-transactional signatures are not specified by the YP, one would expect it
2279         // to match the YP range of [27, 28]
2280         //
2281         // geth uses [0, 1] and some clients have followed. This might change, see:
2282         //  https://github.com/ethereum/go-ethereum/issues/2053
2283         if (v < 27)
2284           v += 27;
2285 
2286         if (v != 27 && v != 28)
2287             return (false, 0);
2288 
2289         return safer_ecrecover(hash, v, r, s);
2290     }
2291 
2292 }
2293 // </ORACLIZE_API>
2294 
2295 // File: contracts/FlightDelayOraclizeInterface.sol
2296 
2297 /**
2298  * FlightDelay with Oraclized Underwriting and Payout
2299  *
2300  * @description	Ocaclize API interface
2301  * @copyright (c) 2017 etherisc GmbH
2302  * @author Christoph Mussenbrock, Stephan Karpischek
2303  */
2304 
2305 pragma solidity ^0.4.11;
2306 
2307 
2308 
2309 
2310 contract FlightDelayOraclizeInterface is usingOraclize {
2311 
2312     modifier onlyOraclizeOr (address _emergency) {
2313 // --> prod-mode
2314         require(msg.sender == oraclize_cbAddress() || msg.sender == _emergency);
2315 // <-- prod-mode
2316         _;
2317     }
2318 }
2319 
2320 // File: contracts/FlightDelayPayoutInterface.sol
2321 
2322 /**
2323  * FlightDelay with Oraclized Underwriting and Payout
2324  *
2325  * @description	Payout contract interface
2326  * @copyright (c) 2017 etherisc GmbH
2327  * @author Christoph Mussenbrock, Stephan Karpischek
2328  */
2329 
2330 pragma solidity ^0.4.11;
2331 
2332 
2333 contract FlightDelayPayoutInterface {
2334 
2335     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _offset) public;
2336 }
2337 
2338 // File: contracts/convertLib.sol
2339 
2340 /**
2341  * FlightDelay with Oraclized Underwriting and Payout
2342  *
2343  * @description	Conversions
2344  * @copyright (c) 2017 etherisc GmbH
2345  * @author Christoph Mussenbrock
2346  */
2347 
2348 pragma solidity ^0.4.11;
2349 
2350 
2351 contract ConvertLib {
2352 
2353     // .. since beginning of the year
2354     uint16[12] days_since = [
2355         11,
2356         42,
2357         70,
2358         101,
2359         131,
2360         162,
2361         192,
2362         223,
2363         254,
2364         284,
2365         315,
2366         345
2367     ];
2368 
2369     function b32toString(bytes32 x) internal returns (string) {
2370         // gas usage: about 1K gas per char.
2371         bytes memory bytesString = new bytes(32);
2372         uint charCount = 0;
2373 
2374         for (uint j = 0; j < 32; j++) {
2375             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
2376             if (char != 0) {
2377                 bytesString[charCount] = char;
2378                 charCount++;
2379             }
2380         }
2381 
2382         bytes memory bytesStringTrimmed = new bytes(charCount);
2383 
2384         for (j = 0; j < charCount; j++) {
2385             bytesStringTrimmed[j] = bytesString[j];
2386         }
2387 
2388         return string(bytesStringTrimmed);
2389     }
2390 
2391     function b32toHexString(bytes32 x) returns (string) {
2392         bytes memory b = new bytes(64);
2393         for (uint i = 0; i < 32; i++) {
2394             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
2395             uint8 high = by/16;
2396             uint8 low = by - 16*high;
2397             if (high > 9) {
2398                 high += 39;
2399             }
2400             if (low > 9) {
2401                 low += 39;
2402             }
2403             b[2*i] = byte(high+48);
2404             b[2*i+1] = byte(low+48);
2405         }
2406 
2407         return string(b);
2408     }
2409 
2410     function parseInt(string _a) internal returns (uint) {
2411         return parseInt(_a, 0);
2412     }
2413 
2414     // parseInt(parseFloat*10^_b)
2415     function parseInt(string _a, uint _b) internal returns (uint) {
2416         bytes memory bresult = bytes(_a);
2417         uint mint = 0;
2418         bool decimals = false;
2419         for (uint i = 0; i<bresult.length; i++) {
2420             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
2421                 if (decimals) {
2422                     if (_b == 0) {
2423                         break;
2424                     } else {
2425                         _b--;
2426                     }
2427                 }
2428                 mint *= 10;
2429                 mint += uint(bresult[i]) - 48;
2430             } else if (bresult[i] == 46) {
2431                 decimals = true;
2432             }
2433         }
2434         if (_b > 0) {
2435             mint *= 10**_b;
2436         }
2437         return mint;
2438     }
2439 
2440     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
2441     // so within the validity of the contract its correct.
2442     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
2443         // _day_month_year = /dep/2016/09/10
2444         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
2445         bytes memory temp2 = bytes(new string(2));
2446         bytes memory temp4 = bytes(new string(4));
2447 
2448         temp4[0] = bDmy[5];
2449         temp4[1] = bDmy[6];
2450         temp4[2] = bDmy[7];
2451         temp4[3] = bDmy[8];
2452         uint year = parseInt(string(temp4));
2453 
2454         temp2[0] = bDmy[10];
2455         temp2[1] = bDmy[11];
2456         uint month = parseInt(string(temp2));
2457 
2458         temp2[0] = bDmy[13];
2459         temp2[1] = bDmy[14];
2460         uint day = parseInt(string(temp2));
2461 
2462         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
2463     }
2464 }
2465 
2466 // File: contracts/FlightDelayPayout.sol
2467 
2468 /**
2469  * FlightDelay with Oraclized Underwriting and Payout
2470  *
2471  * @description	Payout contract
2472  * @copyright (c) 2017 etherisc GmbH
2473  * @author Christoph Mussenbrock
2474  */
2475 
2476 pragma solidity ^0.4.11;
2477 
2478 
2479 
2480 
2481 
2482 
2483 
2484 
2485 
2486 
2487 
2488 
2489 contract FlightDelayPayout is FlightDelayControlledContract, FlightDelayConstants, FlightDelayOraclizeInterface, ConvertLib {
2490 
2491     using strings for *;
2492 
2493     FlightDelayDatabaseInterface FD_DB;
2494     FlightDelayLedgerInterface FD_LG;
2495     FlightDelayAccessControllerInterface FD_AC;
2496 
2497     /*
2498      * @dev Contract constructor sets its controller
2499      * @param _controller FD.Controller
2500      */
2501     function FlightDelayPayout(address _controller) public {
2502         setController(_controller);
2503         oraclize_setCustomGasPrice(ORACLIZE_GASPRICE);
2504     }
2505 
2506     /*
2507      * Public methods
2508      */
2509 
2510     /*
2511      * @dev Set access permissions for methods
2512      */
2513     function setContracts() public onlyController {
2514         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
2515         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
2516         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
2517 
2518         FD_AC.setPermissionById(101, "FD.Underwrite");
2519         FD_AC.setPermissionByAddress(101, oraclize_cbAddress());
2520         FD_AC.setPermissionById(102, "FD.Funder");
2521     }
2522 
2523     /*
2524      * @dev Fund contract
2525      */
2526     function () public payable {
2527         require(FD_AC.checkPermission(102, msg.sender));
2528 
2529         // todo: bookkeeping
2530         // todo: fire funding event
2531     }
2532 
2533     /*
2534      * @dev Schedule oraclize call for payout
2535      * @param _policyId
2536      * @param _riskId
2537      * @param _oraclizeTime
2538      */
2539     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _oraclizeTime) public {
2540         require(FD_AC.checkPermission(101, msg.sender));
2541 
2542         var (carrierFlightNumber, departureYearMonthDay,) = FD_DB.getRiskParameters(_riskId);
2543 
2544         string memory oraclizeUrl = strConcat(
2545             ORACLIZE_STATUS_BASE_URL,
2546             b32toString(carrierFlightNumber),
2547             b32toString(departureYearMonthDay),
2548             ORACLIZE_STATUS_QUERY
2549         );
2550 
2551         bytes32 queryId = oraclize_query(
2552             _oraclizeTime,
2553             "nested",
2554             oraclizeUrl,
2555             ORACLIZE_GAS
2556         );
2557 
2558         FD_DB.createOraclizeCallback(
2559             queryId,
2560             _policyId,
2561             oraclizeState.ForPayout,
2562             _oraclizeTime
2563         );
2564 
2565         LogOraclizeCall(_policyId, queryId, oraclizeUrl, _oraclizeTime);
2566     }
2567 
2568     /*
2569      * @dev Oraclize callback. In an emergency case, we can call this directly from FD.Emergency Account.
2570      * @param _queryId
2571      * @param _result
2572      * @param _proof
2573      */
2574     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclizeOr(getContract('FD.Emergency')) {
2575 
2576         var (policyId, oraclizeTime) = FD_DB.getOraclizeCallback(_queryId);
2577         LogOraclizeCallback(policyId, _queryId, _result, _proof);
2578 
2579         // check if policy was declined after this callback was scheduled
2580         var state = FD_DB.getPolicyState(policyId);
2581         require(uint8(state) != 5);
2582 
2583         bytes32 riskId = FD_DB.getRiskId(policyId);
2584 
2585 // --> debug-mode
2586 //            LogBytes32("riskId", riskId);
2587 // <-- debug-mode
2588 
2589         var slResult = _result.toSlice();
2590 
2591         if (bytes(_result).length == 0) { // empty Result
2592             if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2593                 LogPolicyManualPayout(policyId, "No Callback at +120 min");
2594                 return;
2595             } else {
2596                 schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2597             }
2598         } else {
2599             // first check status
2600             // extract the status field:
2601             slResult.find("\"".toSlice()).beyond("\"".toSlice());
2602             slResult.until(slResult.copy().find("\"".toSlice()));
2603             bytes1 status = bytes(slResult.toString())[0];	// s = L
2604             if (status == "C") {
2605                 // flight cancelled --> payout
2606                 payOut(policyId, 4, 0);
2607                 return;
2608             } else if (status == "D") {
2609                 // flight diverted --> payout
2610                 payOut(policyId, 5, 0);
2611                 return;
2612             } else if (status != "L" && status != "A" && status != "C" && status != "D") {
2613                 LogPolicyManualPayout(policyId, "Unprocessable status");
2614                 return;
2615             }
2616 
2617             // process the rest of the response:
2618             slResult = _result.toSlice();
2619             bool arrived = slResult.contains("actualGateArrival".toSlice());
2620 
2621             if (status == "A" || (status == "L" && !arrived)) {
2622                 // flight still active or not at gate --> reschedule
2623                 if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2624                     LogPolicyManualPayout(policyId, "No arrival at +180 min");
2625                 } else {
2626                     schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2627                 }
2628             } else if (status == "L" && arrived) {
2629                 var aG = "\"arrivalGateDelayMinutes\": ".toSlice();
2630                 if (slResult.contains(aG)) {
2631                     slResult.find(aG).beyond(aG);
2632                     slResult.until(slResult.copy().find("\"".toSlice()).beyond("\"".toSlice()));
2633                     // truffle bug, replace by "}" as soon as it is fixed.
2634                     slResult.until(slResult.copy().find("\x7D".toSlice()));
2635                     slResult.until(slResult.copy().find(",".toSlice()));
2636                     uint delayInMinutes = parseInt(slResult.toString());
2637                 } else {
2638                     delayInMinutes = 0;
2639                 }
2640 
2641                 if (delayInMinutes < 15) {
2642                     payOut(policyId, 0, 0);
2643                 } else if (delayInMinutes < 30) {
2644                     payOut(policyId, 1, delayInMinutes);
2645                 } else if (delayInMinutes < 45) {
2646                     payOut(policyId, 2, delayInMinutes);
2647                 } else {
2648                     payOut(policyId, 3, delayInMinutes);
2649                 }
2650             } else { // no delay info
2651                 payOut(policyId, 0, 0);
2652             }
2653         }
2654     }
2655 
2656     /*
2657      * Internal methods
2658      */
2659 
2660     /*
2661      * @dev Payout
2662      * @param _policyId
2663      * @param _delay
2664      * @param _delayInMinutes
2665      */
2666     function payOut(uint _policyId, uint8 _delay, uint _delayInMinutes)	internal {
2667 // --> debug-mode
2668 //            LogString("im payOut", "");
2669 //            LogUint("policyId", _policyId);
2670 //            LogUint("delay", _delay);
2671 //            LogUint("in minutes", _delayInMinutes);
2672 // <-- debug-mode
2673 
2674         FD_DB.setDelay(_policyId, _delay, _delayInMinutes);
2675 
2676         if (_delay == 0) {
2677             FD_DB.setState(
2678                 _policyId,
2679                 policyState.Expired,
2680                 now,
2681                 "Expired - no delay!"
2682             );
2683         } else {
2684             var (customer, weight, premium) = FD_DB.getPolicyData(_policyId);
2685 
2686 // --> debug-mode
2687 //                LogUint("weight", weight);
2688 // <-- debug-mode
2689 
2690             if (weight == 0) {
2691                 weight = 20000;
2692             }
2693 
2694             uint payout = premium * WEIGHT_PATTERN[_delay] * 10000 / weight;
2695             uint calculatedPayout = payout;
2696 
2697             if (payout > MAX_PAYOUT) {
2698                 payout = MAX_PAYOUT;
2699             }
2700 
2701             FD_DB.setPayouts(_policyId, calculatedPayout, payout);
2702 
2703             if (!FD_LG.sendFunds(customer, Acc.Payout, payout)) {
2704                 FD_DB.setState(
2705                     _policyId,
2706                     policyState.SendFailed,
2707                     now,
2708                     "Payout, send failed!"
2709                 );
2710 
2711                 FD_DB.setPayouts(_policyId, calculatedPayout, 0);
2712             } else {
2713                 FD_DB.setState(
2714                     _policyId,
2715                     policyState.PaidOut,
2716                     now,
2717                     "Payout successful!"
2718                 );
2719             }
2720         }
2721     }
2722 }