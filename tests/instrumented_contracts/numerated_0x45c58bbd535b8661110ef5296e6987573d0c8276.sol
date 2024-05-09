1 /*
2  *      Welcome to the ?????????? Smart-Contract!
3  *      The ???? decentralized, charitable blockchain lottery!
4  *      
5  *      ##########################################
6  *      ##########################################
7  *      ###                                    ###
8  *      ###          ???? & ??? ?????          ###
9  *      ###                 at                 ###
10  *      ###          ??????????.???          ###
11  *      ###                                    ###
12  *      ##########################################
13  *      ##########################################
14  *
15  *      Etheraffle is designed to give ???? ?????? to 
16  *      players, sustainable ??? ????????? to ??? token 
17  *      holders, and ????-???????? ??????? to charities.
18  *
19  *      Learn more & get involved at ??????????.???/??? to become a
20  *      ??? token holder today! Holding ??? tokens automatically  
21  *      makes you a part of the decentralized, autonomous organisation  
22  *      that ???? Etheraffle. Take your place in this decentralized, 
23  *      altruistic vision of the future!
24  *
25  *      If you want to chat to us you have loads of options:
26  *      On ???????? @ ?????://?.??/??????????
27  *      Or on ??????? @ ?????://???????.???/??????????
28  *      Or on ?????? @ ?????://??????????.??????.???
29  *
30  */
31  
32 pragma solidity^0.4.21;
33 
34 /*
35  * @title String & slice utility library for Solidity contracts.
36  * @author Nick Johnson <arachnid@notdot.net>
37  *
38  * @dev Functionality in this library is largely implemented using an
39  *      abstraction called a 'slice'. A slice represents a part of a string -
40  *      anything from the entire string to a single character, or even no
41  *      characters at all (a 0-length slice). Since a slice only has to specify
42  *      an offset and a length, copying and manipulating slices is a lot less
43  *      expensive than copying and manipulating the strings they reference.
44  *
45  *      To further reduce gas costs, most functions on slice that need to return
46  *      a slice modify the original one instead of allocating a new one; for
47  *      instance, `s.split(".")` will return the text up to the first '.',
48  *      modifying s to only contain the remainder of the string after the '.'.
49  *      In situations where you do not want to modify the original slice, you
50  *      can make a copy first with `.copy()`, for example:
51  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
52  *      Solidity has no memory management, it will result in allocating many
53  *      short-lived slices that are later discarded.
54  *
55  *      Functions that return two slices come in two versions: a non-allocating
56  *      version that takes the second slice as an argument, modifying it in
57  *      place, and an allocating version that allocates and returns the second
58  *      slice; see `nextRune` for example.
59  *
60  *      Functions that have to copy string data will return strings rather than
61  *      slices; these can be cast back to slices for further processing if
62  *      required.
63  *
64  *      For convenience, some functions are provided with non-modifying
65  *      variants that create a new slice and return both; for instance,
66  *      `s.splitNew('.')` leaves s unmodified, and returns two values
67  *      corresponding to the left and right parts of the string.
68  */
69  
70 //pragma solidity ^0.4.14;
71 
72 library strings {
73     struct slice {
74         uint _len;
75         uint _ptr;
76     }
77 
78     function memcpy(uint dest, uint src, uint len) private {
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
102     function toSlice(string self) internal returns (slice) {
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
115     function len(bytes32 self) internal returns (uint) {
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
143      *      null-termintaed utf-8 string.
144      * @param self The bytes32 value to convert to a slice.
145      * @return A new slice containing the value of the input argument up to the
146      *         first null.
147      */
148     function toSliceB32(bytes32 self) internal returns (slice ret) {
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
164     function copy(slice self) internal returns (slice) {
165         return slice(self._len, self._ptr);
166     }
167 
168     /*
169      * @dev Copies a slice to a new string.
170      * @param self The slice to copy.
171      * @return A newly allocated string containing the slice's text.
172      */
173     function toString(slice self) internal returns (string) {
174         var ret = new string(self._len);
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
190     function len(slice self) internal returns (uint l) {
191         // Starting at ptr-31 means the LSB will be the byte we care about
192         var ptr = self._ptr - 31;
193         var end = ptr + self._len;
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
218     function empty(slice self) internal returns (bool) {
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
231     function compare(slice self, slice other) internal returns (int) {
232         uint shortest = self._len;
233         if (other._len < self._len)
234             shortest = other._len;
235 
236         var selfptr = self._ptr;
237         var otherptr = other._ptr;
238         for (uint idx = 0; idx < shortest; idx += 32) {
239             uint a;
240             uint b;
241             assembly {
242                 a := mload(selfptr)
243                 b := mload(otherptr)
244             }
245             if (a != b) {
246                 // Mask out irrelevant bytes and check again
247                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
248                 var diff = (a & mask) - (b & mask);
249                 if (diff != 0)
250                     return int(diff);
251             }
252             selfptr += 32;
253             otherptr += 32;
254         }
255         return int(self._len) - int(other._len);
256     }
257 
258     /*
259      * @dev Returns true if the two slices contain the same text.
260      * @param self The first slice to compare.
261      * @param self The second slice to compare.
262      * @return True if the slices are equal, false otherwise.
263      */
264     function equals(slice self, slice other) internal returns (bool) {
265         return compare(self, other) == 0;
266     }
267 
268     /*
269      * @dev Extracts the first rune in the slice into `rune`, advancing the
270      *      slice to point to the next rune and returning `self`.
271      * @param self The slice to operate on.
272      * @param rune The slice that will contain the first rune.
273      * @return `rune`.
274      */
275     function nextRune(slice self, slice rune) internal returns (slice) {
276         rune._ptr = self._ptr;
277 
278         if (self._len == 0) {
279             rune._len = 0;
280             return rune;
281         }
282 
283         uint len;
284         uint b;
285         // Load the first byte of the rune into the LSBs of b
286         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
287         if (b < 0x80) {
288             len = 1;
289         } else if(b < 0xE0) {
290             len = 2;
291         } else if(b < 0xF0) {
292             len = 3;
293         } else {
294             len = 4;
295         }
296 
297         // Check for truncated codepoints
298         if (len > self._len) {
299             rune._len = self._len;
300             self._ptr += self._len;
301             self._len = 0;
302             return rune;
303         }
304 
305         self._ptr += len;
306         self._len -= len;
307         rune._len = len;
308         return rune;
309     }
310 
311     /*
312      * @dev Returns the first rune in the slice, advancing the slice to point
313      *      to the next rune.
314      * @param self The slice to operate on.
315      * @return A slice containing only the first rune from `self`.
316      */
317     function nextRune(slice self) internal returns (slice ret) {
318         nextRune(self, ret);
319     }
320 
321     /*
322      * @dev Returns the number of the first codepoint in the slice.
323      * @param self The slice to operate on.
324      * @return The number of the first codepoint in the slice.
325      */
326     function ord(slice self) internal returns (uint ret) {
327         if (self._len == 0) {
328             return 0;
329         }
330 
331         uint word;
332         uint length;
333         uint divisor = 2 ** 248;
334 
335         // Load the rune into the MSBs of b
336         assembly { word:= mload(mload(add(self, 32))) }
337         var b = word / divisor;
338         if (b < 0x80) {
339             ret = b;
340             length = 1;
341         } else if(b < 0xE0) {
342             ret = b & 0x1F;
343             length = 2;
344         } else if(b < 0xF0) {
345             ret = b & 0x0F;
346             length = 3;
347         } else {
348             ret = b & 0x07;
349             length = 4;
350         }
351 
352         // Check for truncated codepoints
353         if (length > self._len) {
354             return 0;
355         }
356 
357         for (uint i = 1; i < length; i++) {
358             divisor = divisor / 256;
359             b = (word / divisor) & 0xFF;
360             if (b & 0xC0 != 0x80) {
361                 // Invalid UTF-8 sequence
362                 return 0;
363             }
364             ret = (ret * 64) | (b & 0x3F);
365         }
366 
367         return ret;
368     }
369 
370     /*
371      * @dev Returns the keccak-256 hash of the slice.
372      * @param self The slice to hash.
373      * @return The hash of the slice.
374      */
375     function keccak(slice self) internal returns (bytes32 ret) {
376         assembly {
377             ret := keccak256(mload(add(self, 32)), mload(self))
378         }
379     }
380 
381     /*
382      * @dev Returns true if `self` starts with `needle`.
383      * @param self The slice to operate on.
384      * @param needle The slice to search for.
385      * @return True if the slice starts with the provided text, false otherwise.
386      */
387     function startsWith(slice self, slice needle) internal returns (bool) {
388         if (self._len < needle._len) {
389             return false;
390         }
391 
392         if (self._ptr == needle._ptr) {
393             return true;
394         }
395 
396         bool equal;
397         assembly {
398             let length := mload(needle)
399             let selfptr := mload(add(self, 0x20))
400             let needleptr := mload(add(needle, 0x20))
401             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
402         }
403         return equal;
404     }
405 
406     /*
407      * @dev If `self` starts with `needle`, `needle` is removed from the
408      *      beginning of `self`. Otherwise, `self` is unmodified.
409      * @param self The slice to operate on.
410      * @param needle The slice to search for.
411      * @return `self`
412      */
413     function beyond(slice self, slice needle) internal returns (slice) {
414         if (self._len < needle._len) {
415             return self;
416         }
417 
418         bool equal = true;
419         if (self._ptr != needle._ptr) {
420             assembly {
421                 let length := mload(needle)
422                 let selfptr := mload(add(self, 0x20))
423                 let needleptr := mload(add(needle, 0x20))
424                 equal := eq(sha3(selfptr, length), sha3(needleptr, length))
425             }
426         }
427 
428         if (equal) {
429             self._len -= needle._len;
430             self._ptr += needle._len;
431         }
432 
433         return self;
434     }
435 
436     /*
437      * @dev Returns true if the slice ends with `needle`.
438      * @param self The slice to operate on.
439      * @param needle The slice to search for.
440      * @return True if the slice starts with the provided text, false otherwise.
441      */
442     function endsWith(slice self, slice needle) internal returns (bool) {
443         if (self._len < needle._len) {
444             return false;
445         }
446 
447         var selfptr = self._ptr + self._len - needle._len;
448 
449         if (selfptr == needle._ptr) {
450             return true;
451         }
452 
453         bool equal;
454         assembly {
455             let length := mload(needle)
456             let needleptr := mload(add(needle, 0x20))
457             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
458         }
459 
460         return equal;
461     }
462 
463     /*
464      * @dev If `self` ends with `needle`, `needle` is removed from the
465      *      end of `self`. Otherwise, `self` is unmodified.
466      * @param self The slice to operate on.
467      * @param needle The slice to search for.
468      * @return `self`
469      */
470     function until(slice self, slice needle) internal returns (slice) {
471         if (self._len < needle._len) {
472             return self;
473         }
474 
475         var selfptr = self._ptr + self._len - needle._len;
476         bool equal = true;
477         if (selfptr != needle._ptr) {
478             assembly {
479                 let length := mload(needle)
480                 let needleptr := mload(add(needle, 0x20))
481                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
482             }
483         }
484 
485         if (equal) {
486             self._len -= needle._len;
487         }
488 
489         return self;
490     }
491 
492     // Returns the memory address of the first byte of the first occurrence of
493     // `needle` in `self`, or the first byte after `self` if not found.
494     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
495         uint ptr;
496         uint idx;
497 
498         if (needlelen <= selflen) {
499             if (needlelen <= 32) {
500                 // Optimized assembly for 68 gas per byte on short strings
501                 assembly {
502                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
503                     let needledata := and(mload(needleptr), mask)
504                     let end := add(selfptr, sub(selflen, needlelen))
505                     ptr := selfptr
506                     loop:
507                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
508                     ptr := add(ptr, 1)
509                     jumpi(loop, lt(sub(ptr, 1), end))
510                     ptr := add(selfptr, selflen)
511                     exit:
512                 }
513                 return ptr;
514             } else {
515                 // For long needles, use hashing
516                 bytes32 hash;
517                 assembly { hash := sha3(needleptr, needlelen) }
518                 ptr = selfptr;
519                 for (idx = 0; idx <= selflen - needlelen; idx++) {
520                     bytes32 testHash;
521                     assembly { testHash := sha3(ptr, needlelen) }
522                     if (hash == testHash)
523                         return ptr;
524                     ptr += 1;
525                 }
526             }
527         }
528         return selfptr + selflen;
529     }
530 
531     // Returns the memory address of the first byte after the last occurrence of
532     // `needle` in `self`, or the address of `self` if not found.
533     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
534         uint ptr;
535 
536         if (needlelen <= selflen) {
537             if (needlelen <= 32) {
538                 // Optimized assembly for 69 gas per byte on short strings
539                 assembly {
540                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
541                     let needledata := and(mload(needleptr), mask)
542                     ptr := add(selfptr, sub(selflen, needlelen))
543                     loop:
544                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
545                     ptr := sub(ptr, 1)
546                     jumpi(loop, gt(add(ptr, 1), selfptr))
547                     ptr := selfptr
548                     jump(exit)
549                     ret:
550                     ptr := add(ptr, needlelen)
551                     exit:
552                 }
553                 return ptr;
554             } else {
555                 // For long needles, use hashing
556                 bytes32 hash;
557                 assembly { hash := sha3(needleptr, needlelen) }
558                 ptr = selfptr + (selflen - needlelen);
559                 while (ptr >= selfptr) {
560                     bytes32 testHash;
561                     assembly { testHash := sha3(ptr, needlelen) }
562                     if (hash == testHash)
563                         return ptr + needlelen;
564                     ptr -= 1;
565                 }
566             }
567         }
568         return selfptr;
569     }
570 
571     /*
572      * @dev Modifies `self` to contain everything from the first occurrence of
573      *      `needle` to the end of the slice. `self` is set to the empty slice
574      *      if `needle` is not found.
575      * @param self The slice to search and modify.
576      * @param needle The text to search for.
577      * @return `self`.
578      */
579     function find(slice self, slice needle) internal returns (slice) {
580         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
581         self._len -= ptr - self._ptr;
582         self._ptr = ptr;
583         return self;
584     }
585 
586     /*
587      * @dev Modifies `self` to contain the part of the string from the start of
588      *      `self` to the end of the first occurrence of `needle`. If `needle`
589      *      is not found, `self` is set to the empty slice.
590      * @param self The slice to search and modify.
591      * @param needle The text to search for.
592      * @return `self`.
593      */
594     function rfind(slice self, slice needle) internal returns (slice) {
595         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
596         self._len = ptr - self._ptr;
597         return self;
598     }
599 
600     /*
601      * @dev Splits the slice, setting `self` to everything after the first
602      *      occurrence of `needle`, and `token` to everything before it. If
603      *      `needle` does not occur in `self`, `self` is set to the empty slice,
604      *      and `token` is set to the entirety of `self`.
605      * @param self The slice to split.
606      * @param needle The text to search for in `self`.
607      * @param token An output parameter to which the first token is written.
608      * @return `token`.
609      */
610     function split(slice self, slice needle, slice token) internal returns (slice) {
611         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
612         token._ptr = self._ptr;
613         token._len = ptr - self._ptr;
614         if (ptr == self._ptr + self._len) {
615             // Not found
616             self._len = 0;
617         } else {
618             self._len -= token._len + needle._len;
619             self._ptr = ptr + needle._len;
620         }
621         return token;
622     }
623 
624     /*
625      * @dev Splits the slice, setting `self` to everything after the first
626      *      occurrence of `needle`, and returning everything before it. If
627      *      `needle` does not occur in `self`, `self` is set to the empty slice,
628      *      and the entirety of `self` is returned.
629      * @param self The slice to split.
630      * @param needle The text to search for in `self`.
631      * @return The part of `self` up to the first occurrence of `delim`.
632      */
633     function split(slice self, slice needle) internal returns (slice token) {
634         split(self, needle, token);
635     }
636 
637     /*
638      * @dev Splits the slice, setting `self` to everything before the last
639      *      occurrence of `needle`, and `token` to everything after it. If
640      *      `needle` does not occur in `self`, `self` is set to the empty slice,
641      *      and `token` is set to the entirety of `self`.
642      * @param self The slice to split.
643      * @param needle The text to search for in `self`.
644      * @param token An output parameter to which the first token is written.
645      * @return `token`.
646      */
647     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
648         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
649         token._ptr = ptr;
650         token._len = self._len - (ptr - self._ptr);
651         if (ptr == self._ptr) {
652             // Not found
653             self._len = 0;
654         } else {
655             self._len -= token._len + needle._len;
656         }
657         return token;
658     }
659 
660     /*
661      * @dev Splits the slice, setting `self` to everything before the last
662      *      occurrence of `needle`, and returning everything after it. If
663      *      `needle` does not occur in `self`, `self` is set to the empty slice,
664      *      and the entirety of `self` is returned.
665      * @param self The slice to split.
666      * @param needle The text to search for in `self`.
667      * @return The part of `self` after the last occurrence of `delim`.
668      */
669     function rsplit(slice self, slice needle) internal returns (slice token) {
670         rsplit(self, needle, token);
671     }
672 
673     /*
674      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
675      * @param self The slice to search.
676      * @param needle The text to search for in `self`.
677      * @return The number of occurrences of `needle` found in `self`.
678      */
679     function count(slice self, slice needle) internal returns (uint cnt) {
680         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
681         while (ptr <= self._ptr + self._len) {
682             cnt++;
683             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
684         }
685     }
686 
687     /*
688      * @dev Returns True if `self` contains `needle`.
689      * @param self The slice to search.
690      * @param needle The text to search for in `self`.
691      * @return True if `needle` is found in `self`, false otherwise.
692      */
693     function contains(slice self, slice needle) internal returns (bool) {
694         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
695     }
696 
697     /*
698      * @dev Returns a newly allocated string containing the concatenation of
699      *      `self` and `other`.
700      * @param self The first slice to concatenate.
701      * @param other The second slice to concatenate.
702      * @return The concatenation of the two strings.
703      */
704     function concat(slice self, slice other) internal returns (string) {
705         var ret = new string(self._len + other._len);
706         uint retptr;
707         assembly { retptr := add(ret, 32) }
708         memcpy(retptr, self._ptr, self._len);
709         memcpy(retptr + self._len, other._ptr, other._len);
710         return ret;
711     }
712 
713     /*
714      * @dev Joins an array of slices, using `self` as a delimiter, returning a
715      *      newly allocated string.
716      * @param self The delimiter to use.
717      * @param parts A list of slices to join.
718      * @return A newly allocated string containing all the slices in `parts`,
719      *         joined with `self`.
720      */
721     function join(slice self, slice[] parts) internal returns (string) {
722         if (parts.length == 0)
723             return "";
724 
725         uint length = self._len * (parts.length - 1);
726         for(uint i = 0; i < parts.length; i++)
727             length += parts[i]._len;
728 
729         var ret = new string(length);
730         uint retptr;
731         assembly { retptr := add(ret, 32) }
732 
733         for(i = 0; i < parts.length; i++) {
734             memcpy(retptr, parts[i]._ptr, parts[i]._len);
735             retptr += parts[i]._len;
736             if (i < parts.length - 1) {
737                 memcpy(retptr, self._ptr, self._len);
738                 retptr += self._len;
739             }
740         }
741 
742         return ret;
743     }
744 }
745 // <ORACLIZE_API>
746 /*
747 Copyright (c) 2015-2016 Oraclize SRL
748 Copyright (c) 2016 Oraclize LTD
749 
750 
751 
752 Permission is hereby granted, free of charge, to any person obtaining a copy
753 of this software and associated documentation files (the "Software"), to deal
754 in the Software without restriction, including without limitation the rights
755 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
756 copies of the Software, and to permit persons to whom the Software is
757 furnished to do so, subject to the following conditions:
758 
759 
760 
761 The above copyright notice and this permission notice shall be included in
762 all copies or substantial portions of the Software.
763 
764 
765 
766 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
767 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
768 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
769 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
770 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
771 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
772 THE SOFTWARE.
773 */
774 
775 //pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
776 
777 contract OraclizeI {
778     address public cbAddress;
779     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
780     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
781     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
782     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
783     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
784     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
785     function getPrice(string _datasource) returns (uint _dsprice);
786     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
787     function useCoupon(string _coupon);
788     function setProofType(byte _proofType);
789     function setConfig(bytes32 _config);
790     function setCustomGasPrice(uint _gasPrice);
791     function randomDS_getSessionPubKeyHash() returns(bytes32);
792 }
793 contract OraclizeAddrResolverI {
794     function getAddress() returns (address _addr);
795 }
796 contract usingOraclize {
797     uint constant day = 60*60*24;
798     uint constant week = 60*60*24*7;
799     uint constant month = 60*60*24*30;
800     byte constant proofType_NONE = 0x00;
801     byte constant proofType_TLSNotary = 0x10;
802     byte constant proofType_Android = 0x20;
803     byte constant proofType_Ledger = 0x30;
804     byte constant proofType_Native = 0xF0;
805     byte constant proofStorage_IPFS = 0x01;
806     uint8 constant networkID_auto = 0;
807     uint8 constant networkID_mainnet = 1;
808     uint8 constant networkID_testnet = 2;
809     uint8 constant networkID_morden = 2;
810     uint8 constant networkID_consensys = 161;
811 
812     OraclizeAddrResolverI OAR;
813 
814     OraclizeI oraclize;
815     modifier oraclizeAPI {
816         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
817             oraclize_setNetwork(networkID_auto);
818 
819         if(address(oraclize) != OAR.getAddress())
820             oraclize = OraclizeI(OAR.getAddress());
821 
822         _;
823     }
824     modifier coupon(string code){
825         oraclize = OraclizeI(OAR.getAddress());
826         oraclize.useCoupon(code);
827         _;
828     }
829 
830     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
831         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
832             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
833             oraclize_setNetworkName("eth_mainnet");
834             return true;
835         }
836         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
837             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
838             oraclize_setNetworkName("eth_ropsten3");
839             return true;
840         }
841         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
842             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
843             oraclize_setNetworkName("eth_kovan");
844             return true;
845         }
846         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
847             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
848             oraclize_setNetworkName("eth_rinkeby");
849             return true;
850         }
851         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
852             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
853             return true;
854         }
855         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
856             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
857             return true;
858         }
859         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
860             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
861             return true;
862         }
863         return false;
864     }
865 
866     function __callback(bytes32 myid, string result) {
867         __callback(myid, result, new bytes(0));
868     }
869     function __callback(bytes32 myid, string result, bytes proof) {
870     }
871 
872     function oraclize_useCoupon(string code) oraclizeAPI internal {
873         oraclize.useCoupon(code);
874     }
875 
876     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
877         return oraclize.getPrice(datasource);
878     }
879 
880     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
881         return oraclize.getPrice(datasource, gaslimit);
882     }
883 
884     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
885         uint price = oraclize.getPrice(datasource);
886         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
887         return oraclize.query.value(price)(0, datasource, arg);
888     }
889     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
890         uint price = oraclize.getPrice(datasource);
891         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
892         return oraclize.query.value(price)(timestamp, datasource, arg);
893     }
894     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
895         uint price = oraclize.getPrice(datasource, gaslimit);
896         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
897         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
898     }
899     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
900         uint price = oraclize.getPrice(datasource, gaslimit);
901         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
902         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
903     }
904     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
905         uint price = oraclize.getPrice(datasource);
906         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
907         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
908     }
909     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
910         uint price = oraclize.getPrice(datasource);
911         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
912         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
913     }
914     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
915         uint price = oraclize.getPrice(datasource, gaslimit);
916         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
917         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
918     }
919     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
920         uint price = oraclize.getPrice(datasource, gaslimit);
921         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
922         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
923     }
924     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
925         uint price = oraclize.getPrice(datasource);
926         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
927         bytes memory args = stra2cbor(argN);
928         return oraclize.queryN.value(price)(0, datasource, args);
929     }
930     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
931         uint price = oraclize.getPrice(datasource);
932         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
933         bytes memory args = stra2cbor(argN);
934         return oraclize.queryN.value(price)(timestamp, datasource, args);
935     }
936     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
937         uint price = oraclize.getPrice(datasource, gaslimit);
938         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
939         bytes memory args = stra2cbor(argN);
940         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
941     }
942     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
943         uint price = oraclize.getPrice(datasource, gaslimit);
944         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
945         bytes memory args = stra2cbor(argN);
946         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
947     }
948     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
949         string[] memory dynargs = new string[](1);
950         dynargs[0] = args[0];
951         return oraclize_query(datasource, dynargs);
952     }
953     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
954         string[] memory dynargs = new string[](1);
955         dynargs[0] = args[0];
956         return oraclize_query(timestamp, datasource, dynargs);
957     }
958     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
959         string[] memory dynargs = new string[](1);
960         dynargs[0] = args[0];
961         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
962     }
963     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
964         string[] memory dynargs = new string[](1);
965         dynargs[0] = args[0];
966         return oraclize_query(datasource, dynargs, gaslimit);
967     }
968 
969     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
970         string[] memory dynargs = new string[](2);
971         dynargs[0] = args[0];
972         dynargs[1] = args[1];
973         return oraclize_query(datasource, dynargs);
974     }
975     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
976         string[] memory dynargs = new string[](2);
977         dynargs[0] = args[0];
978         dynargs[1] = args[1];
979         return oraclize_query(timestamp, datasource, dynargs);
980     }
981     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
982         string[] memory dynargs = new string[](2);
983         dynargs[0] = args[0];
984         dynargs[1] = args[1];
985         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
986     }
987     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
988         string[] memory dynargs = new string[](2);
989         dynargs[0] = args[0];
990         dynargs[1] = args[1];
991         return oraclize_query(datasource, dynargs, gaslimit);
992     }
993     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
994         string[] memory dynargs = new string[](3);
995         dynargs[0] = args[0];
996         dynargs[1] = args[1];
997         dynargs[2] = args[2];
998         return oraclize_query(datasource, dynargs);
999     }
1000     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1001         string[] memory dynargs = new string[](3);
1002         dynargs[0] = args[0];
1003         dynargs[1] = args[1];
1004         dynargs[2] = args[2];
1005         return oraclize_query(timestamp, datasource, dynargs);
1006     }
1007     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1008         string[] memory dynargs = new string[](3);
1009         dynargs[0] = args[0];
1010         dynargs[1] = args[1];
1011         dynargs[2] = args[2];
1012         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1013     }
1014     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](3);
1016         dynargs[0] = args[0];
1017         dynargs[1] = args[1];
1018         dynargs[2] = args[2];
1019         return oraclize_query(datasource, dynargs, gaslimit);
1020     }
1021 
1022     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1023         string[] memory dynargs = new string[](4);
1024         dynargs[0] = args[0];
1025         dynargs[1] = args[1];
1026         dynargs[2] = args[2];
1027         dynargs[3] = args[3];
1028         return oraclize_query(datasource, dynargs);
1029     }
1030     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1031         string[] memory dynargs = new string[](4);
1032         dynargs[0] = args[0];
1033         dynargs[1] = args[1];
1034         dynargs[2] = args[2];
1035         dynargs[3] = args[3];
1036         return oraclize_query(timestamp, datasource, dynargs);
1037     }
1038     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1039         string[] memory dynargs = new string[](4);
1040         dynargs[0] = args[0];
1041         dynargs[1] = args[1];
1042         dynargs[2] = args[2];
1043         dynargs[3] = args[3];
1044         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1045     }
1046     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1047         string[] memory dynargs = new string[](4);
1048         dynargs[0] = args[0];
1049         dynargs[1] = args[1];
1050         dynargs[2] = args[2];
1051         dynargs[3] = args[3];
1052         return oraclize_query(datasource, dynargs, gaslimit);
1053     }
1054     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1055         string[] memory dynargs = new string[](5);
1056         dynargs[0] = args[0];
1057         dynargs[1] = args[1];
1058         dynargs[2] = args[2];
1059         dynargs[3] = args[3];
1060         dynargs[4] = args[4];
1061         return oraclize_query(datasource, dynargs);
1062     }
1063     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1064         string[] memory dynargs = new string[](5);
1065         dynargs[0] = args[0];
1066         dynargs[1] = args[1];
1067         dynargs[2] = args[2];
1068         dynargs[3] = args[3];
1069         dynargs[4] = args[4];
1070         return oraclize_query(timestamp, datasource, dynargs);
1071     }
1072     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1073         string[] memory dynargs = new string[](5);
1074         dynargs[0] = args[0];
1075         dynargs[1] = args[1];
1076         dynargs[2] = args[2];
1077         dynargs[3] = args[3];
1078         dynargs[4] = args[4];
1079         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1080     }
1081     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1082         string[] memory dynargs = new string[](5);
1083         dynargs[0] = args[0];
1084         dynargs[1] = args[1];
1085         dynargs[2] = args[2];
1086         dynargs[3] = args[3];
1087         dynargs[4] = args[4];
1088         return oraclize_query(datasource, dynargs, gaslimit);
1089     }
1090     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1091         uint price = oraclize.getPrice(datasource);
1092         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1093         bytes memory args = ba2cbor(argN);
1094         return oraclize.queryN.value(price)(0, datasource, args);
1095     }
1096     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1097         uint price = oraclize.getPrice(datasource);
1098         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1099         bytes memory args = ba2cbor(argN);
1100         return oraclize.queryN.value(price)(timestamp, datasource, args);
1101     }
1102     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1103         uint price = oraclize.getPrice(datasource, gaslimit);
1104         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1105         bytes memory args = ba2cbor(argN);
1106         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1107     }
1108     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1109         uint price = oraclize.getPrice(datasource, gaslimit);
1110         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1111         bytes memory args = ba2cbor(argN);
1112         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1113     }
1114     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1115         bytes[] memory dynargs = new bytes[](1);
1116         dynargs[0] = args[0];
1117         return oraclize_query(datasource, dynargs);
1118     }
1119     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1120         bytes[] memory dynargs = new bytes[](1);
1121         dynargs[0] = args[0];
1122         return oraclize_query(timestamp, datasource, dynargs);
1123     }
1124     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1125         bytes[] memory dynargs = new bytes[](1);
1126         dynargs[0] = args[0];
1127         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1128     }
1129     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1130         bytes[] memory dynargs = new bytes[](1);
1131         dynargs[0] = args[0];
1132         return oraclize_query(datasource, dynargs, gaslimit);
1133     }
1134 
1135     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1136         bytes[] memory dynargs = new bytes[](2);
1137         dynargs[0] = args[0];
1138         dynargs[1] = args[1];
1139         return oraclize_query(datasource, dynargs);
1140     }
1141     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1142         bytes[] memory dynargs = new bytes[](2);
1143         dynargs[0] = args[0];
1144         dynargs[1] = args[1];
1145         return oraclize_query(timestamp, datasource, dynargs);
1146     }
1147     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1148         bytes[] memory dynargs = new bytes[](2);
1149         dynargs[0] = args[0];
1150         dynargs[1] = args[1];
1151         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1152     }
1153     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1154         bytes[] memory dynargs = new bytes[](2);
1155         dynargs[0] = args[0];
1156         dynargs[1] = args[1];
1157         return oraclize_query(datasource, dynargs, gaslimit);
1158     }
1159     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1160         bytes[] memory dynargs = new bytes[](3);
1161         dynargs[0] = args[0];
1162         dynargs[1] = args[1];
1163         dynargs[2] = args[2];
1164         return oraclize_query(datasource, dynargs);
1165     }
1166     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1167         bytes[] memory dynargs = new bytes[](3);
1168         dynargs[0] = args[0];
1169         dynargs[1] = args[1];
1170         dynargs[2] = args[2];
1171         return oraclize_query(timestamp, datasource, dynargs);
1172     }
1173     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1174         bytes[] memory dynargs = new bytes[](3);
1175         dynargs[0] = args[0];
1176         dynargs[1] = args[1];
1177         dynargs[2] = args[2];
1178         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1179     }
1180     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](3);
1182         dynargs[0] = args[0];
1183         dynargs[1] = args[1];
1184         dynargs[2] = args[2];
1185         return oraclize_query(datasource, dynargs, gaslimit);
1186     }
1187 
1188     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1189         bytes[] memory dynargs = new bytes[](4);
1190         dynargs[0] = args[0];
1191         dynargs[1] = args[1];
1192         dynargs[2] = args[2];
1193         dynargs[3] = args[3];
1194         return oraclize_query(datasource, dynargs);
1195     }
1196     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1197         bytes[] memory dynargs = new bytes[](4);
1198         dynargs[0] = args[0];
1199         dynargs[1] = args[1];
1200         dynargs[2] = args[2];
1201         dynargs[3] = args[3];
1202         return oraclize_query(timestamp, datasource, dynargs);
1203     }
1204     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1205         bytes[] memory dynargs = new bytes[](4);
1206         dynargs[0] = args[0];
1207         dynargs[1] = args[1];
1208         dynargs[2] = args[2];
1209         dynargs[3] = args[3];
1210         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1211     }
1212     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1213         bytes[] memory dynargs = new bytes[](4);
1214         dynargs[0] = args[0];
1215         dynargs[1] = args[1];
1216         dynargs[2] = args[2];
1217         dynargs[3] = args[3];
1218         return oraclize_query(datasource, dynargs, gaslimit);
1219     }
1220     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1221         bytes[] memory dynargs = new bytes[](5);
1222         dynargs[0] = args[0];
1223         dynargs[1] = args[1];
1224         dynargs[2] = args[2];
1225         dynargs[3] = args[3];
1226         dynargs[4] = args[4];
1227         return oraclize_query(datasource, dynargs);
1228     }
1229     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1230         bytes[] memory dynargs = new bytes[](5);
1231         dynargs[0] = args[0];
1232         dynargs[1] = args[1];
1233         dynargs[2] = args[2];
1234         dynargs[3] = args[3];
1235         dynargs[4] = args[4];
1236         return oraclize_query(timestamp, datasource, dynargs);
1237     }
1238     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1239         bytes[] memory dynargs = new bytes[](5);
1240         dynargs[0] = args[0];
1241         dynargs[1] = args[1];
1242         dynargs[2] = args[2];
1243         dynargs[3] = args[3];
1244         dynargs[4] = args[4];
1245         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1246     }
1247     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1248         bytes[] memory dynargs = new bytes[](5);
1249         dynargs[0] = args[0];
1250         dynargs[1] = args[1];
1251         dynargs[2] = args[2];
1252         dynargs[3] = args[3];
1253         dynargs[4] = args[4];
1254         return oraclize_query(datasource, dynargs, gaslimit);
1255     }
1256 
1257     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1258         return oraclize.cbAddress();
1259     }
1260     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1261         return oraclize.setProofType(proofP);
1262     }
1263     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1264         return oraclize.setCustomGasPrice(gasPrice);
1265     }
1266     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1267         return oraclize.setConfig(config);
1268     }
1269 
1270     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1271         return oraclize.randomDS_getSessionPubKeyHash();
1272     }
1273 
1274     function getCodeSize(address _addr) constant internal returns(uint _size) {
1275         assembly {
1276             _size := extcodesize(_addr)
1277         }
1278     }
1279 
1280     function parseAddr(string _a) internal returns (address){
1281         bytes memory tmp = bytes(_a);
1282         uint160 iaddr = 0;
1283         uint160 b1;
1284         uint160 b2;
1285         for (uint i=2; i<2+2*20; i+=2){
1286             iaddr *= 256;
1287             b1 = uint160(tmp[i]);
1288             b2 = uint160(tmp[i+1]);
1289             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1290             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1291             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1292             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1293             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1294             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1295             iaddr += (b1*16+b2);
1296         }
1297         return address(iaddr);
1298     }
1299 
1300     function strCompare(string _a, string _b) internal returns (int) {
1301         bytes memory a = bytes(_a);
1302         bytes memory b = bytes(_b);
1303         uint minLength = a.length;
1304         if (b.length < minLength) minLength = b.length;
1305         for (uint i = 0; i < minLength; i ++)
1306             if (a[i] < b[i])
1307                 return -1;
1308             else if (a[i] > b[i])
1309                 return 1;
1310         if (a.length < b.length)
1311             return -1;
1312         else if (a.length > b.length)
1313             return 1;
1314         else
1315             return 0;
1316     }
1317 
1318     function indexOf(string _haystack, string _needle) internal returns (int) {
1319         bytes memory h = bytes(_haystack);
1320         bytes memory n = bytes(_needle);
1321         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1322             return -1;
1323         else if(h.length > (2**128 -1))
1324             return -1;
1325         else
1326         {
1327             uint subindex = 0;
1328             for (uint i = 0; i < h.length; i ++)
1329             {
1330                 if (h[i] == n[0])
1331                 {
1332                     subindex = 1;
1333                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1334                     {
1335                         subindex++;
1336                     }
1337                     if(subindex == n.length)
1338                         return int(i);
1339                 }
1340             }
1341             return -1;
1342         }
1343     }
1344 
1345     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1346         bytes memory _ba = bytes(_a);
1347         bytes memory _bb = bytes(_b);
1348         bytes memory _bc = bytes(_c);
1349         bytes memory _bd = bytes(_d);
1350         bytes memory _be = bytes(_e);
1351         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1352         bytes memory babcde = bytes(abcde);
1353         uint k = 0;
1354         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1355         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1356         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1357         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1358         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1359         return string(babcde);
1360     }
1361 
1362     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1363         return strConcat(_a, _b, _c, _d, "");
1364     }
1365 
1366     function strConcat(string _a, string _b, string _c) internal returns (string) {
1367         return strConcat(_a, _b, _c, "", "");
1368     }
1369 
1370     function strConcat(string _a, string _b) internal returns (string) {
1371         return strConcat(_a, _b, "", "", "");
1372     }
1373 
1374     // parseInt
1375     function parseInt(string _a) internal returns (uint) {
1376         return parseInt(_a, 0);
1377     }
1378 
1379     // parseInt(parseFloat*10^_b)
1380     function parseInt(string _a, uint _b) internal returns (uint) {
1381         bytes memory bresult = bytes(_a);
1382         uint mint = 0;
1383         bool decimals = false;
1384         for (uint i=0; i<bresult.length; i++){
1385             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1386                 if (decimals){
1387                    if (_b == 0) break;
1388                     else _b--;
1389                 }
1390                 mint *= 10;
1391                 mint += uint(bresult[i]) - 48;
1392             } else if (bresult[i] == 46) decimals = true;
1393         }
1394         if (_b > 0) mint *= 10**_b;
1395         return mint;
1396     }
1397 
1398     function uint2str(uint i) internal returns (string){
1399         if (i == 0) return "0";
1400         uint j = i;
1401         uint len;
1402         while (j != 0){
1403             len++;
1404             j /= 10;
1405         }
1406         bytes memory bstr = new bytes(len);
1407         uint k = len - 1;
1408         while (i != 0){
1409             bstr[k--] = byte(48 + i % 10);
1410             i /= 10;
1411         }
1412         return string(bstr);
1413     }
1414 
1415     function stra2cbor(string[] arr) internal returns (bytes) {
1416             uint arrlen = arr.length;
1417 
1418             // get correct cbor output length
1419             uint outputlen = 0;
1420             bytes[] memory elemArray = new bytes[](arrlen);
1421             for (uint i = 0; i < arrlen; i++) {
1422                 elemArray[i] = (bytes(arr[i]));
1423                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1424             }
1425             uint ctr = 0;
1426             uint cborlen = arrlen + 0x80;
1427             outputlen += byte(cborlen).length;
1428             bytes memory res = new bytes(outputlen);
1429 
1430             while (byte(cborlen).length > ctr) {
1431                 res[ctr] = byte(cborlen)[ctr];
1432                 ctr++;
1433             }
1434             for (i = 0; i < arrlen; i++) {
1435                 res[ctr] = 0x5F;
1436                 ctr++;
1437                 for (uint x = 0; x < elemArray[i].length; x++) {
1438                     // if there's a bug with larger strings, this may be the culprit
1439                     if (x % 23 == 0) {
1440                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1441                         elemcborlen += 0x40;
1442                         uint lctr = ctr;
1443                         while (byte(elemcborlen).length > ctr - lctr) {
1444                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1445                             ctr++;
1446                         }
1447                     }
1448                     res[ctr] = elemArray[i][x];
1449                     ctr++;
1450                 }
1451                 res[ctr] = 0xFF;
1452                 ctr++;
1453             }
1454             return res;
1455         }
1456 
1457     function ba2cbor(bytes[] arr) internal returns (bytes) {
1458             uint arrlen = arr.length;
1459 
1460             // get correct cbor output length
1461             uint outputlen = 0;
1462             bytes[] memory elemArray = new bytes[](arrlen);
1463             for (uint i = 0; i < arrlen; i++) {
1464                 elemArray[i] = (bytes(arr[i]));
1465                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1466             }
1467             uint ctr = 0;
1468             uint cborlen = arrlen + 0x80;
1469             outputlen += byte(cborlen).length;
1470             bytes memory res = new bytes(outputlen);
1471 
1472             while (byte(cborlen).length > ctr) {
1473                 res[ctr] = byte(cborlen)[ctr];
1474                 ctr++;
1475             }
1476             for (i = 0; i < arrlen; i++) {
1477                 res[ctr] = 0x5F;
1478                 ctr++;
1479                 for (uint x = 0; x < elemArray[i].length; x++) {
1480                     // if there's a bug with larger strings, this may be the culprit
1481                     if (x % 23 == 0) {
1482                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1483                         elemcborlen += 0x40;
1484                         uint lctr = ctr;
1485                         while (byte(elemcborlen).length > ctr - lctr) {
1486                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1487                             ctr++;
1488                         }
1489                     }
1490                     res[ctr] = elemArray[i][x];
1491                     ctr++;
1492                 }
1493                 res[ctr] = 0xFF;
1494                 ctr++;
1495             }
1496             return res;
1497         }
1498 
1499 
1500     string oraclize_network_name;
1501     function oraclize_setNetworkName(string _network_name) internal {
1502         oraclize_network_name = _network_name;
1503     }
1504 
1505     function oraclize_getNetworkName() internal returns (string) {
1506         return oraclize_network_name;
1507     }
1508 
1509     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1510         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1511 	// Convert from seconds to ledger timer ticks
1512         _delay *= 10; 
1513         bytes memory nbytes = new bytes(1);
1514         nbytes[0] = byte(_nbytes);
1515         bytes memory unonce = new bytes(32);
1516         bytes memory sessionKeyHash = new bytes(32);
1517         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1518         assembly {
1519             mstore(unonce, 0x20)
1520             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1521             mstore(sessionKeyHash, 0x20)
1522             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1523         }
1524         bytes memory delay = new bytes(32);
1525         assembly { 
1526             mstore(add(delay, 0x20), _delay) 
1527         }
1528         
1529         bytes memory delay_bytes8 = new bytes(8);
1530         copyBytes(delay, 24, 8, delay_bytes8, 0);
1531 
1532         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1533         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1534         
1535         bytes memory delay_bytes8_left = new bytes(8);
1536         
1537         assembly {
1538             let x := mload(add(delay_bytes8, 0x20))
1539             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1540             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1541             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1542             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1543             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1544             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1545             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1546             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1547 
1548         }
1549         
1550         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1551         return queryId;
1552     }
1553     
1554     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1555         oraclize_randomDS_args[queryId] = commitment;
1556     }
1557 
1558     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1559     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1560 
1561     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1562         bool sigok;
1563         address signer;
1564 
1565         bytes32 sigr;
1566         bytes32 sigs;
1567 
1568         bytes memory sigr_ = new bytes(32);
1569         uint offset = 4+(uint(dersig[3]) - 0x20);
1570         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1571         bytes memory sigs_ = new bytes(32);
1572         offset += 32 + 2;
1573         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1574 
1575         assembly {
1576             sigr := mload(add(sigr_, 32))
1577             sigs := mload(add(sigs_, 32))
1578         }
1579 
1580 
1581         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1582         if (address(sha3(pubkey)) == signer) return true;
1583         else {
1584             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1585             return (address(sha3(pubkey)) == signer);
1586         }
1587     }
1588 
1589     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1590         bool sigok;
1591 
1592         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1593         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1594         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1595 
1596         bytes memory appkey1_pubkey = new bytes(64);
1597         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1598 
1599         bytes memory tosign2 = new bytes(1+65+32);
1600         tosign2[0] = 1; //role
1601         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1602         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1603         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1604         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1605 
1606         if (sigok == false) return false;
1607 
1608 
1609         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1610         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1611 
1612         bytes memory tosign3 = new bytes(1+65);
1613         tosign3[0] = 0xFE;
1614         copyBytes(proof, 3, 65, tosign3, 1);
1615 
1616         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1617         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1618 
1619         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1620 
1621         return sigok;
1622     }
1623 
1624     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1625         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1626         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1627 
1628         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1629         if (proofVerified == false) throw;
1630 
1631         _;
1632     }
1633 
1634     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1635         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1636         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1637 
1638         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1639         if (proofVerified == false) return 2;
1640 
1641         return 0;
1642     }
1643 
1644     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1645         bool match_ = true;
1646 	
1647 	if (prefix.length != n_random_bytes) throw;
1648 	        
1649         for (uint256 i=0; i< n_random_bytes; i++) {
1650             if (content[i] != prefix[i]) match_ = false;
1651         }
1652 
1653         return match_;
1654     }
1655 
1656     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1657 
1658         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1659         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1660         bytes memory keyhash = new bytes(32);
1661         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1662         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1663 
1664         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1665         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1666 
1667         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1668         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1669 
1670         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1671         // This is to verify that the computed args match with the ones specified in the query.
1672         bytes memory commitmentSlice1 = new bytes(8+1+32);
1673         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1674 
1675         bytes memory sessionPubkey = new bytes(64);
1676         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1677         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1678 
1679         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1680         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1681             delete oraclize_randomDS_args[queryId];
1682         } else return false;
1683 
1684 
1685         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1686         bytes memory tosign1 = new bytes(32+8+1+32);
1687         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1688         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1689 
1690         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1691         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1692             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1693         }
1694 
1695         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1696     }
1697 
1698 
1699     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1700     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1701         uint minLength = length + toOffset;
1702 
1703         if (to.length < minLength) {
1704             // Buffer too small
1705             throw; // Should be a better way?
1706         }
1707 
1708         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1709         uint i = 32 + fromOffset;
1710         uint j = 32 + toOffset;
1711 
1712         while (i < (32 + fromOffset + length)) {
1713             assembly {
1714                 let tmp := mload(add(from, i))
1715                 mstore(add(to, j), tmp)
1716             }
1717             i += 32;
1718             j += 32;
1719         }
1720 
1721         return to;
1722     }
1723 
1724     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1725     // Duplicate Solidity's ecrecover, but catching the CALL return value
1726     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1727         // We do our own memory management here. Solidity uses memory offset
1728         // 0x40 to store the current end of memory. We write past it (as
1729         // writes are memory extensions), but don't update the offset so
1730         // Solidity will reuse it. The memory used here is only needed for
1731         // this context.
1732 
1733         // FIXME: inline assembly can't access return values
1734         bool ret;
1735         address addr;
1736 
1737         assembly {
1738             let size := mload(0x40)
1739             mstore(size, hash)
1740             mstore(add(size, 32), v)
1741             mstore(add(size, 64), r)
1742             mstore(add(size, 96), s)
1743 
1744             // NOTE: we can reuse the request memory because we deal with
1745             //       the return code
1746             ret := call(3000, 1, 0, size, 128, size, 32)
1747             addr := mload(size)
1748         }
1749 
1750         return (ret, addr);
1751     }
1752 
1753     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1754     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1755         bytes32 r;
1756         bytes32 s;
1757         uint8 v;
1758 
1759         if (sig.length != 65)
1760           return (false, 0);
1761 
1762         // The signature format is a compact form of:
1763         //   {bytes32 r}{bytes32 s}{uint8 v}
1764         // Compact means, uint8 is not padded to 32 bytes.
1765         assembly {
1766             r := mload(add(sig, 32))
1767             s := mload(add(sig, 64))
1768 
1769             // Here we are loading the last 32 bytes. We exploit the fact that
1770             // 'mload' will pad with zeroes if we overread.
1771             // There is no 'mload8' to do this, but that would be nicer.
1772             v := byte(0, mload(add(sig, 96)))
1773 
1774             // Alternative solution:
1775             // 'byte' is not working due to the Solidity parser, so lets
1776             // use the second best option, 'and'
1777             // v := and(mload(add(sig, 65)), 255)
1778         }
1779 
1780         // albeit non-transactional signatures are not specified by the YP, one would expect it
1781         // to match the YP range of [27, 28]
1782         //
1783         // geth uses [0, 1] and some clients have followed. This might change, see:
1784         //  https://github.com/ethereum/go-ethereum/issues/2053
1785         if (v < 27)
1786           v += 27;
1787 
1788         if (v != 27 && v != 28)
1789             return (false, 0);
1790 
1791         return safer_ecrecover(hash, v, r, s);
1792     }
1793 
1794 }
1795 // </ORACLIZE_API>
1796 
1797 contract ReceiverInterface {
1798     function receiveEther() external payable {}
1799 }
1800 
1801 contract EtheraffleUpgrade {
1802     function addToPrizePool() payable external {}
1803 }
1804 
1805 contract FreeLOTInterface {
1806     function mint(address _to, uint _amt) external {}
1807     function destroy(address _from, uint _amt) external {}
1808     function balanceOf(address who) constant public returns (uint) {}
1809 }
1810 
1811 contract Etheraffle is usingOraclize {
1812     using strings for *;
1813 
1814     uint    public week;
1815     bool    public paused;
1816     uint    public upgraded;
1817     uint    public prizePool;
1818     address public ethRelief;
1819     address public etheraffle;
1820     address public upgradeAddr;
1821     address public disburseAddr;
1822     uint    public take         = 150; // ppt
1823     uint    public gasAmt       = 500000;
1824     uint    public resultsDelay = 3600;
1825     uint    public matchesDelay = 3600;
1826     uint    public rafEnd       = 500400; // 7:00pm Saturdays
1827     uint    public wdrawBfr     = 6048000;
1828     uint    public gasPrc       = 20000000000; // 20 gwei
1829     uint    public tktPrice     = 2000000000000000;
1830     uint    public oracCost     = 1500000000000000; // $1 @ $700
1831     uint[]  public pctOfPool    = [520, 114, 47, 319]; // ppt...
1832     uint[]  public odds         = [56, 1032, 54200, 13983816]; // Rounded down to nearest whole 
1833     uint  constant WEEKDUR      = 604800;
1834     uint  constant BIRTHDAY     = 1500249600;//Etheraffle's birthday <3
1835 
1836     FreeLOTInterface freeLOT;
1837 
1838     string randomStr1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"data\", \"serialNumber\"]','\\n{\"jsonrpc\": \"2.0\",\"method\":\"generateSignedIntegers\",\"id\":\"";
1839     string randomStr2 = "\",\"params\":{\"n\":\"6\",\"min\":1,\"max\":49,\"replacement\":false,\"base\":10,\"apiKey\":${[decrypt] BIaCXRwykpLeDE9h1dQaAUi0LPTD4Jz0kwh6SVTftO+zromdgBhmdQhFwPsaLEGDHHn8bhQA8ksyjOZJpjDzKcVWlkBx5C07udHFtMnvG9g9VITYGxoMOhpFCTnoIKTBlIbNe5D1rIgl9OYUVX4ibTT8fCEE8TkWqQ==}}']";
1840     string apiStr1    = "[URL] ['json(https://etheraffle.com/api/a).m','{\"r\":\"";
1841     string apiStr2    = "\",\"k\":${[decrypt] BDzj/WPcHzGWYRL2cXvMNvInBxhutESn6Xj8pVzUUH+oEeWBoyycp23B7FSjqKJww6uH5AxvD4srlX0D/Rhl678YcKSNX2oMJJ47ciZrCnj6+28GHCLBV+XiA/1GDis9p5Q9NIKI}}']";
1842 
1843     mapping (uint => rafStruct) public raffle;
1844     struct rafStruct {
1845         mapping (address => uint[][]) entries;
1846         uint unclaimed;
1847         uint[] winNums;
1848         uint[] winAmts;
1849         uint timeStamp;
1850         bool wdrawOpen;
1851         uint numEntries;
1852         uint freeEntries;
1853     }
1854 
1855     mapping (bytes32 => qIDStruct) public qID;
1856     struct qIDStruct {
1857         uint weekNo;
1858         bool isRandom;
1859         bool isManual;
1860     }
1861     /**
1862     * @dev  Modifier to prepend to functions adding the additional
1863     *       conditional requiring caller of the method to be the
1864     *       etheraffle address.
1865     */
1866     modifier onlyEtheraffle() {
1867         require(msg.sender == etheraffle);
1868         _;
1869     }
1870     /**
1871     * @dev  Modifier to prepend to functions adding the additional
1872     *       conditional requiring the paused bool to be false.
1873     */
1874     modifier onlyIfNotPaused() {
1875         require(!paused);
1876         _;
1877     }
1878     event LogFunctionsPaused(uint identifier, uint atTime);
1879     event LogQuerySent(bytes32 queryID, uint dueAt, uint sendTime);
1880     event LogReclaim(uint indexed fromRaffle, uint amount, uint atTime);
1881     event LogUpgrade(address newContract, uint ethTransferred, uint atTime);
1882     event LogPrizePoolAddition(address fromWhom, uint howMuch, uint atTime);
1883     event LogFreeLOTWin(uint indexed forRaffle, address toWhom, uint entryNumber, uint amount, uint atTime);
1884     event LogOraclizeCallback(address functionCaller, bytes32 queryID, string result, uint indexed forRaffle, uint atTime);
1885     event LogFundsDisbursed(uint indexed forRaffle, uint oraclizeTotal, uint amount, address indexed toAddress, uint atTime);
1886     event LogWithdraw(uint indexed forRaffle, address indexed toWhom, uint forEntryNumber, uint matches, uint amountWon, uint atTime);
1887     event LogWinningNumbers(uint indexed forRaffle, uint numberOfEntries, uint[] wNumbers, uint currentPrizePool, uint randomSerialNo, uint atTime);
1888     event LogTicketBought(uint indexed forRaffle, uint indexed entryNumber, address indexed theEntrant, uint[] chosenNumbers, uint personalEntryNumber, uint tktCost, uint atTime, uint affiliateID);
1889     event LogPrizePoolsUpdated(uint newMainPrizePool, uint indexed forRaffle, uint unclaimedPrizePool, uint threeMatchWinAmt, uint fourMatchWinAmt, uint fiveMatchWinAmt, uint sixMatchwinAmt, uint atTime);
1890     /**
1891      * @dev   Constructor - sets the Etheraffle contract address &
1892      *        the disbursal contract address for investors, calls
1893      *        the newRaffle() function with sets the current
1894      *        raffle ID global var plus sets up the first raffle's
1895      *        struct with correct time stamp. Sets the withdraw
1896      *        before time to a ten week period, and prepares the
1897      *        initial oraclize call which will begin the recursive
1898      *        function.
1899      *
1900      * @param _freeLOT    The address of the Etheraffle FreeLOT special token.
1901      * @param _dsbrs      The address of the Etheraffle disbursal contract.
1902      * @param _msig       The address of the Etheraffle managerial multisig wallet.
1903      * @param _ethRelief  The address of the EthRelief charity contract.
1904      */
1905     function Etheraffle(address _freeLOT, address _dsbrs, address _msig, address _ethRelief) payable {
1906         week         = getWeek();
1907         etheraffle   = _msig;
1908         disburseAddr = _dsbrs;
1909         ethRelief    = _ethRelief;
1910         freeLOT      = FreeLOTInterface(_freeLOT);
1911         uint delay   = (week * WEEKDUR) + BIRTHDAY + rafEnd + resultsDelay;
1912         raffle[week].timeStamp = (week * WEEKDUR) + BIRTHDAY;
1913         bytes32 query = oraclize_query(delay, "nested", strConcat(randomStr1, uint2str(getWeek()), randomStr2), gasAmt);
1914         qID[query].weekNo = week;
1915         qID[query].isRandom = true;
1916         emit LogQuerySent(query, delay, now);
1917     }
1918     /**
1919      * @dev   Function using Etheraffle's birthday to calculate the
1920      *        week number since then.
1921      */
1922     function getWeek() public constant returns (uint) {
1923         uint curWeek = (now - BIRTHDAY) / WEEKDUR;
1924         if (now - ((curWeek * WEEKDUR) + BIRTHDAY) > rafEnd) {
1925             curWeek++;
1926         }
1927         return curWeek;
1928     }
1929     /**
1930      * @dev   Function which gets current week number and if different
1931      *        from the global var week number, it updates that and sets
1932      *        up the new raffle struct. Should only be called once a
1933      *        week after the raffle is closed. Should it get called
1934      *        sooner, the contract is paused for inspection.
1935      */
1936     function newRaffle() internal {
1937         uint newWeek = getWeek();
1938         if (newWeek == week) {
1939             pauseContract(4);
1940             return;
1941         } else {//∴ new raffle...
1942             week = newWeek;
1943             raffle[newWeek].timeStamp = BIRTHDAY + (newWeek * WEEKDUR);
1944         }
1945     }
1946     /**
1947      * @dev  To pause the contract's functions should the need arise. Internal.
1948      *       Logs an event of the pausing.
1949      *
1950      * @param _id    A uint to identify the caller of this function.
1951      */
1952     function pauseContract(uint _id) internal {
1953       paused = true;
1954       emit LogFunctionsPaused(_id, now);
1955     }
1956     /**
1957      * @dev  Function to enter the raffle. Requires the caller to send ether
1958      *       of amount greater than or equal to the ticket price.
1959      *
1960      * @param _cNums    Ordered array of entrant's six selected numbers.
1961      * @param _affID    Affiliate ID of the source of this entry.
1962      */
1963     function enterRaffle(uint[] _cNums, uint _affID) payable external onlyIfNotPaused {
1964         require(msg.value >= tktPrice);
1965         buyTicket(_cNums, msg.sender, msg.value, _affID);
1966     }
1967     /**
1968      * @dev  Function to enter the raffle on behalf of another address. Requires the 
1969      *       caller to send ether of amount greater than or equal to the ticket price.
1970      *       In the event of a win, only the onBehalfOf address can claim it.
1971      *
1972      * @param _cNums        Ordered array of entrant's six selected numbers.
1973      * @param _affID        Affiliate ID of the source of this entry.
1974      * @param _onBehalfOf   The address to be entered on behalf of.
1975      */
1976     function enterOnBehalfOf(uint[] _cNums, uint _affID, address _onBehalfOf) payable external onlyIfNotPaused {
1977         require(msg.value >= tktPrice);
1978         buyTicket(_cNums, _onBehalfOf, msg.value, _affID);
1979     }
1980     /**
1981      * @dev  Function to enter the raffle for free. Requires the caller's
1982      *       balance of the Etheraffle freeLOT token to be greater than
1983      *       zero. Function destroys one freeLOT token, increments the
1984      *       freeEntries variable in the raffle struct then purchases the
1985      *       ticket.
1986      *
1987      * @param _cNums    Ordered array of entrant's six selected numbers.
1988      * @param _affID    Affiliate ID of the source of this entry.
1989      */
1990     function enterFreeRaffle(uint[] _cNums, uint _affID) payable external onlyIfNotPaused {
1991         freeLOT.destroy(msg.sender, 1);
1992         raffle[week].freeEntries++;
1993         buyTicket(_cNums, msg.sender, msg.value, _affID);
1994     }
1995     /**
1996      * @dev   Function to buy tickets. Internal. Requires the entry number
1997      *        array to be of length 6, requires the timestamp of the current
1998      *        raffle struct to have been set, and for this time this function
1999      *        is call to be before the end of the raffle. Then requires that
2000      *        the chosen numbers are ordered lowest to highest & bound between
2001      *        1 and 49. Function increments the total number of entries in the
2002      *        current raffle's struct, increments the prize pool accordingly
2003      *        and pushes the chosen number array into the entries map and then
2004      *        logs the ticket purchase.
2005      *
2006      * @param _cNums       Array of users selected numbers.
2007      * @param _entrant     Entrant's ethereum address.
2008      * @param _value       The ticket purchase price.
2009      * @param _affID       The affiliate ID of the source of this entry.
2010      */
2011     function buyTicket
2012     (
2013         uint[]  _cNums,
2014         address _entrant,
2015         uint    _value,
2016         uint    _affID
2017     )
2018         internal
2019     {
2020         require
2021         (
2022             _cNums.length == 6 &&
2023             raffle[week].timeStamp > 0 &&
2024             now < raffle[week].timeStamp + rafEnd &&
2025             0         < _cNums[0] &&
2026             _cNums[0] < _cNums[1] &&
2027             _cNums[1] < _cNums[2] &&
2028             _cNums[2] < _cNums[3] &&
2029             _cNums[3] < _cNums[4] &&
2030             _cNums[4] < _cNums[5] &&
2031             _cNums[5] <= 49
2032         );
2033         raffle[week].numEntries++;
2034         prizePool += _value;
2035         raffle[week].entries[_entrant].push(_cNums);
2036         emit LogTicketBought(week, raffle[week].numEntries, _entrant, _cNums, raffle[week].entries[_entrant].length, _value, now, _affID);
2037     }
2038     /**
2039      * @dev Withdraw Winnings function. User calls this function in order to withdraw
2040      *      whatever winnings they are owed. Function can be paused via the modifier
2041      *      function "onlyIfNotPaused"
2042      *
2043      * @param _week        Week number of the raffle the winning entry is from
2044      * @param _entryNum    The entrants entry number into this raffle
2045      */
2046     function withdrawWinnings(uint _week, uint _entryNum) onlyIfNotPaused external {
2047         require
2048         (
2049             raffle[_week].timeStamp > 0 &&
2050             now - raffle[_week].timeStamp > WEEKDUR - (WEEKDUR / 7) &&
2051             now - raffle[_week].timeStamp < wdrawBfr &&
2052             raffle[_week].wdrawOpen == true &&
2053             raffle[_week].entries[msg.sender][_entryNum - 1].length == 6
2054         );
2055         uint matches = getMatches(_week, msg.sender, _entryNum);
2056         if (matches == 2) return winFreeGo(_week, _entryNum);
2057         require
2058         (
2059             matches >= 3 &&
2060             raffle[_week].winAmts[matches - 3] > 0 &&
2061             raffle[_week].winAmts[matches - 3] <= this.balance
2062         );
2063         raffle[_week].entries[msg.sender][_entryNum - 1].push(1);
2064         if (raffle[_week].winAmts[matches - 3] <= raffle[_week].unclaimed) {
2065             raffle[_week].unclaimed -= raffle[_week].winAmts[matches - 3];
2066         } else {
2067             raffle[_week].unclaimed = 0;
2068             pauseContract(5);
2069         }
2070         msg.sender.transfer(raffle[_week].winAmts[matches - 3]);
2071         emit LogWithdraw(_week, msg.sender, _entryNum, matches, raffle[_week].winAmts[matches - 3], now);
2072     }
2073     /*
2074      * @dev     Mints a FreeLOT coupon to a two match winner allowing them 
2075      *          a free entry to Etheraffle. Function pausable by pause toggle.
2076      */
2077     function winFreeGo(uint _week, uint _entryNum) onlyIfNotPaused internal {
2078         raffle[_week].entries[msg.sender][_entryNum - 1].push(1);
2079         freeLOT.mint(msg.sender, 1);
2080         emit LogFreeLOTWin(_week, msg.sender, _entryNum, 1, now);
2081     }
2082     /**
2083      * @dev    Called by the weekly oraclize callback. Checks raffle 10
2084      *         weeks older than current raffle for any unclaimed prize
2085      *         pool. If any found, returns it to the main prizePool and
2086      *         zeros the amount.
2087      */
2088     function reclaimUnclaimed() internal {
2089         uint old = getWeek() - 11;
2090         prizePool += raffle[old].unclaimed;
2091         emit LogReclaim(old, raffle[old].unclaimed, now);
2092     }
2093     /**
2094      * @dev  Function totals up oraclize cost for the raffle, subtracts
2095      *       it from the prizepool (if less than, if greater than if
2096      *       pauses the contract and fires an event). Calculates profit
2097      *       based on raffle's tickets sales and the take percentage,
2098      *       then forwards that amount of ether to the disbursal contract.
2099      *
2100      * @param _week   The week number of the raffle in question.
2101      */
2102     function disburseFunds(uint _week) internal {
2103         uint oracTot = 2 * ((gasAmt * gasPrc) + oracCost);//2 queries per draw...
2104         if (oracTot > prizePool) return pauseContract(1);
2105         prizePool -= oracTot;
2106         uint profit;
2107         if (raffle[_week].numEntries > 0) {
2108             profit = ((raffle[_week].numEntries - raffle[_week].freeEntries) * tktPrice * take) / 1000;
2109             prizePool -= profit;
2110             uint half = profit / 2;
2111             ReceiverInterface(disburseAddr).receiveEther.value(half)();
2112             ReceiverInterface(ethRelief).receiveEther.value(profit - half)();
2113             emit LogFundsDisbursed(_week, oracTot, profit - half, ethRelief, now);
2114             emit LogFundsDisbursed(_week, oracTot, half, disburseAddr, now);
2115             return;
2116         }
2117         emit LogFundsDisbursed(_week, oracTot, profit, 0, now);
2118     }
2119     /**
2120      * @dev   The Oralize call back function. The oracalize api calls are
2121      *        recursive. One to random.org for the draw and the other to
2122      *        the Etheraffle api for the numbers of matches each entry made
2123      *        against the winning numbers. Each calls the other recursively.
2124      *        The former when calledback closes and reclaims any unclaimed
2125      *        prizepool from the raffle ten weeks previous to now. Then it
2126      *        disburses profit to the disbursal contract, then it sets the
2127      *        winning numbers received from random.org into the raffle
2128      *        struct. Finally it prepares the next oraclize call. Which
2129      *        latter callback first sets up the new raffle struct, then
2130      *        sets the payouts based on the number of winners in each tier
2131      *        returned from the api call, then prepares the next oraclize
2132      *        query for a week later to draw the next raffle's winning
2133      *        numbers.
2134      *
2135      * @param _myID     bytes32 - Unique id oraclize provides with their
2136      *                            callbacks.
2137      * @param _result   string - The result of the api call.
2138      */
2139     function __callback(bytes32 _myID, string _result) onlyIfNotPaused {
2140         require(msg.sender == oraclize_cbAddress() || msg.sender == etheraffle);
2141         emit LogOraclizeCallback(msg.sender, _myID, _result, qID[_myID].weekNo, now);
2142         if (qID[_myID].isRandom == true) {
2143             reclaimUnclaimed();
2144             disburseFunds(qID[_myID].weekNo);
2145             setWinningNumbers(qID[_myID].weekNo, _result);
2146             if (qID[_myID].isManual == true) return;
2147             bytes32 query = oraclize_query(matchesDelay, "nested", strConcat(apiStr1, uint2str(qID[_myID].weekNo), apiStr2), gasAmt);
2148             qID[query].weekNo = qID[_myID].weekNo;
2149             emit LogQuerySent(query, matchesDelay + now, now);
2150         } else {
2151             newRaffle();
2152             setPayOuts(qID[_myID].weekNo, _result);
2153             if (qID[_myID].isManual == true) return;
2154             uint delay = (getWeek() * WEEKDUR) + BIRTHDAY + rafEnd + resultsDelay;
2155             query = oraclize_query(delay, "nested", strConcat(randomStr1, uint2str(getWeek()), randomStr2), gasAmt);
2156             qID[query].weekNo = getWeek();
2157             qID[query].isRandom = true;
2158             emit LogQuerySent(query, delay, now);
2159         }
2160     }
2161     /**
2162      * @dev   Slices a string according to specified delimiter, returning
2163      *        the sliced parts in an array.
2164      *
2165      * @param _string   The string to be sliced.
2166      */
2167     function stringToArray(string _string) internal returns (string[]) {
2168         var str    = _string.toSlice();
2169         var delim  = ",".toSlice();
2170         var parts  = new string[](str.count(delim) + 1);
2171         for (uint i = 0; i < parts.length; i++) {
2172             parts[i] = str.split(delim).toString();
2173         }
2174         return parts;
2175     }
2176     /**
2177      * @dev   Takes oraclize random.org api call result string and splits
2178      *        it at the commas into an array, parses those strings in that
2179      *        array as integers and pushes them into the winning numbers
2180      *        array in the raffle's struct. Fires event logging the data,
2181      *        including the serial number of the random.org callback so
2182      *        its veracity can be proven.
2183      *
2184      * @param _week    The week number of the raffle in question.
2185      * @param _result   The results string from oraclize callback.
2186      */
2187     function setWinningNumbers(uint _week, string _result) internal {
2188         string[] memory arr = stringToArray(_result);
2189         for (uint i = 0; i < arr.length; i++){
2190             raffle[_week].winNums.push(parseInt(arr[i]));
2191         }
2192         uint serialNo = parseInt(arr[6]);
2193         emit LogWinningNumbers(_week, raffle[_week].numEntries, raffle[_week].winNums, prizePool, serialNo, now);
2194     }
2195     /*  
2196      * @dev     Returns TOTAL payout per tier when calculated using the odds method.
2197      *
2198      * @param _numWinners       Number of X match winners
2199      * @param _matchesIndex     Index of matches array (∴ 3 match win, 4 match win etc)
2200      */
2201     function oddsTotal(uint _numWinners, uint _matchesIndex) internal view returns (uint) {
2202         return oddsSingle(_matchesIndex) * _numWinners;
2203     }
2204     /*
2205      * @dev     Returns TOTAL payout per tier when calculated using the splits method.
2206      *
2207      * @param _numWinners       Number of X match winners
2208      * @param _matchesIndex     Index of matches array (∴ 3 match win, 4 match win etc)
2209      */
2210     function splitsTotal(uint _numWinners, uint _matchesIndex) internal view returns (uint) {
2211         return splitsSingle(_numWinners, _matchesIndex) * _numWinners;
2212     }
2213     /*
2214      * @dev     Returns single payout when calculated using the odds method.
2215      *
2216      * @param _matchesIndex     Index of matches array (∴ 3 match win, 4 match win etc)
2217      */
2218     function oddsSingle(uint _matchesIndex) internal view returns (uint) {
2219         return tktPrice * odds[_matchesIndex];
2220     }
2221     /*
2222      * @dev     Returns a single payout when calculated using the splits method.
2223      *
2224      * @param _numWinners       Number of X match winners
2225      * @param _matchesIndex     Index of matches array (∴ 3 match win, 4 match win etc)
2226      */
2227     function splitsSingle(uint _numWinners, uint _matchesIndex) internal view returns (uint) {
2228         return (prizePool * pctOfPool[_matchesIndex]) / (_numWinners * 1000);
2229     }
2230     /**
2231      * @dev   Takes the results of the oraclize Etheraffle api call back
2232      *        and uses them to calculate the prizes due to each tier
2233      *        (3 matches, 4 matches etc) then pushes them into the winning
2234      *        amounts array in the raffle in question's struct. Calculates
2235      *        the total winnings of the raffle, subtracts it from the
2236      *        global prize pool sequesters that amount into the raffle's
2237      *        struct "unclaimed" variable, ∴ "rolling over" the unwon
2238      *        ether. Enables winner withdrawals by setting the withdraw
2239      *        open bool to true.
2240      *
2241      * @param _week    The week number of the raffle in question.
2242      * @param _result  The results string from oraclize callback.
2243      */
2244     function setPayOuts(uint _week, string _result) internal {
2245         string[] memory numWinnersStr = stringToArray(_result);
2246         if (numWinnersStr.length < 4) return pauseContract(2);
2247         uint[] memory numWinnersInt = new uint[](4);
2248         for (uint i = 0; i < 4; i++) {
2249             numWinnersInt[i] = parseInt(numWinnersStr[i]);
2250         }
2251         uint[] memory payOuts = new uint[](4);
2252         uint total;
2253         for (i = 0; i < 4; i++) {
2254             if (numWinnersInt[i] != 0) {
2255                 uint amt = oddsTotal(numWinnersInt[i], i) <= splitsTotal(numWinnersInt[i], i) 
2256                          ? oddsSingle(i) 
2257                          : splitsSingle(numWinnersInt[i], i); 
2258                 payOuts[i] = amt;
2259                 total += payOuts[i] * numWinnersInt[i];
2260             }
2261         }
2262         raffle[_week].unclaimed = total;
2263         if (raffle[_week].unclaimed > prizePool) return pauseContract(3);
2264         prizePool -= raffle[_week].unclaimed;
2265         for (i = 0; i < payOuts.length; i++) {
2266             raffle[_week].winAmts.push(payOuts[i]);
2267         }
2268         raffle[_week].wdrawOpen = true;
2269         emit LogPrizePoolsUpdated(prizePool, _week, raffle[_week].unclaimed, payOuts[0], payOuts[1], payOuts[2], payOuts[3], now);
2270     }
2271     /**
2272      * @dev   Function compares array of entrant's 6 chosen numbers to
2273       *       the raffle in question's winning numbers, counting how
2274       *       many matches there are.
2275       *
2276       * @param _week         The week number of the Raffle in question
2277       * @param _entrant      Entrant's ethereum address
2278       * @param _entryNum     number of entrant's entry in question.
2279      */
2280     function getMatches(uint _week, address _entrant, uint _entryNum) constant internal returns (uint) {
2281         uint matches;
2282         for (uint i = 0; i < 6; i++) {
2283             for (uint j = 0; j < 6; j++) {
2284                 if (raffle[_week].entries[_entrant][_entryNum - 1][i] == raffle[_week].winNums[j]) {
2285                     matches++;
2286                     break;
2287                 }
2288             }
2289         }
2290         return matches;
2291     }
2292     /**
2293      * @dev     Manually make an Oraclize API call, incase of automation
2294      *          failure. Only callable by the Etheraffle address.
2295      *
2296      * @param _delay      Either a time in seconds before desired callback
2297      *                    time for the API call, or a future UTC format time for
2298      *                    the desired time for the API callback.
2299      * @param _week       The week number this query is for.
2300      * @param _isRandom   Whether or not the api call being made is for
2301      *                    the random.org results draw, or for the Etheraffle
2302      *                    API results call.
2303      * @param _isManual   The Oraclize call back is a recursive function in
2304      *                    which each call fires off another call in perpetuity.
2305      *                    This bool allows that recursiveness for this call to be
2306      *                    turned on or off depending on caller's requirements.
2307      */
2308     function manuallyMakeOraclizeCall
2309     (
2310         uint _week,
2311         uint _delay,
2312         bool _isRandom,
2313         bool _isManual,
2314         bool _status
2315     )
2316         onlyEtheraffle external
2317     {
2318         paused = _status;
2319         string memory weekNumStr = uint2str(_week);
2320         if (_isRandom == true){
2321             bytes32 query = oraclize_query(_delay, "nested", strConcat(randomStr1, weekNumStr, randomStr2), gasAmt);
2322             qID[query].weekNo   = _week;
2323             qID[query].isRandom = true;
2324             qID[query].isManual = _isManual;
2325         } else {
2326             query = oraclize_query(_delay, "nested", strConcat(apiStr1, weekNumStr, apiStr2), gasAmt);
2327             qID[query].weekNo   = _week;
2328             qID[query].isManual = _isManual;
2329         }
2330     }
2331     /**
2332      * @dev    Set the Oraclize strings, in case of url changes. Only callable by
2333      *         the Etheraffle address  .
2334      *
2335      * @param _newRandomHalfOne       string - with properly escaped characters for
2336      *                                the first half of the random.org call string.
2337      * @param _newRandomHalfTwo       string - with properly escaped characters for
2338      *                                the second half of the random.org call string.
2339      * @param _newEtheraffleHalfOne   string - with properly escaped characters for
2340      *                                the first half of the EtheraffleAPI call string.
2341      * @param _newEtheraffleHalfTwo   string - with properly escaped characters for
2342      *                                the second half of the EtheraffleAPI call string.
2343      *
2344      */
2345     function setOraclizeString
2346     (
2347         string _newRandomHalfOne,
2348         string _newRandomHalfTwo,
2349         string _newEtheraffleHalfOne,
2350         string _newEtheraffleHalfTwo
2351     )
2352         onlyEtheraffle external
2353     {
2354         randomStr1 = _newRandomHalfOne;
2355         randomStr2 = _newRandomHalfTwo;
2356         apiStr1    = _newEtheraffleHalfOne;
2357         apiStr2    = _newEtheraffleHalfTwo;
2358     }
2359     /**
2360      * @dev   Set the ticket price of the raffle. Only callable by the
2361      *        Etheraffle address.
2362      *
2363      * @param _newPrice   uint - The desired new ticket price.
2364      *
2365      */
2366     function setTktPrice(uint _newPrice) onlyEtheraffle external {
2367         tktPrice = _newPrice;
2368     }
2369     /**
2370      * @dev    Set new take percentage. Only callable by the Etheraffle
2371      *         address.
2372      *
2373      * @param _newTake   uint - The desired new take, parts per thousand.
2374      *
2375      */
2376     function setTake(uint _newTake) onlyEtheraffle external {
2377         take = _newTake;
2378     }
2379     /**
2380      * @dev     Set the payouts manually, in case of a failed Oraclize call.
2381      *          Only callable by the Etheraffle address.
2382      *
2383      * @param _week         The week number of the raffle to set the payouts for.
2384      * @param _numMatches   Number of matches. Comma-separated STRING of 4
2385      *                      integers long, consisting of the number of 3 match
2386      *                      winners, 4 match winners, 5 & 6 match winners in
2387      *                      that order.
2388      */
2389     function setPayouts(uint _week, string _numMatches) onlyEtheraffle external {
2390         setPayOuts(_week, _numMatches);
2391     }
2392     /**
2393      * @dev   Set the FreeLOT token contract address, in case of future updrades.
2394      *        Only allable by the Etheraffle address.
2395      *
2396      * @param _newAddr   New address of FreeLOT contract.
2397      */
2398     function setFreeLOT(address _newAddr) onlyEtheraffle external {
2399         freeLOT = FreeLOTInterface(_newAddr);
2400       }
2401     /**
2402      * @dev   Set the EthRelief contract address, and gas required to run
2403      *        the receiving function. Only allable by the Etheraffle address.
2404      *
2405      * @param _newAddr   New address of the EthRelief contract.
2406      */
2407     function setEthRelief(address _newAddr) onlyEtheraffle external {
2408         ethRelief = _newAddr;
2409     }
2410     /**
2411      * @dev   Set the dividend contract address, and gas required to run
2412      *        the receive ether function. Only callable by the Etheraffle
2413      *        address.
2414      *
2415      * @param _newAddr   New address of dividend contract.
2416      */
2417     function setDisbursingAddr(address _newAddr) onlyEtheraffle external {
2418         disburseAddr = _newAddr;
2419     }
2420     /**
2421      * @dev   Set the Etheraffle multisig contract address, in case of future
2422      *        upgrades. Only callable by the current Etheraffle address.
2423      *
2424      * @param _newAddr   New address of Etheraffle multisig contract.
2425      */
2426     function setEtheraffle(address _newAddr) onlyEtheraffle external {
2427         etheraffle = _newAddr;
2428     }
2429     /**
2430      * @dev     Set the raffle end time, in number of seconds passed
2431      *          the start time of 00:00am Monday. Only callable by
2432      *          the Etheraffle address.
2433      *
2434      * @param _newTime    The time desired in seconds.
2435      */
2436     function setRafEnd(uint _newTime) onlyEtheraffle external {
2437         rafEnd = _newTime;
2438     }
2439     /**
2440      * @dev     Set the wdrawBfr time - the time a winner has to withdraw
2441      *          their winnings before the unclaimed prizepool is rolled
2442      *          back into the global prizepool. Only callable by the
2443      *          Etheraffle address.
2444      *
2445      * @param _newTime    The time desired in seconds.
2446      */
2447     function setWithdrawBeforeTime(uint _newTime) onlyEtheraffle external {
2448         wdrawBfr = _newTime;
2449     }
2450     /**
2451      * @dev     Set the paused status of the raffles. Only callable by
2452      *          the Etheraffle address.
2453      *
2454      * @param _status    The desired status of the raffles.
2455      */
2456     function setPaused(bool _status) onlyEtheraffle external {
2457         paused = _status;
2458     }
2459     /**
2460      * @dev     Set the percentage-of-prizepool array. Only callable by the
2461      *          Etheraffle address.
2462      *
2463      * @param _newPoP     An array of four integers totalling 1000.
2464      */
2465     function setPercentOfPool(uint[] _newPoP) onlyEtheraffle external {
2466         pctOfPool = _newPoP;
2467     }
2468     /**
2469      * @dev     Get a entrant's number of entries into a specific raffle
2470      *
2471      * @param _week       The week number of the queried raffle.
2472      * @param _entrant    The entrant in question.
2473      */
2474     function getUserNumEntries(address _entrant, uint _week) constant external returns (uint) {
2475         return raffle[_week].entries[_entrant].length;
2476     }
2477     /**
2478      * @dev     Get chosen numbers of an entrant, for a specific raffle.
2479      *          Returns an array.
2480      *
2481      * @param _entrant    The entrant in question's address.
2482      * @param _week       The week number of the queried raffle.
2483      * @param _entryNum   The entrant's entry number in this raffle.
2484      */
2485     function getChosenNumbers(address _entrant, uint _week, uint _entryNum) constant external returns (uint[]) {
2486         return raffle[_week].entries[_entrant][_entryNum-1];
2487     }
2488     /**
2489      * @dev     Get winning details of a raffle, ie, it's winning numbers
2490      *          and the prize amounts. Returns two arrays.
2491      *
2492      * @param _week   The week number of the raffle in question.
2493      */
2494     function getWinningDetails(uint _week) constant external returns (uint[], uint[]) {
2495         return (raffle[_week].winNums, raffle[_week].winAmts);
2496     }
2497     /**
2498      * @dev     Upgrades the Etheraffle contract. Only callable by the
2499      *          Etheraffle address. Calls an addToPrizePool method as
2500      *          per the abstract contract above. Function renders the
2501      *          entry method uncallable, cancels the Oraclize recursion,
2502      *          then zeroes the prizepool and sends the funds to the new
2503      *          contract. Sets a var tracking when upgrade occurred and logs
2504      *          the event.
2505      *
2506      * @param _newAddr   The new contract address.
2507      */
2508     function upgradeContract(address _newAddr) onlyEtheraffle external {
2509         require(upgraded == 0 && upgradeAddr == address(0));
2510         uint amt    = prizePool;
2511         upgradeAddr = _newAddr;
2512         upgraded    = now;
2513         week        = 0;
2514         prizePool   = 0;
2515         gasAmt      = 0;
2516         apiStr1     = "";
2517         randomStr1  = "";
2518         require(this.balance >= amt);
2519         EtheraffleUpgrade(_newAddr).addToPrizePool.value(amt)();
2520         emit LogUpgrade(_newAddr, amt, upgraded);
2521     }
2522     /**
2523      * @dev     Self destruct contract. Only callable by Etheraffle address.
2524      *          function. It deletes all contract code and data and forwards
2525      *          any remaining ether from non-claimed winning raffle tickets
2526      *          to the EthRelief charity contract. Requires the upgrade contract
2527      *          method to have been called 10 or more weeks prior, to allow
2528      *          winning tickets to be claimed within the usual withdrawal time
2529      *          frame.
2530      */
2531     function selfDestruct() onlyEtheraffle external {
2532         require(now - upgraded > WEEKDUR * 10);
2533         selfdestruct(ethRelief);
2534     }
2535     /**
2536      * @dev     Function allowing manual addition to the global prizepool.
2537      *          Requires the caller to send ether.
2538      */
2539     function addToPrizePool() payable external {
2540         require(msg.value > 0);
2541         prizePool += msg.value;
2542         emit LogPrizePoolAddition(msg.sender, msg.value, now);
2543     }
2544     /**
2545      * @dev   Fallback function.
2546      */
2547     function () payable external {}
2548 }