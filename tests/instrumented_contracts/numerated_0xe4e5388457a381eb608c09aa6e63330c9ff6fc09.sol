1 pragma solidity ^0.4.8;
2 
3 //import "github.com/Arachnid/solidity-stringutils/src/strings.sol";
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
114      *      null-termintaed utf-8 string.
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
218                 uint256 mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
219                 uint256 diff = (a & mask) - (b & mask);
220                 if (diff != 0)
221                     return int(diff);
222             }
223             selfptr += 32;
224             otherptr += 32;
225         }
226         return int(self._len) - int(other._len);
227     }
228 
229     /*
230      * @dev Returns true if the two slices contain the same text.
231      * @param self The first slice to compare.
232      * @param self The second slice to compare.
233      * @return True if the slices are equal, false otherwise.
234      */
235     function equals(slice self, slice other) internal pure returns (bool) {
236         return compare(self, other) == 0;
237     }
238 
239     /*
240      * @dev Extracts the first rune in the slice into `rune`, advancing the
241      *      slice to point to the next rune and returning `self`.
242      * @param self The slice to operate on.
243      * @param rune The slice that will contain the first rune.
244      * @return `rune`.
245      */
246     function nextRune(slice self, slice rune) internal pure returns (slice) {
247         rune._ptr = self._ptr;
248 
249         if (self._len == 0) {
250             rune._len = 0;
251             return rune;
252         }
253 
254         uint l;
255         uint b;
256         // Load the first byte of the rune into the LSBs of b
257         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
258         if (b < 0x80) {
259             l = 1;
260         } else if(b < 0xE0) {
261             l = 2;
262         } else if(b < 0xF0) {
263             l = 3;
264         } else {
265             l = 4;
266         }
267 
268         // Check for truncated codepoints
269         if (l > self._len) {
270             rune._len = self._len;
271             self._ptr += self._len;
272             self._len = 0;
273             return rune;
274         }
275 
276         self._ptr += l;
277         self._len -= l;
278         rune._len = l;
279         return rune;
280     }
281 
282     /*
283      * @dev Returns the first rune in the slice, advancing the slice to point
284      *      to the next rune.
285      * @param self The slice to operate on.
286      * @return A slice containing only the first rune from `self`.
287      */
288     function nextRune(slice self) internal pure returns (slice ret) {
289         nextRune(self, ret);
290     }
291 
292     /*
293      * @dev Returns the number of the first codepoint in the slice.
294      * @param self The slice to operate on.
295      * @return The number of the first codepoint in the slice.
296      */
297     function ord(slice self) internal pure returns (uint ret) {
298         if (self._len == 0) {
299             return 0;
300         }
301 
302         uint word;
303         uint length;
304         uint divisor = 2 ** 248;
305 
306         // Load the rune into the MSBs of b
307         assembly { word:= mload(mload(add(self, 32))) }
308         uint b = word / divisor;
309         if (b < 0x80) {
310             ret = b;
311             length = 1;
312         } else if(b < 0xE0) {
313             ret = b & 0x1F;
314             length = 2;
315         } else if(b < 0xF0) {
316             ret = b & 0x0F;
317             length = 3;
318         } else {
319             ret = b & 0x07;
320             length = 4;
321         }
322 
323         // Check for truncated codepoints
324         if (length > self._len) {
325             return 0;
326         }
327 
328         for (uint i = 1; i < length; i++) {
329             divisor = divisor / 256;
330             b = (word / divisor) & 0xFF;
331             if (b & 0xC0 != 0x80) {
332                 // Invalid UTF-8 sequence
333                 return 0;
334             }
335             ret = (ret * 64) | (b & 0x3F);
336         }
337 
338         return ret;
339     }
340 
341     /*
342      * @dev Returns the keccak-256 hash of the slice.
343      * @param self The slice to hash.
344      * @return The hash of the slice.
345      */
346     function keccak(slice self) internal pure returns (bytes32 ret) {
347         assembly {
348             ret := keccak256(mload(add(self, 32)), mload(self))
349         }
350     }
351 
352     /*
353      * @dev Returns true if `self` starts with `needle`.
354      * @param self The slice to operate on.
355      * @param needle The slice to search for.
356      * @return True if the slice starts with the provided text, false otherwise.
357      */
358     function startsWith(slice self, slice needle) internal pure returns (bool) {
359         if (self._len < needle._len) {
360             return false;
361         }
362 
363         if (self._ptr == needle._ptr) {
364             return true;
365         }
366 
367         bool equal;
368         assembly {
369             let length := mload(needle)
370             let selfptr := mload(add(self, 0x20))
371             let needleptr := mload(add(needle, 0x20))
372             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
373         }
374         return equal;
375     }
376 
377     /*
378      * @dev If `self` starts with `needle`, `needle` is removed from the
379      *      beginning of `self`. Otherwise, `self` is unmodified.
380      * @param self The slice to operate on.
381      * @param needle The slice to search for.
382      * @return `self`
383      */
384     function beyond(slice self, slice needle) internal pure returns (slice) {
385         if (self._len < needle._len) {
386             return self;
387         }
388 
389         bool equal = true;
390         if (self._ptr != needle._ptr) {
391             assembly {
392                 let length := mload(needle)
393                 let selfptr := mload(add(self, 0x20))
394                 let needleptr := mload(add(needle, 0x20))
395                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
396             }
397         }
398 
399         if (equal) {
400             self._len -= needle._len;
401             self._ptr += needle._len;
402         }
403 
404         return self;
405     }
406 
407     /*
408      * @dev Returns true if the slice ends with `needle`.
409      * @param self The slice to operate on.
410      * @param needle The slice to search for.
411      * @return True if the slice starts with the provided text, false otherwise.
412      */
413     function endsWith(slice self, slice needle) internal pure returns (bool) {
414         if (self._len < needle._len) {
415             return false;
416         }
417 
418         uint selfptr = self._ptr + self._len - needle._len;
419 
420         if (selfptr == needle._ptr) {
421             return true;
422         }
423 
424         bool equal;
425         assembly {
426             let length := mload(needle)
427             let needleptr := mload(add(needle, 0x20))
428             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
429         }
430 
431         return equal;
432     }
433 
434     /*
435      * @dev If `self` ends with `needle`, `needle` is removed from the
436      *      end of `self`. Otherwise, `self` is unmodified.
437      * @param self The slice to operate on.
438      * @param needle The slice to search for.
439      * @return `self`
440      */
441     function until(slice self, slice needle) internal pure returns (slice) {
442         if (self._len < needle._len) {
443             return self;
444         }
445 
446         uint selfptr = self._ptr + self._len - needle._len;
447         bool equal = true;
448         if (selfptr != needle._ptr) {
449             assembly {
450                 let length := mload(needle)
451                 let needleptr := mload(add(needle, 0x20))
452                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
453             }
454         }
455 
456         if (equal) {
457             self._len -= needle._len;
458         }
459 
460         return self;
461     }
462 
463     event log_bytemask(bytes32 mask);
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
492                 assembly { hash := sha3(needleptr, needlelen) }
493 
494                 for (idx = 0; idx <= selflen - needlelen; idx++) {
495                     bytes32 testHash;
496                     assembly { testHash := sha3(ptr, needlelen) }
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
532                 assembly { hash := sha3(needleptr, needlelen) }
533                 ptr = selfptr + (selflen - needlelen);
534                 while (ptr >= selfptr) {
535                     bytes32 testHash;
536                     assembly { testHash := sha3(ptr, needlelen) }
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
554     function find(slice self, slice needle) internal pure returns (slice) {
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
569     function rfind(slice self, slice needle) internal pure returns (slice) {
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
585     function split(slice self, slice needle, slice token) internal pure returns (slice) {
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
608     function split(slice self, slice needle) internal pure returns (slice token) {
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
622     function rsplit(slice self, slice needle, slice token) internal pure returns (slice) {
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
644     function rsplit(slice self, slice needle) internal pure returns (slice token) {
645         rsplit(self, needle, token);
646     }
647 
648     /*
649      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
650      * @param self The slice to search.
651      * @param needle The text to search for in `self`.
652      * @return The number of occurrences of `needle` found in `self`.
653      */
654     function count(slice self, slice needle) internal pure returns (uint cnt) {
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
668     function contains(slice self, slice needle) internal pure returns (bool) {
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
679     function concat(slice self, slice other) internal pure returns (string) {
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
696     function join(slice self, slice[] parts) internal pure returns (string) {
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
721 contract CryptoNumismat 
722 {
723     
724     using strings for *;
725     
726     address owner;
727 
728     string public standard = 'CryptoNumismat';
729     string public name;
730     string public symbol;
731     uint8 public decimals;
732     uint256 public totalSupply;
733 
734     struct Buy 
735     {
736         uint cardIndex;
737         address seller;
738         uint minValue;  // in wei
739         uint intName;
740         string name;
741     }
742     
743     struct UnitedBuy 
744     {
745         uint cardIndex;
746         address seller;
747         uint intName;
748         string name;
749     }
750 
751     mapping (uint => Buy) public cardsForSale;
752     mapping (uint => UnitedBuy) public UnitedCardsForSale;
753     mapping (address => bool) public admins;
754     mapping (address => string) public nicknames;
755 
756     event Assign(uint indexed _cardIndex, address indexed _seller, uint256 _value, uint _intName, string _name);
757     event Transfer(address indexed _from, address indexed _to, uint _cardIndex, uint256 _value);
758     
759     function CryptoNumismat() public payable 
760     {
761         owner = msg.sender;
762         admins[owner] = true;
763         
764         totalSupply = 1000;                         // Update total supply
765         name = "cryptonumismat";                    // Set the name for display purposes
766         symbol = "$";                               // Set the symbol for display purposes
767         decimals = 0;                               // Amount of decimals for display purposes
768     }
769     
770     modifier onlyOwner() 
771     {
772         require(msg.sender == owner);
773         _;
774     }
775     
776     modifier onlyAdmins() 
777     {
778         require(admins[msg.sender]);
779         _;
780     }
781     
782     function setOwner(address _owner) onlyOwner() public 
783     {
784         owner = _owner;
785     }
786     
787     function addAdmin(address _admin) onlyOwner() public
788     {
789         admins[_admin] = true;
790     }
791     
792     function removeAdmin(address _admin) onlyOwner() public
793     {
794         delete admins[_admin];
795     }
796     
797     function withdrawAll() onlyOwner() public 
798     {
799         owner.transfer(this.balance);
800     }
801 
802     function withdrawAmount(uint256 _amount) onlyOwner() public 
803     {
804         require(_amount <= this.balance);
805         
806         owner.transfer(_amount);
807     }
808     
809     /// _type == "Common"
810     /// _type == "United"
811 
812     function addCard(string _type, uint _intName, string _name, uint _cardIndex, uint256 _value, address _ownAddress) public onlyAdmins()
813     {
814         require(_cardIndex <= 1000);
815         require(_cardIndex > 0);
816         
817         require(cardsForSale[_cardIndex].cardIndex != _cardIndex);
818         require(UnitedCardsForSale[_intName].intName != _intName);
819         
820         address seller = _ownAddress;
821         uint256 _value2 = (_value * 1000000000);
822         
823         if (strings.equals(_type.toSlice(), "Common".toSlice()))
824         {
825             cardsForSale[_cardIndex] = Buy(_cardIndex, seller, _value2, _intName, _name);
826             Assign(_cardIndex, seller, _value2, _intName, _name);
827         }
828         else if (strings.equals(_type.toSlice(), "United".toSlice()))
829         {
830             UnitedCardsForSale[_intName] = UnitedBuy(_cardIndex, seller, _intName, _name);
831             cardsForSale[_cardIndex] = Buy(_cardIndex, seller, _value2,  _intName, _name);
832             Assign(_cardIndex, seller, _value2, _intName, _name);
833         }
834     }
835     
836     function displayCard(uint _cardIndex) public constant returns(uint, address, uint256, uint, string) 
837     {
838         require(_cardIndex <= 1000);
839         require(_cardIndex > 0);
840         
841         require (cardsForSale[_cardIndex].cardIndex == _cardIndex);
842             
843         return(cardsForSale[_cardIndex].cardIndex, 
844         cardsForSale[_cardIndex].seller,
845         cardsForSale[_cardIndex].minValue,
846         cardsForSale[_cardIndex].intName,
847         cardsForSale[_cardIndex].name);
848     }
849     
850     function setNick(string _newNick) public
851     {
852         nicknames[msg.sender] = _newNick;      
853     }
854     
855     function displayNick(address _owner) public constant returns(string)
856     {
857         return nicknames[_owner];
858     }
859     
860     
861     uint256 private limit1 = 0.05 ether;
862     uint256 private limit2 = 0.5 ether;
863     uint256 private limit3 = 5 ether;
864     uint256 private limit4 = 50 ether;
865     
866     function calculateNextPrice(uint256 _startPrice) public constant returns (uint256 _finalPrice)
867     {
868         if (_startPrice < limit1)
869             _startPrice =  _startPrice * 10 / 4;
870         else if (_startPrice < limit2)
871             _startPrice =  _startPrice * 10 / 5;
872         else if (_startPrice < limit3)
873             _startPrice =  _startPrice * 10 / 6;
874         else if (_startPrice < limit4)
875             _startPrice =  _startPrice * 10 / 7;
876         else
877             _startPrice =  _startPrice * 10 / 8;
878             
879         return (_startPrice / 1000000) * 1000000;
880     }
881     
882     function calculateDevCut(uint256 _startPrice) public constant returns (uint256 _cut)
883     {
884         if (_startPrice < limit2)
885             _startPrice =  _startPrice * 5 / 100;
886         else if (_startPrice < limit3)
887             _startPrice =  _startPrice * 4 / 100;
888         else if (_startPrice < limit4)
889             _startPrice =  _startPrice * 3 / 100;
890         else
891             _startPrice =  _startPrice * 2 / 100;
892             
893         return (_startPrice / 1000000) * 1000000;
894     }
895     
896     function buy(uint _cardIndex) public payable
897     {
898         require(_cardIndex <= 1000);
899         require(_cardIndex > 0);
900         require(cardsForSale[_cardIndex].cardIndex == _cardIndex);
901         require(cardsForSale[_cardIndex].seller != msg.sender);
902         require(msg.sender != address(0));
903         require(msg.sender != owner);
904         require(cardsForSale[_cardIndex].minValue > 0);
905         require(msg.value >= cardsForSale[_cardIndex].minValue);
906         
907         address _buyer = msg.sender;
908         address _seller = cardsForSale[_cardIndex].seller;
909         string _name = cardsForSale[_cardIndex].name;
910         uint _intName = cardsForSale[_cardIndex].intName;
911         
912         address _UnitedOwner = UnitedCardsForSale[_intName].seller;
913         
914         uint256 _price = cardsForSale[_cardIndex].minValue;
915         
916         uint256 _nextPrice = calculateNextPrice(_price);
917         uint256 _devCut = calculateDevCut(_price);
918         
919         uint256 _totalPrice = _price - _devCut - (_devCut / 4);
920         uint256 _extra = msg.value - _price;
921         
922         _seller.transfer(_totalPrice);
923         _UnitedOwner.transfer((_devCut / 4));
924         
925         if (_extra > 0)
926         {
927             Transfer(_buyer, _buyer, _cardIndex, _extra);
928             
929             _buyer.transfer(_extra);
930         }
931         
932         cardsForSale[_cardIndex].seller = _buyer;
933         cardsForSale[_cardIndex].minValue = _nextPrice;
934         
935         if (_cardIndex == UnitedCardsForSale[_intName].cardIndex)
936             UnitedCardsForSale[_intName].seller = _buyer;
937         
938         
939         Transfer(_buyer, _seller, _cardIndex, _totalPrice);
940         Assign(_cardIndex, _buyer, _nextPrice, _intName, _name);////////////////////////////////
941     }
942 }