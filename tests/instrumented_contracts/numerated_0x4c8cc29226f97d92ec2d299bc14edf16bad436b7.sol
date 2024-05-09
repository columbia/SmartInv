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
34     function lend(address _caller, bytes calldata _data) external payable;
35 }
36 
37 /**
38  * @title Initializable
39  *
40  * @dev Helper contract to support initializer functions. To use it, replace
41  * the constructor with a function that has the `initializer` modifier.
42  * WARNING: Unlike constructors, initializer functions must be manually
43  * invoked. This applies both to deploying an Initializable contract, as well
44  * as extending an Initializable contract via inheritance.
45  * WARNING: When used with inheritance, manual care must be taken to not invoke
46  * a parent initializer twice, or ensure that all initializers are idempotent,
47  * because this is not dealt with automatically as with constructors.
48  */
49 contract Initializable {
50 
51   /**
52    * @dev Indicates that the contract has been initialized.
53    */
54   bool private initialized;
55 
56   /**
57    * @dev Indicates that the contract is in the process of being initialized.
58    */
59   bool private initializing;
60 
61   /**
62    * @dev Modifier to use in the initializer function of a contract.
63    */
64   modifier initializer() {
65     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
66 
67     bool isTopLevelCall = !initializing;
68     if (isTopLevelCall) {
69       initializing = true;
70       initialized = true;
71     }
72 
73     _;
74 
75     if (isTopLevelCall) {
76       initializing = false;
77     }
78   }
79 
80   /// @dev Returns true if and only if the function is running in the constructor
81   function isConstructor() private view returns (bool) {
82     // extcodesize checks the size of the code stored in an address, and
83     // address returns the current address. Since the code is still not
84     // deployed when running a constructor, any checks on its code size will
85     // yield zero, making it an effective way to detect if a contract is
86     // under construction or not.
87     address self = address(this);
88     uint256 cs;
89     assembly { cs := extcodesize(self) }
90     return cs == 0;
91   }
92 
93   // Reserved storage space to allow for layout changes in the future.
94   uint256[50] private ______gap;
95 }
96 
97 /*
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with GSN meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 contract Context is Initializable {
108     // Empty internal constructor, to prevent people from mistakenly deploying
109     // an instance of this contract, which should be used via inheritance.
110     constructor () internal { }
111     // solhint-disable-previous-line no-empty-blocks
112 
113     function _msgSender() internal view returns (address payable) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view returns (bytes memory) {
118         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
119         return msg.data;
120     }
121 }
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
125  * the optional functions; to access them see {ERC20Detailed}.
126  */
127 interface IERC20 {
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `recipient`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `sender` to `recipient` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      * - Addition cannot overflow.
220      */
221     function add(uint256 a, uint256 b) internal pure returns (uint256) {
222         uint256 c = a + b;
223         require(c >= a, "SafeMath: addition overflow");
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
238         return sub(a, b, "SafeMath: subtraction overflow");
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      * - Subtraction cannot overflow.
249      *
250      * _Available since v2.4.0._
251      */
252     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b <= a, errorMessage);
254         uint256 c = a - b;
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the multiplication of two unsigned integers, reverting on
261      * overflow.
262      *
263      * Counterpart to Solidity's `*` operator.
264      *
265      * Requirements:
266      * - Multiplication cannot overflow.
267      */
268     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
269         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
270         // benefit is lost if 'b' is also tested.
271         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
272         if (a == 0) {
273             return 0;
274         }
275 
276         uint256 c = a * b;
277         require(c / a == b, "SafeMath: multiplication overflow");
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b) internal pure returns (uint256) {
294         return div(a, b, "SafeMath: division by zero");
295     }
296 
297     /**
298      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
299      * division by zero. The result is rounded towards zero.
300      *
301      * Counterpart to Solidity's `/` operator. Note: this function uses a
302      * `revert` opcode (which leaves remaining gas untouched) while Solidity
303      * uses an invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      * - The divisor cannot be zero.
307      *
308      * _Available since v2.4.0._
309      */
310     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         // Solidity only automatically asserts when dividing by 0
312         require(b > 0, errorMessage);
313         uint256 c = a / b;
314         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         return mod(a, b, "SafeMath: modulo by zero");
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
336      * Reverts with custom message when dividing by zero.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      * - The divisor cannot be zero.
344      *
345      * _Available since v2.4.0._
346      */
347     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
348         require(b != 0, errorMessage);
349         return a % b;
350     }
351 }
352 
353 /**
354  * @dev Implementation of the {IERC20} interface.
355  *
356  * This implementation is agnostic to the way tokens are created. This means
357  * that a supply mechanism has to be added in a derived contract using {_mint}.
358  * For a generic mechanism see {ERC20Mintable}.
359  *
360  * TIP: For a detailed writeup see our guide
361  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
362  * to implement supply mechanisms].
363  *
364  * We have followed general OpenZeppelin guidelines: functions revert instead
365  * of returning `false` on failure. This behavior is nonetheless conventional
366  * and does not conflict with the expectations of ERC20 applications.
367  *
368  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
369  * This allows applications to reconstruct the allowance for all accounts just
370  * by listening to said events. Other implementations of the EIP may not emit
371  * these events, as it isn't required by the specification.
372  *
373  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
374  * functions have been added to mitigate the well-known issues around setting
375  * allowances. See {IERC20-approve}.
376  */
377 contract ERC20 is Initializable, Context, IERC20 {
378     using SafeMath for uint256;
379 
380     mapping (address => uint256) private _balances;
381 
382     mapping (address => mapping (address => uint256)) private _allowances;
383 
384     uint256 private _totalSupply;
385 
386     /**
387      * @dev See {IERC20-totalSupply}.
388      */
389     function totalSupply() public view returns (uint256) {
390         return _totalSupply;
391     }
392 
393     /**
394      * @dev See {IERC20-balanceOf}.
395      */
396     function balanceOf(address account) public view returns (uint256) {
397         return _balances[account];
398     }
399 
400     /**
401      * @dev See {IERC20-transfer}.
402      *
403      * Requirements:
404      *
405      * - `recipient` cannot be the zero address.
406      * - the caller must have a balance of at least `amount`.
407      */
408     function transfer(address recipient, uint256 amount) public returns (bool) {
409         _transfer(_msgSender(), recipient, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-allowance}.
415      */
416     function allowance(address owner, address spender) public view returns (uint256) {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See {IERC20-approve}.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(address spender, uint256 amount) public returns (bool) {
428         _approve(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-transferFrom}.
434      *
435      * Emits an {Approval} event indicating the updated allowance. This is not
436      * required by the EIP. See the note at the beginning of {ERC20};
437      *
438      * Requirements:
439      * - `sender` and `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      * - the caller must have allowance for `sender`'s tokens of at least
442      * `amount`.
443      */
444     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
445         _transfer(sender, recipient, amount);
446         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
447         return true;
448     }
449 
450     /**
451      * @dev Atomically increases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      */
462     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
464         return true;
465     }
466 
467     /**
468      * @dev Atomically decreases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      * - `spender` must have allowance for the caller of at least
479      * `subtractedValue`.
480      */
481     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
483         return true;
484     }
485 
486     /**
487      * @dev Moves tokens `amount` from `sender` to `recipient`.
488      *
489      * This is internal function is equivalent to {transfer}, and can be used to
490      * e.g. implement automatic token fees, slashing mechanisms, etc.
491      *
492      * Emits a {Transfer} event.
493      *
494      * Requirements:
495      *
496      * - `sender` cannot be the zero address.
497      * - `recipient` cannot be the zero address.
498      * - `sender` must have a balance of at least `amount`.
499      */
500     function _transfer(address sender, address recipient, uint256 amount) internal {
501         require(sender != address(0), "ERC20: transfer from the zero address");
502         require(recipient != address(0), "ERC20: transfer to the zero address");
503 
504         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
505         _balances[recipient] = _balances[recipient].add(amount);
506         emit Transfer(sender, recipient, amount);
507     }
508 
509     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
510      * the total supply.
511      *
512      * Emits a {Transfer} event with `from` set to the zero address.
513      *
514      * Requirements
515      *
516      * - `to` cannot be the zero address.
517      */
518     function _mint(address account, uint256 amount) internal {
519         require(account != address(0), "ERC20: mint to the zero address");
520 
521         _totalSupply = _totalSupply.add(amount);
522         _balances[account] = _balances[account].add(amount);
523         emit Transfer(address(0), account, amount);
524     }
525 
526     /**
527      * @dev Destroys `amount` tokens from `account`, reducing the
528      * total supply.
529      *
530      * Emits a {Transfer} event with `to` set to the zero address.
531      *
532      * Requirements
533      *
534      * - `account` cannot be the zero address.
535      * - `account` must have at least `amount` tokens.
536      */
537     function _burn(address account, uint256 amount) internal {
538         require(account != address(0), "ERC20: burn from the zero address");
539 
540         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
541         _totalSupply = _totalSupply.sub(amount);
542         emit Transfer(account, address(0), amount);
543     }
544 
545     /**
546      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
547      *
548      * This is internal function is equivalent to `approve`, and can be used to
549      * e.g. set automatic allowances for certain subsystems, etc.
550      *
551      * Emits an {Approval} event.
552      *
553      * Requirements:
554      *
555      * - `owner` cannot be the zero address.
556      * - `spender` cannot be the zero address.
557      */
558     function _approve(address owner, address spender, uint256 amount) internal {
559         require(owner != address(0), "ERC20: approve from the zero address");
560         require(spender != address(0), "ERC20: approve to the zero address");
561 
562         _allowances[owner][spender] = amount;
563         emit Approval(owner, spender, amount);
564     }
565 
566     /**
567      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
568      * from the caller's allowance.
569      *
570      * See {_burn} and {_approve}.
571      */
572     function _burnFrom(address account, uint256 amount) internal {
573         _burn(account, amount);
574         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
575     }
576 
577     uint256[50] private ______gap;
578 }
579 
580 /**
581  * @dev Collection of functions related to the address type
582  */
583 library Address {
584     /**
585      * @dev Returns true if `account` is a contract.
586      *
587      * [IMPORTANT]
588      * ====
589      * It is unsafe to assume that an address for which this function returns
590      * false is an externally-owned account (EOA) and not a contract.
591      *
592      * Among others, `isContract` will return false for the following 
593      * types of addresses:
594      *
595      *  - an externally-owned account
596      *  - a contract in construction
597      *  - an address where a contract will be created
598      *  - an address where a contract lived, but was destroyed
599      * ====
600      */
601     function isContract(address account) internal view returns (bool) {
602         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
603         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
604         // for accounts without code, i.e. `keccak256('')`
605         bytes32 codehash;
606         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
607         // solhint-disable-next-line no-inline-assembly
608         assembly { codehash := extcodehash(account) }
609         return (codehash != accountHash && codehash != 0x0);
610     }
611 
612     /**
613      * @dev Converts an `address` into `address payable`. Note that this is
614      * simply a type cast: the actual underlying value is not changed.
615      *
616      * _Available since v2.4.0._
617      */
618     function toPayable(address account) internal pure returns (address payable) {
619         return address(uint160(account));
620     }
621 
622     /**
623      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
624      * `recipient`, forwarding all available gas and reverting on errors.
625      *
626      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
627      * of certain opcodes, possibly making contracts go over the 2300 gas limit
628      * imposed by `transfer`, making them unable to receive funds via
629      * `transfer`. {sendValue} removes this limitation.
630      *
631      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
632      *
633      * IMPORTANT: because control is transferred to `recipient`, care must be
634      * taken to not create reentrancy vulnerabilities. Consider using
635      * {ReentrancyGuard} or the
636      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
637      *
638      * _Available since v2.4.0._
639      */
640     function sendValue(address payable recipient, uint256 amount) internal {
641         require(address(this).balance >= amount, "Address: insufficient balance");
642 
643         // solhint-disable-next-line avoid-call-value
644         (bool success, ) = recipient.call.value(amount)("");
645         require(success, "Address: unable to send value, recipient may have reverted");
646     }
647 }
648 
649 /**
650  * @title SafeERC20
651  * @dev Wrappers around ERC20 operations that throw on failure (when the token
652  * contract returns false). Tokens that return no value (and instead revert or
653  * throw on failure) are also supported, non-reverting calls are assumed to be
654  * successful.
655  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
656  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
657  */
658 library SafeERC20 {
659     using SafeMath for uint256;
660     using Address for address;
661 
662     function safeTransfer(IERC20 token, address to, uint256 value) internal {
663         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
664     }
665 
666     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
667         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
668     }
669 
670     function safeApprove(IERC20 token, address spender, uint256 value) internal {
671         // safeApprove should only be called when setting an initial allowance,
672         // or when resetting it to zero. To increase and decrease it, use
673         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
674         // solhint-disable-next-line max-line-length
675         require((value == 0) || (token.allowance(address(this), spender) == 0),
676             "SafeERC20: approve from non-zero to non-zero allowance"
677         );
678         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
679     }
680 
681     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
682         uint256 newAllowance = token.allowance(address(this), spender).add(value);
683         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
684     }
685 
686     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
687         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
688         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
689     }
690 
691     /**
692      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
693      * on the return value: the return value is optional (but if data is returned, it must not be false).
694      * @param token The token targeted by the call.
695      * @param data The call data (encoded using abi.encode or one of its variants).
696      */
697     function callOptionalReturn(IERC20 token, bytes memory data) private {
698         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
699         // we're implementing it ourselves.
700 
701         // A Solidity high level call has three parts:
702         //  1. The target address is checked to verify it contains contract code
703         //  2. The call itself is made, and success asserted
704         //  3. The return value is decoded, which in turn checks the size of the returned data.
705         // solhint-disable-next-line max-line-length
706         require(address(token).isContract(), "SafeERC20: call to non-contract");
707 
708         // solhint-disable-next-line avoid-low-level-calls
709         (bool success, bytes memory returndata) = address(token).call(data);
710         require(success, "SafeERC20: low-level call failed");
711 
712         if (returndata.length > 0) { // Return data is optional
713             // solhint-disable-next-line max-line-length
714             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
715         }
716     }
717 }
718 
719 /**
720  * @title Roles
721  * @dev Library for managing addresses assigned to a Role.
722  */
723 library Roles {
724     struct Role {
725         mapping (address => bool) bearer;
726     }
727 
728     /**
729      * @dev Give an account access to this role.
730      */
731     function add(Role storage role, address account) internal {
732         require(!has(role, account), "Roles: account already has role");
733         role.bearer[account] = true;
734     }
735 
736     /**
737      * @dev Remove an account's access to this role.
738      */
739     function remove(Role storage role, address account) internal {
740         require(has(role, account), "Roles: account does not have role");
741         role.bearer[account] = false;
742     }
743 
744     /**
745      * @dev Check if an account has this role.
746      * @return bool
747      */
748     function has(Role storage role, address account) internal view returns (bool) {
749         require(account != address(0), "Roles: account is the zero address");
750         return role.bearer[account];
751     }
752 }
753 
754 contract KRoles is Initializable {
755     using Roles for Roles.Role;
756 
757     event OperatorAdded(address indexed account);
758     event OperatorRemoved(address indexed account);
759 
760     Roles.Role private _operators;
761     address[] public operators;
762 
763     function initialize(address _operator) public initializer {
764         _addOperator(_operator);
765     }
766 
767     modifier onlyOperator() {
768         require(isOperator(msg.sender), "OperatorRole: caller does not have the Operator role");
769         _;
770     }
771 
772     function isOperator(address account) public view returns (bool) {
773         return _operators.has(account);
774     }
775 
776     function addOperator(address account) public onlyOperator {
777         _addOperator(account);
778     }
779 
780     function renounceOperator() public {
781         _removeOperator(msg.sender);
782     }
783 
784     function _addOperator(address account) internal {
785         _operators.add(account);
786         emit OperatorAdded(account);
787     }
788 
789     function _removeOperator(address account) internal {
790         _operators.remove(account);
791         emit OperatorRemoved(account);
792     }
793 }
794 
795 contract CanReclaimTokens is KRoles {
796     using SafeERC20 for ERC20;
797 
798     mapping(address => bool) private recoverableTokensBlacklist;
799 
800     function initialize(address _nextOwner) public initializer {
801         KRoles.initialize(_nextOwner);
802     }
803 
804     function blacklistRecoverableToken(address _token) public onlyOperator {
805         recoverableTokensBlacklist[_token] = true;
806     }
807 
808     /// @notice Allow the owner of the contract to recover funds accidentally
809     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
810     function recoverTokens(address _token) external onlyOperator {
811         require(
812             !recoverableTokensBlacklist[_token],
813             "CanReclaimTokens: token is not recoverable"
814         );
815 
816         if (_token == address(0x0)) {
817            (bool success,) = msg.sender.call.value(address(this).balance)("");
818             require(success, "Transfer Failed");
819         } else {
820             ERC20(_token).safeTransfer(
821                 msg.sender,
822                 ERC20(_token).balanceOf(address(this))
823             );
824         }
825     }
826 }
827 
828 /**
829  * @dev Contract module that helps prevent reentrant calls to a function.
830  *
831  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
832  * available, which can be applied to functions to make sure there are no nested
833  * (reentrant) calls to them.
834  *
835  * Note that because there is a single `nonReentrant` guard, functions marked as
836  * `nonReentrant` may not call one another. This can be worked around by making
837  * those functions `private`, and then adding `external` `nonReentrant` entry
838  * points to them.
839  */
840 contract ReentrancyGuard is Initializable {
841     // counter to allow mutex lock with only one SSTORE operation
842     uint256 private _guardCounter;
843 
844     function initialize() public initializer {
845         // The counter starts at one to prevent changing it from zero to a non-zero
846         // value, which is a more expensive operation.
847         _guardCounter = 1;
848     }
849 
850     /**
851      * @dev Prevents a contract from calling itself, directly or indirectly.
852      * Calling a `nonReentrant` function from another `nonReentrant`
853      * function is not supported. It is possible to prevent this from happening
854      * by making the `nonReentrant` function external, and make it call a
855      * `private` function that does the actual work.
856      */
857     modifier nonReentrant() {
858         _guardCounter += 1;
859         uint256 localCounter = _guardCounter;
860         _;
861         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
862     }
863 
864     uint256[50] private ______gap;
865 }
866 
867 contract PauserRole is Initializable, Context {
868     using Roles for Roles.Role;
869 
870     event PauserAdded(address indexed account);
871     event PauserRemoved(address indexed account);
872 
873     Roles.Role private _pausers;
874 
875     function initialize(address sender) public initializer {
876         if (!isPauser(sender)) {
877             _addPauser(sender);
878         }
879     }
880 
881     modifier onlyPauser() {
882         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
883         _;
884     }
885 
886     function isPauser(address account) public view returns (bool) {
887         return _pausers.has(account);
888     }
889 
890     function addPauser(address account) public onlyPauser {
891         _addPauser(account);
892     }
893 
894     function renouncePauser() public {
895         _removePauser(_msgSender());
896     }
897 
898     function _addPauser(address account) internal {
899         _pausers.add(account);
900         emit PauserAdded(account);
901     }
902 
903     function _removePauser(address account) internal {
904         _pausers.remove(account);
905         emit PauserRemoved(account);
906     }
907 
908     uint256[50] private ______gap;
909 }
910 
911 /**
912  * @dev Contract module which allows children to implement an emergency stop
913  * mechanism that can be triggered by an authorized account.
914  *
915  * This module is used through inheritance. It will make available the
916  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
917  * the functions of your contract. Note that they will not be pausable by
918  * simply including this module, only once the modifiers are put in place.
919  */
920 contract Pausable is Initializable, Context, PauserRole {
921     /**
922      * @dev Emitted when the pause is triggered by a pauser (`account`).
923      */
924     event Paused(address account);
925 
926     /**
927      * @dev Emitted when the pause is lifted by a pauser (`account`).
928      */
929     event Unpaused(address account);
930 
931     bool private _paused;
932 
933     /**
934      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
935      * to the deployer.
936      */
937     function initialize(address sender) public initializer {
938         PauserRole.initialize(sender);
939 
940         _paused = false;
941     }
942 
943     /**
944      * @dev Returns true if the contract is paused, and false otherwise.
945      */
946     function paused() public view returns (bool) {
947         return _paused;
948     }
949 
950     /**
951      * @dev Modifier to make a function callable only when the contract is not paused.
952      */
953     modifier whenNotPaused() {
954         require(!_paused, "Pausable: paused");
955         _;
956     }
957 
958     /**
959      * @dev Modifier to make a function callable only when the contract is paused.
960      */
961     modifier whenPaused() {
962         require(_paused, "Pausable: not paused");
963         _;
964     }
965 
966     /**
967      * @dev Called by a pauser to pause, triggers stopped state.
968      */
969     function pause() public onlyPauser whenNotPaused {
970         _paused = true;
971         emit Paused(_msgSender());
972     }
973 
974     /**
975      * @dev Called by a pauser to unpause, returns to normal state.
976      */
977     function unpause() public onlyPauser whenPaused {
978         _paused = false;
979         emit Unpaused(_msgSender());
980     }
981 
982     uint256[50] private ______gap;
983 }
984 
985 /**
986  * @title Proxy
987  * @dev Implements delegation of calls to other contracts, with proper
988  * forwarding of return values and bubbling of failures.
989  * It defines a fallback function that delegates all calls to the address
990  * returned by the abstract _implementation() internal function.
991  */
992 contract Proxy {
993   /**
994    * @dev Fallback function.
995    * Implemented entirely in `_fallback`.
996    */
997   function () payable external {
998     _fallback();
999   }
1000 
1001   /**
1002    * @return The Address of the implementation.
1003    */
1004   function _implementation() internal view returns (address);
1005 
1006   /**
1007    * @dev Delegates execution to an implementation contract.
1008    * This is a low level function that doesn't return to its internal call site.
1009    * It will return to the external caller whatever the implementation returns.
1010    * @param implementation Address to delegate.
1011    */
1012   function _delegate(address implementation) internal {
1013     assembly {
1014       // Copy msg.data. We take full control of memory in this inline assembly
1015       // block because it will not return to Solidity code. We overwrite the
1016       // Solidity scratch pad at memory position 0.
1017       calldatacopy(0, 0, calldatasize)
1018 
1019       // Call the implementation.
1020       // out and outsize are 0 because we don't know the size yet.
1021       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
1022 
1023       // Copy the returned data.
1024       returndatacopy(0, 0, returndatasize)
1025 
1026       switch result
1027       // delegatecall returns 0 on error.
1028       case 0 { revert(0, returndatasize) }
1029       default { return(0, returndatasize) }
1030     }
1031   }
1032 
1033   /**
1034    * @dev Function that is run as the first thing in the fallback function.
1035    * Can be redefined in derived contracts to add functionality.
1036    * Redefinitions must call super._willFallback().
1037    */
1038   function _willFallback() internal {
1039   }
1040 
1041   /**
1042    * @dev fallback implementation.
1043    * Extracted to enable manual triggering.
1044    */
1045   function _fallback() internal {
1046     _willFallback();
1047     _delegate(_implementation());
1048   }
1049 }
1050 
1051 /**
1052  * Utility library of inline functions on addresses
1053  *
1054  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
1055  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
1056  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
1057  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
1058  */
1059 library OpenZeppelinUpgradesAddress {
1060     /**
1061      * Returns whether the target address is a contract
1062      * @dev This function will return false if invoked during the constructor of a contract,
1063      * as the code is not actually created until after the constructor finishes.
1064      * @param account address of the account to check
1065      * @return whether the target address is a contract
1066      */
1067     function isContract(address account) internal view returns (bool) {
1068         uint256 size;
1069         // XXX Currently there is no better way to check if there is a contract in an address
1070         // than to check the size of the code at that address.
1071         // See https://ethereum.stackexchange.com/a/14016/36603
1072         // for more details about how this works.
1073         // TODO Check this again before the Serenity release, because all addresses will be
1074         // contracts then.
1075         // solhint-disable-next-line no-inline-assembly
1076         assembly { size := extcodesize(account) }
1077         return size > 0;
1078     }
1079 }
1080 
1081 /**
1082  * @title BaseUpgradeabilityProxy
1083  * @dev This contract implements a proxy that allows to change the
1084  * implementation address to which it will delegate.
1085  * Such a change is called an implementation upgrade.
1086  */
1087 contract BaseUpgradeabilityProxy is Proxy {
1088   /**
1089    * @dev Emitted when the implementation is upgraded.
1090    * @param implementation Address of the new implementation.
1091    */
1092   event Upgraded(address indexed implementation);
1093 
1094   /**
1095    * @dev Storage slot with the address of the current implementation.
1096    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
1097    * validated in the constructor.
1098    */
1099   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1100 
1101   /**
1102    * @dev Returns the current implementation.
1103    * @return Address of the current implementation
1104    */
1105   function _implementation() internal view returns (address impl) {
1106     bytes32 slot = IMPLEMENTATION_SLOT;
1107     assembly {
1108       impl := sload(slot)
1109     }
1110   }
1111 
1112   /**
1113    * @dev Upgrades the proxy to a new implementation.
1114    * @param newImplementation Address of the new implementation.
1115    */
1116   function _upgradeTo(address newImplementation) internal {
1117     _setImplementation(newImplementation);
1118     emit Upgraded(newImplementation);
1119   }
1120 
1121   /**
1122    * @dev Sets the implementation address of the proxy.
1123    * @param newImplementation Address of the new implementation.
1124    */
1125   function _setImplementation(address newImplementation) internal {
1126     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
1127 
1128     bytes32 slot = IMPLEMENTATION_SLOT;
1129 
1130     assembly {
1131       sstore(slot, newImplementation)
1132     }
1133   }
1134 }
1135 
1136 /**
1137  * @title UpgradeabilityProxy
1138  * @dev Extends BaseUpgradeabilityProxy with a constructor for initializing
1139  * implementation and init data.
1140  */
1141 contract UpgradeabilityProxy is BaseUpgradeabilityProxy {
1142   /**
1143    * @dev Contract constructor.
1144    * @param _logic Address of the initial implementation.
1145    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1146    * It should include the signature and the parameters of the function to be called, as described in
1147    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1148    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1149    */
1150   constructor(address _logic, bytes memory _data) public payable {
1151     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
1152     _setImplementation(_logic);
1153     if(_data.length > 0) {
1154       (bool success,) = _logic.delegatecall(_data);
1155       require(success);
1156     }
1157   }  
1158 }
1159 
1160 /**
1161  * @title BaseAdminUpgradeabilityProxy
1162  * @dev This contract combines an upgradeability proxy with an authorization
1163  * mechanism for administrative tasks.
1164  * All external functions in this contract must be guarded by the
1165  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
1166  * feature proposal that would enable this to be done automatically.
1167  */
1168 contract BaseAdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
1169   /**
1170    * @dev Emitted when the administration has been transferred.
1171    * @param previousAdmin Address of the previous admin.
1172    * @param newAdmin Address of the new admin.
1173    */
1174   event AdminChanged(address previousAdmin, address newAdmin);
1175 
1176   /**
1177    * @dev Storage slot with the admin of the contract.
1178    * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
1179    * validated in the constructor.
1180    */
1181 
1182   bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
1183 
1184   /**
1185    * @dev Modifier to check whether the `msg.sender` is the admin.
1186    * If it is, it will run the function. Otherwise, it will delegate the call
1187    * to the implementation.
1188    */
1189   modifier ifAdmin() {
1190     if (msg.sender == _admin()) {
1191       _;
1192     } else {
1193       _fallback();
1194     }
1195   }
1196 
1197   /**
1198    * @return The address of the proxy admin.
1199    */
1200   function admin() external ifAdmin returns (address) {
1201     return _admin();
1202   }
1203 
1204   /**
1205    * @return The address of the implementation.
1206    */
1207   function implementation() external ifAdmin returns (address) {
1208     return _implementation();
1209   }
1210 
1211   /**
1212    * @dev Changes the admin of the proxy.
1213    * Only the current admin can call this function.
1214    * @param newAdmin Address to transfer proxy administration to.
1215    */
1216   function changeAdmin(address newAdmin) external ifAdmin {
1217     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
1218     emit AdminChanged(_admin(), newAdmin);
1219     _setAdmin(newAdmin);
1220   }
1221 
1222   /**
1223    * @dev Upgrade the backing implementation of the proxy.
1224    * Only the admin can call this function.
1225    * @param newImplementation Address of the new implementation.
1226    */
1227   function upgradeTo(address newImplementation) external ifAdmin {
1228     _upgradeTo(newImplementation);
1229   }
1230 
1231   /**
1232    * @dev Upgrade the backing implementation of the proxy and call a function
1233    * on the new implementation.
1234    * This is useful to initialize the proxied contract.
1235    * @param newImplementation Address of the new implementation.
1236    * @param data Data to send as msg.data in the low level call.
1237    * It should include the signature and the parameters of the function to be called, as described in
1238    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1239    */
1240   function upgradeToAndCall(address newImplementation, bytes calldata data) payable external ifAdmin {
1241     _upgradeTo(newImplementation);
1242     (bool success,) = newImplementation.delegatecall(data);
1243     require(success);
1244   }
1245 
1246   /**
1247    * @return The admin slot.
1248    */
1249   function _admin() internal view returns (address adm) {
1250     bytes32 slot = ADMIN_SLOT;
1251     assembly {
1252       adm := sload(slot)
1253     }
1254   }
1255 
1256   /**
1257    * @dev Sets the address of the proxy admin.
1258    * @param newAdmin Address of the new proxy admin.
1259    */
1260   function _setAdmin(address newAdmin) internal {
1261     bytes32 slot = ADMIN_SLOT;
1262 
1263     assembly {
1264       sstore(slot, newAdmin)
1265     }
1266   }
1267 
1268   /**
1269    * @dev Only fall back when the sender is not the admin.
1270    */
1271   function _willFallback() internal {
1272     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
1273     super._willFallback();
1274   }
1275 }
1276 
1277 /**
1278  * @title InitializableUpgradeabilityProxy
1279  * @dev Extends BaseUpgradeabilityProxy with an initializer for initializing
1280  * implementation and init data.
1281  */
1282 contract InitializableUpgradeabilityProxy is BaseUpgradeabilityProxy {
1283   /**
1284    * @dev Contract initializer.
1285    * @param _logic Address of the initial implementation.
1286    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1287    * It should include the signature and the parameters of the function to be called, as described in
1288    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1289    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1290    */
1291   function initialize(address _logic, bytes memory _data) public payable {
1292     require(_implementation() == address(0));
1293     assert(IMPLEMENTATION_SLOT == bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1));
1294     _setImplementation(_logic);
1295     if(_data.length > 0) {
1296       (bool success,) = _logic.delegatecall(_data);
1297       require(success);
1298     }
1299   }  
1300 }
1301 
1302 /**
1303  * @title InitializableAdminUpgradeabilityProxy
1304  * @dev Extends from BaseAdminUpgradeabilityProxy with an initializer for 
1305  * initializing the implementation, admin, and init data.
1306  */
1307 contract InitializableAdminUpgradeabilityProxy is BaseAdminUpgradeabilityProxy, InitializableUpgradeabilityProxy {
1308   /**
1309    * Contract initializer.
1310    * @param _logic address of the initial implementation.
1311    * @param _admin Address of the proxy administrator.
1312    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
1313    * It should include the signature and the parameters of the function to be called, as described in
1314    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
1315    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
1316    */
1317   function initialize(address _logic, address _admin, bytes memory _data) public payable {
1318     require(_implementation() == address(0));
1319     InitializableUpgradeabilityProxy.initialize(_logic, _data);
1320     assert(ADMIN_SLOT == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
1321     _setAdmin(_admin);
1322   }
1323 }
1324 
1325 contract LiquidityPoolV2 is ILiquidityPool, CanReclaimTokens, ReentrancyGuard, Pausable {
1326     using SafeMath for uint256;
1327     using SafeERC20 for ERC20;
1328 
1329     mapping (address=>IKToken) public kTokens;
1330     address[] public registeredTokens;
1331     mapping (address=>bool) public registeredKTokens;
1332     string public VERSION;
1333     IBorrowerProxy borrower;
1334 
1335     uint256 public depositFeeInBips;
1336     uint256 public poolFeeInBips;
1337     uint256 public FEE_BASE = 10000;
1338 
1339     address public ETHEREUM = address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1340     address payable feePool;
1341 
1342     event Deposited(address indexed _depositor, address indexed _token, uint256 _amount, uint256 _mintAmount);
1343     event Withdrew(address indexed _reciever, address indexed _withdrawer, address indexed _token, uint256 _amount, uint256 _burnAmount);
1344     event Borrowed(address indexed _borrower, address indexed _token, uint256 _amount, uint256 _fee);
1345     event EtherReceived(address indexed _from, uint256 _amount);
1346 
1347     function () external payable {
1348         emit EtherReceived(_msgSender(), msg.value);
1349     }
1350 
1351     function initialize(string memory _VERSION, address _borrower) public initializer {
1352         require(_borrower != address(0), "LiquidityPoolV2: borrower proxy cannot be 0x0");
1353         CanReclaimTokens.initialize(msg.sender);
1354         Pausable.initialize(msg.sender);
1355         ReentrancyGuard.initialize();
1356         Pausable.initialize(msg.sender);
1357 
1358         VERSION = _VERSION;
1359         borrower = IBorrowerProxy(_borrower);
1360     }
1361 
1362     /// @notice updates the deposit fee.
1363     ///
1364     /// @dev fee is in bips so it should 
1365     ///     satisfy [0 <= fee <= FEE_BASE]
1366     /// @param _depositFeeInBips The new deposit fee.
1367     ///
1368     /// @return Nothing.
1369     function updateDepositFee(uint256 _depositFeeInBips) external onlyOperator {
1370         require(_depositFeeInBips >= 0 && _depositFeeInBips <= FEE_BASE, "LiquidityPoolV1: fee should be between 0 and FEE_BASE");
1371         depositFeeInBips = _depositFeeInBips;
1372     }
1373 
1374     /// @notice updates the pool fee.
1375     ///
1376     /// @dev fee is in bips so it should 
1377     ///     satisfy [0 <= fee <= FEE_BASE]
1378     /// @param _poolFeeInBips The new pool fee.
1379     ///
1380     /// @return Nothing.
1381     function updatePoolFee(uint256 _poolFeeInBips) external onlyOperator {
1382         require(_poolFeeInBips >= 0 && _poolFeeInBips <= FEE_BASE, "LiquidityPoolV1: fee should be between 0 and FEE_BASE");
1383         poolFeeInBips = _poolFeeInBips;
1384     }
1385 
1386     /// @notice updates the fee pool.
1387     ///
1388     /// @param _newFeePool The new fee pool.
1389     ///
1390     /// @return Nothing.
1391     function updateFeePool(address payable _newFeePool) external onlyOperator {
1392         require(_newFeePool != address(0), "LiquidityPoolV2: feepool cannot be 0x0");
1393         feePool = _newFeePool;        
1394     }
1395 
1396     /// @notice register a token on this Keeper.
1397     ///
1398     /// @param _kToken The keeper ERC20 token.
1399     ///
1400     /// @return Nothing.
1401     function register(IKToken _kToken) external onlyOperator {
1402         require(address(kTokens[_kToken.underlying()]) == address(0x0), "Underlying asset should not have been registered");
1403         require(!registeredKTokens[address(_kToken)], "kToken should not have been registered");
1404 
1405         kTokens[_kToken.underlying()] = _kToken;
1406         registeredKTokens[address(_kToken)] = true;
1407         registeredTokens.push(address(_kToken.underlying()));
1408         blacklistRecoverableToken(_kToken.underlying());
1409     }
1410 
1411     /// @notice Deposit funds to the Keeper Protocol.
1412     ///
1413     /// @param _token The address of the token contract.
1414     /// @param _amount The value of deposit.
1415     ///
1416     /// @return Nothing.
1417     function deposit(address _token, uint256 _amount) external payable nonReentrant whenNotPaused returns (uint256) {
1418         IKToken kToken = kTokens[_token];
1419         require(address(kToken) != address(0x0), "Token is not registered");
1420         require(_amount > 0, "Deposit amount should be greater than 0");
1421         if (_token != ETHEREUM) {
1422             require(msg.value == 0, "LiquidityPoolV2: Should not allow ETH deposits during ERC20 token deposits");
1423             ERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
1424         } else {
1425             require(_amount == msg.value, "Incorrect eth amount");
1426         }
1427 
1428         uint256 mintAmount = calculateMintAmount(kToken, _token, _amount);
1429         kToken.mint(msg.sender, mintAmount);
1430         emit Deposited(msg.sender, _token, _amount, mintAmount);
1431 
1432         return mintAmount;
1433     }
1434 
1435     /// @notice Withdraw funds from the Compound Protocol.
1436     ///
1437     /// @param _to The address of the amount receiver.
1438     /// @param _kToken The address of the kToken contract.
1439     /// @param _kTokenAmount The value of the kToken amount to be burned.
1440     ///
1441     /// @return Nothing.
1442     function withdraw(address payable _to, IKToken _kToken, uint256 _kTokenAmount) external nonReentrant whenNotPaused {
1443         require(registeredKTokens[address(_kToken)], "kToken is not registered");
1444         require(_kTokenAmount > 0, "Withdraw amount should be greater than 0");
1445         address token = _kToken.underlying();
1446         uint256 amount = calculateWithdrawAmount(_kToken, token, _kTokenAmount);
1447         _kToken.burnFrom(msg.sender, _kTokenAmount);
1448         if (token != ETHEREUM) {
1449             ERC20(token).safeTransfer(_to, amount);
1450         } else {
1451             (bool success,) = _to.call.value(amount)("");
1452             require(success, "Transfer Failed");
1453         }
1454         emit Withdrew(_to, msg.sender, token, amount, _kTokenAmount);
1455     }
1456 
1457     /// @notice borrow assets from this LP, and return them within the same transaction.
1458     ///
1459     /// @param _token The address of the token contract.
1460     /// @param _amount The amont of token.
1461     /// @param _data The implementation specific data for the Borrower.
1462     ///
1463     /// @return Nothing.
1464     function borrow(address _token, uint256 _amount, bytes calldata _data) external nonReentrant whenNotPaused {
1465         require(address(kTokens[_token]) != address(0x0), "Token is not registered");
1466         uint256 initialBalance = borrowableBalance(_token);
1467         if (_token != ETHEREUM) {
1468             ERC20(_token).safeTransfer(msg.sender, _amount);
1469         } else {
1470             (bool success,) = msg.sender.call.value(_amount)("");
1471             require(success, "LiquidityPoolV1: failed to send funds to the borrower");
1472         }
1473         borrower.lend(msg.sender, _data);
1474         uint256 finalBalance = borrowableBalance(_token);
1475         require(finalBalance >= initialBalance, "Borrower failed to return the borrowed funds");
1476 
1477         uint256 fee = finalBalance.sub(initialBalance);
1478         uint256 poolFee = calculateFee(poolFeeInBips, fee);
1479         emit Borrowed(msg.sender, _token, _amount, fee.sub(poolFee));
1480         if (_token != ETHEREUM) {
1481             ERC20(_token).safeTransfer(feePool, poolFee);
1482         } else {
1483             (bool success,) = feePool.call.value(poolFee)("");
1484             require(success, "LiquidityPoolV1: failed to send funds to the fee pool");
1485         }
1486     }
1487 
1488     /// @notice Calculate the given token's outstanding balance of this contract.
1489     ///
1490     /// @param _token The address of the token contract.
1491     ///
1492     /// @return Outstanding balance of the given token.
1493     function borrowableBalance(address _token) public view returns (uint256) {
1494         if (_token == ETHEREUM) {
1495             return address(this).balance;
1496         }
1497         return ERC20(_token).balanceOf(address(this));
1498     }
1499 
1500     /// @notice Calculate the given owner's outstanding balance for the given token on this contract.
1501     ///
1502     /// @param _token The address of the token contract.
1503     /// @param _owner The address of the token contract.
1504     ///
1505     /// @return Owner's outstanding balance of the given token.
1506     function underlyingBalance(address _token, address _owner) public view returns (uint256) {
1507         uint256 kBalance = kTokens[_token].balanceOf(_owner);
1508         uint256 kSupply = kTokens[_token].totalSupply();
1509         if (kBalance == 0) {
1510             return 0;
1511         }
1512         return borrowableBalance(_token).mul(kBalance).div(kSupply);
1513     }
1514 
1515     /// @notice Migrate funds to the new liquidity provider.
1516     ///
1517     /// @param _newLP The address of the new LiquidityPool contract.
1518     ///
1519     /// @return Outstanding balance of the given token.
1520     function migrate(ILiquidityPool _newLP) public onlyOperator {
1521         for (uint256 i = 0; i < registeredTokens.length; i++) {
1522             address token = registeredTokens[i];
1523             kTokens[token].addMinter(address(_newLP));
1524             kTokens[token].renounceMinter();
1525             _newLP.register(kTokens[token]);
1526             if (token != ETHEREUM) {
1527                 ERC20(token).safeTransfer(address(_newLP), borrowableBalance(token));
1528             } else {
1529                 (bool success,) = address(_newLP).call.value(borrowableBalance(token))("");
1530                 require(success, "Transfer Failed");
1531             }
1532         }
1533         _newLP.renounceOperator();
1534     }
1535 
1536     // returns the corresponding kToken for the given underlying token if it exists.
1537     function kToken(address _token) external view returns (IKToken) {
1538         return kTokens[_token];
1539     }
1540 
1541     /// Calculates the amount that will be withdrawn when the given amount of kToken 
1542     /// is burnt.
1543     /// @dev used in the withdraw() function to calculate the amount that will be
1544     ///      withdrawn. 
1545     function calculateWithdrawAmount(IKToken _kToken, address _token, uint256 _kTokenAmount) internal view returns (uint256) {
1546         uint256 kTokenSupply = _kToken.totalSupply();
1547         require(kTokenSupply != 0, "No KTokens to be burnt");
1548         uint256 initialBalance = borrowableBalance(_token);
1549         return _kTokenAmount.mul(initialBalance).div(_kToken.totalSupply());
1550     }
1551 
1552     /// Calculates the amount of kTokens that will be minted when the given amount 
1553     /// is deposited.
1554     /// @dev used in the deposit() function to calculate the amount of kTokens that
1555     ///      will be minted.
1556     function calculateMintAmount(IKToken _kToken, address _token, uint256 _depositAmount) internal view returns (uint256) {
1557         // The borrow balance includes the deposit amount, which is removed here.        
1558         uint256 initialBalance = borrowableBalance(_token).sub(_depositAmount);
1559         uint256 kTokenSupply = _kToken.totalSupply();
1560         if (kTokenSupply == 0) {
1561             return _depositAmount;
1562         }
1563 
1564         // mintAmoount = amountDeposited * (1-fee) * kPool /(pool + amountDeposited * fee)
1565         return (applyFee(depositFeeInBips, _depositAmount).mul(kTokenSupply))
1566             .div(initialBalance.add(
1567                 calculateFee(depositFeeInBips, _depositAmount)
1568             ));
1569     }
1570 
1571     /// Applies the fee by subtracting fees from the amount and returns  
1572     /// the amount after deducting the fee.
1573     /// @dev it calculates (1 - fee) * amount
1574     function applyFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
1575         return _amount.mul(FEE_BASE.sub(_feeInBips)).div(FEE_BASE); 
1576     }
1577 
1578     /// Calculates the fee amount. 
1579     /// @dev it calculates fee * amount
1580     function calculateFee(uint256 _feeInBips, uint256 _amount) internal view returns (uint256) {
1581         return _amount.mul(_feeInBips).div(FEE_BASE); 
1582     }
1583 }