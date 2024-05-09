1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Context
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC20
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
106 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeMath
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
319 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC20
320 
321 /**
322  * @dev Implementation of the {IERC20} interface.
323  *
324  * This implementation is agnostic to the way tokens are created. This means
325  * that a supply mechanism has to be added in a derived contract using {_mint}.
326  * For a generic mechanism see {ERC20PresetMinterPauser}.
327  *
328  * TIP: For a detailed writeup see our guide
329  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
330  * to implement supply mechanisms].
331  *
332  * We have followed general OpenZeppelin guidelines: functions revert instead
333  * of returning `false` on failure. This behavior is nonetheless conventional
334  * and does not conflict with the expectations of ERC20 applications.
335  *
336  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
337  * This allows applications to reconstruct the allowance for all accounts just
338  * by listening to said events. Other implementations of the EIP may not emit
339  * these events, as it isn't required by the specification.
340  *
341  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
342  * functions have been added to mitigate the well-known issues around setting
343  * allowances. See {IERC20-approve}.
344  */
345 contract ERC20 is Context, IERC20 {
346     using SafeMath for uint256;
347 
348     mapping (address => uint256) private _balances;
349 
350     mapping (address => mapping (address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
360      * a default value of 18.
361      *
362      * To select a different value for {decimals}, use {_setupDecimals}.
363      *
364      * All three of these values are immutable: they can only be set once during
365      * construction.
366      */
367     constructor (string memory name_, string memory symbol_) public {
368         _name = name_;
369         _symbol = symbol_;
370         _decimals = 18;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view virtual returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view virtual returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
395      * called.
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view virtual returns (uint8) {
402         return _decimals;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view virtual override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view virtual override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20}.
456      *
457      * Requirements:
458      *
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     /**
507      * @dev Moves tokens `amount` from `sender` to `recipient`.
508      *
509      * This is internal function is equivalent to {transfer}, and can be used to
510      * e.g. implement automatic token fees, slashing mechanisms, etc.
511      *
512      * Emits a {Transfer} event.
513      *
514      * Requirements:
515      *
516      * - `sender` cannot be the zero address.
517      * - `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      */
520     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
521         require(sender != address(0), "ERC20: transfer from the zero address");
522         require(recipient != address(0), "ERC20: transfer to the zero address");
523 
524         _beforeTokenTransfer(sender, recipient, amount);
525 
526         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply = _totalSupply.add(amount);
546         _balances[account] = _balances[account].add(amount);
547         emit Transfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
567         _totalSupply = _totalSupply.sub(amount);
568         emit Transfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
573      *
574      * This internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(address owner, address spender, uint256 amount) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Sets {decimals} to a value other than the default one of 18.
594      *
595      * WARNING: This function should only be called from the constructor. Most
596      * applications that interact with token contracts will not expect
597      * {decimals} to ever change, and may work incorrectly if it does.
598      */
599     function _setupDecimals(uint8 decimals_) internal virtual {
600         _decimals = decimals_;
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be to transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
618 }
619 
620 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Ownable
621 
622 /**
623  * @dev Contract module which provides a basic access control mechanism, where
624  * there is an account (an owner) that can be granted exclusive access to
625  * specific functions.
626  *
627  * By default, the owner account will be the one that deploys the contract. This
628  * can later be changed with {transferOwnership}.
629  *
630  * This module is used through inheritance. It will make available the modifier
631  * `onlyOwner`, which can be applied to your functions to restrict their use to
632  * the owner.
633  */
634 abstract contract Ownable is Context {
635     address private _owner;
636 
637     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
638 
639     /**
640      * @dev Initializes the contract setting the deployer as the initial owner.
641      */
642     constructor () internal {
643         address msgSender = _msgSender();
644         _owner = msgSender;
645         emit OwnershipTransferred(address(0), msgSender);
646     }
647 
648     /**
649      * @dev Returns the address of the current owner.
650      */
651     function owner() public view virtual returns (address) {
652         return _owner;
653     }
654 
655     /**
656      * @dev Throws if called by any account other than the owner.
657      */
658     modifier onlyOwner() {
659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
660         _;
661     }
662 
663     /**
664      * @dev Leaves the contract without owner. It will not be possible to call
665      * `onlyOwner` functions anymore. Can only be called by the current owner.
666      *
667      * NOTE: Renouncing ownership will leave the contract without an owner,
668      * thereby removing any functionality that is only available to the owner.
669      */
670     function renounceOwnership() public virtual onlyOwner {
671         emit OwnershipTransferred(_owner, address(0));
672         _owner = address(0);
673     }
674 
675     /**
676      * @dev Transfers ownership of the contract to a new account (`newOwner`).
677      * Can only be called by the current owner.
678      */
679     function transferOwnership(address newOwner) public virtual onlyOwner {
680         require(newOwner != address(0), "Ownable: new owner is the zero address");
681         emit OwnershipTransferred(_owner, newOwner);
682         _owner = newOwner;
683     }
684 }
685 
686 // File: BagsERC20.sol
687 
688 contract Bags is ERC20, Ownable {
689     using SafeMath for uint256;
690 
691     uint256 immutable public MAX_BAGS;
692 
693     constructor(uint256 _maxBags)
694         ERC20("Degen$ Farm Bags", "BAGZ")
695     {
696         MAX_BAGS = _maxBags;
697     }
698 
699     function mint(address to, uint256 amount) external onlyOwner {
700         require(totalSupply() <= MAX_BAGS.sub(amount), "MAX bags amount exceed!");
701         _mint(to, amount);
702     }
703 
704     function burn(address to, uint256 amount) external onlyOwner {
705         _burn(to, amount);
706     }
707 
708     /**
709      * @dev Owner can claim any tokens that transfered
710      * to this contract address
711      */
712     function reclaimToken(ERC20 token) external onlyOwner {
713         require(address(token) != address(0));
714         uint256 balance = token.balanceOf(address(this));
715         token.transfer(owner(), balance);
716     }
717 
718     /**
719      * @dev This function implement proxy for before transfer hook form OpenZeppelin ERC20.
720      *
721      * It use interface for call checker function from external (or this) contract  defined
722      * defined by owner.
723      */
724     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
725         require(to != address(this), "This contract not accept tokens" );
726     }
727 
728     /**
729      * @dev Returns the number of decimals used to get its user representation.
730      * For example, if `decimals` equals `2`, a balance of `505` tokens should
731      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
732      *
733      * Tokens usually opt for a value of 18, imitating the relationship between
734      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
735      * called.
736      *
737      * NOTE: This information is only used for _display_ purposes: it in
738      * no way affects any of the arithmetic of the contract, including
739      * {IERC20-balanceOf} and {IERC20-transfer}.
740      */
741     function decimals() public view override returns (uint8) {
742         return 0;
743     }
744 }
