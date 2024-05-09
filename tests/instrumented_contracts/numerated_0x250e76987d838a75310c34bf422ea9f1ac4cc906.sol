1 pragma solidity ^0.5.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  * Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(isOwner(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Returns true if the caller is the current owner.
72      */
73     function isOwner() public view returns (bool) {
74         return _msgSender() == _owner;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public  onlyOwner {
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      */
100     function _transferOwnership(address newOwner) internal {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105 }
106 pragma solidity ^0.5.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      *
160      * _Available since v2.4.0._
161      */
162     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      * - The divisor cannot be zero.
217      *
218      * _Available since v2.4.0._
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b != 0, errorMessage);
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      * - The divisor cannot be zero.
254      *
255      * _Available since v2.4.0._
256      */
257     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b != 0, errorMessage);
259         return a % b;
260     }
261 }
262 pragma solidity ^0.5.0;
263 
264 
265 library Utils {
266 
267     /* @notice      Convert the bytes array to bytes32 type, the bytes array length must be 32
268     *  @param _bs   Source bytes array
269     *  @return      bytes32
270     */
271     function bytesToBytes32(bytes memory _bs) internal pure returns (bytes32 value) {
272         require(_bs.length == 32, "bytes length is not 32.");
273         assembly {
274             // load 32 bytes from memory starting from position _bs + 0x20 since the first 0x20 bytes stores _bs length
275             value := mload(add(_bs, 0x20))
276         }
277     }
278 
279     /* @notice      Convert bytes to uint256
280     *  @param _b    Source bytes should have length of 32
281     *  @return      uint256
282     */
283     function bytesToUint256(bytes memory _bs) internal pure returns (uint256 value) {
284         require(_bs.length == 32, "bytes length is not 32.");
285         assembly {
286             // load 32 bytes from memory starting from position _bs + 32
287             value := mload(add(_bs, 0x20))
288         }
289         require(value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
290     }
291 
292     /* @notice      Convert uint256 to bytes
293     *  @param _b    uint256 that needs to be converted
294     *  @return      bytes
295     */
296     function uint256ToBytes(uint256 _value) internal pure returns (bytes memory bs) {
297         require(_value <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
298         assembly {
299             // Get a location of some free memory and store it in result as
300             // Solidity does for memory variables.
301             bs := mload(0x40)
302             // Put 0x20 at the first word, the length of bytes for uint256 value
303             mstore(bs, 0x20)
304             //In the next word, put value in bytes format to the next 32 bytes
305             mstore(add(bs, 0x20), _value)
306             // Update the free-memory pointer by padding our last write location to 32 bytes
307             mstore(0x40, add(bs, 0x40))
308         }
309     }
310 
311     /* @notice      Convert bytes to address
312     *  @param _bs   Source bytes: bytes length must be 20
313     *  @return      Converted address from source bytes
314     */
315     function bytesToAddress(bytes memory _bs) internal pure returns (address addr)
316     {
317         require(_bs.length == 20, "bytes length does not match address");
318         assembly {
319             // for _bs, first word store _bs.length, second word store _bs.value
320             // load 32 bytes from mem[_bs+20], convert it into Uint160, meaning we take last 20 bytes as addr (address).
321             addr := mload(add(_bs, 0x14))
322         }
323 
324     }
325     
326     /* @notice      Convert address to bytes
327     *  @param _addr Address need to be converted
328     *  @return      Converted bytes from address
329     */
330     function addressToBytes(address _addr) internal pure returns (bytes memory bs){
331         assembly {
332             // Get a location of some free memory and store it in result as
333             // Solidity does for memory variables.
334             bs := mload(0x40)
335             // Put 20 (address byte length) at the first word, the length of bytes for uint256 value
336             mstore(bs, 0x14)
337             // logical shift left _a by 12 bytes, change _a from right-aligned to left-aligned
338             mstore(add(bs, 0x20), shl(96, _addr))
339             // Update the free-memory pointer by padding our last write location to 32 bytes
340             mstore(0x40, add(bs, 0x40))
341        }
342     }
343 
344     /* @notice          Do hash leaf as the multi-chain does
345     *  @param _data     Data in bytes format
346     *  @return          Hashed value in bytes32 format
347     */
348     function hashLeaf(bytes memory _data) internal pure returns (bytes32 result)  {
349         result = sha256(abi.encodePacked(byte(0x0), _data));
350     }
351 
352     /* @notice          Do hash children as the multi-chain does
353     *  @param _l        Left node
354     *  @param _r        Right node
355     *  @return          Hashed value in bytes32 format
356     */
357     function hashChildren(bytes32 _l, bytes32  _r) internal pure returns (bytes32 result)  {
358         result = sha256(abi.encodePacked(bytes1(0x01), _l, _r));
359     }
360 
361     /* @notice              Compare if two bytes are equal, which are in storage and memory, seperately
362                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L368
363     *  @param _preBytes     The bytes stored in storage
364     *  @param _postBytes    The bytes stored in memory
365     *  @return              Bool type indicating if they are equal
366     */
367     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
368         bool success = true;
369 
370         assembly {
371             // we know _preBytes_offset is 0
372             let fslot := sload(_preBytes_slot)
373             // Arrays of 31 bytes or less have an even value in their slot,
374             // while longer arrays have an odd value. The actual length is
375             // the slot divided by two for odd values, and the lowest order
376             // byte divided by two for even values.
377             // If the slot is even, bitwise and the slot with 255 and divide by
378             // two to get the length. If the slot is odd, bitwise and the slot
379             // with -1 and divide by two.
380             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
381             let mlength := mload(_postBytes)
382 
383             // if lengths don't match the arrays are not equal
384             switch eq(slength, mlength)
385             case 1 {
386                 // fslot can contain both the length and contents of the array
387                 // if slength < 32 bytes so let's prepare for that
388                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
389                 // slength != 0
390                 if iszero(iszero(slength)) {
391                     switch lt(slength, 32)
392                     case 1 {
393                         // blank the last byte which is the length
394                         fslot := mul(div(fslot, 0x100), 0x100)
395 
396                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
397                             // unsuccess:
398                             success := 0
399                         }
400                     }
401                     default {
402                         // cb is a circuit breaker in the for loop since there's
403                         //  no said feature for inline assembly loops
404                         // cb = 1 - don't breaker
405                         // cb = 0 - break
406                         let cb := 1
407 
408                         // get the keccak hash to get the contents of the array
409                         mstore(0x0, _preBytes_slot)
410                         let sc := keccak256(0x0, 0x20)
411 
412                         let mc := add(_postBytes, 0x20)
413                         let end := add(mc, mlength)
414 
415                         // the next line is the loop condition:
416                         // while(uint(mc < end) + cb == 2)
417                         for {} eq(add(lt(mc, end), cb), 2) {
418                             sc := add(sc, 1)
419                             mc := add(mc, 0x20)
420                         } {
421                             if iszero(eq(sload(sc), mload(mc))) {
422                                 // unsuccess:
423                                 success := 0
424                                 cb := 0
425                             }
426                         }
427                     }
428                 }
429             }
430             default {
431                 // unsuccess:
432                 success := 0
433             }
434         }
435 
436         return success;
437     }
438 
439     /* @notice              Slice the _bytes from _start index till the result has length of _length
440                             Refer from https://github.com/summa-tx/bitcoin-spv/blob/master/solidity/contracts/BytesLib.sol#L246
441     *  @param _bytes        The original bytes needs to be sliced
442     *  @param _start        The index of _bytes for the start of sliced bytes
443     *  @param _length       The index of _bytes for the end of sliced bytes
444     *  @return              The sliced bytes
445     */
446     function slice(
447         bytes memory _bytes,
448         uint _start,
449         uint _length
450     )
451         internal
452         pure
453         returns (bytes memory)
454     {
455         require(_bytes.length >= (_start + _length));
456 
457         bytes memory tempBytes;
458 
459         assembly {
460             switch iszero(_length)
461             case 0 {
462                 // Get a location of some free memory and store it in tempBytes as
463                 // Solidity does for memory variables.
464                 tempBytes := mload(0x40)
465 
466                 // The first word of the slice result is potentially a partial
467                 // word read from the original array. To read it, we calculate
468                 // the length of that partial word and start copying that many
469                 // bytes into the array. The first word we copy will start with
470                 // data we don't care about, but the last `lengthmod` bytes will
471                 // land at the beginning of the contents of the new array. When
472                 // we're done copying, we overwrite the full first word with
473                 // the actual length of the slice.
474                 // lengthmod <= _length % 32
475                 let lengthmod := and(_length, 31)
476 
477                 // The multiplication in the next line is necessary
478                 // because when slicing multiples of 32 bytes (lengthmod == 0)
479                 // the following copy loop was copying the origin's length
480                 // and then ending prematurely not copying everything it should.
481                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
482                 let end := add(mc, _length)
483 
484                 for {
485                     // The multiplication in the next line has the same exact purpose
486                     // as the one above.
487                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
488                 } lt(mc, end) {
489                     mc := add(mc, 0x20)
490                     cc := add(cc, 0x20)
491                 } {
492                     mstore(mc, mload(cc))
493                 }
494 
495                 mstore(tempBytes, _length)
496 
497                 //update free-memory pointer
498                 //allocating the array padded to 32 bytes like the compiler does now
499                 mstore(0x40, and(add(mc, 31), not(31)))
500             }
501             //if we want a zero-length slice let's just return a zero-length array
502             default {
503                 tempBytes := mload(0x40)
504 
505                 mstore(0x40, add(tempBytes, 0x20))
506             }
507         }
508 
509         return tempBytes;
510     }
511     /* @notice              Check if the elements number of _signers within _keepers array is no less than _m
512     *  @param _keepers      The array consists of serveral address
513     *  @param _signers      Some specific addresses to be looked into
514     *  @param _m            The number requirement paramter
515     *  @return              True means containment, false meansdo do not contain.
516     */
517     function containMAddresses(address[] memory _keepers, address[] memory _signers, uint _m) internal pure returns (bool){
518         uint m = 0;
519         for(uint i = 0; i < _signers.length; i++){
520             for (uint j = 0; j < _keepers.length; j++) {
521                 if (_signers[i] == _keepers[j]) {
522                     m++;
523                     delete _keepers[j];
524                 }
525             }
526         }
527         return m >= _m;
528     }
529 
530     /* @notice              TODO
531     *  @param key
532     *  @return
533     */
534     function compressMCPubKey(bytes memory key) internal pure returns (bytes memory newkey) {
535          require(key.length >= 67, "key lenggh is too short");
536          newkey = slice(key, 0, 35);
537          if (uint8(key[66]) % 2 == 0){
538              newkey[2] = byte(0x02);
539          } else {
540              newkey[2] = byte(0x03);
541          }
542          return newkey;
543     }
544     
545     /**
546      * @dev Returns true if `account` is a contract.
547      *      Refer from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol#L18
548      *
549      * This test is non-exhaustive, and there may be false-negatives: during the
550      * execution of a contract's constructor, its address will be reported as
551      * not containing a contract.
552      *
553      * IMPORTANT: It is unsafe to assume that an address for which this
554      * function returns false is an externally-owned account (EOA) and not a
555      * contract.
556      */
557     function isContract(address account) internal view returns (bool) {
558         // This method relies in extcodesize, which returns 0 for contracts in
559         // construction, since the code is only stored at the end of the
560         // constructor execution.
561 
562         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
563         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
564         // for accounts without code, i.e. `keccak256('')`
565         bytes32 codehash;
566         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
567         // solhint-disable-next-line no-inline-assembly
568         assembly { codehash := extcodehash(account) }
569         return (codehash != 0x0 && codehash != accountHash);
570     }
571 }
572 pragma solidity ^0.5.0;
573 
574 /**
575  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
576  * the optional functions; to access them see {ERC20Detailed}.
577  */
578 interface IERC20 {
579     /**
580      * @dev Returns the amount of tokens in existence.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     /**
585      * @dev Returns the amount of tokens owned by `account`.
586      */
587     function balanceOf(address account) external view returns (uint256);
588 
589     /**
590      * @dev Moves `amount` tokens from the caller's account to `recipient`.
591      *
592      * Returns a boolean value indicating whether the operation succeeded.
593      *
594      * Emits a {Transfer} event.
595      */
596     function transfer(address recipient, uint256 amount) external returns (bool);
597 
598     /**
599      * @dev Returns the remaining number of tokens that `spender` will be
600      * allowed to spend on behalf of `owner` through {transferFrom}. This is
601      * zero by default.
602      *
603      * This value changes when {approve} or {transferFrom} are called.
604      */
605     function allowance(address owner, address spender) external view returns (uint256);
606 
607     /**
608      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
609      *
610      * Returns a boolean value indicating whether the operation succeeded.
611      *
612      * IMPORTANT: Beware that changing an allowance with this method brings the risk
613      * that someone may use both the old and the new allowance by unfortunate
614      * transaction ordering. One possible solution to mitigate this race
615      * condition is to first reduce the spender's allowance to 0 and set the
616      * desired value afterwards:
617      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address spender, uint256 amount) external returns (bool);
622 
623     /**
624      * @dev Moves `amount` tokens from `sender` to `recipient` using the
625      * allowance mechanism. `amount` is then deducted from the caller's
626      * allowance.
627      *
628      * Returns a boolean value indicating whether the operation succeeded.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
633 
634     /**
635      * @dev Emitted when `value` tokens are moved from one account (`from`) to
636      * another (`to`).
637      *
638      * Note that `value` may be zero.
639      */
640     event Transfer(address indexed from, address indexed to, uint256 value);
641 
642     /**
643      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
644      * a call to {approve}. `value` is the new allowance.
645      */
646     event Approval(address indexed owner, address indexed spender, uint256 value);
647 }
648 /**
649  * @title SafeERC20
650  * @dev Wrappers around ERC20 operations that throw on failure (when the token
651  * contract returns false). Tokens that return no value (and instead revert or
652  * throw on failure) are also supported, non-reverting calls are assumed to be
653  * successful.
654  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
655  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
656  */
657 library SafeERC20 {
658     using SafeMath for uint256;
659 
660     function safeTransfer(IERC20 token, address to, uint256 value) internal {
661         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
662     }
663 
664     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
665         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
666     }
667 
668     function safeApprove(IERC20 token, address spender, uint256 value) internal {
669         // safeApprove should only be called when setting an initial allowance,
670         // or when resetting it to zero. To increase and decrease it, use
671         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
672         // solhint-disable-next-line max-line-length
673         require((value == 0) || (token.allowance(address(this), spender) == 0),
674             "SafeERC20: approve from non-zero to non-zero allowance"
675         );
676         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
677     }
678 
679     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
680         uint256 newAllowance = token.allowance(address(this), spender).add(value);
681         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
682     }
683 
684     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
685         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
686         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
687     }
688 
689     /**
690      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
691      * on the return value: the return value is optional (but if data is returned, it must not be false).
692      * @param token The token targeted by the call.
693      * @param data The call data (encoded using abi.encode or one of its variants).
694      */
695     function callOptionalReturn(IERC20 token, bytes memory data) private {
696         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
697         // we're implementing it ourselves.
698 
699         // A Solidity high level call has three parts:
700         //  1. The target address is checked to verify it contains contract code
701         //  2. The call itself is made, and success asserted
702         //  3. The return value is decoded, which in turn checks the size of the returned data.
703         // solhint-disable-next-line max-line-length
704         require(Utils.isContract(address(token)), "SafeERC20: call to non-contract");
705 
706         // solhint-disable-next-line avoid-low-level-calls
707         (bool success, bytes memory returndata) = address(token).call(data);
708         require(success, "SafeERC20: low-level call failed");
709 
710         if (returndata.length > 0) { // Return data is optional
711             // solhint-disable-next-line max-line-length
712             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
713         }
714     }
715 }
716 pragma solidity ^0.5.0;
717 
718 /**
719  * @dev Interface of the EthCrossChainManager contract for business contract like LockProxy to request cross chain transaction
720  */
721 interface IEthCrossChainManager {
722     function crossChain(uint64 _toChainId, bytes calldata _toContract, bytes calldata _method, bytes calldata _txData) external returns (bool);
723 }
724 pragma solidity ^0.5.0;
725 
726 /**
727  * @dev Interface of the EthCrossChainManagerProxy for business contract like LockProxy to obtain the reliable EthCrossChainManager contract hash.
728  */
729 interface IEthCrossChainManagerProxy {
730     function getEthCrossChainManager() external view returns (address);
731 }
732 pragma solidity ^0.5.0;
733 
734 /**
735  * @dev Wrappers over decoding and deserialization operation from bytes into bassic types in Solidity for PolyNetwork cross chain utility.
736  *
737  * Decode into basic types in Solidity from bytes easily. It's designed to be used 
738  * for PolyNetwork cross chain application, and the decoding rules on Ethereum chain 
739  * and the encoding rule on other chains should be consistent, and . Here we
740  * follow the underlying deserialization rule with implementation found here: 
741  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_source.go
742  *
743  * Using this library instead of the unchecked serialization method can help reduce
744  * the risk of serious bugs and handfule, so it's recommended to use it.
745  *
746  * Please note that risk can be minimized, yet not eliminated.
747  */
748 library ZeroCopySource {
749     /* @notice              Read next byte as boolean type starting at offset from buff
750     *  @param buff          Source bytes array
751     *  @param offset        The position from where we read the boolean value
752     *  @return              The the read boolean value and new offset
753     */
754     function NextBool(bytes memory buff, uint256 offset) internal pure returns(bool, uint256) {
755         require(offset + 1 <= buff.length && offset < offset + 1, "Offset exceeds limit");
756         // byte === bytes1
757         byte v;
758         assembly{
759             v := mload(add(add(buff, 0x20), offset))
760         }
761         bool value;
762         if (v == 0x01) {
763 		    value = true;
764     	} else if (v == 0x00) {
765             value = false;
766         } else {
767             revert("NextBool value error");
768         }
769         return (value, offset + 1);
770     }
771 
772     /* @notice              Read next byte starting at offset from buff
773     *  @param buff          Source bytes array
774     *  @param offset        The position from where we read the byte value
775     *  @return              The read byte value and new offset
776     */
777     function NextByte(bytes memory buff, uint256 offset) internal pure returns (byte, uint256) {
778         require(offset + 1 <= buff.length && offset < offset + 1, "NextByte, Offset exceeds maximum");
779         byte v;
780         assembly{
781             v := mload(add(add(buff, 0x20), offset))
782         }
783         return (v, offset + 1);
784     }
785 
786     /* @notice              Read next byte as uint8 starting at offset from buff
787     *  @param buff          Source bytes array
788     *  @param offset        The position from where we read the byte value
789     *  @return              The read uint8 value and new offset
790     */
791     function NextUint8(bytes memory buff, uint256 offset) internal pure returns (uint8, uint256) {
792         require(offset + 1 <= buff.length && offset < offset + 1, "NextUint8, Offset exceeds maximum");
793         uint8 v;
794         assembly{
795             let tmpbytes := mload(0x40)
796             let bvalue := mload(add(add(buff, 0x20), offset))
797             mstore8(tmpbytes, byte(0, bvalue))
798             mstore(0x40, add(tmpbytes, 0x01))
799             v := mload(sub(tmpbytes, 0x1f))
800         }
801         return (v, offset + 1);
802     }
803 
804     /* @notice              Read next two bytes as uint16 type starting from offset
805     *  @param buff          Source bytes array
806     *  @param offset        The position from where we read the uint16 value
807     *  @return              The read uint16 value and updated offset
808     */
809     function NextUint16(bytes memory buff, uint256 offset) internal pure returns (uint16, uint256) {
810         require(offset + 2 <= buff.length && offset < offset + 2, "NextUint16, offset exceeds maximum");
811         
812         uint16 v;
813         assembly {
814             let tmpbytes := mload(0x40)
815             let bvalue := mload(add(add(buff, 0x20), offset))
816             mstore8(tmpbytes, byte(0x01, bvalue))
817             mstore8(add(tmpbytes, 0x01), byte(0, bvalue))
818             mstore(0x40, add(tmpbytes, 0x02))
819             v := mload(sub(tmpbytes, 0x1e))
820         }
821         return (v, offset + 2);
822     }
823 
824 
825     /* @notice              Read next four bytes as uint32 type starting from offset
826     *  @param buff          Source bytes array
827     *  @param offset        The position from where we read the uint32 value
828     *  @return              The read uint32 value and updated offset
829     */
830     function NextUint32(bytes memory buff, uint256 offset) internal pure returns (uint32, uint256) {
831         require(offset + 4 <= buff.length && offset < offset + 4, "NextUint32, offset exceeds maximum");
832         uint32 v;
833         assembly {
834             let tmpbytes := mload(0x40)
835             let byteLen := 0x04
836             for {
837                 let tindex := 0x00
838                 let bindex := sub(byteLen, 0x01)
839                 let bvalue := mload(add(add(buff, 0x20), offset))
840             } lt(tindex, byteLen) {
841                 tindex := add(tindex, 0x01)
842                 bindex := sub(bindex, 0x01)
843             }{
844                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
845             }
846             mstore(0x40, add(tmpbytes, byteLen))
847             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
848         }
849         return (v, offset + 4);
850     }
851 
852     /* @notice              Read next eight bytes as uint64 type starting from offset
853     *  @param buff          Source bytes array
854     *  @param offset        The position from where we read the uint64 value
855     *  @return              The read uint64 value and updated offset
856     */
857     function NextUint64(bytes memory buff, uint256 offset) internal pure returns (uint64, uint256) {
858         require(offset + 8 <= buff.length && offset < offset + 8, "NextUint64, offset exceeds maximum");
859         uint64 v;
860         assembly {
861             let tmpbytes := mload(0x40)
862             let byteLen := 0x08
863             for {
864                 let tindex := 0x00
865                 let bindex := sub(byteLen, 0x01)
866                 let bvalue := mload(add(add(buff, 0x20), offset))
867             } lt(tindex, byteLen) {
868                 tindex := add(tindex, 0x01)
869                 bindex := sub(bindex, 0x01)
870             }{
871                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
872             }
873             mstore(0x40, add(tmpbytes, byteLen))
874             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
875         }
876         return (v, offset + 8);
877     }
878 
879     /* @notice              Read next 32 bytes as uint256 type starting from offset,
880                             there are limits considering the numerical limits in multi-chain
881     *  @param buff          Source bytes array
882     *  @param offset        The position from where we read the uint256 value
883     *  @return              The read uint256 value and updated offset
884     */
885     function NextUint255(bytes memory buff, uint256 offset) internal pure returns (uint256, uint256) {
886         require(offset + 32 <= buff.length && offset < offset + 32, "NextUint255, offset exceeds maximum");
887         uint256 v;
888         assembly {
889             let tmpbytes := mload(0x40)
890             let byteLen := 0x20
891             for {
892                 let tindex := 0x00
893                 let bindex := sub(byteLen, 0x01)
894                 let bvalue := mload(add(add(buff, 0x20), offset))
895             } lt(tindex, byteLen) {
896                 tindex := add(tindex, 0x01)
897                 bindex := sub(bindex, 0x01)
898             }{
899                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
900             }
901             mstore(0x40, add(tmpbytes, byteLen))
902             v := mload(tmpbytes)
903         }
904         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
905         return (v, offset + 32);
906     }
907     /* @notice              Read next variable bytes starting from offset,
908                             the decoding rule coming from multi-chain
909     *  @param buff          Source bytes array
910     *  @param offset        The position from where we read the bytes value
911     *  @return              The read variable bytes array value and updated offset
912     */
913     function NextVarBytes(bytes memory buff, uint256 offset) internal pure returns(bytes memory, uint256) {
914         uint len;
915         (len, offset) = NextVarUint(buff, offset);
916         require(offset + len <= buff.length && offset < offset + len, "NextVarBytes, offset exceeds maximum");
917         bytes memory tempBytes;
918         assembly{
919             switch iszero(len)
920             case 0 {
921                 // Get a location of some free memory and store it in tempBytes as
922                 // Solidity does for memory variables.
923                 tempBytes := mload(0x40)
924 
925                 // The first word of the slice result is potentially a partial
926                 // word read from the original array. To read it, we calculate
927                 // the length of that partial word and start copying that many
928                 // bytes into the array. The first word we copy will start with
929                 // data we don't care about, but the last `lengthmod` bytes will
930                 // land at the beginning of the contents of the new array. When
931                 // we're done copying, we overwrite the full first word with
932                 // the actual length of the slice.
933                 let lengthmod := and(len, 31)
934 
935                 // The multiplication in the next line is necessary
936                 // because when slicing multiples of 32 bytes (lengthmod == 0)
937                 // the following copy loop was copying the origin's length
938                 // and then ending prematurely not copying everything it should.
939                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
940                 let end := add(mc, len)
941 
942                 for {
943                     // The multiplication in the next line has the same exact purpose
944                     // as the one above.
945                     let cc := add(add(add(buff, lengthmod), mul(0x20, iszero(lengthmod))), offset)
946                 } lt(mc, end) {
947                     mc := add(mc, 0x20)
948                     cc := add(cc, 0x20)
949                 } {
950                     mstore(mc, mload(cc))
951                 }
952 
953                 mstore(tempBytes, len)
954 
955                 //update free-memory pointer
956                 //allocating the array padded to 32 bytes like the compiler does now
957                 mstore(0x40, and(add(mc, 31), not(31)))
958             }
959             //if we want a zero-length slice let's just return a zero-length array
960             default {
961                 tempBytes := mload(0x40)
962 
963                 mstore(0x40, add(tempBytes, 0x20))
964             }
965         }
966 
967         return (tempBytes, offset + len);
968     }
969     /* @notice              Read next 32 bytes starting from offset,
970     *  @param buff          Source bytes array
971     *  @param offset        The position from where we read the bytes value
972     *  @return              The read bytes32 value and updated offset
973     */
974     function NextHash(bytes memory buff, uint256 offset) internal pure returns (bytes32 , uint256) {
975         require(offset + 32 <= buff.length && offset < offset + 32, "NextHash, offset exceeds maximum");
976         bytes32 v;
977         assembly {
978             v := mload(add(buff, add(offset, 0x20)))
979         }
980         return (v, offset + 32);
981     }
982 
983     /* @notice              Read next 20 bytes starting from offset,
984     *  @param buff          Source bytes array
985     *  @param offset        The position from where we read the bytes value
986     *  @return              The read bytes20 value and updated offset
987     */
988     function NextBytes20(bytes memory buff, uint256 offset) internal pure returns (bytes20 , uint256) {
989         require(offset + 20 <= buff.length && offset < offset + 20, "NextBytes20, offset exceeds maximum");
990         bytes20 v;
991         assembly {
992             v := mload(add(buff, add(offset, 0x20)))
993         }
994         return (v, offset + 20);
995     }
996     
997     function NextVarUint(bytes memory buff, uint256 offset) internal pure returns(uint, uint256) {
998         byte v;
999         (v, offset) = NextByte(buff, offset);
1000 
1001         uint value;
1002         if (v == 0xFD) {
1003             // return NextUint16(buff, offset);
1004             (value, offset) = NextUint16(buff, offset);
1005             require(value >= 0xFD && value <= 0xFFFF, "NextUint16, value outside range");
1006             return (value, offset);
1007         } else if (v == 0xFE) {
1008             // return NextUint32(buff, offset);
1009             (value, offset) = NextUint32(buff, offset);
1010             require(value > 0xFFFF && value <= 0xFFFFFFFF, "NextVarUint, value outside range");
1011             return (value, offset);
1012         } else if (v == 0xFF) {
1013             // return NextUint64(buff, offset);
1014             (value, offset) = NextUint64(buff, offset);
1015             require(value > 0xFFFFFFFF, "NextVarUint, value outside range");
1016             return (value, offset);
1017         } else{
1018             // return (uint8(v), offset);
1019             value = uint8(v);
1020             require(value < 0xFD, "NextVarUint, value outside range");
1021             return (value, offset);
1022         }
1023     }
1024 }
1025 pragma solidity ^0.5.0;
1026 
1027 /**
1028  * @dev Wrappers over encoding and serialization operation into bytes from bassic types in Solidity for PolyNetwork cross chain utility.
1029  *
1030  * Encode basic types in Solidity into bytes easily. It's designed to be used 
1031  * for PolyNetwork cross chain application, and the encoding rules on Ethereum chain 
1032  * and the decoding rules on other chains should be consistent. Here we  
1033  * follow the underlying serialization rule with implementation found here: 
1034  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_sink.go
1035  *
1036  * Using this library instead of the unchecked serialization method can help reduce
1037  * the risk of serious bugs and handfule, so it's recommended to use it.
1038  *
1039  * Please note that risk can be minimized, yet not eliminated.
1040  */
1041 library ZeroCopySink {
1042     /* @notice          Convert boolean value into bytes
1043     *  @param b         The boolean value
1044     *  @return          Converted bytes array
1045     */
1046     function WriteBool(bool b) internal pure returns (bytes memory) {
1047         bytes memory buff;
1048         assembly{
1049             buff := mload(0x40)
1050             mstore(buff, 1)
1051             switch iszero(b)
1052             case 1 {
1053                 mstore(add(buff, 0x20), shl(248, 0x00))
1054                 // mstore8(add(buff, 0x20), 0x00)
1055             }
1056             default {
1057                 mstore(add(buff, 0x20), shl(248, 0x01))
1058                 // mstore8(add(buff, 0x20), 0x01)
1059             }
1060             mstore(0x40, add(buff, 0x21))
1061         }
1062         return buff;
1063     }
1064 
1065     /* @notice          Convert byte value into bytes
1066     *  @param b         The byte value
1067     *  @return          Converted bytes array
1068     */
1069     function WriteByte(byte b) internal pure returns (bytes memory) {
1070         return WriteUint8(uint8(b));
1071     }
1072 
1073     /* @notice          Convert uint8 value into bytes
1074     *  @param v         The uint8 value
1075     *  @return          Converted bytes array
1076     */
1077     function WriteUint8(uint8 v) internal pure returns (bytes memory) {
1078         bytes memory buff;
1079         assembly{
1080             buff := mload(0x40)
1081             mstore(buff, 1)
1082             mstore(add(buff, 0x20), shl(248, v))
1083             // mstore(add(buff, 0x20), byte(0x1f, v))
1084             mstore(0x40, add(buff, 0x21))
1085         }
1086         return buff;
1087     }
1088 
1089     /* @notice          Convert uint16 value into bytes
1090     *  @param v         The uint16 value
1091     *  @return          Converted bytes array
1092     */
1093     function WriteUint16(uint16 v) internal pure returns (bytes memory) {
1094         bytes memory buff;
1095 
1096         assembly{
1097             buff := mload(0x40)
1098             let byteLen := 0x02
1099             mstore(buff, byteLen)
1100             for {
1101                 let mindex := 0x00
1102                 let vindex := 0x1f
1103             } lt(mindex, byteLen) {
1104                 mindex := add(mindex, 0x01)
1105                 vindex := sub(vindex, 0x01)
1106             }{
1107                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
1108             }
1109             mstore(0x40, add(buff, 0x22))
1110         }
1111         return buff;
1112     }
1113     
1114     /* @notice          Convert uint32 value into bytes
1115     *  @param v         The uint32 value
1116     *  @return          Converted bytes array
1117     */
1118     function WriteUint32(uint32 v) internal pure returns(bytes memory) {
1119         bytes memory buff;
1120         assembly{
1121             buff := mload(0x40)
1122             let byteLen := 0x04
1123             mstore(buff, byteLen)
1124             for {
1125                 let mindex := 0x00
1126                 let vindex := 0x1f
1127             } lt(mindex, byteLen) {
1128                 mindex := add(mindex, 0x01)
1129                 vindex := sub(vindex, 0x01)
1130             }{
1131                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
1132             }
1133             mstore(0x40, add(buff, 0x24))
1134         }
1135         return buff;
1136     }
1137 
1138     /* @notice          Convert uint64 value into bytes
1139     *  @param v         The uint64 value
1140     *  @return          Converted bytes array
1141     */
1142     function WriteUint64(uint64 v) internal pure returns(bytes memory) {
1143         bytes memory buff;
1144 
1145         assembly{
1146             buff := mload(0x40)
1147             let byteLen := 0x08
1148             mstore(buff, byteLen)
1149             for {
1150                 let mindex := 0x00
1151                 let vindex := 0x1f
1152             } lt(mindex, byteLen) {
1153                 mindex := add(mindex, 0x01)
1154                 vindex := sub(vindex, 0x01)
1155             }{
1156                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
1157             }
1158             mstore(0x40, add(buff, 0x28))
1159         }
1160         return buff;
1161     }
1162 
1163     /* @notice          Convert limited uint256 value into bytes
1164     *  @param v         The uint256 value
1165     *  @return          Converted bytes array
1166     */
1167     function WriteUint255(uint256 v) internal pure returns (bytes memory) {
1168         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds uint255 range");
1169         bytes memory buff;
1170 
1171         assembly{
1172             buff := mload(0x40)
1173             let byteLen := 0x20
1174             mstore(buff, byteLen)
1175             for {
1176                 let mindex := 0x00
1177                 let vindex := 0x1f
1178             } lt(mindex, byteLen) {
1179                 mindex := add(mindex, 0x01)
1180                 vindex := sub(vindex, 0x01)
1181             }{
1182                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
1183             }
1184             mstore(0x40, add(buff, 0x40))
1185         }
1186         return buff;
1187     }
1188 
1189     /* @notice          Encode bytes format data into bytes
1190     *  @param data      The bytes array data
1191     *  @return          Encoded bytes array
1192     */
1193     function WriteVarBytes(bytes memory data) internal pure returns (bytes memory) {
1194         uint64 l = uint64(data.length);
1195         return abi.encodePacked(WriteVarUint(l), data);
1196     }
1197 
1198     function WriteVarUint(uint64 v) internal pure returns (bytes memory) {
1199         if (v < 0xFD){
1200     		return WriteUint8(uint8(v));
1201     	} else if (v <= 0xFFFF) {
1202     		return abi.encodePacked(WriteByte(0xFD), WriteUint16(uint16(v)));
1203     	} else if (v <= 0xFFFFFFFF) {
1204             return abi.encodePacked(WriteByte(0xFE), WriteUint32(uint32(v)));
1205     	} else {
1206     		return abi.encodePacked(WriteByte(0xFF), WriteUint64(uint64(v)));
1207     	}
1208     }
1209 }
1210 contract LockProxy is Ownable {
1211     using SafeMath for uint;
1212     using SafeERC20 for IERC20;
1213 
1214     struct TxArgs {
1215         bytes toAssetHash;
1216         bytes toAddress;
1217         uint256 amount;
1218     }
1219     address public managerProxyContract;
1220     mapping(uint64 => bytes) public proxyHashMap;
1221     mapping(address => mapping(uint64 => bytes)) public assetHashMap;
1222     mapping(address => bool) safeTransfer;
1223 
1224     event SetManagerProxyEvent(address manager);
1225     event BindProxyEvent(uint64 toChainId, bytes targetProxyHash);
1226     event BindAssetEvent(address fromAssetHash, uint64 toChainId, bytes targetProxyHash, uint initialAmount);
1227     event UnlockEvent(address toAssetHash, address toAddress, uint256 amount);
1228     event LockEvent(address fromAssetHash, address fromAddress, uint64 toChainId, bytes toAssetHash, bytes toAddress, uint256 amount);
1229     
1230     modifier onlyManagerContract() {
1231         IEthCrossChainManagerProxy ieccmp = IEthCrossChainManagerProxy(managerProxyContract);
1232         require(_msgSender() == ieccmp.getEthCrossChainManager(), "msgSender is not EthCrossChainManagerContract");
1233         _;
1234     }
1235     
1236     function setManagerProxy(address ethCCMProxyAddr) onlyOwner public {
1237         managerProxyContract = ethCCMProxyAddr;
1238         emit SetManagerProxyEvent(managerProxyContract);
1239     }
1240     
1241     function bindProxyHash(uint64 toChainId, bytes memory targetProxyHash) onlyOwner public returns (bool) {
1242         proxyHashMap[toChainId] = targetProxyHash;
1243         emit BindProxyEvent(toChainId, targetProxyHash);
1244         return true;
1245     }
1246     
1247     function bindAssetHash(address fromAssetHash, uint64 toChainId, bytes memory toAssetHash) onlyOwner public returns (bool) {
1248         assetHashMap[fromAssetHash][toChainId] = toAssetHash;
1249         emit BindAssetEvent(fromAssetHash, toChainId, toAssetHash, getBalanceFor(fromAssetHash));
1250         return true;
1251     }
1252     
1253     /* @notice                  This function is meant to be invoked by the user,
1254     *                           a certin amount teokens will be locked in the proxy contract the invoker/msg.sender immediately.
1255     *                           Then the same amount of tokens will be unloked from target chain proxy contract at the target chain with chainId later.
1256     *  @param fromAssetHash     The asset address in current chain, uniformly named as `fromAssetHash`
1257     *  @param toChainId         The target chain id
1258     *                           
1259     *  @param toAddress         The address in bytes format to receive same amount of tokens in target chain 
1260     *  @param amount            The amount of tokens to be crossed from ethereum to the chain with chainId
1261     */
1262     function lock(address fromAssetHash, uint64 toChainId, bytes memory toAddress, uint256 amount) public payable returns (bool) {
1263         require(amount != 0, "amount cannot be zero!");
1264         
1265         
1266         require(_transferToContract(fromAssetHash, amount), "transfer asset from fromAddress to lock_proxy contract  failed!");
1267         
1268         bytes memory toAssetHash = assetHashMap[fromAssetHash][toChainId];
1269         require(toAssetHash.length != 0, "empty illegal toAssetHash");
1270 
1271         TxArgs memory txArgs = TxArgs({
1272             toAssetHash: toAssetHash,
1273             toAddress: toAddress,
1274             amount: amount
1275         });
1276         bytes memory txData = _serializeTxArgs(txArgs);
1277         
1278         IEthCrossChainManagerProxy eccmp = IEthCrossChainManagerProxy(managerProxyContract);
1279         address eccmAddr = eccmp.getEthCrossChainManager();
1280         IEthCrossChainManager eccm = IEthCrossChainManager(eccmAddr);
1281         
1282         bytes memory toProxyHash = proxyHashMap[toChainId];
1283         require(toProxyHash.length != 0, "empty illegal toProxyHash");
1284         require(eccm.crossChain(toChainId, toProxyHash, "unlock", txData), "EthCrossChainManager crossChain executed error!");
1285 
1286         emit LockEvent(fromAssetHash, _msgSender(), toChainId, toAssetHash, toAddress, amount);
1287         
1288         return true;
1289 
1290     }
1291     
1292     // /* @notice                  This function is meant to be invoked by the ETH crosschain management contract,
1293     // *                           then mint a certin amount of tokens to the designated address since a certain amount 
1294     // *                           was burnt from the source chain invoker.
1295     // *  @param argsBs            The argument bytes recevied by the ethereum lock proxy contract, need to be deserialized.
1296     // *                           based on the way of serialization in the source chain proxy contract.
1297     // *  @param fromContractAddr  The source chain contract address
1298     // *  @param fromChainId       The source chain id
1299     // */
1300     function unlock(bytes memory argsBs, bytes memory fromContractAddr, uint64 fromChainId) onlyManagerContract public returns (bool) {
1301         TxArgs memory args = _deserializeTxArgs(argsBs);
1302 
1303         require(fromContractAddr.length != 0, "from proxy contract address cannot be empty");
1304         require(Utils.equalStorage(proxyHashMap[fromChainId], fromContractAddr), "From Proxy contract address error!");
1305         
1306         require(args.toAssetHash.length != 0, "toAssetHash cannot be empty");
1307         address toAssetHash = Utils.bytesToAddress(args.toAssetHash);
1308 
1309         require(args.toAddress.length != 0, "toAddress cannot be empty");
1310         address toAddress = Utils.bytesToAddress(args.toAddress);
1311         
1312         
1313         require(_transferFromContract(toAssetHash, toAddress, args.amount), "transfer asset from lock_proxy contract to toAddress failed!");
1314         
1315         emit UnlockEvent(toAssetHash, toAddress, args.amount);
1316         return true;
1317     }
1318     
1319     function getBalanceFor(address fromAssetHash) public view returns (uint256) {
1320         if (fromAssetHash == address(0)) {
1321             // return address(this).balance; // this expression would result in error: Failed to decode output: Error: insufficient data for uint256 type
1322             address selfAddr = address(this);
1323             return selfAddr.balance;
1324         } else {
1325             IERC20 erc20Token = IERC20(fromAssetHash);
1326             return erc20Token.balanceOf(address(this));
1327         }
1328     }
1329     function _transferToContract(address fromAssetHash, uint256 amount) internal returns (bool) {
1330         if (fromAssetHash == address(0)) {
1331             // fromAssetHash === address(0) denotes user choose to lock ether
1332             // passively check if the received msg.value equals amount
1333             require(msg.value != 0, "transferred ether cannot be zero!");
1334             require(msg.value == amount, "transferred ether is not equal to amount!");
1335         } else {
1336             // make sure lockproxy contract will decline any received ether
1337             require(msg.value == 0, "there should be no ether transfer!");
1338             // actively transfer amount of asset from msg.sender to lock_proxy contract
1339             require(_transferERC20ToContract(fromAssetHash, _msgSender(), address(this), amount), "transfer erc20 asset to lock_proxy contract failed!");
1340         }
1341         return true;
1342     }
1343     function _transferFromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
1344         if (toAssetHash == address(0x0000000000000000000000000000000000000000)) {
1345             // toAssetHash === address(0) denotes contract needs to unlock ether to toAddress
1346             // convert toAddress from 'address' type to 'address payable' type, then actively transfer ether
1347             address(uint160(toAddress)).transfer(amount);
1348         } else {
1349             // actively transfer amount of asset from msg.sender to lock_proxy contract 
1350             require(_transferERC20FromContract(toAssetHash, toAddress, amount), "transfer erc20 asset to lock_proxy contract failed!");
1351         }
1352         return true;
1353     }
1354     
1355     
1356     function _transferERC20ToContract(address fromAssetHash, address fromAddress, address toAddress, uint256 amount) internal returns (bool) {
1357          IERC20 erc20Token = IERC20(fromAssetHash);
1358         //  require(erc20Token.transferFrom(fromAddress, toAddress, amount), "trasnfer ERC20 Token failed!");
1359          erc20Token.safeTransferFrom(fromAddress, toAddress, amount);
1360          return true;
1361     }
1362     function _transferERC20FromContract(address toAssetHash, address toAddress, uint256 amount) internal returns (bool) {
1363          IERC20 erc20Token = IERC20(toAssetHash);
1364         //  require(erc20Token.transfer(toAddress, amount), "trasnfer ERC20 Token failed!");
1365          erc20Token.safeTransfer(toAddress, amount);
1366          return true;
1367     }
1368     
1369     function _serializeTxArgs(TxArgs memory args) internal pure returns (bytes memory) {
1370         bytes memory buff;
1371         buff = abi.encodePacked(
1372             ZeroCopySink.WriteVarBytes(args.toAssetHash),
1373             ZeroCopySink.WriteVarBytes(args.toAddress),
1374             ZeroCopySink.WriteUint255(args.amount)
1375             );
1376         return buff;
1377     }
1378 
1379     function _deserializeTxArgs(bytes memory valueBs) internal pure returns (TxArgs memory) {
1380         TxArgs memory args;
1381         uint256 off = 0;
1382         (args.toAssetHash, off) = ZeroCopySource.NextVarBytes(valueBs, off);
1383         (args.toAddress, off) = ZeroCopySource.NextVarBytes(valueBs, off);
1384         (args.amount, off) = ZeroCopySource.NextUint255(valueBs, off);
1385         return args;
1386     }
1387 }