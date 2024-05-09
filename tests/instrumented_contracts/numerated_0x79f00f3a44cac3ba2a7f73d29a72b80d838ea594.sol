1 pragma solidity ^0.4.8;
2 
3 library strings {
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
678 contract cens{
679     using strings for *;
680 
681     event Registered(address registree, string name, address directTo);
682     event Transfer(address sender, string name, address receiver);
683     event AddressChanged(string name, address oldAddress, address newAddress);
684     event OwnershipTransfer(string name, address oldOwner, address newOwner);
685     event Error(string error, string name);
686 
687     struct entry{
688         address owner;
689         address directTo;
690         string readableName;
691     }
692     mapping (string => entry) Entries;
693 
694     uint numEntries;
695     uint maxEntries = 10000;
696     bool allowed = false;
697 
698     string compare = ".ceth";
699 
700     address owner;
701     function cens(){
702         owner = msg.sender;
703     }
704 
705     function enableRegistration(){
706       if(msg.sender == owner){
707         allowed = true;
708       }
709     }
710 
711     function read(string name) constant returns (address redirAddress){
712         entry e = Entries[name];
713         return e.directTo;
714     }
715 
716     function getNameOwner(string name) constant returns (address owner){
717         entry e = Entries[name];
718         return e.owner;
719     }
720 
721     function getAmountRegistered() constant returns (uint amountRegistered){
722         return numEntries;
723     }
724 
725     function deleteContract(){
726     	if(msg.sender == owner){
727     		selfdestruct(owner);
728     	}
729     }
730 
731     function send(string name) payable{
732         entry e = Entries[name];
733         if(e.directTo != address(0x0)){
734             if(!e.directTo.send(msg.value)){
735                 throw;
736             }
737             Transfer(msg.sender, name, e.directTo);
738         }else{
739             Error("name is not valid/registered.", name);
740             if(!msg.sender.send(msg.value)){
741                 throw;
742             }
743         }
744     }
745 
746     function changeAddress(string name, address newAddress){
747         entry e = Entries[name];
748         if(msg.sender == e.owner){
749             AddressChanged(name, e.directTo, newAddress);
750             e.directTo = newAddress;
751         }else{
752             Error("insufficient permissions.", name);
753         }
754     }
755 
756     function transferOwnership(string name, address newOwner){
757         entry e = Entries[name];
758         if(msg.sender == e.owner){
759             OwnershipTransfer(name, e.owner, newOwner);
760             e.owner = newOwner;
761         }else{
762             Error("insufficient permissions.", name);
763         }
764     }
765 
766     function register(string name, address directAddress){
767         entry e = Entries[name];
768         bytes memory a = bytes(name);
769         var s = name.toSlice();
770 
771         if(allowed && e.owner == address(0x0) && a.length > 5 && a.length <= 20 && numEntries < maxEntries && s.endsWith(".ceth".toSlice())){
772             e.readableName = name;
773             e.owner = msg.sender;
774             e.directTo = directAddress;
775             Registered(msg.sender, name, directAddress);
776             numEntries++;
777         }else{
778             Error("either the name is taken, too long, has invalid characters, or the registry is full.", name);
779         }
780     }
781 }