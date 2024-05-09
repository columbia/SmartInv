1 pragma solidity^0.4.15;
2 /*
3  * @title String & slice utility library for Solidity contracts.
4  * @author Nick Johnson <arachnid@notdot.net>
5  *
6  * @dev Functionality in this library is largely implemented using an
7  *      abstraction called a 'slice'. A slice represents a part of a string -
8  *      anything from the entire string to a single character, or even no
9  *      characters at all (a 0-length slice). Since a slice only has to specify
10  *      an offset and a length, copying and manipulating slices is a lot less
11  *      expensive than copying and manipulating the strings they reference.
12  *
13  *      To further reduce gas costs, most functions on slice that need to return
14  *      a slice modify the original one instead of allocating a new one; for
15  *      instance, `s.split(".")` will return the text up to the first '.',
16  *      modifying s to only contain the remainder of the string after the '.'.
17  *      In situations where you do not want to modify the original slice, you
18  *      can make a copy first with `.copy()`, for example:
19  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
20  *      Solidity has no memory management, it will result in allocating many
21  *      short-lived slices that are later discarded.
22  *
23  *      Functions that return two slices come in two versions: a non-allocating
24  *      version that takes the second slice as an argument, modifying it in
25  *      place, and an allocating version that allocates and returns the second
26  *      slice; see `nextRune` for example.
27  *
28  *      Functions that have to copy string data will return strings rather than
29  *      slices; these can be cast back to slices for further processing if
30  *      required.
31  *
32  *      For convenience, some functions are provided with non-modifying
33  *      variants that create a new slice and return both; for instance,
34  *      `s.splitNew('.')` leaves s unmodified, and returns two values
35  *      corresponding to the left and right parts of the string.
36  */
37  
38 //pragma solidity ^0.4.14;
39 
40 library strings {
41     struct slice {
42         uint _len;
43         uint _ptr;
44     }
45 
46     function memcpy(uint dest, uint src, uint len) private {
47         // Copy word-length chunks while possible
48         for(; len >= 32; len -= 32) {
49             assembly {
50                 mstore(dest, mload(src))
51             }
52             dest += 32;
53             src += 32;
54         }
55 
56         // Copy remaining bytes
57         uint mask = 256 ** (32 - len) - 1;
58         assembly {
59             let srcpart := and(mload(src), not(mask))
60             let destpart := and(mload(dest), mask)
61             mstore(dest, or(destpart, srcpart))
62         }
63     }
64 
65     /*
66      * @dev Returns a slice containing the entire string.
67      * @param self The string to make a slice from.
68      * @return A newly allocated slice containing the entire string.
69      */
70     function toSlice(string self) internal returns (slice) {
71         uint ptr;
72         assembly {
73             ptr := add(self, 0x20)
74         }
75         return slice(bytes(self).length, ptr);
76     }
77 
78     /*
79      * @dev Returns the length of a null-terminated bytes32 string.
80      * @param self The value to find the length of.
81      * @return The length of the string, from 0 to 32.
82      */
83     function len(bytes32 self) internal returns (uint) {
84         uint ret;
85         if (self == 0)
86             return 0;
87         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
88             ret += 16;
89             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
90         }
91         if (self & 0xffffffffffffffff == 0) {
92             ret += 8;
93             self = bytes32(uint(self) / 0x10000000000000000);
94         }
95         if (self & 0xffffffff == 0) {
96             ret += 4;
97             self = bytes32(uint(self) / 0x100000000);
98         }
99         if (self & 0xffff == 0) {
100             ret += 2;
101             self = bytes32(uint(self) / 0x10000);
102         }
103         if (self & 0xff == 0) {
104             ret += 1;
105         }
106         return 32 - ret;
107     }
108 
109     /*
110      * @dev Returns a slice containing the entire bytes32, interpreted as a
111      *      null-termintaed utf-8 string.
112      * @param self The bytes32 value to convert to a slice.
113      * @return A new slice containing the value of the input argument up to the
114      *         first null.
115      */
116     function toSliceB32(bytes32 self) internal returns (slice ret) {
117         // Allocate space for `self` in memory, copy it there, and point ret at it
118         assembly {
119             let ptr := mload(0x40)
120             mstore(0x40, add(ptr, 0x20))
121             mstore(ptr, self)
122             mstore(add(ret, 0x20), ptr)
123         }
124         ret._len = len(self);
125     }
126 
127     /*
128      * @dev Returns a new slice containing the same data as the current slice.
129      * @param self The slice to copy.
130      * @return A new slice containing the same data as `self`.
131      */
132     function copy(slice self) internal returns (slice) {
133         return slice(self._len, self._ptr);
134     }
135 
136     /*
137      * @dev Copies a slice to a new string.
138      * @param self The slice to copy.
139      * @return A newly allocated string containing the slice's text.
140      */
141     function toString(slice self) internal returns (string) {
142         var ret = new string(self._len);
143         uint retptr;
144         assembly { retptr := add(ret, 32) }
145 
146         memcpy(retptr, self._ptr, self._len);
147         return ret;
148     }
149 
150     /*
151      * @dev Returns the length in runes of the slice. Note that this operation
152      *      takes time proportional to the length of the slice; avoid using it
153      *      in loops, and call `slice.empty()` if you only need to know whether
154      *      the slice is empty or not.
155      * @param self The slice to operate on.
156      * @return The length of the slice in runes.
157      */
158     function len(slice self) internal returns (uint l) {
159         // Starting at ptr-31 means the LSB will be the byte we care about
160         var ptr = self._ptr - 31;
161         var end = ptr + self._len;
162         for (l = 0; ptr < end; l++) {
163             uint8 b;
164             assembly { b := and(mload(ptr), 0xFF) }
165             if (b < 0x80) {
166                 ptr += 1;
167             } else if(b < 0xE0) {
168                 ptr += 2;
169             } else if(b < 0xF0) {
170                 ptr += 3;
171             } else if(b < 0xF8) {
172                 ptr += 4;
173             } else if(b < 0xFC) {
174                 ptr += 5;
175             } else {
176                 ptr += 6;
177             }
178         }
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
300         uint length;
301         uint divisor = 2 ** 248;
302 
303         // Load the rune into the MSBs of b
304         assembly { word:= mload(mload(add(self, 32))) }
305         var b = word / divisor;
306         if (b < 0x80) {
307             ret = b;
308             length = 1;
309         } else if(b < 0xE0) {
310             ret = b & 0x1F;
311             length = 2;
312         } else if(b < 0xF0) {
313             ret = b & 0x0F;
314             length = 3;
315         } else {
316             ret = b & 0x07;
317             length = 4;
318         }
319 
320         // Check for truncated codepoints
321         if (length > self._len) {
322             return 0;
323         }
324 
325         for (uint i = 1; i < length; i++) {
326             divisor = divisor / 256;
327             b = (word / divisor) & 0xFF;
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
345             ret := keccak256(mload(add(self, 32)), mload(self))
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
366             let length := mload(needle)
367             let selfptr := mload(add(self, 0x20))
368             let needleptr := mload(add(needle, 0x20))
369             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
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
389                 let length := mload(needle)
390                 let selfptr := mload(add(self, 0x20))
391                 let needleptr := mload(add(needle, 0x20))
392                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
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
423             let length := mload(needle)
424             let needleptr := mload(add(needle, 0x20))
425             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
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
447                 let length := mload(needle)
448                 let needleptr := mload(add(needle, 0x20))
449                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
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
647     function count(slice self, slice needle) internal returns (uint cnt) {
648         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
649         while (ptr <= self._ptr + self._len) {
650             cnt++;
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
693         uint length = self._len * (parts.length - 1);
694         for(uint i = 0; i < parts.length; i++)
695             length += parts[i]._len;
696 
697         var ret = new string(length);
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
713 // <ORACLIZE_API>
714 /*
715 Copyright (c) 2015-2016 Oraclize SRL
716 Copyright (c) 2016 Oraclize LTD
717 
718 
719 
720 Permission is hereby granted, free of charge, to any person obtaining a copy
721 of this software and associated documentation files (the "Software"), to deal
722 in the Software without restriction, including without limitation the rights
723 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
724 copies of the Software, and to permit persons to whom the Software is
725 furnished to do so, subject to the following conditions:
726 
727 
728 
729 The above copyright notice and this permission notice shall be included in
730 all copies or substantial portions of the Software.
731 
732 
733 
734 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
735 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
736 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
737 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
738 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
739 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
740 THE SOFTWARE.
741 */
742 
743 //pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
744 
745 contract OraclizeI {
746     address public cbAddress;
747     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
748     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
749     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
750     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
751     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
752     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
753     function getPrice(string _datasource) returns (uint _dsprice);
754     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
755     function useCoupon(string _coupon);
756     function setProofType(byte _proofType);
757     function setConfig(bytes32 _config);
758     function setCustomGasPrice(uint _gasPrice);
759     function randomDS_getSessionPubKeyHash() returns(bytes32);
760 }
761 contract OraclizeAddrResolverI {
762     function getAddress() returns (address _addr);
763 }
764 contract usingOraclize {
765     uint constant day = 60*60*24;
766     uint constant week = 60*60*24*7;
767     uint constant month = 60*60*24*30;
768     byte constant proofType_NONE = 0x00;
769     byte constant proofType_TLSNotary = 0x10;
770     byte constant proofType_Android = 0x20;
771     byte constant proofType_Ledger = 0x30;
772     byte constant proofType_Native = 0xF0;
773     byte constant proofStorage_IPFS = 0x01;
774     uint8 constant networkID_auto = 0;
775     uint8 constant networkID_mainnet = 1;
776     uint8 constant networkID_testnet = 2;
777     uint8 constant networkID_morden = 2;
778     uint8 constant networkID_consensys = 161;
779 
780     OraclizeAddrResolverI OAR;
781 
782     OraclizeI oraclize;
783     modifier oraclizeAPI {
784         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
785             oraclize_setNetwork(networkID_auto);
786 
787         if(address(oraclize) != OAR.getAddress())
788             oraclize = OraclizeI(OAR.getAddress());
789 
790         _;
791     }
792     modifier coupon(string code){
793         oraclize = OraclizeI(OAR.getAddress());
794         oraclize.useCoupon(code);
795         _;
796     }
797 
798     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
799         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
800             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
801             oraclize_setNetworkName("eth_mainnet");
802             return true;
803         }
804         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
805             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
806             oraclize_setNetworkName("eth_ropsten3");
807             return true;
808         }
809         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
810             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
811             oraclize_setNetworkName("eth_kovan");
812             return true;
813         }
814         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
815             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
816             oraclize_setNetworkName("eth_rinkeby");
817             return true;
818         }
819         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
820             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
821             return true;
822         }
823         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
824             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
825             return true;
826         }
827         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
828             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
829             return true;
830         }
831         return false;
832     }
833 
834     function __callback(bytes32 myid, string result) {
835         __callback(myid, result, new bytes(0));
836     }
837     function __callback(bytes32 myid, string result, bytes proof) {
838     }
839 
840     function oraclize_useCoupon(string code) oraclizeAPI internal {
841         oraclize.useCoupon(code);
842     }
843 
844     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
845         return oraclize.getPrice(datasource);
846     }
847 
848     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
849         return oraclize.getPrice(datasource, gaslimit);
850     }
851 
852     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
853         uint price = oraclize.getPrice(datasource);
854         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
855         return oraclize.query.value(price)(0, datasource, arg);
856     }
857     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
858         uint price = oraclize.getPrice(datasource);
859         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
860         return oraclize.query.value(price)(timestamp, datasource, arg);
861     }
862     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
863         uint price = oraclize.getPrice(datasource, gaslimit);
864         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
865         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
866     }
867     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
868         uint price = oraclize.getPrice(datasource, gaslimit);
869         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
870         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
871     }
872     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
873         uint price = oraclize.getPrice(datasource);
874         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
875         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
876     }
877     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
878         uint price = oraclize.getPrice(datasource);
879         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
880         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
881     }
882     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
883         uint price = oraclize.getPrice(datasource, gaslimit);
884         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
885         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
886     }
887     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
888         uint price = oraclize.getPrice(datasource, gaslimit);
889         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
890         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
891     }
892     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
893         uint price = oraclize.getPrice(datasource);
894         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
895         bytes memory args = stra2cbor(argN);
896         return oraclize.queryN.value(price)(0, datasource, args);
897     }
898     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
899         uint price = oraclize.getPrice(datasource);
900         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
901         bytes memory args = stra2cbor(argN);
902         return oraclize.queryN.value(price)(timestamp, datasource, args);
903     }
904     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
905         uint price = oraclize.getPrice(datasource, gaslimit);
906         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
907         bytes memory args = stra2cbor(argN);
908         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
909     }
910     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
911         uint price = oraclize.getPrice(datasource, gaslimit);
912         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
913         bytes memory args = stra2cbor(argN);
914         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
915     }
916     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
917         string[] memory dynargs = new string[](1);
918         dynargs[0] = args[0];
919         return oraclize_query(datasource, dynargs);
920     }
921     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
922         string[] memory dynargs = new string[](1);
923         dynargs[0] = args[0];
924         return oraclize_query(timestamp, datasource, dynargs);
925     }
926     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
927         string[] memory dynargs = new string[](1);
928         dynargs[0] = args[0];
929         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
930     }
931     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
932         string[] memory dynargs = new string[](1);
933         dynargs[0] = args[0];
934         return oraclize_query(datasource, dynargs, gaslimit);
935     }
936 
937     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
938         string[] memory dynargs = new string[](2);
939         dynargs[0] = args[0];
940         dynargs[1] = args[1];
941         return oraclize_query(datasource, dynargs);
942     }
943     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
944         string[] memory dynargs = new string[](2);
945         dynargs[0] = args[0];
946         dynargs[1] = args[1];
947         return oraclize_query(timestamp, datasource, dynargs);
948     }
949     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
950         string[] memory dynargs = new string[](2);
951         dynargs[0] = args[0];
952         dynargs[1] = args[1];
953         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
954     }
955     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
956         string[] memory dynargs = new string[](2);
957         dynargs[0] = args[0];
958         dynargs[1] = args[1];
959         return oraclize_query(datasource, dynargs, gaslimit);
960     }
961     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
962         string[] memory dynargs = new string[](3);
963         dynargs[0] = args[0];
964         dynargs[1] = args[1];
965         dynargs[2] = args[2];
966         return oraclize_query(datasource, dynargs);
967     }
968     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
969         string[] memory dynargs = new string[](3);
970         dynargs[0] = args[0];
971         dynargs[1] = args[1];
972         dynargs[2] = args[2];
973         return oraclize_query(timestamp, datasource, dynargs);
974     }
975     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
976         string[] memory dynargs = new string[](3);
977         dynargs[0] = args[0];
978         dynargs[1] = args[1];
979         dynargs[2] = args[2];
980         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
981     }
982     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
983         string[] memory dynargs = new string[](3);
984         dynargs[0] = args[0];
985         dynargs[1] = args[1];
986         dynargs[2] = args[2];
987         return oraclize_query(datasource, dynargs, gaslimit);
988     }
989 
990     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
991         string[] memory dynargs = new string[](4);
992         dynargs[0] = args[0];
993         dynargs[1] = args[1];
994         dynargs[2] = args[2];
995         dynargs[3] = args[3];
996         return oraclize_query(datasource, dynargs);
997     }
998     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
999         string[] memory dynargs = new string[](4);
1000         dynargs[0] = args[0];
1001         dynargs[1] = args[1];
1002         dynargs[2] = args[2];
1003         dynargs[3] = args[3];
1004         return oraclize_query(timestamp, datasource, dynargs);
1005     }
1006     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1007         string[] memory dynargs = new string[](4);
1008         dynargs[0] = args[0];
1009         dynargs[1] = args[1];
1010         dynargs[2] = args[2];
1011         dynargs[3] = args[3];
1012         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1013     }
1014     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](4);
1016         dynargs[0] = args[0];
1017         dynargs[1] = args[1];
1018         dynargs[2] = args[2];
1019         dynargs[3] = args[3];
1020         return oraclize_query(datasource, dynargs, gaslimit);
1021     }
1022     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1023         string[] memory dynargs = new string[](5);
1024         dynargs[0] = args[0];
1025         dynargs[1] = args[1];
1026         dynargs[2] = args[2];
1027         dynargs[3] = args[3];
1028         dynargs[4] = args[4];
1029         return oraclize_query(datasource, dynargs);
1030     }
1031     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1032         string[] memory dynargs = new string[](5);
1033         dynargs[0] = args[0];
1034         dynargs[1] = args[1];
1035         dynargs[2] = args[2];
1036         dynargs[3] = args[3];
1037         dynargs[4] = args[4];
1038         return oraclize_query(timestamp, datasource, dynargs);
1039     }
1040     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1041         string[] memory dynargs = new string[](5);
1042         dynargs[0] = args[0];
1043         dynargs[1] = args[1];
1044         dynargs[2] = args[2];
1045         dynargs[3] = args[3];
1046         dynargs[4] = args[4];
1047         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1048     }
1049     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1050         string[] memory dynargs = new string[](5);
1051         dynargs[0] = args[0];
1052         dynargs[1] = args[1];
1053         dynargs[2] = args[2];
1054         dynargs[3] = args[3];
1055         dynargs[4] = args[4];
1056         return oraclize_query(datasource, dynargs, gaslimit);
1057     }
1058     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1059         uint price = oraclize.getPrice(datasource);
1060         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1061         bytes memory args = ba2cbor(argN);
1062         return oraclize.queryN.value(price)(0, datasource, args);
1063     }
1064     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1065         uint price = oraclize.getPrice(datasource);
1066         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1067         bytes memory args = ba2cbor(argN);
1068         return oraclize.queryN.value(price)(timestamp, datasource, args);
1069     }
1070     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1071         uint price = oraclize.getPrice(datasource, gaslimit);
1072         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1073         bytes memory args = ba2cbor(argN);
1074         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1075     }
1076     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1077         uint price = oraclize.getPrice(datasource, gaslimit);
1078         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1079         bytes memory args = ba2cbor(argN);
1080         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1081     }
1082     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1083         bytes[] memory dynargs = new bytes[](1);
1084         dynargs[0] = args[0];
1085         return oraclize_query(datasource, dynargs);
1086     }
1087     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1088         bytes[] memory dynargs = new bytes[](1);
1089         dynargs[0] = args[0];
1090         return oraclize_query(timestamp, datasource, dynargs);
1091     }
1092     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1093         bytes[] memory dynargs = new bytes[](1);
1094         dynargs[0] = args[0];
1095         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1096     }
1097     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1098         bytes[] memory dynargs = new bytes[](1);
1099         dynargs[0] = args[0];
1100         return oraclize_query(datasource, dynargs, gaslimit);
1101     }
1102 
1103     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1104         bytes[] memory dynargs = new bytes[](2);
1105         dynargs[0] = args[0];
1106         dynargs[1] = args[1];
1107         return oraclize_query(datasource, dynargs);
1108     }
1109     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1110         bytes[] memory dynargs = new bytes[](2);
1111         dynargs[0] = args[0];
1112         dynargs[1] = args[1];
1113         return oraclize_query(timestamp, datasource, dynargs);
1114     }
1115     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1116         bytes[] memory dynargs = new bytes[](2);
1117         dynargs[0] = args[0];
1118         dynargs[1] = args[1];
1119         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1120     }
1121     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1122         bytes[] memory dynargs = new bytes[](2);
1123         dynargs[0] = args[0];
1124         dynargs[1] = args[1];
1125         return oraclize_query(datasource, dynargs, gaslimit);
1126     }
1127     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1128         bytes[] memory dynargs = new bytes[](3);
1129         dynargs[0] = args[0];
1130         dynargs[1] = args[1];
1131         dynargs[2] = args[2];
1132         return oraclize_query(datasource, dynargs);
1133     }
1134     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1135         bytes[] memory dynargs = new bytes[](3);
1136         dynargs[0] = args[0];
1137         dynargs[1] = args[1];
1138         dynargs[2] = args[2];
1139         return oraclize_query(timestamp, datasource, dynargs);
1140     }
1141     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1142         bytes[] memory dynargs = new bytes[](3);
1143         dynargs[0] = args[0];
1144         dynargs[1] = args[1];
1145         dynargs[2] = args[2];
1146         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1147     }
1148     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1149         bytes[] memory dynargs = new bytes[](3);
1150         dynargs[0] = args[0];
1151         dynargs[1] = args[1];
1152         dynargs[2] = args[2];
1153         return oraclize_query(datasource, dynargs, gaslimit);
1154     }
1155 
1156     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1157         bytes[] memory dynargs = new bytes[](4);
1158         dynargs[0] = args[0];
1159         dynargs[1] = args[1];
1160         dynargs[2] = args[2];
1161         dynargs[3] = args[3];
1162         return oraclize_query(datasource, dynargs);
1163     }
1164     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1165         bytes[] memory dynargs = new bytes[](4);
1166         dynargs[0] = args[0];
1167         dynargs[1] = args[1];
1168         dynargs[2] = args[2];
1169         dynargs[3] = args[3];
1170         return oraclize_query(timestamp, datasource, dynargs);
1171     }
1172     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1173         bytes[] memory dynargs = new bytes[](4);
1174         dynargs[0] = args[0];
1175         dynargs[1] = args[1];
1176         dynargs[2] = args[2];
1177         dynargs[3] = args[3];
1178         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1179     }
1180     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](4);
1182         dynargs[0] = args[0];
1183         dynargs[1] = args[1];
1184         dynargs[2] = args[2];
1185         dynargs[3] = args[3];
1186         return oraclize_query(datasource, dynargs, gaslimit);
1187     }
1188     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1189         bytes[] memory dynargs = new bytes[](5);
1190         dynargs[0] = args[0];
1191         dynargs[1] = args[1];
1192         dynargs[2] = args[2];
1193         dynargs[3] = args[3];
1194         dynargs[4] = args[4];
1195         return oraclize_query(datasource, dynargs);
1196     }
1197     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1198         bytes[] memory dynargs = new bytes[](5);
1199         dynargs[0] = args[0];
1200         dynargs[1] = args[1];
1201         dynargs[2] = args[2];
1202         dynargs[3] = args[3];
1203         dynargs[4] = args[4];
1204         return oraclize_query(timestamp, datasource, dynargs);
1205     }
1206     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1207         bytes[] memory dynargs = new bytes[](5);
1208         dynargs[0] = args[0];
1209         dynargs[1] = args[1];
1210         dynargs[2] = args[2];
1211         dynargs[3] = args[3];
1212         dynargs[4] = args[4];
1213         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1214     }
1215     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1216         bytes[] memory dynargs = new bytes[](5);
1217         dynargs[0] = args[0];
1218         dynargs[1] = args[1];
1219         dynargs[2] = args[2];
1220         dynargs[3] = args[3];
1221         dynargs[4] = args[4];
1222         return oraclize_query(datasource, dynargs, gaslimit);
1223     }
1224 
1225     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1226         return oraclize.cbAddress();
1227     }
1228     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1229         return oraclize.setProofType(proofP);
1230     }
1231     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1232         return oraclize.setCustomGasPrice(gasPrice);
1233     }
1234     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1235         return oraclize.setConfig(config);
1236     }
1237 
1238     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1239         return oraclize.randomDS_getSessionPubKeyHash();
1240     }
1241 
1242     function getCodeSize(address _addr) constant internal returns(uint _size) {
1243         assembly {
1244             _size := extcodesize(_addr)
1245         }
1246     }
1247 
1248     function parseAddr(string _a) internal returns (address){
1249         bytes memory tmp = bytes(_a);
1250         uint160 iaddr = 0;
1251         uint160 b1;
1252         uint160 b2;
1253         for (uint i=2; i<2+2*20; i+=2){
1254             iaddr *= 256;
1255             b1 = uint160(tmp[i]);
1256             b2 = uint160(tmp[i+1]);
1257             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1258             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1259             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1260             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1261             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1262             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1263             iaddr += (b1*16+b2);
1264         }
1265         return address(iaddr);
1266     }
1267 
1268     function strCompare(string _a, string _b) internal returns (int) {
1269         bytes memory a = bytes(_a);
1270         bytes memory b = bytes(_b);
1271         uint minLength = a.length;
1272         if (b.length < minLength) minLength = b.length;
1273         for (uint i = 0; i < minLength; i ++)
1274             if (a[i] < b[i])
1275                 return -1;
1276             else if (a[i] > b[i])
1277                 return 1;
1278         if (a.length < b.length)
1279             return -1;
1280         else if (a.length > b.length)
1281             return 1;
1282         else
1283             return 0;
1284     }
1285 
1286     function indexOf(string _haystack, string _needle) internal returns (int) {
1287         bytes memory h = bytes(_haystack);
1288         bytes memory n = bytes(_needle);
1289         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1290             return -1;
1291         else if(h.length > (2**128 -1))
1292             return -1;
1293         else
1294         {
1295             uint subindex = 0;
1296             for (uint i = 0; i < h.length; i ++)
1297             {
1298                 if (h[i] == n[0])
1299                 {
1300                     subindex = 1;
1301                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1302                     {
1303                         subindex++;
1304                     }
1305                     if(subindex == n.length)
1306                         return int(i);
1307                 }
1308             }
1309             return -1;
1310         }
1311     }
1312 
1313     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1314         bytes memory _ba = bytes(_a);
1315         bytes memory _bb = bytes(_b);
1316         bytes memory _bc = bytes(_c);
1317         bytes memory _bd = bytes(_d);
1318         bytes memory _be = bytes(_e);
1319         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1320         bytes memory babcde = bytes(abcde);
1321         uint k = 0;
1322         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1323         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1324         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1325         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1326         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1327         return string(babcde);
1328     }
1329 
1330     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1331         return strConcat(_a, _b, _c, _d, "");
1332     }
1333 
1334     function strConcat(string _a, string _b, string _c) internal returns (string) {
1335         return strConcat(_a, _b, _c, "", "");
1336     }
1337 
1338     function strConcat(string _a, string _b) internal returns (string) {
1339         return strConcat(_a, _b, "", "", "");
1340     }
1341 
1342     // parseInt
1343     function parseInt(string _a) internal returns (uint) {
1344         return parseInt(_a, 0);
1345     }
1346 
1347     // parseInt(parseFloat*10^_b)
1348     function parseInt(string _a, uint _b) internal returns (uint) {
1349         bytes memory bresult = bytes(_a);
1350         uint mint = 0;
1351         bool decimals = false;
1352         for (uint i=0; i<bresult.length; i++){
1353             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1354                 if (decimals){
1355                    if (_b == 0) break;
1356                     else _b--;
1357                 }
1358                 mint *= 10;
1359                 mint += uint(bresult[i]) - 48;
1360             } else if (bresult[i] == 46) decimals = true;
1361         }
1362         if (_b > 0) mint *= 10**_b;
1363         return mint;
1364     }
1365 
1366     function uint2str(uint i) internal returns (string){
1367         if (i == 0) return "0";
1368         uint j = i;
1369         uint len;
1370         while (j != 0){
1371             len++;
1372             j /= 10;
1373         }
1374         bytes memory bstr = new bytes(len);
1375         uint k = len - 1;
1376         while (i != 0){
1377             bstr[k--] = byte(48 + i % 10);
1378             i /= 10;
1379         }
1380         return string(bstr);
1381     }
1382 
1383     function stra2cbor(string[] arr) internal returns (bytes) {
1384             uint arrlen = arr.length;
1385 
1386             // get correct cbor output length
1387             uint outputlen = 0;
1388             bytes[] memory elemArray = new bytes[](arrlen);
1389             for (uint i = 0; i < arrlen; i++) {
1390                 elemArray[i] = (bytes(arr[i]));
1391                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1392             }
1393             uint ctr = 0;
1394             uint cborlen = arrlen + 0x80;
1395             outputlen += byte(cborlen).length;
1396             bytes memory res = new bytes(outputlen);
1397 
1398             while (byte(cborlen).length > ctr) {
1399                 res[ctr] = byte(cborlen)[ctr];
1400                 ctr++;
1401             }
1402             for (i = 0; i < arrlen; i++) {
1403                 res[ctr] = 0x5F;
1404                 ctr++;
1405                 for (uint x = 0; x < elemArray[i].length; x++) {
1406                     // if there's a bug with larger strings, this may be the culprit
1407                     if (x % 23 == 0) {
1408                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1409                         elemcborlen += 0x40;
1410                         uint lctr = ctr;
1411                         while (byte(elemcborlen).length > ctr - lctr) {
1412                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1413                             ctr++;
1414                         }
1415                     }
1416                     res[ctr] = elemArray[i][x];
1417                     ctr++;
1418                 }
1419                 res[ctr] = 0xFF;
1420                 ctr++;
1421             }
1422             return res;
1423         }
1424 
1425     function ba2cbor(bytes[] arr) internal returns (bytes) {
1426             uint arrlen = arr.length;
1427 
1428             // get correct cbor output length
1429             uint outputlen = 0;
1430             bytes[] memory elemArray = new bytes[](arrlen);
1431             for (uint i = 0; i < arrlen; i++) {
1432                 elemArray[i] = (bytes(arr[i]));
1433                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1434             }
1435             uint ctr = 0;
1436             uint cborlen = arrlen + 0x80;
1437             outputlen += byte(cborlen).length;
1438             bytes memory res = new bytes(outputlen);
1439 
1440             while (byte(cborlen).length > ctr) {
1441                 res[ctr] = byte(cborlen)[ctr];
1442                 ctr++;
1443             }
1444             for (i = 0; i < arrlen; i++) {
1445                 res[ctr] = 0x5F;
1446                 ctr++;
1447                 for (uint x = 0; x < elemArray[i].length; x++) {
1448                     // if there's a bug with larger strings, this may be the culprit
1449                     if (x % 23 == 0) {
1450                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1451                         elemcborlen += 0x40;
1452                         uint lctr = ctr;
1453                         while (byte(elemcborlen).length > ctr - lctr) {
1454                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1455                             ctr++;
1456                         }
1457                     }
1458                     res[ctr] = elemArray[i][x];
1459                     ctr++;
1460                 }
1461                 res[ctr] = 0xFF;
1462                 ctr++;
1463             }
1464             return res;
1465         }
1466 
1467 
1468     string oraclize_network_name;
1469     function oraclize_setNetworkName(string _network_name) internal {
1470         oraclize_network_name = _network_name;
1471     }
1472 
1473     function oraclize_getNetworkName() internal returns (string) {
1474         return oraclize_network_name;
1475     }
1476 
1477     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1478         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1479 	// Convert from seconds to ledger timer ticks
1480         _delay *= 10; 
1481         bytes memory nbytes = new bytes(1);
1482         nbytes[0] = byte(_nbytes);
1483         bytes memory unonce = new bytes(32);
1484         bytes memory sessionKeyHash = new bytes(32);
1485         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1486         assembly {
1487             mstore(unonce, 0x20)
1488             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1489             mstore(sessionKeyHash, 0x20)
1490             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1491         }
1492         bytes memory delay = new bytes(32);
1493         assembly { 
1494             mstore(add(delay, 0x20), _delay) 
1495         }
1496         
1497         bytes memory delay_bytes8 = new bytes(8);
1498         copyBytes(delay, 24, 8, delay_bytes8, 0);
1499 
1500         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1501         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1502         
1503         bytes memory delay_bytes8_left = new bytes(8);
1504         
1505         assembly {
1506             let x := mload(add(delay_bytes8, 0x20))
1507             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1508             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1509             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1510             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1511             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1512             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1513             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1514             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1515 
1516         }
1517         
1518         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1519         return queryId;
1520     }
1521     
1522     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1523         oraclize_randomDS_args[queryId] = commitment;
1524     }
1525 
1526     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1527     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1528 
1529     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1530         bool sigok;
1531         address signer;
1532 
1533         bytes32 sigr;
1534         bytes32 sigs;
1535 
1536         bytes memory sigr_ = new bytes(32);
1537         uint offset = 4+(uint(dersig[3]) - 0x20);
1538         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1539         bytes memory sigs_ = new bytes(32);
1540         offset += 32 + 2;
1541         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1542 
1543         assembly {
1544             sigr := mload(add(sigr_, 32))
1545             sigs := mload(add(sigs_, 32))
1546         }
1547 
1548 
1549         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1550         if (address(sha3(pubkey)) == signer) return true;
1551         else {
1552             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1553             return (address(sha3(pubkey)) == signer);
1554         }
1555     }
1556 
1557     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1558         bool sigok;
1559 
1560         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1561         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1562         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1563 
1564         bytes memory appkey1_pubkey = new bytes(64);
1565         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1566 
1567         bytes memory tosign2 = new bytes(1+65+32);
1568         tosign2[0] = 1; //role
1569         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1570         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1571         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1572         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1573 
1574         if (sigok == false) return false;
1575 
1576 
1577         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1578         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1579 
1580         bytes memory tosign3 = new bytes(1+65);
1581         tosign3[0] = 0xFE;
1582         copyBytes(proof, 3, 65, tosign3, 1);
1583 
1584         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1585         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1586 
1587         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1588 
1589         return sigok;
1590     }
1591 
1592     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1593         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1594         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1595 
1596         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1597         if (proofVerified == false) throw;
1598 
1599         _;
1600     }
1601 
1602     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1603         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1604         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1605 
1606         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1607         if (proofVerified == false) return 2;
1608 
1609         return 0;
1610     }
1611 
1612     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1613         bool match_ = true;
1614 	
1615 	if (prefix.length != n_random_bytes) throw;
1616 	        
1617         for (uint256 i=0; i< n_random_bytes; i++) {
1618             if (content[i] != prefix[i]) match_ = false;
1619         }
1620 
1621         return match_;
1622     }
1623 
1624     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1625 
1626         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1627         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1628         bytes memory keyhash = new bytes(32);
1629         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1630         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1631 
1632         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1633         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1634 
1635         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1636         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1637 
1638         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1639         // This is to verify that the computed args match with the ones specified in the query.
1640         bytes memory commitmentSlice1 = new bytes(8+1+32);
1641         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1642 
1643         bytes memory sessionPubkey = new bytes(64);
1644         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1645         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1646 
1647         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1648         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1649             delete oraclize_randomDS_args[queryId];
1650         } else return false;
1651 
1652 
1653         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1654         bytes memory tosign1 = new bytes(32+8+1+32);
1655         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1656         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1657 
1658         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1659         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1660             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1661         }
1662 
1663         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1664     }
1665 
1666 
1667     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1668     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1669         uint minLength = length + toOffset;
1670 
1671         if (to.length < minLength) {
1672             // Buffer too small
1673             throw; // Should be a better way?
1674         }
1675 
1676         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1677         uint i = 32 + fromOffset;
1678         uint j = 32 + toOffset;
1679 
1680         while (i < (32 + fromOffset + length)) {
1681             assembly {
1682                 let tmp := mload(add(from, i))
1683                 mstore(add(to, j), tmp)
1684             }
1685             i += 32;
1686             j += 32;
1687         }
1688 
1689         return to;
1690     }
1691 
1692     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1693     // Duplicate Solidity's ecrecover, but catching the CALL return value
1694     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1695         // We do our own memory management here. Solidity uses memory offset
1696         // 0x40 to store the current end of memory. We write past it (as
1697         // writes are memory extensions), but don't update the offset so
1698         // Solidity will reuse it. The memory used here is only needed for
1699         // this context.
1700 
1701         // FIXME: inline assembly can't access return values
1702         bool ret;
1703         address addr;
1704 
1705         assembly {
1706             let size := mload(0x40)
1707             mstore(size, hash)
1708             mstore(add(size, 32), v)
1709             mstore(add(size, 64), r)
1710             mstore(add(size, 96), s)
1711 
1712             // NOTE: we can reuse the request memory because we deal with
1713             //       the return code
1714             ret := call(3000, 1, 0, size, 128, size, 32)
1715             addr := mload(size)
1716         }
1717 
1718         return (ret, addr);
1719     }
1720 
1721     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1722     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1723         bytes32 r;
1724         bytes32 s;
1725         uint8 v;
1726 
1727         if (sig.length != 65)
1728           return (false, 0);
1729 
1730         // The signature format is a compact form of:
1731         //   {bytes32 r}{bytes32 s}{uint8 v}
1732         // Compact means, uint8 is not padded to 32 bytes.
1733         assembly {
1734             r := mload(add(sig, 32))
1735             s := mload(add(sig, 64))
1736 
1737             // Here we are loading the last 32 bytes. We exploit the fact that
1738             // 'mload' will pad with zeroes if we overread.
1739             // There is no 'mload8' to do this, but that would be nicer.
1740             v := byte(0, mload(add(sig, 96)))
1741 
1742             // Alternative solution:
1743             // 'byte' is not working due to the Solidity parser, so lets
1744             // use the second best option, 'and'
1745             // v := and(mload(add(sig, 65)), 255)
1746         }
1747 
1748         // albeit non-transactional signatures are not specified by the YP, one would expect it
1749         // to match the YP range of [27, 28]
1750         //
1751         // geth uses [0, 1] and some clients have followed. This might change, see:
1752         //  https://github.com/ethereum/go-ethereum/issues/2053
1753         if (v < 27)
1754           v += 27;
1755 
1756         if (v != 27 && v != 28)
1757             return (false, 0);
1758 
1759         return safer_ecrecover(hash, v, r, s);
1760     }
1761 
1762 }
1763 // </ORACLIZE_API>
1764 
1765 contract FreeLOTInterface {
1766     function balanceOf(address who) constant public returns (uint) {}
1767     function destroy(address _from, uint _amt) external {}
1768 }
1769 
1770 contract EtheraffleUpgrade {
1771     function addToPrizePool() payable external {}
1772 }
1773 
1774 contract ReceiverInterface {
1775     function receiveEther() external payable {}
1776 }
1777 
1778 contract Etheraffle is EtheraffleUpgrade, FreeLOTInterface, ReceiverInterface, usingOraclize {
1779     using strings for *;
1780 
1781     uint    public week;
1782     bool    public paused;
1783     uint    public upgraded;
1784     uint    public prizePool;
1785     address public ethRelief;
1786     address public etheraffle;
1787     address public upgradeAddr;
1788     address public disburseAddr;
1789     uint    public take         = 150;//ppt
1790     uint    public gasAmt       = 500000;
1791     uint    public gasPrc       = 20000000000;//20 gwei
1792     uint    public rafEnd       = 500400;//7:00pm Saturdays
1793     uint    public tktPrice     = 2000000000000000;
1794     uint    public oracCost     = 1500000000000000;//$1 @ $700
1795     uint    public wdrawBfr     = 6048000;
1796     uint[]  public pctOfPool    = [520, 114, 47, 319];//ppt...
1797     uint    public resultsDelay = 3600;
1798     uint    public matchesDelay = 3600;
1799     uint  constant weekDur      = 604800;
1800     uint  constant birthday     = 1500249600;//Etheraffle's birthday <3
1801 
1802     FreeLOTInterface freeLOT;
1803 
1804     string randomStr1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"data\", \"serialNumber\"]','\\n{\"jsonrpc\": \"2.0\",\"method\":\"generateSignedIntegers\",\"id\":\"";
1805     string randomStr2 = "\",\"params\":{\"n\":\"6\",\"min\":1,\"max\":49,\"replacement\":false,\"base\":10,\"apiKey\":${[decrypt] BOxU9jP2laZmGPe29WvCh5HY57objD14TTuYv1Y1p7M43mHS8rDupPiIjIq8DNPGm4A8OtbBmBxUZant/WqG0eGgfzb5STSsb44VzOIRrSk2A8r10SxTE5Ysl2HahYHZO18LZmWYCnqjVJ7UTmCBxwRpb5OVIVcp9A==}}']";
1806     string apiStr1 = "[URL] ['json(https://etheraffle.com/api/a).m','{\"r\":\"";
1807     string apiStr2 = "\",\"k\":${[decrypt] BLQNU9ZQxS6ardpB9gmUfVKwKhxSF2MmyB7sh2gmQFH49VewFs52EgaYId5KVEkYuNCP0S2ppzDmiN/5JUzHGTPpkPuTAZdx/ydBCcRMcuuqxg4lSpvtG3oB6zvXfTcCVjGMPbep}}']";
1808 
1809     mapping (uint => rafStruct) public raffle;
1810     struct rafStruct {
1811         mapping (address => uint[][]) entries;
1812         uint unclaimed;
1813         uint[] winNums;
1814         uint[] winAmts;
1815         uint timeStamp;
1816         bool wdrawOpen;
1817         uint numEntries;
1818         uint freeEntries;
1819     }
1820 
1821     mapping (bytes32 => qIDStruct) public qID;
1822     struct qIDStruct {
1823         uint weekNo;
1824         bool isRandom;
1825         bool isManual;
1826     }
1827     /**
1828     * @dev  Modifier to prepend to functions adding the additional
1829     *       conditional requiring caller of the method to be the
1830     *       etheraffle address.
1831     */
1832     modifier onlyEtheraffle() {
1833         require(msg.sender == etheraffle);
1834         _;
1835     }
1836     /**
1837     * @dev  Modifier to prepend to functions adding the additional
1838     *       conditional requiring the paused bool to be false.
1839     */
1840     modifier onlyIfNotPaused() {
1841         require(!paused);
1842         _;
1843     }
1844     event LogFunctionsPaused(uint identifier, uint atTime);
1845     event LogQuerySent(bytes32 queryID, uint dueAt, uint sendTime);
1846     event LogReclaim(uint indexed fromRaffle, uint amount, uint atTime);
1847     event LogUpgrade(address newContract, uint ethTransferred, uint atTime);
1848     event LogPrizePoolAddition(address fromWhom, uint howMuch, uint atTime);
1849     event LogOraclizeCallback(bytes32 queryID, string result, uint indexed forRaffle, uint atTime);
1850     event LogFundsDisbursed(uint indexed forRaffle, uint oraclizeTotal, uint amount, address indexed toAddress, uint atTime);
1851     event LogWithdraw(uint indexed forRaffle, address indexed toWhom, uint forEntryNumber, uint matches, uint amountWon, uint atTime);
1852     event LogWinningNumbers(uint indexed forRaffle, uint numberOfEntries, uint[] wNumbers, uint currentPrizePool, uint randomSerialNo, uint atTime);
1853     event LogTicketBought(uint indexed forRaffle, uint indexed entryNumber, address indexed theEntrant, uint[] chosenNumbers, uint personalEntryNumber, uint tktCost, uint atTime, uint affiliateID);
1854     event LogPrizePoolsUpdated(uint newMainPrizePool, uint indexed forRaffle, uint unclaimedPrizePool, uint threeMatchWinAmt, uint fourMatchWinAmt, uint fiveMatchWinAmt, uint sixMatchwinAmt, uint atTime);
1855     /**
1856      * @dev   Constructor - sets the Etheraffle contract address &
1857      *        the disbursal contract address for investors, calls
1858      *        the newRaffle() function with sets the current
1859      *        raffle ID global var plus sets up the first raffle's
1860      *        struct with correct time stamp. Sets the withdraw
1861      *        before time to a ten week period, and prepares the
1862      *        initial oraclize call which will begin the recursive
1863      *        function.
1864      *
1865      * @param _freeLOT    The address of the Etheraffle FreeLOT special token.
1866      * @param _dsbrs      The address of the Etheraffle disbursal contract.
1867      * @param _msig       The address of the Etheraffle managerial multisig wallet.
1868      * @param _ethRelief  The address of the EthRelief charity contract.
1869      */
1870     function Etheraffle(address _freeLOT, address _dsbrs, address _msig, address _ethRelief) payable {
1871         week         = getWeek();
1872         etheraffle   = _msig;
1873         disburseAddr = _dsbrs;
1874         ethRelief    = _ethRelief;
1875         freeLOT      = FreeLOTInterface(_freeLOT);
1876         uint delay   = (week * weekDur) + birthday + rafEnd + resultsDelay;
1877         raffle[week].timeStamp = (week * weekDur) + birthday;
1878         bytes32 query = oraclize_query(delay, "nested", strConcat(randomStr1, uint2str(getWeek()), randomStr2), gasAmt);
1879         qID[query].weekNo = week;
1880         qID[query].isRandom = true;
1881         LogQuerySent(query, delay, now);
1882     }
1883     /**
1884      * @dev   Function using Etheraffle's birthday to calculate the
1885      *        week number since then.
1886      */
1887     function getWeek() public constant returns (uint) {
1888         uint curWeek = (now - birthday) / weekDur;
1889         if (now - ((curWeek * weekDur) + birthday) > rafEnd) {
1890             curWeek++;
1891         }
1892         return curWeek;
1893     }
1894     /**
1895      * @dev   Function which gets current week number and if different
1896      *        from the global var week number, it updates that and sets
1897      *        up the new raffle struct. Should only be called once a
1898      *        week after the raffle is closed. Should it get called
1899      *        sooner, the contract is paused for inspection.
1900      */
1901     function newRaffle() internal {
1902         uint newWeek = getWeek();
1903         if(newWeek == week) {
1904             pauseContract(4);
1905             return;
1906         } else {//∴ new raffle...
1907             week = newWeek;
1908             raffle[newWeek].timeStamp = birthday + (newWeek * weekDur);
1909         }
1910     }
1911     /**
1912      * @dev  To pause the contract's functions should the need arise. Internal.
1913      *       Logs an event of the pausing.
1914      *
1915      * @param _id    A uint to identify the caller of this function.
1916      */
1917     function pauseContract(uint _id) internal {
1918       paused = true;
1919       LogFunctionsPaused(_id, now);
1920     }
1921     /**
1922      * @dev  Function to enter the raffle. Requires the caller to send ether
1923      *       of amount greater than or equal to the ticket price.
1924      *
1925      * @param _cNums    Ordered array of entrant's six selected numbers.
1926      * @param _affID    Affiliate ID of the source of this entry.
1927      */
1928     function enterRaffle(uint[] _cNums, uint _affID) payable external onlyIfNotPaused {
1929         require(msg.value >= tktPrice);
1930         buyTicket(_cNums, msg.sender, msg.value, _affID);
1931     }
1932     /**
1933      * @dev  Function to enter the raffle for free. Requires the caller's
1934      *       balance of the Etheraffle freeLOT token to be greater than
1935      *       zero. Function destroys one freeLOT token, increments the
1936      *       freeEntries variable in the raffle struct then purchases the
1937      *       ticket.
1938      *
1939      * @param _cNums    Ordered array of entrant's six selected numbers.
1940      * @param _affID    Affiliate ID of the source of this entry.
1941      */
1942     function enterFreeRaffle(uint[] _cNums, uint _affID) payable external onlyIfNotPaused {
1943         freeLOT.destroy(msg.sender, 1);
1944         raffle[week].freeEntries++;
1945         buyTicket(_cNums, msg.sender, msg.value, _affID);
1946     }
1947     /**
1948      * @dev   Function to buy tickets. Internal. Requires the entry number
1949      *        array to be of length 6, requires the timestamp of the current
1950      *        raffle struct to have been set, and for this time this function
1951      *        is call to be before the end of the raffle. Then requires that
1952      *        the chosen numbers are ordered lowest to highest & bound between
1953      *        1 and 49. Function increments the total number of entries in the
1954      *        current raffle's struct, increments the prize pool accordingly
1955      *        and pushes the chosen number array into the entries map and then
1956      *        logs the ticket purchase.
1957      *
1958      * @param _cNums       Array of users selected numbers.
1959      * @param _entrant     Entrant's ethereum address.
1960      * @param _value       The ticket purchase price.
1961      * @param _affID       The affiliate ID of the source of this entry.
1962      */
1963     function buyTicket
1964     (
1965         uint[]  _cNums,
1966         address _entrant,
1967         uint    _value,
1968         uint    _affID
1969     )
1970         internal
1971     {
1972         require
1973         (
1974             _cNums.length == 6 &&
1975             raffle[week].timeStamp > 0 &&
1976             now < raffle[week].timeStamp + rafEnd &&
1977             0         < _cNums[0] &&
1978             _cNums[0] < _cNums[1] &&
1979             _cNums[1] < _cNums[2] &&
1980             _cNums[2] < _cNums[3] &&
1981             _cNums[3] < _cNums[4] &&
1982             _cNums[4] < _cNums[5] &&
1983             _cNums[5] <= 49
1984         );
1985         raffle[week].numEntries++;
1986         prizePool += _value;
1987         raffle[week].entries[_entrant].push(_cNums);
1988         LogTicketBought(week, raffle[week].numEntries, _entrant, _cNums, raffle[week].entries[_entrant].length, _value, now, _affID);
1989     }
1990     /**
1991      * @dev Withdraw Winnings function. User calls this function in order to withdraw
1992      *      whatever winnings they are owed. Function can be paused via the modifier
1993      *      function "onlyIfNotPaused"
1994      *
1995      * @param _week        Week number of the raffle the winning entry is from
1996      * @param _entryNum    The entrants entry number into this raffle
1997      */
1998     function withdrawWinnings(uint _week, uint _entryNum) onlyIfNotPaused external {
1999         require
2000         (
2001             raffle[_week].timeStamp > 0 &&
2002             now - raffle[_week].timeStamp > weekDur - (weekDur / 7) &&
2003             now - raffle[_week].timeStamp < wdrawBfr &&
2004             raffle[_week].wdrawOpen == true &&
2005             raffle[_week].entries[msg.sender][_entryNum - 1].length == 6
2006         );
2007         uint matches = getMatches(_week, msg.sender, _entryNum);
2008         require
2009         (
2010             matches >= 3 &&
2011             raffle[_week].winAmts[matches - 3] > 0 &&
2012             raffle[_week].winAmts[matches - 3] <= this.balance
2013         );
2014         raffle[_week].entries[msg.sender][_entryNum - 1].push(0);
2015         if(raffle[_week].winAmts[matches - 3] <= raffle[_week].unclaimed) {
2016             raffle[_week].unclaimed -= raffle[_week].winAmts[matches - 3];
2017         } else {
2018             raffle[_week].unclaimed = 0;
2019             pauseContract(5);
2020         }
2021         msg.sender.transfer(raffle[_week].winAmts[matches - 3]);
2022         LogWithdraw(_week, msg.sender, _entryNum, matches, raffle[_week].winAmts[matches - 3], now);
2023     }
2024 
2025     /**
2026      * @dev    Called by the weekly oraclize callback. Checks raffle 10
2027      *         weeks older than current raffle for any unclaimed prize
2028      *         pool. If any found, returns it to the main prizePool and
2029      *         zeros the amount.
2030      */
2031     function reclaimUnclaimed() internal {
2032         uint old = getWeek() - 11;
2033         prizePool += raffle[old].unclaimed;
2034         LogReclaim(old, raffle[old].unclaimed, now);
2035     }
2036     /**
2037      * @dev  Function totals up oraclize cost for the raffle, subtracts
2038      *       it from the prizepool (if less than, if greater than if
2039      *       pauses the contract and fires an event). Calculates profit
2040      *       based on raffle's tickets sales and the take percentage,
2041      *       then forwards that amount of ether to the disbursal contract.
2042      *
2043      * @param _week   The week number of the raffle in question.
2044      */
2045     function disburseFunds(uint _week) internal {
2046         uint oracTot = 2 * ((gasAmt * gasPrc) + oracCost);//2 queries per draw...
2047         if(oracTot > prizePool) {
2048           pauseContract(1);
2049           return;
2050         }
2051         prizePool -= oracTot;
2052         uint profit;
2053         if(raffle[_week].numEntries > 0) {
2054             profit = ((raffle[_week].numEntries - raffle[_week].freeEntries) * tktPrice * take) / 1000;
2055             prizePool -= profit;
2056             uint half = profit / 2;
2057             ReceiverInterface(disburseAddr).receiveEther.value(half)();
2058             ReceiverInterface(ethRelief).receiveEther.value(profit - half)();
2059             LogFundsDisbursed(_week, oracTot, profit - half, ethRelief, now);
2060             LogFundsDisbursed(_week, oracTot, half, disburseAddr, now);
2061             return;
2062         }
2063         LogFundsDisbursed(_week, oracTot, profit, 0, now);
2064         return;
2065     }
2066     /**
2067      * @dev   The Oralize call back function. The oracalize api calls are
2068      *        recursive. One to random.org for the draw and the other to
2069      *        the Etheraffle api for the numbers of matches each entry made
2070      *        against the winning numbers. Each calls the other recursively.
2071      *        The former when calledback closes and reclaims any unclaimed
2072      *        prizepool from the raffle ten weeks previous to now. Then it
2073      *        disburses profit to the disbursal contract, then it sets the
2074      *        winning numbers received from random.org into the raffle
2075      *        struct. Finally it prepares the next oraclize call. Which
2076      *        latter callback first sets up the new raffle struct, then
2077      *        sets the payouts based on the number of winners in each tier
2078      *        returned from the api call, then prepares the next oraclize
2079      *        query for a week later to draw the next raffle's winning
2080      *        numbers.
2081      *
2082      * @param _myID     bytes32 - Unique id oraclize provides with their
2083      *                            callbacks.
2084      * @param _result   string - The result of the api call.
2085      */
2086     function __callback(bytes32 _myID, string _result) onlyIfNotPaused {
2087         require(msg.sender == oraclize_cbAddress());
2088         LogOraclizeCallback(_myID, _result, qID[_myID].weekNo, now);
2089         if(qID[_myID].isRandom == true){//is random callback...
2090             reclaimUnclaimed();
2091             disburseFunds(qID[_myID].weekNo);
2092             setWinningNumbers(qID[_myID].weekNo, _result);
2093             if(qID[_myID].isManual == true) { return; }
2094             bytes32 query = oraclize_query(matchesDelay, "nested", strConcat(apiStr1, uint2str(qID[_myID].weekNo), apiStr2), gasAmt);
2095             qID[query].weekNo = qID[_myID].weekNo;
2096             LogQuerySent(query, matchesDelay + now, now);
2097         } else {//is api callback
2098             newRaffle();
2099             setPayOuts(qID[_myID].weekNo, _result);
2100             if(qID[_myID].isManual == true) { return; }
2101             uint delay = (getWeek() * weekDur) + birthday + rafEnd + resultsDelay;
2102             query = oraclize_query(delay, "nested", strConcat(randomStr1, uint2str(getWeek()), randomStr2), gasAmt);
2103             qID[query].weekNo = getWeek();
2104             qID[query].isRandom = true;
2105             LogQuerySent(query, delay, now);
2106         }
2107     }
2108     /**
2109      * @dev   Slices a string according to specified delimiter, returning
2110      *        the sliced parts in an array.
2111      *
2112      * @param _string   The string to be sliced.
2113      */
2114     function stringToArray(string _string) internal returns (string[]) {
2115         var str    = _string.toSlice();
2116         var delim  = ",".toSlice();
2117         var parts  = new string[](str.count(delim) + 1);
2118         for(uint i = 0; i < parts.length; i++) {
2119             parts[i] = str.split(delim).toString();
2120         }
2121         return parts;
2122     }
2123     /**
2124      * @dev   Takes oraclize random.org api call result string and splits
2125      *        it at the commas into an array, parses those strings in that
2126      *        array as integers and pushes them into the winning numbers
2127      *        array in the raffle's struct. Fires event logging the data,
2128      *        including the serial number of the random.org callback so
2129      *        its veracity can be proven.
2130      *
2131      * @param _week    The week number of the raffle in question.
2132      * @param _result   The results string from oraclize callback.
2133      */
2134     function setWinningNumbers(uint _week, string _result) internal {
2135         string[] memory arr = stringToArray(_result);
2136         for(uint i = 0; i < arr.length; i++){
2137             raffle[_week].winNums.push(parseInt(arr[i]));
2138         }
2139         uint serialNo = parseInt(arr[6]);
2140         LogWinningNumbers(_week, raffle[_week].numEntries, raffle[_week].winNums, prizePool, serialNo, now);
2141     }
2142 
2143     /**
2144      * @dev   Takes the results of the oraclize Etheraffle api call back
2145      *        and uses them to calculate the prizes due to each tier
2146      *        (3 matches, 4 matches etc) then pushes them into the winning
2147      *        amounts array in the raffle in question's struct. Calculates
2148      *        the total winnings of the raffle, subtracts it from the
2149      *        global prize pool sequesters that amount into the raffle's
2150      *        struct "unclaimed" variable, ∴ "rolling over" the unwon
2151      *        ether. Enables winner withdrawals by setting the withdraw
2152      *        open bool to true.
2153      *
2154      * @param _week    The week number of the raffle in question.
2155      * @param _result  The results string from oraclize callback.
2156      */
2157     function setPayOuts(uint _week, string _result) internal {
2158         string[] memory numWinnersStr = stringToArray(_result);
2159         if(numWinnersStr.length < 4) {
2160           pauseContract(2);
2161           return;
2162         }
2163         uint[] memory numWinnersInt = new uint[](4);
2164         for (uint i = 0; i < 4; i++) {
2165             numWinnersInt[i] = parseInt(numWinnersStr[i]);
2166         }
2167         uint[] memory payOuts = new uint[](4);
2168         uint total;
2169         for(i = 0; i < 4; i++) {
2170             if(numWinnersInt[i] != 0) {
2171                 payOuts[i] = (prizePool * pctOfPool[i]) / (numWinnersInt[i] * 1000);
2172                 total += payOuts[i] * numWinnersInt[i];
2173             }
2174         }
2175         raffle[_week].unclaimed = total;
2176         if(raffle[_week].unclaimed > prizePool) {
2177           pauseContract(3);
2178           return;
2179         }
2180         prizePool -= raffle[_week].unclaimed;
2181         for(i = 0; i < payOuts.length; i++) {
2182             raffle[_week].winAmts.push(payOuts[i]);
2183         }
2184         raffle[_week].wdrawOpen = true;
2185         LogPrizePoolsUpdated(prizePool, _week, raffle[_week].unclaimed, payOuts[0], payOuts[1], payOuts[2], payOuts[3], now);
2186     }
2187     /**
2188      * @dev   Function compares array of entrant's 6 chosen numbers to
2189       *       the raffle in question's winning numbers, counting how
2190       *       many matches there are.
2191       *
2192       * @param _week         The week number of the Raffle in question
2193       * @param _entrant      Entrant's ethereum address
2194       * @param _entryNum     number of entrant's entry in question.
2195      */
2196     function getMatches(uint _week, address _entrant, uint _entryNum) constant internal returns (uint) {
2197         uint matches;
2198         for(uint i = 0; i < 6; i++) {
2199             for(uint j = 0; j < 6; j++) {
2200                 if(raffle[_week].entries[_entrant][_entryNum - 1][i] == raffle[_week].winNums[j]) {
2201                     matches++;
2202                     break;
2203                 }
2204             }
2205         }
2206         return matches;
2207     }
2208     /**
2209      * @dev     Manually make an Oraclize API call, incase of automation
2210      *          failure. Only callable by the Etheraffle address.
2211      *
2212      * @param _delay      Either a time in seconds before desired callback
2213      *                    time for the API call, or a future UTC format time for
2214      *                    the desired time for the API callback.
2215      * @param _week       The week number this query is for.
2216      * @param _isRandom   Whether or not the api call being made is for
2217      *                    the random.org results draw, or for the Etheraffle
2218      *                    API results call.
2219      * @param _isManual   The Oraclize call back is a recursive function in
2220      *                    which each call fires off another call in perpetuity.
2221      *                    This bool allows that recursiveness for this call to be
2222      *                    turned on or off depending on caller's requirements.
2223      */
2224     function manuallyMakeOraclizeCall
2225     (
2226         uint _week,
2227         uint _delay,
2228         bool _isRandom,
2229         bool _isManual
2230     )
2231         onlyEtheraffle external
2232     {
2233         string memory weekNumStr = uint2str(_week);
2234         if(_isRandom == true){
2235             bytes32 query = oraclize_query(_delay, "nested", strConcat(randomStr1, weekNumStr, randomStr2), gasAmt);
2236             qID[query].weekNo   = _week;
2237             qID[query].isRandom = true;
2238             qID[query].isManual = _isManual;
2239         } else {
2240             query = oraclize_query(_delay, "nested", strConcat(apiStr1, weekNumStr, apiStr2), gasAmt);
2241             qID[query].weekNo   = _week;
2242             qID[query].isManual = _isManual;
2243         }
2244     }
2245     /**
2246      * @dev Set the gas relevant price parameters for the Oraclize calls, in case
2247      *      of future needs for higher gas prices for adequate transaction times,
2248      *      or incase of Oraclize price hikes. Only callable be the Etheraffle
2249      *      address.
2250      *
2251      * @param _newAmt    uint - new allowed gas amount for Oraclize.
2252      * @param _newPrice  uint - new gas price for Oraclize.
2253      * @param _newCost   uint - new cose of Oraclize service.
2254      *
2255      */
2256     function setGasForOraclize
2257     (
2258         uint _newAmt,
2259         uint _newCost,
2260         uint _newPrice
2261     )
2262         onlyEtheraffle external
2263     {
2264         gasAmt   = _newAmt;
2265         oracCost = _newCost;
2266         if(_newPrice > 0) {
2267             oraclize_setCustomGasPrice(_newPrice);
2268             gasPrc = _newPrice;
2269         }
2270     }
2271     /**
2272      * @dev    Set the Oraclize strings, in case of url changes. Only callable by
2273      *         the Etheraffle address  .
2274      *
2275      * @param _newRandomHalfOne       string - with properly escaped characters for
2276      *                                the first half of the random.org call string.
2277      * @param _newRandomHalfTwo       string - with properly escaped characters for
2278      *                                the second half of the random.org call string.
2279      * @param _newEtheraffleHalfOne   string - with properly escaped characters for
2280      *                                the first half of the EtheraffleAPI call string.
2281      * @param _newEtheraffleHalfTwo   string - with properly escaped characters for
2282      *                                the second half of the EtheraffleAPI call string.
2283      *
2284      */
2285     function setOraclizeString
2286     (
2287         string _newRandomHalfOne,
2288         string _newRandomHalfTwo,
2289         string _newEtheraffleHalfOne,
2290         string _newEtheraffleHalfTwo
2291     )
2292         onlyEtheraffle external
2293     {
2294         randomStr1 = _newRandomHalfOne;
2295         randomStr2 = _newRandomHalfTwo;
2296         apiStr1    = _newEtheraffleHalfOne;
2297         apiStr2    = _newEtheraffleHalfTwo;
2298     }
2299     /**
2300      * @dev   Set the ticket price of the raffle. Only callable by the
2301      *        Etheraffle address.
2302      *
2303      * @param _newPrice   uint - The desired new ticket price.
2304      *
2305      */
2306     function setTktPrice(uint _newPrice) onlyEtheraffle external {
2307         tktPrice = _newPrice;
2308     }
2309     /**
2310      * @dev    Set new take percentage. Only callable by the Etheraffle
2311      *         address.
2312      *
2313      * @param _newTake   uint - The desired new take, parts per thousand.
2314      *
2315      */
2316     function setTake(uint _newTake) onlyEtheraffle external {
2317         take = _newTake;
2318     }
2319     /**
2320      * @dev     Set the payouts manually, in case of a failed Oraclize call.
2321      *          Only callable by the Etheraffle address.
2322      *
2323      * @param _week         The week number of the raffle to set the payouts for.
2324      * @param _numMatches   Number of matches. Comma-separated STRING of 4
2325      *                      integers long, consisting of the number of 3 match
2326      *                      winners, 4 match winners, 5 & 6 match winners in
2327      *                      that order.
2328      */
2329     function setPayouts(uint _week, string _numMatches) onlyEtheraffle external {
2330         setPayOuts(_week, _numMatches);
2331     }
2332     /**
2333      * @dev   Set the FreeLOT token contract address, in case of future updrades.
2334      *        Only allable by the Etheraffle address.
2335      *
2336      * @param _newAddr   New address of FreeLOT contract.
2337      */
2338     function setFreeLOT(address _newAddr) onlyEtheraffle external {
2339         freeLOT = FreeLOTInterface(_newAddr);
2340       }
2341     /**
2342      * @dev   Set the EthRelief contract address, and gas required to run
2343      *        the receiving function. Only allable by the Etheraffle address.
2344      *
2345      * @param _newAddr   New address of the EthRelief contract.
2346      */
2347     function setEthRelief(address _newAddr) onlyEtheraffle external {
2348         ethRelief = _newAddr;
2349     }
2350     /**
2351      * @dev   Set the dividend contract address, and gas required to run
2352      *        the receive ether function. Only callable by the Etheraffle
2353      *        address.
2354      *
2355      * @param _newAddr   New address of dividend contract.
2356      */
2357     function setDisbursingAddr(address _newAddr) onlyEtheraffle external {
2358         disburseAddr = _newAddr;
2359     }
2360     /**
2361      * @dev   Set the Etheraffle multisig contract address, in case of future
2362      *        upgrades. Only callable by the current Etheraffle address.
2363      *
2364      * @param _newAddr   New address of Etheraffle multisig contract.
2365      */
2366     function setEtheraffle(address _newAddr) onlyEtheraffle external {
2367         etheraffle = _newAddr;
2368     }
2369     /**
2370      * @dev     Set the raffle end time, in number of seconds passed
2371      *          the start time of 00:00am Monday. Only callable by
2372      *          the Etheraffle address.
2373      *
2374      * @param _newTime    The time desired in seconds.
2375      */
2376     function setRafEnd(uint _newTime) onlyEtheraffle external {
2377         rafEnd = _newTime;
2378     }
2379     /**
2380      * @dev     Set the wdrawBfr time - the time a winner has to withdraw
2381      *          their winnings before the unclaimed prizepool is rolled
2382      *          back into the global prizepool. Only callable by the
2383      *          Etheraffle address.
2384      *
2385      * @param _newTime    The time desired in seconds.
2386      */
2387     function setWithdrawBeforeTime(uint _newTime) onlyEtheraffle external {
2388         wdrawBfr = _newTime;
2389     }
2390     /**
2391      * @dev     Set the paused status of the raffles. Only callable by
2392      *          the Etheraffle address.
2393      *
2394      * @param _status    The desired status of the raffles.
2395      */
2396     function setPaused(bool _status) onlyEtheraffle external {
2397         paused = _status;
2398     }
2399     /**
2400      * @dev     Set the percentage-of-prizepool array. Only callable by the
2401      *          Etheraffle address.
2402      *
2403      * @param _newPoP     An array of four integers totalling 1000.
2404      */
2405     function setPercentOfPool(uint[] _newPoP) onlyEtheraffle external {
2406         pctOfPool = _newPoP;
2407     }
2408     /**
2409      * @dev     Get a entrant's number of entries into a specific raffle
2410      *
2411      * @param _week       The week number of the queried raffle.
2412      * @param _entrant    The entrant in question.
2413      */
2414     function getUserNumEntries(address _entrant, uint _week) constant external returns (uint) {
2415         return raffle[_week].entries[_entrant].length;
2416     }
2417     /**
2418      * @dev     Get chosen numbers of an entrant, for a specific raffle.
2419      *          Returns an array.
2420      *
2421      * @param _entrant    The entrant in question's address.
2422      * @param _week       The week number of the queried raffle.
2423      * @param _entryNum   The entrant's entry number in this raffle.
2424      */
2425     function getChosenNumbers(address _entrant, uint _week, uint _entryNum) constant external returns (uint[]) {
2426         return raffle[_week].entries[_entrant][_entryNum-1];
2427     }
2428     /**
2429      * @dev     Get winning details of a raffle, ie, it's winning numbers
2430      *          and the prize amounts. Returns two arrays.
2431      *
2432      * @param _week   The week number of the raffle in question.
2433      */
2434     function getWinningDetails(uint _week) constant external returns (uint[], uint[]) {
2435         return (raffle[_week].winNums, raffle[_week].winAmts);
2436     }
2437     /**
2438      * @dev     Upgrades the Etheraffle contract. Only callable by the
2439      *          Etheraffle address. Calls an addToPrizePool method as
2440      *          per the abstract contract above. Function renders the
2441      *          entry method uncallable, cancels the Oraclize recursion,
2442      *          then zeroes the prizepool and sends the funds to the new
2443      *          contract. Sets a var tracking when upgrade occurred and logs
2444      *          the event.
2445      *
2446      * @param _newAddr   The new contract address.
2447      */
2448     function upgradeContract(address _newAddr) onlyEtheraffle external {
2449         require(upgraded == 0 && upgradeAddr == address(0));
2450         uint amt    = prizePool;
2451         upgradeAddr = _newAddr;
2452         upgraded    = now;
2453         week        = 0;//no struct for this raffle ∴ no timestamp ∴ no entry possible
2454         prizePool   = 0;
2455         gasAmt      = 0;//will arrest the oraclize recursive callbacks
2456         apiStr1     = "";
2457         randomStr1  = "";
2458         require(this.balance >= amt);
2459         EtheraffleUpgrade(_newAddr).addToPrizePool.value(amt)();
2460         LogUpgrade(_newAddr, amt, upgraded);
2461     }
2462     /**
2463      * @dev     Self destruct contract. Only callable by Etheraffle address.
2464      *          function. It deletes all contract code and data and forwards
2465      *          any remaining ether from non-claimed winning raffle tickets
2466      *          to the EthRelief charity contract. Requires the upgrade contract
2467      *          method to have been called 10 or more weeks prior, to allow
2468      *          winning tickets to be claimed within the usual withdrawal time
2469      *          frame.
2470      */
2471     function selfDestruct() onlyEtheraffle external {
2472         require(now - upgraded > weekDur * 10);
2473         selfdestruct(ethRelief);
2474     }
2475     /**
2476      * @dev     Function allowing manual addition to the global prizepool.
2477      *          Requires the caller to send ether.
2478      */
2479     function addToPrizePool() payable external {
2480         require(msg.value > 0);
2481         prizePool += msg.value;
2482         LogPrizePoolAddition(msg.sender, msg.value, now);
2483     }
2484     /**
2485      * @dev   Fallback function.
2486      */
2487     function () payable external {}
2488 }