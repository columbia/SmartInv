1 pragma solidity ^0.5.0;
2 pragma experimental ABIEncoderV2;
3 
4 contract Context {
5     // Empty internal constructor, to prevent people from mistakenly deploying
6     // an instance of this contract, which should be used via inheritance.
7     constructor () internal { }
8     // solhint-disable-previous-line no-empty-blocks
9 
10     function _msgSender() internal view returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 contract Ownable is Context {
21     address private _owner;
22 
23     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
24 
25     /**
26      * @dev Initializes the contract setting the deployer as the initial owner.
27      */
28     constructor () internal {
29         address msgSender = _msgSender();
30         _owner = msgSender;
31         emit OwnershipTransferred(address(0), msgSender);
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(isOwner(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Returns true if the caller is the current owner.
51      */
52     function isOwner() public view returns (bool) {
53         return _msgSender() == _owner;
54     }
55 
56     /**
57      * @dev Leaves the contract without owner. It will not be possible to call
58      * `onlyOwner` functions anymore. Can only be called by the current owner.
59      *
60      * NOTE: Renouncing ownership will leave the contract without an owner,
61      * thereby removing any functionality that is only available to the owner.
62      */
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 
68     /**
69      * @dev Transfers ownership of the contract to a new account (`newOwner`).
70      * Can only be called by the current owner.
71      */
72     function transferOwnership(address newOwner) public  onlyOwner {
73         _transferOwnership(newOwner);
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      */
79     function _transferOwnership(address newOwner) internal {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 contract Pausable is Context {
87     /**
88      * @dev Emitted when the pause is triggered by a pauser (`account`).
89      */
90     event Paused(address account);
91 
92     /**
93      * @dev Emitted when the pause is lifted by a pauser (`account`).
94      */
95     event Unpaused(address account);
96 
97     bool private _paused;
98 
99     /**
100      * @dev Initializes the contract in unpaused state.
101      */
102     constructor () internal {
103         _paused = false;
104     }
105 
106     /**
107      * @dev Returns true if the contract is paused, and false otherwise.
108      */
109     function paused() public view returns (bool) {
110         return _paused;
111     }
112 
113     /**
114      * @dev Modifier to make a function callable only when the contract is not paused.
115      */
116     modifier whenNotPaused() {
117         require(!_paused, "Pausable: paused");
118         _;
119     }
120 
121     /**
122      * @dev Modifier to make a function callable only when the contract is paused.
123      */
124     modifier whenPaused() {
125         require(_paused, "Pausable: not paused");
126         _;
127     }
128 
129     /**
130      * @dev Called to pause, triggers stopped state.
131      */
132     function _pause() internal whenNotPaused {
133         _paused = true;
134         emit Paused(_msgSender());
135     }
136 
137     /**
138      * @dev Called to unpause, returns to normal state.
139      */
140     function _unpause() internal whenPaused {
141         _paused = false;
142         emit Unpaused(_msgSender());
143     }
144 }
145 
146 library ZeroCopySink {
147     /* @notice          Convert boolean value into bytes
148     *  @param b         The boolean value
149     *  @return          Converted bytes array
150     */
151     function WriteBool(bool b) internal pure returns (bytes memory) {
152         bytes memory buff;
153         assembly{
154             buff := mload(0x40)
155             mstore(buff, 1)
156             switch iszero(b)
157             case 1 {
158                 mstore(add(buff, 0x20), shl(248, 0x00))
159                 // mstore8(add(buff, 0x20), 0x00)
160             }
161             default {
162                 mstore(add(buff, 0x20), shl(248, 0x01))
163                 // mstore8(add(buff, 0x20), 0x01)
164             }
165             mstore(0x40, add(buff, 0x21))
166         }
167         return buff;
168     }
169 
170     /* @notice          Convert byte value into bytes
171     *  @param b         The byte value
172     *  @return          Converted bytes array
173     */
174     function WriteByte(byte b) internal pure returns (bytes memory) {
175         return WriteUint8(uint8(b));
176     }
177 
178     /* @notice          Convert uint8 value into bytes
179     *  @param v         The uint8 value
180     *  @return          Converted bytes array
181     */
182     function WriteUint8(uint8 v) internal pure returns (bytes memory) {
183         bytes memory buff;
184         assembly{
185             buff := mload(0x40)
186             mstore(buff, 1)
187             mstore(add(buff, 0x20), shl(248, v))
188             // mstore(add(buff, 0x20), byte(0x1f, v))
189             mstore(0x40, add(buff, 0x21))
190         }
191         return buff;
192     }
193 
194     /* @notice          Convert uint16 value into bytes
195     *  @param v         The uint16 value
196     *  @return          Converted bytes array
197     */
198     function WriteUint16(uint16 v) internal pure returns (bytes memory) {
199         bytes memory buff;
200 
201         assembly{
202             buff := mload(0x40)
203             let byteLen := 0x02
204             mstore(buff, byteLen)
205             for {
206                 let mindex := 0x00
207                 let vindex := 0x1f
208             } lt(mindex, byteLen) {
209                 mindex := add(mindex, 0x01)
210                 vindex := sub(vindex, 0x01)
211             }{
212                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
213             }
214             mstore(0x40, add(buff, 0x22))
215         }
216         return buff;
217     }
218     
219     /* @notice          Convert uint32 value into bytes
220     *  @param v         The uint32 value
221     *  @return          Converted bytes array
222     */
223     function WriteUint32(uint32 v) internal pure returns(bytes memory) {
224         bytes memory buff;
225         assembly{
226             buff := mload(0x40)
227             let byteLen := 0x04
228             mstore(buff, byteLen)
229             for {
230                 let mindex := 0x00
231                 let vindex := 0x1f
232             } lt(mindex, byteLen) {
233                 mindex := add(mindex, 0x01)
234                 vindex := sub(vindex, 0x01)
235             }{
236                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
237             }
238             mstore(0x40, add(buff, 0x24))
239         }
240         return buff;
241     }
242 
243     /* @notice          Convert uint64 value into bytes
244     *  @param v         The uint64 value
245     *  @return          Converted bytes array
246     */
247     function WriteUint64(uint64 v) internal pure returns(bytes memory) {
248         bytes memory buff;
249 
250         assembly{
251             buff := mload(0x40)
252             let byteLen := 0x08
253             mstore(buff, byteLen)
254             for {
255                 let mindex := 0x00
256                 let vindex := 0x1f
257             } lt(mindex, byteLen) {
258                 mindex := add(mindex, 0x01)
259                 vindex := sub(vindex, 0x01)
260             }{
261                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
262             }
263             mstore(0x40, add(buff, 0x28))
264         }
265         return buff;
266     }
267 
268     /* @notice          Convert limited uint256 value into bytes
269     *  @param v         The uint256 value
270     *  @return          Converted bytes array
271     */
272     function WriteUint255(uint256 v) internal pure returns (bytes memory) {
273         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds uint255 range");
274         bytes memory buff;
275 
276         assembly{
277             buff := mload(0x40)
278             let byteLen := 0x20
279             mstore(buff, byteLen)
280             for {
281                 let mindex := 0x00
282                 let vindex := 0x1f
283             } lt(mindex, byteLen) {
284                 mindex := add(mindex, 0x01)
285                 vindex := sub(vindex, 0x01)
286             }{
287                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
288             }
289             mstore(0x40, add(buff, 0x40))
290         }
291         return buff;
292     }
293 
294     /* @notice          Encode bytes format data into bytes
295     *  @param data      The bytes array data
296     *  @return          Encoded bytes array
297     */
298     function WriteVarBytes(bytes memory data) internal pure returns (bytes memory) {
299         uint64 l = uint64(data.length);
300         return abi.encodePacked(WriteVarUint(l), data);
301     }
302 
303     function WriteVarUint(uint64 v) internal pure returns (bytes memory) {
304         if (v < 0xFD){
305     		return WriteUint8(uint8(v));
306     	} else if (v <= 0xFFFF) {
307     		return abi.encodePacked(WriteByte(0xFD), WriteUint16(uint16(v)));
308     	} else if (v <= 0xFFFFFFFF) {
309             return abi.encodePacked(WriteByte(0xFE), WriteUint32(uint32(v)));
310     	} else {
311     		return abi.encodePacked(WriteByte(0xFF), WriteUint64(uint64(v)));
312     	}
313     }
314 }
315 
316 library ZeroCopySource {
317     /* @notice              Read next byte as boolean type starting at offset from buff
318     *  @param buff          Source bytes array
319     *  @param offset        The position from where we read the boolean value
320     *  @return              The the read boolean value and new offset
321     */
322     function NextBool(bytes memory buff, uint256 offset) internal pure returns(bool, uint256) {
323         require(offset + 1 <= buff.length && offset < offset + 1, "Offset exceeds limit");
324         // byte === bytes1
325         byte v;
326         assembly{
327             v := mload(add(add(buff, 0x20), offset))
328         }
329         bool value;
330         if (v == 0x01) {
331 		    value = true;
332     	} else if (v == 0x00) {
333             value = false;
334         } else {
335             revert("NextBool value error");
336         }
337         return (value, offset + 1);
338     }
339 
340     /* @notice              Read next byte starting at offset from buff
341     *  @param buff          Source bytes array
342     *  @param offset        The position from where we read the byte value
343     *  @return              The read byte value and new offset
344     */
345     function NextByte(bytes memory buff, uint256 offset) internal pure returns (byte, uint256) {
346         require(offset + 1 <= buff.length && offset < offset + 1, "NextByte, Offset exceeds maximum");
347         byte v;
348         assembly{
349             v := mload(add(add(buff, 0x20), offset))
350         }
351         return (v, offset + 1);
352     }
353 
354     /* @notice              Read next byte as uint8 starting at offset from buff
355     *  @param buff          Source bytes array
356     *  @param offset        The position from where we read the byte value
357     *  @return              The read uint8 value and new offset
358     */
359     function NextUint8(bytes memory buff, uint256 offset) internal pure returns (uint8, uint256) {
360         require(offset + 1 <= buff.length && offset < offset + 1, "NextUint8, Offset exceeds maximum");
361         uint8 v;
362         assembly{
363             let tmpbytes := mload(0x40)
364             let bvalue := mload(add(add(buff, 0x20), offset))
365             mstore8(tmpbytes, byte(0, bvalue))
366             mstore(0x40, add(tmpbytes, 0x01))
367             v := mload(sub(tmpbytes, 0x1f))
368         }
369         return (v, offset + 1);
370     }
371 
372     /* @notice              Read next two bytes as uint16 type starting from offset
373     *  @param buff          Source bytes array
374     *  @param offset        The position from where we read the uint16 value
375     *  @return              The read uint16 value and updated offset
376     */
377     function NextUint16(bytes memory buff, uint256 offset) internal pure returns (uint16, uint256) {
378         require(offset + 2 <= buff.length && offset < offset + 2, "NextUint16, offset exceeds maximum");
379         
380         uint16 v;
381         assembly {
382             let tmpbytes := mload(0x40)
383             let bvalue := mload(add(add(buff, 0x20), offset))
384             mstore8(tmpbytes, byte(0x01, bvalue))
385             mstore8(add(tmpbytes, 0x01), byte(0, bvalue))
386             mstore(0x40, add(tmpbytes, 0x02))
387             v := mload(sub(tmpbytes, 0x1e))
388         }
389         return (v, offset + 2);
390     }
391 
392 
393     /* @notice              Read next four bytes as uint32 type starting from offset
394     *  @param buff          Source bytes array
395     *  @param offset        The position from where we read the uint32 value
396     *  @return              The read uint32 value and updated offset
397     */
398     function NextUint32(bytes memory buff, uint256 offset) internal pure returns (uint32, uint256) {
399         require(offset + 4 <= buff.length && offset < offset + 4, "NextUint32, offset exceeds maximum");
400         uint32 v;
401         assembly {
402             let tmpbytes := mload(0x40)
403             let byteLen := 0x04
404             for {
405                 let tindex := 0x00
406                 let bindex := sub(byteLen, 0x01)
407                 let bvalue := mload(add(add(buff, 0x20), offset))
408             } lt(tindex, byteLen) {
409                 tindex := add(tindex, 0x01)
410                 bindex := sub(bindex, 0x01)
411             }{
412                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
413             }
414             mstore(0x40, add(tmpbytes, byteLen))
415             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
416         }
417         return (v, offset + 4);
418     }
419 
420     /* @notice              Read next eight bytes as uint64 type starting from offset
421     *  @param buff          Source bytes array
422     *  @param offset        The position from where we read the uint64 value
423     *  @return              The read uint64 value and updated offset
424     */
425     function NextUint64(bytes memory buff, uint256 offset) internal pure returns (uint64, uint256) {
426         require(offset + 8 <= buff.length && offset < offset + 8, "NextUint64, offset exceeds maximum");
427         uint64 v;
428         assembly {
429             let tmpbytes := mload(0x40)
430             let byteLen := 0x08
431             for {
432                 let tindex := 0x00
433                 let bindex := sub(byteLen, 0x01)
434                 let bvalue := mload(add(add(buff, 0x20), offset))
435             } lt(tindex, byteLen) {
436                 tindex := add(tindex, 0x01)
437                 bindex := sub(bindex, 0x01)
438             }{
439                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
440             }
441             mstore(0x40, add(tmpbytes, byteLen))
442             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
443         }
444         return (v, offset + 8);
445     }
446 
447     /* @notice              Read next 32 bytes as uint256 type starting from offset,
448                             there are limits considering the numerical limits in multi-chain
449     *  @param buff          Source bytes array
450     *  @param offset        The position from where we read the uint256 value
451     *  @return              The read uint256 value and updated offset
452     */
453     function NextUint255(bytes memory buff, uint256 offset) internal pure returns (uint256, uint256) {
454         require(offset + 32 <= buff.length && offset < offset + 32, "NextUint255, offset exceeds maximum");
455         uint256 v;
456         assembly {
457             let tmpbytes := mload(0x40)
458             let byteLen := 0x20
459             for {
460                 let tindex := 0x00
461                 let bindex := sub(byteLen, 0x01)
462                 let bvalue := mload(add(add(buff, 0x20), offset))
463             } lt(tindex, byteLen) {
464                 tindex := add(tindex, 0x01)
465                 bindex := sub(bindex, 0x01)
466             }{
467                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
468             }
469             mstore(0x40, add(tmpbytes, byteLen))
470             v := mload(tmpbytes)
471         }
472         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
473         return (v, offset + 32);
474     }
475     /* @notice              Read next variable bytes starting from offset,
476                             the decoding rule coming from multi-chain
477     *  @param buff          Source bytes array
478     *  @param offset        The position from where we read the bytes value
479     *  @return              The read variable bytes array value and updated offset
480     */
481     function NextVarBytes(bytes memory buff, uint256 offset) internal pure returns(bytes memory, uint256) {
482         uint len;
483         (len, offset) = NextVarUint(buff, offset);
484         require(offset + len <= buff.length && offset < offset + len, "NextVarBytes, offset exceeds maximum");
485         bytes memory tempBytes;
486         assembly{
487             switch iszero(len)
488             case 0 {
489                 // Get a location of some free memory and store it in tempBytes as
490                 // Solidity does for memory variables.
491                 tempBytes := mload(0x40)
492 
493                 // The first word of the slice result is potentially a partial
494                 // word read from the original array. To read it, we calculate
495                 // the length of that partial word and start copying that many
496                 // bytes into the array. The first word we copy will start with
497                 // data we don't care about, but the last `lengthmod` bytes will
498                 // land at the beginning of the contents of the new array. When
499                 // we're done copying, we overwrite the full first word with
500                 // the actual length of the slice.
501                 let lengthmod := and(len, 31)
502 
503                 // The multiplication in the next line is necessary
504                 // because when slicing multiples of 32 bytes (lengthmod == 0)
505                 // the following copy loop was copying the origin's length
506                 // and then ending prematurely not copying everything it should.
507                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
508                 let end := add(mc, len)
509 
510                 for {
511                     // The multiplication in the next line has the same exact purpose
512                     // as the one above.
513                     let cc := add(add(add(buff, lengthmod), mul(0x20, iszero(lengthmod))), offset)
514                 } lt(mc, end) {
515                     mc := add(mc, 0x20)
516                     cc := add(cc, 0x20)
517                 } {
518                     mstore(mc, mload(cc))
519                 }
520 
521                 mstore(tempBytes, len)
522 
523                 //update free-memory pointer
524                 //allocating the array padded to 32 bytes like the compiler does now
525                 mstore(0x40, and(add(mc, 31), not(31)))
526             }
527             //if we want a zero-length slice let's just return a zero-length array
528             default {
529                 tempBytes := mload(0x40)
530 
531                 mstore(0x40, add(tempBytes, 0x20))
532             }
533         }
534 
535         return (tempBytes, offset + len);
536     }
537     /* @notice              Read next 32 bytes starting from offset,
538     *  @param buff          Source bytes array
539     *  @param offset        The position from where we read the bytes value
540     *  @return              The read bytes32 value and updated offset
541     */
542     function NextHash(bytes memory buff, uint256 offset) internal pure returns (bytes32 , uint256) {
543         require(offset + 32 <= buff.length && offset < offset + 32, "NextHash, offset exceeds maximum");
544         bytes32 v;
545         assembly {
546             v := mload(add(buff, add(offset, 0x20)))
547         }
548         return (v, offset + 32);
549     }
550 
551     /* @notice              Read next 20 bytes starting from offset,
552     *  @param buff          Source bytes array
553     *  @param offset        The position from where we read the bytes value
554     *  @return              The read bytes20 value and updated offset
555     */
556     function NextBytes20(bytes memory buff, uint256 offset) internal pure returns (bytes20 , uint256) {
557         require(offset + 20 <= buff.length && offset < offset + 20, "NextBytes20, offset exceeds maximum");
558         bytes20 v;
559         assembly {
560             v := mload(add(buff, add(offset, 0x20)))
561         }
562         return (v, offset + 20);
563     }
564     
565     function NextVarUint(bytes memory buff, uint256 offset) internal pure returns(uint, uint256) {
566         byte v;
567         (v, offset) = NextByte(buff, offset);
568 
569         uint value;
570         if (v == 0xFD) {
571             // return NextUint16(buff, offset);
572             (value, offset) = NextUint16(buff, offset);
573             require(value >= 0xFD && value <= 0xFFFF, "NextUint16, value outside range");
574             return (value, offset);
575         } else if (v == 0xFE) {
576             // return NextUint32(buff, offset);
577             (value, offset) = NextUint32(buff, offset);
578             require(value > 0xFFFF && value <= 0xFFFFFFFF, "NextVarUint, value outside range");
579             return (value, offset);
580         } else if (v == 0xFF) {
581             // return NextUint64(buff, offset);
582             (value, offset) = NextUint64(buff, offset);
583             require(value > 0xFFFFFFFF, "NextVarUint, value outside range");
584             return (value, offset);
585         } else{
586             // return (uint8(v), offset);
587             value = uint8(v);
588             require(value < 0xFD, "NextVarUint, value outside range");
589             return (value, offset);
590         }
591     }
592 }
593 
594 library SafeMath {
595     /**
596      * @dev Returns the addition of two unsigned integers, reverting on
597      * overflow.
598      *
599      * Counterpart to Solidity's `+` operator.
600      *
601      * Requirements:
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         uint256 c = a + b;
606         require(c >= a, "SafeMath: addition overflow");
607 
608         return c;
609     }
610 
611     /**
612      * @dev Returns the subtraction of two unsigned integers, reverting on
613      * overflow (when the result is negative).
614      *
615      * Counterpart to Solidity's `-` operator.
616      *
617      * Requirements:
618      * - Subtraction cannot overflow.
619      */
620     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
621         return sub(a, b, "SafeMath: subtraction overflow");
622     }
623 
624     /**
625      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
626      * overflow (when the result is negative).
627      *
628      * Counterpart to Solidity's `-` operator.
629      *
630      * Requirements:
631      * - Subtraction cannot overflow.
632      *
633      * _Available since v2.4.0._
634      */
635     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
636         require(b <= a, errorMessage);
637         uint256 c = a - b;
638 
639         return c;
640     }
641 
642     /**
643      * @dev Returns the multiplication of two unsigned integers, reverting on
644      * overflow.
645      *
646      * Counterpart to Solidity's `*` operator.
647      *
648      * Requirements:
649      * - Multiplication cannot overflow.
650      */
651     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
652         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
653         // benefit is lost if 'b' is also tested.
654         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
655         if (a == 0) {
656             return 0;
657         }
658 
659         uint256 c = a * b;
660         require(c / a == b, "SafeMath: multiplication overflow");
661 
662         return c;
663     }
664 
665     /**
666      * @dev Returns the integer division of two unsigned integers. Reverts on
667      * division by zero. The result is rounded towards zero.
668      *
669      * Counterpart to Solidity's `/` operator. Note: this function uses a
670      * `revert` opcode (which leaves remaining gas untouched) while Solidity
671      * uses an invalid opcode to revert (consuming all remaining gas).
672      *
673      * Requirements:
674      * - The divisor cannot be zero.
675      */
676     function div(uint256 a, uint256 b) internal pure returns (uint256) {
677         return div(a, b, "SafeMath: division by zero");
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator. Note: this function uses a
685      * `revert` opcode (which leaves remaining gas untouched) while Solidity
686      * uses an invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      * - The divisor cannot be zero.
690      *
691      * _Available since v2.4.0._
692      */
693     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
694         // Solidity only automatically asserts when dividing by 0
695         require(b != 0, errorMessage);
696         uint256 c = a / b;
697         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
698 
699         return c;
700     }
701 
702     /**
703      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
704      * Reverts when dividing by zero.
705      *
706      * Counterpart to Solidity's `%` operator. This function uses a `revert`
707      * opcode (which leaves remaining gas untouched) while Solidity uses an
708      * invalid opcode to revert (consuming all remaining gas).
709      *
710      * Requirements:
711      * - The divisor cannot be zero.
712      */
713     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
714         return mod(a, b, "SafeMath: modulo by zero");
715     }
716 
717     /**
718      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
719      * Reverts with custom message when dividing by zero.
720      *
721      * Counterpart to Solidity's `%` operator. This function uses a `revert`
722      * opcode (which leaves remaining gas untouched) while Solidity uses an
723      * invalid opcode to revert (consuming all remaining gas).
724      *
725      * Requirements:
726      * - The divisor cannot be zero.
727      *
728      * _Available since v2.4.0._
729      */
730     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
731         require(b != 0, errorMessage);
732         return a % b;
733     }
734 }
735 
736 
737 library Utils {
738 
739     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
740     *  @param _bs   Source bytes array
741     *  @return      bytes32
742     */
743     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
744         require(_bs.length == 32, "bytes length is not 32.");
745         assembly {
746             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
747             value := mload(add(_bs, 0x20))
748         }
749     }
750 
751     /* @notice      Convert bytes to uint256
752     *  @param _b    Source bytes should have length of 32
753     *  @return      uint256
754     */
755     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
756         require(_bs.length == 32, "bytes length is not 32.");
757         assembly {
758             // load 32 bytes from memory starting from position _bs + 32
759             value := mload(add(_bs, 0x20))
760         }
761         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
762     }
763 
764     /* @notice      Convert uint256 to bytes
765     *  @param _b    uint256 that needs to be converted
766     *  @return      bytes
767     */
768     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
769         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
770         assembly {
771             // Get a location of some free memory and store it in result as
772             // Solidity does for memory variables.
773             bs := mload(0x40)
774             // Put 0x20 at the first word, the length of bytes for uint256 value
775             mstore(bs, 0x20)
776             //In the next word, put value in bytes format to the next 32 bytes
777             mstore(add(bs, 0x20), _value)
778             // Update the free-memory pointer by padding our last write location to 32 bytes
779             mstore(0x40, add(bs, 0x40))
780         }
781     }
782 
783     /* @notice      Convert bytes to address
784     *  @param _bs   Source bytes: bytes length must be 20
785     *  @return      Converted address from source bytes
786     */
787     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
788     {
789         require(_bs.length == 20, "bytes length does not match address");
790         assembly {
791             // for _bs, first word store _bs.length, second word store _bs.value
792             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
793             addr := mload(add(_bs, 0x14))
794         }
795 
796     }
797     
798     /* @notice      Convert address to bytes
799     *  @param _addr Address need to be converted
800     *  @return      Converted bytes from address
801     */
802     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
803         assembly {
804             // Get a location of some free memory and store it in result as
805             // Solidity does for memory variables.
806             bs := mload(0x40)
807             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
808             mstore(bs, 0x14)
809             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
810             mstore(add(bs, 0x20), shl(96, _addr))
811             // Update the free-memory pointer by padding our last write location to 32 bytes
812             mstore(0x40, add(bs, 0x40))
813        }
814     }
815 
816     /* @notice          Do hash leaf as the multi-chain does
817     *  @param _data     Data in bytes format
818     *  @return          Hashed value in bytes32 format
819     */
820     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
821         result = sha256(abi.encodePacked(byte(0x0), _data));
822     }
823 
824     /* @notice          Do hash children as the multi-chain does
825     *  @param _l        Left node
826     *  @param _r        Right node
827     *  @return          Hashed value in bytes32 format
828     */
829     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
830         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
831     }
832 
833     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
834                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
835     *  @param _preBytes     The bytes stored in storage
836     *  @param _postBytes    The bytes stored in memory
837     *  @return              Bool type indicating if they are equal
838     */
839     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
840         bool success = true;
841 
842         assembly {
843             // we know _preBytes_offset is 0
844             let fslot := sload(_preBytes_slot)
845             // Arrays of 31 bytes or less have an even value in their slot,
846             // while longer arrays have an odd value. The actual length is
847             // the slot divided by two for odd values, and the lowest order
848             // byte divided by two for even values.
849             // If the slot is even, bitwise and the slot with 255 and divide by
850             // two to get the length. If the slot is odd, bitwise and the slot
851             // with -1 and divide by two.
852             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
853             let mlength := mload(_postBytes)
854 
855             // if lengths don't match the arrays are not equal
856             switch eq(slength, mlength)
857             case 1 {
858                 // fslot can contain both the length and contents of the array
859                 // if slength < 32 bytes so let's prepare for that
860                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
861                 // slength != 0
862                 if iszero(iszero(slength)) {
863                     switch lt(slength, 32)
864                     case 1 {
865                         // blank the last byte which is the length
866                         fslot := mul(div(fslot, 0x100), 0x100)
867 
868                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
869                             // unsuccess:
870                             success := 0
871                         }
872                     }
873                     default {
874                         // cb is a circuit breaker in the for loop since there's
875                         //  no said feature for inline assembly loops
876                         // cb = 1 - don't breaker
877                         // cb = 0 - break
878                         let cb := 1
879 
880                         // get the keccak hash to get the contents of the array
881                         mstore(0x0, _preBytes_slot)
882                         let sc := keccak256(0x0, 0x20)
883 
884                         let mc := add(_postBytes, 0x20)
885                         let end := add(mc, mlength)
886 
887                         // the next line is the loop condition:
888                         // while(uint(mc < end) + cb == 2)
889                         for {} eq(add(lt(mc, end), cb), 2) {
890                             sc := add(sc, 1)
891                             mc := add(mc, 0x20)
892                         } {
893                             if iszero(eq(sload(sc), mload(mc))) {
894                                 // unsuccess:
895                                 success := 0
896                                 cb := 0
897                             }
898                         }
899                     }
900                 }
901             }
902             default {
903                 // unsuccess:
904                 success := 0
905             }
906         }
907 
908         return success;
909     }
910 
911     /* @notice              Slice the _bytes from _start index till the result has length of _length
912                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
913     *  @param _bytes        The original bytes needs to be sliced
914     *  @param _start        The index of _bytes for the start of sliced bytes
915     *  @param _length       The index of _bytes for the end of sliced bytes
916     *  @return              The sliced bytes
917     */
918     function slice(
919         bytes memory _bytes,
920         uint _start,
921         uint _length
922     )
923         internal
924         pure
925         returns (bytes memory)
926     {
927         require(_bytes.length >= (_start + _length));
928 
929         bytes memory tempBytes;
930 
931         assembly {
932             switch iszero(_length)
933             case 0 {
934                 // Get a location of some free memory and store it in tempBytes as
935                 // Solidity does for memory variables.
936                 tempBytes := mload(0x40)
937 
938                 // The first word of the slice result is potentially a partial
939                 // word read from the original array. To read it, we calculate
940                 // the length of that partial word and start copying that many
941                 // bytes into the array. The first word we copy will start with
942                 // data we don't care about, but the last `lengthmod` bytes will
943                 // land at the beginning of the contents of the new array. When
944                 // we're done copying, we overwrite the full first word with
945                 // the actual length of the slice.
946                 // lengthmod <= _length % 32
947                 let lengthmod := and(_length, 31)
948 
949                 // The multiplication in the next line is necessary
950                 // because when slicing multiples of 32 bytes (lengthmod == 0)
951                 // the following copy loop was copying the origin's length
952                 // and then ending prematurely not copying everything it should.
953                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
954                 let end := add(mc, _length)
955 
956                 for {
957                     // The multiplication in the next line has the same exact purpose
958                     // as the one above.
959                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
960                 } lt(mc, end) {
961                     mc := add(mc, 0x20)
962                     cc := add(cc, 0x20)
963                 } {
964                     mstore(mc, mload(cc))
965                 }
966 
967                 mstore(tempBytes, _length)
968 
969                 //update free-memory pointer
970                 //allocating the array padded to 32 bytes like the compiler does now
971                 mstore(0x40, and(add(mc, 31), not(31)))
972             }
973             //if we want a zero-length slice let's just return a zero-length array
974             default {
975                 tempBytes := mload(0x40)
976 
977                 mstore(0x40, add(tempBytes, 0x20))
978             }
979         }
980 
981         return tempBytes;
982     }
983     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
984     *  @param _keepers      The array consists of serveral address
985     *  @param _signers      Some specific addresses to be looked into
986     *  @param _m            The number requirement paramter
987     *  @return              True means containment, false meansdo do not contain.
988     */
989     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
990         uint m = 0;
991         for(uint i = 0; i < _signers.length; i++){
992             for (uint j = 0; j < _keepers.length; j++) {
993                 if (_signers[i] == _keepers[j]) {
994                     m++;
995                     delete _keepers[j];
996                 }
997             }
998         }
999         return m >= _m;
1000     }
1001 
1002     /* @notice              TODO
1003     *  @param key
1004     *  @return
1005     */
1006     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
1007          require(key.length >= 67, "key lenggh is too short");
1008          newkey = slice(key, 0, 35);
1009          if (uint8(key[66]) % 2 == 0){
1010              newkey[2] = byte(0x02);
1011          } else {
1012              newkey[2] = byte(0x03);
1013          }
1014          return newkey;
1015     }
1016     
1017     /**
1018      * @dev Returns true if `account` is a contract.
1019      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
1020      *
1021      * This test is non-exhaustive, and there may be false-negatives: during the
1022      * execution of a contract's constructor, its address will be reported as
1023      * not containing a contract.
1024      *
1025      * IMPORTANT: It is unsafe to assume that an address for which this
1026      * function returns false is an externally-owned account (EOA) and not a
1027      * contract.
1028      */
1029     function isContract(address account) internal view returns (bool) {
1030         // This method relies in extcodesize, which returns 0 for contracts in
1031         // construction, since the code is only stored at the end of the
1032         // constructor execution.
1033 
1034         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1035         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1036         // for accounts without code, i.e. `keccak256('')`
1037         bytes32 codehash;
1038         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1039         // solhint-disable-next-line no-inline-assembly
1040         assembly { codehash := extcodehash(account) }
1041         return (codehash != 0x0 && codehash != accountHash);
1042     }
1043 }
1044 
1045 library ECCUtils {
1046     using SafeMath for uint256;
1047     
1048     struct Header {
1049         uint32 version;
1050         uint64 chainId;
1051         uint32 timestamp;
1052         uint32 height;
1053         uint64 consensusData;
1054         bytes32 prevBlockHash;
1055         bytes32 transactionsRoot;
1056         bytes32 crossStatesRoot;
1057         bytes32 blockRoot;
1058         bytes consensusPayload;
1059         bytes20 nextBookkeeper;
1060     }
1061 
1062     struct ToMerkleValue {
1063         bytes  txHash;  // cross chain txhash
1064         uint64 fromChainID;
1065         TxParam makeTxParam;
1066     }
1067 
1068     struct TxParam {
1069         bytes txHash; //  source chain txhash
1070         bytes crossChainId;
1071         bytes fromContract;
1072         uint64 toChainId;
1073         bytes toContract;
1074         bytes method;
1075         bytes args;
1076     }
1077 
1078     uint constant POLYCHAIN_PUBKEY_LEN = 67;
1079     uint constant POLYCHAIN_SIGNATURE_LEN = 65;
1080 
1081     /* @notice                  Verify Poly chain transaction whether exist or not
1082     *  @param _auditPath        Poly chain merkle proof
1083     *  @param _root             Poly chain root
1084     *  @return                  The verified value included in _auditPath
1085     */
1086     function merkleProve(bytes memory _auditPath, bytes32 _root) internal pure returns (bytes memory) {
1087         uint256 off = 0;
1088         bytes memory value;
1089         (value, off)  = ZeroCopySource.NextVarBytes(_auditPath, off);
1090 
1091         bytes32 hash = Utils.hashLeaf(value);
1092         uint size = _auditPath.length.sub(off).div(33);
1093         bytes32 nodeHash;
1094         byte pos;
1095         for (uint i = 0; i < size; i++) {
1096             (pos, off) = ZeroCopySource.NextByte(_auditPath, off);
1097             (nodeHash, off) = ZeroCopySource.NextHash(_auditPath, off);
1098             if (pos == 0x00) {
1099                 hash = Utils.hashChildren(nodeHash, hash);
1100             } else if (pos == 0x01) {
1101                 hash = Utils.hashChildren(hash, nodeHash);
1102             } else {
1103                 revert("merkleProve, NextByte for position info failed");
1104             }
1105         }
1106         require(hash == _root, "merkleProve, expect root is not equal actual root");
1107         return value;
1108     }
1109 
1110     /* @notice              calculate next book keeper according to public key list
1111     *  @param _keyLen       consensus node number
1112     *  @param _m            minimum signature number
1113     *  @param _pubKeyList   consensus node public key list
1114     *  @return              two element: next book keeper, consensus node signer addresses
1115     */
1116     function _getBookKeeper(uint _keyLen, uint _m, bytes memory _pubKeyList) internal pure returns (bytes20, address[] memory){
1117          bytes memory buff;
1118          buff = ZeroCopySink.WriteUint16(uint16(_keyLen));
1119          address[] memory keepers = new address[](_keyLen);
1120          bytes32 hash;
1121          bytes memory publicKey;
1122          for(uint i = 0; i < _keyLen; i++){
1123              publicKey = Utils.slice(_pubKeyList, i*POLYCHAIN_PUBKEY_LEN, POLYCHAIN_PUBKEY_LEN);
1124              buff =  abi.encodePacked(buff, ZeroCopySink.WriteVarBytes(Utils.compressMCPubKey(publicKey)));
1125              hash = keccak256(Utils.slice(publicKey, 3, 64));
1126              keepers[i] = address(uint160(uint256(hash)));
1127          }
1128 
1129          buff = abi.encodePacked(buff, ZeroCopySink.WriteUint16(uint16(_m)));
1130          bytes20  nextBookKeeper = ripemd160(abi.encodePacked(sha256(buff)));
1131          return (nextBookKeeper, keepers);
1132     }
1133 
1134     /* @notice              Verify public key derived from Poly chain
1135     *  @param _pubKeyList   serialized consensus node public key list
1136     *  @param _sigList      consensus node signature list
1137     *  @return              return two element: next book keeper, consensus node signer addresses
1138     */
1139     function verifyPubkey(bytes memory _pubKeyList) internal pure returns (bytes20, address[] memory) {
1140         require(_pubKeyList.length % POLYCHAIN_PUBKEY_LEN == 0, "_pubKeyList length illegal!");
1141         uint n = _pubKeyList.length / POLYCHAIN_PUBKEY_LEN;
1142         require(n >= 1, "too short _pubKeyList!");
1143         return _getBookKeeper(n, n - (n - 1) / 3, _pubKeyList);
1144     }
1145 
1146     /* @notice              Verify Poly chain consensus node signature
1147     *  @param _rawHeader    Poly chain block header raw bytes
1148     *  @param _sigList      consensus node signature list
1149     *  @param _keepers      addresses corresponding with Poly chain book keepers' public keys
1150     *  @param _m            minimum signature number
1151     *  @return              true or false
1152     */
1153     function verifySig(bytes memory _rawHeader, bytes memory _sigList, address[] memory _keepers, uint _m) internal pure returns (bool){
1154         bytes32 hash = getHeaderHash(_rawHeader);
1155 
1156         uint sigCount = _sigList.length.div(POLYCHAIN_SIGNATURE_LEN);
1157         address[] memory signers = new address[](sigCount);
1158         bytes32 r;
1159         bytes32 s;
1160         uint8 v;
1161         for(uint j = 0; j  < sigCount; j++){
1162             r = Utils.bytesToBytes32(Utils.slice(_sigList, j*POLYCHAIN_SIGNATURE_LEN, 32));
1163             s =  Utils.bytesToBytes32(Utils.slice(_sigList, j*POLYCHAIN_SIGNATURE_LEN + 32, 32));
1164             v =  uint8(_sigList[j*POLYCHAIN_SIGNATURE_LEN + 64]) + 27;
1165             signers[j] =  ecrecover(sha256(abi.encodePacked(hash)), v, r, s);
1166             if (signers[j] == address(0)) return false;
1167         }
1168         return Utils.containMAddresses(_keepers, signers, _m);
1169     }
1170     
1171 
1172     /* @notice               Serialize Poly chain book keepers' info in Ethereum addresses format into raw bytes
1173     *  @param keepersBytes   The serialized addresses
1174     *  @return               serialized bytes result
1175     */
1176     function serializeKeepers(address[] memory keepers) internal pure returns (bytes memory) {
1177         uint256 keeperLen = keepers.length;
1178         bytes memory keepersBytes = ZeroCopySink.WriteUint64(uint64(keeperLen));
1179         for(uint i = 0; i < keeperLen; i++) {
1180             keepersBytes = abi.encodePacked(keepersBytes, ZeroCopySink.WriteVarBytes(Utils.addressToBytes(keepers[i])));
1181         }
1182         return keepersBytes;
1183     }
1184 
1185     /* @notice               Deserialize bytes into Ethereum addresses
1186     *  @param keepersBytes   The serialized addresses derived from Poly chain book keepers in bytes format
1187     *  @return               addresses
1188     */
1189     function deserializeKeepers(bytes memory keepersBytes) internal pure returns (address[] memory) {
1190         uint256 off = 0;
1191         uint64 keeperLen;
1192         (keeperLen, off) = ZeroCopySource.NextUint64(keepersBytes, off);
1193         address[] memory keepers = new address[](keeperLen);
1194         bytes memory keeperBytes;
1195         for(uint i = 0; i < keeperLen; i++) {
1196             (keeperBytes, off) = ZeroCopySource.NextVarBytes(keepersBytes, off);
1197             keepers[i] = Utils.bytesToAddress(keeperBytes);
1198         }
1199         return keepers;
1200     }
1201 
1202     /* @notice               Deserialize Poly chain transaction raw value
1203     *  @param _valueBs       Poly chain transaction raw bytes
1204     *  @return               ToMerkleValue struct
1205     */
1206     function deserializeMerkleValue(bytes memory _valueBs) internal pure returns (ToMerkleValue memory) {
1207         ToMerkleValue memory toMerkleValue;
1208         uint256 off = 0;
1209 
1210         (toMerkleValue.txHash, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1211 
1212         (toMerkleValue.fromChainID, off) = ZeroCopySource.NextUint64(_valueBs, off);
1213 
1214         TxParam memory txParam;
1215 
1216         (txParam.txHash, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1217         
1218         (txParam.crossChainId, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1219 
1220         (txParam.fromContract, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1221 
1222         (txParam.toChainId, off) = ZeroCopySource.NextUint64(_valueBs, off);
1223 
1224         (txParam.toContract, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1225 
1226         (txParam.method, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1227 
1228         (txParam.args, off) = ZeroCopySource.NextVarBytes(_valueBs, off);
1229         toMerkleValue.makeTxParam = txParam;
1230 
1231         return toMerkleValue;
1232     }
1233 
1234     /* @notice            Deserialize Poly chain block header raw bytes
1235     *  @param _valueBs    Poly chain block header raw bytes
1236     *  @return            Header struct
1237     */
1238     function deserializeHeader(bytes memory _headerBs) internal pure returns (Header memory) {
1239         Header memory header;
1240         uint256 off = 0;
1241         (header.version, off)  = ZeroCopySource.NextUint32(_headerBs, off);
1242 
1243         (header.chainId, off) = ZeroCopySource.NextUint64(_headerBs, off);
1244 
1245         (header.prevBlockHash, off) = ZeroCopySource.NextHash(_headerBs, off);
1246 
1247         (header.transactionsRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
1248 
1249         (header.crossStatesRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
1250 
1251         (header.blockRoot, off) = ZeroCopySource.NextHash(_headerBs, off);
1252 
1253         (header.timestamp, off) = ZeroCopySource.NextUint32(_headerBs, off);
1254 
1255         (header.height, off) = ZeroCopySource.NextUint32(_headerBs, off);
1256 
1257         (header.consensusData, off) = ZeroCopySource.NextUint64(_headerBs, off);
1258 
1259         (header.consensusPayload, off) = ZeroCopySource.NextVarBytes(_headerBs, off);
1260 
1261         (header.nextBookkeeper, off) = ZeroCopySource.NextBytes20(_headerBs, off);
1262 
1263         return header;
1264     }
1265 
1266     /* @notice            Deserialize Poly chain block header raw bytes
1267     *  @param rawHeader   Poly chain block header raw bytes
1268     *  @return            header hash same as Poly chain
1269     */
1270     function getHeaderHash(bytes memory rawHeader) internal pure returns (bytes32) {
1271         return sha256(abi.encodePacked(sha256(rawHeader)));
1272     }
1273 }
1274 
1275 interface IEthCrossChainData {
1276     function putCurEpochStartHeight(uint32 curEpochStartHeight) external returns (bool);
1277     function getCurEpochStartHeight() external view returns (uint32);
1278     function putCurEpochConPubKeyBytes(bytes calldata curEpochPkBytes) external returns (bool);
1279     function getCurEpochConPubKeyBytes() external view returns (bytes memory);
1280     function markFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) external returns (bool);
1281     function checkIfFromChainTxExist(uint64 fromChainId, bytes32 fromChainTx) external view returns (bool);
1282     function getEthTxHashIndex() external view returns (uint256);
1283     function putEthTxHash(bytes32 ethTxHash) external returns (bool);
1284     function putExtraData(bytes32 key1, bytes32 key2, bytes calldata value) external returns (bool);
1285     function getExtraData(bytes32 key1, bytes32 key2) external view returns (bytes memory);
1286     function transferOwnership(address newOwner) external;
1287     function pause() external returns (bool);
1288     function unpause() external returns (bool);
1289     function paused() external view returns (bool);
1290     // Not used currently by ECCM
1291     function getEthTxHash(uint256 ethTxHashIndex) external view returns (bytes32);
1292 }
1293 
1294 interface IUpgradableECCM {
1295     function pause() external returns (bool);
1296     function unpause() external returns (bool);
1297     function paused() external view returns (bool);
1298     function upgradeToNew(address) external returns (bool);
1299     function isOwner() external view returns (bool);
1300     function setChainId(uint64 _newChainId) external returns (bool);
1301 }
1302 
1303 
1304 interface IEthCrossChainManager {
1305     function crossChain(uint64 _toChainId, bytes calldata _toContract, bytes calldata _method, bytes calldata _txData) external returns (bool);
1306 }
1307 
1308 contract UpgradableECCM is IUpgradableECCM, Ownable, Pausable {
1309     address public EthCrossChainDataAddress;
1310     uint64 public chainId;  
1311     
1312     constructor (address ethCrossChainDataAddr, uint64 _chainId) Pausable() Ownable()  public {
1313         EthCrossChainDataAddress = ethCrossChainDataAddr;
1314         chainId = _chainId;
1315     }
1316     function pause() onlyOwner public returns (bool) {
1317         if (!paused()) {
1318             _pause();
1319         }
1320         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1321         if (!eccd.paused()) {
1322             require(eccd.pause(), "pause EthCrossChainData contract failed");
1323         }
1324         return true;
1325     }
1326     
1327     function unpause() onlyOwner public returns (bool) {
1328         if (paused()) {
1329             _unpause();
1330         }
1331         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1332         if (eccd.paused()) {
1333             require(eccd.unpause(), "unpause EthCrossChainData contract failed");
1334         }
1335         return true;
1336     }
1337 
1338     // if we want to upgrade this contract, we need to invoke this method 
1339     function upgradeToNew(address newEthCrossChainManagerAddress) whenPaused onlyOwner public returns (bool) {
1340         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1341         eccd.transferOwnership(newEthCrossChainManagerAddress);
1342         return true;
1343     }
1344     
1345     function setChainId(uint64 _newChainId) whenPaused onlyOwner public returns (bool) {
1346         chainId = _newChainId;
1347         return true;
1348     }
1349 }
1350 
1351 contract EthCrossChainManager is IEthCrossChainManager, UpgradableECCM {
1352     using SafeMath for uint256;
1353     
1354     address public whiteLister;
1355     mapping(address => bool) public whiteListFromContract;
1356     mapping(address => mapping(bytes => bool)) public whiteListContractMethodMap;
1357 
1358     event InitGenesisBlockEvent(uint256 height, bytes rawHeader);
1359     event ChangeBookKeeperEvent(uint256 height, bytes rawHeader);
1360     event CrossChainEvent(address indexed sender, bytes txId, address proxyOrAssetContract, uint64 toChainId, bytes toContract, bytes rawdata);
1361     event VerifyHeaderAndExecuteTxEvent(uint64 fromChainID, bytes toContract, bytes crossChainTxHash, bytes fromChainTxHash);
1362     constructor(
1363         address _eccd, 
1364         uint64 _chainId, 
1365         address[] memory fromContractWhiteList, 
1366         bytes[] memory contractMethodWhiteList
1367     ) UpgradableECCM(_eccd,_chainId) public {
1368         whiteLister = msg.sender;
1369         for (uint i=0;i<fromContractWhiteList.length;i++) {
1370             whiteListFromContract[fromContractWhiteList[i]] = true;
1371         }
1372         for (uint i=0;i<contractMethodWhiteList.length;i++) {
1373             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
1374             for (uint j=0;j<methods.length;j++) {
1375                 whiteListContractMethodMap[toContract][methods[j]] = true;
1376             }
1377         }
1378     }
1379     
1380     modifier onlyWhiteLister() {
1381         require(msg.sender == whiteLister, "Not whiteLister");
1382         _;
1383     }
1384 
1385     function setWhiteLister(address newWL) public onlyWhiteLister {
1386         require(newWL!=address(0), "Can not transfer to address(0)");
1387         whiteLister = newWL;
1388     }
1389     
1390     function setFromContractWhiteList(address[] memory fromContractWhiteList) public onlyWhiteLister {
1391         for (uint i=0;i<fromContractWhiteList.length;i++) {
1392             whiteListFromContract[fromContractWhiteList[i]] = true;
1393         }
1394     }
1395     
1396     function removeFromContractWhiteList(address[] memory fromContractWhiteList) public onlyWhiteLister {
1397         for (uint i=0;i<fromContractWhiteList.length;i++) {
1398             whiteListFromContract[fromContractWhiteList[i]] = false;
1399         }
1400     }
1401     
1402     function setContractMethodWhiteList(bytes[] memory contractMethodWhiteList) public onlyWhiteLister {
1403         for (uint i=0;i<contractMethodWhiteList.length;i++) {
1404             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
1405             for (uint j=0;j<methods.length;j++) {
1406                 whiteListContractMethodMap[toContract][methods[j]] = true;
1407             }
1408         }
1409     }
1410     
1411     function removeContractMethodWhiteList(bytes[] memory contractMethodWhiteList) public onlyWhiteLister {
1412         for (uint i=0;i<contractMethodWhiteList.length;i++) {
1413             (address toContract,bytes[] memory methods) = abi.decode(contractMethodWhiteList[i],(address,bytes[]));
1414             for (uint j=0;j<methods.length;j++) {
1415                 whiteListContractMethodMap[toContract][methods[j]] = false;
1416             }
1417         }
1418     }
1419 
1420     /* @notice              sync Poly chain genesis block header to smart contrat
1421     *  @dev                 this function can only be called once, nextbookkeeper of rawHeader can't be empty
1422     *  @param rawHeader     Poly chain genesis block raw header or raw Header including switching consensus peers info
1423     *  @return              true or false
1424     */
1425     function initGenesisBlock(bytes memory rawHeader, bytes memory pubKeyList) whenNotPaused public returns(bool) {
1426         // Load Ethereum cross chain data contract
1427         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1428         
1429         // Make sure the contract has not been initialized before
1430         require(eccd.getCurEpochConPubKeyBytes().length == 0, "EthCrossChainData contract has already been initialized!");
1431         
1432         // Parse header and convit the public keys into nextBookKeeper and compare it with header.nextBookKeeper to verify the validity of signature
1433         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
1434         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
1435         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
1436         
1437         // Record current epoch start height and public keys (by storing them in address format)
1438         require(eccd.putCurEpochStartHeight(header.height), "Save Poly chain current epoch start height to Data contract failed!");
1439         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain current epoch book keepers to Data contract failed!");
1440         
1441         // Fire the event
1442         emit InitGenesisBlockEvent(header.height, rawHeader);
1443         return true;
1444     }
1445     
1446     /* @notice              change Poly chain consensus book keeper
1447     *  @param rawHeader     Poly chain change book keeper block raw header
1448     *  @param pubKeyList    Poly chain consensus nodes public key list
1449     *  @param sigList       Poly chain consensus nodes signature list
1450     *  @return              true or false
1451     */
1452     function changeBookKeeper(bytes memory rawHeader, bytes memory pubKeyList, bytes memory sigList) whenNotPaused public returns(bool) {
1453         // Load Ethereum cross chain data contract
1454         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
1455         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1456         
1457         // Make sure rawHeader.height is higher than recorded current epoch start height
1458         uint64 curEpochStartHeight = eccd.getCurEpochStartHeight();
1459         require(header.height > curEpochStartHeight, "The height of header is lower than current epoch start height!");
1460         
1461         // Ensure the rawHeader is the key header including info of switching consensus peers by containing non-empty nextBookKeeper field
1462         require(header.nextBookkeeper != bytes20(0), "The nextBookKeeper of header is empty");
1463         
1464         // Verify signature of rawHeader comes from pubKeyList
1465         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
1466         uint n = polyChainBKs.length;
1467         require(ECCUtils.verifySig(rawHeader, sigList, polyChainBKs, n - (n - 1) / 3), "Verify signature failed!");
1468         
1469         // Convert pubKeyList into ethereum address format and make sure the compound address from the converted ethereum addresses
1470         // equals passed in header.nextBooker
1471         (bytes20 nextBookKeeper, address[] memory keepers) = ECCUtils.verifyPubkey(pubKeyList);
1472         require(header.nextBookkeeper == nextBookKeeper, "NextBookers illegal");
1473         
1474         // update current epoch start height of Poly chain and current epoch consensus peers book keepers addresses
1475         require(eccd.putCurEpochStartHeight(header.height), "Save MC LatestHeight to Data contract failed!");
1476         require(eccd.putCurEpochConPubKeyBytes(ECCUtils.serializeKeepers(keepers)), "Save Poly chain book keepers bytes to Data contract failed!");
1477         
1478         // Fire the change book keeper event
1479         emit ChangeBookKeeperEvent(header.height, rawHeader);
1480         return true;
1481     }
1482 
1483 
1484     /* @notice              ERC20 token cross chain to other blockchain.
1485     *                       this function push tx event to blockchain
1486     *  @param toChainId     Target chain id
1487     *  @param toContract    Target smart contract address in target block chain
1488     *  @param txData        Transaction data for target chain, include to_address, amount
1489     *  @return              true or false
1490     */
1491     function crossChain(uint64 toChainId, bytes calldata toContract, bytes calldata method, bytes calldata txData) whenNotPaused external returns (bool) {
1492         // Only allow whitelist contract to call
1493         require(whiteListFromContract[msg.sender],"Invalid from contract");
1494         
1495         // Load Ethereum cross chain data contract
1496         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1497         
1498         // To help differentiate two txs, the ethTxHashIndex is increasing automatically
1499         uint256 txHashIndex = eccd.getEthTxHashIndex();
1500         
1501         // Convert the uint256 into bytes
1502         bytes memory paramTxHash = Utils.uint256ToBytes(txHashIndex);
1503         
1504         // Construct the makeTxParam, and put the hash info storage, to help provide proof of tx existence
1505         bytes memory rawParam = abi.encodePacked(ZeroCopySink.WriteVarBytes(paramTxHash),
1506             ZeroCopySink.WriteVarBytes(abi.encodePacked(sha256(abi.encodePacked(address(this), paramTxHash)))),
1507             ZeroCopySink.WriteVarBytes(Utils.addressToBytes(msg.sender)),
1508             ZeroCopySink.WriteUint64(toChainId),
1509             ZeroCopySink.WriteVarBytes(toContract),
1510             ZeroCopySink.WriteVarBytes(method),
1511             ZeroCopySink.WriteVarBytes(txData)
1512         );
1513         
1514         // Must save it in the storage to be included in the proof to be verified.
1515         require(eccd.putEthTxHash(keccak256(rawParam)), "Save ethTxHash by index to Data contract failed!");
1516         
1517         // Fire the cross chain event denoting there is a cross chain request from Ethereum network to other public chains through Poly chain network
1518         emit CrossChainEvent(tx.origin, paramTxHash, msg.sender, toChainId, toContract, rawParam);
1519         return true;
1520     }
1521     /* @notice              Verify Poly chain header and proof, execute the cross chain tx from Poly chain to Ethereum
1522     *  @param proof         Poly chain tx merkle proof
1523     *  @param rawHeader     The header containing crossStateRoot to verify the above tx merkle proof
1524     *  @param headerProof   The header merkle proof used to verify rawHeader
1525     *  @param curRawHeader  Any header in current epoch consensus of Poly chain
1526     *  @param headerSig     The coverted signature veriable for solidity derived from Poly chain consensus nodes' signature
1527     *                       used to verify the validity of curRawHeader
1528     *  @return              true or false
1529     */
1530     function verifyHeaderAndExecuteTx(bytes memory proof, bytes memory rawHeader, bytes memory headerProof, bytes memory curRawHeader,bytes memory headerSig) whenNotPaused public returns (bool){
1531         ECCUtils.Header memory header = ECCUtils.deserializeHeader(rawHeader);
1532         // Load ehereum cross chain data contract
1533         IEthCrossChainData eccd = IEthCrossChainData(EthCrossChainDataAddress);
1534         
1535         // Get stored consensus public key bytes of current poly chain epoch and deserialize Poly chain consensus public key bytes to address[]
1536         address[] memory polyChainBKs = ECCUtils.deserializeKeepers(eccd.getCurEpochConPubKeyBytes());
1537 
1538         uint256 curEpochStartHeight = eccd.getCurEpochStartHeight();
1539 
1540         uint n = polyChainBKs.length;
1541         if (header.height >= curEpochStartHeight) {
1542             // It's enough to verify rawHeader signature
1543             require(ECCUtils.verifySig(rawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain header signature failed!");
1544         } else {
1545             // We need to verify the signature of curHeader 
1546             require(ECCUtils.verifySig(curRawHeader, headerSig, polyChainBKs, n - ( n - 1) / 3), "Verify poly chain current epoch header signature failed!");
1547 
1548             // Then use curHeader.StateRoot and headerProof to verify rawHeader.CrossStateRoot
1549             ECCUtils.Header memory curHeader = ECCUtils.deserializeHeader(curRawHeader);
1550             bytes memory proveValue = ECCUtils.merkleProve(headerProof, curHeader.blockRoot);
1551             require(ECCUtils.getHeaderHash(rawHeader) == Utils.bytesToBytes32(proveValue), "verify header proof failed!");
1552         }
1553         
1554         // Through rawHeader.CrossStatesRoot, the toMerkleValue or cross chain msg can be verified and parsed from proof
1555         bytes memory toMerkleValueBs = ECCUtils.merkleProve(proof, header.crossStatesRoot);
1556         
1557         // Parse the toMerkleValue struct and make sure the tx has not been processed, then mark this tx as processed
1558         ECCUtils.ToMerkleValue memory toMerkleValue = ECCUtils.deserializeMerkleValue(toMerkleValueBs);
1559         require(!eccd.checkIfFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "the transaction has been executed!");
1560         require(eccd.markFromChainTxExist(toMerkleValue.fromChainID, Utils.bytesToBytes32(toMerkleValue.txHash)), "Save crosschain tx exist failed!");
1561         
1562         // Ethereum ChainId is 2, we need to check the transaction is for Ethereum network
1563         require(toMerkleValue.makeTxParam.toChainId == chainId, "This Tx is not aiming at this network!");
1564         
1565         // Obtain the targeting contract, so that Ethereum cross chain manager contract can trigger the executation of cross chain tx on Ethereum side
1566         address toContract = Utils.bytesToAddress(toMerkleValue.makeTxParam.toContract);
1567         
1568         // only invoke PreWhiteListed Contract and method For Now
1569         require(whiteListContractMethodMap[toContract][toMerkleValue.makeTxParam.method],"Invalid to contract or method");
1570 
1571         //TODO: check this part to make sure we commit the next line when doing local net UT test
1572         require(_executeCrossChainTx(toContract, toMerkleValue.makeTxParam.method, toMerkleValue.makeTxParam.args, toMerkleValue.makeTxParam.fromContract, toMerkleValue.fromChainID), "Execute CrossChain Tx failed!");
1573 
1574         // Fire the cross chain event denoting the executation of cross chain tx is successful,
1575         // and this tx is coming from other public chains to current Ethereum network
1576         emit VerifyHeaderAndExecuteTxEvent(toMerkleValue.fromChainID, toMerkleValue.makeTxParam.toContract, toMerkleValue.txHash, toMerkleValue.makeTxParam.txHash);
1577 
1578         return true;
1579     }
1580     
1581     /* @notice                  Dynamically invoke the targeting contract, and trigger executation of cross chain tx on Ethereum side
1582     *  @param _toContract       The targeting contract that will be invoked by the Ethereum Cross Chain Manager contract
1583     *  @param _method           At which method will be invoked within the targeting contract
1584     *  @param _args             The parameter that will be passed into the targeting contract
1585     *  @param _fromContractAddr From chain smart contract address
1586     *  @param _fromChainId      Indicate from which chain current cross chain tx comes 
1587     *  @return                  true or false
1588     */
1589     function _executeCrossChainTx(address _toContract, bytes memory _method, bytes memory _args, bytes memory _fromContractAddr, uint64 _fromChainId) internal returns (bool){
1590         // Ensure the targeting contract gonna be invoked is indeed a contract rather than a normal account address
1591         require(Utils.isContract(_toContract), "The passed in address is not a contract!");
1592         bytes memory returnData;
1593         bool success;
1594         
1595         // The returnData will be bytes32, the last byte must be 01;
1596         (success, returnData) = _toContract.call(abi.encodePacked(bytes4(keccak256(abi.encodePacked(_method, "(bytes,bytes,uint64)"))), abi.encode(_args, _fromContractAddr, _fromChainId)));
1597         
1598         // Ensure the executation is successful
1599         require(success == true, "EthCrossChain call business contract failed");
1600         
1601         // Ensure the returned value is true
1602         require(returnData.length != 0, "No return value from business contract!");
1603         (bool res,) = ZeroCopySource.NextBool(returnData, 31);
1604         require(res == true, "EthCrossChain call business contract return is not true");
1605         
1606         return true;
1607     }
1608 }