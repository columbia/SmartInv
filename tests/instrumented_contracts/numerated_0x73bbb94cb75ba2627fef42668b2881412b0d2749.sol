1 pragma solidity ^0.4.15;
2 
3 // File: contracts\strings.sol
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
220                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
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
724 // File: contracts\MyWill.sol
725 
726 /* https://github.com/Arachnid/solidity-stringutils */
727 
728 
729 contract MyWill {
730 
731     using strings for *;
732 
733     /* The club address */
734     address club;
735 
736     /* The contract owner */
737     address owner;
738 
739     /* The list of witnesses */
740     string listWitnesses;
741 
742     /* The heirs with its respective percentages */
743     string listHeirs;
744     string listHeirsPercentages;
745 
746     /* The current votes */
747     mapping (string => bool) mapHeirsVoteOwnerHasDied;
748 
749     /* The status of the contract*/
750     enum Status {CREATED, ALIVE, DEAD}
751     Status status;
752 
753     /* EVENTS */
754     event Deposit(address from, uint value);
755     event SingleTransact(address owner, uint value, address to, bytes data);
756 
757     /* ***************** */
758     /* Contract creation */
759     /* ***************** */
760 
761     function MyWill (address _owner, string _listHeirs, string _listHeirsPercentages, string _listWitnesses, address _club) {
762         club = _club;
763         owner = _owner;
764         status = Status.CREATED;
765         listHeirs = _listHeirs;
766         listHeirsPercentages = _listHeirsPercentages;
767         listWitnesses = _listWitnesses;
768 
769         /* Check List Percentages */
770         var s = _listHeirsPercentages.toSlice().copy();
771         var delim = ";".toSlice();
772         var parts = new uint256[](s.count(delim) + 1);
773 
774         uint256 countPercentage;
775         for(uint i = 0; i < parts.length; i++) {
776             countPercentage = countPercentage + stringToUint(s.split(delim).toString());
777         }
778 
779         require(countPercentage == 100000);
780     }
781 
782     /* ********* */
783     /* Modifiers */
784     /* ********* */
785 
786     modifier onlyOwner() {
787         require(msg.sender == owner);
788         _;
789     }
790 
791     modifier onlyAlive() {
792         require(status == Status.ALIVE || status == Status.CREATED);
793         _;
794     }
795 
796     modifier onlyDead() {
797         require(status == Status.DEAD);
798         _;
799     }
800 
801     modifier onlyHeir() {
802 
803         var s = listHeirs.toSlice().copy();
804         var delim = ";".toSlice();
805         string[] memory listOfHeirs = new string[](s.count(delim) + 1);
806         bool itsHeir = false;
807 
808         string memory senderStringAddress = addressToString(msg.sender);
809 
810         for(uint i = 0; i < listOfHeirs.length; i++) {
811 
812             if(keccak256(senderStringAddress) == keccak256(s.split(delim).toString())){
813                 itsHeir = true;
814                 break;
815             }
816         }
817 
818         require(itsHeir);
819 
820         _;
821     }
822 
823     modifier onlyWitness() {
824 
825         var s = listWitnesses.toSlice().copy();
826         var delim = ";".toSlice();
827         string[] memory arrayOfWitnesses = new string[](s.count(delim) + 1);
828         bool itsWitness = false;
829 
830         string memory senderStringAddress = addressToString(msg.sender);
831 
832         for(uint i = 0; i < arrayOfWitnesses.length; i++) {
833 
834             if(keccak256(senderStringAddress) == keccak256(s.split(delim).toString())){
835                 itsWitness = true;
836                 break;
837             }
838         }
839 
840         require(itsWitness);
841 
842         _;
843     }
844 
845     /* ********* */
846     /* Functions */
847     /* ********* */
848 
849     /* Deposit ether to contract */
850     function () payable onlyAlive {
851         if (status == Status.CREATED) {
852             /* First time, provide witness with ether and pay the fee */
853 
854             // Check if the minimum ammount is provided
855             var witnessesList = listWitnesses.toSlice().copy();
856             var witnessesLength = witnessesList.count(";".toSlice()) + 1;
857             var needed = 1000000000000000 * witnessesLength + 5000000000000000; // 0.001 for each witness and 0.005 for the costs of deploying the smart contract
858             require(msg.value > needed);
859 
860             // Send ether to witnesses
861             for (uint i = 0; i < witnessesLength; i++) {
862                 var witnessAddress = parseAddr(witnessesList.split(";".toSlice()).toString());
863                 witnessAddress.transfer(1000000000000000);
864             }
865 
866             // Send ether to club
867             club.transfer(5000000000000000);
868 
869             // Set the status to active
870             status = Status.ALIVE;
871 
872             // Deposit event
873             Deposit(msg.sender, msg.value - needed);
874         } else {
875             Deposit(msg.sender, msg.value);
876         }
877     }
878 
879     /* Witness executes owner died */
880     function ownerDied() onlyWitness onlyAlive {
881 
882         require (this.balance > 0);
883 
884         //Set owner as died
885         mapHeirsVoteOwnerHasDied[addressToString(msg.sender)] = true;
886 
887         var users = listWitnesses.toSlice().copy();
888         uint256 listLength = users.count(";".toSlice()) + 1;
889         uint8 count = 0;
890 
891         for(uint i = 0; i < listLength; i++) {
892 
893             if(mapHeirsVoteOwnerHasDied[users.split(";".toSlice()).toString()] == true){
894                 count = count + 1;
895             }
896         }
897 
898         if(count == listLength){
899 
900             /* Execute the last will */
901 
902             users = listHeirs.toSlice().copy();
903             var  percentages = listHeirsPercentages.toSlice().copy();
904             listLength = users.count(";".toSlice()) + 1;
905 
906             for(i = 0; i < listLength - 1; i++) {
907                 parseAddr(users.split(";".toSlice()).toString()).transfer(((this.balance * stringToUint(percentages.split(";".toSlice()).toString())) / 100000));
908             }
909 
910             // Last one gets the remaining
911             parseAddr(users.split(";".toSlice()).toString()).transfer(this.balance);
912 
913             status = Status.DEAD;
914         }
915     }
916 
917     /* ******** */
918     /* Transfer */
919     /* ******** */
920 
921     function execute(address _to, uint _value, bytes _data) external onlyOwner {
922         SingleTransact(msg.sender, _value, _to, _data);
923         _to.call.value(_value)(_data);
924     }
925 
926     /* ******* */
927     /* Getters */
928     /* ******* */
929 
930     function isOwner() returns (bool){
931         return msg.sender == owner;
932     }
933 
934     function getStatus() returns (Status){
935         return status;
936     }
937 
938     function getHeirs() returns (string, string) {
939         return (listHeirs, listHeirsPercentages);
940     }
941 
942     function getWitnesses() returns (string) {
943         return listWitnesses;
944     }
945 
946     function getWitnessesCount() returns (uint) {
947         return listWitnesses.toSlice().copy().count(";".toSlice()) + 1;
948     }
949 
950     function getBalance() constant returns (uint) {
951         return  address(this).balance;
952     }
953 
954     function hasVoted() returns (bool){
955         return mapHeirsVoteOwnerHasDied[addressToString(msg.sender)];
956     }
957 
958     /* ***************** */
959     /* Utility Functions */
960     /* ***************** */
961 
962     function stringToUint(string s) constant private returns (uint result) {
963         bytes memory b = bytes(s);
964         uint i;
965         result = 0;
966         for (i = 0; i < b.length; i++) {
967             uint c = uint(b[i]);
968             if (c >= 48 && c <= 57) {
969                 result = result * 10 + (c - 48);
970             }
971         }
972     }
973 
974     function addressToString(address x) private returns (string) {
975         bytes memory s = new bytes(42);
976         s[0] = "0";
977         s[1] = "x";
978         for (uint i = 0; i < 20; i++) {
979             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
980             byte hi = byte(uint8(b) / 16);
981             byte lo = byte(uint8(b) - 16 * uint8(hi));
982             s[2+2*i] = char(hi);
983             s[2+2*i+1] = char(lo);
984         }
985         return string(s);
986     }
987 
988     function char(byte b) private returns (byte c) {
989         if (b < 10) return byte(uint8(b) + 0x30);
990         else return byte(uint8(b) + 0x57);
991     }
992 
993 
994     function parseAddr(string _a) internal returns (address){
995         bytes memory tmp = bytes(_a);
996         uint160 iaddr = 0;
997         uint160 b1;
998         uint160 b2;
999         for (uint i=2; i<2+2*20; i+=2){
1000             iaddr *= 256;
1001             b1 = uint160(tmp[i]);
1002             b2 = uint160(tmp[i+1]);
1003             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1004             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1005             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1006             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1007             iaddr += (b1*16+b2);
1008         }
1009         return address(iaddr);
1010     }
1011 
1012 
1013 }
1014 
1015 // File: contracts\BackToLife.sol
1016 
1017 /* https://github.com/Arachnid/solidity-stringutils */
1018 
1019 
1020 
1021 contract BackToLife {
1022 
1023     using strings for *;
1024 
1025     address club;
1026 
1027     mapping (address => string) mapOwnerStringContract;
1028 
1029     /* Create base contract */
1030     function BackToLife () {
1031         club = msg.sender;
1032     }
1033 
1034     /* Create Last Will Contract */
1035     function createLastWill (address _owner, string _listHeirs, string _listHeirsPercentages, string _listWitnesses) {
1036 
1037         address owner = _owner;
1038 
1039         var s = _listHeirs.toSlice().copy();
1040 
1041         if (!s.endsWith(";".toSlice())){
1042             _listHeirs.toSlice().concat(";".toSlice());
1043         }
1044 
1045         s = _listWitnesses.toSlice().copy();
1046         if (!s.endsWith(";".toSlice())){
1047             _listWitnesses.toSlice().concat(";".toSlice());
1048         }
1049 
1050         s = _listHeirsPercentages.toSlice().copy();
1051         if (!s.endsWith(";".toSlice())){
1052             _listHeirsPercentages.toSlice().concat(";".toSlice());
1053         }
1054 
1055 
1056         /* Add contract to the list of each heirs */
1057 //        s = _listHeirs.toSlice().copy();
1058 //        var delim = ";".toSlice();
1059 //        uint256 listHeirsLength = s.count(delim) + 1;
1060 //        string memory senderStringAddress = addressToString(owner);
1061 //        for(uint i = 0; i < listHeirsLength; i++) {
1062 //            address heirAddress = parseAddr(s.split(delim).toString());
1063 //            mapOwnerStringContract[heirAddress] =  mapOwnerStringContract[heirAddress].toSlice().concat(stringContractAddress.toSlice()).toSlice().concat(";".toSlice());
1064 //        }
1065 
1066         /* Calculate number of witness */
1067         s = _listWitnesses.toSlice().copy();
1068         var delim = ";".toSlice();
1069         uint256 listWitnessLength = s.count(delim) + 1;
1070 
1071         /* Create the My Will contract */
1072         address myWillAddress = new MyWill(owner, _listHeirs, _listHeirsPercentages, _listWitnesses, club);
1073         var myWillAddressString = addressToString(myWillAddress);
1074         mapOwnerStringContract[owner] =  mapOwnerStringContract[owner].toSlice().concat(myWillAddressString.toSlice()).toSlice().concat(";".toSlice());
1075     }
1076 
1077     /* Get Address Contracts */
1078     function getContracts(address owner) returns (string) {
1079         return mapOwnerStringContract[owner];
1080     }
1081 
1082     function addressToString(address x) returns (string) {
1083         bytes memory s = new bytes(42);
1084         s[0] = "0";
1085         s[1] = "x";
1086         for (uint i = 0; i < 20; i++) {
1087             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
1088             byte hi = byte(uint8(b) / 16);
1089             byte lo = byte(uint8(b) - 16 * uint8(hi));
1090             s[2+2*i] = char(hi);
1091             s[2+2*i+1] = char(lo);
1092         }
1093         return string(s);
1094     }
1095 
1096     function char(byte b) returns (byte c) {
1097         if (b < 10) return byte(uint8(b) + 0x30);
1098         else return byte(uint8(b) + 0x57);
1099     }
1100 
1101 //    function parseAddr(string _a) internal returns (address){
1102 //        bytes memory tmp = bytes(_a);
1103 //        uint160 iaddr = 0;
1104 //        uint160 b1;
1105 //        uint160 b2;
1106 //        for (uint i=2; i<2+2*20; i+=2){
1107 //            iaddr *= 256;
1108 //            b1 = uint160(tmp[i]);
1109 //            b2 = uint160(tmp[i+1]);
1110 //            if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1111 //            else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1112 //            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1113 //            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1114 //            iaddr += (b1*16+b2);
1115 //        }
1116 //        return address(iaddr);
1117 //    }
1118 
1119     function getBalance() constant returns (uint) {
1120         return  address(this).balance;
1121     }
1122 
1123 }