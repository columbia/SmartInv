1 // File: contracts/lib/oracle/AggregatorV3Interface.sol
2 
3 // SPDX-License-Identifier: No License
4 pragma solidity >=0.6.0;
5 
6 interface AggregatorV3Interface {
7 
8   function decimals() external view returns (uint8);
9   function description() external view returns (string memory);
10   function version() external view returns (uint256);
11 
12   // getRoundData and latestRoundData should both raise "No data present"
13   // if they do not have data to report, instead of returning unset values
14   // which could be misinterpreted as actual reported values.
15   function getRoundData(uint80 _roundId)
16     external
17     view
18     returns (
19       uint80 roundId,
20       int256 answer,
21       uint256 startedAt,
22       uint256 updatedAt,
23       uint80 answeredInRound
24     );
25   function latestRoundData()
26     external
27     view
28     returns (
29       uint80 roundId,
30       int256 answer,
31       uint256 startedAt,
32       uint256 updatedAt,
33       uint80 answeredInRound
34     );
35 
36 }
37 
38 // File: contracts/lib/math/SafeMath.sol
39 
40 
41 
42 pragma solidity >=0.6.0 <0.8.0;
43 
44 /**
45  * @dev Wrappers over Solidity's arithmetic operations with added overflow
46  * checks.
47  *
48  * Arithmetic operations in Solidity wrap on overflow. This can easily result
49  * in bugs, because programmers usually assume that an overflow raises an
50  * error, which is the standard behavior in high level programming languages.
51  * `SafeMath` restores this intuition by reverting the transaction when an
52  * operation overflows.
53  *
54  * Using this library instead of the unchecked operations eliminates an entire
55  * class of bugs, so it's recommended to use it always.
56  */
57 library SafeMath {
58     /**
59      * @dev Returns the addition of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `+` operator.
63      *
64      * Requirements:
65      *
66      * - Addition cannot overflow.
67      */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      *
83      * - Subtraction cannot overflow.
84      */
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         return sub(a, b, "SafeMath: subtraction overflow");
87     }
88 
89     /**
90      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
91      * overflow (when the result is negative).
92      *
93      * Counterpart to Solidity's `-` operator.
94      *
95      * Requirements:
96      *
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118         // benefit is lost if 'b' is also tested.
119         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120         if (a == 0) {
121             return 0;
122         }
123 
124         uint256 c = a * b;
125         require(c / a == b, "SafeMath: multiplication overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers. Reverts on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b) internal pure returns (uint256) {
143         return div(a, b, "SafeMath: division by zero");
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b > 0, errorMessage);
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         return mod(a, b, "SafeMath: modulo by zero");
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts with custom message when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b != 0, errorMessage);
196         return a % b;
197     }
198 }
199 
200 // File: contracts/lib/token/IERC20.sol
201 
202 
203 
204 pragma solidity >=0.6.0 <0.8.0;
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `recipient`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `sender` to `recipient` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Emitted when `value` tokens are moved from one account (`from`) to
267      * another (`to`).
268      *
269      * Note that `value` may be zero.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     /**
274      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
275      * a call to {approve}. `value` is the new allowance.
276      */
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 // File: contracts/lib/utils/Address.sol
281 
282 
283 
284 pragma solidity >=0.6.2 <0.8.0;
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize, which returns 0 for contracts in
309         // construction, since the code is only stored at the end of the
310         // constructor execution.
311 
312         uint256 size;
313         // solhint-disable-next-line no-inline-assembly
314         assembly { size := extcodesize(account) }
315         return size > 0;
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(address(this).balance >= amount, "Address: insufficient balance");
336 
337         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
338         (bool success, ) = recipient.call{ value: amount }("");
339         require(success, "Address: unable to send value, recipient may have reverted");
340     }
341 
342     /**
343      * @dev Performs a Solidity function call using a low level `call`. A
344      * plain`call` is an unsafe replacement for a function call: use this
345      * function instead.
346      *
347      * If `target` reverts with a revert reason, it is bubbled up by this
348      * function (like regular Solidity function calls).
349      *
350      * Returns the raw returned data. To convert to the expected return value,
351      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
352      *
353      * Requirements:
354      *
355      * - `target` must be a contract.
356      * - calling `target` with `data` must not revert.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
361       return functionCall(target, data, "Address: low-level call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
366      * `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
386         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
391      * with `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
396         require(address(this).balance >= value, "Address: insufficient balance for call");
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: value }(data);
401         return _verifyCallResult(success, returndata, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
411         return functionStaticCall(target, data, "Address: low-level static call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
421         require(isContract(target), "Address: static call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.staticcall(data);
425         return _verifyCallResult(success, returndata, errorMessage);
426     }
427 
428     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
429         if (success) {
430             return returndata;
431         } else {
432             // Look for revert reason and bubble it up if present
433             if (returndata.length > 0) {
434                 // The easiest way to bubble the revert reason is using memory via assembly
435 
436                 // solhint-disable-next-line no-inline-assembly
437                 assembly {
438                     let returndata_size := mload(returndata)
439                     revert(add(32, returndata), returndata_size)
440                 }
441             } else {
442                 revert(errorMessage);
443             }
444         }
445     }
446 }
447 
448 // File: contracts/lib/token/SafeERC20.sol
449 
450 
451 
452 pragma solidity >=0.6.0 <0.8.0;
453 
454 
455 
456 
457 /**
458  * @title SafeERC20
459  * @dev Wrappers around ERC20 operations that throw on failure (when the token
460  * contract returns false). Tokens that return no value (and instead revert or
461  * throw on failure) are also supported, non-reverting calls are assumed to be
462  * successful.
463  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
464  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
465  */
466 library SafeERC20 {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     function safeTransfer(IERC20 token, address to, uint256 value) internal {
471         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
472     }
473 
474     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
475         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
476     }
477 
478     /**
479      * @dev Deprecated. This function has issues similar to the ones found in
480      * {IERC20-approve}, and its usage is discouraged.
481      *
482      * Whenever possible, use {safeIncreaseAllowance} and
483      * {safeDecreaseAllowance} instead.
484      */
485     function safeApprove(IERC20 token, address spender, uint256 value) internal {
486         // safeApprove should only be called when setting an initial allowance,
487         // or when resetting it to zero. To increase and decrease it, use
488         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
489         // solhint-disable-next-line max-line-length
490         require((value == 0) || (token.allowance(address(this), spender) == 0),
491             "SafeERC20: approve from non-zero to non-zero allowance"
492         );
493         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
494     }
495 
496     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
497         uint256 newAllowance = token.allowance(address(this), spender).add(value);
498         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
499     }
500 
501     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
502         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
503         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
504     }
505 
506     /**
507      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
508      * on the return value: the return value is optional (but if data is returned, it must not be false).
509      * @param token The token targeted by the call.
510      * @param data The call data (encoded using abi.encode or one of its variants).
511      */
512     function _callOptionalReturn(IERC20 token, bytes memory data) private {
513         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
514         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
515         // the target address contains contract code and also asserts for success in the low-level call.
516 
517         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
518         if (returndata.length > 0) { // Return data is optional
519             // solhint-disable-next-line max-line-length
520             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
521         }
522     }
523 }
524 
525 // File: contracts/lib/utils/ReentrancyGuard.sol
526 
527 
528 
529 pragma solidity >=0.6.0 <0.8.0;
530 
531 /**
532  * @dev Contract module that helps prevent reentrant calls to a function.
533  *
534  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
535  * available, which can be applied to functions to make sure there are no nested
536  * (reentrant) calls to them.
537  *
538  * Note that because there is a single `nonReentrant` guard, functions marked as
539  * `nonReentrant` may not call one another. This can be worked around by making
540  * those functions `private`, and then adding `external` `nonReentrant` entry
541  * points to them.
542  *
543  * TIP: If you would like to learn more about reentrancy and alternative ways
544  * to protect against it, check out our blog post
545  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
546  */
547 abstract contract ReentrancyGuard {
548     // Booleans are more expensive than uint256 or any type that takes up a full
549     // word because each write operation emits an extra SLOAD to first read the
550     // slot's contents, replace the bits taken up by the boolean, and then write
551     // back. This is the compiler's defense against contract upgrades and
552     // pointer aliasing, and it cannot be disabled.
553 
554     // The values being non-zero value makes deployment a bit more expensive,
555     // but in exchange the refund on every call to nonReentrant will be lower in
556     // amount. Since refunds are capped to a percentage of the total
557     // transaction's gas, it is best to keep them low in cases like this one, to
558     // increase the likelihood of the full refund coming into effect.
559     uint256 private constant _NOT_ENTERED = 1;
560     uint256 private constant _ENTERED = 2;
561 
562     uint256 private _status;
563 
564     constructor () internal {
565         _status = _NOT_ENTERED;
566     }
567 
568     /**
569      * @dev Prevents a contract from calling itself, directly or indirectly.
570      * Calling a `nonReentrant` function from another `nonReentrant`
571      * function is not supported. It is possible to prevent this from happening
572      * by making the `nonReentrant` function external, and make it call a
573      * `private` function that does the actual work.
574      */
575     modifier nonReentrant() {
576         // On the first call to nonReentrant, _notEntered will be true
577         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
578 
579         // Any calls to nonReentrant after this point will fail
580         _status = _ENTERED;
581 
582         _;
583 
584         // By storing the original value once again, a refund is triggered (see
585         // https://eips.ethereum.org/EIPS/eip-2200)
586         _status = _NOT_ENTERED;
587     }
588 }
589 
590 // File: contracts/lib/GSN/Context.sol
591 
592 
593 
594 pragma solidity >=0.6.0 <0.8.0;
595 
596 /*
597  * @dev Provides information about the current execution context, including the
598  * sender of the transaction and its data. While these are generally available
599  * via msg.sender and msg.data, they should not be accessed in such a direct
600  * manner, since when dealing with GSN meta-transactions the account sending and
601  * paying for execution may not be the actual sender (as far as an application
602  * is concerned).
603  *
604  * This contract is only required for intermediate, library-like contracts.
605  */
606 abstract contract Context {
607     function _msgSender() internal view virtual returns (address payable) {
608         return msg.sender;
609     }
610 
611     function _msgData() internal view virtual returns (bytes memory) {
612         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
613         return msg.data;
614     }
615 }
616 
617 // File: contracts/lib/token/ERC20.sol
618 
619 
620 
621 pragma solidity >=0.6.0 <0.8.0;
622 
623 
624 
625 
626 /**
627  * @dev Implementation of the {IERC20} interface.
628  *
629  * This implementation is agnostic to the way tokens are created. This means
630  * that a supply mechanism has to be added in a derived contract using {_mint}.
631  * For a generic mechanism see {ERC20PresetMinterPauser}.
632  *
633  * TIP: For a detailed writeup see our guide
634  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
635  * to implement supply mechanisms].
636  *
637  * We have followed general OpenZeppelin guidelines: functions revert instead
638  * of returning `false` on failure. This behavior is nonetheless conventional
639  * and does not conflict with the expectations of ERC20 applications.
640  *
641  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
642  * This allows applications to reconstruct the allowance for all accounts just
643  * by listening to said events. Other implementations of the EIP may not emit
644  * these events, as it isn't required by the specification.
645  *
646  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
647  * functions have been added to mitigate the well-known issues around setting
648  * allowances. See {IERC20-approve}.
649  */
650 contract ERC20 is Context, IERC20 {
651     using SafeMath for uint256;
652 
653     mapping (address => uint256) private _balances;
654 
655     mapping (address => mapping (address => uint256)) private _allowances;
656 
657     uint256 private _totalSupply;
658 
659     string private _name;
660     string private _symbol;
661     uint8 private _decimals;
662 
663     /**
664      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
665      * a default value of 18.
666      *
667      * To select a different value for {decimals}, use {_setupDecimals}.
668      *
669      * All three of these values are immutable: they can only be set once during
670      * construction.
671      */
672     constructor (string memory name_, string memory symbol_) public {
673         _name = name_;
674         _symbol = symbol_;
675         _decimals = 18;
676     }
677 
678     /**
679      * @dev Returns the name of the token.
680      */
681     function name() public view returns (string memory) {
682         return _name;
683     }
684 
685     /**
686      * @dev Returns the symbol of the token, usually a shorter version of the
687      * name.
688      */
689     function symbol() public view returns (string memory) {
690         return _symbol;
691     }
692 
693     /**
694      * @dev Returns the number of decimals used to get its user representation.
695      * For example, if `decimals` equals `2`, a balance of `505` tokens should
696      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
697      *
698      * Tokens usually opt for a value of 18, imitating the relationship between
699      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
700      * called.
701      *
702      * NOTE: This information is only used for _display_ purposes: it in
703      * no way affects any of the arithmetic of the contract, including
704      * {IERC20-balanceOf} and {IERC20-transfer}.
705      */
706     function decimals() public view returns (uint8) {
707         return _decimals;
708     }
709 
710     /**
711      * @dev See {IERC20-totalSupply}.
712      */
713     function totalSupply() public view override virtual returns (uint256) {
714         return _totalSupply;
715     }
716 
717     /**
718      * @dev See {IERC20-balanceOf}.
719      */
720     function balanceOf(address account) public view override virtual returns (uint256) {
721         return _balances[account];
722     }
723 
724     /**
725      * @dev See {IERC20-transfer}.
726      *
727      * Requirements:
728      *
729      * - `recipient` cannot be the zero address.
730      * - the caller must have a balance of at least `amount`.
731      */
732     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
733         _transfer(_msgSender(), recipient, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-allowance}.
739      */
740     function allowance(address owner, address spender) public view virtual override returns (uint256) {
741         return _allowances[owner][spender];
742     }
743 
744     /**
745      * @dev See {IERC20-approve}.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      */
751     function approve(address spender, uint256 amount) public virtual override returns (bool) {
752         _approve(_msgSender(), spender, amount);
753         return true;
754     }
755 
756     /**
757      * @dev See {IERC20-transferFrom}.
758      *
759      * Emits an {Approval} event indicating the updated allowance. This is not
760      * required by the EIP. See the note at the beginning of {ERC20}.
761      *
762      * Requirements:
763      *
764      * - `sender` and `recipient` cannot be the zero address.
765      * - `sender` must have a balance of at least `amount`.
766      * - the caller must have allowance for ``sender``'s tokens of at least
767      * `amount`.
768      */
769     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
770         _transfer(sender, recipient, amount);
771         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
772         return true;
773     }
774 
775     /**
776      * @dev Atomically increases the allowance granted to `spender` by the caller.
777      *
778      * This is an alternative to {approve} that can be used as a mitigation for
779      * problems described in {IERC20-approve}.
780      *
781      * Emits an {Approval} event indicating the updated allowance.
782      *
783      * Requirements:
784      *
785      * - `spender` cannot be the zero address.
786      */
787     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
788         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
789         return true;
790     }
791 
792     /**
793      * @dev Atomically decreases the allowance granted to `spender` by the caller.
794      *
795      * This is an alternative to {approve} that can be used as a mitigation for
796      * problems described in {IERC20-approve}.
797      *
798      * Emits an {Approval} event indicating the updated allowance.
799      *
800      * Requirements:
801      *
802      * - `spender` cannot be the zero address.
803      * - `spender` must have allowance for the caller of at least
804      * `subtractedValue`.
805      */
806     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
807         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
808         return true;
809     }
810 
811     /**
812      * @dev Moves tokens `amount` from `sender` to `recipient`.
813      *
814      * This is internal function is equivalent to {transfer}, and can be used to
815      * e.g. implement automatic token fees, slashing mechanisms, etc.
816      *
817      * Emits a {Transfer} event.
818      *
819      * Requirements:
820      *
821      * - `sender` cannot be the zero address.
822      * - `recipient` cannot be the zero address.
823      * - `sender` must have a balance of at least `amount`.
824      */
825     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
826         require(sender != address(0), "ERC20: transfer from the zero address");
827         require(recipient != address(0), "ERC20: transfer to the zero address");
828 
829         _beforeTokenTransfer(sender, recipient, amount);
830 
831         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
832         _balances[recipient] = _balances[recipient].add(amount);
833         emit Transfer(sender, recipient, amount);
834     }
835 
836     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
837      * the total supply.
838      *
839      * Emits a {Transfer} event with `from` set to the zero address.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      */
845     function _mint(address account, uint256 amount) internal virtual {
846         require(account != address(0), "ERC20: mint to the zero address");
847 
848         _beforeTokenTransfer(address(0), account, amount);
849 
850         _totalSupply = _totalSupply.add(amount);
851         _balances[account] = _balances[account].add(amount);
852         emit Transfer(address(0), account, amount);
853     }
854 
855     /**
856      * @dev Destroys `amount` tokens from `account`, reducing the
857      * total supply.
858      *
859      * Emits a {Transfer} event with `to` set to the zero address.
860      *
861      * Requirements:
862      *
863      * - `account` cannot be the zero address.
864      * - `account` must have at least `amount` tokens.
865      */
866     function _burn(address account, uint256 amount) internal virtual {
867         require(account != address(0), "ERC20: burn from the zero address");
868 
869         _beforeTokenTransfer(account, address(0), amount);
870 
871         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
872         _totalSupply = _totalSupply.sub(amount);
873         emit Transfer(account, address(0), amount);
874     }
875 
876     /**
877      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
878      *
879      * This internal function is equivalent to `approve`, and can be used to
880      * e.g. set automatic allowances for certain subsystems, etc.
881      *
882      * Emits an {Approval} event.
883      *
884      * Requirements:
885      *
886      * - `owner` cannot be the zero address.
887      * - `spender` cannot be the zero address.
888      */
889     function _approve(address owner, address spender, uint256 amount) internal virtual {
890         require(owner != address(0), "ERC20: approve from the zero address");
891         require(spender != address(0), "ERC20: approve to the zero address");
892 
893         _allowances[owner][spender] = amount;
894         emit Approval(owner, spender, amount);
895     }
896 
897     /**
898      * @dev Sets {decimals} to a value other than the default one of 18.
899      *
900      * WARNING: This function should only be called from the constructor. Most
901      * applications that interact with token contracts will not expect
902      * {decimals} to ever change, and may work incorrectly if it does.
903      */
904     function _setupDecimals(uint8 decimals_) internal {
905         _decimals = decimals_;
906     }
907 
908     /**
909      * @dev Hook that is called before any transfer of tokens. This includes
910      * minting and burning.
911      *
912      * Calling conditions:
913      *
914      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
915      * will be to transferred to `to`.
916      * - when `from` is zero, `amount` tokens will be minted for `to`.
917      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
918      * - `from` and `to` are never both zero.
919      *
920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
921      */
922     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
923 }
924 
925 // File: contracts/lib/access/Ownable.sol
926 
927 
928 
929 pragma solidity >=0.6.0 <0.8.0;
930 
931 /**
932  * @dev Contract module which provides a basic access control mechanism, where
933  * there is an account (an owner) that can be granted exclusive access to
934  * specific functions.
935  *
936  * By default, the owner account will be the one that deploys the contract. This
937  * can later be changed with {transferOwnership}.
938  *
939  * This module is used through inheritance. It will make available the modifier
940  * `onlyOwner`, which can be applied to your functions to restrict their use to
941  * the owner.
942  */
943 abstract contract Ownable is Context {
944     address private _owner;
945 
946     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
947 
948     /**
949      * @dev Initializes the contract setting the deployer as the initial owner.
950      */
951     constructor () internal {
952         address msgSender = _msgSender();
953         _owner = msgSender;
954         emit OwnershipTransferred(address(0), msgSender);
955     }
956 
957     /**
958      * @dev Returns the address of the current owner.
959      */
960     function owner() public view returns (address) {
961         return _owner;
962     }
963 
964     /**
965      * @dev Throws if called by any account other than the owner.
966      */
967     modifier onlyOwner() {
968         require(_owner == _msgSender(), "Ownable: caller is not the owner");
969         _;
970     }
971 
972     /**
973      * @dev Leaves the contract without owner. It will not be possible to call
974      * `onlyOwner` functions anymore. Can only be called by the current owner.
975      *
976      * NOTE: Renouncing ownership will leave the contract without an owner,
977      * thereby removing any functionality that is only available to the owner.
978      */
979     function renounceOwnership() public virtual onlyOwner {
980         emit OwnershipTransferred(_owner, address(0));
981         _owner = address(0);
982     }
983 
984     /**
985      * @dev Transfers ownership of the contract to a new account (`newOwner`).
986      * Can only be called by the current owner.
987      */
988     function transferOwnership(address newOwner) public virtual onlyOwner {
989         require(newOwner != address(0), "Ownable: new owner is the zero address");
990         emit OwnershipTransferred(_owner, newOwner);
991         _owner = newOwner;
992     }
993 }
994 
995 // File: contracts/oneWING.sol
996 
997 
998 
999 pragma solidity >=0.6.0;
1000 
1001 
1002 
1003 
1004 
1005 
1006 
1007 // interface for the oneToken
1008 interface OneToken {
1009     function getOneTokenUsd() external view returns (uint256);
1010 }
1011 
1012 // interface for CollateralOracle
1013 interface IOracleInterface {
1014     function getLatestPrice() external view returns (uint256);
1015     function update() external;
1016     function changeInterval(uint256 seconds_) external;
1017     function priceChangeMax(uint256 change_) external;
1018 }
1019 
1020 /// @title An overcollateralized stablecoin using ETH
1021 /// @author Masanobu Fukuoka
1022 contract oneWING is ERC20("oneWING", "oneWING"), Ownable, ReentrancyGuard {
1023     using SafeMath for uint256;
1024 
1025     uint256 public MAX_RESERVE_RATIO; // At 100% reserve ratio, each oneWING is backed 1-to-1 by $1 of existing stable coins
1026     uint256 private constant DECIMALS = 9;
1027     uint256 public lastRefreshReserve; // The last time the reserve ratio was updated by the contract
1028     uint256 public minimumRefreshTime; // The time between reserve ratio refreshes
1029 
1030     address public stimulus; // oneWING builds a stimulus fund in ETH.
1031     uint256 public stimulusDecimals; // used to calculate oracle rate of Uniswap Pair
1032 
1033     address public oneTokenOracle; // oracle for the oneWING stable coin
1034     bool public oneTokenOracleHasUpdate; //if oneWING token oracle requires update
1035     address public stimulusOracle;  // oracle for a stimulus 
1036     bool public stimulusOracleHasUpdate; //if stimulus oracle requires update
1037 
1038     // Only governance should cause the coin to go fully agorithmic by changing the minimum reserve
1039     // ratio.  For now, we will set a conservative minimum reserve ratio.
1040     uint256 public MIN_RESERVE_RATIO;
1041     uint256 public MIN_DELAY;
1042 
1043     // Makes sure that you can't send coins to a 0 address and prevents coins from being sent to the
1044     // contract address. I want to protect your funds!
1045     modifier validRecipient(address to) {
1046         require(to != address(0x0));
1047         require(to != address(this));
1048         _;
1049     }
1050 
1051     uint256 private _totalSupply;
1052     mapping(address => uint256) private _oneBalances;
1053     mapping(address => uint256) private _lastCall;  // used as a record to prevent flash loan attacks
1054     mapping (address => mapping (address => uint256)) private _allowedOne; // allowance to spend one
1055 
1056     address public gov; // who has admin rights over certain functions
1057     address public pendingGov;  // allows you to transfer the governance to a different user - they must accept it!
1058     uint256 public reserveStepSize; // step size of update of reserve rate (e.g. 5 * 10 ** 8 = 0.5%)
1059     uint256 public reserveRatio;    // a number between 0 and 100 * 10 ** 9.
1060                                     // 0 = 0%
1061                                     // 100 * 10 ** 9 = 100%
1062 
1063     // map of acceptable collaterals
1064     mapping (address => bool) public acceptedCollateral;
1065     mapping (address => uint256) public collateralMintFee; // minting fee for different collaterals (100 * 10 ** 9 = 100% fee)
1066     address[] public collateralArray; // array of collateral - used to iterate while updating certain things like oracle intervals for TWAP
1067 
1068     // modifier to allow auto update of TWAP oracle prices
1069     // also updates reserves rate programatically
1070     modifier updateProtocol() {
1071         if (address(oneTokenOracle) != address(0)) {
1072 
1073             // this is always updated because we always need stablecoin oracle price
1074             if (oneTokenOracleHasUpdate) IOracleInterface(oneTokenOracle).update();
1075 
1076             if (stimulusOracleHasUpdate) IOracleInterface(stimulusOracle).update();
1077 
1078             for (uint i = 0; i < collateralArray.length; i++){
1079                 if (acceptedCollateral[collateralArray[i]] && !oneCoinCollateralOracle[collateralArray[i]]) IOracleInterface(collateralOracle[collateralArray[i]]).update();
1080             }
1081 
1082             // update reserve ratio if enough time has passed
1083             if (block.timestamp - lastRefreshReserve >= minimumRefreshTime) {
1084                 // $Z / 1 one token
1085                 if (getOneTokenUsd() > 1 * 10 ** 9) {
1086                     setReserveRatio(reserveRatio.sub(reserveStepSize));
1087                 } else {
1088                     setReserveRatio(reserveRatio.add(reserveStepSize));
1089                 }
1090 
1091                 lastRefreshReserve = block.timestamp;
1092             }
1093         }
1094 
1095         _;
1096     }
1097 
1098     // events for off-chain record keeping
1099     event NewPendingGov(address oldPendingGov, address newPendingGov);
1100     event NewGov(address oldGov, address newGov);
1101     event NewReserveRate(uint256 reserveRatio);
1102     event Mint(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1103     event Withdraw(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1104     event NewMinimumRefreshTime(uint256 minimumRefreshTime);
1105     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data);
1106 
1107     modifier onlyIchiGov() {
1108         require(msg.sender == gov, "ACCESS: only Ichi governance");
1109         _;
1110     }
1111 
1112     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));  // shortcut for calling transfer
1113     mapping (address => uint256) public collateralDecimals;     // needed to be able to convert from different collaterals
1114     mapping (address => bool) public oneCoinCollateralOracle;   // if true, we query the one token contract's usd price
1115     mapping (address => bool) public previouslySeenCollateral;  // used to allow users to withdraw collateral, even if the collateral has since been deprecated
1116                                                                 // previouslySeenCollateral lets the contract know if a collateral has been used before - this also
1117                                                                 // prevents attacks where uses add a custom address as collateral, but that custom address is actually 
1118                                                                 // their own malicious smart contract. Read peckshield blog for more info.
1119     mapping (address => address) public collateralOracle;       // address of the Collateral-ETH Uniswap Price
1120     mapping (address => bool) public collateralOracleHasUpdate; // if collatoral oracle requires an update
1121 
1122     // default to 0
1123     uint256 public mintFee;
1124     uint256 public withdrawFee;
1125 
1126     // fee to charge when minting oneWING - this will go into collateral
1127     event MintFee(uint256 fee_);
1128     // fee to charge when redeeming oneWING - this will go into collateral
1129     event WithdrawFee(uint256 fee_);
1130 
1131     // set governance access to only oneWING - USDC pool multisig (elected after rewards)
1132     modifier oneLPGov() {
1133         require(msg.sender == lpGov, "ACCESS: only oneLP governance");
1134         _;
1135     }
1136 
1137     address public lpGov;
1138     address public pendingLPGov;
1139 
1140     event NewPendingLPGov(address oldPendingLPGov, address newPendingLPGov);
1141     event NewLPGov(address oldLPGov, address newLPGov);
1142     event NewMintFee(address collateral, uint256 oldFee, uint256 newFee);
1143 
1144     mapping (address => uint256) private _burnedStablecoin; // maps user to burned oneWING
1145 
1146     // important: make sure changeInterval is a function to allow the interval of update to change
1147     function addCollateral(address collateral_, uint256 collateralDecimal_, address oracleAddress_, bool oneCoinOracle, bool oracleHasUpdate)
1148         external
1149         oneLPGov
1150     {
1151         // only add collateral once
1152         if (!previouslySeenCollateral[collateral_]) collateralArray.push(collateral_);
1153 
1154         previouslySeenCollateral[collateral_] = true;
1155         acceptedCollateral[collateral_] = true;
1156         oneCoinCollateralOracle[collateral_] = oneCoinOracle;
1157         collateralDecimals[collateral_] = collateralDecimal_;
1158         collateralOracle[collateral_] = oracleAddress_;
1159         collateralMintFee[collateral_] = 0;
1160         collateralOracleHasUpdate[collateral_]= oracleHasUpdate;
1161     }
1162 
1163 
1164     function setCollateralMintFee(address collateral_, uint256 fee_)
1165         external
1166         oneLPGov
1167     {
1168         require(acceptedCollateral[collateral_], "invalid collateral");
1169         require(fee_ <= 100 * 10 ** 9, "Fee must be valid");
1170         emit NewMintFee(collateral_, collateralMintFee[collateral_], fee_);
1171         collateralMintFee[collateral_] = fee_;
1172     }
1173 
1174     // step size = how much the reserve rate updates per update cycle
1175     function setReserveStepSize(uint256 stepSize_)
1176         external
1177         oneLPGov
1178     {
1179         reserveStepSize = stepSize_;
1180     }
1181 
1182     // changes the oracle for a given collaterarl
1183     function setCollateralOracle(address collateral_, address oracleAddress_, bool oneCoinOracle_, bool oracleHasUpdate)
1184         external
1185         oneLPGov
1186     {
1187         require(acceptedCollateral[collateral_], "invalid collateral");
1188         oneCoinCollateralOracle[collateral_] = oneCoinOracle_;
1189         collateralOracle[collateral_] = oracleAddress_;
1190         collateralOracleHasUpdate[collateral_] = oracleHasUpdate;
1191     }
1192 
1193     // removes a collateral from minting. Still allows withdrawals however
1194     function removeCollateral(address collateral_)
1195         external
1196         oneLPGov
1197     {
1198         acceptedCollateral[collateral_] = false;
1199     }
1200 
1201     // used for querying
1202     function getBurnedStablecoin(address _user)
1203         public
1204         view
1205         returns (uint256)
1206     {
1207         return _burnedStablecoin[_user];
1208     }
1209 
1210     // returns 10 ** 9 price of collateral
1211     function getCollateralUsd(address collateral_) public view returns (uint256) {
1212         require(previouslySeenCollateral[collateral_], "must be an existing collateral");
1213 
1214         if (oneCoinCollateralOracle[collateral_]) return OneToken(collateral_).getOneTokenUsd();
1215         
1216         return IOracleInterface(collateralOracle[collateral_]).getLatestPrice();
1217     }
1218 
1219     function globalCollateralValue() public view returns (uint256) {
1220         uint256 totalCollateralUsd = 0;
1221 
1222         for (uint i = 0; i < collateralArray.length; i++){
1223             // Exclude null addresses
1224             if (collateralArray[i] != address(0)){
1225                 totalCollateralUsd += IERC20(collateralArray[i]).balanceOf(address(this)).mul(10 ** 9).div(10 ** collateralDecimals[collateralArray[i]]).mul(getCollateralUsd(collateralArray[i])).div(10 ** 9); // add stablecoin balance
1226             }
1227 
1228         }
1229         return totalCollateralUsd;
1230     }
1231 
1232     // return price of oneWING in 10 ** 9 decimal
1233     function getOneTokenUsd()
1234         public
1235         view
1236         returns (uint256)
1237     {
1238         return IOracleInterface(oneTokenOracle).getLatestPrice();
1239     }
1240 
1241     /**
1242      * @return The total number of oneWING.
1243      */
1244     function totalSupply()
1245         public
1246         override
1247         view
1248         returns (uint256)
1249     {
1250         return _totalSupply;
1251     }
1252 
1253     /**
1254      * @param who The address to query.
1255      * @return The balance of the specified address.
1256      */
1257     function balanceOf(address who)
1258         public
1259         override
1260         view
1261         returns (uint256)
1262     {
1263         return _oneBalances[who];
1264     }
1265 
1266     /**
1267      * @dev Transfer tokens to a specified address.
1268      * @param to The address to transfer to.
1269      * @param value The amount to be transferred.
1270      * @return True on success, false otherwise.
1271      */
1272     function transfer(address to, uint256 value)
1273         public
1274         override
1275         validRecipient(to)
1276         updateProtocol()
1277         returns (bool)
1278     {
1279         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(value);
1280         _oneBalances[to] = _oneBalances[to].add(value);
1281         emit Transfer(msg.sender, to, value);
1282 
1283         return true;
1284     }
1285 
1286     /**
1287      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1288      * @param owner_ The address which owns the funds.
1289      * @param spender The address which will spend the funds.
1290      * @return The number of tokens still available for the spender.
1291      */
1292     function allowance(address owner_, address spender)
1293         public
1294         override
1295         view
1296         returns (uint256)
1297     {
1298         return _allowedOne[owner_][spender];
1299     }
1300 
1301     /**
1302      * @dev Transfer tokens from one address to another.
1303      * @param from The address you want to send tokens from.
1304      * @param to The address you want to transfer to.
1305      * @param value The amount of tokens to be transferred.
1306      */
1307     function transferFrom(address from, address to, uint256 value)
1308         public
1309         override
1310         validRecipient(to)
1311         updateProtocol()
1312         returns (bool)
1313     {
1314         _allowedOne[from][msg.sender] = _allowedOne[from][msg.sender].sub(value);
1315 
1316         _oneBalances[from] = _oneBalances[from].sub(value);
1317         _oneBalances[to] = _oneBalances[to].add(value);
1318         emit Transfer(from, to, value);
1319 
1320         return true;
1321     }
1322 
1323     /**
1324      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1325      * msg.sender. This method is included for ERC20 compatibility.
1326      * increaseAllowance and decreaseAllowance should be used instead.
1327      * Changing an allowance with this method brings the risk that someone may transfer both
1328      * the old and the new allowance - if they are both greater than zero - if a transfer
1329      * transaction is mined before the later approve() call is mined.
1330      *
1331      * @param spender The address which will spend the funds.
1332      * @param value The amount of tokens to be spent.
1333      */
1334     function approve(address spender, uint256 value)
1335         public
1336         override
1337         validRecipient(spender)
1338         updateProtocol()
1339         returns (bool)
1340     {
1341         _allowedOne[msg.sender][spender] = value;
1342         emit Approval(msg.sender, spender, value);
1343         return true;
1344     }
1345 
1346     /**
1347      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1348      * This method should be used instead of approve() to avoid the double approval vulnerability
1349      * described above.
1350      * @param spender The address which will spend the funds.
1351      * @param addedValue The amount of tokens to increase the allowance by.
1352      */
1353     function increaseAllowance(address spender, uint256 addedValue)
1354         public
1355         override
1356         returns (bool)
1357     {
1358         _allowedOne[msg.sender][spender] = _allowedOne[msg.sender][spender].add(addedValue);
1359         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1360         return true;
1361     }
1362 
1363     /**
1364      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1365      *
1366      * @param spender The address which will spend the funds.
1367      * @param subtractedValue The amount of tokens to decrease the allowance by.
1368      */
1369     function decreaseAllowance(address spender, uint256 subtractedValue)
1370         public
1371         override
1372         returns (bool)
1373     {
1374         uint256 oldValue = _allowedOne[msg.sender][spender];
1375         if (subtractedValue >= oldValue) {
1376             _allowedOne[msg.sender][spender] = 0;
1377         } else {
1378             _allowedOne[msg.sender][spender] = oldValue.sub(subtractedValue);
1379         }
1380         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1381         return true;
1382     }
1383 
1384     function setOneTokenOracle(address oracle_, bool hasUpdate)
1385         external
1386         oneLPGov
1387         returns (bool)
1388     {
1389         oneTokenOracle = oracle_;
1390         oneTokenOracleHasUpdate = hasUpdate;
1391 
1392         return true;
1393     }
1394 
1395     function setStimulusOracle(address oracle_, bool hasUpdate)
1396         external
1397         oneLPGov
1398         returns (bool)
1399     {
1400         stimulusOracle = oracle_;
1401         stimulusOracleHasUpdate = hasUpdate;
1402 
1403         return true;
1404     }
1405 
1406     function setStimulusPriceChangeMax(uint256 change_)
1407         external
1408         oneLPGov
1409         returns (bool)
1410     {
1411         IOracleInterface(stimulusOracle).priceChangeMax(change_);
1412 
1413         return true;
1414     }
1415 
1416     // oracle rate is 10 ** 9 decimals
1417     // returns $Z / Stimulus
1418     function getStimulusUSD()
1419         public
1420         view
1421         returns (uint256)
1422     {
1423         return IOracleInterface(stimulusOracle).getLatestPrice();
1424        
1425     }
1426 
1427     // minimum amount of block time (seconds) required for an update in reserve ratio
1428     function setMinimumRefreshTime(uint256 val_)
1429         external
1430         oneLPGov
1431         returns (bool)
1432     {
1433         require(val_ != 0, "minimum refresh time must be valid");
1434 
1435         minimumRefreshTime = val_;
1436 
1437         // change collateral array
1438         for (uint i = 0; i < collateralArray.length; i++){
1439             if (acceptedCollateral[collateralArray[i]] && !oneCoinCollateralOracle[collateralArray[i]] && collateralOracleHasUpdate[collateralArray[i]]) IOracleInterface(collateralOracle[collateralArray[i]]).changeInterval(val_);
1440         }
1441 
1442         if (oneTokenOracleHasUpdate) IOracleInterface(oneTokenOracle).changeInterval(val_);
1443 
1444         if (stimulusOracleHasUpdate) IOracleInterface(stimulusOracle).changeInterval(val_);
1445 
1446         // change all the oracles (collateral, stimulus, oneToken)
1447 
1448         emit NewMinimumRefreshTime(val_);
1449         return true;
1450     }
1451 
1452     constructor(
1453         uint256 reserveRatio_,
1454         address stimulus_,
1455         uint256 stimulusDecimals_
1456     )
1457         public
1458     {
1459         _setupDecimals(uint8(9));
1460         stimulus = stimulus_;
1461         minimumRefreshTime = 3600 * 1; // 1 hour by default
1462         stimulusDecimals = stimulusDecimals_;
1463         reserveStepSize = 2 * 10 ** 8;  // 0.2% by default
1464         MIN_RESERVE_RATIO = 90 * 10 ** 9;
1465         MAX_RESERVE_RATIO = 100 * 10 ** 9;
1466         MIN_DELAY = 3;             // 3 blocks
1467         withdrawFee = 5 * 10 ** 8; // 0.5% fee at first, remains in collateral
1468         gov = msg.sender;
1469         lpGov = msg.sender;
1470         reserveRatio = reserveRatio_;
1471         _totalSupply = 10 ** 9;
1472 
1473         _oneBalances[msg.sender] = 10 ** 9;
1474         emit Transfer(address(0x0), msg.sender, 10 ** 9);
1475     }
1476 
1477     function setMinimumReserveRatio(uint256 val_)
1478         external
1479         oneLPGov
1480     {
1481         MIN_RESERVE_RATIO = val_;
1482         if (MIN_RESERVE_RATIO > reserveRatio) setReserveRatio(MIN_RESERVE_RATIO);
1483     }
1484 
1485     function setMaximumReserveRatio(uint256 val_)
1486         external
1487         oneLPGov
1488     {
1489         MAX_RESERVE_RATIO = val_;
1490         if (MAX_RESERVE_RATIO < reserveRatio) setReserveRatio(MAX_RESERVE_RATIO);
1491     }
1492 
1493     function setMinimumDelay(uint256 val_)
1494         external
1495         oneLPGov
1496     {
1497         MIN_DELAY = val_;
1498     }
1499 
1500     // LP pool governance ====================================
1501     function setPendingLPGov(address pendingLPGov_)
1502         external
1503         oneLPGov
1504     {
1505         address oldPendingLPGov = pendingLPGov;
1506         pendingLPGov = pendingLPGov_;
1507         emit NewPendingLPGov(oldPendingLPGov, pendingLPGov_);
1508     }
1509 
1510     function acceptLPGov()
1511         external
1512     {
1513         require(msg.sender == pendingLPGov, "!pending");
1514         address oldLPGov = lpGov; // that
1515         lpGov = pendingLPGov;
1516         pendingLPGov = address(0);
1517         emit NewGov(oldLPGov, lpGov);
1518     }
1519 
1520     // over-arching protocol level governance  ===============
1521     function setPendingGov(address pendingGov_)
1522         external
1523         onlyIchiGov
1524     {
1525         address oldPendingGov = pendingGov;
1526         pendingGov = pendingGov_;
1527         emit NewPendingGov(oldPendingGov, pendingGov_);
1528     }
1529 
1530     function acceptGov()
1531         external
1532     {
1533         require(msg.sender == pendingGov, "!pending");
1534         address oldGov = gov;
1535         gov = pendingGov;
1536         pendingGov = address(0);
1537         emit NewGov(oldGov, gov);
1538     }
1539     // ======================================================
1540 
1541     // calculates how much you will need to send in order to mint oneWING, depending on current market prices + reserve ratio
1542     // oneAmount: the amount of oneWING you want to mint
1543     // collateral: the collateral you want to use to pay
1544     // also works in the reverse direction, i.e. how much collateral + stimulus to receive when you burn One
1545     function consultOneDeposit(uint256 oneAmount, address collateral)
1546         public
1547         view
1548         returns (uint256, uint256)
1549     {
1550         require(oneAmount != 0, "must use valid oneAmount");
1551         require(acceptedCollateral[collateral], "must be an accepted collateral");
1552 
1553         uint256 stimulusUsd = getStimulusUSD();     // 10 ** 9
1554 
1555         if (stimulusUsd == 0) {  //price variance too big mint at 100% reserve ratio
1556             uint256 n_collateralAmount = oneAmount.mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1557             n_collateralAmount = n_collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1558             return (n_collateralAmount, 0);
1559         }
1560 
1561         // convert to correct decimals for collateral
1562         uint256 collateralAmount = oneAmount.mul(reserveRatio).div(MAX_RESERVE_RATIO).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1563         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1564 
1565         if (address(oneTokenOracle) == address(0)) return (collateralAmount, 0);
1566 
1567         uint256 stimulusAmountInOneStablecoin = oneAmount.mul(MAX_RESERVE_RATIO.sub(reserveRatio)).div(MAX_RESERVE_RATIO);
1568 
1569         uint256 stimulusAmount = stimulusAmountInOneStablecoin.mul(10 ** 9).div(stimulusUsd).mul(10 ** stimulusDecimals).div(10 ** DECIMALS); // must be 10 ** stimulusDecimals
1570 
1571         return (collateralAmount, stimulusAmount);
1572     }
1573 
1574     function consultOneWithdraw(uint256 oneAmount, address collateral)
1575         public
1576         view
1577         returns (uint256, uint256)
1578     {
1579         require(oneAmount != 0, "must use valid oneAmount");
1580         require(previouslySeenCollateral[collateral], "must be an accepted collateral");
1581 
1582         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1583         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1584 
1585         return (collateralAmount, 0);
1586     }
1587 
1588     // @title: deposit collateral + stimulus token
1589     // collateral: address of the collateral to deposit (USDC, DAI, TUSD, etc)
1590     function mint(
1591         uint256 oneAmount,
1592         address collateral
1593     )
1594         public
1595         payable
1596         nonReentrant
1597         updateProtocol()
1598     {
1599         require(acceptedCollateral[collateral], "must be an accepted collateral");
1600         require(oneAmount != 0, "must mint non-zero amount");
1601 
1602         // wait 3 blocks to avoid flash loans
1603         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few more blocks");
1604 
1605         // validate input amounts are correct
1606         (uint256 collateralAmount, uint256 stimulusAmount) = consultOneDeposit(oneAmount, collateral);
1607         require(collateralAmount <= IERC20(collateral).balanceOf(msg.sender), "sender has insufficient collateral balance");
1608         require(stimulusAmount <= IERC20(stimulus).balanceOf(msg.sender), "sender has insufficient stimulus balance");
1609 
1610         // checks passed, so transfer tokens
1611         SafeERC20.safeTransferFrom(IERC20(collateral), msg.sender, address(this), collateralAmount);
1612         SafeERC20.safeTransferFrom(IERC20(stimulus), msg.sender, address(this), stimulusAmount);
1613 
1614         oneAmount = oneAmount.sub(oneAmount.mul(mintFee).div(100 * 10 ** DECIMALS));                            // apply mint fee
1615         oneAmount = oneAmount.sub(oneAmount.mul(collateralMintFee[collateral]).div(100 * 10 ** DECIMALS));      // apply collateral fee
1616 
1617         _totalSupply = _totalSupply.add(oneAmount);
1618         _oneBalances[msg.sender] = _oneBalances[msg.sender].add(oneAmount);
1619 
1620         emit Transfer(address(0x0), msg.sender, oneAmount);
1621 
1622         _lastCall[msg.sender] = block.number;
1623 
1624         emit Mint(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
1625     }
1626 
1627     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1628     function editMintFee(uint256 fee_)
1629         external
1630         onlyIchiGov
1631     {
1632         require(fee_ <= 100 * 10 ** 9, "Fee must be valid");
1633         mintFee = fee_;
1634         emit MintFee(fee_);
1635     }
1636 
1637     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1638     function editWithdrawFee(uint256 fee_)
1639         external
1640         onlyIchiGov
1641     {
1642         withdrawFee = fee_;
1643         emit WithdrawFee(fee_);
1644     }
1645 
1646     /// burns stablecoin and increments _burnedStablecoin mapping for user
1647     ///         user can claim collateral in a 2nd step below
1648     function withdraw(
1649         uint256 oneAmount,
1650         address collateral
1651     )
1652         public
1653         nonReentrant
1654         updateProtocol()
1655     {
1656         require(oneAmount != 0, "must withdraw non-zero amount");
1657         require(oneAmount <= _oneBalances[msg.sender], "insufficient balance");
1658         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1659         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1660 
1661         // burn oneAmount
1662         _totalSupply = _totalSupply.sub(oneAmount);
1663         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(oneAmount);
1664 
1665         _burnedStablecoin[msg.sender] = _burnedStablecoin[msg.sender].add(oneAmount);
1666 
1667         _lastCall[msg.sender] = block.number;
1668         emit Transfer(msg.sender, address(0x0), oneAmount);
1669     }
1670 
1671     // 2nd step for withdrawal of collateral
1672     // this 2 step withdrawal is important for prevent flash-loan style attacks
1673     // flash-loan style attacks try to use loops/complex arbitrage strategies to
1674     // drain collateral so adding a 2-step process prevents any potential attacks
1675     // because all flash-loans must be repaid within 1 tx and 1 block
1676 
1677     /// @notice If you are interested, I would recommend reading: https://slowmist.medium.com/
1678     ///         also https://cryptobriefing.com/50-million-lost-the-top-19-defi-cryptocurrency-hacks-2020/
1679     function withdrawFinal(address collateral, uint256 amount)
1680         public
1681         nonReentrant
1682         updateProtocol()
1683     {
1684         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1685         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1686 
1687         uint256 oneAmount = _burnedStablecoin[msg.sender];
1688         require(oneAmount != 0, "insufficient oneWING to redeem");
1689         require(amount <= oneAmount, "insufficient oneWING to redeem");
1690 
1691         _burnedStablecoin[msg.sender] = _burnedStablecoin[msg.sender].sub(amount);
1692 
1693         // send collateral - fee (convert to collateral decimals too)
1694         uint256 collateralAmount = amount.sub(amount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1695         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1696 
1697         uint256 stimulusAmount = 0;
1698 
1699         // check enough reserves - don't want to burn one coin if we cannot fulfill withdrawal
1700         require(collateralAmount <= IERC20(collateral).balanceOf(address(this)), "insufficient collateral reserves - try another collateral");
1701 
1702         SafeERC20.safeTransfer(IERC20(collateral), msg.sender, collateralAmount);
1703 
1704         _lastCall[msg.sender] = block.number;
1705 
1706         emit Withdraw(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, amount);
1707     }
1708 
1709     // internal function used to set the reserve ratio of the token
1710     // must be between MIN / MAX Reserve Ratio, which are constants
1711     // cannot be 0
1712     function setReserveRatio(uint256 newRatio_)
1713         internal
1714     {
1715         require(newRatio_ >= 0, "positive reserve ratio");
1716 
1717         if (newRatio_ <= MAX_RESERVE_RATIO && newRatio_ >= MIN_RESERVE_RATIO) {
1718             reserveRatio = newRatio_;
1719             emit NewReserveRate(reserveRatio);
1720         }
1721     }
1722 
1723     /// @notice easy function transfer ETH (not WETH)
1724     function safeTransferETH(address to, uint value)
1725         public
1726         oneLPGov
1727     {
1728         (bool success,) = to.call{value:value}(new bytes(0));
1729         require(success, 'ETH_TRANSFER_FAILED');
1730     }
1731 
1732     /// @notice easy funtion to move stimulus to a new location
1733     //  location: address to send to
1734     //  amount: amount of stimulus to send (use full decimals)
1735     function moveStimulus(
1736         address location,
1737         uint256 amount
1738     )
1739         public
1740         oneLPGov
1741     {
1742         SafeERC20.safeTransfer(IERC20(stimulus), location, amount);
1743     }
1744 
1745     // can execute any abstract transaction on this smart contrat
1746     // target: address / smart contract you are interracting with
1747     // value: msg.value (amount of eth in WEI you are sending. Most of the time it is 0)
1748     // signature: the function signature (name of the function and the types of the arguments).
1749     //            for example: "transfer(address,uint256)", or "approve(address,uint256)"
1750     // data: abi-encodeded byte-code of the parameter values you are sending. See "./encode.js" for Ether.js library function to make this easier
1751     function executeTransaction(address target, uint value, string memory signature, bytes memory data) public payable oneLPGov returns (bytes memory) {
1752         bytes memory callData;
1753 
1754         if (bytes(signature).length == 0) {
1755             callData = data;
1756         } else {
1757             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
1758         }
1759 
1760         // solium-disable-next-line security/no-call-value
1761         (bool success, bytes memory returnData) = target.call.value(value)(callData);
1762         require(success, "oneWING::executeTransaction: Transaction execution reverted.");
1763 
1764         return returnData;
1765     }
1766 
1767 }