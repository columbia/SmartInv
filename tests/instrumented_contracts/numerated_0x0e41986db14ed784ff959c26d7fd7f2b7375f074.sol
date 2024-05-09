1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount)
29         external
30         returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 // File: @openzeppelin/contracts/math/SafeMath.sol
95 
96 pragma solidity ^0.6.0;
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(
154         uint256 a,
155         uint256 b,
156         string memory errorMessage
157     ) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
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
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(
257         uint256 a,
258         uint256 b,
259         string memory errorMessage
260     ) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 pragma solidity ^0.6.2;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296 
297             bytes32 accountHash
298          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly {
301             codehash := extcodehash(account)
302         }
303         return (codehash != accountHash && codehash != 0x0);
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(
324             address(this).balance >= amount,
325             "Address: insufficient balance"
326         );
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{value: amount}("");
330         require(
331             success,
332             "Address: unable to send value, recipient may have reverted"
333         );
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data)
355         internal
356         returns (bytes memory)
357     {
358         return functionCall(target, data, "Address: low-level call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
363      * `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         return _functionCallWithValue(target, data, 0, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but also transferring `value` wei to `target`.
378      *
379      * Requirements:
380      *
381      * - the calling contract must have an ETH balance of at least `value`.
382      * - the called Solidity function must be `payable`.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(
387         address target,
388         bytes memory data,
389         uint256 value
390     ) internal returns (bytes memory) {
391         return
392             functionCallWithValue(
393                 target,
394                 data,
395                 value,
396                 "Address: low-level call with value failed"
397             );
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
402      * with `errorMessage` as a fallback revert reason when `target` reverts.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         require(
413             address(this).balance >= value,
414             "Address: insufficient balance for call"
415         );
416         return _functionCallWithValue(target, data, value, errorMessage);
417     }
418 
419     function _functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 weiValue,
423         string memory errorMessage
424     ) private returns (bytes memory) {
425         require(isContract(target), "Address: call to non-contract");
426 
427         // solhint-disable-next-line avoid-low-level-calls
428         (bool success, bytes memory returndata) = target.call{value: weiValue}(
429             data
430         );
431         if (success) {
432             return returndata;
433         } else {
434             // Look for revert reason and bubble it up if present
435             if (returndata.length > 0) {
436                 // The easiest way to bubble the revert reason is using memory via assembly
437 
438                 // solhint-disable-next-line no-inline-assembly
439                 assembly {
440                     let returndata_size := mload(returndata)
441                     revert(add(32, returndata), returndata_size)
442                 }
443             } else {
444                 revert(errorMessage);
445             }
446         }
447     }
448 }
449 
450 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
451 
452 pragma solidity ^0.6.0;
453 
454 /**
455  * @title SafeERC20
456  * @dev Wrappers around ERC20 operations that throw on failure (when the token
457  * contract returns false). Tokens that return no value (and instead revert or
458  * throw on failure) are also supported, non-reverting calls are assumed to be
459  * successful.
460  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
461  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
462  */
463 library SafeERC20 {
464     using SafeMath for uint256;
465     using Address for address;
466 
467     function safeTransfer(
468         IERC20 token,
469         address to,
470         uint256 value
471     ) internal {
472         _callOptionalReturn(
473             token,
474             abi.encodeWithSelector(token.transfer.selector, to, value)
475         );
476     }
477 
478     function safeTransferFrom(
479         IERC20 token,
480         address from,
481         address to,
482         uint256 value
483     ) internal {
484         _callOptionalReturn(
485             token,
486             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
487         );
488     }
489 
490     /**
491      * @dev Deprecated. This function has issues similar to the ones found in
492      * {IERC20-approve}, and its usage is discouraged.
493      *
494      * Whenever possible, use {safeIncreaseAllowance} and
495      * {safeDecreaseAllowance} instead.
496      */
497     function safeApprove(
498         IERC20 token,
499         address spender,
500         uint256 value
501     ) internal {
502         // safeApprove should only be called when setting an initial allowance,
503         // or when resetting it to zero. To increase and decrease it, use
504         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
505         // solhint-disable-next-line max-line-length
506         require(
507             (value == 0) || (token.allowance(address(this), spender) == 0),
508             "SafeERC20: approve from non-zero to non-zero allowance"
509         );
510         _callOptionalReturn(
511             token,
512             abi.encodeWithSelector(token.approve.selector, spender, value)
513         );
514     }
515 
516     function safeIncreaseAllowance(
517         IERC20 token,
518         address spender,
519         uint256 value
520     ) internal {
521         uint256 newAllowance = token.allowance(address(this), spender).add(
522             value
523         );
524         _callOptionalReturn(
525             token,
526             abi.encodeWithSelector(
527                 token.approve.selector,
528                 spender,
529                 newAllowance
530             )
531         );
532     }
533 
534     function safeDecreaseAllowance(
535         IERC20 token,
536         address spender,
537         uint256 value
538     ) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).sub(
540             value,
541             "SafeERC20: decreased allowance below zero"
542         );
543         _callOptionalReturn(
544             token,
545             abi.encodeWithSelector(
546                 token.approve.selector,
547                 spender,
548                 newAllowance
549             )
550         );
551     }
552 
553     /**
554      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
555      * on the return value: the return value is optional (but if data is returned, it must not be false).
556      * @param token The token targeted by the call.
557      * @param data The call data (encoded using abi.encode or one of its variants).
558      */
559     function _callOptionalReturn(IERC20 token, bytes memory data) private {
560         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
561         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
562         // the target address contains contract code and also asserts for success in the low-level call.
563 
564         bytes memory returndata = address(token).functionCall(
565             data,
566             "SafeERC20: low-level call failed"
567         );
568         if (returndata.length > 0) {
569             // Return data is optional
570             // solhint-disable-next-line max-line-length
571             require(
572                 abi.decode(returndata, (bool)),
573                 "SafeERC20: ERC20 operation did not succeed"
574             );
575         }
576     }
577 }
578 
579 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
580 
581 pragma solidity ^0.6.0;
582 
583 /**
584  * @dev Library for managing
585  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
586  * types.
587  *
588  * Sets have the following properties:
589  *
590  * - Elements are added, removed, and checked for existence in constant time
591  * (O(1)).
592  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
593  *
594  * ```
595  * contract Example {
596  *     // Add the library methods
597  *     using EnumerableSet for EnumerableSet.AddressSet;
598  *
599  *     // Declare a set state variable
600  *     EnumerableSet.AddressSet private mySet;
601  * }
602  * ```
603  *
604  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
605  * (`UintSet`) are supported.
606  */
607 library EnumerableSet {
608     // To implement this library for multiple types with as little code
609     // repetition as possible, we write it in terms of a generic Set type with
610     // bytes32 values.
611     // The Set implementation uses private functions, and user-facing
612     // implementations (such as AddressSet) are just wrappers around the
613     // underlying Set.
614     // This means that we can only create new EnumerableSets for types that fit
615     // in bytes32.
616 
617     struct Set {
618         // Storage of set values
619         bytes32[] _values;
620         // Position of the value in the `values` array, plus 1 because index 0
621         // means a value is not in the set.
622         mapping(bytes32 => uint256) _indexes;
623     }
624 
625     /**
626      * @dev Add a value to a set. O(1).
627      *
628      * Returns true if the value was added to the set, that is if it was not
629      * already present.
630      */
631     function _add(Set storage set, bytes32 value) private returns (bool) {
632         if (!_contains(set, value)) {
633             set._values.push(value);
634             // The value is stored at length-1, but we add 1 to all indexes
635             // and use 0 as a sentinel value
636             set._indexes[value] = set._values.length;
637             return true;
638         } else {
639             return false;
640         }
641     }
642 
643     /**
644      * @dev Removes a value from a set. O(1).
645      *
646      * Returns true if the value was removed from the set, that is if it was
647      * present.
648      */
649     function _remove(Set storage set, bytes32 value) private returns (bool) {
650         // We read and store the value's index to prevent multiple reads from the same storage slot
651         uint256 valueIndex = set._indexes[value];
652 
653         if (valueIndex != 0) {
654             // Equivalent to contains(set, value)
655             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
656             // the array, and then remove the last element (sometimes called as 'swap and pop').
657             // This modifies the order of the array, as noted in {at}.
658 
659             uint256 toDeleteIndex = valueIndex - 1;
660             uint256 lastIndex = set._values.length - 1;
661 
662             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
663             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
664 
665             bytes32 lastvalue = set._values[lastIndex];
666 
667             // Move the last value to the index where the value to delete is
668             set._values[toDeleteIndex] = lastvalue;
669             // Update the index for the moved value
670             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
671 
672             // Delete the slot where the moved value was stored
673             set._values.pop();
674 
675             // Delete the index for the deleted slot
676             delete set._indexes[value];
677 
678             return true;
679         } else {
680             return false;
681         }
682     }
683 
684     /**
685      * @dev Returns true if the value is in the set. O(1).
686      */
687     function _contains(Set storage set, bytes32 value)
688         private
689         view
690         returns (bool)
691     {
692         return set._indexes[value] != 0;
693     }
694 
695     /**
696      * @dev Returns the number of values on the set. O(1).
697      */
698     function _length(Set storage set) private view returns (uint256) {
699         return set._values.length;
700     }
701 
702     /**
703      * @dev Returns the value stored at position `index` in the set. O(1).
704      *
705      * Note that there are no guarantees on the ordering of values inside the
706      * array, and it may change when more values are added or removed.
707      *
708      * Requirements:
709      *
710      * - `index` must be strictly less than {length}.
711      */
712     function _at(Set storage set, uint256 index)
713         private
714         view
715         returns (bytes32)
716     {
717         require(
718             set._values.length > index,
719             "EnumerableSet: index out of bounds"
720         );
721         return set._values[index];
722     }
723 
724     // AddressSet
725 
726     struct AddressSet {
727         Set _inner;
728     }
729 
730     /**
731      * @dev Add a value to a set. O(1).
732      *
733      * Returns true if the value was added to the set, that is if it was not
734      * already present.
735      */
736     function add(AddressSet storage set, address value)
737         internal
738         returns (bool)
739     {
740         return _add(set._inner, bytes32(uint256(value)));
741     }
742 
743     /**
744      * @dev Removes a value from a set. O(1).
745      *
746      * Returns true if the value was removed from the set, that is if it was
747      * present.
748      */
749     function remove(AddressSet storage set, address value)
750         internal
751         returns (bool)
752     {
753         return _remove(set._inner, bytes32(uint256(value)));
754     }
755 
756     /**
757      * @dev Returns true if the value is in the set. O(1).
758      */
759     function contains(AddressSet storage set, address value)
760         internal
761         view
762         returns (bool)
763     {
764         return _contains(set._inner, bytes32(uint256(value)));
765     }
766 
767     /**
768      * @dev Returns the number of values in the set. O(1).
769      */
770     function length(AddressSet storage set) internal view returns (uint256) {
771         return _length(set._inner);
772     }
773 
774     /**
775      * @dev Returns the value stored at position `index` in the set. O(1).
776      *
777      * Note that there are no guarantees on the ordering of values inside the
778      * array, and it may change when more values are added or removed.
779      *
780      * Requirements:
781      *
782      * - `index` must be strictly less than {length}.
783      */
784     function at(AddressSet storage set, uint256 index)
785         internal
786         view
787         returns (address)
788     {
789         return address(uint256(_at(set._inner, index)));
790     }
791 
792     // UintSet
793 
794     struct UintSet {
795         Set _inner;
796     }
797 
798     /**
799      * @dev Add a value to a set. O(1).
800      *
801      * Returns true if the value was added to the set, that is if it was not
802      * already present.
803      */
804     function add(UintSet storage set, uint256 value) internal returns (bool) {
805         return _add(set._inner, bytes32(value));
806     }
807 
808     /**
809      * @dev Removes a value from a set. O(1).
810      *
811      * Returns true if the value was removed from the set, that is if it was
812      * present.
813      */
814     function remove(UintSet storage set, uint256 value)
815         internal
816         returns (bool)
817     {
818         return _remove(set._inner, bytes32(value));
819     }
820 
821     /**
822      * @dev Returns true if the value is in the set. O(1).
823      */
824     function contains(UintSet storage set, uint256 value)
825         internal
826         view
827         returns (bool)
828     {
829         return _contains(set._inner, bytes32(value));
830     }
831 
832     /**
833      * @dev Returns the number of values on the set. O(1).
834      */
835     function length(UintSet storage set) internal view returns (uint256) {
836         return _length(set._inner);
837     }
838 
839     /**
840      * @dev Returns the value stored at position `index` in the set. O(1).
841      *
842      * Note that there are no guarantees on the ordering of values inside the
843      * array, and it may change when more values are added or removed.
844      *
845      * Requirements:
846      *
847      * - `index` must be strictly less than {length}.
848      */
849     function at(UintSet storage set, uint256 index)
850         internal
851         view
852         returns (uint256)
853     {
854         return uint256(_at(set._inner, index));
855     }
856 }
857 
858 // File: @openzeppelin/contracts/GSN/Context.sol
859 
860 pragma solidity ^0.6.0;
861 
862 /*
863  * @dev Provides information about the current execution context, including the
864  * sender of the transaction and its data. While these are generally available
865  * via msg.sender and msg.data, they should not be accessed in such a direct
866  * manner, since when dealing with GSN meta-transactions the account sending and
867  * paying for execution may not be the actual sender (as far as an application
868  * is concerned).
869  *
870  * This contract is only required for intermediate, library-like contracts.
871  */
872 abstract contract Context {
873     function _msgSender() internal virtual view returns (address payable) {
874         return msg.sender;
875     }
876 
877     function _msgData() internal virtual view returns (bytes memory) {
878         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
879         return msg.data;
880     }
881 }
882 
883 // File: @openzeppelin/contracts/access/Ownable.sol
884 
885 pragma solidity ^0.6.0;
886 
887 /**
888  * @dev Contract module which provides a basic access control mechanism, where
889  * there is an account (an owner) that can be granted exclusive access to
890  * specific functions.
891  *
892  * By default, the owner account will be the one that deploys the contract. This
893  * can later be changed with {transferOwnership}.
894  *
895  * This module is used through inheritance. It will make available the modifier
896  * `onlyOwner`, which can be applied to your functions to restrict their use to
897  * the owner.
898  */
899 contract Ownable is Context {
900     address private _owner;
901 
902     event OwnershipTransferred(
903         address indexed previousOwner,
904         address indexed newOwner
905     );
906 
907     /**
908      * @dev Initializes the contract setting the deployer as the initial owner.
909      */
910     constructor() internal {
911         address msgSender = _msgSender();
912         _owner = msgSender;
913         emit OwnershipTransferred(address(0), msgSender);
914     }
915 
916     /**
917      * @dev Returns the address of the current owner.
918      */
919     function owner() public view returns (address) {
920         return _owner;
921     }
922 
923     /**
924      * @dev Throws if called by any account other than the owner.
925      */
926     modifier onlyOwner() {
927         require(_owner == _msgSender(), "Ownable: caller is not the owner");
928         _;
929     }
930 
931     /**
932      * @dev Leaves the contract without owner. It will not be possible to call
933      * `onlyOwner` functions anymore. Can only be called by the current owner.
934      *
935      * NOTE: Renouncing ownership will leave the contract without an owner,
936      * thereby removing any functionality that is only available to the owner.
937      */
938     function renounceOwnership() public virtual onlyOwner {
939         emit OwnershipTransferred(_owner, address(0));
940         _owner = address(0);
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public virtual onlyOwner {
948         require(
949             newOwner != address(0),
950             "Ownable: new owner is the zero address"
951         );
952         emit OwnershipTransferred(_owner, newOwner);
953         _owner = newOwner;
954     }
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
958 
959 pragma solidity ^0.6.0;
960 
961 /**
962  * @dev Implementation of the {IERC20} interface.
963  *
964  * This implementation is agnostic to the way tokens are created. This means
965  * that a supply mechanism has to be added in a derived contract using {_mint}.
966  * For a generic mechanism see {ERC20PresetMinterPauser}.
967  *
968  * TIP: For a detailed writeup see our guide
969  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
970  * to implement supply mechanisms].
971  *
972  * We have followed general OpenZeppelin guidelines: functions revert instead
973  * of returning `false` on failure. This behavior is nonetheless conventional
974  * and does not conflict with the expectations of ERC20 applications.
975  *
976  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
977  * This allows applications to reconstruct the allowance for all accounts just
978  * by listening to said events. Other implementations of the EIP may not emit
979  * these events, as it isn't required by the specification.
980  *
981  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
982  * functions have been added to mitigate the well-known issues around setting
983  * allowances. See {IERC20-approve}.
984  */
985 contract ERC20 is Context, IERC20 {
986     using SafeMath for uint256;
987     using Address for address;
988 
989     mapping(address => uint256) private _balances;
990 
991     mapping(address => mapping(address => uint256)) private _allowances;
992 
993     uint256 private _totalSupply;
994 
995     string private _name;
996     string private _symbol;
997     uint8 private _decimals;
998 
999     /**
1000      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1001      * a default value of 18.
1002      *
1003      * To select a different value for {decimals}, use {_setupDecimals}.
1004      *
1005      * All three of these values are immutable: they can only be set once during
1006      * construction.
1007      */
1008     constructor(string memory name, string memory symbol) public {
1009         _name = name;
1010         _symbol = symbol;
1011         _decimals = 18;
1012     }
1013 
1014     /**
1015      * @dev Returns the name of the token.
1016      */
1017     function name() public view returns (string memory) {
1018         return _name;
1019     }
1020 
1021     /**
1022      * @dev Returns the symbol of the token, usually a shorter version of the
1023      * name.
1024      */
1025     function symbol() public view returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev Returns the number of decimals used to get its user representation.
1031      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1032      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1033      *
1034      * Tokens usually opt for a value of 18, imitating the relationship between
1035      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1036      * called.
1037      *
1038      * NOTE: This information is only used for _display_ purposes: it in
1039      * no way affects any of the arithmetic of the contract, including
1040      * {IERC20-balanceOf} and {IERC20-transfer}.
1041      */
1042     function decimals() public view returns (uint8) {
1043         return _decimals;
1044     }
1045 
1046     /**
1047      * @dev See {IERC20-totalSupply}.
1048      */
1049     function totalSupply() public override view returns (uint256) {
1050         return _totalSupply;
1051     }
1052 
1053     /**
1054      * @dev See {IERC20-balanceOf}.
1055      */
1056     function balanceOf(address account) public override view returns (uint256) {
1057         return _balances[account];
1058     }
1059 
1060     /**
1061      * @dev See {IERC20-transfer}.
1062      *
1063      * Requirements:
1064      *
1065      * - `recipient` cannot be the zero address.
1066      * - the caller must have a balance of at least `amount`.
1067      */
1068     function transfer(address recipient, uint256 amount)
1069         public
1070         virtual
1071         override
1072         returns (bool)
1073     {
1074         _transfer(_msgSender(), recipient, amount);
1075         return true;
1076     }
1077 
1078     /**
1079      * @dev See {IERC20-allowance}.
1080      */
1081     function allowance(address owner, address spender)
1082         public
1083         virtual
1084         override
1085         view
1086         returns (uint256)
1087     {
1088         return _allowances[owner][spender];
1089     }
1090 
1091     /**
1092      * @dev See {IERC20-approve}.
1093      *
1094      * Requirements:
1095      *
1096      * - `spender` cannot be the zero address.
1097      */
1098     function approve(address spender, uint256 amount)
1099         public
1100         virtual
1101         override
1102         returns (bool)
1103     {
1104         _approve(_msgSender(), spender, amount);
1105         return true;
1106     }
1107 
1108     /**
1109      * @dev See {IERC20-transferFrom}.
1110      *
1111      * Emits an {Approval} event indicating the updated allowance. This is not
1112      * required by the EIP. See the note at the beginning of {ERC20};
1113      *
1114      * Requirements:
1115      * - `sender` and `recipient` cannot be the zero address.
1116      * - `sender` must have a balance of at least `amount`.
1117      * - the caller must have allowance for ``sender``'s tokens of at least
1118      * `amount`.
1119      */
1120     function transferFrom(
1121         address sender,
1122         address recipient,
1123         uint256 amount
1124     ) public virtual override returns (bool) {
1125         _transfer(sender, recipient, amount);
1126         _approve(
1127             sender,
1128             _msgSender(),
1129             _allowances[sender][_msgSender()].sub(
1130                 amount,
1131                 "ERC20: transfer amount exceeds allowance"
1132             )
1133         );
1134         return true;
1135     }
1136 
1137     /**
1138      * @dev Atomically increases the allowance granted to `spender` by the caller.
1139      *
1140      * This is an alternative to {approve} that can be used as a mitigation for
1141      * problems described in {IERC20-approve}.
1142      *
1143      * Emits an {Approval} event indicating the updated allowance.
1144      *
1145      * Requirements:
1146      *
1147      * - `spender` cannot be the zero address.
1148      */
1149     function increaseAllowance(address spender, uint256 addedValue)
1150         public
1151         virtual
1152         returns (bool)
1153     {
1154         _approve(
1155             _msgSender(),
1156             spender,
1157             _allowances[_msgSender()][spender].add(addedValue)
1158         );
1159         return true;
1160     }
1161 
1162     /**
1163      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1164      *
1165      * This is an alternative to {approve} that can be used as a mitigation for
1166      * problems described in {IERC20-approve}.
1167      *
1168      * Emits an {Approval} event indicating the updated allowance.
1169      *
1170      * Requirements:
1171      *
1172      * - `spender` cannot be the zero address.
1173      * - `spender` must have allowance for the caller of at least
1174      * `subtractedValue`.
1175      */
1176     function decreaseAllowance(address spender, uint256 subtractedValue)
1177         public
1178         virtual
1179         returns (bool)
1180     {
1181         _approve(
1182             _msgSender(),
1183             spender,
1184             _allowances[_msgSender()][spender].sub(
1185                 subtractedValue,
1186                 "ERC20: decreased allowance below zero"
1187             )
1188         );
1189         return true;
1190     }
1191 
1192     /**
1193      * @dev Moves tokens `amount` from `sender` to `recipient`.
1194      *
1195      * This is internal function is equivalent to {transfer}, and can be used to
1196      * e.g. implement automatic token fees, slashing mechanisms, etc.
1197      *
1198      * Emits a {Transfer} event.
1199      *
1200      * Requirements:
1201      *
1202      * - `sender` cannot be the zero address.
1203      * - `recipient` cannot be the zero address.
1204      * - `sender` must have a balance of at least `amount`.
1205      */
1206     function _transfer(
1207         address sender,
1208         address recipient,
1209         uint256 amount
1210     ) internal virtual {
1211         require(sender != address(0), "ERC20: transfer from the zero address");
1212         require(recipient != address(0), "ERC20: transfer to the zero address");
1213 
1214         _beforeTokenTransfer(sender, recipient, amount);
1215 
1216         _balances[sender] = _balances[sender].sub(
1217             amount,
1218             "ERC20: transfer amount exceeds balance"
1219         );
1220         _balances[recipient] = _balances[recipient].add(amount);
1221         emit Transfer(sender, recipient, amount);
1222     }
1223 
1224     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1225      * the total supply.
1226      *
1227      * Emits a {Transfer} event with `from` set to the zero address.
1228      *
1229      * Requirements
1230      *
1231      * - `to` cannot be the zero address.
1232      */
1233     function _mint(address account, uint256 amount) internal virtual {
1234         require(account != address(0), "ERC20: mint to the zero address");
1235 
1236         _beforeTokenTransfer(address(0), account, amount);
1237 
1238         _totalSupply = _totalSupply.add(amount);
1239         _balances[account] = _balances[account].add(amount);
1240         emit Transfer(address(0), account, amount);
1241     }
1242 
1243     /**
1244      * @dev Destroys `amount` tokens from `account`, reducing the
1245      * total supply.
1246      *
1247      * Emits a {Transfer} event with `to` set to the zero address.
1248      *
1249      * Requirements
1250      *
1251      * - `account` cannot be the zero address.
1252      * - `account` must have at least `amount` tokens.
1253      */
1254     function _burn(address account, uint256 amount) internal virtual {
1255         require(account != address(0), "ERC20: burn from the zero address");
1256 
1257         _beforeTokenTransfer(account, address(0), amount);
1258 
1259         _balances[account] = _balances[account].sub(
1260             amount,
1261             "ERC20: burn amount exceeds balance"
1262         );
1263         _totalSupply = _totalSupply.sub(amount);
1264         emit Transfer(account, address(0), amount);
1265     }
1266 
1267     /**
1268      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1269      *
1270      * This is internal function is equivalent to `approve`, and can be used to
1271      * e.g. set automatic allowances for certain subsystems, etc.
1272      *
1273      * Emits an {Approval} event.
1274      *
1275      * Requirements:
1276      *
1277      * - `owner` cannot be the zero address.
1278      * - `spender` cannot be the zero address.
1279      */
1280     function _approve(
1281         address owner,
1282         address spender,
1283         uint256 amount
1284     ) internal virtual {
1285         require(owner != address(0), "ERC20: approve from the zero address");
1286         require(spender != address(0), "ERC20: approve to the zero address");
1287 
1288         _allowances[owner][spender] = amount;
1289         emit Approval(owner, spender, amount);
1290     }
1291 
1292     /**
1293      * @dev Sets {decimals} to a value other than the default one of 18.
1294      *
1295      * WARNING: This function should only be called from the constructor. Most
1296      * applications that interact with token contracts will not expect
1297      * {decimals} to ever change, and may work incorrectly if it does.
1298      */
1299     function _setupDecimals(uint8 decimals_) internal {
1300         _decimals = decimals_;
1301     }
1302 
1303     /**
1304      * @dev Hook that is called before any transfer of tokens. This includes
1305      * minting and burning.
1306      *
1307      * Calling conditions:
1308      *
1309      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1310      * will be to transferred to `to`.
1311      * - when `from` is zero, `amount` tokens will be minted for `to`.
1312      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1313      * - `from` and `to` are never both zero.
1314      *
1315      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1316      */
1317     function _beforeTokenTransfer(
1318         address from,
1319         address to,
1320         uint256 amount
1321     ) internal virtual {}
1322 }
1323 
1324 // File: contracts/LockToken.sol
1325 
1326 pragma solidity 0.6.12;
1327 
1328 // LockToken with Governance.
1329 contract LockToken is ERC20("LockToken", "LOCK"), Ownable {
1330     constructor() public {
1331         // pre-allocation 2.7M
1332         _mint(msg.sender, 2700000000000000000000000);
1333     }
1334 
1335     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (KeyMaster).
1336     function mint(address _to, uint256 _amount) public onlyOwner {
1337         _mint(_to, _amount);
1338         _moveDelegates(address(0), _delegates[_to], _amount);
1339     }
1340 
1341     // Copied and modified from YAM code:
1342     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1343     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1344     // Which is copied and modified from COMPOUND:
1345     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1346 
1347     /// @dev A record of each accounts delegate
1348     mapping(address => address) internal _delegates;
1349 
1350     /// @notice A checkpoint for marking number of votes from a given block
1351     struct Checkpoint {
1352         uint32 fromBlock;
1353         uint256 votes;
1354     }
1355 
1356     /// @notice A record of votes checkpoints for each account, by index
1357     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
1358 
1359     /// @notice The number of checkpoints for each account
1360     mapping(address => uint32) public numCheckpoints;
1361 
1362     /// @notice The EIP-712 typehash for the contract's domain
1363     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
1364         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
1365     );
1366 
1367     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1368     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
1369         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
1370     );
1371 
1372     /// @notice A record of states for signing / validating signatures
1373     mapping(address => uint256) public nonces;
1374 
1375     /// @notice An event thats emitted when an account changes its delegate
1376     event DelegateChanged(
1377         address indexed delegator,
1378         address indexed fromDelegate,
1379         address indexed toDelegate
1380     );
1381 
1382     /// @notice An event thats emitted when a delegate account's vote balance changes
1383     event DelegateVotesChanged(
1384         address indexed delegate,
1385         uint256 previousBalance,
1386         uint256 newBalance
1387     );
1388 
1389     /**
1390      * @notice Get delegatee
1391      * @param delegator The address to get delegatee for
1392      */
1393     function delegates(address delegator) external view returns (address) {
1394         return _delegates[delegator];
1395     }
1396 
1397     /**
1398      * @notice Delegate votes from `msg.sender` to `delegatee`
1399      * @param delegatee The address to delegate votes to
1400      */
1401     function delegate(address delegatee) external {
1402         return _delegate(msg.sender, delegatee);
1403     }
1404 
1405     /**
1406      * @notice Delegates votes from signatory to `delegatee`
1407      * @param delegatee The address to delegate votes to
1408      * @param nonce The contract state required to match the signature
1409      * @param expiry The time at which to expire the signature
1410      * @param v The recovery byte of the signature
1411      * @param r Half of the ECDSA signature pair
1412      * @param s Half of the ECDSA signature pair
1413      */
1414     function delegateBySig(
1415         address delegatee,
1416         uint256 nonce,
1417         uint256 expiry,
1418         uint8 v,
1419         bytes32 r,
1420         bytes32 s
1421     ) external {
1422         bytes32 domainSeparator = keccak256(
1423             abi.encode(
1424                 DOMAIN_TYPEHASH,
1425                 keccak256(bytes(name())),
1426                 getChainId(),
1427                 address(this)
1428             )
1429         );
1430 
1431         bytes32 structHash = keccak256(
1432             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1433         );
1434 
1435         bytes32 digest = keccak256(
1436             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1437         );
1438 
1439         address signatory = ecrecover(digest, v, r, s);
1440         require(
1441             signatory != address(0),
1442             "LOCK::delegateBySig: invalid signature"
1443         );
1444         require(
1445             nonce == nonces[signatory]++,
1446             "LOCK::delegateBySig: invalid nonce"
1447         );
1448         require(now <= expiry, "LOCK::delegateBySig: signature expired");
1449         return _delegate(signatory, delegatee);
1450     }
1451 
1452     /**
1453      * @notice Gets the current votes balance for `account`
1454      * @param account The address to get votes balance
1455      * @return The number of current votes for `account`
1456      */
1457     function getCurrentVotes(address account) external view returns (uint256) {
1458         uint32 nCheckpoints = numCheckpoints[account];
1459         return
1460             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1461     }
1462 
1463     /**
1464      * @notice Determine the prior number of votes for an account as of a block number
1465      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1466      * @param account The address of the account to check
1467      * @param blockNumber The block number to get the vote balance at
1468      * @return The number of votes the account had as of the given block
1469      */
1470     function getPriorVotes(address account, uint256 blockNumber)
1471         external
1472         view
1473         returns (uint256)
1474     {
1475         require(
1476             blockNumber < block.number,
1477             "LOCK::getPriorVotes: not yet determined"
1478         );
1479 
1480         uint32 nCheckpoints = numCheckpoints[account];
1481         if (nCheckpoints == 0) {
1482             return 0;
1483         }
1484 
1485         // First check most recent balance
1486         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1487             return checkpoints[account][nCheckpoints - 1].votes;
1488         }
1489 
1490         // Next check implicit zero balance
1491         if (checkpoints[account][0].fromBlock > blockNumber) {
1492             return 0;
1493         }
1494 
1495         uint32 lower = 0;
1496         uint32 upper = nCheckpoints - 1;
1497         while (upper > lower) {
1498             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1499             Checkpoint memory cp = checkpoints[account][center];
1500             if (cp.fromBlock == blockNumber) {
1501                 return cp.votes;
1502             } else if (cp.fromBlock < blockNumber) {
1503                 lower = center;
1504             } else {
1505                 upper = center - 1;
1506             }
1507         }
1508         return checkpoints[account][lower].votes;
1509     }
1510 
1511     function _delegate(address delegator, address delegatee) internal {
1512         address currentDelegate = _delegates[delegator];
1513         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying LOCKs (not scaled);
1514         _delegates[delegator] = delegatee;
1515 
1516         emit DelegateChanged(delegator, currentDelegate, delegatee);
1517 
1518         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1519     }
1520 
1521     function _moveDelegates(
1522         address srcRep,
1523         address dstRep,
1524         uint256 amount
1525     ) internal {
1526         if (srcRep != dstRep && amount > 0) {
1527             if (srcRep != address(0)) {
1528                 // decrease old representative
1529                 uint32 srcRepNum = numCheckpoints[srcRep];
1530                 uint256 srcRepOld = srcRepNum > 0
1531                     ? checkpoints[srcRep][srcRepNum - 1].votes
1532                     : 0;
1533                 uint256 srcRepNew = srcRepOld.sub(amount);
1534                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1535             }
1536 
1537             if (dstRep != address(0)) {
1538                 // increase new representative
1539                 uint32 dstRepNum = numCheckpoints[dstRep];
1540                 uint256 dstRepOld = dstRepNum > 0
1541                     ? checkpoints[dstRep][dstRepNum - 1].votes
1542                     : 0;
1543                 uint256 dstRepNew = dstRepOld.add(amount);
1544                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1545             }
1546         }
1547     }
1548 
1549     function _writeCheckpoint(
1550         address delegatee,
1551         uint32 nCheckpoints,
1552         uint256 oldVotes,
1553         uint256 newVotes
1554     ) internal {
1555         uint32 blockNumber = safe32(
1556             block.number,
1557             "LOCK::_writeCheckpoint: block number exceeds 32 bits"
1558         );
1559 
1560         if (
1561             nCheckpoints > 0 &&
1562             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1563         ) {
1564             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1565         } else {
1566             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1567                 blockNumber,
1568                 newVotes
1569             );
1570             numCheckpoints[delegatee] = nCheckpoints + 1;
1571         }
1572 
1573         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1574     }
1575 
1576     function safe32(uint256 n, string memory errorMessage)
1577         internal
1578         pure
1579         returns (uint32)
1580     {
1581         require(n < 2**32, errorMessage);
1582         return uint32(n);
1583     }
1584 
1585     function getChainId() internal pure returns (uint256) {
1586         uint256 chainId;
1587         assembly {
1588             chainId := chainid()
1589         }
1590         return chainId;
1591     }
1592 }
1593 
1594 // File: contracts/KeyMaster.sol
1595 
1596 pragma solidity 0.6.12;
1597 
1598 interface IMigratorMaster {
1599     // Perform LP token migration from legacy UniswapV2 to KeyKeySwap.
1600     // Take the current LP token address and return the new LP token address.
1601     // Migrator should have full access to the caller's LP token.
1602     // Return the new LP token address.
1603     //
1604     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
1605     // KeyKeySwap must mint EXACTLY the same amount of KeyKeySwap LP tokens or
1606     // else something bad will happen. Traditional UniswapV2 does not
1607     // do that so be careful!
1608     function migrate(IERC20 token) external returns (IERC20);
1609 }
1610 
1611 // KeyMaster is the master of Key. He can make LOCK and he is a fair guy.
1612 //
1613 // Note that it's ownable and the owner wields tremendous power. The ownership
1614 // will be transferred to a governance smart contract once LOCK is sufficiently
1615 // distributed and the community can show to govern itself.
1616 //
1617 // Have fun reading it. Hopefully it's bug-free. God bless.
1618 contract KeyMaster is Ownable {
1619     using SafeMath for uint256;
1620     using SafeERC20 for IERC20;
1621 
1622     // Info of each user.
1623     struct UserInfo {
1624         uint256 amount; // How many LP tokens the user has provided.
1625         uint256 rewardDebt; // Reward debt. See explanation below.
1626         //
1627         // We do some fancy math here. Basically, any point in time, the amount of LOCKs
1628         // entitled to a user but is pending to be distributed is:
1629         //
1630         //   pending reward = (user.amount * pool.accLockPerShare) - user.rewardDebt
1631         //
1632         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1633         //   1. The pool's `accLockPerShare` (and `lastRewardBlock`) gets updated.
1634         //   2. User receives the pending reward sent to his/her address.
1635         //   3. User's `amount` gets updated.
1636         //   4. User's `rewardDebt` gets updated.
1637     }
1638 
1639     // Info of each pool.
1640     struct PoolInfo {
1641         IERC20 lpToken; // Address of LP token contract.
1642         uint256 allocPoint; // How many allocation points assigned to this pool. LOCKs to distribute per block.
1643         uint256 lastRewardBlock; // Last block number that LOCKs distribution occurs.
1644         uint256 accLockPerShare; // Accumulated LOCKs per share, times 1e12. See below.
1645     }
1646 
1647     // The LOCK TOKEN!
1648     LockToken public lock;
1649     // Dev address.
1650     address public devaddr;
1651     // Block number when bonus LOCK period ends.
1652     uint256 public bonusEndBlock;
1653     // LOCK tokens created per block.
1654     uint256 public lockPerBlock;
1655     // Bonus multiplier for early lock makers, times 1e12
1656     uint256 public constant BONUS_MULTIPLIER = 12000000000000;
1657     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1658     IMigratorMaster public migrator;
1659 
1660     // Info of each pool.
1661     PoolInfo[] public poolInfo;
1662     // Info of each user that stakes LP tokens.
1663     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1664     // Total allocation points. Must be the sum of all allocation points in all pools.
1665     uint256 public totalAllocPoint = 0;
1666     // The block number when LOCK mining starts.
1667     uint256 public startBlock;
1668     // Number of blocks interval to halve the reward
1669     uint256 public halvingInterval;
1670 
1671     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1672     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1673     event EmergencyWithdraw(
1674         address indexed user,
1675         uint256 indexed pid,
1676         uint256 amount
1677     );
1678 
1679     constructor(
1680         LockToken _lock,
1681         address _devaddr,
1682         uint256 _lockPerBlock,
1683         uint256 _startBlock,
1684         uint256 _bonusEndBlock,
1685         uint256 _halvingInterval
1686     ) public {
1687         lock = _lock;
1688         devaddr = _devaddr;
1689         lockPerBlock = _lockPerBlock;
1690         bonusEndBlock = _bonusEndBlock;
1691         startBlock = _startBlock;
1692         halvingInterval = _halvingInterval;
1693     }
1694 
1695     function poolLength() external view returns (uint256) {
1696         return poolInfo.length;
1697     }
1698 
1699     // Add a new lp to the pool. Can only be called by the owner.
1700     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1701     function add(
1702         uint256 _allocPoint,
1703         IERC20 _lpToken,
1704         bool _withUpdate
1705     ) public onlyOwner {
1706         if (_withUpdate) {
1707             massUpdatePools();
1708         }
1709         uint256 lastRewardBlock = block.number > startBlock
1710             ? block.number
1711             : startBlock;
1712         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1713         poolInfo.push(
1714             PoolInfo({
1715                 lpToken: _lpToken,
1716                 allocPoint: _allocPoint,
1717                 lastRewardBlock: lastRewardBlock,
1718                 accLockPerShare: 0
1719             })
1720         );
1721     }
1722 
1723     // Update the given pool's LOCK allocation point. Can only be called by the owner.
1724     function set(
1725         uint256 _pid,
1726         uint256 _allocPoint,
1727         bool _withUpdate
1728     ) public onlyOwner {
1729         if (_withUpdate) {
1730             massUpdatePools();
1731         }
1732         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1733             _allocPoint
1734         );
1735         poolInfo[_pid].allocPoint = _allocPoint;
1736     }
1737 
1738     // Set the migrator contract. Can only be called by the owner.
1739     function setMigrator(IMigratorMaster _migrator) public onlyOwner {
1740         migrator = _migrator;
1741     }
1742 
1743     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1744     function migrate(uint256 _pid) public {
1745         require(address(migrator) != address(0), "migrate: no migrator");
1746         PoolInfo storage pool = poolInfo[_pid];
1747         IERC20 lpToken = pool.lpToken;
1748         uint256 bal = lpToken.balanceOf(address(this));
1749         lpToken.safeApprove(address(migrator), bal);
1750         IERC20 newLpToken = migrator.migrate(lpToken);
1751         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1752         pool.lpToken = newLpToken;
1753     }
1754 
1755     // Return reward halving multiplier over the given _from to _to block, assuming _from >= bonusEndBlock
1756     function _getHalvingMultiplier(uint256 _from, uint256 _to)
1757         private
1758         view
1759         returns (uint256)
1760     {
1761         uint256 fromTier = _from.sub(bonusEndBlock).div(halvingInterval);
1762         uint256 toTier = _to.sub(bonusEndBlock).div(halvingInterval);
1763         uint256 halving = 1e12;
1764         uint256 startCursorBlock = _from;
1765         uint256 endCursorBlock = _from;
1766         uint256 multiplier = 0;
1767 
1768         for (uint256 i = 0; i < fromTier; i++) {
1769             halving = halving.div(2);
1770         }
1771 
1772         for (uint256 i = fromTier; i <= toTier; i++) {
1773             if (i == toTier) {
1774                 multiplier = multiplier.add(
1775                     _to.sub(endCursorBlock).mul(halving)
1776                 );
1777             } else {
1778                 endCursorBlock = bonusEndBlock.add(halvingInterval.mul(i + 1));
1779                 multiplier = multiplier.add(
1780                     endCursorBlock.sub(startCursorBlock).mul(halving)
1781                 );
1782                 startCursorBlock = endCursorBlock;
1783                 halving = halving.div(2);
1784             }
1785         }
1786 
1787         return multiplier;
1788     }
1789 
1790     // Return reward multiplier over the given _from to _to block, assuming _to > _from
1791     function getMultiplier(uint256 _from, uint256 _to)
1792         public
1793         view
1794         returns (uint256)
1795     {
1796         if (_to <= bonusEndBlock) {
1797             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1798         } else if (_from >= bonusEndBlock) {
1799             return _getHalvingMultiplier(_from, _to);
1800         } else {
1801             return
1802                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1803                     _getHalvingMultiplier(bonusEndBlock, _to)
1804                 );
1805         }
1806     }
1807 
1808     // View function to see pending LOCKs on frontend.
1809     function pendingLock(uint256 _pid, address _user)
1810         external
1811         view
1812         returns (uint256)
1813     {
1814         PoolInfo storage pool = poolInfo[_pid];
1815         UserInfo storage user = userInfo[_pid][_user];
1816         uint256 accLockPerShare = pool.accLockPerShare;
1817         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1818         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1819             uint256 multiplier = getMultiplier(
1820                 pool.lastRewardBlock,
1821                 block.number
1822             );
1823             uint256 lockReward = multiplier
1824                 .mul(lockPerBlock)
1825                 .mul(pool.allocPoint)
1826                 .div(totalAllocPoint)
1827                 .div(1e12);
1828             accLockPerShare = accLockPerShare.add(
1829                 lockReward.mul(1e12).div(lpSupply)
1830             );
1831         }
1832         return user.amount.mul(accLockPerShare).div(1e12).sub(user.rewardDebt);
1833     }
1834 
1835     // Update reward vairables for all pools. Be careful of gas spending!
1836     function massUpdatePools() public {
1837         uint256 length = poolInfo.length;
1838         for (uint256 pid = 0; pid < length; ++pid) {
1839             updatePool(pid);
1840         }
1841     }
1842 
1843     // Update reward variables of the given pool to be up-to-date.
1844     function updatePool(uint256 _pid) public {
1845         PoolInfo storage pool = poolInfo[_pid];
1846         if (block.number <= pool.lastRewardBlock) {
1847             return;
1848         }
1849         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1850         if (lpSupply == 0) {
1851             pool.lastRewardBlock = block.number;
1852             return;
1853         }
1854         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1855         uint256 lockReward = multiplier
1856             .mul(lockPerBlock)
1857             .mul(pool.allocPoint)
1858             .div(totalAllocPoint)
1859             .div(1e12);
1860         lock.mint(devaddr, lockReward.mul(8).div(100));
1861         lock.mint(address(this), lockReward);
1862         pool.accLockPerShare = pool.accLockPerShare.add(
1863             lockReward.mul(1e12).div(lpSupply)
1864         );
1865         pool.lastRewardBlock = block.number;
1866     }
1867 
1868     // Deposit LP tokens to KeyMaster for LOCK allocation.
1869     function deposit(uint256 _pid, uint256 _amount) public {
1870         PoolInfo storage pool = poolInfo[_pid];
1871         UserInfo storage user = userInfo[_pid][msg.sender];
1872         updatePool(_pid);
1873         if (user.amount > 0) {
1874             uint256 pending = user
1875                 .amount
1876                 .mul(pool.accLockPerShare)
1877                 .div(1e12)
1878                 .sub(user.rewardDebt);
1879             safeLockTransfer(msg.sender, pending);
1880         }
1881         pool.lpToken.safeTransferFrom(
1882             address(msg.sender),
1883             address(this),
1884             _amount
1885         );
1886         user.amount = user.amount.add(_amount);
1887         user.rewardDebt = user.amount.mul(pool.accLockPerShare).div(1e12);
1888         emit Deposit(msg.sender, _pid, _amount);
1889     }
1890 
1891     // Withdraw LP tokens from KeyMaster.
1892     function withdraw(uint256 _pid, uint256 _amount) public {
1893         PoolInfo storage pool = poolInfo[_pid];
1894         UserInfo storage user = userInfo[_pid][msg.sender];
1895         require(user.amount >= _amount, "withdraw: not good");
1896         updatePool(_pid);
1897         uint256 pending = user.amount.mul(pool.accLockPerShare).div(1e12).sub(
1898             user.rewardDebt
1899         );
1900         safeLockTransfer(msg.sender, pending);
1901         user.amount = user.amount.sub(_amount);
1902         user.rewardDebt = user.amount.mul(pool.accLockPerShare).div(1e12);
1903         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1904         emit Withdraw(msg.sender, _pid, _amount);
1905     }
1906 
1907     // Withdraw without caring about rewards. EMERGENCY ONLY.
1908     function emergencyWithdraw(uint256 _pid) public {
1909         PoolInfo storage pool = poolInfo[_pid];
1910         UserInfo storage user = userInfo[_pid][msg.sender];
1911         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1912         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1913         user.amount = 0;
1914         user.rewardDebt = 0;
1915     }
1916 
1917     // Safe lock transfer function, just in case if rounding error causes pool to not have enough LOCKs.
1918     function safeLockTransfer(address _to, uint256 _amount) internal {
1919         uint256 lockBal = lock.balanceOf(address(this));
1920         if (_amount > lockBal) {
1921             lock.transfer(_to, lockBal);
1922         } else {
1923             lock.transfer(_to, _amount);
1924         }
1925     }
1926 
1927     // Update dev address by the previous dev.
1928     function dev(address _devaddr) public {
1929         require(msg.sender == devaddr, "dev: wut?");
1930         devaddr = _devaddr;
1931     }
1932 }