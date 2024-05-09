1 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0;
6 
7 interface AggregatorV3Interface {
8 
9   function decimals() external view returns (uint8);
10   function description() external view returns (string memory);
11   function version() external view returns (uint256);
12 
13   // getRoundData and latestRoundData should both raise "No data present"
14   // if they do not have data to report, instead of returning unset values
15   // which could be misinterpreted as actual reported values.
16   function getRoundData(uint80 _roundId)
17     external
18     view
19     returns (
20       uint80 roundId,
21       int256 answer,
22       uint256 startedAt,
23       uint256 updatedAt,
24       uint80 answeredInRound
25     );
26   function latestRoundData()
27     external
28     view
29     returns (
30       uint80 roundId,
31       int256 answer,
32       uint256 startedAt,
33       uint256 updatedAt,
34       uint80 answeredInRound
35     );
36 
37 }
38 
39 // File: @openzeppelin/contracts/math/SafeMath.sol
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
957 // File: contracts/oneETH.sol
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
970     // Return the average time weighted price of oneETH (the Ethereum stable coin),
971     // the collateral (USDC, DAI, etc), and the cryptocurrencies (ETH, BTC, etc).
972     // This includes functions for changing the time interval for average,
973     // updating the oracle price, and returning the current price.
974     function changeInterval(uint256 seconds_) external;
975     function update() external;
976     function consult(address token, uint amountIn) external view returns (uint amountOut);
977 }
978 
979 interface IWETH {
980     // This is used to auto-convert ETH into WETH.
981     function deposit() external payable;
982     function transfer(address to, uint value) external returns (bool);
983     function withdraw(uint) external;
984 }
985 
986 contract oneETH is ERC20("oneETH", "oneETH"), Ownable, ReentrancyGuard {
987     // oneETH is the first fractionally backed stable coin that is especially designed for
988     // the Ethereum community.  In its fractional phase, ETH will be paid into the contract
989     // to mint new oneETH.  The Ethereum community will govern this ETH treasury, spending it
990     // on public goods, to re-collateralize oneETH, or on discount and perks for consumers to
991     // adopt oneETH or ETH.
992     //
993     // This contract is ownable and the owner has tremendous power.  This ownership will be
994     // transferred to a multi-sig contract controlled by signers elected by the community.
995     //
996     // Thanks for reading the contract and happy farming!
997     using SafeMath for uint256;
998 
999     // At 100% reserve ratio, each oneETH is backed 1-to-1 by $1 of existing stable coins
1000     uint256 constant public MAX_RESERVE_RATIO = 100 * 10 ** 9;
1001     uint256 private constant DECIMALS = 9;
1002     uint256 public lastRefreshReserve; // The last time the reserve ratio was updated by the contract
1003     uint256 public minimumRefreshTime; // The time between reserve ratio refreshes
1004 
1005     address public stimulus; // oneETH builds a stimulus fund in ETH.
1006     uint256 public stimulusDecimals; // used to calculate oracle rate of Uniswap Pair
1007 
1008     // We get the price of ETH from Chainlink!  Thanks chainLink!  Hopefully, the chainLink
1009     // will provide Oracle prices for oneETH, oneBTC, etc in the future.  For now, we will get those
1010     // from the ichi.farm exchange which uses Uniswap contracts.
1011     AggregatorV3Interface internal chainlinkStimulusOracle;
1012     AggregatorV3Interface internal ethPrice;
1013 
1014 
1015     address public oneTokenOracle; // oracle for the oneETH stable coin
1016     address public stimulusOracle;  // oracle for a stimulus cryptocurrency that isn't on chainLink
1017     bool public chainLink;         // true means it is a chainLink oracle
1018 
1019     // Only governance should cause the coin to go fully agorithmic by changing the minimum reserve
1020     // ratio.  For now, we will set a conservative minimum reserve ratio.
1021     uint256 public MIN_RESERVE_RATIO;
1022 
1023     // Makes sure that you can't send coins to a 0 address and prevents coins from being sent to the
1024     // contract address. I want to protect your funds! 
1025     modifier validRecipient(address to) {
1026         require(to != address(0x0));
1027         require(to != address(this));
1028         _;
1029     }
1030 
1031     uint256 private _totalSupply;
1032     mapping(address => uint256) private _oneBalances;
1033     mapping(address => uint256) private _lastCall;
1034     mapping (address => mapping (address => uint256)) private _allowedOne;
1035 
1036     address public wethAddress;
1037     address public gov;
1038     // allows you to transfer the governance to a different user - they must accept it!
1039     address public pendingGov;
1040     uint256 public reserveStepSize; // step size of update of reserve rate (e.g. 5 * 10 ** 8 = 0.5%)
1041     uint256 public reserveRatio;    // a number between 0 and 100 * 10 ** 9.
1042                                     // 0 = 0%
1043                                     // 100 * 10 ** 9 = 100%
1044 
1045     // map of acceptable collaterals
1046     mapping (address => bool) public acceptedCollateral;
1047     address[] public collateralArray;
1048 
1049     // modifier to allow auto update of TWAP oracle prices
1050     // also updates reserves rate programatically
1051     modifier updateProtocol() {
1052         if (address(oneTokenOracle) != address(0)) {
1053             // only update if stimulusOracle is set
1054             if (!chainLink) IUniswapOracle(stimulusOracle).update();
1055 
1056             // this is always updated because we always need stablecoin oracle price
1057             IUniswapOracle(oneTokenOracle).update();
1058 
1059             for (uint i = 0; i < collateralArray.length; i++){ 
1060                 if (acceptedCollateral[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).update();
1061             }
1062 
1063             // update reserve ratio if enough time has passed
1064             if (block.timestamp - lastRefreshReserve >= minimumRefreshTime) {
1065                 // $Z / 1 one token
1066                 if (getOneTokenUsd() > 1 * 10 ** 9) {
1067                     setReserveRatio(reserveRatio.sub(reserveStepSize));
1068                 } else {
1069                     setReserveRatio(reserveRatio.add(reserveStepSize));
1070                 }
1071 
1072                 lastRefreshReserve = block.timestamp;
1073             }
1074         }
1075         
1076         _;
1077     }
1078 
1079     event NewPendingGov(address oldPendingGov, address newPendingGov);
1080     event NewGov(address oldGov, address newGov);
1081     event NewReserveRate(uint256 reserveRatio);
1082     event Mint(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1083     event Withdraw(address stimulus, address receiver, address collateral, uint256 collateralAmount, uint256 stimulusAmount, uint256 oneAmount);
1084     event NewMinimumRefreshTime(uint256 minimumRefreshTime);
1085 
1086     modifier onlyIchiGov() {
1087         require(msg.sender == gov, "ACCESS: only Ichi governance");
1088         _;
1089     }
1090 
1091     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
1092     mapping (address => uint256) public collateralDecimals;
1093     mapping (address => bool) public previouslySeenCollateral;
1094     mapping (address => address) public collateralOracle;       // address of the Collateral-ETH Uniswap Price
1095 
1096     // default to 0
1097     uint256 public mintFee;
1098     uint256 public withdrawFee;
1099     uint256 public minBlockFreeze;
1100 
1101     // fee to charge when minting oneETH - this will go into collateral
1102     event MintFee(uint256 fee_);
1103     // fee to charge when redeeming oneETH - this will go into collateral
1104     event WithdrawFee(uint256 fee_);
1105 
1106     // set governance access to only oneETH - ETH pool multisig (elected after rewards)
1107     modifier ethLPGov() {
1108         require(msg.sender == lpGov, "ACCESS: only ethLP governance");
1109         _;
1110     }
1111 
1112     address public lpGov;
1113     address public pendingLPGov;
1114 
1115     event NewPendingLPGov(address oldPendingLPGov, address newPendingLPGov);
1116     event NewLPGov(address oldLPGov, address newLPGov);
1117 
1118     // important: make sure changeInterval is a function to allow the interval of update to change
1119     function addCollateral(address collateral_, uint256 collateralDecimal_, address oracleAddress_)
1120         external
1121         ethLPGov
1122     {
1123         // only add collateral once
1124         if (!previouslySeenCollateral[collateral_]) collateralArray.push(collateral_);
1125 
1126         previouslySeenCollateral[collateral_] = true;
1127         acceptedCollateral[collateral_] = true;
1128         collateralDecimals[collateral_] = collateralDecimal_;
1129         collateralOracle[collateral_] = oracleAddress_;
1130     }
1131 
1132     function setReserveStepSize(uint256 stepSize_)
1133         external
1134         ethLPGov
1135     {
1136         reserveStepSize = stepSize_;
1137     }
1138 
1139     function setCollateralOracle(address collateral_, address oracleAddress_)
1140         external
1141         ethLPGov
1142     {
1143         require(acceptedCollateral[collateral_], "invalid collateral");
1144         collateralOracle[collateral_] = oracleAddress_;
1145     }
1146 
1147     function removeCollateral(address collateral_)
1148         external
1149         ethLPGov
1150     {
1151         acceptedCollateral[collateral_] = false;
1152     }
1153 
1154     // returns 10 ** 9 price of collateral
1155     function getCollateralUsd(address collateral_) public view returns (uint256) {
1156         // price is $Y / ETH (10 ** 8 decimals)
1157         ( , int price, , uint timeStamp, ) = ethPrice.latestRoundData();
1158         require(timeStamp > 0, "Rounds not complete");
1159 
1160         return uint256(price).mul(10 ** 10).div((IUniswapOracle(collateralOracle[collateral_]).consult(wethAddress, 10 ** 18)).mul(10 ** 9).div(10 ** collateralDecimals[collateral_]));
1161     }
1162 
1163     function globalCollateralValue() public view returns (uint256) {
1164         uint256 totalCollateralUsd = 0; 
1165 
1166         for (uint i = 0; i < collateralArray.length; i++){ 
1167             // Exclude null addresses
1168             if (collateralArray[i] != address(0)){
1169                 totalCollateralUsd += IERC20(collateralArray[i]).balanceOf(address(this)).mul(10 ** 9).div(10 ** collateralDecimals[collateralArray[i]]).mul(getCollateralUsd(collateralArray[i])).div(10 ** 9); // add stablecoin balance
1170             }
1171 
1172         }
1173         return totalCollateralUsd;
1174     }
1175 
1176     // return price of oneETH in 10 ** 9 decimal
1177     function getOneTokenUsd()
1178         public
1179         view
1180         returns (uint256)
1181     {
1182         uint256 oneTokenPrice = IUniswapOracle(oneTokenOracle).consult(stimulus, 10 ** stimulusDecimals); // X one tokens (10 ** 9) / 1 stimulus token
1183         uint256 stimulusTWAP = getStimulusOracle(); // $Y / 1 stimulus (10 ** 9)
1184 
1185         uint256 oneTokenUsd = stimulusTWAP.mul(10 ** 9).div(oneTokenPrice); // 10 ** 9 decimals
1186         return oneTokenUsd;
1187     }
1188 
1189     /**
1190      * @return The total number of oneETH.
1191      */
1192     function totalSupply()
1193         public
1194         override
1195         view
1196         returns (uint256)
1197     {
1198         return _totalSupply;
1199     }
1200 
1201     /**
1202      * @param who The address to query.
1203      * @return The balance of the specified address.
1204      */
1205     function balanceOf(address who)
1206         public
1207         override
1208         view
1209         returns (uint256)
1210     {
1211         return _oneBalances[who];
1212     }
1213 
1214     // oracle asset for collateral (oneETH is ETH, oneWHBAR is WHBAR, etc...)
1215     function setChainLinkStimulusOracle(address oracle_)
1216         external
1217         ethLPGov
1218         returns (bool)
1219     {
1220         chainlinkStimulusOracle = AggregatorV3Interface(oracle_);
1221         chainLink = true;
1222 
1223         return true;
1224     }
1225 
1226     /**
1227      * @dev Transfer tokens to a specified address.
1228      * @param to The address to transfer to.
1229      * @param value The amount to be transferred.
1230      * @return True on success, false otherwise.
1231      */
1232     function transfer(address to, uint256 value)
1233         public
1234         override
1235         validRecipient(to)
1236         updateProtocol()
1237         returns (bool)
1238     {
1239         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(value);
1240         _oneBalances[to] = _oneBalances[to].add(value);
1241         emit Transfer(msg.sender, to, value);
1242 
1243         return true;
1244     }
1245 
1246     /**
1247      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
1248      * @param owner_ The address which owns the funds.
1249      * @param spender The address which will spend the funds.
1250      * @return The number of tokens still available for the spender.
1251      */
1252     function allowance(address owner_, address spender)
1253         public
1254         override
1255         view
1256         returns (uint256)
1257     {
1258         return _allowedOne[owner_][spender];
1259     }
1260 
1261     /**
1262      * @dev Transfer tokens from one address to another.
1263      * @param from The address you want to send tokens from.
1264      * @param to The address you want to transfer to.
1265      * @param value The amount of tokens to be transferred.
1266      */
1267     function transferFrom(address from, address to, uint256 value)
1268         public
1269         override
1270         validRecipient(to)
1271         updateProtocol()
1272         returns (bool)
1273     {
1274         _allowedOne[from][msg.sender] = _allowedOne[from][msg.sender].sub(value);
1275 
1276         _oneBalances[from] = _oneBalances[from].sub(value);
1277         _oneBalances[to] = _oneBalances[to].add(value);
1278         emit Transfer(from, to, value);
1279 
1280         return true;
1281     }
1282 
1283     /**
1284      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
1285      * msg.sender. This method is included for ERC20 compatibility.
1286      * increaseAllowance and decreaseAllowance should be used instead.
1287      * Changing an allowance with this method brings the risk that someone may transfer both
1288      * the old and the new allowance - if they are both greater than zero - if a transfer
1289      * transaction is mined before the later approve() call is mined.
1290      *
1291      * @param spender The address which will spend the funds.
1292      * @param value The amount of tokens to be spent.
1293      */
1294     function approve(address spender, uint256 value)
1295         public
1296         override
1297         validRecipient(spender)
1298         updateProtocol()
1299         returns (bool)
1300     {
1301         _allowedOne[msg.sender][spender] = value;
1302         emit Approval(msg.sender, spender, value);
1303         return true;
1304     }
1305 
1306     /**
1307      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1308      * This method should be used instead of approve() to avoid the double approval vulnerability
1309      * described above.
1310      * @param spender The address which will spend the funds.
1311      * @param addedValue The amount of tokens to increase the allowance by.
1312      */
1313     function increaseAllowance(address spender, uint256 addedValue)
1314         public
1315         override
1316         returns (bool)
1317     {
1318         _allowedOne[msg.sender][spender] = _allowedOne[msg.sender][spender].add(addedValue);
1319         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1320         return true;
1321     }
1322 
1323     /**
1324      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1325      *
1326      * @param spender The address which will spend the funds.
1327      * @param subtractedValue The amount of tokens to decrease the allowance by.
1328      */
1329     function decreaseAllowance(address spender, uint256 subtractedValue)
1330         public
1331         override
1332         returns (bool)
1333     {
1334         uint256 oldValue = _allowedOne[msg.sender][spender];
1335         if (subtractedValue >= oldValue) {
1336             _allowedOne[msg.sender][spender] = 0;
1337         } else {
1338             _allowedOne[msg.sender][spender] = oldValue.sub(subtractedValue);
1339         }
1340         emit Approval(msg.sender, spender, _allowedOne[msg.sender][spender]);
1341         return true;
1342     }
1343 
1344     function setOneOracle(address oracle_)
1345         external
1346         ethLPGov
1347         returns (bool) 
1348     {
1349         oneTokenOracle = oracle_;
1350         
1351         return true;
1352     }
1353 
1354     function setStimulusUniswapOracle(address oracle_)
1355         external
1356         ethLPGov
1357         returns (bool)
1358     {
1359         stimulusOracle = oracle_;
1360         chainLink = false;
1361 
1362         return true;
1363     }
1364 
1365     // oracle rate is 10 ** 9 decimals
1366     // returns $Z / Stimulus
1367     function getStimulusOracle()
1368         public
1369         view
1370         returns (uint256)
1371     {
1372         if (chainLink) {
1373             (
1374                 uint80 roundID, 
1375                 int price,
1376                 uint startedAt,
1377                 uint timeStamp,
1378                 uint80 answeredInRound
1379             ) = chainlinkStimulusOracle.latestRoundData();
1380 
1381             require(timeStamp > 0, "Rounds not complete");
1382 
1383             return uint256(price).mul(10); // 10 ** 9 price
1384         } else {
1385             // stimulusTWAP has `stimulusDecimals` decimals
1386             uint256 stimulusTWAP = IUniswapOracle(stimulusOracle).consult(wethAddress, 1 * 10 ** 18); // 1 ETH = X Stimulus, or X Stimulus / ETH
1387 
1388             // price is $Y / ETH
1389             (
1390                 uint80 roundID, 
1391                 int price,
1392                 uint startedAt,
1393                 uint timeStamp,
1394                 uint80 answeredInRound
1395             ) = ethPrice.latestRoundData();
1396 
1397             require(timeStamp > 0, "Rounds not complete");
1398 
1399             return uint256(price).mul(10 ** stimulusDecimals).div(stimulusTWAP); // 10 ** 9 price
1400         }
1401     }
1402 
1403     // minimum amount of block time (seconds) required for an update in reserve ratio
1404     function setMinimumRefreshTime(uint256 val_)
1405         external
1406         ethLPGov
1407         returns (bool)
1408     {
1409         require(val_ != 0, "minimum refresh time must be valid");
1410 
1411         minimumRefreshTime = val_;
1412 
1413         // change collateral array
1414         for (uint i = 0; i < collateralArray.length; i++){ 
1415             if (acceptedCollateral[collateralArray[i]]) IUniswapOracle(collateralOracle[collateralArray[i]]).changeInterval(val_);
1416         }
1417 
1418         // stimulus and oneToken oracle update
1419         IUniswapOracle(oneTokenOracle).changeInterval(val_);
1420         if (!chainLink) IUniswapOracle(stimulusOracle).changeInterval(val_);
1421 
1422         // change all the oracles (collateral, stimulus, oneToken)
1423 
1424         emit NewMinimumRefreshTime(val_);
1425         return true;
1426     }
1427 
1428     // tokenSymbol: oneETH etc...
1429     // stimulus_: address of the stimulus (ETH, wBTC, wHBAR)...
1430     // stimulusDecimals_: decimals of stimulus (e.g. 18)
1431     // wethAddress_: address of WETH
1432     // ethOracleChainLink_: address of chainlink oracle for ETH / USD
1433 
1434     // don't forget to set oracle for stimulus later (ETH, wBTC etc probably can use Chainlink, others use Uniswap)
1435     // chain link stimulus:     setChainLinkStimulusOracle(address)
1436     // uniswap stimulus:        setStimulusUniswapOracle(address)  
1437     constructor(
1438         uint256 reserveRatio_,
1439         address stimulus_,
1440         uint256 stimulusDecimals_,
1441         address wethAddress_,
1442         address ethOracleChainLink_,
1443         uint256 minBlockFreeze_
1444     )
1445         public
1446     {   
1447         _setupDecimals(uint8(9));
1448         stimulus = stimulus_;
1449         minimumRefreshTime = 3600 * 1; // 1 hour by default
1450         stimulusDecimals = stimulusDecimals_;
1451         minBlockFreeze = block.number.add(minBlockFreeze_);
1452         reserveStepSize = 1 * 10 ** 8;  // 0.1% by default
1453         ethPrice = AggregatorV3Interface(ethOracleChainLink_);
1454         MIN_RESERVE_RATIO = 90 * 10 ** 9;
1455         wethAddress = wethAddress_;
1456         withdrawFee = 1 * 10 ** 8; // 0.1% fee at first, remains in collateral
1457         gov = msg.sender;
1458         lpGov = msg.sender;
1459         reserveRatio = reserveRatio_;
1460         _totalSupply = 10 ** 9;
1461 
1462         _oneBalances[msg.sender] = 10 ** 9;
1463         emit Transfer(address(0x0), msg.sender, 10 ** 9);
1464     }
1465     
1466     function setMinimumReserveRatio(uint256 val_)
1467         external
1468         ethLPGov
1469     {
1470         MIN_RESERVE_RATIO = val_;
1471     }
1472 
1473     // LP pool governance ====================================
1474     function setPendingLPGov(address pendingLPGov_)
1475         external
1476         ethLPGov
1477     {
1478         address oldPendingLPGov = pendingLPGov;
1479         pendingLPGov = pendingLPGov_;
1480         emit NewPendingLPGov(oldPendingLPGov, pendingLPGov_);
1481     }
1482 
1483     function acceptLPGov()
1484         external
1485     {
1486         require(msg.sender == pendingLPGov, "!pending");
1487         address oldLPGov = lpGov; // that
1488         lpGov = pendingLPGov;
1489         pendingLPGov = address(0);
1490         emit NewGov(oldLPGov, lpGov);
1491     }
1492 
1493     // over-arching protocol level governance  ===============
1494     function setPendingGov(address pendingGov_)
1495         external
1496         onlyIchiGov
1497     {
1498         address oldPendingGov = pendingGov;
1499         pendingGov = pendingGov_;
1500         emit NewPendingGov(oldPendingGov, pendingGov_);
1501     }
1502 
1503     function acceptGov()
1504         external
1505     {
1506         require(msg.sender == pendingGov, "!pending");
1507         address oldGov = gov;
1508         gov = pendingGov;
1509         pendingGov = address(0);
1510         emit NewGov(oldGov, gov);
1511     }
1512     // ======================================================
1513 
1514     // calculates how much you will need to send in order to mint oneETH, depending on current market prices + reserve ratio
1515     // oneAmount: the amount of oneETH you want to mint
1516     // collateral: the collateral you want to use to pay
1517     // also works in the reverse direction, i.e. how much collateral + stimulus to receive when you burn One
1518     function consultOneDeposit(uint256 oneAmount, address collateral)
1519         public
1520         view
1521         returns (uint256, uint256)
1522     {
1523         require(oneAmount != 0, "must use valid oneAmount");
1524         require(acceptedCollateral[collateral], "must be an accepted collateral");
1525 
1526         // convert to correct decimals for collateral
1527         uint256 collateralAmount = oneAmount.mul(reserveRatio).div(MAX_RESERVE_RATIO).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1528         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1529 
1530         if (address(oneTokenOracle) == address(0)) return (collateralAmount, 0);
1531 
1532         uint256 oneTokenUsd = getOneTokenUsd();             // 10 ** 9
1533         uint256 oneCollateralUsd = getStimulusOracle();     // 10 ** 9
1534 
1535         uint256 stimulusAmountInOneStablecoin = oneAmount.mul(MAX_RESERVE_RATIO.sub(reserveRatio)).div(MAX_RESERVE_RATIO);
1536 
1537         uint256 stimulusAmount = stimulusAmountInOneStablecoin.mul(oneTokenUsd).div(oneCollateralUsd).mul(10 ** stimulusDecimals).div(10 ** DECIMALS); // must be 10 ** stimulusDecimals
1538 
1539         return (collateralAmount, stimulusAmount);
1540     }
1541 
1542     function consultOneWithdraw(uint256 oneAmount, address collateral)
1543         public
1544         view
1545         returns (uint256, uint256)
1546     {
1547         require(oneAmount != 0, "must use valid oneAmount");
1548         require(acceptedCollateral[collateral], "must be an accepted collateral");
1549 
1550         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1551         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1552 
1553         return (collateralAmount, 0);
1554     }
1555 
1556     // @title: deposit collateral + stimulus token
1557     // collateral: address of the collateral to deposit (USDC, DAI, TUSD, etc)
1558     function mint(
1559         uint256 oneAmount,
1560         address collateral
1561     )
1562         public
1563         payable
1564         validRecipient(msg.sender)
1565         nonReentrant
1566     {
1567         require(acceptedCollateral[collateral], "must be an accepted collateral");
1568 
1569         // wait 3 blocks to avoid flash loans
1570         require((_lastCall[msg.sender] + 30) <= block.timestamp, "action too soon - please wait a few more blocks");
1571 
1572         // validate input amounts are correct
1573         (uint256 collateralAmount, uint256 stimulusAmount) = consultOneDeposit(oneAmount, collateral);
1574         require(collateralAmount <= IERC20(collateral).balanceOf(msg.sender), "sender has insufficient collateral balance");
1575 
1576         // auto convert ETH to WETH if needed
1577         bool convertedWeth = false;
1578         if (stimulus == wethAddress && IERC20(stimulus).balanceOf(msg.sender) < stimulusAmount) {
1579             // enough ETH
1580             if (address(msg.sender).balance >= stimulusAmount) {
1581                 IWETH(wethAddress).deposit{value: stimulusAmount}();
1582                 assert(IWETH(wethAddress).transfer(address(this), stimulusAmount));
1583                 if (msg.value > stimulusAmount) safeTransferETH(msg.sender, msg.value - stimulusAmount);
1584                 convertedWeth = true;
1585             } else {
1586                 require(stimulusAmount <= IERC20(stimulus).balanceOf(msg.sender), "sender has insufficient stimulus balance");
1587             }
1588         }
1589 
1590         // checks passed, so transfer tokens
1591         SafeERC20.safeTransferFrom(IERC20(collateral), msg.sender, address(this), collateralAmount);
1592 
1593         if (!convertedWeth) SafeERC20.safeTransferFrom(IERC20(stimulus), msg.sender, address(this), stimulusAmount);
1594 
1595         // apply mint fee
1596         oneAmount = oneAmount.sub(oneAmount.mul(mintFee).div(100 * 10 ** DECIMALS));
1597 
1598         _totalSupply = _totalSupply.add(oneAmount);
1599         _oneBalances[msg.sender] = _oneBalances[msg.sender].add(oneAmount);
1600 
1601         _lastCall[msg.sender] = block.timestamp;
1602 
1603         emit Transfer(address(0x0), msg.sender, oneAmount);
1604         emit Mint(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
1605     }
1606 
1607     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1608     function editMintFee(uint256 fee_)
1609         external
1610         onlyIchiGov
1611     {
1612         mintFee = fee_;
1613         emit MintFee(fee_);
1614     }
1615 
1616     // fee_ should be 10 ** 9 decimals (e.g. 10% = 10 * 10 ** 9)
1617     function editWithdrawFee(uint256 fee_)
1618         external
1619         onlyIchiGov
1620     {
1621         withdrawFee = fee_;
1622         emit WithdrawFee(fee_);
1623     }
1624 
1625     // @title: burn oneETH and receive collateral + stimulus token
1626     // oneAmount: amount of oneToken to burn to withdraw
1627     function withdraw(
1628         uint256 oneAmount,
1629         address collateral
1630     )
1631         public
1632         validRecipient(msg.sender)
1633         nonReentrant
1634         updateProtocol()
1635     {
1636         require(oneAmount <= _oneBalances[msg.sender], "insufficient balance");
1637         require((_lastCall[msg.sender] + 30) <= block.timestamp, "action too soon - please wait 3 blocks");
1638 
1639         // burn oneAmount
1640         _totalSupply = _totalSupply.sub(oneAmount);
1641         _oneBalances[msg.sender] = _oneBalances[msg.sender].sub(oneAmount);
1642 
1643         // send collateral - fee (convert to collateral decimals too)
1644         uint256 collateralAmount = oneAmount.sub(oneAmount.mul(withdrawFee).div(100 * 10 ** DECIMALS)).mul(10 ** collateralDecimals[collateral]).div(10 ** DECIMALS);
1645         collateralAmount = collateralAmount.mul(10 ** 9).div(getCollateralUsd(collateral));
1646 
1647         uint256 stimulusAmount = 0;
1648 
1649         // check enough reserves - don't want to burn one coin if we cannot fulfill withdrawal
1650         require(collateralAmount <= IERC20(collateral).balanceOf(address(this)), "insufficient collateral reserves - try another collateral");
1651 
1652         SafeERC20.safeTransfer(IERC20(collateral), msg.sender, collateralAmount);
1653 
1654         _lastCall[msg.sender] = block.timestamp;
1655 
1656         emit Transfer(msg.sender, address(0x0), oneAmount);
1657         emit Withdraw(stimulus, msg.sender, collateral, collateralAmount, stimulusAmount, oneAmount);
1658     }
1659 
1660     // change reserveRatio
1661     // market driven -> decide the ratio automatically
1662     // if one coin >= $1, we lower reserve rate by half a percent
1663     // if one coin < $1, we increase reserve rate
1664     function setReserveRatio(uint256 newRatio_)
1665         internal
1666     {
1667         require(newRatio_ >= 0, "positive reserve ratio");
1668 
1669         if (newRatio_ <= MAX_RESERVE_RATIO && newRatio_ >= MIN_RESERVE_RATIO) {
1670             reserveRatio = newRatio_;
1671             emit NewReserveRate(reserveRatio);
1672         }
1673     }
1674 
1675     function safeTransferETH(address to, uint value) internal {
1676         (bool success,) = to.call{value:value}(new bytes(0));
1677         require(success, 'ETH_TRANSFER_FAILED');
1678     }
1679 
1680     /// @notice Move stimulus - multisig only
1681     function moveStimulus(
1682         address location,
1683         uint256 amount
1684     )
1685         public
1686         ethLPGov
1687     {
1688         require(block.number > minBlockFreeze, "minBlockFreeze time limit not met yet - try again later");
1689         SafeERC20.safeTransfer(IERC20(stimulus), location, amount);
1690     }
1691 
1692 }