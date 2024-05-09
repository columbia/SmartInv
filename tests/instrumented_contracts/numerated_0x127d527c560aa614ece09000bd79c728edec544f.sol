1 pragma solidity ^0.4.11;
2 
3 
4 
5 /*
6  * @title String & slice utility library for Solidity contracts.
7  * @author Nick Johnson <arachnid@notdot.net>
8  *
9  * @dev Functionality in this library is largely implemented using an
10  *      abstraction called a 'slice'. A slice represents a part of a string -
11  *      anything from the entire string to a single character, or even no
12  *      characters at all (a 0-length slice). Since a slice only has to specify
13  *      an offset and a length, copying and manipulating slices is a lot less
14  *      expensive than copying and manipulating the strings they reference.
15  *
16  *      To further reduce gas costs, most functions on slice that need to return
17  *      a slice modify the original one instead of allocating a new one; for
18  *      instance, `s.split(".")` will return the text up to the first '.',
19  *      modifying s to only contain the remainder of the string after the '.'.
20  *      In situations where you do not want to modify the original slice, you
21  *      can make a copy first with `.copy()`, for example:
22  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
23  *      Solidity has no memory management, it will result in allocating many
24  *      short-lived slices that are later discarded.
25  *
26  *      Functions that return two slices come in two versions: a non-allocating
27  *      version that takes the second slice as an argument, modifying it in
28  *      place, and an allocating version that allocates and returns the second
29  *      slice; see `nextRune` for example.
30  *
31  *      Functions that have to copy string data will return strings rather than
32  *      slices; these can be cast back to slices for further processing if
33  *      required.
34  *
35  *      For convenience, some functions are provided with non-modifying
36  *      variants that create a new slice and return both; for instance,
37  *      `s.splitNew('.')` leaves s unmodified, and returns two values
38  *      corresponding to the left and right parts of the string.
39  */
40 
41 pragma solidity ^0.4.14;
42 
43 library strings {
44     struct slice {
45         uint _len;
46         uint _ptr;
47     }
48 
49     function memcpy(uint dest, uint src, uint len) private pure {
50         // Copy word-length chunks while possible
51         for(; len >= 32; len -= 32) {
52             assembly {
53                 mstore(dest, mload(src))
54             }
55             dest += 32;
56             src += 32;
57         }
58 
59         // Copy remaining bytes
60         uint mask = 256 ** (32 - len) - 1;
61         assembly {
62             let srcpart := and(mload(src), not(mask))
63             let destpart := and(mload(dest), mask)
64             mstore(dest, or(destpart, srcpart))
65         }
66     }
67 
68     /*
69      * @dev Returns a slice containing the entire string.
70      * @param self The string to make a slice from.
71      * @return A newly allocated slice containing the entire string.
72      */
73     function toSlice(string self) internal pure returns (slice) {
74         uint ptr;
75         assembly {
76             ptr := add(self, 0x20)
77         }
78         return slice(bytes(self).length, ptr);
79     }
80 
81     /*
82      * @dev Returns the length of a null-terminated bytes32 string.
83      * @param self The value to find the length of.
84      * @return The length of the string, from 0 to 32.
85      */
86     function len(bytes32 self) internal pure returns (uint) {
87         uint ret;
88         if (self == 0)
89             return 0;
90         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
91             ret += 16;
92             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
93         }
94         if (self & 0xffffffffffffffff == 0) {
95             ret += 8;
96             self = bytes32(uint(self) / 0x10000000000000000);
97         }
98         if (self & 0xffffffff == 0) {
99             ret += 4;
100             self = bytes32(uint(self) / 0x100000000);
101         }
102         if (self & 0xffff == 0) {
103             ret += 2;
104             self = bytes32(uint(self) / 0x10000);
105         }
106         if (self & 0xff == 0) {
107             ret += 1;
108         }
109         return 32 - ret;
110     }
111 
112     /*
113      * @dev Returns a slice containing the entire bytes32, interpreted as a
114      *      null-terminated utf-8 string.
115      * @param self The bytes32 value to convert to a slice.
116      * @return A new slice containing the value of the input argument up to the
117      *         first null.
118      */
119     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
120         // Allocate space for `self` in memory, copy it there, and point ret at it
121         assembly {
122             let ptr := mload(0x40)
123             mstore(0x40, add(ptr, 0x20))
124             mstore(ptr, self)
125             mstore(add(ret, 0x20), ptr)
126         }
127         ret._len = len(self);
128     }
129 
130     /*
131      * @dev Returns a new slice containing the same data as the current slice.
132      * @param self The slice to copy.
133      * @return A new slice containing the same data as `self`.
134      */
135     function copy(slice self) internal pure returns (slice) {
136         return slice(self._len, self._ptr);
137     }
138 
139     /*
140      * @dev Copies a slice to a new string.
141      * @param self The slice to copy.
142      * @return A newly allocated string containing the slice's text.
143      */
144     function toString(slice self) internal pure returns (string) {
145         string memory ret = new string(self._len);
146         uint retptr;
147         assembly { retptr := add(ret, 32) }
148 
149         memcpy(retptr, self._ptr, self._len);
150         return ret;
151     }
152 
153     /*
154      * @dev Returns the length in runes of the slice. Note that this operation
155      *      takes time proportional to the length of the slice; avoid using it
156      *      in loops, and call `slice.empty()` if you only need to know whether
157      *      the slice is empty or not.
158      * @param self The slice to operate on.
159      * @return The length of the slice in runes.
160      */
161     function len(slice self) internal pure returns (uint l) {
162         // Starting at ptr-31 means the LSB will be the byte we care about
163         uint ptr = self._ptr - 31;
164         uint end = ptr + self._len;
165         for (l = 0; ptr < end; l++) {
166             uint8 b;
167             assembly { b := and(mload(ptr), 0xFF) }
168             if (b < 0x80) {
169                 ptr += 1;
170             } else if(b < 0xE0) {
171                 ptr += 2;
172             } else if(b < 0xF0) {
173                 ptr += 3;
174             } else if(b < 0xF8) {
175                 ptr += 4;
176             } else if(b < 0xFC) {
177                 ptr += 5;
178             } else {
179                 ptr += 6;
180             }
181         }
182     }
183 
184     /*
185      * @dev Returns true if the slice is empty (has a length of 0).
186      * @param self The slice to operate on.
187      * @return True if the slice is empty, False otherwise.
188      */
189     function empty(slice self) internal pure returns (bool) {
190         return self._len == 0;
191     }
192 
193     /*
194      * @dev Returns a positive number if `other` comes lexicographically after
195      *      `self`, a negative number if it comes before, or zero if the
196      *      contents of the two slices are equal. Comparison is done per-rune,
197      *      on unicode codepoints.
198      * @param self The first slice to compare.
199      * @param other The second slice to compare.
200      * @return The result of the comparison.
201      */
202     function compare(slice self, slice other) internal pure returns (int) {
203         uint shortest = self._len;
204         if (other._len < self._len)
205             shortest = other._len;
206 
207         uint selfptr = self._ptr;
208         uint otherptr = other._ptr;
209         for (uint idx = 0; idx < shortest; idx += 32) {
210             uint a;
211             uint b;
212             assembly {
213                 a := mload(selfptr)
214                 b := mload(otherptr)
215             }
216             if (a != b) {
217                 // Mask out irrelevant bytes and check again
218                 uint256 mask = uint256(-1); // 0xffff...
219                 if(shortest < 32) {
220                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
221                 }
222                 uint256 diff = (a & mask) - (b & mask);
223                 if (diff != 0)
224                     return int(diff);
225             }
226             selfptr += 32;
227             otherptr += 32;
228         }
229         return int(self._len) - int(other._len);
230     }
231 
232     /*
233      * @dev Returns true if the two slices contain the same text.
234      * @param self The first slice to compare.
235      * @param self The second slice to compare.
236      * @return True if the slices are equal, false otherwise.
237      */
238     function equals(slice self, slice other) internal pure returns (bool) {
239         return compare(self, other) == 0;
240     }
241 
242     /*
243      * @dev Extracts the first rune in the slice into `rune`, advancing the
244      *      slice to point to the next rune and returning `self`.
245      * @param self The slice to operate on.
246      * @param rune The slice that will contain the first rune.
247      * @return `rune`.
248      */
249     function nextRune(slice self, slice rune) internal pure returns (slice) {
250         rune._ptr = self._ptr;
251 
252         if (self._len == 0) {
253             rune._len = 0;
254             return rune;
255         }
256 
257         uint l;
258         uint b;
259         // Load the first byte of the rune into the LSBs of b
260         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
261         if (b < 0x80) {
262             l = 1;
263         } else if(b < 0xE0) {
264             l = 2;
265         } else if(b < 0xF0) {
266             l = 3;
267         } else {
268             l = 4;
269         }
270 
271         // Check for truncated codepoints
272         if (l > self._len) {
273             rune._len = self._len;
274             self._ptr += self._len;
275             self._len = 0;
276             return rune;
277         }
278 
279         self._ptr += l;
280         self._len -= l;
281         rune._len = l;
282         return rune;
283     }
284 
285     /*
286      * @dev Returns the first rune in the slice, advancing the slice to point
287      *      to the next rune.
288      * @param self The slice to operate on.
289      * @return A slice containing only the first rune from `self`.
290      */
291     function nextRune(slice self) internal pure returns (slice ret) {
292         nextRune(self, ret);
293     }
294 
295     /*
296      * @dev Returns the number of the first codepoint in the slice.
297      * @param self The slice to operate on.
298      * @return The number of the first codepoint in the slice.
299      */
300     function ord(slice self) internal pure returns (uint ret) {
301         if (self._len == 0) {
302             return 0;
303         }
304 
305         uint word;
306         uint length;
307         uint divisor = 2 ** 248;
308 
309         // Load the rune into the MSBs of b
310         assembly { word:= mload(mload(add(self, 32))) }
311         uint b = word / divisor;
312         if (b < 0x80) {
313             ret = b;
314             length = 1;
315         } else if(b < 0xE0) {
316             ret = b & 0x1F;
317             length = 2;
318         } else if(b < 0xF0) {
319             ret = b & 0x0F;
320             length = 3;
321         } else {
322             ret = b & 0x07;
323             length = 4;
324         }
325 
326         // Check for truncated codepoints
327         if (length > self._len) {
328             return 0;
329         }
330 
331         for (uint i = 1; i < length; i++) {
332             divisor = divisor / 256;
333             b = (word / divisor) & 0xFF;
334             if (b & 0xC0 != 0x80) {
335                 // Invalid UTF-8 sequence
336                 return 0;
337             }
338             ret = (ret * 64) | (b & 0x3F);
339         }
340 
341         return ret;
342     }
343 
344     /*
345      * @dev Returns the keccak-256 hash of the slice.
346      * @param self The slice to hash.
347      * @return The hash of the slice.
348      */
349     function keccak(slice self) internal pure returns (bytes32 ret) {
350         assembly {
351             ret := keccak256(mload(add(self, 32)), mload(self))
352         }
353     }
354 
355     /*
356      * @dev Returns true if `self` starts with `needle`.
357      * @param self The slice to operate on.
358      * @param needle The slice to search for.
359      * @return True if the slice starts with the provided text, false otherwise.
360      */
361     function startsWith(slice self, slice needle) internal pure returns (bool) {
362         if (self._len < needle._len) {
363             return false;
364         }
365 
366         if (self._ptr == needle._ptr) {
367             return true;
368         }
369 
370         bool equal;
371         assembly {
372             let length := mload(needle)
373             let selfptr := mload(add(self, 0x20))
374             let needleptr := mload(add(needle, 0x20))
375             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
376         }
377         return equal;
378     }
379 
380     /*
381      * @dev If `self` starts with `needle`, `needle` is removed from the
382      *      beginning of `self`. Otherwise, `self` is unmodified.
383      * @param self The slice to operate on.
384      * @param needle The slice to search for.
385      * @return `self`
386      */
387     function beyond(slice self, slice needle) internal pure returns (slice) {
388         if (self._len < needle._len) {
389             return self;
390         }
391 
392         bool equal = true;
393         if (self._ptr != needle._ptr) {
394             assembly {
395                 let length := mload(needle)
396                 let selfptr := mload(add(self, 0x20))
397                 let needleptr := mload(add(needle, 0x20))
398                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
399             }
400         }
401 
402         if (equal) {
403             self._len -= needle._len;
404             self._ptr += needle._len;
405         }
406 
407         return self;
408     }
409 
410     /*
411      * @dev Returns true if the slice ends with `needle`.
412      * @param self The slice to operate on.
413      * @param needle The slice to search for.
414      * @return True if the slice starts with the provided text, false otherwise.
415      */
416     function endsWith(slice self, slice needle) internal pure returns (bool) {
417         if (self._len < needle._len) {
418             return false;
419         }
420 
421         uint selfptr = self._ptr + self._len - needle._len;
422 
423         if (selfptr == needle._ptr) {
424             return true;
425         }
426 
427         bool equal;
428         assembly {
429             let length := mload(needle)
430             let needleptr := mload(add(needle, 0x20))
431             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
432         }
433 
434         return equal;
435     }
436 
437     /*
438      * @dev If `self` ends with `needle`, `needle` is removed from the
439      *      end of `self`. Otherwise, `self` is unmodified.
440      * @param self The slice to operate on.
441      * @param needle The slice to search for.
442      * @return `self`
443      */
444     function until(slice self, slice needle) internal pure returns (slice) {
445         if (self._len < needle._len) {
446             return self;
447         }
448 
449         uint selfptr = self._ptr + self._len - needle._len;
450         bool equal = true;
451         if (selfptr != needle._ptr) {
452             assembly {
453                 let length := mload(needle)
454                 let needleptr := mload(add(needle, 0x20))
455                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
456             }
457         }
458 
459         if (equal) {
460             self._len -= needle._len;
461         }
462 
463         return self;
464     }
465 
466     event log_bytemask(bytes32 mask);
467 
468     // Returns the memory address of the first byte of the first occurrence of
469     // `needle` in `self`, or the first byte after `self` if not found.
470     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
471         uint ptr = selfptr;
472         uint idx;
473 
474         if (needlelen <= selflen) {
475             if (needlelen <= 32) {
476                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
477 
478                 bytes32 needledata;
479                 assembly { needledata := and(mload(needleptr), mask) }
480 
481                 uint end = selfptr + selflen - needlelen;
482                 bytes32 ptrdata;
483                 assembly { ptrdata := and(mload(ptr), mask) }
484 
485                 while (ptrdata != needledata) {
486                     if (ptr >= end)
487                         return selfptr + selflen;
488                     ptr++;
489                     assembly { ptrdata := and(mload(ptr), mask) }
490                 }
491                 return ptr;
492             } else {
493                 // For long needles, use hashing
494                 bytes32 hash;
495                 assembly { hash := sha3(needleptr, needlelen) }
496 
497                 for (idx = 0; idx <= selflen - needlelen; idx++) {
498                     bytes32 testHash;
499                     assembly { testHash := sha3(ptr, needlelen) }
500                     if (hash == testHash)
501                         return ptr;
502                     ptr += 1;
503                 }
504             }
505         }
506         return selfptr + selflen;
507     }
508 
509     // Returns the memory address of the first byte after the last occurrence of
510     // `needle` in `self`, or the address of `self` if not found.
511     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
512         uint ptr;
513 
514         if (needlelen <= selflen) {
515             if (needlelen <= 32) {
516                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
517 
518                 bytes32 needledata;
519                 assembly { needledata := and(mload(needleptr), mask) }
520 
521                 ptr = selfptr + selflen - needlelen;
522                 bytes32 ptrdata;
523                 assembly { ptrdata := and(mload(ptr), mask) }
524 
525                 while (ptrdata != needledata) {
526                     if (ptr <= selfptr)
527                         return selfptr;
528                     ptr--;
529                     assembly { ptrdata := and(mload(ptr), mask) }
530                 }
531                 return ptr + needlelen;
532             } else {
533                 // For long needles, use hashing
534                 bytes32 hash;
535                 assembly { hash := sha3(needleptr, needlelen) }
536                 ptr = selfptr + (selflen - needlelen);
537                 while (ptr >= selfptr) {
538                     bytes32 testHash;
539                     assembly { testHash := sha3(ptr, needlelen) }
540                     if (hash == testHash)
541                         return ptr + needlelen;
542                     ptr -= 1;
543                 }
544             }
545         }
546         return selfptr;
547     }
548 
549     /*
550      * @dev Modifies `self` to contain everything from the first occurrence of
551      *      `needle` to the end of the slice. `self` is set to the empty slice
552      *      if `needle` is not found.
553      * @param self The slice to search and modify.
554      * @param needle The text to search for.
555      * @return `self`.
556      */
557     function find(slice self, slice needle) internal pure returns (slice) {
558         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
559         self._len -= ptr - self._ptr;
560         self._ptr = ptr;
561         return self;
562     }
563 
564     /*
565      * @dev Modifies `self` to contain the part of the string from the start of
566      *      `self` to the end of the first occurrence of `needle`. If `needle`
567      *      is not found, `self` is set to the empty slice.
568      * @param self The slice to search and modify.
569      * @param needle The text to search for.
570      * @return `self`.
571      */
572     function rfind(slice self, slice needle) internal pure returns (slice) {
573         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
574         self._len = ptr - self._ptr;
575         return self;
576     }
577 
578     /*
579      * @dev Splits the slice, setting `self` to everything after the first
580      *      occurrence of `needle`, and `token` to everything before it. If
581      *      `needle` does not occur in `self`, `self` is set to the empty slice,
582      *      and `token` is set to the entirety of `self`.
583      * @param self The slice to split.
584      * @param needle The text to search for in `self`.
585      * @param token An output parameter to which the first token is written.
586      * @return `token`.
587      */
588     function split(slice self, slice needle, slice token) internal pure returns (slice) {
589         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
590         token._ptr = self._ptr;
591         token._len = ptr - self._ptr;
592         if (ptr == self._ptr + self._len) {
593             // Not found
594             self._len = 0;
595         } else {
596             self._len -= token._len + needle._len;
597             self._ptr = ptr + needle._len;
598         }
599         return token;
600     }
601 
602     /*
603      * @dev Splits the slice, setting `self` to everything after the first
604      *      occurrence of `needle`, and returning everything before it. If
605      *      `needle` does not occur in `self`, `self` is set to the empty slice,
606      *      and the entirety of `self` is returned.
607      * @param self The slice to split.
608      * @param needle The text to search for in `self`.
609      * @return The part of `self` up to the first occurrence of `delim`.
610      */
611     function split(slice self, slice needle) internal pure returns (slice token) {
612         split(self, needle, token);
613     }
614 
615     /*
616      * @dev Splits the slice, setting `self` to everything before the last
617      *      occurrence of `needle`, and `token` to everything after it. If
618      *      `needle` does not occur in `self`, `self` is set to the empty slice,
619      *      and `token` is set to the entirety of `self`.
620      * @param self The slice to split.
621      * @param needle The text to search for in `self`.
622      * @param token An output parameter to which the first token is written.
623      * @return `token`.
624      */
625     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
626         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
627         token._ptr = ptr;
628         token._len = self._len - (ptr - self._ptr);
629         if (ptr == self._ptr) {
630             // Not found
631             self._len = 0;
632         } else {
633             self._len -= token._len + needle._len;
634         }
635         return token;
636     }
637 
638     /*
639      * @dev Splits the slice, setting `self` to everything before the last
640      *      occurrence of `needle`, and returning everything after it. If
641      *      `needle` does not occur in `self`, `self` is set to the empty slice,
642      *      and the entirety of `self` is returned.
643      * @param self The slice to split.
644      * @param needle The text to search for in `self`.
645      * @return The part of `self` after the last occurrence of `delim`.
646      */
647     function rsplit(slice self, slice needle) internal pure returns (slice token) {
648         rsplit(self, needle, token);
649     }
650 
651     /*
652      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
653      * @param self The slice to search.
654      * @param needle The text to search for in `self`.
655      * @return The number of occurrences of `needle` found in `self`.
656      */
657     function count(slice self, slice needle) internal pure returns (uint cnt) {
658         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
659         while (ptr <= self._ptr + self._len) {
660             cnt++;
661             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
662         }
663     }
664 
665     /*
666      * @dev Returns True if `self` contains `needle`.
667      * @param self The slice to search.
668      * @param needle The text to search for in `self`.
669      * @return True if `needle` is found in `self`, false otherwise.
670      */
671     function contains(slice self, slice needle) internal pure returns (bool) {
672         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
673     }
674 
675     /*
676      * @dev Returns a newly allocated string containing the concatenation of
677      *      `self` and `other`.
678      * @param self The first slice to concatenate.
679      * @param other The second slice to concatenate.
680      * @return The concatenation of the two strings.
681      */
682     function concat(slice self, slice other) internal pure returns (string) {
683         string memory ret = new string(self._len + other._len);
684         uint retptr;
685         assembly { retptr := add(ret, 32) }
686         memcpy(retptr, self._ptr, self._len);
687         memcpy(retptr + self._len, other._ptr, other._len);
688         return ret;
689     }
690 
691     /*
692      * @dev Joins an array of slices, using `self` as a delimiter, returning a
693      *      newly allocated string.
694      * @param self The delimiter to use.
695      * @param parts A list of slices to join.
696      * @return A newly allocated string containing all the slices in `parts`,
697      *         joined with `self`.
698      */
699     function join(slice self, slice[] parts) internal pure returns (string) {
700         if (parts.length == 0)
701             return "";
702 
703         uint length = self._len * (parts.length - 1);
704         for(uint i = 0; i < parts.length; i++)
705             length += parts[i]._len;
706 
707         string memory ret = new string(length);
708         uint retptr;
709         assembly { retptr := add(ret, 32) }
710 
711         for(i = 0; i < parts.length; i++) {
712             memcpy(retptr, parts[i]._ptr, parts[i]._len);
713             retptr += parts[i]._len;
714             if (i < parts.length - 1) {
715                 memcpy(retptr, self._ptr, self._len);
716                 retptr += self._len;
717             }
718         }
719 
720         return ret;
721     }
722 }
723 
724 
725 // <ORACLIZE_API>
726 /*
727 Copyright (c) 2015-2016 Oraclize SRL
728 Copyright (c) 2016 Oraclize LTD
729 
730 
731 
732 Permission is hereby granted, free of charge, to any person obtaining a copy
733 of this software and associated documentation files (the "Software"), to deal
734 in the Software without restriction, including without limitation the rights
735 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
736 copies of the Software, and to permit persons to whom the Software is
737 furnished to do so, subject to the following conditions:
738 
739 
740 
741 The above copyright notice and this permission notice shall be included in
742 all copies or substantial portions of the Software.
743 
744 
745 
746 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
747 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
748 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
749 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
750 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
751 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
752 THE SOFTWARE.
753 */
754 
755 pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
756 
757 contract OraclizeI {
758     address public cbAddress;
759     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
760     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
761     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
762     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
763     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
764     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
765     function getPrice(string _datasource) returns (uint _dsprice);
766     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
767     function useCoupon(string _coupon);
768     function setProofType(byte _proofType);
769     function setConfig(bytes32 _config);
770     function setCustomGasPrice(uint _gasPrice);
771     function randomDS_getSessionPubKeyHash() returns(bytes32);
772 }
773 
774 contract OraclizeAddrResolverI {
775     function getAddress() returns (address _addr);
776 }
777 
778 /*
779 Begin solidity-cborutils
780 
781 https://github.com/smartcontractkit/solidity-cborutils
782 
783 MIT License
784 
785 Copyright (c) 2018 SmartContract ChainLink, Ltd.
786 
787 Permission is hereby granted, free of charge, to any person obtaining a copy
788 of this software and associated documentation files (the "Software"), to deal
789 in the Software without restriction, including without limitation the rights
790 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
791 copies of the Software, and to permit persons to whom the Software is
792 furnished to do so, subject to the following conditions:
793 
794 The above copyright notice and this permission notice shall be included in all
795 copies or substantial portions of the Software.
796 
797 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
798 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
799 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
800 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
801 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
802 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
803 SOFTWARE.
804  */
805 
806 library Buffer {
807     struct buffer {
808         bytes buf;
809         uint capacity;
810     }
811 
812     function init(buffer memory buf, uint capacity) internal constant {
813         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
814         // Allocate space for the buffer data
815         buf.capacity = capacity;
816         assembly {
817             let ptr := mload(0x40)
818             mstore(buf, ptr)
819             mstore(0x40, add(ptr, capacity))
820         }
821     }
822 
823     function resize(buffer memory buf, uint capacity) private constant {
824         bytes memory oldbuf = buf.buf;
825         init(buf, capacity);
826         append(buf, oldbuf);
827     }
828 
829     function max(uint a, uint b) private constant returns(uint) {
830         if(a > b) {
831             return a;
832         }
833         return b;
834     }
835 
836     /**
837      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
838      *      would exceed the capacity of the buffer.
839      * @param buf The buffer to append to.
840      * @param data The data to append.
841      * @return The original buffer.
842      */
843     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
844         if(data.length + buf.buf.length > buf.capacity) {
845             resize(buf, max(buf.capacity, data.length) * 2);
846         }
847 
848         uint dest;
849         uint src;
850         uint len = data.length;
851         assembly {
852             // Memory address of the buffer data
853             let bufptr := mload(buf)
854             // Length of existing buffer data
855             let buflen := mload(bufptr)
856             // Start address = buffer address + buffer length + sizeof(buffer length)
857             dest := add(add(bufptr, buflen), 32)
858             // Update buffer length
859             mstore(bufptr, add(buflen, mload(data)))
860             src := add(data, 32)
861         }
862 
863         // Copy word-length chunks while possible
864         for(; len >= 32; len -= 32) {
865             assembly {
866                 mstore(dest, mload(src))
867             }
868             dest += 32;
869             src += 32;
870         }
871 
872         // Copy remaining bytes
873         uint mask = 256 ** (32 - len) - 1;
874         assembly {
875             let srcpart := and(mload(src), not(mask))
876             let destpart := and(mload(dest), mask)
877             mstore(dest, or(destpart, srcpart))
878         }
879 
880         return buf;
881     }
882 
883     /**
884      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
885      * exceed the capacity of the buffer.
886      * @param buf The buffer to append to.
887      * @param data The data to append.
888      * @return The original buffer.
889      */
890     function append(buffer memory buf, uint8 data) internal constant {
891         if(buf.buf.length + 1 > buf.capacity) {
892             resize(buf, buf.capacity * 2);
893         }
894 
895         assembly {
896             // Memory address of the buffer data
897             let bufptr := mload(buf)
898             // Length of existing buffer data
899             let buflen := mload(bufptr)
900             // Address = buffer address + buffer length + sizeof(buffer length)
901             let dest := add(add(bufptr, buflen), 32)
902             mstore8(dest, data)
903             // Update buffer length
904             mstore(bufptr, add(buflen, 1))
905         }
906     }
907 
908     /**
909      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
910      * exceed the capacity of the buffer.
911      * @param buf The buffer to append to.
912      * @param data The data to append.
913      * @return The original buffer.
914      */
915     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
916         if(len + buf.buf.length > buf.capacity) {
917             resize(buf, max(buf.capacity, len) * 2);
918         }
919 
920         uint mask = 256 ** len - 1;
921         assembly {
922             // Memory address of the buffer data
923             let bufptr := mload(buf)
924             // Length of existing buffer data
925             let buflen := mload(bufptr)
926             // Address = buffer address + buffer length + sizeof(buffer length) + len
927             let dest := add(add(bufptr, buflen), len)
928             mstore(dest, or(and(mload(dest), not(mask)), data))
929             // Update buffer length
930             mstore(bufptr, add(buflen, len))
931         }
932         return buf;
933     }
934 }
935 
936 library CBOR {
937     using Buffer for Buffer.buffer;
938 
939     uint8 private constant MAJOR_TYPE_INT = 0;
940     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
941     uint8 private constant MAJOR_TYPE_BYTES = 2;
942     uint8 private constant MAJOR_TYPE_STRING = 3;
943     uint8 private constant MAJOR_TYPE_ARRAY = 4;
944     uint8 private constant MAJOR_TYPE_MAP = 5;
945     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
946 
947     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
948         return x * (2 ** y);
949     }
950 
951     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
952         if(value <= 23) {
953             buf.append(uint8(shl8(major, 5) | value));
954         } else if(value <= 0xFF) {
955             buf.append(uint8(shl8(major, 5) | 24));
956             buf.appendInt(value, 1);
957         } else if(value <= 0xFFFF) {
958             buf.append(uint8(shl8(major, 5) | 25));
959             buf.appendInt(value, 2);
960         } else if(value <= 0xFFFFFFFF) {
961             buf.append(uint8(shl8(major, 5) | 26));
962             buf.appendInt(value, 4);
963         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
964             buf.append(uint8(shl8(major, 5) | 27));
965             buf.appendInt(value, 8);
966         }
967     }
968 
969     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
970         buf.append(uint8(shl8(major, 5) | 31));
971     }
972 
973     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
974         encodeType(buf, MAJOR_TYPE_INT, value);
975     }
976 
977     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
978         if(value >= 0) {
979             encodeType(buf, MAJOR_TYPE_INT, uint(value));
980         } else {
981             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
982         }
983     }
984 
985     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
986         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
987         buf.append(value);
988     }
989 
990     function encodeString(Buffer.buffer memory buf, string value) internal constant {
991         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
992         buf.append(bytes(value));
993     }
994 
995     function startArray(Buffer.buffer memory buf) internal constant {
996         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
997     }
998 
999     function startMap(Buffer.buffer memory buf) internal constant {
1000         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1001     }
1002 
1003     function endSequence(Buffer.buffer memory buf) internal constant {
1004         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1005     }
1006 }
1007 
1008 /*
1009 End solidity-cborutils
1010  */
1011 
1012 contract usingOraclize {
1013     uint constant day = 60*60*24;
1014     uint constant week = 60*60*24*7;
1015     uint constant month = 60*60*24*30;
1016     byte constant proofType_NONE = 0x00;
1017     byte constant proofType_TLSNotary = 0x10;
1018     byte constant proofType_Android = 0x20;
1019     byte constant proofType_Ledger = 0x30;
1020     byte constant proofType_Native = 0xF0;
1021     byte constant proofStorage_IPFS = 0x01;
1022     uint8 constant networkID_auto = 0;
1023     uint8 constant networkID_mainnet = 1;
1024     uint8 constant networkID_testnet = 2;
1025     uint8 constant networkID_morden = 2;
1026     uint8 constant networkID_consensys = 161;
1027 
1028     OraclizeAddrResolverI OAR;
1029 
1030     OraclizeI oraclize;
1031     modifier oraclizeAPI {
1032         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1033             oraclize_setNetwork(networkID_auto);
1034 
1035         if(address(oraclize) != OAR.getAddress())
1036             oraclize = OraclizeI(OAR.getAddress());
1037 
1038         _;
1039     }
1040     modifier coupon(string code){
1041         oraclize = OraclizeI(OAR.getAddress());
1042         oraclize.useCoupon(code);
1043         _;
1044     }
1045 
1046     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1047         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1048             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1049             oraclize_setNetworkName("eth_mainnet");
1050             return true;
1051         }
1052         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1053             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1054             oraclize_setNetworkName("eth_ropsten3");
1055             return true;
1056         }
1057         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1058             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1059             oraclize_setNetworkName("eth_kovan");
1060             return true;
1061         }
1062         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1063             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1064             oraclize_setNetworkName("eth_rinkeby");
1065             return true;
1066         }
1067         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1068             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1069             return true;
1070         }
1071         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1072             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1073             return true;
1074         }
1075         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1076             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1077             return true;
1078         }
1079         return false;
1080     }
1081 
1082     function __callback(bytes32 myid, string result) {
1083         __callback(myid, result, new bytes(0));
1084     }
1085     function __callback(bytes32 myid, string result, bytes proof) {
1086     }
1087 
1088     function oraclize_useCoupon(string code) oraclizeAPI internal {
1089         oraclize.useCoupon(code);
1090     }
1091 
1092     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1093         return oraclize.getPrice(datasource);
1094     }
1095 
1096     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1097         return oraclize.getPrice(datasource, gaslimit);
1098     }
1099 
1100     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1101         uint price = oraclize.getPrice(datasource);
1102         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1103         return oraclize.query.value(price)(0, datasource, arg);
1104     }
1105     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1106         uint price = oraclize.getPrice(datasource);
1107         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1108         return oraclize.query.value(price)(timestamp, datasource, arg);
1109     }
1110     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1111         uint price = oraclize.getPrice(datasource, gaslimit);
1112         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1113         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1114     }
1115     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1116         uint price = oraclize.getPrice(datasource, gaslimit);
1117         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1118         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1119     }
1120     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1121         uint price = oraclize.getPrice(datasource);
1122         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1123         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1124     }
1125     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1126         uint price = oraclize.getPrice(datasource);
1127         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1128         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1129     }
1130     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1131         uint price = oraclize.getPrice(datasource, gaslimit);
1132         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1133         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1134     }
1135     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1136         uint price = oraclize.getPrice(datasource, gaslimit);
1137         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1138         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1139     }
1140     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1141         uint price = oraclize.getPrice(datasource);
1142         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1143         bytes memory args = stra2cbor(argN);
1144         return oraclize.queryN.value(price)(0, datasource, args);
1145     }
1146     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1147         uint price = oraclize.getPrice(datasource);
1148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1149         bytes memory args = stra2cbor(argN);
1150         return oraclize.queryN.value(price)(timestamp, datasource, args);
1151     }
1152     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1153         uint price = oraclize.getPrice(datasource, gaslimit);
1154         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1155         bytes memory args = stra2cbor(argN);
1156         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1157     }
1158     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1159         uint price = oraclize.getPrice(datasource, gaslimit);
1160         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1161         bytes memory args = stra2cbor(argN);
1162         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1163     }
1164     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1165         string[] memory dynargs = new string[](1);
1166         dynargs[0] = args[0];
1167         return oraclize_query(datasource, dynargs);
1168     }
1169     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1170         string[] memory dynargs = new string[](1);
1171         dynargs[0] = args[0];
1172         return oraclize_query(timestamp, datasource, dynargs);
1173     }
1174     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1175         string[] memory dynargs = new string[](1);
1176         dynargs[0] = args[0];
1177         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1178     }
1179     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1180         string[] memory dynargs = new string[](1);
1181         dynargs[0] = args[0];
1182         return oraclize_query(datasource, dynargs, gaslimit);
1183     }
1184 
1185     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1186         string[] memory dynargs = new string[](2);
1187         dynargs[0] = args[0];
1188         dynargs[1] = args[1];
1189         return oraclize_query(datasource, dynargs);
1190     }
1191     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1192         string[] memory dynargs = new string[](2);
1193         dynargs[0] = args[0];
1194         dynargs[1] = args[1];
1195         return oraclize_query(timestamp, datasource, dynargs);
1196     }
1197     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1198         string[] memory dynargs = new string[](2);
1199         dynargs[0] = args[0];
1200         dynargs[1] = args[1];
1201         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1202     }
1203     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1204         string[] memory dynargs = new string[](2);
1205         dynargs[0] = args[0];
1206         dynargs[1] = args[1];
1207         return oraclize_query(datasource, dynargs, gaslimit);
1208     }
1209     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1210         string[] memory dynargs = new string[](3);
1211         dynargs[0] = args[0];
1212         dynargs[1] = args[1];
1213         dynargs[2] = args[2];
1214         return oraclize_query(datasource, dynargs);
1215     }
1216     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1217         string[] memory dynargs = new string[](3);
1218         dynargs[0] = args[0];
1219         dynargs[1] = args[1];
1220         dynargs[2] = args[2];
1221         return oraclize_query(timestamp, datasource, dynargs);
1222     }
1223     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1224         string[] memory dynargs = new string[](3);
1225         dynargs[0] = args[0];
1226         dynargs[1] = args[1];
1227         dynargs[2] = args[2];
1228         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1229     }
1230     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1231         string[] memory dynargs = new string[](3);
1232         dynargs[0] = args[0];
1233         dynargs[1] = args[1];
1234         dynargs[2] = args[2];
1235         return oraclize_query(datasource, dynargs, gaslimit);
1236     }
1237 
1238     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1239         string[] memory dynargs = new string[](4);
1240         dynargs[0] = args[0];
1241         dynargs[1] = args[1];
1242         dynargs[2] = args[2];
1243         dynargs[3] = args[3];
1244         return oraclize_query(datasource, dynargs);
1245     }
1246     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1247         string[] memory dynargs = new string[](4);
1248         dynargs[0] = args[0];
1249         dynargs[1] = args[1];
1250         dynargs[2] = args[2];
1251         dynargs[3] = args[3];
1252         return oraclize_query(timestamp, datasource, dynargs);
1253     }
1254     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1255         string[] memory dynargs = new string[](4);
1256         dynargs[0] = args[0];
1257         dynargs[1] = args[1];
1258         dynargs[2] = args[2];
1259         dynargs[3] = args[3];
1260         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1261     }
1262     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1263         string[] memory dynargs = new string[](4);
1264         dynargs[0] = args[0];
1265         dynargs[1] = args[1];
1266         dynargs[2] = args[2];
1267         dynargs[3] = args[3];
1268         return oraclize_query(datasource, dynargs, gaslimit);
1269     }
1270     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1271         string[] memory dynargs = new string[](5);
1272         dynargs[0] = args[0];
1273         dynargs[1] = args[1];
1274         dynargs[2] = args[2];
1275         dynargs[3] = args[3];
1276         dynargs[4] = args[4];
1277         return oraclize_query(datasource, dynargs);
1278     }
1279     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1280         string[] memory dynargs = new string[](5);
1281         dynargs[0] = args[0];
1282         dynargs[1] = args[1];
1283         dynargs[2] = args[2];
1284         dynargs[3] = args[3];
1285         dynargs[4] = args[4];
1286         return oraclize_query(timestamp, datasource, dynargs);
1287     }
1288     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1289         string[] memory dynargs = new string[](5);
1290         dynargs[0] = args[0];
1291         dynargs[1] = args[1];
1292         dynargs[2] = args[2];
1293         dynargs[3] = args[3];
1294         dynargs[4] = args[4];
1295         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1296     }
1297     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1298         string[] memory dynargs = new string[](5);
1299         dynargs[0] = args[0];
1300         dynargs[1] = args[1];
1301         dynargs[2] = args[2];
1302         dynargs[3] = args[3];
1303         dynargs[4] = args[4];
1304         return oraclize_query(datasource, dynargs, gaslimit);
1305     }
1306     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1307         uint price = oraclize.getPrice(datasource);
1308         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1309         bytes memory args = ba2cbor(argN);
1310         return oraclize.queryN.value(price)(0, datasource, args);
1311     }
1312     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1313         uint price = oraclize.getPrice(datasource);
1314         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1315         bytes memory args = ba2cbor(argN);
1316         return oraclize.queryN.value(price)(timestamp, datasource, args);
1317     }
1318     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1319         uint price = oraclize.getPrice(datasource, gaslimit);
1320         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1321         bytes memory args = ba2cbor(argN);
1322         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1323     }
1324     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1325         uint price = oraclize.getPrice(datasource, gaslimit);
1326         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1327         bytes memory args = ba2cbor(argN);
1328         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1329     }
1330     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1331         bytes[] memory dynargs = new bytes[](1);
1332         dynargs[0] = args[0];
1333         return oraclize_query(datasource, dynargs);
1334     }
1335     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1336         bytes[] memory dynargs = new bytes[](1);
1337         dynargs[0] = args[0];
1338         return oraclize_query(timestamp, datasource, dynargs);
1339     }
1340     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1341         bytes[] memory dynargs = new bytes[](1);
1342         dynargs[0] = args[0];
1343         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1344     }
1345     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1346         bytes[] memory dynargs = new bytes[](1);
1347         dynargs[0] = args[0];
1348         return oraclize_query(datasource, dynargs, gaslimit);
1349     }
1350 
1351     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1352         bytes[] memory dynargs = new bytes[](2);
1353         dynargs[0] = args[0];
1354         dynargs[1] = args[1];
1355         return oraclize_query(datasource, dynargs);
1356     }
1357     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1358         bytes[] memory dynargs = new bytes[](2);
1359         dynargs[0] = args[0];
1360         dynargs[1] = args[1];
1361         return oraclize_query(timestamp, datasource, dynargs);
1362     }
1363     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1364         bytes[] memory dynargs = new bytes[](2);
1365         dynargs[0] = args[0];
1366         dynargs[1] = args[1];
1367         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1368     }
1369     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1370         bytes[] memory dynargs = new bytes[](2);
1371         dynargs[0] = args[0];
1372         dynargs[1] = args[1];
1373         return oraclize_query(datasource, dynargs, gaslimit);
1374     }
1375     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1376         bytes[] memory dynargs = new bytes[](3);
1377         dynargs[0] = args[0];
1378         dynargs[1] = args[1];
1379         dynargs[2] = args[2];
1380         return oraclize_query(datasource, dynargs);
1381     }
1382     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1383         bytes[] memory dynargs = new bytes[](3);
1384         dynargs[0] = args[0];
1385         dynargs[1] = args[1];
1386         dynargs[2] = args[2];
1387         return oraclize_query(timestamp, datasource, dynargs);
1388     }
1389     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1390         bytes[] memory dynargs = new bytes[](3);
1391         dynargs[0] = args[0];
1392         dynargs[1] = args[1];
1393         dynargs[2] = args[2];
1394         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1395     }
1396     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1397         bytes[] memory dynargs = new bytes[](3);
1398         dynargs[0] = args[0];
1399         dynargs[1] = args[1];
1400         dynargs[2] = args[2];
1401         return oraclize_query(datasource, dynargs, gaslimit);
1402     }
1403 
1404     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1405         bytes[] memory dynargs = new bytes[](4);
1406         dynargs[0] = args[0];
1407         dynargs[1] = args[1];
1408         dynargs[2] = args[2];
1409         dynargs[3] = args[3];
1410         return oraclize_query(datasource, dynargs);
1411     }
1412     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1413         bytes[] memory dynargs = new bytes[](4);
1414         dynargs[0] = args[0];
1415         dynargs[1] = args[1];
1416         dynargs[2] = args[2];
1417         dynargs[3] = args[3];
1418         return oraclize_query(timestamp, datasource, dynargs);
1419     }
1420     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1421         bytes[] memory dynargs = new bytes[](4);
1422         dynargs[0] = args[0];
1423         dynargs[1] = args[1];
1424         dynargs[2] = args[2];
1425         dynargs[3] = args[3];
1426         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1427     }
1428     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1429         bytes[] memory dynargs = new bytes[](4);
1430         dynargs[0] = args[0];
1431         dynargs[1] = args[1];
1432         dynargs[2] = args[2];
1433         dynargs[3] = args[3];
1434         return oraclize_query(datasource, dynargs, gaslimit);
1435     }
1436     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1437         bytes[] memory dynargs = new bytes[](5);
1438         dynargs[0] = args[0];
1439         dynargs[1] = args[1];
1440         dynargs[2] = args[2];
1441         dynargs[3] = args[3];
1442         dynargs[4] = args[4];
1443         return oraclize_query(datasource, dynargs);
1444     }
1445     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1446         bytes[] memory dynargs = new bytes[](5);
1447         dynargs[0] = args[0];
1448         dynargs[1] = args[1];
1449         dynargs[2] = args[2];
1450         dynargs[3] = args[3];
1451         dynargs[4] = args[4];
1452         return oraclize_query(timestamp, datasource, dynargs);
1453     }
1454     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1455         bytes[] memory dynargs = new bytes[](5);
1456         dynargs[0] = args[0];
1457         dynargs[1] = args[1];
1458         dynargs[2] = args[2];
1459         dynargs[3] = args[3];
1460         dynargs[4] = args[4];
1461         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1462     }
1463     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1464         bytes[] memory dynargs = new bytes[](5);
1465         dynargs[0] = args[0];
1466         dynargs[1] = args[1];
1467         dynargs[2] = args[2];
1468         dynargs[3] = args[3];
1469         dynargs[4] = args[4];
1470         return oraclize_query(datasource, dynargs, gaslimit);
1471     }
1472 
1473     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1474         return oraclize.cbAddress();
1475     }
1476     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1477         return oraclize.setProofType(proofP);
1478     }
1479     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1480         return oraclize.setCustomGasPrice(gasPrice);
1481     }
1482     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1483         return oraclize.setConfig(config);
1484     }
1485 
1486     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1487         return oraclize.randomDS_getSessionPubKeyHash();
1488     }
1489 
1490     function getCodeSize(address _addr) constant internal returns(uint _size) {
1491         assembly {
1492             _size := extcodesize(_addr)
1493         }
1494     }
1495 
1496     function parseAddr(string _a) internal returns (address){
1497         bytes memory tmp = bytes(_a);
1498         uint160 iaddr = 0;
1499         uint160 b1;
1500         uint160 b2;
1501         for (uint i=2; i<2+2*20; i+=2){
1502             iaddr *= 256;
1503             b1 = uint160(tmp[i]);
1504             b2 = uint160(tmp[i+1]);
1505             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1506             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1507             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1508             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1509             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1510             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1511             iaddr += (b1*16+b2);
1512         }
1513         return address(iaddr);
1514     }
1515 
1516     function strCompare(string _a, string _b) internal returns (int) {
1517         bytes memory a = bytes(_a);
1518         bytes memory b = bytes(_b);
1519         uint minLength = a.length;
1520         if (b.length < minLength) minLength = b.length;
1521         for (uint i = 0; i < minLength; i ++)
1522             if (a[i] < b[i])
1523                 return -1;
1524             else if (a[i] > b[i])
1525                 return 1;
1526         if (a.length < b.length)
1527             return -1;
1528         else if (a.length > b.length)
1529             return 1;
1530         else
1531             return 0;
1532     }
1533 
1534     function indexOf(string _haystack, string _needle) internal returns (int) {
1535         bytes memory h = bytes(_haystack);
1536         bytes memory n = bytes(_needle);
1537         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1538             return -1;
1539         else if(h.length > (2**128 -1))
1540             return -1;
1541         else
1542         {
1543             uint subindex = 0;
1544             for (uint i = 0; i < h.length; i ++)
1545             {
1546                 if (h[i] == n[0])
1547                 {
1548                     subindex = 1;
1549                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1550                     {
1551                         subindex++;
1552                     }
1553                     if(subindex == n.length)
1554                         return int(i);
1555                 }
1556             }
1557             return -1;
1558         }
1559     }
1560 
1561     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1562         bytes memory _ba = bytes(_a);
1563         bytes memory _bb = bytes(_b);
1564         bytes memory _bc = bytes(_c);
1565         bytes memory _bd = bytes(_d);
1566         bytes memory _be = bytes(_e);
1567         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1568         bytes memory babcde = bytes(abcde);
1569         uint k = 0;
1570         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1571         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1572         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1573         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1574         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1575         return string(babcde);
1576     }
1577 
1578     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1579         return strConcat(_a, _b, _c, _d, "");
1580     }
1581 
1582     function strConcat(string _a, string _b, string _c) internal returns (string) {
1583         return strConcat(_a, _b, _c, "", "");
1584     }
1585 
1586     function strConcat(string _a, string _b) internal returns (string) {
1587         return strConcat(_a, _b, "", "", "");
1588     }
1589 
1590     // parseInt
1591     function parseInt(string _a) internal returns (uint) {
1592         return parseInt(_a, 0);
1593     }
1594 
1595     // parseInt(parseFloat*10^_b)
1596     function parseInt(string _a, uint _b) internal returns (uint) {
1597         bytes memory bresult = bytes(_a);
1598         uint mint = 0;
1599         bool decimals = false;
1600         for (uint i=0; i<bresult.length; i++){
1601             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1602                 if (decimals){
1603                    if (_b == 0) break;
1604                     else _b--;
1605                 }
1606                 mint *= 10;
1607                 mint += uint(bresult[i]) - 48;
1608             } else if (bresult[i] == 46) decimals = true;
1609         }
1610         if (_b > 0) mint *= 10**_b;
1611         return mint;
1612     }
1613 
1614     function uint2str(uint i) internal returns (string){
1615         if (i == 0) return "0";
1616         uint j = i;
1617         uint len;
1618         while (j != 0){
1619             len++;
1620             j /= 10;
1621         }
1622         bytes memory bstr = new bytes(len);
1623         uint k = len - 1;
1624         while (i != 0){
1625             bstr[k--] = byte(48 + i % 10);
1626             i /= 10;
1627         }
1628         return string(bstr);
1629     }
1630 
1631     using CBOR for Buffer.buffer;
1632     function stra2cbor(string[] arr) internal constant returns (bytes) {
1633         Buffer.buffer memory buf;
1634         Buffer.init(buf, 1024);
1635         buf.startArray();
1636         for (uint i = 0; i < arr.length; i++) {
1637             buf.encodeString(arr[i]);
1638         }
1639         buf.endSequence();
1640         return buf.buf;
1641     }
1642 
1643     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1644         Buffer.buffer memory buf;
1645         Buffer.init(buf, 1024);
1646         buf.startArray();
1647         for (uint i = 0; i < arr.length; i++) {
1648             buf.encodeBytes(arr[i]);
1649         }
1650         buf.endSequence();
1651         return buf.buf;
1652     }
1653 
1654     string oraclize_network_name;
1655     function oraclize_setNetworkName(string _network_name) internal {
1656         oraclize_network_name = _network_name;
1657     }
1658 
1659     function oraclize_getNetworkName() internal returns (string) {
1660         return oraclize_network_name;
1661     }
1662 
1663     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1664         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1665 	// Convert from seconds to ledger timer ticks
1666         _delay *= 10;
1667         bytes memory nbytes = new bytes(1);
1668         nbytes[0] = byte(_nbytes);
1669         bytes memory unonce = new bytes(32);
1670         bytes memory sessionKeyHash = new bytes(32);
1671         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1672         assembly {
1673             mstore(unonce, 0x20)
1674             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1675             mstore(sessionKeyHash, 0x20)
1676             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1677         }
1678         bytes memory delay = new bytes(32);
1679         assembly {
1680             mstore(add(delay, 0x20), _delay)
1681         }
1682 
1683         bytes memory delay_bytes8 = new bytes(8);
1684         copyBytes(delay, 24, 8, delay_bytes8, 0);
1685 
1686         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1687         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1688 
1689         bytes memory delay_bytes8_left = new bytes(8);
1690 
1691         assembly {
1692             let x := mload(add(delay_bytes8, 0x20))
1693             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1694             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1695             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1696             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1697             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1698             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1699             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1700             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1701 
1702         }
1703 
1704         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1705         return queryId;
1706     }
1707 
1708     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1709         oraclize_randomDS_args[queryId] = commitment;
1710     }
1711 
1712     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1713     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1714 
1715     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1716         bool sigok;
1717         address signer;
1718 
1719         bytes32 sigr;
1720         bytes32 sigs;
1721 
1722         bytes memory sigr_ = new bytes(32);
1723         uint offset = 4+(uint(dersig[3]) - 0x20);
1724         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1725         bytes memory sigs_ = new bytes(32);
1726         offset += 32 + 2;
1727         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1728 
1729         assembly {
1730             sigr := mload(add(sigr_, 32))
1731             sigs := mload(add(sigs_, 32))
1732         }
1733 
1734 
1735         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1736         if (address(sha3(pubkey)) == signer) return true;
1737         else {
1738             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1739             return (address(sha3(pubkey)) == signer);
1740         }
1741     }
1742 
1743     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1744         bool sigok;
1745 
1746         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1747         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1748         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1749 
1750         bytes memory appkey1_pubkey = new bytes(64);
1751         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1752 
1753         bytes memory tosign2 = new bytes(1+65+32);
1754         tosign2[0] = 1; //role
1755         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1756         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1757         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1758         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1759 
1760         if (sigok == false) return false;
1761 
1762 
1763         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1764         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1765 
1766         bytes memory tosign3 = new bytes(1+65);
1767         tosign3[0] = 0xFE;
1768         copyBytes(proof, 3, 65, tosign3, 1);
1769 
1770         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1771         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1772 
1773         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1774 
1775         return sigok;
1776     }
1777 
1778     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1779         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1780         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1781 
1782         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1783         if (proofVerified == false) throw;
1784 
1785         _;
1786     }
1787 
1788     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1789         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1790         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1791 
1792         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1793         if (proofVerified == false) return 2;
1794 
1795         return 0;
1796     }
1797 
1798     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1799         bool match_ = true;
1800 
1801 	if (prefix.length != n_random_bytes) throw;
1802 
1803         for (uint256 i=0; i< n_random_bytes; i++) {
1804             if (content[i] != prefix[i]) match_ = false;
1805         }
1806 
1807         return match_;
1808     }
1809 
1810     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1811 
1812         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1813         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1814         bytes memory keyhash = new bytes(32);
1815         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1816         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1817 
1818         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1819         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1820 
1821         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1822         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1823 
1824         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1825         // This is to verify that the computed args match with the ones specified in the query.
1826         bytes memory commitmentSlice1 = new bytes(8+1+32);
1827         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1828 
1829         bytes memory sessionPubkey = new bytes(64);
1830         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1831         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1832 
1833         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1834         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1835             delete oraclize_randomDS_args[queryId];
1836         } else return false;
1837 
1838 
1839         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1840         bytes memory tosign1 = new bytes(32+8+1+32);
1841         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1842         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1843 
1844         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1845         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1846             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1847         }
1848 
1849         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1850     }
1851 
1852 
1853     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1854     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1855         uint minLength = length + toOffset;
1856 
1857         if (to.length < minLength) {
1858             // Buffer too small
1859             throw; // Should be a better way?
1860         }
1861 
1862         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1863         uint i = 32 + fromOffset;
1864         uint j = 32 + toOffset;
1865 
1866         while (i < (32 + fromOffset + length)) {
1867             assembly {
1868                 let tmp := mload(add(from, i))
1869                 mstore(add(to, j), tmp)
1870             }
1871             i += 32;
1872             j += 32;
1873         }
1874 
1875         return to;
1876     }
1877 
1878     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1879     // Duplicate Solidity's ecrecover, but catching the CALL return value
1880     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1881         // We do our own memory management here. Solidity uses memory offset
1882         // 0x40 to store the current end of memory. We write past it (as
1883         // writes are memory extensions), but don't update the offset so
1884         // Solidity will reuse it. The memory used here is only needed for
1885         // this context.
1886 
1887         // FIXME: inline assembly can't access return values
1888         bool ret;
1889         address addr;
1890 
1891         assembly {
1892             let size := mload(0x40)
1893             mstore(size, hash)
1894             mstore(add(size, 32), v)
1895             mstore(add(size, 64), r)
1896             mstore(add(size, 96), s)
1897 
1898             // NOTE: we can reuse the request memory because we deal with
1899             //       the return code
1900             ret := call(3000, 1, 0, size, 128, size, 32)
1901             addr := mload(size)
1902         }
1903 
1904         return (ret, addr);
1905     }
1906 
1907     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1908     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1909         bytes32 r;
1910         bytes32 s;
1911         uint8 v;
1912 
1913         if (sig.length != 65)
1914           return (false, 0);
1915 
1916         // The signature format is a compact form of:
1917         //   {bytes32 r}{bytes32 s}{uint8 v}
1918         // Compact means, uint8 is not padded to 32 bytes.
1919         assembly {
1920             r := mload(add(sig, 32))
1921             s := mload(add(sig, 64))
1922 
1923             // Here we are loading the last 32 bytes. We exploit the fact that
1924             // 'mload' will pad with zeroes if we overread.
1925             // There is no 'mload8' to do this, but that would be nicer.
1926             v := byte(0, mload(add(sig, 96)))
1927 
1928             // Alternative solution:
1929             // 'byte' is not working due to the Solidity parser, so lets
1930             // use the second best option, 'and'
1931             // v := and(mload(add(sig, 65)), 255)
1932         }
1933 
1934         // albeit non-transactional signatures are not specified by the YP, one would expect it
1935         // to match the YP range of [27, 28]
1936         //
1937         // geth uses [0, 1] and some clients have followed. This might change, see:
1938         //  https://github.com/ethereum/go-ethereum/issues/2053
1939         if (v < 27)
1940           v += 27;
1941 
1942         if (v != 27 && v != 28)
1943             return (false, 0);
1944 
1945         return safer_ecrecover(hash, v, r, s);
1946     }
1947 
1948 }
1949 // </ORACLIZE_API>
1950 
1951 library SafeMath {
1952 
1953   /**
1954   * @dev Multiplies two numbers, throws on overflow.
1955   */
1956   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1957     if (a == 0) {
1958       return 0;
1959     }
1960     uint256 c = a * b;
1961     assert(c / a == b);
1962     return c;
1963   }
1964 
1965   /**
1966   * @dev Integer division of two numbers, truncating the quotient.
1967   */
1968   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1969     // assert(b > 0); // Solidity automatically throws when dividing by 0
1970     uint256 c = a / b;
1971     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1972     return c;
1973   }
1974 
1975   /**
1976   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1977   */
1978   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1979     assert(b <= a);
1980     return a - b;
1981   }
1982 
1983   /**
1984   * @dev Adds two numbers, throws on overflow.
1985   */
1986   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1987     uint256 c = a + b;
1988     assert(c >= a);
1989     return c;
1990   }
1991 }
1992 
1993 
1994 contract Ownable {
1995   address public owner;
1996 
1997   function Ownable() public {
1998     owner = msg.sender;
1999   }
2000 
2001   modifier onlyOwner() {
2002     require(msg.sender == owner);
2003     _;
2004   }
2005 
2006   function transferOwnership(address newOwner) public onlyOwner {
2007     if (newOwner != address(0)) {
2008       owner = newOwner;
2009     }
2010   }
2011 
2012 }
2013 
2014 //***********Pausible
2015 
2016 
2017 contract Pausable is Ownable {
2018   event Pause();
2019   event Unpause();
2020 
2021   bool public paused = false;
2022 
2023   /**
2024    * @dev modifier to allow actions only when the contract IS paused
2025    */
2026   modifier whenNotPaused() {
2027     require(!paused);
2028     _;
2029   }
2030 
2031   /**
2032    * @dev modifier to allow actions only when the contract IS NOT paused
2033    */
2034   modifier whenPaused {
2035     require(paused);
2036     _;
2037   }
2038 
2039   /**
2040    * @dev called by the owner to pause, triggers stopped state
2041    */
2042   function pause() public onlyOwner whenNotPaused returns (bool) {
2043     paused = true;
2044     Pause();
2045     return true;
2046   }
2047 
2048   /**
2049    * @dev called by the owner to unpause, returns to normal state
2050    */
2051   function unpause() public onlyOwner whenPaused returns (bool) {
2052     paused = false;
2053     Unpause();
2054     return true;
2055   }
2056 }
2057 
2058 
2059 contract Crowdsaleable is Pausable {
2060   event PauseCrowdsale();
2061   event UnpauseCrowdsale();
2062 
2063   bool public crowdsalePaused = true;
2064 
2065   /**
2066    * @dev modifier to allow actions only when the contract IS paused
2067    */
2068   modifier whenCrowdsaleNotPaused() {
2069     require(!crowdsalePaused);
2070     _;
2071   }
2072 
2073   /**
2074    * @dev modifier to allow actions only when the contract IS NOT paused
2075    */
2076   modifier whenCrowdsalePaused {
2077     require(crowdsalePaused);
2078     _;
2079   }
2080 
2081   /**
2082    * @dev called by the owner to pause, triggers stopped state
2083    */
2084   function pauseCrowdsale() public onlyOwner whenCrowdsaleNotPaused returns (bool) {
2085     crowdsalePaused = true;
2086     PauseCrowdsale();
2087     return true;
2088   }
2089 
2090   /**
2091    * @dev called by the owner to unpause, returns to normal state
2092    */
2093   function unpauseCrowdsale() public onlyOwner whenCrowdsalePaused returns (bool) {
2094     crowdsalePaused = false;
2095     UnpauseCrowdsale();
2096     return true;
2097   }
2098 }
2099 
2100 contract Nihilum is Crowdsaleable, usingOraclize {
2101 
2102     using strings for *;
2103 
2104 
2105 
2106 
2107     //Oraclize
2108     mapping(bytes32=>address) validId;
2109     event LogConstructorInitiated(string nextStep);
2110     event LogWhitelistUpdated(string whitelistValue);
2111     event LogNewOraclizeQuery(string description);
2112 
2113 
2114     string public name;
2115     string public symbol;
2116     uint8 public decimals;
2117 
2118     // address where funds are collected
2119     address public wallet;
2120     
2121     
2122     uint256 public _tokenPrice;
2123     uint256 public _minimumTokens;
2124     bool public _allowManualTokensGeneration;
2125     uint256 public totalSupply;
2126     uint public totalShareholders;
2127 
2128     uint256 private lastUnpaidIteration;
2129 
2130     mapping (address => bool) registeredShareholders;
2131     mapping (uint => address) shareholders;
2132     /* This creates an array with all balances */
2133     mapping (address => uint256) public balanceOf;
2134 
2135     mapping (address => bool) public whitelistedAddresses;
2136 
2137 
2138     uint256 public totalNihilum;
2139     struct Account {
2140         uint256 balance;
2141         uint256 lastNihilum;
2142         bool isClaiming;
2143         bool whitelisted;
2144         bool blacklisted;
2145     }
2146     mapping (address => Account) accounts;
2147 
2148 
2149     event Transfer(address indexed from, address indexed to, uint256 value);
2150 
2151     function Nihilum() public {
2152         balanceOf[msg.sender] = 0;
2153         name = "Nihilum";
2154         symbol = "NH";
2155         decimals = 0;
2156         _tokenPrice = 0.0024 ether;
2157         _minimumTokens = 50;
2158         _allowManualTokensGeneration = true;
2159         wallet = owner;
2160         owner = msg.sender;
2161         totalShareholders = 0;
2162         lastUnpaidIteration = 1;
2163     }
2164 
2165     using SafeMath for uint256;
2166     
2167     /* Send coins */
2168     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
2169         if (balanceOf[msg.sender] < _value) return false;              // Check if the sender has enough
2170         if (balanceOf[_to] + _value < balanceOf[_to]) return false;    // Check for overflows
2171         if (_to == owner || _to == address(this)) return false;         // makes it illegal to send tokens to owner or this contract
2172         _transfer(msg.sender, _to, _value);
2173         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                        // Subtract from the sender
2174         balanceOf[_to] = balanceOf[_to].add(_value);                               // Add the same to the recipient
2175 
2176         /* Adding to shareholders count if tokens spent from owner to others */
2177         if (msg.sender == owner && _to != owner) {
2178             totalSupply += _value;
2179         }
2180         /* Remove from shareholders count if tokens spent from holder to owner */
2181         if (msg.sender != owner && _to == owner) {
2182             totalSupply = totalSupply.sub(_value);
2183         }
2184 
2185         if (owner == _to) {
2186             // sender is owner
2187         } else {
2188             insertShareholder(_to);
2189         }
2190 
2191         /* Notify anyone listening that this transfer took place */
2192         Transfer(msg.sender, _to, _value);
2193 
2194         return true;
2195     }
2196 
2197 
2198     function _transfer(address _from, address _to, uint256 _value) internal {
2199         require(!accounts[_from].blacklisted);
2200         require(!accounts[_to].blacklisted);
2201         require(_to != address(0));
2202         require(_value <= accounts[_from].balance);
2203         require(accounts[_to].balance + _value > accounts[_to].balance);
2204  
2205         var fromOwing = nihilumBalanceOf(_from);
2206         var toOwing = nihilumBalanceOf(_to);
2207         require(fromOwing <= 0 && toOwing <= 0);
2208  
2209         accounts[_from].balance = accounts[_from].balance.sub(_value);
2210         
2211         accounts[_to].balance = accounts[_to].balance.add(_value);
2212  
2213         accounts[_to].lastNihilum = totalNihilum;//accounts[_from].lastNihilum;
2214  
2215         //Transfer(_from, _to, _value);
2216     }
2217 
2218 
2219     function __callback(bytes32 myid, string result) {
2220         if (msg.sender != oraclize_cbAddress()) revert();
2221         if (keccak256(result) == keccak256("true")) {
2222             accounts[validId[myid]].whitelisted = true;
2223             whitelistedAddresses[validId[myid]] = true;
2224         }
2225         LogWhitelistUpdated(result);
2226     }
2227     
2228 
2229     function whitelist(string userAddress) payable {
2230         if (oraclize_getPrice("URL") > this.balance) {
2231             LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
2232         } else {
2233             LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
2234             validId[oraclize_query(60, "URL", "json(https://nihilum.wisemonks.com/wallet_check.json?wallet=".toSlice().concat(userAddress.toSlice()).toSlice().concat(").white_listed".toSlice())   )] = msg.sender;
2235     }
2236     }
2237 
2238 
2239 
2240 
2241     function addSomeTokens(uint256 numTokens) public onlyOwner {
2242         if (_allowManualTokensGeneration) {
2243             balanceOf[msg.sender] += numTokens;
2244             accounts[msg.sender].balance = accounts[msg.sender].balance.add(numTokens);
2245             Transfer(0, msg.sender, numTokens);
2246         } else {
2247             revert();
2248         }
2249     }
2250 
2251     function blacklist(address person) public onlyOwner {
2252         require(person != owner);
2253         balanceOf[person] = 0;
2254         accounts[person].balance = 0;
2255         accounts[person].lastNihilum = totalNihilum;
2256         accounts[person].blacklisted = true;
2257     }
2258 
2259     function () external payable {
2260       if (!crowdsalePaused) {
2261           buyTokens();
2262           } else {
2263               PayNihilumToContract();
2264               }
2265     }
2266 
2267     /* Buy Token 1 token for x ether */
2268     function buyTokens() public whenCrowdsaleNotPaused payable {
2269         require(accounts[msg.sender].whitelisted);
2270         require(!accounts[msg.sender].blacklisted);
2271         require(msg.value > 0);
2272         require(msg.value >= _tokenPrice);
2273         require(msg.value % _tokenPrice == 0);
2274         var numTokens = msg.value / _tokenPrice;
2275         require(numTokens >= _minimumTokens);
2276         balanceOf[msg.sender] += numTokens;
2277         Transfer(0, msg.sender, numTokens);
2278         wallet.transfer(msg.value);
2279         accounts[msg.sender].balance = accounts[msg.sender].balance.add(numTokens);
2280         insertShareholder(msg.sender);
2281         if (msg.sender != owner) {
2282             totalSupply += numTokens;
2283         }
2284     }
2285 
2286     function payNihilum() public onlyOwner {
2287         if (this.balance > 0 && totalShareholders > 0) {
2288             for (uint i = lastUnpaidIteration; i <= totalShareholders; i++) {
2289                 uint256 currentBalance = balanceOf[shareholders[i]];
2290                 lastUnpaidIteration = i;
2291                 if (currentBalance > 0 && nihilumBalanceOf(shareholders[i]) > 0 && !accounts[shareholders[i]].isClaiming && msg.gas > 2000) {
2292                     accounts[shareholders[i]].isClaiming = true;
2293                     shareholders[i].transfer(nihilumBalanceOf(shareholders[i]));
2294                     accounts[shareholders[i]].lastNihilum = totalNihilum;
2295                     accounts[shareholders[i]].isClaiming = false;
2296                 }
2297             }
2298             lastUnpaidIteration = 1;
2299         }
2300     }
2301 
2302     function nihilumBalanceOf(address account) public constant returns (uint256) {
2303         var newNihilum = totalNihilum.sub(accounts[account].lastNihilum);
2304         var product = accounts[account].balance.mul(newNihilum);
2305         if (totalSupply <= 0) return 0;
2306         if (account == owner) return 0;
2307         return product.div(totalSupply);
2308     }
2309 
2310     function claimNihilum() public {
2311         require(!accounts[msg.sender].blacklisted);
2312         var owing = nihilumBalanceOf(msg.sender);
2313         if (owing > 0 && !accounts[msg.sender].isClaiming) {
2314             accounts[msg.sender].isClaiming = true;
2315             accounts[msg.sender].lastNihilum = totalNihilum;
2316             msg.sender.transfer(owing);
2317             accounts[msg.sender].isClaiming = false;
2318         }
2319     }
2320 
2321     function PayNihilumToContract() public onlyOwner payable {
2322         totalNihilum = totalNihilum.add(msg.value);
2323     }
2324 
2325         function PayToContract() public onlyOwner payable {
2326         
2327     }
2328 
2329     function ChangeTokenPrice(uint256 newPrice) public onlyOwner {
2330         _tokenPrice = newPrice;
2331     }
2332 
2333     function insertShareholder(address _shareholder) internal returns (bool) {
2334         if (registeredShareholders[_shareholder] == true) {
2335 
2336         } else {
2337             totalShareholders += 1;
2338             shareholders[totalShareholders] = _shareholder;
2339             registeredShareholders[_shareholder] = true;
2340             return true;
2341         }
2342         return false;
2343     }
2344 }