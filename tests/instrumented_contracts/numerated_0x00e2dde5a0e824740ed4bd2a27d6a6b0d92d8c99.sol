1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
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
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 
109 pragma solidity >=0.6.0 <0.8.0;
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, with an overflow flag.
127      *
128      * _Available since v3.4._
129      */
130     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
131         uint256 c = a + b;
132         if (c < a) return (false, 0);
133         return (true, c);
134     }
135 
136     /**
137      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
138      *
139      * _Available since v3.4._
140      */
141     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
142         if (b > a) return (false, 0);
143         return (true, a - b);
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) return (true, 0);
156         uint256 c = a * b;
157         if (c / a != b) return (false, 0);
158         return (true, c);
159     }
160 
161     /**
162      * @dev Returns the division of two unsigned integers, with a division by zero flag.
163      *
164      * _Available since v3.4._
165      */
166     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         if (b == 0) return (false, 0);
168         return (true, a / b);
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         if (b == 0) return (false, 0);
178         return (true, a % b);
179     }
180 
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      *
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a, "SafeMath: addition overflow");
194         return c;
195     }
196 
197     /**
198      * @dev Returns the subtraction of two unsigned integers, reverting on
199      * overflow (when the result is negative).
200      *
201      * Counterpart to Solidity's `-` operator.
202      *
203      * Requirements:
204      *
205      * - Subtraction cannot overflow.
206      */
207     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
208         require(b <= a, "SafeMath: subtraction overflow");
209         return a - b;
210     }
211 
212     /**
213      * @dev Returns the multiplication of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `*` operator.
217      *
218      * Requirements:
219      *
220      * - Multiplication cannot overflow.
221      */
222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
223         if (a == 0) return 0;
224         uint256 c = a * b;
225         require(c / a == b, "SafeMath: multiplication overflow");
226         return c;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers, reverting on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         require(b > 0, "SafeMath: division by zero");
243         return a / b;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * reverting when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         require(b > 0, "SafeMath: modulo by zero");
260         return a % b;
261     }
262 
263     /**
264      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
265      * overflow (when the result is negative).
266      *
267      * CAUTION: This function is deprecated because it requires allocating memory for the error
268      * message unnecessarily. For custom revert reasons use {trySub}.
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         return a - b;
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
283      * division by zero. The result is rounded towards zero.
284      *
285      * CAUTION: This function is deprecated because it requires allocating memory for the error
286      * message unnecessarily. For custom revert reasons use {tryDiv}.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b > 0, errorMessage);
298         return a / b;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * reverting with custom message when dividing by zero.
304      *
305      * CAUTION: This function is deprecated because it requires allocating memory for the error
306      * message unnecessarily. For custom revert reasons use {tryMod}.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
317         require(b > 0, errorMessage);
318         return a % b;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
323 
324 
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 
328 
329 
330 /**
331  * @dev Implementation of the {IERC20} interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using {_mint}.
335  * For a generic mechanism see {ERC20PresetMinterPauser}.
336  *
337  * TIP: For a detailed writeup see our guide
338  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
339  * to implement supply mechanisms].
340  *
341  * We have followed general OpenZeppelin guidelines: functions revert instead
342  * of returning `false` on failure. This behavior is nonetheless conventional
343  * and does not conflict with the expectations of ERC20 applications.
344  *
345  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
346  * This allows applications to reconstruct the allowance for all accounts just
347  * by listening to said events. Other implementations of the EIP may not emit
348  * these events, as it isn't required by the specification.
349  *
350  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
351  * functions have been added to mitigate the well-known issues around setting
352  * allowances. See {IERC20-approve}.
353  */
354 contract ERC20 is Context, IERC20 {
355     using SafeMath for uint256;
356 
357     mapping (address => uint256) private _balances;
358 
359     mapping (address => mapping (address => uint256)) private _allowances;
360 
361     uint256 private _totalSupply;
362 
363     string private _name;
364     string private _symbol;
365     uint8 private _decimals;
366 
367     /**
368      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
369      * a default value of 18.
370      *
371      * To select a different value for {decimals}, use {_setupDecimals}.
372      *
373      * All three of these values are immutable: they can only be set once during
374      * construction.
375      */
376     constructor (string memory name_, string memory symbol_) public {
377         _name = name_;
378         _symbol = symbol_;
379         _decimals = 18;
380     }
381 
382     /**
383      * @dev Returns the name of the token.
384      */
385     function name() public view virtual returns (string memory) {
386         return _name;
387     }
388 
389     /**
390      * @dev Returns the symbol of the token, usually a shorter version of the
391      * name.
392      */
393     function symbol() public view virtual returns (string memory) {
394         return _symbol;
395     }
396 
397     /**
398      * @dev Returns the number of decimals used to get its user representation.
399      * For example, if `decimals` equals `2`, a balance of `505` tokens should
400      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
401      *
402      * Tokens usually opt for a value of 18, imitating the relationship between
403      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
404      * called.
405      *
406      * NOTE: This information is only used for _display_ purposes: it in
407      * no way affects any of the arithmetic of the contract, including
408      * {IERC20-balanceOf} and {IERC20-transfer}.
409      */
410     function decimals() public view virtual returns (uint8) {
411         return _decimals;
412     }
413 
414     /**
415      * @dev See {IERC20-totalSupply}.
416      */
417     function totalSupply() public view virtual override returns (uint256) {
418         return _totalSupply;
419     }
420 
421     /**
422      * @dev See {IERC20-balanceOf}.
423      */
424     function balanceOf(address account) public view virtual override returns (uint256) {
425         return _balances[account];
426     }
427 
428     /**
429      * @dev See {IERC20-transfer}.
430      *
431      * Requirements:
432      *
433      * - `recipient` cannot be the zero address.
434      * - the caller must have a balance of at least `amount`.
435      */
436     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
437         _transfer(_msgSender(), recipient, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-allowance}.
443      */
444     function allowance(address owner, address spender) public view virtual override returns (uint256) {
445         return _allowances[owner][spender];
446     }
447 
448     /**
449      * @dev See {IERC20-approve}.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function approve(address spender, uint256 amount) public virtual override returns (bool) {
456         _approve(_msgSender(), spender, amount);
457         return true;
458     }
459 
460     /**
461      * @dev See {IERC20-transferFrom}.
462      *
463      * Emits an {Approval} event indicating the updated allowance. This is not
464      * required by the EIP. See the note at the beginning of {ERC20}.
465      *
466      * Requirements:
467      *
468      * - `sender` and `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      * - the caller must have allowance for ``sender``'s tokens of at least
471      * `amount`.
472      */
473     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
474         _transfer(sender, recipient, amount);
475         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
476         return true;
477     }
478 
479     /**
480      * @dev Atomically increases the allowance granted to `spender` by the caller.
481      *
482      * This is an alternative to {approve} that can be used as a mitigation for
483      * problems described in {IERC20-approve}.
484      *
485      * Emits an {Approval} event indicating the updated allowance.
486      *
487      * Requirements:
488      *
489      * - `spender` cannot be the zero address.
490      */
491     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
493         return true;
494     }
495 
496     /**
497      * @dev Atomically decreases the allowance granted to `spender` by the caller.
498      *
499      * This is an alternative to {approve} that can be used as a mitigation for
500      * problems described in {IERC20-approve}.
501      *
502      * Emits an {Approval} event indicating the updated allowance.
503      *
504      * Requirements:
505      *
506      * - `spender` cannot be the zero address.
507      * - `spender` must have allowance for the caller of at least
508      * `subtractedValue`.
509      */
510     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
512         return true;
513     }
514 
515     /**
516      * @dev Moves tokens `amount` from `sender` to `recipient`.
517      *
518      * This is internal function is equivalent to {transfer}, and can be used to
519      * e.g. implement automatic token fees, slashing mechanisms, etc.
520      *
521      * Emits a {Transfer} event.
522      *
523      * Requirements:
524      *
525      * - `sender` cannot be the zero address.
526      * - `recipient` cannot be the zero address.
527      * - `sender` must have a balance of at least `amount`.
528      */
529     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532 
533         _beforeTokenTransfer(sender, recipient, amount);
534 
535         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
536         _balances[recipient] = _balances[recipient].add(amount);
537         emit Transfer(sender, recipient, amount);
538     }
539 
540     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
541      * the total supply.
542      *
543      * Emits a {Transfer} event with `from` set to the zero address.
544      *
545      * Requirements:
546      *
547      * - `to` cannot be the zero address.
548      */
549     function _mint(address account, uint256 amount) internal virtual {
550         require(account != address(0), "ERC20: mint to the zero address");
551 
552         _beforeTokenTransfer(address(0), account, amount);
553 
554         _totalSupply = _totalSupply.add(amount);
555         _balances[account] = _balances[account].add(amount);
556         emit Transfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements:
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
576         _totalSupply = _totalSupply.sub(amount);
577         emit Transfer(account, address(0), amount);
578     }
579 
580     /**
581      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
582      *
583      * This internal function is equivalent to `approve`, and can be used to
584      * e.g. set automatic allowances for certain subsystems, etc.
585      *
586      * Emits an {Approval} event.
587      *
588      * Requirements:
589      *
590      * - `owner` cannot be the zero address.
591      * - `spender` cannot be the zero address.
592      */
593     function _approve(address owner, address spender, uint256 amount) internal virtual {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     /**
602      * @dev Sets {decimals} to a value other than the default one of 18.
603      *
604      * WARNING: This function should only be called from the constructor. Most
605      * applications that interact with token contracts will not expect
606      * {decimals} to ever change, and may work incorrectly if it does.
607      */
608     function _setupDecimals(uint8 decimals_) internal virtual {
609         _decimals = decimals_;
610     }
611 
612     /**
613      * @dev Hook that is called before any transfer of tokens. This includes
614      * minting and burning.
615      *
616      * Calling conditions:
617      *
618      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
619      * will be to transferred to `to`.
620      * - when `from` is zero, `amount` tokens will be minted for `to`.
621      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
622      * - `from` and `to` are never both zero.
623      *
624      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
625      */
626     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
627 }
628 
629 // File: @openzeppelin/contracts/access/Ownable.sol
630 
631 
632 pragma solidity >=0.6.0 <0.8.0;
633 
634 /**
635  * @dev Contract module which provides a basic access control mechanism, where
636  * there is an account (an owner) that can be granted exclusive access to
637  * specific functions.
638  *
639  * By default, the owner account will be the one that deploys the contract. This
640  * can later be changed with {transferOwnership}.
641  *
642  * This module is used through inheritance. It will make available the modifier
643  * `onlyOwner`, which can be applied to your functions to restrict their use to
644  * the owner.
645  */
646 abstract contract Ownable is Context {
647     address private _owner;
648 
649     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
650 
651     /**
652      * @dev Initializes the contract setting the deployer as the initial owner.
653      */
654     constructor () internal {
655         address msgSender = _msgSender();
656         _owner = msgSender;
657         emit OwnershipTransferred(address(0), msgSender);
658     }
659 
660     /**
661      * @dev Returns the address of the current owner.
662      */
663     function owner() public view virtual returns (address) {
664         return _owner;
665     }
666 
667     /**
668      * @dev Throws if called by any account other than the owner.
669      */
670     modifier onlyOwner() {
671         require(owner() == _msgSender(), "Ownable: caller is not the owner");
672         _;
673     }
674 
675     /**
676      * @dev Leaves the contract without owner. It will not be possible to call
677      * `onlyOwner` functions anymore. Can only be called by the current owner.
678      *
679      * NOTE: Renouncing ownership will leave the contract without an owner,
680      * thereby removing any functionality that is only available to the owner.
681      */
682     function renounceOwnership() public virtual onlyOwner {
683         emit OwnershipTransferred(_owner, address(0));
684         _owner = address(0);
685     }
686 
687     /**
688      * @dev Transfers ownership of the contract to a new account (`newOwner`).
689      * Can only be called by the current owner.
690      */
691     function transferOwnership(address newOwner) public virtual onlyOwner {
692         require(newOwner != address(0), "Ownable: new owner is the zero address");
693         emit OwnershipTransferred(_owner, newOwner);
694         _owner = newOwner;
695     }
696 }
697 
698 // File: contracts/bBetaToken.sol
699 
700 
701 pragma solidity 0.6.12;
702 
703 
704 
705 contract bBetaToken is ERC20("bBeta", "bBETA"), Ownable {
706     uint256 public cap = 20000e18;
707     address public bBetaMaster;
708     mapping(address => uint) public redeemed;
709 
710     uint256 public startAtBlock;
711     uint256 public NUMBER_BLOCKS_PER_DAY;
712     uint256 constant public DATA_PROVIDER_TOTAL_AMOUNT = 2000e18;
713     uint256 constant public AIRDROP_TOTAL_AMOUNT = 2000e18;
714     uint256 public dataProviderAmount = DATA_PROVIDER_TOTAL_AMOUNT;
715     uint256 public farmingAmount = 16000e18;
716 
717     constructor(address _sendTo, uint256 _startAtBlock, uint256 _numberBlockPerDay) public {
718         startAtBlock = _startAtBlock;
719         NUMBER_BLOCKS_PER_DAY = _numberBlockPerDay == 0 ? 6000 : _numberBlockPerDay;
720         _mint(_sendTo, AIRDROP_TOTAL_AMOUNT);
721     }
722     
723     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
724         super._beforeTokenTransfer(from, to, amount);
725 
726         if (from == address(0)) {
727             require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
728         }
729     }
730 
731     function setMaster(address _bBetaMaster) public onlyOwner {
732         bBetaMaster = _bBetaMaster;
733     }
734 
735     function mint(address _to, uint256 _amount) public {
736         require(msg.sender == bBetaMaster, "bBetaToken: only master farmer can mint");
737         if (_amount > farmingAmount) {
738             _amount = farmingAmount;
739         }
740         farmingAmount = farmingAmount.sub(_amount);
741         _mint(_to, _amount);
742     }
743 
744     function safeBurn(uint256 _amount) public {
745         uint canBurn = canBurnAmount(msg.sender);
746         uint burnAmount = canBurn > _amount ? _amount : canBurn;
747         redeemed[msg.sender] += burnAmount;
748         _burn(msg.sender, burnAmount);
749     }
750 
751     function burn(uint256 _amount) public {
752         require(redeemed[msg.sender] + _amount <= 1e18, "bBetaToken: cannot burn more than 1 bBeta");
753         redeemed[msg.sender] += _amount;
754         _burn(msg.sender, _amount);
755     }
756 
757     function canBurnAmount(address _add) public view returns (uint) {
758         return 1e18 - redeemed[_add];
759     }
760 
761     function mintForDataProvider(address _to) public onlyOwner {
762         require(block.number >= startAtBlock + 14 * NUMBER_BLOCKS_PER_DAY, "bBetaToken: Cannot mint at this time");
763         require(dataProviderAmount > 0, "bBetaToken: Cannot mint more token for future farming");
764 
765         _mint(_to, dataProviderAmount);
766         dataProviderAmount = 0;
767     }
768 }