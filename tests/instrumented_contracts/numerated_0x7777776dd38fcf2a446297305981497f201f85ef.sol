1 pragma solidity ^ 0.5.7;
2 
3 library SafeMath {
4 
5     /**
6      * @dev Multiplies two numbers, reverts on overflow.
7      */
8     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         require(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns(uint256) {
18         require(b > 0); // Solidity only automatically asserts when dividing by 0
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26         return c;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns(uint256) {
30         uint256 c = a + b;
31         require(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /*
38  * @title String & slice utility library for Solidity contracts.
39  * @author Nick Johnson <arachnid@notdot.net>
40  *
41  * @dev Functionality in this library is largely implemented using an
42  *      abstraction called a 'slice'. A slice represents a part of a string -
43  *      anything from the entire string to a single character, or even no
44  *      characters at all (a 0-length slice). Since a slice only has to specify
45  *      an offset and a length, copying and manipulating slices is a lot less
46  *      expensive than copying and manipulating the strings they reference.
47  *
48  *      To further reduce gas costs, most functions on slice that need to return
49  *      a slice modify the original one instead of allocating a new one; for
50  *      instance, `s.split(".")` will return the text up to the first '.',
51  *      modifying s to only contain the remainder of the string after the '.'.
52  *      In situations where you do not want to modify the original slice, you
53  *      can make a copy first with `.copy()`, for example:
54  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
55  *      Solidity has no memory management, it will result in allocating many
56  *      short-lived slices that are later discarded.
57  *
58  *      Functions that return two slices come in two versions: a non-allocating
59  *      version that takes the second slice as an argument, modifying it in
60  *      place, and an allocating version that allocates and returns the second
61  *      slice; see `nextRune` for example.
62  *
63  *      Functions that have to copy string data will return strings rather than
64  *      slices; these can be cast back to slices for further processing if
65  *      required.
66  *
67  *      For convenience, some functions are provided with non-modifying
68  *      variants that create a new slice and return both; for instance,
69  *      `s.splitNew('.')` leaves s unmodified, and returns two values
70  *      corresponding to the left and right parts of the string.
71  */
72 library strings {
73     struct slice {
74         uint _len;
75         uint _ptr;
76     }
77 
78     function memcpy(uint dest, uint src, uint len) private pure {
79         // Copy word-length chunks while possible
80         for(; len >= 32; len -= 32) {
81             assembly {
82                 mstore(dest, mload(src))
83             }
84             dest += 32;
85             src += 32;
86         }
87 
88         // Copy remaining bytes
89         uint mask = 256 ** (32 - len) - 1;
90         assembly {
91             let srcpart := and(mload(src), not(mask))
92             let destpart := and(mload(dest), mask)
93             mstore(dest, or(destpart, srcpart))
94         }
95     }
96 
97     /*
98      * @dev Returns a slice containing the entire string.
99      * @param self The string to make a slice from.
100      * @return A newly allocated slice containing the entire string.
101      */
102     function toSlice(string memory self) internal pure returns (slice memory) {
103         uint ptr;
104         assembly {
105             ptr := add(self, 0x20)
106         }
107         return slice(bytes(self).length, ptr);
108     }
109 
110     /*
111      * @dev Returns a new slice containing the same data as the current slice.
112      * @param self The slice to copy.
113      * @return A new slice containing the same data as `self`.
114      */
115     function copy(slice memory self) internal pure returns (slice memory) {
116         return slice(self._len, self._ptr);
117     }
118 
119     /*
120      * @dev Copies a slice to a new string.
121      * @param self The slice to copy.
122      * @return A newly allocated string containing the slice's text.
123      */
124     function toString(slice memory self) internal pure returns (string memory) {
125         string memory ret = new string(self._len);
126         uint retptr;
127         assembly { retptr := add(ret, 32) }
128 
129         memcpy(retptr, self._ptr, self._len);
130         return ret;
131     }
132 
133     /*
134      * @dev Returns the length in runes of the slice. Note that this operation
135      *      takes time proportional to the length of the slice; avoid using it
136      *      in loops, and call `slice.empty()` if you only need to know whether
137      *      the slice is empty or not.
138      * @param self The slice to operate on.
139      * @return The length of the slice in runes.
140      */
141     function len(slice memory self) internal pure returns (uint l) {
142         // Starting at ptr-31 means the LSB will be the byte we care about
143         uint ptr = self._ptr - 31;
144         uint end = ptr + self._len;
145         for (l = 0; ptr < end; l++) {
146             uint8 b;
147             assembly { b := and(mload(ptr), 0xFF) }
148             if (b < 0x80) {
149                 ptr += 1;
150             } else if(b < 0xE0) {
151                 ptr += 2;
152             } else if(b < 0xF0) {
153                 ptr += 3;
154             } else if(b < 0xF8) {
155                 ptr += 4;
156             } else if(b < 0xFC) {
157                 ptr += 5;
158             } else {
159                 ptr += 6;
160             }
161         }
162     }
163 
164     /*
165      * @dev Returns true if the slice is empty (has a length of 0).
166      * @param self The slice to operate on.
167      * @return True if the slice is empty, False otherwise.
168      */
169     function empty(slice memory self) internal pure returns (bool) {
170         return self._len == 0;
171     }
172 
173     /*
174      * @dev Returns a positive number if `other` comes lexicographically after
175      *      `self`, a negative number if it comes before, or zero if the
176      *      contents of the two slices are equal. Comparison is done per-rune,
177      *      on unicode codepoints.
178      * @param self The first slice to compare.
179      * @param other The second slice to compare.
180      * @return The result of the comparison.
181      */
182     function compare(slice memory self, slice memory other) internal pure returns (int) {
183         uint shortest = self._len;
184         if (other._len < self._len)
185             shortest = other._len;
186 
187         uint selfptr = self._ptr;
188         uint otherptr = other._ptr;
189         for (uint idx = 0; idx < shortest; idx += 32) {
190             uint a;
191             uint b;
192             assembly {
193                 a := mload(selfptr)
194                 b := mload(otherptr)
195             }
196             if (a != b) {
197                 // Mask out irrelevant bytes and check again
198                 uint256 mask = uint256(-1); // 0xffff...
199                 if(shortest < 32) {
200                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
201                 }
202                 uint256 diff = (a & mask) - (b & mask);
203                 if (diff != 0)
204                     return int(diff);
205             }
206             selfptr += 32;
207             otherptr += 32;
208         }
209         return int(self._len) - int(other._len);
210     }
211 
212     /*
213      * @dev Returns true if the two slices contain the same text.
214      * @param self The first slice to compare.
215      * @param self The second slice to compare.
216      * @return True if the slices are equal, false otherwise.
217      */
218     function equals(slice memory self, slice memory other) internal pure returns (bool) {
219         return compare(self, other) == 0;
220     }
221 
222     /*
223      * @dev Extracts the first rune in the slice into `rune`, advancing the
224      *      slice to point to the next rune and returning `self`.
225      * @param self The slice to operate on.
226      * @param rune The slice that will contain the first rune.
227      * @return `rune`.
228      */
229     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
230         rune._ptr = self._ptr;
231 
232         if (self._len == 0) {
233             rune._len = 0;
234             return rune;
235         }
236 
237         uint l;
238         uint b;
239         // Load the first byte of the rune into the LSBs of b
240         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
241         if (b < 0x80) {
242             l = 1;
243         } else if(b < 0xE0) {
244             l = 2;
245         } else if(b < 0xF0) {
246             l = 3;
247         } else {
248             l = 4;
249         }
250 
251         // Check for truncated codepoints
252         if (l > self._len) {
253             rune._len = self._len;
254             self._ptr += self._len;
255             self._len = 0;
256             return rune;
257         }
258 
259         self._ptr += l;
260         self._len -= l;
261         rune._len = l;
262         return rune;
263     }
264 
265     /*
266      * @dev Returns the first rune in the slice, advancing the slice to point
267      *      to the next rune.
268      * @param self The slice to operate on.
269      * @return A slice containing only the first rune from `self`.
270      */
271     function nextRune(slice memory self) internal pure returns (slice memory ret) {
272         nextRune(self, ret);
273     }
274 
275     /*
276      * @dev Returns the number of the first codepoint in the slice.
277      * @param self The slice to operate on.
278      * @return The number of the first codepoint in the slice.
279      */
280     function ord(slice memory self) internal pure returns (uint ret) {
281         if (self._len == 0) {
282             return 0;
283         }
284 
285         uint word;
286         uint length;
287         uint divisor = 2 ** 248;
288 
289         // Load the rune into the MSBs of b
290         assembly { word:= mload(mload(add(self, 32))) }
291         uint b = word / divisor;
292         if (b < 0x80) {
293             ret = b;
294             length = 1;
295         } else if(b < 0xE0) {
296             ret = b & 0x1F;
297             length = 2;
298         } else if(b < 0xF0) {
299             ret = b & 0x0F;
300             length = 3;
301         } else {
302             ret = b & 0x07;
303             length = 4;
304         }
305 
306         // Check for truncated codepoints
307         if (length > self._len) {
308             return 0;
309         }
310 
311         for (uint i = 1; i < length; i++) {
312             divisor = divisor / 256;
313             b = (word / divisor) & 0xFF;
314             if (b & 0xC0 != 0x80) {
315                 // Invalid UTF-8 sequence
316                 return 0;
317             }
318             ret = (ret * 64) | (b & 0x3F);
319         }
320 
321         return ret;
322     }
323 
324     /*
325      * @dev Returns the keccak-256 hash of the slice.
326      * @param self The slice to hash.
327      * @return The hash of the slice.
328      */
329     function keccak(slice memory self) internal pure returns (bytes32 ret) {
330         assembly {
331             ret := keccak256(mload(add(self, 32)), mload(self))
332         }
333     }
334 
335     /*
336      * @dev Returns true if `self` starts with `needle`.
337      * @param self The slice to operate on.
338      * @param needle The slice to search for.
339      * @return True if the slice starts with the provided text, false otherwise.
340      */
341     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
342         if (self._len < needle._len) {
343             return false;
344         }
345 
346         if (self._ptr == needle._ptr) {
347             return true;
348         }
349 
350         bool equal;
351         assembly {
352             let length := mload(needle)
353             let selfptr := mload(add(self, 0x20))
354             let needleptr := mload(add(needle, 0x20))
355             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
356         }
357         return equal;
358     }
359 
360     /*
361      * @dev If `self` starts with `needle`, `needle` is removed from the
362      *      beginning of `self`. Otherwise, `self` is unmodified.
363      * @param self The slice to operate on.
364      * @param needle The slice to search for.
365      * @return `self`
366      */
367     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
368         if (self._len < needle._len) {
369             return self;
370         }
371 
372         bool equal = true;
373         if (self._ptr != needle._ptr) {
374             assembly {
375                 let length := mload(needle)
376                 let selfptr := mload(add(self, 0x20))
377                 let needleptr := mload(add(needle, 0x20))
378                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
379             }
380         }
381 
382         if (equal) {
383             self._len -= needle._len;
384             self._ptr += needle._len;
385         }
386 
387         return self;
388     }
389 
390     /*
391      * @dev Returns true if the slice ends with `needle`.
392      * @param self The slice to operate on.
393      * @param needle The slice to search for.
394      * @return True if the slice starts with the provided text, false otherwise.
395      */
396     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
397         if (self._len < needle._len) {
398             return false;
399         }
400 
401         uint selfptr = self._ptr + self._len - needle._len;
402 
403         if (selfptr == needle._ptr) {
404             return true;
405         }
406 
407         bool equal;
408         assembly {
409             let length := mload(needle)
410             let needleptr := mload(add(needle, 0x20))
411             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
412         }
413 
414         return equal;
415     }
416 
417     /*
418      * @dev If `self` ends with `needle`, `needle` is removed from the
419      *      end of `self`. Otherwise, `self` is unmodified.
420      * @param self The slice to operate on.
421      * @param needle The slice to search for.
422      * @return `self`
423      */
424     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
425         if (self._len < needle._len) {
426             return self;
427         }
428 
429         uint selfptr = self._ptr + self._len - needle._len;
430         bool equal = true;
431         if (selfptr != needle._ptr) {
432             assembly {
433                 let length := mload(needle)
434                 let needleptr := mload(add(needle, 0x20))
435                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
436             }
437         }
438 
439         if (equal) {
440             self._len -= needle._len;
441         }
442 
443         return self;
444     }
445 
446     // Returns the memory address of the first byte of the first occurrence of
447     // `needle` in `self`, or the first byte after `self` if not found.
448     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
449         uint ptr = selfptr;
450         uint idx;
451 
452         if (needlelen <= selflen) {
453             if (needlelen <= 32) {
454                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
455 
456                 bytes32 needledata;
457                 assembly { needledata := and(mload(needleptr), mask) }
458 
459                 uint end = selfptr + selflen - needlelen;
460                 bytes32 ptrdata;
461                 assembly { ptrdata := and(mload(ptr), mask) }
462 
463                 while (ptrdata != needledata) {
464                     if (ptr >= end)
465                         return selfptr + selflen;
466                     ptr++;
467                     assembly { ptrdata := and(mload(ptr), mask) }
468                 }
469                 return ptr;
470             } else {
471                 // For long needles, use hashing
472                 bytes32 hash;
473                 assembly { hash := keccak256(needleptr, needlelen) }
474 
475                 for (idx = 0; idx <= selflen - needlelen; idx++) {
476                     bytes32 testHash;
477                     assembly { testHash := keccak256(ptr, needlelen) }
478                     if (hash == testHash)
479                         return ptr;
480                     ptr += 1;
481                 }
482             }
483         }
484         return selfptr + selflen;
485     }
486 
487     // Returns the memory address of the first byte after the last occurrence of
488     // `needle` in `self`, or the address of `self` if not found.
489     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
490         uint ptr;
491 
492         if (needlelen <= selflen) {
493             if (needlelen <= 32) {
494                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
495 
496                 bytes32 needledata;
497                 assembly { needledata := and(mload(needleptr), mask) }
498 
499                 ptr = selfptr + selflen - needlelen;
500                 bytes32 ptrdata;
501                 assembly { ptrdata := and(mload(ptr), mask) }
502 
503                 while (ptrdata != needledata) {
504                     if (ptr <= selfptr)
505                         return selfptr;
506                     ptr--;
507                     assembly { ptrdata := and(mload(ptr), mask) }
508                 }
509                 return ptr + needlelen;
510             } else {
511                 // For long needles, use hashing
512                 bytes32 hash;
513                 assembly { hash := keccak256(needleptr, needlelen) }
514                 ptr = selfptr + (selflen - needlelen);
515                 while (ptr >= selfptr) {
516                     bytes32 testHash;
517                     assembly { testHash := keccak256(ptr, needlelen) }
518                     if (hash == testHash)
519                         return ptr + needlelen;
520                     ptr -= 1;
521                 }
522             }
523         }
524         return selfptr;
525     }
526 
527     /*
528      * @dev Modifies `self` to contain everything from the first occurrence of
529      *      `needle` to the end of the slice. `self` is set to the empty slice
530      *      if `needle` is not found.
531      * @param self The slice to search and modify.
532      * @param needle The text to search for.
533      * @return `self`.
534      */
535     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
536         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
537         self._len -= ptr - self._ptr;
538         self._ptr = ptr;
539         return self;
540     }
541 
542     /*
543      * @dev Modifies `self` to contain the part of the string from the start of
544      *      `self` to the end of the first occurrence of `needle`. If `needle`
545      *      is not found, `self` is set to the empty slice.
546      * @param self The slice to search and modify.
547      * @param needle The text to search for.
548      * @return `self`.
549      */
550     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
551         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
552         self._len = ptr - self._ptr;
553         return self;
554     }
555 
556     /*
557      * @dev Splits the slice, setting `self` to everything after the first
558      *      occurrence of `needle`, and `token` to everything before it. If
559      *      `needle` does not occur in `self`, `self` is set to the empty slice,
560      *      and `token` is set to the entirety of `self`.
561      * @param self The slice to split.
562      * @param needle The text to search for in `self`.
563      * @param token An output parameter to which the first token is written.
564      * @return `token`.
565      */
566     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
567         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
568         token._ptr = self._ptr;
569         token._len = ptr - self._ptr;
570         if (ptr == self._ptr + self._len) {
571             // Not found
572             self._len = 0;
573         } else {
574             self._len -= token._len + needle._len;
575             self._ptr = ptr + needle._len;
576         }
577         return token;
578     }
579 
580     /*
581      * @dev Splits the slice, setting `self` to everything after the first
582      *      occurrence of `needle`, and returning everything before it. If
583      *      `needle` does not occur in `self`, `self` is set to the empty slice,
584      *      and the entirety of `self` is returned.
585      * @param self The slice to split.
586      * @param needle The text to search for in `self`.
587      * @return The part of `self` up to the first occurrence of `delim`.
588      */
589     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
590         split(self, needle, token);
591     }
592 
593     /*
594      * @dev Splits the slice, setting `self` to everything before the last
595      *      occurrence of `needle`, and `token` to everything after it. If
596      *      `needle` does not occur in `self`, `self` is set to the empty slice,
597      *      and `token` is set to the entirety of `self`.
598      * @param self The slice to split.
599      * @param needle The text to search for in `self`.
600      * @param token An output parameter to which the first token is written.
601      * @return `token`.
602      */
603     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
604         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
605         token._ptr = ptr;
606         token._len = self._len - (ptr - self._ptr);
607         if (ptr == self._ptr) {
608             // Not found
609             self._len = 0;
610         } else {
611             self._len -= token._len + needle._len;
612         }
613         return token;
614     }
615 
616     /*
617      * @dev Splits the slice, setting `self` to everything before the last
618      *      occurrence of `needle`, and returning everything after it. If
619      *      `needle` does not occur in `self`, `self` is set to the empty slice,
620      *      and the entirety of `self` is returned.
621      * @param self The slice to split.
622      * @param needle The text to search for in `self`.
623      * @return The part of `self` after the last occurrence of `delim`.
624      */
625     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
626         rsplit(self, needle, token);
627     }
628 
629     /*
630      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
631      * @param self The slice to search.
632      * @param needle The text to search for in `self`.
633      * @return The number of occurrences of `needle` found in `self`.
634      */
635     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
636         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
637         while (ptr <= self._ptr + self._len) {
638             cnt++;
639             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
640         }
641     }
642 
643     /*
644      * @dev Returns True if `self` contains `needle`.
645      * @param self The slice to search.
646      * @param needle The text to search for in `self`.
647      * @return True if `needle` is found in `self`, false otherwise.
648      */
649     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
650         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
651     }
652 
653     /*
654      * @dev Returns a newly allocated string containing the concatenation of
655      *      `self` and `other`.
656      * @param self The first slice to concatenate.
657      * @param other The second slice to concatenate.
658      * @return The concatenation of the two strings.
659      */
660     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
661         string memory ret = new string(self._len + other._len);
662         uint retptr;
663         assembly { retptr := add(ret, 32) }
664         memcpy(retptr, self._ptr, self._len);
665         memcpy(retptr + self._len, other._ptr, other._len);
666         return ret;
667     }
668 
669     /*
670      * @dev Joins an array of slices, using `self` as a delimiter, returning a
671      *      newly allocated string.
672      * @param self The delimiter to use.
673      * @param parts A list of slices to join.
674      * @return A newly allocated string containing all the slices in `parts`,
675      *         joined with `self`.
676      */
677     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
678         if (parts.length == 0)
679             return "";
680 
681         uint length = self._len * (parts.length - 1);
682         for(uint i = 0; i < parts.length; i++)
683             length += parts[i]._len;
684 
685         string memory ret = new string(length);
686         uint retptr;
687         assembly { retptr := add(ret, 32) }
688 
689         for(uint i = 0; i < parts.length; i++) {
690             memcpy(retptr, parts[i]._ptr, parts[i]._len);
691             retptr += parts[i]._len;
692             if (i < parts.length - 1) {
693                 memcpy(retptr, self._ptr, self._len);
694                 retptr += self._len;
695             }
696         }
697 
698         return ret;
699     }
700 }
701 
702 
703 /*
704 
705 ORACLIZE_API
706 github.com/oraclize/ethereum-api/oraclizeAPI.sol
707 
708 */
709 
710 contract solcChecker {
711     /* INCOMPATIBLE SOLC: import the following instead: "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol" */ function f(bytes calldata x) external;
712 }
713 
714 contract OraclizeI {
715 
716     address public cbAddress;
717 
718     function setProofType(byte _proofType) external;
719     function setCustomGasPrice(uint _gasPrice) external;
720     function getPrice(string memory _datasource) public returns (uint _dsprice);
721     function randomDS_getSessionPubKeyHash() external view returns (bytes32 _sessionKeyHash);
722     function getPrice(string memory _datasource, uint _gasLimit) public returns (uint _dsprice);
723     function queryN(uint _timestamp, string memory _datasource, bytes memory _argN) public payable returns (bytes32 _id);
724     function query(uint _timestamp, string calldata _datasource, string calldata _arg) external payable returns (bytes32 _id);
725     function query2(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) public payable returns (bytes32 _id);
726     function query_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg, uint _gasLimit) external payable returns (bytes32 _id);
727     function queryN_withGasLimit(uint _timestamp, string calldata _datasource, bytes calldata _argN, uint _gasLimit) external payable returns (bytes32 _id);
728     function query2_withGasLimit(uint _timestamp, string calldata _datasource, string calldata _arg1, string calldata _arg2, uint _gasLimit) external payable returns (bytes32 _id);
729 }
730 
731 contract OraclizeAddrResolverI {
732     function getAddress() public returns (address _address);
733 }
734 
735 /*
736 
737 Begin solidity-cborutils
738 
739 */
740 library Buffer {
741 
742     struct buffer {
743         bytes buf;
744         uint capacity;
745     }
746 
747     function init(buffer memory _buf, uint _capacity) internal pure {
748         uint capacity = _capacity;
749         if (capacity % 32 != 0) {
750             capacity += 32 - (capacity % 32);
751         }
752         _buf.capacity = capacity; // Allocate space for the buffer data
753         assembly {
754             let ptr := mload(0x40)
755             mstore(_buf, ptr)
756             mstore(ptr, 0)
757             mstore(0x40, add(ptr, capacity))
758         }
759     }
760 
761     function resize(buffer memory _buf, uint _capacity) private pure {
762         bytes memory oldbuf = _buf.buf;
763         init(_buf, _capacity);
764         append(_buf, oldbuf);
765     }
766 
767     function max(uint _a, uint _b) private pure returns (uint _max) {
768         if (_a > _b) {
769             return _a;
770         }
771         return _b;
772     }
773     /**
774       * @dev Appends a byte array to the end of the buffer. Resizes if doing so
775       *      would exceed the capacity of the buffer.
776       * @param _buf The buffer to append to.
777       * @param _data The data to append.
778       * @return The original buffer.
779       *
780       */
781     function append(buffer memory _buf, bytes memory _data) internal pure returns (buffer memory _buffer) {
782         if (_data.length + _buf.buf.length > _buf.capacity) {
783             resize(_buf, max(_buf.capacity, _data.length) * 2);
784         }
785         uint dest;
786         uint src;
787         uint len = _data.length;
788         assembly {
789             let bufptr := mload(_buf) // Memory address of the buffer data
790             let buflen := mload(bufptr) // Length of existing buffer data
791             dest := add(add(bufptr, buflen), 32) // Start address = buffer address + buffer length + sizeof(buffer length)
792             mstore(bufptr, add(buflen, mload(_data))) // Update buffer length
793             src := add(_data, 32)
794         }
795         for(; len >= 32; len -= 32) { // Copy word-length chunks while possible
796             assembly {
797                 mstore(dest, mload(src))
798             }
799             dest += 32;
800             src += 32;
801         }
802         uint mask = 256 ** (32 - len) - 1; // Copy remaining bytes
803         assembly {
804             let srcpart := and(mload(src), not(mask))
805             let destpart := and(mload(dest), mask)
806             mstore(dest, or(destpart, srcpart))
807         }
808         return _buf;
809     }
810     /**
811       *
812       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
813       * exceed the capacity of the buffer.
814       * @param _buf The buffer to append to.
815       * @param _data The data to append.
816       * @return The original buffer.
817       *
818       */
819     function append(buffer memory _buf, uint8 _data) internal pure {
820         if (_buf.buf.length + 1 > _buf.capacity) {
821             resize(_buf, _buf.capacity * 2);
822         }
823         assembly {
824             let bufptr := mload(_buf) // Memory address of the buffer data
825             let buflen := mload(bufptr) // Length of existing buffer data
826             let dest := add(add(bufptr, buflen), 32) // Address = buffer address + buffer length + sizeof(buffer length)
827             mstore8(dest, _data)
828             mstore(bufptr, add(buflen, 1)) // Update buffer length
829         }
830     }
831     /**
832       *
833       * @dev Appends a byte to the end of the buffer. Resizes if doing so would
834       * exceed the capacity of the buffer.
835       * @param _buf The buffer to append to.
836       * @param _data The data to append.
837       * @return The original buffer.
838       *
839       */
840     function appendInt(buffer memory _buf, uint _data, uint _len) internal pure returns (buffer memory _buffer) {
841         if (_len + _buf.buf.length > _buf.capacity) {
842             resize(_buf, max(_buf.capacity, _len) * 2);
843         }
844         uint mask = 256 ** _len - 1;
845         assembly {
846             let bufptr := mload(_buf) // Memory address of the buffer data
847             let buflen := mload(bufptr) // Length of existing buffer data
848             let dest := add(add(bufptr, buflen), _len) // Address = buffer address + buffer length + sizeof(buffer length) + len
849             mstore(dest, or(and(mload(dest), not(mask)), _data))
850             mstore(bufptr, add(buflen, _len)) // Update buffer length
851         }
852         return _buf;
853     }
854 }
855 
856 library CBOR {
857 
858     using Buffer for Buffer.buffer;
859 
860     uint8 private constant MAJOR_TYPE_INT = 0;
861     uint8 private constant MAJOR_TYPE_MAP = 5;
862     uint8 private constant MAJOR_TYPE_BYTES = 2;
863     uint8 private constant MAJOR_TYPE_ARRAY = 4;
864     uint8 private constant MAJOR_TYPE_STRING = 3;
865     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
866     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
867 
868     function encodeType(Buffer.buffer memory _buf, uint8 _major, uint _value) private pure {
869         if (_value <= 23) {
870             _buf.append(uint8((_major << 5) | _value));
871         } else if (_value <= 0xFF) {
872             _buf.append(uint8((_major << 5) | 24));
873             _buf.appendInt(_value, 1);
874         } else if (_value <= 0xFFFF) {
875             _buf.append(uint8((_major << 5) | 25));
876             _buf.appendInt(_value, 2);
877         } else if (_value <= 0xFFFFFFFF) {
878             _buf.append(uint8((_major << 5) | 26));
879             _buf.appendInt(_value, 4);
880         } else if (_value <= 0xFFFFFFFFFFFFFFFF) {
881             _buf.append(uint8((_major << 5) | 27));
882             _buf.appendInt(_value, 8);
883         }
884     }
885 
886     function encodeIndefiniteLengthType(Buffer.buffer memory _buf, uint8 _major) private pure {
887         _buf.append(uint8((_major << 5) | 31));
888     }
889 
890     function encodeUInt(Buffer.buffer memory _buf, uint _value) internal pure {
891         encodeType(_buf, MAJOR_TYPE_INT, _value);
892     }
893 
894     function encodeInt(Buffer.buffer memory _buf, int _value) internal pure {
895         if (_value >= 0) {
896             encodeType(_buf, MAJOR_TYPE_INT, uint(_value));
897         } else {
898             encodeType(_buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - _value));
899         }
900     }
901 
902     function encodeBytes(Buffer.buffer memory _buf, bytes memory _value) internal pure {
903         encodeType(_buf, MAJOR_TYPE_BYTES, _value.length);
904         _buf.append(_value);
905     }
906 
907     function encodeString(Buffer.buffer memory _buf, string memory _value) internal pure {
908         encodeType(_buf, MAJOR_TYPE_STRING, bytes(_value).length);
909         _buf.append(bytes(_value));
910     }
911 
912     function startArray(Buffer.buffer memory _buf) internal pure {
913         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_ARRAY);
914     }
915 
916     function startMap(Buffer.buffer memory _buf) internal pure {
917         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_MAP);
918     }
919 
920     function endSequence(Buffer.buffer memory _buf) internal pure {
921         encodeIndefiniteLengthType(_buf, MAJOR_TYPE_CONTENT_FREE);
922     }
923 }
924 /*
925 
926 End solidity-cborutils
927 
928 */
929 contract usingOraclize {
930 
931     using CBOR for Buffer.buffer;
932 
933     OraclizeI oraclize;
934     OraclizeAddrResolverI OAR;
935 
936     uint constant day = 60 * 60 * 24;
937     uint constant week = 60 * 60 * 24 * 7;
938     uint constant month = 60 * 60 * 24 * 30;
939 
940     byte constant proofType_NONE = 0x00;
941     byte constant proofType_Ledger = 0x30;
942     byte constant proofType_Native = 0xF0;
943     byte constant proofStorage_IPFS = 0x01;
944     byte constant proofType_Android = 0x40;
945     byte constant proofType_TLSNotary = 0x10;
946 
947     string oraclize_network_name;
948     uint8 constant networkID_auto = 0;
949     uint8 constant networkID_morden = 2;
950     uint8 constant networkID_mainnet = 1;
951     uint8 constant networkID_testnet = 2;
952     uint8 constant networkID_consensys = 161;
953 
954     mapping(bytes32 => bytes32) oraclize_randomDS_args;
955     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
956 
957     modifier oraclizeAPI {
958         if ((address(OAR) == address(0)) || (getCodeSize(address(OAR)) == 0)) {
959             oraclize_setNetwork(networkID_auto);
960         }
961         if (address(oraclize) != OAR.getAddress()) {
962             oraclize = OraclizeI(OAR.getAddress());
963         }
964         _;
965     }
966 
967     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string memory _result, bytes memory _proof) {
968         // RandomDS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
969         require((_proof[0] == "L") && (_proof[1] == "P") && (uint8(_proof[2]) == uint8(1)));
970         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
971         require(proofVerified);
972         _;
973     }
974 
975     function oraclize_setNetwork(uint8 _networkID) internal returns (bool _networkSet) {
976       return oraclize_setNetwork();
977       _networkID; // silence the warning and remain backwards compatible
978     }
979 
980     function oraclize_setNetworkName(string memory _network_name) internal {
981         oraclize_network_name = _network_name;
982     }
983 
984     function oraclize_getNetworkName() internal view returns (string memory _networkName) {
985         return oraclize_network_name;
986     }
987 
988     function oraclize_setNetwork() internal returns (bool _networkSet) {
989         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) { //mainnet
990             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
991             oraclize_setNetworkName("eth_mainnet");
992             return true;
993         }
994         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) { //ropsten testnet
995             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
996             oraclize_setNetworkName("eth_ropsten3");
997             return true;
998         }
999         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) { //kovan testnet
1000             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1001             oraclize_setNetworkName("eth_kovan");
1002             return true;
1003         }
1004         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) { //rinkeby testnet
1005             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1006             oraclize_setNetworkName("eth_rinkeby");
1007             return true;
1008         }
1009         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) { //ethereum-bridge
1010             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1011             return true;
1012         }
1013         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) { //ether.camp ide
1014             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1015             return true;
1016         }
1017         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) { //browser-solidity
1018             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1019             return true;
1020         }
1021         return false;
1022     }
1023 
1024     function __callback(bytes32 _myid, string memory _result) public payable {
1025         __callback(_myid, _result, new bytes(0));
1026     }
1027 
1028     function __callback(bytes32 _myid, string memory _result, bytes memory _proof) pure public {
1029       return;
1030       _myid; _result; _proof; // Silence compiler warnings
1031     }
1032 
1033     function oraclize_getPrice(string memory _datasource) oraclizeAPI internal returns (uint _queryPrice) {
1034         return oraclize.getPrice(_datasource);
1035     }
1036 
1037     function oraclize_getPrice(string memory _datasource, uint _gasLimit) oraclizeAPI internal returns (uint _queryPrice) {
1038         return oraclize.getPrice(_datasource, _gasLimit);
1039     }
1040 
1041     function oraclize_query(string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
1042         uint price = oraclize.getPrice(_datasource);
1043         if (price > 1 ether + tx.gasprice * 200000) {
1044             return 0; // Unexpectedly high price
1045         }
1046         return oraclize.query.value(price)(0, _datasource, _arg);
1047     }
1048 
1049     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg) oraclizeAPI internal returns (bytes32 _id) {
1050         uint price = oraclize.getPrice(_datasource);
1051         if (price > 1 ether + tx.gasprice * 200000) {
1052             return 0; // Unexpectedly high price
1053         }
1054         return oraclize.query.value(price)(_timestamp, _datasource, _arg);
1055     }
1056 
1057     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1058         uint price = oraclize.getPrice(_datasource,_gasLimit);
1059         if (price > 1 ether + tx.gasprice * _gasLimit) {
1060             return 0; // Unexpectedly high price
1061         }
1062         return oraclize.query_withGasLimit.value(price)(_timestamp, _datasource, _arg, _gasLimit);
1063     }
1064 
1065     function oraclize_query(string memory _datasource, string memory _arg, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1066         uint price = oraclize.getPrice(_datasource, _gasLimit);
1067         if (price > 1 ether + tx.gasprice * _gasLimit) {
1068            return 0; // Unexpectedly high price
1069         }
1070         return oraclize.query_withGasLimit.value(price)(0, _datasource, _arg, _gasLimit);
1071     }
1072 
1073     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1074         uint price = oraclize.getPrice(_datasource);
1075         if (price > 1 ether + tx.gasprice * 200000) {
1076             return 0; // Unexpectedly high price
1077         }
1078         return oraclize.query2.value(price)(0, _datasource, _arg1, _arg2);
1079     }
1080 
1081     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2) oraclizeAPI internal returns (bytes32 _id) {
1082         uint price = oraclize.getPrice(_datasource);
1083         if (price > 1 ether + tx.gasprice * 200000) {
1084             return 0; // Unexpectedly high price
1085         }
1086         return oraclize.query2.value(price)(_timestamp, _datasource, _arg1, _arg2);
1087     }
1088 
1089     function oraclize_query(uint _timestamp, string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1090         uint price = oraclize.getPrice(_datasource, _gasLimit);
1091         if (price > 1 ether + tx.gasprice * _gasLimit) {
1092             return 0; // Unexpectedly high price
1093         }
1094         return oraclize.query2_withGasLimit.value(price)(_timestamp, _datasource, _arg1, _arg2, _gasLimit);
1095     }
1096 
1097     function oraclize_query(string memory _datasource, string memory _arg1, string memory _arg2, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1098         uint price = oraclize.getPrice(_datasource, _gasLimit);
1099         if (price > 1 ether + tx.gasprice * _gasLimit) {
1100             return 0; // Unexpectedly high price
1101         }
1102         return oraclize.query2_withGasLimit.value(price)(0, _datasource, _arg1, _arg2, _gasLimit);
1103     }
1104 
1105     function oraclize_query(string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1106         uint price = oraclize.getPrice(_datasource);
1107         if (price > 1 ether + tx.gasprice * 200000) {
1108             return 0; // Unexpectedly high price
1109         }
1110         bytes memory args = stra2cbor(_argN);
1111         return oraclize.queryN.value(price)(0, _datasource, args);
1112     }
1113 
1114     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1115         uint price = oraclize.getPrice(_datasource);
1116         if (price > 1 ether + tx.gasprice * 200000) {
1117             return 0; // Unexpectedly high price
1118         }
1119         bytes memory args = stra2cbor(_argN);
1120         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1121     }
1122 
1123     function oraclize_query(uint _timestamp, string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1124         uint price = oraclize.getPrice(_datasource, _gasLimit);
1125         if (price > 1 ether + tx.gasprice * _gasLimit) {
1126             return 0; // Unexpectedly high price
1127         }
1128         bytes memory args = stra2cbor(_argN);
1129         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1130     }
1131 
1132     function oraclize_query(string memory _datasource, string[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1133         uint price = oraclize.getPrice(_datasource, _gasLimit);
1134         if (price > 1 ether + tx.gasprice * _gasLimit) {
1135             return 0; // Unexpectedly high price
1136         }
1137         bytes memory args = stra2cbor(_argN);
1138         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1139     }
1140 
1141     function oraclize_query(string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1142         string[] memory dynargs = new string[](1);
1143         dynargs[0] = _args[0];
1144         return oraclize_query(_datasource, dynargs);
1145     }
1146 
1147     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1148         string[] memory dynargs = new string[](1);
1149         dynargs[0] = _args[0];
1150         return oraclize_query(_timestamp, _datasource, dynargs);
1151     }
1152 
1153     function oraclize_query(uint _timestamp, string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1154         string[] memory dynargs = new string[](1);
1155         dynargs[0] = _args[0];
1156         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1157     }
1158 
1159     function oraclize_query(string memory _datasource, string[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1160         string[] memory dynargs = new string[](1);
1161         dynargs[0] = _args[0];
1162         return oraclize_query(_datasource, dynargs, _gasLimit);
1163     }
1164 
1165     function oraclize_query(string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1166         string[] memory dynargs = new string[](2);
1167         dynargs[0] = _args[0];
1168         dynargs[1] = _args[1];
1169         return oraclize_query(_datasource, dynargs);
1170     }
1171 
1172     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1173         string[] memory dynargs = new string[](2);
1174         dynargs[0] = _args[0];
1175         dynargs[1] = _args[1];
1176         return oraclize_query(_timestamp, _datasource, dynargs);
1177     }
1178 
1179     function oraclize_query(uint _timestamp, string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1180         string[] memory dynargs = new string[](2);
1181         dynargs[0] = _args[0];
1182         dynargs[1] = _args[1];
1183         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1184     }
1185 
1186     function oraclize_query(string memory _datasource, string[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1187         string[] memory dynargs = new string[](2);
1188         dynargs[0] = _args[0];
1189         dynargs[1] = _args[1];
1190         return oraclize_query(_datasource, dynargs, _gasLimit);
1191     }
1192 
1193     function oraclize_query(string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1194         string[] memory dynargs = new string[](3);
1195         dynargs[0] = _args[0];
1196         dynargs[1] = _args[1];
1197         dynargs[2] = _args[2];
1198         return oraclize_query(_datasource, dynargs);
1199     }
1200 
1201     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1202         string[] memory dynargs = new string[](3);
1203         dynargs[0] = _args[0];
1204         dynargs[1] = _args[1];
1205         dynargs[2] = _args[2];
1206         return oraclize_query(_timestamp, _datasource, dynargs);
1207     }
1208 
1209     function oraclize_query(uint _timestamp, string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1210         string[] memory dynargs = new string[](3);
1211         dynargs[0] = _args[0];
1212         dynargs[1] = _args[1];
1213         dynargs[2] = _args[2];
1214         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1215     }
1216 
1217     function oraclize_query(string memory _datasource, string[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1218         string[] memory dynargs = new string[](3);
1219         dynargs[0] = _args[0];
1220         dynargs[1] = _args[1];
1221         dynargs[2] = _args[2];
1222         return oraclize_query(_datasource, dynargs, _gasLimit);
1223     }
1224 
1225     function oraclize_query(string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1226         string[] memory dynargs = new string[](4);
1227         dynargs[0] = _args[0];
1228         dynargs[1] = _args[1];
1229         dynargs[2] = _args[2];
1230         dynargs[3] = _args[3];
1231         return oraclize_query(_datasource, dynargs);
1232     }
1233 
1234     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1235         string[] memory dynargs = new string[](4);
1236         dynargs[0] = _args[0];
1237         dynargs[1] = _args[1];
1238         dynargs[2] = _args[2];
1239         dynargs[3] = _args[3];
1240         return oraclize_query(_timestamp, _datasource, dynargs);
1241     }
1242 
1243     function oraclize_query(uint _timestamp, string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1244         string[] memory dynargs = new string[](4);
1245         dynargs[0] = _args[0];
1246         dynargs[1] = _args[1];
1247         dynargs[2] = _args[2];
1248         dynargs[3] = _args[3];
1249         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1250     }
1251 
1252     function oraclize_query(string memory _datasource, string[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1253         string[] memory dynargs = new string[](4);
1254         dynargs[0] = _args[0];
1255         dynargs[1] = _args[1];
1256         dynargs[2] = _args[2];
1257         dynargs[3] = _args[3];
1258         return oraclize_query(_datasource, dynargs, _gasLimit);
1259     }
1260 
1261     function oraclize_query(string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1262         string[] memory dynargs = new string[](5);
1263         dynargs[0] = _args[0];
1264         dynargs[1] = _args[1];
1265         dynargs[2] = _args[2];
1266         dynargs[3] = _args[3];
1267         dynargs[4] = _args[4];
1268         return oraclize_query(_datasource, dynargs);
1269     }
1270 
1271     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1272         string[] memory dynargs = new string[](5);
1273         dynargs[0] = _args[0];
1274         dynargs[1] = _args[1];
1275         dynargs[2] = _args[2];
1276         dynargs[3] = _args[3];
1277         dynargs[4] = _args[4];
1278         return oraclize_query(_timestamp, _datasource, dynargs);
1279     }
1280 
1281     function oraclize_query(uint _timestamp, string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1282         string[] memory dynargs = new string[](5);
1283         dynargs[0] = _args[0];
1284         dynargs[1] = _args[1];
1285         dynargs[2] = _args[2];
1286         dynargs[3] = _args[3];
1287         dynargs[4] = _args[4];
1288         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1289     }
1290 
1291     function oraclize_query(string memory _datasource, string[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1292         string[] memory dynargs = new string[](5);
1293         dynargs[0] = _args[0];
1294         dynargs[1] = _args[1];
1295         dynargs[2] = _args[2];
1296         dynargs[3] = _args[3];
1297         dynargs[4] = _args[4];
1298         return oraclize_query(_datasource, dynargs, _gasLimit);
1299     }
1300 
1301     function oraclize_query(string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1302         uint price = oraclize.getPrice(_datasource);
1303         if (price > 1 ether + tx.gasprice * 200000) {
1304             return 0; // Unexpectedly high price
1305         }
1306         bytes memory args = ba2cbor(_argN);
1307         return oraclize.queryN.value(price)(0, _datasource, args);
1308     }
1309 
1310     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN) oraclizeAPI internal returns (bytes32 _id) {
1311         uint price = oraclize.getPrice(_datasource);
1312         if (price > 1 ether + tx.gasprice * 200000) {
1313             return 0; // Unexpectedly high price
1314         }
1315         bytes memory args = ba2cbor(_argN);
1316         return oraclize.queryN.value(price)(_timestamp, _datasource, args);
1317     }
1318 
1319     function oraclize_query(uint _timestamp, string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1320         uint price = oraclize.getPrice(_datasource, _gasLimit);
1321         if (price > 1 ether + tx.gasprice * _gasLimit) {
1322             return 0; // Unexpectedly high price
1323         }
1324         bytes memory args = ba2cbor(_argN);
1325         return oraclize.queryN_withGasLimit.value(price)(_timestamp, _datasource, args, _gasLimit);
1326     }
1327 
1328     function oraclize_query(string memory _datasource, bytes[] memory _argN, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1329         uint price = oraclize.getPrice(_datasource, _gasLimit);
1330         if (price > 1 ether + tx.gasprice * _gasLimit) {
1331             return 0; // Unexpectedly high price
1332         }
1333         bytes memory args = ba2cbor(_argN);
1334         return oraclize.queryN_withGasLimit.value(price)(0, _datasource, args, _gasLimit);
1335     }
1336 
1337     function oraclize_query(string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1338         bytes[] memory dynargs = new bytes[](1);
1339         dynargs[0] = _args[0];
1340         return oraclize_query(_datasource, dynargs);
1341     }
1342 
1343     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1344         bytes[] memory dynargs = new bytes[](1);
1345         dynargs[0] = _args[0];
1346         return oraclize_query(_timestamp, _datasource, dynargs);
1347     }
1348 
1349     function oraclize_query(uint _timestamp, string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1350         bytes[] memory dynargs = new bytes[](1);
1351         dynargs[0] = _args[0];
1352         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1353     }
1354 
1355     function oraclize_query(string memory _datasource, bytes[1] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1356         bytes[] memory dynargs = new bytes[](1);
1357         dynargs[0] = _args[0];
1358         return oraclize_query(_datasource, dynargs, _gasLimit);
1359     }
1360 
1361     function oraclize_query(string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1362         bytes[] memory dynargs = new bytes[](2);
1363         dynargs[0] = _args[0];
1364         dynargs[1] = _args[1];
1365         return oraclize_query(_datasource, dynargs);
1366     }
1367 
1368     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1369         bytes[] memory dynargs = new bytes[](2);
1370         dynargs[0] = _args[0];
1371         dynargs[1] = _args[1];
1372         return oraclize_query(_timestamp, _datasource, dynargs);
1373     }
1374 
1375     function oraclize_query(uint _timestamp, string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1376         bytes[] memory dynargs = new bytes[](2);
1377         dynargs[0] = _args[0];
1378         dynargs[1] = _args[1];
1379         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1380     }
1381 
1382     function oraclize_query(string memory _datasource, bytes[2] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1383         bytes[] memory dynargs = new bytes[](2);
1384         dynargs[0] = _args[0];
1385         dynargs[1] = _args[1];
1386         return oraclize_query(_datasource, dynargs, _gasLimit);
1387     }
1388 
1389     function oraclize_query(string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1390         bytes[] memory dynargs = new bytes[](3);
1391         dynargs[0] = _args[0];
1392         dynargs[1] = _args[1];
1393         dynargs[2] = _args[2];
1394         return oraclize_query(_datasource, dynargs);
1395     }
1396 
1397     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1398         bytes[] memory dynargs = new bytes[](3);
1399         dynargs[0] = _args[0];
1400         dynargs[1] = _args[1];
1401         dynargs[2] = _args[2];
1402         return oraclize_query(_timestamp, _datasource, dynargs);
1403     }
1404 
1405     function oraclize_query(uint _timestamp, string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1406         bytes[] memory dynargs = new bytes[](3);
1407         dynargs[0] = _args[0];
1408         dynargs[1] = _args[1];
1409         dynargs[2] = _args[2];
1410         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1411     }
1412 
1413     function oraclize_query(string memory _datasource, bytes[3] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1414         bytes[] memory dynargs = new bytes[](3);
1415         dynargs[0] = _args[0];
1416         dynargs[1] = _args[1];
1417         dynargs[2] = _args[2];
1418         return oraclize_query(_datasource, dynargs, _gasLimit);
1419     }
1420 
1421     function oraclize_query(string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1422         bytes[] memory dynargs = new bytes[](4);
1423         dynargs[0] = _args[0];
1424         dynargs[1] = _args[1];
1425         dynargs[2] = _args[2];
1426         dynargs[3] = _args[3];
1427         return oraclize_query(_datasource, dynargs);
1428     }
1429 
1430     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1431         bytes[] memory dynargs = new bytes[](4);
1432         dynargs[0] = _args[0];
1433         dynargs[1] = _args[1];
1434         dynargs[2] = _args[2];
1435         dynargs[3] = _args[3];
1436         return oraclize_query(_timestamp, _datasource, dynargs);
1437     }
1438 
1439     function oraclize_query(uint _timestamp, string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1440         bytes[] memory dynargs = new bytes[](4);
1441         dynargs[0] = _args[0];
1442         dynargs[1] = _args[1];
1443         dynargs[2] = _args[2];
1444         dynargs[3] = _args[3];
1445         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1446     }
1447 
1448     function oraclize_query(string memory _datasource, bytes[4] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1449         bytes[] memory dynargs = new bytes[](4);
1450         dynargs[0] = _args[0];
1451         dynargs[1] = _args[1];
1452         dynargs[2] = _args[2];
1453         dynargs[3] = _args[3];
1454         return oraclize_query(_datasource, dynargs, _gasLimit);
1455     }
1456 
1457     function oraclize_query(string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1458         bytes[] memory dynargs = new bytes[](5);
1459         dynargs[0] = _args[0];
1460         dynargs[1] = _args[1];
1461         dynargs[2] = _args[2];
1462         dynargs[3] = _args[3];
1463         dynargs[4] = _args[4];
1464         return oraclize_query(_datasource, dynargs);
1465     }
1466 
1467     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args) oraclizeAPI internal returns (bytes32 _id) {
1468         bytes[] memory dynargs = new bytes[](5);
1469         dynargs[0] = _args[0];
1470         dynargs[1] = _args[1];
1471         dynargs[2] = _args[2];
1472         dynargs[3] = _args[3];
1473         dynargs[4] = _args[4];
1474         return oraclize_query(_timestamp, _datasource, dynargs);
1475     }
1476 
1477     function oraclize_query(uint _timestamp, string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1478         bytes[] memory dynargs = new bytes[](5);
1479         dynargs[0] = _args[0];
1480         dynargs[1] = _args[1];
1481         dynargs[2] = _args[2];
1482         dynargs[3] = _args[3];
1483         dynargs[4] = _args[4];
1484         return oraclize_query(_timestamp, _datasource, dynargs, _gasLimit);
1485     }
1486 
1487     function oraclize_query(string memory _datasource, bytes[5] memory _args, uint _gasLimit) oraclizeAPI internal returns (bytes32 _id) {
1488         bytes[] memory dynargs = new bytes[](5);
1489         dynargs[0] = _args[0];
1490         dynargs[1] = _args[1];
1491         dynargs[2] = _args[2];
1492         dynargs[3] = _args[3];
1493         dynargs[4] = _args[4];
1494         return oraclize_query(_datasource, dynargs, _gasLimit);
1495     }
1496 
1497     function oraclize_setProof(byte _proofP) oraclizeAPI internal {
1498         return oraclize.setProofType(_proofP);
1499     }
1500 
1501 
1502     function oraclize_cbAddress() oraclizeAPI internal returns (address _callbackAddress) {
1503         return oraclize.cbAddress();
1504     }
1505 
1506     function getCodeSize(address _addr) view internal returns (uint _size) {
1507         assembly {
1508             _size := extcodesize(_addr)
1509         }
1510     }
1511 
1512     function oraclize_setCustomGasPrice(uint _gasPrice) oraclizeAPI internal {
1513         return oraclize.setCustomGasPrice(_gasPrice);
1514     }
1515 
1516     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32 _sessionKeyHash) {
1517         return oraclize.randomDS_getSessionPubKeyHash();
1518     }
1519 
1520     function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
1521         bytes memory tmp = bytes(_a);
1522         uint160 iaddr = 0;
1523         uint160 b1;
1524         uint160 b2;
1525         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
1526             iaddr *= 256;
1527             b1 = uint160(uint8(tmp[i]));
1528             b2 = uint160(uint8(tmp[i + 1]));
1529             if ((b1 >= 97) && (b1 <= 102)) {
1530                 b1 -= 87;
1531             } else if ((b1 >= 65) && (b1 <= 70)) {
1532                 b1 -= 55;
1533             } else if ((b1 >= 48) && (b1 <= 57)) {
1534                 b1 -= 48;
1535             }
1536             if ((b2 >= 97) && (b2 <= 102)) {
1537                 b2 -= 87;
1538             } else if ((b2 >= 65) && (b2 <= 70)) {
1539                 b2 -= 55;
1540             } else if ((b2 >= 48) && (b2 <= 57)) {
1541                 b2 -= 48;
1542             }
1543             iaddr += (b1 * 16 + b2);
1544         }
1545         return address(iaddr);
1546     }
1547 
1548     function strCompare(string memory _a, string memory _b) internal pure returns (int _returnCode) {
1549         bytes memory a = bytes(_a);
1550         bytes memory b = bytes(_b);
1551         uint minLength = a.length;
1552         if (b.length < minLength) {
1553             minLength = b.length;
1554         }
1555         for (uint i = 0; i < minLength; i ++) {
1556             if (a[i] < b[i]) {
1557                 return -1;
1558             } else if (a[i] > b[i]) {
1559                 return 1;
1560             }
1561         }
1562         if (a.length < b.length) {
1563             return -1;
1564         } else if (a.length > b.length) {
1565             return 1;
1566         } else {
1567             return 0;
1568         }
1569     }
1570 
1571     function indexOf(string memory _haystack, string memory _needle) internal pure returns (int _returnCode) {
1572         bytes memory h = bytes(_haystack);
1573         bytes memory n = bytes(_needle);
1574         if (h.length < 1 || n.length < 1 || (n.length > h.length)) {
1575             return -1;
1576         } else if (h.length > (2 ** 128 - 1)) {
1577             return -1;
1578         } else {
1579             uint subindex = 0;
1580             for (uint i = 0; i < h.length; i++) {
1581                 if (h[i] == n[0]) {
1582                     subindex = 1;
1583                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) {
1584                         subindex++;
1585                     }
1586                     if (subindex == n.length) {
1587                         return int(i);
1588                     }
1589                 }
1590             }
1591             return -1;
1592         }
1593     }
1594 
1595     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
1596         return strConcat(_a, _b, "", "", "");
1597     }
1598 
1599     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
1600         return strConcat(_a, _b, _c, "", "");
1601     }
1602 
1603     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
1604         return strConcat(_a, _b, _c, _d, "");
1605     }
1606 
1607     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
1608         bytes memory _ba = bytes(_a);
1609         bytes memory _bb = bytes(_b);
1610         bytes memory _bc = bytes(_c);
1611         bytes memory _bd = bytes(_d);
1612         bytes memory _be = bytes(_e);
1613         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1614         bytes memory babcde = bytes(abcde);
1615         uint k = 0;
1616         uint i = 0;
1617         for (i = 0; i < _ba.length; i++) {
1618             babcde[k++] = _ba[i];
1619         }
1620         for (i = 0; i < _bb.length; i++) {
1621             babcde[k++] = _bb[i];
1622         }
1623         for (i = 0; i < _bc.length; i++) {
1624             babcde[k++] = _bc[i];
1625         }
1626         for (i = 0; i < _bd.length; i++) {
1627             babcde[k++] = _bd[i];
1628         }
1629         for (i = 0; i < _be.length; i++) {
1630             babcde[k++] = _be[i];
1631         }
1632         return string(babcde);
1633     }
1634 
1635     function safeParseInt(string memory _a) internal pure returns (uint _parsedInt) {
1636         return safeParseInt(_a, 0);
1637     }
1638 
1639     function safeParseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1640         bytes memory bresult = bytes(_a);
1641         uint mint = 0;
1642         bool decimals = false;
1643         for (uint i = 0; i < bresult.length; i++) {
1644             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1645                 if (decimals) {
1646                    if (_b == 0) break;
1647                     else _b--;
1648                 }
1649                 mint *= 10;
1650                 mint += uint(uint8(bresult[i])) - 48;
1651             } else if (uint(uint8(bresult[i])) == 46) {
1652                 require(!decimals, 'More than one decimal encountered in string!');
1653                 decimals = true;
1654             } else {
1655                 revert("Non-numeral character encountered in string!");
1656             }
1657         }
1658         if (_b > 0) {
1659             mint *= 10 ** _b;
1660         }
1661         return mint;
1662     }
1663 
1664     function parseInt(string memory _a) internal pure returns (uint _parsedInt) {
1665         return parseInt(_a, 0);
1666     }
1667 
1668     function parseInt(string memory _a, uint _b) internal pure returns (uint _parsedInt) {
1669         bytes memory bresult = bytes(_a);
1670         uint mint = 0;
1671         bool decimals = false;
1672         for (uint i = 0; i < bresult.length; i++) {
1673             if ((uint(uint8(bresult[i])) >= 48) && (uint(uint8(bresult[i])) <= 57)) {
1674                 if (decimals) {
1675                    if (_b == 0) {
1676                        break;
1677                    } else {
1678                        _b--;
1679                    }
1680                 }
1681                 mint *= 10;
1682                 mint += uint(uint8(bresult[i])) - 48;
1683             } else if (uint(uint8(bresult[i])) == 46) {
1684                 decimals = true;
1685             }
1686         }
1687         if (_b > 0) {
1688             mint *= 10 ** _b;
1689         }
1690         return mint;
1691     }
1692 
1693     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
1694         if (_i == 0) {
1695             return "0";
1696         }
1697         uint j = _i;
1698         uint len;
1699         while (j != 0) {
1700             len++;
1701             j /= 10;
1702         }
1703         bytes memory bstr = new bytes(len);
1704         uint k = len - 1;
1705         while (_i != 0) {
1706             bstr[k--] = byte(uint8(48 + _i % 10));
1707             _i /= 10;
1708         }
1709         return string(bstr);
1710     }
1711 
1712     function stra2cbor(string[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1713         safeMemoryCleaner();
1714         Buffer.buffer memory buf;
1715         Buffer.init(buf, 1024);
1716         buf.startArray();
1717         for (uint i = 0; i < _arr.length; i++) {
1718             buf.encodeString(_arr[i]);
1719         }
1720         buf.endSequence();
1721         return buf.buf;
1722     }
1723 
1724     function ba2cbor(bytes[] memory _arr) internal pure returns (bytes memory _cborEncoding) {
1725         safeMemoryCleaner();
1726         Buffer.buffer memory buf;
1727         Buffer.init(buf, 1024);
1728         buf.startArray();
1729         for (uint i = 0; i < _arr.length; i++) {
1730             buf.encodeBytes(_arr[i]);
1731         }
1732         buf.endSequence();
1733         return buf.buf;
1734     }
1735 
1736     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32 _queryId) {
1737         require((_nbytes > 0) && (_nbytes <= 32));
1738         _delay *= 10; // Convert from seconds to ledger timer ticks
1739         bytes memory nbytes = new bytes(1);
1740         nbytes[0] = byte(uint8(_nbytes));
1741         bytes memory unonce = new bytes(32);
1742         bytes memory sessionKeyHash = new bytes(32);
1743         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1744         assembly {
1745             mstore(unonce, 0x20)
1746             /*
1747              The following variables can be relaxed.
1748              Check the relaxed random contract at https://github.com/oraclize/ethereum-examples
1749              for an idea on how to override and replace commit hash variables.
1750             */
1751             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1752             mstore(sessionKeyHash, 0x20)
1753             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1754         }
1755         bytes memory delay = new bytes(32);
1756         assembly {
1757             mstore(add(delay, 0x20), _delay)
1758         }
1759         bytes memory delay_bytes8 = new bytes(8);
1760         copyBytes(delay, 24, 8, delay_bytes8, 0);
1761         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1762         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1763         bytes memory delay_bytes8_left = new bytes(8);
1764         assembly {
1765             let x := mload(add(delay_bytes8, 0x20))
1766             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1767             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1768             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1769             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1770             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1771             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1772             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1773             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1774         }
1775         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1776         return queryId;
1777     }
1778 
1779     function oraclize_randomDS_setCommitment(bytes32 _queryId, bytes32 _commitment) internal {
1780         oraclize_randomDS_args[_queryId] = _commitment;
1781     }
1782 
1783     function verifySig(bytes32 _tosignh, bytes memory _dersig, bytes memory _pubkey) internal returns (bool _sigVerified) {
1784         bool sigok;
1785         address signer;
1786         bytes32 sigr;
1787         bytes32 sigs;
1788         bytes memory sigr_ = new bytes(32);
1789         uint offset = 4 + (uint(uint8(_dersig[3])) - 0x20);
1790         sigr_ = copyBytes(_dersig, offset, 32, sigr_, 0);
1791         bytes memory sigs_ = new bytes(32);
1792         offset += 32 + 2;
1793         sigs_ = copyBytes(_dersig, offset + (uint(uint8(_dersig[offset - 1])) - 0x20), 32, sigs_, 0);
1794         assembly {
1795             sigr := mload(add(sigr_, 32))
1796             sigs := mload(add(sigs_, 32))
1797         }
1798         (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
1799         if (address(uint160(uint256(keccak256(_pubkey)))) == signer) {
1800             return true;
1801         } else {
1802             (sigok, signer) = safer_ecrecover(_tosignh, 28, sigr, sigs);
1803             return (address(uint160(uint256(keccak256(_pubkey)))) == signer);
1804         }
1805     }
1806 
1807     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes memory _proof, uint _sig2offset) internal returns (bool _proofVerified) {
1808         bool sigok;
1809         // Random DS Proof Step 6: Verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1810         bytes memory sig2 = new bytes(uint(uint8(_proof[_sig2offset + 1])) + 2);
1811         copyBytes(_proof, _sig2offset, sig2.length, sig2, 0);
1812         bytes memory appkey1_pubkey = new bytes(64);
1813         copyBytes(_proof, 3 + 1, 64, appkey1_pubkey, 0);
1814         bytes memory tosign2 = new bytes(1 + 65 + 32);
1815         tosign2[0] = byte(uint8(1)); //role
1816         copyBytes(_proof, _sig2offset - 65, 65, tosign2, 1);
1817         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1818         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1819         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1820         if (!sigok) {
1821             return false;
1822         }
1823         // Random DS Proof Step 7: Verify the APPKEY1 provenance (must be signed by Ledger)
1824         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1825         bytes memory tosign3 = new bytes(1 + 65);
1826         tosign3[0] = 0xFE;
1827         copyBytes(_proof, 3, 65, tosign3, 1);
1828         bytes memory sig3 = new bytes(uint(uint8(_proof[3 + 65 + 1])) + 2);
1829         copyBytes(_proof, 3 + 65, sig3.length, sig3, 0);
1830         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1831         return sigok;
1832     }
1833 
1834     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string memory _result, bytes memory _proof) internal returns (uint8 _returnCode) {
1835         // Random DS Proof Step 1: The prefix has to match 'LP\x01' (Ledger Proof version 1)
1836         if ((_proof[0] != "L") || (_proof[1] != "P") || (uint8(_proof[2]) != uint8(1))) {
1837             return 1;
1838         }
1839         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1840         if (!proofVerified) {
1841             return 2;
1842         }
1843         return 0;
1844     }
1845 
1846     function matchBytes32Prefix(bytes32 _content, bytes memory _prefix, uint _nRandomBytes) internal pure returns (bool _matchesPrefix) {
1847         bool match_ = true;
1848         require(_prefix.length == _nRandomBytes);
1849         for (uint256 i = 0; i< _nRandomBytes; i++) {
1850             if (_content[i] != _prefix[i]) {
1851                 match_ = false;
1852             }
1853         }
1854         return match_;
1855     }
1856 
1857     function oraclize_randomDS_proofVerify__main(bytes memory _proof, bytes32 _queryId, bytes memory _result, string memory _contextName) internal returns (bool _proofVerified) {
1858         // Random DS Proof Step 2: The unique keyhash has to match with the sha256 of (context name + _queryId)
1859         uint ledgerProofLength = 3 + 65 + (uint(uint8(_proof[3 + 65 + 1])) + 2) + 32;
1860         bytes memory keyhash = new bytes(32);
1861         copyBytes(_proof, ledgerProofLength, 32, keyhash, 0);
1862         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(_contextName, _queryId)))))) {
1863             return false;
1864         }
1865         bytes memory sig1 = new bytes(uint(uint8(_proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1])) + 2);
1866         copyBytes(_proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1867         // Random DS Proof Step 3: We assume sig1 is valid (it will be verified during step 5) and we verify if '_result' is the _prefix of sha256(sig1)
1868         if (!matchBytes32Prefix(sha256(sig1), _result, uint(uint8(_proof[ledgerProofLength + 32 + 8])))) {
1869             return false;
1870         }
1871         // Random DS Proof Step 4: Commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1872         // This is to verify that the computed args match with the ones specified in the query.
1873         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1874         copyBytes(_proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1875         bytes memory sessionPubkey = new bytes(64);
1876         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1877         copyBytes(_proof, sig2offset - 64, 64, sessionPubkey, 0);
1878         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1879         if (oraclize_randomDS_args[_queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))) { //unonce, nbytes and sessionKeyHash match
1880             delete oraclize_randomDS_args[_queryId];
1881         } else return false;
1882         // Random DS Proof Step 5: Validity verification for sig1 (keyhash and args signed with the sessionKey)
1883         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1884         copyBytes(_proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1885         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
1886             return false;
1887         }
1888         // Verify if sessionPubkeyHash was verified already, if not.. let's do it!
1889         if (!oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash]) {
1890             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(_proof, sig2offset);
1891         }
1892         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1893     }
1894     /*
1895      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1896     */
1897     function copyBytes(bytes memory _from, uint _fromOffset, uint _length, bytes memory _to, uint _toOffset) internal pure returns (bytes memory _copiedBytes) {
1898         uint minLength = _length + _toOffset;
1899         require(_to.length >= minLength); // Buffer too small. Should be a better way?
1900         uint i = 32 + _fromOffset; // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1901         uint j = 32 + _toOffset;
1902         while (i < (32 + _fromOffset + _length)) {
1903             assembly {
1904                 let tmp := mload(add(_from, i))
1905                 mstore(add(_to, j), tmp)
1906             }
1907             i += 32;
1908             j += 32;
1909         }
1910         return _to;
1911     }
1912     /*
1913      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1914      Duplicate Solidity's ecrecover, but catching the CALL return value
1915     */
1916     function safer_ecrecover(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) internal returns (bool _success, address _recoveredAddress) {
1917         /*
1918          We do our own memory management here. Solidity uses memory offset
1919          0x40 to store the current end of memory. We write past it (as
1920          writes are memory extensions), but don't update the offset so
1921          Solidity will reuse it. The memory used here is only needed for
1922          this context.
1923          FIXME: inline assembly can't access return values
1924         */
1925         bool ret;
1926         address addr;
1927         assembly {
1928             let size := mload(0x40)
1929             mstore(size, _hash)
1930             mstore(add(size, 32), _v)
1931             mstore(add(size, 64), _r)
1932             mstore(add(size, 96), _s)
1933             ret := call(3000, 1, 0, size, 128, size, 32) // NOTE: we can reuse the request memory because we deal with the return code.
1934             addr := mload(size)
1935         }
1936         return (ret, addr);
1937     }
1938     /*
1939      The following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1940     */
1941     function ecrecovery(bytes32 _hash, bytes memory _sig) internal returns (bool _success, address _recoveredAddress) {
1942         bytes32 r;
1943         bytes32 s;
1944         uint8 v;
1945         if (_sig.length != 65) {
1946             return (false, address(0));
1947         }
1948         /*
1949          The signature format is a compact form of:
1950            {bytes32 r}{bytes32 s}{uint8 v}
1951          Compact means, uint8 is not padded to 32 bytes.
1952         */
1953         assembly {
1954             r := mload(add(_sig, 32))
1955             s := mload(add(_sig, 64))
1956             /*
1957              Here we are loading the last 32 bytes. We exploit the fact that
1958              'mload' will pad with zeroes if we overread.
1959              There is no 'mload8' to do this, but that would be nicer.
1960             */
1961             v := byte(0, mload(add(_sig, 96)))
1962             /*
1963               Alternative solution:
1964               'byte' is not working due to the Solidity parser, so lets
1965               use the second best option, 'and'
1966               v := and(mload(add(_sig, 65)), 255)
1967             */
1968         }
1969         /*
1970          albeit non-transactional signatures are not specified by the YP, one would expect it
1971          to match the YP range of [27, 28]
1972          geth uses [0, 1] and some clients have followed. This might change, see:
1973          https://github.com/ethereum/go-ethereum/issues/2053
1974         */
1975         if (v < 27) {
1976             v += 27;
1977         }
1978         if (v != 27 && v != 28) {
1979             return (false, address(0));
1980         }
1981         return safer_ecrecover(_hash, v, r, s);
1982     }
1983 
1984     function safeMemoryCleaner() internal pure {
1985         assembly {
1986             let fmem := mload(0x40)
1987             codecopy(fmem, codesize, sub(msize, fmem))
1988         }
1989     }
1990 }
1991 
1992 /*
1993 
1994 END ORACLIZE_API
1995 
1996 */
1997 
1998 /**
1999  * @title Ownable
2000  * @dev The Ownable contract has an owner address, and provides basic authorization control
2001  * functions, this simplifies the implementation of "user permissions".
2002  */
2003 contract Ownable {
2004 
2005     address public owner;
2006 
2007     /**
2008      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
2009      * account.
2010      */
2011     constructor()public {
2012         owner = msg.sender;
2013     }
2014 
2015     /**
2016      * @dev Throws if called by any account other than the owner.
2017      */
2018     modifier onlyOwner() {
2019         require(msg.sender == owner);
2020         _;
2021     }
2022 }
2023 
2024 /*
2025 Cryptocasino http://playtowin.io - all rights reserved
2026 Game drunkard
2027 Game results are calculated using the service http://oraclize.it based on a query to the https://www.random.org/
2028 The creators of the project are not responsible for any material losses during the game, all bets are made by you at your own peril and risk.
2029 Contract address 0x7777776dd38fcf2a446297305981497f201f85ef, making a bet you give an announcement that you are of age and you are 18 years old.
2030 */
2031 contract DrunkardGame is Ownable, usingOraclize {
2032 
2033     using SafeMath for uint;
2034     using strings for *;
2035     //drunkard settings
2036     address payable public marketing_address = 0x777777018285801412ec226229C6F6AE16445F89;
2037     string public constant GAME_DRUNKARD_TITLE = 'drunkard';
2038     uint public constant GAME_DRUNKARD_ID = 100;
2039     uint public constant MARKETING_PERCENT = 3;
2040     uint public constant MIN_STAKE = 0.05 ether;
2041     uint public constant MAX_STAKE = 1 ether;
2042     uint constant PERCENT_TO_WIN = 225; //bet+125%
2043     uint public round_drunkard = 0;
2044     uint custom_gas_limit;
2045     //drunkard saving games to history
2046     struct drunkard_game {
2047         address payable from;
2048         bytes32 queryId;
2049         uint    round;
2050         bool    winner;
2051         uint    bet;
2052         uint    choice;
2053         uint    game_choice;
2054         uint    timestamp;
2055         uint    profit;
2056         bool    status;
2057         uint    serial;
2058     }
2059     mapping (bytes32 => drunkard_game) drunkard_game_hystory;
2060     bytes32[] public oraclizedIndices;
2061     //incomplete user games
2062     mapping (address => uint) playerPendingWithdrawals;
2063     bool public drunkard_status;
2064     
2065     constructor()public{
2066         //set gas price to oraclize query
2067         oraclize_setCustomGasPrice(10000000000 wei);
2068         //set gas limit for oracle callback
2069         custom_gas_limit = 235000;
2070         //status game true: started, false: stopped
2071         drunkard_status = true;
2072     }
2073 
2074     event Drunkard(
2075         address indexed from,
2076         uint round,
2077         uint choice,
2078         uint bet,
2079         uint game_choice,
2080         bool winner,
2081         //uint timestamp,
2082         uint profit,
2083         bytes32 proof_hash
2084     );
2085 
2086     event Game(
2087         address indexed from,
2088         uint indexed block,
2089         uint value,
2090         string game,
2091         bytes32 proof_hash
2092     );
2093     
2094     //playing with contract wallets is prohibited
2095     modifier isNotContract() {
2096         uint size;
2097         address addr = msg.sender;
2098         assembly { size := extcodesize(addr) }
2099         require(size == 0 && tx.origin == msg.sender);
2100         _;
2101     }
2102     
2103     modifier drunkardIsStarted() {
2104         require(drunkard_status);
2105         _;
2106     }
2107     
2108     /*
2109     only if game is active & bet is valid can query oraclize and set player vars     
2110     */
2111     function game_drunkard(uint _choice)drunkardIsStarted isNotContract external payable {
2112        
2113         require(_choice >=1 && _choice <=3, "Invalid choice");
2114         require(msg.value >= MIN_STAKE && msg.value <= MAX_STAKE, 'Minimal stake 0.05 ether, max stake 1 ether');
2115         
2116         // Making oraclized query to random.org.
2117         bytes32 oraclizeQueryId;
2118         round_drunkard +=1;
2119         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/2/invoke).result.random[\"serialNumber\", \"data\", \"userData\"]', '\\n{\"jsonrpc\": \"2.0\", \"method\": \"generateSignedIntegers\", \"params\": { \"apiKey\": \"${[decrypt] BBrhDqQMkDMenw2av7Bl4vIPCmkF1jH+jj8R3vclZ8ar/Zi0jcvxdJ3cnOZquLE6+gxptFVY3RTZtjL/2hTppCA3dHCJpJ7KQHwWyfC9ZRkP94N/5LdNb4dLAtykAy2LZnHZGt1tSZOOjfndZZQzRgrvD9XF}\", \"n\": 1, \"min\": 1, \"max\": 3, \"userData\":";
2120         string memory queryString2 = uint2str(GAME_DRUNKARD_ID);
2121         string memory queryString3 = ",\"replacement\": true, \"base\": 10${[identity] \"}\"}, \"id\":";
2122         string memory queryString4 = uint2str(round_drunkard);
2123         string memory queryString5 = "${[identity] \"}\"}']";
2124         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
2125         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
2126         string memory queryString1_2_3_4 = queryString1_2_3.toSlice().concat(queryString4.toSlice());
2127         string memory queryString = queryString1_2_3_4.toSlice().concat(queryString5.toSlice());
2128         
2129         oraclizeQueryId = oraclize_query( 
2130           "nested", 
2131           queryString,
2132           custom_gas_limit
2133         ); 
2134         
2135         // Recording the bet info for future reference.
2136         drunkard_game_hystory[oraclizeQueryId].round = round_drunkard;
2137         drunkard_game_hystory[oraclizeQueryId].winner = false;
2138         drunkard_game_hystory[oraclizeQueryId].queryId = oraclizeQueryId;
2139         drunkard_game_hystory[oraclizeQueryId].from = msg.sender;
2140         drunkard_game_hystory[oraclizeQueryId].bet = msg.value;
2141         drunkard_game_hystory[oraclizeQueryId].choice = _choice;
2142         drunkard_game_hystory[oraclizeQueryId].status = true;
2143         
2144         // Recording oraclize indices.
2145         oraclizedIndices.push(oraclizeQueryId) -1;
2146         //Recording user bet
2147         playerPendingWithdrawals[msg.sender] = playerPendingWithdrawals[msg.sender].add(msg.value);
2148         emit Game(msg.sender, block.number, msg.value, GAME_DRUNKARD_TITLE, oraclizeQueryId);
2149     }
2150     
2151     /*only oracle can call this method*/
2152     function __callback(bytes32 myid, string memory result)public payable {
2153         require (msg.sender == oraclize_cbAddress(), 'Only an oracle can call a method.');
2154    
2155         if(drunkard_game_hystory[myid].status){
2156             /* map random result to player */
2157             strings.slice memory oraclize_result = result.toSlice();
2158             strings.slice memory part;
2159             //serial number of request for random.org
2160             uint serilal = parseInt(oraclize_result.split(",".toSlice(), part).toString()); 
2161             //random number from random.org
2162             uint choices = parseInt(oraclize_result.split(",".toSlice(), part).toString()); 
2163             //game ID
2164             uint game = parseInt(oraclize_result.split(",".toSlice(), part).toString());
2165             
2166             if(game == GAME_DRUNKARD_ID){
2167                 __drunkard_result(myid, serilal, choices);
2168             }
2169         }
2170    }
2171    
2172    /*calculate winnings based on callback oraclize.io and random.org*/
2173    function __drunkard_result(bytes32 _id, uint _serial, uint _random)internal {
2174             address payable player = drunkard_game_hystory[_id].from;
2175             uint choice = drunkard_game_hystory[_id].choice;
2176             uint bet = drunkard_game_hystory[_id].bet;
2177             bool winner = false;
2178             uint profit;
2179             
2180             if(choice == _random){
2181                 winner = true;
2182                 //calculation of winnings: bet + 125% - 3% ccommission
2183                 uint start_profit = bet.mul(PERCENT_TO_WIN).div(100);
2184                 //system commission 3%
2185                 uint commission = start_profit.mul(MARKETING_PERCENT).div(100);
2186                 profit = start_profit - commission; 
2187                 drunkard_game_hystory[_id].profit = profit;
2188                 marketing_address.transfer(commission);
2189                 player.transfer(profit);
2190             }else{
2191                 drunkard_game_hystory[_id].profit = 0;
2192             }
2193             
2194             drunkard_game_hystory[_id].timestamp = now;
2195             drunkard_game_hystory[_id].game_choice = _random;
2196             drunkard_game_hystory[_id].winner = winner;
2197             drunkard_game_hystory[_id].status = false;
2198             drunkard_game_hystory[_id].serial = _serial;
2199             //delete the record of the pending user transaction
2200             playerPendingWithdrawals[player] = playerPendingWithdrawals[player].sub(bet);
2201             emit Drunkard(player, 1, choice, bet, _random, winner,  profit, _id);
2202    }
2203    
2204    /*get game specific data*/
2205    function getGame(bytes32 _game)public view returns(
2206        address from,
2207        bytes32 queryId,
2208        uint round,
2209        bool winner,
2210        uint bet,
2211        uint choice,
2212        uint game_choice,
2213        uint timestamp,
2214        uint profit,
2215        bool status,
2216        uint serial) {
2217         from = drunkard_game_hystory[_game].from;
2218         queryId = drunkard_game_hystory[_game].queryId;
2219         round = drunkard_game_hystory[_game].round;
2220         winner = drunkard_game_hystory[_game].winner;
2221         bet = drunkard_game_hystory[_game].bet;
2222         choice = drunkard_game_hystory[_game].choice;
2223         game_choice = drunkard_game_hystory[_game].game_choice;
2224         timestamp = drunkard_game_hystory[_game].timestamp;
2225         profit = drunkard_game_hystory[_game].profit;
2226         status = drunkard_game_hystory[_game].status;
2227         serial = drunkard_game_hystory[_game].serial;
2228     }
2229     
2230     /*
2231     All funds are on the contract and are not covered by the rate of cryptocasino property.
2232     The casino pays 0.0044 broadcasts at each bet per call by random.org.
2233     To cover the costs of maintaining servers and equipment, we must withdraw some of the money from the contract.
2234     */
2235     function returnRoyalty(uint _value) onlyOwner public {
2236         uint value = _value.mul(1 ether);
2237         if (address(this).balance >= value) {
2238             marketing_address.transfer(value);
2239         }
2240     }
2241     
2242     /* start game */
2243     function ownerStartGame() public onlyOwner {
2244         drunkard_status = true;
2245     }
2246     
2247     /* stop game */
2248     function ownerStopGame() public onlyOwner {
2249         drunkard_status = false;
2250     }
2251     
2252     /* set gas price for oraclize callback */
2253     function ownerSetCallbackGasPrice(uint _new_gas_price) public onlyOwner {
2254         oraclize_setCustomGasPrice(_new_gas_price);
2255     }
2256     
2257     /* set gas limit for oraclize query */
2258     function ownerSetOraclizeSafeGas(uint32 _new_custom_gas_limit) public onlyOwner	{
2259     	custom_gas_limit = _new_custom_gas_limit;
2260     }
2261 
2262      function() external payable {
2263 
2264     }
2265 }