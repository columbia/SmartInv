1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-31
3  */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-26
7  */
8 
9 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
10 
11 pragma solidity ^0.6.0;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount)
35         external
36         returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender)
46         external
47         view
48         returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(
94         address indexed owner,
95         address indexed spender,
96         uint256 value
97     );
98 }
99 
100 // File: @openzeppelin/contracts/math/SafeMath.sol
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(
160         uint256 a,
161         uint256 b,
162         string memory errorMessage
163     ) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(
263         uint256 a,
264         uint256 b,
265         string memory errorMessage
266     ) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: @openzeppelin/contracts/utils/Address.sol
273 
274 pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300         // for accounts without code, i.e. `keccak256('')`
301         bytes32 codehash;
302 
303 
304             bytes32 accountHash
305          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly {
308             codehash := extcodehash(account)
309         }
310         return (codehash != accountHash && codehash != 0x0);
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(
331             address(this).balance >= amount,
332             "Address: insufficient balance"
333         );
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{value: amount}("");
337         require(
338             success,
339             "Address: unable to send value, recipient may have reverted"
340         );
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain`call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data)
362         internal
363         returns (bytes memory)
364     {
365         return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         return _functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value
397     ) internal returns (bytes memory) {
398         return
399             functionCallWithValue(
400                 target,
401                 data,
402                 value,
403                 "Address: low-level call with value failed"
404             );
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(
420             address(this).balance >= value,
421             "Address: insufficient balance for call"
422         );
423         return _functionCallWithValue(target, data, value, errorMessage);
424     }
425 
426     function _functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 weiValue,
430         string memory errorMessage
431     ) private returns (bytes memory) {
432         require(isContract(target), "Address: call to non-contract");
433 
434         // solhint-disable-next-line avoid-low-level-calls
435         (bool success, bytes memory returndata) = target.call{value: weiValue}(
436             data
437         );
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 // solhint-disable-next-line no-inline-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
458 
459 pragma solidity ^0.6.0;
460 
461 /**
462  * @title SafeERC20
463  * @dev Wrappers around ERC20 operations that throw on failure (when the token
464  * contract returns false). Tokens that return no value (and instead revert or
465  * throw on failure) are also supported, non-reverting calls are assumed to be
466  * successful.
467  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
468  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
469  */
470 library SafeERC20 {
471     using SafeMath for uint256;
472     using Address for address;
473 
474     function safeTransfer(
475         IERC20 token,
476         address to,
477         uint256 value
478     ) internal {
479         _callOptionalReturn(
480             token,
481             abi.encodeWithSelector(token.transfer.selector, to, value)
482         );
483     }
484 
485     function safeTransferFrom(
486         IERC20 token,
487         address from,
488         address to,
489         uint256 value
490     ) internal {
491         _callOptionalReturn(
492             token,
493             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
494         );
495     }
496 
497     /**
498      * @dev Deprecated. This function has issues similar to the ones found in
499      * {IERC20-approve}, and its usage is discouraged.
500      *
501      * Whenever possible, use {safeIncreaseAllowance} and
502      * {safeDecreaseAllowance} instead.
503      */
504     function safeApprove(
505         IERC20 token,
506         address spender,
507         uint256 value
508     ) internal {
509         // safeApprove should only be called when setting an initial allowance,
510         // or when resetting it to zero. To increase and decrease it, use
511         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
512         // solhint-disable-next-line max-line-length
513         require(
514             (value == 0) || (token.allowance(address(this), spender) == 0),
515             "SafeERC20: approve from non-zero to non-zero allowance"
516         );
517         _callOptionalReturn(
518             token,
519             abi.encodeWithSelector(token.approve.selector, spender, value)
520         );
521     }
522 
523     function safeIncreaseAllowance(
524         IERC20 token,
525         address spender,
526         uint256 value
527     ) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(
529             value
530         );
531         _callOptionalReturn(
532             token,
533             abi.encodeWithSelector(
534                 token.approve.selector,
535                 spender,
536                 newAllowance
537             )
538         );
539     }
540 
541     function safeDecreaseAllowance(
542         IERC20 token,
543         address spender,
544         uint256 value
545     ) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(
547             value,
548             "SafeERC20: decreased allowance below zero"
549         );
550         _callOptionalReturn(
551             token,
552             abi.encodeWithSelector(
553                 token.approve.selector,
554                 spender,
555                 newAllowance
556             )
557         );
558     }
559 
560     /**
561      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
562      * on the return value: the return value is optional (but if data is returned, it must not be false).
563      * @param token The token targeted by the call.
564      * @param data The call data (encoded using abi.encode or one of its variants).
565      */
566     function _callOptionalReturn(IERC20 token, bytes memory data) private {
567         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
568         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
569         // the target address contains contract code and also asserts for success in the low-level call.
570 
571         bytes memory returndata = address(token).functionCall(
572             data,
573             "SafeERC20: low-level call failed"
574         );
575         if (returndata.length > 0) {
576             // Return data is optional
577             // solhint-disable-next-line max-line-length
578             require(
579                 abi.decode(returndata, (bool)),
580                 "SafeERC20: ERC20 operation did not succeed"
581             );
582         }
583     }
584 }
585 
586 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
587 
588 pragma solidity ^0.6.0;
589 
590 /**
591  * @dev Library for managing
592  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
593  * types.
594  *
595  * Sets have the following properties:
596  *
597  * - Elements are added, removed, and checked for existence in constant time
598  * (O(1)).
599  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
600  *
601  * ```
602  * contract Example {
603  *     // Add the library methods
604  *     using EnumerableSet for EnumerableSet.AddressSet;
605  *
606  *     // Declare a set state variable
607  *     EnumerableSet.AddressSet private mySet;
608  * }
609  * ```
610  *
611  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
612  * (`UintSet`) are supported.
613  */
614 library EnumerableSet {
615     // To implement this library for multiple types with as little code
616     // repetition as possible, we write it in terms of a generic Set type with
617     // bytes32 values.
618     // The Set implementation uses private functions, and user-facing
619     // implementations (such as AddressSet) are just wrappers around the
620     // underlying Set.
621     // This means that we can only create new EnumerableSets for types that fit
622     // in bytes32.
623 
624     struct Set {
625         // Storage of set values
626         bytes32[] _values;
627         // Position of the value in the `values` array, plus 1 because index 0
628         // means a value is not in the set.
629         mapping(bytes32 => uint256) _indexes;
630     }
631 
632     /**
633      * @dev Add a value to a set. O(1).
634      *
635      * Returns true if the value was added to the set, that is if it was not
636      * already present.
637      */
638     function _add(Set storage set, bytes32 value) private returns (bool) {
639         if (!_contains(set, value)) {
640             set._values.push(value);
641             // The value is stored at length-1, but we add 1 to all indexes
642             // and use 0 as a sentinel value
643             set._indexes[value] = set._values.length;
644             return true;
645         } else {
646             return false;
647         }
648     }
649 
650     /**
651      * @dev Removes a value from a set. O(1).
652      *
653      * Returns true if the value was removed from the set, that is if it was
654      * present.
655      */
656     function _remove(Set storage set, bytes32 value) private returns (bool) {
657         // We read and store the value's index to prevent multiple reads from the same storage slot
658         uint256 valueIndex = set._indexes[value];
659 
660         if (valueIndex != 0) {
661             // Equivalent to contains(set, value)
662             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
663             // the array, and then remove the last element (sometimes called as 'swap and pop').
664             // This modifies the order of the array, as noted in {at}.
665 
666             uint256 toDeleteIndex = valueIndex - 1;
667             uint256 lastIndex = set._values.length - 1;
668 
669             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
670             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
671 
672             bytes32 lastvalue = set._values[lastIndex];
673 
674             // Move the last value to the index where the value to delete is
675             set._values[toDeleteIndex] = lastvalue;
676             // Update the index for the moved value
677             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
678 
679             // Delete the slot where the moved value was stored
680             set._values.pop();
681 
682             // Delete the index for the deleted slot
683             delete set._indexes[value];
684 
685             return true;
686         } else {
687             return false;
688         }
689     }
690 
691     /**
692      * @dev Returns true if the value is in the set. O(1).
693      */
694     function _contains(Set storage set, bytes32 value)
695         private
696         view
697         returns (bool)
698     {
699         return set._indexes[value] != 0;
700     }
701 
702     /**
703      * @dev Returns the number of values on the set. O(1).
704      */
705     function _length(Set storage set) private view returns (uint256) {
706         return set._values.length;
707     }
708 
709     /**
710      * @dev Returns the value stored at position `index` in the set. O(1).
711      *
712      * Note that there are no guarantees on the ordering of values inside the
713      * array, and it may change when more values are added or removed.
714      *
715      * Requirements:
716      *
717      * - `index` must be strictly less than {length}.
718      */
719     function _at(Set storage set, uint256 index)
720         private
721         view
722         returns (bytes32)
723     {
724         require(
725             set._values.length > index,
726             "EnumerableSet: index out of bounds"
727         );
728         return set._values[index];
729     }
730 
731     // AddressSet
732 
733     struct AddressSet {
734         Set _inner;
735     }
736 
737     /**
738      * @dev Add a value to a set. O(1).
739      *
740      * Returns true if the value was added to the set, that is if it was not
741      * already present.
742      */
743     function add(AddressSet storage set, address value)
744         internal
745         returns (bool)
746     {
747         return _add(set._inner, bytes32(uint256(value)));
748     }
749 
750     /**
751      * @dev Removes a value from a set. O(1).
752      *
753      * Returns true if the value was removed from the set, that is if it was
754      * present.
755      */
756     function remove(AddressSet storage set, address value)
757         internal
758         returns (bool)
759     {
760         return _remove(set._inner, bytes32(uint256(value)));
761     }
762 
763     /**
764      * @dev Returns true if the value is in the set. O(1).
765      */
766     function contains(AddressSet storage set, address value)
767         internal
768         view
769         returns (bool)
770     {
771         return _contains(set._inner, bytes32(uint256(value)));
772     }
773 
774     /**
775      * @dev Returns the number of values in the set. O(1).
776      */
777     function length(AddressSet storage set) internal view returns (uint256) {
778         return _length(set._inner);
779     }
780 
781     /**
782      * @dev Returns the value stored at position `index` in the set. O(1).
783      *
784      * Note that there are no guarantees on the ordering of values inside the
785      * array, and it may change when more values are added or removed.
786      *
787      * Requirements:
788      *
789      * - `index` must be strictly less than {length}.
790      */
791     function at(AddressSet storage set, uint256 index)
792         internal
793         view
794         returns (address)
795     {
796         return address(uint256(_at(set._inner, index)));
797     }
798 
799     // UintSet
800 
801     struct UintSet {
802         Set _inner;
803     }
804 
805     /**
806      * @dev Add a value to a set. O(1).
807      *
808      * Returns true if the value was added to the set, that is if it was not
809      * already present.
810      */
811     function add(UintSet storage set, uint256 value) internal returns (bool) {
812         return _add(set._inner, bytes32(value));
813     }
814 
815     /**
816      * @dev Removes a value from a set. O(1).
817      *
818      * Returns true if the value was removed from the set, that is if it was
819      * present.
820      */
821     function remove(UintSet storage set, uint256 value)
822         internal
823         returns (bool)
824     {
825         return _remove(set._inner, bytes32(value));
826     }
827 
828     /**
829      * @dev Returns true if the value is in the set. O(1).
830      */
831     function contains(UintSet storage set, uint256 value)
832         internal
833         view
834         returns (bool)
835     {
836         return _contains(set._inner, bytes32(value));
837     }
838 
839     /**
840      * @dev Returns the number of values on the set. O(1).
841      */
842     function length(UintSet storage set) internal view returns (uint256) {
843         return _length(set._inner);
844     }
845 
846     /**
847      * @dev Returns the value stored at position `index` in the set. O(1).
848      *
849      * Note that there are no guarantees on the ordering of values inside the
850      * array, and it may change when more values are added or removed.
851      *
852      * Requirements:
853      *
854      * - `index` must be strictly less than {length}.
855      */
856     function at(UintSet storage set, uint256 index)
857         internal
858         view
859         returns (uint256)
860     {
861         return uint256(_at(set._inner, index));
862     }
863 }
864 
865 // File: @openzeppelin/contracts/GSN/Context.sol
866 
867 pragma solidity ^0.6.0;
868 
869 /*
870  * @dev Provides information about the current execution context, including the
871  * sender of the transaction and its data. While these are generally available
872  * via msg.sender and msg.data, they should not be accessed in such a direct
873  * manner, since when dealing with GSN meta-transactions the account sending and
874  * paying for execution may not be the actual sender (as far as an application
875  * is concerned).
876  *
877  * This contract is only required for intermediate, library-like contracts.
878  */
879 abstract contract Context {
880     function _msgSender() internal virtual view returns (address payable) {
881         return msg.sender;
882     }
883 
884     function _msgData() internal virtual view returns (bytes memory) {
885         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
886         return msg.data;
887     }
888 }
889 
890 // File: @openzeppelin/contracts/access/Ownable.sol
891 
892 pragma solidity ^0.6.0;
893 
894 /**
895  * @dev Contract module which provides a basic access control mechanism, where
896  * there is an account (an owner) that can be granted exclusive access to
897  * specific functions.
898  *
899  * By default, the owner account will be the one that deploys the contract. This
900  * can later be changed with {transferOwnership}.
901  *
902  * This module is used through inheritance. It will make available the modifier
903  * `onlyOwner`, which can be applied to your functions to restrict their use to
904  * the owner.
905  */
906 contract Ownable is Context {
907     address private _owner;
908 
909     event OwnershipTransferred(
910         address indexed previousOwner,
911         address indexed newOwner
912     );
913 
914     /**
915      * @dev Initializes the contract setting the deployer as the initial owner.
916      */
917     constructor() internal {
918         address msgSender = _msgSender();
919         _owner = msgSender;
920         emit OwnershipTransferred(address(0), msgSender);
921     }
922 
923     /**
924      * @dev Returns the address of the current owner.
925      */
926     function owner() public view returns (address) {
927         return _owner;
928     }
929 
930     /**
931      * @dev Throws if called by any account other than the owner.
932      */
933     modifier onlyOwner() {
934         require(_owner == _msgSender(), "Ownable: caller is not the owner");
935         _;
936     }
937 
938     /**
939      * @dev Leaves the contract without owner. It will not be possible to call
940      * `onlyOwner` functions anymore. Can only be called by the current owner.
941      *
942      * NOTE: Renouncing ownership will leave the contract without an owner,
943      * thereby removing any functionality that is only available to the owner.
944      */
945     function renounceOwnership() public virtual onlyOwner {
946         emit OwnershipTransferred(_owner, address(0));
947         _owner = address(0);
948     }
949 
950     /**
951      * @dev Transfers ownership of the contract to a new account (`newOwner`).
952      * Can only be called by the current owner.
953      */
954     function transferOwnership(address newOwner) public virtual onlyOwner {
955         require(
956             newOwner != address(0),
957             "Ownable: new owner is the zero address"
958         );
959         emit OwnershipTransferred(_owner, newOwner);
960         _owner = newOwner;
961     }
962 }
963 
964 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
965 
966 pragma solidity ^0.6.0;
967 
968 /**
969  * @dev Implementation of the {IERC20} interface.
970  *
971  * This implementation is agnostic to the way tokens are created. This means
972  * that a supply mechanism has to be added in a derived contract using {_mint}.
973  * For a generic mechanism see {ERC20PresetMinterPauser}.
974  *
975  * TIP: For a detailed writeup see our guide
976  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
977  * to implement supply mechanisms].
978  *
979  * We have followed general OpenZeppelin guidelines: functions revert instead
980  * of returning `false` on failure. This behavior is nonetheless conventional
981  * and does not conflict with the expectations of ERC20 applications.
982  *
983  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
984  * This allows applications to reconstruct the allowance for all accounts just
985  * by listening to said events. Other implementations of the EIP may not emit
986  * these events, as it isn't required by the specification.
987  *
988  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
989  * functions have been added to mitigate the well-known issues around setting
990  * allowances. See {IERC20-approve}.
991  */
992 contract ERC20 is Context, IERC20 {
993     using SafeMath for uint256;
994     using Address for address;
995 
996     mapping(address => uint256) internal _balances;
997 
998     mapping(address => mapping(address => uint256)) private _allowances;
999 
1000     uint256 private _totalSupply;
1001 
1002     string private _name;
1003     string private _symbol;
1004     uint8 private _decimals;
1005 
1006     /**
1007      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1008      * a default value of 18.
1009      *
1010      * To select a different value for {decimals}, use {_setupDecimals}.
1011      *
1012      * All three of these values are immutable: they can only be set once during
1013      * construction.
1014      */
1015     constructor(string memory name, string memory symbol) public {
1016         _name = name;
1017         _symbol = symbol;
1018         _decimals = 18;
1019     }
1020 
1021     /**
1022      * @dev Returns the name of the token.
1023      */
1024     function name() public view returns (string memory) {
1025         return _name;
1026     }
1027 
1028     /**
1029      * @dev Returns the symbol of the token, usually a shorter version of the
1030      * name.
1031      */
1032     function symbol() public view returns (string memory) {
1033         return _symbol;
1034     }
1035 
1036     /**
1037      * @dev Returns the number of decimals used to get its user representation.
1038      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1039      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1040      *
1041      * Tokens usually opt for a value of 18, imitating the relationship between
1042      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1043      * called.
1044      *
1045      * NOTE: This information is only used for _display_ purposes: it in
1046      * no way affects any of the arithmetic of the contract, including
1047      * {IERC20-balanceOf} and {IERC20-transfer}.
1048      */
1049     function decimals() public view returns (uint8) {
1050         return _decimals;
1051     }
1052 
1053     /**
1054      * @dev See {IERC20-totalSupply}.
1055      */
1056     function totalSupply() public override view returns (uint256) {
1057         return _totalSupply;
1058     }
1059 
1060     /**
1061      * @dev See {IERC20-balanceOf}.
1062      */
1063     function balanceOf(address account) public override view returns (uint256) {
1064         return _balances[account];
1065     }
1066 
1067     /**
1068      * @dev See {IERC20-transfer}.
1069      *
1070      * Requirements:
1071      *
1072      * - `recipient` cannot be the zero address.
1073      * - the caller must have a balance of at least `amount`.
1074      */
1075     function transfer(address recipient, uint256 amount)
1076         public
1077         virtual
1078         override
1079         returns (bool)
1080     {
1081         _transfer(_msgSender(), recipient, amount);
1082         return true;
1083     }
1084 
1085     /**
1086      * @dev See {IERC20-allowance}.
1087      */
1088     function allowance(address owner, address spender)
1089         public
1090         virtual
1091         override
1092         view
1093         returns (uint256)
1094     {
1095         return _allowances[owner][spender];
1096     }
1097 
1098     /**
1099      * @dev See {IERC20-approve}.
1100      *
1101      * Requirements:
1102      *
1103      * - `spender` cannot be the zero address.
1104      */
1105     function approve(address spender, uint256 amount)
1106         public
1107         virtual
1108         override
1109         returns (bool)
1110     {
1111         _approve(_msgSender(), spender, amount);
1112         return true;
1113     }
1114 
1115     /**
1116      * @dev See {IERC20-transferFrom}.
1117      *
1118      * Emits an {Approval} event indicating the updated allowance. This is not
1119      * required by the EIP. See the note at the beginning of {ERC20};
1120      *
1121      * Requirements:
1122      * - `sender` and `recipient` cannot be the zero address.
1123      * - `sender` must have a balance of at least `amount`.
1124      * - the caller must have allowance for ``sender``'s tokens of at least
1125      * `amount`.
1126      */
1127     function transferFrom(
1128         address sender,
1129         address recipient,
1130         uint256 amount
1131     ) public virtual override returns (bool) {
1132         _transfer(sender, recipient, amount);
1133         _approve(
1134             sender,
1135             _msgSender(),
1136             _allowances[sender][_msgSender()].sub(
1137                 amount,
1138                 "ERC20: transfer amount exceeds allowance"
1139             )
1140         );
1141         return true;
1142     }
1143 
1144     /**
1145      * @dev Atomically increases the allowance granted to `spender` by the caller.
1146      *
1147      * This is an alternative to {approve} that can be used as a mitigation for
1148      * problems described in {IERC20-approve}.
1149      *
1150      * Emits an {Approval} event indicating the updated allowance.
1151      *
1152      * Requirements:
1153      *
1154      * - `spender` cannot be the zero address.
1155      */
1156     function increaseAllowance(address spender, uint256 addedValue)
1157         public
1158         virtual
1159         returns (bool)
1160     {
1161         _approve(
1162             _msgSender(),
1163             spender,
1164             _allowances[_msgSender()][spender].add(addedValue)
1165         );
1166         return true;
1167     }
1168 
1169     /**
1170      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1171      *
1172      * This is an alternative to {approve} that can be used as a mitigation for
1173      * problems described in {IERC20-approve}.
1174      *
1175      * Emits an {Approval} event indicating the updated allowance.
1176      *
1177      * Requirements:
1178      *
1179      * - `spender` cannot be the zero address.
1180      * - `spender` must have allowance for the caller of at least
1181      * `subtractedValue`.
1182      */
1183     function decreaseAllowance(address spender, uint256 subtractedValue)
1184         public
1185         virtual
1186         returns (bool)
1187     {
1188         _approve(
1189             _msgSender(),
1190             spender,
1191             _allowances[_msgSender()][spender].sub(
1192                 subtractedValue,
1193                 "ERC20: decreased allowance below zero"
1194             )
1195         );
1196         return true;
1197     }
1198 
1199     /**
1200      * @dev Moves tokens `amount` from `sender` to `recipient`.
1201      *
1202      * This is internal function is equivalent to {transfer}, and can be used to
1203      * e.g. implement automatic token fees, slashing mechanisms, etc.
1204      *
1205      * Emits a {Transfer} event.
1206      *
1207      * Requirements:
1208      *
1209      * - `sender` cannot be the zero address.
1210      * - `recipient` cannot be the zero address.
1211      * - `sender` must have a balance of at least `amount`.
1212      */
1213     function _transfer(
1214         address sender,
1215         address recipient,
1216         uint256 amount
1217     ) internal virtual {
1218         require(sender != address(0), "ERC20: transfer from the zero address");
1219         require(recipient != address(0), "ERC20: transfer to the zero address");
1220 
1221         _beforeTokenTransfer(sender, recipient, amount);
1222 
1223         _balances[sender] = _balances[sender].sub(
1224             amount,
1225             "ERC20: transfer amount exceeds balance"
1226         );
1227         _balances[recipient] = _balances[recipient].add(amount);
1228         emit Transfer(sender, recipient, amount);
1229     }
1230 
1231     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1232      * the total supply.
1233      *
1234      * Emits a {Transfer} event with `from` set to the zero address.
1235      *
1236      * Requirements
1237      *
1238      * - `to` cannot be the zero address.
1239      */
1240     function _mint(address account, uint256 amount) internal virtual {
1241         require(account != address(0), "ERC20: mint to the zero address");
1242 
1243         _beforeTokenTransfer(address(0), account, amount);
1244 
1245         _totalSupply = _totalSupply.add(amount);
1246         _balances[account] = _balances[account].add(amount);
1247         emit Transfer(address(0), account, amount);
1248     }
1249 
1250     /**
1251      * @dev Destroys `amount` tokens from `account`, reducing the
1252      * total supply.
1253      *
1254      * Emits a {Transfer} event with `to` set to the zero address.
1255      *
1256      * Requirements
1257      *
1258      * - `account` cannot be the zero address.
1259      * - `account` must have at least `amount` tokens.
1260      */
1261     function _burn(address account, uint256 amount) internal virtual {
1262         require(account != address(0), "ERC20: burn from the zero address");
1263 
1264         _beforeTokenTransfer(account, address(0), amount);
1265 
1266         _balances[account] = _balances[account].sub(
1267             amount,
1268             "ERC20: burn amount exceeds balance"
1269         );
1270         _totalSupply = _totalSupply.sub(amount);
1271         emit Transfer(account, address(0), amount);
1272     }
1273 
1274     /**
1275      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1276      *
1277      * This is internal function is equivalent to `approve`, and can be used to
1278      * e.g. set automatic allowances for certain subsystems, etc.
1279      *
1280      * Emits an {Approval} event.
1281      *
1282      * Requirements:
1283      *
1284      * - `owner` cannot be the zero address.
1285      * - `spender` cannot be the zero address.
1286      */
1287     function _approve(
1288         address owner,
1289         address spender,
1290         uint256 amount
1291     ) internal virtual {
1292         require(owner != address(0), "ERC20: approve from the zero address");
1293         require(spender != address(0), "ERC20: approve to the zero address");
1294 
1295         _allowances[owner][spender] = amount;
1296         emit Approval(owner, spender, amount);
1297     }
1298 
1299     /**
1300      * @dev Sets {decimals} to a value other than the default one of 18.
1301      *
1302      * WARNING: This function should only be called from the constructor. Most
1303      * applications that interact with token contracts will not expect
1304      * {decimals} to ever change, and may work incorrectly if it does.
1305      */
1306     function _setupDecimals(uint8 decimals_) internal {
1307         _decimals = decimals_;
1308     }
1309 
1310     /**
1311      * @dev Hook that is called before any transfer of tokens. This includes
1312      * minting and burning.
1313      *
1314      * Calling conditions:
1315      *
1316      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1317      * will be to transferred to `to`.
1318      * - when `from` is zero, `amount` tokens will be minted for `to`.
1319      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1320      * - `from` and `to` are never both zero.
1321      *
1322      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1323      */
1324     function _beforeTokenTransfer(
1325         address from,
1326         address to,
1327         uint256 amount
1328     ) internal virtual {}
1329 }
1330 
1331 // File: contracts/iGOVToken.sol
1332 
1333 pragma solidity ^0.6.6;
1334 
1335 contract iGOVToken is ERC20("Unifund Gov", "iGOV"), Ownable {
1336     using SafeMath for uint256;
1337     address feeCollector = msg.sender;
1338 
1339     uint16 constant fee = 500; // 5.00 %
1340 
1341     function setFeeCollector(address _feeCollector) public onlyOwner {
1342         feeCollector = _feeCollector;
1343     }
1344     
1345     function getFeeCollector() public view returns (address) {
1346         return feeCollector;
1347     }
1348 
1349     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1350     function mint(address _to, uint256 _amount) public onlyOwner {
1351         _mint(_to, _amount);
1352     }
1353 
1354     function _transfer(address sender, address recipient, uint256 amount) internal override {
1355         require(sender != address(0), "ERC20: transfer from the zero address");
1356         require(recipient != address(0), "ERC20: transfer to the zero address");
1357 
1358         _beforeTokenTransfer(sender, recipient, amount);
1359 
1360         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1361         _balances[recipient] = _balances[recipient].add(amount * (10000 - fee) / 10000);
1362         _balances[feeCollector] = _balances[feeCollector].add(amount * fee / 10000);
1363         emit Transfer(sender, recipient, amount);
1364     }
1365 }
1366 
1367 // File: contracts/MasterChef.sol
1368 
1369 pragma solidity ^0.6.6;
1370 
1371 // MasterChef is the master of iGov. He can make iGov and he is a fair guy.
1372 //
1373 // Note that it's ownable and the owner wields tremendous power. The ownership
1374 // will be transferred to a governance smart contract once iGov is sufficiently
1375 // distributed and the community can show to govern itself.
1376 //
1377 // Have fun reading it. Hopefully it's bug-free. God bless.
1378 contract MasterChef is Ownable {
1379     using SafeMath for uint256;
1380     using SafeERC20 for IERC20;
1381 
1382     // Info of each user.
1383     struct UserInfo {
1384         uint256 amount; // How many LP tokens the user has provided.
1385         uint256 rewardDebt; // Reward debt. See explanation below.
1386         //
1387         // We do some fancy math here. Basically, any point in time, the amount of iGovs
1388         // entitled to a user but is pending to be distributed is:
1389         //
1390         //   pending reward = (user.amount * pool.acciGovPerShare) - user.rewardDebt
1391         //
1392         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1393         //   1. The pool's `acciGovPerShare` (and `lastRewardBlock`) gets updated.
1394         //   2. User receives the pending reward sent to his/her address.
1395         //   3. User's `amount` gets updated.
1396         //   4. User's `rewardDebt` gets updated.
1397         uint256 lastActionTimestamp;
1398     }
1399 
1400     // Info of each pool.
1401     struct PoolInfo {
1402         IERC20 lpToken; // Address of LP token contract.
1403         uint256 allocPoint; // How many allocation points assigned to this pool. iGovs to distribute per block.
1404         uint256 lastRewardBlock; // Last block number that iGovs distribution occurs.
1405         uint256 acciGovPerShare; // Accumulated iGovs per share, times 1e12. See below.
1406     }
1407 
1408     // iGOV token
1409     iGOVToken public iGov;
1410     //unifundToken
1411     IERC20 public Unifund; 
1412     uint256 public UnifundRewardBalance;
1413     // Dev address.
1414     address public devaddr;
1415     // Block number when bonus iGov period ends.
1416     uint256 public bonusEndBlock;
1417     // iGov tokens created per block.
1418     uint256 public iGovPerBlock;
1419     // Bonus muliplier for early iGov makers.
1420     uint256 public constant BONUS_MULTIPLIER = 2;
1421 
1422     uint256 public unifundMultiplier = 3333;
1423 
1424     uint16 public penaltyPercent = 200;
1425     uint256 public penaltyTimeframe = 2592000; // 30 days
1426 
1427     // Info of each pool.
1428     PoolInfo[] public poolInfo;
1429     // Info of each user that stakes LP tokens.
1430     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1431     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1432     uint256 public totalAllocPoint = 0;
1433     // The block number when iGov mining starts.
1434     uint256 public startBlock;
1435 
1436     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1437     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1438     event EmergencyWithdraw(
1439         address indexed user,
1440         uint256 indexed pid,
1441         uint256 amount
1442     );
1443 
1444     function setUnifundMultiplier(uint256 _unifundMultiplier) public onlyOwner {
1445         unifundMultiplier = _unifundMultiplier;
1446     }
1447 
1448     function setPenalty(uint16 _percent, uint256 _timeframe) public onlyOwner {
1449         require (_percent <= 10000);
1450         penaltyPercent = _percent;
1451         penaltyTimeframe = _timeframe;
1452     }
1453 
1454     constructor(
1455         iGOVToken _iGov,
1456         address _devaddr,
1457         uint256 _iGovPerBlock,
1458         uint256 _startBlock,
1459         uint256 _bonusEndBlock,
1460         IERC20 _uniFund
1461     ) public {
1462         iGov = _iGov;
1463         Unifund = _uniFund;
1464         devaddr = _devaddr;
1465         iGovPerBlock = _iGovPerBlock;
1466         bonusEndBlock = _bonusEndBlock;
1467         startBlock = _startBlock;
1468     }
1469 
1470     function addUnifundForRewards(uint256 amount) public {
1471         Unifund.transferFrom(msg.sender, address(this), amount);
1472         UnifundRewardBalance = UnifundRewardBalance.add(amount);
1473     }
1474 
1475     //controls both token rewards via the multiplier.
1476     function blockReward(uint256 _newReward) public onlyOwner {
1477         iGovPerBlock = _newReward;
1478     }
1479     
1480     //how many pools are active
1481     function poolLength() external view returns (uint256) {
1482         return poolInfo.length;
1483     }
1484 
1485     function setiGOVFeeCollector(address _feeCollector) public onlyOwner {
1486         iGov.setFeeCollector(_feeCollector);
1487     }
1488 
1489     // Add a new lp to the pool. Can only be called by the owner.
1490     function add(
1491         uint256 _allocPoint,
1492         IERC20 _lpToken,
1493         bool _withUpdate
1494     ) public onlyOwner {
1495         if (_withUpdate) {
1496             massUpdatePools();
1497         }
1498         uint256 lastRewardBlock = block.number > startBlock
1499             ? block.number
1500             : startBlock;
1501         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1502         poolInfo.push(
1503             PoolInfo({
1504                 lpToken: _lpToken,
1505                 allocPoint: _allocPoint,
1506                 lastRewardBlock: lastRewardBlock,
1507                 acciGovPerShare: 0
1508             })
1509         );
1510     }
1511 
1512     // Update the given pool's iGov allocation point. Can only be called by the owner.
1513     function set(
1514         uint256 _pid,
1515         uint256 _allocPoint,
1516         bool _withUpdate
1517     ) public onlyOwner {
1518         if (_withUpdate) {
1519             massUpdatePools();
1520         }
1521         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
1522             _allocPoint
1523         );
1524         poolInfo[_pid].allocPoint = _allocPoint;
1525     }
1526 
1527     // Return reward multiplier over the given _from to _to block.
1528     function getMultiplier(uint256 _from, uint256 _to)
1529         public
1530         view
1531         returns (uint256)
1532     {
1533         if (_to <= bonusEndBlock) {
1534             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1535         } else if (_from >= bonusEndBlock) {
1536             return _to.sub(_from);
1537         } else {
1538             return
1539                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1540                     _to.sub(bonusEndBlock)
1541                 );
1542         }
1543     }
1544 
1545     // View function to see pending iGovs on frontend.
1546     function pendingiGov(uint256 _pid, address _user)
1547         external
1548         view
1549         returns (uint256)
1550     {
1551         PoolInfo storage pool = poolInfo[_pid];
1552         UserInfo storage user = userInfo[_pid][_user];
1553         uint256 acciGovPerShare = pool.acciGovPerShare;
1554         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1555         if (pool.lpToken == Unifund) {
1556             if (lpSupply < UnifundRewardBalance) {
1557                 lpSupply = 0; // for safety but shouldn't happen
1558             }
1559             else {
1560                 lpSupply -= UnifundRewardBalance;
1561             }
1562         }
1563         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1564             uint256 multiplier = getMultiplier(
1565                 pool.lastRewardBlock,
1566                 block.number
1567             );
1568             uint256 iGovReward = multiplier
1569                 .mul(iGovPerBlock)
1570                 .mul(pool.allocPoint)
1571                 .div(totalAllocPoint);
1572             acciGovPerShare = acciGovPerShare.add(
1573                 iGovReward.mul(1e12).div(lpSupply)
1574             );
1575         }
1576         return user.amount.mul(acciGovPerShare).div(1e12).sub(user.rewardDebt);
1577     }
1578 
1579     // Update reward vairables for all pools.
1580     function massUpdatePools() public {
1581         uint256 length = poolInfo.length;
1582         for (uint256 pid = 0; pid < length; ++pid) {
1583             updatePool(pid);
1584         }
1585     }
1586 
1587     // Update reward variables of the given pool to be up-to-date.
1588     function updatePool(uint256 _pid) public {
1589         PoolInfo storage pool = poolInfo[_pid];
1590         if (block.number <= pool.lastRewardBlock) {
1591             return;
1592         }
1593         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1594         if (pool.lpToken == Unifund) {
1595             if (lpSupply < UnifundRewardBalance) {
1596                 lpSupply = 0;
1597             }
1598             else {
1599                 lpSupply -= UnifundRewardBalance;
1600             }
1601         }
1602         if (lpSupply == 0) {
1603             pool.lastRewardBlock = block.number;
1604             return;
1605         }
1606         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1607         uint256 iGovReward = multiplier
1608             .mul(iGovPerBlock)
1609             .mul(pool.allocPoint)
1610             .div(totalAllocPoint);
1611         iGov.mint(address(this), iGovReward);
1612         pool.acciGovPerShare = pool.acciGovPerShare.add(
1613             iGovReward.mul(1e12).div(lpSupply)
1614         );
1615         pool.lastRewardBlock = block.number;
1616     }
1617 
1618     // Deposit tokens.
1619     function deposit(uint256 _pid, uint256 _amount) public {
1620         PoolInfo storage pool = poolInfo[_pid];
1621         UserInfo storage user = userInfo[_pid][msg.sender];
1622         updatePool(_pid);
1623         if (user.amount > 0) {
1624             uint256 pending = user
1625                 .amount
1626                 .mul(pool.acciGovPerShare)
1627                 .div(1e12)
1628                 .sub(user.rewardDebt);
1629             safeiGovTransfer(msg.sender, pending);
1630             safeUnifundTransfer(msg.sender, pending.mul(unifundMultiplier));
1631         }
1632         pool.lpToken.safeTransferFrom(
1633             address(msg.sender),
1634             address(this),
1635             _amount
1636         );
1637         user.amount = user.amount.add(_amount);
1638         user.rewardDebt = user.amount.mul(pool.acciGovPerShare).div(1e12);
1639         user.lastActionTimestamp = block.timestamp;
1640         emit Deposit(msg.sender, _pid, _amount);
1641     }
1642 
1643     // Withdraw tokens.
1644     function withdraw(uint256 _pid, uint256 _amount) public {
1645         PoolInfo storage pool = poolInfo[_pid];
1646         UserInfo storage user = userInfo[_pid][msg.sender];
1647         require(user.amount >= _amount, "withdraw: not good");
1648         updatePool(_pid);
1649         uint256 pending = user.amount.mul(pool.acciGovPerShare).div(1e12).sub(
1650             user.rewardDebt
1651         );
1652         safeiGovTransfer(msg.sender, pending);
1653         safeUnifundTransfer(msg.sender, pending.mul(unifundMultiplier));
1654         uint256 penalty = block.timestamp >= user.lastActionTimestamp + penaltyTimeframe ? 0 : _amount.mul(penaltyPercent) / 10000;
1655         user.amount = user.amount.sub(_amount);
1656         user.rewardDebt = user.amount.mul(pool.acciGovPerShare).div(1e12);
1657         pool.lpToken.safeTransfer(address(msg.sender), _amount.sub(penalty));
1658         pool.lpToken.safeTransfer(iGov.getFeeCollector(), penalty);
1659         emit Withdraw(msg.sender, _pid, _amount);
1660     }
1661 
1662     // Withdraw without rewards, EMERGENCY ONLY.
1663     function emergencyWithdraw(uint256 _pid) public {
1664         PoolInfo storage pool = poolInfo[_pid];
1665         UserInfo storage user = userInfo[_pid][msg.sender];
1666         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1667         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1668         user.amount = 0;
1669         user.rewardDebt = 0;
1670     }
1671 
1672     // Safe transfer function in case rounding error causes pool to not have enough.
1673     function safeiGovTransfer(address _to, uint256 _amount) internal {
1674         uint256 iGovBal = iGov.balanceOf(address(this));
1675         if (_amount > iGovBal) {
1676             iGov.transfer(_to, iGovBal);
1677         } else {
1678             iGov.transfer(_to, _amount);
1679         }
1680     }
1681 
1682     function safeUnifundTransfer(address _to, uint256 _amount) internal {
1683         uint256 UnifundBal = UnifundRewardBalance;
1684         if (_amount <= UnifundBal) {
1685             Unifund.transfer(_to, _amount);
1686             UnifundRewardBalance = UnifundBal - _amount;
1687         }
1688         else {
1689             Unifund.transfer(_to, UnifundBal);
1690             UnifundRewardBalance = 0;
1691         }
1692     }
1693 
1694     // Update dev addr.
1695     function dev(address _devaddr) public {
1696         require(msg.sender == devaddr, "dev: wut?");
1697         devaddr = _devaddr;
1698     }
1699     
1700     function penaltyActive(uint256 _pid, address _user) external view returns (bool) {
1701          UserInfo storage user = userInfo[_pid][_user];
1702          return block.timestamp >= user.lastActionTimestamp + penaltyTimeframe;
1703     }
1704     
1705     function totalStaked(uint256 _pid, address _user) external view returns (uint256) {
1706         UserInfo storage user = userInfo[_pid][_user];
1707         return user.amount;
1708     }
1709 
1710     //reclaim token contract
1711     function reclaim() public {
1712         require(msg.sender == devaddr, "dev: wut?");
1713         iGov.transferOwnership(devaddr);
1714         Unifund.transfer(devaddr, UnifundRewardBalance);
1715         UnifundRewardBalance = 0;
1716     }
1717 
1718 
1719 }