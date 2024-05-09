1 pragma solidity ^0.4.24;
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
50         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
51             ret += 16;
52             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
53         }
54         if (self & 0xffffffffffffffff == 0) {
55             ret += 8;
56             self = bytes32(uint(self) / 0x10000000000000000);
57         }
58         if (self & 0xffffffff == 0) {
59             ret += 4;
60             self = bytes32(uint(self) / 0x100000000);
61         }
62         if (self & 0xffff == 0) {
63             ret += 2;
64             self = bytes32(uint(self) / 0x10000);
65         }
66         if (self & 0xff == 0) {
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
180                     mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
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
669         for(i = 0; i < parts.length; i++) {
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
682 /**
683  * @title Ownable
684  * @dev The Ownable contract has an owner address, and provides basic authorization control
685  * functions, this simplifies the implementation of "user permissions".
686  */
687 contract Ownable {
688   address public owner;
689 
690 
691   event OwnershipRenounced(address indexed previousOwner);
692   event OwnershipTransferred(
693     address indexed previousOwner,
694     address indexed newOwner
695   );
696 
697 
698   /**
699    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
700    * account.
701    */
702   constructor() public {
703     owner = msg.sender;
704   }
705 
706   /**
707    * @dev Throws if called by any account other than the owner.
708    */
709   modifier onlyOwner() {
710     require(msg.sender == owner);
711     _;
712   }
713 
714   /**
715    * @dev Allows the current owner to relinquish control of the contract.
716    * @notice Renouncing to ownership will leave the contract without an owner.
717    * It will not be possible to call the functions with the `onlyOwner`
718    * modifier anymore.
719    */
720   function renounceOwnership() public onlyOwner {
721     emit OwnershipRenounced(owner);
722     owner = address(0);
723   }
724 
725   /**
726    * @dev Allows the current owner to transfer control of the contract to a newOwner.
727    * @param _newOwner The address to transfer ownership to.
728    */
729   function transferOwnership(address _newOwner) public onlyOwner {
730     _transferOwnership(_newOwner);
731   }
732 
733   /**
734    * @dev Transfers control of the contract to a newOwner.
735    * @param _newOwner The address to transfer ownership to.
736    */
737   function _transferOwnership(address _newOwner) internal {
738     require(_newOwner != address(0));
739     emit OwnershipTransferred(owner, _newOwner);
740     owner = _newOwner;
741   }
742 }
743 
744 
745 /**
746  * @title ERC165
747  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
748  */
749 interface ERC165 {
750 
751   /**
752    * @notice Query if a contract implements an interface
753    * @param _interfaceId The interface identifier, as specified in ERC-165
754    * @dev Interface identification is specified in ERC-165. This function
755    * uses less than 30,000 gas.
756    */
757   function supportsInterface(bytes4 _interfaceId)
758     external
759     view
760     returns (bool);
761 }
762 
763 
764 /**
765  * @title SupportsInterfaceWithLookup
766  * @author Matt Condon (@shrugs)
767  * @dev Implements ERC165 using a lookup table.
768  */
769 contract SupportsInterfaceWithLookup is ERC165 {
770 
771   bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
772   /**
773    * 0x01ffc9a7 ===
774    *   bytes4(keccak256('supportsInterface(bytes4)'))
775    */
776 
777   /**
778    * @dev a mapping of interface id to whether or not it's supported
779    */
780   mapping(bytes4 => bool) internal supportedInterfaces;
781 
782   /**
783    * @dev A contract implementing SupportsInterfaceWithLookup
784    * implement ERC165 itself
785    */
786   constructor()
787     public
788   {
789     _registerInterface(InterfaceId_ERC165);
790   }
791 
792   /**
793    * @dev implement supportsInterface(bytes4) using a lookup table
794    */
795   function supportsInterface(bytes4 _interfaceId)
796     external
797     view
798     returns (bool)
799   {
800     return supportedInterfaces[_interfaceId];
801   }
802 
803   /**
804    * @dev private method for registering an interface
805    */
806   function _registerInterface(bytes4 _interfaceId)
807     internal
808   {
809     require(_interfaceId != 0xffffffff);
810     supportedInterfaces[_interfaceId] = true;
811   }
812 }
813 
814 
815 
816 /**
817  * @title ERC721 Non-Fungible Token Standard basic interface
818  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
819  */
820 contract ERC721Basic is ERC165 {
821 
822   bytes4 internal constant InterfaceId_ERC721 = 0x80ac58cd;
823   /*
824    * 0x80ac58cd ===
825    *   bytes4(keccak256('balanceOf(address)')) ^
826    *   bytes4(keccak256('ownerOf(uint256)')) ^
827    *   bytes4(keccak256('approve(address,uint256)')) ^
828    *   bytes4(keccak256('getApproved(uint256)')) ^
829    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
830    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
831    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
832    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
833    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
834    */
835 
836   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
837   /*
838    * 0x4f558e79 ===
839    *   bytes4(keccak256('exists(uint256)'))
840    */
841 
842   bytes4 internal constant InterfaceId_ERC721Enumerable = 0x780e9d63;
843   /**
844    * 0x780e9d63 ===
845    *   bytes4(keccak256('totalSupply()')) ^
846    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
847    *   bytes4(keccak256('tokenByIndex(uint256)'))
848    */
849 
850   bytes4 internal constant InterfaceId_ERC721Metadata = 0x5b5e139f;
851   /**
852    * 0x5b5e139f ===
853    *   bytes4(keccak256('name()')) ^
854    *   bytes4(keccak256('symbol()')) ^
855    *   bytes4(keccak256('tokenURI(uint256)'))
856    */
857 
858   event Transfer(
859     address indexed _from,
860     address indexed _to,
861     uint256 indexed _tokenId
862   );
863   event Approval(
864     address indexed _owner,
865     address indexed _approved,
866     uint256 indexed _tokenId
867   );
868   event ApprovalForAll(
869     address indexed _owner,
870     address indexed _operator,
871     bool _approved
872   );
873 
874   function balanceOf(address _owner) public view returns (uint256 _balance);
875   function ownerOf(uint256 _tokenId) public view returns (address _owner);
876   function exists(uint256 _tokenId) public view returns (bool _exists);
877 
878   function approve(address _to, uint256 _tokenId) public;
879   function getApproved(uint256 _tokenId)
880     public view returns (address _operator);
881 
882   function setApprovalForAll(address _operator, bool _approved) public;
883   function isApprovedForAll(address _owner, address _operator)
884     public view returns (bool);
885 
886   function transferFrom(address _from, address _to, uint256 _tokenId) public;
887   function safeTransferFrom(address _from, address _to, uint256 _tokenId)
888     public;
889 
890   function safeTransferFrom(
891     address _from,
892     address _to,
893     uint256 _tokenId,
894     bytes _data
895   )
896     public;
897 }
898 
899 
900 /**
901  * @title ERC721 token receiver interface
902  * @dev Interface for any contract that wants to support safeTransfers
903  * from ERC721 asset contracts.
904  */
905 contract ERC721Receiver {
906   /**
907    * @dev Magic value to be returned upon successful reception of an NFT
908    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
909    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
910    */
911   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
912 
913   /**
914    * @notice Handle the receipt of an NFT
915    * @dev The ERC721 smart contract calls this function on the recipient
916    * after a `safetransfer`. This function MAY throw to revert and reject the
917    * transfer. Return of other than the magic value MUST result in the
918    * transaction being reverted.
919    * Note: the contract address is always the message sender.
920    * @param _operator The address which called `safeTransferFrom` function
921    * @param _from The address which previously owned the token
922    * @param _tokenId The NFT identifier which is being transferred
923    * @param _data Additional data with no specified format
924    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
925    */
926   function onERC721Received(
927     address _operator,
928     address _from,
929     uint256 _tokenId,
930     bytes _data
931   )
932     public
933     returns(bytes4);
934 }
935 
936 
937 /**
938  * @title SafeMath
939  * @dev Math operations with safety checks that throw on error
940  */
941 library SafeMath {
942 
943   /**
944   * @dev Multiplies two numbers, throws on overflow.
945   */
946   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
947     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
948     // benefit is lost if 'b' is also tested.
949     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
950     if (_a == 0) {
951       return 0;
952     }
953 
954     c = _a * _b;
955     assert(c / _a == _b);
956     return c;
957   }
958 
959   /**
960   * @dev Integer division of two numbers, truncating the quotient.
961   */
962   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
963     // assert(_b > 0); // Solidity automatically throws when dividing by 0
964     // uint256 c = _a / _b;
965     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
966     return _a / _b;
967   }
968 
969   /**
970   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
971   */
972   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
973     assert(_b <= _a);
974     return _a - _b;
975   }
976 
977   /**
978   * @dev Adds two numbers, throws on overflow.
979   */
980   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
981     c = _a + _b;
982     assert(c >= _a);
983     return c;
984   }
985 }
986 
987 /**
988  * Utility library of inline functions on addresses
989  */
990 library AddressUtils {
991 
992   /**
993    * Returns whether the target address is a contract
994    * @dev This function will return false if invoked during the constructor of a contract,
995    * as the code is not actually created until after the constructor finishes.
996    * @param _addr address to check
997    * @return whether the target address is a contract
998    */
999   function isContract(address _addr) internal view returns (bool) {
1000     uint256 size;
1001     // XXX Currently there is no better way to check if there is a contract in an address
1002     // than to check the size of the code at that address.
1003     // See https://ethereum.stackexchange.com/a/14016/36603
1004     // for more details about how this works.
1005     // TODO Check this again before the Serenity release, because all addresses will be
1006     // contracts then.
1007     // solium-disable-next-line security/no-inline-assembly
1008     assembly { size := extcodesize(_addr) }
1009     return size > 0;
1010   }
1011 
1012 }
1013 
1014 /**
1015  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1016  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1017  */
1018 contract ERC721Enumerable is ERC721Basic {
1019   function totalSupply() public view returns (uint256);
1020   function tokenOfOwnerByIndex(
1021     address _owner,
1022     uint256 _index
1023   )
1024     public
1025     view
1026     returns (uint256 _tokenId);
1027 
1028   function tokenByIndex(uint256 _index) public view returns (uint256);
1029 }
1030 
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1034  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1035  */
1036 contract ERC721Metadata is ERC721Basic {
1037   function name() external view returns (string _name);
1038   function symbol() external view returns (string _symbol);
1039   function tokenURI(uint256 _tokenId) public view returns (string);
1040 }
1041 
1042 
1043 /**
1044  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
1045  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1046  */
1047 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
1048 }
1049 
1050 /**
1051  * @title ERC721 Non-Fungible Token Standard basic implementation
1052  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1053  */
1054 contract ERC721BasicToken is SupportsInterfaceWithLookup, ERC721Basic {
1055 
1056   using SafeMath for uint256;
1057   using AddressUtils for address;
1058 
1059   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1060   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
1061   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
1062 
1063   // Mapping from token ID to owner
1064   mapping (uint256 => address) internal tokenOwner;
1065 
1066   // Mapping from token ID to approved address
1067   mapping (uint256 => address) internal tokenApprovals;
1068 
1069   // Mapping from owner to number of owned token
1070   mapping (address => uint256) internal ownedTokensCount;
1071 
1072   // Mapping from owner to operator approvals
1073   mapping (address => mapping (address => bool)) internal operatorApprovals;
1074 
1075   constructor()
1076     public
1077   {
1078     // register the supported interfaces to conform to ERC721 via ERC165
1079     _registerInterface(InterfaceId_ERC721);
1080     _registerInterface(InterfaceId_ERC721Exists);
1081   }
1082 
1083   /**
1084    * @dev Gets the balance of the specified address
1085    * @param _owner address to query the balance of
1086    * @return uint256 representing the amount owned by the passed address
1087    */
1088   function balanceOf(address _owner) public view returns (uint256) {
1089     require(_owner != address(0));
1090     return ownedTokensCount[_owner];
1091   }
1092 
1093   /**
1094    * @dev Gets the owner of the specified token ID
1095    * @param _tokenId uint256 ID of the token to query the owner of
1096    * @return owner address currently marked as the owner of the given token ID
1097    */
1098   function ownerOf(uint256 _tokenId) public view returns (address) {
1099     address owner = tokenOwner[_tokenId];
1100     require(owner != address(0));
1101     return owner;
1102   }
1103 
1104   /**
1105    * @dev Returns whether the specified token exists
1106    * @param _tokenId uint256 ID of the token to query the existence of
1107    * @return whether the token exists
1108    */
1109   function exists(uint256 _tokenId) public view returns (bool) {
1110     address owner = tokenOwner[_tokenId];
1111     return owner != address(0);
1112   }
1113 
1114   /**
1115    * @dev Approves another address to transfer the given token ID
1116    * The zero address indicates there is no approved address.
1117    * There can only be one approved address per token at a given time.
1118    * Can only be called by the token owner or an approved operator.
1119    * @param _to address to be approved for the given token ID
1120    * @param _tokenId uint256 ID of the token to be approved
1121    */
1122   function approve(address _to, uint256 _tokenId) public {
1123     address owner = ownerOf(_tokenId);
1124     require(_to != owner);
1125     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1126 
1127     tokenApprovals[_tokenId] = _to;
1128     emit Approval(owner, _to, _tokenId);
1129   }
1130 
1131   /**
1132    * @dev Gets the approved address for a token ID, or zero if no address set
1133    * @param _tokenId uint256 ID of the token to query the approval of
1134    * @return address currently approved for the given token ID
1135    */
1136   function getApproved(uint256 _tokenId) public view returns (address) {
1137     return tokenApprovals[_tokenId];
1138   }
1139 
1140   /**
1141    * @dev Sets or unsets the approval of a given operator
1142    * An operator is allowed to transfer all tokens of the sender on their behalf
1143    * @param _to operator address to set the approval
1144    * @param _approved representing the status of the approval to be set
1145    */
1146   function setApprovalForAll(address _to, bool _approved) public {
1147     require(_to != msg.sender);
1148     operatorApprovals[msg.sender][_to] = _approved;
1149     emit ApprovalForAll(msg.sender, _to, _approved);
1150   }
1151 
1152   /**
1153    * @dev Tells whether an operator is approved by a given owner
1154    * @param _owner owner address which you want to query the approval of
1155    * @param _operator operator address which you want to query the approval of
1156    * @return bool whether the given operator is approved by the given owner
1157    */
1158   function isApprovedForAll(
1159     address _owner,
1160     address _operator
1161   )
1162     public
1163     view
1164     returns (bool)
1165   {
1166     return operatorApprovals[_owner][_operator];
1167   }
1168 
1169   /**
1170    * @dev Transfers the ownership of a given token ID to another address
1171    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1172    * Requires the msg sender to be the owner, approved, or operator
1173    * @param _from current owner of the token
1174    * @param _to address to receive the ownership of the given token ID
1175    * @param _tokenId uint256 ID of the token to be transferred
1176   */
1177   function transferFrom(
1178     address _from,
1179     address _to,
1180     uint256 _tokenId
1181   )
1182     public
1183   {
1184     require(isApprovedOrOwner(msg.sender, _tokenId));
1185     require(_from != address(0));
1186     require(_to != address(0));
1187 
1188     clearApproval(_from, _tokenId);
1189     removeTokenFrom(_from, _tokenId);
1190     addTokenTo(_to, _tokenId);
1191 
1192     emit Transfer(_from, _to, _tokenId);
1193   }
1194 
1195   /**
1196    * @dev Safely transfers the ownership of a given token ID to another address
1197    * If the target address is a contract, it must implement `onERC721Received`,
1198    * which is called upon a safe transfer, and return the magic value
1199    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1200    * the transfer is reverted.
1201    *
1202    * Requires the msg sender to be the owner, approved, or operator
1203    * @param _from current owner of the token
1204    * @param _to address to receive the ownership of the given token ID
1205    * @param _tokenId uint256 ID of the token to be transferred
1206   */
1207   function safeTransferFrom(
1208     address _from,
1209     address _to,
1210     uint256 _tokenId
1211   )
1212     public
1213   {
1214     // solium-disable-next-line arg-overflow
1215     safeTransferFrom(_from, _to, _tokenId, "");
1216   }
1217 
1218   /**
1219    * @dev Safely transfers the ownership of a given token ID to another address
1220    * If the target address is a contract, it must implement `onERC721Received`,
1221    * which is called upon a safe transfer, and return the magic value
1222    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1223    * the transfer is reverted.
1224    * Requires the msg sender to be the owner, approved, or operator
1225    * @param _from current owner of the token
1226    * @param _to address to receive the ownership of the given token ID
1227    * @param _tokenId uint256 ID of the token to be transferred
1228    * @param _data bytes data to send along with a safe transfer check
1229    */
1230   function safeTransferFrom(
1231     address _from,
1232     address _to,
1233     uint256 _tokenId,
1234     bytes _data
1235   )
1236     public
1237   {
1238     transferFrom(_from, _to, _tokenId);
1239     // solium-disable-next-line arg-overflow
1240     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
1241   }
1242 
1243   /**
1244    * @dev Returns whether the given spender can transfer a given token ID
1245    * @param _spender address of the spender to query
1246    * @param _tokenId uint256 ID of the token to be transferred
1247    * @return bool whether the msg.sender is approved for the given token ID,
1248    *  is an operator of the owner, or is the owner of the token
1249    */
1250   function isApprovedOrOwner(
1251     address _spender,
1252     uint256 _tokenId
1253   )
1254     internal
1255     view
1256     returns (bool)
1257   {
1258     address owner = ownerOf(_tokenId);
1259     // Disable solium check because of
1260     // https://github.com/duaraghav8/Solium/issues/175
1261     // solium-disable-next-line operator-whitespace
1262     return (
1263       _spender == owner ||
1264       getApproved(_tokenId) == _spender ||
1265       isApprovedForAll(owner, _spender)
1266     );
1267   }
1268 
1269   /**
1270    * @dev Internal function to mint a new token
1271    * Reverts if the given token ID already exists
1272    * @param _to The address that will own the minted token
1273    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1274    */
1275   function _mint(address _to, uint256 _tokenId) internal {
1276     require(_to != address(0));
1277     addTokenTo(_to, _tokenId);
1278     emit Transfer(address(0), _to, _tokenId);
1279   }
1280 
1281   /**
1282    * @dev Internal function to burn a specific token
1283    * Reverts if the token does not exist
1284    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1285    */
1286   function _burn(address _owner, uint256 _tokenId) internal {
1287     clearApproval(_owner, _tokenId);
1288     removeTokenFrom(_owner, _tokenId);
1289     emit Transfer(_owner, address(0), _tokenId);
1290   }
1291 
1292   /**
1293    * @dev Internal function to clear current approval of a given token ID
1294    * Reverts if the given address is not indeed the owner of the token
1295    * @param _owner owner of the token
1296    * @param _tokenId uint256 ID of the token to be transferred
1297    */
1298   function clearApproval(address _owner, uint256 _tokenId) internal {
1299     require(ownerOf(_tokenId) == _owner);
1300     if (tokenApprovals[_tokenId] != address(0)) {
1301       tokenApprovals[_tokenId] = address(0);
1302     }
1303   }
1304 
1305   /**
1306    * @dev Internal function to add a token ID to the list of a given address
1307    * @param _to address representing the new owner of the given token ID
1308    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1309    */
1310   function addTokenTo(address _to, uint256 _tokenId) internal {
1311     require(tokenOwner[_tokenId] == address(0));
1312     tokenOwner[_tokenId] = _to;
1313     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
1314   }
1315 
1316   /**
1317    * @dev Internal function to remove a token ID from the list of a given address
1318    * @param _from address representing the previous owner of the given token ID
1319    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1320    */
1321   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1322     require(ownerOf(_tokenId) == _from);
1323     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
1324     tokenOwner[_tokenId] = address(0);
1325   }
1326 
1327   /**
1328    * @dev Internal function to invoke `onERC721Received` on a target address
1329    * The call is not executed if the target address is not a contract
1330    * @param _from address representing the previous owner of the given token ID
1331    * @param _to target address that will receive the tokens
1332    * @param _tokenId uint256 ID of the token to be transferred
1333    * @param _data bytes optional data to send along with the call
1334    * @return whether the call correctly returned the expected magic value
1335    */
1336   function checkAndCallSafeTransfer(
1337     address _from,
1338     address _to,
1339     uint256 _tokenId,
1340     bytes _data
1341   )
1342     internal
1343     returns (bool)
1344   {
1345     if (!_to.isContract()) {
1346       return true;
1347     }
1348     bytes4 retval = ERC721Receiver(_to).onERC721Received(
1349       msg.sender, _from, _tokenId, _data);
1350     return (retval == ERC721_RECEIVED);
1351   }
1352 }
1353 
1354 /**
1355  * @title Full ERC721 Token
1356  * This implementation includes all the required and some optional functionality of the ERC721 standard
1357  * Moreover, it includes approve all functionality using operator terminology
1358  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
1359  */
1360 contract ERC721Token is SupportsInterfaceWithLookup, ERC721BasicToken, ERC721 {
1361 
1362   // Token name
1363   string internal name_;
1364 
1365   // Token symbol
1366   string internal symbol_;
1367 
1368   // Mapping from owner to list of owned token IDs
1369   mapping(address => uint256[]) internal ownedTokens;
1370 
1371   // Mapping from token ID to index of the owner tokens list
1372   mapping(uint256 => uint256) internal ownedTokensIndex;
1373 
1374   // Array with all token ids, used for enumeration
1375   uint256[] internal allTokens;
1376 
1377   // Mapping from token id to position in the allTokens array
1378   mapping(uint256 => uint256) internal allTokensIndex;
1379 
1380   // Optional mapping for token URIs
1381   mapping(uint256 => string) internal tokenURIs;
1382 
1383   /**
1384    * @dev Constructor function
1385    */
1386   constructor(string _name, string _symbol) public {
1387     name_ = _name;
1388     symbol_ = _symbol;
1389 
1390     // register the supported interfaces to conform to ERC721 via ERC165
1391     _registerInterface(InterfaceId_ERC721Enumerable);
1392     _registerInterface(InterfaceId_ERC721Metadata);
1393   }
1394 
1395   /**
1396    * @dev Gets the token name
1397    * @return string representing the token name
1398    */
1399   function name() external view returns (string) {
1400     return name_;
1401   }
1402 
1403   /**
1404    * @dev Gets the token symbol
1405    * @return string representing the token symbol
1406    */
1407   function symbol() external view returns (string) {
1408     return symbol_;
1409   }
1410 
1411   /**
1412    * @dev Returns an URI for a given token ID
1413    * Throws if the token ID does not exist. May return an empty string.
1414    * @param _tokenId uint256 ID of the token to query
1415    */
1416   function tokenURI(uint256 _tokenId) public view returns (string) {
1417     require(exists(_tokenId));
1418     return tokenURIs[_tokenId];
1419   }
1420 
1421   /**
1422    * @dev Gets the token ID at a given index of the tokens list of the requested owner
1423    * @param _owner address owning the tokens list to be accessed
1424    * @param _index uint256 representing the index to be accessed of the requested tokens list
1425    * @return uint256 token ID at the given index of the tokens list owned by the requested address
1426    */
1427   function tokenOfOwnerByIndex(
1428     address _owner,
1429     uint256 _index
1430   )
1431     public
1432     view
1433     returns (uint256)
1434   {
1435     require(_index < balanceOf(_owner));
1436     return ownedTokens[_owner][_index];
1437   }
1438 
1439   /**
1440    * @dev Gets the total amount of tokens stored by the contract
1441    * @return uint256 representing the total amount of tokens
1442    */
1443   function totalSupply() public view returns (uint256) {
1444     return allTokens.length;
1445   }
1446 
1447   /**
1448    * @dev Gets the token ID at a given index of all the tokens in this contract
1449    * Reverts if the index is greater or equal to the total number of tokens
1450    * @param _index uint256 representing the index to be accessed of the tokens list
1451    * @return uint256 token ID at the given index of the tokens list
1452    */
1453   function tokenByIndex(uint256 _index) public view returns (uint256) {
1454     require(_index < totalSupply());
1455     return allTokens[_index];
1456   }
1457 
1458   /**
1459    * @dev Internal function to set the token URI for a given token
1460    * Reverts if the token ID does not exist
1461    * @param _tokenId uint256 ID of the token to set its URI
1462    * @param _uri string URI to assign
1463    */
1464   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1465     require(exists(_tokenId));
1466     tokenURIs[_tokenId] = _uri;
1467   }
1468 
1469   /**
1470    * @dev Internal function to add a token ID to the list of a given address
1471    * @param _to address representing the new owner of the given token ID
1472    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1473    */
1474   function addTokenTo(address _to, uint256 _tokenId) internal {
1475     super.addTokenTo(_to, _tokenId);
1476     uint256 length = ownedTokens[_to].length;
1477     ownedTokens[_to].push(_tokenId);
1478     ownedTokensIndex[_tokenId] = length;
1479   }
1480 
1481   /**
1482    * @dev Internal function to remove a token ID from the list of a given address
1483    * @param _from address representing the previous owner of the given token ID
1484    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1485    */
1486   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1487     super.removeTokenFrom(_from, _tokenId);
1488 
1489     // To prevent a gap in the array, we store the last token in the index of the token to delete, and
1490     // then delete the last slot.
1491     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1492     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1493     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1494 
1495     ownedTokens[_from][tokenIndex] = lastToken;
1496     // This also deletes the contents at the last position of the array
1497     ownedTokens[_from].length--;
1498 
1499     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1500     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1501     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1502 
1503     ownedTokensIndex[_tokenId] = 0;
1504     ownedTokensIndex[lastToken] = tokenIndex;
1505   }
1506 
1507   /**
1508    * @dev Internal function to mint a new token
1509    * Reverts if the given token ID already exists
1510    * @param _to address the beneficiary that will own the minted token
1511    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1512    */
1513   function _mint(address _to, uint256 _tokenId) internal {
1514     super._mint(_to, _tokenId);
1515 
1516     allTokensIndex[_tokenId] = allTokens.length;
1517     allTokens.push(_tokenId);
1518   }
1519 
1520   /**
1521    * @dev Internal function to burn a specific token
1522    * Reverts if the token does not exist
1523    * @param _owner owner of the token to burn
1524    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1525    */
1526   function _burn(address _owner, uint256 _tokenId) internal {
1527     super._burn(_owner, _tokenId);
1528 
1529     // Clear metadata (if any)
1530     if (bytes(tokenURIs[_tokenId]).length != 0) {
1531       delete tokenURIs[_tokenId];
1532     }
1533 
1534     // Reorg all tokens array
1535     uint256 tokenIndex = allTokensIndex[_tokenId];
1536     uint256 lastTokenIndex = allTokens.length.sub(1);
1537     uint256 lastToken = allTokens[lastTokenIndex];
1538 
1539     allTokens[tokenIndex] = lastToken;
1540     allTokens[lastTokenIndex] = 0;
1541 
1542     allTokens.length--;
1543     allTokensIndex[_tokenId] = 0;
1544     allTokensIndex[lastToken] = tokenIndex;
1545   }
1546 
1547 }
1548 
1549 contract BlockvisCoupon is ERC721Token, Ownable {
1550     using strings for string;
1551 
1552     string private constant NAME = "Blockvis Coupon";
1553     string private constant SYMBOL = "Blockvis";
1554 
1555     uint256 private maxGift = 0.1 ether;
1556 
1557     constructor() public ERC721Token(NAME, SYMBOL) {}
1558     using strings for strings.slice;
1559 
1560     uint8[16] digits = [0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x41,0x42,0x43,0x44,0x45,0x46];
1561 
1562     function tokenURI(uint256 x) public view returns (string result) {
1563         result = "https://coupons.blockvis.com/metadata/0000000000000000000000000000000000000000000000000000000000000000.json"; 
1564         strings.slice memory r = result.toSlice();
1565         uint256 ptr = r._ptr + 38 + 32;
1566         uint coded = 0;
1567         for (uint256 i = 0; i <= 128; i += 4) {
1568             coded = coded | uint256(digits[(x >> i) & 0xF]) << (i*2);
1569         }
1570         assembly {
1571             mstore(ptr,coded)
1572         }
1573         coded = 0;
1574         for (i = 0; i <= 128; i += 4) {
1575             coded = coded | uint256(digits[(x >> (i+128)) & 0xF]) << (i*2);
1576         }
1577         ptr = r._ptr + 38;
1578         assembly {
1579             mstore(ptr,coded)
1580         }
1581     }
1582 
1583     function mint(address _to, uint256 _tokenId) public payable onlyOwner {
1584         super._mint(_to, _tokenId);
1585 
1586         uint256 amount = msg.value;
1587         if (amount == 0) return;
1588 
1589         if (amount > maxGift) {
1590             amount = maxGift;
1591         }
1592         _to.transfer(amount);
1593     }
1594 
1595     function setMaxGift(uint256 _maxGift) public onlyOwner {
1596         maxGift = _maxGift;
1597     }
1598 }