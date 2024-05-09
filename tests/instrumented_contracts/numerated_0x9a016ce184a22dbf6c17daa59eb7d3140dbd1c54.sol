1 // File: contracts/libs/common/ZeroCopySource.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.12;
6 
7 /**
8  * @dev Wrappers over decoding and deserialization operation from bytes into bassic types in Solidity for PolyNetwork cross chain utility.
9  *
10  * Decode into basic types in Solidity from bytes easily. It's designed to be used
11  * for PolyNetwork cross chain application, and the decoding rules on Ethereum chain
12  * and the encoding rule on other chains should be consistent, and . Here we
13  * follow the underlying deserialization rule with implementation found here:
14  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_source.go
15  *
16  * Using this library instead of the unchecked serialization method can help reduce
17  * the risk of serious bugs and handfule, so it's recommended to use it.
18  *
19  * Please note that risk can be minimized, yet not eliminated.
20  */
21 library ZeroCopySource {
22     /* @notice              Read next byte as boolean type starting at offset from buff
23     *  @param buff          Source bytes array
24     *  @param offset        The position from where we read the boolean value
25     *  @return              The the read boolean value and new offset
26     */
27     function NextBool(bytes memory buff, uint256 offset) internal pure returns(bool, uint256) {
28         require(offset + 1 <= buff.length && offset < offset + 1, "Offset exceeds limit");
29         // byte === bytes1
30         byte v;
31         assembly{
32             v := mload(add(add(buff, 0x20), offset))
33         }
34         bool value;
35         if (v == 0x01) {
36 		    value = true;
37     	} else if (v == 0x00) {
38             value = false;
39         } else {
40             revert("NextBool value error");
41         }
42         return (value, offset + 1);
43     }
44 
45     /* @notice              Read next byte starting at offset from buff
46     *  @param buff          Source bytes array
47     *  @param offset        The position from where we read the byte value
48     *  @return              The read byte value and new offset
49     */
50     function NextByte(bytes memory buff, uint256 offset) internal pure returns (byte, uint256) {
51         require(offset + 1 <= buff.length && offset < offset + 1, "NextByte, Offset exceeds maximum");
52         byte v;
53         assembly{
54             v := mload(add(add(buff, 0x20), offset))
55         }
56         return (v, offset + 1);
57     }
58 
59     /* @notice              Read next byte as uint8 starting at offset from buff
60     *  @param buff          Source bytes array
61     *  @param offset        The position from where we read the byte value
62     *  @return              The read uint8 value and new offset
63     */
64     function NextUint8(bytes memory buff, uint256 offset) internal pure returns (uint8, uint256) {
65         require(offset + 1 <= buff.length && offset < offset + 1, "NextUint8, Offset exceeds maximum");
66         uint8 v;
67         assembly{
68             let tmpbytes := mload(0x40)
69             let bvalue := mload(add(add(buff, 0x20), offset))
70             mstore8(tmpbytes, byte(0, bvalue))
71             mstore(0x40, add(tmpbytes, 0x01))
72             v := mload(sub(tmpbytes, 0x1f))
73         }
74         return (v, offset + 1);
75     }
76 
77     /* @notice              Read next two bytes as uint16 type starting from offset
78     *  @param buff          Source bytes array
79     *  @param offset        The position from where we read the uint16 value
80     *  @return              The read uint16 value and updated offset
81     */
82     function NextUint16(bytes memory buff, uint256 offset) internal pure returns (uint16, uint256) {
83         require(offset + 2 <= buff.length && offset < offset + 2, "NextUint16, offset exceeds maximum");
84 
85         uint16 v;
86         assembly {
87             let tmpbytes := mload(0x40)
88             let bvalue := mload(add(add(buff, 0x20), offset))
89             mstore8(tmpbytes, byte(0x01, bvalue))
90             mstore8(add(tmpbytes, 0x01), byte(0, bvalue))
91             mstore(0x40, add(tmpbytes, 0x02))
92             v := mload(sub(tmpbytes, 0x1e))
93         }
94         return (v, offset + 2);
95     }
96 
97 
98     /* @notice              Read next four bytes as uint32 type starting from offset
99     *  @param buff          Source bytes array
100     *  @param offset        The position from where we read the uint32 value
101     *  @return              The read uint32 value and updated offset
102     */
103     function NextUint32(bytes memory buff, uint256 offset) internal pure returns (uint32, uint256) {
104         require(offset + 4 <= buff.length && offset < offset + 4, "NextUint32, offset exceeds maximum");
105         uint32 v;
106         assembly {
107             let tmpbytes := mload(0x40)
108             let byteLen := 0x04
109             for {
110                 let tindex := 0x00
111                 let bindex := sub(byteLen, 0x01)
112                 let bvalue := mload(add(add(buff, 0x20), offset))
113             } lt(tindex, byteLen) {
114                 tindex := add(tindex, 0x01)
115                 bindex := sub(bindex, 0x01)
116             }{
117                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
118             }
119             mstore(0x40, add(tmpbytes, byteLen))
120             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
121         }
122         return (v, offset + 4);
123     }
124 
125     /* @notice              Read next eight bytes as uint64 type starting from offset
126     *  @param buff          Source bytes array
127     *  @param offset        The position from where we read the uint64 value
128     *  @return              The read uint64 value and updated offset
129     */
130     function NextUint64(bytes memory buff, uint256 offset) internal pure returns (uint64, uint256) {
131         require(offset + 8 <= buff.length && offset < offset + 8, "NextUint64, offset exceeds maximum");
132         uint64 v;
133         assembly {
134             let tmpbytes := mload(0x40)
135             let byteLen := 0x08
136             for {
137                 let tindex := 0x00
138                 let bindex := sub(byteLen, 0x01)
139                 let bvalue := mload(add(add(buff, 0x20), offset))
140             } lt(tindex, byteLen) {
141                 tindex := add(tindex, 0x01)
142                 bindex := sub(bindex, 0x01)
143             }{
144                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
145             }
146             mstore(0x40, add(tmpbytes, byteLen))
147             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
148         }
149         return (v, offset + 8);
150     }
151 
152     /* @notice              Read next 32 bytes as uint256 type starting from offset,
153                             there are limits considering the numerical limits in multi-chain
154     *  @param buff          Source bytes array
155     *  @param offset        The position from where we read the uint256 value
156     *  @return              The read uint256 value and updated offset
157     */
158     function NextUint255(bytes memory buff, uint256 offset) internal pure returns (uint256, uint256) {
159         require(offset + 32 <= buff.length && offset < offset + 32, "NextUint255, offset exceeds maximum");
160         uint256 v;
161         assembly {
162             let tmpbytes := mload(0x40)
163             let byteLen := 0x20
164             for {
165                 let tindex := 0x00
166                 let bindex := sub(byteLen, 0x01)
167                 let bvalue := mload(add(add(buff, 0x20), offset))
168             } lt(tindex, byteLen) {
169                 tindex := add(tindex, 0x01)
170                 bindex := sub(bindex, 0x01)
171             }{
172                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
173             }
174             mstore(0x40, add(tmpbytes, byteLen))
175             v := mload(tmpbytes)
176         }
177         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
178         return (v, offset + 32);
179     }
180     /* @notice              Read next variable bytes starting from offset,
181                             the decoding rule coming from multi-chain
182     *  @param buff          Source bytes array
183     *  @param offset        The position from where we read the bytes value
184     *  @return              The read variable bytes array value and updated offset
185     */
186     function NextVarBytes(bytes memory buff, uint256 offset) internal pure returns(bytes memory, uint256) {
187         uint len;
188         (len, offset) = NextVarUint(buff, offset);
189         require(offset + len <= buff.length && offset < offset + len, "NextVarBytes, offset exceeds maximum");
190         bytes memory tempBytes;
191         assembly{
192             switch iszero(len)
193             case 0 {
194                 // Get a location of some free memory and store it in tempBytes as
195                 // Solidity does for memory variables.
196                 tempBytes := mload(0x40)
197 
198                 // The first word of the slice result is potentially a partial
199                 // word read from the original array. To read it, we calculate
200                 // the length of that partial word and start copying that many
201                 // bytes into the array. The first word we copy will start with
202                 // data we don't care about, but the last `lengthmod` bytes will
203                 // land at the beginning of the contents of the new array. When
204                 // we're done copying, we overwrite the full first word with
205                 // the actual length of the slice.
206                 let lengthmod := and(len, 31)
207 
208                 // The multiplication in the next line is necessary
209                 // because when slicing multiples of 32 bytes (lengthmod == 0)
210                 // the following copy loop was copying the origin's length
211                 // and then ending prematurely not copying everything it should.
212                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
213                 let end := add(mc, len)
214 
215                 for {
216                     // The multiplication in the next line has the same exact purpose
217                     // as the one above.
218                     let cc := add(add(add(buff, lengthmod), mul(0x20, iszero(lengthmod))), offset)
219                 } lt(mc, end) {
220                     mc := add(mc, 0x20)
221                     cc := add(cc, 0x20)
222                 } {
223                     mstore(mc, mload(cc))
224                 }
225 
226                 mstore(tempBytes, len)
227 
228                 //update free-memory pointer
229                 //allocating the array padded to 32 bytes like the compiler does now
230                 mstore(0x40, and(add(mc, 31), not(31)))
231             }
232             //if we want a zero-length slice let's just return a zero-length array
233             default {
234                 tempBytes := mload(0x40)
235 
236                 mstore(0x40, add(tempBytes, 0x20))
237             }
238         }
239 
240         return (tempBytes, offset + len);
241     }
242     /* @notice              Read next 32 bytes starting from offset,
243     *  @param buff          Source bytes array
244     *  @param offset        The position from where we read the bytes value
245     *  @return              The read bytes32 value and updated offset
246     */
247     function NextHash(bytes memory buff, uint256 offset) internal pure returns (bytes32 , uint256) {
248         require(offset + 32 <= buff.length && offset < offset + 32, "NextHash, offset exceeds maximum");
249         bytes32 v;
250         assembly {
251             v := mload(add(buff, add(offset, 0x20)))
252         }
253         return (v, offset + 32);
254     }
255 
256     /* @notice              Read next 20 bytes starting from offset,
257     *  @param buff          Source bytes array
258     *  @param offset        The position from where we read the bytes value
259     *  @return              The read bytes20 value and updated offset
260     */
261     function NextBytes20(bytes memory buff, uint256 offset) internal pure returns (bytes20 , uint256) {
262         require(offset + 20 <= buff.length && offset < offset + 20, "NextBytes20, offset exceeds maximum");
263         bytes20 v;
264         assembly {
265             v := mload(add(buff, add(offset, 0x20)))
266         }
267         return (v, offset + 20);
268     }
269 
270     function NextVarUint(bytes memory buff, uint256 offset) internal pure returns(uint, uint256) {
271         byte v;
272         (v, offset) = NextByte(buff, offset);
273 
274         uint value;
275         if (v == 0xFD) {
276             // return NextUint16(buff, offset);
277             (value, offset) = NextUint16(buff, offset);
278             require(value >= 0xFD && value <= 0xFFFF, "NextUint16, value outside range");
279             return (value, offset);
280         } else if (v == 0xFE) {
281             // return NextUint32(buff, offset);
282             (value, offset) = NextUint32(buff, offset);
283             require(value > 0xFFFF && value <= 0xFFFFFFFF, "NextVarUint, value outside range");
284             return (value, offset);
285         } else if (v == 0xFF) {
286             // return NextUint64(buff, offset);
287             (value, offset) = NextUint64(buff, offset);
288             require(value > 0xFFFFFFFF, "NextVarUint, value outside range");
289             return (value, offset);
290         } else{
291             // return (uint8(v), offset);
292             value = uint8(v);
293             require(value < 0xFD, "NextVarUint, value outside range");
294             return (value, offset);
295         }
296     }
297 }
298 
299 // File: contracts/libs/common/ZeroCopySink.sol
300 
301 
302 pragma solidity 0.6.12;
303 
304 /**
305  * @dev Wrappers over encoding and serialization operation into bytes from bassic types in Solidity for PolyNetwork cross chain utility.
306  *
307  * Encode basic types in Solidity into bytes easily. It's designed to be used
308  * for PolyNetwork cross chain application, and the encoding rules on Ethereum chain
309  * and the decoding rules on other chains should be consistent. Here we
310  * follow the underlying serialization rule with implementation found here:
311  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_sink.go
312  *
313  * Using this library instead of the unchecked serialization method can help reduce
314  * the risk of serious bugs and handfule, so it's recommended to use it.
315  *
316  * Please note that risk can be minimized, yet not eliminated.
317  */
318 library ZeroCopySink {
319     /* @notice          Convert boolean value into bytes
320     *  @param b         The boolean value
321     *  @return          Converted bytes array
322     */
323     function WriteBool(bool b) internal pure returns (bytes memory) {
324         bytes memory buff;
325         assembly{
326             buff := mload(0x40)
327             mstore(buff, 1)
328             switch iszero(b)
329             case 1 {
330                 mstore(add(buff, 0x20), shl(248, 0x00))
331                 // mstore8(add(buff, 0x20), 0x00)
332             }
333             default {
334                 mstore(add(buff, 0x20), shl(248, 0x01))
335                 // mstore8(add(buff, 0x20), 0x01)
336             }
337             mstore(0x40, add(buff, 0x21))
338         }
339         return buff;
340     }
341 
342     /* @notice          Convert byte value into bytes
343     *  @param b         The byte value
344     *  @return          Converted bytes array
345     */
346     function WriteByte(byte b) internal pure returns (bytes memory) {
347         return WriteUint8(uint8(b));
348     }
349 
350     /* @notice          Convert uint8 value into bytes
351     *  @param v         The uint8 value
352     *  @return          Converted bytes array
353     */
354     function WriteUint8(uint8 v) internal pure returns (bytes memory) {
355         bytes memory buff;
356         assembly{
357             buff := mload(0x40)
358             mstore(buff, 1)
359             mstore(add(buff, 0x20), shl(248, v))
360             // mstore(add(buff, 0x20), byte(0x1f, v))
361             mstore(0x40, add(buff, 0x21))
362         }
363         return buff;
364     }
365 
366     /* @notice          Convert uint16 value into bytes
367     *  @param v         The uint16 value
368     *  @return          Converted bytes array
369     */
370     function WriteUint16(uint16 v) internal pure returns (bytes memory) {
371         bytes memory buff;
372 
373         assembly{
374             buff := mload(0x40)
375             let byteLen := 0x02
376             mstore(buff, byteLen)
377             for {
378                 let mindex := 0x00
379                 let vindex := 0x1f
380             } lt(mindex, byteLen) {
381                 mindex := add(mindex, 0x01)
382                 vindex := sub(vindex, 0x01)
383             }{
384                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
385             }
386             mstore(0x40, add(buff, 0x22))
387         }
388         return buff;
389     }
390 
391     /* @notice          Convert uint32 value into bytes
392     *  @param v         The uint32 value
393     *  @return          Converted bytes array
394     */
395     function WriteUint32(uint32 v) internal pure returns(bytes memory) {
396         bytes memory buff;
397         assembly{
398             buff := mload(0x40)
399             let byteLen := 0x04
400             mstore(buff, byteLen)
401             for {
402                 let mindex := 0x00
403                 let vindex := 0x1f
404             } lt(mindex, byteLen) {
405                 mindex := add(mindex, 0x01)
406                 vindex := sub(vindex, 0x01)
407             }{
408                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
409             }
410             mstore(0x40, add(buff, 0x24))
411         }
412         return buff;
413     }
414 
415     /* @notice          Convert uint64 value into bytes
416     *  @param v         The uint64 value
417     *  @return          Converted bytes array
418     */
419     function WriteUint64(uint64 v) internal pure returns(bytes memory) {
420         bytes memory buff;
421 
422         assembly{
423             buff := mload(0x40)
424             let byteLen := 0x08
425             mstore(buff, byteLen)
426             for {
427                 let mindex := 0x00
428                 let vindex := 0x1f
429             } lt(mindex, byteLen) {
430                 mindex := add(mindex, 0x01)
431                 vindex := sub(vindex, 0x01)
432             }{
433                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
434             }
435             mstore(0x40, add(buff, 0x28))
436         }
437         return buff;
438     }
439 
440     /* @notice          Convert limited uint256 value into bytes
441     *  @param v         The uint256 value
442     *  @return          Converted bytes array
443     */
444     function WriteUint255(uint256 v) internal pure returns (bytes memory) {
445         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds uint255 range");
446         bytes memory buff;
447 
448         assembly{
449             buff := mload(0x40)
450             let byteLen := 0x20
451             mstore(buff, byteLen)
452             for {
453                 let mindex := 0x00
454                 let vindex := 0x1f
455             } lt(mindex, byteLen) {
456                 mindex := add(mindex, 0x01)
457                 vindex := sub(vindex, 0x01)
458             }{
459                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
460             }
461             mstore(0x40, add(buff, 0x40))
462         }
463         return buff;
464     }
465 
466     /* @notice          Encode bytes format data into bytes
467     *  @param data      The bytes array data
468     *  @return          Encoded bytes array
469     */
470     function WriteVarBytes(bytes memory data) internal pure returns (bytes memory) {
471         uint64 l = uint64(data.length);
472         return abi.encodePacked(WriteVarUint(l), data);
473     }
474 
475     function WriteVarUint(uint64 v) internal pure returns (bytes memory) {
476         if (v < 0xFD){
477     		return WriteUint8(uint8(v));
478     	} else if (v <= 0xFFFF) {
479     		return abi.encodePacked(WriteByte(0xFD), WriteUint16(uint16(v)));
480     	} else if (v <= 0xFFFFFFFF) {
481             return abi.encodePacked(WriteByte(0xFE), WriteUint32(uint32(v)));
482     	} else {
483     		return abi.encodePacked(WriteByte(0xFF), WriteUint64(uint64(v)));
484     	}
485     }
486 }
487 
488 // File: contracts/libs/utils/ReentrancyGuard.sol
489 
490 
491 pragma solidity 0.6.12;
492 
493 /**
494  * @dev Contract module that helps prevent reentrant calls to a function.
495  *
496  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
497  * available, which can be applied to functions to make sure there are no nested
498  * (reentrant) calls to them.
499  *
500  * Note that because there is a single `nonReentrant` guard, functions marked as
501  * `nonReentrant` may not call one another. This can be worked around by making
502  * those functions `private`, and then adding `external` `nonReentrant` entry
503  * points to them.
504  *
505  * TIP: If you would like to learn more about reentrancy and alternative ways
506  * to protect against it, check out our blog post
507  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
508  */
509 contract ReentrancyGuard {
510     bool private _notEntered;
511 
512     constructor () internal {
513         // Storing an initial non-zero value makes deployment a bit more
514         // expensive, but in exchange the refund on every call to nonReentrant
515         // will be lower in amount. Since refunds are capped to a percetange of
516         // the total transaction's gas, it is best to keep them low in cases
517         // like this one, to increase the likelihood of the full refund coming
518         // into effect.
519         _notEntered = true;
520     }
521 
522     /**
523      * @dev Prevents a contract from calling itself, directly or indirectly.
524      * Calling a `nonReentrant` function from another `nonReentrant`
525      * function is not supported. It is possible to prevent this from happening
526      * by making the `nonReentrant` function external, and make it call a
527      * `private` function that does the actual work.
528      */
529     modifier nonReentrant() {
530         // On the first call to nonReentrant, _notEntered will be true
531         require(_notEntered, "ReentrancyGuard: reentrant call");
532 
533         // Any calls to nonReentrant after this point will fail
534         _notEntered = false;
535 
536         _;
537 
538         // By storing the original value once again, a refund is triggered (see
539         // https://eips.ethereum.org/EIPS/eip-2200)
540         _notEntered = true;
541     }
542 }
543 
544 // File: contracts/libs/utils/Utils.sol
545 
546 
547 pragma solidity 0.6.12;
548 
549 library Utils {
550 
551     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
552     *  @param _bs   Source bytes array
553     *  @return      bytes32
554     */
555     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
556         require(_bs.length == 32, "bytes length is not 32.");
557         assembly {
558             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
559             value := mload(add(_bs, 0x20))
560         }
561     }
562 
563     /* @notice      Convert bytes to uint256
564     *  @param _b    Source bytes should have length of 32
565     *  @return      uint256
566     */
567     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
568         require(_bs.length == 32, "bytes length is not 32.");
569         assembly {
570             // load 32 bytes from memory starting from position _bs + 32
571             value := mload(add(_bs, 0x20))
572         }
573         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
574     }
575 
576     /* @notice      Convert uint256 to bytes
577     *  @param _b    uint256 that needs to be converted
578     *  @return      bytes
579     */
580     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
581         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
582         assembly {
583             // Get a location of some free memory and store it in result as
584             // Solidity does for memory variables.
585             bs := mload(0x40)
586             // Put 0x20 at the first word, the length of bytes for uint256 value
587             mstore(bs, 0x20)
588             //In the next word, put value in bytes format to the next 32 bytes
589             mstore(add(bs, 0x20), _value)
590             // Update the free-memory pointer by padding our last write location to 32 bytes
591             mstore(0x40, add(bs, 0x40))
592         }
593     }
594 
595     /* @notice      Convert bytes to address
596     *  @param _bs   Source bytes: bytes length must be 20
597     *  @return      Converted address from source bytes
598     */
599     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
600     {
601         require(_bs.length == 20, "bytes length does not match address");
602         assembly {
603             // for _bs, first word store _bs.length, second word store _bs.value
604             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
605             addr := mload(add(_bs, 0x14))
606         }
607 
608     }
609 
610     /* @notice      Convert address to bytes
611     *  @param _addr Address need to be converted
612     *  @return      Converted bytes from address
613     */
614     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
615         assembly {
616             // Get a location of some free memory and store it in result as
617             // Solidity does for memory variables.
618             bs := mload(0x40)
619             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
620             mstore(bs, 0x14)
621             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
622             mstore(add(bs, 0x20), shl(96, _addr))
623             // Update the free-memory pointer by padding our last write location to 32 bytes
624             mstore(0x40, add(bs, 0x40))
625        }
626     }
627 
628     /* @notice          Do hash leaf as the multi-chain does
629     *  @param _data     Data in bytes format
630     *  @return          Hashed value in bytes32 format
631     */
632     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
633         result = sha256(abi.encodePacked(byte(0x0), _data));
634     }
635 
636     /* @notice          Do hash children as the multi-chain does
637     *  @param _l        Left node
638     *  @param _r        Right node
639     *  @return          Hashed value in bytes32 format
640     */
641     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
642         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
643     }
644 
645     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
646                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
647     *  @param _preBytes     The bytes stored in storage
648     *  @param _postBytes    The bytes stored in memory
649     *  @return              Bool type indicating if they are equal
650     */
651     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
652         bool success = true;
653 
654         assembly {
655             // we know _preBytes_offset is 0
656             let fslot := sload(_preBytes_slot)
657             // Arrays of 31 bytes or less have an even value in their slot,
658             // while longer arrays have an odd value. The actual length is
659             // the slot divided by two for odd values, and the lowest order
660             // byte divided by two for even values.
661             // If the slot is even, bitwise and the slot with 255 and divide by
662             // two to get the length. If the slot is odd, bitwise and the slot
663             // with -1 and divide by two.
664             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
665             let mlength := mload(_postBytes)
666 
667             // if lengths don't match the arrays are not equal
668             switch eq(slength, mlength)
669             case 1 {
670                 // fslot can contain both the length and contents of the array
671                 // if slength < 32 bytes so let's prepare for that
672                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
673                 // slength != 0
674                 if iszero(iszero(slength)) {
675                     switch lt(slength, 32)
676                     case 1 {
677                         // blank the last byte which is the length
678                         fslot := mul(div(fslot, 0x100), 0x100)
679 
680                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
681                             // unsuccess:
682                             success := 0
683                         }
684                     }
685                     default {
686                         // cb is a circuit breaker in the for loop since there's
687                         //  no said feature for inline assembly loops
688                         // cb = 1 - don't breaker
689                         // cb = 0 - break
690                         let cb := 1
691 
692                         // get the keccak hash to get the contents of the array
693                         mstore(0x0, _preBytes_slot)
694                         let sc := keccak256(0x0, 0x20)
695 
696                         let mc := add(_postBytes, 0x20)
697                         let end := add(mc, mlength)
698 
699                         // the next line is the loop condition:
700                         // while(uint(mc < end) + cb == 2)
701                         for {} eq(add(lt(mc, end), cb), 2) {
702                             sc := add(sc, 1)
703                             mc := add(mc, 0x20)
704                         } {
705                             if iszero(eq(sload(sc), mload(mc))) {
706                                 // unsuccess:
707                                 success := 0
708                                 cb := 0
709                             }
710                         }
711                     }
712                 }
713             }
714             default {
715                 // unsuccess:
716                 success := 0
717             }
718         }
719 
720         return success;
721     }
722 
723     /* @notice              Slice the _bytes from _start index till the result has length of _length
724                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
725     *  @param _bytes        The original bytes needs to be sliced
726     *  @param _start        The index of _bytes for the start of sliced bytes
727     *  @param _length       The index of _bytes for the end of sliced bytes
728     *  @return              The sliced bytes
729     */
730     function slice(
731         bytes memory _bytes,
732         uint _start,
733         uint _length
734     )
735         internal
736         pure
737         returns (bytes memory)
738     {
739         require(_bytes.length >= (_start + _length));
740 
741         bytes memory tempBytes;
742 
743         assembly {
744             switch iszero(_length)
745             case 0 {
746                 // Get a location of some free memory and store it in tempBytes as
747                 // Solidity does for memory variables.
748                 tempBytes := mload(0x40)
749 
750                 // The first word of the slice result is potentially a partial
751                 // word read from the original array. To read it, we calculate
752                 // the length of that partial word and start copying that many
753                 // bytes into the array. The first word we copy will start with
754                 // data we don't care about, but the last `lengthmod` bytes will
755                 // land at the beginning of the contents of the new array. When
756                 // we're done copying, we overwrite the full first word with
757                 // the actual length of the slice.
758                 // lengthmod <= _length % 32
759                 let lengthmod := and(_length, 31)
760 
761                 // The multiplication in the next line is necessary
762                 // because when slicing multiples of 32 bytes (lengthmod == 0)
763                 // the following copy loop was copying the origin's length
764                 // and then ending prematurely not copying everything it should.
765                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
766                 let end := add(mc, _length)
767 
768                 for {
769                     // The multiplication in the next line has the same exact purpose
770                     // as the one above.
771                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
772                 } lt(mc, end) {
773                     mc := add(mc, 0x20)
774                     cc := add(cc, 0x20)
775                 } {
776                     mstore(mc, mload(cc))
777                 }
778 
779                 mstore(tempBytes, _length)
780 
781                 //update free-memory pointer
782                 //allocating the array padded to 32 bytes like the compiler does now
783                 mstore(0x40, and(add(mc, 31), not(31)))
784             }
785             //if we want a zero-length slice let's just return a zero-length array
786             default {
787                 tempBytes := mload(0x40)
788 
789                 mstore(0x40, add(tempBytes, 0x20))
790             }
791         }
792 
793         return tempBytes;
794     }
795     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
796     *  @param _keepers      The array consists of serveral address
797     *  @param _signers      Some specific addresses to be looked into
798     *  @param _m            The number requirement paramter
799     *  @return              True means containment, false meansdo do not contain.
800     */
801     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
802         uint m = 0;
803         for(uint i = 0; i < _signers.length; i++){
804             for (uint j = 0; j < _keepers.length; j++) {
805                 if (_signers[i] == _keepers[j]) {
806                     m++;
807                     delete _keepers[j];
808                 }
809             }
810         }
811         return m >= _m;
812     }
813 
814     /* @notice              TODO
815     *  @param key
816     *  @return
817     */
818     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
819          require(key.length >= 67, "key lenggh is too short");
820          newkey = slice(key, 0, 35);
821          if (uint8(key[66]) % 2 == 0){
822              newkey[2] = byte(0x02);
823          } else {
824              newkey[2] = byte(0x03);
825          }
826          return newkey;
827     }
828 
829     /**
830      * @dev Returns true if `account` is a contract.
831      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
832      *
833      * This test is non-exhaustive, and there may be false-negatives: during the
834      * execution of a contract's constructor, its address will be reported as
835      * not containing a contract.
836      *
837      * IMPORTANT: It is unsafe to assume that an address for which this
838      * function returns false is an externally-owned account (EOA) and not a
839      * contract.
840      */
841     function isContract(address account) internal view returns (bool) {
842         // This method relies in extcodesize, which returns 0 for contracts in
843         // construction, since the code is only stored at the end of the
844         // constructor execution.
845 
846         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
847         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
848         // for accounts without code, i.e. `keccak256('')`
849         bytes32 codehash;
850         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
851         // solhint-disable-next-line no-inline-assembly
852         assembly { codehash := extcodehash(account) }
853         return (codehash != 0x0 && codehash != accountHash);
854     }
855 }
856 
857 // File: contracts/libs/math/SafeMath.sol
858 
859 
860 pragma solidity 0.6.12;
861 
862 /**
863  * @dev Wrappers over Solidity's arithmetic operations with added overflow
864  * checks.
865  *
866  * Arithmetic operations in Solidity wrap on overflow. This can easily result
867  * in bugs, because programmers usually assume that an overflow raises an
868  * error, which is the standard behavior in high level programming languages.
869  * `SafeMath` restores this intuition by reverting the transaction when an
870  * operation overflows.
871  *
872  * Using this library instead of the unchecked operations eliminates an entire
873  * class of bugs, so it's recommended to use it always.
874  */
875 library SafeMath {
876     /**
877      * @dev Returns the addition of two unsigned integers, reverting on
878      * overflow.
879      *
880      * Counterpart to Solidity's `+` operator.
881      *
882      * Requirements:
883      * - Addition cannot overflow.
884      */
885     function add(uint256 a, uint256 b) internal pure returns (uint256) {
886         uint256 c = a + b;
887         require(c >= a, "SafeMath: addition overflow");
888 
889         return c;
890     }
891 
892     /**
893      * @dev Returns the subtraction of two unsigned integers, reverting on
894      * overflow (when the result is negative).
895      *
896      * Counterpart to Solidity's `-` operator.
897      *
898      * Requirements:
899      * - Subtraction cannot overflow.
900      */
901     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
902         return sub(a, b, "SafeMath: subtraction overflow");
903     }
904 
905     /**
906      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
907      * overflow (when the result is negative).
908      *
909      * Counterpart to Solidity's `-` operator.
910      *
911      * Requirements:
912      * - Subtraction cannot overflow.
913      */
914     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
915         require(b <= a, errorMessage);
916         uint256 c = a - b;
917 
918         return c;
919     }
920 
921     /**
922      * @dev Returns the multiplication of two unsigned integers, reverting on
923      * overflow.
924      *
925      * Counterpart to Solidity's `*` operator.
926      *
927      * Requirements:
928      * - Multiplication cannot overflow.
929      */
930     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
931         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
932         // benefit is lost if 'b' is also tested.
933         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
934         if (a == 0) {
935             return 0;
936         }
937 
938         uint256 c = a * b;
939         require(c / a == b, "SafeMath: multiplication overflow");
940 
941         return c;
942     }
943 
944     /**
945      * @dev Returns the integer division of two unsigned integers. Reverts on
946      * division by zero. The result is rounded towards zero.
947      *
948      * Counterpart to Solidity's `/` operator. Note: this function uses a
949      * `revert` opcode (which leaves remaining gas untouched) while Solidity
950      * uses an invalid opcode to revert (consuming all remaining gas).
951      *
952      * Requirements:
953      * - The divisor cannot be zero.
954      */
955     function div(uint256 a, uint256 b) internal pure returns (uint256) {
956         return div(a, b, "SafeMath: division by zero");
957     }
958 
959     /**
960      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
961      * division by zero. The result is rounded towards zero.
962      *
963      * Counterpart to Solidity's `/` operator. Note: this function uses a
964      * `revert` opcode (which leaves remaining gas untouched) while Solidity
965      * uses an invalid opcode to revert (consuming all remaining gas).
966      *
967      * Requirements:
968      * - The divisor cannot be zero.
969      */
970     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
971         // Solidity only automatically asserts when dividing by 0
972         require(b > 0, errorMessage);
973         uint256 c = a / b;
974         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
975 
976         return c;
977     }
978 
979     /**
980      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
981      * Reverts when dividing by zero.
982      *
983      * Counterpart to Solidity's `%` operator. This function uses a `revert`
984      * opcode (which leaves remaining gas untouched) while Solidity uses an
985      * invalid opcode to revert (consuming all remaining gas).
986      *
987      * Requirements:
988      * - The divisor cannot be zero.
989      */
990     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
991         return mod(a, b, "SafeMath: modulo by zero");
992     }
993 
994     /**
995      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
996      * Reverts with custom message when dividing by zero.
997      *
998      * Counterpart to Solidity's `%` operator. This function uses a `revert`
999      * opcode (which leaves remaining gas untouched) while Solidity uses an
1000      * invalid opcode to revert (consuming all remaining gas).
1001      *
1002      * Requirements:
1003      * - The divisor cannot be zero.
1004      */
1005     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1006         require(b != 0, errorMessage);
1007         return a % b;
1008     }
1009 }
1010 
1011 // File: contracts/Wallet.sol
1012 
1013 
1014 pragma solidity 0.6.12;
1015 
1016 interface ERC20 {
1017     function approve(address spender, uint256 amount) external returns (bool);
1018     function transfer(address recipient, uint256 amount) external returns (bool);
1019     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1020     function balanceOf(address account) external view returns (uint256);
1021 }
1022 
1023 /// @title The Wallet contract for Switcheo TradeHub
1024 /// @author Switcheo Network
1025 /// @notice This contract faciliates deposits for Switcheo TradeHub.
1026 /// @dev This contract is used together with the LockProxy contract to allow users
1027 /// to deposit funds without requiring them to have ETH
1028 contract Wallet {
1029     bool public isInitialized;
1030     address public creator;
1031     address public owner;
1032     bytes public swthAddress;
1033 
1034     function initialize(address _owner, bytes calldata _swthAddress) external {
1035         require(isInitialized == false, "Contract already initialized");
1036         isInitialized = true;
1037         creator = msg.sender;
1038         owner = _owner;
1039         swthAddress = _swthAddress;
1040     }
1041 
1042     /// @dev Allow this contract to receive Ethereum
1043     receive() external payable {}
1044 
1045     /// @dev Allow this contract to receive ERC223 tokens
1046     // An empty implementation is required so that the ERC223 token will not
1047     // throw an error on transfer
1048     function tokenFallback(address, uint, bytes calldata) external {}
1049 
1050     /// @dev send ETH from this contract to its creator
1051     function sendETHToCreator(uint256 _amount) external {
1052         require(msg.sender == creator, "Sender must be creator");
1053         // we use `call` here following the recommendation from
1054         // https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/
1055         (bool success,  ) = creator.call{value: _amount}("");
1056         require(success, "Transfer failed");
1057     }
1058 
1059     /// @dev send tokens from this contract to its creator
1060     function sendERC20ToCreator(address _assetId, uint256 _amount) external {
1061         require(msg.sender == creator, "Sender must be creator");
1062 
1063         ERC20 token = ERC20(_assetId);
1064         _callOptionalReturn(
1065             token,
1066             abi.encodeWithSelector(
1067                 token.transfer.selector,
1068                 creator,
1069                 _amount
1070             )
1071         );
1072     }
1073 
1074     /**
1075      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1076      * on the return value: the return value is optional (but if data is returned, it must not be false).
1077      * @param token The token targeted by the call.
1078      * @param data The call data (encoded using abi.encode or one of its variants).
1079      */
1080     function _callOptionalReturn(ERC20 token, bytes memory data) private {
1081         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1082         // we're implementing it ourselves.
1083 
1084         // A Solidity high level call has three parts:
1085         //  1. The target address is checked to verify it contains contract code
1086         //  2. The call itself is made, and success asserted
1087         //  3. The return value is decoded, which in turn checks the size of the returned data.
1088         // solhint-disable-next-line max-line-length
1089         require(_isContract(address(token)), "SafeERC20: call to non-contract");
1090 
1091         // solhint-disable-next-line avoid-low-level-calls
1092         (bool success, bytes memory returndata) = address(token).call(data);
1093         require(success, "SafeERC20: low-level call failed");
1094 
1095         if (returndata.length > 0) { // Return data is optional
1096             // solhint-disable-next-line max-line-length
1097             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1098         }
1099     }
1100 
1101     /**
1102      * @dev Returns true if `account` is a contract.
1103      *
1104      * [IMPORTANT]
1105      * ====
1106      * It is unsafe to assume that an address for which this function returns
1107      * false is an externally-owned account (EOA) and not a contract.
1108      *
1109      * Among others, `_isContract` will return false for the following
1110      * types of addresses:
1111      *
1112      *  - an externally-owned account
1113      *  - a contract in construction
1114      *  - an address where a contract will be created
1115      *  - an address where a contract lived, but was destroyed
1116      * ====
1117      */
1118     function _isContract(address account) private view returns (bool) {
1119         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1120         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1121         // for accounts without code, i.e. `keccak256('')`
1122         bytes32 codehash;
1123         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1124         // solhint-disable-next-line no-inline-assembly
1125         assembly { codehash := extcodehash(account) }
1126         return (codehash != accountHash && codehash != 0x0);
1127     }
1128 }
1129 
1130 // File: contracts/LockProxy.sol
1131 
1132 
1133 pragma solidity 0.6.12;
1134 
1135 
1136 
1137 
1138 
1139 
1140 
1141 interface CCM {
1142     function crossChain(uint64 _toChainId, bytes calldata _toContract, bytes calldata _method, bytes calldata _txData) external returns (bool);
1143 }
1144 
1145 interface CCMProxy {
1146     function getEthCrossChainManager() external view returns (address);
1147 }
1148 
1149 /// @title The LockProxy contract for Switcheo TradeHub
1150 /// @author Switcheo Network
1151 /// @notice This contract faciliates deposits and withdrawals to Switcheo TradeHub.
1152 /// @dev The contract also allows for additional features in the future through "extension" contracts.
1153 contract LockProxy is ReentrancyGuard {
1154     using SafeMath for uint256;
1155 
1156     // used for cross-chain addExtension and removeExtension methods
1157     struct ExtensionTxArgs {
1158         bytes extensionAddress;
1159     }
1160 
1161     // used for cross-chain registerAsset method
1162     struct RegisterAssetTxArgs {
1163         bytes assetHash;
1164         bytes nativeAssetHash;
1165     }
1166 
1167     // used for cross-chain lock and unlock methods
1168     struct TransferTxArgs {
1169         bytes fromAssetHash;
1170         bytes toAssetHash;
1171         bytes toAddress;
1172         uint256 amount;
1173         uint256 feeAmount;
1174         bytes feeAddress;
1175         bytes fromAddress;
1176         uint256 nonce;
1177     }
1178 
1179     // used to create a unique salt for wallet creation
1180     bytes public constant SALT_PREFIX = "switcheo-eth-wallet-factory-v1";
1181     address public constant ETH_ASSET_HASH = address(0);
1182 
1183     CCMProxy public ccmProxy;
1184     uint64 public counterpartChainId;
1185     uint256 public currentNonce = 0;
1186 
1187     // a mapping of assetHashes to the hash of
1188     // (associated proxy address on Switcheo TradeHub, associated asset hash on Switcheo TradeHub)
1189     mapping(address => bytes32) public registry;
1190 
1191     // a record of signed messages to prevent replay attacks
1192     mapping(bytes32 => bool) public seenMessages;
1193 
1194     // a mapping of extension contracts
1195     mapping(address => bool) public extensions;
1196 
1197     // a record of created wallets
1198     mapping(address => bool) public wallets;
1199 
1200     event LockEvent(
1201         address fromAssetHash,
1202         address fromAddress,
1203         uint64 toChainId,
1204         bytes toAssetHash,
1205         bytes toAddress,
1206         bytes txArgs
1207     );
1208 
1209     event UnlockEvent(
1210         address toAssetHash,
1211         address toAddress,
1212         uint256 amount,
1213         bytes txArgs
1214     );
1215 
1216     constructor(address _ccmProxyAddress, uint64 _counterpartChainId) public {
1217         require(_counterpartChainId > 0, "counterpartChainId cannot be zero");
1218         require(_ccmProxyAddress != address(0), "ccmProxyAddress cannot be empty");
1219         counterpartChainId = _counterpartChainId;
1220         ccmProxy = CCMProxy(_ccmProxyAddress);
1221     }
1222 
1223     modifier onlyManagerContract() {
1224         require(
1225             msg.sender == ccmProxy.getEthCrossChainManager(),
1226             "msg.sender is not CCM"
1227         );
1228         _;
1229     }
1230 
1231     /// @dev Allow this contract to receive Ethereum
1232     receive() external payable {}
1233 
1234     /// @dev Allow this contract to receive ERC223 tokens
1235     /// An empty implementation is required so that the ERC223 token will not
1236     /// throw an error on transfer, this is specific to ERC223 tokens which
1237     /// require this implementation, e.g. DGTX
1238     function tokenFallback(address, uint, bytes calldata) external {}
1239 
1240     /// @dev Calculate the wallet address for the given owner and Switcheo TradeHub address
1241     /// @param _ownerAddress the Ethereum address which the user has control over, i.e. can sign msgs with
1242     /// @param _swthAddress the hex value of the user's Switcheo TradeHub address
1243     /// @param _bytecodeHash the hash of the wallet contract's bytecode
1244     /// @return the wallet address
1245     function getWalletAddress(
1246         address _ownerAddress,
1247         bytes calldata _swthAddress,
1248         bytes32 _bytecodeHash
1249     )
1250         external
1251         view
1252         returns (address)
1253     {
1254         bytes32 salt = _getSalt(
1255             _ownerAddress,
1256             _swthAddress
1257         );
1258 
1259         bytes32 data = keccak256(
1260             abi.encodePacked(bytes1(0xff), address(this), salt, _bytecodeHash)
1261         );
1262 
1263         return address(bytes20(data << 96));
1264     }
1265 
1266     /// @dev Create the wallet for the given owner and Switcheo TradeHub address
1267     /// @param _ownerAddress the Ethereum address which the user has control over, i.e. can sign msgs with
1268     /// @param _swthAddress the hex value of the user's Switcheo TradeHub address
1269     /// @return true if success
1270     function createWallet(
1271         address _ownerAddress,
1272         bytes calldata _swthAddress
1273     )
1274         external
1275         nonReentrant
1276         returns (bool)
1277     {
1278         require(_ownerAddress != address(0), "Empty ownerAddress");
1279         require(_swthAddress.length != 0, "Empty swthAddress");
1280 
1281         bytes32 salt = _getSalt(
1282             _ownerAddress,
1283             _swthAddress
1284         );
1285 
1286         Wallet wallet = new Wallet{salt: salt}();
1287         wallet.initialize(_ownerAddress, _swthAddress);
1288         wallets[address(wallet)] = true;
1289 
1290         return true;
1291     }
1292 
1293     /// @dev Add a contract as an extension
1294     /// @param _argsBz the serialized ExtensionTxArgs
1295     /// @param _fromChainId the originating chainId
1296     /// @return true if success
1297     function addExtension(
1298         bytes calldata _argsBz,
1299         bytes calldata /* _fromContractAddr */,
1300         uint64 _fromChainId
1301     )
1302         external
1303         onlyManagerContract
1304         nonReentrant
1305         returns (bool)
1306     {
1307         require(_fromChainId == counterpartChainId, "Invalid chain ID");
1308 
1309         ExtensionTxArgs memory args = _deserializeExtensionTxArgs(_argsBz);
1310         address extensionAddress = Utils.bytesToAddress(args.extensionAddress);
1311         extensions[extensionAddress] = true;
1312 
1313         return true;
1314     }
1315 
1316     /// @dev Remove a contract from the extensions mapping
1317     /// @param _argsBz the serialized ExtensionTxArgs
1318     /// @param _fromChainId the originating chainId
1319     /// @return true if success
1320     function removeExtension(
1321         bytes calldata _argsBz,
1322         bytes calldata /* _fromContractAddr */,
1323         uint64 _fromChainId
1324     )
1325         external
1326         onlyManagerContract
1327         nonReentrant
1328         returns (bool)
1329     {
1330         require(_fromChainId == counterpartChainId, "Invalid chain ID");
1331 
1332         ExtensionTxArgs memory args = _deserializeExtensionTxArgs(_argsBz);
1333         address extensionAddress = Utils.bytesToAddress(args.extensionAddress);
1334         extensions[extensionAddress] = false;
1335 
1336         return true;
1337     }
1338 
1339     /// @dev Marks an asset as registered by mapping the asset's address to
1340     /// the specified _fromContractAddr and assetHash on Switcheo TradeHub
1341     /// @param _argsBz the serialized RegisterAssetTxArgs
1342     /// @param _fromContractAddr the associated contract address on Switcheo TradeHub
1343     /// @param _fromChainId the originating chainId
1344     /// @return true if success
1345     function registerAsset(
1346         bytes calldata _argsBz,
1347         bytes calldata _fromContractAddr,
1348         uint64 _fromChainId
1349     )
1350         external
1351         onlyManagerContract
1352         nonReentrant
1353         returns (bool)
1354     {
1355         require(_fromChainId == counterpartChainId, "Invalid chain ID");
1356 
1357         RegisterAssetTxArgs memory args = _deserializeRegisterAssetTxArgs(_argsBz);
1358         _markAssetAsRegistered(
1359             Utils.bytesToAddress(args.nativeAssetHash),
1360             _fromContractAddr,
1361             args.assetHash
1362         );
1363 
1364         return true;
1365     }
1366 
1367     /// @dev Performs a deposit from a Wallet contract
1368     /// @param _walletAddress address of the wallet contract, the wallet contract
1369     /// does not receive ETH in this call, but _walletAddress still needs to be payable
1370     /// since the wallet contract can receive ETH, there would be compile errors otherwise
1371     /// @param _assetHash the asset to deposit
1372     /// @param _targetProxyHash the associated proxy hash on Switcheo TradeHub
1373     /// @param _toAssetHash the associated asset hash on Switcheo TradeHub
1374     /// @param _feeAddress the hex version of the Switcheo TradeHub address to send the fee to
1375     /// @param _values[0]: amount, the number of tokens to deposit
1376     /// @param _values[1]: feeAmount, the number of tokens to be used as fees
1377     /// @param _values[2]: nonce, to prevent replay attacks
1378     /// @param _values[3]: callAmount, some tokens may burn an amount before transfer
1379     /// so we allow a callAmount to support these tokens
1380     /// @param _v: the v value of the wallet owner's signature
1381     /// @param _rs: the r, s values of the wallet owner's signature
1382     function lockFromWallet(
1383         address payable _walletAddress,
1384         address _assetHash,
1385         bytes calldata _targetProxyHash,
1386         bytes calldata _toAssetHash,
1387         bytes calldata _feeAddress,
1388         uint256[] calldata _values,
1389         uint8 _v,
1390         bytes32[] calldata _rs
1391     )
1392         external
1393         nonReentrant
1394         returns (bool)
1395     {
1396         require(wallets[_walletAddress], "Invalid wallet address");
1397 
1398         Wallet wallet = Wallet(_walletAddress);
1399         _validateLockFromWallet(
1400             wallet.owner(),
1401             _assetHash,
1402             _targetProxyHash,
1403             _toAssetHash,
1404             _feeAddress,
1405             _values,
1406             _v,
1407             _rs
1408         );
1409 
1410         // it is very important that this function validates the success of a transfer correctly
1411         // since, once this line is passed, the deposit is assumed to be successful
1412         // which will eventually result in the specified amount of tokens being minted for the
1413         // wallet.swthAddress on Switcheo TradeHub
1414         _transferInFromWallet(_walletAddress, _assetHash, _values[0], _values[3]);
1415 
1416         _lock(
1417             _assetHash,
1418             _targetProxyHash,
1419             _toAssetHash,
1420             wallet.swthAddress(),
1421             _values[0],
1422             _values[1],
1423             _feeAddress
1424         );
1425 
1426         return true;
1427     }
1428 
1429     /// @dev Performs a deposit
1430     /// @param _assetHash the asset to deposit
1431     /// @param _targetProxyHash the associated proxy hash on Switcheo TradeHub
1432     /// @param _toAddress the hex version of the Switcheo TradeHub address to deposit to
1433     /// @param _toAssetHash the associated asset hash on Switcheo TradeHub
1434     /// @param _feeAddress the hex version of the Switcheo TradeHub address to send the fee to
1435     /// @param _values[0]: amount, the number of tokens to deposit
1436     /// @param _values[1]: feeAmount, the number of tokens to be used as fees
1437     /// @param _values[2]: callAmount, some tokens may burn an amount before transfer
1438     /// so we allow a callAmount to support these tokens
1439     function lock(
1440         address _assetHash,
1441         bytes calldata _targetProxyHash,
1442         bytes calldata _toAddress,
1443         bytes calldata _toAssetHash,
1444         bytes calldata _feeAddress,
1445         uint256[] calldata _values
1446     )
1447         external
1448         payable
1449         nonReentrant
1450         returns (bool)
1451     {
1452 
1453         // it is very important that this function validates the success of a transfer correctly
1454         // since, once this line is passed, the deposit is assumed to be successful
1455         // which will eventually result in the specified amount of tokens being minted for the
1456         // _toAddress on Switcheo TradeHub
1457         _transferIn(_assetHash, _values[0], _values[2]);
1458 
1459         _lock(
1460             _assetHash,
1461             _targetProxyHash,
1462             _toAssetHash,
1463             _toAddress,
1464             _values[0],
1465             _values[1],
1466             _feeAddress
1467         );
1468 
1469         return true;
1470     }
1471 
1472     /// @dev Performs a withdrawal that was initiated on Switcheo TradeHub
1473     /// @param _argsBz the serialized TransferTxArgs
1474     /// @param _fromContractAddr the associated contract address on Switcheo TradeHub
1475     /// @param _fromChainId the originating chainId
1476     /// @return true if success
1477     function unlock(
1478         bytes calldata _argsBz,
1479         bytes calldata _fromContractAddr,
1480         uint64 _fromChainId
1481     )
1482         external
1483         onlyManagerContract
1484         nonReentrant
1485         returns (bool)
1486     {
1487         require(_fromChainId == counterpartChainId, "Invalid chain ID");
1488 
1489         TransferTxArgs memory args = _deserializeTransferTxArgs(_argsBz);
1490         require(args.fromAssetHash.length > 0, "Invalid fromAssetHash");
1491         require(args.toAssetHash.length == 20, "Invalid toAssetHash");
1492 
1493         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
1494         address toAddress = Utils.bytesToAddress(args.toAddress);
1495 
1496         _validateAssetRegistration(toAssetHash, _fromContractAddr, args.fromAssetHash);
1497         _transferOut(toAddress, toAssetHash, args.amount);
1498 
1499         emit UnlockEvent(toAssetHash, toAddress, args.amount, _argsBz);
1500         return true;
1501     }
1502 
1503     /// @dev Performs a transfer of funds, this is only callable by approved extension contracts
1504     /// the `nonReentrant` guard is intentionally not added to this function, to allow for more flexibility.
1505     /// The calling contract should be secure and have its own `nonReentrant` guard as needed.
1506     /// @param _receivingAddress the address to transfer to
1507     /// @param _assetHash the asset to transfer
1508     /// @param _amount the amount to transfer
1509     /// @return true if success
1510     function extensionTransfer(
1511         address _receivingAddress,
1512         address _assetHash,
1513         uint256 _amount
1514     )
1515         external
1516         returns (bool)
1517     {
1518         require(
1519             extensions[msg.sender] == true,
1520             "Invalid extension"
1521         );
1522 
1523         if (_assetHash == ETH_ASSET_HASH) {
1524             // we use `call` here since the _receivingAddress could be a contract
1525             // see https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/
1526             // for more info
1527             (bool success,  ) = _receivingAddress.call{value: _amount}("");
1528             require(success, "Transfer failed");
1529             return true;
1530         }
1531 
1532         ERC20 token = ERC20(_assetHash);
1533         _callOptionalReturn(
1534             token,
1535             abi.encodeWithSelector(
1536                 token.approve.selector,
1537                 _receivingAddress,
1538                 _amount
1539             )
1540         );
1541 
1542         return true;
1543     }
1544 
1545     /// @dev Marks an asset as registered by associating it to a specified Switcheo TradeHub proxy and asset hash
1546     /// @param _assetHash the address of the asset to mark
1547     /// @param _proxyAddress the associated proxy address on Switcheo TradeHub
1548     /// @param _toAssetHash the associated asset hash on Switcheo TradeHub
1549     function _markAssetAsRegistered(
1550         address _assetHash,
1551         bytes memory _proxyAddress,
1552         bytes memory _toAssetHash
1553     )
1554         private
1555     {
1556         require(_proxyAddress.length == 20, "Invalid proxyAddress");
1557         require(
1558             registry[_assetHash] == bytes32(0),
1559             "Asset already registered"
1560         );
1561 
1562         bytes32 value = keccak256(abi.encodePacked(
1563             _proxyAddress,
1564             _toAssetHash
1565         ));
1566 
1567         registry[_assetHash] = value;
1568     }
1569 
1570     /// @dev Validates that an asset's registration matches the given params
1571     /// @param _assetHash the address of the asset to check
1572     /// @param _proxyAddress the expected proxy address on Switcheo TradeHub
1573     /// @param _toAssetHash the expected asset hash on Switcheo TradeHub
1574     function _validateAssetRegistration(
1575         address _assetHash,
1576         bytes memory _proxyAddress,
1577         bytes memory _toAssetHash
1578     )
1579         private
1580         view
1581     {
1582         require(_proxyAddress.length == 20, "Invalid proxyAddress");
1583         bytes32 value = keccak256(abi.encodePacked(
1584             _proxyAddress,
1585             _toAssetHash
1586         ));
1587         require(registry[_assetHash] == value, "Asset not registered");
1588     }
1589 
1590     /// @dev validates the asset registration and calls the CCM contract
1591     function _lock(
1592         address _fromAssetHash,
1593         bytes memory _targetProxyHash,
1594         bytes memory _toAssetHash,
1595         bytes memory _toAddress,
1596         uint256 _amount,
1597         uint256 _feeAmount,
1598         bytes memory _feeAddress
1599     )
1600         private
1601     {
1602         require(_targetProxyHash.length == 20, "Invalid targetProxyHash");
1603         require(_toAssetHash.length > 0, "Empty toAssetHash");
1604         require(_toAddress.length > 0, "Empty toAddress");
1605         require(_amount > 0, "Amount must be more than zero");
1606         require(_feeAmount < _amount, "Fee amount cannot be greater than amount");
1607 
1608         _validateAssetRegistration(_fromAssetHash, _targetProxyHash, _toAssetHash);
1609 
1610         TransferTxArgs memory txArgs = TransferTxArgs({
1611             fromAssetHash: Utils.addressToBytes(_fromAssetHash),
1612             toAssetHash: _toAssetHash,
1613             toAddress: _toAddress,
1614             amount: _amount,
1615             feeAmount: _feeAmount,
1616             feeAddress: _feeAddress,
1617             fromAddress: abi.encodePacked(msg.sender),
1618             nonce: _getNextNonce()
1619         });
1620 
1621         bytes memory txData = _serializeTransferTxArgs(txArgs);
1622         CCM ccm = _getCcm();
1623         require(
1624             ccm.crossChain(counterpartChainId, _targetProxyHash, "unlock", txData),
1625             "EthCrossChainManager crossChain executed error!"
1626         );
1627 
1628         emit LockEvent(_fromAssetHash, msg.sender, counterpartChainId, _toAssetHash, _toAddress, txData);
1629     }
1630 
1631     /// @dev validate the signature for lockFromWallet
1632     function _validateLockFromWallet(
1633         address _walletOwner,
1634         address _assetHash,
1635         bytes memory _targetProxyHash,
1636         bytes memory _toAssetHash,
1637         bytes memory _feeAddress,
1638         uint256[] memory _values,
1639         uint8 _v,
1640         bytes32[] memory _rs
1641     )
1642         private
1643     {
1644         bytes32 message = keccak256(abi.encodePacked(
1645             "sendTokens",
1646             _assetHash,
1647             _targetProxyHash,
1648             _toAssetHash,
1649             _feeAddress,
1650             _values[0],
1651             _values[1],
1652             _values[2]
1653         ));
1654 
1655         require(seenMessages[message] == false, "Message already seen");
1656         seenMessages[message] = true;
1657         _validateSignature(message, _walletOwner, _v, _rs[0], _rs[1]);
1658     }
1659 
1660     /// @dev transfers funds from a Wallet contract into this contract
1661     /// the difference between this contract's before and after balance must equal _amount
1662     /// this is assumed to be sufficient in ensuring that the expected amount
1663     /// of funds were transferred in
1664     function _transferInFromWallet(
1665         address payable _walletAddress,
1666         address _assetHash,
1667         uint256 _amount,
1668         uint256 _callAmount
1669     )
1670         private
1671     {
1672         Wallet wallet = Wallet(_walletAddress);
1673         if (_assetHash == ETH_ASSET_HASH) {
1674             uint256 before = address(this).balance;
1675 
1676             wallet.sendETHToCreator(_callAmount);
1677 
1678             uint256 transferred = address(this).balance.sub(before);
1679             require(transferred == _amount, "ETH transferred does not match the expected amount");
1680             return;
1681         }
1682 
1683         ERC20 token = ERC20(_assetHash);
1684         uint256 before = token.balanceOf(address(this));
1685 
1686         wallet.sendERC20ToCreator(_assetHash, _callAmount);
1687 
1688         uint256 transferred = token.balanceOf(address(this)).sub(before);
1689         require(transferred == _amount, "Tokens transferred does not match the expected amount");
1690     }
1691 
1692     /// @dev transfers funds from an address into this contract
1693     /// for ETH transfers, we only check that msg.value == _amount, and _callAmount is ignored
1694     /// for token transfers, the difference between this contract's before and after balance must equal _amount
1695     /// these checks are assumed to be sufficient in ensuring that the expected amount
1696     /// of funds were transferred in
1697     function _transferIn(
1698         address _assetHash,
1699         uint256 _amount,
1700         uint256 _callAmount
1701     )
1702         private
1703     {
1704         if (_assetHash == ETH_ASSET_HASH) {
1705             require(msg.value == _amount, "ETH transferred does not match the expected amount");
1706             return;
1707         }
1708 
1709         ERC20 token = ERC20(_assetHash);
1710         uint256 before = token.balanceOf(address(this));
1711         _callOptionalReturn(
1712             token,
1713             abi.encodeWithSelector(
1714                 token.transferFrom.selector,
1715                 msg.sender,
1716                 address(this),
1717                 _callAmount
1718             )
1719         );
1720         uint256 transferred = token.balanceOf(address(this)).sub(before);
1721         require(transferred == _amount, "Tokens transferred does not match the expected amount");
1722     }
1723 
1724     /// @dev transfers funds from this contract to the _toAddress
1725     function _transferOut(
1726         address _toAddress,
1727         address _assetHash,
1728         uint256 _amount
1729     )
1730         private
1731     {
1732         if (_assetHash == ETH_ASSET_HASH) {
1733             // we use `call` here since the _receivingAddress could be a contract
1734             // see https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/
1735             // for more info
1736             (bool success,  ) = _toAddress.call{value: _amount}("");
1737             require(success, "Transfer failed");
1738             return;
1739         }
1740 
1741         ERC20 token = ERC20(_assetHash);
1742         _callOptionalReturn(
1743             token,
1744             abi.encodeWithSelector(
1745                 token.transfer.selector,
1746                 _toAddress,
1747                 _amount
1748             )
1749         );
1750     }
1751 
1752     /// @dev validates a signature against the specified user address
1753     function _validateSignature(
1754         bytes32 _message,
1755         address _user,
1756         uint8 _v,
1757         bytes32 _r,
1758         bytes32 _s
1759     )
1760         private
1761         pure
1762     {
1763         bytes32 prefixedMessage = keccak256(abi.encodePacked(
1764             "\x19Ethereum Signed Message:\n32",
1765             _message
1766         ));
1767 
1768         require(
1769             _user == ecrecover(prefixedMessage, _v, _r, _s),
1770             "Invalid signature"
1771         );
1772     }
1773 
1774     function _serializeTransferTxArgs(TransferTxArgs memory args) private pure returns (bytes memory) {
1775         bytes memory buff;
1776         buff = abi.encodePacked(
1777             ZeroCopySink.WriteVarBytes(args.fromAssetHash),
1778             ZeroCopySink.WriteVarBytes(args.toAssetHash),
1779             ZeroCopySink.WriteVarBytes(args.toAddress),
1780             ZeroCopySink.WriteUint255(args.amount),
1781             ZeroCopySink.WriteUint255(args.feeAmount),
1782             ZeroCopySink.WriteVarBytes(args.feeAddress),
1783             ZeroCopySink.WriteVarBytes(args.fromAddress),
1784             ZeroCopySink.WriteUint255(args.nonce)
1785         );
1786         return buff;
1787     }
1788 
1789     function _deserializeTransferTxArgs(bytes memory valueBz) private pure returns (TransferTxArgs memory) {
1790         TransferTxArgs memory args;
1791         uint256 off = 0;
1792         (args.fromAssetHash, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1793         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1794         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1795         (args.amount, off) = ZeroCopySource.NextUint255(valueBz, off);
1796         return args;
1797     }
1798 
1799     function _deserializeRegisterAssetTxArgs(bytes memory valueBz) private pure returns (RegisterAssetTxArgs memory) {
1800         RegisterAssetTxArgs memory args;
1801         uint256 off = 0;
1802         (args.assetHash, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1803         (args.nativeAssetHash, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1804         return args;
1805     }
1806 
1807     function _deserializeExtensionTxArgs(bytes memory valueBz) private pure returns (ExtensionTxArgs memory) {
1808         ExtensionTxArgs memory args;
1809         uint256 off = 0;
1810         (args.extensionAddress, off) = ZeroCopySource.NextVarBytes(valueBz, off);
1811         return args;
1812     }
1813 
1814     function _getCcm() private view returns (CCM) {
1815       CCM ccm = CCM(ccmProxy.getEthCrossChainManager());
1816       return ccm;
1817     }
1818 
1819     function _getNextNonce() private returns (uint256) {
1820       currentNonce = currentNonce.add(1);
1821       return currentNonce;
1822     }
1823 
1824     function _getSalt(
1825         address _ownerAddress,
1826         bytes memory _swthAddress
1827     )
1828         private
1829         pure
1830         returns (bytes32)
1831     {
1832         return keccak256(abi.encodePacked(
1833             SALT_PREFIX,
1834             _ownerAddress,
1835             _swthAddress
1836         ));
1837     }
1838 
1839 
1840     /**
1841      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1842      * on the return value: the return value is optional (but if data is returned, it must not be false).
1843      * @param token The token targeted by the call.
1844      * @param data The call data (encoded using abi.encode or one of its variants).
1845      */
1846     function _callOptionalReturn(ERC20 token, bytes memory data) private {
1847         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1848         // we're implementing it ourselves.
1849 
1850         // A Solidity high level call has three parts:
1851         //  1. The target address is checked to verify it contains contract code
1852         //  2. The call itself is made, and success asserted
1853         //  3. The return value is decoded, which in turn checks the size of the returned data.
1854         // solhint-disable-next-line max-line-length
1855         require(_isContract(address(token)), "SafeERC20: call to non-contract");
1856 
1857         // solhint-disable-next-line avoid-low-level-calls
1858         (bool success, bytes memory returndata) = address(token).call(data);
1859         require(success, "SafeERC20: low-level call failed");
1860 
1861         if (returndata.length > 0) { // Return data is optional
1862             // solhint-disable-next-line max-line-length
1863             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1864         }
1865     }
1866 
1867     /**
1868      * @dev Returns true if `account` is a contract.
1869      *
1870      * [IMPORTANT]
1871      * ====
1872      * It is unsafe to assume that an address for which this function returns
1873      * false is an externally-owned account (EOA) and not a contract.
1874      *
1875      * Among others, `_isContract` will return false for the following
1876      * types of addresses:
1877      *
1878      *  - an externally-owned account
1879      *  - a contract in construction
1880      *  - an address where a contract will be created
1881      *  - an address where a contract lived, but was destroyed
1882      * ====
1883      */
1884     function _isContract(address account) private view returns (bool) {
1885         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1886         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1887         // for accounts without code, i.e. `keccak256('')`
1888         bytes32 codehash;
1889         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1890         // solhint-disable-next-line no-inline-assembly
1891         assembly { codehash := extcodehash(account) }
1892         return (codehash != accountHash && codehash != 0x0);
1893     }
1894 }