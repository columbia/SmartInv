1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
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
26 pragma solidity ^0.7.0;
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 pragma solidity ^0.7.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, with an overflow flag.
120      *
121      * _Available since v3.4._
122      */
123     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
124         uint256 c = a + b;
125         if (c < a) return (false, 0);
126         return (true, c);
127     }
128 
129     /**
130      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         if (b > a) return (false, 0);
136         return (true, a - b);
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) return (true, 0);
149         uint256 c = a * b;
150         if (c / a != b) return (false, 0);
151         return (true, c);
152     }
153 
154     /**
155      * @dev Returns the division of two unsigned integers, with a division by zero flag.
156      *
157      * _Available since v3.4._
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         if (b == 0) return (false, 0);
161         return (true, a / b);
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a % b);
172     }
173 
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187         return c;
188     }
189 
190     /**
191      * @dev Returns the subtraction of two unsigned integers, reverting on
192      * overflow (when the result is negative).
193      *
194      * Counterpart to Solidity's `-` operator.
195      *
196      * Requirements:
197      *
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b <= a, "SafeMath: subtraction overflow");
202         return a - b;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         if (a == 0) return 0;
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers, reverting on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         require(b > 0, "SafeMath: division by zero");
236         return a / b;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * reverting when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: modulo by zero");
253         return a % b;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
258      * overflow (when the result is negative).
259      *
260      * CAUTION: This function is deprecated because it requires allocating memory for the error
261      * message unnecessarily. For custom revert reasons use {trySub}.
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b <= a, errorMessage);
271         return a - b;
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * CAUTION: This function is deprecated because it requires allocating memory for the error
279      * message unnecessarily. For custom revert reasons use {tryDiv}.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         require(b > 0, errorMessage);
291         return a / b;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * reverting with custom message when dividing by zero.
297      *
298      * CAUTION: This function is deprecated because it requires allocating memory for the error
299      * message unnecessarily. For custom revert reasons use {tryMod}.
300      *
301      * Counterpart to Solidity's `%` operator. This function uses a `revert`
302      * opcode (which leaves remaining gas untouched) while Solidity uses an
303      * invalid opcode to revert (consuming all remaining gas).
304      *
305      * Requirements:
306      *
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b > 0, errorMessage);
311         return a % b;
312     }
313 }
314 
315 pragma solidity ^0.7.0;
316 
317 
318 
319 /**
320  * @dev Implementation of the {IERC20} interface.
321  *
322  * This implementation is agnostic to the way tokens are created. This means
323  * that a supply mechanism has to be added in a derived contract using {_mint}.
324  * For a generic mechanism see {ERC20PresetMinterPauser}.
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
343 contract ERC20 is Context, IERC20 {
344     using SafeMath for uint256;
345 
346     mapping (address => uint256) private _balances;
347 
348     mapping (address => mapping (address => uint256)) private _allowances;
349 
350     uint256 private _totalSupply;
351 
352     string private _name;
353     string private _symbol;
354     uint8 private _decimals;
355 
356     /**
357      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
358      * a default value of 18.
359      *
360      * To select a different value for {decimals}, use {_setupDecimals}.
361      *
362      * All three of these values are immutable: they can only be set once during
363      * construction.
364      */
365     constructor (string memory name_, string memory symbol_) {
366         _name = name_;
367         _symbol = symbol_;
368         _decimals = 18;
369     }
370 
371     /**
372      * @dev Returns the name of the token.
373      */
374     function name() public view virtual returns (string memory) {
375         return _name;
376     }
377 
378     /**
379      * @dev Returns the symbol of the token, usually a shorter version of the
380      * name.
381      */
382     function symbol() public view virtual returns (string memory) {
383         return _symbol;
384     }
385 
386     /**
387      * @dev Returns the number of decimals used to get its user representation.
388      * For example, if `decimals` equals `2`, a balance of `505` tokens should
389      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
390      *
391      * Tokens usually opt for a value of 18, imitating the relationship between
392      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
393      * called.
394      *
395      * NOTE: This information is only used for _display_ purposes: it in
396      * no way affects any of the arithmetic of the contract, including
397      * {IERC20-balanceOf} and {IERC20-transfer}.
398      */
399     function decimals() public view virtual returns (uint8) {
400         return _decimals;
401     }
402 
403     /**
404      * @dev See {IERC20-totalSupply}.
405      */
406     function totalSupply() public view virtual override returns (uint256) {
407         return _totalSupply;
408     }
409 
410     /**
411      * @dev See {IERC20-balanceOf}.
412      */
413     function balanceOf(address account) public view virtual override returns (uint256) {
414         return _balances[account];
415     }
416 
417     /**
418      * @dev See {IERC20-transfer}.
419      *
420      * Requirements:
421      *
422      * - `recipient` cannot be the zero address.
423      * - the caller must have a balance of at least `amount`.
424      */
425     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
426         _transfer(_msgSender(), recipient, amount);
427         return true;
428     }
429 
430     /**
431      * @dev See {IERC20-allowance}.
432      */
433     function allowance(address owner, address spender) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function approve(address spender, uint256 amount) public virtual override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20}.
454      *
455      * Requirements:
456      *
457      * - `sender` and `recipient` cannot be the zero address.
458      * - `sender` must have a balance of at least `amount`.
459      * - the caller must have allowance for ``sender``'s tokens of at least
460      * `amount`.
461      */
462     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
463         _transfer(sender, recipient, amount);
464         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
465         return true;
466     }
467 
468     /**
469      * @dev Atomically increases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      */
480     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
481         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically decreases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      * - `spender` must have allowance for the caller of at least
497      * `subtractedValue`.
498      */
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504     /**
505      * @dev Moves tokens `amount` from `sender` to `recipient`.
506      *
507      * This is internal function is equivalent to {transfer}, and can be used to
508      * e.g. implement automatic token fees, slashing mechanisms, etc.
509      *
510      * Emits a {Transfer} event.
511      *
512      * Requirements:
513      *
514      * - `sender` cannot be the zero address.
515      * - `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      */
518     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
519         require(sender != address(0), "ERC20: transfer from the zero address");
520         require(recipient != address(0), "ERC20: transfer to the zero address");
521 
522         _beforeTokenTransfer(sender, recipient, amount);
523 
524         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
525         _balances[recipient] = _balances[recipient].add(amount);
526         emit Transfer(sender, recipient, amount);
527     }
528 
529     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
530      * the total supply.
531      *
532      * Emits a {Transfer} event with `from` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `to` cannot be the zero address.
537      */
538     function _mint(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: mint to the zero address");
540 
541         _beforeTokenTransfer(address(0), account, amount);
542 
543         _totalSupply = _totalSupply.add(amount);
544         _balances[account] = _balances[account].add(amount);
545         emit Transfer(address(0), account, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a {Transfer} event with `to` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: burn from the zero address");
561 
562         _beforeTokenTransfer(account, address(0), amount);
563 
564         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
565         _totalSupply = _totalSupply.sub(amount);
566         emit Transfer(account, address(0), amount);
567     }
568 
569     /**
570      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
571      *
572      * This internal function is equivalent to `approve`, and can be used to
573      * e.g. set automatic allowances for certain subsystems, etc.
574      *
575      * Emits an {Approval} event.
576      *
577      * Requirements:
578      *
579      * - `owner` cannot be the zero address.
580      * - `spender` cannot be the zero address.
581      */
582     function _approve(address owner, address spender, uint256 amount) internal virtual {
583         require(owner != address(0), "ERC20: approve from the zero address");
584         require(spender != address(0), "ERC20: approve to the zero address");
585 
586         _allowances[owner][spender] = amount;
587         emit Approval(owner, spender, amount);
588     }
589 
590     /**
591      * @dev Sets {decimals} to a value other than the default one of 18.
592      *
593      * WARNING: This function should only be called from the constructor. Most
594      * applications that interact with token contracts will not expect
595      * {decimals} to ever change, and may work incorrectly if it does.
596      */
597     function _setupDecimals(uint8 decimals_) internal virtual {
598         _decimals = decimals_;
599     }
600 
601     /**
602      * @dev Hook that is called before any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * will be to transferred to `to`.
609      * - when `from` is zero, `amount` tokens will be minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
616 }
617 
618 
619 pragma solidity ^0.7.0;
620 
621 
622 /**
623  * @dev Extension of {ERC20} that allows token holders to destroy both their own
624  * tokens and those that they have an allowance for, in a way that can be
625  * recognized off-chain (via event analysis).
626  */
627 abstract contract ERC20Burnable is Context, ERC20 {
628     using SafeMath for uint256;
629 
630     /**
631      * @dev Destroys `amount` tokens from the caller.
632      *
633      * See {ERC20-_burn}.
634      */
635     function burn(uint256 amount) public virtual {
636         _burn(_msgSender(), amount);
637     }
638 
639     /**
640      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
641      * allowance.
642      *
643      * See {ERC20-_burn} and {ERC20-allowance}.
644      *
645      * Requirements:
646      *
647      * - the caller must have allowance for ``accounts``'s tokens of at least
648      * `amount`.
649      */
650     function burnFrom(address account, uint256 amount) public virtual {
651         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
652 
653         _approve(account, _msgSender(), decreasedAllowance);
654         _burn(account, amount);
655     }
656 }
657 
658 
659 pragma solidity ^0.7.0;
660 
661 /**
662  * @dev Contract module which provides a basic access control mechanism, where
663  * there is an account (an owner) that can be granted exclusive access to
664  * specific functions.
665  *
666  * By default, the owner account will be the one that deploys the contract. This
667  * can later be changed with {transferOwnership}.
668  *
669  * This module is used through inheritance. It will make available the modifier
670  * `onlyOwner`, which can be applied to your functions to restrict their use to
671  * the owner.
672  */
673 abstract contract Ownable is Context {
674     address private _owner;
675 
676     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
677 
678     /**
679      * @dev Initializes the contract setting the deployer as the initial owner.
680      */
681     constructor () {
682         address msgSender = _msgSender();
683         _owner = msgSender;
684         emit OwnershipTransferred(address(0), msgSender);
685     }
686 
687     /**
688      * @dev Returns the address of the current owner.
689      */
690     function owner() public view virtual returns (address) {
691         return _owner;
692     }
693 
694     /**
695      * @dev Throws if called by any account other than the owner.
696      */
697     modifier onlyOwner() {
698         require(owner() == _msgSender(), "Ownable: caller is not the owner");
699         _;
700     }
701 
702     /**
703      * @dev Leaves the contract without owner. It will not be possible to call
704      * `onlyOwner` functions anymore. Can only be called by the current owner.
705      *
706      * NOTE: Renouncing ownership will leave the contract without an owner,
707      * thereby removing any functionality that is only available to the owner.
708      */
709     function renounceOwnership() public virtual onlyOwner {
710         emit OwnershipTransferred(_owner, address(0));
711         _owner = address(0);
712     }
713 
714     /**
715      * @dev Transfers ownership of the contract to a new account (`newOwner`).
716      * Can only be called by the current owner.
717      */
718     function transferOwnership(address newOwner) public virtual onlyOwner {
719         require(newOwner != address(0), "Ownable: new owner is the zero address");
720         emit OwnershipTransferred(_owner, newOwner);
721         _owner = newOwner;
722     }
723 }
724 
725 pragma solidity 0.7.6;
726 
727 
728 contract DARTToken is Context, Ownable, ERC20Burnable {
729     string public constant NAME = "dART Token";
730     string public constant SYMBOL = "dART";
731     uint8 public constant DECIMALS = 18;
732     uint256 public constant TOTAL_SUPPLY = 142090000 * (10**uint256(DECIMALS));
733 
734     address public SeedInvestmentAddr;
735     address public PrivateSaleAddr;
736     address public StakingRewardsAddr;
737     address public LiquidityPoolAddr;
738     address public MarketingAddr;
739     address public TreasuryAddr;
740     address public TeamAllocationAddr;
741     address public AdvisorsAddr;
742     address public ReserveAddr;
743 
744     uint256 public constant SEED_INVESTMENT = 3000000 * (10**uint256(DECIMALS)); // 2.1% for Seed investment
745     uint256 public constant PRIVATE_SALE = 15000000 * (10**uint256(DECIMALS)); // 10.6% for Private Sale
746 
747     uint256 public constant STAKING_REWARDS = 24500000 * (10**uint256(DECIMALS)); // 17.2% for Staking rewards
748     
749     uint256 public constant LIQUIDITY_POOL = 9000000 * (10**uint256(DECIMALS)); // 6.3% for Liquidity pool
750 
751     uint256 public constant MARKETING = 14000000 * (10**uint256(DECIMALS)); // 9.9% for Marketing/Listings
752     uint256 public constant TREASURY = 19600000 * (10**uint256(DECIMALS)); // 13.8% for Treasury
753 
754     uint256 public constant TEAM_ALLOCATION = 17000000 * (10**uint256(DECIMALS)); // 12% for Team allocation
755     uint256 public constant ADVISORS = 5000000 * (10**uint256(DECIMALS)); // 3.5% for Advisors
756 
757     uint256 public constant RESERVE = 34990000 * (10**uint256(DECIMALS)); // 24.6% for Bridge consumption
758 
759     bool private _isDistributionComplete = false;
760 
761     constructor()
762         ERC20(NAME, SYMBOL)
763     {
764         _mint(address(this), TOTAL_SUPPLY);
765     }
766 
767     function setDistributionTeamsAddresses(
768         address _SeedInvestmentAddr,
769         address _PrivateSaleAddr,
770         address _StakingRewardsAddr,
771         address _LiquidityPoolAddr,
772         address _MarketingAddr,
773         address _TreasuryAddr,
774         address _TeamAllocationAddr,
775         address _AdvisorsAddr,
776         address _ReserveAddr
777     ) external onlyOwner {
778         require(!_isDistributionComplete, "Already distributed");
779 
780         // set parnters addresses
781         SeedInvestmentAddr = _SeedInvestmentAddr;
782         PrivateSaleAddr = _PrivateSaleAddr;
783         StakingRewardsAddr = _StakingRewardsAddr;
784         LiquidityPoolAddr = _LiquidityPoolAddr;
785         MarketingAddr = _MarketingAddr;
786         TreasuryAddr = _TreasuryAddr;
787         TeamAllocationAddr = _TeamAllocationAddr;
788         AdvisorsAddr = _AdvisorsAddr;
789         ReserveAddr = _ReserveAddr;
790     }
791 
792     function distributeTokens() external onlyOwner {
793         require(!_isDistributionComplete, "Already distributed");
794 
795         _transfer(address(this), SeedInvestmentAddr, SEED_INVESTMENT);
796         _transfer(address(this), PrivateSaleAddr, PRIVATE_SALE);
797         _transfer(address(this), StakingRewardsAddr, STAKING_REWARDS);
798         _transfer(address(this), LiquidityPoolAddr, LIQUIDITY_POOL);
799         _transfer(address(this), MarketingAddr, MARKETING);
800         _transfer(address(this), TreasuryAddr, TREASURY);
801         _transfer(address(this), TeamAllocationAddr, TEAM_ALLOCATION);
802         _transfer(address(this), AdvisorsAddr, ADVISORS);
803         _transfer(address(this), ReserveAddr, RESERVE);
804 
805         _isDistributionComplete = true;
806     }
807 }