1 /*
2  * Copyright (c) 2022, Circle Internet Financial Limited.
3  *
4  * Licensed under the Apache License, Version 2.0 (the "License");
5  * you may not use this file except in compliance with the License.
6  * You may obtain a copy of the License at
7  *
8  * http://www.apache.org/licenses/LICENSE-2.0
9  *
10  * Unless required by applicable law or agreed to in writing, software
11  * distributed under the License is distributed on an "AS IS" BASIS,
12  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13  * See the License for the specific language governing permissions and
14  * limitations under the License.
15  */
16 pragma solidity 0.7.6;
17 
18 /*
19 The MIT License (MIT)
20 
21 Copyright (c) 2016 Smart Contract Solutions, Inc.
22 
23 Permission is hereby granted, free of charge, to any person obtaining
24 a copy of this software and associated documentation files (the
25 "Software"), to deal in the Software without restriction, including
26 without limitation the rights to use, copy, modify, merge, publish,
27 distribute, sublicense, and/or sell copies of the Software, and to
28 permit persons to whom the Software is furnished to do so, subject to
29 the following conditions:
30 
31 The above copyright notice and this permission notice shall be included
32 in all copies or substantial portions of the Software.
33 
34 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
35 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
36 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
37 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
38 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
39 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
40 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
41 */
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMathTMV {
48     /**
49      * @dev Multiplies two numbers, throws on overflow.
50      */
51     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
53         // benefit is lost if 'b' is also tested.
54         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
55         if (_a == 0) {
56             return 0;
57         }
58 
59         c = _a * _b;
60         require(c / _a == _b, "Overflow during multiplication.");
61         return c;
62     }
63 
64     /**
65      * @dev Integer division of two numbers, truncating the quotient.
66      */
67     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
68         // assert(_b > 0); // Solidity automatically throws when dividing by 0
69         // uint256 c = _a / _b;
70         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
71         return _a / _b;
72     }
73 
74     /**
75      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76      */
77     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
78         require(_b <= _a, "Underflow during subtraction.");
79         return _a - _b;
80     }
81 
82     /**
83      * @dev Adds two numbers, throws on overflow.
84      */
85     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
86         c = _a + _b;
87         require(c >= _a, "Overflow during addition.");
88         return c;
89     }
90 }
91 
92 library TypedMemView {
93     using SafeMathTMV for uint256;
94 
95     // Why does this exist?
96     // the solidity `bytes memory` type has a few weaknesses.
97     // 1. You can't index ranges effectively
98     // 2. You can't slice without copying
99     // 3. The underlying data may represent any type
100     // 4. Solidity never deallocates memory, and memory costs grow
101     //    superlinearly
102 
103     // By using a memory view instead of a `bytes memory` we get the following
104     // advantages:
105     // 1. Slices are done on the stack, by manipulating the pointer
106     // 2. We can index arbitrary ranges and quickly convert them to stack types
107     // 3. We can insert type info into the pointer, and typecheck at runtime
108 
109     // This makes `TypedMemView` a useful tool for efficient zero-copy
110     // algorithms.
111 
112     // Why bytes29?
113     // We want to avoid confusion between views, digests, and other common
114     // types so we chose a large and uncommonly used odd number of bytes
115     //
116     // Note that while bytes are left-aligned in a word, integers and addresses
117     // are right-aligned. This means when working in assembly we have to
118     // account for the 3 unused bytes on the righthand side
119     //
120     // First 5 bytes are a type flag.
121     // - ff_ffff_fffe is reserved for unknown type.
122     // - ff_ffff_ffff is reserved for invalid types/errors.
123     // next 12 are memory address
124     // next 12 are len
125     // bottom 3 bytes are empty
126 
127     // Assumptions:
128     // - non-modification of memory.
129     // - No Solidity updates
130     // - - wrt free mem point
131     // - - wrt bytes representation in memory
132     // - - wrt memory addressing in general
133 
134     // Usage:
135     // - create type constants
136     // - use `assertType` for runtime type assertions
137     // - - unfortunately we can't do this at compile time yet :(
138     // - recommended: implement modifiers that perform type checking
139     // - - e.g.
140     // - - `uint40 constant MY_TYPE = 3;`
141     // - - ` modifer onlyMyType(bytes29 myView) { myView.assertType(MY_TYPE); }`
142     // - instantiate a typed view from a bytearray using `ref`
143     // - use `index` to inspect the contents of the view
144     // - use `slice` to create smaller views into the same memory
145     // - - `slice` can increase the offset
146     // - - `slice can decrease the length`
147     // - - must specify the output type of `slice`
148     // - - `slice` will return a null view if you try to overrun
149     // - - make sure to explicitly check for this with `notNull` or `assertType`
150     // - use `equal` for typed comparisons.
151 
152     // The null view
153     bytes29 public constant NULL =
154         hex"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
155     uint256 constant LOW_12_MASK = 0xffffffffffffffffffffffff;
156     uint8 constant TWELVE_BYTES = 96;
157 
158     /**
159      * @notice      Returns the encoded hex character that represents the lower 4 bits of the argument.
160      * @param _b    The byte
161      * @return      char - The encoded hex character
162      */
163     function nibbleHex(uint8 _b) internal pure returns (uint8 char) {
164         // This can probably be done more efficiently, but it's only in error
165         // paths, so we don't really care :)
166         uint8 _nibble = _b | 0xf0; // set top 4, keep bottom 4
167         if (_nibble == 0xf0) {
168             return 0x30;
169         } // 0
170         if (_nibble == 0xf1) {
171             return 0x31;
172         } // 1
173         if (_nibble == 0xf2) {
174             return 0x32;
175         } // 2
176         if (_nibble == 0xf3) {
177             return 0x33;
178         } // 3
179         if (_nibble == 0xf4) {
180             return 0x34;
181         } // 4
182         if (_nibble == 0xf5) {
183             return 0x35;
184         } // 5
185         if (_nibble == 0xf6) {
186             return 0x36;
187         } // 6
188         if (_nibble == 0xf7) {
189             return 0x37;
190         } // 7
191         if (_nibble == 0xf8) {
192             return 0x38;
193         } // 8
194         if (_nibble == 0xf9) {
195             return 0x39;
196         } // 9
197         if (_nibble == 0xfa) {
198             return 0x61;
199         } // a
200         if (_nibble == 0xfb) {
201             return 0x62;
202         } // b
203         if (_nibble == 0xfc) {
204             return 0x63;
205         } // c
206         if (_nibble == 0xfd) {
207             return 0x64;
208         } // d
209         if (_nibble == 0xfe) {
210             return 0x65;
211         } // e
212         if (_nibble == 0xff) {
213             return 0x66;
214         } // f
215     }
216 
217     /**
218      * @notice      Returns a uint16 containing the hex-encoded byte.
219      * @param _b    The byte
220      * @return      encoded - The hex-encoded byte
221      */
222     function byteHex(uint8 _b) internal pure returns (uint16 encoded) {
223         encoded |= nibbleHex(_b >> 4); // top 4 bits
224         encoded <<= 8;
225         encoded |= nibbleHex(_b); // lower 4 bits
226     }
227 
228     /**
229      * @notice      Encodes the uint256 to hex. `first` contains the encoded top 16 bytes.
230      *              `second` contains the encoded lower 16 bytes.
231      *
232      * @param _b    The 32 bytes as uint256
233      * @return      first - The top 16 bytes
234      * @return      second - The bottom 16 bytes
235      */
236     function encodeHex(uint256 _b)
237         internal
238         pure
239         returns (uint256 first, uint256 second)
240     {
241         for (uint8 i = 31; i > 15; i -= 1) {
242             uint8 _byte = uint8(_b >> (i * 8));
243             first |= byteHex(_byte);
244             if (i != 16) {
245                 first <<= 16;
246             }
247         }
248 
249         // abusing underflow here =_=
250         for (uint8 i = 15; i < 255; i -= 1) {
251             uint8 _byte = uint8(_b >> (i * 8));
252             second |= byteHex(_byte);
253             if (i != 0) {
254                 second <<= 16;
255             }
256         }
257     }
258 
259     /**
260      * @notice          Changes the endianness of a uint256.
261      * @dev             https://graphics.stanford.edu/~seander/bithacks.html#ReverseParallel
262      * @param _b        The unsigned integer to reverse
263      * @return          v - The reversed value
264      */
265     function reverseUint256(uint256 _b) internal pure returns (uint256 v) {
266         v = _b;
267 
268         // swap bytes
269         v =
270             ((v >> 8) &
271                 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) |
272             ((v &
273                 0x00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF) <<
274                 8);
275         // swap 2-byte long pairs
276         v =
277             ((v >> 16) &
278                 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) |
279             ((v &
280                 0x0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF) <<
281                 16);
282         // swap 4-byte long pairs
283         v =
284             ((v >> 32) &
285                 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) |
286             ((v &
287                 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) <<
288                 32);
289         // swap 8-byte long pairs
290         v =
291             ((v >> 64) &
292                 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) |
293             ((v &
294                 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) <<
295                 64);
296         // swap 16-byte long pairs
297         v = (v >> 128) | (v << 128);
298     }
299 
300     /**
301      * @notice      Create a mask with the highest `_len` bits set.
302      * @param _len  The length
303      * @return      mask - The mask
304      */
305     function leftMask(uint8 _len) private pure returns (uint256 mask) {
306         // ugly. redo without assembly?
307         assembly {
308             // solium-disable-previous-line security/no-inline-assembly
309             mask := sar(
310                 sub(_len, 1),
311                 0x8000000000000000000000000000000000000000000000000000000000000000
312             )
313         }
314     }
315 
316     /**
317      * @notice      Return the null view.
318      * @return      bytes29 - The null view
319      */
320     function nullView() internal pure returns (bytes29) {
321         return NULL;
322     }
323 
324     /**
325      * @notice      Check if the view is null.
326      * @return      bool - True if the view is null
327      */
328     function isNull(bytes29 memView) internal pure returns (bool) {
329         return memView == NULL;
330     }
331 
332     /**
333      * @notice      Check if the view is not null.
334      * @return      bool - True if the view is not null
335      */
336     function notNull(bytes29 memView) internal pure returns (bool) {
337         return !isNull(memView);
338     }
339 
340     /**
341      * @notice          Check if the view is of a valid type and points to a valid location
342      *                  in memory.
343      * @dev             We perform this check by examining solidity's unallocated memory
344      *                  pointer and ensuring that the view's upper bound is less than that.
345      * @param memView   The view
346      * @return          ret - True if the view is valid
347      */
348     function isValid(bytes29 memView) internal pure returns (bool ret) {
349         if (typeOf(memView) == 0xffffffffff) {
350             return false;
351         }
352         uint256 _end = end(memView);
353         assembly {
354             // solium-disable-previous-line security/no-inline-assembly
355             ret := not(gt(_end, mload(0x40)))
356         }
357     }
358 
359     /**
360      * @notice          Require that a typed memory view be valid.
361      * @dev             Returns the view for easy chaining.
362      * @param memView   The view
363      * @return          bytes29 - The validated view
364      */
365     function assertValid(bytes29 memView) internal pure returns (bytes29) {
366         require(isValid(memView), "Validity assertion failed");
367         return memView;
368     }
369 
370     /**
371      * @notice          Return true if the memview is of the expected type. Otherwise false.
372      * @param memView   The view
373      * @param _expected The expected type
374      * @return          bool - True if the memview is of the expected type
375      */
376     function isType(bytes29 memView, uint40 _expected)
377         internal
378         pure
379         returns (bool)
380     {
381         return typeOf(memView) == _expected;
382     }
383 
384     /**
385      * @notice          Require that a typed memory view has a specific type.
386      * @dev             Returns the view for easy chaining.
387      * @param memView   The view
388      * @param _expected The expected type
389      * @return          bytes29 - The view with validated type
390      */
391     function assertType(bytes29 memView, uint40 _expected)
392         internal
393         pure
394         returns (bytes29)
395     {
396         if (!isType(memView, _expected)) {
397             (, uint256 g) = encodeHex(uint256(typeOf(memView)));
398             (, uint256 e) = encodeHex(uint256(_expected));
399             string memory err = string(
400                 abi.encodePacked(
401                     "Type assertion failed. Got 0x",
402                     uint80(g),
403                     ". Expected 0x",
404                     uint80(e)
405                 )
406             );
407             revert(err);
408         }
409         return memView;
410     }
411 
412     /**
413      * @notice          Return an identical view with a different type.
414      * @param memView   The view
415      * @param _newType  The new type
416      * @return          newView - The new view with the specified type
417      */
418     function castTo(bytes29 memView, uint40 _newType)
419         internal
420         pure
421         returns (bytes29 newView)
422     {
423         // then | in the new type
424         assembly {
425             // solium-disable-previous-line security/no-inline-assembly
426             // shift off the top 5 bytes
427             newView := or(newView, shr(40, shl(40, memView)))
428             newView := or(newView, shl(216, _newType))
429         }
430     }
431 
432     /**
433      * @notice          Unsafe raw pointer construction. This should generally not be called
434      *                  directly. Prefer `ref` wherever possible.
435      * @dev             Unsafe raw pointer construction. This should generally not be called
436      *                  directly. Prefer `ref` wherever possible.
437      * @param _type     The type
438      * @param _loc      The memory address
439      * @param _len      The length
440      * @return          newView - The new view with the specified type, location and length
441      */
442     function unsafeBuildUnchecked(
443         uint256 _type,
444         uint256 _loc,
445         uint256 _len
446     ) private pure returns (bytes29 newView) {
447         assembly {
448             // solium-disable-previous-line security/no-inline-assembly
449             newView := shl(96, or(newView, _type)) // insert type
450             newView := shl(96, or(newView, _loc)) // insert loc
451             newView := shl(24, or(newView, _len)) // empty bottom 3 bytes
452         }
453     }
454 
455     /**
456      * @notice          Instantiate a new memory view. This should generally not be called
457      *                  directly. Prefer `ref` wherever possible.
458      * @dev             Instantiate a new memory view. This should generally not be called
459      *                  directly. Prefer `ref` wherever possible.
460      * @param _type     The type
461      * @param _loc      The memory address
462      * @param _len      The length
463      * @return          newView - The new view with the specified type, location and length
464      */
465     function build(
466         uint256 _type,
467         uint256 _loc,
468         uint256 _len
469     ) internal pure returns (bytes29 newView) {
470         uint256 _end = _loc.add(_len);
471         assembly {
472             // solium-disable-previous-line security/no-inline-assembly
473             if gt(_end, mload(0x40)) {
474                 _end := 0
475             }
476         }
477         if (_end == 0) {
478             return NULL;
479         }
480         newView = unsafeBuildUnchecked(_type, _loc, _len);
481     }
482 
483     /**
484      * @notice          Instantiate a memory view from a byte array.
485      * @dev             Note that due to Solidity memory representation, it is not possible to
486      *                  implement a deref, as the `bytes` type stores its len in memory.
487      * @param arr       The byte array
488      * @param newType   The type
489      * @return          bytes29 - The memory view
490      */
491     function ref(bytes memory arr, uint40 newType)
492         internal
493         pure
494         returns (bytes29)
495     {
496         uint256 _len = arr.length;
497 
498         uint256 _loc;
499         assembly {
500             // solium-disable-previous-line security/no-inline-assembly
501             _loc := add(arr, 0x20) // our view is of the data, not the struct
502         }
503 
504         return build(newType, _loc, _len);
505     }
506 
507     /**
508      * @notice          Return the associated type information.
509      * @param memView   The memory view
510      * @return          _type - The type associated with the view
511      */
512     function typeOf(bytes29 memView) internal pure returns (uint40 _type) {
513         assembly {
514             // solium-disable-previous-line security/no-inline-assembly
515             // 216 == 256 - 40
516             _type := shr(216, memView) // shift out lower 24 bytes
517         }
518     }
519 
520     /**
521      * @notice          Optimized type comparison. Checks that the 5-byte type flag is equal.
522      * @param left      The first view
523      * @param right     The second view
524      * @return          bool - True if the 5-byte type flag is equal
525      */
526     function sameType(bytes29 left, bytes29 right)
527         internal
528         pure
529         returns (bool)
530     {
531         return (left ^ right) >> (2 * TWELVE_BYTES) == 0;
532     }
533 
534     /**
535      * @notice          Return the memory address of the underlying bytes.
536      * @param memView   The view
537      * @return          _loc - The memory address
538      */
539     function loc(bytes29 memView) internal pure returns (uint96 _loc) {
540         uint256 _mask = LOW_12_MASK; // assembly can't use globals
541         assembly {
542             // solium-disable-previous-line security/no-inline-assembly
543             // 120 bits = 12 bytes (the encoded loc) + 3 bytes (empty low space)
544             _loc := and(shr(120, memView), _mask)
545         }
546     }
547 
548     /**
549      * @notice          The number of memory words this memory view occupies, rounded up.
550      * @param memView   The view
551      * @return          uint256 - The number of memory words
552      */
553     function words(bytes29 memView) internal pure returns (uint256) {
554         return uint256(len(memView)).add(32) / 32;
555     }
556 
557     /**
558      * @notice          The in-memory footprint of a fresh copy of the view.
559      * @param memView   The view
560      * @return          uint256 - The in-memory footprint of a fresh copy of the view.
561      */
562     function footprint(bytes29 memView) internal pure returns (uint256) {
563         return words(memView) * 32;
564     }
565 
566     /**
567      * @notice          The number of bytes of the view.
568      * @param memView   The view
569      * @return          _len - The length of the view
570      */
571     function len(bytes29 memView) internal pure returns (uint96 _len) {
572         uint256 _mask = LOW_12_MASK; // assembly can't use globals
573         assembly {
574             // solium-disable-previous-line security/no-inline-assembly
575             _len := and(shr(24, memView), _mask)
576         }
577     }
578 
579     /**
580      * @notice          Returns the endpoint of `memView`.
581      * @param memView   The view
582      * @return          uint256 - The endpoint of `memView`
583      */
584     function end(bytes29 memView) internal pure returns (uint256) {
585         return loc(memView) + len(memView);
586     }
587 
588     /**
589      * @notice          Safe slicing without memory modification.
590      * @param memView   The view
591      * @param _index    The start index
592      * @param _len      The length
593      * @param newType   The new type
594      * @return          bytes29 - The new view
595      */
596     function slice(
597         bytes29 memView,
598         uint256 _index,
599         uint256 _len,
600         uint40 newType
601     ) internal pure returns (bytes29) {
602         uint256 _loc = loc(memView);
603 
604         // Ensure it doesn't overrun the view
605         if (_loc.add(_index).add(_len) > end(memView)) {
606             return NULL;
607         }
608 
609         _loc = _loc.add(_index);
610         return build(newType, _loc, _len);
611     }
612 
613     /**
614      * @notice          Shortcut to `slice`. Gets a view representing the first `_len` bytes.
615      * @param memView   The view
616      * @param _len      The length
617      * @param newType   The new type
618      * @return          bytes29 - The new view
619      */
620     function prefix(
621         bytes29 memView,
622         uint256 _len,
623         uint40 newType
624     ) internal pure returns (bytes29) {
625         return slice(memView, 0, _len, newType);
626     }
627 
628     /**
629      * @notice          Shortcut to `slice`. Gets a view representing the last `_len` byte.
630      * @param memView   The view
631      * @param _len      The length
632      * @param newType   The new type
633      * @return          bytes29 - The new view
634      */
635     function postfix(
636         bytes29 memView,
637         uint256 _len,
638         uint40 newType
639     ) internal pure returns (bytes29) {
640         return slice(memView, uint256(len(memView)).sub(_len), _len, newType);
641     }
642 
643     /**
644      * @notice          Construct an error message for an indexing overrun.
645      * @param _loc      The memory address
646      * @param _len      The length
647      * @param _index    The index
648      * @param _slice    The slice where the overrun occurred
649      * @return          err - The err
650      */
651     function indexErrOverrun(
652         uint256 _loc,
653         uint256 _len,
654         uint256 _index,
655         uint256 _slice
656     ) internal pure returns (string memory err) {
657         (, uint256 a) = encodeHex(_loc);
658         (, uint256 b) = encodeHex(_len);
659         (, uint256 c) = encodeHex(_index);
660         (, uint256 d) = encodeHex(_slice);
661         err = string(
662             abi.encodePacked(
663                 "TypedMemView/index - Overran the view. Slice is at 0x",
664                 uint48(a),
665                 " with length 0x",
666                 uint48(b),
667                 ". Attempted to index at offset 0x",
668                 uint48(c),
669                 " with length 0x",
670                 uint48(d),
671                 "."
672             )
673         );
674     }
675 
676     /**
677      * @notice          Load up to 32 bytes from the view onto the stack.
678      * @dev             Returns a bytes32 with only the `_bytes` highest bytes set.
679      *                  This can be immediately cast to a smaller fixed-length byte array.
680      *                  To automatically cast to an integer, use `indexUint`.
681      * @param memView   The view
682      * @param _index    The index
683      * @param _bytes    The bytes
684      * @return          result - The 32 byte result
685      */
686     function index(
687         bytes29 memView,
688         uint256 _index,
689         uint8 _bytes
690     ) internal pure returns (bytes32 result) {
691         if (_bytes == 0) {
692             return bytes32(0);
693         }
694         if (_index.add(_bytes) > len(memView)) {
695             revert(
696                 indexErrOverrun(
697                     loc(memView),
698                     len(memView),
699                     _index,
700                     uint256(_bytes)
701                 )
702             );
703         }
704         require(
705             _bytes <= 32,
706             "TypedMemView/index - Attempted to index more than 32 bytes"
707         );
708 
709         uint8 bitLength = _bytes * 8;
710         uint256 _loc = loc(memView);
711         uint256 _mask = leftMask(bitLength);
712         assembly {
713             // solium-disable-previous-line security/no-inline-assembly
714             result := and(mload(add(_loc, _index)), _mask)
715         }
716     }
717 
718     /**
719      * @notice          Parse an unsigned integer from the view at `_index`.
720      * @dev             Requires that the view have >= `_bytes` bytes following that index.
721      * @param memView   The view
722      * @param _index    The index
723      * @param _bytes    The bytes
724      * @return          result - The unsigned integer
725      */
726     function indexUint(
727         bytes29 memView,
728         uint256 _index,
729         uint8 _bytes
730     ) internal pure returns (uint256 result) {
731         return uint256(index(memView, _index, _bytes)) >> ((32 - _bytes) * 8);
732     }
733 
734     /**
735      * @notice          Parse an unsigned integer from LE bytes.
736      * @param memView   The view
737      * @param _index    The index
738      * @param _bytes    The bytes
739      * @return          result - The unsigned integer
740      */
741     function indexLEUint(
742         bytes29 memView,
743         uint256 _index,
744         uint8 _bytes
745     ) internal pure returns (uint256 result) {
746         return reverseUint256(uint256(index(memView, _index, _bytes)));
747     }
748 
749     /**
750      * @notice          Parse an address from the view at `_index`. Requires that the view have >= 20 bytes
751      *                  following that index.
752      * @param memView   The view
753      * @param _index    The index
754      * @return          address - The address
755      */
756     function indexAddress(bytes29 memView, uint256 _index)
757         internal
758         pure
759         returns (address)
760     {
761         return address(uint160(indexUint(memView, _index, 20)));
762     }
763 
764     /**
765      * @notice          Return the keccak256 hash of the underlying memory
766      * @param memView   The view
767      * @return          digest - The keccak256 hash of the underlying memory
768      */
769     function keccak(bytes29 memView) internal pure returns (bytes32 digest) {
770         uint256 _loc = loc(memView);
771         uint256 _len = len(memView);
772         assembly {
773             // solium-disable-previous-line security/no-inline-assembly
774             digest := keccak256(_loc, _len)
775         }
776     }
777 
778     /**
779      * @notice          Return the sha2 digest of the underlying memory.
780      * @dev             We explicitly deallocate memory afterwards.
781      * @param memView   The view
782      * @return          digest - The sha2 hash of the underlying memory
783      */
784     function sha2(bytes29 memView) internal view returns (bytes32 digest) {
785         uint256 _loc = loc(memView);
786         uint256 _len = len(memView);
787         assembly {
788             // solium-disable-previous-line security/no-inline-assembly
789             let ptr := mload(0x40)
790             pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2 #1
791             digest := mload(ptr)
792         }
793     }
794 
795     /**
796      * @notice          Implements bitcoin's hash160 (rmd160(sha2()))
797      * @param memView   The pre-image
798      * @return          digest - the Digest
799      */
800     function hash160(bytes29 memView) internal view returns (bytes20 digest) {
801         uint256 _loc = loc(memView);
802         uint256 _len = len(memView);
803         assembly {
804             // solium-disable-previous-line security/no-inline-assembly
805             let ptr := mload(0x40)
806             pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2
807             pop(staticcall(gas(), 3, ptr, 0x20, ptr, 0x20)) // rmd160
808             digest := mload(add(ptr, 0xc)) // return value is 0-prefixed.
809         }
810     }
811 
812     /**
813      * @notice          Implements bitcoin's hash256 (double sha2)
814      * @param memView   A view of the preimage
815      * @return          digest - the Digest
816      */
817     function hash256(bytes29 memView) internal view returns (bytes32 digest) {
818         uint256 _loc = loc(memView);
819         uint256 _len = len(memView);
820         assembly {
821             // solium-disable-previous-line security/no-inline-assembly
822             let ptr := mload(0x40)
823             pop(staticcall(gas(), 2, _loc, _len, ptr, 0x20)) // sha2 #1
824             pop(staticcall(gas(), 2, ptr, 0x20, ptr, 0x20)) // sha2 #2
825             digest := mload(ptr)
826         }
827     }
828 
829     /**
830      * @notice          Return true if the underlying memory is equal. Else false.
831      * @param left      The first view
832      * @param right     The second view
833      * @return          bool - True if the underlying memory is equal
834      */
835     function untypedEqual(bytes29 left, bytes29 right)
836         internal
837         pure
838         returns (bool)
839     {
840         return
841             (loc(left) == loc(right) && len(left) == len(right)) ||
842             keccak(left) == keccak(right);
843     }
844 
845     /**
846      * @notice          Return false if the underlying memory is equal. Else true.
847      * @param left      The first view
848      * @param right     The second view
849      * @return          bool - False if the underlying memory is equal
850      */
851     function untypedNotEqual(bytes29 left, bytes29 right)
852         internal
853         pure
854         returns (bool)
855     {
856         return !untypedEqual(left, right);
857     }
858 
859     /**
860      * @notice          Compares type equality.
861      * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
862      * @param left      The first view
863      * @param right     The second view
864      * @return          bool - True if the types are the same
865      */
866     function equal(bytes29 left, bytes29 right) internal pure returns (bool) {
867         return
868             left == right ||
869             (typeOf(left) == typeOf(right) && keccak(left) == keccak(right));
870     }
871 
872     /**
873      * @notice          Compares type inequality.
874      * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
875      * @param left      The first view
876      * @param right     The second view
877      * @return          bool - True if the types are not the same
878      */
879     function notEqual(bytes29 left, bytes29 right)
880         internal
881         pure
882         returns (bool)
883     {
884         return !equal(left, right);
885     }
886 
887     /**
888      * @notice          Copy the view to a location, return an unsafe memory reference
889      * @dev             Super Dangerous direct memory access.
890      *
891      *                  This reference can be overwritten if anything else modifies memory (!!!).
892      *                  As such it MUST be consumed IMMEDIATELY.
893      *                  This function is private to prevent unsafe usage by callers.
894      * @param memView   The view
895      * @param _newLoc   The new location
896      * @return          written - the unsafe memory reference
897      */
898     function unsafeCopyTo(bytes29 memView, uint256 _newLoc)
899         private
900         view
901         returns (bytes29 written)
902     {
903         require(notNull(memView), "TypedMemView/copyTo - Null pointer deref");
904         require(
905             isValid(memView),
906             "TypedMemView/copyTo - Invalid pointer deref"
907         );
908         uint256 _len = len(memView);
909         uint256 _oldLoc = loc(memView);
910 
911         uint256 ptr;
912         assembly {
913             // solium-disable-previous-line security/no-inline-assembly
914             ptr := mload(0x40)
915             // revert if we're writing in occupied memory
916             if gt(ptr, _newLoc) {
917                 revert(0x60, 0x20) // empty revert message
918             }
919 
920             // use the identity precompile to copy
921             // guaranteed not to fail, so pop the success
922             pop(staticcall(gas(), 4, _oldLoc, _len, _newLoc, _len))
923         }
924 
925         written = unsafeBuildUnchecked(typeOf(memView), _newLoc, _len);
926     }
927 
928     /**
929      * @notice          Copies the referenced memory to a new loc in memory, returning a `bytes` pointing to
930      *                  the new memory
931      * @dev             Shortcuts if the pointers are identical, otherwise compares type and digest.
932      * @param memView   The view
933      * @return          ret - The view pointing to the new memory
934      */
935     function clone(bytes29 memView) internal view returns (bytes memory ret) {
936         uint256 ptr;
937         uint256 _len = len(memView);
938         assembly {
939             // solium-disable-previous-line security/no-inline-assembly
940             ptr := mload(0x40) // load unused memory pointer
941             ret := ptr
942         }
943         unsafeCopyTo(memView, ptr + 0x20);
944         assembly {
945             // solium-disable-previous-line security/no-inline-assembly
946             mstore(0x40, add(add(ptr, _len), 0x20)) // write new unused pointer
947             mstore(ptr, _len) // write len of new array (in bytes)
948         }
949     }
950 
951     /**
952      * @notice          Join the views in memory, return an unsafe reference to the memory.
953      * @dev             Super Dangerous direct memory access.
954      *
955      *                  This reference can be overwritten if anything else modifies memory (!!!).
956      *                  As such it MUST be consumed IMMEDIATELY.
957      *                  This function is private to prevent unsafe usage by callers.
958      * @param memViews  The views
959      * @return          unsafeView - The conjoined view pointing to the new memory
960      */
961     function unsafeJoin(bytes29[] memory memViews, uint256 _location)
962         private
963         view
964         returns (bytes29 unsafeView)
965     {
966         assembly {
967             // solium-disable-previous-line security/no-inline-assembly
968             let ptr := mload(0x40)
969             // revert if we're writing in occupied memory
970             if gt(ptr, _location) {
971                 revert(0x60, 0x20) // empty revert message
972             }
973         }
974 
975         uint256 _offset = 0;
976         for (uint256 i = 0; i < memViews.length; i++) {
977             bytes29 memView = memViews[i];
978             unsafeCopyTo(memView, _location + _offset);
979             _offset += len(memView);
980         }
981         unsafeView = unsafeBuildUnchecked(0, _location, _offset);
982     }
983 
984     /**
985      * @notice          Produce the keccak256 digest of the concatenated contents of multiple views.
986      * @param memViews  The views
987      * @return          bytes32 - The keccak256 digest
988      */
989     function joinKeccak(bytes29[] memory memViews)
990         internal
991         view
992         returns (bytes32)
993     {
994         uint256 ptr;
995         assembly {
996             // solium-disable-previous-line security/no-inline-assembly
997             ptr := mload(0x40) // load unused memory pointer
998         }
999         return keccak(unsafeJoin(memViews, ptr));
1000     }
1001 
1002     /**
1003      * @notice          Produce the sha256 digest of the concatenated contents of multiple views.
1004      * @param memViews  The views
1005      * @return          bytes32 - The sha256 digest
1006      */
1007     function joinSha2(bytes29[] memory memViews)
1008         internal
1009         view
1010         returns (bytes32)
1011     {
1012         uint256 ptr;
1013         assembly {
1014             // solium-disable-previous-line security/no-inline-assembly
1015             ptr := mload(0x40) // load unused memory pointer
1016         }
1017         return sha2(unsafeJoin(memViews, ptr));
1018     }
1019 
1020     /**
1021      * @notice          copies all views, joins them into a new bytearray.
1022      * @param memViews  The views
1023      * @return          ret - The new byte array
1024      */
1025     function join(bytes29[] memory memViews)
1026         internal
1027         view
1028         returns (bytes memory ret)
1029     {
1030         uint256 ptr;
1031         assembly {
1032             // solium-disable-previous-line security/no-inline-assembly
1033             ptr := mload(0x40) // load unused memory pointer
1034         }
1035 
1036         bytes29 _newView = unsafeJoin(memViews, ptr + 0x20);
1037         uint256 _written = len(_newView);
1038         uint256 _footprint = footprint(_newView);
1039 
1040         assembly {
1041             // solium-disable-previous-line security/no-inline-assembly
1042             // store the legnth
1043             mstore(ptr, _written)
1044             // new pointer is old + 0x20 + the footprint of the body
1045             mstore(0x40, add(add(ptr, _footprint), 0x20))
1046             ret := ptr
1047         }
1048     }
1049 }
1050 
1051 /*
1052  * Copyright (c) 2022, Circle Internet Financial Limited.
1053  *
1054  * Licensed under the Apache License, Version 2.0 (the "License");
1055  * you may not use this file except in compliance with the License.
1056  * You may obtain a copy of the License at
1057  *
1058  * http://www.apache.org/licenses/LICENSE-2.0
1059  *
1060  * Unless required by applicable law or agreed to in writing, software
1061  * distributed under the License is distributed on an "AS IS" BASIS,
1062  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1063  * See the License for the specific language governing permissions and
1064  * limitations under the License.
1065  */
1066 
1067 /*
1068  * Copyright (c) 2022, Circle Internet Financial Limited.
1069  *
1070  * Licensed under the Apache License, Version 2.0 (the "License");
1071  * you may not use this file except in compliance with the License.
1072  * You may obtain a copy of the License at
1073  *
1074  * http://www.apache.org/licenses/LICENSE-2.0
1075  *
1076  * Unless required by applicable law or agreed to in writing, software
1077  * distributed under the License is distributed on an "AS IS" BASIS,
1078  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1079  * See the License for the specific language governing permissions and
1080  * limitations under the License.
1081  */
1082 
1083 /**
1084  * @title IRelayer
1085  * @notice Sends messages from source domain to destination domain
1086  */
1087 interface IRelayer {
1088     /**
1089      * @notice Sends an outgoing message from the source domain.
1090      * @dev Increment nonce, format the message, and emit `MessageSent` event with message information.
1091      * @param destinationDomain Domain of destination chain
1092      * @param recipient Address of message recipient on destination domain as bytes32
1093      * @param messageBody Raw bytes content of message
1094      * @return nonce reserved by message
1095      */
1096     function sendMessage(
1097         uint32 destinationDomain,
1098         bytes32 recipient,
1099         bytes calldata messageBody
1100     ) external returns (uint64);
1101 
1102     /**
1103      * @notice Sends an outgoing message from the source domain, with a specified caller on the
1104      * destination domain.
1105      * @dev Increment nonce, format the message, and emit `MessageSent` event with message information.
1106      * WARNING: if the `destinationCaller` does not represent a valid address as bytes32, then it will not be possible
1107      * to broadcast the message on the destination domain. This is an advanced feature, and the standard
1108      * sendMessage() should be preferred for use cases where a specific destination caller is not required.
1109      * @param destinationDomain Domain of destination chain
1110      * @param recipient Address of message recipient on destination domain as bytes32
1111      * @param destinationCaller caller on the destination domain, as bytes32
1112      * @param messageBody Raw bytes content of message
1113      * @return nonce reserved by message
1114      */
1115     function sendMessageWithCaller(
1116         uint32 destinationDomain,
1117         bytes32 recipient,
1118         bytes32 destinationCaller,
1119         bytes calldata messageBody
1120     ) external returns (uint64);
1121 
1122     /**
1123      * @notice Replace a message with a new message body and/or destination caller.
1124      * @dev The `originalAttestation` must be a valid attestation of `originalMessage`.
1125      * @param originalMessage original message to replace
1126      * @param originalAttestation attestation of `originalMessage`
1127      * @param newMessageBody new message body of replaced message
1128      * @param newDestinationCaller the new destination caller
1129      */
1130     function replaceMessage(
1131         bytes calldata originalMessage,
1132         bytes calldata originalAttestation,
1133         bytes calldata newMessageBody,
1134         bytes32 newDestinationCaller
1135     ) external;
1136 }
1137 
1138 /*
1139  * Copyright (c) 2022, Circle Internet Financial Limited.
1140  *
1141  * Licensed under the Apache License, Version 2.0 (the "License");
1142  * you may not use this file except in compliance with the License.
1143  * You may obtain a copy of the License at
1144  *
1145  * http://www.apache.org/licenses/LICENSE-2.0
1146  *
1147  * Unless required by applicable law or agreed to in writing, software
1148  * distributed under the License is distributed on an "AS IS" BASIS,
1149  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1150  * See the License for the specific language governing permissions and
1151  * limitations under the License.
1152  */
1153 
1154 /**
1155  * @title IReceiver
1156  * @notice Receives messages on destination chain and forwards them to IMessageDestinationHandler
1157  */
1158 interface IReceiver {
1159     /**
1160      * @notice Receives an incoming message, validating the header and passing
1161      * the body to application-specific handler.
1162      * @param message The message raw bytes
1163      * @param signature The message signature
1164      * @return success bool, true if successful
1165      */
1166     function receiveMessage(bytes calldata message, bytes calldata signature)
1167         external
1168         returns (bool success);
1169 }
1170 
1171 /**
1172  * @title IMessageTransmitter
1173  * @notice Interface for message transmitters, which both relay and receive messages.
1174  */
1175 interface IMessageTransmitter is IRelayer, IReceiver {
1176 
1177 }
1178 
1179 /*
1180  * Copyright (c) 2022, Circle Internet Financial Limited.
1181  *
1182  * Licensed under the Apache License, Version 2.0 (the "License");
1183  * you may not use this file except in compliance with the License.
1184  * You may obtain a copy of the License at
1185  *
1186  * http://www.apache.org/licenses/LICENSE-2.0
1187  *
1188  * Unless required by applicable law or agreed to in writing, software
1189  * distributed under the License is distributed on an "AS IS" BASIS,
1190  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1191  * See the License for the specific language governing permissions and
1192  * limitations under the License.
1193  */
1194 
1195 /**
1196  * @title IMessageHandler
1197  * @notice Handles messages on destination domain forwarded from
1198  * an IReceiver
1199  */
1200 interface IMessageHandler {
1201     /**
1202      * @notice handles an incoming message from a Receiver
1203      * @param sourceDomain the source domain of the message
1204      * @param sender the sender of the message
1205      * @param messageBody The message raw bytes
1206      * @return success bool, true if successful
1207      */
1208     function handleReceiveMessage(
1209         uint32 sourceDomain,
1210         bytes32 sender,
1211         bytes calldata messageBody
1212     ) external returns (bool);
1213 }
1214 
1215 /*
1216  * Copyright (c) 2022, Circle Internet Financial Limited.
1217  *
1218  * Licensed under the Apache License, Version 2.0 (the "License");
1219  * you may not use this file except in compliance with the License.
1220  * You may obtain a copy of the License at
1221  *
1222  * http://www.apache.org/licenses/LICENSE-2.0
1223  *
1224  * Unless required by applicable law or agreed to in writing, software
1225  * distributed under the License is distributed on an "AS IS" BASIS,
1226  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1227  * See the License for the specific language governing permissions and
1228  * limitations under the License.
1229  */
1230 
1231 /**
1232  * @title Message Library
1233  * @notice Library for formatted messages used by Relayer and Receiver.
1234  *
1235  * @dev The message body is dynamically-sized to support custom message body
1236  * formats. Other fields must be fixed-size to avoid hash collisions.
1237  * Each other input value has an explicit type to guarantee fixed-size.
1238  * Padding: uintNN fields are left-padded, and bytesNN fields are right-padded.
1239  *
1240  * Field                 Bytes      Type       Index
1241  * version               4          uint32     0
1242  * sourceDomain          4          uint32     4
1243  * destinationDomain     4          uint32     8
1244  * nonce                 8          uint64     12
1245  * sender                32         bytes32    20
1246  * recipient             32         bytes32    52
1247  * destinationCaller     32         bytes32    84
1248  * messageBody           dynamic    bytes      116
1249  *
1250  **/
1251 library Message {
1252     using TypedMemView for bytes;
1253     using TypedMemView for bytes29;
1254 
1255     // Indices of each field in message
1256     uint8 private constant VERSION_INDEX = 0;
1257     uint8 private constant SOURCE_DOMAIN_INDEX = 4;
1258     uint8 private constant DESTINATION_DOMAIN_INDEX = 8;
1259     uint8 private constant NONCE_INDEX = 12;
1260     uint8 private constant SENDER_INDEX = 20;
1261     uint8 private constant RECIPIENT_INDEX = 52;
1262     uint8 private constant DESTINATION_CALLER_INDEX = 84;
1263     uint8 private constant MESSAGE_BODY_INDEX = 116;
1264 
1265     /**
1266      * @notice Returns formatted (packed) message with provided fields
1267      * @param _msgVersion the version of the message format
1268      * @param _msgSourceDomain Domain of home chain
1269      * @param _msgDestinationDomain Domain of destination chain
1270      * @param _msgNonce Destination-specific nonce
1271      * @param _msgSender Address of sender on source chain as bytes32
1272      * @param _msgRecipient Address of recipient on destination chain as bytes32
1273      * @param _msgDestinationCaller Address of caller on destination chain as bytes32
1274      * @param _msgRawBody Raw bytes of message body
1275      * @return Formatted message
1276      **/
1277     function _formatMessage(
1278         uint32 _msgVersion,
1279         uint32 _msgSourceDomain,
1280         uint32 _msgDestinationDomain,
1281         uint64 _msgNonce,
1282         bytes32 _msgSender,
1283         bytes32 _msgRecipient,
1284         bytes32 _msgDestinationCaller,
1285         bytes memory _msgRawBody
1286     ) internal pure returns (bytes memory) {
1287         return
1288             abi.encodePacked(
1289                 _msgVersion,
1290                 _msgSourceDomain,
1291                 _msgDestinationDomain,
1292                 _msgNonce,
1293                 _msgSender,
1294                 _msgRecipient,
1295                 _msgDestinationCaller,
1296                 _msgRawBody
1297             );
1298     }
1299 
1300     // @notice Returns _message's version field
1301     function _version(bytes29 _message) internal pure returns (uint32) {
1302         return uint32(_message.indexUint(VERSION_INDEX, 4));
1303     }
1304 
1305     // @notice Returns _message's sourceDomain field
1306     function _sourceDomain(bytes29 _message) internal pure returns (uint32) {
1307         return uint32(_message.indexUint(SOURCE_DOMAIN_INDEX, 4));
1308     }
1309 
1310     // @notice Returns _message's destinationDomain field
1311     function _destinationDomain(bytes29 _message)
1312         internal
1313         pure
1314         returns (uint32)
1315     {
1316         return uint32(_message.indexUint(DESTINATION_DOMAIN_INDEX, 4));
1317     }
1318 
1319     // @notice Returns _message's nonce field
1320     function _nonce(bytes29 _message) internal pure returns (uint64) {
1321         return uint64(_message.indexUint(NONCE_INDEX, 8));
1322     }
1323 
1324     // @notice Returns _message's sender field
1325     function _sender(bytes29 _message) internal pure returns (bytes32) {
1326         return _message.index(SENDER_INDEX, 32);
1327     }
1328 
1329     // @notice Returns _message's recipient field
1330     function _recipient(bytes29 _message) internal pure returns (bytes32) {
1331         return _message.index(RECIPIENT_INDEX, 32);
1332     }
1333 
1334     // @notice Returns _message's destinationCaller field
1335     function _destinationCaller(bytes29 _message)
1336         internal
1337         pure
1338         returns (bytes32)
1339     {
1340         return _message.index(DESTINATION_CALLER_INDEX, 32);
1341     }
1342 
1343     // @notice Returns _message's messageBody field
1344     function _messageBody(bytes29 _message) internal pure returns (bytes29) {
1345         return
1346             _message.slice(
1347                 MESSAGE_BODY_INDEX,
1348                 _message.len() - MESSAGE_BODY_INDEX,
1349                 0
1350             );
1351     }
1352 
1353     /**
1354      * @notice converts address to bytes32 (alignment preserving cast.)
1355      * @param addr the address to convert to bytes32
1356      */
1357     function addressToBytes32(address addr) external pure returns (bytes32) {
1358         return bytes32(uint256(uint160(addr)));
1359     }
1360 
1361     /**
1362      * @notice converts bytes32 to address (alignment preserving cast.)
1363      * @dev Warning: it is possible to have different input values _buf map to the same address.
1364      * For use cases where this is not acceptable, validate that the first 12 bytes of _buf are zero-padding.
1365      * @param _buf the bytes32 to convert to address
1366      */
1367     function bytes32ToAddress(bytes32 _buf) public pure returns (address) {
1368         return address(uint160(uint256(_buf)));
1369     }
1370 
1371     /**
1372      * @notice Reverts if message is malformed or incorrect length
1373      * @param _message The message as bytes29
1374      */
1375     function _validateMessageFormat(bytes29 _message) internal pure {
1376         require(_message.isValid(), "Malformed message");
1377         require(
1378             _message.len() >= MESSAGE_BODY_INDEX,
1379             "Invalid message: too short"
1380         );
1381     }
1382 }
1383 
1384 /*
1385  * Copyright (c) 2022, Circle Internet Financial Limited.
1386  *
1387  * Licensed under the Apache License, Version 2.0 (the "License");
1388  * you may not use this file except in compliance with the License.
1389  * You may obtain a copy of the License at
1390  *
1391  * http://www.apache.org/licenses/LICENSE-2.0
1392  *
1393  * Unless required by applicable law or agreed to in writing, software
1394  * distributed under the License is distributed on an "AS IS" BASIS,
1395  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1396  * See the License for the specific language governing permissions and
1397  * limitations under the License.
1398  */
1399 
1400 /*
1401  * Copyright (c) 2022, Circle Internet Financial Limited.
1402  *
1403  * Licensed under the Apache License, Version 2.0 (the "License");
1404  * you may not use this file except in compliance with the License.
1405  * You may obtain a copy of the License at
1406  *
1407  * http://www.apache.org/licenses/LICENSE-2.0
1408  *
1409  * Unless required by applicable law or agreed to in writing, software
1410  * distributed under the License is distributed on an "AS IS" BASIS,
1411  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1412  * See the License for the specific language governing permissions and
1413  * limitations under the License.
1414  */
1415 
1416 /*
1417  * Copyright (c) 2022, Circle Internet Financial Limited.
1418  *
1419  * Licensed under the Apache License, Version 2.0 (the "License");
1420  * you may not use this file except in compliance with the License.
1421  * You may obtain a copy of the License at
1422  *
1423  * http://www.apache.org/licenses/LICENSE-2.0
1424  *
1425  * Unless required by applicable law or agreed to in writing, software
1426  * distributed under the License is distributed on an "AS IS" BASIS,
1427  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1428  * See the License for the specific language governing permissions and
1429  * limitations under the License.
1430  */
1431 
1432 /*
1433  * @dev Provides information about the current execution context, including the
1434  * sender of the transaction and its data. While these are generally available
1435  * via msg.sender and msg.data, they should not be accessed in such a direct
1436  * manner, since when dealing with GSN meta-transactions the account sending and
1437  * paying for execution may not be the actual sender (as far as an application
1438  * is concerned).
1439  *
1440  * This contract is only required for intermediate, library-like contracts.
1441  */
1442 abstract contract Context {
1443     function _msgSender() internal view virtual returns (address payable) {
1444         return msg.sender;
1445     }
1446 
1447     function _msgData() internal view virtual returns (bytes memory) {
1448         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1449         return msg.data;
1450     }
1451 }
1452 
1453 /**
1454  * @dev forked from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7c5f6bc2c8743d83443fa46395d75f2f3f99054a/contracts/access/Ownable.sol
1455  * Modifications:
1456  * 1. Update Solidity version from 0.8.0 to 0.7.6 (11/9/2022). (v8 was used
1457  * as base because it includes internal _transferOwnership method.)
1458  * 2. Remove renounceOwnership function
1459  *
1460  * Description
1461  * Contract module which provides a basic access control mechanism, where
1462  * there is an account (an owner) that can be granted exclusive access to
1463  * specific functions.
1464  *
1465  * By default, the owner account will be the one that deploys the contract. This
1466  * can later be changed with {transferOwnership}.
1467  *
1468  * This module is used through inheritance. It will make available the modifier
1469  * `onlyOwner`, which can be applied to your functions to restrict their use to
1470  * the owner.
1471  */
1472 abstract contract Ownable is Context {
1473     address private _owner;
1474 
1475     event OwnershipTransferred(
1476         address indexed previousOwner,
1477         address indexed newOwner
1478     );
1479 
1480     /**
1481      * @dev Initializes the contract setting the deployer as the initial owner.
1482      */
1483     constructor() {
1484         _transferOwnership(_msgSender());
1485     }
1486 
1487     /**
1488      * @dev Throws if called by any account other than the owner.
1489      */
1490     modifier onlyOwner() {
1491         _checkOwner();
1492         _;
1493     }
1494 
1495     /**
1496      * @dev Returns the address of the current owner.
1497      */
1498     function owner() public view virtual returns (address) {
1499         return _owner;
1500     }
1501 
1502     /**
1503      * @dev Throws if the sender is not the owner.
1504      */
1505     function _checkOwner() internal view virtual {
1506         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1507     }
1508 
1509     /**
1510      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1511      * Can only be called by the current owner.
1512      */
1513     function transferOwnership(address newOwner) public virtual onlyOwner {
1514         require(
1515             newOwner != address(0),
1516             "Ownable: new owner is the zero address"
1517         );
1518         _transferOwnership(newOwner);
1519     }
1520 
1521     /**
1522      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1523      * Internal function without access restriction.
1524      */
1525     function _transferOwnership(address newOwner) internal virtual {
1526         address oldOwner = _owner;
1527         _owner = newOwner;
1528         emit OwnershipTransferred(oldOwner, newOwner);
1529     }
1530 }
1531 
1532 /**
1533  * @dev forked from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/7c5f6bc2c8743d83443fa46395d75f2f3f99054a/contracts/access/Ownable2Step.sol
1534  * Modifications:
1535  * 1. Update Solidity version from 0.8.0 to 0.7.6. Version 0.8.0 was used
1536  * as base because this contract was added to OZ repo after version 0.8.0.
1537  *
1538  * Contract module which provides access control mechanism, where
1539  * there is an account (an owner) that can be granted exclusive access to
1540  * specific functions.
1541  *
1542  * By default, the owner account will be the one that deploys the contract. This
1543  * can later be changed with {transferOwnership} and {acceptOwnership}.
1544  *
1545  * This module is used through inheritance. It will make available all functions
1546  * from parent (Ownable).
1547  */
1548 abstract contract Ownable2Step is Ownable {
1549     address private _pendingOwner;
1550 
1551     event OwnershipTransferStarted(
1552         address indexed previousOwner,
1553         address indexed newOwner
1554     );
1555 
1556     /**
1557      * @dev Returns the address of the pending owner.
1558      */
1559     function pendingOwner() public view virtual returns (address) {
1560         return _pendingOwner;
1561     }
1562 
1563     /**
1564      * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
1565      * Can only be called by the current owner.
1566      */
1567     function transferOwnership(address newOwner)
1568         public
1569         virtual
1570         override
1571         onlyOwner
1572     {
1573         _pendingOwner = newOwner;
1574         emit OwnershipTransferStarted(owner(), newOwner);
1575     }
1576 
1577     /**
1578      * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
1579      * Internal function without access restriction.
1580      */
1581     function _transferOwnership(address newOwner) internal virtual override {
1582         delete _pendingOwner;
1583         super._transferOwnership(newOwner);
1584     }
1585 
1586     /**
1587      * @dev The new owner accepts the ownership transfer.
1588      */
1589     function acceptOwnership() external {
1590         address sender = _msgSender();
1591         require(
1592             pendingOwner() == sender,
1593             "Ownable2Step: caller is not the new owner"
1594         );
1595         _transferOwnership(sender);
1596     }
1597 }
1598 
1599 /**
1600  * @notice Base contract which allows children to implement an emergency stop
1601  * mechanism
1602  * @dev Forked from https://github.com/centrehq/centre-tokens/blob/0d3cab14ebd133a83fc834dbd48d0468bdf0b391/contracts/v1/Pausable.sol
1603  * Modifications:
1604  * 1. Update Solidity version from 0.6.12 to 0.7.6 (8/23/2022)
1605  * 2. Change pauser visibility to private, declare external getter (11/19/22)
1606  */
1607 contract Pausable is Ownable2Step {
1608     event Pause();
1609     event Unpause();
1610     event PauserChanged(address indexed newAddress);
1611 
1612     address private _pauser;
1613     bool public paused = false;
1614 
1615     /**
1616      * @dev Modifier to make a function callable only when the contract is not paused.
1617      */
1618     modifier whenNotPaused() {
1619         require(!paused, "Pausable: paused");
1620         _;
1621     }
1622 
1623     /**
1624      * @dev throws if called by any account other than the pauser
1625      */
1626     modifier onlyPauser() {
1627         require(msg.sender == _pauser, "Pausable: caller is not the pauser");
1628         _;
1629     }
1630 
1631     /**
1632      * @notice Returns current pauser
1633      * @return Pauser's address
1634      */
1635     function pauser() external view returns (address) {
1636         return _pauser;
1637     }
1638 
1639     /**
1640      * @dev called by the owner to pause, triggers stopped state
1641      */
1642     function pause() external onlyPauser {
1643         paused = true;
1644         emit Pause();
1645     }
1646 
1647     /**
1648      * @dev called by the owner to unpause, returns to normal state
1649      */
1650     function unpause() external onlyPauser {
1651         paused = false;
1652         emit Unpause();
1653     }
1654 
1655     /**
1656      * @dev update the pauser role
1657      */
1658     function updatePauser(address _newPauser) external onlyOwner {
1659         require(
1660             _newPauser != address(0),
1661             "Pausable: new pauser is the zero address"
1662         );
1663         _pauser = _newPauser;
1664         emit PauserChanged(_pauser);
1665     }
1666 }
1667 
1668 /*
1669  * Copyright (c) 2022, Circle Internet Financial Limited.
1670  *
1671  * Licensed under the Apache License, Version 2.0 (the "License");
1672  * you may not use this file except in compliance with the License.
1673  * You may obtain a copy of the License at
1674  *
1675  * http://www.apache.org/licenses/LICENSE-2.0
1676  *
1677  * Unless required by applicable law or agreed to in writing, software
1678  * distributed under the License is distributed on an "AS IS" BASIS,
1679  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
1680  * See the License for the specific language governing permissions and
1681  * limitations under the License.
1682  */
1683 
1684 /**
1685  * @dev Interface of the ERC20 standard as defined in the EIP.
1686  */
1687 interface IERC20 {
1688     /**
1689      * @dev Returns the amount of tokens in existence.
1690      */
1691     function totalSupply() external view returns (uint256);
1692 
1693     /**
1694      * @dev Returns the amount of tokens owned by `account`.
1695      */
1696     function balanceOf(address account) external view returns (uint256);
1697 
1698     /**
1699      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1700      *
1701      * Returns a boolean value indicating whether the operation succeeded.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function transfer(address recipient, uint256 amount)
1706         external
1707         returns (bool);
1708 
1709     /**
1710      * @dev Returns the remaining number of tokens that `spender` will be
1711      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1712      * zero by default.
1713      *
1714      * This value changes when {approve} or {transferFrom} are called.
1715      */
1716     function allowance(address owner, address spender)
1717         external
1718         view
1719         returns (uint256);
1720 
1721     /**
1722      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1723      *
1724      * Returns a boolean value indicating whether the operation succeeded.
1725      *
1726      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1727      * that someone may use both the old and the new allowance by unfortunate
1728      * transaction ordering. One possible solution to mitigate this race
1729      * condition is to first reduce the spender's allowance to 0 and set the
1730      * desired value afterwards:
1731      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1732      *
1733      * Emits an {Approval} event.
1734      */
1735     function approve(address spender, uint256 amount) external returns (bool);
1736 
1737     /**
1738      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1739      * allowance mechanism. `amount` is then deducted from the caller's
1740      * allowance.
1741      *
1742      * Returns a boolean value indicating whether the operation succeeded.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function transferFrom(
1747         address sender,
1748         address recipient,
1749         uint256 amount
1750     ) external returns (bool);
1751 
1752     /**
1753      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1754      * another (`to`).
1755      *
1756      * Note that `value` may be zero.
1757      */
1758     event Transfer(address indexed from, address indexed to, uint256 value);
1759 
1760     /**
1761      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1762      * a call to {approve}. `value` is the new allowance.
1763      */
1764     event Approval(
1765         address indexed owner,
1766         address indexed spender,
1767         uint256 value
1768     );
1769 }
1770 
1771 /**
1772  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1773  * checks.
1774  *
1775  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1776  * in bugs, because programmers usually assume that an overflow raises an
1777  * error, which is the standard behavior in high level programming languages.
1778  * `SafeMath` restores this intuition by reverting the transaction when an
1779  * operation overflows.
1780  *
1781  * Using this library instead of the unchecked operations eliminates an entire
1782  * class of bugs, so it's recommended to use it always.
1783  */
1784 library SafeMath {
1785     /**
1786      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1787      *
1788      * _Available since v3.4._
1789      */
1790     function tryAdd(uint256 a, uint256 b)
1791         internal
1792         pure
1793         returns (bool, uint256)
1794     {
1795         uint256 c = a + b;
1796         if (c < a) return (false, 0);
1797         return (true, c);
1798     }
1799 
1800     /**
1801      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1802      *
1803      * _Available since v3.4._
1804      */
1805     function trySub(uint256 a, uint256 b)
1806         internal
1807         pure
1808         returns (bool, uint256)
1809     {
1810         if (b > a) return (false, 0);
1811         return (true, a - b);
1812     }
1813 
1814     /**
1815      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1816      *
1817      * _Available since v3.4._
1818      */
1819     function tryMul(uint256 a, uint256 b)
1820         internal
1821         pure
1822         returns (bool, uint256)
1823     {
1824         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1825         // benefit is lost if 'b' is also tested.
1826         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1827         if (a == 0) return (true, 0);
1828         uint256 c = a * b;
1829         if (c / a != b) return (false, 0);
1830         return (true, c);
1831     }
1832 
1833     /**
1834      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1835      *
1836      * _Available since v3.4._
1837      */
1838     function tryDiv(uint256 a, uint256 b)
1839         internal
1840         pure
1841         returns (bool, uint256)
1842     {
1843         if (b == 0) return (false, 0);
1844         return (true, a / b);
1845     }
1846 
1847     /**
1848      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1849      *
1850      * _Available since v3.4._
1851      */
1852     function tryMod(uint256 a, uint256 b)
1853         internal
1854         pure
1855         returns (bool, uint256)
1856     {
1857         if (b == 0) return (false, 0);
1858         return (true, a % b);
1859     }
1860 
1861     /**
1862      * @dev Returns the addition of two unsigned integers, reverting on
1863      * overflow.
1864      *
1865      * Counterpart to Solidity's `+` operator.
1866      *
1867      * Requirements:
1868      *
1869      * - Addition cannot overflow.
1870      */
1871     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1872         uint256 c = a + b;
1873         require(c >= a, "SafeMath: addition overflow");
1874         return c;
1875     }
1876 
1877     /**
1878      * @dev Returns the subtraction of two unsigned integers, reverting on
1879      * overflow (when the result is negative).
1880      *
1881      * Counterpart to Solidity's `-` operator.
1882      *
1883      * Requirements:
1884      *
1885      * - Subtraction cannot overflow.
1886      */
1887     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1888         require(b <= a, "SafeMath: subtraction overflow");
1889         return a - b;
1890     }
1891 
1892     /**
1893      * @dev Returns the multiplication of two unsigned integers, reverting on
1894      * overflow.
1895      *
1896      * Counterpart to Solidity's `*` operator.
1897      *
1898      * Requirements:
1899      *
1900      * - Multiplication cannot overflow.
1901      */
1902     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1903         if (a == 0) return 0;
1904         uint256 c = a * b;
1905         require(c / a == b, "SafeMath: multiplication overflow");
1906         return c;
1907     }
1908 
1909     /**
1910      * @dev Returns the integer division of two unsigned integers, reverting on
1911      * division by zero. The result is rounded towards zero.
1912      *
1913      * Counterpart to Solidity's `/` operator. Note: this function uses a
1914      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1915      * uses an invalid opcode to revert (consuming all remaining gas).
1916      *
1917      * Requirements:
1918      *
1919      * - The divisor cannot be zero.
1920      */
1921     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1922         require(b > 0, "SafeMath: division by zero");
1923         return a / b;
1924     }
1925 
1926     /**
1927      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1928      * reverting when dividing by zero.
1929      *
1930      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1931      * opcode (which leaves remaining gas untouched) while Solidity uses an
1932      * invalid opcode to revert (consuming all remaining gas).
1933      *
1934      * Requirements:
1935      *
1936      * - The divisor cannot be zero.
1937      */
1938     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1939         require(b > 0, "SafeMath: modulo by zero");
1940         return a % b;
1941     }
1942 
1943     /**
1944      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1945      * overflow (when the result is negative).
1946      *
1947      * CAUTION: This function is deprecated because it requires allocating memory for the error
1948      * message unnecessarily. For custom revert reasons use {trySub}.
1949      *
1950      * Counterpart to Solidity's `-` operator.
1951      *
1952      * Requirements:
1953      *
1954      * - Subtraction cannot overflow.
1955      */
1956     function sub(
1957         uint256 a,
1958         uint256 b,
1959         string memory errorMessage
1960     ) internal pure returns (uint256) {
1961         require(b <= a, errorMessage);
1962         return a - b;
1963     }
1964 
1965     /**
1966      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1967      * division by zero. The result is rounded towards zero.
1968      *
1969      * CAUTION: This function is deprecated because it requires allocating memory for the error
1970      * message unnecessarily. For custom revert reasons use {tryDiv}.
1971      *
1972      * Counterpart to Solidity's `/` operator. Note: this function uses a
1973      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1974      * uses an invalid opcode to revert (consuming all remaining gas).
1975      *
1976      * Requirements:
1977      *
1978      * - The divisor cannot be zero.
1979      */
1980     function div(
1981         uint256 a,
1982         uint256 b,
1983         string memory errorMessage
1984     ) internal pure returns (uint256) {
1985         require(b > 0, errorMessage);
1986         return a / b;
1987     }
1988 
1989     /**
1990      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1991      * reverting with custom message when dividing by zero.
1992      *
1993      * CAUTION: This function is deprecated because it requires allocating memory for the error
1994      * message unnecessarily. For custom revert reasons use {tryMod}.
1995      *
1996      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1997      * opcode (which leaves remaining gas untouched) while Solidity uses an
1998      * invalid opcode to revert (consuming all remaining gas).
1999      *
2000      * Requirements:
2001      *
2002      * - The divisor cannot be zero.
2003      */
2004     function mod(
2005         uint256 a,
2006         uint256 b,
2007         string memory errorMessage
2008     ) internal pure returns (uint256) {
2009         require(b > 0, errorMessage);
2010         return a % b;
2011     }
2012 }
2013 
2014 /**
2015  * @dev Collection of functions related to the address type
2016  */
2017 library Address {
2018     /**
2019      * @dev Returns true if `account` is a contract.
2020      *
2021      * [IMPORTANT]
2022      * ====
2023      * It is unsafe to assume that an address for which this function returns
2024      * false is an externally-owned account (EOA) and not a contract.
2025      *
2026      * Among others, `isContract` will return false for the following
2027      * types of addresses:
2028      *
2029      *  - an externally-owned account
2030      *  - a contract in construction
2031      *  - an address where a contract will be created
2032      *  - an address where a contract lived, but was destroyed
2033      * ====
2034      */
2035     function isContract(address account) internal view returns (bool) {
2036         // This method relies on extcodesize, which returns 0 for contracts in
2037         // construction, since the code is only stored at the end of the
2038         // constructor execution.
2039 
2040         uint256 size;
2041         // solhint-disable-next-line no-inline-assembly
2042         assembly {
2043             size := extcodesize(account)
2044         }
2045         return size > 0;
2046     }
2047 
2048     /**
2049      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2050      * `recipient`, forwarding all available gas and reverting on errors.
2051      *
2052      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2053      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2054      * imposed by `transfer`, making them unable to receive funds via
2055      * `transfer`. {sendValue} removes this limitation.
2056      *
2057      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2058      *
2059      * IMPORTANT: because control is transferred to `recipient`, care must be
2060      * taken to not create reentrancy vulnerabilities. Consider using
2061      * {ReentrancyGuard} or the
2062      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2063      */
2064     function sendValue(address payable recipient, uint256 amount) internal {
2065         require(
2066             address(this).balance >= amount,
2067             "Address: insufficient balance"
2068         );
2069 
2070         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
2071         (bool success, ) = recipient.call{value: amount}("");
2072         require(
2073             success,
2074             "Address: unable to send value, recipient may have reverted"
2075         );
2076     }
2077 
2078     /**
2079      * @dev Performs a Solidity function call using a low level `call`. A
2080      * plain`call` is an unsafe replacement for a function call: use this
2081      * function instead.
2082      *
2083      * If `target` reverts with a revert reason, it is bubbled up by this
2084      * function (like regular Solidity function calls).
2085      *
2086      * Returns the raw returned data. To convert to the expected return value,
2087      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2088      *
2089      * Requirements:
2090      *
2091      * - `target` must be a contract.
2092      * - calling `target` with `data` must not revert.
2093      *
2094      * _Available since v3.1._
2095      */
2096     function functionCall(address target, bytes memory data)
2097         internal
2098         returns (bytes memory)
2099     {
2100         return functionCall(target, data, "Address: low-level call failed");
2101     }
2102 
2103     /**
2104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2105      * `errorMessage` as a fallback revert reason when `target` reverts.
2106      *
2107      * _Available since v3.1._
2108      */
2109     function functionCall(
2110         address target,
2111         bytes memory data,
2112         string memory errorMessage
2113     ) internal returns (bytes memory) {
2114         return functionCallWithValue(target, data, 0, errorMessage);
2115     }
2116 
2117     /**
2118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2119      * but also transferring `value` wei to `target`.
2120      *
2121      * Requirements:
2122      *
2123      * - the calling contract must have an ETH balance of at least `value`.
2124      * - the called Solidity function must be `payable`.
2125      *
2126      * _Available since v3.1._
2127      */
2128     function functionCallWithValue(
2129         address target,
2130         bytes memory data,
2131         uint256 value
2132     ) internal returns (bytes memory) {
2133         return
2134             functionCallWithValue(
2135                 target,
2136                 data,
2137                 value,
2138                 "Address: low-level call with value failed"
2139             );
2140     }
2141 
2142     /**
2143      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2144      * with `errorMessage` as a fallback revert reason when `target` reverts.
2145      *
2146      * _Available since v3.1._
2147      */
2148     function functionCallWithValue(
2149         address target,
2150         bytes memory data,
2151         uint256 value,
2152         string memory errorMessage
2153     ) internal returns (bytes memory) {
2154         require(
2155             address(this).balance >= value,
2156             "Address: insufficient balance for call"
2157         );
2158         require(isContract(target), "Address: call to non-contract");
2159 
2160         // solhint-disable-next-line avoid-low-level-calls
2161         (bool success, bytes memory returndata) = target.call{value: value}(
2162             data
2163         );
2164         return _verifyCallResult(success, returndata, errorMessage);
2165     }
2166 
2167     /**
2168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2169      * but performing a static call.
2170      *
2171      * _Available since v3.3._
2172      */
2173     function functionStaticCall(address target, bytes memory data)
2174         internal
2175         view
2176         returns (bytes memory)
2177     {
2178         return
2179             functionStaticCall(
2180                 target,
2181                 data,
2182                 "Address: low-level static call failed"
2183             );
2184     }
2185 
2186     /**
2187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2188      * but performing a static call.
2189      *
2190      * _Available since v3.3._
2191      */
2192     function functionStaticCall(
2193         address target,
2194         bytes memory data,
2195         string memory errorMessage
2196     ) internal view returns (bytes memory) {
2197         require(isContract(target), "Address: static call to non-contract");
2198 
2199         // solhint-disable-next-line avoid-low-level-calls
2200         (bool success, bytes memory returndata) = target.staticcall(data);
2201         return _verifyCallResult(success, returndata, errorMessage);
2202     }
2203 
2204     /**
2205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2206      * but performing a delegate call.
2207      *
2208      * _Available since v3.4._
2209      */
2210     function functionDelegateCall(address target, bytes memory data)
2211         internal
2212         returns (bytes memory)
2213     {
2214         return
2215             functionDelegateCall(
2216                 target,
2217                 data,
2218                 "Address: low-level delegate call failed"
2219             );
2220     }
2221 
2222     /**
2223      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2224      * but performing a delegate call.
2225      *
2226      * _Available since v3.4._
2227      */
2228     function functionDelegateCall(
2229         address target,
2230         bytes memory data,
2231         string memory errorMessage
2232     ) internal returns (bytes memory) {
2233         require(isContract(target), "Address: delegate call to non-contract");
2234 
2235         // solhint-disable-next-line avoid-low-level-calls
2236         (bool success, bytes memory returndata) = target.delegatecall(data);
2237         return _verifyCallResult(success, returndata, errorMessage);
2238     }
2239 
2240     function _verifyCallResult(
2241         bool success,
2242         bytes memory returndata,
2243         string memory errorMessage
2244     ) private pure returns (bytes memory) {
2245         if (success) {
2246             return returndata;
2247         } else {
2248             // Look for revert reason and bubble it up if present
2249             if (returndata.length > 0) {
2250                 // The easiest way to bubble the revert reason is using memory via assembly
2251 
2252                 // solhint-disable-next-line no-inline-assembly
2253                 assembly {
2254                     let returndata_size := mload(returndata)
2255                     revert(add(32, returndata), returndata_size)
2256                 }
2257             } else {
2258                 revert(errorMessage);
2259             }
2260         }
2261     }
2262 }
2263 
2264 /**
2265  * @title SafeERC20
2266  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2267  * contract returns false). Tokens that return no value (and instead revert or
2268  * throw on failure) are also supported, non-reverting calls are assumed to be
2269  * successful.
2270  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2271  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2272  */
2273 library SafeERC20 {
2274     using SafeMath for uint256;
2275     using Address for address;
2276 
2277     function safeTransfer(
2278         IERC20 token,
2279         address to,
2280         uint256 value
2281     ) internal {
2282         _callOptionalReturn(
2283             token,
2284             abi.encodeWithSelector(token.transfer.selector, to, value)
2285         );
2286     }
2287 
2288     function safeTransferFrom(
2289         IERC20 token,
2290         address from,
2291         address to,
2292         uint256 value
2293     ) internal {
2294         _callOptionalReturn(
2295             token,
2296             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
2297         );
2298     }
2299 
2300     /**
2301      * @dev Deprecated. This function has issues similar to the ones found in
2302      * {IERC20-approve}, and its usage is discouraged.
2303      *
2304      * Whenever possible, use {safeIncreaseAllowance} and
2305      * {safeDecreaseAllowance} instead.
2306      */
2307     function safeApprove(
2308         IERC20 token,
2309         address spender,
2310         uint256 value
2311     ) internal {
2312         // safeApprove should only be called when setting an initial allowance,
2313         // or when resetting it to zero. To increase and decrease it, use
2314         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2315         // solhint-disable-next-line max-line-length
2316         require(
2317             (value == 0) || (token.allowance(address(this), spender) == 0),
2318             "SafeERC20: approve from non-zero to non-zero allowance"
2319         );
2320         _callOptionalReturn(
2321             token,
2322             abi.encodeWithSelector(token.approve.selector, spender, value)
2323         );
2324     }
2325 
2326     function safeIncreaseAllowance(
2327         IERC20 token,
2328         address spender,
2329         uint256 value
2330     ) internal {
2331         uint256 newAllowance = token.allowance(address(this), spender).add(
2332             value
2333         );
2334         _callOptionalReturn(
2335             token,
2336             abi.encodeWithSelector(
2337                 token.approve.selector,
2338                 spender,
2339                 newAllowance
2340             )
2341         );
2342     }
2343 
2344     function safeDecreaseAllowance(
2345         IERC20 token,
2346         address spender,
2347         uint256 value
2348     ) internal {
2349         uint256 newAllowance = token.allowance(address(this), spender).sub(
2350             value,
2351             "SafeERC20: decreased allowance below zero"
2352         );
2353         _callOptionalReturn(
2354             token,
2355             abi.encodeWithSelector(
2356                 token.approve.selector,
2357                 spender,
2358                 newAllowance
2359             )
2360         );
2361     }
2362 
2363     /**
2364      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2365      * on the return value: the return value is optional (but if data is returned, it must not be false).
2366      * @param token The token targeted by the call.
2367      * @param data The call data (encoded using abi.encode or one of its variants).
2368      */
2369     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2370         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2371         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2372         // the target address contains contract code and also asserts for success in the low-level call.
2373 
2374         bytes memory returndata = address(token).functionCall(
2375             data,
2376             "SafeERC20: low-level call failed"
2377         );
2378         if (returndata.length > 0) {
2379             // Return data is optional
2380             // solhint-disable-next-line max-line-length
2381             require(
2382                 abi.decode(returndata, (bool)),
2383                 "SafeERC20: ERC20 operation did not succeed"
2384             );
2385         }
2386     }
2387 }
2388 
2389 /**
2390  * @notice Base contract which allows children to rescue ERC20 locked in their contract.
2391  * @dev Forked from https://github.com/centrehq/centre-tokens/blob/0d3cab14ebd133a83fc834dbd48d0468bdf0b391/contracts/v1.1/Rescuable.sol
2392  * Modifications:
2393  * 1. Update Solidity version from 0.6.12 to 0.7.6 (8/23/2022)
2394  */
2395 contract Rescuable is Ownable2Step {
2396     using SafeERC20 for IERC20;
2397 
2398     address private _rescuer;
2399 
2400     event RescuerChanged(address indexed newRescuer);
2401 
2402     /**
2403      * @notice Returns current rescuer
2404      * @return Rescuer's address
2405      */
2406     function rescuer() external view returns (address) {
2407         return _rescuer;
2408     }
2409 
2410     /**
2411      * @notice Revert if called by any account other than the rescuer.
2412      */
2413     modifier onlyRescuer() {
2414         require(msg.sender == _rescuer, "Rescuable: caller is not the rescuer");
2415         _;
2416     }
2417 
2418     /**
2419      * @notice Rescue ERC20 tokens locked up in this contract.
2420      * @param tokenContract ERC20 token contract address
2421      * @param to        Recipient address
2422      * @param amount    Amount to withdraw
2423      */
2424     function rescueERC20(
2425         IERC20 tokenContract,
2426         address to,
2427         uint256 amount
2428     ) external onlyRescuer {
2429         tokenContract.safeTransfer(to, amount);
2430     }
2431 
2432     /**
2433      * @notice Assign the rescuer role to a given address.
2434      * @param newRescuer New rescuer's address
2435      */
2436     function updateRescuer(address newRescuer) external onlyOwner {
2437         require(
2438             newRescuer != address(0),
2439             "Rescuable: new rescuer is the zero address"
2440         );
2441         _rescuer = newRescuer;
2442         emit RescuerChanged(newRescuer);
2443     }
2444 }
2445 
2446 /*
2447  * Copyright (c) 2022, Circle Internet Financial Limited.
2448  *
2449  * Licensed under the Apache License, Version 2.0 (the "License");
2450  * you may not use this file except in compliance with the License.
2451  * You may obtain a copy of the License at
2452  *
2453  * http://www.apache.org/licenses/LICENSE-2.0
2454  *
2455  * Unless required by applicable law or agreed to in writing, software
2456  * distributed under the License is distributed on an "AS IS" BASIS,
2457  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
2458  * See the License for the specific language governing permissions and
2459  * limitations under the License.
2460  */
2461 
2462 /**
2463  * @dev Library for managing
2464  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
2465  * types.
2466  *
2467  * Sets have the following properties:
2468  *
2469  * - Elements are added, removed, and checked for existence in constant time
2470  * (O(1)).
2471  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
2472  *
2473  * ```
2474  * contract Example {
2475  *     // Add the library methods
2476  *     using EnumerableSet for EnumerableSet.AddressSet;
2477  *
2478  *     // Declare a set state variable
2479  *     EnumerableSet.AddressSet private mySet;
2480  * }
2481  * ```
2482  *
2483  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
2484  * and `uint256` (`UintSet`) are supported.
2485  */
2486 library EnumerableSet {
2487     // To implement this library for multiple types with as little code
2488     // repetition as possible, we write it in terms of a generic Set type with
2489     // bytes32 values.
2490     // The Set implementation uses private functions, and user-facing
2491     // implementations (such as AddressSet) are just wrappers around the
2492     // underlying Set.
2493     // This means that we can only create new EnumerableSets for types that fit
2494     // in bytes32.
2495 
2496     struct Set {
2497         // Storage of set values
2498         bytes32[] _values;
2499         // Position of the value in the `values` array, plus 1 because index 0
2500         // means a value is not in the set.
2501         mapping(bytes32 => uint256) _indexes;
2502     }
2503 
2504     /**
2505      * @dev Add a value to a set. O(1).
2506      *
2507      * Returns true if the value was added to the set, that is if it was not
2508      * already present.
2509      */
2510     function _add(Set storage set, bytes32 value) private returns (bool) {
2511         if (!_contains(set, value)) {
2512             set._values.push(value);
2513             // The value is stored at length-1, but we add 1 to all indexes
2514             // and use 0 as a sentinel value
2515             set._indexes[value] = set._values.length;
2516             return true;
2517         } else {
2518             return false;
2519         }
2520     }
2521 
2522     /**
2523      * @dev Removes a value from a set. O(1).
2524      *
2525      * Returns true if the value was removed from the set, that is if it was
2526      * present.
2527      */
2528     function _remove(Set storage set, bytes32 value) private returns (bool) {
2529         // We read and store the value's index to prevent multiple reads from the same storage slot
2530         uint256 valueIndex = set._indexes[value];
2531 
2532         if (valueIndex != 0) {
2533             // Equivalent to contains(set, value)
2534             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
2535             // the array, and then remove the last element (sometimes called as 'swap and pop').
2536             // This modifies the order of the array, as noted in {at}.
2537 
2538             uint256 toDeleteIndex = valueIndex - 1;
2539             uint256 lastIndex = set._values.length - 1;
2540 
2541             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
2542             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
2543 
2544             bytes32 lastvalue = set._values[lastIndex];
2545 
2546             // Move the last value to the index where the value to delete is
2547             set._values[toDeleteIndex] = lastvalue;
2548             // Update the index for the moved value
2549             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
2550 
2551             // Delete the slot where the moved value was stored
2552             set._values.pop();
2553 
2554             // Delete the index for the deleted slot
2555             delete set._indexes[value];
2556 
2557             return true;
2558         } else {
2559             return false;
2560         }
2561     }
2562 
2563     /**
2564      * @dev Returns true if the value is in the set. O(1).
2565      */
2566     function _contains(Set storage set, bytes32 value)
2567         private
2568         view
2569         returns (bool)
2570     {
2571         return set._indexes[value] != 0;
2572     }
2573 
2574     /**
2575      * @dev Returns the number of values on the set. O(1).
2576      */
2577     function _length(Set storage set) private view returns (uint256) {
2578         return set._values.length;
2579     }
2580 
2581     /**
2582      * @dev Returns the value stored at position `index` in the set. O(1).
2583      *
2584      * Note that there are no guarantees on the ordering of values inside the
2585      * array, and it may change when more values are added or removed.
2586      *
2587      * Requirements:
2588      *
2589      * - `index` must be strictly less than {length}.
2590      */
2591     function _at(Set storage set, uint256 index)
2592         private
2593         view
2594         returns (bytes32)
2595     {
2596         require(
2597             set._values.length > index,
2598             "EnumerableSet: index out of bounds"
2599         );
2600         return set._values[index];
2601     }
2602 
2603     // Bytes32Set
2604 
2605     struct Bytes32Set {
2606         Set _inner;
2607     }
2608 
2609     /**
2610      * @dev Add a value to a set. O(1).
2611      *
2612      * Returns true if the value was added to the set, that is if it was not
2613      * already present.
2614      */
2615     function add(Bytes32Set storage set, bytes32 value)
2616         internal
2617         returns (bool)
2618     {
2619         return _add(set._inner, value);
2620     }
2621 
2622     /**
2623      * @dev Removes a value from a set. O(1).
2624      *
2625      * Returns true if the value was removed from the set, that is if it was
2626      * present.
2627      */
2628     function remove(Bytes32Set storage set, bytes32 value)
2629         internal
2630         returns (bool)
2631     {
2632         return _remove(set._inner, value);
2633     }
2634 
2635     /**
2636      * @dev Returns true if the value is in the set. O(1).
2637      */
2638     function contains(Bytes32Set storage set, bytes32 value)
2639         internal
2640         view
2641         returns (bool)
2642     {
2643         return _contains(set._inner, value);
2644     }
2645 
2646     /**
2647      * @dev Returns the number of values in the set. O(1).
2648      */
2649     function length(Bytes32Set storage set) internal view returns (uint256) {
2650         return _length(set._inner);
2651     }
2652 
2653     /**
2654      * @dev Returns the value stored at position `index` in the set. O(1).
2655      *
2656      * Note that there are no guarantees on the ordering of values inside the
2657      * array, and it may change when more values are added or removed.
2658      *
2659      * Requirements:
2660      *
2661      * - `index` must be strictly less than {length}.
2662      */
2663     function at(Bytes32Set storage set, uint256 index)
2664         internal
2665         view
2666         returns (bytes32)
2667     {
2668         return _at(set._inner, index);
2669     }
2670 
2671     // AddressSet
2672 
2673     struct AddressSet {
2674         Set _inner;
2675     }
2676 
2677     /**
2678      * @dev Add a value to a set. O(1).
2679      *
2680      * Returns true if the value was added to the set, that is if it was not
2681      * already present.
2682      */
2683     function add(AddressSet storage set, address value)
2684         internal
2685         returns (bool)
2686     {
2687         return _add(set._inner, bytes32(uint256(uint160(value))));
2688     }
2689 
2690     /**
2691      * @dev Removes a value from a set. O(1).
2692      *
2693      * Returns true if the value was removed from the set, that is if it was
2694      * present.
2695      */
2696     function remove(AddressSet storage set, address value)
2697         internal
2698         returns (bool)
2699     {
2700         return _remove(set._inner, bytes32(uint256(uint160(value))));
2701     }
2702 
2703     /**
2704      * @dev Returns true if the value is in the set. O(1).
2705      */
2706     function contains(AddressSet storage set, address value)
2707         internal
2708         view
2709         returns (bool)
2710     {
2711         return _contains(set._inner, bytes32(uint256(uint160(value))));
2712     }
2713 
2714     /**
2715      * @dev Returns the number of values in the set. O(1).
2716      */
2717     function length(AddressSet storage set) internal view returns (uint256) {
2718         return _length(set._inner);
2719     }
2720 
2721     /**
2722      * @dev Returns the value stored at position `index` in the set. O(1).
2723      *
2724      * Note that there are no guarantees on the ordering of values inside the
2725      * array, and it may change when more values are added or removed.
2726      *
2727      * Requirements:
2728      *
2729      * - `index` must be strictly less than {length}.
2730      */
2731     function at(AddressSet storage set, uint256 index)
2732         internal
2733         view
2734         returns (address)
2735     {
2736         return address(uint160(uint256(_at(set._inner, index))));
2737     }
2738 
2739     // UintSet
2740 
2741     struct UintSet {
2742         Set _inner;
2743     }
2744 
2745     /**
2746      * @dev Add a value to a set. O(1).
2747      *
2748      * Returns true if the value was added to the set, that is if it was not
2749      * already present.
2750      */
2751     function add(UintSet storage set, uint256 value) internal returns (bool) {
2752         return _add(set._inner, bytes32(value));
2753     }
2754 
2755     /**
2756      * @dev Removes a value from a set. O(1).
2757      *
2758      * Returns true if the value was removed from the set, that is if it was
2759      * present.
2760      */
2761     function remove(UintSet storage set, uint256 value)
2762         internal
2763         returns (bool)
2764     {
2765         return _remove(set._inner, bytes32(value));
2766     }
2767 
2768     /**
2769      * @dev Returns true if the value is in the set. O(1).
2770      */
2771     function contains(UintSet storage set, uint256 value)
2772         internal
2773         view
2774         returns (bool)
2775     {
2776         return _contains(set._inner, bytes32(value));
2777     }
2778 
2779     /**
2780      * @dev Returns the number of values on the set. O(1).
2781      */
2782     function length(UintSet storage set) internal view returns (uint256) {
2783         return _length(set._inner);
2784     }
2785 
2786     /**
2787      * @dev Returns the value stored at position `index` in the set. O(1).
2788      *
2789      * Note that there are no guarantees on the ordering of values inside the
2790      * array, and it may change when more values are added or removed.
2791      *
2792      * Requirements:
2793      *
2794      * - `index` must be strictly less than {length}.
2795      */
2796     function at(UintSet storage set, uint256 index)
2797         internal
2798         view
2799         returns (uint256)
2800     {
2801         return uint256(_at(set._inner, index));
2802     }
2803 }
2804 
2805 /**
2806  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2807  *
2808  * These functions can be used to verify that a message was signed by the holder
2809  * of the private keys of a given address.
2810  */
2811 library ECDSA {
2812     /**
2813      * @dev Returns the address that signed a hashed message (`hash`) with
2814      * `signature`. This address can then be used for verification purposes.
2815      *
2816      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2817      * this function rejects them by requiring the `s` value to be in the lower
2818      * half order, and the `v` value to be either 27 or 28.
2819      *
2820      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2821      * verification to be secure: it is possible to craft signatures that
2822      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2823      * this is by receiving a hash of the original message (which may otherwise
2824      * be too long), and then calling {toEthSignedMessageHash} on it.
2825      */
2826     function recover(bytes32 hash, bytes memory signature)
2827         internal
2828         pure
2829         returns (address)
2830     {
2831         // Check the signature length
2832         if (signature.length != 65) {
2833             revert("ECDSA: invalid signature length");
2834         }
2835 
2836         // Divide the signature in r, s and v variables
2837         bytes32 r;
2838         bytes32 s;
2839         uint8 v;
2840 
2841         // ecrecover takes the signature parameters, and the only way to get them
2842         // currently is to use assembly.
2843         // solhint-disable-next-line no-inline-assembly
2844         assembly {
2845             r := mload(add(signature, 0x20))
2846             s := mload(add(signature, 0x40))
2847             v := byte(0, mload(add(signature, 0x60)))
2848         }
2849 
2850         return recover(hash, v, r, s);
2851     }
2852 
2853     /**
2854      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
2855      * `r` and `s` signature fields separately.
2856      */
2857     function recover(
2858         bytes32 hash,
2859         uint8 v,
2860         bytes32 r,
2861         bytes32 s
2862     ) internal pure returns (address) {
2863         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2864         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2865         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
2866         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2867         //
2868         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2869         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2870         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2871         // these malleable signatures as well.
2872         require(
2873             uint256(s) <=
2874                 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
2875             "ECDSA: invalid signature 's' value"
2876         );
2877         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
2878 
2879         // If the signature is valid (and not malleable), return the signer address
2880         address signer = ecrecover(hash, v, r, s);
2881         require(signer != address(0), "ECDSA: invalid signature");
2882 
2883         return signer;
2884     }
2885 
2886     /**
2887      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2888      * replicates the behavior of the
2889      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
2890      * JSON-RPC method.
2891      *
2892      * See {recover}.
2893      */
2894     function toEthSignedMessageHash(bytes32 hash)
2895         internal
2896         pure
2897         returns (bytes32)
2898     {
2899         // 32 is the length in bytes of hash,
2900         // enforced by the type signature above
2901         return
2902             keccak256(
2903                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
2904             );
2905     }
2906 }
2907 
2908 contract Attestable is Ownable2Step {
2909     // ============ Events ============
2910     /**
2911      * @notice Emitted when an attester is enabled
2912      * @param attester newly enabled attester
2913      */
2914     event AttesterEnabled(address indexed attester);
2915 
2916     /**
2917      * @notice Emitted when an attester is disabled
2918      * @param attester newly disabled attester
2919      */
2920     event AttesterDisabled(address indexed attester);
2921 
2922     /**
2923      * @notice Emitted when threshold number of attestations (m in m/n multisig) is updated
2924      * @param oldSignatureThreshold old signature threshold
2925      * @param newSignatureThreshold new signature threshold
2926      */
2927     event SignatureThresholdUpdated(
2928         uint256 oldSignatureThreshold,
2929         uint256 newSignatureThreshold
2930     );
2931 
2932     /**
2933      * @dev Emitted when attester manager address is updated
2934      * @param previousAttesterManager representing the address of the previous attester manager
2935      * @param newAttesterManager representing the address of the new attester manager
2936      */
2937     event AttesterManagerUpdated(
2938         address indexed previousAttesterManager,
2939         address indexed newAttesterManager
2940     );
2941 
2942     // ============ Libraries ============
2943     using EnumerableSet for EnumerableSet.AddressSet;
2944 
2945     // ============ State Variables ============
2946     // number of signatures from distinct attesters required for a message to be received (m in m/n multisig)
2947     uint256 public signatureThreshold;
2948 
2949     // 65-byte ECDSA signature: v (32) + r (32) + s (1)
2950     uint256 internal constant signatureLength = 65;
2951 
2952     // enabled attesters (message signers)
2953     // (length of enabledAttesters is n in m/n multisig of message signers)
2954     EnumerableSet.AddressSet private enabledAttesters;
2955 
2956     // Attester Manager of the contract
2957     address private _attesterManager;
2958 
2959     // ============ Modifiers ============
2960     /**
2961      * @dev Throws if called by any account other than the attester manager.
2962      */
2963     modifier onlyAttesterManager() {
2964         require(msg.sender == _attesterManager, "Caller not attester manager");
2965         _;
2966     }
2967 
2968     // ============ Constructor ============
2969     /**
2970      * @dev The constructor sets the original attester manager of the contract to the sender account.
2971      * @param attester attester to initialize
2972      */
2973     constructor(address attester) {
2974         _setAttesterManager(msg.sender);
2975         // Initially 1 signature is required. Threshold can be increased by attesterManager.
2976         signatureThreshold = 1;
2977         enableAttester(attester);
2978     }
2979 
2980     // ============ Public/External Functions  ============
2981     /**
2982      * @notice Enables an attester
2983      * @dev Only callable by attesterManager. New attester must be nonzero, and currently disabled.
2984      * @param newAttester attester to enable
2985      */
2986     function enableAttester(address newAttester) public onlyAttesterManager {
2987         require(newAttester != address(0), "New attester must be nonzero");
2988         require(enabledAttesters.add(newAttester), "Attester already enabled");
2989         emit AttesterEnabled(newAttester);
2990     }
2991 
2992     /**
2993      * @notice returns true if given `attester` is enabled, else false
2994      * @param attester attester to check enabled status of
2995      * @return true if given `attester` is enabled, else false
2996      */
2997     function isEnabledAttester(address attester) public view returns (bool) {
2998         return enabledAttesters.contains(attester);
2999     }
3000 
3001     /**
3002      * @notice returns the number of enabled attesters
3003      * @return number of enabled attesters
3004      */
3005     function getNumEnabledAttesters() public view returns (uint256) {
3006         return enabledAttesters.length();
3007     }
3008 
3009     /**
3010      * @dev Allows the current attester manager to transfer control of the contract to a newAttesterManager.
3011      * @param newAttesterManager The address to update attester manager to.
3012      */
3013     function updateAttesterManager(address newAttesterManager)
3014         external
3015         onlyOwner
3016     {
3017         require(
3018             newAttesterManager != address(0),
3019             "Invalid attester manager address"
3020         );
3021         address _oldAttesterManager = _attesterManager;
3022         _setAttesterManager(newAttesterManager);
3023         emit AttesterManagerUpdated(_oldAttesterManager, newAttesterManager);
3024     }
3025 
3026     /**
3027      * @notice Disables an attester
3028      * @dev Only callable by attesterManager. Disabling the attester is not allowed if there is only one attester
3029      * enabled, or if it would cause the number of enabled attesters to become less than signatureThreshold.
3030      * (Attester must be currently enabled.)
3031      * @param attester attester to disable
3032      */
3033     function disableAttester(address attester) external onlyAttesterManager {
3034         // Disallow disabling attester if there is only 1 active attester
3035         uint256 _numEnabledAttesters = getNumEnabledAttesters();
3036 
3037         require(_numEnabledAttesters > 1, "Too few enabled attesters");
3038 
3039         // Disallow disabling an attester if it would cause the n in m/n multisig to fall below m (threshold # of signers).
3040         require(
3041             _numEnabledAttesters > signatureThreshold,
3042             "Signature threshold is too low"
3043         );
3044 
3045         require(enabledAttesters.remove(attester), "Attester already disabled");
3046         emit AttesterDisabled(attester);
3047     }
3048 
3049     /**
3050      * @notice Sets the threshold of signatures required to attest to a message.
3051      * (This is the m in m/n multisig.)
3052      * @dev new signature threshold must be nonzero, and must not exceed number
3053      * of enabled attesters.
3054      * @param newSignatureThreshold new signature threshold
3055      */
3056     function setSignatureThreshold(uint256 newSignatureThreshold)
3057         external
3058         onlyAttesterManager
3059     {
3060         require(newSignatureThreshold != 0, "Invalid signature threshold");
3061 
3062         // New signature threshold cannot exceed the number of enabled attesters
3063         require(
3064             newSignatureThreshold <= enabledAttesters.length(),
3065             "New signature threshold too high"
3066         );
3067 
3068         require(
3069             newSignatureThreshold != signatureThreshold,
3070             "Signature threshold already set"
3071         );
3072 
3073         uint256 _oldSignatureThreshold = signatureThreshold;
3074         signatureThreshold = newSignatureThreshold;
3075         emit SignatureThresholdUpdated(
3076             _oldSignatureThreshold,
3077             signatureThreshold
3078         );
3079     }
3080 
3081     /**
3082      * @dev Returns the address of the attester manager
3083      * @return address of the attester manager
3084      */
3085     function attesterManager() external view returns (address) {
3086         return _attesterManager;
3087     }
3088 
3089     /**
3090      * @notice gets enabled attester at given `index`
3091      * @param index index of attester to check
3092      * @return enabled attester at given `index`
3093      */
3094     function getEnabledAttester(uint256 index) external view returns (address) {
3095         return enabledAttesters.at(index);
3096     }
3097 
3098     // ============ Internal Utils ============
3099     /**
3100      * @dev Sets a new attester manager address
3101      * @param _newAttesterManager attester manager address to set
3102      */
3103     function _setAttesterManager(address _newAttesterManager) internal {
3104         _attesterManager = _newAttesterManager;
3105     }
3106 
3107     /**
3108      * @notice reverts if the attestation, which is comprised of one or more concatenated 65-byte signatures, is invalid.
3109      * @dev Rules for valid attestation:
3110      * 1. length of `_attestation` == 65 (signature length) * signatureThreshold
3111      * 2. addresses recovered from attestation must be in increasing order.
3112      * For example, if signature A is signed by address 0x1..., and signature B
3113      * is signed by address 0x2..., attestation must be passed as AB.
3114      * 3. no duplicate signers
3115      * 4. all signers must be enabled attesters
3116      *
3117      * Based on Christian Lundkvist's Simple Multisig
3118      * (https://github.com/christianlundkvist/simple-multisig/tree/560c463c8651e0a4da331bd8f245ccd2a48ab63d)
3119      * @param _message message to verify attestation of
3120      * @param _attestation attestation of `_message`
3121      */
3122     function _verifyAttestationSignatures(
3123         bytes calldata _message,
3124         bytes calldata _attestation
3125     ) internal view {
3126         require(
3127             _attestation.length == signatureLength * signatureThreshold,
3128             "Invalid attestation length"
3129         );
3130 
3131         // (Attesters cannot be address(0))
3132         address _latestAttesterAddress = address(0);
3133         // Address recovered from signatures must be in increasing order, to prevent duplicates
3134 
3135         bytes32 _digest = keccak256(_message);
3136 
3137         for (uint256 i; i < signatureThreshold; ++i) {
3138             bytes memory _signature = _attestation[i * signatureLength:i *
3139                 signatureLength +
3140                 signatureLength];
3141 
3142             address _recoveredAttester = _recoverAttesterSignature(
3143                 _digest,
3144                 _signature
3145             );
3146 
3147             // Signatures must be in increasing order of address, and may not duplicate signatures from same address
3148             require(
3149                 _recoveredAttester > _latestAttesterAddress,
3150                 "Invalid signature order or dupe"
3151             );
3152             require(
3153                 isEnabledAttester(_recoveredAttester),
3154                 "Invalid signature: not attester"
3155             );
3156             _latestAttesterAddress = _recoveredAttester;
3157         }
3158     }
3159 
3160     /**
3161      * @notice Checks that signature was signed by attester
3162      * @param _digest message hash
3163      * @param _signature message signature
3164      * @return address of recovered signer
3165      **/
3166     function _recoverAttesterSignature(bytes32 _digest, bytes memory _signature)
3167         internal
3168         pure
3169         returns (address)
3170     {
3171         return (ECDSA.recover(_digest, _signature));
3172     }
3173 }
3174 
3175 /**
3176  * @title MessageTransmitter
3177  * @notice Contract responsible for sending and receiving messages across chains.
3178  */
3179 contract MessageTransmitter is
3180     IMessageTransmitter,
3181     Pausable,
3182     Rescuable,
3183     Attestable
3184 {
3185     // ============ Events ============
3186     /**
3187      * @notice Emitted when a new message is dispatched
3188      * @param message Raw bytes of message
3189      */
3190     event MessageSent(bytes message);
3191 
3192     /**
3193      * @notice Emitted when a new message is received
3194      * @param caller Caller (msg.sender) on destination domain
3195      * @param sourceDomain The source domain this message originated from
3196      * @param nonce The nonce unique to this message
3197      * @param sender The sender of this message
3198      * @param messageBody message body bytes
3199      */
3200     event MessageReceived(
3201         address indexed caller,
3202         uint32 sourceDomain,
3203         uint64 indexed nonce,
3204         bytes32 sender,
3205         bytes messageBody
3206     );
3207 
3208     /**
3209      * @notice Emitted when max message body size is updated
3210      * @param newMaxMessageBodySize new maximum message body size, in bytes
3211      */
3212     event MaxMessageBodySizeUpdated(uint256 newMaxMessageBodySize);
3213 
3214     // ============ Libraries ============
3215     using TypedMemView for bytes;
3216     using TypedMemView for bytes29;
3217     using Message for bytes29;
3218 
3219     // ============ State Variables ============
3220     // Domain of chain on which the contract is deployed
3221     uint32 public immutable localDomain;
3222 
3223     // Message Format version
3224     uint32 public immutable version;
3225 
3226     // Maximum size of message body, in bytes.
3227     // This value is set by owner.
3228     uint256 public maxMessageBodySize;
3229 
3230     // Next available nonce from this source domain
3231     uint64 public nextAvailableNonce;
3232 
3233     // Maps a bytes32 hash of (sourceDomain, nonce) -> uint256 (0 if unused, 1 if used)
3234     mapping(bytes32 => uint256) public usedNonces;
3235 
3236     // ============ Constructor ============
3237     constructor(
3238         uint32 _localDomain,
3239         address _attester,
3240         uint32 _maxMessageBodySize,
3241         uint32 _version
3242     ) Attestable(_attester) {
3243         localDomain = _localDomain;
3244         maxMessageBodySize = _maxMessageBodySize;
3245         version = _version;
3246     }
3247 
3248     // ============ External Functions  ============
3249     /**
3250      * @notice Send the message to the destination domain and recipient
3251      * @dev Increment nonce, format the message, and emit `MessageSent` event with message information.
3252      * @param destinationDomain Domain of destination chain
3253      * @param recipient Address of message recipient on destination chain as bytes32
3254      * @param messageBody Raw bytes content of message
3255      * @return nonce reserved by message
3256      */
3257     function sendMessage(
3258         uint32 destinationDomain,
3259         bytes32 recipient,
3260         bytes calldata messageBody
3261     ) external override whenNotPaused returns (uint64) {
3262         bytes32 _emptyDestinationCaller = bytes32(0);
3263         uint64 _nonce = _reserveAndIncrementNonce();
3264         bytes32 _messageSender = Message.addressToBytes32(msg.sender);
3265 
3266         _sendMessage(
3267             destinationDomain,
3268             recipient,
3269             _emptyDestinationCaller,
3270             _messageSender,
3271             _nonce,
3272             messageBody
3273         );
3274 
3275         return _nonce;
3276     }
3277 
3278     /**
3279      * @notice Replace a message with a new message body and/or destination caller.
3280      * @dev The `originalAttestation` must be a valid attestation of `originalMessage`.
3281      * Reverts if msg.sender does not match sender of original message, or if the source domain of the original message
3282      * does not match this MessageTransmitter's local domain.
3283      * @param originalMessage original message to replace
3284      * @param originalAttestation attestation of `originalMessage`
3285      * @param newMessageBody new message body of replaced message
3286      * @param newDestinationCaller the new destination caller, which may be the
3287      * same as the original destination caller, a new destination caller, or an empty
3288      * destination caller (bytes32(0), indicating that any destination caller is valid.)
3289      */
3290     function replaceMessage(
3291         bytes calldata originalMessage,
3292         bytes calldata originalAttestation,
3293         bytes calldata newMessageBody,
3294         bytes32 newDestinationCaller
3295     ) external override whenNotPaused {
3296         // Validate each signature in the attestation
3297         _verifyAttestationSignatures(originalMessage, originalAttestation);
3298 
3299         bytes29 _originalMsg = originalMessage.ref(0);
3300 
3301         // Validate message format
3302         _originalMsg._validateMessageFormat();
3303 
3304         // Validate message sender
3305         bytes32 _sender = _originalMsg._sender();
3306         require(
3307             msg.sender == Message.bytes32ToAddress(_sender),
3308             "Sender not permitted to use nonce"
3309         );
3310 
3311         // Validate source domain
3312         uint32 _sourceDomain = _originalMsg._sourceDomain();
3313         require(
3314             _sourceDomain == localDomain,
3315             "Message not originally sent from this domain"
3316         );
3317 
3318         uint32 _destinationDomain = _originalMsg._destinationDomain();
3319         bytes32 _recipient = _originalMsg._recipient();
3320         uint64 _nonce = _originalMsg._nonce();
3321 
3322         _sendMessage(
3323             _destinationDomain,
3324             _recipient,
3325             newDestinationCaller,
3326             _sender,
3327             _nonce,
3328             newMessageBody
3329         );
3330     }
3331 
3332     /**
3333      * @notice Send the message to the destination domain and recipient, for a specified `destinationCaller` on the
3334      * destination domain.
3335      * @dev Increment nonce, format the message, and emit `MessageSent` event with message information.
3336      * WARNING: if the `destinationCaller` does not represent a valid address, then it will not be possible
3337      * to broadcast the message on the destination domain. This is an advanced feature, and the standard
3338      * sendMessage() should be preferred for use cases where a specific destination caller is not required.
3339      * @param destinationDomain Domain of destination chain
3340      * @param recipient Address of message recipient on destination domain as bytes32
3341      * @param destinationCaller caller on the destination domain, as bytes32
3342      * @param messageBody Raw bytes content of message
3343      * @return nonce reserved by message
3344      */
3345     function sendMessageWithCaller(
3346         uint32 destinationDomain,
3347         bytes32 recipient,
3348         bytes32 destinationCaller,
3349         bytes calldata messageBody
3350     ) external override whenNotPaused returns (uint64) {
3351         require(
3352             destinationCaller != bytes32(0),
3353             "Destination caller must be nonzero"
3354         );
3355 
3356         uint64 _nonce = _reserveAndIncrementNonce();
3357         bytes32 _messageSender = Message.addressToBytes32(msg.sender);
3358 
3359         _sendMessage(
3360             destinationDomain,
3361             recipient,
3362             destinationCaller,
3363             _messageSender,
3364             _nonce,
3365             messageBody
3366         );
3367 
3368         return _nonce;
3369     }
3370 
3371     /**
3372      * @notice Receive a message. Messages with a given nonce
3373      * can only be broadcast once for a (sourceDomain, destinationDomain)
3374      * pair. The message body of a valid message is passed to the
3375      * specified recipient for further processing.
3376      *
3377      * @dev Attestation format:
3378      * A valid attestation is the concatenated 65-byte signature(s) of exactly
3379      * `thresholdSignature` signatures, in increasing order of attester address.
3380      * ***If the attester addresses recovered from signatures are not in
3381      * increasing order, signature verification will fail.***
3382      * If incorrect number of signatures or duplicate signatures are supplied,
3383      * signature verification will fail.
3384      *
3385      * Message format:
3386      * Field                 Bytes      Type       Index
3387      * version               4          uint32     0
3388      * sourceDomain          4          uint32     4
3389      * destinationDomain     4          uint32     8
3390      * nonce                 8          uint64     12
3391      * sender                32         bytes32    20
3392      * recipient             32         bytes32    52
3393      * messageBody           dynamic    bytes      84
3394      * @param message Message bytes
3395      * @param attestation Concatenated 65-byte signature(s) of `message`, in increasing order
3396      * of the attester address recovered from signatures.
3397      * @return success bool, true if successful
3398      */
3399     function receiveMessage(bytes calldata message, bytes calldata attestation)
3400         external
3401         override
3402         whenNotPaused
3403         returns (bool success)
3404     {
3405         // Validate each signature in the attestation
3406         _verifyAttestationSignatures(message, attestation);
3407 
3408         bytes29 _msg = message.ref(0);
3409 
3410         // Validate message format
3411         _msg._validateMessageFormat();
3412 
3413         // Validate domain
3414         require(
3415             _msg._destinationDomain() == localDomain,
3416             "Invalid destination domain"
3417         );
3418 
3419         // Validate destination caller
3420         if (_msg._destinationCaller() != bytes32(0)) {
3421             require(
3422                 _msg._destinationCaller() ==
3423                     Message.addressToBytes32(msg.sender),
3424                 "Invalid caller for message"
3425             );
3426         }
3427 
3428         // Validate version
3429         require(_msg._version() == version, "Invalid message version");
3430 
3431         // Validate nonce is available
3432         uint32 _sourceDomain = _msg._sourceDomain();
3433         uint64 _nonce = _msg._nonce();
3434         bytes32 _sourceAndNonce = _hashSourceAndNonce(_sourceDomain, _nonce);
3435         require(usedNonces[_sourceAndNonce] == 0, "Nonce already used");
3436         // Mark nonce used
3437         usedNonces[_sourceAndNonce] = 1;
3438 
3439         // Handle receive message
3440         bytes32 _sender = _msg._sender();
3441         bytes memory _messageBody = _msg._messageBody().clone();
3442         require(
3443             IMessageHandler(Message.bytes32ToAddress(_msg._recipient()))
3444                 .handleReceiveMessage(_sourceDomain, _sender, _messageBody),
3445             "handleReceiveMessage() failed"
3446         );
3447 
3448         // Emit MessageReceived event
3449         emit MessageReceived(
3450             msg.sender,
3451             _sourceDomain,
3452             _nonce,
3453             _sender,
3454             _messageBody
3455         );
3456         return true;
3457     }
3458 
3459     /**
3460      * @notice Sets the max message body size
3461      * @dev This value should not be reduced without good reason,
3462      * to avoid impacting users who rely on large messages.
3463      * @param newMaxMessageBodySize new max message body size, in bytes
3464      */
3465     function setMaxMessageBodySize(uint256 newMaxMessageBodySize)
3466         external
3467         onlyOwner
3468     {
3469         maxMessageBodySize = newMaxMessageBodySize;
3470         emit MaxMessageBodySizeUpdated(maxMessageBodySize);
3471     }
3472 
3473     // ============ Internal Utils ============
3474     /**
3475      * @notice Send the message to the destination domain and recipient. If `_destinationCaller` is not equal to bytes32(0),
3476      * the message can only be received on the destination chain when called by `_destinationCaller`.
3477      * @dev Format the message and emit `MessageSent` event with message information.
3478      * @param _destinationDomain Domain of destination chain
3479      * @param _recipient Address of message recipient on destination domain as bytes32
3480      * @param _destinationCaller caller on the destination domain, as bytes32
3481      * @param _sender message sender, as bytes32
3482      * @param _nonce nonce reserved for message
3483      * @param _messageBody Raw bytes content of message
3484      */
3485     function _sendMessage(
3486         uint32 _destinationDomain,
3487         bytes32 _recipient,
3488         bytes32 _destinationCaller,
3489         bytes32 _sender,
3490         uint64 _nonce,
3491         bytes calldata _messageBody
3492     ) internal {
3493         // Validate message body length
3494         require(
3495             _messageBody.length <= maxMessageBodySize,
3496             "Message body exceeds max size"
3497         );
3498 
3499         require(_recipient != bytes32(0), "Recipient must be nonzero");
3500 
3501         // serialize message
3502         bytes memory _message = Message._formatMessage(
3503             version,
3504             localDomain,
3505             _destinationDomain,
3506             _nonce,
3507             _sender,
3508             _recipient,
3509             _destinationCaller,
3510             _messageBody
3511         );
3512 
3513         // Emit MessageSent event
3514         emit MessageSent(_message);
3515     }
3516 
3517     /**
3518      * @notice hashes `_source` and `_nonce`.
3519      * @param _source Domain of chain where the transfer originated
3520      * @param _nonce The unique identifier for the message from source to
3521               destination
3522      * @return hash of source and nonce
3523      */
3524     function _hashSourceAndNonce(uint32 _source, uint64 _nonce)
3525         internal
3526         pure
3527         returns (bytes32)
3528     {
3529         return keccak256(abi.encodePacked(_source, _nonce));
3530     }
3531 
3532     /**
3533      * Reserve and increment next available nonce
3534      * @return nonce reserved
3535      */
3536     function _reserveAndIncrementNonce() internal returns (uint64) {
3537         uint64 _nonceReserved = nextAvailableNonce;
3538         nextAvailableNonce = nextAvailableNonce + 1;
3539         return _nonceReserved;
3540     }
3541 }