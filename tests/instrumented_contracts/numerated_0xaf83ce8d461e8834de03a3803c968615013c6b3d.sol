1 pragma solidity ^0.6.0;
2 library SafeMath {
3     /**
4      * @dev Returns the addition of two unsigned integers, reverting on
5      * overflow.
6      *
7      * Counterpart to Solidity's `+` operator.
8      *
9      * Requirements:
10      * - Addition cannot overflow.
11      */
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         require(c >= a, "SafeMath: addition overflow");
15 
16         return c;
17     }
18 
19     /**
20      * @dev Returns the subtraction of two unsigned integers, reverting on
21      * overflow (when the result is negative).
22      *
23      * Counterpart to Solidity's `-` operator.
24      *
25      * Requirements:
26      * - Subtraction cannot overflow.
27      */
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
34      * overflow (when the result is negative).
35      *
36      * Counterpart to Solidity's `-` operator.
37      *
38      * Requirements:
39      * - Subtraction cannot overflow.
40      *
41      * _Available since v2.4.0._
42      */
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      *
99      * _Available since v2.4.0._
100      */
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         // Solidity only automatically asserts when dividing by 0
103         require(b != 0, errorMessage);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
112      * Reverts when dividing by zero.
113      *
114      * Counterpart to Solidity's `%` operator. This function uses a `revert`
115      * opcode (which leaves remaining gas untouched) while Solidity uses an
116      * invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      * - The divisor cannot be zero.
120      */
121     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
122         return mod(a, b, "SafeMath: modulo by zero");
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts with custom message when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      *
136      * _Available since v2.4.0._
137      */
138     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b != 0, errorMessage);
140         return a % b;
141     }
142 }
143 
144 library ZeroCopySink {
145     /* @notice          Convert boolean value into bytes
146     *  @param b         The boolean value
147     *  @return          Converted bytes array
148     */
149     function WriteBool(bool b) internal pure returns (bytes memory) {
150         bytes memory buff;
151         assembly{
152             buff := mload(0x40)
153             mstore(buff, 1)
154             switch iszero(b)
155             case 1 {
156                 mstore(add(buff, 0x20), shl(248, 0x00))
157                 // mstore8(add(buff, 0x20), 0x00)
158             }
159             default {
160                 mstore(add(buff, 0x20), shl(248, 0x01))
161                 // mstore8(add(buff, 0x20), 0x01)
162             }
163             mstore(0x40, add(buff, 0x21))
164         }
165         return buff;
166     }
167 
168     /* @notice          Convert byte value into bytes
169     *  @param b         The byte value
170     *  @return          Converted bytes array
171     */
172     function WriteByte(byte b) internal pure returns (bytes memory) {
173         return WriteUint8(uint8(b));
174     }
175 
176     /* @notice          Convert uint8 value into bytes
177     *  @param v         The uint8 value
178     *  @return          Converted bytes array
179     */
180     function WriteUint8(uint8 v) internal pure returns (bytes memory) {
181         bytes memory buff;
182         assembly{
183             buff := mload(0x40)
184             mstore(buff, 1)
185             mstore(add(buff, 0x20), shl(248, v))
186             // mstore(add(buff, 0x20), byte(0x1f, v))
187             mstore(0x40, add(buff, 0x21))
188         }
189         return buff;
190     }
191 
192     /* @notice          Convert uint16 value into bytes
193     *  @param v         The uint16 value
194     *  @return          Converted bytes array
195     */
196     function WriteUint16(uint16 v) internal pure returns (bytes memory) {
197         bytes memory buff;
198 
199         assembly{
200             buff := mload(0x40)
201             let byteLen := 0x02
202             mstore(buff, byteLen)
203             for {
204                 let mindex := 0x00
205                 let vindex := 0x1f
206             } lt(mindex, byteLen) {
207                 mindex := add(mindex, 0x01)
208                 vindex := sub(vindex, 0x01)
209             }{
210                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
211             }
212             mstore(0x40, add(buff, 0x22))
213         }
214         return buff;
215     }
216     
217     /* @notice          Convert uint32 value into bytes
218     *  @param v         The uint32 value
219     *  @return          Converted bytes array
220     */
221     function WriteUint32(uint32 v) internal pure returns(bytes memory) {
222         bytes memory buff;
223         assembly{
224             buff := mload(0x40)
225             let byteLen := 0x04
226             mstore(buff, byteLen)
227             for {
228                 let mindex := 0x00
229                 let vindex := 0x1f
230             } lt(mindex, byteLen) {
231                 mindex := add(mindex, 0x01)
232                 vindex := sub(vindex, 0x01)
233             }{
234                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
235             }
236             mstore(0x40, add(buff, 0x24))
237         }
238         return buff;
239     }
240 
241     /* @notice          Convert uint64 value into bytes
242     *  @param v         The uint64 value
243     *  @return          Converted bytes array
244     */
245     function WriteUint64(uint64 v) internal pure returns(bytes memory) {
246         bytes memory buff;
247 
248         assembly{
249             buff := mload(0x40)
250             let byteLen := 0x08
251             mstore(buff, byteLen)
252             for {
253                 let mindex := 0x00
254                 let vindex := 0x1f
255             } lt(mindex, byteLen) {
256                 mindex := add(mindex, 0x01)
257                 vindex := sub(vindex, 0x01)
258             }{
259                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
260             }
261             mstore(0x40, add(buff, 0x28))
262         }
263         return buff;
264     }
265 
266     /* @notice          Convert limited uint256 value into bytes
267     *  @param v         The uint256 value
268     *  @return          Converted bytes array
269     */
270     function WriteUint255(uint256 v) internal pure returns (bytes memory) {
271         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds uint255 range");
272         bytes memory buff;
273 
274         assembly{
275             buff := mload(0x40)
276             let byteLen := 0x20
277             mstore(buff, byteLen)
278             for {
279                 let mindex := 0x00
280                 let vindex := 0x1f
281             } lt(mindex, byteLen) {
282                 mindex := add(mindex, 0x01)
283                 vindex := sub(vindex, 0x01)
284             }{
285                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
286             }
287             mstore(0x40, add(buff, 0x40))
288         }
289         return buff;
290     }
291 
292     /* @notice          Encode bytes format data into bytes
293     *  @param data      The bytes array data
294     *  @return          Encoded bytes array
295     */
296     function WriteVarBytes(bytes memory data) internal pure returns (bytes memory) {
297         uint64 l = uint64(data.length);
298         return abi.encodePacked(WriteVarUint(l), data);
299     }
300 
301     function WriteVarUint(uint64 v) internal pure returns (bytes memory) {
302         if (v < 0xFD){
303     		return WriteUint8(uint8(v));
304     	} else if (v <= 0xFFFF) {
305     		return abi.encodePacked(WriteByte(0xFD), WriteUint16(uint16(v)));
306     	} else if (v <= 0xFFFFFFFF) {
307             return abi.encodePacked(WriteByte(0xFE), WriteUint32(uint32(v)));
308     	} else {
309     		return abi.encodePacked(WriteByte(0xFF), WriteUint64(uint64(v)));
310     	}
311     }
312 }
313 library ZeroCopySource {
314     /* @notice              Read next byte as boolean type starting at offset from buff
315     *  @param buff          Source bytes array
316     *  @param offset        The position from where we read the boolean value
317     *  @return              The the read boolean value and new offset
318     */
319     function NextBool(bytes memory buff, uint256 offset) internal pure returns(bool, uint256) {
320         require(offset + 1 <= buff.length && offset < offset + 1, "Offset exceeds limit");
321         // byte === bytes1
322         byte v;
323         assembly{
324             v := mload(add(add(buff, 0x20), offset))
325         }
326         bool value;
327         if (v == 0x01) {
328 		    value = true;
329     	} else if (v == 0x00) {
330             value = false;
331         } else {
332             revert("NextBool value error");
333         }
334         return (value, offset + 1);
335     }
336 
337     /* @notice              Read next byte starting at offset from buff
338     *  @param buff          Source bytes array
339     *  @param offset        The position from where we read the byte value
340     *  @return              The read byte value and new offset
341     */
342     function NextByte(bytes memory buff, uint256 offset) internal pure returns (byte, uint256) {
343         require(offset + 1 <= buff.length && offset < offset + 1, "NextByte, Offset exceeds maximum");
344         byte v;
345         assembly{
346             v := mload(add(add(buff, 0x20), offset))
347         }
348         return (v, offset + 1);
349     }
350 
351     /* @notice              Read next byte as uint8 starting at offset from buff
352     *  @param buff          Source bytes array
353     *  @param offset        The position from where we read the byte value
354     *  @return              The read uint8 value and new offset
355     */
356     function NextUint8(bytes memory buff, uint256 offset) internal pure returns (uint8, uint256) {
357         require(offset + 1 <= buff.length && offset < offset + 1, "NextUint8, Offset exceeds maximum");
358         uint8 v;
359         assembly{
360             let tmpbytes := mload(0x40)
361             let bvalue := mload(add(add(buff, 0x20), offset))
362             mstore8(tmpbytes, byte(0, bvalue))
363             mstore(0x40, add(tmpbytes, 0x01))
364             v := mload(sub(tmpbytes, 0x1f))
365         }
366         return (v, offset + 1);
367     }
368 
369     /* @notice              Read next two bytes as uint16 type starting from offset
370     *  @param buff          Source bytes array
371     *  @param offset        The position from where we read the uint16 value
372     *  @return              The read uint16 value and updated offset
373     */
374     function NextUint16(bytes memory buff, uint256 offset) internal pure returns (uint16, uint256) {
375         require(offset + 2 <= buff.length && offset < offset + 2, "NextUint16, offset exceeds maximum");
376         
377         uint16 v;
378         assembly {
379             let tmpbytes := mload(0x40)
380             let bvalue := mload(add(add(buff, 0x20), offset))
381             mstore8(tmpbytes, byte(0x01, bvalue))
382             mstore8(add(tmpbytes, 0x01), byte(0, bvalue))
383             mstore(0x40, add(tmpbytes, 0x02))
384             v := mload(sub(tmpbytes, 0x1e))
385         }
386         return (v, offset + 2);
387     }
388 
389 
390     /* @notice              Read next four bytes as uint32 type starting from offset
391     *  @param buff          Source bytes array
392     *  @param offset        The position from where we read the uint32 value
393     *  @return              The read uint32 value and updated offset
394     */
395     function NextUint32(bytes memory buff, uint256 offset) internal pure returns (uint32, uint256) {
396         require(offset + 4 <= buff.length && offset < offset + 4, "NextUint32, offset exceeds maximum");
397         uint32 v;
398         assembly {
399             let tmpbytes := mload(0x40)
400             let byteLen := 0x04
401             for {
402                 let tindex := 0x00
403                 let bindex := sub(byteLen, 0x01)
404                 let bvalue := mload(add(add(buff, 0x20), offset))
405             } lt(tindex, byteLen) {
406                 tindex := add(tindex, 0x01)
407                 bindex := sub(bindex, 0x01)
408             }{
409                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
410             }
411             mstore(0x40, add(tmpbytes, byteLen))
412             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
413         }
414         return (v, offset + 4);
415     }
416 
417     /* @notice              Read next eight bytes as uint64 type starting from offset
418     *  @param buff          Source bytes array
419     *  @param offset        The position from where we read the uint64 value
420     *  @return              The read uint64 value and updated offset
421     */
422     function NextUint64(bytes memory buff, uint256 offset) internal pure returns (uint64, uint256) {
423         require(offset + 8 <= buff.length && offset < offset + 8, "NextUint64, offset exceeds maximum");
424         uint64 v;
425         assembly {
426             let tmpbytes := mload(0x40)
427             let byteLen := 0x08
428             for {
429                 let tindex := 0x00
430                 let bindex := sub(byteLen, 0x01)
431                 let bvalue := mload(add(add(buff, 0x20), offset))
432             } lt(tindex, byteLen) {
433                 tindex := add(tindex, 0x01)
434                 bindex := sub(bindex, 0x01)
435             }{
436                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
437             }
438             mstore(0x40, add(tmpbytes, byteLen))
439             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
440         }
441         return (v, offset + 8);
442     }
443 
444     /* @notice              Read next 32 bytes as uint256 type starting from offset,
445                             there are limits considering the numerical limits in multi-chain
446     *  @param buff          Source bytes array
447     *  @param offset        The position from where we read the uint256 value
448     *  @return              The read uint256 value and updated offset
449     */
450     function NextUint255(bytes memory buff, uint256 offset) internal pure returns (uint256, uint256) {
451         require(offset + 32 <= buff.length && offset < offset + 32, "NextUint255, offset exceeds maximum");
452         uint256 v;
453         assembly {
454             let tmpbytes := mload(0x40)
455             let byteLen := 0x20
456             for {
457                 let tindex := 0x00
458                 let bindex := sub(byteLen, 0x01)
459                 let bvalue := mload(add(add(buff, 0x20), offset))
460             } lt(tindex, byteLen) {
461                 tindex := add(tindex, 0x01)
462                 bindex := sub(bindex, 0x01)
463             }{
464                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
465             }
466             mstore(0x40, add(tmpbytes, byteLen))
467             v := mload(tmpbytes)
468         }
469         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
470         return (v, offset + 32);
471     }
472     /* @notice              Read next variable bytes starting from offset,
473                             the decoding rule coming from multi-chain
474     *  @param buff          Source bytes array
475     *  @param offset        The position from where we read the bytes value
476     *  @return              The read variable bytes array value and updated offset
477     */
478     function NextVarBytes(bytes memory buff, uint256 offset) internal pure returns(bytes memory, uint256) {
479         uint len;
480         (len, offset) = NextVarUint(buff, offset);
481         require(offset + len <= buff.length && offset < offset + len, "NextVarBytes, offset exceeds maximum");
482         bytes memory tempBytes;
483         assembly{
484             switch iszero(len)
485             case 0 {
486                 // Get a location of some free memory and store it in tempBytes as
487                 // Solidity does for memory variables.
488                 tempBytes := mload(0x40)
489 
490                 // The first word of the slice result is potentially a partial
491                 // word read from the original array. To read it, we calculate
492                 // the length of that partial word and start copying that many
493                 // bytes into the array. The first word we copy will start with
494                 // data we don't care about, but the last `lengthmod` bytes will
495                 // land at the beginning of the contents of the new array. When
496                 // we're done copying, we overwrite the full first word with
497                 // the actual length of the slice.
498                 let lengthmod := and(len, 31)
499 
500                 // The multiplication in the next line is necessary
501                 // because when slicing multiples of 32 bytes (lengthmod == 0)
502                 // the following copy loop was copying the origin's length
503                 // and then ending prematurely not copying everything it should.
504                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
505                 let end := add(mc, len)
506 
507                 for {
508                     // The multiplication in the next line has the same exact purpose
509                     // as the one above.
510                     let cc := add(add(add(buff, lengthmod), mul(0x20, iszero(lengthmod))), offset)
511                 } lt(mc, end) {
512                     mc := add(mc, 0x20)
513                     cc := add(cc, 0x20)
514                 } {
515                     mstore(mc, mload(cc))
516                 }
517 
518                 mstore(tempBytes, len)
519 
520                 //update free-memory pointer
521                 //allocating the array padded to 32 bytes like the compiler does now
522                 mstore(0x40, and(add(mc, 31), not(31)))
523             }
524             //if we want a zero-length slice let's just return a zero-length array
525             default {
526                 tempBytes := mload(0x40)
527 
528                 mstore(0x40, add(tempBytes, 0x20))
529             }
530         }
531 
532         return (tempBytes, offset + len);
533     }
534     /* @notice              Read next 32 bytes starting from offset,
535     *  @param buff          Source bytes array
536     *  @param offset        The position from where we read the bytes value
537     *  @return              The read bytes32 value and updated offset
538     */
539     function NextHash(bytes memory buff, uint256 offset) internal pure returns (bytes32 , uint256) {
540         require(offset + 32 <= buff.length && offset < offset + 32, "NextHash, offset exceeds maximum");
541         bytes32 v;
542         assembly {
543             v := mload(add(buff, add(offset, 0x20)))
544         }
545         return (v, offset + 32);
546     }
547 
548     /* @notice              Read next 20 bytes starting from offset,
549     *  @param buff          Source bytes array
550     *  @param offset        The position from where we read the bytes value
551     *  @return              The read bytes20 value and updated offset
552     */
553     function NextBytes20(bytes memory buff, uint256 offset) internal pure returns (bytes20 , uint256) {
554         require(offset + 20 <= buff.length && offset < offset + 20, "NextBytes20, offset exceeds maximum");
555         bytes20 v;
556         assembly {
557             v := mload(add(buff, add(offset, 0x20)))
558         }
559         return (v, offset + 20);
560     }
561     
562     function NextVarUint(bytes memory buff, uint256 offset) internal pure returns(uint, uint256) {
563         byte v;
564         (v, offset) = NextByte(buff, offset);
565 
566         uint value;
567         if (v == 0xFD) {
568             // return NextUint16(buff, offset);
569             (value, offset) = NextUint16(buff, offset);
570             require(value >= 0xFD && value <= 0xFFFF, "NextUint16, value outside range");
571             return (value, offset);
572         } else if (v == 0xFE) {
573             // return NextUint32(buff, offset);
574             (value, offset) = NextUint32(buff, offset);
575             require(value > 0xFFFF && value <= 0xFFFFFFFF, "NextVarUint, value outside range");
576             return (value, offset);
577         } else if (v == 0xFF) {
578             // return NextUint64(buff, offset);
579             (value, offset) = NextUint64(buff, offset);
580             require(value > 0xFFFFFFFF, "NextVarUint, value outside range");
581             return (value, offset);
582         } else{
583             // return (uint8(v), offset);
584             value = uint8(v);
585             require(value < 0xFD, "NextVarUint, value outside range");
586             return (value, offset);
587         }
588     }
589 }
590 library Utils {
591 
592     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
593     *  @param _bs   Source bytes array
594     *  @return      bytes32
595     */
596     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
597         require(_bs.length == 32, "bytes length is not 32.");
598         assembly {
599             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
600             value := mload(add(_bs, 0x20))
601         }
602     }
603 
604     /* @notice      Convert bytes to uint256
605     *  @param _b    Source bytes should have length of 32
606     *  @return      uint256
607     */
608     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
609         require(_bs.length == 32, "bytes length is not 32.");
610         assembly {
611             // load 32 bytes from memory starting from position _bs + 32
612             value := mload(add(_bs, 0x20))
613         }
614         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
615     }
616 
617     /* @notice      Convert uint256 to bytes
618     *  @param _b    uint256 that needs to be converted
619     *  @return      bytes
620     */
621     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
622         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
623         assembly {
624             // Get a location of some free memory and store it in result as
625             // Solidity does for memory variables.
626             bs := mload(0x40)
627             // Put 0x20 at the first word, the length of bytes for uint256 value
628             mstore(bs, 0x20)
629             //In the next word, put value in bytes format to the next 32 bytes
630             mstore(add(bs, 0x20), _value)
631             // Update the free-memory pointer by padding our last write location to 32 bytes
632             mstore(0x40, add(bs, 0x40))
633         }
634     }
635 
636     /* @notice      Convert bytes to address
637     *  @param _bs   Source bytes: bytes length must be 20
638     *  @return      Converted address from source bytes
639     */
640     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
641     {
642         require(_bs.length == 20, "bytes length does not match address");
643         assembly {
644             // for _bs, first word store _bs.length, second word store _bs.value
645             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
646             addr := mload(add(_bs, 0x14))
647         }
648 
649     }
650     
651     /* @notice      Convert address to bytes
652     *  @param _addr Address need to be converted
653     *  @return      Converted bytes from address
654     */
655     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
656         assembly {
657             // Get a location of some free memory and store it in result as
658             // Solidity does for memory variables.
659             bs := mload(0x40)
660             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
661             mstore(bs, 0x14)
662             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
663             mstore(add(bs, 0x20), shl(96, _addr))
664             // Update the free-memory pointer by padding our last write location to 32 bytes
665             mstore(0x40, add(bs, 0x40))
666        }
667     }
668 
669     /* @notice          Do hash leaf as the multi-chain does
670     *  @param _data     Data in bytes format
671     *  @return          Hashed value in bytes32 format
672     */
673     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
674         result = sha256(abi.encodePacked(byte(0x0), _data));
675     }
676 
677     /* @notice          Do hash children as the multi-chain does
678     *  @param _l        Left node
679     *  @param _r        Right node
680     *  @return          Hashed value in bytes32 format
681     */
682     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
683         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
684     }
685 
686     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
687                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
688     *  @param _preBytes     The bytes stored in storage
689     *  @param _postBytes    The bytes stored in memory
690     *  @return              Bool type indicating if they are equal
691     */
692     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
693         bool success = true;
694 
695         assembly {
696             // we know _preBytes_offset is 0
697             let fslot := sload(_preBytes_slot)
698             // Arrays of 31 bytes or less have an even value in their slot,
699             // while longer arrays have an odd value. The actual length is
700             // the slot divided by two for odd values, and the lowest order
701             // byte divided by two for even values.
702             // If the slot is even, bitwise and the slot with 255 and divide by
703             // two to get the length. If the slot is odd, bitwise and the slot
704             // with -1 and divide by two.
705             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
706             let mlength := mload(_postBytes)
707 
708             // if lengths don't match the arrays are not equal
709             switch eq(slength, mlength)
710             case 1 {
711                 // fslot can contain both the length and contents of the array
712                 // if slength < 32 bytes so let's prepare for that
713                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
714                 // slength != 0
715                 if iszero(iszero(slength)) {
716                     switch lt(slength, 32)
717                     case 1 {
718                         // blank the last byte which is the length
719                         fslot := mul(div(fslot, 0x100), 0x100)
720 
721                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
722                             // unsuccess:
723                             success := 0
724                         }
725                     }
726                     default {
727                         // cb is a circuit breaker in the for loop since there's
728                         //  no said feature for inline assembly loops
729                         // cb = 1 - don't breaker
730                         // cb = 0 - break
731                         let cb := 1
732 
733                         // get the keccak hash to get the contents of the array
734                         mstore(0x0, _preBytes_slot)
735                         let sc := keccak256(0x0, 0x20)
736 
737                         let mc := add(_postBytes, 0x20)
738                         let end := add(mc, mlength)
739 
740                         // the next line is the loop condition:
741                         // while(uint(mc < end) + cb == 2)
742                         for {} eq(add(lt(mc, end), cb), 2) {
743                             sc := add(sc, 1)
744                             mc := add(mc, 0x20)
745                         } {
746                             if iszero(eq(sload(sc), mload(mc))) {
747                                 // unsuccess:
748                                 success := 0
749                                 cb := 0
750                             }
751                         }
752                     }
753                 }
754             }
755             default {
756                 // unsuccess:
757                 success := 0
758             }
759         }
760 
761         return success;
762     }
763 
764     /* @notice              Slice the _bytes from _start index till the result has length of _length
765                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
766     *  @param _bytes        The original bytes needs to be sliced
767     *  @param _start        The index of _bytes for the start of sliced bytes
768     *  @param _length       The index of _bytes for the end of sliced bytes
769     *  @return              The sliced bytes
770     */
771     function slice(
772         bytes memory _bytes,
773         uint _start,
774         uint _length
775     )
776         internal
777         pure
778         returns (bytes memory)
779     {
780         require(_bytes.length >= (_start + _length));
781 
782         bytes memory tempBytes;
783 
784         assembly {
785             switch iszero(_length)
786             case 0 {
787                 // Get a location of some free memory and store it in tempBytes as
788                 // Solidity does for memory variables.
789                 tempBytes := mload(0x40)
790 
791                 // The first word of the slice result is potentially a partial
792                 // word read from the original array. To read it, we calculate
793                 // the length of that partial word and start copying that many
794                 // bytes into the array. The first word we copy will start with
795                 // data we don't care about, but the last `lengthmod` bytes will
796                 // land at the beginning of the contents of the new array. When
797                 // we're done copying, we overwrite the full first word with
798                 // the actual length of the slice.
799                 // lengthmod <= _length % 32
800                 let lengthmod := and(_length, 31)
801 
802                 // The multiplication in the next line is necessary
803                 // because when slicing multiples of 32 bytes (lengthmod == 0)
804                 // the following copy loop was copying the origin's length
805                 // and then ending prematurely not copying everything it should.
806                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
807                 let end := add(mc, _length)
808 
809                 for {
810                     // The multiplication in the next line has the same exact purpose
811                     // as the one above.
812                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
813                 } lt(mc, end) {
814                     mc := add(mc, 0x20)
815                     cc := add(cc, 0x20)
816                 } {
817                     mstore(mc, mload(cc))
818                 }
819 
820                 mstore(tempBytes, _length)
821 
822                 //update free-memory pointer
823                 //allocating the array padded to 32 bytes like the compiler does now
824                 mstore(0x40, and(add(mc, 31), not(31)))
825             }
826             //if we want a zero-length slice let's just return a zero-length array
827             default {
828                 tempBytes := mload(0x40)
829 
830                 mstore(0x40, add(tempBytes, 0x20))
831             }
832         }
833 
834         return tempBytes;
835     }
836     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
837     *  @param _keepers      The array consists of serveral address
838     *  @param _signers      Some specific addresses to be looked into
839     *  @param _m            The number requirement paramter
840     *  @return              True means containment, false meansdo do not contain.
841     */
842     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
843         uint m = 0;
844         for(uint i = 0; i < _signers.length; i++){
845             for (uint j = 0; j < _keepers.length; j++) {
846                 if (_signers[i] == _keepers[j]) {
847                     m++;
848                     delete _keepers[j];
849                 }
850             }
851         }
852         return m >= _m;
853     }
854 
855     /* @notice              TODO
856     *  @param key
857     *  @return
858     */
859     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
860          require(key.length >= 67, "key lenggh is too short");
861          newkey = slice(key, 0, 35);
862          if (uint8(key[66]) % 2 == 0){
863              newkey[2] = byte(0x02);
864          } else {
865              newkey[2] = byte(0x03);
866          }
867          return newkey;
868     }
869     
870     /**
871      * @dev Returns true if `account` is a contract.
872      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
873      *
874      * This test is non-exhaustive, and there may be false-negatives: during the
875      * execution of a contract's constructor, its address will be reported as
876      * not containing a contract.
877      *
878      * IMPORTANT: It is unsafe to assume that an address for which this
879      * function returns false is an externally-owned account (EOA) and not a
880      * contract.
881      */
882     function isContract(address account) internal view returns (bool) {
883         // This method relies in extcodesize, which returns 0 for contracts in
884         // construction, since the code is only stored at the end of the
885         // constructor execution.
886 
887         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
888         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
889         // for accounts without code, i.e. `keccak256('')`
890         bytes32 codehash;
891         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
892         // solhint-disable-next-line no-inline-assembly
893         assembly { codehash := extcodehash(account) }
894         return (codehash != 0x0 && codehash != accountHash);
895     }
896 }
897 library SafeERC20 {
898     using SafeMath for uint256;
899 
900     function safeTransfer(IERC20 token, address to, uint256 value) internal {
901         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
902     }
903 
904     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
905         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
906     }
907 
908     function safeApprove(IERC20 token, address spender, uint256 value) internal {
909         // safeApprove should only be called when setting an initial allowance,
910         // or when resetting it to zero. To increase and decrease it, use
911         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
912         // solhint-disable-next-line max-line-length
913         require((value == 0) || (token.allowance(address(this), spender) == 0),
914             "SafeERC20: approve from non-zero to non-zero allowance"
915         );
916         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
917     }
918 
919     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
920         uint256 newAllowance = token.allowance(address(this), spender).add(value);
921         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
922     }
923 
924     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
925         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
926         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
927     }
928 
929     /**
930      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
931      * on the return value: the return value is optional (but if data is returned, it must not be false).
932      * @param token The token targeted by the call.
933      * @param data The call data (encoded using abi.encode or one of its variants).
934      */
935     function callOptionalReturn(IERC20 token, bytes memory data) private {
936         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
937         // we're implementing it ourselves.
938 
939         // A Solidity high level call has three parts:
940         //  1. The target address is checked to verify it contains contract code
941         //  2. The call itself is made, and success asserted
942         //  3. The return value is decoded, which in turn checks the size of the returned data.
943         // solhint-disable-next-line max-line-length
944         require(Utils.isContract(address(token)), "SafeERC20: call to non-contract");
945 
946         // solhint-disable-next-line avoid-low-level-calls
947         (bool success, bytes memory returndata) = address(token).call(data);
948         require(success, "SafeERC20: low-level call failed");
949 
950         if (returndata.length > 0) { // Return data is optional
951             // solhint-disable-next-line max-line-length
952             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
953         }
954     }
955 }
956 contract Context {
957     // Empty internal constructor, to prevent people from mistakenly deploying
958     // an instance of this contract, which should be used via inheritance.
959     constructor () internal { }
960     // solhint-disable-previous-line no-empty-blocks
961 
962     function _msgSender() internal view returns (address payable) {
963         return msg.sender;
964     }
965 
966     function _msgData() internal view returns (bytes memory) {
967         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
968         return msg.data;
969     }
970 }
971 contract Pausable is Context {
972     /**
973      * @dev Emitted when the pause is triggered by a pauser (`account`).
974      */
975     event Paused(address account);
976 
977     /**
978      * @dev Emitted when the pause is lifted by a pauser (`account`).
979      */
980     event Unpaused(address account);
981 
982     bool private _paused;
983 
984     /**
985      * @dev Initializes the contract in unpaused state.
986      */
987     constructor () internal {
988         _paused = false;
989     }
990 
991     /**
992      * @dev Returns true if the contract is paused, and false otherwise.
993      */
994     function paused() public view returns (bool) {
995         return _paused;
996     }
997 
998     /**
999      * @dev Modifier to make a function callable only when the contract is not paused.
1000      */
1001     modifier whenNotPaused() {
1002         require(!_paused, "Pausable: paused");
1003         _;
1004     }
1005 
1006     /**
1007      * @dev Modifier to make a function callable only when the contract is paused.
1008      */
1009     modifier whenPaused() {
1010         require(_paused, "Pausable: not paused");
1011         _;
1012     }
1013 
1014     /**
1015      * @dev Called to pause, triggers stopped state.
1016      */
1017     function _pause() internal whenNotPaused {
1018         _paused = true;
1019         emit Paused(_msgSender());
1020     }
1021 
1022     /**
1023      * @dev Called to unpause, returns to normal state.
1024      */
1025     function _unpause() internal whenPaused {
1026         _paused = false;
1027         emit Unpaused(_msgSender());
1028     }
1029 }
1030 contract Ownable is Context {
1031     address private _owner;
1032 
1033     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1034 
1035     /**
1036      * @dev Initializes the contract setting the deployer as the initial owner.
1037      */
1038     constructor () internal {
1039         address msgSender = _msgSender();
1040         _owner = msgSender;
1041         emit OwnershipTransferred(address(0), msgSender);
1042     }
1043 
1044     /**
1045      * @dev Returns the address of the current owner.
1046      */
1047     function owner() public view returns (address) {
1048         return _owner;
1049     }
1050 
1051     /**
1052      * @dev Throws if called by any account other than the owner.
1053      */
1054     modifier onlyOwner() {
1055         require(isOwner(), "Ownable: caller is not the owner");
1056         _;
1057     }
1058 
1059     /**
1060      * @dev Returns true if the caller is the current owner.
1061      */
1062     function isOwner() public view returns (bool) {
1063         return _msgSender() == _owner;
1064     }
1065 
1066     /**
1067      * @dev Leaves the contract without owner. It will not be possible to call
1068      * `onlyOwner` functions anymore. Can only be called by the current owner.
1069      *
1070      * NOTE: Renouncing ownership will leave the contract without an owner,
1071      * thereby removing any functionality that is only available to the owner.
1072      */
1073     function renounceOwnership() public onlyOwner {
1074         emit OwnershipTransferred(_owner, address(0));
1075         _owner = address(0);
1076     }
1077 
1078     /**
1079      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1080      * Can only be called by the current owner.
1081      */
1082     function transferOwnership(address newOwner) public  onlyOwner {
1083         _transferOwnership(newOwner);
1084     }
1085 
1086     /**
1087      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1088      */
1089     function _transferOwnership(address newOwner) internal {
1090         require(newOwner != address(0), "Ownable: new owner is the zero address");
1091         emit OwnershipTransferred(_owner, newOwner);
1092         _owner = newOwner;
1093     }
1094 }
1095 contract ReentrancyGuard {
1096     bool private _notEntered;
1097 
1098     constructor () internal {
1099         // Storing an initial non-zero value makes deployment a bit more
1100         // expensive, but in exchange the refund on every call to nonReentrant
1101         // will be lower in amount. Since refunds are capped to a percetange of
1102         // the total transaction's gas, it is best to keep them low in cases
1103         // like this one, to increase the likelihood of the full refund coming
1104         // into effect.
1105         _notEntered = true;
1106     }
1107 
1108     /**
1109      * @dev Prevents a contract from calling itself, directly or indirectly.
1110      * Calling a `nonReentrant` function from another `nonReentrant`
1111      * function is not supported. It is possible to prevent this from happening
1112      * by making the `nonReentrant` function external, and make it call a
1113      * `private` function that does the actual work.
1114      */
1115     modifier nonReentrant() {
1116         // On the first call to nonReentrant, _notEntered will be true
1117         require(_notEntered, "ReentrancyGuard: reentrant call");
1118 
1119         // Any calls to nonReentrant after this point will fail
1120         _notEntered = false;
1121 
1122         _;
1123 
1124         // By storing the original value once again, a refund is triggered (see
1125         // https://eips.ethereum.org/EIPS/eip-2200)
1126         _notEntered = true;
1127     }
1128 }
1129 interface IERC20 {
1130     /**
1131      * @dev Returns the amount of tokens in existence.
1132      */
1133     function totalSupply() external view returns (uint256);
1134 
1135     /**
1136      * @dev Returns the amount of tokens owned by `account`.
1137      */
1138     function balanceOf(address account) external view returns (uint256);
1139 
1140     /**
1141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1142      *
1143      * Returns a boolean value indicating whether the operation succeeded.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function transfer(address recipient, uint256 amount) external returns (bool);
1148 
1149     /**
1150      * @dev Returns the remaining number of tokens that `spender` will be
1151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1152      * zero by default.
1153      *
1154      * This value changes when {approve} or {transferFrom} are called.
1155      */
1156     function allowance(address owner, address spender) external view returns (uint256);
1157 
1158     /**
1159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1160      *
1161      * Returns a boolean value indicating whether the operation succeeded.
1162      *
1163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1164      * that someone may use both the old and the new allowance by unfortunate
1165      * transaction ordering. One possible solution to mitigate this race
1166      * condition is to first reduce the spender's allowance to 0 and set the
1167      * desired value afterwards:
1168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1169      *
1170      * Emits an {Approval} event.
1171      */
1172     function approve(address spender, uint256 amount) external returns (bool);
1173 
1174     /**
1175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1176      * allowance mechanism. `amount` is then deducted from the caller's
1177      * allowance.
1178      *
1179      * Returns a boolean value indicating whether the operation succeeded.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1184 
1185     /**
1186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1187      * another (`to`).
1188      *
1189      * Note that `value` may be zero.
1190      */
1191     event Transfer(address indexed from, address indexed to, uint256 value);
1192 
1193     /**
1194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1195      * a call to {approve}. `value` is the new allowance.
1196      */
1197     event Approval(address indexed owner, address indexed spender, uint256 value);
1198 }
1199 interface IEthCrossChainManager {
1200     function crossChain(uint64 _toChainId, bytes calldata _toContract, bytes calldata _method, bytes calldata _txData) external returns (bool);
1201 }
1202 interface IEthCrossChainManagerProxy {
1203     function getEthCrossChainManager() external view returns (address);
1204 }
1205 interface IWETH {
1206     function deposit() external payable;
1207     function transfer(address to, uint value) external returns (bool);
1208     function withdraw(uint) external;
1209 }
1210 
1211 contract Swapper is Ownable, Pausable, ReentrancyGuard {
1212     using SafeMath for uint;
1213     using SafeERC20 for IERC20;
1214 
1215     struct TxArgs {
1216         uint amount;
1217         uint minOut;
1218         uint64 toPoolId;
1219         uint64 toChainId;
1220         bytes fromAssetHash;
1221         bytes fromAddress;
1222         bytes toAssetHash;
1223         bytes toAddress;
1224     }
1225     
1226     address public WETH;
1227     address public feeCollector;
1228     address public lockProxyAddress;
1229     address public managerProxyContract;
1230     bytes public swapProxyHash;
1231     uint64 public swapChainId;
1232     uint64 public chainId;
1233    
1234     mapping(bytes => mapping(uint64 => bool)) public assetInPool;
1235     mapping(uint64 => address) public poolTokenMap;
1236 
1237     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
1238     event SwapEvent(address fromAssetHash, address fromAddress, uint64 toPoolId, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint amount,uint fee, uint id);
1239     event AddLiquidityEvent(address fromAssetHash, address fromAddress,  uint64 toPoolId, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint amount, uint fee, uint id);
1240     event RemoveLiquidityEvent(address fromAssetHash, address fromAddress,  uint64 toPoolId, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint amount, uint fee, uint id);
1241     
1242     constructor(address _owner, uint64 _chainId, uint64 _swapChianId, address _lockProxy, address _CCMP, address _weth, bytes memory _swapProxyHash) public {
1243         require(_chainId != 0, "!legal");
1244         transferOwnership(_owner);
1245         chainId = _chainId;
1246         lockProxyAddress = _lockProxy;
1247         managerProxyContract = _CCMP;
1248         WETH = _weth;
1249         swapProxyHash = _swapProxyHash;
1250         swapChainId = _swapChianId;
1251     }
1252 
1253     modifier onlyManagerContract() {
1254         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
1255         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
1256         _;
1257     }
1258 
1259     function pause() external onlyOwner {
1260         _pause();
1261     }
1262 
1263     function unpause() external onlyOwner {
1264         _unpause();
1265     }
1266     
1267     function setFeeCollector(address collector) external onlyOwner {
1268         require(collector != address(0), "emtpy address");
1269         feeCollector = collector;
1270     }
1271 
1272     function setLockProxy(address _lockProxy) external onlyOwner {
1273         require(_lockProxy != address(0), "emtpy address");
1274         lockProxyAddress = _lockProxy;
1275     }
1276     
1277     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
1278         managerProxyContract = ethCCMProxyAddr;
1279     }
1280     
1281     function setSwapProxyHash(bytes memory swapProxyAddr) onlyOwner public {
1282         swapProxyHash = swapProxyAddr;
1283     }
1284     
1285     function setSwapChainId(uint64 _swapChianId) onlyOwner public {
1286         swapChainId = _swapChianId;
1287     }
1288     
1289     function setWETH(address _weth) external onlyOwner {
1290         WETH = _weth;
1291     }
1292     
1293     function bindAssetAndPool(bytes memory fromAssetHash, uint64 poolId) onlyOwner public returns (bool) {
1294         assetInPool[fromAssetHash][poolId] = true;
1295         return true;
1296     }
1297     
1298     function bind3Asset(bytes memory asset1, bytes memory asset2, bytes memory asset3, uint64 poolId) onlyOwner public {
1299         assetInPool[asset1][poolId] = true;
1300         assetInPool[asset2][poolId] = true;
1301         assetInPool[asset3][poolId] = true;
1302     }
1303     
1304     function registerPoolWith3Assets(uint64 poolId, address poolTokenAddress, bytes memory asset1, bytes memory asset2, bytes memory asset3) onlyOwner public {
1305         poolTokenMap[poolId] = poolTokenAddress;
1306         assetInPool[asset1][poolId] = true;
1307         assetInPool[asset2][poolId] = true;
1308         assetInPool[asset3][poolId] = true;
1309     }
1310     
1311     function registerPool(uint64 poolId, address poolTokenAddress) onlyOwner public returns (bool) {
1312         poolTokenMap[poolId] = poolTokenAddress;
1313         return true;
1314     }
1315     
1316     function extractFee(address token) external {
1317         require(msg.sender == feeCollector, "!feeCollector");
1318         if (token == address(0)) {
1319             msg.sender.transfer(address(this).balance);
1320         } else {
1321             IERC20(token).safeTransfer(feeCollector, IERC20(token).balanceOf(address(this)));
1322         }
1323     }
1324     
1325     function swap(address fromAssetHash, uint64 toPoolId, uint64 toChainId, bytes memory toAssetHash, bytes memory toAddress, uint amount, uint minOutAmount, uint fee, uint id) public payable nonReentrant whenNotPaused returns (bool) {
1326         _pull(fromAssetHash, amount);
1327     
1328         amount = _checkoutFee(fromAssetHash, amount, fee);
1329         
1330         _push(fromAssetHash, amount);
1331 
1332         fromAssetHash = fromAssetHash==address(0) ? WETH : fromAssetHash ; 
1333         require(poolTokenMap[toPoolId] != address(0), "given pool do not exsit");
1334         require(assetInPool[Utils.addressToBytes(fromAssetHash)][toPoolId],"input token not in given pool");
1335         require(assetInPool[toAssetHash][toPoolId],"output token not in given pool");
1336         require(toAddress.length !=0, "empty toAddress");
1337         address addr;
1338         assembly { addr := mload(add(toAddress,0x14)) }
1339         require(addr != address(0),"zero toAddress");
1340          
1341         {
1342             TxArgs memory txArgs = TxArgs({
1343                 amount: amount,
1344                 minOut: minOutAmount,
1345                 toPoolId: toPoolId,
1346                 toChainId: toChainId,
1347                 fromAssetHash: Utils.addressToBytes(fromAssetHash),
1348                 fromAddress: Utils.addressToBytes(_msgSender()),
1349                 toAssetHash: toAssetHash,
1350                 toAddress: toAddress
1351             });
1352             bytes memory txData = _serializeTxArgs(txArgs);
1353             
1354             address eccmAddr = IEthCrossChainManagerProxy(managerProxyContract).getEthCrossChainManager();
1355             IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
1356             
1357             require(eccm.crossChain(swapChainId, swapProxyHash, "swap", txData), "EthCrossChainManager crossChain executed error!");
1358         }
1359         
1360         emit LockEvent(fromAssetHash, _msgSender(), swapChainId, Utils.addressToBytes(address(0)), swapProxyHash, amount);
1361         emit SwapEvent(fromAssetHash, _msgSender(), toPoolId, toChainId, toAssetHash, toAddress, amount, fee, id);
1362         
1363         return true;
1364     }
1365     
1366     function add_liquidity(address fromAssetHash, uint64 toPoolId, uint64 toChainId, bytes memory toAddress, uint amount, uint minOutAmount, uint fee, uint id) public payable nonReentrant whenNotPaused returns (bool) {
1367         _pull(fromAssetHash, amount);
1368             
1369         amount = _checkoutFee(fromAssetHash, amount, fee);
1370         
1371         _push(fromAssetHash, amount);
1372 
1373         fromAssetHash = fromAssetHash==address(0) ? WETH : fromAssetHash ;   
1374         require(poolTokenMap[toPoolId] != address(0), "given pool do not exsit");
1375         require(assetInPool[Utils.addressToBytes(fromAssetHash)][toPoolId],"input token not in given pool");
1376         require(toAddress.length !=0, "empty toAddress");
1377         address addr;
1378         assembly { addr := mload(add(toAddress,0x14)) }
1379         require(addr != address(0),"zero toAddress");
1380         
1381         {
1382             TxArgs memory txArgs = TxArgs({
1383                 amount: amount,
1384                 minOut: minOutAmount,
1385                 toPoolId: toPoolId,
1386                 toChainId: toChainId,
1387                 fromAssetHash: Utils.addressToBytes(fromAssetHash),
1388                 fromAddress: Utils.addressToBytes(_msgSender()),
1389                 toAssetHash: Utils.addressToBytes(address(0)),
1390                 toAddress: toAddress
1391             });
1392             bytes memory txData = _serializeTxArgs(txArgs);
1393             
1394             address eccmAddr = IEthCrossChainManagerProxy(managerProxyContract).getEthCrossChainManager();
1395             IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
1396             
1397             require(eccm.crossChain(swapChainId, swapProxyHash, "add", txData), "EthCrossChainManager crossChain executed error!");
1398         }
1399 
1400         emit LockEvent(fromAssetHash, _msgSender(), swapChainId, Utils.addressToBytes(address(0)), swapProxyHash, amount);
1401         emit AddLiquidityEvent(fromAssetHash, _msgSender(), toPoolId, toChainId, Utils.addressToBytes(address(0)), toAddress, amount, fee, id);
1402         
1403         return true;
1404     }
1405     
1406     function remove_liquidity(address fromAssetHash, uint64 toPoolId, uint64 toChainId, bytes memory toAssetHash, bytes memory toAddress, uint amount, uint minOutAmount, uint fee, uint id) public payable nonReentrant whenNotPaused returns (bool) {
1407         _pull(fromAssetHash, amount);
1408     
1409         amount = _checkoutFee(fromAssetHash, amount, fee);
1410         
1411         _push(fromAssetHash, amount);
1412             
1413         fromAssetHash = fromAssetHash==address(0) ? WETH : fromAssetHash ; 
1414         require(poolTokenMap[toPoolId] != address(0), "given pool do not exsit");
1415         require(poolTokenMap[toPoolId] == fromAssetHash,"input token is not pool LP token");
1416         require(assetInPool[toAssetHash][toPoolId],"output token not in given pool");
1417         require(toAddress.length !=0, "empty toAddress");
1418         address addr;
1419         assembly { addr := mload(add(toAddress,0x14)) }
1420         require(addr != address(0),"zero toAddress");
1421         
1422         {
1423             TxArgs memory txArgs = TxArgs({
1424                 amount: amount,
1425                 minOut: minOutAmount,
1426                 toPoolId: toPoolId,
1427                 toChainId: toChainId,
1428                 fromAssetHash: Utils.addressToBytes(fromAssetHash),
1429                 fromAddress: Utils.addressToBytes(_msgSender()),
1430                 toAssetHash: toAssetHash,
1431                 toAddress: toAddress
1432             });
1433             bytes memory txData = _serializeTxArgs(txArgs);
1434             
1435             address eccmAddr = IEthCrossChainManagerProxy(managerProxyContract).getEthCrossChainManager();
1436             IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
1437             
1438             require(eccm.crossChain(swapChainId, swapProxyHash, "remove", txData), "EthCrossChainManager crossChain executed error!");
1439         }
1440         
1441         emit LockEvent(fromAssetHash, _msgSender(), swapChainId, Utils.addressToBytes(address(0)), swapProxyHash, amount);
1442         emit RemoveLiquidityEvent(fromAssetHash, _msgSender(), toPoolId, toChainId, toAssetHash, toAddress, amount, fee, id);
1443         
1444         return true;
1445     }
1446     
1447     function getBalanceFor(address fromAssetHash) public view returns (uint256) {
1448         if (fromAssetHash == address(0)) {
1449             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
1450             address selfAddr = address(this);
1451             return selfAddr.balance;
1452         } else {
1453             IERC20 erc20Token = IERC20(fromAssetHash);
1454             return erc20Token.balanceOf(address(this));
1455         }
1456     }
1457     
1458     // take input
1459     function _pull(address fromAsset, uint amount) internal {
1460         if (fromAsset == address(0)) {
1461             require(msg.value == amount, "insufficient ether");
1462         } else {
1463             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
1464         }
1465     }
1466     
1467     // take fee in the form of ether
1468     function _checkoutFee(address fromAsset, uint amount, uint fee) internal view returns (uint) {
1469         if (fromAsset == address(0)) {
1470             require(msg.value == amount, "insufficient ether");
1471             require(amount > fee, "amount less than fee");
1472             return amount.sub(fee);
1473         } else {
1474             require(msg.value == fee, "insufficient ether");
1475             return amount;
1476         }
1477     }
1478     
1479     // lock money in LockProxy, ether store in swapper 
1480     function _push(address fromAsset, uint amount) internal {
1481         if (fromAsset == address(0)) {
1482             // TODO: send ether to LockProxy, ** LockProxy do not have receive(),cannot send ether now
1483             IWETH(WETH).deposit{value: amount}();
1484             IWETH(WETH).transfer(lockProxyAddress, amount);
1485         } else {
1486             IERC20(fromAsset).safeTransfer(lockProxyAddress, amount);
1487         }
1488     }
1489     
1490     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
1491         bytes memory buff;
1492         buff = abi.encodePacked(
1493             ZeroCopySink.WriteUint255(args.amount),
1494             ZeroCopySink.WriteUint255(args.minOut),
1495             ZeroCopySink.WriteUint64(args.toPoolId),
1496             ZeroCopySink.WriteUint64(args.toChainId),
1497             ZeroCopySink.WriteVarBytes(args.fromAssetHash),
1498             ZeroCopySink.WriteVarBytes(args.fromAddress),
1499             ZeroCopySink.WriteVarBytes(args.toAssetHash),
1500             ZeroCopySink.WriteVarBytes(args.toAddress)
1501             );
1502         return buff;
1503     }
1504 
1505 }