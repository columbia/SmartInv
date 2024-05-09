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
633 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
634 
635 
636 
637 pragma solidity >=0.6.0 <0.8.0;
638 
639 
640 /**
641  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
642  */
643 abstract contract ERC20Capped is ERC20 {
644     using SafeMath for uint256;
645 
646     uint256 private _cap;
647 
648     /**
649      * @dev Sets the value of the `cap`. This value is immutable, it can only be
650      * set once during construction.
651      */
652     constructor (uint256 cap_) internal {
653         require(cap_ > 0, "ERC20Capped: cap is 0");
654         _cap = cap_;
655     }
656 
657     /**
658      * @dev Returns the cap on the token's total supply.
659      */
660     function cap() public view virtual returns (uint256) {
661         return _cap;
662     }
663 
664     /**
665      * @dev See {ERC20-_beforeTokenTransfer}.
666      *
667      * Requirements:
668      *
669      * - minted tokens must not cause the total supply to go over the cap.
670      */
671     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
672         super._beforeTokenTransfer(from, to, amount);
673 
674         if (from == address(0)) { // When minting tokens
675             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
676         }
677     }
678 }
679 
680 // File: @openzeppelin/contracts/access/Ownable.sol
681 
682 
683 
684 pragma solidity >=0.6.0 <0.8.0;
685 
686 /**
687  * @dev Contract module which provides a basic access control mechanism, where
688  * there is an account (an owner) that can be granted exclusive access to
689  * specific functions.
690  *
691  * By default, the owner account will be the one that deploys the contract. This
692  * can later be changed with {transferOwnership}.
693  *
694  * This module is used through inheritance. It will make available the modifier
695  * `onlyOwner`, which can be applied to your functions to restrict their use to
696  * the owner.
697  */
698 abstract contract Ownable is Context {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev Initializes the contract setting the deployer as the initial owner.
705      */
706     constructor () internal {
707         address msgSender = _msgSender();
708         _owner = msgSender;
709         emit OwnershipTransferred(address(0), msgSender);
710     }
711 
712     /**
713      * @dev Returns the address of the current owner.
714      */
715     function owner() public view virtual returns (address) {
716         return _owner;
717     }
718 
719     /**
720      * @dev Throws if called by any account other than the owner.
721      */
722     modifier onlyOwner() {
723         require(owner() == _msgSender(), "Ownable: caller is not the owner");
724         _;
725     }
726 
727     /**
728      * @dev Leaves the contract without owner. It will not be possible to call
729      * `onlyOwner` functions anymore. Can only be called by the current owner.
730      *
731      * NOTE: Renouncing ownership will leave the contract without an owner,
732      * thereby removing any functionality that is only available to the owner.
733      */
734     function renounceOwnership() public virtual onlyOwner {
735         emit OwnershipTransferred(_owner, address(0));
736         _owner = address(0);
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Can only be called by the current owner.
742      */
743     function transferOwnership(address newOwner) public virtual onlyOwner {
744         require(newOwner != address(0), "Ownable: new owner is the zero address");
745         emit OwnershipTransferred(_owner, newOwner);
746         _owner = newOwner;
747     }
748 }
749 
750 // File: @openzeppelin/contracts/introspection/IERC165.sol
751 
752 
753 
754 pragma solidity >=0.6.0 <0.8.0;
755 
756 /**
757  * @dev Interface of the ERC165 standard, as defined in the
758  * https://eips.ethereum.org/EIPS/eip-165[EIP].
759  *
760  * Implementers can declare support of contract interfaces, which can then be
761  * queried by others ({ERC165Checker}).
762  *
763  * For an implementation, see {ERC165}.
764  */
765 interface IERC165 {
766     /**
767      * @dev Returns true if this contract implements the interface defined by
768      * `interfaceId`. See the corresponding
769      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
770      * to learn more about how these ids are created.
771      *
772      * This function call must use less than 30 000 gas.
773      */
774     function supportsInterface(bytes4 interfaceId) external view returns (bool);
775 }
776 
777 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
778 
779 
780 
781 pragma solidity >=0.6.2 <0.8.0;
782 
783 
784 /**
785  * @dev Required interface of an ERC721 compliant contract.
786  */
787 interface IERC721 is IERC165 {
788     /**
789      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
790      */
791     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
792 
793     /**
794      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
795      */
796     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
797 
798     /**
799      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
800      */
801     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
802 
803     /**
804      * @dev Returns the number of tokens in ``owner``'s account.
805      */
806     function balanceOf(address owner) external view returns (uint256 balance);
807 
808     /**
809      * @dev Returns the owner of the `tokenId` token.
810      *
811      * Requirements:
812      *
813      * - `tokenId` must exist.
814      */
815     function ownerOf(uint256 tokenId) external view returns (address owner);
816 
817     /**
818      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
819      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must exist and be owned by `from`.
826      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
827      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
828      *
829      * Emits a {Transfer} event.
830      */
831     function safeTransferFrom(address from, address to, uint256 tokenId) external;
832 
833     /**
834      * @dev Transfers `tokenId` token from `from` to `to`.
835      *
836      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
844      *
845      * Emits a {Transfer} event.
846      */
847     function transferFrom(address from, address to, uint256 tokenId) external;
848 
849     /**
850      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
851      * The approval is cleared when the token is transferred.
852      *
853      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
854      *
855      * Requirements:
856      *
857      * - The caller must own the token or be an approved operator.
858      * - `tokenId` must exist.
859      *
860      * Emits an {Approval} event.
861      */
862     function approve(address to, uint256 tokenId) external;
863 
864     /**
865      * @dev Returns the account approved for `tokenId` token.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      */
871     function getApproved(uint256 tokenId) external view returns (address operator);
872 
873     /**
874      * @dev Approve or remove `operator` as an operator for the caller.
875      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
876      *
877      * Requirements:
878      *
879      * - The `operator` cannot be the caller.
880      *
881      * Emits an {ApprovalForAll} event.
882      */
883     function setApprovalForAll(address operator, bool _approved) external;
884 
885     /**
886      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
887      *
888      * See {setApprovalForAll}
889      */
890     function isApprovedForAll(address owner, address operator) external view returns (bool);
891 
892     /**
893       * @dev Safely transfers `tokenId` token from `from` to `to`.
894       *
895       * Requirements:
896       *
897       * - `from` cannot be the zero address.
898       * - `to` cannot be the zero address.
899       * - `tokenId` token must exist and be owned by `from`.
900       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
901       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902       *
903       * Emits a {Transfer} event.
904       */
905     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
909 
910 
911 
912 pragma solidity >=0.6.2 <0.8.0;
913 
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Metadata is IERC721 {
920 
921     /**
922      * @dev Returns the token collection name.
923      */
924     function name() external view returns (string memory);
925 
926     /**
927      * @dev Returns the token collection symbol.
928      */
929     function symbol() external view returns (string memory);
930 
931     /**
932      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
933      */
934     function tokenURI(uint256 tokenId) external view returns (string memory);
935 }
936 
937 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
938 
939 
940 
941 pragma solidity >=0.6.2 <0.8.0;
942 
943 
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Enumerable is IERC721 {
949 
950     /**
951      * @dev Returns the total amount of tokens stored by the contract.
952      */
953     function totalSupply() external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
957      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
958      */
959     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
960 
961     /**
962      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
963      * Use along with {totalSupply} to enumerate all tokens.
964      */
965     function tokenByIndex(uint256 index) external view returns (uint256);
966 }
967 
968 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
969 
970 
971 
972 pragma solidity >=0.6.0 <0.8.0;
973 
974 /**
975  * @title ERC721 token receiver interface
976  * @dev Interface for any contract that wants to support safeTransfers
977  * from ERC721 asset contracts.
978  */
979 interface IERC721Receiver {
980     /**
981      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
982      * by `operator` from `from`, this function is called.
983      *
984      * It must return its Solidity selector to confirm the token transfer.
985      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
986      *
987      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
988      */
989     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
990 }
991 
992 // File: @openzeppelin/contracts/introspection/ERC165.sol
993 
994 
995 
996 pragma solidity >=0.6.0 <0.8.0;
997 
998 
999 /**
1000  * @dev Implementation of the {IERC165} interface.
1001  *
1002  * Contracts may inherit from this and call {_registerInterface} to declare
1003  * their support of an interface.
1004  */
1005 abstract contract ERC165 is IERC165 {
1006     /*
1007      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1008      */
1009     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1010 
1011     /**
1012      * @dev Mapping of interface ids to whether or not it's supported.
1013      */
1014     mapping(bytes4 => bool) private _supportedInterfaces;
1015 
1016     constructor () internal {
1017         // Derived contracts need only register support for their own interfaces,
1018         // we register support for ERC165 itself here
1019         _registerInterface(_INTERFACE_ID_ERC165);
1020     }
1021 
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      *
1025      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1028         return _supportedInterfaces[interfaceId];
1029     }
1030 
1031     /**
1032      * @dev Registers the contract as an implementer of the interface defined by
1033      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1034      * registering its interface id is not required.
1035      *
1036      * See {IERC165-supportsInterface}.
1037      *
1038      * Requirements:
1039      *
1040      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1041      */
1042     function _registerInterface(bytes4 interfaceId) internal virtual {
1043         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1044         _supportedInterfaces[interfaceId] = true;
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts/utils/Address.sol
1049 
1050 
1051 
1052 pragma solidity >=0.6.2 <0.8.0;
1053 
1054 /**
1055  * @dev Collection of functions related to the address type
1056  */
1057 library Address {
1058     /**
1059      * @dev Returns true if `account` is a contract.
1060      *
1061      * [IMPORTANT]
1062      * ====
1063      * It is unsafe to assume that an address for which this function returns
1064      * false is an externally-owned account (EOA) and not a contract.
1065      *
1066      * Among others, `isContract` will return false for the following
1067      * types of addresses:
1068      *
1069      *  - an externally-owned account
1070      *  - a contract in construction
1071      *  - an address where a contract will be created
1072      *  - an address where a contract lived, but was destroyed
1073      * ====
1074      */
1075     function isContract(address account) internal view returns (bool) {
1076         // This method relies on extcodesize, which returns 0 for contracts in
1077         // construction, since the code is only stored at the end of the
1078         // constructor execution.
1079 
1080         uint256 size;
1081         // solhint-disable-next-line no-inline-assembly
1082         assembly { size := extcodesize(account) }
1083         return size > 0;
1084     }
1085 
1086     /**
1087      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1088      * `recipient`, forwarding all available gas and reverting on errors.
1089      *
1090      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1091      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1092      * imposed by `transfer`, making them unable to receive funds via
1093      * `transfer`. {sendValue} removes this limitation.
1094      *
1095      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1096      *
1097      * IMPORTANT: because control is transferred to `recipient`, care must be
1098      * taken to not create reentrancy vulnerabilities. Consider using
1099      * {ReentrancyGuard} or the
1100      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1101      */
1102     function sendValue(address payable recipient, uint256 amount) internal {
1103         require(address(this).balance >= amount, "Address: insufficient balance");
1104 
1105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1106         (bool success, ) = recipient.call{ value: amount }("");
1107         require(success, "Address: unable to send value, recipient may have reverted");
1108     }
1109 
1110     /**
1111      * @dev Performs a Solidity function call using a low level `call`. A
1112      * plain`call` is an unsafe replacement for a function call: use this
1113      * function instead.
1114      *
1115      * If `target` reverts with a revert reason, it is bubbled up by this
1116      * function (like regular Solidity function calls).
1117      *
1118      * Returns the raw returned data. To convert to the expected return value,
1119      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1120      *
1121      * Requirements:
1122      *
1123      * - `target` must be a contract.
1124      * - calling `target` with `data` must not revert.
1125      *
1126      * _Available since v3.1._
1127      */
1128     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1129       return functionCall(target, data, "Address: low-level call failed");
1130     }
1131 
1132     /**
1133      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1134      * `errorMessage` as a fallback revert reason when `target` reverts.
1135      *
1136      * _Available since v3.1._
1137      */
1138     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1139         return functionCallWithValue(target, data, 0, errorMessage);
1140     }
1141 
1142     /**
1143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1144      * but also transferring `value` wei to `target`.
1145      *
1146      * Requirements:
1147      *
1148      * - the calling contract must have an ETH balance of at least `value`.
1149      * - the called Solidity function must be `payable`.
1150      *
1151      * _Available since v3.1._
1152      */
1153     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1154         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1155     }
1156 
1157     /**
1158      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1159      * with `errorMessage` as a fallback revert reason when `target` reverts.
1160      *
1161      * _Available since v3.1._
1162      */
1163     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1164         require(address(this).balance >= value, "Address: insufficient balance for call");
1165         require(isContract(target), "Address: call to non-contract");
1166 
1167         // solhint-disable-next-line avoid-low-level-calls
1168         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1169         return _verifyCallResult(success, returndata, errorMessage);
1170     }
1171 
1172     /**
1173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1174      * but performing a static call.
1175      *
1176      * _Available since v3.3._
1177      */
1178     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1179         return functionStaticCall(target, data, "Address: low-level static call failed");
1180     }
1181 
1182     /**
1183      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1184      * but performing a static call.
1185      *
1186      * _Available since v3.3._
1187      */
1188     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1189         require(isContract(target), "Address: static call to non-contract");
1190 
1191         // solhint-disable-next-line avoid-low-level-calls
1192         (bool success, bytes memory returndata) = target.staticcall(data);
1193         return _verifyCallResult(success, returndata, errorMessage);
1194     }
1195 
1196     /**
1197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1198      * but performing a delegate call.
1199      *
1200      * _Available since v3.4._
1201      */
1202     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1203         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1204     }
1205 
1206     /**
1207      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1208      * but performing a delegate call.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1213         require(isContract(target), "Address: delegate call to non-contract");
1214 
1215         // solhint-disable-next-line avoid-low-level-calls
1216         (bool success, bytes memory returndata) = target.delegatecall(data);
1217         return _verifyCallResult(success, returndata, errorMessage);
1218     }
1219 
1220     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1221         if (success) {
1222             return returndata;
1223         } else {
1224             // Look for revert reason and bubble it up if present
1225             if (returndata.length > 0) {
1226                 // The easiest way to bubble the revert reason is using memory via assembly
1227 
1228                 // solhint-disable-next-line no-inline-assembly
1229                 assembly {
1230                     let returndata_size := mload(returndata)
1231                     revert(add(32, returndata), returndata_size)
1232                 }
1233             } else {
1234                 revert(errorMessage);
1235             }
1236         }
1237     }
1238 }
1239 
1240 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1241 
1242 
1243 
1244 pragma solidity >=0.6.0 <0.8.0;
1245 
1246 /**
1247  * @dev Library for managing
1248  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1249  * types.
1250  *
1251  * Sets have the following properties:
1252  *
1253  * - Elements are added, removed, and checked for existence in constant time
1254  * (O(1)).
1255  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1256  *
1257  * ```
1258  * contract Example {
1259  *     // Add the library methods
1260  *     using EnumerableSet for EnumerableSet.AddressSet;
1261  *
1262  *     // Declare a set state variable
1263  *     EnumerableSet.AddressSet private mySet;
1264  * }
1265  * ```
1266  *
1267  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1268  * and `uint256` (`UintSet`) are supported.
1269  */
1270 library EnumerableSet {
1271     // To implement this library for multiple types with as little code
1272     // repetition as possible, we write it in terms of a generic Set type with
1273     // bytes32 values.
1274     // The Set implementation uses private functions, and user-facing
1275     // implementations (such as AddressSet) are just wrappers around the
1276     // underlying Set.
1277     // This means that we can only create new EnumerableSets for types that fit
1278     // in bytes32.
1279 
1280     struct Set {
1281         // Storage of set values
1282         bytes32[] _values;
1283 
1284         // Position of the value in the `values` array, plus 1 because index 0
1285         // means a value is not in the set.
1286         mapping (bytes32 => uint256) _indexes;
1287     }
1288 
1289     /**
1290      * @dev Add a value to a set. O(1).
1291      *
1292      * Returns true if the value was added to the set, that is if it was not
1293      * already present.
1294      */
1295     function _add(Set storage set, bytes32 value) private returns (bool) {
1296         if (!_contains(set, value)) {
1297             set._values.push(value);
1298             // The value is stored at length-1, but we add 1 to all indexes
1299             // and use 0 as a sentinel value
1300             set._indexes[value] = set._values.length;
1301             return true;
1302         } else {
1303             return false;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Removes a value from a set. O(1).
1309      *
1310      * Returns true if the value was removed from the set, that is if it was
1311      * present.
1312      */
1313     function _remove(Set storage set, bytes32 value) private returns (bool) {
1314         // We read and store the value's index to prevent multiple reads from the same storage slot
1315         uint256 valueIndex = set._indexes[value];
1316 
1317         if (valueIndex != 0) { // Equivalent to contains(set, value)
1318             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1319             // the array, and then remove the last element (sometimes called as 'swap and pop').
1320             // This modifies the order of the array, as noted in {at}.
1321 
1322             uint256 toDeleteIndex = valueIndex - 1;
1323             uint256 lastIndex = set._values.length - 1;
1324 
1325             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1326             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1327 
1328             bytes32 lastvalue = set._values[lastIndex];
1329 
1330             // Move the last value to the index where the value to delete is
1331             set._values[toDeleteIndex] = lastvalue;
1332             // Update the index for the moved value
1333             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1334 
1335             // Delete the slot where the moved value was stored
1336             set._values.pop();
1337 
1338             // Delete the index for the deleted slot
1339             delete set._indexes[value];
1340 
1341             return true;
1342         } else {
1343             return false;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Returns true if the value is in the set. O(1).
1349      */
1350     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1351         return set._indexes[value] != 0;
1352     }
1353 
1354     /**
1355      * @dev Returns the number of values on the set. O(1).
1356      */
1357     function _length(Set storage set) private view returns (uint256) {
1358         return set._values.length;
1359     }
1360 
1361    /**
1362     * @dev Returns the value stored at position `index` in the set. O(1).
1363     *
1364     * Note that there are no guarantees on the ordering of values inside the
1365     * array, and it may change when more values are added or removed.
1366     *
1367     * Requirements:
1368     *
1369     * - `index` must be strictly less than {length}.
1370     */
1371     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1372         require(set._values.length > index, "EnumerableSet: index out of bounds");
1373         return set._values[index];
1374     }
1375 
1376     // Bytes32Set
1377 
1378     struct Bytes32Set {
1379         Set _inner;
1380     }
1381 
1382     /**
1383      * @dev Add a value to a set. O(1).
1384      *
1385      * Returns true if the value was added to the set, that is if it was not
1386      * already present.
1387      */
1388     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1389         return _add(set._inner, value);
1390     }
1391 
1392     /**
1393      * @dev Removes a value from a set. O(1).
1394      *
1395      * Returns true if the value was removed from the set, that is if it was
1396      * present.
1397      */
1398     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1399         return _remove(set._inner, value);
1400     }
1401 
1402     /**
1403      * @dev Returns true if the value is in the set. O(1).
1404      */
1405     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1406         return _contains(set._inner, value);
1407     }
1408 
1409     /**
1410      * @dev Returns the number of values in the set. O(1).
1411      */
1412     function length(Bytes32Set storage set) internal view returns (uint256) {
1413         return _length(set._inner);
1414     }
1415 
1416    /**
1417     * @dev Returns the value stored at position `index` in the set. O(1).
1418     *
1419     * Note that there are no guarantees on the ordering of values inside the
1420     * array, and it may change when more values are added or removed.
1421     *
1422     * Requirements:
1423     *
1424     * - `index` must be strictly less than {length}.
1425     */
1426     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1427         return _at(set._inner, index);
1428     }
1429 
1430     // AddressSet
1431 
1432     struct AddressSet {
1433         Set _inner;
1434     }
1435 
1436     /**
1437      * @dev Add a value to a set. O(1).
1438      *
1439      * Returns true if the value was added to the set, that is if it was not
1440      * already present.
1441      */
1442     function add(AddressSet storage set, address value) internal returns (bool) {
1443         return _add(set._inner, bytes32(uint256(uint160(value))));
1444     }
1445 
1446     /**
1447      * @dev Removes a value from a set. O(1).
1448      *
1449      * Returns true if the value was removed from the set, that is if it was
1450      * present.
1451      */
1452     function remove(AddressSet storage set, address value) internal returns (bool) {
1453         return _remove(set._inner, bytes32(uint256(uint160(value))));
1454     }
1455 
1456     /**
1457      * @dev Returns true if the value is in the set. O(1).
1458      */
1459     function contains(AddressSet storage set, address value) internal view returns (bool) {
1460         return _contains(set._inner, bytes32(uint256(uint160(value))));
1461     }
1462 
1463     /**
1464      * @dev Returns the number of values in the set. O(1).
1465      */
1466     function length(AddressSet storage set) internal view returns (uint256) {
1467         return _length(set._inner);
1468     }
1469 
1470    /**
1471     * @dev Returns the value stored at position `index` in the set. O(1).
1472     *
1473     * Note that there are no guarantees on the ordering of values inside the
1474     * array, and it may change when more values are added or removed.
1475     *
1476     * Requirements:
1477     *
1478     * - `index` must be strictly less than {length}.
1479     */
1480     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1481         return address(uint160(uint256(_at(set._inner, index))));
1482     }
1483 
1484 
1485     // UintSet
1486 
1487     struct UintSet {
1488         Set _inner;
1489     }
1490 
1491     /**
1492      * @dev Add a value to a set. O(1).
1493      *
1494      * Returns true if the value was added to the set, that is if it was not
1495      * already present.
1496      */
1497     function add(UintSet storage set, uint256 value) internal returns (bool) {
1498         return _add(set._inner, bytes32(value));
1499     }
1500 
1501     /**
1502      * @dev Removes a value from a set. O(1).
1503      *
1504      * Returns true if the value was removed from the set, that is if it was
1505      * present.
1506      */
1507     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1508         return _remove(set._inner, bytes32(value));
1509     }
1510 
1511     /**
1512      * @dev Returns true if the value is in the set. O(1).
1513      */
1514     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1515         return _contains(set._inner, bytes32(value));
1516     }
1517 
1518     /**
1519      * @dev Returns the number of values on the set. O(1).
1520      */
1521     function length(UintSet storage set) internal view returns (uint256) {
1522         return _length(set._inner);
1523     }
1524 
1525    /**
1526     * @dev Returns the value stored at position `index` in the set. O(1).
1527     *
1528     * Note that there are no guarantees on the ordering of values inside the
1529     * array, and it may change when more values are added or removed.
1530     *
1531     * Requirements:
1532     *
1533     * - `index` must be strictly less than {length}.
1534     */
1535     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1536         return uint256(_at(set._inner, index));
1537     }
1538 }
1539 
1540 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1541 
1542 
1543 
1544 pragma solidity >=0.6.0 <0.8.0;
1545 
1546 /**
1547  * @dev Library for managing an enumerable variant of Solidity's
1548  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1549  * type.
1550  *
1551  * Maps have the following properties:
1552  *
1553  * - Entries are added, removed, and checked for existence in constant time
1554  * (O(1)).
1555  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1556  *
1557  * ```
1558  * contract Example {
1559  *     // Add the library methods
1560  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1561  *
1562  *     // Declare a set state variable
1563  *     EnumerableMap.UintToAddressMap private myMap;
1564  * }
1565  * ```
1566  *
1567  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1568  * supported.
1569  */
1570 library EnumerableMap {
1571     // To implement this library for multiple types with as little code
1572     // repetition as possible, we write it in terms of a generic Map type with
1573     // bytes32 keys and values.
1574     // The Map implementation uses private functions, and user-facing
1575     // implementations (such as Uint256ToAddressMap) are just wrappers around
1576     // the underlying Map.
1577     // This means that we can only create new EnumerableMaps for types that fit
1578     // in bytes32.
1579 
1580     struct MapEntry {
1581         bytes32 _key;
1582         bytes32 _value;
1583     }
1584 
1585     struct Map {
1586         // Storage of map keys and values
1587         MapEntry[] _entries;
1588 
1589         // Position of the entry defined by a key in the `entries` array, plus 1
1590         // because index 0 means a key is not in the map.
1591         mapping (bytes32 => uint256) _indexes;
1592     }
1593 
1594     /**
1595      * @dev Adds a key-value pair to a map, or updates the value for an existing
1596      * key. O(1).
1597      *
1598      * Returns true if the key was added to the map, that is if it was not
1599      * already present.
1600      */
1601     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1602         // We read and store the key's index to prevent multiple reads from the same storage slot
1603         uint256 keyIndex = map._indexes[key];
1604 
1605         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1606             map._entries.push(MapEntry({ _key: key, _value: value }));
1607             // The entry is stored at length-1, but we add 1 to all indexes
1608             // and use 0 as a sentinel value
1609             map._indexes[key] = map._entries.length;
1610             return true;
1611         } else {
1612             map._entries[keyIndex - 1]._value = value;
1613             return false;
1614         }
1615     }
1616 
1617     /**
1618      * @dev Removes a key-value pair from a map. O(1).
1619      *
1620      * Returns true if the key was removed from the map, that is if it was present.
1621      */
1622     function _remove(Map storage map, bytes32 key) private returns (bool) {
1623         // We read and store the key's index to prevent multiple reads from the same storage slot
1624         uint256 keyIndex = map._indexes[key];
1625 
1626         if (keyIndex != 0) { // Equivalent to contains(map, key)
1627             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1628             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1629             // This modifies the order of the array, as noted in {at}.
1630 
1631             uint256 toDeleteIndex = keyIndex - 1;
1632             uint256 lastIndex = map._entries.length - 1;
1633 
1634             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1635             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1636 
1637             MapEntry storage lastEntry = map._entries[lastIndex];
1638 
1639             // Move the last entry to the index where the entry to delete is
1640             map._entries[toDeleteIndex] = lastEntry;
1641             // Update the index for the moved entry
1642             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1643 
1644             // Delete the slot where the moved entry was stored
1645             map._entries.pop();
1646 
1647             // Delete the index for the deleted slot
1648             delete map._indexes[key];
1649 
1650             return true;
1651         } else {
1652             return false;
1653         }
1654     }
1655 
1656     /**
1657      * @dev Returns true if the key is in the map. O(1).
1658      */
1659     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1660         return map._indexes[key] != 0;
1661     }
1662 
1663     /**
1664      * @dev Returns the number of key-value pairs in the map. O(1).
1665      */
1666     function _length(Map storage map) private view returns (uint256) {
1667         return map._entries.length;
1668     }
1669 
1670    /**
1671     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1672     *
1673     * Note that there are no guarantees on the ordering of entries inside the
1674     * array, and it may change when more entries are added or removed.
1675     *
1676     * Requirements:
1677     *
1678     * - `index` must be strictly less than {length}.
1679     */
1680     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1681         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1682 
1683         MapEntry storage entry = map._entries[index];
1684         return (entry._key, entry._value);
1685     }
1686 
1687     /**
1688      * @dev Tries to returns the value associated with `key`.  O(1).
1689      * Does not revert if `key` is not in the map.
1690      */
1691     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1692         uint256 keyIndex = map._indexes[key];
1693         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1694         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1695     }
1696 
1697     /**
1698      * @dev Returns the value associated with `key`.  O(1).
1699      *
1700      * Requirements:
1701      *
1702      * - `key` must be in the map.
1703      */
1704     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1705         uint256 keyIndex = map._indexes[key];
1706         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1707         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1708     }
1709 
1710     /**
1711      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1712      *
1713      * CAUTION: This function is deprecated because it requires allocating memory for the error
1714      * message unnecessarily. For custom revert reasons use {_tryGet}.
1715      */
1716     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1717         uint256 keyIndex = map._indexes[key];
1718         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1719         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1720     }
1721 
1722     // UintToAddressMap
1723 
1724     struct UintToAddressMap {
1725         Map _inner;
1726     }
1727 
1728     /**
1729      * @dev Adds a key-value pair to a map, or updates the value for an existing
1730      * key. O(1).
1731      *
1732      * Returns true if the key was added to the map, that is if it was not
1733      * already present.
1734      */
1735     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1736         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1737     }
1738 
1739     /**
1740      * @dev Removes a value from a set. O(1).
1741      *
1742      * Returns true if the key was removed from the map, that is if it was present.
1743      */
1744     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1745         return _remove(map._inner, bytes32(key));
1746     }
1747 
1748     /**
1749      * @dev Returns true if the key is in the map. O(1).
1750      */
1751     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1752         return _contains(map._inner, bytes32(key));
1753     }
1754 
1755     /**
1756      * @dev Returns the number of elements in the map. O(1).
1757      */
1758     function length(UintToAddressMap storage map) internal view returns (uint256) {
1759         return _length(map._inner);
1760     }
1761 
1762    /**
1763     * @dev Returns the element stored at position `index` in the set. O(1).
1764     * Note that there are no guarantees on the ordering of values inside the
1765     * array, and it may change when more values are added or removed.
1766     *
1767     * Requirements:
1768     *
1769     * - `index` must be strictly less than {length}.
1770     */
1771     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1772         (bytes32 key, bytes32 value) = _at(map._inner, index);
1773         return (uint256(key), address(uint160(uint256(value))));
1774     }
1775 
1776     /**
1777      * @dev Tries to returns the value associated with `key`.  O(1).
1778      * Does not revert if `key` is not in the map.
1779      *
1780      * _Available since v3.4._
1781      */
1782     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1783         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1784         return (success, address(uint160(uint256(value))));
1785     }
1786 
1787     /**
1788      * @dev Returns the value associated with `key`.  O(1).
1789      *
1790      * Requirements:
1791      *
1792      * - `key` must be in the map.
1793      */
1794     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1795         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1796     }
1797 
1798     /**
1799      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1800      *
1801      * CAUTION: This function is deprecated because it requires allocating memory for the error
1802      * message unnecessarily. For custom revert reasons use {tryGet}.
1803      */
1804     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1805         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1806     }
1807 }
1808 
1809 // File: @openzeppelin/contracts/utils/Strings.sol
1810 
1811 
1812 
1813 pragma solidity >=0.6.0 <0.8.0;
1814 
1815 /**
1816  * @dev String operations.
1817  */
1818 library Strings {
1819     /**
1820      * @dev Converts a `uint256` to its ASCII `string` representation.
1821      */
1822     function toString(uint256 value) internal pure returns (string memory) {
1823         // Inspired by OraclizeAPI's implementation - MIT licence
1824         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1825 
1826         if (value == 0) {
1827             return "0";
1828         }
1829         uint256 temp = value;
1830         uint256 digits;
1831         while (temp != 0) {
1832             digits++;
1833             temp /= 10;
1834         }
1835         bytes memory buffer = new bytes(digits);
1836         uint256 index = digits - 1;
1837         temp = value;
1838         while (temp != 0) {
1839             buffer[index--] = bytes1(uint8(48 + temp % 10));
1840             temp /= 10;
1841         }
1842         return string(buffer);
1843     }
1844 }
1845 
1846 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1847 
1848 
1849 
1850 pragma solidity >=0.6.0 <0.8.0;
1851 
1852 
1853 
1854 
1855 
1856 
1857 
1858 
1859 
1860 
1861 
1862 
1863 /**
1864  * @title ERC721 Non-Fungible Token Standard basic implementation
1865  * @dev see https://eips.ethereum.org/EIPS/eip-721
1866  */
1867 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1868     using SafeMath for uint256;
1869     using Address for address;
1870     using EnumerableSet for EnumerableSet.UintSet;
1871     using EnumerableMap for EnumerableMap.UintToAddressMap;
1872     using Strings for uint256;
1873 
1874     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1875     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1876     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1877 
1878     // Mapping from holder address to their (enumerable) set of owned tokens
1879     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1880 
1881     // Enumerable mapping from token ids to their owners
1882     EnumerableMap.UintToAddressMap private _tokenOwners;
1883 
1884     // Mapping from token ID to approved address
1885     mapping (uint256 => address) private _tokenApprovals;
1886 
1887     // Mapping from owner to operator approvals
1888     mapping (address => mapping (address => bool)) private _operatorApprovals;
1889 
1890     // Token name
1891     string private _name;
1892 
1893     // Token symbol
1894     string private _symbol;
1895 
1896     // Optional mapping for token URIs
1897     mapping (uint256 => string) private _tokenURIs;
1898 
1899     // Base URI
1900     string private _baseURI;
1901 
1902     /*
1903      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1904      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1905      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1906      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1907      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1908      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1909      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1910      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1911      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1912      *
1913      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1914      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1915      */
1916     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1917 
1918     /*
1919      *     bytes4(keccak256('name()')) == 0x06fdde03
1920      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1921      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1922      *
1923      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1924      */
1925     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1926 
1927     /*
1928      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1929      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1930      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1931      *
1932      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1933      */
1934     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1935 
1936     /**
1937      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1938      */
1939     constructor (string memory name_, string memory symbol_) public {
1940         _name = name_;
1941         _symbol = symbol_;
1942 
1943         // register the supported interfaces to conform to ERC721 via ERC165
1944         _registerInterface(_INTERFACE_ID_ERC721);
1945         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1946         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1947     }
1948 
1949     /**
1950      * @dev See {IERC721-balanceOf}.
1951      */
1952     function balanceOf(address owner) public view virtual override returns (uint256) {
1953         require(owner != address(0), "ERC721: balance query for the zero address");
1954         return _holderTokens[owner].length();
1955     }
1956 
1957     /**
1958      * @dev See {IERC721-ownerOf}.
1959      */
1960     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1961         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1962     }
1963 
1964     /**
1965      * @dev See {IERC721Metadata-name}.
1966      */
1967     function name() public view virtual override returns (string memory) {
1968         return _name;
1969     }
1970 
1971     /**
1972      * @dev See {IERC721Metadata-symbol}.
1973      */
1974     function symbol() public view virtual override returns (string memory) {
1975         return _symbol;
1976     }
1977 
1978     /**
1979      * @dev See {IERC721Metadata-tokenURI}.
1980      */
1981     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1982         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1983 
1984         string memory _tokenURI = _tokenURIs[tokenId];
1985         string memory base = baseURI();
1986 
1987         // If there is no base URI, return the token URI.
1988         if (bytes(base).length == 0) {
1989             return _tokenURI;
1990         }
1991         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1992         if (bytes(_tokenURI).length > 0) {
1993             return string(abi.encodePacked(base, _tokenURI));
1994         }
1995         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1996         return string(abi.encodePacked(base, tokenId.toString()));
1997     }
1998 
1999     /**
2000     * @dev Returns the base URI set via {_setBaseURI}. This will be
2001     * automatically added as a prefix in {tokenURI} to each token's URI, or
2002     * to the token ID if no specific URI is set for that token ID.
2003     */
2004     function baseURI() public view virtual returns (string memory) {
2005         return _baseURI;
2006     }
2007 
2008     /**
2009      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2010      */
2011     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2012         return _holderTokens[owner].at(index);
2013     }
2014 
2015     /**
2016      * @dev See {IERC721Enumerable-totalSupply}.
2017      */
2018     function totalSupply() public view virtual override returns (uint256) {
2019         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
2020         return _tokenOwners.length();
2021     }
2022 
2023     /**
2024      * @dev See {IERC721Enumerable-tokenByIndex}.
2025      */
2026     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2027         (uint256 tokenId, ) = _tokenOwners.at(index);
2028         return tokenId;
2029     }
2030 
2031     /**
2032      * @dev See {IERC721-approve}.
2033      */
2034     function approve(address to, uint256 tokenId) public virtual override {
2035         address owner = ERC721.ownerOf(tokenId);
2036         require(to != owner, "ERC721: approval to current owner");
2037 
2038         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
2039             "ERC721: approve caller is not owner nor approved for all"
2040         );
2041 
2042         _approve(to, tokenId);
2043     }
2044 
2045     /**
2046      * @dev See {IERC721-getApproved}.
2047      */
2048     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2049         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
2050 
2051         return _tokenApprovals[tokenId];
2052     }
2053 
2054     /**
2055      * @dev See {IERC721-setApprovalForAll}.
2056      */
2057     function setApprovalForAll(address operator, bool approved) public virtual override {
2058         require(operator != _msgSender(), "ERC721: approve to caller");
2059 
2060         _operatorApprovals[_msgSender()][operator] = approved;
2061         emit ApprovalForAll(_msgSender(), operator, approved);
2062     }
2063 
2064     /**
2065      * @dev See {IERC721-isApprovedForAll}.
2066      */
2067     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2068         return _operatorApprovals[owner][operator];
2069     }
2070 
2071     /**
2072      * @dev See {IERC721-transferFrom}.
2073      */
2074     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2075         //solhint-disable-next-line max-line-length
2076         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2077 
2078         _transfer(from, to, tokenId);
2079     }
2080 
2081     /**
2082      * @dev See {IERC721-safeTransferFrom}.
2083      */
2084     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2085         safeTransferFrom(from, to, tokenId, "");
2086     }
2087 
2088     /**
2089      * @dev See {IERC721-safeTransferFrom}.
2090      */
2091     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2092         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2093         _safeTransfer(from, to, tokenId, _data);
2094     }
2095 
2096     /**
2097      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2098      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2099      *
2100      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2101      *
2102      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2103      * implement alternative mechanisms to perform token transfer, such as signature-based.
2104      *
2105      * Requirements:
2106      *
2107      * - `from` cannot be the zero address.
2108      * - `to` cannot be the zero address.
2109      * - `tokenId` token must exist and be owned by `from`.
2110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2111      *
2112      * Emits a {Transfer} event.
2113      */
2114     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2115         _transfer(from, to, tokenId);
2116         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2117     }
2118 
2119     /**
2120      * @dev Returns whether `tokenId` exists.
2121      *
2122      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2123      *
2124      * Tokens start existing when they are minted (`_mint`),
2125      * and stop existing when they are burned (`_burn`).
2126      */
2127     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2128         return _tokenOwners.contains(tokenId);
2129     }
2130 
2131     /**
2132      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2133      *
2134      * Requirements:
2135      *
2136      * - `tokenId` must exist.
2137      */
2138     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2139         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2140         address owner = ERC721.ownerOf(tokenId);
2141         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
2142     }
2143 
2144     /**
2145      * @dev Safely mints `tokenId` and transfers it to `to`.
2146      *
2147      * Requirements:
2148      d*
2149      * - `tokenId` must not exist.
2150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2151      *
2152      * Emits a {Transfer} event.
2153      */
2154     function _safeMint(address to, uint256 tokenId) internal virtual {
2155         _safeMint(to, tokenId, "");
2156     }
2157 
2158     /**
2159      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2160      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2161      */
2162     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
2163         _mint(to, tokenId);
2164         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2165     }
2166 
2167     /**
2168      * @dev Mints `tokenId` and transfers it to `to`.
2169      *
2170      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2171      *
2172      * Requirements:
2173      *
2174      * - `tokenId` must not exist.
2175      * - `to` cannot be the zero address.
2176      *
2177      * Emits a {Transfer} event.
2178      */
2179     function _mint(address to, uint256 tokenId) internal virtual {
2180         require(to != address(0), "ERC721: mint to the zero address");
2181         require(!_exists(tokenId), "ERC721: token already minted");
2182 
2183         _beforeTokenTransfer(address(0), to, tokenId);
2184 
2185         _holderTokens[to].add(tokenId);
2186 
2187         _tokenOwners.set(tokenId, to);
2188 
2189         emit Transfer(address(0), to, tokenId);
2190     }
2191 
2192     /**
2193      * @dev Destroys `tokenId`.
2194      * The approval is cleared when the token is burned.
2195      *
2196      * Requirements:
2197      *
2198      * - `tokenId` must exist.
2199      *
2200      * Emits a {Transfer} event.
2201      */
2202     function _burn(uint256 tokenId) internal virtual {
2203         address owner = ERC721.ownerOf(tokenId); // internal owner
2204 
2205         _beforeTokenTransfer(owner, address(0), tokenId);
2206 
2207         // Clear approvals
2208         _approve(address(0), tokenId);
2209 
2210         // Clear metadata (if any)
2211         if (bytes(_tokenURIs[tokenId]).length != 0) {
2212             delete _tokenURIs[tokenId];
2213         }
2214 
2215         _holderTokens[owner].remove(tokenId);
2216 
2217         _tokenOwners.remove(tokenId);
2218 
2219         emit Transfer(owner, address(0), tokenId);
2220     }
2221 
2222     /**
2223      * @dev Transfers `tokenId` from `from` to `to`.
2224      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2225      *
2226      * Requirements:
2227      *
2228      * - `to` cannot be the zero address.
2229      * - `tokenId` token must be owned by `from`.
2230      *
2231      * Emits a {Transfer} event.
2232      */
2233     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2234         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
2235         require(to != address(0), "ERC721: transfer to the zero address");
2236 
2237         _beforeTokenTransfer(from, to, tokenId);
2238 
2239         // Clear approvals from the previous owner
2240         _approve(address(0), tokenId);
2241 
2242         _holderTokens[from].remove(tokenId);
2243         _holderTokens[to].add(tokenId);
2244 
2245         _tokenOwners.set(tokenId, to);
2246 
2247         emit Transfer(from, to, tokenId);
2248     }
2249 
2250     /**
2251      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2252      *
2253      * Requirements:
2254      *
2255      * - `tokenId` must exist.
2256      */
2257     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2258         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2259         _tokenURIs[tokenId] = _tokenURI;
2260     }
2261 
2262     /**
2263      * @dev Internal function to set the base URI for all token IDs. It is
2264      * automatically added as a prefix to the value returned in {tokenURI},
2265      * or to the token ID if {tokenURI} is empty.
2266      */
2267     function _setBaseURI(string memory baseURI_) internal virtual {
2268         _baseURI = baseURI_;
2269     }
2270 
2271     /**
2272      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2273      * The call is not executed if the target address is not a contract.
2274      *
2275      * @param from address representing the previous owner of the given token ID
2276      * @param to target address that will receive the tokens
2277      * @param tokenId uint256 ID of the token to be transferred
2278      * @param _data bytes optional data to send along with the call
2279      * @return bool whether the call correctly returned the expected magic value
2280      */
2281     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2282         private returns (bool)
2283     {
2284         if (!to.isContract()) {
2285             return true;
2286         }
2287         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2288             IERC721Receiver(to).onERC721Received.selector,
2289             _msgSender(),
2290             from,
2291             tokenId,
2292             _data
2293         ), "ERC721: transfer to non ERC721Receiver implementer");
2294         bytes4 retval = abi.decode(returndata, (bytes4));
2295         return (retval == _ERC721_RECEIVED);
2296     }
2297 
2298     function _approve(address to, uint256 tokenId) private {
2299         _tokenApprovals[tokenId] = to;
2300         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2301     }
2302 
2303     /**
2304      * @dev Hook that is called before any token transfer. This includes minting
2305      * and burning.
2306      *
2307      * Calling conditions:
2308      *
2309      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2310      * transferred to `to`.
2311      * - When `from` is zero, `tokenId` will be minted for `to`.
2312      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2313      * - `from` cannot be the zero address.
2314      * - `to` cannot be the zero address.
2315      *
2316      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2317      */
2318     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2319 }
2320 
2321 // File: contracts/LeasedEmblem.sol
2322 
2323 
2324 
2325 pragma solidity 0.7.6;
2326 
2327 
2328 
2329 
2330 contract LeasedEmblem is ERC721, Ownable {
2331   using SafeMath for uint256;
2332 
2333   address internal leaseExchange;
2334 
2335 
2336   struct Metadata {
2337     uint256 amount;
2338     address leasor;
2339     uint256 duration;
2340     uint256 tradeExpiry;
2341     uint256 leaseExpiry;
2342     bool isMining;
2343   }
2344 
2345   mapping(uint256 => Metadata) public metadata;
2346 
2347 
2348   mapping(address => uint256[]) internal leasedTokens;
2349 
2350 
2351   mapping(uint256 => uint256) internal leasedTokensIndex;
2352 
2353 
2354   mapping (uint256 => address) internal tokenLeasor;
2355 
2356 
2357   mapping (address => uint256) internal leasedTokensCount;
2358 
2359   uint256 highestId = 1;
2360 
2361   uint256 sixMonths = 15768000;
2362 
2363   constructor (string memory _name, string memory _symbol) public ERC721(_name, _symbol) {
2364   }
2365 
2366 
2367   function getNewId() public view returns(uint256) {
2368     return highestId;
2369   }
2370 
2371   function leasorOf(uint256 _tokenId) public view returns (address) {
2372     address owner = tokenLeasor[_tokenId];
2373     require(owner != address(0));
2374     return owner;
2375   }
2376 
2377   function balanceOfLeasor(address _leasor) public view returns (uint256) {
2378     require(_leasor != address(0));
2379     return leasedTokensCount[_leasor];
2380   }
2381 
2382   function tokenOfLeasorByIndex(address _leasor,uint256 _index) public view returns (uint256){
2383     require(_index < balanceOfLeasor(_leasor));
2384     return leasedTokens[_leasor][_index];
2385   }
2386 
2387   function addTokenToLeasor(address _to, uint256 _tokenId) internal {
2388     require(tokenLeasor[_tokenId] == address(0));
2389     tokenLeasor[_tokenId] = _to;
2390     leasedTokensCount[_to] = leasedTokensCount[_to].add(1);
2391     uint256 length = leasedTokens[_to].length;
2392     leasedTokens[_to].push(_tokenId);
2393     leasedTokensIndex[_tokenId] = length;
2394   }
2395 
2396   function removeTokenFromLeasor(address _from, uint256 _tokenId) internal {
2397     require(leasorOf(_tokenId) == _from);
2398     leasedTokensCount[_from] = leasedTokensCount[_from].sub(1);
2399     tokenLeasor[_tokenId] = address(0);
2400 
2401     uint256 tokenIndex = leasedTokensIndex[_tokenId];
2402     uint256 lastTokenIndex = leasedTokens[_from].length.sub(1);
2403     uint256 lastToken = leasedTokens[_from][lastTokenIndex];
2404 
2405     leasedTokens[_from][tokenIndex] = lastToken;
2406     leasedTokens[_from][lastTokenIndex] = 0;
2407     leasedTokens[_from].pop();
2408     delete leasedTokensIndex[_tokenId];
2409     leasedTokensIndex[lastToken] = tokenIndex;
2410   }
2411 
2412   function setLeaseExchange(address _leaseExchange) public onlyOwner {
2413     leaseExchange = _leaseExchange;
2414   }
2415 
2416   function totalAmount() external view returns (uint256) {
2417     uint256 amount = 0;
2418     for(uint256 i = 0; i < totalSupply(); i++){
2419       amount += metadata[tokenByIndex(i)].amount;
2420     }
2421     return amount;
2422   }
2423 
2424   function setMetadata(uint256 _tokenId, uint256 amount, address leasor, uint256 duration,uint256 tradeExpiry, uint256 leaseExpiry) internal {
2425     require(_exists(_tokenId));
2426     metadata[_tokenId]= Metadata(amount,leasor,duration,tradeExpiry,leaseExpiry,false);
2427   }
2428 
2429   function getMetadata(uint256 _tokenId) public view returns (uint256, address, uint256, uint256,uint256, bool) {
2430     require(_exists(_tokenId));
2431     return (
2432       metadata[_tokenId].amount,
2433       metadata[_tokenId].leasor,
2434       metadata[_tokenId].duration,
2435       metadata[_tokenId].tradeExpiry,
2436       metadata[_tokenId].leaseExpiry,
2437       metadata[_tokenId].isMining
2438     );
2439   }
2440 
2441   function getAmountForUser(address owner) external view returns (uint256) {
2442     uint256 amount = 0;
2443     uint256 numTokens = balanceOf(owner);
2444 
2445     for(uint256 i = 0; i < numTokens; i++){
2446       amount += metadata[tokenOfOwnerByIndex(owner,i)].amount;
2447     }
2448     return amount;
2449   }
2450 
2451   function getAmountForUserMining(address owner) external view returns (uint256) {
2452     uint256 amount = 0;
2453     uint256 numTokens = balanceOf(owner);
2454 
2455     for(uint256 i = 0; i < numTokens; i++){
2456       if(metadata[tokenOfOwnerByIndex(owner,i)].isMining) {
2457         amount += metadata[tokenOfOwnerByIndex(owner,i)].amount;
2458       }
2459     }
2460     return amount;
2461   }
2462 
2463   function getAmount(uint256 _tokenId) public view returns (uint256) {
2464     require(_exists(_tokenId));
2465     return metadata[_tokenId].amount;
2466   }
2467 
2468   function getTradeExpiry(uint256 _tokenId) public view returns (uint256) {
2469     require(_exists(_tokenId));
2470     return metadata[_tokenId].tradeExpiry;
2471   }
2472 
2473   function getDuration(uint256 _tokenId) public view returns (uint256) {
2474     require(_exists(_tokenId));
2475     return metadata[_tokenId].duration;
2476   }
2477 
2478   function getIsMining(uint256 _tokenId) public view returns (bool) {
2479     require(_exists(_tokenId));
2480     return metadata[_tokenId].isMining;
2481   }
2482 
2483   function startMining(address _owner, uint256 _tokenId) public returns (bool) {
2484     require(msg.sender == leaseExchange);
2485     require(_exists(_tokenId));
2486     require(ownerOf(_tokenId) == _owner);
2487     require(block.timestamp < metadata[_tokenId].tradeExpiry);
2488     require(metadata[_tokenId].isMining == false);
2489     Metadata storage m = metadata[_tokenId];
2490     m.isMining = true;
2491     m.leaseExpiry = block.timestamp + m.duration;
2492     return true;
2493   }
2494 
2495   function canRetrieveEMB(address _leasor, uint256 _tokenId) public view returns (bool) {
2496     require(_exists(_tokenId));
2497     require(metadata[_tokenId].leasor == _leasor);
2498     if(metadata[_tokenId].isMining == false) {
2499       return(block.timestamp > metadata[_tokenId].leaseExpiry);
2500     }
2501     else {
2502       return(block.timestamp > metadata[_tokenId].tradeExpiry);
2503     }
2504   }
2505 
2506   function endLease(address _leasee, uint256 _tokenId) public {
2507     require(msg.sender == leaseExchange);
2508     require(_exists(_tokenId));
2509     require(ownerOf(_tokenId) == _leasee);
2510     require(block.timestamp > metadata[_tokenId].leaseExpiry);
2511     removeTokenFromLeasor(metadata[_tokenId].leasor, _tokenId);
2512     _burn(_tokenId);
2513   }
2514 
2515   function splitLEMB(uint256 _tokenId, uint256 amount) public {
2516     require(_exists(_tokenId));
2517     require(ownerOf(_tokenId) == msg.sender);
2518     require(metadata[_tokenId].isMining == false);
2519     require(block.timestamp < metadata[_tokenId].tradeExpiry);
2520     require(amount < getAmount(_tokenId));
2521 
2522     uint256 _newTokenId = getNewId();
2523 
2524     Metadata storage m = metadata[_tokenId];
2525     m.amount = m.amount - amount;
2526 
2527     _mint(msg.sender, _newTokenId);
2528     addTokenToLeasor(m.leasor, _newTokenId);
2529     setMetadata(_newTokenId, amount, m.leasor, m.duration,m.tradeExpiry, 0);
2530     highestId = highestId + 1;
2531   }
2532 
2533   function mintUniqueTokenTo(address _to, uint256 amount, address leasor, uint256 duration) public {
2534     require(msg.sender == leaseExchange);
2535     uint256 _tokenId = getNewId();
2536     _mint(_to, _tokenId);
2537     addTokenToLeasor(leasor, _tokenId);
2538     uint256 tradeExpiry = block.timestamp + sixMonths;
2539     setMetadata(_tokenId, amount, leasor, duration,tradeExpiry, 0);
2540     highestId = highestId + 1;
2541   }
2542 
2543   function _burn(uint256 _tokenId) override internal {
2544     super._burn(_tokenId);
2545     delete metadata[_tokenId];
2546   }
2547 
2548   modifier canTransfer(uint256 _tokenId) {
2549     require(_isApprovedOrOwner(msg.sender, _tokenId));
2550     require(metadata[_tokenId].isMining == false);
2551     _;
2552   }
2553 
2554 }
2555 
2556 // File: contracts/Emblem.sol
2557 
2558 
2559 
2560 pragma solidity 0.7.6;
2561 
2562 
2563 
2564 
2565 
2566 
2567 contract Emblem is ERC20, ERC20Capped, Ownable {
2568   using SafeMath for uint256;
2569 
2570    bool internal useVanityFees;
2571    address internal leaseExchange;
2572    address internal vanityPurchaseReceiver;
2573    uint256 internal vanityPurchaseCost = 1 * (10 ** 8); //1 EMB
2574    bytes12[] internal allVanities;
2575    LeasedEmblem internal LEMB;
2576 
2577    mapping (bytes12 => address) public vanityAddresses;
2578    mapping (address => bytes12[]) public ownedVanities;
2579    mapping (address => mapping(bytes12 => uint256)) public ownedVanitiesIndex;
2580    mapping (bytes12 => uint256) internal allVanitiesIndex;
2581    mapping (address => mapping (bytes12 => address)) internal allowedVanities;
2582    mapping (bytes12 => uint256) internal vanityFees;
2583 
2584    event TransferVanity(address indexed from, address indexed to, bytes12 vanity);
2585    event ApprovedVanity(address indexed from, address indexed to, bytes12 vanity);
2586    event VanityPurchaseCost(uint256 cost);
2587    event VanityPurchased(address indexed from, bytes12 vanity);
2588 
2589    constructor(string memory _name, string memory _ticker, uint8 _decimal, uint256 _supply, address _wallet) public ERC20(_name, _ticker) ERC20Capped(_supply) {
2590      _mint(_wallet,_supply);
2591      _setupDecimals(_decimal);
2592    }
2593 
2594    function setLeaseExchange(address _leaseExchange) public onlyOwner {
2595      require(_leaseExchange != address(0), "Lease Exchange address cannot be set to 0");
2596      leaseExchange = _leaseExchange;
2597    }
2598 
2599    function setVanityPurchaseCost(uint256 cost) public onlyOwner {
2600      require(cost > 0, "Vanity Purchase Cost must be > 0");
2601      vanityPurchaseCost = cost;
2602      emit VanityPurchaseCost(cost);
2603    }
2604 
2605    function getVanityPurchaseCost() public view returns (uint256) {
2606      return vanityPurchaseCost;
2607    }
2608 
2609    function enableFees(bool enabled) public onlyOwner {
2610      useVanityFees = enabled;
2611    }
2612 
2613    function setVanityPurchaseReceiver(address _address) public onlyOwner {
2614      require(_address != address(0), "Vanity Purchase Receiver address cannot be set to 0");
2615      vanityPurchaseReceiver = _address;
2616    }
2617 
2618    function setLEMB(address _lemb) public onlyOwner {
2619      require(_lemb != address(0), "Leased Emblem address cannot be set to 0");
2620      LEMB = LeasedEmblem(_lemb);
2621    }
2622 
2623    function setVanityFee(bytes12 vanity, uint256 fee) public onlyOwner {
2624      vanityFees[vanity] = fee;
2625    }
2626 
2627    function getFee(bytes12 vanity) public view returns(uint256) {
2628      return vanityFees[vanity];
2629    }
2630 
2631    function enabledVanityFee() public view returns(bool) {
2632      return useVanityFees;
2633    }
2634 
2635    function vanityAllowance(address _owner, bytes12 _vanity, address _spender) public view returns (bool) {
2636      return allowedVanities[_owner][_vanity] == _spender;
2637    }
2638 
2639    function getVanityOwner(bytes12 _vanity) public view returns (address) {
2640      return vanityAddresses[_vanity];
2641    }
2642 
2643    function getAllVanities() public view returns (bytes12[] memory){
2644      return allVanities;
2645    }
2646 
2647    function getMyVanities() public view returns (bytes12[] memory){
2648      return ownedVanities[msg.sender];
2649    }
2650 
2651    function approveVanity(address _spender, bytes12 _vanity) public returns (bool) {
2652      require(_spender != address(0), 'spender of vanity cannot be address zero');
2653      require(vanityAddresses[_vanity] == msg.sender, 'transaction initiator must own the vanity');
2654      allowedVanities[msg.sender][_vanity] = _spender;
2655 
2656      emit ApprovedVanity(msg.sender, _spender, _vanity);
2657      return true;
2658    }
2659 
2660    function clearVanityApproval(bytes12 _vanity) public returns (bool){
2661      require(vanityAddresses[_vanity] == msg.sender,'transaction initiator must own the vanity');
2662      delete allowedVanities[msg.sender][_vanity];
2663      return true;
2664    }
2665 
2666    function transferVanity(bytes12 van, address newOwner) public returns (bool) {
2667      require(newOwner != address(0),'new vanity owner cannot be of address zero');
2668      require(vanityAddresses[van] == msg.sender,'transaction initiator must own the vanity');
2669 
2670      vanityAddresses[van] = newOwner;
2671      ownedVanities[newOwner].push(van);
2672      ownedVanitiesIndex[newOwner][van] = ownedVanities[newOwner].length.sub(1);
2673 
2674      uint256 vanityIndex = ownedVanitiesIndex[msg.sender][van];
2675      uint256 lastVanityIndex = ownedVanities[msg.sender].length.sub(1);
2676      bytes12 lastVanity = ownedVanities[msg.sender][lastVanityIndex];
2677 
2678      ownedVanities[msg.sender][vanityIndex] = lastVanity;
2679      ownedVanities[msg.sender].pop();
2680 
2681      delete ownedVanitiesIndex[msg.sender][van];
2682      ownedVanitiesIndex[msg.sender][lastVanity] = vanityIndex;
2683 
2684      emit TransferVanity(msg.sender, newOwner,van);
2685 
2686      return true;
2687    }
2688 
2689    function transferVanityFrom(
2690      address _from,
2691      address _to,
2692      bytes12 _vanity
2693    )
2694      public
2695      returns (bool)
2696    {
2697      require(_to != address(0),'new vanity owner cannot be of address zero');
2698      require(_from == vanityAddresses[_vanity],'the vanity being transferred must be owned by address _from');
2699      require(msg.sender == allowedVanities[_from][_vanity],'transaction initiator must be approved to transfer vanity');
2700 
2701      vanityAddresses[_vanity] = _to;
2702      ownedVanities[_to].push(_vanity);
2703      ownedVanitiesIndex[_to][_vanity] = ownedVanities[_to].length.sub(1);
2704 
2705      uint256 vanityIndex = ownedVanitiesIndex[_from][_vanity];
2706      uint256 lastVanityIndex = ownedVanities[_from].length.sub(1);
2707      bytes12 lastVanity = ownedVanities[_from][lastVanityIndex];
2708 
2709      ownedVanities[_from][vanityIndex] = lastVanity;
2710      ownedVanities[_from].pop();
2711 
2712      delete ownedVanitiesIndex[_from][_vanity];
2713      ownedVanitiesIndex[_from][lastVanity] = vanityIndex;
2714 
2715      emit TransferVanity(_from, _to,_vanity);
2716 
2717      return true;
2718    }
2719 
2720    function purchaseVanity(bytes12 van) public returns (bool) {
2721      require(vanityPurchaseReceiver != address(0),'vanity purchase receiver must be set');
2722      require(vanityAddresses[van] == address(0),'vanity must not be purchased so far');
2723 
2724      for(uint8 i = 0; i < 12; i++){
2725        //Vanities must be lower case
2726        require((uint8(van[i]) >= 48 && uint8(van[i]) <= 57) || (uint8(van[i]) >= 65 && uint8(van[i]) <= 90));
2727      }
2728      if(vanityPurchaseCost > 0) this.transferFrom(msg.sender,vanityPurchaseReceiver, vanityPurchaseCost);
2729 
2730      vanityAddresses[van] = msg.sender;
2731      ownedVanities[msg.sender].push(van);
2732      ownedVanitiesIndex[msg.sender][van] = ownedVanities[msg.sender].length.sub(1);
2733      allVanities.push(van);
2734      allVanitiesIndex[van] = allVanities.length.sub(1);
2735 
2736      emit VanityPurchased(msg.sender, van);
2737      return true;
2738    }
2739 
2740    //ensure the amount being transferred does not dip into EMB owned through leases.
2741    function canTransfer(address _account,uint256 _value) internal view returns (bool) {
2742       if(address(LEMB)!= address(0)){
2743         require((_value.add(LEMB.getAmountForUserMining(_account)) <= balanceOf(_account)),'value being sent cannot dip into EMB acquired through leasing');
2744       }
2745       return true;
2746    }
2747 
2748    function transfer(address _to, uint256 _value) public override returns (bool){
2749       require(canTransfer(msg.sender,_value),'value must be transferrable by transaction initiator');
2750       super.transfer(_to,_value);
2751       return true;
2752    }
2753 
2754    function multiTransfer(bytes27[] calldata _addressesAndAmounts) external returns (bool){
2755       for (uint i = 0; i < _addressesAndAmounts.length; i++) {
2756           address to = address(uint216(_addressesAndAmounts[i] >> 56));
2757           uint216 amount = uint216((_addressesAndAmounts[i] << 160) >> 160);
2758           transfer(to, amount);
2759       }
2760       return true;
2761    }
2762 
2763    function releaseEMB(address _from, address _to, uint256 _value) external returns (bool){
2764      require(address(0) != leaseExchange, 'Lease Exchange must be activated');
2765      require(msg.sender == leaseExchange, 'only the lease exchange can call this function');
2766      transferFrom(_from,_to,_value);
2767      return true;
2768    }
2769 
2770    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool){
2771       if(msg.sender != leaseExchange) require(canTransfer(_from,_value),'value must be transfered from address _from');
2772       super.transferFrom(_from,_to,_value);
2773       return true;
2774    }
2775 
2776    function decreaseAllowance(address _spender,uint256 _subtractedValue) public override returns (bool) {
2777      if(_spender == leaseExchange) {
2778        if(address(LEMB)!= address(0)){
2779          require(allowance(msg.sender,_spender).sub(_subtractedValue) >= LEMB.getAmountForUserMining(msg.sender),'if spender is the lease exchange, the allowance must be greater than the amount the user is mining with LEMB');
2780        }
2781      }
2782      super.decreaseAllowance(_spender,_subtractedValue);
2783      return true;
2784    }
2785 
2786    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
2787       super._beforeTokenTransfer(from, to, amount);
2788 
2789       if (from == address(0)) { // When minting tokens
2790           require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
2791       }
2792     }
2793 
2794    function approve(address _spender, uint256 _value) public override returns (bool) {
2795      if(_spender == leaseExchange){
2796        if(address(LEMB)!= address(0)){
2797          require(_value >= LEMB.getAmountForUserMining(msg.sender));
2798        }
2799      }
2800      _approve(msg.sender, _spender, _value);
2801      return true;
2802    }
2803 
2804 }