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
39 // SPDX-License-Identifier: MIT
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Wrappers over Solidity's arithmetic operations with added overflow
45  * checks.
46  *
47  * Arithmetic operations in Solidity wrap on overflow. This can easily result
48  * in bugs, because programmers usually assume that an overflow raises an
49  * error, which is the standard behavior in high level programming languages.
50  * `SafeMath` restores this intuition by reverting the transaction when an
51  * operation overflows.
52  *
53  * Using this library instead of the unchecked operations eliminates an entire
54  * class of bugs, so it's recommended to use it always.
55  */
56 library SafeMath {
57     /**
58      * @dev Returns the addition of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `+` operator.
62      *
63      * Requirements:
64      *
65      * - Addition cannot overflow.
66      */
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a, "SafeMath: addition overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the subtraction of two unsigned integers, reverting on
76      * overflow (when the result is negative).
77      *
78      * Counterpart to Solidity's `-` operator.
79      *
80      * Requirements:
81      *
82      * - Subtraction cannot overflow.
83      */
84     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
85         return sub(a, b, "SafeMath: subtraction overflow");
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      *
96      * - Subtraction cannot overflow.
97      */
98     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         require(b <= a, errorMessage);
100         uint256 c = a - b;
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117         // benefit is lost if 'b' is also tested.
118         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
119         if (a == 0) {
120             return 0;
121         }
122 
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers. Reverts on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator. Note: this function uses a
134      * `revert` opcode (which leaves remaining gas untouched) while Solidity
135      * uses an invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function div(uint256 a, uint256 b) internal pure returns (uint256) {
142         return div(a, b, "SafeMath: division by zero");
143     }
144 
145     /**
146      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
147      * division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator. Note: this function uses a
150      * `revert` opcode (which leaves remaining gas untouched) while Solidity
151      * uses an invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b > 0, errorMessage);
159         uint256 c = a / b;
160         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * Reverts when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return mod(a, b, "SafeMath: modulo by zero");
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * Reverts with custom message when dividing by zero.
184      *
185      * Counterpart to Solidity's `%` operator. This function uses a `revert`
186      * opcode (which leaves remaining gas untouched) while Solidity uses an
187      * invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b != 0, errorMessage);
195         return a % b;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
200 
201 pragma solidity ^0.6.0;
202 
203 /**
204  * @dev Interface of the ERC20 standard as defined in the EIP.
205  */
206 interface IERC20 {
207     /**
208      * @dev Returns the amount of tokens in existence.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns the amount of tokens owned by `account`.
214      */
215     function balanceOf(address account) external view returns (uint256);
216 
217     /**
218      * @dev Moves `amount` tokens from the caller's account to `recipient`.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Returns the remaining number of tokens that `spender` will be
228      * allowed to spend on behalf of `owner` through {transferFrom}. This is
229      * zero by default.
230      *
231      * This value changes when {approve} or {transferFrom} are called.
232      */
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     /**
236      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * IMPORTANT: Beware that changing an allowance with this method brings the risk
241      * that someone may use both the old and the new allowance by unfortunate
242      * transaction ordering. One possible solution to mitigate this race
243      * condition is to first reduce the spender's allowance to 0 and set the
244      * desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Moves `amount` tokens from `sender` to `recipient` using the
253      * allowance mechanism. `amount` is then deducted from the caller's
254      * allowance.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
261 
262     /**
263      * @dev Emitted when `value` tokens are moved from one account (`from`) to
264      * another (`to`).
265      *
266      * Note that `value` may be zero.
267      */
268     event Transfer(address indexed from, address indexed to, uint256 value);
269 
270     /**
271      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
272      * a call to {approve}. `value` is the new allowance.
273      */
274     event Approval(address indexed owner, address indexed spender, uint256 value);
275 }
276 
277 // File: @openzeppelin/contracts/utils/Address.sol
278 
279 pragma solidity ^0.6.2;
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies in extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { size := extcodesize(account) }
310         return size > 0;
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
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
333         (bool success, ) = recipient.call{ value: amount }("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain`call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356       return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
366         return _functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         return _functionCallWithValue(target, data, value, errorMessage);
393     }
394 
395     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
396         require(isContract(target), "Address: call to non-contract");
397 
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 // solhint-disable-next-line no-inline-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
420 
421 pragma solidity ^0.6.0;
422 
423 
424 
425 
426 /**
427  * @title SafeERC20
428  * @dev Wrappers around ERC20 operations that throw on failure (when the token
429  * contract returns false). Tokens that return no value (and instead revert or
430  * throw on failure) are also supported, non-reverting calls are assumed to be
431  * successful.
432  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
433  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
434  */
435 library SafeERC20 {
436     using SafeMath for uint256;
437     using Address for address;
438 
439     function safeTransfer(IERC20 token, address to, uint256 value) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
441     }
442 
443     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
444         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
445     }
446 
447     /**
448      * @dev Deprecated. This function has issues similar to the ones found in
449      * {IERC20-approve}, and its usage is discouraged.
450      *
451      * Whenever possible, use {safeIncreaseAllowance} and
452      * {safeDecreaseAllowance} instead.
453      */
454     function safeApprove(IERC20 token, address spender, uint256 value) internal {
455         // safeApprove should only be called when setting an initial allowance,
456         // or when resetting it to zero. To increase and decrease it, use
457         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
458         // solhint-disable-next-line max-line-length
459         require((value == 0) || (token.allowance(address(this), spender) == 0),
460             "SafeERC20: approve from non-zero to non-zero allowance"
461         );
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
463     }
464 
465     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).add(value);
467         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
471         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
472         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
473     }
474 
475     /**
476      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
477      * on the return value: the return value is optional (but if data is returned, it must not be false).
478      * @param token The token targeted by the call.
479      * @param data The call data (encoded using abi.encode or one of its variants).
480      */
481     function _callOptionalReturn(IERC20 token, bytes memory data) private {
482         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
483         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
484         // the target address contains contract code and also asserts for success in the low-level call.
485 
486         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
487         if (returndata.length > 0) { // Return data is optional
488             // solhint-disable-next-line max-line-length
489             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
495 
496 pragma solidity ^0.6.0;
497 
498 /**
499  * @dev Contract module that helps prevent reentrant calls to a function.
500  *
501  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
502  * available, which can be applied to functions to make sure there are no nested
503  * (reentrant) calls to them.
504  *
505  * Note that because there is a single `nonReentrant` guard, functions marked as
506  * `nonReentrant` may not call one another. This can be worked around by making
507  * those functions `private`, and then adding `external` `nonReentrant` entry
508  * points to them.
509  *
510  * TIP: If you would like to learn more about reentrancy and alternative ways
511  * to protect against it, check out our blog post
512  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
513  */
514 contract ReentrancyGuard {
515     // Booleans are more expensive than uint256 or any type that takes up a full
516     // word because each write operation emits an extra SLOAD to first read the
517     // slot's contents, replace the bits taken up by the boolean, and then write
518     // back. This is the compiler's defense against contract upgrades and
519     // pointer aliasing, and it cannot be disabled.
520 
521     // The values being non-zero value makes deployment a bit more expensive,
522     // but in exchange the refund on every call to nonReentrant will be lower in
523     // amount. Since refunds are capped to a percentage of the total
524     // transaction's gas, it is best to keep them low in cases like this one, to
525     // increase the likelihood of the full refund coming into effect.
526     uint256 private constant _NOT_ENTERED = 1;
527     uint256 private constant _ENTERED = 2;
528 
529     uint256 private _status;
530 
531     constructor () internal {
532         _status = _NOT_ENTERED;
533     }
534 
535     /**
536      * @dev Prevents a contract from calling itself, directly or indirectly.
537      * Calling a `nonReentrant` function from another `nonReentrant`
538      * function is not supported. It is possible to prevent this from happening
539      * by making the `nonReentrant` function external, and make it call a
540      * `private` function that does the actual work.
541      */
542     modifier nonReentrant() {
543         // On the first call to nonReentrant, _notEntered will be true
544         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
545 
546         // Any calls to nonReentrant after this point will fail
547         _status = _ENTERED;
548 
549         _;
550 
551         // By storing the original value once again, a refund is triggered (see
552         // https://eips.ethereum.org/EIPS/eip-2200)
553         _status = _NOT_ENTERED;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/GSN/Context.sol
558 
559 pragma solidity ^0.6.0;
560 
561 /*
562  * @dev Provides information about the current execution context, including the
563  * sender of the transaction and its data. While these are generally available
564  * via msg.sender and msg.data, they should not be accessed in such a direct
565  * manner, since when dealing with GSN meta-transactions the account sending and
566  * paying for execution may not be the actual sender (as far as an application
567  * is concerned).
568  *
569  * This contract is only required for intermediate, library-like contracts.
570  */
571 abstract contract Context {
572     function _msgSender() internal view virtual returns (address payable) {
573         return msg.sender;
574     }
575 
576     function _msgData() internal view virtual returns (bytes memory) {
577         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
578         return msg.data;
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
583 
584 pragma solidity ^0.6.0;
585 
586 
587 
588 
589 
590 /**
591  * @dev Implementation of the {IERC20} interface.
592  *
593  * This implementation is agnostic to the way tokens are created. This means
594  * that a supply mechanism has to be added in a derived contract using {_mint}.
595  * For a generic mechanism see {ERC20PresetMinterPauser}.
596  *
597  * TIP: For a detailed writeup see our guide
598  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
599  * to implement supply mechanisms].
600  *
601  * We have followed general OpenZeppelin guidelines: functions revert instead
602  * of returning `false` on failure. This behavior is nonetheless conventional
603  * and does not conflict with the expectations of ERC20 applications.
604  *
605  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
606  * This allows applications to reconstruct the allowance for all accounts just
607  * by listening to said events. Other implementations of the EIP may not emit
608  * these events, as it isn't required by the specification.
609  *
610  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
611  * functions have been added to mitigate the well-known issues around setting
612  * allowances. See {IERC20-approve}.
613  */
614 contract ERC20 is Context, IERC20 {
615     using SafeMath for uint256;
616     using Address for address;
617 
618     mapping (address => uint256) private _balances;
619 
620     mapping (address => mapping (address => uint256)) private _allowances;
621 
622     uint256 private _totalSupply;
623 
624     string private _name;
625     string private _symbol;
626     uint8 private _decimals;
627 
628     /**
629      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
630      * a default value of 18.
631      *
632      * To select a different value for {decimals}, use {_setupDecimals}.
633      *
634      * All three of these values are immutable: they can only be set once during
635      * construction.
636      */
637     constructor (string memory name, string memory symbol) public {
638         _name = name;
639         _symbol = symbol;
640         _decimals = 18;
641     }
642 
643     /**
644      * @dev Returns the name of the token.
645      */
646     function name() public view returns (string memory) {
647         return _name;
648     }
649 
650     /**
651      * @dev Returns the symbol of the token, usually a shorter version of the
652      * name.
653      */
654     function symbol() public view returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev Returns the number of decimals used to get its user representation.
660      * For example, if `decimals` equals `2`, a balance of `505` tokens should
661      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
662      *
663      * Tokens usually opt for a value of 18, imitating the relationship between
664      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
665      * called.
666      *
667      * NOTE: This information is only used for _display_ purposes: it in
668      * no way affects any of the arithmetic of the contract, including
669      * {IERC20-balanceOf} and {IERC20-transfer}.
670      */
671     function decimals() public view returns (uint8) {
672         return _decimals;
673     }
674 
675     /**
676      * @dev See {IERC20-totalSupply}.
677      */
678     function totalSupply() public view override virtual returns (uint256) {
679         return _totalSupply;
680     }
681 
682     /**
683      * @dev See {IERC20-balanceOf}.
684      */
685     function balanceOf(address account) public view override virtual returns (uint256) {
686         return _balances[account];
687     }
688 
689     /**
690      * @dev See {IERC20-transfer}.
691      *
692      * Requirements:
693      *
694      * - `recipient` cannot be the zero address.
695      * - the caller must have a balance of at least `amount`.
696      */
697     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
698         _transfer(_msgSender(), recipient, amount);
699         return true;
700     }
701 
702     /**
703      * @dev See {IERC20-allowance}.
704      */
705     function allowance(address owner, address spender) public view virtual override returns (uint256) {
706         return _allowances[owner][spender];
707     }
708 
709     /**
710      * @dev See {IERC20-approve}.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      */
716     function approve(address spender, uint256 amount) public virtual override returns (bool) {
717         _approve(_msgSender(), spender, amount);
718         return true;
719     }
720 
721     /**
722      * @dev See {IERC20-transferFrom}.
723      *
724      * Emits an {Approval} event indicating the updated allowance. This is not
725      * required by the EIP. See the note at the beginning of {ERC20};
726      *
727      * Requirements:
728      * - `sender` and `recipient` cannot be the zero address.
729      * - `sender` must have a balance of at least `amount`.
730      * - the caller must have allowance for ``sender``'s tokens of at least
731      * `amount`.
732      */
733     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
734         _transfer(sender, recipient, amount);
735         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
736         return true;
737     }
738 
739     /**
740      * @dev Atomically increases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {IERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      */
751     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
752         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
753         return true;
754     }
755 
756     /**
757      * @dev Atomically decreases the allowance granted to `spender` by the caller.
758      *
759      * This is an alternative to {approve} that can be used as a mitigation for
760      * problems described in {IERC20-approve}.
761      *
762      * Emits an {Approval} event indicating the updated allowance.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      * - `spender` must have allowance for the caller of at least
768      * `subtractedValue`.
769      */
770     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
771         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
772         return true;
773     }
774 
775     /**
776      * @dev Moves tokens `amount` from `sender` to `recipient`.
777      *
778      * This is internal function is equivalent to {transfer}, and can be used to
779      * e.g. implement automatic token fees, slashing mechanisms, etc.
780      *
781      * Emits a {Transfer} event.
782      *
783      * Requirements:
784      *
785      * - `sender` cannot be the zero address.
786      * - `recipient` cannot be the zero address.
787      * - `sender` must have a balance of at least `amount`.
788      */
789     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
790         require(sender != address(0), "ERC20: transfer from the zero address");
791         require(recipient != address(0), "ERC20: transfer to the zero address");
792 
793         _beforeTokenTransfer(sender, recipient, amount);
794 
795         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
796         _balances[recipient] = _balances[recipient].add(amount);
797         emit Transfer(sender, recipient, amount);
798     }
799 
800     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
801      * the total supply.
802      *
803      * Emits a {Transfer} event with `from` set to the zero address.
804      *
805      * Requirements
806      *
807      * - `to` cannot be the zero address.
808      */
809     function _mint(address account, uint256 amount) internal virtual {
810         require(account != address(0), "ERC20: mint to the zero address");
811 
812         _beforeTokenTransfer(address(0), account, amount);
813 
814         _totalSupply = _totalSupply.add(amount);
815         _balances[account] = _balances[account].add(amount);
816         emit Transfer(address(0), account, amount);
817     }
818 
819     /**
820      * @dev Destroys `amount` tokens from `account`, reducing the
821      * total supply.
822      *
823      * Emits a {Transfer} event with `to` set to the zero address.
824      *
825      * Requirements
826      *
827      * - `account` cannot be the zero address.
828      * - `account` must have at least `amount` tokens.
829      */
830     function _burn(address account, uint256 amount) internal virtual {
831         require(account != address(0), "ERC20: burn from the zero address");
832 
833         _beforeTokenTransfer(account, address(0), amount);
834 
835         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
836         _totalSupply = _totalSupply.sub(amount);
837         emit Transfer(account, address(0), amount);
838     }
839 
840     /**
841      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
842      *
843      * This internal function is equivalent to `approve`, and can be used to
844      * e.g. set automatic allowances for certain subsystems, etc.
845      *
846      * Emits an {Approval} event.
847      *
848      * Requirements:
849      *
850      * - `owner` cannot be the zero address.
851      * - `spender` cannot be the zero address.
852      */
853     function _approve(address owner, address spender, uint256 amount) internal virtual {
854         require(owner != address(0), "ERC20: approve from the zero address");
855         require(spender != address(0), "ERC20: approve to the zero address");
856 
857         _allowances[owner][spender] = amount;
858         emit Approval(owner, spender, amount);
859     }
860 
861     /**
862      * @dev Sets {decimals} to a value other than the default one of 18.
863      *
864      * WARNING: This function should only be called from the constructor. Most
865      * applications that interact with token contracts will not expect
866      * {decimals} to ever change, and may work incorrectly if it does.
867      */
868     function _setupDecimals(uint8 decimals_) internal {
869         _decimals = decimals_;
870     }
871 
872     /**
873      * @dev Hook that is called before any transfer of tokens. This includes
874      * minting and burning.
875      *
876      * Calling conditions:
877      *
878      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
879      * will be to transferred to `to`.
880      * - when `from` is zero, `amount` tokens will be minted for `to`.
881      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
882      * - `from` and `to` are never both zero.
883      *
884      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
885      */
886     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
887 }
888 
889 // File: @openzeppelin/contracts/access/Ownable.sol
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
957 // File: contracts/oneBTC.sol
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
968     // We need the current prices of just about everything for the system to work!
969     // 
970     // Return the average time weighted price of oneBTC (the Bitcoin stable coin),
971     // the collateral (USDC, DAI, etc), and the cryptocurrencies (BTC, BTC, etc).
972     // This includes functions for changing the time interval for average,
973     // updating the oracle price, and returning the current price.
974     function changeInterval(uint256 seconds_) external;
975     function update() external;
976     function consult(address token, uint amountIn) external view returns (uint amountOut);
977 }
978 
979 contract oneBTC is ERC20("oneBTC", "oneBTC"), Ownable, ReentrancyGuard {
980     // oneBTC is the first fractionally backed stable coin that is especially designed for
981     // the Ethereum community.  In its fractional phase, BTC will be paid into the contract
982     // to mint new oneBTC.  The Ethereum community will govern this BTC treasury, spending it
983     // on public goods, to re-collateralize oneBTC, or on discount and perks for consumers to
984     // adopt oneBTC or BTC.
985     //
986     // This contract is ownable and the owner has tremendous power.  This ownership will be
987     // transferred to a multi-sig contract controlled by signers elected by the community.
988     //
989     // Thanks for reading the contract and happy farming!
990     using SafeMath for uint256;
991 
992     // At 100% reserve ratio, each oneBTC is backed 1-to-1 by $1 of existing stable coins
993     uint256 constant public MAX_RESERVE_RATIO = 100 * 10 ** 9;
994     uint256 private constant DECIMALS = 9;
995     uint256 public lastRefreshReserve; // The last time the reserve ratio was updated by the contract
996     uint256 public minimumRefreshTime; // The time between reserve ratio refreshes
997 
998     address public stimulus; // oneBTC builds a stimulus fund in BTC.
999     uint256 public stimulusDecimals; // used to calculate oracle rate of Uniswap Pair
1000 
1001     // We get the price of BTC from Chainlink!  Thanks chainLink!  Hopefully, the chainLink
1002     // will provide Oracle prices for oneBTC, oneBTC, etc in the future.  For now, we will get those
1003     // from the ichi.farm exchange which uses Uniswap contracts.
1004     AggregatorV3Interface internal chainlinkStimulusOracle;
1005     AggregatorV3Interface internal ethPrice;
1006 
1007 
1008     address public oneTokenOracle; // oracle for the oneBTC stable coin
1009     address public stimulusOracle;  // oracle for a stimulus cryptocurrency that isn't on chainLink
1010     bool public chainLink;         // true means it is a chainLink oracle
1011 
1012     // Only governance should cause the coin to go fully agorithmic by changing the minimum reserve
1013     // ratio.  For now, we will set a conservative minimum reserve ratio.
1014     uint256 public MIN_RESERVE_RATIO;
1015     uint256 public MIN_DELAY;
1016 
1017     // Makes sure that you can't send coins to a 0 address and prevents coins from being sent to the
1018     // contract address. I want to protect your funds! 
1019     modifier validRecipient(address to) {
1020         require(to != address(0x0));
1021         require(to != address(this));
1022         _;
1023     }
1024 
1025     uint256 private _totalSupply;
1026     mapping(address => uint256) private _oneBalances;
1027     mapping(address => uint256) private _lastCall;
1028     mapping (address => mapping (address => uint256)) private _allowedOne;
1029 
1030     address public wethAddress;
1031     address public ethUsdcUniswapOracle;
1032     address public gov;
1033     // allows you to transfer the governance to a different user - they must accept it!
1034     address public pendingGov;
1035     uint256 public reserveStepSize; // step size of update of reserve rate (e.g. 5 * 10 ** 8 = 0.5%)
1036     uint256 public reserveRatio;    // a number between 0 and 100 * 10 ** 9.
1037                                     // 0 = 0%
1038                                     // 100 * 10 ** 9 = 100%
1039 
1040     // map of acceptable collaterals
1041     mapping (address => bool) public acceptedCollateral;
1042     address[] public collateralArray;
1043 
1044     // modifier to allow auto update of TWAP oracle prices
1045     // also updates reserves rate programatically
1046     modifier updateProtocol() {
1047         if (address(oneTokenOracle) != address(0)) {
1048             // only update if stimulusOracle is set
1049             if (!chainLink) IUniswapOracle(stimulusOracle).update();
1050 
1051             // this is always updated because we always need stablecoin oracle price
1052             IUniswapOracle(oneTokenOracle).update();
1053 
1054             for (uint i = 0; i < collateralArray.length; i++){ 
1055                 if (acceptedCollateral[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).update();
1056             }
1057 
1058             // update reserve ratio if enough time has passed
1059             if (block.timestamp - lastRefreshReserve >= minimumRefreshTime) {
1060                 // $Z / 1 one token
1061                 if (getOneTokenUsd() > 1 * 10 ** 9) {
1062                     setReserveRatio(reserveRatio.sub(reserveStepSize));
1063                 } else {
1064                     setReserveRatio(reserveRatio.add(reserveStepSize));
1065                 }
1066 
1067                 lastRefreshReserve = block.timestamp;
1068             }
1069         }
1070         
1071         _;
1072     }
1073 
1074     event NewPendingGov(address oldPendingGov, address newPendingGov);
1075     event NewGov(address oldGov, address newGov);
1076     event NewReserveRate(uint256 reserveRatio);
1077     event Mint(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1078     event Withdraw(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1079     event NewMinimumRefreshTime(uint256 minimumRefreshTime);
1080 
1081     modifier onlyIchiGov() {
1082         require(msg.sender == gov, "ACCESS: only Ichi governance");
1083         _;
1084     }
1085 
1086     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
1087     mapping (address => uint256) public collateralDecimals;
1088     mapping (address => bool) public previouslySeenCollateral;
1089     mapping (address => address) public collateralOracle;       // address of the Collateral-BTC Uniswap Price
1090 
1091     // default to 0
1092     uint256 public mintFee;
1093     uint256 public withdrawFee;
1094     uint256 public minBlockFreeze;
1095 
1096     // fee to charge when minting oneBTC - this will go into collateral
1097     event MintFee(uint256 fee_);
1098     // fee to charge when redeeming oneBTC - this will go into collateral
1099     event WithdrawFee(uint256 fee_);
1100 
1101     // set governance access to only oneBTC - BTC pool multisig (elected after rewards)
1102     modifier btcLPGov() {
1103         require(msg.sender == lpGov, "ACCESS: only btcLP governance");
1104         _;
1105     }
1106 
1107     address public lpGov;
1108     address public pendingLPGov;
1109 
1110     event NewPendingLPGov(address oldPendingLPGov, address newPendingLPGov);
1111     event NewLPGov(address oldLPGov, address newLPGov);
1112 
1113     mapping (address => uint256) private _burnedStablecoin; // maps user to burned oneBTC
1114 
1115     // important: make sure changeInterval is a function to allow the interval of update to change
1116     function addCollateral(address collateral_, uint256 collateralDecimal_, address oracleAddress_)
1117         external
1118         btcLPGov
1119     {
1120         // only add collateral once
1121         if (!previouslySeenCollateral[collateral_]) collateralArray.push(collateral_);
1122 
1123         previouslySeenCollateral[collateral_] = true;
1124         acceptedCollateral[collateral_] = true;
1125         collateralDecimals[collateral_] = collateralDecimal_;
1126         collateralOracle[collateral_] = oracleAddress_;
1127     }
1128 
1129     function setReserveStepSize(uint256 stepSize_)
1130         external
1131         btcLPGov
1132     {
1133         reserveStepSize = stepSize_;
1134     }
1135 
1136     function setCollateralOracle(address collateral_, address oracleAddress_)
1137         external
1138         btcLPGov
1139     {
1140         require(acceptedCollateral[collateral_], "invalid collateral");
1141         collateralOracle[collateral_] = oracleAddress_;
1142     }
1143 
1144     function removeCollateral(address collateral_)
1145         external
1146         btcLPGov
1147     {
1148         acceptedCollateral[collateral_] = false;
1149     }
1150 
1151     // used for querying
1152     function getBurnedStablecoin(address _user)
1153         public
1154         view
1155         returns (uint256)
1156     {
1157         return _burnedStablecoin[_user];
1158     }
1159 
1160     // returns 10 ** 9 price of collateral
1161     function getCollateralUsd(address collateral_) public view returns (uint256) {
1162         require(previouslySeenCollateral[collateral_], "must be an existing collateral");
1163         uint256 ethUsdcTWAP = IUniswapOracle(ethUsdcUniswapOracle).consult(wethAddress, 1 * 10 ** 18);  // 1 ETH = X USDC (10 ^ 6 decimals)
1164         return ethUsdcTWAP.mul(10 ** 3).mul(10 ** 9).div((IUniswapOracle(collateralOracle[collateral_]).consult(wethAddress, 10 ** 18)).mul(10 ** 9).div(10 ** collateralDecimals[collateral_]));
1165     }
1166 
1167     function globalCollateralValue() public view returns (uint256) {
1168         uint256 totalCollateralUsd = 0; 
1169 
1170         for (uint i = 0; i < collateralArray.length; i++){ 
1171             // Exclude null addresses
1172             if (collateralArray[i] != address(0)){
1173                 totalCollateralUsd += IERC20(collateralArray[i]).balanceOf(address(this)).mul(10 ** 9).div(10 ** collateralDecimals[collateralArray[i]]).mul(getCollateralUsd(collateralArray[i])).div(10 ** 9); // add stablecoin balance
1174             }
1175 
1176         }
1177         return totalCollateralUsd;
1178     }
1179 
1180     // return price of oneBTC in 10 ** 9 decimal
1181     function getOneTokenUsd()
1182         public
1183         view
1184         returns (uint256)
1185     {
1186         uint256 oneTokenPrice = IUniswapOracle(oneTokenOracle).consult(stimulus, 10 ** stimulusDecimals); // X one tokens (10 ** 9) / 1 stimulus token
1187         uint256 stimulusTWAP = getStimulusOracle(); // $Y / 1 stimulus (10 ** 9)
1188 
1189         uint256 oneTokenUsd = stimulusTWAP.mul(10 ** 9).div(oneTokenPrice); // 10 ** 9 decimals
1190         return oneTokenUsd;
1191     }
1192 
1193     /**
1194      * @return The total number of oneBTC.
1195      */
1196     function totalSupply()
1197         public
1198         override
1199         view
1200         returns (uint256)
1201     {
1202         return _totalSupply;
1203     }
1204 
1205     /**
1206      * @param who The address to query.
1207      * @return The balance of the specified address.
1208      */
1209     function balanceOf(address who)
1210         public
1211         override
1212         view
1213         returns (uint256)
1214     {
1215         return _oneBalances[who];
1216     }
1217 
1218     // oracle asset for collateral (oneBTC is BTC, oneWHBAR is WHBAR, etc...)
1219     function setChainLinkStimulusOracle(address oracle_)
1220         external
1221         btcLPGov
1222         returns (bool)
1223     {
1224         chainlinkStimulusOracle = AggregatorV3Interface(oracle_);
1225         chainLink = true;
1226 
1227         return true;
1228     }
1229 
1230     /**
1231      * @dev Transfer tokens to a specified address.
1232      * @param to The address to transfer to.
1233      * @param value The amount to be transferred.
1234      * @return True on success, false otherwise.
1235      */
1236     function transfer(address to, uint256 value)
1237         public
1238         override
1239         validRecipient(to)
1240         updateProtocol()
1241         returns (bool)
1242     {
1243         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(value);
1244         _oneBalances[to] = _oneBalances[to].add(value);
1245         emit Transfer(msg.sender, to, value);
1246 
1247         return true;
1248     }
1249 
1250     /**
1251      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1252      * @param owner_ The address which owns the funds.
1253      * @param spender The address which will spend the funds.
1254      * @return The number of tokens still available for the spender.
1255      */
1256     function allowance(address owner_, address spender)
1257         public
1258         override
1259         view
1260         returns (uint256)
1261     {
1262         return _allowedOne[owner_][spender];
1263     }
1264 
1265     /**
1266      * @dev Transfer tokens from one address to another.
1267      * @param from The address you want to send tokens from.
1268      * @param to The address you want to transfer to.
1269      * @param value The amount of tokens to be transferred.
1270      */
1271     function transferFrom(address from, address to, uint256 value)
1272         public
1273         override
1274         validRecipient(to)
1275         updateProtocol()
1276         returns (bool)
1277     {
1278         _allowedOne[from][msg.sender] = _allowedOne[from][msg.sender].sub(value);
1279 
1280         _oneBalances[from] = _oneBalances[from].sub(value);
1281         _oneBalances[to] = _oneBalances[to].add(value);
1282         emit Transfer(from, to, value);
1283 
1284         return true;
1285     }
1286 
1287     /**
1288      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1289      * msg.sender. This method is included for ERC20 compatibility.
1290      * increaseAllowance and decreaseAllowance should be used instead.
1291      * Changing an allowance with this method brings the risk that someone may transfer both
1292      * the old and the new allowance - if they are both greater than zero - if a transfer
1293      * transaction is mined before the later approve() call is mined.
1294      *
1295      * @param spender The address which will spend the funds.
1296      * @param value The amount of tokens to be spent.
1297      */
1298     function approve(address spender, uint256 value)
1299         public
1300         override
1301         validRecipient(spender)
1302         updateProtocol()
1303         returns (bool)
1304     {
1305         _allowedOne[msg.sender][spender] = value;
1306         emit Approval(msg.sender, spender, value);
1307         return true;
1308     }
1309 
1310     /**
1311      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1312      * This method should be used instead of approve() to avoid the double approval vulnerability
1313      * described above.
1314      * @param spender The address which will spend the funds.
1315      * @param addedValue The amount of tokens to increase the allowance by.
1316      */
1317     function increaseAllowance(address spender, uint256 addedValue)
1318         public
1319         override
1320         returns (bool)
1321     {
1322         _allowedOne[msg.sender][spender] = _allowedOne[msg.sender][spender].add(addedValue);
1323         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1324         return true;
1325     }
1326 
1327     /**
1328      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1329      *
1330      * @param spender The address which will spend the funds.
1331      * @param subtractedValue The amount of tokens to decrease the allowance by.
1332      */
1333     function decreaseAllowance(address spender, uint256 subtractedValue)
1334         public
1335         override
1336         returns (bool)
1337     {
1338         uint256 oldValue = _allowedOne[msg.sender][spender];
1339         if (subtractedValue >= oldValue) {
1340             _allowedOne[msg.sender][spender] = 0;
1341         } else {
1342             _allowedOne[msg.sender][spender] = oldValue.sub(subtractedValue);
1343         }
1344         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1345         return true;
1346     }
1347 
1348     function setOneOracle(address oracle_)
1349         external
1350         btcLPGov
1351         returns (bool) 
1352     {
1353         oneTokenOracle = oracle_;
1354         
1355         return true;
1356     }
1357 
1358     function setEthUsdcUniswapOracle(address oracle_)
1359         external
1360         btcLPGov
1361         returns (bool)
1362     {
1363         ethUsdcUniswapOracle = oracle_;
1364 
1365         return true;
1366     }
1367 
1368     function setStimulusUniswapOracle(address oracle_)
1369         external
1370         btcLPGov
1371         returns (bool)
1372     {
1373         stimulusOracle = oracle_;
1374         chainLink = false;
1375 
1376         return true;
1377     }
1378 
1379     // oracle rate is 10 ** 9 decimals
1380     // returns $Z / Stimulus
1381     function getStimulusOracle()
1382         public
1383         view
1384         returns (uint256)
1385     {
1386         if (chainLink) {
1387             (
1388                 uint80 roundID, 
1389                 int price,
1390                 uint startedAt,
1391                 uint timeStamp,
1392                 uint80 answeredInRound
1393             ) = chainlinkStimulusOracle.latestRoundData();
1394 
1395             require(timeStamp > 0, "Rounds not complete");
1396 
1397             return uint256(price).mul(10); // 10 ** 9 price
1398         } else {
1399             // stimulusTWAP has `stimulusDecimals` decimals
1400             uint256 stimulusTWAP = IUniswapOracle(stimulusOracle).consult(wethAddress, 1 * 10 ** 18);       // 1 ETH = X Stimulus, or X Stimulus / ETH
1401             uint256 ethUsdcTWAP = IUniswapOracle(ethUsdcUniswapOracle).consult(wethAddress, 1 * 10 ** 18);  // 1 ETH = X USDC
1402 
1403             // X USDC / 1 ETH * (1 ETH / x Stimulus) = Y USDC / Stimulus
1404             return ethUsdcTWAP.mul(10 ** 3).mul(10 ** stimulusDecimals).div(stimulusTWAP); // 10 ** 9 price
1405         }
1406     }
1407 
1408     // minimum amount of block time (seconds) required for an update in reserve ratio
1409     function setMinimumRefreshTime(uint256 val_)
1410         external
1411         btcLPGov
1412         returns (bool)
1413     {
1414         require(val_ != 0, "minimum refresh time must be valid");
1415 
1416         minimumRefreshTime = val_;
1417 
1418         // change collateral array
1419         for (uint i = 0; i < collateralArray.length; i++){ 
1420             if (acceptedCollateral[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).changeInterval(val_);
1421         }
1422 
1423         IUniswapOracle(ethUsdcUniswapOracle).changeInterval(val_);
1424         // stimulus and oneToken oracle update
1425         IUniswapOracle(oneTokenOracle).changeInterval(val_);
1426         if (!chainLink) IUniswapOracle(stimulusOracle).changeInterval(val_);
1427 
1428         // change all the oracles (collateral, stimulus, oneToken)
1429 
1430         emit NewMinimumRefreshTime(val_);
1431         return true;
1432     }
1433 
1434     // tokenSymbol: oneBTC etc...
1435     // stimulus_: address of the stimulus (BTC, wBTC, wHBAR)...
1436     // stimulusDecimals_: decimals of stimulus (e.g. 18)
1437     // wethAddress_: address of WETH
1438     // ethOracleChainLink_: address of chainlink oracle for BTC / USD
1439 
1440     // don't forget to set oracle for stimulus later (BTC, wBTC etc probably can use Chainlink, others use Uniswap)
1441     // chain link stimulus:     setChainLinkStimulusOracle(address)
1442     // uniswap stimulus:        setStimulusUniswapOracle(address)  
1443     constructor(
1444         uint256 reserveRatio_,
1445         address stimulus_,
1446         uint256 stimulusDecimals_,
1447         address wethAddress_,
1448         address ethOracleChainLink_,
1449         address ethUsdcUniswap_,
1450         uint256 minBlockFreeze_
1451     )
1452         public
1453     {   
1454         _setupDecimals(uint8(9));
1455         stimulus = stimulus_;
1456         minimumRefreshTime = 3600 * 1; // 1 hour by default
1457         stimulusDecimals = stimulusDecimals_;
1458         minBlockFreeze = block.number.add(minBlockFreeze_);
1459         reserveStepSize = 1 * 10 ** 8;  // 0.1% by default
1460         ethPrice = AggregatorV3Interface(ethOracleChainLink_);
1461         ethUsdcUniswapOracle = ethUsdcUniswap_;
1462         MIN_RESERVE_RATIO = 90 * 10 ** 9;
1463         wethAddress = wethAddress_;
1464         MIN_DELAY = 3;             // 3 blocks
1465         withdrawFee = 1 * 10 ** 8; // 0.1% fee at first, remains in collateral
1466         gov = msg.sender;
1467         lpGov = msg.sender;
1468         reserveRatio = reserveRatio_;
1469         _totalSupply = 10 ** 9;
1470 
1471         _oneBalances[msg.sender] = 10 ** 9;
1472         emit Transfer(address(0x0), msg.sender, 10 ** 9);
1473     }
1474     
1475     function setMinimumReserveRatio(uint256 val_)
1476         external
1477         btcLPGov
1478     {
1479         MIN_RESERVE_RATIO = val_;
1480     }
1481 
1482     function setMinimumDelay(uint256 val_)
1483         external
1484         btcLPGov
1485     {
1486         MIN_DELAY = val_;
1487     }
1488 
1489     // LP pool governance ====================================
1490     function setPendingLPGov(address pendingLPGov_)
1491         external
1492         btcLPGov
1493     {
1494         address oldPendingLPGov = pendingLPGov;
1495         pendingLPGov = pendingLPGov_;
1496         emit NewPendingLPGov(oldPendingLPGov, pendingLPGov_);
1497     }
1498 
1499     function acceptLPGov()
1500         external
1501     {
1502         require(msg.sender == pendingLPGov, "!pending");
1503         address oldLPGov = lpGov; // that
1504         lpGov = pendingLPGov;
1505         pendingLPGov = address(0);
1506         emit NewGov(oldLPGov, lpGov);
1507     }
1508 
1509     // over-arching protocol level governance  ===============
1510     function setPendingGov(address pendingGov_)
1511         external
1512         onlyIchiGov
1513     {
1514         address oldPendingGov = pendingGov;
1515         pendingGov = pendingGov_;
1516         emit NewPendingGov(oldPendingGov, pendingGov_);
1517     }
1518 
1519     function acceptGov()
1520         external
1521     {
1522         require(msg.sender == pendingGov, "!pending");
1523         address oldGov = gov;
1524         gov = pendingGov;
1525         pendingGov = address(0);
1526         emit NewGov(oldGov, gov);
1527     }
1528     // ======================================================
1529 
1530     // calculates how much you will need to send in order to mint oneBTC, depending on current market prices + reserve ratio
1531     // oneAmount: the amount of oneBTC you want to mint
1532     // collateral: the collateral you want to use to pay
1533     // also works in the reverse direction, i.e. how much collateral + stimulus to receive when you burn One
1534     function consultOneDeposit(uint256 oneAmount, address collateral)
1535         public
1536         view
1537         returns (uint256, uint256)
1538     {
1539         require(oneAmount != 0, "must use valid oneAmount");
1540         require(acceptedCollateral[collateral], "must be an accepted collateral");
1541 
1542         // convert to correct decimals for collateral
1543         uint256 collateralAmount = oneAmount.mul(reserveRatio).div(MAX_RESERVE_RATIO).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1544         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1545 
1546         if (address(oneTokenOracle) == address(0)) return (collateralAmount, 0);
1547 
1548         uint256 stimulusUsd = getStimulusOracle();     // 10 ** 9
1549 
1550         uint256 stimulusAmountInOneStablecoin = oneAmount.mul(MAX_RESERVE_RATIO.sub(reserveRatio)).div(MAX_RESERVE_RATIO);
1551 
1552         uint256 stimulusAmount = stimulusAmountInOneStablecoin.mul(10 ** 9).div(stimulusUsd).mul(10 ** stimulusDecimals).div(10 ** DECIMALS); // must be 10 ** stimulusDecimals
1553 
1554         return (collateralAmount, stimulusAmount);
1555     }
1556 
1557     function consultOneWithdraw(uint256 oneAmount, address collateral)
1558         public
1559         view
1560         returns (uint256, uint256)
1561     {
1562         require(oneAmount != 0, "must use valid oneAmount");
1563         require(acceptedCollateral[collateral], "must be an accepted collateral");
1564 
1565         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1566         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1567 
1568         return (collateralAmount, 0);
1569     }
1570 
1571     // @title: deposit collateral + stimulus token
1572     // collateral: address of the collateral to deposit (USDC, DAI, TUSD, etc)
1573     function mint(
1574         uint256 oneAmount,
1575         address collateral
1576     )
1577         public
1578         payable
1579         nonReentrant
1580     {
1581         require(acceptedCollateral[collateral], "must be an accepted collateral");
1582         require(oneAmount != 0, "must mint non-zero amount");
1583 
1584         // wait 3 blocks to avoid flash loans
1585         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few more blocks");
1586 
1587         // validate input amounts are correct
1588         (uint256 collateralAmount, uint256 stimulusAmount) = consultOneDeposit(oneAmount, collateral);
1589         require(collateralAmount <= IERC20(collateral).balanceOf(msg.sender), "sender has insufficient collateral balance");
1590         require(stimulusAmount <= IERC20(stimulus).balanceOf(msg.sender), "sender has insufficient stimulus balance");
1591 
1592         // checks passed, so transfer tokens
1593         SafeERC20.safeTransferFrom(IERC20(collateral), msg.sender, address(this), collateralAmount);
1594         SafeERC20.safeTransferFrom(IERC20(stimulus), msg.sender, address(this), stimulusAmount);
1595 
1596         // apply mint fee
1597         oneAmount = oneAmount.sub(oneAmount.mul(mintFee).div(100 * 10 ** DECIMALS));
1598 
1599         _totalSupply = _totalSupply.add(oneAmount);
1600         _oneBalances[msg.sender] = _oneBalances[msg.sender].add(oneAmount);
1601 
1602         emit Transfer(address(0x0), msg.sender, oneAmount);
1603 
1604         _lastCall[msg.sender] = block.number;
1605 
1606         emit Mint(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
1607     }
1608 
1609     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1610     function editMintFee(uint256 fee_)
1611         external
1612         onlyIchiGov
1613     {
1614         mintFee = fee_;
1615         emit MintFee(fee_);
1616     }
1617 
1618     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1619     function editWithdrawFee(uint256 fee_)
1620         external
1621         onlyIchiGov
1622     {
1623         withdrawFee = fee_;
1624         emit WithdrawFee(fee_);
1625     }
1626 
1627     // @title: burn oneBTC and receive collateral + stimulus token
1628     // oneAmount: amount of oneToken to burn to withdraw
1629     function withdraw(
1630         uint256 oneAmount,
1631         address collateral
1632     )
1633         public
1634         nonReentrant
1635         updateProtocol()
1636     {
1637         require(oneAmount != 0, "must withdraw non-zero amount");
1638         require(oneAmount <= _oneBalances[msg.sender], "insufficient balance");
1639         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1640         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1641 
1642         // burn oneAmount
1643         _totalSupply = _totalSupply.sub(oneAmount);
1644         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(oneAmount);
1645 
1646         _burnedStablecoin[msg.sender] = _burnedStablecoin[msg.sender].add(oneAmount);
1647 
1648         _lastCall[msg.sender] = block.number;
1649         emit Transfer(msg.sender, address(0x0), oneAmount);
1650     }
1651 
1652     function withdrawFinal(address collateral)
1653         public
1654         nonReentrant
1655         updateProtocol()
1656     {
1657         require(previouslySeenCollateral[collateral], "must be an existing collateral");
1658         require((_lastCall[msg.sender] + MIN_DELAY) <= block.number, "action too soon - please wait a few blocks");
1659 
1660         uint256 oneAmount = _burnedStablecoin[msg.sender];
1661         require(oneAmount != 0, "insufficient oneBTC to redeem");
1662 
1663         _burnedStablecoin[msg.sender] = 0;
1664 
1665         // send collateral - fee (convert to collateral decimals too)
1666         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
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
1678         emit Withdraw(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
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
1699         btcLPGov
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
1711         btcLPGov
1712     {
1713         require(block.number > minBlockFreeze, "minBlockFreeze time limit not met yet - try again later");
1714         SafeERC20.safeTransfer(IERC20(stimulus), location, amount);
1715     }
1716 
1717 }