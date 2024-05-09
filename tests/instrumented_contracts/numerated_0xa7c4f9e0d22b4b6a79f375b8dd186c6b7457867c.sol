1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () internal {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         uint256 c = a + b;
111         if (c < a) return (false, 0);
112         return (true, c);
113     }
114 
115     /**
116      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
117      *
118      * _Available since v3.4._
119      */
120     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
121         if (b > a) return (false, 0);
122         return (true, a - b);
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) return (true, 0);
135         uint256 c = a * b;
136         if (c / a != b) return (false, 0);
137         return (true, c);
138     }
139 
140     /**
141      * @dev Returns the division of two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         if (b == 0) return (false, 0);
147         return (true, a / b);
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
152      *
153      * _Available since v3.4._
154      */
155     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
156         if (b == 0) return (false, 0);
157         return (true, a % b);
158     }
159 
160     /**
161      * @dev Returns the addition of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `+` operator.
165      *
166      * Requirements:
167      *
168      * - Addition cannot overflow.
169      */
170     function add(uint256 a, uint256 b) internal pure returns (uint256) {
171         uint256 c = a + b;
172         require(c >= a, "SafeMath: addition overflow");
173         return c;
174     }
175 
176     /**
177      * @dev Returns the subtraction of two unsigned integers, reverting on
178      * overflow (when the result is negative).
179      *
180      * Counterpart to Solidity's `-` operator.
181      *
182      * Requirements:
183      *
184      * - Subtraction cannot overflow.
185      */
186     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187         require(b <= a, "SafeMath: subtraction overflow");
188         return a - b;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         if (a == 0) return 0;
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers, reverting on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         require(b > 0, "SafeMath: division by zero");
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         require(b > 0, "SafeMath: modulo by zero");
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b <= a, errorMessage);
257         return a - b;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
262      * division by zero. The result is rounded towards zero.
263      *
264      * CAUTION: This function is deprecated because it requires allocating memory for the error
265      * message unnecessarily. For custom revert reasons use {tryDiv}.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b > 0, errorMessage);
277         return a / b;
278     }
279 
280     /**
281      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
282      * reverting with custom message when dividing by zero.
283      *
284      * CAUTION: This function is deprecated because it requires allocating memory for the error
285      * message unnecessarily. For custom revert reasons use {tryMod}.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296         require(b > 0, errorMessage);
297         return a % b;
298     }
299 }
300 
301 /**
302  * @dev Interface of the ERC20 standard as defined in the EIP.
303  */
304 interface IERC20 {
305     /**
306      * @dev Returns the amount of tokens in existence.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns the amount of tokens owned by `account`.
312      */
313     function balanceOf(address account) external view returns (uint256);
314 
315     /**
316      * @dev Moves `amount` tokens from the caller's account to `recipient`.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transfer(address recipient, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Returns the remaining number of tokens that `spender` will be
326      * allowed to spend on behalf of `owner` through {transferFrom}. This is
327      * zero by default.
328      *
329      * This value changes when {approve} or {transferFrom} are called.
330      */
331     function allowance(address owner, address spender) external view returns (uint256);
332 
333     /**
334      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * IMPORTANT: Beware that changing an allowance with this method brings the risk
339      * that someone may use both the old and the new allowance by unfortunate
340      * transaction ordering. One possible solution to mitigate this race
341      * condition is to first reduce the spender's allowance to 0 and set the
342      * desired value afterwards:
343      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address spender, uint256 amount) external returns (bool);
348 
349     /**
350      * @dev Moves `amount` tokens from `sender` to `recipient` using the
351      * allowance mechanism. `amount` is then deducted from the caller's
352      * allowance.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Emitted when `value` tokens are moved from one account (`from`) to
362      * another (`to`).
363      *
364      * Note that `value` may be zero.
365      */
366     event Transfer(address indexed from, address indexed to, uint256 value);
367 
368     /**
369      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
370      * a call to {approve}. `value` is the new allowance.
371      */
372     event Approval(address indexed owner, address indexed spender, uint256 value);
373 }
374 
375 /**
376  * @dev Implementation of the {IERC20} interface.
377  *
378  * This implementation is agnostic to the way tokens are created. This means
379  * that a supply mechanism has to be added in a derived contract using {_mint}.
380  * For a generic mechanism see {ERC20PresetMinterPauser}.
381  *
382  * TIP: For a detailed writeup see our guide
383  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
384  * to implement supply mechanisms].
385  *
386  * We have followed general OpenZeppelin guidelines: functions revert instead
387  * of returning `false` on failure. This behavior is nonetheless conventional
388  * and does not conflict with the expectations of ERC20 applications.
389  *
390  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
391  * This allows applications to reconstruct the allowance for all accounts just
392  * by listening to said events. Other implementations of the EIP may not emit
393  * these events, as it isn't required by the specification.
394  *
395  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
396  * functions have been added to mitigate the well-known issues around setting
397  * allowances. See {IERC20-approve}.
398  */
399 contract ERC20 is Context, IERC20 {
400     using SafeMath for uint256;
401 
402     mapping (address => uint256) private _balances;
403 
404     mapping (address => mapping (address => uint256)) private _allowances;
405 
406     uint256 private _totalSupply;
407 
408     string private _name;
409     string private _symbol;
410     uint8 private _decimals;
411 
412     /**
413      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
414      * a default value of 18.
415      *
416      * To select a different value for {decimals}, use {_setupDecimals}.
417      *
418      * All three of these values are immutable: they can only be set once during
419      * construction.
420      */
421     constructor (string memory name_, string memory symbol_) public {
422         _name = name_;
423         _symbol = symbol_;
424         _decimals = 18;
425     }
426 
427     /**
428      * @dev Returns the name of the token.
429      */
430     function name() public view virtual returns (string memory) {
431         return _name;
432     }
433 
434     /**
435      * @dev Returns the symbol of the token, usually a shorter version of the
436      * name.
437      */
438     function symbol() public view virtual returns (string memory) {
439         return _symbol;
440     }
441 
442     /**
443      * @dev Returns the number of decimals used to get its user representation.
444      * For example, if `decimals` equals `2`, a balance of `505` tokens should
445      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
446      *
447      * Tokens usually opt for a value of 18, imitating the relationship between
448      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
449      * called.
450      *
451      * NOTE: This information is only used for _display_ purposes: it in
452      * no way affects any of the arithmetic of the contract, including
453      * {IERC20-balanceOf} and {IERC20-transfer}.
454      */
455     function decimals() public view virtual returns (uint8) {
456         return _decimals;
457     }
458 
459     /**
460      * @dev See {IERC20-totalSupply}.
461      */
462     function totalSupply() public view virtual override returns (uint256) {
463         return _totalSupply;
464     }
465 
466     /**
467      * @dev See {IERC20-balanceOf}.
468      */
469     function balanceOf(address account) public view virtual override returns (uint256) {
470         return _balances[account];
471     }
472 
473     /**
474      * @dev See {IERC20-transfer}.
475      *
476      * Requirements:
477      *
478      * - `recipient` cannot be the zero address.
479      * - the caller must have a balance of at least `amount`.
480      */
481     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(_msgSender(), recipient, amount);
483         return true;
484     }
485 
486     /**
487      * @dev See {IERC20-allowance}.
488      */
489     function allowance(address owner, address spender) public view virtual override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     /**
494      * @dev See {IERC20-approve}.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      */
500     function approve(address spender, uint256 amount) public virtual override returns (bool) {
501         _approve(_msgSender(), spender, amount);
502         return true;
503     }
504 
505     /**
506      * @dev See {IERC20-transferFrom}.
507      *
508      * Emits an {Approval} event indicating the updated allowance. This is not
509      * required by the EIP. See the note at the beginning of {ERC20}.
510      *
511      * Requirements:
512      *
513      * - `sender` and `recipient` cannot be the zero address.
514      * - `sender` must have a balance of at least `amount`.
515      * - the caller must have allowance for ``sender``'s tokens of at least
516      * `amount`.
517      */
518     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
519         _transfer(sender, recipient, amount);
520         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
521         return true;
522     }
523 
524     /**
525      * @dev Atomically increases the allowance granted to `spender` by the caller.
526      *
527      * This is an alternative to {approve} that can be used as a mitigation for
528      * problems described in {IERC20-approve}.
529      *
530      * Emits an {Approval} event indicating the updated allowance.
531      *
532      * Requirements:
533      *
534      * - `spender` cannot be the zero address.
535      */
536     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
537         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
538         return true;
539     }
540 
541     /**
542      * @dev Atomically decreases the allowance granted to `spender` by the caller.
543      *
544      * This is an alternative to {approve} that can be used as a mitigation for
545      * problems described in {IERC20-approve}.
546      *
547      * Emits an {Approval} event indicating the updated allowance.
548      *
549      * Requirements:
550      *
551      * - `spender` cannot be the zero address.
552      * - `spender` must have allowance for the caller of at least
553      * `subtractedValue`.
554      */
555     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
557         return true;
558     }
559 
560     /**
561      * @dev Moves tokens `amount` from `sender` to `recipient`.
562      *
563      * This is internal function is equivalent to {transfer}, and can be used to
564      * e.g. implement automatic token fees, slashing mechanisms, etc.
565      *
566      * Emits a {Transfer} event.
567      *
568      * Requirements:
569      *
570      * - `sender` cannot be the zero address.
571      * - `recipient` cannot be the zero address.
572      * - `sender` must have a balance of at least `amount`.
573      */
574     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
575         require(sender != address(0), "ERC20: transfer from the zero address");
576         require(recipient != address(0), "ERC20: transfer to the zero address");
577 
578         _beforeTokenTransfer(sender, recipient, amount);
579 
580         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
581         _balances[recipient] = _balances[recipient].add(amount);
582         emit Transfer(sender, recipient, amount);
583     }
584 
585     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
586      * the total supply.
587      *
588      * Emits a {Transfer} event with `from` set to the zero address.
589      *
590      * Requirements:
591      *
592      * - `to` cannot be the zero address.
593      */
594     function _mint(address account, uint256 amount) internal virtual {
595         require(account != address(0), "ERC20: mint to the zero address");
596 
597         _beforeTokenTransfer(address(0), account, amount);
598 
599         _totalSupply = _totalSupply.add(amount);
600         _balances[account] = _balances[account].add(amount);
601         emit Transfer(address(0), account, amount);
602     }
603 
604     /**
605      * @dev Destroys `amount` tokens from `account`, reducing the
606      * total supply.
607      *
608      * Emits a {Transfer} event with `to` set to the zero address.
609      *
610      * Requirements:
611      *
612      * - `account` cannot be the zero address.
613      * - `account` must have at least `amount` tokens.
614      */
615     function _burn(address account, uint256 amount) internal virtual {
616         require(account != address(0), "ERC20: burn from the zero address");
617 
618         _beforeTokenTransfer(account, address(0), amount);
619 
620         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
621         _totalSupply = _totalSupply.sub(amount);
622         emit Transfer(account, address(0), amount);
623     }
624 
625     /**
626      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
627      *
628      * This internal function is equivalent to `approve`, and can be used to
629      * e.g. set automatic allowances for certain subsystems, etc.
630      *
631      * Emits an {Approval} event.
632      *
633      * Requirements:
634      *
635      * - `owner` cannot be the zero address.
636      * - `spender` cannot be the zero address.
637      */
638     function _approve(address owner, address spender, uint256 amount) internal virtual {
639         require(owner != address(0), "ERC20: approve from the zero address");
640         require(spender != address(0), "ERC20: approve to the zero address");
641 
642         _allowances[owner][spender] = amount;
643         emit Approval(owner, spender, amount);
644     }
645 
646     /**
647      * @dev Sets {decimals} to a value other than the default one of 18.
648      *
649      * WARNING: This function should only be called from the constructor. Most
650      * applications that interact with token contracts will not expect
651      * {decimals} to ever change, and may work incorrectly if it does.
652      */
653     function _setupDecimals(uint8 decimals_) internal virtual {
654         _decimals = decimals_;
655     }
656 
657     /**
658      * @dev Hook that is called before any transfer of tokens. This includes
659      * minting and burning.
660      *
661      * Calling conditions:
662      *
663      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
664      * will be to transferred to `to`.
665      * - when `from` is zero, `amount` tokens will be minted for `to`.
666      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
667      * - `from` and `to` are never both zero.
668      *
669      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
670      */
671     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
672 }
673 
674 abstract contract LMTBasic is IERC20 {
675 	function addLocked(address _userAddress, uint _locked) virtual public;
676 }
677 
678 contract TokenSale is Ownable {
679     
680     using SafeMath for uint;
681 
682 	uint public constant SALE_DURATION = 3 days;
683 	uint public constant EXCHANGE_RATIO = 8;
684 
685 	IERC20 public LYM;
686 	LMTBasic public LMT;
687 
688 	uint public lymCollected;
689 	uint public tokensSold;
690 
691 	// Stage 1
692 	uint public startDate;
693 
694 	address public wallet1Receiver;
695 	address public wallet2Receiver;
696 
697 	event Bought(address indexed user, uint indexed lymAmount, uint lmtAmount);
698 	event Claimed(address indexed user, uint lmtAmount);
699 
700 	constructor(
701 		address _lymAddress,
702 		address _lmtAddress,
703 		uint _startDate,
704 		address _wallet1Receiver,
705 		address _wallet2Receiver
706 	) 
707 		public 
708 	{
709 		startDate = _startDate;
710 
711 		LYM = IERC20(_lymAddress);
712 		LMT = LMTBasic(_lmtAddress);
713 		
714 		wallet1Receiver = _wallet1Receiver;
715 		wallet2Receiver = _wallet2Receiver;
716 	}
717 
718 	function buy(uint _lymAmount) public {
719 	    require(startDate < block.timestamp && block.timestamp < startDate + SALE_DURATION, "sale is closed");
720 
721 		require(LYM.transferFrom(msg.sender, owner(), _lymAmount));
722 		lymCollected = lymCollected.add(_lymAmount);
723 		
724 		uint lmtAmount = _lymAmount.div(EXCHANGE_RATIO);
725 		LMT.addLocked(msg.sender, lmtAmount);
726 		LMT.transfer(msg.sender, lmtAmount);
727 
728 		tokensSold = tokensSold.add(lmtAmount);
729 		emit Bought(msg.sender, _lymAmount, lmtAmount);
730 	}
731 
732 	// -----------------------------------------------
733 	// --------------Owner functions------------------
734 	// -----------------------------------------------
735 	
736 	function withdrawUnsoldTokens() public onlyOwner {
737 		require(block.timestamp > startDate + SALE_DURATION, "not a finish time");
738 
739 		uint balance = LMT.balanceOf(address(this));
740 
741 		LMT.transfer(wallet1Receiver, balance/3);
742 		LMT.transfer(wallet2Receiver, balance*2/3);
743 	}
744 
745 	function withdrawLostTokens(address _tokenAddress) public onlyOwner {
746 		require(block.timestamp > startDate + SALE_DURATION, "not a finish time");
747 		require(_tokenAddress != address(LMT), "can't withdraw LMT");
748 
749 		if(_tokenAddress == address(0)) {
750 			msg.sender.transfer(address(this).balance);
751 			return;
752 		}
753 
754 		IERC20(_tokenAddress).transfer(msg.sender, IERC20(_tokenAddress).balanceOf(address(this)));
755 	}
756 }