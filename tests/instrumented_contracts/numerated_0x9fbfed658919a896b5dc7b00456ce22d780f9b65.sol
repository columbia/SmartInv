1 // File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.7.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     address self = address(this);
57     uint256 cs;
58     assembly { cs := extcodesize(self) }
59     return cs == 0;
60   }
61 
62   // Reserved storage space to allow for layout changes in the future.
63   uint256[50] private ______gap;
64 }
65 
66 // File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol
67 
68 pragma solidity ^0.6.0;
69 
70 
71 /*
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with GSN meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 contract ContextUpgradeSafe is Initializable {
82     // Empty internal constructor, to prevent people from mistakenly deploying
83     // an instance of this contract, which should be used via inheritance.
84 
85     function __Context_init() internal initializer {
86         __Context_init_unchained();
87     }
88 
89     function __Context_init_unchained() internal initializer {
90 
91 
92     }
93 
94 
95     function _msgSender() internal view virtual returns (address payable) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
101         return msg.data;
102     }
103 
104     uint256[50] private __gap;
105 }
106 
107 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol
108 
109 pragma solidity ^0.6.0;
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
186 
187 pragma solidity ^0.6.0;
188 
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `+` operator.
208      *
209      * Requirements:
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      */
241     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b <= a, errorMessage);
243         uint256 c = a - b;
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the multiplication of two unsigned integers, reverting on
250      * overflow.
251      *
252      * Counterpart to Solidity's `*` operator.
253      *
254      * Requirements:
255      * - Multiplication cannot overflow.
256      */
257     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259         // benefit is lost if 'b' is also tested.
260         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261         if (a == 0) {
262             return 0;
263         }
264 
265         uint256 c = a * b;
266         require(c / a == b, "SafeMath: multiplication overflow");
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         // Solidity only automatically asserts when dividing by 0
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return mod(a, b, "SafeMath: modulo by zero");
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts with custom message when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b != 0, errorMessage);
334         return a % b;
335     }
336 }
337 
338 // File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol
339 
340 pragma solidity ^0.6.2;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
365         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
366         // for accounts without code, i.e. `keccak256('')`
367         bytes32 codehash;
368         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
369         // solhint-disable-next-line no-inline-assembly
370         assembly { codehash := extcodehash(account) }
371         return (codehash != accountHash && codehash != 0x0);
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
394         (bool success, ) = recipient.call{ value: amount }("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 }
398 
399 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20.sol
400 
401 pragma solidity ^0.6.0;
402 
403 
404 
405 
406 
407 
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20MinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin guidelines: functions revert instead
420  * of returning `false` on failure. This behavior is nonetheless conventional
421  * and does not conflict with the expectations of ERC20 applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     mapping (address => uint256) private _balances;
437 
438     mapping (address => mapping (address => uint256)) private _allowances;
439 
440     uint256 private _totalSupply;
441 
442     string private _name;
443     string private _symbol;
444     uint8 private _decimals;
445 
446     /**
447      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
448      * a default value of 18.
449      *
450      * To select a different value for {decimals}, use {_setupDecimals}.
451      *
452      * All three of these values are immutable: they can only be set once during
453      * construction.
454      */
455 
456     function __ERC20_init(string memory name, string memory symbol) internal initializer {
457         __Context_init_unchained();
458         __ERC20_init_unchained(name, symbol);
459     }
460 
461     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
462 
463 
464         _name = name;
465         _symbol = symbol;
466         _decimals = 18;
467 
468     }
469 
470 
471     /**
472      * @dev Returns the name of the token.
473      */
474     function name() public view returns (string memory) {
475         return _name;
476     }
477 
478     /**
479      * @dev Returns the symbol of the token, usually a shorter version of the
480      * name.
481      */
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     /**
487      * @dev Returns the number of decimals used to get its user representation.
488      * For example, if `decimals` equals `2`, a balance of `505` tokens should
489      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
490      *
491      * Tokens usually opt for a value of 18, imitating the relationship between
492      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
493      * called.
494      *
495      * NOTE: This information is only used for _display_ purposes: it in
496      * no way affects any of the arithmetic of the contract, including
497      * {IERC20-balanceOf} and {IERC20-transfer}.
498      */
499     function decimals() public view returns (uint8) {
500         return _decimals;
501     }
502 
503     /**
504      * @dev See {IERC20-totalSupply}.
505      */
506     function totalSupply() public view override returns (uint256) {
507         return _totalSupply;
508     }
509 
510     /**
511      * @dev See {IERC20-balanceOf}.
512      */
513     function balanceOf(address account) public view override returns (uint256) {
514         return _balances[account];
515     }
516 
517     /**
518      * @dev See {IERC20-transfer}.
519      *
520      * Requirements:
521      *
522      * - `recipient` cannot be the zero address.
523      * - the caller must have a balance of at least `amount`.
524      */
525     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
526         _transfer(_msgSender(), recipient, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-allowance}.
532      */
533     function allowance(address owner, address spender) public view virtual override returns (uint256) {
534         return _allowances[owner][spender];
535     }
536 
537     /**
538      * @dev See {IERC20-approve}.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      */
544     function approve(address spender, uint256 amount) public virtual override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     /**
550      * @dev See {IERC20-transferFrom}.
551      *
552      * Emits an {Approval} event indicating the updated allowance. This is not
553      * required by the EIP. See the note at the beginning of {ERC20};
554      *
555      * Requirements:
556      * - `sender` and `recipient` cannot be the zero address.
557      * - `sender` must have a balance of at least `amount`.
558      * - the caller must have allowance for ``sender``'s tokens of at least
559      * `amount`.
560      */
561     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically increases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
581         return true;
582     }
583 
584     /**
585      * @dev Atomically decreases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      * - `spender` must have allowance for the caller of at least
596      * `subtractedValue`.
597      */
598     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
599         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
600         return true;
601     }
602 
603     /**
604      * @dev Moves tokens `amount` from `sender` to `recipient`.
605      *
606      * This is internal function is equivalent to {transfer}, and can be used to
607      * e.g. implement automatic token fees, slashing mechanisms, etc.
608      *
609      * Emits a {Transfer} event.
610      *
611      * Requirements:
612      *
613      * - `sender` cannot be the zero address.
614      * - `recipient` cannot be the zero address.
615      * - `sender` must have a balance of at least `amount`.
616      */
617     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
618         require(sender != address(0), "ERC20: transfer from the zero address");
619         require(recipient != address(0), "ERC20: transfer to the zero address");
620 
621         _beforeTokenTransfer(sender, recipient, amount);
622 
623         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
624         _balances[recipient] = _balances[recipient].add(amount);
625         emit Transfer(sender, recipient, amount);
626     }
627 
628     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
629      * the total supply.
630      *
631      * Emits a {Transfer} event with `from` set to the zero address.
632      *
633      * Requirements
634      *
635      * - `to` cannot be the zero address.
636      */
637     function _mint(address account, uint256 amount) internal virtual {
638         require(account != address(0), "ERC20: mint to the zero address");
639 
640         _beforeTokenTransfer(address(0), account, amount);
641 
642         _totalSupply = _totalSupply.add(amount);
643         _balances[account] = _balances[account].add(amount);
644         emit Transfer(address(0), account, amount);
645     }
646 
647     /**
648      * @dev Destroys `amount` tokens from `account`, reducing the
649      * total supply.
650      *
651      * Emits a {Transfer} event with `to` set to the zero address.
652      *
653      * Requirements
654      *
655      * - `account` cannot be the zero address.
656      * - `account` must have at least `amount` tokens.
657      */
658     function _burn(address account, uint256 amount) internal virtual {
659         require(account != address(0), "ERC20: burn from the zero address");
660 
661         _beforeTokenTransfer(account, address(0), amount);
662 
663         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
664         _totalSupply = _totalSupply.sub(amount);
665         emit Transfer(account, address(0), amount);
666     }
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
670      *
671      * This is internal function is equivalent to `approve`, and can be used to
672      * e.g. set automatic allowances for certain subsystems, etc.
673      *
674      * Emits an {Approval} event.
675      *
676      * Requirements:
677      *
678      * - `owner` cannot be the zero address.
679      * - `spender` cannot be the zero address.
680      */
681     function _approve(address owner, address spender, uint256 amount) internal virtual {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     /**
690      * @dev Sets {decimals} to a value other than the default one of 18.
691      *
692      * WARNING: This function should only be called from the constructor. Most
693      * applications that interact with token contracts will not expect
694      * {decimals} to ever change, and may work incorrectly if it does.
695      */
696     function _setupDecimals(uint8 decimals_) internal {
697         _decimals = decimals_;
698     }
699 
700     /**
701      * @dev Hook that is called before any transfer of tokens. This includes
702      * minting and burning.
703      *
704      * Calling conditions:
705      *
706      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
707      * will be to transferred to `to`.
708      * - when `from` is zero, `amount` tokens will be minted for `to`.
709      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
710      * - `from` and `to` are never both zero.
711      *
712      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
713      */
714     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
715 
716     uint256[44] private __gap;
717 }
718 
719 // File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/ERC20Burnable.sol
720 
721 pragma solidity ^0.6.0;
722 
723 
724 
725 
726 /**
727  * @dev Extension of {ERC20} that allows token holders to destroy both their own
728  * tokens and those that they have an allowance for, in a way that can be
729  * recognized off-chain (via event analysis).
730  */
731 abstract contract ERC20BurnableUpgradeSafe is Initializable, ContextUpgradeSafe, ERC20UpgradeSafe {
732     function __ERC20Burnable_init() internal initializer {
733         __Context_init_unchained();
734         __ERC20Burnable_init_unchained();
735     }
736 
737     function __ERC20Burnable_init_unchained() internal initializer {
738 
739 
740     }
741 
742     /**
743      * @dev Destroys `amount` tokens from the caller.
744      *
745      * See {ERC20-_burn}.
746      */
747     function burn(uint256 amount) public virtual {
748         _burn(_msgSender(), amount);
749     }
750 
751     /**
752      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
753      * allowance.
754      *
755      * See {ERC20-_burn} and {ERC20-allowance}.
756      *
757      * Requirements:
758      *
759      * - the caller must have allowance for ``accounts``'s tokens of at least
760      * `amount`.
761      */
762     function burnFrom(address account, uint256 amount) public virtual {
763         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
764 
765         _approve(account, _msgSender(), decreasedAllowance);
766         _burn(account, amount);
767     }
768 
769     uint256[50] private __gap;
770 }
771 
772 // File: contracts/Plutus.sol
773 
774 pragma solidity ^0.6.0;
775 
776 contract Plutus is ERC20BurnableUpgradeSafe {
777 
778     address public bondedContract;
779     address public unbondedContract;
780 
781     constructor(
782         string memory name,
783         string memory symbol,
784         address _bondedContract,
785         address _unbondedContract
786     )
787         public
788     {
789         __ERC20_init(name, symbol);
790 
791         bondedContract = _bondedContract;
792         unbondedContract = _unbondedContract;
793 
794         _mint(
795             bondedContract, 98000000 * uint256(10)**decimals()
796         ); // 98,000,000.00
797         _mint(
798             unbondedContract, 22000000 * uint256(10)**decimals()
799         ); // 22,000,000.00
800     }
801 }