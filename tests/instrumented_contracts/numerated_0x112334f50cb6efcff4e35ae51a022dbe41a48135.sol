1 // File: @openzeppelin/contracts/token/ERC777/IERC777.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC777Token standard as defined in the EIP.
9  *
10  * This contract uses the
11  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
12  * token holders and recipients react to token movements by using setting implementers
13  * for the associated interfaces in said registry. See {IERC1820Registry} and
14  * {ERC1820Implementer}.
15  */
16 interface IERC777 {
17     /**
18      * @dev Returns the name of the token.
19      */
20     function name() external view returns (string memory);
21 
22     /**
23      * @dev Returns the symbol of the token, usually a shorter version of the
24      * name.
25      */
26     function symbol() external view returns (string memory);
27 
28     /**
29      * @dev Returns the smallest part of the token that is not divisible. This
30      * means all token operations (creation, movement and destruction) must have
31      * amounts that are a multiple of this number.
32      *
33      * For most token contracts, this value will equal 1.
34      */
35     function granularity() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by an account (`owner`).
44      */
45     function balanceOf(address owner) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * If send or receive hooks are registered for the caller and `recipient`,
51      * the corresponding functions will be called with `data` and empty
52      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
53      *
54      * Emits a {Sent} event.
55      *
56      * Requirements
57      *
58      * - the caller must have at least `amount` tokens.
59      * - `recipient` cannot be the zero address.
60      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
61      * interface.
62      */
63     function send(address recipient, uint256 amount, bytes calldata data) external;
64 
65     /**
66      * @dev Destroys `amount` tokens from the caller's account, reducing the
67      * total supply.
68      *
69      * If a send hook is registered for the caller, the corresponding function
70      * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
71      *
72      * Emits a {Burned} event.
73      *
74      * Requirements
75      *
76      * - the caller must have at least `amount` tokens.
77      */
78     function burn(uint256 amount, bytes calldata data) external;
79 
80     /**
81      * @dev Returns true if an account is an operator of `tokenHolder`.
82      * Operators can send and burn tokens on behalf of their owners. All
83      * accounts are their own operator.
84      *
85      * See {operatorSend} and {operatorBurn}.
86      */
87     function isOperatorFor(address operator, address tokenHolder) external view returns (bool);
88 
89     /**
90      * @dev Make an account an operator of the caller.
91      *
92      * See {isOperatorFor}.
93      *
94      * Emits an {AuthorizedOperator} event.
95      *
96      * Requirements
97      *
98      * - `operator` cannot be calling address.
99      */
100     function authorizeOperator(address operator) external;
101 
102     /**
103      * @dev Revoke an account's operator status for the caller.
104      *
105      * See {isOperatorFor} and {defaultOperators}.
106      *
107      * Emits a {RevokedOperator} event.
108      *
109      * Requirements
110      *
111      * - `operator` cannot be calling address.
112      */
113     function revokeOperator(address operator) external;
114 
115     /**
116      * @dev Returns the list of default operators. These accounts are operators
117      * for all token holders, even if {authorizeOperator} was never called on
118      * them.
119      *
120      * This list is immutable, but individual holders may revoke these via
121      * {revokeOperator}, in which case {isOperatorFor} will return false.
122      */
123     function defaultOperators() external view returns (address[] memory);
124 
125     /**
126      * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
127      * be an operator of `sender`.
128      *
129      * If send or receive hooks are registered for `sender` and `recipient`,
130      * the corresponding functions will be called with `data` and
131      * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
132      *
133      * Emits a {Sent} event.
134      *
135      * Requirements
136      *
137      * - `sender` cannot be the zero address.
138      * - `sender` must have at least `amount` tokens.
139      * - the caller must be an operator for `sender`.
140      * - `recipient` cannot be the zero address.
141      * - if `recipient` is a contract, it must implement the {IERC777Recipient}
142      * interface.
143      */
144     function operatorSend(
145         address sender,
146         address recipient,
147         uint256 amount,
148         bytes calldata data,
149         bytes calldata operatorData
150     ) external;
151 
152     /**
153      * @dev Destroys `amount` tokens from `account`, reducing the total supply.
154      * The caller must be an operator of `account`.
155      *
156      * If a send hook is registered for `account`, the corresponding function
157      * will be called with `data` and `operatorData`. See {IERC777Sender}.
158      *
159      * Emits a {Burned} event.
160      *
161      * Requirements
162      *
163      * - `account` cannot be the zero address.
164      * - `account` must have at least `amount` tokens.
165      * - the caller must be an operator for `account`.
166      */
167     function operatorBurn(
168         address account,
169         uint256 amount,
170         bytes calldata data,
171         bytes calldata operatorData
172     ) external;
173 
174     event Sent(
175         address indexed operator,
176         address indexed from,
177         address indexed to,
178         uint256 amount,
179         bytes data,
180         bytes operatorData
181     );
182 
183     event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
184 
185     event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
186 
187     event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
188 
189     event RevokedOperator(address indexed operator, address indexed tokenHolder);
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
193 
194 // SPDX-License-Identifier: MIT
195 
196 pragma solidity ^0.6.0;
197 
198 /**
199  * @dev Interface of the ERC20 standard as defined in the EIP.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Moves `amount` tokens from `sender` to `recipient` using the
248      * allowance mechanism. `amount` is then deducted from the caller's
249      * allowance.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
256 
257     /**
258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
259      * another (`to`).
260      *
261      * Note that `value` may be zero.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 value);
264 
265     /**
266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
267      * a call to {approve}. `value` is the new allowance.
268      */
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 // File: @openzeppelin/contracts/math/SafeMath.sol
273 
274 // SPDX-License-Identifier: MIT
275 
276 pragma solidity ^0.6.0;
277 
278 /**
279  * @dev Wrappers over Solidity's arithmetic operations with added overflow
280  * checks.
281  *
282  * Arithmetic operations in Solidity wrap on overflow. This can easily result
283  * in bugs, because programmers usually assume that an overflow raises an
284  * error, which is the standard behavior in high level programming languages.
285  * `SafeMath` restores this intuition by reverting the transaction when an
286  * operation overflows.
287  *
288  * Using this library instead of the unchecked operations eliminates an entire
289  * class of bugs, so it's recommended to use it always.
290  */
291 library SafeMath {
292     /**
293      * @dev Returns the addition of two unsigned integers, reverting on
294      * overflow.
295      *
296      * Counterpart to Solidity's `+` operator.
297      *
298      * Requirements:
299      *
300      * - Addition cannot overflow.
301      */
302     function add(uint256 a, uint256 b) internal pure returns (uint256) {
303         uint256 c = a + b;
304         require(c >= a, "SafeMath: addition overflow");
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the subtraction of two unsigned integers, reverting on
311      * overflow (when the result is negative).
312      *
313      * Counterpart to Solidity's `-` operator.
314      *
315      * Requirements:
316      *
317      * - Subtraction cannot overflow.
318      */
319     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
320         return sub(a, b, "SafeMath: subtraction overflow");
321     }
322 
323     /**
324      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
325      * overflow (when the result is negative).
326      *
327      * Counterpart to Solidity's `-` operator.
328      *
329      * Requirements:
330      *
331      * - Subtraction cannot overflow.
332      */
333     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b <= a, errorMessage);
335         uint256 c = a - b;
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the multiplication of two unsigned integers, reverting on
342      * overflow.
343      *
344      * Counterpart to Solidity's `*` operator.
345      *
346      * Requirements:
347      *
348      * - Multiplication cannot overflow.
349      */
350     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
351         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
352         // benefit is lost if 'b' is also tested.
353         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
354         if (a == 0) {
355             return 0;
356         }
357 
358         uint256 c = a * b;
359         require(c / a == b, "SafeMath: multiplication overflow");
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the integer division of two unsigned integers. Reverts on
366      * division by zero. The result is rounded towards zero.
367      *
368      * Counterpart to Solidity's `/` operator. Note: this function uses a
369      * `revert` opcode (which leaves remaining gas untouched) while Solidity
370      * uses an invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function div(uint256 a, uint256 b) internal pure returns (uint256) {
377         return div(a, b, "SafeMath: division by zero");
378     }
379 
380     /**
381      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
382      * division by zero. The result is rounded towards zero.
383      *
384      * Counterpart to Solidity's `/` operator. Note: this function uses a
385      * `revert` opcode (which leaves remaining gas untouched) while Solidity
386      * uses an invalid opcode to revert (consuming all remaining gas).
387      *
388      * Requirements:
389      *
390      * - The divisor cannot be zero.
391      */
392     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
393         require(b > 0, errorMessage);
394         uint256 c = a / b;
395         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
396 
397         return c;
398     }
399 
400     /**
401      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
402      * Reverts when dividing by zero.
403      *
404      * Counterpart to Solidity's `%` operator. This function uses a `revert`
405      * opcode (which leaves remaining gas untouched) while Solidity uses an
406      * invalid opcode to revert (consuming all remaining gas).
407      *
408      * Requirements:
409      *
410      * - The divisor cannot be zero.
411      */
412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
413         return mod(a, b, "SafeMath: modulo by zero");
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
418      * Reverts with custom message when dividing by zero.
419      *
420      * Counterpart to Solidity's `%` operator. This function uses a `revert`
421      * opcode (which leaves remaining gas untouched) while Solidity uses an
422      * invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b != 0, errorMessage);
430         return a % b;
431     }
432 }
433 
434 // File: @openzeppelin/contracts/utils/Address.sol
435 
436 // SPDX-License-Identifier: MIT
437 
438 pragma solidity ^0.6.2;
439 
440 /**
441  * @dev Collection of functions related to the address type
442  */
443 library Address {
444     /**
445      * @dev Returns true if `account` is a contract.
446      *
447      * [IMPORTANT]
448      * ====
449      * It is unsafe to assume that an address for which this function returns
450      * false is an externally-owned account (EOA) and not a contract.
451      *
452      * Among others, `isContract` will return false for the following
453      * types of addresses:
454      *
455      *  - an externally-owned account
456      *  - a contract in construction
457      *  - an address where a contract will be created
458      *  - an address where a contract lived, but was destroyed
459      * ====
460      */
461     function isContract(address account) internal view returns (bool) {
462         // This method relies in extcodesize, which returns 0 for contracts in
463         // construction, since the code is only stored at the end of the
464         // constructor execution.
465 
466         uint256 size;
467         // solhint-disable-next-line no-inline-assembly
468         assembly { size := extcodesize(account) }
469         return size > 0;
470     }
471 
472     /**
473      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
474      * `recipient`, forwarding all available gas and reverting on errors.
475      *
476      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
477      * of certain opcodes, possibly making contracts go over the 2300 gas limit
478      * imposed by `transfer`, making them unable to receive funds via
479      * `transfer`. {sendValue} removes this limitation.
480      *
481      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
482      *
483      * IMPORTANT: because control is transferred to `recipient`, care must be
484      * taken to not create reentrancy vulnerabilities. Consider using
485      * {ReentrancyGuard} or the
486      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
487      */
488     function sendValue(address payable recipient, uint256 amount) internal {
489         require(address(this).balance >= amount, "Address: insufficient balance");
490 
491         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
492         (bool success, ) = recipient.call{ value: amount }("");
493         require(success, "Address: unable to send value, recipient may have reverted");
494     }
495 
496     /**
497      * @dev Performs a Solidity function call using a low level `call`. A
498      * plain`call` is an unsafe replacement for a function call: use this
499      * function instead.
500      *
501      * If `target` reverts with a revert reason, it is bubbled up by this
502      * function (like regular Solidity function calls).
503      *
504      * Returns the raw returned data. To convert to the expected return value,
505      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
506      *
507      * Requirements:
508      *
509      * - `target` must be a contract.
510      * - calling `target` with `data` must not revert.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
515       return functionCall(target, data, "Address: low-level call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
520      * `errorMessage` as a fallback revert reason when `target` reverts.
521      *
522      * _Available since v3.1._
523      */
524     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
525         return _functionCallWithValue(target, data, 0, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but also transferring `value` wei to `target`.
531      *
532      * Requirements:
533      *
534      * - the calling contract must have an ETH balance of at least `value`.
535      * - the called Solidity function must be `payable`.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
545      * with `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
550         require(address(this).balance >= value, "Address: insufficient balance for call");
551         return _functionCallWithValue(target, data, value, errorMessage);
552     }
553 
554     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
555         require(isContract(target), "Address: call to non-contract");
556 
557         // solhint-disable-next-line avoid-low-level-calls
558         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
559         if (success) {
560             return returndata;
561         } else {
562             // Look for revert reason and bubble it up if present
563             if (returndata.length > 0) {
564                 // The easiest way to bubble the revert reason is using memory via assembly
565 
566                 // solhint-disable-next-line no-inline-assembly
567                 assembly {
568                     let returndata_size := mload(returndata)
569                     revert(add(32, returndata), returndata_size)
570                 }
571             } else {
572                 revert(errorMessage);
573             }
574         }
575     }
576 }
577 
578 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
579 
580 // SPDX-License-Identifier: MIT
581 
582 pragma solidity ^0.6.0;
583 
584 
585 
586 
587 /**
588  * @title SafeERC20
589  * @dev Wrappers around ERC20 operations that throw on failure (when the token
590  * contract returns false). Tokens that return no value (and instead revert or
591  * throw on failure) are also supported, non-reverting calls are assumed to be
592  * successful.
593  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
594  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
595  */
596 library SafeERC20 {
597     using SafeMath for uint256;
598     using Address for address;
599 
600     function safeTransfer(IERC20 token, address to, uint256 value) internal {
601         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
602     }
603 
604     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
605         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
606     }
607 
608     /**
609      * @dev Deprecated. This function has issues similar to the ones found in
610      * {IERC20-approve}, and its usage is discouraged.
611      *
612      * Whenever possible, use {safeIncreaseAllowance} and
613      * {safeDecreaseAllowance} instead.
614      */
615     function safeApprove(IERC20 token, address spender, uint256 value) internal {
616         // safeApprove should only be called when setting an initial allowance,
617         // or when resetting it to zero. To increase and decrease it, use
618         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
619         // solhint-disable-next-line max-line-length
620         require((value == 0) || (token.allowance(address(this), spender) == 0),
621             "SafeERC20: approve from non-zero to non-zero allowance"
622         );
623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
624     }
625 
626     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
627         uint256 newAllowance = token.allowance(address(this), spender).add(value);
628         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
629     }
630 
631     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
632         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
634     }
635 
636     /**
637      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
638      * on the return value: the return value is optional (but if data is returned, it must not be false).
639      * @param token The token targeted by the call.
640      * @param data The call data (encoded using abi.encode or one of its variants).
641      */
642     function _callOptionalReturn(IERC20 token, bytes memory data) private {
643         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
644         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
645         // the target address contains contract code and also asserts for success in the low-level call.
646 
647         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
648         if (returndata.length > 0) { // Return data is optional
649             // solhint-disable-next-line max-line-length
650             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
651         }
652     }
653 }
654 
655 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
656 
657 // SPDX-License-Identifier: MIT
658 
659 pragma solidity ^0.6.0;
660 
661 /**
662  * @dev Library for managing
663  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
664  * types.
665  *
666  * Sets have the following properties:
667  *
668  * - Elements are added, removed, and checked for existence in constant time
669  * (O(1)).
670  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
671  *
672  * ```
673  * contract Example {
674  *     // Add the library methods
675  *     using EnumerableSet for EnumerableSet.AddressSet;
676  *
677  *     // Declare a set state variable
678  *     EnumerableSet.AddressSet private mySet;
679  * }
680  * ```
681  *
682  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
683  * (`UintSet`) are supported.
684  */
685 library EnumerableSet {
686     // To implement this library for multiple types with as little code
687     // repetition as possible, we write it in terms of a generic Set type with
688     // bytes32 values.
689     // The Set implementation uses private functions, and user-facing
690     // implementations (such as AddressSet) are just wrappers around the
691     // underlying Set.
692     // This means that we can only create new EnumerableSets for types that fit
693     // in bytes32.
694 
695     struct Set {
696         // Storage of set values
697         bytes32[] _values;
698 
699         // Position of the value in the `values` array, plus 1 because index 0
700         // means a value is not in the set.
701         mapping (bytes32 => uint256) _indexes;
702     }
703 
704     /**
705      * @dev Add a value to a set. O(1).
706      *
707      * Returns true if the value was added to the set, that is if it was not
708      * already present.
709      */
710     function _add(Set storage set, bytes32 value) private returns (bool) {
711         if (!_contains(set, value)) {
712             set._values.push(value);
713             // The value is stored at length-1, but we add 1 to all indexes
714             // and use 0 as a sentinel value
715             set._indexes[value] = set._values.length;
716             return true;
717         } else {
718             return false;
719         }
720     }
721 
722     /**
723      * @dev Removes a value from a set. O(1).
724      *
725      * Returns true if the value was removed from the set, that is if it was
726      * present.
727      */
728     function _remove(Set storage set, bytes32 value) private returns (bool) {
729         // We read and store the value's index to prevent multiple reads from the same storage slot
730         uint256 valueIndex = set._indexes[value];
731 
732         if (valueIndex != 0) { // Equivalent to contains(set, value)
733             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
734             // the array, and then remove the last element (sometimes called as 'swap and pop').
735             // This modifies the order of the array, as noted in {at}.
736 
737             uint256 toDeleteIndex = valueIndex - 1;
738             uint256 lastIndex = set._values.length - 1;
739 
740             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
741             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
742 
743             bytes32 lastvalue = set._values[lastIndex];
744 
745             // Move the last value to the index where the value to delete is
746             set._values[toDeleteIndex] = lastvalue;
747             // Update the index for the moved value
748             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
749 
750             // Delete the slot where the moved value was stored
751             set._values.pop();
752 
753             // Delete the index for the deleted slot
754             delete set._indexes[value];
755 
756             return true;
757         } else {
758             return false;
759         }
760     }
761 
762     /**
763      * @dev Returns true if the value is in the set. O(1).
764      */
765     function _contains(Set storage set, bytes32 value) private view returns (bool) {
766         return set._indexes[value] != 0;
767     }
768 
769     /**
770      * @dev Returns the number of values on the set. O(1).
771      */
772     function _length(Set storage set) private view returns (uint256) {
773         return set._values.length;
774     }
775 
776    /**
777     * @dev Returns the value stored at position `index` in the set. O(1).
778     *
779     * Note that there are no guarantees on the ordering of values inside the
780     * array, and it may change when more values are added or removed.
781     *
782     * Requirements:
783     *
784     * - `index` must be strictly less than {length}.
785     */
786     function _at(Set storage set, uint256 index) private view returns (bytes32) {
787         require(set._values.length > index, "EnumerableSet: index out of bounds");
788         return set._values[index];
789     }
790 
791     // AddressSet
792 
793     struct AddressSet {
794         Set _inner;
795     }
796 
797     /**
798      * @dev Add a value to a set. O(1).
799      *
800      * Returns true if the value was added to the set, that is if it was not
801      * already present.
802      */
803     function add(AddressSet storage set, address value) internal returns (bool) {
804         return _add(set._inner, bytes32(uint256(value)));
805     }
806 
807     /**
808      * @dev Removes a value from a set. O(1).
809      *
810      * Returns true if the value was removed from the set, that is if it was
811      * present.
812      */
813     function remove(AddressSet storage set, address value) internal returns (bool) {
814         return _remove(set._inner, bytes32(uint256(value)));
815     }
816 
817     /**
818      * @dev Returns true if the value is in the set. O(1).
819      */
820     function contains(AddressSet storage set, address value) internal view returns (bool) {
821         return _contains(set._inner, bytes32(uint256(value)));
822     }
823 
824     /**
825      * @dev Returns the number of values in the set. O(1).
826      */
827     function length(AddressSet storage set) internal view returns (uint256) {
828         return _length(set._inner);
829     }
830 
831    /**
832     * @dev Returns the value stored at position `index` in the set. O(1).
833     *
834     * Note that there are no guarantees on the ordering of values inside the
835     * array, and it may change when more values are added or removed.
836     *
837     * Requirements:
838     *
839     * - `index` must be strictly less than {length}.
840     */
841     function at(AddressSet storage set, uint256 index) internal view returns (address) {
842         return address(uint256(_at(set._inner, index)));
843     }
844 
845 
846     // UintSet
847 
848     struct UintSet {
849         Set _inner;
850     }
851 
852     /**
853      * @dev Add a value to a set. O(1).
854      *
855      * Returns true if the value was added to the set, that is if it was not
856      * already present.
857      */
858     function add(UintSet storage set, uint256 value) internal returns (bool) {
859         return _add(set._inner, bytes32(value));
860     }
861 
862     /**
863      * @dev Removes a value from a set. O(1).
864      *
865      * Returns true if the value was removed from the set, that is if it was
866      * present.
867      */
868     function remove(UintSet storage set, uint256 value) internal returns (bool) {
869         return _remove(set._inner, bytes32(value));
870     }
871 
872     /**
873      * @dev Returns true if the value is in the set. O(1).
874      */
875     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
876         return _contains(set._inner, bytes32(value));
877     }
878 
879     /**
880      * @dev Returns the number of values on the set. O(1).
881      */
882     function length(UintSet storage set) internal view returns (uint256) {
883         return _length(set._inner);
884     }
885 
886    /**
887     * @dev Returns the value stored at position `index` in the set. O(1).
888     *
889     * Note that there are no guarantees on the ordering of values inside the
890     * array, and it may change when more values are added or removed.
891     *
892     * Requirements:
893     *
894     * - `index` must be strictly less than {length}.
895     */
896     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
897         return uint256(_at(set._inner, index));
898     }
899 }
900 
901 // File: @openzeppelin/contracts/introspection/IERC1820Registry.sol
902 
903 // SPDX-License-Identifier: MIT
904 
905 pragma solidity ^0.6.0;
906 
907 /**
908  * @dev Interface of the global ERC1820 Registry, as defined in the
909  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
910  * implementers for interfaces in this registry, as well as query support.
911  *
912  * Implementers may be shared by multiple accounts, and can also implement more
913  * than a single interface for each account. Contracts can implement interfaces
914  * for themselves, but externally-owned accounts (EOA) must delegate this to a
915  * contract.
916  *
917  * {IERC165} interfaces can also be queried via the registry.
918  *
919  * For an in-depth explanation and source code analysis, see the EIP text.
920  */
921 interface IERC1820Registry {
922     /**
923      * @dev Sets `newManager` as the manager for `account`. A manager of an
924      * account is able to set interface implementers for it.
925      *
926      * By default, each account is its own manager. Passing a value of `0x0` in
927      * `newManager` will reset the manager to this initial state.
928      *
929      * Emits a {ManagerChanged} event.
930      *
931      * Requirements:
932      *
933      * - the caller must be the current manager for `account`.
934      */
935     function setManager(address account, address newManager) external;
936 
937     /**
938      * @dev Returns the manager for `account`.
939      *
940      * See {setManager}.
941      */
942     function getManager(address account) external view returns (address);
943 
944     /**
945      * @dev Sets the `implementer` contract as ``account``'s implementer for
946      * `interfaceHash`.
947      *
948      * `account` being the zero address is an alias for the caller's address.
949      * The zero address can also be used in `implementer` to remove an old one.
950      *
951      * See {interfaceHash} to learn how these are created.
952      *
953      * Emits an {InterfaceImplementerSet} event.
954      *
955      * Requirements:
956      *
957      * - the caller must be the current manager for `account`.
958      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
959      * end in 28 zeroes).
960      * - `implementer` must implement {IERC1820Implementer} and return true when
961      * queried for support, unless `implementer` is the caller. See
962      * {IERC1820Implementer-canImplementInterfaceForAddress}.
963      */
964     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
965 
966     /**
967      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
968      * implementer is registered, returns the zero address.
969      *
970      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
971      * zeroes), `account` will be queried for support of it.
972      *
973      * `account` being the zero address is an alias for the caller's address.
974      */
975     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
976 
977     /**
978      * @dev Returns the interface hash for an `interfaceName`, as defined in the
979      * corresponding
980      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
981      */
982     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
983 
984     /**
985      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
986      *  @param account Address of the contract for which to update the cache.
987      *  @param interfaceId ERC165 interface for which to update the cache.
988      */
989     function updateERC165Cache(address account, bytes4 interfaceId) external;
990 
991     /**
992      *  @notice Checks whether a contract implements an ERC165 interface or not.
993      *  If the result is not cached a direct lookup on the contract address is performed.
994      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
995      *  {updateERC165Cache} with the contract address.
996      *  @param account Address of the contract to check.
997      *  @param interfaceId ERC165 interface to check.
998      *  @return True if `account` implements `interfaceId`, false otherwise.
999      */
1000     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
1001 
1002     /**
1003      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
1004      *  @param account Address of the contract to check.
1005      *  @param interfaceId ERC165 interface to check.
1006      *  @return True if `account` implements `interfaceId`, false otherwise.
1007      */
1008     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
1009 
1010     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
1011 
1012     event ManagerChanged(address indexed account, address indexed newManager);
1013 }
1014 
1015 // File: @openzeppelin/contracts/token/ERC777/IERC777Recipient.sol
1016 
1017 // SPDX-License-Identifier: MIT
1018 
1019 pragma solidity ^0.6.0;
1020 
1021 /**
1022  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
1023  *
1024  * Accounts can be notified of {IERC777} tokens being sent to them by having a
1025  * contract implement this interface (contract holders can be their own
1026  * implementer) and registering it on the
1027  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
1028  *
1029  * See {IERC1820Registry} and {ERC1820Implementer}.
1030  */
1031 interface IERC777Recipient {
1032     /**
1033      * @dev Called by an {IERC777} token contract whenever tokens are being
1034      * moved or created into a registered account (`to`). The type of operation
1035      * is conveyed by `from` being the zero address or not.
1036      *
1037      * This call occurs _after_ the token contract's state is updated, so
1038      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
1039      *
1040      * This function may revert to prevent the operation from being executed.
1041      */
1042     function tokensReceived(
1043         address operator,
1044         address from,
1045         address to,
1046         uint256 amount,
1047         bytes calldata userData,
1048         bytes calldata operatorData
1049     ) external;
1050 }
1051 
1052 // File: contracts/IWETH.sol
1053 
1054 pragma solidity ^0.6.0;
1055 
1056 interface IWETH {
1057   function deposit() external payable;
1058   function transfer(address to, uint value) external returns (bool);
1059   function withdraw(uint) external;
1060   function balanceOf(address who) external view returns (uint256);
1061   function approve(address spender, uint256 amount) external returns (bool);
1062   function allowance(address owner, address spender) external returns (uint256);
1063 }
1064 
1065 // File: contracts/AbstractOwnable.sol
1066 
1067 pragma solidity ^0.6.0;
1068 
1069 abstract contract AbstractOwnable {
1070 
1071   modifier onlyOwner() {
1072     require(_owner() == msg.sender, "caller is not the owner");
1073     _;
1074   }
1075 
1076   function _owner() internal virtual returns(address);
1077 
1078 }
1079 
1080 // File: contracts/Withdrawable.sol
1081 
1082 pragma solidity >=0.4.24;
1083 
1084 
1085 
1086 
1087 abstract contract Withdrawable is AbstractOwnable {
1088   using SafeERC20 for IERC20;
1089   address constant ETHER = address(0);
1090 
1091   event LogWithdrawToken(
1092     address indexed _from,
1093     address indexed _token,
1094     uint amount
1095   );
1096 
1097   /**
1098    * @dev Withdraw asset.
1099    * @param asset Asset to be withdrawn.
1100    */
1101   function adminWithdraw(address asset) public onlyOwner {
1102     uint tokenBalance = adminWithdrawAllowed(asset);
1103     require(tokenBalance > 0, "admin witdraw not allowed");
1104     _withdraw(asset, tokenBalance);
1105   }
1106 
1107   function _withdraw(address _tokenAddress, uint _amount) internal {
1108     if (_tokenAddress == ETHER) {
1109       msg.sender.transfer(_amount);
1110     } else {
1111       IERC20(_tokenAddress).safeTransfer(msg.sender, _amount);
1112     }
1113     emit LogWithdrawToken(msg.sender, _tokenAddress, _amount);
1114   }
1115 
1116   // can be overridden to disallow withdraw for some token
1117   function adminWithdrawAllowed(address asset) internal virtual view returns(uint allowedAmount) {
1118     allowedAmount = asset == ETHER
1119       ? address(this).balance
1120       : IERC20(asset).balanceOf(address(this));
1121   }
1122 }
1123 
1124 // File: contracts/Erc20Vault.sol
1125 
1126 pragma solidity ^0.6.0;
1127 
1128 
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 contract Erc20Vault is Withdrawable, IERC777Recipient {
1137     using SafeERC20 for IERC20;
1138     using EnumerableSet for EnumerableSet.AddressSet;
1139 
1140     IERC1820Registry constant private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
1141     bytes32 constant private TOKENS_RECIPIENT_INTERFACE_HASH = keccak256("ERC777TokensRecipient");
1142     bytes32 constant private ERC777_TOKEN_INTERFACE_HASH = keccak256("ERC777Token");
1143 
1144     EnumerableSet.AddressSet private supportedTokens;
1145     address public PNETWORK;
1146     IWETH public weth;
1147 
1148     event PegIn(
1149         address _tokenAddress,
1150         address _tokenSender,
1151         uint256 _tokenAmount,
1152         string _destinationAddress,
1153         bytes _userData
1154     );
1155 
1156     constructor(
1157         address _weth,
1158         address [] memory _tokensToSupport
1159     ) public {
1160         PNETWORK = msg.sender;
1161         for (uint256 i = 0; i < _tokensToSupport.length; i++) {
1162             supportedTokens.add(_tokensToSupport[i]);
1163         }
1164         weth = IWETH(_weth);
1165         _erc1820.setInterfaceImplementer(address(this), TOKENS_RECIPIENT_INTERFACE_HASH, address(this));
1166     }
1167 
1168     modifier onlyPNetwork() {
1169         require(msg.sender == PNETWORK, "Caller must be PNETWORK address!");
1170         _;
1171     }
1172 
1173     receive() external payable {
1174         require(msg.sender == address(weth));
1175     }
1176 
1177     function setWeth(address _weth) external onlyPNetwork {
1178         weth = IWETH(_weth);
1179     }
1180 
1181     function setPNetwork(address _pnetwork) external onlyPNetwork {
1182         PNETWORK = _pnetwork;
1183     }
1184 
1185     function IS_TOKEN_SUPPORTED(address _token) external view returns(bool) {
1186         return supportedTokens.contains(_token);
1187     }
1188 
1189     function _owner() internal override returns(address) {
1190         return PNETWORK;
1191     }
1192 
1193     function adminWithdrawAllowed(address asset) internal override view returns(uint) {
1194         return supportedTokens.contains(asset) ? 0 : super.adminWithdrawAllowed(asset);
1195     }
1196 
1197     function addSupportedToken(
1198         address _tokenAddress
1199     )
1200         external
1201         onlyPNetwork
1202         returns (bool SUCCESS)
1203     {
1204         supportedTokens.add(_tokenAddress);
1205         return true;
1206     }
1207 
1208     function removeSupportedToken(
1209         address _tokenAddress
1210     )
1211         external
1212         onlyPNetwork
1213         returns (bool SUCCESS)
1214     {
1215         return supportedTokens.remove(_tokenAddress);
1216     }
1217 
1218     function getSupportedTokens() external view returns(address[] memory res) {
1219         res = new address[](supportedTokens.length());
1220         for (uint256 i = 0; i < supportedTokens.length(); i++) {
1221             res[i] = supportedTokens.at(i);
1222         }
1223     }
1224 
1225     function pegIn(
1226         uint256 _tokenAmount,
1227         address _tokenAddress,
1228         string calldata _destinationAddress
1229     )
1230         external
1231         returns (bool)
1232     {
1233         return pegIn(_tokenAmount, _tokenAddress, _destinationAddress, "");
1234     }
1235 
1236     function pegIn(
1237         uint256 _tokenAmount,
1238         address _tokenAddress,
1239         string memory _destinationAddress,
1240         bytes memory _userData
1241     )
1242         public
1243         returns (bool)
1244     {
1245         require(supportedTokens.contains(_tokenAddress), "Token at supplied address is NOT supported!");
1246         require(_tokenAmount > 0, "Token amount must be greater than zero!");
1247         IERC20(_tokenAddress).safeTransferFrom(msg.sender, address(this), _tokenAmount);
1248         emit PegIn(_tokenAddress, msg.sender, _tokenAmount, _destinationAddress, _userData);
1249         return true;
1250     }
1251 
1252     /**
1253      * @dev Implementation of IERC777Recipient.
1254      */
1255     function tokensReceived(
1256         address /*operator*/,
1257         address from,
1258         address to,
1259         uint256 amount,
1260         bytes calldata userData,
1261         bytes calldata /*operatorData*/
1262     ) external override {
1263         address _tokenAddress = msg.sender;
1264         require(supportedTokens.contains(_tokenAddress), "caller is not a supported ERC777 token!");
1265         require(to == address(this), "Token receiver is not this contract");
1266         if (userData.length > 0) {
1267             require(amount > 0, "Token amount must be greater than zero!");
1268             (bytes32 tag, string memory _destinationAddress) = abi.decode(userData, (bytes32, string));
1269             require(tag == keccak256("ERC777-pegIn"), "Invalid tag for automatic pegIn on ERC777 send");
1270             emit PegIn(_tokenAddress, from, amount, _destinationAddress, userData);
1271         }
1272     }
1273 
1274     function pegInEth(string calldata _destinationAddress)
1275         external
1276         payable
1277         returns (bool)
1278     {
1279         return pegInEth(_destinationAddress, "");
1280     }
1281 
1282     function pegInEth(
1283         string memory _destinationAddress,
1284         bytes memory _userData
1285     )
1286         public
1287         payable
1288         returns (bool)
1289     {
1290         require(supportedTokens.contains(address(weth)), "WETH is NOT supported!");
1291         require(msg.value > 0, "Ethers amount must be greater than zero!");
1292         weth.deposit.value(msg.value)();
1293         emit PegIn(address(weth), msg.sender, msg.value, _destinationAddress, _userData);
1294         return true;
1295     }
1296 
1297     function pegOutWeth(
1298         address payable _tokenRecipient,
1299         uint256 _tokenAmount,
1300         bytes memory _userData
1301     )
1302         internal
1303         returns (bool)
1304     {
1305         weth.withdraw(_tokenAmount);
1306         // NOTE: This is the latest recommendation (@ time of writing) for transferring ETH. This no longer relies
1307         // on the provided 2300 gas stipend and instead forwards all available gas onwards.
1308         // SOURCE: https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now
1309         (bool success, ) = _tokenRecipient.call.value(_tokenAmount)(_userData);
1310         require(success, "ETH transfer failed when pegging out wETH!");
1311     }
1312 
1313     function pegOut(
1314         address payable _tokenRecipient,
1315         address _tokenAddress,
1316         uint256 _tokenAmount
1317     )
1318         public
1319         onlyPNetwork
1320         returns (bool)
1321     {
1322         if (_tokenAddress == address(weth)) {
1323             pegOutWeth(_tokenRecipient, _tokenAmount, "");
1324         } else {
1325             IERC20(_tokenAddress).safeTransfer(_tokenRecipient, _tokenAmount);
1326         }
1327         return true;
1328     }
1329 
1330     function pegOut(
1331         address payable _tokenRecipient,
1332         address _tokenAddress,
1333         uint256 _tokenAmount,
1334         bytes calldata _userData
1335     )
1336         external
1337         onlyPNetwork
1338         returns (bool)
1339     {
1340         if (_tokenAddress == address(weth)) {
1341             pegOutWeth(_tokenRecipient, _tokenAmount, _userData);
1342         } else {
1343             address erc777Address = _erc1820.getInterfaceImplementer(_tokenAddress, ERC777_TOKEN_INTERFACE_HASH);
1344             if (erc777Address == address(0)) {
1345                 return pegOut(_tokenRecipient, _tokenAddress, _tokenAmount);
1346             } else {
1347                 IERC777(erc777Address).send(_tokenRecipient, _tokenAmount, _userData);
1348                 return true;
1349             }
1350         }
1351     }
1352 
1353     function migrate(
1354         address payable _to
1355     )
1356         external
1357         onlyPNetwork
1358     {
1359         uint256 numberOfTokens = supportedTokens.length();
1360         for (uint256 i = 0; i < numberOfTokens; i++) {
1361             address tokenAddress = supportedTokens.at(0);
1362             _migrateSingle(_to, tokenAddress);
1363         }
1364     }
1365 
1366     function destroy()
1367         external
1368         onlyPNetwork
1369     {
1370         for (uint256 i = 0; i < supportedTokens.length(); i++) {
1371             address tokenAddress = supportedTokens.at(i);
1372             require(IERC20(tokenAddress).balanceOf(address(this)) == 0, "Balance of supported tokens must be 0");
1373         }
1374         selfdestruct(msg.sender);
1375     }
1376 
1377     function migrateSingle(
1378         address payable _to,
1379         address _tokenAddress
1380     )
1381         external
1382         onlyPNetwork
1383     {
1384         _migrateSingle(_to, _tokenAddress);
1385     }
1386 
1387     function _migrateSingle(
1388         address payable _to,
1389         address _tokenAddress
1390     )
1391         private
1392     {
1393         if (supportedTokens.contains(_tokenAddress)) {
1394             uint balance = IERC20(_tokenAddress).balanceOf(address(this));
1395             IERC20(_tokenAddress).safeTransfer(_to, balance);
1396             supportedTokens.remove(_tokenAddress);
1397         }
1398     }
1399 }