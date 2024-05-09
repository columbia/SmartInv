1 pragma solidity =0.6.6;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
110      * Reverts when dividing by zero.
111      *
112      * Counterpart to Solidity's `%` operator. This function uses a `revert`
113      * opcode (which leaves remaining gas untouched) while Solidity uses an
114      * invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         return mod(a, b, "SafeMath: modulo by zero");
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts with custom message when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 
140 /**
141  * @title Initializable
142  *
143  * @dev Helper contract to support initializer functions. To use it, replace
144  * the constructor with a function that has the `initializer` modifier.
145  * WARNING: Unlike constructors, initializer functions must be manually
146  * invoked. This applies both to deploying an Initializable contract, as well
147  * as extending an Initializable contract via inheritance.
148  * WARNING: When used with inheritance, manual care must be taken to not invoke
149  * a parent initializer twice, or ensure that all initializers are idempotent,
150  * because this is not dealt with automatically as with constructors.
151  */
152 contract Initializable {
153 
154   /**
155    * @dev Indicates that the contract has been initialized.
156    */
157   bool private initialized;
158 
159   /**
160    * @dev Indicates that the contract is in the process of being initialized.
161    */
162   bool private initializing;
163 
164   /**
165    * @dev Modifier to use in the initializer function of a contract.
166    */
167   modifier initializer() {
168     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
169 
170     bool isTopLevelCall = !initializing;
171     if (isTopLevelCall) {
172       initializing = true;
173       initialized = true;
174     }
175 
176     _;
177 
178     if (isTopLevelCall) {
179       initializing = false;
180     }
181   }
182 
183   /// @dev Returns true if and only if the function is running in the constructor
184   function isConstructor() private view returns (bool) {
185     // extcodesize checks the size of the code stored in an address, and
186     // address returns the current address. Since the code is still not
187     // deployed when running a constructor, any checks on its code size will
188     // yield zero, making it an effective way to detect if a contract is
189     // under construction or not.
190     address self = address(this);
191     uint256 cs;
192     assembly { cs := extcodesize(self) }
193     return cs == 0;
194   }
195 
196   // Reserved storage space to allow for layout changes in the future.
197   uint256[50] private ______gap;
198 }
199 
200 /*
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with GSN meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 contract ContextUpgradeSafe is Initializable {
211     // Empty internal constructor, to prevent people from mistakenly deploying
212     // an instance of this contract, which should be used via inheritance.
213 
214     function __Context_init() internal initializer {
215         __Context_init_unchained();
216     }
217 
218     function __Context_init_unchained() internal initializer {
219 
220 
221     }
222 
223 
224     function _msgSender() internal view virtual returns (address payable) {
225         return msg.sender;
226     }
227 
228     function _msgData() internal view virtual returns (bytes memory) {
229         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
230         return msg.data;
231     }
232 
233     uint256[50] private __gap;
234 }
235 
236 contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
237     address private _owner;
238 
239     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
240 
241     /**
242      * @dev Initializes the contract setting the deployer as the initial owner.
243      */
244 
245     function __Ownable_init() internal initializer {
246         __Context_init_unchained();
247         __Ownable_init_unchained();
248     }
249 
250     function __Ownable_init_unchained() internal initializer {
251 
252 
253         address msgSender = _msgSender();
254         _owner = msgSender;
255         emit OwnershipTransferred(address(0), msgSender);
256 
257     }
258 
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(_owner == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         emit OwnershipTransferred(_owner, address(0));
284         _owner = address(0);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 
297     uint256[49] private __gap;
298 }
299 
300 interface IERC20 {
301     /**
302      * @dev Returns the amount of tokens in existence.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns the amount of tokens owned by `account`.
308      */
309     function balanceOf(address account) external view returns (uint256);
310 
311     /**
312      * @dev Moves `amount` tokens from the caller's account to `recipient`.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transfer(address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Returns the remaining number of tokens that `spender` will be
322      * allowed to spend on behalf of `owner` through {transferFrom}. This is
323      * zero by default.
324      *
325      * This value changes when {approve} or {transferFrom} are called.
326      */
327     function allowance(address owner, address spender) external view returns (uint256);
328 
329     /**
330      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * IMPORTANT: Beware that changing an allowance with this method brings the risk
335      * that someone may use both the old and the new allowance by unfortunate
336      * transaction ordering. One possible solution to mitigate this race
337      * condition is to first reduce the spender's allowance to 0 and set the
338      * desired value afterwards:
339      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address spender, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Moves `amount` tokens from `sender` to `recipient` using the
347      * allowance mechanism. `amount` is then deducted from the caller's
348      * allowance.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 }
370 
371 /**
372  * @dev Interface of the ERC20 standard as defined in the EIP.
373  */
374 
375 /**
376  * @dev Wrappers over Solidity's arithmetic operations with added overflow
377  * checks.
378  *
379  * Arithmetic operations in Solidity wrap on overflow. This can easily result
380  * in bugs, because programmers usually assume that an overflow raises an
381  * error, which is the standard behavior in high level programming languages.
382  * `SafeMath` restores this intuition by reverting the transaction when an
383  * operation overflows.
384  *
385  * Using this library instead of the unchecked operations eliminates an entire
386  * class of bugs, so it's recommended to use it always.
387  */
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * [IMPORTANT]
397      * ====
398      * It is unsafe to assume that an address for which this function returns
399      * false is an externally-owned account (EOA) and not a contract.
400      *
401      * Among others, `isContract` will return false for the following
402      * types of addresses:
403      *
404      *  - an externally-owned account
405      *  - a contract in construction
406      *  - an address where a contract will be created
407      *  - an address where a contract lived, but was destroyed
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
412         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
413         // for accounts without code, i.e. `keccak256('')`
414         bytes32 codehash;
415         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
416         // solhint-disable-next-line no-inline-assembly
417         assembly { codehash := extcodehash(account) }
418         return (codehash != accountHash && codehash != 0x0);
419     }
420 
421     /**
422      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
423      * `recipient`, forwarding all available gas and reverting on errors.
424      *
425      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
426      * of certain opcodes, possibly making contracts go over the 2300 gas limit
427      * imposed by `transfer`, making them unable to receive funds via
428      * `transfer`. {sendValue} removes this limitation.
429      *
430      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
431      *
432      * IMPORTANT: because control is transferred to `recipient`, care must be
433      * taken to not create reentrancy vulnerabilities. Consider using
434      * {ReentrancyGuard} or the
435      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
436      */
437     function sendValue(address payable recipient, uint256 amount) internal {
438         require(address(this).balance >= amount, "Address: insufficient balance");
439 
440         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
441         (bool success, ) = recipient.call{ value: amount }("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 }
445 
446 contract ERC20UpgradeSafe is Initializable, ContextUpgradeSafe, IERC20 {
447     using SafeMath for uint256;
448     using Address for address;
449 
450     mapping(address => uint256) internal _balances;
451 
452     mapping(address => mapping(address => uint256)) private _allowances;
453 
454     uint256 internal _totalSupply;
455 
456     string private _name;
457     string private _symbol;
458     uint8 private _decimals;
459 
460     uint256 internal _gonsPerToken;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
464      * a default value of 18.
465      *
466      * To select a different value for {decimals}, use {_setupDecimals}.
467      *
468      * All three of these values are immutable: they can only be set once during
469      * construction.
470      */
471 
472     function __ERC20_init(string memory name, string memory symbol)
473         internal
474         initializer
475     {
476         __Context_init_unchained();
477         __ERC20_init_unchained(name, symbol);
478     }
479 
480     function __ERC20_init_unchained(string memory name, string memory symbol)
481         internal
482         initializer
483     {
484         _name = name;
485         _symbol = symbol;
486         _decimals = 18;
487     }
488 
489     /**
490      * @dev Returns the name of the token.
491      */
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     /**
497      * @dev Returns the symbol of the token, usually a shorter version of the
498      * name.
499      */
500     function symbol() public view returns (string memory) {
501         return _symbol;
502     }
503 
504     /**
505      * @dev Returns the number of decimals used to get its user representation.
506      * For example, if `decimals` equals `2`, a balance of `505` tokens should
507      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
508      *
509      * Tokens usually opt for a value of 18, imitating the relationship between
510      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
511      * called.
512      *
513      * NOTE: This information is only used for _display_ purposes: it in
514      * no way affects any of the arithmetic of the contract, including
515      * {IERC20-balanceOf} and {IERC20-transfer}.
516      */
517     function decimals() public view returns (uint8) {
518         return _decimals;
519     }
520 
521     /**
522      * @dev See {IERC20-totalSupply}.
523      */
524     function totalSupply() public override view returns (uint256) {
525         return _totalSupply;
526     }
527 
528     /**
529      * @dev See {IERC20-balanceOf}.
530      */
531     function balanceOf(address account) public override view returns (uint256) {
532         return _balances[account].div(_gonsPerToken);
533     }
534 
535     /**
536      * @dev See {IERC20-transfer}.
537      *
538      * Requirements:
539      *
540      * - `recipient` cannot be the zero address.
541      * - the caller must have a balance of at least `amount`.
542      */
543     function transfer(address recipient, uint256 amount)
544         public
545         virtual
546         override
547         returns (bool)
548     {
549         _transfer(_msgSender(), recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(address owner, address spender)
557         public
558         virtual
559         override
560         view
561         returns (uint256)
562     {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function approve(address spender, uint256 amount)
574         public
575         virtual
576         override
577         returns (bool)
578     {
579         _approve(_msgSender(), spender, amount);
580         return true;
581     }
582 
583     /**
584      * @dev See {IERC20-transferFrom}.
585      *
586      * Emits an {Approval} event indicating the updated allowance. This is not
587      * required by the EIP. See the note at the beginning of {ERC20};
588      *
589      * Requirements:
590      * - `sender` and `recipient` cannot be the zero address.
591      * - `sender` must have a balance of at least `amount`.
592      * - the caller must have allowance for ``sender``'s tokens of at least
593      * `amount`.
594      */
595     function transferFrom(
596         address sender,
597         address recipient,
598         uint256 amount
599     ) public virtual override returns (bool) {
600         _transfer(sender, recipient, amount);
601         _approve(
602             sender,
603             _msgSender(),
604             _allowances[sender][_msgSender()].sub(
605                 amount,
606                 "ERC20: transfer amount exceeds allowance"
607             )
608         );
609         return true;
610     }
611 
612     /**
613      * @dev Atomically increases the allowance granted to `spender` by the caller.
614      *
615      * This is an alternative to {approve} that can be used as a mitigation for
616      * problems described in {IERC20-approve}.
617      *
618      * Emits an {Approval} event indicating the updated allowance.
619      *
620      * Requirements:
621      *
622      * - `spender` cannot be the zero address.
623      */
624     function increaseAllowance(address spender, uint256 addedValue)
625         public
626         virtual
627         returns (bool)
628     {
629         _approve(
630             _msgSender(),
631             spender,
632             _allowances[_msgSender()][spender].add(addedValue)
633         );
634         return true;
635     }
636 
637     /**
638      * @dev Atomically decreases the allowance granted to `spender` by the caller.
639      *
640      * This is an alternative to {approve} that can be used as a mitigation for
641      * problems described in {IERC20-approve}.
642      *
643      * Emits an {Approval} event indicating the updated allowance.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      * - `spender` must have allowance for the caller of at least
649      * `subtractedValue`.
650      */
651     function decreaseAllowance(address spender, uint256 subtractedValue)
652         public
653         virtual
654         returns (bool)
655     {
656         _approve(
657             _msgSender(),
658             spender,
659             _allowances[_msgSender()][spender].sub(
660                 subtractedValue,
661                 "ERC20: decreased allowance below zero"
662             )
663         );
664         return true;
665     }
666 
667     /**
668      * @dev Moves tokens `amount` from `sender` to `recipient`.
669      *
670      * This is internal function is equivalent to {transfer}, and can be used to
671      * e.g. implement automatic token fees, slashing mechanisms, etc.
672      *
673      * Emits a {Transfer} event.
674      *
675      * Requirements:
676      *
677      * - `sender` cannot be the zero address.
678      * - `recipient` cannot be the zero address.
679      * - `sender` must have a balance of at least `amount`.
680      */
681     function _transfer(
682         address sender,
683         address recipient,
684         uint256 amount
685     ) internal virtual {
686         require(sender != address(0), "ERC20: transfer from the zero address");
687         require(recipient != address(0), "ERC20: transfer to the zero address");
688 
689         _beforeTokenTransfer(sender, recipient, amount);
690 
691         uint256 gonAmount = amount.mul(_gonsPerToken);
692         _balances[sender] = _balances[sender].sub(
693             gonAmount,
694             "ERC20: transfer amount exceeds balance"
695         );
696         _balances[recipient] = _balances[recipient].add(gonAmount);
697         emit Transfer(sender, recipient, amount);
698     }
699 
700     /**
701      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
702      *
703      * This is internal function is equivalent to `approve`, and can be used to
704      * e.g. set automatic allowances for certain subsystems, etc.
705      *
706      * Emits an {Approval} event.
707      *
708      * Requirements:
709      *
710      * - `owner` cannot be the zero address.
711      * - `spender` cannot be the zero address.
712      */
713     function _approve(
714         address owner,
715         address spender,
716         uint256 amount
717     ) internal virtual {
718         require(owner != address(0), "ERC20: approve from the zero address");
719         require(spender != address(0), "ERC20: approve to the zero address");
720 
721         _allowances[owner][spender] = amount;
722         emit Approval(owner, spender, amount);
723     }
724 
725     /**
726      * @dev Sets {decimals} to a value other than the default one of 18.
727      *
728      * WARNING: This function should only be called from the constructor. Most
729      * applications that interact with token contracts will not expect
730      * {decimals} to ever change, and may work incorrectly if it does.
731      */
732     function _setupDecimals(uint8 decimals_) internal {
733         _decimals = decimals_;
734     }
735 
736     /**
737      * @dev Hook that is called before any transfer of tokens. This includes
738      * minting and burning.
739      *
740      * Calling conditions:
741      *
742      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
743      * will be to transferred to `to`.
744      * - when `from` is zero, `amount` tokens will be minted for `to`.
745      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
746      * - `from` and `to` are never both zero.
747      *
748      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
749      */
750     function _beforeTokenTransfer(
751         address from,
752         address to,
753         uint256 amount
754     ) internal virtual {}
755 
756     uint256[44] private __gap;
757 }
758 
759 library SafeMathInt {
760     int256 private constant MIN_INT256 = int256(1) << 255;
761     int256 private constant MAX_INT256 = ~(int256(1) << 255);
762 
763     /**
764      * @dev Multiplies two int256 variables and fails on overflow.
765      */
766     function mul(int256 a, int256 b) internal pure returns (int256) {
767         int256 c = a * b;
768 
769         // Detect overflow when multiplying MIN_INT256 with -1
770         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
771         require((b == 0) || (c / b == a));
772         return c;
773     }
774 
775     /**
776      * @dev Division of two int256 variables and fails on overflow.
777      */
778     function div(int256 a, int256 b) internal pure returns (int256) {
779         // Prevent overflow when dividing MIN_INT256 by -1
780         require(b != -1 || a != MIN_INT256);
781 
782         // Solidity already throws when dividing by 0.
783         return a / b;
784     }
785 
786     /**
787      * @dev Subtracts two int256 variables and fails on overflow.
788      */
789     function sub(int256 a, int256 b) internal pure returns (int256) {
790         int256 c = a - b;
791         require((b >= 0 && c <= a) || (b < 0 && c > a));
792         return c;
793     }
794 
795     /**
796      * @dev Adds two int256 variables and fails on overflow.
797      */
798     function add(int256 a, int256 b) internal pure returns (int256) {
799         int256 c = a + b;
800         require((b >= 0 && c >= a) || (b < 0 && c < a));
801         return c;
802     }
803 
804     /**
805      * @dev Converts to absolute value, and fails on overflow.
806      */
807     function abs(int256 a) internal pure returns (int256) {
808         require(a != MIN_INT256);
809         return a < 0 ? -a : a;
810     }
811 }
812 
813 interface IOracle {
814     function getData() external returns (uint256, bool);
815 
816     function update() external;
817 
818     function consult() external view returns (uint256 exchangeRate);
819 }
820 
821 interface IFeeCollector {
822     function collectTransferFee(uint256 _amount)
823         external
824         returns (uint256 amountAfterFee);
825 
826     function collectTransferAndStakingFees(uint256 _amount)
827         external
828         returns (uint256 amountAfterFee);
829 
830     function calculateTransferAndStakingFee(uint256 _amount)
831         external
832         view
833         returns (
834             uint256 totalFeeAmount,
835             uint256 transferFeeAmount,
836             uint256 stakingFeeAmount,
837             uint256 feeToBurn,
838             uint256 feeToStakers,
839             uint256 amountAfterFee
840         );
841 
842     function calculateTransferFee(uint256 _amount)
843         external
844         view
845         returns (
846             uint256 feeToCharge,
847             uint256 feeToBurn,
848             uint256 feeToStakers,
849             uint256 amountAfterFee
850         );
851 }
852 
853 interface IMonetaryPolicy {
854     function rebase() external;
855 
856     function setMarketOracle(IOracle _marketOracle) external;
857 
858     function setRocket(IRocketV2 _rocket) external;
859 
860     function setDeviationThreshold(uint256 _deviationThreshold) external;
861 
862     function setRebaseLag(uint256 _rebaseLag) external;
863 
864     function setRebaseTimingParameters(
865         uint256 _minRebaseTimeIntervalSec,
866         uint256 _rebaseWindowOffsetSec,
867         uint256 _rebaseWindowLengthSec
868     ) external;
869 
870     function inRebaseWindow() external view returns (bool);
871 }
872 
873 interface IRocketV2 is IERC20 {
874     function setMonetaryPolicy(IMonetaryPolicy _monetaryPolicy) external;
875 
876     function rebase(uint256 epoch, int256 supplyDelta)
877         external
878         returns (uint256 supplyAfterRebase);
879 
880     function setFeeCollector(IFeeCollector _feeCollector) external;
881 
882     function isFeeChargingEnabled() external view returns (bool stakingEnabled);
883 
884     function transferFromWithoutCollectingFee(
885         address sender,
886         address recipient,
887         uint256 amount
888     ) external returns (bool success);
889 
890     function claim(uint256 rocketV1Amount) external;
891 
892     function calculateClaim(uint256 rocketV1AmountToSend)
893         external
894         view
895         returns (uint256 rocketV2AmountToReceive);
896 }
897 
898 interface IStaking {
899     function stake(uint256 _amount) external returns (uint256 creditsIssued);
900 
901     function redeem(uint256 _amount) external returns (uint256 rocketReturned);
902 
903     function tokensToCredits(uint256 _amount)
904         external
905         view
906         returns (uint256 credits);
907 
908     function creditsToTokens(uint256 _credits)
909         external
910         view
911         returns (uint256 rocketAmount);
912 
913     function getStakerBalance(address staker)
914         external
915         view
916         returns (
917             uint256 credits,
918             uint256 toRedeem,
919             uint256 toRedeemAfterFee
920         );
921 }
922 
923 // SPDX-License-Identifier: MIT
924 contract RocketV2 is IRocketV2, OwnableUpgradeSafe, ERC20UpgradeSafe {
925     using SafeMath for uint256;
926     using SafeMathInt for int256;
927 
928     IFeeCollector public feeCollector;
929     IStaking public staking;
930     IMonetaryPolicy public monetaryPolicy;
931     IERC20 public rocketV1;
932 
933     uint256 private constant DECIMALS = 18;
934     uint256 private constant MAX_UINT256 = ~uint256(0);
935     uint256 private constant INITIAL_SUPPLY = 3 * 10**6 * 10**DECIMALS;
936 
937     // TOTAL_GONS is a multiple of INITIAL_SUPPLY so that _gonsPerToken is an integer.
938     // Use the highest value that fits in a uint256 for max granularity.
939     uint256 private constant TOTAL_GONS = MAX_UINT256 -
940         (MAX_UINT256 % INITIAL_SUPPLY);
941 
942     // MAX_SUPPLY = maximum integer < (sqrt(4*TOTAL_GONS + 1) - 1) / 2
943     uint256 private constant MAX_SUPPLY = ~uint128(0); // (2^128) - 1
944 
945     event LogMonetaryPolicyUpdated(address monetaryPolicy);
946     event FeeCollectorUpdated(address feeCollector);
947     event StakingUpdated(address staking);
948     event RocketRebased(uint256 indexed epoch, uint256 totalSupply);
949 
950     modifier onlyMonetaryPolicy() {
951         require(
952             _msgSender() == address(monetaryPolicy),
953             "RocketV2: caller is not the monetary policy"
954         );
955         _;
956     }
957 
958     modifier canTransferWithoutFees() {
959         require(
960             _msgSender() == address(feeCollector) ||
961                 _msgSender() == address(staking),
962             "RocketV2: caller is not allowed to transfer without paying fees"
963         );
964         _;
965     }
966 
967     function initialize(IERC20 _rocketV1) external initializer {
968         __Context_init_unchained();
969         __ERC20_init_unchained("Rocket Coin", "RCKT");
970         __Ownable_init_unchained();
971 
972         _setupDecimals(uint8(DECIMALS));
973 
974         _totalSupply = INITIAL_SUPPLY;
975         _balances[address(this)] = TOTAL_GONS;
976         _gonsPerToken = TOTAL_GONS.div(_totalSupply);
977         rocketV1 = _rocketV1;
978 
979         emit Transfer(address(0x0), address(this), _totalSupply);
980     }
981 
982     function setMonetaryPolicy(IMonetaryPolicy _monetaryPolicy)
983         external
984         override
985         onlyOwner
986     {
987         require(
988             address(_monetaryPolicy) != address(0),
989             "RocketV2: monetaryPolicy address can't be zero"
990         );
991         monetaryPolicy = _monetaryPolicy;
992         emit LogMonetaryPolicyUpdated(address(_monetaryPolicy));
993     }
994 
995     function setFeeCollector(IFeeCollector _feeCollector)
996         external
997         override
998         onlyOwner
999     {
1000         require(
1001             address(_feeCollector) != address(0),
1002             "RocketV2: feeCollector address can't be zero"
1003         );
1004         feeCollector = _feeCollector;
1005         emit FeeCollectorUpdated(address(_feeCollector));
1006     }
1007 
1008     function setStaking(IStaking _staking) public onlyOwner {
1009         require(
1010             address(_staking) != address(0),
1011             "RocketV2: staking address can't be zero"
1012         );
1013         staking = _staking;
1014         emit StakingUpdated(address(_staking));
1015     }
1016 
1017     function claim(uint256 rocketV1Amount) external override {
1018         require(
1019             rocketV1.transferFrom(_msgSender(), address(this), rocketV1Amount),
1020             "RocketV2: Must receive RocketV1 tokens"
1021         );
1022 
1023         uint256 toSend = calculateClaim(rocketV1Amount);
1024 
1025         // Note: this transfer doesn't collect fees
1026         super._transfer(address(this), _msgSender(), toSend);
1027     }
1028 
1029     function calculateClaim(uint256 rocketV1AmountToSend)
1030         public
1031         override
1032         view
1033         returns (uint256 rocketV2AmountToReceive)
1034     {
1035         uint256 v1Supply = rocketV1.totalSupply();
1036         uint256 v2Supply = totalSupply();
1037         rocketV2AmountToReceive = rocketV1AmountToSend.mul(v2Supply).div(
1038             v1Supply
1039         );
1040     }
1041 
1042     function rebase(uint256 epoch, int256 supplyDelta)
1043         external
1044         override
1045         onlyMonetaryPolicy
1046         returns (uint256 supplyAfterRebase)
1047     {
1048         if (supplyDelta == 0) {
1049             emit RocketRebased(epoch, _totalSupply);
1050             return _totalSupply;
1051         }
1052         if (supplyDelta < 0) {
1053             _totalSupply = _totalSupply.sub(uint256(supplyDelta.abs()));
1054         } else {
1055             _totalSupply = _totalSupply.add(uint256(supplyDelta));
1056         }
1057         if (_totalSupply > MAX_SUPPLY) {
1058             _totalSupply = MAX_SUPPLY;
1059         }
1060 
1061         _gonsPerToken = TOTAL_GONS.div(_totalSupply);
1062 
1063         // From this point forward, _gonsPerToken is taken as the source of truth.
1064         // We recalculate a new _totalSupply to be in agreement with the _gonsPerToken
1065         // conversion rate.
1066         // This means our applied supplyDelta can deviate from the requested supplyDelta,
1067         // but this deviation is guaranteed to be < (_totalSupply^2)/(TOTAL_GONS - _totalSupply).
1068         //
1069         // In the case of _totalSupply <= MAX_UINT128 (our current supply cap), this
1070         // deviation is guaranteed to be < 1, so we can omit this step. If the supply cap is
1071         // ever increased, it must be re-included.
1072         // _totalSupply = TOTAL_GONS.div(_gonsPerToken)
1073 
1074         emit RocketRebased(epoch, _totalSupply);
1075         return _totalSupply;
1076     }
1077 
1078     function isFeeChargingEnabled()
1079         public
1080         override
1081         view
1082         returns (bool feeEnabled)
1083     {
1084         return address(feeCollector) != address(0) ? true : false;
1085     }
1086 
1087     function transferFromWithoutCollectingFee(
1088         address sender,
1089         address recipient,
1090         uint256 amount
1091     ) external override canTransferWithoutFees returns (bool success) {
1092         super._transfer(sender, recipient, amount);
1093         success = true;
1094     }
1095 
1096     function _transfer(
1097         address sender,
1098         address recipient,
1099         uint256 amount
1100     ) internal override {
1101         if (isFeeChargingEnabled()) {
1102             (uint256 totalFee, , , ) = feeCollector.calculateTransferFee(
1103                 amount
1104             );
1105             super._transfer(sender, address(this), totalFee);
1106             super._approve(address(this), address(feeCollector), totalFee);
1107             uint256 amountAfterFee = feeCollector.collectTransferFee(amount);
1108             super._approve(address(this), address(feeCollector), 0);
1109 
1110             super._transfer(sender, recipient, amountAfterFee);
1111         } else {
1112             super._transfer(sender, recipient, amount);
1113         }
1114     }
1115 }