1 // File: vendors/strings.sol
2 
3 /*
4  * @title String & slice utility library for Solidity contracts.
5  * @author Nick Johnson <arachnid@notdot.net>
6  *
7  * @dev Functionality in this library is largely implemented using an
8  *      abstraction called a 'slice'. A slice represents a part of a string -
9  *      anything from the entire string to a single character, or even no
10  *      characters at all (a 0-length slice). Since a slice only has to specify
11  *      an offset and a length, copying and manipulating slices is a lot less
12  *      expensive than copying and manipulating the strings they reference.
13  *
14  *      To further reduce gas costs, most functions on slice that need to return
15  *      a slice modify the original one instead of allocating a new one; for
16  *      instance, `s.split(".")` will return the text up to the first '.',
17  *      modifying s to only contain the remainder of the string after the '.'.
18  *      In situations where you do not want to modify the original slice, you
19  *      can make a copy first with `.copy()`, for example:
20  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
21  *      Solidity has no memory management, it will result in allocating many
22  *      short-lived slices that are later discarded.
23  *
24  *      Functions that return two slices come in two versions: a non-allocating
25  *      version that takes the second slice as an argument, modifying it in
26  *      place, and an allocating version that allocates and returns the second
27  *      slice; see `nextRune` for example.
28  *
29  *      Functions that have to copy string data will return strings rather than
30  *      slices; these can be cast back to slices for further processing if
31  *      required.
32  *
33  *      For convenience, some functions are provided with non-modifying
34  *      variants that create a new slice and return both; for instance,
35  *      `s.splitNew('.')` leaves s unmodified, and returns two values
36  *      corresponding to the left and right parts of the string.
37  */
38 
39 pragma solidity ^0.4.7;
40 
41 library strings {
42     struct slice {
43         uint _len;
44         uint _ptr;
45     }
46 
47     function memcpy(uint dest, uint src, uint len) private {
48         // Copy word-length chunks while possible
49         for(; len >= 32; len -= 32) {
50             assembly {
51                 mstore(dest, mload(src))
52             }
53             dest += 32;
54             src += 32;
55         }
56 
57         // Copy remaining bytes
58         uint mask = 256 ** (32 - len) - 1;
59         assembly {
60             let srcpart := and(mload(src), not(mask))
61             let destpart := and(mload(dest), mask)
62             mstore(dest, or(destpart, srcpart))
63         }
64     }
65 
66     /*
67      * @dev Returns a slice containing the entire string.
68      * @param self The string to make a slice from.
69      * @return A newly allocated slice containing the entire string.
70      */
71     function toSlice(string self) internal returns (slice) {
72         uint ptr;
73         assembly {
74             ptr := add(self, 0x20)
75         }
76         return slice(bytes(self).length, ptr);
77     }
78 
79     /*
80      * @dev Returns the length of a null-terminated bytes32 string.
81      * @param self The value to find the length of.
82      * @return The length of the string, from 0 to 32.
83      */
84     function len(bytes32 self) internal returns (uint) {
85         uint ret;
86         if (self == 0)
87             return 0;
88         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
89             ret += 16;
90             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
91         }
92         if (self & 0xffffffffffffffff == 0) {
93             ret += 8;
94             self = bytes32(uint(self) / 0x10000000000000000);
95         }
96         if (self & 0xffffffff == 0) {
97             ret += 4;
98             self = bytes32(uint(self) / 0x100000000);
99         }
100         if (self & 0xffff == 0) {
101             ret += 2;
102             self = bytes32(uint(self) / 0x10000);
103         }
104         if (self & 0xff == 0) {
105             ret += 1;
106         }
107         return 32 - ret;
108     }
109 
110     /*
111      * @dev Returns a slice containing the entire bytes32, interpreted as a
112      *      null-termintaed utf-8 string.
113      * @param self The bytes32 value to convert to a slice.
114      * @return A new slice containing the value of the input argument up to the
115      *         first null.
116      */
117     function toSliceB32(bytes32 self) internal returns (slice ret) {
118         // Allocate space for `self` in memory, copy it there, and point ret at it
119         assembly {
120             let ptr := mload(0x40)
121             mstore(0x40, add(ptr, 0x20))
122             mstore(ptr, self)
123             mstore(add(ret, 0x20), ptr)
124         }
125         ret._len = len(self);
126     }
127 
128     /*
129      * @dev Returns a new slice containing the same data as the current slice.
130      * @param self The slice to copy.
131      * @return A new slice containing the same data as `self`.
132      */
133     function copy(slice self) internal returns (slice) {
134         return slice(self._len, self._ptr);
135     }
136 
137     /*
138      * @dev Copies a slice to a new string.
139      * @param self The slice to copy.
140      * @return A newly allocated string containing the slice's text.
141      */
142     function toString(slice self) internal returns (string) {
143         var ret = new string(self._len);
144         uint retptr;
145         assembly { retptr := add(ret, 32) }
146 
147         memcpy(retptr, self._ptr, self._len);
148         return ret;
149     }
150 
151     /*
152      * @dev Returns the length in runes of the slice. Note that this operation
153      *      takes time proportional to the length of the slice; avoid using it
154      *      in loops, and call `slice.empty()` if you only need to know whether
155      *      the slice is empty or not.
156      * @param self The slice to operate on.
157      * @return The length of the slice in runes.
158      */
159     function len(slice self) internal returns (uint) {
160         // Starting at ptr-31 means the LSB will be the byte we care about
161         var ptr = self._ptr - 31;
162         var end = ptr + self._len;
163         for (uint len = 0; ptr < end; len++) {
164             uint8 b;
165             assembly { b := and(mload(ptr), 0xFF) }
166             if (b < 0x80) {
167                 ptr += 1;
168             } else if(b < 0xE0) {
169                 ptr += 2;
170             } else if(b < 0xF0) {
171                 ptr += 3;
172             } else if(b < 0xF8) {
173                 ptr += 4;
174             } else if(b < 0xFC) {
175                 ptr += 5;
176             } else {
177                 ptr += 6;
178             }
179         }
180         return len;
181     }
182 
183     /*
184      * @dev Returns true if the slice is empty (has a length of 0).
185      * @param self The slice to operate on.
186      * @return True if the slice is empty, False otherwise.
187      */
188     function empty(slice self) internal returns (bool) {
189         return self._len == 0;
190     }
191 
192     /*
193      * @dev Returns a positive number if `other` comes lexicographically after
194      *      `self`, a negative number if it comes before, or zero if the
195      *      contents of the two slices are equal. Comparison is done per-rune,
196      *      on unicode codepoints.
197      * @param self The first slice to compare.
198      * @param other The second slice to compare.
199      * @return The result of the comparison.
200      */
201     function compare(slice self, slice other) internal returns (int) {
202         uint shortest = self._len;
203         if (other._len < self._len)
204             shortest = other._len;
205 
206         var selfptr = self._ptr;
207         var otherptr = other._ptr;
208         for (uint idx = 0; idx < shortest; idx += 32) {
209             uint a;
210             uint b;
211             assembly {
212                 a := mload(selfptr)
213                 b := mload(otherptr)
214             }
215             if (a != b) {
216                 // Mask out irrelevant bytes and check again
217                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
218                 var diff = (a & mask) - (b & mask);
219                 if (diff != 0)
220                     return int(diff);
221             }
222             selfptr += 32;
223             otherptr += 32;
224         }
225         return int(self._len) - int(other._len);
226     }
227 
228     /*
229      * @dev Returns true if the two slices contain the same text.
230      * @param self The first slice to compare.
231      * @param self The second slice to compare.
232      * @return True if the slices are equal, false otherwise.
233      */
234     function equals(slice self, slice other) internal returns (bool) {
235         return compare(self, other) == 0;
236     }
237 
238     /*
239      * @dev Extracts the first rune in the slice into `rune`, advancing the
240      *      slice to point to the next rune and returning `self`.
241      * @param self The slice to operate on.
242      * @param rune The slice that will contain the first rune.
243      * @return `rune`.
244      */
245     function nextRune(slice self, slice rune) internal returns (slice) {
246         rune._ptr = self._ptr;
247 
248         if (self._len == 0) {
249             rune._len = 0;
250             return rune;
251         }
252 
253         uint len;
254         uint b;
255         // Load the first byte of the rune into the LSBs of b
256         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
257         if (b < 0x80) {
258             len = 1;
259         } else if(b < 0xE0) {
260             len = 2;
261         } else if(b < 0xF0) {
262             len = 3;
263         } else {
264             len = 4;
265         }
266 
267         // Check for truncated codepoints
268         if (len > self._len) {
269             rune._len = self._len;
270             self._ptr += self._len;
271             self._len = 0;
272             return rune;
273         }
274 
275         self._ptr += len;
276         self._len -= len;
277         rune._len = len;
278         return rune;
279     }
280 
281     /*
282      * @dev Returns the first rune in the slice, advancing the slice to point
283      *      to the next rune.
284      * @param self The slice to operate on.
285      * @return A slice containing only the first rune from `self`.
286      */
287     function nextRune(slice self) internal returns (slice ret) {
288         nextRune(self, ret);
289     }
290 
291     /*
292      * @dev Returns the number of the first codepoint in the slice.
293      * @param self The slice to operate on.
294      * @return The number of the first codepoint in the slice.
295      */
296     function ord(slice self) internal returns (uint ret) {
297         if (self._len == 0) {
298             return 0;
299         }
300 
301         uint word;
302         uint len;
303         uint div = 2 ** 248;
304 
305         // Load the rune into the MSBs of b
306         assembly { word:= mload(mload(add(self, 32))) }
307         var b = word / div;
308         if (b < 0x80) {
309             ret = b;
310             len = 1;
311         } else if(b < 0xE0) {
312             ret = b & 0x1F;
313             len = 2;
314         } else if(b < 0xF0) {
315             ret = b & 0x0F;
316             len = 3;
317         } else {
318             ret = b & 0x07;
319             len = 4;
320         }
321 
322         // Check for truncated codepoints
323         if (len > self._len) {
324             return 0;
325         }
326 
327         for (uint i = 1; i < len; i++) {
328             div = div / 256;
329             b = (word / div) & 0xFF;
330             if (b & 0xC0 != 0x80) {
331                 // Invalid UTF-8 sequence
332                 return 0;
333             }
334             ret = (ret * 64) | (b & 0x3F);
335         }
336 
337         return ret;
338     }
339 
340     /*
341      * @dev Returns the keccak-256 hash of the slice.
342      * @param self The slice to hash.
343      * @return The hash of the slice.
344      */
345     function keccak(slice self) internal returns (bytes32 ret) {
346         assembly {
347             ret := sha3(mload(add(self, 32)), mload(self))
348         }
349     }
350 
351     /*
352      * @dev Returns true if `self` starts with `needle`.
353      * @param self The slice to operate on.
354      * @param needle The slice to search for.
355      * @return True if the slice starts with the provided text, false otherwise.
356      */
357     function startsWith(slice self, slice needle) internal returns (bool) {
358         if (self._len < needle._len) {
359             return false;
360         }
361 
362         if (self._ptr == needle._ptr) {
363             return true;
364         }
365 
366         bool equal;
367         assembly {
368             let len := mload(needle)
369             let selfptr := mload(add(self, 0x20))
370             let needleptr := mload(add(needle, 0x20))
371             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
372         }
373         return equal;
374     }
375 
376     /*
377      * @dev If `self` starts with `needle`, `needle` is removed from the
378      *      beginning of `self`. Otherwise, `self` is unmodified.
379      * @param self The slice to operate on.
380      * @param needle The slice to search for.
381      * @return `self`
382      */
383     function beyond(slice self, slice needle) internal returns (slice) {
384         if (self._len < needle._len) {
385             return self;
386         }
387 
388         bool equal = true;
389         if (self._ptr != needle._ptr) {
390             assembly {
391                 let len := mload(needle)
392                 let selfptr := mload(add(self, 0x20))
393                 let needleptr := mload(add(needle, 0x20))
394                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
395             }
396         }
397 
398         if (equal) {
399             self._len -= needle._len;
400             self._ptr += needle._len;
401         }
402 
403         return self;
404     }
405 
406     /*
407      * @dev Returns true if the slice ends with `needle`.
408      * @param self The slice to operate on.
409      * @param needle The slice to search for.
410      * @return True if the slice starts with the provided text, false otherwise.
411      */
412     function endsWith(slice self, slice needle) internal returns (bool) {
413         if (self._len < needle._len) {
414             return false;
415         }
416 
417         var selfptr = self._ptr + self._len - needle._len;
418 
419         if (selfptr == needle._ptr) {
420             return true;
421         }
422 
423         bool equal;
424         assembly {
425             let len := mload(needle)
426             let needleptr := mload(add(needle, 0x20))
427             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
428         }
429 
430         return equal;
431     }
432 
433     /*
434      * @dev If `self` ends with `needle`, `needle` is removed from the
435      *      end of `self`. Otherwise, `self` is unmodified.
436      * @param self The slice to operate on.
437      * @param needle The slice to search for.
438      * @return `self`
439      */
440     function until(slice self, slice needle) internal returns (slice) {
441         if (self._len < needle._len) {
442             return self;
443         }
444 
445         var selfptr = self._ptr + self._len - needle._len;
446         bool equal = true;
447         if (selfptr != needle._ptr) {
448             assembly {
449                 let len := mload(needle)
450                 let needleptr := mload(add(needle, 0x20))
451                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
452             }
453         }
454 
455         if (equal) {
456             self._len -= needle._len;
457         }
458 
459         return self;
460     }
461 
462     // Returns the memory address of the first byte of the first occurrence of
463     // `needle` in `self`, or the first byte after `self` if not found.
464     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
465         uint ptr;
466         uint idx;
467 
468         if (needlelen <= selflen) {
469             if (needlelen <= 32) {
470                 // Optimized assembly for 68 gas per byte on short strings
471                 assembly {
472                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
473                     let needledata := and(mload(needleptr), mask)
474                     let end := add(selfptr, sub(selflen, needlelen))
475                     ptr := selfptr
476                     loop:
477                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
478                     ptr := add(ptr, 1)
479                     jumpi(loop, lt(sub(ptr, 1), end))
480                     ptr := add(selfptr, selflen)
481                     exit:
482                 }
483                 return ptr;
484             } else {
485                 // For long needles, use hashing
486                 bytes32 hash;
487                 assembly { hash := sha3(needleptr, needlelen) }
488                 ptr = selfptr;
489                 for (idx = 0; idx <= selflen - needlelen; idx++) {
490                     bytes32 testHash;
491                     assembly { testHash := sha3(ptr, needlelen) }
492                     if (hash == testHash)
493                         return ptr;
494                     ptr += 1;
495                 }
496             }
497         }
498         return selfptr + selflen;
499     }
500 
501     // Returns the memory address of the first byte after the last occurrence of
502     // `needle` in `self`, or the address of `self` if not found.
503     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
504         uint ptr;
505 
506         if (needlelen <= selflen) {
507             if (needlelen <= 32) {
508                 // Optimized assembly for 69 gas per byte on short strings
509                 assembly {
510                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
511                     let needledata := and(mload(needleptr), mask)
512                     ptr := add(selfptr, sub(selflen, needlelen))
513                     loop:
514                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
515                     ptr := sub(ptr, 1)
516                     jumpi(loop, gt(add(ptr, 1), selfptr))
517                     ptr := selfptr
518                     jump(exit)
519                     ret:
520                     ptr := add(ptr, needlelen)
521                     exit:
522                 }
523                 return ptr;
524             } else {
525                 // For long needles, use hashing
526                 bytes32 hash;
527                 assembly { hash := sha3(needleptr, needlelen) }
528                 ptr = selfptr + (selflen - needlelen);
529                 while (ptr >= selfptr) {
530                     bytes32 testHash;
531                     assembly { testHash := sha3(ptr, needlelen) }
532                     if (hash == testHash)
533                         return ptr + needlelen;
534                     ptr -= 1;
535                 }
536             }
537         }
538         return selfptr;
539     }
540 
541     /*
542      * @dev Modifies `self` to contain everything from the first occurrence of
543      *      `needle` to the end of the slice. `self` is set to the empty slice
544      *      if `needle` is not found.
545      * @param self The slice to search and modify.
546      * @param needle The text to search for.
547      * @return `self`.
548      */
549     function find(slice self, slice needle) internal returns (slice) {
550         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
551         self._len -= ptr - self._ptr;
552         self._ptr = ptr;
553         return self;
554     }
555 
556     /*
557      * @dev Modifies `self` to contain the part of the string from the start of
558      *      `self` to the end of the first occurrence of `needle`. If `needle`
559      *      is not found, `self` is set to the empty slice.
560      * @param self The slice to search and modify.
561      * @param needle The text to search for.
562      * @return `self`.
563      */
564     function rfind(slice self, slice needle) internal returns (slice) {
565         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
566         self._len = ptr - self._ptr;
567         return self;
568     }
569 
570     /*
571      * @dev Splits the slice, setting `self` to everything after the first
572      *      occurrence of `needle`, and `token` to everything before it. If
573      *      `needle` does not occur in `self`, `self` is set to the empty slice,
574      *      and `token` is set to the entirety of `self`.
575      * @param self The slice to split.
576      * @param needle The text to search for in `self`.
577      * @param token An output parameter to which the first token is written.
578      * @return `token`.
579      */
580     function split(slice self, slice needle, slice token) internal returns (slice) {
581         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
582         token._ptr = self._ptr;
583         token._len = ptr - self._ptr;
584         if (ptr == self._ptr + self._len) {
585             // Not found
586             self._len = 0;
587         } else {
588             self._len -= token._len + needle._len;
589             self._ptr = ptr + needle._len;
590         }
591         return token;
592     }
593 
594     /*
595      * @dev Splits the slice, setting `self` to everything after the first
596      *      occurrence of `needle`, and returning everything before it. If
597      *      `needle` does not occur in `self`, `self` is set to the empty slice,
598      *      and the entirety of `self` is returned.
599      * @param self The slice to split.
600      * @param needle The text to search for in `self`.
601      * @return The part of `self` up to the first occurrence of `delim`.
602      */
603     function split(slice self, slice needle) internal returns (slice token) {
604         split(self, needle, token);
605     }
606 
607     /*
608      * @dev Splits the slice, setting `self` to everything before the last
609      *      occurrence of `needle`, and `token` to everything after it. If
610      *      `needle` does not occur in `self`, `self` is set to the empty slice,
611      *      and `token` is set to the entirety of `self`.
612      * @param self The slice to split.
613      * @param needle The text to search for in `self`.
614      * @param token An output parameter to which the first token is written.
615      * @return `token`.
616      */
617     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
618         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
619         token._ptr = ptr;
620         token._len = self._len - (ptr - self._ptr);
621         if (ptr == self._ptr) {
622             // Not found
623             self._len = 0;
624         } else {
625             self._len -= token._len + needle._len;
626         }
627         return token;
628     }
629 
630     /*
631      * @dev Splits the slice, setting `self` to everything before the last
632      *      occurrence of `needle`, and returning everything after it. If
633      *      `needle` does not occur in `self`, `self` is set to the empty slice,
634      *      and the entirety of `self` is returned.
635      * @param self The slice to split.
636      * @param needle The text to search for in `self`.
637      * @return The part of `self` after the last occurrence of `delim`.
638      */
639     function rsplit(slice self, slice needle) internal returns (slice token) {
640         rsplit(self, needle, token);
641     }
642 
643     /*
644      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
645      * @param self The slice to search.
646      * @param needle The text to search for in `self`.
647      * @return The number of occurrences of `needle` found in `self`.
648      */
649     function count(slice self, slice needle) internal returns (uint count) {
650         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
651         while (ptr <= self._ptr + self._len) {
652             count++;
653             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
654         }
655     }
656 
657     /*
658      * @dev Returns True if `self` contains `needle`.
659      * @param self The slice to search.
660      * @param needle The text to search for in `self`.
661      * @return True if `needle` is found in `self`, false otherwise.
662      */
663     function contains(slice self, slice needle) internal returns (bool) {
664         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
665     }
666 
667     /*
668      * @dev Returns a newly allocated string containing the concatenation of
669      *      `self` and `other`.
670      * @param self The first slice to concatenate.
671      * @param other The second slice to concatenate.
672      * @return The concatenation of the two strings.
673      */
674     function concat(slice self, slice other) internal returns (string) {
675         var ret = new string(self._len + other._len);
676         uint retptr;
677         assembly { retptr := add(ret, 32) }
678         memcpy(retptr, self._ptr, self._len);
679         memcpy(retptr + self._len, other._ptr, other._len);
680         return ret;
681     }
682 
683     /*
684      * @dev Joins an array of slices, using `self` as a delimiter, returning a
685      *      newly allocated string.
686      * @param self The delimiter to use.
687      * @param parts A list of slices to join.
688      * @return A newly allocated string containing all the slices in `parts`,
689      *         joined with `self`.
690      */
691     function join(slice self, slice[] parts) internal returns (string) {
692         if (parts.length == 0)
693             return "";
694 
695         uint len = self._len * (parts.length - 1);
696         for(uint i = 0; i < parts.length; i++)
697             len += parts[i]._len;
698 
699         var ret = new string(len);
700         uint retptr;
701         assembly { retptr := add(ret, 32) }
702 
703         for(i = 0; i < parts.length; i++) {
704             memcpy(retptr, parts[i]._ptr, parts[i]._len);
705             retptr += parts[i]._len;
706             if (i < parts.length - 1) {
707                 memcpy(retptr, self._ptr, self._len);
708                 retptr += self._len;
709             }
710         }
711 
712         return ret;
713     }
714 }
715 
716 // File: contracts/FlightDelayAccessControllerInterface.sol
717 
718 /**
719  * FlightDelay with Oraclized Underwriting and Payout
720  *
721  * @description	AccessControllerInterface
722  * @copyright (c) 2017 etherisc GmbH
723  * @author Christoph Mussenbrock
724  */
725 
726 pragma solidity ^0.4.11;
727 
728 
729 contract FlightDelayAccessControllerInterface {
730 
731     function setPermissionById(uint8 _perm, bytes32 _id) public;
732 
733     function setPermissionById(uint8 _perm, bytes32 _id, bool _access) public;
734 
735     function setPermissionByAddress(uint8 _perm, address _addr) public;
736 
737     function setPermissionByAddress(uint8 _perm, address _addr, bool _access) public;
738 
739     function checkPermission(uint8 _perm, address _addr) public returns (bool _success);
740 }
741 
742 // File: contracts/FlightDelayConstants.sol
743 
744 /**
745  * FlightDelay with Oraclized Underwriting and Payout
746  *
747  * @description	Events and Constants
748  * @copyright (c) 2017 etherisc GmbH
749  * @author Christoph Mussenbrock
750  */
751 
752 pragma solidity ^0.4.11;
753 
754 
755 contract FlightDelayConstants {
756 
757     /*
758     * General events
759     */
760 
761 // --> test-mode
762 //        event LogUint(string _message, uint _uint);
763 //        event LogUintEth(string _message, uint ethUint);
764 //        event LogUintTime(string _message, uint timeUint);
765 //        event LogInt(string _message, int _int);
766 //        event LogAddress(string _message, address _address);
767 //        event LogBytes32(string _message, bytes32 hexBytes32);
768 //        event LogBytes(string _message, bytes hexBytes);
769 //        event LogBytes32Str(string _message, bytes32 strBytes32);
770 //        event LogString(string _message, string _string);
771 //        event LogBool(string _message, bool _bool);
772 //        event Log(address);
773 // <-- test-mode
774 
775     event LogPolicyApplied(
776         uint _policyId,
777         address _customer,
778         bytes32 strCarrierFlightNumber,
779         uint ethPremium
780     );
781     event LogPolicyAccepted(
782         uint _policyId,
783         uint _statistics0,
784         uint _statistics1,
785         uint _statistics2,
786         uint _statistics3,
787         uint _statistics4,
788         uint _statistics5
789     );
790     event LogPolicyPaidOut(
791         uint _policyId,
792         uint ethAmount
793     );
794     event LogPolicyExpired(
795         uint _policyId
796     );
797     event LogPolicyDeclined(
798         uint _policyId,
799         bytes32 strReason
800     );
801     event LogPolicyManualPayout(
802         uint _policyId,
803         bytes32 strReason
804     );
805     event LogSendFunds(
806         address _recipient,
807         uint8 _from,
808         uint ethAmount
809     );
810     event LogReceiveFunds(
811         address _sender,
812         uint8 _to,
813         uint ethAmount
814     );
815     event LogSendFail(
816         uint _policyId,
817         bytes32 strReason
818     );
819     event LogOraclizeCall(
820         uint _policyId,
821         bytes32 hexQueryId,
822         string _oraclizeUrl,
823         uint256 _oraclizeTime
824     );
825     event LogOraclizeCallback(
826         uint _policyId,
827         bytes32 hexQueryId,
828         string _result,
829         bytes hexProof
830     );
831     event LogSetState(
832         uint _policyId,
833         uint8 _policyState,
834         uint _stateTime,
835         bytes32 _stateMessage
836     );
837     event LogExternal(
838         uint256 _policyId,
839         address _address,
840         bytes32 _externalId
841     );
842 
843     /*
844     * General constants
845     */
846     // contracts release version
847     uint public constant MAJOR_VERSION = 1;
848     uint public constant MINOR_VERSION = 0;
849     uint public constant PATCH_VERSION = 2;
850 
851     // minimum observations for valid prediction
852     uint constant MIN_OBSERVATIONS = 10;
853     // minimum premium to cover costs
854     uint constant MIN_PREMIUM = 50 finney;
855     // maximum premium
856     uint constant MAX_PREMIUM = 1 ether;
857     // maximum payout
858     uint constant MAX_PAYOUT = 1100 finney;
859 
860     uint constant MIN_PREMIUM_EUR = 1500 wei;
861     uint constant MAX_PREMIUM_EUR = 29000 wei;
862     uint constant MAX_PAYOUT_EUR = 30000 wei;
863 
864     uint constant MIN_PREMIUM_USD = 1700 wei;
865     uint constant MAX_PREMIUM_USD = 34000 wei;
866     uint constant MAX_PAYOUT_USD = 35000 wei;
867 
868     uint constant MIN_PREMIUM_GBP = 1300 wei;
869     uint constant MAX_PREMIUM_GBP = 25000 wei;
870     uint constant MAX_PAYOUT_GBP = 270 wei;
871 
872     // maximum cumulated weighted premium per risk
873     uint constant MAX_CUMULATED_WEIGHTED_PREMIUM = 60 ether;
874     // 1 percent for DAO, 1 percent for maintainer
875     uint8 constant REWARD_PERCENT = 2;
876     // reserve for tail risks
877     uint8 constant RESERVE_PERCENT = 1;
878     // the weight pattern; in future versions this may become part of the policy struct.
879     // currently can't be constant because of compiler restrictions
880     // WEIGHT_PATTERN[0] is not used, just to be consistent
881     uint8[6] WEIGHT_PATTERN = [
882         0,
883         0,
884         0,
885         30,
886         50,
887         50
888     ];
889 
890 // --> prod-mode
891     // DEFINITIONS FOR ROPSTEN AND MAINNET
892     // minimum time before departure for applying
893     uint constant MIN_TIME_BEFORE_DEPARTURE	= 24 hours; // for production
894     // check for delay after .. minutes after scheduled arrival
895     uint constant CHECK_PAYOUT_OFFSET = 15 minutes; // for production
896 // <-- prod-mode
897 
898 // --> test-mode
899 //        // DEFINITIONS FOR LOCAL TESTNET
900 //        // minimum time before departure for applying
901 //        uint constant MIN_TIME_BEFORE_DEPARTURE = 1 seconds; // for testing
902 //        // check for delay after .. minutes after scheduled arrival
903 //        uint constant CHECK_PAYOUT_OFFSET = 1 seconds; // for testing
904 // <-- test-mode
905 
906     // maximum duration of flight
907     uint constant MAX_FLIGHT_DURATION = 2 days;
908     // Deadline for acceptance of policies: 31.12.2030 (Testnet)
909     uint constant CONTRACT_DEAD_LINE = 1922396399;
910 
911     // gas Constants for oraclize
912     uint constant ORACLIZE_GAS = 700000;
913     uint constant ORACLIZE_GASPRICE = 4000000000;
914 
915 
916     /*
917     * URLs and query strings for oraclize
918     */
919 
920 // --> prod-mode
921     // DEFINITIONS FOR ROPSTEN AND MAINNET
922     string constant ORACLIZE_RATINGS_BASE_URL =
923         // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
924         "[URL] json(https://api.flightstats.com/flex/ratings/rest/v1/json/flight/";
925     string constant ORACLIZE_RATINGS_QUERY =
926         "?${[decrypt] BCGB+KxK9Hi0+HSuAjqUImcDiycjuUNPi8ibBGo6KFP/m9gOK6xtJbyi5lbPxPfDypCywVtTwe13VZbu02337Lw0mhTFO0OkUltmxGxi2mWgDBwN+VZdiXjtStOwuNYnhj8hjm71ppPGCVKXExvl1z3qDXkSbMMYZNBG+JNVFP7/YWhSZCXW}).ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
927     string constant ORACLIZE_STATUS_BASE_URL =
928         // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
929         "[URL] json(https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/";
930     string constant ORACLIZE_STATUS_QUERY =
931         // pattern:
932         "?${[decrypt] BKc9+sMSvpu/p3qUjdu0QrHliQpNylhoQmHqL/8mQ/jKfsf7wdIiwwdMizp5u6LoP8rIvGhRfEcjK1SgotQDGFqws/5+9S9D5OXdEPXnkEsjQZJsyu8uhRRWg/0QSSP6LYP2ONUQc92QncGJbPCDxOcf3lGiNRrhznHfjFW7n+lwz4mVxN76}&utc=true).flightStatuses[0]['status','delays','operationalTimes']";
933 // <-- prod-mode
934 
935 // --> test-mode
936 //        // DEFINITIONS FOR LOCAL TESTNET
937 //        string constant ORACLIZE_RATINGS_BASE_URL =
938 //            // ratings api is v1, see https://developer.flightstats.com/api-docs/ratings/v1
939 //            "[URL] json(https://api-test.etherisc.com/flex/ratings/rest/v1/json/flight/";
940 //        string constant ORACLIZE_RATINGS_QUERY =
941 //            // for testrpc:
942 //            ").ratings[0]['observations','late15','late30','late45','cancelled','diverted','arrivalAirportFsCode','departureAirportFsCode']";
943 //        string constant ORACLIZE_STATUS_BASE_URL =
944 //            // flight status api is v2, see https://developer.flightstats.com/api-docs/flightstatus/v2/flight
945 //            "[URL] json(https://api-test.etherisc.com/flex/flightstatus/rest/v2/json/flight/status/";
946 //        string constant ORACLIZE_STATUS_QUERY =
947 //            // for testrpc:
948 //            "?utc=true).flightStatuses[0]['status','delays','operationalTimes']";
949 // <-- test-mode
950 }
951 
952 // File: contracts/FlightDelayControllerInterface.sol
953 
954 /**
955  * FlightDelay with Oraclized Underwriting and Payout
956  *
957  * @description Contract interface
958  * @copyright (c) 2017 etherisc GmbH
959  * @author Christoph Mussenbrock, Stephan Karpischek
960  */
961 
962 pragma solidity ^0.4.11;
963 
964 
965 contract FlightDelayControllerInterface {
966 
967     function isOwner(address _addr) public returns (bool _isOwner);
968 
969     function selfRegister(bytes32 _id) public returns (bool result);
970 
971     function getContract(bytes32 _id) public returns (address _addr);
972 }
973 
974 // File: contracts/FlightDelayDatabaseModel.sol
975 
976 /**
977  * FlightDelay with Oraclized Underwriting and Payout
978  *
979  * @description Database model
980  * @copyright (c) 2017 etherisc GmbH
981  * @author Christoph Mussenbrock, Stephan Karpischek
982  */
983 
984 pragma solidity ^0.4.11;
985 
986 
987 contract FlightDelayDatabaseModel {
988 
989     // Ledger accounts.
990     enum Acc {
991         Premium,      // 0
992         RiskFund,     // 1
993         Payout,       // 2
994         Balance,      // 3
995         Reward,       // 4
996         OraclizeCosts // 5
997     }
998 
999     // policy Status Codes and meaning:
1000     //
1001     // 00 = Applied:	  the customer has payed a premium, but the oracle has
1002     //					        not yet checked and confirmed.
1003     //					        The customer can still revoke the policy.
1004     // 01 = Accepted:	  the oracle has checked and confirmed.
1005     //					        The customer can still revoke the policy.
1006     // 02 = Revoked:	  The customer has revoked the policy.
1007     //					        The premium minus cancellation fee is payed back to the
1008     //					        customer by the oracle.
1009     // 03 = PaidOut:	  The flight has ended with delay.
1010     //					        The oracle has checked and payed out.
1011     // 04 = Expired:	  The flight has endet with <15min. delay.
1012     //					        No payout.
1013     // 05 = Declined:	  The application was invalid.
1014     //					        The premium minus cancellation fee is payed back to the
1015     //					        customer by the oracle.
1016     // 06 = SendFailed:	During Revoke, Decline or Payout, sending ether failed
1017     //					        for unknown reasons.
1018     //					        The funds remain in the contracts RiskFund.
1019 
1020 
1021     //                   00       01        02       03        04      05           06
1022     enum policyState { Applied, Accepted, Revoked, PaidOut, Expired, Declined, SendFailed }
1023 
1024     // oraclize callback types:
1025     enum oraclizeState { ForUnderwriting, ForPayout }
1026 
1027     //               00   01   02   03
1028     enum Currency { ETH, EUR, USD, GBP }
1029 
1030     // the policy structure: this structure keeps track of the individual parameters of a policy.
1031     // typically customer address, premium and some status information.
1032     struct Policy {
1033         // 0 - the customer
1034         address customer;
1035 
1036         // 1 - premium
1037         uint premium;
1038         // risk specific parameters:
1039         // 2 - pointer to the risk in the risks mapping
1040         bytes32 riskId;
1041         // custom payout pattern
1042         // in future versions, customer will be able to tamper with this array.
1043         // to keep things simple, we have decided to hard-code the array for all policies.
1044         // uint8[5] pattern;
1045         // 3 - probability weight. this is the central parameter
1046         uint weight;
1047         // 4 - calculated Payout
1048         uint calculatedPayout;
1049         // 5 - actual Payout
1050         uint actualPayout;
1051 
1052         // status fields:
1053         // 6 - the state of the policy
1054         policyState state;
1055         // 7 - time of last state change
1056         uint stateTime;
1057         // 8 - state change message/reason
1058         bytes32 stateMessage;
1059         // 9 - TLSNotary Proof
1060         bytes proof;
1061         // 10 - Currency
1062         Currency currency;
1063         // 10 - External customer id
1064         bytes32 customerExternalId;
1065     }
1066 
1067     // the risk structure; this structure keeps track of the risk-
1068     // specific parameters.
1069     // several policies can share the same risk structure (typically
1070     // some people flying with the same plane)
1071     struct Risk {
1072         // 0 - Airline Code + FlightNumber
1073         bytes32 carrierFlightNumber;
1074         // 1 - scheduled departure and arrival time in the format /dep/YYYY/MM/DD
1075         bytes32 departureYearMonthDay;
1076         // 2 - the inital arrival time
1077         uint arrivalTime;
1078         // 3 - the final delay in minutes
1079         uint delayInMinutes;
1080         // 4 - the determined delay category (0-5)
1081         uint8 delay;
1082         // 5 - we limit the cumulated weighted premium to avoid cluster risks
1083         uint cumulatedWeightedPremium;
1084         // 6 - max cumulated Payout for this risk
1085         uint premiumMultiplier;
1086     }
1087 
1088     // the oraclize callback structure: we use several oraclize calls.
1089     // all oraclize calls will result in a common callback to __callback(...).
1090     // to keep track of the different querys we have to introduce this struct.
1091     struct OraclizeCallback {
1092         // for which policy have we called?
1093         uint policyId;
1094         // for which purpose did we call? {ForUnderwrite | ForPayout}
1095         oraclizeState oState;
1096         // time
1097         uint oraclizeTime;
1098     }
1099 
1100     struct Customer {
1101         bytes32 customerExternalId;
1102         bool identityConfirmed;
1103     }
1104 }
1105 
1106 // File: contracts/FlightDelayControlledContract.sol
1107 
1108 /**
1109  * FlightDelay with Oraclized Underwriting and Payout
1110  *
1111  * @description Controlled contract Interface
1112  * @copyright (c) 2017 etherisc GmbH
1113  * @author Christoph Mussenbrock
1114  */
1115 
1116 pragma solidity ^0.4.11;
1117 
1118 
1119 
1120 
1121 contract FlightDelayControlledContract is FlightDelayDatabaseModel {
1122 
1123     address public controller;
1124     FlightDelayControllerInterface FD_CI;
1125 
1126     modifier onlyController() {
1127         require(msg.sender == controller);
1128         _;
1129     }
1130 
1131     function setController(address _controller) internal returns (bool _result) {
1132         controller = _controller;
1133         FD_CI = FlightDelayControllerInterface(_controller);
1134         _result = true;
1135     }
1136 
1137     function destruct() public onlyController {
1138         selfdestruct(controller);
1139     }
1140 
1141     function setContracts() public onlyController {}
1142 
1143     function getContract(bytes32 _id) internal returns (address _addr) {
1144         _addr = FD_CI.getContract(_id);
1145     }
1146 }
1147 
1148 // File: contracts/FlightDelayDatabaseInterface.sol
1149 
1150 /**
1151  * FlightDelay with Oraclized Underwriting and Payout
1152  *
1153  * @description Database contract interface
1154  * @copyright (c) 2017 etherisc GmbH
1155  * @author Christoph Mussenbrock, Stephan Karpischek
1156  */
1157 
1158 pragma solidity ^0.4.11;
1159 
1160 
1161 
1162 contract FlightDelayDatabaseInterface is FlightDelayDatabaseModel {
1163 
1164     uint public MIN_DEPARTURE_LIM;
1165 
1166     uint public MAX_DEPARTURE_LIM;
1167 
1168     bytes32[] public validOrigins;
1169 
1170     bytes32[] public validDestinations;
1171 
1172     function countOrigins() public constant returns (uint256 _length);
1173 
1174     function getOriginByIndex(uint256 _i) public constant returns (bytes32 _origin);
1175 
1176     function countDestinations() public constant returns (uint256 _length);
1177 
1178     function getDestinationByIndex(uint256 _i) public constant returns (bytes32 _destination);
1179 
1180     function setAccessControl(address _contract, address _caller, uint8 _perm) public;
1181 
1182     function setAccessControl(
1183         address _contract,
1184         address _caller,
1185         uint8 _perm,
1186         bool _access
1187     ) public;
1188 
1189     function getAccessControl(address _contract, address _caller, uint8 _perm) public returns (bool _allowed) ;
1190 
1191     function setLedger(uint8 _index, int _value) public;
1192 
1193     function getLedger(uint8 _index) public returns (int _value) ;
1194 
1195     function getCustomerPremium(uint _policyId) public returns (address _customer, uint _premium) ;
1196 
1197     function getPolicyData(uint _policyId) public returns (address _customer, uint _weight, uint _premium);
1198 
1199     function getPolicyState(uint _policyId) public returns (policyState _state) ;
1200 
1201     function getRiskId(uint _policyId) public returns (bytes32 _riskId);
1202 
1203     function createPolicy(address _customer, uint _premium, Currency _currency, bytes32 _customerExternalId, bytes32 _riskId) public returns (uint _policyId) ;
1204 
1205     function setState(
1206         uint _policyId,
1207         policyState _state,
1208         uint _stateTime,
1209         bytes32 _stateMessage
1210     ) public;
1211 
1212     function setWeight(uint _policyId, uint _weight, bytes _proof) public;
1213 
1214     function setPayouts(uint _policyId, uint _calculatedPayout, uint _actualPayout) public;
1215 
1216     function setDelay(uint _policyId, uint8 _delay, uint _delayInMinutes) public;
1217 
1218     function getRiskParameters(bytes32 _riskId)
1219         public returns (bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime) ;
1220 
1221     function getPremiumFactors(bytes32 _riskId)
1222         public returns (uint _cumulatedWeightedPremium, uint _premiumMultiplier);
1223 
1224     function createUpdateRisk(bytes32 _carrierFlightNumber, bytes32 _departureYearMonthDay, uint _arrivalTime)
1225         public returns (bytes32 _riskId);
1226 
1227     function setPremiumFactors(bytes32 _riskId, uint _cumulatedWeightedPremium, uint _premiumMultiplier) public;
1228 
1229     function getOraclizeCallback(bytes32 _queryId)
1230         public returns (uint _policyId, uint _oraclizeTime) ;
1231 
1232     function getOraclizePolicyId(bytes32 _queryId)
1233         public returns (uint _policyId) ;
1234 
1235     function createOraclizeCallback(
1236         bytes32 _queryId,
1237         uint _policyId,
1238         oraclizeState _oraclizeState,
1239         uint _oraclizeTime
1240     ) public;
1241 
1242     function checkTime(bytes32 _queryId, bytes32 _riskId, uint _offset)
1243         public returns (bool _result) ;
1244 }
1245 
1246 // File: contracts/FlightDelayLedgerInterface.sol
1247 
1248 /**
1249  * FlightDelay with Oraclized Underwriting and Payout
1250  *
1251  * @description	Ledger contract interface
1252  * @copyright (c) 2017 etherisc GmbH
1253  * @author Christoph Mussenbrock, Stephan Karpischek
1254  */
1255 
1256 pragma solidity ^0.4.11;
1257 
1258 
1259 
1260 contract FlightDelayLedgerInterface is FlightDelayDatabaseModel {
1261 
1262     function receiveFunds(Acc _to) public payable;
1263 
1264     function sendFunds(address _recipient, Acc _from, uint _amount) public returns (bool _success);
1265 
1266     function bookkeeping(Acc _from, Acc _to, uint amount) public;
1267 }
1268 
1269 // File: vendors/usingOraclize.sol
1270 
1271 // <ORACLIZE_API>
1272 /*
1273 Copyright (c) 2015-2016 Oraclize SRL
1274 Copyright (c) 2016 Oraclize LTD
1275 
1276 
1277 
1278 Permission is hereby granted, free of charge, to any person obtaining a copy
1279 of this software and associated documentation files (the "Software"), to deal
1280 in the Software without restriction, including without limitation the rights
1281 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1282 copies of the Software, and to permit persons to whom the Software is
1283 furnished to do so, subject to the following conditions:
1284 
1285 
1286 
1287 The above copyright notice and this permission notice shall be included in
1288 all copies or substantial portions of the Software.
1289 
1290 
1291 
1292 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1293 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1294 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
1295 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1296 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1297 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
1298 THE SOFTWARE.
1299 */
1300 
1301 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
1302 
1303 contract OraclizeI {
1304     address public cbAddress;
1305     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
1306     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
1307     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
1308     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
1309     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
1310     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
1311     function getPrice(string _datasource) returns (uint _dsprice);
1312     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
1313     function useCoupon(string _coupon);
1314     function setProofType(byte _proofType);
1315     function setConfig(bytes32 _config);
1316     function setCustomGasPrice(uint _gasPrice);
1317     function randomDS_getSessionPubKeyHash() returns(bytes32);
1318 }
1319 contract OraclizeAddrResolverI {
1320     function getAddress() returns (address _addr);
1321 }
1322 contract usingOraclize {
1323     uint constant day = 60*60*24;
1324     uint constant week = 60*60*24*7;
1325     uint constant month = 60*60*24*30;
1326     byte constant proofType_NONE = 0x00;
1327     byte constant proofType_TLSNotary = 0x10;
1328     byte constant proofType_Android = 0x20;
1329     byte constant proofType_Ledger = 0x30;
1330     byte constant proofType_Native = 0xF0;
1331     byte constant proofStorage_IPFS = 0x01;
1332     uint8 constant networkID_auto = 0;
1333     uint8 constant networkID_mainnet = 1;
1334     uint8 constant networkID_testnet = 2;
1335     uint8 constant networkID_morden = 2;
1336     uint8 constant networkID_consensys = 161;
1337 
1338     OraclizeAddrResolverI OAR;
1339 
1340     OraclizeI oraclize;
1341     modifier oraclizeAPI {
1342         if((address(OAR)==0)||(getCodeSize(address(OAR))==0)) oraclize_setNetwork(networkID_auto);
1343         oraclize = OraclizeI(OAR.getAddress());
1344         _;
1345     }
1346     modifier coupon(string code){
1347         oraclize = OraclizeI(OAR.getAddress());
1348         oraclize.useCoupon(code);
1349         _;
1350     }
1351 
1352     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1353         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1354             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1355             oraclize_setNetworkName("eth_mainnet");
1356             return true;
1357         }
1358         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1359             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1360             oraclize_setNetworkName("eth_ropsten3");
1361             return true;
1362         }
1363         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1364             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1365             oraclize_setNetworkName("eth_kovan");
1366             return true;
1367         }
1368         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1369             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1370             oraclize_setNetworkName("eth_rinkeby");
1371             return true;
1372         }
1373         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1374             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1375             return true;
1376         }
1377         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1378             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1379             return true;
1380         }
1381         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1382             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1383             return true;
1384         }
1385         return false;
1386     }
1387 
1388     function __callback(bytes32 myid, string result) {
1389         __callback(myid, result, new bytes(0));
1390     }
1391     function __callback(bytes32 myid, string result, bytes proof) {
1392     }
1393 
1394     function oraclize_useCoupon(string code) oraclizeAPI internal {
1395         oraclize.useCoupon(code);
1396     }
1397 
1398     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1399         return oraclize.getPrice(datasource);
1400     }
1401 
1402     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1403         return oraclize.getPrice(datasource, gaslimit);
1404     }
1405 
1406     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1407         uint price = oraclize.getPrice(datasource);
1408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1409         return oraclize.query.value(price)(0, datasource, arg);
1410     }
1411     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1412         uint price = oraclize.getPrice(datasource);
1413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1414         return oraclize.query.value(price)(timestamp, datasource, arg);
1415     }
1416     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1417         uint price = oraclize.getPrice(datasource, gaslimit);
1418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1419         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1420     }
1421     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1422         uint price = oraclize.getPrice(datasource, gaslimit);
1423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1424         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1425     }
1426     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1427         uint price = oraclize.getPrice(datasource);
1428         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1429         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1430     }
1431     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1432         uint price = oraclize.getPrice(datasource);
1433         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1434         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1435     }
1436     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1437         uint price = oraclize.getPrice(datasource, gaslimit);
1438         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1439         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1440     }
1441     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1442         uint price = oraclize.getPrice(datasource, gaslimit);
1443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1444         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1445     }
1446     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1447         uint price = oraclize.getPrice(datasource);
1448         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1449         bytes memory args = stra2cbor(argN);
1450         return oraclize.queryN.value(price)(0, datasource, args);
1451     }
1452     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1453         uint price = oraclize.getPrice(datasource);
1454         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1455         bytes memory args = stra2cbor(argN);
1456         return oraclize.queryN.value(price)(timestamp, datasource, args);
1457     }
1458     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1459         uint price = oraclize.getPrice(datasource, gaslimit);
1460         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1461         bytes memory args = stra2cbor(argN);
1462         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1463     }
1464     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1465         uint price = oraclize.getPrice(datasource, gaslimit);
1466         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1467         bytes memory args = stra2cbor(argN);
1468         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1469     }
1470     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1471         string[] memory dynargs = new string[](1);
1472         dynargs[0] = args[0];
1473         return oraclize_query(datasource, dynargs);
1474     }
1475     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1476         string[] memory dynargs = new string[](1);
1477         dynargs[0] = args[0];
1478         return oraclize_query(timestamp, datasource, dynargs);
1479     }
1480     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1481         string[] memory dynargs = new string[](1);
1482         dynargs[0] = args[0];
1483         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1484     }
1485     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1486         string[] memory dynargs = new string[](1);
1487         dynargs[0] = args[0];
1488         return oraclize_query(datasource, dynargs, gaslimit);
1489     }
1490 
1491     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1492         string[] memory dynargs = new string[](2);
1493         dynargs[0] = args[0];
1494         dynargs[1] = args[1];
1495         return oraclize_query(datasource, dynargs);
1496     }
1497     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1498         string[] memory dynargs = new string[](2);
1499         dynargs[0] = args[0];
1500         dynargs[1] = args[1];
1501         return oraclize_query(timestamp, datasource, dynargs);
1502     }
1503     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1504         string[] memory dynargs = new string[](2);
1505         dynargs[0] = args[0];
1506         dynargs[1] = args[1];
1507         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1508     }
1509     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1510         string[] memory dynargs = new string[](2);
1511         dynargs[0] = args[0];
1512         dynargs[1] = args[1];
1513         return oraclize_query(datasource, dynargs, gaslimit);
1514     }
1515     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1516         string[] memory dynargs = new string[](3);
1517         dynargs[0] = args[0];
1518         dynargs[1] = args[1];
1519         dynargs[2] = args[2];
1520         return oraclize_query(datasource, dynargs);
1521     }
1522     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1523         string[] memory dynargs = new string[](3);
1524         dynargs[0] = args[0];
1525         dynargs[1] = args[1];
1526         dynargs[2] = args[2];
1527         return oraclize_query(timestamp, datasource, dynargs);
1528     }
1529     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1530         string[] memory dynargs = new string[](3);
1531         dynargs[0] = args[0];
1532         dynargs[1] = args[1];
1533         dynargs[2] = args[2];
1534         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1535     }
1536     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1537         string[] memory dynargs = new string[](3);
1538         dynargs[0] = args[0];
1539         dynargs[1] = args[1];
1540         dynargs[2] = args[2];
1541         return oraclize_query(datasource, dynargs, gaslimit);
1542     }
1543 
1544     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1545         string[] memory dynargs = new string[](4);
1546         dynargs[0] = args[0];
1547         dynargs[1] = args[1];
1548         dynargs[2] = args[2];
1549         dynargs[3] = args[3];
1550         return oraclize_query(datasource, dynargs);
1551     }
1552     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1553         string[] memory dynargs = new string[](4);
1554         dynargs[0] = args[0];
1555         dynargs[1] = args[1];
1556         dynargs[2] = args[2];
1557         dynargs[3] = args[3];
1558         return oraclize_query(timestamp, datasource, dynargs);
1559     }
1560     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1561         string[] memory dynargs = new string[](4);
1562         dynargs[0] = args[0];
1563         dynargs[1] = args[1];
1564         dynargs[2] = args[2];
1565         dynargs[3] = args[3];
1566         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1567     }
1568     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1569         string[] memory dynargs = new string[](4);
1570         dynargs[0] = args[0];
1571         dynargs[1] = args[1];
1572         dynargs[2] = args[2];
1573         dynargs[3] = args[3];
1574         return oraclize_query(datasource, dynargs, gaslimit);
1575     }
1576     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1577         string[] memory dynargs = new string[](5);
1578         dynargs[0] = args[0];
1579         dynargs[1] = args[1];
1580         dynargs[2] = args[2];
1581         dynargs[3] = args[3];
1582         dynargs[4] = args[4];
1583         return oraclize_query(datasource, dynargs);
1584     }
1585     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1586         string[] memory dynargs = new string[](5);
1587         dynargs[0] = args[0];
1588         dynargs[1] = args[1];
1589         dynargs[2] = args[2];
1590         dynargs[3] = args[3];
1591         dynargs[4] = args[4];
1592         return oraclize_query(timestamp, datasource, dynargs);
1593     }
1594     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1595         string[] memory dynargs = new string[](5);
1596         dynargs[0] = args[0];
1597         dynargs[1] = args[1];
1598         dynargs[2] = args[2];
1599         dynargs[3] = args[3];
1600         dynargs[4] = args[4];
1601         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1602     }
1603     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1604         string[] memory dynargs = new string[](5);
1605         dynargs[0] = args[0];
1606         dynargs[1] = args[1];
1607         dynargs[2] = args[2];
1608         dynargs[3] = args[3];
1609         dynargs[4] = args[4];
1610         return oraclize_query(datasource, dynargs, gaslimit);
1611     }
1612     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1613         uint price = oraclize.getPrice(datasource);
1614         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1615         bytes memory args = ba2cbor(argN);
1616         return oraclize.queryN.value(price)(0, datasource, args);
1617     }
1618     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1619         uint price = oraclize.getPrice(datasource);
1620         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1621         bytes memory args = ba2cbor(argN);
1622         return oraclize.queryN.value(price)(timestamp, datasource, args);
1623     }
1624     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1625         uint price = oraclize.getPrice(datasource, gaslimit);
1626         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1627         bytes memory args = ba2cbor(argN);
1628         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1629     }
1630     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1631         uint price = oraclize.getPrice(datasource, gaslimit);
1632         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1633         bytes memory args = ba2cbor(argN);
1634         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1635     }
1636     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1637         bytes[] memory dynargs = new bytes[](1);
1638         dynargs[0] = args[0];
1639         return oraclize_query(datasource, dynargs);
1640     }
1641     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1642         bytes[] memory dynargs = new bytes[](1);
1643         dynargs[0] = args[0];
1644         return oraclize_query(timestamp, datasource, dynargs);
1645     }
1646     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1647         bytes[] memory dynargs = new bytes[](1);
1648         dynargs[0] = args[0];
1649         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1650     }
1651     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1652         bytes[] memory dynargs = new bytes[](1);
1653         dynargs[0] = args[0];
1654         return oraclize_query(datasource, dynargs, gaslimit);
1655     }
1656 
1657     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1658         bytes[] memory dynargs = new bytes[](2);
1659         dynargs[0] = args[0];
1660         dynargs[1] = args[1];
1661         return oraclize_query(datasource, dynargs);
1662     }
1663     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1664         bytes[] memory dynargs = new bytes[](2);
1665         dynargs[0] = args[0];
1666         dynargs[1] = args[1];
1667         return oraclize_query(timestamp, datasource, dynargs);
1668     }
1669     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1670         bytes[] memory dynargs = new bytes[](2);
1671         dynargs[0] = args[0];
1672         dynargs[1] = args[1];
1673         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1674     }
1675     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1676         bytes[] memory dynargs = new bytes[](2);
1677         dynargs[0] = args[0];
1678         dynargs[1] = args[1];
1679         return oraclize_query(datasource, dynargs, gaslimit);
1680     }
1681     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1682         bytes[] memory dynargs = new bytes[](3);
1683         dynargs[0] = args[0];
1684         dynargs[1] = args[1];
1685         dynargs[2] = args[2];
1686         return oraclize_query(datasource, dynargs);
1687     }
1688     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1689         bytes[] memory dynargs = new bytes[](3);
1690         dynargs[0] = args[0];
1691         dynargs[1] = args[1];
1692         dynargs[2] = args[2];
1693         return oraclize_query(timestamp, datasource, dynargs);
1694     }
1695     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1696         bytes[] memory dynargs = new bytes[](3);
1697         dynargs[0] = args[0];
1698         dynargs[1] = args[1];
1699         dynargs[2] = args[2];
1700         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1701     }
1702     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1703         bytes[] memory dynargs = new bytes[](3);
1704         dynargs[0] = args[0];
1705         dynargs[1] = args[1];
1706         dynargs[2] = args[2];
1707         return oraclize_query(datasource, dynargs, gaslimit);
1708     }
1709 
1710     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1711         bytes[] memory dynargs = new bytes[](4);
1712         dynargs[0] = args[0];
1713         dynargs[1] = args[1];
1714         dynargs[2] = args[2];
1715         dynargs[3] = args[3];
1716         return oraclize_query(datasource, dynargs);
1717     }
1718     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1719         bytes[] memory dynargs = new bytes[](4);
1720         dynargs[0] = args[0];
1721         dynargs[1] = args[1];
1722         dynargs[2] = args[2];
1723         dynargs[3] = args[3];
1724         return oraclize_query(timestamp, datasource, dynargs);
1725     }
1726     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1727         bytes[] memory dynargs = new bytes[](4);
1728         dynargs[0] = args[0];
1729         dynargs[1] = args[1];
1730         dynargs[2] = args[2];
1731         dynargs[3] = args[3];
1732         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1733     }
1734     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1735         bytes[] memory dynargs = new bytes[](4);
1736         dynargs[0] = args[0];
1737         dynargs[1] = args[1];
1738         dynargs[2] = args[2];
1739         dynargs[3] = args[3];
1740         return oraclize_query(datasource, dynargs, gaslimit);
1741     }
1742     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1743         bytes[] memory dynargs = new bytes[](5);
1744         dynargs[0] = args[0];
1745         dynargs[1] = args[1];
1746         dynargs[2] = args[2];
1747         dynargs[3] = args[3];
1748         dynargs[4] = args[4];
1749         return oraclize_query(datasource, dynargs);
1750     }
1751     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1752         bytes[] memory dynargs = new bytes[](5);
1753         dynargs[0] = args[0];
1754         dynargs[1] = args[1];
1755         dynargs[2] = args[2];
1756         dynargs[3] = args[3];
1757         dynargs[4] = args[4];
1758         return oraclize_query(timestamp, datasource, dynargs);
1759     }
1760     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1761         bytes[] memory dynargs = new bytes[](5);
1762         dynargs[0] = args[0];
1763         dynargs[1] = args[1];
1764         dynargs[2] = args[2];
1765         dynargs[3] = args[3];
1766         dynargs[4] = args[4];
1767         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1768     }
1769     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1770         bytes[] memory dynargs = new bytes[](5);
1771         dynargs[0] = args[0];
1772         dynargs[1] = args[1];
1773         dynargs[2] = args[2];
1774         dynargs[3] = args[3];
1775         dynargs[4] = args[4];
1776         return oraclize_query(datasource, dynargs, gaslimit);
1777     }
1778 
1779     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1780         return oraclize.cbAddress();
1781     }
1782     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1783         return oraclize.setProofType(proofP);
1784     }
1785     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1786         return oraclize.setCustomGasPrice(gasPrice);
1787     }
1788     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1789         return oraclize.setConfig(config);
1790     }
1791 
1792     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1793         return oraclize.randomDS_getSessionPubKeyHash();
1794     }
1795 
1796     function getCodeSize(address _addr) constant internal returns(uint _size) {
1797         assembly {
1798             _size := extcodesize(_addr)
1799         }
1800     }
1801 
1802     function parseAddr(string _a) internal returns (address){
1803         bytes memory tmp = bytes(_a);
1804         uint160 iaddr = 0;
1805         uint160 b1;
1806         uint160 b2;
1807         for (uint i=2; i<2+2*20; i+=2){
1808             iaddr *= 256;
1809             b1 = uint160(tmp[i]);
1810             b2 = uint160(tmp[i+1]);
1811             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1812             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1813             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1814             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1815             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1816             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1817             iaddr += (b1*16+b2);
1818         }
1819         return address(iaddr);
1820     }
1821 
1822     function strCompare(string _a, string _b) internal returns (int) {
1823         bytes memory a = bytes(_a);
1824         bytes memory b = bytes(_b);
1825         uint minLength = a.length;
1826         if (b.length < minLength) minLength = b.length;
1827         for (uint i = 0; i < minLength; i ++)
1828             if (a[i] < b[i])
1829                 return -1;
1830             else if (a[i] > b[i])
1831                 return 1;
1832         if (a.length < b.length)
1833             return -1;
1834         else if (a.length > b.length)
1835             return 1;
1836         else
1837             return 0;
1838     }
1839 
1840     function indexOf(string _haystack, string _needle) internal returns (int) {
1841         bytes memory h = bytes(_haystack);
1842         bytes memory n = bytes(_needle);
1843         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1844             return -1;
1845         else if(h.length > (2**128 -1))
1846             return -1;
1847         else
1848         {
1849             uint subindex = 0;
1850             for (uint i = 0; i < h.length; i ++)
1851             {
1852                 if (h[i] == n[0])
1853                 {
1854                     subindex = 1;
1855                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1856                     {
1857                         subindex++;
1858                     }
1859                     if(subindex == n.length)
1860                         return int(i);
1861                 }
1862             }
1863             return -1;
1864         }
1865     }
1866 
1867     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1868         bytes memory _ba = bytes(_a);
1869         bytes memory _bb = bytes(_b);
1870         bytes memory _bc = bytes(_c);
1871         bytes memory _bd = bytes(_d);
1872         bytes memory _be = bytes(_e);
1873         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1874         bytes memory babcde = bytes(abcde);
1875         uint k = 0;
1876         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1877         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1878         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1879         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1880         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1881         return string(babcde);
1882     }
1883 
1884     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1885         return strConcat(_a, _b, _c, _d, "");
1886     }
1887 
1888     function strConcat(string _a, string _b, string _c) internal returns (string) {
1889         return strConcat(_a, _b, _c, "", "");
1890     }
1891 
1892     function strConcat(string _a, string _b) internal returns (string) {
1893         return strConcat(_a, _b, "", "", "");
1894     }
1895 
1896     // parseInt
1897     function parseInt(string _a) internal returns (uint) {
1898         return parseInt(_a, 0);
1899     }
1900 
1901     // parseInt(parseFloat*10^_b)
1902     function parseInt(string _a, uint _b) internal returns (uint) {
1903         bytes memory bresult = bytes(_a);
1904         uint mint = 0;
1905         bool decimals = false;
1906         for (uint i=0; i<bresult.length; i++){
1907             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1908                 if (decimals){
1909                    if (_b == 0) break;
1910                     else _b--;
1911                 }
1912                 mint *= 10;
1913                 mint += uint(bresult[i]) - 48;
1914             } else if (bresult[i] == 46) decimals = true;
1915         }
1916         if (_b > 0) mint *= 10**_b;
1917         return mint;
1918     }
1919 
1920     function uint2str(uint i) internal returns (string){
1921         if (i == 0) return "0";
1922         uint j = i;
1923         uint len;
1924         while (j != 0){
1925             len++;
1926             j /= 10;
1927         }
1928         bytes memory bstr = new bytes(len);
1929         uint k = len - 1;
1930         while (i != 0){
1931             bstr[k--] = byte(48 + i % 10);
1932             i /= 10;
1933         }
1934         return string(bstr);
1935     }
1936 
1937     function stra2cbor(string[] arr) internal returns (bytes) {
1938             uint arrlen = arr.length;
1939 
1940             // get correct cbor output length
1941             uint outputlen = 0;
1942             bytes[] memory elemArray = new bytes[](arrlen);
1943             for (uint i = 0; i < arrlen; i++) {
1944                 elemArray[i] = (bytes(arr[i]));
1945                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1946             }
1947             uint ctr = 0;
1948             uint cborlen = arrlen + 0x80;
1949             outputlen += byte(cborlen).length;
1950             bytes memory res = new bytes(outputlen);
1951 
1952             while (byte(cborlen).length > ctr) {
1953                 res[ctr] = byte(cborlen)[ctr];
1954                 ctr++;
1955             }
1956             for (i = 0; i < arrlen; i++) {
1957                 res[ctr] = 0x5F;
1958                 ctr++;
1959                 for (uint x = 0; x < elemArray[i].length; x++) {
1960                     // if there's a bug with larger strings, this may be the culprit
1961                     if (x % 23 == 0) {
1962                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1963                         elemcborlen += 0x40;
1964                         uint lctr = ctr;
1965                         while (byte(elemcborlen).length > ctr - lctr) {
1966                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1967                             ctr++;
1968                         }
1969                     }
1970                     res[ctr] = elemArray[i][x];
1971                     ctr++;
1972                 }
1973                 res[ctr] = 0xFF;
1974                 ctr++;
1975             }
1976             return res;
1977         }
1978 
1979     function ba2cbor(bytes[] arr) internal returns (bytes) {
1980             uint arrlen = arr.length;
1981 
1982             // get correct cbor output length
1983             uint outputlen = 0;
1984             bytes[] memory elemArray = new bytes[](arrlen);
1985             for (uint i = 0; i < arrlen; i++) {
1986                 elemArray[i] = (bytes(arr[i]));
1987                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1988             }
1989             uint ctr = 0;
1990             uint cborlen = arrlen + 0x80;
1991             outputlen += byte(cborlen).length;
1992             bytes memory res = new bytes(outputlen);
1993 
1994             while (byte(cborlen).length > ctr) {
1995                 res[ctr] = byte(cborlen)[ctr];
1996                 ctr++;
1997             }
1998             for (i = 0; i < arrlen; i++) {
1999                 res[ctr] = 0x5F;
2000                 ctr++;
2001                 for (uint x = 0; x < elemArray[i].length; x++) {
2002                     // if there's a bug with larger strings, this may be the culprit
2003                     if (x % 23 == 0) {
2004                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
2005                         elemcborlen += 0x40;
2006                         uint lctr = ctr;
2007                         while (byte(elemcborlen).length > ctr - lctr) {
2008                             res[ctr] = byte(elemcborlen)[ctr - lctr];
2009                             ctr++;
2010                         }
2011                     }
2012                     res[ctr] = elemArray[i][x];
2013                     ctr++;
2014                 }
2015                 res[ctr] = 0xFF;
2016                 ctr++;
2017             }
2018             return res;
2019         }
2020 
2021 
2022     string oraclize_network_name;
2023     function oraclize_setNetworkName(string _network_name) internal {
2024         oraclize_network_name = _network_name;
2025     }
2026 
2027     function oraclize_getNetworkName() internal returns (string) {
2028         return oraclize_network_name;
2029     }
2030 
2031     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
2032         if ((_nbytes == 0)||(_nbytes > 32)) throw;
2033         bytes memory nbytes = new bytes(1);
2034         nbytes[0] = byte(_nbytes);
2035         bytes memory unonce = new bytes(32);
2036         bytes memory sessionKeyHash = new bytes(32);
2037         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
2038         assembly {
2039             mstore(unonce, 0x20)
2040             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
2041             mstore(sessionKeyHash, 0x20)
2042             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
2043         }
2044         bytes[3] memory args = [unonce, nbytes, sessionKeyHash];
2045         bytes32 queryId = oraclize_query(_delay, "random", args, _customGasLimit);
2046         oraclize_randomDS_setCommitment(queryId, sha3(bytes8(_delay), args[1], sha256(args[0]), args[2]));
2047         return queryId;
2048     }
2049 
2050     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
2051         oraclize_randomDS_args[queryId] = commitment;
2052     }
2053 
2054     mapping(bytes32=>bytes32) oraclize_randomDS_args;
2055     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
2056 
2057     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
2058         bool sigok;
2059         address signer;
2060 
2061         bytes32 sigr;
2062         bytes32 sigs;
2063 
2064         bytes memory sigr_ = new bytes(32);
2065         uint offset = 4+(uint(dersig[3]) - 0x20);
2066         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
2067         bytes memory sigs_ = new bytes(32);
2068         offset += 32 + 2;
2069         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
2070 
2071         assembly {
2072             sigr := mload(add(sigr_, 32))
2073             sigs := mload(add(sigs_, 32))
2074         }
2075 
2076 
2077         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
2078         if (address(sha3(pubkey)) == signer) return true;
2079         else {
2080             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
2081             return (address(sha3(pubkey)) == signer);
2082         }
2083     }
2084 
2085     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
2086         bool sigok;
2087 
2088         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
2089         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
2090         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
2091 
2092         bytes memory appkey1_pubkey = new bytes(64);
2093         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
2094 
2095         bytes memory tosign2 = new bytes(1+65+32);
2096         tosign2[0] = 1; //role
2097         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
2098         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
2099         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
2100         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
2101 
2102         if (sigok == false) return false;
2103 
2104 
2105         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
2106         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
2107 
2108         bytes memory tosign3 = new bytes(1+65);
2109         tosign3[0] = 0xFE;
2110         copyBytes(proof, 3, 65, tosign3, 1);
2111 
2112         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
2113         copyBytes(proof, 3+65, sig3.length, sig3, 0);
2114 
2115         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2116 
2117         return sigok;
2118     }
2119 
2120     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
2121         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2122         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
2123 
2124         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2125         if (proofVerified == false) throw;
2126 
2127         _;
2128     }
2129 
2130     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
2131         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2132         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
2133 
2134         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2135         if (proofVerified == false) return 2;
2136 
2137         return 0;
2138     }
2139 
2140     function matchBytes32Prefix(bytes32 content, bytes prefix) internal returns (bool){
2141         bool match_ = true;
2142 
2143         for (var i=0; i<prefix.length; i++){
2144             if (content[i] != prefix[i]) match_ = false;
2145         }
2146 
2147         return match_;
2148     }
2149 
2150     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
2151         bool checkok;
2152 
2153 
2154         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
2155         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
2156         bytes memory keyhash = new bytes(32);
2157         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
2158         checkok = (sha3(keyhash) == sha3(sha256(context_name, queryId)));
2159         if (checkok == false) return false;
2160 
2161         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
2162         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
2163 
2164 
2165         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
2166         checkok = matchBytes32Prefix(sha256(sig1), result);
2167         if (checkok == false) return false;
2168 
2169 
2170         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2171         // This is to verify that the computed args match with the ones specified in the query.
2172         bytes memory commitmentSlice1 = new bytes(8+1+32);
2173         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
2174 
2175         bytes memory sessionPubkey = new bytes(64);
2176         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
2177         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
2178 
2179         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2180         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
2181             delete oraclize_randomDS_args[queryId];
2182         } else return false;
2183 
2184 
2185         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
2186         bytes memory tosign1 = new bytes(32+8+1+32);
2187         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
2188         checkok = verifySig(sha256(tosign1), sig1, sessionPubkey);
2189         if (checkok == false) return false;
2190 
2191         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
2192         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
2193             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
2194         }
2195 
2196         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2197     }
2198 
2199 
2200     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2201     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
2202         uint minLength = length + toOffset;
2203 
2204         if (to.length < minLength) {
2205             // Buffer too small
2206             throw; // Should be a better way?
2207         }
2208 
2209         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2210         uint i = 32 + fromOffset;
2211         uint j = 32 + toOffset;
2212 
2213         while (i < (32 + fromOffset + length)) {
2214             assembly {
2215                 let tmp := mload(add(from, i))
2216                 mstore(add(to, j), tmp)
2217             }
2218             i += 32;
2219             j += 32;
2220         }
2221 
2222         return to;
2223     }
2224 
2225     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2226     // Duplicate Solidity's ecrecover, but catching the CALL return value
2227     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
2228         // We do our own memory management here. Solidity uses memory offset
2229         // 0x40 to store the current end of memory. We write past it (as
2230         // writes are memory extensions), but don't update the offset so
2231         // Solidity will reuse it. The memory used here is only needed for
2232         // this context.
2233 
2234         // FIXME: inline assembly can't access return values
2235         bool ret;
2236         address addr;
2237 
2238         assembly {
2239             let size := mload(0x40)
2240             mstore(size, hash)
2241             mstore(add(size, 32), v)
2242             mstore(add(size, 64), r)
2243             mstore(add(size, 96), s)
2244 
2245             // NOTE: we can reuse the request memory because we deal with
2246             //       the return code
2247             ret := call(3000, 1, 0, size, 128, size, 32)
2248             addr := mload(size)
2249         }
2250 
2251         return (ret, addr);
2252     }
2253 
2254     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2255     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2256         bytes32 r;
2257         bytes32 s;
2258         uint8 v;
2259 
2260         if (sig.length != 65)
2261           return (false, 0);
2262 
2263         // The signature format is a compact form of:
2264         //   {bytes32 r}{bytes32 s}{uint8 v}
2265         // Compact means, uint8 is not padded to 32 bytes.
2266         assembly {
2267             r := mload(add(sig, 32))
2268             s := mload(add(sig, 64))
2269 
2270             // Here we are loading the last 32 bytes. We exploit the fact that
2271             // 'mload' will pad with zeroes if we overread.
2272             // There is no 'mload8' to do this, but that would be nicer.
2273             v := byte(0, mload(add(sig, 96)))
2274 
2275             // Alternative solution:
2276             // 'byte' is not working due to the Solidity parser, so lets
2277             // use the second best option, 'and'
2278             // v := and(mload(add(sig, 65)), 255)
2279         }
2280 
2281         // albeit non-transactional signatures are not specified by the YP, one would expect it
2282         // to match the YP range of [27, 28]
2283         //
2284         // geth uses [0, 1] and some clients have followed. This might change, see:
2285         //  https://github.com/ethereum/go-ethereum/issues/2053
2286         if (v < 27)
2287           v += 27;
2288 
2289         if (v != 27 && v != 28)
2290             return (false, 0);
2291 
2292         return safer_ecrecover(hash, v, r, s);
2293     }
2294 
2295 }
2296 // </ORACLIZE_API>
2297 
2298 // File: contracts/FlightDelayOraclizeInterface.sol
2299 
2300 /**
2301  * FlightDelay with Oraclized Underwriting and Payout
2302  *
2303  * @description	Ocaclize API interface
2304  * @copyright (c) 2017 etherisc GmbH
2305  * @author Christoph Mussenbrock, Stephan Karpischek
2306  */
2307 
2308 pragma solidity ^0.4.11;
2309 
2310 
2311 
2312 contract FlightDelayOraclizeInterface is usingOraclize {
2313 
2314     modifier onlyOraclizeOr (address _emergency) {
2315 // --> prod-mode
2316         require(msg.sender == oraclize_cbAddress() || msg.sender == _emergency);
2317 // <-- prod-mode
2318         _;
2319     }
2320 }
2321 
2322 // File: contracts/FlightDelayPayoutInterface.sol
2323 
2324 /**
2325  * FlightDelay with Oraclized Underwriting and Payout
2326  *
2327  * @description	Payout contract interface
2328  * @copyright (c) 2017 etherisc GmbH
2329  * @author Christoph Mussenbrock, Stephan Karpischek
2330  */
2331 
2332 pragma solidity ^0.4.11;
2333 
2334 
2335 contract FlightDelayPayoutInterface {
2336 
2337     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _offset) public;
2338 }
2339 
2340 // File: contracts/convertLib.sol
2341 
2342 /**
2343  * FlightDelay with Oraclized Underwriting and Payout
2344  *
2345  * @description	Conversions
2346  * @copyright (c) 2017 etherisc GmbH
2347  * @author Christoph Mussenbrock
2348  */
2349 
2350 pragma solidity ^0.4.11;
2351 
2352 
2353 contract ConvertLib {
2354 
2355     // .. since beginning of the year
2356     uint16[12] days_since = [
2357         11,
2358         42,
2359         70,
2360         101,
2361         131,
2362         162,
2363         192,
2364         223,
2365         254,
2366         284,
2367         315,
2368         345
2369     ];
2370 
2371     function b32toString(bytes32 x) internal returns (string) {
2372         // gas usage: about 1K gas per char.
2373         bytes memory bytesString = new bytes(32);
2374         uint charCount = 0;
2375 
2376         for (uint j = 0; j < 32; j++) {
2377             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
2378             if (char != 0) {
2379                 bytesString[charCount] = char;
2380                 charCount++;
2381             }
2382         }
2383 
2384         bytes memory bytesStringTrimmed = new bytes(charCount);
2385 
2386         for (j = 0; j < charCount; j++) {
2387             bytesStringTrimmed[j] = bytesString[j];
2388         }
2389 
2390         return string(bytesStringTrimmed);
2391     }
2392 
2393     function b32toHexString(bytes32 x) returns (string) {
2394         bytes memory b = new bytes(64);
2395         for (uint i = 0; i < 32; i++) {
2396             uint8 by = uint8(uint(x) / (2**(8*(31 - i))));
2397             uint8 high = by/16;
2398             uint8 low = by - 16*high;
2399             if (high > 9) {
2400                 high += 39;
2401             }
2402             if (low > 9) {
2403                 low += 39;
2404             }
2405             b[2*i] = byte(high+48);
2406             b[2*i+1] = byte(low+48);
2407         }
2408 
2409         return string(b);
2410     }
2411 
2412     function parseInt(string _a) internal returns (uint) {
2413         return parseInt(_a, 0);
2414     }
2415 
2416     // parseInt(parseFloat*10^_b)
2417     function parseInt(string _a, uint _b) internal returns (uint) {
2418         bytes memory bresult = bytes(_a);
2419         uint mint = 0;
2420         bool decimals = false;
2421         for (uint i = 0; i<bresult.length; i++) {
2422             if ((bresult[i] >= 48)&&(bresult[i] <= 57)) {
2423                 if (decimals) {
2424                     if (_b == 0) {
2425                         break;
2426                     } else {
2427                         _b--;
2428                     }
2429                 }
2430                 mint *= 10;
2431                 mint += uint(bresult[i]) - 48;
2432             } else if (bresult[i] == 46) {
2433                 decimals = true;
2434             }
2435         }
2436         if (_b > 0) {
2437             mint *= 10**_b;
2438         }
2439         return mint;
2440     }
2441 
2442     // the following function yields correct results in the time between 1.3.2016 and 28.02.2020,
2443     // so within the validity of the contract its correct.
2444     function toUnixtime(bytes32 _dayMonthYear) constant returns (uint unixtime) {
2445         // _day_month_year = /dep/2016/09/10
2446         bytes memory bDmy = bytes(b32toString(_dayMonthYear));
2447         bytes memory temp2 = bytes(new string(2));
2448         bytes memory temp4 = bytes(new string(4));
2449 
2450         temp4[0] = bDmy[5];
2451         temp4[1] = bDmy[6];
2452         temp4[2] = bDmy[7];
2453         temp4[3] = bDmy[8];
2454         uint year = parseInt(string(temp4));
2455 
2456         temp2[0] = bDmy[10];
2457         temp2[1] = bDmy[11];
2458         uint month = parseInt(string(temp2));
2459 
2460         temp2[0] = bDmy[13];
2461         temp2[1] = bDmy[14];
2462         uint day = parseInt(string(temp2));
2463 
2464         unixtime = ((year - 1970) * 365 + days_since[month-1] + day) * 86400;
2465     }
2466 }
2467 
2468 // File: contracts/FlightDelayPayout.sol
2469 
2470 /**
2471  * FlightDelay with Oraclized Underwriting and Payout
2472  *
2473  * @description	Payout contract
2474  * @copyright (c) 2017 etherisc GmbH
2475  * @author Christoph Mussenbrock
2476  */
2477 
2478 pragma solidity ^0.4.11;
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
2489 
2490 contract FlightDelayPayout is FlightDelayControlledContract, FlightDelayConstants, FlightDelayOraclizeInterface, ConvertLib {
2491 
2492     using strings for *;
2493 
2494     FlightDelayDatabaseInterface FD_DB;
2495     FlightDelayLedgerInterface FD_LG;
2496     FlightDelayAccessControllerInterface FD_AC;
2497 
2498     /*
2499      * @dev Contract constructor sets its controller
2500      * @param _controller FD.Controller
2501      */
2502     function FlightDelayPayout(address _controller) public {
2503         setController(_controller);
2504         oraclize_setCustomGasPrice(ORACLIZE_GASPRICE);
2505     }
2506 
2507     /*
2508      * Public methods
2509      */
2510 
2511     /*
2512      * @dev Set access permissions for methods
2513      */
2514     function setContracts() public onlyController {
2515         FD_AC = FlightDelayAccessControllerInterface(getContract("FD.AccessController"));
2516         FD_DB = FlightDelayDatabaseInterface(getContract("FD.Database"));
2517         FD_LG = FlightDelayLedgerInterface(getContract("FD.Ledger"));
2518 
2519         FD_AC.setPermissionById(101, "FD.Underwrite");
2520         FD_AC.setPermissionByAddress(101, oraclize_cbAddress());
2521         FD_AC.setPermissionById(102, "FD.Funder");
2522         FD_AC.setPermissionById(103, "FD.Owner");
2523     }
2524 
2525     /*
2526      * @dev Fund contract
2527      */
2528     function () public payable {
2529         require(FD_AC.checkPermission(102, msg.sender));
2530 
2531         // todo: bookkeeping
2532         // todo: fire funding event
2533     }
2534 
2535     /*
2536      * @dev Schedule oraclize call for payout
2537      * @param _policyId
2538      * @param _riskId
2539      * @param _oraclizeTime
2540      */
2541     function schedulePayoutOraclizeCall(uint _policyId, bytes32 _riskId, uint _oraclizeTime) public {
2542         require(FD_AC.checkPermission(101, msg.sender));
2543 
2544         var (carrierFlightNumber, departureYearMonthDay,) = FD_DB.getRiskParameters(_riskId);
2545 
2546         string memory oraclizeUrl = strConcat(
2547             ORACLIZE_STATUS_BASE_URL,
2548             b32toString(carrierFlightNumber),
2549             b32toString(departureYearMonthDay),
2550             ORACLIZE_STATUS_QUERY
2551         );
2552 
2553         bytes32 queryId = oraclize_query(
2554             _oraclizeTime,
2555             "nested",
2556             oraclizeUrl,
2557             ORACLIZE_GAS
2558         );
2559 
2560         FD_DB.createOraclizeCallback(
2561             queryId,
2562             _policyId,
2563             oraclizeState.ForPayout,
2564             _oraclizeTime
2565         );
2566 
2567         LogOraclizeCall(_policyId, queryId, oraclizeUrl, _oraclizeTime);
2568     }
2569 
2570     /*
2571      * @dev Oraclize callback. In an emergency case, we can call this directly from FD.Emergency Account.
2572      * @param _queryId
2573      * @param _result
2574      * @param _proof
2575      */
2576     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclizeOr(getContract('FD.Emergency')) {
2577 
2578         var (policyId, oraclizeTime) = FD_DB.getOraclizeCallback(_queryId);
2579         LogOraclizeCallback(policyId, _queryId, _result, _proof);
2580 
2581         // check if policy was declined after this callback was scheduled
2582         var state = FD_DB.getPolicyState(policyId);
2583         require(uint8(state) != 5);
2584 
2585         bytes32 riskId = FD_DB.getRiskId(policyId);
2586 
2587 // --> debug-mode
2588 //            LogBytes32("riskId", riskId);
2589 // <-- debug-mode
2590 
2591         var slResult = _result.toSlice();
2592 
2593         if (bytes(_result).length == 0) { // empty Result
2594             if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2595                 LogPolicyManualPayout(policyId, "No Callback at +120 min");
2596                 return;
2597             } else {
2598                 schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2599             }
2600         } else {
2601             // first check status
2602             // extract the status field:
2603             slResult.find("\"".toSlice()).beyond("\"".toSlice());
2604             slResult.until(slResult.copy().find("\"".toSlice()));
2605             bytes1 status = bytes(slResult.toString())[0];	// s = L
2606             if (status == "C") {
2607                 // flight cancelled --> payout
2608                 payOut(policyId, 4, 0);
2609                 return;
2610             } else if (status == "D") {
2611                 // flight diverted --> payout
2612                 payOut(policyId, 5, 0);
2613                 return;
2614             } else if (status != "L" && status != "A" && status != "C" && status != "D") {
2615                 LogPolicyManualPayout(policyId, "Unprocessable status");
2616                 return;
2617             }
2618 
2619             // process the rest of the response:
2620             slResult = _result.toSlice();
2621             bool arrived = slResult.contains("actualGateArrival".toSlice());
2622 
2623             if (status == "A" || (status == "L" && !arrived)) {
2624                 // flight still active or not at gate --> reschedule
2625                 if (FD_DB.checkTime(_queryId, riskId, 180 minutes)) {
2626                     LogPolicyManualPayout(policyId, "No arrival at +180 min");
2627                 } else {
2628                     schedulePayoutOraclizeCall(policyId, riskId, oraclizeTime + 45 minutes);
2629                 }
2630             } else if (status == "L" && arrived) {
2631                 var aG = "\"arrivalGateDelayMinutes\": ".toSlice();
2632                 if (slResult.contains(aG)) {
2633                     slResult.find(aG).beyond(aG);
2634                     slResult.until(slResult.copy().find("\"".toSlice()).beyond("\"".toSlice()));
2635                     // truffle bug, replace by "}" as soon as it is fixed.
2636                     slResult.until(slResult.copy().find("\x7D".toSlice()));
2637                     slResult.until(slResult.copy().find(",".toSlice()));
2638                     uint delayInMinutes = parseInt(slResult.toString());
2639                 } else {
2640                     delayInMinutes = 0;
2641                 }
2642 
2643                 if (delayInMinutes < 15) {
2644                     payOut(policyId, 0, 0);
2645                 } else if (delayInMinutes < 30) {
2646                     payOut(policyId, 1, delayInMinutes);
2647                 } else if (delayInMinutes < 45) {
2648                     payOut(policyId, 2, delayInMinutes);
2649                 } else {
2650                     payOut(policyId, 3, delayInMinutes);
2651                 }
2652             } else { // no delay info
2653                 payOut(policyId, 0, 0);
2654             }
2655         }
2656     }
2657 
2658     /*
2659      * Internal methods
2660      */
2661 
2662     /*
2663      * @dev Payout
2664      * @param _policyId
2665      * @param _delay
2666      * @param _delayInMinutes
2667      */
2668     function payOut(uint _policyId, uint8 _delay, uint _delayInMinutes)	internal {
2669 // --> debug-mode
2670 //            LogString("im payOut", "");
2671 //            LogUint("policyId", _policyId);
2672 //            LogUint("delay", _delay);
2673 //            LogUint("in minutes", _delayInMinutes);
2674 // <-- debug-mode
2675 
2676         FD_DB.setDelay(_policyId, _delay, _delayInMinutes);
2677 
2678         if (_delay == 0 || WEIGHT_PATTERN[_delay] == 0) {
2679             FD_DB.setState(
2680                 _policyId,
2681                 policyState.Expired,
2682                 now,
2683                 "Expired - no delay!"
2684             );
2685         } else {
2686             var (customer, weight, premium) = FD_DB.getPolicyData(_policyId);
2687 
2688 // --> debug-mode
2689 //                LogUint("weight", weight);
2690 // <-- debug-mode
2691 
2692             if (weight == 0) {
2693                 weight = 20000;
2694             }
2695 
2696             uint payout = premium * WEIGHT_PATTERN[_delay] * 10000 / weight;
2697             uint calculatedPayout = payout;
2698 
2699             if (payout > MAX_PAYOUT) {
2700                 payout = MAX_PAYOUT;
2701             }
2702 
2703             FD_DB.setPayouts(_policyId, calculatedPayout, payout);
2704 
2705             if (!FD_LG.sendFunds(customer, Acc.Payout, payout)) {
2706                 FD_DB.setState(
2707                     _policyId,
2708                     policyState.SendFailed,
2709                     now,
2710                     "Payout, send failed!"
2711                 );
2712 
2713                 FD_DB.setPayouts(_policyId, calculatedPayout, 0);
2714             } else {
2715                 FD_DB.setState(
2716                     _policyId,
2717                     policyState.PaidOut,
2718                     now,
2719                     "Payout successful!"
2720                 );
2721             }
2722         }
2723     }
2724 
2725     function setOraclizeGasPrice(uint _gasPrice) external returns (bool _success) {
2726         require(FD_AC.checkPermission(103, msg.sender));
2727 
2728         oraclize_setCustomGasPrice(_gasPrice);
2729         _success = true;
2730     }
2731 }