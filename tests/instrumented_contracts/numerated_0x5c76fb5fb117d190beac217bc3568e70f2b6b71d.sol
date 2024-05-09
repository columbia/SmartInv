1 /**
2  *  The Consumer Contract Wallet
3  *  Copyright (C) 2018 The Contract Wallet Company Limited
4  *
5  *  This program is free software: you can redistribute it and/or modify
6  *  it under the terms of the GNU General Public License as published by
7  *  the Free Software Foundation, either version 3 of the License, or
8  *  (at your option) any later version.
9 
10  *  This program is distributed in the hope that it will be useful,
11  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
12  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13  *  GNU General Public License for more details.
14 
15  *  You should have received a copy of the GNU General Public License
16  *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
17  */
18 
19 pragma solidity ^0.4.25;
20 
21 /// @title The Controller interface provides access to an external list of controllers.
22 interface IController {
23     function isController(address) external view returns (bool);
24 }
25 
26 /// @title Controller stores a list of controller addresses that can be used for authentication in other contracts.
27 contract Controller is IController {
28     event AddedController(address _sender, address _controller);
29     event RemovedController(address _sender, address _controller);
30 
31     mapping (address => bool) private _isController;
32     uint private _controllerCount;
33 
34     /// @dev Constructor initializes the list of controllers with the provided address.
35     /// @param _account address to add to the list of controllers.
36     constructor(address _account) public {
37         _addController(_account);
38     }
39 
40     /// @dev Checks if message sender is a controller.
41     modifier onlyController() {
42         require(isController(msg.sender), "sender is not a controller");
43         _;
44     }
45 
46     /// @dev Add a new controller to the list of controllers.
47     /// @param _account address to add to the list of controllers.
48     function addController(address _account) external onlyController {
49         _addController(_account);
50     }
51 
52     /// @dev Remove a controller from the list of controllers.
53     /// @param _account address to remove from the list of controllers.
54     function removeController(address _account) external onlyController {
55         _removeController(_account);
56     }
57 
58     /// @return true if the provided account is a controller.
59     function isController(address _account) public view returns (bool) {
60         return _isController[_account];
61     }
62 
63     /// @return the current number of controllers.
64     function controllerCount() public view returns (uint) {
65         return _controllerCount;
66     }
67 
68     /// @dev Internal-only function that adds a new controller.
69     function _addController(address _account) internal {
70         require(!_isController[_account], "provided account is already a controller");
71         _isController[_account] = true;
72         _controllerCount++;
73         emit AddedController(msg.sender, _account);
74     }
75 
76     /// @dev Internal-only function that removes an existing controller.
77     function _removeController(address _account) internal {
78         require(_isController[_account], "provided account is not a controller");
79         require(_controllerCount > 1, "cannot remove the last controller");
80         _isController[_account] = false;
81         _controllerCount--;
82         emit RemovedController(msg.sender, _account);
83     }
84 }
85 
86 /**
87  * BSD 2-Clause License
88  *
89  * Copyright (c) 2018, True Names Limited
90  * All rights reserved.
91  *
92  * Redistribution and use in source and binary forms, with or without
93  * modification, are permitted provided that the following conditions are met:
94  *
95  * * Redistributions of source code must retain the above copyright notice, this
96  *   list of conditions and the following disclaimer.
97  *
98  * * Redistributions in binary form must reproduce the above copyright notice,
99  *   this list of conditions and the following disclaimer in the documentation
100  *   and/or other materials provided with the distribution.
101  *
102  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
103  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
104  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
105  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
106  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
107  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
108  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
109  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
110  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
111  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
112 */
113 
114 interface ENS {
115 
116     // Logged when the owner of a node assigns a new owner to a subnode.
117     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
118 
119     // Logged when the owner of a node transfers ownership to a new account.
120     event Transfer(bytes32 indexed node, address owner);
121 
122     // Logged when the resolver for a node changes.
123     event NewResolver(bytes32 indexed node, address resolver);
124 
125     // Logged when the TTL of a node changes
126     event NewTTL(bytes32 indexed node, uint64 ttl);
127 
128 
129     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
130     function setResolver(bytes32 node, address resolver) public;
131     function setOwner(bytes32 node, address owner) public;
132     function setTTL(bytes32 node, uint64 ttl) public;
133     function owner(bytes32 node) public view returns (address);
134     function resolver(bytes32 node) public view returns (address);
135     function ttl(bytes32 node) public view returns (uint64);
136 
137 }
138 
139 /// @title Resolver returns the controller contract address.
140 interface IResolver {
141     function addr(bytes32) external view returns (address);
142 }
143 
144 /// @title Controllable implements access control functionality based on a controller set in ENS.
145 contract Controllable {
146     /// @dev _ENS points to the ENS registry smart contract.
147     ENS private _ENS;
148     /// @dev Is the registered ENS name of the controller contract.
149     bytes32 private _node;
150 
151     /// @dev Constructor initializes the controller contract object.
152     /// @param _ens is the address of the ENS.
153     /// @param _controllerName is the ENS name of the Controller.
154     constructor(address _ens, bytes32 _controllerName) internal {
155       _ENS = ENS(_ens);
156       _node = _controllerName;
157     }
158 
159     /// @dev Checks if message sender is the controller.
160     modifier onlyController() {
161         require(_isController(msg.sender), "sender is not a controller");
162         _;
163     }
164 
165     /// @return true if the provided account is the controller.
166     function _isController(address _account) internal view returns (bool) {
167         return IController(IResolver(_ENS.resolver(_node)).addr(_node)).isController(_account);
168     }
169 }
170 
171 /// @title Date provides date parsing functionality.
172 contract Date {
173 
174     bytes32 constant private JANUARY = keccak256("Jan");
175     bytes32 constant private FEBRUARY = keccak256("Feb");
176     bytes32 constant private MARCH = keccak256("Mar");
177     bytes32 constant private APRIL = keccak256("Apr");
178     bytes32 constant private MAY = keccak256("May");
179     bytes32 constant private JUNE = keccak256("Jun");
180     bytes32 constant private JULY = keccak256("Jul");
181     bytes32 constant private AUGUST = keccak256("Aug");
182     bytes32 constant private SEPTEMBER = keccak256("Sep");
183     bytes32 constant private OCTOBER = keccak256("Oct");
184     bytes32 constant private NOVEMBER = keccak256("Nov");
185     bytes32 constant private DECEMBER = keccak256("Dec");
186 
187     /// @return the number of the month based on its name.
188     /// @param _month the first three letters of a month's name e.g. "Jan".
189     function _monthToNumber(string _month) internal pure returns (uint8) {
190         bytes32 month = keccak256(abi.encodePacked(_month));
191         if (month == JANUARY) {
192             return 1;
193         } else if (month == FEBRUARY) {
194             return 2;
195         } else if (month == MARCH) {
196             return 3;
197         } else if (month == APRIL) {
198             return 4;
199         } else if (month == MAY) {
200             return 5;
201         } else if (month == JUNE) {
202             return 6;
203         } else if (month == JULY) {
204             return 7;
205         } else if (month == AUGUST) {
206             return 8;
207         } else if (month == SEPTEMBER) {
208             return 9;
209         } else if (month == OCTOBER) {
210             return 10;
211         } else if (month == NOVEMBER) {
212             return 11;
213         } else if (month == DECEMBER) {
214             return 12;
215         } else {
216             revert("not a valid month");
217         }
218     }
219 }
220 
221 /*
222  * Copyright 2016 Nick Johnson
223  *
224  * Licensed under the Apache License, Version 2.0 (the "License");
225  * you may not use this file except in compliance with the License.
226  * You may obtain a copy of the License at
227  *
228  *     http://www.apache.org/licenses/LICENSE-2.0
229  *
230  * Unless required by applicable law or agreed to in writing, software
231  * distributed under the License is distributed on an "AS IS" BASIS,
232  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
233  * See the License for the specific language governing permissions and
234  * limitations under the License.
235  */
236 
237 /*
238  * @title String & slice utility library for Solidity contracts.
239  * @author Nick Johnson <arachnid@notdot.net>
240  *
241  * @dev Functionality in this library is largely implemented using an
242  *      abstraction called a 'slice'. A slice represents a part of a string -
243  *      anything from the entire string to a single character, or even no
244  *      characters at all (a 0-length slice). Since a slice only has to specify
245  *      an offset and a length, copying and manipulating slices is a lot less
246  *      expensive than copying and manipulating the strings they reference.
247  *
248  *      To further reduce gas costs, most functions on slice that need to return
249  *      a slice modify the original one instead of allocating a new one; for
250  *      instance, `s.split(".")` will return the text up to the first '.',
251  *      modifying s to only contain the remainder of the string after the '.'.
252  *      In situations where you do not want to modify the original slice, you
253  *      can make a copy first with `.copy()`, for example:
254  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
255  *      Solidity has no memory management, it will result in allocating many
256  *      short-lived slices that are later discarded.
257  *
258  *      Functions that return two slices come in two versions: a non-allocating
259  *      version that takes the second slice as an argument, modifying it in
260  *      place, and an allocating version that allocates and returns the second
261  *      slice; see `nextRune` for example.
262  *
263  *      Functions that have to copy string data will return strings rather than
264  *      slices; these can be cast back to slices for further processing if
265  *      required.
266  *
267  *      For convenience, some functions are provided with non-modifying
268  *      variants that create a new slice and return both; for instance,
269  *      `s.splitNew('.')` leaves s unmodified, and returns two values
270  *      corresponding to the left and right parts of the string.
271  */
272 
273 library strings {
274     struct slice {
275         uint _len;
276         uint _ptr;
277     }
278 
279     function memcpy(uint dest, uint src, uint len) private pure {
280         // Copy word-length chunks while possible
281         for(; len >= 32; len -= 32) {
282             assembly {
283                 mstore(dest, mload(src))
284             }
285             dest += 32;
286             src += 32;
287         }
288 
289         // Copy remaining bytes
290         uint mask = 256 ** (32 - len) - 1;
291         assembly {
292             let srcpart := and(mload(src), not(mask))
293             let destpart := and(mload(dest), mask)
294             mstore(dest, or(destpart, srcpart))
295         }
296     }
297 
298     /*
299      * @dev Returns a slice containing the entire string.
300      * @param self The string to make a slice from.
301      * @return A newly allocated slice containing the entire string.
302      */
303     function toSlice(string memory self) internal pure returns (slice memory) {
304         uint ptr;
305         assembly {
306             ptr := add(self, 0x20)
307         }
308         return slice(bytes(self).length, ptr);
309     }
310 
311     /*
312      * @dev Returns the length of a null-terminated bytes32 string.
313      * @param self The value to find the length of.
314      * @return The length of the string, from 0 to 32.
315      */
316     function len(bytes32 self) internal pure returns (uint) {
317         uint ret;
318         if (self == 0)
319             return 0;
320         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
321             ret += 16;
322             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
323         }
324         if (self & 0xffffffffffffffff == 0) {
325             ret += 8;
326             self = bytes32(uint(self) / 0x10000000000000000);
327         }
328         if (self & 0xffffffff == 0) {
329             ret += 4;
330             self = bytes32(uint(self) / 0x100000000);
331         }
332         if (self & 0xffff == 0) {
333             ret += 2;
334             self = bytes32(uint(self) / 0x10000);
335         }
336         if (self & 0xff == 0) {
337             ret += 1;
338         }
339         return 32 - ret;
340     }
341 
342     /*
343      * @dev Returns a slice containing the entire bytes32, interpreted as a
344      *      null-terminated utf-8 string.
345      * @param self The bytes32 value to convert to a slice.
346      * @return A new slice containing the value of the input argument up to the
347      *         first null.
348      */
349     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
350         // Allocate space for `self` in memory, copy it there, and point ret at it
351         assembly {
352             let ptr := mload(0x40)
353             mstore(0x40, add(ptr, 0x20))
354             mstore(ptr, self)
355             mstore(add(ret, 0x20), ptr)
356         }
357         ret._len = len(self);
358     }
359 
360     /*
361      * @dev Returns a new slice containing the same data as the current slice.
362      * @param self The slice to copy.
363      * @return A new slice containing the same data as `self`.
364      */
365     function copy(slice memory self) internal pure returns (slice memory) {
366         return slice(self._len, self._ptr);
367     }
368 
369     /*
370      * @dev Copies a slice to a new string.
371      * @param self The slice to copy.
372      * @return A newly allocated string containing the slice's text.
373      */
374     function toString(slice memory self) internal pure returns (string memory) {
375         string memory ret = new string(self._len);
376         uint retptr;
377         assembly { retptr := add(ret, 32) }
378 
379         memcpy(retptr, self._ptr, self._len);
380         return ret;
381     }
382 
383     /*
384      * @dev Returns the length in runes of the slice. Note that this operation
385      *      takes time proportional to the length of the slice; avoid using it
386      *      in loops, and call `slice.empty()` if you only need to know whether
387      *      the slice is empty or not.
388      * @param self The slice to operate on.
389      * @return The length of the slice in runes.
390      */
391     function len(slice memory self) internal pure returns (uint l) {
392         // Starting at ptr-31 means the LSB will be the byte we care about
393         uint ptr = self._ptr - 31;
394         uint end = ptr + self._len;
395         for (l = 0; ptr < end; l++) {
396             uint8 b;
397             assembly { b := and(mload(ptr), 0xFF) }
398             if (b < 0x80) {
399                 ptr += 1;
400             } else if(b < 0xE0) {
401                 ptr += 2;
402             } else if(b < 0xF0) {
403                 ptr += 3;
404             } else if(b < 0xF8) {
405                 ptr += 4;
406             } else if(b < 0xFC) {
407                 ptr += 5;
408             } else {
409                 ptr += 6;
410             }
411         }
412     }
413 
414     /*
415      * @dev Returns true if the slice is empty (has a length of 0).
416      * @param self The slice to operate on.
417      * @return True if the slice is empty, False otherwise.
418      */
419     function empty(slice memory self) internal pure returns (bool) {
420         return self._len == 0;
421     }
422 
423     /*
424      * @dev Returns a positive number if `other` comes lexicographically after
425      *      `self`, a negative number if it comes before, or zero if the
426      *      contents of the two slices are equal. Comparison is done per-rune,
427      *      on unicode codepoints.
428      * @param self The first slice to compare.
429      * @param other The second slice to compare.
430      * @return The result of the comparison.
431      */
432     function compare(slice memory self, slice memory other) internal pure returns (int) {
433         uint shortest = self._len;
434         if (other._len < self._len)
435             shortest = other._len;
436 
437         uint selfptr = self._ptr;
438         uint otherptr = other._ptr;
439         for (uint idx = 0; idx < shortest; idx += 32) {
440             uint a;
441             uint b;
442             assembly {
443                 a := mload(selfptr)
444                 b := mload(otherptr)
445             }
446             if (a != b) {
447                 // Mask out irrelevant bytes and check again
448                 uint256 mask = uint256(-1); // 0xffff...
449                 if(shortest < 32) {
450                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
451                 }
452                 uint256 diff = (a & mask) - (b & mask);
453                 if (diff != 0)
454                     return int(diff);
455             }
456             selfptr += 32;
457             otherptr += 32;
458         }
459         return int(self._len) - int(other._len);
460     }
461 
462     /*
463      * @dev Returns true if the two slices contain the same text.
464      * @param self The first slice to compare.
465      * @param self The second slice to compare.
466      * @return True if the slices are equal, false otherwise.
467      */
468     function equals(slice memory self, slice memory other) internal pure returns (bool) {
469         return compare(self, other) == 0;
470     }
471 
472     /*
473      * @dev Extracts the first rune in the slice into `rune`, advancing the
474      *      slice to point to the next rune and returning `self`.
475      * @param self The slice to operate on.
476      * @param rune The slice that will contain the first rune.
477      * @return `rune`.
478      */
479     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
480         rune._ptr = self._ptr;
481 
482         if (self._len == 0) {
483             rune._len = 0;
484             return rune;
485         }
486 
487         uint l;
488         uint b;
489         // Load the first byte of the rune into the LSBs of b
490         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
491         if (b < 0x80) {
492             l = 1;
493         } else if(b < 0xE0) {
494             l = 2;
495         } else if(b < 0xF0) {
496             l = 3;
497         } else {
498             l = 4;
499         }
500 
501         // Check for truncated codepoints
502         if (l > self._len) {
503             rune._len = self._len;
504             self._ptr += self._len;
505             self._len = 0;
506             return rune;
507         }
508 
509         self._ptr += l;
510         self._len -= l;
511         rune._len = l;
512         return rune;
513     }
514 
515     /*
516      * @dev Returns the first rune in the slice, advancing the slice to point
517      *      to the next rune.
518      * @param self The slice to operate on.
519      * @return A slice containing only the first rune from `self`.
520      */
521     function nextRune(slice memory self) internal pure returns (slice memory ret) {
522         nextRune(self, ret);
523     }
524 
525     /*
526      * @dev Returns the number of the first codepoint in the slice.
527      * @param self The slice to operate on.
528      * @return The number of the first codepoint in the slice.
529      */
530     function ord(slice memory self) internal pure returns (uint ret) {
531         if (self._len == 0) {
532             return 0;
533         }
534 
535         uint word;
536         uint length;
537         uint divisor = 2 ** 248;
538 
539         // Load the rune into the MSBs of b
540         assembly { word:= mload(mload(add(self, 32))) }
541         uint b = word / divisor;
542         if (b < 0x80) {
543             ret = b;
544             length = 1;
545         } else if(b < 0xE0) {
546             ret = b & 0x1F;
547             length = 2;
548         } else if(b < 0xF0) {
549             ret = b & 0x0F;
550             length = 3;
551         } else {
552             ret = b & 0x07;
553             length = 4;
554         }
555 
556         // Check for truncated codepoints
557         if (length > self._len) {
558             return 0;
559         }
560 
561         for (uint i = 1; i < length; i++) {
562             divisor = divisor / 256;
563             b = (word / divisor) & 0xFF;
564             if (b & 0xC0 != 0x80) {
565                 // Invalid UTF-8 sequence
566                 return 0;
567             }
568             ret = (ret * 64) | (b & 0x3F);
569         }
570 
571         return ret;
572     }
573 
574     /*
575      * @dev Returns the keccak-256 hash of the slice.
576      * @param self The slice to hash.
577      * @return The hash of the slice.
578      */
579     function keccak(slice memory self) internal pure returns (bytes32 ret) {
580         assembly {
581             ret := keccak256(mload(add(self, 32)), mload(self))
582         }
583     }
584 
585     /*
586      * @dev Returns true if `self` starts with `needle`.
587      * @param self The slice to operate on.
588      * @param needle The slice to search for.
589      * @return True if the slice starts with the provided text, false otherwise.
590      */
591     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
592         if (self._len < needle._len) {
593             return false;
594         }
595 
596         if (self._ptr == needle._ptr) {
597             return true;
598         }
599 
600         bool equal;
601         assembly {
602             let length := mload(needle)
603             let selfptr := mload(add(self, 0x20))
604             let needleptr := mload(add(needle, 0x20))
605             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
606         }
607         return equal;
608     }
609 
610     /*
611      * @dev If `self` starts with `needle`, `needle` is removed from the
612      *      beginning of `self`. Otherwise, `self` is unmodified.
613      * @param self The slice to operate on.
614      * @param needle The slice to search for.
615      * @return `self`
616      */
617     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
618         if (self._len < needle._len) {
619             return self;
620         }
621 
622         bool equal = true;
623         if (self._ptr != needle._ptr) {
624             assembly {
625                 let length := mload(needle)
626                 let selfptr := mload(add(self, 0x20))
627                 let needleptr := mload(add(needle, 0x20))
628                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
629             }
630         }
631 
632         if (equal) {
633             self._len -= needle._len;
634             self._ptr += needle._len;
635         }
636 
637         return self;
638     }
639 
640     /*
641      * @dev Returns true if the slice ends with `needle`.
642      * @param self The slice to operate on.
643      * @param needle The slice to search for.
644      * @return True if the slice starts with the provided text, false otherwise.
645      */
646     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
647         if (self._len < needle._len) {
648             return false;
649         }
650 
651         uint selfptr = self._ptr + self._len - needle._len;
652 
653         if (selfptr == needle._ptr) {
654             return true;
655         }
656 
657         bool equal;
658         assembly {
659             let length := mload(needle)
660             let needleptr := mload(add(needle, 0x20))
661             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
662         }
663 
664         return equal;
665     }
666 
667     /*
668      * @dev If `self` ends with `needle`, `needle` is removed from the
669      *      end of `self`. Otherwise, `self` is unmodified.
670      * @param self The slice to operate on.
671      * @param needle The slice to search for.
672      * @return `self`
673      */
674     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
675         if (self._len < needle._len) {
676             return self;
677         }
678 
679         uint selfptr = self._ptr + self._len - needle._len;
680         bool equal = true;
681         if (selfptr != needle._ptr) {
682             assembly {
683                 let length := mload(needle)
684                 let needleptr := mload(add(needle, 0x20))
685                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
686             }
687         }
688 
689         if (equal) {
690             self._len -= needle._len;
691         }
692 
693         return self;
694     }
695 
696     // Returns the memory address of the first byte of the first occurrence of
697     // `needle` in `self`, or the first byte after `self` if not found.
698     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
699         uint ptr = selfptr;
700         uint idx;
701 
702         if (needlelen <= selflen) {
703             if (needlelen <= 32) {
704                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
705 
706                 bytes32 needledata;
707                 assembly { needledata := and(mload(needleptr), mask) }
708 
709                 uint end = selfptr + selflen - needlelen;
710                 bytes32 ptrdata;
711                 assembly { ptrdata := and(mload(ptr), mask) }
712 
713                 while (ptrdata != needledata) {
714                     if (ptr >= end)
715                         return selfptr + selflen;
716                     ptr++;
717                     assembly { ptrdata := and(mload(ptr), mask) }
718                 }
719                 return ptr;
720             } else {
721                 // For long needles, use hashing
722                 bytes32 hash;
723                 assembly { hash := keccak256(needleptr, needlelen) }
724 
725                 for (idx = 0; idx <= selflen - needlelen; idx++) {
726                     bytes32 testHash;
727                     assembly { testHash := keccak256(ptr, needlelen) }
728                     if (hash == testHash)
729                         return ptr;
730                     ptr += 1;
731                 }
732             }
733         }
734         return selfptr + selflen;
735     }
736 
737     // Returns the memory address of the first byte after the last occurrence of
738     // `needle` in `self`, or the address of `self` if not found.
739     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
740         uint ptr;
741 
742         if (needlelen <= selflen) {
743             if (needlelen <= 32) {
744                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
745 
746                 bytes32 needledata;
747                 assembly { needledata := and(mload(needleptr), mask) }
748 
749                 ptr = selfptr + selflen - needlelen;
750                 bytes32 ptrdata;
751                 assembly { ptrdata := and(mload(ptr), mask) }
752 
753                 while (ptrdata != needledata) {
754                     if (ptr <= selfptr)
755                         return selfptr;
756                     ptr--;
757                     assembly { ptrdata := and(mload(ptr), mask) }
758                 }
759                 return ptr + needlelen;
760             } else {
761                 // For long needles, use hashing
762                 bytes32 hash;
763                 assembly { hash := keccak256(needleptr, needlelen) }
764                 ptr = selfptr + (selflen - needlelen);
765                 while (ptr >= selfptr) {
766                     bytes32 testHash;
767                     assembly { testHash := keccak256(ptr, needlelen) }
768                     if (hash == testHash)
769                         return ptr + needlelen;
770                     ptr -= 1;
771                 }
772             }
773         }
774         return selfptr;
775     }
776 
777     /*
778      * @dev Modifies `self` to contain everything from the first occurrence of
779      *      `needle` to the end of the slice. `self` is set to the empty slice
780      *      if `needle` is not found.
781      * @param self The slice to search and modify.
782      * @param needle The text to search for.
783      * @return `self`.
784      */
785     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
786         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
787         self._len -= ptr - self._ptr;
788         self._ptr = ptr;
789         return self;
790     }
791 
792     /*
793      * @dev Modifies `self` to contain the part of the string from the start of
794      *      `self` to the end of the first occurrence of `needle`. If `needle`
795      *      is not found, `self` is set to the empty slice.
796      * @param self The slice to search and modify.
797      * @param needle The text to search for.
798      * @return `self`.
799      */
800     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
801         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
802         self._len = ptr - self._ptr;
803         return self;
804     }
805 
806     /*
807      * @dev Splits the slice, setting `self` to everything after the first
808      *      occurrence of `needle`, and `token` to everything before it. If
809      *      `needle` does not occur in `self`, `self` is set to the empty slice,
810      *      and `token` is set to the entirety of `self`.
811      * @param self The slice to split.
812      * @param needle The text to search for in `self`.
813      * @param token An output parameter to which the first token is written.
814      * @return `token`.
815      */
816     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
817         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
818         token._ptr = self._ptr;
819         token._len = ptr - self._ptr;
820         if (ptr == self._ptr + self._len) {
821             // Not found
822             self._len = 0;
823         } else {
824             self._len -= token._len + needle._len;
825             self._ptr = ptr + needle._len;
826         }
827         return token;
828     }
829 
830     /*
831      * @dev Splits the slice, setting `self` to everything after the first
832      *      occurrence of `needle`, and returning everything before it. If
833      *      `needle` does not occur in `self`, `self` is set to the empty slice,
834      *      and the entirety of `self` is returned.
835      * @param self The slice to split.
836      * @param needle The text to search for in `self`.
837      * @return The part of `self` up to the first occurrence of `delim`.
838      */
839     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
840         split(self, needle, token);
841     }
842 
843     /*
844      * @dev Splits the slice, setting `self` to everything before the last
845      *      occurrence of `needle`, and `token` to everything after it. If
846      *      `needle` does not occur in `self`, `self` is set to the empty slice,
847      *      and `token` is set to the entirety of `self`.
848      * @param self The slice to split.
849      * @param needle The text to search for in `self`.
850      * @param token An output parameter to which the first token is written.
851      * @return `token`.
852      */
853     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
854         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
855         token._ptr = ptr;
856         token._len = self._len - (ptr - self._ptr);
857         if (ptr == self._ptr) {
858             // Not found
859             self._len = 0;
860         } else {
861             self._len -= token._len + needle._len;
862         }
863         return token;
864     }
865 
866     /*
867      * @dev Splits the slice, setting `self` to everything before the last
868      *      occurrence of `needle`, and returning everything after it. If
869      *      `needle` does not occur in `self`, `self` is set to the empty slice,
870      *      and the entirety of `self` is returned.
871      * @param self The slice to split.
872      * @param needle The text to search for in `self`.
873      * @return The part of `self` after the last occurrence of `delim`.
874      */
875     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
876         rsplit(self, needle, token);
877     }
878 
879     /*
880      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
881      * @param self The slice to search.
882      * @param needle The text to search for in `self`.
883      * @return The number of occurrences of `needle` found in `self`.
884      */
885     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
886         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
887         while (ptr <= self._ptr + self._len) {
888             cnt++;
889             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
890         }
891     }
892 
893     /*
894      * @dev Returns True if `self` contains `needle`.
895      * @param self The slice to search.
896      * @param needle The text to search for in `self`.
897      * @return True if `needle` is found in `self`, false otherwise.
898      */
899     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
900         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
901     }
902 
903     /*
904      * @dev Returns a newly allocated string containing the concatenation of
905      *      `self` and `other`.
906      * @param self The first slice to concatenate.
907      * @param other The second slice to concatenate.
908      * @return The concatenation of the two strings.
909      */
910     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
911         string memory ret = new string(self._len + other._len);
912         uint retptr;
913         assembly { retptr := add(ret, 32) }
914         memcpy(retptr, self._ptr, self._len);
915         memcpy(retptr + self._len, other._ptr, other._len);
916         return ret;
917     }
918 
919     /*
920      * @dev Joins an array of slices, using `self` as a delimiter, returning a
921      *      newly allocated string.
922      * @param self The delimiter to use.
923      * @param parts A list of slices to join.
924      * @return A newly allocated string containing all the slices in `parts`,
925      *         joined with `self`.
926      */
927     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
928         if (parts.length == 0)
929             return "";
930 
931         uint length = self._len * (parts.length - 1);
932         for(uint i = 0; i < parts.length; i++)
933             length += parts[i]._len;
934 
935         string memory ret = new string(length);
936         uint retptr;
937         assembly { retptr := add(ret, 32) }
938 
939         for(i = 0; i < parts.length; i++) {
940             memcpy(retptr, parts[i]._ptr, parts[i]._len);
941             retptr += parts[i]._len;
942             if (i < parts.length - 1) {
943                 memcpy(retptr, self._ptr, self._len);
944                 retptr += self._len;
945             }
946         }
947 
948         return ret;
949     }
950 }
951 
952 // <ORACLIZE_API>
953 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
954 /*
955 Copyright (c) 2015-2016 Oraclize SRL
956 Copyright (c) 2016 Oraclize LTD
957 
958 
959 
960 Permission is hereby granted, free of charge, to any person obtaining a copy
961 of this software and associated documentation files (the "Software"), to deal
962 in the Software without restriction, including without limitation the rights
963 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
964 copies of the Software, and to permit persons to whom the Software is
965 furnished to do so, subject to the following conditions:
966 
967 
968 
969 The above copyright notice and this permission notice shall be included in
970 all copies or substantial portions of the Software.
971 
972 
973 
974 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
975 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
976 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
977 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
978 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
979 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
980 THE SOFTWARE.
981 */
982 
983 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
984 
985 contract OraclizeI {
986     address public cbAddress;
987     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
988     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
989     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
990     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
991     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
992     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
993     function getPrice(string _datasource) public returns (uint _dsprice);
994     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
995     function setProofType(byte _proofType) external;
996     function setCustomGasPrice(uint _gasPrice) external;
997     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
998 }
999 
1000 contract OraclizeAddrResolverI {
1001     function getAddress() public returns (address _addr);
1002 }
1003 
1004 /*
1005 Begin solidity-cborutils
1006 
1007 https://github.com/smartcontractkit/solidity-cborutils
1008 
1009 MIT License
1010 
1011 Copyright (c) 2018 SmartContract ChainLink, Ltd.
1012 
1013 Permission is hereby granted, free of charge, to any person obtaining a copy
1014 of this software and associated documentation files (the "Software"), to deal
1015 in the Software without restriction, including without limitation the rights
1016 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1017 copies of the Software, and to permit persons to whom the Software is
1018 furnished to do so, subject to the following conditions:
1019 
1020 The above copyright notice and this permission notice shall be included in all
1021 copies or substantial portions of the Software.
1022 
1023 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1024 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1025 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1026 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1027 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1028 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1029 SOFTWARE.
1030  */
1031 
1032 library Buffer {
1033     struct buffer {
1034         bytes buf;
1035         uint capacity;
1036     }
1037 
1038     function init(buffer memory buf, uint _capacity) internal pure {
1039         uint capacity = _capacity;
1040         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
1041         // Allocate space for the buffer data
1042         buf.capacity = capacity;
1043         assembly {
1044             let ptr := mload(0x40)
1045             mstore(buf, ptr)
1046             mstore(ptr, 0)
1047             mstore(0x40, add(ptr, capacity))
1048         }
1049     }
1050 
1051     function resize(buffer memory buf, uint capacity) private pure {
1052         bytes memory oldbuf = buf.buf;
1053         init(buf, capacity);
1054         append(buf, oldbuf);
1055     }
1056 
1057     function max(uint a, uint b) private pure returns(uint) {
1058         if(a > b) {
1059             return a;
1060         }
1061         return b;
1062     }
1063 
1064     /**
1065      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
1066      *      would exceed the capacity of the buffer.
1067      * @param buf The buffer to append to.
1068      * @param data The data to append.
1069      * @return The original buffer.
1070      */
1071     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
1072         if(data.length + buf.buf.length > buf.capacity) {
1073             resize(buf, max(buf.capacity, data.length) * 2);
1074         }
1075 
1076         uint dest;
1077         uint src;
1078         uint len = data.length;
1079         assembly {
1080             // Memory address of the buffer data
1081             let bufptr := mload(buf)
1082             // Length of existing buffer data
1083             let buflen := mload(bufptr)
1084             // Start address = buffer address + buffer length + sizeof(buffer length)
1085             dest := add(add(bufptr, buflen), 32)
1086             // Update buffer length
1087             mstore(bufptr, add(buflen, mload(data)))
1088             src := add(data, 32)
1089         }
1090 
1091         // Copy word-length chunks while possible
1092         for(; len >= 32; len -= 32) {
1093             assembly {
1094                 mstore(dest, mload(src))
1095             }
1096             dest += 32;
1097             src += 32;
1098         }
1099 
1100         // Copy remaining bytes
1101         uint mask = 256 ** (32 - len) - 1;
1102         assembly {
1103             let srcpart := and(mload(src), not(mask))
1104             let destpart := and(mload(dest), mask)
1105             mstore(dest, or(destpart, srcpart))
1106         }
1107 
1108         return buf;
1109     }
1110 
1111     /**
1112      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1113      * exceed the capacity of the buffer.
1114      * @param buf The buffer to append to.
1115      * @param data The data to append.
1116      * @return The original buffer.
1117      */
1118     function append(buffer memory buf, uint8 data) internal pure {
1119         if(buf.buf.length + 1 > buf.capacity) {
1120             resize(buf, buf.capacity * 2);
1121         }
1122 
1123         assembly {
1124             // Memory address of the buffer data
1125             let bufptr := mload(buf)
1126             // Length of existing buffer data
1127             let buflen := mload(bufptr)
1128             // Address = buffer address + buffer length + sizeof(buffer length)
1129             let dest := add(add(bufptr, buflen), 32)
1130             mstore8(dest, data)
1131             // Update buffer length
1132             mstore(bufptr, add(buflen, 1))
1133         }
1134     }
1135 
1136     /**
1137      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
1138      * exceed the capacity of the buffer.
1139      * @param buf The buffer to append to.
1140      * @param data The data to append.
1141      * @return The original buffer.
1142      */
1143     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
1144         if(len + buf.buf.length > buf.capacity) {
1145             resize(buf, max(buf.capacity, len) * 2);
1146         }
1147 
1148         uint mask = 256 ** len - 1;
1149         assembly {
1150             // Memory address of the buffer data
1151             let bufptr := mload(buf)
1152             // Length of existing buffer data
1153             let buflen := mload(bufptr)
1154             // Address = buffer address + buffer length + sizeof(buffer length) + len
1155             let dest := add(add(bufptr, buflen), len)
1156             mstore(dest, or(and(mload(dest), not(mask)), data))
1157             // Update buffer length
1158             mstore(bufptr, add(buflen, len))
1159         }
1160         return buf;
1161     }
1162 }
1163 
1164 library CBOR {
1165     using Buffer for Buffer.buffer;
1166 
1167     uint8 private constant MAJOR_TYPE_INT = 0;
1168     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
1169     uint8 private constant MAJOR_TYPE_BYTES = 2;
1170     uint8 private constant MAJOR_TYPE_STRING = 3;
1171     uint8 private constant MAJOR_TYPE_ARRAY = 4;
1172     uint8 private constant MAJOR_TYPE_MAP = 5;
1173     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
1174 
1175     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
1176         if(value <= 23) {
1177             buf.append(uint8((major << 5) | value));
1178         } else if(value <= 0xFF) {
1179             buf.append(uint8((major << 5) | 24));
1180             buf.appendInt(value, 1);
1181         } else if(value <= 0xFFFF) {
1182             buf.append(uint8((major << 5) | 25));
1183             buf.appendInt(value, 2);
1184         } else if(value <= 0xFFFFFFFF) {
1185             buf.append(uint8((major << 5) | 26));
1186             buf.appendInt(value, 4);
1187         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
1188             buf.append(uint8((major << 5) | 27));
1189             buf.appendInt(value, 8);
1190         }
1191     }
1192 
1193     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
1194         buf.append(uint8((major << 5) | 31));
1195     }
1196 
1197     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
1198         encodeType(buf, MAJOR_TYPE_INT, value);
1199     }
1200 
1201     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
1202         if(value >= 0) {
1203             encodeType(buf, MAJOR_TYPE_INT, uint(value));
1204         } else {
1205             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
1206         }
1207     }
1208 
1209     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
1210         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
1211         buf.append(value);
1212     }
1213 
1214     function encodeString(Buffer.buffer memory buf, string value) internal pure {
1215         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
1216         buf.append(bytes(value));
1217     }
1218 
1219     function startArray(Buffer.buffer memory buf) internal pure {
1220         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
1221     }
1222 
1223     function startMap(Buffer.buffer memory buf) internal pure {
1224         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
1225     }
1226 
1227     function endSequence(Buffer.buffer memory buf) internal pure {
1228         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
1229     }
1230 }
1231 
1232 /*
1233 End solidity-cborutils
1234  */
1235 
1236 contract usingOraclize {
1237     uint constant day = 60*60*24;
1238     uint constant week = 60*60*24*7;
1239     uint constant month = 60*60*24*30;
1240     byte constant proofType_NONE = 0x00;
1241     byte constant proofType_TLSNotary = 0x10;
1242     byte constant proofType_Ledger = 0x30;
1243     byte constant proofType_Android = 0x40;
1244     byte constant proofType_Native = 0xF0;
1245     byte constant proofStorage_IPFS = 0x01;
1246     uint8 constant networkID_auto = 0;
1247     uint8 constant networkID_mainnet = 1;
1248     uint8 constant networkID_testnet = 2;
1249     uint8 constant networkID_morden = 2;
1250     uint8 constant networkID_consensys = 161;
1251 
1252     OraclizeAddrResolverI OAR;
1253 
1254     OraclizeI oraclize;
1255     modifier oraclizeAPI {
1256         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
1257             oraclize_setNetwork(networkID_auto);
1258 
1259         if(address(oraclize) != OAR.getAddress())
1260             oraclize = OraclizeI(OAR.getAddress());
1261 
1262         _;
1263     }
1264     modifier coupon(string code){
1265         oraclize = OraclizeI(OAR.getAddress());
1266         _;
1267     }
1268 
1269     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
1270       return oraclize_setNetwork();
1271       networkID; // silence the warning and remain backwards compatible
1272     }
1273     function oraclize_setNetwork() internal returns(bool){
1274         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
1275             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
1276             oraclize_setNetworkName("eth_mainnet");
1277             return true;
1278         }
1279         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
1280             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
1281             oraclize_setNetworkName("eth_ropsten3");
1282             return true;
1283         }
1284         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
1285             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
1286             oraclize_setNetworkName("eth_kovan");
1287             return true;
1288         }
1289         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
1290             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
1291             oraclize_setNetworkName("eth_rinkeby");
1292             return true;
1293         }
1294         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
1295             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1296             return true;
1297         }
1298         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
1299             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
1300             return true;
1301         }
1302         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
1303             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
1304             return true;
1305         }
1306         return false;
1307     }
1308 
1309     function __callback(bytes32 myid, string result) public {
1310         __callback(myid, result, new bytes(0));
1311     }
1312     function __callback(bytes32 myid, string result, bytes proof) public {
1313       return;
1314       // Following should never be reached with a preceding return, however
1315       // this is just a placeholder function, ideally meant to be defined in
1316       // child contract when proofs are used
1317       myid; result; proof; // Silence compiler warnings
1318       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
1319     }
1320 
1321     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
1322         return oraclize.getPrice(datasource);
1323     }
1324 
1325     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
1326         return oraclize.getPrice(datasource, gaslimit);
1327     }
1328 
1329     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1330         uint price = oraclize.getPrice(datasource);
1331         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1332         return oraclize.query.value(price)(0, datasource, arg);
1333     }
1334     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
1335         uint price = oraclize.getPrice(datasource);
1336         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1337         return oraclize.query.value(price)(timestamp, datasource, arg);
1338     }
1339     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1340         uint price = oraclize.getPrice(datasource, gaslimit);
1341         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1342         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
1343     }
1344     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1345         uint price = oraclize.getPrice(datasource, gaslimit);
1346         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1347         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
1348     }
1349     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1350         uint price = oraclize.getPrice(datasource);
1351         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1352         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
1353     }
1354     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
1355         uint price = oraclize.getPrice(datasource);
1356         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1357         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
1358     }
1359     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1360         uint price = oraclize.getPrice(datasource, gaslimit);
1361         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1362         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
1363     }
1364     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1365         uint price = oraclize.getPrice(datasource, gaslimit);
1366         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1367         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
1368     }
1369     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1370         uint price = oraclize.getPrice(datasource);
1371         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1372         bytes memory args = stra2cbor(argN);
1373         return oraclize.queryN.value(price)(0, datasource, args);
1374     }
1375     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
1376         uint price = oraclize.getPrice(datasource);
1377         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1378         bytes memory args = stra2cbor(argN);
1379         return oraclize.queryN.value(price)(timestamp, datasource, args);
1380     }
1381     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1382         uint price = oraclize.getPrice(datasource, gaslimit);
1383         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1384         bytes memory args = stra2cbor(argN);
1385         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1386     }
1387     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1388         uint price = oraclize.getPrice(datasource, gaslimit);
1389         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1390         bytes memory args = stra2cbor(argN);
1391         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1392     }
1393     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1394         string[] memory dynargs = new string[](1);
1395         dynargs[0] = args[0];
1396         return oraclize_query(datasource, dynargs);
1397     }
1398     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1399         string[] memory dynargs = new string[](1);
1400         dynargs[0] = args[0];
1401         return oraclize_query(timestamp, datasource, dynargs);
1402     }
1403     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1404         string[] memory dynargs = new string[](1);
1405         dynargs[0] = args[0];
1406         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1407     }
1408     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1409         string[] memory dynargs = new string[](1);
1410         dynargs[0] = args[0];
1411         return oraclize_query(datasource, dynargs, gaslimit);
1412     }
1413 
1414     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1415         string[] memory dynargs = new string[](2);
1416         dynargs[0] = args[0];
1417         dynargs[1] = args[1];
1418         return oraclize_query(datasource, dynargs);
1419     }
1420     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1421         string[] memory dynargs = new string[](2);
1422         dynargs[0] = args[0];
1423         dynargs[1] = args[1];
1424         return oraclize_query(timestamp, datasource, dynargs);
1425     }
1426     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1427         string[] memory dynargs = new string[](2);
1428         dynargs[0] = args[0];
1429         dynargs[1] = args[1];
1430         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1431     }
1432     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1433         string[] memory dynargs = new string[](2);
1434         dynargs[0] = args[0];
1435         dynargs[1] = args[1];
1436         return oraclize_query(datasource, dynargs, gaslimit);
1437     }
1438     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1439         string[] memory dynargs = new string[](3);
1440         dynargs[0] = args[0];
1441         dynargs[1] = args[1];
1442         dynargs[2] = args[2];
1443         return oraclize_query(datasource, dynargs);
1444     }
1445     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1446         string[] memory dynargs = new string[](3);
1447         dynargs[0] = args[0];
1448         dynargs[1] = args[1];
1449         dynargs[2] = args[2];
1450         return oraclize_query(timestamp, datasource, dynargs);
1451     }
1452     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1453         string[] memory dynargs = new string[](3);
1454         dynargs[0] = args[0];
1455         dynargs[1] = args[1];
1456         dynargs[2] = args[2];
1457         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1458     }
1459     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1460         string[] memory dynargs = new string[](3);
1461         dynargs[0] = args[0];
1462         dynargs[1] = args[1];
1463         dynargs[2] = args[2];
1464         return oraclize_query(datasource, dynargs, gaslimit);
1465     }
1466 
1467     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1468         string[] memory dynargs = new string[](4);
1469         dynargs[0] = args[0];
1470         dynargs[1] = args[1];
1471         dynargs[2] = args[2];
1472         dynargs[3] = args[3];
1473         return oraclize_query(datasource, dynargs);
1474     }
1475     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1476         string[] memory dynargs = new string[](4);
1477         dynargs[0] = args[0];
1478         dynargs[1] = args[1];
1479         dynargs[2] = args[2];
1480         dynargs[3] = args[3];
1481         return oraclize_query(timestamp, datasource, dynargs);
1482     }
1483     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1484         string[] memory dynargs = new string[](4);
1485         dynargs[0] = args[0];
1486         dynargs[1] = args[1];
1487         dynargs[2] = args[2];
1488         dynargs[3] = args[3];
1489         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1490     }
1491     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1492         string[] memory dynargs = new string[](4);
1493         dynargs[0] = args[0];
1494         dynargs[1] = args[1];
1495         dynargs[2] = args[2];
1496         dynargs[3] = args[3];
1497         return oraclize_query(datasource, dynargs, gaslimit);
1498     }
1499     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1500         string[] memory dynargs = new string[](5);
1501         dynargs[0] = args[0];
1502         dynargs[1] = args[1];
1503         dynargs[2] = args[2];
1504         dynargs[3] = args[3];
1505         dynargs[4] = args[4];
1506         return oraclize_query(datasource, dynargs);
1507     }
1508     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1509         string[] memory dynargs = new string[](5);
1510         dynargs[0] = args[0];
1511         dynargs[1] = args[1];
1512         dynargs[2] = args[2];
1513         dynargs[3] = args[3];
1514         dynargs[4] = args[4];
1515         return oraclize_query(timestamp, datasource, dynargs);
1516     }
1517     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1518         string[] memory dynargs = new string[](5);
1519         dynargs[0] = args[0];
1520         dynargs[1] = args[1];
1521         dynargs[2] = args[2];
1522         dynargs[3] = args[3];
1523         dynargs[4] = args[4];
1524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1525     }
1526     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1527         string[] memory dynargs = new string[](5);
1528         dynargs[0] = args[0];
1529         dynargs[1] = args[1];
1530         dynargs[2] = args[2];
1531         dynargs[3] = args[3];
1532         dynargs[4] = args[4];
1533         return oraclize_query(datasource, dynargs, gaslimit);
1534     }
1535     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1536         uint price = oraclize.getPrice(datasource);
1537         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1538         bytes memory args = ba2cbor(argN);
1539         return oraclize.queryN.value(price)(0, datasource, args);
1540     }
1541     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1542         uint price = oraclize.getPrice(datasource);
1543         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1544         bytes memory args = ba2cbor(argN);
1545         return oraclize.queryN.value(price)(timestamp, datasource, args);
1546     }
1547     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1548         uint price = oraclize.getPrice(datasource, gaslimit);
1549         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1550         bytes memory args = ba2cbor(argN);
1551         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1552     }
1553     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1554         uint price = oraclize.getPrice(datasource, gaslimit);
1555         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1556         bytes memory args = ba2cbor(argN);
1557         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1558     }
1559     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1560         bytes[] memory dynargs = new bytes[](1);
1561         dynargs[0] = args[0];
1562         return oraclize_query(datasource, dynargs);
1563     }
1564     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1565         bytes[] memory dynargs = new bytes[](1);
1566         dynargs[0] = args[0];
1567         return oraclize_query(timestamp, datasource, dynargs);
1568     }
1569     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1570         bytes[] memory dynargs = new bytes[](1);
1571         dynargs[0] = args[0];
1572         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1573     }
1574     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1575         bytes[] memory dynargs = new bytes[](1);
1576         dynargs[0] = args[0];
1577         return oraclize_query(datasource, dynargs, gaslimit);
1578     }
1579 
1580     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1581         bytes[] memory dynargs = new bytes[](2);
1582         dynargs[0] = args[0];
1583         dynargs[1] = args[1];
1584         return oraclize_query(datasource, dynargs);
1585     }
1586     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1587         bytes[] memory dynargs = new bytes[](2);
1588         dynargs[0] = args[0];
1589         dynargs[1] = args[1];
1590         return oraclize_query(timestamp, datasource, dynargs);
1591     }
1592     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1593         bytes[] memory dynargs = new bytes[](2);
1594         dynargs[0] = args[0];
1595         dynargs[1] = args[1];
1596         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1597     }
1598     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1599         bytes[] memory dynargs = new bytes[](2);
1600         dynargs[0] = args[0];
1601         dynargs[1] = args[1];
1602         return oraclize_query(datasource, dynargs, gaslimit);
1603     }
1604     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1605         bytes[] memory dynargs = new bytes[](3);
1606         dynargs[0] = args[0];
1607         dynargs[1] = args[1];
1608         dynargs[2] = args[2];
1609         return oraclize_query(datasource, dynargs);
1610     }
1611     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1612         bytes[] memory dynargs = new bytes[](3);
1613         dynargs[0] = args[0];
1614         dynargs[1] = args[1];
1615         dynargs[2] = args[2];
1616         return oraclize_query(timestamp, datasource, dynargs);
1617     }
1618     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1619         bytes[] memory dynargs = new bytes[](3);
1620         dynargs[0] = args[0];
1621         dynargs[1] = args[1];
1622         dynargs[2] = args[2];
1623         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1624     }
1625     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1626         bytes[] memory dynargs = new bytes[](3);
1627         dynargs[0] = args[0];
1628         dynargs[1] = args[1];
1629         dynargs[2] = args[2];
1630         return oraclize_query(datasource, dynargs, gaslimit);
1631     }
1632 
1633     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1634         bytes[] memory dynargs = new bytes[](4);
1635         dynargs[0] = args[0];
1636         dynargs[1] = args[1];
1637         dynargs[2] = args[2];
1638         dynargs[3] = args[3];
1639         return oraclize_query(datasource, dynargs);
1640     }
1641     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1642         bytes[] memory dynargs = new bytes[](4);
1643         dynargs[0] = args[0];
1644         dynargs[1] = args[1];
1645         dynargs[2] = args[2];
1646         dynargs[3] = args[3];
1647         return oraclize_query(timestamp, datasource, dynargs);
1648     }
1649     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1650         bytes[] memory dynargs = new bytes[](4);
1651         dynargs[0] = args[0];
1652         dynargs[1] = args[1];
1653         dynargs[2] = args[2];
1654         dynargs[3] = args[3];
1655         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1656     }
1657     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1658         bytes[] memory dynargs = new bytes[](4);
1659         dynargs[0] = args[0];
1660         dynargs[1] = args[1];
1661         dynargs[2] = args[2];
1662         dynargs[3] = args[3];
1663         return oraclize_query(datasource, dynargs, gaslimit);
1664     }
1665     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1666         bytes[] memory dynargs = new bytes[](5);
1667         dynargs[0] = args[0];
1668         dynargs[1] = args[1];
1669         dynargs[2] = args[2];
1670         dynargs[3] = args[3];
1671         dynargs[4] = args[4];
1672         return oraclize_query(datasource, dynargs);
1673     }
1674     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1675         bytes[] memory dynargs = new bytes[](5);
1676         dynargs[0] = args[0];
1677         dynargs[1] = args[1];
1678         dynargs[2] = args[2];
1679         dynargs[3] = args[3];
1680         dynargs[4] = args[4];
1681         return oraclize_query(timestamp, datasource, dynargs);
1682     }
1683     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1684         bytes[] memory dynargs = new bytes[](5);
1685         dynargs[0] = args[0];
1686         dynargs[1] = args[1];
1687         dynargs[2] = args[2];
1688         dynargs[3] = args[3];
1689         dynargs[4] = args[4];
1690         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1691     }
1692     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1693         bytes[] memory dynargs = new bytes[](5);
1694         dynargs[0] = args[0];
1695         dynargs[1] = args[1];
1696         dynargs[2] = args[2];
1697         dynargs[3] = args[3];
1698         dynargs[4] = args[4];
1699         return oraclize_query(datasource, dynargs, gaslimit);
1700     }
1701 
1702     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1703         return oraclize.cbAddress();
1704     }
1705     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1706         return oraclize.setProofType(proofP);
1707     }
1708     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1709         return oraclize.setCustomGasPrice(gasPrice);
1710     }
1711 
1712     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1713         return oraclize.randomDS_getSessionPubKeyHash();
1714     }
1715 
1716     function getCodeSize(address _addr) view internal returns(uint _size) {
1717         assembly {
1718             _size := extcodesize(_addr)
1719         }
1720     }
1721 
1722     function parseAddr(string _a) internal pure returns (address){
1723         bytes memory tmp = bytes(_a);
1724         uint160 iaddr = 0;
1725         uint160 b1;
1726         uint160 b2;
1727         for (uint i=2; i<2+2*20; i+=2){
1728             iaddr *= 256;
1729             b1 = uint160(tmp[i]);
1730             b2 = uint160(tmp[i+1]);
1731             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1732             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1733             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1734             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1735             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1736             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1737             iaddr += (b1*16+b2);
1738         }
1739         return address(iaddr);
1740     }
1741 
1742     function strCompare(string _a, string _b) internal pure returns (int) {
1743         bytes memory a = bytes(_a);
1744         bytes memory b = bytes(_b);
1745         uint minLength = a.length;
1746         if (b.length < minLength) minLength = b.length;
1747         for (uint i = 0; i < minLength; i ++)
1748             if (a[i] < b[i])
1749                 return -1;
1750             else if (a[i] > b[i])
1751                 return 1;
1752         if (a.length < b.length)
1753             return -1;
1754         else if (a.length > b.length)
1755             return 1;
1756         else
1757             return 0;
1758     }
1759 
1760     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1761         bytes memory h = bytes(_haystack);
1762         bytes memory n = bytes(_needle);
1763         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1764             return -1;
1765         else if(h.length > (2**128 -1))
1766             return -1;
1767         else
1768         {
1769             uint subindex = 0;
1770             for (uint i = 0; i < h.length; i ++)
1771             {
1772                 if (h[i] == n[0])
1773                 {
1774                     subindex = 1;
1775                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1776                     {
1777                         subindex++;
1778                     }
1779                     if(subindex == n.length)
1780                         return int(i);
1781                 }
1782             }
1783             return -1;
1784         }
1785     }
1786 
1787     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1788         bytes memory _ba = bytes(_a);
1789         bytes memory _bb = bytes(_b);
1790         bytes memory _bc = bytes(_c);
1791         bytes memory _bd = bytes(_d);
1792         bytes memory _be = bytes(_e);
1793         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1794         bytes memory babcde = bytes(abcde);
1795         uint k = 0;
1796         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1797         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1798         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1799         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1800         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1801         return string(babcde);
1802     }
1803 
1804     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1805         return strConcat(_a, _b, _c, _d, "");
1806     }
1807 
1808     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1809         return strConcat(_a, _b, _c, "", "");
1810     }
1811 
1812     function strConcat(string _a, string _b) internal pure returns (string) {
1813         return strConcat(_a, _b, "", "", "");
1814     }
1815 
1816     // parseInt
1817     function parseInt(string _a) internal pure returns (uint) {
1818         return parseInt(_a, 0);
1819     }
1820 
1821     // parseInt(parseFloat*10^_b)
1822     function parseInt(string _a, uint _b) internal pure returns (uint) {
1823         bytes memory bresult = bytes(_a);
1824         uint mint = 0;
1825         bool decimals = false;
1826         for (uint i=0; i<bresult.length; i++){
1827             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1828                 if (decimals){
1829                    if (_b == 0) break;
1830                     else _b--;
1831                 }
1832                 mint *= 10;
1833                 mint += uint(bresult[i]) - 48;
1834             } else if (bresult[i] == 46) decimals = true;
1835         }
1836         if (_b > 0) mint *= 10**_b;
1837         return mint;
1838     }
1839 
1840     function uint2str(uint i) internal pure returns (string){
1841         if (i == 0) return "0";
1842         uint j = i;
1843         uint len;
1844         while (j != 0){
1845             len++;
1846             j /= 10;
1847         }
1848         bytes memory bstr = new bytes(len);
1849         uint k = len - 1;
1850         while (i != 0){
1851             bstr[k--] = byte(48 + i % 10);
1852             i /= 10;
1853         }
1854         return string(bstr);
1855     }
1856 
1857     using CBOR for Buffer.buffer;
1858     function stra2cbor(string[] arr) internal pure returns (bytes) {
1859         safeMemoryCleaner();
1860         Buffer.buffer memory buf;
1861         Buffer.init(buf, 1024);
1862         buf.startArray();
1863         for (uint i = 0; i < arr.length; i++) {
1864             buf.encodeString(arr[i]);
1865         }
1866         buf.endSequence();
1867         return buf.buf;
1868     }
1869 
1870     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1871         safeMemoryCleaner();
1872         Buffer.buffer memory buf;
1873         Buffer.init(buf, 1024);
1874         buf.startArray();
1875         for (uint i = 0; i < arr.length; i++) {
1876             buf.encodeBytes(arr[i]);
1877         }
1878         buf.endSequence();
1879         return buf.buf;
1880     }
1881 
1882     string oraclize_network_name;
1883     function oraclize_setNetworkName(string _network_name) internal {
1884         oraclize_network_name = _network_name;
1885     }
1886 
1887     function oraclize_getNetworkName() internal view returns (string) {
1888         return oraclize_network_name;
1889     }
1890 
1891     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1892         require((_nbytes > 0) && (_nbytes <= 32));
1893         // Convert from seconds to ledger timer ticks
1894         _delay *= 10;
1895         bytes memory nbytes = new bytes(1);
1896         nbytes[0] = byte(_nbytes);
1897         bytes memory unonce = new bytes(32);
1898         bytes memory sessionKeyHash = new bytes(32);
1899         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1900         assembly {
1901             mstore(unonce, 0x20)
1902             // the following variables can be relaxed
1903             // check relaxed random contract under ethereum-examples repo
1904             // for an idea on how to override and replace comit hash vars
1905             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1906             mstore(sessionKeyHash, 0x20)
1907             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1908         }
1909         bytes memory delay = new bytes(32);
1910         assembly {
1911             mstore(add(delay, 0x20), _delay)
1912         }
1913 
1914         bytes memory delay_bytes8 = new bytes(8);
1915         copyBytes(delay, 24, 8, delay_bytes8, 0);
1916 
1917         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1918         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1919 
1920         bytes memory delay_bytes8_left = new bytes(8);
1921 
1922         assembly {
1923             let x := mload(add(delay_bytes8, 0x20))
1924             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1925             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1926             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1927             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1928             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1929             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1930             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1931             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1932 
1933         }
1934 
1935         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1936         return queryId;
1937     }
1938 
1939     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1940         oraclize_randomDS_args[queryId] = commitment;
1941     }
1942 
1943     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1944     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1945 
1946     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1947         bool sigok;
1948         address signer;
1949 
1950         bytes32 sigr;
1951         bytes32 sigs;
1952 
1953         bytes memory sigr_ = new bytes(32);
1954         uint offset = 4+(uint(dersig[3]) - 0x20);
1955         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1956         bytes memory sigs_ = new bytes(32);
1957         offset += 32 + 2;
1958         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1959 
1960         assembly {
1961             sigr := mload(add(sigr_, 32))
1962             sigs := mload(add(sigs_, 32))
1963         }
1964 
1965 
1966         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1967         if (address(keccak256(pubkey)) == signer) return true;
1968         else {
1969             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1970             return (address(keccak256(pubkey)) == signer);
1971         }
1972     }
1973 
1974     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1975         bool sigok;
1976 
1977         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1978         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1979         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1980 
1981         bytes memory appkey1_pubkey = new bytes(64);
1982         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1983 
1984         bytes memory tosign2 = new bytes(1+65+32);
1985         tosign2[0] = byte(1); //role
1986         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1987         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1988         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1989         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1990 
1991         if (sigok == false) return false;
1992 
1993 
1994         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1995         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1996 
1997         bytes memory tosign3 = new bytes(1+65);
1998         tosign3[0] = 0xFE;
1999         copyBytes(proof, 3, 65, tosign3, 1);
2000 
2001         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
2002         copyBytes(proof, 3+65, sig3.length, sig3, 0);
2003 
2004         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
2005 
2006         return sigok;
2007     }
2008 
2009     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
2010         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2011         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
2012 
2013         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2014         require(proofVerified);
2015 
2016         _;
2017     }
2018 
2019     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
2020         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
2021         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
2022 
2023         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
2024         if (proofVerified == false) return 2;
2025 
2026         return 0;
2027     }
2028 
2029     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
2030         bool match_ = true;
2031 
2032         require(prefix.length == n_random_bytes);
2033 
2034         for (uint256 i=0; i< n_random_bytes; i++) {
2035             if (content[i] != prefix[i]) match_ = false;
2036         }
2037 
2038         return match_;
2039     }
2040 
2041     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
2042 
2043         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
2044         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
2045         bytes memory keyhash = new bytes(32);
2046         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
2047         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
2048 
2049         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
2050         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
2051 
2052         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
2053         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
2054 
2055         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
2056         // This is to verify that the computed args match with the ones specified in the query.
2057         bytes memory commitmentSlice1 = new bytes(8+1+32);
2058         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
2059 
2060         bytes memory sessionPubkey = new bytes(64);
2061         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
2062         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
2063 
2064         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
2065         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
2066             delete oraclize_randomDS_args[queryId];
2067         } else return false;
2068 
2069 
2070         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
2071         bytes memory tosign1 = new bytes(32+8+1+32);
2072         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
2073         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
2074 
2075         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
2076         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
2077             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
2078         }
2079 
2080         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
2081     }
2082 
2083     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2084     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
2085         uint minLength = length + toOffset;
2086 
2087         // Buffer too small
2088         require(to.length >= minLength); // Should be a better way?
2089 
2090         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
2091         uint i = 32 + fromOffset;
2092         uint j = 32 + toOffset;
2093 
2094         while (i < (32 + fromOffset + length)) {
2095             assembly {
2096                 let tmp := mload(add(from, i))
2097                 mstore(add(to, j), tmp)
2098             }
2099             i += 32;
2100             j += 32;
2101         }
2102 
2103         return to;
2104     }
2105 
2106     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2107     // Duplicate Solidity's ecrecover, but catching the CALL return value
2108     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
2109         // We do our own memory management here. Solidity uses memory offset
2110         // 0x40 to store the current end of memory. We write past it (as
2111         // writes are memory extensions), but don't update the offset so
2112         // Solidity will reuse it. The memory used here is only needed for
2113         // this context.
2114 
2115         // FIXME: inline assembly can't access return values
2116         bool ret;
2117         address addr;
2118 
2119         assembly {
2120             let size := mload(0x40)
2121             mstore(size, hash)
2122             mstore(add(size, 32), v)
2123             mstore(add(size, 64), r)
2124             mstore(add(size, 96), s)
2125 
2126             // NOTE: we can reuse the request memory because we deal with
2127             //       the return code
2128             ret := call(3000, 1, 0, size, 128, size, 32)
2129             addr := mload(size)
2130         }
2131 
2132         return (ret, addr);
2133     }
2134 
2135     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
2136     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
2137         bytes32 r;
2138         bytes32 s;
2139         uint8 v;
2140 
2141         if (sig.length != 65)
2142           return (false, 0);
2143 
2144         // The signature format is a compact form of:
2145         //   {bytes32 r}{bytes32 s}{uint8 v}
2146         // Compact means, uint8 is not padded to 32 bytes.
2147         assembly {
2148             r := mload(add(sig, 32))
2149             s := mload(add(sig, 64))
2150 
2151             // Here we are loading the last 32 bytes. We exploit the fact that
2152             // 'mload' will pad with zeroes if we overread.
2153             // There is no 'mload8' to do this, but that would be nicer.
2154             v := byte(0, mload(add(sig, 96)))
2155 
2156             // Alternative solution:
2157             // 'byte' is not working due to the Solidity parser, so lets
2158             // use the second best option, 'and'
2159             // v := and(mload(add(sig, 65)), 255)
2160         }
2161 
2162         // albeit non-transactional signatures are not specified by the YP, one would expect it
2163         // to match the YP range of [27, 28]
2164         //
2165         // geth uses [0, 1] and some clients have followed. This might change, see:
2166         //  https://github.com/ethereum/go-ethereum/issues/2053
2167         if (v < 27)
2168           v += 27;
2169 
2170         if (v != 27 && v != 28)
2171             return (false, 0);
2172 
2173         return safer_ecrecover(hash, v, r, s);
2174     }
2175 
2176     function safeMemoryCleaner() internal pure {
2177         assembly {
2178             let fmem := mload(0x40)
2179             codecopy(fmem, codesize, sub(msize, fmem))
2180         }
2181     }
2182 
2183 }
2184 // </ORACLIZE_API>
2185 
2186 /// @title JSON provides JSON parsing functionality.
2187 contract JSON is usingOraclize{
2188     using strings for *;
2189 
2190     bytes32 constant private prefixHash = keccak256("{\"ETH\":");
2191 
2192     /// @dev Extracts JSON rate value from the response object.
2193     /// @param _json body of the JSON response from the CryptoCompare API.
2194     function parseRate(string _json) public pure returns (string) {
2195 
2196         uint json_len = abi.encodePacked(_json).length;
2197         //{"ETH":}.length = 8, assuming a (maximum of) 18 digit prevision
2198         require(json_len > 8 && json_len <= 28, "misformatted input");
2199 
2200         bytes memory jsonPrefix = new bytes(7);
2201         copyBytes(abi.encodePacked(_json), 0, 7, jsonPrefix, 0);
2202         require(keccak256(jsonPrefix) == prefixHash, "prefix mismatch");
2203 
2204         strings.slice memory body = _json.toSlice();
2205         body.split(":".toSlice()); //we are sure that ':' is included in the string, body now contains the rate+'}'
2206         json_len = body._len;
2207         body.until("}".toSlice());
2208         require(body._len == json_len-1,"not json format"); //ensure that the json is properly terminated with a '}'
2209         return body.toString();
2210 
2211     }
2212 }
2213 
2214 /**
2215  * The MIT License (MIT)
2216  * 
2217  * Copyright (c) 2016 Smart Contract Solutions, Inc.
2218  * 
2219  * Permission is hereby granted, free of charge, to any person obtaining
2220  * a copy of this software and associated documentation files (the
2221  * "Software"), to deal in the Software without restriction, including
2222  * without limitation the rights to use, copy, modify, merge, publish,
2223  * distribute, sublicense, and/or sell copies of the Software, and to
2224  * permit persons to whom the Software is furnished to do so, subject to
2225  * the following conditions:
2226  * 
2227  * The above copyright notice and this permission notice shall be included
2228  * in all copies or substantial portions of the Software.
2229  * 
2230  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
2231  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
2232  * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
2233  * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
2234  * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
2235  * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
2236  * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
2237  */
2238 
2239 /**
2240  * @title SafeMath
2241  * @dev Math operations with safety checks that revert on error
2242  */
2243 library SafeMath {
2244 
2245   /**
2246   * @dev Multiplies two numbers, reverts on overflow.
2247   */
2248   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2249     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2250     // benefit is lost if 'b' is also tested.
2251     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2252     if (a == 0) {
2253       return 0;
2254     }
2255 
2256     uint256 c = a * b;
2257     require(c / a == b);
2258 
2259     return c;
2260   }
2261 
2262   /**
2263   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2264   */
2265   function div(uint256 a, uint256 b) internal pure returns (uint256) {
2266     require(b > 0); // Solidity only automatically asserts when dividing by 0
2267     uint256 c = a / b;
2268     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
2269 
2270     return c;
2271   }
2272 
2273   /**
2274   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2275   */
2276   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2277     require(b <= a);
2278     uint256 c = a - b;
2279 
2280     return c;
2281   }
2282 
2283   /**
2284   * @dev Adds two numbers, reverts on overflow.
2285   */
2286   function add(uint256 a, uint256 b) internal pure returns (uint256) {
2287     uint256 c = a + b;
2288     require(c >= a);
2289 
2290     return c;
2291   }
2292 
2293   /**
2294   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2295   * reverts when dividing by zero.
2296   */
2297   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2298     require(b != 0);
2299     return a % b;
2300   }
2301 }
2302 
2303 /// @title ParseIntScientific provides floating point in scientific notation (e.g. e-5) parsing functionality.
2304 contract ParseIntScientific {
2305 
2306     using SafeMath for uint256;
2307 
2308     byte constant private PLUS_ASCII = byte(43); //decimal value of '+'
2309     byte constant private DASH_ASCII = byte(45); //decimal value of '-'
2310     byte constant private DOT_ASCII = byte(46); //decimal value of '.'
2311     byte constant private ZERO_ASCII = byte(48); //decimal value of '0'
2312     byte constant private NINE_ASCII = byte(57); //decimal value of '9'
2313     byte constant private E_ASCII = byte(69); //decimal value of 'E'
2314     byte constant private e_ASCII = byte(101); //decimal value of 'e'
2315 
2316     /// @dev ParseIntScientific delegates the call to _parseIntScientific(string, uint) with the 2nd argument being 0.
2317     function _parseIntScientific(string _inString) internal pure returns (uint) {
2318         return _parseIntScientific(_inString, 0);
2319     }
2320 
2321     /// @dev ParseIntScientificWei parses a rate expressed in ETH and returns its wei denomination
2322     function _parseIntScientificWei(string _inString) internal pure returns (uint) {
2323         return _parseIntScientific(_inString, 18);
2324     }
2325 
2326     /// @dev ParseIntScientific parses a JSON standard - floating point number.
2327     /// @param _inString is input string.
2328     /// @param _magnitudeMult multiplies the number with 10^_magnitudeMult.
2329     function _parseIntScientific(string _inString, uint _magnitudeMult) internal pure returns (uint) {
2330 
2331         bytes memory inBytes = bytes(_inString);
2332         uint mint = 0; // the final uint returned
2333         uint mintDec = 0; // the uint following the decimal point
2334         uint mintExp = 0; // the exponent
2335         uint decMinted = 0; // how many decimals were 'minted'.
2336         uint expIndex = 0; // the position in the byte array that 'e' was found (if found)
2337         bool integral = false; // indicates the existence of the integral part, it should always exist (even if 0) e.g. 'e+1'  or '.1' is not valid
2338         bool decimals = false; // indicates a decimal number, set to true if '.' is found
2339         bool exp = false; // indicates if the number being parsed has an exponential representation
2340         bool minus = false; // indicated if the exponent is negative
2341         bool plus = false; // indicated if the exponent is positive
2342 
2343         for (uint i = 0; i < inBytes.length; i++) {
2344             if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (!exp)) {
2345                 // 'e' not encountered yet, minting integer part or decimals
2346                 if (decimals) {
2347                     // '.' encountered
2348                     //use safeMath in case there is an overflow
2349                     mintDec = mintDec.mul(10);
2350                     mintDec = mintDec.add(uint(inBytes[i]) - uint(ZERO_ASCII));
2351                     decMinted++; //keep track of the #decimals
2352                 } else {
2353                     // integral part (before '.')
2354                     integral = true;
2355                     //use safeMath in case there is an overflow
2356                     mint = mint.mul(10);
2357                     mint = mint.add(uint(inBytes[i]) - uint(ZERO_ASCII));
2358                 }
2359             } else if ((inBytes[i] >= ZERO_ASCII) && (inBytes[i] <= NINE_ASCII) && (exp)) {
2360                 //exponential notation (e-/+) has been detected, mint the exponent
2361                 mintExp = mintExp.mul(10);
2362                 mintExp = mintExp.add(uint(inBytes[i]) - uint(ZERO_ASCII));
2363             } else if (inBytes[i] == DOT_ASCII) {
2364                 //an integral part before should always exist before '.'
2365                 require(integral, "missing integral part");
2366                 // an extra decimal point makes the format invalid
2367                 require(!decimals, "duplicate decimal point");
2368                 //the decimal point should always be before the exponent
2369                 require(!exp, "decimal after exponent");
2370                 decimals = true;
2371             } else if (inBytes[i] == DASH_ASCII) {
2372                 // an extra '-' should be considered an invalid character
2373                 require(!minus, "duplicate -");
2374                 require(!plus, "extra sign");
2375                 require(expIndex + 1 == i, "- sign not immediately after e");
2376                 minus = true;
2377             } else if (inBytes[i] == PLUS_ASCII) {
2378                 // an extra '+' should be considered an invalid character
2379                 require(!plus, "duplicate +");
2380                 require(!minus, "extra sign");
2381                 require(expIndex + 1 == i, "+ sign not immediately after e");
2382                 plus = true;
2383             } else if ((inBytes[i] == E_ASCII) || (inBytes[i] == e_ASCII)) {
2384                 //an integral part before should always exist before 'e'
2385                 require(integral, "missing integral part");
2386                 // an extra 'e' or 'E' should be considered an invalid character
2387                 require(!exp, "duplicate exponent symbol");
2388                 exp = true;
2389                 expIndex = i;
2390             } else {
2391                 revert("invalid digit");
2392             }
2393         }
2394 
2395         if (minus || plus) {
2396             // end of string e[x|-] without specifying the exponent
2397             require(i > expIndex + 2);
2398         } else if (exp) {
2399             // end of string (e) without specifying the exponent
2400             require(i > expIndex + 1);
2401         }
2402 
2403         if (minus) {
2404             // e^(-x)
2405             if (mintExp >= _magnitudeMult) {
2406                 // the (negative) exponent is bigger than the given parameter for "shifting left".
2407                 // use integer division to reduce the precision.
2408                 require(mintExp - _magnitudeMult < 78, "exponent > 77"); //
2409                 mint /= 10 ** (mintExp - _magnitudeMult);
2410                 return mint;
2411 
2412             } else {
2413                 // the (negative) exponent is smaller than the given parameter for "shifting left".
2414                 //no need for underflow check
2415                 _magnitudeMult = _magnitudeMult - mintExp;
2416             }
2417         } else {
2418             // e^(+x), positive exponent or no exponent
2419             // just shift left as many times as indicated by the exponent and the shift parameter
2420             _magnitudeMult = _magnitudeMult.add(mintExp);
2421           }
2422 
2423           if (_magnitudeMult >= decMinted) {
2424               // the decimals are fewer or equal than the shifts: use all of them
2425               // shift number and add the decimals at the end
2426               // include decimals if present in the original input
2427               require(decMinted < 78, "more than 77 decimal digits parsed"); //
2428               mint = mint.mul(10 ** (decMinted));
2429               mint = mint.add(mintDec);
2430               //// add zeros at the end if the decimals were fewer than #_magnitudeMult
2431               require(_magnitudeMult - decMinted < 78, "exponent > 77"); //
2432               mint = mint.mul(10 ** (_magnitudeMult - decMinted));
2433           } else {
2434               // the decimals are more than the #_magnitudeMult shifts
2435               // use only the ones needed, discard the rest
2436               decMinted -= _magnitudeMult;
2437               require(decMinted < 78, "more than 77 decimal digits parsed"); //
2438               mintDec /= 10 ** (decMinted);
2439               // shift number and add the decimals at the end
2440               require(_magnitudeMult < 78, "more than 77 decimal digits parsed"); //
2441               mint = mint.mul(10 ** (_magnitudeMult));
2442               mint = mint.add(mintDec);
2443           }
2444 
2445         return mint;
2446     }
2447 }
2448 
2449 /**
2450  * This method was modified from the GPLv3 solidity code found in this repository
2451  * https://github.com/vcealicu/melonport-price-feed/blob/master/pricefeed/PriceFeed.sol
2452  */
2453 
2454 /// @title Base64 provides base 64 decoding functionality.
2455 contract Base64 {
2456     bytes constant BASE64_DECODE_CHAR = hex"000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e003e003f3435363738393a3b3c3d00000000000000000102030405060708090a0b0c0d0e0f10111213141516171819000000003f001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f30313233";
2457 
2458     /// @return decoded array of bytes.
2459     /// @param _encoded base 64 encoded array of bytes.
2460     function _base64decode(bytes _encoded) internal pure returns (bytes) {
2461         byte v1;
2462         byte v2;
2463         byte v3;
2464         byte v4;
2465         uint length = _encoded.length;
2466         bytes memory result = new bytes(length);
2467         uint index;
2468 
2469         // base64 encoded strings can't be length 0 and they must be divisble by 4
2470         require(length > 0  && length % 4 == 0, "invalid base64 encoding");
2471 
2472           if (keccak256(abi.encodePacked(_encoded[length - 2])) == keccak256("=")) {
2473               length -= 2;
2474           } else if (keccak256(abi.encodePacked(_encoded[length - 1])) == keccak256("=")) {
2475               length -= 1;
2476           }
2477           uint count = length >> 2 << 2;
2478           for (uint i = 0; i < count;) {
2479               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2480               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2481               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2482               v4 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2483 
2484               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2485               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2486               result[index++] = (v3 << 6 | v4) & 255;
2487           }
2488           if (length - count == 2) {
2489               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2490               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2491               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2492           } else if (length - count == 3) {
2493               v1 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2494               v2 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2495               v3 = BASE64_DECODE_CHAR[uint(_encoded[i++])];
2496 
2497               result[index++] = (v1 << 2 | v2 >> 4) & 255;
2498               result[index++] = (v2 << 4 | v3 >> 2) & 255;
2499           }
2500 
2501         // Set to correct length.
2502         assembly {
2503             mstore(result, index)
2504         }
2505 
2506         return result;
2507     }
2508 }
2509 
2510 
2511 /// @title Oracle converts ERC20 token amounts into equivalent ether amounts based on cryptocurrency exchange rates.
2512 interface IOracle {
2513     function convert(address, uint) external view returns (bool, uint);
2514 }
2515 
2516 
2517 /// @title Oracle provides asset exchange rates and conversion functionality.
2518 contract Oracle is usingOraclize, Base64, Date, JSON, Controllable, ParseIntScientific, IOracle {
2519     using strings for *;
2520     using SafeMath for uint256;
2521 
2522 
2523     /*******************/
2524     /*     Events     */
2525     /*****************/
2526 
2527     event AddedToken(address _sender, address _token, string _symbol, uint _magnitude);
2528     event RemovedToken(address _sender, address _token);
2529     event UpdatedTokenRate(address _sender, address _token, uint _rate);
2530 
2531     event SetGasPrice(address _sender, uint _gasPrice);
2532     event Converted(address _sender, address _token, uint _amount, uint _ether);
2533 
2534     event RequestedUpdate(string _symbol);
2535     event FailedUpdateRequest(string _reason);
2536 
2537     event VerifiedProof(bytes _publicKey, string _result);
2538 
2539     event SetCryptoComparePublicKey(address _sender, bytes _publicKey);
2540 
2541     /**********************/
2542     /*     Constants     */
2543     /********************/
2544 
2545     uint constant private PROOF_LEN = 165;
2546     uint constant private ECDSA_SIG_LEN = 65;
2547     uint constant private ENCODING_BYTES = 2;
2548     uint constant private HEADERS_LEN = PROOF_LEN - 2 * ENCODING_BYTES - ECDSA_SIG_LEN; // 2 bytes encoding headers length + 2 for signature.
2549     uint constant private DIGEST_BASE64_LEN = 44; //base64 encoding of the SHA256 hash (32-bytes) of the result: fixed length.
2550     uint constant private DIGEST_OFFSET = HEADERS_LEN - DIGEST_BASE64_LEN; // the starting position of the result hash in the headers string.
2551 
2552     uint constant private MAX_BYTE_SIZE = 256; //for calculating length encoding
2553 
2554     struct Token {
2555         string symbol;    // Token symbol
2556         uint magnitude;   // 10^decimals
2557         uint rate;        // Token exchange rate in wei
2558         uint lastUpdate;  // Time of the last rate update
2559         bool exists;      // Flags if the struct is empty or not
2560     }
2561 
2562     mapping(address => Token) public tokens;
2563     address[] private _tokenAddresses;
2564 
2565     bytes public APIPublicKey;
2566     mapping(bytes32 => address) private _queryToToken;
2567 
2568     /// @dev Construct the oracle with multiple controllers, address resolver and custom gas price.
2569     /// @dev _resolver is the oraclize address resolver contract address.
2570     /// @param _ens is the address of the ENS.
2571     /// @param _controllerName is the ENS name of the Controller.
2572     constructor(address _resolver, address _ens, bytes32 _controllerName) Controllable(_ens, _controllerName) public {
2573         APIPublicKey = hex"a0f4f688350018ad1b9785991c0bde5f704b005dc79972b114dbed4a615a983710bfc647ebe5a320daa28771dce6a2d104f5efa2e4a85ba3760b76d46f8571ca";
2574         OAR = OraclizeAddrResolverI(_resolver);
2575         oraclize_setCustomGasPrice(10000000000);
2576         oraclize_setProof(proofType_Native);
2577     }
2578 
2579     /// @dev Updates the Crypto Compare public API key.
2580     function updateAPIPublicKey(bytes _publicKey) external onlyController {
2581         APIPublicKey = _publicKey;
2582         emit SetCryptoComparePublicKey(msg.sender, _publicKey);
2583     }
2584 
2585     /// @dev Sets the gas price used by oraclize query.
2586     function setCustomGasPrice(uint _gasPrice) external onlyController {
2587         oraclize_setCustomGasPrice(_gasPrice);
2588         emit SetGasPrice(msg.sender, _gasPrice);
2589     }
2590 
2591     /// @dev Convert ERC20 token amount to the corresponding ether amount (used by the wallet contract).
2592     /// @param _token ERC20 token contract address.
2593     /// @param _amount amount of token in base units.
2594     function convert(address _token, uint _amount) external view returns (bool, uint) {
2595         // Store the token in memory to save map entry lookup gas.
2596         Token storage token = tokens[_token];
2597         // If the token exists require that its rate is not zero
2598         if (token.exists) {
2599             require(token.rate != 0, "token rate is 0");
2600             // Safely convert the token amount to ether based on the exchange rate.
2601             // return the value and a 'true' implying that the token is protected
2602             return (true, _amount.mul(token.rate).div(token.magnitude));
2603         }
2604         // this returns a 'false' to imply that a card is not protected 
2605         return (false, 0);
2606         
2607     }
2608 
2609     /// @dev Add ERC20 tokens to the list of supported tokens.
2610     /// @param _tokens ERC20 token contract addresses.
2611     /// @param _symbols ERC20 token names.
2612     /// @param _magnitude 10 to the power of number of decimal places used by each ERC20 token.
2613     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2614     function addTokens(address[] _tokens, bytes32[] _symbols, uint[] _magnitude, uint _updateDate) external onlyController {
2615         // Require that all parameters have the same length.
2616         require(_tokens.length == _symbols.length && _tokens.length == _magnitude.length, "parameter lengths do not match");
2617         // Add each token to the list of supported tokens.
2618         for (uint i = 0; i < _tokens.length; i++) {
2619             // Require that the token doesn't already exist.
2620             address token = _tokens[i];
2621             require(!tokens[token].exists, "token already exists");
2622             // Store the intermediate values.
2623             string memory symbol = _symbols[i].toSliceB32().toString();
2624             uint magnitude = _magnitude[i];
2625             // Add the token to the token list.
2626             tokens[token] = Token({
2627                 symbol : symbol,
2628                 magnitude : magnitude,
2629                 rate : 0,
2630                 exists : true,
2631                 lastUpdate: _updateDate
2632             });
2633             // Add the token address to the address list.
2634             _tokenAddresses.push(token);
2635             // Emit token addition event.
2636             emit AddedToken(msg.sender, token, symbol, magnitude);
2637         }
2638     }
2639 
2640     /// @dev Remove ERC20 tokens from the list of supported tokens.
2641     /// @param _tokens ERC20 token contract addresses.
2642     function removeTokens(address[] _tokens) external onlyController {
2643         // Delete each token object from the list of supported tokens based on the addresses provided.
2644         for (uint i = 0; i < _tokens.length; i++) {
2645             //token must exist, reverts on duplicates as well
2646             require(tokens[_tokens[i]].exists, "token does not exist");
2647             // Store the token address.
2648             address token = _tokens[i];
2649             // Delete the token object.
2650             delete tokens[token];
2651             // Remove the token address from the address list.
2652             for (uint j = 0; j < _tokenAddresses.length.sub(1); j++) {
2653                 if (_tokenAddresses[j] == token) {
2654                     _tokenAddresses[j] = _tokenAddresses[_tokenAddresses.length.sub(1)];
2655                     break;
2656                 }
2657             }
2658             _tokenAddresses.length--;
2659             // Emit token removal event.
2660             emit RemovedToken(msg.sender, token);
2661         }
2662     }
2663 
2664     /// @dev Update ERC20 token exchange rate manually.
2665     /// @param _token ERC20 token contract address.
2666     /// @param _rate ERC20 token exchange rate in wei.
2667     /// @param _updateDate date for the token updates. This will be compared to when oracle updates are received.
2668     function updateTokenRate(address _token, uint _rate, uint _updateDate) external onlyController {
2669         // Require that the token exists.
2670         require(tokens[_token].exists, "token does not exist");
2671         // Update the token's rate.
2672         tokens[_token].rate = _rate;
2673         // Update the token's last update timestamp.
2674         tokens[_token].lastUpdate = _updateDate;
2675         // Emit the rate update event.
2676         emit UpdatedTokenRate(msg.sender, _token, _rate);
2677     }
2678 
2679     /// @dev Update ERC20 token exchange rates for all supported tokens.
2680     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2681     function updateTokenRates(uint _gasLimit) external payable onlyController {
2682         _updateTokenRates(_gasLimit);
2683     }
2684 
2685     //// @dev Withdraw ether from the smart contract to the specified account.
2686     function withdraw(address _to, uint _amount) external onlyController {
2687         _to.transfer(_amount);
2688     }
2689 
2690     //// @dev Handle Oraclize query callback and verifiy the provided origin proof.
2691     //// @param _queryID Oraclize query ID.
2692     //// @param _result query result in JSON format.
2693     //// @param _proof origin proof from crypto compare.
2694     // solium-disable-next-line mixedcase
2695     function __callback(bytes32 _queryID, string _result, bytes _proof) public {
2696         // Require that the caller is the Oraclize contract.
2697         require(msg.sender == oraclize_cbAddress(), "sender is not oraclize");
2698         // Use the query ID to find the matching token address.
2699         address _token = _queryToToken[_queryID];
2700         require(_token != address(0), "queryID matches to address 0");
2701         // Get the corresponding token object.
2702         Token storage token = tokens[_token];
2703 
2704         bool valid;
2705         uint timestamp;
2706         (valid, timestamp) = _verifyProof(_result, _proof, APIPublicKey, token.lastUpdate);
2707 
2708         // Require that the proof is valid.
2709         if (valid) {
2710             // Parse the JSON result to get the rate in wei.
2711             token.rate = _parseIntScientificWei(parseRate(_result));
2712             // Set the update time of the token rate.
2713             token.lastUpdate = timestamp;
2714             // Remove query from the list.
2715             delete _queryToToken[_queryID];
2716             // Emit the rate update event.
2717             emit UpdatedTokenRate(msg.sender, _token, token.rate);
2718         }
2719     }
2720 
2721     /// @dev Re-usable helper function that performs the Oraclize Query.
2722     //// @param _gasLimit the gas limit is passed, this is used for the Oraclize callback
2723     function _updateTokenRates(uint _gasLimit) private {
2724         // Check if there are any existing tokens.
2725         if (_tokenAddresses.length == 0) {
2726             // Emit a query failure event.
2727             emit FailedUpdateRequest("no tokens");
2728         // Check if the contract has enough Ether to pay for the query.
2729         } else if (oraclize_getPrice("URL") * _tokenAddresses.length > address(this).balance) {
2730             // Emit a query failure event.
2731             emit FailedUpdateRequest("insufficient balance");
2732         } else {
2733             // Set up the cryptocompare API query strings.
2734             strings.slice memory apiPrefix = "https://min-api.cryptocompare.com/data/price?fsym=".toSlice();
2735             strings.slice memory apiSuffix = "&tsyms=ETH&sign=true".toSlice();
2736 
2737             // Create a new oraclize query for each supported token.
2738             for (uint i = 0; i < _tokenAddresses.length; i++) {
2739                 // Store the token symbol used in the query.
2740                 strings.slice memory symbol = tokens[_tokenAddresses[i]].symbol.toSlice();
2741                 // Create a new oraclize query from the component strings.
2742                 bytes32 queryID = oraclize_query("URL", apiPrefix.concat(symbol).toSlice().concat(apiSuffix), _gasLimit);
2743                 // Store the query ID together with the associated token address.
2744                 _queryToToken[queryID] = _tokenAddresses[i];
2745                 // Emit the query success event.
2746                 emit RequestedUpdate(symbol.toString());
2747             }
2748         }
2749     }
2750 
2751     /// @dev Verify the origin proof returned by the cryptocompare API.
2752     /// @param _result query result in JSON format.
2753     /// @param _proof origin proof from cryptocompare.
2754     /// @param _publicKey cryptocompare public key.
2755     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2756     function _verifyProof(string _result, bytes _proof, bytes _publicKey, uint _lastUpdate) private returns (bool, uint) {
2757 
2758         //expecting fixed length proofs
2759         if (_proof.length != PROOF_LEN)
2760           revert("invalid proof length");
2761 
2762         //proof should be 65 bytes long: R (32 bytes) + S (32 bytes) + v (1 byte)
2763         if (uint(_proof[1]) != ECDSA_SIG_LEN)
2764           revert("invalid signature length");
2765 
2766         bytes memory signature = new bytes(ECDSA_SIG_LEN);
2767 
2768         signature = copyBytes(_proof, 2, ECDSA_SIG_LEN, signature, 0);
2769 
2770         // Extract the headers, big endian encoding of headers length
2771         if (uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN]) * MAX_BYTE_SIZE + uint(_proof[ENCODING_BYTES + ECDSA_SIG_LEN + 1]) != HEADERS_LEN)
2772           revert("invalid headers length");
2773 
2774         bytes memory headers = new bytes(HEADERS_LEN);
2775         headers = copyBytes(_proof, 2*ENCODING_BYTES + ECDSA_SIG_LEN, HEADERS_LEN, headers, 0);
2776 
2777         // Check if the signature is valid and if the signer address is matching.
2778         if (!_verifySignature(headers, signature, _publicKey)) {
2779             revert("invalid signature");
2780         }
2781 
2782         // Check if the date is valid.
2783         bytes memory dateHeader = new bytes(20);
2784         //keep only the relevant string(e.g. "16 Nov 2018 16:22:18")
2785         dateHeader = copyBytes(headers, 11, 20, dateHeader, 0);
2786 
2787         bool dateValid;
2788         uint timestamp;
2789         (dateValid, timestamp) = _verifyDate(string(dateHeader), _lastUpdate);
2790 
2791         // Check whether the date returned is valid or not
2792         if (!dateValid)
2793             revert("invalid date");
2794 
2795         // Check if the signed digest hash matches the result hash.
2796         bytes memory digest = new bytes(DIGEST_BASE64_LEN);
2797         digest = copyBytes(headers, DIGEST_OFFSET, DIGEST_BASE64_LEN, digest, 0);
2798 
2799         if (keccak256(abi.encodePacked(sha256(abi.encodePacked(_result)))) != keccak256(_base64decode(digest)))
2800           revert("result hash not matching");
2801 
2802         emit VerifiedProof(_publicKey, _result);
2803         return (true, timestamp);
2804     }
2805 
2806     /// @dev Verify the HTTP headers and the signature
2807     /// @param _headers HTTP headers provided by the cryptocompare api
2808     /// @param _signature signature provided by the cryptocompare api
2809     /// @param _publicKey cryptocompare public key.
2810     function _verifySignature(bytes _headers, bytes _signature, bytes _publicKey) private returns (bool) {
2811         address signer;
2812         bool signatureOK;
2813 
2814         // Checks if the signature is valid by hashing the headers
2815         (signatureOK, signer) = ecrecovery(sha256(_headers), _signature);
2816         return signatureOK && signer == address(keccak256(_publicKey));
2817     }
2818 
2819     /// @dev Verify the signed HTTP date header.
2820     /// @param _dateHeader extracted date string e.g. Wed, 12 Sep 2018 15:18:14 GMT.
2821     /// @param _lastUpdate timestamp of the last time the requested token was updated.
2822     function _verifyDate(string _dateHeader, uint _lastUpdate) private pure returns (bool, uint) {
2823 
2824         //called by verifyProof(), _dateHeader is always a string of length = 20
2825         assert(abi.encodePacked(_dateHeader).length == 20);
2826 
2827         //Split the date string and get individual date components.
2828         strings.slice memory date = _dateHeader.toSlice();
2829         strings.slice memory timeDelimiter = ":".toSlice();
2830         strings.slice memory dateDelimiter = " ".toSlice();
2831 
2832         uint day = _parseIntScientific(date.split(dateDelimiter).toString());
2833         require(day > 0 && day < 32, "day error");
2834 
2835         uint month = _monthToNumber(date.split(dateDelimiter).toString());
2836         require(month > 0 && month < 13, "month error");
2837 
2838         uint year = _parseIntScientific(date.split(dateDelimiter).toString());
2839         require(year > 2017 && year < 3000, "year error");
2840 
2841         uint hour = _parseIntScientific(date.split(timeDelimiter).toString());
2842         require(hour < 25, "hour error");
2843 
2844         uint minute = _parseIntScientific(date.split(timeDelimiter).toString());
2845         require(minute < 60, "minute error");
2846 
2847         uint second = _parseIntScientific(date.split(timeDelimiter).toString());
2848         require(second < 60, "second error");
2849 
2850         uint timestamp = year * (10 ** 10) + month * (10 ** 8) + day * (10 ** 6) + hour * (10 ** 4) + minute * (10 ** 2) + second;
2851 
2852         return (timestamp > _lastUpdate, timestamp);
2853     }
2854 }
2855 
2856 /// @title Ownable has an owner address and provides basic authorization control functions.
2857 /// This contract is modified version of the MIT OpenZepplin Ownable contract 
2858 /// This contract doesn't allow for multiple changeOwner operations
2859 /// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
2860 contract Ownable {
2861     event TransferredOwnership(address _from, address _to);
2862 
2863     address private _owner;
2864     bool private _isTransferable;
2865 
2866     /// @dev Constructor sets the original owner of the contract and whether or not it is one time transferable.
2867     constructor(address _account, bool _transferable) internal {
2868         _owner = _account;
2869         _isTransferable = _transferable;
2870         emit TransferredOwnership(address(0), _account);
2871     }
2872 
2873     /// @dev Reverts if called by any account other than the owner.
2874     modifier onlyOwner() {
2875         require(_isOwner(), "sender is not an owner");
2876         _;
2877     }
2878 
2879     /// @dev Allows the current owner to transfer control of the contract to a new address.
2880     /// @param _account address to transfer ownership to.
2881     function transferOwnership(address _account) external onlyOwner {
2882         // Require that the ownership is transferable.
2883         require(_isTransferable, "ownership is not transferable");
2884         // Require that the new owner is not the zero address.
2885         require(_account != address(0), "owner cannot be set to zero address");
2886         // Set the transferable flag to false.
2887         _isTransferable = false;
2888         // Emit the ownership transfer event.
2889         emit TransferredOwnership(_owner, _account);
2890         // Set the owner to the provided address.
2891         _owner = _account;
2892     }
2893 
2894     /// @dev Allows the current owner to relinquish control of the contract.
2895     /// @notice Renouncing to ownership will leave the contract without an owner and unusable.
2896     /// It will not be possible to call the functions with the `onlyOwner` modifier anymore.
2897     function renounceOwnership() public onlyOwner {
2898         // Require that the ownership is transferable.
2899         require(_isTransferable, "ownership is not transferable");
2900         emit TransferredOwnership(_owner, address(0));
2901         // note that this could be terminal
2902         _owner = address(0);
2903     }
2904 
2905     /// @return the address of the owner.
2906     function owner() public view returns (address) {
2907         return _owner;
2908     }
2909 
2910     /// @return true if the ownership is transferable.
2911     function isTransferable() public view returns (bool) {
2912         return _isTransferable;
2913     }
2914 
2915     /// @return true if sender is the owner of the contract.
2916     function _isOwner() internal view returns (bool) {
2917         return msg.sender == _owner;
2918     }
2919 }
2920 
2921 /**
2922  * BSD 2-Clause License
2923  * 
2924  * Copyright (c) 2018, True Names Limited
2925  * All rights reserved.
2926  * 
2927  * Redistribution and use in source and binary forms, with or without
2928  * modification, are permitted provided that the following conditions are met:
2929  * 
2930  * * Redistributions of source code must retain the above copyright notice, this
2931  *   list of conditions and the following disclaimer.
2932  * 
2933  * * Redistributions in binary form must reproduce the above copyright notice,
2934  *   this list of conditions and the following disclaimer in the documentation
2935  *   and/or other materials provided with the distribution.
2936  * 
2937  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
2938  * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
2939  * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
2940  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
2941  * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
2942  * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
2943  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
2944  * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
2945  * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
2946  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
2947 */
2948 
2949 /**
2950  * A simple resolver anyone can use; only allows the owner of a node to set its
2951  * address.
2952  */
2953 contract PublicResolver {
2954 
2955     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
2956     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
2957     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
2958     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
2959     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
2960     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
2961     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
2962     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
2963 
2964     event AddrChanged(bytes32 indexed node, address a);
2965     event ContentChanged(bytes32 indexed node, bytes32 hash);
2966     event NameChanged(bytes32 indexed node, string name);
2967     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
2968     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
2969     event TextChanged(bytes32 indexed node, string indexedKey, string key);
2970     event MultihashChanged(bytes32 indexed node, bytes hash);
2971 
2972     struct PublicKey {
2973         bytes32 x;
2974         bytes32 y;
2975     }
2976 
2977     struct Record {
2978         address addr;
2979         bytes32 content;
2980         string name;
2981         PublicKey pubkey;
2982         mapping(string=>string) text;
2983         mapping(uint256=>bytes) abis;
2984         bytes multihash;
2985     }
2986 
2987     ENS ens;
2988 
2989     mapping (bytes32 => Record) records;
2990 
2991     modifier only_owner(bytes32 node) {
2992         require(ens.owner(node) == msg.sender);
2993         _;
2994     }
2995 
2996     /**
2997      * Constructor.
2998      * @param ensAddr The ENS registrar contract.
2999      */
3000     constructor(ENS ensAddr) public {
3001         ens = ensAddr;
3002     }
3003 
3004     /**
3005      * Sets the address associated with an ENS node.
3006      * May only be called by the owner of that node in the ENS registry.
3007      * @param node The node to update.
3008      * @param addr The address to set.
3009      */
3010     function setAddr(bytes32 node, address addr) public only_owner(node) {
3011         records[node].addr = addr;
3012         emit AddrChanged(node, addr);
3013     }
3014 
3015     /**
3016      * Sets the content hash associated with an ENS node.
3017      * May only be called by the owner of that node in the ENS registry.
3018      * Note that this resource type is not standardized, and will likely change
3019      * in future to a resource type based on multihash.
3020      * @param node The node to update.
3021      * @param hash The content hash to set
3022      */
3023     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
3024         records[node].content = hash;
3025         emit ContentChanged(node, hash);
3026     }
3027 
3028     /**
3029      * Sets the multihash associated with an ENS node.
3030      * May only be called by the owner of that node in the ENS registry.
3031      * @param node The node to update.
3032      * @param hash The multihash to set
3033      */
3034     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
3035         records[node].multihash = hash;
3036         emit MultihashChanged(node, hash);
3037     }
3038     
3039     /**
3040      * Sets the name associated with an ENS node, for reverse records.
3041      * May only be called by the owner of that node in the ENS registry.
3042      * @param node The node to update.
3043      * @param name The name to set.
3044      */
3045     function setName(bytes32 node, string name) public only_owner(node) {
3046         records[node].name = name;
3047         emit NameChanged(node, name);
3048     }
3049 
3050     /**
3051      * Sets the ABI associated with an ENS node.
3052      * Nodes may have one ABI of each content type. To remove an ABI, set it to
3053      * the empty string.
3054      * @param node The node to update.
3055      * @param contentType The content type of the ABI
3056      * @param data The ABI data.
3057      */
3058     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
3059         // Content types must be powers of 2
3060         require(((contentType - 1) & contentType) == 0);
3061         
3062         records[node].abis[contentType] = data;
3063         emit ABIChanged(node, contentType);
3064     }
3065     
3066     /**
3067      * Sets the SECP256k1 public key associated with an ENS node.
3068      * @param node The ENS node to query
3069      * @param x the X coordinate of the curve point for the public key.
3070      * @param y the Y coordinate of the curve point for the public key.
3071      */
3072     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
3073         records[node].pubkey = PublicKey(x, y);
3074         emit PubkeyChanged(node, x, y);
3075     }
3076 
3077     /**
3078      * Sets the text data associated with an ENS node and key.
3079      * May only be called by the owner of that node in the ENS registry.
3080      * @param node The node to update.
3081      * @param key The key to set.
3082      * @param value The text data value to set.
3083      */
3084     function setText(bytes32 node, string key, string value) public only_owner(node) {
3085         records[node].text[key] = value;
3086         emit TextChanged(node, key, key);
3087     }
3088 
3089     /**
3090      * Returns the text data associated with an ENS node and key.
3091      * @param node The ENS node to query.
3092      * @param key The text data key to query.
3093      * @return The associated text data.
3094      */
3095     function text(bytes32 node, string key) public view returns (string) {
3096         return records[node].text[key];
3097     }
3098 
3099     /**
3100      * Returns the SECP256k1 public key associated with an ENS node.
3101      * Defined in EIP 619.
3102      * @param node The ENS node to query
3103      * @return x, y the X and Y coordinates of the curve point for the public key.
3104      */
3105     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
3106         return (records[node].pubkey.x, records[node].pubkey.y);
3107     }
3108 
3109     /**
3110      * Returns the ABI associated with an ENS node.
3111      * Defined in EIP205.
3112      * @param node The ENS node to query
3113      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
3114      * @return contentType The content type of the return value
3115      * @return data The ABI data
3116      */
3117     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
3118         Record storage record = records[node];
3119         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
3120             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
3121                 data = record.abis[contentType];
3122                 return;
3123             }
3124         }
3125         contentType = 0;
3126     }
3127 
3128     /**
3129      * Returns the name associated with an ENS node, for reverse records.
3130      * Defined in EIP181.
3131      * @param node The ENS node to query.
3132      * @return The associated name.
3133      */
3134     function name(bytes32 node) public view returns (string) {
3135         return records[node].name;
3136     }
3137 
3138     /**
3139      * Returns the content hash associated with an ENS node.
3140      * Note that this resource type is not standardized, and will likely change
3141      * in future to a resource type based on multihash.
3142      * @param node The ENS node to query.
3143      * @return The associated content hash.
3144      */
3145     function content(bytes32 node) public view returns (bytes32) {
3146         return records[node].content;
3147     }
3148 
3149     /**
3150      * Returns the multihash associated with an ENS node.
3151      * @param node The ENS node to query.
3152      * @return The associated multihash.
3153      */
3154     function multihash(bytes32 node) public view returns (bytes) {
3155         return records[node].multihash;
3156     }
3157 
3158     /**
3159      * Returns the address associated with an ENS node.
3160      * @param node The ENS node to query.
3161      * @return The associated address.
3162      */
3163     function addr(bytes32 node) public view returns (address) {
3164         return records[node].addr;
3165     }
3166 
3167     /**
3168      * Returns true if the resolver implements the interface specified by the provided hash.
3169      * @param interfaceID The ID of the interface to check for.
3170      * @return True if the contract implements the requested interface.
3171      */
3172     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
3173         return interfaceID == ADDR_INTERFACE_ID ||
3174         interfaceID == CONTENT_INTERFACE_ID ||
3175         interfaceID == NAME_INTERFACE_ID ||
3176         interfaceID == ABI_INTERFACE_ID ||
3177         interfaceID == PUBKEY_INTERFACE_ID ||
3178         interfaceID == TEXT_INTERFACE_ID ||
3179         interfaceID == MULTIHASH_INTERFACE_ID ||
3180         interfaceID == INTERFACE_META_ID;
3181     }
3182 }
3183 
3184 /// @title ERC20 interface is a subset of the ERC20 specification.
3185 interface ERC20 {
3186     function transfer(address, uint) external returns (bool);
3187     function balanceOf(address) external view returns (uint);
3188 }
3189 
3190 
3191 /// @title ERC165 interface specifies a standard way of querying if a contract implements an interface.
3192 interface ERC165 {
3193     function supportsInterface(bytes4) external view returns (bool);
3194 }
3195 
3196 
3197 /// @title Whitelist provides payee-whitelist functionality.
3198 contract Whitelist is Controllable, Ownable {
3199     event AddedToWhitelist(address _sender, address[] _addresses);
3200     event SubmittedWhitelistAddition(address[] _addresses, bytes32 _hash);
3201     event CancelledWhitelistAddition(address _sender, bytes32 _hash);
3202 
3203     event RemovedFromWhitelist(address _sender, address[] _addresses);
3204     event SubmittedWhitelistRemoval(address[] _addresses, bytes32 _hash);
3205     event CancelledWhitelistRemoval(address _sender, bytes32 _hash);
3206 
3207     mapping(address => bool) public isWhitelisted;
3208     address[] private _pendingWhitelistAddition;
3209     address[] private _pendingWhitelistRemoval;
3210     bool public submittedWhitelistAddition;
3211     bool public submittedWhitelistRemoval;
3212     bool public initializedWhitelist;
3213 
3214     /// @dev Check if the provided addresses contain the owner or the zero-address address.
3215     modifier hasNoOwnerOrZeroAddress(address[] _addresses) {
3216         for (uint i = 0; i < _addresses.length; i++) {
3217             require(_addresses[i] != owner(), "provided whitelist contains the owner address");
3218             require(_addresses[i] != address(0), "provided whitelist contains the zero address");
3219         }
3220         _;
3221     }
3222 
3223     /// @dev Check that neither addition nor removal operations have already been submitted.
3224     modifier noActiveSubmission() {
3225         require(!submittedWhitelistAddition && !submittedWhitelistRemoval, "whitelist operation has already been submitted");
3226         _;
3227     }
3228 
3229     /// @dev Getter for pending addition array.
3230     function pendingWhitelistAddition() external view returns(address[]) {
3231         return _pendingWhitelistAddition;
3232     }
3233 
3234     /// @dev Getter for pending removal array.
3235     function pendingWhitelistRemoval() external view returns(address[]) {
3236         return _pendingWhitelistRemoval;
3237     }
3238 
3239     /// @dev Getter for pending addition/removal array hash.
3240     function pendingWhitelistHash(address[] _pendingWhitelist) public pure returns(bytes32) {
3241         return keccak256(abi.encodePacked(_pendingWhitelist));
3242     }
3243 
3244     /// @dev Add initial addresses to the whitelist.
3245     /// @param _addresses are the Ethereum addresses to be whitelisted.
3246     function initializeWhitelist(address[] _addresses) external onlyOwner hasNoOwnerOrZeroAddress(_addresses) {
3247         // Require that the whitelist has not been initialized.
3248         require(!initializedWhitelist, "whitelist has already been initialized");
3249         // Add each of the provided addresses to the whitelist.
3250         for (uint i = 0; i < _addresses.length; i++) {
3251             isWhitelisted[_addresses[i]] = true;
3252         }
3253         initializedWhitelist = true;
3254         // Emit the addition event.
3255         emit AddedToWhitelist(msg.sender, _addresses);
3256     }
3257 
3258     /// @dev Add addresses to the whitelist.
3259     /// @param _addresses are the Ethereum addresses to be whitelisted.
3260     function submitWhitelistAddition(address[] _addresses) external onlyOwner noActiveSubmission hasNoOwnerOrZeroAddress(_addresses)  {
3261         // Require that the whitelist has been initialized.
3262         require(initializedWhitelist, "whitelist has not been initialized");
3263         // Set the provided addresses to the pending addition addresses.
3264         _pendingWhitelistAddition = _addresses;
3265         // Flag the operation as submitted.
3266         submittedWhitelistAddition = true;
3267         // Emit the submission event.
3268         emit SubmittedWhitelistAddition(_addresses, pendingWhitelistHash(_pendingWhitelistAddition));
3269     }
3270 
3271     /// @dev Confirm pending whitelist addition.
3272     function confirmWhitelistAddition(bytes32 _hash) external onlyController {
3273         // Require that the whitelist addition has been submitted.
3274         require(submittedWhitelistAddition, "whitelist addition has not been submitted");
3275 
3276         // Require that confirmation hash and the hash of the pending whitelist addition match
3277         require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition do not match");
3278 
3279         // Whitelist pending addresses.
3280         for (uint i = 0; i < _pendingWhitelistAddition.length; i++) {
3281             isWhitelisted[_pendingWhitelistAddition[i]] = true;
3282         }
3283         // Emit the addition event.
3284         emit AddedToWhitelist(msg.sender, _pendingWhitelistAddition);
3285         // Reset pending addresses.
3286         delete _pendingWhitelistAddition;
3287         // Reset the submission flag.
3288         submittedWhitelistAddition = false;
3289     }
3290 
3291     /// @dev Cancel pending whitelist addition.
3292     function cancelWhitelistAddition(bytes32 _hash) external onlyController {
3293         // Require that confirmation hash and the hash of the pending whitelist addition match
3294         require(_hash == pendingWhitelistHash(_pendingWhitelistAddition), "hash of the pending whitelist addition does not match");
3295         // Reset pending addresses.
3296         delete _pendingWhitelistAddition;
3297         // Reset the submitted operation flag.
3298         submittedWhitelistAddition = false;
3299         // Emit the cancellation event.
3300         emit CancelledWhitelistAddition(msg.sender, _hash);
3301     }
3302 
3303     /// @dev Remove addresses from the whitelist.
3304     /// @param _addresses are the Ethereum addresses to be removed.
3305     function submitWhitelistRemoval(address[] _addresses) external onlyOwner noActiveSubmission {
3306         // Add the provided addresses to the pending addition list.
3307         _pendingWhitelistRemoval = _addresses;
3308         // Flag the operation as submitted.
3309         submittedWhitelistRemoval = true;
3310         // Emit the submission event.
3311         emit SubmittedWhitelistRemoval(_addresses, pendingWhitelistHash(_pendingWhitelistRemoval));
3312     }
3313 
3314     /// @dev Confirm pending removal of whitelisted addresses.
3315     function confirmWhitelistRemoval(bytes32 _hash) external onlyController {
3316         // Require that the pending whitelist is not empty and the operation has been submitted.
3317         require(submittedWhitelistRemoval, "whitelist removal has not been submitted");
3318         require(_pendingWhitelistRemoval.length > 0, "pending whitelist removal is empty");
3319         // Require that confirmation hash and the hash of the pending whitelist removal match
3320         require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match the confirmed hash");
3321         // Remove pending addresses.
3322         for (uint i = 0; i < _pendingWhitelistRemoval.length; i++) {
3323             isWhitelisted[_pendingWhitelistRemoval[i]] = false;
3324         }
3325         // Emit the removal event.
3326         emit RemovedFromWhitelist(msg.sender, _pendingWhitelistRemoval);
3327         // Reset pending addresses.
3328         delete _pendingWhitelistRemoval;
3329         // Reset the submission flag.
3330         submittedWhitelistRemoval = false;
3331     }
3332 
3333     /// @dev Cancel pending removal of whitelisted addresses.
3334     function cancelWhitelistRemoval(bytes32 _hash) external onlyController {
3335         // Require that confirmation hash and the hash of the pending whitelist removal match
3336         require(_hash == pendingWhitelistHash(_pendingWhitelistRemoval), "hash of the pending whitelist removal does not match");
3337         // Reset pending addresses.
3338         delete _pendingWhitelistRemoval;
3339         // Reset the submitted operation flag.
3340         submittedWhitelistRemoval = false;
3341         // Emit the cancellation event.
3342         emit CancelledWhitelistRemoval(msg.sender, _hash);
3343     }
3344 }
3345 
3346 
3347 //// @title SpendLimit provides daily spend limit functionality.
3348 contract SpendLimit is Controllable, Ownable {
3349     event SetSpendLimit(address _sender, uint _amount);
3350     event SubmittedSpendLimitChange(uint _amount);
3351     event CancelledSpendLimitChange(address _sender, uint _amount);
3352 
3353     using SafeMath for uint256;
3354 
3355     uint public spendLimit;
3356     uint private _spendLimitDay;
3357     uint private _spendAvailable;
3358 
3359     uint public pendingSpendLimit;
3360     bool public submittedSpendLimit;
3361     bool public initializedSpendLimit;
3362 
3363     /// @dev Constructor initializes the daily spend limit in wei.
3364     constructor(uint _spendLimit) internal {
3365         spendLimit = _spendLimit;
3366         _spendLimitDay = now;
3367         _spendAvailable = spendLimit;
3368     }
3369 
3370     /// @dev Returns the available daily balance - accounts for daily limit reset.
3371     /// @return amount of ether in wei.
3372     function spendAvailable() public view returns (uint) {
3373         if (now > _spendLimitDay + 24 hours) {
3374             return spendLimit;
3375         } else {
3376             return _spendAvailable;
3377         }
3378     }
3379 
3380     /// @dev Initialize a daily spend (aka transfer) limit for non-whitelisted addresses.
3381     /// @param _amount is the daily limit amount in wei.
3382     function initializeSpendLimit(uint _amount) external onlyOwner {
3383         // Require that the spend limit has not been initialized.
3384         require(!initializedSpendLimit, "spend limit has already been initialized");
3385         // Modify spend limit based on the provided value.
3386         _modifySpendLimit(_amount);
3387         // Flag the operation as initialized.
3388         initializedSpendLimit = true;
3389         // Emit the set limit event.
3390         emit SetSpendLimit(msg.sender, _amount);
3391     }
3392 
3393     /// @dev Set a daily transfer limit for non-whitelisted addresses.
3394     /// @param _amount is the daily limit amount in wei.
3395     function submitSpendLimit(uint _amount) external onlyOwner {
3396         // Require that the spend limit has been initialized.
3397         require(initializedSpendLimit, "spend limit has not been initialized");
3398         // Require that the operation has been submitted.
3399         require(!submittedSpendLimit, "spend limit has already been submitted");
3400         // Assign the provided amount to pending daily limit change.
3401         pendingSpendLimit = _amount;
3402         // Flag the operation as submitted.
3403         submittedSpendLimit = true;
3404         // Emit the submission event.
3405         emit SubmittedSpendLimitChange(_amount);
3406     }
3407 
3408     /// @dev Confirm pending set daily limit operation.
3409     function confirmSpendLimit(uint _amount) external onlyController {
3410         // Require that the operation has been submitted.
3411         require(submittedSpendLimit, "spend limit has not been submitted");
3412         // Require that pending and confirmed spend limit are the same
3413         require(pendingSpendLimit == _amount, "confirmed and submitted spend limits dont match");
3414         // Modify spend limit based on the pending value.
3415         _modifySpendLimit(pendingSpendLimit);
3416         // Emit the set limit event.
3417         emit SetSpendLimit(msg.sender, pendingSpendLimit);
3418         // Reset the submission flag.
3419         submittedSpendLimit = false;
3420         // Reset pending daily limit.
3421         pendingSpendLimit = 0;
3422     }
3423 
3424     /// @dev Cancel pending set daily limit operation.
3425     function cancelSpendLimit(uint _amount) external onlyController {
3426         // Require that pending and confirmed spend limit are the same
3427         require(pendingSpendLimit == _amount, "pending and cancelled spend limits dont match");
3428         // Reset pending daily limit.
3429         pendingSpendLimit = 0;
3430         // Reset the submitted operation flag.
3431         submittedSpendLimit = false;
3432         // Emit the cancellation event.
3433         emit CancelledSpendLimitChange(msg.sender, _amount);
3434     }
3435 
3436     // @dev Setter method for the available daily spend limit.
3437     function _setSpendAvailable(uint _amount) internal {
3438         _spendAvailable = _amount;
3439     }
3440 
3441     /// @dev Update available spend limit based on the daily reset.
3442     function _updateSpendAvailable() internal {
3443         if (now > _spendLimitDay.add(24 hours)) {
3444             // Advance the current day by how many days have passed.
3445             uint extraDays = now.sub(_spendLimitDay).div(24 hours);
3446             _spendLimitDay = _spendLimitDay.add(extraDays.mul(24 hours));
3447             // Set the available limit to the current spend limit.
3448             _spendAvailable = spendLimit;
3449         }
3450     }
3451 
3452     /// @dev Modify the spend limit and spend available based on the provided value.
3453     /// @dev _amount is the daily limit amount in wei.
3454     function _modifySpendLimit(uint _amount) private {
3455         // Account for the spend limit daily reset.
3456         _updateSpendAvailable();
3457         // Set the daily limit to the provided amount.
3458         spendLimit = _amount;
3459         // Lower the available limit if it's higher than the new daily limit.
3460         if (_spendAvailable > spendLimit) {
3461             _spendAvailable = spendLimit;
3462         }
3463     }
3464 }
3465 
3466 
3467 //// @title Asset store with extra security features.
3468 contract Vault is Whitelist, SpendLimit, ERC165 {
3469     event Received(address _from, uint _amount);
3470     event Transferred(address _to, address _asset, uint _amount);
3471 
3472     using SafeMath for uint256;
3473 
3474     /// @dev Supported ERC165 interface ID.
3475     bytes4 private constant _ERC165_INTERFACE_ID = 0x01ffc9a7; // solium-disable-line uppercase
3476 
3477     /// @dev ENS points to the ENS registry smart contract.
3478     ENS private _ENS;
3479     /// @dev Is the registered ENS name of the oracle contract.
3480     bytes32 private _node;
3481 
3482     /// @dev Constructor initializes the vault with an owner address and spend limit. It also sets up the oracle and controller contracts.
3483     /// @param _owner is the owner account of the wallet contract.
3484     /// @param _transferable indicates whether the contract ownership can be transferred.
3485     /// @param _ens is the ENS public registry contract address.
3486     /// @param _oracleName is the ENS name of the Oracle.
3487     /// @param _controllerName is the ENS name of the controller.
3488     /// @param _spendLimit is the initial spend limit.
3489     constructor(address _owner, bool _transferable, address _ens, bytes32 _oracleName, bytes32 _controllerName, uint _spendLimit) SpendLimit(_spendLimit) Ownable(_owner, _transferable) Controllable(_ens, _controllerName) public {
3490         _ENS = ENS(_ens);
3491         _node = _oracleName;
3492     }
3493 
3494     /// @dev Checks if the value is not zero.
3495     modifier isNotZero(uint _value) {
3496         require(_value != 0, "provided value cannot be zero");
3497         _;
3498     }
3499 
3500     /// @dev Ether can be deposited from any source, so this contract must be payable by anyone.
3501     function() public payable {
3502         //TODO question: Why is this check here, is it necessary or are we building into a corner?
3503         require(msg.data.length == 0);
3504         emit Received(msg.sender, msg.value);
3505     }
3506 
3507     /// @dev Returns the amount of an asset owned by the contract.
3508     /// @param _asset address of an ERC20 token or 0x0 for ether.
3509     /// @return balance associated with the wallet address in wei.
3510     function balance(address _asset) external view returns (uint) {
3511         if (_asset != address(0)) {
3512             return ERC20(_asset).balanceOf(this);
3513         } else {
3514             return address(this).balance;
3515         }
3516     }
3517 
3518     /// @dev Transfers the specified asset to the recipient's address.
3519     /// @param _to is the recipient's address.
3520     /// @param _asset is the address of an ERC20 token or 0x0 for ether.
3521     /// @param _amount is the amount of tokens to be transferred in base units.
3522     function transfer(address _to, address _asset, uint _amount) external onlyOwner isNotZero(_amount) {
3523         // Checks if the _to address is not the zero-address
3524         require(_to != address(0), "_to address cannot be set to 0x0");
3525 
3526         // If address is not whitelisted, take daily limit into account.
3527         if (!isWhitelisted[_to]) {
3528             // Update the available spend limit.
3529             _updateSpendAvailable();
3530             // Convert token amount to ether value.
3531             uint etherValue;
3532             bool tokenExists;
3533             if (_asset != address(0)) {
3534                 (tokenExists, etherValue) = IOracle(PublicResolver(_ENS.resolver(_node)).addr(_node)).convert(_asset, _amount);
3535             } else {
3536                 etherValue = _amount;
3537             }
3538 
3539             // If token is supported by our oracle or is ether
3540             // Check against the daily spent limit and update accordingly
3541             if (tokenExists || _asset == address(0)) {
3542                 // Require that the value is under remaining limit.
3543                 require(etherValue <= spendAvailable(), "transfer amount exceeds available spend limit");
3544                 // Update the available limit.
3545                 _setSpendAvailable(spendAvailable().sub(etherValue));
3546             }
3547         }
3548         // Transfer token or ether based on the provided address.
3549         if (_asset != address(0)) {
3550             require(ERC20(_asset).transfer(_to, _amount), "ERC20 token transfer was unsuccessful");
3551         } else {
3552             _to.transfer(_amount);
3553         }
3554         // Emit the transfer event.
3555         emit Transferred(_to, _asset, _amount);
3556     }
3557 
3558     /// @dev Checks for interface support based on ERC165.
3559     function supportsInterface(bytes4 interfaceID) external view returns (bool) {
3560         return interfaceID == _ERC165_INTERFACE_ID;
3561     }
3562 }
3563 
3564 
3565 //// @title Asset wallet with extra security features and gas top up management.
3566 contract Wallet is Vault {
3567     event SetTopUpLimit(address _sender, uint _amount);
3568     event SubmittedTopUpLimitChange(uint _amount);
3569     event CancelledTopUpLimitChange(address _sender, uint _amount);
3570 
3571     event ToppedUpGas(address _sender, address _owner, uint _amount);
3572 
3573     using SafeMath for uint256;
3574 
3575     uint constant private MINIMUM_TOPUP_LIMIT = 1 finney; // solium-disable-line uppercase
3576     uint constant private MAXIMUM_TOPUP_LIMIT = 500 finney; // solium-disable-line uppercase
3577 
3578     uint public topUpLimit;
3579     uint private _topUpLimitDay;
3580     uint private _topUpAvailable;
3581 
3582     uint public pendingTopUpLimit;
3583     bool public submittedTopUpLimit;
3584     bool public initializedTopUpLimit;
3585 
3586     /// @dev Constructor initializes the wallet top up limit and the vault contract.
3587     /// @param _owner is the owner account of the wallet contract.
3588     /// @param _transferable indicates whether the contract ownership can be transferred.
3589     /// @param _ens is the address of the ENS.
3590     /// @param _oracleName is the ENS name of the Oracle.
3591     /// @param _controllerName is the ENS name of the Controller.
3592     /// @param _spendLimit is the initial spend limit.
3593     constructor(address _owner, bool _transferable, address _ens, bytes32 _oracleName, bytes32 _controllerName, uint _spendLimit) Vault(_owner, _transferable, _ens, _oracleName, _controllerName, _spendLimit) public {
3594         _topUpLimitDay = now;
3595         topUpLimit = MAXIMUM_TOPUP_LIMIT;
3596         _topUpAvailable = topUpLimit;
3597     }
3598 
3599     /// @dev Returns the available daily gas top up balance - accounts for daily limit reset.
3600     /// @return amount of gas in wei.
3601     function topUpAvailable() external view returns (uint) {
3602         if (now > _topUpLimitDay + 24 hours) {
3603             return topUpLimit;
3604         } else {
3605             return _topUpAvailable;
3606         }
3607     }
3608 
3609     /// @dev Initialize a daily gas top up limit.
3610     /// @param _amount is the gas top up amount in wei.
3611     function initializeTopUpLimit(uint _amount) external onlyOwner {
3612         // Require that the top up limit has not been initialized.
3613         require(!initializedTopUpLimit, "top up limit has already been initialized");
3614         // Require that the limit amount is within the acceptable range.
3615         require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
3616         // Modify spend limit based on the provided value.
3617         _modifyTopUpLimit(_amount);
3618         // Flag operation as initialized.
3619         initializedTopUpLimit = true;
3620         // Emit the set limit event.
3621         emit SetTopUpLimit(msg.sender, _amount);
3622     }
3623 
3624     /// @dev Set a daily top up top up limit.
3625     /// @param _amount is the daily top up limit amount in wei.
3626     function submitTopUpLimit(uint _amount) external onlyOwner {
3627         // Require that the top up limit has been initialized.
3628         require(initializedTopUpLimit, "top up limit has not been initialized");
3629         // Require that the operation has not been submitted.
3630         require(!submittedTopUpLimit, "top up limit has already been submitted");
3631         // Require that the limit amount is within the acceptable range.
3632         require(MINIMUM_TOPUP_LIMIT <= _amount && _amount <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside of the min/max range");
3633         // Assign the provided amount to pending daily limit change.
3634         pendingTopUpLimit = _amount;
3635         // Flag the operation as submitted.
3636         submittedTopUpLimit = true;
3637         // Emit the submission event.
3638         emit SubmittedTopUpLimitChange(_amount);
3639     }
3640 
3641     /// @dev Confirm pending set top up limit operation.
3642     function confirmTopUpLimit(uint _amount) external onlyController {
3643         // Require that the operation has been submitted.
3644         require(submittedTopUpLimit, "top up limit has not been submitted");
3645         // Assert that the pending top up limit amount is within the acceptable range.
3646         require(MINIMUM_TOPUP_LIMIT <= pendingTopUpLimit && pendingTopUpLimit <= MAXIMUM_TOPUP_LIMIT, "top up amount is outside the min/max range");
3647         // Assert that confirmed and pending topup limit are the same.
3648         require(_amount == pendingTopUpLimit, "confirmed and pending topup limit are not same");
3649         // Modify top up limit based on the pending value.
3650         _modifyTopUpLimit(pendingTopUpLimit);
3651         // Emit the set limit event.
3652         emit SetTopUpLimit(msg.sender, pendingTopUpLimit);
3653         // Reset pending daily limit.
3654         pendingTopUpLimit = 0;
3655         // Reset the submission flag.
3656         submittedTopUpLimit = false;
3657     }
3658 
3659     /// @dev Cancel pending set top up limit operation.
3660     function cancelTopUpLimit(uint _amount) external onlyController {
3661         // Require that pending and confirmed spend limit are the same
3662         require(pendingTopUpLimit == _amount, "pending and cancelled top up limits dont match");
3663         // Reset pending daily limit.
3664         pendingTopUpLimit = 0;
3665         // Reset the submitted operation flag.
3666         submittedTopUpLimit = false;
3667         // Emit the cancellation event.
3668         emit CancelledTopUpLimitChange(msg.sender, _amount);
3669     }
3670 
3671     /// @dev Refill owner's gas balance.
3672     /// @dev Revert if the transaction amount is too large
3673     /// @param _amount is the amount of ether to transfer to the owner account in wei.
3674     function topUpGas(uint _amount) external isNotZero(_amount) {
3675         // Require that the sender is either the owner or a controller.
3676         require(_isOwner() || _isController(msg.sender), "sender is neither an owner nor a controller");
3677         // Account for the top up limit daily reset.
3678         _updateTopUpAvailable();
3679         // Make sure the available top up amount is not zero.
3680         require(_topUpAvailable != 0, "available top up limit cannot be zero");
3681         // Fail if there isn't enough in the daily top up limit to perform topUp
3682         require(_amount <= _topUpAvailable, "available top up limit less than amount passed in");
3683         // Reduce the top up amount from available balance and transfer corresponding
3684         // ether to the owner's account.
3685         _topUpAvailable = _topUpAvailable.sub(_amount);
3686         owner().transfer(_amount);
3687         // Emit the gas top up event.
3688         emit ToppedUpGas(tx.origin, owner(), _amount);
3689     }
3690 
3691     /// @dev Modify the top up limit and top up available based on the provided value.
3692     /// @dev _amount is the daily limit amount in wei.
3693     function _modifyTopUpLimit(uint _amount) private {
3694         // Account for the top up limit daily reset.
3695         _updateTopUpAvailable();
3696         // Set the daily limit to the provided amount.
3697         topUpLimit = _amount;
3698         // Lower the available limit if it's higher than the new daily limit.
3699         if (_topUpAvailable > topUpLimit) {
3700             _topUpAvailable = topUpLimit;
3701         }
3702     }
3703 
3704     /// @dev Update available top up limit based on the daily reset.
3705     function _updateTopUpAvailable() private {
3706         if (now > _topUpLimitDay.add(24 hours)) {
3707             // Advance the current day by how many days have passed.
3708             uint extraDays = now.sub(_topUpLimitDay).div(24 hours);
3709             _topUpLimitDay = _topUpLimitDay.add(extraDays.mul(24 hours));
3710             // Set the available limit to the current top up limit.
3711             _topUpAvailable = topUpLimit;
3712         }
3713     }
3714 }