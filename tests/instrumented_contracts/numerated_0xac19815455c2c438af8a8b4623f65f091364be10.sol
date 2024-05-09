1 pragma solidity 0.5.12;
2 
3 /**
4  * @title Initializable
5  *
6  * @dev Helper contract to support initializer functions. To use it, replace
7  * the constructor with a function that has the `initializer` modifier.
8  * WARNING: Unlike constructors, initializer functions must be manually
9  * invoked. This applies both to deploying an Initializable contract, as well
10  * as extending an Initializable contract via inheritance.
11  * WARNING: When used with inheritance, manual care must be taken to not invoke
12  * a parent initializer twice, or ensure that all initializers are idempotent,
13  * because this is not dealt with automatically as with constructors.
14  */
15 contract Initializable {
16 
17   /**
18    * @dev Indicates that the contract has been initialized.
19    */
20   bool private initialized;
21 
22   /**
23    * @dev Indicates that the contract is in the process of being initialized.
24    */
25   bool private initializing;
26 
27   /**
28    * @dev Modifier to use in the initializer function of a contract.
29    */
30   modifier initializer() {
31     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
32 
33     bool isTopLevelCall = !initializing;
34     if (isTopLevelCall) {
35       initializing = true;
36       initialized = true;
37     }
38 
39     _;
40 
41     if (isTopLevelCall) {
42       initializing = false;
43     }
44   }
45 
46   /// @dev Returns true if and only if the function is running in the constructor
47   function isConstructor() private view returns (bool) {
48     // extcodesize checks the size of the code stored in an address, and
49     // address returns the current address. Since the code is still not
50     // deployed when running a constructor, any checks on its code size will
51     // yield zero, making it an effective way to detect if a contract is
52     // under construction or not.
53     address self = address(this);
54     uint256 cs;
55     assembly { cs := extcodesize(self) }
56     return cs == 0;
57   }
58 
59   // Reserved storage space to allow for layout changes in the future.
60   uint256[50] private ______gap;
61 }
62 
63 /*
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with GSN meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 contract Context is Initializable {
74     // Empty internal constructor, to prevent people from mistakenly deploying
75     // an instance of this contract, which should be used via inheritance.
76     constructor () internal { }
77     // solhint-disable-previous-line no-empty-blocks
78 
79     function _msgSender() internal view returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 /**
90  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
91  * the optional functions; to access them see {ERC20Detailed}.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 /**
165  * @dev Wrappers over Solidity's arithmetic operations with added overflow
166  * checks.
167  *
168  * Arithmetic operations in Solidity wrap on overflow. This can easily result
169  * in bugs, because programmers usually assume that an overflow raises an
170  * error, which is the standard behavior in high level programming languages.
171  * `SafeMath` restores this intuition by reverting the transaction when an
172  * operation overflows.
173  *
174  * Using this library instead of the unchecked operations eliminates an entire
175  * class of bugs, so it's recommended to use it always.
176  */
177 library SafeMath {
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
204         return sub(a, b, "SafeMath: subtraction overflow");
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      * - Subtraction cannot overflow.
215      *
216      * _Available since v2.4.0._
217      */
218     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b <= a, errorMessage);
220         uint256 c = a - b;
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      * - Multiplication cannot overflow.
233      */
234     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
235         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
236         // benefit is lost if 'b' is also tested.
237         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
238         if (a == 0) {
239             return 0;
240         }
241 
242         uint256 c = a * b;
243         require(c / a == b, "SafeMath: multiplication overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the integer division of two unsigned integers. Reverts on
250      * division by zero. The result is rounded towards zero.
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      * - The divisor cannot be zero.
258      */
259     function div(uint256 a, uint256 b) internal pure returns (uint256) {
260         return div(a, b, "SafeMath: division by zero");
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      * - The divisor cannot be zero.
273      *
274      * _Available since v2.4.0._
275      */
276     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         // Solidity only automatically asserts when dividing by 0
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
297         return mod(a, b, "SafeMath: modulo by zero");
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts with custom message when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      *
311      * _Available since v2.4.0._
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b != 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 /**
320  * @dev Implementation of the {IERC20} interface.
321  *
322  * This implementation is agnostic to the way tokens are created. This means
323  * that a supply mechanism has to be added in a derived contract using {_mint}.
324  * For a generic mechanism see {ERC20Mintable}.
325  *
326  * TIP: For a detailed writeup see our guide
327  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
328  * to implement supply mechanisms].
329  *
330  * We have followed general OpenZeppelin guidelines: functions revert instead
331  * of returning `false` on failure. This behavior is nonetheless conventional
332  * and does not conflict with the expectations of ERC20 applications.
333  *
334  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
335  * This allows applications to reconstruct the allowance for all accounts just
336  * by listening to said events. Other implementations of the EIP may not emit
337  * these events, as it isn't required by the specification.
338  *
339  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
340  * functions have been added to mitigate the well-known issues around setting
341  * allowances. See {IERC20-approve}.
342  */
343 contract ERC20 is Initializable, Context, IERC20 {
344     using SafeMath for uint256;
345 
346     mapping (address => uint256) private _balances;
347 
348     mapping (address => mapping (address => uint256)) private _allowances;
349 
350     uint256 private _totalSupply;
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account) public view returns (uint256) {
363         return _balances[account];
364     }
365 
366     /**
367      * @dev See {IERC20-transfer}.
368      *
369      * Requirements:
370      *
371      * - `recipient` cannot be the zero address.
372      * - the caller must have a balance of at least `amount`.
373      */
374     function transfer(address recipient, uint256 amount) public returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender) public view returns (uint256) {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function approve(address spender, uint256 amount) public returns (bool) {
394         _approve(_msgSender(), spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20};
403      *
404      * Requirements:
405      * - `sender` and `recipient` cannot be the zero address.
406      * - `sender` must have a balance of at least `amount`.
407      * - the caller must have allowance for `sender`'s tokens of at least
408      * `amount`.
409      */
410     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
411         _transfer(sender, recipient, amount);
412         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
413         return true;
414     }
415 
416     /**
417      * @dev Atomically increases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
429         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
430         return true;
431     }
432 
433     /**
434      * @dev Atomically decreases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      * - `spender` must have allowance for the caller of at least
445      * `subtractedValue`.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
448         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
449         return true;
450     }
451 
452     /**
453      * @dev Moves tokens `amount` from `sender` to `recipient`.
454      *
455      * This is internal function is equivalent to {transfer}, and can be used to
456      * e.g. implement automatic token fees, slashing mechanisms, etc.
457      *
458      * Emits a {Transfer} event.
459      *
460      * Requirements:
461      *
462      * - `sender` cannot be the zero address.
463      * - `recipient` cannot be the zero address.
464      * - `sender` must have a balance of at least `amount`.
465      */
466     function _transfer(address sender, address recipient, uint256 amount) internal {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
471         _balances[recipient] = _balances[recipient].add(amount);
472         emit Transfer(sender, recipient, amount);
473     }
474 
475     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
476      * the total supply.
477      *
478      * Emits a {Transfer} event with `from` set to the zero address.
479      *
480      * Requirements
481      *
482      * - `to` cannot be the zero address.
483      */
484     function _mint(address account, uint256 amount) internal {
485         require(account != address(0), "ERC20: mint to the zero address");
486 
487         _totalSupply = _totalSupply.add(amount);
488         _balances[account] = _balances[account].add(amount);
489         emit Transfer(address(0), account, amount);
490     }
491 
492     /**
493      * @dev Destroys `amount` tokens from `account`, reducing the
494      * total supply.
495      *
496      * Emits a {Transfer} event with `to` set to the zero address.
497      *
498      * Requirements
499      *
500      * - `account` cannot be the zero address.
501      * - `account` must have at least `amount` tokens.
502      */
503     function _burn(address account, uint256 amount) internal {
504         require(account != address(0), "ERC20: burn from the zero address");
505 
506         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
507         _totalSupply = _totalSupply.sub(amount);
508         emit Transfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
513      *
514      * This is internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(address owner, address spender, uint256 amount) internal {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
534      * from the caller's allowance.
535      *
536      * See {_burn} and {_approve}.
537      */
538     function _burnFrom(address account, uint256 amount) internal {
539         _burn(account, amount);
540         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
541     }
542 
543     uint256[50] private ______gap;
544 }
545 
546 /**
547  * @dev Collection of functions related to the address type
548  */
549 library Address {
550     /**
551      * @dev Returns true if `account` is a contract.
552      *
553      * [IMPORTANT]
554      * ====
555      * It is unsafe to assume that an address for which this function returns
556      * false is an externally-owned account (EOA) and not a contract.
557      *
558      * Among others, `isContract` will return false for the following 
559      * types of addresses:
560      *
561      *  - an externally-owned account
562      *  - a contract in construction
563      *  - an address where a contract will be created
564      *  - an address where a contract lived, but was destroyed
565      * ====
566      */
567     function isContract(address account) internal view returns (bool) {
568         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
569         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
570         // for accounts without code, i.e. `keccak256('')`
571         bytes32 codehash;
572         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
573         // solhint-disable-next-line no-inline-assembly
574         assembly { codehash := extcodehash(account) }
575         return (codehash != accountHash && codehash != 0x0);
576     }
577 
578     /**
579      * @dev Converts an `address` into `address payable`. Note that this is
580      * simply a type cast: the actual underlying value is not changed.
581      *
582      * _Available since v2.4.0._
583      */
584     function toPayable(address account) internal pure returns (address payable) {
585         return address(uint160(account));
586     }
587 
588     /**
589      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
590      * `recipient`, forwarding all available gas and reverting on errors.
591      *
592      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
593      * of certain opcodes, possibly making contracts go over the 2300 gas limit
594      * imposed by `transfer`, making them unable to receive funds via
595      * `transfer`. {sendValue} removes this limitation.
596      *
597      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
598      *
599      * IMPORTANT: because control is transferred to `recipient`, care must be
600      * taken to not create reentrancy vulnerabilities. Consider using
601      * {ReentrancyGuard} or the
602      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
603      *
604      * _Available since v2.4.0._
605      */
606     function sendValue(address payable recipient, uint256 amount) internal {
607         require(address(this).balance >= amount, "Address: insufficient balance");
608 
609         // solhint-disable-next-line avoid-call-value
610         (bool success, ) = recipient.call.value(amount)("");
611         require(success, "Address: unable to send value, recipient may have reverted");
612     }
613 }
614 
615 /**
616  * @title SafeERC20
617  * @dev Wrappers around ERC20 operations that throw on failure (when the token
618  * contract returns false). Tokens that return no value (and instead revert or
619  * throw on failure) are also supported, non-reverting calls are assumed to be
620  * successful.
621  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
622  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
623  */
624 library SafeERC20 {
625     using SafeMath for uint256;
626     using Address for address;
627 
628     function safeTransfer(IERC20 token, address to, uint256 value) internal {
629         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
630     }
631 
632     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
633         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
634     }
635 
636     function safeApprove(IERC20 token, address spender, uint256 value) internal {
637         // safeApprove should only be called when setting an initial allowance,
638         // or when resetting it to zero. To increase and decrease it, use
639         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
640         // solhint-disable-next-line max-line-length
641         require((value == 0) || (token.allowance(address(this), spender) == 0),
642             "SafeERC20: approve from non-zero to non-zero allowance"
643         );
644         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
645     }
646 
647     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
648         uint256 newAllowance = token.allowance(address(this), spender).add(value);
649         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
650     }
651 
652     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
653         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
654         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
655     }
656 
657     /**
658      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
659      * on the return value: the return value is optional (but if data is returned, it must not be false).
660      * @param token The token targeted by the call.
661      * @param data The call data (encoded using abi.encode or one of its variants).
662      */
663     function callOptionalReturn(IERC20 token, bytes memory data) private {
664         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
665         // we're implementing it ourselves.
666 
667         // A Solidity high level call has three parts:
668         //  1. The target address is checked to verify it contains contract code
669         //  2. The call itself is made, and success asserted
670         //  3. The return value is decoded, which in turn checks the size of the returned data.
671         // solhint-disable-next-line max-line-length
672         require(address(token).isContract(), "SafeERC20: call to non-contract");
673 
674         // solhint-disable-next-line avoid-low-level-calls
675         (bool success, bytes memory returndata) = address(token).call(data);
676         require(success, "SafeERC20: low-level call failed");
677 
678         if (returndata.length > 0) { // Return data is optional
679             // solhint-disable-next-line max-line-length
680             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
681         }
682     }
683 }
684 
685 /**
686  * @title Roles
687  * @dev Library for managing addresses assigned to a Role.
688  */
689 library Roles {
690     struct Role {
691         mapping (address => bool) bearer;
692     }
693 
694     /**
695      * @dev Give an account access to this role.
696      */
697     function add(Role storage role, address account) internal {
698         require(!has(role, account), "Roles: account already has role");
699         role.bearer[account] = true;
700     }
701 
702     /**
703      * @dev Remove an account's access to this role.
704      */
705     function remove(Role storage role, address account) internal {
706         require(has(role, account), "Roles: account does not have role");
707         role.bearer[account] = false;
708     }
709 
710     /**
711      * @dev Check if an account has this role.
712      * @return bool
713      */
714     function has(Role storage role, address account) internal view returns (bool) {
715         require(account != address(0), "Roles: account is the zero address");
716         return role.bearer[account];
717     }
718 }
719 
720 contract kRoles is Initializable {
721     using Roles for Roles.Role;
722 
723     event OperatorAdded(address indexed account);
724     event OperatorRemoved(address indexed account);
725 
726     Roles.Role private _operators;
727     address[] public operators;
728 
729     function initialize(address _operator) public initializer {
730         _addOperator(_operator);
731     }
732 
733     modifier onlyOperator() {
734         require(isOperator(msg.sender), "OperatorRole: caller does not have the Operator role");
735         _;
736     }
737 
738     function isOperator(address account) public view returns (bool) {
739         return _operators.has(account);
740     }
741 
742     function addOperator(address account) public onlyOperator {
743         _addOperator(account);
744     }
745 
746     function renounceOperator() public {
747         _removeOperator(msg.sender);
748     }
749 
750     function _addOperator(address account) internal {
751         _operators.add(account);
752         emit OperatorAdded(account);
753     }
754 
755     function _removeOperator(address account) internal {
756         _operators.remove(account);
757         emit OperatorRemoved(account);
758     }
759 }
760 
761 contract CanReclaimTokens is kRoles {
762     using SafeERC20 for ERC20;
763 
764     mapping(address => bool) private recoverableTokensBlacklist;
765 
766     function initialize(address _nextOwner) public initializer {
767         kRoles.initialize(_nextOwner);
768     }
769 
770     function blacklistRecoverableToken(address _token) public onlyOperator {
771         recoverableTokensBlacklist[_token] = true;
772     }
773 
774     /// @notice Allow the owner of the contract to recover funds accidentally
775     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
776     function recoverTokens(address _token) external onlyOperator {
777         require(
778             !recoverableTokensBlacklist[_token],
779             "CanReclaimTokens: token is not recoverable"
780         );
781 
782         if (_token == address(0x0)) {
783            (bool success,) = msg.sender.call.value(address(this).balance)("");
784             require(success, "Transfer Failed");
785         } else {
786             ERC20(_token).safeTransfer(
787                 msg.sender,
788                 ERC20(_token).balanceOf(address(this))
789             );
790         }
791     }
792 }
793 
794 /**
795  * @dev Extension of {ERC20} that allows token holders to destroy both their own
796  * tokens and those that they have an allowance for, in a way that can be
797  * recognized off-chain (via event analysis).
798  */
799 contract ERC20Burnable is Initializable, Context, ERC20 {
800     /**
801      * @dev Destroys `amount` tokens from the caller.
802      *
803      * See {ERC20-_burn}.
804      */
805     function burn(uint256 amount) public {
806         _burn(_msgSender(), amount);
807     }
808 
809     /**
810      * @dev See {ERC20-_burnFrom}.
811      */
812     function burnFrom(address account, uint256 amount) public {
813         _burnFrom(account, amount);
814     }
815 
816     uint256[50] private ______gap;
817 }
818 
819 contract PauserRole is Initializable, Context {
820     using Roles for Roles.Role;
821 
822     event PauserAdded(address indexed account);
823     event PauserRemoved(address indexed account);
824 
825     Roles.Role private _pausers;
826 
827     function initialize(address sender) public initializer {
828         if (!isPauser(sender)) {
829             _addPauser(sender);
830         }
831     }
832 
833     modifier onlyPauser() {
834         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
835         _;
836     }
837 
838     function isPauser(address account) public view returns (bool) {
839         return _pausers.has(account);
840     }
841 
842     function addPauser(address account) public onlyPauser {
843         _addPauser(account);
844     }
845 
846     function renouncePauser() public {
847         _removePauser(_msgSender());
848     }
849 
850     function _addPauser(address account) internal {
851         _pausers.add(account);
852         emit PauserAdded(account);
853     }
854 
855     function _removePauser(address account) internal {
856         _pausers.remove(account);
857         emit PauserRemoved(account);
858     }
859 
860     uint256[50] private ______gap;
861 }
862 
863 /**
864  * @dev Contract module which allows children to implement an emergency stop
865  * mechanism that can be triggered by an authorized account.
866  *
867  * This module is used through inheritance. It will make available the
868  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
869  * the functions of your contract. Note that they will not be pausable by
870  * simply including this module, only once the modifiers are put in place.
871  */
872 contract Pausable is Initializable, Context, PauserRole {
873     /**
874      * @dev Emitted when the pause is triggered by a pauser (`account`).
875      */
876     event Paused(address account);
877 
878     /**
879      * @dev Emitted when the pause is lifted by a pauser (`account`).
880      */
881     event Unpaused(address account);
882 
883     bool private _paused;
884 
885     /**
886      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
887      * to the deployer.
888      */
889     function initialize(address sender) public initializer {
890         PauserRole.initialize(sender);
891 
892         _paused = false;
893     }
894 
895     /**
896      * @dev Returns true if the contract is paused, and false otherwise.
897      */
898     function paused() public view returns (bool) {
899         return _paused;
900     }
901 
902     /**
903      * @dev Modifier to make a function callable only when the contract is not paused.
904      */
905     modifier whenNotPaused() {
906         require(!_paused, "Pausable: paused");
907         _;
908     }
909 
910     /**
911      * @dev Modifier to make a function callable only when the contract is paused.
912      */
913     modifier whenPaused() {
914         require(_paused, "Pausable: not paused");
915         _;
916     }
917 
918     /**
919      * @dev Called by a pauser to pause, triggers stopped state.
920      */
921     function pause() public onlyPauser whenNotPaused {
922         _paused = true;
923         emit Paused(_msgSender());
924     }
925 
926     /**
927      * @dev Called by a pauser to unpause, returns to normal state.
928      */
929     function unpause() public onlyPauser whenPaused {
930         _paused = false;
931         emit Unpaused(_msgSender());
932     }
933 
934     uint256[50] private ______gap;
935 }
936 
937 /**
938  * @title Pausable token
939  * @dev ERC20 with pausable transfers and allowances.
940  *
941  * Useful if you want to stop trades until the end of a crowdsale, or have
942  * an emergency switch for freezing all token transfers in the event of a large
943  * bug.
944  */
945 contract ERC20Pausable is Initializable, ERC20, Pausable {
946     function initialize(address sender) public initializer {
947         Pausable.initialize(sender);
948     }
949 
950     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
951         return super.transfer(to, value);
952     }
953 
954     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
955         return super.transferFrom(from, to, value);
956     }
957 
958     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
959         return super.approve(spender, value);
960     }
961 
962     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
963         return super.increaseAllowance(spender, addedValue);
964     }
965 
966     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
967         return super.decreaseAllowance(spender, subtractedValue);
968     }
969 
970     uint256[50] private ______gap;
971 }
972 
973 contract MinterRole is Initializable, Context {
974     using Roles for Roles.Role;
975 
976     event MinterAdded(address indexed account);
977     event MinterRemoved(address indexed account);
978 
979     Roles.Role private _minters;
980 
981     function initialize(address sender) public initializer {
982         if (!isMinter(sender)) {
983             _addMinter(sender);
984         }
985     }
986 
987     modifier onlyMinter() {
988         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
989         _;
990     }
991 
992     function isMinter(address account) public view returns (bool) {
993         return _minters.has(account);
994     }
995 
996     function addMinter(address account) public onlyMinter {
997         _addMinter(account);
998     }
999 
1000     function renounceMinter() public {
1001         _removeMinter(_msgSender());
1002     }
1003 
1004     function _addMinter(address account) internal {
1005         _minters.add(account);
1006         emit MinterAdded(account);
1007     }
1008 
1009     function _removeMinter(address account) internal {
1010         _minters.remove(account);
1011         emit MinterRemoved(account);
1012     }
1013 
1014     uint256[50] private ______gap;
1015 }
1016 
1017 /**
1018  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
1019  * which have permission to mint (create) new tokens as they see fit.
1020  *
1021  * At construction, the deployer of the contract is the only minter.
1022  */
1023 contract ERC20Mintable is Initializable, ERC20, MinterRole {
1024     function initialize(address sender) public initializer {
1025         MinterRole.initialize(sender);
1026     }
1027 
1028     /**
1029      * @dev See {ERC20-_mint}.
1030      *
1031      * Requirements:
1032      *
1033      * - the caller must have the {MinterRole}.
1034      */
1035     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
1036         _mint(account, amount);
1037         return true;
1038     }
1039 
1040     uint256[50] private ______gap;
1041 }
1042 
1043 interface ERC20Detailed {
1044     function name() external view returns (string memory);
1045     function symbol() external view returns (string memory);
1046     function decimals() external view returns (uint8);
1047 }
1048 
1049 contract StandardToken is ERC20Pausable, ERC20Mintable, ERC20Burnable, CanReclaimTokens {
1050     string private name_;
1051     string private symbol_;
1052     uint8 private decimals_;
1053 
1054     event LogRenamed(string _name, string _symbol);
1055 
1056     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
1057         // Initialize the minter and pauser roles
1058         ERC20Mintable.initialize(msg.sender);
1059         ERC20Pausable.initialize(msg.sender);
1060         CanReclaimTokens.initialize(msg.sender);
1061 
1062         name_ = name;
1063         symbol_ = symbol;
1064         decimals_ = decimals;
1065     }
1066 
1067     /// @return The name of the token.
1068     function name() public view returns (string memory) {
1069         return name_;
1070     }
1071 
1072     /// @return The symbol of the token.
1073     function symbol() public view returns (string memory) {
1074         return symbol_;
1075     }
1076 
1077     /// @return The number of decimals of the token.
1078     function decimals() public view returns (uint8) {
1079         return decimals_;
1080     }
1081 
1082     /// @param _name The new name of the token.
1083     /// @param _symbol Thew new symbol of the token.
1084     function rename(string calldata _name, string calldata _symbol) external onlyOperator {
1085         name_ = _name;
1086         symbol_ = _symbol;
1087         emit LogRenamed(_name, _symbol);
1088     }
1089 }
1090 
1091 contract KToken is StandardToken {
1092     address private underlying_;
1093 
1094     function initialize(string memory name, string memory symbol, uint8 decimals, address _underlying) public initializer {
1095         // Initialize the StandardToken
1096         StandardToken.initialize(name, symbol, decimals);
1097 
1098         underlying_ = _underlying;
1099     }
1100 
1101     /// @return The address of the underlying token.
1102     function underlying() public view returns (address) {
1103         return underlying_;
1104     }
1105 }
1106 
1107 contract kEther is KToken {
1108     function initialize(address _underlying) public initializer {
1109         KToken.initialize("kEther", "kETH", 18, _underlying);
1110     }
1111 }
1112 
1113 contract kWrappedEther is KToken {
1114     function initialize(address _underlying) public initializer {
1115         KToken.initialize("kWrappedEther", "kwETH", 18, _underlying);
1116     }
1117 }