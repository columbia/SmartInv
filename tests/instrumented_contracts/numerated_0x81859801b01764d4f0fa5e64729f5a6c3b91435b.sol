1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         address msgSender = _msgSender();
48         _owner = msgSender;
49         emit OwnershipTransferred(address(0), msgSender);
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(_owner == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     /**
80      * @dev Transfers ownership of the contract to a new account (`newOwner`).
81      * Can only be called by the current owner.
82      */
83     function transferOwnership(address newOwner) public virtual onlyOwner {
84         require(newOwner != address(0), "Ownable: new owner is the zero address");
85         emit OwnershipTransferred(_owner, newOwner);
86         _owner = newOwner;
87     }
88 }
89 
90 /**
91  * @title Initializable
92  *
93  * @dev Helper contract to support initializer functions. To use it, replace
94  * the constructor with a function that has the `initializer` modifier.
95  * WARNING: Unlike constructors, initializer functions must be manually
96  * invoked. This applies both to deploying an Initializable contract, as well
97  * as extending an Initializable contract via inheritance.
98  * WARNING: When used with inheritance, manual care must be taken to not invoke
99  * a parent initializer twice, or ensure that all initializers are idempotent,
100  * because this is not dealt with automatically as with constructors.
101  */
102 contract Initializable {
103 
104   /**
105    * @dev Indicates that the contract has been initialized.
106    */
107   bool private initialized;
108 
109   /**
110    * @dev Indicates that the contract is in the process of being initialized.
111    */
112   bool private initializing;
113 
114   /**
115    * @dev Modifier to use in the initializer function of a contract.
116    */
117   modifier initializer() {
118     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
119 
120     bool isTopLevelCall = !initializing;
121     if (isTopLevelCall) {
122       initializing = true;
123       initialized = true;
124     }
125 
126     _;
127 
128     if (isTopLevelCall) {
129       initializing = false;
130     }
131   }
132 
133   /// @dev Returns true if and only if the function is running in the constructor
134   function isConstructor() private view returns (bool) {
135     // extcodesize checks the size of the code stored in an address, and
136     // address returns the current address. Since the code is still not
137     // deployed when running a constructor, any checks on its code size will
138     // yield zero, making it an effective way to detect if a contract is
139     // under construction or not.
140     address self = address(this);
141     uint256 cs;
142     assembly { cs := extcodesize(self) }
143     return cs == 0;
144   }
145 
146   // Reserved storage space to allow for layout changes in the future.
147   uint256[50] private ______gap;
148 }
149 
150 /*
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with GSN meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 contract ContextUpgradeSafe is Initializable {
161     // Empty internal constructor, to prevent people from mistakenly deploying
162     // an instance of this contract, which should be used via inheritance.
163 
164     function __Context_init() internal initializer {
165         __Context_init_unchained();
166     }
167 
168     function __Context_init_unchained() internal initializer {
169 
170 
171     }
172 
173 
174     function _msgSender() internal view virtual returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 
183     uint256[50] private __gap;
184 }
185 
186 /**
187  * @dev Interface of the ERC20 standard as defined in the EIP.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through {transferFrom}. This is
212      * zero by default.
213      *
214      * This value changes when {approve} or {transferFrom} are called.
215      */
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to {approve}. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 /**
261  * @dev Wrappers over Solidity's arithmetic operations with added overflow
262  * checks.
263  *
264  * Arithmetic operations in Solidity wrap on overflow. This can easily result
265  * in bugs, because programmers usually assume that an overflow raises an
266  * error, which is the standard behavior in high level programming languages.
267  * `SafeMath` restores this intuition by reverting the transaction when an
268  * operation overflows.
269  *
270  * Using this library instead of the unchecked operations eliminates an entire
271  * class of bugs, so it's recommended to use it always.
272  */
273 library SafeMath {
274     /**
275      * @dev Returns the addition of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `+` operator.
279      *
280      * Requirements:
281      * - Addition cannot overflow.
282      */
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         uint256 c = a + b;
285         require(c >= a, "SafeMath: addition overflow");
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      * - Subtraction cannot overflow.
298      */
299     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
300         return sub(a, b, "SafeMath: subtraction overflow");
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      * - Subtraction cannot overflow.
311      */
312     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b <= a, errorMessage);
314         uint256 c = a - b;
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the multiplication of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `*` operator.
324      *
325      * Requirements:
326      * - Multiplication cannot overflow.
327      */
328     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
329         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
330         // benefit is lost if 'b' is also tested.
331         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
332         if (a == 0) {
333             return 0;
334         }
335 
336         uint256 c = a * b;
337         require(c / a == b, "SafeMath: multiplication overflow");
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the integer division of two unsigned integers. Reverts on
344      * division by zero. The result is rounded towards zero.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         return div(a, b, "SafeMath: division by zero");
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator. Note: this function uses a
362      * `revert` opcode (which leaves remaining gas untouched) while Solidity
363      * uses an invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      * - The divisor cannot be zero.
367      */
368     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         // Solidity only automatically asserts when dividing by 0
370         require(b > 0, errorMessage);
371         uint256 c = a / b;
372         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
379      * Reverts when dividing by zero.
380      *
381      * Counterpart to Solidity's `%` operator. This function uses a `revert`
382      * opcode (which leaves remaining gas untouched) while Solidity uses an
383      * invalid opcode to revert (consuming all remaining gas).
384      *
385      * Requirements:
386      * - The divisor cannot be zero.
387      */
388     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
389         return mod(a, b, "SafeMath: modulo by zero");
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394      * Reverts with custom message when dividing by zero.
395      *
396      * Counterpart to Solidity's `%` operator. This function uses a `revert`
397      * opcode (which leaves remaining gas untouched) while Solidity uses an
398      * invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      * - The divisor cannot be zero.
402      */
403     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
404         require(b != 0, errorMessage);
405         return a % b;
406     }
407 }
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
432         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
433         // for accounts without code, i.e. `keccak256('')`
434         bytes32 codehash;
435         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
436         // solhint-disable-next-line no-inline-assembly
437         assembly { codehash := extcodehash(account) }
438         return (codehash != accountHash && codehash != 0x0);
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
461         (bool success, ) = recipient.call{ value: amount }("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 }
465 
466 /**
467  * @dev Implementation of the {IERC20} interface.
468  *
469  * This implementation is agnostic to the way tokens are created. This means
470  * that a supply mechanism has to be added in a derived contract using {_mint}.
471  * For a generic mechanism see {ERC20MinterPauser}.
472  *
473  * TIP: For a detailed writeup see our guide
474  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
475  * to implement supply mechanisms].
476  *
477  * We have followed general OpenZeppelin guidelines: functions revert instead
478  * of returning `false` on failure. This behavior is nonetheless conventional
479  * and does not conflict with the expectations of ERC20 applications.
480  *
481  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
482  * This allows applications to reconstruct the allowance for all accounts just
483  * by listening to said events. Other implementations of the EIP may not emit
484  * these events, as it isn't required by the specification.
485  *
486  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
487  * functions have been added to mitigate the well-known issues around setting
488  * allowances. See {IERC20-approve}.
489  */
490 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
491     using SafeMath for uint256;
492     using Address for address;
493 
494     mapping (address => uint256) private _balances;
495 
496     mapping (address => mapping (address => uint256)) private _allowances;
497 
498     uint256 private _totalSupply;
499 
500     string private _name;
501     string private _symbol;
502     uint8 private _decimals;
503 
504     /**
505      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
506      * a default value of 18.
507      *
508      * To select a different value for {decimals}, use {_setupDecimals}.
509      *
510      * All three of these values are immutable: they can only be set once during
511      * construction.
512      */
513 
514     function __ERC20_init(string memory name, string memory symbol) internal initializer {
515         __Context_init_unchained();
516         __ERC20_init_unchained(name, symbol);
517     }
518 
519     function __ERC20_init_unchained(string memory name, string memory symbol) internal initializer {
520 
521 
522         _name = name;
523         _symbol = symbol;
524         _decimals = 18;
525 
526     }
527 
528 
529     /**
530      * @dev Returns the name of the token.
531      */
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     /**
537      * @dev Returns the symbol of the token, usually a shorter version of the
538      * name.
539      */
540     function symbol() public view returns (string memory) {
541         return _symbol;
542     }
543 
544     /**
545      * @dev Returns the number of decimals used to get its user representation.
546      * For example, if `decimals` equals `2`, a balance of `505` tokens should
547      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
548      *
549      * Tokens usually opt for a value of 18, imitating the relationship between
550      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
551      * called.
552      *
553      * NOTE: This information is only used for _display_ purposes: it in
554      * no way affects any of the arithmetic of the contract, including
555      * {IERC20-balanceOf} and {IERC20-transfer}.
556      */
557     function decimals() public view returns (uint8) {
558         return _decimals;
559     }
560 
561     /**
562      * @dev See {IERC20-totalSupply}.
563      */
564     function totalSupply() public view override returns (uint256) {
565         return _totalSupply;
566     }
567 
568     /**
569      * @dev See {IERC20-balanceOf}.
570      */
571     function balanceOf(address account) public view override returns (uint256) {
572         return _balances[account];
573     }
574 
575     /**
576      * @dev See {IERC20-transfer}.
577      *
578      * Requirements:
579      *
580      * - `recipient` cannot be the zero address.
581      * - the caller must have a balance of at least `amount`.
582      */
583     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
584         _transfer(_msgSender(), recipient, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-allowance}.
590      */
591     function allowance(address owner, address spender) public view virtual override returns (uint256) {
592         return _allowances[owner][spender];
593     }
594 
595     /**
596      * @dev See {IERC20-approve}.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function approve(address spender, uint256 amount) public virtual override returns (bool) {
603         _approve(_msgSender(), spender, amount);
604         return true;
605     }
606 
607     /**
608      * @dev See {IERC20-transferFrom}.
609      *
610      * Emits an {Approval} event indicating the updated allowance. This is not
611      * required by the EIP. See the note at the beginning of {ERC20};
612      *
613      * Requirements:
614      * - `sender` and `recipient` cannot be the zero address.
615      * - `sender` must have a balance of at least `amount`.
616      * - the caller must have allowance for ``sender``'s tokens of at least
617      * `amount`.
618      */
619     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
620         _transfer(sender, recipient, amount);
621         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
622         return true;
623     }
624 
625     /**
626      * @dev Atomically increases the allowance granted to `spender` by the caller.
627      *
628      * This is an alternative to {approve} that can be used as a mitigation for
629      * problems described in {IERC20-approve}.
630      *
631      * Emits an {Approval} event indicating the updated allowance.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      */
637     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
638         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
639         return true;
640     }
641 
642     /**
643      * @dev Atomically decreases the allowance granted to `spender` by the caller.
644      *
645      * This is an alternative to {approve} that can be used as a mitigation for
646      * problems described in {IERC20-approve}.
647      *
648      * Emits an {Approval} event indicating the updated allowance.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      * - `spender` must have allowance for the caller of at least
654      * `subtractedValue`.
655      */
656     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
657         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
658         return true;
659     }
660 
661     /**
662      * @dev Moves tokens `amount` from `sender` to `recipient`.
663      *
664      * This is internal function is equivalent to {transfer}, and can be used to
665      * e.g. implement automatic token fees, slashing mechanisms, etc.
666      *
667      * Emits a {Transfer} event.
668      *
669      * Requirements:
670      *
671      * - `sender` cannot be the zero address.
672      * - `recipient` cannot be the zero address.
673      * - `sender` must have a balance of at least `amount`.
674      */
675     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
676         require(sender != address(0), "ERC20: transfer from the zero address");
677         require(recipient != address(0), "ERC20: transfer to the zero address");
678 
679         _beforeTokenTransfer(sender, recipient, amount);
680 
681         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
682         _balances[recipient] = _balances[recipient].add(amount);
683         emit Transfer(sender, recipient, amount);
684     }
685 
686     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
687      * the total supply.
688      *
689      * Emits a {Transfer} event with `from` set to the zero address.
690      *
691      * Requirements
692      *
693      * - `to` cannot be the zero address.
694      */
695     function _mint(address account, uint256 amount) internal virtual {
696         require(account != address(0), "ERC20: mint to the zero address");
697 
698         _beforeTokenTransfer(address(0), account, amount);
699 
700         _totalSupply = _totalSupply.add(amount);
701         _balances[account] = _balances[account].add(amount);
702         emit Transfer(address(0), account, amount);
703     }
704 
705     /**
706      * @dev Destroys `amount` tokens from `account`, reducing the
707      * total supply.
708      *
709      * Emits a {Transfer} event with `to` set to the zero address.
710      *
711      * Requirements
712      *
713      * - `account` cannot be the zero address.
714      * - `account` must have at least `amount` tokens.
715      */
716     function _burn(address account, uint256 amount) internal virtual {
717         require(account != address(0), "ERC20: burn from the zero address");
718 
719         _beforeTokenTransfer(account, address(0), amount);
720 
721         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
722         _totalSupply = _totalSupply.sub(amount);
723         emit Transfer(account, address(0), amount);
724     }
725 
726     /**
727      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
728      *
729      * This is internal function is equivalent to `approve`, and can be used to
730      * e.g. set automatic allowances for certain subsystems, etc.
731      *
732      * Emits an {Approval} event.
733      *
734      * Requirements:
735      *
736      * - `owner` cannot be the zero address.
737      * - `spender` cannot be the zero address.
738      */
739     function _approve(address owner, address spender, uint256 amount) internal virtual {
740         require(owner != address(0), "ERC20: approve from the zero address");
741         require(spender != address(0), "ERC20: approve to the zero address");
742 
743         _allowances[owner][spender] = amount;
744         emit Approval(owner, spender, amount);
745     }
746 
747     /**
748      * @dev Sets {decimals} to a value other than the default one of 18.
749      *
750      * WARNING: This function should only be called from the constructor. Most
751      * applications that interact with token contracts will not expect
752      * {decimals} to ever change, and may work incorrectly if it does.
753      */
754     function _setupDecimals(uint8 decimals_) internal {
755         _decimals = decimals_;
756     }
757 
758     /**
759      * @dev Hook that is called before any transfer of tokens. This includes
760      * minting and burning.
761      *
762      * Calling conditions:
763      *
764      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
765      * will be to transferred to `to`.
766      * - when `from` is zero, `amount` tokens will be minted for `to`.
767      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
768      * - `from` and `to` are never both zero.
769      *
770      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
771      */
772     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
773 
774     uint256[44] private __gap;
775 }
776 
777 contract ERC20WithPermit is Initializable, ERC20UpgradeSafe {
778     using SafeMath for uint;
779 
780     mapping(address => uint) public nonces;
781 
782     // If the token is redeployed, the version is increased to prevent a permit
783     // signature being used on both token instances.
784     string public version;
785 
786     // --- EIP712 niceties ---
787     bytes32 public DOMAIN_SEPARATOR;
788     // PERMIT_TYPEHASH is the value returned from
789     // keccak256("Permit(address holder,address spender,uint nonce,uint expiry,bool allowed)")
790     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
791 
792     function initialize(
793         uint _chainId,
794         string memory _version,
795         string memory _name,
796         string memory _symbol,
797         uint8 _decimals
798     ) public initializer {
799         __ERC20_init(_name, _symbol);
800         _setupDecimals(_decimals);
801         version = _version;
802         DOMAIN_SEPARATOR = keccak256(
803             abi.encode(
804                 keccak256(
805                     "EIP712Domain(string name,string version,uint chainId,address verifyingContract)"
806                 ),
807                 keccak256(bytes(name())),
808                 keccak256(bytes(version)),
809                 _chainId,
810                 address(this)
811             )
812         );
813     }
814 
815     // --- Approve by signature ---
816     function permit(
817         address holder,
818         address spender,
819         uint nonce,
820         uint expiry,
821         bool allowed,
822         uint8 v,
823         bytes32 r,
824         bytes32 s
825     ) external {
826         bytes32 digest = keccak256(
827             abi.encodePacked(
828                 "\x19\x01",
829                 DOMAIN_SEPARATOR,
830                 keccak256(
831                     abi.encode(
832                         PERMIT_TYPEHASH,
833                         holder,
834                         spender,
835                         nonce,
836                         expiry,
837                         allowed
838                     )
839                 )
840             )
841         );
842 
843         require(holder != address(0), "ERC20WithRate: address must not be 0x0");
844         require(
845             holder == ecrecover(digest, v, r, s),
846             "ERC20WithRate: invalid signature"
847         );
848         require(
849             expiry == 0 || now <= expiry,
850             "ERC20WithRate: permit has expired"
851         );
852         require(nonce == nonces[holder]++, "ERC20WithRate: invalid nonce");
853         uint amount = allowed ? uint(-1) : 0;
854         _approve(holder, spender, amount);
855     }
856 }
857 
858 /**
859  * @title SafeERC20
860  * @dev Wrappers around ERC20 operations that throw on failure (when the token
861  * contract returns false). Tokens that return no value (and instead revert or
862  * throw on failure) are also supported, non-reverting calls are assumed to be
863  * successful.
864  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
865  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
866  */
867 library SafeERC20 {
868     using SafeMath for uint256;
869     using Address for address;
870 
871     function safeTransfer(IERC20 token, address to, uint256 value) internal {
872         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
873     }
874 
875     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
876         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
877     }
878 
879     function safeApprove(IERC20 token, address spender, uint256 value) internal {
880         // safeApprove should only be called when setting an initial allowance,
881         // or when resetting it to zero. To increase and decrease it, use
882         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
883         // solhint-disable-next-line max-line-length
884         require((value == 0) || (token.allowance(address(this), spender) == 0),
885             "SafeERC20: approve from non-zero to non-zero allowance"
886         );
887         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
888     }
889 
890     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
891         uint256 newAllowance = token.allowance(address(this), spender).add(value);
892         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
893     }
894 
895     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
896         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
897         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
898     }
899 
900     /**
901      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
902      * on the return value: the return value is optional (but if data is returned, it must not be false).
903      * @param token The token targeted by the call.
904      * @param data The call data (encoded using abi.encode or one of its variants).
905      */
906     function _callOptionalReturn(IERC20 token, bytes memory data) private {
907         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
908         // we're implementing it ourselves.
909 
910         // A Solidity high level call has three parts:
911         //  1. The target address is checked to verify it contains contract code
912         //  2. The call itself is made, and success asserted
913         //  3. The return value is decoded, which in turn checks the size of the returned data.
914         // solhint-disable-next-line max-line-length
915         require(address(token).isContract(), "SafeERC20: call to non-contract");
916 
917         // solhint-disable-next-line avoid-low-level-calls
918         (bool success, bytes memory returndata) = address(token).call(data);
919         require(success, "SafeERC20: low-level call failed");
920 
921         if (returndata.length > 0) { // Return data is optional
922             // solhint-disable-next-line max-line-length
923             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
924         }
925     }
926 }
927 
928 /**
929  * @title Claimable
930  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
931  * This allows the new owner to accept the transfer.
932  */
933 contract Claimable is Initializable {
934     address private _owner;
935     address public pendingOwner;
936 
937     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
938 
939     function initialize(address _nextOwner) public virtual initializer {
940         _owner = _nextOwner;
941     }
942 
943     /**
944      * @dev Returns the address of the current owner.
945      */
946     function owner() public view returns (address) {
947         return _owner;
948     }
949 
950     /**
951      * @dev Throws if called by any account other than the owner.
952      */
953     modifier onlyOwner() {
954         require(_owner == msg.sender, "Ownable: caller is not the owner");
955         _;
956     }
957 
958     modifier onlyPendingOwner() {
959         require(
960             msg.sender == pendingOwner,
961             "Claimable: caller is not the pending owner"
962         );
963         _;
964     }
965 
966     /**
967      * @dev Transfers ownership of the contract to a new account (`newOwner`).
968      * Can only be called by the current owner.
969      */
970     function transferOwnership(address newOwner) public onlyOwner {
971         require(
972             newOwner != pendingOwner,
973             "Claimable: invalid new owner"
974         );
975         pendingOwner = newOwner;
976     }
977 
978     /**
979      * @dev Transfers ownership of the contract to a new account (`newOwner`).
980      * Can only be called by the current owner.
981      */
982     function _transferOwnership(address newOwner) internal {
983         emit OwnershipTransferred(_owner, newOwner);
984         _owner = newOwner;
985     }
986 
987     function claimOwnership() public onlyPendingOwner {
988         _transferOwnership(pendingOwner);
989         delete pendingOwner;
990     }
991 }
992 
993 contract CanReclaimTokens is Claimable {
994     using SafeERC20 for ERC20UpgradeSafe;
995 
996     mapping(address => bool) private recoverableTokensBlacklist;
997 
998     function initialize(address _nextOwner) public override initializer {
999         Claimable.initialize(_nextOwner);
1000     }
1001 
1002     function blacklistRecoverableToken(address _token) public onlyOwner {
1003         recoverableTokensBlacklist[_token] = true;
1004     }
1005 
1006     /// @notice Allow the owner of the contract to recover funds accidentally
1007     /// sent to the contract. To withdraw ETH, the token should be set to `0x0`.
1008     function recoverTokens(address _token) external onlyOwner {
1009         require(
1010             !recoverableTokensBlacklist[_token],
1011             "CanReclaimTokens: token is not recoverable"
1012         );
1013 
1014         if (_token == address(0x0)) {
1015             msg.sender.transfer(address(this).balance);
1016         } else {
1017             ERC20UpgradeSafe(_token).safeTransfer(
1018                 msg.sender, ERC20UpgradeSafe(_token).balanceOf(address(this))
1019             );
1020         }
1021     }
1022 }
1023 
1024 /**
1025  * @dev Wrapped BFI on Ethereum
1026  *
1027  * Read more about its tokenomic here: https://bearn-defi.medium.com/bearn-fi-introduction-9e65f6395dfc
1028  *
1029  * Total 12,500 BFI issued (minted) on Ethereum:
1030  * - 500 BFIE for initial supply (Uniswap and Value Liquid)
1031  * - 3000 BFIE for UNIv2 BFIE-ETH (50/50) mining incentive (4 months)
1032  * - 7000 BFIE for ValueLiquid VLP BFIE-VALUE (70/30) mining incentive (18 months)
1033  * - 2000 BFIE reserve for public mint (from BFI Bsc)
1034  */
1035 contract BearnTokenERC20 is
1036     ERC20WithPermit,
1037     CanReclaimTokens {
1038 
1039     uint public cap = 12500 ether;
1040 
1041     function initialize(
1042         uint _chainId,
1043         address _nextOwner,
1044         string memory _version,
1045         string memory _name,
1046         string memory _symbol,
1047         uint8 _decimals
1048     ) public initializer {
1049         __ERC20_init(_name, _symbol);
1050         _setupDecimals(_decimals);
1051         ERC20WithPermit.initialize(
1052             _chainId,
1053             _version,
1054             _name,
1055             _symbol,
1056             _decimals
1057         );
1058         CanReclaimTokens.initialize(_nextOwner);
1059         _mint(msg.sender, cap.sub(2000 ether)); // first mint to setup liquidity
1060     }
1061 
1062     // Can be called by only Gateway
1063     function mint(address _to, uint _amount) external onlyOwner {
1064         _mint(_to, _amount);
1065     }
1066 
1067     // Can be called by only Gateway
1068     function burn(uint _amount) external onlyOwner {
1069         _burn(msg.sender, _amount);
1070     }
1071 
1072     function transfer(address recipient, uint amount) public override returns (bool) {
1073         require(
1074             recipient != address(this),
1075             "BEARN ERC20UpgradeSafe: can't transfer to token address"
1076         );
1077         return super.transfer(recipient, amount);
1078     }
1079 
1080     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
1081         require(
1082             recipient != address(this),
1083             "BEARN ERC20UpgradeSafe: can't transfer to stoken address"
1084         );
1085         return super.transferFrom(sender, recipient, amount);
1086     }
1087 
1088     /**
1089      * @dev See {ERC20-_beforeTokenTransfer}.
1090      *
1091      * Requirements:
1092      *
1093      * - minted tokens must not cause the total supply to go over the cap.
1094      */
1095     function _beforeTokenTransfer(address from, address to, uint amount) internal virtual override {
1096         super._beforeTokenTransfer(from, to, amount);
1097 
1098         if (from == address(0)) { // When minting tokens
1099             require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
1100         }
1101     }
1102 }