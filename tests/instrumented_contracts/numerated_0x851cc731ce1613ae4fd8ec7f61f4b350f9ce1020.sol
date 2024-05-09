1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Owned
5  * @dev Basic contract to define an owner.
6  * @author Julien Niset - <julien@argent.xyz>
7  */
8 contract Owned {
9 
10     // The owner
11     address public owner;
12 
13     event OwnerChanged(address indexed _newOwner);
14 
15     /**
16      * @dev Throws if the sender is not the owner.
17      */
18     modifier onlyOwner {
19         require(msg.sender == owner, "Must be owner");
20         _;
21     }
22 
23     constructor() public {
24         owner = msg.sender;
25     }
26 
27     /**
28      * @dev Lets the owner transfer ownership of the contract to a new owner.
29      * @param _newOwner The new owner.
30      */
31     function changeOwner(address _newOwner) external onlyOwner {
32         require(_newOwner != address(0), "Address must not be null");
33         owner = _newOwner;
34         emit OwnerChanged(_newOwner);
35     }
36 }
37 
38 /**
39  * @title Managed
40  * @dev Basic contract that defines a set of managers. Only the owner can add/remove managers.
41  * @author Julien Niset - <julien@argent.xyz>
42  */
43 contract Managed is Owned {
44 
45     // The managers
46     mapping (address => bool) public managers;
47 
48     /**
49      * @dev Throws if the sender is not a manager.
50      */
51     modifier onlyManager {
52         require(managers[msg.sender] == true, "M: Must be manager");
53         _;
54     }
55 
56     event ManagerAdded(address indexed _manager);
57     event ManagerRevoked(address indexed _manager);
58 
59     /**
60     * @dev Adds a manager. 
61     * @param _manager The address of the manager.
62     */
63     function addManager(address _manager) external onlyOwner {
64         require(_manager != address(0), "M: Address must not be null");
65         if(managers[_manager] == false) {
66             managers[_manager] = true;
67             emit ManagerAdded(_manager);
68         }        
69     }
70 
71     /**
72     * @dev Revokes a manager.
73     * @param _manager The address of the manager.
74     */
75     function revokeManager(address _manager) external onlyOwner {
76         require(managers[_manager] == true, "M: Target must be an existing manager");
77         delete managers[_manager];
78         emit ManagerRevoked(_manager);
79     }
80 }
81 
82 /**
83  * ENS Registry interface.
84  */
85 contract ENSRegistry {
86     function owner(bytes32 _node) public view returns (address);
87     function resolver(bytes32 _node) public view returns (address);
88     function ttl(bytes32 _node) public view returns (uint64);
89     function setOwner(bytes32 _node, address _owner) public;
90     function setSubnodeOwner(bytes32 _node, bytes32 _label, address _owner) public;
91     function setResolver(bytes32 _node, address _resolver) public;
92     function setTTL(bytes32 _node, uint64 _ttl) public;
93 }
94 
95 /**
96  * ENS Resolver interface.
97  */
98 contract ENSResolver {
99     function addr(bytes32 _node) public view returns (address);
100     function setAddr(bytes32 _node, address _addr) public;
101     function name(bytes32 _node) public view returns (string);
102     function setName(bytes32 _node, string _name) public;
103 }
104 
105 /**
106  * ENS Reverse Registrar interface.
107  */
108 contract ENSReverseRegistrar {
109     function claim(address _owner) public returns (bytes32 _node);
110     function claimWithResolver(address _owner, address _resolver) public returns (bytes32);
111     function setName(string _name) public returns (bytes32);
112     function node(address _addr) public view returns (bytes32);
113 }
114 
115 /*
116  * @title String & slice utility library for Solidity contracts.
117  * @author Nick Johnson <arachnid@notdot.net>
118  *
119  * @dev Functionality in this library is largely implemented using an
120  *      abstraction called a 'slice'. A slice represents a part of a string -
121  *      anything from the entire string to a single character, or even no
122  *      characters at all (a 0-length slice). Since a slice only has to specify
123  *      an offset and a length, copying and manipulating slices is a lot less
124  *      expensive than copying and manipulating the strings they reference.
125  *
126  *      To further reduce gas costs, most functions on slice that need to return
127  *      a slice modify the original one instead of allocating a new one; for
128  *      instance, `s.split(".")` will return the text up to the first '.',
129  *      modifying s to only contain the remainder of the string after the '.'.
130  *      In situations where you do not want to modify the original slice, you
131  *      can make a copy first with `.copy()`, for example:
132  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
133  *      Solidity has no memory management, it will result in allocating many
134  *      short-lived slices that are later discarded.
135  *
136  *      Functions that return two slices come in two versions: a non-allocating
137  *      version that takes the second slice as an argument, modifying it in
138  *      place, and an allocating version that allocates and returns the second
139  *      slice; see `nextRune` for example.
140  *
141  *      Functions that have to copy string data will return strings rather than
142  *      slices; these can be cast back to slices for further processing if
143  *      required.
144  *
145  *      For convenience, some functions are provided with non-modifying
146  *      variants that create a new slice and return both; for instance,
147  *      `s.splitNew('.')` leaves s unmodified, and returns two values
148  *      corresponding to the left and right parts of the string.
149  */
150 /* solium-disable */
151 library strings {
152     struct slice {
153         uint _len;
154         uint _ptr;
155     }
156 
157     function memcpy(uint dest, uint src, uint len) private pure {
158         // Copy word-length chunks while possible
159         for(; len >= 32; len -= 32) {
160             assembly {
161                 mstore(dest, mload(src))
162             }
163             dest += 32;
164             src += 32;
165         }
166 
167         // Copy remaining bytes
168         uint mask = 256 ** (32 - len) - 1;
169         assembly {
170             let srcpart := and(mload(src), not(mask))
171             let destpart := and(mload(dest), mask)
172             mstore(dest, or(destpart, srcpart))
173         }
174     }
175 
176     /*
177      * @dev Returns a slice containing the entire string.
178      * @param self The string to make a slice from.
179      * @return A newly allocated slice containing the entire string.
180      */
181     function toSlice(string memory self) internal pure returns (slice memory) {
182         uint ptr;
183         assembly {
184             ptr := add(self, 0x20)
185         }
186         return slice(bytes(self).length, ptr);
187     }
188 
189     /*
190      * @dev Returns the length of a null-terminated bytes32 string.
191      * @param self The value to find the length of.
192      * @return The length of the string, from 0 to 32.
193      */
194     function len(bytes32 self) internal pure returns (uint) {
195         uint ret;
196         if (self == 0)
197             return 0;
198         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
199             ret += 16;
200             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
201         }
202         if (self & 0xffffffffffffffff == 0) {
203             ret += 8;
204             self = bytes32(uint(self) / 0x10000000000000000);
205         }
206         if (self & 0xffffffff == 0) {
207             ret += 4;
208             self = bytes32(uint(self) / 0x100000000);
209         }
210         if (self & 0xffff == 0) {
211             ret += 2;
212             self = bytes32(uint(self) / 0x10000);
213         }
214         if (self & 0xff == 0) {
215             ret += 1;
216         }
217         return 32 - ret;
218     }
219 
220     /*
221      * @dev Returns a slice containing the entire bytes32, interpreted as a
222      *      null-terminated utf-8 string.
223      * @param self The bytes32 value to convert to a slice.
224      * @return A new slice containing the value of the input argument up to the
225      *         first null.
226      */
227     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
228         // Allocate space for `self` in memory, copy it there, and point ret at it
229         assembly {
230             let ptr := mload(0x40)
231             mstore(0x40, add(ptr, 0x20))
232             mstore(ptr, self)
233             mstore(add(ret, 0x20), ptr)
234         }
235         ret._len = len(self);
236     }
237 
238     /*
239      * @dev Returns a new slice containing the same data as the current slice.
240      * @param self The slice to copy.
241      * @return A new slice containing the same data as `self`.
242      */
243     function copy(slice memory self) internal pure returns (slice memory) {
244         return slice(self._len, self._ptr);
245     }
246 
247     /*
248      * @dev Copies a slice to a new string.
249      * @param self The slice to copy.
250      * @return A newly allocated string containing the slice's text.
251      */
252     function toString(slice memory self) internal pure returns (string memory) {
253         string memory ret = new string(self._len);
254         uint retptr;
255         assembly { retptr := add(ret, 32) }
256 
257         memcpy(retptr, self._ptr, self._len);
258         return ret;
259     }
260 
261     /*
262      * @dev Returns the length in runes of the slice. Note that this operation
263      *      takes time proportional to the length of the slice; avoid using it
264      *      in loops, and call `slice.empty()` if you only need to know whether
265      *      the slice is empty or not.
266      * @param self The slice to operate on.
267      * @return The length of the slice in runes.
268      */
269     function len(slice memory self) internal pure returns (uint l) {
270         // Starting at ptr-31 means the LSB will be the byte we care about
271         uint ptr = self._ptr - 31;
272         uint end = ptr + self._len;
273         for (l = 0; ptr < end; l++) {
274             uint8 b;
275             assembly { b := and(mload(ptr), 0xFF) }
276             if (b < 0x80) {
277                 ptr += 1;
278             } else if(b < 0xE0) {
279                 ptr += 2;
280             } else if(b < 0xF0) {
281                 ptr += 3;
282             } else if(b < 0xF8) {
283                 ptr += 4;
284             } else if(b < 0xFC) {
285                 ptr += 5;
286             } else {
287                 ptr += 6;
288             }
289         }
290     }
291 
292     /*
293      * @dev Returns true if the slice is empty (has a length of 0).
294      * @param self The slice to operate on.
295      * @return True if the slice is empty, False otherwise.
296      */
297     function empty(slice memory self) internal pure returns (bool) {
298         return self._len == 0;
299     }
300 
301     /*
302      * @dev Returns a positive number if `other` comes lexicographically after
303      *      `self`, a negative number if it comes before, or zero if the
304      *      contents of the two slices are equal. Comparison is done per-rune,
305      *      on unicode codepoints.
306      * @param self The first slice to compare.
307      * @param other The second slice to compare.
308      * @return The result of the comparison.
309      */
310     function compare(slice memory self, slice memory other) internal pure returns (int) {
311         uint shortest = self._len;
312         if (other._len < self._len)
313             shortest = other._len;
314 
315         uint selfptr = self._ptr;
316         uint otherptr = other._ptr;
317         for (uint idx = 0; idx < shortest; idx += 32) {
318             uint a;
319             uint b;
320             assembly {
321                 a := mload(selfptr)
322                 b := mload(otherptr)
323             }
324             if (a != b) {
325                 // Mask out irrelevant bytes and check again
326                 uint256 mask = uint256(-1); // 0xffff...
327                 if(shortest < 32) {
328                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
329                 }
330                 uint256 diff = (a & mask) - (b & mask);
331                 if (diff != 0)
332                     return int(diff);
333             }
334             selfptr += 32;
335             otherptr += 32;
336         }
337         return int(self._len) - int(other._len);
338     }
339 
340     /*
341      * @dev Returns true if the two slices contain the same text.
342      * @param self The first slice to compare.
343      * @param self The second slice to compare.
344      * @return True if the slices are equal, false otherwise.
345      */
346     function equals(slice memory self, slice memory other) internal pure returns (bool) {
347         return compare(self, other) == 0;
348     }
349 
350     /*
351      * @dev Extracts the first rune in the slice into `rune`, advancing the
352      *      slice to point to the next rune and returning `self`.
353      * @param self The slice to operate on.
354      * @param rune The slice that will contain the first rune.
355      * @return `rune`.
356      */
357     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
358         rune._ptr = self._ptr;
359 
360         if (self._len == 0) {
361             rune._len = 0;
362             return rune;
363         }
364 
365         uint l;
366         uint b;
367         // Load the first byte of the rune into the LSBs of b
368         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
369         if (b < 0x80) {
370             l = 1;
371         } else if(b < 0xE0) {
372             l = 2;
373         } else if(b < 0xF0) {
374             l = 3;
375         } else {
376             l = 4;
377         }
378 
379         // Check for truncated codepoints
380         if (l > self._len) {
381             rune._len = self._len;
382             self._ptr += self._len;
383             self._len = 0;
384             return rune;
385         }
386 
387         self._ptr += l;
388         self._len -= l;
389         rune._len = l;
390         return rune;
391     }
392 
393     /*
394      * @dev Returns the first rune in the slice, advancing the slice to point
395      *      to the next rune.
396      * @param self The slice to operate on.
397      * @return A slice containing only the first rune from `self`.
398      */
399     function nextRune(slice memory self) internal pure returns (slice memory ret) {
400         nextRune(self, ret);
401     }
402 
403     /*
404      * @dev Returns the number of the first codepoint in the slice.
405      * @param self The slice to operate on.
406      * @return The number of the first codepoint in the slice.
407      */
408     function ord(slice memory self) internal pure returns (uint ret) {
409         if (self._len == 0) {
410             return 0;
411         }
412 
413         uint word;
414         uint length;
415         uint divisor = 2 ** 248;
416 
417         // Load the rune into the MSBs of b
418         assembly { word:= mload(mload(add(self, 32))) }
419         uint b = word / divisor;
420         if (b < 0x80) {
421             ret = b;
422             length = 1;
423         } else if(b < 0xE0) {
424             ret = b & 0x1F;
425             length = 2;
426         } else if(b < 0xF0) {
427             ret = b & 0x0F;
428             length = 3;
429         } else {
430             ret = b & 0x07;
431             length = 4;
432         }
433 
434         // Check for truncated codepoints
435         if (length > self._len) {
436             return 0;
437         }
438 
439         for (uint i = 1; i < length; i++) {
440             divisor = divisor / 256;
441             b = (word / divisor) & 0xFF;
442             if (b & 0xC0 != 0x80) {
443                 // Invalid UTF-8 sequence
444                 return 0;
445             }
446             ret = (ret * 64) | (b & 0x3F);
447         }
448 
449         return ret;
450     }
451 
452     /*
453      * @dev Returns the keccak-256 hash of the slice.
454      * @param self The slice to hash.
455      * @return The hash of the slice.
456      */
457     function keccak(slice memory self) internal pure returns (bytes32 ret) {
458         assembly {
459             ret := keccak256(mload(add(self, 32)), mload(self))
460         }
461     }
462 
463     /*
464      * @dev Returns true if `self` starts with `needle`.
465      * @param self The slice to operate on.
466      * @param needle The slice to search for.
467      * @return True if the slice starts with the provided text, false otherwise.
468      */
469     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
470         if (self._len < needle._len) {
471             return false;
472         }
473 
474         if (self._ptr == needle._ptr) {
475             return true;
476         }
477 
478         bool equal;
479         assembly {
480             let length := mload(needle)
481             let selfptr := mload(add(self, 0x20))
482             let needleptr := mload(add(needle, 0x20))
483             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
484         }
485         return equal;
486     }
487 
488     /*
489      * @dev If `self` starts with `needle`, `needle` is removed from the
490      *      beginning of `self`. Otherwise, `self` is unmodified.
491      * @param self The slice to operate on.
492      * @param needle The slice to search for.
493      * @return `self`
494      */
495     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
496         if (self._len < needle._len) {
497             return self;
498         }
499 
500         bool equal = true;
501         if (self._ptr != needle._ptr) {
502             assembly {
503                 let length := mload(needle)
504                 let selfptr := mload(add(self, 0x20))
505                 let needleptr := mload(add(needle, 0x20))
506                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
507             }
508         }
509 
510         if (equal) {
511             self._len -= needle._len;
512             self._ptr += needle._len;
513         }
514 
515         return self;
516     }
517 
518     /*
519      * @dev Returns true if the slice ends with `needle`.
520      * @param self The slice to operate on.
521      * @param needle The slice to search for.
522      * @return True if the slice starts with the provided text, false otherwise.
523      */
524     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
525         if (self._len < needle._len) {
526             return false;
527         }
528 
529         uint selfptr = self._ptr + self._len - needle._len;
530 
531         if (selfptr == needle._ptr) {
532             return true;
533         }
534 
535         bool equal;
536         assembly {
537             let length := mload(needle)
538             let needleptr := mload(add(needle, 0x20))
539             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
540         }
541 
542         return equal;
543     }
544 
545     /*
546      * @dev If `self` ends with `needle`, `needle` is removed from the
547      *      end of `self`. Otherwise, `self` is unmodified.
548      * @param self The slice to operate on.
549      * @param needle The slice to search for.
550      * @return `self`
551      */
552     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
553         if (self._len < needle._len) {
554             return self;
555         }
556 
557         uint selfptr = self._ptr + self._len - needle._len;
558         bool equal = true;
559         if (selfptr != needle._ptr) {
560             assembly {
561                 let length := mload(needle)
562                 let needleptr := mload(add(needle, 0x20))
563                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
564             }
565         }
566 
567         if (equal) {
568             self._len -= needle._len;
569         }
570 
571         return self;
572     }
573 
574     // Returns the memory address of the first byte of the first occurrence of
575     // `needle` in `self`, or the first byte after `self` if not found.
576     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
577         uint ptr = selfptr;
578         uint idx;
579 
580         if (needlelen <= selflen) {
581             if (needlelen <= 32) {
582                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
583 
584                 bytes32 needledata;
585                 assembly { needledata := and(mload(needleptr), mask) }
586 
587                 uint end = selfptr + selflen - needlelen;
588                 bytes32 ptrdata;
589                 assembly { ptrdata := and(mload(ptr), mask) }
590 
591                 while (ptrdata != needledata) {
592                     if (ptr >= end)
593                         return selfptr + selflen;
594                     ptr++;
595                     assembly { ptrdata := and(mload(ptr), mask) }
596                 }
597                 return ptr;
598             } else {
599                 // For long needles, use hashing
600                 bytes32 hash;
601                 assembly { hash := keccak256(needleptr, needlelen) }
602 
603                 for (idx = 0; idx <= selflen - needlelen; idx++) {
604                     bytes32 testHash;
605                     assembly { testHash := keccak256(ptr, needlelen) }
606                     if (hash == testHash)
607                         return ptr;
608                     ptr += 1;
609                 }
610             }
611         }
612         return selfptr + selflen;
613     }
614 
615     // Returns the memory address of the first byte after the last occurrence of
616     // `needle` in `self`, or the address of `self` if not found.
617     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
618         uint ptr;
619 
620         if (needlelen <= selflen) {
621             if (needlelen <= 32) {
622                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
623 
624                 bytes32 needledata;
625                 assembly { needledata := and(mload(needleptr), mask) }
626 
627                 ptr = selfptr + selflen - needlelen;
628                 bytes32 ptrdata;
629                 assembly { ptrdata := and(mload(ptr), mask) }
630 
631                 while (ptrdata != needledata) {
632                     if (ptr <= selfptr)
633                         return selfptr;
634                     ptr--;
635                     assembly { ptrdata := and(mload(ptr), mask) }
636                 }
637                 return ptr + needlelen;
638             } else {
639                 // For long needles, use hashing
640                 bytes32 hash;
641                 assembly { hash := keccak256(needleptr, needlelen) }
642                 ptr = selfptr + (selflen - needlelen);
643                 while (ptr >= selfptr) {
644                     bytes32 testHash;
645                     assembly { testHash := keccak256(ptr, needlelen) }
646                     if (hash == testHash)
647                         return ptr + needlelen;
648                     ptr -= 1;
649                 }
650             }
651         }
652         return selfptr;
653     }
654 
655     /*
656      * @dev Modifies `self` to contain everything from the first occurrence of
657      *      `needle` to the end of the slice. `self` is set to the empty slice
658      *      if `needle` is not found.
659      * @param self The slice to search and modify.
660      * @param needle The text to search for.
661      * @return `self`.
662      */
663     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
664         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
665         self._len -= ptr - self._ptr;
666         self._ptr = ptr;
667         return self;
668     }
669 
670     /*
671      * @dev Modifies `self` to contain the part of the string from the start of
672      *      `self` to the end of the first occurrence of `needle`. If `needle`
673      *      is not found, `self` is set to the empty slice.
674      * @param self The slice to search and modify.
675      * @param needle The text to search for.
676      * @return `self`.
677      */
678     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
679         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
680         self._len = ptr - self._ptr;
681         return self;
682     }
683 
684     /*
685      * @dev Splits the slice, setting `self` to everything after the first
686      *      occurrence of `needle`, and `token` to everything before it. If
687      *      `needle` does not occur in `self`, `self` is set to the empty slice,
688      *      and `token` is set to the entirety of `self`.
689      * @param self The slice to split.
690      * @param needle The text to search for in `self`.
691      * @param token An output parameter to which the first token is written.
692      * @return `token`.
693      */
694     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
695         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
696         token._ptr = self._ptr;
697         token._len = ptr - self._ptr;
698         if (ptr == self._ptr + self._len) {
699             // Not found
700             self._len = 0;
701         } else {
702             self._len -= token._len + needle._len;
703             self._ptr = ptr + needle._len;
704         }
705         return token;
706     }
707 
708     /*
709      * @dev Splits the slice, setting `self` to everything after the first
710      *      occurrence of `needle`, and returning everything before it. If
711      *      `needle` does not occur in `self`, `self` is set to the empty slice,
712      *      and the entirety of `self` is returned.
713      * @param self The slice to split.
714      * @param needle The text to search for in `self`.
715      * @return The part of `self` up to the first occurrence of `delim`.
716      */
717     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
718         split(self, needle, token);
719     }
720 
721     /*
722      * @dev Splits the slice, setting `self` to everything before the last
723      *      occurrence of `needle`, and `token` to everything after it. If
724      *      `needle` does not occur in `self`, `self` is set to the empty slice,
725      *      and `token` is set to the entirety of `self`.
726      * @param self The slice to split.
727      * @param needle The text to search for in `self`.
728      * @param token An output parameter to which the first token is written.
729      * @return `token`.
730      */
731     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
732         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
733         token._ptr = ptr;
734         token._len = self._len - (ptr - self._ptr);
735         if (ptr == self._ptr) {
736             // Not found
737             self._len = 0;
738         } else {
739             self._len -= token._len + needle._len;
740         }
741         return token;
742     }
743 
744     /*
745      * @dev Splits the slice, setting `self` to everything before the last
746      *      occurrence of `needle`, and returning everything after it. If
747      *      `needle` does not occur in `self`, `self` is set to the empty slice,
748      *      and the entirety of `self` is returned.
749      * @param self The slice to split.
750      * @param needle The text to search for in `self`.
751      * @return The part of `self` after the last occurrence of `delim`.
752      */
753     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
754         rsplit(self, needle, token);
755     }
756 
757     /*
758      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
759      * @param self The slice to search.
760      * @param needle The text to search for in `self`.
761      * @return The number of occurrences of `needle` found in `self`.
762      */
763     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
764         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
765         while (ptr <= self._ptr + self._len) {
766             cnt++;
767             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
768         }
769     }
770 
771     /*
772      * @dev Returns True if `self` contains `needle`.
773      * @param self The slice to search.
774      * @param needle The text to search for in `self`.
775      * @return True if `needle` is found in `self`, false otherwise.
776      */
777     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
778         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
779     }
780 
781     /*
782      * @dev Returns a newly allocated string containing the concatenation of
783      *      `self` and `other`.
784      * @param self The first slice to concatenate.
785      * @param other The second slice to concatenate.
786      * @return The concatenation of the two strings.
787      */
788     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
789         string memory ret = new string(self._len + other._len);
790         uint retptr;
791         assembly { retptr := add(ret, 32) }
792         memcpy(retptr, self._ptr, self._len);
793         memcpy(retptr + self._len, other._ptr, other._len);
794         return ret;
795     }
796 
797     /*
798      * @dev Joins an array of slices, using `self` as a delimiter, returning a
799      *      newly allocated string.
800      * @param self The delimiter to use.
801      * @param parts A list of slices to join.
802      * @return A newly allocated string containing all the slices in `parts`,
803      *         joined with `self`.
804      */
805     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
806         if (parts.length == 0)
807             return "";
808 
809         uint length = self._len * (parts.length - 1);
810         for(uint i = 0; i < parts.length; i++)
811             length += parts[i]._len;
812 
813         string memory ret = new string(length);
814         uint retptr;
815         assembly { retptr := add(ret, 32) }
816 
817         for(i = 0; i < parts.length; i++) {
818             memcpy(retptr, parts[i]._ptr, parts[i]._len);
819             retptr += parts[i]._len;
820             if (i < parts.length - 1) {
821                 memcpy(retptr, self._ptr, self._len);
822                 retptr += self._len;
823             }
824         }
825 
826         return ret;
827     }
828 }
829 
830 /**
831  * @title ENSConsumer
832  * @dev Helper contract to resolve ENS names.
833  * @author Julien Niset - <julien@argent.xyz>
834  */
835 contract ENSConsumer {
836 
837     using strings for *;
838 
839     // namehash('addr.reverse')
840     bytes32 constant public ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
841 
842     // the address of the ENS registry
843     address ensRegistry;
844 
845     /**
846     * @dev No address should be provided when deploying on Mainnet to avoid storage cost. The 
847     * contract will use the hardcoded value.
848     */
849     constructor(address _ensRegistry) public {
850         ensRegistry = _ensRegistry;
851     }
852 
853     /**
854     * @dev Resolves an ENS name to an address.
855     * @param _node The namehash of the ENS name. 
856     */
857     function resolveEns(bytes32 _node) public view returns (address) {
858         address resolver = getENSRegistry().resolver(_node);
859         return ENSResolver(resolver).addr(_node);
860     }
861 
862     /**
863     * @dev Gets the official ENS registry.
864     */
865     function getENSRegistry() public view returns (ENSRegistry) {
866         return ENSRegistry(ensRegistry);
867     }
868 
869     /**
870     * @dev Gets the official ENS reverse registrar. 
871     */
872     function getENSReverseRegistrar() public view returns (ENSReverseRegistrar) {
873         return ENSReverseRegistrar(getENSRegistry().owner(ADDR_REVERSE_NODE));
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
887  * @title Proxy
888  * @dev Basic proxy that delegates all calls to a fixed implementing contract.
889  * The implementing contract cannot be upgraded.
890  * @author Julien Niset - <julien@argent.xyz>
891  */
892 contract Proxy {
893 
894     address implementation;
895 
896     event Received(uint indexed value, address indexed sender, bytes data);
897 
898     constructor(address _implementation) public {
899         implementation = _implementation;
900     }
901 
902     function() external payable {
903 
904         if(msg.data.length == 0 && msg.value > 0) { 
905             emit Received(msg.value, msg.sender, msg.data); 
906         }
907         else {
908             // solium-disable-next-line security/no-inline-assembly
909             assembly {
910                 let target := sload(0)
911                 calldatacopy(0, 0, calldatasize())
912                 let result := delegatecall(gas, target, 0, calldatasize(), 0, 0)
913                 returndatacopy(0, 0, returndatasize())
914                 switch result 
915                 case 0 {revert(0, returndatasize())} 
916                 default {return (0, returndatasize())}
917             }
918         }
919     }
920 }
921 
922 /**
923  * @title Module
924  * @dev Interface for a module. 
925  * A module MUST implement the addModule() method to ensure that a wallet with at least one module
926  * can never end up in a "frozen" state.
927  * @author Julien Niset - <julien@argent.xyz>
928  */
929 interface Module {
930 
931     /**
932      * @dev Inits a module for a wallet by e.g. setting some wallet specific parameters in storage.
933      * @param _wallet The wallet.
934      */
935     function init(BaseWallet _wallet) external;
936 
937     /**
938      * @dev Adds a module to a wallet.
939      * @param _wallet The target wallet.
940      * @param _module The modules to authorise.
941      */
942     function addModule(BaseWallet _wallet, Module _module) external;
943 
944     /**
945     * @dev Utility method to recover any ERC20 token that was sent to the
946     * module by mistake. 
947     * @param _token The token to recover.
948     */
949     function recoverToken(address _token) external;
950 }
951 
952 /**
953  * @title BaseWallet
954  * @dev Simple modular wallet that authorises modules to call its invoke() method.
955  * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
956  * @author Julien Niset - <julien@argent.xyz>
957  */
958 contract BaseWallet {
959 
960     // The implementation of the proxy
961     address public implementation;
962     // The owner 
963     address public owner;
964     // The authorised modules
965     mapping (address => bool) public authorised;
966     // The enabled static calls
967     mapping (bytes4 => address) public enabled;
968     // The number of modules
969     uint public modules;
970     
971     event AuthorisedModule(address indexed module, bool value);
972     event EnabledStaticCall(address indexed module, bytes4 indexed method);
973     event Invoked(address indexed module, address indexed target, uint indexed value, bytes data);
974     event Received(uint indexed value, address indexed sender, bytes data);
975     event OwnerChanged(address owner);
976     
977     /**
978      * @dev Throws if the sender is not an authorised module.
979      */
980     modifier moduleOnly {
981         require(authorised[msg.sender], "BW: msg.sender not an authorized module");
982         _;
983     }
984 
985     /**
986      * @dev Inits the wallet by setting the owner and authorising a list of modules.
987      * @param _owner The owner.
988      * @param _modules The modules to authorise.
989      */
990     function init(address _owner, address[] _modules) external {
991         require(owner == address(0) && modules == 0, "BW: wallet already initialised");
992         require(_modules.length > 0, "BW: construction requires at least 1 module");
993         owner = _owner;
994         modules = _modules.length;
995         for(uint256 i = 0; i < _modules.length; i++) {
996             require(authorised[_modules[i]] == false, "BW: module is already added");
997             authorised[_modules[i]] = true;
998             Module(_modules[i]).init(this);
999             emit AuthorisedModule(_modules[i], true);
1000         }
1001     }
1002     
1003     /**
1004      * @dev Enables/Disables a module.
1005      * @param _module The target module.
1006      * @param _value Set to true to authorise the module.
1007      */
1008     function authoriseModule(address _module, bool _value) external moduleOnly {
1009         if (authorised[_module] != _value) {
1010             if(_value == true) {
1011                 modules += 1;
1012                 authorised[_module] = true;
1013                 Module(_module).init(this);
1014             }
1015             else {
1016                 modules -= 1;
1017                 require(modules > 0, "BW: wallet must have at least one module");
1018                 delete authorised[_module];
1019             }
1020             emit AuthorisedModule(_module, _value);
1021         }
1022     }
1023 
1024     /**
1025     * @dev Enables a static method by specifying the target module to which the call
1026     * must be delegated.
1027     * @param _module The target module.
1028     * @param _method The static method signature.
1029     */
1030     function enableStaticCall(address _module, bytes4 _method) external moduleOnly {
1031         require(authorised[_module], "BW: must be an authorised module for static call");
1032         enabled[_method] = _module;
1033         emit EnabledStaticCall(_module, _method);
1034     }
1035 
1036     /**
1037      * @dev Sets a new owner for the wallet.
1038      * @param _newOwner The new owner.
1039      */
1040     function setOwner(address _newOwner) external moduleOnly {
1041         require(_newOwner != address(0), "BW: address cannot be null");
1042         owner = _newOwner;
1043         emit OwnerChanged(_newOwner);
1044     }
1045     
1046     /**
1047      * @dev Performs a generic transaction.
1048      * @param _target The address for the transaction.
1049      * @param _value The value of the transaction.
1050      * @param _data The data of the transaction.
1051      */
1052     function invoke(address _target, uint _value, bytes _data) external moduleOnly {
1053         // solium-disable-next-line security/no-call-value
1054         require(_target.call.value(_value)(_data), "BW: call to target failed");
1055         emit Invoked(msg.sender, _target, _value, _data);
1056     }
1057 
1058     /**
1059      * @dev This method makes it possible for the wallet to comply to interfaces expecting the wallet to
1060      * implement specific static methods. It delegates the static call to a target contract if the data corresponds 
1061      * to an enabled method, or logs the call otherwise.
1062      */
1063     function() public payable {
1064         if(msg.data.length > 0) { 
1065             address module = enabled[msg.sig];
1066             if(module == address(0)) {
1067                 emit Received(msg.value, msg.sender, msg.data);
1068             } 
1069             else {
1070                 require(authorised[module], "BW: must be an authorised module for static call");
1071                 // solium-disable-next-line security/no-inline-assembly
1072                 assembly {
1073                     calldatacopy(0, 0, calldatasize())
1074                     let result := staticcall(gas, module, 0, calldatasize(), 0, 0)
1075                     returndatacopy(0, 0, returndatasize())
1076                     switch result 
1077                     case 0 {revert(0, returndatasize())} 
1078                     default {return (0, returndatasize())}
1079                 }
1080             }
1081         }
1082     }
1083 }
1084 
1085 /**
1086  * ERC20 contract interface.
1087  */
1088 contract ERC20 {
1089     function totalSupply() public view returns (uint);
1090     function decimals() public view returns (uint);
1091     function balanceOf(address tokenOwner) public view returns (uint balance);
1092     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
1093     function transfer(address to, uint tokens) public returns (bool success);
1094     function approve(address spender, uint tokens) public returns (bool success);
1095     function transferFrom(address from, address to, uint tokens) public returns (bool success);
1096 }
1097 
1098 /**
1099  * @title ModuleRegistry
1100  * @dev Registry of authorised modules. 
1101  * Modules must be registered before they can be authorised on a wallet.
1102  * @author Julien Niset - <julien@argent.xyz>
1103  */
1104 contract ModuleRegistry is Owned {
1105 
1106     mapping (address => Info) internal modules;
1107     mapping (address => Info) internal upgraders;
1108 
1109     event ModuleRegistered(address indexed module, bytes32 name);
1110     event ModuleDeRegistered(address module);
1111     event UpgraderRegistered(address indexed upgrader, bytes32 name);
1112     event UpgraderDeRegistered(address upgrader);
1113 
1114     struct Info {
1115         bool exists;
1116         bytes32 name;
1117     }
1118 
1119     /**
1120      * @dev Registers a module.
1121      * @param _module The module.
1122      * @param _name The unique name of the module.
1123      */
1124     function registerModule(address _module, bytes32 _name) external onlyOwner {
1125         require(!modules[_module].exists, "MR: module already exists");
1126         modules[_module] = Info({exists: true, name: _name});
1127         emit ModuleRegistered(_module, _name);
1128     }
1129 
1130     /**
1131      * @dev Deregisters a module.
1132      * @param _module The module.
1133      */
1134     function deregisterModule(address _module) external onlyOwner {
1135         require(modules[_module].exists, "MR: module does not exists");
1136         delete modules[_module];
1137         emit ModuleDeRegistered(_module);
1138     }
1139 
1140         /**
1141      * @dev Registers an upgrader.
1142      * @param _upgrader The upgrader.
1143      * @param _name The unique name of the upgrader.
1144      */
1145     function registerUpgrader(address _upgrader, bytes32 _name) external onlyOwner {
1146         require(!upgraders[_upgrader].exists, "MR: upgrader already exists");
1147         upgraders[_upgrader] = Info({exists: true, name: _name});
1148         emit UpgraderRegistered(_upgrader, _name);
1149     }
1150 
1151     /**
1152      * @dev Deregisters an upgrader.
1153      * @param _upgrader The _upgrader.
1154      */
1155     function deregisterUpgrader(address _upgrader) external onlyOwner {
1156         require(upgraders[_upgrader].exists, "MR: upgrader does not exists");
1157         delete upgraders[_upgrader];
1158         emit UpgraderDeRegistered(_upgrader);
1159     }
1160 
1161     /**
1162     * @dev Utility method enbaling the owner of the registry to claim any ERC20 token that was sent to the
1163     * registry.
1164     * @param _token The token to recover.
1165     */
1166     function recoverToken(address _token) external onlyOwner {
1167         uint total = ERC20(_token).balanceOf(address(this));
1168         ERC20(_token).transfer(msg.sender, total);
1169     } 
1170 
1171     /**
1172      * @dev Gets the name of a module from its address.
1173      * @param _module The module address.
1174      * @return the name.
1175      */
1176     function moduleInfo(address _module) external view returns (bytes32) {
1177         return modules[_module].name;
1178     }
1179 
1180     /**
1181      * @dev Gets the name of an upgrader from its address.
1182      * @param _upgrader The upgrader address.
1183      * @return the name.
1184      */
1185     function upgraderInfo(address _upgrader) external view returns (bytes32) {
1186         return upgraders[_upgrader].name;
1187     }
1188 
1189     /**
1190      * @dev Checks if a module is registered.
1191      * @param _module The module address.
1192      * @return true if the module is registered.
1193      */
1194     function isRegisteredModule(address _module) external view returns (bool) {
1195         return modules[_module].exists;
1196     }
1197 
1198     /**
1199      * @dev Checks if a list of modules are registered.
1200      * @param _modules The list of modules address.
1201      * @return true if all the modules are registered.
1202      */
1203     function isRegisteredModule(address[] _modules) external view returns (bool) {
1204         for(uint i = 0; i < _modules.length; i++) {
1205             if (!modules[_modules[i]].exists) {
1206                 return false;
1207             }
1208         }
1209         return true;
1210     }  
1211 
1212     /**
1213      * @dev Checks if an upgrader is registered.
1214      * @param _upgrader The upgrader address.
1215      * @return true if the upgrader is registered.
1216      */
1217     function isRegisteredUpgrader(address _upgrader) external view returns (bool) {
1218         return upgraders[_upgrader].exists;
1219     } 
1220 
1221 }
1222 
1223 /**
1224  * @title WalletFactory
1225  * @dev The WalletFactory contract creates and assigns wallets to accounts.
1226  * @author Julien Niset - <julien@argent.xyz>
1227  */
1228 contract WalletFactory is Owned, Managed, ENSConsumer {
1229 
1230     // The address of the module registry
1231     address public moduleRegistry;
1232     // The address of the base wallet implementation
1233     address public walletImplementation;
1234     // The address of the ENS manager
1235     address public ensManager;
1236     // The address of the ENS resolver
1237     address public ensResolver;
1238 
1239     // *************** Events *************************** //
1240 
1241     event ModuleRegistryChanged(address addr);
1242     event WalletImplementationChanged(address addr);
1243     event ENSManagerChanged(address addr);
1244     event ENSResolverChanged(address addr);
1245     event WalletCreated(address indexed _wallet, address indexed _owner);
1246 
1247     // *************** Constructor ********************** //
1248 
1249     /**
1250      * @dev Default constructor.
1251      */
1252     constructor(
1253         address _ensRegistry, 
1254         address _moduleRegistry,
1255         address _walletImplementation, 
1256         address _ensManager, 
1257         address _ensResolver
1258     ) 
1259         ENSConsumer(_ensRegistry) 
1260         public 
1261     {
1262         moduleRegistry = _moduleRegistry;
1263         walletImplementation = _walletImplementation;
1264         ensManager = _ensManager;
1265         ensResolver = _ensResolver;
1266     }
1267 
1268     // *************** External Functions ********************* //
1269 
1270     /**
1271      * @dev Lets the manager create a wallet for an account. The wallet is initialised with a list of modules.
1272      * @param _owner The account address.
1273      * @param _modules The list of modules.
1274      * @param _label Optional ENS label of the new wallet (e.g. franck).
1275      */
1276     function createWallet(address _owner, address[] _modules, string _label) external onlyManager {
1277         require(_owner != address(0), "WF: owner cannot be null");
1278         require(_modules.length > 0, "WF: cannot assign with less than 1 module");
1279         require(ModuleRegistry(moduleRegistry).isRegisteredModule(_modules), "WF: one or more modules are not registered");
1280         // create the proxy
1281         Proxy proxy = new Proxy(walletImplementation);
1282         address wallet = address(proxy);
1283         // check for ENS
1284         bytes memory labelBytes = bytes(_label);
1285         if (labelBytes.length != 0) {
1286             // add the factory to the modules so it can claim the reverse ENS
1287             address[] memory extendedModules = new address[](_modules.length + 1);
1288             extendedModules[0] = address(this);
1289             for(uint i = 0; i < _modules.length; i++) {
1290                 extendedModules[i + 1] = _modules[i];
1291             }
1292             // initialise the wallet with the owner and the extended modules
1293             BaseWallet(wallet).init(_owner, extendedModules);
1294             // register ENS
1295             registerWalletENS(wallet, _label);
1296             // remove the factory from the authorised modules
1297             BaseWallet(wallet).authoriseModule(address(this), false);
1298         } else {
1299             // initialise the wallet with the owner and the modules
1300             BaseWallet(wallet).init(_owner, _modules);
1301         }
1302         emit WalletCreated(wallet, _owner);
1303     }
1304 
1305     /**
1306      * @dev Lets the owner change the address of the module registry contract.
1307      * @param _moduleRegistry The address of the module registry contract.
1308      */
1309     function changeModuleRegistry(address _moduleRegistry) external onlyOwner {
1310         require(_moduleRegistry != address(0), "WF: address cannot be null");
1311         moduleRegistry = _moduleRegistry;
1312         emit ModuleRegistryChanged(_moduleRegistry);
1313     }
1314 
1315     /**
1316      * @dev Lets the owner change the address of the implementing contract.
1317      * @param _walletImplementation The address of the implementing contract.
1318      */
1319     function changeWalletImplementation(address _walletImplementation) external onlyOwner {
1320         require(_walletImplementation != address(0), "WF: address cannot be null");
1321         walletImplementation = _walletImplementation;
1322         emit WalletImplementationChanged(_walletImplementation);
1323     }
1324 
1325     /**
1326      * @dev Lets the owner change the address of the ENS manager contract.
1327      * @param _ensManager The address of the ENS manager contract.
1328      */
1329     function changeENSManager(address _ensManager) external onlyOwner {
1330         require(_ensManager != address(0), "WF: address cannot be null");
1331         ensManager = _ensManager;
1332         emit ENSManagerChanged(_ensManager);
1333     }
1334 
1335     /**
1336      * @dev Lets the owner change the address of the ENS resolver contract.
1337      * @param _ensResolver The address of the ENS resolver contract.
1338      */
1339     function changeENSResolver(address _ensResolver) external onlyOwner {
1340         require(_ensResolver != address(0), "WF: address cannot be null");
1341         ensResolver = _ensResolver;
1342         emit ENSResolverChanged(_ensResolver);
1343     }
1344 
1345     /**
1346      * @dev Register an ENS subname to a wallet.
1347      * @param _wallet The wallet address.
1348      * @param _label ENS label of the new wallet (e.g. franck).
1349      */
1350     function registerWalletENS(address _wallet, string _label) internal {
1351         // claim reverse
1352         bytes memory methodData = abi.encodeWithSignature("claimWithResolver(address,address)", ensManager, ensResolver);
1353         BaseWallet(_wallet).invoke(getENSReverseRegistrar(), 0, methodData);
1354         // register with ENS manager
1355         IENSManager(ensManager).register(_label, _wallet);
1356     }
1357 
1358     /**
1359      * @dev Inits the module for a wallet by logging an event.
1360      * The method can only be called by the wallet itself.
1361      * @param _wallet The wallet.
1362      */
1363     function init(BaseWallet _wallet) external pure {
1364         //do nothing
1365     }
1366 }