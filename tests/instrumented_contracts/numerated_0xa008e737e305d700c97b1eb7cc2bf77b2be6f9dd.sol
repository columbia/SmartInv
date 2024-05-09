1 pragma solidity ^0.6.12;
2 
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b <= a, errorMessage);
58         uint256 c = a - b;
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the multiplication of two unsigned integers, reverting on
65      * overflow.
66      *
67      * Counterpart to Solidity's `*` operator.
68      *
69      * Requirements:
70      * - Multiplication cannot overflow.
71      */
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
74         // benefit is lost if 'b' is also tested.
75         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
76         if (a == 0) {
77             return 0;
78         }
79 
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the integer division of two unsigned integers. Reverts on
88      * division by zero. The result is rounded towards zero.
89      *
90      * Counterpart to Solidity's `/` operator. Note: this function uses a
91      * `revert` opcode (which leaves remaining gas untouched) while Solidity
92      * uses an invalid opcode to revert (consuming all remaining gas).
93      *
94      * Requirements:
95      * - The divisor cannot be zero.
96      */
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         // Solidity only automatically asserts when dividing by 0
114         require(b > 0, errorMessage);
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123      * Reverts when dividing by zero.
124      *
125      * Counterpart to Solidity's `%` operator. This function uses a `revert`
126      * opcode (which leaves remaining gas untouched) while Solidity uses an
127      * invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         return mod(a, b, "SafeMath: modulo by zero");
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts with custom message when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b != 0, errorMessage);
149         return a % b;
150     }
151 }
152 
153 
154 /**
155  * @dev Collection of functions related to the address type
156  */
157 library Address {
158     /**
159      * @dev Returns true if `account` is a contract.
160      *
161      * [IMPORTANT]
162      * ====
163      * It is unsafe to assume that an address for which this function returns
164      * false is an externally-owned account (EOA) and not a contract.
165      *
166      * Among others, `isContract` will return false for the following
167      * types of addresses:
168      *
169      *  - an externally-owned account
170      *  - a contract in construction
171      *  - an address where a contract will be created
172      *  - an address where a contract lived, but was destroyed
173      * ====
174      */
175     function isContract(address account) internal view returns (bool) {
176         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
177         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
178         // for accounts without code, i.e. `keccak256('')`
179         bytes32 codehash;
180         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
181         // solhint-disable-next-line no-inline-assembly
182         assembly { codehash := extcodehash(account) }
183         return (codehash != accountHash && codehash != 0x0);
184     }
185 
186     /**
187      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
188      * `recipient`, forwarding all available gas and reverting on errors.
189      *
190      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
191      * of certain opcodes, possibly making contracts go over the 2300 gas limit
192      * imposed by `transfer`, making them unable to receive funds via
193      * `transfer`. {sendValue} removes this limitation.
194      *
195      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
196      *
197      * IMPORTANT: because control is transferred to `recipient`, care must be
198      * taken to not create reentrancy vulnerabilities. Consider using
199      * {ReentrancyGuard} or the
200      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
201      */
202     function sendValue(address payable recipient, uint256 amount) internal {
203         require(address(this).balance >= amount, "Address: insufficient balance");
204 
205         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
206         (bool success, ) = recipient.call{ value: amount }("");
207         require(success, "Address: unable to send value, recipient may have reverted");
208     }
209 }
210 
211 
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP.
214  */
215 interface IERC20 {
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
273      * another (`to`).
274      *
275      * Note that `value` may be zero.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 value);
278 
279     /**
280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
281      * a call to {approve}. `value` is the new allowance.
282      */
283     event Approval(address indexed owner, address indexed spender, uint256 value);
284 }
285 
286 
287 
288 /**
289  * @title Initializable
290  *
291  * @dev Helper contract to support initializer functions. To use it, replace
292  * the constructor with a function that has the `initializer` modifier.
293  * WARNING: Unlike constructors, initializer functions must be manually
294  * invoked. This applies both to deploying an Initializable contract, as well
295  * as extending an Initializable contract via inheritance.
296  * WARNING: When used with inheritance, manual care must be taken to not invoke
297  * a parent initializer twice, or ensure that all initializers are idempotent,
298  * because this is not dealt with automatically as with constructors.
299  */
300 contract Initializable {
301 
302   /**
303    * @dev Indicates that the contract has been initialized.
304    */
305   bool private initialized;
306 
307   /**
308    * @dev Indicates that the contract is in the process of being initialized.
309    */
310   bool private initializing;
311 
312   /**
313    * @dev Modifier to use in the initializer function of a contract.
314    */
315   modifier initializer() {
316     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
317 
318     bool isTopLevelCall = !initializing;
319     if (isTopLevelCall) {
320       initializing = true;
321       initialized = true;
322     }
323 
324     _;
325 
326     if (isTopLevelCall) {
327       initializing = false;
328     }
329   }
330 
331   /// @dev Returns true if and only if the function is running in the constructor
332   function isConstructor() private view returns (bool) {
333     // extcodesize checks the size of the code stored in an address, and
334     // address returns the current address. Since the code is still not
335     // deployed when running a constructor, any checks on its code size will
336     // yield zero, making it an effective way to detect if a contract is
337     // under construction or not.
338     address self = address(this);
339     uint256 cs;
340     assembly { cs := extcodesize(self) }
341     return cs == 0;
342   }
343 
344   // Reserved storage space to allow for layout changes in the future.
345   uint256[50] private ______gap;
346 }
347 
348 
349 /*
350  * @dev Provides information about the current execution context, including the
351  * sender of the transaction and its data. While these are generally available
352  * via msg.sender and msg.data, they should not be accessed in such a direct
353  * manner, since when dealing with GSN meta-transactions the account sending and
354  * paying for execution may not be the actual sender (as far as an application
355  * is concerned).
356  *
357  * This contract is only required for intermediate, library-like contracts.
358  */
359 contract ContextUpgradeSafe is Initializable {
360     // Empty internal constructor, to prevent people from mistakenly deploying
361     // an instance of this contract, which should be used via inheritance.
362 
363     function __Context_init() internal initializer {
364         __Context_init_unchained();
365     }
366 
367     function __Context_init_unchained() internal initializer {
368 
369 
370     }
371 
372 
373     function _msgSender() internal view virtual returns (address payable) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes memory) {
378         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
379         return msg.data;
380     }
381 
382     uint256[50] private __gap;
383 }
384 
385 
386 
387 /**
388  * @dev Implementation of the {IERC20} interface.
389  *
390  * This implementation is agnostic to the way tokens are created. This means
391  * that a supply mechanism has to be added in a derived contract using {_mint}.
392  * For a generic mechanism see {ERC20MinterPauser}.
393  *
394  * TIP: For a detailed writeup see our guide
395  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
396  * to implement supply mechanisms].
397  *
398  * We have followed general OpenZeppelin guidelines: functions revert instead
399  * of returning `false` on failure. This behavior is nonetheless conventional
400  * and does not conflict with the expectations of ERC20 applications.
401  *
402  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
403  * This allows applications to reconstruct the allowance for all accounts just
404  * by listening to said events. Other implementations of the EIP may not emit
405  * these events, as it isn't required by the specification.
406  *
407  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
408  * functions have been added to mitigate the well-known issues around setting
409  * allowances. See {IERC20-approve}.
410  */
411 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
412     using SafeMath for uint256;
413     using Address for address;
414 
415     mapping (address => uint256) private _balances;
416 
417     mapping (address => mapping (address => uint256)) private _allowances;
418 
419     uint256 private _totalSupply;
420 
421     string private _name;
422     string private _symbol;
423     uint8 private _decimals;
424 
425     /**
426      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
427      * a default value of 18.
428      *
429      * To select a different value for {decimals}, use {_setupDecimals}.
430      *
431      * All three of these values are immutable: they can only be set once during
432      * construction.
433      */
434 
435     function __ERC20_init(string memory name, string memory symbol) internal initializer {
436         __Context_init_unchained();
437         __ERC20_init_unchained(name, symbol);
438     }
439 
440     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
441 
442 
443         _name = name;
444         _symbol = symbol;
445         _decimals = 18;
446 
447     }
448 
449 
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @dev Returns the symbol of the token, usually a shorter version of the
459      * name.
460      */
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     /**
466      * @dev Returns the number of decimals used to get its user representation.
467      * For example, if `decimals` equals `2`, a balance of `505` tokens should
468      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
469      *
470      * Tokens usually opt for a value of 18, imitating the relationship between
471      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
472      * called.
473      *
474      * NOTE: This information is only used for _display_ purposes: it in
475      * no way affects any of the arithmetic of the contract, including
476      * {IERC20-balanceOf} and {IERC20-transfer}.
477      */
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 
482     /**
483      * @dev See {IERC20-totalSupply}.
484      */
485     function totalSupply() public view override returns (uint256) {
486         return _totalSupply;
487     }
488 
489     /**
490      * @dev See {IERC20-balanceOf}.
491      */
492     function balanceOf(address account) public view override returns (uint256) {
493         return _balances[account];
494     }
495 
496     /**
497      * @dev See {IERC20-transfer}.
498      *
499      * Requirements:
500      *
501      * - `recipient` cannot be the zero address.
502      * - the caller must have a balance of at least `amount`.
503      */
504     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-allowance}.
511      */
512     function allowance(address owner, address spender) public view virtual override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     /**
517      * @dev See {IERC20-approve}.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         _approve(_msgSender(), spender, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-transferFrom}.
530      *
531      * Emits an {Approval} event indicating the updated allowance. This is not
532      * required by the EIP. See the note at the beginning of {ERC20};
533      *
534      * Requirements:
535      * - `sender` and `recipient` cannot be the zero address.
536      * - `sender` must have a balance of at least `amount`.
537      * - the caller must have allowance for ``sender``'s tokens of at least
538      * `amount`.
539      */
540     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
541         _transfer(sender, recipient, amount);
542         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
543         return true;
544     }
545 
546     /**
547      * @dev Atomically increases the allowance granted to `spender` by the caller.
548      *
549      * This is an alternative to {approve} that can be used as a mitigation for
550      * problems described in {IERC20-approve}.
551      *
552      * Emits an {Approval} event indicating the updated allowance.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
559         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically decreases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      * - `spender` must have allowance for the caller of at least
575      * `subtractedValue`.
576      */
577     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
579         return true;
580     }
581 
582     /**
583      * @dev Moves tokens `amount` from `sender` to `recipient`.
584      *
585      * This is internal function is equivalent to {transfer}, and can be used to
586      * e.g. implement automatic token fees, slashing mechanisms, etc.
587      *
588      * Emits a {Transfer} event.
589      *
590      * Requirements:
591      *
592      * - `sender` cannot be the zero address.
593      * - `recipient` cannot be the zero address.
594      * - `sender` must have a balance of at least `amount`.
595      */
596     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
597         require(sender != address(0), "ERC20: transfer from the zero address");
598         require(recipient != address(0), "ERC20: transfer to the zero address");
599 
600         _beforeTokenTransfer(sender, recipient, amount);
601 
602         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
603         _balances[recipient] = _balances[recipient].add(amount);
604         emit Transfer(sender, recipient, amount);
605     }
606 
607     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
608      * the total supply.
609      *
610      * Emits a {Transfer} event with `from` set to the zero address.
611      *
612      * Requirements
613      *
614      * - `to` cannot be the zero address.
615      */
616     function _mint(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: mint to the zero address");
618 
619         _beforeTokenTransfer(address(0), account, amount);
620 
621         _totalSupply = _totalSupply.add(amount);
622         _balances[account] = _balances[account].add(amount);
623         emit Transfer(address(0), account, amount);
624     }
625 
626     /**
627      * @dev Destroys `amount` tokens from `account`, reducing the
628      * total supply.
629      *
630      * Emits a {Transfer} event with `to` set to the zero address.
631      *
632      * Requirements
633      *
634      * - `account` cannot be the zero address.
635      * - `account` must have at least `amount` tokens.
636      */
637     function _burn(address account, uint256 amount) internal virtual {
638         require(account != address(0), "ERC20: burn from the zero address");
639 
640         _beforeTokenTransfer(account, address(0), amount);
641 
642         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
643         _totalSupply = _totalSupply.sub(amount);
644         emit Transfer(account, address(0), amount);
645     }
646 
647     /**
648      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
649      *
650      * This is internal function is equivalent to `approve`, and can be used to
651      * e.g. set automatic allowances for certain subsystems, etc.
652      *
653      * Emits an {Approval} event.
654      *
655      * Requirements:
656      *
657      * - `owner` cannot be the zero address.
658      * - `spender` cannot be the zero address.
659      */
660     function _approve(address owner, address spender, uint256 amount) internal virtual {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     /**
669      * @dev Sets {decimals} to a value other than the default one of 18.
670      *
671      * WARNING: This function should only be called from the constructor. Most
672      * applications that interact with token contracts will not expect
673      * {decimals} to ever change, and may work incorrectly if it does.
674      */
675     function _setupDecimals(uint8 decimals_) internal {
676         _decimals = decimals_;
677     }
678 
679     /**
680      * @dev Hook that is called before any transfer of tokens. This includes
681      * minting and burning.
682      *
683      * Calling conditions:
684      *
685      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
686      * will be to transferred to `to`.
687      * - when `from` is zero, `amount` tokens will be minted for `to`.
688      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
689      * - `from` and `to` are never both zero.
690      *
691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
692      */
693     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
694 
695     uint256[44] private __gap;
696 }
697 
698 
699 contract Scammet is Initializable, ERC20UpgradeSafe {
700 
701     function initialize(string memory name, string memory symbol) public initializer {
702     	__ERC20_init(name, symbol);
703     	uint totalSupply = 1000000 * (10 ** 18);
704     	_mint(_msgSender(), totalSupply);
705     }
706 }