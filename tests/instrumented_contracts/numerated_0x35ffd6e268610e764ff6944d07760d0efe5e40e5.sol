1 pragma solidity 0.5.12;
2 
3 interface IKToken {
4     function underlying() external view returns (address);
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function mint(address recipient, uint256 amount) external returns (bool);
12     function burnFrom(address sender, uint256 amount) external;
13     function addMinter(address sender) external;
14     function renounceMinter() external;
15 }
16 
17 interface ILiquidityPool {
18     function () external payable;
19     function kToken(address _token) external view returns (IKToken);
20     function register(IKToken _kToken) external;
21     function renounceOperator() external;
22     function deposit(address _token, uint256 _amount) external payable returns (uint256);
23     function withdraw(address payable _to, IKToken _kToken, uint256 _kTokenAmount) external;
24     function borrowableBalance(address _token) external view returns (uint256);
25     function underlyingBalance(address _token, address _owner) external view returns (uint256);
26 }
27 
28 interface ILender {
29     function () external payable;
30     function borrow(address _token, uint256 _amount, bytes calldata _data) external;
31 }
32 
33 interface IBorrowerProxy {
34     function initialize() external;
35     function lend(address _caller, bytes calldata _data) external payable;
36 }
37 
38 /**
39  * @title Initializable
40  *
41  * @dev Helper contract to support initializer functions. To use it, replace
42  * the constructor with a function that has the `initializer` modifier.
43  * WARNING: Unlike constructors, initializer functions must be manually
44  * invoked. This applies both to deploying an Initializable contract, as well
45  * as extending an Initializable contract via inheritance.
46  * WARNING: When used with inheritance, manual care must be taken to not invoke
47  * a parent initializer twice, or ensure that all initializers are idempotent,
48  * because this is not dealt with automatically as with constructors.
49  */
50 contract Initializable {
51 
52   /**
53    * @dev Indicates that the contract has been initialized.
54    */
55   bool private initialized;
56 
57   /**
58    * @dev Indicates that the contract is in the process of being initialized.
59    */
60   bool private initializing;
61 
62   /**
63    * @dev Modifier to use in the initializer function of a contract.
64    */
65   modifier initializer() {
66     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
67 
68     bool isTopLevelCall = !initializing;
69     if (isTopLevelCall) {
70       initializing = true;
71       initialized = true;
72     }
73 
74     _;
75 
76     if (isTopLevelCall) {
77       initializing = false;
78     }
79   }
80 
81   /// @dev Returns true if and only if the function is running in the constructor
82   function isConstructor() private view returns (bool) {
83     // extcodesize checks the size of the code stored in an address, and
84     // address returns the current address. Since the code is still not
85     // deployed when running a constructor, any checks on its code size will
86     // yield zero, making it an effective way to detect if a contract is
87     // under construction or not.
88     address self = address(this);
89     uint256 cs;
90     assembly { cs := extcodesize(self) }
91     return cs == 0;
92   }
93 
94   // Reserved storage space to allow for layout changes in the future.
95   uint256[50] private ______gap;
96 }
97 
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with GSN meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 contract Context is Initializable {
109     // Empty internal constructor, to prevent people from mistakenly deploying
110     // an instance of this contract, which should be used via inheritance.
111     constructor () internal { }
112     // solhint-disable-previous-line no-empty-blocks
113 
114     function _msgSender() internal view returns (address payable) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view returns (bytes memory) {
119         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
120         return msg.data;
121     }
122 }
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
126  * the optional functions; to access them see {ERC20Detailed}.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
186      * another (`to`).
187      *
188      * Note that `value` may be zero.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     /**
193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
194      * a call to {approve}. `value` is the new allowance.
195      */
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations with added overflow
201  * checks.
202  *
203  * Arithmetic operations in Solidity wrap on overflow. This can easily result
204  * in bugs, because programmers usually assume that an overflow raises an
205  * error, which is the standard behavior in high level programming languages.
206  * `SafeMath` restores this intuition by reverting the transaction when an
207  * operation overflows.
208  *
209  * Using this library instead of the unchecked operations eliminates an entire
210  * class of bugs, so it's recommended to use it always.
211  */
212 library SafeMath {
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         return sub(a, b, "SafeMath: subtraction overflow");
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      * - Subtraction cannot overflow.
250      *
251      * _Available since v2.4.0._
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      * - Multiplication cannot overflow.
268      */
269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
270         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
271         // benefit is lost if 'b' is also tested.
272         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
273         if (a == 0) {
274             return 0;
275         }
276 
277         uint256 c = a * b;
278         require(c / a == b, "SafeMath: multiplication overflow");
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the integer division of two unsigned integers. Reverts on
285      * division by zero. The result is rounded towards zero.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b) internal pure returns (uint256) {
295         return div(a, b, "SafeMath: division by zero");
296     }
297 
298     /**
299      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
300      * division by zero. The result is rounded towards zero.
301      *
302      * Counterpart to Solidity's `/` operator. Note: this function uses a
303      * `revert` opcode (which leaves remaining gas untouched) while Solidity
304      * uses an invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      * - The divisor cannot be zero.
308      *
309      * _Available since v2.4.0._
310      */
311     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
312         // Solidity only automatically asserts when dividing by 0
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      * - The divisor cannot be zero.
330      */
331     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
332         return mod(a, b, "SafeMath: modulo by zero");
333     }
334 
335     /**
336      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
337      * Reverts with custom message when dividing by zero.
338      *
339      * Counterpart to Solidity's `%` operator. This function uses a `revert`
340      * opcode (which leaves remaining gas untouched) while Solidity uses an
341      * invalid opcode to revert (consuming all remaining gas).
342      *
343      * Requirements:
344      * - The divisor cannot be zero.
345      *
346      * _Available since v2.4.0._
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 /**
355  * @dev Implementation of the {IERC20} interface.
356  *
357  * This implementation is agnostic to the way tokens are created. This means
358  * that a supply mechanism has to be added in a derived contract using {_mint}.
359  * For a generic mechanism see {ERC20Mintable}.
360  *
361  * TIP: For a detailed writeup see our guide
362  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
363  * to implement supply mechanisms].
364  *
365  * We have followed general OpenZeppelin guidelines: functions revert instead
366  * of returning `false` on failure. This behavior is nonetheless conventional
367  * and does not conflict with the expectations of ERC20 applications.
368  *
369  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
370  * This allows applications to reconstruct the allowance for all accounts just
371  * by listening to said events. Other implementations of the EIP may not emit
372  * these events, as it isn't required by the specification.
373  *
374  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
375  * functions have been added to mitigate the well-known issues around setting
376  * allowances. See {IERC20-approve}.
377  */
378 contract ERC20 is Initializable, Context, IERC20 {
379     using SafeMath for uint256;
380 
381     mapping (address => uint256) private _balances;
382 
383     mapping (address => mapping (address => uint256)) private _allowances;
384 
385     uint256 private _totalSupply;
386 
387     /**
388      * @dev See {IERC20-totalSupply}.
389      */
390     function totalSupply() public view returns (uint256) {
391         return _totalSupply;
392     }
393 
394     /**
395      * @dev See {IERC20-balanceOf}.
396      */
397     function balanceOf(address account) public view returns (uint256) {
398         return _balances[account];
399     }
400 
401     /**
402      * @dev See {IERC20-transfer}.
403      *
404      * Requirements:
405      *
406      * - `recipient` cannot be the zero address.
407      * - the caller must have a balance of at least `amount`.
408      */
409     function transfer(address recipient, uint256 amount) public returns (bool) {
410         _transfer(_msgSender(), recipient, amount);
411         return true;
412     }
413 
414     /**
415      * @dev See {IERC20-allowance}.
416      */
417     function allowance(address owner, address spender) public view returns (uint256) {
418         return _allowances[owner][spender];
419     }
420 
421     /**
422      * @dev See {IERC20-approve}.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      */
428     function approve(address spender, uint256 amount) public returns (bool) {
429         _approve(_msgSender(), spender, amount);
430         return true;
431     }
432 
433     /**
434      * @dev See {IERC20-transferFrom}.
435      *
436      * Emits an {Approval} event indicating the updated allowance. This is not
437      * required by the EIP. See the note at the beginning of {ERC20};
438      *
439      * Requirements:
440      * - `sender` and `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      * - the caller must have allowance for `sender`'s tokens of at least
443      * `amount`.
444      */
445     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
446         _transfer(sender, recipient, amount);
447         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
448         return true;
449     }
450 
451     /**
452      * @dev Atomically increases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
464         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically decreases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      * - `spender` must have allowance for the caller of at least
480      * `subtractedValue`.
481      */
482     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
484         return true;
485     }
486 
487     /**
488      * @dev Moves tokens `amount` from `sender` to `recipient`.
489      *
490      * This is internal function is equivalent to {transfer}, and can be used to
491      * e.g. implement automatic token fees, slashing mechanisms, etc.
492      *
493      * Emits a {Transfer} event.
494      *
495      * Requirements:
496      *
497      * - `sender` cannot be the zero address.
498      * - `recipient` cannot be the zero address.
499      * - `sender` must have a balance of at least `amount`.
500      */
501     function _transfer(address sender, address recipient, uint256 amount) internal {
502         require(sender != address(0), "ERC20: transfer from the zero address");
503         require(recipient != address(0), "ERC20: transfer to the zero address");
504 
505         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
506         _balances[recipient] = _balances[recipient].add(amount);
507         emit Transfer(sender, recipient, amount);
508     }
509 
510     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
511      * the total supply.
512      *
513      * Emits a {Transfer} event with `from` set to the zero address.
514      *
515      * Requirements
516      *
517      * - `to` cannot be the zero address.
518      */
519     function _mint(address account, uint256 amount) internal {
520         require(account != address(0), "ERC20: mint to the zero address");
521 
522         _totalSupply = _totalSupply.add(amount);
523         _balances[account] = _balances[account].add(amount);
524         emit Transfer(address(0), account, amount);
525     }
526 
527     /**
528      * @dev Destroys `amount` tokens from `account`, reducing the
529      * total supply.
530      *
531      * Emits a {Transfer} event with `to` set to the zero address.
532      *
533      * Requirements
534      *
535      * - `account` cannot be the zero address.
536      * - `account` must have at least `amount` tokens.
537      */
538     function _burn(address account, uint256 amount) internal {
539         require(account != address(0), "ERC20: burn from the zero address");
540 
541         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
542         _totalSupply = _totalSupply.sub(amount);
543         emit Transfer(account, address(0), amount);
544     }
545 
546     /**
547      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
548      *
549      * This is internal function is equivalent to `approve`, and can be used to
550      * e.g. set automatic allowances for certain subsystems, etc.
551      *
552      * Emits an {Approval} event.
553      *
554      * Requirements:
555      *
556      * - `owner` cannot be the zero address.
557      * - `spender` cannot be the zero address.
558      */
559     function _approve(address owner, address spender, uint256 amount) internal {
560         require(owner != address(0), "ERC20: approve from the zero address");
561         require(spender != address(0), "ERC20: approve to the zero address");
562 
563         _allowances[owner][spender] = amount;
564         emit Approval(owner, spender, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
569      * from the caller's allowance.
570      *
571      * See {_burn} and {_approve}.
572      */
573     function _burnFrom(address account, uint256 amount) internal {
574         _burn(account, amount);
575         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
576     }
577 
578     uint256[50] private ______gap;
579 }
580 
581 /**
582  * @dev Collection of functions related to the address type
583  */
584 library Address {
585     /**
586      * @dev Returns true if `account` is a contract.
587      *
588      * [IMPORTANT]
589      * ====
590      * It is unsafe to assume that an address for which this function returns
591      * false is an externally-owned account (EOA) and not a contract.
592      *
593      * Among others, `isContract` will return false for the following 
594      * types of addresses:
595      *
596      *  - an externally-owned account
597      *  - a contract in construction
598      *  - an address where a contract will be created
599      *  - an address where a contract lived, but was destroyed
600      * ====
601      */
602     function isContract(address account) internal view returns (bool) {
603         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
604         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
605         // for accounts without code, i.e. `keccak256('')`
606         bytes32 codehash;
607         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
608         // solhint-disable-next-line no-inline-assembly
609         assembly { codehash := extcodehash(account) }
610         return (codehash != accountHash && codehash != 0x0);
611     }
612 
613     /**
614      * @dev Converts an `address` into `address payable`. Note that this is
615      * simply a type cast: the actual underlying value is not changed.
616      *
617      * _Available since v2.4.0._
618      */
619     function toPayable(address account) internal pure returns (address payable) {
620         return address(uint160(account));
621     }
622 
623     /**
624      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
625      * `recipient`, forwarding all available gas and reverting on errors.
626      *
627      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
628      * of certain opcodes, possibly making contracts go over the 2300 gas limit
629      * imposed by `transfer`, making them unable to receive funds via
630      * `transfer`. {sendValue} removes this limitation.
631      *
632      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
633      *
634      * IMPORTANT: because control is transferred to `recipient`, care must be
635      * taken to not create reentrancy vulnerabilities. Consider using
636      * {ReentrancyGuard} or the
637      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
638      *
639      * _Available since v2.4.0._
640      */
641     function sendValue(address payable recipient, uint256 amount) internal {
642         require(address(this).balance >= amount, "Address: insufficient balance");
643 
644         // solhint-disable-next-line avoid-call-value
645         (bool success, ) = recipient.call.value(amount)("");
646         require(success, "Address: unable to send value, recipient may have reverted");
647     }
648 }
649 
650 /**
651  * @title SafeERC20
652  * @dev Wrappers around ERC20 operations that throw on failure (when the token
653  * contract returns false). Tokens that return no value (and instead revert or
654  * throw on failure) are also supported, non-reverting calls are assumed to be
655  * successful.
656  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
657  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
658  */
659 library SafeERC20 {
660     using SafeMath for uint256;
661     using Address for address;
662 
663     function safeTransfer(IERC20 token, address to, uint256 value) internal {
664         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
665     }
666 
667     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
668         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
669     }
670 
671     function safeApprove(IERC20 token, address spender, uint256 value) internal {
672         // safeApprove should only be called when setting an initial allowance,
673         // or when resetting it to zero. To increase and decrease it, use
674         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
675         // solhint-disable-next-line max-line-length
676         require((value == 0) || (token.allowance(address(this), spender) == 0),
677             "SafeERC20: approve from non-zero to non-zero allowance"
678         );
679         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
680     }
681 
682     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
683         uint256 newAllowance = token.allowance(address(this), spender).add(value);
684         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
685     }
686 
687     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
688         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
689         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
690     }
691 
692     /**
693      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
694      * on the return value: the return value is optional (but if data is returned, it must not be false).
695      * @param token The token targeted by the call.
696      * @param data The call data (encoded using abi.encode or one of its variants).
697      */
698     function callOptionalReturn(IERC20 token, bytes memory data) private {
699         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
700         // we're implementing it ourselves.
701 
702         // A Solidity high level call has three parts:
703         //  1. The target address is checked to verify it contains contract code
704         //  2. The call itself is made, and success asserted
705         //  3. The return value is decoded, which in turn checks the size of the returned data.
706         // solhint-disable-next-line max-line-length
707         require(address(token).isContract(), "SafeERC20: call to non-contract");
708 
709         // solhint-disable-next-line avoid-low-level-calls
710         (bool success, bytes memory returndata) = address(token).call(data);
711         require(success, "SafeERC20: low-level call failed");
712 
713         if (returndata.length > 0) { // Return data is optional
714             // solhint-disable-next-line max-line-length
715             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
716         }
717     }
718 }
719 
720 /**
721  * @title Roles
722  * @dev Library for managing addresses assigned to a Role.
723  */
724 library Roles {
725     struct Role {
726         mapping (address => bool) bearer;
727     }
728 
729     /**
730      * @dev Give an account access to this role.
731      */
732     function add(Role storage role, address account) internal {
733         require(!has(role, account), "Roles: account already has role");
734         role.bearer[account] = true;
735     }
736 
737     /**
738      * @dev Remove an account's access to this role.
739      */
740     function remove(Role storage role, address account) internal {
741         require(has(role, account), "Roles: account does not have role");
742         role.bearer[account] = false;
743     }
744 
745     /**
746      * @dev Check if an account has this role.
747      * @return bool
748      */
749     function has(Role storage role, address account) internal view returns (bool) {
750         require(account != address(0), "Roles: account is the zero address");
751         return role.bearer[account];
752     }
753 }
754 
755 contract KRoles is Initializable {
756     using Roles for Roles.Role;
757 
758     event OperatorAdded(address indexed account);
759     event OperatorRemoved(address indexed account);
760 
761     Roles.Role private _operators;
762     address[] public operators;
763 
764     function initialize(address _operator) public initializer {
765         _addOperator(_operator);
766     }
767 
768     modifier onlyOperator() {
769         require(isOperator(msg.sender), "OperatorRole: caller does not have the Operator role");
770         _;
771     }
772 
773     function isOperator(address account) public view returns (bool) {
774         return _operators.has(account);
775     }
776 
777     function addOperator(address account) public onlyOperator {
778         _addOperator(account);
779     }
780 
781     function renounceOperator() public {
782         _removeOperator(msg.sender);
783     }
784 
785     function _addOperator(address account) internal {
786         _operators.add(account);
787         emit OperatorAdded(account);
788     }
789 
790     function _removeOperator(address account) internal {
791         _operators.remove(account);
792         emit OperatorRemoved(account);
793     }
794 }
795 
796 contract CanReclaimTokens is KRoles {
797     using SafeERC20 for ERC20;
798 
799     mapping(address => bool) private recoverableTokensBlacklist;
800 
801     function initialize(address _nextOwner) public initializer {
802         KRoles.initialize(_nextOwner);
803     }
804 
805     function blacklistRecoverableToken(address _token) public onlyOperator {
806         recoverableTokensBlacklist[_token] = true;
807     }
808 
809     /// @notice Allow the owner of the contract to recover funds accidentally
810     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
811     function recoverTokens(address _token) external onlyOperator {
812         require(
813             !recoverableTokensBlacklist[_token],
814             "CanReclaimTokens: token is not recoverable"
815         );
816 
817         if (_token == address(0x0)) {
818            (bool success,) = msg.sender.call.value(address(this).balance)("");
819             require(success, "Transfer Failed");
820         } else {
821             ERC20(_token).safeTransfer(
822                 msg.sender,
823                 ERC20(_token).balanceOf(address(this))
824             );
825         }
826     }
827 }
828 
829 /**
830  * @dev Contract module that helps prevent reentrant calls to a function.
831  *
832  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
833  * available, which can be applied to functions to make sure there are no nested
834  * (reentrant) calls to them.
835  *
836  * Note that because there is a single `nonReentrant` guard, functions marked as
837  * `nonReentrant` may not call one another. This can be worked around by making
838  * those functions `private`, and then adding `external` `nonReentrant` entry
839  * points to them.
840  */
841 contract ReentrancyGuard is Initializable {
842     // counter to allow mutex lock with only one SSTORE operation
843     uint256 private _guardCounter;
844 
845     function initialize() public initializer {
846         // The counter starts at one to prevent changing it from zero to a non-zero
847         // value, which is a more expensive operation.
848         _guardCounter = 1;
849     }
850 
851     /**
852      * @dev Prevents a contract from calling itself, directly or indirectly.
853      * Calling a `nonReentrant` function from another `nonReentrant`
854      * function is not supported. It is possible to prevent this from happening
855      * by making the `nonReentrant` function external, and make it call a
856      * `private` function that does the actual work.
857      */
858     modifier nonReentrant() {
859         _guardCounter += 1;
860         uint256 localCounter = _guardCounter;
861         _;
862         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
863     }
864 
865     uint256[50] private ______gap;
866 }
867 
868 contract PauserRole is Initializable, Context {
869     using Roles for Roles.Role;
870 
871     event PauserAdded(address indexed account);
872     event PauserRemoved(address indexed account);
873 
874     Roles.Role private _pausers;
875 
876     function initialize(address sender) public initializer {
877         if (!isPauser(sender)) {
878             _addPauser(sender);
879         }
880     }
881 
882     modifier onlyPauser() {
883         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
884         _;
885     }
886 
887     function isPauser(address account) public view returns (bool) {
888         return _pausers.has(account);
889     }
890 
891     function addPauser(address account) public onlyPauser {
892         _addPauser(account);
893     }
894 
895     function renouncePauser() public {
896         _removePauser(_msgSender());
897     }
898 
899     function _addPauser(address account) internal {
900         _pausers.add(account);
901         emit PauserAdded(account);
902     }
903 
904     function _removePauser(address account) internal {
905         _pausers.remove(account);
906         emit PauserRemoved(account);
907     }
908 
909     uint256[50] private ______gap;
910 }
911 
912 /**
913  * @dev Contract module which allows children to implement an emergency stop
914  * mechanism that can be triggered by an authorized account.
915  *
916  * This module is used through inheritance. It will make available the
917  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
918  * the functions of your contract. Note that they will not be pausable by
919  * simply including this module, only once the modifiers are put in place.
920  */
921 contract Pausable is Initializable, Context, PauserRole {
922     /**
923      * @dev Emitted when the pause is triggered by a pauser (`account`).
924      */
925     event Paused(address account);
926 
927     /**
928      * @dev Emitted when the pause is lifted by a pauser (`account`).
929      */
930     event Unpaused(address account);
931 
932     bool private _paused;
933 
934     /**
935      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
936      * to the deployer.
937      */
938     function initialize(address sender) public initializer {
939         PauserRole.initialize(sender);
940 
941         _paused = false;
942     }
943 
944     /**
945      * @dev Returns true if the contract is paused, and false otherwise.
946      */
947     function paused() public view returns (bool) {
948         return _paused;
949     }
950 
951     /**
952      * @dev Modifier to make a function callable only when the contract is not paused.
953      */
954     modifier whenNotPaused() {
955         require(!_paused, "Pausable: paused");
956         _;
957     }
958 
959     /**
960      * @dev Modifier to make a function callable only when the contract is paused.
961      */
962     modifier whenPaused() {
963         require(_paused, "Pausable: not paused");
964         _;
965     }
966 
967     /**
968      * @dev Called by a pauser to pause, triggers stopped state.
969      */
970     function pause() public onlyPauser whenNotPaused {
971         _paused = true;
972         emit Paused(_msgSender());
973     }
974 
975     /**
976      * @dev Called by a pauser to unpause, returns to normal state.
977      */
978     function unpause() public onlyPauser whenPaused {
979         _paused = false;
980         emit Unpaused(_msgSender());
981     }
982 
983     uint256[50] private ______gap;
984 }
985 
986 /**
987  * @title Proxy
988  * @dev Implements delegation of calls to other contracts, with proper
989  * forwarding of return values and bubbling of failures.
990  * It defines a fallback function that delegates all calls to the address
991  * returned by the abstract _implementation() internal function.
992  */
993 contract Proxy {
994   /**
995    * @dev Fallback function.
996    * Implemented entirely in `_fallback`.
997    */
998   function () payable external {
999     _fallback();
1000   }
1001 
1002   /**
1003    * @return The Address of the implementation.
1004    */
1005   function _implementation() internal view returns (address);
1006 
1007   /**
1008    * @dev Delegates execution to an implementation contract.
1009    * This is a low level function that doesn't return to its internal call site.
1010    * It will return to the external caller whatever the implementation returns.
1011    * @param implementation Address to delegate.
1012    */
1013   function _delegate(address implementation) internal {
1014     assembly {
1015       // Copy msg.data. We take full control of memory in this inline assembly
1016       // block because it will not return to Solidity code. We overwrite the
1017       // Solidity scratch pad at memory position 0.
1018       calldatacopy(0, 0, calldatasize)
1019 
1020       // Call the implementation.
1021       // out and outsize are 0 because we don't know the size yet.
1022       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
1023 
1024       // Copy the returned data.
1025       returndatacopy(0, 0, returndatasize)
1026 
1027       switch result
1028       // delegatecall returns 0 on error.
1029       case 0 { revert(0, returndatasize) }
1030       default { return(0, returndatasize) }
1031     }
1032   }
1033 
1034   /**
1035    * @dev Function that is run as the first thing in the fallback function.
1036    * Can be redefined in derived contracts to add functionality.
1037    * Redefinitions must call super._willFallback().
1038    */
1039   function _willFallback() internal {
1040   }
1041 
1042   /**
1043    * @dev fallback implementation.
1044    * Extracted to enable manual triggering.
1045    */
1046   function _fallback() internal {
1047     _willFallback();
1048     _delegate(_implementation());
1049   }
1050 }
1051 
1052 /**
1053  * Utility library of inline functions on addresses
1054  *
1055  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
1056  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
1057  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
1058  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
1059  */
1060 library OpenZeppelinUpgradesAddress {
1061     /**
1062      * Returns whether the target address is a contract
1063      * @dev This function will return false if invoked during the constructor of a contract,
1064      * as the code is not actually created until after the constructor finishes.
1065      * @param account address of the account to check
1066      * @return whether the target address is a contract
1067      */
1068     function isContract(address account) internal view returns (bool) {
1069         uint256 size;
1070         // XXX Currently there is no better way to check if there is a contract in an address
1071         // than to check the size of the code at that address.
1072         // See https://ethereum.stackexchange.com/a/14016/36603
1073         // for more details about how this works.
1074         // TODO Check this again before the Serenity release, because all addresses will be
1075         // contracts then.
1076         // solhint-disable-next-line no-inline-assembly
1077         assembly { size := extcodesize(account) }
1078         return size > 0;
1079     }
1080 }
1081 
1082 /**
1083  * @title BaseUpgradeabilityProxy
1084  * @dev This contract implements a proxy that allows to change the
1085  * implementation address to which it will delegate.
1086  * Such a change is called an implementation upgrade.
1087  */
1088 contract BaseUpgradeabilityProxy is Proxy {
1089   /**
1090    * @dev Emitted when the implementation is upgraded.
1091    * @param implementation Address of the new implementation.
1092    */
1093   event Upgraded(address indexed implementation);
1094 
1095   /**
1096    * @dev Storage slot with the address of the current implementation.
1097    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
1098    * validated in the constructor.
1099    */
1100   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1101 
1102   /**
1103    * @dev Returns the current implementation.
1104    * @return Address of the current implementation
1105    */
1106   function _implementation() internal view returns (address impl) {
1107     bytes32 slot = IMPLEMENTATION_SLOT;
1108     assembly {
1109       impl := sload(slot)
1110     }
1111   }
1112 
1113   /**
1114    * @dev Upgrades the proxy to a new implementation.
1115    * @param newImplementation Address of the new implementation.
1116    */
1117   function _upgradeTo(address newImplementation) internal {
1118     _setImplementation(newImplementation);
1119     emit Upgraded(newImplementation);
1120   }
1121 
1122   /**
1123    * @dev Sets the implementation address of the proxy.
1124    * @param newImplementation Address of the new implementation.
1125    */
1126   function _setImplementation(address newImplementation) internal {
1127     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
1128 
1129     bytes32 slot = IMPLEMENTATION_SLOT;
1130 
1131     assembly {
1132       sstore(slot, newImplementation)
1133     }
1134   }
1135 }
1136 
1137 /**
1138  * @title UpgradeabilityProxy
1139  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
1140  * implementation and init data.
1141  */
1142 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
1143   /**
1144    * @dev Contract constructor.
1145    * @param _logic Address of the initial implementation.
1146    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1147    * It should include the signature and the parameters of the function to be called, as described in
1148    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1149    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1150    */
1151   constructor(address _logic, bytes memory _data) public payable {
1152     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
1153     _setImplementation(_logic);
1154     if(_data.length > 0) {
1155       (bool success,) = _logic.delegatecall(_data);
1156       require(success);
1157     }
1158   }  
1159 }
1160 
1161 /**
1162  * @title BaseAdminUpgradeabilityProxy
1163  * @dev This contract combines an upgradeability proxy with an authorization
1164  * mechanism for administrative tasks.
1165  * All external functions in this contract must be guarded by the
1166  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
1167  * feature proposal that would enable this to be done automatically.
1168  */
1169 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
1170   /**
1171    * @dev Emitted when the administration has been transferred.
1172    * @param previousAdmin Address of the previous admin.
1173    * @param newAdmin Address of the new admin.
1174    */
1175   event AdminChanged(address previousAdmin, address newAdmin);
1176 
1177   /**
1178    * @dev Storage slot with the admin of the contract.
1179    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
1180    * validated in the constructor.
1181    */
1182 
1183   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1184 
1185   /**
1186    * @dev Modifier to check whether the `msg.sender` is the admin.
1187    * If it is, it will run the function. Otherwise, it will delegate the call
1188    * to the implementation.
1189    */
1190   modifier ifAdmin() {
1191     if (msg.sender == _admin()) {
1192       _;
1193     } else {
1194       _fallback();
1195     }
1196   }
1197 
1198   /**
1199    * @return The address of the proxy admin.
1200    */
1201   function admin() external ifAdmin returns (address) {
1202     return _admin();
1203   }
1204 
1205   /**
1206    * @return The address of the implementation.
1207    */
1208   function implementation() external ifAdmin returns (address) {
1209     return _implementation();
1210   }
1211 
1212   /**
1213    * @dev Changes the admin of the proxy.
1214    * Only the current admin can call this function.
1215    * @param newAdmin Address to transfer proxy administration to.
1216    */
1217   function changeAdmin(address newAdmin) external ifAdmin {
1218     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
1219     emit AdminChanged(_admin(), newAdmin);
1220     _setAdmin(newAdmin);
1221   }
1222 
1223   /**
1224    * @dev Upgrade the backing implementation of the proxy.
1225    * Only the admin can call this function.
1226    * @param newImplementation Address of the new implementation.
1227    */
1228   function upgradeTo(address newImplementation) external ifAdmin {
1229     _upgradeTo(newImplementation);
1230   }
1231 
1232   /**
1233    * @dev Upgrade the backing implementation of the proxy and call a function
1234    * on the new implementation.
1235    * This is useful to initialize the proxied contract.
1236    * @param newImplementation Address of the new implementation.
1237    * @param data Data to send as msg.data in the low level call.
1238    * It should include the signature and the parameters of the function to be called, as described in
1239    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1240    */
1241   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
1242     _upgradeTo(newImplementation);
1243     (bool success,) = newImplementation.delegatecall(data);
1244     require(success);
1245   }
1246 
1247   /**
1248    * @return The admin slot.
1249    */
1250   function _admin() internal view returns (address adm) {
1251     bytes32 slot = ADMIN_SLOT;
1252     assembly {
1253       adm := sload(slot)
1254     }
1255   }
1256 
1257   /**
1258    * @dev Sets the address of the proxy admin.
1259    * @param newAdmin Address of the new proxy admin.
1260    */
1261   function _setAdmin(address newAdmin) internal {
1262     bytes32 slot = ADMIN_SLOT;
1263 
1264     assembly {
1265       sstore(slot, newAdmin)
1266     }
1267   }
1268 
1269   /**
1270    * @dev Only fall back when the sender is not the admin.
1271    */
1272   function _willFallback() internal {
1273     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
1274     super._willFallback();
1275   }
1276 }
1277 
1278 /**
1279  * @title InitializableUpgradeabilityProxy
1280  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
1281  * implementation and init data.
1282  */
1283 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
1284   /**
1285    * @dev Contract initializer.
1286    * @param _logic Address of the initial implementation.
1287    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1288    * It should include the signature and the parameters of the function to be called, as described in
1289    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1290    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1291    */
1292   function initialize(address _logic, bytes memory _data) public payable {
1293     require(_implementation() == address(0));
1294     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
1295     _setImplementation(_logic);
1296     if(_data.length > 0) {
1297       (bool success,) = _logic.delegatecall(_data);
1298       require(success);
1299     }
1300   }  
1301 }
1302 
1303 /**
1304  * @title InitializableAdminUpgradeabilityProxy
1305  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
1306  * initializing the implementation, admin, and init data.
1307  */
1308 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
1309   /**
1310    * Contract initializer.
1311    * @param _logic address of the initial implementation.
1312    * @param _admin Address of the proxy administrator.
1313    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1314    * It should include the signature and the parameters of the function to be called, as described in
1315    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1316    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1317    */
1318   function initialize(address _logic, address _admin, bytes memory _data) public payable {
1319     require(_implementation() == address(0));
1320     InitializableUpgradeabilityProxy.initialize(_logic, _data);
1321     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
1322     _setAdmin(_admin);
1323   }
1324 }
1325 
1326 contract LiquidityPoolV2 is ILiquidityPool, CanReclaimTokens, ReentrancyGuard, Pausable {
1327     using SafeMath for uint256;
1328     using SafeERC20 for ERC20;
1329 
1330     mapping (address=>IKToken) public kTokens;
1331     address[] public registeredTokens;
1332     mapping (address=>bool) public registeredKTokens;
1333     string public VERSION;
1334     IBorrowerProxy borrower;
1335 
1336     uint256 public depositFeeInBips;
1337     uint256 public poolFeeInBips;
1338     uint256 public FEE_BASE = 10000;
1339 
1340     address public ETHEREUM = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1341     address payable feePool;
1342 
1343     event Deposited(address indexed _depositor, address indexed _token, uint256 _amount, uint256 _mintAmount);
1344     event Withdrew(address indexed _reciever, address indexed _withdrawer, address indexed _token, uint256 _amount, uint256 _burnAmount);
1345     event Borrowed(address indexed _borrower, address indexed _token, uint256 _amount, uint256 _fee);
1346     event EtherReceived(address indexed _from, uint256 _amount);
1347 
1348     function () external payable {
1349         emit EtherReceived(_msgSender(), msg.value);
1350     }
1351 
1352     function initialize(string memory _VERSION, address _borrower) public initializer {
1353         require(_borrower != address(0), "LiquidityPoolV2: borrower proxy cannot be 0x0");
1354         CanReclaimTokens.initialize(msg.sender);
1355         Pausable.initialize(msg.sender);
1356         ReentrancyGuard.initialize();
1357         Pausable.initialize(msg.sender);
1358 
1359         VERSION = _VERSION;
1360         borrower = IBorrowerProxy(_borrower);
1361         borrower.initialize();
1362     }
1363 
1364     /// @notice updates the deposit fee.
1365     ///
1366     /// @dev fee is in bips so it should 
1367     ///     satisfy [0 <= fee <= FEE_BASE]
1368     /// @param _depositFeeInBips The new deposit fee.
1369     ///
1370     /// @return Nothing.
1371     function updateDepositFee(uint256 _depositFeeInBips) external onlyOperator {
1372         require(_depositFeeInBips >= 0 && _depositFeeInBips <= FEE_BASE, "LiquidityPoolV1: fee should be between 0 and FEE_BASE");
1373         depositFeeInBips = _depositFeeInBips;
1374     }
1375 
1376     /// @notice updates the pool fee.
1377     ///
1378     /// @dev fee is in bips so it should 
1379     ///     satisfy [0 <= fee <= FEE_BASE]
1380     /// @param _poolFeeInBips The new pool fee.
1381     ///
1382     /// @return Nothing.
1383     function updatePoolFee(uint256 _poolFeeInBips) external onlyOperator {
1384         require(_poolFeeInBips >= 0 && _poolFeeInBips <= FEE_BASE, "LiquidityPoolV1: fee should be between 0 and FEE_BASE");
1385         poolFeeInBips = _poolFeeInBips;
1386     }
1387 
1388     /// @notice updates the fee pool.
1389     ///
1390     /// @param _newFeePool The new fee pool.
1391     ///
1392     /// @return Nothing.
1393     function updateFeePool(address payable _newFeePool) external onlyOperator {
1394         require(_newFeePool != address(0), "LiquidityPoolV2: feepool cannot be 0x0");
1395         feePool = _newFeePool;        
1396     }
1397 
1398     /// @notice register a token on this Keeper.
1399     ///
1400     /// @param _kToken The keeper ERC20 token.
1401     ///
1402     /// @return Nothing.
1403     function register(IKToken _kToken) external onlyOperator {
1404         require(address(kTokens[_kToken.underlying()]) == address(0x0), "Underlying asset should not have been registered");
1405         require(!registeredKTokens[address(_kToken)], "kToken should not have been registered");
1406 
1407         kTokens[_kToken.underlying()] = _kToken;
1408         registeredKTokens[address(_kToken)] = true;
1409         registeredTokens.push(address(_kToken.underlying()));
1410         blacklistRecoverableToken(_kToken.underlying());
1411     }
1412 
1413     /// @notice Deposit funds to the Keeper Protocol.
1414     ///
1415     /// @param _token The address of the token contract.
1416     /// @param _amount The value of deposit.
1417     ///
1418     /// @return Nothing.
1419     function deposit(address _token, uint256 _amount) external payable nonReentrant whenNotPaused returns (uint256) {
1420         IKToken kToken = kTokens[_token];
1421         require(address(kToken) != address(0x0), "Token is not registered");
1422         require(_amount > 0, "Deposit amount should be greater than 0");
1423         if (_token != ETHEREUM) {
1424             require(msg.value == 0, "LiquidityPoolV2: Should not allow ETH deposits during ERC20 token deposits");
1425             ERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
1426         } else {
1427             require(_amount == msg.value, "Incorrect eth amount");
1428         }
1429 
1430         uint256 mintAmount = calculateMintAmount(kToken, _token, _amount);
1431         kToken.mint(msg.sender, mintAmount);
1432         emit Deposited(msg.sender, _token, _amount, mintAmount);
1433 
1434         return mintAmount;
1435     }
1436 
1437     /// @notice Withdraw funds from the Compound Protocol.
1438     ///
1439     /// @param _to The address of the amount receiver.
1440     /// @param _kToken The address of the kToken contract.
1441     /// @param _kTokenAmount The value of the kToken amount to be burned.
1442     ///
1443     /// @return Nothing.
1444     function withdraw(address payable _to, IKToken _kToken, uint256 _kTokenAmount) external nonReentrant whenNotPaused {
1445         require(registeredKTokens[address(_kToken)], "kToken is not registered");
1446         require(_kTokenAmount > 0, "Withdraw amount should be greater than 0");
1447         address token = _kToken.underlying();
1448         uint256 amount = calculateWithdrawAmount(_kToken, token, _kTokenAmount);
1449         _kToken.burnFrom(msg.sender, _kTokenAmount);
1450         if (token != ETHEREUM) {
1451             ERC20(token).safeTransfer(_to, amount);
1452         } else {
1453             (bool success,) = _to.call.value(amount)("");
1454             require(success, "Transfer Failed");
1455         }
1456         emit Withdrew(_to, msg.sender, token, amount, _kTokenAmount);
1457     }
1458 
1459     /// @notice borrow assets from this LP, and return them within the same transaction.
1460     ///
1461     /// @param _token The address of the token contract.
1462     /// @param _amount The amont of token.
1463     /// @param _data The implementation specific data for the Borrower.
1464     ///
1465     /// @return Nothing.
1466     function borrow(address _token, uint256 _amount, bytes calldata _data) external nonReentrant whenNotPaused {
1467         require(address(kTokens[_token]) != address(0x0), "Token is not registered");
1468         uint256 initialBalance = borrowableBalance(_token);
1469         if (_token != ETHEREUM) {
1470             ERC20(_token).safeTransfer(msg.sender, _amount);
1471         } else {
1472             (bool success,) = msg.sender.call.value(_amount)("");
1473             require(success, "LiquidityPoolV1: failed to send funds to the borrower");
1474         }
1475         borrower.lend(msg.sender, _data);
1476         uint256 finalBalance = borrowableBalance(_token);
1477         require(finalBalance >= initialBalance, "Borrower failed to return the borrowed funds");
1478 
1479         uint256 fee = finalBalance.sub(initialBalance);
1480         uint256 poolFee = calculateFee(poolFeeInBips, fee);
1481         emit Borrowed(msg.sender, _token, _amount, fee);
1482         if (_token != ETHEREUM) {
1483             ERC20(_token).safeTransfer(feePool, poolFee);
1484         } else {
1485             (bool success,) = feePool.call.value(poolFee)("");
1486             require(success, "LiquidityPoolV1: failed to send funds to the fee pool");
1487         }
1488     }
1489 
1490     /// @notice Calculate the given token's outstanding balance of this contract.
1491     ///
1492     /// @param _token The address of the token contract.
1493     ///
1494     /// @return Outstanding balance of the given token.
1495     function borrowableBalance(address _token) public view returns (uint256) {
1496         if (_token == ETHEREUM) {
1497             return address(this).balance;
1498         }
1499         return ERC20(_token).balanceOf(address(this));
1500     }
1501 
1502     /// @notice Calculate the given owner's outstanding balance for the given token on this contract.
1503     ///
1504     /// @param _token The address of the token contract.
1505     /// @param _owner The address of the token contract.
1506     ///
1507     /// @return Owner's outstanding balance of the given token.
1508     function underlyingBalance(address _token, address _owner) public view returns (uint256) {
1509         uint256 kBalance = kTokens[_token].balanceOf(_owner);
1510         uint256 kSupply = kTokens[_token].totalSupply();
1511         if (kBalance == 0) {
1512             return 0;
1513         }
1514         return borrowableBalance(_token).mul(kBalance).div(kSupply);
1515     }
1516 
1517     /// @notice Migrate funds to the new liquidity provider.
1518     ///
1519     /// @param _newLP The address of the new LiquidityPool contract.
1520     ///
1521     /// @return Outstanding balance of the given token.
1522     function migrate(ILiquidityPool _newLP) public onlyOperator {
1523         for (uint256 i = 0; i < registeredTokens.length; i++) {
1524             address token = registeredTokens[i];
1525             kTokens[token].addMinter(address(_newLP));
1526             kTokens[token].renounceMinter();
1527             _newLP.register(kTokens[token]);
1528             if (token != ETHEREUM) {
1529                 ERC20(token).safeTransfer(address(_newLP), borrowableBalance(token));
1530             } else {
1531                 (bool success,) = address(_newLP).call.value(borrowableBalance(token))("");
1532                 require(success, "Transfer Failed");
1533             }
1534         }
1535         _newLP.renounceOperator();
1536     }
1537 
1538     // returns the corresponding kToken for the given underlying token if it exists.
1539     function kToken(address _token) external view returns (IKToken) {
1540         return kTokens[_token];
1541     }
1542 
1543     /// Calculates the amount that will be withdrawn when the given amount of kToken 
1544     /// is burnt.
1545     /// @dev used in the withdraw() function to calculate the amount that will be
1546     ///      withdrawn. 
1547     function calculateWithdrawAmount(IKToken _kToken, address _token, uint256 _kTokenAmount) internal view returns (uint256) {
1548         uint256 kTokenSupply = _kToken.totalSupply();
1549         require(kTokenSupply != 0, "No KTokens to be burnt");
1550         uint256 initialBalance = borrowableBalance(_token);
1551         return _kTokenAmount.mul(initialBalance).div(_kToken.totalSupply());
1552     }
1553 
1554     /// Calculates the amount of kTokens that will be minted when the given amount 
1555     /// is deposited.
1556     /// @dev used in the deposit() function to calculate the amount of kTokens that
1557     ///      will be minted.
1558     function calculateMintAmount(IKToken _kToken, address _token, uint256 _depositAmount) internal view returns (uint256) {
1559         // The borrow balance includes the deposit amount, which is removed here.        
1560         uint256 initialBalance = borrowableBalance(_token).sub(_depositAmount);
1561         uint256 kTokenSupply = _kToken.totalSupply();
1562         if (kTokenSupply == 0) {
1563             return _depositAmount;
1564         }
1565 
1566         // mintAmoount = amountDeposited * (1-fee) * kPool /(pool + amountDeposited * fee)
1567         return (applyFee(depositFeeInBips, _depositAmount).mul(kTokenSupply))
1568             .div(initialBalance.add(
1569                 calculateFee(depositFeeInBips, _depositAmount)
1570             ));
1571     }
1572 
1573     /// Applies the fee by subtracting fees from the amount and returns  
1574     /// the amount after deducting the fee.
1575     /// @dev it calculates (1 - fee) * amount
1576     function applyFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
1577         return _amount.mul(FEE_BASE.sub(_feeInBips)).div(FEE_BASE); 
1578     }
1579 
1580     /// Calculates the fee amount. 
1581     /// @dev it calculates fee * amount
1582     function calculateFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
1583         return _amount.mul(_feeInBips).div(FEE_BASE); 
1584     }
1585 }