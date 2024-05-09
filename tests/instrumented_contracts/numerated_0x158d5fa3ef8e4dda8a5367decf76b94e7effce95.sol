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
455 /*
456 * @author Hamdi Allam hamdi.allam97@gmail.com
457 * Please reach out with any questions or concerns
458 */
459 pragma solidity ^0.5.0;
460 
461 library RLPReader {
462     uint8 constant STRING_SHORT_START = 0x80;
463     uint8 constant STRING_LONG_START  = 0xb8;
464     uint8 constant LIST_SHORT_START   = 0xc0;
465     uint8 constant LIST_LONG_START    = 0xf8;
466     uint8 constant WORD_SIZE = 32;
467 
468     struct RLPItem {
469         uint len;
470         uint memPtr;
471     }
472 
473     struct Iterator {
474         RLPItem item;   // Item that's being iterated over.
475         uint nextPtr;   // Position of the next item in the list.
476     }
477 
478     /*
479     * @dev Returns the next element in the iteration. Reverts if it has not next element.
480     * @param self The iterator.
481     * @return The next element in the iteration.
482     */
483     function next(Iterator memory self) internal pure returns (RLPItem memory) {
484         require(hasNext(self));
485 
486         uint ptr = self.nextPtr;
487         uint itemLength = _itemLength(ptr);
488         self.nextPtr = ptr + itemLength;
489 
490         return RLPItem(itemLength, ptr);
491     }
492 
493     /*
494     * @dev Returns true if the iteration has more elements.
495     * @param self The iterator.
496     * @return true if the iteration has more elements.
497     */
498     function hasNext(Iterator memory self) internal pure returns (bool) {
499         RLPItem memory item = self.item;
500         return self.nextPtr < item.memPtr + item.len;
501     }
502 
503     /*
504     * @param item RLP encoded bytes
505     */
506     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
507         uint memPtr;
508         assembly {
509             memPtr := add(item, 0x20)
510         }
511 
512         return RLPItem(item.length, memPtr);
513     }
514 
515     /*
516     * @dev Create an iterator. Reverts if item is not a list.
517     * @param self The RLP item.
518     * @return An 'Iterator' over the item.
519     */
520     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
521         require(isList(self));
522 
523         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
524         return Iterator(self, ptr);
525     }
526 
527     /*
528     * @param item RLP encoded bytes
529     */
530     function rlpLen(RLPItem memory item) internal pure returns (uint) {
531         return item.len;
532     }
533 
534     /*
535     * @param item RLP encoded bytes
536     */
537     function payloadLen(RLPItem memory item) internal pure returns (uint) {
538         return item.len - _payloadOffset(item.memPtr);
539     }
540 
541     /*
542     * @param item RLP encoded list in bytes
543     */
544     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
545         require(isList(item));
546 
547         uint items = numItems(item);
548         RLPItem[] memory result = new RLPItem[](items);
549 
550         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
551         uint dataLen;
552         for (uint i = 0; i < items; i++) {
553             dataLen = _itemLength(memPtr);
554             result[i] = RLPItem(dataLen, memPtr); 
555             memPtr = memPtr + dataLen;
556         }
557 
558         return result;
559     }
560 
561     // @return indicator whether encoded payload is a list. negate this function call for isData.
562     function isList(RLPItem memory item) internal pure returns (bool) {
563         if (item.len == 0) return false;
564 
565         uint8 byte0;
566         uint memPtr = item.memPtr;
567         assembly {
568             byte0 := byte(0, mload(memPtr))
569         }
570 
571         if (byte0 < LIST_SHORT_START)
572             return false;
573         return true;
574     }
575 
576     /** RLPItem conversions into data types **/
577 
578     // @returns raw rlp encoding in bytes
579     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
580         bytes memory result = new bytes(item.len);
581         if (result.length == 0) return result;
582         
583         uint ptr;
584         assembly {
585             ptr := add(0x20, result)
586         }
587 
588         copy(item.memPtr, ptr, item.len);
589         return result;
590     }
591 
592     // any non-zero byte is considered true
593     function toBoolean(RLPItem memory item) internal pure returns (bool) {
594         require(item.len == 1);
595         uint result;
596         uint memPtr = item.memPtr;
597         assembly {
598             result := byte(0, mload(memPtr))
599         }
600 
601         return result == 0 ? false : true;
602     }
603 
604     function toAddress(RLPItem memory item) internal pure returns (address) {
605         // 1 byte for the length prefix
606         require(item.len == 21);
607 
608         return address(toUint(item));
609     }
610 
611     function toUint(RLPItem memory item) internal pure returns (uint) {
612         require(item.len > 0 && item.len <= 33);
613 
614         uint offset = _payloadOffset(item.memPtr);
615         uint len = item.len - offset;
616 
617         uint result;
618         uint memPtr = item.memPtr + offset;
619         assembly {
620             result := mload(memPtr)
621 
622             // shfit to the correct location if neccesary
623             if lt(len, 32) {
624                 result := div(result, exp(256, sub(32, len)))
625             }
626         }
627 
628         return result;
629     }
630 
631     // enforces 32 byte length
632     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
633         // one byte prefix
634         require(item.len == 33);
635 
636         uint result;
637         uint memPtr = item.memPtr + 1;
638         assembly {
639             result := mload(memPtr)
640         }
641 
642         return result;
643     }
644 
645     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
646         require(item.len > 0);
647 
648         uint offset = _payloadOffset(item.memPtr);
649         uint len = item.len - offset; // data length
650         bytes memory result = new bytes(len);
651 
652         uint destPtr;
653         assembly {
654             destPtr := add(0x20, result)
655         }
656 
657         copy(item.memPtr + offset, destPtr, len);
658         return result;
659     }
660 
661     /*
662     * Private Helpers
663     */
664 
665     // @return number of payload items inside an encoded list.
666     function numItems(RLPItem memory item) private pure returns (uint) {
667         if (item.len == 0) return 0;
668 
669         uint count = 0;
670         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
671         uint endPtr = item.memPtr + item.len;
672         while (currPtr < endPtr) {
673            currPtr = currPtr + _itemLength(currPtr); // skip over an item
674            count++;
675         }
676 
677         return count;
678     }
679 
680     // @return entire rlp item byte length
681     function _itemLength(uint memPtr) private pure returns (uint) {
682         uint itemLen;
683         uint byte0;
684         assembly {
685             byte0 := byte(0, mload(memPtr))
686         }
687 
688         if (byte0 < STRING_SHORT_START)
689             itemLen = 1;
690         
691         else if (byte0 < STRING_LONG_START)
692             itemLen = byte0 - STRING_SHORT_START + 1;
693 
694         else if (byte0 < LIST_SHORT_START) {
695             assembly {
696                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
697                 memPtr := add(memPtr, 1) // skip over the first byte
698                 
699                 /* 32 byte word size */
700                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
701                 itemLen := add(dataLen, add(byteLen, 1))
702             }
703         }
704 
705         else if (byte0 < LIST_LONG_START) {
706             itemLen = byte0 - LIST_SHORT_START + 1;
707         } 
708 
709         else {
710             assembly {
711                 let byteLen := sub(byte0, 0xf7)
712                 memPtr := add(memPtr, 1)
713 
714                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
715                 itemLen := add(dataLen, add(byteLen, 1))
716             }
717         }
718 
719         return itemLen;
720     }
721 
722     // @return number of bytes until the data
723     function _payloadOffset(uint memPtr) private pure returns (uint) {
724         uint byte0;
725         assembly {
726             byte0 := byte(0, mload(memPtr))
727         }
728 
729         if (byte0 < STRING_SHORT_START) 
730             return 0;
731         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
732             return 1;
733         else if (byte0 < LIST_SHORT_START)  // being explicit
734             return byte0 - (STRING_LONG_START - 1) + 1;
735         else
736             return byte0 - (LIST_LONG_START - 1) + 1;
737     }
738 
739     /*
740     * @param src Pointer to source
741     * @param dest Pointer to destination
742     * @param len Amount of memory to copy from the source
743     */
744     function copy(uint src, uint dest, uint len) private pure {
745         if (len == 0) return;
746 
747         // copy as many word sizes as possible
748         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
749             assembly {
750                 mstore(dest, mload(src))
751             }
752 
753             src += WORD_SIZE;
754             dest += WORD_SIZE;
755         }
756 
757         // left over bytes. Mask is used to remove unwanted bytes from the word
758         uint mask = 256 ** (WORD_SIZE - len) - 1;
759         assembly {
760             let srcpart := and(mload(src), not(mask)) // zero out src
761             let destpart := and(mload(dest), mask) // retrieve the bytes
762             mstore(dest, or(destpart, srcpart))
763         }
764     }
765 }
766 
767 // File: contracts/common/lib/ExitPayloadReader.sol
768 
769 pragma solidity 0.5.17;
770 
771 
772 
773 library ExitPayloadReader {
774   using RLPReader for bytes;
775   using RLPReader for RLPReader.RLPItem;
776 
777   uint8 constant WORD_SIZE = 32;
778 
779   struct ExitPayload {
780     RLPReader.RLPItem[] data;
781   }
782 
783   struct Receipt {
784     RLPReader.RLPItem[] data;
785     bytes raw;
786     uint256 logIndex;
787   }
788 
789   struct Log {
790     RLPReader.RLPItem data;
791     RLPReader.RLPItem[] list;
792   }
793 
794   struct LogTopics {
795     RLPReader.RLPItem[] data;
796   }
797 
798   function toExitPayload(bytes memory data)
799         internal
800         pure
801         returns (ExitPayload memory)
802     {
803         RLPReader.RLPItem[] memory payloadData = data
804             .toRlpItem()
805             .toList();
806 
807         return ExitPayload(payloadData);
808     }
809 
810     function copy(uint src, uint dest, uint len) private pure {
811         if (len == 0) return;
812 
813         // copy as many word sizes as possible
814         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
815             assembly {
816                 mstore(dest, mload(src))
817             }
818 
819             src += WORD_SIZE;
820             dest += WORD_SIZE;
821         }
822 
823         // left over bytes. Mask is used to remove unwanted bytes from the word
824         uint mask = 256 ** (WORD_SIZE - len) - 1;
825         assembly {
826             let srcpart := and(mload(src), not(mask)) // zero out src
827             let destpart := and(mload(dest), mask) // retrieve the bytes
828             mstore(dest, or(destpart, srcpart))
829         }
830     }
831 
832     function getHeaderNumber(ExitPayload memory payload) internal pure returns(uint256) {
833       return payload.data[0].toUint();
834     }
835 
836     function getBlockProof(ExitPayload memory payload) internal pure returns(bytes memory) {
837       return payload.data[1].toBytes();
838     }
839 
840     function getBlockNumber(ExitPayload memory payload) internal pure returns(uint256) {
841       return payload.data[2].toUint();
842     }
843 
844     function getBlockTime(ExitPayload memory payload) internal pure returns(uint256) {
845       return payload.data[3].toUint();
846     }
847 
848     function getTxRoot(ExitPayload memory payload) internal pure returns(bytes32) {
849       return bytes32(payload.data[4].toUint());
850     }
851 
852     function getReceiptRoot(ExitPayload memory payload) internal pure returns(bytes32) {
853       return bytes32(payload.data[5].toUint());
854     }
855 
856     function getReceipt(ExitPayload memory payload) internal pure returns(Receipt memory receipt) {
857       receipt.raw = payload.data[6].toBytes();
858       RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
859 
860       if (receiptItem.isList()) {
861           // legacy tx
862           receipt.data = receiptItem.toList();
863       } else {
864           // pop first byte before parsting receipt
865           bytes memory typedBytes = receipt.raw;
866           bytes memory result = new bytes(typedBytes.length - 1);
867           uint256 srcPtr;
868           uint256 destPtr;
869           assembly {
870               srcPtr := add(33, typedBytes)
871               destPtr := add(0x20, result)
872           }
873 
874           copy(srcPtr, destPtr, result.length);
875           receipt.data = result.toRlpItem().toList();
876       }
877 
878       receipt.logIndex = getReceiptLogIndex(payload);
879       return receipt;
880     }
881 
882     function getReceiptProof(ExitPayload memory payload) internal pure returns(bytes memory) {
883       return payload.data[7].toBytes();
884     }
885 
886     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns(bytes memory) {
887       return payload.data[8].toBytes();
888     }
889 
890     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns(uint256) {
891       return payload.data[8].toUint();
892     }
893 
894     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns(uint256) {
895       return payload.data[9].toUint();
896     }
897 
898     function getTx(ExitPayload memory payload) internal pure returns(bytes memory) {
899       return payload.data[10].toBytes();
900     }
901 
902     function getTxProof(ExitPayload memory payload) internal pure returns(bytes memory) {
903       return payload.data[11].toBytes();
904     }
905     
906     // Receipt methods
907     function toBytes(Receipt memory receipt) internal pure returns(bytes memory) {
908         return receipt.raw;
909     }
910 
911     function getLog(Receipt memory receipt) internal pure returns(Log memory) {
912         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
913         return Log(logData, logData.toList());
914     }
915 
916     // Log methods
917     function getEmitter(Log memory log) internal pure returns(address) {
918       return RLPReader.toAddress(log.list[0]);
919     }
920 
921     function getTopics(Log memory log) internal pure returns(LogTopics memory) {
922         return LogTopics(log.list[1].toList());
923     }
924 
925     function getData(Log memory log) internal pure returns(bytes memory) {
926         return log.list[2].toBytes();
927     }
928 
929     function toRlpBytes(Log memory log) internal pure returns(bytes memory) {
930       return log.data.toRlpBytes();
931     }
932 
933     // LogTopics methods
934     function getField(LogTopics memory topics, uint256 index) internal pure returns(RLPReader.RLPItem memory) {
935       return topics.data[index];
936     }
937 }
938 
939 // File: contracts/root/withdrawManager/IWithdrawManager.sol
940 
941 pragma solidity ^0.5.2;
942 
943 contract IWithdrawManager {
944     function createExitQueue(address token) external;
945 
946     function verifyInclusion(
947         bytes calldata data,
948         uint8 offset,
949         bool verifyTxInclusion
950     ) external view returns (uint256 age);
951 
952     function addExitToQueue(
953         address exitor,
954         address childToken,
955         address rootToken,
956         uint256 exitAmountOrTokenId,
957         bytes32 txHash,
958         bool isRegularExit,
959         uint256 priority
960     ) external;
961 
962     function addInput(
963         uint256 exitId,
964         uint256 age,
965         address utxoOwner,
966         address token
967     ) external;
968 
969     function challengeExit(
970         uint256 exitId,
971         uint256 inputId,
972         bytes calldata challengeData,
973         address adjudicatorPredicate
974     ) external;
975 }
976 
977 // File: contracts/root/depositManager/IDepositManager.sol
978 
979 pragma solidity ^0.5.2;
980 
981 interface IDepositManager {
982     function depositEther() external payable;
983     function transferAssets(
984         address _token,
985         address _user,
986         uint256 _amountOrNFTId
987     ) external;
988     function depositERC20(address _token, uint256 _amount) external;
989     function depositERC721(address _token, uint256 _tokenId) external;
990 }
991 
992 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
993 
994 pragma solidity ^0.5.2;
995 
996 /**
997  * @title Ownable
998  * @dev The Ownable contract has an owner address, and provides basic authorization control
999  * functions, this simplifies the implementation of "user permissions".
1000  */
1001 contract Ownable {
1002     address private _owner;
1003 
1004     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1005 
1006     /**
1007      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1008      * account.
1009      */
1010     constructor () internal {
1011         _owner = msg.sender;
1012         emit OwnershipTransferred(address(0), _owner);
1013     }
1014 
1015     /**
1016      * @return the address of the owner.
1017      */
1018     function owner() public view returns (address) {
1019         return _owner;
1020     }
1021 
1022     /**
1023      * @dev Throws if called by any account other than the owner.
1024      */
1025     modifier onlyOwner() {
1026         require(isOwner());
1027         _;
1028     }
1029 
1030     /**
1031      * @return true if `msg.sender` is the owner of the contract.
1032      */
1033     function isOwner() public view returns (bool) {
1034         return msg.sender == _owner;
1035     }
1036 
1037     /**
1038      * @dev Allows the current owner to relinquish control of the contract.
1039      * It will not be possible to call the functions with the `onlyOwner`
1040      * modifier anymore.
1041      * @notice Renouncing ownership will leave the contract without an owner,
1042      * thereby removing any functionality that is only available to the owner.
1043      */
1044     function renounceOwnership() public onlyOwner {
1045         emit OwnershipTransferred(_owner, address(0));
1046         _owner = address(0);
1047     }
1048 
1049     /**
1050      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1051      * @param newOwner The address to transfer ownership to.
1052      */
1053     function transferOwnership(address newOwner) public onlyOwner {
1054         _transferOwnership(newOwner);
1055     }
1056 
1057     /**
1058      * @dev Transfers control of the contract to a newOwner.
1059      * @param newOwner The address to transfer ownership to.
1060      */
1061     function _transferOwnership(address newOwner) internal {
1062         require(newOwner != address(0));
1063         emit OwnershipTransferred(_owner, newOwner);
1064         _owner = newOwner;
1065     }
1066 }
1067 
1068 // File: contracts/common/misc/ProxyStorage.sol
1069 
1070 pragma solidity ^0.5.2;
1071 
1072 
1073 contract ProxyStorage is Ownable {
1074     address internal proxyTo;
1075 }
1076 
1077 // File: contracts/common/governance/IGovernance.sol
1078 
1079 pragma solidity ^0.5.2;
1080 
1081 interface IGovernance {
1082     function update(address target, bytes calldata data) external;
1083 }
1084 
1085 // File: contracts/common/governance/Governable.sol
1086 
1087 pragma solidity ^0.5.2;
1088 
1089 
1090 contract Governable {
1091     IGovernance public governance;
1092 
1093     constructor(address _governance) public {
1094         governance = IGovernance(_governance);
1095     }
1096 
1097     modifier onlyGovernance() {
1098         _assertGovernance();
1099         _;
1100     }
1101 
1102     function _assertGovernance() private view {
1103         require(
1104             msg.sender == address(governance),
1105             "Only governance contract is authorized"
1106         );
1107     }
1108 }
1109 
1110 // File: contracts/common/Registry.sol
1111 
1112 pragma solidity ^0.5.2;
1113 
1114 
1115 
1116 
1117 contract Registry is Governable {
1118     // @todo hardcode constants
1119     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
1120     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
1121     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
1122     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
1123     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
1124     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
1125     bytes32 private constant STATE_SENDER = keccak256("stateSender");
1126     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
1127 
1128     address public erc20Predicate;
1129     address public erc721Predicate;
1130 
1131     mapping(bytes32 => address) public contractMap;
1132     mapping(address => address) public rootToChildToken;
1133     mapping(address => address) public childToRootToken;
1134     mapping(address => bool) public proofValidatorContracts;
1135     mapping(address => bool) public isERC721;
1136 
1137     enum Type {Invalid, ERC20, ERC721, Custom}
1138     struct Predicate {
1139         Type _type;
1140     }
1141     mapping(address => Predicate) public predicates;
1142 
1143     event TokenMapped(address indexed rootToken, address indexed childToken);
1144     event ProofValidatorAdded(address indexed validator, address indexed from);
1145     event ProofValidatorRemoved(address indexed validator, address indexed from);
1146     event PredicateAdded(address indexed predicate, address indexed from);
1147     event PredicateRemoved(address indexed predicate, address indexed from);
1148     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
1149 
1150     constructor(address _governance) public Governable(_governance) {}
1151 
1152     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
1153         emit ContractMapUpdated(_key, contractMap[_key], _address);
1154         contractMap[_key] = _address;
1155     }
1156 
1157     /**
1158      * @dev Map root token to child token
1159      * @param _rootToken Token address on the root chain
1160      * @param _childToken Token address on the child chain
1161      * @param _isERC721 Is the token being mapped ERC721
1162      */
1163     function mapToken(
1164         address _rootToken,
1165         address _childToken,
1166         bool _isERC721
1167     ) external onlyGovernance {
1168         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
1169         rootToChildToken[_rootToken] = _childToken;
1170         childToRootToken[_childToken] = _rootToken;
1171         isERC721[_rootToken] = _isERC721;
1172         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
1173         emit TokenMapped(_rootToken, _childToken);
1174     }
1175 
1176     function addErc20Predicate(address predicate) public onlyGovernance {
1177         require(predicate != address(0x0), "Can not add null address as predicate");
1178         erc20Predicate = predicate;
1179         addPredicate(predicate, Type.ERC20);
1180     }
1181 
1182     function addErc721Predicate(address predicate) public onlyGovernance {
1183         erc721Predicate = predicate;
1184         addPredicate(predicate, Type.ERC721);
1185     }
1186 
1187     function addPredicate(address predicate, Type _type) public onlyGovernance {
1188         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
1189         predicates[predicate]._type = _type;
1190         emit PredicateAdded(predicate, msg.sender);
1191     }
1192 
1193     function removePredicate(address predicate) public onlyGovernance {
1194         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
1195         delete predicates[predicate];
1196         emit PredicateRemoved(predicate, msg.sender);
1197     }
1198 
1199     function getValidatorShareAddress() public view returns (address) {
1200         return contractMap[VALIDATOR_SHARE];
1201     }
1202 
1203     function getWethTokenAddress() public view returns (address) {
1204         return contractMap[WETH_TOKEN];
1205     }
1206 
1207     function getDepositManagerAddress() public view returns (address) {
1208         return contractMap[DEPOSIT_MANAGER];
1209     }
1210 
1211     function getStakeManagerAddress() public view returns (address) {
1212         return contractMap[STAKE_MANAGER];
1213     }
1214 
1215     function getSlashingManagerAddress() public view returns (address) {
1216         return contractMap[SLASHING_MANAGER];
1217     }
1218 
1219     function getWithdrawManagerAddress() public view returns (address) {
1220         return contractMap[WITHDRAW_MANAGER];
1221     }
1222 
1223     function getChildChainAndStateSender() public view returns (address, address) {
1224         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
1225     }
1226 
1227     function isTokenMapped(address _token) public view returns (bool) {
1228         return rootToChildToken[_token] != address(0x0);
1229     }
1230 
1231     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
1232         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
1233         return isERC721[_token];
1234     }
1235 
1236     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
1237         if (isTokenMappedAndIsErc721(_token)) {
1238             return erc721Predicate;
1239         }
1240         return erc20Predicate;
1241     }
1242 
1243     function isChildTokenErc721(address childToken) public view returns (bool) {
1244         address rootToken = childToRootToken[childToken];
1245         require(rootToken != address(0x0), "Child token is not mapped");
1246         return isERC721[rootToken];
1247     }
1248 }
1249 
1250 // File: contracts/common/mixin/ChainIdMixin.sol
1251 
1252 pragma solidity ^0.5.2;
1253 
1254 contract ChainIdMixin {
1255   bytes constant public networkId = hex"3A99";
1256   uint256 constant public CHAINID = 15001;
1257 }
1258 
1259 // File: contracts/root/RootChainStorage.sol
1260 
1261 pragma solidity ^0.5.2;
1262 
1263 
1264 
1265 
1266 
1267 contract RootChainHeader {
1268     event NewHeaderBlock(
1269         address indexed proposer,
1270         uint256 indexed headerBlockId,
1271         uint256 indexed reward,
1272         uint256 start,
1273         uint256 end,
1274         bytes32 root
1275     );
1276     // housekeeping event
1277     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
1278     struct HeaderBlock {
1279         bytes32 root;
1280         uint256 start;
1281         uint256 end;
1282         uint256 createdAt;
1283         address proposer;
1284     }
1285 }
1286 
1287 
1288 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
1289     bytes32 public heimdallId;
1290     uint8 public constant VOTE_TYPE = 2;
1291 
1292     uint16 internal constant MAX_DEPOSITS = 10000;
1293     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
1294     uint256 internal _blockDepositId = 1;
1295     mapping(uint256 => HeaderBlock) public headerBlocks;
1296     Registry internal registry;
1297 }
1298 
1299 // File: contracts/staking/stakeManager/IStakeManager.sol
1300 
1301 pragma solidity 0.5.17;
1302 
1303 contract IStakeManager {
1304     // validator replacement
1305     function startAuction(
1306         uint256 validatorId,
1307         uint256 amount,
1308         bool acceptDelegation,
1309         bytes calldata signerPubkey
1310     ) external;
1311 
1312     function confirmAuctionBid(uint256 validatorId, uint256 heimdallFee) external;
1313 
1314     function transferFunds(
1315         uint256 validatorId,
1316         uint256 amount,
1317         address delegator
1318     ) external returns (bool);
1319 
1320     function delegationDeposit(
1321         uint256 validatorId,
1322         uint256 amount,
1323         address delegator
1324     ) external returns (bool);
1325 
1326     function unstake(uint256 validatorId) external;
1327 
1328     function totalStakedFor(address addr) external view returns (uint256);
1329 
1330     function stakeFor(
1331         address user,
1332         uint256 amount,
1333         uint256 heimdallFee,
1334         bool acceptDelegation,
1335         bytes memory signerPubkey
1336     ) public;
1337 
1338     function checkSignatures(
1339         uint256 blockInterval,
1340         bytes32 voteHash,
1341         bytes32 stateRoot,
1342         address proposer,
1343         uint[3][] calldata sigs
1344     ) external returns (uint256);
1345 
1346     function updateValidatorState(uint256 validatorId, int256 amount) public;
1347 
1348     function ownerOf(uint256 tokenId) public view returns (address);
1349 
1350     function slash(bytes calldata slashingInfoList) external returns (uint256);
1351 
1352     function validatorStake(uint256 validatorId) public view returns (uint256);
1353 
1354     function epoch() public view returns (uint256);
1355 
1356     function getRegistry() public view returns (address);
1357 
1358     function withdrawalDelay() public view returns (uint256);
1359 
1360     function delegatedAmount(uint256 validatorId) public view returns(uint256);
1361 
1362     function decreaseValidatorDelegatedAmount(uint256 validatorId, uint256 amount) public;
1363 
1364     function withdrawDelegatorsReward(uint256 validatorId) public returns(uint256);
1365 
1366     function delegatorsReward(uint256 validatorId) public view returns(uint256);
1367 
1368     function dethroneAndStake(
1369         address auctionUser,
1370         uint256 heimdallFee,
1371         uint256 validatorId,
1372         uint256 auctionAmount,
1373         bool acceptDelegation,
1374         bytes calldata signerPubkey
1375     ) external;
1376 }
1377 
1378 // File: contracts/root/IRootChain.sol
1379 
1380 pragma solidity ^0.5.2;
1381 
1382 
1383 interface IRootChain {
1384     function slash() external;
1385 
1386     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
1387         external;
1388     
1389     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs)
1390         external;
1391 
1392     function getLastChildBlock() external view returns (uint256);
1393 
1394     function currentHeaderBlock() external view returns (uint256);
1395 }
1396 
1397 // File: contracts/root/RootChain.sol
1398 
1399 pragma solidity ^0.5.2;
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 
1408 contract RootChain is RootChainStorage, IRootChain {
1409     using SafeMath for uint256;
1410     using RLPReader for bytes;
1411     using RLPReader for RLPReader.RLPItem;
1412 
1413     modifier onlyDepositManager() {
1414         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
1415         _;
1416     }
1417 
1418     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
1419         revert();
1420     }
1421 
1422     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
1423         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
1424             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
1425         require(CHAINID == _borChainID, "Invalid bor chain id");
1426 
1427         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
1428 
1429         // check if it is better to keep it in local storage instead
1430         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
1431         uint256 _reward = stakeManager.checkSignatures(
1432             end.sub(start).add(1),
1433             /**  
1434                 prefix 01 to data 
1435                 01 represents positive vote on data and 00 is negative vote
1436                 malicious validator can try to send 2/3 on negative vote so 01 is appended
1437              */
1438             keccak256(abi.encodePacked(bytes(hex"01"), data)),
1439             accountHash,
1440             proposer,
1441             sigs
1442         );
1443 
1444         require(_reward != 0, "Invalid checkpoint");
1445         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
1446         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
1447         _blockDepositId = 1;
1448     }
1449 
1450     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
1451         depositId = currentHeaderBlock().add(_blockDepositId);
1452         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
1453         _blockDepositId = _blockDepositId.add(numDeposits);
1454         require(
1455             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
1456             _blockDepositId <= MAX_DEPOSITS,
1457             "TOO_MANY_DEPOSITS"
1458         );
1459     }
1460 
1461     function getLastChildBlock() external view returns (uint256) {
1462         return headerBlocks[currentHeaderBlock()].end;
1463     }
1464 
1465     function slash() external {
1466         //TODO: future implementation
1467     }
1468 
1469     function currentHeaderBlock() public view returns (uint256) {
1470         return _nextHeaderBlock.sub(MAX_DEPOSITS);
1471     }
1472 
1473     function _buildHeaderBlock(
1474         address proposer,
1475         uint256 start,
1476         uint256 end,
1477         bytes32 rootHash
1478     ) private returns (bool) {
1479         uint256 nextChildBlock;
1480         /*
1481     The ID of the 1st header block is MAX_DEPOSITS.
1482     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
1483     */
1484         if (_nextHeaderBlock > MAX_DEPOSITS) {
1485             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
1486         }
1487         if (nextChildBlock != start) {
1488             return false;
1489         }
1490 
1491         HeaderBlock memory headerBlock = HeaderBlock({
1492             root: rootHash,
1493             start: nextChildBlock,
1494             end: end,
1495             createdAt: now,
1496             proposer: proposer
1497         });
1498 
1499         headerBlocks[_nextHeaderBlock] = headerBlock;
1500         return true;
1501     }
1502 
1503     // Housekeeping function. @todo remove later
1504     function setNextHeaderBlock(uint256 _value) public onlyOwner {
1505         require(_value % MAX_DEPOSITS == 0, "Invalid value");
1506         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
1507             delete headerBlocks[i];
1508         }
1509         _nextHeaderBlock = _value;
1510         _blockDepositId = 1;
1511         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
1512     }
1513 
1514     // Housekeeping function. @todo remove later
1515     function setHeimdallId(string memory _heimdallId) public onlyOwner {
1516         heimdallId = keccak256(abi.encodePacked(_heimdallId));
1517     }
1518 }
1519 
1520 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
1521 
1522 pragma solidity ^0.5.2;
1523 
1524 /**
1525  * @title IERC165
1526  * @dev https://eips.ethereum.org/EIPS/eip-165
1527  */
1528 interface IERC165 {
1529     /**
1530      * @notice Query if a contract implements an interface
1531      * @param interfaceId The interface identifier, as specified in ERC-165
1532      * @dev Interface identification is specified in ERC-165. This function
1533      * uses less than 30,000 gas.
1534      */
1535     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1536 }
1537 
1538 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
1539 
1540 pragma solidity ^0.5.2;
1541 
1542 
1543 /**
1544  * @title ERC721 Non-Fungible Token Standard basic interface
1545  * @dev see https://eips.ethereum.org/EIPS/eip-721
1546  */
1547 contract IERC721 is IERC165 {
1548     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1550     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1551 
1552     function balanceOf(address owner) public view returns (uint256 balance);
1553     function ownerOf(uint256 tokenId) public view returns (address owner);
1554 
1555     function approve(address to, uint256 tokenId) public;
1556     function getApproved(uint256 tokenId) public view returns (address operator);
1557 
1558     function setApprovalForAll(address operator, bool _approved) public;
1559     function isApprovedForAll(address owner, address operator) public view returns (bool);
1560 
1561     function transferFrom(address from, address to, uint256 tokenId) public;
1562     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1563 
1564     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1565 }
1566 
1567 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
1568 
1569 pragma solidity ^0.5.2;
1570 
1571 /**
1572  * @title ERC721 token receiver interface
1573  * @dev Interface for any contract that wants to support safeTransfers
1574  * from ERC721 asset contracts.
1575  */
1576 contract IERC721Receiver {
1577     /**
1578      * @notice Handle the receipt of an NFT
1579      * @dev The ERC721 smart contract calls this function on the recipient
1580      * after a `safeTransfer`. This function MUST return the function selector,
1581      * otherwise the caller will revert the transaction. The selector to be
1582      * returned can be obtained as `this.onERC721Received.selector`. This
1583      * function MAY throw to revert and reject the transfer.
1584      * Note: the ERC721 contract address is always the message sender.
1585      * @param operator The address which called `safeTransferFrom` function
1586      * @param from The address which previously owned the token
1587      * @param tokenId The NFT identifier which is being transferred
1588      * @param data Additional data with no specified format
1589      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1590      */
1591     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1592     public returns (bytes4);
1593 }
1594 
1595 // File: openzeppelin-solidity/contracts/utils/Address.sol
1596 
1597 pragma solidity ^0.5.2;
1598 
1599 /**
1600  * Utility library of inline functions on addresses
1601  */
1602 library Address {
1603     /**
1604      * Returns whether the target address is a contract
1605      * @dev This function will return false if invoked during the constructor of a contract,
1606      * as the code is not actually created until after the constructor finishes.
1607      * @param account address of the account to check
1608      * @return whether the target address is a contract
1609      */
1610     function isContract(address account) internal view returns (bool) {
1611         uint256 size;
1612         // XXX Currently there is no better way to check if there is a contract in an address
1613         // than to check the size of the code at that address.
1614         // See https://ethereum.stackexchange.com/a/14016/36603
1615         // for more details about how this works.
1616         // TODO Check this again before the Serenity release, because all addresses will be
1617         // contracts then.
1618         // solhint-disable-next-line no-inline-assembly
1619         assembly { size := extcodesize(account) }
1620         return size > 0;
1621     }
1622 }
1623 
1624 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
1625 
1626 pragma solidity ^0.5.2;
1627 
1628 
1629 /**
1630  * @title Counters
1631  * @author Matt Condon (@shrugs)
1632  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1633  * of elements in a mapping, issuing ERC721 ids, or counting request ids
1634  *
1635  * Include with `using Counters for Counters.Counter;`
1636  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
1637  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1638  * directly accessed.
1639  */
1640 library Counters {
1641     using SafeMath for uint256;
1642 
1643     struct Counter {
1644         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1645         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1646         // this feature: see https://github.com/ethereum/solidity/issues/4637
1647         uint256 _value; // default: 0
1648     }
1649 
1650     function current(Counter storage counter) internal view returns (uint256) {
1651         return counter._value;
1652     }
1653 
1654     function increment(Counter storage counter) internal {
1655         counter._value += 1;
1656     }
1657 
1658     function decrement(Counter storage counter) internal {
1659         counter._value = counter._value.sub(1);
1660     }
1661 }
1662 
1663 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
1664 
1665 pragma solidity ^0.5.2;
1666 
1667 
1668 /**
1669  * @title ERC165
1670  * @author Matt Condon (@shrugs)
1671  * @dev Implements ERC165 using a lookup table.
1672  */
1673 contract ERC165 is IERC165 {
1674     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1675     /*
1676      * 0x01ffc9a7 ===
1677      *     bytes4(keccak256('supportsInterface(bytes4)'))
1678      */
1679 
1680     /**
1681      * @dev a mapping of interface id to whether or not it's supported
1682      */
1683     mapping(bytes4 => bool) private _supportedInterfaces;
1684 
1685     /**
1686      * @dev A contract implementing SupportsInterfaceWithLookup
1687      * implement ERC165 itself
1688      */
1689     constructor () internal {
1690         _registerInterface(_INTERFACE_ID_ERC165);
1691     }
1692 
1693     /**
1694      * @dev implement supportsInterface(bytes4) using a lookup table
1695      */
1696     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1697         return _supportedInterfaces[interfaceId];
1698     }
1699 
1700     /**
1701      * @dev internal method for registering an interface
1702      */
1703     function _registerInterface(bytes4 interfaceId) internal {
1704         require(interfaceId != 0xffffffff);
1705         _supportedInterfaces[interfaceId] = true;
1706     }
1707 }
1708 
1709 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
1710 
1711 pragma solidity ^0.5.2;
1712 
1713 
1714 
1715 
1716 
1717 
1718 
1719 /**
1720  * @title ERC721 Non-Fungible Token Standard basic implementation
1721  * @dev see https://eips.ethereum.org/EIPS/eip-721
1722  */
1723 contract ERC721 is ERC165, IERC721 {
1724     using SafeMath for uint256;
1725     using Address for address;
1726     using Counters for Counters.Counter;
1727 
1728     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1729     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1730     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1731 
1732     // Mapping from token ID to owner
1733     mapping (uint256 => address) private _tokenOwner;
1734 
1735     // Mapping from token ID to approved address
1736     mapping (uint256 => address) private _tokenApprovals;
1737 
1738     // Mapping from owner to number of owned token
1739     mapping (address => Counters.Counter) private _ownedTokensCount;
1740 
1741     // Mapping from owner to operator approvals
1742     mapping (address => mapping (address => bool)) private _operatorApprovals;
1743 
1744     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1745     /*
1746      * 0x80ac58cd ===
1747      *     bytes4(keccak256('balanceOf(address)')) ^
1748      *     bytes4(keccak256('ownerOf(uint256)')) ^
1749      *     bytes4(keccak256('approve(address,uint256)')) ^
1750      *     bytes4(keccak256('getApproved(uint256)')) ^
1751      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1752      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1753      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1754      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1755      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1756      */
1757 
1758     constructor () public {
1759         // register the supported interfaces to conform to ERC721 via ERC165
1760         _registerInterface(_INTERFACE_ID_ERC721);
1761     }
1762 
1763     /**
1764      * @dev Gets the balance of the specified address
1765      * @param owner address to query the balance of
1766      * @return uint256 representing the amount owned by the passed address
1767      */
1768     function balanceOf(address owner) public view returns (uint256) {
1769         require(owner != address(0));
1770         return _ownedTokensCount[owner].current();
1771     }
1772 
1773     /**
1774      * @dev Gets the owner of the specified token ID
1775      * @param tokenId uint256 ID of the token to query the owner of
1776      * @return address currently marked as the owner of the given token ID
1777      */
1778     function ownerOf(uint256 tokenId) public view returns (address) {
1779         address owner = _tokenOwner[tokenId];
1780         require(owner != address(0));
1781         return owner;
1782     }
1783 
1784     /**
1785      * @dev Approves another address to transfer the given token ID
1786      * The zero address indicates there is no approved address.
1787      * There can only be one approved address per token at a given time.
1788      * Can only be called by the token owner or an approved operator.
1789      * @param to address to be approved for the given token ID
1790      * @param tokenId uint256 ID of the token to be approved
1791      */
1792     function approve(address to, uint256 tokenId) public {
1793         address owner = ownerOf(tokenId);
1794         require(to != owner);
1795         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1796 
1797         _tokenApprovals[tokenId] = to;
1798         emit Approval(owner, to, tokenId);
1799     }
1800 
1801     /**
1802      * @dev Gets the approved address for a token ID, or zero if no address set
1803      * Reverts if the token ID does not exist.
1804      * @param tokenId uint256 ID of the token to query the approval of
1805      * @return address currently approved for the given token ID
1806      */
1807     function getApproved(uint256 tokenId) public view returns (address) {
1808         require(_exists(tokenId));
1809         return _tokenApprovals[tokenId];
1810     }
1811 
1812     /**
1813      * @dev Sets or unsets the approval of a given operator
1814      * An operator is allowed to transfer all tokens of the sender on their behalf
1815      * @param to operator address to set the approval
1816      * @param approved representing the status of the approval to be set
1817      */
1818     function setApprovalForAll(address to, bool approved) public {
1819         require(to != msg.sender);
1820         _operatorApprovals[msg.sender][to] = approved;
1821         emit ApprovalForAll(msg.sender, to, approved);
1822     }
1823 
1824     /**
1825      * @dev Tells whether an operator is approved by a given owner
1826      * @param owner owner address which you want to query the approval of
1827      * @param operator operator address which you want to query the approval of
1828      * @return bool whether the given operator is approved by the given owner
1829      */
1830     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1831         return _operatorApprovals[owner][operator];
1832     }
1833 
1834     /**
1835      * @dev Transfers the ownership of a given token ID to another address
1836      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1837      * Requires the msg.sender to be the owner, approved, or operator
1838      * @param from current owner of the token
1839      * @param to address to receive the ownership of the given token ID
1840      * @param tokenId uint256 ID of the token to be transferred
1841      */
1842     function transferFrom(address from, address to, uint256 tokenId) public {
1843         require(_isApprovedOrOwner(msg.sender, tokenId));
1844 
1845         _transferFrom(from, to, tokenId);
1846     }
1847 
1848     /**
1849      * @dev Safely transfers the ownership of a given token ID to another address
1850      * If the target address is a contract, it must implement `onERC721Received`,
1851      * which is called upon a safe transfer, and return the magic value
1852      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1853      * the transfer is reverted.
1854      * Requires the msg.sender to be the owner, approved, or operator
1855      * @param from current owner of the token
1856      * @param to address to receive the ownership of the given token ID
1857      * @param tokenId uint256 ID of the token to be transferred
1858      */
1859     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1860         safeTransferFrom(from, to, tokenId, "");
1861     }
1862 
1863     /**
1864      * @dev Safely transfers the ownership of a given token ID to another address
1865      * If the target address is a contract, it must implement `onERC721Received`,
1866      * which is called upon a safe transfer, and return the magic value
1867      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1868      * the transfer is reverted.
1869      * Requires the msg.sender to be the owner, approved, or operator
1870      * @param from current owner of the token
1871      * @param to address to receive the ownership of the given token ID
1872      * @param tokenId uint256 ID of the token to be transferred
1873      * @param _data bytes data to send along with a safe transfer check
1874      */
1875     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1876         transferFrom(from, to, tokenId);
1877         require(_checkOnERC721Received(from, to, tokenId, _data));
1878     }
1879 
1880     /**
1881      * @dev Returns whether the specified token exists
1882      * @param tokenId uint256 ID of the token to query the existence of
1883      * @return bool whether the token exists
1884      */
1885     function _exists(uint256 tokenId) internal view returns (bool) {
1886         address owner = _tokenOwner[tokenId];
1887         return owner != address(0);
1888     }
1889 
1890     /**
1891      * @dev Returns whether the given spender can transfer a given token ID
1892      * @param spender address of the spender to query
1893      * @param tokenId uint256 ID of the token to be transferred
1894      * @return bool whether the msg.sender is approved for the given token ID,
1895      * is an operator of the owner, or is the owner of the token
1896      */
1897     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1898         address owner = ownerOf(tokenId);
1899         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1900     }
1901 
1902     /**
1903      * @dev Internal function to mint a new token
1904      * Reverts if the given token ID already exists
1905      * @param to The address that will own the minted token
1906      * @param tokenId uint256 ID of the token to be minted
1907      */
1908     function _mint(address to, uint256 tokenId) internal {
1909         require(to != address(0));
1910         require(!_exists(tokenId));
1911 
1912         _tokenOwner[tokenId] = to;
1913         _ownedTokensCount[to].increment();
1914 
1915         emit Transfer(address(0), to, tokenId);
1916     }
1917 
1918     /**
1919      * @dev Internal function to burn a specific token
1920      * Reverts if the token does not exist
1921      * Deprecated, use _burn(uint256) instead.
1922      * @param owner owner of the token to burn
1923      * @param tokenId uint256 ID of the token being burned
1924      */
1925     function _burn(address owner, uint256 tokenId) internal {
1926         require(ownerOf(tokenId) == owner);
1927 
1928         _clearApproval(tokenId);
1929 
1930         _ownedTokensCount[owner].decrement();
1931         _tokenOwner[tokenId] = address(0);
1932 
1933         emit Transfer(owner, address(0), tokenId);
1934     }
1935 
1936     /**
1937      * @dev Internal function to burn a specific token
1938      * Reverts if the token does not exist
1939      * @param tokenId uint256 ID of the token being burned
1940      */
1941     function _burn(uint256 tokenId) internal {
1942         _burn(ownerOf(tokenId), tokenId);
1943     }
1944 
1945     /**
1946      * @dev Internal function to transfer ownership of a given token ID to another address.
1947      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1948      * @param from current owner of the token
1949      * @param to address to receive the ownership of the given token ID
1950      * @param tokenId uint256 ID of the token to be transferred
1951      */
1952     function _transferFrom(address from, address to, uint256 tokenId) internal {
1953         require(ownerOf(tokenId) == from);
1954         require(to != address(0));
1955 
1956         _clearApproval(tokenId);
1957 
1958         _ownedTokensCount[from].decrement();
1959         _ownedTokensCount[to].increment();
1960 
1961         _tokenOwner[tokenId] = to;
1962 
1963         emit Transfer(from, to, tokenId);
1964     }
1965 
1966     /**
1967      * @dev Internal function to invoke `onERC721Received` on a target address
1968      * The call is not executed if the target address is not a contract
1969      * @param from address representing the previous owner of the given token ID
1970      * @param to target address that will receive the tokens
1971      * @param tokenId uint256 ID of the token to be transferred
1972      * @param _data bytes optional data to send along with the call
1973      * @return bool whether the call correctly returned the expected magic value
1974      */
1975     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1976         internal returns (bool)
1977     {
1978         if (!to.isContract()) {
1979             return true;
1980         }
1981 
1982         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1983         return (retval == _ERC721_RECEIVED);
1984     }
1985 
1986     /**
1987      * @dev Private function to clear current approval of a given token ID
1988      * @param tokenId uint256 ID of the token to be transferred
1989      */
1990     function _clearApproval(uint256 tokenId) private {
1991         if (_tokenApprovals[tokenId] != address(0)) {
1992             _tokenApprovals[tokenId] = address(0);
1993         }
1994     }
1995 }
1996 
1997 // File: contracts/root/withdrawManager/ExitNFT.sol
1998 
1999 pragma solidity ^0.5.2;
2000 
2001 
2002 
2003 contract ExitNFT is ERC721 {
2004     Registry internal registry;
2005 
2006     modifier onlyWithdrawManager() {
2007         require(
2008             msg.sender == registry.getWithdrawManagerAddress(),
2009             "UNAUTHORIZED_WITHDRAW_MANAGER_ONLY"
2010         );
2011         _;
2012     }
2013 
2014     constructor(address _registry) public {
2015         registry = Registry(_registry);
2016     }
2017 
2018     function mint(address _owner, uint256 _tokenId)
2019         external
2020         onlyWithdrawManager
2021     {
2022         _mint(_owner, _tokenId);
2023     }
2024 
2025     function burn(uint256 _tokenId) external onlyWithdrawManager {
2026         _burn(_tokenId);
2027     }
2028 
2029     function exists(uint256 tokenId) public view returns (bool) {
2030         return _exists(tokenId);
2031     }
2032 }
2033 
2034 // File: contracts/root/withdrawManager/WithdrawManagerStorage.sol
2035 
2036 pragma solidity ^0.5.2;
2037 
2038 
2039 
2040 
2041 
2042 
2043 contract ExitsDataStructure {
2044     struct Input {
2045         address utxoOwner;
2046         address predicate;
2047         address token;
2048     }
2049 
2050     struct PlasmaExit {
2051         uint256 receiptAmountOrNFTId;
2052         bytes32 txHash;
2053         address owner;
2054         address token;
2055         bool isRegularExit;
2056         address predicate;
2057         // Mapping from age of input to Input
2058         mapping(uint256 => Input) inputs;
2059     }
2060 }
2061 
2062 
2063 contract WithdrawManagerHeader is ExitsDataStructure {
2064     event Withdraw(uint256 indexed exitId, address indexed user, address indexed token, uint256 amount);
2065 
2066     event ExitStarted(
2067         address indexed exitor,
2068         uint256 indexed exitId,
2069         address indexed token,
2070         uint256 amount,
2071         bool isRegularExit
2072     );
2073 
2074     event ExitUpdated(uint256 indexed exitId, uint256 indexed age, address signer);
2075     event ExitPeriodUpdate(uint256 indexed oldExitPeriod, uint256 indexed newExitPeriod);
2076 
2077     event ExitCancelled(uint256 indexed exitId);
2078 }
2079 
2080 
2081 contract WithdrawManagerStorage is ProxyStorage, WithdrawManagerHeader {
2082     // 0.5 week = 7 * 86400 / 2 = 302400
2083     uint256 public HALF_EXIT_PERIOD = 302400;
2084 
2085     // Bonded exits collaterized at 0.1 ETH
2086     uint256 internal constant BOND_AMOUNT = 10**17;
2087 
2088     Registry internal registry;
2089     RootChain internal rootChain;
2090 
2091     mapping(uint128 => bool) isKnownExit;
2092     mapping(uint256 => PlasmaExit) public exits;
2093     // mapping with token => (owner => exitId) keccak(token+owner) keccak(token+owner+tokenId)
2094     mapping(bytes32 => uint256) public ownerExits;
2095     mapping(address => address) public exitsQueues;
2096     ExitNFT public exitNft;
2097 
2098     // ERC721, ERC20 and Weth transfers require 155000, 100000, 52000 gas respectively
2099     // Processing each exit in a while loop iteration requires ~52000 gas (@todo check if this changed)
2100     // uint32 constant internal ITERATION_GAS = 52000;
2101 
2102     // So putting an upper limit of 155000 + 52000 + leeway
2103     uint32 public ON_FINALIZE_GAS_LIMIT = 300000;
2104 
2105     uint256 public exitWindow;
2106 }
2107 
2108 // File: contracts/root/predicates/IPredicate.sol
2109 
2110 pragma solidity ^0.5.2;
2111 
2112 
2113 
2114 
2115 
2116 
2117 
2118 
2119 interface IPredicate {
2120     /**
2121    * @notice Verify the deprecation of a state update
2122    * @param exit ABI encoded PlasmaExit data
2123    * @param inputUtxo ABI encoded Input UTXO data
2124    * @param challengeData RLP encoded data of the challenge reference tx that encodes the following fields
2125    * headerNumber Header block number of which the reference tx was a part of
2126    * blockProof Proof that the block header (in the child chain) is a leaf in the submitted merkle root
2127    * blockNumber Block number of which the reference tx is a part of
2128    * blockTime Reference tx block time
2129    * blocktxRoot Transactions root of block
2130    * blockReceiptsRoot Receipts root of block
2131    * receipt Receipt of the reference transaction
2132    * receiptProof Merkle proof of the reference receipt
2133    * branchMask Merkle proof branchMask for the receipt
2134    * logIndex Log Index to read from the receipt
2135    * tx Challenge transaction
2136    * txProof Merkle proof of the challenge tx
2137    * @return Whether or not the state is deprecated
2138    */
2139     function verifyDeprecation(
2140         bytes calldata exit,
2141         bytes calldata inputUtxo,
2142         bytes calldata challengeData
2143     ) external returns (bool);
2144 
2145     function interpretStateUpdate(bytes calldata state)
2146         external
2147         view
2148         returns (bytes memory);
2149     function onFinalizeExit(bytes calldata data) external;
2150 }
2151 
2152 contract PredicateUtils is ExitsDataStructure, ChainIdMixin {
2153     using RLPReader for RLPReader.RLPItem;
2154 
2155     // Bonded exits collaterized at 0.1 ETH
2156     uint256 private constant BOND_AMOUNT = 10**17;
2157 
2158     IWithdrawManager internal withdrawManager;
2159     IDepositManager internal depositManager;
2160 
2161     modifier onlyWithdrawManager() {
2162         require(
2163             msg.sender == address(withdrawManager),
2164             "ONLY_WITHDRAW_MANAGER"
2165         );
2166         _;
2167     }
2168 
2169     modifier isBondProvided() {
2170         require(msg.value == BOND_AMOUNT, "Invalid Bond amount");
2171         _;
2172     }
2173 
2174     function onFinalizeExit(bytes calldata data) external onlyWithdrawManager {
2175         (, address token, address exitor, uint256 tokenId) = decodeExitForProcessExit(
2176             data
2177         );
2178         depositManager.transferAssets(token, exitor, tokenId);
2179     }
2180 
2181     function sendBond() internal {
2182         address(uint160(address(withdrawManager))).transfer(BOND_AMOUNT);
2183     }
2184 
2185     function getAddressFromTx(RLPReader.RLPItem[] memory txList)
2186         internal
2187         pure
2188         returns (address signer, bytes32 txHash)
2189     {
2190         bytes[] memory rawTx = new bytes[](9);
2191         for (uint8 i = 0; i <= 5; i++) {
2192             rawTx[i] = txList[i].toBytes();
2193         }
2194         rawTx[6] = networkId;
2195         rawTx[7] = hex""; // [7] and [8] have something to do with v, r, s values
2196         rawTx[8] = hex"";
2197 
2198         txHash = keccak256(RLPEncode.encodeList(rawTx));
2199         signer = ecrecover(
2200             txHash,
2201             Common.getV(txList[6].toBytes(), Common.toUint16(networkId)),
2202             bytes32(txList[7].toUint()),
2203             bytes32(txList[8].toUint())
2204         );
2205     }
2206 
2207     function decodeExit(bytes memory data)
2208         internal
2209         pure
2210         returns (PlasmaExit memory)
2211     {
2212         (address owner, address token, uint256 amountOrTokenId, bytes32 txHash, bool isRegularExit) = abi
2213             .decode(data, (address, address, uint256, bytes32, bool));
2214         return
2215             PlasmaExit(
2216                 amountOrTokenId,
2217                 txHash,
2218                 owner,
2219                 token,
2220                 isRegularExit,
2221                 address(0) /* predicate value is not required */
2222             );
2223     }
2224 
2225     function decodeExitForProcessExit(bytes memory data)
2226         internal
2227         pure
2228         returns (uint256 exitId, address token, address exitor, uint256 tokenId)
2229     {
2230         (exitId, token, exitor, tokenId) = abi.decode(
2231             data,
2232             (uint256, address, address, uint256)
2233         );
2234     }
2235 
2236     function decodeInputUtxo(bytes memory data)
2237         internal
2238         pure
2239         returns (uint256 age, address signer, address predicate, address token)
2240     {
2241         (age, signer, predicate, token) = abi.decode(
2242             data,
2243             (uint256, address, address, address)
2244         );
2245     }
2246 
2247 }
2248 
2249 contract IErcPredicate is IPredicate, PredicateUtils {
2250     enum ExitType {Invalid, OutgoingTransfer, IncomingTransfer, Burnt}
2251 
2252     struct ExitTxData {
2253         uint256 amountOrToken;
2254         bytes32 txHash;
2255         address childToken;
2256         address signer;
2257         ExitType exitType;
2258     }
2259 
2260     struct ReferenceTxData {
2261         uint256 closingBalance;
2262         uint256 age;
2263         address childToken;
2264         address rootToken;
2265     }
2266 
2267     uint256 internal constant MAX_LOGS = 10;
2268 
2269     constructor(address _withdrawManager, address _depositManager) public {
2270         withdrawManager = IWithdrawManager(_withdrawManager);
2271         depositManager = IDepositManager(_depositManager);
2272     }
2273 }
2274 
2275 // File: contracts/root/predicates/ERC20PredicateBurnOnly.sol
2276 
2277 pragma solidity ^0.5.2;
2278 
2279 
2280 
2281 
2282 
2283 
2284 
2285 
2286 
2287 
2288 
2289 contract ERC20PredicateBurnOnly is IErcPredicate {
2290     using RLPReader for bytes;
2291     using RLPReader for RLPReader.RLPItem;
2292     using SafeMath for uint256;
2293 
2294     using ExitPayloadReader for bytes;
2295     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
2296     using ExitPayloadReader for ExitPayloadReader.Receipt;
2297     using ExitPayloadReader for ExitPayloadReader.Log;
2298     using ExitPayloadReader for ExitPayloadReader.LogTopics;
2299 
2300     // keccak256('Withdraw(address,address,uint256,uint256,uint256)')
2301     bytes32 constant WITHDRAW_EVENT_SIG = 0xebff2602b3f468259e1e99f613fed6691f3a6526effe6ef3e768ba7ae7a36c4f;
2302 
2303     constructor(
2304         address _withdrawManager,
2305         address _depositManager
2306     ) public IErcPredicate(_withdrawManager, _depositManager) {
2307     }
2308 
2309     function startExitWithBurntTokens(bytes calldata data) external {
2310         ExitPayloadReader.ExitPayload memory payload = data.toExitPayload();
2311         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
2312         uint256 logIndex = payload.getReceiptLogIndex();
2313         require(logIndex < MAX_LOGS, "Supporting a max of 10 logs");
2314         uint256 age = withdrawManager.verifyInclusion(
2315             data,
2316             0, /* offset */
2317             false /* verifyTxInclusion */
2318         );
2319         ExitPayloadReader.Log memory log = receipt.getLog();
2320 
2321         // "address" (contract address that emitted the log) field in the receipt
2322         address childToken = log.getEmitter();
2323         ExitPayloadReader.LogTopics memory topics = log.getTopics();
2324         // now, inputItems[i] refers to i-th (0-based) topic in the topics array
2325         // event Withdraw(address indexed token, address indexed from, uint256 amountOrTokenId, uint256 input1, uint256 output1)
2326         require(
2327             bytes32(topics.getField(0).toUint()) == WITHDRAW_EVENT_SIG,
2328             "Not a withdraw event signature"
2329         );
2330         require(
2331             msg.sender == address(topics.getField(2).toUint()), // from
2332             "Withdrawer and burn exit tx do not match"
2333         );
2334         address rootToken = address(topics.getField(1).toUint());
2335         uint256 exitAmount = BytesLib.toUint(log.getData(), 0); // amountOrTokenId
2336         withdrawManager.addExitToQueue(
2337             msg.sender,
2338             childToken,
2339             rootToken,
2340             exitAmount,
2341             bytes32(0x0),
2342             true, /* isRegularExit */
2343             age << 1
2344         );
2345     }
2346 
2347     function verifyDeprecation(
2348         bytes calldata exit,
2349         bytes calldata inputUtxo,
2350         bytes calldata challengeData
2351     ) external returns (bool) {}
2352 
2353     function interpretStateUpdate(bytes calldata state)
2354         external
2355         view
2356         returns (bytes memory) {}
2357 }