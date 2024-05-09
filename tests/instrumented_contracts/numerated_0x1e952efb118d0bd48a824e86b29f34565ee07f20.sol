1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         uint256 size;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { size := extcodesize(account) }
266         return size > 0;
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) { // Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 
445 /*
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with GSN meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address payable) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes memory) {
461         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
462         return msg.data;
463     }
464 }
465 
466 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor () internal {
488         address msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(_owner == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         emit OwnershipTransferred(_owner, address(0));
517         _owner = address(0);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 }
530 
531 
532 /**
533  * @dev Standard math utilities missing in the Solidity language.
534  */
535 library Math {
536     /**
537      * @dev Returns the largest of two numbers.
538      */
539     function max(uint256 a, uint256 b) internal pure returns (uint256) {
540         return a >= b ? a : b;
541     }
542 
543     /**
544      * @dev Returns the smallest of two numbers.
545      */
546     function min(uint256 a, uint256 b) internal pure returns (uint256) {
547         return a < b ? a : b;
548     }
549 
550     /**
551      * @dev Returns the average of two numbers. The result is rounded towards
552      * zero.
553      */
554     function average(uint256 a, uint256 b) internal pure returns (uint256) {
555         // (a + b) / 2 can overflow, so we distribute
556         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
557     }
558 }
559 
560 
561 contract LPTokenWrapperV3 {
562     using SafeMath for uint256;
563     using SafeERC20 for IERC20;
564 
565     IERC20 public lp = IERC20(0xA56Ed2632E443Db5f93e73C89df399a081408Cc4);
566 
567     uint256 private _totalSupply;
568     mapping(address => uint256) private _balances;
569 
570     address public treasury;
571 
572     constructor(address _lp, address _treasury) public {
573         lp = IERC20(_lp);
574         treasury = _treasury;
575     }
576 
577     function totalSupply() public view returns (uint256) {
578         return _totalSupply;
579     }
580 
581     function balanceOf(address account) public view returns (uint256) {
582         return _balances[account];
583     }
584 
585     function _stake(uint256 amount, uint256 hashrate, address account) internal {
586         require(treasury != address(0), "!zero address");
587 
588         _totalSupply = _totalSupply.add(hashrate);
589         _balances[account] = _balances[account].add(hashrate);
590 
591         lp.safeTransferFrom(msg.sender, treasury, amount);
592     }
593 }
594 
595 
596 /**
597  * @dev Implementation of the {IERC20} interface.
598  *
599  * This implementation is agnostic to the way tokens are created. This means
600  * that a supply mechanism has to be added in a derived contract using {_mint}.
601  * For a generic mechanism see {ERC20PresetMinterPauser}.
602  *
603  * TIP: For a detailed writeup see our guide
604  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
605  * to implement supply mechanisms].
606  *
607  * We have followed general OpenZeppelin guidelines: functions revert instead
608  * of returning `false` on failure. This behavior is nonetheless conventional
609  * and does not conflict with the expectations of ERC20 applications.
610  *
611  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
612  * This allows applications to reconstruct the allowance for all accounts just
613  * by listening to said events. Other implementations of the EIP may not emit
614  * these events, as it isn't required by the specification.
615  *
616  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
617  * functions have been added to mitigate the well-known issues around setting
618  * allowances. See {IERC20-approve}.
619  */
620 contract ERC20 is Context, IERC20 {
621     using SafeMath for uint256;
622     using Address for address;
623 
624     mapping (address => uint256) private _balances;
625 
626     mapping (address => mapping (address => uint256)) private _allowances;
627 
628     uint256 private _totalSupply;
629 
630     string private _name;
631     string private _symbol;
632     uint8 private _decimals;
633 
634     /**
635      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
636      * a default value of 18.
637      *
638      * To select a different value for {decimals}, use {_setupDecimals}.
639      *
640      * All three of these values are immutable: they can only be set once during
641      * construction.
642      */
643     constructor (string memory name, string memory symbol) public {
644         _name = name;
645         _symbol = symbol;
646         _decimals = 18;
647     }
648 
649     /**
650      * @dev Returns the name of the token.
651      */
652     function name() public view returns (string memory) {
653         return _name;
654     }
655 
656     /**
657      * @dev Returns the symbol of the token, usually a shorter version of the
658      * name.
659      */
660     function symbol() public view returns (string memory) {
661         return _symbol;
662     }
663 
664     /**
665      * @dev Returns the number of decimals used to get its user representation.
666      * For example, if `decimals` equals `2`, a balance of `505` tokens should
667      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
668      *
669      * Tokens usually opt for a value of 18, imitating the relationship between
670      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
671      * called.
672      *
673      * NOTE: This information is only used for _display_ purposes: it in
674      * no way affects any of the arithmetic of the contract, including
675      * {IERC20-balanceOf} and {IERC20-transfer}.
676      */
677     function decimals() public view returns (uint8) {
678         return _decimals;
679     }
680 
681     /**
682      * @dev See {IERC20-totalSupply}.
683      */
684     function totalSupply() public view override returns (uint256) {
685         return _totalSupply;
686     }
687 
688     /**
689      * @dev See {IERC20-balanceOf}.
690      */
691     function balanceOf(address account) public view override returns (uint256) {
692         return _balances[account];
693     }
694 
695     /**
696      * @dev See {IERC20-transfer}.
697      *
698      * Requirements:
699      *
700      * - `recipient` cannot be the zero address.
701      * - the caller must have a balance of at least `amount`.
702      */
703     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
704         _transfer(_msgSender(), recipient, amount);
705         return true;
706     }
707 
708     /**
709      * @dev See {IERC20-allowance}.
710      */
711     function allowance(address owner, address spender) public view virtual override returns (uint256) {
712         return _allowances[owner][spender];
713     }
714 
715     /**
716      * @dev See {IERC20-approve}.
717      *
718      * Requirements:
719      *
720      * - `spender` cannot be the zero address.
721      */
722     function approve(address spender, uint256 amount) public virtual override returns (bool) {
723         _approve(_msgSender(), spender, amount);
724         return true;
725     }
726 
727     /**
728      * @dev See {IERC20-transferFrom}.
729      *
730      * Emits an {Approval} event indicating the updated allowance. This is not
731      * required by the EIP. See the note at the beginning of {ERC20};
732      *
733      * Requirements:
734      * - `sender` and `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      * - the caller must have allowance for ``sender``'s tokens of at least
737      * `amount`.
738      */
739     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
740         _transfer(sender, recipient, amount);
741         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
742         return true;
743     }
744 
745     /**
746      * @dev Atomically increases the allowance granted to `spender` by the caller.
747      *
748      * This is an alternative to {approve} that can be used as a mitigation for
749      * problems described in {IERC20-approve}.
750      *
751      * Emits an {Approval} event indicating the updated allowance.
752      *
753      * Requirements:
754      *
755      * - `spender` cannot be the zero address.
756      */
757     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
758         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
759         return true;
760     }
761 
762     /**
763      * @dev Atomically decreases the allowance granted to `spender` by the caller.
764      *
765      * This is an alternative to {approve} that can be used as a mitigation for
766      * problems described in {IERC20-approve}.
767      *
768      * Emits an {Approval} event indicating the updated allowance.
769      *
770      * Requirements:
771      *
772      * - `spender` cannot be the zero address.
773      * - `spender` must have allowance for the caller of at least
774      * `subtractedValue`.
775      */
776     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
777         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
778         return true;
779     }
780 
781     /**
782      * @dev Moves tokens `amount` from `sender` to `recipient`.
783      *
784      * This is internal function is equivalent to {transfer}, and can be used to
785      * e.g. implement automatic token fees, slashing mechanisms, etc.
786      *
787      * Emits a {Transfer} event.
788      *
789      * Requirements:
790      *
791      * - `sender` cannot be the zero address.
792      * - `recipient` cannot be the zero address.
793      * - `sender` must have a balance of at least `amount`.
794      */
795     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
796         require(sender != address(0), "ERC20: transfer from the zero address");
797         require(recipient != address(0), "ERC20: transfer to the zero address");
798 
799         _beforeTokenTransfer(sender, recipient, amount);
800 
801         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
802         _balances[recipient] = _balances[recipient].add(amount);
803         emit Transfer(sender, recipient, amount);
804     }
805 
806     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
807      * the total supply.
808      *
809      * Emits a {Transfer} event with `from` set to the zero address.
810      *
811      * Requirements
812      *
813      * - `to` cannot be the zero address.
814      */
815     function _mint(address account, uint256 amount) internal virtual {
816         require(account != address(0), "ERC20: mint to the zero address");
817 
818         _beforeTokenTransfer(address(0), account, amount);
819 
820         _totalSupply = _totalSupply.add(amount);
821         _balances[account] = _balances[account].add(amount);
822         emit Transfer(address(0), account, amount);
823     }
824 
825     /**
826      * @dev Destroys `amount` tokens from `account`, reducing the
827      * total supply.
828      *
829      * Emits a {Transfer} event with `to` set to the zero address.
830      *
831      * Requirements
832      *
833      * - `account` cannot be the zero address.
834      * - `account` must have at least `amount` tokens.
835      */
836     function _burn(address account, uint256 amount) internal virtual {
837         require(account != address(0), "ERC20: burn from the zero address");
838 
839         _beforeTokenTransfer(account, address(0), amount);
840 
841         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
842         _totalSupply = _totalSupply.sub(amount);
843         emit Transfer(account, address(0), amount);
844     }
845 
846     /**
847      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
848      *
849      * This internal function is equivalent to `approve`, and can be used to
850      * e.g. set automatic allowances for certain subsystems, etc.
851      *
852      * Emits an {Approval} event.
853      *
854      * Requirements:
855      *
856      * - `owner` cannot be the zero address.
857      * - `spender` cannot be the zero address.
858      */
859     function _approve(address owner, address spender, uint256 amount) internal virtual {
860         require(owner != address(0), "ERC20: approve from the zero address");
861         require(spender != address(0), "ERC20: approve to the zero address");
862 
863         _allowances[owner][spender] = amount;
864         emit Approval(owner, spender, amount);
865     }
866 
867     /**
868      * @dev Sets {decimals} to a value other than the default one of 18.
869      *
870      * WARNING: This function should only be called from the constructor. Most
871      * applications that interact with token contracts will not expect
872      * {decimals} to ever change, and may work incorrectly if it does.
873      */
874     function _setupDecimals(uint8 decimals_) internal {
875         _decimals = decimals_;
876     }
877 
878     /**
879      * @dev Hook that is called before any transfer of tokens. This includes
880      * minting and burning.
881      *
882      * Calling conditions:
883      *
884      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
885      * will be to transferred to `to`.
886      * - when `from` is zero, `amount` tokens will be minted for `to`.
887      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
888      * - `from` and `to` are never both zero.
889      *
890      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
891      */
892     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
893 }
894 
895 
896 contract vZKSToken is ERC20, Ownable {
897     string public constant TOKEN_NAME = "vZooKeeperShareToken";
898     string public constant TOKEN_SYMBOL = "vZKS";
899     uint8 public constant TOKEN_DECIMALS = 0;
900 
901     constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) public {
902         _setupDecimals(TOKEN_DECIMALS);
903     }
904 
905     function mint(address account, uint256 amount) public onlyOwner {
906         _mint(account, amount);
907     }
908 }
909 
910 
911 contract TreasuryAllocator is Ownable {
912     address public allocator;
913 
914     modifier onlyAllocator() {
915         require(_msgSender() == allocator, "Caller is not allocator");
916         _;
917     }
918 
919     function setAllocator(address _allocator)
920     external
921     onlyOwner
922     {
923         allocator = _allocator;
924     }
925 }
926 
927 
928 interface IRewardTreasury {
929     function allocateReward() external returns(uint256);
930 }
931 
932 
933 contract ZooRewardTreasury is TreasuryAllocator, IRewardTreasury {
934     using SafeERC20 for IERC20;
935 
936     IERC20 public token;
937 
938     event RewardAllocated(address indexed to, uint256 amount);
939 
940     constructor(address _token) public {
941         token = IERC20(_token);
942     }
943 
944     function allocateReward() external override onlyAllocator returns (uint256) {
945         uint256 bal = token.balanceOf(address(this));
946         uint256 half = bal / 2;
947 
948         token.safeTransfer(msg.sender, half);
949         emit RewardAllocated(msg.sender, half);
950 
951         return half;
952     }
953 
954     function emergencyWithdraw(address _token, uint256 _amount) external onlyOwner {
955         IERC20(_token).safeTransfer(msg.sender, _amount);
956     }
957 }
958 
959 
960 interface IReferral {
961     function setReferrer(address farmer, address referrer) external;
962     function getReferrer(address farmer) external view returns (address);
963     function isValidReferrer(address referrer) external view returns (bool);
964     function rndSeed(uint256 rnd) external view returns (address, bool);
965 }
966 
967 
968 interface IOracle {
969     function update() external;
970     function estimateRequirement(address account, uint256 hashrate) external view returns(uint256, uint256, uint256);
971 }
972 
973 
974 contract ZooPool is LPTokenWrapperV3, Ownable {
975     using SafeMath for uint256;
976     using SafeERC20 for IERC20;
977 
978     uint256 public epoch = 0;
979     IERC20 public rewardToken = IERC20(0xA56Ed2632E443Db5f93e73C89df399a081408Cc4);
980 
981     vZKSToken public vZKShareToken;
982     uint256[] public animalHashrates;
983 
984     IOracle public iOracle;
985     IReferral public iReferral;
986     IRewardTreasury public iZooRewardTreasury;
987 
988     uint256 public constant DURATION = 105 days;
989 
990     uint256 public periodFinish = 0;
991     uint256 public rewardRate = 0;
992     uint256 public lastUpdateTime;
993     uint256 public rewardPerTokenStored;
994 
995     mapping(address => uint256) public userRewardPerTokenPaid;
996     mapping(address => uint256) public rewards;
997 
998     event RewardAdded(uint256 reward);
999     event Staked(address indexed user, uint256 amount);
1000     event Withdrawn(address indexed user, uint256 amount);
1001     event RewardPaid(address indexed user, uint256 reward);
1002 
1003     constructor(address _rewardToken, address _daoTreasury, address _iReferral, address _oracle, address _zooRewardTreasury) LPTokenWrapperV3(_rewardToken, _daoTreasury) public {
1004         rewardToken = IERC20(_rewardToken);
1005         iReferral = IReferral(_iReferral);
1006         iOracle = IOracle(_oracle);
1007         vZKShareToken = new vZKSToken();
1008         iZooRewardTreasury = IRewardTreasury(_zooRewardTreasury);
1009         animalHashrates.push(0);
1010     }
1011 
1012     function addAnimals(uint256[] calldata hashrates) public onlyOwner {
1013         require(hashrates.length > 0, "!empty");
1014         for (uint i = 0; i < hashrates.length; i++) {
1015             animalHashrates.push(hashrates[i]);
1016         }
1017     }
1018 
1019     function setTreasury(address _newTreasury) public onlyOwner {
1020         treasury = _newTreasury;
1021     }
1022 
1023     function setOracle(address _oracle) public onlyOwner {
1024         require(_oracle != address(0), "!zero address");
1025         iOracle = IOracle(_oracle);
1026     }
1027 
1028     modifier updateReward(address account) {
1029         rewardPerTokenStored = rewardPerToken();
1030         lastUpdateTime = lastTimeRewardApplicable();
1031         if (account != address(0)) {
1032             rewards[account] = earned(account);
1033             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1034         }
1035         _;
1036     }
1037 
1038     modifier checkHalve() {
1039         if (block.timestamp >= periodFinish) {
1040             epoch = epoch + 1;
1041 
1042             uint256 reward = iZooRewardTreasury.allocateReward();
1043             rewardRate = reward.div(DURATION);
1044             lastUpdateTime = block.timestamp;
1045             periodFinish = block.timestamp.add(DURATION);
1046 
1047             emit RewardAdded(reward);
1048         }
1049         _;
1050     }
1051 
1052     function lastTimeRewardApplicable() public view returns (uint256) {
1053         return Math.min(block.timestamp, periodFinish);
1054     }
1055 
1056     function rewardPerToken() public view returns (uint256) {
1057         if (totalSupply() == 0) {
1058             return rewardPerTokenStored;
1059         }
1060         return rewardPerTokenStored.add(
1061             lastTimeRewardApplicable()
1062             .sub(lastUpdateTime)
1063             .mul(rewardRate)
1064             .mul(1e18)
1065             .div(totalSupply())
1066         );
1067     }
1068 
1069     function earned(address account) public view returns (uint256) {
1070         return balanceOf(account)
1071         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1072         .div(1e18)
1073         .add(rewards[account]);
1074     }
1075 
1076     function firstBuyTicketRand(uint8[] calldata _ids, uint8[] calldata _counts, uint256 rand) public {
1077         require(!iReferral.isValidReferrer(msg.sender), 'DAO: not first');
1078 
1079         (address _referrerAddress,) = iReferral.rndSeed(rand);
1080         iReferral.setReferrer(msg.sender, _referrerAddress);
1081 
1082         _buyTicket(_ids, _counts, msg.sender);
1083     }
1084 
1085     function firstBuyTicket(uint8[] calldata _ids, uint8[] calldata _counts, address _referrerAddress) public {
1086         require(!iReferral.isValidReferrer(msg.sender), 'DAO: not first');
1087 
1088         iReferral.setReferrer(msg.sender, _referrerAddress);
1089 
1090         _buyTicket(_ids, _counts, msg.sender);
1091     }
1092 
1093     function buyTicket(uint8[] calldata ids, uint8[] calldata counts) public {
1094         require(iReferral.isValidReferrer(msg.sender), 'DAO: the caller should be a referer');
1095 
1096         _buyTicket(ids, counts, msg.sender);
1097     }
1098 
1099     function buyTicketFor(uint8[] calldata _ids, uint8[] calldata _counts, address _referrerAddress, address _beneficiaryAddress) public {
1100         require(iReferral.isValidReferrer(_referrerAddress), 'DAO: the caller should be a referer');
1101         require(_beneficiaryAddress != address(0), 'DAO: cannot be 0');
1102         if (!iReferral.isValidReferrer(_beneficiaryAddress)) {
1103             iReferral.setReferrer(_beneficiaryAddress, _referrerAddress);
1104         }
1105 
1106         _buyTicket(_ids, _counts, _beneficiaryAddress);
1107     }
1108 
1109     function _buyTicket(uint8[] calldata _ids, uint8[] calldata _counts, address _userAddress)
1110     internal
1111     updateReward(_userAddress)
1112     checkHalve
1113     {
1114         iOracle.update();
1115         address _referrerAddress = iReferral.getReferrer(_userAddress);
1116         (uint256 userHashrate, uint256 userAmount, uint256 referReward) = estimateTokenAmount(_ids, _counts);
1117 
1118         super._stake(userAmount, userHashrate, _userAddress);
1119         vZKShareToken.mint(_referrerAddress, referReward);
1120     }
1121 
1122     function getReward() public updateReward(msg.sender) checkHalve {
1123         uint256 reward = earned(msg.sender);
1124         if (reward > 0) {
1125             rewards[msg.sender] = 0;
1126             rewardToken.safeTransfer(msg.sender, reward);
1127             emit RewardPaid(msg.sender, reward);
1128         }
1129     }
1130 
1131     function animalsCount() public view returns (uint256) {
1132         return animalHashrates.length;
1133     }
1134 
1135     function estimateHashrate(uint8[] calldata ids, uint8[] calldata counts) public view returns (uint256) {
1136         require(ids.length == counts.length, "!length not equal");
1137         uint256 hashrate = 0;
1138         for (uint i = 0; i < ids.length; i++) {
1139             uint animalIdx = ids[i];
1140             hashrate = hashrate.add(animalHashrates[animalIdx] * counts[i]);
1141         }
1142         return hashrate;
1143     }
1144 
1145     function estimateTokenAmount(uint8[] calldata ids, uint8[] calldata counts) public view returns (uint256 userHashrate, uint256 userAmount, uint256 referReward) {
1146         uint256 hashrate = estimateHashrate(ids, counts);
1147         (userHashrate, userAmount, referReward) = iOracle.estimateRequirement(msg.sender, hashrate);
1148     }
1149 
1150     function emergencyWithdraw(address _token, uint256 _amount) external onlyOwner {
1151         IERC20(_token).safeTransfer(msg.sender, _amount);
1152     }
1153 }