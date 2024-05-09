1 pragma solidity ^0.4.10;
2 
3 contract accessControlled {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         if ( msg.sender != owner ) throw;
12         /* o caracter "_" é substituído pelo corpo da funcao onde o modifier é utilizado */
13         _;
14     }
15 
16     function transferOwnership( address newOwner ) onlyOwner {
17         owner = newOwner;
18     }
19 
20 }
21 
22 contract OriginalMyIdRepository is accessControlled{
23     using strings for *;
24 
25     uint256 public totalUsers;
26     uint256 public totalWallets;
27     idRepository[] public userIds;
28 
29     mapping ( uint256 => uint256 ) public userIdIndex;
30 	mapping ( string => uint256 )  userByWallet;
31     //mapping ( uint256 => string[] ) public walletsFromUser;
32 
33 
34     struct idRepository {
35         uint256 userId;
36         string[] userWallets;
37     }
38 
39 	event User( uint256 id );
40 	event CheckUserByWallet( uint256 id );
41     event ShowLastWallet( string wallet );
42     event LogS( string text );
43     event LogN( uint number );
44 
45 	function OriginalMyIdRepository() {
46 		owner = msg.sender;
47 		newUser( 0, 'Invalid index 0' );
48 		totalUsers -= 1;
49 		totalWallets -= 1;
50 	}
51 
52     /* Criar usuário ou adicionar wallet a usuario existente */
53     function newUser( uint256 id, string wallet ) onlyOwner returns ( bool ) {
54         if ( userByWallet[wallet] > 0 ) throw;
55 
56         uint userIndex;
57         if ( userIdIndex[id] > 0 ) {
58             userIndex = userIdIndex[id];
59         } else {
60             userIndex = userIds.length++;
61         }
62         
63         idRepository i = userIds[userIndex];
64         
65         if ( userIdIndex[id] == 0 ){
66             i.userId = id;
67             userIdIndex[id] = userIndex;
68             totalUsers++;
69         }
70 
71         string[] walletList = i.userWallets; 
72         uint w = walletList.length++;
73         if ( userByWallet[wallet] > 0 ) throw;
74         i.userWallets[w] = wallet;
75         userByWallet[wallet] = id;
76         //walletsFromUser[id] = i.userWallets;
77         totalWallets++;
78 
79         User(id);
80 
81         return true;
82     }
83     
84     function checkUserByWallet( string wallet ) returns ( uint256 ) {
85         uint256 userId = userByWallet[wallet];
86         CheckUserByWallet( userId );
87         return userId;
88     }
89 
90     function getLastWallet( uint256 id ) returns ( string ) {
91         uint userIndex = userIdIndex[id];
92         idRepository i = userIds[userIndex];
93         return i.userWallets[i.userWallets.length-1];
94     }
95 
96     function getWalletsFromUser( uint256 id ) returns (string wallets){
97         string memory separator;
98         separator = ',';
99         uint userIndex = userIdIndex[id];
100         idRepository i = userIds[userIndex];
101         for (uint j=0; j < i.userWallets.length; j++){
102             ShowLastWallet( i.userWallets[j] );
103             if (j > 0 ) wallets = wallets.toSlice().concat(separator.toSlice());
104             wallets = wallets.toSlice().concat(i.userWallets[j].toSlice());
105         }
106         return;
107     }
108 
109     function isWalletFromUser( uint256 id, string wallet ) returns ( bool ){
110         if ( userByWallet[wallet] == id ) return true;
111         return false;
112     }
113 
114 
115     /* Se tentarem enviar ether para o end desse contrato, ele rejeita */
116     function () {
117         throw;
118     }
119 }
120 
121 /*
122  * @title String & slice utility library for Solidity contracts.
123  * @author Nick Johnson <arachnid@notdot.net>
124  *
125  * @dev Functionality in this library is largely implemented using an
126  *      abstraction called a 'slice'. A slice represents a part of a string -
127  *      anything from the entire string to a single character, or even no
128  *      characters at all (a 0-length slice). Since a slice only has to specify
129  *      an offset and a length, copying and manipulating slices is a lot less
130  *      expensive than copying and manipulating the strings they reference.
131  *
132  *      To further reduce gas costs, most functions on slice that need to return
133  *      a slice modify the original one instead of allocating a new one; for
134  *      instance, `s.split(".")` will return the text up to the first '.',
135  *      modifying s to only contain the remainder of the string after the '.'.
136  *      In situations where you do not want to modify the original slice, you
137  *      can make a copy first with `.copy()`, for example:
138  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
139  *      Solidity has no memory management, it will result in allocating many
140  *      short-lived slices that are later discarded.
141  *
142  *      Functions that return two slices come in two versions: a non-allocating
143  *      version that takes the second slice as an argument, modifying it in
144  *      place, and an allocating version that allocates and returns the second
145  *      slice; see `nextRune` for example.
146  *
147  *      Functions that have to copy string data will return strings rather than
148  *      slices; these can be cast back to slices for further processing if
149  *      required.
150  *
151  *      For convenience, some functions are provided with non-modifying
152  *      variants that create a new slice and return both; for instance,
153  *      `s.splitNew('.')` leaves s unmodified, and returns two values
154  *      corresponding to the left and right parts of the string.
155  */
156 pragma solidity ^0.4.10;
157 
158 library strings {
159     struct slice {
160         uint _len;
161         uint _ptr;
162     }
163 
164     function memcpy(uint dest, uint src, uint len) private {
165         // Copy word-length chunks while possible
166         for(; len >= 32; len -= 32) {
167             assembly {
168                 mstore(dest, mload(src))
169             }
170             dest += 32;
171             src += 32;
172         }
173 
174         // Copy remaining bytes
175         uint mask = 256 ** (32 - len) - 1;
176         assembly {
177             let srcpart := and(mload(src), not(mask))
178             let destpart := and(mload(dest), mask)
179             mstore(dest, or(destpart, srcpart))
180         }
181     }
182 
183     /*
184      * @dev Returns a slice containing the entire string.
185      * @param self The string to make a slice from.
186      * @return A newly allocated slice containing the entire string.
187      */
188     function toSlice(string self) internal returns (slice) {
189         uint ptr;
190         assembly {
191             ptr := add(self, 0x20)
192         }
193         return slice(bytes(self).length, ptr);
194     }
195 
196     /*
197      * @dev Returns the length of a null-terminated bytes32 string.
198      * @param self The value to find the length of.
199      * @return The length of the string, from 0 to 32.
200      */
201     function len(bytes32 self) internal returns (uint) {
202         uint ret;
203         if (self == 0)
204             return 0;
205         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
206             ret += 16;
207             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
208         }
209         if (self & 0xffffffffffffffff == 0) {
210             ret += 8;
211             self = bytes32(uint(self) / 0x10000000000000000);
212         }
213         if (self & 0xffffffff == 0) {
214             ret += 4;
215             self = bytes32(uint(self) / 0x100000000);
216         }
217         if (self & 0xffff == 0) {
218             ret += 2;
219             self = bytes32(uint(self) / 0x10000);
220         }
221         if (self & 0xff == 0) {
222             ret += 1;
223         }
224         return 32 - ret;
225     }
226 
227     /*
228      * @dev Returns a slice containing the entire bytes32, interpreted as a
229      *      null-termintaed utf-8 string.
230      * @param self The bytes32 value to convert to a slice.
231      * @return A new slice containing the value of the input argument up to the
232      *         first null.
233      */
234     function toSliceB32(bytes32 self) internal returns (slice ret) {
235         // Allocate space for `self` in memory, copy it there, and point ret at it
236         assembly {
237             let ptr := mload(0x40)
238             mstore(0x40, add(ptr, 0x20))
239             mstore(ptr, self)
240             mstore(add(ret, 0x20), ptr)
241         }
242         ret._len = len(self);
243     }
244 
245     /*
246      * @dev Returns a new slice containing the same data as the current slice.
247      * @param self The slice to copy.
248      * @return A new slice containing the same data as `self`.
249      */
250     function copy(slice self) internal returns (slice) {
251         return slice(self._len, self._ptr);
252     }
253 
254     /*
255      * @dev Copies a slice to a new string.
256      * @param self The slice to copy.
257      * @return A newly allocated string containing the slice's text.
258      */
259     function toString(slice self) internal returns (string) {
260         var ret = new string(self._len);
261         uint retptr;
262         assembly { retptr := add(ret, 32) }
263 
264         memcpy(retptr, self._ptr, self._len);
265         return ret;
266     }
267 
268     /*
269      * @dev Returns the length in runes of the slice. Note that this operation
270      *      takes time proportional to the length of the slice; avoid using it
271      *      in loops, and call `slice.empty()` if you only need to know whether
272      *      the slice is empty or not.
273      * @param self The slice to operate on.
274      * @return The length of the slice in runes.
275      */
276     function len(slice self) internal returns (uint) {
277         // Starting at ptr-31 means the LSB will be the byte we care about
278         var ptr = self._ptr - 31;
279         var end = ptr + self._len;
280         for (uint len = 0; ptr < end; len++) {
281             uint8 b;
282             assembly { b := and(mload(ptr), 0xFF) }
283             if (b < 0x80) {
284                 ptr += 1;
285             } else if(b < 0xE0) {
286                 ptr += 2;
287             } else if(b < 0xF0) {
288                 ptr += 3;
289             } else if(b < 0xF8) {
290                 ptr += 4;
291             } else if(b < 0xFC) {
292                 ptr += 5;
293             } else {
294                 ptr += 6;
295             }
296         }
297         return len;
298     }
299 
300     /*
301      * @dev Returns true if the slice is empty (has a length of 0).
302      * @param self The slice to operate on.
303      * @return True if the slice is empty, False otherwise.
304      */
305     function empty(slice self) internal returns (bool) {
306         return self._len == 0;
307     }
308 
309     /*
310      * @dev Returns a positive number if `other` comes lexicographically after
311      *      `self`, a negative number if it comes before, or zero if the
312      *      contents of the two slices are equal. Comparison is done per-rune,
313      *      on unicode codepoints.
314      * @param self The first slice to compare.
315      * @param other The second slice to compare.
316      * @return The result of the comparison.
317      */
318     function compare(slice self, slice other) internal returns (int) {
319         uint shortest = self._len;
320         if (other._len < self._len)
321             shortest = other._len;
322 
323         var selfptr = self._ptr;
324         var otherptr = other._ptr;
325         for (uint idx = 0; idx < shortest; idx += 32) {
326             uint a;
327             uint b;
328             assembly {
329                 a := mload(selfptr)
330                 b := mload(otherptr)
331             }
332             if (a != b) {
333                 // Mask out irrelevant bytes and check again
334                 uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
335                 var diff = (a & mask) - (b & mask);
336                 if (diff != 0)
337                     return int(diff);
338             }
339             selfptr += 32;
340             otherptr += 32;
341         }
342         return int(self._len) - int(other._len);
343     }
344 
345     /*
346      * @dev Returns true if the two slices contain the same text.
347      * @param self The first slice to compare.
348      * @param self The second slice to compare.
349      * @return True if the slices are equal, false otherwise.
350      */
351     function equals(slice self, slice other) internal returns (bool) {
352         return compare(self, other) == 0;
353     }
354 
355     /*
356      * @dev Extracts the first rune in the slice into `rune`, advancing the
357      *      slice to point to the next rune and returning `self`.
358      * @param self The slice to operate on.
359      * @param rune The slice that will contain the first rune.
360      * @return `rune`.
361      */
362     function nextRune(slice self, slice rune) internal returns (slice) {
363         rune._ptr = self._ptr;
364 
365         if (self._len == 0) {
366             rune._len = 0;
367             return rune;
368         }
369 
370         uint len;
371         uint b;
372         // Load the first byte of the rune into the LSBs of b
373         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
374         if (b < 0x80) {
375             len = 1;
376         } else if(b < 0xE0) {
377             len = 2;
378         } else if(b < 0xF0) {
379             len = 3;
380         } else {
381             len = 4;
382         }
383 
384         // Check for truncated codepoints
385         if (len > self._len) {
386             rune._len = self._len;
387             self._ptr += self._len;
388             self._len = 0;
389             return rune;
390         }
391 
392         self._ptr += len;
393         self._len -= len;
394         rune._len = len;
395         return rune;
396     }
397 
398     /*
399      * @dev Returns the first rune in the slice, advancing the slice to point
400      *      to the next rune.
401      * @param self The slice to operate on.
402      * @return A slice containing only the first rune from `self`.
403      */
404     function nextRune(slice self) internal returns (slice ret) {
405         nextRune(self, ret);
406     }
407 
408     /*
409      * @dev Returns the number of the first codepoint in the slice.
410      * @param self The slice to operate on.
411      * @return The number of the first codepoint in the slice.
412      */
413     function ord(slice self) internal returns (uint ret) {
414         if (self._len == 0) {
415             return 0;
416         }
417 
418         uint word;
419         uint len;
420         uint div = 2 ** 248;
421 
422         // Load the rune into the MSBs of b
423         assembly { word:= mload(mload(add(self, 32))) }
424         var b = word / div;
425         if (b < 0x80) {
426             ret = b;
427             len = 1;
428         } else if(b < 0xE0) {
429             ret = b & 0x1F;
430             len = 2;
431         } else if(b < 0xF0) {
432             ret = b & 0x0F;
433             len = 3;
434         } else {
435             ret = b & 0x07;
436             len = 4;
437         }
438 
439         // Check for truncated codepoints
440         if (len > self._len) {
441             return 0;
442         }
443 
444         for (uint i = 1; i < len; i++) {
445             div = div / 256;
446             b = (word / div) & 0xFF;
447             if (b & 0xC0 != 0x80) {
448                 // Invalid UTF-8 sequence
449                 return 0;
450             }
451             ret = (ret * 64) | (b & 0x3F);
452         }
453 
454         return ret;
455     }
456 
457     /*
458      * @dev Returns the keccak-256 hash of the slice.
459      * @param self The slice to hash.
460      * @return The hash of the slice.
461      */
462     function keccak(slice self) internal returns (bytes32 ret) {
463         assembly {
464             ret := sha3(mload(add(self, 32)), mload(self))
465         }
466     }
467 
468     /*
469      * @dev Returns true if `self` starts with `needle`.
470      * @param self The slice to operate on.
471      * @param needle The slice to search for.
472      * @return True if the slice starts with the provided text, false otherwise.
473      */
474     function startsWith(slice self, slice needle) internal returns (bool) {
475         if (self._len < needle._len) {
476             return false;
477         }
478 
479         if (self._ptr == needle._ptr) {
480             return true;
481         }
482 
483         bool equal;
484         assembly {
485             let len := mload(needle)
486             let selfptr := mload(add(self, 0x20))
487             let needleptr := mload(add(needle, 0x20))
488             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
489         }
490         return equal;
491     }
492 
493     /*
494      * @dev If `self` starts with `needle`, `needle` is removed from the
495      *      beginning of `self`. Otherwise, `self` is unmodified.
496      * @param self The slice to operate on.
497      * @param needle The slice to search for.
498      * @return `self`
499      */
500     function beyond(slice self, slice needle) internal returns (slice) {
501         if (self._len < needle._len) {
502             return self;
503         }
504 
505         bool equal = true;
506         if (self._ptr != needle._ptr) {
507             assembly {
508                 let len := mload(needle)
509                 let selfptr := mload(add(self, 0x20))
510                 let needleptr := mload(add(needle, 0x20))
511                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
512             }
513         }
514 
515         if (equal) {
516             self._len -= needle._len;
517             self._ptr += needle._len;
518         }
519 
520         return self;
521     }
522 
523     /*
524      * @dev Returns true if the slice ends with `needle`.
525      * @param self The slice to operate on.
526      * @param needle The slice to search for.
527      * @return True if the slice starts with the provided text, false otherwise.
528      */
529     function endsWith(slice self, slice needle) internal returns (bool) {
530         if (self._len < needle._len) {
531             return false;
532         }
533 
534         var selfptr = self._ptr + self._len - needle._len;
535 
536         if (selfptr == needle._ptr) {
537             return true;
538         }
539 
540         bool equal;
541         assembly {
542             let len := mload(needle)
543             let needleptr := mload(add(needle, 0x20))
544             equal := eq(sha3(selfptr, len), sha3(needleptr, len))
545         }
546 
547         return equal;
548     }
549 
550     /*
551      * @dev If `self` ends with `needle`, `needle` is removed from the
552      *      end of `self`. Otherwise, `self` is unmodified.
553      * @param self The slice to operate on.
554      * @param needle The slice to search for.
555      * @return `self`
556      */
557     function until(slice self, slice needle) internal returns (slice) {
558         if (self._len < needle._len) {
559             return self;
560         }
561 
562         var selfptr = self._ptr + self._len - needle._len;
563         bool equal = true;
564         if (selfptr != needle._ptr) {
565             assembly {
566                 let len := mload(needle)
567                 let needleptr := mload(add(needle, 0x20))
568                 equal := eq(sha3(selfptr, len), sha3(needleptr, len))
569             }
570         }
571 
572         if (equal) {
573             self._len -= needle._len;
574         }
575 
576         return self;
577     }
578 
579     // Returns the memory address of the first byte of the first occurrence of
580     // `needle` in `self`, or the first byte after `self` if not found.
581     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
582         uint ptr;
583         uint idx;
584 
585         if (needlelen <= selflen) {
586             if (needlelen <= 32) {
587                 // Optimized assembly for 68 gas per byte on short strings
588                 assembly {
589                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
590                     let needledata := and(mload(needleptr), mask)
591                     let end := add(selfptr, sub(selflen, needlelen))
592                     ptr := selfptr
593                     loop:
594                     jumpi(exit, eq(and(mload(ptr), mask), needledata))
595                     ptr := add(ptr, 1)
596                     jumpi(loop, lt(sub(ptr, 1), end))
597                     ptr := add(selfptr, selflen)
598                     exit:
599                 }
600                 return ptr;
601             } else {
602                 // For long needles, use hashing
603                 bytes32 hash;
604                 assembly { hash := sha3(needleptr, needlelen) }
605                 ptr = selfptr;
606                 for (idx = 0; idx <= selflen - needlelen; idx++) {
607                     bytes32 testHash;
608                     assembly { testHash := sha3(ptr, needlelen) }
609                     if (hash == testHash)
610                         return ptr;
611                     ptr += 1;
612                 }
613             }
614         }
615         return selfptr + selflen;
616     }
617 
618     // Returns the memory address of the first byte after the last occurrence of
619     // `needle` in `self`, or the address of `self` if not found.
620     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
621         uint ptr;
622 
623         if (needlelen <= selflen) {
624             if (needlelen <= 32) {
625                 // Optimized assembly for 69 gas per byte on short strings
626                 assembly {
627                     let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
628                     let needledata := and(mload(needleptr), mask)
629                     ptr := add(selfptr, sub(selflen, needlelen))
630                     loop:
631                     jumpi(ret, eq(and(mload(ptr), mask), needledata))
632                     ptr := sub(ptr, 1)
633                     jumpi(loop, gt(add(ptr, 1), selfptr))
634                     ptr := selfptr
635                     jump(exit)
636                     ret:
637                     ptr := add(ptr, needlelen)
638                     exit:
639                 }
640                 return ptr;
641             } else {
642                 // For long needles, use hashing
643                 bytes32 hash;
644                 assembly { hash := sha3(needleptr, needlelen) }
645                 ptr = selfptr + (selflen - needlelen);
646                 while (ptr >= selfptr) {
647                     bytes32 testHash;
648                     assembly { testHash := sha3(ptr, needlelen) }
649                     if (hash == testHash)
650                         return ptr + needlelen;
651                     ptr -= 1;
652                 }
653             }
654         }
655         return selfptr;
656     }
657 
658     /*
659      * @dev Modifies `self` to contain everything from the first occurrence of
660      *      `needle` to the end of the slice. `self` is set to the empty slice
661      *      if `needle` is not found.
662      * @param self The slice to search and modify.
663      * @param needle The text to search for.
664      * @return `self`.
665      */
666     function find(slice self, slice needle) internal returns (slice) {
667         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
668         self._len -= ptr - self._ptr;
669         self._ptr = ptr;
670         return self;
671     }
672 
673     /*
674      * @dev Modifies `self` to contain the part of the string from the start of
675      *      `self` to the end of the first occurrence of `needle`. If `needle`
676      *      is not found, `self` is set to the empty slice.
677      * @param self The slice to search and modify.
678      * @param needle The text to search for.
679      * @return `self`.
680      */
681     function rfind(slice self, slice needle) internal returns (slice) {
682         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
683         self._len = ptr - self._ptr;
684         return self;
685     }
686 
687     /*
688      * @dev Splits the slice, setting `self` to everything after the first
689      *      occurrence of `needle`, and `token` to everything before it. If
690      *      `needle` does not occur in `self`, `self` is set to the empty slice,
691      *      and `token` is set to the entirety of `self`.
692      * @param self The slice to split.
693      * @param needle The text to search for in `self`.
694      * @param token An output parameter to which the first token is written.
695      * @return `token`.
696      */
697     function split(slice self, slice needle, slice token) internal returns (slice) {
698         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
699         token._ptr = self._ptr;
700         token._len = ptr - self._ptr;
701         if (ptr == self._ptr + self._len) {
702             // Not found
703             self._len = 0;
704         } else {
705             self._len -= token._len + needle._len;
706             self._ptr = ptr + needle._len;
707         }
708         return token;
709     }
710 
711     /*
712      * @dev Splits the slice, setting `self` to everything after the first
713      *      occurrence of `needle`, and returning everything before it. If
714      *      `needle` does not occur in `self`, `self` is set to the empty slice,
715      *      and the entirety of `self` is returned.
716      * @param self The slice to split.
717      * @param needle The text to search for in `self`.
718      * @return The part of `self` up to the first occurrence of `delim`.
719      */
720     function split(slice self, slice needle) internal returns (slice token) {
721         split(self, needle, token);
722     }
723 
724     /*
725      * @dev Splits the slice, setting `self` to everything before the last
726      *      occurrence of `needle`, and `token` to everything after it. If
727      *      `needle` does not occur in `self`, `self` is set to the empty slice,
728      *      and `token` is set to the entirety of `self`.
729      * @param self The slice to split.
730      * @param needle The text to search for in `self`.
731      * @param token An output parameter to which the first token is written.
732      * @return `token`.
733      */
734     function rsplit(slice self, slice needle, slice token) internal returns (slice) {
735         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
736         token._ptr = ptr;
737         token._len = self._len - (ptr - self._ptr);
738         if (ptr == self._ptr) {
739             // Not found
740             self._len = 0;
741         } else {
742             self._len -= token._len + needle._len;
743         }
744         return token;
745     }
746 
747     /*
748      * @dev Splits the slice, setting `self` to everything before the last
749      *      occurrence of `needle`, and returning everything after it. If
750      *      `needle` does not occur in `self`, `self` is set to the empty slice,
751      *      and the entirety of `self` is returned.
752      * @param self The slice to split.
753      * @param needle The text to search for in `self`.
754      * @return The part of `self` after the last occurrence of `delim`.
755      */
756     function rsplit(slice self, slice needle) internal returns (slice token) {
757         rsplit(self, needle, token);
758     }
759 
760     /*
761      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
762      * @param self The slice to search.
763      * @param needle The text to search for in `self`.
764      * @return The number of occurrences of `needle` found in `self`.
765      */
766     function count(slice self, slice needle) internal returns (uint count) {
767         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
768         while (ptr <= self._ptr + self._len) {
769             count++;
770             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
771         }
772     }
773 
774     /*
775      * @dev Returns True if `self` contains `needle`.
776      * @param self The slice to search.
777      * @param needle The text to search for in `self`.
778      * @return True if `needle` is found in `self`, false otherwise.
779      */
780     function contains(slice self, slice needle) internal returns (bool) {
781         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
782     }
783 
784     /*
785      * @dev Returns a newly allocated string containing the concatenation of
786      *      `self` and `other`.
787      * @param self The first slice to concatenate.
788      * @param other The second slice to concatenate.
789      * @return The concatenation of the two strings.
790      */
791     function concat(slice self, slice other) internal returns (string) {
792         var ret = new string(self._len + other._len);
793         uint retptr;
794         assembly { retptr := add(ret, 32) }
795         memcpy(retptr, self._ptr, self._len);
796         memcpy(retptr + self._len, other._ptr, other._len);
797         return ret;
798     }
799 
800     /*
801      * @dev Joins an array of slices, using `self` as a delimiter, returning a
802      *      newly allocated string.
803      * @param self The delimiter to use.
804      * @param parts A list of slices to join.
805      * @return A newly allocated string containing all the slices in `parts`,
806      *         joined with `self`.
807      */
808     function join(slice self, slice[] parts) internal returns (string) {
809         if (parts.length == 0)
810             return "";
811 
812         uint len = self._len * (parts.length - 1);
813         for(uint i = 0; i < parts.length; i++)
814             len += parts[i]._len;
815 
816         var ret = new string(len);
817         uint retptr;
818         assembly { retptr := add(ret, 32) }
819 
820         for(i = 0; i < parts.length; i++) {
821             memcpy(retptr, parts[i]._ptr, parts[i]._len);
822             retptr += parts[i]._len;
823             if (i < parts.length - 1) {
824                 memcpy(retptr, self._ptr, self._len);
825                 retptr += self._len;
826             }
827         }
828 
829         return ret;
830     }
831 }