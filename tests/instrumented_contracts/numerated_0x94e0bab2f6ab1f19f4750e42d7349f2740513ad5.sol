1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
271 
272 
273 
274 pragma solidity >=0.6.0 <0.8.0;
275 
276 
277 
278 
279 /**
280  * @dev Implementation of the {IERC20} interface.
281  *
282  * This implementation is agnostic to the way tokens are created. This means
283  * that a supply mechanism has to be added in a derived contract using {_mint}.
284  * For a generic mechanism see {ERC20PresetMinterPauser}.
285  *
286  * TIP: For a detailed writeup see our guide
287  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
288  * to implement supply mechanisms].
289  *
290  * We have followed general OpenZeppelin guidelines: functions revert instead
291  * of returning `false` on failure. This behavior is nonetheless conventional
292  * and does not conflict with the expectations of ERC20 applications.
293  *
294  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
295  * This allows applications to reconstruct the allowance for all accounts just
296  * by listening to said events. Other implementations of the EIP may not emit
297  * these events, as it isn't required by the specification.
298  *
299  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
300  * functions have been added to mitigate the well-known issues around setting
301  * allowances. See {IERC20-approve}.
302  */
303 contract ERC20 is Context, IERC20 {
304     using SafeMath for uint256;
305 
306     mapping (address => uint256) private _balances;
307 
308     mapping (address => mapping (address => uint256)) private _allowances;
309 
310     uint256 private _totalSupply;
311 
312     string private _name;
313     string private _symbol;
314     uint8 private _decimals;
315 
316     /**
317      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
318      * a default value of 18.
319      *
320      * To select a different value for {decimals}, use {_setupDecimals}.
321      *
322      * All three of these values are immutable: they can only be set once during
323      * construction.
324      */
325     constructor (string memory name_, string memory symbol_) public {
326         _name = name_;
327         _symbol = symbol_;
328         _decimals = 18;
329     }
330 
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @dev Returns the symbol of the token, usually a shorter version of the
340      * name.
341      */
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     /**
347      * @dev Returns the number of decimals used to get its user representation.
348      * For example, if `decimals` equals `2`, a balance of `505` tokens should
349      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
350      *
351      * Tokens usually opt for a value of 18, imitating the relationship between
352      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
353      * called.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362 
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view override returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view override returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view virtual override returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public virtual override returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20}.
414      *
415      * Requirements:
416      *
417      * - `sender` and `recipient` cannot be the zero address.
418      * - `sender` must have a balance of at least `amount`.
419      * - the caller must have allowance for ``sender``'s tokens of at least
420      * `amount`.
421      */
422     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     /**
429      * @dev Atomically increases the allowance granted to `spender` by the caller.
430      *
431      * This is an alternative to {approve} that can be used as a mitigation for
432      * problems described in {IERC20-approve}.
433      *
434      * Emits an {Approval} event indicating the updated allowance.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
441         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Atomically decreases the allowance granted to `spender` by the caller.
447      *
448      * This is an alternative to {approve} that can be used as a mitigation for
449      * problems described in {IERC20-approve}.
450      *
451      * Emits an {Approval} event indicating the updated allowance.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      * - `spender` must have allowance for the caller of at least
457      * `subtractedValue`.
458      */
459     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
460         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
461         return true;
462     }
463 
464     /**
465      * @dev Moves tokens `amount` from `sender` to `recipient`.
466      *
467      * This is internal function is equivalent to {transfer}, and can be used to
468      * e.g. implement automatic token fees, slashing mechanisms, etc.
469      *
470      * Emits a {Transfer} event.
471      *
472      * Requirements:
473      *
474      * - `sender` cannot be the zero address.
475      * - `recipient` cannot be the zero address.
476      * - `sender` must have a balance of at least `amount`.
477      */
478     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
485         _balances[recipient] = _balances[recipient].add(amount);
486         emit Transfer(sender, recipient, amount);
487     }
488 
489     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
490      * the total supply.
491      *
492      * Emits a {Transfer} event with `from` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `to` cannot be the zero address.
497      */
498     function _mint(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: mint to the zero address");
500 
501         _beforeTokenTransfer(address(0), account, amount);
502 
503         _totalSupply = _totalSupply.add(amount);
504         _balances[account] = _balances[account].add(amount);
505         emit Transfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
525         _totalSupply = _totalSupply.sub(amount);
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Sets {decimals} to a value other than the default one of 18.
552      *
553      * WARNING: This function should only be called from the constructor. Most
554      * applications that interact with token contracts will not expect
555      * {decimals} to ever change, and may work incorrectly if it does.
556      */
557     function _setupDecimals(uint8 decimals_) internal {
558         _decimals = decimals_;
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be to transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
576 }
577 
578 // File: @openzeppelin/contracts/access/Ownable.sol
579 
580 
581 
582 pragma solidity >=0.6.0 <0.8.0;
583 
584 /**
585  * @dev Contract module which provides a basic access control mechanism, where
586  * there is an account (an owner) that can be granted exclusive access to
587  * specific functions.
588  *
589  * By default, the owner account will be the one that deploys the contract. This
590  * can later be changed with {transferOwnership}.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be applied to your functions to restrict their use to
594  * the owner.
595  */
596 abstract contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600 
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () internal {
605         address msgSender = _msgSender();
606         _owner = msgSender;
607         emit OwnershipTransferred(address(0), msgSender);
608     }
609 
610     /**
611      * @dev Returns the address of the current owner.
612      */
613     function owner() public view returns (address) {
614         return _owner;
615     }
616 
617     /**
618      * @dev Throws if called by any account other than the owner.
619      */
620     modifier onlyOwner() {
621         require(_owner == _msgSender(), "Ownable: caller is not the owner");
622         _;
623     }
624 
625     /**
626      * @dev Leaves the contract without owner. It will not be possible to call
627      * `onlyOwner` functions anymore. Can only be called by the current owner.
628      *
629      * NOTE: Renouncing ownership will leave the contract without an owner,
630      * thereby removing any functionality that is only available to the owner.
631      */
632     function renounceOwnership() public virtual onlyOwner {
633         emit OwnershipTransferred(_owner, address(0));
634         _owner = address(0);
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         emit OwnershipTransferred(_owner, newOwner);
644         _owner = newOwner;
645     }
646 }
647 
648 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
649 
650 
651 
652 pragma solidity >=0.6.0 <0.8.0;
653 
654 
655 /**
656  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
657  */
658 abstract contract ERC20Capped is ERC20 {
659     using SafeMath for uint256;
660 
661     uint256 private _cap;
662 
663     /**
664      * @dev Sets the value of the `cap`. This value is immutable, it can only be
665      * set once during construction.
666      */
667     constructor (uint256 cap_) internal {
668         require(cap_ > 0, "ERC20Capped: cap is 0");
669         _cap = cap_;
670     }
671 
672     /**
673      * @dev Returns the cap on the token's total supply.
674      */
675     function cap() public view returns (uint256) {
676         return _cap;
677     }
678 
679     /**
680      * @dev See {ERC20-_beforeTokenTransfer}.
681      *
682      * Requirements:
683      *
684      * - minted tokens must not cause the total supply to go over the cap.
685      */
686     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
687         super._beforeTokenTransfer(from, to, amount);
688 
689         if (from == address(0)) { // When minting tokens
690             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
691         }
692     }
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
696 
697 
698 
699 pragma solidity >=0.6.0 <0.8.0;
700 
701 
702 
703 /**
704  * @dev Extension of {ERC20} that allows token holders to destroy both their own
705  * tokens and those that they have an allowance for, in a way that can be
706  * recognized off-chain (via event analysis).
707  */
708 abstract contract ERC20Burnable is Context, ERC20 {
709     using SafeMath for uint256;
710 
711     /**
712      * @dev Destroys `amount` tokens from the caller.
713      *
714      * See {ERC20-_burn}.
715      */
716     function burn(uint256 amount) public virtual {
717         _burn(_msgSender(), amount);
718     }
719 
720     /**
721      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
722      * allowance.
723      *
724      * See {ERC20-_burn} and {ERC20-allowance}.
725      *
726      * Requirements:
727      *
728      * - the caller must have allowance for ``accounts``'s tokens of at least
729      * `amount`.
730      */
731     function burnFrom(address account, uint256 amount) public virtual {
732         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
733 
734         _approve(account, _msgSender(), decreasedAllowance);
735         _burn(account, amount);
736     }
737 }
738 
739 // File: contracts/Unic.sol
740 
741 pragma solidity 0.6.12;
742 
743 
744 
745 
746 
747 // Unic with Governance.
748 contract Unic is ERC20, ERC20Capped, ERC20Burnable, Ownable {
749     constructor () 
750         public 
751         ERC20("UNIC", "UNIC")
752         ERC20Capped(1_000_000e18)
753     {
754         // Mint 1 UNIC to me because I deserve it
755         _mint(_msgSender(), 1e18);
756         _moveDelegates(address(0), _delegates[_msgSender()], 1e18);
757     }
758 
759     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
760     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
761         _mint(_to, _amount);
762         _moveDelegates(address(0), _delegates[_to], _amount);
763         return true;
764     }
765 
766     // Copied and modified from YAM code:
767     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
768     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
769     // Which is copied and modified from COMPOUND:
770     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
771 
772     /// @dev A record of each accounts delegate
773     mapping (address => address) internal _delegates;
774 
775     /// @notice A checkpoint for marking number of votes from a given block
776     struct Checkpoint {
777         uint32 fromBlock;
778         uint256 votes;
779     }
780 
781     /// @notice A record of votes checkpoints for each account, by index
782     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
783 
784     /// @notice The number of checkpoints for each account
785     mapping (address => uint32) public numCheckpoints;
786 
787     /// @notice The EIP-712 typehash for the contract's domain
788     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
789 
790     /// @notice The EIP-712 typehash for the delegation struct used by the contract
791     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
792 
793     /// @notice A record of states for signing / validating signatures
794     mapping (address => uint) public nonces;
795 
796       /// @notice An event thats emitted when an account changes its delegate
797     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
798 
799     /// @notice An event thats emitted when a delegate account's vote balance changes
800     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
801 
802     /**
803      * @notice Delegate votes from `msg.sender` to `delegatee`
804      * @param delegator The address to get delegatee for
805      */
806     function delegates(address delegator)
807         external
808         view
809         returns (address)
810     {
811         return _delegates[delegator];
812     }
813 
814    /**
815     * @notice Delegate votes from `msg.sender` to `delegatee`
816     * @param delegatee The address to delegate votes to
817     */
818     function delegate(address delegatee) external {
819         return _delegate(msg.sender, delegatee);
820     }
821 
822     /**
823      * @notice Delegates votes from signatory to `delegatee`
824      * @param delegatee The address to delegate votes to
825      * @param nonce The contract state required to match the signature
826      * @param expiry The time at which to expire the signature
827      * @param v The recovery byte of the signature
828      * @param r Half of the ECDSA signature pair
829      * @param s Half of the ECDSA signature pair
830      */
831     function delegateBySig(
832         address delegatee,
833         uint nonce,
834         uint expiry,
835         uint8 v,
836         bytes32 r,
837         bytes32 s
838     )
839         external
840     {
841         bytes32 domainSeparator = keccak256(
842             abi.encode(
843                 DOMAIN_TYPEHASH,
844                 keccak256(bytes(name())),
845                 getChainId(),
846                 address(this)
847             )
848         );
849 
850         bytes32 structHash = keccak256(
851             abi.encode(
852                 DELEGATION_TYPEHASH,
853                 delegatee,
854                 nonce,
855                 expiry
856             )
857         );
858 
859         bytes32 digest = keccak256(
860             abi.encodePacked(
861                 "\x19\x01",
862                 domainSeparator,
863                 structHash
864             )
865         );
866 
867         address signatory = ecrecover(digest, v, r, s);
868         require(signatory != address(0), "UNIC::delegateBySig: invalid signature");
869         require(nonce == nonces[signatory]++, "UNIC::delegateBySig: invalid nonce");
870         require(now <= expiry, "UNIC::delegateBySig: signature expired");
871         return _delegate(signatory, delegatee);
872     }
873 
874     /**
875      * @notice Gets the current votes balance for `account`
876      * @param account The address to get votes balance
877      * @return The number of current votes for `account`
878      */
879     function getCurrentVotes(address account)
880         external
881         view
882         returns (uint256)
883     {
884         uint32 nCheckpoints = numCheckpoints[account];
885         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
886     }
887 
888     /**
889      * @notice Determine the prior number of votes for an account as of a block number
890      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
891      * @param account The address of the account to check
892      * @param blockNumber The block number to get the vote balance at
893      * @return The number of votes the account had as of the given block
894      */
895     function getPriorVotes(address account, uint blockNumber)
896         external
897         view
898         returns (uint256)
899     {
900         require(blockNumber < block.number, "UNIC::getPriorVotes: not yet determined");
901 
902         uint32 nCheckpoints = numCheckpoints[account];
903         if (nCheckpoints == 0) {
904             return 0;
905         }
906 
907         // First check most recent balance
908         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
909             return checkpoints[account][nCheckpoints - 1].votes;
910         }
911 
912         // Next check implicit zero balance
913         if (checkpoints[account][0].fromBlock > blockNumber) {
914             return 0;
915         }
916 
917         uint32 lower = 0;
918         uint32 upper = nCheckpoints - 1;
919         while (upper > lower) {
920             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
921             Checkpoint memory cp = checkpoints[account][center];
922             if (cp.fromBlock == blockNumber) {
923                 return cp.votes;
924             } else if (cp.fromBlock < blockNumber) {
925                 lower = center;
926             } else {
927                 upper = center - 1;
928             }
929         }
930         return checkpoints[account][lower].votes;
931     }
932 
933     function _delegate(address delegator, address delegatee)
934         internal
935     {
936         address currentDelegate = _delegates[delegator];
937         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying UNICs (not scaled);
938         _delegates[delegator] = delegatee;
939 
940         emit DelegateChanged(delegator, currentDelegate, delegatee);
941 
942         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
943     }
944 
945     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
946         if (srcRep != dstRep && amount > 0) {
947             if (srcRep != address(0)) {
948                 // decrease old representative
949                 uint32 srcRepNum = numCheckpoints[srcRep];
950                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
951                 uint256 srcRepNew = srcRepOld.sub(amount);
952                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
953             }
954 
955             if (dstRep != address(0)) {
956                 // increase new representative
957                 uint32 dstRepNum = numCheckpoints[dstRep];
958                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
959                 uint256 dstRepNew = dstRepOld.add(amount);
960                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
961             }
962         }
963     }
964 
965     function _writeCheckpoint(
966         address delegatee,
967         uint32 nCheckpoints,
968         uint256 oldVotes,
969         uint256 newVotes
970     )
971         internal
972     {
973         uint32 blockNumber = safe32(block.number, "UNIC::_writeCheckpoint: block number exceeds 32 bits");
974 
975         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
976             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
977         } else {
978             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
979             numCheckpoints[delegatee] = nCheckpoints + 1;
980         }
981 
982         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
983     }
984 
985     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
986         require(n < 2**32, errorMessage);
987         return uint32(n);
988     }
989 
990     function getChainId() internal pure returns (uint) {
991         uint256 chainId;
992         assembly { chainId := chainid() }
993         return chainId;
994     }
995 
996     /**
997      * @dev See {ERC20-_beforeTokenTransfer}.
998      */
999     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1000         super._beforeTokenTransfer(from, to, amount);
1001     }
1002 }