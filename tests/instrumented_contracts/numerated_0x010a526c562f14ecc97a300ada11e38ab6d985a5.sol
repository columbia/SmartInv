1 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
107 
108 pragma solidity >=0.6.0 <0.8.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         uint256 c = a + b;
131         if (c < a) return (false, 0);
132         return (true, c);
133     }
134 
135     /**
136      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         if (b > a) return (false, 0);
142         return (true, a - b);
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) return (true, 0);
155         uint256 c = a * b;
156         if (c / a != b) return (false, 0);
157         return (true, c);
158     }
159 
160     /**
161      * @dev Returns the division of two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         if (b == 0) return (false, 0);
167         return (true, a / b);
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         if (b == 0) return (false, 0);
177         return (true, a % b);
178     }
179 
180     /**
181      * @dev Returns the addition of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `+` operator.
185      *
186      * Requirements:
187      *
188      * - Addition cannot overflow.
189      */
190     function add(uint256 a, uint256 b) internal pure returns (uint256) {
191         uint256 c = a + b;
192         require(c >= a, "SafeMath: addition overflow");
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         require(b <= a, "SafeMath: subtraction overflow");
208         return a - b;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         if (a == 0) return 0;
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225         return c;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers, reverting on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b) internal pure returns (uint256) {
241         require(b > 0, "SafeMath: division by zero");
242         return a / b;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * reverting when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         require(b > 0, "SafeMath: modulo by zero");
259         return a % b;
260     }
261 
262     /**
263      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
264      * overflow (when the result is negative).
265      *
266      * CAUTION: This function is deprecated because it requires allocating memory for the error
267      * message unnecessarily. For custom revert reasons use {trySub}.
268      *
269      * Counterpart to Solidity's `-` operator.
270      *
271      * Requirements:
272      *
273      * - Subtraction cannot overflow.
274      */
275     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b <= a, errorMessage);
277         return a - b;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
282      * division by zero. The result is rounded towards zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryDiv}.
286      *
287      * Counterpart to Solidity's `/` operator. Note: this function uses a
288      * `revert` opcode (which leaves remaining gas untouched) while Solidity
289      * uses an invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a / b;
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * reverting with custom message when dividing by zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryMod}.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b > 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
322 
323 pragma solidity >=0.6.0 <0.8.0;
324 
325 
326 
327 
328 /**
329  * @dev Implementation of the {IERC20} interface.
330  *
331  * This implementation is agnostic to the way tokens are created. This means
332  * that a supply mechanism has to be added in a derived contract using {_mint}.
333  * For a generic mechanism see {ERC20PresetMinterPauser}.
334  *
335  * TIP: For a detailed writeup see our guide
336  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
337  * to implement supply mechanisms].
338  *
339  * We have followed general OpenZeppelin guidelines: functions revert instead
340  * of returning `false` on failure. This behavior is nonetheless conventional
341  * and does not conflict with the expectations of ERC20 applications.
342  *
343  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
344  * This allows applications to reconstruct the allowance for all accounts just
345  * by listening to said events. Other implementations of the EIP may not emit
346  * these events, as it isn't required by the specification.
347  *
348  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
349  * functions have been added to mitigate the well-known issues around setting
350  * allowances. See {IERC20-approve}.
351  */
352 contract ERC20 is Context, IERC20 {
353     using SafeMath for uint256;
354 
355     mapping (address => uint256) private _balances;
356 
357     mapping (address => mapping (address => uint256)) private _allowances;
358 
359     uint256 private _totalSupply;
360 
361     string private _name;
362     string private _symbol;
363     uint8 private _decimals;
364 
365     /**
366      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
367      * a default value of 18.
368      *
369      * To select a different value for {decimals}, use {_setupDecimals}.
370      *
371      * All three of these values are immutable: they can only be set once during
372      * construction.
373      */
374     constructor (string memory name_, string memory symbol_) public {
375         _name = name_;
376         _symbol = symbol_;
377         _decimals = 18;
378     }
379 
380     /**
381      * @dev Returns the name of the token.
382      */
383     function name() public view virtual returns (string memory) {
384         return _name;
385     }
386 
387     /**
388      * @dev Returns the symbol of the token, usually a shorter version of the
389      * name.
390      */
391     function symbol() public view virtual returns (string memory) {
392         return _symbol;
393     }
394 
395     /**
396      * @dev Returns the number of decimals used to get its user representation.
397      * For example, if `decimals` equals `2`, a balance of `505` tokens should
398      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
399      *
400      * Tokens usually opt for a value of 18, imitating the relationship between
401      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
402      * called.
403      *
404      * NOTE: This information is only used for _display_ purposes: it in
405      * no way affects any of the arithmetic of the contract, including
406      * {IERC20-balanceOf} and {IERC20-transfer}.
407      */
408     function decimals() public view virtual returns (uint8) {
409         return _decimals;
410     }
411 
412     /**
413      * @dev See {IERC20-totalSupply}.
414      */
415     function totalSupply() public view virtual override returns (uint256) {
416         return _totalSupply;
417     }
418 
419     /**
420      * @dev See {IERC20-balanceOf}.
421      */
422     function balanceOf(address account) public view virtual override returns (uint256) {
423         return _balances[account];
424     }
425 
426     /**
427      * @dev See {IERC20-transfer}.
428      *
429      * Requirements:
430      *
431      * - `recipient` cannot be the zero address.
432      * - the caller must have a balance of at least `amount`.
433      */
434     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
435         _transfer(_msgSender(), recipient, amount);
436         return true;
437     }
438 
439     /**
440      * @dev See {IERC20-allowance}.
441      */
442     function allowance(address owner, address spender) public view virtual override returns (uint256) {
443         return _allowances[owner][spender];
444     }
445 
446     /**
447      * @dev See {IERC20-approve}.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      */
453     function approve(address spender, uint256 amount) public virtual override returns (bool) {
454         _approve(_msgSender(), spender, amount);
455         return true;
456     }
457 
458     /**
459      * @dev See {IERC20-transferFrom}.
460      *
461      * Emits an {Approval} event indicating the updated allowance. This is not
462      * required by the EIP. See the note at the beginning of {ERC20}.
463      *
464      * Requirements:
465      *
466      * - `sender` and `recipient` cannot be the zero address.
467      * - `sender` must have a balance of at least `amount`.
468      * - the caller must have allowance for ``sender``'s tokens of at least
469      * `amount`.
470      */
471     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
472         _transfer(sender, recipient, amount);
473         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
474         return true;
475     }
476 
477     /**
478      * @dev Atomically increases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      */
489     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
491         return true;
492     }
493 
494     /**
495      * @dev Atomically decreases the allowance granted to `spender` by the caller.
496      *
497      * This is an alternative to {approve} that can be used as a mitigation for
498      * problems described in {IERC20-approve}.
499      *
500      * Emits an {Approval} event indicating the updated allowance.
501      *
502      * Requirements:
503      *
504      * - `spender` cannot be the zero address.
505      * - `spender` must have allowance for the caller of at least
506      * `subtractedValue`.
507      */
508     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
509         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
510         return true;
511     }
512 
513     /**
514      * @dev Moves tokens `amount` from `sender` to `recipient`.
515      *
516      * This is internal function is equivalent to {transfer}, and can be used to
517      * e.g. implement automatic token fees, slashing mechanisms, etc.
518      *
519      * Emits a {Transfer} event.
520      *
521      * Requirements:
522      *
523      * - `sender` cannot be the zero address.
524      * - `recipient` cannot be the zero address.
525      * - `sender` must have a balance of at least `amount`.
526      */
527     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
528         require(sender != address(0), "ERC20: transfer from the zero address");
529         require(recipient != address(0), "ERC20: transfer to the zero address");
530 
531         _beforeTokenTransfer(sender, recipient, amount);
532 
533         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
534         _balances[recipient] = _balances[recipient].add(amount);
535         emit Transfer(sender, recipient, amount);
536     }
537 
538     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
539      * the total supply.
540      *
541      * Emits a {Transfer} event with `from` set to the zero address.
542      *
543      * Requirements:
544      *
545      * - `to` cannot be the zero address.
546      */
547     function _mint(address account, uint256 amount) internal virtual {
548         require(account != address(0), "ERC20: mint to the zero address");
549 
550         _beforeTokenTransfer(address(0), account, amount);
551 
552         _totalSupply = _totalSupply.add(amount);
553         _balances[account] = _balances[account].add(amount);
554         emit Transfer(address(0), account, amount);
555     }
556 
557     /**
558      * @dev Destroys `amount` tokens from `account`, reducing the
559      * total supply.
560      *
561      * Emits a {Transfer} event with `to` set to the zero address.
562      *
563      * Requirements:
564      *
565      * - `account` cannot be the zero address.
566      * - `account` must have at least `amount` tokens.
567      */
568     function _burn(address account, uint256 amount) internal virtual {
569         require(account != address(0), "ERC20: burn from the zero address");
570 
571         _beforeTokenTransfer(account, address(0), amount);
572 
573         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
574         _totalSupply = _totalSupply.sub(amount);
575         emit Transfer(account, address(0), amount);
576     }
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
580      *
581      * This internal function is equivalent to `approve`, and can be used to
582      * e.g. set automatic allowances for certain subsystems, etc.
583      *
584      * Emits an {Approval} event.
585      *
586      * Requirements:
587      *
588      * - `owner` cannot be the zero address.
589      * - `spender` cannot be the zero address.
590      */
591     function _approve(address owner, address spender, uint256 amount) internal virtual {
592         require(owner != address(0), "ERC20: approve from the zero address");
593         require(spender != address(0), "ERC20: approve to the zero address");
594 
595         _allowances[owner][spender] = amount;
596         emit Approval(owner, spender, amount);
597     }
598 
599     /**
600      * @dev Sets {decimals} to a value other than the default one of 18.
601      *
602      * WARNING: This function should only be called from the constructor. Most
603      * applications that interact with token contracts will not expect
604      * {decimals} to ever change, and may work incorrectly if it does.
605      */
606     function _setupDecimals(uint8 decimals_) internal virtual {
607         _decimals = decimals_;
608     }
609 
610     /**
611      * @dev Hook that is called before any transfer of tokens. This includes
612      * minting and burning.
613      *
614      * Calling conditions:
615      *
616      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
617      * will be to transferred to `to`.
618      * - when `from` is zero, `amount` tokens will be minted for `to`.
619      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
620      * - `from` and `to` are never both zero.
621      *
622      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
623      */
624     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
625 }
626 
627 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
628 
629 pragma solidity >=0.6.0 <0.8.0;
630 
631 
632 
633 /**
634  * @dev Extension of {ERC20} that allows token holders to destroy both their own
635  * tokens and those that they have an allowance for, in a way that can be
636  * recognized off-chain (via event analysis).
637  */
638 abstract contract ERC20Burnable is Context, ERC20 {
639     using SafeMath for uint256;
640 
641     /**
642      * @dev Destroys `amount` tokens from the caller.
643      *
644      * See {ERC20-_burn}.
645      */
646     function burn(uint256 amount) public virtual {
647         _burn(_msgSender(), amount);
648     }
649 
650     /**
651      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
652      * allowance.
653      *
654      * See {ERC20-_burn} and {ERC20-allowance}.
655      *
656      * Requirements:
657      *
658      * - the caller must have allowance for ``accounts``'s tokens of at least
659      * `amount`.
660      */
661     function burnFrom(address account, uint256 amount) public virtual {
662         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
663 
664         _approve(account, _msgSender(), decreasedAllowance);
665         _burn(account, amount);
666     }
667 }
668 
669 // File: @openzeppelin\contracts\access\Ownable.sol
670 
671 pragma solidity >=0.6.0 <0.8.0;
672 
673 /**
674  * @dev Contract module which provides a basic access control mechanism, where
675  * there is an account (an owner) that can be granted exclusive access to
676  * specific functions.
677  *
678  * By default, the owner account will be the one that deploys the contract. This
679  * can later be changed with {transferOwnership}.
680  *
681  * This module is used through inheritance. It will make available the modifier
682  * `onlyOwner`, which can be applied to your functions to restrict their use to
683  * the owner.
684  */
685 abstract contract Ownable is Context {
686     address private _owner;
687 
688     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
689 
690     /**
691      * @dev Initializes the contract setting the deployer as the initial owner.
692      */
693     constructor () internal {
694         address msgSender = _msgSender();
695         _owner = msgSender;
696         emit OwnershipTransferred(address(0), msgSender);
697     }
698 
699     /**
700      * @dev Returns the address of the current owner.
701      */
702     function owner() public view virtual returns (address) {
703         return _owner;
704     }
705 
706     /**
707      * @dev Throws if called by any account other than the owner.
708      */
709     modifier onlyOwner() {
710         require(owner() == _msgSender(), "Ownable: caller is not the owner");
711         _;
712     }
713 
714     /**
715      * @dev Leaves the contract without owner. It will not be possible to call
716      * `onlyOwner` functions anymore. Can only be called by the current owner.
717      *
718      * NOTE: Renouncing ownership will leave the contract without an owner,
719      * thereby removing any functionality that is only available to the owner.
720      */
721     function renounceOwnership() public virtual onlyOwner {
722         emit OwnershipTransferred(_owner, address(0));
723         _owner = address(0);
724     }
725 
726     /**
727      * @dev Transfers ownership of the contract to a new account (`newOwner`).
728      * Can only be called by the current owner.
729      */
730     function transferOwnership(address newOwner) public virtual onlyOwner {
731         require(newOwner != address(0), "Ownable: new owner is the zero address");
732         emit OwnershipTransferred(_owner, newOwner);
733         _owner = newOwner;
734     }
735 }
736 
737 // File: contracts\Interfaces\ElasticIERC20.sol
738 
739 pragma solidity >=0.6.0 <0.8.0;
740 
741 /**
742  * @dev Interface of the ERC20 standard as defined in the EIP.
743  */
744 interface ElasticIERC20 {
745     /**
746      * @dev Returns the amount of tokens in existence.
747      */
748     function totalSupply() external view returns (uint256);
749 
750     /**
751      * @dev Returns the amount of tokens owned by `account`.
752      */
753     function balanceOf(address account) external view returns (uint256);
754 
755     /**
756      * @dev Moves `amount` tokens from the caller's account to `recipient`.
757      *
758      * Returns a boolean value indicating whether the operation succeeded.
759      *
760      * Emits a {Transfer} event.
761      */
762     function transfer(address recipient, uint256 amount) external returns (bool);
763 
764     /**
765      * @dev Returns the remaining number of tokens that `spender` will be
766      * allowed to spend on behalf of `owner` through {transferFrom}. This is
767      * zero by default.
768      *
769      * This value changes when {approve} or {transferFrom} are called.
770      */
771     function allowance(address owner, address spender) external view returns (uint256);
772 
773     /**
774      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
775      *
776      * Returns a boolean value indicating whether the operation succeeded.
777      *
778      * IMPORTANT: Beware that changing an allowance with this method brings the risk
779      * that someone may use both the old and the new allowance by unfortunate
780      * transaction ordering. One possible solution to mitigate this race
781      * condition is to first reduce the spender's allowance to 0 and set the
782      * desired value afterwards:
783      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
784      *
785      * Emits an {Approval} event.
786      */
787     function approve(address spender, uint256 amount) external returns (bool);
788 
789     /**
790      * @dev Moves `amount` tokens from `sender` to `recipient` using the
791      * allowance mechanism. `amount` is then deducted from the caller's
792      * allowance.
793      *
794      * Returns a boolean value indicating whether the operation succeeded.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
799 
800     // Additional mint and burn functions
801     function burn(address account, uint256 amount) external;
802     function mint(address account, uint256 amount) external;
803 
804     /**
805      * @dev Emitted when `value` tokens are moved from one account (`from`) to
806      * another (`to`).
807      *
808      * Note that `value` may be zero.
809      */
810     event Transfer(address indexed from, address indexed to, uint256 value);
811 
812     /**
813      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
814      * a call to {approve}. `value` is the new allowance.
815      */
816     event Approval(address indexed owner, address indexed spender, uint256 value);
817 }
818 
819 // File: contracts\TokenSwap.sol
820 
821 pragma solidity ^0.7.0;
822 
823 
824 
825 
826 contract TokenSwap is Ownable {
827     ERC20Burnable public immutable xftOld;
828     ElasticIERC20 public immutable xftNew;
829     bool public active;
830     address public contract_address;
831 
832     constructor(ERC20Burnable _xftOld, ElasticIERC20 _xftNew) {
833         xftOld = _xftOld;
834         xftNew = _xftNew;
835         active = false;
836         contract_address = address(0x0);
837     }
838     event XFTUpgraded(address user, uint256 amount);
839     function upgrade() public {
840         if (!active) {
841             require(msg.sender == contract_address, "You can't upgrade yet");
842         }
843         uint256 amount = xftOld.balanceOf(msg.sender);
844         require(amount > 0, "User has no tokens");
845         require(xftOld.allowance(msg.sender, address(this)) >= amount, "User must approve tokens first");
846         xftOld.transferFrom(msg.sender, address(this), amount); //Tokens need to be transferred
847         require(xftOld.balanceOf(address(this)) >= amount, "Insufficient balance");
848         xftOld.burn(amount);
849         xftNew.mint(msg.sender, amount);
850         emit XFTUpgraded(msg.sender, amount);
851     }
852 
853     function setActive() onlyOwner public{
854         require(!active, "switch already triggered");
855         active = true;
856     }
857     function setContract(address _contract) onlyOwner public {
858         require(!active, "switch already triggered");
859         contract_address = _contract;
860     }
861 }