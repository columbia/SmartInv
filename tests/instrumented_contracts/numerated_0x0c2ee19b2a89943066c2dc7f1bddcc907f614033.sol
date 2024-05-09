1 /// @title Base64
2 /// @notice Provides a function for encoding some bytes in base64
3 /// @author Brecht Devos <brecht@loopring.org>
4 library Base64 {
5     bytes internal constant TABLE =
6         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
7 
8     /// @notice Encodes some bytes to the base64 representation
9     function encode(bytes memory data) internal pure returns (string memory) {
10         uint256 len = data.length;
11         if (len == 0) return "";
12 
13         // multiply by 4/3 rounded up
14         uint256 encodedLen = 4 * ((len + 2) / 3);
15 
16         // Add some extra buffer at the end
17         bytes memory result = new bytes(encodedLen + 32);
18 
19         bytes memory table = TABLE;
20 
21         assembly {
22             let tablePtr := add(table, 1)
23             let resultPtr := add(result, 32)
24 
25             for {
26                 let i := 0
27             } lt(i, len) {
28 
29             } {
30                 i := add(i, 3)
31                 let input := and(mload(add(data, i)), 0xffffff)
32 
33                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
34                 out := shl(8, out)
35                 out := add(
36                     out,
37                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
38                 )
39                 out := shl(8, out)
40                 out := add(
41                     out,
42                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
43                 )
44                 out := shl(8, out)
45                 out := add(
46                     out,
47                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
48                 )
49                 out := shl(224, out)
50 
51                 mstore(resultPtr, out)
52 
53                 resultPtr := add(resultPtr, 4)
54             }
55 
56             switch mod(len, 3)
57             case 1 {
58                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
59             }
60             case 2 {
61                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
62             }
63 
64             mstore(result, encodedLen)
65         }
66 
67         return string(result);
68     }
69 
70     function decode(bytes memory data) internal pure returns (bytes memory) {
71         uint8[128] memory toInt;
72 
73         for (uint8 i = 0; i < bytes(TABLE).length; i++) {
74             toInt[uint8(bytes(TABLE)[i])] = i;
75         }
76 
77         uint256 delta;
78         uint256 len = data.length;
79         if (data[len - 2] == "=" && data[len - 1] == "=") {
80             delta = 2;
81         } else if (data[len - 1] == "=") {
82             delta = 1;
83         } else {
84             delta = 0;
85         }
86         uint256 decodedLen = (len * 3) / 4 - delta;
87         bytes memory buffer = new bytes(decodedLen);
88         uint256 index;
89         uint8 mask = 0xFF;
90 
91         for (uint256 i = 0; i < len; i += 4) {
92             uint8 c0 = toInt[uint8(data[i])];
93             uint8 c1 = toInt[uint8(data[i + 1])];
94             buffer[index++] = (bytes1)(((c0 << 2) | (c1 >> 4)) & mask);
95             if (index >= buffer.length) {
96                 return buffer;
97             }
98             uint8 c2 = toInt[uint8(data[i + 2])];
99             buffer[index++] = (bytes1)(((c1 << 4) | (c2 >> 2)) & mask);
100             if (index >= buffer.length) {
101                 return buffer;
102             }
103             uint8 c3 = toInt[uint8(data[i + 3])];
104             buffer[index++] = (bytes1)(((c2 << 6) | c3) & mask);
105         }
106         return buffer;
107     }
108 }
109 
110 
111 interface DateTimeAPI {
112     /*
113      *  Abstract contract for interfacing with the DateTime contract.
114      *
115      */
116     function isLeapYear(uint16 year) external returns (bool);
117 
118     function getYear(uint256 timestamp) external returns (uint16);
119 
120     function getMonth(uint256 timestamp) external returns (uint8);
121 
122     function getDay(uint256 timestamp) external returns (uint8);
123 
124     function getHour(uint256 timestamp) external returns (uint8);
125 
126     function getMinute(uint256 timestamp) external returns (uint8);
127 
128     function getSecond(uint256 timestamp) external returns (uint8);
129 
130     function getWeekday(uint256 timestamp) external returns (uint8);
131 
132     function toTimestamp(
133         uint16 year,
134         uint8 month,
135         uint8 day
136     ) external returns (uint256 timestamp);
137 
138     function toTimestamp(
139         uint16 year,
140         uint8 month,
141         uint8 day,
142         uint8 hour
143     ) external returns (uint256 timestamp);
144 
145     function toTimestamp(
146         uint16 year,
147         uint8 month,
148         uint8 day,
149         uint8 hour,
150         uint8 minute
151     ) external returns (uint256 timestamp);
152 
153     function toTimestamp(
154         uint16 year,
155         uint8 month,
156         uint8 day,
157         uint8 hour,
158         uint8 minute,
159         uint8 second
160     ) external returns (uint256 timestamp);
161 }
162 
163 
164 /*
165  * @title Solidity Bytes Arrays Utils
166  * @author Gonçalo Sá <goncalo.sa@consensys.net>
167  *
168  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
169  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
170  */
171 pragma solidity >=0.8.0 <0.9.0;
172 
173 
174 library BytesLib {
175     function concat(
176         bytes memory _preBytes,
177         bytes memory _postBytes
178     )
179         internal
180         pure
181         returns (bytes memory)
182     {
183         bytes memory tempBytes;
184 
185         assembly {
186             // Get a location of some free memory and store it in tempBytes as
187             // Solidity does for memory variables.
188             tempBytes := mload(0x40)
189 
190             // Store the length of the first bytes array at the beginning of
191             // the memory for tempBytes.
192             let length := mload(_preBytes)
193             mstore(tempBytes, length)
194 
195             // Maintain a memory counter for the current write location in the
196             // temp bytes array by adding the 32 bytes for the array length to
197             // the starting location.
198             let mc := add(tempBytes, 0x20)
199             // Stop copying when the memory counter reaches the length of the
200             // first bytes array.
201             let end := add(mc, length)
202 
203             for {
204                 // Initialize a copy counter to the start of the _preBytes data,
205                 // 32 bytes into its memory.
206                 let cc := add(_preBytes, 0x20)
207             } lt(mc, end) {
208                 // Increase both counters by 32 bytes each iteration.
209                 mc := add(mc, 0x20)
210                 cc := add(cc, 0x20)
211             } {
212                 // Write the _preBytes data into the tempBytes memory 32 bytes
213                 // at a time.
214                 mstore(mc, mload(cc))
215             }
216 
217             // Add the length of _postBytes to the current length of tempBytes
218             // and store it as the new length in the first 32 bytes of the
219             // tempBytes memory.
220             length := mload(_postBytes)
221             mstore(tempBytes, add(length, mload(tempBytes)))
222 
223             // Move the memory counter back from a multiple of 0x20 to the
224             // actual end of the _preBytes data.
225             mc := end
226             // Stop copying when the memory counter reaches the new combined
227             // length of the arrays.
228             end := add(mc, length)
229 
230             for {
231                 let cc := add(_postBytes, 0x20)
232             } lt(mc, end) {
233                 mc := add(mc, 0x20)
234                 cc := add(cc, 0x20)
235             } {
236                 mstore(mc, mload(cc))
237             }
238 
239             // Update the free-memory pointer by padding our last write location
240             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
241             // next 32 byte block, then round down to the nearest multiple of
242             // 32. If the sum of the length of the two arrays is zero then add
243             // one before rounding down to leave a blank 32 bytes (the length block with 0).
244             mstore(0x40, and(
245               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
246               not(31) // Round down to the nearest 32 bytes.
247             ))
248         }
249 
250         return tempBytes;
251     }
252 
253     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
254         assembly {
255             // Read the first 32 bytes of _preBytes storage, which is the length
256             // of the array. (We don't need to use the offset into the slot
257             // because arrays use the entire slot.)
258             let fslot := sload(_preBytes.slot)
259             // Arrays of 31 bytes or less have an even value in their slot,
260             // while longer arrays have an odd value. The actual length is
261             // the slot divided by two for odd values, and the lowest order
262             // byte divided by two for even values.
263             // If the slot is even, bitwise and the slot with 255 and divide by
264             // two to get the length. If the slot is odd, bitwise and the slot
265             // with -1 and divide by two.
266             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
267             let mlength := mload(_postBytes)
268             let newlength := add(slength, mlength)
269             // slength can contain both the length and contents of the array
270             // if length < 32 bytes so let's prepare for that
271             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
272             switch add(lt(slength, 32), lt(newlength, 32))
273             case 2 {
274                 // Since the new array still fits in the slot, we just need to
275                 // update the contents of the slot.
276                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
277                 sstore(
278                     _preBytes.slot,
279                     // all the modifications to the slot are inside this
280                     // next block
281                     add(
282                         // we can just add to the slot contents because the
283                         // bytes we want to change are the LSBs
284                         fslot,
285                         add(
286                             mul(
287                                 div(
288                                     // load the bytes from memory
289                                     mload(add(_postBytes, 0x20)),
290                                     // zero all bytes to the right
291                                     exp(0x100, sub(32, mlength))
292                                 ),
293                                 // and now shift left the number of bytes to
294                                 // leave space for the length in the slot
295                                 exp(0x100, sub(32, newlength))
296                             ),
297                             // increase length by the double of the memory
298                             // bytes length
299                             mul(mlength, 2)
300                         )
301                     )
302                 )
303             }
304             case 1 {
305                 // The stored value fits in the slot, but the combined value
306                 // will exceed it.
307                 // get the keccak hash to get the contents of the array
308                 mstore(0x0, _preBytes.slot)
309                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
310 
311                 // save new length
312                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
313 
314                 // The contents of the _postBytes array start 32 bytes into
315                 // the structure. Our first read should obtain the `submod`
316                 // bytes that can fit into the unused space in the last word
317                 // of the stored array. To get this, we read 32 bytes starting
318                 // from `submod`, so the data we read overlaps with the array
319                 // contents by `submod` bytes. Masking the lowest-order
320                 // `submod` bytes allows us to add that value directly to the
321                 // stored value.
322 
323                 let submod := sub(32, slength)
324                 let mc := add(_postBytes, submod)
325                 let end := add(_postBytes, mlength)
326                 let mask := sub(exp(0x100, submod), 1)
327 
328                 sstore(
329                     sc,
330                     add(
331                         and(
332                             fslot,
333                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
334                         ),
335                         and(mload(mc), mask)
336                     )
337                 )
338 
339                 for {
340                     mc := add(mc, 0x20)
341                     sc := add(sc, 1)
342                 } lt(mc, end) {
343                     sc := add(sc, 1)
344                     mc := add(mc, 0x20)
345                 } {
346                     sstore(sc, mload(mc))
347                 }
348 
349                 mask := exp(0x100, sub(mc, end))
350 
351                 sstore(sc, mul(div(mload(mc), mask), mask))
352             }
353             default {
354                 // get the keccak hash to get the contents of the array
355                 mstore(0x0, _preBytes.slot)
356                 // Start copying to the last used word of the stored array.
357                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
358 
359                 // save new length
360                 sstore(_preBytes.slot, add(mul(newlength, 2), 1))
361 
362                 // Copy over the first `submod` bytes of the new data as in
363                 // case 1 above.
364                 let slengthmod := mod(slength, 32)
365                 let mlengthmod := mod(mlength, 32)
366                 let submod := sub(32, slengthmod)
367                 let mc := add(_postBytes, submod)
368                 let end := add(_postBytes, mlength)
369                 let mask := sub(exp(0x100, submod), 1)
370 
371                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
372 
373                 for {
374                     sc := add(sc, 1)
375                     mc := add(mc, 0x20)
376                 } lt(mc, end) {
377                     sc := add(sc, 1)
378                     mc := add(mc, 0x20)
379                 } {
380                     sstore(sc, mload(mc))
381                 }
382 
383                 mask := exp(0x100, sub(mc, end))
384 
385                 sstore(sc, mul(div(mload(mc), mask), mask))
386             }
387         }
388     }
389 
390     function slice(
391         bytes memory _bytes,
392         uint256 _start,
393         uint256 _length
394     )
395         internal
396         pure
397         returns (bytes memory)
398     {
399         require(_length + 31 >= _length, "slice_overflow");
400         require(_bytes.length >= _start + _length, "slice_outOfBounds");
401 
402         bytes memory tempBytes;
403 
404         assembly {
405             switch iszero(_length)
406             case 0 {
407                 // Get a location of some free memory and store it in tempBytes as
408                 // Solidity does for memory variables.
409                 tempBytes := mload(0x40)
410 
411                 // The first word of the slice result is potentially a partial
412                 // word read from the original array. To read it, we calculate
413                 // the length of that partial word and start copying that many
414                 // bytes into the array. The first word we copy will start with
415                 // data we don't care about, but the last `lengthmod` bytes will
416                 // land at the beginning of the contents of the new array. When
417                 // we're done copying, we overwrite the full first word with
418                 // the actual length of the slice.
419                 let lengthmod := and(_length, 31)
420 
421                 // The multiplication in the next line is necessary
422                 // because when slicing multiples of 32 bytes (lengthmod == 0)
423                 // the following copy loop was copying the origin's length
424                 // and then ending prematurely not copying everything it should.
425                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
426                 let end := add(mc, _length)
427 
428                 for {
429                     // The multiplication in the next line has the same exact purpose
430                     // as the one above.
431                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
432                 } lt(mc, end) {
433                     mc := add(mc, 0x20)
434                     cc := add(cc, 0x20)
435                 } {
436                     mstore(mc, mload(cc))
437                 }
438 
439                 mstore(tempBytes, _length)
440 
441                 //update free-memory pointer
442                 //allocating the array padded to 32 bytes like the compiler does now
443                 mstore(0x40, and(add(mc, 31), not(31)))
444             }
445             //if we want a zero-length slice let's just return a zero-length array
446             default {
447                 tempBytes := mload(0x40)
448                 //zero out the 32 bytes slice we are about to return
449                 //we need to do it because Solidity does not garbage collect
450                 mstore(tempBytes, 0)
451 
452                 mstore(0x40, add(tempBytes, 0x20))
453             }
454         }
455 
456         return tempBytes;
457     }
458 
459     function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
460         require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
461         address tempAddress;
462 
463         assembly {
464             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
465         }
466 
467         return tempAddress;
468     }
469 
470     function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
471         require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
472         uint8 tempUint;
473 
474         assembly {
475             tempUint := mload(add(add(_bytes, 0x1), _start))
476         }
477 
478         return tempUint;
479     }
480 
481     function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
482         require(_bytes.length >= _start + 2, "toUint16_outOfBounds");
483         uint16 tempUint;
484 
485         assembly {
486             tempUint := mload(add(add(_bytes, 0x2), _start))
487         }
488 
489         return tempUint;
490     }
491 
492     function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
493         require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
494         uint32 tempUint;
495 
496         assembly {
497             tempUint := mload(add(add(_bytes, 0x4), _start))
498         }
499 
500         return tempUint;
501     }
502 
503     function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
504         require(_bytes.length >= _start + 8, "toUint64_outOfBounds");
505         uint64 tempUint;
506 
507         assembly {
508             tempUint := mload(add(add(_bytes, 0x8), _start))
509         }
510 
511         return tempUint;
512     }
513 
514     function toUint96(bytes memory _bytes, uint256 _start) internal pure returns (uint96) {
515         require(_bytes.length >= _start + 12, "toUint96_outOfBounds");
516         uint96 tempUint;
517 
518         assembly {
519             tempUint := mload(add(add(_bytes, 0xc), _start))
520         }
521 
522         return tempUint;
523     }
524 
525     function toUint128(bytes memory _bytes, uint256 _start) internal pure returns (uint128) {
526         require(_bytes.length >= _start + 16, "toUint128_outOfBounds");
527         uint128 tempUint;
528 
529         assembly {
530             tempUint := mload(add(add(_bytes, 0x10), _start))
531         }
532 
533         return tempUint;
534     }
535 
536     function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
537         require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
538         uint256 tempUint;
539 
540         assembly {
541             tempUint := mload(add(add(_bytes, 0x20), _start))
542         }
543 
544         return tempUint;
545     }
546 
547     function toBytes32(bytes memory _bytes, uint256 _start) internal pure returns (bytes32) {
548         require(_bytes.length >= _start + 32, "toBytes32_outOfBounds");
549         bytes32 tempBytes32;
550 
551         assembly {
552             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
553         }
554 
555         return tempBytes32;
556     }
557 
558     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
559         bool success = true;
560 
561         assembly {
562             let length := mload(_preBytes)
563 
564             // if lengths don't match the arrays are not equal
565             switch eq(length, mload(_postBytes))
566             case 1 {
567                 // cb is a circuit breaker in the for loop since there's
568                 //  no said feature for inline assembly loops
569                 // cb = 1 - don't breaker
570                 // cb = 0 - break
571                 let cb := 1
572 
573                 let mc := add(_preBytes, 0x20)
574                 let end := add(mc, length)
575 
576                 for {
577                     let cc := add(_postBytes, 0x20)
578                 // the next line is the loop condition:
579                 // while(uint256(mc < end) + cb == 2)
580                 } eq(add(lt(mc, end), cb), 2) {
581                     mc := add(mc, 0x20)
582                     cc := add(cc, 0x20)
583                 } {
584                     // if any of these checks fails then arrays are not equal
585                     if iszero(eq(mload(mc), mload(cc))) {
586                         // unsuccess:
587                         success := 0
588                         cb := 0
589                     }
590                 }
591             }
592             default {
593                 // unsuccess:
594                 success := 0
595             }
596         }
597 
598         return success;
599     }
600 
601     function equalStorage(
602         bytes storage _preBytes,
603         bytes memory _postBytes
604     )
605         internal
606         view
607         returns (bool)
608     {
609         bool success = true;
610 
611         assembly {
612             // we know _preBytes_offset is 0
613             let fslot := sload(_preBytes.slot)
614             // Decode the length of the stored array like in concatStorage().
615             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
616             let mlength := mload(_postBytes)
617 
618             // if lengths don't match the arrays are not equal
619             switch eq(slength, mlength)
620             case 1 {
621                 // slength can contain both the length and contents of the array
622                 // if length < 32 bytes so let's prepare for that
623                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
624                 if iszero(iszero(slength)) {
625                     switch lt(slength, 32)
626                     case 1 {
627                         // blank the last byte which is the length
628                         fslot := mul(div(fslot, 0x100), 0x100)
629 
630                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
631                             // unsuccess:
632                             success := 0
633                         }
634                     }
635                     default {
636                         // cb is a circuit breaker in the for loop since there's
637                         //  no said feature for inline assembly loops
638                         // cb = 1 - don't breaker
639                         // cb = 0 - break
640                         let cb := 1
641 
642                         // get the keccak hash to get the contents of the array
643                         mstore(0x0, _preBytes.slot)
644                         let sc := keccak256(0x0, 0x20)
645 
646                         let mc := add(_postBytes, 0x20)
647                         let end := add(mc, mlength)
648 
649                         // the next line is the loop condition:
650                         // while(uint256(mc < end) + cb == 2)
651                         for {} eq(add(lt(mc, end), cb), 2) {
652                             sc := add(sc, 1)
653                             mc := add(mc, 0x20)
654                         } {
655                             if iszero(eq(sload(sc), mload(mc))) {
656                                 // unsuccess:
657                                 success := 0
658                                 cb := 0
659                             }
660                         }
661                     }
662                 }
663             }
664             default {
665                 // unsuccess:
666                 success := 0
667             }
668         }
669 
670         return success;
671     }
672 }
673 
674 
675 library Bytecode {
676   error InvalidCodeAtRange(uint256 _size, uint256 _start, uint256 _end);
677 
678   /**
679     @notice Generate a creation code that results on a contract with `_code` as bytecode
680     @param _code The returning value of the resulting `creationCode`
681     @return creationCode (constructor) for new contract
682   */
683   function creationCodeFor(bytes memory _code) internal pure returns (bytes memory) {
684     /*
685       0x00    0x63         0x63XXXXXX  PUSH4 _code.length  size
686       0x01    0x80         0x80        DUP1                size size
687       0x02    0x60         0x600e      PUSH1 14            14 size size
688       0x03    0x60         0x6000      PUSH1 00            0 14 size size
689       0x04    0x39         0x39        CODECOPY            size
690       0x05    0x60         0x6000      PUSH1 00            0 size
691       0x06    0xf3         0xf3        RETURN
692       <CODE>
693     */
694 
695     return abi.encodePacked(
696       hex"63",
697       uint32(_code.length),
698       hex"80_60_0E_60_00_39_60_00_F3",
699       _code
700     );
701   }
702 
703   /**
704     @notice Returns the size of the code on a given address
705     @param _addr Address that may or may not contain code
706     @return size of the code on the given `_addr`
707   */
708   function codeSize(address _addr) internal view returns (uint256 size) {
709     assembly { size := extcodesize(_addr) }
710   }
711 
712   /**
713     @notice Returns the code of a given address
714     @dev It will fail if `_end < _start`
715     @param _addr Address that may or may not contain code
716     @param _start number of bytes of code to skip on read
717     @param _end index before which to end extraction
718     @return oCode read from `_addr` deployed bytecode
719 
720     Forked from: https://gist.github.com/KardanovIR/fe98661df9338c842b4a30306d507fbd
721   */
722   function codeAt(address _addr, uint256 _start, uint256 _end) internal view returns (bytes memory oCode) {
723     uint256 csize = codeSize(_addr);
724     if (csize == 0) return bytes("");
725 
726     if (_start > csize) return bytes("");
727     if (_end < _start) revert InvalidCodeAtRange(csize, _start, _end); 
728 
729     unchecked {
730       uint256 reqSize = _end - _start;
731       uint256 maxSize = csize - _start;
732 
733       uint256 size = maxSize < reqSize ? maxSize : reqSize;
734 
735       assembly {
736         // allocate output byte array - this could also be done without assembly
737         // by using o_code = new bytes(size)
738         oCode := mload(0x40)
739         // new "memory end" including padding
740         mstore(0x40, add(oCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
741         // store length in memory
742         mstore(oCode, size)
743         // actually retrieve the code, this needs assembly
744         extcodecopy(_addr, add(oCode, 0x20), _start, size)
745       }
746     }
747   }
748 }
749 
750 
751 /**
752   @title A key-value storage with auto-generated keys for storing chunks of data with a lower write & read cost.
753   @author Agustin Aguilar <aa@horizon.io>
754 
755   Readme: https://github.com/0xsequence/sstore2#readme
756 */
757 library SSTORE2 {
758   error WriteError();
759 
760   /**
761     @notice Stores `_data` and returns `pointer` as key for later retrieval
762     @dev The pointer is a contract address with `_data` as code
763     @param _data to be written
764     @return pointer Pointer to the written `_data`
765   */
766   function write(bytes memory _data) internal returns (address pointer) {
767     // Append 00 to _data so contract can't be called
768     // Build init code
769     bytes memory code = Bytecode.creationCodeFor(
770       abi.encodePacked(
771         hex'00',
772         _data
773       )
774     );
775 
776     // Deploy contract using create
777     assembly { pointer := create(0, add(code, 32), mload(code)) }
778 
779     // Address MUST be non-zero
780     if (pointer == address(0)) revert WriteError();
781   }
782 
783   /**
784     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
785     @dev The function is intended for reading pointers generated by `write`
786     @param _pointer to be read
787     @return data read from `_pointer` contract
788   */
789   function read(address _pointer) internal view returns (bytes memory) {
790     return Bytecode.codeAt(_pointer, 1, type(uint256).max);
791   }
792 
793   /**
794     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
795     @dev The function is intended for reading pointers generated by `write`
796     @param _pointer to be read
797     @param _start number of bytes to skip
798     @return data read from `_pointer` contract
799   */
800   function read(address _pointer, uint256 _start) internal view returns (bytes memory) {
801     return Bytecode.codeAt(_pointer, _start + 1, type(uint256).max);
802   }
803 
804   /**
805     @notice Reads the contents of the `_pointer` code as data, skips the first byte 
806     @dev The function is intended for reading pointers generated by `write`
807     @param _pointer to be read
808     @param _start number of bytes to skip
809     @param _end index before which to end extraction
810     @return data read from `_pointer` contract
811   */
812   function read(address _pointer, uint256 _start, uint256 _end) internal view returns (bytes memory) {
813     return Bytecode.codeAt(_pointer, _start + 1, _end + 1);
814   }
815 }
816 
817 
818 /**
819  * @dev These functions deal with verification of Merkle Trees proofs.
820  *
821  * The proofs can be generated using the JavaScript library
822  * https://github.com/miguelmota/merkletreejs[merkletreejs].
823  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
824  *
825  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
826  *
827  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
828  * hashing, or use a hash function other than keccak256 for hashing leaves.
829  * This is because the concatenation of a sorted pair of internal nodes in
830  * the merkle tree could be reinterpreted as a leaf value.
831  */
832 library MerkleProof {
833     /**
834      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
835      * defined by `root`. For this, a `proof` must be provided, containing
836      * sibling hashes on the branch from the leaf to the root of the tree. Each
837      * pair of leaves and each pair of pre-images are assumed to be sorted.
838      */
839     function verify(
840         bytes32[] memory proof,
841         bytes32 root,
842         bytes32 leaf
843     ) internal pure returns (bool) {
844         return processProof(proof, leaf) == root;
845     }
846 
847     /**
848      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
849      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
850      * hash matches the root of the tree. When processing the proof, the pairs
851      * of leafs & pre-images are assumed to be sorted.
852      *
853      * _Available since v4.4._
854      */
855     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
856         bytes32 computedHash = leaf;
857         for (uint256 i = 0; i < proof.length; i++) {
858             bytes32 proofElement = proof[i];
859             if (computedHash <= proofElement) {
860                 // Hash(current computed hash + current element of the proof)
861                 computedHash = _efficientHash(computedHash, proofElement);
862             } else {
863                 // Hash(current element of the proof + current computed hash)
864                 computedHash = _efficientHash(proofElement, computedHash);
865             }
866         }
867         return computedHash;
868     }
869 
870     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
871         assembly {
872             mstore(0x00, a)
873             mstore(0x20, b)
874             value := keccak256(0x00, 0x40)
875         }
876     }
877 }
878 
879 
880 /**
881  * @dev Collection of functions related to the address type
882  */
883 library Address {
884     /**
885      * @dev Returns true if `account` is a contract.
886      *
887      * [IMPORTANT]
888      * ====
889      * It is unsafe to assume that an address for which this function returns
890      * false is an externally-owned account (EOA) and not a contract.
891      *
892      * Among others, `isContract` will return false for the following
893      * types of addresses:
894      *
895      *  - an externally-owned account
896      *  - a contract in construction
897      *  - an address where a contract will be created
898      *  - an address where a contract lived, but was destroyed
899      * ====
900      *
901      * [IMPORTANT]
902      * ====
903      * You shouldn't rely on `isContract` to protect against flash loan attacks!
904      *
905      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
906      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
907      * constructor.
908      * ====
909      */
910     function isContract(address account) internal view returns (bool) {
911         // This method relies on extcodesize/address.code.length, which returns 0
912         // for contracts in construction, since the code is only stored at the end
913         // of the constructor execution.
914 
915         return account.code.length > 0;
916     }
917 
918     /**
919      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
920      * `recipient`, forwarding all available gas and reverting on errors.
921      *
922      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
923      * of certain opcodes, possibly making contracts go over the 2300 gas limit
924      * imposed by `transfer`, making them unable to receive funds via
925      * `transfer`. {sendValue} removes this limitation.
926      *
927      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
928      *
929      * IMPORTANT: because control is transferred to `recipient`, care must be
930      * taken to not create reentrancy vulnerabilities. Consider using
931      * {ReentrancyGuard} or the
932      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
933      */
934     function sendValue(address payable recipient, uint256 amount) internal {
935         require(address(this).balance >= amount, "Address: insufficient balance");
936 
937         (bool success, ) = recipient.call{value: amount}("");
938         require(success, "Address: unable to send value, recipient may have reverted");
939     }
940 
941     /**
942      * @dev Performs a Solidity function call using a low level `call`. A
943      * plain `call` is an unsafe replacement for a function call: use this
944      * function instead.
945      *
946      * If `target` reverts with a revert reason, it is bubbled up by this
947      * function (like regular Solidity function calls).
948      *
949      * Returns the raw returned data. To convert to the expected return value,
950      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
951      *
952      * Requirements:
953      *
954      * - `target` must be a contract.
955      * - calling `target` with `data` must not revert.
956      *
957      * _Available since v3.1._
958      */
959     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
960         return functionCall(target, data, "Address: low-level call failed");
961     }
962 
963     /**
964      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
965      * `errorMessage` as a fallback revert reason when `target` reverts.
966      *
967      * _Available since v3.1._
968      */
969     function functionCall(
970         address target,
971         bytes memory data,
972         string memory errorMessage
973     ) internal returns (bytes memory) {
974         return functionCallWithValue(target, data, 0, errorMessage);
975     }
976 
977     /**
978      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
979      * but also transferring `value` wei to `target`.
980      *
981      * Requirements:
982      *
983      * - the calling contract must have an ETH balance of at least `value`.
984      * - the called Solidity function must be `payable`.
985      *
986      * _Available since v3.1._
987      */
988     function functionCallWithValue(
989         address target,
990         bytes memory data,
991         uint256 value
992     ) internal returns (bytes memory) {
993         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
994     }
995 
996     /**
997      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
998      * with `errorMessage` as a fallback revert reason when `target` reverts.
999      *
1000      * _Available since v3.1._
1001      */
1002     function functionCallWithValue(
1003         address target,
1004         bytes memory data,
1005         uint256 value,
1006         string memory errorMessage
1007     ) internal returns (bytes memory) {
1008         require(address(this).balance >= value, "Address: insufficient balance for call");
1009         require(isContract(target), "Address: call to non-contract");
1010 
1011         (bool success, bytes memory returndata) = target.call{value: value}(data);
1012         return verifyCallResult(success, returndata, errorMessage);
1013     }
1014 
1015     /**
1016      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1017      * but performing a static call.
1018      *
1019      * _Available since v3.3._
1020      */
1021     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1022         return functionStaticCall(target, data, "Address: low-level static call failed");
1023     }
1024 
1025     /**
1026      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1027      * but performing a static call.
1028      *
1029      * _Available since v3.3._
1030      */
1031     function functionStaticCall(
1032         address target,
1033         bytes memory data,
1034         string memory errorMessage
1035     ) internal view returns (bytes memory) {
1036         require(isContract(target), "Address: static call to non-contract");
1037 
1038         (bool success, bytes memory returndata) = target.staticcall(data);
1039         return verifyCallResult(success, returndata, errorMessage);
1040     }
1041 
1042     /**
1043      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1044      * but performing a delegate call.
1045      *
1046      * _Available since v3.4._
1047      */
1048     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1049         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1050     }
1051 
1052     /**
1053      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1054      * but performing a delegate call.
1055      *
1056      * _Available since v3.4._
1057      */
1058     function functionDelegateCall(
1059         address target,
1060         bytes memory data,
1061         string memory errorMessage
1062     ) internal returns (bytes memory) {
1063         require(isContract(target), "Address: delegate call to non-contract");
1064 
1065         (bool success, bytes memory returndata) = target.delegatecall(data);
1066         return verifyCallResult(success, returndata, errorMessage);
1067     }
1068 
1069     /**
1070      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1071      * revert reason using the provided one.
1072      *
1073      * _Available since v4.3._
1074      */
1075     function verifyCallResult(
1076         bool success,
1077         bytes memory returndata,
1078         string memory errorMessage
1079     ) internal pure returns (bytes memory) {
1080         if (success) {
1081             return returndata;
1082         } else {
1083             // Look for revert reason and bubble it up if present
1084             if (returndata.length > 0) {
1085                 // The easiest way to bubble the revert reason is using memory via assembly
1086 
1087                 assembly {
1088                     let returndata_size := mload(returndata)
1089                     revert(add(32, returndata), returndata_size)
1090                 }
1091             } else {
1092                 revert(errorMessage);
1093             }
1094         }
1095     }
1096 }
1097 
1098 /**
1099  * @dev String operations.
1100  */
1101 library Strings {
1102     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1103 
1104     /**
1105      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1106      */
1107     function toString(uint256 value) internal pure returns (string memory) {
1108         // Inspired by OraclizeAPI's implementation - MIT licence
1109         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1110 
1111         if (value == 0) {
1112             return "0";
1113         }
1114         uint256 temp = value;
1115         uint256 digits;
1116         while (temp != 0) {
1117             digits++;
1118             temp /= 10;
1119         }
1120         bytes memory buffer = new bytes(digits);
1121         while (value != 0) {
1122             digits -= 1;
1123             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1124             value /= 10;
1125         }
1126         return string(buffer);
1127     }
1128 
1129     /**
1130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1131      */
1132     function toHexString(uint256 value) internal pure returns (string memory) {
1133         if (value == 0) {
1134             return "0x00";
1135         }
1136         uint256 temp = value;
1137         uint256 length = 0;
1138         while (temp != 0) {
1139             length++;
1140             temp >>= 8;
1141         }
1142         return toHexString(value, length);
1143     }
1144 
1145     /**
1146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1147      */
1148     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1149         bytes memory buffer = new bytes(2 * length + 2);
1150         buffer[0] = "0";
1151         buffer[1] = "x";
1152         for (uint256 i = 2 * length + 1; i > 1; --i) {
1153             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1154             value >>= 4;
1155         }
1156         require(value == 0, "Strings: hex length insufficient");
1157         return string(buffer);
1158     }
1159 }
1160 
1161 /**
1162  * @dev Interface of the ERC165 standard, as defined in the
1163  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1164  *
1165  * Implementers can declare support of contract interfaces, which can then be
1166  * queried by others ({ERC165Checker}).
1167  *
1168  * For an implementation, see {ERC165}.
1169  */
1170 interface IERC165 {
1171     /**
1172      * @dev Returns true if this contract implements the interface defined by
1173      * `interfaceId`. See the corresponding
1174      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1175      * to learn more about how these ids are created.
1176      *
1177      * This function call must use less than 30 000 gas.
1178      */
1179     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1180 }
1181 
1182 
1183 /**
1184  * @dev Implementation of the {IERC165} interface.
1185  *
1186  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1187  * for the additional interface id that will be supported. For example:
1188  *
1189  * ```solidity
1190  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1191  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1192  * }
1193  * ```
1194  *
1195  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1196  */
1197 abstract contract ERC165 is IERC165 {
1198     /**
1199      * @dev See {IERC165-supportsInterface}.
1200      */
1201     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1202         return interfaceId == type(IERC165).interfaceId;
1203     }
1204 }
1205 
1206 
1207 
1208 /**
1209  * @dev Interface for the NFT Royalty Standard.
1210  *
1211  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1212  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1213  *
1214  * _Available since v4.5._
1215  */
1216 interface IERC2981 is IERC165 {
1217     /**
1218      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1219      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1220      */
1221     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1222         external
1223         view
1224         returns (address receiver, uint256 royaltyAmount);
1225 }
1226 
1227 /**
1228  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1229  *
1230  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1231  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1232  *
1233  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1234  * fee is specified in basis points by default.
1235  *
1236  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1237  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1238  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1239  *
1240  * _Available since v4.5._
1241  */
1242 abstract contract ERC2981 is IERC2981, ERC165 {
1243     struct RoyaltyInfo {
1244         address receiver;
1245         uint96 royaltyFraction;
1246     }
1247 
1248     RoyaltyInfo private _defaultRoyaltyInfo;
1249     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1250 
1251     /**
1252      * @dev See {IERC165-supportsInterface}.
1253      */
1254     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1255         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1256     }
1257 
1258     /**
1259      * @inheritdoc IERC2981
1260      */
1261     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1262         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1263 
1264         if (royalty.receiver == address(0)) {
1265             royalty = _defaultRoyaltyInfo;
1266         }
1267 
1268         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1269 
1270         return (royalty.receiver, royaltyAmount);
1271     }
1272 
1273     /**
1274      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1275      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1276      * override.
1277      */
1278     function _feeDenominator() internal pure virtual returns (uint96) {
1279         return 10000;
1280     }
1281 
1282     /**
1283      * @dev Sets the royalty information that all ids in this contract will default to.
1284      *
1285      * Requirements:
1286      *
1287      * - `receiver` cannot be the zero address.
1288      * - `feeNumerator` cannot be greater than the fee denominator.
1289      */
1290     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1291         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1292         require(receiver != address(0), "ERC2981: invalid receiver");
1293 
1294         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1295     }
1296 
1297     /**
1298      * @dev Removes default royalty information.
1299      */
1300     function _deleteDefaultRoyalty() internal virtual {
1301         delete _defaultRoyaltyInfo;
1302     }
1303 
1304     /**
1305      * @dev Sets the royalty information for a specific token id, overriding the global default.
1306      *
1307      * Requirements:
1308      *
1309      * - `tokenId` must be already minted.
1310      * - `receiver` cannot be the zero address.
1311      * - `feeNumerator` cannot be greater than the fee denominator.
1312      */
1313     function _setTokenRoyalty(
1314         uint256 tokenId,
1315         address receiver,
1316         uint96 feeNumerator
1317     ) internal virtual {
1318         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1319         require(receiver != address(0), "ERC2981: Invalid parameters");
1320 
1321         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1322     }
1323 
1324     /**
1325      * @dev Resets royalty information for the token id back to the global default.
1326      */
1327     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1328         delete _tokenRoyaltyInfo[tokenId];
1329     }
1330 }
1331 
1332 
1333 
1334 // SPDX-License-Identifier: MIT
1335 // ERC721A Contracts v4.0.0
1336 // Creator: Chiru Labs
1337 
1338 /**
1339  * @dev Interface of an ERC721A compliant contract.
1340  */
1341 interface IERC721A {
1342     /**
1343      * The caller must own the token or be an approved operator.
1344      */
1345     error ApprovalCallerNotOwnerNorApproved();
1346 
1347     /**
1348      * The token does not exist.
1349      */
1350     error ApprovalQueryForNonexistentToken();
1351 
1352     /**
1353      * The caller cannot approve to their own address.
1354      */
1355     error ApproveToCaller();
1356 
1357     /**
1358      * The caller cannot approve to the current owner.
1359      */
1360     error ApprovalToCurrentOwner();
1361 
1362     /**
1363      * Cannot query the balance for the zero address.
1364      */
1365     error BalanceQueryForZeroAddress();
1366 
1367     /**
1368      * Cannot mint to the zero address.
1369      */
1370     error MintToZeroAddress();
1371 
1372     /**
1373      * The quantity of tokens minted must be more than zero.
1374      */
1375     error MintZeroQuantity();
1376 
1377     /**
1378      * The token does not exist.
1379      */
1380     error OwnerQueryForNonexistentToken();
1381 
1382     /**
1383      * The caller must own the token or be an approved operator.
1384      */
1385     error TransferCallerNotOwnerNorApproved();
1386 
1387     /**
1388      * The token must be owned by `from`.
1389      */
1390     error TransferFromIncorrectOwner();
1391 
1392     /**
1393      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1394      */
1395     error TransferToNonERC721ReceiverImplementer();
1396 
1397     /**
1398      * Cannot transfer to the zero address.
1399      */
1400     error TransferToZeroAddress();
1401 
1402     /**
1403      * The token does not exist.
1404      */
1405     error URIQueryForNonexistentToken();
1406 
1407     struct TokenOwnership {
1408         // The address of the owner.
1409         address addr;
1410         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1411         uint64 startTimestamp;
1412         // Whether the token has been burned.
1413         bool burned;
1414     }
1415 
1416     /**
1417      * @dev Returns the total amount of tokens stored by the contract.
1418      *
1419      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1420      */
1421     function totalSupply() external view returns (uint256);
1422 
1423     // ==============================
1424     //            IERC165
1425     // ==============================
1426 
1427     /**
1428      * @dev Returns true if this contract implements the interface defined by
1429      * `interfaceId`. See the corresponding
1430      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1431      * to learn more about how these ids are created.
1432      *
1433      * This function call must use less than 30 000 gas.
1434      */
1435     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1436 
1437     // ==============================
1438     //            IERC721
1439     // ==============================
1440 
1441     /**
1442      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1443      */
1444     event Transfer(
1445         address indexed from,
1446         address indexed to,
1447         uint256 indexed tokenId
1448     );
1449 
1450     /**
1451      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1452      */
1453     event Approval(
1454         address indexed owner,
1455         address indexed approved,
1456         uint256 indexed tokenId
1457     );
1458 
1459     /**
1460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1461      */
1462     event ApprovalForAll(
1463         address indexed owner,
1464         address indexed operator,
1465         bool approved
1466     );
1467 
1468     /**
1469      * @dev Returns the number of tokens in ``owner``'s account.
1470      */
1471     function balanceOf(address owner) external view returns (uint256 balance);
1472 
1473     /**
1474      * @dev Returns the owner of the `tokenId` token.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      */
1480     function ownerOf(uint256 tokenId) external view returns (address owner);
1481 
1482     /**
1483      * @dev Safely transfers `tokenId` token from `from` to `to`.
1484      *
1485      * Requirements:
1486      *
1487      * - `from` cannot be the zero address.
1488      * - `to` cannot be the zero address.
1489      * - `tokenId` token must exist and be owned by `from`.
1490      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1491      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1492      *
1493      * Emits a {Transfer} event.
1494      */
1495     function safeTransferFrom(
1496         address from,
1497         address to,
1498         uint256 tokenId,
1499         bytes calldata data
1500     ) external;
1501 
1502     /**
1503      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1504      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1505      *
1506      * Requirements:
1507      *
1508      * - `from` cannot be the zero address.
1509      * - `to` cannot be the zero address.
1510      * - `tokenId` token must exist and be owned by `from`.
1511      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1512      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1513      *
1514      * Emits a {Transfer} event.
1515      */
1516     function safeTransferFrom(
1517         address from,
1518         address to,
1519         uint256 tokenId
1520     ) external;
1521 
1522     /**
1523      * @dev Transfers `tokenId` token from `from` to `to`.
1524      *
1525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1526      *
1527      * Requirements:
1528      *
1529      * - `from` cannot be the zero address.
1530      * - `to` cannot be the zero address.
1531      * - `tokenId` token must be owned by `from`.
1532      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function transferFrom(
1537         address from,
1538         address to,
1539         uint256 tokenId
1540     ) external;
1541 
1542     /**
1543      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1544      * The approval is cleared when the token is transferred.
1545      *
1546      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1547      *
1548      * Requirements:
1549      *
1550      * - The caller must own the token or be an approved operator.
1551      * - `tokenId` must exist.
1552      *
1553      * Emits an {Approval} event.
1554      */
1555     function approve(address to, uint256 tokenId) external;
1556 
1557     /**
1558      * @dev Approve or remove `operator` as an operator for the caller.
1559      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1560      *
1561      * Requirements:
1562      *
1563      * - The `operator` cannot be the caller.
1564      *
1565      * Emits an {ApprovalForAll} event.
1566      */
1567     function setApprovalForAll(address operator, bool _approved) external;
1568 
1569     /**
1570      * @dev Returns the account approved for `tokenId` token.
1571      *
1572      * Requirements:
1573      *
1574      * - `tokenId` must exist.
1575      */
1576     function getApproved(uint256 tokenId)
1577         external
1578         view
1579         returns (address operator);
1580 
1581     /**
1582      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1583      *
1584      * See {setApprovalForAll}
1585      */
1586     function isApprovedForAll(address owner, address operator)
1587         external
1588         view
1589         returns (bool);
1590 
1591     // ==============================
1592     //        IERC721Metadata
1593     // ==============================
1594 
1595     /**
1596      * @dev Returns the token collection name.
1597      */
1598     function name() external view returns (string memory);
1599 
1600     /**
1601      * @dev Returns the token collection symbol.
1602      */
1603     function symbol() external view returns (string memory);
1604 
1605     /**
1606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1607      */
1608     function tokenURI(uint256 tokenId) external view returns (string memory);
1609 }
1610 
1611 
1612 /**
1613  * @dev ERC721 token receiver interface.
1614  */
1615 interface ERC721A__IERC721Receiver {
1616     function onERC721Received(
1617         address operator,
1618         address from,
1619         uint256 tokenId,
1620         bytes calldata data
1621     ) external returns (bytes4);
1622 }
1623 
1624 /**
1625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1626  * the Metadata extension. Built to optimize for lower gas during batch mints.
1627  *
1628  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1629  *
1630  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1631  *
1632  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1633  */
1634 contract ERC721A is IERC721A {
1635     // Mask of an entry in packed address data.
1636     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1637 
1638     // The bit position of `numberMinted` in packed address data.
1639     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1640 
1641     // The bit position of `numberBurned` in packed address data.
1642     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1643 
1644     // The bit position of `aux` in packed address data.
1645     uint256 private constant BITPOS_AUX = 192;
1646 
1647     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1648     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1649 
1650     // The bit position of `startTimestamp` in packed ownership.
1651     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1652 
1653     // The bit mask of the `burned` bit in packed ownership.
1654     uint256 private constant BITMASK_BURNED = 1 << 224;
1655 
1656     // The bit position of the `nextInitialized` bit in packed ownership.
1657     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1658 
1659     // The bit mask of the `nextInitialized` bit in packed ownership.
1660     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1661 
1662     // The tokenId of the next token to be minted.
1663     uint256 private _currentIndex;
1664 
1665     // The number of tokens burned.
1666     uint256 private _burnCounter;
1667 
1668     // Token name
1669     string private _name;
1670 
1671     // Token symbol
1672     string private _symbol;
1673 
1674     // Mapping from token ID to ownership details
1675     // An empty struct value does not necessarily mean the token is unowned.
1676     // See `_packedOwnershipOf` implementation for details.
1677     //
1678     // Bits Layout:
1679     // - [0..159]   `addr`
1680     // - [160..223] `startTimestamp`
1681     // - [224]      `burned`
1682     // - [225]      `nextInitialized`
1683     mapping(uint256 => uint256) private _packedOwnerships;
1684 
1685     // Mapping owner address to address data.
1686     //
1687     // Bits Layout:
1688     // - [0..63]    `balance`
1689     // - [64..127]  `numberMinted`
1690     // - [128..191] `numberBurned`
1691     // - [192..255] `aux`
1692     mapping(address => uint256) private _packedAddressData;
1693 
1694     // Mapping from token ID to approved address.
1695     mapping(uint256 => address) private _tokenApprovals;
1696 
1697     // Mapping from owner to operator approvals
1698     mapping(address => mapping(address => bool)) private _operatorApprovals;
1699 
1700     constructor(string memory name_, string memory symbol_) {
1701         _name = name_;
1702         _symbol = symbol_;
1703         _currentIndex = _startTokenId();
1704     }
1705 
1706     /**
1707      * @dev Returns the starting token ID.
1708      * To change the starting token ID, please override this function.
1709      */
1710     function _startTokenId() internal view virtual returns (uint256) {
1711         return 0;
1712     }
1713 
1714     /**
1715      * @dev Returns the next token ID to be minted.
1716      */
1717     function _nextTokenId() internal view returns (uint256) {
1718         return _currentIndex;
1719     }
1720 
1721     /**
1722      * @dev Returns the total number of tokens in existence.
1723      * Burned tokens will reduce the count.
1724      * To get the total number of tokens minted, please see `_totalMinted`.
1725      */
1726     function totalSupply() public view override returns (uint256) {
1727         // Counter underflow is impossible as _burnCounter cannot be incremented
1728         // more than `_currentIndex - _startTokenId()` times.
1729         unchecked {
1730             return _currentIndex - _burnCounter - _startTokenId();
1731         }
1732     }
1733 
1734     /**
1735      * @dev Returns the total amount of tokens minted in the contract.
1736      */
1737     function _totalMinted() internal view returns (uint256) {
1738         // Counter underflow is impossible as _currentIndex does not decrement,
1739         // and it is initialized to `_startTokenId()`
1740         unchecked {
1741             return _currentIndex - _startTokenId();
1742         }
1743     }
1744 
1745     /**
1746      * @dev Returns the total number of tokens burned.
1747      */
1748     function _totalBurned() internal view returns (uint256) {
1749         return _burnCounter;
1750     }
1751 
1752     /**
1753      * @dev See {IERC165-supportsInterface}.
1754      */
1755     function supportsInterface(bytes4 interfaceId)
1756         public
1757         view
1758         virtual
1759         override
1760         returns (bool)
1761     {
1762         // The interface IDs are constants representing the first 4 bytes of the XOR of
1763         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1764         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1765         return
1766             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1767             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1768             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1769     }
1770 
1771     /**
1772      * @dev See {IERC721-balanceOf}.
1773      */
1774     function balanceOf(address owner) public view override returns (uint256) {
1775         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1776         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1777     }
1778 
1779     /**
1780      * Returns the number of tokens minted by `owner`.
1781      */
1782     function _numberMinted(address owner) internal view returns (uint256) {
1783         return
1784             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
1785             BITMASK_ADDRESS_DATA_ENTRY;
1786     }
1787 
1788     /**
1789      * Returns the number of tokens burned by or on behalf of `owner`.
1790      */
1791     function _numberBurned(address owner) internal view returns (uint256) {
1792         return
1793             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
1794             BITMASK_ADDRESS_DATA_ENTRY;
1795     }
1796 
1797     /**
1798      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1799      */
1800     function _getAux(address owner) internal view returns (uint64) {
1801         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1802     }
1803 
1804     /**
1805      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1806      * If there are multiple variables, please pack them into a uint64.
1807      */
1808     function _setAux(address owner, uint64 aux) internal {
1809         uint256 packed = _packedAddressData[owner];
1810         uint256 auxCasted;
1811         assembly {
1812             // Cast aux without masking.
1813             auxCasted := aux
1814         }
1815         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1816         _packedAddressData[owner] = packed;
1817     }
1818 
1819     /**
1820      * Returns the packed ownership data of `tokenId`.
1821      */
1822     function _packedOwnershipOf(uint256 tokenId)
1823         private
1824         view
1825         returns (uint256)
1826     {
1827         uint256 curr = tokenId;
1828 
1829         unchecked {
1830             if (_startTokenId() <= curr)
1831                 if (curr < _currentIndex) {
1832                     uint256 packed = _packedOwnerships[curr];
1833                     // If not burned.
1834                     if (packed & BITMASK_BURNED == 0) {
1835                         // Invariant:
1836                         // There will always be an ownership that has an address and is not burned
1837                         // before an ownership that does not have an address and is not burned.
1838                         // Hence, curr will not underflow.
1839                         //
1840                         // We can directly compare the packed value.
1841                         // If the address is zero, packed is zero.
1842                         while (packed == 0) {
1843                             packed = _packedOwnerships[--curr];
1844                         }
1845                         return packed;
1846                     }
1847                 }
1848         }
1849         revert OwnerQueryForNonexistentToken();
1850     }
1851 
1852     /**
1853      * Returns the unpacked `TokenOwnership` struct from `packed`.
1854      */
1855     function _unpackedOwnership(uint256 packed)
1856         private
1857         pure
1858         returns (TokenOwnership memory ownership)
1859     {
1860         ownership.addr = address(uint160(packed));
1861         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1862         ownership.burned = packed & BITMASK_BURNED != 0;
1863     }
1864 
1865     /**
1866      * Returns the unpacked `TokenOwnership` struct at `index`.
1867      */
1868     function _ownershipAt(uint256 index)
1869         internal
1870         view
1871         returns (TokenOwnership memory)
1872     {
1873         return _unpackedOwnership(_packedOwnerships[index]);
1874     }
1875 
1876     /**
1877      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1878      */
1879     function _initializeOwnershipAt(uint256 index) internal {
1880         if (_packedOwnerships[index] == 0) {
1881             _packedOwnerships[index] = _packedOwnershipOf(index);
1882         }
1883     }
1884 
1885     /**
1886      * Gas spent here starts off proportional to the maximum mint batch size.
1887      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1888      */
1889     function _ownershipOf(uint256 tokenId)
1890         internal
1891         view
1892         returns (TokenOwnership memory)
1893     {
1894         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1895     }
1896 
1897     /**
1898      * @dev See {IERC721-ownerOf}.
1899      */
1900     function ownerOf(uint256 tokenId) public view override returns (address) {
1901         return address(uint160(_packedOwnershipOf(tokenId)));
1902     }
1903 
1904     /**
1905      * @dev See {IERC721Metadata-name}.
1906      */
1907     function name() public view virtual override returns (string memory) {
1908         return _name;
1909     }
1910 
1911     /**
1912      * @dev See {IERC721Metadata-symbol}.
1913      */
1914     function symbol() public view virtual override returns (string memory) {
1915         return _symbol;
1916     }
1917 
1918     /**
1919      * @dev See {IERC721Metadata-tokenURI}.
1920      */
1921     function tokenURI(uint256 tokenId)
1922         public
1923         view
1924         virtual
1925         override
1926         returns (string memory)
1927     {
1928         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1929 
1930         string memory baseURI = _baseURI();
1931         return
1932             bytes(baseURI).length != 0
1933                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1934                 : "";
1935     }
1936 
1937     /**
1938      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1939      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1940      * by default, can be overriden in child contracts.
1941      */
1942     function _baseURI() internal view virtual returns (string memory) {
1943         return "";
1944     }
1945 
1946     /**
1947      * @dev Casts the address to uint256 without masking.
1948      */
1949     function _addressToUint256(address value)
1950         private
1951         pure
1952         returns (uint256 result)
1953     {
1954         assembly {
1955             result := value
1956         }
1957     }
1958 
1959     /**
1960      * @dev Casts the boolean to uint256 without branching.
1961      */
1962     function _boolToUint256(bool value) private pure returns (uint256 result) {
1963         assembly {
1964             result := value
1965         }
1966     }
1967 
1968     /**
1969      * @dev See {IERC721-approve}.
1970      */
1971     function approve(address to, uint256 tokenId) public override {
1972         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1973         if (to == owner) revert ApprovalToCurrentOwner();
1974 
1975         if (_msgSenderERC721A() != owner)
1976             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1977                 revert ApprovalCallerNotOwnerNorApproved();
1978             }
1979 
1980         _tokenApprovals[tokenId] = to;
1981         emit Approval(owner, to, tokenId);
1982     }
1983 
1984     /**
1985      * @dev See {IERC721-getApproved}.
1986      */
1987     function getApproved(uint256 tokenId)
1988         public
1989         view
1990         override
1991         returns (address)
1992     {
1993         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1994 
1995         return _tokenApprovals[tokenId];
1996     }
1997 
1998     /**
1999      * @dev See {IERC721-setApprovalForAll}.
2000      */
2001     function setApprovalForAll(address operator, bool approved)
2002         public
2003         virtual
2004         override
2005     {
2006         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
2007 
2008         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2009         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2010     }
2011 
2012     /**
2013      * @dev See {IERC721-isApprovedForAll}.
2014      */
2015     function isApprovedForAll(address owner, address operator)
2016         public
2017         view
2018         virtual
2019         override
2020         returns (bool)
2021     {
2022         return _operatorApprovals[owner][operator];
2023     }
2024 
2025     /**
2026      * @dev See {IERC721-transferFrom}.
2027      */
2028     function transferFrom(
2029         address from,
2030         address to,
2031         uint256 tokenId
2032     ) public virtual override {
2033         _transfer(from, to, tokenId);
2034     }
2035 
2036     /**
2037      * @dev See {IERC721-safeTransferFrom}.
2038      */
2039     function safeTransferFrom(
2040         address from,
2041         address to,
2042         uint256 tokenId
2043     ) public virtual override {
2044         safeTransferFrom(from, to, tokenId, "");
2045     }
2046 
2047     /**
2048      * @dev See {IERC721-safeTransferFrom}.
2049      */
2050     function safeTransferFrom(
2051         address from,
2052         address to,
2053         uint256 tokenId,
2054         bytes memory _data
2055     ) public virtual override {
2056         _transfer(from, to, tokenId);
2057         if (to.code.length != 0)
2058             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2059                 revert TransferToNonERC721ReceiverImplementer();
2060             }
2061     }
2062 
2063     /**
2064      * @dev Returns whether `tokenId` exists.
2065      *
2066      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2067      *
2068      * Tokens start existing when they are minted (`_mint`),
2069      */
2070     function _exists(uint256 tokenId) internal view returns (bool) {
2071         return
2072             _startTokenId() <= tokenId &&
2073             tokenId < _currentIndex && // If within bounds,
2074             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
2075     }
2076 
2077     /**
2078      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2079      */
2080     function _safeMint(address to, uint256 quantity) internal {
2081         _safeMint(to, quantity, "");
2082     }
2083 
2084     /**
2085      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2086      *
2087      * Requirements:
2088      *
2089      * - If `to` refers to a smart contract, it must implement
2090      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2091      * - `quantity` must be greater than 0.
2092      *
2093      * Emits a {Transfer} event.
2094      */
2095     function _safeMint(
2096         address to,
2097         uint256 quantity,
2098         bytes memory _data
2099     ) internal {
2100         uint256 startTokenId = _currentIndex;
2101         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
2102         if (quantity == 0) revert MintZeroQuantity();
2103 
2104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2105 
2106         // Overflows are incredibly unrealistic.
2107         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2108         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2109         unchecked {
2110             // Updates:
2111             // - `balance += quantity`.
2112             // - `numberMinted += quantity`.
2113             //
2114             // We can directly add to the balance and number minted.
2115             _packedAddressData[to] +=
2116                 quantity *
2117                 ((1 << BITPOS_NUMBER_MINTED) | 1);
2118 
2119             // Updates:
2120             // - `address` to the owner.
2121             // - `startTimestamp` to the timestamp of minting.
2122             // - `burned` to `false`.
2123             // - `nextInitialized` to `quantity == 1`.
2124             _packedOwnerships[startTokenId] =
2125                 _addressToUint256(to) |
2126                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2127                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2128 
2129             uint256 updatedIndex = startTokenId;
2130             uint256 end = updatedIndex + quantity;
2131 
2132             if (to.code.length != 0) {
2133                 do {
2134                     emit Transfer(address(0), to, updatedIndex);
2135                     if (
2136                         !_checkContractOnERC721Received(
2137                             address(0),
2138                             to,
2139                             updatedIndex++,
2140                             _data
2141                         )
2142                     ) {
2143                         revert TransferToNonERC721ReceiverImplementer();
2144                     }
2145                 } while (updatedIndex < end);
2146                 // Reentrancy protection
2147                 if (_currentIndex != startTokenId) revert();
2148             } else {
2149                 do {
2150                     emit Transfer(address(0), to, updatedIndex++);
2151                 } while (updatedIndex < end);
2152             }
2153             _currentIndex = updatedIndex;
2154         }
2155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2156     }
2157 
2158     /**
2159      * @dev Mints `quantity` tokens and transfers them to `to`.
2160      *
2161      * Requirements:
2162      *
2163      * - `to` cannot be the zero address.
2164      * - `quantity` must be greater than 0.
2165      *
2166      * Emits a {Transfer} event.
2167      */
2168     function _mint(address to, uint256 quantity) internal {
2169         uint256 startTokenId = _currentIndex;
2170         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
2171         if (quantity == 0) revert MintZeroQuantity();
2172 
2173         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2174 
2175         // Overflows are incredibly unrealistic.
2176         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2177         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2178         unchecked {
2179             // Updates:
2180             // - `balance += quantity`.
2181             // - `numberMinted += quantity`.
2182             //
2183             // We can directly add to the balance and number minted.
2184             _packedAddressData[to] +=
2185                 quantity *
2186                 ((1 << BITPOS_NUMBER_MINTED) | 1);
2187 
2188             // Updates:
2189             // - `address` to the owner.
2190             // - `startTimestamp` to the timestamp of minting.
2191             // - `burned` to `false`.
2192             // - `nextInitialized` to `quantity == 1`.
2193             _packedOwnerships[startTokenId] =
2194                 _addressToUint256(to) |
2195                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2196                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
2197 
2198             uint256 updatedIndex = startTokenId;
2199             uint256 end = updatedIndex + quantity;
2200 
2201             do {
2202                 emit Transfer(address(0), to, updatedIndex++);
2203             } while (updatedIndex < end);
2204 
2205             _currentIndex = updatedIndex;
2206         }
2207         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2208     }
2209 
2210     /**
2211      * @dev Transfers `tokenId` from `from` to `to`.
2212      *
2213      * Requirements:
2214      *
2215      * - `to` cannot be the zero address.
2216      * - `tokenId` token must be owned by `from`.
2217      *
2218      * Emits a {Transfer} event.
2219      */
2220     function _transfer(
2221         address from,
2222         address to,
2223         uint256 tokenId
2224     ) private {
2225         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2226 
2227         if (address(uint160(prevOwnershipPacked)) != from)
2228             revert TransferFromIncorrectOwner();
2229 
2230         address approvedAddress = _tokenApprovals[tokenId];
2231 
2232         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2233             isApprovedForAll(from, _msgSenderERC721A()) ||
2234             approvedAddress == _msgSenderERC721A());
2235 
2236         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2237         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
2238 
2239         _beforeTokenTransfers(from, to, tokenId, 1);
2240 
2241         // Clear approvals from the previous owner.
2242         if (_addressToUint256(approvedAddress) != 0) {
2243             delete _tokenApprovals[tokenId];
2244         }
2245 
2246         // Underflow of the sender's balance is impossible because we check for
2247         // ownership above and the recipient's balance can't realistically overflow.
2248         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2249         unchecked {
2250             // We can directly increment and decrement the balances.
2251             --_packedAddressData[from]; // Updates: `balance -= 1`.
2252             ++_packedAddressData[to]; // Updates: `balance += 1`.
2253 
2254             // Updates:
2255             // - `address` to the next owner.
2256             // - `startTimestamp` to the timestamp of transfering.
2257             // - `burned` to `false`.
2258             // - `nextInitialized` to `true`.
2259             _packedOwnerships[tokenId] =
2260                 _addressToUint256(to) |
2261                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2262                 BITMASK_NEXT_INITIALIZED;
2263 
2264             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2265             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2266                 uint256 nextTokenId = tokenId + 1;
2267                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2268                 if (_packedOwnerships[nextTokenId] == 0) {
2269                     // If the next slot is within bounds.
2270                     if (nextTokenId != _currentIndex) {
2271                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2272                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2273                     }
2274                 }
2275             }
2276         }
2277 
2278         emit Transfer(from, to, tokenId);
2279         _afterTokenTransfers(from, to, tokenId, 1);
2280     }
2281 
2282     /**
2283      * @dev Equivalent to `_burn(tokenId, false)`.
2284      */
2285     function _burn(uint256 tokenId) internal virtual {
2286         _burn(tokenId, false);
2287     }
2288 
2289     /**
2290      * @dev Destroys `tokenId`.
2291      * The approval is cleared when the token is burned.
2292      *
2293      * Requirements:
2294      *
2295      * - `tokenId` must exist.
2296      *
2297      * Emits a {Transfer} event.
2298      */
2299     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2300         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2301 
2302         address from = address(uint160(prevOwnershipPacked));
2303         address approvedAddress = _tokenApprovals[tokenId];
2304 
2305         if (approvalCheck) {
2306             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
2307                 isApprovedForAll(from, _msgSenderERC721A()) ||
2308                 approvedAddress == _msgSenderERC721A());
2309 
2310             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2311         }
2312 
2313         _beforeTokenTransfers(from, address(0), tokenId, 1);
2314 
2315         // Clear approvals from the previous owner.
2316         if (_addressToUint256(approvedAddress) != 0) {
2317             delete _tokenApprovals[tokenId];
2318         }
2319 
2320         // Underflow of the sender's balance is impossible because we check for
2321         // ownership above and the recipient's balance can't realistically overflow.
2322         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2323         unchecked {
2324             // Updates:
2325             // - `balance -= 1`.
2326             // - `numberBurned += 1`.
2327             //
2328             // We can directly decrement the balance, and increment the number burned.
2329             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
2330             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
2331 
2332             // Updates:
2333             // - `address` to the last owner.
2334             // - `startTimestamp` to the timestamp of burning.
2335             // - `burned` to `true`.
2336             // - `nextInitialized` to `true`.
2337             _packedOwnerships[tokenId] =
2338                 _addressToUint256(from) |
2339                 (block.timestamp << BITPOS_START_TIMESTAMP) |
2340                 BITMASK_BURNED |
2341                 BITMASK_NEXT_INITIALIZED;
2342 
2343             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2344             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
2345                 uint256 nextTokenId = tokenId + 1;
2346                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2347                 if (_packedOwnerships[nextTokenId] == 0) {
2348                     // If the next slot is within bounds.
2349                     if (nextTokenId != _currentIndex) {
2350                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2351                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2352                     }
2353                 }
2354             }
2355         }
2356 
2357         emit Transfer(from, address(0), tokenId);
2358         _afterTokenTransfers(from, address(0), tokenId, 1);
2359 
2360         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2361         unchecked {
2362             _burnCounter++;
2363         }
2364     }
2365 
2366     /**
2367      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2368      *
2369      * @param from address representing the previous owner of the given token ID
2370      * @param to target address that will receive the tokens
2371      * @param tokenId uint256 ID of the token to be transferred
2372      * @param _data bytes optional data to send along with the call
2373      * @return bool whether the call correctly returned the expected magic value
2374      */
2375     function _checkContractOnERC721Received(
2376         address from,
2377         address to,
2378         uint256 tokenId,
2379         bytes memory _data
2380     ) private returns (bool) {
2381         try
2382             ERC721A__IERC721Receiver(to).onERC721Received(
2383                 _msgSenderERC721A(),
2384                 from,
2385                 tokenId,
2386                 _data
2387             )
2388         returns (bytes4 retval) {
2389             return
2390                 retval ==
2391                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
2392         } catch (bytes memory reason) {
2393             if (reason.length == 0) {
2394                 revert TransferToNonERC721ReceiverImplementer();
2395             } else {
2396                 assembly {
2397                     revert(add(32, reason), mload(reason))
2398                 }
2399             }
2400         }
2401     }
2402 
2403     /**
2404      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2405      * And also called before burning one token.
2406      *
2407      * startTokenId - the first token id to be transferred
2408      * quantity - the amount to be transferred
2409      *
2410      * Calling conditions:
2411      *
2412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2413      * transferred to `to`.
2414      * - When `from` is zero, `tokenId` will be minted for `to`.
2415      * - When `to` is zero, `tokenId` will be burned by `from`.
2416      * - `from` and `to` are never both zero.
2417      */
2418     function _beforeTokenTransfers(
2419         address from,
2420         address to,
2421         uint256 startTokenId,
2422         uint256 quantity
2423     ) internal virtual {}
2424 
2425     /**
2426      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2427      * minting.
2428      * And also called after one token has been burned.
2429      *
2430      * startTokenId - the first token id to be transferred
2431      * quantity - the amount to be transferred
2432      *
2433      * Calling conditions:
2434      *
2435      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2436      * transferred to `to`.
2437      * - When `from` is zero, `tokenId` has been minted for `to`.
2438      * - When `to` is zero, `tokenId` has been burned by `from`.
2439      * - `from` and `to` are never both zero.
2440      */
2441     function _afterTokenTransfers(
2442         address from,
2443         address to,
2444         uint256 startTokenId,
2445         uint256 quantity
2446     ) internal virtual {}
2447 
2448     /**
2449      * @dev Returns the message sender (defaults to `msg.sender`).
2450      *
2451      * If you are writing GSN compatible contracts, you need to override this function.
2452      */
2453     function _msgSenderERC721A() internal view virtual returns (address) {
2454         return msg.sender;
2455     }
2456 
2457     /**
2458      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2459      */
2460     function _toString(uint256 value)
2461         internal
2462         pure
2463         returns (string memory ptr)
2464     {
2465         assembly {
2466             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2467             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2468             // We will need 1 32-byte word to store the length,
2469             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2470             ptr := add(mload(0x40), 128)
2471             // Update the free memory pointer to allocate.
2472             mstore(0x40, ptr)
2473 
2474             // Cache the end of the memory to calculate the length later.
2475             let end := ptr
2476 
2477             // We write the string from the rightmost digit to the leftmost digit.
2478             // The following is essentially a do-while loop that also handles the zero case.
2479             // Costs a bit more than early returning for the zero case,
2480             // but cheaper in terms of deployment and overall runtime costs.
2481             for {
2482                 // Initialize and perform the first pass without check.
2483                 let temp := value
2484                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2485                 ptr := sub(ptr, 1)
2486                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2487                 mstore8(ptr, add(48, mod(temp, 10)))
2488                 temp := div(temp, 10)
2489             } temp {
2490                 // Keep dividing `temp` until zero.
2491                 temp := div(temp, 10)
2492             } {
2493                 // Body of the for loop.
2494                 ptr := sub(ptr, 1)
2495                 mstore8(ptr, add(48, mod(temp, 10)))
2496             }
2497 
2498             let length := sub(end, ptr)
2499             // Move the pointer 32 bytes leftwards to make room for the length.
2500             ptr := sub(ptr, 32)
2501             // Store the length.
2502             mstore(ptr, length)
2503         }
2504     }
2505 }
2506 
2507 
2508 /**
2509  * @dev Provides information about the current execution context, including the
2510  * sender of the transaction and its data. While these are generally available
2511  * via msg.sender and msg.data, they should not be accessed in such a direct
2512  * manner, since when dealing with meta-transactions the account sending and
2513  * paying for execution may not be the actual sender (as far as an application
2514  * is concerned).
2515  *
2516  * This contract is only required for intermediate, library-like contracts.
2517  */
2518 abstract contract Context {
2519     function _msgSender() internal view virtual returns (address) {
2520         return msg.sender;
2521     }
2522 
2523     function _msgData() internal view virtual returns (bytes calldata) {
2524         return msg.data;
2525     }
2526 }
2527 
2528 
2529 /**
2530  * @dev Contract module which provides a basic access control mechanism, where
2531  * there is an account (an owner) that can be granted exclusive access to
2532  * specific functions.
2533  *
2534  * By default, the owner account will be the one that deploys the contract. This
2535  * can later be changed with {transferOwnership}.
2536  *
2537  * This module is used through inheritance. It will make available the modifier
2538  * `onlyOwner`, which can be applied to your functions to restrict their use to
2539  * the owner.
2540  */
2541 abstract contract Ownable is Context {
2542     address private _owner;
2543 
2544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2545 
2546     /**
2547      * @dev Initializes the contract setting the deployer as the initial owner.
2548      */
2549     constructor() {
2550         _transferOwnership(_msgSender());
2551     }
2552 
2553     /**
2554      * @dev Returns the address of the current owner.
2555      */
2556     function owner() public view virtual returns (address) {
2557         return _owner;
2558     }
2559 
2560     /**
2561      * @dev Throws if called by any account other than the owner.
2562      */
2563     modifier onlyOwner() {
2564         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2565         _;
2566     }
2567 
2568     /**
2569      * @dev Leaves the contract without owner. It will not be possible to call
2570      * `onlyOwner` functions anymore. Can only be called by the current owner.
2571      *
2572      * NOTE: Renouncing ownership will leave the contract without an owner,
2573      * thereby removing any functionality that is only available to the owner.
2574      */
2575     function renounceOwnership() public virtual onlyOwner {
2576         _transferOwnership(address(0));
2577     }
2578 
2579     /**
2580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2581      * Can only be called by the current owner.
2582      */
2583     function transferOwnership(address newOwner) public virtual onlyOwner {
2584         require(newOwner != address(0), "Ownable: new owner is the zero address");
2585         _transferOwnership(newOwner);
2586     }
2587 
2588     /**
2589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2590      * Internal function without access restriction.
2591      */
2592     function _transferOwnership(address newOwner) internal virtual {
2593         address oldOwner = _owner;
2594         _owner = newOwner;
2595         emit OwnershipTransferred(oldOwner, newOwner);
2596     }
2597 }
2598 
2599 
2600 
2601 /**
2602  * @dev Interface of the ERC20 standard as defined in the EIP.
2603  */
2604 interface IERC20 {
2605     /**
2606      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2607      * another (`to`).
2608      *
2609      * Note that `value` may be zero.
2610      */
2611     event Transfer(address indexed from, address indexed to, uint256 value);
2612 
2613     /**
2614      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2615      * a call to {approve}. `value` is the new allowance.
2616      */
2617     event Approval(address indexed owner, address indexed spender, uint256 value);
2618 
2619     /**
2620      * @dev Returns the amount of tokens in existence.
2621      */
2622     function totalSupply() external view returns (uint256);
2623 
2624     /**
2625      * @dev Returns the amount of tokens owned by `account`.
2626      */
2627     function balanceOf(address account) external view returns (uint256);
2628 
2629     /**
2630      * @dev Moves `amount` tokens from the caller's account to `to`.
2631      *
2632      * Returns a boolean value indicating whether the operation succeeded.
2633      *
2634      * Emits a {Transfer} event.
2635      */
2636     function transfer(address to, uint256 amount) external returns (bool);
2637 
2638     /**
2639      * @dev Returns the remaining number of tokens that `spender` will be
2640      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2641      * zero by default.
2642      *
2643      * This value changes when {approve} or {transferFrom} are called.
2644      */
2645     function allowance(address owner, address spender) external view returns (uint256);
2646 
2647     /**
2648      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2649      *
2650      * Returns a boolean value indicating whether the operation succeeded.
2651      *
2652      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2653      * that someone may use both the old and the new allowance by unfortunate
2654      * transaction ordering. One possible solution to mitigate this race
2655      * condition is to first reduce the spender's allowance to 0 and set the
2656      * desired value afterwards:
2657      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2658      *
2659      * Emits an {Approval} event.
2660      */
2661     function approve(address spender, uint256 amount) external returns (bool);
2662 
2663     /**
2664      * @dev Moves `amount` tokens from `from` to `to` using the
2665      * allowance mechanism. `amount` is then deducted from the caller's
2666      * allowance.
2667      *
2668      * Returns a boolean value indicating whether the operation succeeded.
2669      *
2670      * Emits a {Transfer} event.
2671      */
2672     function transferFrom(
2673         address from,
2674         address to,
2675         uint256 amount
2676     ) external returns (bool);
2677 }
2678 
2679 
2680 /**
2681  * @title SafeERC20
2682  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2683  * contract returns false). Tokens that return no value (and instead revert or
2684  * throw on failure) are also supported, non-reverting calls are assumed to be
2685  * successful.
2686  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2687  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2688  */
2689 library SafeERC20 {
2690     using Address for address;
2691 
2692     function safeTransfer(
2693         IERC20 token,
2694         address to,
2695         uint256 value
2696     ) internal {
2697         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2698     }
2699 
2700     function safeTransferFrom(
2701         IERC20 token,
2702         address from,
2703         address to,
2704         uint256 value
2705     ) internal {
2706         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2707     }
2708 
2709     /**
2710      * @dev Deprecated. This function has issues similar to the ones found in
2711      * {IERC20-approve}, and its usage is discouraged.
2712      *
2713      * Whenever possible, use {safeIncreaseAllowance} and
2714      * {safeDecreaseAllowance} instead.
2715      */
2716     function safeApprove(
2717         IERC20 token,
2718         address spender,
2719         uint256 value
2720     ) internal {
2721         // safeApprove should only be called when setting an initial allowance,
2722         // or when resetting it to zero. To increase and decrease it, use
2723         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2724         require(
2725             (value == 0) || (token.allowance(address(this), spender) == 0),
2726             "SafeERC20: approve from non-zero to non-zero allowance"
2727         );
2728         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2729     }
2730 
2731     function safeIncreaseAllowance(
2732         IERC20 token,
2733         address spender,
2734         uint256 value
2735     ) internal {
2736         uint256 newAllowance = token.allowance(address(this), spender) + value;
2737         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2738     }
2739 
2740     function safeDecreaseAllowance(
2741         IERC20 token,
2742         address spender,
2743         uint256 value
2744     ) internal {
2745         unchecked {
2746             uint256 oldAllowance = token.allowance(address(this), spender);
2747             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2748             uint256 newAllowance = oldAllowance - value;
2749             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2750         }
2751     }
2752 
2753     /**
2754      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2755      * on the return value: the return value is optional (but if data is returned, it must not be false).
2756      * @param token The token targeted by the call.
2757      * @param data The call data (encoded using abi.encode or one of its variants).
2758      */
2759     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2760         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2761         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
2762         // the target address contains contract code and also asserts for success in the low-level call.
2763 
2764         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2765         if (returndata.length > 0) {
2766             // Return data is optional
2767             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2768         }
2769     }
2770 }
2771 
2772 
2773 /**
2774  * Slightly adjusted version of PaymentSplitter by OpenZeppelin
2775  *
2776  * @title PaymentSplitter
2777  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2778  * that the Ether will be split in this way, since it is handled transparently by the contract.
2779  *
2780  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2781  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2782  * an amount proportional to the percentage of total shares they were assigned.
2783  *
2784  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2785  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2786  * function.
2787  *
2788  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2789  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2790  * to run tests before sending real value to this contract.
2791  */
2792 contract PaymentSplitter is Context {
2793     event PayeeAdded(address account, uint256 shares);
2794     event PaymentReleased(address to, uint256 amount);
2795     event ERC20PaymentReleased(
2796         IERC20 indexed token,
2797         address to,
2798         uint256 amount
2799     );
2800     event PaymentReceived(address from, uint256 amount);
2801 
2802     uint256 private _totalShares;
2803     uint256 private _totalReleased;
2804 
2805     mapping(address => uint256) private _shares;
2806     mapping(address => uint256) private _released;
2807     address[] private _payees;
2808 
2809     mapping(IERC20 => uint256) private _erc20TotalReleased;
2810     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2811 
2812     /**
2813      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2814      * the matching position in the `shares` array.
2815      *
2816      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2817      * duplicates in `payees`.
2818      */
2819     constructor(address[] memory payees, uint256[] memory shares_) payable {
2820         require(
2821             payees.length == shares_.length,
2822             "PaymentSplitter: payees and shares length mismatch"
2823         );
2824         require(payees.length > 0, "PaymentSplitter: no payees");
2825 
2826         for (uint256 i = 0; i < payees.length; i++) {
2827             _addPayee(payees[i], shares_[i]);
2828         }
2829     }
2830 
2831     /**
2832      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2833      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2834      * reliability of the events, and not the actual splitting of Ether.
2835      *
2836      * To learn more about this see the Solidity documentation for
2837      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2838      * functions].
2839      */
2840     receive() external payable virtual {
2841         emit PaymentReceived(_msgSender(), msg.value);
2842     }
2843 
2844     /**
2845      * @dev Getter for the total shares held by payees.
2846      */
2847     function totalShares() public view returns (uint256) {
2848         return _totalShares;
2849     }
2850 
2851     /**
2852      * @dev Getter for the total amount of Ether already released.
2853      */
2854     function totalReleased() public view returns (uint256) {
2855         return _totalReleased;
2856     }
2857 
2858     /**
2859      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2860      * contract.
2861      */
2862     function totalReleased(IERC20 token) public view returns (uint256) {
2863         return _erc20TotalReleased[token];
2864     }
2865 
2866     /**
2867      * @dev Getter for the amount of shares held by an account.
2868      */
2869     function shares(address account) public view returns (uint256) {
2870         return _shares[account];
2871     }
2872 
2873     /**
2874      * @dev Getter for the amount of Ether already released to a payee.
2875      */
2876     function released(address account) public view returns (uint256) {
2877         return _released[account];
2878     }
2879 
2880     /**
2881      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2882      * IERC20 contract.
2883      */
2884     function released(IERC20 token, address account)
2885         public
2886         view
2887         returns (uint256)
2888     {
2889         return _erc20Released[token][account];
2890     }
2891 
2892     /**
2893      * @dev Getter for the address of the payee number `index`.
2894      */
2895     function payee(uint256 index) public view returns (address) {
2896         return _payees[index];
2897     }
2898 
2899     /**
2900      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2901      * total shares and their previous withdrawals.
2902      */
2903     function release(address payable account) public virtual {
2904         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2905 
2906         uint256 totalReceived = address(this).balance + totalReleased();
2907         uint256 payment = _pendingPayment(
2908             account,
2909             totalReceived,
2910             released(account)
2911         );
2912 
2913         require(payment != 0, "PaymentSplitter: account is not due payment");
2914 
2915         _released[account] += payment;
2916         _totalReleased += payment;
2917 
2918         Address.sendValue(account, payment);
2919         emit PaymentReleased(account, payment);
2920     }
2921 
2922     /**
2923      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2924      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2925      * contract.
2926      */
2927     function release(IERC20 token, address account) public virtual {
2928         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2929 
2930         uint256 totalReceived = token.balanceOf(address(this)) +
2931             totalReleased(token);
2932         uint256 payment = _pendingPayment(
2933             account,
2934             totalReceived,
2935             released(token, account)
2936         );
2937 
2938         require(payment != 0, "PaymentSplitter: account is not due payment");
2939 
2940         _erc20Released[token][account] += payment;
2941         _erc20TotalReleased[token] += payment;
2942 
2943         SafeERC20.safeTransfer(token, account, payment);
2944         emit ERC20PaymentReleased(token, account, payment);
2945     }
2946 
2947     /**
2948      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2949      * already released amounts.
2950      */
2951     function _pendingPayment(
2952         address account,
2953         uint256 totalReceived,
2954         uint256 alreadyReleased
2955     ) private view returns (uint256) {
2956         return
2957             (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2958     }
2959 
2960     /**
2961      * @dev Add a new payee to the contract.
2962      * @param account The address of the payee to add.
2963      * @param shares_ The number of shares owned by the payee.
2964      */
2965     function _addPayee(address account, uint256 shares_) internal {
2966         require(
2967             account != address(0),
2968             "PaymentSplitter: account is the zero address"
2969         );
2970         require(shares_ > 0, "PaymentSplitter: shares are 0");
2971         require(
2972             _shares[account] == 0,
2973             "PaymentSplitter: account already has shares"
2974         );
2975 
2976         _payees.push(account);
2977         _shares[account] = shares_;
2978         _totalShares = _totalShares + shares_;
2979         emit PayeeAdded(account, shares_);
2980     }
2981 
2982     /**
2983      * @dev Update a payee on the contract.
2984      * @param index The array index of the payee to update.
2985      * @param shares_ The number of shares owned by the payee.
2986      */
2987     function _updatePayee(uint256 index, uint256 shares_) internal {
2988         require(shares_ > 0, "PaymentSplitter: shares are 0");
2989         uint256 temp = _shares[payee(index)];
2990         _shares[payee(index)] = shares_;
2991         _totalShares = _totalShares - temp + shares_;
2992     }
2993 
2994     /**
2995      * @dev Remove a payee from the contract.
2996      * @param index The array index of the payee to update.
2997      */
2998     function _removePayee(uint256 index) internal {
2999         uint256 temp = _shares[payee(index)];
3000         _shares[payee(index)] = 0;
3001         _payees[index] = _payees[_payees.length - 1];
3002         _payees.pop();
3003         _totalShares = _totalShares - temp;
3004     }
3005 }
3006 
3007 
3008 contract Royalties_V1_1 is PaymentSplitter, Ownable {
3009     constructor(
3010         address[] memory payees_,
3011         uint256[] memory shares_,
3012         address owner_
3013     ) PaymentSplitter(payees_, shares_) {
3014         transferOwnership(owner_);
3015     }
3016 
3017     function addPayee(address payee, uint256 shares) public onlyOwner {
3018         _addPayee(payee, shares);
3019     }
3020 
3021     function updatePayee(uint256 payeeIndex, uint256 shares) public onlyOwner {
3022         _updatePayee(payeeIndex, shares);
3023     }
3024 
3025     function removePayee(uint256 payeeIndex) public onlyOwner {
3026         _removePayee(payeeIndex);
3027     }
3028 }
3029 
3030 
3031 contract MixedStems_V1_1 is ERC721A, ERC2981, Ownable {
3032     using Strings for uint256;
3033     using Address for address payable;
3034     using BytesLib for bytes;
3035 
3036     enum Phase {
3037         INIT,
3038         ALLOWLIST,
3039         PUBLIC,
3040         RESERVE
3041     }
3042 
3043     type SongID is uint256;
3044     type TrackID is uint256;
3045 
3046     Royalties_V1_1 public immutable royaltyContract;
3047 
3048     DateTimeAPI public constant dateTimeAPI = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);
3049     uint256 public presaleMintStartTime;
3050     uint256 public publicMintStartTime;
3051     uint256 public reserveMintStartTime;
3052 
3053     string public baseURI;
3054     string public prerevealURI;
3055 
3056     uint256 public numVariableTracks;
3057     uint256 public mintPrice;
3058     uint256 public maxSupply;
3059     uint256 public maxPerMint;
3060 
3061     // metadata values
3062     string public composer;
3063     string private _singular;
3064     string public description;
3065 
3066     // song ID -> track ID -> array of pointers to SSTORE2 MIDI data
3067     mapping(SongID => mapping(TrackID => address[])) private _tracks;
3068     // song ID -> array of pointers to SSTORE2 MIDI data
3069     mapping(SongID => address[]) private _staticTracks;
3070     // song ID -> time division
3071     mapping(SongID => bytes2) private _timeDivisions;
3072     // song ID -> song name
3073     mapping(SongID => string) private _songNames;
3074     // song ID -> variant -> variant name
3075     mapping(SongID => mapping(uint256 => string)) private _variantNames;
3076     // song ID -> track ID -> track name
3077     mapping(SongID => mapping(TrackID => string)) private _stemTypeNames;
3078     // stem address -> stem name
3079     mapping(address => string) private _stemNames;
3080 
3081     bytes private _seeds;
3082 
3083     bytes32 private _allowlistMerkleRoot;
3084 
3085     // MODIFIERS -----------------------------------------------------
3086 
3087     modifier mustAfter(uint256 time) {
3088         require(
3089             block.timestamp > time && time > 0,
3090             "MixedStems_V1_1: OperationRequiresTime"
3091         );
3092         _;
3093     }
3094 
3095     modifier mustPrice(uint256 _price) {
3096         require(msg.value == _price, "MixedStems_V1_1: WrongPrice");
3097         _;
3098     }
3099 
3100     // CONSTRUCTOR ---------------------------------------------------
3101 
3102     constructor(
3103         string memory name_,
3104         string memory singular_,
3105         string memory description_,
3106         string memory symbol_,
3107         string memory composer_,
3108         uint256 numVariableTracks_,
3109         address[] memory royaltyReceivers_,
3110         uint256[] memory royaltyShares_,
3111         uint256 royaltyPercent_
3112     ) ERC721A(name_, symbol_) {
3113         _singular = singular_;
3114         description = description_;
3115         numVariableTracks = numVariableTracks_;
3116         composer = composer_;
3117         Royalties_V1_1 p = new Royalties_V1_1(
3118             royaltyReceivers_,
3119             royaltyShares_,
3120             msg.sender
3121         );
3122         royaltyContract = p;
3123         _setDefaultRoyalty(address(p), uint96(royaltyPercent_));
3124     }
3125 
3126     // ADMIN FUNCTIONS ---------------------------------------------------
3127 
3128     function withdraw(address payable to, uint256 amount) public onlyOwner {
3129         require(
3130             address(this).balance >= amount,
3131             "MixedStems_V1_1: InsufficientBalance"
3132         );
3133 
3134         if (amount == 0) {
3135             amount = address(this).balance;
3136         }
3137         if (to == address(0)) {
3138             to = payable(owner());
3139         }
3140         to.sendValue(amount);
3141     }
3142 
3143     function setBaseURI(string memory _baseURI) public onlyOwner {
3144         baseURI = _baseURI;
3145     }
3146 
3147     function setPreRevealURI(string memory _prerevealURI) public onlyOwner {
3148         prerevealURI = _prerevealURI;
3149     }
3150 
3151     function setComposer(string memory composer_) public onlyOwner {
3152         composer = composer_;
3153     }
3154 
3155     function setDescription(string memory description_) public onlyOwner {
3156         description = description_;
3157     }
3158 
3159     function setMintPrice(uint256 value) public onlyOwner {
3160         mintPrice = value;
3161     }
3162 
3163     function setMaxPerMint(uint256 value) public onlyOwner {
3164         maxPerMint = value;
3165     }
3166 
3167     function setMaxSupply(uint256 value) public onlyOwner {
3168         maxSupply = value;
3169     }
3170 
3171     function setSeeds(bytes memory seeds) public onlyOwner {
3172         _seeds = seeds;
3173     }
3174 
3175     function setAllowlistMerkleRoot(bytes32 value) public onlyOwner {
3176         _allowlistMerkleRoot = value;
3177     }
3178 
3179     function setRoyaltyPercentage(uint96 percent) public onlyOwner {
3180         _setDefaultRoyalty(address(royaltyContract), percent);
3181     }
3182 
3183     function setSongNames(SongID[] memory songs, string[] memory songNames)
3184         public
3185         onlyOwner
3186     {
3187         require(songs.length == songNames.length);
3188         for (uint256 i = 0; i < songNames.length; i++) {
3189             _songNames[songs[i]] = songNames[i];
3190         }
3191     }
3192 
3193     function setVariantNames(
3194         SongID song,
3195         uint256[] memory variants,
3196         string[] memory variantNames
3197     ) public onlyOwner {
3198         require(variants.length == variantNames.length);
3199         for (uint256 i = 0; i < variants.length; i++) {
3200             _variantNames[song][variants[i]] = variantNames[i];
3201         }
3202     }
3203 
3204     function setTrackNames(
3205         SongID song,
3206         TrackID[] memory tracks,
3207         string[] memory trackNames
3208     ) public onlyOwner {
3209         require(tracks.length == trackNames.length);
3210         for (uint256 i = 0; i < trackNames.length; i++) {
3211             _stemTypeNames[song][tracks[i]] = trackNames[i];
3212         }
3213     }
3214 
3215     function setPresaleStart(
3216         uint16 year,
3217         uint8 month,
3218         uint8 day,
3219         uint8 hour,
3220         uint8 minute,
3221         uint8 second
3222     ) public onlyOwner {
3223         presaleMintStartTime = dateTimeAPI.toTimestamp(
3224             year,
3225             month,
3226             day,
3227             hour,
3228             minute,
3229             second
3230         );
3231     }
3232 
3233     function setPublicStart(
3234         uint16 year,
3235         uint8 month,
3236         uint8 day,
3237         uint8 hour,
3238         uint8 minute,
3239         uint8 second
3240     ) public onlyOwner {
3241         publicMintStartTime = dateTimeAPI.toTimestamp(
3242             year,
3243             month,
3244             day,
3245             hour,
3246             minute,
3247             second
3248         );
3249     }
3250 
3251     function setReserveStart(
3252         uint16 year,
3253         uint8 month,
3254         uint8 day,
3255         uint8 hour,
3256         uint8 minute,
3257         uint8 second
3258     ) public onlyOwner {
3259         reserveMintStartTime = dateTimeAPI.toTimestamp(
3260             year,
3261             month,
3262             day,
3263             hour,
3264             minute,
3265             second
3266         );
3267     }
3268 
3269     function addVariableTrack(
3270         SongID song,
3271         TrackID trackNum,
3272         bytes calldata track,
3273         string calldata trackName
3274     ) external onlyOwner {
3275         require(TrackID.unwrap(trackNum) < numVariableTracks);
3276         address pointer = SSTORE2.write(track);
3277         _tracks[song][trackNum].push(pointer);
3278         _stemNames[pointer] = trackName;
3279     }
3280 
3281     function removeVariableTrack(
3282         SongID song,
3283         TrackID trackNum,
3284         uint256 index
3285     ) external onlyOwner {
3286         _tracks[song][trackNum][index] = _tracks[song][trackNum][
3287             _tracks[song][trackNum].length - 1
3288         ];
3289         _tracks[song][trackNum].pop();
3290     }
3291 
3292     function resetVariableTracks(SongID song, TrackID trackNum)
3293         external
3294         onlyOwner
3295     {
3296         delete _tracks[song][trackNum];
3297     }
3298 
3299     function addStaticTrack(
3300         SongID song,
3301         bytes calldata track
3302     ) external onlyOwner {
3303         address pointer = SSTORE2.write(track);
3304         _staticTracks[song].push(pointer);
3305     }
3306 
3307     function removeStaticTrack(SongID song, uint256 index) external onlyOwner {
3308         _staticTracks[song][index] = _staticTracks[song][
3309             _staticTracks[song].length - 1
3310         ];
3311         _staticTracks[song].pop();
3312     }
3313 
3314     function resetStaticTracks(SongID song) external onlyOwner {
3315         delete _staticTracks[song];
3316     }
3317 
3318     function setTimeDivision(SongID song, bytes2 timeDivision)
3319         public
3320         onlyOwner
3321     {
3322         _timeDivisions[song] = timeDivision;
3323     }
3324 
3325     // ERC-721 FUNCTIONS ---------------------------------------------------
3326 
3327     function tokenURI(uint256 tokenId)
3328         public
3329         view
3330         override
3331         returns (string memory)
3332     {
3333         if (!_exists(tokenId)) {
3334             revert URIQueryForNonexistentToken();
3335         }
3336 
3337         if (_seeds.length == 0) {
3338             return string(abi.encodePacked(prerevealURI, tokenId.toString()));
3339         }
3340 
3341         bytes32 seed = getSeed(tokenId);
3342         uint256 variant = getVariant(tokenId);
3343         SongID song = SongID.wrap(uint8(seed[0]));
3344 
3345         string memory mid = midi(tokenId);
3346 
3347         bytes memory json = abi.encodePacked(
3348             '{"name":"',
3349             _singular,
3350             " #",
3351             tokenId.toString(),
3352             '", "description": "',
3353             description,
3354             '", "image": "',
3355             baseURI,
3356             "/image/",
3357             uint256(seed).toHexString(),
3358             '", "animation_url": "',
3359             baseURI,
3360             "/animation/",
3361             uint256(seed).toHexString()
3362         );
3363         json = abi.encodePacked(
3364             json,
3365             '", "midi": "data:audio/midi;base64,',
3366             mid,
3367             '", "external_url": "https://beatfoundry.xyz", "composer": "',
3368             composer,
3369             '", "attributes": [{"trait_type": "Song", "value": "',
3370             _songNames[song],
3371             '"}'
3372         );
3373 
3374         json = abi.encodePacked(
3375             json,
3376             ', {"trait_type": "Cover Art", "value": "',
3377             _variantNames[song][variant],
3378             '"}'
3379         );
3380 
3381         for (uint256 i = 0; i < numVariableTracks; i++) {
3382             json = abi.encodePacked(
3383                 json,
3384                 ', {"trait_type": "',
3385                 _stemTypeNames[song][TrackID.wrap(i)],
3386                 '", "value": "',
3387                 _stemNames[_tracks[song][TrackID.wrap(i)][uint8(seed[i + 1])]],
3388                 '"}'
3389             );
3390         }
3391         json = abi.encodePacked(json, "]}");
3392         return
3393             string(
3394                 abi.encodePacked(
3395                     "data:application/json;base64,",
3396                     Base64.encode(json)
3397                 )
3398             );
3399     }
3400 
3401     function midi(uint256 tokenId) public view returns (string memory) {
3402         if (!_exists(tokenId)) {
3403             revert URIQueryForNonexistentToken();
3404         }
3405         bytes32 seed = getSeed(tokenId);
3406 
3407         SongID song = SongID.wrap(uint8(seed[0]));
3408 
3409         uint256 lenStatic = _staticTracks[song].length;
3410 
3411         bytes memory mid = newMidi(uint8(lenStatic + numVariableTracks), song);
3412 
3413         for (uint256 i = 0; i < numVariableTracks; i++) {
3414             bytes memory track = SSTORE2.read(
3415                 _tracks[song][TrackID.wrap(i)][uint8(seed[i + 1])]
3416             );
3417             mid = bytes.concat(mid, newTrack(track));
3418         }
3419 
3420         for (uint256 i = 0; i < lenStatic; i++) {
3421             bytes memory track = SSTORE2.read(_staticTracks[song][i]);
3422             mid = bytes.concat(mid, newTrack(track));
3423         }
3424 
3425         return Base64.encode(mid);
3426     }
3427 
3428     function getVariant(uint256 tokenId) public view returns (uint256) {
3429         if (!_exists(tokenId)) {
3430             revert URIQueryForNonexistentToken();
3431         }
3432         return
3433             uint8(
3434                 _seeds[
3435                     tokenId * (numVariableTracks + 2) + (numVariableTracks + 1)
3436                 ]
3437             );
3438     }
3439 
3440     function getSeed(uint256 tokenId) public view returns (bytes32) {
3441         if (!_exists(tokenId)) {
3442             revert URIQueryForNonexistentToken();
3443         }
3444 
3445         require(_seeds.length > 0, "MixedStems_V1_1: NoSeeds");
3446 
3447         return
3448             bytes32(
3449                 _seeds.slice(
3450                     tokenId * (numVariableTracks + 2),
3451                     (numVariableTracks + 2)
3452                 )
3453             );
3454     }
3455 
3456     // MINTING FUNCTIONS ---------------------------------------------------
3457 
3458     function mint(uint256 amount)
3459         external
3460         payable
3461         mustAfter(publicMintStartTime)
3462         mustPrice(mintPrice * amount)
3463     {
3464         require(
3465             _nextTokenId() + amount <= maxSupply,
3466             "MixedStems_V1_1: MintingLimitReached"
3467         );
3468         require(
3469             amount <= maxPerMint,
3470             "MixedStems_V1_1: AmountGreaterThanMaxMintPerTx"
3471         );
3472 
3473         _safeMint(_msgSender(), amount);
3474     }
3475 
3476     function mintReserve(address to, uint256 amount)
3477         external
3478         mustAfter(reserveMintStartTime)
3479         onlyOwner
3480     {
3481         require(
3482             _nextTokenId() + amount <= maxSupply,
3483             "MixedStems_V1_1: MintingLimitReached"
3484         );
3485         _safeMint(to, amount);
3486     }
3487 
3488     function mintAllowlist(
3489         uint256 amount,
3490         uint256 allotted,
3491         bytes32[] calldata allowlistProof
3492     )
3493         external
3494         payable
3495         mustAfter(presaleMintStartTime)
3496         mustPrice(mintPrice * amount)
3497     {
3498         require(
3499             _nextTokenId() + amount <= maxSupply,
3500             "MixedStems_V1_1: MintingLimitReached"
3501         );
3502         require(
3503             balanceOf(_msgSender()) + amount <= allotted,
3504             "MixedStems_V1_1: AllocationExceeded"
3505         );
3506         require(
3507             isAllowlistedFor(_msgSender(), allotted, allowlistProof),
3508             "MixedStems_V1_1: NotAllowlisted"
3509         );
3510         _safeMint(_msgSender(), amount);
3511     }
3512 
3513     // MIDI FUNCTIONS ---------------------------------------------------
3514 
3515     function newMidi(uint8 numTracks, SongID song)
3516         private
3517         view
3518         returns (bytes memory)
3519     {
3520         bytes2 timeDivision = _timeDivisions[song];
3521         if (uint16(timeDivision) == 0) {
3522             timeDivision = bytes2(uint16(256));
3523         }
3524         bytes memory data = new bytes(14);
3525         data[0] = bytes1(0x4D);
3526         data[1] = bytes1(0x54);
3527         data[2] = bytes1(0x68);
3528         data[3] = bytes1(0x64);
3529         data[4] = bytes1(0x00);
3530         data[5] = bytes1(0x00);
3531         data[6] = bytes1(0x00);
3532         data[7] = bytes1(0x06);
3533         data[8] = bytes1(0x00);
3534         if (numTracks == 1) {
3535             data[9] = bytes1(0x00);
3536         } else {
3537             data[9] = bytes1(0x01);
3538         }
3539         data[10] = bytes1(0x00);
3540         data[11] = bytes1(numTracks);
3541         data[12] = timeDivision[0];
3542         data[13] = timeDivision[1];
3543         return data;
3544     }
3545 
3546     function newTrack(bytes memory data) private pure returns (bytes memory) {
3547         bytes memory it = new bytes(8);
3548         it[0] = bytes1(0x4D);
3549         it[1] = bytes1(0x54);
3550         it[2] = bytes1(0x72);
3551         it[3] = bytes1(0x6b);
3552         bytes memory asBytes = abi.encodePacked(data.length);
3553         it[4] = asBytes[asBytes.length - 4];
3554         it[5] = asBytes[asBytes.length - 3];
3555         it[6] = asBytes[asBytes.length - 2];
3556         it[7] = asBytes[asBytes.length - 1];
3557         return bytes.concat(it, data);
3558     }
3559 
3560     // HELPERS ------------------------------------------------------------------
3561 
3562     function isAllowlistedFor(
3563         address _allowlistee,
3564         uint256 _amount,
3565         bytes32[] calldata _proof
3566     ) private view returns (bool) {
3567         return
3568             MerkleProof.verify(
3569                 _proof,
3570                 _allowlistMerkleRoot,
3571                 keccak256(abi.encodePacked(_allowlistee, _amount))
3572             );
3573     }
3574 
3575     function mintingPhase() public view returns (Phase) {
3576         if (block.timestamp > reserveMintStartTime) {
3577             return Phase.RESERVE;
3578         } else if (block.timestamp > publicMintStartTime) {
3579             return Phase.PUBLIC;
3580         } else if (block.timestamp > presaleMintStartTime) {
3581             return Phase.ALLOWLIST;
3582         } else {
3583             return Phase.INIT;
3584         }
3585     }
3586 
3587      function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
3588         // IERC165: 0x01ffc9a7, IERC721: 0x80ac58cd, IERC721Metadata: 0x5b5e139f, IERC29081: 0x2a55205a
3589         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
3590     }
3591 
3592      function _feeDenominator() internal pure override returns (uint96) {
3593         return 100;
3594     }
3595 }