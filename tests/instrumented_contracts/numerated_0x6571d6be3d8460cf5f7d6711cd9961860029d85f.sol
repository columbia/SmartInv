1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
85 
86 
87 
88 pragma solidity >=0.6.0 <0.8.0;
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         uint256 c = a + b;
111         if (c < a) return (false, 0);
112         return (true, c);
113     }
114 
115     /**
116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         if (b > a) return (false, 0);
122         return (true, a - b);
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) return (true, 0);
135         uint256 c = a * b;
136         if (c / a != b) return (false, 0);
137         return (true, c);
138     }
139 
140     /**
141      * @dev Returns the division of two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b == 0) return (false, 0);
147         return (true, a / b);
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a % b);
158     }
159 
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b <= a, "SafeMath: subtraction overflow");
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         if (a == 0) return 0;
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         require(b > 0, "SafeMath: division by zero");
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: modulo by zero");
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b <= a, errorMessage);
257         return a - b;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {tryDiv}.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         return a / b;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 
302 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
303 
304 
305 
306 pragma solidity >=0.6.2 <0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { size := extcodesize(account) }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{ value: amount }("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383       return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{ value: value }(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.delegatecall(data);
471         return _verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 // solhint-disable-next-line no-inline-assembly
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
496 
497 
498 
499 pragma solidity >=0.6.0 <0.8.0;
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure (when the token
506  * contract returns false). Tokens that return no value (and instead revert or
507  * throw on failure) are also supported, non-reverting calls are assumed to be
508  * successful.
509  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
510  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
511  */
512 library SafeERC20 {
513     using SafeMath for uint256;
514     using Address for address;
515 
516     function safeTransfer(IERC20 token, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
518     }
519 
520     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
521         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
522     }
523 
524     /**
525      * @dev Deprecated. This function has issues similar to the ones found in
526      * {IERC20-approve}, and its usage is discouraged.
527      *
528      * Whenever possible, use {safeIncreaseAllowance} and
529      * {safeDecreaseAllowance} instead.
530      */
531     function safeApprove(IERC20 token, address spender, uint256 value) internal {
532         // safeApprove should only be called when setting an initial allowance,
533         // or when resetting it to zero. To increase and decrease it, use
534         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
535         // solhint-disable-next-line max-line-length
536         require((value == 0) || (token.allowance(address(this), spender) == 0),
537             "SafeERC20: approve from non-zero to non-zero allowance"
538         );
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
540     }
541 
542     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
543         uint256 newAllowance = token.allowance(address(this), spender).add(value);
544         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
545     }
546 
547     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
548         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
549         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
550     }
551 
552     /**
553      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
554      * on the return value: the return value is optional (but if data is returned, it must not be false).
555      * @param token The token targeted by the call.
556      * @param data The call data (encoded using abi.encode or one of its variants).
557      */
558     function _callOptionalReturn(IERC20 token, bytes memory data) private {
559         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
560         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
561         // the target address contains contract code and also asserts for success in the low-level call.
562 
563         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 
572 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
573 
574 
575 
576 pragma solidity >=0.6.0 <0.8.0;
577 
578 /*
579  * @dev Provides information about the current execution context, including the
580  * sender of the transaction and its data. While these are generally available
581  * via msg.sender and msg.data, they should not be accessed in such a direct
582  * manner, since when dealing with GSN meta-transactions the account sending and
583  * paying for execution may not be the actual sender (as far as an application
584  * is concerned).
585  *
586  * This contract is only required for intermediate, library-like contracts.
587  */
588 abstract contract Context {
589     function _msgSender() internal view virtual returns (address payable) {
590         return msg.sender;
591     }
592 
593     function _msgData() internal view virtual returns (bytes memory) {
594         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
595         return msg.data;
596     }
597 }
598 
599 
600 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
601 
602 
603 
604 pragma solidity >=0.6.0 <0.8.0;
605 
606 
607 
608 /**
609  * @dev Implementation of the {IERC20} interface.
610  *
611  * This implementation is agnostic to the way tokens are created. This means
612  * that a supply mechanism has to be added in a derived contract using {_mint}.
613  * For a generic mechanism see {ERC20PresetMinterPauser}.
614  *
615  * TIP: For a detailed writeup see our guide
616  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
617  * to implement supply mechanisms].
618  *
619  * We have followed general OpenZeppelin guidelines: functions revert instead
620  * of returning `false` on failure. This behavior is nonetheless conventional
621  * and does not conflict with the expectations of ERC20 applications.
622  *
623  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
624  * This allows applications to reconstruct the allowance for all accounts just
625  * by listening to said events. Other implementations of the EIP may not emit
626  * these events, as it isn't required by the specification.
627  *
628  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
629  * functions have been added to mitigate the well-known issues around setting
630  * allowances. See {IERC20-approve}.
631  */
632 contract ERC20 is Context, IERC20 {
633     using SafeMath for uint256;
634 
635     mapping (address => uint256) private _balances;
636 
637     mapping (address => mapping (address => uint256)) private _allowances;
638 
639     uint256 private _totalSupply;
640 
641     string private _name;
642     string private _symbol;
643     uint8 private _decimals;
644 
645     /**
646      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
647      * a default value of 18.
648      *
649      * To select a different value for {decimals}, use {_setupDecimals}.
650      *
651      * All three of these values are immutable: they can only be set once during
652      * construction.
653      */
654     constructor (string memory name_, string memory symbol_) public {
655         _name = name_;
656         _symbol = symbol_;
657         _decimals = 18;
658     }
659 
660     /**
661      * @dev Returns the name of the token.
662      */
663     function name() public view virtual returns (string memory) {
664         return _name;
665     }
666 
667     /**
668      * @dev Returns the symbol of the token, usually a shorter version of the
669      * name.
670      */
671     function symbol() public view virtual returns (string memory) {
672         return _symbol;
673     }
674 
675     /**
676      * @dev Returns the number of decimals used to get its user representation.
677      * For example, if `decimals` equals `2`, a balance of `505` tokens should
678      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
679      *
680      * Tokens usually opt for a value of 18, imitating the relationship between
681      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
682      * called.
683      *
684      * NOTE: This information is only used for _display_ purposes: it in
685      * no way affects any of the arithmetic of the contract, including
686      * {IERC20-balanceOf} and {IERC20-transfer}.
687      */
688     function decimals() public view virtual returns (uint8) {
689         return _decimals;
690     }
691 
692     /**
693      * @dev See {IERC20-totalSupply}.
694      */
695     function totalSupply() public view virtual override returns (uint256) {
696         return _totalSupply;
697     }
698 
699     /**
700      * @dev See {IERC20-balanceOf}.
701      */
702     function balanceOf(address account) public view virtual override returns (uint256) {
703         return _balances[account];
704     }
705 
706     /**
707      * @dev See {IERC20-transfer}.
708      *
709      * Requirements:
710      *
711      * - `recipient` cannot be the zero address.
712      * - the caller must have a balance of at least `amount`.
713      */
714     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
715         _transfer(_msgSender(), recipient, amount);
716         return true;
717     }
718 
719     /**
720      * @dev See {IERC20-allowance}.
721      */
722     function allowance(address owner, address spender) public view virtual override returns (uint256) {
723         return _allowances[owner][spender];
724     }
725 
726     /**
727      * @dev See {IERC20-approve}.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      */
733     function approve(address spender, uint256 amount) public virtual override returns (bool) {
734         _approve(_msgSender(), spender, amount);
735         return true;
736     }
737 
738     /**
739      * @dev See {IERC20-transferFrom}.
740      *
741      * Emits an {Approval} event indicating the updated allowance. This is not
742      * required by the EIP. See the note at the beginning of {ERC20}.
743      *
744      * Requirements:
745      *
746      * - `sender` and `recipient` cannot be the zero address.
747      * - `sender` must have a balance of at least `amount`.
748      * - the caller must have allowance for ``sender``'s tokens of at least
749      * `amount`.
750      */
751     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
752         _transfer(sender, recipient, amount);
753         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
754         return true;
755     }
756 
757     /**
758      * @dev Atomically increases the allowance granted to `spender` by the caller.
759      *
760      * This is an alternative to {approve} that can be used as a mitigation for
761      * problems described in {IERC20-approve}.
762      *
763      * Emits an {Approval} event indicating the updated allowance.
764      *
765      * Requirements:
766      *
767      * - `spender` cannot be the zero address.
768      */
769     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
770         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
771         return true;
772     }
773 
774     /**
775      * @dev Atomically decreases the allowance granted to `spender` by the caller.
776      *
777      * This is an alternative to {approve} that can be used as a mitigation for
778      * problems described in {IERC20-approve}.
779      *
780      * Emits an {Approval} event indicating the updated allowance.
781      *
782      * Requirements:
783      *
784      * - `spender` cannot be the zero address.
785      * - `spender` must have allowance for the caller of at least
786      * `subtractedValue`.
787      */
788     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
789         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
790         return true;
791     }
792 
793     /**
794      * @dev Moves tokens `amount` from `sender` to `recipient`.
795      *
796      * This is internal function is equivalent to {transfer}, and can be used to
797      * e.g. implement automatic token fees, slashing mechanisms, etc.
798      *
799      * Emits a {Transfer} event.
800      *
801      * Requirements:
802      *
803      * - `sender` cannot be the zero address.
804      * - `recipient` cannot be the zero address.
805      * - `sender` must have a balance of at least `amount`.
806      */
807     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
808         require(sender != address(0), "ERC20: transfer from the zero address");
809         require(recipient != address(0), "ERC20: transfer to the zero address");
810 
811         _beforeTokenTransfer(sender, recipient, amount);
812 
813         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
814         _balances[recipient] = _balances[recipient].add(amount);
815         emit Transfer(sender, recipient, amount);
816     }
817 
818     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
819      * the total supply.
820      *
821      * Emits a {Transfer} event with `from` set to the zero address.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      */
827     function _mint(address account, uint256 amount) internal virtual {
828         require(account != address(0), "ERC20: mint to the zero address");
829 
830         _beforeTokenTransfer(address(0), account, amount);
831 
832         _totalSupply = _totalSupply.add(amount);
833         _balances[account] = _balances[account].add(amount);
834         emit Transfer(address(0), account, amount);
835     }
836 
837     /**
838      * @dev Destroys `amount` tokens from `account`, reducing the
839      * total supply.
840      *
841      * Emits a {Transfer} event with `to` set to the zero address.
842      *
843      * Requirements:
844      *
845      * - `account` cannot be the zero address.
846      * - `account` must have at least `amount` tokens.
847      */
848     function _burn(address account, uint256 amount) internal virtual {
849         require(account != address(0), "ERC20: burn from the zero address");
850 
851         _beforeTokenTransfer(account, address(0), amount);
852 
853         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
854         _totalSupply = _totalSupply.sub(amount);
855         emit Transfer(account, address(0), amount);
856     }
857 
858     /**
859      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
860      *
861      * This internal function is equivalent to `approve`, and can be used to
862      * e.g. set automatic allowances for certain subsystems, etc.
863      *
864      * Emits an {Approval} event.
865      *
866      * Requirements:
867      *
868      * - `owner` cannot be the zero address.
869      * - `spender` cannot be the zero address.
870      */
871     function _approve(address owner, address spender, uint256 amount) internal virtual {
872         require(owner != address(0), "ERC20: approve from the zero address");
873         require(spender != address(0), "ERC20: approve to the zero address");
874 
875         _allowances[owner][spender] = amount;
876         emit Approval(owner, spender, amount);
877     }
878 
879     /**
880      * @dev Sets {decimals} to a value other than the default one of 18.
881      *
882      * WARNING: This function should only be called from the constructor. Most
883      * applications that interact with token contracts will not expect
884      * {decimals} to ever change, and may work incorrectly if it does.
885      */
886     function _setupDecimals(uint8 decimals_) internal virtual {
887         _decimals = decimals_;
888     }
889 
890     /**
891      * @dev Hook that is called before any transfer of tokens. This includes
892      * minting and burning.
893      *
894      * Calling conditions:
895      *
896      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
897      * will be to transferred to `to`.
898      * - when `from` is zero, `amount` tokens will be minted for `to`.
899      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
900      * - `from` and `to` are never both zero.
901      *
902      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
903      */
904     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
905 }
906 
907 
908 // File contracts/bridge/interfaces/ISwap.sol
909 
910 
911 
912 pragma solidity 0.6.12;
913 
914 interface ISwap {
915   // pool data view functions
916   function getA() external view returns (uint256);
917 
918   function getToken(uint8 index) external view returns (IERC20);
919 
920   function getTokenIndex(address tokenAddress) external view returns (uint8);
921 
922   function getTokenBalance(uint8 index) external view returns (uint256);
923 
924   function getVirtualPrice() external view returns (uint256);
925 
926   // min return calculation functions
927   function calculateSwap(
928     uint8 tokenIndexFrom,
929     uint8 tokenIndexTo,
930     uint256 dx
931   ) external view returns (uint256);
932 
933   function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
934     external
935     view
936     returns (uint256);
937 
938   function calculateRemoveLiquidity(uint256 amount)
939     external
940     view
941     returns (uint256[] memory);
942 
943   function calculateRemoveLiquidityOneToken(
944     uint256 tokenAmount,
945     uint8 tokenIndex
946   ) external view returns (uint256 availableTokenAmount);
947 
948   // state modifying functions
949   function initialize(
950     IERC20[] memory pooledTokens,
951     uint8[] memory decimals,
952     string memory lpTokenName,
953     string memory lpTokenSymbol,
954     uint256 a,
955     uint256 fee,
956     uint256 adminFee,
957     address lpTokenTargetAddress
958   ) external;
959 
960   function swap(
961     uint8 tokenIndexFrom,
962     uint8 tokenIndexTo,
963     uint256 dx,
964     uint256 minDy,
965     uint256 deadline
966   ) external returns (uint256);
967 
968   function addLiquidity(
969     uint256[] calldata amounts,
970     uint256 minToMint,
971     uint256 deadline
972   ) external returns (uint256);
973 
974   function removeLiquidity(
975     uint256 amount,
976     uint256[] calldata minAmounts,
977     uint256 deadline
978   ) external returns (uint256[] memory);
979 
980   function removeLiquidityOneToken(
981     uint256 tokenAmount,
982     uint8 tokenIndex,
983     uint256 minAmount,
984     uint256 deadline
985   ) external returns (uint256);
986 
987   function removeLiquidityImbalance(
988     uint256[] calldata amounts,
989     uint256 maxBurnAmount,
990     uint256 deadline
991   ) external returns (uint256);
992 }
993 
994 
995 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.1
996 
997 
998 
999 pragma solidity >=0.6.0 <0.8.0;
1000 
1001 
1002 /**
1003  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1004  * tokens and those that they have an allowance for, in a way that can be
1005  * recognized off-chain (via event analysis).
1006  */
1007 abstract contract ERC20Burnable is Context, ERC20 {
1008     using SafeMath for uint256;
1009 
1010     /**
1011      * @dev Destroys `amount` tokens from the caller.
1012      *
1013      * See {ERC20-_burn}.
1014      */
1015     function burn(uint256 amount) public virtual {
1016         _burn(_msgSender(), amount);
1017     }
1018 
1019     /**
1020      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1021      * allowance.
1022      *
1023      * See {ERC20-_burn} and {ERC20-allowance}.
1024      *
1025      * Requirements:
1026      *
1027      * - the caller must have allowance for ``accounts``'s tokens of at least
1028      * `amount`.
1029      */
1030     function burnFrom(address account, uint256 amount) public virtual {
1031         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1032 
1033         _approve(account, _msgSender(), decreasedAllowance);
1034         _burn(account, amount);
1035     }
1036 }
1037 
1038 
1039 // File contracts/bridge/interfaces/ISynapseBridge.sol
1040 
1041 
1042 
1043 pragma solidity 0.6.12;
1044 
1045 
1046 interface ISynapseBridge {
1047   using SafeERC20 for IERC20;
1048 
1049   function deposit(
1050     address to,
1051     uint256 chainId,
1052     IERC20 token,
1053     uint256 amount
1054   ) external;
1055 
1056   function depositAndSwap(
1057     address to,
1058     uint256 chainId,
1059     IERC20 token,
1060     uint256 amount,
1061     uint8 tokenIndexFrom,
1062     uint8 tokenIndexTo,
1063     uint256 minDy,
1064     uint256 deadline
1065   ) external;
1066 
1067   function redeem(
1068     address to,
1069     uint256 chainId,
1070     IERC20 token,
1071     uint256 amount
1072   ) external;
1073 
1074   function redeemAndSwap(
1075     address to,
1076     uint256 chainId,
1077     IERC20 token,
1078     uint256 amount,
1079     uint8 tokenIndexFrom,
1080     uint8 tokenIndexTo,
1081     uint256 minDy,
1082     uint256 deadline
1083   ) external;
1084 
1085   function redeemAndRemove(
1086     address to,
1087     uint256 chainId,
1088     IERC20 token,
1089     uint256 amount,
1090     uint8 liqTokenIndex,
1091     uint256 liqMinAmount,
1092     uint256 liqDeadline
1093   ) external;
1094 }
1095 
1096 
1097 // File contracts/bridge/interfaces/IWETH9.sol
1098 
1099 
1100 
1101 pragma solidity >=0.4.0;
1102 
1103 interface IWETH9 {
1104     function name() external view returns (string memory);
1105 
1106     function symbol() external view returns (string memory);
1107 
1108     function decimals() external view returns (uint8);
1109 
1110     function balanceOf(address) external view returns (uint256);
1111 
1112     function allowance(address, address) external view returns (uint256);
1113 
1114     receive() external payable;
1115 
1116     function deposit() external payable;
1117 
1118     function withdraw(uint256 wad) external;
1119 
1120     function totalSupply() external view returns (uint256);
1121 
1122     function approve(address guy, uint256 wad) external returns (bool);
1123 
1124     function transfer(address dst, uint256 wad) external returns (bool);
1125 
1126     function transferFrom(
1127         address src,
1128         address dst,
1129         uint256 wad
1130     ) external returns (bool);
1131 }
1132 
1133 
1134 // File contracts/bridge/wrappers/L1BridgeZap.sol
1135 
1136 
1137 pragma solidity 0.6.12;
1138 
1139 
1140 
1141 
1142 
1143 /**
1144  * @title L1BridgeZap
1145  * @notice This contract is responsible for handling user Zaps into the SynapseBridge contract, through the Synapse Swap contracts. It does so
1146  * It does so by combining the action of addLiquidity() to the base swap pool, and then calling either deposit() or depositAndSwap() on the bridge.
1147  * This is done in hopes of automating portions of the bridge user experience to users, while keeping the SynapseBridge contract logic small.
1148  *
1149  * @dev This contract should be deployed with a base Swap.sol address and a SynapseBridge.sol address, otherwise, it will not function.
1150  */
1151 contract L1BridgeZap {
1152   using SafeERC20 for IERC20;
1153 
1154   uint256 constant MAX_UINT256 = 2**256 - 1;
1155   
1156   ISwap baseSwap;
1157   ISynapseBridge synapseBridge;
1158   IERC20[] public baseTokens;
1159   address payable public immutable WETH_ADDRESS;
1160   
1161 
1162   /**
1163    * @notice Constructs the contract, approves each token inside of baseSwap to be used by baseSwap (needed for addLiquidity())
1164    */
1165   constructor(address payable _wethAddress, ISwap _baseSwap, ISynapseBridge _synapseBridge) public {
1166     WETH_ADDRESS = _wethAddress;
1167     baseSwap = _baseSwap;
1168     synapseBridge = _synapseBridge;
1169     IERC20(_wethAddress).safeIncreaseAllowance(address(_synapseBridge), MAX_UINT256);
1170     {
1171       uint8 i;
1172       for (; i < 32; i++) {
1173         try _baseSwap.getToken(i) returns (IERC20 token) {
1174           baseTokens.push(token);
1175           token.safeIncreaseAllowance(address(_baseSwap), MAX_UINT256);
1176         } catch {
1177           break;
1178         }
1179       }
1180       require(i > 1, 'baseSwap must have at least 2 tokens');
1181     }
1182   }
1183   
1184   /**
1185    * @notice Wraps SynapseBridge deposit() function to make it compatible w/ ETH -> WETH conversions
1186    * @param to address on other chain to bridge assets to
1187    * @param chainId which chain to bridge assets onto
1188    * @param amount Amount in native token decimals to transfer cross-chain pre-fees
1189    **/
1190   function depositETH(
1191     address to,
1192     uint256 chainId,
1193     uint256 amount
1194     ) external payable {
1195       require(msg.value > 0 && msg.value == amount, 'INCORRECT MSG VALUE');
1196       IWETH9(WETH_ADDRESS).deposit{value: msg.value}();
1197       synapseBridge.deposit(to, chainId, IERC20(WETH_ADDRESS), amount);
1198     }
1199 
1200   /**
1201    * @notice Wraps SynapseBridge depositAndSwap() function to make it compatible w/ ETH -> WETH conversions
1202    * @param to address on other chain to bridge assets to
1203    * @param chainId which chain to bridge assets onto
1204    * @param amount Amount in native token decimals to transfer cross-chain pre-fees
1205    * @param tokenIndexFrom the token the user wants to swap from
1206    * @param tokenIndexTo the token the user wants to swap to
1207    * @param minDy the min amount the user would like to receive, or revert to only minting the SynERC20 token crosschain.
1208    * @param deadline latest timestamp to accept this transaction
1209    **/
1210   function depositETHAndSwap(
1211     address to,
1212     uint256 chainId,
1213     uint256 amount,
1214     uint8 tokenIndexFrom,
1215     uint8 tokenIndexTo,
1216     uint256 minDy,
1217     uint256 deadline
1218     ) external payable {
1219       require(msg.value > 0 && msg.value == amount, 'INCORRECT MSG VALUE');
1220       IWETH9(WETH_ADDRESS).deposit{value: msg.value}();
1221       synapseBridge.depositAndSwap(to, chainId, IERC20(WETH_ADDRESS), amount, tokenIndexFrom, tokenIndexTo, minDy, deadline);
1222     }
1223 
1224 
1225   /**
1226    * @notice A simple method to calculate prices from deposits or
1227    * withdrawals, excluding fees but including slippage. This is
1228    * helpful as an input into the various "min" parameters on calls
1229    * to fight front-running
1230    *
1231    * @dev This shouldn't be used outside frontends for user estimates.
1232    *
1233    * @param amounts an array of token amounts to deposit or withdrawal,
1234    * corresponding to pooledTokens. The amount should be in each
1235    * pooled token's native precision.
1236    * @param deposit whether this is a deposit or a withdrawal
1237    * @return token amount the user will receive
1238    */
1239   function calculateTokenAmount(uint256[] calldata amounts, bool deposit)
1240     external
1241     view
1242     virtual
1243     returns (uint256)
1244   {
1245     return baseSwap.calculateTokenAmount(amounts, deposit);
1246   }
1247 
1248       /**
1249      * @notice Calculate the amount of underlying token available to withdraw
1250      * when withdrawing via only single token
1251      * @param tokenAmount the amount of LP token to burn
1252      * @param tokenIndex index of which token will be withdrawn
1253      * @return availableTokenAmount calculated amount of underlying token
1254      * available to withdraw
1255      */
1256     function calculateRemoveLiquidityOneToken(
1257         uint256 tokenAmount,
1258         uint8 tokenIndex
1259     ) external view virtual returns (uint256 availableTokenAmount) {
1260         return baseSwap.calculateRemoveLiquidityOneToken(tokenAmount, tokenIndex);
1261     }
1262 
1263 
1264   /**
1265    * @notice Combines adding liquidity to the given Swap, and calls deposit() on the bridge using that LP token
1266    * @param to address on other chain to bridge assets to
1267    * @param chainId which chain to bridge assets onto
1268    * @param token ERC20 compatible token to deposit into the bridge
1269    * @param liquidityAmounts the amounts of each token to add, in their native precision
1270    * @param minToMint the minimum LP tokens adding this amount of liquidity
1271    * should mint, otherwise revert. Handy for front-running mitigation
1272    * @param deadline latest timestamp to accept this transaction
1273    **/
1274   function zapAndDeposit(
1275     address to,
1276     uint256 chainId,
1277     IERC20 token,
1278     uint256[] calldata liquidityAmounts,
1279     uint256 minToMint,
1280     uint256 deadline
1281   ) external {
1282     // add liquidity
1283     for (uint256 i = 0; i < baseTokens.length; i++) {
1284       if (liquidityAmounts[i] != 0) {
1285         baseTokens[i].safeTransferFrom(
1286           msg.sender,
1287           address(this),
1288           liquidityAmounts[i]
1289         );
1290       }
1291     }
1292 
1293     uint256 liqAdded = baseSwap.addLiquidity(
1294       liquidityAmounts,
1295       minToMint,
1296       deadline
1297     );
1298     // deposit into bridge, gets nUSD
1299     if (token.allowance(address(this), address(synapseBridge)) < liqAdded) {
1300       token.safeApprove(address(synapseBridge), MAX_UINT256);
1301     }
1302     synapseBridge.deposit(to, chainId, token, liqAdded);
1303   }
1304 
1305   /**
1306    * @notice Combines adding liquidity to the given Swap, and calls depositAndSwap() on the bridge using that LP token
1307    * @param to address on other chain to bridge assets to
1308    * @param chainId which chain to bridge assets onto
1309    * @param token ERC20 compatible token to deposit into the bridge
1310    * @param liquidityAmounts the amounts of each token to add, in their native precision
1311    * @param minToMint the minimum LP tokens adding this amount of liquidity
1312    * should mint, otherwise revert. Handy for front-running mitigation
1313    * @param liqDeadline latest timestamp to accept this transaction
1314    * @param tokenIndexFrom the token the user wants to swap from
1315    * @param tokenIndexTo the token the user wants to swap to
1316    * @param minDy the min amount the user would like to receive, or revert to only minting the SynERC20 token crosschain.
1317    * @param swapDeadline latest timestamp to accept this transaction
1318    **/
1319   function zapAndDepositAndSwap(
1320     address to,
1321     uint256 chainId,
1322     IERC20 token,
1323     uint256[] calldata liquidityAmounts,
1324     uint256 minToMint,
1325     uint256 liqDeadline,
1326     uint8 tokenIndexFrom,
1327     uint8 tokenIndexTo,
1328     uint256 minDy,
1329     uint256 swapDeadline
1330   ) external {
1331     // add liquidity
1332     for (uint256 i = 0; i < baseTokens.length; i++) {
1333       if (liquidityAmounts[i] != 0) {
1334         baseTokens[i].safeTransferFrom(
1335           msg.sender,
1336           address(this),
1337           liquidityAmounts[i]
1338         );
1339       }
1340     }
1341 
1342     uint256 liqAdded = baseSwap.addLiquidity(
1343       liquidityAmounts,
1344       minToMint,
1345       liqDeadline
1346     );
1347     // deposit into bridge, bridge attemps to swap into desired asset
1348     if (token.allowance(address(this), address(synapseBridge)) < liqAdded) {
1349       token.safeApprove(address(synapseBridge), MAX_UINT256);
1350     }
1351     synapseBridge.depositAndSwap(
1352       to,
1353       chainId,
1354       token,
1355       liqAdded,
1356       tokenIndexFrom,
1357       tokenIndexTo,
1358       minDy,
1359       swapDeadline
1360     );
1361   }
1362 
1363     /**
1364    * @notice Wraps SynapseBridge deposit() function
1365    * @param to address on other chain to bridge assets to
1366    * @param chainId which chain to bridge assets onto
1367    * @param token ERC20 compatible token to deposit into the bridge
1368    * @param amount Amount in native token decimals to transfer cross-chain pre-fees
1369    **/
1370   function deposit(
1371     address to,
1372     uint256 chainId,
1373     IERC20 token,
1374     uint256 amount
1375     ) external {
1376       token.safeTransferFrom(msg.sender, address(this), amount);
1377 
1378       if (token.allowance(address(this), address(synapseBridge)) < amount) {
1379         token.safeApprove(address(synapseBridge), MAX_UINT256);
1380       }
1381       synapseBridge.deposit(to, chainId, token, amount);
1382   }
1383   
1384   /**
1385    * @notice Wraps SynapseBridge depositAndSwap() function
1386    * @param to address on other chain to bridge assets to
1387    * @param chainId which chain to bridge assets onto
1388    * @param token ERC20 compatible token to deposit into the bridge
1389    * @param amount Amount in native token decimals to transfer cross-chain pre-fees
1390    * @param tokenIndexFrom the token the user wants to swap from
1391    * @param tokenIndexTo the token the user wants to swap to
1392    * @param minDy the min amount the user would like to receive, or revert to only minting the SynERC20 token crosschain.
1393    * @param deadline latest timestamp to accept this transaction
1394    **/
1395   function depositAndSwap(
1396     address to,
1397     uint256 chainId,
1398     IERC20 token,
1399     uint256 amount,
1400     uint8 tokenIndexFrom,
1401     uint8 tokenIndexTo,
1402     uint256 minDy,
1403     uint256 deadline
1404   ) external {
1405       token.safeTransferFrom(msg.sender, address(this), amount);
1406       
1407       if (token.allowance(address(this), address(synapseBridge)) < amount) {
1408         token.safeApprove(address(synapseBridge), MAX_UINT256);
1409       }
1410       synapseBridge.depositAndSwap(to, chainId, token, amount, tokenIndexFrom, tokenIndexTo, minDy, deadline);
1411   }
1412 
1413 
1414     /**
1415    * @notice Wraps SynapseBridge redeem() function
1416    * @param to address on other chain to bridge assets to
1417    * @param chainId which chain to bridge assets onto
1418    * @param token ERC20 compatible token to redeem into the bridge
1419    * @param amount Amount in native token decimals to transfer cross-chain pre-fees
1420    **/
1421   function redeem(
1422     address to,
1423     uint256 chainId,
1424     IERC20 token,
1425     uint256 amount
1426     ) external {
1427       token.safeTransferFrom(msg.sender, address(this), amount);
1428 
1429       if (token.allowance(address(this), address(synapseBridge)) < amount) {
1430         token.safeApprove(address(synapseBridge), MAX_UINT256);
1431       }
1432       synapseBridge.redeem(to, chainId, token, amount);
1433   }
1434   
1435 }