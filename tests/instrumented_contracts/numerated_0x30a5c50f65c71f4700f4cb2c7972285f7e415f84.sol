1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 pragma solidity ^0.6.0;
386 
387 
388 
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using SafeMath for uint256;
401     using Address for address;
402 
403     function safeTransfer(IERC20 token, address to, uint256 value) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
409     }
410 
411     /**
412      * @dev Deprecated. This function has issues similar to the ones found in
413      * {IERC20-approve}, and its usage is discouraged.
414      *
415      * Whenever possible, use {safeIncreaseAllowance} and
416      * {safeDecreaseAllowance} instead.
417      */
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
448         // the target address contains contract code and also asserts for success in the low-level call.
449 
450         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
451         if (returndata.length > 0) { // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts/GSN/Context.sol
459 
460 pragma solidity ^0.6.0;
461 
462 /*
463  * @dev Provides information about the current execution context, including the
464  * sender of the transaction and its data. While these are generally available
465  * via msg.sender and msg.data, they should not be accessed in such a direct
466  * manner, since when dealing with GSN meta-transactions the account sending and
467  * paying for execution may not be the actual sender (as far as an application
468  * is concerned).
469  *
470  * This contract is only required for intermediate, library-like contracts.
471  */
472 abstract contract Context {
473     function _msgSender() internal view virtual returns (address payable) {
474         return msg.sender;
475     }
476 
477     function _msgData() internal view virtual returns (bytes memory) {
478         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
479         return msg.data;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/access/Ownable.sol
484 
485 pragma solidity ^0.6.0;
486 
487 /**
488  * @dev Contract module which provides a basic access control mechanism, where
489  * there is an account (an owner) that can be granted exclusive access to
490  * specific functions.
491  *
492  * By default, the owner account will be the one that deploys the contract. This
493  * can later be changed with {transferOwnership}.
494  *
495  * This module is used through inheritance. It will make available the modifier
496  * `onlyOwner`, which can be applied to your functions to restrict their use to
497  * the owner.
498  */
499 contract Ownable is Context {
500     address private _owner;
501 
502     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
503 
504     /**
505      * @dev Initializes the contract setting the deployer as the initial owner.
506      */
507     constructor () internal {
508         address msgSender = _msgSender();
509         _owner = msgSender;
510         emit OwnershipTransferred(address(0), msgSender);
511     }
512 
513     /**
514      * @dev Returns the address of the current owner.
515      */
516     function owner() public view returns (address) {
517         return _owner;
518     }
519 
520     /**
521      * @dev Throws if called by any account other than the owner.
522      */
523     modifier onlyOwner() {
524         require(_owner == _msgSender(), "Ownable: caller is not the owner");
525         _;
526     }
527 
528     /**
529      * @dev Leaves the contract without owner. It will not be possible to call
530      * `onlyOwner` functions anymore. Can only be called by the current owner.
531      *
532      * NOTE: Renouncing ownership will leave the contract without an owner,
533      * thereby removing any functionality that is only available to the owner.
534      */
535     function renounceOwnership() public virtual onlyOwner {
536         emit OwnershipTransferred(_owner, address(0));
537         _owner = address(0);
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Can only be called by the current owner.
543      */
544     function transferOwnership(address newOwner) public virtual onlyOwner {
545         require(newOwner != address(0), "Ownable: new owner is the zero address");
546         emit OwnershipTransferred(_owner, newOwner);
547         _owner = newOwner;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
552 
553 pragma solidity ^0.6.0;
554 
555 
556 
557 
558 
559 /**
560  * @dev Implementation of the {IERC20} interface.
561  *
562  * This implementation is agnostic to the way tokens are created. This means
563  * that a supply mechanism has to be added in a derived contract using {_mint}.
564  * For a generic mechanism see {ERC20PresetMinterPauser}.
565  *
566  * TIP: For a detailed writeup see our guide
567  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
568  * to implement supply mechanisms].
569  *
570  * We have followed general OpenZeppelin guidelines: functions revert instead
571  * of returning `false` on failure. This behavior is nonetheless conventional
572  * and does not conflict with the expectations of ERC20 applications.
573  *
574  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
575  * This allows applications to reconstruct the allowance for all accounts just
576  * by listening to said events. Other implementations of the EIP may not emit
577  * these events, as it isn't required by the specification.
578  *
579  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
580  * functions have been added to mitigate the well-known issues around setting
581  * allowances. See {IERC20-approve}.
582  */
583 contract ERC20 is Context, IERC20 {
584     using SafeMath for uint256;
585     using Address for address;
586 
587     mapping (address => uint256) private _balances;
588 
589     mapping (address => mapping (address => uint256)) private _allowances;
590 
591     uint256 private _totalSupply;
592 
593     string private _name;
594     string private _symbol;
595     uint8 private _decimals;
596 
597     /**
598      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
599      * a default value of 18.
600      *
601      * To select a different value for {decimals}, use {_setupDecimals}.
602      *
603      * All three of these values are immutable: they can only be set once during
604      * construction.
605      */
606     constructor (string memory name, string memory symbol) public {
607         _name = name;
608         _symbol = symbol;
609         _decimals = 18;
610     }
611 
612     /**
613      * @dev Returns the name of the token.
614      */
615     function name() public view returns (string memory) {
616         return _name;
617     }
618 
619     /**
620      * @dev Returns the symbol of the token, usually a shorter version of the
621      * name.
622      */
623     function symbol() public view returns (string memory) {
624         return _symbol;
625     }
626 
627     /**
628      * @dev Returns the number of decimals used to get its user representation.
629      * For example, if `decimals` equals `2`, a balance of `505` tokens should
630      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
631      *
632      * Tokens usually opt for a value of 18, imitating the relationship between
633      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
634      * called.
635      *
636      * NOTE: This information is only used for _display_ purposes: it in
637      * no way affects any of the arithmetic of the contract, including
638      * {IERC20-balanceOf} and {IERC20-transfer}.
639      */
640     function decimals() public view returns (uint8) {
641         return _decimals;
642     }
643 
644     /**
645      * @dev See {IERC20-totalSupply}.
646      */
647     function totalSupply() public view override returns (uint256) {
648         return _totalSupply;
649     }
650 
651     /**
652      * @dev See {IERC20-balanceOf}.
653      */
654     function balanceOf(address account) public view override returns (uint256) {
655         return _balances[account];
656     }
657 
658     /**
659      * @dev See {IERC20-transfer}.
660      *
661      * Requirements:
662      *
663      * - `recipient` cannot be the zero address.
664      * - the caller must have a balance of at least `amount`.
665      */
666     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
667         _transfer(_msgSender(), recipient, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-allowance}.
673      */
674     function allowance(address owner, address spender) public view virtual override returns (uint256) {
675         return _allowances[owner][spender];
676     }
677 
678     /**
679      * @dev See {IERC20-approve}.
680      *
681      * Requirements:
682      *
683      * - `spender` cannot be the zero address.
684      */
685     function approve(address spender, uint256 amount) public virtual override returns (bool) {
686         _approve(_msgSender(), spender, amount);
687         return true;
688     }
689 
690     /**
691      * @dev See {IERC20-transferFrom}.
692      *
693      * Emits an {Approval} event indicating the updated allowance. This is not
694      * required by the EIP. See the note at the beginning of {ERC20};
695      *
696      * Requirements:
697      * - `sender` and `recipient` cannot be the zero address.
698      * - `sender` must have a balance of at least `amount`.
699      * - the caller must have allowance for ``sender``'s tokens of at least
700      * `amount`.
701      */
702     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
703         _transfer(sender, recipient, amount);
704         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
705         return true;
706     }
707 
708     /**
709      * @dev Atomically increases the allowance granted to `spender` by the caller.
710      *
711      * This is an alternative to {approve} that can be used as a mitigation for
712      * problems described in {IERC20-approve}.
713      *
714      * Emits an {Approval} event indicating the updated allowance.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      */
720     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
721         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
722         return true;
723     }
724 
725     /**
726      * @dev Atomically decreases the allowance granted to `spender` by the caller.
727      *
728      * This is an alternative to {approve} that can be used as a mitigation for
729      * problems described in {IERC20-approve}.
730      *
731      * Emits an {Approval} event indicating the updated allowance.
732      *
733      * Requirements:
734      *
735      * - `spender` cannot be the zero address.
736      * - `spender` must have allowance for the caller of at least
737      * `subtractedValue`.
738      */
739     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
740         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
741         return true;
742     }
743 
744     /**
745      * @dev Moves tokens `amount` from `sender` to `recipient`.
746      *
747      * This is internal function is equivalent to {transfer}, and can be used to
748      * e.g. implement automatic token fees, slashing mechanisms, etc.
749      *
750      * Emits a {Transfer} event.
751      *
752      * Requirements:
753      *
754      * - `sender` cannot be the zero address.
755      * - `recipient` cannot be the zero address.
756      * - `sender` must have a balance of at least `amount`.
757      */
758     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
759         require(sender != address(0), "ERC20: transfer from the zero address");
760         require(recipient != address(0), "ERC20: transfer to the zero address");
761 
762         _beforeTokenTransfer(sender, recipient, amount);
763 
764         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
765         _balances[recipient] = _balances[recipient].add(amount);
766         emit Transfer(sender, recipient, amount);
767     }
768 
769     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
770      * the total supply.
771      *
772      * Emits a {Transfer} event with `from` set to the zero address.
773      *
774      * Requirements
775      *
776      * - `to` cannot be the zero address.
777      */
778     function _mint(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: mint to the zero address");
780 
781         _beforeTokenTransfer(address(0), account, amount);
782 
783         _totalSupply = _totalSupply.add(amount);
784         _balances[account] = _balances[account].add(amount);
785         emit Transfer(address(0), account, amount);
786     }
787 
788     /**
789      * @dev Destroys `amount` tokens from `account`, reducing the
790      * total supply.
791      *
792      * Emits a {Transfer} event with `to` set to the zero address.
793      *
794      * Requirements
795      *
796      * - `account` cannot be the zero address.
797      * - `account` must have at least `amount` tokens.
798      */
799     function _burn(address account, uint256 amount) internal virtual {
800         require(account != address(0), "ERC20: burn from the zero address");
801 
802         _beforeTokenTransfer(account, address(0), amount);
803 
804         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
805         _totalSupply = _totalSupply.sub(amount);
806         emit Transfer(account, address(0), amount);
807     }
808 
809     /**
810      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
811      *
812      * This internal function is equivalent to `approve`, and can be used to
813      * e.g. set automatic allowances for certain subsystems, etc.
814      *
815      * Emits an {Approval} event.
816      *
817      * Requirements:
818      *
819      * - `owner` cannot be the zero address.
820      * - `spender` cannot be the zero address.
821      */
822     function _approve(address owner, address spender, uint256 amount) internal virtual {
823         require(owner != address(0), "ERC20: approve from the zero address");
824         require(spender != address(0), "ERC20: approve to the zero address");
825 
826         _allowances[owner][spender] = amount;
827         emit Approval(owner, spender, amount);
828     }
829 
830     /**
831      * @dev Sets {decimals} to a value other than the default one of 18.
832      *
833      * WARNING: This function should only be called from the constructor. Most
834      * applications that interact with token contracts will not expect
835      * {decimals} to ever change, and may work incorrectly if it does.
836      */
837     function _setupDecimals(uint8 decimals_) internal {
838         _decimals = decimals_;
839     }
840 
841     /**
842      * @dev Hook that is called before any transfer of tokens. This includes
843      * minting and burning.
844      *
845      * Calling conditions:
846      *
847      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
848      * will be to transferred to `to`.
849      * - when `from` is zero, `amount` tokens will be minted for `to`.
850      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
851      * - `from` and `to` are never both zero.
852      *
853      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
854      */
855     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
856 }
857 
858 // File: contracts/interfaces/IMigratorChef.sol
859 
860 pragma solidity 0.6.12;
861 
862 
863 interface IMigratorChef {
864     // Perform LP token migration from legacy UniswapV2 to SakeSwap.
865     // Take the current LP token address and return the new LP token address.
866     // Migrator should have full access to the caller's LP token.
867     // Return the new LP token address.
868     //
869     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
870     // SakeSwap must mint EXACTLY the same amount of SakeSwap LP tokens or
871     // else something bad will happen. Traditional UniswapV2 does not
872     // do that so be careful!
873     function migrate(IERC20 token) external returns (IERC20);
874 }
875 
876 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
877 
878 pragma solidity ^0.6.0;
879 
880 /**
881  * @dev Library for managing
882  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
883  * types.
884  *
885  * Sets have the following properties:
886  *
887  * - Elements are added, removed, and checked for existence in constant time
888  * (O(1)).
889  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
890  *
891  * ```
892  * contract Example {
893  *     // Add the library methods
894  *     using EnumerableSet for EnumerableSet.AddressSet;
895  *
896  *     // Declare a set state variable
897  *     EnumerableSet.AddressSet private mySet;
898  * }
899  * ```
900  *
901  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
902  * (`UintSet`) are supported.
903  */
904 library EnumerableSet {
905     // To implement this library for multiple types with as little code
906     // repetition as possible, we write it in terms of a generic Set type with
907     // bytes32 values.
908     // The Set implementation uses private functions, and user-facing
909     // implementations (such as AddressSet) are just wrappers around the
910     // underlying Set.
911     // This means that we can only create new EnumerableSets for types that fit
912     // in bytes32.
913 
914     struct Set {
915         // Storage of set values
916         bytes32[] _values;
917 
918         // Position of the value in the `values` array, plus 1 because index 0
919         // means a value is not in the set.
920         mapping (bytes32 => uint256) _indexes;
921     }
922 
923     /**
924      * @dev Add a value to a set. O(1).
925      *
926      * Returns true if the value was added to the set, that is if it was not
927      * already present.
928      */
929     function _add(Set storage set, bytes32 value) private returns (bool) {
930         if (!_contains(set, value)) {
931             set._values.push(value);
932             // The value is stored at length-1, but we add 1 to all indexes
933             // and use 0 as a sentinel value
934             set._indexes[value] = set._values.length;
935             return true;
936         } else {
937             return false;
938         }
939     }
940 
941     /**
942      * @dev Removes a value from a set. O(1).
943      *
944      * Returns true if the value was removed from the set, that is if it was
945      * present.
946      */
947     function _remove(Set storage set, bytes32 value) private returns (bool) {
948         // We read and store the value's index to prevent multiple reads from the same storage slot
949         uint256 valueIndex = set._indexes[value];
950 
951         if (valueIndex != 0) { // Equivalent to contains(set, value)
952             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
953             // the array, and then remove the last element (sometimes called as 'swap and pop').
954             // This modifies the order of the array, as noted in {at}.
955 
956             uint256 toDeleteIndex = valueIndex - 1;
957             uint256 lastIndex = set._values.length - 1;
958 
959             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
960             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
961 
962             bytes32 lastvalue = set._values[lastIndex];
963 
964             // Move the last value to the index where the value to delete is
965             set._values[toDeleteIndex] = lastvalue;
966             // Update the index for the moved value
967             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
968 
969             // Delete the slot where the moved value was stored
970             set._values.pop();
971 
972             // Delete the index for the deleted slot
973             delete set._indexes[value];
974 
975             return true;
976         } else {
977             return false;
978         }
979     }
980 
981     /**
982      * @dev Returns true if the value is in the set. O(1).
983      */
984     function _contains(Set storage set, bytes32 value) private view returns (bool) {
985         return set._indexes[value] != 0;
986     }
987 
988     /**
989      * @dev Returns the number of values on the set. O(1).
990      */
991     function _length(Set storage set) private view returns (uint256) {
992         return set._values.length;
993     }
994 
995    /**
996     * @dev Returns the value stored at position `index` in the set. O(1).
997     *
998     * Note that there are no guarantees on the ordering of values inside the
999     * array, and it may change when more values are added or removed.
1000     *
1001     * Requirements:
1002     *
1003     * - `index` must be strictly less than {length}.
1004     */
1005     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1006         require(set._values.length > index, "EnumerableSet: index out of bounds");
1007         return set._values[index];
1008     }
1009 
1010     // AddressSet
1011 
1012     struct AddressSet {
1013         Set _inner;
1014     }
1015 
1016     /**
1017      * @dev Add a value to a set. O(1).
1018      *
1019      * Returns true if the value was added to the set, that is if it was not
1020      * already present.
1021      */
1022     function add(AddressSet storage set, address value) internal returns (bool) {
1023         return _add(set._inner, bytes32(uint256(value)));
1024     }
1025 
1026     /**
1027      * @dev Removes a value from a set. O(1).
1028      *
1029      * Returns true if the value was removed from the set, that is if it was
1030      * present.
1031      */
1032     function remove(AddressSet storage set, address value) internal returns (bool) {
1033         return _remove(set._inner, bytes32(uint256(value)));
1034     }
1035 
1036     /**
1037      * @dev Returns true if the value is in the set. O(1).
1038      */
1039     function contains(AddressSet storage set, address value) internal view returns (bool) {
1040         return _contains(set._inner, bytes32(uint256(value)));
1041     }
1042 
1043     /**
1044      * @dev Returns the number of values in the set. O(1).
1045      */
1046     function length(AddressSet storage set) internal view returns (uint256) {
1047         return _length(set._inner);
1048     }
1049 
1050    /**
1051     * @dev Returns the value stored at position `index` in the set. O(1).
1052     *
1053     * Note that there are no guarantees on the ordering of values inside the
1054     * array, and it may change when more values are added or removed.
1055     *
1056     * Requirements:
1057     *
1058     * - `index` must be strictly less than {length}.
1059     */
1060     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1061         return address(uint256(_at(set._inner, index)));
1062     }
1063 
1064 
1065     // UintSet
1066 
1067     struct UintSet {
1068         Set _inner;
1069     }
1070 
1071     /**
1072      * @dev Add a value to a set. O(1).
1073      *
1074      * Returns true if the value was added to the set, that is if it was not
1075      * already present.
1076      */
1077     function add(UintSet storage set, uint256 value) internal returns (bool) {
1078         return _add(set._inner, bytes32(value));
1079     }
1080 
1081     /**
1082      * @dev Removes a value from a set. O(1).
1083      *
1084      * Returns true if the value was removed from the set, that is if it was
1085      * present.
1086      */
1087     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1088         return _remove(set._inner, bytes32(value));
1089     }
1090 
1091     /**
1092      * @dev Returns true if the value is in the set. O(1).
1093      */
1094     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1095         return _contains(set._inner, bytes32(value));
1096     }
1097 
1098     /**
1099      * @dev Returns the number of values on the set. O(1).
1100      */
1101     function length(UintSet storage set) internal view returns (uint256) {
1102         return _length(set._inner);
1103     }
1104 
1105    /**
1106     * @dev Returns the value stored at position `index` in the set. O(1).
1107     *
1108     * Note that there are no guarantees on the ordering of values inside the
1109     * array, and it may change when more values are added or removed.
1110     *
1111     * Requirements:
1112     *
1113     * - `index` must be strictly less than {length}.
1114     */
1115     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1116         return uint256(_at(set._inner, index));
1117     }
1118 }
1119 
1120 // File: contracts/SakeToken.sol
1121 
1122 pragma solidity 0.6.12;
1123 
1124 
1125 
1126 
1127 
1128 
1129 // SakeToken with Governance.
1130 contract SakeToken is Context, IERC20, Ownable {
1131     using SafeMath for uint256;
1132     using Address for address;
1133 
1134     mapping (address => uint256) private _balances;
1135 
1136     mapping (address => mapping (address => uint256)) private _allowances;
1137 
1138     uint256 private _totalSupply;
1139 
1140     string private _name = "SakeToken";
1141     string private _symbol = "SAKE";
1142     uint8 private _decimals = 18;
1143 
1144     /**
1145      * @dev Returns the name of the token.
1146      */
1147     function name() public view returns (string memory) {
1148         return _name;
1149     }
1150 
1151     /**
1152      * @dev Returns the symbol of the token, usually a shorter version of the
1153      * name.
1154      */
1155     function symbol() public view returns (string memory) {
1156         return _symbol;
1157     }
1158 
1159     /**
1160      * @dev Returns the number of decimals used to get its user representation.
1161      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1162      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1163      *
1164      * Tokens usually opt for a value of 18, imitating the relationship between
1165      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1166      * called.
1167      *
1168      * NOTE: This information is only used for _display_ purposes: it in
1169      * no way affects any of the arithmetic of the contract, including
1170      * {IERC20-balanceOf} and {IERC20-transfer}.
1171      */
1172     function decimals() public view returns (uint8) {
1173         return _decimals;
1174     }
1175 
1176     /**
1177      * @dev See {IERC20-totalSupply}.
1178      */
1179     function totalSupply() public view override returns (uint256) {
1180         return _totalSupply;
1181     }
1182 
1183     /**
1184      * @dev See {IERC20-balanceOf}.
1185      */
1186     function balanceOf(address account) public view override returns (uint256) {
1187         return _balances[account];
1188     }
1189 
1190     /**
1191      * @dev See {IERC20-transfer}.
1192      *
1193      * Requirements:
1194      *
1195      * - `recipient` cannot be the zero address.
1196      * - the caller must have a balance of at least `amount`.
1197      */
1198     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1199         _transfer(_msgSender(), recipient, amount);
1200         return true;
1201     }
1202 
1203     /**
1204      * @dev See {IERC20-allowance}.
1205      */
1206     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1207         return _allowances[owner][spender];
1208     }
1209 
1210     /**
1211      * @dev See {IERC20-approve}.
1212      *
1213      * Requirements:
1214      *
1215      * - `spender` cannot be the zero address.
1216      */
1217     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1218         _approve(_msgSender(), spender, amount);
1219         return true;
1220     }
1221 
1222     /**
1223      * @dev See {IERC20-transferFrom}.
1224      *
1225      * Emits an {Approval} event indicating the updated allowance. This is not
1226      * required by the EIP. See the note at the beginning of {ERC20};
1227      *
1228      * Requirements:
1229      * - `sender` and `recipient` cannot be the zero address.
1230      * - `sender` must have a balance of at least `amount`.
1231      * - the caller must have allowance for ``sender``'s tokens of at least
1232      * `amount`.
1233      */
1234     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1235         _transfer(sender, recipient, amount);
1236         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1237         return true;
1238     }
1239 
1240     /**
1241      * @dev Atomically increases the allowance granted to `spender` by the caller.
1242      *
1243      * This is an alternative to {approve} that can be used as a mitigation for
1244      * problems described in {IERC20-approve}.
1245      *
1246      * Emits an {Approval} event indicating the updated allowance.
1247      *
1248      * Requirements:
1249      *
1250      * - `spender` cannot be the zero address.
1251      */
1252     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1253         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1254         return true;
1255     }
1256 
1257     /**
1258      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1259      *
1260      * This is an alternative to {approve} that can be used as a mitigation for
1261      * problems described in {IERC20-approve}.
1262      *
1263      * Emits an {Approval} event indicating the updated allowance.
1264      *
1265      * Requirements:
1266      *
1267      * - `spender` cannot be the zero address.
1268      * - `spender` must have allowance for the caller of at least
1269      * `subtractedValue`.
1270      */
1271     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1272         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1273         return true;
1274     }
1275 
1276     /**
1277      * @dev Moves tokens `amount` from `sender` to `recipient`.
1278      *
1279      * This is internal function is equivalent to {transfer}, and can be used to
1280      * e.g. implement automatic token fees, slashing mechanisms, etc.
1281      *
1282      * Emits a {Transfer} event.
1283      *
1284      * Requirements:
1285      *
1286      * - `sender` cannot be the zero address.
1287      * - `recipient` cannot be the zero address.
1288      * - `sender` must have a balance of at least `amount`.
1289      */
1290     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1291         require(sender != address(0), "ERC20: transfer from the zero address");
1292         require(recipient != address(0), "ERC20: transfer to the zero address");
1293 
1294         _beforeTokenTransfer(sender, recipient, amount);
1295 
1296         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1297         _balances[recipient] = _balances[recipient].add(amount);
1298         emit Transfer(sender, recipient, amount);
1299 
1300         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
1301     }
1302 
1303     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1304      * the total supply.
1305      *
1306      * Emits a {Transfer} event with `from` set to the zero address.
1307      *
1308      * Requirements
1309      *
1310      * - `to` cannot be the zero address.
1311      */
1312     function _mint(address account, uint256 amount) internal virtual {
1313         require(account != address(0), "ERC20: mint to the zero address");
1314 
1315         _beforeTokenTransfer(address(0), account, amount);
1316 
1317         _totalSupply = _totalSupply.add(amount);
1318         _balances[account] = _balances[account].add(amount);
1319         emit Transfer(address(0), account, amount);
1320     }
1321 
1322     /**
1323      * @dev Destroys `amount` tokens from `account`, reducing the
1324      * total supply.
1325      *
1326      * Emits a {Transfer} event with `to` set to the zero address.
1327      *
1328      * Requirements
1329      *
1330      * - `account` cannot be the zero address.
1331      * - `account` must have at least `amount` tokens.
1332      */
1333     function _burn(address account, uint256 amount) internal virtual {
1334         require(account != address(0), "ERC20: burn from the zero address");
1335 
1336         _beforeTokenTransfer(account, address(0), amount);
1337 
1338         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1339         _totalSupply = _totalSupply.sub(amount);
1340         emit Transfer(account, address(0), amount);
1341     }
1342 
1343     /**
1344      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1345      *
1346      * This is internal function is equivalent to `approve`, and can be used to
1347      * e.g. set automatic allowances for certain subsystems, etc.
1348      *
1349      * Emits an {Approval} event.
1350      *
1351      * Requirements:
1352      *
1353      * - `owner` cannot be the zero address.
1354      * - `spender` cannot be the zero address.
1355      */
1356     function _approve(address owner, address spender, uint256 amount) internal virtual {
1357         require(owner != address(0), "ERC20: approve from the zero address");
1358         require(spender != address(0), "ERC20: approve to the zero address");
1359 
1360         _allowances[owner][spender] = amount;
1361         emit Approval(owner, spender, amount);
1362     }
1363 
1364     /**
1365      * @dev Sets {decimals} to a value other than the default one of 18.
1366      *
1367      * WARNING: This function should only be called from the constructor. Most
1368      * applications that interact with token contracts will not expect
1369      * {decimals} to ever change, and may work incorrectly if it does.
1370      */
1371     function _setupDecimals(uint8 decimals_) internal {
1372         _decimals = decimals_;
1373     }
1374 
1375     /**
1376      * @dev Hook that is called before any transfer of tokens. This includes
1377      * minting and burning.
1378      *
1379      * Calling conditions:
1380      *
1381      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1382      * will be to transferred to `to`.
1383      * - when `from` is zero, `amount` tokens will be minted for `to`.
1384      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1385      * - `from` and `to` are never both zero.
1386      *
1387      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1388      */
1389     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1390 
1391     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (SakeMaster).
1392     function mint(address _to, uint256 _amount) public onlyOwner {
1393         _mint(_to, _amount);
1394         _moveDelegates(address(0), _delegates[_to], _amount);
1395     }
1396 
1397     // Copied and modified from YAM code:
1398     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
1399     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
1400     // Which is copied and modified from COMPOUND:
1401     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1402 
1403     /// @notice A record of each accounts delegate
1404     mapping (address => address) internal _delegates;
1405 
1406     /// @notice A checkpoint for marking number of votes from a given block
1407     struct Checkpoint {
1408         uint32 fromBlock;
1409         uint256 votes;
1410     }
1411 
1412     /// @notice A record of votes checkpoints for each account, by index
1413     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1414 
1415     /// @notice The number of checkpoints for each account
1416     mapping (address => uint32) public numCheckpoints;
1417 
1418     /// @notice The EIP-712 typehash for the contract's domain
1419     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1420 
1421     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1422     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1423 
1424     /// @notice A record of states for signing / validating signatures
1425     mapping (address => uint) public nonces;
1426 
1427     /// @notice An event thats emitted when an account changes its delegate
1428     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1429 
1430     /// @notice An event thats emitted when a delegate account's vote balance changes
1431     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1432 
1433     /**
1434      * @notice Delegate votes from `msg.sender` to `delegatee`
1435      * @param delegator The address to get delegatee for
1436      */
1437     function delegates(address delegator)
1438         external
1439         view
1440         returns (address)
1441     {
1442         return _delegates[delegator];
1443     }
1444 
1445    /**
1446     * @notice Delegate votes from `msg.sender` to `delegatee`
1447     * @param delegatee The address to delegate votes to
1448     */
1449     function delegate(address delegatee) external {
1450         return _delegate(msg.sender, delegatee);
1451     }
1452 
1453     /**
1454      * @notice Delegates votes from signatory to `delegatee`
1455      * @param delegatee The address to delegate votes to
1456      * @param nonce The contract state required to match the signature
1457      * @param expiry The time at which to expire the signature
1458      * @param v The recovery byte of the signature
1459      * @param r Half of the ECDSA signature pair
1460      * @param s Half of the ECDSA signature pair
1461      */
1462     function delegateBySig(
1463         address delegatee,
1464         uint nonce,
1465         uint expiry,
1466         uint8 v,
1467         bytes32 r,
1468         bytes32 s
1469     )
1470         external
1471     {
1472         bytes32 domainSeparator = keccak256(
1473             abi.encode(
1474                 DOMAIN_TYPEHASH,
1475                 keccak256(bytes(name())),
1476                 getChainId(),
1477                 address(this)
1478             )
1479         );
1480 
1481         bytes32 structHash = keccak256(
1482             abi.encode(
1483                 DELEGATION_TYPEHASH,
1484                 delegatee,
1485                 nonce,
1486                 expiry
1487             )
1488         );
1489 
1490         bytes32 digest = keccak256(
1491             abi.encodePacked(
1492                 "\x19\x01",
1493                 domainSeparator,
1494                 structHash
1495             )
1496         );
1497 
1498         address signatory = ecrecover(digest, v, r, s);
1499         require(signatory != address(0), "SAKE::delegateBySig: invalid signature");
1500         require(nonce == nonces[signatory]++, "SAKE::delegateBySig: invalid nonce");
1501         require(now <= expiry, "SAKE::delegateBySig: signature expired");
1502         return _delegate(signatory, delegatee);
1503     }
1504 
1505     /**
1506      * @notice Gets the current votes balance for `account`
1507      * @param account The address to get votes balance
1508      * @return The number of current votes for `account`
1509      */
1510     function getCurrentVotes(address account)
1511         external
1512         view
1513         returns (uint256)
1514     {
1515         uint32 nCheckpoints = numCheckpoints[account];
1516         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1517     }
1518 
1519     /**
1520      * @notice Determine the prior number of votes for an account as of a block number
1521      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1522      * @param account The address of the account to check
1523      * @param blockNumber The block number to get the vote balance at
1524      * @return The number of votes the account had as of the given block
1525      */
1526     function getPriorVotes(address account, uint blockNumber)
1527         external
1528         view
1529         returns (uint256)
1530     {
1531         require(blockNumber < block.number, "SAKE::getPriorVotes: not yet determined");
1532 
1533         uint32 nCheckpoints = numCheckpoints[account];
1534         if (nCheckpoints == 0) {
1535             return 0;
1536         }
1537 
1538         // First check most recent balance
1539         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1540             return checkpoints[account][nCheckpoints - 1].votes;
1541         }
1542 
1543         // Next check implicit zero balance
1544         if (checkpoints[account][0].fromBlock > blockNumber) {
1545             return 0;
1546         }
1547 
1548         uint32 lower = 0;
1549         uint32 upper = nCheckpoints - 1;
1550         while (upper > lower) {
1551             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1552             Checkpoint memory cp = checkpoints[account][center];
1553             if (cp.fromBlock == blockNumber) {
1554                 return cp.votes;
1555             } else if (cp.fromBlock < blockNumber) {
1556                 lower = center;
1557             } else {
1558                 upper = center - 1;
1559             }
1560         }
1561         return checkpoints[account][lower].votes;
1562     }
1563 
1564     function _delegate(address delegator, address delegatee)
1565         internal
1566     {
1567         address currentDelegate = _delegates[delegator];
1568         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SAKEs (not scaled);
1569         _delegates[delegator] = delegatee;
1570 
1571         emit DelegateChanged(delegator, currentDelegate, delegatee);
1572 
1573         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1574     }
1575 
1576     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1577         if (srcRep != dstRep && amount > 0) {
1578             if (srcRep != address(0)) {
1579                 // decrease old representative
1580                 uint32 srcRepNum = numCheckpoints[srcRep];
1581                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1582                 uint256 srcRepNew = srcRepOld.sub(amount);
1583                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1584             }
1585 
1586             if (dstRep != address(0)) {
1587                 // increase new representative
1588                 uint32 dstRepNum = numCheckpoints[dstRep];
1589                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1590                 uint256 dstRepNew = dstRepOld.add(amount);
1591                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1592             }
1593         }
1594     }
1595 
1596     function _writeCheckpoint(
1597         address delegatee,
1598         uint32 nCheckpoints,
1599         uint256 oldVotes,
1600         uint256 newVotes
1601     )
1602         internal
1603     {
1604         uint32 blockNumber = safe32(block.number, "SAKE::_writeCheckpoint: block number exceeds 32 bits");
1605 
1606         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1607             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1608         } else {
1609             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1610             numCheckpoints[delegatee] = nCheckpoints + 1;
1611         }
1612 
1613         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1614     }
1615 
1616     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1617         require(n < 2**32, errorMessage);
1618         return uint32(n);
1619     }
1620 
1621     function getChainId() internal pure returns (uint) {
1622         uint256 chainId;
1623         assembly { chainId := chainid() }
1624         return chainId;
1625     }
1626 }
1627 
1628 // File: contracts/SakeMaster.sol
1629 
1630 pragma solidity 0.6.12;
1631 
1632 
1633 
1634 
1635 
1636 
1637 
1638 
1639 // SakeMaster is the master of Sake. He can make Sake and he is a fair guy.
1640 //
1641 // Note that it's ownable and the owner wields tremendous power. The ownership
1642 // will be transferred to a governance smart contract once SAKE is sufficiently
1643 // distributed and the community can show to govern itself.
1644 //
1645 // Have fun reading it. Hopefully it's bug-free. God bless.
1646 contract SakeMaster is Ownable {
1647     using SafeMath for uint256;
1648     using SafeERC20 for IERC20;
1649 
1650     // Info of each user.
1651     struct UserInfo {
1652         uint256 amount; // How many LP tokens the user has provided.
1653         uint256 rewardDebt; // Reward debt. See explanation below.
1654         //
1655         // We do some fancy math here. Basically, any point in time, the amount of SAKEs
1656         // entitled to a user but is pending to be distributed is:
1657         //
1658         //   pending reward = (user.amount * pool.accSakePerShare) - user.rewardDebt
1659         //
1660         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1661         //   1. The pool's `accSakePerShare` (and `lastRewardBlock`) gets updated.
1662         //   2. User receives the pending reward sent to his/her address.
1663         //   3. User's `amount` gets updated.
1664         //   4. User's `rewardDebt` gets updated.
1665     }
1666 
1667     // Info of each pool.
1668     struct PoolInfo {
1669         IERC20 lpToken; // Address of LP token contract.
1670         uint256 allocPoint; // How many allocation points assigned to this pool. SAKEs to distribute per block.
1671         uint256 lastRewardBlock; // Last block number that SAKEs distribution occurs.
1672         uint256 accSakePerShare; // Accumulated SAKEs per share, times 1e12. See below.
1673     }
1674 
1675     // The SAKE TOKEN!
1676     SakeToken public sake;
1677     // Dev address.
1678     address public devaddr;
1679     // Block number when beta test period ends.
1680     uint256 public betaTestEndBlock;
1681     // Block number when bonus SAKE period ends.
1682     uint256 public bonusEndBlock;
1683     // Block number when mint SAKE period ends.
1684     uint256 public mintEndBlock;
1685     // SAKE tokens created per block.
1686     uint256 public sakePerBlock;
1687     // Bonus muliplier for 5~20 days sake makers.
1688     uint256 public constant BONUSONE_MULTIPLIER = 20;
1689     // Bonus muliplier for 20~35 sake makers.
1690     uint256 public constant BONUSTWO_MULTIPLIER = 2;
1691     // beta test block num,about 5 days.
1692     uint256 public constant BETATEST_BLOCKNUM = 35000;
1693     // Bonus block num,about 15 days.
1694     uint256 public constant BONUS_BLOCKNUM = 100000;
1695     // mint end block num,about 30 days.
1696     uint256 public constant MINTEND_BLOCKNUM = 200000;
1697     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1698     IMigratorChef public migrator;
1699 
1700     // Info of each pool.
1701     PoolInfo[] public poolInfo;
1702     // Info of each user that stakes LP tokens.
1703     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1704     // Record whether the pair has been added.
1705     mapping(address => uint256) public lpTokenPID;
1706     // Total allocation poitns. Must be the sum of all allocation points in all pools.
1707     uint256 public totalAllocPoint = 0;
1708     // The block number when SAKE mining starts.
1709     uint256 public startBlock;
1710 
1711     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1712     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1713     event EmergencyWithdraw(
1714         address indexed user,
1715         uint256 indexed pid,
1716         uint256 amount
1717     );
1718 
1719     constructor(
1720         SakeToken _sake,
1721         address _devaddr,
1722         uint256 _sakePerBlock,
1723         uint256 _startBlock
1724     ) public {
1725         sake = _sake;
1726         devaddr = _devaddr;
1727         sakePerBlock = _sakePerBlock;
1728         startBlock = _startBlock;
1729         betaTestEndBlock = startBlock.add(BETATEST_BLOCKNUM);
1730         bonusEndBlock = startBlock.add(BONUS_BLOCKNUM).add(BETATEST_BLOCKNUM);
1731         mintEndBlock = startBlock.add(MINTEND_BLOCKNUM).add(BETATEST_BLOCKNUM);
1732     }
1733 
1734     function poolLength() external view returns (uint256) {
1735         return poolInfo.length;
1736     }
1737 
1738     // Add a new lp to the pool. Can only be called by the owner.
1739     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1740     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1741         if (_withUpdate) {
1742             massUpdatePools();
1743         }
1744         require(lpTokenPID[address(_lpToken)] == 0, "SakeMaster:duplicate add.");
1745         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1746         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1747         poolInfo.push(
1748             PoolInfo({
1749                 lpToken: _lpToken,
1750                 allocPoint: _allocPoint,
1751                 lastRewardBlock: lastRewardBlock,
1752                 accSakePerShare: 0
1753             })
1754         );
1755         lpTokenPID[address(_lpToken)] = poolInfo.length;
1756     }
1757 
1758     // Update the given pool's SAKE allocation point. Can only be called by the owner.
1759     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1760         if (_withUpdate) {
1761             massUpdatePools();
1762         }
1763         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1764         poolInfo[_pid].allocPoint = _allocPoint;
1765     }
1766 
1767     // Set the migrator contract. Can only be called by the owner.
1768     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1769         migrator = _migrator;
1770     }
1771 
1772     // Handover the saketoken mintage right.
1773     function handoverSakeMintage(address newOwner) public onlyOwner {
1774         sake.transferOwnership(newOwner);
1775     }
1776 
1777     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1778     function migrate(uint256 _pid) public {
1779         require(address(migrator) != address(0), "migrate: no migrator");
1780         PoolInfo storage pool = poolInfo[_pid];
1781         IERC20 lpToken = pool.lpToken;
1782         uint256 bal = lpToken.balanceOf(address(this));
1783         lpToken.safeApprove(address(migrator), bal);
1784         IERC20 newLpToken = migrator.migrate(lpToken);
1785         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1786         pool.lpToken = newLpToken;
1787     }
1788 
1789     // Return reward multiplier over the given _from to _to block.
1790     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1791         uint256 _toFinal = _to > mintEndBlock ? mintEndBlock : _to;
1792         if (_toFinal <= betaTestEndBlock) {
1793              return _toFinal.sub(_from);
1794         }else if (_from >= mintEndBlock) {
1795             return 0;
1796         } else if (_toFinal <= bonusEndBlock) {
1797             if (_from < betaTestEndBlock) {
1798                 return betaTestEndBlock.sub(_from).add(_toFinal.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER));
1799             } else {
1800                 return _toFinal.sub(_from).mul(BONUSONE_MULTIPLIER);
1801             }
1802         } else {
1803             if (_from < betaTestEndBlock) {
1804                 return betaTestEndBlock.sub(_from).add(bonusEndBlock.sub(betaTestEndBlock).mul(BONUSONE_MULTIPLIER)).add(
1805                     (_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER)));
1806             } else if (betaTestEndBlock <= _from && _from < bonusEndBlock) {
1807                 return bonusEndBlock.sub(_from).mul(BONUSONE_MULTIPLIER).add(_toFinal.sub(bonusEndBlock).mul(BONUSTWO_MULTIPLIER));
1808             } else {
1809                 return _toFinal.sub(_from).mul(BONUSTWO_MULTIPLIER);
1810             }
1811         } 
1812     }
1813 
1814     // View function to see pending SAKEs on frontend.
1815     function pendingSake(uint256 _pid, address _user) external view returns (uint256) {
1816         PoolInfo storage pool = poolInfo[_pid];
1817         UserInfo storage user = userInfo[_pid][_user];
1818         uint256 accSakePerShare = pool.accSakePerShare;
1819         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1820         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1821             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1822             uint256 sakeReward = multiplier.mul(sakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1823             accSakePerShare = accSakePerShare.add(sakeReward.mul(1e12).div(lpSupply));
1824         }
1825         return user.amount.mul(accSakePerShare).div(1e12).sub(user.rewardDebt);
1826     }
1827 
1828     // Update reward vairables for all pools. Be careful of gas spending!
1829     function massUpdatePools() public {
1830         uint256 length = poolInfo.length;
1831         for (uint256 pid = 0; pid < length; ++pid) {
1832             updatePool(pid);
1833         }
1834     }
1835 
1836     // Update reward variables of the given pool to be up-to-date.
1837     function updatePool(uint256 _pid) public {
1838         PoolInfo storage pool = poolInfo[_pid];
1839         if (block.number <= pool.lastRewardBlock) {
1840             return;
1841         }
1842         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1843         if (lpSupply == 0) {
1844             pool.lastRewardBlock = block.number;
1845             return;
1846         }
1847         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1848         if (multiplier == 0) {
1849             pool.lastRewardBlock = block.number;
1850             return;
1851         }
1852         uint256 sakeReward = multiplier.mul(sakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1853         sake.mint(devaddr, sakeReward.div(15));
1854         sake.mint(address(this), sakeReward);
1855         pool.accSakePerShare = pool.accSakePerShare.add(sakeReward.mul(1e12).div(lpSupply));
1856         pool.lastRewardBlock = block.number;
1857     }
1858 
1859     // Deposit LP tokens to SakeMaster for SAKE allocation.
1860     function deposit(uint256 _pid, uint256 _amount) public {
1861         PoolInfo storage pool = poolInfo[_pid];
1862         UserInfo storage user = userInfo[_pid][msg.sender];
1863         updatePool(_pid);
1864         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).sub(user.rewardDebt);
1865         user.amount = user.amount.add(_amount);
1866         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1867         if (pending > 0) safeSakeTransfer(msg.sender, pending);
1868         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1869         emit Deposit(msg.sender, _pid, _amount);
1870     }
1871 
1872     // Withdraw LP tokens from SakeMaster.
1873     function withdraw(uint256 _pid, uint256 _amount) public {
1874         PoolInfo storage pool = poolInfo[_pid];
1875         UserInfo storage user = userInfo[_pid][msg.sender];
1876         require(user.amount >= _amount, "withdraw: not good");
1877         updatePool(_pid);
1878         uint256 pending = user.amount.mul(pool.accSakePerShare).div(1e12).sub(user.rewardDebt);
1879         user.amount = user.amount.sub(_amount);
1880         user.rewardDebt = user.amount.mul(pool.accSakePerShare).div(1e12);
1881         safeSakeTransfer(msg.sender, pending);
1882         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1883         emit Withdraw(msg.sender, _pid, _amount);
1884     }
1885 
1886     // Withdraw without caring about rewards. EMERGENCY ONLY.
1887     function emergencyWithdraw(uint256 _pid) public {
1888         PoolInfo storage pool = poolInfo[_pid];
1889         UserInfo storage user = userInfo[_pid][msg.sender];
1890         require(user.amount > 0, "emergencyWithdraw: not good");
1891         uint256 _amount = user.amount;
1892         user.amount = 0;
1893         user.rewardDebt = 0;
1894         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1895         emit EmergencyWithdraw(msg.sender, _pid, _amount);
1896     }
1897 
1898     // Safe sake transfer function, just in case if rounding error causes pool to not have enough SAKEs.
1899     function safeSakeTransfer(address _to, uint256 _amount) internal {
1900         uint256 sakeBal = sake.balanceOf(address(this));
1901         if (_amount > sakeBal) {
1902             sake.transfer(_to, sakeBal);
1903         } else {
1904             sake.transfer(_to, _amount);
1905         }
1906     }
1907 
1908     // Update dev address by the previous dev.
1909     function dev(address _devaddr) public {
1910         require(msg.sender == devaddr, "dev: wut?");
1911         devaddr = _devaddr;
1912     }
1913 }
1914 
1915 // File: contracts/interfaces/IStakingRewards.sol
1916 
1917 pragma solidity 0.6.12;
1918 
1919 // Uniswap Liquidity Mining
1920 interface IStakingRewards {
1921     function earned(address account) external view returns (uint256);
1922 
1923     function stake(uint256 amount) external;
1924 
1925     function withdraw(uint256 amount) external;
1926 
1927     function getReward() external;
1928 
1929     function exit() external;
1930 
1931     function balanceOf(address account) external view returns (uint256);
1932 }
1933 
1934 // File: contracts/SakeUniV2.sol
1935 
1936 pragma solidity 0.6.12;
1937 
1938 
1939 
1940 
1941 
1942 
1943 
1944 contract SakeUniV2 is Ownable, ERC20("Wrapped UniSwap Liquidity Token", "WULP") {
1945     using SafeERC20 for IERC20;
1946     using SafeMath for uint256;
1947 
1948     // Info of each user.
1949     struct UserInfo {
1950         uint256 amount; // How many LP tokens the user has provided.
1951         uint256 sakeRewardDebt; // Sake reward debt. See explanation below.
1952         //
1953         // We do some fancy math here. Basically, any point in time, the amount of SAKEs
1954         // entitled to a user but is pending to be distributed is:
1955         //
1956         //   pending reward = (user.amount * pool.accSakePerShare) - user.rewardDebt
1957         //
1958         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
1959         //   1. The pool's `accSakePerShare` (and `lastRewardBlock`) gets updated.
1960         //   2. User receives the pending reward sent to his/her address.
1961         //   3. User's `amount` gets updated.
1962         //   4. User's `rewardDebt` gets updated.
1963         uint256 uniRewardDebt; // similar with sakeRewardDebt
1964         uint256 firstDepositTime;
1965     }
1966 
1967     // Info of each user that stakes LP tokens.
1968     mapping(address => UserInfo) public userInfo;
1969 
1970     IStakingRewards public uniStaking;
1971     uint256 public lastRewardBlock; // Last block number that SAKEs distribution occurs.
1972     uint256 public accSakePerShare; // Accumulated SAKEs per share, times 1e12. See below.
1973     uint256 public accUniPerShare; // Accumulated UNIs per share, times 1e12. See below.
1974 
1975     // The UNI Token.
1976     IERC20 public uniToken;
1977     // The SAKE TOKEN!
1978     SakeToken public sake;
1979     SakeMaster public sakeMaster;
1980     IERC20 public lpToken; // Address of LP token contract.
1981 
1982     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
1983     IMigratorChef public migrator;
1984     // The address to receive UNI token fee.
1985     address public uniTokenFeeReceiver;
1986     // The ratio of UNI token fee (10%).
1987     uint8 public uniFeeRatio = 10;
1988     uint8 public isMigrateComplete = 0;
1989 
1990     //Liquidity Event
1991     event EmergencyWithdraw(address indexed user, uint256 amount);
1992     event Deposit(address indexed user, uint256 amount);
1993     event Withdraw(address indexed user, uint256 amount);
1994 
1995     constructor(
1996         SakeMaster _sakeMaster,
1997         address _uniLpToken,
1998         address _uniStaking,
1999         address _uniToken,
2000         SakeToken _sake,
2001         address _uniTokenFeeReceiver
2002     ) public {
2003         sakeMaster = _sakeMaster;
2004         uniStaking = IStakingRewards(_uniStaking);
2005         uniToken = IERC20(_uniToken);
2006         sake = _sake;
2007         uniTokenFeeReceiver = _uniTokenFeeReceiver;
2008         lpToken = IERC20(_uniLpToken);
2009     }
2010 
2011     ////////////////////////////////////////////////////////////////////
2012     //Migrate liquidity to sakeswap
2013     ///////////////////////////////////////////////////////////////////
2014     function setMigrator(IMigratorChef _migrator) public onlyOwner {
2015         migrator = _migrator;
2016     }
2017 
2018     function migrate() public onlyOwner {
2019         require(address(migrator) != address(0), "migrate: no migrator");
2020         updatePool();
2021         //get all lp and uni reward from uniStaking
2022         uniStaking.withdraw(totalSupply());
2023         //get all wrapped lp and sake reward from sakeMaster
2024         uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2025         sakeMaster.withdraw(poolIdInSakeMaster, totalSupply());
2026         uint256 bal = lpToken.balanceOf(address(this));
2027         lpToken.safeApprove(address(migrator), bal);
2028         IERC20 newLpToken = migrator.migrate(lpToken);
2029         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
2030         lpToken = newLpToken;
2031         isMigrateComplete = 1;
2032     }
2033 
2034     // View function to see pending SAKEs and UNIs on frontend.
2035     function pending(address _user) external view returns (uint256 _sake, uint256 _uni) {
2036         UserInfo storage user = userInfo[_user];
2037         uint256 tempAccSakePerShare = accSakePerShare;
2038         uint256 tempAccUniPerShare = accUniPerShare;
2039     
2040         if (isMigrateComplete == 0 && block.number > lastRewardBlock && totalSupply() != 0) {
2041             uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2042             uint256 sakeReward = sakeMaster.pendingSake(poolIdInSakeMaster, address(this));
2043             tempAccSakePerShare = tempAccSakePerShare.add(sakeReward.mul(1e12).div(totalSupply()));
2044             uint256 uniReward = uniStaking.earned(address(this));
2045             tempAccUniPerShare = tempAccUniPerShare.add(uniReward.mul(1e12).div(totalSupply()));
2046         }
2047         _sake = user.amount.mul(tempAccSakePerShare).div(1e12).sub(user.sakeRewardDebt);
2048         _uni = user.amount.mul(tempAccUniPerShare).div(1e12).sub(user.uniRewardDebt);
2049     }
2050 
2051     // Update reward variables of the given pool to be up-to-date.
2052     function updatePool() public {
2053         if (block.number <= lastRewardBlock || isMigrateComplete == 1) {
2054             return;
2055         }
2056 
2057         if (totalSupply() == 0) {
2058             lastRewardBlock = block.number;
2059             return;
2060         }
2061         uint256 sakeBalance = sake.balanceOf(address(this));
2062         uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2063         // Get Sake Reward from SakeMaster
2064         sakeMaster.deposit(poolIdInSakeMaster, 0);
2065         uint256 sakeReward = sake.balanceOf(address(this)).sub(sakeBalance);
2066         accSakePerShare = accSakePerShare.add(sakeReward.mul(1e12).div((totalSupply())));
2067         uint256 uniReward = uniStaking.earned(address(this));
2068         uniStaking.getReward();
2069         accUniPerShare = accUniPerShare.add(uniReward.mul(1e12).div(totalSupply()));
2070         lastRewardBlock = block.number;
2071     }
2072 
2073     function _mintWulp(address _addr, uint256 _amount) internal {
2074         lpToken.safeTransferFrom(_addr, address(this), _amount);
2075         _mint(address(this), _amount);
2076     }
2077 
2078     function _burnWulp(address _to, uint256 _amount) internal {
2079         lpToken.safeTransfer(address(_to), _amount);
2080         _burn(address(this), _amount);
2081     }
2082 
2083     // Deposit LP tokens to SakeMaster for SAKE allocation.
2084     function deposit(uint256 _amount) public {
2085         require(isMigrateComplete == 0 || (isMigrateComplete == 1 && _amount == 0), "already migrate");
2086         UserInfo storage user = userInfo[msg.sender];
2087         updatePool();
2088         if (_amount > 0 && user.firstDepositTime == 0) user.firstDepositTime = block.number;
2089         uint256 pendingSake = user.amount.mul(accSakePerShare).div(1e12).sub(user.sakeRewardDebt);
2090         uint256 pendingUni = user.amount.mul(accUniPerShare).div(1e12).sub(user.uniRewardDebt);
2091         user.amount = user.amount.add(_amount);
2092         user.sakeRewardDebt = user.amount.mul(accSakePerShare).div(1e12);
2093         user.uniRewardDebt = user.amount.mul(accUniPerShare).div(1e12);
2094         if (pendingSake > 0) _safeSakeTransfer(msg.sender, pendingSake);
2095         if (pendingUni > 0) {
2096             uint256 uniFee = pendingUni.mul(uniFeeRatio).div(100);
2097             uint256 uniToUser = pendingUni.sub(uniFee);
2098             _safeUniTransfer(uniTokenFeeReceiver, uniFee);
2099             _safeUniTransfer(msg.sender, uniToUser);
2100         }
2101         if (_amount > 0) {
2102             //generate wrapped uniswap lp token
2103             _mintWulp(msg.sender, _amount);
2104 
2105             //approve and stake to uniswap
2106             lpToken.approve(address(uniStaking), _amount);
2107             uniStaking.stake(_amount);
2108 
2109             //approve and stake to sakemaster
2110             _approve(address(this), address(sakeMaster), _amount);
2111             uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2112             sakeMaster.deposit(poolIdInSakeMaster, _amount);
2113         }
2114 
2115         emit Deposit(msg.sender, _amount);
2116     }
2117 
2118     // Withdraw LP tokens from SakeUni.
2119     function withdraw(uint256 _amount) public {
2120         UserInfo storage user = userInfo[msg.sender];
2121         require(user.amount >= _amount, "withdraw: not good");
2122         updatePool();
2123         uint256 pendingSake = user.amount.mul(accSakePerShare).div(1e12).sub(user.sakeRewardDebt);
2124         uint256 pendingUni = user.amount.mul(accUniPerShare).div(1e12).sub(user.uniRewardDebt);
2125         user.amount = user.amount.sub(_amount);
2126         user.sakeRewardDebt = user.amount.mul(accSakePerShare).div(1e12);
2127         user.uniRewardDebt = user.amount.mul(accUniPerShare).div(1e12);
2128         if (pendingSake > 0) _safeSakeTransfer(msg.sender, pendingSake);
2129         if (pendingUni > 0) {
2130             uint256 uniFee = pendingUni.mul(uniFeeRatio).div(100);
2131             uint256 uniToUser = pendingUni.sub(uniFee);
2132             _safeUniTransfer(uniTokenFeeReceiver, uniFee);
2133             _safeUniTransfer(msg.sender, uniToUser);
2134         }
2135         if (_amount > 0) {
2136             if (isMigrateComplete == 0) {
2137                 uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2138                 //unstake wrapped lp token from sake master
2139                 sakeMaster.withdraw(poolIdInSakeMaster, _amount);
2140                 //unstake uniswap lp token from uniswap
2141                 uniStaking.withdraw(_amount);
2142             }
2143 
2144             _burnWulp(address(msg.sender), _amount);
2145         }
2146 
2147         emit Withdraw(msg.sender, _amount);
2148     }
2149 
2150     // Withdraw without caring about rewards. EMERGENCY ONLY.
2151     function emergencyWithdraw() public {
2152         UserInfo storage user = userInfo[msg.sender];
2153         require(user.amount > 0, "emergencyWithdraw: not good");
2154         uint256 _amount = user.amount;
2155         user.amount = 0;
2156         user.sakeRewardDebt = 0;
2157         user.uniRewardDebt = 0;
2158         {
2159             if (isMigrateComplete == 0) {
2160                 uint256 poolIdInSakeMaster = sakeMaster.lpTokenPID(address(this)).sub(1);
2161                 //unstake wrapped lp token from sake master
2162                 sakeMaster.withdraw(poolIdInSakeMaster, _amount);
2163                 //unstake lp token from uniswap
2164                 uniStaking.withdraw(_amount);
2165             }
2166 
2167             _burnWulp(address(msg.sender), _amount);
2168         }
2169         emit EmergencyWithdraw(msg.sender, _amount);
2170     }
2171 
2172     // Safe sake transfer function, just in case if rounding error causes pool to not have enough SAKEs.
2173     function _safeSakeTransfer(address _to, uint256 _amount) internal {
2174         uint256 sakeBal = sake.balanceOf(address(this));
2175         if (_amount > sakeBal) {
2176             sake.transfer(_to, sakeBal);
2177         } else {
2178             sake.transfer(_to, _amount);
2179         }
2180     }
2181 
2182     // Safe uni transfer function
2183     function _safeUniTransfer(address _to, uint256 _amount) internal {
2184         uint256 uniBal = uniToken.balanceOf(address(this));
2185         if (_amount > uniBal) {
2186             uniToken.transfer(_to, uniBal);
2187         } else {
2188             uniToken.transfer(_to, _amount);
2189         }
2190     }
2191 
2192     function setUniTokenFeeReceiver(address _uniTokenFeeReceiver) public onlyOwner {
2193         uniTokenFeeReceiver = _uniTokenFeeReceiver;
2194     }
2195 }