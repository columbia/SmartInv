1 pragma solidity ^0.5.17;
2 
3 library strings {
4     struct slice {
5         uint _len;
6         uint _ptr;
7     }
8 
9     function memcpy(uint dest, uint src, uint len) private pure {
10         // Copy word-length chunks while possible
11         for(; len >= 32; len -= 32) {
12             assembly {
13                 mstore(dest, mload(src))
14             }
15             dest += 32;
16             src += 32;
17         }
18 
19         // Copy remaining bytes
20         uint mask = 256 ** (32 - len) - 1;
21         assembly {
22             let srcpart := and(mload(src), not(mask))
23             let destpart := and(mload(dest), mask)
24             mstore(dest, or(destpart, srcpart))
25         }
26     }
27 
28     /*
29      * @dev Returns a slice containing the entire string.
30      * @param self The string to make a slice from.
31      * @return A newly allocated slice containing the entire string.
32      */
33     function toSlice(string memory self) internal pure returns (slice memory) {
34         uint ptr;
35         assembly {
36             ptr := add(self, 0x20)
37         }
38         return slice(bytes(self).length, ptr);
39     }
40 
41     /*
42      * @dev Returns the length of a null-terminated bytes32 string.
43      * @param self The value to find the length of.
44      * @return The length of the string, from 0 to 32.
45      */
46     function len(bytes32 self) internal pure returns (uint) {
47         uint ret;
48         if (self == 0)
49             return 0;
50         if (uint(self) & 0xffffffffffffffffffffffffffffffff == 0) {
51             ret += 16;
52             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
53         }
54         if (uint(self) & 0xffffffffffffffff == 0) {
55             ret += 8;
56             self = bytes32(uint(self) / 0x10000000000000000);
57         }
58         if (uint(self) & 0xffffffff == 0) {
59             ret += 4;
60             self = bytes32(uint(self) / 0x100000000);
61         }
62         if (uint(self) & 0xffff == 0) {
63             ret += 2;
64             self = bytes32(uint(self) / 0x10000);
65         }
66         if (uint(self) & 0xff == 0) {
67             ret += 1;
68         }
69         return 32 - ret;
70     }
71 
72     /*
73      * @dev Returns a slice containing the entire bytes32, interpreted as a
74      *      null-terminated utf-8 string.
75      * @param self The bytes32 value to convert to a slice.
76      * @return A new slice containing the value of the input argument up to the
77      *         first null.
78      */
79     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
80         // Allocate space for `self` in memory, copy it there, and point ret at it
81         assembly {
82             let ptr := mload(0x40)
83             mstore(0x40, add(ptr, 0x20))
84             mstore(ptr, self)
85             mstore(add(ret, 0x20), ptr)
86         }
87         ret._len = len(self);
88     }
89 
90     /*
91      * @dev Returns a new slice containing the same data as the current slice.
92      * @param self The slice to copy.
93      * @return A new slice containing the same data as `self`.
94      */
95     function copy(slice memory self) internal pure returns (slice memory) {
96         return slice(self._len, self._ptr);
97     }
98 
99     /*
100      * @dev Copies a slice to a new string.
101      * @param self The slice to copy.
102      * @return A newly allocated string containing the slice's text.
103      */
104     function toString(slice memory self) internal pure returns (string memory) {
105         string memory ret = new string(self._len);
106         uint retptr;
107         assembly { retptr := add(ret, 32) }
108 
109         memcpy(retptr, self._ptr, self._len);
110         return ret;
111     }
112 
113     /*
114      * @dev Returns the length in runes of the slice. Note that this operation
115      *      takes time proportional to the length of the slice; avoid using it
116      *      in loops, and call `slice.empty()` if you only need to know whether
117      *      the slice is empty or not.
118      * @param self The slice to operate on.
119      * @return The length of the slice in runes.
120      */
121     function len(slice memory self) internal pure returns (uint l) {
122         // Starting at ptr-31 means the LSB will be the byte we care about
123         uint ptr = self._ptr - 31;
124         uint end = ptr + self._len;
125         for (l = 0; ptr < end; l++) {
126             uint8 b;
127             assembly { b := and(mload(ptr), 0xFF) }
128             if (b < 0x80) {
129                 ptr += 1;
130             } else if(b < 0xE0) {
131                 ptr += 2;
132             } else if(b < 0xF0) {
133                 ptr += 3;
134             } else if(b < 0xF8) {
135                 ptr += 4;
136             } else if(b < 0xFC) {
137                 ptr += 5;
138             } else {
139                 ptr += 6;
140             }
141         }
142     }
143 
144     /*
145      * @dev Returns true if the slice is empty (has a length of 0).
146      * @param self The slice to operate on.
147      * @return True if the slice is empty, False otherwise.
148      */
149     function empty(slice memory self) internal pure returns (bool) {
150         return self._len == 0;
151     }
152 
153     /*
154      * @dev Returns a positive number if `other` comes lexicographically after
155      *      `self`, a negative number if it comes before, or zero if the
156      *      contents of the two slices are equal. Comparison is done per-rune,
157      *      on unicode codepoints.
158      * @param self The first slice to compare.
159      * @param other The second slice to compare.
160      * @return The result of the comparison.
161      */
162     function compare(slice memory self, slice memory other) internal pure returns (int) {
163         uint shortest = self._len;
164         if (other._len < self._len)
165             shortest = other._len;
166 
167         uint selfptr = self._ptr;
168         uint otherptr = other._ptr;
169         for (uint idx = 0; idx < shortest; idx += 32) {
170             uint a;
171             uint b;
172             assembly {
173                 a := mload(selfptr)
174                 b := mload(otherptr)
175             }
176             if (a != b) {
177                 // Mask out irrelevant bytes and check again
178                 uint256 mask = uint256(-1); // 0xffff...
179                 if(shortest < 32) {
180                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
181                 }
182                 uint256 diff = (a & mask) - (b & mask);
183                 if (diff != 0)
184                     return int(diff);
185             }
186             selfptr += 32;
187             otherptr += 32;
188         }
189         return int(self._len) - int(other._len);
190     }
191 
192     /*
193      * @dev Returns true if the two slices contain the same text.
194      * @param self The first slice to compare.
195      * @param self The second slice to compare.
196      * @return True if the slices are equal, false otherwise.
197      */
198     function equals(slice memory self, slice memory other) internal pure returns (bool) {
199         return compare(self, other) == 0;
200     }
201 
202     /*
203      * @dev Extracts the first rune in the slice into `rune`, advancing the
204      *      slice to point to the next rune and returning `self`.
205      * @param self The slice to operate on.
206      * @param rune The slice that will contain the first rune.
207      * @return `rune`.
208      */
209     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
210         rune._ptr = self._ptr;
211 
212         if (self._len == 0) {
213             rune._len = 0;
214             return rune;
215         }
216 
217         uint l;
218         uint b;
219         // Load the first byte of the rune into the LSBs of b
220         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
221         if (b < 0x80) {
222             l = 1;
223         } else if(b < 0xE0) {
224             l = 2;
225         } else if(b < 0xF0) {
226             l = 3;
227         } else {
228             l = 4;
229         }
230 
231         // Check for truncated codepoints
232         if (l > self._len) {
233             rune._len = self._len;
234             self._ptr += self._len;
235             self._len = 0;
236             return rune;
237         }
238 
239         self._ptr += l;
240         self._len -= l;
241         rune._len = l;
242         return rune;
243     }
244 
245     /*
246      * @dev Returns the first rune in the slice, advancing the slice to point
247      *      to the next rune.
248      * @param self The slice to operate on.
249      * @return A slice containing only the first rune from `self`.
250      */
251     function nextRune(slice memory self) internal pure returns (slice memory ret) {
252         nextRune(self, ret);
253     }
254 
255     /*
256      * @dev Returns the number of the first codepoint in the slice.
257      * @param self The slice to operate on.
258      * @return The number of the first codepoint in the slice.
259      */
260     function ord(slice memory self) internal pure returns (uint ret) {
261         if (self._len == 0) {
262             return 0;
263         }
264 
265         uint word;
266         uint length;
267         uint divisor = 2 ** 248;
268 
269         // Load the rune into the MSBs of b
270         assembly { word:= mload(mload(add(self, 32))) }
271         uint b = word / divisor;
272         if (b < 0x80) {
273             ret = b;
274             length = 1;
275         } else if(b < 0xE0) {
276             ret = b & 0x1F;
277             length = 2;
278         } else if(b < 0xF0) {
279             ret = b & 0x0F;
280             length = 3;
281         } else {
282             ret = b & 0x07;
283             length = 4;
284         }
285 
286         // Check for truncated codepoints
287         if (length > self._len) {
288             return 0;
289         }
290 
291         for (uint i = 1; i < length; i++) {
292             divisor = divisor / 256;
293             b = (word / divisor) & 0xFF;
294             if (b & 0xC0 != 0x80) {
295                 // Invalid UTF-8 sequence
296                 return 0;
297             }
298             ret = (ret * 64) | (b & 0x3F);
299         }
300 
301         return ret;
302     }
303 
304     /*
305      * @dev Returns the keccak-256 hash of the slice.
306      * @param self The slice to hash.
307      * @return The hash of the slice.
308      */
309     function keccak(slice memory self) internal pure returns (bytes32 ret) {
310         assembly {
311             ret := keccak256(mload(add(self, 32)), mload(self))
312         }
313     }
314 
315     /*
316      * @dev Returns true if `self` starts with `needle`.
317      * @param self The slice to operate on.
318      * @param needle The slice to search for.
319      * @return True if the slice starts with the provided text, false otherwise.
320      */
321     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
322         if (self._len < needle._len) {
323             return false;
324         }
325 
326         if (self._ptr == needle._ptr) {
327             return true;
328         }
329 
330         bool equal;
331         assembly {
332             let length := mload(needle)
333             let selfptr := mload(add(self, 0x20))
334             let needleptr := mload(add(needle, 0x20))
335             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
336         }
337         return equal;
338     }
339 
340     /*
341      * @dev If `self` starts with `needle`, `needle` is removed from the
342      *      beginning of `self`. Otherwise, `self` is unmodified.
343      * @param self The slice to operate on.
344      * @param needle The slice to search for.
345      * @return `self`
346      */
347     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
348         if (self._len < needle._len) {
349             return self;
350         }
351 
352         bool equal = true;
353         if (self._ptr != needle._ptr) {
354             assembly {
355                 let length := mload(needle)
356                 let selfptr := mload(add(self, 0x20))
357                 let needleptr := mload(add(needle, 0x20))
358                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
359             }
360         }
361 
362         if (equal) {
363             self._len -= needle._len;
364             self._ptr += needle._len;
365         }
366 
367         return self;
368     }
369 
370     /*
371      * @dev Returns true if the slice ends with `needle`.
372      * @param self The slice to operate on.
373      * @param needle The slice to search for.
374      * @return True if the slice starts with the provided text, false otherwise.
375      */
376     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
377         if (self._len < needle._len) {
378             return false;
379         }
380 
381         uint selfptr = self._ptr + self._len - needle._len;
382 
383         if (selfptr == needle._ptr) {
384             return true;
385         }
386 
387         bool equal;
388         assembly {
389             let length := mload(needle)
390             let needleptr := mload(add(needle, 0x20))
391             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
392         }
393 
394         return equal;
395     }
396 
397     /*
398      * @dev If `self` ends with `needle`, `needle` is removed from the
399      *      end of `self`. Otherwise, `self` is unmodified.
400      * @param self The slice to operate on.
401      * @param needle The slice to search for.
402      * @return `self`
403      */
404     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
405         if (self._len < needle._len) {
406             return self;
407         }
408 
409         uint selfptr = self._ptr + self._len - needle._len;
410         bool equal = true;
411         if (selfptr != needle._ptr) {
412             assembly {
413                 let length := mload(needle)
414                 let needleptr := mload(add(needle, 0x20))
415                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
416             }
417         }
418 
419         if (equal) {
420             self._len -= needle._len;
421         }
422 
423         return self;
424     }
425 
426     // Returns the memory address of the first byte of the first occurrence of
427     // `needle` in `self`, or the first byte after `self` if not found.
428     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
429         uint ptr = selfptr;
430         uint idx;
431 
432         if (needlelen <= selflen) {
433             if (needlelen <= 32) {
434                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
435 
436                 bytes32 needledata;
437                 assembly { needledata := and(mload(needleptr), mask) }
438 
439                 uint end = selfptr + selflen - needlelen;
440                 bytes32 ptrdata;
441                 assembly { ptrdata := and(mload(ptr), mask) }
442 
443                 while (ptrdata != needledata) {
444                     if (ptr >= end)
445                         return selfptr + selflen;
446                     ptr++;
447                     assembly { ptrdata := and(mload(ptr), mask) }
448                 }
449                 return ptr;
450             } else {
451                 // For long needles, use hashing
452                 bytes32 hash;
453                 assembly { hash := keccak256(needleptr, needlelen) }
454 
455                 for (idx = 0; idx <= selflen - needlelen; idx++) {
456                     bytes32 testHash;
457                     assembly { testHash := keccak256(ptr, needlelen) }
458                     if (hash == testHash)
459                         return ptr;
460                     ptr += 1;
461                 }
462             }
463         }
464         return selfptr + selflen;
465     }
466 
467     // Returns the memory address of the first byte after the last occurrence of
468     // `needle` in `self`, or the address of `self` if not found.
469     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
470         uint ptr;
471 
472         if (needlelen <= selflen) {
473             if (needlelen <= 32) {
474                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
475 
476                 bytes32 needledata;
477                 assembly { needledata := and(mload(needleptr), mask) }
478 
479                 ptr = selfptr + selflen - needlelen;
480                 bytes32 ptrdata;
481                 assembly { ptrdata := and(mload(ptr), mask) }
482 
483                 while (ptrdata != needledata) {
484                     if (ptr <= selfptr)
485                         return selfptr;
486                     ptr--;
487                     assembly { ptrdata := and(mload(ptr), mask) }
488                 }
489                 return ptr + needlelen;
490             } else {
491                 // For long needles, use hashing
492                 bytes32 hash;
493                 assembly { hash := keccak256(needleptr, needlelen) }
494                 ptr = selfptr + (selflen - needlelen);
495                 while (ptr >= selfptr) {
496                     bytes32 testHash;
497                     assembly { testHash := keccak256(ptr, needlelen) }
498                     if (hash == testHash)
499                         return ptr + needlelen;
500                     ptr -= 1;
501                 }
502             }
503         }
504         return selfptr;
505     }
506 
507     /*
508      * @dev Modifies `self` to contain everything from the first occurrence of
509      *      `needle` to the end of the slice. `self` is set to the empty slice
510      *      if `needle` is not found.
511      * @param self The slice to search and modify.
512      * @param needle The text to search for.
513      * @return `self`.
514      */
515     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
516         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
517         self._len -= ptr - self._ptr;
518         self._ptr = ptr;
519         return self;
520     }
521 
522     /*
523      * @dev Modifies `self` to contain the part of the string from the start of
524      *      `self` to the end of the first occurrence of `needle`. If `needle`
525      *      is not found, `self` is set to the empty slice.
526      * @param self The slice to search and modify.
527      * @param needle The text to search for.
528      * @return `self`.
529      */
530     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
531         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
532         self._len = ptr - self._ptr;
533         return self;
534     }
535 
536     /*
537      * @dev Splits the slice, setting `self` to everything after the first
538      *      occurrence of `needle`, and `token` to everything before it. If
539      *      `needle` does not occur in `self`, `self` is set to the empty slice,
540      *      and `token` is set to the entirety of `self`.
541      * @param self The slice to split.
542      * @param needle The text to search for in `self`.
543      * @param token An output parameter to which the first token is written.
544      * @return `token`.
545      */
546     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
547         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
548         token._ptr = self._ptr;
549         token._len = ptr - self._ptr;
550         if (ptr == self._ptr + self._len) {
551             // Not found
552             self._len = 0;
553         } else {
554             self._len -= token._len + needle._len;
555             self._ptr = ptr + needle._len;
556         }
557         return token;
558     }
559 
560     /*
561      * @dev Splits the slice, setting `self` to everything after the first
562      *      occurrence of `needle`, and returning everything before it. If
563      *      `needle` does not occur in `self`, `self` is set to the empty slice,
564      *      and the entirety of `self` is returned.
565      * @param self The slice to split.
566      * @param needle The text to search for in `self`.
567      * @return The part of `self` up to the first occurrence of `delim`.
568      */
569     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
570         split(self, needle, token);
571     }
572 
573     /*
574      * @dev Splits the slice, setting `self` to everything before the last
575      *      occurrence of `needle`, and `token` to everything after it. If
576      *      `needle` does not occur in `self`, `self` is set to the empty slice,
577      *      and `token` is set to the entirety of `self`.
578      * @param self The slice to split.
579      * @param needle The text to search for in `self`.
580      * @param token An output parameter to which the first token is written.
581      * @return `token`.
582      */
583     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
584         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
585         token._ptr = ptr;
586         token._len = self._len - (ptr - self._ptr);
587         if (ptr == self._ptr) {
588             // Not found
589             self._len = 0;
590         } else {
591             self._len -= token._len + needle._len;
592         }
593         return token;
594     }
595 
596     /*
597      * @dev Splits the slice, setting `self` to everything before the last
598      *      occurrence of `needle`, and returning everything after it. If
599      *      `needle` does not occur in `self`, `self` is set to the empty slice,
600      *      and the entirety of `self` is returned.
601      * @param self The slice to split.
602      * @param needle The text to search for in `self`.
603      * @return The part of `self` after the last occurrence of `delim`.
604      */
605     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
606         rsplit(self, needle, token);
607     }
608 
609     /*
610      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
611      * @param self The slice to search.
612      * @param needle The text to search for in `self`.
613      * @return The number of occurrences of `needle` found in `self`.
614      */
615     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
616         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
617         while (ptr <= self._ptr + self._len) {
618             cnt++;
619             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
620         }
621     }
622 
623     /*
624      * @dev Returns True if `self` contains `needle`.
625      * @param self The slice to search.
626      * @param needle The text to search for in `self`.
627      * @return True if `needle` is found in `self`, false otherwise.
628      */
629     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
630         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
631     }
632 
633     /*
634      * @dev Returns a newly allocated string containing the concatenation of
635      *      `self` and `other`.
636      * @param self The first slice to concatenate.
637      * @param other The second slice to concatenate.
638      * @return The concatenation of the two strings.
639      */
640     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
641         string memory ret = new string(self._len + other._len);
642         uint retptr;
643         assembly { retptr := add(ret, 32) }
644         memcpy(retptr, self._ptr, self._len);
645         memcpy(retptr + self._len, other._ptr, other._len);
646         return ret;
647     }
648 
649     /*
650      * @dev Joins an array of slices, using `self` as a delimiter, returning a
651      *      newly allocated string.
652      * @param self The delimiter to use.
653      * @param parts A list of slices to join.
654      * @return A newly allocated string containing all the slices in `parts`,
655      *         joined with `self`.
656      */
657     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
658         if (parts.length == 0)
659             return "";
660 
661         uint length = self._len * (parts.length - 1);
662         for(uint i = 0; i < parts.length; i++)
663             length += parts[i]._len;
664 
665         string memory ret = new string(length);
666         uint retptr;
667         assembly { retptr := add(ret, 32) }
668 
669         for(uint i = 0; i < parts.length; i++) {
670             memcpy(retptr, parts[i]._ptr, parts[i]._len);
671             retptr += parts[i]._len;
672             if (i < parts.length - 1) {
673                 memcpy(retptr, self._ptr, self._len);
674                 retptr += self._len;
675             }
676         }
677 
678         return ret;
679     }
680 }
681 
682 library BytesLib {
683     function concat(
684         bytes memory _preBytes,
685         bytes memory _postBytes
686     )
687         internal
688         pure
689         returns (bytes memory)
690     {
691         bytes memory tempBytes;
692 
693         assembly {
694             // Get a location of some free memory and store it in tempBytes as
695             // Solidity does for memory variables.
696             tempBytes := mload(0x40)
697 
698             // Store the length of the first bytes array at the beginning of
699             // the memory for tempBytes.
700             let length := mload(_preBytes)
701             mstore(tempBytes, length)
702 
703             // Maintain a memory counter for the current write location in the
704             // temp bytes array by adding the 32 bytes for the array length to
705             // the starting location.
706             let mc := add(tempBytes, 0x20)
707             // Stop copying when the memory counter reaches the length of the
708             // first bytes array.
709             let end := add(mc, length)
710 
711             for {
712                 // Initialize a copy counter to the start of the _preBytes data,
713                 // 32 bytes into its memory.
714                 let cc := add(_preBytes, 0x20)
715             } lt(mc, end) {
716                 // Increase both counters by 32 bytes each iteration.
717                 mc := add(mc, 0x20)
718                 cc := add(cc, 0x20)
719             } {
720                 // Write the _preBytes data into the tempBytes memory 32 bytes
721                 // at a time.
722                 mstore(mc, mload(cc))
723             }
724 
725             // Add the length of _postBytes to the current length of tempBytes
726             // and store it as the new length in the first 32 bytes of the
727             // tempBytes memory.
728             length := mload(_postBytes)
729             mstore(tempBytes, add(length, mload(tempBytes)))
730 
731             // Move the memory counter back from a multiple of 0x20 to the
732             // actual end of the _preBytes data.
733             mc := end
734             // Stop copying when the memory counter reaches the new combined
735             // length of the arrays.
736             end := add(mc, length)
737 
738             for {
739                 let cc := add(_postBytes, 0x20)
740             } lt(mc, end) {
741                 mc := add(mc, 0x20)
742                 cc := add(cc, 0x20)
743             } {
744                 mstore(mc, mload(cc))
745             }
746 
747             // Update the free-memory pointer by padding our last write location
748             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
749             // next 32 byte block, then round down to the nearest multiple of
750             // 32. If the sum of the length of the two arrays is zero then add 
751             // one before rounding down to leave a blank 32 bytes (the length block with 0).
752             mstore(0x40, and(
753               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
754               not(31) // Round down to the nearest 32 bytes.
755             ))
756         }
757 
758         return tempBytes;
759     }
760 
761     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
762         assembly {
763             // Read the first 32 bytes of _preBytes storage, which is the length
764             // of the array. (We don't need to use the offset into the slot
765             // because arrays use the entire slot.)
766             let fslot := sload(_preBytes_slot)
767             // Arrays of 31 bytes or less have an even value in their slot,
768             // while longer arrays have an odd value. The actual length is
769             // the slot divided by two for odd values, and the lowest order
770             // byte divided by two for even values.
771             // If the slot is even, bitwise and the slot with 255 and divide by
772             // two to get the length. If the slot is odd, bitwise and the slot
773             // with -1 and divide by two.
774             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
775             let mlength := mload(_postBytes)
776             let newlength := add(slength, mlength)
777             // slength can contain both the length and contents of the array
778             // if length < 32 bytes so let's prepare for that
779             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
780             switch add(lt(slength, 32), lt(newlength, 32))
781             case 2 {
782                 // Since the new array still fits in the slot, we just need to
783                 // update the contents of the slot.
784                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
785                 sstore(
786                     _preBytes_slot,
787                     // all the modifications to the slot are inside this
788                     // next block
789                     add(
790                         // we can just add to the slot contents because the
791                         // bytes we want to change are the LSBs
792                         fslot,
793                         add(
794                             mul(
795                                 div(
796                                     // load the bytes from memory
797                                     mload(add(_postBytes, 0x20)),
798                                     // zero all bytes to the right
799                                     exp(0x100, sub(32, mlength))
800                                 ),
801                                 // and now shift left the number of bytes to
802                                 // leave space for the length in the slot
803                                 exp(0x100, sub(32, newlength))
804                             ),
805                             // increase length by the double of the memory
806                             // bytes length
807                             mul(mlength, 2)
808                         )
809                     )
810                 )
811             }
812             case 1 {
813                 // The stored value fits in the slot, but the combined value
814                 // will exceed it.
815                 // get the keccak hash to get the contents of the array
816                 mstore(0x0, _preBytes_slot)
817                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
818 
819                 // save new length
820                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
821 
822                 // The contents of the _postBytes array start 32 bytes into
823                 // the structure. Our first read should obtain the `submod`
824                 // bytes that can fit into the unused space in the last word
825                 // of the stored array. To get this, we read 32 bytes starting
826                 // from `submod`, so the data we read overlaps with the array
827                 // contents by `submod` bytes. Masking the lowest-order
828                 // `submod` bytes allows us to add that value directly to the
829                 // stored value.
830 
831                 let submod := sub(32, slength)
832                 let mc := add(_postBytes, submod)
833                 let end := add(_postBytes, mlength)
834                 let mask := sub(exp(0x100, submod), 1)
835 
836                 sstore(
837                     sc,
838                     add(
839                         and(
840                             fslot,
841                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
842                         ),
843                         and(mload(mc), mask)
844                     )
845                 )
846 
847                 for {
848                     mc := add(mc, 0x20)
849                     sc := add(sc, 1)
850                 } lt(mc, end) {
851                     sc := add(sc, 1)
852                     mc := add(mc, 0x20)
853                 } {
854                     sstore(sc, mload(mc))
855                 }
856 
857                 mask := exp(0x100, sub(mc, end))
858 
859                 sstore(sc, mul(div(mload(mc), mask), mask))
860             }
861             default {
862                 // get the keccak hash to get the contents of the array
863                 mstore(0x0, _preBytes_slot)
864                 // Start copying to the last used word of the stored array.
865                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
866 
867                 // save new length
868                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
869 
870                 // Copy over the first `submod` bytes of the new data as in
871                 // case 1 above.
872                 let slengthmod := mod(slength, 32)
873                 let mlengthmod := mod(mlength, 32)
874                 let submod := sub(32, slengthmod)
875                 let mc := add(_postBytes, submod)
876                 let end := add(_postBytes, mlength)
877                 let mask := sub(exp(0x100, submod), 1)
878 
879                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
880                 
881                 for { 
882                     sc := add(sc, 1)
883                     mc := add(mc, 0x20)
884                 } lt(mc, end) {
885                     sc := add(sc, 1)
886                     mc := add(mc, 0x20)
887                 } {
888                     sstore(sc, mload(mc))
889                 }
890 
891                 mask := exp(0x100, sub(mc, end))
892 
893                 sstore(sc, mul(div(mload(mc), mask), mask))
894             }
895         }
896     }
897 
898     function slice(
899         bytes memory _bytes,
900         uint _start,
901         uint _length
902     )
903         internal
904         pure
905         returns (bytes memory)
906     {
907         require(_bytes.length >= (_start + _length));
908 
909         bytes memory tempBytes;
910 
911         assembly {
912             switch iszero(_length)
913             case 0 {
914                 // Get a location of some free memory and store it in tempBytes as
915                 // Solidity does for memory variables.
916                 tempBytes := mload(0x40)
917 
918                 // The first word of the slice result is potentially a partial
919                 // word read from the original array. To read it, we calculate
920                 // the length of that partial word and start copying that many
921                 // bytes into the array. The first word we copy will start with
922                 // data we don't care about, but the last `lengthmod` bytes will
923                 // land at the beginning of the contents of the new array. When
924                 // we're done copying, we overwrite the full first word with
925                 // the actual length of the slice.
926                 let lengthmod := and(_length, 31)
927 
928                 // The multiplication in the next line is necessary
929                 // because when slicing multiples of 32 bytes (lengthmod == 0)
930                 // the following copy loop was copying the origin's length
931                 // and then ending prematurely not copying everything it should.
932                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
933                 let end := add(mc, _length)
934 
935                 for {
936                     // The multiplication in the next line has the same exact purpose
937                     // as the one above.
938                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
939                 } lt(mc, end) {
940                     mc := add(mc, 0x20)
941                     cc := add(cc, 0x20)
942                 } {
943                     mstore(mc, mload(cc))
944                 }
945 
946                 mstore(tempBytes, _length)
947 
948                 //update free-memory pointer
949                 //allocating the array padded to 32 bytes like the compiler does now
950                 mstore(0x40, and(add(mc, 31), not(31)))
951             }
952             //if we want a zero-length slice let's just return a zero-length array
953             default {
954                 tempBytes := mload(0x40)
955 
956                 mstore(0x40, add(tempBytes, 0x20))
957             }
958         }
959 
960         return tempBytes;
961     }
962 
963     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
964         require(_bytes.length >= (_start + 20));
965         address tempAddress;
966 
967         assembly {
968             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
969         }
970 
971         return tempAddress;
972     }
973 
974     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
975         require(_bytes.length >= (_start + 1));
976         uint8 tempUint;
977 
978         assembly {
979             tempUint := mload(add(add(_bytes, 0x1), _start))
980         }
981 
982         return tempUint;
983     }
984 
985     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
986         require(_bytes.length >= (_start + 2));
987         uint16 tempUint;
988 
989         assembly {
990             tempUint := mload(add(add(_bytes, 0x2), _start))
991         }
992 
993         return tempUint;
994     }
995 
996     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
997         require(_bytes.length >= (_start + 4));
998         uint32 tempUint;
999 
1000         assembly {
1001             tempUint := mload(add(add(_bytes, 0x4), _start))
1002         }
1003 
1004         return tempUint;
1005     }
1006 
1007     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
1008         require(_bytes.length >= (_start + 8));
1009         uint64 tempUint;
1010 
1011         assembly {
1012             tempUint := mload(add(add(_bytes, 0x8), _start))
1013         }
1014 
1015         return tempUint;
1016     }
1017 
1018     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
1019         require(_bytes.length >= (_start + 12));
1020         uint96 tempUint;
1021 
1022         assembly {
1023             tempUint := mload(add(add(_bytes, 0xc), _start))
1024         }
1025 
1026         return tempUint;
1027     }
1028 
1029     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
1030         require(_bytes.length >= (_start + 16));
1031         uint128 tempUint;
1032 
1033         assembly {
1034             tempUint := mload(add(add(_bytes, 0x10), _start))
1035         }
1036 
1037         return tempUint;
1038     }
1039 
1040     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
1041         require(_bytes.length >= (_start + 32));
1042         uint256 tempUint;
1043 
1044         assembly {
1045             tempUint := mload(add(add(_bytes, 0x20), _start))
1046         }
1047 
1048         return tempUint;
1049     }
1050 
1051     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
1052         require(_bytes.length >= (_start + 32));
1053         bytes32 tempBytes32;
1054 
1055         assembly {
1056             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
1057         }
1058 
1059         return tempBytes32;
1060     }
1061 
1062     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
1063         bool success = true;
1064 
1065         assembly {
1066             let length := mload(_preBytes)
1067 
1068             // if lengths don't match the arrays are not equal
1069             switch eq(length, mload(_postBytes))
1070             case 1 {
1071                 // cb is a circuit breaker in the for loop since there's
1072                 //  no said feature for inline assembly loops
1073                 // cb = 1 - don't breaker
1074                 // cb = 0 - break
1075                 let cb := 1
1076 
1077                 let mc := add(_preBytes, 0x20)
1078                 let end := add(mc, length)
1079 
1080                 for {
1081                     let cc := add(_postBytes, 0x20)
1082                 // the next line is the loop condition:
1083                 // while(uint(mc < end) + cb == 2)
1084                 } eq(add(lt(mc, end), cb), 2) {
1085                     mc := add(mc, 0x20)
1086                     cc := add(cc, 0x20)
1087                 } {
1088                     // if any of these checks fails then arrays are not equal
1089                     if iszero(eq(mload(mc), mload(cc))) {
1090                         // unsuccess:
1091                         success := 0
1092                         cb := 0
1093                     }
1094                 }
1095             }
1096             default {
1097                 // unsuccess:
1098                 success := 0
1099             }
1100         }
1101 
1102         return success;
1103     }
1104 
1105     function equalStorage(
1106         bytes storage _preBytes,
1107         bytes memory _postBytes
1108     )
1109         internal
1110         view
1111         returns (bool)
1112     {
1113         bool success = true;
1114 
1115         assembly {
1116             // we know _preBytes_offset is 0
1117             let fslot := sload(_preBytes_slot)
1118             // Decode the length of the stored array like in concatStorage().
1119             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
1120             let mlength := mload(_postBytes)
1121 
1122             // if lengths don't match the arrays are not equal
1123             switch eq(slength, mlength)
1124             case 1 {
1125                 // slength can contain both the length and contents of the array
1126                 // if length < 32 bytes so let's prepare for that
1127                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
1128                 if iszero(iszero(slength)) {
1129                     switch lt(slength, 32)
1130                     case 1 {
1131                         // blank the last byte which is the length
1132                         fslot := mul(div(fslot, 0x100), 0x100)
1133 
1134                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
1135                             // unsuccess:
1136                             success := 0
1137                         }
1138                     }
1139                     default {
1140                         // cb is a circuit breaker in the for loop since there's
1141                         //  no said feature for inline assembly loops
1142                         // cb = 1 - don't breaker
1143                         // cb = 0 - break
1144                         let cb := 1
1145 
1146                         // get the keccak hash to get the contents of the array
1147                         mstore(0x0, _preBytes_slot)
1148                         let sc := keccak256(0x0, 0x20)
1149 
1150                         let mc := add(_postBytes, 0x20)
1151                         let end := add(mc, mlength)
1152 
1153                         // the next line is the loop condition:
1154                         // while(uint(mc < end) + cb == 2)
1155                         for {} eq(add(lt(mc, end), cb), 2) {
1156                             sc := add(sc, 1)
1157                             mc := add(mc, 0x20)
1158                         } {
1159                             if iszero(eq(sload(sc), mload(mc))) {
1160                                 // unsuccess:
1161                                 success := 0
1162                                 cb := 0
1163                             }
1164                         }
1165                     }
1166                 }
1167             }
1168             default {
1169                 // unsuccess:
1170                 success := 0
1171             }
1172         }
1173 
1174         return success;
1175     }
1176 }
1177 
1178 interface ApproveAndCallFallBack {
1179     function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external payable returns (bool);
1180 }
1181 
1182 /**
1183  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1184  * checks.
1185  *
1186  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1187  * in bugs, because programmers usually assume that an overflow raises an
1188  * error, which is the standard behavior in high level programming languages.
1189  * `SafeMath` restores this intuition by reverting the transaction when an
1190  * operation overflows.
1191  *
1192  * Using this library instead of the unchecked operations eliminates an entire
1193  * class of bugs, so it's recommended to use it always.
1194  */
1195 library SafeMath {
1196     /**
1197      * @dev Returns the addition of two unsigned integers, reverting on
1198      * overflow.
1199      *
1200      * Counterpart to Solidity's `+` operator.
1201      *
1202      * Requirements:
1203      * - Addition cannot overflow.
1204      */
1205     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1206         uint256 c = a + b;
1207         require(c >= a, "SafeMath: addition overflow");
1208 
1209         return c;
1210     }
1211 
1212     /**
1213      * @dev Returns the subtraction of two unsigned integers, reverting on
1214      * overflow (when the result is negative).
1215      *
1216      * Counterpart to Solidity's `-` operator.
1217      *
1218      * Requirements:
1219      * - Subtraction cannot overflow.
1220      */
1221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1222         return sub(a, b, "SafeMath: subtraction overflow");
1223     }
1224 
1225     /**
1226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1227      * overflow (when the result is negative).
1228      *
1229      * Counterpart to Solidity's `-` operator.
1230      *
1231      * Requirements:
1232      * - Subtraction cannot overflow.
1233      *
1234      * _Available since v2.4.0._
1235      */
1236     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1237         require(b <= a, errorMessage);
1238         uint256 c = a - b;
1239 
1240         return c;
1241     }
1242 
1243     /**
1244      * @dev Returns the multiplication of two unsigned integers, reverting on
1245      * overflow.
1246      *
1247      * Counterpart to Solidity's `*` operator.
1248      *
1249      * Requirements:
1250      * - Multiplication cannot overflow.
1251      */
1252     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1253         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1254         // benefit is lost if 'b' is also tested.
1255         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1256         if (a == 0) {
1257             return 0;
1258         }
1259 
1260         uint256 c = a * b;
1261         require(c / a == b, "SafeMath: multiplication overflow");
1262 
1263         return c;
1264     }
1265 
1266     /**
1267      * @dev Returns the integer division of two unsigned integers. Reverts on
1268      * division by zero. The result is rounded towards zero.
1269      *
1270      * Counterpart to Solidity's `/` operator. Note: this function uses a
1271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1272      * uses an invalid opcode to revert (consuming all remaining gas).
1273      *
1274      * Requirements:
1275      * - The divisor cannot be zero.
1276      */
1277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1278         return div(a, b, "SafeMath: division by zero");
1279     }
1280 
1281     /**
1282      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1283      * division by zero. The result is rounded towards zero.
1284      *
1285      * Counterpart to Solidity's `/` operator. Note: this function uses a
1286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1287      * uses an invalid opcode to revert (consuming all remaining gas).
1288      *
1289      * Requirements:
1290      * - The divisor cannot be zero.
1291      *
1292      * _Available since v2.4.0._
1293      */
1294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1295         // Solidity only automatically asserts when dividing by 0
1296         require(b > 0, errorMessage);
1297         uint256 c = a / b;
1298         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1299 
1300         return c;
1301     }
1302 
1303     /**
1304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1305      * Reverts when dividing by zero.
1306      *
1307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1308      * opcode (which leaves remaining gas untouched) while Solidity uses an
1309      * invalid opcode to revert (consuming all remaining gas).
1310      *
1311      * Requirements:
1312      * - The divisor cannot be zero.
1313      */
1314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1315         return mod(a, b, "SafeMath: modulo by zero");
1316     }
1317 
1318     /**
1319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1320      * Reverts with custom message when dividing by zero.
1321      *
1322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1323      * opcode (which leaves remaining gas untouched) while Solidity uses an
1324      * invalid opcode to revert (consuming all remaining gas).
1325      *
1326      * Requirements:
1327      * - The divisor cannot be zero.
1328      *
1329      * _Available since v2.4.0._
1330      */
1331     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1332         require(b != 0, errorMessage);
1333         return a % b;
1334     }
1335 }
1336 
1337 
1338 /*
1339  * @dev Provides information about the current execution context, including the
1340  * sender of the transaction and its data. While these are generally available
1341  * via msg.sender and msg.data, they should not be accessed in such a direct
1342  * manner, since when dealing with GSN meta-transactions the account sending and
1343  * paying for execution may not be the actual sender (as far as an application
1344  * is concerned).
1345  *
1346  * This contract is only required for intermediate, library-like contracts.
1347  */
1348 contract Context {
1349     // Empty internal constructor, to prevent people from mistakenly deploying
1350     // an instance of this contract, which should be used via inheritance.
1351     constructor () internal { }
1352     // solhint-disable-previous-line no-empty-blocks
1353 
1354     function _msgSender() internal view returns (address payable) {
1355         return msg.sender;
1356     }
1357 
1358     function _msgData() internal view returns (bytes memory) {
1359         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1360         return msg.data;
1361     }
1362 }
1363 
1364 /**
1365  * @dev Contract module which provides a basic access control mechanism, where
1366  * there is an account (an owner) that can be granted exclusive access to
1367  * specific functions.
1368  *
1369  * This module is used through inheritance. It will make available the modifier
1370  * `onlyOwner`, which can be applied to your functions to restrict their use to
1371  * the owner.
1372  */
1373 contract Ownable is Context {
1374     address private _owner;
1375 
1376     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1377 
1378     /**
1379      * @dev Initializes the contract setting the deployer as the initial owner.
1380      */
1381     constructor () internal {
1382         address msgSender = _msgSender();
1383         _owner = msgSender;
1384         emit OwnershipTransferred(address(0), msgSender);
1385     }
1386 
1387     /**
1388      * @dev Returns the address of the current owner.
1389      */
1390     function owner() public view returns (address) {
1391         return _owner;
1392     }
1393 
1394     /**
1395      * @dev Throws if called by any account other than the owner.
1396      */
1397     modifier onlyOwner() {
1398         require(isOwner(), "Ownable: caller is not the owner");
1399         _;
1400     }
1401 
1402     /**
1403      * @dev Returns true if the caller is the current owner.
1404      */
1405     function isOwner() public view returns (bool) {
1406         return _msgSender() == _owner;
1407     }
1408 
1409     /**
1410      * @dev Leaves the contract without owner. It will not be possible to call
1411      * `onlyOwner` functions anymore. Can only be called by the current owner.
1412      *
1413      * NOTE: Renouncing ownership will leave the contract without an owner,
1414      * thereby removing any functionality that is only available to the owner.
1415      */
1416     function renounceOwnership() public onlyOwner {
1417         emit OwnershipTransferred(_owner, address(0));
1418         _owner = address(0);
1419     }
1420 
1421     /**
1422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1423      * Can only be called by the current owner.
1424      */
1425     function transferOwnership(address newOwner) public onlyOwner {
1426         _transferOwnership(newOwner);
1427     }
1428 
1429     /**
1430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1431      */
1432     function _transferOwnership(address newOwner) internal {
1433         require(newOwner != address(0), "Ownable: new owner is the zero address");
1434         emit OwnershipTransferred(_owner, newOwner);
1435         _owner = newOwner;
1436     }
1437 }
1438 
1439 
1440 
1441 /**
1442  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
1443  * the optional functions; to access them see {ERC20Detailed}.
1444  */
1445 interface IERC20 {
1446     /**
1447      * @dev Returns the amount of tokens in existence.
1448      */
1449     function totalSupply() external view returns (uint256);
1450 
1451     /**
1452      * @dev Returns the amount of tokens owned by `account`.
1453      */
1454     function balanceOf(address account) external view returns (uint256);
1455 
1456     /**
1457      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1458      *
1459      * Returns a boolean value indicating whether the operation succeeded.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function transfer(address recipient, uint256 amount) external returns (bool);
1464 
1465     /**
1466      * @dev Returns the remaining number of tokens that `spender` will be
1467      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1468      * zero by default.
1469      *
1470      * This value changes when {approve} or {transferFrom} are called.
1471      */
1472     function allowance(address owner, address spender) external view returns (uint256);
1473 
1474     /**
1475      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1476      *
1477      * Returns a boolean value indicating whether the operation succeeded.
1478      *
1479      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1480      * that someone may use both the old and the new allowance by unfortunate
1481      * transaction ordering. One possible solution to mitigate this race
1482      * condition is to first reduce the spender's allowance to 0 and set the
1483      * desired value afterwards:
1484      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1485      *
1486      * Emits an {Approval} event.
1487      */
1488     function approve(address spender, uint256 amount) external returns (bool);
1489 
1490     /**
1491      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1492      * allowance mechanism. `amount` is then deducted from the caller's
1493      * allowance.
1494      *
1495      * Returns a boolean value indicating whether the operation succeeded.
1496      *
1497      * Emits a {Transfer} event.
1498      */
1499     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1500 
1501     /**
1502      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1503      * another (`to`).
1504      *
1505      * Note that `value` may be zero.
1506      */
1507     event Transfer(address indexed from, address indexed to, uint256 value);
1508 
1509     /**
1510      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1511      * a call to {approve}. `value` is the new allowance.
1512      */
1513     event Approval(address indexed owner, address indexed spender, uint256 value);
1514 }
1515 
1516 
1517 /**
1518  * @dev Implementation of the {IERC20} interface.
1519  *
1520  * This implementation is agnostic to the way tokens are created. This means
1521  * that a supply mechanism has to be added in a derived contract using {_mint}.
1522  * For a generic mechanism see {ERC20Mintable}.
1523  *
1524  * TIP: For a detailed writeup see our guide
1525  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1526  * to implement supply mechanisms].
1527  *
1528  * We have followed general OpenZeppelin guidelines: functions revert instead
1529  * of returning `false` on failure. This behavior is nonetheless conventional
1530  * and does not conflict with the expectations of ERC20 applications.
1531  *
1532  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1533  * This allows applications to reconstruct the allowance for all accounts just
1534  * by listening to said events. Other implementations of the EIP may not emit
1535  * these events, as it isn't required by the specification.
1536  *
1537  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1538  * functions have been added to mitigate the well-known issues around setting
1539  * allowances. See {IERC20-approve}.
1540  */
1541 contract ERC20 is Context, IERC20 {
1542     using SafeMath for uint256;
1543 
1544     mapping (address => uint256) private _balances;
1545 
1546     mapping (address => mapping (address => uint256)) private _allowances;
1547 
1548     uint256 private _totalSupply;
1549 
1550     /**
1551      * @dev See {IERC20-totalSupply}.
1552      */
1553     function totalSupply() public view returns (uint256) {
1554         return _totalSupply;
1555     }
1556 
1557     /**
1558      * @dev See {IERC20-balanceOf}.
1559      */
1560     function balanceOf(address account) public view returns (uint256) {
1561         return _balances[account];
1562     }
1563 
1564     /**
1565      * @dev See {IERC20-transfer}.
1566      *
1567      * Requirements:
1568      *
1569      * - `recipient` cannot be the zero address.
1570      * - the caller must have a balance of at least `amount`.
1571      */
1572     function transfer(address recipient, uint256 amount) public returns (bool) {
1573         _transfer(_msgSender(), recipient, amount);
1574         return true;
1575     }
1576 
1577     /**
1578      * @dev See {IERC20-allowance}.
1579      */
1580     function allowance(address owner, address spender) public view returns (uint256) {
1581         return _allowances[owner][spender];
1582     }
1583 
1584     /**
1585      * @dev See {IERC20-approve}.
1586      *
1587      * Requirements:
1588      *
1589      * - `spender` cannot be the zero address.
1590      */
1591     function approve(address spender, uint256 amount) public returns (bool) {
1592         _approve(_msgSender(), spender, amount);
1593         return true;
1594     }
1595 
1596     /**
1597      * @dev See {IERC20-transferFrom}.
1598      *
1599      * Emits an {Approval} event indicating the updated allowance. This is not
1600      * required by the EIP. See the note at the beginning of {ERC20};
1601      *
1602      * Requirements:
1603      * - `sender` and `recipient` cannot be the zero address.
1604      * - `sender` must have a balance of at least `amount`.
1605      * - the caller must have allowance for `sender`'s tokens of at least
1606      * `amount`.
1607      */
1608     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1609         _transfer(sender, recipient, amount);
1610         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1611         return true;
1612     }
1613 
1614     /**
1615      * @dev Atomically increases the allowance granted to `spender` by the caller.
1616      *
1617      * This is an alternative to {approve} that can be used as a mitigation for
1618      * problems described in {IERC20-approve}.
1619      *
1620      * Emits an {Approval} event indicating the updated allowance.
1621      *
1622      * Requirements:
1623      *
1624      * - `spender` cannot be the zero address.
1625      */
1626     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1627         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1628         return true;
1629     }
1630 
1631     /**
1632      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1633      *
1634      * This is an alternative to {approve} that can be used as a mitigation for
1635      * problems described in {IERC20-approve}.
1636      *
1637      * Emits an {Approval} event indicating the updated allowance.
1638      *
1639      * Requirements:
1640      *
1641      * - `spender` cannot be the zero address.
1642      * - `spender` must have allowance for the caller of at least
1643      * `subtractedValue`.
1644      */
1645     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1646         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1647         return true;
1648     }
1649 
1650     /**
1651      * @dev Moves tokens `amount` from `sender` to `recipient`.
1652      *
1653      * This is internal function is equivalent to {transfer}, and can be used to
1654      * e.g. implement automatic token fees, slashing mechanisms, etc.
1655      *
1656      * Emits a {Transfer} event.
1657      *
1658      * Requirements:
1659      *
1660      * - `sender` cannot be the zero address.
1661      * - `recipient` cannot be the zero address.
1662      * - `sender` must have a balance of at least `amount`.
1663      */
1664     function _transfer(address sender, address recipient, uint256 amount) internal {
1665         require(sender != address(0), "ERC20: transfer from the zero address");
1666         require(recipient != address(0), "ERC20: transfer to the zero address");
1667 
1668         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1669         _balances[recipient] = _balances[recipient].add(amount);
1670         emit Transfer(sender, recipient, amount);
1671     }
1672 
1673     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1674      * the total supply.
1675      *
1676      * Emits a {Transfer} event with `from` set to the zero address.
1677      *
1678      * Requirements
1679      *
1680      * - `to` cannot be the zero address.
1681      */
1682     function _mint(address account, uint256 amount) internal {
1683         require(account != address(0), "ERC20: mint to the zero address");
1684 
1685         _totalSupply = _totalSupply.add(amount);
1686         _balances[account] = _balances[account].add(amount);
1687         emit Transfer(address(0), account, amount);
1688     }
1689 
1690     /**
1691      * @dev Destroys `amount` tokens from `account`, reducing the
1692      * total supply.
1693      *
1694      * Emits a {Transfer} event with `to` set to the zero address.
1695      *
1696      * Requirements
1697      *
1698      * - `account` cannot be the zero address.
1699      * - `account` must have at least `amount` tokens.
1700      */
1701     function _burn(address account, uint256 amount) internal {
1702         require(account != address(0), "ERC20: burn from the zero address");
1703 
1704         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1705         _totalSupply = _totalSupply.sub(amount);
1706         emit Transfer(account, address(0), amount);
1707     }
1708 
1709     /**
1710      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1711      *
1712      * This is internal function is equivalent to `approve`, and can be used to
1713      * e.g. set automatic allowances for certain subsystems, etc.
1714      *
1715      * Emits an {Approval} event.
1716      *
1717      * Requirements:
1718      *
1719      * - `owner` cannot be the zero address.
1720      * - `spender` cannot be the zero address.
1721      */
1722     function _approve(address owner, address spender, uint256 amount) internal {
1723         require(owner != address(0), "ERC20: approve from the zero address");
1724         require(spender != address(0), "ERC20: approve to the zero address");
1725 
1726         _allowances[owner][spender] = amount;
1727         emit Approval(owner, spender, amount);
1728     }
1729 
1730     /**
1731      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1732      * from the caller's allowance.
1733      *
1734      * See {_burn} and {_approve}.
1735      */
1736     function _burnFrom(address account, uint256 amount) internal {
1737         _burn(account, amount);
1738         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1739     }
1740 }
1741 
1742 
1743 /**
1744  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1745  * tokens and those that they have an allowance for, in a way that can be
1746  * recognized off-chain (via event analysis).
1747  */
1748 contract ERC20Burnable is Context, ERC20 {
1749     /**
1750      * @dev Destroys `amount` tokens from the caller.
1751      *
1752      * See {ERC20-_burn}.
1753      */
1754     function burn(uint256 amount) public {
1755         _burn(_msgSender(), amount);
1756     }
1757 
1758     /**
1759      * @dev See {ERC20-_burnFrom}.
1760      */
1761     function burnFrom(address account, uint256 amount) public {
1762         _burnFrom(account, amount);
1763     }
1764 }
1765 
1766 
1767 interface ETHFeed {
1768     function priceForEtherInUsdWei() external view returns (uint256);
1769 }
1770 
1771 interface BZNFeed {
1772     /**
1773      * Returns the converted BZN value
1774      */
1775     function convert(uint256 usd) external view returns (uint256);
1776 }
1777 
1778 /**
1779  * @dev Interface of the ERC165 standard, as defined in the
1780  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1781  *
1782  * Implementers can declare support of contract interfaces, which can then be
1783  * queried by others ({ERC165Checker}).
1784  *
1785  * For an implementation, see {ERC165}.
1786  */
1787 interface IERC165 {
1788     /**
1789      * @dev Returns true if this contract implements the interface defined by
1790      * `interfaceId`. See the corresponding
1791      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1792      * to learn more about how these ids are created.
1793      *
1794      * This function call must use less than 30 000 gas.
1795      */
1796     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1797 }
1798 
1799 
1800 /**
1801  * @dev Required interface of an ERC721 compliant contract.
1802  */
1803 contract IERC721 is IERC165 {
1804     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1805     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1806     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1807 
1808     /**
1809      * @dev Returns the number of NFTs in `owner`'s account.
1810      */
1811     function balanceOf(address owner) public view returns (uint256 balance);
1812 
1813     /**
1814      * @dev Returns the owner of the NFT specified by `tokenId`.
1815      */
1816     function ownerOf(uint256 tokenId) public view returns (address owner);
1817 
1818     /**
1819      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1820      * another (`to`).
1821      *
1822      *
1823      *
1824      * Requirements:
1825      * - `from`, `to` cannot be zero.
1826      * - `tokenId` must be owned by `from`.
1827      * - If the caller is not `from`, it must be have been allowed to move this
1828      * NFT by either {approve} or {setApprovalForAll}.
1829      */
1830     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1831     /**
1832      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
1833      * another (`to`).
1834      *
1835      * Requirements:
1836      * - If the caller is not `from`, it must be approved to move this NFT by
1837      * either {approve} or {setApprovalForAll}.
1838      */
1839     function transferFrom(address from, address to, uint256 tokenId) public;
1840     function approve(address to, uint256 tokenId) public;
1841     function getApproved(uint256 tokenId) public view returns (address operator);
1842 
1843     function setApprovalForAll(address operator, bool _approved) public;
1844     function isApprovedForAll(address owner, address operator) public view returns (bool);
1845 
1846 
1847     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1848 }
1849 
1850 
1851 contract IGunToken is IERC721 {
1852     function exists(uint256 tokenId) external view returns (bool);
1853 
1854     function claimAllocation(address to, uint16 size, uint8 category) external returns (uint);
1855 }
1856 
1857 contract GunPreOrder is Ownable, ApproveAndCallFallBack {
1858     using BytesLib for bytes;
1859     using SafeMath for uint256;
1860     
1861     //Event for when a bulk buy order has been placed
1862     event consumerBulkBuy(uint8 category, uint256 quanity, address reserver);
1863     //Event for when a gun has been bought
1864     event GunsBought(uint256 gunId, address owner, uint8 category);
1865     //Event for when ether is taken out of this contract
1866     event Withdrawal(uint256 amount);
1867 
1868     //Default referal commision percent
1869     uint256 public constant COMMISSION_PERCENT = 5;
1870     
1871     //Whether category is open
1872     mapping(uint8 => bool) public categoryExists;
1873     mapping(uint8 => bool) public categoryOpen;
1874     mapping(uint8 => bool) public categoryKilled;
1875     
1876     //The additional referal commision percent for any given referal address (default is 0)
1877     mapping(address => uint256) internal commissionRate;
1878     
1879     //How many guns in a given category an address has reserved
1880     mapping(uint8 => mapping(address => uint256)) public categoryReserveAmount;
1881     
1882     //Opensea buy address
1883     address internal constant OPENSEA = 0x5b3256965e7C3cF26E11FCAf296DfC8807C01073;
1884 
1885     //The percent increase and percent base for a given category
1886     mapping(uint8 => uint256) public categoryPercentIncrease;
1887     mapping(uint8 => uint256) public categoryPercentBase;
1888 
1889     //Price of a givevn category in USD WEI
1890     mapping(uint8 => uint256) public categoryPrice;
1891     
1892     //The percent of ether required for buying in BZN
1893     mapping(uint8 => uint256) public requiredEtherPercent;
1894     mapping(uint8 => uint256) public requiredEtherPercentBase;
1895     bool public allowCreateCategory = true;
1896     bool public allowEthPayment = true;
1897 
1898     //The gun token contract
1899     IGunToken public token;
1900     //The gun factory contract
1901     GunFactory internal factory;
1902     //The BZN contract
1903     ERC20Burnable internal bzn;
1904     //The Maker ETH/USD price feed
1905     ETHFeed public ethFeed;
1906     BZNFeed public bznFeed;
1907     //The gamepool address
1908     address internal gamePool;
1909     
1910     //Require the skinned/regular shop to be opened
1911     modifier ensureShopOpen(uint8 category) {
1912         require(categoryExists[category], "Category doesn't exist!");
1913         require(categoryOpen[category], "Category is not open!");
1914         _;
1915     }
1916     
1917     //Allow a function to accept ETH payment
1918     modifier payInETH(address referal, uint8 category, address new_owner, uint16 quanity) {
1919         require(allowEthPayment, "ETH Payments are disabled");
1920         uint256 usdPrice;
1921         uint256 totalPrice;
1922         (usdPrice, totalPrice) = priceFor(category, quanity);
1923         require(usdPrice > 0, "Price not yet set");
1924         
1925         categoryPrice[category] = usdPrice; //Save last price
1926         
1927         uint256 price = convert(totalPrice, false);
1928         
1929         require(msg.value >= price, "Not enough Ether sent!");
1930         
1931         _;
1932         
1933         if (msg.value > price) {
1934             uint256 change = msg.value - price;
1935 
1936             msg.sender.transfer(change);
1937         }
1938         
1939         if (referal != address(0)) {
1940             require(referal != msg.sender, "The referal cannot be the sender");
1941             require(referal != tx.origin, "The referal cannot be the tranaction origin");
1942             require(referal != new_owner, "The referal cannot be the new owner");
1943 
1944             //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
1945             uint256 totalCommision = COMMISSION_PERCENT + commissionRate[referal];
1946 
1947             uint256 commision = (price * totalCommision) / 100;
1948             
1949             address payable _referal = address(uint160(referal));
1950 
1951             _referal.transfer(commision);
1952         }
1953 
1954     }
1955     
1956     //Allow function to accept BZN payment
1957     modifier payInBZN(address referal, uint8 category, address payable new_owner, uint16 quanity) {
1958         uint256[] memory prices = new uint256[](4); //Hack to work around local var limit (usdPrice, bznPrice, commision, totalPrice)
1959         (prices[0], prices[3]) = priceFor(category, quanity);
1960         require(prices[0] > 0, "Price not yet set");
1961             
1962         categoryPrice[category] = prices[0];
1963         
1964         prices[1] = convert(prices[3], true); //Convert the totalPrice to BZN
1965 
1966         //The commissionRate map adds any partner bonuses, or 0 if a normal user referral
1967         if (referal != address(0)) {
1968             prices[2] = (prices[1] * (COMMISSION_PERCENT + commissionRate[referal])) / 100;
1969         }
1970         
1971         uint256 requiredEther = (convert(prices[3], false) * requiredEtherPercent[category]) / requiredEtherPercentBase[category];
1972         
1973         require(msg.value >= requiredEther, "Buying with BZN requires some Ether!");
1974         
1975         bzn.burnFrom(new_owner, (((prices[1] - prices[2]) * 30) / 100));
1976         bzn.transferFrom(new_owner, gamePool, prices[1] - prices[2] - (((prices[1] - prices[2]) * 30) / 100));
1977         
1978         _;
1979         
1980         if (msg.value > requiredEther) {
1981             new_owner.transfer(msg.value - requiredEther);
1982         }
1983         
1984         if (referal != address(0)) {
1985             require(referal != msg.sender, "The referal cannot be the sender");
1986             require(referal != tx.origin, "The referal cannot be the tranaction origin");
1987             require(referal != new_owner, "The referal cannot be the new owner");
1988             
1989             bzn.transferFrom(new_owner, referal, prices[2]);
1990             
1991             prices[2] = (requiredEther * (COMMISSION_PERCENT + commissionRate[referal])) / 100;
1992             
1993             address payable _referal = address(uint160(referal));
1994 
1995             _referal.transfer(prices[2]);
1996         }
1997     }
1998 
1999     //Constructor
2000     constructor(
2001         address tokenAddress,
2002         address tokenFactory,
2003         address gp,
2004         address ethfeed,
2005         address bzn_address
2006     ) public {
2007         token = IGunToken(tokenAddress);
2008 
2009         factory = GunFactory(tokenFactory);
2010         
2011         ethFeed = ETHFeed(ethfeed);
2012         bzn = ERC20Burnable(bzn_address);
2013 
2014         gamePool = gp;
2015 
2016         //Set percent increases
2017         categoryPercentIncrease[1] = 100035;
2018         categoryPercentBase[1] = 100000;
2019         
2020         categoryPercentIncrease[2] = 100025;
2021         categoryPercentBase[2] = 100000;
2022         
2023         categoryPercentIncrease[3] = 100015;
2024         categoryPercentBase[3] = 100000;
2025         
2026         commissionRate[OPENSEA] = 10;
2027     }
2028     
2029     function createCategory(uint8 category) public onlyOwner {
2030         require(allowCreateCategory);
2031         
2032         categoryExists[category] = true;
2033     }
2034     
2035     function disableCreateCategories() public onlyOwner {
2036         allowCreateCategory = false;
2037     }
2038 
2039     function toggleETHPayment(bool enable) public onlyOwner {
2040         allowEthPayment = enable;
2041     }
2042     
2043     //Set the referal commision rate for an address
2044     function setCommission(address referral, uint256 percent) public onlyOwner {
2045         require(percent > COMMISSION_PERCENT);
2046         require(percent < 95);
2047         percent = percent - COMMISSION_PERCENT;
2048         
2049         commissionRate[referral] = percent;
2050     }
2051     
2052     //Set the price increase/base for skinned or regular guns
2053     function setPercentIncrease(uint256 increase, uint256 base, uint8 category) public onlyOwner {
2054         require(increase > base);
2055         
2056         categoryPercentIncrease[category] = increase;
2057         categoryPercentBase[category] = base;
2058     }
2059     
2060     function setEtherPercent(uint256 percent, uint256 base, uint8 category) public onlyOwner {
2061         requiredEtherPercent[category] = percent;
2062         requiredEtherPercentBase[category] = base;
2063     }
2064     
2065     function killCategory(uint8 category) public onlyOwner {
2066         require(!categoryKilled[category]);
2067         
2068         categoryOpen[category] = false;
2069         categoryKilled[category] = true;
2070     }
2071 
2072     //Open/Close the skinned or regular guns shop
2073     function setShopState(uint8 category, bool open) public onlyOwner {
2074         require(category == 1 || category == 2 || category == 3);
2075         require(!categoryKilled[category]);
2076         require(categoryExists[category]);
2077         
2078         categoryOpen[category] = open;
2079     }
2080 
2081     /**
2082      * Set the price for any given category in USD.
2083      */
2084     function setPrice(uint8 category, uint256 price, bool inWei) public onlyOwner {
2085         uint256 multiply = 1e18;
2086         if (inWei) {
2087             multiply = 1;
2088         }
2089         
2090         categoryPrice[category] = price * multiply;
2091     }
2092 
2093     /**
2094     Withdraw the amount from the contract's balance. Only the contract owner can execute this function
2095     */
2096     function withdraw(uint256 amount) public onlyOwner {
2097         uint256 balance = address(this).balance;
2098 
2099         require(amount <= balance, "Requested to much");
2100         
2101         address payable _owner = address(uint160(owner()));
2102         
2103         _owner.transfer(amount);
2104 
2105         emit Withdrawal(amount);
2106     }
2107     
2108     function setBZNFeedContract(address new_bzn_feed) public onlyOwner {
2109         bznFeed = BZNFeed(new_bzn_feed);
2110     }
2111 
2112     function setEtherFeedContract(address new_eth_feed) public onlyOwner {
2113         ethFeed = ETHFeed(new_eth_feed);
2114     }
2115     
2116     //Buy many skinned or regular guns with BZN. This will reserve the amount of guns and allows the new_owner to invoke claimGuns for free
2117     function buyWithBZN(address referal, uint8 category, address payable new_owner, uint16 quanity) ensureShopOpen(category) payInBZN(referal, category, new_owner, quanity) public payable returns (bool) {
2118         factory.mintFor(new_owner, quanity, category);
2119             
2120         return true;
2121     }
2122     
2123     //Buy many skinned or regular guns with ETH. This will reserve the amount of guns and allows the new_owner to invoke claimGuns for free
2124     function buyWithEther(address referal, uint8 category, address new_owner, uint16 quanity) ensureShopOpen(category) payInETH(referal, category, new_owner, quanity) public payable returns (bool) {
2125         factory.mintFor(new_owner, quanity, category);
2126         
2127         return true;
2128     }
2129     
2130     function convert(uint256 usdValue, bool isBZN) public view returns (uint256) {
2131         if (isBZN) {
2132             return bznFeed.convert(usdValue);
2133         } else {
2134             uint256 priceForEtherInUsdWei = ethFeed.priceForEtherInUsdWei();
2135             
2136             return usdValue / (priceForEtherInUsdWei / 1e18);
2137         }
2138     }
2139     
2140     /**
2141     Get the price for skinned or regular guns in USD (wei)
2142     */
2143     function priceFor(uint8 category, uint16 quanity) public view returns (uint256, uint256) {
2144         require(quanity > 0);
2145         uint256 percent = categoryPercentIncrease[category];
2146         uint256 base = categoryPercentBase[category];
2147 
2148         uint256 currentPrice = categoryPrice[category];
2149         uint256 nextPrice = currentPrice;
2150         uint256 totalPrice = 0;
2151         //We can't use exponents because we'll overflow quickly
2152         //Only for loop :(
2153         for (uint i = 0; i < quanity; i++) {
2154             nextPrice = (currentPrice * percent) / base;
2155             
2156             currentPrice = nextPrice;
2157             
2158             totalPrice += nextPrice;
2159         }
2160 
2161         //Return the next price, as this is the true price
2162         return (nextPrice, totalPrice);
2163     }
2164 
2165     //Determine if a tokenId exists (has been sold)
2166     function sold(uint256 _tokenId) public view returns (bool) {
2167         return token.exists(_tokenId);
2168     }
2169     
2170     function receiveApproval(address from, uint256 tokenAmount, address tokenContract, bytes memory data) public payable returns (bool) {
2171         address referal;
2172         uint8 category;
2173         uint16 quanity;
2174         
2175         (referal, category, quanity) = abi.decode(data, (address, uint8, uint16));
2176         
2177         require(quanity >= 1);
2178         
2179         address payable _from = address(uint160(from)); 
2180         
2181         buyWithBZN(referal, category, _from, quanity);
2182         
2183         return true;
2184     }
2185 }
2186 
2187 contract GunFactory is Ownable {
2188     using strings for *;
2189     
2190     uint8 public constant PREMIUM_CATEGORY = 1;
2191     uint8 public constant MIDGRADE_CATEGORY = 2;
2192     uint8 public constant REGULAR_CATEGORY = 3;
2193     uint256 public constant ONE_MONTH = 2628000;
2194     
2195     uint256 public mintedGuns = 0;
2196     address preOrderAddress;
2197     IGunToken token;
2198     
2199     mapping(uint8 => uint256) internal gunsMintedByCategory;
2200     mapping(uint8 => uint256) internal totalGunsMintedByCategory;
2201     
2202     mapping(uint8 => uint256) internal firstMonthLimit;
2203     mapping(uint8 => uint256) internal secondMonthLimit;
2204     mapping(uint8 => uint256) internal thirdMonthLimit;
2205     
2206     uint256 internal startTime;
2207     mapping(uint8 => uint256) internal currentMonthEnd;
2208     uint256 internal monthOneEnd;
2209     uint256 internal monthTwoEnd;
2210 
2211     modifier onlyPreOrder {
2212         require(msg.sender == preOrderAddress, "Not authorized");
2213         _;
2214     }
2215 
2216     modifier isInitialized {
2217         require(preOrderAddress != address(0), "No linked preorder");
2218         require(address(token) != address(0), "No linked token");
2219         _;
2220     }
2221     
2222     constructor() public {
2223         firstMonthLimit[PREMIUM_CATEGORY] = 5000;
2224         firstMonthLimit[MIDGRADE_CATEGORY] = 20000;
2225         firstMonthLimit[REGULAR_CATEGORY] = 30000;
2226         
2227         secondMonthLimit[PREMIUM_CATEGORY] = 2500;
2228         secondMonthLimit[MIDGRADE_CATEGORY] = 10000;
2229         secondMonthLimit[REGULAR_CATEGORY] = 15000;
2230         
2231         thirdMonthLimit[PREMIUM_CATEGORY] = 600;
2232         thirdMonthLimit[MIDGRADE_CATEGORY] = 3000;
2233         thirdMonthLimit[REGULAR_CATEGORY] = 6000;
2234         
2235         startTime = block.timestamp;
2236         monthOneEnd = startTime + ONE_MONTH;
2237         monthTwoEnd = startTime + ONE_MONTH + ONE_MONTH;
2238         
2239         currentMonthEnd[PREMIUM_CATEGORY] = monthOneEnd;
2240         currentMonthEnd[MIDGRADE_CATEGORY] = monthOneEnd;
2241         currentMonthEnd[REGULAR_CATEGORY] = monthOneEnd;
2242     }
2243 
2244     function uintToString(uint v) internal pure returns (string memory) {
2245         if (v == 0) {
2246             return "0";
2247         }
2248         uint j = v;
2249         uint len;
2250         while (j != 0) {
2251             len++;
2252             j /= 10;
2253         }
2254         bytes memory bstr = new bytes(len);
2255         uint k = len - 1;
2256         while (v != 0) {
2257             bstr[k--] = byte(uint8(48 + v % 10));
2258             v /= 10;
2259         }
2260         
2261         return string(bstr);
2262     }
2263 
2264     function mintFor(address newOwner, uint16 size, uint8 category) public onlyPreOrder isInitialized returns (uint256) {
2265         GunPreOrder preOrder = GunPreOrder(preOrderAddress);
2266         require(preOrder.categoryExists(category), "Invalid category");
2267         
2268         require(!hasReachedLimit(category), "The monthly limit has been reached");
2269         
2270         token.claimAllocation(newOwner, size, category);
2271         
2272         mintedGuns += size;
2273         
2274         gunsMintedByCategory[category] = gunsMintedByCategory[category] + size;
2275         totalGunsMintedByCategory[category] = totalGunsMintedByCategory[category] + size;
2276     }
2277     
2278     function hasReachedLimit(uint8 category) internal returns (bool) {
2279         uint256 currentTime = block.timestamp;
2280         uint256 limit = currentLimit(category);
2281         
2282         uint256 monthEnd = currentMonthEnd[category];
2283         
2284         //If the current block time is greater than or equal to the end of the month
2285         if (currentTime >= monthEnd) {
2286             //It's a new month, reset all limits
2287             //gunsMintedByCategory[PREMIUM_CATEGORY] = 0;
2288             //gunsMintedByCategory[MIDGRADE_CATEGORY] = 0;
2289             //gunsMintedByCategory[REGULAR_CATEGORY] = 0;
2290             gunsMintedByCategory[category] = 0;
2291             
2292             //Set next month end to be equal one month in advance
2293             //do this while the current time is greater than the next month end
2294             while (currentTime >= monthEnd) {
2295                 monthEnd = monthEnd + ONE_MONTH;
2296             }
2297             
2298             //Finally, update the limit
2299             limit = currentLimit(category);
2300             currentMonthEnd[category] = monthEnd;
2301         }
2302         
2303         //Check if the limit has been reached
2304         return gunsMintedByCategory[category] >= limit;
2305     }
2306     
2307     function reachedLimit(uint8 category) public view returns (bool) {
2308         uint256 limit = currentLimit(category);
2309         
2310         return gunsMintedByCategory[category] >= limit;
2311     }
2312     
2313     function currentLimit(uint8 category) public view returns (uint256) {
2314         uint256 currentTime = block.timestamp;
2315         uint256 limit;
2316         if (currentTime < monthOneEnd) {
2317             limit = firstMonthLimit[category];
2318         } else if (currentTime < monthTwoEnd) {
2319             limit = secondMonthLimit[category];
2320         } else {
2321             limit = thirdMonthLimit[category];
2322         }
2323         
2324         return limit;
2325     }
2326     
2327     function setCategoryLimit(uint8 category, uint256 firstLimit, uint256 secondLimit, uint256 thirdLimit) public onlyOwner {
2328         require(firstMonthLimit[category] == 0);
2329         require(secondMonthLimit[category] == 0);
2330         require(thirdMonthLimit[category] == 0);
2331         
2332         firstMonthLimit[category] = firstLimit;
2333         secondMonthLimit[category] = secondLimit;
2334         thirdMonthLimit[category] = thirdLimit;
2335     }
2336     
2337     /**
2338     Attach the preOrder that will be receiving tokens being marked for sale by the
2339     sellCar function
2340     */
2341     function attachPreOrder(address dst) public onlyOwner {
2342         require(preOrderAddress == address(0));
2343         require(dst != address(0));
2344 
2345         //Enforce that address is indeed a preorder
2346         GunPreOrder preOrder = GunPreOrder(dst);
2347 
2348         preOrderAddress = address(preOrder);
2349     }
2350 
2351     /**
2352     Attach the token being used for things
2353     */
2354     function attachToken(address dst) public onlyOwner {
2355         require(address(token) == address(0));
2356         require(dst != address(0));
2357 
2358         //Enforce that address is indeed a preorder
2359         IGunToken ct = IGunToken(dst);
2360 
2361         token = ct;
2362     }
2363 }