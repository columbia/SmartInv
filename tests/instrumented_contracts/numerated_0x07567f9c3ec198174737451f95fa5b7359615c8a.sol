1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
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
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 // SPDX-License-Identifier: MIT
162 /*
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with GSN meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 abstract contract Context {
173     function _msgSender() internal view virtual returns (address payable) {
174         return msg.sender;
175     }
176 
177     function _msgData() internal view virtual returns (bytes memory) {
178         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
179         return msg.data;
180     }
181 }
182 
183 // SPDX-License-Identifier: MIT
184 /**
185  * @dev Contract module which provides a basic access control mechanism, where
186  * there is an account (an owner) that can be granted exclusive access to
187  * specific functions.
188  *
189  * By default, the owner account will be the one that deploys the contract. This
190  * can later be changed with {transferOwnership}.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 abstract contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor () internal {
205         address msgSender = _msgSender();
206         _owner = msgSender;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(_owner == _msgSender(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     /**
226      * @dev Leaves the contract without owner. It will not be possible to call
227      * `onlyOwner` functions anymore. Can only be called by the current owner.
228      *
229      * NOTE: Renouncing ownership will leave the contract without an owner,
230      * thereby removing any functionality that is only available to the owner.
231      */
232     function renounceOwnership() public virtual onlyOwner {
233         emit OwnershipTransferred(_owner, address(0));
234         _owner = address(0);
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         emit OwnershipTransferred(_owner, newOwner);
244         _owner = newOwner;
245     }
246 }
247 
248 // SPDX-License-Identifier: MIT
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257 
258     /**
259      * @dev Returns the amount of tokens owned by `account`.
260      */
261     function balanceOf(address account) external view returns (uint256);
262 
263     /**
264      * @dev Moves `amount` tokens from the caller's account to `recipient`.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transfer(address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Returns the remaining number of tokens that `spender` will be
274      * allowed to spend on behalf of `owner` through {transferFrom}. This is
275      * zero by default.
276      *
277      * This value changes when {approve} or {transferFrom} are called.
278      */
279     function allowance(address owner, address spender) external view returns (uint256);
280 
281     /**
282      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * IMPORTANT: Beware that changing an allowance with this method brings the risk
287      * that someone may use both the old and the new allowance by unfortunate
288      * transaction ordering. One possible solution to mitigate this race
289      * condition is to first reduce the spender's allowance to 0 and set the
290      * desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address spender, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Moves `amount` tokens from `sender` to `recipient` using the
299      * allowance mechanism. `amount` is then deducted from the caller's
300      * allowance.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * Emits a {Transfer} event.
305      */
306     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Emitted when `value` tokens are moved from one account (`from`) to
310      * another (`to`).
311      *
312      * Note that `value` may be zero.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 value);
315 
316     /**
317      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
318      * a call to {approve}. `value` is the new allowance.
319      */
320     event Approval(address indexed owner, address indexed spender, uint256 value);
321 }
322 
323 // SPDX-License-Identifier: MIT
324 /**
325  * @dev Implementation of the {IERC20} interface.
326  *
327  * This implementation is agnostic to the way tokens are created. This means
328  * that a supply mechanism has to be added in a derived contract using {_mint}.
329  * For a generic mechanism see {ERC20PresetMinterPauser}.
330  *
331  * TIP: For a detailed writeup see our guide
332  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
333  * to implement supply mechanisms].
334  *
335  * We have followed general OpenZeppelin guidelines: functions revert instead
336  * of returning `false` on failure. This behavior is nonetheless conventional
337  * and does not conflict with the expectations of ERC20 applications.
338  *
339  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
340  * This allows applications to reconstruct the allowance for all accounts just
341  * by listening to said events. Other implementations of the EIP may not emit
342  * these events, as it isn't required by the specification.
343  *
344  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
345  * functions have been added to mitigate the well-known issues around setting
346  * allowances. See {IERC20-approve}.
347  */
348 contract ERC20 is Context, IERC20 {
349     using SafeMath for uint256;
350 
351     mapping (address => uint256) private _balances;
352 
353     mapping (address => mapping (address => uint256)) private _allowances;
354 
355     uint256 private _totalSupply;
356 
357     string private _name;
358     string private _symbol;
359     uint8 private _decimals;
360 
361     /**
362      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
363      * a default value of 18.
364      *
365      * To select a different value for {decimals}, use {_setupDecimals}.
366      *
367      * All three of these values are immutable: they can only be set once during
368      * construction.
369      */
370     constructor (string memory name_, string memory symbol_) public {
371         _name = name_;
372         _symbol = symbol_;
373         _decimals = 18;
374     }
375 
376     /**
377      * @dev Returns the name of the token.
378      */
379     function name() public view returns (string memory) {
380         return _name;
381     }
382 
383     /**
384      * @dev Returns the symbol of the token, usually a shorter version of the
385      * name.
386      */
387     function symbol() public view returns (string memory) {
388         return _symbol;
389     }
390 
391     /**
392      * @dev Returns the number of decimals used to get its user representation.
393      * For example, if `decimals` equals `2`, a balance of `505` tokens should
394      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
395      *
396      * Tokens usually opt for a value of 18, imitating the relationship between
397      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
398      * called.
399      *
400      * NOTE: This information is only used for _display_ purposes: it in
401      * no way affects any of the arithmetic of the contract, including
402      * {IERC20-balanceOf} and {IERC20-transfer}.
403      */
404     function decimals() public view returns (uint8) {
405         return _decimals;
406     }
407 
408     /**
409      * @dev See {IERC20-totalSupply}.
410      */
411     function totalSupply() public view override returns (uint256) {
412         return _totalSupply;
413     }
414 
415     /**
416      * @dev See {IERC20-balanceOf}.
417      */
418     function balanceOf(address account) public view override returns (uint256) {
419         return _balances[account];
420     }
421 
422     /**
423      * @dev See {IERC20-transfer}.
424      *
425      * Requirements:
426      *
427      * - `recipient` cannot be the zero address.
428      * - the caller must have a balance of at least `amount`.
429      */
430     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
431         _transfer(_msgSender(), recipient, amount);
432         return true;
433     }
434 
435     /**
436      * @dev See {IERC20-allowance}.
437      */
438     function allowance(address owner, address spender) public view virtual override returns (uint256) {
439         return _allowances[owner][spender];
440     }
441 
442     /**
443      * @dev See {IERC20-approve}.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      */
449     function approve(address spender, uint256 amount) public virtual override returns (bool) {
450         _approve(_msgSender(), spender, amount);
451         return true;
452     }
453 
454     /**
455      * @dev See {IERC20-transferFrom}.
456      *
457      * Emits an {Approval} event indicating the updated allowance. This is not
458      * required by the EIP. See the note at the beginning of {ERC20}.
459      *
460      * Requirements:
461      *
462      * - `sender` and `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      * - the caller must have allowance for ``sender``'s tokens of at least
465      * `amount`.
466      */
467     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
468         _transfer(sender, recipient, amount);
469         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
470         return true;
471     }
472 
473     /**
474      * @dev Atomically increases the allowance granted to `spender` by the caller.
475      *
476      * This is an alternative to {approve} that can be used as a mitigation for
477      * problems described in {IERC20-approve}.
478      *
479      * Emits an {Approval} event indicating the updated allowance.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
486         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
487         return true;
488     }
489 
490     /**
491      * @dev Atomically decreases the allowance granted to `spender` by the caller.
492      *
493      * This is an alternative to {approve} that can be used as a mitigation for
494      * problems described in {IERC20-approve}.
495      *
496      * Emits an {Approval} event indicating the updated allowance.
497      *
498      * Requirements:
499      *
500      * - `spender` cannot be the zero address.
501      * - `spender` must have allowance for the caller of at least
502      * `subtractedValue`.
503      */
504     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
506         return true;
507     }
508 
509     /**
510      * @dev Moves tokens `amount` from `sender` to `recipient`.
511      *
512      * This is internal function is equivalent to {transfer}, and can be used to
513      * e.g. implement automatic token fees, slashing mechanisms, etc.
514      *
515      * Emits a {Transfer} event.
516      *
517      * Requirements:
518      *
519      * - `sender` cannot be the zero address.
520      * - `recipient` cannot be the zero address.
521      * - `sender` must have a balance of at least `amount`.
522      */
523     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
524         require(sender != address(0), "ERC20: transfer from the zero address");
525         require(recipient != address(0), "ERC20: transfer to the zero address");
526 
527         _beforeTokenTransfer(sender, recipient, amount);
528 
529         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
530         _balances[recipient] = _balances[recipient].add(amount);
531         emit Transfer(sender, recipient, amount);
532     }
533 
534     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
535      * the total supply.
536      *
537      * Emits a {Transfer} event with `from` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `to` cannot be the zero address.
542      */
543     function _mint(address account, uint256 amount) internal virtual {
544         require(account != address(0), "ERC20: mint to the zero address");
545 
546         _beforeTokenTransfer(address(0), account, amount);
547 
548         _totalSupply = _totalSupply.add(amount);
549         _balances[account] = _balances[account].add(amount);
550         emit Transfer(address(0), account, amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`, reducing the
555      * total supply.
556      *
557      * Emits a {Transfer} event with `to` set to the zero address.
558      *
559      * Requirements:
560      *
561      * - `account` cannot be the zero address.
562      * - `account` must have at least `amount` tokens.
563      */
564     function _burn(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: burn from the zero address");
566 
567         _beforeTokenTransfer(account, address(0), amount);
568 
569         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
570         _totalSupply = _totalSupply.sub(amount);
571         emit Transfer(account, address(0), amount);
572     }
573 
574     /**
575      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
576      *
577      * This internal function is equivalent to `approve`, and can be used to
578      * e.g. set automatic allowances for certain subsystems, etc.
579      *
580      * Emits an {Approval} event.
581      *
582      * Requirements:
583      *
584      * - `owner` cannot be the zero address.
585      * - `spender` cannot be the zero address.
586      */
587     function _approve(address owner, address spender, uint256 amount) internal virtual {
588         require(owner != address(0), "ERC20: approve from the zero address");
589         require(spender != address(0), "ERC20: approve to the zero address");
590 
591         _allowances[owner][spender] = amount;
592         emit Approval(owner, spender, amount);
593     }
594 
595     /**
596      * @dev Sets {decimals} to a value other than the default one of 18.
597      *
598      * WARNING: This function should only be called from the constructor. Most
599      * applications that interact with token contracts will not expect
600      * {decimals} to ever change, and may work incorrectly if it does.
601      */
602     function _setupDecimals(uint8 decimals_) internal {
603         _decimals = decimals_;
604     }
605 
606     /**
607      * @dev Hook that is called before any transfer of tokens. This includes
608      * minting and burning.
609      *
610      * Calling conditions:
611      *
612      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
613      * will be to transferred to `to`.
614      * - when `from` is zero, `amount` tokens will be minted for `to`.
615      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
616      * - `from` and `to` are never both zero.
617      *
618      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
619      */
620     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
621 }
622 
623 // SPDX-License-Identifier: MIT
624 /**
625  * @title A simple holder of tokens.
626  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
627  * needs to hold multiple distinct pools of the same token.
628  */
629 contract TokenPool is Ownable {
630     IERC20 public token;
631     bool private _isTokenRescuable;
632 
633     constructor(IERC20 _token) public {
634         token = _token;
635         _isTokenRescuable = false;
636     }
637 
638     function balance() public view returns (uint256) {
639         return token.balanceOf(address(this));
640     }
641 
642     function setRescuable(bool rescuable) public onlyOwner {
643         _isTokenRescuable = rescuable;
644     }
645 
646     function transfer(address to, uint256 value)
647         external
648         onlyOwner
649         returns (bool)
650     {
651         return token.transfer(to, value);
652     }
653 
654     function rescueFunds(
655         address tokenToRescue,
656         address to,
657         uint256 amount
658     ) external onlyOwner returns (bool) {
659         if (!_isTokenRescuable) {
660             require(
661                 address(token) != tokenToRescue,
662                 "TokenPool: Cannot claim token held by the contract"
663             );
664         }
665 
666         return IERC20(tokenToRescue).transfer(to, amount);
667     }
668 }
669 
670 // SPDX-License-Identifier: MIT
671 /**
672  * @title IOU vesting interface
673  */
674 interface IIouVesting {
675     /**
676      * @dev Get current rewards amount for sender
677      * @param includeForfeited Include forfeited amount of other users who unstaked early
678      */
679     function getCurrentRewards(bool includeForfeited)
680         external
681         view
682         returns (uint256);
683 
684     /**
685      * @dev Get the total possible rewards, without forfeited rewards, if user stakes for the entire period
686      * @param includeForfeited Include forfeited amount of other users who unstaked early
687      */
688     function getTotalPossibleRewards(bool includeForfeited)
689         external
690         view
691         returns (uint256);
692 
693     /**
694      * @dev Used for burning user shares and withdrawing rewards based on the requested amount
695      * @param amount The amount of IOU you want to burn and get rewards for
696      * @param donationRatio The percentage ratio you want to donate (in 18 decimals; 0.15 * 10^18)
697      */
698     function unstake(uint256 amount, uint256 donationRatio) external;
699 
700     /**
701      * @dev Used for adding user's shares into IouVesting contract
702      * @param amount The amount you want to stake
703      */
704     function stake(uint256 amount) external;
705 
706     /**
707      * @return The total number of deposit tokens staked globally, by all users.
708      */
709     function totalStaked() external view returns (uint256);
710 
711     /**
712      * @return The total number of IOUs locked in the contract
713      */
714     function totalLocked() external view returns (uint256);
715 
716     /**
717      * @return The total number of IOUs staked by user.
718      */
719     function totalStakedFor(address user) external view returns (uint256);
720 
721     /**
722      * @return The total number of rewards tokens.
723      */
724     function totalRewards() external view returns (uint256);
725 
726     /**
727      * @return Total earnings for a user
728      */
729     function getEarnings(address user) external view returns (uint256);
730 }
731 
732 // SPDX-License-Identifier: MIT
733 /**
734  * @title IOU vesting contract
735  */
736 contract IouVesting is IIouVesting, Ownable {
737     using SafeMath for uint256;
738 
739     uint256 public startTimestamp;
740     uint256 public availableForfeitedAmount;
741     uint256 public totalUsers = 0;
742 
743     uint256 public constant ratio = 1449697206000000; //0.001449697206
744     uint256 public constant totalMonths = 6;
745 
746     address public donationAddress;
747 
748     mapping(address => uint256) userShares;
749     mapping(address => uint256) userEarnings;
750 
751     event RewardsClaimed(address indexed user, uint256 amount);
752     event RewardsDonated(address indexed user, uint256 amount);
753     event TokensLocked(address indexed user, uint256 amount);
754     event TokensStaked(address indexed user, uint256 amount, uint256 total);
755 
756     TokenPool private _iouPool;
757     TokenPool private _lockedIouPool;
758     TokenPool private _rewardsPool;
759 
760     /**
761      * @param iouToken The token users deposit as stake.
762      * @param rewardToken The token users receive as they unstake.
763      */
764     constructor(IERC20 iouToken, IERC20 rewardToken) public {
765         startTimestamp = block.timestamp;
766         availableForfeitedAmount = 0;
767         _iouPool = new TokenPool(iouToken);
768         _lockedIouPool = new TokenPool(iouToken);
769         _rewardsPool = new TokenPool(rewardToken);
770         _rewardsPool.setRescuable(true);
771     }
772 
773     function setDonationAddress(address donationReceiver) external onlyOwner {
774         donationAddress = donationReceiver;
775     }
776 
777     /**
778      * @dev Rescue rewards
779      */
780     function rescueRewards() external onlyOwner {
781         require(_rewardsPool.balance() > 0, "IouVesting: Nothing to rescue");
782         require(
783             _rewardsPool.transfer(msg.sender, _rewardsPool.balance()),
784             "IouVesting: rescue rewards from rewards pool failed"
785         );
786     }
787 
788     /**
789      * @dev Get current rewards amount for sender
790      * @param includeForfeited Include forfeited amount of other users who unstaked early
791      */
792     function getCurrentRewards(bool includeForfeited)
793         public
794         view
795         override
796         returns (uint256)
797     {
798         require(
799             msg.sender != address(0),
800             "IouVesting: Cannot get rewards for address(0)."
801         );
802 
803         require(
804             userShares[msg.sender] != uint256(0),
805             "IouVesting: Sender hasn't staked anything."
806         );
807 
808         return computeRewards(msg.sender, includeForfeited);
809     }
810 
811     /**
812      * @return The token users deposit as stake.
813      */
814     function getStakingToken() public view returns (IERC20) {
815         return _iouPool.token();
816     }
817 
818     /**
819      * @return The token users deposit as stake.
820      */
821     function getRewardToken() public view returns (IERC20) {
822         return _rewardsPool.token();
823     }
824 
825     /**
826      * @return Total earnings for a user
827      */
828     function getEarnings(address user) public view override returns (uint256) {
829         return userEarnings[user];
830     }
831 
832     /**
833      * @return The total number of deposit tokens staked globally, by all users.
834      */
835     function totalStaked() public view override returns (uint256) {
836         return _iouPool.balance();
837     }
838 
839     /**
840      * @return The total number of IOUs locked in the contract
841      */
842     function totalLocked() public view override returns (uint256) {
843         return _lockedIouPool.balance();
844     }
845 
846     /**
847      * @return The total number of IOUs staked by user.
848      */
849     function totalStakedFor(address user)
850         public
851         view
852         override
853         returns (uint256)
854     {
855         return userShares[user];
856     }
857 
858     /**
859      * @return The total number of rewards tokens.
860      */
861     function totalRewards() public view override returns (uint256) {
862         return _rewardsPool.balance();
863     }
864 
865     /**
866      * @dev Lets the owner rescue funds air-dropped to the staking pool.
867      * @param tokenToRescue Address of the token to be rescued.
868      * @param to Address to which the rescued funds are to be sent.
869      * @param amount Amount of tokens to be rescued.
870      * @return Transfer success.
871      */
872     function rescueFundsFromStakingPool(
873         address tokenToRescue,
874         address to,
875         uint256 amount
876     ) public onlyOwner returns (bool) {
877         return _iouPool.rescueFunds(tokenToRescue, to, amount);
878     }
879 
880     /**
881      * @dev Get the total possible rewards, without forfeited rewards, if user stakes for the entire period
882      * @param includeForfeited Include forfeited amount of other users who unstaked early
883      */
884     function getTotalPossibleRewards(bool includeForfeited)
885         external
886         view
887         override
888         returns (uint256)
889     {
890         return computeUserTotalPossibleRewards(msg.sender, includeForfeited);
891     }
892 
893     function getRatio(
894         uint256 numerator,
895         uint256 denominator,
896         uint256 precision
897     ) private view returns (uint256) {
898         uint256 _numerator = numerator * 10**(precision + 1);
899         uint256 _quotient = ((_numerator / denominator) + 5) / 10;
900         return (_quotient);
901     }
902 
903     function computeUserTotalPossibleRewards(
904         address user,
905         bool includeForfeited
906     ) private view returns (uint256) {
907         uint256 originalAmount = (userShares[user] * ratio) / (10**18);
908         if (!includeForfeited) return originalAmount;
909 
910         uint256 shareVsTotalStakedRatio =
911             getRatio(userShares[user], totalStaked(), 18);
912         uint256 forfeitedAmount =
913             (shareVsTotalStakedRatio * availableForfeitedAmount) / (10**18);
914 
915         return originalAmount.add(forfeitedAmount);
916     }
917 
918     /**
919      * @dev Get current rewards amount for sender
920      * @param user The address of the user you want to calculate rewards for
921      * @param includeForfeited Include forfeited amount of other users who unstaked early
922      */
923     function computeRewards(address user, bool includeForfeited)
924         private
925         view
926         returns (uint256)
927     {
928         uint256 nowTimestamp = block.timestamp;
929         uint256 endTimestamp = startTimestamp + (totalMonths * 30 days);
930         if (nowTimestamp > endTimestamp) {
931             nowTimestamp = endTimestamp;
932         }
933 
934         uint256 stakingMonths =
935             (nowTimestamp - startTimestamp) / 60 / 60 / 24 / 30; //months
936         if (stakingMonths == uint256(0)) {
937             //even if 1 second has passed, it's counted as 1 month
938             stakingMonths = 1;
939         }
940 
941         if (includeForfeited) {
942             uint256 totalUserPossibleReward =
943                 computeUserTotalPossibleRewards(user, true);
944 
945             return (totalUserPossibleReward * stakingMonths) / totalMonths;
946         } else {
947             uint256 totalUserPossibleRewardWithoutForfeited =
948                 computeUserTotalPossibleRewards(user, false);
949             uint256 rewardsWithoutForfeited =
950                 ((totalUserPossibleRewardWithoutForfeited * stakingMonths) /
951                     totalMonths);
952 
953             if (!includeForfeited) return rewardsWithoutForfeited;
954         }
955     }
956 
957     /**
958      * @dev Used for adding the necessary warp tokens amount based on the IOU's token total supply at the given ratio
959      * @param iouToken The address of the IOU token
960      * @param amount The amount you want to lock into the rewards pool
961      */
962     function lockTokens(IERC20 iouToken, uint256 amount) external {
963         //11333
964         uint256 supply = iouToken.totalSupply();
965         uint256 necessaryRewardSupply = (supply * ratio) / (10**18);
966 
967         require(
968             amount >= necessaryRewardSupply,
969             "IouVesting: The amount provided for locking is not right"
970         );
971 
972         require(
973             _rewardsPool.token().transferFrom(
974                 msg.sender,
975                 address(_rewardsPool),
976                 amount
977             ),
978             "TokenGeyser: transfer into locked pool failed"
979         );
980 
981         emit TokensLocked(msg.sender, amount);
982     }
983 
984     /**
985      * @dev Used for burning user shares and withdrawing rewards based on the requested amount
986      * @param amount The amount of IOU you want to burn and get rewards for
987      * @param donationRatio The percentage ratio you want to donate (in 18 decimals; 0.15 * 10^18)
988      */
989     function unstake(uint256 amount, uint256 donationRatio) external override {
990         require(
991             amount > uint256(0),
992             "IouVesting: Unstake amount needs to be greater than 0"
993         );
994         require(
995             userShares[msg.sender] != uint256(0),
996             "IouVesting: There is nothing to unstake for you"
997         );
998 
999         require(
1000             userShares[msg.sender] >= amount,
1001             "IouVesting: You cannot unstake more than you staked"
1002         );
1003 
1004         require(
1005             donationRatio <= uint256(100),
1006             "IouVesting: You cannot donate more than you earned"
1007         );
1008 
1009         uint256 amountVsSharesRatio =
1010             getRatio(amount, userShares[msg.sender], 18);
1011         uint256 totalUserPossibleRewards =
1012             (computeUserTotalPossibleRewards(msg.sender, false) *
1013                 amountVsSharesRatio) / (10**18);
1014 
1015         uint256 totalCurrentUserRewards =
1016             (getCurrentRewards(true) * amountVsSharesRatio) / (10**18);
1017 
1018         //in case rewards were rescued
1019         if (totalRewards() > 0) {
1020             uint256 donationAmount = 0;
1021             if (donationAddress != address(0) && donationRatio > 0) {
1022                 donationAmount =
1023                     (donationRatio * totalCurrentUserRewards) /
1024                     (10**18);
1025             }
1026 
1027             uint256 toTransferToUser = totalCurrentUserRewards;
1028             if (donationAmount > 0) {
1029                 toTransferToUser = totalCurrentUserRewards - donationAmount;
1030                 require(
1031                     _rewardsPool.transfer(donationAddress, donationAmount),
1032                     "IouVesting: transfer from rewards pool to donation receiver failed"
1033                 );
1034             }
1035 
1036             require(
1037                 _rewardsPool.transfer(msg.sender, toTransferToUser),
1038                 "IouVesting: transfer from rewards pool failed"
1039             );
1040             emit RewardsClaimed(msg.sender, toTransferToUser);
1041             emit RewardsDonated(msg.sender, donationAmount);
1042 
1043             userEarnings[msg.sender] += totalCurrentUserRewards;
1044 
1045             availableForfeitedAmount += (totalUserPossibleRewards -
1046                 totalCurrentUserRewards);
1047         }
1048 
1049         require(
1050             _iouPool.transfer(address(_lockedIouPool), amount),
1051             "IouVesting: transfer from iou pool to locked iou pool failed"
1052         );
1053 
1054         userShares[msg.sender] -= amount;
1055         if (userShares[msg.sender] == uint256(0)) {
1056             totalUsers--;
1057         }
1058     }
1059 
1060     /**
1061      * @dev Used for adding user's shares into IouVesting contract
1062      * @param amount The amount you want to stake
1063      */
1064     function stake(uint256 amount) external override {
1065         require(amount > 0, "IouVesting: You cannot stake 0");
1066         require(
1067             _rewardsPool.balance() > 0,
1068             "IouVesting: No rewards are available"
1069         );
1070 
1071         require(
1072             _iouPool.token().transferFrom(
1073                 msg.sender,
1074                 address(_iouPool),
1075                 amount
1076             ),
1077             "IouVesting: transfer into iou pool failed"
1078         );
1079 
1080         if (userShares[msg.sender] == uint256(0)) {
1081             totalUsers++;
1082         }
1083         userShares[msg.sender] += amount;
1084 
1085         emit TokensStaked(msg.sender, amount, totalStaked());
1086     }
1087 }