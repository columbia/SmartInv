1 pragma solidity ^0.4.19;
2 library SafeMath {
3 
4   /**
5   * @dev Multiplies two numbers, throws on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   /**
17   * @dev Integer division of two numbers, truncating the quotient.
18   */
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   /**
27   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
28   */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   /**
35   * @dev Adds two numbers, throws on overflow.
36   */
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
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
721 
722 contract CryptoMyWord {
723   using SafeMath for uint256;
724   using strings for *;
725 
726   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
727   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
728   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
729   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
730   event NewWord(uint wordId, string name, uint price);
731 
732   address private owner;
733   uint256 nameTokenId;
734   uint256 tokenId;
735   mapping (address => bool) private admins;
736   //IItemRegistry private itemRegistry;
737   bool private erc721Enabled = false;
738 
739   uint256 private increaseLimit1 = 0.8 ether;
740   uint256 private increaseLimit2 = 1.5 ether;
741   uint256 private increaseLimit3 = 2.0 ether;
742   uint256 private increaseLimit4 = 5.0 ether;
743 
744   uint256[] private listedItems;
745   mapping (uint256 => address) public ownerOfItem;
746   mapping (address => string) public nameOfOwner;
747   mapping (address => string) public snsOfOwner;
748   mapping (uint256 => uint256) private startingPriceOfItem;
749   mapping (uint256 => uint256) private priceOfItem;
750   mapping (uint256 => string) private nameOfItem;
751   mapping (uint256 => string) private urlOfItem;
752   mapping (uint256 => address[]) private borrowerOfItem;
753   mapping (string => uint256[]) private nameToItems;
754   mapping (uint256 => address) private approvedOfItem;
755   mapping (string => uint256) private nameToParents;
756   mapping (string => uint256) private nameToNameToken;
757   mapping (string => string) private firstIdOfName;
758   mapping (string => string) private secondIdOfName;
759 
760   function CryptoMyWord () public {
761     owner = msg.sender;
762     admins[owner] = true;
763   }
764 
765   struct Token {
766     address firstMintedBy;
767     uint64 mintedAt;
768     uint256 startingPrice;
769     uint256 priceOfItem;
770     string name;
771     string url;
772     string firstIdOfName;
773     string secondIdOfName;
774     address owner;
775   }
776   Token[] public tokens;
777   struct Name {
778     string name;
779     uint256 parent;
780   }
781   Name[] public names;
782   /* Modifiers */
783   modifier onlyOwner() {
784     require(owner == msg.sender);
785     _;
786   }
787 
788   modifier onlyAdmins() {
789     require(admins[msg.sender]);
790     _;
791   }
792 
793   modifier onlyERC721() {
794     require(erc721Enabled);
795     _;
796   }
797 
798   /* Owner */
799   function setOwner (address _owner) onlyOwner() public {
800     owner = _owner;
801   }
802 
803   function getOwner () view public returns(address) {
804     return owner;
805   }
806 
807   function addAdmin (address _admin) onlyOwner() public {
808     admins[_admin] = true;
809   }
810 
811   function removeAdmin (address _admin) onlyOwner() public {
812     delete admins[_admin];
813   }
814 
815   // Unlocks ERC721 behaviour, allowing for trading on third party platforms.
816   function enableERC721 () onlyOwner() public {
817     erc721Enabled = true;
818   }
819 
820   // locks ERC721 behaviour, allowing for trading on third party platforms.
821   function disableERC721 () onlyOwner() public {
822     erc721Enabled = false;
823   }
824 
825   /* Withdraw */
826   /*
827     NOTICE: These functions withdraw the developer's cut which is left
828     in the contract by `buy`. User funds are immediately sent to the old
829     owner in `buy`, no user funds are left in the contract.
830   */
831   function withdrawAll () onlyOwner() public {
832     owner.transfer(this.balance);
833   }
834 
835   function withdrawAmount (uint256 _amount) onlyOwner() public {
836     owner.transfer(_amount);
837   }
838 
839 
840   function listItem (uint256 _price, address _owner, string _name) onlyAdmins() public {
841     require(nameToItems[_name].length == 0);
842     Token memory token = Token({
843       firstMintedBy: _owner,
844       mintedAt: uint64(now),
845       startingPrice: _price,
846       priceOfItem: _price,
847       name: _name,
848       url: "",
849       firstIdOfName: "",
850       secondIdOfName: "",
851       owner: _owner
852     });
853     tokenId = tokens.push(token) - 1;
854     Name memory namesval = Name({
855       name: _name,
856       parent: tokenId
857     });
858     ownerOfItem[tokenId] = _owner;
859     priceOfItem[tokenId] = _price;
860     startingPriceOfItem[tokenId] = _price;
861     nameOfItem[tokenId] = _name;
862     nameToItems[_name].push(tokenId);
863     listedItems.push(tokenId);
864     nameToParents[_name] = tokenId;
865     nameTokenId = names.push(namesval) - 1;
866     nameToNameToken[_name] = nameTokenId;
867   }
868 
869   function _mint (uint256 _price, address _owner, string _name, string _url) internal {
870     address firstOwner = _owner;
871     if(nameToItems[_name].length != 0){
872       firstOwner = ownerOf(nameToParents[_name]);
873       if(admins[firstOwner]){
874         firstOwner = _owner;
875       }
876     }
877     Token memory token = Token({
878       firstMintedBy: firstOwner,
879       mintedAt: uint64(now),
880       startingPrice: _price,
881       priceOfItem: _price,
882       name: _name,
883       url: "",
884       firstIdOfName: "",
885       secondIdOfName: "",
886       owner: _owner
887     });
888     tokenId = tokens.push(token) - 1;
889     Name memory namesval = Name({
890       name: _name,
891       parent: tokenId
892     });
893     if(nameToItems[_name].length != 0){
894       names[nameToNameToken[_name]] = namesval;
895     }
896     ownerOfItem[tokenId] = _owner;
897     priceOfItem[tokenId] = _price;
898     startingPriceOfItem[tokenId] = _price;
899     nameOfItem[tokenId] = _name;
900     urlOfItem[tokenId] = _url;
901     nameToItems[_name].push(tokenId);
902     listedItems.push(tokenId);
903     nameToParents[_name] = tokenId;
904   }
905 
906   function composite (uint256 _firstId, uint256 _secondId, uint8 _space) public {
907     int counter1 = 0;
908     for (uint i = 0; i < borrowerOfItem[_firstId].length; i++) {
909       if (borrowerOfItem[_firstId][i] == msg.sender) {
910         counter1++;
911       }
912     }
913     int counter2 = 0;
914     for (uint i2 = 0; i2 < borrowerOfItem[_secondId].length; i2++) {
915       if (borrowerOfItem[_secondId][i2] == msg.sender) {
916         counter2++;
917       }
918     }
919     require(ownerOfItem[_firstId] == msg.sender || counter1 > 0);
920     require(ownerOfItem[_secondId] == msg.sender || counter2 > 0);
921     string memory compositedName1 = nameOfItem[_firstId];
922     string memory space = " ";
923     if(_space > 0){
924       compositedName1 = nameOfItem[_firstId].toSlice().concat(space.toSlice());
925     }
926     string memory compositedName = compositedName1.toSlice().concat(nameOfItem[_secondId].toSlice());
927     require(nameToItems[compositedName].length == 0);
928     firstIdOfName[compositedName] = nameOfItem[_firstId];
929     secondIdOfName[compositedName] = nameOfItem[_secondId];
930     _mint(0.01 ether, msg.sender, compositedName, "");
931   }
932 
933   function setUrl (uint256 _tokenId, string _url) public {
934     require(ownerOf(_tokenId) == msg.sender);
935     tokens[_tokenId].url = _url;
936   }
937 
938   /* Buying */
939   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
940     if (_price < increaseLimit1) {
941       return _price.mul(200).div(95); // 1.95
942     } else if (_price < increaseLimit2) {
943       return _price.mul(135).div(95); //1.3
944     } else if (_price < increaseLimit3) {
945       return _price.mul(125).div(95); //1.2
946     } else if (_price < increaseLimit4) {
947       return _price.mul(120).div(95); //1.12
948     } else {
949       return _price.mul(115).div(95); //1.1
950     }
951   }
952 
953   function calculateDevCut (uint256 _price) public pure returns (uint256 _devCut) {
954     return _price.mul(4).div(100);
955   }
956   function calculateFirstCut (uint256 _price) public pure returns (uint256 _firstCut) {
957     return _price.mul(1).div(100);
958   }
959   function ceil(uint a) public pure returns (uint ) {
960     return uint(int(a * 100) / 100);
961   }
962   /*
963      Buy a country directly from the contract for the calculated price
964      which ensures that the owner gets a profit.  All countries that
965      have been listed can be bought by this method. User funds are sent
966      directly to the previous owner and are never stored in the contract.
967   */
968   function buy (uint256 _itemId) payable public {
969     require(priceOf(_itemId) > 0);
970     require(ownerOf(_itemId) != address(0));
971     require(msg.value >= priceOf(_itemId));
972     require(ownerOf(_itemId) != msg.sender);
973     require(!isContract(msg.sender));
974     require(msg.sender != address(0));
975     address firstOwner = tokens[_itemId].firstMintedBy;
976     address oldOwner = ownerOf(_itemId);
977     address newOwner = msg.sender;
978     uint256 price = ceil(priceOf(_itemId));
979     uint256 excess = msg.value.sub(price);
980     string memory name = nameOf(_itemId);
981     uint256 nextPrice = ceil(nextPriceOf(_itemId));
982     //_transfer(oldOwner, newOwner, _itemId);
983     _mint(nextPrice, newOwner, name, "");
984     priceOfItem[_itemId] = nextPrice;
985 
986     Bought(_itemId, newOwner, price);
987     Sold(_itemId, oldOwner, price);
988 
989     // Devevloper's cut which is left in contract and accesed by
990     // `withdrawAll` and `withdrawAmountTo` methods.
991     uint256 devCut = ceil(calculateDevCut(price));
992     uint256 firstCut = ceil(calculateFirstCut(price));
993     // Transfer payment to old owner minus the developer's cut.
994     oldOwner.transfer(price.sub(devCut));
995     firstOwner.transfer(price.sub(firstCut));
996     if (excess > 0) {
997       newOwner.transfer(excess);
998     }
999   }
1000 
1001   /* ERC721 */
1002   function implementsERC721() public view returns (bool _implements) {
1003     return erc721Enabled;
1004   }
1005 
1006   function name() public pure returns (string _name) {
1007     return "CryptoMyWord";
1008   }
1009 
1010   function symbol() public pure returns (string _symbol) {
1011     return "CMW";
1012   }
1013 
1014   function totalSupply() public view returns (uint256 _totalSupply) {
1015     return listedItems.length;
1016   }
1017 
1018   function balanceOf (address _owner) public view returns (uint256 _balance) {
1019     uint256 counter = 0;
1020 
1021     for (uint256 i = 0; i < listedItems.length; i++) {
1022       if (ownerOf(listedItems[i]) == _owner) {
1023         counter++;
1024       }
1025     }
1026 
1027     return counter;
1028   }
1029 
1030   function ownerOf (uint256 _itemId) public view returns (address _owner) {
1031     return ownerOfItem[_itemId];
1032   }
1033 
1034   function tokensOf (address _owner) external view returns (uint256[] _tokenIds) {
1035     uint256[] memory result = new uint256[](balanceOf(_owner));
1036 
1037     uint256 itemCounter = 0;
1038     for (uint256 i = 0; i < tokens.length; i++) {
1039       if (ownerOfItem[i] == _owner) {
1040         result[itemCounter] = i;
1041         itemCounter++;
1042       }
1043     }
1044 
1045     return result;
1046   }
1047 
1048   function getNames () external view returns (uint256[] _tokenIds){
1049     uint256[] memory result = new uint256[](names.length);
1050     uint256 itemCounter = 0;
1051     for (uint i = 0; i < names.length; i++) {
1052       result[itemCounter] = nameToNameToken[names[itemCounter].name];
1053       itemCounter++;
1054     }
1055     return result;
1056   }
1057 
1058   function tokenExists (uint256 _itemId) public view returns (bool _exists) {
1059     return priceOf(_itemId) > 0;
1060   }
1061 
1062   function approvedFor(uint256 _itemId) public view returns (address _approved) {
1063     return approvedOfItem[_itemId];
1064   }
1065 
1066   function approve(address _to, uint256 _itemId) onlyERC721() public {
1067     require(msg.sender != _to);
1068     require(tokenExists(_itemId));
1069     require(ownerOf(_itemId) == msg.sender);
1070 
1071     if (_to == 0) {
1072       if (approvedOfItem[_itemId] != 0) {
1073         delete approvedOfItem[_itemId];
1074         Approval(msg.sender, 0, _itemId);
1075       }
1076     } else {
1077       approvedOfItem[_itemId] = _to;
1078       Approval(msg.sender, _to, _itemId);
1079     }
1080   }
1081 
1082   /* Transferring a country to another owner will entitle the new owner the profits from `buy` */
1083   function transfer(address _to, uint256 _itemId) onlyERC721() public {
1084     require(msg.sender == ownerOf(_itemId));
1085     _transfer(msg.sender, _to, _itemId);
1086   }
1087 
1088   function transferFrom(address _from, address _to, uint256 _itemId) onlyERC721() public {
1089     require(approvedFor(_itemId) == msg.sender);
1090     _transfer(_from, _to, _itemId);
1091   }
1092 
1093   function _transfer(address _from, address _to, uint256 _itemId) internal {
1094     require(tokenExists(_itemId));
1095     require(ownerOf(_itemId) == _from);
1096     require(_to != address(0));
1097     require(_to != address(this));
1098 
1099     ownerOfItem[_itemId] = _to;
1100     approvedOfItem[_itemId] = 0;
1101 
1102     Transfer(_from, _to, _itemId);
1103   }
1104 
1105   /* Read */
1106   function isAdmin (address _admin) public view returns (bool _isAdmin) {
1107     return admins[_admin];
1108   }
1109 
1110   function startingPriceOf (uint256 _itemId) public view returns (uint256 _startingPrice) {
1111     return startingPriceOfItem[_itemId];
1112   }
1113 
1114   function priceOf (uint256 _itemId) public view returns (uint256 _price) {
1115     return priceOfItem[_itemId];
1116   }
1117 
1118   function nextPriceOf (uint256 _itemId) public view returns (uint256 _nextPrice) {
1119     return calculateNextPrice(priceOf(_itemId));
1120   }
1121 
1122   function nameOf (uint256 _itemId) public view returns (string _name) {
1123     return nameOfItem[_itemId];
1124   }
1125 
1126   function itemsByName (string _name) public view returns (uint256[] _items){
1127     return nameToItems[_name];
1128   }
1129 
1130   function allOf (uint256 _itemId) external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
1131     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
1132   }
1133 
1134   function allForPopulate (uint256 _itemId) onlyOwner() external view returns (address _owner, uint256 _startingPrice, uint256 _price, uint256 _nextPrice) {
1135     return (ownerOf(_itemId), startingPriceOf(_itemId), priceOf(_itemId), nextPriceOf(_itemId));
1136   }
1137 
1138   function selfDestruct () onlyOwner() public{
1139     selfdestruct(owner);
1140   }
1141 
1142   function itemsForSaleLimit (uint256 _from, uint256 _take) public view returns (uint256[] _items) {
1143     uint256[] memory items = new uint256[](_take);
1144 
1145     for (uint256 i = 0; i < _take; i++) {
1146       items[i] = listedItems[_from + i];
1147     }
1148 
1149     return items;
1150   }
1151 
1152   /* Util */
1153   function isContract(address addr) internal view returns (bool) {
1154     uint size;
1155     assembly { size := extcodesize(addr) } // solium-disable-line
1156     return size > 0;
1157   }
1158 }