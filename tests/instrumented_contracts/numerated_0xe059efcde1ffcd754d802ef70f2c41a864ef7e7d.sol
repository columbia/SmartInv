1 pragma solidity ^0.4.24;
2 
3 
4 /*
5  * @title String & slice utility library for Solidity contracts.
6  * @author Nick Johnson <arachnid@notdot.net>
7  *
8  * @dev Functionality in this library is largely implemented using an
9  *      abstraction called a 'slice'. A slice represents a part of a string -
10  *      anything from the entire string to a single character, or even no
11  *      characters at all (a 0-length slice). Since a slice only has to specify
12  *      an offset and a length, copying and manipulating slices is a lot less
13  *      expensive than copying and manipulating the strings they reference.
14  *
15  *      To further reduce gas costs, most functions on slice that need to return
16  *      a slice modify the original one instead of allocating a new one; for
17  *      instance, `s.split(".")` will return the text up to the first '.',
18  *      modifying s to only contain the remainder of the string after the '.'.
19  *      In situations where you do not want to modify the original slice, you
20  *      can make a copy first with `.copy()`, for example:
21  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
22  *      Solidity has no memory management, it will result in allocating many
23  *      short-lived slices that are later discarded.
24  *
25  *      Functions that return two slices come in two versions: a non-allocating
26  *      version that takes the second slice as an argument, modifying it in
27  *      place, and an allocating version that allocates and returns the second
28  *      slice; see `nextRune` for example.
29  *
30  *      Functions that have to copy string data will return strings rather than
31  *      slices; these can be cast back to slices for further processing if
32  *      required.
33  *
34  *      For convenience, some functions are provided with non-modifying
35  *      variants that create a new slice and return both; for instance,
36  *      `s.splitNew('.')` leaves s unmodified, and returns two values
37  *      corresponding to the left and right parts of the string.
38  */
39 
40 
41 
42 library strings {
43     struct slice {
44         uint _len;
45         uint _ptr;
46     }
47 
48     function memcpy(uint dest, uint src, uint len) private pure {
49         // Copy word-length chunks while possible
50         for(; len >= 32; len -= 32) {
51             assembly {
52                 mstore(dest, mload(src))
53             }
54             dest += 32;
55             src += 32;
56         }
57 
58         // Copy remaining bytes
59         uint mask = 256 ** (32 - len) - 1;
60         assembly {
61             let srcpart := and(mload(src), not(mask))
62             let destpart := and(mload(dest), mask)
63             mstore(dest, or(destpart, srcpart))
64         }
65     }
66 
67     /*
68      * @dev Returns a slice containing the entire string.
69      * @param self The string to make a slice from.
70      * @return A newly allocated slice containing the entire string.
71      */
72     function toSlice(string memory self) internal pure returns (slice memory) {
73         uint ptr;
74         assembly {
75             ptr := add(self, 0x20)
76         }
77         return slice(bytes(self).length, ptr);
78     }
79 
80     /*
81      * @dev Returns the length of a null-terminated bytes32 string.
82      * @param self The value to find the length of.
83      * @return The length of the string, from 0 to 32.
84      */
85     function len(bytes32 self) internal pure returns (uint) {
86         uint ret;
87         if (self == 0)
88             return 0;
89         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
90             ret += 16;
91             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
92         }
93         if (self & 0xffffffffffffffff == 0) {
94             ret += 8;
95             self = bytes32(uint(self) / 0x10000000000000000);
96         }
97         if (self & 0xffffffff == 0) {
98             ret += 4;
99             self = bytes32(uint(self) / 0x100000000);
100         }
101         if (self & 0xffff == 0) {
102             ret += 2;
103             self = bytes32(uint(self) / 0x10000);
104         }
105         if (self & 0xff == 0) {
106             ret += 1;
107         }
108         return 32 - ret;
109     }
110 
111     /*
112      * @dev Returns a slice containing the entire bytes32, interpreted as a
113      *      null-terminated utf-8 string.
114      * @param self The bytes32 value to convert to a slice.
115      * @return A new slice containing the value of the input argument up to the
116      *         first null.
117      */
118     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
119         // Allocate space for `self` in memory, copy it there, and point ret at it
120         assembly {
121             let ptr := mload(0x40)
122             mstore(0x40, add(ptr, 0x20))
123             mstore(ptr, self)
124             mstore(add(ret, 0x20), ptr)
125         }
126         ret._len = len(self);
127     }
128 
129     /*
130      * @dev Returns a new slice containing the same data as the current slice.
131      * @param self The slice to copy.
132      * @return A new slice containing the same data as `self`.
133      */
134     function copy(slice memory self) internal pure returns (slice memory) {
135         return slice(self._len, self._ptr);
136     }
137 
138     /*
139      * @dev Copies a slice to a new string.
140      * @param self The slice to copy.
141      * @return A newly allocated string containing the slice's text.
142      */
143     function toString(slice memory self) internal pure returns (string memory) {
144         string memory ret = new string(self._len);
145         uint retptr;
146         assembly { retptr := add(ret, 32) }
147 
148         memcpy(retptr, self._ptr, self._len);
149         return ret;
150     }
151 
152     /*
153      * @dev Returns the length in runes of the slice. Note that this operation
154      *      takes time proportional to the length of the slice; avoid using it
155      *      in loops, and call `slice.empty()` if you only need to know whether
156      *      the slice is empty or not.
157      * @param self The slice to operate on.
158      * @return The length of the slice in runes.
159      */
160     function len(slice memory self) internal pure returns (uint l) {
161         // Starting at ptr-31 means the LSB will be the byte we care about
162         uint ptr = self._ptr - 31;
163         uint end = ptr + self._len;
164         for (l = 0; ptr < end; l++) {
165             uint8 b;
166             assembly { b := and(mload(ptr), 0xFF) }
167             if (b < 0x80) {
168                 ptr += 1;
169             } else if(b < 0xE0) {
170                 ptr += 2;
171             } else if(b < 0xF0) {
172                 ptr += 3;
173             } else if(b < 0xF8) {
174                 ptr += 4;
175             } else if(b < 0xFC) {
176                 ptr += 5;
177             } else {
178                 ptr += 6;
179             }
180         }
181     }
182 
183     /*
184      * @dev Returns true if the slice is empty (has a length of 0).
185      * @param self The slice to operate on.
186      * @return True if the slice is empty, False otherwise.
187      */
188     function empty(slice memory self) internal pure returns (bool) {
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
201     function compare(slice memory self, slice memory other) internal pure returns (int) {
202         uint shortest = self._len;
203         if (other._len < self._len)
204             shortest = other._len;
205 
206         uint selfptr = self._ptr;
207         uint otherptr = other._ptr;
208         for (uint idx = 0; idx < shortest; idx += 32) {
209             uint a;
210             uint b;
211             assembly {
212                 a := mload(selfptr)
213                 b := mload(otherptr)
214             }
215             if (a != b) {
216                 // Mask out irrelevant bytes and check again
217                 uint256 mask = uint256(-1); // 0xffff...
218                 if(shortest < 32) {
219                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
220                 }
221                 uint256 diff = (a & mask) - (b & mask);
222                 if (diff != 0)
223                     return int(diff);
224             }
225             selfptr += 32;
226             otherptr += 32;
227         }
228         return int(self._len) - int(other._len);
229     }
230 
231     /*
232      * @dev Returns true if the two slices contain the same text.
233      * @param self The first slice to compare.
234      * @param self The second slice to compare.
235      * @return True if the slices are equal, false otherwise.
236      */
237     function equals(slice memory self, slice memory other) internal pure returns (bool) {
238         return compare(self, other) == 0;
239     }
240 
241     /*
242      * @dev Extracts the first rune in the slice into `rune`, advancing the
243      *      slice to point to the next rune and returning `self`.
244      * @param self The slice to operate on.
245      * @param rune The slice that will contain the first rune.
246      * @return `rune`.
247      */
248     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
249         rune._ptr = self._ptr;
250 
251         if (self._len == 0) {
252             rune._len = 0;
253             return rune;
254         }
255 
256         uint l;
257         uint b;
258         // Load the first byte of the rune into the LSBs of b
259         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
260         if (b < 0x80) {
261             l = 1;
262         } else if(b < 0xE0) {
263             l = 2;
264         } else if(b < 0xF0) {
265             l = 3;
266         } else {
267             l = 4;
268         }
269 
270         // Check for truncated codepoints
271         if (l > self._len) {
272             rune._len = self._len;
273             self._ptr += self._len;
274             self._len = 0;
275             return rune;
276         }
277 
278         self._ptr += l;
279         self._len -= l;
280         rune._len = l;
281         return rune;
282     }
283 
284     /*
285      * @dev Returns the first rune in the slice, advancing the slice to point
286      *      to the next rune.
287      * @param self The slice to operate on.
288      * @return A slice containing only the first rune from `self`.
289      */
290     function nextRune(slice memory self) internal pure returns (slice memory ret) {
291         nextRune(self, ret);
292     }
293 
294     /*
295      * @dev Returns the number of the first codepoint in the slice.
296      * @param self The slice to operate on.
297      * @return The number of the first codepoint in the slice.
298      */
299     function ord(slice memory self) internal pure returns (uint ret) {
300         if (self._len == 0) {
301             return 0;
302         }
303 
304         uint word;
305         uint length;
306         uint divisor = 2 ** 248;
307 
308         // Load the rune into the MSBs of b
309         assembly { word:= mload(mload(add(self, 32))) }
310         uint b = word / divisor;
311         if (b < 0x80) {
312             ret = b;
313             length = 1;
314         } else if(b < 0xE0) {
315             ret = b & 0x1F;
316             length = 2;
317         } else if(b < 0xF0) {
318             ret = b & 0x0F;
319             length = 3;
320         } else {
321             ret = b & 0x07;
322             length = 4;
323         }
324 
325         // Check for truncated codepoints
326         if (length > self._len) {
327             return 0;
328         }
329 
330         for (uint i = 1; i < length; i++) {
331             divisor = divisor / 256;
332             b = (word / divisor) & 0xFF;
333             if (b & 0xC0 != 0x80) {
334                 // Invalid UTF-8 sequence
335                 return 0;
336             }
337             ret = (ret * 64) | (b & 0x3F);
338         }
339 
340         return ret;
341     }
342 
343     /*
344      * @dev Returns the keccak-256 hash of the slice.
345      * @param self The slice to hash.
346      * @return The hash of the slice.
347      */
348     function keccak(slice memory self) internal pure returns (bytes32 ret) {
349         assembly {
350             ret := keccak256(mload(add(self, 32)), mload(self))
351         }
352     }
353 
354     /*
355      * @dev Returns true if `self` starts with `needle`.
356      * @param self The slice to operate on.
357      * @param needle The slice to search for.
358      * @return True if the slice starts with the provided text, false otherwise.
359      */
360     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
361         if (self._len < needle._len) {
362             return false;
363         }
364 
365         if (self._ptr == needle._ptr) {
366             return true;
367         }
368 
369         bool equal;
370         assembly {
371             let length := mload(needle)
372             let selfptr := mload(add(self, 0x20))
373             let needleptr := mload(add(needle, 0x20))
374             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
375         }
376         return equal;
377     }
378 
379     /*
380      * @dev If `self` starts with `needle`, `needle` is removed from the
381      *      beginning of `self`. Otherwise, `self` is unmodified.
382      * @param self The slice to operate on.
383      * @param needle The slice to search for.
384      * @return `self`
385      */
386     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
387         if (self._len < needle._len) {
388             return self;
389         }
390 
391         bool equal = true;
392         if (self._ptr != needle._ptr) {
393             assembly {
394                 let length := mload(needle)
395                 let selfptr := mload(add(self, 0x20))
396                 let needleptr := mload(add(needle, 0x20))
397                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
398             }
399         }
400 
401         if (equal) {
402             self._len -= needle._len;
403             self._ptr += needle._len;
404         }
405 
406         return self;
407     }
408 
409     /*
410      * @dev Returns true if the slice ends with `needle`.
411      * @param self The slice to operate on.
412      * @param needle The slice to search for.
413      * @return True if the slice starts with the provided text, false otherwise.
414      */
415     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
416         if (self._len < needle._len) {
417             return false;
418         }
419 
420         uint selfptr = self._ptr + self._len - needle._len;
421 
422         if (selfptr == needle._ptr) {
423             return true;
424         }
425 
426         bool equal;
427         assembly {
428             let length := mload(needle)
429             let needleptr := mload(add(needle, 0x20))
430             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
431         }
432 
433         return equal;
434     }
435 
436     /*
437      * @dev If `self` ends with `needle`, `needle` is removed from the
438      *      end of `self`. Otherwise, `self` is unmodified.
439      * @param self The slice to operate on.
440      * @param needle The slice to search for.
441      * @return `self`
442      */
443     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
444         if (self._len < needle._len) {
445             return self;
446         }
447 
448         uint selfptr = self._ptr + self._len - needle._len;
449         bool equal = true;
450         if (selfptr != needle._ptr) {
451             assembly {
452                 let length := mload(needle)
453                 let needleptr := mload(add(needle, 0x20))
454                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
455             }
456         }
457 
458         if (equal) {
459             self._len -= needle._len;
460         }
461 
462         return self;
463     }
464 
465     // Returns the memory address of the first byte of the first occurrence of
466     // `needle` in `self`, or the first byte after `self` if not found.
467     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
468         uint ptr = selfptr;
469         uint idx;
470 
471         if (needlelen <= selflen) {
472             if (needlelen <= 32) {
473                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
474 
475                 bytes32 needledata;
476                 assembly { needledata := and(mload(needleptr), mask) }
477 
478                 uint end = selfptr + selflen - needlelen;
479                 bytes32 ptrdata;
480                 assembly { ptrdata := and(mload(ptr), mask) }
481 
482                 while (ptrdata != needledata) {
483                     if (ptr >= end)
484                         return selfptr + selflen;
485                     ptr++;
486                     assembly { ptrdata := and(mload(ptr), mask) }
487                 }
488                 return ptr;
489             } else {
490                 // For long needles, use hashing
491                 bytes32 hash;
492                 assembly { hash := keccak256(needleptr, needlelen) }
493 
494                 for (idx = 0; idx <= selflen - needlelen; idx++) {
495                     bytes32 testHash;
496                     assembly { testHash := keccak256(ptr, needlelen) }
497                     if (hash == testHash)
498                         return ptr;
499                     ptr += 1;
500                 }
501             }
502         }
503         return selfptr + selflen;
504     }
505 
506     // Returns the memory address of the first byte after the last occurrence of
507     // `needle` in `self`, or the address of `self` if not found.
508     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
509         uint ptr;
510 
511         if (needlelen <= selflen) {
512             if (needlelen <= 32) {
513                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
514 
515                 bytes32 needledata;
516                 assembly { needledata := and(mload(needleptr), mask) }
517 
518                 ptr = selfptr + selflen - needlelen;
519                 bytes32 ptrdata;
520                 assembly { ptrdata := and(mload(ptr), mask) }
521 
522                 while (ptrdata != needledata) {
523                     if (ptr <= selfptr)
524                         return selfptr;
525                     ptr--;
526                     assembly { ptrdata := and(mload(ptr), mask) }
527                 }
528                 return ptr + needlelen;
529             } else {
530                 // For long needles, use hashing
531                 bytes32 hash;
532                 assembly { hash := keccak256(needleptr, needlelen) }
533                 ptr = selfptr + (selflen - needlelen);
534                 while (ptr >= selfptr) {
535                     bytes32 testHash;
536                     assembly { testHash := keccak256(ptr, needlelen) }
537                     if (hash == testHash)
538                         return ptr + needlelen;
539                     ptr -= 1;
540                 }
541             }
542         }
543         return selfptr;
544     }
545 
546     /*
547      * @dev Modifies `self` to contain everything from the first occurrence of
548      *      `needle` to the end of the slice. `self` is set to the empty slice
549      *      if `needle` is not found.
550      * @param self The slice to search and modify.
551      * @param needle The text to search for.
552      * @return `self`.
553      */
554     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
555         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
556         self._len -= ptr - self._ptr;
557         self._ptr = ptr;
558         return self;
559     }
560 
561     /*
562      * @dev Modifies `self` to contain the part of the string from the start of
563      *      `self` to the end of the first occurrence of `needle`. If `needle`
564      *      is not found, `self` is set to the empty slice.
565      * @param self The slice to search and modify.
566      * @param needle The text to search for.
567      * @return `self`.
568      */
569     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
570         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
571         self._len = ptr - self._ptr;
572         return self;
573     }
574 
575     /*
576      * @dev Splits the slice, setting `self` to everything after the first
577      *      occurrence of `needle`, and `token` to everything before it. If
578      *      `needle` does not occur in `self`, `self` is set to the empty slice,
579      *      and `token` is set to the entirety of `self`.
580      * @param self The slice to split.
581      * @param needle The text to search for in `self`.
582      * @param token An output parameter to which the first token is written.
583      * @return `token`.
584      */
585     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
586         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
587         token._ptr = self._ptr;
588         token._len = ptr - self._ptr;
589         if (ptr == self._ptr + self._len) {
590             // Not found
591             self._len = 0;
592         } else {
593             self._len -= token._len + needle._len;
594             self._ptr = ptr + needle._len;
595         }
596         return token;
597     }
598 
599     /*
600      * @dev Splits the slice, setting `self` to everything after the first
601      *      occurrence of `needle`, and returning everything before it. If
602      *      `needle` does not occur in `self`, `self` is set to the empty slice,
603      *      and the entirety of `self` is returned.
604      * @param self The slice to split.
605      * @param needle The text to search for in `self`.
606      * @return The part of `self` up to the first occurrence of `delim`.
607      */
608     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
609         split(self, needle, token);
610     }
611 
612     /*
613      * @dev Splits the slice, setting `self` to everything before the last
614      *      occurrence of `needle`, and `token` to everything after it. If
615      *      `needle` does not occur in `self`, `self` is set to the empty slice,
616      *      and `token` is set to the entirety of `self`.
617      * @param self The slice to split.
618      * @param needle The text to search for in `self`.
619      * @param token An output parameter to which the first token is written.
620      * @return `token`.
621      */
622     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
623         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
624         token._ptr = ptr;
625         token._len = self._len - (ptr - self._ptr);
626         if (ptr == self._ptr) {
627             // Not found
628             self._len = 0;
629         } else {
630             self._len -= token._len + needle._len;
631         }
632         return token;
633     }
634 
635     /*
636      * @dev Splits the slice, setting `self` to everything before the last
637      *      occurrence of `needle`, and returning everything after it. If
638      *      `needle` does not occur in `self`, `self` is set to the empty slice,
639      *      and the entirety of `self` is returned.
640      * @param self The slice to split.
641      * @param needle The text to search for in `self`.
642      * @return The part of `self` after the last occurrence of `delim`.
643      */
644     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
645         rsplit(self, needle, token);
646     }
647 
648     /*
649      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
650      * @param self The slice to search.
651      * @param needle The text to search for in `self`.
652      * @return The number of occurrences of `needle` found in `self`.
653      */
654     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
655         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
656         while (ptr <= self._ptr + self._len) {
657             cnt++;
658             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
659         }
660     }
661 
662     /*
663      * @dev Returns True if `self` contains `needle`.
664      * @param self The slice to search.
665      * @param needle The text to search for in `self`.
666      * @return True if `needle` is found in `self`, false otherwise.
667      */
668     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
669         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
670     }
671 
672     /*
673      * @dev Returns a newly allocated string containing the concatenation of
674      *      `self` and `other`.
675      * @param self The first slice to concatenate.
676      * @param other The second slice to concatenate.
677      * @return The concatenation of the two strings.
678      */
679     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
680         string memory ret = new string(self._len + other._len);
681         uint retptr;
682         assembly { retptr := add(ret, 32) }
683         memcpy(retptr, self._ptr, self._len);
684         memcpy(retptr + self._len, other._ptr, other._len);
685         return ret;
686     }
687 
688     /*
689      * @dev Joins an array of slices, using `self` as a delimiter, returning a
690      *      newly allocated string.
691      * @param self The delimiter to use.
692      * @param parts A list of slices to join.
693      * @return A newly allocated string containing all the slices in `parts`,
694      *         joined with `self`.
695      */
696     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
697         if (parts.length == 0)
698             return "";
699 
700         uint length = self._len * (parts.length - 1);
701         for(uint i = 0; i < parts.length; i++)
702             length += parts[i]._len;
703 
704         string memory ret = new string(length);
705         uint retptr;
706         assembly { retptr := add(ret, 32) }
707 
708         for(i = 0; i < parts.length; i++) {
709             memcpy(retptr, parts[i]._ptr, parts[i]._len);
710             retptr += parts[i]._len;
711             if (i < parts.length - 1) {
712                 memcpy(retptr, self._ptr, self._len);
713                 retptr += self._len;
714             }
715         }
716 
717         return ret;
718     }
719 }
720 
721 contract Control {
722     using strings for *;
723 
724     uint constant REWARD_BASE = 100;
725     uint constant REWARD_TAX = 8;
726     uint constant REWARD_GET = REWARD_BASE - REWARD_TAX;
727     uint constant MAX_ALLBET = 2**120;//avoid bet overflow
728     uint constant MIN_BET = 0.001 ether;
729 
730     bytes32 constant SHA_DEUCE = keccak256("DEUCE");
731 
732     address internal creator;
733     address internal owner;
734     uint public destroy_time;
735 
736     constructor(address target)
737     public {
738         creator = msg.sender;
739         owner = target;
740         // this contract's exists time is one year
741         destroy_time = now + 365 * 24 * 60 * 60;
742     }
743 
744     function kill()
745     external payable {
746         require(now >= destroy_time);
747         selfdestruct(owner);
748     }
749 
750     struct PlayerBet {
751         uint bet0; //bet to deuce
752         uint bet1;
753         uint bet2;
754         bool drawed;
755     }
756 
757     struct MatchBet {
758         uint betDeadline;
759         uint allbet;
760         uint allbet0;//allbet to deuce
761         uint allbet1;
762         uint allbet2;
763         bool ownerDrawed;
764         bytes32 SHA_WIN;
765         bytes32 SHA_T1;
766         bytes32 SHA_T2;
767         mapping(address => PlayerBet) list;
768     }
769 
770     MatchBet[] public MatchList;
771 
772     modifier onlyOwner() {
773         require(msg.sender == creator || msg.sender == owner);
774         _;
775     }
776 
777     modifier MatchExist(uint index) {
778         require(index < MatchList.length);
779         _;
780     }
781 
782     function AddMatch(string troop1, string troop2, uint deadline)
783     external
784     onlyOwner {
785         MatchList.push(MatchBet({
786             betDeadline :deadline,
787             allbet      :0,
788             allbet0     :0,
789             allbet1     :0,
790             allbet2     :0,
791             ownerDrawed :false,
792             SHA_T1      :keccak256(bytes(troop1)),
793             SHA_T2      :keccak256(bytes(troop2)),
794             SHA_WIN     :bytes32(0)
795         }));
796     }
797 
798     //urgency situation
799     function MatchResetDeadline(uint index,uint time)
800     external
801     onlyOwner MatchExist(index) {
802         MatchBet storage oMatch = MatchList[index];
803         oMatch.betDeadline = time;
804     }
805 
806     function MatchEnd(uint index,string winTroop)
807     external
808     onlyOwner MatchExist(index) {
809         MatchBet storage oMatch = MatchList[index];
810         require(oMatch.SHA_WIN == 0);
811         bytes32 shaWin = keccak256(bytes(winTroop));
812         require(shaWin == SHA_DEUCE || shaWin == oMatch.SHA_T1 || shaWin == oMatch.SHA_T2 );
813         oMatch.SHA_WIN = shaWin;
814     }
815 
816     function Bet(uint index, string troop)
817     external payable
818     MatchExist(index) {
819         //check bet
820         require(msg.value >= MIN_BET);
821 
822         MatchBet storage oMatch = MatchList[index];
823 
824         //check timeout or match over
825         require(oMatch.SHA_WIN == 0 && oMatch.betDeadline >= now);
826 
827         uint tempAllBet = oMatch.allbet + msg.value;
828         //check if allbet overflow
829         require(tempAllBet > oMatch.allbet && tempAllBet <= MAX_ALLBET);
830 
831         PlayerBet storage oBet = oMatch.list[msg.sender];
832         oMatch.allbet = tempAllBet;
833         bytes32 shaBetTroop = keccak256(bytes(troop));
834         if ( shaBetTroop == oMatch.SHA_T1 ) {
835             oBet.bet1 += msg.value;
836             oMatch.allbet1 += msg.value;
837         }
838         else if ( shaBetTroop == oMatch.SHA_T2 ) {
839             oBet.bet2 += msg.value;
840             oMatch.allbet2 += msg.value;
841         }
842         else {
843             require( shaBetTroop == SHA_DEUCE );
844             oBet.bet0 += msg.value;
845             oMatch.allbet0 += msg.value;
846         }
847     }
848 
849     function CalReward(MatchBet storage oMatch,PlayerBet storage oBet)
850     internal view
851     returns(uint) {
852         uint myWinBet;
853         uint allWinBet;
854         if ( oMatch.SHA_WIN == oMatch.SHA_T1) {
855             myWinBet = oBet.bet1;
856             allWinBet = oMatch.allbet1;
857         }
858         else if ( oMatch.SHA_WIN == oMatch.SHA_T2 ) {
859             myWinBet = oBet.bet2;
860             allWinBet = oMatch.allbet2;
861         }
862         else {
863             myWinBet = oBet.bet0;
864             allWinBet = oMatch.allbet0;
865         }
866         if (myWinBet == 0) return 0;
867         return myWinBet + (oMatch.allbet - allWinBet) * myWinBet / allWinBet * REWARD_GET / REWARD_BASE;
868     }
869 
870     function Withdraw(uint index,address target)
871     public payable
872     MatchExist(index) {
873         MatchBet storage oMatch = MatchList[index];
874         PlayerBet storage oBet = oMatch.list[target];
875         if (oBet.drawed) return;
876         if (oMatch.SHA_WIN == 0) return;
877         uint reward = CalReward(oMatch,oBet);
878         if (reward == 0) return;
879         oBet.drawed = true;
880         target.transfer(reward);
881     }
882 
883     function WithdrawAll(address target)
884     external payable {
885         for (uint i=0; i<MatchList.length; i++) {
886             Withdraw(i,target);
887         }
888     }
889 
890     function CreatorWithdraw(uint index)
891     internal {
892         MatchBet storage oMatch = MatchList[index];
893         if (oMatch.ownerDrawed) return;
894         if (oMatch.SHA_WIN == 0) return;
895         oMatch.ownerDrawed = true;
896         uint allWinBet;
897         if ( oMatch.SHA_WIN == oMatch.SHA_T1) {
898             allWinBet = oMatch.allbet1;
899         }
900         else if ( oMatch.SHA_WIN == oMatch.SHA_T2 ) {
901             allWinBet = oMatch.allbet2;
902         }
903         else {
904             allWinBet = oMatch.allbet0;
905         }
906         if (oMatch.allbet == allWinBet) return;
907         if (allWinBet == 0) {
908             //nobody win, get all bet
909             owner.transfer(oMatch.allbet);
910         }
911         else {
912             //somebody win, withdraw tax
913             uint alltax = (oMatch.allbet - allWinBet) * REWARD_TAX / REWARD_BASE;
914             owner.transfer(alltax);
915         }
916     }
917 
918     function CreatorWithdrawAll()
919     external payable {
920         for (uint i=0; i<MatchList.length; i++) {
921             CreatorWithdraw(i);
922         }
923     }
924 
925     function GetMatchLength()
926     external view
927     returns(uint) {
928         return MatchList.length;
929     }
930 
931     function uint2str(uint i)
932     internal pure
933     returns (string){
934         if (i == 0) return "0";
935         uint j = i;
936         uint len;
937         while (j != 0){
938             len++;
939             j /= 10;
940         }
941         bytes memory bstr = new bytes(len);
942         while (i != 0){
943             bstr[--len] = byte(48 + i % 10);
944             i /= 10;
945         }
946         return string(bstr);
947     }
948 
949     function GetInfo(MatchBet storage obj,uint idx,address target)
950     internal view
951     returns(string){
952         PlayerBet storage oBet = obj.list[target];
953         string memory info = "#";
954         info = info.toSlice().concat(uint2str(idx).toSlice());
955         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(oBet.bet1).toSlice());
956         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(obj.allbet1).toSlice());
957         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(oBet.bet2).toSlice());
958         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(obj.allbet2).toSlice());
959         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(oBet.bet0).toSlice());
960         info = info.toSlice().concat(",".toSlice()).toSlice().concat(uint2str(obj.allbet0).toSlice());
961         if (oBet.drawed) {
962             info = info.toSlice().concat(",".toSlice()).toSlice().concat("1".toSlice());
963         }
964         else {
965             info = info.toSlice().concat(",".toSlice()).toSlice().concat("0".toSlice());
966         }
967         return info;
968     }
969 
970     function GetDetail(address target)
971     external view
972     returns(string) {
973         string memory res;
974         for (uint i=0; i<MatchList.length; i++){
975             res = res.toSlice().concat(GetInfo(MatchList[i],i,target).toSlice());
976         }
977         return res;
978     }
979 
980 }