1 // File: contracts\interfaces\IRewardStaking.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 interface IRewardStaking {
7     function stakeFor(address, uint256) external;
8     function stake( uint256) external;
9     function withdraw(uint256 amount, bool claim) external;
10     function withdrawAndUnwrap(uint256 amount, bool claim) external;
11     function earned(address account) external view returns (uint256);
12     function getReward() external;
13     function getReward(address _account, bool _claimExtras) external;
14     function extraRewardsLength() external view returns (uint256);
15     function extraRewards(uint256 _pid) external view returns (address);
16     function rewardToken() external view returns (address);
17     function balanceOf(address _account) external view returns (uint256);
18     function rewardRate() external view returns(uint256);
19     function totalSupply() external view returns(uint256);
20 }
21 
22 // File: contracts\interfaces\IConvexDeposits.sol
23 
24 pragma solidity 0.6.12;
25 
26 interface IConvexDeposits {
27     function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns(bool);
28     function deposit(uint256 _amount, bool _lock, address _stakeAddress) external;
29 }
30 
31 // File: contracts\interfaces\IRewardHook.sol
32 
33 
34 pragma solidity 0.6.12;
35 
36 interface IRewardHook {
37     function onRewardClaim() external;
38 }
39 
40 // File: @openzeppelin\contracts\math\SafeMath.sol
41 
42 
43 pragma solidity >=0.6.0 <0.8.0;
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, with an overflow flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         uint256 c = a + b;
66         if (c < a) return (false, 0);
67         return (true, c);
68     }
69 
70     /**
71      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         if (b > a) return (false, 0);
77         return (true, a - b);
78     }
79 
80     /**
81      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
82      *
83      * _Available since v3.4._
84      */
85     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) return (true, 0);
90         uint256 c = a * b;
91         if (c / a != b) return (false, 0);
92         return (true, c);
93     }
94 
95     /**
96      * @dev Returns the division of two unsigned integers, with a division by zero flag.
97      *
98      * _Available since v3.4._
99      */
100     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
101         if (b == 0) return (false, 0);
102         return (true, a / b);
103     }
104 
105     /**
106      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
107      *
108      * _Available since v3.4._
109      */
110     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
111         if (b == 0) return (false, 0);
112         return (true, a % b);
113     }
114 
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b <= a, "SafeMath: subtraction overflow");
143         return a - b;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         if (a == 0) return 0;
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers, reverting on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b > 0, "SafeMath: division by zero");
177         return a / b;
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * reverting when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         require(b > 0, "SafeMath: modulo by zero");
194         return a % b;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
199      * overflow (when the result is negative).
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {trySub}.
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b <= a, errorMessage);
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * CAUTION: This function is deprecated because it requires allocating memory for the error
220      * message unnecessarily. For custom revert reasons use {tryDiv}.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         return a / b;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * reverting with custom message when dividing by zero.
238      *
239      * CAUTION: This function is deprecated because it requires allocating memory for the error
240      * message unnecessarily. For custom revert reasons use {tryMod}.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b > 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
257 
258 
259 pragma solidity >=0.6.0 <0.8.0;
260 
261 /**
262  * @dev Interface of the ERC20 standard as defined in the EIP.
263  */
264 interface IERC20 {
265     /**
266      * @dev Returns the amount of tokens in existence.
267      */
268     function totalSupply() external view returns (uint256);
269 
270     /**
271      * @dev Returns the amount of tokens owned by `account`.
272      */
273     function balanceOf(address account) external view returns (uint256);
274 
275     /**
276      * @dev Moves `amount` tokens from the caller's account to `recipient`.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transfer(address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Returns the remaining number of tokens that `spender` will be
286      * allowed to spend on behalf of `owner` through {transferFrom}. This is
287      * zero by default.
288      *
289      * This value changes when {approve} or {transferFrom} are called.
290      */
291     function allowance(address owner, address spender) external view returns (uint256);
292 
293     /**
294      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * IMPORTANT: Beware that changing an allowance with this method brings the risk
299      * that someone may use both the old and the new allowance by unfortunate
300      * transaction ordering. One possible solution to mitigate this race
301      * condition is to first reduce the spender's allowance to 0 and set the
302      * desired value afterwards:
303      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
304      *
305      * Emits an {Approval} event.
306      */
307     function approve(address spender, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Moves `amount` tokens from `sender` to `recipient` using the
311      * allowance mechanism. `amount` is then deducted from the caller's
312      * allowance.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Emitted when `value` tokens are moved from one account (`from`) to
322      * another (`to`).
323      *
324      * Note that `value` may be zero.
325      */
326     event Transfer(address indexed from, address indexed to, uint256 value);
327 
328     /**
329      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
330      * a call to {approve}. `value` is the new allowance.
331      */
332     event Approval(address indexed owner, address indexed spender, uint256 value);
333 }
334 
335 // File: @openzeppelin\contracts\utils\Address.sol
336 
337 
338 pragma solidity >=0.6.2 <0.8.0;
339 
340 /**
341  * @dev Collection of functions related to the address type
342  */
343 library Address {
344     /**
345      * @dev Returns true if `account` is a contract.
346      *
347      * [IMPORTANT]
348      * ====
349      * It is unsafe to assume that an address for which this function returns
350      * false is an externally-owned account (EOA) and not a contract.
351      *
352      * Among others, `isContract` will return false for the following
353      * types of addresses:
354      *
355      *  - an externally-owned account
356      *  - a contract in construction
357      *  - an address where a contract will be created
358      *  - an address where a contract lived, but was destroyed
359      * ====
360      */
361     function isContract(address account) internal view returns (bool) {
362         // This method relies on extcodesize, which returns 0 for contracts in
363         // construction, since the code is only stored at the end of the
364         // constructor execution.
365 
366         uint256 size;
367         // solhint-disable-next-line no-inline-assembly
368         assembly { size := extcodesize(account) }
369         return size > 0;
370     }
371 
372     /**
373      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
374      * `recipient`, forwarding all available gas and reverting on errors.
375      *
376      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
377      * of certain opcodes, possibly making contracts go over the 2300 gas limit
378      * imposed by `transfer`, making them unable to receive funds via
379      * `transfer`. {sendValue} removes this limitation.
380      *
381      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
382      *
383      * IMPORTANT: because control is transferred to `recipient`, care must be
384      * taken to not create reentrancy vulnerabilities. Consider using
385      * {ReentrancyGuard} or the
386      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
387      */
388     function sendValue(address payable recipient, uint256 amount) internal {
389         require(address(this).balance >= amount, "Address: insufficient balance");
390 
391         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
392         (bool success, ) = recipient.call{ value: amount }("");
393         require(success, "Address: unable to send value, recipient may have reverted");
394     }
395 
396     /**
397      * @dev Performs a Solidity function call using a low level `call`. A
398      * plain`call` is an unsafe replacement for a function call: use this
399      * function instead.
400      *
401      * If `target` reverts with a revert reason, it is bubbled up by this
402      * function (like regular Solidity function calls).
403      *
404      * Returns the raw returned data. To convert to the expected return value,
405      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
406      *
407      * Requirements:
408      *
409      * - `target` must be a contract.
410      * - calling `target` with `data` must not revert.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
415       return functionCall(target, data, "Address: low-level call failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
420      * `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
450         require(address(this).balance >= value, "Address: insufficient balance for call");
451         require(isContract(target), "Address: call to non-contract");
452 
453         // solhint-disable-next-line avoid-low-level-calls
454         (bool success, bytes memory returndata) = target.call{ value: value }(data);
455         return _verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
465         return functionStaticCall(target, data, "Address: low-level static call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
475         require(isContract(target), "Address: static call to non-contract");
476 
477         // solhint-disable-next-line avoid-low-level-calls
478         (bool success, bytes memory returndata) = target.staticcall(data);
479         return _verifyCallResult(success, returndata, errorMessage);
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
484      * but performing a delegate call.
485      *
486      * _Available since v3.4._
487      */
488     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
489         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
499         require(isContract(target), "Address: delegate call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) = target.delegatecall(data);
503         return _verifyCallResult(success, returndata, errorMessage);
504     }
505 
506     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 // solhint-disable-next-line no-inline-assembly
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
527 
528 
529 pragma solidity >=0.6.0 <0.8.0;
530 
531 
532 
533 /**
534  * @title SafeERC20
535  * @dev Wrappers around ERC20 operations that throw on failure (when the token
536  * contract returns false). Tokens that return no value (and instead revert or
537  * throw on failure) are also supported, non-reverting calls are assumed to be
538  * successful.
539  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
540  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
541  */
542 library SafeERC20 {
543     using SafeMath for uint256;
544     using Address for address;
545 
546     function safeTransfer(IERC20 token, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
548     }
549 
550     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
551         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
552     }
553 
554     /**
555      * @dev Deprecated. This function has issues similar to the ones found in
556      * {IERC20-approve}, and its usage is discouraged.
557      *
558      * Whenever possible, use {safeIncreaseAllowance} and
559      * {safeDecreaseAllowance} instead.
560      */
561     function safeApprove(IERC20 token, address spender, uint256 value) internal {
562         // safeApprove should only be called when setting an initial allowance,
563         // or when resetting it to zero. To increase and decrease it, use
564         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
565         // solhint-disable-next-line max-line-length
566         require((value == 0) || (token.allowance(address(this), spender) == 0),
567             "SafeERC20: approve from non-zero to non-zero allowance"
568         );
569         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
570     }
571 
572     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
573         uint256 newAllowance = token.allowance(address(this), spender).add(value);
574         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
575     }
576 
577     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
578         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
579         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
580     }
581 
582     /**
583      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
584      * on the return value: the return value is optional (but if data is returned, it must not be false).
585      * @param token The token targeted by the call.
586      * @param data The call data (encoded using abi.encode or one of its variants).
587      */
588     function _callOptionalReturn(IERC20 token, bytes memory data) private {
589         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
590         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
591         // the target address contains contract code and also asserts for success in the low-level call.
592 
593         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
594         if (returndata.length > 0) { // Return data is optional
595             // solhint-disable-next-line max-line-length
596             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
597         }
598     }
599 }
600 
601 // File: @openzeppelin\contracts\utils\Context.sol
602 
603 
604 pragma solidity >=0.6.0 <0.8.0;
605 
606 /*
607  * @dev Provides information about the current execution context, including the
608  * sender of the transaction and its data. While these are generally available
609  * via msg.sender and msg.data, they should not be accessed in such a direct
610  * manner, since when dealing with GSN meta-transactions the account sending and
611  * paying for execution may not be the actual sender (as far as an application
612  * is concerned).
613  *
614  * This contract is only required for intermediate, library-like contracts.
615  */
616 abstract contract Context {
617     function _msgSender() internal view virtual returns (address payable) {
618         return msg.sender;
619     }
620 
621     function _msgData() internal view virtual returns (bytes memory) {
622         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
623         return msg.data;
624     }
625 }
626 
627 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
628 
629 
630 pragma solidity >=0.6.0 <0.8.0;
631 
632 
633 
634 /**
635  * @dev Implementation of the {IERC20} interface.
636  *
637  * This implementation is agnostic to the way tokens are created. This means
638  * that a supply mechanism has to be added in a derived contract using {_mint}.
639  * For a generic mechanism see {ERC20PresetMinterPauser}.
640  *
641  * TIP: For a detailed writeup see our guide
642  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
643  * to implement supply mechanisms].
644  *
645  * We have followed general OpenZeppelin guidelines: functions revert instead
646  * of returning `false` on failure. This behavior is nonetheless conventional
647  * and does not conflict with the expectations of ERC20 applications.
648  *
649  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
650  * This allows applications to reconstruct the allowance for all accounts just
651  * by listening to said events. Other implementations of the EIP may not emit
652  * these events, as it isn't required by the specification.
653  *
654  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
655  * functions have been added to mitigate the well-known issues around setting
656  * allowances. See {IERC20-approve}.
657  */
658 contract ERC20 is Context, IERC20 {
659     using SafeMath for uint256;
660 
661     mapping (address => uint256) private _balances;
662 
663     mapping (address => mapping (address => uint256)) private _allowances;
664 
665     uint256 private _totalSupply;
666 
667     string private _name;
668     string private _symbol;
669     uint8 private _decimals;
670 
671     /**
672      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
673      * a default value of 18.
674      *
675      * To select a different value for {decimals}, use {_setupDecimals}.
676      *
677      * All three of these values are immutable: they can only be set once during
678      * construction.
679      */
680     constructor (string memory name_, string memory symbol_) public {
681         _name = name_;
682         _symbol = symbol_;
683         _decimals = 18;
684     }
685 
686     /**
687      * @dev Returns the name of the token.
688      */
689     function name() public view virtual returns (string memory) {
690         return _name;
691     }
692 
693     /**
694      * @dev Returns the symbol of the token, usually a shorter version of the
695      * name.
696      */
697     function symbol() public view virtual returns (string memory) {
698         return _symbol;
699     }
700 
701     /**
702      * @dev Returns the number of decimals used to get its user representation.
703      * For example, if `decimals` equals `2`, a balance of `505` tokens should
704      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
705      *
706      * Tokens usually opt for a value of 18, imitating the relationship between
707      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
708      * called.
709      *
710      * NOTE: This information is only used for _display_ purposes: it in
711      * no way affects any of the arithmetic of the contract, including
712      * {IERC20-balanceOf} and {IERC20-transfer}.
713      */
714     function decimals() public view virtual returns (uint8) {
715         return _decimals;
716     }
717 
718     /**
719      * @dev See {IERC20-totalSupply}.
720      */
721     function totalSupply() public view virtual override returns (uint256) {
722         return _totalSupply;
723     }
724 
725     /**
726      * @dev See {IERC20-balanceOf}.
727      */
728     function balanceOf(address account) public view virtual override returns (uint256) {
729         return _balances[account];
730     }
731 
732     /**
733      * @dev See {IERC20-transfer}.
734      *
735      * Requirements:
736      *
737      * - `recipient` cannot be the zero address.
738      * - the caller must have a balance of at least `amount`.
739      */
740     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
741         _transfer(_msgSender(), recipient, amount);
742         return true;
743     }
744 
745     /**
746      * @dev See {IERC20-allowance}.
747      */
748     function allowance(address owner, address spender) public view virtual override returns (uint256) {
749         return _allowances[owner][spender];
750     }
751 
752     /**
753      * @dev See {IERC20-approve}.
754      *
755      * Requirements:
756      *
757      * - `spender` cannot be the zero address.
758      */
759     function approve(address spender, uint256 amount) public virtual override returns (bool) {
760         _approve(_msgSender(), spender, amount);
761         return true;
762     }
763 
764     /**
765      * @dev See {IERC20-transferFrom}.
766      *
767      * Emits an {Approval} event indicating the updated allowance. This is not
768      * required by the EIP. See the note at the beginning of {ERC20}.
769      *
770      * Requirements:
771      *
772      * - `sender` and `recipient` cannot be the zero address.
773      * - `sender` must have a balance of at least `amount`.
774      * - the caller must have allowance for ``sender``'s tokens of at least
775      * `amount`.
776      */
777     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
778         _transfer(sender, recipient, amount);
779         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
780         return true;
781     }
782 
783     /**
784      * @dev Atomically increases the allowance granted to `spender` by the caller.
785      *
786      * This is an alternative to {approve} that can be used as a mitigation for
787      * problems described in {IERC20-approve}.
788      *
789      * Emits an {Approval} event indicating the updated allowance.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      */
795     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
796         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
797         return true;
798     }
799 
800     /**
801      * @dev Atomically decreases the allowance granted to `spender` by the caller.
802      *
803      * This is an alternative to {approve} that can be used as a mitigation for
804      * problems described in {IERC20-approve}.
805      *
806      * Emits an {Approval} event indicating the updated allowance.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      * - `spender` must have allowance for the caller of at least
812      * `subtractedValue`.
813      */
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
816         return true;
817     }
818 
819     /**
820      * @dev Moves tokens `amount` from `sender` to `recipient`.
821      *
822      * This is internal function is equivalent to {transfer}, and can be used to
823      * e.g. implement automatic token fees, slashing mechanisms, etc.
824      *
825      * Emits a {Transfer} event.
826      *
827      * Requirements:
828      *
829      * - `sender` cannot be the zero address.
830      * - `recipient` cannot be the zero address.
831      * - `sender` must have a balance of at least `amount`.
832      */
833     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
834         require(sender != address(0), "ERC20: transfer from the zero address");
835         require(recipient != address(0), "ERC20: transfer to the zero address");
836 
837         _beforeTokenTransfer(sender, recipient, amount);
838 
839         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
840         _balances[recipient] = _balances[recipient].add(amount);
841         emit Transfer(sender, recipient, amount);
842     }
843 
844     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
845      * the total supply.
846      *
847      * Emits a {Transfer} event with `from` set to the zero address.
848      *
849      * Requirements:
850      *
851      * - `to` cannot be the zero address.
852      */
853     function _mint(address account, uint256 amount) internal virtual {
854         require(account != address(0), "ERC20: mint to the zero address");
855 
856         _beforeTokenTransfer(address(0), account, amount);
857 
858         _totalSupply = _totalSupply.add(amount);
859         _balances[account] = _balances[account].add(amount);
860         emit Transfer(address(0), account, amount);
861     }
862 
863     /**
864      * @dev Destroys `amount` tokens from `account`, reducing the
865      * total supply.
866      *
867      * Emits a {Transfer} event with `to` set to the zero address.
868      *
869      * Requirements:
870      *
871      * - `account` cannot be the zero address.
872      * - `account` must have at least `amount` tokens.
873      */
874     function _burn(address account, uint256 amount) internal virtual {
875         require(account != address(0), "ERC20: burn from the zero address");
876 
877         _beforeTokenTransfer(account, address(0), amount);
878 
879         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
880         _totalSupply = _totalSupply.sub(amount);
881         emit Transfer(account, address(0), amount);
882     }
883 
884     /**
885      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
886      *
887      * This internal function is equivalent to `approve`, and can be used to
888      * e.g. set automatic allowances for certain subsystems, etc.
889      *
890      * Emits an {Approval} event.
891      *
892      * Requirements:
893      *
894      * - `owner` cannot be the zero address.
895      * - `spender` cannot be the zero address.
896      */
897     function _approve(address owner, address spender, uint256 amount) internal virtual {
898         require(owner != address(0), "ERC20: approve from the zero address");
899         require(spender != address(0), "ERC20: approve to the zero address");
900 
901         _allowances[owner][spender] = amount;
902         emit Approval(owner, spender, amount);
903     }
904 
905     /**
906      * @dev Sets {decimals} to a value other than the default one of 18.
907      *
908      * WARNING: This function should only be called from the constructor. Most
909      * applications that interact with token contracts will not expect
910      * {decimals} to ever change, and may work incorrectly if it does.
911      */
912     function _setupDecimals(uint8 decimals_) internal virtual {
913         _decimals = decimals_;
914     }
915 
916     /**
917      * @dev Hook that is called before any transfer of tokens. This includes
918      * minting and burning.
919      *
920      * Calling conditions:
921      *
922      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
923      * will be to transferred to `to`.
924      * - when `from` is zero, `amount` tokens will be minted for `to`.
925      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
926      * - `from` and `to` are never both zero.
927      *
928      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
929      */
930     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
931 }
932 
933 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
934 
935 
936 pragma solidity >=0.6.0 <0.8.0;
937 
938 /**
939  * @dev Contract module that helps prevent reentrant calls to a function.
940  *
941  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
942  * available, which can be applied to functions to make sure there are no nested
943  * (reentrant) calls to them.
944  *
945  * Note that because there is a single `nonReentrant` guard, functions marked as
946  * `nonReentrant` may not call one another. This can be worked around by making
947  * those functions `private`, and then adding `external` `nonReentrant` entry
948  * points to them.
949  *
950  * TIP: If you would like to learn more about reentrancy and alternative ways
951  * to protect against it, check out our blog post
952  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
953  */
954 abstract contract ReentrancyGuard {
955     // Booleans are more expensive than uint256 or any type that takes up a full
956     // word because each write operation emits an extra SLOAD to first read the
957     // slot's contents, replace the bits taken up by the boolean, and then write
958     // back. This is the compiler's defense against contract upgrades and
959     // pointer aliasing, and it cannot be disabled.
960 
961     // The values being non-zero value makes deployment a bit more expensive,
962     // but in exchange the refund on every call to nonReentrant will be lower in
963     // amount. Since refunds are capped to a percentage of the total
964     // transaction's gas, it is best to keep them low in cases like this one, to
965     // increase the likelihood of the full refund coming into effect.
966     uint256 private constant _NOT_ENTERED = 1;
967     uint256 private constant _ENTERED = 2;
968 
969     uint256 private _status;
970 
971     constructor () internal {
972         _status = _NOT_ENTERED;
973     }
974 
975     /**
976      * @dev Prevents a contract from calling itself, directly or indirectly.
977      * Calling a `nonReentrant` function from another `nonReentrant`
978      * function is not supported. It is possible to prevent this from happening
979      * by making the `nonReentrant` function external, and make it call a
980      * `private` function that does the actual work.
981      */
982     modifier nonReentrant() {
983         // On the first call to nonReentrant, _notEntered will be true
984         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
985 
986         // Any calls to nonReentrant after this point will fail
987         _status = _ENTERED;
988 
989         _;
990 
991         // By storing the original value once again, a refund is triggered (see
992         // https://eips.ethereum.org/EIPS/eip-2200)
993         _status = _NOT_ENTERED;
994     }
995 }
996 
997 // File: contracts\wrappers\CvxCrvStakingWrapper.sol
998 
999 pragma solidity 0.6.12;
1000 pragma experimental ABIEncoderV2;
1001 //Wrapper for staked cvxcrv that allows other incentives and user reward weighting
1002 
1003 //Based on Curve.fi's gauge wrapper implementations at https://github.com/curvefi/curve-dao-contracts/tree/master/contracts/gauges/wrappers
1004 contract CvxCrvStakingWrapper is ERC20, ReentrancyGuard {
1005     using SafeERC20
1006     for IERC20;
1007     using SafeMath
1008     for uint256;
1009 
1010     struct EarnedData {
1011         address token;
1012         uint256 amount;
1013     }
1014 
1015     struct RewardType {
1016         address reward_token;
1017         uint8 reward_group;
1018         uint128 reward_integral;
1019         uint128 reward_remaining;
1020         mapping(address => uint256) reward_integral_for;
1021         mapping(address => uint256) claimable_reward;
1022     }
1023 
1024     //constants/immutables
1025     address public constant crvDepositor = address(0x8014595F2AB54cD7c604B00E9fb932176fDc86Ae);
1026     address public constant cvxCrvStaking = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e);
1027     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
1028     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
1029     address public constant cvxCrv = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
1030     address public constant threeCrv = address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
1031     address public constant treasury = address(0x1389388d01708118b497f59521f6943Be2541bb7);
1032     uint256 private constant WEIGHT_PRECISION = 10000;
1033     uint256 private constant MAX_REWARD_COUNT = 10;
1034 
1035     //rewards
1036     RewardType[] public rewards;
1037     mapping(address => uint256) public registeredRewards;
1038     address public rewardHook;
1039     mapping (address => uint256) public userRewardWeight;
1040     uint256 public supplyWeight;
1041 
1042     //management
1043     bool public isShutdown;
1044     address public owner;
1045 
1046     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _isCrv);
1047     event Withdrawn(address indexed _user, uint256 _amount);
1048     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1049     event RewardInvalidated(address _rewardToken);
1050     event RewardGroupSet(address _rewardToken, uint256 _rewardGroup);
1051     event HookSet(address _rewardToken);
1052     event IsShutdown();
1053     event RewardPaid(address indexed _user, address indexed _token, uint256 _amount, address _receiver);
1054 
1055     constructor() public
1056         ERC20(
1057             "Staked CvxCrv",
1058             "stkCvxCrv"
1059         ){
1060 
1061         owner = address(0xa3C5A1e09150B75ff251c1a7815A07182c3de2FB); //default to convex multisig
1062         emit OwnershipTransferred(address(0), owner);
1063 
1064         addRewards();
1065         setApprovals();
1066 
1067         //preset hook
1068         rewardHook = address(0x723f9Aa67FDD9B0e375eF8553eB2AFC28eCD4a96);
1069         emit HookSet(rewardHook);
1070     }
1071 
1072 
1073     function decimals() public view override returns (uint8) {
1074         return 18;
1075     }
1076 
1077      modifier onlyOwner() {
1078         require(owner == msg.sender, "Ownable: caller is not the owner");
1079         _;
1080     }
1081 
1082     function transferOwnership(address newOwner) public virtual onlyOwner {
1083         require(newOwner != address(0), "Ownable: new owner is the zero address");
1084         emit OwnershipTransferred(owner, newOwner);
1085         owner = newOwner;
1086     }
1087 
1088     function renounceOwnership() public virtual onlyOwner {
1089         emit OwnershipTransferred(owner, address(0));
1090         owner = address(0);
1091     }
1092 
1093     function shutdown() external onlyOwner nonReentrant{
1094         isShutdown = true;
1095         emit IsShutdown();
1096     }
1097 
1098     function reclaim() external onlyOwner nonReentrant{
1099         require(isShutdown,"!shutdown");
1100 
1101         //reclaim extra staked cvxcrv tokens and return to treasury if this wrapper is shutdown
1102         //in order that the extra staking weight can be migrated
1103         uint256 extraTokens = IRewardStaking(cvxCrvStaking).balanceOf(address(this)) - totalSupply();
1104         IRewardStaking(cvxCrvStaking).withdraw(extraTokens, false);
1105         IERC20(cvxCrv).safeTransfer(treasury, extraTokens);
1106     }
1107 
1108     function setApprovals() public {
1109         IERC20(crv).safeApprove(crvDepositor, 0);
1110         IERC20(crv).safeApprove(crvDepositor, uint256(-1));
1111         IERC20(cvxCrv).safeApprove(cvxCrvStaking, 0);
1112         IERC20(cvxCrv).safeApprove(cvxCrvStaking, uint256(-1));
1113     }
1114 
1115     function addRewards() internal {
1116 
1117         if (rewards.length == 0) {
1118             rewards.push(
1119                 RewardType({
1120                     reward_token: crv,
1121                     reward_integral: 0,
1122                     reward_remaining: 0,
1123                     reward_group: 0
1124                 })
1125             );
1126             rewards.push(
1127                 RewardType({
1128                     reward_token: cvx,
1129                     reward_integral: 0,
1130                     reward_remaining: 0,
1131                     reward_group: 0
1132                 })
1133             );
1134             rewards.push(
1135                 RewardType({
1136                     reward_token: threeCrv,
1137                     reward_integral: 0,
1138                     reward_remaining: 0,
1139                     reward_group: 1
1140                 })
1141             );
1142             registeredRewards[crv] = 1; //mark registered at index+1
1143             registeredRewards[cvx] = 2; //mark registered at index+1
1144             registeredRewards[threeCrv] = 3; //mark registered at index+1
1145             //send to self to warmup state
1146             IERC20(crv).transfer(address(this),0);
1147             //send to self to warmup state
1148             IERC20(cvx).transfer(address(this),0);
1149             //send to self to warmup state
1150             IERC20(threeCrv).transfer(address(this),0);
1151 
1152             emit RewardGroupSet(crv, 0);
1153             emit RewardGroupSet(cvx, 0);
1154             emit RewardGroupSet(threeCrv, 1);
1155         }
1156     }
1157 
1158     function addTokenReward(address _token, uint256 _rewardGroup) public onlyOwner nonReentrant{
1159         require(_token != address(0) && _token != cvxCrvStaking && _token != address(this) && _token != cvxCrv,"invalid address");
1160 
1161         //check if already registered
1162         if(registeredRewards[_token] == 0){
1163             //limit reward count
1164             require(rewards.length < MAX_REWARD_COUNT, "max rewards");
1165             //new token, add token to list
1166             rewards.push(
1167                 RewardType({
1168                     reward_token: _token,
1169                     reward_integral: 0,
1170                     reward_remaining: 0,
1171                     reward_group: _rewardGroup > 0 ? uint8(1) : uint8(0)
1172                 })
1173             );
1174             //add to registered map
1175             registeredRewards[_token] = rewards.length; //mark registered at index+1
1176             //send to self to warmup state
1177             IERC20(_token).transfer(address(this),0);   
1178 
1179             emit RewardGroupSet(_token, _rewardGroup);
1180         }else{
1181             //get previous used index of given token
1182             //this ensures that reviving can only be done on the previous used slot
1183             uint256 index = registeredRewards[_token];
1184             if(index > 0){
1185                 //index is registeredRewards minus one
1186                 RewardType storage reward = rewards[index-1];
1187                 //check if it was invalidated
1188                 if(reward.reward_token == address(0)){
1189                     //revive
1190                     reward.reward_token = _token;
1191                 }
1192             }
1193         }
1194     }
1195 
1196     //allow invalidating a reward if the token causes trouble in calcRewardIntegral
1197     function invalidateReward(address _token) public onlyOwner {
1198         uint256 index = registeredRewards[_token];
1199         if(index > 0){
1200             //index is registered rewards minus one
1201             RewardType storage reward = rewards[index-1];
1202             require(reward.reward_token == _token, "!mismatch");
1203             //set reward token address to 0, integral calc will now skip
1204             reward.reward_token = address(0);
1205             emit RewardInvalidated(_token);
1206         }
1207     }
1208 
1209     //set reward group
1210     function setRewardGroup(address _token, uint256 _rewardGroup) public onlyOwner {
1211         //checkpoint
1212         _checkpoint([address(msg.sender),address(0)]);
1213 
1214         uint256 index = registeredRewards[_token];
1215         if(index > 0){
1216             //index is registered rewards minus one
1217             RewardType storage reward = rewards[index-1];
1218             reward.reward_group = _rewardGroup > 0 ? uint8(1) : uint8(0);
1219             emit RewardGroupSet(_token, _rewardGroup);
1220         }
1221     }
1222 
1223     function setHook(address _hook) external onlyOwner{
1224         rewardHook = _hook;
1225         emit HookSet(_hook);
1226     }
1227 
1228     function rewardLength() external view returns(uint256) {
1229         return rewards.length;
1230     }
1231 
1232 
1233     function _calcRewardIntegral(uint256 _index, address[2] memory _accounts, uint256[2] memory _balances, uint256 _supply, bool _isClaim) internal{
1234          RewardType storage reward = rewards[_index];
1235          //skip invalidated rewards
1236          //if a reward token starts throwing an error, calcRewardIntegral needs a way to exit
1237          if(reward.reward_token == address(0)){
1238             return;
1239          }
1240 
1241         //get difference in balance and remaining rewards
1242         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
1243         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
1244         
1245 
1246         if (bal.sub(reward.reward_remaining) > 0) {
1247             //adjust supply based on reward group
1248             if(reward.reward_group == 0){
1249                 //use inverse (supplyWeight can never be more than _supply)
1250                 _supply = (_supply - supplyWeight);
1251             }else{
1252                 //use supplyWeight
1253                 _supply = supplyWeight;
1254             }
1255 
1256             if(_supply > 0){
1257                 reward.reward_integral = reward.reward_integral + uint128(bal.sub(reward.reward_remaining).mul(1e20).div(_supply));
1258             }
1259         }
1260 
1261         //update user integrals
1262         for (uint256 u = 0; u < _accounts.length; u++) {
1263             //do not give rewards to address 0
1264             if (_accounts[u] == address(0)) continue;
1265             if(_isClaim && u != 0) continue; //if claiming, only update/claim for first address and use second as forwarding
1266 
1267             //adjust user balance based on reward group
1268             uint256 userb = _balances[u];
1269             if(reward.reward_group == 0){
1270                 //use userRewardWeight inverse: weight of 0 should be full reward group 0
1271                 userb = userb * (WEIGHT_PRECISION - userRewardWeight[_accounts[u]]) / WEIGHT_PRECISION;
1272             }else{
1273                 //use userRewardWeight: weight of 10,000 should be full reward group 1
1274                 userb = userb * userRewardWeight[_accounts[u]] / WEIGHT_PRECISION;
1275             }
1276 
1277             uint userI = reward.reward_integral_for[_accounts[u]];
1278             if(_isClaim || userI < reward.reward_integral){
1279                 if(_isClaim){
1280                     uint256 receiveable = reward.claimable_reward[_accounts[u]].add(userb.mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1281                     if(receiveable > 0){
1282                         reward.claimable_reward[_accounts[u]] = 0;
1283                         //cheat for gas savings by transfering to the second index in accounts list
1284                         //if claiming only the 0 index will update so 1 index can hold forwarding info
1285                         //guaranteed to have an address in u+1 so no need to check
1286                         IERC20(reward.reward_token).safeTransfer(_accounts[u+1], receiveable);
1287                         emit RewardPaid(_accounts[u], reward.reward_token, receiveable, _accounts[u+1]);
1288                         bal = bal.sub(receiveable);
1289                     }
1290                 }else{
1291                     reward.claimable_reward[_accounts[u]] = reward.claimable_reward[_accounts[u]].add(userb.mul( uint256(reward.reward_integral).sub(userI)).div(1e20));
1292                 }
1293                 reward.reward_integral_for[_accounts[u]] = reward.reward_integral;
1294             }
1295         }
1296 
1297         //update remaining reward here since balance could have changed if claiming
1298         if(bal != reward.reward_remaining){
1299             reward.reward_remaining = uint128(bal);
1300         }
1301     }
1302 
1303     function _checkpoint(address[2] memory _accounts) internal nonReentrant{
1304 
1305         uint256 supply = totalSupply();
1306         uint256[2] memory depositedBalance;
1307         depositedBalance[0] = balanceOf(_accounts[0]);
1308         depositedBalance[1] = balanceOf(_accounts[1]);
1309         
1310         //claim normal cvxcrv staking rewards
1311         IRewardStaking(cvxCrvStaking).getReward(address(this), true);
1312         //claim outside staking rewards
1313         _claimExtras();
1314 
1315         uint256 rewardCount = rewards.length;
1316         for (uint256 i = 0; i < rewardCount; i++) {
1317            _calcRewardIntegral(i,_accounts,depositedBalance,supply,false);
1318         }
1319     }
1320 
1321     function _checkpointAndClaim(address[2] memory _accounts) internal nonReentrant{
1322 
1323         uint256 supply = totalSupply();
1324         uint256[2] memory depositedBalance;
1325         depositedBalance[0] = balanceOf(_accounts[0]); //only do first slot
1326         
1327         //claim normal cvxcrv staking rewards
1328         IRewardStaking(cvxCrvStaking).getReward(address(this), true);
1329         //claim outside staking rewards
1330         _claimExtras();
1331 
1332         uint256 rewardCount = rewards.length;
1333         for (uint256 i = 0; i < rewardCount; i++) {
1334            _calcRewardIntegral(i,_accounts,depositedBalance,supply,true);
1335         }
1336     }
1337 
1338     //claim any rewards not part of the convex pool
1339     function _claimExtras() internal {
1340         //claim via hook if exists
1341         if(rewardHook != address(0)){
1342             try IRewardHook(rewardHook).onRewardClaim(){
1343             }catch{}
1344         }
1345     }
1346 
1347     function user_checkpoint(address _account) external returns(bool) {
1348         _checkpoint([_account, address(0)]);
1349         return true;
1350     }
1351 
1352     //run earned as a mutable function to claim everything before calculating earned rewards
1353     function earned(address _account) external returns(EarnedData[] memory claimable) {
1354         _checkpoint([_account, address(0)]);
1355         return _earned(_account);
1356     }
1357 
1358     //because we are doing a mutative earned(), we can just simulate checkpointing a user and looking at recorded claimables
1359     //thus no need to look at each reward contract's claimable tokens or cvx minting equations etc
1360     function _earned(address _account) internal view returns(EarnedData[] memory claimable) {
1361         
1362         uint256 rewardCount = rewards.length;
1363         claimable = new EarnedData[](rewardCount);
1364 
1365         for (uint256 i = 0; i < rewardCount; i++) {
1366             RewardType storage reward = rewards[i];
1367 
1368             //skip invalidated rewards
1369             if(reward.reward_token == address(0)){
1370                 continue;
1371             }
1372     
1373             claimable[i].amount = reward.claimable_reward[_account];
1374             claimable[i].token = reward.reward_token;
1375         }
1376         return claimable;
1377     }
1378 
1379     //set a user's reward weight to determine how much of each reward group to receive
1380     function setRewardWeight(uint256 _weight) public{
1381         require(_weight <= WEIGHT_PRECISION, "!invalid");
1382 
1383         //checkpoint user
1384          _checkpoint([address(msg.sender), address(0)]);
1385 
1386         //set user weight and new supply weight
1387         //supply weight defined as amount of weight for reward group 1
1388         //..which means reward group 0 will be the inverse (real supply - weight)
1389         uint256 sweight = supplyWeight;
1390         //remove old user weight
1391         sweight -= balanceOf(msg.sender) * userRewardWeight[msg.sender] / WEIGHT_PRECISION;
1392         //add new user weight
1393         sweight += balanceOf(msg.sender) * _weight / WEIGHT_PRECISION;
1394         //store
1395         supplyWeight = sweight;
1396         userRewardWeight[msg.sender] = _weight;
1397     }
1398 
1399     //get user's weighted balance for specified reward group
1400     function userRewardBalance(address _address, uint256 _rewardGroup) external view returns(uint256){
1401         uint256 userb = balanceOf(_address);
1402         if(_rewardGroup == 0){
1403             //userRewardWeight of 0 should be full weight for reward group 0
1404             userb = userb * (WEIGHT_PRECISION - userRewardWeight[_address]) / WEIGHT_PRECISION;
1405         }else{
1406             // userRewardWeight of 10,000 should be full weight for reward group 1
1407             userb = userb * userRewardWeight[_address] / WEIGHT_PRECISION;
1408         }
1409         return userb;
1410     }
1411 
1412     //get weighted supply for specified reward group
1413     function rewardSupply(uint256 _rewardGroup) public view returns(uint256){
1414         //if group 0, return inverse of supplyWeight
1415         if(_rewardGroup == 0){
1416             return (totalSupply() - supplyWeight);
1417         }
1418 
1419         //else return supplyWeight
1420         return supplyWeight;
1421     }
1422 
1423     //claim
1424     function getReward(address _account) external {
1425         //claim directly in checkpoint logic to save a bit of gas
1426         _checkpointAndClaim([_account, _account]);
1427     }
1428 
1429     //claim and forward
1430     function getReward(address _account, address _forwardTo) external {
1431         //if forwarding, require caller is self
1432         require(msg.sender == _account, "!self");
1433         //claim directly in checkpoint logic to save a bit of gas
1434         //pack forwardTo into account array to save gas so that a proxy etc doesnt have to double transfer
1435         _checkpointAndClaim([_account,_forwardTo]);
1436     }
1437 
1438     //deposit vanilla crv
1439     function deposit(uint256 _amount, address _to) public {
1440         require(!isShutdown, "shutdown");
1441 
1442         //dont need to call checkpoint since _mint() will
1443 
1444         if (_amount > 0) {
1445             //deposit
1446             _mint(_to, _amount);
1447             IERC20(crv).safeTransferFrom(msg.sender, address(this), _amount);
1448             IConvexDeposits(crvDepositor).deposit(_amount, false, cvxCrvStaking);
1449         }
1450 
1451         emit Deposited(msg.sender, _to, _amount, true);
1452     }
1453 
1454     function depositAndSetWeight(uint256 _amount, uint256 _weight) external {
1455         deposit(_amount, msg.sender);
1456         setRewardWeight(_weight);
1457     }
1458 
1459     //stake cvxcrv
1460     function stake(uint256 _amount, address _to) public {
1461         require(!isShutdown, "shutdown");
1462 
1463         //dont need to call checkpoint since _mint() will
1464 
1465         if (_amount > 0) {
1466             //deposit
1467             _mint(_to, _amount);
1468             IERC20(cvxCrv).safeTransferFrom(msg.sender, address(this), _amount);
1469             IRewardStaking(cvxCrvStaking).stake(_amount);
1470         }
1471 
1472         emit Deposited(msg.sender, _to, _amount, false);
1473     }
1474 
1475     function stakeAndSetWeight(uint256 _amount, uint256 _weight) external {
1476         stake(_amount, msg.sender);
1477         setRewardWeight(_weight);
1478     }
1479 
1480     //backwards compatibility for other systems (note: amount and address reversed)
1481     function stakeFor(address _to, uint256 _amount) external {
1482         stake(_amount, _to);
1483     }
1484 
1485     //withdraw to convex deposit token
1486     function withdraw(uint256 _amount) external {
1487         
1488         //dont need to call checkpoint since _burn() will
1489 
1490         if (_amount > 0) {
1491             //withdraw
1492             _burn(msg.sender, _amount);
1493             IRewardStaking(cvxCrvStaking).withdraw(_amount, false);
1494             IERC20(cvxCrv).safeTransfer(msg.sender, _amount);
1495         }
1496 
1497         emit Withdrawn(msg.sender, _amount);
1498     }
1499 
1500     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override {
1501         _checkpoint([_from, _to]);
1502 
1503         if(_from != _to){
1504             //adjust supply weight assuming post transfer balances
1505             uint256 sweight = supplyWeight;
1506             if(_from != address(0)){
1507                 sweight -= balanceOf(_from) * userRewardWeight[_from] / WEIGHT_PRECISION;
1508                 sweight += balanceOf(_from).sub(_amount) * userRewardWeight[_from] / WEIGHT_PRECISION;
1509             }
1510             if(_to != address(0)){
1511                 sweight -= balanceOf(_to) * userRewardWeight[_to] / WEIGHT_PRECISION;
1512                 sweight += balanceOf(_to).add(_amount) * userRewardWeight[_to] / WEIGHT_PRECISION;
1513             }
1514 
1515             //write new supply weight
1516             supplyWeight = sweight;
1517         }
1518     }
1519 }