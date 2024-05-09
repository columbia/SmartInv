1 pragma solidity ^0.4.24;
2 
3 /**
4  * ENS Registry interface.
5  */
6 contract ENSRegistry {
7     function owner(bytes32 _node) public view returns (address);
8     function resolver(bytes32 _node) public view returns (address);
9     function ttl(bytes32 _node) public view returns (uint64);
10     function setOwner(bytes32 _node, address _owner) public;
11     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
12     function setResolver(bytes32 _node, address _resolver) public;
13     function setTTL(bytes32 _node, uint64 _ttl) public;
14 }
15 
16 /**
17  * ENS Resolver interface.
18  */
19 contract ENSResolver {
20     function addr(bytes32 _node) public view returns (address);
21     function setAddr(bytes32 _node, address _addr) public;
22     function name(bytes32 _node) public view returns (string);
23     function setName(bytes32 _node, string _name) public;
24 }
25 
26 /**
27  * ENS Reverse Registrar interface.
28  */
29 contract ENSReverseRegistrar {
30     function claim(address _owner) public returns (bytes32 _node);
31     function claimWithResolver(address _owner, address _resolver) public returns (bytes32);
32     function setName(string _name) public returns (bytes32);
33     function node(address _addr) public view returns (bytes32);
34 }
35 
36 /*
37  * @title String & slice utility library for Solidity contracts.
38  * @author Nick Johnson <arachnid@notdot.net>
39  *
40  * @dev Functionality in this library is largely implemented using an
41  *      abstraction called a 'slice'. A slice represents a part of a string -
42  *      anything from the entire string to a single character, or even no
43  *      characters at all (a 0-length slice). Since a slice only has to specify
44  *      an offset and a length, copying and manipulating slices is a lot less
45  *      expensive than copying and manipulating the strings they reference.
46  *
47  *      To further reduce gas costs, most functions on slice that need to return
48  *      a slice modify the original one instead of allocating a new one; for
49  *      instance, `s.split(".")` will return the text up to the first '.',
50  *      modifying s to only contain the remainder of the string after the '.'.
51  *      In situations where you do not want to modify the original slice, you
52  *      can make a copy first with `.copy()`, for example:
53  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
54  *      Solidity has no memory management, it will result in allocating many
55  *      short-lived slices that are later discarded.
56  *
57  *      Functions that return two slices come in two versions: a non-allocating
58  *      version that takes the second slice as an argument, modifying it in
59  *      place, and an allocating version that allocates and returns the second
60  *      slice; see `nextRune` for example.
61  *
62  *      Functions that have to copy string data will return strings rather than
63  *      slices; these can be cast back to slices for further processing if
64  *      required.
65  *
66  *      For convenience, some functions are provided with non-modifying
67  *      variants that create a new slice and return both; for instance,
68  *      `s.splitNew('.')` leaves s unmodified, and returns two values
69  *      corresponding to the left and right parts of the string.
70  */
71 /* solium-disable */
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
111      * @dev Returns the length of a null-terminated bytes32 string.
112      * @param self The value to find the length of.
113      * @return The length of the string, from 0 to 32.
114      */
115     function len(bytes32 self) internal pure returns (uint) {
116         uint ret;
117         if (self == 0)
118             return 0;
119         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
120             ret += 16;
121             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
122         }
123         if (self & 0xffffffffffffffff == 0) {
124             ret += 8;
125             self = bytes32(uint(self) / 0x10000000000000000);
126         }
127         if (self & 0xffffffff == 0) {
128             ret += 4;
129             self = bytes32(uint(self) / 0x100000000);
130         }
131         if (self & 0xffff == 0) {
132             ret += 2;
133             self = bytes32(uint(self) / 0x10000);
134         }
135         if (self & 0xff == 0) {
136             ret += 1;
137         }
138         return 32 - ret;
139     }
140 
141     /*
142      * @dev Returns a slice containing the entire bytes32, interpreted as a
143      *      null-terminated utf-8 string.
144      * @param self The bytes32 value to convert to a slice.
145      * @return A new slice containing the value of the input argument up to the
146      *         first null.
147      */
148     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
149         // Allocate space for `self` in memory, copy it there, and point ret at it
150         assembly {
151             let ptr := mload(0x40)
152             mstore(0x40, add(ptr, 0x20))
153             mstore(ptr, self)
154             mstore(add(ret, 0x20), ptr)
155         }
156         ret._len = len(self);
157     }
158 
159     /*
160      * @dev Returns a new slice containing the same data as the current slice.
161      * @param self The slice to copy.
162      * @return A new slice containing the same data as `self`.
163      */
164     function copy(slice memory self) internal pure returns (slice memory) {
165         return slice(self._len, self._ptr);
166     }
167 
168     /*
169      * @dev Copies a slice to a new string.
170      * @param self The slice to copy.
171      * @return A newly allocated string containing the slice's text.
172      */
173     function toString(slice memory self) internal pure returns (string memory) {
174         string memory ret = new string(self._len);
175         uint retptr;
176         assembly { retptr := add(ret, 32) }
177 
178         memcpy(retptr, self._ptr, self._len);
179         return ret;
180     }
181 
182     /*
183      * @dev Returns the length in runes of the slice. Note that this operation
184      *      takes time proportional to the length of the slice; avoid using it
185      *      in loops, and call `slice.empty()` if you only need to know whether
186      *      the slice is empty or not.
187      * @param self The slice to operate on.
188      * @return The length of the slice in runes.
189      */
190     function len(slice memory self) internal pure returns (uint l) {
191         // Starting at ptr-31 means the LSB will be the byte we care about
192         uint ptr = self._ptr - 31;
193         uint end = ptr + self._len;
194         for (l = 0; ptr < end; l++) {
195             uint8 b;
196             assembly { b := and(mload(ptr), 0xFF) }
197             if (b < 0x80) {
198                 ptr += 1;
199             } else if(b < 0xE0) {
200                 ptr += 2;
201             } else if(b < 0xF0) {
202                 ptr += 3;
203             } else if(b < 0xF8) {
204                 ptr += 4;
205             } else if(b < 0xFC) {
206                 ptr += 5;
207             } else {
208                 ptr += 6;
209             }
210         }
211     }
212 
213     /*
214      * @dev Returns true if the slice is empty (has a length of 0).
215      * @param self The slice to operate on.
216      * @return True if the slice is empty, False otherwise.
217      */
218     function empty(slice memory self) internal pure returns (bool) {
219         return self._len == 0;
220     }
221 
222     /*
223      * @dev Returns a positive number if `other` comes lexicographically after
224      *      `self`, a negative number if it comes before, or zero if the
225      *      contents of the two slices are equal. Comparison is done per-rune,
226      *      on unicode codepoints.
227      * @param self The first slice to compare.
228      * @param other The second slice to compare.
229      * @return The result of the comparison.
230      */
231     function compare(slice memory self, slice memory other) internal pure returns (int) {
232         uint shortest = self._len;
233         if (other._len < self._len)
234             shortest = other._len;
235 
236         uint selfptr = self._ptr;
237         uint otherptr = other._ptr;
238         for (uint idx = 0; idx < shortest; idx += 32) {
239             uint a;
240             uint b;
241             assembly {
242                 a := mload(selfptr)
243                 b := mload(otherptr)
244             }
245             if (a != b) {
246                 // Mask out irrelevant bytes and check again
247                 uint256 mask = uint256(-1); // 0xffff...
248                 if(shortest < 32) {
249                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
250                 }
251                 uint256 diff = (a & mask) - (b & mask);
252                 if (diff != 0)
253                     return int(diff);
254             }
255             selfptr += 32;
256             otherptr += 32;
257         }
258         return int(self._len) - int(other._len);
259     }
260 
261     /*
262      * @dev Returns true if the two slices contain the same text.
263      * @param self The first slice to compare.
264      * @param self The second slice to compare.
265      * @return True if the slices are equal, false otherwise.
266      */
267     function equals(slice memory self, slice memory other) internal pure returns (bool) {
268         return compare(self, other) == 0;
269     }
270 
271     /*
272      * @dev Extracts the first rune in the slice into `rune`, advancing the
273      *      slice to point to the next rune and returning `self`.
274      * @param self The slice to operate on.
275      * @param rune The slice that will contain the first rune.
276      * @return `rune`.
277      */
278     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
279         rune._ptr = self._ptr;
280 
281         if (self._len == 0) {
282             rune._len = 0;
283             return rune;
284         }
285 
286         uint l;
287         uint b;
288         // Load the first byte of the rune into the LSBs of b
289         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
290         if (b < 0x80) {
291             l = 1;
292         } else if(b < 0xE0) {
293             l = 2;
294         } else if(b < 0xF0) {
295             l = 3;
296         } else {
297             l = 4;
298         }
299 
300         // Check for truncated codepoints
301         if (l > self._len) {
302             rune._len = self._len;
303             self._ptr += self._len;
304             self._len = 0;
305             return rune;
306         }
307 
308         self._ptr += l;
309         self._len -= l;
310         rune._len = l;
311         return rune;
312     }
313 
314     /*
315      * @dev Returns the first rune in the slice, advancing the slice to point
316      *      to the next rune.
317      * @param self The slice to operate on.
318      * @return A slice containing only the first rune from `self`.
319      */
320     function nextRune(slice memory self) internal pure returns (slice memory ret) {
321         nextRune(self, ret);
322     }
323 
324     /*
325      * @dev Returns the number of the first codepoint in the slice.
326      * @param self The slice to operate on.
327      * @return The number of the first codepoint in the slice.
328      */
329     function ord(slice memory self) internal pure returns (uint ret) {
330         if (self._len == 0) {
331             return 0;
332         }
333 
334         uint word;
335         uint length;
336         uint divisor = 2 ** 248;
337 
338         // Load the rune into the MSBs of b
339         assembly { word:= mload(mload(add(self, 32))) }
340         uint b = word / divisor;
341         if (b < 0x80) {
342             ret = b;
343             length = 1;
344         } else if(b < 0xE0) {
345             ret = b & 0x1F;
346             length = 2;
347         } else if(b < 0xF0) {
348             ret = b & 0x0F;
349             length = 3;
350         } else {
351             ret = b & 0x07;
352             length = 4;
353         }
354 
355         // Check for truncated codepoints
356         if (length > self._len) {
357             return 0;
358         }
359 
360         for (uint i = 1; i < length; i++) {
361             divisor = divisor / 256;
362             b = (word / divisor) & 0xFF;
363             if (b & 0xC0 != 0x80) {
364                 // Invalid UTF-8 sequence
365                 return 0;
366             }
367             ret = (ret * 64) | (b & 0x3F);
368         }
369 
370         return ret;
371     }
372 
373     /*
374      * @dev Returns the keccak-256 hash of the slice.
375      * @param self The slice to hash.
376      * @return The hash of the slice.
377      */
378     function keccak(slice memory self) internal pure returns (bytes32 ret) {
379         assembly {
380             ret := keccak256(mload(add(self, 32)), mload(self))
381         }
382     }
383 
384     /*
385      * @dev Returns true if `self` starts with `needle`.
386      * @param self The slice to operate on.
387      * @param needle The slice to search for.
388      * @return True if the slice starts with the provided text, false otherwise.
389      */
390     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
391         if (self._len < needle._len) {
392             return false;
393         }
394 
395         if (self._ptr == needle._ptr) {
396             return true;
397         }
398 
399         bool equal;
400         assembly {
401             let length := mload(needle)
402             let selfptr := mload(add(self, 0x20))
403             let needleptr := mload(add(needle, 0x20))
404             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
405         }
406         return equal;
407     }
408 
409     /*
410      * @dev If `self` starts with `needle`, `needle` is removed from the
411      *      beginning of `self`. Otherwise, `self` is unmodified.
412      * @param self The slice to operate on.
413      * @param needle The slice to search for.
414      * @return `self`
415      */
416     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
417         if (self._len < needle._len) {
418             return self;
419         }
420 
421         bool equal = true;
422         if (self._ptr != needle._ptr) {
423             assembly {
424                 let length := mload(needle)
425                 let selfptr := mload(add(self, 0x20))
426                 let needleptr := mload(add(needle, 0x20))
427                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
428             }
429         }
430 
431         if (equal) {
432             self._len -= needle._len;
433             self._ptr += needle._len;
434         }
435 
436         return self;
437     }
438 
439     /*
440      * @dev Returns true if the slice ends with `needle`.
441      * @param self The slice to operate on.
442      * @param needle The slice to search for.
443      * @return True if the slice starts with the provided text, false otherwise.
444      */
445     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
446         if (self._len < needle._len) {
447             return false;
448         }
449 
450         uint selfptr = self._ptr + self._len - needle._len;
451 
452         if (selfptr == needle._ptr) {
453             return true;
454         }
455 
456         bool equal;
457         assembly {
458             let length := mload(needle)
459             let needleptr := mload(add(needle, 0x20))
460             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
461         }
462 
463         return equal;
464     }
465 
466     /*
467      * @dev If `self` ends with `needle`, `needle` is removed from the
468      *      end of `self`. Otherwise, `self` is unmodified.
469      * @param self The slice to operate on.
470      * @param needle The slice to search for.
471      * @return `self`
472      */
473     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
474         if (self._len < needle._len) {
475             return self;
476         }
477 
478         uint selfptr = self._ptr + self._len - needle._len;
479         bool equal = true;
480         if (selfptr != needle._ptr) {
481             assembly {
482                 let length := mload(needle)
483                 let needleptr := mload(add(needle, 0x20))
484                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
485             }
486         }
487 
488         if (equal) {
489             self._len -= needle._len;
490         }
491 
492         return self;
493     }
494 
495     // Returns the memory address of the first byte of the first occurrence of
496     // `needle` in `self`, or the first byte after `self` if not found.
497     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
498         uint ptr = selfptr;
499         uint idx;
500 
501         if (needlelen <= selflen) {
502             if (needlelen <= 32) {
503                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
504 
505                 bytes32 needledata;
506                 assembly { needledata := and(mload(needleptr), mask) }
507 
508                 uint end = selfptr + selflen - needlelen;
509                 bytes32 ptrdata;
510                 assembly { ptrdata := and(mload(ptr), mask) }
511 
512                 while (ptrdata != needledata) {
513                     if (ptr >= end)
514                         return selfptr + selflen;
515                     ptr++;
516                     assembly { ptrdata := and(mload(ptr), mask) }
517                 }
518                 return ptr;
519             } else {
520                 // For long needles, use hashing
521                 bytes32 hash;
522                 assembly { hash := keccak256(needleptr, needlelen) }
523 
524                 for (idx = 0; idx <= selflen - needlelen; idx++) {
525                     bytes32 testHash;
526                     assembly { testHash := keccak256(ptr, needlelen) }
527                     if (hash == testHash)
528                         return ptr;
529                     ptr += 1;
530                 }
531             }
532         }
533         return selfptr + selflen;
534     }
535 
536     // Returns the memory address of the first byte after the last occurrence of
537     // `needle` in `self`, or the address of `self` if not found.
538     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
539         uint ptr;
540 
541         if (needlelen <= selflen) {
542             if (needlelen <= 32) {
543                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
544 
545                 bytes32 needledata;
546                 assembly { needledata := and(mload(needleptr), mask) }
547 
548                 ptr = selfptr + selflen - needlelen;
549                 bytes32 ptrdata;
550                 assembly { ptrdata := and(mload(ptr), mask) }
551 
552                 while (ptrdata != needledata) {
553                     if (ptr <= selfptr)
554                         return selfptr;
555                     ptr--;
556                     assembly { ptrdata := and(mload(ptr), mask) }
557                 }
558                 return ptr + needlelen;
559             } else {
560                 // For long needles, use hashing
561                 bytes32 hash;
562                 assembly { hash := keccak256(needleptr, needlelen) }
563                 ptr = selfptr + (selflen - needlelen);
564                 while (ptr >= selfptr) {
565                     bytes32 testHash;
566                     assembly { testHash := keccak256(ptr, needlelen) }
567                     if (hash == testHash)
568                         return ptr + needlelen;
569                     ptr -= 1;
570                 }
571             }
572         }
573         return selfptr;
574     }
575 
576     /*
577      * @dev Modifies `self` to contain everything from the first occurrence of
578      *      `needle` to the end of the slice. `self` is set to the empty slice
579      *      if `needle` is not found.
580      * @param self The slice to search and modify.
581      * @param needle The text to search for.
582      * @return `self`.
583      */
584     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
585         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
586         self._len -= ptr - self._ptr;
587         self._ptr = ptr;
588         return self;
589     }
590 
591     /*
592      * @dev Modifies `self` to contain the part of the string from the start of
593      *      `self` to the end of the first occurrence of `needle`. If `needle`
594      *      is not found, `self` is set to the empty slice.
595      * @param self The slice to search and modify.
596      * @param needle The text to search for.
597      * @return `self`.
598      */
599     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
600         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
601         self._len = ptr - self._ptr;
602         return self;
603     }
604 
605     /*
606      * @dev Splits the slice, setting `self` to everything after the first
607      *      occurrence of `needle`, and `token` to everything before it. If
608      *      `needle` does not occur in `self`, `self` is set to the empty slice,
609      *      and `token` is set to the entirety of `self`.
610      * @param self The slice to split.
611      * @param needle The text to search for in `self`.
612      * @param token An output parameter to which the first token is written.
613      * @return `token`.
614      */
615     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
616         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
617         token._ptr = self._ptr;
618         token._len = ptr - self._ptr;
619         if (ptr == self._ptr + self._len) {
620             // Not found
621             self._len = 0;
622         } else {
623             self._len -= token._len + needle._len;
624             self._ptr = ptr + needle._len;
625         }
626         return token;
627     }
628 
629     /*
630      * @dev Splits the slice, setting `self` to everything after the first
631      *      occurrence of `needle`, and returning everything before it. If
632      *      `needle` does not occur in `self`, `self` is set to the empty slice,
633      *      and the entirety of `self` is returned.
634      * @param self The slice to split.
635      * @param needle The text to search for in `self`.
636      * @return The part of `self` up to the first occurrence of `delim`.
637      */
638     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
639         split(self, needle, token);
640     }
641 
642     /*
643      * @dev Splits the slice, setting `self` to everything before the last
644      *      occurrence of `needle`, and `token` to everything after it. If
645      *      `needle` does not occur in `self`, `self` is set to the empty slice,
646      *      and `token` is set to the entirety of `self`.
647      * @param self The slice to split.
648      * @param needle The text to search for in `self`.
649      * @param token An output parameter to which the first token is written.
650      * @return `token`.
651      */
652     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
653         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
654         token._ptr = ptr;
655         token._len = self._len - (ptr - self._ptr);
656         if (ptr == self._ptr) {
657             // Not found
658             self._len = 0;
659         } else {
660             self._len -= token._len + needle._len;
661         }
662         return token;
663     }
664 
665     /*
666      * @dev Splits the slice, setting `self` to everything before the last
667      *      occurrence of `needle`, and returning everything after it. If
668      *      `needle` does not occur in `self`, `self` is set to the empty slice,
669      *      and the entirety of `self` is returned.
670      * @param self The slice to split.
671      * @param needle The text to search for in `self`.
672      * @return The part of `self` after the last occurrence of `delim`.
673      */
674     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
675         rsplit(self, needle, token);
676     }
677 
678     /*
679      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
680      * @param self The slice to search.
681      * @param needle The text to search for in `self`.
682      * @return The number of occurrences of `needle` found in `self`.
683      */
684     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
685         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
686         while (ptr <= self._ptr + self._len) {
687             cnt++;
688             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
689         }
690     }
691 
692     /*
693      * @dev Returns True if `self` contains `needle`.
694      * @param self The slice to search.
695      * @param needle The text to search for in `self`.
696      * @return True if `needle` is found in `self`, false otherwise.
697      */
698     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
699         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
700     }
701 
702     /*
703      * @dev Returns a newly allocated string containing the concatenation of
704      *      `self` and `other`.
705      * @param self The first slice to concatenate.
706      * @param other The second slice to concatenate.
707      * @return The concatenation of the two strings.
708      */
709     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
710         string memory ret = new string(self._len + other._len);
711         uint retptr;
712         assembly { retptr := add(ret, 32) }
713         memcpy(retptr, self._ptr, self._len);
714         memcpy(retptr + self._len, other._ptr, other._len);
715         return ret;
716     }
717 
718     /*
719      * @dev Joins an array of slices, using `self` as a delimiter, returning a
720      *      newly allocated string.
721      * @param self The delimiter to use.
722      * @param parts A list of slices to join.
723      * @return A newly allocated string containing all the slices in `parts`,
724      *         joined with `self`.
725      */
726     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
727         if (parts.length == 0)
728             return "";
729 
730         uint length = self._len * (parts.length - 1);
731         for(uint i = 0; i < parts.length; i++)
732             length += parts[i]._len;
733 
734         string memory ret = new string(length);
735         uint retptr;
736         assembly { retptr := add(ret, 32) }
737 
738         for(i = 0; i < parts.length; i++) {
739             memcpy(retptr, parts[i]._ptr, parts[i]._len);
740             retptr += parts[i]._len;
741             if (i < parts.length - 1) {
742                 memcpy(retptr, self._ptr, self._len);
743                 retptr += self._len;
744             }
745         }
746 
747         return ret;
748     }
749 }
750 
751 /**
752  * @title ENSConsumer
753  * @dev Helper contract to resolve ENS names.
754  * @author Julien Niset - <julien@argent.xyz>
755  */
756 contract ENSConsumer {
757 
758     using strings for *;
759 
760     // namehash('addr.reverse')
761     bytes32 constant public ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
762 
763     // the address of the ENS registry
764     address ensRegistry;
765 
766     /**
767     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The 
768     * contract will use the hardcoded value.
769     */
770     constructor(address _ensRegistry) public {
771         ensRegistry = _ensRegistry;
772     }
773 
774     /**
775     * @dev Resolves an ENS name to an address.
776     * @param _node The namehash of the ENS name. 
777     */
778     function resolveEns(bytes32 _node) public view returns (address) {
779         address resolver = getENSRegistry().resolver(_node);
780         return ENSResolver(resolver).addr(_node);
781     }
782 
783     /**
784     * @dev Gets the official ENS registry.
785     */
786     function getENSRegistry() public view returns (ENSRegistry) {
787         return ENSRegistry(ensRegistry);
788     }
789 
790     /**
791     * @dev Gets the official ENS reverse registrar. 
792     */
793     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
794         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
795     }
796 }
797 
798 /**
799  * @title Owned
800  * @dev Basic contract to define an owner.
801  * @author Julien Niset - <julien@argent.xyz>
802  */
803 contract Owned {
804 
805     // The owner
806     address public owner;
807 
808     event OwnerChanged(address indexed _newOwner);
809 
810     /**
811      * @dev Throws if the sender is not the owner.
812      */
813     modifier onlyOwner {
814         require(msg.sender == owner, "Must be owner");
815         _;
816     }
817 
818     constructor() public {
819         owner = msg.sender;
820     }
821 
822     /**
823      * @dev Lets the owner transfer ownership of the contract to a new owner.
824      * @param _newOwner The new owner.
825      */
826     function changeOwner(address _newOwner) external onlyOwner {
827         require(_newOwner != address(0), "Address must not be null");
828         owner = _newOwner;
829         emit OwnerChanged(_newOwner);
830     }
831 }
832 
833 /**
834  * @title Managed
835  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
836  * @author Julien Niset - <julien@argent.xyz>
837  */
838 contract Managed is Owned {
839 
840     // The managers
841     mapping (address => bool) public managers;
842 
843     /**
844      * @dev Throws if the sender is not a manager.
845      */
846     modifier onlyManager {
847         require(managers[msg.sender] == true, "M: Must be manager");
848         _;
849     }
850 
851     event ManagerAdded(address indexed _manager);
852     event ManagerRevoked(address indexed _manager);
853 
854     /**
855     * @dev Adds a manager. 
856     * @param _manager The address of the manager.
857     */
858     function addManager(address _manager) external onlyOwner {
859         require(_manager != address(0), "M: Address must not be null");
860         if(managers[_manager] == false) {
861             managers[_manager] = true;
862             emit ManagerAdded(_manager);
863         }        
864     }
865 
866     /**
867     * @dev Revokes a manager.
868     * @param _manager The address of the manager.
869     */
870     function revokeManager(address _manager) external onlyOwner {
871         require(managers[_manager] == true, "M: Target must be an existing manager");
872         delete managers[_manager];
873         emit ManagerRevoked(_manager);
874     }
875 }
876 
877 /**
878  * @dev Interface for an ENS Mananger.
879  */
880 interface IENSManager {
881     function changeRootnodeOwner(address _newOwner) external;
882     function register(string _label, address _owner) external;
883     function isAvailable(bytes32 _subnode) external view returns(bool);
884 }
885 
886 /**
887  * @title ArgentENSManager
888  * @dev Implementation of an ENS manager that orchestrates the complete
889  * registration of subdomains for a single root (e.g. argent.xyz). 
890  * The contract defines a manager role who is the only role that can trigger the registration of
891  * a new subdomain.
892  * @author Julien Niset - <julien@argent.xyz>
893  */
894 contract ArgentENSManager is IENSManager, Owned, Managed, ENSConsumer {
895     
896     using strings for *;
897 
898     // The managed root name
899     string public rootName;
900     // The managed root node
901     bytes32 public rootNode;
902     // The address of the ENS resolver
903     address public ensResolver;
904 
905     // *************** Events *************************** //
906 
907     event RootnodeOwnerChange(bytes32 indexed _rootnode, address indexed _newOwner);
908     event ENSResolverChanged(address addr);
909     event Registered(address indexed _owner, string _ens);
910     event Unregistered(string _ens);
911 
912     // *************** Constructor ********************** //
913 
914     /**
915      * @dev Constructor that sets the ENS root name and root node to manage.
916      * @param _rootName The root name (e.g. argentx.eth).
917      * @param _rootNode The node of the root name (e.g. namehash(argentx.eth)).
918      */
919     constructor(string _rootName, bytes32 _rootNode, address _ensRegistry, address _ensResolver) ENSConsumer(_ensRegistry) public {
920         rootName = _rootName;
921         rootNode = _rootNode;
922         ensResolver = _ensResolver;
923     }
924 
925     // *************** External Functions ********************* //
926 
927     /**
928      * @dev This function must be called when the ENS Manager contract is replaced
929      * and the address of the new Manager should be provided.
930      * @param _newOwner The address of the new ENS manager that will manage the root node.
931      */
932     function changeRootnodeOwner(address _newOwner) external onlyOwner {
933         getENSRegistry().setOwner(rootNode, _newOwner);
934         emit RootnodeOwnerChange(rootNode, _newOwner);
935     }
936 
937     /**
938      * @dev Lets the owner change the address of the ENS resolver contract.
939      * @param _ensResolver The address of the ENS resolver contract.
940      */
941     function changeENSResolver(address _ensResolver) external onlyOwner {
942         require(_ensResolver != address(0), "WF: address cannot be null");
943         ensResolver = _ensResolver;
944         emit ENSResolverChanged(_ensResolver);
945     }
946 
947     /** 
948     * @dev Lets the manager assign an ENS subdomain of the root node to a target address.
949     * Registers both the forward and reverse ENS.
950     * @param _label The subdomain label.
951     * @param _owner The owner of the subdomain.
952     */
953     function register(string _label, address _owner) external onlyManager {
954         bytes32 labelNode = keccak256(abi.encodePacked(_label));
955         bytes32 node = keccak256(abi.encodePacked(rootNode, labelNode));
956         address currentOwner = getENSRegistry().owner(node);
957         require(currentOwner == 0, "AEM: _label is alrealdy owned");
958 
959         // Forward ENS
960         getENSRegistry().setSubnodeOwner(rootNode, labelNode, address(this));
961         getENSRegistry().setResolver(node, ensResolver);
962         getENSRegistry().setOwner(node, _owner);
963         ENSResolver(ensResolver).setAddr(node, _owner);
964 
965         // Reverse ENS
966         strings.slice[] memory parts = new strings.slice[](2);
967         parts[0] = _label.toSlice();
968         parts[1] = rootName.toSlice();
969         string memory name = ".".toSlice().join(parts);
970         bytes32 reverseNode = getENSReverseRegistrar().node(_owner);
971         ENSResolver(ensResolver).setName(reverseNode, name);
972 
973         emit Registered(_owner, name);
974     }
975 
976     // *************** Public Functions ********************* //
977 
978     /**
979      * @dev Returns true is a given subnode is available.
980      * @param _subnode The target subnode.
981      * @return true if the subnode is available.
982      */
983     function isAvailable(bytes32 _subnode) public view returns (bool) {
984         bytes32 node = keccak256(abi.encodePacked(rootNode, _subnode));
985         address currentOwner = getENSRegistry().owner(node);
986         if(currentOwner == 0) {
987             return true;
988         }
989         return false;
990     }
991 }