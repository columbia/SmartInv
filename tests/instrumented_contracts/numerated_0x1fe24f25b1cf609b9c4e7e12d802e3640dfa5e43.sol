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
26 // File: contracts\lib\token\ERC20\IERC20.sol
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: contracts\lib\math\SafeMath.sol
105 
106 pragma solidity >=0.6.0 <0.8.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, with an overflow flag.
124      *
125      * _Available since v3.4._
126      */
127     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
128         uint256 c = a + b;
129         if (c < a) return (false, 0);
130         return (true, c);
131     }
132 
133     /**
134      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b > a) return (false, 0);
140         return (true, a - b);
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) return (true, 0);
153         uint256 c = a * b;
154         if (c / a != b) return (false, 0);
155         return (true, c);
156     }
157 
158     /**
159      * @dev Returns the division of two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         if (b == 0) return (false, 0);
165         return (true, a / b);
166     }
167 
168     /**
169      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a % b);
176     }
177 
178     /**
179      * @dev Returns the addition of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `+` operator.
183      *
184      * Requirements:
185      *
186      * - Addition cannot overflow.
187      */
188     function add(uint256 a, uint256 b) internal pure returns (uint256) {
189         uint256 c = a + b;
190         require(c >= a, "SafeMath: addition overflow");
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         require(b <= a, "SafeMath: subtraction overflow");
206         return a - b;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      *
217      * - Multiplication cannot overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         if (a == 0) return 0;
221         uint256 c = a * b;
222         require(c / a == b, "SafeMath: multiplication overflow");
223         return c;
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers, reverting on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b > 0, "SafeMath: division by zero");
240         return a / b;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * reverting when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b > 0, "SafeMath: modulo by zero");
257         return a % b;
258     }
259 
260     /**
261      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
262      * overflow (when the result is negative).
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {trySub}.
266      *
267      * Counterpart to Solidity's `-` operator.
268      *
269      * Requirements:
270      *
271      * - Subtraction cannot overflow.
272      */
273     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b <= a, errorMessage);
275         return a - b;
276     }
277 
278     /**
279      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
280      * division by zero. The result is rounded towards zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryDiv}.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a / b;
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * reverting with custom message when dividing by zero.
301      *
302      * CAUTION: This function is deprecated because it requires allocating memory for the error
303      * message unnecessarily. For custom revert reasons use {tryMod}.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b > 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 // File: contracts\lib\token\ERC20\ERC20.sol
320 
321 
322 pragma solidity >=0.6.0 <0.8.0;
323 
324 
325 
326 
327 /**
328  * @dev Implementation of the {IERC20} interface.
329  *
330  * This implementation is agnostic to the way tokens are created. This means
331  * that a supply mechanism has to be added in a derived contract using {_mint}.
332  * For a generic mechanism see {ERC20PresetMinterPauser}.
333  *
334  * TIP: For a detailed writeup see our guide
335  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
336  * to implement supply mechanisms].
337  *
338  * We have followed general OpenZeppelin guidelines: functions revert instead
339  * of returning `false` on failure. This behavior is nonetheless conventional
340  * and does not conflict with the expectations of ERC20 applications.
341  *
342  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
343  * This allows applications to reconstruct the allowance for all accounts just
344  * by listening to said events. Other implementations of the EIP may not emit
345  * these events, as it isn't required by the specification.
346  *
347  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
348  * functions have been added to mitigate the well-known issues around setting
349  * allowances. See {IERC20-approve}.
350  */
351 contract ERC20 is Context, IERC20 {
352     using SafeMath for uint256;
353 
354     mapping (address => uint256) private _balances;
355 
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     uint256 private _totalSupply;
359 
360     string private _name;
361     string private _symbol;
362     uint8 private _decimals;
363 
364     /**
365      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
366      * a default value of 18.
367      *
368      * To select a different value for {decimals}, use {_setupDecimals}.
369      *
370      * All three of these values are immutable: they can only be set once during
371      * construction.
372      */
373     constructor (string memory name_, string memory symbol_) {
374         _name = name_;
375         _symbol = symbol_;
376         _decimals = 18;
377     }
378 
379     /**
380      * @dev Returns the name of the token.
381      */
382     function name() public view virtual returns (string memory) {
383         return _name;
384     }
385 
386     /**
387      * @dev Returns the symbol of the token, usually a shorter version of the
388      * name.
389      */
390     function symbol() public view virtual returns (string memory) {
391         return _symbol;
392     }
393 
394     /**
395      * @dev Returns the number of decimals used to get its user representation.
396      * For example, if `decimals` equals `2`, a balance of `505` tokens should
397      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
398      *
399      * Tokens usually opt for a value of 18, imitating the relationship between
400      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
401      * called.
402      *
403      * NOTE: This information is only used for _display_ purposes: it in
404      * no way affects any of the arithmetic of the contract, including
405      * {IERC20-balanceOf} and {IERC20-transfer}.
406      */
407     function decimals() public view virtual returns (uint8) {
408         return _decimals;
409     }
410 
411     /**
412      * @dev See {IERC20-totalSupply}.
413      */
414     function totalSupply() public view virtual override returns (uint256) {
415         return _totalSupply;
416     }
417 
418     /**
419      * @dev See {IERC20-balanceOf}.
420      */
421     function balanceOf(address account) public view virtual override returns (uint256) {
422         return _balances[account];
423     }
424 
425     /**
426      * @dev See {IERC20-transfer}.
427      *
428      * Requirements:
429      *
430      * - `recipient` cannot be the zero address.
431      * - the caller must have a balance of at least `amount`.
432      */
433     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
434         _transfer(_msgSender(), recipient, amount);
435         return true;
436     }
437 
438     /**
439      * @dev See {IERC20-allowance}.
440      */
441     function allowance(address owner, address spender) public view virtual override returns (uint256) {
442         return _allowances[owner][spender];
443     }
444 
445     /**
446      * @dev See {IERC20-approve}.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      */
452     function approve(address spender, uint256 amount) public virtual override returns (bool) {
453         _approve(_msgSender(), spender, amount);
454         return true;
455     }
456 
457     /**
458      * @dev See {IERC20-transferFrom}.
459      *
460      * Emits an {Approval} event indicating the updated allowance. This is not
461      * required by the EIP. See the note at the beginning of {ERC20}.
462      *
463      * Requirements:
464      *
465      * - `sender` and `recipient` cannot be the zero address.
466      * - `sender` must have a balance of at least `amount`.
467      * - the caller must have allowance for ``sender``'s tokens of at least
468      * `amount`.
469      */
470     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
471         _transfer(sender, recipient, amount);
472         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
473         return true;
474     }
475 
476     /**
477      * @dev Atomically increases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
490         return true;
491     }
492 
493     /**
494      * @dev Atomically decreases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      * - `spender` must have allowance for the caller of at least
505      * `subtractedValue`.
506      */
507     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
508         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
509         return true;
510     }
511 
512     /**
513      * @dev Moves tokens `amount` from `sender` to `recipient`.
514      *
515      * This is internal function is equivalent to {transfer}, and can be used to
516      * e.g. implement automatic token fees, slashing mechanisms, etc.
517      *
518      * Emits a {Transfer} event.
519      *
520      * Requirements:
521      *
522      * - `sender` cannot be the zero address.
523      * - `recipient` cannot be the zero address.
524      * - `sender` must have a balance of at least `amount`.
525      */
526     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
527         require(sender != address(0), "ERC20: transfer from the zero address");
528         require(recipient != address(0), "ERC20: transfer to the zero address");
529 
530         _beforeTokenTransfer(sender, recipient, amount);
531 
532         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
533         _balances[recipient] = _balances[recipient].add(amount);
534         emit Transfer(sender, recipient, amount);
535     }
536 
537     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538      * the total supply.
539      *
540      * Emits a {Transfer} event with `from` set to the zero address.
541      *
542      * Requirements:
543      *
544      * - `to` cannot be the zero address.
545      */
546     function _mint(address account, uint256 amount) internal virtual {
547         require(account != address(0), "ERC20: mint to the zero address");
548 
549         _beforeTokenTransfer(address(0), account, amount);
550 
551         _totalSupply = _totalSupply.add(amount);
552         _balances[account] = _balances[account].add(amount);
553         emit Transfer(address(0), account, amount);
554     }
555 
556     /**
557      * @dev Destroys `amount` tokens from `account`, reducing the
558      * total supply.
559      *
560      * Emits a {Transfer} event with `to` set to the zero address.
561      *
562      * Requirements:
563      *
564      * - `account` cannot be the zero address.
565      * - `account` must have at least `amount` tokens.
566      */
567     function _burn(address account, uint256 amount) internal virtual {
568         require(account != address(0), "ERC20: burn from the zero address");
569 
570         _beforeTokenTransfer(account, address(0), amount);
571 
572         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
573         _totalSupply = _totalSupply.sub(amount);
574         emit Transfer(account, address(0), amount);
575     }
576 
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
579      *
580      * This internal function is equivalent to `approve`, and can be used to
581      * e.g. set automatic allowances for certain subsystems, etc.
582      *
583      * Emits an {Approval} event.
584      *
585      * Requirements:
586      *
587      * - `owner` cannot be the zero address.
588      * - `spender` cannot be the zero address.
589      */
590     function _approve(address owner, address spender, uint256 amount) internal virtual {
591         require(owner != address(0), "ERC20: approve from the zero address");
592         require(spender != address(0), "ERC20: approve to the zero address");
593 
594         _allowances[owner][spender] = amount;
595         emit Approval(owner, spender, amount);
596     }
597 
598     /**
599      * @dev Sets {decimals} to a value other than the default one of 18.
600      *
601      * WARNING: This function should only be called from the constructor. Most
602      * applications that interact with token contracts will not expect
603      * {decimals} to ever change, and may work incorrectly if it does.
604      */
605     function _setupDecimals(uint8 decimals_) internal virtual {
606         _decimals = decimals_;
607     }
608 
609     /**
610      * @dev Hook that is called before any transfer of tokens. This includes
611      * minting and burning.
612      *
613      * Calling conditions:
614      *
615      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
616      * will be to transferred to `to`.
617      * - when `from` is zero, `amount` tokens will be minted for `to`.
618      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
619      * - `from` and `to` are never both zero.
620      *
621      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
622      */
623     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
624 }
625 
626 // File: contracts\lib\access\Ownable.sol
627 
628 
629 pragma solidity >=0.6.0 <0.8.0;
630 
631 /**
632  * @dev Contract module which provides a basic access control mechanism, where
633  * there is an account (an owner) that can be granted exclusive access to
634  * specific functions.
635  *
636  * By default, the owner account will be the one that deploys the contract. This
637  * can later be changed with {transferOwnership}.
638  *
639  * This module is used through inheritance. It will make available the modifier
640  * `onlyOwner`, which can be applied to your functions to restrict their use to
641  * the owner.
642  */
643 abstract contract Ownable is Context {
644     address private _owner;
645 
646     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
647 
648     /**
649      * @dev Initializes the contract setting the deployer as the initial owner.
650      */
651     constructor () {
652         address msgSender = _msgSender();
653         _owner = msgSender;
654         emit OwnershipTransferred(address(0), msgSender);
655     }
656 
657     /**
658      * @dev Returns the address of the current owner.
659      */
660     function owner() public view virtual returns (address) {
661         return _owner;
662     }
663 
664     /**
665      * @dev Throws if called by any account other than the owner.
666      */
667     modifier onlyOwner() {
668         require(owner() == _msgSender(), "Ownable: caller is not the owner");
669         _;
670     }
671 
672     /**
673      * @dev Leaves the contract without owner. It will not be possible to call
674      * `onlyOwner` functions anymore. Can only be called by the current owner.
675      *
676      * NOTE: Renouncing ownership will leave the contract without an owner,
677      * thereby removing any functionality that is only available to the owner.
678      */
679     function renounceOwnership() public virtual onlyOwner {
680         emit OwnershipTransferred(_owner, address(0));
681         _owner = address(0);
682     }
683 
684     /**
685      * @dev Transfers ownership of the contract to a new account (`newOwner`).
686      * Can only be called by the current owner.
687      */
688     function transferOwnership(address newOwner) public virtual onlyOwner {
689         require(newOwner != address(0), "Ownable: new owner is the zero address");
690         emit OwnershipTransferred(_owner, newOwner);
691         _owner = newOwner;
692     }
693 }
694 
695 // File: contracts\Freezable\Freezable.sol
696 
697 
698 pragma solidity ^0.7.0;
699 
700 //import "@openzeppelin/contracts/utils/Context.sol";
701 
702 /*
703 ** usage:
704 **   require(!isFrozen(_account), "Freezable: frozen");
705 ** or
706 **   modifier: whenAccountNotFrozen(address _account)
707 ** or 
708 **   require(!freezes[_from], "From account is locked.");
709 */
710 //abstract contract Freezable is Context {
711 abstract contract Freezable {
712     event Frozen(address account);
713     event Unfrozen(address account);
714     mapping(address => bool) internal freezes;
715 
716 
717     function isFrozen(address _account) public view virtual returns (bool) {
718         return freezes[_account];
719     }
720 
721     modifier whenAccountNotFrozen(address _account) {
722         require(!isFrozen(_account), "Freezable: frozen");
723         _;
724     }
725 
726     modifier whenAccountFrozen(address _account) {
727         require(isFrozen(_account), "Freezable: not frozen");
728         _;
729     }
730  
731 }
732 
733 // File: contracts\ERC677\IERC677.sol
734 
735 
736 pragma solidity ^0.7.0;
737 
738 //import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
739 //abstract contract IERC677 is IERC20 {
740 
741 abstract contract IERC677 {
742   function transferAndCall(address to, uint value, bytes memory data) public virtual returns (bool success);
743 
744   event Transfer(address indexed from, address indexed to, uint value, bytes data);
745   
746 }
747 
748 // File: contracts\ERC677\IERC677Receiver.sol
749 
750 
751 pragma solidity ^0.7.0;
752 
753 abstract contract IERC677Receiver {
754   function onTokenTransfer(address _sender, uint _value, bytes memory _data) public virtual;
755 }
756 
757 // File: contracts\CGGToken.sol
758 
759 
760 pragma solidity ^0.7.0;
761 
762 
763 
764 
765 
766 
767 /*
768 ** CGGToken
769 ** Standard ERC20 capabilities (Openzeppelin 3.4.0)
770 ** Implements ERC677 transferAndCall
771 ** Implements Freezable
772 */
773 contract CGGToken is ERC20, Freezable, Ownable {
774 
775     constructor(uint256 initialSupply) ERC20("ChainGuardians Governance Token", "CGG") {
776         _mint(msg.sender, initialSupply);
777     }
778 
779     /* /////////////////////////////
780     ** Freezable
781     ** /////////////////////////////
782     */
783     function _beforeTokenTransfer(address from, address to, uint256 amount) 
784         internal virtual override 
785     {
786         super._beforeTokenTransfer(from, to, amount);
787         
788         require(!isFrozen(from), "ERC20Freezable: from account is frozen");
789         require(!isFrozen(to), "ERC20Freezable: to account is frozen");
790     }
791 
792     function freeze(address _account) public onlyOwner {
793         freezes[_account] = true;
794         emit Frozen(_account);
795     }
796 
797     function unfreeze(address _account) public onlyOwner {
798         freezes[_account] = false;
799         emit Unfrozen(_account);
800     }
801 
802     /* /////////////////////////////
803     ** ERC677 Transfer and call
804     ** /////////////////////////////
805     */
806     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
807 
808     /**
809     * @dev transfer token to a contract address with additional data if the recipient is a contact.
810     * @param _to The address to transfer to.
811     * @param _value The amount to be transferred.
812     * @param _data The extra data to be passed to the receiving contract.
813     */
814     function transferAndCall(address _to, uint _value, bytes memory _data)
815         public
816         returns (bool success)
817     {
818         super.transfer(_to, _value);
819         emit Transfer(msg.sender, _to, _value, _data);
820         if (isContract(_to)) {
821             IERC677Receiver receiver = IERC677Receiver(_to);
822             receiver.onTokenTransfer(msg.sender, _value, _data);
823         }
824         return true;
825     }
826 
827     function isContract(address _addr)
828         private
829         view
830         returns (bool hasCode)
831     {
832         uint length;
833         assembly { length := extcodesize(_addr) }
834         return length > 0;
835     }
836 }