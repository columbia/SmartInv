1 pragma solidity ^0.4.18;
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
39 
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
159     function len(slice self) internal returns (uint l) {
160         // Starting at ptr-31 means the LSB will be the byte we care about
161         var ptr = self._ptr - 31;
162         var end = ptr + self._len;
163         for (l = 0; ptr < end; l++) {
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
180     }
181 
182     /*
183      * @dev Returns true if the slice is empty (has a length of 0).
184      * @param self The slice to operate on.
185      * @return True if the slice is empty, False otherwise.
186      */
187     function empty(slice self) internal returns (bool) {
188         return self._len == 0;
189     }
190 
191     /*
192      * @dev Returns a positive number if `other` comes lexicographically after
193      *      `self`, a negative number if it comes before, or zero if the
194      *      contents of the two slices are equal. Comparison is done per-rune,
195      *      on unicode codepoints.
196      * @param self The first slice to compare.
197      * @param other The second slice to compare.
198      * @return The result of the comparison.
199      */
200     function compare(slice self, slice other) internal returns (int) {
201         uint shortest = self._len;
202         if (other._len < self._len)
203             shortest = other._len;
204 
205         var selfptr = self._ptr;
206         var otherptr = other._ptr;
207         for (uint idx = 0; idx < shortest; idx += 32) {
208             uint a;
209             uint b;
210             assembly {
211                 a := mload(selfptr)
212                 b := mload(otherptr)
213             }
214             if (a != b) {
215                 // Mask out irrelevant bytes and check again
216                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
217                 var diff = (a & mask) - (b & mask);
218                 if (diff != 0)
219                     return int(diff);
220             }
221             selfptr += 32;
222             otherptr += 32;
223         }
224         return int(self._len) - int(other._len);
225     }
226 
227     /*
228      * @dev Returns true if the two slices contain the same text.
229      * @param self The first slice to compare.
230      * @param self The second slice to compare.
231      * @return True if the slices are equal, false otherwise.
232      */
233     function equals(slice self, slice other) internal returns (bool) {
234         return compare(self, other) == 0;
235     }
236 
237     /*
238      * @dev Extracts the first rune in the slice into `rune`, advancing the
239      *      slice to point to the next rune and returning `self`.
240      * @param self The slice to operate on.
241      * @param rune The slice that will contain the first rune.
242      * @return `rune`.
243      */
244     function nextRune(slice self, slice rune) internal returns (slice) {
245         rune._ptr = self._ptr;
246 
247         if (self._len == 0) {
248             rune._len = 0;
249             return rune;
250         }
251 
252         uint len;
253         uint b;
254         // Load the first byte of the rune into the LSBs of b
255         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
256         if (b < 0x80) {
257             len = 1;
258         } else if(b < 0xE0) {
259             len = 2;
260         } else if(b < 0xF0) {
261             len = 3;
262         } else {
263             len = 4;
264         }
265 
266         // Check for truncated codepoints
267         if (len > self._len) {
268             rune._len = self._len;
269             self._ptr += self._len;
270             self._len = 0;
271             return rune;
272         }
273 
274         self._ptr += len;
275         self._len -= len;
276         rune._len = len;
277         return rune;
278     }
279 
280     /*
281      * @dev Returns the first rune in the slice, advancing the slice to point
282      *      to the next rune.
283      * @param self The slice to operate on.
284      * @return A slice containing only the first rune from `self`.
285      */
286     function nextRune(slice self) internal returns (slice ret) {
287         nextRune(self, ret);
288     }
289 
290     /*
291      * @dev Returns the number of the first codepoint in the slice.
292      * @param self The slice to operate on.
293      * @return The number of the first codepoint in the slice.
294      */
295     function ord(slice self) internal returns (uint ret) {
296         if (self._len == 0) {
297             return 0;
298         }
299 
300         uint word;
301         uint length;
302         uint divisor = 2 ** 248;
303 
304         // Load the rune into the MSBs of b
305         assembly { word:= mload(mload(add(self, 32))) }
306         var b = word / divisor;
307         if (b < 0x80) {
308             ret = b;
309             length = 1;
310         } else if(b < 0xE0) {
311             ret = b & 0x1F;
312             length = 2;
313         } else if(b < 0xF0) {
314             ret = b & 0x0F;
315             length = 3;
316         } else {
317             ret = b & 0x07;
318             length = 4;
319         }
320 
321         // Check for truncated codepoints
322         if (length > self._len) {
323             return 0;
324         }
325 
326         for (uint i = 1; i < length; i++) {
327             divisor = divisor / 256;
328             b = (word / divisor) & 0xFF;
329             if (b & 0xC0 != 0x80) {
330                 // Invalid UTF-8 sequence
331                 return 0;
332             }
333             ret = (ret * 64) | (b & 0x3F);
334         }
335 
336         return ret;
337     }
338 
339     /*
340      * @dev Returns the keccak-256 hash of the slice.
341      * @param self The slice to hash.
342      * @return The hash of the slice.
343      */
344     function keccak(slice self) internal returns (bytes32 ret) {
345         assembly {
346             ret := keccak256(mload(add(self, 32)), mload(self))
347         }
348     }
349 
350     /*
351      * @dev Returns true if `self` starts with `needle`.
352      * @param self The slice to operate on.
353      * @param needle The slice to search for.
354      * @return True if the slice starts with the provided text, false otherwise.
355      */
356     function startsWith(slice self, slice needle) internal returns (bool) {
357         if (self._len < needle._len) {
358             return false;
359         }
360 
361         if (self._ptr == needle._ptr) {
362             return true;
363         }
364 
365         bool equal;
366         assembly {
367             let length := mload(needle)
368             let selfptr := mload(add(self, 0x20))
369             let needleptr := mload(add(needle, 0x20))
370             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
371         }
372         return equal;
373     }
374 
375     /*
376      * @dev If `self` starts with `needle`, `needle` is removed from the
377      *      beginning of `self`. Otherwise, `self` is unmodified.
378      * @param self The slice to operate on.
379      * @param needle The slice to search for.
380      * @return `self`
381      */
382     function beyond(slice self, slice needle) internal returns (slice) {
383         if (self._len < needle._len) {
384             return self;
385         }
386 
387         bool equal = true;
388         if (self._ptr != needle._ptr) {
389             assembly {
390                 let length := mload(needle)
391                 let selfptr := mload(add(self, 0x20))
392                 let needleptr := mload(add(needle, 0x20))
393                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
394             }
395         }
396 
397         if (equal) {
398             self._len -= needle._len;
399             self._ptr += needle._len;
400         }
401 
402         return self;
403     }
404 
405     /*
406      * @dev Returns true if the slice ends with `needle`.
407      * @param self The slice to operate on.
408      * @param needle The slice to search for.
409      * @return True if the slice starts with the provided text, false otherwise.
410      */
411     function endsWith(slice self, slice needle) internal returns (bool) {
412         if (self._len < needle._len) {
413             return false;
414         }
415 
416         var selfptr = self._ptr + self._len - needle._len;
417 
418         if (selfptr == needle._ptr) {
419             return true;
420         }
421 
422         bool equal;
423         assembly {
424             let length := mload(needle)
425             let needleptr := mload(add(needle, 0x20))
426             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
427         }
428 
429         return equal;
430     }
431 
432     /*
433      * @dev If `self` ends with `needle`, `needle` is removed from the
434      *      end of `self`. Otherwise, `self` is unmodified.
435      * @param self The slice to operate on.
436      * @param needle The slice to search for.
437      * @return `self`
438      */
439     function until(slice self, slice needle) internal returns (slice) {
440         if (self._len < needle._len) {
441             return self;
442         }
443 
444         var selfptr = self._ptr + self._len - needle._len;
445         bool equal = true;
446         if (selfptr != needle._ptr) {
447             assembly {
448                 let length := mload(needle)
449                 let needleptr := mload(add(needle, 0x20))
450                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
451             }
452         }
453 
454         if (equal) {
455             self._len -= needle._len;
456         }
457 
458         return self;
459     }
460 
461     // Returns the memory address of the first byte of the first occurrence of
462     // `needle` in `self`, or the first byte after `self` if not found.
463     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
464         uint ptr;
465         uint idx;
466 
467         if (needlelen <= selflen) {
468             if (needlelen <= 32) {
469                 // Optimized assembly for 68 gas per byte on short strings
470                 assembly {
471                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
472                     let needledata := and(mload(needleptr), mask)
473                     let end := add(selfptr, sub(selflen, needlelen))
474                     ptr := selfptr
475                     loop:
476                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
477                     ptr := add(ptr, 1)
478                     jumpi(loop, lt(sub(ptr, 1), end))
479                     ptr := add(selfptr, selflen)
480                     exit:
481                 }
482                 return ptr;
483             } else {
484                 // For long needles, use hashing
485                 bytes32 hash;
486                 assembly { hash := sha3(needleptr, needlelen) }
487                 ptr = selfptr;
488                 for (idx = 0; idx <= selflen - needlelen; idx++) {
489                     bytes32 testHash;
490                     assembly { testHash := sha3(ptr, needlelen) }
491                     if (hash == testHash)
492                         return ptr;
493                     ptr += 1;
494                 }
495             }
496         }
497         return selfptr + selflen;
498     }
499 
500     // Returns the memory address of the first byte after the last occurrence of
501     // `needle` in `self`, or the address of `self` if not found.
502     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
503         uint ptr;
504 
505         if (needlelen <= selflen) {
506             if (needlelen <= 32) {
507                 // Optimized assembly for 69 gas per byte on short strings
508                 assembly {
509                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
510                     let needledata := and(mload(needleptr), mask)
511                     ptr := add(selfptr, sub(selflen, needlelen))
512                     loop:
513                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
514                     ptr := sub(ptr, 1)
515                     jumpi(loop, gt(add(ptr, 1), selfptr))
516                     ptr := selfptr
517                     jump(exit)
518                     ret:
519                     ptr := add(ptr, needlelen)
520                     exit:
521                 }
522                 return ptr;
523             } else {
524                 // For long needles, use hashing
525                 bytes32 hash;
526                 assembly { hash := sha3(needleptr, needlelen) }
527                 ptr = selfptr + (selflen - needlelen);
528                 while (ptr >= selfptr) {
529                     bytes32 testHash;
530                     assembly { testHash := sha3(ptr, needlelen) }
531                     if (hash == testHash)
532                         return ptr + needlelen;
533                     ptr -= 1;
534                 }
535             }
536         }
537         return selfptr;
538     }
539 
540     /*
541      * @dev Modifies `self` to contain everything from the first occurrence of
542      *      `needle` to the end of the slice. `self` is set to the empty slice
543      *      if `needle` is not found.
544      * @param self The slice to search and modify.
545      * @param needle The text to search for.
546      * @return `self`.
547      */
548     function find(slice self, slice needle) internal returns (slice) {
549         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
550         self._len -= ptr - self._ptr;
551         self._ptr = ptr;
552         return self;
553     }
554 
555     /*
556      * @dev Modifies `self` to contain the part of the string from the start of
557      *      `self` to the end of the first occurrence of `needle`. If `needle`
558      *      is not found, `self` is set to the empty slice.
559      * @param self The slice to search and modify.
560      * @param needle The text to search for.
561      * @return `self`.
562      */
563     function rfind(slice self, slice needle) internal returns (slice) {
564         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
565         self._len = ptr - self._ptr;
566         return self;
567     }
568 
569     /*
570      * @dev Splits the slice, setting `self` to everything after the first
571      *      occurrence of `needle`, and `token` to everything before it. If
572      *      `needle` does not occur in `self`, `self` is set to the empty slice,
573      *      and `token` is set to the entirety of `self`.
574      * @param self The slice to split.
575      * @param needle The text to search for in `self`.
576      * @param token An output parameter to which the first token is written.
577      * @return `token`.
578      */
579     function split(slice self, slice needle, slice token) internal returns (slice) {
580         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
581         token._ptr = self._ptr;
582         token._len = ptr - self._ptr;
583         if (ptr == self._ptr + self._len) {
584             // Not found
585             self._len = 0;
586         } else {
587             self._len -= token._len + needle._len;
588             self._ptr = ptr + needle._len;
589         }
590         return token;
591     }
592 
593     /*
594      * @dev Splits the slice, setting `self` to everything after the first
595      *      occurrence of `needle`, and returning everything before it. If
596      *      `needle` does not occur in `self`, `self` is set to the empty slice,
597      *      and the entirety of `self` is returned.
598      * @param self The slice to split.
599      * @param needle The text to search for in `self`.
600      * @return The part of `self` up to the first occurrence of `delim`.
601      */
602     function split(slice self, slice needle) internal returns (slice token) {
603         split(self, needle, token);
604     }
605 
606     /*
607      * @dev Splits the slice, setting `self` to everything before the last
608      *      occurrence of `needle`, and `token` to everything after it. If
609      *      `needle` does not occur in `self`, `self` is set to the empty slice,
610      *      and `token` is set to the entirety of `self`.
611      * @param self The slice to split.
612      * @param needle The text to search for in `self`.
613      * @param token An output parameter to which the first token is written.
614      * @return `token`.
615      */
616     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
617         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
618         token._ptr = ptr;
619         token._len = self._len - (ptr - self._ptr);
620         if (ptr == self._ptr) {
621             // Not found
622             self._len = 0;
623         } else {
624             self._len -= token._len + needle._len;
625         }
626         return token;
627     }
628 
629     /*
630      * @dev Splits the slice, setting `self` to everything before the last
631      *      occurrence of `needle`, and returning everything after it. If
632      *      `needle` does not occur in `self`, `self` is set to the empty slice,
633      *      and the entirety of `self` is returned.
634      * @param self The slice to split.
635      * @param needle The text to search for in `self`.
636      * @return The part of `self` after the last occurrence of `delim`.
637      */
638     function rsplit(slice self, slice needle) internal returns (slice token) {
639         rsplit(self, needle, token);
640     }
641 
642     /*
643      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
644      * @param self The slice to search.
645      * @param needle The text to search for in `self`.
646      * @return The number of occurrences of `needle` found in `self`.
647      */
648     function count(slice self, slice needle) internal returns (uint cnt) {
649         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
650         while (ptr <= self._ptr + self._len) {
651             cnt++;
652             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
653         }
654     }
655 
656     /*
657      * @dev Returns True if `self` contains `needle`.
658      * @param self The slice to search.
659      * @param needle The text to search for in `self`.
660      * @return True if `needle` is found in `self`, false otherwise.
661      */
662     function contains(slice self, slice needle) internal returns (bool) {
663         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
664     }
665 
666     /*
667      * @dev Returns a newly allocated string containing the concatenation of
668      *      `self` and `other`.
669      * @param self The first slice to concatenate.
670      * @param other The second slice to concatenate.
671      * @return The concatenation of the two strings.
672      */
673     function concat(slice self, slice other) internal returns (string) {
674         var ret = new string(self._len + other._len);
675         uint retptr;
676         assembly { retptr := add(ret, 32) }
677         memcpy(retptr, self._ptr, self._len);
678         memcpy(retptr + self._len, other._ptr, other._len);
679         return ret;
680     }
681 
682     /*
683      * @dev Joins an array of slices, using `self` as a delimiter, returning a
684      *      newly allocated string.
685      * @param self The delimiter to use.
686      * @param parts A list of slices to join.
687      * @return A newly allocated string containing all the slices in `parts`,
688      *         joined with `self`.
689      */
690     function join(slice self, slice[] parts) internal returns (string) {
691         if (parts.length == 0)
692             return "";
693 
694         uint length = self._len * (parts.length - 1);
695         for(uint i = 0; i < parts.length; i++)
696             length += parts[i]._len;
697 
698         var ret = new string(length);
699         uint retptr;
700         assembly { retptr := add(ret, 32) }
701 
702         for(i = 0; i < parts.length; i++) {
703             memcpy(retptr, parts[i]._ptr, parts[i]._len);
704             retptr += parts[i]._len;
705             if (i < parts.length - 1) {
706                 memcpy(retptr, self._ptr, self._len);
707                 retptr += self._len;
708             }
709         }
710 
711         return ret;
712     }
713 }
714 
715 /**
716  * @title SafeMath
717  * @dev Math operations with safety checks that throw on error
718  */
719 library SafeMath {
720 
721   /**
722   * @dev Multiplies two numbers, throws on overflow.
723   */
724   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
725     if (a == 0) {
726       return 0;
727     }
728     uint256 c = a * b;
729     assert(c / a == b);
730     return c;
731   }
732 
733   /**
734   * @dev Integer division of two numbers, truncating the quotient.
735   */
736   function div(uint256 a, uint256 b) internal pure returns (uint256) {
737     // assert(b > 0); // Solidity automatically throws when dividing by 0
738     uint256 c = a / b;
739     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
740     return c;
741   }
742 
743   /**
744   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
745   */
746   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
747     assert(b <= a);
748     return a - b;
749   }
750 
751   /**
752   * @dev Adds two numbers, throws on overflow.
753   */
754   function add(uint256 a, uint256 b) internal pure returns (uint256) {
755     uint256 c = a + b;
756     assert(c >= a);
757     return c;
758   }
759 }
760 
761 /**
762  * @title Ownable
763  * @dev The Ownable contract has an owner address, and provides basic authorization control
764  * functions, this simplifies the implementation of "user permissions".
765  */
766 contract Ownable {
767   address public owner;
768 
769 
770   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
771 
772 
773   /**
774    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
775    * account.
776    */
777   function Ownable() public {
778     owner = msg.sender;
779   }
780 
781   /**
782    * @dev Throws if called by any account other than the owner.
783    */
784   modifier onlyOwner() {
785     require(msg.sender == owner);
786     _;
787   }
788 
789   /**
790    * @dev Allows the current owner to transfer control of the contract to a newOwner.
791    * @param newOwner The address to transfer ownership to.
792    */
793   function transferOwnership(address newOwner) public onlyOwner {
794     require(newOwner != address(0));
795     OwnershipTransferred(owner, newOwner);
796     owner = newOwner;
797   }
798 
799 }
800 
801 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
802 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
803 contract ERC721 {
804   // Required methods
805   function approve(address _to, uint256 _tokenId) public;
806   function balanceOf(address _owner) public view returns (uint256 balance);
807   function implementsERC721() public pure returns (bool);
808   function ownerOf(uint256 _tokenId) public view returns (address addr);
809   function takeOwnership(uint256 _tokenId) public;
810   function totalSupply() public view returns (uint256 total);
811   function transferFrom(address _from, address _to, uint256 _tokenId) public;
812   function transfer(address _to, uint256 _tokenId) public;
813 
814   event Transfer(address indexed from, address indexed to, uint256 tokenId);
815   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
816 
817   // Optional
818   // function name() public view returns (string name);
819   // function symbol() public view returns (string symbol);
820   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
821   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
822 }
823 
824 contract ERC20 {
825   function allowance(address owner, address spender) public view returns (uint256);
826   function transferFrom(address from, address to, uint256 value) public returns (bool);
827   function approve(address spender, uint256 value) public returns (bool);
828 
829   function totalSupply() public view returns (uint256);
830   function balanceOf(address who) public view returns (uint256);
831   function transfer(address to, uint256 value) public returns (bool);
832 
833   event Approval(address indexed owner, address indexed spender, uint256 value);
834   event Transfer(address indexed from, address indexed to, uint256 value);
835 }
836 
837 /**
838  * @title Basic token
839  * @dev Basic version of StandardToken, with no allowances.
840  */
841 contract BasicToken is ERC20 {
842   using SafeMath for uint256;
843 
844   mapping(address => uint256) balances;
845 
846   uint256 totalSupply_;
847 
848   /**
849   * @dev total number of tokens in existence
850   */
851   function totalSupply() public view returns (uint256) {
852     return totalSupply_;
853   }
854 
855   /**
856   * @dev transfer token for a specified address
857   * @param _to The address to transfer to.
858   * @param _value The amount to be transferred.
859   */
860   function transfer(address _to, uint256 _value) public returns (bool) {
861     require(_to != address(0));
862     require(_value <= balances[msg.sender]);
863 
864     // SafeMath.sub will throw if there is not enough balance.
865     balances[msg.sender] = balances[msg.sender].sub(_value);
866     balances[_to] = balances[_to].add(_value);
867     Transfer(msg.sender, _to, _value);
868     return true;
869   }
870 
871   /**
872   * @dev Gets the balance of the specified address.
873   * @param _owner The address to query the the balance of.
874   * @return An uint256 representing the amount owned by the passed address.
875   */
876   function balanceOf(address _owner) public view returns (uint256 balance) {
877     return balances[_owner];
878   }
879 
880 }
881 
882 contract StandardToken is ERC20, BasicToken {
883 
884   mapping (address => mapping (address => uint256)) internal allowed;
885 
886 
887   /**
888    * @dev Transfer tokens from one address to another
889    * @param _from address The address which you want to send tokens from
890    * @param _to address The address which you want to transfer to
891    * @param _value uint256 the amount of tokens to be transferred
892    */
893   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
894     require(_to != address(0));
895     require(_value <= balances[_from]);
896     require(_value <= allowed[_from][msg.sender]);
897 
898     balances[_from] = balances[_from].sub(_value);
899     balances[_to] = balances[_to].add(_value);
900     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
901     Transfer(_from, _to, _value);
902     return true;
903   }
904 
905   /**
906    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
907    *
908    * Beware that changing an allowance with this method brings the risk that someone may use both the old
909    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
910    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
911    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
912    * @param _spender The address which will spend the funds.
913    * @param _value The amount of tokens to be spent.
914    */
915   function approve(address _spender, uint256 _value) public returns (bool) {
916     allowed[msg.sender][_spender] = _value;
917     Approval(msg.sender, _spender, _value);
918     return true;
919   }
920 
921   /**
922    * @dev Function to check the amount of tokens that an owner allowed to a spender.
923    * @param _owner address The address which owns the funds.
924    * @param _spender address The address which will spend the funds.
925    * @return A uint256 specifying the amount of tokens still available for the spender.
926    */
927   function allowance(address _owner, address _spender) public view returns (uint256) {
928     return allowed[_owner][_spender];
929   }
930 
931   /**
932    * @dev Increase the amount of tokens that an owner allowed to a spender.
933    *
934    * approve should be called when allowed[_spender] == 0. To increment
935    * allowed value is better to use this function to avoid 2 calls (and wait until
936    * the first transaction is mined)
937    * From MonolithDAO Token.sol
938    * @param _spender The address which will spend the funds.
939    * @param _addedValue The amount of tokens to increase the allowance by.
940    */
941   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
942     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
943     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
944     return true;
945   }
946 
947   /**
948    * @dev Decrease the amount of tokens that an owner allowed to a spender.
949    *
950    * approve should be called when allowed[_spender] == 0. To decrement
951    * allowed value is better to use this function to avoid 2 calls (and wait until
952    * the first transaction is mined)
953    * From MonolithDAO Token.sol
954    * @param _spender The address which will spend the funds.
955    * @param _subtractedValue The amount of tokens to decrease the allowance by.
956    */
957   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
958     uint oldValue = allowed[msg.sender][_spender];
959     if (_subtractedValue > oldValue) {
960       allowed[msg.sender][_spender] = 0;
961     } else {
962       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
963     }
964     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
965     return true;
966   }
967 
968 }
969 
970 contract MutableToken is StandardToken, Ownable {
971   event Mint(address indexed to, uint256 amount, uint256 balance, uint256 totalSupply);
972   event Burn(address indexed burner, uint256 value, uint256 balance, uint256 totalSupply);
973 
974   address master;
975 
976   function setContractMaster(address _newMaster) onlyOwner public {
977     require(_newMaster != address(0));
978     require(EmojiToken(_newMaster).isEmoji());
979     master = _newMaster;
980   }
981 
982   /**
983    * @dev Function to mint tokens
984    * @param _to The address that will receive the minted tokens.
985    * @param _amount The amount of tokens to mint.
986    * @return A boolean that indicates if the operation was successful.
987    */
988   function mint(address _to, uint256 _amount) public returns (bool) {
989     require(master == msg.sender);
990     totalSupply_ = totalSupply_.add(_amount);
991     balances[_to] = balances[_to].add(_amount);
992     Mint(_to, _amount, balances[_to], totalSupply_);
993     Transfer(address(0), _to, _amount);
994     return true;
995   }
996 
997   /**
998    * @dev Burns a specific amount of tokens.
999    * @param _value The amount of token to be burned.
1000    */
1001   function burn(uint256 _value, address _owner) public {
1002     require(master == msg.sender);
1003     require(_value <= balances[_owner]);
1004     // no need to require value <= totalSupply, since that would imply the
1005     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1006 
1007     address burner = _owner;
1008     balances[burner] = balances[burner].sub(_value);
1009     totalSupply_ = totalSupply_.sub(_value);
1010     Burn(burner, _value, balances[burner], totalSupply_);
1011   }
1012 
1013 }
1014 
1015 /* Base contract for ERC-20 Craft Token Collectibles. 
1016  * @title Crypto Emoji - #Emojinomics
1017  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1018  */
1019 contract CraftToken is MutableToken {
1020   string public name;
1021   string public symbol;
1022   uint8 public decimals;
1023 
1024   function CraftToken(string emoji, string symb) public {
1025     require(EmojiToken(msg.sender).isEmoji());
1026     master = msg.sender;
1027     name = emoji;
1028     symbol = symb;
1029     decimals = 8;
1030   }
1031 }
1032 
1033 
1034 /* Base contract for ERC-721 Emoji Token Collectibles. 
1035  * @title Crypto Emoji - #Emojinomics
1036  * @author Fazri Zubair & Farhan Khwaja (Lucid Sight, Inc.)
1037  */
1038 contract EmojiToken is ERC721 {
1039   using strings for *;
1040 
1041   /*** EVENTS ***/
1042   event Birth(uint256 tokenId, string name, address owner);
1043 
1044   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
1045 
1046   event Transfer(address from, address to, uint256 tokenId);
1047 
1048   event EmojiMessageUpdated(address from, uint256 tokenId, string message);
1049 
1050   event TokenBurnt(uint256 tokenId, address master);
1051 
1052   /*** CONSTANTS ***/
1053 
1054   /// @notice Name and symbol of the non fungible token, as defined in ERC721.
1055   string public constant NAME = "CryptoEmoji";
1056   string public constant SYMBOL = "CE";
1057 
1058   uint256 private constant PROMO_CREATION_LIMIT = 1000;
1059 
1060   uint256 private startingPrice = 0.001 ether;
1061   uint256 private firstStepLimit =  0.063 ether;
1062   uint256 private secondStepLimit = 0.52 ether;
1063 
1064   //5% to contract
1065   uint256 ownerCut = 5;
1066 
1067   bool ownerCutIsLocked;
1068 
1069   //One Craft token 1 has 8 decimals
1070   uint256 oneCraftToken = 100000000;
1071 
1072   /*** STORAGE ***/
1073 
1074   /// @dev A mapping from EMOJI IDs to the address that owns them. All emojis must have
1075   ///  some valid owner address.
1076   mapping (uint256 => address) public emojiIndexToOwner;
1077 
1078   // @dev A mapping from owner address to count of tokens that address owns.
1079   //  Used internally inside balanceOf() to resolve ownership count.
1080   mapping (address => uint256) private ownershipTokenCount;
1081 
1082   /// @dev A mapping from Emojis to an address that has been approved to call
1083   ///  transferFrom(). Each Emoji can only have one approved address for transfer
1084   ///  at any time. A zero value means no approval is outstanding.
1085   mapping (uint256 => address) public emojiIndexToApproved;
1086 
1087   // @dev A mapping from emojis to the price of the token.
1088   mapping (uint256 => uint256) private emojiIndexToPrice;
1089 
1090   // @dev A mapping from emojis in existence 
1091   mapping (string => bool) private emojiCreated;
1092 
1093   mapping (uint256 => address) private emojiCraftTokenAddress;
1094 
1095   // The addresses of the accounts (or contracts) that can execute actions within each roles.
1096   address public ceoAddress;
1097   address public cooAddress;
1098 
1099   uint256 public promoCreatedCount;
1100 
1101   /*** DATATYPES ***/
1102   struct Emoji {
1103     string name;
1104     string msg;
1105   }
1106 
1107   struct MemoryHolder {
1108     mapping(uint256 => uint256) bal;
1109     mapping(uint256 => uint256) used;
1110   }
1111 
1112 
1113   Emoji[] private emojis;
1114 
1115   /*** ACCESS MODIFIERS ***/
1116   /// @dev Access modifier for CEO-only functionality
1117   modifier onlyCEO() {
1118     require(msg.sender == ceoAddress);
1119     _;
1120   }
1121 
1122   /// @dev Access modifier for COO-only functionality
1123   modifier onlyCOO() {
1124     require(msg.sender == cooAddress);
1125     _;
1126   }
1127   
1128   /// Access modifier for contract owner only functionality
1129   modifier onlyCLevel() {
1130     require(
1131       msg.sender == ceoAddress ||
1132       msg.sender == cooAddress
1133     );
1134     _;
1135   }
1136   
1137   /*** CONSTRUCTOR ***/
1138   function EmojiToken() public {
1139     ceoAddress = msg.sender;
1140     cooAddress = msg.sender;
1141   }
1142 
1143   function isEmoji() public returns (bool) {
1144     return true;
1145   }
1146 
1147   /// @notice Here for bug related migration
1148   function migrateCraftTokenMaster(uint tokenId, address newMasterContract) public onlyCLevel {
1149     CraftToken(emojiCraftTokenAddress[tokenId]).setContractMaster(newMasterContract);
1150   }
1151 
1152   /*** PUBLIC FUNCTIONS ***/
1153   /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
1154   /// @param _to The address to be granted transfer approval. Pass address(0) to
1155   ///  clear all approvals.
1156   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1157   /// @dev Required for ERC-721 compliance.
1158   function approve(
1159     address _to,
1160     uint256 _tokenId
1161   ) public {
1162     // Caller must own token.
1163     require(_owns(msg.sender, _tokenId));
1164 
1165     emojiIndexToApproved[_tokenId] = _to;
1166 
1167     Approval(msg.sender, _to, _tokenId);
1168   }
1169 
1170   /// For querying balance of a particular account
1171   /// @param _owner The address for balance query
1172   /// @dev Required for ERC-721 compliance.
1173   function balanceOf(address _owner) public view returns (uint256 balance) {
1174     return ownershipTokenCount[_owner];
1175   }
1176 
1177   
1178   /// @dev Creates a new promo Emoji with the given name, with given _price and assignes it to an address.
1179   function createPromoEmoji(address _owner, string _name, string _symb, uint256 _price) public onlyCLevel {
1180     require(promoCreatedCount < PROMO_CREATION_LIMIT);
1181 
1182     address emojiOwner = _owner;
1183     if (emojiOwner == address(0)) {
1184       emojiOwner = cooAddress;
1185     }
1186 
1187     if (_price <= 0) {
1188       _price = startingPrice;
1189     }
1190 
1191     promoCreatedCount++;
1192 
1193     uint256 indx = _createEmoji(_name, emojiOwner, _price);
1194     //Creates token contract
1195     emojiCraftTokenAddress[indx] = new CraftToken(_name, _symb);
1196   }
1197 
1198   /// @dev Creates a new Emoji with the given name.
1199   function createBaseEmoji(string _name, string _symb) public onlyCLevel {
1200     uint256 indx = _createEmoji(_name, address(this), startingPrice);
1201     //Creates token contract
1202     emojiCraftTokenAddress[indx] = new CraftToken(_name, _symb);
1203   }
1204 
1205   function createEmojiStory(uint[] _parts) public {
1206     MemoryHolder storage memD;
1207 
1208     string memory mashUp = "";
1209     uint price;
1210 
1211     for(uint i = 0; i < _parts.length; i++) {
1212 
1213       if(memD.bal[_parts[i]] == 0) {
1214         memD.bal[_parts[i]] = CraftToken(emojiCraftTokenAddress[_parts[i]]).balanceOf(msg.sender);
1215       }
1216       memD.used[_parts[i]]++;
1217 
1218       require(CraftToken(emojiCraftTokenAddress[_parts[i]]).balanceOf(msg.sender) >= memD.used[_parts[i]]);
1219 
1220       price += emojiIndexToPrice[_parts[i]];
1221       mashUp = mashUp.toSlice().concat(emojis[_parts[i]].name.toSlice()); 
1222     }
1223       
1224     //Creates Mash Up
1225     _createEmoji(mashUp,msg.sender,price);
1226 
1227     //BURN
1228     for(uint iii = 0; iii < _parts.length; iii++) {
1229       CraftToken(emojiCraftTokenAddress[_parts[iii]]).burn(oneCraftToken, msg.sender);
1230       TokenBurnt(_parts[iii], emojiCraftTokenAddress[_parts[iii]]);
1231     }
1232     
1233   }
1234 
1235    /// @notice Returns all the relevant information about a specific emoji.
1236   /// @param _tokenId The tokenId of the emoji of interest.
1237   function getCraftTokenAddress(uint256 _tokenId) public view returns (
1238     address masterErc20
1239   ) {
1240     masterErc20 = emojiCraftTokenAddress[_tokenId];
1241   }
1242 
1243   /// @notice Returns all the relevant information about a specific emoji.
1244   /// @param _tokenId The tokenId of the emoji of interest.
1245   function getEmoji(uint256 _tokenId) public view returns (
1246     string emojiName,
1247     string emojiMsg,
1248     uint256 sellingPrice,
1249     address owner
1250   ) {
1251     Emoji storage emojiObj = emojis[_tokenId];
1252     emojiName = emojiObj.name;
1253     emojiMsg = emojiObj.msg;
1254     sellingPrice = emojiIndexToPrice[_tokenId];
1255     owner = emojiIndexToOwner[_tokenId];
1256   }
1257 
1258   function implementsERC721() public pure returns (bool) {
1259     return true;
1260   }
1261 
1262   /// @dev Required for ERC-721 compliance.
1263   function name() public pure returns (string) {
1264     return NAME;
1265   }
1266 
1267   /// For querying owner of token
1268   /// @param _tokenId The tokenID for owner inquiry
1269   /// @dev Required for ERC-721 compliance.
1270   function ownerOf(uint256 _tokenId)
1271     public
1272     view
1273     returns (address owner)
1274   {
1275     owner = emojiIndexToOwner[_tokenId];
1276     require(owner != address(0));
1277   }
1278 
1279   function payout(address _to) public onlyCLevel {
1280     _payout(_to);
1281   }
1282 
1283   // Allows someone to send ether and obtain the token
1284   function purchase(uint256 _tokenId) public payable {
1285     address oldOwner = emojiIndexToOwner[_tokenId];
1286     uint sellingPrice = emojiIndexToPrice[_tokenId];
1287     address newOwner = msg.sender;
1288 
1289     // Making sure token owner is not sending to self
1290     require(oldOwner != newOwner);
1291 
1292     // Safety check to prevent against an unexpected 0x0 default.
1293     require(_addressNotNull(newOwner));
1294 
1295     // Making sure sent amount is greater than or equal to the sellingPrice
1296     require(msg.value >= sellingPrice);
1297 
1298     uint256 percentage = SafeMath.sub(100, ownerCut);
1299     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, percentage), 100));
1300     uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
1301 
1302     // Update prices
1303     if (sellingPrice < firstStepLimit) {
1304       // first stage
1305       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), percentage);
1306     } else if (sellingPrice < secondStepLimit) {
1307       // second stage
1308       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 130), percentage);
1309     } else {
1310       // third stage
1311       emojiIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 115), percentage);
1312     }
1313 
1314     _transfer(oldOwner, newOwner, _tokenId);
1315 
1316     // Pay previous tokenOwner if owner is not contract
1317     if (oldOwner != address(this)) {
1318       oldOwner.transfer(payment); //(1-0.06)
1319     }
1320 
1321     TokenSold(_tokenId, sellingPrice, emojiIndexToPrice[_tokenId], oldOwner, newOwner, emojis[_tokenId].name);
1322 
1323     msg.sender.transfer(purchaseExcess);
1324 
1325     //if Non-Story
1326     if(emojiCraftTokenAddress[_tokenId] != address(0)) {
1327       CraftToken(emojiCraftTokenAddress[_tokenId]).mint(oldOwner,oneCraftToken);
1328       CraftToken(emojiCraftTokenAddress[_tokenId]).mint(msg.sender,oneCraftToken);
1329     }
1330     
1331   }
1332 
1333   function transferTokenToCEO(uint256 _tokenId, uint qty) public onlyCLevel {
1334     CraftToken(emojiCraftTokenAddress[_tokenId]).transfer(ceoAddress,qty);
1335   }
1336 
1337   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
1338     return emojiIndexToPrice[_tokenId];
1339   }
1340 
1341   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
1342   /// @param _newCEO The address of the new CEO
1343   function setCEO(address _newCEO) public onlyCEO {
1344     require(_newCEO != address(0));
1345 
1346     ceoAddress = _newCEO;
1347   }
1348 
1349   /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
1350   /// @param _newCOO The address of the new COO
1351   function setCOO(address _newCOO) public onlyCOO {
1352     require(_newCOO != address(0));
1353 
1354     cooAddress = _newCOO;
1355   }
1356 
1357   /// @dev Required for ERC-721 compliance.
1358   function symbol() public pure returns (string) {
1359     return SYMBOL;
1360   }
1361 
1362   /// @notice Allow pre-approved user to take ownership of a token
1363   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1364   /// @dev Required for ERC-721 compliance.
1365   function takeOwnership(uint256 _tokenId) public {
1366     address newOwner = msg.sender;
1367     address oldOwner = emojiIndexToOwner[_tokenId];
1368 
1369     // Safety check to prevent against an unexpected 0x0 default.
1370     require(_addressNotNull(newOwner));
1371 
1372     // Making sure transfer is approved
1373     require(_approved(newOwner, _tokenId));
1374 
1375     _transfer(oldOwner, newOwner, _tokenId);
1376   }
1377 
1378   function setEmojiMsg(uint256 _tokenId, string message) public {
1379     require(_owns(msg.sender, _tokenId));
1380     Emoji storage item = emojis[_tokenId];
1381     item.msg = bytes32ToString(stringToBytes32(message));
1382 
1383     EmojiMessageUpdated(msg.sender, _tokenId, item.msg);
1384   }
1385 
1386   function stringToBytes32(string memory source) internal returns (bytes32 result) {
1387         bytes memory tempEmptyStringTest = bytes(source);
1388         if (tempEmptyStringTest.length == 0) {
1389             return 0x0;
1390         }
1391     
1392         assembly {
1393             result := mload(add(source, 32))
1394         }
1395     }
1396 
1397   function bytes32ToString(bytes32 x) constant internal returns (string) {
1398         bytes memory bytesString = new bytes(32);
1399         uint charCount = 0;
1400         for (uint j = 0; j < 32; j++) {
1401             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
1402             if (char != 0) {
1403                 bytesString[charCount] = char;
1404                 charCount++;
1405             }
1406         }
1407         bytes memory bytesStringTrimmed = new bytes(charCount);
1408         for (j = 0; j < charCount; j++) {
1409             bytesStringTrimmed[j] = bytesString[j];
1410         }
1411         return string(bytesStringTrimmed);
1412     }
1413 
1414   /// @param _owner The owner whose emoji tokens we are interested in.
1415   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
1416   ///  expensive (it walks the entire Emojis array looking for emojis belonging to owner),
1417   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
1418   ///  not contract-to-contract calls.
1419   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
1420     uint256 tokenCount = balanceOf(_owner);
1421     if (tokenCount == 0) {
1422         // Return an empty array
1423       return new uint256[](0);
1424     } else {
1425       uint256[] memory result = new uint256[](tokenCount);
1426       uint256 totalEmojis = totalSupply();
1427       uint256 resultIndex = 0;
1428 
1429       uint256 emojiId;
1430       for (emojiId = 0; emojiId <= totalEmojis; emojiId++) {
1431         if (emojiIndexToOwner[emojiId] == _owner) {
1432           result[resultIndex] = emojiId;
1433           resultIndex++;
1434         }
1435       }
1436       return result;
1437     }
1438   }
1439 
1440   /// For querying totalSupply of token
1441   /// @dev Required for ERC-721 compliance.
1442   function totalSupply() public view returns (uint256 total) {
1443     return emojis.length;
1444   }
1445 
1446   /// Owner initates the transfer of the token to another account
1447   /// @param _to The address for the token to be transferred to.
1448   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1449   /// @dev Required for ERC-721 compliance.
1450   function transfer(
1451     address _to,
1452     uint256 _tokenId
1453   ) public {
1454     require(_owns(msg.sender, _tokenId));
1455     require(_addressNotNull(_to));
1456 
1457     _transfer(msg.sender, _to, _tokenId);
1458   }
1459 
1460   /// Third-party initiates transfer of token from address _from to address _to
1461   /// @param _from The address for the token to be transferred from.
1462   /// @param _to The address for the token to be transferred to.
1463   /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
1464   /// @dev Required for ERC-721 compliance.
1465   function transferFrom(
1466     address _from,
1467     address _to,
1468     uint256 _tokenId
1469   ) public {
1470     require(_owns(_from, _tokenId));
1471     require(_approved(_to, _tokenId));
1472     require(_addressNotNull(_to));
1473 
1474     _transfer(_from, _to, _tokenId);
1475   }
1476 
1477   /*** PRIVATE FUNCTIONS ***/
1478   /// Safety check on _to address to prevent against an unexpected 0x0 default.
1479   function _addressNotNull(address _to) private pure returns (bool) {
1480     return _to != address(0);
1481   }
1482 
1483   /// For checking approval of transfer for address _to
1484   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
1485     return emojiIndexToApproved[_tokenId] == _to;
1486   }
1487 
1488   /// For creating Emoji
1489   function _createEmoji(string _name, address _owner, uint256 _price) private returns(uint256) {
1490     require(emojiCreated[_name] == false);
1491     Emoji memory _emoji = Emoji({
1492       name: _name,
1493       msg: "?New?"
1494     });
1495     uint256 newEmojiId = emojis.push(_emoji) - 1;
1496 
1497     // It's probably never going to happen, 4 billion tokens are A LOT, but
1498     // let's just be 100% sure we never let this happen.
1499     require(newEmojiId == uint256(uint32(newEmojiId)));
1500 
1501     Birth(newEmojiId, _name, _owner);
1502 
1503     emojiIndexToPrice[newEmojiId] = _price;
1504 
1505     // This will assign ownership, and also emit the Transfer event as
1506     // per ERC721 draft
1507     _transfer(address(0), _owner, newEmojiId);
1508     emojiCreated[_name] = true;
1509 
1510     return newEmojiId;
1511   }
1512 
1513   /// Check for token ownership
1514   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
1515     return claimant == emojiIndexToOwner[_tokenId];
1516   }
1517 
1518   /// For paying out balance on contract
1519   function _payout(address _to) private {
1520     if (_to == address(0)) {
1521       ceoAddress.transfer(this.balance);
1522     }
1523   }
1524 
1525   /// @dev Assigns ownership of a specific Emoji to an address.
1526   function _transfer(address _from, address _to, uint256 _tokenId) private {
1527     // Since the number of emojis is capped to 2^32 we can't overflow this
1528     ownershipTokenCount[_to]++;
1529     //transfer ownership
1530     emojiIndexToOwner[_tokenId] = _to;
1531 
1532     // When creating new emojis _from is 0x0, but we can't account that address.
1533     if (_from != address(0)) {
1534       ownershipTokenCount[_from]--;
1535       // clear any previously approved ownership exchange
1536       delete emojiIndexToApproved[_tokenId];
1537     }
1538 
1539     // Emit the transfer event.
1540     Transfer(_from, _to, _tokenId);
1541   }
1542 
1543   /// @dev Updates ownerCut
1544   function updateOwnerCut(uint256 _newCut) external onlyCLevel{
1545     require(ownerCut <= 9);
1546     require(ownerCutIsLocked == false);
1547     ownerCut = _newCut;
1548   }
1549 
1550   /// @dev Lock ownerCut
1551   function lockOwnerCut(uint confirmCode) external onlyCLevel{
1552     /// Not a secert just to make sure we don't accidentally submit this function
1553     if(confirmCode == 197428124) {
1554     ownerCutIsLocked = true;
1555     }
1556   }
1557 }