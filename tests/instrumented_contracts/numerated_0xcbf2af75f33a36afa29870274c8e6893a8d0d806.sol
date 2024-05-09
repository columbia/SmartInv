1 pragma solidity 0.6.1;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 }
18 
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations with added overflow
22  * checks.
23  *
24  * Arithmetic operations in Solidity wrap on overflow. This can easily result
25  * in bugs, because programmers usually assume that an overflow raises an
26  * error, which is the standard behavior in high level programming languages.
27  * `SafeMath` restores this intuition by reverting the transaction when an
28  * operation overflows.
29  *
30  * Using this library instead of the unchecked operations eliminates an entire
31  * class of bugs, so it's recommended to use it always.
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60         return sub(a, b, "SafeMath: subtraction overflow");
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166 }
167 
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20MinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * We have followed general OpenZeppelin guidelines: functions revert instead
256  * of returning `false` on failure. This behavior is nonetheless conventional
257  * and does not conflict with the expectations of ERC20 applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20 {
269     using SafeMath for uint256;
270 
271     mapping (address => uint256) private _balances;
272 
273     mapping (address => mapping (address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     string private _name;
278     string private _symbol;
279     uint8 private _decimals;
280 
281     /**
282      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
283      * a default value of 18.
284      *
285      * To select a different value for {decimals}, use {_setupDecimals}.
286      *
287      * All three of these values are immutable: they can only be set once during
288      * construction.
289      */
290     constructor (string memory name, string memory symbol, uint256 totalSupply, address owner) public {
291         _name = name;
292         _symbol = symbol;
293         _decimals = 18;
294         _totalSupply = totalSupply;
295         _balances[owner] = _totalSupply;
296         emit Transfer(address(0), owner, _totalSupply);
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
321      * called.
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view returns (uint8) {
328         return _decimals;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view override returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view virtual override returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20};
382      *
383      * Requirements:
384      * - `sender` and `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``sender``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
390         _transfer(sender, recipient, amount);
391         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
392         return true;
393     }
394 
395     /**
396      * @dev Atomically increases the allowance granted to `spender` by the caller.
397      *
398      * This is an alternative to {approve} that can be used as a mitigation for
399      * problems described in {IERC20-approve}.
400      *
401      * Emits an {Approval} event indicating the updated allowance.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
408         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
409         return true;
410     }
411 
412     /**
413      * @dev Atomically decreases the allowance granted to `spender` by the caller.
414      *
415      * This is an alternative to {approve} that can be used as a mitigation for
416      * problems described in {IERC20-approve}.
417      *
418      * Emits an {Approval} event indicating the updated allowance.
419      *
420      * Requirements:
421      *
422      * - `spender` cannot be the zero address.
423      * - `spender` must have allowance for the caller of at least
424      * `subtractedValue`.
425      */
426     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
427         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
428         return true;
429     }
430 
431     /**
432      * @dev Moves tokens `amount` from `sender` to `recipient`.
433      *
434      * This is internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `sender` cannot be the zero address.
442      * - `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      */
445     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
446         require(sender != address(0), "ERC20: transfer from the zero address");
447         require(recipient != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(sender, recipient, amount);
450 
451         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
452         _balances[recipient] = _balances[recipient].add(amount);
453         emit Transfer(sender, recipient, amount);
454     }
455 
456     /**
457      * @dev Destroys `amount` tokens from `account`, reducing the
458      * total supply.
459      *
460      * Emits a {Transfer} event with `to` set to the zero address.
461      *
462      * Requirements
463      *
464      * - `account` cannot be the zero address.
465      * - `account` must have at least `amount` tokens.
466      */
467     function _burn(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: burn from the zero address");
469 
470         _beforeTokenTransfer(account, address(0), amount);
471 
472         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
473         _totalSupply = _totalSupply.sub(amount);
474         emit Transfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
479      *
480      * This is internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(address owner, address spender, uint256 amount) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Sets {decimals} to a value other than the default one of 18.
500      *
501      * WARNING: This function should only be called from the constructor. Most
502      * applications that interact with token contracts will not expect
503      * {decimals} to ever change, and may work incorrectly if it does.
504      */
505     function _setupDecimals(uint8 decimals_) internal {
506         _decimals = decimals_;
507     }
508 
509     /**
510      * @dev Hook that is called before any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * will be to transferred to `to`.
517      * - when `from` is zero, `amount` tokens will be minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
524 }
525 
526 
527 /**
528  * @dev Contract module which provides a basic access control mechanism, where
529  * there is an account (an owner) that can be granted exclusive access to
530  * specific functions.
531  *
532  * By default, the owner account will be the one that deploys the contract. This
533  * can later be changed with {transferOwnership}.
534  *
535  * This module is used through inheritance. It will make available the modifier
536  * `onlyOwner`, which can be applied to your functions to restrict their use to
537  * the owner.
538  */
539 contract Ownable is Context {
540     address private _owner;
541 
542     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
543 
544     /**
545      * @dev Initializes the contract setting the deployer as the initial owner.
546      */
547     constructor (address owner) internal {
548         _owner = owner;
549         emit OwnershipTransferred(address(0), _owner);
550     }
551 
552     /**
553      * @dev Returns the address of the current owner.
554      */
555     function owner() public view returns (address) {
556         return _owner;
557     }
558 
559     /**
560      * @dev Throws if called by any account other than the owner.
561      */
562     modifier onlyOwner() {
563         require(_owner == _msgSender(), "Ownable: caller is not the owner");
564         _;
565     }
566 
567     /**
568      * @dev Leaves the contract without owner. It will not be possible to call
569      * `onlyOwner` functions anymore. Can only be called by the current owner.
570      *
571      * NOTE: Renouncing ownership will leave the contract without an owner,
572      * thereby removing any functionality that is only available to the owner.
573      */
574     function renounceOwnership() public virtual onlyOwner {
575         emit OwnershipTransferred(_owner, address(0));
576         _owner = address(0);
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Can only be called by the current owner.
582      */
583     function transferOwnership(address newOwner) public virtual onlyOwner {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         emit OwnershipTransferred(_owner, newOwner);
586         _owner = newOwner;
587     }
588 }
589 
590 
591 /**
592  * @dev Contract module which allows children to implement an emergency stop
593  * mechanism that can be triggered by an authorized account.
594  *
595  * This module is used through inheritance. It will make available the
596  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
597  * the functions of your contract. Note that they will not be pausable by
598  * simply including this module, only once the modifiers are put in place.
599  */
600 abstract contract Pausable is Context, Ownable {
601     /**
602      * @dev Emitted when the pause is triggered by `account`.
603      */
604     event Paused(address account);
605 
606     /**
607      * @dev Emitted when the pause is lifted by `account`.
608      */
609     event Unpaused(address account);
610 
611     bool private _paused;
612 
613     /**
614      * @dev Initializes the contract in unpaused state.
615      */
616     constructor () internal {
617         _paused = false;
618     }
619 
620     /**
621      * @dev Returns true if the contract is paused, and false otherwise.
622      */
623     function paused() public view returns (bool) {
624         return _paused;
625     }
626 
627     /**
628      * @dev Modifier to make a function callable only when the contract is not paused.
629      *
630      * Requirements:
631      *
632      * - The contract must not be paused.
633      */
634     modifier whenNotPaused() {
635         require(!_paused, "Pausable: paused");
636         _;
637     }
638 
639     /**
640      * @dev Modifier to make a function callable only when the contract is paused.
641      *
642      * Requirements:
643      *
644      * - The contract must be paused.
645      */
646     modifier whenPaused() {
647         require(_paused, "Pausable: not paused");
648         _;
649     }
650 
651     /**
652      * @dev Triggers stopped state.
653      *
654      * Requirements:
655      *
656      * - The contract must not be paused.
657      */
658     function pause() public virtual onlyOwner whenNotPaused {
659         _paused = true;
660         emit Paused(_msgSender());
661     }
662 
663     /**
664      * @dev Returns to normal state.
665      *
666      * Requirements:
667      *
668      * - The contract must be paused.
669      */
670     function unpause() public virtual onlyOwner whenPaused {
671         _paused = false;
672         emit Unpaused(_msgSender());
673     }
674 }
675 
676 
677 /**
678  * @dev Extension of {ERC20} that allows token holders to destroy both their own
679  * tokens and those that they have an allowance for, in a way that can be
680  * recognized off-chain (via event analysis).
681  */
682 abstract contract ERC20Burnable is Context, ERC20, Ownable {
683     /**
684      * @dev Destroys `amount` tokens from the caller.
685      *
686      * See {ERC20-_burn}.
687      */
688     function burn(uint256 amount) public virtual onlyOwner {
689         _burn(_msgSender(), amount);
690     }
691 
692     /**
693      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
694      * allowance.
695      *
696      * See {ERC20-_burn} and {ERC20-allowance}.
697      *
698      * Requirements:
699      *
700      * - the caller must have allowance for ``accounts``'s tokens of at least
701      * `amount`.
702      */
703     function burnFrom(address account, uint256 amount) public virtual onlyOwner {
704         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
705 
706         _approve(account, _msgSender(), decreasedAllowance);
707         _burn(account, amount);
708     }
709 }
710 
711 
712 /**
713  * @dev ERC20 token with pausable token transfers, minting and burning.
714  *
715  * Useful for scenarios such as preventing trades until the end of an evaluation
716  * period, or having an emergency switch for freezing all token transfers in the
717  * event of a large bug.
718  */
719 abstract contract ERC20Pausable is ERC20, Pausable, ERC20Burnable {
720     /**
721      * @dev See {ERC20-_beforeTokenTransfer}.
722      *
723      * Requirements:
724      *
725      * - the contract must not be paused.
726      */
727     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
728         require(!paused(), "ERC20Pausable: token transfer while paused");
729         super._beforeTokenTransfer(from, to, amount);
730     }
731 }
732 
733 
734 contract LUNAToken is ERC20Pausable {
735 
736     string internal constant _name = "LUNA";
737     string internal constant _symbol = "LUNA";
738     address public constant tokenWallet = 0xfDAB463d850AEc9B91e15C4Fa7D1528c7e225ca1;
739     uint256 public constant INIT_TOTALSUPPLY = 1000000000*10**18;
740 
741     constructor () public ERC20(_name, _symbol, INIT_TOTALSUPPLY, tokenWallet) Ownable(tokenWallet) Pausable() {
742 
743     }
744 }