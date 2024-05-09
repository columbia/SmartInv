1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-17
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-08
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: contracts/libs/Address.sol
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Collection of functions related to the address type
17  */
18 library Address {
19     /**
20      * @dev Returns true if `account` is a contract.
21      *
22      * [IMPORTANT]
23      * ====
24      * It is unsafe to assume that an address for which this function returns
25      * false is an externally-owned account (EOA) and not a contract.
26      *
27      * Among others, `isContract` will return false for the following
28      * types of addresses:
29      *
30      *  - an externally-owned account
31      *  - a contract in construction
32      *  - an address where a contract will be created
33      *  - an address where a contract lived, but was destroyed
34      * ====
35      */
36     function isContract(address account) internal view returns (bool) {
37         // This method relies on extcodesize, which returns 0 for contracts in
38         // construction, since the code is only stored at the end of the
39         // constructor execution.
40 
41         uint256 size;
42         // solhint-disable-next-line no-inline-assembly
43         assembly {
44             size := extcodesize(account)
45         }
46         return size > 0;
47     }
48 
49     /**
50      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
51      * `recipient`, forwarding all available gas and reverting on errors.
52      *
53      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
54      * of certain opcodes, possibly making contracts go over the 2300 gas limit
55      * imposed by `transfer`, making them unable to receive funds via
56      * `transfer`. {sendValue} removes this limitation.
57      *
58      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
59      *
60      * IMPORTANT: because control is transferred to `recipient`, care must be
61      * taken to not create reentrancy vulnerabilities. Consider using
62      * {ReentrancyGuard} or the
63      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(
67             address(this).balance >= amount,
68             "Address: insufficient balance"
69         );
70 
71         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
72         (bool success, ) = recipient.call{value: amount}("");
73         require(
74             success,
75             "Address: unable to send value, recipient may have reverted"
76         );
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain`call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data)
98         internal
99         returns (bytes memory)
100     {
101         return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(
111         address target,
112         bytes memory data,
113         string memory errorMessage
114     ) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint256 value
133     ) internal returns (bytes memory) {
134         return
135             functionCallWithValue(
136                 target,
137                 data,
138                 value,
139                 "Address: low-level call with value failed"
140             );
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
145      * with `errorMessage` as a fallback revert reason when `target` reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(
156             address(this).balance >= value,
157             "Address: insufficient balance for call"
158         );
159         require(isContract(target), "Address: call to non-contract");
160 
161         // solhint-disable-next-line avoid-low-level-calls
162         (bool success, bytes memory returndata) = target.call{value: value}(
163             data
164         );
165         return _verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but performing a static call.
171      *
172      * _Available since v3.3._
173      */
174     function functionStaticCall(address target, bytes memory data)
175         internal
176         view
177         returns (bytes memory)
178     {
179         return
180             functionStaticCall(
181                 target,
182                 data,
183                 "Address: low-level static call failed"
184             );
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
189      * but performing a static call.
190      *
191      * _Available since v3.3._
192      */
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         // solhint-disable-next-line avoid-low-level-calls
201         (bool success, bytes memory returndata) = target.staticcall(data);
202         return _verifyCallResult(success, returndata, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but performing a delegate call.
208      *
209      * _Available since v3.4._
210      */
211     function functionDelegateCall(address target, bytes memory data)
212         internal
213         returns (bytes memory)
214     {
215         return
216             functionDelegateCall(
217                 target,
218                 data,
219                 "Address: low-level delegate call failed"
220             );
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a delegate call.
226      *
227      * _Available since v3.4._
228      */
229     function functionDelegateCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal returns (bytes memory) {
234         require(isContract(target), "Address: delegate call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = target.delegatecall(data);
238         return _verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     function _verifyCallResult(
242         bool success,
243         bytes memory returndata,
244         string memory errorMessage
245     ) private pure returns (bytes memory) {
246         if (success) {
247             return returndata;
248         } else {
249             // Look for revert reason and bubble it up if present
250             if (returndata.length > 0) {
251                 // The easiest way to bubble the revert reason is using memory via assembly
252 
253                 // solhint-disable-next-line no-inline-assembly
254                 assembly {
255                     let returndata_size := mload(returndata)
256                     revert(add(32, returndata), returndata_size)
257                 }
258             } else {
259                 revert(errorMessage);
260             }
261         }
262     }
263 }
264 
265 // File: contracts/libs/IERC20.sol
266 
267 pragma solidity >=0.4.0;
268 
269 interface IERC20 {
270     /**
271      * @dev Returns the amount of tokens in existence.
272      */
273     function totalSupply() external view returns (uint256);
274 
275     /**
276      * @dev Returns the token decimals.
277      */
278     function decimals() external view returns (uint8);
279 
280     /**
281      * @dev Returns the token symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the token name.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the erc20 token owner.
292      */
293     function getOwner() external view returns (address);
294 
295     /**
296      * @dev Returns the amount of tokens owned by `account`.
297      */
298     function balanceOf(address account) external view returns (uint256);
299 
300     /**
301      * @dev Moves `amount` tokens from the caller's account to `recipient`.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transfer(address recipient, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Returns the remaining number of tokens that `spender` will be
311      * allowed to spend on behalf of `owner` through {transferFrom}. This is
312      * zero by default.
313      *
314      * This value changes when {approve} or {transferFrom} are called.
315      */
316     function allowance(address _owner, address spender) external view returns (uint256);
317 
318     /**
319      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * IMPORTANT: Beware that changing an allowance with this method brings the risk
324      * that someone may use both the old and the new allowance by unfortunate
325      * transaction ordering. One possible solution to mitigate this race
326      * condition is to first reduce the spender's allowance to 0 and set the
327      * desired value afterwards:
328      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address spender, uint256 amount) external returns (bool);
333 
334     /**
335      * @dev Moves `amount` tokens from `sender` to `recipient` using the
336      * allowance mechanism. `amount` is then deducted from the caller's
337      * allowance.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transferFrom(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) external returns (bool);
348 
349     /**
350      * @dev Emitted when `value` tokens are moved from one account (`from`) to
351      * another (`to`).
352      *
353      * Note that `value` may be zero.
354      */
355     event Transfer(address indexed from, address indexed to, uint256 value);
356 
357     /**
358      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
359      * a call to {approve}. `value` is the new allowance.
360      */
361     event Approval(address indexed owner, address indexed spender, uint256 value);
362 }
363 
364 // File: contracts/libs/SafeMath.sol
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Wrappers over Solidity's arithmetic operations with added overflow
370  * checks.
371  *
372  * Arithmetic operations in Solidity wrap on overflow. This can easily result
373  * in bugs, because programmers usually assume that an overflow raises an
374  * error, which is the standard behavior in high level programming languages.
375  * `SafeMath` restores this intuition by reverting the transaction when an
376  * operation overflows.
377  *
378  * Using this library instead of the unchecked operations eliminates an entire
379  * class of bugs, so it's recommended to use it always.
380  */
381 library SafeMath {
382     /**
383      * @dev Returns the addition of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryAdd(uint256 a, uint256 b)
388         internal
389         pure
390         returns (bool, uint256)
391     {
392         unchecked {
393             uint256 c = a + b;
394             if (c < a) return (false, 0);
395             return (true, c);
396         }
397     }
398 
399     /**
400      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
401      *
402      * _Available since v3.4._
403      */
404     function trySub(uint256 a, uint256 b)
405         internal
406         pure
407         returns (bool, uint256)
408     {
409         unchecked {
410             if (b > a) return (false, 0);
411             return (true, a - b);
412         }
413     }
414 
415     /**
416      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
417      *
418      * _Available since v3.4._
419      */
420     function tryMul(uint256 a, uint256 b)
421         internal
422         pure
423         returns (bool, uint256)
424     {
425         unchecked {
426             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
427             // benefit is lost if 'b' is also tested.
428             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
429             if (a == 0) return (true, 0);
430             uint256 c = a * b;
431             if (c / a != b) return (false, 0);
432             return (true, c);
433         }
434     }
435 
436     /**
437      * @dev Returns the division of two unsigned integers, with a division by zero flag.
438      *
439      * _Available since v3.4._
440      */
441     function tryDiv(uint256 a, uint256 b)
442         internal
443         pure
444         returns (bool, uint256)
445     {
446         unchecked {
447             if (b == 0) return (false, 0);
448             return (true, a / b);
449         }
450     }
451 
452     /**
453      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
454      *
455      * _Available since v3.4._
456      */
457     function tryMod(uint256 a, uint256 b)
458         internal
459         pure
460         returns (bool, uint256)
461     {
462         unchecked {
463             if (b == 0) return (false, 0);
464             return (true, a % b);
465         }
466     }
467 
468     /**
469      * @dev Returns the addition of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `+` operator.
473      *
474      * Requirements:
475      *
476      * - Addition cannot overflow.
477      */
478     function add(uint256 a, uint256 b) internal pure returns (uint256) {
479         return a + b;
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting on
484      * overflow (when the result is negative).
485      *
486      * Counterpart to Solidity's `-` operator.
487      *
488      * Requirements:
489      *
490      * - Subtraction cannot overflow.
491      */
492     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
493         return a - b;
494     }
495 
496     /**
497      * @dev Returns the multiplication of two unsigned integers, reverting on
498      * overflow.
499      *
500      * Counterpart to Solidity's `*` operator.
501      *
502      * Requirements:
503      *
504      * - Multiplication cannot overflow.
505      */
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         return a * b;
508     }
509 
510     /**
511      * @dev Returns the integer division of two unsigned integers, reverting on
512      * division by zero. The result is rounded towards zero.
513      *
514      * Counterpart to Solidity's `/` operator.
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function div(uint256 a, uint256 b) internal pure returns (uint256) {
521         return a / b;
522     }
523 
524     /**
525      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
526      * reverting when dividing by zero.
527      *
528      * Counterpart to Solidity's `%` operator. This function uses a `revert`
529      * opcode (which leaves remaining gas untouched) while Solidity uses an
530      * invalid opcode to revert (consuming all remaining gas).
531      *
532      * Requirements:
533      *
534      * - The divisor cannot be zero.
535      */
536     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
537         return a % b;
538     }
539 
540     /**
541      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
542      * overflow (when the result is negative).
543      *
544      * CAUTION: This function is deprecated because it requires allocating memory for the error
545      * message unnecessarily. For custom revert reasons use {trySub}.
546      *
547      * Counterpart to Solidity's `-` operator.
548      *
549      * Requirements:
550      *
551      * - Subtraction cannot overflow.
552      */
553     function sub(
554         uint256 a,
555         uint256 b,
556         string memory errorMessage
557     ) internal pure returns (uint256) {
558         unchecked {
559             require(b <= a, errorMessage);
560             return a - b;
561         }
562     }
563 
564     /**
565      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
566      * division by zero. The result is rounded towards zero.
567      *
568      * Counterpart to Solidity's `/` operator. Note: this function uses a
569      * `revert` opcode (which leaves remaining gas untouched) while Solidity
570      * uses an invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function div(
577         uint256 a,
578         uint256 b,
579         string memory errorMessage
580     ) internal pure returns (uint256) {
581         unchecked {
582             require(b > 0, errorMessage);
583             return a / b;
584         }
585     }
586 
587     /**
588      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
589      * reverting with custom message when dividing by zero.
590      *
591      * CAUTION: This function is deprecated because it requires allocating memory for the error
592      * message unnecessarily. For custom revert reasons use {tryMod}.
593      *
594      * Counterpart to Solidity's `%` operator. This function uses a `revert`
595      * opcode (which leaves remaining gas untouched) while Solidity uses an
596      * invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function mod(
603         uint256 a,
604         uint256 b,
605         string memory errorMessage
606     ) internal pure returns (uint256) {
607         unchecked {
608             require(b > 0, errorMessage);
609             return a % b;
610         }
611     }
612 }
613 
614 // File: contracts/libs/SafeERC20.sol
615 
616 pragma solidity ^0.8.0;
617 
618 
619 
620 
621 /**
622  * @title SafeERC20
623  * @dev Wrappers around ERC20 operations that throw on failure (when the token
624  * contract returns false). Tokens that return no value (and instead revert or
625  * throw on failure) are also supported, non-reverting calls are assumed to be
626  * successful.
627  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
628  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
629  */
630 library SafeERC20 {
631     using SafeMath for uint256;
632     using Address for address;
633 
634     function safeTransfer(
635         IERC20 token,
636         address to,
637         uint256 value
638     ) internal {
639         _callOptionalReturn(
640             token,
641             abi.encodeWithSelector(token.transfer.selector, to, value)
642         );
643     }
644 
645     function safeTransferFrom(
646         IERC20 token,
647         address from,
648         address to,
649         uint256 value
650     ) internal {
651         _callOptionalReturn(
652             token,
653             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
654         );
655     }
656 
657     /**
658      * @dev Deprecated. This function has issues similar to the ones found in
659      * {IERC20-approve}, and its usage is discouraged.
660      *
661      * Whenever possible, use {safeIncreaseAllowance} and
662      * {safeDecreaseAllowance} instead.
663      */
664     function safeApprove(
665         IERC20 token,
666         address spender,
667         uint256 value
668     ) internal {
669         // safeApprove should only be called when setting an initial allowance,
670         // or when resetting it to zero. To increase and decrease it, use
671         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
672         // solhint-disable-next-line max-line-length
673         require(
674             (value == 0) || (token.allowance(address(this), spender) == 0),
675             "SafeERC20: approve from non-zero to non-zero allowance"
676         );
677         _callOptionalReturn(
678             token,
679             abi.encodeWithSelector(token.approve.selector, spender, value)
680         );
681     }
682 
683     function safeIncreaseAllowance(
684         IERC20 token,
685         address spender,
686         uint256 value
687     ) internal {
688         uint256 newAllowance = token.allowance(address(this), spender).add(
689             value
690         );
691         _callOptionalReturn(
692             token,
693             abi.encodeWithSelector(
694                 token.approve.selector,
695                 spender,
696                 newAllowance
697             )
698         );
699     }
700 
701     function safeDecreaseAllowance(
702         IERC20 token,
703         address spender,
704         uint256 value
705     ) internal {
706         uint256 newAllowance = token.allowance(address(this), spender).sub(
707             value,
708             "SafeERC20: decreased allowance below zero"
709         );
710         _callOptionalReturn(
711             token,
712             abi.encodeWithSelector(
713                 token.approve.selector,
714                 spender,
715                 newAllowance
716             )
717         );
718     }
719 
720     /**
721      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
722      * on the return value: the return value is optional (but if data is returned, it must not be false).
723      * @param token The token targeted by the call.
724      * @param data The call data (encoded using abi.encode or one of its variants).
725      */
726     function _callOptionalReturn(IERC20 token, bytes memory data) private {
727         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
728         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
729         // the target address contains contract code and also asserts for success in the low-level call.
730 
731         bytes memory returndata = address(token).functionCall(
732             data,
733             "SafeERC20: low-level call failed"
734         );
735         if (returndata.length > 0) {
736             // Return data is optional
737             // solhint-disable-next-line max-line-length
738             require(
739                 abi.decode(returndata, (bool)),
740                 "SafeERC20: ERC20 operation did not succeed"
741             );
742         }
743     }
744 }
745 
746 // File: contracts/libs/EnumerableSet.sol
747 
748 pragma solidity ^0.8.0;
749 
750 /**
751  * @dev Library for managing
752  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
753  * types.
754  *
755  * Sets have the following properties:
756  *
757  * - Elements are added, removed, and checked for existence in constant time
758  * (O(1)).
759  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
760  *
761  * ```
762  * contract Example {
763  *     // Add the library methods
764  *     using EnumerableSet for EnumerableSet.AddressSet;
765  *
766  *     // Declare a set state variable
767  *     EnumerableSet.AddressSet private mySet;
768  * }
769  * ```
770  *
771  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
772  * and `uint256` (`UintSet`) are supported.
773  */
774 library EnumerableSet {
775     // To implement this library for multiple types with as little code
776     // repetition as possible, we write it in terms of a generic Set type with
777     // bytes32 values.
778     // The Set implementation uses private functions, and user-facing
779     // implementations (such as AddressSet) are just wrappers around the
780     // underlying Set.
781     // This means that we can only create new EnumerableSets for types that fit
782     // in bytes32.
783 
784     struct Set {
785         // Storage of set values
786         bytes32[] _values;
787         // Position of the value in the `values` array, plus 1 because index 0
788         // means a value is not in the set.
789         mapping(bytes32 => uint256) _indexes;
790     }
791 
792     /**
793      * @dev Add a value to a set. O(1).
794      *
795      * Returns true if the value was added to the set, that is if it was not
796      * already present.
797      */
798     function _add(Set storage set, bytes32 value) private returns (bool) {
799         if (!_contains(set, value)) {
800             set._values.push(value);
801             // The value is stored at length-1, but we add 1 to all indexes
802             // and use 0 as a sentinel value
803             set._indexes[value] = set._values.length;
804             return true;
805         } else {
806             return false;
807         }
808     }
809 
810     /**
811      * @dev Removes a value from a set. O(1).
812      *
813      * Returns true if the value was removed from the set, that is if it was
814      * present.
815      */
816     function _remove(Set storage set, bytes32 value) private returns (bool) {
817         // We read and store the value's index to prevent multiple reads from the same storage slot
818         uint256 valueIndex = set._indexes[value];
819 
820         if (valueIndex != 0) {
821             // Equivalent to contains(set, value)
822             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
823             // the array, and then remove the last element (sometimes called as 'swap and pop').
824             // This modifies the order of the array, as noted in {at}.
825 
826             uint256 toDeleteIndex = valueIndex - 1;
827             uint256 lastIndex = set._values.length - 1;
828 
829             if (lastIndex != toDeleteIndex) {
830                 bytes32 lastvalue = set._values[lastIndex];
831 
832                 // Move the last value to the index where the value to delete is
833                 set._values[toDeleteIndex] = lastvalue;
834                 // Update the index for the moved value
835                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
836             }
837 
838             // Delete the slot where the moved value was stored
839             set._values.pop();
840 
841             // Delete the index for the deleted slot
842             delete set._indexes[value];
843 
844             return true;
845         } else {
846             return false;
847         }
848     }
849 
850     /**
851      * @dev Returns true if the value is in the set. O(1).
852      */
853     function _contains(Set storage set, bytes32 value)
854         private
855         view
856         returns (bool)
857     {
858         return set._indexes[value] != 0;
859     }
860 
861     /**
862      * @dev Returns the number of values on the set. O(1).
863      */
864     function _length(Set storage set) private view returns (uint256) {
865         return set._values.length;
866     }
867 
868     /**
869      * @dev Returns the value stored at position `index` in the set. O(1).
870      *
871      * Note that there are no guarantees on the ordering of values inside the
872      * array, and it may change when more values are added or removed.
873      *
874      * Requirements:
875      *
876      * - `index` must be strictly less than {length}.
877      */
878     function _at(Set storage set, uint256 index)
879         private
880         view
881         returns (bytes32)
882     {
883         return set._values[index];
884     }
885 
886     /**
887      * @dev Return the entire set in an array
888      *
889      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
890      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
891      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
892      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
893      */
894     function _values(Set storage set) private view returns (bytes32[] memory) {
895         return set._values;
896     }
897 
898     // Bytes32Set
899 
900     struct Bytes32Set {
901         Set _inner;
902     }
903 
904     /**
905      * @dev Add a value to a set. O(1).
906      *
907      * Returns true if the value was added to the set, that is if it was not
908      * already present.
909      */
910     function add(Bytes32Set storage set, bytes32 value)
911         internal
912         returns (bool)
913     {
914         return _add(set._inner, value);
915     }
916 
917     /**
918      * @dev Removes a value from a set. O(1).
919      *
920      * Returns true if the value was removed from the set, that is if it was
921      * present.
922      */
923     function remove(Bytes32Set storage set, bytes32 value)
924         internal
925         returns (bool)
926     {
927         return _remove(set._inner, value);
928     }
929 
930     /**
931      * @dev Returns true if the value is in the set. O(1).
932      */
933     function contains(Bytes32Set storage set, bytes32 value)
934         internal
935         view
936         returns (bool)
937     {
938         return _contains(set._inner, value);
939     }
940 
941     /**
942      * @dev Returns the number of values in the set. O(1).
943      */
944     function length(Bytes32Set storage set) internal view returns (uint256) {
945         return _length(set._inner);
946     }
947 
948     /**
949      * @dev Returns the value stored at position `index` in the set. O(1).
950      *
951      * Note that there are no guarantees on the ordering of values inside the
952      * array, and it may change when more values are added or removed.
953      *
954      * Requirements:
955      *
956      * - `index` must be strictly less than {length}.
957      */
958     function at(Bytes32Set storage set, uint256 index)
959         internal
960         view
961         returns (bytes32)
962     {
963         return _at(set._inner, index);
964     }
965 
966     /**
967      * @dev Return the entire set in an array
968      *
969      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
970      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
971      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
972      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
973      */
974     function values(Bytes32Set storage set)
975         internal
976         view
977         returns (bytes32[] memory)
978     {
979         return _values(set._inner);
980     }
981 
982     // AddressSet
983 
984     struct AddressSet {
985         Set _inner;
986     }
987 
988     /**
989      * @dev Add a value to a set. O(1).
990      *
991      * Returns true if the value was added to the set, that is if it was not
992      * already present.
993      */
994     function add(AddressSet storage set, address value)
995         internal
996         returns (bool)
997     {
998         return _add(set._inner, bytes32(uint256(uint160(value))));
999     }
1000 
1001     /**
1002      * @dev Removes a value from a set. O(1).
1003      *
1004      * Returns true if the value was removed from the set, that is if it was
1005      * present.
1006      */
1007     function remove(AddressSet storage set, address value)
1008         internal
1009         returns (bool)
1010     {
1011         return _remove(set._inner, bytes32(uint256(uint160(value))));
1012     }
1013 
1014     /**
1015      * @dev Returns true if the value is in the set. O(1).
1016      */
1017     function contains(AddressSet storage set, address value)
1018         internal
1019         view
1020         returns (bool)
1021     {
1022         return _contains(set._inner, bytes32(uint256(uint160(value))));
1023     }
1024 
1025     /**
1026      * @dev Returns the number of values in the set. O(1).
1027      */
1028     function length(AddressSet storage set) internal view returns (uint256) {
1029         return _length(set._inner);
1030     }
1031 
1032     /**
1033      * @dev Returns the value stored at position `index` in the set. O(1).
1034      *
1035      * Note that there are no guarantees on the ordering of values inside the
1036      * array, and it may change when more values are added or removed.
1037      *
1038      * Requirements:
1039      *
1040      * - `index` must be strictly less than {length}.
1041      */
1042     function at(AddressSet storage set, uint256 index)
1043         internal
1044         view
1045         returns (address)
1046     {
1047         return address(uint160(uint256(_at(set._inner, index))));
1048     }
1049 
1050     /**
1051      * @dev Return the entire set in an array
1052      *
1053      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1054      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1055      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1056      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1057      */
1058     function values(AddressSet storage set)
1059         internal
1060         view
1061         returns (address[] memory)
1062     {
1063         bytes32[] memory store = _values(set._inner);
1064         address[] memory result;
1065 
1066         assembly {
1067             result := store
1068         }
1069 
1070         return result;
1071     }
1072 
1073     // UintSet
1074 
1075     struct UintSet {
1076         Set _inner;
1077     }
1078 
1079     /**
1080      * @dev Add a value to a set. O(1).
1081      *
1082      * Returns true if the value was added to the set, that is if it was not
1083      * already present.
1084      */
1085     function add(UintSet storage set, uint256 value) internal returns (bool) {
1086         return _add(set._inner, bytes32(value));
1087     }
1088 
1089     /**
1090      * @dev Removes a value from a set. O(1).
1091      *
1092      * Returns true if the value was removed from the set, that is if it was
1093      * present.
1094      */
1095     function remove(UintSet storage set, uint256 value)
1096         internal
1097         returns (bool)
1098     {
1099         return _remove(set._inner, bytes32(value));
1100     }
1101 
1102     /**
1103      * @dev Returns true if the value is in the set. O(1).
1104      */
1105     function contains(UintSet storage set, uint256 value)
1106         internal
1107         view
1108         returns (bool)
1109     {
1110         return _contains(set._inner, bytes32(value));
1111     }
1112 
1113     /**
1114      * @dev Returns the number of values on the set. O(1).
1115      */
1116     function length(UintSet storage set) internal view returns (uint256) {
1117         return _length(set._inner);
1118     }
1119 
1120     /**
1121      * @dev Returns the value stored at position `index` in the set. O(1).
1122      *
1123      * Note that there are no guarantees on the ordering of values inside the
1124      * array, and it may change when more values are added or removed.
1125      *
1126      * Requirements:
1127      *
1128      * - `index` must be strictly less than {length}.
1129      */
1130     function at(UintSet storage set, uint256 index)
1131         internal
1132         view
1133         returns (uint256)
1134     {
1135         return uint256(_at(set._inner, index));
1136     }
1137 
1138     /**
1139      * @dev Return the entire set in an array
1140      *
1141      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1142      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1143      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1144      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1145      */
1146     function values(UintSet storage set)
1147         internal
1148         view
1149         returns (uint256[] memory)
1150     {
1151         bytes32[] memory store = _values(set._inner);
1152         uint256[] memory result;
1153 
1154         assembly {
1155             result := store
1156         }
1157 
1158         return result;
1159     }
1160 }
1161 
1162 // File: contracts/libs/IERC721Receiver.sol
1163 
1164 
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 /**
1169  * @title ERC721 token receiver interface
1170  * @dev Interface for any contract that wants to support safeTransfers
1171  * from ERC721 asset contracts.
1172  */
1173 interface IERC721Receiver {
1174     /**
1175      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1176      * by `operator` from `from`, this function is called.
1177      *
1178      * It must return its Solidity selector to confirm the token transfer.
1179      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1180      *
1181      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1182      */
1183     function onERC721Received(
1184         address operator,
1185         address from,
1186         uint256 tokenId,
1187         bytes calldata data
1188     ) external returns (bytes4);
1189 }
1190 // File: contracts/libs/IERC165.sol
1191 
1192 
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 /**
1197  * @dev Interface of the ERC165 standard, as defined in the
1198  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1199  *
1200  * Implementers can declare support of contract interfaces, which can then be
1201  * queried by others ({ERC165Checker}).
1202  *
1203  * For an implementation, see {ERC165}.
1204  */
1205 interface IERC165 {
1206     /**
1207      * @dev Returns true if this contract implements the interface defined by
1208      * `interfaceId`. See the corresponding
1209      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1210      * to learn more about how these ids are created.
1211      *
1212      * This function call must use less than 30 000 gas.
1213      */
1214     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1215 }
1216 
1217 // File: contracts/libs/IERC721.sol
1218 
1219 
1220 
1221 pragma solidity ^0.8.0;
1222 
1223 
1224 /**
1225  * @dev Required interface of an ERC721 compliant contract.
1226  */
1227 interface IERC721 is IERC165 {
1228     /**
1229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1230      */
1231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1232 
1233     /**
1234      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1235      */
1236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1237 
1238     /**
1239      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1240      */
1241     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1242 
1243     /**
1244      * @dev Returns the number of tokens in ``owner``'s account.
1245      */
1246     function balanceOf(address owner) external view returns (uint256 balance);
1247 
1248     /**
1249      * @dev Returns the owner of the `tokenId` token.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      */
1255     function ownerOf(uint256 tokenId) external view returns (address owner);
1256 
1257     /**
1258      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1259      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1260      *
1261      * Requirements:
1262      *
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must exist and be owned by `from`.
1266      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function safeTransferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId
1275     ) external;
1276 
1277     /**
1278      * @dev Transfers `tokenId` token from `from` to `to`.
1279      *
1280      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1281      *
1282      * Requirements:
1283      *
1284      * - `from` cannot be the zero address.
1285      * - `to` cannot be the zero address.
1286      * - `tokenId` token must be owned by `from`.
1287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function transferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) external;
1296 
1297     /**
1298      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1299      * The approval is cleared when the token is transferred.
1300      *
1301      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1302      *
1303      * Requirements:
1304      *
1305      * - The caller must own the token or be an approved operator.
1306      * - `tokenId` must exist.
1307      *
1308      * Emits an {Approval} event.
1309      */
1310     function approve(address to, uint256 tokenId) external;
1311 
1312     /**
1313      * @dev Returns the account approved for `tokenId` token.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function getApproved(uint256 tokenId) external view returns (address operator);
1320 
1321     /**
1322      * @dev Approve or remove `operator` as an operator for the caller.
1323      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1324      *
1325      * Requirements:
1326      *
1327      * - The `operator` cannot be the caller.
1328      *
1329      * Emits an {ApprovalForAll} event.
1330      */
1331     function setApprovalForAll(address operator, bool _approved) external;
1332 
1333     /**
1334      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1335      *
1336      * See {setApprovalForAll}
1337      */
1338     function isApprovedForAll(address owner, address operator) external view returns (bool);
1339 
1340     /**
1341      * @dev Safely transfers `tokenId` token from `from` to `to`.
1342      *
1343      * Requirements:
1344      *
1345      * - `from` cannot be the zero address.
1346      * - `to` cannot be the zero address.
1347      * - `tokenId` token must exist and be owned by `from`.
1348      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1350      *
1351      * Emits a {Transfer} event.
1352      */
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId,
1357         bytes calldata data
1358     ) external;
1359 }
1360 // File: contracts/libs/Context.sol
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 /*
1365  * @dev Provides information about the current execution context, including the
1366  * sender of the transaction and its data. While these are generally available
1367  * via msg.sender and msg.data, they should not be accessed in such a direct
1368  * manner, since when dealing with meta-transactions the account sending and
1369  * paying for execution may not be the actual sender (as far as an application
1370  * is concerned).
1371  *
1372  * This contract is only required for intermediate, library-like contracts.
1373  */
1374 abstract contract Context {
1375     function _msgSender() internal view virtual returns (address) {
1376         return msg.sender;
1377     }
1378 
1379     function _msgData() internal view virtual returns (bytes calldata) {
1380         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1381         return msg.data;
1382     }
1383 }
1384 
1385 // File: contracts/libs/Ownable.sol
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 abstract contract Ownable is Context {
1391     address private _owner;
1392 
1393     event OwnershipTransferred(
1394         address indexed previousOwner,
1395         address indexed newOwner
1396     );
1397 
1398     /**
1399      * @dev Initializes the contract setting the deployer as the initial owner.
1400      */
1401     constructor() {
1402         _transferOwnership(_msgSender());
1403     }
1404 
1405     /**
1406      * @dev Returns the address of the current owner.
1407      */
1408     function owner() public view virtual returns (address) {
1409         return _owner;
1410     }
1411 
1412     /**
1413      * @dev Throws if called by any account other than the owner.
1414      */
1415     modifier onlyOwner() {
1416         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1417         _;
1418     }
1419 
1420     /**
1421      * @dev Leaves the contract without owner. It will not be possible to call
1422      * `onlyOwner` functions anymore. Can only be called by the current owner.
1423      *
1424      * NOTE: Renouncing ownership will leave the contract without an owner,
1425      * thereby removing any functionality that is only available to the owner.
1426      */
1427     function renounceOwnership() public virtual onlyOwner {
1428         _transferOwnership(address(0));
1429     }
1430 
1431     /**
1432      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1433      * Can only be called by the current owner.
1434      */
1435     function transferOwnership(address newOwner) public virtual onlyOwner {
1436         require(
1437             newOwner != address(0),
1438             "Ownable: new owner is the zero address"
1439         );
1440         _transferOwnership(newOwner);
1441     }
1442 
1443     /**
1444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1445      * Internal function without access restriction.
1446      */
1447     function _transferOwnership(address newOwner) internal virtual {
1448         address oldOwner = _owner;
1449         _owner = newOwner;
1450         emit OwnershipTransferred(oldOwner, newOwner);
1451     }
1452 }
1453 // File: contracts/libs/Pausable.sol
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 
1458 /**
1459  * @dev Contract module which allows children to implement an emergency stop
1460  * mechanism that can be triggered by an authorized account.
1461  *
1462  * This module is used through inheritance. It will make available the
1463  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1464  * the functions of your contract. Note that they will not be pausable by
1465  * simply including this module, only once the modifiers are put in place.
1466  */
1467 abstract contract Pausable is Ownable {
1468     /**
1469      * @dev Emitted when the pause is triggered by `account`.
1470      */
1471     event Paused(address account);
1472 
1473     /**
1474      * @dev Emitted when the pause is lifted by `account`.
1475      */
1476     event Unpaused(address account);
1477 
1478     bool private _paused;
1479 
1480     /**
1481      * @dev Initializes the contract in unpaused state.
1482      */
1483     constructor() {
1484         _paused = false;
1485     }
1486 
1487     /**
1488      * @dev Returns true if the contract is paused, and false otherwise.
1489      */
1490     function paused() public view virtual returns (bool) {
1491         return _paused;
1492     }
1493 
1494     /**
1495      * @dev Modifier to make a function callable only when the contract is not paused.
1496      *
1497      * Requirements:
1498      *
1499      * - The contract must not be paused.
1500      */
1501     modifier whenNotPaused() {
1502         require(!paused(), "Pausable: paused");
1503         _;
1504     }
1505 
1506     /**
1507      * @dev Modifier to make a function callable only when the contract is paused.
1508      *
1509      * Requirements:
1510      *
1511      * - The contract must be paused.
1512      */
1513     modifier whenPaused() {
1514         require(paused(), "Pausable: not paused");
1515         _;
1516     }
1517 
1518     /**
1519      * @dev Triggers stopped state.
1520      *
1521      * Requirements:
1522      *
1523      * - The contract must not be paused.
1524      */
1525     function pause() external onlyOwner whenNotPaused {
1526         _paused = true;
1527         emit Paused(_msgSender());
1528     }
1529 
1530     /**
1531      * @dev Returns to normal state.
1532      *
1533      * Requirements:
1534      *
1535      * - The contract must be paused.
1536      */
1537     function _unpause() external onlyOwner whenPaused {
1538         _paused = false;
1539         emit Unpaused(_msgSender());
1540     }
1541 }
1542 
1543 // File: contracts/libs/ReentrancyGuard.sol
1544 
1545 pragma solidity ^0.8.0;
1546 
1547 /**
1548  * @dev Contract module that helps prevent reentrant calls to a function.
1549  *
1550  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1551  * available, which can be applied to functions to make sure there are no nested
1552  * (reentrant) calls to them.
1553  *
1554  * Note that because there is a single `nonReentrant` guard, functions marked as
1555  * `nonReentrant` may not call one another. This can be worked around by making
1556  * those functions `private`, and then adding `external` `nonReentrant` entry
1557  * points to them.
1558  *
1559  * TIP: If you would like to learn more about reentrancy and alternative ways
1560  * to protect against it, check out our blog post
1561  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1562  */
1563 abstract contract ReentrancyGuard {
1564     // Booleans are more expensive than uint256 or any type that takes up a full
1565     // word because each write operation emits an extra SLOAD to first read the
1566     // slot's contents, replace the bits taken up by the boolean, and then write
1567     // back. This is the compiler's defense against contract upgrades and
1568     // pointer aliasing, and it cannot be disabled.
1569 
1570     // The values being non-zero value makes deployment a bit more expensive,
1571     // but in exchange the refund on every call to nonReentrant will be lower in
1572     // amount. Since refunds are capped to a percentage of the total
1573     // transaction's gas, it is best to keep them low in cases like this one, to
1574     // increase the likelihood of the full refund coming into effect.
1575     uint256 private constant _NOT_ENTERED = 1;
1576     uint256 private constant _ENTERED = 2;
1577 
1578     uint256 private _status;
1579 
1580     constructor() {
1581         _status = _NOT_ENTERED;
1582     }
1583 
1584     /**
1585      * @dev Prevents a contract from calling itself, directly or indirectly.
1586      * Calling a `nonReentrant` function from another `nonReentrant`
1587      * function is not supported. It is possible to prevent this from happening
1588      * by making the `nonReentrant` function external, and make it call a
1589      * `private` function that does the actual work.
1590      */
1591     modifier nonReentrant() {
1592         // On the first call to nonReentrant, _notEntered will be true
1593         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1594 
1595         // Any calls to nonReentrant after this point will fail
1596         _status = _ENTERED;
1597 
1598         _;
1599 
1600         // By storing the original value once again, a refund is triggered (see
1601         // https://eips.ethereum.org/EIPS/eip-2200)
1602         _status = _NOT_ENTERED;
1603     }
1604 }
1605 
1606 pragma solidity ^0.8.0;
1607 
1608 /**
1609  * @dev These functions deal with verification of Merkle Trees proofs.
1610  *
1611  * The proofs can be generated using the JavaScript library
1612  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1613  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1614  *
1615  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1616  */
1617 library MerkleProof {
1618     /**
1619      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1620      * defined by `root`. For this, a `proof` must be provided, containing
1621      * sibling hashes on the branch from the leaf to the root of the tree. Each
1622      * pair of leaves and each pair of pre-images are assumed to be sorted.
1623      */
1624     function verify(
1625         bytes32[] memory proof,
1626         bytes32 root,
1627         bytes32 leaf
1628     ) internal pure returns (bool) {
1629         return processProof(proof, leaf) == root;
1630     }
1631 
1632     /**
1633      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1634      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1635      * hash matches the root of the tree. When processing the proof, the pairs
1636      * of leafs & pre-images are assumed to be sorted.
1637      *
1638      * _Available since v4.4._
1639      */
1640     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1641         bytes32 computedHash = leaf;
1642         for (uint256 i = 0; i < proof.length; i++) {
1643             bytes32 proofElement = proof[i];
1644             if (computedHash <= proofElement) {
1645                 // Hash(current computed hash + current element of the proof)
1646                 computedHash = _efficientHash(computedHash, proofElement);
1647             } else {
1648                 // Hash(current element of the proof + current computed hash)
1649                 computedHash = _efficientHash(proofElement, computedHash);
1650             }
1651         }
1652         return computedHash;
1653     }
1654 
1655     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1656         assembly {
1657             mstore(0x00, a)
1658             mstore(0x20, b)
1659             value := keccak256(0x00, 0x40)
1660         }
1661     }
1662 }
1663 
1664 
1665 // File: contracts/NftStaking.sol
1666 
1667 
1668 
1669 pragma solidity ^0.8.0;
1670 
1671 
1672 contract NftStaking is ReentrancyGuard, Pausable, IERC721Receiver {
1673     using SafeMath for uint256;
1674     using EnumerableSet for EnumerableSet.UintSet;
1675     using SafeERC20 for IERC20;
1676 
1677     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
1678 
1679     enum Rarity {
1680         COMMON,
1681         RARE,
1682         ICONIC,
1683         GOLDEN
1684     }
1685 
1686     enum StakeType {
1687         UNLOCKED,
1688         LOCKED,
1689         PAIR_LOCKED
1690     }
1691 
1692     bytes32 public SEASON1_MERKLE_ROOT;
1693     bytes32 public SEASON2_MERKLE_ROOT;
1694 
1695     /** Season1 / Season2 NFT address */
1696     address public _season1Nft;
1697     address public _season2Nft;
1698     /** Reward Token address */
1699     address public _rewardToken;
1700 
1701     // Withdraw lock period
1702     uint256 public _lockPeriod = 60 days; // Lock period 60 days
1703     uint16 public _unstakeFee = 500; // Unstake fee 5%
1704     uint16 public _forcedUnstakeFee = 10000; // Force unstake fee 100%
1705 
1706     struct NftStakeInfo {
1707         Rarity _rarity;
1708         bool _isLocked;
1709         uint256 _pairedTokenId;
1710         uint256 _stakedAt;
1711     }
1712 
1713     struct UserInfo {
1714         EnumerableSet.UintSet _season1Nfts;
1715         EnumerableSet.UintSet _season2Nfts;
1716         mapping(uint256 => NftStakeInfo) _season1StakeInfos;
1717         mapping(uint256 => NftStakeInfo) _season2StakeInfos;
1718         uint256 _pending; // Not claimed
1719         uint256 _totalClaimed; // Claimed so far
1720         uint256 _lastClaimedAt;
1721         uint256 _pairCount; // Paired count
1722     }
1723 
1724     mapping(Rarity => uint256) _season1BaseRpds; // RPD: reward per day
1725     mapping(Rarity => uint16) _season1LockedExtras;
1726     mapping(Rarity => mapping(StakeType => uint16)) _season2Extras;
1727 
1728     // Info of each user that stakes LP tokens.
1729     mapping(address => UserInfo) private _userInfo;
1730 
1731     event Staked(
1732         address indexed account,
1733         uint256 tokenId,
1734         bool isSeason1,
1735         bool isLocked
1736     );
1737     event Unstaked(address indexed account, uint256 tokenId, bool isSeason1);
1738     event Locked(address indexed account, uint256 tokenId, bool isSeason1);
1739     event Paired(
1740         address indexed account,
1741         uint256 season1TokenId,
1742         uint256 season2TokenId
1743     );
1744     event Harvested(address indexed account, uint256 amount);
1745     event InsufficientRewardToken(
1746         address indexed account,
1747         uint256 amountNeeded,
1748         uint256 balance
1749     );
1750 
1751     constructor(address __rewardToken, address __season1Nft) {
1752         IERC20(__rewardToken).balanceOf(address(this));
1753         IERC721(__season1Nft).balanceOf(address(this));
1754 
1755         _rewardToken = __rewardToken;
1756         _season1Nft = __season1Nft;
1757 
1758         // Base reward per day
1759         _season1BaseRpds[Rarity.COMMON] = 50 ether;
1760         _season1BaseRpds[Rarity.RARE] = 125 ether;
1761         _season1BaseRpds[Rarity.ICONIC] = 250 ether;
1762 
1763         // Season1 locked cases extra percentage
1764         _season1LockedExtras[Rarity.COMMON] = 2000; // 20%
1765         _season1LockedExtras[Rarity.COMMON] = 2000; // 20%
1766         _season1LockedExtras[Rarity.COMMON] = 2000; // 20%
1767 
1768         // Season2 extra percentage
1769         _season2Extras[Rarity.COMMON][StakeType.UNLOCKED] = 1000;
1770         _season2Extras[Rarity.COMMON][StakeType.LOCKED] = 2000;
1771         _season2Extras[Rarity.COMMON][StakeType.PAIR_LOCKED] = 5000;
1772         _season2Extras[Rarity.RARE][StakeType.UNLOCKED] = 2000;
1773         _season2Extras[Rarity.RARE][StakeType.LOCKED] = 2000;
1774         _season2Extras[Rarity.RARE][StakeType.PAIR_LOCKED] = 5000;
1775         _season2Extras[Rarity.ICONIC][StakeType.UNLOCKED] = 3500;
1776         _season2Extras[Rarity.ICONIC][StakeType.LOCKED] = 2000;
1777         _season2Extras[Rarity.ICONIC][StakeType.PAIR_LOCKED] = 5000;
1778         _season2Extras[Rarity.GOLDEN][StakeType.UNLOCKED] = 5000;
1779         _season2Extras[Rarity.GOLDEN][StakeType.LOCKED] = 2000;
1780         _season2Extras[Rarity.GOLDEN][StakeType.PAIR_LOCKED] = 5000;
1781     }
1782 
1783     function setSeason2Nft(address __season2Nft) external onlyOwner {
1784         IERC721(__season2Nft).balanceOf(address(this));
1785         _season2Nft = __season2Nft;
1786     }
1787 
1788     function getRewardInNormal(
1789         uint256 __rpd,
1790         uint256 __stakedAt,
1791         uint256 __lastClaimedAt
1792     ) private view returns (uint256) {
1793         uint256 timePassed = __stakedAt > __lastClaimedAt
1794             ? block.timestamp.sub(__stakedAt)
1795             : block.timestamp.sub(__lastClaimedAt);
1796         return __rpd.mul(timePassed).div(1 days);
1797     }
1798 
1799     function getRewardInLocked(
1800         uint256 __rpd,
1801         uint256 __extraRate,
1802         uint256 __stakedAt,
1803         uint256 __lastClaimedAt
1804     ) private view returns (uint256 lockedAmount, uint256 unlockedAmount) {
1805         uint256 lockEndAt = __stakedAt.add(_lockPeriod);
1806         if (lockEndAt > block.timestamp) {
1807             lockedAmount = __rpd
1808                 .mul(block.timestamp.sub(__stakedAt))
1809                 .mul(uint256(10000).add(__extraRate))
1810                 .div(10000)
1811                 .div(1 days);
1812         } else {
1813             uint256 timePassed = __lastClaimedAt >= lockEndAt
1814                 ? block.timestamp.sub(__lastClaimedAt)
1815                 : block.timestamp.sub(__stakedAt);
1816             unlockedAmount = __rpd
1817                 .mul(timePassed)
1818                 .mul(uint256(10000).add(__extraRate))
1819                 .div(10000)
1820                 .div(1 days);
1821         }
1822     }
1823 
1824     function getSeason1Rewards(address __account, uint256 __nftId)
1825         private
1826         view
1827         returns (uint256 lockedAmount, uint256 unlockedAmount)
1828     {
1829         UserInfo storage user = _userInfo[__account];
1830         NftStakeInfo storage season1StakeInfo = user._season1StakeInfos[
1831             __nftId
1832         ];
1833         Rarity season1Rarity = season1StakeInfo._rarity;
1834         uint256 baseRpd = _season1BaseRpds[season1Rarity];
1835 
1836         // For the locked staking add extra percentage
1837         if (season1StakeInfo._isLocked) {
1838             (lockedAmount, unlockedAmount) = getRewardInLocked(
1839                 baseRpd,
1840                 _season1LockedExtras[season1Rarity],
1841                 season1StakeInfo._stakedAt,
1842                 user._lastClaimedAt
1843             );
1844         } else {
1845             unlockedAmount = getRewardInNormal(
1846                 baseRpd,
1847                 season1StakeInfo._stakedAt,
1848                 user._lastClaimedAt
1849             );
1850         }
1851     }
1852 
1853     function getPairedSeason2Rewards(address __account, uint256 __nftId)
1854         private
1855         view
1856         returns (uint256 lockedAmount, uint256 unlockedAmount)
1857     {
1858         UserInfo storage user = _userInfo[__account];
1859         NftStakeInfo storage season1StakeInfo = user._season1StakeInfos[
1860             __nftId
1861         ];
1862         NftStakeInfo storage season2StakeInfo = user._season2StakeInfos[
1863             season1StakeInfo._pairedTokenId
1864         ];
1865         Rarity season1Rarity = season1StakeInfo._rarity;
1866         Rarity season2Rarity = season2StakeInfo._rarity;
1867         uint256 baseRpd = _season1BaseRpds[season1Rarity];
1868         if (season1StakeInfo._pairedTokenId == 0) {
1869             lockedAmount = 0;
1870             unlockedAmount = 0;
1871         } else if (season2StakeInfo._isLocked) {
1872             // extra rate is wheter season1 is locked or not
1873             uint256 rpdExtraRate = season1StakeInfo._isLocked
1874                 ? _season2Extras[season2Rarity][StakeType.PAIR_LOCKED]
1875                 : _season2Extras[season2Rarity][StakeType.LOCKED];
1876             (lockedAmount, unlockedAmount) = getRewardInLocked(
1877                 baseRpd,
1878                 rpdExtraRate,
1879                 season2StakeInfo._stakedAt,
1880                 user._lastClaimedAt
1881             );
1882         } else {
1883             // base rpd for the season2 unlocked
1884             baseRpd = baseRpd
1885                 .mul(_season2Extras[season2Rarity][StakeType.UNLOCKED])
1886                 .div(10000);
1887             unlockedAmount = getRewardInNormal(
1888                 baseRpd,
1889                 season2StakeInfo._stakedAt,
1890                 user._lastClaimedAt
1891             );
1892         }
1893     }
1894 
1895     function viewProfit(address __account)
1896         public
1897         view
1898         returns (
1899             uint256 totalEarned,
1900             uint256 totalClaimed,
1901             uint256 lockedRewards,
1902             uint256 unlockedRewards
1903         )
1904     {
1905         UserInfo storage user = _userInfo[__account];
1906         totalClaimed = user._totalClaimed;
1907         unlockedRewards = user._pending;
1908 
1909         uint256 countSeason1Nfts = user._season1Nfts.length();
1910         uint256 index;
1911         for (index = 0; index < countSeason1Nfts; index++) {
1912             uint256 pendingLockedRewards = 0;
1913             uint256 pendingUnlockedRewards = 0;
1914 
1915             (pendingLockedRewards, pendingUnlockedRewards) = getSeason1Rewards(
1916                 __account,
1917                 user._season1Nfts.at(index)
1918             );
1919 
1920             // Add season1 reward
1921             if (pendingLockedRewards > 0) {
1922                 lockedRewards = lockedRewards.add(pendingLockedRewards);
1923             }
1924             if (pendingUnlockedRewards > 0) {
1925                 unlockedRewards = unlockedRewards.add(pendingUnlockedRewards);
1926             }
1927 
1928             (
1929                 pendingLockedRewards,
1930                 pendingUnlockedRewards
1931             ) = getPairedSeason2Rewards(__account, user._season1Nfts.at(index));
1932 
1933             // Add season2 reward
1934             if (pendingLockedRewards > 0) {
1935                 lockedRewards = lockedRewards.add(pendingLockedRewards);
1936             }
1937             if (pendingUnlockedRewards > 0) {
1938                 unlockedRewards = unlockedRewards.add(pendingUnlockedRewards);
1939             }
1940         }
1941 
1942         totalEarned = totalClaimed.add(lockedRewards).add(unlockedRewards);
1943     }
1944 
1945     /**
1946      * @notice Get season1 nfts
1947      */
1948     function viewSeason1Nfts(address __account)
1949         external
1950         view
1951         returns (uint256[] memory season1Nfts, bool[] memory lockStats)
1952     {
1953         UserInfo storage user = _userInfo[__account];
1954         uint256 countSeason1Nfts = user._season1Nfts.length();
1955 
1956         season1Nfts = new uint256[](countSeason1Nfts);
1957         lockStats = new bool[](countSeason1Nfts);
1958         uint256 index;
1959         uint256 tokenId;
1960         for (index = 0; index < countSeason1Nfts; index++) {
1961             tokenId = user._season1Nfts.at(index);
1962             season1Nfts[index] = tokenId;
1963             lockStats[index] = user._season1StakeInfos[tokenId]._isLocked;
1964         }
1965     }
1966 
1967     /**
1968      * @notice Get season2 nfts
1969      */
1970     function viewSeason2Nfts(address __account)
1971         external
1972         view
1973         returns (uint256[] memory season2Nfts, bool[] memory lockStats)
1974     {
1975         UserInfo storage user = _userInfo[__account];
1976         uint256 countSeason2Nfts = user._season2Nfts.length();
1977 
1978         season2Nfts = new uint256[](countSeason2Nfts);
1979         lockStats = new bool[](countSeason2Nfts);
1980         uint256 index;
1981         uint256 tokenId;
1982         for (index = 0; index < countSeason2Nfts; index++) {
1983             tokenId = user._season2Nfts.at(index);
1984             season2Nfts[index] = tokenId;
1985             lockStats[index] = user._season2StakeInfos[tokenId]._isLocked;
1986         }
1987     }
1988 
1989     /**
1990      * @notice Get paired season1 / season2 nfts
1991      */
1992     function viewPairedNfts(address __account)
1993         external
1994         view
1995         returns (
1996             uint256[] memory pairedSeason1Nfts,
1997             uint256[] memory pairedSeason2Nfts
1998         )
1999     {
2000         UserInfo storage user = _userInfo[__account];
2001         uint256 pairCount = user._pairCount;
2002         pairedSeason1Nfts = new uint256[](pairCount);
2003         pairedSeason2Nfts = new uint256[](pairCount);
2004         uint256 index;
2005         uint256 tokenId;
2006         uint256 rindex = 0;
2007         uint256 season2NftCount = user._season2Nfts.length();
2008         for (index = 0; index < season2NftCount; index++) {
2009             tokenId = user._season2Nfts.at(index);
2010             if (user._season2StakeInfos[tokenId]._pairedTokenId == 0) {
2011                 continue;
2012             }
2013             pairedSeason1Nfts[rindex] = user
2014                 ._season2StakeInfos[tokenId]
2015                 ._pairedTokenId;
2016             pairedSeason2Nfts[rindex] = tokenId;
2017             rindex = rindex.add(1);
2018         }
2019     }
2020 
2021     // Verify that a given leaf is in the tree.
2022     function isWhiteListedSeason1(bytes32 _leafNode, bytes32[] memory _proof)
2023         public
2024         view
2025         returns (bool)
2026     {
2027         return MerkleProof.verify(_proof, SEASON1_MERKLE_ROOT, _leafNode);
2028     }
2029 
2030     function isWhiteListedSeason2(bytes32 _leafNode, bytes32[] memory _proof)
2031         public
2032         view
2033         returns (bool)
2034     {
2035         return MerkleProof.verify(_proof, SEASON2_MERKLE_ROOT, _leafNode);
2036     }
2037 
2038     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
2039     function toLeaf(
2040         uint256 tokenID,
2041         uint256 index,
2042         uint256 amount
2043     ) public pure returns (bytes32) {
2044         return keccak256(abi.encodePacked(index, tokenID, amount));
2045     }
2046 
2047     function setMerkleRoot(bytes32 _season1Root, bytes32 _season2Root)
2048         external
2049         onlyOwner
2050     {
2051         SEASON1_MERKLE_ROOT = _season1Root;
2052         SEASON2_MERKLE_ROOT = _season2Root;
2053     }
2054 
2055     function updateFeeValues(uint16 __unstakeFee, uint16 __forcedUnstakeFee)
2056         external
2057         onlyOwner
2058     {
2059         _unstakeFee = __unstakeFee;
2060         _forcedUnstakeFee = __forcedUnstakeFee;
2061     }
2062 
2063     function updateLockPeriod(uint256 __lockPeriod) external onlyOwner {
2064         require(__lockPeriod > 0, "Invalid lock period");
2065         _lockPeriod = __lockPeriod;
2066     }
2067 
2068     function updateSeason1BaseRpd(Rarity __rarity, uint256 __rpd)
2069         external
2070         onlyOwner
2071     {
2072         require(__rpd > 0, "Non zero values required");
2073         _season1BaseRpds[__rarity] = __rpd;
2074     }
2075 
2076     function updateSeason1LockedExtraPercent(
2077         Rarity __rarity,
2078         uint16 __lockedExtraPercent
2079     ) external onlyOwner {
2080         _season1LockedExtras[__rarity] = __lockedExtraPercent;
2081     }
2082 
2083     function updateSeason2ExtraPercent(
2084         Rarity __rarity,
2085         StakeType __stakeType,
2086         uint16 __extraPercent
2087     ) external onlyOwner {
2088         _season2Extras[__rarity][__stakeType] = __extraPercent;
2089     }
2090 
2091     function isStaked(address __account, uint256 __tokenId)
2092         external
2093         view
2094         returns (bool)
2095     {
2096         UserInfo storage user = _userInfo[__account];
2097         return
2098             user._season1Nfts.contains(__tokenId) ||
2099             user._season2Nfts.contains(__tokenId);
2100     }
2101 
2102     /**
2103      * @notice Claim rewards
2104      */
2105     function claimRewards() external {
2106         UserInfo storage user = _userInfo[_msgSender()];
2107         (, , , uint256 unlockedRewards) = viewProfit(_msgSender());
2108         if (unlockedRewards > 0) {
2109             uint256 feeAmount = unlockedRewards.mul(_unstakeFee).div(10000);
2110             if (feeAmount > 0) {
2111                 IERC20(_rewardToken).safeTransfer(DEAD, feeAmount);
2112                 unlockedRewards = unlockedRewards.sub(feeAmount);
2113             }
2114             if (unlockedRewards > 0) {
2115                 user._totalClaimed = user._totalClaimed.add(unlockedRewards);
2116                 IERC20(_rewardToken).safeTransfer(_msgSender(), unlockedRewards);
2117             }
2118         }
2119         user._lastClaimedAt = block.timestamp;
2120     }
2121 
2122     /**
2123      * @notice Stake season1 nft
2124      */
2125     function stakeSeason1(
2126         bool __lockedStaking,
2127         uint256[] calldata __tokenIDList,
2128         uint256[] calldata __indexList,
2129         uint256[] calldata __rarityList,
2130         bytes32[][] calldata __proofList
2131     ) external nonReentrant whenNotPaused {
2132         require(
2133             IERC721(_season1Nft).isApprovedForAll(_msgSender(), address(this)),
2134             "Not approve nft to staker address"
2135         );
2136 
2137         UserInfo storage user = _userInfo[_msgSender()];
2138         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2139             // Check if the params are correct
2140             require(
2141                 isWhiteListedSeason1(
2142                     toLeaf(__tokenIDList[i], __indexList[i], __rarityList[i]),
2143                     __proofList[i]
2144                 ),
2145                 "Invalid params"
2146             );
2147 
2148             IERC721(_season1Nft).safeTransferFrom(
2149                 _msgSender(),
2150                 address(this),
2151                 __tokenIDList[i]
2152             );
2153 
2154             user._season1Nfts.add(__tokenIDList[i]);
2155             user._season1StakeInfos[__tokenIDList[i]] = NftStakeInfo({
2156                 _rarity: Rarity(__rarityList[i]),
2157                 _isLocked: __lockedStaking,
2158                 _stakedAt: block.timestamp,
2159                 _pairedTokenId: 0
2160             });
2161 
2162             emit Staked(_msgSender(), __tokenIDList[i], true, __lockedStaking);
2163         }
2164     }
2165 
2166     /**
2167      * @notice Stake season2 nft
2168      */
2169     function stakeSeason2(
2170         bool __lockedStaking,
2171         uint256[] calldata __tokenIDList,
2172         uint256[] calldata __indexList,
2173         uint256[] calldata __rarityList,
2174         bytes32[][] calldata __proofList
2175     ) external nonReentrant whenNotPaused {
2176         require(
2177             IERC721(_season2Nft).isApprovedForAll(_msgSender(), address(this)),
2178             "Not approve nft to staker address"
2179         );
2180 
2181         UserInfo storage user = _userInfo[_msgSender()];
2182         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2183             // Check if the params are correct
2184             require(
2185                 isWhiteListedSeason2(
2186                     toLeaf(__tokenIDList[i], __indexList[i], __rarityList[i]),
2187                     __proofList[i]
2188                 ),
2189                 "Invalid params"
2190             );
2191 
2192             IERC721(_season2Nft).safeTransferFrom(
2193                 _msgSender(),
2194                 address(this),
2195                 __tokenIDList[i]
2196             );
2197 
2198             user._season2Nfts.add(__tokenIDList[i]);
2199             user._season2StakeInfos[__tokenIDList[i]] = NftStakeInfo({
2200                 _rarity: Rarity(__rarityList[i]),
2201                 _isLocked: __lockedStaking,
2202                 _stakedAt: block.timestamp,
2203                 _pairedTokenId: 0
2204             });
2205 
2206             emit Staked(_msgSender(), __tokenIDList[i], false, __lockedStaking);
2207         }
2208     }
2209 
2210     function unstakeSeason1(uint256[] calldata __tokenIDList)
2211         external
2212         nonReentrant
2213     {
2214         UserInfo storage user = _userInfo[_msgSender()];
2215         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2216             require(
2217                 user._season1Nfts.contains(__tokenIDList[i]),
2218                 "Not staked one of nfts"
2219             );
2220 
2221             IERC721(_season1Nft).safeTransferFrom(
2222                 address(this),
2223                 _msgSender(),
2224                 __tokenIDList[i]
2225             );
2226 
2227             // locked rewards are sent to rewards back to the pool
2228             // unlocked rewards are added to the user rewards
2229             (, uint256 unlockedRewards) = getSeason1Rewards(
2230                 _msgSender(),
2231                 __tokenIDList[i]
2232             );
2233             user._pending = user._pending.add(unlockedRewards);
2234 
2235             user._season1Nfts.remove(__tokenIDList[i]);
2236             // If it was paired with a season2 nft, unpair them
2237             uint256 pairedTokenId = user
2238                 ._season1StakeInfos[__tokenIDList[i]]
2239                 ._pairedTokenId;
2240             if (pairedTokenId > 0) {
2241                 user._season2StakeInfos[pairedTokenId]._pairedTokenId = 0;
2242                 user._pairCount = user._pairCount.sub(1);
2243             }
2244 
2245             delete user._season1StakeInfos[__tokenIDList[i]];
2246 
2247             emit Unstaked(_msgSender(), __tokenIDList[i], true);
2248         }
2249     }
2250 
2251     function unstakeSeason2(uint256[] calldata __tokenIDList)
2252         external
2253         nonReentrant
2254     {
2255         UserInfo storage user = _userInfo[_msgSender()];
2256         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2257             require(
2258                 user._season2Nfts.contains(__tokenIDList[i]),
2259                 "Not staked one of nfts"
2260             );
2261 
2262             IERC721(_season2Nft).safeTransferFrom(
2263                 address(this),
2264                 _msgSender(),
2265                 __tokenIDList[i]
2266             );
2267 
2268             // If it was paired with a season1 nft, unpair them
2269             uint256 pairedTokenId = user
2270                 ._season2StakeInfos[__tokenIDList[i]]
2271                 ._pairedTokenId;
2272 
2273             if (pairedTokenId > 0) {
2274                 // locked rewards are sent to rewards back to the pool
2275                 // unlocked rewards are added to the user rewards
2276                 (, uint256 unlockedRewards) = getPairedSeason2Rewards(
2277                     _msgSender(),
2278                     pairedTokenId
2279                 );
2280                 user._pending = user._pending.add(unlockedRewards);
2281             }
2282 
2283             user._season2Nfts.remove(__tokenIDList[i]);
2284 
2285             if (pairedTokenId > 0) {
2286                 user._season1StakeInfos[pairedTokenId]._pairedTokenId = 0;
2287                 user._pairCount = user._pairCount.sub(1);
2288             }
2289             delete user._season2StakeInfos[__tokenIDList[i]];
2290 
2291             emit Unstaked(_msgSender(), __tokenIDList[i], false);
2292         }
2293     }
2294 
2295     /**
2296      * @notice Lock season1 nft from the unlocked pool to the lock pool
2297      */
2298     function lockSeason1Nfts(uint256[] calldata __tokenIDList)
2299         external
2300         onlyOwner
2301     {
2302         UserInfo storage user = _userInfo[_msgSender()];
2303         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2304             // Check if the params are correct
2305             require(
2306                 user._season1Nfts.contains(__tokenIDList[i]),
2307                 "One of nfts not staked yet"
2308             );
2309             require(
2310                 !user._season1StakeInfos[__tokenIDList[i]]._isLocked,
2311                 "Locked already"
2312             );
2313             (, uint256 unlockedRewards) = getSeason1Rewards(
2314                 _msgSender(),
2315                 __tokenIDList[i]
2316             );
2317             user._pending = user._pending.add(unlockedRewards);
2318 
2319             user._season1StakeInfos[__tokenIDList[i]]._isLocked = true;
2320             user._season1StakeInfos[__tokenIDList[i]]._stakedAt = block
2321                 .timestamp;
2322             emit Locked(_msgSender(), __tokenIDList[i], true);
2323         }
2324     }
2325 
2326     /**
2327      * @notice Lock season2 nft from the unlocked pool to the lock pool
2328      */
2329     function lockSeason2Nfts(uint256[] calldata __tokenIDList)
2330         external
2331         onlyOwner
2332     {
2333         UserInfo storage user = _userInfo[_msgSender()];
2334         for (uint256 i = 0; i < __tokenIDList.length; i++) {
2335             // Check if the params are correct
2336             require(
2337                 user._season2Nfts.contains(__tokenIDList[i]),
2338                 "One of nfts not staked yet"
2339             );
2340             require(
2341                 !user._season2StakeInfos[__tokenIDList[i]]._isLocked,
2342                 "Locked already"
2343             );
2344             uint256 pairedTokenId = user
2345                 ._season2StakeInfos[__tokenIDList[i]]
2346                 ._pairedTokenId;
2347 
2348             if (pairedTokenId > 0) {
2349                 (, uint256 unlockedRewards) = getPairedSeason2Rewards(
2350                     _msgSender(),
2351                     pairedTokenId
2352                 );
2353                 user._pending = user._pending.add(unlockedRewards);
2354             }
2355             user._season2StakeInfos[__tokenIDList[i]]._isLocked = true;
2356             user._season2StakeInfos[__tokenIDList[i]]._stakedAt = block
2357                 .timestamp;
2358 
2359             emit Locked(_msgSender(), __tokenIDList[i], false);
2360         }
2361     }
2362 
2363     /**
2364      * @notice
2365      */
2366     function pairNfts(uint256 __season1TokenID, uint256 __season2TokenID)
2367         external
2368         nonReentrant
2369         whenNotPaused
2370     {
2371         UserInfo storage user = _userInfo[_msgSender()];
2372         require(
2373             user._season1Nfts.contains(__season1TokenID) &&
2374                 user._season2Nfts.contains(__season2TokenID),
2375             "One of nfts is not staked"
2376         );
2377         require(
2378             user._season1StakeInfos[__season1TokenID]._pairedTokenId == 0 &&
2379                 user._season2StakeInfos[__season2TokenID]._pairedTokenId == 0,
2380             "Already paired"
2381         );
2382         user
2383             ._season1StakeInfos[__season1TokenID]
2384             ._pairedTokenId = __season2TokenID;
2385         user
2386             ._season2StakeInfos[__season2TokenID]
2387             ._pairedTokenId = __season1TokenID;
2388         user._season2StakeInfos[__season2TokenID]._stakedAt = block.timestamp;
2389         user._pairCount = user._pairCount.add(1);
2390 
2391         emit Paired(_msgSender(), __season1TokenID, __season2TokenID);
2392     }
2393 
2394     function safeRewardTransfer(address __to, uint256 __amount)
2395         internal
2396         returns (uint256)
2397     {
2398         uint256 balance = IERC20(_rewardToken).balanceOf(address(this));
2399         if (balance >= __amount) {
2400             IERC20(_rewardToken).safeTransfer(__to, __amount);
2401             return __amount;
2402         }
2403 
2404         if (balance > 0) {
2405             IERC20(_rewardToken).safeTransfer(__to, balance);
2406         }
2407         emit InsufficientRewardToken(__to, __amount, balance);
2408         return balance;
2409     }
2410 
2411     function onERC721Received(
2412         address,
2413         address,
2414         uint256,
2415         bytes memory
2416     ) public virtual override returns (bytes4) {
2417         return this.onERC721Received.selector;
2418     }
2419 }