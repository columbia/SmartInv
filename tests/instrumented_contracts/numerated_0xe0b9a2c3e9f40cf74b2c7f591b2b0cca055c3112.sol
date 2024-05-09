1 // File: @openzeppelin/contracts/utils/Context.sol
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
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 
328 
329 pragma solidity >=0.6.0 <0.8.0;
330 
331 
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20PresetMinterPauser}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin guidelines: functions revert instead
346  * of returning `false` on failure. This behavior is nonetheless conventional
347  * and does not conflict with the expectations of ERC20 applications.
348  *
349  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
350  * This allows applications to reconstruct the allowance for all accounts just
351  * by listening to said events. Other implementations of the EIP may not emit
352  * these events, as it isn't required by the specification.
353  *
354  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
355  * functions have been added to mitigate the well-known issues around setting
356  * allowances. See {IERC20-approve}.
357  */
358 contract ERC20 is Context, IERC20 {
359     using SafeMath for uint256;
360 
361     mapping (address => uint256) private _balances;
362 
363     mapping (address => mapping (address => uint256)) private _allowances;
364 
365     uint256 private _totalSupply;
366 
367     string private _name;
368     string private _symbol;
369     uint8 private _decimals;
370 
371     /**
372      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
373      * a default value of 18.
374      *
375      * To select a different value for {decimals}, use {_setupDecimals}.
376      *
377      * All three of these values are immutable: they can only be set once during
378      * construction.
379      */
380     constructor (string memory name_, string memory symbol_) public {
381         _name = name_;
382         _symbol = symbol_;
383         _decimals = 18;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view virtual returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view virtual returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @dev Returns the number of decimals used to get its user representation.
403      * For example, if `decimals` equals `2`, a balance of `505` tokens should
404      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
405      *
406      * Tokens usually opt for a value of 18, imitating the relationship between
407      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
408      * called.
409      *
410      * NOTE: This information is only used for _display_ purposes: it in
411      * no way affects any of the arithmetic of the contract, including
412      * {IERC20-balanceOf} and {IERC20-transfer}.
413      */
414     function decimals() public view virtual returns (uint8) {
415         return _decimals;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view virtual override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view virtual override returns (uint256) {
429         return _balances[account];
430     }
431 
432     /**
433      * @dev See {IERC20-transfer}.
434      *
435      * Requirements:
436      *
437      * - `recipient` cannot be the zero address.
438      * - the caller must have a balance of at least `amount`.
439      */
440     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-allowance}.
447      */
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     /**
453      * @dev See {IERC20-approve}.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      */
459     function approve(address spender, uint256 amount) public virtual override returns (bool) {
460         _approve(_msgSender(), spender, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See {IERC20-transferFrom}.
466      *
467      * Emits an {Approval} event indicating the updated allowance. This is not
468      * required by the EIP. See the note at the beginning of {ERC20}.
469      *
470      * Requirements:
471      *
472      * - `sender` and `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``sender``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(sender, recipient, amount);
479         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically increases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      */
495     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
497         return true;
498     }
499 
500     /**
501      * @dev Atomically decreases the allowance granted to `spender` by the caller.
502      *
503      * This is an alternative to {approve} that can be used as a mitigation for
504      * problems described in {IERC20-approve}.
505      *
506      * Emits an {Approval} event indicating the updated allowance.
507      *
508      * Requirements:
509      *
510      * - `spender` cannot be the zero address.
511      * - `spender` must have allowance for the caller of at least
512      * `subtractedValue`.
513      */
514     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
516         return true;
517     }
518 
519     /**
520      * @dev Moves tokens `amount` from `sender` to `recipient`.
521      *
522      * This is internal function is equivalent to {transfer}, and can be used to
523      * e.g. implement automatic token fees, slashing mechanisms, etc.
524      *
525      * Emits a {Transfer} event.
526      *
527      * Requirements:
528      *
529      * - `sender` cannot be the zero address.
530      * - `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `amount`.
532      */
533     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536 
537         _beforeTokenTransfer(sender, recipient, amount);
538 
539         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
540         _balances[recipient] = _balances[recipient].add(amount);
541         emit Transfer(sender, recipient, amount);
542     }
543 
544     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
545      * the total supply.
546      *
547      * Emits a {Transfer} event with `from` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `to` cannot be the zero address.
552      */
553     function _mint(address account, uint256 amount) internal virtual {
554         require(account != address(0), "ERC20: mint to the zero address");
555 
556         _beforeTokenTransfer(address(0), account, amount);
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) internal virtual {
575         require(account != address(0), "ERC20: burn from the zero address");
576 
577         _beforeTokenTransfer(account, address(0), amount);
578 
579         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
580         _totalSupply = _totalSupply.sub(amount);
581         emit Transfer(account, address(0), amount);
582     }
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
586      *
587      * This internal function is equivalent to `approve`, and can be used to
588      * e.g. set automatic allowances for certain subsystems, etc.
589      *
590      * Emits an {Approval} event.
591      *
592      * Requirements:
593      *
594      * - `owner` cannot be the zero address.
595      * - `spender` cannot be the zero address.
596      */
597     function _approve(address owner, address spender, uint256 amount) internal virtual {
598         require(owner != address(0), "ERC20: approve from the zero address");
599         require(spender != address(0), "ERC20: approve to the zero address");
600 
601         _allowances[owner][spender] = amount;
602         emit Approval(owner, spender, amount);
603     }
604 
605     /**
606      * @dev Sets {decimals} to a value other than the default one of 18.
607      *
608      * WARNING: This function should only be called from the constructor. Most
609      * applications that interact with token contracts will not expect
610      * {decimals} to ever change, and may work incorrectly if it does.
611      */
612     function _setupDecimals(uint8 decimals_) internal virtual {
613         _decimals = decimals_;
614     }
615 
616     /**
617      * @dev Hook that is called before any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * will be to transferred to `to`.
624      * - when `from` is zero, `amount` tokens will be minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
631 }
632 
633 // File: @openzeppelin/contracts/access/Ownable.sol
634 
635 
636 
637 pragma solidity >=0.6.0 <0.8.0;
638 
639 /**
640  * @dev Contract module which provides a basic access control mechanism, where
641  * there is an account (an owner) that can be granted exclusive access to
642  * specific functions.
643  *
644  * By default, the owner account will be the one that deploys the contract. This
645  * can later be changed with {transferOwnership}.
646  *
647  * This module is used through inheritance. It will make available the modifier
648  * `onlyOwner`, which can be applied to your functions to restrict their use to
649  * the owner.
650  */
651 abstract contract Ownable is Context {
652     address private _owner;
653 
654     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
655 
656     /**
657      * @dev Initializes the contract setting the deployer as the initial owner.
658      */
659     constructor () internal {
660         address msgSender = _msgSender();
661         _owner = msgSender;
662         emit OwnershipTransferred(address(0), msgSender);
663     }
664 
665     /**
666      * @dev Returns the address of the current owner.
667      */
668     function owner() public view virtual returns (address) {
669         return _owner;
670     }
671 
672     /**
673      * @dev Throws if called by any account other than the owner.
674      */
675     modifier onlyOwner() {
676         require(owner() == _msgSender(), "Ownable: caller is not the owner");
677         _;
678     }
679 
680     /**
681      * @dev Leaves the contract without owner. It will not be possible to call
682      * `onlyOwner` functions anymore. Can only be called by the current owner.
683      *
684      * NOTE: Renouncing ownership will leave the contract without an owner,
685      * thereby removing any functionality that is only available to the owner.
686      */
687     function renounceOwnership() public virtual onlyOwner {
688         emit OwnershipTransferred(_owner, address(0));
689         _owner = address(0);
690     }
691 
692     /**
693      * @dev Transfers ownership of the contract to a new account (`newOwner`).
694      * Can only be called by the current owner.
695      */
696     function transferOwnership(address newOwner) public virtual onlyOwner {
697         require(newOwner != address(0), "Ownable: new owner is the zero address");
698         emit OwnershipTransferred(_owner, newOwner);
699         _owner = newOwner;
700     }
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
704 
705 
706 
707 pragma solidity >=0.6.0 <0.8.0;
708 
709 
710 /**
711  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
712  */
713 abstract contract ERC20Capped is ERC20 {
714     using SafeMath for uint256;
715 
716     uint256 private _cap;
717 
718     /**
719      * @dev Sets the value of the `cap`. This value is immutable, it can only be
720      * set once during construction.
721      */
722     constructor (uint256 cap_) internal {
723         require(cap_ > 0, "ERC20Capped: cap is 0");
724         _cap = cap_;
725     }
726 
727     /**
728      * @dev Returns the cap on the token's total supply.
729      */
730     function cap() public view virtual returns (uint256) {
731         return _cap;
732     }
733 
734     /**
735      * @dev See {ERC20-_beforeTokenTransfer}.
736      *
737      * Requirements:
738      *
739      * - minted tokens must not cause the total supply to go over the cap.
740      */
741     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
742         super._beforeTokenTransfer(from, to, amount);
743 
744         if (from == address(0)) { // When minting tokens
745             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
746         }
747     }
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
751 
752 
753 
754 pragma solidity >=0.6.0 <0.8.0;
755 
756 
757 
758 /**
759  * @dev Extension of {ERC20} that allows token holders to destroy both their own
760  * tokens and those that they have an allowance for, in a way that can be
761  * recognized off-chain (via event analysis).
762  */
763 abstract contract ERC20Burnable is Context, ERC20 {
764     using SafeMath for uint256;
765 
766     /**
767      * @dev Destroys `amount` tokens from the caller.
768      *
769      * See {ERC20-_burn}.
770      */
771     function burn(uint256 amount) public virtual {
772         _burn(_msgSender(), amount);
773     }
774 
775     /**
776      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
777      * allowance.
778      *
779      * See {ERC20-_burn} and {ERC20-allowance}.
780      *
781      * Requirements:
782      *
783      * - the caller must have allowance for ``accounts``'s tokens of at least
784      * `amount`.
785      */
786     function burnFrom(address account, uint256 amount) public virtual {
787         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
788 
789         _approve(account, _msgSender(), decreasedAllowance);
790         _burn(account, amount);
791     }
792 }
793 
794 // File: contracts/interfaces/ILocker.sol
795 
796 pragma solidity >=0.6.0 <0.8.0;
797 
798 interface ILiquiditySyncer {
799   function syncLiquiditySupply(address pool) external;
800 }
801 
802 interface ILocker {
803   /**
804    * @dev Fails if transaction is not allowed. Otherwise returns the penalty.
805    * Returns a bool and a uint16, bool clarifying the penalty applied, and uint16 the penaltyOver1000
806    */
807   function lockOrGetPenalty(address source, address dest)
808     external
809     returns (bool, uint256);
810 }
811 
812 interface ILockerUser {
813   function locker() external view returns (ILocker);
814 }
815 
816 // File: contracts/GenShards.sol
817 
818 pragma solidity 0.6.12;
819 
820 
821 
822 
823 
824 
825 // Gen Shards with Governance.
826 contract GenShards is ERC20, ERC20Capped, ERC20Burnable, Ownable, ILockerUser {
827     constructor () 
828         public 
829         ERC20("Gen Shards", "GS")
830         ERC20Capped(208_969_354e18)
831     {
832         // Mint GS
833         _mint(_msgSender(), 208_969_354e18);
834         _moveDelegates(address(0), _delegates[_msgSender()], 208_969_354e18);
835     }
836 
837     ILocker public override locker;
838 
839     function setLocker(address _locker) external onlyOwner() {
840         locker = ILocker(_locker);
841     }
842 
843     function _transfer(
844         address sender,
845         address recipient,
846         uint256 amount
847     ) internal virtual override {
848         if (address(locker) != address(0)) {
849             locker.lockOrGetPenalty(sender, recipient);
850         }
851         return super._transfer(sender, recipient, amount);
852     }
853 
854     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner.
855     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
856         _mint(_to, _amount);
857         _moveDelegates(address(0), _delegates[_to], _amount);
858         return true;
859     }
860 
861     // Copied and modified from YAM code:
862     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
863     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
864     // Which is copied and modified from COMPOUND:
865     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
866 
867     /// @dev A record of each accounts delegate
868     mapping (address => address) internal _delegates;
869 
870     /// @notice A checkpoint for marking number of votes from a given block
871     struct Checkpoint {
872         uint32 fromBlock;
873         uint256 votes;
874     }
875 
876     /// @notice A record of votes checkpoints for each account, by index
877     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
878 
879     /// @notice The number of checkpoints for each account
880     mapping (address => uint32) public numCheckpoints;
881 
882     /// @notice The EIP-712 typehash for the contract's domain
883     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
884 
885     /// @notice The EIP-712 typehash for the delegation struct used by the contract
886     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
887 
888     /// @notice A record of states for signing / validating signatures
889     mapping (address => uint) public nonces;
890 
891       /// @notice An event thats emitted when an account changes its delegate
892     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
893 
894     /// @notice An event thats emitted when a delegate account's vote balance changes
895     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
896 
897     /**
898      * @notice Delegate votes from `msg.sender` to `delegatee`
899      * @param delegator The address to get delegatee for
900      */
901     function delegates(address delegator)
902         external
903         view
904         returns (address)
905     {
906         return _delegates[delegator];
907     }
908 
909    /**
910     * @notice Delegate votes from `msg.sender` to `delegatee`
911     * @param delegatee The address to delegate votes to
912     */
913     function delegate(address delegatee) external {
914         return _delegate(msg.sender, delegatee);
915     }
916 
917     /**
918      * @notice Delegates votes from signatory to `delegatee`
919      * @param delegatee The address to delegate votes to
920      * @param nonce The contract state required to match the signature
921      * @param expiry The time at which to expire the signature
922      * @param v The recovery byte of the signature
923      * @param r Half of the ECDSA signature pair
924      * @param s Half of the ECDSA signature pair
925      */
926     function delegateBySig(
927         address delegatee,
928         uint nonce,
929         uint expiry,
930         uint8 v,
931         bytes32 r,
932         bytes32 s
933     )
934         external
935     {
936         bytes32 domainSeparator = keccak256(
937             abi.encode(
938                 DOMAIN_TYPEHASH,
939                 keccak256(bytes(name())),
940                 getChainId(),
941                 address(this)
942             )
943         );
944 
945         bytes32 structHash = keccak256(
946             abi.encode(
947                 DELEGATION_TYPEHASH,
948                 delegatee,
949                 nonce,
950                 expiry
951             )
952         );
953 
954         bytes32 digest = keccak256(
955             abi.encodePacked(
956                 "\x19\x01",
957                 domainSeparator,
958                 structHash
959             )
960         );
961 
962         address signatory = ecrecover(digest, v, r, s);
963         require(signatory != address(0), "GenShards::delegateBySig: invalid signature");
964         require(nonce == nonces[signatory]++, "GenShards::delegateBySig: invalid nonce");
965         require(now <= expiry, "GenShards::delegateBySig: signature expired");
966         return _delegate(signatory, delegatee);
967     }
968 
969     /**
970      * @notice Gets the current votes balance for `account`
971      * @param account The address to get votes balance
972      * @return The number of current votes for `account`
973      */
974     function getCurrentVotes(address account)
975         external
976         view
977         returns (uint256)
978     {
979         uint32 nCheckpoints = numCheckpoints[account];
980         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
981     }
982 
983     /**
984      * @notice Determine the prior number of votes for an account as of a block number
985      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
986      * @param account The address of the account to check
987      * @param blockNumber The block number to get the vote balance at
988      * @return The number of votes the account had as of the given block
989      */
990     function getPriorVotes(address account, uint blockNumber)
991         external
992         view
993         returns (uint256)
994     {
995         require(blockNumber < block.number, "GenShards::getPriorVotes: not yet determined");
996 
997         uint32 nCheckpoints = numCheckpoints[account];
998         if (nCheckpoints == 0) {
999             return 0;
1000         }
1001 
1002         // First check most recent balance
1003         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1004             return checkpoints[account][nCheckpoints - 1].votes;
1005         }
1006 
1007         // Next check implicit zero balance
1008         if (checkpoints[account][0].fromBlock > blockNumber) {
1009             return 0;
1010         }
1011 
1012         uint32 lower = 0;
1013         uint32 upper = nCheckpoints - 1;
1014         while (upper > lower) {
1015             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1016             Checkpoint memory cp = checkpoints[account][center];
1017             if (cp.fromBlock == blockNumber) {
1018                 return cp.votes;
1019             } else if (cp.fromBlock < blockNumber) {
1020                 lower = center;
1021             } else {
1022                 upper = center - 1;
1023             }
1024         }
1025         return checkpoints[account][lower].votes;
1026     }
1027 
1028     function _delegate(address delegator, address delegatee)
1029         internal
1030     {
1031         address currentDelegate = _delegates[delegator];
1032         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying GS (not scaled);
1033         _delegates[delegator] = delegatee;
1034 
1035         emit DelegateChanged(delegator, currentDelegate, delegatee);
1036 
1037         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1038     }
1039 
1040     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1041         if (srcRep != dstRep && amount > 0) {
1042             if (srcRep != address(0)) {
1043                 // decrease old representative
1044                 uint32 srcRepNum = numCheckpoints[srcRep];
1045                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1046                 uint256 srcRepNew = srcRepOld.sub(amount);
1047                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1048             }
1049 
1050             if (dstRep != address(0)) {
1051                 // increase new representative
1052                 uint32 dstRepNum = numCheckpoints[dstRep];
1053                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1054                 uint256 dstRepNew = dstRepOld.add(amount);
1055                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1056             }
1057         }
1058     }
1059 
1060     function _writeCheckpoint(
1061         address delegatee,
1062         uint32 nCheckpoints,
1063         uint256 oldVotes,
1064         uint256 newVotes
1065     )
1066         internal
1067     {
1068         uint32 blockNumber = safe32(block.number, "GenShards::_writeCheckpoint: block number exceeds 32 bits");
1069 
1070         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1071             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1072         } else {
1073             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1074             numCheckpoints[delegatee] = nCheckpoints + 1;
1075         }
1076 
1077         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1078     }
1079 
1080     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1081         require(n < 2**32, errorMessage);
1082         return uint32(n);
1083     }
1084 
1085     function getChainId() internal pure returns (uint) {
1086         uint256 chainId;
1087         assembly { chainId := chainid() }
1088         return chainId;
1089     }
1090 
1091     /**
1092      * @dev See {ERC20-_beforeTokenTransfer}.
1093      */
1094     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1095         super._beforeTokenTransfer(from, to, amount);
1096     }
1097 }