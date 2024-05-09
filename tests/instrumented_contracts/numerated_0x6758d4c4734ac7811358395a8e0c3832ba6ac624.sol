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
91     function safeTransfer(IERC20 token, address to, uint256 value) internal {
92         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
93     }
94 
95     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
96         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
97     }
98 
99     function safeApprove(IERC20 token, address spender, uint256 value) internal {
100         // safeApprove should only be called when setting an initial allowance,
101         // or when resetting it to zero. To increase and decrease it, use
102         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
103         // solhint-disable-next-line max-line-length
104         require((value == 0) || (token.allowance(address(this), spender) == 0),
105             "SafeERC20: approve from non-zero to non-zero allowance"
106         );
107         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
108     }
109 
110     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
111         uint256 newAllowance = token.allowance(address(this), spender).add(value);
112         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
113     }
114 
115     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
116         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
117         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
118     }
119 
120     /**
121      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
122      * on the return value: the return value is optional (but if data is returned, it must not be false).
123      * @param token The token targeted by the call.
124      * @param data The call data (encoded using abi.encode or one of its variants).
125      */
126     function callOptionalReturn(IERC20 token, bytes memory data) private {
127         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
128         // we're implementing it ourselves.
129 
130         // A Solidity high level call has three parts:
131         //  1. The target address is checked to verify it contains contract code
132         //  2. The call itself is made, and success asserted
133         //  3. The return value is decoded, which in turn checks the size of the returned data.
134         // solhint-disable-next-line max-line-length
135         require(address(token).isContract(), "SafeERC20: call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = address(token).call(data);
139         require(success, "SafeERC20: low-level call failed");
140 
141         if (returndata.length > 0) { // Return data is optional
142             // solhint-disable-next-line max-line-length
143             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
144         }
145     }
146 }
147 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      * - Addition cannot overflow.
170      */
171     function add(uint256 a, uint256 b) internal pure returns (uint256) {
172         uint256 c = a + b;
173         require(c >= a, "SafeMath: addition overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting on
180      * overflow (when the result is negative).
181      *
182      * Counterpart to Solidity's `-` operator.
183      *
184      * Requirements:
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188         return sub(a, b, "SafeMath: subtraction overflow");
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      *
200      * _Available since v2.4.0._
201      */
202     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b <= a, errorMessage);
204         uint256 c = a - b;
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      * - Multiplication cannot overflow.
217      */
218     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
219         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
220         // benefit is lost if 'b' is also tested.
221         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
222         if (a == 0) {
223             return 0;
224         }
225 
226         uint256 c = a * b;
227         require(c / a == b, "SafeMath: multiplication overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers. Reverts on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b) internal pure returns (uint256) {
244         return div(a, b, "SafeMath: division by zero");
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      *
258      * _Available since v2.4.0._
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         // Solidity only automatically asserts when dividing by 0
262         require(b > 0, errorMessage);
263         uint256 c = a / b;
264         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
271      * Reverts when dividing by zero.
272      *
273      * Counterpart to Solidity's `%` operator. This function uses a `revert`
274      * opcode (which leaves remaining gas untouched) while Solidity uses an
275      * invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return mod(a, b, "SafeMath: modulo by zero");
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts with custom message when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      * - The divisor cannot be zero.
294      *
295      * _Available since v2.4.0._
296      */
297     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b != 0, errorMessage);
299         return a % b;
300     }
301 }
302 
303 /**
304  * @dev Collection of functions related to the address type
305  */
306 library Address {
307     /**
308      * @dev Returns true if `account` is a contract.
309      *
310      * [IMPORTANT]
311      * ====
312      * It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      *
315      * Among others, `isContract` will return false for the following
316      * types of addresses:
317      *
318      *  - an externally-owned account
319      *  - a contract in construction
320      *  - an address where a contract will be created
321      *  - an address where a contract lived, but was destroyed
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
326         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
327         // for accounts without code, i.e. `keccak256('')`
328         bytes32 codehash;
329         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly { codehash := extcodehash(account) }
332         return (codehash != accountHash && codehash != 0x0);
333     }
334 
335     /**
336      * @dev Converts an `address` into `address payable`. Note that this is
337      * simply a type cast: the actual underlying value is not changed.
338      *
339      * _Available since v2.4.0._
340      */
341     function toPayable(address account) internal pure returns (address payable) {
342         return address(uint160(account));
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      *
361      * _Available since v2.4.0._
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         // solhint-disable-next-line avoid-call-value
367         (bool success, ) = recipient.call.value(amount)("");
368         require(success, "Address: unable to send value, recipient may have reverted");
369     }
370 }
371 
372 library BytesLib {
373     function concat(
374         bytes memory _preBytes,
375         bytes memory _postBytes
376     )
377     internal
378     pure
379     returns (bytes memory)
380     {
381         bytes memory tempBytes;
382 
383         assembly {
384         // Get a location of some free memory and store it in tempBytes as
385         // Solidity does for memory variables.
386             tempBytes := mload(0x40)
387 
388         // Store the length of the first bytes array at the beginning of
389         // the memory for tempBytes.
390             let length := mload(_preBytes)
391             mstore(tempBytes, length)
392 
393         // Maintain a memory counter for the current write location in the
394         // temp bytes array by adding the 32 bytes for the array length to
395         // the starting location.
396             let mc := add(tempBytes, 0x20)
397         // Stop copying when the memory counter reaches the length of the
398         // first bytes array.
399             let end := add(mc, length)
400 
401             for {
402             // Initialize a copy counter to the start of the _preBytes data,
403             // 32 bytes into its memory.
404                 let cc := add(_preBytes, 0x20)
405             } lt(mc, end) {
406             // Increase both counters by 32 bytes each iteration.
407                 mc := add(mc, 0x20)
408                 cc := add(cc, 0x20)
409             } {
410             // Write the _preBytes data into the tempBytes memory 32 bytes
411             // at a time.
412                 mstore(mc, mload(cc))
413             }
414 
415         // Add the length of _postBytes to the current length of tempBytes
416         // and store it as the new length in the first 32 bytes of the
417         // tempBytes memory.
418             length := mload(_postBytes)
419             mstore(tempBytes, add(length, mload(tempBytes)))
420 
421         // Move the memory counter back from a multiple of 0x20 to the
422         // actual end of the _preBytes data.
423             mc := end
424         // Stop copying when the memory counter reaches the new combined
425         // length of the arrays.
426             end := add(mc, length)
427 
428             for {
429                 let cc := add(_postBytes, 0x20)
430             } lt(mc, end) {
431                 mc := add(mc, 0x20)
432                 cc := add(cc, 0x20)
433             } {
434                 mstore(mc, mload(cc))
435             }
436 
437         // Update the free-memory pointer by padding our last write location
438         // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
439         // next 32 byte block, then round down to the nearest multiple of
440         // 32. If the sum of the length of the two arrays is zero then add
441         // one before rounding down to leave a blank 32 bytes (the length block with 0).
442             mstore(0x40, and(
443             add(add(end, iszero(add(length, mload(_preBytes)))), 31),
444             not(31) // Round down to the nearest 32 bytes.
445             ))
446         }
447 
448         return tempBytes;
449     }
450 
451     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
452         assembly {
453         // Read the first 32 bytes of _preBytes storage, which is the length
454         // of the array. (We don't need to use the offset into the slot
455         // because arrays use the entire slot.)
456             let fslot := sload(_preBytes_slot)
457         // Arrays of 31 bytes or less have an even value in their slot,
458         // while longer arrays have an odd value. The actual length is
459         // the slot divided by two for odd values, and the lowest order
460         // byte divided by two for even values.
461         // If the slot is even, bitwise and the slot with 255 and divide by
462         // two to get the length. If the slot is odd, bitwise and the slot
463         // with -1 and divide by two.
464             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
465             let mlength := mload(_postBytes)
466             let newlength := add(slength, mlength)
467         // slength can contain both the length and contents of the array
468         // if length < 32 bytes so let's prepare for that
469         // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
470             switch add(lt(slength, 32), lt(newlength, 32))
471             case 2 {
472             // Since the new array still fits in the slot, we just need to
473             // update the contents of the slot.
474             // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
475                 sstore(
476                 _preBytes_slot,
477                 // all the modifications to the slot are inside this
478                 // next block
479                 add(
480                 // we can just add to the slot contents because the
481                 // bytes we want to change are the LSBs
482                 fslot,
483                 add(
484                 mul(
485                 div(
486                 // load the bytes from memory
487                 mload(add(_postBytes, 0x20)),
488                 // zero all bytes to the right
489                 exp(0x100, sub(32, mlength))
490                 ),
491                 // and now shift left the number of bytes to
492                 // leave space for the length in the slot
493                 exp(0x100, sub(32, newlength))
494                 ),
495                 // increase length by the double of the memory
496                 // bytes length
497                 mul(mlength, 2)
498                 )
499                 )
500                 )
501             }
502             case 1 {
503             // The stored value fits in the slot, but the combined value
504             // will exceed it.
505             // get the keccak hash to get the contents of the array
506                 mstore(0x0, _preBytes_slot)
507                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
508 
509             // save new length
510                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
511 
512             // The contents of the _postBytes array start 32 bytes into
513             // the structure. Our first read should obtain the `submod`
514             // bytes that can fit into the unused space in the last word
515             // of the stored array. To get this, we read 32 bytes starting
516             // from `submod`, so the data we read overlaps with the array
517             // contents by `submod` bytes. Masking the lowest-order
518             // `submod` bytes allows us to add that value directly to the
519             // stored value.
520 
521                 let submod := sub(32, slength)
522                 let mc := add(_postBytes, submod)
523                 let end := add(_postBytes, mlength)
524                 let mask := sub(exp(0x100, submod), 1)
525 
526                 sstore(
527                 sc,
528                 add(
529                 and(
530                 fslot,
531                 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
532                 ),
533                 and(mload(mc), mask)
534                 )
535                 )
536 
537                 for {
538                     mc := add(mc, 0x20)
539                     sc := add(sc, 1)
540                 } lt(mc, end) {
541                     sc := add(sc, 1)
542                     mc := add(mc, 0x20)
543                 } {
544                     sstore(sc, mload(mc))
545                 }
546 
547                 mask := exp(0x100, sub(mc, end))
548 
549                 sstore(sc, mul(div(mload(mc), mask), mask))
550             }
551             default {
552             // get the keccak hash to get the contents of the array
553                 mstore(0x0, _preBytes_slot)
554             // Start copying to the last used word of the stored array.
555                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
556 
557             // save new length
558                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
559 
560             // Copy over the first `submod` bytes of the new data as in
561             // case 1 above.
562                 let slengthmod := mod(slength, 32)
563                 let mlengthmod := mod(mlength, 32)
564                 let submod := sub(32, slengthmod)
565                 let mc := add(_postBytes, submod)
566                 let end := add(_postBytes, mlength)
567                 let mask := sub(exp(0x100, submod), 1)
568 
569                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
570 
571                 for {
572                     sc := add(sc, 1)
573                     mc := add(mc, 0x20)
574                 } lt(mc, end) {
575                     sc := add(sc, 1)
576                     mc := add(mc, 0x20)
577                 } {
578                     sstore(sc, mload(mc))
579                 }
580 
581                 mask := exp(0x100, sub(mc, end))
582 
583                 sstore(sc, mul(div(mload(mc), mask), mask))
584             }
585         }
586     }
587 
588     function slice(
589         bytes memory _bytes,
590         uint _start,
591         uint _length
592     )
593     internal
594     pure
595     returns (bytes memory)
596     {
597         require(_bytes.length >= (_start + _length));
598 
599         bytes memory tempBytes;
600 
601         assembly {
602             switch iszero(_length)
603             case 0 {
604             // Get a location of some free memory and store it in tempBytes as
605             // Solidity does for memory variables.
606                 tempBytes := mload(0x40)
607 
608             // The first word of the slice result is potentially a partial
609             // word read from the original array. To read it, we calculate
610             // the length of that partial word and start copying that many
611             // bytes into the array. The first word we copy will start with
612             // data we don't care about, but the last `lengthmod` bytes will
613             // land at the beginning of the contents of the new array. When
614             // we're done copying, we overwrite the full first word with
615             // the actual length of the slice.
616                 let lengthmod := and(_length, 31)
617 
618             // The multiplication in the next line is necessary
619             // because when slicing multiples of 32 bytes (lengthmod == 0)
620             // the following copy loop was copying the origin's length
621             // and then ending prematurely not copying everything it should.
622                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
623                 let end := add(mc, _length)
624 
625                 for {
626                 // The multiplication in the next line has the same exact purpose
627                 // as the one above.
628                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
629                 } lt(mc, end) {
630                     mc := add(mc, 0x20)
631                     cc := add(cc, 0x20)
632                 } {
633                     mstore(mc, mload(cc))
634                 }
635 
636                 mstore(tempBytes, _length)
637 
638             //update free-memory pointer
639             //allocating the array padded to 32 bytes like the compiler does now
640                 mstore(0x40, and(add(mc, 31), not(31)))
641             }
642             //if we want a zero-length slice let's just return a zero-length array
643             default {
644                 tempBytes := mload(0x40)
645 
646                 mstore(0x40, add(tempBytes, 0x20))
647             }
648         }
649 
650         return tempBytes;
651     }
652 
653     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
654         require(_bytes.length >= (_start + 20));
655         address tempAddress;
656 
657         assembly {
658             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
659         }
660 
661         return tempAddress;
662     }
663 
664     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
665         require(_bytes.length >= (_start + 1));
666         uint8 tempUint;
667 
668         assembly {
669             tempUint := mload(add(add(_bytes, 0x1), _start))
670         }
671 
672         return tempUint;
673     }
674 
675     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
676         require(_bytes.length >= (_start + 2));
677         uint16 tempUint;
678 
679         assembly {
680             tempUint := mload(add(add(_bytes, 0x2), _start))
681         }
682 
683         return tempUint;
684     }
685 
686     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
687         require(_bytes.length >= (_start + 4));
688         uint32 tempUint;
689 
690         assembly {
691             tempUint := mload(add(add(_bytes, 0x4), _start))
692         }
693 
694         return tempUint;
695     }
696 
697     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
698         require(_bytes.length >= (_start + 8));
699         uint64 tempUint;
700 
701         assembly {
702             tempUint := mload(add(add(_bytes, 0x8), _start))
703         }
704 
705         return tempUint;
706     }
707 
708     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
709         require(_bytes.length >= (_start + 12));
710         uint96 tempUint;
711 
712         assembly {
713             tempUint := mload(add(add(_bytes, 0xc), _start))
714         }
715 
716         return tempUint;
717     }
718 
719     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
720         require(_bytes.length >= (_start + 16));
721         uint128 tempUint;
722 
723         assembly {
724             tempUint := mload(add(add(_bytes, 0x10), _start))
725         }
726 
727         return tempUint;
728     }
729 
730     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
731         require(_bytes.length >= (_start + 32));
732         uint256 tempUint;
733 
734         assembly {
735             tempUint := mload(add(add(_bytes, 0x20), _start))
736         }
737 
738         return tempUint;
739     }
740 
741     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
742         require(_bytes.length >= (_start + 32));
743         bytes32 tempBytes32;
744 
745         assembly {
746             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
747         }
748 
749         return tempBytes32;
750     }
751 
752     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
753         bool success = true;
754 
755         assembly {
756             let length := mload(_preBytes)
757 
758         // if lengths don't match the arrays are not equal
759             switch eq(length, mload(_postBytes))
760             case 1 {
761             // cb is a circuit breaker in the for loop since there's
762             //  no said feature for inline assembly loops
763             // cb = 1 - don't breaker
764             // cb = 0 - break
765                 let cb := 1
766 
767                 let mc := add(_preBytes, 0x20)
768                 let end := add(mc, length)
769 
770                 for {
771                     let cc := add(_postBytes, 0x20)
772                 // the next line is the loop condition:
773                 // while(uint(mc < end) + cb == 2)
774                 } eq(add(lt(mc, end), cb), 2) {
775                     mc := add(mc, 0x20)
776                     cc := add(cc, 0x20)
777                 } {
778                 // if any of these checks fails then arrays are not equal
779                     if iszero(eq(mload(mc), mload(cc))) {
780                     // unsuccess:
781                         success := 0
782                         cb := 0
783                     }
784                 }
785             }
786             default {
787             // unsuccess:
788                 success := 0
789             }
790         }
791 
792         return success;
793     }
794 
795     function equalStorage(
796         bytes storage _preBytes,
797         bytes memory _postBytes
798     )
799     internal
800     view
801     returns (bool)
802     {
803         bool success = true;
804 
805         assembly {
806         // we know _preBytes_offset is 0
807             let fslot := sload(_preBytes_slot)
808         // Decode the length of the stored array like in concatStorage().
809             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
810             let mlength := mload(_postBytes)
811 
812         // if lengths don't match the arrays are not equal
813             switch eq(slength, mlength)
814             case 1 {
815             // slength can contain both the length and contents of the array
816             // if length < 32 bytes so let's prepare for that
817             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
818                 if iszero(iszero(slength)) {
819                     switch lt(slength, 32)
820                     case 1 {
821                     // blank the last byte which is the length
822                         fslot := mul(div(fslot, 0x100), 0x100)
823 
824                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
825                         // unsuccess:
826                             success := 0
827                         }
828                     }
829                     default {
830                     // cb is a circuit breaker in the for loop since there's
831                     //  no said feature for inline assembly loops
832                     // cb = 1 - don't breaker
833                     // cb = 0 - break
834                         let cb := 1
835 
836                     // get the keccak hash to get the contents of the array
837                         mstore(0x0, _preBytes_slot)
838                         let sc := keccak256(0x0, 0x20)
839 
840                         let mc := add(_postBytes, 0x20)
841                         let end := add(mc, mlength)
842 
843                     // the next line is the loop condition:
844                     // while(uint(mc < end) + cb == 2)
845                         for {} eq(add(lt(mc, end), cb), 2) {
846                             sc := add(sc, 1)
847                             mc := add(mc, 0x20)
848                         } {
849                             if iszero(eq(sload(sc), mload(mc))) {
850                             // unsuccess:
851                                 success := 0
852                                 cb := 0
853                             }
854                         }
855                     }
856                 }
857             }
858             default {
859             // unsuccess:
860                 success := 0
861             }
862         }
863 
864         return success;
865     }
866 }
867 
868 interface IERC20Minter {
869     function mint(address to, uint256 amount) external;
870     function burn(uint256 amount) external;
871     function replaceMinter(address newMinter) external;
872 }
873 
874 contract NerveMultiSigWalletII {
875     using Address for address;
876     using SafeERC20 for IERC20;
877     using SafeMath for uint256;
878     using BytesLib for bytes;
879 
880     modifier isOwner{
881         require(owner == msg.sender, "Only owner can execute it");
882         _;
883     }
884     modifier isManager{
885         require(managers[msg.sender] == 1, "Only manager can execute it");
886         _;
887     }
888     bool public upgrade = false;
889     address public upgradeContractAddress = address(0);
890     // 最大管理员数量
891     uint public max_managers = 15;
892     // 最小签名比例 66%
893     uint public rate = 66;
894     // 签名字节长度
895     uint public signatureLength = 65;
896     // 比例分母
897     uint constant DENOMINATOR = 100;
898     // 当前合约版本
899     uint8 constant VERSION = 2;
900     // 当前交易的最小签名数量
901     uint8 public current_min_signatures;
902     address public owner;
903     mapping(address => uint8) private seedManagers;
904     address[] private seedManagerArray;
905     mapping(address => uint8) private managers;
906     address[] private managerArray;
907     mapping(bytes32 => uint8) private completedKeccak256s;
908     mapping(string => uint8) private completedTxs;
909     mapping(address => uint8) private minterERC20s;
910 
911     constructor(address[] memory _managers) public{
912         require(_managers.length <= max_managers, "Exceeded the maximum number of managers");
913         owner = msg.sender;
914         managerArray = _managers;
915         for (uint8 i = 0; i < managerArray.length; i++) {
916             managers[managerArray[i]] = 1;
917             seedManagers[managerArray[i]] = 1;
918             seedManagerArray.push(managerArray[i]);
919         }
920         require(managers[owner] == 0, "Contract creator cannot act as manager");
921         // 设置当前交易的最小签名数量
922         current_min_signatures = calMinSignatures(managerArray.length);
923     }
924     function() external payable {
925         emit DepositFunds(msg.sender, msg.value);
926     }
927 
928     function createOrSignWithdraw(string memory txKey, address payable to, uint256 amount, bool isERC20, address ERC20, bytes memory signatures) public isManager {
929         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
930         require(to != address(0), "Withdraw: transfer to the zero address");
931         require(amount > 0, "Withdrawal amount must be greater than 0");
932         // 校验已经完成的交易
933         require(completedTxs[txKey] == 0, "Transaction has been completed");
934         // 校验提现金额
935         if (isERC20) {
936             validateTransferERC20(ERC20, to, amount);
937         } else {
938             require(address(this).balance >= amount, "This contract address does not have sufficient balance of ether");
939         }
940         bytes32 vHash = keccak256(abi.encodePacked(txKey, to, amount, isERC20, ERC20, VERSION));
941         // 校验请求重复性
942         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
943         // 校验签名
944         require(validSignature(vHash, signatures), "Valid signatures fail");
945         // 执行转账
946         if (isERC20) {
947             transferERC20(ERC20, to, amount);
948         } else {
949             // 实际到账
950             require(address(this).balance >= amount, "This contract address does not have sufficient balance of ether");
951             to.transfer(amount);
952             emit TransferFunds(to, amount);
953         }
954         // 保存交易数据
955         completeTx(txKey, vHash, 1);
956         emit TxWithdrawCompleted(txKey);
957     }
958 
959 
960     function createOrSignManagerChange(string memory txKey, address[] memory adds, address[] memory removes, uint8 count, bytes memory signatures) public isManager {
961         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
962         require(adds.length > 0 || removes.length > 0, "There are no managers joining or exiting");
963         // 校验已经完成的交易
964         require(completedTxs[txKey] == 0, "Transaction has been completed");
965         preValidateAddsAndRemoves(adds, removes);
966         bytes32 vHash = keccak256(abi.encodePacked(txKey, adds, count, removes, VERSION));
967         // 校验请求重复性
968         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
969         // 校验签名
970         require(validSignature(vHash, signatures), "Valid signatures fail");
971         // 变更管理员
972         removeManager(removes);
973         addManager(adds);
974         // 更新当前交易的最小签名数
975         current_min_signatures = calMinSignatures(managerArray.length);
976         // 保存交易数据
977         completeTx(txKey, vHash, 1);
978         // add event
979         emit TxManagerChangeCompleted(txKey);
980     }
981 
982     function createOrSignUpgrade(string memory txKey, address upgradeContract, bytes memory signatures) public isManager {
983         require(bytes(txKey).length == 64, "Fixed length of txKey: 64");
984         // 校验已经完成的交易
985         require(completedTxs[txKey] == 0, "Transaction has been completed");
986         require(!upgrade, "It has been upgraded");
987         require(upgradeContract.isContract(), "The address is not a contract address");
988         // 校验
989         bytes32 vHash = keccak256(abi.encodePacked(txKey, upgradeContract, VERSION));
990         // 校验请求重复性
991         require(completedKeccak256s[vHash] == 0, "Invalid signatures");
992         // 校验签名
993         require(validSignature(vHash, signatures), "Valid signatures fail");
994         // 变更可升级
995         upgrade = true;
996         upgradeContractAddress = upgradeContract;
997         // 保存交易数据
998         completeTx(txKey, vHash, 1);
999         // add event
1000         emit TxUpgradeCompleted(txKey);
1001     }
1002 
1003     function validSignature(bytes32 hash, bytes memory signatures) internal view returns (bool) {
1004         require(signatures.length <= 975, "Max length of signatures: 975");
1005         // 获取签名列表对应的有效管理员,如果存在错误的签名、或者不是管理员的签名，就失败
1006         uint sManagersCount = getManagerFromSignatures(hash, signatures);
1007         // 判断最小签名数量
1008         return sManagersCount >= current_min_signatures;
1009     }
1010 
1011     function getManagerFromSignatures(bytes32 hash, bytes memory signatures) internal view returns (uint){
1012         uint signCount = 0;
1013         uint times = signatures.length.div(signatureLength);
1014         address[] memory result = new address[](times);
1015         uint k = 0;
1016         uint8 j = 0;
1017         for (uint i = 0; i < times; i++) {
1018             bytes memory sign = signatures.slice(k, signatureLength);
1019             address mAddress = ecrecovery(hash, sign);
1020             require(mAddress != address(0), "Signatures error");
1021             // 管理计数
1022             if (managers[mAddress] == 1) {
1023                 signCount++;
1024                 result[j++] = mAddress;
1025             }
1026             k += signatureLength;
1027         }
1028         // 验证地址重复性
1029         bool suc = repeatability(result);
1030         delete result;
1031         require(suc, "Signatures duplicate");
1032         return signCount;
1033     }
1034 
1035     function validateRepeatability(address currentAddress, address[] memory list) internal pure returns (bool) {
1036         address tempAddress;
1037         for (uint i = 0; i < list.length; i++) {
1038             tempAddress = list[i];
1039             if (tempAddress == address(0)) {
1040                 break;
1041             }
1042             if (tempAddress == currentAddress) {
1043                 return false;
1044             }
1045         }
1046         return true;
1047     }
1048 
1049     function repeatability(address[] memory list) internal pure returns (bool) {
1050         for (uint i = 0; i < list.length; i++) {
1051             address address1 = list[i];
1052             if (address1 == address(0)) {
1053                 break;
1054             }
1055             for (uint j = i + 1; j < list.length; j++) {
1056                 address address2 = list[j];
1057                 if (address2 == address(0)) {
1058                     break;
1059                 }
1060                 if (address1 == address2) {
1061                     return false;
1062                 }
1063             }
1064         }
1065         return true;
1066     }
1067 
1068     function ecrecovery(bytes32 hash, bytes memory sig) internal view returns (address) {
1069         bytes32 r;
1070         bytes32 s;
1071         uint8 v;
1072         if (sig.length != signatureLength) {
1073             return address(0);
1074         }
1075         assembly {
1076             r := mload(add(sig, 32))
1077             s := mload(add(sig, 64))
1078             v := byte(0, mload(add(sig, 96)))
1079         }
1080         // https://github.com/ethereum/go-ethereum/issues/2053
1081         if (v < 27) {
1082             v += 27;
1083         }
1084         if (v != 27 && v != 28) {
1085             return address(0);
1086         }
1087         return ecrecover(hash, v, r, s);
1088     }
1089 
1090     function preValidateAddsAndRemoves(address[] memory adds, address[] memory removes) internal view {
1091         // 校验adds
1092         uint addLen = adds.length;
1093         for (uint i = 0; i < addLen; i++) {
1094             address add = adds[i];
1095             require(add != address(0), "ERROR: Detected zero address in adds");
1096             require(managers[add] == 0, "The address list that is being added already exists as a manager");
1097         }
1098         require(repeatability(adds), "Duplicate parameters for the address to join");
1099         // 校验合约创建者不能被添加
1100         require(validateRepeatability(owner, adds), "Contract creator cannot act as manager");
1101         // 校验removes
1102         require(repeatability(removes), "Duplicate parameters for the address to exit");
1103         uint removeLen = removes.length;
1104         for (uint i = 0; i < removeLen; i++) {
1105             address remove = removes[i];
1106             require(seedManagers[remove] == 0, "Can't exit seed manager");
1107             require(managers[remove] == 1, "There are addresses in the exiting address list that are not manager");
1108         }
1109         require(managerArray.length + adds.length - removes.length <= max_managers, "Exceeded the maximum number of managers");
1110     }
1111 
1112     /*
1113      根据 `当前有效管理员数量` 和 `最小签名比例` 计算最小签名数量，向上取整
1114     */
1115     function calMinSignatures(uint managerCounts) internal view returns (uint8) {
1116         require(managerCounts > 0, "Manager Can't empty.");
1117         uint numerator = rate * managerCounts + DENOMINATOR - 1;
1118         return uint8(numerator / DENOMINATOR);
1119     }
1120     function removeManager(address[] memory removes) internal {
1121         if (removes.length == 0) {
1122             return;
1123         }
1124         for (uint i = 0; i < removes.length; i++) {
1125             delete managers[removes[i]];
1126         }
1127         // 遍历修改前管理员列表
1128         for (uint i = 0; i < managerArray.length; i++) {
1129             if (managers[managerArray[i]] == 0) {
1130                 delete managerArray[i];
1131             }
1132         }
1133         uint tempIndex = 0x10;
1134         for (uint i = 0; i<managerArray.length; i++) {
1135             address temp = managerArray[i];
1136             if (temp == address(0)) {
1137                 if (tempIndex == 0x10) tempIndex = i;
1138                 continue;
1139             } else if (tempIndex != 0x10) {
1140                 managerArray[tempIndex] = temp;
1141                 tempIndex++;
1142             }
1143         }
1144         managerArray.length -= removes.length;
1145     }
1146     function addManager(address[] memory adds) internal {
1147         if (adds.length == 0) {
1148             return;
1149         }
1150         for (uint i = 0; i < adds.length; i++) {
1151             address add = adds[i];
1152             if(managers[add] == 0) {
1153                 managers[add] = 1;
1154                 managerArray.push(add);
1155             }
1156         }
1157     }
1158     function completeTx(string memory txKey, bytes32 keccak256Hash, uint8 e) internal {
1159         completedTxs[txKey] = e;
1160         completedKeccak256s[keccak256Hash] = e;
1161     }
1162     function validateTransferERC20(address ERC20, address to, uint256 amount) internal view {
1163         require(to != address(0), "ERC20: transfer to the zero address");
1164         require(address(this) != ERC20, "Do nothing by yourself");
1165         require(ERC20.isContract(), "The address is not a contract address");
1166         if (isMinterERC20(ERC20)) {
1167             // 定制ERC20验证结束
1168             return;
1169         }
1170         IERC20 token = IERC20(ERC20);
1171         uint256 balance = token.balanceOf(address(this));
1172         require(balance >= amount, "No enough balance of token");
1173     }
1174     function transferERC20(address ERC20, address to, uint256 amount) internal {
1175         if (isMinterERC20(ERC20)) {
1176             // 定制的ERC20，跨链转入以太坊网络即增发
1177             IERC20Minter minterToken = IERC20Minter(ERC20);
1178             minterToken.mint(to, amount);
1179             return;
1180         }
1181         IERC20 token = IERC20(ERC20);
1182         uint256 balance = token.balanceOf(address(this));
1183         require(balance >= amount, "No enough balance of token");
1184         token.safeTransfer(to, amount);
1185     }
1186     function closeUpgrade() public isOwner {
1187         require(upgrade, "Denied");
1188         upgrade = false;
1189     }
1190     function upgradeContractS1() public isOwner {
1191         require(upgrade, "Denied");
1192         require(upgradeContractAddress != address(0), "ERROR: transfer to the zero address");
1193         address(uint160(upgradeContractAddress)).transfer(address(this).balance);
1194     }
1195     function upgradeContractS2(address ERC20) public isOwner {
1196         require(upgrade, "Denied");
1197         require(upgradeContractAddress != address(0), "ERROR: transfer to the zero address");
1198         require(address(this) != ERC20, "Do nothing by yourself");
1199         require(ERC20.isContract(), "The address is not a contract address");
1200         IERC20 token = IERC20(ERC20);
1201         uint256 balance = token.balanceOf(address(this));
1202         require(balance >= 0, "No enough balance of token");
1203         token.safeTransfer(upgradeContractAddress, balance);
1204         if (isMinterERC20(ERC20)) {
1205             // 定制的ERC20，转移增发销毁权限到新多签合约
1206             IERC20Minter minterToken = IERC20Minter(ERC20);
1207             minterToken.replaceMinter(upgradeContractAddress);
1208         }
1209     }
1210 
1211     // 是否定制的ERC20
1212     function isMinterERC20(address ERC20) public view returns (bool) {
1213         return minterERC20s[ERC20] > 0;
1214     }
1215 
1216     // 登记定制的ERC20
1217     function registerMinterERC20(address ERC20) public isOwner {
1218         require(address(this) != ERC20, "Do nothing by yourself");
1219         require(ERC20.isContract(), "The address is not a contract address");
1220         require(!isMinterERC20(ERC20), "This address has already been registered");
1221         minterERC20s[ERC20] = 1;
1222     }
1223 
1224     // 取消登记定制的ERC20
1225     function unregisterMinterERC20(address ERC20) public isOwner {
1226         require(isMinterERC20(ERC20), "This address is not registered");
1227         delete minterERC20s[ERC20];
1228     }
1229 
1230     // 从eth网络跨链转出资产(ETH or ERC20)
1231     function crossOut(string memory to, uint256 amount, address ERC20) public payable returns (bool) {
1232         address from = msg.sender;
1233         require(amount > 0, "ERROR: Zero amount");
1234         if (ERC20 != address(0)) {
1235             require(msg.value == 0, "ERC20: Does not accept Ethereum Coin");
1236             require(ERC20.isContract(), "The address is not a contract address");
1237             IERC20 token = IERC20(ERC20);
1238             uint256 allowance = token.allowance(from, address(this));
1239             require(allowance >= amount, "No enough amount for authorization");
1240             uint256 fromBalance = token.balanceOf(from);
1241             require(fromBalance >= amount, "No enough balance of the token");
1242             token.safeTransferFrom(from, address(this), amount);
1243             if (isMinterERC20(ERC20)) {
1244                 // 定制的ERC20，从以太坊网络跨链转出token即销毁
1245                 IERC20Minter minterToken = IERC20Minter(ERC20);
1246                 minterToken.burn(amount);
1247             }
1248         } else {
1249             require(msg.value == amount, "Inconsistency Ethereum amount");
1250         }
1251         emit CrossOutFunds(from, to, amount, ERC20);
1252         return true;
1253     }
1254 
1255     function isCompletedTx(string memory txKey) public view returns (bool){
1256         return completedTxs[txKey] > 0;
1257     }
1258     function ifManager(address _manager) public view returns (bool) {
1259         return managers[_manager] == 1;
1260     }
1261     function allManagers() public view returns (address[] memory) {
1262         return managerArray;
1263     }
1264     event DepositFunds(address from, uint amount);
1265     event CrossOutFunds(address from, string to, uint amount, address ERC20);
1266     event TransferFunds(address to, uint amount);
1267     event TxWithdrawCompleted(string txKey);
1268     event TxManagerChangeCompleted(string txKey);
1269     event TxUpgradeCompleted(string txKey);
1270 }