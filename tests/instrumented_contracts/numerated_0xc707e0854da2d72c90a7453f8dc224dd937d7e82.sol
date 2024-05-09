1 pragma solidity ^0.5.5;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @title SafeERC20
80  * @dev Wrappers around ERC20 operations that throw on failure (when the token
81  * contract returns false). Tokens that return no value (and instead revert or
82  * throw on failure) are also supported, non-reverting calls are assumed to be
83  * successful.
84  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
85  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
86  */
87 library SafeERC20 {
88     using SafeMath for uint256;
89     using Address for address;
90 
91     function safeTransfer(IERC20 token, address to, uint256 value, mapping(address => uint8) storage bugERC20s) internal {
92         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value), bugERC20s);
93     }
94 
95     function safeTransferFrom(IERC20 token, address from, address to, uint256 value, mapping(address => uint8) storage bugERC20s) internal {
96         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value), bugERC20s);
97     }
98 
99 
100 
101 
102     /**
103      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
104      * on the return value: the return value is optional (but if data is returned, it must not be false).
105      * @param token The token targeted by the call.
106      * @param data The call data (encoded using abi.encode or one of its variants).
107      */
108     function callOptionalReturn(IERC20 token, bytes memory data, mapping(address => uint8) storage bugERC20s) private {
109         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
110         // we're implementing it ourselves.
111 
112         // A Solidity high level call has three parts:
113         //  1. The target address is checked to verify it contains contract code
114         //  2. The call itself is made, and success asserted
115         //  3. The return value is decoded, which in turn checks the size of the returned data.
116         // solhint-disable-next-line max-line-length
117         require(address(token).isContract(), "SafeERC20: call to non-contract");
118 
119         // solhint-disable-next-line avoid-low-level-calls
120         (bool success, bytes memory returndata) = address(token).call(data);
121         require(success, "SafeERC20: low-level call failed");
122 
123         if (bugERC20s[address(token)] != 0) {
124             return;
125         }
126         if (returndata.length > 0) { // Return data is optional
127             // solhint-disable-next-line max-line-length
128             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
129         }
130     }
131 }
132 
133 // Part: ReentrancyGuard
134 
135 /**
136  * @dev Contract module that helps prevent reentrant calls to a function.
137  *
138  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
139  * available, which can be applied to functions to make sure there are no nested
140  * (reentrant) calls to them.
141  *
142  * Note that because there is a single `nonReentrant` guard, functions marked as
143  * `nonReentrant` may not call one another. This can be worked around by making
144  * those functions `private`, and then adding `external` `nonReentrant` entry
145  * points to them.
146  *
147  * TIP: If you would like to learn more about reentrancy and alternative ways
148  * to protect against it, check out our blog post
149  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
150  */
151 contract ReentrancyGuard {
152     // Booleans are more expensive than uint256 or any type that takes up a full
153     // word because each write operation emits an extra SLOAD to first read the
154     // slot's contents, replace the bits taken up by the boolean, and then write
155     // back. This is the compiler's defense against contract upgrades and
156     // pointer aliasing, and it cannot be disabled.
157 
158     // The values being non-zero value makes deployment a bit more expensive,
159     // but in exchange the refund on every call to nonReentrant will be lower in
160     // amount. Since refunds are capped to a percentage of the total
161     // transaction's gas, it is best to keep them low in cases like this one, to
162     // increase the likelihood of the full refund coming into effect.
163     uint256 private constant _NOT_ENTERED = 1;
164     uint256 private constant _ENTERED = 2;
165 
166     uint256 private _status;
167 
168     constructor () internal {
169         _status = _NOT_ENTERED;
170     }
171 
172     /**
173      * @dev Prevents a contract from calling itself, directly or indirectly.
174      * Calling a `nonReentrant` function from another `nonReentrant`
175      * function is not supported. It is possible to prevent this from happening
176      * by making the `nonReentrant` function external, and make it call a
177      * `private` function that does the actual work.
178      */
179     modifier nonReentrant() {
180         // On the first call to nonReentrant, _notEntered will be true
181         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
182 
183         // Any calls to nonReentrant after this point will fail
184         _status = _ENTERED;
185 
186         _;
187 
188         // By storing the original value once again, a refund is triggered (see
189         // https://eips.ethereum.org/EIPS/eip-2200)
190         _status = _NOT_ENTERED;
191     }
192 }
193 
194 /**
195  * @dev Wrappers over Solidity's arithmetic operations with added overflow
196  * checks.
197  *
198  * Arithmetic operations in Solidity wrap on overflow. This can easily result
199  * in bugs, because programmers usually assume that an overflow raises an
200  * error, which is the standard behavior in high level programming languages.
201  * `SafeMath` restores this intuition by reverting the transaction when an
202  * operation overflows.
203  *
204  * Using this library instead of the unchecked operations eliminates an entire
205  * class of bugs, so it's recommended to use it always.
206  */
207 library SafeMath {
208     /**
209      * @dev Returns the addition of two unsigned integers, reverting on
210      * overflow.
211      *
212      * Counterpart to Solidity's `+` operator.
213      *
214      * Requirements:
215      * - Addition cannot overflow.
216      */
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         require(c >= a, "SafeMath: addition overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      * - Subtraction cannot overflow.
232      */
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         return sub(a, b, "SafeMath: subtraction overflow");
235     }
236 
237     /**
238      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
239      * overflow (when the result is negative).
240      *
241      * Counterpart to Solidity's `-` operator.
242      *
243      * Requirements:
244      * - Subtraction cannot overflow.
245      *
246      * _Available since v2.4.0._
247      */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b <= a, errorMessage);
250         uint256 c = a - b;
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the multiplication of two unsigned integers, reverting on
257      * overflow.
258      *
259      * Counterpart to Solidity's `*` operator.
260      *
261      * Requirements:
262      * - Multiplication cannot overflow.
263      */
264     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
265         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
266         // benefit is lost if 'b' is also tested.
267         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
268         if (a == 0) {
269             return 0;
270         }
271 
272         uint256 c = a * b;
273         require(c / a == b, "SafeMath: multiplication overflow");
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers. Reverts on
280      * division by zero. The result is rounded towards zero.
281      *
282      * Counterpart to Solidity's `/` operator. Note: this function uses a
283      * `revert` opcode (which leaves remaining gas untouched) while Solidity
284      * uses an invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      * - The divisor cannot be zero.
303      *
304      * _Available since v2.4.0._
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         // Solidity only automatically asserts when dividing by 0
308         require(b > 0, errorMessage);
309         uint256 c = a / b;
310         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
311 
312         return c;
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
327         return mod(a, b, "SafeMath: modulo by zero");
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * Reverts with custom message when dividing by zero.
333      *
334      * Counterpart to Solidity's `%` operator. This function uses a `revert`
335      * opcode (which leaves remaining gas untouched) while Solidity uses an
336      * invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      * - The divisor cannot be zero.
340      *
341      * _Available since v2.4.0._
342      */
343     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
344         require(b != 0, errorMessage);
345         return a % b;
346     }
347 }
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
372         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
373         // for accounts without code, i.e. `keccak256('')`
374         bytes32 codehash;
375         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { codehash := extcodehash(account) }
378         return (codehash != accountHash && codehash != 0x0);
379     }
380 
381     /**
382      * @dev Converts an `address` into `address payable`. Note that this is
383      * simply a type cast: the actual underlying value is not changed.
384      *
385      * _Available since v2.4.0._
386      */
387     function toPayable(address account) internal pure returns (address payable) {
388         return address(uint160(account));
389     }
390 
391     /**
392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
393      * `recipient`, forwarding all available gas and reverting on errors.
394      *
395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
397      * imposed by `transfer`, making them unable to receive funds via
398      * `transfer`. {sendValue} removes this limitation.
399      *
400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
401      *
402      * IMPORTANT: because control is transferred to `recipient`, care must be
403      * taken to not create reentrancy vulnerabilities. Consider using
404      * {ReentrancyGuard} or the
405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
406      *
407      * _Available since v2.4.0._
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         // solhint-disable-next-line avoid-call-value
413         (bool success, ) = recipient.call.value(amount)("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 }
417 
418 library BytesLib {
419     function concat(
420         bytes memory _preBytes,
421         bytes memory _postBytes
422     )
423     internal
424     pure
425     returns (bytes memory)
426     {
427         bytes memory tempBytes;
428 
429         assembly {
430         // Get a location of some free memory and store it in tempBytes as
431         // Solidity does for memory variables.
432             tempBytes := mload(0x40)
433 
434         // Store the length of the first bytes array at the beginning of
435         // the memory for tempBytes.
436             let length := mload(_preBytes)
437             mstore(tempBytes, length)
438 
439         // Maintain a memory counter for the current write location in the
440         // temp bytes array by adding the 32 bytes for the array length to
441         // the starting location.
442             let mc := add(tempBytes, 0x20)
443         // Stop copying when the memory counter reaches the length of the
444         // first bytes array.
445             let end := add(mc, length)
446 
447             for {
448             // Initialize a copy counter to the start of the _preBytes data,
449             // 32 bytes into its memory.
450                 let cc := add(_preBytes, 0x20)
451             } lt(mc, end) {
452             // Increase both counters by 32 bytes each iteration.
453                 mc := add(mc, 0x20)
454                 cc := add(cc, 0x20)
455             } {
456             // Write the _preBytes data into the tempBytes memory 32 bytes
457             // at a time.
458                 mstore(mc, mload(cc))
459             }
460 
461         // Add the length of _postBytes to the current length of tempBytes
462         // and store it as the new length in the first 32 bytes of the
463         // tempBytes memory.
464             length := mload(_postBytes)
465             mstore(tempBytes, add(length, mload(tempBytes)))
466 
467         // Move the memory counter back from a multiple of 0x20 to the
468         // actual end of the _preBytes data.
469             mc := end
470         // Stop copying when the memory counter reaches the new combined
471         // length of the arrays.
472             end := add(mc, length)
473 
474             for {
475                 let cc := add(_postBytes, 0x20)
476             } lt(mc, end) {
477                 mc := add(mc, 0x20)
478                 cc := add(cc, 0x20)
479             } {
480                 mstore(mc, mload(cc))
481             }
482 
483         // Update the free-memory pointer by padding our last write location
484         // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
485         // next 32 byte block, then round down to the nearest multiple of
486         // 32. If the sum of the length of the two arrays is zero then add
487         // one before rounding down to leave a blank 32 bytes (the length block with 0).
488             mstore(0x40, and(
489             add(add(end, iszero(add(length, mload(_preBytes)))), 31),
490             not(31) // Round down to the nearest 32 bytes.
491             ))
492         }
493 
494         return tempBytes;
495     }
496 
497     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
498         assembly {
499         // Read the first 32 bytes of _preBytes storage, which is the length
500         // of the array. (We don't need to use the offset into the slot
501         // because arrays use the entire slot.)
502             let fslot := sload(_preBytes_slot)
503         // Arrays of 31 bytes or less have an even value in their slot,
504         // while longer arrays have an odd value. The actual length is
505         // the slot divided by two for odd values, and the lowest order
506         // byte divided by two for even values.
507         // If the slot is even, bitwise and the slot with 255 and divide by
508         // two to get the length. If the slot is odd, bitwise and the slot
509         // with -1 and divide by two.
510             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
511             let mlength := mload(_postBytes)
512             let newlength := add(slength, mlength)
513         // slength can contain both the length and contents of the array
514         // if length < 32 bytes so let's prepare for that
515         // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
516             switch add(lt(slength, 32), lt(newlength, 32))
517             case 2 {
518             // Since the new array still fits in the slot, we just need to
519             // update the contents of the slot.
520             // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
521                 sstore(
522                 _preBytes_slot,
523                 // all the modifications to the slot are inside this
524                 // next block
525                 add(
526                 // we can just add to the slot contents because the
527                 // bytes we want to change are the LSBs
528                 fslot,
529                 add(
530                 mul(
531                 div(
532                 // load the bytes from memory
533                 mload(add(_postBytes, 0x20)),
534                 // zero all bytes to the right
535                 exp(0x100, sub(32, mlength))
536                 ),
537                 // and now shift left the number of bytes to
538                 // leave space for the length in the slot
539                 exp(0x100, sub(32, newlength))
540                 ),
541                 // increase length by the double of the memory
542                 // bytes length
543                 mul(mlength, 2)
544                 )
545                 )
546                 )
547             }
548             case 1 {
549             // The stored value fits in the slot, but the combined value
550             // will exceed it.
551             // get the keccak hash to get the contents of the array
552                 mstore(0x0, _preBytes_slot)
553                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
554 
555             // save new length
556                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
557 
558             // The contents of the _postBytes array start 32 bytes into
559             // the structure. Our first read should obtain the `submod`
560             // bytes that can fit into the unused space in the last word
561             // of the stored array. To get this, we read 32 bytes starting
562             // from `submod`, so the data we read overlaps with the array
563             // contents by `submod` bytes. Masking the lowest-order
564             // `submod` bytes allows us to add that value directly to the
565             // stored value.
566 
567                 let submod := sub(32, slength)
568                 let mc := add(_postBytes, submod)
569                 let end := add(_postBytes, mlength)
570                 let mask := sub(exp(0x100, submod), 1)
571 
572                 sstore(
573                 sc,
574                 add(
575                 and(
576                 fslot,
577                 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
578                 ),
579                 and(mload(mc), mask)
580                 )
581                 )
582 
583                 for {
584                     mc := add(mc, 0x20)
585                     sc := add(sc, 1)
586                 } lt(mc, end) {
587                     sc := add(sc, 1)
588                     mc := add(mc, 0x20)
589                 } {
590                     sstore(sc, mload(mc))
591                 }
592 
593                 mask := exp(0x100, sub(mc, end))
594 
595                 sstore(sc, mul(div(mload(mc), mask), mask))
596             }
597             default {
598             // get the keccak hash to get the contents of the array
599                 mstore(0x0, _preBytes_slot)
600             // Start copying to the last used word of the stored array.
601                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
602 
603             // save new length
604                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
605 
606             // Copy over the first `submod` bytes of the new data as in
607             // case 1 above.
608                 let slengthmod := mod(slength, 32)
609                 let mlengthmod := mod(mlength, 32)
610                 let submod := sub(32, slengthmod)
611                 let mc := add(_postBytes, submod)
612                 let end := add(_postBytes, mlength)
613                 let mask := sub(exp(0x100, submod), 1)
614 
615                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
616 
617                 for {
618                     sc := add(sc, 1)
619                     mc := add(mc, 0x20)
620                 } lt(mc, end) {
621                     sc := add(sc, 1)
622                     mc := add(mc, 0x20)
623                 } {
624                     sstore(sc, mload(mc))
625                 }
626 
627                 mask := exp(0x100, sub(mc, end))
628 
629                 sstore(sc, mul(div(mload(mc), mask), mask))
630             }
631         }
632     }
633 
634     function slice(
635         bytes memory _bytes,
636         uint _start,
637         uint _length
638     )
639     internal
640     pure
641     returns (bytes memory)
642     {
643         require(_bytes.length >= (_start + _length));
644 
645         bytes memory tempBytes;
646 
647         assembly {
648             switch iszero(_length)
649             case 0 {
650             // Get a location of some free memory and store it in tempBytes as
651             // Solidity does for memory variables.
652                 tempBytes := mload(0x40)
653 
654             // The first word of the slice result is potentially a partial
655             // word read from the original array. To read it, we calculate
656             // the length of that partial word and start copying that many
657             // bytes into the array. The first word we copy will start with
658             // data we don't care about, but the last `lengthmod` bytes will
659             // land at the beginning of the contents of the new array. When
660             // we're done copying, we overwrite the full first word with
661             // the actual length of the slice.
662                 let lengthmod := and(_length, 31)
663 
664             // The multiplication in the next line is necessary
665             // because when slicing multiples of 32 bytes (lengthmod == 0)
666             // the following copy loop was copying the origin's length
667             // and then ending prematurely not copying everything it should.
668                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
669                 let end := add(mc, _length)
670 
671                 for {
672                 // The multiplication in the next line has the same exact purpose
673                 // as the one above.
674                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
675                 } lt(mc, end) {
676                     mc := add(mc, 0x20)
677                     cc := add(cc, 0x20)
678                 } {
679                     mstore(mc, mload(cc))
680                 }
681 
682                 mstore(tempBytes, _length)
683 
684             //update free-memory pointer
685             //allocating the array padded to 32 bytes like the compiler does now
686                 mstore(0x40, and(add(mc, 31), not(31)))
687             }
688             //if we want a zero-length slice let's just return a zero-length array
689             default {
690                 tempBytes := mload(0x40)
691 
692                 mstore(0x40, add(tempBytes, 0x20))
693             }
694         }
695 
696         return tempBytes;
697     }
698 
699     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
700         require(_bytes.length >= (_start + 20));
701         address tempAddress;
702 
703         assembly {
704             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
705         }
706 
707         return tempAddress;
708     }
709 
710     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
711         require(_bytes.length >= (_start + 1));
712         uint8 tempUint;
713 
714         assembly {
715             tempUint := mload(add(add(_bytes, 0x1), _start))
716         }
717 
718         return tempUint;
719     }
720 
721     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
722         require(_bytes.length >= (_start + 2));
723         uint16 tempUint;
724 
725         assembly {
726             tempUint := mload(add(add(_bytes, 0x2), _start))
727         }
728 
729         return tempUint;
730     }
731 
732     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
733         require(_bytes.length >= (_start + 4));
734         uint32 tempUint;
735 
736         assembly {
737             tempUint := mload(add(add(_bytes, 0x4), _start))
738         }
739 
740         return tempUint;
741     }
742 
743     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
744         require(_bytes.length >= (_start + 8));
745         uint64 tempUint;
746 
747         assembly {
748             tempUint := mload(add(add(_bytes, 0x8), _start))
749         }
750 
751         return tempUint;
752     }
753 
754     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
755         require(_bytes.length >= (_start + 12));
756         uint96 tempUint;
757 
758         assembly {
759             tempUint := mload(add(add(_bytes, 0xc), _start))
760         }
761 
762         return tempUint;
763     }
764 
765     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
766         require(_bytes.length >= (_start + 16));
767         uint128 tempUint;
768 
769         assembly {
770             tempUint := mload(add(add(_bytes, 0x10), _start))
771         }
772 
773         return tempUint;
774     }
775 
776     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
777         require(_bytes.length >= (_start + 32));
778         uint256 tempUint;
779 
780         assembly {
781             tempUint := mload(add(add(_bytes, 0x20), _start))
782         }
783 
784         return tempUint;
785     }
786 
787     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
788         require(_bytes.length >= (_start + 32));
789         bytes32 tempBytes32;
790 
791         assembly {
792             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
793         }
794 
795         return tempBytes32;
796     }
797 
798     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
799         bool success = true;
800 
801         assembly {
802             let length := mload(_preBytes)
803 
804         // if lengths don't match the arrays are not equal
805             switch eq(length, mload(_postBytes))
806             case 1 {
807             // cb is a circuit breaker in the for loop since there's
808             //  no said feature for inline assembly loops
809             // cb = 1 - don't breaker
810             // cb = 0 - break
811                 let cb := 1
812 
813                 let mc := add(_preBytes, 0x20)
814                 let end := add(mc, length)
815 
816                 for {
817                     let cc := add(_postBytes, 0x20)
818                 // the next line is the loop condition:
819                 // while(uint(mc < end) + cb == 2)
820                 } eq(add(lt(mc, end), cb), 2) {
821                     mc := add(mc, 0x20)
822                     cc := add(cc, 0x20)
823                 } {
824                 // if any of these checks fails then arrays are not equal
825                     if iszero(eq(mload(mc), mload(cc))) {
826                     // unsuccess:
827                         success := 0
828                         cb := 0
829                     }
830                 }
831             }
832             default {
833             // unsuccess:
834                 success := 0
835             }
836         }
837 
838         return success;
839     }
840 
841     function equalStorage(
842         bytes storage _preBytes,
843         bytes memory _postBytes
844     )
845     internal
846     view
847     returns (bool)
848     {
849         bool success = true;
850 
851         assembly {
852         // we know _preBytes_offset is 0
853             let fslot := sload(_preBytes_slot)
854         // Decode the length of the stored array like in concatStorage().
855             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
856             let mlength := mload(_postBytes)
857 
858         // if lengths don't match the arrays are not equal
859             switch eq(slength, mlength)
860             case 1 {
861             // slength can contain both the length and contents of the array
862             // if length < 32 bytes so let's prepare for that
863             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
864                 if iszero(iszero(slength)) {
865                     switch lt(slength, 32)
866                     case 1 {
867                     // blank the last byte which is the length
868                         fslot := mul(div(fslot, 0x100), 0x100)
869 
870                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
871                         // unsuccess:
872                             success := 0
873                         }
874                     }
875                     default {
876                     // cb is a circuit breaker in the for loop since there's
877                     //  no said feature for inline assembly loops
878                     // cb = 1 - don't breaker
879                     // cb = 0 - break
880                         let cb := 1
881 
882                     // get the keccak hash to get the contents of the array
883                         mstore(0x0, _preBytes_slot)
884                         let sc := keccak256(0x0, 0x20)
885 
886                         let mc := add(_postBytes, 0x20)
887                         let end := add(mc, mlength)
888 
889                     // the next line is the loop condition:
890                     // while(uint(mc < end) + cb == 2)
891                         for {} eq(add(lt(mc, end), cb), 2) {
892                             sc := add(sc, 1)
893                             mc := add(mc, 0x20)
894                         } {
895                             if iszero(eq(sload(sc), mload(mc))) {
896                             // unsuccess:
897                                 success := 0
898                                 cb := 0
899                             }
900                         }
901                     }
902                 }
903             }
904             default {
905             // unsuccess:
906                 success := 0
907             }
908         }
909 
910         return success;
911     }
912 }
913 
914 interface IERC20Minter {
915     function mint(address to, uint256 amount) external;
916     function burn(uint256 amount) external;
917     function replaceMinter(address newMinter) external;
918 }
919 
920 contract NerveMultiSigWalletIII is ReentrancyGuard {
921     using Address for address;
922     using SafeERC20 for IERC20;
923     using SafeMath for uint256;
924     using BytesLib for bytes;
925 
926     modifier isOwner{
927         require(owner == msg.sender, "Only owner can execute it");
928         _;
929     }
930     modifier isManager{
931         require(managers[msg.sender] == 1, "Only manager can execute it");
932         _;
933     }
934     bool public upgrade = false;
935     address public upgradeContractAddress = address(0);
936     // 最大管理员数量
937     uint public max_managers = 15;
938     // 最小管理员数量
939     uint public min_managers = 3;
940     // 最小签名比例 66%
941     uint public rate = 66;
942     // 签名字节长度
943     uint public signatureLength = 65;
944     // 比例分母
945     uint constant DENOMINATOR = 100;
946     // 当前合约版本
947     uint8 constant VERSION = 3;
948     // hash计算加盐
949     uint public hashSalt; 
950     // 当前交易的最小签名数量
951     uint8 public current_min_signatures;
952     address public owner;
953     mapping(address => uint8) private seedManagers;
954     address[] private seedManagerArray;
955     mapping(address => uint8) private managers;
956     address[] private managerArray;
957     mapping(bytes32 => uint8) private completedKeccak256s;
958     mapping(string => uint8) private completedTxs;
959     mapping(address => uint8) private minterERC20s;
960     mapping(address => uint8) public bugERC20s;
961     bool public openCrossOutII = false;
962 
963     constructor(uint256 _chainid, address[] memory _managers) public{
964         require(_managers.length <= max_managers, "Exceeded the maximum number of managers");
965         require(_managers.length >= min_managers, "Not reaching the min number of managers");
966         owner = msg.sender;
967         managerArray = _managers;
968         for (uint8 i = 0; i < managerArray.length; i++) {
969             managers[managerArray[i]] = 1;
970             seedManagers[managerArray[i]] = 1;
971             seedManagerArray.push(managerArray[i]);
972         }
973         require(managers[owner] == 0, "Contract creator cannot act as manager");
974         // 设置当前交易的最小签名数量
975         current_min_signatures = calMinSignatures(managerArray.length);
976         hashSalt = _chainid * 2 + VERSION;
977     }
978     function() external payable {
979         emit DepositFunds(msg.sender, msg.value);
980     }
981 
982     function createOrSignWithdraw(string memory txKey, address payable to, uint256 amount, bool isERC20, address ERC20, bytes memory signatures) public nonReentrant isManager {
983         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
984         require(to != address(0), "Withdraw: transfer to the zero address");
985         require(amount > 0, "Withdrawal amount must be greater than 0");
986         // 校验已经完成的交易
987         require(completedTxs[txKey] == 0, "Transaction has been completed");
988         // 校验提现金额
989         if (isERC20) {
990             validateTransferERC20(ERC20, to, amount);
991         } else {
992             require(address(this).balance >= amount, "This contract address does not have sufficient balance of ether");
993         }
994         bytes32 vHash = keccak256(abi.encodePacked(txKey, to, amount, isERC20, ERC20, hashSalt));
995         // 校验请求重复性
996         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
997         // 校验签名
998         require(validSignature(vHash, signatures), "Valid signatures fail");
999         // 执行转账
1000         if (isERC20) {
1001             transferERC20(ERC20, to, amount);
1002         } else {
1003             // 实际到账
1004             require(address(this).balance >= amount, "This contract address does not have sufficient balance of ether");
1005             to.transfer(amount);
1006             emit TransferFunds(to, amount);
1007         }
1008         // 保存交易数据
1009         completeTx(txKey, vHash, 1);
1010         emit TxWithdrawCompleted(txKey);
1011     }
1012 
1013 
1014     function createOrSignManagerChange(string memory txKey, address[] memory adds, address[] memory removes, uint8 count, bytes memory signatures) public isManager {
1015         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
1016         require(adds.length > 0 || removes.length > 0, "There are no managers joining or exiting");
1017         // 校验已经完成的交易
1018         require(completedTxs[txKey] == 0, "Transaction has been completed");
1019         preValidateAddsAndRemoves(adds, removes);
1020         bytes32 vHash = keccak256(abi.encodePacked(txKey, adds, count, removes, hashSalt));
1021         // 校验请求重复性
1022         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
1023         // 校验签名
1024         require(validSignature(vHash, signatures), "Valid signatures fail");
1025         // 变更管理员
1026         removeManager(removes);
1027         addManager(adds);
1028         // 更新当前交易的最小签名数
1029         current_min_signatures = calMinSignatures(managerArray.length);
1030         // 保存交易数据
1031         completeTx(txKey, vHash, 1);
1032         // add event
1033         emit TxManagerChangeCompleted(txKey);
1034     }
1035 
1036     function createOrSignUpgrade(string memory txKey, address upgradeContract, bytes memory signatures) public isManager {
1037         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
1038         // 校验已经完成的交易
1039         require(completedTxs[txKey] == 0, "Transaction has been completed");
1040         require(!upgrade, "It has been upgraded");
1041         require(upgradeContract.isContract(), "The address is not a contract address");
1042         // 校验
1043         bytes32 vHash = keccak256(abi.encodePacked(txKey, upgradeContract, hashSalt));
1044         // 校验请求重复性
1045         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
1046         // 校验签名
1047         require(validSignature(vHash, signatures), "Valid signatures fail");
1048         // 变更可升级
1049         upgrade = true;
1050         upgradeContractAddress = upgradeContract;
1051         // 保存交易数据
1052         completeTx(txKey, vHash, 1);
1053         // add event
1054         emit TxUpgradeCompleted(txKey);
1055     }
1056 
1057     function validSignature(bytes32 hash, bytes memory signatures) internal view returns (bool) {
1058         require(signatures.length <= 975, "Max length of signatures: 975");
1059         // 获取签名列表对应的有效管理员,如果存在错误的签名、或者不是管理员的签名，就失败
1060         uint sManagersCount = getManagerFromSignatures(hash, signatures);
1061         // 判断最小签名数量
1062         return sManagersCount >= current_min_signatures;
1063     }
1064 
1065     function getManagerFromSignatures(bytes32 hash, bytes memory signatures) internal view returns (uint){
1066         uint signCount = 0;
1067         uint times = signatures.length.div(signatureLength);
1068         address[] memory result = new address[](times);
1069         uint k = 0;
1070         uint8 j = 0;
1071         for (uint i = 0; i < times; i++) {
1072             bytes memory sign = signatures.slice(k, signatureLength);
1073             address mAddress = ecrecovery(hash, sign);
1074             require(mAddress != address(0), "Signatures error");
1075             // 管理计数
1076             if (managers[mAddress] == 1) {
1077                 signCount++;
1078                 result[j++] = mAddress;
1079             }
1080             k += signatureLength;
1081         }
1082         // 验证地址重复性
1083         bool suc = repeatability(result);
1084         delete result;
1085         require(suc, "Signatures duplicate");
1086         return signCount;
1087     }
1088 
1089     function validateRepeatability(address currentAddress, address[] memory list) internal pure returns (bool) {
1090         address tempAddress;
1091         for (uint i = 0; i < list.length; i++) {
1092             tempAddress = list[i];
1093             if (tempAddress == address(0)) {
1094                 break;
1095             }
1096             if (tempAddress == currentAddress) {
1097                 return false;
1098             }
1099         }
1100         return true;
1101     }
1102 
1103     function repeatability(address[] memory list) internal pure returns (bool) {
1104         for (uint i = 0; i < list.length; i++) {
1105             address address1 = list[i];
1106             if (address1 == address(0)) {
1107                 break;
1108             }
1109             for (uint j = i + 1; j < list.length; j++) {
1110                 address address2 = list[j];
1111                 if (address2 == address(0)) {
1112                     break;
1113                 }
1114                 if (address1 == address2) {
1115                     return false;
1116                 }
1117             }
1118         }
1119         return true;
1120     }
1121 
1122     function ecrecovery(bytes32 hash, bytes memory sig) internal view returns (address) {
1123         bytes32 r;
1124         bytes32 s;
1125         uint8 v;
1126         if (sig.length != signatureLength) {
1127             return address(0);
1128         }
1129         assembly {
1130             r := mload(add(sig, 32))
1131             s := mload(add(sig, 64))
1132             v := byte(0, mload(add(sig, 96)))
1133         }
1134         if(uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1135             return address(0);
1136         }
1137         // https://github.com/ethereum/go-ethereum/issues/2053
1138         if (v < 27) {
1139             v += 27;
1140         }
1141         if (v != 27 && v != 28) {
1142             return address(0);
1143         }
1144         return ecrecover(hash, v, r, s);
1145     }
1146 
1147     function preValidateAddsAndRemoves(address[] memory adds, address[] memory removes) internal view {
1148         // 校验adds
1149         uint addLen = adds.length;
1150         for (uint i = 0; i < addLen; i++) {
1151             address add = adds[i];
1152             require(add != address(0), "ERROR: Detected zero address in adds");
1153             require(managers[add] == 0, "The address list that is being added already exists as a manager");
1154         }
1155         require(repeatability(adds), "Duplicate parameters for the address to join");
1156         // 校验合约创建者不能被添加
1157         require(validateRepeatability(owner, adds), "Contract creator cannot act as manager");
1158         // 校验removes
1159         require(repeatability(removes), "Duplicate parameters for the address to exit");
1160         uint removeLen = removes.length;
1161         for (uint i = 0; i < removeLen; i++) {
1162             address remove = removes[i];
1163             require(seedManagers[remove] == 0, "Can't exit seed manager");
1164             require(managers[remove] == 1, "There are addresses in the exiting address list that are not manager");
1165         }
1166         require(managerArray.length + adds.length - removes.length <= max_managers, "Exceeded the maximum number of managers");
1167     }
1168 
1169     /*
1170      根据 `当前有效管理员数量` 和 `最小签名比例` 计算最小签名数量，向上取整
1171     */
1172     function calMinSignatures(uint managerCounts) internal view returns (uint8) {
1173         require(managerCounts > 0, "Manager Can't empty.");
1174         uint numerator = rate * managerCounts + DENOMINATOR - 1;
1175         return uint8(numerator / DENOMINATOR);
1176     }
1177     function removeManager(address[] memory removes) internal {
1178         if (removes.length == 0) {
1179             return;
1180         }
1181         for (uint i = 0; i < removes.length; i++) {
1182             delete managers[removes[i]];
1183         }
1184         // 遍历修改前管理员列表
1185         for (uint i = 0; i < managerArray.length; i++) {
1186             if (managers[managerArray[i]] == 0) {
1187                 delete managerArray[i];
1188             }
1189         }
1190         uint tempIndex = 0x10;
1191         for (uint i = 0; i<managerArray.length; i++) {
1192             address temp = managerArray[i];
1193             if (temp == address(0)) {
1194                 if (tempIndex == 0x10) tempIndex = i;
1195                 continue;
1196             } else if (tempIndex != 0x10) {
1197                 managerArray[tempIndex] = temp;
1198                 tempIndex++;
1199             }
1200         }
1201         managerArray.length -= removes.length;
1202     }
1203     function addManager(address[] memory adds) internal {
1204         if (adds.length == 0) {
1205             return;
1206         }
1207         for (uint i = 0; i < adds.length; i++) {
1208             address add = adds[i];
1209             if(managers[add] == 0) {
1210                 managers[add] = 1;
1211                 managerArray.push(add);
1212             }
1213         }
1214     }
1215     function completeTx(string memory txKey, bytes32 keccak256Hash, uint8 e) internal {
1216         completedTxs[txKey] = e;
1217         completedKeccak256s[keccak256Hash] = e;
1218     }
1219     function validateTransferERC20(address ERC20, address to, uint256 amount) internal view {
1220         require(to != address(0), "ERC20: transfer to the zero address");
1221         require(address(this) != ERC20, "Do nothing by yourself");
1222         require(ERC20.isContract(), "The address is not a contract address");
1223         if (isMinterERC20(ERC20)) {
1224             // 定制ERC20验证结束
1225             return;
1226         }
1227         IERC20 token = IERC20(ERC20);
1228         uint256 balance = token.balanceOf(address(this));
1229         require(balance >= amount, "No enough balance of token");
1230     }
1231     function transferERC20(address ERC20, address to, uint256 amount) internal {
1232         if (isMinterERC20(ERC20)) {
1233             // 定制的ERC20，跨链转入以太坊网络即增发
1234             IERC20Minter minterToken = IERC20Minter(ERC20);
1235             minterToken.mint(to, amount);
1236             return;
1237         }
1238         IERC20 token = IERC20(ERC20);
1239         uint256 balance = token.balanceOf(address(this));
1240         require(balance >= amount, "No enough balance of token");
1241         token.safeTransfer(to, amount, bugERC20s);
1242     }
1243     function closeUpgrade() public isOwner {
1244         require(upgrade, "Denied");
1245         upgrade = false;
1246     }
1247     function upgradeContractS1() public isOwner {
1248         require(upgrade, "Denied");
1249         require(upgradeContractAddress != address(0), "ERROR: transfer to the zero address");
1250         address(uint160(upgradeContractAddress)).transfer(address(this).balance);
1251     }
1252     function upgradeContractS2(address ERC20) public isOwner {
1253         require(upgrade, "Denied");
1254         require(upgradeContractAddress != address(0), "ERROR: transfer to the zero address");
1255         require(address(this) != ERC20, "Do nothing by yourself");
1256         require(ERC20.isContract(), "The address is not a contract address");
1257         IERC20 token = IERC20(ERC20);
1258         uint256 balance = token.balanceOf(address(this));
1259         require(balance >= 0, "No enough balance of token");
1260         token.safeTransfer(upgradeContractAddress, balance, bugERC20s);
1261         if (isMinterERC20(ERC20)) {
1262             // 定制的ERC20，转移增发销毁权限到新多签合约
1263             IERC20Minter minterToken = IERC20Minter(ERC20);
1264             minterToken.replaceMinter(upgradeContractAddress);
1265         }
1266     }
1267 
1268     // 是否定制的ERC20
1269     function isMinterERC20(address ERC20) public view returns (bool) {
1270         return minterERC20s[ERC20] > 0;
1271     }
1272 
1273     // 登记定制的ERC20
1274     function registerMinterERC20(address ERC20) public isOwner {
1275         require(address(this) != ERC20, "Do nothing by yourself");
1276         require(ERC20.isContract(), "The address is not a contract address");
1277         require(!isMinterERC20(ERC20), "This address has already been registered");
1278         minterERC20s[ERC20] = 1;
1279     }
1280 
1281     // 取消登记定制的ERC20
1282     function unregisterMinterERC20(address ERC20) public isOwner {
1283         require(isMinterERC20(ERC20), "This address is not registered");
1284         delete minterERC20s[ERC20];
1285     }
1286 
1287     // 登记BUG的ERC20
1288     function registerBugERC20(address bug) public isOwner {
1289         require(address(this) != bug, "Do nothing by yourself");
1290         require(bug.isContract(), "The address is not a contract address");
1291         bugERC20s[bug] = 1;
1292     }
1293     // 取消登记BUG的ERC20
1294     function unregisterBugERC20(address bug) public isOwner {
1295         bugERC20s[bug] = 0;
1296     }
1297     // 从eth网络跨链转出资产(ETH or ERC20)
1298     function crossOut(string memory to, uint256 amount, address ERC20) public payable returns (bool) {
1299         address from = msg.sender;
1300         require(amount > 0, "ERROR: Zero amount");
1301         if (ERC20 != address(0)) {
1302             require(msg.value == 0, "ERC20: Does not accept Ethereum Coin");
1303             require(ERC20.isContract(), "The address is not a contract address");
1304             IERC20 token = IERC20(ERC20);
1305             uint256 allowance = token.allowance(from, address(this));
1306             require(allowance >= amount, "No enough amount for authorization");
1307             uint256 fromBalance = token.balanceOf(from);
1308             require(fromBalance >= amount, "No enough balance of the token");
1309             token.safeTransferFrom(from, address(this), amount, bugERC20s);
1310             if (isMinterERC20(ERC20)) {
1311                 // 定制的ERC20，从以太坊网络跨链转出token即销毁
1312                 IERC20Minter minterToken = IERC20Minter(ERC20);
1313                 minterToken.burn(amount);
1314             }
1315         } else {
1316             require(msg.value == amount, "Inconsistency Ethereum amount");
1317         }
1318         emit CrossOutFunds(from, to, amount, ERC20);
1319         return true;
1320     }
1321 
1322     // 从eth网络跨链转出资产(ETH or ERC20)
1323     function crossOutII(string memory to, uint256 amount, address ERC20, bytes memory data) public payable returns (bool) {
1324         require(openCrossOutII, "CrossOutII: Not open");
1325         address from = msg.sender;
1326         uint erc20Amount = 0;
1327         if (ERC20 != address(0)) {
1328             require(amount > 0, "ERROR: Zero amount");
1329             require(ERC20.isContract(), "The address is not a contract address");
1330             IERC20 token = IERC20(ERC20);
1331             uint256 allowance = token.allowance(from, address(this));
1332             require(allowance >= amount, "No enough amount for authorization");
1333             uint256 fromBalance = token.balanceOf(from);
1334             require(fromBalance >= amount, "No enough balance of the token");
1335             token.safeTransferFrom(from, address(this), amount, bugERC20s);
1336             if (isMinterERC20(ERC20)) {
1337                 // 定制的ERC20，从以太坊网络跨链转出token即销毁
1338                 IERC20Minter minterToken = IERC20Minter(ERC20);
1339                 minterToken.burn(amount);
1340             }
1341             erc20Amount = amount;
1342         } else {
1343             require(msg.value > 0 && amount == 0, "CrossOutII: Illegal eth amount");
1344         }
1345         emit CrossOutIIFunds(from, to, erc20Amount, ERC20, msg.value, data);
1346         return true;
1347     }
1348 
1349     function setCrossOutII(bool _open) public isOwner {
1350         openCrossOutII = _open;
1351     }
1352 
1353     function isCompletedTx(string memory txKey) public view returns (bool){
1354         return completedTxs[txKey] > 0;
1355     }
1356     function ifManager(address _manager) public view returns (bool) {
1357         return managers[_manager] == 1;
1358     }
1359     function allManagers() public view returns (address[] memory) {
1360         return managerArray;
1361     }
1362     event DepositFunds(address from, uint amount);
1363     event CrossOutFunds(address from, string to, uint amount, address ERC20);
1364     event CrossOutIIFunds(address from, string to, uint amount, address ERC20, uint ethAmount, bytes data);
1365     event TransferFunds(address to, uint amount);
1366     event TxWithdrawCompleted(string txKey);
1367     event TxManagerChangeCompleted(string txKey);
1368     event TxUpgradeCompleted(string txKey);
1369 }