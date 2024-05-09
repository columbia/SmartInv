1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 pragma solidity >=0.6.0 <0.8.0;
221 
222 /*
223  * @dev Provides information about the current execution context, including the
224  * sender of the transaction and its data. While these are generally available
225  * via msg.sender and msg.data, they should not be accessed in such a direct
226  * manner, since when dealing with GSN meta-transactions the account sending and
227  * paying for execution may not be the actual sender (as far as an application
228  * is concerned).
229  *
230  * This contract is only required for intermediate, library-like contracts.
231  */
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
244 
245 pragma solidity >=0.6.0 <0.8.0;
246 
247 /**
248  * @dev Interface of the ERC20 standard as defined in the EIP.
249  */
250 interface IERC20 {
251     /**
252      * @dev Returns the amount of tokens in existence.
253      */
254     function totalSupply() external view returns (uint256);
255 
256     /**
257      * @dev Returns the amount of tokens owned by `account`.
258      */
259     function balanceOf(address account) external view returns (uint256);
260 
261     /**
262      * @dev Moves `amount` tokens from the caller's account to `recipient`.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transfer(address recipient, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Returns the remaining number of tokens that `spender` will be
272      * allowed to spend on behalf of `owner` through {transferFrom}. This is
273      * zero by default.
274      *
275      * This value changes when {approve} or {transferFrom} are called.
276      */
277     function allowance(address owner, address spender) external view returns (uint256);
278 
279     /**
280      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * IMPORTANT: Beware that changing an allowance with this method brings the risk
285      * that someone may use both the old and the new allowance by unfortunate
286      * transaction ordering. One possible solution to mitigate this race
287      * condition is to first reduce the spender's allowance to 0 and set the
288      * desired value afterwards:
289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address spender, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Moves `amount` tokens from `sender` to `recipient` using the
297      * allowance mechanism. `amount` is then deducted from the caller's
298      * allowance.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Emitted when `value` tokens are moved from one account (`from`) to
308      * another (`to`).
309      *
310      * Note that `value` may be zero.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 value);
313 
314     /**
315      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
316      * a call to {approve}. `value` is the new allowance.
317      */
318     event Approval(address indexed owner, address indexed spender, uint256 value);
319 }
320 
321 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
627 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
628 
629 pragma solidity >=0.6.0 <0.8.0;
630 
631 
632 /**
633  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
634  */
635 abstract contract ERC20Capped is ERC20 {
636     using SafeMath for uint256;
637 
638     uint256 private _cap;
639 
640     /**
641      * @dev Sets the value of the `cap`. This value is immutable, it can only be
642      * set once during construction.
643      */
644     constructor (uint256 cap_) internal {
645         require(cap_ > 0, "ERC20Capped: cap is 0");
646         _cap = cap_;
647     }
648 
649     /**
650      * @dev Returns the cap on the token's total supply.
651      */
652     function cap() public view virtual returns (uint256) {
653         return _cap;
654     }
655 
656     /**
657      * @dev See {ERC20-_beforeTokenTransfer}.
658      *
659      * Requirements:
660      *
661      * - minted tokens must not cause the total supply to go over the cap.
662      */
663     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
664         super._beforeTokenTransfer(from, to, amount);
665 
666         if (from == address(0)) { // When minting tokens
667             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
668         }
669     }
670 }
671 
672 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
673 
674 pragma solidity >=0.6.0 <0.8.0;
675 
676 
677 
678 /**
679  * @dev Extension of {ERC20} that allows token holders to destroy both their own
680  * tokens and those that they have an allowance for, in a way that can be
681  * recognized off-chain (via event analysis).
682  */
683 abstract contract ERC20Burnable is Context, ERC20 {
684     using SafeMath for uint256;
685 
686     /**
687      * @dev Destroys `amount` tokens from the caller.
688      *
689      * See {ERC20-_burn}.
690      */
691     function burn(uint256 amount) public virtual {
692         _burn(_msgSender(), amount);
693     }
694 
695     /**
696      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
697      * allowance.
698      *
699      * See {ERC20-_burn} and {ERC20-allowance}.
700      *
701      * Requirements:
702      *
703      * - the caller must have allowance for ``accounts``'s tokens of at least
704      * `amount`.
705      */
706     function burnFrom(address account, uint256 amount) public virtual {
707         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
708 
709         _approve(account, _msgSender(), decreasedAllowance);
710         _burn(account, amount);
711     }
712 }
713 
714 // File: @openzeppelin/contracts/access/Ownable.sol
715 
716 pragma solidity >=0.6.0 <0.8.0;
717 
718 /**
719  * @dev Contract module which provides a basic access control mechanism, where
720  * there is an account (an owner) that can be granted exclusive access to
721  * specific functions.
722  *
723  * By default, the owner account will be the one that deploys the contract. This
724  * can later be changed with {transferOwnership}.
725  *
726  * This module is used through inheritance. It will make available the modifier
727  * `onlyOwner`, which can be applied to your functions to restrict their use to
728  * the owner.
729  */
730 abstract contract Ownable is Context {
731     address private _owner;
732 
733     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
734 
735     /**
736      * @dev Initializes the contract setting the deployer as the initial owner.
737      */
738     constructor () internal {
739         address msgSender = _msgSender();
740         _owner = msgSender;
741         emit OwnershipTransferred(address(0), msgSender);
742     }
743 
744     /**
745      * @dev Returns the address of the current owner.
746      */
747     function owner() public view virtual returns (address) {
748         return _owner;
749     }
750 
751     /**
752      * @dev Throws if called by any account other than the owner.
753      */
754     modifier onlyOwner() {
755         require(owner() == _msgSender(), "Ownable: caller is not the owner");
756         _;
757     }
758 
759     /**
760      * @dev Leaves the contract without owner. It will not be possible to call
761      * `onlyOwner` functions anymore. Can only be called by the current owner.
762      *
763      * NOTE: Renouncing ownership will leave the contract without an owner,
764      * thereby removing any functionality that is only available to the owner.
765      */
766     function renounceOwnership() public virtual onlyOwner {
767         emit OwnershipTransferred(_owner, address(0));
768         _owner = address(0);
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (`newOwner`).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         emit OwnershipTransferred(_owner, newOwner);
778         _owner = newOwner;
779     }
780 }
781 
782 // File: contracts/Staking/DHP.sol
783 
784 pragma solidity ^0.7.0;
785 
786 
787 
788 
789 
790 contract DHP is ERC20Capped, ERC20Burnable, Ownable {
791     using SafeMath for uint;
792 
793     constructor(uint totalSupply, address assetManager) ERC20("dHealth", "DHP") ERC20Capped(totalSupply) {
794         _mint(assetManager, totalSupply);
795     }
796 
797     function _beforeTokenTransfer(
798         address from,
799         address to,
800         uint256 amount
801     ) internal virtual override(ERC20, ERC20Capped) {
802         super._beforeTokenTransfer(from, to, amount);
803     }
804 }