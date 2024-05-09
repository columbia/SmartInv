1 pragma solidity 0.4.25;
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
39 pragma solidity 0.4.25;
40 
41 library strings {
42     struct slice {
43         uint _len;
44         uint _ptr;
45     }
46 
47     function memcpy(uint dest, uint src, uint len) private pure {
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
71     function toSlice(string self) internal pure returns (slice) {
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
84     function len(bytes32 self) internal pure returns (uint) {
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
112      *      null-terminated utf-8 string.
113      * @param self The bytes32 value to convert to a slice.
114      * @return A new slice containing the value of the input argument up to the
115      *         first null.
116      */
117     function toSliceB32(bytes32 self) internal pure returns (slice ret) {
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
133     function copy(slice self) internal pure returns (slice) {
134         return slice(self._len, self._ptr);
135     }
136 
137     /*
138      * @dev Copies a slice to a new string.
139      * @param self The slice to copy.
140      * @return A newly allocated string containing the slice's text.
141      */
142     function toString(slice self) internal pure returns (string) {
143         string memory ret = new string(self._len);
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
159     function len(slice self) internal pure returns (uint l) {
160         // Starting at ptr-31 means the LSB will be the byte we care about
161         uint ptr = self._ptr - 31;
162         uint end = ptr + self._len;
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
187     function empty(slice self) internal pure returns (bool) {
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
200     function compare(slice self, slice other) internal pure returns (int) {
201         uint shortest = self._len;
202         if (other._len < self._len)
203             shortest = other._len;
204 
205         uint selfptr = self._ptr;
206         uint otherptr = other._ptr;
207         for (uint idx = 0; idx < shortest; idx += 32) {
208             uint a;
209             uint b;
210             assembly {
211                 a := mload(selfptr)
212                 b := mload(otherptr)
213             }
214             if (a != b) {
215                 // Mask out irrelevant bytes and check again
216                 uint256 mask = uint256(-1); // 0xffff...
217                 if(shortest < 32) {
218                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
219                 }
220                 uint256 diff = (a & mask) - (b & mask);
221                 if (diff != 0)
222                     return int(diff);
223             }
224             selfptr += 32;
225             otherptr += 32;
226         }
227         return int(self._len) - int(other._len);
228     }
229 
230     /*
231      * @dev Returns true if the two slices contain the same text.
232      * @param self The first slice to compare.
233      * @param self The second slice to compare.
234      * @return True if the slices are equal, false otherwise.
235      */
236     function equals(slice self, slice other) internal pure returns (bool) {
237         return compare(self, other) == 0;
238     }
239 
240     /*
241      * @dev Extracts the first rune in the slice into `rune`, advancing the
242      *      slice to point to the next rune and returning `self`.
243      * @param self The slice to operate on.
244      * @param rune The slice that will contain the first rune.
245      * @return `rune`.
246      */
247     function nextRune(slice self, slice rune) internal pure returns (slice) {
248         rune._ptr = self._ptr;
249 
250         if (self._len == 0) {
251             rune._len = 0;
252             return rune;
253         }
254 
255         uint l;
256         uint b;
257         // Load the first byte of the rune into the LSBs of b
258         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
259         if (b < 0x80) {
260             l = 1;
261         } else if(b < 0xE0) {
262             l = 2;
263         } else if(b < 0xF0) {
264             l = 3;
265         } else {
266             l = 4;
267         }
268 
269         // Check for truncated codepoints
270         if (l > self._len) {
271             rune._len = self._len;
272             self._ptr += self._len;
273             self._len = 0;
274             return rune;
275         }
276 
277         self._ptr += l;
278         self._len -= l;
279         rune._len = l;
280         return rune;
281     }
282 
283     /*
284      * @dev Returns the first rune in the slice, advancing the slice to point
285      *      to the next rune.
286      * @param self The slice to operate on.
287      * @return A slice containing only the first rune from `self`.
288      */
289     function nextRune(slice self) internal pure returns (slice ret) {
290         nextRune(self, ret);
291     }
292 
293     /*
294      * @dev Returns the number of the first codepoint in the slice.
295      * @param self The slice to operate on.
296      * @return The number of the first codepoint in the slice.
297      */
298     function ord(slice self) internal pure returns (uint ret) {
299         if (self._len == 0) {
300             return 0;
301         }
302 
303         uint word;
304         uint length;
305         uint divisor = 2 ** 248;
306 
307         // Load the rune into the MSBs of b
308         assembly { word:= mload(mload(add(self, 32))) }
309         uint b = word / divisor;
310         if (b < 0x80) {
311             ret = b;
312             length = 1;
313         } else if(b < 0xE0) {
314             ret = b & 0x1F;
315             length = 2;
316         } else if(b < 0xF0) {
317             ret = b & 0x0F;
318             length = 3;
319         } else {
320             ret = b & 0x07;
321             length = 4;
322         }
323 
324         // Check for truncated codepoints
325         if (length > self._len) {
326             return 0;
327         }
328 
329         for (uint i = 1; i < length; i++) {
330             divisor = divisor / 256;
331             b = (word / divisor) & 0xFF;
332             if (b & 0xC0 != 0x80) {
333                 // Invalid UTF-8 sequence
334                 return 0;
335             }
336             ret = (ret * 64) | (b & 0x3F);
337         }
338 
339         return ret;
340     }
341 
342     /*
343      * @dev Returns the keccak-256 hash of the slice.
344      * @param self The slice to hash.
345      * @return The hash of the slice.
346      */
347     function keccak(slice self) internal pure returns (bytes32 ret) {
348         assembly {
349             ret := keccak256(mload(add(self, 32)), mload(self))
350         }
351     }
352 
353     /*
354      * @dev Returns true if `self` starts with `needle`.
355      * @param self The slice to operate on.
356      * @param needle The slice to search for.
357      * @return True if the slice starts with the provided text, false otherwise.
358      */
359     function startsWith(slice self, slice needle) internal pure returns (bool) {
360         if (self._len < needle._len) {
361             return false;
362         }
363 
364         if (self._ptr == needle._ptr) {
365             return true;
366         }
367 
368         bool equal;
369         assembly {
370             let length := mload(needle)
371             let selfptr := mload(add(self, 0x20))
372             let needleptr := mload(add(needle, 0x20))
373             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
374         }
375         return equal;
376     }
377 
378     /*
379      * @dev If `self` starts with `needle`, `needle` is removed from the
380      *      beginning of `self`. Otherwise, `self` is unmodified.
381      * @param self The slice to operate on.
382      * @param needle The slice to search for.
383      * @return `self`
384      */
385     function beyond(slice self, slice needle) internal pure returns (slice) {
386         if (self._len < needle._len) {
387             return self;
388         }
389 
390         bool equal = true;
391         if (self._ptr != needle._ptr) {
392             assembly {
393                 let length := mload(needle)
394                 let selfptr := mload(add(self, 0x20))
395                 let needleptr := mload(add(needle, 0x20))
396                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
397             }
398         }
399 
400         if (equal) {
401             self._len -= needle._len;
402             self._ptr += needle._len;
403         }
404 
405         return self;
406     }
407 
408     /*
409      * @dev Returns true if the slice ends with `needle`.
410      * @param self The slice to operate on.
411      * @param needle The slice to search for.
412      * @return True if the slice starts with the provided text, false otherwise.
413      */
414     function endsWith(slice self, slice needle) internal pure returns (bool) {
415         if (self._len < needle._len) {
416             return false;
417         }
418 
419         uint selfptr = self._ptr + self._len - needle._len;
420 
421         if (selfptr == needle._ptr) {
422             return true;
423         }
424 
425         bool equal;
426         assembly {
427             let length := mload(needle)
428             let needleptr := mload(add(needle, 0x20))
429             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
430         }
431 
432         return equal;
433     }
434 
435     /*
436      * @dev If `self` ends with `needle`, `needle` is removed from the
437      *      end of `self`. Otherwise, `self` is unmodified.
438      * @param self The slice to operate on.
439      * @param needle The slice to search for.
440      * @return `self`
441      */
442     function until(slice self, slice needle) internal pure returns (slice) {
443         if (self._len < needle._len) {
444             return self;
445         }
446 
447         uint selfptr = self._ptr + self._len - needle._len;
448         bool equal = true;
449         if (selfptr != needle._ptr) {
450             assembly {
451                 let length := mload(needle)
452                 let needleptr := mload(add(needle, 0x20))
453                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
454             }
455         }
456 
457         if (equal) {
458             self._len -= needle._len;
459         }
460 
461         return self;
462     }
463 
464     event log_bytemask(bytes32 mask);
465 
466     // Returns the memory address of the first byte of the first occurrence of
467     // `needle` in `self`, or the first byte after `self` if not found.
468     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
469         uint ptr = selfptr;
470         uint idx;
471 
472         if (needlelen <= selflen) {
473             if (needlelen <= 32) {
474                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
475 
476                 bytes32 needledata;
477                 assembly { needledata := and(mload(needleptr), mask) }
478 
479                 uint end = selfptr + selflen - needlelen;
480                 bytes32 ptrdata;
481                 assembly { ptrdata := and(mload(ptr), mask) }
482 
483                 while (ptrdata != needledata) {
484                     if (ptr >= end)
485                         return selfptr + selflen;
486                     ptr++;
487                     assembly { ptrdata := and(mload(ptr), mask) }
488                 }
489                 return ptr;
490             } else {
491                 // For long needles, use hashing
492                 bytes32 hash;
493                 assembly { hash := sha3(needleptr, needlelen) }
494 
495                 for (idx = 0; idx <= selflen - needlelen; idx++) {
496                     bytes32 testHash;
497                     assembly { testHash := sha3(ptr, needlelen) }
498                     if (hash == testHash)
499                         return ptr;
500                     ptr += 1;
501                 }
502             }
503         }
504         return selfptr + selflen;
505     }
506 
507     // Returns the memory address of the first byte after the last occurrence of
508     // `needle` in `self`, or the address of `self` if not found.
509     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
510         uint ptr;
511 
512         if (needlelen <= selflen) {
513             if (needlelen <= 32) {
514                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
515 
516                 bytes32 needledata;
517                 assembly { needledata := and(mload(needleptr), mask) }
518 
519                 ptr = selfptr + selflen - needlelen;
520                 bytes32 ptrdata;
521                 assembly { ptrdata := and(mload(ptr), mask) }
522 
523                 while (ptrdata != needledata) {
524                     if (ptr <= selfptr)
525                         return selfptr;
526                     ptr--;
527                     assembly { ptrdata := and(mload(ptr), mask) }
528                 }
529                 return ptr + needlelen;
530             } else {
531                 // For long needles, use hashing
532                 bytes32 hash;
533                 assembly { hash := sha3(needleptr, needlelen) }
534                 ptr = selfptr + (selflen - needlelen);
535                 while (ptr >= selfptr) {
536                     bytes32 testHash;
537                     assembly { testHash := sha3(ptr, needlelen) }
538                     if (hash == testHash)
539                         return ptr + needlelen;
540                     ptr -= 1;
541                 }
542             }
543         }
544         return selfptr;
545     }
546 
547     /*
548      * @dev Modifies `self` to contain everything from the first occurrence of
549      *      `needle` to the end of the slice. `self` is set to the empty slice
550      *      if `needle` is not found.
551      * @param self The slice to search and modify.
552      * @param needle The text to search for.
553      * @return `self`.
554      */
555     function find(slice self, slice needle) internal pure returns (slice) {
556         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
557         self._len -= ptr - self._ptr;
558         self._ptr = ptr;
559         return self;
560     }
561 
562     /*
563      * @dev Modifies `self` to contain the part of the string from the start of
564      *      `self` to the end of the first occurrence of `needle`. If `needle`
565      *      is not found, `self` is set to the empty slice.
566      * @param self The slice to search and modify.
567      * @param needle The text to search for.
568      * @return `self`.
569      */
570     function rfind(slice self, slice needle) internal pure returns (slice) {
571         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
572         self._len = ptr - self._ptr;
573         return self;
574     }
575 
576     /*
577      * @dev Splits the slice, setting `self` to everything after the first
578      *      occurrence of `needle`, and `token` to everything before it. If
579      *      `needle` does not occur in `self`, `self` is set to the empty slice,
580      *      and `token` is set to the entirety of `self`.
581      * @param self The slice to split.
582      * @param needle The text to search for in `self`.
583      * @param token An output parameter to which the first token is written.
584      * @return `token`.
585      */
586     function split(slice self, slice needle, slice token) internal pure returns (slice) {
587         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
588         token._ptr = self._ptr;
589         token._len = ptr - self._ptr;
590         if (ptr == self._ptr + self._len) {
591             // Not found
592             self._len = 0;
593         } else {
594             self._len -= token._len + needle._len;
595             self._ptr = ptr + needle._len;
596         }
597         return token;
598     }
599 
600     /*
601      * @dev Splits the slice, setting `self` to everything after the first
602      *      occurrence of `needle`, and returning everything before it. If
603      *      `needle` does not occur in `self`, `self` is set to the empty slice,
604      *      and the entirety of `self` is returned.
605      * @param self The slice to split.
606      * @param needle The text to search for in `self`.
607      * @return The part of `self` up to the first occurrence of `delim`.
608      */
609     function split(slice self, slice needle) internal pure returns (slice token) {
610         split(self, needle, token);
611     }
612 
613     /*
614      * @dev Splits the slice, setting `self` to everything before the last
615      *      occurrence of `needle`, and `token` to everything after it. If
616      *      `needle` does not occur in `self`, `self` is set to the empty slice,
617      *      and `token` is set to the entirety of `self`.
618      * @param self The slice to split.
619      * @param needle The text to search for in `self`.
620      * @param token An output parameter to which the first token is written.
621      * @return `token`.
622      */
623     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
624         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
625         token._ptr = ptr;
626         token._len = self._len - (ptr - self._ptr);
627         if (ptr == self._ptr) {
628             // Not found
629             self._len = 0;
630         } else {
631             self._len -= token._len + needle._len;
632         }
633         return token;
634     }
635 
636     /*
637      * @dev Splits the slice, setting `self` to everything before the last
638      *      occurrence of `needle`, and returning everything after it. If
639      *      `needle` does not occur in `self`, `self` is set to the empty slice,
640      *      and the entirety of `self` is returned.
641      * @param self The slice to split.
642      * @param needle The text to search for in `self`.
643      * @return The part of `self` after the last occurrence of `delim`.
644      */
645     function rsplit(slice self, slice needle) internal pure returns (slice token) {
646         rsplit(self, needle, token);
647     }
648 
649     /*
650      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
651      * @param self The slice to search.
652      * @param needle The text to search for in `self`.
653      * @return The number of occurrences of `needle` found in `self`.
654      */
655     function count(slice self, slice needle) internal pure returns (uint cnt) {
656         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
657         while (ptr <= self._ptr + self._len) {
658             cnt++;
659             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
660         }
661     }
662 
663     /*
664      * @dev Returns True if `self` contains `needle`.
665      * @param self The slice to search.
666      * @param needle The text to search for in `self`.
667      * @return True if `needle` is found in `self`, false otherwise.
668      */
669     function contains(slice self, slice needle) internal pure returns (bool) {
670         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
671     }
672 
673     /*
674      * @dev Returns a newly allocated string containing the concatenation of
675      *      `self` and `other`.
676      * @param self The first slice to concatenate.
677      * @param other The second slice to concatenate.
678      * @return The concatenation of the two strings.
679      */
680     function concat(slice self, slice other) internal pure returns (string) {
681         string memory ret = new string(self._len + other._len);
682         uint retptr;
683         assembly { retptr := add(ret, 32) }
684         memcpy(retptr, self._ptr, self._len);
685         memcpy(retptr + self._len, other._ptr, other._len);
686         return ret;
687     }
688 
689     /*
690      * @dev Joins an array of slices, using `self` as a delimiter, returning a
691      *      newly allocated string.
692      * @param self The delimiter to use.
693      * @param parts A list of slices to join.
694      * @return A newly allocated string containing all the slices in `parts`,
695      *         joined with `self`.
696      */
697     function join(slice self, slice[] parts) internal pure returns (string) {
698         if (parts.length == 0)
699             return "";
700 
701         uint length = self._len * (parts.length - 1);
702         for(uint i = 0; i < parts.length; i++)
703             length += parts[i]._len;
704 
705         string memory ret = new string(length);
706         uint retptr;
707         assembly { retptr := add(ret, 32) }
708 
709         for(i = 0; i < parts.length; i++) {
710             memcpy(retptr, parts[i]._ptr, parts[i]._len);
711             retptr += parts[i]._len;
712             if (i < parts.length - 1) {
713                 memcpy(retptr, self._ptr, self._len);
714                 retptr += self._len;
715             }
716         }
717 
718         return ret;
719     }
720 }
721 
722 /**
723  * @title Ownable
724  * @dev The Ownable contract has an owner address, and provides basic authorization control
725  * functions, this simplifies the implementation of "user permissions".
726  */
727 contract Ownable {
728   address public owner;
729   address public coinvest;
730   mapping (address => bool) public admins;
731 
732   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
733 
734   /**
735    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
736    * account.
737    */
738   constructor() public {
739     owner = msg.sender;
740     coinvest = msg.sender;
741     admins[owner] = true;
742     admins[coinvest] = true;
743   }
744 
745   /**
746    * @dev Throws if called by any account other than the owner.
747    */
748   modifier onlyOwner() {
749     require(msg.sender == owner);
750     _;
751   }
752 
753   modifier coinvestOrOwner() {
754       require(msg.sender == coinvest || msg.sender == owner);
755       _;
756   }
757 
758   modifier onlyAdmin() {
759       require(admins[msg.sender]);
760       _;
761   }
762 
763   /**
764    * @dev Allows the current owner to transfer control of the contract to a newOwner.
765    * @param newOwner The address to transfer ownership to.
766    */
767   function transferOwnership(address newOwner) onlyOwner public {
768     require(newOwner != address(0));
769     emit OwnershipTransferred(owner, newOwner);
770     owner = newOwner;
771   }
772   
773   /**
774    * @dev Changes the Coinvest wallet that will receive funds from investment contract.
775    * @param _newCoinvest The address of the new wallet.
776   **/
777   function transferCoinvest(address _newCoinvest) 
778     external
779     onlyOwner
780   {
781     require(_newCoinvest != address(0));
782     coinvest = _newCoinvest;
783   }
784 
785   /**
786    * @dev Used to add admins who are allowed to add funds to the investment contract and change gas price.
787    * @param _user The address of the admin to add or remove.
788    * @param _status True to add the user, False to remove the user.
789   **/
790   function alterAdmin(address _user, bool _status)
791     external
792     onlyOwner
793   {
794     require(_user != address(0));
795     require(_user != coinvest);
796     admins[_user] = _status;
797   }
798 
799 }
800 
801 // <ORACLIZE_API>
802 /*
803 Copyright (c) 2015-2016 Oraclize SRL
804 Copyright (c) 2016 Oraclize LTD
805 
806 
807 
808 Permission is hereby granted, free of charge, to any person obtaining a copy
809 of this software and associated documentation files (the "Software"), to deal
810 in the Software without restriction, including without limitation the rights
811 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
812 copies of the Software, and to permit persons to whom the Software is
813 furnished to do so, subject to the following conditions:
814 
815 
816 
817 The above copyright notice and this permission notice shall be included in
818 all copies or substantial portions of the Software.
819 
820 
821 
822 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
823 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
824 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
825 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
826 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
827 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
828 THE SOFTWARE.
829 */
830 
831 pragma solidity >= 0.4.1 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
832 
833 contract OraclizeI {
834     address public cbAddress;
835     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
836     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
837     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
838     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
839     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
840     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
841     function getPrice(string _datasource) returns (uint _dsprice);
842     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
843     function useCoupon(string _coupon);
844     function setProofType(byte _proofType);
845     function setConfig(bytes32 _config);
846     function setCustomGasPrice(uint _gasPrice);
847     function randomDS_getSessionPubKeyHash() returns(bytes32);
848 }
849 
850 contract OraclizeAddrResolverI {
851     function getAddress() returns (address _addr);
852 }
853 
854 /*
855 Begin solidity-cborutils
856 
857 https://github.com/smartcontractkit/solidity-cborutils
858 
859 MIT License
860 
861 Copyright (c) 2018 SmartContract ChainLink, Ltd.
862 
863 Permission is hereby granted, free of charge, to any person obtaining a copy
864 of this software and associated documentation files (the "Software"), to deal
865 in the Software without restriction, including without limitation the rights
866 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
867 copies of the Software, and to permit persons to whom the Software is
868 furnished to do so, subject to the following conditions:
869 
870 The above copyright notice and this permission notice shall be included in all
871 copies or substantial portions of the Software.
872 
873 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
874 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
875 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
876 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
877 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
878 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
879 SOFTWARE.
880  */
881 
882 library Buffer {
883     struct buffer {
884         bytes buf;
885         uint capacity;
886     }
887 
888     function init(buffer memory buf, uint _capacity) internal constant {
889         uint capacity = _capacity;
890         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
891         // Allocate space for the buffer data
892         buf.capacity = capacity;
893         assembly {
894             let ptr := mload(0x40)
895             mstore(buf, ptr)
896             mstore(ptr, 0)
897             mstore(0x40, add(ptr, capacity))
898         }
899     }
900 
901     function resize(buffer memory buf, uint capacity) private constant {
902         bytes memory oldbuf = buf.buf;
903         init(buf, capacity);
904         append(buf, oldbuf);
905     }
906 
907     function max(uint a, uint b) private constant returns(uint) {
908         if(a > b) {
909             return a;
910         }
911         return b;
912     }
913 
914     /**
915      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
916      *      would exceed the capacity of the buffer.
917      * @param buf The buffer to append to.
918      * @param data The data to append.
919      * @return The original buffer.
920      */
921     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
922         if(data.length + buf.buf.length > buf.capacity) {
923             resize(buf, max(buf.capacity, data.length) * 2);
924         }
925 
926         uint dest;
927         uint src;
928         uint len = data.length;
929         assembly {
930             // Memory address of the buffer data
931             let bufptr := mload(buf)
932             // Length of existing buffer data
933             let buflen := mload(bufptr)
934             // Start address = buffer address + buffer length + sizeof(buffer length)
935             dest := add(add(bufptr, buflen), 32)
936             // Update buffer length
937             mstore(bufptr, add(buflen, mload(data)))
938             src := add(data, 32)
939         }
940 
941         // Copy word-length chunks while possible
942         for(; len >= 32; len -= 32) {
943             assembly {
944                 mstore(dest, mload(src))
945             }
946             dest += 32;
947             src += 32;
948         }
949 
950         // Copy remaining bytes
951         uint mask = 256 ** (32 - len) - 1;
952         assembly {
953             let srcpart := and(mload(src), not(mask))
954             let destpart := and(mload(dest), mask)
955             mstore(dest, or(destpart, srcpart))
956         }
957 
958         return buf;
959     }
960 
961     /**
962      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
963      * exceed the capacity of the buffer.
964      * @param buf The buffer to append to.
965      * @param data The data to append.
966      * @return The original buffer.
967      */
968     function append(buffer memory buf, uint8 data) internal constant {
969         if(buf.buf.length + 1 > buf.capacity) {
970             resize(buf, buf.capacity * 2);
971         }
972 
973         assembly {
974             // Memory address of the buffer data
975             let bufptr := mload(buf)
976             // Length of existing buffer data
977             let buflen := mload(bufptr)
978             // Address = buffer address + buffer length + sizeof(buffer length)
979             let dest := add(add(bufptr, buflen), 32)
980             mstore8(dest, data)
981             // Update buffer length
982             mstore(bufptr, add(buflen, 1))
983         }
984     }
985 
986     /**
987      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
988      * exceed the capacity of the buffer.
989      * @param buf The buffer to append to.
990      * @param data The data to append.
991      * @return The original buffer.
992      */
993     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
994         if(len + buf.buf.length > buf.capacity) {
995             resize(buf, max(buf.capacity, len) * 2);
996         }
997 
998         uint mask = 256 ** len - 1;
999         assembly {
1000             // Memory address of the buffer data
1001             let bufptr := mload(buf)
1002             // Length of existing buffer data
1003             let buflen := mload(bufptr)
1004             // Address = buffer address + buffer length + sizeof(buffer length) + len
1005             let dest := add(add(bufptr, buflen), len)
1006             mstore(dest, or(and(mload(dest), not(mask)), data))
1007             // Update buffer length
1008             mstore(bufptr, add(buflen, len))
1009         }
1010         return buf;
1011     }
1012 }
1013 
1014 library CBOR {
1015     using Buffer for Buffer.buffer;
1016 
1017     uint8 private constant MAJOR_TYPE_INT = 0;
1018     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1019     uint8 private constant MAJOR_TYPE_BYTES = 2;
1020     uint8 private constant MAJOR_TYPE_STRING = 3;
1021     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1022     uint8 private constant MAJOR_TYPE_MAP = 5;
1023     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1024 
1025     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
1026         return x * (2 ** y);
1027     }
1028 
1029     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
1030         if(value <= 23) {
1031             buf.append(uint8(shl8(major, 5) | value));
1032         } else if(value <= 0xFF) {
1033             buf.append(uint8(shl8(major, 5) | 24));
1034             buf.appendInt(value, 1);
1035         } else if(value <= 0xFFFF) {
1036             buf.append(uint8(shl8(major, 5) | 25));
1037             buf.appendInt(value, 2);
1038         } else if(value <= 0xFFFFFFFF) {
1039             buf.append(uint8(shl8(major, 5) | 26));
1040             buf.appendInt(value, 4);
1041         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
1042             buf.append(uint8(shl8(major, 5) | 27));
1043             buf.appendInt(value, 8);
1044         }
1045     }
1046 
1047     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
1048         buf.append(uint8(shl8(major, 5) | 31));
1049     }
1050 
1051     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
1052         encodeType(buf, MAJOR_TYPE_INT, value);
1053     }
1054 
1055     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
1056         if(value >= 0) {
1057             encodeType(buf, MAJOR_TYPE_INT, uint(value));
1058         } else {
1059             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
1060         }
1061     }
1062 
1063     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
1064         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
1065         buf.append(value);
1066     }
1067 
1068     function encodeString(Buffer.buffer memory buf, string value) internal constant {
1069         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
1070         buf.append(bytes(value));
1071     }
1072 
1073     function startArray(Buffer.buffer memory buf) internal constant {
1074         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1075     }
1076 
1077     function startMap(Buffer.buffer memory buf) internal constant {
1078         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1079     }
1080 
1081     function endSequence(Buffer.buffer memory buf) internal constant {
1082         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1083     }
1084 }
1085 
1086 /*
1087 End solidity-cborutils
1088  */
1089 
1090 contract usingOraclize {
1091     uint constant day = 60*60*24;
1092     uint constant week = 60*60*24*7;
1093     uint constant month = 60*60*24*30;
1094     byte constant proofType_NONE = 0x00;
1095     byte constant proofType_TLSNotary = 0x10;
1096     byte constant proofType_Ledger = 0x30;
1097     byte constant proofType_Android = 0x40;
1098     byte constant proofType_Native = 0xF0;
1099     byte constant proofStorage_IPFS = 0x01;
1100     uint8 constant networkID_auto = 0;
1101     uint8 constant networkID_mainnet = 1;
1102     uint8 constant networkID_testnet = 2;
1103     uint8 constant networkID_morden = 2;
1104     uint8 constant networkID_consensys = 161;
1105 
1106     OraclizeAddrResolverI OAR;
1107 
1108     OraclizeI oraclize;
1109     modifier oraclizeAPI {
1110         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1111             oraclize_setNetwork(networkID_auto);
1112 
1113         if(address(oraclize) != OAR.getAddress())
1114             oraclize = OraclizeI(OAR.getAddress());
1115 
1116         _;
1117     }
1118     modifier coupon(string code){
1119         oraclize = OraclizeI(OAR.getAddress());
1120         oraclize.useCoupon(code);
1121         _;
1122     }
1123 
1124     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1125         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1126             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1127             oraclize_setNetworkName("eth_mainnet");
1128             return true;
1129         }
1130         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1131             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1132             oraclize_setNetworkName("eth_ropsten3");
1133             return true;
1134         }
1135         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1136             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1137             oraclize_setNetworkName("eth_kovan");
1138             return true;
1139         }
1140         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1141             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1142             oraclize_setNetworkName("eth_rinkeby");
1143             return true;
1144         }
1145         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1146             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1147             return true;
1148         }
1149         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1150             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1151             return true;
1152         }
1153         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1154             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1155             return true;
1156         }
1157         return false;
1158     }
1159 
1160     function __callback(bytes32 myid, string result) {
1161         __callback(myid, result, new bytes(0));
1162     }
1163     function __callback(bytes32 myid, string result, bytes proof) {
1164     }
1165 
1166     function oraclize_useCoupon(string code) oraclizeAPI internal {
1167         oraclize.useCoupon(code);
1168     }
1169 
1170     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1171         return oraclize.getPrice(datasource);
1172     }
1173 
1174     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1175         return oraclize.getPrice(datasource, gaslimit);
1176     }
1177 
1178     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1179         uint price = oraclize.getPrice(datasource);
1180         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1181         return oraclize.query.value(price)(0, datasource, arg);
1182     }
1183     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1184         uint price = oraclize.getPrice(datasource);
1185         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1186         return oraclize.query.value(price)(timestamp, datasource, arg);
1187     }
1188     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1189         uint price = oraclize.getPrice(datasource, gaslimit);
1190         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1191         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1192     }
1193     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1194         uint price = oraclize.getPrice(datasource, gaslimit);
1195         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1196         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1197     }
1198     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1199         uint price = oraclize.getPrice(datasource);
1200         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1201         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1202     }
1203     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1204         uint price = oraclize.getPrice(datasource);
1205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1206         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1207     }
1208     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1209         uint price = oraclize.getPrice(datasource, gaslimit);
1210         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1211         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1212     }
1213     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1214         uint price = oraclize.getPrice(datasource, gaslimit);
1215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1216         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1217     }
1218     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1219         uint price = oraclize.getPrice(datasource);
1220         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1221         bytes memory args = stra2cbor(argN);
1222         return oraclize.queryN.value(price)(0, datasource, args);
1223     }
1224     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1225         uint price = oraclize.getPrice(datasource);
1226         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1227         bytes memory args = stra2cbor(argN);
1228         return oraclize.queryN.value(price)(timestamp, datasource, args);
1229     }
1230     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1231         uint price = oraclize.getPrice(datasource, gaslimit);
1232         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1233         bytes memory args = stra2cbor(argN);
1234         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1235     }
1236     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1237         uint price = oraclize.getPrice(datasource, gaslimit);
1238         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1239         bytes memory args = stra2cbor(argN);
1240         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1241     }
1242     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1243         string[] memory dynargs = new string[](1);
1244         dynargs[0] = args[0];
1245         return oraclize_query(datasource, dynargs);
1246     }
1247     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1248         string[] memory dynargs = new string[](1);
1249         dynargs[0] = args[0];
1250         return oraclize_query(timestamp, datasource, dynargs);
1251     }
1252     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1253         string[] memory dynargs = new string[](1);
1254         dynargs[0] = args[0];
1255         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1256     }
1257     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1258         string[] memory dynargs = new string[](1);
1259         dynargs[0] = args[0];
1260         return oraclize_query(datasource, dynargs, gaslimit);
1261     }
1262 
1263     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1264         string[] memory dynargs = new string[](2);
1265         dynargs[0] = args[0];
1266         dynargs[1] = args[1];
1267         return oraclize_query(datasource, dynargs);
1268     }
1269     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1270         string[] memory dynargs = new string[](2);
1271         dynargs[0] = args[0];
1272         dynargs[1] = args[1];
1273         return oraclize_query(timestamp, datasource, dynargs);
1274     }
1275     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1276         string[] memory dynargs = new string[](2);
1277         dynargs[0] = args[0];
1278         dynargs[1] = args[1];
1279         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1280     }
1281     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1282         string[] memory dynargs = new string[](2);
1283         dynargs[0] = args[0];
1284         dynargs[1] = args[1];
1285         return oraclize_query(datasource, dynargs, gaslimit);
1286     }
1287     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1288         string[] memory dynargs = new string[](3);
1289         dynargs[0] = args[0];
1290         dynargs[1] = args[1];
1291         dynargs[2] = args[2];
1292         return oraclize_query(datasource, dynargs);
1293     }
1294     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1295         string[] memory dynargs = new string[](3);
1296         dynargs[0] = args[0];
1297         dynargs[1] = args[1];
1298         dynargs[2] = args[2];
1299         return oraclize_query(timestamp, datasource, dynargs);
1300     }
1301     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1302         string[] memory dynargs = new string[](3);
1303         dynargs[0] = args[0];
1304         dynargs[1] = args[1];
1305         dynargs[2] = args[2];
1306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1307     }
1308     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1309         string[] memory dynargs = new string[](3);
1310         dynargs[0] = args[0];
1311         dynargs[1] = args[1];
1312         dynargs[2] = args[2];
1313         return oraclize_query(datasource, dynargs, gaslimit);
1314     }
1315 
1316     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1317         string[] memory dynargs = new string[](4);
1318         dynargs[0] = args[0];
1319         dynargs[1] = args[1];
1320         dynargs[2] = args[2];
1321         dynargs[3] = args[3];
1322         return oraclize_query(datasource, dynargs);
1323     }
1324     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1325         string[] memory dynargs = new string[](4);
1326         dynargs[0] = args[0];
1327         dynargs[1] = args[1];
1328         dynargs[2] = args[2];
1329         dynargs[3] = args[3];
1330         return oraclize_query(timestamp, datasource, dynargs);
1331     }
1332     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1333         string[] memory dynargs = new string[](4);
1334         dynargs[0] = args[0];
1335         dynargs[1] = args[1];
1336         dynargs[2] = args[2];
1337         dynargs[3] = args[3];
1338         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1339     }
1340     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1341         string[] memory dynargs = new string[](4);
1342         dynargs[0] = args[0];
1343         dynargs[1] = args[1];
1344         dynargs[2] = args[2];
1345         dynargs[3] = args[3];
1346         return oraclize_query(datasource, dynargs, gaslimit);
1347     }
1348     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1349         string[] memory dynargs = new string[](5);
1350         dynargs[0] = args[0];
1351         dynargs[1] = args[1];
1352         dynargs[2] = args[2];
1353         dynargs[3] = args[3];
1354         dynargs[4] = args[4];
1355         return oraclize_query(datasource, dynargs);
1356     }
1357     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1358         string[] memory dynargs = new string[](5);
1359         dynargs[0] = args[0];
1360         dynargs[1] = args[1];
1361         dynargs[2] = args[2];
1362         dynargs[3] = args[3];
1363         dynargs[4] = args[4];
1364         return oraclize_query(timestamp, datasource, dynargs);
1365     }
1366     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1367         string[] memory dynargs = new string[](5);
1368         dynargs[0] = args[0];
1369         dynargs[1] = args[1];
1370         dynargs[2] = args[2];
1371         dynargs[3] = args[3];
1372         dynargs[4] = args[4];
1373         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1374     }
1375     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1376         string[] memory dynargs = new string[](5);
1377         dynargs[0] = args[0];
1378         dynargs[1] = args[1];
1379         dynargs[2] = args[2];
1380         dynargs[3] = args[3];
1381         dynargs[4] = args[4];
1382         return oraclize_query(datasource, dynargs, gaslimit);
1383     }
1384     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1385         uint price = oraclize.getPrice(datasource);
1386         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1387         bytes memory args = ba2cbor(argN);
1388         return oraclize.queryN.value(price)(0, datasource, args);
1389     }
1390     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1391         uint price = oraclize.getPrice(datasource);
1392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1393         bytes memory args = ba2cbor(argN);
1394         return oraclize.queryN.value(price)(timestamp, datasource, args);
1395     }
1396     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1397         uint price = oraclize.getPrice(datasource, gaslimit);
1398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1399         bytes memory args = ba2cbor(argN);
1400         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1401     }
1402     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1403         uint price = oraclize.getPrice(datasource, gaslimit);
1404         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1405         bytes memory args = ba2cbor(argN);
1406         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1407     }
1408     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1409         bytes[] memory dynargs = new bytes[](1);
1410         dynargs[0] = args[0];
1411         return oraclize_query(datasource, dynargs);
1412     }
1413     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1414         bytes[] memory dynargs = new bytes[](1);
1415         dynargs[0] = args[0];
1416         return oraclize_query(timestamp, datasource, dynargs);
1417     }
1418     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1419         bytes[] memory dynargs = new bytes[](1);
1420         dynargs[0] = args[0];
1421         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1422     }
1423     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1424         bytes[] memory dynargs = new bytes[](1);
1425         dynargs[0] = args[0];
1426         return oraclize_query(datasource, dynargs, gaslimit);
1427     }
1428 
1429     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1430         bytes[] memory dynargs = new bytes[](2);
1431         dynargs[0] = args[0];
1432         dynargs[1] = args[1];
1433         return oraclize_query(datasource, dynargs);
1434     }
1435     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1436         bytes[] memory dynargs = new bytes[](2);
1437         dynargs[0] = args[0];
1438         dynargs[1] = args[1];
1439         return oraclize_query(timestamp, datasource, dynargs);
1440     }
1441     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1442         bytes[] memory dynargs = new bytes[](2);
1443         dynargs[0] = args[0];
1444         dynargs[1] = args[1];
1445         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1446     }
1447     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1448         bytes[] memory dynargs = new bytes[](2);
1449         dynargs[0] = args[0];
1450         dynargs[1] = args[1];
1451         return oraclize_query(datasource, dynargs, gaslimit);
1452     }
1453     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1454         bytes[] memory dynargs = new bytes[](3);
1455         dynargs[0] = args[0];
1456         dynargs[1] = args[1];
1457         dynargs[2] = args[2];
1458         return oraclize_query(datasource, dynargs);
1459     }
1460     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1461         bytes[] memory dynargs = new bytes[](3);
1462         dynargs[0] = args[0];
1463         dynargs[1] = args[1];
1464         dynargs[2] = args[2];
1465         return oraclize_query(timestamp, datasource, dynargs);
1466     }
1467     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1468         bytes[] memory dynargs = new bytes[](3);
1469         dynargs[0] = args[0];
1470         dynargs[1] = args[1];
1471         dynargs[2] = args[2];
1472         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1473     }
1474     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1475         bytes[] memory dynargs = new bytes[](3);
1476         dynargs[0] = args[0];
1477         dynargs[1] = args[1];
1478         dynargs[2] = args[2];
1479         return oraclize_query(datasource, dynargs, gaslimit);
1480     }
1481 
1482     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1483         bytes[] memory dynargs = new bytes[](4);
1484         dynargs[0] = args[0];
1485         dynargs[1] = args[1];
1486         dynargs[2] = args[2];
1487         dynargs[3] = args[3];
1488         return oraclize_query(datasource, dynargs);
1489     }
1490     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1491         bytes[] memory dynargs = new bytes[](4);
1492         dynargs[0] = args[0];
1493         dynargs[1] = args[1];
1494         dynargs[2] = args[2];
1495         dynargs[3] = args[3];
1496         return oraclize_query(timestamp, datasource, dynargs);
1497     }
1498     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1499         bytes[] memory dynargs = new bytes[](4);
1500         dynargs[0] = args[0];
1501         dynargs[1] = args[1];
1502         dynargs[2] = args[2];
1503         dynargs[3] = args[3];
1504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1505     }
1506     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1507         bytes[] memory dynargs = new bytes[](4);
1508         dynargs[0] = args[0];
1509         dynargs[1] = args[1];
1510         dynargs[2] = args[2];
1511         dynargs[3] = args[3];
1512         return oraclize_query(datasource, dynargs, gaslimit);
1513     }
1514     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1515         bytes[] memory dynargs = new bytes[](5);
1516         dynargs[0] = args[0];
1517         dynargs[1] = args[1];
1518         dynargs[2] = args[2];
1519         dynargs[3] = args[3];
1520         dynargs[4] = args[4];
1521         return oraclize_query(datasource, dynargs);
1522     }
1523     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1524         bytes[] memory dynargs = new bytes[](5);
1525         dynargs[0] = args[0];
1526         dynargs[1] = args[1];
1527         dynargs[2] = args[2];
1528         dynargs[3] = args[3];
1529         dynargs[4] = args[4];
1530         return oraclize_query(timestamp, datasource, dynargs);
1531     }
1532     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1533         bytes[] memory dynargs = new bytes[](5);
1534         dynargs[0] = args[0];
1535         dynargs[1] = args[1];
1536         dynargs[2] = args[2];
1537         dynargs[3] = args[3];
1538         dynargs[4] = args[4];
1539         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1540     }
1541     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1542         bytes[] memory dynargs = new bytes[](5);
1543         dynargs[0] = args[0];
1544         dynargs[1] = args[1];
1545         dynargs[2] = args[2];
1546         dynargs[3] = args[3];
1547         dynargs[4] = args[4];
1548         return oraclize_query(datasource, dynargs, gaslimit);
1549     }
1550 
1551     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1552         return oraclize.cbAddress();
1553     }
1554     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1555         return oraclize.setProofType(proofP);
1556     }
1557     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1558         return oraclize.setCustomGasPrice(gasPrice);
1559     }
1560     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1561         return oraclize.setConfig(config);
1562     }
1563 
1564     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1565         return oraclize.randomDS_getSessionPubKeyHash();
1566     }
1567 
1568     function getCodeSize(address _addr) constant internal returns(uint _size) {
1569         assembly {
1570             _size := extcodesize(_addr)
1571         }
1572     }
1573 
1574     function parseAddr(string _a) internal returns (address){
1575         bytes memory tmp = bytes(_a);
1576         uint160 iaddr = 0;
1577         uint160 b1;
1578         uint160 b2;
1579         for (uint i=2; i<2+2*20; i+=2){
1580             iaddr *= 256;
1581             b1 = uint160(tmp[i]);
1582             b2 = uint160(tmp[i+1]);
1583             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1584             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1585             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1586             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1587             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1588             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1589             iaddr += (b1*16+b2);
1590         }
1591         return address(iaddr);
1592     }
1593 
1594     function strCompare(string _a, string _b) internal returns (int) {
1595         bytes memory a = bytes(_a);
1596         bytes memory b = bytes(_b);
1597         uint minLength = a.length;
1598         if (b.length < minLength) minLength = b.length;
1599         for (uint i = 0; i < minLength; i ++)
1600             if (a[i] < b[i])
1601                 return -1;
1602             else if (a[i] > b[i])
1603                 return 1;
1604         if (a.length < b.length)
1605             return -1;
1606         else if (a.length > b.length)
1607             return 1;
1608         else
1609             return 0;
1610     }
1611 
1612     function indexOf(string _haystack, string _needle) internal returns (int) {
1613         bytes memory h = bytes(_haystack);
1614         bytes memory n = bytes(_needle);
1615         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1616             return -1;
1617         else if(h.length > (2**128 -1))
1618             return -1;
1619         else
1620         {
1621             uint subindex = 0;
1622             for (uint i = 0; i < h.length; i ++)
1623             {
1624                 if (h[i] == n[0])
1625                 {
1626                     subindex = 1;
1627                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1628                     {
1629                         subindex++;
1630                     }
1631                     if(subindex == n.length)
1632                         return int(i);
1633                 }
1634             }
1635             return -1;
1636         }
1637     }
1638 
1639     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1640         bytes memory _ba = bytes(_a);
1641         bytes memory _bb = bytes(_b);
1642         bytes memory _bc = bytes(_c);
1643         bytes memory _bd = bytes(_d);
1644         bytes memory _be = bytes(_e);
1645         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1646         bytes memory babcde = bytes(abcde);
1647         uint k = 0;
1648         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1649         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1650         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1651         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1652         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1653         return string(babcde);
1654     }
1655 
1656     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1657         return strConcat(_a, _b, _c, _d, "");
1658     }
1659 
1660     function strConcat(string _a, string _b, string _c) internal returns (string) {
1661         return strConcat(_a, _b, _c, "", "");
1662     }
1663 
1664     function strConcat(string _a, string _b) internal returns (string) {
1665         return strConcat(_a, _b, "", "", "");
1666     }
1667 
1668     // parseInt
1669     function parseInt(string _a) internal returns (uint) {
1670         return parseInt(_a, 0);
1671     }
1672 
1673     // parseInt(parseFloat*10^_b)
1674     function parseInt(string _a, uint _b) internal returns (uint) {
1675         bytes memory bresult = bytes(_a);
1676         uint mint = 0;
1677         bool decimals = false;
1678         for (uint i=0; i<bresult.length; i++){
1679             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1680                 if (decimals){
1681                    if (_b == 0) break;
1682                     else _b--;
1683                 }
1684                 mint *= 10;
1685                 mint += uint(bresult[i]) - 48;
1686             } else if (bresult[i] == 46) decimals = true;
1687         }
1688         if (_b > 0) mint *= 10**_b;
1689         return mint;
1690     }
1691 
1692     function uint2str(uint i) internal returns (string){
1693         if (i == 0) return "0";
1694         uint j = i;
1695         uint len;
1696         while (j != 0){
1697             len++;
1698             j /= 10;
1699         }
1700         bytes memory bstr = new bytes(len);
1701         uint k = len - 1;
1702         while (i != 0){
1703             bstr[k--] = byte(48 + i % 10);
1704             i /= 10;
1705         }
1706         return string(bstr);
1707     }
1708 
1709     using CBOR for Buffer.buffer;
1710     function stra2cbor(string[] arr) internal constant returns (bytes) {
1711         safeMemoryCleaner();
1712         Buffer.buffer memory buf;
1713         Buffer.init(buf, 1024);
1714         buf.startArray();
1715         for (uint i = 0; i < arr.length; i++) {
1716             buf.encodeString(arr[i]);
1717         }
1718         buf.endSequence();
1719         return buf.buf;
1720     }
1721 
1722     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1723         safeMemoryCleaner();
1724         Buffer.buffer memory buf;
1725         Buffer.init(buf, 1024);
1726         buf.startArray();
1727         for (uint i = 0; i < arr.length; i++) {
1728             buf.encodeBytes(arr[i]);
1729         }
1730         buf.endSequence();
1731         return buf.buf;
1732     }
1733 
1734     string oraclize_network_name;
1735     function oraclize_setNetworkName(string _network_name) internal {
1736         oraclize_network_name = _network_name;
1737     }
1738 
1739     function oraclize_getNetworkName() internal returns (string) {
1740         return oraclize_network_name;
1741     }
1742 
1743     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1744         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1745 	// Convert from seconds to ledger timer ticks
1746         _delay *= 10;
1747         bytes memory nbytes = new bytes(1);
1748         nbytes[0] = byte(_nbytes);
1749         bytes memory unonce = new bytes(32);
1750         bytes memory sessionKeyHash = new bytes(32);
1751         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1752         assembly {
1753             mstore(unonce, 0x20)
1754             // the following variables can be relaxed
1755             // check relaxed random contract under ethereum-examples repo
1756             // for an idea on how to override and replace comit hash vars
1757             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1758             mstore(sessionKeyHash, 0x20)
1759             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1760         }
1761         bytes memory delay = new bytes(32);
1762         assembly {
1763             mstore(add(delay, 0x20), _delay)
1764         }
1765 
1766         bytes memory delay_bytes8 = new bytes(8);
1767         copyBytes(delay, 24, 8, delay_bytes8, 0);
1768 
1769         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1770         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1771 
1772         bytes memory delay_bytes8_left = new bytes(8);
1773 
1774         assembly {
1775             let x := mload(add(delay_bytes8, 0x20))
1776             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1777             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1778             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1779             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1780             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1781             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1782             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1783             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1784 
1785         }
1786 
1787         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1788         return queryId;
1789     }
1790 
1791     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1792         oraclize_randomDS_args[queryId] = commitment;
1793     }
1794 
1795     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1796     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1797 
1798     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1799         bool sigok;
1800         address signer;
1801 
1802         bytes32 sigr;
1803         bytes32 sigs;
1804 
1805         bytes memory sigr_ = new bytes(32);
1806         uint offset = 4+(uint(dersig[3]) - 0x20);
1807         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1808         bytes memory sigs_ = new bytes(32);
1809         offset += 32 + 2;
1810         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1811 
1812         assembly {
1813             sigr := mload(add(sigr_, 32))
1814             sigs := mload(add(sigs_, 32))
1815         }
1816 
1817 
1818         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1819         if (address(sha3(pubkey)) == signer) return true;
1820         else {
1821             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1822             return (address(sha3(pubkey)) == signer);
1823         }
1824     }
1825 
1826     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1827         bool sigok;
1828 
1829         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1830         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1831         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1832 
1833         bytes memory appkey1_pubkey = new bytes(64);
1834         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1835 
1836         bytes memory tosign2 = new bytes(1+65+32);
1837         tosign2[0] = 1; //role
1838         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1839         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1840         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1841         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1842 
1843         if (sigok == false) return false;
1844 
1845 
1846         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1847         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1848 
1849         bytes memory tosign3 = new bytes(1+65);
1850         tosign3[0] = 0xFE;
1851         copyBytes(proof, 3, 65, tosign3, 1);
1852 
1853         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1854         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1855 
1856         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1857 
1858         return sigok;
1859     }
1860 
1861     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1862         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1863         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1864 
1865         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1866         if (proofVerified == false) throw;
1867 
1868         _;
1869     }
1870 
1871     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1872         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1873         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1874 
1875         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1876         if (proofVerified == false) return 2;
1877 
1878         return 0;
1879     }
1880 
1881     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1882         bool match_ = true;
1883 
1884 	if (prefix.length != n_random_bytes) throw;
1885 
1886         for (uint256 i=0; i< n_random_bytes; i++) {
1887             if (content[i] != prefix[i]) match_ = false;
1888         }
1889 
1890         return match_;
1891     }
1892 
1893     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1894 
1895         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1896         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1897         bytes memory keyhash = new bytes(32);
1898         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1899         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1900 
1901         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1902         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1903 
1904         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1905         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1906 
1907         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1908         // This is to verify that the computed args match with the ones specified in the query.
1909         bytes memory commitmentSlice1 = new bytes(8+1+32);
1910         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1911 
1912         bytes memory sessionPubkey = new bytes(64);
1913         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1914         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1915 
1916         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1917         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1918             delete oraclize_randomDS_args[queryId];
1919         } else return false;
1920 
1921 
1922         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1923         bytes memory tosign1 = new bytes(32+8+1+32);
1924         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1925         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1926 
1927         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1928         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1929             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1930         }
1931 
1932         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1933     }
1934 
1935 
1936     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1937     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1938         uint minLength = length + toOffset;
1939 
1940         if (to.length < minLength) {
1941             // Buffer too small
1942             throw; // Should be a better way?
1943         }
1944 
1945         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1946         uint i = 32 + fromOffset;
1947         uint j = 32 + toOffset;
1948 
1949         while (i < (32 + fromOffset + length)) {
1950             assembly {
1951                 let tmp := mload(add(from, i))
1952                 mstore(add(to, j), tmp)
1953             }
1954             i += 32;
1955             j += 32;
1956         }
1957 
1958         return to;
1959     }
1960 
1961     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1962     // Duplicate Solidity's ecrecover, but catching the CALL return value
1963     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1964         // We do our own memory management here. Solidity uses memory offset
1965         // 0x40 to store the current end of memory. We write past it (as
1966         // writes are memory extensions), but don't update the offset so
1967         // Solidity will reuse it. The memory used here is only needed for
1968         // this context.
1969 
1970         // FIXME: inline assembly can't access return values
1971         bool ret;
1972         address addr;
1973 
1974         assembly {
1975             let size := mload(0x40)
1976             mstore(size, hash)
1977             mstore(add(size, 32), v)
1978             mstore(add(size, 64), r)
1979             mstore(add(size, 96), s)
1980 
1981             // NOTE: we can reuse the request memory because we deal with
1982             //       the return code
1983             ret := call(3000, 1, 0, size, 128, size, 32)
1984             addr := mload(size)
1985         }
1986 
1987         return (ret, addr);
1988     }
1989 
1990     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1991     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1992         bytes32 r;
1993         bytes32 s;
1994         uint8 v;
1995 
1996         if (sig.length != 65)
1997           return (false, 0);
1998 
1999         // The signature format is a compact form of:
2000         //   {bytes32 r}{bytes32 s}{uint8 v}
2001         // Compact means, uint8 is not padded to 32 bytes.
2002         assembly {
2003             r := mload(add(sig, 32))
2004             s := mload(add(sig, 64))
2005 
2006             // Here we are loading the last 32 bytes. We exploit the fact that
2007             // 'mload' will pad with zeroes if we overread.
2008             // There is no 'mload8' to do this, but that would be nicer.
2009             v := byte(0, mload(add(sig, 96)))
2010 
2011             // Alternative solution:
2012             // 'byte' is not working due to the Solidity parser, so lets
2013             // use the second best option, 'and'
2014             // v := and(mload(add(sig, 65)), 255)
2015         }
2016 
2017         // albeit non-transactional signatures are not specified by the YP, one would expect it
2018         // to match the YP range of [27, 28]
2019         //
2020         // geth uses [0, 1] and some clients have followed. This might change, see:
2021         //  https://github.com/ethereum/go-ethereum/issues/2053
2022         if (v < 27)
2023           v += 27;
2024 
2025         if (v != 27 && v != 28)
2026             return (false, 0);
2027 
2028         return safer_ecrecover(hash, v, r, s);
2029     }
2030 
2031     function safeMemoryCleaner() internal constant {
2032         assembly {
2033             let fmem := mload(0x40)
2034             codecopy(fmem, codesize, sub(msize, fmem))
2035         }
2036     }
2037 }
2038 // </ORACLIZE_API>
2039 
2040 /**
2041  * @title SafeMath
2042  * @dev Math operations with safety checks that throw on error
2043  */
2044 library SafeMathLib{
2045   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2046     uint256 c = a * b;
2047     assert(a == 0 || c / a == b);
2048     return c;
2049   }
2050 
2051   function div(uint256 a, uint256 b) internal pure returns (uint256) {
2052     // assert(b > 0); // Solidity automatically throws when dividing by 0
2053     uint256 c = a / b;
2054     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2055     return c;
2056   }
2057 
2058   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2059     assert(b <= a);
2060     return a - b;
2061   }
2062   
2063   function add(uint256 a, uint256 b) internal pure returns (uint256) {
2064     uint256 c = a + b;
2065     assert(c >= a);
2066     return c;
2067   }
2068 }
2069 
2070 contract ERC20Interface {
2071 
2072     function totalSupply() public constant returns (uint);
2073     function balanceOf(address tokenOwner) public constant returns (uint balance);
2074     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
2075     function transfer(address to, uint tokens) public returns (bool success);
2076     function approve(address spender, uint tokens) public returns (bool success);
2077     function transferFrom(address from, address to, uint tokens) public returns (bool success);
2078 
2079     event Transfer(address indexed from, address indexed to, uint tokens);
2080     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
2081 
2082 }
2083 
2084 contract BankI {
2085     function transfer(address _to, uint256 _value, bool _isCoin) external returns (bool success);
2086 }
2087 
2088 contract UserDataI {
2089     function modifyHoldings(address _beneficiary, uint256[] _cryptoIds, uint256[] _amounts, bool _buy) external;
2090 }
2091 
2092 library InvestLib {
2093 
2094     using SafeMathLib for uint256;
2095     using strings for *;
2096 
2097     /**
2098      * @dev Calculate the COIN value of the cryptos to be bought/sold.
2099      * @param _amounts The amount (in 10 ** 18) of the cryptos being bought.
2100      * @param _cryptoValues The value of the cryptos at time of call.
2101     **/
2102     function calculateValue(uint256[] memory _amounts, uint256[] memory _cryptoValues)
2103       public
2104       pure
2105     returns (uint256 value)
2106     {
2107         for (uint256 i = 0; i < _amounts.length; i++) {
2108             value = value.add(_cryptoValues[i+1].mul(_amounts[i]).div(_cryptoValues[0]));
2109         }
2110     }
2111     
2112     /**
2113      * @dev Converts given cryptos and amounts into a single uint256[] array.
2114      * @param _cryptos Array of the crypto Ids to be bought.
2115      * @param _amounts Array containing the amounts of each crypto to buy.
2116     **/
2117     function bitConv(uint256[] memory _cryptos, uint256[] memory _amounts)
2118       internal
2119       pure
2120     returns (uint256[] memory combined)
2121     {
2122         combined = new uint256[](_cryptos.length); 
2123         for (uint256 i = 0; i < _cryptos.length; i++) {
2124             combined[i] = _cryptos[i];
2125             combined[i] |= _amounts[i] << 8;
2126         }
2127         return combined;
2128     }
2129     
2130     /**
2131      * @dev Recovers the cryptos and amounts from combined array.
2132      * @param _idsAndAmts Array of uints containing both crypto Id and amount.
2133     **/
2134     function bitRec(uint256[] memory _idsAndAmts) 
2135       public
2136       pure
2137     returns (uint256[] memory cryptos, uint256[] memory amounts) 
2138     {
2139         cryptos = new uint256[](_idsAndAmts.length);
2140         amounts = new uint256[](_idsAndAmts.length);
2141 
2142         for (uint256 i = 0; i < _idsAndAmts.length; i++) {
2143             cryptos[i] = uint256(uint8(_idsAndAmts[i]));
2144             amounts[i] = uint256(uint248(_idsAndAmts[i] >> 8));
2145         }
2146         return (cryptos, amounts);
2147     }
2148 
2149     /**
2150      * @dev Cycles through a list of separators to split the api
2151      * @dev result string. Returns list so that we can update invest contract with values.
2152      * @param _cryptos The cryptoIds being decoded.
2153      * @param _result The raw string returned from the cryptocompare api with all crypto prices.
2154      * @param _isCoin True/False of the crypto that is being used to invest is COIN/CASH.
2155     **/
2156     function decodePrices(uint256[] memory _cryptos, string memory _result, bool _isCoin) 
2157       public
2158       view
2159     returns (uint256[] memory prices)
2160     {
2161         strings.slice memory s = _result.toSlice();
2162         strings.slice memory delim = 'USD'.toSlice();
2163         s.split(delim).toString();
2164 
2165         prices = new uint256[](_cryptos.length + 1);
2166         
2167         //Find price of COIN first.
2168         string memory coinPart = s.split(delim).toString();
2169         prices[0] = parseInt(coinPart,18);
2170 
2171         // Each crypto is advanced one in the prices array because COIN/CASH is index 0.
2172         for(uint256 i = 0; i < _cryptos.length; i++) {
2173             uint256 crypto = _cryptos[i];
2174             bool isInverse = crypto % 2 > 0;
2175             
2176             // This loop is necessary because cryptocompare will only return 1 value when the same crypto is queried twice (in case of inverse).
2177             for (uint256 j = 0; j < _cryptos.length; j++) {
2178                 if (j == i) break;
2179                 if ((isInverse && _cryptos[j] == crypto - 1) || (!isInverse && _cryptos[j] == crypto + 1)) {
2180                     prices[i+1] = (10 ** 36) / prices[j+1];
2181                     break;
2182                 }
2183             }
2184             
2185             // If the crypto is COIN or CASH buying itself we don't want it to split price (because CryptoCompare will only return the first query)
2186             if ((prices[i+1] == 0 && _isCoin && (crypto == 0 || crypto == 1)) ||
2187                 (prices[i+1] == 0 && !_isCoin && (crypto == 2 || crypto == 3))) {
2188                 
2189                 if (!isInverse) prices[i+1] = prices[0];
2190                 else prices[i+1] = (10 ** 36) / prices[0];
2191             }
2192 
2193             // Normal cases
2194             else if (prices[i+1] == 0) {
2195                 string memory part = s.split(delim).toString();
2196         
2197                 uint256 price = parseInt(part,18);
2198                 if (price > 0 && !isInverse) prices[i+1] = price;
2199                 else if (price > 0) prices[i+1] = (10 ** 36) / price;
2200             }
2201         }
2202 
2203         // Final check in case anything goes wrong.
2204         for (uint256 k = 0; k < prices.length; k++) require(prices[k] > 0);
2205         return prices;
2206     }
2207 
2208     /**
2209      * @dev decodePrices needs to use these functions from the Oraclize contract.
2210     **/
2211     // parseInt
2212     function parseInt(string _a) internal returns (uint) {
2213         return parseInt(_a, 0);
2214     }
2215 
2216     // parseInt(parseFloat*10^_b)
2217     function parseInt(string _a, uint _b) internal returns (uint) {
2218         bytes memory bresult = bytes(_a);
2219         uint mint = 0;
2220         bool decimals = false;
2221         for (uint i=0; i<bresult.length; i++){
2222             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
2223                 if (decimals){
2224                    if (_b == 0) break;
2225                     else _b--;
2226                 }
2227                 mint *= 10;
2228                 mint += uint(bresult[i]) - 48;
2229             } else if (bresult[i] == 46) decimals = true;
2230         }
2231         if (_b > 0) mint *= 10**_b;
2232         return mint;
2233     }
2234 
2235 
2236 }
2237 
2238 contract Investment is Ownable, usingOraclize { 
2239 
2240     using SafeMathLib for uint256;
2241     using strings for *;
2242     using InvestLib for *;
2243     
2244     BankI public bank;
2245     UserDataI public userData;
2246     
2247     address public coinToken;
2248     address public cashToken;
2249     uint256 public customGasPrice;
2250     string public coinUrl = "http://ec2-18-234-124-53.compute-1.amazonaws.com/api/priceTest?cryptos=COIN,";
2251     string public cashUrl = "";
2252     bool public paused;
2253     
2254     uint256 public constant COIN_ID = 0;
2255     uint256 public constant COIN_INV = 1;
2256     uint256 public constant CASH_ID = 2;
2257     uint256 public constant CASH_INV = 3;
2258     
2259     // Stores all trade info so Oraclize can return and update.
2260     // idsAndAmts stores both the crypto ID and amounts with a uint8 and uint248 respectively.
2261     struct TradeInfo {
2262         bool isBuy;
2263         bool isCoin;
2264         address beneficiary;
2265         uint256[] idsAndAmts;
2266     }
2267     
2268     // Oraclize ID => TradeInfo.
2269     mapping(bytes32 => TradeInfo) trades;
2270 
2271     // Even indices are normal cryptos, odd are inverses--empty string if either does not exist.
2272     string[] public cryptoSymbols;
2273 
2274     // Balance of a user's free trades.
2275     mapping(address => uint256) public freeTrades;
2276 
2277     event newOraclizeQuery(string description, bytes32 txHash, bytes32 queryId);
2278     event Buy(
2279               bytes32 indexed queryId, 
2280               address indexed buyer, 
2281               uint256[] cryptoIds, 
2282               uint256[] amounts, 
2283               uint256[] prices, 
2284               bool isCoin
2285               );
2286               
2287     event Sell(
2288                bytes32 indexed queryId, 
2289                address indexed seller, 
2290                uint256[] cryptoIds, 
2291                uint256[] amounts, 
2292                uint256[] prices, 
2293                bool isCoin
2294                );
2295 
2296 /** ********************************** Defaults ************************************* **/
2297     
2298     /**
2299      * @dev Constructor function, construct with coinvest token.
2300      * @param _coinToken The address of the Coinvest COIN token.
2301      * @param _cashToken Address of the Coinvest CASH token.
2302      * @param _bank Contract where all of the user Coinvest tokens will be stored.
2303      * @param _userData Contract where all of the user balances will be stored.
2304     **/
2305     constructor(address _coinToken, address _cashToken, address _bank, address _userData)
2306       public
2307       payable
2308     {
2309         coinToken = _coinToken;
2310         cashToken = _cashToken;
2311         bank = BankI(_bank);
2312         userData = UserDataI(_userData);
2313 
2314         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
2315         
2316         addCrypto(0, "COIN,", false);
2317         addCrypto(0, "", false);
2318         addCrypto(0, "BTC,", false);
2319         addCrypto(0, "ETH,", false);
2320         addCrypto(0, "XRP,", false);
2321         addCrypto(0, "LTC,", false);
2322         addCrypto(0, "DASH,", false);
2323         addCrypto(0, "BCH,", false);
2324         addCrypto(0, "XMR,", false);
2325         addCrypto(0, "XEM,", false);
2326         addCrypto(0, "EOS,", false);
2327         
2328         customGasPrice = 5000000000;
2329         oraclize_setCustomGasPrice(customGasPrice);
2330     }
2331   
2332     /**
2333      * @dev Used by Coinvest-associated wallets to fund the contract.
2334             Users may also pay within a buy or sell call if no funds are available.
2335     **/
2336     function()
2337       external
2338       payable
2339       onlyAdmin
2340     {
2341         
2342     }
2343   
2344 /** *************************** ApproveAndCall FallBack **************************** **/
2345   
2346     /**
2347      * @dev ApproveAndCall will send us data, we'll determine if the beneficiary is the sender, then we'll call this contract.
2348     **/
2349     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) 
2350       public
2351     {
2352         require(msg.sender == coinToken || msg.sender == cashToken);
2353 
2354         // check here to make sure _from == beneficiary in data
2355         address beneficiary;
2356         assembly {
2357             beneficiary := mload(add(_data,36))
2358         }
2359         require(_from == beneficiary);
2360         
2361         address(this).delegatecall(_data);
2362         _token; _amount;
2363     }
2364   
2365 /** ********************************** External ************************************* **/
2366     
2367     /**
2368      * @dev User calls to invest, will then call Oraclize and Oraclize adds holdings.
2369      * @dev User must first approve this contract to transfer enough tokens to buy.
2370      * @param _beneficiary The user making the call whose balance will be updated.
2371      * @param _cryptoIds The Ids of the cryptos to invest in.
2372      * @param _amounts The amount of each crypto the user wants to buy, delineated in 10 ^ 18 wei.
2373      * @param _isCoin True/False of the crypto that is being used to invest is COIN/CASH.
2374     **/
2375     function buy(
2376         address _beneficiary, 
2377         uint256[] _cryptoIds, 
2378         uint256[] _amounts, 
2379         bool _isCoin)
2380       public
2381       payable
2382       notPaused
2383       onlySenderOrToken(_beneficiary)
2384     {
2385         require(_cryptoIds.length == _amounts.length);
2386         getPrices(_beneficiary, _cryptoIds, _amounts, _isCoin, true);
2387     }
2388     
2389     function sell(
2390         address _beneficiary, 
2391         uint256[] _cryptoIds, 
2392         uint256[] _amounts, 
2393         bool _isCoin)
2394       public
2395       payable
2396       notPaused
2397       onlySenderOrToken(_beneficiary)
2398     {
2399         require(_cryptoIds.length == _amounts.length);
2400         getPrices(_beneficiary, _cryptoIds, _amounts, _isCoin, false);
2401     }
2402     
2403 /** ********************************** Internal ************************************ **/
2404     
2405     /**
2406      * @dev Broker will call this for an investor to invest in one or multiple assets
2407      * @param _beneficiary The address that is being bought for
2408      * @param _cryptoIds The list of uint IDs for each crypto to buy
2409      * @param _amounts The amounts of each crypto to buy (measured in 10 ** 18 wei!)
2410      * @param _prices The price of each bought crypto at time of callback.
2411      * @param _coinValue The amount of coin to transferFrom from user.
2412      * @param _isCoin True/False of the crypto that is being used to invest is COIN/CASH.
2413     **/
2414     function finalizeBuy(
2415         address _beneficiary, 
2416         uint256[] memory _cryptoIds, 
2417         uint256[] memory _amounts, 
2418         uint256[] memory _prices, 
2419         uint256 _coinValue,
2420         bool _isCoin,
2421         bytes32 myid
2422         )
2423       internal
2424     {
2425         ERC20Interface token;
2426         if (_isCoin) token = ERC20Interface(coinToken);
2427         else token = ERC20Interface(cashToken);
2428 
2429         uint256 fee = 4990000000000000000 * (10 ** 18) / _prices[0];
2430         if (freeTrades[_beneficiary] >  0) freeTrades[_beneficiary] = freeTrades[_beneficiary].sub(1);
2431         else require(token.transferFrom(_beneficiary, coinvest, fee));
2432         
2433         require(token.transferFrom(_beneficiary, bank, _coinValue));
2434 
2435         // We want to allow actual COIN/CASH exchange so users have easy access and we can "CASH" out fees
2436         if (_cryptoIds[0] == COIN_ID && _cryptoIds.length == 1) {
2437             require(bank.transfer(_beneficiary, _amounts[0], true));
2438         } else if (_cryptoIds[0] == CASH_ID && _cryptoIds.length == 1) {
2439             require(bank.transfer(_beneficiary, _amounts[0], false));
2440         } else {
2441             userData.modifyHoldings(_beneficiary, _cryptoIds, _amounts, true);
2442         }
2443 
2444         emit Buy(myid, _beneficiary, _cryptoIds, _amounts, _prices, _isCoin);
2445     }
2446     
2447     /**
2448      * @param _beneficiary The address that is being sold for
2449      * @param _cryptoIds The list of uint IDs for each crypto
2450      * @param _amounts The amounts of each crypto to sell (measured in 10 ** 18 wei!)
2451      * @param _prices The prices of each crypto at time of callback.
2452      * @param _coinValue The amount of COIN to be transferred to user.
2453      * @param _isCoin True/False of the crypto that is being used to invest is COIN/CASH.
2454     **/
2455     function finalizeSell(
2456         address _beneficiary, 
2457         uint256[] memory _cryptoIds, 
2458         uint256[] memory _amounts, 
2459         uint256[] memory _prices, 
2460         uint256 _coinValue, 
2461         bool _isCoin,
2462         bytes32 myid
2463         )
2464       internal
2465     {   
2466         uint256 fee = 4990000000000000000 * (10 ** 18) / _prices[0];
2467         if (freeTrades[_beneficiary] > 0) freeTrades[_beneficiary] = freeTrades[_beneficiary].sub(1);
2468         else {
2469             require(_coinValue > fee);
2470             require(bank.transfer(coinvest, fee, _isCoin));
2471             _coinValue = _coinValue.sub(fee);
2472         }
2473 
2474         require(bank.transfer(_beneficiary, _coinValue, _isCoin));
2475         
2476         // Subtract from balance of each held crypto for user.
2477         userData.modifyHoldings(_beneficiary, _cryptoIds, _amounts, false);
2478         
2479         emit Sell(myid, _beneficiary, _cryptoIds, _amounts, _prices, _isCoin);
2480     }
2481     
2482 /** ******************************** Only Owner ************************************* **/
2483     
2484     /**
2485      * @dev Owner may add a crypto to the investment contract.
2486      * @param _index Id of the crypto if an old one is being altered, 0 if new crypto is to be added.
2487      * @param _symbol Symbol of the new crypto.
2488      * @param _inverse Whether or not an inverse should be added following a pushed crypto.
2489     **/
2490     function addCrypto(uint256 _index, string memory _symbol, bool _inverse)
2491       public
2492       onlyOwner
2493     {
2494         // If a used index is to be changed, only alter that symbol.
2495         if (_index > 0) {
2496             cryptoSymbols[_index] = _symbol;
2497         } else { // If we are adding a new symbol, push either the symbol or blank string after.
2498             cryptoSymbols.push(_symbol);
2499             if (_inverse) cryptoSymbols.push(_symbol);
2500             else cryptoSymbols.push("");
2501         }
2502     }
2503     
2504     /**
2505      * @dev Allows Coinvest to reward users with free platform trades.
2506      * @param _users List of users to reward.
2507      * @param _trades List of free trades to give to each.
2508     **/
2509     function addTrades(address[] _users, uint256[] _trades)
2510       external
2511       onlyAdmin
2512     {
2513         require(_users.length == _trades.length);
2514         for (uint256 i = 0; i < _users.length; i++) {
2515             freeTrades[_users[i]] = _trades[i];
2516         }     
2517     }
2518     
2519     /**
2520      * @dev We were having gas problems on launch so we consolidated here. Will clean up soon.
2521     **/
2522     function changeVars(
2523         address _coinToken, 
2524         address _cashToken, 
2525         address _bank, 
2526         address _userData,
2527         string _coinUrl,
2528         string _cashUrl,
2529         bool _paused)
2530       external
2531       onlyOwner
2532     {
2533         coinToken = _coinToken;
2534         cashToken = _cashToken;
2535         bank = BankI(_bank);
2536         userData = UserDataI(_userData);
2537         coinUrl = _coinUrl;
2538         cashUrl = _cashUrl;
2539         paused = _paused;
2540     }
2541     
2542     /**
2543      * @dev Change Oraclize gas limit and price.
2544      * @param _newGasPrice New gas price to use in wei.
2545     **/
2546     function changeGas(uint256 _newGasPrice)
2547       external
2548       onlyAdmin
2549     returns (bool success)
2550     {
2551         customGasPrice = _newGasPrice;
2552         oraclize_setCustomGasPrice(_newGasPrice);
2553         return true;
2554     }
2555 
2556 /** ********************************* Modifiers ************************************* **/
2557     
2558     /**
2559      * @dev For buys and sells we only want an approved broker or the buyer/seller
2560      * @dev themselves to mess with the buyer/seller's portfolio
2561      * @param _beneficiary The buyer or seller whose portfolio is being modified
2562     **/
2563     modifier onlySenderOrToken(address _beneficiary)
2564     {
2565         require(msg.sender == _beneficiary || msg.sender == coinToken || msg.sender == cashToken);
2566         _;
2567     }
2568     
2569     /**
2570      * @dev Ensures the contract cannot be used if Coinvest pauses it.
2571     **/
2572     modifier notPaused()
2573     {
2574         require(!paused);
2575         _;
2576     }
2577     
2578 /** ******************************************************************************** **/
2579 /** ******************************* Oracle Logic *********************************** **/
2580 /** ******************************************************************************** **/
2581 
2582     /**
2583      * @dev Here we Oraclize to CryptoCompare to get prices for these cryptos.
2584      * @param _beneficiary The user who is executing the buy or sell.
2585      * @param _cryptos The IDs of the cryptos to get prices for.
2586      * @param _amounts Amount of each crypto to buy.
2587      * @param _isCoin True/False of the crypto that is being used to invest is COIN/CASH.
2588      * @param _buy Whether or not this is a buy (as opposed to sell).
2589     **/
2590     function getPrices(
2591         address _beneficiary, 
2592         uint256[] memory _cryptos, 
2593         uint256[] memory _amounts, 
2594         bool _isCoin, 
2595         bool _buy) 
2596       internal
2597     {
2598         bytes32 txHash = keccak256(abi.encodePacked(_beneficiary, _cryptos, _amounts, _isCoin, _buy));
2599         if (oraclize_getPrice("URL") > address(this).balance) {
2600             emit newOraclizeQuery("Oraclize query was NOT sent", '0x0', '0x0');
2601         } else {
2602             string memory fullUrl = craftUrl(_cryptos, _isCoin);
2603             bytes32 queryId = oraclize_query("URL", fullUrl, 150000 + 40000 * _cryptos.length);
2604             trades[queryId] = TradeInfo(_buy, _isCoin, _beneficiary, InvestLib.bitConv(_cryptos, _amounts));
2605             emit newOraclizeQuery("Oraclize query was sent", txHash, queryId);
2606         }
2607     }
2608     
2609     /**
2610      * @dev Oraclize calls and should simply set the query array to the int results.
2611      * @param myid Unique ID of the Oraclize query, index for save idsAndAmts.
2612      * @param result JSON string of CryptoCompare's return.
2613      * @param proof Proof of validity of the Oracle call--not used.
2614     **/
2615     function __callback(bytes32 myid, string result, bytes proof)
2616       public
2617     {
2618         require(msg.sender == oraclize_cbAddress());
2619 
2620         TradeInfo memory tradeInfo = trades[myid];
2621         (uint256[] memory cryptos, uint256[] memory amounts) = InvestLib.bitRec(tradeInfo.idsAndAmts);
2622 
2623         bool isCoin = tradeInfo.isCoin;
2624         uint256[] memory cryptoValues = InvestLib.decodePrices(cryptos, result, isCoin);
2625         uint256 value = InvestLib.calculateValue(amounts, cryptoValues);
2626         
2627         if (tradeInfo.isBuy) finalizeBuy(tradeInfo.beneficiary, cryptos, amounts, cryptoValues, value, isCoin, myid);
2628         else finalizeSell(tradeInfo.beneficiary, cryptos, amounts, cryptoValues, value, isCoin, myid);
2629         
2630         delete trades[myid];
2631         proof;
2632     }
2633     
2634 /** ******************************* Constants ************************************ **/
2635     
2636     /**
2637      * @dev Crafts URL for Oraclize to grab data from.
2638      * @param _cryptos The uint256 crypto ID of the cryptos to search.
2639      * @param _isCoin True if COIN is being used as the investment token.
2640     **/
2641     function craftUrl(uint256[] memory _cryptos, bool _isCoin)
2642       public
2643       view
2644     returns (string memory url)
2645     {
2646         if (_isCoin) url = coinUrl;
2647         else url = cashUrl;
2648 
2649         for (uint256 i = 0; i < _cryptos.length; i++) {
2650             uint256 id = _cryptos[i];
2651 
2652             // This loop ensures only one of each crypto is being bought.
2653             for (uint256 j = 0; j < _cryptos.length; j++) {
2654                 if (i == j) break;
2655                 require(id != _cryptos[j]);
2656             }
2657 
2658             require(bytes(cryptoSymbols[id]).length > 0);
2659             url = url.toSlice().concat(cryptoSymbols[id].toSlice());
2660         }
2661         return url;
2662     }
2663     
2664 /** ************************** Only Coinvest ******************************* **/
2665 
2666     /**
2667      * @dev Allow the owner to take ERC20 tokens off of this contract if they are accidentally sent.
2668      * @param _tokenContract The address of the token to withdraw (0x0 if Ether).
2669      * @param _amount The amount of Ether to withdraw (because some needs to be left for Oraclize).
2670     **/
2671     function tokenEscape(address _tokenContract, uint256 _amount)
2672       external
2673       coinvestOrOwner
2674     {
2675         if (_tokenContract == address(0)) coinvest.transfer(_amount);
2676         else {
2677             ERC20Interface lostToken = ERC20Interface(_tokenContract);
2678             uint256 stuckTokens = lostToken.balanceOf(address(this));
2679             lostToken.transfer(coinvest, stuckTokens);
2680         }
2681     }
2682 
2683 }