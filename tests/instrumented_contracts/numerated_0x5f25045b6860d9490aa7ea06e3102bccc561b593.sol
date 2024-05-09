1 contract Satoshi {
2   using strings for *;
3   enum MoodState {happy, sad, angry, thinking, stoked}
4   string public whatSatoshiSays;
5   string public name;
6   MoodState public satoshiMood;
7   uint public currentPrice;
8   address public currentOwner;
9   address private devAddress;  
10   
11   
12   function Satoshi() public {
13     whatSatoshiSays = "My name is Satoshi Nakamoto, nice to meet you!";    
14     name = "Satoshi Nakamoto";
15     satoshiMood = MoodState.happy;
16     currentPrice = 1000000000000000; 
17     currentOwner = msg.sender;
18     devAddress = msg.sender;
19     
20   }
21   
22   function changeWhatSatoshiSays(string _whatSatoshiSays, MoodState _satoshiMood, string _name) payable public {
23     require(msg.value >= currentPrice && _name.toSlice().len() <= 25 && _whatSatoshiSays.toSlice().len() <= 180);
24     uint sentAmount = msg.value; 
25     uint devFee = (sentAmount * 1) / 100; // 1 % fee sent to devs
26     uint amountToSendToCurrentOwner = sentAmount - devFee;
27     devAddress.transfer(devFee); 
28     currentOwner.transfer(amountToSendToCurrentOwner); // Transfer the rest to the last owner
29     currentPrice = (currentPrice * 106) / 100; // 6 % increase in price every time
30     currentOwner = msg.sender;
31     whatSatoshiSays = _whatSatoshiSays;    
32     satoshiMood = _satoshiMood;
33     name = _name;
34     
35   }
36 
37   function fetchCurrentSatoshiState() public view returns (string, string, MoodState, address, uint) {
38     return (whatSatoshiSays, name, satoshiMood, currentOwner, currentPrice);
39   }  
40 }
41 
42 library strings {
43     struct slice {
44         uint _len;
45         uint _ptr;
46     }
47 
48     function memcpy(uint dest, uint src, uint len) private {
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
72     function toSlice(string self) internal returns (slice) {
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
85     function len(bytes32 self) internal returns (uint) {
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
113      *      null-termintaed utf-8 string.
114      * @param self The bytes32 value to convert to a slice.
115      * @return A new slice containing the value of the input argument up to the
116      *         first null.
117      */
118     function toSliceB32(bytes32 self) internal returns (slice ret) {
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
134     function copy(slice self) internal returns (slice) {
135         return slice(self._len, self._ptr);
136     }
137 
138     /*
139      * @dev Copies a slice to a new string.
140      * @param self The slice to copy.
141      * @return A newly allocated string containing the slice's text.
142      */
143     function toString(slice self) internal returns (string) {
144         var ret = new string(self._len);
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
160     function len(slice self) internal returns (uint l) {
161         // Starting at ptr-31 means the LSB will be the byte we care about
162         var ptr = self._ptr - 31;
163         var end = ptr + self._len;
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
188     function empty(slice self) internal returns (bool) {
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
201     function compare(slice self, slice other) internal returns (int) {
202         uint shortest = self._len;
203         if (other._len < self._len)
204             shortest = other._len;
205 
206         var selfptr = self._ptr;
207         var otherptr = other._ptr;
208         for (uint idx = 0; idx < shortest; idx += 32) {
209             uint a;
210             uint b;
211             assembly {
212                 a := mload(selfptr)
213                 b := mload(otherptr)
214             }
215             if (a != b) {
216                 // Mask out irrelevant bytes and check again
217                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
218                 var diff = (a & mask) - (b & mask);
219                 if (diff != 0)
220                     return int(diff);
221             }
222             selfptr += 32;
223             otherptr += 32;
224         }
225         return int(self._len) - int(other._len);
226     }
227 
228     /*
229      * @dev Returns true if the two slices contain the same text.
230      * @param self The first slice to compare.
231      * @param self The second slice to compare.
232      * @return True if the slices are equal, false otherwise.
233      */
234     function equals(slice self, slice other) internal returns (bool) {
235         return compare(self, other) == 0;
236     }
237 
238     /*
239      * @dev Extracts the first rune in the slice into `rune`, advancing the
240      *      slice to point to the next rune and returning `self`.
241      * @param self The slice to operate on.
242      * @param rune The slice that will contain the first rune.
243      * @return `rune`.
244      */
245     function nextRune(slice self, slice rune) internal returns (slice) {
246         rune._ptr = self._ptr;
247 
248         if (self._len == 0) {
249             rune._len = 0;
250             return rune;
251         }
252 
253         uint len;
254         uint b;
255         // Load the first byte of the rune into the LSBs of b
256         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
257         if (b < 0x80) {
258             len = 1;
259         } else if(b < 0xE0) {
260             len = 2;
261         } else if(b < 0xF0) {
262             len = 3;
263         } else {
264             len = 4;
265         }
266 
267         // Check for truncated codepoints
268         if (len > self._len) {
269             rune._len = self._len;
270             self._ptr += self._len;
271             self._len = 0;
272             return rune;
273         }
274 
275         self._ptr += len;
276         self._len -= len;
277         rune._len = len;
278         return rune;
279     }
280 
281     /*
282      * @dev Returns the first rune in the slice, advancing the slice to point
283      *      to the next rune.
284      * @param self The slice to operate on.
285      * @return A slice containing only the first rune from `self`.
286      */
287     function nextRune(slice self) internal returns (slice ret) {
288         nextRune(self, ret);
289     }
290 
291     /*
292      * @dev Returns the number of the first codepoint in the slice.
293      * @param self The slice to operate on.
294      * @return The number of the first codepoint in the slice.
295      */
296     function ord(slice self) internal returns (uint ret) {
297         if (self._len == 0) {
298             return 0;
299         }
300 
301         uint word;
302         uint length;
303         uint divisor = 2 ** 248;
304 
305         // Load the rune into the MSBs of b
306         assembly { word:= mload(mload(add(self, 32))) }
307         var b = word / divisor;
308         if (b < 0x80) {
309             ret = b;
310             length = 1;
311         } else if(b < 0xE0) {
312             ret = b & 0x1F;
313             length = 2;
314         } else if(b < 0xF0) {
315             ret = b & 0x0F;
316             length = 3;
317         } else {
318             ret = b & 0x07;
319             length = 4;
320         }
321 
322         // Check for truncated codepoints
323         if (length > self._len) {
324             return 0;
325         }
326 
327         for (uint i = 1; i < length; i++) {
328             divisor = divisor / 256;
329             b = (word / divisor) & 0xFF;
330             if (b & 0xC0 != 0x80) {
331                 // Invalid UTF-8 sequence
332                 return 0;
333             }
334             ret = (ret * 64) | (b & 0x3F);
335         }
336 
337         return ret;
338     }
339 
340     /*
341      * @dev Returns the keccak-256 hash of the slice.
342      * @param self The slice to hash.
343      * @return The hash of the slice.
344      */
345     function keccak(slice self) internal returns (bytes32 ret) {
346         assembly {
347             ret := keccak256(mload(add(self, 32)), mload(self))
348         }
349     }
350 
351     /*
352      * @dev Returns true if `self` starts with `needle`.
353      * @param self The slice to operate on.
354      * @param needle The slice to search for.
355      * @return True if the slice starts with the provided text, false otherwise.
356      */
357     function startsWith(slice self, slice needle) internal returns (bool) {
358         if (self._len < needle._len) {
359             return false;
360         }
361 
362         if (self._ptr == needle._ptr) {
363             return true;
364         }
365 
366         bool equal;
367         assembly {
368             let length := mload(needle)
369             let selfptr := mload(add(self, 0x20))
370             let needleptr := mload(add(needle, 0x20))
371             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
372         }
373         return equal;
374     }
375 
376     /*
377      * @dev If `self` starts with `needle`, `needle` is removed from the
378      *      beginning of `self`. Otherwise, `self` is unmodified.
379      * @param self The slice to operate on.
380      * @param needle The slice to search for.
381      * @return `self`
382      */
383     function beyond(slice self, slice needle) internal returns (slice) {
384         if (self._len < needle._len) {
385             return self;
386         }
387 
388         bool equal = true;
389         if (self._ptr != needle._ptr) {
390             assembly {
391                 let length := mload(needle)
392                 let selfptr := mload(add(self, 0x20))
393                 let needleptr := mload(add(needle, 0x20))
394                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
395             }
396         }
397 
398         if (equal) {
399             self._len -= needle._len;
400             self._ptr += needle._len;
401         }
402 
403         return self;
404     }
405 
406     /*
407      * @dev Returns true if the slice ends with `needle`.
408      * @param self The slice to operate on.
409      * @param needle The slice to search for.
410      * @return True if the slice starts with the provided text, false otherwise.
411      */
412     function endsWith(slice self, slice needle) internal returns (bool) {
413         if (self._len < needle._len) {
414             return false;
415         }
416 
417         var selfptr = self._ptr + self._len - needle._len;
418 
419         if (selfptr == needle._ptr) {
420             return true;
421         }
422 
423         bool equal;
424         assembly {
425             let length := mload(needle)
426             let needleptr := mload(add(needle, 0x20))
427             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
428         }
429 
430         return equal;
431     }
432 
433     /*
434      * @dev If `self` ends with `needle`, `needle` is removed from the
435      *      end of `self`. Otherwise, `self` is unmodified.
436      * @param self The slice to operate on.
437      * @param needle The slice to search for.
438      * @return `self`
439      */
440     function until(slice self, slice needle) internal returns (slice) {
441         if (self._len < needle._len) {
442             return self;
443         }
444 
445         var selfptr = self._ptr + self._len - needle._len;
446         bool equal = true;
447         if (selfptr != needle._ptr) {
448             assembly {
449                 let length := mload(needle)
450                 let needleptr := mload(add(needle, 0x20))
451                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
452             }
453         }
454 
455         if (equal) {
456             self._len -= needle._len;
457         }
458 
459         return self;
460     }
461 
462     // Returns the memory address of the first byte of the first occurrence of
463     // `needle` in `self`, or the first byte after `self` if not found.
464     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
465         uint ptr;
466         uint idx;
467 
468         if (needlelen <= selflen) {
469             if (needlelen <= 32) {
470                 // Optimized assembly for 68 gas per byte on short strings
471                 assembly {
472                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
473                     let needledata := and(mload(needleptr), mask)
474                     let end := add(selfptr, sub(selflen, needlelen))
475                     ptr := selfptr
476                     loop:
477                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
478                     ptr := add(ptr, 1)
479                     jumpi(loop, lt(sub(ptr, 1), end))
480                     ptr := add(selfptr, selflen)
481                     exit:
482                 }
483                 return ptr;
484             } else {
485                 // For long needles, use hashing
486                 bytes32 hash;
487                 assembly { hash := sha3(needleptr, needlelen) }
488                 ptr = selfptr;
489                 for (idx = 0; idx <= selflen - needlelen; idx++) {
490                     bytes32 testHash;
491                     assembly { testHash := sha3(ptr, needlelen) }
492                     if (hash == testHash)
493                         return ptr;
494                     ptr += 1;
495                 }
496             }
497         }
498         return selfptr + selflen;
499     }
500 
501     // Returns the memory address of the first byte after the last occurrence of
502     // `needle` in `self`, or the address of `self` if not found.
503     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
504         uint ptr;
505 
506         if (needlelen <= selflen) {
507             if (needlelen <= 32) {
508                 // Optimized assembly for 69 gas per byte on short strings
509                 assembly {
510                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
511                     let needledata := and(mload(needleptr), mask)
512                     ptr := add(selfptr, sub(selflen, needlelen))
513                     loop:
514                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
515                     ptr := sub(ptr, 1)
516                     jumpi(loop, gt(add(ptr, 1), selfptr))
517                     ptr := selfptr
518                     jump(exit)
519                     ret:
520                     ptr := add(ptr, needlelen)
521                     exit:
522                 }
523                 return ptr;
524             } else {
525                 // For long needles, use hashing
526                 bytes32 hash;
527                 assembly { hash := sha3(needleptr, needlelen) }
528                 ptr = selfptr + (selflen - needlelen);
529                 while (ptr >= selfptr) {
530                     bytes32 testHash;
531                     assembly { testHash := sha3(ptr, needlelen) }
532                     if (hash == testHash)
533                         return ptr + needlelen;
534                     ptr -= 1;
535                 }
536             }
537         }
538         return selfptr;
539     }
540 
541     /*
542      * @dev Modifies `self` to contain everything from the first occurrence of
543      *      `needle` to the end of the slice. `self` is set to the empty slice
544      *      if `needle` is not found.
545      * @param self The slice to search and modify.
546      * @param needle The text to search for.
547      * @return `self`.
548      */
549     function find(slice self, slice needle) internal returns (slice) {
550         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
551         self._len -= ptr - self._ptr;
552         self._ptr = ptr;
553         return self;
554     }
555 
556     /*
557      * @dev Modifies `self` to contain the part of the string from the start of
558      *      `self` to the end of the first occurrence of `needle`. If `needle`
559      *      is not found, `self` is set to the empty slice.
560      * @param self The slice to search and modify.
561      * @param needle The text to search for.
562      * @return `self`.
563      */
564     function rfind(slice self, slice needle) internal returns (slice) {
565         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
566         self._len = ptr - self._ptr;
567         return self;
568     }
569 
570     /*
571      * @dev Splits the slice, setting `self` to everything after the first
572      *      occurrence of `needle`, and `token` to everything before it. If
573      *      `needle` does not occur in `self`, `self` is set to the empty slice,
574      *      and `token` is set to the entirety of `self`.
575      * @param self The slice to split.
576      * @param needle The text to search for in `self`.
577      * @param token An output parameter to which the first token is written.
578      * @return `token`.
579      */
580     function split(slice self, slice needle, slice token) internal returns (slice) {
581         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
582         token._ptr = self._ptr;
583         token._len = ptr - self._ptr;
584         if (ptr == self._ptr + self._len) {
585             // Not found
586             self._len = 0;
587         } else {
588             self._len -= token._len + needle._len;
589             self._ptr = ptr + needle._len;
590         }
591         return token;
592     }
593 
594     /*
595      * @dev Splits the slice, setting `self` to everything after the first
596      *      occurrence of `needle`, and returning everything before it. If
597      *      `needle` does not occur in `self`, `self` is set to the empty slice,
598      *      and the entirety of `self` is returned.
599      * @param self The slice to split.
600      * @param needle The text to search for in `self`.
601      * @return The part of `self` up to the first occurrence of `delim`.
602      */
603     function split(slice self, slice needle) internal returns (slice token) {
604         split(self, needle, token);
605     }
606 
607     /*
608      * @dev Splits the slice, setting `self` to everything before the last
609      *      occurrence of `needle`, and `token` to everything after it. If
610      *      `needle` does not occur in `self`, `self` is set to the empty slice,
611      *      and `token` is set to the entirety of `self`.
612      * @param self The slice to split.
613      * @param needle The text to search for in `self`.
614      * @param token An output parameter to which the first token is written.
615      * @return `token`.
616      */
617     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
618         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
619         token._ptr = ptr;
620         token._len = self._len - (ptr - self._ptr);
621         if (ptr == self._ptr) {
622             // Not found
623             self._len = 0;
624         } else {
625             self._len -= token._len + needle._len;
626         }
627         return token;
628     }
629 
630     /*
631      * @dev Splits the slice, setting `self` to everything before the last
632      *      occurrence of `needle`, and returning everything after it. If
633      *      `needle` does not occur in `self`, `self` is set to the empty slice,
634      *      and the entirety of `self` is returned.
635      * @param self The slice to split.
636      * @param needle The text to search for in `self`.
637      * @return The part of `self` after the last occurrence of `delim`.
638      */
639     function rsplit(slice self, slice needle) internal returns (slice token) {
640         rsplit(self, needle, token);
641     }
642 
643     /*
644      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
645      * @param self The slice to search.
646      * @param needle The text to search for in `self`.
647      * @return The number of occurrences of `needle` found in `self`.
648      */
649     function count(slice self, slice needle) internal returns (uint cnt) {
650         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
651         while (ptr <= self._ptr + self._len) {
652             cnt++;
653             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
654         }
655     }
656 
657     /*
658      * @dev Returns True if `self` contains `needle`.
659      * @param self The slice to search.
660      * @param needle The text to search for in `self`.
661      * @return True if `needle` is found in `self`, false otherwise.
662      */
663     function contains(slice self, slice needle) internal returns (bool) {
664         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
665     }
666 
667     /*
668      * @dev Returns a newly allocated string containing the concatenation of
669      *      `self` and `other`.
670      * @param self The first slice to concatenate.
671      * @param other The second slice to concatenate.
672      * @return The concatenation of the two strings.
673      */
674     function concat(slice self, slice other) internal returns (string) {
675         var ret = new string(self._len + other._len);
676         uint retptr;
677         assembly { retptr := add(ret, 32) }
678         memcpy(retptr, self._ptr, self._len);
679         memcpy(retptr + self._len, other._ptr, other._len);
680         return ret;
681     }
682 
683     /*
684      * @dev Joins an array of slices, using `self` as a delimiter, returning a
685      *      newly allocated string.
686      * @param self The delimiter to use.
687      * @param parts A list of slices to join.
688      * @return A newly allocated string containing all the slices in `parts`,
689      *         joined with `self`.
690      */
691     function join(slice self, slice[] parts) internal returns (string) {
692         if (parts.length == 0)
693             return "";
694 
695         uint length = self._len * (parts.length - 1);
696         for(uint i = 0; i < parts.length; i++)
697             length += parts[i]._len;
698 
699         var ret = new string(length);
700         uint retptr;
701         assembly { retptr := add(ret, 32) }
702 
703         for(i = 0; i < parts.length; i++) {
704             memcpy(retptr, parts[i]._ptr, parts[i]._len);
705             retptr += parts[i]._len;
706             if (i < parts.length - 1) {
707                 memcpy(retptr, self._ptr, self._len);
708                 retptr += self._len;
709             }
710         }
711 
712         return ret;
713     }
714 }