1 // SPDX-License-Identifier: MIT
2 // 84 71 32 64 84 104 101 71 104 111 115 116 68 101 118 
3 // ASCII
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(
87         address sender,
88         address recipient,
89         uint256 amount
90     ) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 /**
109  * @dev Interface for the optional metadata functions from the ERC20 standard.
110  *
111  * _Available since v4.1._
112  */
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 
131 /**
132  * @dev Implementation of the {IERC20} interface.
133  *
134  * This implementation is agnostic to the way tokens are created. This means
135  * that a supply mechanism has to be added in a derived contract using {_mint}.
136  * For a generic mechanism see {ERC20PresetMinterPauser}.
137  *
138  * TIP: For a detailed writeup see our guide
139  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
140  * to implement supply mechanisms].
141  *
142  * We have followed general OpenZeppelin guidelines: functions revert instead
143  * of returning `false` on failure. This behavior is nonetheless conventional
144  * and does not conflict with the expectations of ERC20 applications.
145  *
146  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
147  * This allows applications to reconstruct the allowance for all accounts just
148  * by listening to said events. Other implementations of the EIP may not emit
149  * these events, as it isn't required by the specification.
150  *
151  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
152  * functions have been added to mitigate the well-known issues around setting
153  * allowances. See {IERC20-approve}.
154  */
155 contract ERC20 is Context, IERC20, IERC20Metadata {
156     using SafeMath for uint256;
157 
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * The default value of {decimals} is 18. To select a different value for
171      * {decimals} you should overload it.
172      *
173      * All two of these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor(string memory name_, string memory symbol_) {
177         _name = name_;
178         _symbol = symbol_;
179     }
180 
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() public view virtual override returns (string memory) {
185         return _name;
186     }
187 
188     /**
189      * @dev Returns the symbol of the token, usually a shorter version of the
190      * name.
191      */
192     function symbol() public view virtual override returns (string memory) {
193         return _symbol;
194     }
195 
196     /**
197      * @dev Returns the number of decimals used to get its user representation.
198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
199      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
200      *
201      * Tokens usually opt for a value of 18, imitating the relationship between
202      * Ether and Wei. This is the value {ERC20} uses, unless this function is
203      * overridden;
204      *
205      * NOTE: This information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * {IERC20-balanceOf} and {IERC20-transfer}.
208      */
209     function decimals() public view virtual override returns (uint8) {
210         return 18;
211     }
212 
213     /**
214      * @dev See {IERC20-totalSupply}.
215      */
216     function totalSupply() public view virtual override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev See {IERC20-balanceOf}.
222      */
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     /**
228      * @dev See {IERC20-transfer}.
229      *
230      * Requirements:
231      *
232      * - `recipient` cannot be the zero address.
233      * - the caller must have a balance of at least `amount`.
234      */
235     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-allowance}.
242      */
243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     /**
248      * @dev See {IERC20-approve}.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function approve(address spender, uint256 amount) public virtual override returns (bool) {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-transferFrom}.
261      *
262      * Emits an {Approval} event indicating the updated allowance. This is not
263      * required by the EIP. See the note at the beginning of {ERC20}.
264      *
265      * Requirements:
266      *
267      * - `sender` and `recipient` cannot be the zero address.
268      * - `sender` must have a balance of at least `amount`.
269      * - the caller must have allowance for ``sender``'s tokens of at least
270      * `amount`.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public virtual override returns (bool) {
277         _transfer(sender, recipient, amount);
278         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
279         return true;
280     }
281 
282     /**
283      * @dev Atomically increases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to {approve} that can be used as a mitigation for
286      * problems described in {IERC20-approve}.
287      *
288      * Emits an {Approval} event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
295         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
296         return true;
297     }
298 
299     /**
300      * @dev Atomically decreases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      * - `spender` must have allowance for the caller of at least
311      * `subtractedValue`.
312      */
313     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
315         return true;
316     }
317 
318     /**
319      * @dev Moves tokens `amount` from `sender` to `recipient`.
320      *
321      * This is internal function is equivalent to {transfer}, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a {Transfer} event.
325      *
326      * Requirements:
327      *
328      * - `sender` cannot be the zero address.
329      * - `recipient` cannot be the zero address.
330      * - `sender` must have a balance of at least `amount`.
331      */
332     function _transfer(
333         address sender,
334         address recipient,
335         uint256 amount
336     ) internal virtual {
337         require(sender != address(0), "ERC20: transfer from the zero address");
338         require(recipient != address(0), "ERC20: transfer to the zero address");
339 
340         _beforeTokenTransfer(sender, recipient, amount);
341 
342         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
343         _balances[recipient] = _balances[recipient].add(amount);
344         emit Transfer(sender, recipient, amount);
345     }
346 
347     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
348      * the total supply.
349      *
350      * Emits a {Transfer} event with `from` set to the zero address.
351      *
352      * Requirements:
353      *
354      * - `account` cannot be the zero address.
355      */
356     function _mint(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: mint to the zero address");
358 
359         _beforeTokenTransfer(address(0), account, amount);
360 
361         _totalSupply = _totalSupply.add(amount);
362         _balances[account] = _balances[account].add(amount);
363         emit Transfer(address(0), account, amount);
364     }
365 
366     /**
367      * @dev Destroys `amount` tokens from `account`, reducing the
368      * total supply.
369      *
370      * Emits a {Transfer} event with `to` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      * - `account` must have at least `amount` tokens.
376      */
377     function _burn(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: burn from the zero address");
379 
380         _beforeTokenTransfer(account, address(0), amount);
381 
382         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
383         _totalSupply = _totalSupply.sub(amount);
384         emit Transfer(account, address(0), amount);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
389      *
390      * This internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an {Approval} event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(
401         address owner,
402         address spender,
403         uint256 amount
404     ) internal virtual {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = amount;
409         emit Approval(owner, spender, amount);
410     }
411 
412     /**
413      * @dev Hook that is called before any transfer of tokens. This includes
414      * minting and burning.
415      *
416      * Calling conditions:
417      *
418      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
419      * will be to transferred to `to`.
420      * - when `from` is zero, `amount` tokens will be minted for `to`.
421      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
422      * - `from` and `to` are never both zero.
423      *
424      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
425      */
426     function _beforeTokenTransfer(
427         address from,
428         address to,
429         uint256 amount
430     ) internal virtual {}
431 }
432 
433 
434 contract Ownable is Context {
435     address private _owner;
436 
437     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
438 
439     /**
440      * @dev Initializes the contract setting the deployer as the initial owner.
441      */
442     constructor () {
443         address msgSender = _msgSender();
444         _owner = msgSender;
445         emit OwnershipTransferred(address(0), msgSender);
446     }
447 
448     /**
449      * @dev Returns the address of the current owner.
450      */
451     function owner() public view returns (address) {
452         return _owner;
453     }
454 
455     /**
456      * @dev Throws if called by any account other than the owner.
457      */
458     modifier onlyOwner() {
459         require(_owner == _msgSender(), "Ownable: caller is not the owner");
460         _;
461     }
462 
463     /**
464      * @dev Leaves the contract without owner. It will not be possible to call
465      * `onlyOwner` functions anymore. Can only be called by the current owner.
466      *
467      * NOTE: Renouncing ownership will leave the contract without an owner,
468      * thereby removing any functionality that is only available to the owner.
469      */
470     function renounceOwnership() public virtual onlyOwner {
471         emit OwnershipTransferred(_owner, address(0));
472         _owner = address(0);
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Can only be called by the current owner.
478      */
479     function transferOwnership(address newOwner) public virtual onlyOwner {
480         require(newOwner != address(0), "Ownable: new owner is the zero address");
481         emit OwnershipTransferred(_owner, newOwner);
482         _owner = newOwner;
483     }
484 }
485 
486 library SafeMath {
487     /**
488      * @dev Returns the addition of two unsigned integers, reverting on
489      * overflow.
490      *
491      * Counterpart to Solidity's `+` operator.
492      *
493      * Requirements:
494      *
495      * - Addition cannot overflow.
496      */
497     function add(uint256 a, uint256 b) internal pure returns (uint256) {
498         uint256 c = a + b;
499         require(c >= a, "SafeMath: addition overflow");
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the subtraction of two unsigned integers, reverting on
506      * overflow (when the result is negative).
507      *
508      * Counterpart to Solidity's `-` operator.
509      *
510      * Requirements:
511      *
512      * - Subtraction cannot overflow.
513      */
514     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
515         return sub(a, b, "SafeMath: subtraction overflow");
516     }
517 
518     /**
519      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
520      * overflow (when the result is negative).
521      *
522      * Counterpart to Solidity's `-` operator.
523      *
524      * Requirements:
525      *
526      * - Subtraction cannot overflow.
527      */
528     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
529         require(b <= a, errorMessage);
530         uint256 c = a - b;
531 
532         return c;
533     }
534 
535     /**
536      * @dev Returns the multiplication of two unsigned integers, reverting on
537      * overflow.
538      *
539      * Counterpart to Solidity's `*` operator.
540      *
541      * Requirements:
542      *
543      * - Multiplication cannot overflow.
544      */
545     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
546         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
547         // benefit is lost if 'b' is also tested.
548         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
549         if (a == 0) {
550             return 0;
551         }
552 
553         uint256 c = a * b;
554         require(c / a == b, "SafeMath: multiplication overflow");
555 
556         return c;
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b) internal pure returns (uint256) {
572         return div(a, b, "SafeMath: division by zero");
573     }
574 
575     /**
576      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
577      * division by zero. The result is rounded towards zero.
578      *
579      * Counterpart to Solidity's `/` operator. Note: this function uses a
580      * `revert` opcode (which leaves remaining gas untouched) while Solidity
581      * uses an invalid opcode to revert (consuming all remaining gas).
582      *
583      * Requirements:
584      *
585      * - The divisor cannot be zero.
586      */
587     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
588         require(b > 0, errorMessage);
589         uint256 c = a / b;
590         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
591 
592         return c;
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
608         return mod(a, b, "SafeMath: modulo by zero");
609     }
610 
611     /**
612      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
613      * Reverts with custom message when dividing by zero.
614      *
615      * Counterpart to Solidity's `%` operator. This function uses a `revert`
616      * opcode (which leaves remaining gas untouched) while Solidity uses an
617      * invalid opcode to revert (consuming all remaining gas).
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
624         require(b != 0, errorMessage);
625         return a % b;
626     }
627 }
628 
629 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
630 /**
631  * @dev Contract module that helps prevent reentrant calls to a function.
632  *
633  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
634  * available, which can be applied to functions to make sure there are no nested
635  * (reentrant) calls to them.
636  *
637  * Note that because there is a single `nonReentrant` guard, functions marked as
638  * `nonReentrant` may not call one another. This can be worked around by making
639  * those functions `private`, and then adding `external` `nonReentrant` entry
640  * points to them.
641  *
642  * TIP: If you would like to learn more about reentrancy and alternative ways
643  * to protect against it, check out our blog post
644  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
645  */
646 abstract contract ReentrancyGuard {
647     // Booleans are more expensive than uint256 or any type that takes up a full
648     // word because each write operation emits an extra SLOAD to first read the
649     // slot's contents, replace the bits taken up by the boolean, and then write
650     // back. This is the compiler's defense against contract upgrades and
651     // pointer aliasing, and it cannot be disabled.
652 
653     // The values being non-zero value makes deployment a bit more expensive,
654     // but in exchange the refund on every call to nonReentrant will be lower in
655     // amount. Since refunds are capped to a percentage of the total
656     // transaction's gas, it is best to keep them low in cases like this one, to
657     // increase the likelihood of the full refund coming into effect.
658     uint256 private constant _NOT_ENTERED = 1;
659     uint256 private constant _ENTERED = 2;
660 
661     uint256 private _status;
662 
663     constructor() {
664         _status = _NOT_ENTERED;
665     }
666 
667     /**
668      * @dev Prevents a contract from calling itself, directly or indirectly.
669      * Calling a `nonReentrant` function from another `nonReentrant`
670      * function is not supported. It is possible to prevent this from happening
671      * by making the `nonReentrant` function external, and make it call a
672      * `private` function that does the actual work.
673      */
674     modifier nonReentrant() {
675         // On the first call to nonReentrant, _notEntered will be true
676         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
677 
678         // Any calls to nonReentrant after this point will fail
679         _status = _ENTERED;
680 
681         _;
682 
683         // By storing the original value once again, a refund is triggered (see
684         // https://eips.ethereum.org/EIPS/eip-2200)
685         _status = _NOT_ENTERED;
686     }
687 }
688 
689 
690 /// @title Dividend-Paying Token
691 /// @author Roger Wu (https://github.com/roger-wu)
692 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
693 ///  to token holders as dividends and allows token holders to withdraw their dividends.
694 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
695 contract DividendStakingToken is ERC20 {
696   using SafeMath for uint256;
697 
698   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
699 
700   function _transfer(address from, address to, uint256 value) internal virtual override {
701     require(false, "Cant transfer");
702     super._transfer(from, to, value);
703   }
704 
705   function _mint(address account, uint256 value) internal override {
706     super._mint(account, value);
707   }
708 
709   function _burn(address account, uint256 value) internal override {
710     super._burn(account, value);
711   }
712 
713   function _setDividendBalance(address account, uint256 newBalance) internal {
714     uint256 currentBalance = balanceOf(account);
715 
716     if(newBalance > currentBalance) {
717         uint256 mintAmount = newBalance.sub(currentBalance);
718         _mint(account, mintAmount);
719     } else if(newBalance < currentBalance) {
720         uint256 burnAmount = currentBalance.sub(newBalance);
721         _burn(account, burnAmount);
722     }
723   }
724 }
725 
726 contract StakingContract is Ownable, DividendStakingToken, ReentrancyGuard {
727     using SafeMath for uint256;
728 
729     IERC20 public accelToken;
730 
731     uint256 public totalRewardEthDistributed;
732     uint256 public amountEthForReward;
733     uint256 public requiredTimeForReward;
734     uint256 public rewardEthPerSecond;
735     uint256 public accEthPerShare;
736     uint256 public lastRewardTime;
737     uint256 public PRECISION_FACTOR;
738     uint256 public totalStakedAmount;
739     mapping(address => UserInfo) public userInfo;
740 
741     struct UserInfo {
742         uint256 amount;
743         uint256 depositTime;
744         uint256 rewardEthDebt;
745         uint256 pendingEthReward;
746     }
747 
748     event Deposit(address indexed user, uint256 amount);
749     event EmergencyWithdraw(address indexed user, uint256 amount);
750     event Withdraw(address indexed user, uint256 amount);
751     event Harvest(address indexed user, uint256 amount);
752 
753     constructor (address _addressAccel) DividendStakingToken("Staking_Dividend_Tracker", "Staking_Dividend_Tracker") {
754         accelToken = IERC20(_addressAccel);
755         PRECISION_FACTOR = uint256(10**12);
756         rewardEthPerSecond = 0.000004 ether; // 10 eth/month
757         requiredTimeForReward = 30 days;
758         lastRewardTime = block.timestamp;
759     }
760 
761     receive() external payable {
762         distributeETHRewardToStaking();
763     }
764 
765     function distributeETHRewardToStaking() public payable {
766         amountEthForReward = amountEthForReward.add(msg.value);
767     }    
768     
769     function setRewardEthPerSecond(uint256 _rewardEthPerSecond) public onlyOwner{
770         rewardEthPerSecond = _rewardEthPerSecond;
771     }
772 
773     function deposit(uint256 _amount) external nonReentrant {
774         UserInfo storage user = userInfo[msg.sender];
775         require(_amount > 0, "Can't deposit zero amount");
776 
777         _updatePool();
778 
779         if (user.amount > 0) {
780             user.pendingEthReward = user.pendingEthReward.add(user.amount.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt));
781         }
782 
783         user.depositTime = user.depositTime > 0 ? user.depositTime : block.timestamp;
784         
785         if (_amount > 0) {
786             user.amount = user.amount.add(_amount);
787             accelToken.transferFrom(address(msg.sender), address(this), _amount);
788         }
789 
790         totalStakedAmount = totalStakedAmount.add(_amount);
791         user.rewardEthDebt = user.amount.mul(accEthPerShare).div(PRECISION_FACTOR);
792 
793         _setDividendBalance(msg.sender, user.amount);
794         emit Deposit(msg.sender, _amount);
795     }
796 
797     function setTimeRequireForRewardStaking(uint256 _second) public onlyOwner{
798         requiredTimeForReward = _second;
799     }
800 
801     function withdraw() external nonReentrant {
802         UserInfo storage user = userInfo[msg.sender];
803         require(user.amount >= 0, "You havent invested yet");
804 
805         _updatePool();
806 
807         uint256 pendingEth = user.pendingEthReward.add(user.amount.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt));
808 
809         accelToken.transfer(address(msg.sender), user.amount);
810 
811         if(block.timestamp > user.depositTime.add(requiredTimeForReward)){
812             if (pendingEth > 0) {
813                 payable(address(msg.sender)).transfer(pendingEth);
814             }
815         }else {
816             amountEthForReward = amountEthForReward.add(pendingEth);
817         }
818         totalStakedAmount = totalStakedAmount.sub(user.amount);
819         user.amount = 0;
820         user.depositTime = 0;
821         user.rewardEthDebt = 0;
822         user.pendingEthReward = 0;
823 
824         _setDividendBalance(msg.sender, user.amount);
825         emit Withdraw(msg.sender, user.amount);
826     }
827 
828     function harvest() external nonReentrant {
829         UserInfo storage user = userInfo[msg.sender];
830         require(user.amount >= 0, "You havent invested yet");
831         require(block.timestamp > user.depositTime.add(requiredTimeForReward), "Check locking time require");
832 
833         _updatePool();
834 
835         uint256 pendingEth = user.pendingEthReward.add(user.amount.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt));
836         if (pendingEth > 0) {
837             payable(address(msg.sender)).transfer(pendingEth);
838             user.pendingEthReward = 0;
839             user.rewardEthDebt = user.amount.mul(accEthPerShare).div(PRECISION_FACTOR);
840             emit Harvest(msg.sender, pendingEth);
841         }
842     }
843 
844     function emergencyWithdraw() external nonReentrant {
845         UserInfo storage user = userInfo[msg.sender];
846         uint256 amountToTransfer = user.amount;
847         user.amount = 0;
848         user.depositTime = 0;
849         user.rewardEthDebt = 0;
850         amountEthForReward = amountEthForReward.add(user.pendingEthReward);
851         user.pendingEthReward = 0;
852 
853         if (amountToTransfer > 0) {
854             accelToken.transfer(address(msg.sender), amountToTransfer);
855         }
856 
857         emit EmergencyWithdraw(msg.sender, amountToTransfer);
858     }
859 
860     function pendingReward(address _user) public view returns (uint256) {
861         UserInfo storage user = userInfo[_user];
862         uint256 pendingEth;
863         
864         if (block.timestamp > lastRewardTime && totalStakedAmount != 0) {
865             uint256 multiplier = block.timestamp.sub(lastRewardTime);
866             uint256 ethReward = multiplier.mul(rewardEthPerSecond);
867             if(ethReward > amountEthForReward){
868                 ethReward = amountEthForReward;
869             }
870             uint256 adjustedEthPerShare = accEthPerShare.add(ethReward.mul(PRECISION_FACTOR).div(totalStakedAmount));
871             pendingEth =  user.pendingEthReward.add(user.amount.mul(adjustedEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt));
872         } else {
873             pendingEth = user.pendingEthReward.add(user.amount.mul(accEthPerShare).div(PRECISION_FACTOR).sub(user.rewardEthDebt));
874         }
875 
876         return pendingEth;
877     }
878 
879     function ableToHarvestReward(address _user) public view returns (bool) {
880         UserInfo storage user = userInfo[_user];
881         if(block.timestamp > user.depositTime.add(requiredTimeForReward) && pendingReward(_user) > 0){
882             return true;
883         }else
884             return false;
885     }
886 
887     function _updatePool() internal {
888         if (block.timestamp <= lastRewardTime) {
889             return;
890         }
891 
892         if (totalStakedAmount == 0) {
893             lastRewardTime = block.timestamp;
894             return;
895         }
896 
897         uint256 multiplier = block.timestamp.sub(lastRewardTime);
898         uint256 ethReward = multiplier.mul(rewardEthPerSecond);
899         if(ethReward > amountEthForReward){
900             ethReward = amountEthForReward;
901         }
902         accEthPerShare = accEthPerShare.add(ethReward.mul(PRECISION_FACTOR).div(totalStakedAmount));
903         amountEthForReward = amountEthForReward.sub(ethReward);
904         totalRewardEthDistributed = totalRewardEthDistributed.add(ethReward);
905 
906         lastRewardTime = block.timestamp;
907     }
908 }