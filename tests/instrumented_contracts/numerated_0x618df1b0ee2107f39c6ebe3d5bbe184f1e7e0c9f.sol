1 pragma solidity ^0.4.13;
2 
3 library Strings {
4     struct slice {
5         uint _len;
6         uint _ptr;
7     }
8 
9     function memcpy(uint dest, uint src, uint len) private {
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
33     function toSlice(string self) internal returns (slice) {
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
46     function len(bytes32 self) internal returns (uint) {
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
74      *      null-termintaed utf-8 string.
75      * @param self The bytes32 value to convert to a slice.
76      * @return A new slice containing the value of the input argument up to the
77      *         first null.
78      */
79     function toSliceB32(bytes32 self) internal returns (slice ret) {
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
95     function copy(slice self) internal returns (slice) {
96         return slice(self._len, self._ptr);
97     }
98 
99     /*
100      * @dev Copies a slice to a new string.
101      * @param self The slice to copy.
102      * @return A newly allocated string containing the slice's text.
103      */
104     function toString(slice self) internal returns (string) {
105         var ret = new string(self._len);
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
121     function len(slice self) internal returns (uint) {
122         // Starting at ptr-31 means the LSB will be the byte we care about
123         var ptr = self._ptr - 31;
124         var end = ptr + self._len;
125         for (uint len = 0; ptr < end; len++) {
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
142         return len;
143     }
144 
145     /*
146      * @dev Returns true if the slice is empty (has a length of 0).
147      * @param self The slice to operate on.
148      * @return True if the slice is empty, False otherwise.
149      */
150     function empty(slice self) internal returns (bool) {
151         return self._len == 0;
152     }
153 
154     /*
155      * @dev Returns a positive number if `other` comes lexicographically after
156      *      `self`, a negative number if it comes before, or zero if the
157      *      contents of the two slices are equal. Comparison is done per-rune,
158      *      on unicode codepoints.
159      * @param self The first slice to compare.
160      * @param other The second slice to compare.
161      * @return The result of the comparison.
162      */
163     function compare(slice self, slice other) internal returns (int) {
164         uint shortest = self._len;
165         if (other._len < self._len)
166             shortest = other._len;
167 
168         var selfptr = self._ptr;
169         var otherptr = other._ptr;
170         for (uint idx = 0; idx < shortest; idx += 32) {
171             uint a;
172             uint b;
173             assembly {
174                 a := mload(selfptr)
175                 b := mload(otherptr)
176             }
177             if (a != b) {
178                 // Mask out irrelevant bytes and check again
179                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
180                 var diff = (a & mask) - (b & mask);
181                 if (diff != 0)
182                     return int(diff);
183             }
184             selfptr += 32;
185             otherptr += 32;
186         }
187         return int(self._len) - int(other._len);
188     }
189 
190     /*
191      * @dev Returns true if the two slices contain the same text.
192      * @param self The first slice to compare.
193      * @param self The second slice to compare.
194      * @return True if the slices are equal, false otherwise.
195      */
196     function equals(slice self, slice other) internal returns (bool) {
197         return compare(self, other) == 0;
198     }
199 
200     /*
201      * @dev Extracts the first rune in the slice into `rune`, advancing the
202      *      slice to point to the next rune and returning `self`.
203      * @param self The slice to operate on.
204      * @param rune The slice that will contain the first rune.
205      * @return `rune`.
206      */
207     function nextRune(slice self, slice rune) internal returns (slice) {
208         rune._ptr = self._ptr;
209 
210         if (self._len == 0) {
211             rune._len = 0;
212             return rune;
213         }
214 
215         uint len;
216         uint b;
217         // Load the first byte of the rune into the LSBs of b
218         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
219         if (b < 0x80) {
220             len = 1;
221         } else if(b < 0xE0) {
222             len = 2;
223         } else if(b < 0xF0) {
224             len = 3;
225         } else {
226             len = 4;
227         }
228 
229         // Check for truncated codepoints
230         if (len > self._len) {
231             rune._len = self._len;
232             self._ptr += self._len;
233             self._len = 0;
234             return rune;
235         }
236 
237         self._ptr += len;
238         self._len -= len;
239         rune._len = len;
240         return rune;
241     }
242 
243     /*
244      * @dev Returns the first rune in the slice, advancing the slice to point
245      *      to the next rune.
246      * @param self The slice to operate on.
247      * @return A slice containing only the first rune from `self`.
248      */
249     function nextRune(slice self) internal returns (slice ret) {
250         nextRune(self, ret);
251     }
252 
253     /*
254      * @dev Returns the number of the first codepoint in the slice.
255      * @param self The slice to operate on.
256      * @return The number of the first codepoint in the slice.
257      */
258     function ord(slice self) internal returns (uint ret) {
259         if (self._len == 0) {
260             return 0;
261         }
262 
263         uint word;
264         uint len;
265         uint div = 2 ** 248;
266 
267         // Load the rune into the MSBs of b
268         assembly { word:= mload(mload(add(self, 32))) }
269         var b = word / div;
270         if (b < 0x80) {
271             ret = b;
272             len = 1;
273         } else if(b < 0xE0) {
274             ret = b & 0x1F;
275             len = 2;
276         } else if(b < 0xF0) {
277             ret = b & 0x0F;
278             len = 3;
279         } else {
280             ret = b & 0x07;
281             len = 4;
282         }
283 
284         // Check for truncated codepoints
285         if (len > self._len) {
286             return 0;
287         }
288 
289         for (uint i = 1; i < len; i++) {
290             div = div / 256;
291             b = (word / div) & 0xFF;
292             if (b & 0xC0 != 0x80) {
293                 // Invalid UTF-8 sequence
294                 return 0;
295             }
296             ret = (ret * 64) | (b & 0x3F);
297         }
298 
299         return ret;
300     }
301 
302     /*
303      * @dev Returns the keccak-256 hash of the slice.
304      * @param self The slice to hash.
305      * @return The hash of the slice.
306      */
307     function keccak(slice self) internal returns (bytes32 ret) {
308         assembly {
309             ret := sha3(mload(add(self, 32)), mload(self))
310         }
311     }
312 
313     /*
314      * @dev Returns true if `self` starts with `needle`.
315      * @param self The slice to operate on.
316      * @param needle The slice to search for.
317      * @return True if the slice starts with the provided text, false otherwise.
318      */
319     function startsWith(slice self, slice needle) internal returns (bool) {
320         if (self._len < needle._len) {
321             return false;
322         }
323 
324         if (self._ptr == needle._ptr) {
325             return true;
326         }
327 
328         bool equal;
329         assembly {
330             let len := mload(needle)
331             let selfptr := mload(add(self, 0x20))
332             let needleptr := mload(add(needle, 0x20))
333             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
334         }
335         return equal;
336     }
337 
338     /*
339      * @dev If `self` starts with `needle`, `needle` is removed from the
340      *      beginning of `self`. Otherwise, `self` is unmodified.
341      * @param self The slice to operate on.
342      * @param needle The slice to search for.
343      * @return `self`
344      */
345     function beyond(slice self, slice needle) internal returns (slice) {
346         if (self._len < needle._len) {
347             return self;
348         }
349 
350         bool equal = true;
351         if (self._ptr != needle._ptr) {
352             assembly {
353                 let len := mload(needle)
354                 let selfptr := mload(add(self, 0x20))
355                 let needleptr := mload(add(needle, 0x20))
356                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
357             }
358         }
359 
360         if (equal) {
361             self._len -= needle._len;
362             self._ptr += needle._len;
363         }
364 
365         return self;
366     }
367 
368     /*
369      * @dev Returns true if the slice ends with `needle`.
370      * @param self The slice to operate on.
371      * @param needle The slice to search for.
372      * @return True if the slice starts with the provided text, false otherwise.
373      */
374     function endsWith(slice self, slice needle) internal returns (bool) {
375         if (self._len < needle._len) {
376             return false;
377         }
378 
379         var selfptr = self._ptr + self._len - needle._len;
380 
381         if (selfptr == needle._ptr) {
382             return true;
383         }
384 
385         bool equal;
386         assembly {
387             let len := mload(needle)
388             let needleptr := mload(add(needle, 0x20))
389             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
390         }
391 
392         return equal;
393     }
394 
395     /*
396      * @dev If `self` ends with `needle`, `needle` is removed from the
397      *      end of `self`. Otherwise, `self` is unmodified.
398      * @param self The slice to operate on.
399      * @param needle The slice to search for.
400      * @return `self`
401      */
402     function until(slice self, slice needle) internal returns (slice) {
403         if (self._len < needle._len) {
404             return self;
405         }
406 
407         var selfptr = self._ptr + self._len - needle._len;
408         bool equal = true;
409         if (selfptr != needle._ptr) {
410             assembly {
411                 let len := mload(needle)
412                 let needleptr := mload(add(needle, 0x20))
413                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
414             }
415         }
416 
417         if (equal) {
418             self._len -= needle._len;
419         }
420 
421         return self;
422     }
423 
424     // Returns the memory address of the first byte of the first occurrence of
425     // `needle` in `self`, or the first byte after `self` if not found.
426     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
427         uint ptr;
428         uint idx;
429 
430         if (needlelen <= selflen) {
431             if (needlelen <= 32) {
432                 // Optimized assembly for 68 gas per byte on short strings
433                 assembly {
434                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
435                     let needledata := and(mload(needleptr), mask)
436                     let end := add(selfptr, sub(selflen, needlelen))
437                     ptr := selfptr
438                     loop:
439                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
440                     ptr := add(ptr, 1)
441                     jumpi(loop, lt(sub(ptr, 1), end))
442                     ptr := add(selfptr, selflen)
443                     exit:
444                 }
445                 return ptr;
446             } else {
447                 // For long needles, use hashing
448                 bytes32 hash;
449                 assembly { hash := sha3(needleptr, needlelen) }
450                 ptr = selfptr;
451                 for (idx = 0; idx <= selflen - needlelen; idx++) {
452                     bytes32 testHash;
453                     assembly { testHash := sha3(ptr, needlelen) }
454                     if (hash == testHash)
455                         return ptr;
456                     ptr += 1;
457                 }
458             }
459         }
460         return selfptr + selflen;
461     }
462 
463     // Returns the memory address of the first byte after the last occurrence of
464     // `needle` in `self`, or the address of `self` if not found.
465     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
466         uint ptr;
467 
468         if (needlelen <= selflen) {
469             if (needlelen <= 32) {
470                 // Optimized assembly for 69 gas per byte on short strings
471                 assembly {
472                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
473                     let needledata := and(mload(needleptr), mask)
474                     ptr := add(selfptr, sub(selflen, needlelen))
475                     loop:
476                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
477                     ptr := sub(ptr, 1)
478                     jumpi(loop, gt(add(ptr, 1), selfptr))
479                     ptr := selfptr
480                     jump(exit)
481                     ret:
482                     ptr := add(ptr, needlelen)
483                     exit:
484                 }
485                 return ptr;
486             } else {
487                 // For long needles, use hashing
488                 bytes32 hash;
489                 assembly { hash := sha3(needleptr, needlelen) }
490                 ptr = selfptr + (selflen - needlelen);
491                 while (ptr >= selfptr) {
492                     bytes32 testHash;
493                     assembly { testHash := sha3(ptr, needlelen) }
494                     if (hash == testHash)
495                         return ptr + needlelen;
496                     ptr -= 1;
497                 }
498             }
499         }
500         return selfptr;
501     }
502 
503     /*
504      * @dev Modifies `self` to contain everything from the first occurrence of
505      *      `needle` to the end of the slice. `self` is set to the empty slice
506      *      if `needle` is not found.
507      * @param self The slice to search and modify.
508      * @param needle The text to search for.
509      * @return `self`.
510      */
511     function find(slice self, slice needle) internal returns (slice) {
512         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
513         self._len -= ptr - self._ptr;
514         self._ptr = ptr;
515         return self;
516     }
517 
518     /*
519      * @dev Modifies `self` to contain the part of the string from the start of
520      *      `self` to the end of the first occurrence of `needle`. If `needle`
521      *      is not found, `self` is set to the empty slice.
522      * @param self The slice to search and modify.
523      * @param needle The text to search for.
524      * @return `self`.
525      */
526     function rfind(slice self, slice needle) internal returns (slice) {
527         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
528         self._len = ptr - self._ptr;
529         return self;
530     }
531 
532     /*
533      * @dev Splits the slice, setting `self` to everything after the first
534      *      occurrence of `needle`, and `token` to everything before it. If
535      *      `needle` does not occur in `self`, `self` is set to the empty slice,
536      *      and `token` is set to the entirety of `self`.
537      * @param self The slice to split.
538      * @param needle The text to search for in `self`.
539      * @param token An output parameter to which the first token is written.
540      * @return `token`.
541      */
542     function split(slice self, slice needle, slice token) internal returns (slice) {
543         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
544         token._ptr = self._ptr;
545         token._len = ptr - self._ptr;
546         if (ptr == self._ptr + self._len) {
547             // Not found
548             self._len = 0;
549         } else {
550             self._len -= token._len + needle._len;
551             self._ptr = ptr + needle._len;
552         }
553         return token;
554     }
555 
556     /*
557      * @dev Splits the slice, setting `self` to everything after the first
558      *      occurrence of `needle`, and returning everything before it. If
559      *      `needle` does not occur in `self`, `self` is set to the empty slice,
560      *      and the entirety of `self` is returned.
561      * @param self The slice to split.
562      * @param needle The text to search for in `self`.
563      * @return The part of `self` up to the first occurrence of `delim`.
564      */
565     function split(slice self, slice needle) internal returns (slice token) {
566         split(self, needle, token);
567     }
568 
569     /*
570      * @dev Splits the slice, setting `self` to everything before the last
571      *      occurrence of `needle`, and `token` to everything after it. If
572      *      `needle` does not occur in `self`, `self` is set to the empty slice,
573      *      and `token` is set to the entirety of `self`.
574      * @param self The slice to split.
575      * @param needle The text to search for in `self`.
576      * @param token An output parameter to which the first token is written.
577      * @return `token`.
578      */
579     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
580         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
581         token._ptr = ptr;
582         token._len = self._len - (ptr - self._ptr);
583         if (ptr == self._ptr) {
584             // Not found
585             self._len = 0;
586         } else {
587             self._len -= token._len + needle._len;
588         }
589         return token;
590     }
591 
592     /*
593      * @dev Splits the slice, setting `self` to everything before the last
594      *      occurrence of `needle`, and returning everything after it. If
595      *      `needle` does not occur in `self`, `self` is set to the empty slice,
596      *      and the entirety of `self` is returned.
597      * @param self The slice to split.
598      * @param needle The text to search for in `self`.
599      * @return The part of `self` after the last occurrence of `delim`.
600      */
601     function rsplit(slice self, slice needle) internal returns (slice token) {
602         rsplit(self, needle, token);
603     }
604 
605     /*
606      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
607      * @param self The slice to search.
608      * @param needle The text to search for in `self`.
609      * @return The number of occurrences of `needle` found in `self`.
610      */
611     function count(slice self, slice needle) internal returns (uint count) {
612         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
613         while (ptr <= self._ptr + self._len) {
614             count++;
615             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
616         }
617     }
618 
619     /*
620      * @dev Returns True if `self` contains `needle`.
621      * @param self The slice to search.
622      * @param needle The text to search for in `self`.
623      * @return True if `needle` is found in `self`, false otherwise.
624      */
625     function contains(slice self, slice needle) internal returns (bool) {
626         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
627     }
628 
629     /*
630      * @dev Returns a newly allocated string containing the concatenation of
631      *      `self` and `other`.
632      * @param self The first slice to concatenate.
633      * @param other The second slice to concatenate.
634      * @return The concatenation of the two strings.
635      */
636     function concat(slice self, slice other) internal returns (string) {
637         var ret = new string(self._len + other._len);
638         uint retptr;
639         assembly { retptr := add(ret, 32) }
640         memcpy(retptr, self._ptr, self._len);
641         memcpy(retptr + self._len, other._ptr, other._len);
642         return ret;
643     }
644 
645     /*
646      * @dev Joins an array of slices, using `self` as a delimiter, returning a
647      *      newly allocated string.
648      * @param self The delimiter to use.
649      * @param parts A list of slices to join.
650      * @return A newly allocated string containing all the slices in `parts`,
651      *         joined with `self`.
652      */
653     function join(slice self, slice[] parts) internal returns (string) {
654         if (parts.length == 0)
655             return "";
656 
657         uint len = self._len * (parts.length - 1);
658         for(uint i = 0; i < parts.length; i++)
659             len += parts[i]._len;
660 
661         var ret = new string(len);
662         uint retptr;
663         assembly { retptr := add(ret, 32) }
664 
665         for(i = 0; i < parts.length; i++) {
666             memcpy(retptr, parts[i]._ptr, parts[i]._len);
667             retptr += parts[i]._len;
668             if (i < parts.length - 1) {
669                 memcpy(retptr, self._ptr, self._len);
670                 retptr += self._len;
671             }
672         }
673 
674         return ret;
675     }
676 }
677 
678 library ConvertStringByte {
679   function bytes32ToString(bytes32 x) constant returns (string) {
680     bytes memory bytesString = new bytes(32);
681     uint charCount = 0;
682     for (uint j = 0; j < 32; j++) {
683       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
684       if (char != 0) {
685           bytesString[charCount] = char;
686           charCount++;
687       }
688     }
689     bytes memory bytesStringTrimmed = new bytes(charCount);
690     for (j = 0; j < charCount; j++) {
691       bytesStringTrimmed[j] = bytesString[j];
692     }
693     return string(bytesStringTrimmed);
694   }
695 
696   function stringToBytes32(string memory source) returns (bytes32 result) {
697     assembly {
698       result := mload(add(source, 32))
699     }
700   }
701 }
702 
703 
704 /**
705  * @title Ownable
706  * @dev The Ownable contract has an owner address, and provides basic authorization control
707  * functions, this simplifies the implementation of "user permissions".
708  */
709 contract Ownable {
710   address public owner;
711 
712 
713   /**
714    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
715    * account.
716    */
717   function Ownable() {
718     owner = msg.sender;
719   }
720 
721 
722   /**
723    * @dev Throws if called by any account other than the owner.
724    */
725   modifier onlyOwner() {
726     require(msg.sender == owner);
727     _;
728   }
729 
730 
731   /**
732    * @dev Allows the current owner to transfer control of the contract to a newOwner.
733    * @param newOwner The address to transfer ownership to.
734    */
735   function transferOwnership(address newOwner) onlyOwner {
736     if (newOwner != address(0)) {
737       owner = newOwner;
738     }
739   }
740 
741 }
742 
743 
744 contract Platinum is Ownable {
745   using SafeMath for uint256;
746   using Strings for *;
747 
748   // ========= 宣告 =========
749   string public version = "0.0.1";
750   // 基本單位
751   string public unit = "oz";
752   // 總供給量
753   uint256 public total;
754   // 存貨
755   struct Bullion {
756     string index;
757     string unit;
758     uint256 amount;
759     string ipfs;
760   }
761   bytes32[] public storehouseIndex;
762   mapping (bytes32 => Bullion) public storehouse;
763   // 掛勾貨幣
764   address public token;
765   // 匯率 1白金：白金幣
766   uint256 public rate = 10;
767   // PlatinumToken 實例
768   PlatinumToken coin;
769 
770 
771 
772 
773 
774   // ========= 初始化 =========
775   function Platinum() {
776 
777   }
778 
779 
780 
781 
782   // ========= event =========
783   event Stock (
784     string index,
785     string unit,
786     uint256 amount,
787     string ipfs,
788     uint256 total
789   );
790 
791   event Ship (
792     string index,
793     uint256 total
794   );
795 
796   event Mint (
797     uint256 amount,
798     uint256 total
799   );
800 
801   event Alchemy (
802     uint256 amount,
803     uint256 total
804   );
805 
806   event Buy (
807     string index,
808     address from,
809     uint256 fee,
810     uint256 price
811   );
812 
813 
814 
815 
816 
817 
818   // ========= 擁有者方法 =========
819 
820   /**
821    * 操作存貨-進貨
822    *
823    * 此方法執行：
824    *  - 紀錄新增的白金，紀錄資訊：
825    *    - index: 白金編號
826    *    - unit: 白金單位
827    *    - amount: 數量
828    *    - ipfs: 白金證明URL
829    *  - 增加白金總庫存數量，量為amount
830    *
831    * Requires:
832    *  - 執行者須為owner
833    *  - 白金編號index不能重複
834    *  - 單位須等於目前合約所設定的單位
835    *  - 量amount需大於0
836    *
837    * Returns:
838    *  - bool: 執行成功時，回傳true
839    *
840    * Events:
841    *  - Stock: 執行成功時觸發
842    */
843   function stock(string _index, string _unit, uint256 _amount, string _ipfs) onlyOwner returns (bool) {
844     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
845 
846     require(_amount > 0);
847     require(_unit.toSlice().equals(unit.toSlice()));
848     require(!(storehouse[_bindex].amount > 0));
849 
850     Bullion bullion = storehouse[_bindex];
851     bullion.index = _index;
852     bullion.unit = _unit;
853     bullion.amount = _amount;
854     bullion.ipfs = _ipfs;
855 
856     // 加入倉儲目錄
857     storehouseIndex.push(_bindex);
858     // 加入倉儲
859     storehouse[_bindex] = bullion;
860 
861     // 增加總庫存
862     total = total.add(_amount);
863 
864     Stock(bullion.index, bullion.unit, bullion.amount, bullion.ipfs, total);
865 
866     return true;
867   }
868 
869   /**
870    * 操作存貨-出貨
871    *
872    * 此方法執行：
873    *  - 移除白金庫存
874    *  - 減少白金總庫存量，量為白金庫存的數量
875    *
876    * Requires:
877    *  - 執行者為owner
878    *  - 白金編號index需存在於紀錄（已使用stock方法新增該庫存）
879    *  - 白金總庫存需足夠，大於指定白金庫存的數量
880    *
881    * Returns:
882    *  - bool: 執行成功時，回傳true
883    *
884    * Events:
885    *  - Ship: 執行成功時觸發
886    */
887   function ship(string _index) onlyOwner returns (bool) {
888     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
889 
890     require(storehouse[_bindex].amount > 0);
891     Bullion bullion = storehouse[_bindex];
892     require(total.sub(bullion.amount) >= 0);
893 
894     uint256 tmpAmount = bullion.amount;
895 
896     for (uint256 index = 0; index < storehouseIndex.length; index++) {
897       Bullion _bullion = storehouse[storehouseIndex[index]];
898       if (_bullion.index.toSlice().equals(_index.toSlice())) {
899         // 從倉儲目錄移除
900         delete storehouseIndex[index];
901       }
902     }
903     // 從倉儲移除
904     delete storehouse[_bindex];
905     // 減少總庫存
906     total = total.sub(tmpAmount);
907 
908     Ship(bullion.index, total);
909 
910     return true;
911   }
912 
913   /**
914    * 鑄幣
915    *
916    * 此方法執行：
917    *  - 增加白金代幣數量
918    *  - 減少總白金庫存
919    *
920    * Requires:
921    *  - 執行者為owner
922    *  - 白金總庫存需足夠，即大於等於ptAmount
923    *  - 白金代幣合約需已設定（setTokenAddress方法）
924    *
925    * Returns:
926    *  - bool: 執行成功時，回傳true
927    *
928    * Events:
929    *  - Mint: 執行成功時觸發
930    */
931   function mint(uint256 _ptAmount) onlyOwner returns (bool) {
932     require(token != 0x0);
933 
934     uint256 amount = convert2PlatinumToken(_ptAmount);
935     // 發送token的增加涵式
936     bool produced = coin.produce(amount);
937     require(produced);
938 
939     total = total.sub(_ptAmount);
940 
941     Mint(_ptAmount, total);
942 
943     return true;
944   }
945 
946   /**
947    * 煉金
948    *
949    * 此方法執行：
950    *  - 減少白金代幣
951    *  - 增加總白金庫存
952    *
953    * Requires:
954    *  - 執行者為owner
955    *  - 需已設定白金代幣合約（setTokenAddress方法）
956    *  - 白金代幣owner所擁有的代幣足夠，即tokenAmount小於等於代幣owner的白金代幣數量
957    *
958    * Returns:
959    *  - bool: 執行成功，回傳true
960    *
961    * Events:
962    *  - Alchemy: 執行成功時觸發
963    */
964   function alchemy(uint256 _tokenAmount) onlyOwner returns (bool) {
965     require(token != 0x0);
966 
967     uint256 amount = convert2Platinum(_tokenAmount);
968     bool reduced = coin.reduce(_tokenAmount);
969     require(reduced);
970 
971     total = total.add(amount);
972 
973     Alchemy(amount, total);
974 
975     return true;
976   }
977 
978   /**
979    * 設定-匯率
980    *
981    * 匯率規則:
982    *  - 白金數量 * 匯率 = 白金代幣數量
983    *  - 白金代幣數量 / 匯率 = 白金數量
984    *
985    * Requires:
986    *  - 執行者為owner
987    *  - 匯率rate需大於0
988    *
989    * Returns:
990    *  - bool: 執行成功，回傳true
991    */
992   function setRate(uint256 _rate) onlyOwner returns (bool) {
993     require(_rate > 0);
994 
995     rate = _rate;
996     return true;
997   }
998 
999   /**
1000    * 設定-Token地址
1001    *
1002    * 設定白金合約地址
1003    *
1004    * Requires:
1005    *  - 執行者為owner
1006    *  - 合約地址address不為0
1007    *
1008    * Returns:
1009    *  - bool: 執行成功，回傳true
1010    */
1011   function setTokenAddress(address _address) onlyOwner returns (bool) {
1012     require(_address != 0x0);
1013 
1014     coin = PlatinumToken(_address);
1015     token = _address;
1016     return true;
1017   }
1018 
1019   /**
1020    * 購買金條
1021    *
1022    * 此方法執行：
1023    *  - 扣除buyer的白金代幣
1024    *  - 移除白金庫存，代表buyer已從庫存買走白金
1025    *
1026    * Requires:
1027    *  - 執行者為owner
1028    *  - 白金編號index需存在於紀錄（已使用stock方法新增該庫存）
1029    *
1030    * Returns:
1031    *  - bool: 執行成功，回傳true
1032    *
1033    * Events:
1034    *  - Buy: 執行成功時觸發
1035    */
1036   function buy(string _index, address buyer) onlyOwner returns (bool) {
1037     require(token != 0x0);
1038     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
1039     uint256 fee = coin.fee();
1040     require(storehouse[_bindex].amount > 0);
1041 
1042     Bullion bullion = storehouse[_bindex];
1043     uint256 tokenPrice = convert2PlatinumToken(bullion.amount);
1044     uint256 tokenPriceFee = tokenPrice.add(fee);
1045 
1046     // 轉帳
1047     bool transfered = coin.transferFrom(buyer, coin.owner(), tokenPriceFee);
1048     require(transfered);
1049 
1050     // 直接把剛剛賣出的價格煉金
1051     bool reduced = coin.reduce(tokenPrice);
1052     require(reduced);
1053 
1054     // 減少庫存
1055     for (uint256 index = 0; index < storehouseIndex.length; index++) {
1056       Bullion _bullion = storehouse[storehouseIndex[index]];
1057       if (_bullion.index.toSlice().equals(_index.toSlice())) {
1058         // 從倉儲目錄移除
1059         delete storehouseIndex[index];
1060       }
1061     }
1062     // 從倉儲移除
1063     delete storehouse[_bindex];
1064 
1065     Buy(_index, buyer, fee, tokenPrice);
1066 
1067     return true;
1068   }
1069 
1070 
1071 
1072 
1073 
1074   // ========= 公共方法 =========
1075 
1076   // 比率轉換-白金幣換白金
1077   function convert2Platinum(uint256 _amount) constant returns (uint256) {
1078     return _amount.div(rate);
1079   }
1080 
1081   // 比率轉換-白金換白金幣
1082   function convert2PlatinumToken(uint256 _amount) constant returns (uint256) {
1083     return _amount.mul(rate);
1084   }
1085 
1086   // 金條資訊
1087   function info(string _index) constant returns (string, string, uint256, string) {
1088     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
1089     require(storehouse[_bindex].amount > 0);
1090 
1091     Bullion bullion = storehouse[_bindex];
1092 
1093     return (bullion.index, bullion.unit, bullion.amount, bullion.ipfs);
1094   }
1095 }
1096 
1097 
1098 /**
1099  * @title SafeMath
1100  * @dev Math operations with safety checks that throw on error
1101  */
1102 library SafeMath {
1103   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1104     uint256 c = a * b;
1105     assert(a == 0 || c / a == b);
1106     return c;
1107   }
1108 
1109   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1110     // assert(b > 0); // Solidity automatically throws when dividing by 0
1111     uint256 c = a / b;
1112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1113     return c;
1114   }
1115 
1116   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1117     assert(b <= a);
1118     return a - b;
1119   }
1120 
1121   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1122     uint256 c = a + b;
1123     assert(c >= a);
1124     return c;
1125   }
1126 }
1127 
1128 /**
1129  * @title ERC20Basic
1130  * @dev Simpler version of ERC20 interface
1131  * @dev see https://github.com/ethereum/EIPs/issues/179
1132  */
1133 contract ERC20Basic {
1134   uint256 public totalSupply;
1135   function balanceOf(address who) constant returns (uint256);
1136   function transfer(address to, uint256 value) returns (bool);
1137   event Transfer(address indexed from, address indexed to, uint256 value);
1138 }
1139 
1140 /**
1141  * @title ERC20 interface
1142  * @dev see https://github.com/ethereum/EIPs/issues/20
1143  */
1144 contract ERC20 is ERC20Basic {
1145   function allowance(address owner, address spender) constant returns (uint256);
1146   function transferFrom(address from, address to, uint256 value) returns (bool);
1147   function approve(address spender, uint256 value) returns (bool);
1148   event Approval(address indexed owner, address indexed spender, uint256 value);
1149 }
1150 
1151 
1152 contract PlatinumToken is Ownable, ERC20 {
1153   using SafeMath for uint256;
1154   // ========= 宣告 =========
1155 
1156   // 版本
1157   string public version = "0.0.1";
1158   // 名稱
1159   string public name;
1160   // 標記
1161   string public symbol;
1162   // 小數點位數
1163   uint256 public decimals;
1164   // 白金合約地址
1165   address public platinum;
1166 
1167   mapping (address => mapping (address => uint256)) allowed;
1168   mapping(address => uint256) balances;
1169   // 總供給量
1170   uint256 public totalSupply;
1171   // 手續費
1172   uint256 public fee = 10;
1173 
1174   // ========= 初始化 =========
1175   function PlatinumToken(
1176     uint256 initialSupply,
1177     string tokenName,
1178     uint8 decimalUnits,
1179     string tokenSymbol
1180     ) {
1181     balances[msg.sender] = initialSupply;
1182     totalSupply = initialSupply;
1183     name = tokenName;
1184     symbol = tokenSymbol;
1185     decimals = decimalUnits;
1186   }
1187 
1188   // ========= 權限控管 =========
1189   modifier isPlatinumContract() {
1190     require(platinum != 0x0);
1191     require(msg.sender == platinum);
1192     _;
1193   }
1194 
1195   modifier isOwnerOrPlatinumContract() {
1196     require(msg.sender != address(0) && (msg.sender == platinum || msg.sender == owner));
1197     _;
1198   }
1199 
1200   /**
1201    * 增產
1202    *
1203    *  此方法執行：
1204    *    - 增加owner的balance，量為指定的amount
1205    *    - 增加totalSupply，量為指定的amount
1206    *
1207    *  Requires:
1208    *    - 執行者為白金合約（可透過setPlatinumAddress方法設定）
1209    *    - amount須設定為0以上
1210    *
1211    *  Return:
1212    *    - bool: 執行成功回傳true
1213    */
1214   function produce(uint256 amount) isPlatinumContract returns (bool) {
1215     balances[owner] = balances[owner].add(amount);
1216     totalSupply = totalSupply.add(amount);
1217 
1218     return true;
1219   }
1220 
1221   /** 減產
1222    *
1223    *  此方法執行：
1224    *    - 減少owner的balance，量為指定的amount
1225    *    - 減少totalSupply，量為指定的amount
1226    *
1227    *  Requires:
1228    *    - 執行者為白金合約（可透過setPlatinumAddress方法設定）
1229    *    - amount須設定為0以上
1230    *    - owner的balance需大於等於指定的amount
1231    *    - totalSupply需大於等於指定的amount
1232    *
1233    *  Return:
1234    *    - bool: 執行成功回傳true
1235    */
1236   function reduce(uint256 amount) isPlatinumContract returns (bool) {
1237     require(balances[owner].sub(amount) >= 0);
1238     require(totalSupply.sub(amount) >= 0);
1239 
1240     balances[owner] = balances[owner].sub(amount);
1241     totalSupply = totalSupply.sub(amount);
1242 
1243     return true;
1244   }
1245 
1246   /**
1247    * 設定-白金合約地址
1248    *
1249    * 此方法執行：
1250    *  - 修改此合約所認識的白金合約地址，此地址決定能執行produce和reduce方法的合約
1251    *
1252    * Requires:
1253    *  - 執行者須為owner
1254    *  - 地址不能設為0
1255    *
1256    * Returns:
1257    *  - bool: 設定成功時回傳true
1258    */
1259   function setPlatinumAddress(address _address) onlyOwner returns (bool) {
1260     require(_address != 0x0);
1261 
1262     platinum = _address;
1263     return true;
1264   }
1265 
1266   /**
1267    * 設定-手續費
1268    *
1269    * 手續費規則：
1270    *  - 購買金條時，代幣量總量增加手續費為總扣除代幣總量
1271    *
1272    * Requires:
1273    *  - 執行者為owner
1274    *
1275    * Returns:
1276    *  - bool: 執行成功，回傳true
1277    */
1278   function setFee(uint256 _fee) onlyOwner returns (bool) {
1279     require(_fee >= 0);
1280 
1281     fee = _fee;
1282     return true;
1283   }
1284 
1285   /**
1286    * 交易，轉移白金代幣
1287    *
1288    * 此方法執行：
1289    *  - 減少from的白金代幣，量為value
1290    *  - 增加to的白金代幣，量為value
1291    *
1292    * Requires:
1293    *  - 執行者為owner
1294    *
1295    * Returns:
1296    *  - bool: 執行成功回傳true
1297    *
1298    * Events:
1299    *  - Transfer: 執行成功時，觸發此事件
1300    */
1301   function transfer(address _to, uint256 _value) onlyOwner returns (bool) {
1302     balances[owner] = balances[owner].sub(_value);
1303     balances[_to] = balances[_to].add(_value);
1304 
1305     Transfer(owner, _to, _value);
1306 
1307     return true;
1308   }
1309 
1310   /**
1311    * 查詢白金代幣餘額
1312    *
1313    * Returns:
1314    *  - balance: 指定address的白金代幣餘額
1315    */
1316   function balanceOf(address _owner) constant returns (uint256 balance) {
1317     return balances[_owner];
1318   }
1319 
1320   /**
1321    * 轉帳
1322    *
1323    * 實際將approve過的token數量進行交易
1324    *
1325    * 此方法執行：
1326    *  - 交易指定數量的代幣
1327    *
1328    * Requires:
1329    *  - 交易的代幣數量value需大於0
1330    *  - allowed的代幣數量需大於value（allowed的代幣先由呼叫approve方法設定）
1331    *
1332    * Returns:
1333    *  - bool: 執行成功，回傳true
1334    */
1335   function transferFrom(address _from, address _to, uint256 _value) isOwnerOrPlatinumContract returns (bool) {
1336     var _allowance = allowed[_from][owner];
1337 
1338     uint256 valueSubFee = _value.sub(fee);
1339 
1340     balances[_to] = balances[_to].add(valueSubFee);
1341     balances[_from] = balances[_from].sub(_value);
1342     balances[owner] = balances[owner].add(fee);
1343     allowed[_from][owner] = _allowance.sub(_value);
1344 
1345     Transfer(_from, _to, _value);
1346 
1347     return true;
1348   }
1349 
1350   /**
1351    * 轉帳 - 允許
1352    *
1353    * 允許一定數量的代幣可以轉帳至owner
1354    *
1355    * 欲修改允許值，需先執行此方法將value設為0，再執行一次此方法將value設為指定值
1356    *
1357    * 此方法操作：
1358    *  - 修改allowed值，紀錄sender允許轉帳value數量代幣給owner
1359    *  - allowed值有設定時，value須為0
1360    *  - allowed值未設定時，value不為0
1361    *
1362    * Returns:
1363    *  - bool: 執行成功，回傳true
1364    */
1365   function approve(address _dummy, uint256 _value) returns (bool) {
1366     // To change the approve amount you first have to reduce the addresses`
1367     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1368     //  already 0 to mitigate the race condition described here:
1369     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1370     require((_value == 0) || (allowed[msg.sender][owner] == 0));
1371 
1372     allowed[msg.sender][owner] = _value;
1373     Approval(msg.sender, owner, _value);
1374     return true;
1375   }
1376 
1377   /**
1378    * 轉帳 - 查詢允許值
1379    *
1380    * Returns:
1381    *  - unit256: 允許值
1382    */
1383   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1384     return allowed[_owner][_spender];
1385   }
1386 
1387   /**
1388    * 刪除合約
1389    *
1390    * 此方法呼叫合約內建的selfdestruct方法
1391    */
1392   function suicide() onlyOwner returns (bool) {
1393     selfdestruct(owner);
1394     return true;
1395   }
1396 }