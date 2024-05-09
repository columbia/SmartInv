1 pragma solidity ^0.4.13;
2 
3 library ConvertStringByte {
4   function bytes32ToString(bytes32 x) constant returns (string) {
5     bytes memory bytesString = new bytes(32);
6     uint charCount = 0;
7     for (uint j = 0; j < 32; j++) {
8       byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
9       if (char != 0) {
10           bytesString[charCount] = char;
11           charCount++;
12       }
13     }
14     bytes memory bytesStringTrimmed = new bytes(charCount);
15     for (j = 0; j < charCount; j++) {
16       bytesStringTrimmed[j] = bytesString[j];
17     }
18     return string(bytesStringTrimmed);
19   }
20 
21   function stringToBytes32(string memory source) returns (bytes32 result) {
22     assembly {
23       result := mload(add(source, 32))
24     }
25   }
26 }
27 
28 library Strings {
29     struct slice {
30         uint _len;
31         uint _ptr;
32     }
33 
34     function memcpy(uint dest, uint src, uint len) private {
35         // Copy word-length chunks while possible
36         for(; len >= 32; len -= 32) {
37             assembly {
38                 mstore(dest, mload(src))
39             }
40             dest += 32;
41             src += 32;
42         }
43 
44         // Copy remaining bytes
45         uint mask = 256 ** (32 - len) - 1;
46         assembly {
47             let srcpart := and(mload(src), not(mask))
48             let destpart := and(mload(dest), mask)
49             mstore(dest, or(destpart, srcpart))
50         }
51     }
52 
53     /*
54      * @dev Returns a slice containing the entire string.
55      * @param self The string to make a slice from.
56      * @return A newly allocated slice containing the entire string.
57      */
58     function toSlice(string self) internal returns (slice) {
59         uint ptr;
60         assembly {
61             ptr := add(self, 0x20)
62         }
63         return slice(bytes(self).length, ptr);
64     }
65 
66     /*
67      * @dev Returns the length of a null-terminated bytes32 string.
68      * @param self The value to find the length of.
69      * @return The length of the string, from 0 to 32.
70      */
71     function len(bytes32 self) internal returns (uint) {
72         uint ret;
73         if (self == 0)
74             return 0;
75         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
76             ret += 16;
77             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
78         }
79         if (self & 0xffffffffffffffff == 0) {
80             ret += 8;
81             self = bytes32(uint(self) / 0x10000000000000000);
82         }
83         if (self & 0xffffffff == 0) {
84             ret += 4;
85             self = bytes32(uint(self) / 0x100000000);
86         }
87         if (self & 0xffff == 0) {
88             ret += 2;
89             self = bytes32(uint(self) / 0x10000);
90         }
91         if (self & 0xff == 0) {
92             ret += 1;
93         }
94         return 32 - ret;
95     }
96 
97     /*
98      * @dev Returns a slice containing the entire bytes32, interpreted as a
99      *      null-termintaed utf-8 string.
100      * @param self The bytes32 value to convert to a slice.
101      * @return A new slice containing the value of the input argument up to the
102      *         first null.
103      */
104     function toSliceB32(bytes32 self) internal returns (slice ret) {
105         // Allocate space for `self` in memory, copy it there, and point ret at it
106         assembly {
107             let ptr := mload(0x40)
108             mstore(0x40, add(ptr, 0x20))
109             mstore(ptr, self)
110             mstore(add(ret, 0x20), ptr)
111         }
112         ret._len = len(self);
113     }
114 
115     /*
116      * @dev Returns a new slice containing the same data as the current slice.
117      * @param self The slice to copy.
118      * @return A new slice containing the same data as `self`.
119      */
120     function copy(slice self) internal returns (slice) {
121         return slice(self._len, self._ptr);
122     }
123 
124     /*
125      * @dev Copies a slice to a new string.
126      * @param self The slice to copy.
127      * @return A newly allocated string containing the slice's text.
128      */
129     function toString(slice self) internal returns (string) {
130         var ret = new string(self._len);
131         uint retptr;
132         assembly { retptr := add(ret, 32) }
133 
134         memcpy(retptr, self._ptr, self._len);
135         return ret;
136     }
137 
138     /*
139      * @dev Returns the length in runes of the slice. Note that this operation
140      *      takes time proportional to the length of the slice; avoid using it
141      *      in loops, and call `slice.empty()` if you only need to know whether
142      *      the slice is empty or not.
143      * @param self The slice to operate on.
144      * @return The length of the slice in runes.
145      */
146     function len(slice self) internal returns (uint) {
147         // Starting at ptr-31 means the LSB will be the byte we care about
148         var ptr = self._ptr - 31;
149         var end = ptr + self._len;
150         for (uint len = 0; ptr < end; len++) {
151             uint8 b;
152             assembly { b := and(mload(ptr), 0xFF) }
153             if (b < 0x80) {
154                 ptr += 1;
155             } else if(b < 0xE0) {
156                 ptr += 2;
157             } else if(b < 0xF0) {
158                 ptr += 3;
159             } else if(b < 0xF8) {
160                 ptr += 4;
161             } else if(b < 0xFC) {
162                 ptr += 5;
163             } else {
164                 ptr += 6;
165             }
166         }
167         return len;
168     }
169 
170     /*
171      * @dev Returns true if the slice is empty (has a length of 0).
172      * @param self The slice to operate on.
173      * @return True if the slice is empty, False otherwise.
174      */
175     function empty(slice self) internal returns (bool) {
176         return self._len == 0;
177     }
178 
179     /*
180      * @dev Returns a positive number if `other` comes lexicographically after
181      *      `self`, a negative number if it comes before, or zero if the
182      *      contents of the two slices are equal. Comparison is done per-rune,
183      *      on unicode codepoints.
184      * @param self The first slice to compare.
185      * @param other The second slice to compare.
186      * @return The result of the comparison.
187      */
188     function compare(slice self, slice other) internal returns (int) {
189         uint shortest = self._len;
190         if (other._len < self._len)
191             shortest = other._len;
192 
193         var selfptr = self._ptr;
194         var otherptr = other._ptr;
195         for (uint idx = 0; idx < shortest; idx += 32) {
196             uint a;
197             uint b;
198             assembly {
199                 a := mload(selfptr)
200                 b := mload(otherptr)
201             }
202             if (a != b) {
203                 // Mask out irrelevant bytes and check again
204                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
205                 var diff = (a & mask) - (b & mask);
206                 if (diff != 0)
207                     return int(diff);
208             }
209             selfptr += 32;
210             otherptr += 32;
211         }
212         return int(self._len) - int(other._len);
213     }
214 
215     /*
216      * @dev Returns true if the two slices contain the same text.
217      * @param self The first slice to compare.
218      * @param self The second slice to compare.
219      * @return True if the slices are equal, false otherwise.
220      */
221     function equals(slice self, slice other) internal returns (bool) {
222         return compare(self, other) == 0;
223     }
224 
225     /*
226      * @dev Extracts the first rune in the slice into `rune`, advancing the
227      *      slice to point to the next rune and returning `self`.
228      * @param self The slice to operate on.
229      * @param rune The slice that will contain the first rune.
230      * @return `rune`.
231      */
232     function nextRune(slice self, slice rune) internal returns (slice) {
233         rune._ptr = self._ptr;
234 
235         if (self._len == 0) {
236             rune._len = 0;
237             return rune;
238         }
239 
240         uint len;
241         uint b;
242         // Load the first byte of the rune into the LSBs of b
243         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
244         if (b < 0x80) {
245             len = 1;
246         } else if(b < 0xE0) {
247             len = 2;
248         } else if(b < 0xF0) {
249             len = 3;
250         } else {
251             len = 4;
252         }
253 
254         // Check for truncated codepoints
255         if (len > self._len) {
256             rune._len = self._len;
257             self._ptr += self._len;
258             self._len = 0;
259             return rune;
260         }
261 
262         self._ptr += len;
263         self._len -= len;
264         rune._len = len;
265         return rune;
266     }
267 
268     /*
269      * @dev Returns the first rune in the slice, advancing the slice to point
270      *      to the next rune.
271      * @param self The slice to operate on.
272      * @return A slice containing only the first rune from `self`.
273      */
274     function nextRune(slice self) internal returns (slice ret) {
275         nextRune(self, ret);
276     }
277 
278     /*
279      * @dev Returns the number of the first codepoint in the slice.
280      * @param self The slice to operate on.
281      * @return The number of the first codepoint in the slice.
282      */
283     function ord(slice self) internal returns (uint ret) {
284         if (self._len == 0) {
285             return 0;
286         }
287 
288         uint word;
289         uint len;
290         uint div = 2 ** 248;
291 
292         // Load the rune into the MSBs of b
293         assembly { word:= mload(mload(add(self, 32))) }
294         var b = word / div;
295         if (b < 0x80) {
296             ret = b;
297             len = 1;
298         } else if(b < 0xE0) {
299             ret = b & 0x1F;
300             len = 2;
301         } else if(b < 0xF0) {
302             ret = b & 0x0F;
303             len = 3;
304         } else {
305             ret = b & 0x07;
306             len = 4;
307         }
308 
309         // Check for truncated codepoints
310         if (len > self._len) {
311             return 0;
312         }
313 
314         for (uint i = 1; i < len; i++) {
315             div = div / 256;
316             b = (word / div) & 0xFF;
317             if (b & 0xC0 != 0x80) {
318                 // Invalid UTF-8 sequence
319                 return 0;
320             }
321             ret = (ret * 64) | (b & 0x3F);
322         }
323 
324         return ret;
325     }
326 
327     /*
328      * @dev Returns the keccak-256 hash of the slice.
329      * @param self The slice to hash.
330      * @return The hash of the slice.
331      */
332     function keccak(slice self) internal returns (bytes32 ret) {
333         assembly {
334             ret := sha3(mload(add(self, 32)), mload(self))
335         }
336     }
337 
338     /*
339      * @dev Returns true if `self` starts with `needle`.
340      * @param self The slice to operate on.
341      * @param needle The slice to search for.
342      * @return True if the slice starts with the provided text, false otherwise.
343      */
344     function startsWith(slice self, slice needle) internal returns (bool) {
345         if (self._len < needle._len) {
346             return false;
347         }
348 
349         if (self._ptr == needle._ptr) {
350             return true;
351         }
352 
353         bool equal;
354         assembly {
355             let len := mload(needle)
356             let selfptr := mload(add(self, 0x20))
357             let needleptr := mload(add(needle, 0x20))
358             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
359         }
360         return equal;
361     }
362 
363     /*
364      * @dev If `self` starts with `needle`, `needle` is removed from the
365      *      beginning of `self`. Otherwise, `self` is unmodified.
366      * @param self The slice to operate on.
367      * @param needle The slice to search for.
368      * @return `self`
369      */
370     function beyond(slice self, slice needle) internal returns (slice) {
371         if (self._len < needle._len) {
372             return self;
373         }
374 
375         bool equal = true;
376         if (self._ptr != needle._ptr) {
377             assembly {
378                 let len := mload(needle)
379                 let selfptr := mload(add(self, 0x20))
380                 let needleptr := mload(add(needle, 0x20))
381                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
382             }
383         }
384 
385         if (equal) {
386             self._len -= needle._len;
387             self._ptr += needle._len;
388         }
389 
390         return self;
391     }
392 
393     /*
394      * @dev Returns true if the slice ends with `needle`.
395      * @param self The slice to operate on.
396      * @param needle The slice to search for.
397      * @return True if the slice starts with the provided text, false otherwise.
398      */
399     function endsWith(slice self, slice needle) internal returns (bool) {
400         if (self._len < needle._len) {
401             return false;
402         }
403 
404         var selfptr = self._ptr + self._len - needle._len;
405 
406         if (selfptr == needle._ptr) {
407             return true;
408         }
409 
410         bool equal;
411         assembly {
412             let len := mload(needle)
413             let needleptr := mload(add(needle, 0x20))
414             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
415         }
416 
417         return equal;
418     }
419 
420     /*
421      * @dev If `self` ends with `needle`, `needle` is removed from the
422      *      end of `self`. Otherwise, `self` is unmodified.
423      * @param self The slice to operate on.
424      * @param needle The slice to search for.
425      * @return `self`
426      */
427     function until(slice self, slice needle) internal returns (slice) {
428         if (self._len < needle._len) {
429             return self;
430         }
431 
432         var selfptr = self._ptr + self._len - needle._len;
433         bool equal = true;
434         if (selfptr != needle._ptr) {
435             assembly {
436                 let len := mload(needle)
437                 let needleptr := mload(add(needle, 0x20))
438                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
439             }
440         }
441 
442         if (equal) {
443             self._len -= needle._len;
444         }
445 
446         return self;
447     }
448 
449     // Returns the memory address of the first byte of the first occurrence of
450     // `needle` in `self`, or the first byte after `self` if not found.
451     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
452         uint ptr;
453         uint idx;
454 
455         if (needlelen <= selflen) {
456             if (needlelen <= 32) {
457                 // Optimized assembly for 68 gas per byte on short strings
458                 assembly {
459                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
460                     let needledata := and(mload(needleptr), mask)
461                     let end := add(selfptr, sub(selflen, needlelen))
462                     ptr := selfptr
463                     loop:
464                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
465                     ptr := add(ptr, 1)
466                     jumpi(loop, lt(sub(ptr, 1), end))
467                     ptr := add(selfptr, selflen)
468                     exit:
469                 }
470                 return ptr;
471             } else {
472                 // For long needles, use hashing
473                 bytes32 hash;
474                 assembly { hash := sha3(needleptr, needlelen) }
475                 ptr = selfptr;
476                 for (idx = 0; idx <= selflen - needlelen; idx++) {
477                     bytes32 testHash;
478                     assembly { testHash := sha3(ptr, needlelen) }
479                     if (hash == testHash)
480                         return ptr;
481                     ptr += 1;
482                 }
483             }
484         }
485         return selfptr + selflen;
486     }
487 
488     // Returns the memory address of the first byte after the last occurrence of
489     // `needle` in `self`, or the address of `self` if not found.
490     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
491         uint ptr;
492 
493         if (needlelen <= selflen) {
494             if (needlelen <= 32) {
495                 // Optimized assembly for 69 gas per byte on short strings
496                 assembly {
497                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
498                     let needledata := and(mload(needleptr), mask)
499                     ptr := add(selfptr, sub(selflen, needlelen))
500                     loop:
501                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
502                     ptr := sub(ptr, 1)
503                     jumpi(loop, gt(add(ptr, 1), selfptr))
504                     ptr := selfptr
505                     jump(exit)
506                     ret:
507                     ptr := add(ptr, needlelen)
508                     exit:
509                 }
510                 return ptr;
511             } else {
512                 // For long needles, use hashing
513                 bytes32 hash;
514                 assembly { hash := sha3(needleptr, needlelen) }
515                 ptr = selfptr + (selflen - needlelen);
516                 while (ptr >= selfptr) {
517                     bytes32 testHash;
518                     assembly { testHash := sha3(ptr, needlelen) }
519                     if (hash == testHash)
520                         return ptr + needlelen;
521                     ptr -= 1;
522                 }
523             }
524         }
525         return selfptr;
526     }
527 
528     /*
529      * @dev Modifies `self` to contain everything from the first occurrence of
530      *      `needle` to the end of the slice. `self` is set to the empty slice
531      *      if `needle` is not found.
532      * @param self The slice to search and modify.
533      * @param needle The text to search for.
534      * @return `self`.
535      */
536     function find(slice self, slice needle) internal returns (slice) {
537         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
538         self._len -= ptr - self._ptr;
539         self._ptr = ptr;
540         return self;
541     }
542 
543     /*
544      * @dev Modifies `self` to contain the part of the string from the start of
545      *      `self` to the end of the first occurrence of `needle`. If `needle`
546      *      is not found, `self` is set to the empty slice.
547      * @param self The slice to search and modify.
548      * @param needle The text to search for.
549      * @return `self`.
550      */
551     function rfind(slice self, slice needle) internal returns (slice) {
552         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
553         self._len = ptr - self._ptr;
554         return self;
555     }
556 
557     /*
558      * @dev Splits the slice, setting `self` to everything after the first
559      *      occurrence of `needle`, and `token` to everything before it. If
560      *      `needle` does not occur in `self`, `self` is set to the empty slice,
561      *      and `token` is set to the entirety of `self`.
562      * @param self The slice to split.
563      * @param needle The text to search for in `self`.
564      * @param token An output parameter to which the first token is written.
565      * @return `token`.
566      */
567     function split(slice self, slice needle, slice token) internal returns (slice) {
568         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
569         token._ptr = self._ptr;
570         token._len = ptr - self._ptr;
571         if (ptr == self._ptr + self._len) {
572             // Not found
573             self._len = 0;
574         } else {
575             self._len -= token._len + needle._len;
576             self._ptr = ptr + needle._len;
577         }
578         return token;
579     }
580 
581     /*
582      * @dev Splits the slice, setting `self` to everything after the first
583      *      occurrence of `needle`, and returning everything before it. If
584      *      `needle` does not occur in `self`, `self` is set to the empty slice,
585      *      and the entirety of `self` is returned.
586      * @param self The slice to split.
587      * @param needle The text to search for in `self`.
588      * @return The part of `self` up to the first occurrence of `delim`.
589      */
590     function split(slice self, slice needle) internal returns (slice token) {
591         split(self, needle, token);
592     }
593 
594     /*
595      * @dev Splits the slice, setting `self` to everything before the last
596      *      occurrence of `needle`, and `token` to everything after it. If
597      *      `needle` does not occur in `self`, `self` is set to the empty slice,
598      *      and `token` is set to the entirety of `self`.
599      * @param self The slice to split.
600      * @param needle The text to search for in `self`.
601      * @param token An output parameter to which the first token is written.
602      * @return `token`.
603      */
604     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
605         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
606         token._ptr = ptr;
607         token._len = self._len - (ptr - self._ptr);
608         if (ptr == self._ptr) {
609             // Not found
610             self._len = 0;
611         } else {
612             self._len -= token._len + needle._len;
613         }
614         return token;
615     }
616 
617     /*
618      * @dev Splits the slice, setting `self` to everything before the last
619      *      occurrence of `needle`, and returning everything after it. If
620      *      `needle` does not occur in `self`, `self` is set to the empty slice,
621      *      and the entirety of `self` is returned.
622      * @param self The slice to split.
623      * @param needle The text to search for in `self`.
624      * @return The part of `self` after the last occurrence of `delim`.
625      */
626     function rsplit(slice self, slice needle) internal returns (slice token) {
627         rsplit(self, needle, token);
628     }
629 
630     /*
631      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
632      * @param self The slice to search.
633      * @param needle The text to search for in `self`.
634      * @return The number of occurrences of `needle` found in `self`.
635      */
636     function count(slice self, slice needle) internal returns (uint count) {
637         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
638         while (ptr <= self._ptr + self._len) {
639             count++;
640             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
641         }
642     }
643 
644     /*
645      * @dev Returns True if `self` contains `needle`.
646      * @param self The slice to search.
647      * @param needle The text to search for in `self`.
648      * @return True if `needle` is found in `self`, false otherwise.
649      */
650     function contains(slice self, slice needle) internal returns (bool) {
651         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
652     }
653 
654     /*
655      * @dev Returns a newly allocated string containing the concatenation of
656      *      `self` and `other`.
657      * @param self The first slice to concatenate.
658      * @param other The second slice to concatenate.
659      * @return The concatenation of the two strings.
660      */
661     function concat(slice self, slice other) internal returns (string) {
662         var ret = new string(self._len + other._len);
663         uint retptr;
664         assembly { retptr := add(ret, 32) }
665         memcpy(retptr, self._ptr, self._len);
666         memcpy(retptr + self._len, other._ptr, other._len);
667         return ret;
668     }
669 
670     /*
671      * @dev Joins an array of slices, using `self` as a delimiter, returning a
672      *      newly allocated string.
673      * @param self The delimiter to use.
674      * @param parts A list of slices to join.
675      * @return A newly allocated string containing all the slices in `parts`,
676      *         joined with `self`.
677      */
678     function join(slice self, slice[] parts) internal returns (string) {
679         if (parts.length == 0)
680             return "";
681 
682         uint len = self._len * (parts.length - 1);
683         for(uint i = 0; i < parts.length; i++)
684             len += parts[i]._len;
685 
686         var ret = new string(len);
687         uint retptr;
688         assembly { retptr := add(ret, 32) }
689 
690         for(i = 0; i < parts.length; i++) {
691             memcpy(retptr, parts[i]._ptr, parts[i]._len);
692             retptr += parts[i]._len;
693             if (i < parts.length - 1) {
694                 memcpy(retptr, self._ptr, self._len);
695                 retptr += self._len;
696             }
697         }
698 
699         return ret;
700     }
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
743 contract Platinum is Ownable {
744   using SafeMath for uint256;
745   using Strings for *;
746 
747   // ========= 宣告 =========
748   string public version = "0.0.1";
749   // 基本單位
750   string public unit = "oz";
751   // 總供給量
752   uint256 public total;
753   // 存貨
754   struct Bullion {
755     string index;
756     string unit;
757     uint256 amount;
758     string ipfs;
759   }
760   bytes32[] public storehouseIndex;
761   mapping (bytes32 => Bullion) public storehouse;
762   // 掛勾貨幣
763   address public token;
764   // 匯率 1白金：白金幣
765   uint256 public rate = 10;
766   // PlatinumToken 實例
767   PlatinumToken coin;
768 
769 
770 
771 
772 
773   // ========= 初始化 =========
774   function Platinum() {
775 
776   }
777 
778 
779 
780 
781   // ========= event =========
782   event Stock (
783     string index,
784     string unit,
785     uint256 amount,
786     string ipfs,
787     uint256 total
788   );
789 
790   event Ship (
791     string index,
792     uint256 total
793   );
794 
795   event Mint (
796     uint256 amount,
797     uint256 total
798   );
799 
800   event Alchemy (
801     uint256 amount,
802     uint256 total
803   );
804 
805   event Buy (
806     string index,
807     address from,
808     uint256 fee,
809     uint256 price
810   );
811 
812 
813 
814 
815 
816 
817   // ========= 擁有者方法 =========
818 
819   /**
820    * 操作存貨-進貨
821    *
822    * 此方法執行：
823    *  - 紀錄新增的白金，紀錄資訊：
824    *    - index: 白金編號
825    *    - unit: 白金單位
826    *    - amount: 數量
827    *    - ipfs: 白金證明URL
828    *  - 增加白金總庫存數量，量為amount
829    *
830    * Requires:
831    *  - 執行者須為owner
832    *  - 白金編號index不能重複
833    *  - 單位須等於目前合約所設定的單位
834    *  - 量amount需大於0
835    *
836    * Returns:
837    *  - bool: 執行成功時，回傳true
838    *
839    * Events:
840    *  - Stock: 執行成功時觸發
841    */
842   function stock(string _index, string _unit, uint256 _amount, string _ipfs) onlyOwner returns (bool) {
843     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
844 
845     require(_amount > 0);
846     require(_unit.toSlice().equals(unit.toSlice()));
847     require(!(storehouse[_bindex].amount > 0));
848 
849     Bullion bullion = storehouse[_bindex];
850     bullion.index = _index;
851     bullion.unit = _unit;
852     bullion.amount = _amount;
853     bullion.ipfs = _ipfs;
854 
855     // 加入倉儲目錄
856     storehouseIndex.push(_bindex);
857     // 加入倉儲
858     storehouse[_bindex] = bullion;
859 
860     // 增加總庫存
861     total = total.add(_amount);
862 
863     Stock(bullion.index, bullion.unit, bullion.amount, bullion.ipfs, total);
864 
865     return true;
866   }
867 
868   /**
869    * 操作存貨-出貨
870    *
871    * 此方法執行：
872    *  - 移除白金庫存
873    *  - 減少白金總庫存量，量為白金庫存的數量
874    *
875    * Requires:
876    *  - 執行者為owner
877    *  - 白金編號index需存在於紀錄（已使用stock方法新增該庫存）
878    *  - 白金總庫存需足夠，大於指定白金庫存的數量
879    *
880    * Returns:
881    *  - bool: 執行成功時，回傳true
882    *
883    * Events:
884    *  - Ship: 執行成功時觸發
885    */
886   function ship(string _index) onlyOwner returns (bool) {
887     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
888 
889     require(storehouse[_bindex].amount > 0);
890     Bullion bullion = storehouse[_bindex];
891     require(total.sub(bullion.amount) >= 0);
892 
893     uint256 tmpAmount = bullion.amount;
894 
895     for (uint256 index = 0; index < storehouseIndex.length; index++) {
896       Bullion _bullion = storehouse[storehouseIndex[index]];
897       if (_bullion.index.toSlice().equals(_index.toSlice())) {
898         // 從倉儲目錄移除
899         delete storehouseIndex[index];
900       }
901     }
902     // 從倉儲移除
903     delete storehouse[_bindex];
904     // 減少總庫存
905     total = total.sub(tmpAmount);
906 
907     Ship(bullion.index, total);
908 
909     return true;
910   }
911 
912   /**
913    * 鑄幣
914    *
915    * 此方法執行：
916    *  - 增加白金代幣數量
917    *  - 減少總白金庫存
918    *
919    * Requires:
920    *  - 執行者為owner
921    *  - 白金總庫存需足夠，即大於等於ptAmount
922    *  - 白金代幣合約需已設定（setTokenAddress方法）
923    *
924    * Returns:
925    *  - bool: 執行成功時，回傳true
926    *
927    * Events:
928    *  - Mint: 執行成功時觸發
929    */
930   function mint(uint256 _ptAmount) onlyOwner returns (bool) {
931     require(token != 0x0);
932 
933     uint256 amount = convert2PlatinumToken(_ptAmount);
934     // 發送token的增加涵式
935     bool produced = coin.produce(amount);
936     require(produced);
937 
938     total = total.sub(_ptAmount);
939 
940     Mint(_ptAmount, total);
941 
942     return true;
943   }
944 
945   /**
946    * 煉金
947    *
948    * 此方法執行：
949    *  - 減少白金代幣
950    *  - 增加總白金庫存
951    *
952    * Requires:
953    *  - 執行者為owner
954    *  - 需已設定白金代幣合約（setTokenAddress方法）
955    *  - 白金代幣owner所擁有的代幣足夠，即tokenAmount小於等於代幣owner的白金代幣數量
956    *
957    * Returns:
958    *  - bool: 執行成功，回傳true
959    *
960    * Events:
961    *  - Alchemy: 執行成功時觸發
962    */
963   function alchemy(uint256 _tokenAmount) onlyOwner returns (bool) {
964     require(token != 0x0);
965 
966     uint256 amount = convert2Platinum(_tokenAmount);
967     bool reduced = coin.reduce(_tokenAmount);
968     require(reduced);
969 
970     total = total.add(amount);
971 
972     Alchemy(amount, total);
973 
974     return true;
975   }
976 
977   /**
978    * 設定-匯率
979    *
980    * 匯率規則:
981    *  - 白金數量 * 匯率 = 白金代幣數量
982    *  - 白金代幣數量 / 匯率 = 白金數量
983    *
984    * Requires:
985    *  - 執行者為owner
986    *  - 匯率rate需大於0
987    *
988    * Returns:
989    *  - bool: 執行成功，回傳true
990    */
991   function setRate(uint256 _rate) onlyOwner returns (bool) {
992     require(_rate > 0);
993 
994     rate = _rate;
995     return true;
996   }
997 
998   /**
999    * 設定-Token地址
1000    *
1001    * 設定白金合約地址
1002    *
1003    * Requires:
1004    *  - 執行者為owner
1005    *  - 合約地址address不為0
1006    *
1007    * Returns:
1008    *  - bool: 執行成功，回傳true
1009    */
1010   function setTokenAddress(address _address) onlyOwner returns (bool) {
1011     require(_address != 0x0);
1012 
1013     coin = PlatinumToken(_address);
1014     token = _address;
1015     return true;
1016   }
1017 
1018   /**
1019    * 購買金條
1020    *
1021    * 此方法執行：
1022    *  - 扣除buyer的白金代幣
1023    *  - 移除白金庫存，代表buyer已從庫存買走白金
1024    *
1025    * Requires:
1026    *  - 執行者為owner
1027    *  - 白金編號index需存在於紀錄（已使用stock方法新增該庫存）
1028    *
1029    * Returns:
1030    *  - bool: 執行成功，回傳true
1031    *
1032    * Events:
1033    *  - Buy: 執行成功時觸發
1034    */
1035   function buy(string _index, address buyer) onlyOwner returns (bool) {
1036     require(token != 0x0);
1037     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
1038     uint256 fee = coin.fee();
1039     require(storehouse[_bindex].amount > 0);
1040 
1041     Bullion bullion = storehouse[_bindex];
1042     uint256 tokenPrice = convert2PlatinumToken(bullion.amount);
1043     uint256 tokenPriceFee = tokenPrice.add(fee);
1044 
1045     // 轉帳
1046     bool transfered = coin.transferFrom(buyer, coin.owner(), tokenPriceFee);
1047     require(transfered);
1048 
1049     // 直接把剛剛賣出的價格煉金
1050     bool reduced = coin.reduce(tokenPrice);
1051     require(reduced);
1052 
1053     // 減少庫存
1054     for (uint256 index = 0; index < storehouseIndex.length; index++) {
1055       Bullion _bullion = storehouse[storehouseIndex[index]];
1056       if (_bullion.index.toSlice().equals(_index.toSlice())) {
1057         // 從倉儲目錄移除
1058         delete storehouseIndex[index];
1059       }
1060     }
1061     // 從倉儲移除
1062     delete storehouse[_bindex];
1063 
1064     Buy(_index, buyer, fee, tokenPrice);
1065 
1066     return true;
1067   }
1068 
1069 
1070 
1071 
1072 
1073   // ========= 公共方法 =========
1074 
1075   // 比率轉換-白金幣換白金
1076   function convert2Platinum(uint256 _amount) constant returns (uint256) {
1077     return _amount.div(rate);
1078   }
1079 
1080   // 比率轉換-白金換白金幣
1081   function convert2PlatinumToken(uint256 _amount) constant returns (uint256) {
1082     return _amount.mul(rate);
1083   }
1084 
1085   // 金條資訊
1086   function info(string _index) constant returns (string, string, uint256, string) {
1087     bytes32 _bindex = ConvertStringByte.stringToBytes32(_index);
1088     require(storehouse[_bindex].amount > 0);
1089 
1090     Bullion bullion = storehouse[_bindex];
1091 
1092     return (bullion.index, bullion.unit, bullion.amount, bullion.ipfs);
1093   }
1094 }
1095 
1096 
1097 /**
1098  * @title SafeMath
1099  * @dev Math operations with safety checks that throw on error
1100  */
1101 library SafeMath {
1102   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
1103     uint256 c = a * b;
1104     assert(a == 0 || c / a == b);
1105     return c;
1106   }
1107 
1108   function div(uint256 a, uint256 b) internal constant returns (uint256) {
1109     // assert(b > 0); // Solidity automatically throws when dividing by 0
1110     uint256 c = a / b;
1111     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1112     return c;
1113   }
1114 
1115   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
1116     assert(b <= a);
1117     return a - b;
1118   }
1119 
1120   function add(uint256 a, uint256 b) internal constant returns (uint256) {
1121     uint256 c = a + b;
1122     assert(c >= a);
1123     return c;
1124   }
1125 }
1126 
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
1140 
1141 /**
1142  * @title ERC20 interface
1143  * @dev see https://github.com/ethereum/EIPs/issues/20
1144  */
1145 contract ERC20 is ERC20Basic {
1146   function allowance(address owner, address spender) constant returns (uint256);
1147   function transferFrom(address from, address to, uint256 value) returns (bool);
1148   function approve(address spender, uint256 value) returns (bool);
1149   event Approval(address indexed owner, address indexed spender, uint256 value);
1150 }
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
1188   /**
1189    * Transfer
1190    *
1191    * 傳送事件，當有白金代幣的所有權轉移時，此事件會被觸發
1192    */
1193   event Transfer(address indexed from, address indexed to, uint256 value);
1194 
1195   // ========= 權限控管 =========
1196   modifier isPlatinumContract() {
1197     require(platinum != 0x0);
1198     require(msg.sender == platinum);
1199     _;
1200   }
1201 
1202   modifier isOwnerOrPlatinumContract() {
1203     require(msg.sender != address(0) && (msg.sender == platinum || msg.sender == owner));
1204     _;
1205   }
1206 
1207   /**
1208    * 增產
1209    *
1210    *  此方法執行：
1211    *    - 增加owner的balance，量為指定的amount
1212    *    - 增加totalSupply，量為指定的amount
1213    *
1214    *  Requires:
1215    *    - 執行者為白金合約（可透過setPlatinumAddress方法設定）
1216    *    - amount須設定為0以上
1217    *
1218    *  Return:
1219    *    - bool: 執行成功回傳true
1220    */
1221   function produce(uint256 amount) isPlatinumContract returns (bool) {
1222     balances[owner] = balances[owner].add(amount);
1223     totalSupply = totalSupply.add(amount);
1224 
1225     return true;
1226   }
1227 
1228   /** 減產
1229    *
1230    *  此方法執行：
1231    *    - 減少owner的balance，量為指定的amount
1232    *    - 減少totalSupply，量為指定的amount
1233    *
1234    *  Requires:
1235    *    - 執行者為白金合約（可透過setPlatinumAddress方法設定）
1236    *    - amount須設定為0以上
1237    *    - owner的balance需大於等於指定的amount
1238    *    - totalSupply需大於等於指定的amount
1239    *
1240    *  Return:
1241    *    - bool: 執行成功回傳true
1242    */
1243   function reduce(uint256 amount) isPlatinumContract returns (bool) {
1244     require(balances[owner].sub(amount) >= 0);
1245     require(totalSupply.sub(amount) >= 0);
1246 
1247     balances[owner] = balances[owner].sub(amount);
1248     totalSupply = totalSupply.sub(amount);
1249 
1250     return true;
1251   }
1252 
1253   /**
1254    * 設定-白金合約地址
1255    *
1256    * 此方法執行：
1257    *  - 修改此合約所認識的白金合約地址，此地址決定能執行produce和reduce方法的合約
1258    *
1259    * Requires:
1260    *  - 執行者須為owner
1261    *  - 地址不能設為0
1262    *
1263    * Returns:
1264    *  - bool: 設定成功時回傳true
1265    */
1266   function setPlatinumAddress(address _address) onlyOwner returns (bool) {
1267     require(_address != 0x0);
1268 
1269     platinum = _address;
1270     return true;
1271   }
1272 
1273   /**
1274    * 設定-手續費
1275    *
1276    * 手續費規則：
1277    *  - 購買金條時，代幣量總量增加手續費為總扣除代幣總量
1278    *
1279    * Requires:
1280    *  - 執行者為owner
1281    *
1282    * Returns:
1283    *  - bool: 執行成功，回傳true
1284    */
1285   function setFee(uint256 _fee) onlyOwner returns (bool) {
1286     require(_fee >= 0);
1287 
1288     fee = _fee;
1289     return true;
1290   }
1291 
1292   /**
1293    * 交易，轉移白金代幣
1294    *
1295    * 此方法執行：
1296    *  - 減少from的白金代幣，量為value
1297    *  - 增加to的白金代幣，量為value
1298    *
1299    * Requires:
1300    *  - 執行者為owner
1301    *
1302    * Returns:
1303    *  - bool: 執行成功回傳true
1304    *
1305    * Events:
1306    *  - Transfer: 執行成功時，觸發此事件
1307    */
1308   function transfer(address _to, uint256 _value) onlyOwner returns (bool) {
1309     balances[owner] = balances[owner].sub(_value);
1310     balances[_to] = balances[_to].add(_value);
1311 
1312     Transfer(owner, _to, _value);
1313 
1314     return true;
1315   }
1316 
1317   /**
1318    * 查詢白金代幣餘額
1319    *
1320    * Returns:
1321    *  - balance: 指定address的白金代幣餘額
1322    */
1323   function balanceOf(address _owner) constant returns (uint256 balance) {
1324     return balances[_owner];
1325   }
1326 
1327   /**
1328    * 轉帳
1329    *
1330    * 實際將approve過的token數量進行交易
1331    *
1332    * 此方法執行：
1333    *  - 交易指定數量的代幣
1334    *
1335    * Requires:
1336    *  - 交易的代幣數量value需大於0
1337    *  - allowed的代幣數量需大於value（allowed的代幣先由呼叫approve方法設定）
1338    *
1339    * Returns:
1340    *  - bool: 執行成功，回傳true
1341    */
1342   function transferFrom(address _from, address _to, uint256 _value) isOwnerOrPlatinumContract returns (bool) {
1343     var _allowance = allowed[_from][owner];
1344 
1345     uint256 valueSubFee = _value.sub(fee);
1346 
1347     balances[_to] = balances[_to].add(valueSubFee);
1348     balances[_from] = balances[_from].sub(_value);
1349     balances[owner] = balances[owner].add(fee);
1350     allowed[_from][owner] = _allowance.sub(_value);
1351 
1352     return true;
1353   }
1354 
1355   /**
1356    * 轉帳 - 允許
1357    *
1358    * 允許一定數量的代幣可以轉帳至owner
1359    *
1360    * 欲修改允許值，需先執行此方法將value設為0，再執行一次此方法將value設為指定值
1361    *
1362    * 此方法操作：
1363    *  - 修改allowed值，紀錄sender允許轉帳value數量代幣給owner
1364    *  - allowed值有設定時，value須為0
1365    *  - allowed值未設定時，value不為0
1366    *
1367    * Returns:
1368    *  - bool: 執行成功，回傳true
1369    */
1370   function approve(address _dummy, uint256 _value) returns (bool) {
1371     // To change the approve amount you first have to reduce the addresses`
1372     //  allowance to zero by calling `approve(_spender, 0)` if it is not
1373     //  already 0 to mitigate the race condition described here:
1374     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1375     require((_value == 0) || (allowed[msg.sender][owner] == 0));
1376     // TODO whether or not to checkout the balance of the sender
1377 
1378     allowed[msg.sender][owner] = _value;
1379     Approval(msg.sender, owner, _value);
1380     return true;
1381   }
1382 
1383   /**
1384    * 轉帳 - 查詢允許值
1385    *
1386    * Returns:
1387    *  - unit256: 允許值
1388    */
1389   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
1390     return allowed[_owner][_spender];
1391   }
1392 
1393 }