1 pragma solidity ^0.5.2;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 
70 library BytesLib {
71     function concat(bytes memory _preBytes, bytes memory _postBytes)
72         internal
73         pure
74         returns (bytes memory)
75     {
76         bytes memory tempBytes;
77         assembly {
78             // Get a location of some free memory and store it in tempBytes as
79             // Solidity does for memory variables.
80             tempBytes := mload(0x40)
81 
82             // Store the length of the first bytes array at the beginning of
83             // the memory for tempBytes.
84             let length := mload(_preBytes)
85             mstore(tempBytes, length)
86 
87             // Maintain a memory counter for the current write location in the
88             // temp bytes array by adding the 32 bytes for the array length to
89             // the starting location.
90             let mc := add(tempBytes, 0x20)
91             // Stop copying when the memory counter reaches the length of the
92             // first bytes array.
93             let end := add(mc, length)
94 
95             for {
96                 // Initialize a copy counter to the start of the _preBytes data,
97                 // 32 bytes into its memory.
98                 let cc := add(_preBytes, 0x20)
99             } lt(mc, end) {
100                 // Increase both counters by 32 bytes each iteration.
101                 mc := add(mc, 0x20)
102                 cc := add(cc, 0x20)
103             } {
104                 // Write the _preBytes data into the tempBytes memory 32 bytes
105                 // at a time.
106                 mstore(mc, mload(cc))
107             }
108 
109             // Add the length of _postBytes to the current length of tempBytes
110             // and store it as the new length in the first 32 bytes of the
111             // tempBytes memory.
112             length := mload(_postBytes)
113             mstore(tempBytes, add(length, mload(tempBytes)))
114 
115             // Move the memory counter back from a multiple of 0x20 to the
116             // actual end of the _preBytes data.
117             mc := end
118             // Stop copying when the memory counter reaches the new combined
119             // length of the arrays.
120             end := add(mc, length)
121 
122             for {
123                 let cc := add(_postBytes, 0x20)
124             } lt(mc, end) {
125                 mc := add(mc, 0x20)
126                 cc := add(cc, 0x20)
127             } {
128                 mstore(mc, mload(cc))
129             }
130 
131             // Update the free-memory pointer by padding our last write location
132             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
133             // next 32 byte block, then round down to the nearest multiple of
134             // 32. If the sum of the length of the two arrays is zero then add
135             // one before rounding down to leave a blank 32 bytes (the length block with 0).
136             mstore(
137                 0x40,
138                 and(
139                     add(add(end, iszero(add(length, mload(_preBytes)))), 31),
140                     not(31) // Round down to the nearest 32 bytes.
141                 )
142             )
143         }
144         return tempBytes;
145     }
146 
147     function slice(bytes memory _bytes, uint256 _start, uint256 _length)
148         internal
149         pure
150         returns (bytes memory)
151     {
152         require(_bytes.length >= (_start + _length));
153         bytes memory tempBytes;
154         assembly {
155             switch iszero(_length)
156                 case 0 {
157                     // Get a location of some free memory and store it in tempBytes as
158                     // Solidity does for memory variables.
159                     tempBytes := mload(0x40)
160 
161                     // The first word of the slice result is potentially a partial
162                     // word read from the original array. To read it, we calculate
163                     // the length of that partial word and start copying that many
164                     // bytes into the array. The first word we copy will start with
165                     // data we don't care about, but the last `lengthmod` bytes will
166                     // land at the beginning of the contents of the new array. When
167                     // we're done copying, we overwrite the full first word with
168                     // the actual length of the slice.
169                     let lengthmod := and(_length, 31)
170 
171                     // The multiplication in the next line is necessary
172                     // because when slicing multiples of 32 bytes (lengthmod == 0)
173                     // the following copy loop was copying the origin's length
174                     // and then ending prematurely not copying everything it should.
175                     let mc := add(
176                         add(tempBytes, lengthmod),
177                         mul(0x20, iszero(lengthmod))
178                     )
179                     let end := add(mc, _length)
180 
181                     for {
182                         // The multiplication in the next line has the same exact purpose
183                         // as the one above.
184                         let cc := add(
185                             add(
186                                 add(_bytes, lengthmod),
187                                 mul(0x20, iszero(lengthmod))
188                             ),
189                             _start
190                         )
191                     } lt(mc, end) {
192                         mc := add(mc, 0x20)
193                         cc := add(cc, 0x20)
194                     } {
195                         mstore(mc, mload(cc))
196                     }
197 
198                     mstore(tempBytes, _length)
199 
200                     //update free-memory pointer
201                     //allocating the array padded to 32 bytes like the compiler does now
202                     mstore(0x40, and(add(mc, 31), not(31)))
203                 }
204                 //if we want a zero-length slice let's just return a zero-length array
205                 default {
206                     tempBytes := mload(0x40)
207                     mstore(0x40, add(tempBytes, 0x20))
208                 }
209         }
210 
211         return tempBytes;
212     }
213 
214     // Pad a bytes array to 32 bytes
215     function leftPad(bytes memory _bytes) internal pure returns (bytes memory) {
216         // may underflow if bytes.length < 32. Hence using SafeMath.sub
217         bytes memory newBytes = new bytes(SafeMath.sub(32, _bytes.length));
218         return concat(newBytes, _bytes);
219     }
220 
221     function toBytes32(bytes memory b) internal pure returns (bytes32) {
222         require(b.length >= 32, "Bytes array should atleast be 32 bytes");
223         bytes32 out;
224         for (uint256 i = 0; i < 32; i++) {
225             out |= bytes32(b[i] & 0xFF) >> (i * 8);
226         }
227         return out;
228     }
229 
230     function toBytes4(bytes memory b) internal pure returns (bytes4 result) {
231         assembly {
232             result := mload(add(b, 32))
233         }
234     }
235 
236     function fromBytes32(bytes32 x) internal pure returns (bytes memory) {
237         bytes memory b = new bytes(32);
238         for (uint256 i = 0; i < 32; i++) {
239             b[i] = bytes1(uint8(uint256(x) / (2**(8 * (31 - i)))));
240         }
241         return b;
242     }
243 
244     function fromUint(uint256 _num) internal pure returns (bytes memory _ret) {
245         _ret = new bytes(32);
246         assembly {
247             mstore(add(_ret, 32), _num)
248         }
249     }
250 
251     function toUint(bytes memory _bytes, uint256 _start)
252         internal
253         pure
254         returns (uint256)
255     {
256         require(_bytes.length >= (_start + 32));
257         uint256 tempUint;
258         assembly {
259             tempUint := mload(add(add(_bytes, 0x20), _start))
260         }
261         return tempUint;
262     }
263 
264     function toAddress(bytes memory _bytes, uint256 _start)
265         internal
266         pure
267         returns (address)
268     {
269         require(_bytes.length >= (_start + 20));
270         address tempAddress;
271         assembly {
272             tempAddress := div(
273                 mload(add(add(_bytes, 0x20), _start)),
274                 0x1000000000000000000000000
275             )
276         }
277 
278         return tempAddress;
279     }
280 }
281 
282 
283 
284 library Common {
285     function getV(bytes memory v, uint16 chainId) public pure returns (uint8) {
286         if (chainId > 0) {
287             return
288                 uint8(
289                     BytesLib.toUint(BytesLib.leftPad(v), 0) - (chainId * 2) - 8
290                 );
291         } else {
292             return uint8(BytesLib.toUint(BytesLib.leftPad(v), 0));
293         }
294     }
295 
296     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
297     function isContract(address _addr) public view returns (bool) {
298         uint256 length;
299         assembly {
300             //retrieve the size of the code on target address, this needs assembly
301             length := extcodesize(_addr)
302         }
303         return (length > 0);
304     }
305 
306     // convert bytes to uint8
307     function toUint8(bytes memory _arg) public pure returns (uint8) {
308         return uint8(_arg[0]);
309     }
310 
311     function toUint16(bytes memory _arg) public pure returns (uint16) {
312         return (uint16(uint8(_arg[0])) << 8) | uint16(uint8(_arg[1]));
313     }
314 }
315 
316 
317 
318 /**
319  * @title Math
320  * @dev Assorted math operations
321  */
322 library Math {
323     /**
324      * @dev Returns the largest of two numbers.
325      */
326     function max(uint256 a, uint256 b) internal pure returns (uint256) {
327         return a >= b ? a : b;
328     }
329 
330     /**
331      * @dev Returns the smallest of two numbers.
332      */
333     function min(uint256 a, uint256 b) internal pure returns (uint256) {
334         return a < b ? a : b;
335     }
336 
337     /**
338      * @dev Calculates the average of two numbers. Since these are integers,
339      * averages of an even and odd number cannot be represented, and will be
340      * rounded down.
341      */
342     function average(uint256 a, uint256 b) internal pure returns (uint256) {
343         // (a + b) / 2 can overflow, so we distribute
344         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
345     }
346 }
347 
348 
349 // Library for RLP encoding a list of bytes arrays.
350 // Modeled after ethereumjs/rlp (https://github.com/ethereumjs/rlp)
351 // [Very] modified version of Sam Mayo's library.
352 
353 library RLPEncode {
354     // Encode an item (bytes memory)
355     function encodeItem(bytes memory self)
356         internal
357         pure
358         returns (bytes memory)
359     {
360         bytes memory encoded;
361         if (self.length == 1 && uint8(self[0] & 0xFF) < 0x80) {
362             encoded = new bytes(1);
363             encoded = self;
364         } else {
365             encoded = BytesLib.concat(encodeLength(self.length, 128), self);
366         }
367         return encoded;
368     }
369 
370     // Encode a list of items
371     function encodeList(bytes[] memory self)
372         internal
373         pure
374         returns (bytes memory)
375     {
376         bytes memory encoded;
377         for (uint256 i = 0; i < self.length; i++) {
378             encoded = BytesLib.concat(encoded, encodeItem(self[i]));
379         }
380         return BytesLib.concat(encodeLength(encoded.length, 192), encoded);
381     }
382 
383     // Hack to encode nested lists. If you have a list as an item passed here, included
384     // pass = true in that index. E.g.
385     // [item, list, item] --> pass = [false, true, false]
386     // function encodeListWithPasses(bytes[] memory self, bool[] pass) internal pure returns (bytes memory) {
387     //   bytes memory encoded;
388     //   for (uint i=0; i < self.length; i++) {
389     //   if (pass[i] == true) {
390     //   encoded = BytesLib.concat(encoded, self[i]);
391     //   } else {
392     //   encoded = BytesLib.concat(encoded, encodeItem(self[i]));
393     //   }
394     //   }
395     //   return BytesLib.concat(encodeLength(encoded.length, 192), encoded);
396     // }
397 
398     // Generate the prefix for an item or the entire list based on RLP spec
399     function encodeLength(uint256 L, uint256 offset)
400         internal
401         pure
402         returns (bytes memory)
403     {
404         if (L < 56) {
405             bytes memory prefix = new bytes(1);
406             prefix[0] = bytes1(uint8(L + offset));
407             return prefix;
408         } else {
409             // lenLen is the length of the hex representation of the data length
410             uint256 lenLen;
411             uint256 i = 0x1;
412 
413             while (L / i != 0) {
414                 lenLen++;
415                 i *= 0x100;
416             }
417 
418             bytes memory prefix0 = getLengthBytes(offset + 55 + lenLen);
419             bytes memory prefix1 = getLengthBytes(L);
420             return BytesLib.concat(prefix0, prefix1);
421         }
422     }
423 
424     function getLengthBytes(uint256 x) internal pure returns (bytes memory b) {
425         // Figure out if we need 1 or two bytes to express the length.
426         // 1 byte gets us to max 255
427         // 2 bytes gets us to max 65535 (no payloads will be larger than this)
428         uint256 nBytes = 1;
429         if (x > 255) {
430             nBytes = 2;
431         }
432 
433         b = new bytes(nBytes);
434         // Encode the length and return it
435         for (uint256 i = 0; i < nBytes; i++) {
436             b[i] = bytes1(uint8(x / (2**(8 * (nBytes - 1 - i)))));
437         }
438     }
439 }
440 
441 
442 /*
443 * @author Hamdi Allam hamdi.allam97@gmail.com
444 * Please reach out with any questions or concerns
445 */
446 
447 library RLPReader {
448     uint8 constant STRING_SHORT_START = 0x80;
449     uint8 constant STRING_LONG_START  = 0xb8;
450     uint8 constant LIST_SHORT_START   = 0xc0;
451     uint8 constant LIST_LONG_START    = 0xf8;
452     uint8 constant WORD_SIZE = 32;
453 
454     struct RLPItem {
455         uint len;
456         uint memPtr;
457     }
458 
459     struct Iterator {
460         RLPItem item;   // Item that's being iterated over.
461         uint nextPtr;   // Position of the next item in the list.
462     }
463 
464     /*
465     * @dev Returns the next element in the iteration. Reverts if it has not next element.
466     * @param self The iterator.
467     * @return The next element in the iteration.
468     */
469     function next(Iterator memory self) internal pure returns (RLPItem memory) {
470         require(hasNext(self));
471 
472         uint ptr = self.nextPtr;
473         uint itemLength = _itemLength(ptr);
474         self.nextPtr = ptr + itemLength;
475 
476         return RLPItem(itemLength, ptr);
477     }
478 
479     /*
480     * @dev Returns true if the iteration has more elements.
481     * @param self The iterator.
482     * @return true if the iteration has more elements.
483     */
484     function hasNext(Iterator memory self) internal pure returns (bool) {
485         RLPItem memory item = self.item;
486         return self.nextPtr < item.memPtr + item.len;
487     }
488 
489     /*
490     * @param item RLP encoded bytes
491     */
492     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
493         uint memPtr;
494         assembly {
495             memPtr := add(item, 0x20)
496         }
497 
498         return RLPItem(item.length, memPtr);
499     }
500 
501     /*
502     * @dev Create an iterator. Reverts if item is not a list.
503     * @param self The RLP item.
504     * @return An 'Iterator' over the item.
505     */
506     function iterator(RLPItem memory self) internal pure returns (Iterator memory) {
507         require(isList(self));
508 
509         uint ptr = self.memPtr + _payloadOffset(self.memPtr);
510         return Iterator(self, ptr);
511     }
512 
513     /*
514     * @param item RLP encoded bytes
515     */
516     function rlpLen(RLPItem memory item) internal pure returns (uint) {
517         return item.len;
518     }
519 
520     /*
521     * @param item RLP encoded bytes
522     */
523     function payloadLen(RLPItem memory item) internal pure returns (uint) {
524         return item.len - _payloadOffset(item.memPtr);
525     }
526 
527     /*
528     * @param item RLP encoded list in bytes
529     */
530     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory) {
531         require(isList(item));
532 
533         uint items = numItems(item);
534         RLPItem[] memory result = new RLPItem[](items);
535 
536         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
537         uint dataLen;
538         for (uint i = 0; i < items; i++) {
539             dataLen = _itemLength(memPtr);
540             result[i] = RLPItem(dataLen, memPtr); 
541             memPtr = memPtr + dataLen;
542         }
543 
544         return result;
545     }
546 
547     // @return indicator whether encoded payload is a list. negate this function call for isData.
548     function isList(RLPItem memory item) internal pure returns (bool) {
549         if (item.len == 0) return false;
550 
551         uint8 byte0;
552         uint memPtr = item.memPtr;
553         assembly {
554             byte0 := byte(0, mload(memPtr))
555         }
556 
557         if (byte0 < LIST_SHORT_START)
558             return false;
559         return true;
560     }
561 
562     /** RLPItem conversions into data types **/
563 
564     // @returns raw rlp encoding in bytes
565     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
566         bytes memory result = new bytes(item.len);
567         if (result.length == 0) return result;
568         
569         uint ptr;
570         assembly {
571             ptr := add(0x20, result)
572         }
573 
574         copy(item.memPtr, ptr, item.len);
575         return result;
576     }
577 
578     // any non-zero byte is considered true
579     function toBoolean(RLPItem memory item) internal pure returns (bool) {
580         require(item.len == 1);
581         uint result;
582         uint memPtr = item.memPtr;
583         assembly {
584             result := byte(0, mload(memPtr))
585         }
586 
587         return result == 0 ? false : true;
588     }
589 
590     function toAddress(RLPItem memory item) internal pure returns (address) {
591         // 1 byte for the length prefix
592         require(item.len == 21);
593 
594         return address(toUint(item));
595     }
596 
597     function toUint(RLPItem memory item) internal pure returns (uint) {
598         require(item.len > 0 && item.len <= 33);
599 
600         uint offset = _payloadOffset(item.memPtr);
601         uint len = item.len - offset;
602 
603         uint result;
604         uint memPtr = item.memPtr + offset;
605         assembly {
606             result := mload(memPtr)
607 
608             // shfit to the correct location if neccesary
609             if lt(len, 32) {
610                 result := div(result, exp(256, sub(32, len)))
611             }
612         }
613 
614         return result;
615     }
616 
617     // enforces 32 byte length
618     function toUintStrict(RLPItem memory item) internal pure returns (uint) {
619         // one byte prefix
620         require(item.len == 33);
621 
622         uint result;
623         uint memPtr = item.memPtr + 1;
624         assembly {
625             result := mload(memPtr)
626         }
627 
628         return result;
629     }
630 
631     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
632         require(item.len > 0);
633 
634         uint offset = _payloadOffset(item.memPtr);
635         uint len = item.len - offset; // data length
636         bytes memory result = new bytes(len);
637 
638         uint destPtr;
639         assembly {
640             destPtr := add(0x20, result)
641         }
642 
643         copy(item.memPtr + offset, destPtr, len);
644         return result;
645     }
646 
647     /*
648     * Private Helpers
649     */
650 
651     // @return number of payload items inside an encoded list.
652     function numItems(RLPItem memory item) private pure returns (uint) {
653         if (item.len == 0) return 0;
654 
655         uint count = 0;
656         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
657         uint endPtr = item.memPtr + item.len;
658         while (currPtr < endPtr) {
659            currPtr = currPtr + _itemLength(currPtr); // skip over an item
660            count++;
661         }
662 
663         return count;
664     }
665 
666     // @return entire rlp item byte length
667     function _itemLength(uint memPtr) private pure returns (uint) {
668         uint itemLen;
669         uint byte0;
670         assembly {
671             byte0 := byte(0, mload(memPtr))
672         }
673 
674         if (byte0 < STRING_SHORT_START)
675             itemLen = 1;
676         
677         else if (byte0 < STRING_LONG_START)
678             itemLen = byte0 - STRING_SHORT_START + 1;
679 
680         else if (byte0 < LIST_SHORT_START) {
681             assembly {
682                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
683                 memPtr := add(memPtr, 1) // skip over the first byte
684                 
685                 /* 32 byte word size */
686                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
687                 itemLen := add(dataLen, add(byteLen, 1))
688             }
689         }
690 
691         else if (byte0 < LIST_LONG_START) {
692             itemLen = byte0 - LIST_SHORT_START + 1;
693         } 
694 
695         else {
696             assembly {
697                 let byteLen := sub(byte0, 0xf7)
698                 memPtr := add(memPtr, 1)
699 
700                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
701                 itemLen := add(dataLen, add(byteLen, 1))
702             }
703         }
704 
705         return itemLen;
706     }
707 
708     // @return number of bytes until the data
709     function _payloadOffset(uint memPtr) private pure returns (uint) {
710         uint byte0;
711         assembly {
712             byte0 := byte(0, mload(memPtr))
713         }
714 
715         if (byte0 < STRING_SHORT_START) 
716             return 0;
717         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
718             return 1;
719         else if (byte0 < LIST_SHORT_START)  // being explicit
720             return byte0 - (STRING_LONG_START - 1) + 1;
721         else
722             return byte0 - (LIST_LONG_START - 1) + 1;
723     }
724 
725     /*
726     * @param src Pointer to source
727     * @param dest Pointer to destination
728     * @param len Amount of memory to copy from the source
729     */
730     function copy(uint src, uint dest, uint len) private pure {
731         if (len == 0) return;
732 
733         // copy as many word sizes as possible
734         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
735             assembly {
736                 mstore(dest, mload(src))
737             }
738 
739             src += WORD_SIZE;
740             dest += WORD_SIZE;
741         }
742 
743         // left over bytes. Mask is used to remove unwanted bytes from the word
744         uint mask = 256 ** (WORD_SIZE - len) - 1;
745         assembly {
746             let srcpart := and(mload(src), not(mask)) // zero out src
747             let destpart := and(mload(dest), mask) // retrieve the bytes
748             mstore(dest, or(destpart, srcpart))
749         }
750     }
751 }
752 
753 
754 
755 
756 library ExitPayloadReader {
757   using RLPReader for bytes;
758   using RLPReader for RLPReader.RLPItem;
759 
760   uint8 constant WORD_SIZE = 32;
761 
762   struct ExitPayload {
763     RLPReader.RLPItem[] data;
764   }
765 
766   struct Receipt {
767     RLPReader.RLPItem[] data;
768     bytes raw;
769     uint256 logIndex;
770   }
771 
772   struct Log {
773     RLPReader.RLPItem data;
774     RLPReader.RLPItem[] list;
775   }
776 
777   struct LogTopics {
778     RLPReader.RLPItem[] data;
779   }
780 
781   function toExitPayload(bytes memory data)
782         internal
783         pure
784         returns (ExitPayload memory)
785     {
786         RLPReader.RLPItem[] memory payloadData = data
787             .toRlpItem()
788             .toList();
789 
790         return ExitPayload(payloadData);
791     }
792 
793     function copy(uint src, uint dest, uint len) private pure {
794         if (len == 0) return;
795 
796         // copy as many word sizes as possible
797         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
798             assembly {
799                 mstore(dest, mload(src))
800             }
801 
802             src += WORD_SIZE;
803             dest += WORD_SIZE;
804         }
805 
806         // left over bytes. Mask is used to remove unwanted bytes from the word
807         uint mask = 256 ** (WORD_SIZE - len) - 1;
808         assembly {
809             let srcpart := and(mload(src), not(mask)) // zero out src
810             let destpart := and(mload(dest), mask) // retrieve the bytes
811             mstore(dest, or(destpart, srcpart))
812         }
813     }
814 
815     function getHeaderNumber(ExitPayload memory payload) internal pure returns(uint256) {
816       return payload.data[0].toUint();
817     }
818 
819     function getBlockProof(ExitPayload memory payload) internal pure returns(bytes memory) {
820       return payload.data[1].toBytes();
821     }
822 
823     function getBlockNumber(ExitPayload memory payload) internal pure returns(uint256) {
824       return payload.data[2].toUint();
825     }
826 
827     function getBlockTime(ExitPayload memory payload) internal pure returns(uint256) {
828       return payload.data[3].toUint();
829     }
830 
831     function getTxRoot(ExitPayload memory payload) internal pure returns(bytes32) {
832       return bytes32(payload.data[4].toUint());
833     }
834 
835     function getReceiptRoot(ExitPayload memory payload) internal pure returns(bytes32) {
836       return bytes32(payload.data[5].toUint());
837     }
838 
839     function getReceipt(ExitPayload memory payload) internal pure returns(Receipt memory receipt) {
840       receipt.raw = payload.data[6].toBytes();
841       RLPReader.RLPItem memory receiptItem = receipt.raw.toRlpItem();
842 
843       if (receiptItem.isList()) {
844           // legacy tx
845           receipt.data = receiptItem.toList();
846       } else {
847           // pop first byte before parsting receipt
848           bytes memory typedBytes = receipt.raw;
849           bytes memory result = new bytes(typedBytes.length - 1);
850           uint256 srcPtr;
851           uint256 destPtr;
852           assembly {
853               srcPtr := add(33, typedBytes)
854               destPtr := add(0x20, result)
855           }
856 
857           copy(srcPtr, destPtr, result.length);
858           receipt.data = result.toRlpItem().toList();
859       }
860 
861       receipt.logIndex = getReceiptLogIndex(payload);
862       return receipt;
863     }
864 
865     function getReceiptProof(ExitPayload memory payload) internal pure returns(bytes memory) {
866       return payload.data[7].toBytes();
867     }
868 
869     function getBranchMaskAsBytes(ExitPayload memory payload) internal pure returns(bytes memory) {
870       return payload.data[8].toBytes();
871     }
872 
873     function getBranchMaskAsUint(ExitPayload memory payload) internal pure returns(uint256) {
874       return payload.data[8].toUint();
875     }
876 
877     function getReceiptLogIndex(ExitPayload memory payload) internal pure returns(uint256) {
878       return payload.data[9].toUint();
879     }
880 
881     function getTx(ExitPayload memory payload) internal pure returns(bytes memory) {
882       return payload.data[10].toBytes();
883     }
884 
885     function getTxProof(ExitPayload memory payload) internal pure returns(bytes memory) {
886       return payload.data[11].toBytes();
887     }
888     
889     // Receipt methods
890     function toBytes(Receipt memory receipt) internal pure returns(bytes memory) {
891         return receipt.raw;
892     }
893 
894     function getLog(Receipt memory receipt) internal pure returns(Log memory) {
895         RLPReader.RLPItem memory logData = receipt.data[3].toList()[receipt.logIndex];
896         return Log(logData, logData.toList());
897     }
898 
899     // Log methods
900     function getEmitter(Log memory log) internal pure returns(address) {
901       return RLPReader.toAddress(log.list[0]);
902     }
903 
904     function getTopics(Log memory log) internal pure returns(LogTopics memory) {
905         return LogTopics(log.list[1].toList());
906     }
907 
908     function getData(Log memory log) internal pure returns(bytes memory) {
909         return log.list[2].toBytes();
910     }
911 
912     function toRlpBytes(Log memory log) internal pure returns(bytes memory) {
913       return log.data.toRlpBytes();
914     }
915 
916     // LogTopics methods
917     function getField(LogTopics memory topics, uint256 index) internal pure returns(RLPReader.RLPItem memory) {
918       return topics.data[index];
919     }
920 }
921 
922 
923 
924 contract IWithdrawManager {
925     function createExitQueue(address token) external;
926 
927     function verifyInclusion(
928         bytes calldata data,
929         uint8 offset,
930         bool verifyTxInclusion
931     ) external view returns (uint256 age);
932 
933     function addExitToQueue(
934         address exitor,
935         address childToken,
936         address rootToken,
937         uint256 exitAmountOrTokenId,
938         bytes32 txHash,
939         bool isRegularExit,
940         uint256 priority
941     ) external;
942 
943     function addInput(
944         uint256 exitId,
945         uint256 age,
946         address utxoOwner,
947         address token
948     ) external;
949 
950     function challengeExit(
951         uint256 exitId,
952         uint256 inputId,
953         bytes calldata challengeData,
954         address adjudicatorPredicate
955     ) external;
956 }
957 
958 
959 
960 interface IDepositManager {
961     function depositEther() external payable;
962     function transferAssets(
963         address _token,
964         address _user,
965         uint256 _amountOrNFTId
966     ) external;
967     function depositERC20(address _token, uint256 _amount) external;
968     function depositERC721(address _token, uint256 _tokenId) external;
969 }
970 
971 
972 
973 /**
974  * @title Ownable
975  * @dev The Ownable contract has an owner address, and provides basic authorization control
976  * functions, this simplifies the implementation of "user permissions".
977  */
978 contract Ownable {
979     address private _owner;
980 
981     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
982 
983     /**
984      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
985      * account.
986      */
987     constructor () internal {
988         _owner = msg.sender;
989         emit OwnershipTransferred(address(0), _owner);
990     }
991 
992     /**
993      * @return the address of the owner.
994      */
995     function owner() public view returns (address) {
996         return _owner;
997     }
998 
999     /**
1000      * @dev Throws if called by any account other than the owner.
1001      */
1002     modifier onlyOwner() {
1003         require(isOwner());
1004         _;
1005     }
1006 
1007     /**
1008      * @return true if `msg.sender` is the owner of the contract.
1009      */
1010     function isOwner() public view returns (bool) {
1011         return msg.sender == _owner;
1012     }
1013 
1014     /**
1015      * @dev Allows the current owner to relinquish control of the contract.
1016      * It will not be possible to call the functions with the `onlyOwner`
1017      * modifier anymore.
1018      * @notice Renouncing ownership will leave the contract without an owner,
1019      * thereby removing any functionality that is only available to the owner.
1020      */
1021     function renounceOwnership() public onlyOwner {
1022         emit OwnershipTransferred(_owner, address(0));
1023         _owner = address(0);
1024     }
1025 
1026     /**
1027      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1028      * @param newOwner The address to transfer ownership to.
1029      */
1030     function transferOwnership(address newOwner) public onlyOwner {
1031         _transferOwnership(newOwner);
1032     }
1033 
1034     /**
1035      * @dev Transfers control of the contract to a newOwner.
1036      * @param newOwner The address to transfer ownership to.
1037      */
1038     function _transferOwnership(address newOwner) internal {
1039         require(newOwner != address(0));
1040         emit OwnershipTransferred(_owner, newOwner);
1041         _owner = newOwner;
1042     }
1043 }
1044 
1045 
1046 
1047 contract ProxyStorage is Ownable {
1048     address internal proxyTo;
1049 }
1050 
1051 
1052 
1053 interface IGovernance {
1054     function update(address target, bytes calldata data) external;
1055 }
1056 
1057 
1058 
1059 contract Governable {
1060     IGovernance public governance;
1061 
1062     constructor(address _governance) public {
1063         governance = IGovernance(_governance);
1064     }
1065 
1066     modifier onlyGovernance() {
1067         _assertGovernance();
1068         _;
1069     }
1070 
1071     function _assertGovernance() private view {
1072         require(
1073             msg.sender == address(governance),
1074             "Only governance contract is authorized"
1075         );
1076     }
1077 }
1078 
1079 
1080 
1081 
1082 contract Registry is Governable {
1083     // @todo hardcode constants
1084     bytes32 private constant WETH_TOKEN = keccak256("wethToken");
1085     bytes32 private constant DEPOSIT_MANAGER = keccak256("depositManager");
1086     bytes32 private constant STAKE_MANAGER = keccak256("stakeManager");
1087     bytes32 private constant VALIDATOR_SHARE = keccak256("validatorShare");
1088     bytes32 private constant WITHDRAW_MANAGER = keccak256("withdrawManager");
1089     bytes32 private constant CHILD_CHAIN = keccak256("childChain");
1090     bytes32 private constant STATE_SENDER = keccak256("stateSender");
1091     bytes32 private constant SLASHING_MANAGER = keccak256("slashingManager");
1092 
1093     address public erc20Predicate;
1094     address public erc721Predicate;
1095 
1096     mapping(bytes32 => address) public contractMap;
1097     mapping(address => address) public rootToChildToken;
1098     mapping(address => address) public childToRootToken;
1099     mapping(address => bool) public proofValidatorContracts;
1100     mapping(address => bool) public isERC721;
1101 
1102     enum Type {Invalid, ERC20, ERC721, Custom}
1103     struct Predicate {
1104         Type _type;
1105     }
1106     mapping(address => Predicate) public predicates;
1107 
1108     event TokenMapped(address indexed rootToken, address indexed childToken);
1109     event ProofValidatorAdded(address indexed validator, address indexed from);
1110     event ProofValidatorRemoved(address indexed validator, address indexed from);
1111     event PredicateAdded(address indexed predicate, address indexed from);
1112     event PredicateRemoved(address indexed predicate, address indexed from);
1113     event ContractMapUpdated(bytes32 indexed key, address indexed previousContract, address indexed newContract);
1114 
1115     constructor(address _governance) public Governable(_governance) {}
1116 
1117     function updateContractMap(bytes32 _key, address _address) external onlyGovernance {
1118         emit ContractMapUpdated(_key, contractMap[_key], _address);
1119         contractMap[_key] = _address;
1120     }
1121 
1122     /**
1123      * @dev Map root token to child token
1124      * @param _rootToken Token address on the root chain
1125      * @param _childToken Token address on the child chain
1126      * @param _isERC721 Is the token being mapped ERC721
1127      */
1128     function mapToken(
1129         address _rootToken,
1130         address _childToken,
1131         bool _isERC721
1132     ) external onlyGovernance {
1133         require(_rootToken != address(0x0) && _childToken != address(0x0), "INVALID_TOKEN_ADDRESS");
1134         rootToChildToken[_rootToken] = _childToken;
1135         childToRootToken[_childToken] = _rootToken;
1136         isERC721[_rootToken] = _isERC721;
1137         IWithdrawManager(contractMap[WITHDRAW_MANAGER]).createExitQueue(_rootToken);
1138         emit TokenMapped(_rootToken, _childToken);
1139     }
1140 
1141     function addErc20Predicate(address predicate) public onlyGovernance {
1142         require(predicate != address(0x0), "Can not add null address as predicate");
1143         erc20Predicate = predicate;
1144         addPredicate(predicate, Type.ERC20);
1145     }
1146 
1147     function addErc721Predicate(address predicate) public onlyGovernance {
1148         erc721Predicate = predicate;
1149         addPredicate(predicate, Type.ERC721);
1150     }
1151 
1152     function addPredicate(address predicate, Type _type) public onlyGovernance {
1153         require(predicates[predicate]._type == Type.Invalid, "Predicate already added");
1154         predicates[predicate]._type = _type;
1155         emit PredicateAdded(predicate, msg.sender);
1156     }
1157 
1158     function removePredicate(address predicate) public onlyGovernance {
1159         require(predicates[predicate]._type != Type.Invalid, "Predicate does not exist");
1160         delete predicates[predicate];
1161         emit PredicateRemoved(predicate, msg.sender);
1162     }
1163 
1164     function getValidatorShareAddress() public view returns (address) {
1165         return contractMap[VALIDATOR_SHARE];
1166     }
1167 
1168     function getWethTokenAddress() public view returns (address) {
1169         return contractMap[WETH_TOKEN];
1170     }
1171 
1172     function getDepositManagerAddress() public view returns (address) {
1173         return contractMap[DEPOSIT_MANAGER];
1174     }
1175 
1176     function getStakeManagerAddress() public view returns (address) {
1177         return contractMap[STAKE_MANAGER];
1178     }
1179 
1180     function getSlashingManagerAddress() public view returns (address) {
1181         return contractMap[SLASHING_MANAGER];
1182     }
1183 
1184     function getWithdrawManagerAddress() public view returns (address) {
1185         return contractMap[WITHDRAW_MANAGER];
1186     }
1187 
1188     function getChildChainAndStateSender() public view returns (address, address) {
1189         return (contractMap[CHILD_CHAIN], contractMap[STATE_SENDER]);
1190     }
1191 
1192     function isTokenMapped(address _token) public view returns (bool) {
1193         return rootToChildToken[_token] != address(0x0);
1194     }
1195 
1196     function isTokenMappedAndIsErc721(address _token) public view returns (bool) {
1197         require(isTokenMapped(_token), "TOKEN_NOT_MAPPED");
1198         return isERC721[_token];
1199     }
1200 
1201     function isTokenMappedAndGetPredicate(address _token) public view returns (address) {
1202         if (isTokenMappedAndIsErc721(_token)) {
1203             return erc721Predicate;
1204         }
1205         return erc20Predicate;
1206     }
1207 
1208     function isChildTokenErc721(address childToken) public view returns (bool) {
1209         address rootToken = childToRootToken[childToken];
1210         require(rootToken != address(0x0), "Child token is not mapped");
1211         return isERC721[rootToken];
1212     }
1213 }
1214 
1215 
1216 
1217 contract ChainIdMixin {
1218   bytes constant public networkId = hex"6D";
1219   uint256 constant public CHAINID = 109;
1220 }
1221 
1222 
1223 
1224 
1225 
1226 contract RootChainHeader {
1227     event NewHeaderBlock(
1228         address indexed proposer,
1229         uint256 indexed headerBlockId,
1230         uint256 indexed reward,
1231         uint256 start,
1232         uint256 end,
1233         bytes32 root
1234     );
1235     // housekeeping event
1236     event ResetHeaderBlock(address indexed proposer, uint256 indexed headerBlockId);
1237     struct HeaderBlock {
1238         bytes32 root;
1239         uint256 start;
1240         uint256 end;
1241         uint256 createdAt;
1242         address proposer;
1243     }
1244 }
1245 
1246 
1247 contract RootChainStorage is ProxyStorage, RootChainHeader, ChainIdMixin {
1248     bytes32 public heimdallId;
1249     uint8 public constant VOTE_TYPE = 2;
1250 
1251     uint16 internal constant MAX_DEPOSITS = 10000;
1252     uint256 public _nextHeaderBlock = MAX_DEPOSITS;
1253     uint256 internal _blockDepositId = 1;
1254     mapping(uint256 => HeaderBlock) public headerBlocks;
1255     Registry internal registry;
1256 }
1257 
1258 
1259 
1260 contract IStakeManager {
1261     // validator replacement
1262     function startAuction(
1263         uint256 validatorId,
1264         uint256 amount,
1265         bool acceptDelegation,
1266         bytes calldata signerPubkey
1267     ) external;
1268 
1269     function confirmAuctionBid(uint256 validatorId, uint256 heimdallFee) external;
1270 
1271     function transferFunds(
1272         uint256 validatorId,
1273         uint256 amount,
1274         address delegator
1275     ) external returns (bool);
1276 
1277     function delegationDeposit(
1278         uint256 validatorId,
1279         uint256 amount,
1280         address delegator
1281     ) external returns (bool);
1282 
1283     function unstake(uint256 validatorId) external;
1284 
1285     function totalStakedFor(address addr) external view returns (uint256);
1286 
1287     function stakeFor(
1288         address user,
1289         uint256 amount,
1290         uint256 heimdallFee,
1291         bool acceptDelegation,
1292         bytes memory signerPubkey
1293     ) public;
1294 
1295     function checkSignatures(
1296         uint256 blockInterval,
1297         bytes32 voteHash,
1298         bytes32 stateRoot,
1299         address proposer,
1300         uint[3][] calldata sigs
1301     ) external returns (uint256);
1302 
1303     function updateValidatorState(uint256 validatorId, int256 amount) public;
1304 
1305     function ownerOf(uint256 tokenId) public view returns (address);
1306 
1307     function slash(bytes calldata slashingInfoList) external returns (uint256);
1308 
1309     function validatorStake(uint256 validatorId) public view returns (uint256);
1310 
1311     function epoch() public view returns (uint256);
1312 
1313     function getRegistry() public view returns (address);
1314 
1315     function withdrawalDelay() public view returns (uint256);
1316 
1317     function delegatedAmount(uint256 validatorId) public view returns(uint256);
1318 
1319     function decreaseValidatorDelegatedAmount(uint256 validatorId, uint256 amount) public;
1320 
1321     function withdrawDelegatorsReward(uint256 validatorId) public returns(uint256);
1322 
1323     function delegatorsReward(uint256 validatorId) public view returns(uint256);
1324 
1325     function dethroneAndStake(
1326         address auctionUser,
1327         uint256 heimdallFee,
1328         uint256 validatorId,
1329         uint256 auctionAmount,
1330         bool acceptDelegation,
1331         bytes calldata signerPubkey
1332     ) external;
1333 }
1334 
1335 
1336 
1337 
1338 interface IRootChain {
1339     function slash() external;
1340 
1341     function submitHeaderBlock(bytes calldata data, bytes calldata sigs)
1342         external;
1343     
1344     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs)
1345         external;
1346 
1347     function getLastChildBlock() external view returns (uint256);
1348 
1349     function currentHeaderBlock() external view returns (uint256);
1350 }
1351 
1352 
1353 
1354 
1355 
1356 
1357 contract RootChain is RootChainStorage, IRootChain {
1358     using SafeMath for uint256;
1359     using RLPReader for bytes;
1360     using RLPReader for RLPReader.RLPItem;
1361 
1362     modifier onlyDepositManager() {
1363         require(msg.sender == registry.getDepositManagerAddress(), "UNAUTHORIZED_DEPOSIT_MANAGER_ONLY");
1364         _;
1365     }
1366 
1367     function submitHeaderBlock(bytes calldata data, bytes calldata sigs) external {
1368         revert();
1369     }
1370 
1371     function submitCheckpoint(bytes calldata data, uint[3][] calldata sigs) external {
1372         (address proposer, uint256 start, uint256 end, bytes32 rootHash, bytes32 accountHash, uint256 _borChainID) = abi
1373             .decode(data, (address, uint256, uint256, bytes32, bytes32, uint256));
1374         require(CHAINID == _borChainID, "Invalid bor chain id");
1375 
1376         require(_buildHeaderBlock(proposer, start, end, rootHash), "INCORRECT_HEADER_DATA");
1377 
1378         // check if it is better to keep it in local storage instead
1379         IStakeManager stakeManager = IStakeManager(registry.getStakeManagerAddress());
1380         uint256 _reward = stakeManager.checkSignatures(
1381             end.sub(start).add(1),
1382             /**  
1383                 prefix 01 to data 
1384                 01 represents positive vote on data and 00 is negative vote
1385                 malicious validator can try to send 2/3 on negative vote so 01 is appended
1386              */
1387             keccak256(abi.encodePacked(bytes(hex"01"), data)),
1388             accountHash,
1389             proposer,
1390             sigs
1391         );
1392 
1393         require(_reward != 0, "Invalid checkpoint");
1394         emit NewHeaderBlock(proposer, _nextHeaderBlock, _reward, start, end, rootHash);
1395         _nextHeaderBlock = _nextHeaderBlock.add(MAX_DEPOSITS);
1396         _blockDepositId = 1;
1397     }
1398 
1399     function updateDepositId(uint256 numDeposits) external onlyDepositManager returns (uint256 depositId) {
1400         depositId = currentHeaderBlock().add(_blockDepositId);
1401         // deposit ids will be (_blockDepositId, _blockDepositId + 1, .... _blockDepositId + numDeposits - 1)
1402         _blockDepositId = _blockDepositId.add(numDeposits);
1403         require(
1404             // Since _blockDepositId is initialized to 1; only (MAX_DEPOSITS - 1) deposits per header block are allowed
1405             _blockDepositId <= MAX_DEPOSITS,
1406             "TOO_MANY_DEPOSITS"
1407         );
1408     }
1409 
1410     function getLastChildBlock() external view returns (uint256) {
1411         return headerBlocks[currentHeaderBlock()].end;
1412     }
1413 
1414     function slash() external {
1415         //TODO: future implementation
1416     }
1417 
1418     function currentHeaderBlock() public view returns (uint256) {
1419         return _nextHeaderBlock.sub(MAX_DEPOSITS);
1420     }
1421 
1422     function _buildHeaderBlock(
1423         address proposer,
1424         uint256 start,
1425         uint256 end,
1426         bytes32 rootHash
1427     ) private returns (bool) {
1428         uint256 nextChildBlock;
1429         /*
1430     The ID of the 1st header block is MAX_DEPOSITS.
1431     if _nextHeaderBlock == MAX_DEPOSITS, then the first header block is yet to be submitted, hence nextChildBlock = 0
1432     */
1433         if (_nextHeaderBlock > MAX_DEPOSITS) {
1434             nextChildBlock = headerBlocks[currentHeaderBlock()].end + 1;
1435         }
1436         if (nextChildBlock != start) {
1437             return false;
1438         }
1439 
1440         HeaderBlock memory headerBlock = HeaderBlock({
1441             root: rootHash,
1442             start: nextChildBlock,
1443             end: end,
1444             createdAt: now,
1445             proposer: proposer
1446         });
1447 
1448         headerBlocks[_nextHeaderBlock] = headerBlock;
1449         return true;
1450     }
1451 
1452     // Housekeeping function. @todo remove later
1453     function setNextHeaderBlock(uint256 _value) public onlyOwner {
1454         require(_value % MAX_DEPOSITS == 0, "Invalid value");
1455         for (uint256 i = _value; i < _nextHeaderBlock; i += MAX_DEPOSITS) {
1456             delete headerBlocks[i];
1457         }
1458         _nextHeaderBlock = _value;
1459         _blockDepositId = 1;
1460         emit ResetHeaderBlock(msg.sender, _nextHeaderBlock);
1461     }
1462 
1463     // Housekeeping function. @todo remove later
1464     function setHeimdallId(string memory _heimdallId) public onlyOwner {
1465         heimdallId = keccak256(abi.encodePacked(_heimdallId));
1466     }
1467 }
1468 
1469 
1470 
1471 /**
1472  * @title IERC165
1473  * @dev https://eips.ethereum.org/EIPS/eip-165
1474  */
1475 interface IERC165 {
1476     /**
1477      * @notice Query if a contract implements an interface
1478      * @param interfaceId The interface identifier, as specified in ERC-165
1479      * @dev Interface identification is specified in ERC-165. This function
1480      * uses less than 30,000 gas.
1481      */
1482     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1483 }
1484 
1485 
1486 
1487 /**
1488  * @title ERC721 Non-Fungible Token Standard basic interface
1489  * @dev see https://eips.ethereum.org/EIPS/eip-721
1490  */
1491 contract IERC721 is IERC165 {
1492     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1493     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1494     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1495 
1496     function balanceOf(address owner) public view returns (uint256 balance);
1497     function ownerOf(uint256 tokenId) public view returns (address owner);
1498 
1499     function approve(address to, uint256 tokenId) public;
1500     function getApproved(uint256 tokenId) public view returns (address operator);
1501 
1502     function setApprovalForAll(address operator, bool _approved) public;
1503     function isApprovedForAll(address owner, address operator) public view returns (bool);
1504 
1505     function transferFrom(address from, address to, uint256 tokenId) public;
1506     function safeTransferFrom(address from, address to, uint256 tokenId) public;
1507 
1508     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
1509 }
1510 
1511 
1512 
1513 /**
1514  * @title ERC721 token receiver interface
1515  * @dev Interface for any contract that wants to support safeTransfers
1516  * from ERC721 asset contracts.
1517  */
1518 contract IERC721Receiver {
1519     /**
1520      * @notice Handle the receipt of an NFT
1521      * @dev The ERC721 smart contract calls this function on the recipient
1522      * after a `safeTransfer`. This function MUST return the function selector,
1523      * otherwise the caller will revert the transaction. The selector to be
1524      * returned can be obtained as `this.onERC721Received.selector`. This
1525      * function MAY throw to revert and reject the transfer.
1526      * Note: the ERC721 contract address is always the message sender.
1527      * @param operator The address which called `safeTransferFrom` function
1528      * @param from The address which previously owned the token
1529      * @param tokenId The NFT identifier which is being transferred
1530      * @param data Additional data with no specified format
1531      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1532      */
1533     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
1534     public returns (bytes4);
1535 }
1536 
1537 
1538 
1539 /**
1540  * Utility library of inline functions on addresses
1541  */
1542 library Address {
1543     /**
1544      * Returns whether the target address is a contract
1545      * @dev This function will return false if invoked during the constructor of a contract,
1546      * as the code is not actually created until after the constructor finishes.
1547      * @param account address of the account to check
1548      * @return whether the target address is a contract
1549      */
1550     function isContract(address account) internal view returns (bool) {
1551         uint256 size;
1552         // XXX Currently there is no better way to check if there is a contract in an address
1553         // than to check the size of the code at that address.
1554         // See https://ethereum.stackexchange.com/a/14016/36603
1555         // for more details about how this works.
1556         // TODO Check this again before the Serenity release, because all addresses will be
1557         // contracts then.
1558         // solhint-disable-next-line no-inline-assembly
1559         assembly { size := extcodesize(account) }
1560         return size > 0;
1561     }
1562 }
1563 
1564 
1565 
1566 /**
1567  * @title Counters
1568  * @author Matt Condon (@shrugs)
1569  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1570  * of elements in a mapping, issuing ERC721 ids, or counting request ids
1571  *
1572  * Include with `using Counters for Counters.Counter;`
1573  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
1574  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1575  * directly accessed.
1576  */
1577 library Counters {
1578     using SafeMath for uint256;
1579 
1580     struct Counter {
1581         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1582         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1583         // this feature: see https://github.com/ethereum/solidity/issues/4637
1584         uint256 _value; // default: 0
1585     }
1586 
1587     function current(Counter storage counter) internal view returns (uint256) {
1588         return counter._value;
1589     }
1590 
1591     function increment(Counter storage counter) internal {
1592         counter._value += 1;
1593     }
1594 
1595     function decrement(Counter storage counter) internal {
1596         counter._value = counter._value.sub(1);
1597     }
1598 }
1599 
1600 
1601 
1602 /**
1603  * @title ERC165
1604  * @author Matt Condon (@shrugs)
1605  * @dev Implements ERC165 using a lookup table.
1606  */
1607 contract ERC165 is IERC165 {
1608     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1609     /*
1610      * 0x01ffc9a7 ===
1611      *     bytes4(keccak256('supportsInterface(bytes4)'))
1612      */
1613 
1614     /**
1615      * @dev a mapping of interface id to whether or not it's supported
1616      */
1617     mapping(bytes4 => bool) private _supportedInterfaces;
1618 
1619     /**
1620      * @dev A contract implementing SupportsInterfaceWithLookup
1621      * implement ERC165 itself
1622      */
1623     constructor () internal {
1624         _registerInterface(_INTERFACE_ID_ERC165);
1625     }
1626 
1627     /**
1628      * @dev implement supportsInterface(bytes4) using a lookup table
1629      */
1630     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1631         return _supportedInterfaces[interfaceId];
1632     }
1633 
1634     /**
1635      * @dev internal method for registering an interface
1636      */
1637     function _registerInterface(bytes4 interfaceId) internal {
1638         require(interfaceId != 0xffffffff);
1639         _supportedInterfaces[interfaceId] = true;
1640     }
1641 }
1642 
1643 
1644 
1645 
1646 
1647 
1648 
1649 
1650 /**
1651  * @title ERC721 Non-Fungible Token Standard basic implementation
1652  * @dev see https://eips.ethereum.org/EIPS/eip-721
1653  */
1654 contract ERC721 is ERC165, IERC721 {
1655     using SafeMath for uint256;
1656     using Address for address;
1657     using Counters for Counters.Counter;
1658 
1659     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1660     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1661     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1662 
1663     // Mapping from token ID to owner
1664     mapping (uint256 => address) private _tokenOwner;
1665 
1666     // Mapping from token ID to approved address
1667     mapping (uint256 => address) private _tokenApprovals;
1668 
1669     // Mapping from owner to number of owned token
1670     mapping (address => Counters.Counter) private _ownedTokensCount;
1671 
1672     // Mapping from owner to operator approvals
1673     mapping (address => mapping (address => bool)) private _operatorApprovals;
1674 
1675     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1676     /*
1677      * 0x80ac58cd ===
1678      *     bytes4(keccak256('balanceOf(address)')) ^
1679      *     bytes4(keccak256('ownerOf(uint256)')) ^
1680      *     bytes4(keccak256('approve(address,uint256)')) ^
1681      *     bytes4(keccak256('getApproved(uint256)')) ^
1682      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1683      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1684      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1685      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1686      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1687      */
1688 
1689     constructor () public {
1690         // register the supported interfaces to conform to ERC721 via ERC165
1691         _registerInterface(_INTERFACE_ID_ERC721);
1692     }
1693 
1694     /**
1695      * @dev Gets the balance of the specified address
1696      * @param owner address to query the balance of
1697      * @return uint256 representing the amount owned by the passed address
1698      */
1699     function balanceOf(address owner) public view returns (uint256) {
1700         require(owner != address(0));
1701         return _ownedTokensCount[owner].current();
1702     }
1703 
1704     /**
1705      * @dev Gets the owner of the specified token ID
1706      * @param tokenId uint256 ID of the token to query the owner of
1707      * @return address currently marked as the owner of the given token ID
1708      */
1709     function ownerOf(uint256 tokenId) public view returns (address) {
1710         address owner = _tokenOwner[tokenId];
1711         require(owner != address(0));
1712         return owner;
1713     }
1714 
1715     /**
1716      * @dev Approves another address to transfer the given token ID
1717      * The zero address indicates there is no approved address.
1718      * There can only be one approved address per token at a given time.
1719      * Can only be called by the token owner or an approved operator.
1720      * @param to address to be approved for the given token ID
1721      * @param tokenId uint256 ID of the token to be approved
1722      */
1723     function approve(address to, uint256 tokenId) public {
1724         address owner = ownerOf(tokenId);
1725         require(to != owner);
1726         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1727 
1728         _tokenApprovals[tokenId] = to;
1729         emit Approval(owner, to, tokenId);
1730     }
1731 
1732     /**
1733      * @dev Gets the approved address for a token ID, or zero if no address set
1734      * Reverts if the token ID does not exist.
1735      * @param tokenId uint256 ID of the token to query the approval of
1736      * @return address currently approved for the given token ID
1737      */
1738     function getApproved(uint256 tokenId) public view returns (address) {
1739         require(_exists(tokenId));
1740         return _tokenApprovals[tokenId];
1741     }
1742 
1743     /**
1744      * @dev Sets or unsets the approval of a given operator
1745      * An operator is allowed to transfer all tokens of the sender on their behalf
1746      * @param to operator address to set the approval
1747      * @param approved representing the status of the approval to be set
1748      */
1749     function setApprovalForAll(address to, bool approved) public {
1750         require(to != msg.sender);
1751         _operatorApprovals[msg.sender][to] = approved;
1752         emit ApprovalForAll(msg.sender, to, approved);
1753     }
1754 
1755     /**
1756      * @dev Tells whether an operator is approved by a given owner
1757      * @param owner owner address which you want to query the approval of
1758      * @param operator operator address which you want to query the approval of
1759      * @return bool whether the given operator is approved by the given owner
1760      */
1761     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1762         return _operatorApprovals[owner][operator];
1763     }
1764 
1765     /**
1766      * @dev Transfers the ownership of a given token ID to another address
1767      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1768      * Requires the msg.sender to be the owner, approved, or operator
1769      * @param from current owner of the token
1770      * @param to address to receive the ownership of the given token ID
1771      * @param tokenId uint256 ID of the token to be transferred
1772      */
1773     function transferFrom(address from, address to, uint256 tokenId) public {
1774         require(_isApprovedOrOwner(msg.sender, tokenId));
1775 
1776         _transferFrom(from, to, tokenId);
1777     }
1778 
1779     /**
1780      * @dev Safely transfers the ownership of a given token ID to another address
1781      * If the target address is a contract, it must implement `onERC721Received`,
1782      * which is called upon a safe transfer, and return the magic value
1783      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1784      * the transfer is reverted.
1785      * Requires the msg.sender to be the owner, approved, or operator
1786      * @param from current owner of the token
1787      * @param to address to receive the ownership of the given token ID
1788      * @param tokenId uint256 ID of the token to be transferred
1789      */
1790     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1791         safeTransferFrom(from, to, tokenId, "");
1792     }
1793 
1794     /**
1795      * @dev Safely transfers the ownership of a given token ID to another address
1796      * If the target address is a contract, it must implement `onERC721Received`,
1797      * which is called upon a safe transfer, and return the magic value
1798      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1799      * the transfer is reverted.
1800      * Requires the msg.sender to be the owner, approved, or operator
1801      * @param from current owner of the token
1802      * @param to address to receive the ownership of the given token ID
1803      * @param tokenId uint256 ID of the token to be transferred
1804      * @param _data bytes data to send along with a safe transfer check
1805      */
1806     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1807         transferFrom(from, to, tokenId);
1808         require(_checkOnERC721Received(from, to, tokenId, _data));
1809     }
1810 
1811     /**
1812      * @dev Returns whether the specified token exists
1813      * @param tokenId uint256 ID of the token to query the existence of
1814      * @return bool whether the token exists
1815      */
1816     function _exists(uint256 tokenId) internal view returns (bool) {
1817         address owner = _tokenOwner[tokenId];
1818         return owner != address(0);
1819     }
1820 
1821     /**
1822      * @dev Returns whether the given spender can transfer a given token ID
1823      * @param spender address of the spender to query
1824      * @param tokenId uint256 ID of the token to be transferred
1825      * @return bool whether the msg.sender is approved for the given token ID,
1826      * is an operator of the owner, or is the owner of the token
1827      */
1828     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1829         address owner = ownerOf(tokenId);
1830         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1831     }
1832 
1833     /**
1834      * @dev Internal function to mint a new token
1835      * Reverts if the given token ID already exists
1836      * @param to The address that will own the minted token
1837      * @param tokenId uint256 ID of the token to be minted
1838      */
1839     function _mint(address to, uint256 tokenId) internal {
1840         require(to != address(0));
1841         require(!_exists(tokenId));
1842 
1843         _tokenOwner[tokenId] = to;
1844         _ownedTokensCount[to].increment();
1845 
1846         emit Transfer(address(0), to, tokenId);
1847     }
1848 
1849     /**
1850      * @dev Internal function to burn a specific token
1851      * Reverts if the token does not exist
1852      * Deprecated, use _burn(uint256) instead.
1853      * @param owner owner of the token to burn
1854      * @param tokenId uint256 ID of the token being burned
1855      */
1856     function _burn(address owner, uint256 tokenId) internal {
1857         require(ownerOf(tokenId) == owner);
1858 
1859         _clearApproval(tokenId);
1860 
1861         _ownedTokensCount[owner].decrement();
1862         _tokenOwner[tokenId] = address(0);
1863 
1864         emit Transfer(owner, address(0), tokenId);
1865     }
1866 
1867     /**
1868      * @dev Internal function to burn a specific token
1869      * Reverts if the token does not exist
1870      * @param tokenId uint256 ID of the token being burned
1871      */
1872     function _burn(uint256 tokenId) internal {
1873         _burn(ownerOf(tokenId), tokenId);
1874     }
1875 
1876     /**
1877      * @dev Internal function to transfer ownership of a given token ID to another address.
1878      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1879      * @param from current owner of the token
1880      * @param to address to receive the ownership of the given token ID
1881      * @param tokenId uint256 ID of the token to be transferred
1882      */
1883     function _transferFrom(address from, address to, uint256 tokenId) internal {
1884         require(ownerOf(tokenId) == from);
1885         require(to != address(0));
1886 
1887         _clearApproval(tokenId);
1888 
1889         _ownedTokensCount[from].decrement();
1890         _ownedTokensCount[to].increment();
1891 
1892         _tokenOwner[tokenId] = to;
1893 
1894         emit Transfer(from, to, tokenId);
1895     }
1896 
1897     /**
1898      * @dev Internal function to invoke `onERC721Received` on a target address
1899      * The call is not executed if the target address is not a contract
1900      * @param from address representing the previous owner of the given token ID
1901      * @param to target address that will receive the tokens
1902      * @param tokenId uint256 ID of the token to be transferred
1903      * @param _data bytes optional data to send along with the call
1904      * @return bool whether the call correctly returned the expected magic value
1905      */
1906     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1907         internal returns (bool)
1908     {
1909         if (!to.isContract()) {
1910             return true;
1911         }
1912 
1913         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1914         return (retval == _ERC721_RECEIVED);
1915     }
1916 
1917     /**
1918      * @dev Private function to clear current approval of a given token ID
1919      * @param tokenId uint256 ID of the token to be transferred
1920      */
1921     function _clearApproval(uint256 tokenId) private {
1922         if (_tokenApprovals[tokenId] != address(0)) {
1923             _tokenApprovals[tokenId] = address(0);
1924         }
1925     }
1926 }
1927 
1928 
1929 
1930 
1931 contract ExitNFT is ERC721 {
1932     Registry internal registry;
1933 
1934     modifier onlyWithdrawManager() {
1935         require(
1936             msg.sender == registry.getWithdrawManagerAddress(),
1937             "UNAUTHORIZED_WITHDRAW_MANAGER_ONLY"
1938         );
1939         _;
1940     }
1941 
1942     constructor(address _registry) public {
1943         registry = Registry(_registry);
1944     }
1945 
1946     function mint(address _owner, uint256 _tokenId)
1947         external
1948         onlyWithdrawManager
1949     {
1950         _mint(_owner, _tokenId);
1951     }
1952 
1953     function burn(uint256 _tokenId) external onlyWithdrawManager {
1954         _burn(_tokenId);
1955     }
1956 
1957     function exists(uint256 tokenId) public view returns (bool) {
1958         return _exists(tokenId);
1959     }
1960 }
1961 
1962 
1963 
1964 
1965 
1966 
1967 contract ExitsDataStructure {
1968     struct Input {
1969         address utxoOwner;
1970         address predicate;
1971         address token;
1972     }
1973 
1974     struct PlasmaExit {
1975         uint256 receiptAmountOrNFTId;
1976         bytes32 txHash;
1977         address owner;
1978         address token;
1979         bool isRegularExit;
1980         address predicate;
1981         // Mapping from age of input to Input
1982         mapping(uint256 => Input) inputs;
1983     }
1984 }
1985 
1986 
1987 contract WithdrawManagerHeader is ExitsDataStructure {
1988     event Withdraw(uint256 indexed exitId, address indexed user, address indexed token, uint256 amount);
1989 
1990     event ExitStarted(
1991         address indexed exitor,
1992         uint256 indexed exitId,
1993         address indexed token,
1994         uint256 amount,
1995         bool isRegularExit
1996     );
1997 
1998     event ExitUpdated(uint256 indexed exitId, uint256 indexed age, address signer);
1999     event ExitPeriodUpdate(uint256 indexed oldExitPeriod, uint256 indexed newExitPeriod);
2000 
2001     event ExitCancelled(uint256 indexed exitId);
2002 }
2003 
2004 
2005 contract WithdrawManagerStorage is ProxyStorage, WithdrawManagerHeader {
2006     // 0.5 week = 7 * 86400 / 2 = 302400
2007     uint256 public HALF_EXIT_PERIOD = 302400;
2008 
2009     // Bonded exits collaterized at 0.1 ETH
2010     uint256 internal constant BOND_AMOUNT = 10**17;
2011 
2012     Registry internal registry;
2013     RootChain internal rootChain;
2014 
2015     mapping(uint128 => bool) isKnownExit;
2016     mapping(uint256 => PlasmaExit) public exits;
2017     // mapping with token => (owner => exitId) keccak(token+owner) keccak(token+owner+tokenId)
2018     mapping(bytes32 => uint256) public ownerExits;
2019     mapping(address => address) public exitsQueues;
2020     ExitNFT public exitNft;
2021 
2022     // ERC721, ERC20 and Weth transfers require 155000, 100000, 52000 gas respectively
2023     // Processing each exit in a while loop iteration requires ~52000 gas (@todo check if this changed)
2024     // uint32 constant internal ITERATION_GAS = 52000;
2025 
2026     // So putting an upper limit of 155000 + 52000 + leeway
2027     uint32 public ON_FINALIZE_GAS_LIMIT = 300000;
2028 
2029     uint256 public exitWindow;
2030 }
2031 
2032 
2033 
2034 
2035 
2036 
2037 
2038 interface IPredicate {
2039     /**
2040    * @notice Verify the deprecation of a state update
2041    * @param exit ABI encoded PlasmaExit data
2042    * @param inputUtxo ABI encoded Input UTXO data
2043    * @param challengeData RLP encoded data of the challenge reference tx that encodes the following fields
2044    * headerNumber Header block number of which the reference tx was a part of
2045    * blockProof Proof that the block header (in the child chain) is a leaf in the submitted merkle root
2046    * blockNumber Block number of which the reference tx is a part of
2047    * blockTime Reference tx block time
2048    * blocktxRoot Transactions root of block
2049    * blockReceiptsRoot Receipts root of block
2050    * receipt Receipt of the reference transaction
2051    * receiptProof Merkle proof of the reference receipt
2052    * branchMask Merkle proof branchMask for the receipt
2053    * logIndex Log Index to read from the receipt
2054    * tx Challenge transaction
2055    * txProof Merkle proof of the challenge tx
2056    * @return Whether or not the state is deprecated
2057    */
2058     function verifyDeprecation(
2059         bytes calldata exit,
2060         bytes calldata inputUtxo,
2061         bytes calldata challengeData
2062     ) external returns (bool);
2063 
2064     function interpretStateUpdate(bytes calldata state)
2065         external
2066         view
2067         returns (bytes memory);
2068     function onFinalizeExit(bytes calldata data) external;
2069 }
2070 
2071 contract PredicateUtils is ExitsDataStructure, ChainIdMixin {
2072     using RLPReader for RLPReader.RLPItem;
2073 
2074     // Bonded exits collaterized at 0.1 ETH
2075     uint256 private constant BOND_AMOUNT = 10**17;
2076 
2077     IWithdrawManager internal withdrawManager;
2078     IDepositManager internal depositManager;
2079 
2080     modifier onlyWithdrawManager() {
2081         require(
2082             msg.sender == address(withdrawManager),
2083             "ONLY_WITHDRAW_MANAGER"
2084         );
2085         _;
2086     }
2087 
2088     modifier isBondProvided() {
2089         require(msg.value == BOND_AMOUNT, "Invalid Bond amount");
2090         _;
2091     }
2092 
2093     function onFinalizeExit(bytes calldata data) external onlyWithdrawManager {
2094         (, address token, address exitor, uint256 tokenId) = decodeExitForProcessExit(
2095             data
2096         );
2097         depositManager.transferAssets(token, exitor, tokenId);
2098     }
2099 
2100     function sendBond() internal {
2101         address(uint160(address(withdrawManager))).transfer(BOND_AMOUNT);
2102     }
2103 
2104     function getAddressFromTx(RLPReader.RLPItem[] memory txList)
2105         internal
2106         pure
2107         returns (address signer, bytes32 txHash)
2108     {
2109         bytes[] memory rawTx = new bytes[](9);
2110         for (uint8 i = 0; i <= 5; i++) {
2111             rawTx[i] = txList[i].toBytes();
2112         }
2113         rawTx[6] = networkId;
2114         rawTx[7] = hex""; // [7] and [8] have something to do with v, r, s values
2115         rawTx[8] = hex"";
2116 
2117         txHash = keccak256(RLPEncode.encodeList(rawTx));
2118         signer = ecrecover(
2119             txHash,
2120             Common.getV(txList[6].toBytes(), Common.toUint16(networkId)),
2121             bytes32(txList[7].toUint()),
2122             bytes32(txList[8].toUint())
2123         );
2124     }
2125 
2126     function decodeExit(bytes memory data)
2127         internal
2128         pure
2129         returns (PlasmaExit memory)
2130     {
2131         (address owner, address token, uint256 amountOrTokenId, bytes32 txHash, bool isRegularExit) = abi
2132             .decode(data, (address, address, uint256, bytes32, bool));
2133         return
2134             PlasmaExit(
2135                 amountOrTokenId,
2136                 txHash,
2137                 owner,
2138                 token,
2139                 isRegularExit,
2140                 address(0) /* predicate value is not required */
2141             );
2142     }
2143 
2144     function decodeExitForProcessExit(bytes memory data)
2145         internal
2146         pure
2147         returns (uint256 exitId, address token, address exitor, uint256 tokenId)
2148     {
2149         (exitId, token, exitor, tokenId) = abi.decode(
2150             data,
2151             (uint256, address, address, uint256)
2152         );
2153     }
2154 
2155     function decodeInputUtxo(bytes memory data)
2156         internal
2157         pure
2158         returns (uint256 age, address signer, address predicate, address token)
2159     {
2160         (age, signer, predicate, token) = abi.decode(
2161             data,
2162             (uint256, address, address, address)
2163         );
2164     }
2165 
2166 }
2167 
2168 contract IErcPredicate is IPredicate, PredicateUtils {
2169     enum ExitType {Invalid, OutgoingTransfer, IncomingTransfer, Burnt}
2170 
2171     struct ExitTxData {
2172         uint256 amountOrToken;
2173         bytes32 txHash;
2174         address childToken;
2175         address signer;
2176         ExitType exitType;
2177     }
2178 
2179     struct ReferenceTxData {
2180         uint256 closingBalance;
2181         uint256 age;
2182         address childToken;
2183         address rootToken;
2184     }
2185 
2186     uint256 internal constant MAX_LOGS = 10;
2187 
2188     constructor(address _withdrawManager, address _depositManager) public {
2189         withdrawManager = IWithdrawManager(_withdrawManager);
2190         depositManager = IDepositManager(_depositManager);
2191     }
2192 }
2193 
2194 
2195 
2196 
2197 
2198 
2199 
2200 
2201 
2202 
2203 
2204 
2205 contract ERC20PredicateBurnOnly is IErcPredicate {
2206     using RLPReader for bytes;
2207     using RLPReader for RLPReader.RLPItem;
2208     using SafeMath for uint256;
2209 
2210     using ExitPayloadReader for bytes;
2211     using ExitPayloadReader for ExitPayloadReader.ExitPayload;
2212     using ExitPayloadReader for ExitPayloadReader.Receipt;
2213     using ExitPayloadReader for ExitPayloadReader.Log;
2214     using ExitPayloadReader for ExitPayloadReader.LogTopics;
2215 
2216     // keccak256('Withdraw(address,address,uint256,uint256,uint256)')
2217     bytes32 constant WITHDRAW_EVENT_SIG = 0xebff2602b3f468259e1e99f613fed6691f3a6526effe6ef3e768ba7ae7a36c4f;
2218 
2219     constructor(
2220         address _withdrawManager,
2221         address _depositManager
2222     ) public IErcPredicate(_withdrawManager, _depositManager) {
2223     }
2224 
2225     function startExitWithBurntTokens(bytes calldata data) external {
2226         ExitPayloadReader.ExitPayload memory payload = data.toExitPayload();
2227         ExitPayloadReader.Receipt memory receipt = payload.getReceipt();
2228         uint256 logIndex = payload.getReceiptLogIndex();
2229         require(logIndex < MAX_LOGS, "Supporting a max of 10 logs");
2230         uint256 age = withdrawManager.verifyInclusion(
2231             data,
2232             0, /* offset */
2233             false /* verifyTxInclusion */
2234         );
2235         ExitPayloadReader.Log memory log = receipt.getLog();
2236 
2237         // "address" (contract address that emitted the log) field in the receipt
2238         address childToken = log.getEmitter();
2239         ExitPayloadReader.LogTopics memory topics = log.getTopics();
2240         // now, inputItems[i] refers to i-th (0-based) topic in the topics array
2241         // event Withdraw(address indexed token, address indexed from, uint256 amountOrTokenId, uint256 input1, uint256 output1)
2242         require(
2243             bytes32(topics.getField(0).toUint()) == WITHDRAW_EVENT_SIG,
2244             "Not a withdraw event signature"
2245         );
2246         require(
2247             msg.sender == address(topics.getField(2).toUint()), // from
2248             "Withdrawer and burn exit tx do not match"
2249         );
2250         address rootToken = address(topics.getField(1).toUint());
2251         uint256 exitAmount = BytesLib.toUint(log.getData(), 0); // amountOrTokenId
2252         withdrawManager.addExitToQueue(
2253             msg.sender,
2254             childToken,
2255             rootToken,
2256             exitAmount,
2257             bytes32(0x0),
2258             true, /* isRegularExit */
2259             age << 1
2260         );
2261     }
2262 
2263     function verifyDeprecation(
2264         bytes calldata exit,
2265         bytes calldata inputUtxo,
2266         bytes calldata challengeData
2267     ) external returns (bool) {}
2268 
2269     function interpretStateUpdate(bytes calldata state)
2270         external
2271         view
2272         returns (bytes memory) {}
2273 }