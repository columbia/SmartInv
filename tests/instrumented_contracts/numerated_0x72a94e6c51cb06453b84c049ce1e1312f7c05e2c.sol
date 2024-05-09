1 // SPDX-License-Identifier: MIT
2 
3 //
4 //      Wiiides 
5 //      
6 //      @sterlingcrispin 
7 //      @wiiides
8 //      wiiides.com
9 //      NotAudited.xyz
10 //  
11 //      no warranty expressed or implied
12 //      see wiiides.com for important terms of service
13 //
14 //
15 //
16 //  
17 //                                              
18 //                                        WIIIIIIIIIIIIIIIIIIIIIIDE             
19 //                           WIIIIIIIIIIDE------------WIIIIIIIIIIDE             
20 //              WIIIIIIIIIIIDE------------------------WIIIIIIIIIIDE             
21 //              wiiiiiiiiiiide------------------------WIIIIIIIIIIDE             
22 //  WIIIIIIIIIIDE,,,,,,,,,,,,-------------------------WIIIIIIIIIIDE             
23 //  ,,,,,,,,,,,,,-------------------------------------WIIIIIIIIIIIIIIIIIIIIIIIDE
24 //  .........................-------------------------.........................W
25 //  ,,,,,,,,,,,,,........................-------------.........................I
26 //  ,,,,,,,,,,,,,........................-------------.........................I
27 //  ...........................................................................I
28 //  ...........................................................................D
29 //  ...........................................................................E
30 //  wiiiiiiide..................................................................
31 //  wiiiiiiiiiiiiiiiiiiiiiide......................................wiiiiiiiiiide
32 //  WIIIIIIIIIIDE,,,,,,,,,,,,,.....................................WIIIIIIIIIIDE
33 //  ...........................................................................W
34 //  ...........................................................................I
35 //  .....................................wiiiiiiiiiiiiiiiiiiiiiiide............I
36 //  .....................................WIIIIIIIIIIIIIIIIIIIIIIIDE............I
37 //  ...........................................................................I
38 //  ...........WIIIIIIIIIIIDE..................................................I
39 //  .........................WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE............I
40 //  .........................WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE............I
41 //  ...........................................................................D
42 //  ...........................................................................E
43 //  ...........WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE
44 //  ...........WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE
45 //  ...........WIIIIIIIIIIIIDE 
46 //  ...........WIIIIIIIIIIIIDE 
47 //  
48 //
49 
50 // File: https://raw.githubusercontent.com/Arachnid/solidity-stringutils/master/src/strings.sol
51 
52 /*
53  * @title String & slice utility library for Solidity contracts.
54  * @author Nick Johnson <arachnid@notdot.net>
55  *
56  * @dev Functionality in this library is largely implemented using an
57  *      abstraction called a 'slice'. A slice represents a part of a string -
58  *      anything from the entire string to a single character, or even no
59  *      characters at all (a 0-length slice). Since a slice only has to specify
60  *      an offset and a length, copying and manipulating slices is a lot less
61  *      expensive than copying and manipulating the strings they reference.
62  *
63  *      To further reduce gas costs, most functions on slice that need to return
64  *      a slice modify the original one instead of allocating a new one; for
65  *      instance, `s.split(".")` will return the text up to the first '.',
66  *      modifying s to only contain the remainder of the string after the '.'.
67  *      In situations where you do not want to modify the original slice, you
68  *      can make a copy first with `.copy()`, for example:
69  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
70  *      Solidity has no memory management, it will result in allocating many
71  *      short-lived slices that are later discarded.
72  *
73  *      Functions that return two slices come in two versions: a non-allocating
74  *      version that takes the second slice as an argument, modifying it in
75  *      place, and an allocating version that allocates and returns the second
76  *      slice; see `nextRune` for example.
77  *
78  *      Functions that have to copy string data will return strings rather than
79  *      slices; these can be cast back to slices for further processing if
80  *      required.
81  *
82  *      For convenience, some functions are provided with non-modifying
83  *      variants that create a new slice and return both; for instance,
84  *      `s.splitNew('.')` leaves s unmodified, and returns two values
85  *      corresponding to the left and right parts of the string.
86  */
87 
88 pragma solidity ^0.8.0;
89 
90 library strings {
91     struct slice {
92         uint _len;
93         uint _ptr;
94     }
95 
96     function memcpy(uint dest, uint src, uint len) private pure {
97         // Copy word-length chunks while possible
98         for(; len >= 32; len -= 32) {
99             assembly {
100                 mstore(dest, mload(src))
101             }
102             dest += 32;
103             src += 32;
104         }
105 
106         // Copy remaining bytes
107         uint mask = type(uint).max;
108         if (len > 0) {
109             mask = 256 ** (32 - len) - 1;
110         }
111         assembly {
112             let srcpart := and(mload(src), not(mask))
113             let destpart := and(mload(dest), mask)
114             mstore(dest, or(destpart, srcpart))
115         }
116     }
117 
118     /*
119      * @dev Returns a slice containing the entire string.
120      * @param self The string to make a slice from.
121      * @return A newly allocated slice containing the entire string.
122      */
123     function toSlice(string memory self) internal pure returns (slice memory) {
124         uint ptr;
125         assembly {
126             ptr := add(self, 0x20)
127         }
128         return slice(bytes(self).length, ptr);
129     }
130 
131     /*
132      * @dev Returns the length of a null-terminated bytes32 string.
133      * @param self The value to find the length of.
134      * @return The length of the string, from 0 to 32.
135      */
136     function len(bytes32 self) internal pure returns (uint) {
137         uint ret;
138         if (self == 0)
139             return 0;
140         if (uint(self) & type(uint128).max == 0) {
141             ret += 16;
142             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
143         }
144         if (uint(self) & type(uint64).max == 0) {
145             ret += 8;
146             self = bytes32(uint(self) / 0x10000000000000000);
147         }
148         if (uint(self) & type(uint32).max == 0) {
149             ret += 4;
150             self = bytes32(uint(self) / 0x100000000);
151         }
152         if (uint(self) & type(uint16).max == 0) {
153             ret += 2;
154             self = bytes32(uint(self) / 0x10000);
155         }
156         if (uint(self) & type(uint8).max == 0) {
157             ret += 1;
158         }
159         return 32 - ret;
160     }
161 
162     /*
163      * @dev Returns a slice containing the entire bytes32, interpreted as a
164      *      null-terminated utf-8 string.
165      * @param self The bytes32 value to convert to a slice.
166      * @return A new slice containing the value of the input argument up to the
167      *         first null.
168      */
169     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
170         // Allocate space for `self` in memory, copy it there, and point ret at it
171         assembly {
172             let ptr := mload(0x40)
173             mstore(0x40, add(ptr, 0x20))
174             mstore(ptr, self)
175             mstore(add(ret, 0x20), ptr)
176         }
177         ret._len = len(self);
178     }
179 
180     /*
181      * @dev Returns a new slice containing the same data as the current slice.
182      * @param self The slice to copy.
183      * @return A new slice containing the same data as `self`.
184      */
185     function copy(slice memory self) internal pure returns (slice memory) {
186         return slice(self._len, self._ptr);
187     }
188 
189     /*
190      * @dev Copies a slice to a new string.
191      * @param self The slice to copy.
192      * @return A newly allocated string containing the slice's text.
193      */
194     function toString(slice memory self) internal pure returns (string memory) {
195         string memory ret = new string(self._len);
196         uint retptr;
197         assembly { retptr := add(ret, 32) }
198 
199         memcpy(retptr, self._ptr, self._len);
200         return ret;
201     }
202 
203     /*
204      * @dev Returns the length in runes of the slice. Note that this operation
205      *      takes time proportional to the length of the slice; avoid using it
206      *      in loops, and call `slice.empty()` if you only need to know whether
207      *      the slice is empty or not.
208      * @param self The slice to operate on.
209      * @return The length of the slice in runes.
210      */
211     function len(slice memory self) internal pure returns (uint l) {
212         // Starting at ptr-31 means the LSB will be the byte we care about
213         uint ptr = self._ptr - 31;
214         uint end = ptr + self._len;
215         for (l = 0; ptr < end; l++) {
216             uint8 b;
217             assembly { b := and(mload(ptr), 0xFF) }
218             if (b < 0x80) {
219                 ptr += 1;
220             } else if(b < 0xE0) {
221                 ptr += 2;
222             } else if(b < 0xF0) {
223                 ptr += 3;
224             } else if(b < 0xF8) {
225                 ptr += 4;
226             } else if(b < 0xFC) {
227                 ptr += 5;
228             } else {
229                 ptr += 6;
230             }
231         }
232     }
233 
234     /*
235      * @dev Returns true if the slice is empty (has a length of 0).
236      * @param self The slice to operate on.
237      * @return True if the slice is empty, False otherwise.
238      */
239     function empty(slice memory self) internal pure returns (bool) {
240         return self._len == 0;
241     }
242 
243     /*
244      * @dev Returns a positive number if `other` comes lexicographically after
245      *      `self`, a negative number if it comes before, or zero if the
246      *      contents of the two slices are equal. Comparison is done per-rune,
247      *      on unicode codepoints.
248      * @param self The first slice to compare.
249      * @param other The second slice to compare.
250      * @return The result of the comparison.
251      */
252     function compare(slice memory self, slice memory other) internal pure returns (int) {
253         uint shortest = self._len;
254         if (other._len < self._len)
255             shortest = other._len;
256 
257         uint selfptr = self._ptr;
258         uint otherptr = other._ptr;
259         for (uint idx = 0; idx < shortest; idx += 32) {
260             uint a;
261             uint b;
262             assembly {
263                 a := mload(selfptr)
264                 b := mload(otherptr)
265             }
266             if (a != b) {
267                 // Mask out irrelevant bytes and check again
268                 uint mask = type(uint).max; // 0xffff...
269                 if(shortest < 32) {
270                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
271                 }
272                 unchecked {
273                     uint diff = (a & mask) - (b & mask);
274                     if (diff != 0)
275                         return int(diff);
276                 }
277             }
278             selfptr += 32;
279             otherptr += 32;
280         }
281         return int(self._len) - int(other._len);
282     }
283 
284     /*
285      * @dev Returns true if the two slices contain the same text.
286      * @param self The first slice to compare.
287      * @param self The second slice to compare.
288      * @return True if the slices are equal, false otherwise.
289      */
290     function equals(slice memory self, slice memory other) internal pure returns (bool) {
291         return compare(self, other) == 0;
292     }
293 
294     /*
295      * @dev Extracts the first rune in the slice into `rune`, advancing the
296      *      slice to point to the next rune and returning `self`.
297      * @param self The slice to operate on.
298      * @param rune The slice that will contain the first rune.
299      * @return `rune`.
300      */
301     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
302         rune._ptr = self._ptr;
303 
304         if (self._len == 0) {
305             rune._len = 0;
306             return rune;
307         }
308 
309         uint l;
310         uint b;
311         // Load the first byte of the rune into the LSBs of b
312         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
313         if (b < 0x80) {
314             l = 1;
315         } else if(b < 0xE0) {
316             l = 2;
317         } else if(b < 0xF0) {
318             l = 3;
319         } else {
320             l = 4;
321         }
322 
323         // Check for truncated codepoints
324         if (l > self._len) {
325             rune._len = self._len;
326             self._ptr += self._len;
327             self._len = 0;
328             return rune;
329         }
330 
331         self._ptr += l;
332         self._len -= l;
333         rune._len = l;
334         return rune;
335     }
336 
337     /*
338      * @dev Returns the first rune in the slice, advancing the slice to point
339      *      to the next rune.
340      * @param self The slice to operate on.
341      * @return A slice containing only the first rune from `self`.
342      */
343     function nextRune(slice memory self) internal pure returns (slice memory ret) {
344         nextRune(self, ret);
345     }
346 
347     /*
348      * @dev Returns the number of the first codepoint in the slice.
349      * @param self The slice to operate on.
350      * @return The number of the first codepoint in the slice.
351      */
352     function ord(slice memory self) internal pure returns (uint ret) {
353         if (self._len == 0) {
354             return 0;
355         }
356 
357         uint word;
358         uint length;
359         uint divisor = 2 ** 248;
360 
361         // Load the rune into the MSBs of b
362         assembly { word:= mload(mload(add(self, 32))) }
363         uint b = word / divisor;
364         if (b < 0x80) {
365             ret = b;
366             length = 1;
367         } else if(b < 0xE0) {
368             ret = b & 0x1F;
369             length = 2;
370         } else if(b < 0xF0) {
371             ret = b & 0x0F;
372             length = 3;
373         } else {
374             ret = b & 0x07;
375             length = 4;
376         }
377 
378         // Check for truncated codepoints
379         if (length > self._len) {
380             return 0;
381         }
382 
383         for (uint i = 1; i < length; i++) {
384             divisor = divisor / 256;
385             b = (word / divisor) & 0xFF;
386             if (b & 0xC0 != 0x80) {
387                 // Invalid UTF-8 sequence
388                 return 0;
389             }
390             ret = (ret * 64) | (b & 0x3F);
391         }
392 
393         return ret;
394     }
395 
396     /*
397      * @dev Returns the keccak-256 hash of the slice.
398      * @param self The slice to hash.
399      * @return The hash of the slice.
400      */
401     function keccak(slice memory self) internal pure returns (bytes32 ret) {
402         assembly {
403             ret := keccak256(mload(add(self, 32)), mload(self))
404         }
405     }
406 
407     /*
408      * @dev Returns true if `self` starts with `needle`.
409      * @param self The slice to operate on.
410      * @param needle The slice to search for.
411      * @return True if the slice starts with the provided text, false otherwise.
412      */
413     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
414         if (self._len < needle._len) {
415             return false;
416         }
417 
418         if (self._ptr == needle._ptr) {
419             return true;
420         }
421 
422         bool equal;
423         assembly {
424             let length := mload(needle)
425             let selfptr := mload(add(self, 0x20))
426             let needleptr := mload(add(needle, 0x20))
427             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
428         }
429         return equal;
430     }
431 
432     /*
433      * @dev If `self` starts with `needle`, `needle` is removed from the
434      *      beginning of `self`. Otherwise, `self` is unmodified.
435      * @param self The slice to operate on.
436      * @param needle The slice to search for.
437      * @return `self`
438      */
439     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
440         if (self._len < needle._len) {
441             return self;
442         }
443 
444         bool equal = true;
445         if (self._ptr != needle._ptr) {
446             assembly {
447                 let length := mload(needle)
448                 let selfptr := mload(add(self, 0x20))
449                 let needleptr := mload(add(needle, 0x20))
450                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
451             }
452         }
453 
454         if (equal) {
455             self._len -= needle._len;
456             self._ptr += needle._len;
457         }
458 
459         return self;
460     }
461 
462     /*
463      * @dev Returns true if the slice ends with `needle`.
464      * @param self The slice to operate on.
465      * @param needle The slice to search for.
466      * @return True if the slice starts with the provided text, false otherwise.
467      */
468     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
469         if (self._len < needle._len) {
470             return false;
471         }
472 
473         uint selfptr = self._ptr + self._len - needle._len;
474 
475         if (selfptr == needle._ptr) {
476             return true;
477         }
478 
479         bool equal;
480         assembly {
481             let length := mload(needle)
482             let needleptr := mload(add(needle, 0x20))
483             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
484         }
485 
486         return equal;
487     }
488 
489     /*
490      * @dev If `self` ends with `needle`, `needle` is removed from the
491      *      end of `self`. Otherwise, `self` is unmodified.
492      * @param self The slice to operate on.
493      * @param needle The slice to search for.
494      * @return `self`
495      */
496     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
497         if (self._len < needle._len) {
498             return self;
499         }
500 
501         uint selfptr = self._ptr + self._len - needle._len;
502         bool equal = true;
503         if (selfptr != needle._ptr) {
504             assembly {
505                 let length := mload(needle)
506                 let needleptr := mload(add(needle, 0x20))
507                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
508             }
509         }
510 
511         if (equal) {
512             self._len -= needle._len;
513         }
514 
515         return self;
516     }
517 
518     // Returns the memory address of the first byte of the first occurrence of
519     // `needle` in `self`, or the first byte after `self` if not found.
520     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
521         uint ptr = selfptr;
522         uint idx;
523 
524         if (needlelen <= selflen) {
525             if (needlelen <= 32) {
526                 bytes32 mask;
527                 if (needlelen > 0) {
528                     mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
529                 }
530 
531                 bytes32 needledata;
532                 assembly { needledata := and(mload(needleptr), mask) }
533 
534                 uint end = selfptr + selflen - needlelen;
535                 bytes32 ptrdata;
536                 assembly { ptrdata := and(mload(ptr), mask) }
537 
538                 while (ptrdata != needledata) {
539                     if (ptr >= end)
540                         return selfptr + selflen;
541                     ptr++;
542                     assembly { ptrdata := and(mload(ptr), mask) }
543                 }
544                 return ptr;
545             } else {
546                 // For long needles, use hashing
547                 bytes32 hash;
548                 assembly { hash := keccak256(needleptr, needlelen) }
549 
550                 for (idx = 0; idx <= selflen - needlelen; idx++) {
551                     bytes32 testHash;
552                     assembly { testHash := keccak256(ptr, needlelen) }
553                     if (hash == testHash)
554                         return ptr;
555                     ptr += 1;
556                 }
557             }
558         }
559         return selfptr + selflen;
560     }
561 
562     // Returns the memory address of the first byte after the last occurrence of
563     // `needle` in `self`, or the address of `self` if not found.
564     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
565         uint ptr;
566 
567         if (needlelen <= selflen) {
568             if (needlelen <= 32) {
569                 bytes32 mask;
570                 if (needlelen > 0) {
571                     mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
572                 }
573 
574                 bytes32 needledata;
575                 assembly { needledata := and(mload(needleptr), mask) }
576 
577                 ptr = selfptr + selflen - needlelen;
578                 bytes32 ptrdata;
579                 assembly { ptrdata := and(mload(ptr), mask) }
580 
581                 while (ptrdata != needledata) {
582                     if (ptr <= selfptr)
583                         return selfptr;
584                     ptr--;
585                     assembly { ptrdata := and(mload(ptr), mask) }
586                 }
587                 return ptr + needlelen;
588             } else {
589                 // For long needles, use hashing
590                 bytes32 hash;
591                 assembly { hash := keccak256(needleptr, needlelen) }
592                 ptr = selfptr + (selflen - needlelen);
593                 while (ptr >= selfptr) {
594                     bytes32 testHash;
595                     assembly { testHash := keccak256(ptr, needlelen) }
596                     if (hash == testHash)
597                         return ptr + needlelen;
598                     ptr -= 1;
599                 }
600             }
601         }
602         return selfptr;
603     }
604 
605     /*
606      * @dev Modifies `self` to contain everything from the first occurrence of
607      *      `needle` to the end of the slice. `self` is set to the empty slice
608      *      if `needle` is not found.
609      * @param self The slice to search and modify.
610      * @param needle The text to search for.
611      * @return `self`.
612      */
613     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
614         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
615         self._len -= ptr - self._ptr;
616         self._ptr = ptr;
617         return self;
618     }
619 
620     /*
621      * @dev Modifies `self` to contain the part of the string from the start of
622      *      `self` to the end of the first occurrence of `needle`. If `needle`
623      *      is not found, `self` is set to the empty slice.
624      * @param self The slice to search and modify.
625      * @param needle The text to search for.
626      * @return `self`.
627      */
628     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
629         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
630         self._len = ptr - self._ptr;
631         return self;
632     }
633 
634     /*
635      * @dev Splits the slice, setting `self` to everything after the first
636      *      occurrence of `needle`, and `token` to everything before it. If
637      *      `needle` does not occur in `self`, `self` is set to the empty slice,
638      *      and `token` is set to the entirety of `self`.
639      * @param self The slice to split.
640      * @param needle The text to search for in `self`.
641      * @param token An output parameter to which the first token is written.
642      * @return `token`.
643      */
644     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
645         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
646         token._ptr = self._ptr;
647         token._len = ptr - self._ptr;
648         if (ptr == self._ptr + self._len) {
649             // Not found
650             self._len = 0;
651         } else {
652             self._len -= token._len + needle._len;
653             self._ptr = ptr + needle._len;
654         }
655         return token;
656     }
657 
658     /*
659      * @dev Splits the slice, setting `self` to everything after the first
660      *      occurrence of `needle`, and returning everything before it. If
661      *      `needle` does not occur in `self`, `self` is set to the empty slice,
662      *      and the entirety of `self` is returned.
663      * @param self The slice to split.
664      * @param needle The text to search for in `self`.
665      * @return The part of `self` up to the first occurrence of `delim`.
666      */
667     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
668         split(self, needle, token);
669     }
670 
671     /*
672      * @dev Splits the slice, setting `self` to everything before the last
673      *      occurrence of `needle`, and `token` to everything after it. If
674      *      `needle` does not occur in `self`, `self` is set to the empty slice,
675      *      and `token` is set to the entirety of `self`.
676      * @param self The slice to split.
677      * @param needle The text to search for in `self`.
678      * @param token An output parameter to which the first token is written.
679      * @return `token`.
680      */
681     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
682         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
683         token._ptr = ptr;
684         token._len = self._len - (ptr - self._ptr);
685         if (ptr == self._ptr) {
686             // Not found
687             self._len = 0;
688         } else {
689             self._len -= token._len + needle._len;
690         }
691         return token;
692     }
693 
694     /*
695      * @dev Splits the slice, setting `self` to everything before the last
696      *      occurrence of `needle`, and returning everything after it. If
697      *      `needle` does not occur in `self`, `self` is set to the empty slice,
698      *      and the entirety of `self` is returned.
699      * @param self The slice to split.
700      * @param needle The text to search for in `self`.
701      * @return The part of `self` after the last occurrence of `delim`.
702      */
703     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
704         rsplit(self, needle, token);
705     }
706 
707     /*
708      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
709      * @param self The slice to search.
710      * @param needle The text to search for in `self`.
711      * @return The number of occurrences of `needle` found in `self`.
712      */
713     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
714         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
715         while (ptr <= self._ptr + self._len) {
716             cnt++;
717             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
718         }
719     }
720 
721     /*
722      * @dev Returns True if `self` contains `needle`.
723      * @param self The slice to search.
724      * @param needle The text to search for in `self`.
725      * @return True if `needle` is found in `self`, false otherwise.
726      */
727     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
728         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
729     }
730 
731     /*
732      * @dev Returns a newly allocated string containing the concatenation of
733      *      `self` and `other`.
734      * @param self The first slice to concatenate.
735      * @param other The second slice to concatenate.
736      * @return The concatenation of the two strings.
737      */
738     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
739         string memory ret = new string(self._len + other._len);
740         uint retptr;
741         assembly { retptr := add(ret, 32) }
742         memcpy(retptr, self._ptr, self._len);
743         memcpy(retptr + self._len, other._ptr, other._len);
744         return ret;
745     }
746 
747     /*
748      * @dev Joins an array of slices, using `self` as a delimiter, returning a
749      *      newly allocated string.
750      * @param self The delimiter to use.
751      * @param parts A list of slices to join.
752      * @return A newly allocated string containing all the slices in `parts`,
753      *         joined with `self`.
754      */
755     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
756         if (parts.length == 0)
757             return "";
758 
759         uint length = self._len * (parts.length - 1);
760         for(uint i = 0; i < parts.length; i++)
761             length += parts[i]._len;
762 
763         string memory ret = new string(length);
764         uint retptr;
765         assembly { retptr := add(ret, 32) }
766 
767         for(uint i = 0; i < parts.length; i++) {
768             memcpy(retptr, parts[i]._ptr, parts[i]._len);
769             retptr += parts[i]._len;
770             if (i < parts.length - 1) {
771                 memcpy(retptr, self._ptr, self._len);
772                 retptr += self._len;
773             }
774         }
775 
776         return ret;
777     }
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
781 
782 
783 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 /**
788  * @dev Interface of the ERC20 standard as defined in the EIP.
789  */
790 interface IERC20 {
791     /**
792      * @dev Emitted when `value` tokens are moved from one account (`from`) to
793      * another (`to`).
794      *
795      * Note that `value` may be zero.
796      */
797     event Transfer(address indexed from, address indexed to, uint256 value);
798 
799     /**
800      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
801      * a call to {approve}. `value` is the new allowance.
802      */
803     event Approval(address indexed owner, address indexed spender, uint256 value);
804 
805     /**
806      * @dev Returns the amount of tokens in existence.
807      */
808     function totalSupply() external view returns (uint256);
809 
810     /**
811      * @dev Returns the amount of tokens owned by `account`.
812      */
813     function balanceOf(address account) external view returns (uint256);
814 
815     /**
816      * @dev Moves `amount` tokens from the caller's account to `to`.
817      *
818      * Returns a boolean value indicating whether the operation succeeded.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transfer(address to, uint256 amount) external returns (bool);
823 
824     /**
825      * @dev Returns the remaining number of tokens that `spender` will be
826      * allowed to spend on behalf of `owner` through {transferFrom}. This is
827      * zero by default.
828      *
829      * This value changes when {approve} or {transferFrom} are called.
830      */
831     function allowance(address owner, address spender) external view returns (uint256);
832 
833     /**
834      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
835      *
836      * Returns a boolean value indicating whether the operation succeeded.
837      *
838      * IMPORTANT: Beware that changing an allowance with this method brings the risk
839      * that someone may use both the old and the new allowance by unfortunate
840      * transaction ordering. One possible solution to mitigate this race
841      * condition is to first reduce the spender's allowance to 0 and set the
842      * desired value afterwards:
843      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
844      *
845      * Emits an {Approval} event.
846      */
847     function approve(address spender, uint256 amount) external returns (bool);
848 
849     /**
850      * @dev Moves `amount` tokens from `from` to `to` using the
851      * allowance mechanism. `amount` is then deducted from the caller's
852      * allowance.
853      *
854      * Returns a boolean value indicating whether the operation succeeded.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 amount
862     ) external returns (bool);
863 }
864 
865 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
866 
867 
868 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @dev Contract module that helps prevent reentrant calls to a function.
874  *
875  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
876  * available, which can be applied to functions to make sure there are no nested
877  * (reentrant) calls to them.
878  *
879  * Note that because there is a single `nonReentrant` guard, functions marked as
880  * `nonReentrant` may not call one another. This can be worked around by making
881  * those functions `private`, and then adding `external` `nonReentrant` entry
882  * points to them.
883  *
884  * TIP: If you would like to learn more about reentrancy and alternative ways
885  * to protect against it, check out our blog post
886  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
887  */
888 abstract contract ReentrancyGuard {
889     // Booleans are more expensive than uint256 or any type that takes up a full
890     // word because each write operation emits an extra SLOAD to first read the
891     // slot's contents, replace the bits taken up by the boolean, and then write
892     // back. This is the compiler's defense against contract upgrades and
893     // pointer aliasing, and it cannot be disabled.
894 
895     // The values being non-zero value makes deployment a bit more expensive,
896     // but in exchange the refund on every call to nonReentrant will be lower in
897     // amount. Since refunds are capped to a percentage of the total
898     // transaction's gas, it is best to keep them low in cases like this one, to
899     // increase the likelihood of the full refund coming into effect.
900     uint256 private constant _NOT_ENTERED = 1;
901     uint256 private constant _ENTERED = 2;
902 
903     uint256 private _status;
904 
905     constructor() {
906         _status = _NOT_ENTERED;
907     }
908 
909     /**
910      * @dev Prevents a contract from calling itself, directly or indirectly.
911      * Calling a `nonReentrant` function from another `nonReentrant`
912      * function is not supported. It is possible to prevent this from happening
913      * by making the `nonReentrant` function external, and making it call a
914      * `private` function that does the actual work.
915      */
916     modifier nonReentrant() {
917         // On the first call to nonReentrant, _notEntered will be true
918         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
919 
920         // Any calls to nonReentrant after this point will fail
921         _status = _ENTERED;
922 
923         _;
924 
925         // By storing the original value once again, a refund is triggered (see
926         // https://eips.ethereum.org/EIPS/eip-2200)
927         _status = _NOT_ENTERED;
928     }
929 }
930 
931 // File: @openzeppelin/contracts/utils/Strings.sol
932 
933 
934 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 /**
939  * @dev String operations.
940  */
941 library Strings {
942     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
943     uint8 private constant _ADDRESS_LENGTH = 20;
944 
945     /**
946      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
947      */
948     function toString(uint256 value) internal pure returns (string memory) {
949         // Inspired by OraclizeAPI's implementation - MIT licence
950         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
951 
952         if (value == 0) {
953             return "0";
954         }
955         uint256 temp = value;
956         uint256 digits;
957         while (temp != 0) {
958             digits++;
959             temp /= 10;
960         }
961         bytes memory buffer = new bytes(digits);
962         while (value != 0) {
963             digits -= 1;
964             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
965             value /= 10;
966         }
967         return string(buffer);
968     }
969 
970     /**
971      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
972      */
973     function toHexString(uint256 value) internal pure returns (string memory) {
974         if (value == 0) {
975             return "0x00";
976         }
977         uint256 temp = value;
978         uint256 length = 0;
979         while (temp != 0) {
980             length++;
981             temp >>= 8;
982         }
983         return toHexString(value, length);
984     }
985 
986     /**
987      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
988      */
989     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
990         bytes memory buffer = new bytes(2 * length + 2);
991         buffer[0] = "0";
992         buffer[1] = "x";
993         for (uint256 i = 2 * length + 1; i > 1; --i) {
994             buffer[i] = _HEX_SYMBOLS[value & 0xf];
995             value >>= 4;
996         }
997         require(value == 0, "Strings: hex length insufficient");
998         return string(buffer);
999     }
1000 
1001     /**
1002      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1003      */
1004     function toHexString(address addr) internal pure returns (string memory) {
1005         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1006     }
1007 }
1008 
1009 // File: @openzeppelin/contracts/utils/Context.sol
1010 
1011 
1012 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1013 
1014 pragma solidity ^0.8.0;
1015 
1016 /**
1017  * @dev Provides information about the current execution context, including the
1018  * sender of the transaction and its data. While these are generally available
1019  * via msg.sender and msg.data, they should not be accessed in such a direct
1020  * manner, since when dealing with meta-transactions the account sending and
1021  * paying for execution may not be the actual sender (as far as an application
1022  * is concerned).
1023  *
1024  * This contract is only required for intermediate, library-like contracts.
1025  */
1026 abstract contract Context {
1027     function _msgSender() internal view virtual returns (address) {
1028         return msg.sender;
1029     }
1030 
1031     function _msgData() internal view virtual returns (bytes calldata) {
1032         return msg.data;
1033     }
1034 }
1035 
1036 // File: @openzeppelin/contracts/access/Ownable.sol
1037 
1038 
1039 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 
1044 /**
1045  * @dev Contract module which provides a basic access control mechanism, where
1046  * there is an account (an owner) that can be granted exclusive access to
1047  * specific functions.
1048  *
1049  * By default, the owner account will be the one that deploys the contract. This
1050  * can later be changed with {transferOwnership}.
1051  *
1052  * This module is used through inheritance. It will make available the modifier
1053  * `onlyOwner`, which can be applied to your functions to restrict their use to
1054  * the owner.
1055  */
1056 abstract contract Ownable is Context {
1057     address private _owner;
1058 
1059     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1060 
1061     /**
1062      * @dev Initializes the contract setting the deployer as the initial owner.
1063      */
1064     constructor() {
1065         _transferOwnership(_msgSender());
1066     }
1067 
1068     /**
1069      * @dev Throws if called by any account other than the owner.
1070      */
1071     modifier onlyOwner() {
1072         _checkOwner();
1073         _;
1074     }
1075 
1076     /**
1077      * @dev Returns the address of the current owner.
1078      */
1079     function owner() public view virtual returns (address) {
1080         return _owner;
1081     }
1082 
1083     /**
1084      * @dev Throws if the sender is not the owner.
1085      */
1086     function _checkOwner() internal view virtual {
1087         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1088     }
1089 
1090     /**
1091      * @dev Leaves the contract without owner. It will not be possible to call
1092      * `onlyOwner` functions anymore. Can only be called by the current owner.
1093      *
1094      * NOTE: Renouncing ownership will leave the contract without an owner,
1095      * thereby removing any functionality that is only available to the owner.
1096      */
1097     function renounceOwnership() public virtual onlyOwner {
1098         _transferOwnership(address(0));
1099     }
1100 
1101     /**
1102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1103      * Can only be called by the current owner.
1104      */
1105     function transferOwnership(address newOwner) public virtual onlyOwner {
1106         require(newOwner != address(0), "Ownable: new owner is the zero address");
1107         _transferOwnership(newOwner);
1108     }
1109 
1110     /**
1111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1112      * Internal function without access restriction.
1113      */
1114     function _transferOwnership(address newOwner) internal virtual {
1115         address oldOwner = _owner;
1116         _owner = newOwner;
1117         emit OwnershipTransferred(oldOwner, newOwner);
1118     }
1119 }
1120 
1121 // File: @openzeppelin/contracts/utils/Address.sol
1122 
1123 
1124 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1125 
1126 pragma solidity ^0.8.1;
1127 
1128 /**
1129  * @dev Collection of functions related to the address type
1130  */
1131 library Address {
1132     /**
1133      * @dev Returns true if `account` is a contract.
1134      *
1135      * [IMPORTANT]
1136      * ====
1137      * It is unsafe to assume that an address for which this function returns
1138      * false is an externally-owned account (EOA) and not a contract.
1139      *
1140      * Among others, `isContract` will return false for the following
1141      * types of addresses:
1142      *
1143      *  - an externally-owned account
1144      *  - a contract in construction
1145      *  - an address where a contract will be created
1146      *  - an address where a contract lived, but was destroyed
1147      * ====
1148      *
1149      * [IMPORTANT]
1150      * ====
1151      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1152      *
1153      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1154      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1155      * constructor.
1156      * ====
1157      */
1158     function isContract(address account) internal view returns (bool) {
1159         // This method relies on extcodesize/address.code.length, which returns 0
1160         // for contracts in construction, since the code is only stored at the end
1161         // of the constructor execution.
1162 
1163         return account.code.length > 0;
1164     }
1165 
1166     /**
1167      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1168      * `recipient`, forwarding all available gas and reverting on errors.
1169      *
1170      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1171      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1172      * imposed by `transfer`, making them unable to receive funds via
1173      * `transfer`. {sendValue} removes this limitation.
1174      *
1175      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1176      *
1177      * IMPORTANT: because control is transferred to `recipient`, care must be
1178      * taken to not create reentrancy vulnerabilities. Consider using
1179      * {ReentrancyGuard} or the
1180      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1181      */
1182     function sendValue(address payable recipient, uint256 amount) internal {
1183         require(address(this).balance >= amount, "Address: insufficient balance");
1184 
1185         (bool success, ) = recipient.call{value: amount}("");
1186         require(success, "Address: unable to send value, recipient may have reverted");
1187     }
1188 
1189     /**
1190      * @dev Performs a Solidity function call using a low level `call`. A
1191      * plain `call` is an unsafe replacement for a function call: use this
1192      * function instead.
1193      *
1194      * If `target` reverts with a revert reason, it is bubbled up by this
1195      * function (like regular Solidity function calls).
1196      *
1197      * Returns the raw returned data. To convert to the expected return value,
1198      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1199      *
1200      * Requirements:
1201      *
1202      * - `target` must be a contract.
1203      * - calling `target` with `data` must not revert.
1204      *
1205      * _Available since v3.1._
1206      */
1207     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1208         return functionCall(target, data, "Address: low-level call failed");
1209     }
1210 
1211     /**
1212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1213      * `errorMessage` as a fallback revert reason when `target` reverts.
1214      *
1215      * _Available since v3.1._
1216      */
1217     function functionCall(
1218         address target,
1219         bytes memory data,
1220         string memory errorMessage
1221     ) internal returns (bytes memory) {
1222         return functionCallWithValue(target, data, 0, errorMessage);
1223     }
1224 
1225     /**
1226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1227      * but also transferring `value` wei to `target`.
1228      *
1229      * Requirements:
1230      *
1231      * - the calling contract must have an ETH balance of at least `value`.
1232      * - the called Solidity function must be `payable`.
1233      *
1234      * _Available since v3.1._
1235      */
1236     function functionCallWithValue(
1237         address target,
1238         bytes memory data,
1239         uint256 value
1240     ) internal returns (bytes memory) {
1241         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1242     }
1243 
1244     /**
1245      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1246      * with `errorMessage` as a fallback revert reason when `target` reverts.
1247      *
1248      * _Available since v3.1._
1249      */
1250     function functionCallWithValue(
1251         address target,
1252         bytes memory data,
1253         uint256 value,
1254         string memory errorMessage
1255     ) internal returns (bytes memory) {
1256         require(address(this).balance >= value, "Address: insufficient balance for call");
1257         require(isContract(target), "Address: call to non-contract");
1258 
1259         (bool success, bytes memory returndata) = target.call{value: value}(data);
1260         return verifyCallResult(success, returndata, errorMessage);
1261     }
1262 
1263     /**
1264      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1265      * but performing a static call.
1266      *
1267      * _Available since v3.3._
1268      */
1269     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1270         return functionStaticCall(target, data, "Address: low-level static call failed");
1271     }
1272 
1273     /**
1274      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1275      * but performing a static call.
1276      *
1277      * _Available since v3.3._
1278      */
1279     function functionStaticCall(
1280         address target,
1281         bytes memory data,
1282         string memory errorMessage
1283     ) internal view returns (bytes memory) {
1284         require(isContract(target), "Address: static call to non-contract");
1285 
1286         (bool success, bytes memory returndata) = target.staticcall(data);
1287         return verifyCallResult(success, returndata, errorMessage);
1288     }
1289 
1290     /**
1291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1292      * but performing a delegate call.
1293      *
1294      * _Available since v3.4._
1295      */
1296     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1297         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1298     }
1299 
1300     /**
1301      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1302      * but performing a delegate call.
1303      *
1304      * _Available since v3.4._
1305      */
1306     function functionDelegateCall(
1307         address target,
1308         bytes memory data,
1309         string memory errorMessage
1310     ) internal returns (bytes memory) {
1311         require(isContract(target), "Address: delegate call to non-contract");
1312 
1313         (bool success, bytes memory returndata) = target.delegatecall(data);
1314         return verifyCallResult(success, returndata, errorMessage);
1315     }
1316 
1317     /**
1318      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1319      * revert reason using the provided one.
1320      *
1321      * _Available since v4.3._
1322      */
1323     function verifyCallResult(
1324         bool success,
1325         bytes memory returndata,
1326         string memory errorMessage
1327     ) internal pure returns (bytes memory) {
1328         if (success) {
1329             return returndata;
1330         } else {
1331             // Look for revert reason and bubble it up if present
1332             if (returndata.length > 0) {
1333                 // The easiest way to bubble the revert reason is using memory via assembly
1334                 /// @solidity memory-safe-assembly
1335                 assembly {
1336                     let returndata_size := mload(returndata)
1337                     revert(add(32, returndata), returndata_size)
1338                 }
1339             } else {
1340                 revert(errorMessage);
1341             }
1342         }
1343     }
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1347 
1348 
1349 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 /**
1354  * @title ERC721 token receiver interface
1355  * @dev Interface for any contract that wants to support safeTransfers
1356  * from ERC721 asset contracts.
1357  */
1358 interface IERC721Receiver {
1359     /**
1360      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1361      * by `operator` from `from`, this function is called.
1362      *
1363      * It must return its Solidity selector to confirm the token transfer.
1364      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1365      *
1366      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1367      */
1368     function onERC721Received(
1369         address operator,
1370         address from,
1371         uint256 tokenId,
1372         bytes calldata data
1373     ) external returns (bytes4);
1374 }
1375 
1376 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 /**
1384  * @dev Interface of the ERC165 standard, as defined in the
1385  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1386  *
1387  * Implementers can declare support of contract interfaces, which can then be
1388  * queried by others ({ERC165Checker}).
1389  *
1390  * For an implementation, see {ERC165}.
1391  */
1392 interface IERC165 {
1393     /**
1394      * @dev Returns true if this contract implements the interface defined by
1395      * `interfaceId`. See the corresponding
1396      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1397      * to learn more about how these ids are created.
1398      *
1399      * This function call must use less than 30 000 gas.
1400      */
1401     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1402 }
1403 
1404 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1405 
1406 
1407 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 
1412 /**
1413  * @dev Implementation of the {IERC165} interface.
1414  *
1415  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1416  * for the additional interface id that will be supported. For example:
1417  *
1418  * ```solidity
1419  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1420  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1421  * }
1422  * ```
1423  *
1424  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1425  */
1426 abstract contract ERC165 is IERC165 {
1427     /**
1428      * @dev See {IERC165-supportsInterface}.
1429      */
1430     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1431         return interfaceId == type(IERC165).interfaceId;
1432     }
1433 }
1434 
1435 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1436 
1437 
1438 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1439 
1440 pragma solidity ^0.8.0;
1441 
1442 
1443 /**
1444  * @dev Required interface of an ERC721 compliant contract.
1445  */
1446 interface IERC721 is IERC165 {
1447     /**
1448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1449      */
1450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1451 
1452     /**
1453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1454      */
1455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1456 
1457     /**
1458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1459      */
1460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1461 
1462     /**
1463      * @dev Returns the number of tokens in ``owner``'s account.
1464      */
1465     function balanceOf(address owner) external view returns (uint256 balance);
1466 
1467     /**
1468      * @dev Returns the owner of the `tokenId` token.
1469      *
1470      * Requirements:
1471      *
1472      * - `tokenId` must exist.
1473      */
1474     function ownerOf(uint256 tokenId) external view returns (address owner);
1475 
1476     /**
1477      * @dev Safely transfers `tokenId` token from `from` to `to`.
1478      *
1479      * Requirements:
1480      *
1481      * - `from` cannot be the zero address.
1482      * - `to` cannot be the zero address.
1483      * - `tokenId` token must exist and be owned by `from`.
1484      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1485      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function safeTransferFrom(
1490         address from,
1491         address to,
1492         uint256 tokenId,
1493         bytes calldata data
1494     ) external;
1495 
1496     /**
1497      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1498      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1499      *
1500      * Requirements:
1501      *
1502      * - `from` cannot be the zero address.
1503      * - `to` cannot be the zero address.
1504      * - `tokenId` token must exist and be owned by `from`.
1505      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1506      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1507      *
1508      * Emits a {Transfer} event.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId
1514     ) external;
1515 
1516     /**
1517      * @dev Transfers `tokenId` token from `from` to `to`.
1518      *
1519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1520      *
1521      * Requirements:
1522      *
1523      * - `from` cannot be the zero address.
1524      * - `to` cannot be the zero address.
1525      * - `tokenId` token must be owned by `from`.
1526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1527      *
1528      * Emits a {Transfer} event.
1529      */
1530     function transferFrom(
1531         address from,
1532         address to,
1533         uint256 tokenId
1534     ) external;
1535 
1536     /**
1537      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1538      * The approval is cleared when the token is transferred.
1539      *
1540      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1541      *
1542      * Requirements:
1543      *
1544      * - The caller must own the token or be an approved operator.
1545      * - `tokenId` must exist.
1546      *
1547      * Emits an {Approval} event.
1548      */
1549     function approve(address to, uint256 tokenId) external;
1550 
1551     /**
1552      * @dev Approve or remove `operator` as an operator for the caller.
1553      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1554      *
1555      * Requirements:
1556      *
1557      * - The `operator` cannot be the caller.
1558      *
1559      * Emits an {ApprovalForAll} event.
1560      */
1561     function setApprovalForAll(address operator, bool _approved) external;
1562 
1563     /**
1564      * @dev Returns the account approved for `tokenId` token.
1565      *
1566      * Requirements:
1567      *
1568      * - `tokenId` must exist.
1569      */
1570     function getApproved(uint256 tokenId) external view returns (address operator);
1571 
1572     /**
1573      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1574      *
1575      * See {setApprovalForAll}
1576      */
1577     function isApprovedForAll(address owner, address operator) external view returns (bool);
1578 }
1579 
1580 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1581 
1582 
1583 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 
1588 /**
1589  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1590  * @dev See https://eips.ethereum.org/EIPS/eip-721
1591  */
1592 interface IERC721Enumerable is IERC721 {
1593     /**
1594      * @dev Returns the total amount of tokens stored by the contract.
1595      */
1596     function totalSupply() external view returns (uint256);
1597 
1598     /**
1599      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1600      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1601      */
1602     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1603 
1604     /**
1605      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1606      * Use along with {totalSupply} to enumerate all tokens.
1607      */
1608     function tokenByIndex(uint256 index) external view returns (uint256);
1609 }
1610 
1611 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1612 
1613 
1614 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1615 
1616 pragma solidity ^0.8.0;
1617 
1618 
1619 /**
1620  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1621  * @dev See https://eips.ethereum.org/EIPS/eip-721
1622  */
1623 interface IERC721Metadata is IERC721 {
1624     /**
1625      * @dev Returns the token collection name.
1626      */
1627     function name() external view returns (string memory);
1628 
1629     /**
1630      * @dev Returns the token collection symbol.
1631      */
1632     function symbol() external view returns (string memory);
1633 
1634     /**
1635      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1636      */
1637     function tokenURI(uint256 tokenId) external view returns (string memory);
1638 }
1639 
1640 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1641 
1642 
1643 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1644 
1645 pragma solidity ^0.8.0;
1646 
1647 
1648 
1649 
1650 
1651 
1652 
1653 
1654 /**
1655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1656  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1657  * {ERC721Enumerable}.
1658  */
1659 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1660     using Address for address;
1661     using Strings for uint256;
1662 
1663     // Token name
1664     string private _name;
1665 
1666     // Token symbol
1667     string private _symbol;
1668 
1669     // Mapping from token ID to owner address
1670     mapping(uint256 => address) private _owners;
1671 
1672     // Mapping owner address to token count
1673     mapping(address => uint256) private _balances;
1674 
1675     // Mapping from token ID to approved address
1676     mapping(uint256 => address) private _tokenApprovals;
1677 
1678     // Mapping from owner to operator approvals
1679     mapping(address => mapping(address => bool)) private _operatorApprovals;
1680 
1681     /**
1682      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1683      */
1684     constructor(string memory name_, string memory symbol_) {
1685         _name = name_;
1686         _symbol = symbol_;
1687     }
1688 
1689     /**
1690      * @dev See {IERC165-supportsInterface}.
1691      */
1692     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1693         return
1694             interfaceId == type(IERC721).interfaceId ||
1695             interfaceId == type(IERC721Metadata).interfaceId ||
1696             super.supportsInterface(interfaceId);
1697     }
1698 
1699     /**
1700      * @dev See {IERC721-balanceOf}.
1701      */
1702     function balanceOf(address owner) public view virtual override returns (uint256) {
1703         require(owner != address(0), "ERC721: address zero is not a valid owner");
1704         return _balances[owner];
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-ownerOf}.
1709      */
1710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1711         address owner = _owners[tokenId];
1712         require(owner != address(0), "ERC721: invalid token ID");
1713         return owner;
1714     }
1715 
1716     /**
1717      * @dev See {IERC721Metadata-name}.
1718      */
1719     function name() public view virtual override returns (string memory) {
1720         return _name;
1721     }
1722 
1723     /**
1724      * @dev See {IERC721Metadata-symbol}.
1725      */
1726     function symbol() public view virtual override returns (string memory) {
1727         return _symbol;
1728     }
1729 
1730     /**
1731      * @dev See {IERC721Metadata-tokenURI}.
1732      */
1733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1734         _requireMinted(tokenId);
1735 
1736         string memory baseURI = _baseURI();
1737         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1738     }
1739 
1740     /**
1741      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1742      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1743      * by default, can be overridden in child contracts.
1744      */
1745     function _baseURI() internal view virtual returns (string memory) {
1746         return "";
1747     }
1748 
1749     /**
1750      * @dev See {IERC721-approve}.
1751      */
1752     function approve(address to, uint256 tokenId) public virtual override {
1753         address owner = ERC721.ownerOf(tokenId);
1754         require(to != owner, "ERC721: approval to current owner");
1755 
1756         require(
1757             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1758             "ERC721: approve caller is not token owner nor approved for all"
1759         );
1760 
1761         _approve(to, tokenId);
1762     }
1763 
1764     /**
1765      * @dev See {IERC721-getApproved}.
1766      */
1767     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1768         _requireMinted(tokenId);
1769 
1770         return _tokenApprovals[tokenId];
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-setApprovalForAll}.
1775      */
1776     function setApprovalForAll(address operator, bool approved) public virtual override {
1777         _setApprovalForAll(_msgSender(), operator, approved);
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-isApprovedForAll}.
1782      */
1783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1784         return _operatorApprovals[owner][operator];
1785     }
1786 
1787     /**
1788      * @dev See {IERC721-transferFrom}.
1789      */
1790     function transferFrom(
1791         address from,
1792         address to,
1793         uint256 tokenId
1794     ) public virtual override {
1795         //solhint-disable-next-line max-line-length
1796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1797 
1798         _transfer(from, to, tokenId);
1799     }
1800 
1801     /**
1802      * @dev See {IERC721-safeTransferFrom}.
1803      */
1804     function safeTransferFrom(
1805         address from,
1806         address to,
1807         uint256 tokenId
1808     ) public virtual override {
1809         safeTransferFrom(from, to, tokenId, "");
1810     }
1811 
1812     /**
1813      * @dev See {IERC721-safeTransferFrom}.
1814      */
1815     function safeTransferFrom(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory data
1820     ) public virtual override {
1821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1822         _safeTransfer(from, to, tokenId, data);
1823     }
1824 
1825     /**
1826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1828      *
1829      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1830      *
1831      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1832      * implement alternative mechanisms to perform token transfer, such as signature-based.
1833      *
1834      * Requirements:
1835      *
1836      * - `from` cannot be the zero address.
1837      * - `to` cannot be the zero address.
1838      * - `tokenId` token must exist and be owned by `from`.
1839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1840      *
1841      * Emits a {Transfer} event.
1842      */
1843     function _safeTransfer(
1844         address from,
1845         address to,
1846         uint256 tokenId,
1847         bytes memory data
1848     ) internal virtual {
1849         _transfer(from, to, tokenId);
1850         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1851     }
1852 
1853     /**
1854      * @dev Returns whether `tokenId` exists.
1855      *
1856      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1857      *
1858      * Tokens start existing when they are minted (`_mint`),
1859      * and stop existing when they are burned (`_burn`).
1860      */
1861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1862         return _owners[tokenId] != address(0);
1863     }
1864 
1865     /**
1866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1867      *
1868      * Requirements:
1869      *
1870      * - `tokenId` must exist.
1871      */
1872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1873         address owner = ERC721.ownerOf(tokenId);
1874         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1875     }
1876 
1877     /**
1878      * @dev Safely mints `tokenId` and transfers it to `to`.
1879      *
1880      * Requirements:
1881      *
1882      * - `tokenId` must not exist.
1883      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1884      *
1885      * Emits a {Transfer} event.
1886      */
1887     function _safeMint(address to, uint256 tokenId) internal virtual {
1888         _safeMint(to, tokenId, "");
1889     }
1890 
1891     /**
1892      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1893      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1894      */
1895     function _safeMint(
1896         address to,
1897         uint256 tokenId,
1898         bytes memory data
1899     ) internal virtual {
1900         _mint(to, tokenId);
1901         require(
1902             _checkOnERC721Received(address(0), to, tokenId, data),
1903             "ERC721: transfer to non ERC721Receiver implementer"
1904         );
1905     }
1906 
1907     /**
1908      * @dev Mints `tokenId` and transfers it to `to`.
1909      *
1910      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1911      *
1912      * Requirements:
1913      *
1914      * - `tokenId` must not exist.
1915      * - `to` cannot be the zero address.
1916      *
1917      * Emits a {Transfer} event.
1918      */
1919     function _mint(address to, uint256 tokenId) internal virtual {
1920         require(to != address(0), "ERC721: mint to the zero address");
1921         require(!_exists(tokenId), "ERC721: token already minted");
1922 
1923         _beforeTokenTransfer(address(0), to, tokenId);
1924 
1925         _balances[to] += 1;
1926         _owners[tokenId] = to;
1927 
1928         emit Transfer(address(0), to, tokenId);
1929 
1930         _afterTokenTransfer(address(0), to, tokenId);
1931     }
1932 
1933     /**
1934      * @dev Destroys `tokenId`.
1935      * The approval is cleared when the token is burned.
1936      *
1937      * Requirements:
1938      *
1939      * - `tokenId` must exist.
1940      *
1941      * Emits a {Transfer} event.
1942      */
1943     function _burn(uint256 tokenId) internal virtual {
1944         address owner = ERC721.ownerOf(tokenId);
1945 
1946         _beforeTokenTransfer(owner, address(0), tokenId);
1947 
1948         // Clear approvals
1949         _approve(address(0), tokenId);
1950 
1951         _balances[owner] -= 1;
1952         delete _owners[tokenId];
1953 
1954         emit Transfer(owner, address(0), tokenId);
1955 
1956         _afterTokenTransfer(owner, address(0), tokenId);
1957     }
1958 
1959     /**
1960      * @dev Transfers `tokenId` from `from` to `to`.
1961      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1962      *
1963      * Requirements:
1964      *
1965      * - `to` cannot be the zero address.
1966      * - `tokenId` token must be owned by `from`.
1967      *
1968      * Emits a {Transfer} event.
1969      */
1970     function _transfer(
1971         address from,
1972         address to,
1973         uint256 tokenId
1974     ) internal virtual {
1975         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1976         require(to != address(0), "ERC721: transfer to the zero address");
1977 
1978         _beforeTokenTransfer(from, to, tokenId);
1979 
1980         // Clear approvals from the previous owner
1981         _approve(address(0), tokenId);
1982 
1983         _balances[from] -= 1;
1984         _balances[to] += 1;
1985         _owners[tokenId] = to;
1986 
1987         emit Transfer(from, to, tokenId);
1988 
1989         _afterTokenTransfer(from, to, tokenId);
1990     }
1991 
1992     /**
1993      * @dev Approve `to` to operate on `tokenId`
1994      *
1995      * Emits an {Approval} event.
1996      */
1997     function _approve(address to, uint256 tokenId) internal virtual {
1998         _tokenApprovals[tokenId] = to;
1999         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2000     }
2001 
2002     /**
2003      * @dev Approve `operator` to operate on all of `owner` tokens
2004      *
2005      * Emits an {ApprovalForAll} event.
2006      */
2007     function _setApprovalForAll(
2008         address owner,
2009         address operator,
2010         bool approved
2011     ) internal virtual {
2012         require(owner != operator, "ERC721: approve to caller");
2013         _operatorApprovals[owner][operator] = approved;
2014         emit ApprovalForAll(owner, operator, approved);
2015     }
2016 
2017     /**
2018      * @dev Reverts if the `tokenId` has not been minted yet.
2019      */
2020     function _requireMinted(uint256 tokenId) internal view virtual {
2021         require(_exists(tokenId), "ERC721: invalid token ID");
2022     }
2023 
2024     /**
2025      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2026      * The call is not executed if the target address is not a contract.
2027      *
2028      * @param from address representing the previous owner of the given token ID
2029      * @param to target address that will receive the tokens
2030      * @param tokenId uint256 ID of the token to be transferred
2031      * @param data bytes optional data to send along with the call
2032      * @return bool whether the call correctly returned the expected magic value
2033      */
2034     function _checkOnERC721Received(
2035         address from,
2036         address to,
2037         uint256 tokenId,
2038         bytes memory data
2039     ) private returns (bool) {
2040         if (to.isContract()) {
2041             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2042                 return retval == IERC721Receiver.onERC721Received.selector;
2043             } catch (bytes memory reason) {
2044                 if (reason.length == 0) {
2045                     revert("ERC721: transfer to non ERC721Receiver implementer");
2046                 } else {
2047                     /// @solidity memory-safe-assembly
2048                     assembly {
2049                         revert(add(32, reason), mload(reason))
2050                     }
2051                 }
2052             }
2053         } else {
2054             return true;
2055         }
2056     }
2057 
2058     /**
2059      * @dev Hook that is called before any token transfer. This includes minting
2060      * and burning.
2061      *
2062      * Calling conditions:
2063      *
2064      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2065      * transferred to `to`.
2066      * - When `from` is zero, `tokenId` will be minted for `to`.
2067      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2068      * - `from` and `to` are never both zero.
2069      *
2070      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2071      */
2072     function _beforeTokenTransfer(
2073         address from,
2074         address to,
2075         uint256 tokenId
2076     ) internal virtual {}
2077 
2078     /**
2079      * @dev Hook that is called after any transfer of tokens. This includes
2080      * minting and burning.
2081      *
2082      * Calling conditions:
2083      *
2084      * - when `from` and `to` are both non-zero.
2085      * - `from` and `to` are never both zero.
2086      *
2087      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2088      */
2089     function _afterTokenTransfer(
2090         address from,
2091         address to,
2092         uint256 tokenId
2093     ) internal virtual {}
2094 }
2095 
2096 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
2097 
2098 
2099 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
2100 
2101 pragma solidity ^0.8.0;
2102 
2103 
2104 
2105 /**
2106  * @title ERC721 Burnable Token
2107  * @dev ERC721 Token that can be burned (destroyed).
2108  */
2109 abstract contract ERC721Burnable is Context, ERC721 {
2110     /**
2111      * @dev Burns `tokenId`. See {ERC721-_burn}.
2112      *
2113      * Requirements:
2114      *
2115      * - The caller must own `tokenId` or be an approved operator.
2116      */
2117     function burn(uint256 tokenId) public virtual {
2118         //solhint-disable-next-line max-line-length
2119         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2120         _burn(tokenId);
2121     }
2122 }
2123 
2124 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
2125 
2126 
2127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
2128 
2129 pragma solidity ^0.8.0;
2130 
2131 
2132 
2133 /**
2134  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2135  * enumerability of all the token ids in the contract as well as all token ids owned by each
2136  * account.
2137  */
2138 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2139     // Mapping from owner to list of owned token IDs
2140     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2141 
2142     // Mapping from token ID to index of the owner tokens list
2143     mapping(uint256 => uint256) private _ownedTokensIndex;
2144 
2145     // Array with all token ids, used for enumeration
2146     uint256[] private _allTokens;
2147 
2148     // Mapping from token id to position in the allTokens array
2149     mapping(uint256 => uint256) private _allTokensIndex;
2150 
2151     /**
2152      * @dev See {IERC165-supportsInterface}.
2153      */
2154     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2155         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2156     }
2157 
2158     /**
2159      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2160      */
2161     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2162         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2163         return _ownedTokens[owner][index];
2164     }
2165 
2166     /**
2167      * @dev See {IERC721Enumerable-totalSupply}.
2168      */
2169     function totalSupply() public view virtual override returns (uint256) {
2170         return _allTokens.length;
2171     }
2172 
2173     /**
2174      * @dev See {IERC721Enumerable-tokenByIndex}.
2175      */
2176     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2177         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2178         return _allTokens[index];
2179     }
2180 
2181     /**
2182      * @dev Hook that is called before any token transfer. This includes minting
2183      * and burning.
2184      *
2185      * Calling conditions:
2186      *
2187      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2188      * transferred to `to`.
2189      * - When `from` is zero, `tokenId` will be minted for `to`.
2190      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2191      * - `from` cannot be the zero address.
2192      * - `to` cannot be the zero address.
2193      *
2194      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2195      */
2196     function _beforeTokenTransfer(
2197         address from,
2198         address to,
2199         uint256 tokenId
2200     ) internal virtual override {
2201         super._beforeTokenTransfer(from, to, tokenId);
2202 
2203         if (from == address(0)) {
2204             _addTokenToAllTokensEnumeration(tokenId);
2205         } else if (from != to) {
2206             _removeTokenFromOwnerEnumeration(from, tokenId);
2207         }
2208         if (to == address(0)) {
2209             _removeTokenFromAllTokensEnumeration(tokenId);
2210         } else if (to != from) {
2211             _addTokenToOwnerEnumeration(to, tokenId);
2212         }
2213     }
2214 
2215     /**
2216      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2217      * @param to address representing the new owner of the given token ID
2218      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2219      */
2220     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2221         uint256 length = ERC721.balanceOf(to);
2222         _ownedTokens[to][length] = tokenId;
2223         _ownedTokensIndex[tokenId] = length;
2224     }
2225 
2226     /**
2227      * @dev Private function to add a token to this extension's token tracking data structures.
2228      * @param tokenId uint256 ID of the token to be added to the tokens list
2229      */
2230     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2231         _allTokensIndex[tokenId] = _allTokens.length;
2232         _allTokens.push(tokenId);
2233     }
2234 
2235     /**
2236      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2237      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2238      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2239      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2240      * @param from address representing the previous owner of the given token ID
2241      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2242      */
2243     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2244         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2245         // then delete the last slot (swap and pop).
2246 
2247         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2248         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2249 
2250         // When the token to delete is the last token, the swap operation is unnecessary
2251         if (tokenIndex != lastTokenIndex) {
2252             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2253 
2254             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2255             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2256         }
2257 
2258         // This also deletes the contents at the last position of the array
2259         delete _ownedTokensIndex[tokenId];
2260         delete _ownedTokens[from][lastTokenIndex];
2261     }
2262 
2263     /**
2264      * @dev Private function to remove a token from this extension's token tracking data structures.
2265      * This has O(1) time complexity, but alters the order of the _allTokens array.
2266      * @param tokenId uint256 ID of the token to be removed from the tokens list
2267      */
2268     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2269         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2270         // then delete the last slot (swap and pop).
2271 
2272         uint256 lastTokenIndex = _allTokens.length - 1;
2273         uint256 tokenIndex = _allTokensIndex[tokenId];
2274 
2275         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2276         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2277         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2278         uint256 lastTokenId = _allTokens[lastTokenIndex];
2279 
2280         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2281         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2282 
2283         // This also deletes the contents at the last position of the array
2284         delete _allTokensIndex[tokenId];
2285         _allTokens.pop();
2286     }
2287 }
2288 
2289 // File: Wiiides.sol
2290 
2291 
2292 
2293 //
2294 //      Wiiides 
2295 //      
2296 //      @sterlingcrispin 
2297 //      @wiiides
2298 //      wiiides.com
2299 //      NotAudited.xyz
2300 //  
2301 //      no warranty expressed or implied
2302 //      see wiiides.com for important terms of service
2303 //
2304 //
2305 //
2306 //  
2307 //                                              
2308 //                                        WIIIIIIIIIIIIIIIIIIIIIIDE             
2309 //                           WIIIIIIIIIIDE------------WIIIIIIIIIIDE             
2310 //              WIIIIIIIIIIIDE------------------------WIIIIIIIIIIDE             
2311 //              wiiiiiiiiiiide------------------------WIIIIIIIIIIDE             
2312 //  WIIIIIIIIIIDE,,,,,,,,,,,,-------------------------WIIIIIIIIIIDE             
2313 //  ,,,,,,,,,,,,,-------------------------------------WIIIIIIIIIIIIIIIIIIIIIIIDE
2314 //  .........................-------------------------.........................W
2315 //  ,,,,,,,,,,,,,........................-------------.........................I
2316 //  ,,,,,,,,,,,,,........................-------------.........................I
2317 //  ...........................................................................I
2318 //  ...........................................................................D
2319 //  ...........................................................................E
2320 //  wiiiiiiide..................................................................
2321 //  wiiiiiiiiiiiiiiiiiiiiiide......................................wiiiiiiiiiide
2322 //  WIIIIIIIIIIDE,,,,,,,,,,,,,.....................................WIIIIIIIIIIDE
2323 //  ...........................................................................W
2324 //  ...........................................................................I
2325 //  .....................................wiiiiiiiiiiiiiiiiiiiiiiide............I
2326 //  .....................................WIIIIIIIIIIIIIIIIIIIIIIIDE............I
2327 //  ...........................................................................I
2328 //  ...........WIIIIIIIIIIIDE..................................................I
2329 //  .........................WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE............I
2330 //  .........................WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE............I
2331 //  ...........................................................................D
2332 //  ...........................................................................E
2333 //  ...........WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE
2334 //  ...........WIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDE
2335 //  ...........WIIIIIIIIIIIIDE 
2336 //  ...........WIIIIIIIIIIIIDE 
2337 //  
2338 //
2339 pragma solidity ^0.8.12;
2340 pragma abicoder v2;
2341 
2342 
2343 
2344 
2345 
2346 
2347 
2348 
2349 abstract contract CryptoPunksMarket {
2350     mapping (uint => address) public punkIndexToAddress;
2351 }
2352 
2353 abstract contract CryptoPunksData{
2354     function punkAttributes(uint16 index) external view returns (string memory text) {}
2355     function punkImageSvg(uint16 index) external view returns (string memory svg) {}
2356 }
2357 
2358 abstract contract BrainWorms {
2359     function uMad(uint256 idx) external pure returns (string memory madResult) {}
2360     function bigMad(uint256 idx) external pure returns (string memory bigMadResult) {}
2361 }
2362 
2363 abstract contract Lockout is ERC721 {}
2364 abstract contract UsrMessage is ERC721 {}
2365 abstract contract IdeasOfMountains is ERC721 {}
2366 abstract contract Neophyte is ERC721 {}
2367 
2368 contract Wiiides is
2369     ERC721Enumerable,
2370     ERC721Burnable,
2371     ReentrancyGuard,
2372     Ownable
2373 {
2374     using Strings for uint256;
2375     using strings for *;                                                       
2376 
2377     constructor() ERC721 ("Wiiides", "Wiiides") {}
2378 
2379     // Crypto punks
2380     CryptoPunksMarket cryptoPunks;
2381     CryptoPunksData cryptoPunksData;
2382 
2383     // Some of my previous projects
2384     ERC721[] prevProjects;
2385     mapping(ERC721 => mapping(uint256 => bool)) prevProjectsClaimed;
2386 
2387     // Got Brainworms?
2388     BrainWorms brainWorms;
2389 
2390     // Currency
2391     uint256 public MINT_PRICE_FIVE = 0.075 ether; // 0.015 each
2392     uint256 public MINT_PRICE_SIXNINE = 0.69 ether; // 0.01 each
2393     address payable public withdrawalAddress;
2394 
2395     // Minting states
2396     bool public mintActive = false;
2397     bool public claimActive = false;
2398 
2399     uint256 public constant maxSupply = 10000;
2400     mapping(uint256 => uint256) private tokenOrder;
2401     uint256 tokenOrderRange = 0;
2402     uint256 nextMintIdx = 0;
2403 
2404     // Token features
2405     uint256 maxWidth = 6000;
2406     mapping(uint256 => uint256) public tokenWidth;
2407     mapping(uint256 => bool) public uMad;
2408     bool public bigMad;
2409     bytes desc;
2410 
2411     modifier callerIsUser() {
2412         require(tx.origin == msg.sender, "The caller is another contract");
2413         _;
2414     }
2415     // Because people can claim ID's with their punk 
2416     // ahead of the mint sequence,
2417     // I need to find the next available unclaimed token.
2418     // I don't expect thousands of people to claim out of sequence,
2419     // otherwise I would rewrite this to be more gas efficient
2420     function _mint() internal {
2421         uint256 tokenToMint;
2422         while(true){
2423             // pseudo random mint pattern by sampling from a list of random non-repeating integers
2424             unchecked{
2425                 tokenToMint = tokenOrder[nextMintIdx%tokenOrderRange] + (nextMintIdx/tokenOrderRange) * tokenOrderRange;
2426             }
2427             if(tokenWidth[tokenToMint] == 0 ){
2428                 tokenWidth[tokenToMint] = randWidth(tokenToMint);
2429                 _safeMint(msg.sender, tokenToMint);
2430                 unchecked{
2431                     nextMintIdx++;
2432                 }
2433                 break;
2434             } 
2435             unchecked{
2436                 nextMintIdx++;
2437             }
2438         }
2439 
2440     }
2441 
2442     // mint the next available token 
2443     function mintOne() public nonReentrant callerIsUser {
2444         require(
2445             mintActive, 
2446             "mint not active"
2447         );
2448         require(
2449             balanceOf(msg.sender) + 1 <= 2,
2450             "limit 2 free mints"
2451         );
2452         require(
2453             totalSupply() + 1 <= maxSupply,
2454             "Request to mint tokens exceeds supply"
2455         );
2456         _mint();
2457     }
2458 
2459     // mint five
2460     function mintFive() external payable nonReentrant callerIsUser {
2461         require(
2462             balanceOf(msg.sender) + 5 <= 12,
2463             "you own too many"
2464         );
2465         require(
2466             msg.value >= MINT_PRICE_FIVE,
2467             "Eth sent too low"
2468         );
2469         require(
2470             mintActive, 
2471             "mint not active"
2472         );
2473         require(
2474             totalSupply() + 5 <= maxSupply,
2475             "Request to mint tokens exceeds supply"
2476         );
2477         uint256 i;
2478         while (i < 5) {
2479             _mint();
2480             unchecked{
2481                 i++;
2482             }
2483         }
2484     }
2485 
2486     // mint 69
2487     function mintSixtyNine() external payable nonReentrant callerIsUser {
2488         require(
2489             balanceOf(msg.sender) + 69 <= 75,
2490             "you own too many"
2491         );
2492         require(
2493             msg.value >= MINT_PRICE_SIXNINE,
2494             "Eth sent too low"
2495         );
2496         require(
2497             mintActive, 
2498             "mint not active"
2499         );
2500         require(
2501             totalSupply() + 69 <= maxSupply,
2502             "Request to mint tokens exceeds supply"
2503         );
2504         uint256 i;
2505         while (i < 69) {
2506             _mint();
2507             unchecked{
2508                 i++;
2509             }
2510         }
2511     }
2512 
2513     // claim any token by the ID if you're a Crypto Punk holder
2514     function claimTokenByPunkId(uint256 id) external nonReentrant callerIsUser {
2515         require(
2516             claimActive == true,
2517             "claim not active"
2518         );
2519         require(
2520             tokenWidth[id] == 0, 
2521             "can't claim already minted"
2522         );
2523         // this address check gives me authority to airdrop people their Wiiide, 
2524         // if they don't want to interact with this contract out of paranoia
2525         if(msg.sender != withdrawalAddress){
2526             require(
2527                 cryptoPunks.punkIndexToAddress(id) == msg.sender,
2528                 "not your punk"
2529             );
2530         }
2531         require(
2532             totalSupply() + 1 <= maxSupply,
2533             "Request to mint tokens exceeds supply"
2534         );
2535         tokenWidth[id] = randWidth(id);
2536         _safeMint(msg.sender, id);
2537     }
2538 
2539     // claim by one of my previous projects
2540     function claimTokenByProject(uint256 id, uint256 projectIndex) external nonReentrant callerIsUser{
2541         require(
2542             claimActive == true,
2543             "claim not active"
2544         );
2545         require(
2546             balanceOf(msg.sender) + 5 <= 75,
2547             "you own too many"
2548         );
2549         require(
2550             prevProjects[projectIndex].ownerOf(id) == msg.sender,
2551             "not your token"
2552         );
2553         require(
2554             prevProjectsClaimed[prevProjects[projectIndex]][id] == false,
2555             "token already claimed"
2556         );
2557         // make sure it's in the neophyte token sequence
2558         if(projectIndex==3){
2559             require(
2560                 id >= 279000000 && id <= 279000167,
2561                 "neophyte id out of range"
2562             );
2563         }
2564         require(
2565             totalSupply() + 5 <= maxSupply,
2566             "Request to mint tokens exceeds supply"
2567         );
2568         prevProjectsClaimed[prevProjects[projectIndex]][id] = true;
2569         uint256 i;
2570         while (i < 5) {
2571             _mint();
2572             unchecked{
2573                 i++;
2574             }
2575         }
2576     }
2577    
2578     // reset the stretch if you're the wiiide holder
2579     // most people wont bother doing this and the whole collection will trend to oblivion
2580     // but maybe its nice to give some people a little control 
2581     function tokenOwnerResetStretch(uint256 id) external {
2582         require(
2583             ownerOf(id) == msg.sender,
2584             "not your wiiide"
2585             );
2586         tokenWidth[id] = randWidth(id);
2587     }
2588     
2589     // break the trait up from 'Mohawk' into 'M' 'Hawk', and jam some extra o's in there
2590     function splitTraitHalf(strings.slice memory secondHalf,string memory delim) internal pure returns(string memory result){
2591         if(secondHalf.endsWith(delim.toSlice())){
2592             secondHalf = string.concat(secondHalf.toString(), delim,delim).toSlice();
2593         }
2594         strings.slice memory firstHalf = secondHalf.split(delim.toSlice());
2595         if(secondHalf.len()>0){
2596             result = string.concat(firstHalf.toString(),delim,delim,delim,secondHalf.toString());
2597         } else {
2598             result = "";
2599         }
2600         
2601     }
2602 
2603     // attempt to replace letters in the trait we're going to repeat
2604     function splitTrait(string memory stringToSplit) internal pure returns(string memory result){
2605 
2606         result = splitTraitHalf(stringToSplit.toSlice(),"o");
2607 
2608         if(bytes(result).length==0){
2609             result = splitTraitHalf(stringToSplit.toSlice(),"a");
2610         }
2611         if(bytes(result).length==0){
2612             result = splitTraitHalf(stringToSplit.toSlice(),"e");
2613         }
2614         if(bytes(result).length==0){
2615             result = string.concat(stringToSplit,"RRR");
2616         }
2617         return result;
2618     }   
2619 
2620     // generate Wiiides
2621     function tokenURI(uint256 tokenId)
2622         public
2623         view
2624         virtual
2625         override
2626         returns (string memory)
2627     {
2628         // I really don't want to resort to using these but I might be forced to
2629         if(bigMad){
2630             return brainWorms.bigMad(tokenId);
2631         }
2632         if(uMad[tokenId]){
2633             return brainWorms.uMad(tokenId);
2634         }
2635 
2636         // get the SVG
2637         string memory punkSVG = cryptoPunksData.punkImageSvg(uint16(tokenId));
2638         strings.slice memory slicePunk = punkSVG.toSlice();            
2639         // cut the head off
2640         slicePunk.beyond("data:image/svg+xml;utf8,<svg".toSlice());
2641 
2642         // future proofing max width for browser issues
2643         uint256 tempInt = tokenWidth[tokenId];
2644         if(tempInt > maxWidth){
2645             tempInt = maxWidth;
2646         }
2647 
2648         string[7] memory parts;
2649         // replace the svg head of the svg with a stretched style and filled background etc
2650         parts[0] = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none"><rect width="100%" height="100%" fill="#6a8494"/><svg x="-';
2651         // the new x offset so the wiiide stays centered
2652         parts[1] = Strings.toString((tempInt-500)/2);
2653         parts[2] = '" width="';
2654         // the new stretched width
2655         parts[3] = Strings.toString(tempInt);
2656         parts[4] = '" height="100%" preserveAspectRatio="none" ';
2657         // reattach the svg head
2658         parts[5] = slicePunk.toString();
2659         parts[6] = '</svg>';
2660 
2661        // get attributes which come in as a string like "Male 1, Smile, Mohawk"
2662         string memory attrs = cryptoPunksData.punkAttributes(uint16(tokenId));
2663         strings.slice memory sliceAttr = attrs.toSlice();            
2664         strings.slice memory delimAttr = ", ".toSlice();     
2665 
2666         // break up that string into an array of independent values
2667         string[] memory attrParts = new string[](sliceAttr.count(delimAttr)+1); 
2668         for (uint i = 0; i < attrParts.length; i++) {                              
2669            attrParts[i] = sliceAttr.split(delimAttr).toString();                               
2670         }    
2671      
2672         string memory output = string.concat(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6]);
2673         string memory trait = string.concat('","attributes": [{"trait_type": "Tyyype","value": "', splitTrait(attrParts[0]) , '"}');
2674         
2675         // all the accessories
2676         for(uint256 i = 1; i < attrParts.length; i++){
2677             trait = string.concat(trait,',{"trait_type": "Stuuuff","value": "', splitTrait(attrParts[i]), '"}');
2678         }
2679         // count the traits
2680         trait = string.concat(trait,',{"trait_type": "Stuuuff","value": "',  Strings.toString(attrParts.length-1)  , ' Tings"}');
2681         // show how stretched they are
2682         attrs = "i";
2683         uint256 count = 1;
2684         while(count < (tempInt/500)*100){
2685             attrs = string.concat(attrs, "i");
2686             count += 100;
2687         }
2688         trait = string.concat(trait,',{"trait_type": "Wiiidth","value": "Wi', attrs , 'de"}');
2689 
2690         // build the metadata and encode the image as base64
2691         string memory json = Base64.encode(bytes(string.concat('{"name": "Wiiide #', Strings.toString(tokenId),trait, '], "description": "',string(desc),'", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}')));
2692         // encode all of that as base64 and deliver the final TokenURI
2693         output = string(abi.encodePacked('data:application/json;base64,', json));
2694 
2695         return output;
2696     }
2697 
2698     // random width of tokens
2699     function randWidth(uint256 idx) internal view returns(uint256){
2700         unchecked{
2701             return rand(((idx%6)+1)*250,totalSupply()) + 550 ;
2702         }
2703     }
2704 
2705     // this is not a good random number generator but it's good enough for this
2706     function rand(uint256 num, uint256 swerve) internal view returns (uint256) {
2707         return  uint256(keccak256(abi.encodePacked( block.timestamp, num, swerve))) % num;
2708     }
2709 
2710     // free mint for myself 
2711     function authorMint(uint256 _amountToMint) external onlyOwner {
2712         require(
2713             totalSupply() + _amountToMint <= maxSupply,
2714             "Request to mint tokens exceeds supply"
2715         );
2716         uint256 i;
2717         while (i < _amountToMint) {
2718             _mint();
2719             unchecked{
2720                 i++;
2721             }
2722         }
2723     }
2724 
2725     // set mint prices
2726     function authorSetMintPrices(uint256 newMintPriceFive, uint256 newMintPriceSixNine) external onlyOwner {
2727         require(
2728             newMintPriceFive > 0.01 ether,
2729             "wrong units"
2730         );
2731         require(
2732             newMintPriceSixNine > 0.01 ether,
2733             "wrong units"
2734         );
2735         MINT_PRICE_FIVE = newMintPriceFive;
2736         MINT_PRICE_SIXNINE = newMintPriceSixNine;
2737     }
2738     
2739     // this avoids having to pre-populate a giant array
2740     // where the value stored at an index is equal to the index
2741     function getSwapIdx(uint256 idx) private view returns(uint256){
2742         // the index to swap with
2743         if(tokenOrder[idx] !=0){
2744             // there's actually a value there
2745             return tokenOrder[idx];
2746         } else{
2747             // no value has been assigned 
2748             // so by default the value is the index
2749             return idx;
2750         }
2751     }
2752 
2753     // Non repeating integers via Fischer Yates Shuffle
2754     // this isn't a high security way of doing this,
2755     // as I'm just going to store the shuffle order as a private variable
2756     // and anyone determined enough could read it, and mint the wiiides
2757     // that are rarest. But most people won't bother or know how.
2758     // And if you're really that determined to exploit such a 
2759     // goofy project, maybe you should be doing MEV or something instead,
2760     // or go buy a mountain bike and touch grass
2761     function authorInitTokenShuffle(uint256 newRange) external onlyOwner {
2762         require(
2763             tokenOrderRange == 0,
2764             "token shuffle already called"
2765         );
2766         tokenOrderRange = newRange;
2767         uint256 i = tokenOrderRange-1;
2768         uint256 a;
2769         uint256 b;
2770         uint256 n;
2771         while(i > 0){
2772             // the value we're at
2773             a = getSwapIdx(i);
2774             // the value to swap to
2775             n = rand(i+1,i);
2776             b = getSwapIdx(n);
2777             // do the swap 
2778             tokenOrder[i] = b;
2779             tokenOrder[n] = a;
2780             unchecked{
2781                 i = i - 1;
2782             }
2783         }
2784     }
2785 
2786     // register contracts
2787     function authorRegisterContracts(address[] calldata addr) external onlyOwner{
2788         prevProjects.push(Lockout(addr[0]));
2789         prevProjects.push(UsrMessage(addr[1]));
2790         prevProjects.push(IdeasOfMountains(addr[2]));
2791         prevProjects.push(Neophyte(addr[3]));
2792         cryptoPunks = CryptoPunksMarket(addr[4]);
2793         cryptoPunksData = CryptoPunksData(addr[5]);
2794     }
2795 
2796     // set desc for metadata because its looong for wiiides
2797     function authorSetDesc(bytes calldata newDesc) external onlyOwner{
2798         desc = newDesc;
2799     }
2800 
2801     // emergency set new max width if there's a browser rendering problem in the future 
2802     function authorSetMaxWidth(uint256 val) external onlyOwner {
2803         maxWidth = val;
2804     }
2805 
2806     // set withdraw address
2807     function authorRegisterWithdrawlAddress(address payable givenWithdrawalAddress) external onlyOwner {
2808         withdrawalAddress = givenWithdrawalAddress;
2809     }
2810 
2811     // toggle to start/pause minting
2812     function authorToggleMintState(bool mintState, bool claimState) external onlyOwner {
2813         mintActive = mintState;
2814         claimActive = claimState;
2815     }
2816 
2817     // thank you 
2818     function authorWithdraw() external onlyOwner {
2819         (bool success, ) = withdrawalAddress.call{value:address(this).balance}("");
2820         require(success, "Transfer failed.");
2821     }
2822 
2823     function authorYouMad(uint256 idx, bool b) external onlyOwner {
2824         uMad[idx] = b;
2825     }
2826 
2827     function authorBigMad(bool b) external onlyOwner{
2828         bigMad = b;
2829     }
2830 
2831     function authorBrainWorms(address addr) external onlyOwner{
2832         brainWorms = BrainWorms(addr);
2833     }
2834 
2835     // thanks but why did you send shitcoins to this contract
2836     function authorForwardERC20s(IERC20 _token, address _to, uint256 _amount) external onlyOwner {
2837         require(
2838             address(_to) != address(0),
2839             "Can't send to a zero address."
2840         );
2841         _token.transfer(_to, _amount);
2842     }
2843    
2844     // widenoooor
2845     function _beforeTokenTransfer(
2846         address from,
2847         address to,
2848         uint256 tokenId
2849     ) internal virtual override(ERC721, ERC721Enumerable) {
2850         super._beforeTokenTransfer(from, to, tokenId);
2851         if(tokenWidth[tokenId] < maxWidth){
2852             // 1.2x to 2x growth rate depending on tokenId 0th to 20th
2853             // (tokenId %20)*50)+1150
2854             // it's scaled up and divided by 1000 to behave like a decimal place
2855             unchecked {
2856                 tokenWidth[tokenId] =  (tokenWidth[tokenId]* ((tokenId % 20)*50+1150 ))/1000;
2857             }
2858         } 
2859     }
2860 
2861     function supportsInterface(bytes4 interfaceId)
2862         public
2863         view
2864         virtual
2865         override(ERC721, ERC721Enumerable)
2866         returns (bool)
2867     {
2868         return super.supportsInterface(interfaceId);
2869     }
2870 
2871 
2872 }
2873 
2874 /// [MIT License]
2875 /// @title Base64
2876 /// @notice Provides a function for encoding some bytes in base64
2877 /// @author Brecht Devos <brecht@loopring.org>
2878 library Base64 {
2879     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2880     /// @notice Encodes some bytes to the base64 representation
2881     function encode(bytes memory data) internal pure returns (string memory) {
2882         uint256 len = data.length;
2883         if (len == 0) return "";
2884         uint256 encodedLen = 4 * ((len + 2) / 3);
2885         bytes memory result = new bytes(encodedLen + 32);
2886         bytes memory table = TABLE;
2887 
2888         assembly {
2889             let tablePtr := add(table, 1)
2890             let resultPtr := add(result, 32)
2891             for {
2892                 let i := 0
2893             } lt(i, len) {
2894 
2895             } {
2896                 i := add(i, 3)
2897                 let input := and(mload(add(data, i)), 0xffffff)
2898                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2899                 out := shl(8, out)
2900                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
2901                 out := shl(8, out)
2902                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
2903                 out := shl(8, out)
2904                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
2905                 out := shl(224, out)
2906                 mstore(resultPtr, out)
2907                 resultPtr := add(resultPtr, 4)
2908             }
2909             switch mod(len, 3)
2910             case 1 {
2911                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2912             }
2913             case 2 {
2914                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2915             }
2916             mstore(result, encodedLen)
2917         }
2918         return string(result);
2919     }
2920 }