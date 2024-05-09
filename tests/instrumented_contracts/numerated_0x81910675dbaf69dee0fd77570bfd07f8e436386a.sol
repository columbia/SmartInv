1 /**
2  *Submitted for verification at BscScan.com on 2021-12-29
3 */
4 
5 pragma solidity 0.6.12;
6 
7 library Utils {
8 
9     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
10     *  @param _bs   Source bytes array
11     *  @return      bytes32
12     */
13     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
14         require(_bs.length == 32, "bytes length is not 32.");
15         assembly {
16             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
17             value := mload(add(_bs, 0x20))
18         }
19     }
20 
21     /* @notice      Convert bytes to uint256
22     *  @param _b    Source bytes should have length of 32
23     *  @return      uint256
24     */
25     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
26         require(_bs.length == 32, "bytes length is not 32.");
27         assembly {
28             // load 32 bytes from memory starting from position _bs + 32
29             value := mload(add(_bs, 0x20))
30         }
31         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
32     }
33 
34     /* @notice      Convert uint256 to bytes
35     *  @param _b    uint256 that needs to be converted
36     *  @return      bytes
37     */
38     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
39         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
40         assembly {
41             // Get a location of some free memory and store it in result as
42             // Solidity does for memory variables.
43             bs := mload(0x40)
44             // Put 0x20 at the first word, the length of bytes for uint256 value
45             mstore(bs, 0x20)
46             //In the next word, put value in bytes format to the next 32 bytes
47             mstore(add(bs, 0x20), _value)
48             // Update the free-memory pointer by padding our last write location to 32 bytes
49             mstore(0x40, add(bs, 0x40))
50         }
51     }
52 
53     /* @notice      Convert bytes to address
54     *  @param _bs   Source bytes: bytes length must be 20
55     *  @return      Converted address from source bytes
56     */
57     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
58     {
59         require(_bs.length == 20, "bytes length does not match address");
60         assembly {
61             // for _bs, first word store _bs.length, second word store _bs.value
62             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
63             addr := mload(add(_bs, 0x14))
64         }
65 
66     }
67     
68     /* @notice      Convert address to bytes
69     *  @param _addr Address need to be converted
70     *  @return      Converted bytes from address
71     */
72     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
73         assembly {
74             // Get a location of some free memory and store it in result as
75             // Solidity does for memory variables.
76             bs := mload(0x40)
77             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
78             mstore(bs, 0x14)
79             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
80             mstore(add(bs, 0x20), shl(96, _addr))
81             // Update the free-memory pointer by padding our last write location to 32 bytes
82             mstore(0x40, add(bs, 0x40))
83        }
84     }
85 
86     /* @notice          Do hash leaf as the multi-chain does
87     *  @param _data     Data in bytes format
88     *  @return          Hashed value in bytes32 format
89     */
90     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
91         result = sha256(abi.encodePacked(byte(0x0), _data));
92     }
93 
94     /* @notice          Do hash children as the multi-chain does
95     *  @param _l        Left node
96     *  @param _r        Right node
97     *  @return          Hashed value in bytes32 format
98     */
99     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
100         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
101     }
102 
103     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
104                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
105     *  @param _preBytes     The bytes stored in storage
106     *  @param _postBytes    The bytes stored in memory
107     *  @return              Bool type indicating if they are equal
108     */
109     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
110         bool success = true;
111 
112         assembly {
113             // we know _preBytes_offset is 0
114             let fslot := sload(_preBytes_slot)
115             // Arrays of 31 bytes or less have an even value in their slot,
116             // while longer arrays have an odd value. The actual length is
117             // the slot divided by two for odd values, and the lowest order
118             // byte divided by two for even values.
119             // If the slot is even, bitwise and the slot with 255 and divide by
120             // two to get the length. If the slot is odd, bitwise and the slot
121             // with -1 and divide by two.
122             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
123             let mlength := mload(_postBytes)
124 
125             // if lengths don't match the arrays are not equal
126             switch eq(slength, mlength)
127             case 1 {
128                 // fslot can contain both the length and contents of the array
129                 // if slength < 32 bytes so let's prepare for that
130                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
131                 // slength != 0
132                 if iszero(iszero(slength)) {
133                     switch lt(slength, 32)
134                     case 1 {
135                         // blank the last byte which is the length
136                         fslot := mul(div(fslot, 0x100), 0x100)
137 
138                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
139                             // unsuccess:
140                             success := 0
141                         }
142                     }
143                     default {
144                         // cb is a circuit breaker in the for loop since there's
145                         //  no said feature for inline assembly loops
146                         // cb = 1 - don't breaker
147                         // cb = 0 - break
148                         let cb := 1
149 
150                         // get the keccak hash to get the contents of the array
151                         mstore(0x0, _preBytes_slot)
152                         let sc := keccak256(0x0, 0x20)
153 
154                         let mc := add(_postBytes, 0x20)
155                         let end := add(mc, mlength)
156 
157                         // the next line is the loop condition:
158                         // while(uint(mc < end) + cb == 2)
159                         for {} eq(add(lt(mc, end), cb), 2) {
160                             sc := add(sc, 1)
161                             mc := add(mc, 0x20)
162                         } {
163                             if iszero(eq(sload(sc), mload(mc))) {
164                                 // unsuccess:
165                                 success := 0
166                                 cb := 0
167                             }
168                         }
169                     }
170                 }
171             }
172             default {
173                 // unsuccess:
174                 success := 0
175             }
176         }
177 
178         return success;
179     }
180 
181     /* @notice              Slice the _bytes from _start index till the result has length of _length
182                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
183     *  @param _bytes        The original bytes needs to be sliced
184     *  @param _start        The index of _bytes for the start of sliced bytes
185     *  @param _length       The index of _bytes for the end of sliced bytes
186     *  @return              The sliced bytes
187     */
188     function slice(
189         bytes memory _bytes,
190         uint _start,
191         uint _length
192     )
193         internal
194         pure
195         returns (bytes memory)
196     {
197         require(_bytes.length >= (_start + _length));
198 
199         bytes memory tempBytes;
200 
201         assembly {
202             switch iszero(_length)
203             case 0 {
204                 // Get a location of some free memory and store it in tempBytes as
205                 // Solidity does for memory variables.
206                 tempBytes := mload(0x40)
207 
208                 // The first word of the slice result is potentially a partial
209                 // word read from the original array. To read it, we calculate
210                 // the length of that partial word and start copying that many
211                 // bytes into the array. The first word we copy will start with
212                 // data we don't care about, but the last `lengthmod` bytes will
213                 // land at the beginning of the contents of the new array. When
214                 // we're done copying, we overwrite the full first word with
215                 // the actual length of the slice.
216                 // lengthmod <= _length % 32
217                 let lengthmod := and(_length, 31)
218 
219                 // The multiplication in the next line is necessary
220                 // because when slicing multiples of 32 bytes (lengthmod == 0)
221                 // the following copy loop was copying the origin's length
222                 // and then ending prematurely not copying everything it should.
223                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
224                 let end := add(mc, _length)
225 
226                 for {
227                     // The multiplication in the next line has the same exact purpose
228                     // as the one above.
229                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
230                 } lt(mc, end) {
231                     mc := add(mc, 0x20)
232                     cc := add(cc, 0x20)
233                 } {
234                     mstore(mc, mload(cc))
235                 }
236 
237                 mstore(tempBytes, _length)
238 
239                 //update free-memory pointer
240                 //allocating the array padded to 32 bytes like the compiler does now
241                 mstore(0x40, and(add(mc, 31), not(31)))
242             }
243             //if we want a zero-length slice let's just return a zero-length array
244             default {
245                 tempBytes := mload(0x40)
246 
247                 mstore(0x40, add(tempBytes, 0x20))
248             }
249         }
250 
251         return tempBytes;
252     }
253     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
254     *  @param _keepers      The array consists of serveral address
255     *  @param _signers      Some specific addresses to be looked into
256     *  @param _m            The number requirement paramter
257     *  @return              True means containment, false meansdo do not contain.
258     */
259     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
260         uint m = 0;
261         for(uint i = 0; i < _signers.length; i++){
262             for (uint j = 0; j < _keepers.length; j++) {
263                 if (_signers[i] == _keepers[j]) {
264                     m++;
265                     delete _keepers[j];
266                 }
267             }
268         }
269         return m >= _m;
270     }
271 
272     /* @notice              TODO
273     *  @param key
274     *  @return
275     */
276     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
277          require(key.length >= 67, "key lenggh is too short");
278          newkey = slice(key, 0, 35);
279          if (uint8(key[66]) % 2 == 0){
280              newkey[2] = byte(0x02);
281          } else {
282              newkey[2] = byte(0x03);
283          }
284          return newkey;
285     }
286     
287     /**
288      * @dev Returns true if `account` is a contract.
289      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
290      *
291      * This test is non-exhaustive, and there may be false-negatives: during the
292      * execution of a contract's constructor, its address will be reported as
293      * not containing a contract.
294      *
295      * IMPORTANT: It is unsafe to assume that an address for which this
296      * function returns false is an externally-owned account (EOA) and not a
297      * contract.
298      */
299     function isContract(address account) internal view returns (bool) {
300         // This method relies in extcodesize, which returns 0 for contracts in
301         // construction, since the code is only stored at the end of the
302         // constructor execution.
303 
304         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
305         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
306         // for accounts without code, i.e. `keccak256('')`
307         bytes32 codehash;
308         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { codehash := extcodehash(account) }
311         return (codehash != 0x0 && codehash != accountHash);
312     }
313 }
314 
315 contract Context {
316     // Empty internal constructor, to prevent people from mistakenly deploying
317     // an instance of this contract, which should be used via inheritance.
318     constructor () internal { }
319     // solhint-disable-previous-line no-empty-blocks
320 
321     function _msgSender() internal view returns (address payable) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view returns (bytes memory) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 contract Ownable is Context {
332     address private _owner;
333 
334     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
335 
336     /**
337      * @dev Initializes the contract setting the deployer as the initial owner.
338      */
339     constructor () internal {
340         address msgSender = _msgSender();
341         _owner = msgSender;
342         emit OwnershipTransferred(address(0), msgSender);
343     }
344 
345     /**
346      * @dev Returns the address of the current owner.
347      */
348     function owner() public view returns (address) {
349         return _owner;
350     }
351 
352     /**
353      * @dev Throws if called by any account other than the owner.
354      */
355     modifier onlyOwner() {
356         require(isOwner(), "Ownable: caller is not the owner");
357         _;
358     }
359 
360     /**
361      * @dev Returns true if the caller is the current owner.
362      */
363     function isOwner() public view returns (bool) {
364         return _msgSender() == _owner;
365     }
366 
367     /**
368      * @dev Leaves the contract without owner. It will not be possible to call
369      * `onlyOwner` functions anymore. Can only be called by the current owner.
370      *
371      * NOTE: Renouncing ownership will leave the contract without an owner,
372      * thereby removing any functionality that is only available to the owner.
373      */
374     function renounceOwnership() public onlyOwner {
375         emit OwnershipTransferred(_owner, address(0));
376         _owner = address(0);
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public  onlyOwner {
384         _transferOwnership(newOwner);
385     }
386 
387     /**
388      * @dev Transfers ownership of the contract to a new account (`newOwner`).
389      */
390     function _transferOwnership(address newOwner) internal {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         emit OwnershipTransferred(_owner, newOwner);
393         _owner = newOwner;
394     }
395 }
396 
397 contract ReentrancyGuard {
398     bool private _notEntered;
399 
400     constructor () internal {
401         // Storing an initial non-zero value makes deployment a bit more
402         // expensive, but in exchange the refund on every call to nonReentrant
403         // will be lower in amount. Since refunds are capped to a percetange of
404         // the total transaction's gas, it is best to keep them low in cases
405         // like this one, to increase the likelihood of the full refund coming
406         // into effect.
407         _notEntered = true;
408     }
409 
410     /**
411      * @dev Prevents a contract from calling itself, directly or indirectly.
412      * Calling a `nonReentrant` function from another `nonReentrant`
413      * function is not supported. It is possible to prevent this from happening
414      * by making the `nonReentrant` function external, and make it call a
415      * `private` function that does the actual work.
416      */
417     modifier nonReentrant() {
418         // On the first call to nonReentrant, _notEntered will be true
419         require(_notEntered, "ReentrancyGuard: reentrant call");
420 
421         // Any calls to nonReentrant after this point will fail
422         _notEntered = false;
423 
424         _;
425 
426         // By storing the original value once again, a refund is triggered (see
427         // https://eips.ethereum.org/EIPS/eip-2200)
428         _notEntered = true;
429     }
430 }
431 
432 library SafeMath {
433     /**
434      * @dev Returns the addition of two unsigned integers, reverting on
435      * overflow.
436      *
437      * Counterpart to Solidity's `+` operator.
438      *
439      * Requirements:
440      * - Addition cannot overflow.
441      */
442     function add(uint256 a, uint256 b) internal pure returns (uint256) {
443         uint256 c = a + b;
444         require(c >= a, "SafeMath: addition overflow");
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      * - Subtraction cannot overflow.
457      */
458     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
459         return sub(a, b, "SafeMath: subtraction overflow");
460     }
461 
462     /**
463      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
464      * overflow (when the result is negative).
465      *
466      * Counterpart to Solidity's `-` operator.
467      *
468      * Requirements:
469      * - Subtraction cannot overflow.
470      *
471      * _Available since v2.4.0._
472      */
473     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
474         require(b <= a, errorMessage);
475         uint256 c = a - b;
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the multiplication of two unsigned integers, reverting on
482      * overflow.
483      *
484      * Counterpart to Solidity's `*` operator.
485      *
486      * Requirements:
487      * - Multiplication cannot overflow.
488      */
489     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
490         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
491         // benefit is lost if 'b' is also tested.
492         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
493         if (a == 0) {
494             return 0;
495         }
496 
497         uint256 c = a * b;
498         require(c / a == b, "SafeMath: multiplication overflow");
499 
500         return c;
501     }
502 
503     /**
504      * @dev Returns the integer division of two unsigned integers. Reverts on
505      * division by zero. The result is rounded towards zero.
506      *
507      * Counterpart to Solidity's `/` operator. Note: this function uses a
508      * `revert` opcode (which leaves remaining gas untouched) while Solidity
509      * uses an invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      * - The divisor cannot be zero.
513      */
514     function div(uint256 a, uint256 b) internal pure returns (uint256) {
515         return div(a, b, "SafeMath: division by zero");
516     }
517 
518     /**
519      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
520      * division by zero. The result is rounded towards zero.
521      *
522      * Counterpart to Solidity's `/` operator. Note: this function uses a
523      * `revert` opcode (which leaves remaining gas untouched) while Solidity
524      * uses an invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      * - The divisor cannot be zero.
528      *
529      * _Available since v2.4.0._
530      */
531     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
532         // Solidity only automatically asserts when dividing by 0
533         require(b != 0, errorMessage);
534         uint256 c = a / b;
535         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
536 
537         return c;
538     }
539 
540     /**
541      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
542      * Reverts when dividing by zero.
543      *
544      * Counterpart to Solidity's `%` operator. This function uses a `revert`
545      * opcode (which leaves remaining gas untouched) while Solidity uses an
546      * invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      * - The divisor cannot be zero.
550      */
551     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
552         return mod(a, b, "SafeMath: modulo by zero");
553     }
554 
555     /**
556      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
557      * Reverts with custom message when dividing by zero.
558      *
559      * Counterpart to Solidity's `%` operator. This function uses a `revert`
560      * opcode (which leaves remaining gas untouched) while Solidity uses an
561      * invalid opcode to revert (consuming all remaining gas).
562      *
563      * Requirements:
564      * - The divisor cannot be zero.
565      *
566      * _Available since v2.4.0._
567      */
568     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b != 0, errorMessage);
570         return a % b;
571     }
572 }
573 
574 
575 contract Pausable is Context {
576     /**
577      * @dev Emitted when the pause is triggered by a pauser (`account`).
578      */
579     event Paused(address account);
580 
581     /**
582      * @dev Emitted when the pause is lifted by a pauser (`account`).
583      */
584     event Unpaused(address account);
585 
586     bool private _paused;
587 
588     /**
589      * @dev Initializes the contract in unpaused state.
590      */
591     constructor () internal {
592         _paused = false;
593     }
594 
595     /**
596      * @dev Returns true if the contract is paused, and false otherwise.
597      */
598     function paused() public view returns (bool) {
599         return _paused;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is not paused.
604      */
605     modifier whenNotPaused() {
606         require(!_paused, "Pausable: paused");
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      */
613     modifier whenPaused() {
614         require(_paused, "Pausable: not paused");
615         _;
616     }
617 
618     /**
619      * @dev Called to pause, triggers stopped state.
620      */
621     function _pause() internal whenNotPaused {
622         _paused = true;
623         emit Paused(_msgSender());
624     }
625 
626     /**
627      * @dev Called to unpause, returns to normal state.
628      */
629     function _unpause() internal whenPaused {
630         _paused = false;
631         emit Unpaused(_msgSender());
632     }
633 }
634 
635 interface IERC20 {
636     /**
637      * @dev Returns the amount of tokens in existence.
638      */
639     function totalSupply() external view returns (uint256);
640 
641     /**
642      * @dev Returns the amount of tokens owned by `account`.
643      */
644     function balanceOf(address account) external view returns (uint256);
645 
646     /**
647      * @dev Moves `amount` tokens from the caller's account to `recipient`.
648      *
649      * Returns a boolean value indicating whether the operation succeeded.
650      *
651      * Emits a {Transfer} event.
652      */
653     function transfer(address recipient, uint256 amount) external returns (bool);
654 
655     /**
656      * @dev Returns the remaining number of tokens that `spender` will be
657      * allowed to spend on behalf of `owner` through {transferFrom}. This is
658      * zero by default.
659      *
660      * This value changes when {approve} or {transferFrom} are called.
661      */
662     function allowance(address owner, address spender) external view returns (uint256);
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
666      *
667      * Returns a boolean value indicating whether the operation succeeded.
668      *
669      * IMPORTANT: Beware that changing an allowance with this method brings the risk
670      * that someone may use both the old and the new allowance by unfortunate
671      * transaction ordering. One possible solution to mitigate this race
672      * condition is to first reduce the spender's allowance to 0 and set the
673      * desired value afterwards:
674      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address spender, uint256 amount) external returns (bool);
679 
680     /**
681      * @dev Moves `amount` tokens from `sender` to `recipient` using the
682      * allowance mechanism. `amount` is then deducted from the caller's
683      * allowance.
684      *
685      * Returns a boolean value indicating whether the operation succeeded.
686      *
687      * Emits a {Transfer} event.
688      */
689     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
690 
691     /**
692      * @dev Emitted when `value` tokens are moved from one account (`from`) to
693      * another (`to`).
694      *
695      * Note that `value` may be zero.
696      */
697     event Transfer(address indexed from, address indexed to, uint256 value);
698 
699     /**
700      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
701      * a call to {approve}. `value` is the new allowance.
702      */
703     event Approval(address indexed owner, address indexed spender, uint256 value);
704 }
705 
706 
707 library SafeERC20 {
708     using SafeMath for uint256;
709 
710     function safeTransfer(IERC20 token, address to, uint256 value) internal {
711         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
712     }
713 
714     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
715         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
716     }
717 
718     function safeApprove(IERC20 token, address spender, uint256 value) internal {
719         // safeApprove should only be called when setting an initial allowance,
720         // or when resetting it to zero. To increase and decrease it, use
721         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
722         // solhint-disable-next-line max-line-length
723         require((value == 0) || (token.allowance(address(this), spender) == 0),
724             "SafeERC20: approve from non-zero to non-zero allowance"
725         );
726         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
727     }
728 
729     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
730         uint256 newAllowance = token.allowance(address(this), spender).add(value);
731         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
732     }
733 
734     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
735         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
736         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
737     }
738 
739     /**
740      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
741      * on the return value: the return value is optional (but if data is returned, it must not be false).
742      * @param token The token targeted by the call.
743      * @param data The call data (encoded using abi.encode or one of its variants).
744      */
745     function callOptionalReturn(IERC20 token, bytes memory data) private {
746         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
747         // we're implementing it ourselves.
748 
749         // A Solidity high level call has three parts:
750         //  1. The target address is checked to verify it contains contract code
751         //  2. The call itself is made, and success asserted
752         //  3. The return value is decoded, which in turn checks the size of the returned data.
753         // solhint-disable-next-line max-line-length
754         require(Utils.isContract(address(token)), "SafeERC20: call to non-contract");
755 
756         // solhint-disable-next-line avoid-low-level-calls
757         (bool success, bytes memory returndata) = address(token).call(data);
758         require(success, "SafeERC20: low-level call failed");
759 
760         if (returndata.length > 0) { // Return data is optional
761             // solhint-disable-next-line max-line-length
762             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
763         }
764     }
765 }
766 
767 interface ILockProxy {
768     function managerProxyContract() external view returns (address);
769     function proxyHashMap(uint64) external view returns (bytes memory);
770     function assetHashMap(address, uint64) external view returns (bytes memory);
771     function getBalanceFor(address) external view returns (uint256);
772     function setManagerProxy(
773         address eccmpAddr
774     ) external;
775     
776     function bindProxyHash(
777         uint64 toChainId, 
778         bytes calldata targetProxyHash
779     ) external returns (bool);
780 
781     function bindAssetHash(
782         address fromAssetHash, 
783         uint64 toChainId, 
784         bytes calldata toAssetHash
785     ) external returns (bool);
786 
787     function lock(
788         address fromAssetHash, 
789         uint64 toChainId, 
790         bytes calldata toAddress, 
791         uint256 amount
792     ) external payable returns (bool);
793 }
794 
795 contract PolyWrapper is Ownable, Pausable, ReentrancyGuard {
796     using SafeMath for uint;
797     using SafeERC20 for IERC20;
798     
799     uint public maxLockProxyIndex = 0;
800     uint public chainId;
801     address public feeCollector;
802     
803     mapping(uint => address) public lockProxyIndexMap;
804 
805     constructor(address _owner, uint _chainId) public {
806         require(_chainId != 0, "!legal");
807         transferOwnership(_owner);
808         chainId = _chainId;
809     }
810 
811     function setFeeCollector(address collector) external onlyOwner {
812         require(collector != address(0), "emtpy address");
813         feeCollector = collector;
814     }
815 
816     function resetLockProxy(uint index, address _lockProxy) external onlyOwner {
817         require(_lockProxy != address(0));
818         require(lockProxyIndexMap[index] != address(0), "no lockproxy exsist in given index");
819         lockProxyIndexMap[index] = _lockProxy;
820         require(ILockProxy(_lockProxy).managerProxyContract() != address(0), "not lockproxy");
821     }
822 
823     function addLockProxy(address _lockProxy) external onlyOwner {
824         require(_lockProxy != address(0));
825         lockProxyIndexMap[maxLockProxyIndex++] = _lockProxy;
826         require(ILockProxy(_lockProxy).managerProxyContract() != address(0), "not lockproxy");
827     }
828 
829     function pause() external onlyOwner {
830         _pause();
831     }
832 
833     function unpause() external onlyOwner {
834         _unpause();
835     }
836 
837 
838     function extractFee(address token) external {
839         require(msg.sender == feeCollector, "!feeCollector");
840         if (token == address(0)) {
841             payable(msg.sender).transfer(address(this).balance);
842         } else {
843             IERC20(token).safeTransfer(feeCollector, IERC20(token).balanceOf(address(this)));
844         }
845     }
846     
847     function lock(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount, uint fee, uint id) external payable nonReentrant whenNotPaused {
848         
849         require(toChainId != chainId && toChainId != 0, "!toChainId");
850         require(toAddress.length !=0, "empty toAddress");
851         address addr;
852         assembly { addr := mload(add(toAddress,0x14)) }
853         require(addr != address(0),"zero toAddress");
854         
855         _pull(fromAsset, amount);
856 
857         amount = _checkoutFee(fromAsset, amount, fee);
858         
859         address lockProxy = _getSupportLockProxy(fromAsset, toChainId);
860         _push(fromAsset, toChainId, toAddress, amount, lockProxy);
861 
862         emit PolyWrapperLock(fromAsset, msg.sender, toChainId, toAddress, amount, fee, id);
863     }
864     
865     function specifiedLock(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount, uint fee, uint id, address lockProxy) external payable nonReentrant whenNotPaused {
866         
867         require(toChainId != chainId && toChainId != 0, "!toChainId");
868         require(toAddress.length !=0, "empty toAddress");
869         address addr;
870         assembly { addr := mload(add(toAddress,0x14)) }
871         require(addr != address(0),"zero toAddress");
872         
873         _pull(fromAsset, amount);
874 
875         amount = _checkoutFee(fromAsset, amount, fee);
876         
877         require(isValidLockProxy(lockProxy),"invalid lockProxy");
878         _push(fromAsset, toChainId, toAddress, amount, lockProxy);
879 
880         emit PolyWrapperLock(fromAsset, msg.sender, toChainId, toAddress, amount, fee, id);
881     }
882 
883     function speedUp(address fromAsset, bytes memory txHash, uint fee) external payable nonReentrant whenNotPaused {
884         _pull(fromAsset, fee);
885         emit PolyWrapperSpeedUp(fromAsset, txHash, msg.sender, fee);
886     }
887 
888     function _pull(address fromAsset, uint amount) internal {
889         if (fromAsset == address(0)) {
890             require(msg.value == amount, "insufficient ether");
891         } else {
892             IERC20(fromAsset).safeTransferFrom(msg.sender, address(this), amount);
893         }
894     }
895 
896     // take fee in the form of ether
897     function _checkoutFee(address fromAsset, uint amount, uint fee) internal view returns (uint) {
898         if (fromAsset == address(0)) {
899             require(msg.value >= amount, "insufficient ether");
900             require(amount > fee, "amount less than fee");
901             return amount.sub(fee);
902         } else {
903             require(msg.value >= fee, "insufficient ether");
904             return amount;
905         }
906     }
907 
908     function _push(address fromAsset, uint64 toChainId, bytes memory toAddress, uint amount, address lockProxyAddress) internal {
909         ILockProxy lockProxy = ILockProxy(lockProxyAddress);
910         if (fromAsset == address(0)) {
911             require(lockProxy.lock{value: amount}(fromAsset, toChainId, toAddress, amount), "lock ether fail");
912         } else {
913             IERC20(fromAsset).safeApprove(address(lockProxy), 0);
914             IERC20(fromAsset).safeApprove(address(lockProxy), amount);
915             require(lockProxy.lock(fromAsset, toChainId, toAddress, amount), "lock erc20 fail");
916         }
917     }
918 
919     function isValidLockProxy(address lockProxy) public view returns(bool) {
920         for (uint i=0;i<maxLockProxyIndex;i++) {
921             if (lockProxy == lockProxyIndexMap[i]) {
922                 return true;
923             }
924         }
925         return false;
926     }
927 
928     function _getSupportLockProxy(address fromAsset, uint64 toChainId) internal view returns(address) {
929         for (uint i=0;i<maxLockProxyIndex;i++) {
930             address lockProxy = lockProxyIndexMap[i];
931             if (ILockProxy(lockProxy).assetHashMap(fromAsset, toChainId).length != 0) {
932                 return lockProxy;
933             }
934         }
935         revert("No LockProxy Support this cross txn");
936     } 
937 
938     function getBalanceBatch(address[] memory assets, address richGuy) public view returns(uint[] memory) {
939         uint[] memory res = new uint[](assets.length);
940         for (uint i=0;i<assets.length;i++) {
941             if (assets[i] == address(0)) {
942                 res[i] = richGuy.balance;
943             } else {
944                 res[i] = IERC20(assets[i]).balanceOf(richGuy);
945             }
946         }
947         return res;
948     }
949 
950     event PolyWrapperLock(address indexed fromAsset, address indexed sender, uint64 toChainId, bytes toAddress, uint net, uint fee, uint id);
951     event PolyWrapperSpeedUp(address indexed fromAsset, bytes indexed txHash, address indexed sender, uint efee);
952 
953 }