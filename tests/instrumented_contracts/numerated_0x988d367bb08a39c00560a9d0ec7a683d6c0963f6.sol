1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/common/lib/BytesLib.sol
70 
71 pragma solidity ^0.5.2;
72 
73 
74 library BytesLib {
75     function concat(bytes memory _preBytes, bytes memory _postBytes)
76         internal
77         pure
78         returns (bytes memory)
79     {
80         bytes memory tempBytes;
81         assembly {
82             // Get a location of some free memory and store it in tempBytes as
83             // Solidity does for memory variables.
84             tempBytes := mload(0x40)
85 
86             // Store the length of the first bytes array at the beginning of
87             // the memory for tempBytes.
88             let length := mload(_preBytes)
89             mstore(tempBytes, length)
90 
91             // Maintain a memory counter for the current write location in the
92             // temp bytes array by adding the 32 bytes for the array length to
93             // the starting location.
94             let mc := add(tempBytes, 0x20)
95             // Stop copying when the memory counter reaches the length of the
96             // first bytes array.
97             let end := add(mc, length)
98 
99             for {
100                 // Initialize a copy counter to the start of the _preBytes data,
101                 // 32 bytes into its memory.
102                 let cc := add(_preBytes, 0x20)
103             } lt(mc, end) {
104                 // Increase both counters by 32 bytes each iteration.
105                 mc := add(mc, 0x20)
106                 cc := add(cc, 0x20)
107             } {
108                 // Write the _preBytes data into the tempBytes memory 32 bytes
109                 // at a time.
110                 mstore(mc, mload(cc))
111             }
112 
113             // Add the length of _postBytes to the current length of tempBytes
114             // and store it as the new length in the first 32 bytes of the
115             // tempBytes memory.
116             length := mload(_postBytes)
117             mstore(tempBytes, add(length, mload(tempBytes)))
118 
119             // Move the memory counter back from a multiple of 0x20 to the
120             // actual end of the _preBytes data.
121             mc := end
122             // Stop copying when the memory counter reaches the new combined
123             // length of the arrays.
124             end := add(mc, length)
125 
126             for {
127                 let cc := add(_postBytes, 0x20)
128             } lt(mc, end) {
129                 mc := add(mc, 0x20)
130                 cc := add(cc, 0x20)
131             } {
132                 mstore(mc, mload(cc))
133             }
134 
135             // Update the free-memory pointer by padding our last write location
136             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
137             // next 32 byte block, then round down to the nearest multiple of
138             // 32. If the sum of the length of the two arrays is zero then add
139             // one before rounding down to leave a blank 32 bytes (the length block with 0).
140             mstore(
141                 0x40,
142                 and(
143                     add(add(end, iszero(add(length, mload(_preBytes)))), 31),
144                     not(31) // Round down to the nearest 32 bytes.
145                 )
146             )
147         }
148         return tempBytes;
149     }
150 
151     function slice(bytes memory _bytes, uint256 _start, uint256 _length)
152         internal
153         pure
154         returns (bytes memory)
155     {
156         require(_bytes.length >= (_start + _length));
157         bytes memory tempBytes;
158         assembly {
159             switch iszero(_length)
160                 case 0 {
161                     // Get a location of some free memory and store it in tempBytes as
162                     // Solidity does for memory variables.
163                     tempBytes := mload(0x40)
164 
165                     // The first word of the slice result is potentially a partial
166                     // word read from the original array. To read it, we calculate
167                     // the length of that partial word and start copying that many
168                     // bytes into the array. The first word we copy will start with
169                     // data we don't care about, but the last `lengthmod` bytes will
170                     // land at the beginning of the contents of the new array. When
171                     // we're done copying, we overwrite the full first word with
172                     // the actual length of the slice.
173                     let lengthmod := and(_length, 31)
174 
175                     // The multiplication in the next line is necessary
176                     // because when slicing multiples of 32 bytes (lengthmod == 0)
177                     // the following copy loop was copying the origin's length
178                     // and then ending prematurely not copying everything it should.
179                     let mc := add(
180                         add(tempBytes, lengthmod),
181                         mul(0x20, iszero(lengthmod))
182                     )
183                     let end := add(mc, _length)
184 
185                     for {
186                         // The multiplication in the next line has the same exact purpose
187                         // as the one above.
188                         let cc := add(
189                             add(
190                                 add(_bytes, lengthmod),
191                                 mul(0x20, iszero(lengthmod))
192                             ),
193                             _start
194                         )
195                     } lt(mc, end) {
196                         mc := add(mc, 0x20)
197                         cc := add(cc, 0x20)
198                     } {
199                         mstore(mc, mload(cc))
200                     }
201 
202                     mstore(tempBytes, _length)
203 
204                     //update free-memory pointer
205                     //allocating the array padded to 32 bytes like the compiler does now
206                     mstore(0x40, and(add(mc, 31), not(31)))
207                 }
208                 //if we want a zero-length slice let's just return a zero-length array
209                 default {
210                     tempBytes := mload(0x40)
211                     mstore(0x40, add(tempBytes, 0x20))
212                 }
213         }
214 
215         return tempBytes;
216     }
217 
218     // Pad a bytes array to 32 bytes
219     function leftPad(bytes memory _bytes) internal pure returns (bytes memory) {
220         // may underflow if bytes.length < 32. Hence using SafeMath.sub
221         bytes memory newBytes = new bytes(SafeMath.sub(32, _bytes.length));
222         return concat(newBytes, _bytes);
223     }
224 
225     function toBytes32(bytes memory b) internal pure returns (bytes32) {
226         require(b.length >= 32, "Bytes array should atleast be 32 bytes");
227         bytes32 out;
228         for (uint256 i = 0; i < 32; i++) {
229             out |= bytes32(b[i] & 0xFF) >> (i * 8);
230         }
231         return out;
232     }
233 
234     function toBytes4(bytes memory b) internal pure returns (bytes4 result) {
235         assembly {
236             result := mload(add(b, 32))
237         }
238     }
239 
240     function fromBytes32(bytes32 x) internal pure returns (bytes memory) {
241         bytes memory b = new bytes(32);
242         for (uint256 i = 0; i < 32; i++) {
243             b[i] = bytes1(uint8(uint256(x) / (2**(8 * (31 - i)))));
244         }
245         return b;
246     }
247 
248     function fromUint(uint256 _num) internal pure returns (bytes memory _ret) {
249         _ret = new bytes(32);
250         assembly {
251             mstore(add(_ret, 32), _num)
252         }
253     }
254 
255     function toUint(bytes memory _bytes, uint256 _start)
256         internal
257         pure
258         returns (uint256)
259     {
260         require(_bytes.length >= (_start + 32));
261         uint256 tempUint;
262         assembly {
263             tempUint := mload(add(add(_bytes, 0x20), _start))
264         }
265         return tempUint;
266     }
267 
268     function toAddress(bytes memory _bytes, uint256 _start)
269         internal
270         pure
271         returns (address)
272     {
273         require(_bytes.length >= (_start + 20));
274         address tempAddress;
275         assembly {
276             tempAddress := div(
277                 mload(add(add(_bytes, 0x20), _start)),
278                 0x1000000000000000000000000
279             )
280         }
281 
282         return tempAddress;
283     }
284 }
285 
286 // File: contracts/common/lib/Common.sol
287 
288 pragma solidity ^0.5.2;
289 
290 
291 library Common {
292     function getV(bytes memory v, uint16 chainId) public pure returns (uint8) {
293         if (chainId > 0) {
294             return
295                 uint8(
296                     BytesLib.toUint(BytesLib.leftPad(v), 0) - (chainId * 2) - 8
297                 );
298         } else {
299             return uint8(BytesLib.toUint(BytesLib.leftPad(v), 0));
300         }
301     }
302 
303     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
304     function isContract(address _addr) public view returns (bool) {
305         uint256 length;
306         assembly {
307             //retrieve the size of the code on target address, this needs assembly
308             length := extcodesize(_addr)
309         }
310         return (length > 0);
311     }
312 
313     // convert bytes to uint8
314     function toUint8(bytes memory _arg) public pure returns (uint8) {
315         return uint8(_arg[0]);
316     }
317 
318     function toUint16(bytes memory _arg) public pure returns (uint16) {
319         return (uint16(uint8(_arg[0])) << 8) | uint16(uint8(_arg[1]));
320     }
321 }
322 
323 // File: openzeppelin-solidity/contracts/math/Math.sol
324 
325 pragma solidity ^0.5.2;
326 
327 /**
328  * @title Math
329  * @dev Assorted math operations
330  */
331 library Math {
332     /**
333      * @dev Returns the largest of two numbers.
334      */
335     function max(uint256 a, uint256 b) internal pure returns (uint256) {
336         return a >= b ? a : b;
337     }
338 
339     /**
340      * @dev Returns the smallest of two numbers.
341      */
342     function min(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a < b ? a : b;
344     }
345 
346     /**
347      * @dev Calculates the average of two numbers. Since these are integers,
348      * averages of an even and odd number cannot be represented, and will be
349      * rounded down.
350      */
351     function average(uint256 a, uint256 b) internal pure returns (uint256) {
352         // (a + b) / 2 can overflow, so we distribute
353         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
354     }
355 }
356 
357 // File: contracts/common/lib/RLPEncode.sol
358 
359 // Library for RLP encoding a list of bytes arrays.
360 // Modeled after ethereumjs/rlp (https://github.com/ethereumjs/rlp)
361 // [Very] modified version of Sam Mayo's library.
362 pragma solidity ^0.5.2;
363 
364 
365 library RLPEncode {
366     // Encode an item (bytes memory)
367     function encodeItem(bytes memory self)
368         internal
369         pure
370         returns (bytes memory)
371     {
372         bytes memory encoded;
373         if (self.length == 1 && uint8(self[0] & 0xFF) < 0x80) {
374             encoded = new bytes(1);
375             encoded = self;
376         } else {
377             encoded = BytesLib.concat(encodeLength(self.length, 128), self);
378         }
379         return encoded;
380     }
381 
382     // Encode a list of items
383     function encodeList(bytes[] memory self)
384         internal
385         pure
386         returns (bytes memory)
387     {
388         bytes memory encoded;
389         for (uint256 i = 0; i < self.length; i++) {
390             encoded = BytesLib.concat(encoded, encodeItem(self[i]));
391         }
392         return BytesLib.concat(encodeLength(encoded.length, 192), encoded);
393     }
394 
395     // Hack to encode nested lists. If you have a list as an item passed here, included
396     // pass = true in that index. E.g.
397     // [item, list, item] --> pass = [false, true, false]
398     // function encodeListWithPasses(bytes[] memory self, bool[] pass) internal pure returns (bytes memory) {
399     //   bytes memory encoded;
400     //   for (uint i=0; i < self.length; i++) {
401     // 		if (pass[i] == true) {
402     // 			encoded = BytesLib.concat(encoded, self[i]);
403     // 		} else {
404     // 			encoded = BytesLib.concat(encoded, encodeItem(self[i]));
405     // 		}
406     //   }
407     //   return BytesLib.concat(encodeLength(encoded.length, 192), encoded);
408     // }
409 
410     // Generate the prefix for an item or the entire list based on RLP spec
411     function encodeLength(uint256 L, uint256 offset)
412         internal
413         pure
414         returns (bytes memory)
415     {
416         if (L < 56) {
417             bytes memory prefix = new bytes(1);
418             prefix[0] = bytes1(uint8(L + offset));
419             return prefix;
420         } else {
421             // lenLen is the length of the hex representation of the data length
422             uint256 lenLen;
423             uint256 i = 0x1;
424 
425             while (L / i != 0) {
426                 lenLen++;
427                 i *= 0x100;
428             }
429 
430             bytes memory prefix0 = getLengthBytes(offset + 55 + lenLen);
431             bytes memory prefix1 = getLengthBytes(L);
432             return BytesLib.concat(prefix0, prefix1);
433         }
434     }
435 
436     function getLengthBytes(uint256 x) internal pure returns (bytes memory b) {
437         // Figure out if we need 1 or two bytes to express the length.
438         // 1 byte gets us to max 255
439         // 2 bytes gets us to max 65535 (no payloads will be larger than this)
440         uint256 nBytes = 1;
441         if (x > 255) {
442             nBytes = 2;
443         }
444 
445         b = new bytes(nBytes);
446         // Encode the length and return it
447         for (uint256 i = 0; i < nBytes; i++) {
448             b[i] = bytes1(uint8(x / (2**(8 * (nBytes - 1 - i)))));
449         }
450     }
451 }
452 
453 // File: solidity-rlp/contracts/RLPReader.sol
454 
455 // SPDX-License-Identifier: Apache-2.0
456 
457 /*
458 * @author Hamdi Allam hamdi.allam97@gmail.com
459 * Please reach out with any questions or concerns
460 */
461 pragma solidity >=0.5.0 <0.7.0;
462 
463 library RLPReader {
464     uint8 constant STRING_SHORT_START = 0x80;
465     uint8 constant STRING_LONG_START  = 0xb8;
466     uint8 constant LIST_SHORT_START   = 0xc0;
467     uint8 constant LIST_LONG_START    = 0xf8;
468     uint8 constant WORD_SIZE = 32;
469 
470     struct RLPItem {
471         uint len;
472         uint memPtr;
473     }
474 
475     struct Iterator {
476         RLPItem item;   // Item that's being iterated over.
477         uint nextPtr;   // Position of the next item in the list.
478     }
479 
480     /*
481     * @dev Returns the next element in the iteration. Reverts if it has not next element.
482     * @param self The iterator.
483     * @return The next element in the iteration.
484     */
485     function next(Iterator memory self) internal pure returns (RLPItem memory) {
486         require(hasNext(self));
487 
488         uint ptr = self.nextPtr;
489         uint itemLength = _itemLength(ptr);
490         self.nextPtr = ptr + itemLength;
491 
492         return RLPItem(itemLength, ptr);
493     }
494 
495     /*
496     * @dev Returns true if the iteration has more elements.
497     * @param self The iterator.
498     * @return true if the iteration has more elements.
499     */
500     function hasNext(Iterator memory self) internal pure returns (bool) {
501         RLPItem memory item = self.item;
502         return self.nextPtr < item.memPtr + item.len;
503     }
504 
505     /*
506     * @param item RLP encoded bytes
507     */
508     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
509         uint memPtr;
510         assembly {
511             memPtr := add(item, 0x20)
512         }
513 
514         return RLPItem(item.length, memPtr);
515     }
516 
517     /*
518     * @dev Create an iterator. Reverts if item is not a list.
519     * @param self The RLP item.
520     * @return An 'Iterator' over the item.
521     */
522     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
523         require(isList(self));
524 
525         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
526         return Iterator(self, ptr);
527     }
528 
529     /*
530     * @param the RLP item.
531     */
532     function rlpLen(RLPItem memory item) internal pure returns (uint) {
533         return item.len;
534     }
535 
536     /*
537      * @param the RLP item.
538      * @return (memPtr, len) pair: location of the item's payload in memory.
539      */
540     function payloadLocation(RLPItem memory item) internal pure returns (uint, uint) {
541         uint offset = _payloadOffset(item.memPtr);
542         uint memPtr = item.memPtr + offset;
543         uint len = item.len - offset; // data length
544         return (memPtr, len);
545     }
546 
547     /*
548     * @param the RLP item.
549     */
550     function payloadLen(RLPItem memory item) internal pure returns (uint) {
551         (, uint len) = payloadLocation(item);
552         return len;
553     }
554 
555     /*
556     * @param the RLP item containing the encoded list.
557     */
558     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
559         require(isList(item));
560 
561         uint items = numItems(item);
562         RLPItem[] memory result = new RLPItem[](items);
563 
564         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
565         uint dataLen;
566         for (uint i = 0; i < items; i++) {
567             dataLen = _itemLength(memPtr);
568             result[i] = RLPItem(dataLen, memPtr); 
569             memPtr = memPtr + dataLen;
570         }
571 
572         return result;
573     }
574 
575     // @return indicator whether encoded payload is a list. negate this function call for isData.
576     function isList(RLPItem memory item) internal pure returns (bool) {
577         if (item.len == 0) return false;
578 
579         uint8 byte0;
580         uint memPtr = item.memPtr;
581         assembly {
582             byte0 := byte(0, mload(memPtr))
583         }
584 
585         if (byte0 < LIST_SHORT_START)
586             return false;
587         return true;
588     }
589 
590     /*
591      * @dev A cheaper version of keccak256(toRlpBytes(item)) that avoids copying memory.
592      * @return keccak256 hash of RLP encoded bytes.
593      */
594     function rlpBytesKeccak256(RLPItem memory item) internal pure returns (bytes32) {
595         uint256 ptr = item.memPtr;
596         uint256 len = item.len;
597         bytes32 result;
598         assembly {
599             result := keccak256(ptr, len)
600         }
601         return result;
602     }
603 
604     /*
605      * @dev A cheaper version of keccak256(toBytes(item)) that avoids copying memory.
606      * @return keccak256 hash of the item payload.
607      */
608     function payloadKeccak256(RLPItem memory item) internal pure returns (bytes32) {
609         (uint memPtr, uint len) = payloadLocation(item);
610         bytes32 result;
611         assembly {
612             result := keccak256(memPtr, len)
613         }
614         return result;
615     }
616 
617     /** RLPItem conversions into data types **/
618 
619     // @returns raw rlp encoding in bytes
620     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
621         bytes memory result = new bytes(item.len);
622         if (result.length == 0) return result;
623         
624         uint ptr;
625         assembly {
626             ptr := add(0x20, result)
627         }
628 
629         copy(item.memPtr, ptr, item.len);
630         return result;
631     }
632 
633     // any non-zero byte except "0x80" is considered true
634     function toBoolean(RLPItem memory item) internal pure returns (bool) {
635         require(item.len == 1);
636         uint result;
637         uint memPtr = item.memPtr;
638         assembly {
639             result := byte(0, mload(memPtr))
640         }
641 
642         // SEE Github Issue #5.
643         // Summary: Most commonly used RLP libraries (i.e Geth) will encode
644         // "0" as "0x80" instead of as "0". We handle this edge case explicitly
645         // here.
646         if (result == 0 || result == STRING_SHORT_START) {
647             return false;
648         } else {
649             return true;
650         }
651     }
652 
653     function toAddress(RLPItem memory item) internal pure returns (address) {
654         // 1 byte for the length prefix
655         require(item.len == 21);
656 
657         return address(toUint(item));
658     }
659 
660     function toUint(RLPItem memory item) internal pure returns (uint) {
661         require(item.len > 0 && item.len <= 33);
662 
663         (uint memPtr, uint len) = payloadLocation(item);
664 
665         uint result;
666         assembly {
667             result := mload(memPtr)
668 
669             // shfit to the correct location if neccesary
670             if lt(len, 32) {
671                 result := div(result, exp(256, sub(32, len)))
672             }
673         }
674 
675         return result;
676     }
677 
678     // enforces 32 byte length
679     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
680         // one byte prefix
681         require(item.len == 33);
682 
683         uint result;
684         uint memPtr = item.memPtr + 1;
685         assembly {
686             result := mload(memPtr)
687         }
688 
689         return result;
690     }
691 
692     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
693         require(item.len > 0);
694 
695         (uint memPtr, uint len) = payloadLocation(item);
696         bytes memory result = new bytes(len);
697 
698         uint destPtr;
699         assembly {
700             destPtr := add(0x20, result)
701         }
702 
703         copy(memPtr, destPtr, len);
704         return result;
705     }
706 
707     /*
708     * Private Helpers
709     */
710 
711     // @return number of payload items inside an encoded list.
712     function numItems(RLPItem memory item) private pure returns (uint) {
713         if (item.len == 0) return 0;
714 
715         uint count = 0;
716         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
717         uint endPtr = item.memPtr + item.len;
718         while (currPtr < endPtr) {
719            currPtr = currPtr + _itemLength(currPtr); // skip over an item
720            count++;
721         }
722 
723         return count;
724     }
725 
726     // @return entire rlp item byte length
727     function _itemLength(uint memPtr) private pure returns (uint) {
728         uint itemLen;
729         uint byte0;
730         assembly {
731             byte0 := byte(0, mload(memPtr))
732         }
733 
734         if (byte0 < STRING_SHORT_START)
735             itemLen = 1;
736         
737         else if (byte0 < STRING_LONG_START)
738             itemLen = byte0 - STRING_SHORT_START + 1;
739 
740         else if (byte0 < LIST_SHORT_START) {
741             assembly {
742                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
743                 memPtr := add(memPtr, 1) // skip over the first byte
744                 
745                 /* 32 byte word size */
746                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
747                 itemLen := add(dataLen, add(byteLen, 1))
748             }
749         }
750 
751         else if (byte0 < LIST_LONG_START) {
752             itemLen = byte0 - LIST_SHORT_START + 1;
753         } 
754 
755         else {
756             assembly {
757                 let byteLen := sub(byte0, 0xf7)
758                 memPtr := add(memPtr, 1)
759 
760                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
761                 itemLen := add(dataLen, add(byteLen, 1))
762             }
763         }
764 
765         return itemLen;
766     }
767 
768     // @return number of bytes until the data
769     function _payloadOffset(uint memPtr) private pure returns (uint) {
770         uint byte0;
771         assembly {
772             byte0 := byte(0, mload(memPtr))
773         }
774 
775         if (byte0 < STRING_SHORT_START) 
776             return 0;
777         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
778             return 1;
779         else if (byte0 < LIST_SHORT_START)  // being explicit
780             return byte0 - (STRING_LONG_START - 1) + 1;
781         else
782             return byte0 - (LIST_LONG_START - 1) + 1;
783     }
784 
785     /*
786     * @param src Pointer to source
787     * @param dest Pointer to destination
788     * @param len Amount of memory to copy from the source
789     */
790     function copy(uint src, uint dest, uint len) private pure {
791         if (len == 0) return;
792 
793         // copy as many word sizes as possible
794         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
795             assembly {
796                 mstore(dest, mload(src))
797             }
798 
799             src += WORD_SIZE;
800             dest += WORD_SIZE;
801         }
802 
803         // left over bytes. Mask is used to remove unwanted bytes from the word
804         uint mask = 256 ** (WORD_SIZE - len) - 1;
805         assembly {
806             let srcpart := and(mload(src), not(mask)) // zero out src
807             let destpart := and(mload(dest), mask) // retrieve the bytes
808             mstore(dest, or(destpart, srcpart))
809         }
810     }
811 }
812 
813 // File: contracts/root/withdrawManager/IWithdrawManager.sol
814 
815 pragma solidity ^0.5.2;
816 
817 contract IWithdrawManager {
818     function createExitQueue(address token) external;
819 
820     function verifyInclusion(
821         bytes calldata data,
822         uint8 offset,
823         bool verifyTxInclusion
824     ) external view returns (uint256 age);
825 
826     function addExitToQueue(
827         address exitor,
828         address childToken,
829         address rootToken,
830         uint256 exitAmountOrTokenId,
831         bytes32 txHash,
832         bool isRegularExit,
833         uint256 priority
834     ) external;
835 
836     function addInput(
837         uint256 exitId,
838         uint256 age,
839         address utxoOwner,
840         address token
841     ) external;
842 
843     function challengeExit(
844         uint256 exitId,
845         uint256 inputId,
846         bytes calldata challengeData,
847         address adjudicatorPredicate
848     ) external;
849 }
850 
851 // File: contracts/root/depositManager/IDepositManager.sol
852 
853 pragma solidity ^0.5.2;
854 
855 interface IDepositManager {
856     function depositEther() external payable;
857     function transferAssets(
858         address _token,
859         address _user,
860         uint256 _amountOrNFTId
861     ) external;
862     function depositERC20(address _token, uint256 _amount) external;
863     function depositERC721(address _token, uint256 _tokenId) external;
864 }
865 
866 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
867 
868 pragma solidity ^0.5.2;
869 
870 /**
871  * @title Ownable
872  * @dev The Ownable contract has an owner address, and provides basic authorization control
873  * functions, this simplifies the implementation of "user permissions".
874  */
875 contract Ownable {
876     address private _owner;
877 
878     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
879 
880     /**
881      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
882      * account.
883      */
884     constructor () internal {
885         _owner = msg.sender;
886         emit OwnershipTransferred(address(0), _owner);
887     }
888 
889     /**
890      * @return the address of the owner.
891      */
892     function owner() public view returns (address) {
893         return _owner;
894     }
895 
896     /**
897      * @dev Throws if called by any account other than the owner.
898      */
899     modifier onlyOwner() {
900         require(isOwner());
901         _;
902     }
903 
904     /**
905      * @return true if `msg.sender` is the owner of the contract.
906      */
907     function isOwner() public view returns (bool) {
908         return msg.sender == _owner;
909     }
910 
911     /**
912      * @dev Allows the current owner to relinquish control of the contract.
913      * It will not be possible to call the functions with the `onlyOwner`
914      * modifier anymore.
915      * @notice Renouncing ownership will leave the contract without an owner,
916      * thereby removing any functionality that is only available to the owner.
917      */
918     function renounceOwnership() public onlyOwner {
919         emit OwnershipTransferred(_owner, address(0));
920         _owner = address(0);
921     }
922 
923     /**
924      * @dev Allows the current owner to transfer control of the contract to a newOwner.
925      * @param newOwner The address to transfer ownership to.
926      */
927     function transferOwnership(address newOwner) public onlyOwner {
928         _transferOwnership(newOwner);
929     }
930 
931     /**
932      * @dev Transfers control of the contract to a newOwner.
933      * @param newOwner The address to transfer ownership to.
934      */
935     function _transferOwnership(address newOwner) internal {
936         require(newOwner != address(0));
937         emit OwnershipTransferred(_owner, newOwner);
938         _owner = newOwner;
939     }
940 }
941 
942 // File: contracts/common/misc/ProxyStorage.sol
943 
944 pragma solidity ^0.5.2;
945 
946 
947 contract ProxyStorage is Ownable {
948     address internal proxyTo;
949 }
950 
951 // File: contracts/common/governance/IGovernance.sol
952 
953 pragma solidity ^0.5.2;
954 
955 interface IGovernance {
956     function update(address target, bytes calldata data) external;
957 }
958 
959 // File: contracts/common/governance/Governable.sol
960 
961 pragma solidity ^0.5.2;
962 
963 
964 contract Governable {
965     IGovernance public governance;
966 
967     constructor(address _governance) public {
968         governance = IGovernance(_governance);
969     }
970 
971     modifier onlyGovernance() {
972         _assertGovernance();
973         _;
974     }
975 
976     function _assertGovernance() private view {
977         require(
978             msg.sender == address(governance),
979             "Only governance contract is authorized"
980         );
981     }
982 }
983 
984 // File: contracts/common/Registry.sol
985 
986 pragma solidity ^0.5.2;
987 
988 
989 
990 
991 contract Registry is Governable {
992     // @todo hardcode constants
993     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
994     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
995     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
996     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
997     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
998     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
999     bytes32 private constant STATE_SENDER = keccak256("stateSender");
1000     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
1001 
1002     address public erc20Predicate;
1003     address public erc721Predicate;
1004 
1005     mapping(bytes32 => address) public contractMap;
1006     mapping(address => address) public rootToChildToken;
1007     mapping(address => address) public childToRootToken;
1008     mapping(address => bool) public proofValidatorContracts;
1009     mapping(address => bool) public isERC721;
1010 
1011     enum Type {Invalid, ERC20, ERC721, Custom}
1012     struct Predicate {
1013         Type _type;
1014     }
1015     mapping(address => Predicate) public predicates;
1016 
1017     event TokenMapped(address indexed rootToken, address indexed childToken);
1018     event ProofValidatorAdded(address indexed validator, address indexed from);
1019     event ProofValidatorRemoved(address indexed validator, address indexed from);
1020     event PredicateAdded(address indexed predicate, address indexed from);
1021     event PredicateRemoved(address indexed predicate, address indexed from);
1022     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
1023 
1024     constructor(address _governance) public Governable(_governance) {}
1025 
1026     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
1027         emit ContractMapUpdated(_key, contractMap[_key], _address);
1028         contractMap[_key] = _address;
1029     }
1030 
1031     /**
1032      * @dev Map root token to child token
1033      * @param _rootToken Token address on the root chain
1034      * @param _childToken Token address on the child chain
1035      * @param _isERC721 Is the token being mapped ERC721
1036      */
1037     function mapToken(
1038         address _rootToken,
1039         address _childToken,
1040         bool _isERC721
1041     ) external onlyGovernance {
1042         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
1043         rootToChildToken[_rootToken] = _childToken;
1044         childToRootToken[_childToken] = _rootToken;
1045         isERC721[_rootToken] = _isERC721;
1046         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
1047         emit TokenMapped(_rootToken, _childToken);
1048     }
1049 
1050     function addErc20Predicate(address predicate) public onlyGovernance {
1051         require(predicate != address(0x0), "Can not add null address as predicate");
1052         erc20Predicate = predicate;
1053         addPredicate(predicate, Type.ERC20);
1054     }
1055 
1056     function addErc721Predicate(address predicate) public onlyGovernance {
1057         erc721Predicate = predicate;
1058         addPredicate(predicate, Type.ERC721);
1059     }
1060 
1061     function addPredicate(address predicate, Type _type) public onlyGovernance {
1062         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
1063         predicates[predicate]._type = _type;
1064         emit PredicateAdded(predicate, msg.sender);
1065     }
1066 
1067     function removePredicate(address predicate) public onlyGovernance {
1068         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
1069         delete predicates[predicate];
1070         emit PredicateRemoved(predicate, msg.sender);
1071     }
1072 
1073     function getValidatorShareAddress() public view returns (address) {
1074         return contractMap[VALIDATOR_SHARE];
1075     }
1076 
1077     function getWethTokenAddress() public view returns (address) {
1078         return contractMap[WETH_TOKEN];
1079     }
1080 
1081     function getDepositManagerAddress() public view returns (address) {
1082         return contractMap[DEPOSIT_MANAGER];
1083     }
1084 
1085     function getStakeManagerAddress() public view returns (address) {
1086         return contractMap[STAKE_MANAGER];
1087     }
1088 
1089     function getSlashingManagerAddress() public view returns (address) {
1090         return contractMap[SLASHING_MANAGER];
1091     }
1092 
1093     function getWithdrawManagerAddress() public view returns (address) {
1094         return contractMap[WITHDRAW_MANAGER];
1095     }
1096 
1097     function getChildChainAndStateSender() public view returns (address, address) {
1098         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
1099     }
1100 
1101     function isTokenMapped(address _token) public view returns (bool) {
1102         return rootToChildToken[_token] != address(0x0);
1103     }
1104 
1105     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
1106         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
1107         return isERC721[_token];
1108     }
1109 
1110     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
1111         if (isTokenMappedAndIsErc721(_token)) {
1112             return erc721Predicate;
1113         }
1114         return erc20Predicate;
1115     }
1116 
1117     function isChildTokenErc721(address childToken) public view returns (bool) {
1118         address rootToken = childToRootToken[childToken];
1119         require(rootToken != address(0x0), "Child token is not mapped");
1120         return isERC721[rootToken];
1121     }
1122 }
1123 
1124 // File: contracts/common/mixin/ChainIdMixin.sol
1125 
1126 pragma solidity ^0.5.2;
1127 
1128 contract ChainIdMixin {
1129   bytes constant public networkId = hex"89";
1130   uint256 constant public CHAINID = 137;
1131 }
1132 
1133 // File: contracts/root/RootChainStorage.sol
1134 
1135 pragma solidity ^0.5.2;
1136 
1137 
1138 
1139 
1140 
1141 contract RootChainHeader {
1142     event NewHeaderBlock(
1143         address indexed proposer,
1144         uint256 indexed headerBlockId,
1145         uint256 indexed reward,
1146         uint256 start,
1147         uint256 end,
1148         bytes32 root
1149     );
1150     // housekeeping event
1151     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
1152     struct HeaderBlock {
1153         bytes32 root;
1154         uint256 start;
1155         uint256 end;
1156         uint256 createdAt;
1157         address proposer;
1158     }
1159 }
1160 
1161 
1162 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
1163     bytes32 public heimdallId;
1164     uint8 public constant VOTE_TYPE = 2;
1165 
1166     uint16 internal constant MAX_DEPOSITS = 10000;
1167     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
1168     uint256 internal _blockDepositId = 1;
1169     mapping(uint256 => HeaderBlock) public headerBlocks;
1170     Registry internal registry;
1171 }
1172 
1173 // File: contracts/staking/stakeManager/IStakeManager.sol
1174 
1175 pragma solidity 0.5.17;
1176 
1177 contract IStakeManager {
1178     // validator replacement
1179     function startAuction(
1180         uint256 validatorId,
1181         uint256 amount,
1182         bool acceptDelegation,
1183         bytes calldata signerPubkey
1184     ) external;
1185 
1186     function confirmAuctionBid(uint256 validatorId, uint256 heimdallFee) external;
1187 
1188     function transferFunds(
1189         uint256 validatorId,
1190         uint256 amount,
1191         address delegator
1192     ) external returns (bool);
1193 
1194     function delegationDeposit(
1195         uint256 validatorId,
1196         uint256 amount,
1197         address delegator
1198     ) external returns (bool);
1199 
1200     function unstake(uint256 validatorId) external;
1201 
1202     function totalStakedFor(address addr) external view returns (uint256);
1203 
1204     function stakeFor(
1205         address user,
1206         uint256 amount,
1207         uint256 heimdallFee,
1208         bool acceptDelegation,
1209         bytes memory signerPubkey
1210     ) public;
1211 
1212     function checkSignatures(
1213         uint256 blockInterval,
1214         bytes32 voteHash,
1215         bytes32 stateRoot,
1216         address proposer,
1217         uint[3][] calldata sigs
1218     ) external returns (uint256);
1219 
1220     function updateValidatorState(uint256 validatorId, int256 amount) public;
1221 
1222     function ownerOf(uint256 tokenId) public view returns (address);
1223 
1224     function slash(bytes calldata slashingInfoList) external returns (uint256);
1225 
1226     function validatorStake(uint256 validatorId) public view returns (uint256);
1227 
1228     function epoch() public view returns (uint256);
1229 
1230     function getRegistry() public view returns (address);
1231 
1232     function withdrawalDelay() public view returns (uint256);
1233 
1234     function delegatedAmount(uint256 validatorId) public view returns(uint256);
1235 
1236     function decreaseValidatorDelegatedAmount(uint256 validatorId, uint256 amount) public;
1237 
1238     function withdrawDelegatorsReward(uint256 validatorId) public returns(uint256);
1239 
1240     function delegatorsReward(uint256 validatorId) public view returns(uint256);
1241 
1242     function dethroneAndStake(
1243         address auctionUser,
1244         uint256 heimdallFee,
1245         uint256 validatorId,
1246         uint256 auctionAmount,
1247         bool acceptDelegation,
1248         bytes calldata signerPubkey
1249     ) external;
1250 }
1251 
1252 // File: contracts/root/IRootChain.sol
1253 
1254 pragma solidity ^0.5.2;
1255 
1256 
1257 interface IRootChain {
1258     function slash() external;
1259 
1260     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
1261         external;
1262     
1263     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs)
1264         external;
1265 
1266     function getLastChildBlock() external view returns (uint256);
1267 
1268     function currentHeaderBlock() external view returns (uint256);
1269 }
1270 
1271 // File: contracts/root/RootChain.sol
1272 
1273 pragma solidity ^0.5.2;
1274 
1275 
1276 
1277 
1278 
1279 
1280 
1281 
1282 contract RootChain is RootChainStorage, IRootChain {
1283     using SafeMath for uint256;
1284     using RLPReader for bytes;
1285     using RLPReader for RLPReader.RLPItem;
1286 
1287     modifier onlyDepositManager() {
1288         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
1289         _;
1290     }
1291 
1292     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
1293         revert();
1294     }
1295 
1296     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
1297         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
1298             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
1299         require(CHAINID == _borChainID, "Invalid bor chain id");
1300 
1301         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
1302 
1303         // check if it is better to keep it in local storage instead
1304         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
1305         uint256 _reward = stakeManager.checkSignatures(
1306             end.sub(start).add(1),
1307             /**  
1308                 prefix 01 to data 
1309                 01 represents positive vote on data and 00 is negative vote
1310                 malicious validator can try to send 2/3 on negative vote so 01 is appended
1311              */
1312             keccak256(abi.encodePacked(bytes(hex"01"), data)),
1313             accountHash,
1314             proposer,
1315             sigs
1316         );
1317 
1318         require(_reward != 0, "Invalid checkpoint");
1319         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
1320         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
1321         _blockDepositId = 1;
1322     }
1323 
1324     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
1325         depositId = currentHeaderBlock().add(_blockDepositId);
1326         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
1327         _blockDepositId = _blockDepositId.add(numDeposits);
1328         require(
1329             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
1330             _blockDepositId <= MAX_DEPOSITS,
1331             "TOO_MANY_DEPOSITS"
1332         );
1333     }
1334 
1335     function getLastChildBlock() external view returns (uint256) {
1336         return headerBlocks[currentHeaderBlock()].end;
1337     }
1338 
1339     function slash() external {
1340         //TODO: future implementation
1341     }
1342 
1343     function currentHeaderBlock() public view returns (uint256) {
1344         return _nextHeaderBlock.sub(MAX_DEPOSITS);
1345     }
1346 
1347     function _buildHeaderBlock(
1348         address proposer,
1349         uint256 start,
1350         uint256 end,
1351         bytes32 rootHash
1352     ) private returns (bool) {
1353         uint256 nextChildBlock;
1354         /*
1355     The ID of the 1st header block is MAX_DEPOSITS.
1356     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
1357     */
1358         if (_nextHeaderBlock > MAX_DEPOSITS) {
1359             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
1360         }
1361         if (nextChildBlock != start) {
1362             return false;
1363         }
1364 
1365         HeaderBlock memory headerBlock = HeaderBlock({
1366             root: rootHash,
1367             start: nextChildBlock,
1368             end: end,
1369             createdAt: now,
1370             proposer: proposer
1371         });
1372 
1373         headerBlocks[_nextHeaderBlock] = headerBlock;
1374         return true;
1375     }
1376 
1377     // Housekeeping function. @todo remove later
1378     function setNextHeaderBlock(uint256 _value) public onlyOwner {
1379         require(_value % MAX_DEPOSITS == 0, "Invalid value");
1380         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
1381             delete headerBlocks[i];
1382         }
1383         _nextHeaderBlock = _value;
1384         _blockDepositId = 1;
1385         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
1386     }
1387 
1388     // Housekeeping function. @todo remove later
1389     function setHeimdallId(string memory _heimdallId) public onlyOwner {
1390         heimdallId = keccak256(abi.encodePacked(_heimdallId));
1391     }
1392 }
1393 
1394 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
1395 
1396 pragma solidity ^0.5.2;
1397 
1398 /**
1399  * @title IERC165
1400  * @dev https://eips.ethereum.org/EIPS/eip-165
1401  */
1402 interface IERC165 {
1403     /**
1404      * @notice Query if a contract implements an interface
1405      * @param interfaceId The interface identifier, as specified in ERC-165
1406      * @dev Interface identification is specified in ERC-165. This function
1407      * uses less than 30,000 gas.
1408      */
1409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1410 }
1411 
1412 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
1413 
1414 pragma solidity ^0.5.2;
1415 
1416 
1417 /**
1418  * @title ERC721 Non-Fungible Token Standard basic interface
1419  * @dev see https://eips.ethereum.org/EIPS/eip-721
1420  */
1421 contract IERC721 is IERC165 {
1422     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1423     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1424     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1425 
1426     function balanceOf(address owner) public view returns (uint256 balance);
1427     function ownerOf(uint256 tokenId) public view returns (address owner);
1428 
1429     function approve(address to, uint256 tokenId) public;
1430     function getApproved(uint256 tokenId) public view returns (address operator);
1431 
1432     function setApprovalForAll(address operator, bool _approved) public;
1433     function isApprovedForAll(address owner, address operator) public view returns (bool);
1434 
1435     function transferFrom(address from, address to, uint256 tokenId) public;
1436     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1437 
1438     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1439 }
1440 
1441 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
1442 
1443 pragma solidity ^0.5.2;
1444 
1445 /**
1446  * @title ERC721 token receiver interface
1447  * @dev Interface for any contract that wants to support safeTransfers
1448  * from ERC721 asset contracts.
1449  */
1450 contract IERC721Receiver {
1451     /**
1452      * @notice Handle the receipt of an NFT
1453      * @dev The ERC721 smart contract calls this function on the recipient
1454      * after a `safeTransfer`. This function MUST return the function selector,
1455      * otherwise the caller will revert the transaction. The selector to be
1456      * returned can be obtained as `this.onERC721Received.selector`. This
1457      * function MAY throw to revert and reject the transfer.
1458      * Note: the ERC721 contract address is always the message sender.
1459      * @param operator The address which called `safeTransferFrom` function
1460      * @param from The address which previously owned the token
1461      * @param tokenId The NFT identifier which is being transferred
1462      * @param data Additional data with no specified format
1463      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1464      */
1465     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1466     public returns (bytes4);
1467 }
1468 
1469 // File: openzeppelin-solidity/contracts/utils/Address.sol
1470 
1471 pragma solidity ^0.5.2;
1472 
1473 /**
1474  * Utility library of inline functions on addresses
1475  */
1476 library Address {
1477     /**
1478      * Returns whether the target address is a contract
1479      * @dev This function will return false if invoked during the constructor of a contract,
1480      * as the code is not actually created until after the constructor finishes.
1481      * @param account address of the account to check
1482      * @return whether the target address is a contract
1483      */
1484     function isContract(address account) internal view returns (bool) {
1485         uint256 size;
1486         // XXX Currently there is no better way to check if there is a contract in an address
1487         // than to check the size of the code at that address.
1488         // See https://ethereum.stackexchange.com/a/14016/36603
1489         // for more details about how this works.
1490         // TODO Check this again before the Serenity release, because all addresses will be
1491         // contracts then.
1492         // solhint-disable-next-line no-inline-assembly
1493         assembly { size := extcodesize(account) }
1494         return size > 0;
1495     }
1496 }
1497 
1498 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
1499 
1500 pragma solidity ^0.5.2;
1501 
1502 
1503 /**
1504  * @title Counters
1505  * @author Matt Condon (@shrugs)
1506  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1507  * of elements in a mapping, issuing ERC721 ids, or counting request ids
1508  *
1509  * Include with `using Counters for Counters.Counter;`
1510  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
1511  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1512  * directly accessed.
1513  */
1514 library Counters {
1515     using SafeMath for uint256;
1516 
1517     struct Counter {
1518         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1519         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1520         // this feature: see https://github.com/ethereum/solidity/issues/4637
1521         uint256 _value; // default: 0
1522     }
1523 
1524     function current(Counter storage counter) internal view returns (uint256) {
1525         return counter._value;
1526     }
1527 
1528     function increment(Counter storage counter) internal {
1529         counter._value += 1;
1530     }
1531 
1532     function decrement(Counter storage counter) internal {
1533         counter._value = counter._value.sub(1);
1534     }
1535 }
1536 
1537 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
1538 
1539 pragma solidity ^0.5.2;
1540 
1541 
1542 /**
1543  * @title ERC165
1544  * @author Matt Condon (@shrugs)
1545  * @dev Implements ERC165 using a lookup table.
1546  */
1547 contract ERC165 is IERC165 {
1548     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1549     /*
1550      * 0x01ffc9a7 ===
1551      *     bytes4(keccak256('supportsInterface(bytes4)'))
1552      */
1553 
1554     /**
1555      * @dev a mapping of interface id to whether or not it's supported
1556      */
1557     mapping(bytes4 => bool) private _supportedInterfaces;
1558 
1559     /**
1560      * @dev A contract implementing SupportsInterfaceWithLookup
1561      * implement ERC165 itself
1562      */
1563     constructor () internal {
1564         _registerInterface(_INTERFACE_ID_ERC165);
1565     }
1566 
1567     /**
1568      * @dev implement supportsInterface(bytes4) using a lookup table
1569      */
1570     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1571         return _supportedInterfaces[interfaceId];
1572     }
1573 
1574     /**
1575      * @dev internal method for registering an interface
1576      */
1577     function _registerInterface(bytes4 interfaceId) internal {
1578         require(interfaceId != 0xffffffff);
1579         _supportedInterfaces[interfaceId] = true;
1580     }
1581 }
1582 
1583 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1584 
1585 pragma solidity ^0.5.2;
1586 
1587 
1588 
1589 
1590 
1591 
1592 
1593 /**
1594  * @title ERC721 Non-Fungible Token Standard basic implementation
1595  * @dev see https://eips.ethereum.org/EIPS/eip-721
1596  */
1597 contract ERC721 is ERC165, IERC721 {
1598     using SafeMath for uint256;
1599     using Address for address;
1600     using Counters for Counters.Counter;
1601 
1602     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1603     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1604     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1605 
1606     // Mapping from token ID to owner
1607     mapping (uint256 => address) private _tokenOwner;
1608 
1609     // Mapping from token ID to approved address
1610     mapping (uint256 => address) private _tokenApprovals;
1611 
1612     // Mapping from owner to number of owned token
1613     mapping (address => Counters.Counter) private _ownedTokensCount;
1614 
1615     // Mapping from owner to operator approvals
1616     mapping (address => mapping (address => bool)) private _operatorApprovals;
1617 
1618     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1619     /*
1620      * 0x80ac58cd ===
1621      *     bytes4(keccak256('balanceOf(address)')) ^
1622      *     bytes4(keccak256('ownerOf(uint256)')) ^
1623      *     bytes4(keccak256('approve(address,uint256)')) ^
1624      *     bytes4(keccak256('getApproved(uint256)')) ^
1625      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1626      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1627      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1628      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1629      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1630      */
1631 
1632     constructor () public {
1633         // register the supported interfaces to conform to ERC721 via ERC165
1634         _registerInterface(_INTERFACE_ID_ERC721);
1635     }
1636 
1637     /**
1638      * @dev Gets the balance of the specified address
1639      * @param owner address to query the balance of
1640      * @return uint256 representing the amount owned by the passed address
1641      */
1642     function balanceOf(address owner) public view returns (uint256) {
1643         require(owner != address(0));
1644         return _ownedTokensCount[owner].current();
1645     }
1646 
1647     /**
1648      * @dev Gets the owner of the specified token ID
1649      * @param tokenId uint256 ID of the token to query the owner of
1650      * @return address currently marked as the owner of the given token ID
1651      */
1652     function ownerOf(uint256 tokenId) public view returns (address) {
1653         address owner = _tokenOwner[tokenId];
1654         require(owner != address(0));
1655         return owner;
1656     }
1657 
1658     /**
1659      * @dev Approves another address to transfer the given token ID
1660      * The zero address indicates there is no approved address.
1661      * There can only be one approved address per token at a given time.
1662      * Can only be called by the token owner or an approved operator.
1663      * @param to address to be approved for the given token ID
1664      * @param tokenId uint256 ID of the token to be approved
1665      */
1666     function approve(address to, uint256 tokenId) public {
1667         address owner = ownerOf(tokenId);
1668         require(to != owner);
1669         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1670 
1671         _tokenApprovals[tokenId] = to;
1672         emit Approval(owner, to, tokenId);
1673     }
1674 
1675     /**
1676      * @dev Gets the approved address for a token ID, or zero if no address set
1677      * Reverts if the token ID does not exist.
1678      * @param tokenId uint256 ID of the token to query the approval of
1679      * @return address currently approved for the given token ID
1680      */
1681     function getApproved(uint256 tokenId) public view returns (address) {
1682         require(_exists(tokenId));
1683         return _tokenApprovals[tokenId];
1684     }
1685 
1686     /**
1687      * @dev Sets or unsets the approval of a given operator
1688      * An operator is allowed to transfer all tokens of the sender on their behalf
1689      * @param to operator address to set the approval
1690      * @param approved representing the status of the approval to be set
1691      */
1692     function setApprovalForAll(address to, bool approved) public {
1693         require(to != msg.sender);
1694         _operatorApprovals[msg.sender][to] = approved;
1695         emit ApprovalForAll(msg.sender, to, approved);
1696     }
1697 
1698     /**
1699      * @dev Tells whether an operator is approved by a given owner
1700      * @param owner owner address which you want to query the approval of
1701      * @param operator operator address which you want to query the approval of
1702      * @return bool whether the given operator is approved by the given owner
1703      */
1704     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1705         return _operatorApprovals[owner][operator];
1706     }
1707 
1708     /**
1709      * @dev Transfers the ownership of a given token ID to another address
1710      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1711      * Requires the msg.sender to be the owner, approved, or operator
1712      * @param from current owner of the token
1713      * @param to address to receive the ownership of the given token ID
1714      * @param tokenId uint256 ID of the token to be transferred
1715      */
1716     function transferFrom(address from, address to, uint256 tokenId) public {
1717         require(_isApprovedOrOwner(msg.sender, tokenId));
1718 
1719         _transferFrom(from, to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev Safely transfers the ownership of a given token ID to another address
1724      * If the target address is a contract, it must implement `onERC721Received`,
1725      * which is called upon a safe transfer, and return the magic value
1726      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1727      * the transfer is reverted.
1728      * Requires the msg.sender to be the owner, approved, or operator
1729      * @param from current owner of the token
1730      * @param to address to receive the ownership of the given token ID
1731      * @param tokenId uint256 ID of the token to be transferred
1732      */
1733     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1734         safeTransferFrom(from, to, tokenId, "");
1735     }
1736 
1737     /**
1738      * @dev Safely transfers the ownership of a given token ID to another address
1739      * If the target address is a contract, it must implement `onERC721Received`,
1740      * which is called upon a safe transfer, and return the magic value
1741      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1742      * the transfer is reverted.
1743      * Requires the msg.sender to be the owner, approved, or operator
1744      * @param from current owner of the token
1745      * @param to address to receive the ownership of the given token ID
1746      * @param tokenId uint256 ID of the token to be transferred
1747      * @param _data bytes data to send along with a safe transfer check
1748      */
1749     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1750         transferFrom(from, to, tokenId);
1751         require(_checkOnERC721Received(from, to, tokenId, _data));
1752     }
1753 
1754     /**
1755      * @dev Returns whether the specified token exists
1756      * @param tokenId uint256 ID of the token to query the existence of
1757      * @return bool whether the token exists
1758      */
1759     function _exists(uint256 tokenId) internal view returns (bool) {
1760         address owner = _tokenOwner[tokenId];
1761         return owner != address(0);
1762     }
1763 
1764     /**
1765      * @dev Returns whether the given spender can transfer a given token ID
1766      * @param spender address of the spender to query
1767      * @param tokenId uint256 ID of the token to be transferred
1768      * @return bool whether the msg.sender is approved for the given token ID,
1769      * is an operator of the owner, or is the owner of the token
1770      */
1771     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1772         address owner = ownerOf(tokenId);
1773         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1774     }
1775 
1776     /**
1777      * @dev Internal function to mint a new token
1778      * Reverts if the given token ID already exists
1779      * @param to The address that will own the minted token
1780      * @param tokenId uint256 ID of the token to be minted
1781      */
1782     function _mint(address to, uint256 tokenId) internal {
1783         require(to != address(0));
1784         require(!_exists(tokenId));
1785 
1786         _tokenOwner[tokenId] = to;
1787         _ownedTokensCount[to].increment();
1788 
1789         emit Transfer(address(0), to, tokenId);
1790     }
1791 
1792     /**
1793      * @dev Internal function to burn a specific token
1794      * Reverts if the token does not exist
1795      * Deprecated, use _burn(uint256) instead.
1796      * @param owner owner of the token to burn
1797      * @param tokenId uint256 ID of the token being burned
1798      */
1799     function _burn(address owner, uint256 tokenId) internal {
1800         require(ownerOf(tokenId) == owner);
1801 
1802         _clearApproval(tokenId);
1803 
1804         _ownedTokensCount[owner].decrement();
1805         _tokenOwner[tokenId] = address(0);
1806 
1807         emit Transfer(owner, address(0), tokenId);
1808     }
1809 
1810     /**
1811      * @dev Internal function to burn a specific token
1812      * Reverts if the token does not exist
1813      * @param tokenId uint256 ID of the token being burned
1814      */
1815     function _burn(uint256 tokenId) internal {
1816         _burn(ownerOf(tokenId), tokenId);
1817     }
1818 
1819     /**
1820      * @dev Internal function to transfer ownership of a given token ID to another address.
1821      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1822      * @param from current owner of the token
1823      * @param to address to receive the ownership of the given token ID
1824      * @param tokenId uint256 ID of the token to be transferred
1825      */
1826     function _transferFrom(address from, address to, uint256 tokenId) internal {
1827         require(ownerOf(tokenId) == from);
1828         require(to != address(0));
1829 
1830         _clearApproval(tokenId);
1831 
1832         _ownedTokensCount[from].decrement();
1833         _ownedTokensCount[to].increment();
1834 
1835         _tokenOwner[tokenId] = to;
1836 
1837         emit Transfer(from, to, tokenId);
1838     }
1839 
1840     /**
1841      * @dev Internal function to invoke `onERC721Received` on a target address
1842      * The call is not executed if the target address is not a contract
1843      * @param from address representing the previous owner of the given token ID
1844      * @param to target address that will receive the tokens
1845      * @param tokenId uint256 ID of the token to be transferred
1846      * @param _data bytes optional data to send along with the call
1847      * @return bool whether the call correctly returned the expected magic value
1848      */
1849     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1850         internal returns (bool)
1851     {
1852         if (!to.isContract()) {
1853             return true;
1854         }
1855 
1856         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1857         return (retval == _ERC721_RECEIVED);
1858     }
1859 
1860     /**
1861      * @dev Private function to clear current approval of a given token ID
1862      * @param tokenId uint256 ID of the token to be transferred
1863      */
1864     function _clearApproval(uint256 tokenId) private {
1865         if (_tokenApprovals[tokenId] != address(0)) {
1866             _tokenApprovals[tokenId] = address(0);
1867         }
1868     }
1869 }
1870 
1871 // File: contracts/root/withdrawManager/ExitNFT.sol
1872 
1873 pragma solidity ^0.5.2;
1874 
1875 
1876 
1877 contract ExitNFT is ERC721 {
1878     Registry internal registry;
1879 
1880     modifier onlyWithdrawManager() {
1881         require(
1882             msg.sender == registry.getWithdrawManagerAddress(),
1883             "UNAUTHORIZED_WITHDRAW_MANAGER_ONLY"
1884         );
1885         _;
1886     }
1887 
1888     constructor(address _registry) public {
1889         registry = Registry(_registry);
1890     }
1891 
1892     function mint(address _owner, uint256 _tokenId)
1893         external
1894         onlyWithdrawManager
1895     {
1896         _mint(_owner, _tokenId);
1897     }
1898 
1899     function burn(uint256 _tokenId) external onlyWithdrawManager {
1900         _burn(_tokenId);
1901     }
1902 
1903     function exists(uint256 tokenId) public view returns (bool) {
1904         return _exists(tokenId);
1905     }
1906 }
1907 
1908 // File: contracts/root/withdrawManager/WithdrawManagerStorage.sol
1909 
1910 pragma solidity ^0.5.2;
1911 
1912 
1913 
1914 
1915 
1916 
1917 contract ExitsDataStructure {
1918     struct Input {
1919         address utxoOwner;
1920         address predicate;
1921         address token;
1922     }
1923 
1924     struct PlasmaExit {
1925         uint256 receiptAmountOrNFTId;
1926         bytes32 txHash;
1927         address owner;
1928         address token;
1929         bool isRegularExit;
1930         address predicate;
1931         // Mapping from age of input to Input
1932         mapping(uint256 => Input) inputs;
1933     }
1934 }
1935 
1936 
1937 contract WithdrawManagerHeader is ExitsDataStructure {
1938     event Withdraw(uint256 indexed exitId, address indexed user, address indexed token, uint256 amount);
1939 
1940     event ExitStarted(
1941         address indexed exitor,
1942         uint256 indexed exitId,
1943         address indexed token,
1944         uint256 amount,
1945         bool isRegularExit
1946     );
1947 
1948     event ExitUpdated(uint256 indexed exitId, uint256 indexed age, address signer);
1949     event ExitPeriodUpdate(uint256 indexed oldExitPeriod, uint256 indexed newExitPeriod);
1950 
1951     event ExitCancelled(uint256 indexed exitId);
1952 }
1953 
1954 
1955 contract WithdrawManagerStorage is ProxyStorage, WithdrawManagerHeader {
1956     // 0.5 week = 7 * 86400 / 2 = 302400
1957     uint256 public HALF_EXIT_PERIOD = 302400;
1958 
1959     // Bonded exits collaterized at 0.1 ETH
1960     uint256 internal constant BOND_AMOUNT = 10**17;
1961 
1962     Registry internal registry;
1963     RootChain internal rootChain;
1964 
1965     mapping(uint128 => bool) isKnownExit;
1966     mapping(uint256 => PlasmaExit) public exits;
1967     // mapping with token => (owner => exitId) keccak(token+owner) keccak(token+owner+tokenId)
1968     mapping(bytes32 => uint256) public ownerExits;
1969     mapping(address => address) public exitsQueues;
1970     ExitNFT public exitNft;
1971 
1972     // ERC721, ERC20 and Weth transfers require 155000, 100000, 52000 gas respectively
1973     // Processing each exit in a while loop iteration requires ~52000 gas (@todo check if this changed)
1974     // uint32 constant internal ITERATION_GAS = 52000;
1975 
1976     // So putting an upper limit of 155000 + 52000 + leeway
1977     uint32 public ON_FINALIZE_GAS_LIMIT = 300000;
1978 
1979     uint256 public exitWindow;
1980 }
1981 
1982 // File: contracts/root/predicates/IPredicate.sol
1983 
1984 pragma solidity ^0.5.2;
1985 
1986 
1987 
1988 
1989 
1990 
1991 
1992 
1993 interface IPredicate {
1994     /**
1995    * @notice Verify the deprecation of a state update
1996    * @param exit ABI encoded PlasmaExit data
1997    * @param inputUtxo ABI encoded Input UTXO data
1998    * @param challengeData RLP encoded data of the challenge reference tx that encodes the following fields
1999    * headerNumber Header block number of which the reference tx was a part of
2000    * blockProof Proof that the block header (in the child chain) is a leaf in the submitted merkle root
2001    * blockNumber Block number of which the reference tx is a part of
2002    * blockTime Reference tx block time
2003    * blocktxRoot Transactions root of block
2004    * blockReceiptsRoot Receipts root of block
2005    * receipt Receipt of the reference transaction
2006    * receiptProof Merkle proof of the reference receipt
2007    * branchMask Merkle proof branchMask for the receipt
2008    * logIndex Log Index to read from the receipt
2009    * tx Challenge transaction
2010    * txProof Merkle proof of the challenge tx
2011    * @return Whether or not the state is deprecated
2012    */
2013     function verifyDeprecation(
2014         bytes calldata exit,
2015         bytes calldata inputUtxo,
2016         bytes calldata challengeData
2017     ) external returns (bool);
2018 
2019     function interpretStateUpdate(bytes calldata state)
2020         external
2021         view
2022         returns (bytes memory);
2023     function onFinalizeExit(bytes calldata data) external;
2024 }
2025 
2026 contract PredicateUtils is ExitsDataStructure, ChainIdMixin {
2027     using RLPReader for RLPReader.RLPItem;
2028 
2029     // Bonded exits collaterized at 0.1 ETH
2030     uint256 private constant BOND_AMOUNT = 10**17;
2031 
2032     IWithdrawManager internal withdrawManager;
2033     IDepositManager internal depositManager;
2034 
2035     modifier onlyWithdrawManager() {
2036         require(
2037             msg.sender == address(withdrawManager),
2038             "ONLY_WITHDRAW_MANAGER"
2039         );
2040         _;
2041     }
2042 
2043     modifier isBondProvided() {
2044         require(msg.value == BOND_AMOUNT, "Invalid Bond amount");
2045         _;
2046     }
2047 
2048     function onFinalizeExit(bytes calldata data) external onlyWithdrawManager {
2049         (, address token, address exitor, uint256 tokenId) = decodeExitForProcessExit(
2050             data
2051         );
2052         depositManager.transferAssets(token, exitor, tokenId);
2053     }
2054 
2055     function sendBond() internal {
2056         address(uint160(address(withdrawManager))).transfer(BOND_AMOUNT);
2057     }
2058 
2059     function getAddressFromTx(RLPReader.RLPItem[] memory txList)
2060         internal
2061         pure
2062         returns (address signer, bytes32 txHash)
2063     {
2064         bytes[] memory rawTx = new bytes[](9);
2065         for (uint8 i = 0; i <= 5; i++) {
2066             rawTx[i] = txList[i].toBytes();
2067         }
2068         rawTx[6] = networkId;
2069         rawTx[7] = hex""; // [7] and [8] have something to do with v, r, s values
2070         rawTx[8] = hex"";
2071 
2072         txHash = keccak256(RLPEncode.encodeList(rawTx));
2073         signer = ecrecover(
2074             txHash,
2075             Common.getV(txList[6].toBytes(), Common.toUint16(networkId)),
2076             bytes32(txList[7].toUint()),
2077             bytes32(txList[8].toUint())
2078         );
2079     }
2080 
2081     function decodeExit(bytes memory data)
2082         internal
2083         pure
2084         returns (PlasmaExit memory)
2085     {
2086         (address owner, address token, uint256 amountOrTokenId, bytes32 txHash, bool isRegularExit) = abi
2087             .decode(data, (address, address, uint256, bytes32, bool));
2088         return
2089             PlasmaExit(
2090                 amountOrTokenId,
2091                 txHash,
2092                 owner,
2093                 token,
2094                 isRegularExit,
2095                 address(0) /* predicate value is not required */
2096             );
2097     }
2098 
2099     function decodeExitForProcessExit(bytes memory data)
2100         internal
2101         pure
2102         returns (uint256 exitId, address token, address exitor, uint256 tokenId)
2103     {
2104         (exitId, token, exitor, tokenId) = abi.decode(
2105             data,
2106             (uint256, address, address, uint256)
2107         );
2108     }
2109 
2110     function decodeInputUtxo(bytes memory data)
2111         internal
2112         pure
2113         returns (uint256 age, address signer, address predicate, address token)
2114     {
2115         (age, signer, predicate, token) = abi.decode(
2116             data,
2117             (uint256, address, address, address)
2118         );
2119     }
2120 
2121 }
2122 
2123 contract IErcPredicate is IPredicate, PredicateUtils {
2124     enum ExitType {Invalid, OutgoingTransfer, IncomingTransfer, Burnt}
2125 
2126     struct ExitTxData {
2127         uint256 amountOrToken;
2128         bytes32 txHash;
2129         address childToken;
2130         address signer;
2131         ExitType exitType;
2132     }
2133 
2134     struct ReferenceTxData {
2135         uint256 closingBalance;
2136         uint256 age;
2137         address childToken;
2138         address rootToken;
2139     }
2140 
2141     uint256 internal constant MAX_LOGS = 10;
2142 
2143     constructor(address _withdrawManager, address _depositManager) public {
2144         withdrawManager = IWithdrawManager(_withdrawManager);
2145         depositManager = IDepositManager(_depositManager);
2146     }
2147 }
2148 
2149 // File: contracts/root/predicates/ERC20PredicateBurnOnly.sol
2150 
2151 pragma solidity ^0.5.2;
2152 
2153 
2154 
2155 
2156 contract ERC20PredicateBurnOnly is IErcPredicate {
2157     using RLPReader for bytes;
2158     using RLPReader for RLPReader.RLPItem;
2159     using SafeMath for uint256;
2160 
2161     // keccak256('Withdraw(address,address,uint256,uint256,uint256)')
2162     bytes32 constant WITHDRAW_EVENT_SIG = 0xebff2602b3f468259e1e99f613fed6691f3a6526effe6ef3e768ba7ae7a36c4f;
2163 
2164     Registry registry;
2165 
2166     constructor(
2167         address _withdrawManager,
2168         address _depositManager,
2169         address _registry
2170     ) public IErcPredicate(_withdrawManager, _depositManager) {
2171         registry = Registry(_registry);
2172     }
2173 
2174     function startExitWithBurntTokens(bytes calldata data) external {
2175         RLPReader.RLPItem[] memory referenceTxData = data.toRlpItem().toList();
2176         bytes memory receipt = referenceTxData[6].toBytes();
2177         RLPReader.RLPItem[] memory inputItems = receipt.toRlpItem().toList();
2178         uint256 logIndex = referenceTxData[9].toUint();
2179         require(logIndex < MAX_LOGS, "Supporting a max of 10 logs");
2180         uint256 age = withdrawManager.verifyInclusion(
2181             data,
2182             0, /* offset */
2183             false /* verifyTxInclusion */
2184         );
2185         inputItems = inputItems[3].toList()[logIndex].toList(); // select log based on given logIndex
2186 
2187         // "address" (contract address that emitted the log) field in the receipt
2188         address childToken = RLPReader.toAddress(inputItems[0]);
2189         bytes memory logData = inputItems[2].toBytes();
2190         inputItems = inputItems[1].toList(); // topics
2191         // now, inputItems[i] refers to i-th (0-based) topic in the topics array
2192         // event Withdraw(address indexed token, address indexed from, uint256 amountOrTokenId, uint256 input1, uint256 output1)
2193         require(
2194             bytes32(inputItems[0].toUint()) == WITHDRAW_EVENT_SIG,
2195             "Not a withdraw event signature"
2196         );
2197         address rootToken = address(RLPReader.toUint(inputItems[1]));
2198         require(
2199             msg.sender == address(inputItems[2].toUint()), // from
2200             "Withdrawer and burn exit tx do not match"
2201         );
2202         uint256 exitAmount = BytesLib.toUint(logData, 0); // amountOrTokenId
2203         withdrawManager.addExitToQueue(
2204             msg.sender,
2205             childToken,
2206             rootToken,
2207             exitAmount,
2208             bytes32(0x0),
2209             true, /* isRegularExit */
2210             age << 1
2211         );
2212     }
2213 
2214     function verifyDeprecation(
2215         bytes calldata exit,
2216         bytes calldata inputUtxo,
2217         bytes calldata challengeData
2218     ) external returns (bool) {}
2219 
2220     function interpretStateUpdate(bytes calldata state)
2221         external
2222         view
2223         returns (bytes memory) {}
2224 }