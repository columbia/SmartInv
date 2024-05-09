1 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
2 
3 pragma solidity >=0.6.0;
4 
5 interface AggregatorV3Interface {
6 
7   function decimals() external view returns (uint8);
8   function description() external view returns (string memory);
9   function version() external view returns (uint256);
10 
11   // getRoundData and latestRoundData should both raise "No data present"
12   // if they do not have data to report, instead of returning unset values
13   // which could be misinterpreted as actual reported values.
14   function getRoundData(uint80 _roundId)
15     external
16     view
17     returns (
18       uint80 roundId,
19       int256 answer,
20       uint256 startedAt,
21       uint256 updatedAt,
22       uint80 answeredInRound
23     );
24   function latestRoundData()
25     external
26     view
27     returns (
28       uint80 roundId,
29       int256 answer,
30       uint256 startedAt,
31       uint256 updatedAt,
32       uint80 answeredInRound
33     );
34 
35 }
36 
37 // File: @openzeppelin/contracts/math/SafeMath.sol
38 
39 pragma solidity ^0.6.0;
40 
41 /**
42  * @dev Wrappers over Solidity's arithmetic operations with added overflow
43  * checks.
44  *
45  * Arithmetic operations in Solidity wrap on overflow. This can easily result
46  * in bugs, because programmers usually assume that an overflow raises an
47  * error, which is the standard behavior in high level programming languages.
48  * `SafeMath` restores this intuition by reverting the transaction when an
49  * operation overflows.
50  *
51  * Using this library instead of the unchecked operations eliminates an entire
52  * class of bugs, so it's recommended to use it always.
53  */
54 library SafeMath {
55     /**
56      * @dev Returns the addition of two unsigned integers, reverting on
57      * overflow.
58      *
59      * Counterpart to Solidity's `+` operator.
60      *
61      * Requirements:
62      *
63      * - Addition cannot overflow.
64      */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the subtraction of two unsigned integers, reverting on
74      * overflow (when the result is negative).
75      *
76      * Counterpart to Solidity's `-` operator.
77      *
78      * Requirements:
79      *
80      * - Subtraction cannot overflow.
81      */
82     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83         return sub(a, b, "SafeMath: subtraction overflow");
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b <= a, errorMessage);
98         uint256 c = a - b;
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the multiplication of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `*` operator.
108      *
109      * Requirements:
110      *
111      * - Multiplication cannot overflow.
112      */
113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115         // benefit is lost if 'b' is also tested.
116         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
117         if (a == 0) {
118             return 0;
119         }
120 
121         uint256 c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b != 0, errorMessage);
193         return a % b;
194     }
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
198 
199 pragma solidity ^0.6.0;
200 
201 /**
202  * @dev Interface of the ERC20 standard as defined in the EIP.
203  */
204 interface IERC20 {
205     /**
206      * @dev Returns the amount of tokens in existence.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns the amount of tokens owned by `account`.
212      */
213     function balanceOf(address account) external view returns (uint256);
214 
215     /**
216      * @dev Moves `amount` tokens from the caller's account to `recipient`.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transfer(address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Returns the remaining number of tokens that `spender` will be
226      * allowed to spend on behalf of `owner` through {transferFrom}. This is
227      * zero by default.
228      *
229      * This value changes when {approve} or {transferFrom} are called.
230      */
231     function allowance(address owner, address spender) external view returns (uint256);
232 
233     /**
234      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * IMPORTANT: Beware that changing an allowance with this method brings the risk
239      * that someone may use both the old and the new allowance by unfortunate
240      * transaction ordering. One possible solution to mitigate this race
241      * condition is to first reduce the spender's allowance to 0 and set the
242      * desired value afterwards:
243      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address spender, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Moves `amount` tokens from `sender` to `recipient` using the
251      * allowance mechanism. `amount` is then deducted from the caller's
252      * allowance.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * Emits a {Transfer} event.
257      */
258     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Emitted when `value` tokens are moved from one account (`from`) to
262      * another (`to`).
263      *
264      * Note that `value` may be zero.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     /**
269      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
270      * a call to {approve}. `value` is the new allowance.
271      */
272     event Approval(address indexed owner, address indexed spender, uint256 value);
273 }
274 
275 // File: @openzeppelin/contracts/utils/Address.sol
276 
277 pragma solidity ^0.6.2;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // This method relies in extcodesize, which returns 0 for contracts in
302         // construction, since the code is only stored at the end of the
303         // constructor execution.
304 
305         uint256 size;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { size := extcodesize(account) }
308         return size > 0;
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
418 
419 pragma solidity ^0.6.0;
420 
421 
422 
423 
424 /**
425  * @title SafeERC20
426  * @dev Wrappers around ERC20 operations that throw on failure (when the token
427  * contract returns false). Tokens that return no value (and instead revert or
428  * throw on failure) are also supported, non-reverting calls are assumed to be
429  * successful.
430  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
431  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
432  */
433 library SafeERC20 {
434     using SafeMath for uint256;
435     using Address for address;
436 
437     function safeTransfer(IERC20 token, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439     }
440 
441     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
442         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
443     }
444 
445     /**
446      * @dev Deprecated. This function has issues similar to the ones found in
447      * {IERC20-approve}, and its usage is discouraged.
448      *
449      * Whenever possible, use {safeIncreaseAllowance} and
450      * {safeDecreaseAllowance} instead.
451      */
452     function safeApprove(IERC20 token, address spender, uint256 value) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         // solhint-disable-next-line max-line-length
457         require((value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
464         uint256 newAllowance = token.allowance(address(this), spender).add(value);
465         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
466     }
467 
468     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
469         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
470         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function _callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
482         // the target address contains contract code and also asserts for success in the low-level call.
483 
484         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
485         if (returndata.length > 0) { // Return data is optional
486             // solhint-disable-next-line max-line-length
487             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
488         }
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
493 
494 pragma solidity ^0.6.0;
495 
496 /**
497  * @dev Contract module that helps prevent reentrant calls to a function.
498  *
499  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
500  * available, which can be applied to functions to make sure there are no nested
501  * (reentrant) calls to them.
502  *
503  * Note that because there is a single `nonReentrant` guard, functions marked as
504  * `nonReentrant` may not call one another. This can be worked around by making
505  * those functions `private`, and then adding `external` `nonReentrant` entry
506  * points to them.
507  *
508  * TIP: If you would like to learn more about reentrancy and alternative ways
509  * to protect against it, check out our blog post
510  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
511  */
512 contract ReentrancyGuard {
513     // Booleans are more expensive than uint256 or any type that takes up a full
514     // word because each write operation emits an extra SLOAD to first read the
515     // slot's contents, replace the bits taken up by the boolean, and then write
516     // back. This is the compiler's defense against contract upgrades and
517     // pointer aliasing, and it cannot be disabled.
518 
519     // The values being non-zero value makes deployment a bit more expensive,
520     // but in exchange the refund on every call to nonReentrant will be lower in
521     // amount. Since refunds are capped to a percentage of the total
522     // transaction's gas, it is best to keep them low in cases like this one, to
523     // increase the likelihood of the full refund coming into effect.
524     uint256 private constant _NOT_ENTERED = 1;
525     uint256 private constant _ENTERED = 2;
526 
527     uint256 private _status;
528 
529     constructor () internal {
530         _status = _NOT_ENTERED;
531     }
532 
533     /**
534      * @dev Prevents a contract from calling itself, directly or indirectly.
535      * Calling a `nonReentrant` function from another `nonReentrant`
536      * function is not supported. It is possible to prevent this from happening
537      * by making the `nonReentrant` function external, and make it call a
538      * `private` function that does the actual work.
539      */
540     modifier nonReentrant() {
541         // On the first call to nonReentrant, _notEntered will be true
542         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
543 
544         // Any calls to nonReentrant after this point will fail
545         _status = _ENTERED;
546 
547         _;
548 
549         // By storing the original value once again, a refund is triggered (see
550         // https://eips.ethereum.org/EIPS/eip-2200)
551         _status = _NOT_ENTERED;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/GSN/Context.sol
556 
557 pragma solidity ^0.6.0;
558 
559 /*
560  * @dev Provides information about the current execution context, including the
561  * sender of the transaction and its data. While these are generally available
562  * via msg.sender and msg.data, they should not be accessed in such a direct
563  * manner, since when dealing with GSN meta-transactions the account sending and
564  * paying for execution may not be the actual sender (as far as an application
565  * is concerned).
566  *
567  * This contract is only required for intermediate, library-like contracts.
568  */
569 abstract contract Context {
570     function _msgSender() internal view virtual returns (address payable) {
571         return msg.sender;
572     }
573 
574     function _msgData() internal view virtual returns (bytes memory) {
575         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
576         return msg.data;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
581 
582 pragma solidity ^0.6.0;
583 
584 
585 
586 
587 
588 /**
589  * @dev Implementation of the {IERC20} interface.
590  *
591  * This implementation is agnostic to the way tokens are created. This means
592  * that a supply mechanism has to be added in a derived contract using {_mint}.
593  * For a generic mechanism see {ERC20PresetMinterPauser}.
594  *
595  * TIP: For a detailed writeup see our guide
596  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
597  * to implement supply mechanisms].
598  *
599  * We have followed general OpenZeppelin guidelines: functions revert instead
600  * of returning `false` on failure. This behavior is nonetheless conventional
601  * and does not conflict with the expectations of ERC20 applications.
602  *
603  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
604  * This allows applications to reconstruct the allowance for all accounts just
605  * by listening to said events. Other implementations of the EIP may not emit
606  * these events, as it isn't required by the specification.
607  *
608  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
609  * functions have been added to mitigate the well-known issues around setting
610  * allowances. See {IERC20-approve}.
611  */
612 contract ERC20 is Context, IERC20 {
613     using SafeMath for uint256;
614     using Address for address;
615 
616     mapping (address => uint256) private _balances;
617 
618     mapping (address => mapping (address => uint256)) private _allowances;
619 
620     uint256 private _totalSupply;
621 
622     string private _name;
623     string private _symbol;
624     uint8 private _decimals;
625 
626     /**
627      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
628      * a default value of 18.
629      *
630      * To select a different value for {decimals}, use {_setupDecimals}.
631      *
632      * All three of these values are immutable: they can only be set once during
633      * construction.
634      */
635     constructor (string memory name, string memory symbol) public {
636         _name = name;
637         _symbol = symbol;
638         _decimals = 18;
639     }
640 
641     /**
642      * @dev Returns the name of the token.
643      */
644     function name() public view returns (string memory) {
645         return _name;
646     }
647 
648     /**
649      * @dev Returns the symbol of the token, usually a shorter version of the
650      * name.
651      */
652     function symbol() public view returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev Returns the number of decimals used to get its user representation.
658      * For example, if `decimals` equals `2`, a balance of `505` tokens should
659      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
660      *
661      * Tokens usually opt for a value of 18, imitating the relationship between
662      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
663      * called.
664      *
665      * NOTE: This information is only used for _display_ purposes: it in
666      * no way affects any of the arithmetic of the contract, including
667      * {IERC20-balanceOf} and {IERC20-transfer}.
668      */
669     function decimals() public view returns (uint8) {
670         return _decimals;
671     }
672 
673     /**
674      * @dev See {IERC20-totalSupply}.
675      */
676     function totalSupply() public view override virtual returns (uint256) {
677         return _totalSupply;
678     }
679 
680     /**
681      * @dev See {IERC20-balanceOf}.
682      */
683     function balanceOf(address account) public view override virtual returns (uint256) {
684         return _balances[account];
685     }
686 
687     /**
688      * @dev See {IERC20-transfer}.
689      *
690      * Requirements:
691      *
692      * - `recipient` cannot be the zero address.
693      * - the caller must have a balance of at least `amount`.
694      */
695     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
696         _transfer(_msgSender(), recipient, amount);
697         return true;
698     }
699 
700     /**
701      * @dev See {IERC20-allowance}.
702      */
703     function allowance(address owner, address spender) public view virtual override returns (uint256) {
704         return _allowances[owner][spender];
705     }
706 
707     /**
708      * @dev See {IERC20-approve}.
709      *
710      * Requirements:
711      *
712      * - `spender` cannot be the zero address.
713      */
714     function approve(address spender, uint256 amount) public virtual override returns (bool) {
715         _approve(_msgSender(), spender, amount);
716         return true;
717     }
718 
719     /**
720      * @dev See {IERC20-transferFrom}.
721      *
722      * Emits an {Approval} event indicating the updated allowance. This is not
723      * required by the EIP. See the note at the beginning of {ERC20};
724      *
725      * Requirements:
726      * - `sender` and `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      * - the caller must have allowance for ``sender``'s tokens of at least
729      * `amount`.
730      */
731     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
732         _transfer(sender, recipient, amount);
733         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
734         return true;
735     }
736 
737     /**
738      * @dev Atomically increases the allowance granted to `spender` by the caller.
739      *
740      * This is an alternative to {approve} that can be used as a mitigation for
741      * problems described in {IERC20-approve}.
742      *
743      * Emits an {Approval} event indicating the updated allowance.
744      *
745      * Requirements:
746      *
747      * - `spender` cannot be the zero address.
748      */
749     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
751         return true;
752     }
753 
754     /**
755      * @dev Atomically decreases the allowance granted to `spender` by the caller.
756      *
757      * This is an alternative to {approve} that can be used as a mitigation for
758      * problems described in {IERC20-approve}.
759      *
760      * Emits an {Approval} event indicating the updated allowance.
761      *
762      * Requirements:
763      *
764      * - `spender` cannot be the zero address.
765      * - `spender` must have allowance for the caller of at least
766      * `subtractedValue`.
767      */
768     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
769         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
770         return true;
771     }
772 
773     /**
774      * @dev Moves tokens `amount` from `sender` to `recipient`.
775      *
776      * This is internal function is equivalent to {transfer}, and can be used to
777      * e.g. implement automatic token fees, slashing mechanisms, etc.
778      *
779      * Emits a {Transfer} event.
780      *
781      * Requirements:
782      *
783      * - `sender` cannot be the zero address.
784      * - `recipient` cannot be the zero address.
785      * - `sender` must have a balance of at least `amount`.
786      */
787     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
788         require(sender != address(0), "ERC20: transfer from the zero address");
789         require(recipient != address(0), "ERC20: transfer to the zero address");
790 
791         _beforeTokenTransfer(sender, recipient, amount);
792 
793         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
794         _balances[recipient] = _balances[recipient].add(amount);
795         emit Transfer(sender, recipient, amount);
796     }
797 
798     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
799      * the total supply.
800      *
801      * Emits a {Transfer} event with `from` set to the zero address.
802      *
803      * Requirements
804      *
805      * - `to` cannot be the zero address.
806      */
807     function _mint(address account, uint256 amount) internal virtual {
808         require(account != address(0), "ERC20: mint to the zero address");
809 
810         _beforeTokenTransfer(address(0), account, amount);
811 
812         _totalSupply = _totalSupply.add(amount);
813         _balances[account] = _balances[account].add(amount);
814         emit Transfer(address(0), account, amount);
815     }
816 
817     /**
818      * @dev Destroys `amount` tokens from `account`, reducing the
819      * total supply.
820      *
821      * Emits a {Transfer} event with `to` set to the zero address.
822      *
823      * Requirements
824      *
825      * - `account` cannot be the zero address.
826      * - `account` must have at least `amount` tokens.
827      */
828     function _burn(address account, uint256 amount) internal virtual {
829         require(account != address(0), "ERC20: burn from the zero address");
830 
831         _beforeTokenTransfer(account, address(0), amount);
832 
833         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
834         _totalSupply = _totalSupply.sub(amount);
835         emit Transfer(account, address(0), amount);
836     }
837 
838     /**
839      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
840      *
841      * This internal function is equivalent to `approve`, and can be used to
842      * e.g. set automatic allowances for certain subsystems, etc.
843      *
844      * Emits an {Approval} event.
845      *
846      * Requirements:
847      *
848      * - `owner` cannot be the zero address.
849      * - `spender` cannot be the zero address.
850      */
851     function _approve(address owner, address spender, uint256 amount) internal virtual {
852         require(owner != address(0), "ERC20: approve from the zero address");
853         require(spender != address(0), "ERC20: approve to the zero address");
854 
855         _allowances[owner][spender] = amount;
856         emit Approval(owner, spender, amount);
857     }
858 
859     /**
860      * @dev Sets {decimals} to a value other than the default one of 18.
861      *
862      * WARNING: This function should only be called from the constructor. Most
863      * applications that interact with token contracts will not expect
864      * {decimals} to ever change, and may work incorrectly if it does.
865      */
866     function _setupDecimals(uint8 decimals_) internal {
867         _decimals = decimals_;
868     }
869 
870     /**
871      * @dev Hook that is called before any transfer of tokens. This includes
872      * minting and burning.
873      *
874      * Calling conditions:
875      *
876      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
877      * will be to transferred to `to`.
878      * - when `from` is zero, `amount` tokens will be minted for `to`.
879      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
880      * - `from` and `to` are never both zero.
881      *
882      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
883      */
884     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
885 }
886 
887 // File: @openzeppelin/contracts/access/Ownable.sol
888 
889 // SPDX-License-Identifier: MIT
890 
891 pragma solidity ^0.6.0;
892 
893 /**
894  * @dev Contract module which provides a basic access control mechanism, where
895  * there is an account (an owner) that can be granted exclusive access to
896  * specific functions.
897  *
898  * By default, the owner account will be the one that deploys the contract. This
899  * can later be changed with {transferOwnership}.
900  *
901  * This module is used through inheritance. It will make available the modifier
902  * `onlyOwner`, which can be applied to your functions to restrict their use to
903  * the owner.
904  */
905 contract Ownable is Context {
906     address private _owner;
907 
908     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
909 
910     /**
911      * @dev Initializes the contract setting the deployer as the initial owner.
912      */
913     constructor () internal {
914         address msgSender = _msgSender();
915         _owner = msgSender;
916         emit OwnershipTransferred(address(0), msgSender);
917     }
918 
919     /**
920      * @dev Returns the address of the current owner.
921      */
922     function owner() public view returns (address) {
923         return _owner;
924     }
925 
926     /**
927      * @dev Throws if called by any account other than the owner.
928      */
929     modifier onlyOwner() {
930         require(_owner == _msgSender(), "Ownable: caller is not the owner");
931         _;
932     }
933 
934     /**
935      * @dev Leaves the contract without owner. It will not be possible to call
936      * `onlyOwner` functions anymore. Can only be called by the current owner.
937      *
938      * NOTE: Renouncing ownership will leave the contract without an owner,
939      * thereby removing any functionality that is only available to the owner.
940      */
941     function renounceOwnership() public virtual onlyOwner {
942         emit OwnershipTransferred(_owner, address(0));
943         _owner = address(0);
944     }
945 
946     /**
947      * @dev Transfers ownership of the contract to a new account (`newOwner`).
948      * Can only be called by the current owner.
949      */
950     function transferOwnership(address newOwner) public virtual onlyOwner {
951         require(newOwner != address(0), "Ownable: new owner is the zero address");
952         emit OwnershipTransferred(_owner, newOwner);
953         _owner = newOwner;
954     }
955 }
956 
957 // File: contracts/3-oneLINK.sol
958 
959 pragma solidity ^0.6.0;
960 
961 
962 
963 
964 
965 
966 
967 interface IUniswapOracle {
968     function changeInterval(uint256 seconds_) external;
969     function update() external;
970     function consult(address token, uint amountIn) external view returns (uint amountOut);
971 }
972 
973 interface OneToken {
974     function getOneTokenUsd() external view returns (uint256);
975 }
976 
977 // TODO: add fees for different collateral
978 
979 contract oneLINK is ERC20("oneLINK", "oneLINK"), Ownable, ReentrancyGuard {
980     using SafeMath for uint256;
981 
982     // At 100% reserve ratio, each oneLINK is backed 1-to-1 by $1 of existing stable coins
983     uint256 constant public MAX_RESERVE_RATIO = 100 * 10 ** 9;
984     uint256 private constant DECIMALS = 9;
985     uint256 public lastRefreshReserve; // The last time the reserve ratio was updated by the contract
986     uint256 public minimumRefreshTime; // The time between reserve ratio refreshes
987 
988     address public stimulus; // oneLINK builds a stimulus fund in LINK.
989     uint256 public stimulusDecimals; // used to calculate oracle rate of Uniswap Pair
990 
991     // We get the price of LINK from Chainlink!  Thanks chainLink!  Hopefully, the chainLink
992     // will provide Oracle prices for oneLINK, oneLINK, etc in the future.  For now, we will get those
993     // from the ichi.farm exchange which uses Uniswap contracts.
994     AggregatorV3Interface internal chainlinkStimulusOracle;
995     AggregatorV3Interface internal ethPrice;
996 
997 
998     address public oneTokenOracle; // oracle for the oneLINK stable coin
999     address public stimulusOracle;  // oracle for a stimulus cryptocurrency that isn't on chainLink
1000     bool public chainLink;         // true means it is a chainLink oracle
1001 
1002     // Only governance should cause the coin to go fully agorithmic by changing the minimum reserve
1003     // ratio.  For now, we will set a conservative minimum reserve ratio.
1004     uint256 public MIN_RESERVE_RATIO;
1005     uint256 public MIN_DELAY;
1006 
1007     // Makes sure that you can't send coins to a 0 address and prevents coins from being sent to the
1008     // contract address. I want to protect your funds! 
1009     modifier validRecipient(address to) {
1010         require(to != address(0x0));
1011         require(to != address(this));
1012         _;
1013     }
1014 
1015     uint256 private _totalSupply;
1016     mapping(address => uint256) private _oneBalances;
1017     mapping(address => uint256) private _lastCall;
1018     mapping (address => mapping (address => uint256)) private _allowedOne;
1019 
1020     address public wethAddress;
1021     address public ethUsdcUniswapOracle;
1022     address public gov;
1023     // allows you to transfer the governance to a different user - they must accept it!
1024     address public pendingGov;
1025     uint256 public reserveStepSize; // step size of update of reserve rate (e.g. 5 * 10 ** 8 = 0.5%)
1026     uint256 public reserveRatio;    // a number between 0 and 100 * 10 ** 9.
1027                                     // 0 = 0%
1028                                     // 100 * 10 ** 9 = 100%
1029 
1030     // map of acceptable collaterals
1031     mapping (address => bool) public acceptedCollateral;
1032     mapping (address => uint256) public collateralMintFee;
1033     address[] public collateralArray;
1034 
1035     // modifier to allow auto update of TWAP oracle prices
1036     // also updates reserves rate programatically
1037     modifier updateProtocol() {
1038         if (address(oneTokenOracle) != address(0)) {
1039             // only update if stimulusOracle is set
1040             if (!chainLink) IUniswapOracle(stimulusOracle).update();
1041 
1042             // this is always updated because we always need stablecoin oracle price
1043             IUniswapOracle(oneTokenOracle).update();
1044 
1045             for (uint i = 0; i < collateralArray.length; i++){ 
1046                 if (acceptedCollateral[collateralArray[i]] && !oneCoinCollateralOracle[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).update();
1047             }
1048 
1049             // update reserve ratio if enough time has passed
1050             if (block.timestamp - lastRefreshReserve >= minimumRefreshTime) {
1051                 // $Z / 1 one token
1052                 if (getOneTokenUsd() > 1 * 10 ** 9) {
1053                     setReserveRatio(reserveRatio.sub(reserveStepSize));
1054                 } else {
1055                     setReserveRatio(reserveRatio.add(reserveStepSize));
1056                 }
1057 
1058                 lastRefreshReserve = block.timestamp;
1059             }
1060         }
1061         
1062         _;
1063     }
1064 
1065     event NewPendingGov(address oldPendingGov, address newPendingGov);
1066     event NewGov(address oldGov, address newGov);
1067     event NewReserveRate(uint256 reserveRatio);
1068     event Mint(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1069     event Withdraw(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1070     event NewMinimumRefreshTime(uint256 minimumRefreshTime);
1071     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data);
1072 
1073     modifier onlyIchiGov() {
1074         require(msg.sender == gov, "ACCESS: only Ichi governance");
1075         _;
1076     }
1077 
1078     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
1079     mapping (address => uint256) public collateralDecimals;
1080     mapping (address => bool) public oneCoinCollateralOracle;   // if true, we query the one token contract's usd price
1081     mapping (address => bool) public previouslySeenCollateral;
1082     mapping (address => address) public collateralOracle;       // address of the Collateral-LINK Uniswap Price
1083 
1084     // default to 0
1085     uint256 public mintFee;
1086     uint256 public withdrawFee;
1087 
1088     // fee to charge when minting oneLINK - this will go into collateral
1089     event MintFee(uint256 fee_);
1090     // fee to charge when redeeming oneLINK - this will go into collateral
1091     event WithdrawFee(uint256 fee_);
1092 
1093     // set governance access to only oneLINK - LINK pool multisig (elected after rewards)
1094     modifier linkLPGov() {
1095         require(msg.sender == lpGov, "ACCESS: only linkLP governance");
1096         _;
1097     }
1098 
1099     address public lpGov;
1100     address public pendingLPGov;
1101 
1102     event NewPendingLPGov(address oldPendingLPGov, address newPendingLPGov);
1103     event NewLPGov(address oldLPGov, address newLPGov);
1104     event NewMintFee(address collateral, uint256 oldFee, uint256 newFee);
1105 
1106     mapping (address => uint256) private _burnedStablecoin; // maps user to burned oneLINK
1107 
1108     // important: make sure changeInterval is a function to allow the interval of update to change
1109     function addCollateral(address collateral_, uint256 collateralDecimal_, address oracleAddress_, bool oneCoinOracle)
1110         external
1111         linkLPGov
1112     {
1113         // only add collateral once
1114         if (!previouslySeenCollateral[collateral_]) collateralArray.push(collateral_);
1115 
1116         previouslySeenCollateral[collateral_] = true;
1117         acceptedCollateral[collateral_] = true;
1118         oneCoinCollateralOracle[collateral_] = oneCoinOracle;
1119         collateralDecimals[collateral_] = collateralDecimal_;
1120         collateralOracle[collateral_] = oracleAddress_;
1121         collateralMintFee[collateral_] = 0;
1122     }
1123 
1124 
1125     function setCollateralMintFee(address collateral_, uint256 fee_)
1126         external
1127         linkLPGov
1128     {
1129         require(acceptedCollateral[collateral_], "invalid collateral");
1130         require(fee_ <= 100 * 10 ** 9, "Fee must be valid");
1131         emit NewMintFee(collateral_, collateralMintFee[collateral_], fee_);
1132         collateralMintFee[collateral_] = fee_;
1133     }
1134 
1135     function setReserveStepSize(uint256 stepSize_)
1136         external
1137         linkLPGov
1138     {
1139         reserveStepSize = stepSize_;
1140     }
1141 
1142     function setCollateralOracle(address collateral_, address oracleAddress_, bool oneCoinOracle_)
1143         external
1144         linkLPGov
1145     {
1146         require(acceptedCollateral[collateral_], "invalid collateral");
1147         oneCoinCollateralOracle[collateral_] = oneCoinOracle_;
1148         collateralOracle[collateral_] = oracleAddress_;
1149     }
1150 
1151     function removeCollateral(address collateral_)
1152         external
1153         linkLPGov
1154     {
1155         acceptedCollateral[collateral_] = false;
1156     }
1157 
1158     // used for querying
1159     function getBurnedStablecoin(address _user)
1160         public
1161         view
1162         returns (uint256)
1163     {
1164         return _burnedStablecoin[_user];
1165     }
1166 
1167     // returns 10 ** 9 price of collateral
1168     function getCollateralUsd(address collateral_) public view returns (uint256) {
1169         require(previouslySeenCollateral[collateral_], "must be an existing collateral");
1170 
1171         if (oneCoinCollateralOracle[collateral_]) return OneToken(collateral_).getOneTokenUsd();
1172 
1173         uint256 ethUsdcTWAP = IUniswapOracle(ethUsdcUniswapOracle).consult(wethAddress, 1 * 10 ** 18);  // 1 ETH = X USDC (10 ^ 6 decimals)
1174         return ethUsdcTWAP.mul(10 ** 3).mul(10 ** 9).div((IUniswapOracle(collateralOracle[collateral_]).consult(wethAddress, 10 ** 18)).mul(10 ** 9).div(10 ** collateralDecimals[collateral_]));
1175     }
1176 
1177     function globalCollateralValue() public view returns (uint256) {
1178         uint256 totalCollateralUsd = 0; 
1179 
1180         for (uint i = 0; i < collateralArray.length; i++){ 
1181             // Exclude null addresses
1182             if (collateralArray[i] != address(0)){
1183                 totalCollateralUsd += IERC20(collateralArray[i]).balanceOf(address(this)).mul(10 ** 9).div(10 ** collateralDecimals[collateralArray[i]]).mul(getCollateralUsd(collateralArray[i])).div(10 ** 9); // add stablecoin balance
1184             }
1185 
1186         }
1187         return totalCollateralUsd;
1188     }
1189 
1190     // return price of oneLINK in 10 ** 9 decimal
1191     function getOneTokenUsd()
1192         public
1193         view
1194         returns (uint256)
1195     {
1196         uint256 oneTokenPrice = IUniswapOracle(oneTokenOracle).consult(stimulus, 10 ** stimulusDecimals); // X one tokens (10 ** 9) / 1 stimulus token
1197         uint256 stimulusTWAP = getStimulusOracle(); // $Y / 1 stimulus (10 ** 9)
1198 
1199         uint256 oneTokenUsd = stimulusTWAP.mul(10 ** 9).div(oneTokenPrice); // 10 ** 9 decimals
1200         return oneTokenUsd;
1201     }
1202 
1203     /**
1204      * @return The total number of oneLINK.
1205      */
1206     function totalSupply()
1207         public
1208         override
1209         view
1210         returns (uint256)
1211     {
1212         return _totalSupply;
1213     }
1214 
1215     /**
1216      * @param who The address to query.
1217      * @return The balance of the specified address.
1218      */
1219     function balanceOf(address who)
1220         public
1221         override
1222         view
1223         returns (uint256)
1224     {
1225         return _oneBalances[who];
1226     }
1227 
1228     function setChainLinkStimulusOracle(address oracle_)
1229         external
1230         linkLPGov
1231         returns (bool)
1232     {
1233         chainlinkStimulusOracle = AggregatorV3Interface(oracle_);
1234         chainLink = true;
1235 
1236         return true;
1237     }
1238 
1239     /**
1240      * @dev Transfer tokens to a specified address.
1241      * @param to The address to transfer to.
1242      * @param value The amount to be transferred.
1243      * @return True on success, false otherwise.
1244      */
1245     function transfer(address to, uint256 value)
1246         public
1247         override
1248         validRecipient(to)
1249         updateProtocol()
1250         returns (bool)
1251     {
1252         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(value);
1253         _oneBalances[to] = _oneBalances[to].add(value);
1254         emit Transfer(msg.sender, to, value);
1255 
1256         return true;
1257     }
1258 
1259     /**
1260      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1261      * @param owner_ The address which owns the funds.
1262      * @param spender The address which will spend the funds.
1263      * @return The number of tokens still available for the spender.
1264      */
1265     function allowance(address owner_, address spender)
1266         public
1267         override
1268         view
1269         returns (uint256)
1270     {
1271         return _allowedOne[owner_][spender];
1272     }
1273 
1274     /**
1275      * @dev Transfer tokens from one address to another.
1276      * @param from The address you want to send tokens from.
1277      * @param to The address you want to transfer to.
1278      * @param value The amount of tokens to be transferred.
1279      */
1280     function transferFrom(address from, address to, uint256 value)
1281         public
1282         override
1283         validRecipient(to)
1284         updateProtocol()
1285         returns (bool)
1286     {
1287         _allowedOne[from][msg.sender] = _allowedOne[from][msg.sender].sub(value);
1288 
1289         _oneBalances[from] = _oneBalances[from].sub(value);
1290         _oneBalances[to] = _oneBalances[to].add(value);
1291         emit Transfer(from, to, value);
1292 
1293         return true;
1294     }
1295 
1296     /**
1297      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1298      * msg.sender. This method is included for ERC20 compatibility.
1299      * increaseAllowance and decreaseAllowance should be used instead.
1300      * Changing an allowance with this method brings the risk that someone may transfer both
1301      * the old and the new allowance - if they are both greater than zero - if a transfer
1302      * transaction is mined before the later approve() call is mined.
1303      *
1304      * @param spender The address which will spend the funds.
1305      * @param value The amount of tokens to be spent.
1306      */
1307     function approve(address spender, uint256 value)
1308         public
1309         override
1310         validRecipient(spender)
1311         updateProtocol()
1312         returns (bool)
1313     {
1314         _allowedOne[msg.sender][spender] = value;
1315         emit Approval(msg.sender, spender, value);
1316         return true;
1317     }
1318 
1319     /**
1320      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1321      * This method should be used instead of approve() to avoid the double approval vulnerability
1322      * described above.
1323      * @param spender The address which will spend the funds.
1324      * @param addedValue The amount of tokens to increase the allowance by.
1325      */
1326     function increaseAllowance(address spender, uint256 addedValue)
1327         public
1328         override
1329         returns (bool)
1330     {
1331         _allowedOne[msg.sender][spender] = _allowedOne[msg.sender][spender].add(addedValue);
1332         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1333         return true;
1334     }
1335 
1336     /**
1337      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1338      *
1339      * @param spender The address which will spend the funds.
1340      * @param subtractedValue The amount of tokens to decrease the allowance by.
1341      */
1342     function decreaseAllowance(address spender, uint256 subtractedValue)
1343         public
1344         override
1345         returns (bool)
1346     {
1347         uint256 oldValue = _allowedOne[msg.sender][spender];
1348         if (subtractedValue >= oldValue) {
1349             _allowedOne[msg.sender][spender] = 0;
1350         } else {
1351             _allowedOne[msg.sender][spender] = oldValue.sub(subtractedValue);
1352         }
1353         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1354         return true;
1355     }
1356 
1357     function setOneOracle(address oracle_)
1358         external
1359         linkLPGov
1360         returns (bool) 
1361     {
1362         oneTokenOracle = oracle_;
1363         
1364         return true;
1365     }
1366 
1367     function setEthUsdcUniswapOracle(address oracle_)
1368         external
1369         linkLPGov
1370         returns (bool)
1371     {
1372         ethUsdcUniswapOracle = oracle_;
1373 
1374         return true;
1375     }
1376 
1377     function setStimulusUniswapOracle(address oracle_)
1378         external
1379         linkLPGov
1380         returns (bool)
1381     {
1382         stimulusOracle = oracle_;
1383         chainLink = false;
1384 
1385         return true;
1386     }
1387 
1388     // oracle rate is 10 ** 9 decimals
1389     // returns $Z / Stimulus
1390     function getStimulusOracle()
1391         public
1392         view
1393         returns (uint256)
1394     {
1395         if (chainLink) {
1396             (
1397                 uint80 roundID, 
1398                 int price,
1399                 uint startedAt,
1400                 uint timeStamp,
1401                 uint80 answeredInRound
1402             ) = chainlinkStimulusOracle.latestRoundData();
1403 
1404             require(timeStamp > 0, "Rounds not complete");
1405 
1406             return uint256(price).mul(10); // 10 ** 9 price
1407         } else {
1408             // stimulusTWAP has `stimulusDecimals` decimals
1409             uint256 stimulusTWAP = IUniswapOracle(stimulusOracle).consult(wethAddress, 1 * 10 ** 18);       // 1 ETH = X Stimulus, or X Stimulus / ETH
1410             uint256 ethUsdcTWAP = IUniswapOracle(ethUsdcUniswapOracle).consult(wethAddress, 1 * 10 ** 18);  // 1 ETH = X USDC
1411 
1412             // X USDC / 1 ETH * (1 ETH / x Stimulus) = Y USDC / Stimulus
1413             return ethUsdcTWAP.mul(10 ** 3).mul(10 ** stimulusDecimals).div(stimulusTWAP); // 10 ** 9 price
1414         }
1415     }
1416 
1417     // minimum amount of block time (seconds) required for an update in reserve ratio
1418     function setMinimumRefreshTime(uint256 val_)
1419         external
1420         linkLPGov
1421         returns (bool)
1422     {
1423         require(val_ != 0, "minimum refresh time must be valid");
1424 
1425         minimumRefreshTime = val_;
1426 
1427         // change collateral array
1428         for (uint i = 0; i < collateralArray.length; i++){ 
1429             if (acceptedCollateral[collateralArray[i]] && !oneCoinCollateralOracle[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).changeInterval(val_);
1430         }
1431 
1432         IUniswapOracle(ethUsdcUniswapOracle).changeInterval(val_);
1433         // stimulus and oneToken oracle update
1434         IUniswapOracle(oneTokenOracle).changeInterval(val_);
1435         if (!chainLink) IUniswapOracle(stimulusOracle).changeInterval(val_);
1436 
1437         // change all the oracles (collateral, stimulus, oneToken)
1438 
1439         emit NewMinimumRefreshTime(val_);
1440         return true;
1441     }
1442 
1443     constructor(
1444         uint256 reserveRatio_,
1445         address stimulus_,
1446         uint256 stimulusDecimals_,
1447         address wethAddress_,
1448         address ethOracleChainLink_,
1449         address ethUsdcUniswap_
1450     )
1451         public
1452     {   
1453         _setupDecimals(uint8(9));
1454         stimulus = stimulus_;
1455         minimumRefreshTime = 3600 * 1; // 1 hour by default
1456         stimulusDecimals = stimulusDecimals_;
1457         reserveStepSize = 2 * 10 ** 8;  // 0.2% by default
1458         ethPrice = AggregatorV3Interface(ethOracleChainLink_);
1459         ethUsdcUniswapOracle = ethUsdcUniswap_;
1460         MIN_RESERVE_RATIO = 90 * 10 ** 9;
1461         wethAddress = wethAddress_;
1462         MIN_DELAY = 3;             // 3 blocks
1463         withdrawFee = 1 * 10 ** 8; // 0.1% fee at first, remains in collateral
1464         gov = msg.sender;
1465         lpGov = msg.sender;
1466         reserveRatio = reserveRatio_;
1467         _totalSupply = 10 ** 9;
1468 
1469         _oneBalances[msg.sender] = 10 ** 9;
1470         emit Transfer(address(0x0), msg.sender, 10 ** 9);
1471     }
1472     
1473     function setMinimumReserveRatio(uint256 val_)
1474         external
1475         linkLPGov
1476     {
1477         MIN_RESERVE_RATIO = val_;
1478     }
1479 
1480     function setMinimumDelay(uint256 val_)
1481         external
1482         linkLPGov
1483     {
1484         MIN_DELAY = val_;
1485     }
1486 
1487     // LP pool governance ====================================
1488     function setPendingLPGov(address pendingLPGov_)
1489         external
1490         linkLPGov
1491     {
1492         address oldPendingLPGov = pendingLPGov;
1493         pendingLPGov = pendingLPGov_;
1494         emit NewPendingLPGov(oldPendingLPGov, pendingLPGov_);
1495     }
1496 
1497     function acceptLPGov()
1498         external
1499     {
1500         require(msg.sender == pendingLPGov, "!pending");
1501         address oldLPGov = lpGov; // that
1502         lpGov = pendingLPGov;
1503         pendingLPGov = address(0);
1504         emit NewGov(oldLPGov, lpGov);
1505     }
1506 
1507     // over-arching protocol level governance  ===============
1508     function setPendingGov(address pendingGov_)
1509         external
1510         onlyIchiGov
1511     {
1512         address oldPendingGov = pendingGov;
1513         pendingGov = pendingGov_;
1514         emit NewPendingGov(oldPendingGov, pendingGov_);
1515     }
1516 
1517     function acceptGov()
1518         external
1519     {
1520         require(msg.sender == pendingGov, "!pending");
1521         address oldGov = gov;
1522         gov = pendingGov;
1523         pendingGov = address(0);
1524         emit NewGov(oldGov, gov);
1525     }
1526     // ======================================================
1527 
1528     // calculates how much you will need to send in order to mint oneLINK, depending on current market prices + reserve ratio
1529     // oneAmount: the amount of oneLINK you want to mint
1530     // collateral: the collateral you want to use to pay
1531     // also works in the reverse direction, i.e. how much collateral + stimulus to receive when you burn One
1532     function consultOneDeposit(uint256 oneAmount, address collateral)
1533         public
1534         view
1535         returns (uint256, uint256)
1536     {
1537         require(oneAmount != 0, "must use valid oneAmount");
1538         require(acceptedCollateral[collateral], "must be an accepted collateral");
1539 
1540         // convert to correct decimals for collateral
1541         uint256 collateralAmount = oneAmount.mul(reserveRatio).div(MAX_RESERVE_RATIO).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1542         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1543 
1544         if (address(oneTokenOracle) == address(0)) return (collateralAmount, 0);
1545 
1546         uint256 stimulusUsd = getStimulusOracle();     // 10 ** 9
1547 
1548         uint256 stimulusAmountInOneStablecoin = oneAmount.mul(MAX_RESERVE_RATIO.sub(reserveRatio)).div(MAX_RESERVE_RATIO);
1549 
1550         uint256 stimulusAmount = stimulusAmountInOneStablecoin.mul(10 ** 9).div(stimulusUsd).mul(10 ** stimulusDecimals).div(10 ** DECIMALS); // must be 10 ** stimulusDecimals
1551 
1552         return (collateralAmount, stimulusAmount);
1553     }
1554 
1555     function consultOneWithdraw(uint256 oneAmount, address collateral)
1556         public
1557         view
1558         returns (uint256, uint256)
1559     {
1560         require(oneAmount != 0, "must use valid oneAmount");
1561         require(previouslySeenCollateral[collateral], "must be an accepted collateral");
1562 
1563         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1564         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1565 
1566         return (collateralAmount, 0);
1567     }
1568 
1569     // @title: deposit collateral + stimulus token
1570     // collateral: address of the collateral to deposit (USDC, DAI, TUSD, etc)
1571     function mint(
1572         uint256 oneAmount,
1573         address collateral
1574     )
1575         public
1576         payable
1577         nonReentrant
1578     {
1579         require(acceptedCollateral[collateral], "must be an accepted collateral");
1580         require(oneAmount != 0, "must mint non-zero amount");
1581 
1582         // wait 3 blocks to avoid flash loans
1583         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few more blocks");
1584 
1585         // validate input amounts are correct
1586         (uint256 collateralAmount, uint256 stimulusAmount) = consultOneDeposit(oneAmount, collateral);
1587         require(collateralAmount <= IERC20(collateral).balanceOf(msg.sender), "sender has insufficient collateral balance");
1588         require(stimulusAmount <= IERC20(stimulus).balanceOf(msg.sender), "sender has insufficient stimulus balance");
1589 
1590         // checks passed, so transfer tokens
1591         SafeERC20.safeTransferFrom(IERC20(collateral), msg.sender, address(this), collateralAmount);
1592         SafeERC20.safeTransferFrom(IERC20(stimulus), msg.sender, address(this), stimulusAmount);
1593 
1594         oneAmount = oneAmount.sub(oneAmount.mul(mintFee).div(100 * 10 ** DECIMALS));                            // apply mint fee
1595         oneAmount = oneAmount.sub(oneAmount.mul(collateralMintFee[collateral]).div(100 * 10 ** DECIMALS));      // apply collateral fee
1596 
1597         _totalSupply = _totalSupply.add(oneAmount);
1598         _oneBalances[msg.sender] = _oneBalances[msg.sender].add(oneAmount);
1599 
1600         emit Transfer(address(0x0), msg.sender, oneAmount);
1601 
1602         _lastCall[msg.sender] = block.number;
1603 
1604         emit Mint(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
1605     }
1606 
1607     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1608     function editMintFee(uint256 fee_)
1609         external
1610         onlyIchiGov
1611     {
1612         require(fee_ <= 100 * 10 ** 9, "Fee must be valid");
1613         mintFee = fee_;
1614         emit MintFee(fee_);
1615     }
1616 
1617     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1618     function editWithdrawFee(uint256 fee_)
1619         external
1620         onlyIchiGov
1621     {
1622         withdrawFee = fee_;
1623         emit WithdrawFee(fee_);
1624     }
1625 
1626     // @title: burn oneLINK and receive collateral + stimulus token
1627     // oneAmount: amount of oneToken to burn to withdraw
1628     function withdraw(
1629         uint256 oneAmount,
1630         address collateral
1631     )
1632         public
1633         nonReentrant
1634         updateProtocol()
1635     {
1636         require(oneAmount != 0, "must withdraw non-zero amount");
1637         require(oneAmount <= _oneBalances[msg.sender], "insufficient balance");
1638         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1639         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1640 
1641         // burn oneAmount
1642         _totalSupply = _totalSupply.sub(oneAmount);
1643         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(oneAmount);
1644 
1645         _burnedStablecoin[msg.sender] = _burnedStablecoin[msg.sender].add(oneAmount);
1646 
1647         _lastCall[msg.sender] = block.number;
1648         emit Transfer(msg.sender, address(0x0), oneAmount);
1649     }
1650 
1651     function withdrawFinal(address collateral, uint256 amount)
1652         public
1653         nonReentrant
1654         updateProtocol()
1655     {
1656         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1657         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1658 
1659         uint256 oneAmount = _burnedStablecoin[msg.sender];
1660         require(oneAmount != 0, "insufficient oneLINK to redeem");
1661         require(amount <= oneAmount, "insufficient oneLINK to redeem");
1662 
1663         _burnedStablecoin[msg.sender] = _burnedStablecoin[msg.sender].sub(amount);
1664 
1665         // send collateral - fee (convert to collateral decimals too)
1666         uint256 collateralAmount = amount.sub(amount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1667         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1668 
1669         uint256 stimulusAmount = 0;
1670 
1671         // check enough reserves - don't want to burn one coin if we cannot fulfill withdrawal
1672         require(collateralAmount <= IERC20(collateral).balanceOf(address(this)), "insufficient collateral reserves - try another collateral");
1673 
1674         SafeERC20.safeTransfer(IERC20(collateral), msg.sender, collateralAmount);
1675 
1676         _lastCall[msg.sender] = block.number;
1677 
1678         emit Withdraw(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, amount);
1679     }
1680 
1681     // change reserveRatio
1682     // market driven -> decide the ratio automatically
1683     // if one coin >= $1, we lower reserve rate by half a percent
1684     // if one coin < $1, we increase reserve rate
1685     function setReserveRatio(uint256 newRatio_)
1686         internal
1687     {
1688         require(newRatio_ >= 0, "positive reserve ratio");
1689 
1690         if (newRatio_ <= MAX_RESERVE_RATIO && newRatio_ >= MIN_RESERVE_RATIO) {
1691             reserveRatio = newRatio_;
1692             emit NewReserveRate(reserveRatio);
1693         }
1694     }
1695 
1696     // in case any eth get sent
1697     function safeTransferETH(address to, uint value) 
1698         public
1699         linkLPGov
1700     {
1701         (bool success,) = to.call{value:value}(new bytes(0));
1702         require(success, 'ETH_TRANSFER_FAILED');
1703     }
1704 
1705     /// @notice Move stimulus - multisig only
1706     function moveStimulus(
1707         address location,
1708         uint256 amount
1709     )
1710         public
1711         linkLPGov
1712     {
1713         SafeERC20.safeTransfer(IERC20(stimulus), location, amount);
1714     }
1715 
1716     function executeTransaction(address target, uint value, string memory signature, bytes memory data) public payable linkLPGov returns (bytes memory) {
1717         bytes memory callData;
1718 
1719         if (bytes(signature).length == 0) {
1720             callData = data;
1721         } else {
1722             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
1723         }
1724 
1725         // solium-disable-next-line security/no-call-value
1726         (bool success, bytes memory returnData) = target.call.value(value)(callData);
1727         require(success, "oneLINK::executeTransaction: Transaction execution reverted.");
1728 
1729         return returnData;
1730     }
1731 
1732 }