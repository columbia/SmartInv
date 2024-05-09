1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 
217 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
218 
219 
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /*
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with GSN meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address payable) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes memory) {
239         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
240         return msg.data;
241     }
242 }
243 
244 
245 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
246 
247 
248 
249 pragma solidity >=0.6.0 <0.8.0;
250 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2
327 
328 
329 
330 pragma solidity >=0.6.0 <0.8.0;
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
633 
634 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.2
635 
636 
637 
638 pragma solidity >=0.6.0 <0.8.0;
639 
640 
641 /**
642  * @dev Extension of {ERC20} that allows token holders to destroy both their own
643  * tokens and those that they have an allowance for, in a way that can be
644  * recognized off-chain (via event analysis).
645  */
646 abstract contract ERC20Burnable is Context, ERC20 {
647     using SafeMath for uint256;
648 
649     /**
650      * @dev Destroys `amount` tokens from the caller.
651      *
652      * See {ERC20-_burn}.
653      */
654     function burn(uint256 amount) public virtual {
655         _burn(_msgSender(), amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
660      * allowance.
661      *
662      * See {ERC20-_burn} and {ERC20-allowance}.
663      *
664      * Requirements:
665      *
666      * - the caller must have allowance for ``accounts``'s tokens of at least
667      * `amount`.
668      */
669     function burnFrom(address account, uint256 amount) public virtual {
670         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
671 
672         _approve(account, _msgSender(), decreasedAllowance);
673         _burn(account, amount);
674     }
675 }
676 
677 
678 // File @openzeppelin/contracts/GSN/Context.sol@v3.4.2
679 
680 
681 
682 pragma solidity >=0.6.0 <0.8.0;
683 
684 
685 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
686 
687 
688 
689 pragma solidity >=0.6.0 <0.8.0;
690 
691 /**
692  * @dev Contract module which provides a basic access control mechanism, where
693  * there is an account (an owner) that can be granted exclusive access to
694  * specific functions.
695  *
696  * By default, the owner account will be the one that deploys the contract. This
697  * can later be changed with {transferOwnership}.
698  *
699  * This module is used through inheritance. It will make available the modifier
700  * `onlyOwner`, which can be applied to your functions to restrict their use to
701  * the owner.
702  */
703 abstract contract Ownable is Context {
704     address private _owner;
705 
706     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
707 
708     /**
709      * @dev Initializes the contract setting the deployer as the initial owner.
710      */
711     constructor () internal {
712         address msgSender = _msgSender();
713         _owner = msgSender;
714         emit OwnershipTransferred(address(0), msgSender);
715     }
716 
717     /**
718      * @dev Returns the address of the current owner.
719      */
720     function owner() public view virtual returns (address) {
721         return _owner;
722     }
723 
724     /**
725      * @dev Throws if called by any account other than the owner.
726      */
727     modifier onlyOwner() {
728         require(owner() == _msgSender(), "Ownable: caller is not the owner");
729         _;
730     }
731 
732     /**
733      * @dev Leaves the contract without owner. It will not be possible to call
734      * `onlyOwner` functions anymore. Can only be called by the current owner.
735      *
736      * NOTE: Renouncing ownership will leave the contract without an owner,
737      * thereby removing any functionality that is only available to the owner.
738      */
739     function renounceOwnership() public virtual onlyOwner {
740         emit OwnershipTransferred(_owner, address(0));
741         _owner = address(0);
742     }
743 
744     /**
745      * @dev Transfers ownership of the contract to a new account (`newOwner`).
746      * Can only be called by the current owner.
747      */
748     function transferOwnership(address newOwner) public virtual onlyOwner {
749         require(newOwner != address(0), "Ownable: new owner is the zero address");
750         emit OwnershipTransferred(_owner, newOwner);
751         _owner = newOwner;
752     }
753 }
754 
755 
756 // File contracts/owner/Operator.sol
757 
758 
759 
760 pragma solidity 0.6.12;
761 
762 
763 contract Operator is Context, Ownable {
764     address private _operator;
765 
766     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
767 
768     constructor() internal {
769         _operator = _msgSender();
770         emit OperatorTransferred(address(0), _operator);
771     }
772 
773     function operator() public view returns (address) {
774         return _operator;
775     }
776 
777     modifier onlyOperator() {
778         require(_operator == msg.sender, "operator: caller is not the operator");
779         _;
780     }
781 
782     function isOperator() public view returns (bool) {
783         return _msgSender() == _operator;
784     }
785 
786     function transferOperator(address newOperator_) public onlyOwner {
787         _transferOperator(newOperator_);
788     }
789 
790     function _transferOperator(address newOperator_) internal {
791         require(newOperator_ != address(0), "operator: zero address given for new operator");
792         emit OperatorTransferred(address(0), newOperator_);
793         _operator = newOperator_;
794     }
795 }
796 
797 
798 // File contracts/GLDMShare.sol
799 
800 
801 
802 pragma solidity 0.6.12;
803 
804 
805 
806 contract GLDMShare is ERC20Burnable, Operator {
807     using SafeMath for uint256;
808 
809     // TOTAL MAX SUPPLY = 70,000 tSHAREs
810     uint256 public constant FARMING_POOL_REWARD_ALLOCATION = 59500 ether;   
811     uint256 public constant COMMUNITY_FUND_POOL_ALLOCATION = 7000 ether;    
812     uint256 public constant TEAM_FUND_POOL_ALLOCATION = 3360 ether;          
813     uint256 public constant DEV_FUND_POOL_ALLOCATION = 140 ether;
814     uint256 public constant VESTING_DURATION = 730 days;
815     uint256 public startTime;
816     uint256 public endTime;
817 
818     uint256 public communityFundRewardRate;
819     uint256 public teamFundRewardRate;
820     uint256 public devFundRewardRate;
821 
822     address public communityFund;
823     address public teamFund;
824     address public devFund;
825 
826     uint256 public communityFundLastClaimed;
827     uint256 public teamFundLastClaimed;
828     uint256 public devFundLastClaimed;
829 
830     bool public rewardPoolDistributed = false;
831 
832     constructor(uint256 _startTime, address _communityFund, address _teamFund, address _devFund) public ERC20("GoldMint Shares", "SGLDM") {
833         _mint(msg.sender, 1 ether); // mint 1 GLDM Share for initial pools deployment
834 
835         startTime = _startTime;
836         endTime = startTime + VESTING_DURATION;
837 
838         communityFundLastClaimed = startTime;
839         devFundLastClaimed = startTime;
840         teamFundLastClaimed = startTime;
841 
842         communityFundRewardRate = COMMUNITY_FUND_POOL_ALLOCATION.div(VESTING_DURATION);
843         teamFundRewardRate = TEAM_FUND_POOL_ALLOCATION.div(VESTING_DURATION);
844         devFundRewardRate = DEV_FUND_POOL_ALLOCATION.div(VESTING_DURATION);
845         
846         require(_teamFund != address(0), "Address cannot be 0");
847         teamFund = _teamFund;
848 
849         require(_devFund != address(0), "Address cannot be 0");
850         devFund = _devFund;
851 
852         require(_communityFund != address(0), "Address cannot be 0");
853         communityFund = _communityFund;
854     }
855 
856     function setTreasuryFund(address _communityFund) external {
857         require(msg.sender == teamFund, "!dev");
858         communityFund = _communityFund;
859     }
860 
861     function setTeamFund(address _teamFund) external {
862         require(msg.sender == teamFund, "!dev");
863         require(_teamFund != address(0), "zero");
864         teamFund = _teamFund;
865     }
866 
867     function unclaimedTreasuryFund() public view returns (uint256 _pending) {
868         uint256 _now = block.timestamp;
869         if (_now > endTime) _now = endTime;
870         if (communityFundLastClaimed >= _now) return 0;
871         _pending = _now.sub(communityFundLastClaimed).mul(communityFundRewardRate);
872     }
873 
874     function unclaimedTeamFund() public view returns (uint256 _pending) {
875         uint256 _now = block.timestamp;
876         if (_now > endTime) _now = endTime;
877         if (teamFundLastClaimed >= _now) return 0;
878         _pending = _now.sub(teamFundLastClaimed).mul(teamFundRewardRate);
879     }
880 
881     function unclaimedDevFund() public view returns (uint256 _pending) {
882         uint256 _now = block.timestamp;
883         if (_now > endTime) _now = endTime;
884         if (devFundLastClaimed >= _now) return 0;
885         _pending = _now.sub(devFundLastClaimed).mul(devFundRewardRate);
886     }
887 
888     /**
889      * @dev Claim pending rewards to community and dev fund
890      */
891     function claimRewards() external {
892         uint256 _pending = unclaimedTreasuryFund();
893         if (_pending > 0 && communityFund != address(0)) {
894             _mint(communityFund, _pending);
895             communityFundLastClaimed = block.timestamp;
896         }
897         _pending = unclaimedTeamFund();
898         if (_pending > 0 && teamFund != address(0)) {
899             _mint(teamFund, _pending);
900             teamFundLastClaimed = block.timestamp;
901         }
902 
903         _pending = unclaimedDevFund();
904         if (_pending > 0 && devFund != address(0)) {
905             _mint(devFund, _pending);
906             devFundLastClaimed = block.timestamp;
907         }
908     }
909 
910     /**
911      * @notice distribute to reward pool (only once)
912      */
913     function distributeReward(address _farmingIncentiveFund) external onlyOperator {
914         require(!rewardPoolDistributed, "only can distribute once");
915         require(_farmingIncentiveFund != address(0), "!_farmingIncentiveFund");
916         rewardPoolDistributed = true;
917         _mint(_farmingIncentiveFund, FARMING_POOL_REWARD_ALLOCATION);
918     }
919 
920     function burn(uint256 amount) public override {
921         super.burn(amount);
922     }
923 
924     function governanceRecoverUnsupported(
925         IERC20 _token,
926         uint256 _amount,
927         address _to
928     ) external onlyOperator {
929         _token.transfer(_to, _amount);
930     }
931 }