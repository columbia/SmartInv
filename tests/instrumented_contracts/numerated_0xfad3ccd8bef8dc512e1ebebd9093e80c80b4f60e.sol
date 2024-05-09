1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    */
88   function renounceOwnership() public onlyOwner {
89     emit OwnershipRenounced(owner);
90     owner = address(0);
91   }
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param _newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address _newOwner) public onlyOwner {
98     _transferOwnership(_newOwner);
99   }
100 
101   /**
102    * @dev Transfers control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function _transferOwnership(address _newOwner) internal {
106     require(_newOwner != address(0));
107     emit OwnershipTransferred(owner, _newOwner);
108     owner = _newOwner;
109   }
110 }
111 
112 /*
113  * @title String & slice utility library for Solidity contracts.
114  * @author Nick Johnson <arachnid@notdot.net>
115  *
116  * @dev Functionality in this library is largely implemented using an
117  *      abstraction called a 'slice'. A slice represents a part of a string -
118  *      anything from the entire string to a single character, or even no
119  *      characters at all (a 0-length slice). Since a slice only has to specify
120  *      an offset and a length, copying and manipulating slices is a lot less
121  *      expensive than copying and manipulating the strings they reference.
122  *
123  *      To further reduce gas costs, most functions on slice that need to return
124  *      a slice modify the original one instead of allocating a new one; for
125  *      instance, `s.split(".")` will return the text up to the first '.',
126  *      modifying s to only contain the remainder of the string after the '.'.
127  *      In situations where you do not want to modify the original slice, you
128  *      can make a copy first with `.copy()`, for example:
129  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
130  *      Solidity has no memory management, it will result in allocating many
131  *      short-lived slices that are later discarded.
132  *
133  *      Functions that return two slices come in two versions: a non-allocating
134  *      version that takes the second slice as an argument, modifying it in
135  *      place, and an allocating version that allocates and returns the second
136  *      slice; see `nextRune` for example.
137  *
138  *      Functions that have to copy string data will return strings rather than
139  *      slices; these can be cast back to slices for further processing if
140  *      required.
141  *
142  *      For convenience, some functions are provided with non-modifying
143  *      variants that create a new slice and return both; for instance,
144  *      `s.splitNew('.')` leaves s unmodified, and returns two values
145  *      corresponding to the left and right parts of the string.
146  */
147 
148 
149 
150 library strings {
151     struct slice {
152         uint _len;
153         uint _ptr;
154     }
155 
156     function memcpy(uint dest, uint src, uint len) private pure {
157         // Copy word-length chunks while possible
158         for(; len >= 32; len -= 32) {
159             assembly {
160                 mstore(dest, mload(src))
161             }
162             dest += 32;
163             src += 32;
164         }
165 
166         // Copy remaining bytes
167         uint mask = 256 ** (32 - len) - 1;
168         assembly {
169             let srcpart := and(mload(src), not(mask))
170             let destpart := and(mload(dest), mask)
171             mstore(dest, or(destpart, srcpart))
172         }
173     }
174 
175     /*
176      * @dev Returns a slice containing the entire string.
177      * @param self The string to make a slice from.
178      * @return A newly allocated slice containing the entire string.
179      */
180     function toSlice(string memory self) internal pure returns (slice memory) {
181         uint ptr;
182         assembly {
183             ptr := add(self, 0x20)
184         }
185         return slice(bytes(self).length, ptr);
186     }
187 
188     /*
189      * @dev Returns the length of a null-terminated bytes32 string.
190      * @param self The value to find the length of.
191      * @return The length of the string, from 0 to 32.
192      */
193     function len(bytes32 self) internal pure returns (uint) {
194         uint ret;
195         if (self == 0)
196             return 0;
197         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
198             ret += 16;
199             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
200         }
201         if (self & 0xffffffffffffffff == 0) {
202             ret += 8;
203             self = bytes32(uint(self) / 0x10000000000000000);
204         }
205         if (self & 0xffffffff == 0) {
206             ret += 4;
207             self = bytes32(uint(self) / 0x100000000);
208         }
209         if (self & 0xffff == 0) {
210             ret += 2;
211             self = bytes32(uint(self) / 0x10000);
212         }
213         if (self & 0xff == 0) {
214             ret += 1;
215         }
216         return 32 - ret;
217     }
218 
219     /*
220      * @dev Returns a slice containing the entire bytes32, interpreted as a
221      *      null-terminated utf-8 string.
222      * @param self The bytes32 value to convert to a slice.
223      * @return A new slice containing the value of the input argument up to the
224      *         first null.
225      */
226     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
227         // Allocate space for `self` in memory, copy it there, and point ret at it
228         assembly {
229             let ptr := mload(0x40)
230             mstore(0x40, add(ptr, 0x20))
231             mstore(ptr, self)
232             mstore(add(ret, 0x20), ptr)
233         }
234         ret._len = len(self);
235     }
236 
237     /*
238      * @dev Returns a new slice containing the same data as the current slice.
239      * @param self The slice to copy.
240      * @return A new slice containing the same data as `self`.
241      */
242     function copy(slice memory self) internal pure returns (slice memory) {
243         return slice(self._len, self._ptr);
244     }
245 
246     /*
247      * @dev Copies a slice to a new string.
248      * @param self The slice to copy.
249      * @return A newly allocated string containing the slice's text.
250      */
251     function toString(slice memory self) internal pure returns (string memory) {
252         string memory ret = new string(self._len);
253         uint retptr;
254         assembly { retptr := add(ret, 32) }
255 
256         memcpy(retptr, self._ptr, self._len);
257         return ret;
258     }
259 
260     /*
261      * @dev Returns the length in runes of the slice. Note that this operation
262      *      takes time proportional to the length of the slice; avoid using it
263      *      in loops, and call `slice.empty()` if you only need to know whether
264      *      the slice is empty or not.
265      * @param self The slice to operate on.
266      * @return The length of the slice in runes.
267      */
268     function len(slice memory self) internal pure returns (uint l) {
269         // Starting at ptr-31 means the LSB will be the byte we care about
270         uint ptr = self._ptr - 31;
271         uint end = ptr + self._len;
272         for (l = 0; ptr < end; l++) {
273             uint8 b;
274             assembly { b := and(mload(ptr), 0xFF) }
275             if (b < 0x80) {
276                 ptr += 1;
277             } else if(b < 0xE0) {
278                 ptr += 2;
279             } else if(b < 0xF0) {
280                 ptr += 3;
281             } else if(b < 0xF8) {
282                 ptr += 4;
283             } else if(b < 0xFC) {
284                 ptr += 5;
285             } else {
286                 ptr += 6;
287             }
288         }
289     }
290 
291     /*
292      * @dev Returns true if the slice is empty (has a length of 0).
293      * @param self The slice to operate on.
294      * @return True if the slice is empty, False otherwise.
295      */
296     function empty(slice memory self) internal pure returns (bool) {
297         return self._len == 0;
298     }
299 
300     /*
301      * @dev Returns a positive number if `other` comes lexicographically after
302      *      `self`, a negative number if it comes before, or zero if the
303      *      contents of the two slices are equal. Comparison is done per-rune,
304      *      on unicode codepoints.
305      * @param self The first slice to compare.
306      * @param other The second slice to compare.
307      * @return The result of the comparison.
308      */
309     function compare(slice memory self, slice memory other) internal pure returns (int) {
310         uint shortest = self._len;
311         if (other._len < self._len)
312             shortest = other._len;
313 
314         uint selfptr = self._ptr;
315         uint otherptr = other._ptr;
316         for (uint idx = 0; idx < shortest; idx += 32) {
317             uint a;
318             uint b;
319             assembly {
320                 a := mload(selfptr)
321                 b := mload(otherptr)
322             }
323             if (a != b) {
324                 // Mask out irrelevant bytes and check again
325                 uint256 mask = uint256(-1); // 0xffff...
326                 if(shortest < 32) {
327                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
328                 }
329                 uint256 diff = (a & mask) - (b & mask);
330                 if (diff != 0)
331                     return int(diff);
332             }
333             selfptr += 32;
334             otherptr += 32;
335         }
336         return int(self._len) - int(other._len);
337     }
338 
339     /*
340      * @dev Returns true if the two slices contain the same text.
341      * @param self The first slice to compare.
342      * @param self The second slice to compare.
343      * @return True if the slices are equal, false otherwise.
344      */
345     function equals(slice memory self, slice memory other) internal pure returns (bool) {
346         return compare(self, other) == 0;
347     }
348 
349     /*
350      * @dev Extracts the first rune in the slice into `rune`, advancing the
351      *      slice to point to the next rune and returning `self`.
352      * @param self The slice to operate on.
353      * @param rune The slice that will contain the first rune.
354      * @return `rune`.
355      */
356     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
357         rune._ptr = self._ptr;
358 
359         if (self._len == 0) {
360             rune._len = 0;
361             return rune;
362         }
363 
364         uint l;
365         uint b;
366         // Load the first byte of the rune into the LSBs of b
367         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
368         if (b < 0x80) {
369             l = 1;
370         } else if(b < 0xE0) {
371             l = 2;
372         } else if(b < 0xF0) {
373             l = 3;
374         } else {
375             l = 4;
376         }
377 
378         // Check for truncated codepoints
379         if (l > self._len) {
380             rune._len = self._len;
381             self._ptr += self._len;
382             self._len = 0;
383             return rune;
384         }
385 
386         self._ptr += l;
387         self._len -= l;
388         rune._len = l;
389         return rune;
390     }
391 
392     /*
393      * @dev Returns the first rune in the slice, advancing the slice to point
394      *      to the next rune.
395      * @param self The slice to operate on.
396      * @return A slice containing only the first rune from `self`.
397      */
398     function nextRune(slice memory self) internal pure returns (slice memory ret) {
399         nextRune(self, ret);
400     }
401 
402     /*
403      * @dev Returns the number of the first codepoint in the slice.
404      * @param self The slice to operate on.
405      * @return The number of the first codepoint in the slice.
406      */
407     function ord(slice memory self) internal pure returns (uint ret) {
408         if (self._len == 0) {
409             return 0;
410         }
411 
412         uint word;
413         uint length;
414         uint divisor = 2 ** 248;
415 
416         // Load the rune into the MSBs of b
417         assembly { word:= mload(mload(add(self, 32))) }
418         uint b = word / divisor;
419         if (b < 0x80) {
420             ret = b;
421             length = 1;
422         } else if(b < 0xE0) {
423             ret = b & 0x1F;
424             length = 2;
425         } else if(b < 0xF0) {
426             ret = b & 0x0F;
427             length = 3;
428         } else {
429             ret = b & 0x07;
430             length = 4;
431         }
432 
433         // Check for truncated codepoints
434         if (length > self._len) {
435             return 0;
436         }
437 
438         for (uint i = 1; i < length; i++) {
439             divisor = divisor / 256;
440             b = (word / divisor) & 0xFF;
441             if (b & 0xC0 != 0x80) {
442                 // Invalid UTF-8 sequence
443                 return 0;
444             }
445             ret = (ret * 64) | (b & 0x3F);
446         }
447 
448         return ret;
449     }
450 
451     /*
452      * @dev Returns the keccak-256 hash of the slice.
453      * @param self The slice to hash.
454      * @return The hash of the slice.
455      */
456     function keccak(slice memory self) internal pure returns (bytes32 ret) {
457         assembly {
458             ret := keccak256(mload(add(self, 32)), mload(self))
459         }
460     }
461 
462     /*
463      * @dev Returns true if `self` starts with `needle`.
464      * @param self The slice to operate on.
465      * @param needle The slice to search for.
466      * @return True if the slice starts with the provided text, false otherwise.
467      */
468     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
469         if (self._len < needle._len) {
470             return false;
471         }
472 
473         if (self._ptr == needle._ptr) {
474             return true;
475         }
476 
477         bool equal;
478         assembly {
479             let length := mload(needle)
480             let selfptr := mload(add(self, 0x20))
481             let needleptr := mload(add(needle, 0x20))
482             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
483         }
484         return equal;
485     }
486 
487     /*
488      * @dev If `self` starts with `needle`, `needle` is removed from the
489      *      beginning of `self`. Otherwise, `self` is unmodified.
490      * @param self The slice to operate on.
491      * @param needle The slice to search for.
492      * @return `self`
493      */
494     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
495         if (self._len < needle._len) {
496             return self;
497         }
498 
499         bool equal = true;
500         if (self._ptr != needle._ptr) {
501             assembly {
502                 let length := mload(needle)
503                 let selfptr := mload(add(self, 0x20))
504                 let needleptr := mload(add(needle, 0x20))
505                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
506             }
507         }
508 
509         if (equal) {
510             self._len -= needle._len;
511             self._ptr += needle._len;
512         }
513 
514         return self;
515     }
516 
517     /*
518      * @dev Returns true if the slice ends with `needle`.
519      * @param self The slice to operate on.
520      * @param needle The slice to search for.
521      * @return True if the slice starts with the provided text, false otherwise.
522      */
523     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
524         if (self._len < needle._len) {
525             return false;
526         }
527 
528         uint selfptr = self._ptr + self._len - needle._len;
529 
530         if (selfptr == needle._ptr) {
531             return true;
532         }
533 
534         bool equal;
535         assembly {
536             let length := mload(needle)
537             let needleptr := mload(add(needle, 0x20))
538             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
539         }
540 
541         return equal;
542     }
543 
544     /*
545      * @dev If `self` ends with `needle`, `needle` is removed from the
546      *      end of `self`. Otherwise, `self` is unmodified.
547      * @param self The slice to operate on.
548      * @param needle The slice to search for.
549      * @return `self`
550      */
551     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
552         if (self._len < needle._len) {
553             return self;
554         }
555 
556         uint selfptr = self._ptr + self._len - needle._len;
557         bool equal = true;
558         if (selfptr != needle._ptr) {
559             assembly {
560                 let length := mload(needle)
561                 let needleptr := mload(add(needle, 0x20))
562                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
563             }
564         }
565 
566         if (equal) {
567             self._len -= needle._len;
568         }
569 
570         return self;
571     }
572 
573     // Returns the memory address of the first byte of the first occurrence of
574     // `needle` in `self`, or the first byte after `self` if not found.
575     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
576         uint ptr = selfptr;
577         uint idx;
578 
579         if (needlelen <= selflen) {
580             if (needlelen <= 32) {
581                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
582 
583                 bytes32 needledata;
584                 assembly { needledata := and(mload(needleptr), mask) }
585 
586                 uint end = selfptr + selflen - needlelen;
587                 bytes32 ptrdata;
588                 assembly { ptrdata := and(mload(ptr), mask) }
589 
590                 while (ptrdata != needledata) {
591                     if (ptr >= end)
592                         return selfptr + selflen;
593                     ptr++;
594                     assembly { ptrdata := and(mload(ptr), mask) }
595                 }
596                 return ptr;
597             } else {
598                 // For long needles, use hashing
599                 bytes32 hash;
600                 assembly { hash := keccak256(needleptr, needlelen) }
601 
602                 for (idx = 0; idx <= selflen - needlelen; idx++) {
603                     bytes32 testHash;
604                     assembly { testHash := keccak256(ptr, needlelen) }
605                     if (hash == testHash)
606                         return ptr;
607                     ptr += 1;
608                 }
609             }
610         }
611         return selfptr + selflen;
612     }
613 
614     // Returns the memory address of the first byte after the last occurrence of
615     // `needle` in `self`, or the address of `self` if not found.
616     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
617         uint ptr;
618 
619         if (needlelen <= selflen) {
620             if (needlelen <= 32) {
621                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
622 
623                 bytes32 needledata;
624                 assembly { needledata := and(mload(needleptr), mask) }
625 
626                 ptr = selfptr + selflen - needlelen;
627                 bytes32 ptrdata;
628                 assembly { ptrdata := and(mload(ptr), mask) }
629 
630                 while (ptrdata != needledata) {
631                     if (ptr <= selfptr)
632                         return selfptr;
633                     ptr--;
634                     assembly { ptrdata := and(mload(ptr), mask) }
635                 }
636                 return ptr + needlelen;
637             } else {
638                 // For long needles, use hashing
639                 bytes32 hash;
640                 assembly { hash := keccak256(needleptr, needlelen) }
641                 ptr = selfptr + (selflen - needlelen);
642                 while (ptr >= selfptr) {
643                     bytes32 testHash;
644                     assembly { testHash := keccak256(ptr, needlelen) }
645                     if (hash == testHash)
646                         return ptr + needlelen;
647                     ptr -= 1;
648                 }
649             }
650         }
651         return selfptr;
652     }
653 
654     /*
655      * @dev Modifies `self` to contain everything from the first occurrence of
656      *      `needle` to the end of the slice. `self` is set to the empty slice
657      *      if `needle` is not found.
658      * @param self The slice to search and modify.
659      * @param needle The text to search for.
660      * @return `self`.
661      */
662     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
663         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
664         self._len -= ptr - self._ptr;
665         self._ptr = ptr;
666         return self;
667     }
668 
669     /*
670      * @dev Modifies `self` to contain the part of the string from the start of
671      *      `self` to the end of the first occurrence of `needle`. If `needle`
672      *      is not found, `self` is set to the empty slice.
673      * @param self The slice to search and modify.
674      * @param needle The text to search for.
675      * @return `self`.
676      */
677     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
678         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
679         self._len = ptr - self._ptr;
680         return self;
681     }
682 
683     /*
684      * @dev Splits the slice, setting `self` to everything after the first
685      *      occurrence of `needle`, and `token` to everything before it. If
686      *      `needle` does not occur in `self`, `self` is set to the empty slice,
687      *      and `token` is set to the entirety of `self`.
688      * @param self The slice to split.
689      * @param needle The text to search for in `self`.
690      * @param token An output parameter to which the first token is written.
691      * @return `token`.
692      */
693     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
694         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
695         token._ptr = self._ptr;
696         token._len = ptr - self._ptr;
697         if (ptr == self._ptr + self._len) {
698             // Not found
699             self._len = 0;
700         } else {
701             self._len -= token._len + needle._len;
702             self._ptr = ptr + needle._len;
703         }
704         return token;
705     }
706 
707     /*
708      * @dev Splits the slice, setting `self` to everything after the first
709      *      occurrence of `needle`, and returning everything before it. If
710      *      `needle` does not occur in `self`, `self` is set to the empty slice,
711      *      and the entirety of `self` is returned.
712      * @param self The slice to split.
713      * @param needle The text to search for in `self`.
714      * @return The part of `self` up to the first occurrence of `delim`.
715      */
716     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
717         split(self, needle, token);
718     }
719 
720     /*
721      * @dev Splits the slice, setting `self` to everything before the last
722      *      occurrence of `needle`, and `token` to everything after it. If
723      *      `needle` does not occur in `self`, `self` is set to the empty slice,
724      *      and `token` is set to the entirety of `self`.
725      * @param self The slice to split.
726      * @param needle The text to search for in `self`.
727      * @param token An output parameter to which the first token is written.
728      * @return `token`.
729      */
730     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
731         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
732         token._ptr = ptr;
733         token._len = self._len - (ptr - self._ptr);
734         if (ptr == self._ptr) {
735             // Not found
736             self._len = 0;
737         } else {
738             self._len -= token._len + needle._len;
739         }
740         return token;
741     }
742 
743     /*
744      * @dev Splits the slice, setting `self` to everything before the last
745      *      occurrence of `needle`, and returning everything after it. If
746      *      `needle` does not occur in `self`, `self` is set to the empty slice,
747      *      and the entirety of `self` is returned.
748      * @param self The slice to split.
749      * @param needle The text to search for in `self`.
750      * @return The part of `self` after the last occurrence of `delim`.
751      */
752     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
753         rsplit(self, needle, token);
754     }
755 
756     /*
757      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
758      * @param self The slice to search.
759      * @param needle The text to search for in `self`.
760      * @return The number of occurrences of `needle` found in `self`.
761      */
762     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
763         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
764         while (ptr <= self._ptr + self._len) {
765             cnt++;
766             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
767         }
768     }
769 
770     /*
771      * @dev Returns True if `self` contains `needle`.
772      * @param self The slice to search.
773      * @param needle The text to search for in `self`.
774      * @return True if `needle` is found in `self`, false otherwise.
775      */
776     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
777         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
778     }
779 
780     /*
781      * @dev Returns a newly allocated string containing the concatenation of
782      *      `self` and `other`.
783      * @param self The first slice to concatenate.
784      * @param other The second slice to concatenate.
785      * @return The concatenation of the two strings.
786      */
787     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
788         string memory ret = new string(self._len + other._len);
789         uint retptr;
790         assembly { retptr := add(ret, 32) }
791         memcpy(retptr, self._ptr, self._len);
792         memcpy(retptr + self._len, other._ptr, other._len);
793         return ret;
794     }
795 
796     /*
797      * @dev Joins an array of slices, using `self` as a delimiter, returning a
798      *      newly allocated string.
799      * @param self The delimiter to use.
800      * @param parts A list of slices to join.
801      * @return A newly allocated string containing all the slices in `parts`,
802      *         joined with `self`.
803      */
804     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
805         if (parts.length == 0)
806             return "";
807 
808         uint length = self._len * (parts.length - 1);
809         for(uint i = 0; i < parts.length; i++)
810             length += parts[i]._len;
811 
812         string memory ret = new string(length);
813         uint retptr;
814         assembly { retptr := add(ret, 32) }
815 
816         for(i = 0; i < parts.length; i++) {
817             memcpy(retptr, parts[i]._ptr, parts[i]._len);
818             retptr += parts[i]._len;
819             if (i < parts.length - 1) {
820                 memcpy(retptr, self._ptr, self._len);
821                 retptr += self._len;
822             }
823         }
824 
825         return ret;
826     }
827 }
828 
829 // <ORACLIZE_API>
830 /*
831 Copyright (c) 2015-2016 Oraclize SRL
832 Copyright (c) 2016 Oraclize LTD
833 
834 
835 
836 Permission is hereby granted, free of charge, to any person obtaining a copy
837 of this software and associated documentation files (the "Software"), to deal
838 in the Software without restriction, including without limitation the rights
839 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
840 copies of the Software, and to permit persons to whom the Software is
841 furnished to do so, subject to the following conditions:
842 
843 
844 
845 The above copyright notice and this permission notice shall be included in
846 all copies or substantial portions of the Software.
847 
848 
849 
850 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
851 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
852 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
853 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
854 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
855 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
856 THE SOFTWARE.
857 */
858 
859 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
860 
861 // Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
862 
863 contract OraclizeI {
864     address public cbAddress;
865     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
866     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
867     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
868     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
869     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
870     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
871     function getPrice(string _datasource) public returns (uint _dsprice);
872     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
873     function setProofType(byte _proofType) external;
874     function setCustomGasPrice(uint _gasPrice) external;
875     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
876 }
877 
878 contract OraclizeAddrResolverI {
879     function getAddress() public returns (address _addr);
880 }
881 
882 /*
883 Begin solidity-cborutils
884 
885 https://github.com/smartcontractkit/solidity-cborutils
886 
887 MIT License
888 
889 Copyright (c) 2018 SmartContract ChainLink, Ltd.
890 
891 Permission is hereby granted, free of charge, to any person obtaining a copy
892 of this software and associated documentation files (the "Software"), to deal
893 in the Software without restriction, including without limitation the rights
894 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
895 copies of the Software, and to permit persons to whom the Software is
896 furnished to do so, subject to the following conditions:
897 
898 The above copyright notice and this permission notice shall be included in all
899 copies or substantial portions of the Software.
900 
901 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
902 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
903 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
904 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
905 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
906 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
907 SOFTWARE.
908  */
909 
910 library Buffer {
911     struct buffer {
912         bytes buf;
913         uint capacity;
914     }
915 
916     function init(buffer memory buf, uint _capacity) internal pure {
917         uint capacity = _capacity;
918         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
919         // Allocate space for the buffer data
920         buf.capacity = capacity;
921         assembly {
922             let ptr := mload(0x40)
923             mstore(buf, ptr)
924             mstore(ptr, 0)
925             mstore(0x40, add(ptr, capacity))
926         }
927     }
928 
929     function resize(buffer memory buf, uint capacity) private pure {
930         bytes memory oldbuf = buf.buf;
931         init(buf, capacity);
932         append(buf, oldbuf);
933     }
934 
935     function max(uint a, uint b) private pure returns(uint) {
936         if(a > b) {
937             return a;
938         }
939         return b;
940     }
941 
942     /**
943      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
944      *      would exceed the capacity of the buffer.
945      * @param buf The buffer to append to.
946      * @param data The data to append.
947      * @return The original buffer.
948      */
949     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
950         if(data.length + buf.buf.length > buf.capacity) {
951             resize(buf, max(buf.capacity, data.length) * 2);
952         }
953 
954         uint dest;
955         uint src;
956         uint len = data.length;
957         assembly {
958             // Memory address of the buffer data
959             let bufptr := mload(buf)
960             // Length of existing buffer data
961             let buflen := mload(bufptr)
962             // Start address = buffer address + buffer length + sizeof(buffer length)
963             dest := add(add(bufptr, buflen), 32)
964             // Update buffer length
965             mstore(bufptr, add(buflen, mload(data)))
966             src := add(data, 32)
967         }
968 
969         // Copy word-length chunks while possible
970         for(; len >= 32; len -= 32) {
971             assembly {
972                 mstore(dest, mload(src))
973             }
974             dest += 32;
975             src += 32;
976         }
977 
978         // Copy remaining bytes
979         uint mask = 256 ** (32 - len) - 1;
980         assembly {
981             let srcpart := and(mload(src), not(mask))
982             let destpart := and(mload(dest), mask)
983             mstore(dest, or(destpart, srcpart))
984         }
985 
986         return buf;
987     }
988 
989     /**
990      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
991      * exceed the capacity of the buffer.
992      * @param buf The buffer to append to.
993      * @param data The data to append.
994      * @return The original buffer.
995      */
996     function append(buffer memory buf, uint8 data) internal pure {
997         if(buf.buf.length + 1 > buf.capacity) {
998             resize(buf, buf.capacity * 2);
999         }
1000 
1001         assembly {
1002             // Memory address of the buffer data
1003             let bufptr := mload(buf)
1004             // Length of existing buffer data
1005             let buflen := mload(bufptr)
1006             // Address = buffer address + buffer length + sizeof(buffer length)
1007             let dest := add(add(bufptr, buflen), 32)
1008             mstore8(dest, data)
1009             // Update buffer length
1010             mstore(bufptr, add(buflen, 1))
1011         }
1012     }
1013 
1014     /**
1015      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1016      * exceed the capacity of the buffer.
1017      * @param buf The buffer to append to.
1018      * @param data The data to append.
1019      * @return The original buffer.
1020      */
1021     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
1022         if(len + buf.buf.length > buf.capacity) {
1023             resize(buf, max(buf.capacity, len) * 2);
1024         }
1025 
1026         uint mask = 256 ** len - 1;
1027         assembly {
1028             // Memory address of the buffer data
1029             let bufptr := mload(buf)
1030             // Length of existing buffer data
1031             let buflen := mload(bufptr)
1032             // Address = buffer address + buffer length + sizeof(buffer length) + len
1033             let dest := add(add(bufptr, buflen), len)
1034             mstore(dest, or(and(mload(dest), not(mask)), data))
1035             // Update buffer length
1036             mstore(bufptr, add(buflen, len))
1037         }
1038         return buf;
1039     }
1040 }
1041 
1042 library CBOR {
1043     using Buffer for Buffer.buffer;
1044 
1045     uint8 private constant MAJOR_TYPE_INT = 0;
1046     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1047     uint8 private constant MAJOR_TYPE_BYTES = 2;
1048     uint8 private constant MAJOR_TYPE_STRING = 3;
1049     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1050     uint8 private constant MAJOR_TYPE_MAP = 5;
1051     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1052 
1053     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
1054         if(value <= 23) {
1055             buf.append(uint8((major << 5) | value));
1056         } else if(value <= 0xFF) {
1057             buf.append(uint8((major << 5) | 24));
1058             buf.appendInt(value, 1);
1059         } else if(value <= 0xFFFF) {
1060             buf.append(uint8((major << 5) | 25));
1061             buf.appendInt(value, 2);
1062         } else if(value <= 0xFFFFFFFF) {
1063             buf.append(uint8((major << 5) | 26));
1064             buf.appendInt(value, 4);
1065         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
1066             buf.append(uint8((major << 5) | 27));
1067             buf.appendInt(value, 8);
1068         }
1069     }
1070 
1071     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
1072         buf.append(uint8((major << 5) | 31));
1073     }
1074 
1075     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
1076         encodeType(buf, MAJOR_TYPE_INT, value);
1077     }
1078 
1079     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
1080         if(value >= 0) {
1081             encodeType(buf, MAJOR_TYPE_INT, uint(value));
1082         } else {
1083             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
1084         }
1085     }
1086 
1087     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
1088         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
1089         buf.append(value);
1090     }
1091 
1092     function encodeString(Buffer.buffer memory buf, string value) internal pure {
1093         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
1094         buf.append(bytes(value));
1095     }
1096 
1097     function startArray(Buffer.buffer memory buf) internal pure {
1098         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1099     }
1100 
1101     function startMap(Buffer.buffer memory buf) internal pure {
1102         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1103     }
1104 
1105     function endSequence(Buffer.buffer memory buf) internal pure {
1106         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1107     }
1108 }
1109 
1110 /*
1111 End solidity-cborutils
1112  */
1113 
1114 contract usingOraclize {
1115     uint constant day = 60*60*24;
1116     uint constant week = 60*60*24*7;
1117     uint constant month = 60*60*24*30;
1118     byte constant proofType_NONE = 0x00;
1119     byte constant proofType_TLSNotary = 0x10;
1120     byte constant proofType_Ledger = 0x30;
1121     byte constant proofType_Android = 0x40;
1122     byte constant proofType_Native = 0xF0;
1123     byte constant proofStorage_IPFS = 0x01;
1124     uint8 constant networkID_auto = 0;
1125     uint8 constant networkID_mainnet = 1;
1126     uint8 constant networkID_testnet = 2;
1127     uint8 constant networkID_morden = 2;
1128     uint8 constant networkID_consensys = 161;
1129 
1130     OraclizeAddrResolverI OAR;
1131 
1132     OraclizeI oraclize;
1133     modifier oraclizeAPI {
1134         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1135             oraclize_setNetwork(networkID_auto);
1136 
1137         if(address(oraclize) != OAR.getAddress())
1138             oraclize = OraclizeI(OAR.getAddress());
1139 
1140         _;
1141     }
1142     modifier coupon(string code){
1143         oraclize = OraclizeI(OAR.getAddress());
1144         _;
1145     }
1146 
1147     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1148       return oraclize_setNetwork();
1149       networkID; // silence the warning and remain backwards compatible
1150     }
1151     function oraclize_setNetwork() internal returns(bool){
1152         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1153             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1154             oraclize_setNetworkName("eth_mainnet");
1155             return true;
1156         }
1157         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1158             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1159             oraclize_setNetworkName("eth_ropsten3");
1160             return true;
1161         }
1162         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1163             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1164             oraclize_setNetworkName("eth_kovan");
1165             return true;
1166         }
1167         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1168             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1169             oraclize_setNetworkName("eth_rinkeby");
1170             return true;
1171         }
1172         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1173             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1174             return true;
1175         }
1176         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1177             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1178             return true;
1179         }
1180         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1181             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1182             return true;
1183         }
1184         return false;
1185     }
1186 
1187     function __callback(bytes32 myid, string result) public {
1188         __callback(myid, result, new bytes(0));
1189     }
1190     function __callback(bytes32 myid, string result, bytes proof) public {
1191       return;
1192       myid; result; proof; // Silence compiler warnings
1193     }
1194 
1195     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1196         return oraclize.getPrice(datasource);
1197     }
1198 
1199     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1200         return oraclize.getPrice(datasource, gaslimit);
1201     }
1202 
1203     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1204         uint price = oraclize.getPrice(datasource);
1205         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1206         return oraclize.query.value(price)(0, datasource, arg);
1207     }
1208     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1209         uint price = oraclize.getPrice(datasource);
1210         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1211         return oraclize.query.value(price)(timestamp, datasource, arg);
1212     }
1213     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1214         uint price = oraclize.getPrice(datasource, gaslimit);
1215         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1216         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1217     }
1218     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1219         uint price = oraclize.getPrice(datasource, gaslimit);
1220         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1221         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1222     }
1223     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1224         uint price = oraclize.getPrice(datasource);
1225         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1226         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1227     }
1228     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1229         uint price = oraclize.getPrice(datasource);
1230         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1231         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1232     }
1233     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1234         uint price = oraclize.getPrice(datasource, gaslimit);
1235         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1236         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1237     }
1238     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1239         uint price = oraclize.getPrice(datasource, gaslimit);
1240         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1241         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1242     }
1243     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1244         uint price = oraclize.getPrice(datasource);
1245         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1246         bytes memory args = stra2cbor(argN);
1247         return oraclize.queryN.value(price)(0, datasource, args);
1248     }
1249     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1250         uint price = oraclize.getPrice(datasource);
1251         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1252         bytes memory args = stra2cbor(argN);
1253         return oraclize.queryN.value(price)(timestamp, datasource, args);
1254     }
1255     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1256         uint price = oraclize.getPrice(datasource, gaslimit);
1257         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1258         bytes memory args = stra2cbor(argN);
1259         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1260     }
1261     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1262         uint price = oraclize.getPrice(datasource, gaslimit);
1263         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1264         bytes memory args = stra2cbor(argN);
1265         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1266     }
1267     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1268         string[] memory dynargs = new string[](1);
1269         dynargs[0] = args[0];
1270         return oraclize_query(datasource, dynargs);
1271     }
1272     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1273         string[] memory dynargs = new string[](1);
1274         dynargs[0] = args[0];
1275         return oraclize_query(timestamp, datasource, dynargs);
1276     }
1277     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1278         string[] memory dynargs = new string[](1);
1279         dynargs[0] = args[0];
1280         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1281     }
1282     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1283         string[] memory dynargs = new string[](1);
1284         dynargs[0] = args[0];
1285         return oraclize_query(datasource, dynargs, gaslimit);
1286     }
1287 
1288     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1289         string[] memory dynargs = new string[](2);
1290         dynargs[0] = args[0];
1291         dynargs[1] = args[1];
1292         return oraclize_query(datasource, dynargs);
1293     }
1294     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1295         string[] memory dynargs = new string[](2);
1296         dynargs[0] = args[0];
1297         dynargs[1] = args[1];
1298         return oraclize_query(timestamp, datasource, dynargs);
1299     }
1300     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1301         string[] memory dynargs = new string[](2);
1302         dynargs[0] = args[0];
1303         dynargs[1] = args[1];
1304         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1305     }
1306     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1307         string[] memory dynargs = new string[](2);
1308         dynargs[0] = args[0];
1309         dynargs[1] = args[1];
1310         return oraclize_query(datasource, dynargs, gaslimit);
1311     }
1312     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1313         string[] memory dynargs = new string[](3);
1314         dynargs[0] = args[0];
1315         dynargs[1] = args[1];
1316         dynargs[2] = args[2];
1317         return oraclize_query(datasource, dynargs);
1318     }
1319     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1320         string[] memory dynargs = new string[](3);
1321         dynargs[0] = args[0];
1322         dynargs[1] = args[1];
1323         dynargs[2] = args[2];
1324         return oraclize_query(timestamp, datasource, dynargs);
1325     }
1326     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1327         string[] memory dynargs = new string[](3);
1328         dynargs[0] = args[0];
1329         dynargs[1] = args[1];
1330         dynargs[2] = args[2];
1331         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1332     }
1333     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1334         string[] memory dynargs = new string[](3);
1335         dynargs[0] = args[0];
1336         dynargs[1] = args[1];
1337         dynargs[2] = args[2];
1338         return oraclize_query(datasource, dynargs, gaslimit);
1339     }
1340 
1341     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1342         string[] memory dynargs = new string[](4);
1343         dynargs[0] = args[0];
1344         dynargs[1] = args[1];
1345         dynargs[2] = args[2];
1346         dynargs[3] = args[3];
1347         return oraclize_query(datasource, dynargs);
1348     }
1349     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1350         string[] memory dynargs = new string[](4);
1351         dynargs[0] = args[0];
1352         dynargs[1] = args[1];
1353         dynargs[2] = args[2];
1354         dynargs[3] = args[3];
1355         return oraclize_query(timestamp, datasource, dynargs);
1356     }
1357     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1358         string[] memory dynargs = new string[](4);
1359         dynargs[0] = args[0];
1360         dynargs[1] = args[1];
1361         dynargs[2] = args[2];
1362         dynargs[3] = args[3];
1363         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1364     }
1365     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1366         string[] memory dynargs = new string[](4);
1367         dynargs[0] = args[0];
1368         dynargs[1] = args[1];
1369         dynargs[2] = args[2];
1370         dynargs[3] = args[3];
1371         return oraclize_query(datasource, dynargs, gaslimit);
1372     }
1373     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1374         string[] memory dynargs = new string[](5);
1375         dynargs[0] = args[0];
1376         dynargs[1] = args[1];
1377         dynargs[2] = args[2];
1378         dynargs[3] = args[3];
1379         dynargs[4] = args[4];
1380         return oraclize_query(datasource, dynargs);
1381     }
1382     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1383         string[] memory dynargs = new string[](5);
1384         dynargs[0] = args[0];
1385         dynargs[1] = args[1];
1386         dynargs[2] = args[2];
1387         dynargs[3] = args[3];
1388         dynargs[4] = args[4];
1389         return oraclize_query(timestamp, datasource, dynargs);
1390     }
1391     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1392         string[] memory dynargs = new string[](5);
1393         dynargs[0] = args[0];
1394         dynargs[1] = args[1];
1395         dynargs[2] = args[2];
1396         dynargs[3] = args[3];
1397         dynargs[4] = args[4];
1398         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1399     }
1400     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1401         string[] memory dynargs = new string[](5);
1402         dynargs[0] = args[0];
1403         dynargs[1] = args[1];
1404         dynargs[2] = args[2];
1405         dynargs[3] = args[3];
1406         dynargs[4] = args[4];
1407         return oraclize_query(datasource, dynargs, gaslimit);
1408     }
1409     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1410         uint price = oraclize.getPrice(datasource);
1411         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1412         bytes memory args = ba2cbor(argN);
1413         return oraclize.queryN.value(price)(0, datasource, args);
1414     }
1415     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1416         uint price = oraclize.getPrice(datasource);
1417         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1418         bytes memory args = ba2cbor(argN);
1419         return oraclize.queryN.value(price)(timestamp, datasource, args);
1420     }
1421     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1422         uint price = oraclize.getPrice(datasource, gaslimit);
1423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1424         bytes memory args = ba2cbor(argN);
1425         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1426     }
1427     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1428         uint price = oraclize.getPrice(datasource, gaslimit);
1429         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1430         bytes memory args = ba2cbor(argN);
1431         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1432     }
1433     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1434         bytes[] memory dynargs = new bytes[](1);
1435         dynargs[0] = args[0];
1436         return oraclize_query(datasource, dynargs);
1437     }
1438     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1439         bytes[] memory dynargs = new bytes[](1);
1440         dynargs[0] = args[0];
1441         return oraclize_query(timestamp, datasource, dynargs);
1442     }
1443     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1444         bytes[] memory dynargs = new bytes[](1);
1445         dynargs[0] = args[0];
1446         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1447     }
1448     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1449         bytes[] memory dynargs = new bytes[](1);
1450         dynargs[0] = args[0];
1451         return oraclize_query(datasource, dynargs, gaslimit);
1452     }
1453 
1454     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1455         bytes[] memory dynargs = new bytes[](2);
1456         dynargs[0] = args[0];
1457         dynargs[1] = args[1];
1458         return oraclize_query(datasource, dynargs);
1459     }
1460     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1461         bytes[] memory dynargs = new bytes[](2);
1462         dynargs[0] = args[0];
1463         dynargs[1] = args[1];
1464         return oraclize_query(timestamp, datasource, dynargs);
1465     }
1466     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1467         bytes[] memory dynargs = new bytes[](2);
1468         dynargs[0] = args[0];
1469         dynargs[1] = args[1];
1470         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1471     }
1472     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1473         bytes[] memory dynargs = new bytes[](2);
1474         dynargs[0] = args[0];
1475         dynargs[1] = args[1];
1476         return oraclize_query(datasource, dynargs, gaslimit);
1477     }
1478     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1479         bytes[] memory dynargs = new bytes[](3);
1480         dynargs[0] = args[0];
1481         dynargs[1] = args[1];
1482         dynargs[2] = args[2];
1483         return oraclize_query(datasource, dynargs);
1484     }
1485     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1486         bytes[] memory dynargs = new bytes[](3);
1487         dynargs[0] = args[0];
1488         dynargs[1] = args[1];
1489         dynargs[2] = args[2];
1490         return oraclize_query(timestamp, datasource, dynargs);
1491     }
1492     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1493         bytes[] memory dynargs = new bytes[](3);
1494         dynargs[0] = args[0];
1495         dynargs[1] = args[1];
1496         dynargs[2] = args[2];
1497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1498     }
1499     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1500         bytes[] memory dynargs = new bytes[](3);
1501         dynargs[0] = args[0];
1502         dynargs[1] = args[1];
1503         dynargs[2] = args[2];
1504         return oraclize_query(datasource, dynargs, gaslimit);
1505     }
1506 
1507     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1508         bytes[] memory dynargs = new bytes[](4);
1509         dynargs[0] = args[0];
1510         dynargs[1] = args[1];
1511         dynargs[2] = args[2];
1512         dynargs[3] = args[3];
1513         return oraclize_query(datasource, dynargs);
1514     }
1515     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1516         bytes[] memory dynargs = new bytes[](4);
1517         dynargs[0] = args[0];
1518         dynargs[1] = args[1];
1519         dynargs[2] = args[2];
1520         dynargs[3] = args[3];
1521         return oraclize_query(timestamp, datasource, dynargs);
1522     }
1523     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1524         bytes[] memory dynargs = new bytes[](4);
1525         dynargs[0] = args[0];
1526         dynargs[1] = args[1];
1527         dynargs[2] = args[2];
1528         dynargs[3] = args[3];
1529         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1530     }
1531     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1532         bytes[] memory dynargs = new bytes[](4);
1533         dynargs[0] = args[0];
1534         dynargs[1] = args[1];
1535         dynargs[2] = args[2];
1536         dynargs[3] = args[3];
1537         return oraclize_query(datasource, dynargs, gaslimit);
1538     }
1539     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1540         bytes[] memory dynargs = new bytes[](5);
1541         dynargs[0] = args[0];
1542         dynargs[1] = args[1];
1543         dynargs[2] = args[2];
1544         dynargs[3] = args[3];
1545         dynargs[4] = args[4];
1546         return oraclize_query(datasource, dynargs);
1547     }
1548     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1549         bytes[] memory dynargs = new bytes[](5);
1550         dynargs[0] = args[0];
1551         dynargs[1] = args[1];
1552         dynargs[2] = args[2];
1553         dynargs[3] = args[3];
1554         dynargs[4] = args[4];
1555         return oraclize_query(timestamp, datasource, dynargs);
1556     }
1557     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1558         bytes[] memory dynargs = new bytes[](5);
1559         dynargs[0] = args[0];
1560         dynargs[1] = args[1];
1561         dynargs[2] = args[2];
1562         dynargs[3] = args[3];
1563         dynargs[4] = args[4];
1564         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1565     }
1566     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1567         bytes[] memory dynargs = new bytes[](5);
1568         dynargs[0] = args[0];
1569         dynargs[1] = args[1];
1570         dynargs[2] = args[2];
1571         dynargs[3] = args[3];
1572         dynargs[4] = args[4];
1573         return oraclize_query(datasource, dynargs, gaslimit);
1574     }
1575 
1576     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1577         return oraclize.cbAddress();
1578     }
1579     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1580         return oraclize.setProofType(proofP);
1581     }
1582     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1583         return oraclize.setCustomGasPrice(gasPrice);
1584     }
1585 
1586     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1587         return oraclize.randomDS_getSessionPubKeyHash();
1588     }
1589 
1590     function getCodeSize(address _addr) constant internal returns(uint _size) {
1591         assembly {
1592             _size := extcodesize(_addr)
1593         }
1594     }
1595 
1596     function parseAddr(string _a) internal pure returns (address){
1597         bytes memory tmp = bytes(_a);
1598         uint160 iaddr = 0;
1599         uint160 b1;
1600         uint160 b2;
1601         for (uint i=2; i<2+2*20; i+=2){
1602             iaddr *= 256;
1603             b1 = uint160(tmp[i]);
1604             b2 = uint160(tmp[i+1]);
1605             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1606             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1607             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1608             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1609             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1610             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1611             iaddr += (b1*16+b2);
1612         }
1613         return address(iaddr);
1614     }
1615 
1616     function strCompare(string _a, string _b) internal pure returns (int) {
1617         bytes memory a = bytes(_a);
1618         bytes memory b = bytes(_b);
1619         uint minLength = a.length;
1620         if (b.length < minLength) minLength = b.length;
1621         for (uint i = 0; i < minLength; i ++)
1622             if (a[i] < b[i])
1623                 return -1;
1624             else if (a[i] > b[i])
1625                 return 1;
1626         if (a.length < b.length)
1627             return -1;
1628         else if (a.length > b.length)
1629             return 1;
1630         else
1631             return 0;
1632     }
1633 
1634     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1635         bytes memory h = bytes(_haystack);
1636         bytes memory n = bytes(_needle);
1637         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1638             return -1;
1639         else if(h.length > (2**128 -1))
1640             return -1;
1641         else
1642         {
1643             uint subindex = 0;
1644             for (uint i = 0; i < h.length; i ++)
1645             {
1646                 if (h[i] == n[0])
1647                 {
1648                     subindex = 1;
1649                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1650                     {
1651                         subindex++;
1652                     }
1653                     if(subindex == n.length)
1654                         return int(i);
1655                 }
1656             }
1657             return -1;
1658         }
1659     }
1660 
1661     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1662         bytes memory _ba = bytes(_a);
1663         bytes memory _bb = bytes(_b);
1664         bytes memory _bc = bytes(_c);
1665         bytes memory _bd = bytes(_d);
1666         bytes memory _be = bytes(_e);
1667         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1668         bytes memory babcde = bytes(abcde);
1669         uint k = 0;
1670         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1671         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1672         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1673         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1674         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1675         return string(babcde);
1676     }
1677 
1678     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1679         return strConcat(_a, _b, _c, _d, "");
1680     }
1681 
1682     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1683         return strConcat(_a, _b, _c, "", "");
1684     }
1685 
1686     function strConcat(string _a, string _b) internal pure returns (string) {
1687         return strConcat(_a, _b, "", "", "");
1688     }
1689 
1690     // parseInt
1691     function parseInt(string _a) internal pure returns (uint) {
1692         return parseInt(_a, 0);
1693     }
1694 
1695     // parseInt(parseFloat*10^_b)
1696     function parseInt(string _a, uint _b) internal pure returns (uint) {
1697         bytes memory bresult = bytes(_a);
1698         uint mint = 0;
1699         bool decimals = false;
1700         for (uint i=0; i<bresult.length; i++){
1701             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1702                 if (decimals){
1703                    if (_b == 0) break;
1704                     else _b--;
1705                 }
1706                 mint *= 10;
1707                 mint += uint(bresult[i]) - 48;
1708             } else if (bresult[i] == 46) decimals = true;
1709         }
1710         if (_b > 0) mint *= 10**_b;
1711         return mint;
1712     }
1713 
1714     function uint2str(uint i) internal pure returns (string){
1715         if (i == 0) return "0";
1716         uint j = i;
1717         uint len;
1718         while (j != 0){
1719             len++;
1720             j /= 10;
1721         }
1722         bytes memory bstr = new bytes(len);
1723         uint k = len - 1;
1724         while (i != 0){
1725             bstr[k--] = byte(48 + i % 10);
1726             i /= 10;
1727         }
1728         return string(bstr);
1729     }
1730 
1731     using CBOR for Buffer.buffer;
1732     function stra2cbor(string[] arr) internal pure returns (bytes) {
1733         safeMemoryCleaner();
1734         Buffer.buffer memory buf;
1735         Buffer.init(buf, 1024);
1736         buf.startArray();
1737         for (uint i = 0; i < arr.length; i++) {
1738             buf.encodeString(arr[i]);
1739         }
1740         buf.endSequence();
1741         return buf.buf;
1742     }
1743 
1744     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1745         safeMemoryCleaner();
1746         Buffer.buffer memory buf;
1747         Buffer.init(buf, 1024);
1748         buf.startArray();
1749         for (uint i = 0; i < arr.length; i++) {
1750             buf.encodeBytes(arr[i]);
1751         }
1752         buf.endSequence();
1753         return buf.buf;
1754     }
1755 
1756     string oraclize_network_name;
1757     function oraclize_setNetworkName(string _network_name) internal {
1758         oraclize_network_name = _network_name;
1759     }
1760 
1761     function oraclize_getNetworkName() internal view returns (string) {
1762         return oraclize_network_name;
1763     }
1764 
1765     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1766         require((_nbytes > 0) && (_nbytes <= 32));
1767         // Convert from seconds to ledger timer ticks
1768         _delay *= 10;
1769         bytes memory nbytes = new bytes(1);
1770         nbytes[0] = byte(_nbytes);
1771         bytes memory unonce = new bytes(32);
1772         bytes memory sessionKeyHash = new bytes(32);
1773         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1774         assembly {
1775             mstore(unonce, 0x20)
1776             // the following variables can be relaxed
1777             // check relaxed random contract under ethereum-examples repo
1778             // for an idea on how to override and replace comit hash vars
1779             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1780             mstore(sessionKeyHash, 0x20)
1781             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1782         }
1783         bytes memory delay = new bytes(32);
1784         assembly {
1785             mstore(add(delay, 0x20), _delay)
1786         }
1787 
1788         bytes memory delay_bytes8 = new bytes(8);
1789         copyBytes(delay, 24, 8, delay_bytes8, 0);
1790 
1791         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1792         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1793 
1794         bytes memory delay_bytes8_left = new bytes(8);
1795 
1796         assembly {
1797             let x := mload(add(delay_bytes8, 0x20))
1798             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1799             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1800             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1801             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1802             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1803             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1804             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1805             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1806 
1807         }
1808 
1809         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1810         return queryId;
1811     }
1812 
1813     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1814         oraclize_randomDS_args[queryId] = commitment;
1815     }
1816 
1817     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1818     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1819 
1820     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1821         bool sigok;
1822         address signer;
1823 
1824         bytes32 sigr;
1825         bytes32 sigs;
1826 
1827         bytes memory sigr_ = new bytes(32);
1828         uint offset = 4+(uint(dersig[3]) - 0x20);
1829         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1830         bytes memory sigs_ = new bytes(32);
1831         offset += 32 + 2;
1832         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1833 
1834         assembly {
1835             sigr := mload(add(sigr_, 32))
1836             sigs := mload(add(sigs_, 32))
1837         }
1838 
1839 
1840         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1841         if (address(keccak256(pubkey)) == signer) return true;
1842         else {
1843             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1844             return (address(keccak256(pubkey)) == signer);
1845         }
1846     }
1847 
1848     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1849         bool sigok;
1850 
1851         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1852         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1853         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1854 
1855         bytes memory appkey1_pubkey = new bytes(64);
1856         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1857 
1858         bytes memory tosign2 = new bytes(1+65+32);
1859         tosign2[0] = byte(1); //role
1860         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1861         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1862         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1863         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1864 
1865         if (sigok == false) return false;
1866 
1867 
1868         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1869         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1870 
1871         bytes memory tosign3 = new bytes(1+65);
1872         tosign3[0] = 0xFE;
1873         copyBytes(proof, 3, 65, tosign3, 1);
1874 
1875         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1876         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1877 
1878         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1879 
1880         return sigok;
1881     }
1882 
1883     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1884         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1885         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1886 
1887         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1888         require(proofVerified);
1889 
1890         _;
1891     }
1892 
1893     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1894         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1895         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1896 
1897         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1898         if (proofVerified == false) return 2;
1899 
1900         return 0;
1901     }
1902 
1903     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1904         bool match_ = true;
1905 
1906         require(prefix.length == n_random_bytes);
1907 
1908         for (uint256 i=0; i< n_random_bytes; i++) {
1909             if (content[i] != prefix[i]) match_ = false;
1910         }
1911 
1912         return match_;
1913     }
1914 
1915     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1916 
1917         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1918         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1919         bytes memory keyhash = new bytes(32);
1920         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1921         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1922 
1923         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1924         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1925 
1926         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1927         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1928 
1929         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1930         // This is to verify that the computed args match with the ones specified in the query.
1931         bytes memory commitmentSlice1 = new bytes(8+1+32);
1932         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1933 
1934         bytes memory sessionPubkey = new bytes(64);
1935         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1936         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1937 
1938         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1939         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1940             delete oraclize_randomDS_args[queryId];
1941         } else return false;
1942 
1943 
1944         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1945         bytes memory tosign1 = new bytes(32+8+1+32);
1946         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1947         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1948 
1949         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1950         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1951             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1952         }
1953 
1954         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1955     }
1956 
1957     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1958     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1959         uint minLength = length + toOffset;
1960 
1961         // Buffer too small
1962         require(to.length >= minLength); // Should be a better way?
1963 
1964         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1965         uint i = 32 + fromOffset;
1966         uint j = 32 + toOffset;
1967 
1968         while (i < (32 + fromOffset + length)) {
1969             assembly {
1970                 let tmp := mload(add(from, i))
1971                 mstore(add(to, j), tmp)
1972             }
1973             i += 32;
1974             j += 32;
1975         }
1976 
1977         return to;
1978     }
1979 
1980     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1981     // Duplicate Solidity's ecrecover, but catching the CALL return value
1982     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1983         // We do our own memory management here. Solidity uses memory offset
1984         // 0x40 to store the current end of memory. We write past it (as
1985         // writes are memory extensions), but don't update the offset so
1986         // Solidity will reuse it. The memory used here is only needed for
1987         // this context.
1988 
1989         // FIXME: inline assembly can't access return values
1990         bool ret;
1991         address addr;
1992 
1993         assembly {
1994             let size := mload(0x40)
1995             mstore(size, hash)
1996             mstore(add(size, 32), v)
1997             mstore(add(size, 64), r)
1998             mstore(add(size, 96), s)
1999 
2000             // NOTE: we can reuse the request memory because we deal with
2001             //       the return code
2002             ret := call(3000, 1, 0, size, 128, size, 32)
2003             addr := mload(size)
2004         }
2005 
2006         return (ret, addr);
2007     }
2008 
2009     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2010     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2011         bytes32 r;
2012         bytes32 s;
2013         uint8 v;
2014 
2015         if (sig.length != 65)
2016           return (false, 0);
2017 
2018         // The signature format is a compact form of:
2019         //   {bytes32 r}{bytes32 s}{uint8 v}
2020         // Compact means, uint8 is not padded to 32 bytes.
2021         assembly {
2022             r := mload(add(sig, 32))
2023             s := mload(add(sig, 64))
2024 
2025             // Here we are loading the last 32 bytes. We exploit the fact that
2026             // 'mload' will pad with zeroes if we overread.
2027             // There is no 'mload8' to do this, but that would be nicer.
2028             v := byte(0, mload(add(sig, 96)))
2029 
2030             // Alternative solution:
2031             // 'byte' is not working due to the Solidity parser, so lets
2032             // use the second best option, 'and'
2033             // v := and(mload(add(sig, 65)), 255)
2034         }
2035 
2036         // albeit non-transactional signatures are not specified by the YP, one would expect it
2037         // to match the YP range of [27, 28]
2038         //
2039         // geth uses [0, 1] and some clients have followed. This might change, see:
2040         //  https://github.com/ethereum/go-ethereum/issues/2053
2041         if (v < 27)
2042           v += 27;
2043 
2044         if (v != 27 && v != 28)
2045             return (false, 0);
2046 
2047         return safer_ecrecover(hash, v, r, s);
2048     }
2049 
2050     function safeMemoryCleaner() internal pure {
2051         assembly {
2052             let fmem := mload(0x40)
2053             codecopy(fmem, codesize, sub(msize, fmem))
2054         }
2055     }
2056 
2057 }
2058 // </ORACLIZE_API>
2059 
2060 contract PriceUpdaterInterface {
2061   enum Currency { ETH, BTC, WME, WMZ, WMR, WMX }
2062 
2063   uint public decimalPrecision = 3;
2064 
2065   mapping(uint => uint) public price;
2066 }
2067 
2068 contract PriceUpdater is usingOraclize, Ownable, PriceUpdaterInterface {
2069   using SafeMath for uint;
2070   using strings for *;
2071 
2072   uint public priceLastUpdate;
2073   uint public priceLastUpdateRequest;
2074   uint public priceUpdateInterval;
2075   uint public callbackGas = 150000;
2076   uint public maxInterval;
2077 
2078   constructor (uint _priceUpdateInterval, uint _maxInterval) public {
2079     priceUpdateInterval = _priceUpdateInterval;
2080     maxInterval = _maxInterval;
2081     price[uint(PriceUpdaterInterface.Currency.WME)] = 1000;
2082   }
2083 
2084   function withdraw() public onlyOwner {
2085     require(address(this).balance > 0);
2086     owner.transfer(address(this).balance);
2087   }
2088 
2089   function updatePrice() public payable {
2090     require(msg.sender == oraclize_cbAddress() || msg.sender == owner);
2091     // require(updateRequestExpired() && oraclize_getPrice("URL") > address(this).balance);
2092     require(updateRequestExpired());
2093     
2094     oraclize_query(
2095       priceUpdateInterval,
2096       "URL",
2097       "https://rates.web.money/rates/getrates.ashx?pairs=eth-eur_eur-wmx_eur-rub_eur-usd",
2098       callbackGas
2099     );
2100     priceLastUpdateRequest = getTime();
2101   }
2102 
2103   /// @notice Called on price update by Oraclize
2104   function __callback(bytes32 myid, string result, bytes proof) public {
2105     require(msg.sender == oraclize_cbAddress());
2106     setPrices(result);
2107     updatePrice();
2108   }
2109 
2110   function() external payable {
2111   }
2112 
2113   /// @notice set the price of currencies in euro, called in case we don't get oraclize data
2114   ///         for more than double the update interval
2115   /// @param _prices Currency rates in format "ethPrice;btcPrice;wmrPrice;wmzPrice" in euro
2116   function setPricesManually(string _prices) external onlyOwner {
2117     // allow for owners to change the price anytime if the price has expired
2118     require(priceExpired() || updateRequestExpired());
2119     setPrices(_prices);
2120   }
2121 
2122   function setPrices(string _prices) internal {
2123     var s = _prices.toSlice();
2124 
2125     price[uint(PriceUpdaterInterface.Currency.ETH)] = parseUint(s.split(";".toSlice()).toString(), decimalPrecision);
2126     price[uint(PriceUpdaterInterface.Currency.BTC)] = parseUint(s.split(";".toSlice()).toString(), decimalPrecision);
2127     price[uint(PriceUpdaterInterface.Currency.WMR)] = parseUint(s.split(";".toSlice()).toString(), decimalPrecision);
2128     price[uint(PriceUpdaterInterface.Currency.WMZ)] = parseUint(s.split(";".toSlice()).toString(), decimalPrecision);
2129     price[uint(PriceUpdaterInterface.Currency.WMX)] = price[uint(PriceUpdaterInterface.Currency.BTC)];
2130 
2131     priceLastUpdate = getTime();
2132   }
2133 
2134   function parseUint(string _a, uint _b) pure internal returns (uint) {
2135     bytes memory bresult = bytes(_a);
2136     uint mint = 0;
2137     bool decimals = false;
2138     for (uint i = 0; i < bresult.length; i++) {
2139       if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
2140         if (decimals) {
2141           if (_b == 0) break;
2142           else _b--;
2143         }
2144         mint *= 10;
2145         mint += uint(bresult[i]) - 48;
2146       } else if (bresult[i] == 46) {
2147         decimals = true;
2148       }
2149     }
2150     if (_b > 0) mint *= uint(10 ** _b);
2151     return mint;
2152   }
2153 
2154   function setOraclizeGasPrice(uint256 _gasPrice) external onlyOwner {
2155     oraclize_setCustomGasPrice(_gasPrice);
2156   }
2157 
2158   function setOraclizeGasLimit(uint _callbackGas) external onlyOwner {
2159     callbackGas = _callbackGas;
2160   }
2161 
2162   function setPriceUpdateInterval(uint _priceUpdateInterval) external onlyOwner {
2163     priceUpdateInterval = _priceUpdateInterval;
2164   }
2165 
2166   function setMaxInterval(uint _maxInterval) external onlyOwner {
2167     maxInterval = _maxInterval;
2168   }
2169 
2170   /// @dev Check that double the update interval has passed since last successful price update
2171   function priceExpired() public view returns (bool) {
2172     return (getTime() > priceLastUpdate + maxInterval);
2173   }
2174 
2175   /// @dev Check that price update was requested more than max interval ago
2176   function updateRequestExpired() public view returns (bool) {
2177     return getTime() >= (priceLastUpdateRequest + maxInterval);
2178   }
2179 
2180   /// @dev to be overridden in tests
2181   function getTime() internal view returns (uint256) {
2182     // solium-disable-next-line security/no-block-members
2183     return now;
2184   }
2185 }