1 pragma solidity ^0.6.0;
2 
3 
4 // SPDX-License-Identifier: MIT
5 interface ITokenGeyserManager {
6     /**
7         @dev Retrieves total rewards earned for a specific staking token
8         @param token - address of the ERC20 token
9     */
10     function getEarned(address token) external view returns (uint256);
11 
12     /**
13         @dev Retrieves staked amount for a specific token address
14         @param token - address of the ERC20 token
15     */
16     function getStake(address token) external view returns (uint256);
17 
18     /**
19         @dev Retrieves total rewards earned for all the staking tokens
20     */
21     function getEarnings()
22         external
23         view
24         returns (address[] memory, uint256[] memory);
25 
26     /**
27         @dev Retrieves all stakes for sender
28      */
29     function getStakes()
30         external
31         view
32         returns (address[] memory, uint256[] memory);
33 
34     /**
35         @dev Stakes all tokens sent
36         @param tokens - array of tokens' addresses you want to stake
37         @param amounts - stake amount you want for each token
38      */
39     function stake(
40         address[] calldata tokens,
41         uint256[] calldata amounts,
42         int256 nftId
43     ) external returns (bool);
44 
45     /**
46         @dev Unstakes all tokens sent
47         @param tokens - array of tokens' addresses you want to unstake
48         @param amounts - unstake amount you want for each token
49      */
50     function unstake(address[] calldata tokens, uint256[] calldata amounts)
51         external;
52 
53     /**
54         @dev Retrives current user's rewards amount
55         @param tokens - array of tokens' addresses you want to unstake
56         @param amounts - unstake amount you want for each token
57      */
58     function unstakeQuery(
59         address[] calldata tokens,
60         uint256[] calldata amounts
61     ) external returns (address[] memory, uint256[] memory);
62 
63     /**
64         @dev Adds a new geyser in the team
65         @param token - address of the staking token for which the geyser was created
66         @param geyser - address of the geyser
67      */
68     function addGeyser(address token, address geyser) external returns (bool);
69 
70     event Staked(address indexed sender, address indexed token, uint256 amount);
71     event Unstaked(
72         address indexed sender,
73         address indexed token,
74         uint256 amount
75     );
76 
77     event GeyserAdded(
78         address indexed sender,
79         address indexed geyser,
80         address token
81     );
82     event GeyserManagerCreated(
83         address indexed sender,
84         address indexed geyserManager
85     );
86 }
87 
88 // SPDX-License-Identifier: MIT
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 // SPDX-License-Identifier: MIT
246 /*
247  * @dev Provides information about the current execution context, including the
248  * sender of the transaction and its data. While these are generally available
249  * via msg.sender and msg.data, they should not be accessed in such a direct
250  * manner, since when dealing with GSN meta-transactions the account sending and
251  * paying for execution may not be the actual sender (as far as an application
252  * is concerned).
253  *
254  * This contract is only required for intermediate, library-like contracts.
255  */
256 abstract contract Context {
257     function _msgSender() internal view virtual returns (address payable) {
258         return msg.sender;
259     }
260 
261     function _msgData() internal view virtual returns (bytes memory) {
262         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
263         return msg.data;
264     }
265 }
266 
267 // SPDX-License-Identifier: MIT
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 abstract contract Ownable is Context {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev Initializes the contract setting the deployer as the initial owner.
287      */
288     constructor () internal {
289         address msgSender = _msgSender();
290         _owner = msgSender;
291         emit OwnershipTransferred(address(0), msgSender);
292     }
293 
294     /**
295      * @dev Returns the address of the current owner.
296      */
297     function owner() public view returns (address) {
298         return _owner;
299     }
300 
301     /**
302      * @dev Throws if called by any account other than the owner.
303      */
304     modifier onlyOwner() {
305         require(_owner == _msgSender(), "Ownable: caller is not the owner");
306         _;
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public virtual onlyOwner {
317         emit OwnershipTransferred(_owner, address(0));
318         _owner = address(0);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331 
332 // SPDX-License-Identifier: MIT
333 /**
334  * @dev Interface of the ERC20 standard as defined in the EIP.
335  */
336 interface IERC20 {
337     /**
338      * @dev Returns the amount of tokens in existence.
339      */
340     function totalSupply() external view returns (uint256);
341 
342     /**
343      * @dev Returns the amount of tokens owned by `account`.
344      */
345     function balanceOf(address account) external view returns (uint256);
346 
347     /**
348      * @dev Moves `amount` tokens from the caller's account to `recipient`.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transfer(address recipient, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Returns the remaining number of tokens that `spender` will be
358      * allowed to spend on behalf of `owner` through {transferFrom}. This is
359      * zero by default.
360      *
361      * This value changes when {approve} or {transferFrom} are called.
362      */
363     function allowance(address owner, address spender) external view returns (uint256);
364 
365     /**
366      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * IMPORTANT: Beware that changing an allowance with this method brings the risk
371      * that someone may use both the old and the new allowance by unfortunate
372      * transaction ordering. One possible solution to mitigate this race
373      * condition is to first reduce the spender's allowance to 0 and set the
374      * desired value afterwards:
375      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376      *
377      * Emits an {Approval} event.
378      */
379     function approve(address spender, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Moves `amount` tokens from `sender` to `recipient` using the
383      * allowance mechanism. `amount` is then deducted from the caller's
384      * allowance.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Emitted when `value` tokens are moved from one account (`from`) to
394      * another (`to`).
395      *
396      * Note that `value` may be zero.
397      */
398     event Transfer(address indexed from, address indexed to, uint256 value);
399 
400     /**
401      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
402      * a call to {approve}. `value` is the new allowance.
403      */
404     event Approval(address indexed owner, address indexed spender, uint256 value);
405 }
406 
407 // SPDX-License-Identifier: MIT
408 /**
409  * @dev Implementation of the {IERC20} interface.
410  *
411  * This implementation is agnostic to the way tokens are created. This means
412  * that a supply mechanism has to be added in a derived contract using {_mint}.
413  * For a generic mechanism see {ERC20PresetMinterPauser}.
414  *
415  * TIP: For a detailed writeup see our guide
416  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
417  * to implement supply mechanisms].
418  *
419  * We have followed general OpenZeppelin guidelines: functions revert instead
420  * of returning `false` on failure. This behavior is nonetheless conventional
421  * and does not conflict with the expectations of ERC20 applications.
422  *
423  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
424  * This allows applications to reconstruct the allowance for all accounts just
425  * by listening to said events. Other implementations of the EIP may not emit
426  * these events, as it isn't required by the specification.
427  *
428  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
429  * functions have been added to mitigate the well-known issues around setting
430  * allowances. See {IERC20-approve}.
431  */
432 contract ERC20 is Context, IERC20 {
433     using SafeMath for uint256;
434 
435     mapping (address => uint256) private _balances;
436 
437     mapping (address => mapping (address => uint256)) private _allowances;
438 
439     uint256 private _totalSupply;
440 
441     string private _name;
442     string private _symbol;
443     uint8 private _decimals;
444 
445     /**
446      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
447      * a default value of 18.
448      *
449      * To select a different value for {decimals}, use {_setupDecimals}.
450      *
451      * All three of these values are immutable: they can only be set once during
452      * construction.
453      */
454     constructor (string memory name_, string memory symbol_) public {
455         _name = name_;
456         _symbol = symbol_;
457         _decimals = 18;
458     }
459 
460     /**
461      * @dev Returns the name of the token.
462      */
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev Returns the symbol of the token, usually a shorter version of the
469      * name.
470      */
471     function symbol() public view returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
482      * called.
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals() public view returns (uint8) {
489         return _decimals;
490     }
491 
492     /**
493      * @dev See {IERC20-totalSupply}.
494      */
495     function totalSupply() public view override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     /**
500      * @dev See {IERC20-balanceOf}.
501      */
502     function balanceOf(address account) public view override returns (uint256) {
503         return _balances[account];
504     }
505 
506     /**
507      * @dev See {IERC20-transfer}.
508      *
509      * Requirements:
510      *
511      * - `recipient` cannot be the zero address.
512      * - the caller must have a balance of at least `amount`.
513      */
514     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
515         _transfer(_msgSender(), recipient, amount);
516         return true;
517     }
518 
519     /**
520      * @dev See {IERC20-allowance}.
521      */
522     function allowance(address owner, address spender) public view virtual override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     /**
527      * @dev See {IERC20-approve}.
528      *
529      * Requirements:
530      *
531      * - `spender` cannot be the zero address.
532      */
533     function approve(address spender, uint256 amount) public virtual override returns (bool) {
534         _approve(_msgSender(), spender, amount);
535         return true;
536     }
537 
538     /**
539      * @dev See {IERC20-transferFrom}.
540      *
541      * Emits an {Approval} event indicating the updated allowance. This is not
542      * required by the EIP. See the note at the beginning of {ERC20}.
543      *
544      * Requirements:
545      *
546      * - `sender` and `recipient` cannot be the zero address.
547      * - `sender` must have a balance of at least `amount`.
548      * - the caller must have allowance for ``sender``'s tokens of at least
549      * `amount`.
550      */
551     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
552         _transfer(sender, recipient, amount);
553         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
554         return true;
555     }
556 
557     /**
558      * @dev Atomically increases the allowance granted to `spender` by the caller.
559      *
560      * This is an alternative to {approve} that can be used as a mitigation for
561      * problems described in {IERC20-approve}.
562      *
563      * Emits an {Approval} event indicating the updated allowance.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
570         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically decreases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      * - `spender` must have allowance for the caller of at least
586      * `subtractedValue`.
587      */
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
590         return true;
591     }
592 
593     /**
594      * @dev Moves tokens `amount` from `sender` to `recipient`.
595      *
596      * This is internal function is equivalent to {transfer}, and can be used to
597      * e.g. implement automatic token fees, slashing mechanisms, etc.
598      *
599      * Emits a {Transfer} event.
600      *
601      * Requirements:
602      *
603      * - `sender` cannot be the zero address.
604      * - `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      */
607     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
608         require(sender != address(0), "ERC20: transfer from the zero address");
609         require(recipient != address(0), "ERC20: transfer to the zero address");
610 
611         _beforeTokenTransfer(sender, recipient, amount);
612 
613         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
614         _balances[recipient] = _balances[recipient].add(amount);
615         emit Transfer(sender, recipient, amount);
616     }
617 
618     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
619      * the total supply.
620      *
621      * Emits a {Transfer} event with `from` set to the zero address.
622      *
623      * Requirements:
624      *
625      * - `to` cannot be the zero address.
626      */
627     function _mint(address account, uint256 amount) internal virtual {
628         require(account != address(0), "ERC20: mint to the zero address");
629 
630         _beforeTokenTransfer(address(0), account, amount);
631 
632         _totalSupply = _totalSupply.add(amount);
633         _balances[account] = _balances[account].add(amount);
634         emit Transfer(address(0), account, amount);
635     }
636 
637     /**
638      * @dev Destroys `amount` tokens from `account`, reducing the
639      * total supply.
640      *
641      * Emits a {Transfer} event with `to` set to the zero address.
642      *
643      * Requirements:
644      *
645      * - `account` cannot be the zero address.
646      * - `account` must have at least `amount` tokens.
647      */
648     function _burn(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: burn from the zero address");
650 
651         _beforeTokenTransfer(account, address(0), amount);
652 
653         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
654         _totalSupply = _totalSupply.sub(amount);
655         emit Transfer(account, address(0), amount);
656     }
657 
658     /**
659      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
660      *
661      * This internal function is equivalent to `approve`, and can be used to
662      * e.g. set automatic allowances for certain subsystems, etc.
663      *
664      * Emits an {Approval} event.
665      *
666      * Requirements:
667      *
668      * - `owner` cannot be the zero address.
669      * - `spender` cannot be the zero address.
670      */
671     function _approve(address owner, address spender, uint256 amount) internal virtual {
672         require(owner != address(0), "ERC20: approve from the zero address");
673         require(spender != address(0), "ERC20: approve to the zero address");
674 
675         _allowances[owner][spender] = amount;
676         emit Approval(owner, spender, amount);
677     }
678 
679     /**
680      * @dev Sets {decimals} to a value other than the default one of 18.
681      *
682      * WARNING: This function should only be called from the constructor. Most
683      * applications that interact with token contracts will not expect
684      * {decimals} to ever change, and may work incorrectly if it does.
685      */
686     function _setupDecimals(uint8 decimals_) internal {
687         _decimals = decimals_;
688     }
689 
690     /**
691      * @dev Hook that is called before any transfer of tokens. This includes
692      * minting and burning.
693      *
694      * Calling conditions:
695      *
696      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
697      * will be to transferred to `to`.
698      * - when `from` is zero, `amount` tokens will be minted for `to`.
699      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
700      * - `from` and `to` are never both zero.
701      *
702      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
703      */
704     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
705 }
706 
707 // SPDX-License-Identifier: MIT
708 /**
709  * @title Staking interface, as defined by EIP-900.
710  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
711  */
712 interface IStaking {
713     event Staked(
714         address indexed user,
715         uint256 amount,
716         uint256 total,
717         bytes data
718     );
719     event Unstaked(
720         address indexed user,
721         uint256 amount,
722         uint256 total,
723         bytes data
724     );
725 
726     function unstake(address staker, uint256 amount, bytes calldata data) external;
727 
728     function totalStakedFor(address addr) external view returns (uint256);
729 
730     function totalStaked() external view returns (uint256);
731 
732     function token() external view returns (address);
733 
734     function supportsHistory() external pure returns (bool);
735 }
736 
737 // SPDX-License-Identifier: MIT
738 /**
739  * @title Staking interface, as defined by EIP-900.
740  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
741  */
742 interface IStakeWithNFT {
743     function stake(
744         address staker,
745         uint256 amount,
746         bytes calldata data,
747         int256 nftId
748     ) external;
749 
750     function stakeFor(
751         address staker,
752         address user,
753         uint256 amount,
754         bytes calldata data,
755         int256 nftId
756     ) external;
757 }
758 
759 // SPDX-License-Identifier: MIT
760 /**
761  * @title A simple holder of tokens.
762  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
763  * needs to hold multiple distinct pools of the same token.
764  */
765 contract TokenPool is Ownable {
766     IERC20 public token;
767     bool private _isTokenRescuable;
768 
769     constructor(IERC20 _token) public {
770         token = _token;
771         _isTokenRescuable = false;
772     }
773 
774     function balance() public view returns (uint256) {
775         return token.balanceOf(address(this));
776     }
777 
778     function setRescuable(bool rescuable) public onlyOwner {
779         _isTokenRescuable = rescuable;
780     }
781 
782     function transfer(address to, uint256 value)
783         external
784         onlyOwner
785         returns (bool)
786     {
787         return token.transfer(to, value);
788     }
789 
790     function rescueFunds(
791         address tokenToRescue,
792         address to,
793         uint256 amount
794     ) external onlyOwner returns (bool) {
795         if (!_isTokenRescuable) {
796             require(
797                 address(token) != tokenToRescue,
798                 "TokenPool: Cannot claim token held by the contract"
799             );
800         }
801 
802         return IERC20(tokenToRescue).transfer(to, amount);
803     }
804 }
805 
806 // SPDX-License-Identifier: MIT
807 /**
808  * @dev Interface of the ERC165 standard, as defined in the
809  * https://eips.ethereum.org/EIPS/eip-165[EIP].
810  *
811  * Implementers can declare support of contract interfaces, which can then be
812  * queried by others ({ERC165Checker}).
813  *
814  * For an implementation, see {ERC165}.
815  */
816 interface IERC165 {
817     /**
818      * @dev Returns true if this contract implements the interface defined by
819      * `interfaceId`. See the corresponding
820      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
821      * to learn more about how these ids are created.
822      *
823      * This function call must use less than 30 000 gas.
824      */
825     function supportsInterface(bytes4 interfaceId) external view returns (bool);
826 }
827 
828 // SPDX-License-Identifier: MIT
829 /**
830  * @dev Required interface of an ERC721 compliant contract.
831  */
832 interface IERC721 is IERC165 {
833     /**
834      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
835      */
836     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
837 
838     /**
839      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
840      */
841     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
842 
843     /**
844      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
845      */
846     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
847 
848     /**
849      * @dev Returns the number of tokens in ``owner``'s account.
850      */
851     function balanceOf(address owner) external view returns (uint256 balance);
852 
853     /**
854      * @dev Returns the owner of the `tokenId` token.
855      *
856      * Requirements:
857      *
858      * - `tokenId` must exist.
859      */
860     function ownerOf(uint256 tokenId) external view returns (address owner);
861 
862     /**
863      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
864      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
865      *
866      * Requirements:
867      *
868      * - `from` cannot be the zero address.
869      * - `to` cannot be the zero address.
870      * - `tokenId` token must exist and be owned by `from`.
871      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
872      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
873      *
874      * Emits a {Transfer} event.
875      */
876     function safeTransferFrom(address from, address to, uint256 tokenId) external;
877 
878     /**
879      * @dev Transfers `tokenId` token from `from` to `to`.
880      *
881      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must be owned by `from`.
888      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
889      *
890      * Emits a {Transfer} event.
891      */
892     function transferFrom(address from, address to, uint256 tokenId) external;
893 
894     /**
895      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
896      * The approval is cleared when the token is transferred.
897      *
898      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
899      *
900      * Requirements:
901      *
902      * - The caller must own the token or be an approved operator.
903      * - `tokenId` must exist.
904      *
905      * Emits an {Approval} event.
906      */
907     function approve(address to, uint256 tokenId) external;
908 
909     /**
910      * @dev Returns the account approved for `tokenId` token.
911      *
912      * Requirements:
913      *
914      * - `tokenId` must exist.
915      */
916     function getApproved(uint256 tokenId) external view returns (address operator);
917 
918     /**
919      * @dev Approve or remove `operator` as an operator for the caller.
920      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
921      *
922      * Requirements:
923      *
924      * - The `operator` cannot be the caller.
925      *
926      * Emits an {ApprovalForAll} event.
927      */
928     function setApprovalForAll(address operator, bool _approved) external;
929 
930     /**
931      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
932      *
933      * See {setApprovalForAll}
934      */
935     function isApprovedForAll(address owner, address operator) external view returns (bool);
936 
937     /**
938       * @dev Safely transfers `tokenId` token from `from` to `to`.
939       *
940       * Requirements:
941       *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944       * - `tokenId` token must exist and be owned by `from`.
945       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
946       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947       *
948       * Emits a {Transfer} event.
949       */
950     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
951 }
952 
953 // SPDX-License-Identifier: MIT
954 /**
955  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
956  * @dev See https://eips.ethereum.org/EIPS/eip-721
957  */
958 interface IERC721Metadata is IERC721 {
959 
960     /**
961      * @dev Returns the token collection name.
962      */
963     function name() external view returns (string memory);
964 
965     /**
966      * @dev Returns the token collection symbol.
967      */
968     function symbol() external view returns (string memory);
969 
970     /**
971      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
972      */
973     function tokenURI(uint256 tokenId) external view returns (string memory);
974 }
975 
976 // SPDX-License-Identifier: MIT
977 /**
978  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 interface IERC721Enumerable is IERC721 {
982 
983     /**
984      * @dev Returns the total amount of tokens stored by the contract.
985      */
986     function totalSupply() external view returns (uint256);
987 
988     /**
989      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
990      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
991      */
992     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
993 
994     /**
995      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
996      * Use along with {totalSupply} to enumerate all tokens.
997      */
998     function tokenByIndex(uint256 index) external view returns (uint256);
999 }
1000 
1001 // SPDX-License-Identifier: MIT
1002 /**
1003  * @title ERC721 token receiver interface
1004  * @dev Interface for any contract that wants to support safeTransfers
1005  * from ERC721 asset contracts.
1006  */
1007 interface IERC721Receiver {
1008     /**
1009      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1010      * by `operator` from `from`, this function is called.
1011      *
1012      * It must return its Solidity selector to confirm the token transfer.
1013      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1014      *
1015      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1016      */
1017     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1018 }
1019 
1020 // SPDX-License-Identifier: MIT
1021 /**
1022  * @dev Implementation of the {IERC165} interface.
1023  *
1024  * Contracts may inherit from this and call {_registerInterface} to declare
1025  * their support of an interface.
1026  */
1027 abstract contract ERC165 is IERC165 {
1028     /*
1029      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1030      */
1031     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1032 
1033     /**
1034      * @dev Mapping of interface ids to whether or not it's supported.
1035      */
1036     mapping(bytes4 => bool) private _supportedInterfaces;
1037 
1038     constructor () internal {
1039         // Derived contracts need only register support for their own interfaces,
1040         // we register support for ERC165 itself here
1041         _registerInterface(_INTERFACE_ID_ERC165);
1042     }
1043 
1044     /**
1045      * @dev See {IERC165-supportsInterface}.
1046      *
1047      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1048      */
1049     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1050         return _supportedInterfaces[interfaceId];
1051     }
1052 
1053     /**
1054      * @dev Registers the contract as an implementer of the interface defined by
1055      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1056      * registering its interface id is not required.
1057      *
1058      * See {IERC165-supportsInterface}.
1059      *
1060      * Requirements:
1061      *
1062      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1063      */
1064     function _registerInterface(bytes4 interfaceId) internal virtual {
1065         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1066         _supportedInterfaces[interfaceId] = true;
1067     }
1068 }
1069 
1070 // SPDX-License-Identifier: MIT
1071 /**
1072  * @dev Collection of functions related to the address type
1073  */
1074 library Address {
1075     /**
1076      * @dev Returns true if `account` is a contract.
1077      *
1078      * [IMPORTANT]
1079      * ====
1080      * It is unsafe to assume that an address for which this function returns
1081      * false is an externally-owned account (EOA) and not a contract.
1082      *
1083      * Among others, `isContract` will return false for the following
1084      * types of addresses:
1085      *
1086      *  - an externally-owned account
1087      *  - a contract in construction
1088      *  - an address where a contract will be created
1089      *  - an address where a contract lived, but was destroyed
1090      * ====
1091      */
1092     function isContract(address account) internal view returns (bool) {
1093         // This method relies on extcodesize, which returns 0 for contracts in
1094         // construction, since the code is only stored at the end of the
1095         // constructor execution.
1096 
1097         uint256 size;
1098         // solhint-disable-next-line no-inline-assembly
1099         assembly { size := extcodesize(account) }
1100         return size > 0;
1101     }
1102 
1103     /**
1104      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1105      * `recipient`, forwarding all available gas and reverting on errors.
1106      *
1107      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1108      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1109      * imposed by `transfer`, making them unable to receive funds via
1110      * `transfer`. {sendValue} removes this limitation.
1111      *
1112      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1113      *
1114      * IMPORTANT: because control is transferred to `recipient`, care must be
1115      * taken to not create reentrancy vulnerabilities. Consider using
1116      * {ReentrancyGuard} or the
1117      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1118      */
1119     function sendValue(address payable recipient, uint256 amount) internal {
1120         require(address(this).balance >= amount, "Address: insufficient balance");
1121 
1122         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1123         (bool success, ) = recipient.call{ value: amount }("");
1124         require(success, "Address: unable to send value, recipient may have reverted");
1125     }
1126 
1127     /**
1128      * @dev Performs a Solidity function call using a low level `call`. A
1129      * plain`call` is an unsafe replacement for a function call: use this
1130      * function instead.
1131      *
1132      * If `target` reverts with a revert reason, it is bubbled up by this
1133      * function (like regular Solidity function calls).
1134      *
1135      * Returns the raw returned data. To convert to the expected return value,
1136      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1137      *
1138      * Requirements:
1139      *
1140      * - `target` must be a contract.
1141      * - calling `target` with `data` must not revert.
1142      *
1143      * _Available since v3.1._
1144      */
1145     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1146       return functionCall(target, data, "Address: low-level call failed");
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1151      * `errorMessage` as a fallback revert reason when `target` reverts.
1152      *
1153      * _Available since v3.1._
1154      */
1155     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1156         return functionCallWithValue(target, data, 0, errorMessage);
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1161      * but also transferring `value` wei to `target`.
1162      *
1163      * Requirements:
1164      *
1165      * - the calling contract must have an ETH balance of at least `value`.
1166      * - the called Solidity function must be `payable`.
1167      *
1168      * _Available since v3.1._
1169      */
1170     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1171         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1172     }
1173 
1174     /**
1175      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1176      * with `errorMessage` as a fallback revert reason when `target` reverts.
1177      *
1178      * _Available since v3.1._
1179      */
1180     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1181         require(address(this).balance >= value, "Address: insufficient balance for call");
1182         require(isContract(target), "Address: call to non-contract");
1183 
1184         // solhint-disable-next-line avoid-low-level-calls
1185         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1186         return _verifyCallResult(success, returndata, errorMessage);
1187     }
1188 
1189     /**
1190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1191      * but performing a static call.
1192      *
1193      * _Available since v3.3._
1194      */
1195     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1196         return functionStaticCall(target, data, "Address: low-level static call failed");
1197     }
1198 
1199     /**
1200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1201      * but performing a static call.
1202      *
1203      * _Available since v3.3._
1204      */
1205     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1206         require(isContract(target), "Address: static call to non-contract");
1207 
1208         // solhint-disable-next-line avoid-low-level-calls
1209         (bool success, bytes memory returndata) = target.staticcall(data);
1210         return _verifyCallResult(success, returndata, errorMessage);
1211     }
1212 
1213     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1214         if (success) {
1215             return returndata;
1216         } else {
1217             // Look for revert reason and bubble it up if present
1218             if (returndata.length > 0) {
1219                 // The easiest way to bubble the revert reason is using memory via assembly
1220 
1221                 // solhint-disable-next-line no-inline-assembly
1222                 assembly {
1223                     let returndata_size := mload(returndata)
1224                     revert(add(32, returndata), returndata_size)
1225                 }
1226             } else {
1227                 revert(errorMessage);
1228             }
1229         }
1230     }
1231 }
1232 
1233 // SPDX-License-Identifier: MIT
1234 /**
1235  * @dev Library for managing
1236  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1237  * types.
1238  *
1239  * Sets have the following properties:
1240  *
1241  * - Elements are added, removed, and checked for existence in constant time
1242  * (O(1)).
1243  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1244  *
1245  * ```
1246  * contract Example {
1247  *     // Add the library methods
1248  *     using EnumerableSet for EnumerableSet.AddressSet;
1249  *
1250  *     // Declare a set state variable
1251  *     EnumerableSet.AddressSet private mySet;
1252  * }
1253  * ```
1254  *
1255  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1256  * and `uint256` (`UintSet`) are supported.
1257  */
1258 library EnumerableSet {
1259     // To implement this library for multiple types with as little code
1260     // repetition as possible, we write it in terms of a generic Set type with
1261     // bytes32 values.
1262     // The Set implementation uses private functions, and user-facing
1263     // implementations (such as AddressSet) are just wrappers around the
1264     // underlying Set.
1265     // This means that we can only create new EnumerableSets for types that fit
1266     // in bytes32.
1267 
1268     struct Set {
1269         // Storage of set values
1270         bytes32[] _values;
1271 
1272         // Position of the value in the `values` array, plus 1 because index 0
1273         // means a value is not in the set.
1274         mapping (bytes32 => uint256) _indexes;
1275     }
1276 
1277     /**
1278      * @dev Add a value to a set. O(1).
1279      *
1280      * Returns true if the value was added to the set, that is if it was not
1281      * already present.
1282      */
1283     function _add(Set storage set, bytes32 value) private returns (bool) {
1284         if (!_contains(set, value)) {
1285             set._values.push(value);
1286             // The value is stored at length-1, but we add 1 to all indexes
1287             // and use 0 as a sentinel value
1288             set._indexes[value] = set._values.length;
1289             return true;
1290         } else {
1291             return false;
1292         }
1293     }
1294 
1295     /**
1296      * @dev Removes a value from a set. O(1).
1297      *
1298      * Returns true if the value was removed from the set, that is if it was
1299      * present.
1300      */
1301     function _remove(Set storage set, bytes32 value) private returns (bool) {
1302         // We read and store the value's index to prevent multiple reads from the same storage slot
1303         uint256 valueIndex = set._indexes[value];
1304 
1305         if (valueIndex != 0) { // Equivalent to contains(set, value)
1306             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1307             // the array, and then remove the last element (sometimes called as 'swap and pop').
1308             // This modifies the order of the array, as noted in {at}.
1309 
1310             uint256 toDeleteIndex = valueIndex - 1;
1311             uint256 lastIndex = set._values.length - 1;
1312 
1313             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1314             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1315 
1316             bytes32 lastvalue = set._values[lastIndex];
1317 
1318             // Move the last value to the index where the value to delete is
1319             set._values[toDeleteIndex] = lastvalue;
1320             // Update the index for the moved value
1321             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1322 
1323             // Delete the slot where the moved value was stored
1324             set._values.pop();
1325 
1326             // Delete the index for the deleted slot
1327             delete set._indexes[value];
1328 
1329             return true;
1330         } else {
1331             return false;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Returns true if the value is in the set. O(1).
1337      */
1338     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1339         return set._indexes[value] != 0;
1340     }
1341 
1342     /**
1343      * @dev Returns the number of values on the set. O(1).
1344      */
1345     function _length(Set storage set) private view returns (uint256) {
1346         return set._values.length;
1347     }
1348 
1349    /**
1350     * @dev Returns the value stored at position `index` in the set. O(1).
1351     *
1352     * Note that there are no guarantees on the ordering of values inside the
1353     * array, and it may change when more values are added or removed.
1354     *
1355     * Requirements:
1356     *
1357     * - `index` must be strictly less than {length}.
1358     */
1359     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1360         require(set._values.length > index, "EnumerableSet: index out of bounds");
1361         return set._values[index];
1362     }
1363 
1364     // Bytes32Set
1365 
1366     struct Bytes32Set {
1367         Set _inner;
1368     }
1369 
1370     /**
1371      * @dev Add a value to a set. O(1).
1372      *
1373      * Returns true if the value was added to the set, that is if it was not
1374      * already present.
1375      */
1376     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1377         return _add(set._inner, value);
1378     }
1379 
1380     /**
1381      * @dev Removes a value from a set. O(1).
1382      *
1383      * Returns true if the value was removed from the set, that is if it was
1384      * present.
1385      */
1386     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1387         return _remove(set._inner, value);
1388     }
1389 
1390     /**
1391      * @dev Returns true if the value is in the set. O(1).
1392      */
1393     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1394         return _contains(set._inner, value);
1395     }
1396 
1397     /**
1398      * @dev Returns the number of values in the set. O(1).
1399      */
1400     function length(Bytes32Set storage set) internal view returns (uint256) {
1401         return _length(set._inner);
1402     }
1403 
1404    /**
1405     * @dev Returns the value stored at position `index` in the set. O(1).
1406     *
1407     * Note that there are no guarantees on the ordering of values inside the
1408     * array, and it may change when more values are added or removed.
1409     *
1410     * Requirements:
1411     *
1412     * - `index` must be strictly less than {length}.
1413     */
1414     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1415         return _at(set._inner, index);
1416     }
1417 
1418     // AddressSet
1419 
1420     struct AddressSet {
1421         Set _inner;
1422     }
1423 
1424     /**
1425      * @dev Add a value to a set. O(1).
1426      *
1427      * Returns true if the value was added to the set, that is if it was not
1428      * already present.
1429      */
1430     function add(AddressSet storage set, address value) internal returns (bool) {
1431         return _add(set._inner, bytes32(uint256(value)));
1432     }
1433 
1434     /**
1435      * @dev Removes a value from a set. O(1).
1436      *
1437      * Returns true if the value was removed from the set, that is if it was
1438      * present.
1439      */
1440     function remove(AddressSet storage set, address value) internal returns (bool) {
1441         return _remove(set._inner, bytes32(uint256(value)));
1442     }
1443 
1444     /**
1445      * @dev Returns true if the value is in the set. O(1).
1446      */
1447     function contains(AddressSet storage set, address value) internal view returns (bool) {
1448         return _contains(set._inner, bytes32(uint256(value)));
1449     }
1450 
1451     /**
1452      * @dev Returns the number of values in the set. O(1).
1453      */
1454     function length(AddressSet storage set) internal view returns (uint256) {
1455         return _length(set._inner);
1456     }
1457 
1458    /**
1459     * @dev Returns the value stored at position `index` in the set. O(1).
1460     *
1461     * Note that there are no guarantees on the ordering of values inside the
1462     * array, and it may change when more values are added or removed.
1463     *
1464     * Requirements:
1465     *
1466     * - `index` must be strictly less than {length}.
1467     */
1468     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1469         return address(uint256(_at(set._inner, index)));
1470     }
1471 
1472 
1473     // UintSet
1474 
1475     struct UintSet {
1476         Set _inner;
1477     }
1478 
1479     /**
1480      * @dev Add a value to a set. O(1).
1481      *
1482      * Returns true if the value was added to the set, that is if it was not
1483      * already present.
1484      */
1485     function add(UintSet storage set, uint256 value) internal returns (bool) {
1486         return _add(set._inner, bytes32(value));
1487     }
1488 
1489     /**
1490      * @dev Removes a value from a set. O(1).
1491      *
1492      * Returns true if the value was removed from the set, that is if it was
1493      * present.
1494      */
1495     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1496         return _remove(set._inner, bytes32(value));
1497     }
1498 
1499     /**
1500      * @dev Returns true if the value is in the set. O(1).
1501      */
1502     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1503         return _contains(set._inner, bytes32(value));
1504     }
1505 
1506     /**
1507      * @dev Returns the number of values on the set. O(1).
1508      */
1509     function length(UintSet storage set) internal view returns (uint256) {
1510         return _length(set._inner);
1511     }
1512 
1513    /**
1514     * @dev Returns the value stored at position `index` in the set. O(1).
1515     *
1516     * Note that there are no guarantees on the ordering of values inside the
1517     * array, and it may change when more values are added or removed.
1518     *
1519     * Requirements:
1520     *
1521     * - `index` must be strictly less than {length}.
1522     */
1523     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1524         return uint256(_at(set._inner, index));
1525     }
1526 }
1527 
1528 // SPDX-License-Identifier: MIT
1529 /**
1530  * @dev Library for managing an enumerable variant of Solidity's
1531  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1532  * type.
1533  *
1534  * Maps have the following properties:
1535  *
1536  * - Entries are added, removed, and checked for existence in constant time
1537  * (O(1)).
1538  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1539  *
1540  * ```
1541  * contract Example {
1542  *     // Add the library methods
1543  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1544  *
1545  *     // Declare a set state variable
1546  *     EnumerableMap.UintToAddressMap private myMap;
1547  * }
1548  * ```
1549  *
1550  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1551  * supported.
1552  */
1553 library EnumerableMap {
1554     // To implement this library for multiple types with as little code
1555     // repetition as possible, we write it in terms of a generic Map type with
1556     // bytes32 keys and values.
1557     // The Map implementation uses private functions, and user-facing
1558     // implementations (such as Uint256ToAddressMap) are just wrappers around
1559     // the underlying Map.
1560     // This means that we can only create new EnumerableMaps for types that fit
1561     // in bytes32.
1562 
1563     struct MapEntry {
1564         bytes32 _key;
1565         bytes32 _value;
1566     }
1567 
1568     struct Map {
1569         // Storage of map keys and values
1570         MapEntry[] _entries;
1571 
1572         // Position of the entry defined by a key in the `entries` array, plus 1
1573         // because index 0 means a key is not in the map.
1574         mapping (bytes32 => uint256) _indexes;
1575     }
1576 
1577     /**
1578      * @dev Adds a key-value pair to a map, or updates the value for an existing
1579      * key. O(1).
1580      *
1581      * Returns true if the key was added to the map, that is if it was not
1582      * already present.
1583      */
1584     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1585         // We read and store the key's index to prevent multiple reads from the same storage slot
1586         uint256 keyIndex = map._indexes[key];
1587 
1588         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1589             map._entries.push(MapEntry({ _key: key, _value: value }));
1590             // The entry is stored at length-1, but we add 1 to all indexes
1591             // and use 0 as a sentinel value
1592             map._indexes[key] = map._entries.length;
1593             return true;
1594         } else {
1595             map._entries[keyIndex - 1]._value = value;
1596             return false;
1597         }
1598     }
1599 
1600     /**
1601      * @dev Removes a key-value pair from a map. O(1).
1602      *
1603      * Returns true if the key was removed from the map, that is if it was present.
1604      */
1605     function _remove(Map storage map, bytes32 key) private returns (bool) {
1606         // We read and store the key's index to prevent multiple reads from the same storage slot
1607         uint256 keyIndex = map._indexes[key];
1608 
1609         if (keyIndex != 0) { // Equivalent to contains(map, key)
1610             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1611             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1612             // This modifies the order of the array, as noted in {at}.
1613 
1614             uint256 toDeleteIndex = keyIndex - 1;
1615             uint256 lastIndex = map._entries.length - 1;
1616 
1617             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1618             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1619 
1620             MapEntry storage lastEntry = map._entries[lastIndex];
1621 
1622             // Move the last entry to the index where the entry to delete is
1623             map._entries[toDeleteIndex] = lastEntry;
1624             // Update the index for the moved entry
1625             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1626 
1627             // Delete the slot where the moved entry was stored
1628             map._entries.pop();
1629 
1630             // Delete the index for the deleted slot
1631             delete map._indexes[key];
1632 
1633             return true;
1634         } else {
1635             return false;
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns true if the key is in the map. O(1).
1641      */
1642     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1643         return map._indexes[key] != 0;
1644     }
1645 
1646     /**
1647      * @dev Returns the number of key-value pairs in the map. O(1).
1648      */
1649     function _length(Map storage map) private view returns (uint256) {
1650         return map._entries.length;
1651     }
1652 
1653    /**
1654     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1655     *
1656     * Note that there are no guarantees on the ordering of entries inside the
1657     * array, and it may change when more entries are added or removed.
1658     *
1659     * Requirements:
1660     *
1661     * - `index` must be strictly less than {length}.
1662     */
1663     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1664         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1665 
1666         MapEntry storage entry = map._entries[index];
1667         return (entry._key, entry._value);
1668     }
1669 
1670     /**
1671      * @dev Returns the value associated with `key`.  O(1).
1672      *
1673      * Requirements:
1674      *
1675      * - `key` must be in the map.
1676      */
1677     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1678         return _get(map, key, "EnumerableMap: nonexistent key");
1679     }
1680 
1681     /**
1682      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1683      */
1684     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1685         uint256 keyIndex = map._indexes[key];
1686         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1687         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1688     }
1689 
1690     // UintToAddressMap
1691 
1692     struct UintToAddressMap {
1693         Map _inner;
1694     }
1695 
1696     /**
1697      * @dev Adds a key-value pair to a map, or updates the value for an existing
1698      * key. O(1).
1699      *
1700      * Returns true if the key was added to the map, that is if it was not
1701      * already present.
1702      */
1703     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1704         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1705     }
1706 
1707     /**
1708      * @dev Removes a value from a set. O(1).
1709      *
1710      * Returns true if the key was removed from the map, that is if it was present.
1711      */
1712     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1713         return _remove(map._inner, bytes32(key));
1714     }
1715 
1716     /**
1717      * @dev Returns true if the key is in the map. O(1).
1718      */
1719     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1720         return _contains(map._inner, bytes32(key));
1721     }
1722 
1723     /**
1724      * @dev Returns the number of elements in the map. O(1).
1725      */
1726     function length(UintToAddressMap storage map) internal view returns (uint256) {
1727         return _length(map._inner);
1728     }
1729 
1730    /**
1731     * @dev Returns the element stored at position `index` in the set. O(1).
1732     * Note that there are no guarantees on the ordering of values inside the
1733     * array, and it may change when more values are added or removed.
1734     *
1735     * Requirements:
1736     *
1737     * - `index` must be strictly less than {length}.
1738     */
1739     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1740         (bytes32 key, bytes32 value) = _at(map._inner, index);
1741         return (uint256(key), address(uint256(value)));
1742     }
1743 
1744     /**
1745      * @dev Returns the value associated with `key`.  O(1).
1746      *
1747      * Requirements:
1748      *
1749      * - `key` must be in the map.
1750      */
1751     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1752         return address(uint256(_get(map._inner, bytes32(key))));
1753     }
1754 
1755     /**
1756      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1757      */
1758     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1759         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1760     }
1761 }
1762 
1763 // SPDX-License-Identifier: MIT
1764 /**
1765  * @dev String operations.
1766  */
1767 library Strings {
1768     /**
1769      * @dev Converts a `uint256` to its ASCII `string` representation.
1770      */
1771     function toString(uint256 value) internal pure returns (string memory) {
1772         // Inspired by OraclizeAPI's implementation - MIT licence
1773         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1774 
1775         if (value == 0) {
1776             return "0";
1777         }
1778         uint256 temp = value;
1779         uint256 digits;
1780         while (temp != 0) {
1781             digits++;
1782             temp /= 10;
1783         }
1784         bytes memory buffer = new bytes(digits);
1785         uint256 index = digits - 1;
1786         temp = value;
1787         while (temp != 0) {
1788             buffer[index--] = byte(uint8(48 + temp % 10));
1789             temp /= 10;
1790         }
1791         return string(buffer);
1792     }
1793 }
1794 
1795 // SPDX-License-Identifier: MIT
1796 /**
1797  * @title ERC721 Non-Fungible Token Standard basic implementation
1798  * @dev see https://eips.ethereum.org/EIPS/eip-721
1799  */
1800 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1801     using SafeMath for uint256;
1802     using Address for address;
1803     using EnumerableSet for EnumerableSet.UintSet;
1804     using EnumerableMap for EnumerableMap.UintToAddressMap;
1805     using Strings for uint256;
1806 
1807     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1808     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1809     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1810 
1811     // Mapping from holder address to their (enumerable) set of owned tokens
1812     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1813 
1814     // Enumerable mapping from token ids to their owners
1815     EnumerableMap.UintToAddressMap private _tokenOwners;
1816 
1817     // Mapping from token ID to approved address
1818     mapping (uint256 => address) private _tokenApprovals;
1819 
1820     // Mapping from owner to operator approvals
1821     mapping (address => mapping (address => bool)) private _operatorApprovals;
1822 
1823     // Token name
1824     string private _name;
1825 
1826     // Token symbol
1827     string private _symbol;
1828 
1829     // Optional mapping for token URIs
1830     mapping (uint256 => string) private _tokenURIs;
1831 
1832     // Base URI
1833     string private _baseURI;
1834 
1835     /*
1836      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1837      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1838      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1839      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1840      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1841      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1842      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1843      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1844      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1845      *
1846      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1847      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1848      */
1849     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1850 
1851     /*
1852      *     bytes4(keccak256('name()')) == 0x06fdde03
1853      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1854      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1855      *
1856      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1857      */
1858     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1859 
1860     /*
1861      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1862      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1863      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1864      *
1865      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1866      */
1867     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1868 
1869     /**
1870      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1871      */
1872     constructor (string memory name_, string memory symbol_) public {
1873         _name = name_;
1874         _symbol = symbol_;
1875 
1876         // register the supported interfaces to conform to ERC721 via ERC165
1877         _registerInterface(_INTERFACE_ID_ERC721);
1878         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1879         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1880     }
1881 
1882     /**
1883      * @dev See {IERC721-balanceOf}.
1884      */
1885     function balanceOf(address owner) public view override returns (uint256) {
1886         require(owner != address(0), "ERC721: balance query for the zero address");
1887 
1888         return _holderTokens[owner].length();
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-ownerOf}.
1893      */
1894     function ownerOf(uint256 tokenId) public view override returns (address) {
1895         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1896     }
1897 
1898     /**
1899      * @dev See {IERC721Metadata-name}.
1900      */
1901     function name() public view override returns (string memory) {
1902         return _name;
1903     }
1904 
1905     /**
1906      * @dev See {IERC721Metadata-symbol}.
1907      */
1908     function symbol() public view override returns (string memory) {
1909         return _symbol;
1910     }
1911 
1912     /**
1913      * @dev See {IERC721Metadata-tokenURI}.
1914      */
1915     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1916         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1917 
1918         string memory _tokenURI = _tokenURIs[tokenId];
1919 
1920         // If there is no base URI, return the token URI.
1921         if (bytes(_baseURI).length == 0) {
1922             return _tokenURI;
1923         }
1924         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1925         if (bytes(_tokenURI).length > 0) {
1926             return string(abi.encodePacked(_baseURI, _tokenURI));
1927         }
1928         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1929         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1930     }
1931 
1932     /**
1933     * @dev Returns the base URI set via {_setBaseURI}. This will be
1934     * automatically added as a prefix in {tokenURI} to each token's URI, or
1935     * to the token ID if no specific URI is set for that token ID.
1936     */
1937     function baseURI() public view returns (string memory) {
1938         return _baseURI;
1939     }
1940 
1941     /**
1942      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1943      */
1944     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1945         return _holderTokens[owner].at(index);
1946     }
1947 
1948     /**
1949      * @dev See {IERC721Enumerable-totalSupply}.
1950      */
1951     function totalSupply() public view override returns (uint256) {
1952         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1953         return _tokenOwners.length();
1954     }
1955 
1956     /**
1957      * @dev See {IERC721Enumerable-tokenByIndex}.
1958      */
1959     function tokenByIndex(uint256 index) public view override returns (uint256) {
1960         (uint256 tokenId, ) = _tokenOwners.at(index);
1961         return tokenId;
1962     }
1963 
1964     /**
1965      * @dev See {IERC721-approve}.
1966      */
1967     function approve(address to, uint256 tokenId) public virtual override {
1968         address owner = ownerOf(tokenId);
1969         require(to != owner, "ERC721: approval to current owner");
1970 
1971         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1972             "ERC721: approve caller is not owner nor approved for all"
1973         );
1974 
1975         _approve(to, tokenId);
1976     }
1977 
1978     /**
1979      * @dev See {IERC721-getApproved}.
1980      */
1981     function getApproved(uint256 tokenId) public view override returns (address) {
1982         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1983 
1984         return _tokenApprovals[tokenId];
1985     }
1986 
1987     /**
1988      * @dev See {IERC721-setApprovalForAll}.
1989      */
1990     function setApprovalForAll(address operator, bool approved) public virtual override {
1991         require(operator != _msgSender(), "ERC721: approve to caller");
1992 
1993         _operatorApprovals[_msgSender()][operator] = approved;
1994         emit ApprovalForAll(_msgSender(), operator, approved);
1995     }
1996 
1997     /**
1998      * @dev See {IERC721-isApprovedForAll}.
1999      */
2000     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
2001         return _operatorApprovals[owner][operator];
2002     }
2003 
2004     /**
2005      * @dev See {IERC721-transferFrom}.
2006      */
2007     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
2008         //solhint-disable-next-line max-line-length
2009         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2010 
2011         _transfer(from, to, tokenId);
2012     }
2013 
2014     /**
2015      * @dev See {IERC721-safeTransferFrom}.
2016      */
2017     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2018         safeTransferFrom(from, to, tokenId, "");
2019     }
2020 
2021     /**
2022      * @dev See {IERC721-safeTransferFrom}.
2023      */
2024     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2025         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2026         _safeTransfer(from, to, tokenId, _data);
2027     }
2028 
2029     /**
2030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2032      *
2033      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2034      *
2035      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2036      * implement alternative mechanisms to perform token transfer, such as signature-based.
2037      *
2038      * Requirements:
2039      *
2040      * - `from` cannot be the zero address.
2041      * - `to` cannot be the zero address.
2042      * - `tokenId` token must exist and be owned by `from`.
2043      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2044      *
2045      * Emits a {Transfer} event.
2046      */
2047     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2048         _transfer(from, to, tokenId);
2049         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2050     }
2051 
2052     /**
2053      * @dev Returns whether `tokenId` exists.
2054      *
2055      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2056      *
2057      * Tokens start existing when they are minted (`_mint`),
2058      * and stop existing when they are burned (`_burn`).
2059      */
2060     function _exists(uint256 tokenId) internal view returns (bool) {
2061         return _tokenOwners.contains(tokenId);
2062     }
2063 
2064     /**
2065      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2066      *
2067      * Requirements:
2068      *
2069      * - `tokenId` must exist.
2070      */
2071     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
2072         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2073         address owner = ownerOf(tokenId);
2074         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2075     }
2076 
2077     /**
2078      * @dev Safely mints `tokenId` and transfers it to `to`.
2079      *
2080      * Requirements:
2081      d*
2082      * - `tokenId` must not exist.
2083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2084      *
2085      * Emits a {Transfer} event.
2086      */
2087     function _safeMint(address to, uint256 tokenId) internal virtual {
2088         _safeMint(to, tokenId, "");
2089     }
2090 
2091     /**
2092      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2093      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2094      */
2095     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
2096         _mint(to, tokenId);
2097         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2098     }
2099 
2100     /**
2101      * @dev Mints `tokenId` and transfers it to `to`.
2102      *
2103      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2104      *
2105      * Requirements:
2106      *
2107      * - `tokenId` must not exist.
2108      * - `to` cannot be the zero address.
2109      *
2110      * Emits a {Transfer} event.
2111      */
2112     function _mint(address to, uint256 tokenId) internal virtual {
2113         require(to != address(0), "ERC721: mint to the zero address");
2114         require(!_exists(tokenId), "ERC721: token already minted");
2115 
2116         _beforeTokenTransfer(address(0), to, tokenId);
2117 
2118         _holderTokens[to].add(tokenId);
2119 
2120         _tokenOwners.set(tokenId, to);
2121 
2122         emit Transfer(address(0), to, tokenId);
2123     }
2124 
2125     /**
2126      * @dev Destroys `tokenId`.
2127      * The approval is cleared when the token is burned.
2128      *
2129      * Requirements:
2130      *
2131      * - `tokenId` must exist.
2132      *
2133      * Emits a {Transfer} event.
2134      */
2135     function _burn(uint256 tokenId) internal virtual {
2136         address owner = ownerOf(tokenId);
2137 
2138         _beforeTokenTransfer(owner, address(0), tokenId);
2139 
2140         // Clear approvals
2141         _approve(address(0), tokenId);
2142 
2143         // Clear metadata (if any)
2144         if (bytes(_tokenURIs[tokenId]).length != 0) {
2145             delete _tokenURIs[tokenId];
2146         }
2147 
2148         _holderTokens[owner].remove(tokenId);
2149 
2150         _tokenOwners.remove(tokenId);
2151 
2152         emit Transfer(owner, address(0), tokenId);
2153     }
2154 
2155     /**
2156      * @dev Transfers `tokenId` from `from` to `to`.
2157      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2158      *
2159      * Requirements:
2160      *
2161      * - `to` cannot be the zero address.
2162      * - `tokenId` token must be owned by `from`.
2163      *
2164      * Emits a {Transfer} event.
2165      */
2166     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2167         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2168         require(to != address(0), "ERC721: transfer to the zero address");
2169 
2170         _beforeTokenTransfer(from, to, tokenId);
2171 
2172         // Clear approvals from the previous owner
2173         _approve(address(0), tokenId);
2174 
2175         _holderTokens[from].remove(tokenId);
2176         _holderTokens[to].add(tokenId);
2177 
2178         _tokenOwners.set(tokenId, to);
2179 
2180         emit Transfer(from, to, tokenId);
2181     }
2182 
2183     /**
2184      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2185      *
2186      * Requirements:
2187      *
2188      * - `tokenId` must exist.
2189      */
2190     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2191         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2192         _tokenURIs[tokenId] = _tokenURI;
2193     }
2194 
2195     /**
2196      * @dev Internal function to set the base URI for all token IDs. It is
2197      * automatically added as a prefix to the value returned in {tokenURI},
2198      * or to the token ID if {tokenURI} is empty.
2199      */
2200     function _setBaseURI(string memory baseURI_) internal virtual {
2201         _baseURI = baseURI_;
2202     }
2203 
2204     /**
2205      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2206      * The call is not executed if the target address is not a contract.
2207      *
2208      * @param from address representing the previous owner of the given token ID
2209      * @param to target address that will receive the tokens
2210      * @param tokenId uint256 ID of the token to be transferred
2211      * @param _data bytes optional data to send along with the call
2212      * @return bool whether the call correctly returned the expected magic value
2213      */
2214     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2215         private returns (bool)
2216     {
2217         if (!to.isContract()) {
2218             return true;
2219         }
2220         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2221             IERC721Receiver(to).onERC721Received.selector,
2222             _msgSender(),
2223             from,
2224             tokenId,
2225             _data
2226         ), "ERC721: transfer to non ERC721Receiver implementer");
2227         bytes4 retval = abi.decode(returndata, (bytes4));
2228         return (retval == _ERC721_RECEIVED);
2229     }
2230 
2231     function _approve(address to, uint256 tokenId) private {
2232         _tokenApprovals[tokenId] = to;
2233         emit Approval(ownerOf(tokenId), to, tokenId);
2234     }
2235 
2236     /**
2237      * @dev Hook that is called before any token transfer. This includes minting
2238      * and burning.
2239      *
2240      * Calling conditions:
2241      *
2242      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2243      * transferred to `to`.
2244      * - When `from` is zero, `tokenId` will be minted for `to`.
2245      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2246      * - `from` cannot be the zero address.
2247      * - `to` cannot be the zero address.
2248      *
2249      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2250      */
2251     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2252 }
2253 
2254 // SPDX-License-Identifier: MIT
2255 /**
2256  * @dev Contract module which allows children to implement an emergency stop
2257  * mechanism that can be triggered by an authorized account.
2258  *
2259  * This module is used through inheritance. It will make available the
2260  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2261  * the functions of your contract. Note that they will not be pausable by
2262  * simply including this module, only once the modifiers are put in place.
2263  */
2264 abstract contract Pausable is Context {
2265     /**
2266      * @dev Emitted when the pause is triggered by `account`.
2267      */
2268     event Paused(address account);
2269 
2270     /**
2271      * @dev Emitted when the pause is lifted by `account`.
2272      */
2273     event Unpaused(address account);
2274 
2275     bool private _paused;
2276 
2277     /**
2278      * @dev Initializes the contract in unpaused state.
2279      */
2280     constructor () internal {
2281         _paused = false;
2282     }
2283 
2284     /**
2285      * @dev Returns true if the contract is paused, and false otherwise.
2286      */
2287     function paused() public view returns (bool) {
2288         return _paused;
2289     }
2290 
2291     /**
2292      * @dev Modifier to make a function callable only when the contract is not paused.
2293      *
2294      * Requirements:
2295      *
2296      * - The contract must not be paused.
2297      */
2298     modifier whenNotPaused() {
2299         require(!_paused, "Pausable: paused");
2300         _;
2301     }
2302 
2303     /**
2304      * @dev Modifier to make a function callable only when the contract is paused.
2305      *
2306      * Requirements:
2307      *
2308      * - The contract must be paused.
2309      */
2310     modifier whenPaused() {
2311         require(_paused, "Pausable: not paused");
2312         _;
2313     }
2314 
2315     /**
2316      * @dev Triggers stopped state.
2317      *
2318      * Requirements:
2319      *
2320      * - The contract must not be paused.
2321      */
2322     function _pause() internal virtual whenNotPaused {
2323         _paused = true;
2324         emit Paused(_msgSender());
2325     }
2326 
2327     /**
2328      * @dev Returns to normal state.
2329      *
2330      * Requirements:
2331      *
2332      * - The contract must be paused.
2333      */
2334     function _unpause() internal virtual whenPaused {
2335         _paused = false;
2336         emit Unpaused(_msgSender());
2337     }
2338 }
2339 
2340 // SPDX-License-Identifier: MIT
2341 /**
2342  * @dev ERC721 token with pausable token transfers, minting and burning.
2343  *
2344  * Useful for scenarios such as preventing trades until the end of an evaluation
2345  * period, or having an emergency switch for freezing all token transfers in the
2346  * event of a large bug.
2347  */
2348 abstract contract ERC721Pausable is ERC721, Pausable {
2349     /**
2350      * @dev See {ERC721-_beforeTokenTransfer}.
2351      *
2352      * Requirements:
2353      *
2354      * - the contract must not be paused.
2355      */
2356     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2357         super._beforeTokenTransfer(from, to, tokenId);
2358 
2359         require(!paused(), "ERC721Pausable: token transfer while paused");
2360     }
2361 }
2362 
2363 /*
2364     uint256 public constant socialNftIdentifier = uint256(1);
2365     uint256 public constant rareNftIdentifier = uint256(2);
2366     uint256 public constant epicNftIdentifier = uint256(4);
2367     uint256 public constant legendaryNftIdentifier = uint256(8);
2368 */
2369 contract WarpNFT is Ownable, ERC721Pausable {
2370     uint256 public idTracker;
2371 
2372     // converts id -> token type
2373     mapping(uint256 => uint256) public tokenType;
2374 
2375     /**
2376     @notice the constructor function is fired only once during contract deployment
2377     @dev assuming all NFT URI metadata is based on a URL he baseURI would be something like https://
2378     **/
2379     constructor() public ERC721("Warp Finance", "WNFT") {
2380         idTracker = 0;
2381     }
2382 
2383     /**
2384     @notice mintNewNFT allows the owner of this contract to mint an input address a newNFT
2385     @param _to is the address the NFT is being minted to
2386     **/
2387     function mintNewNFT(
2388         address _to,
2389         uint256 _type,
2390         string memory _tokenURI
2391     ) public onlyOwner {
2392         _safeMint(_to, idTracker);
2393         _setTokenURI(idTracker, _tokenURI);
2394         tokenType[idTracker] = _type;
2395         idTracker++;
2396     }
2397 
2398     function burn(uint256 tokenId) public onlyOwner {
2399         _burn(tokenId);
2400     }
2401 
2402     function setTokenURI(uint256 tokenId, string memory _tokenURI)
2403         public
2404         onlyOwner
2405     {
2406         _setTokenURI(tokenId, _tokenURI);
2407     }
2408 
2409     function setBaseURI(string memory baseURI_) public onlyOwner {
2410         _setBaseURI(baseURI_);
2411     }
2412 
2413     function pause() public onlyOwner {
2414         _pause();
2415     }
2416 
2417     function unpause() public onlyOwner {
2418         _unpause();
2419     }
2420 }
2421 
2422 // SPDX-License-Identifier: MIT
2423 /**
2424  * @title Token Geyser
2425  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
2426  *      Compound and Uniswap.
2427  *
2428  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
2429  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
2430  *      claimed by users.
2431  *
2432  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
2433  *      is a function of the number of tokens deposited as well as the length of time deposited.
2434  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
2435  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
2436  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
2437  *
2438  *      More background and motivation available at:
2439  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
2440  */
2441 contract TokenGeyser is IStaking, IStakeWithNFT, Ownable {
2442     using SafeMath for uint256;
2443 
2444     event Staked(
2445         address indexed user,
2446         uint256 amount,
2447         uint256 total,
2448         bytes data
2449     );
2450     event Unstaked(
2451         address indexed user,
2452         uint256 amount,
2453         uint256 total,
2454         bytes data
2455     );
2456     event TokensClaimed(address indexed user, uint256 amount);
2457     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
2458     // amount: Unlocked tokens, total: Total locked tokens
2459     event TokensUnlocked(uint256 amount, uint256 total);
2460 
2461     TokenPool private _stakingPool;
2462     TokenPool private _unlockedPool;
2463     TokenPool private _lockedPool;
2464 
2465     //
2466     // Time-bonus params
2467     //
2468     uint256 public bonusDecimals = 2;
2469     uint256 public startBonus = 0;
2470     uint256 public bonusPeriodSec = 0;
2471 
2472     //
2473     // Global accounting state
2474     //
2475     uint256 public totalLockedShares = 0;
2476     uint256 public totalStakingShares = 0;
2477     uint256 private _totalStakingShareSeconds = 0;
2478     uint256 private _lastAccountingTimestampSec = now;
2479     uint256 private _maxUnlockSchedules = 0;
2480     uint256 private _initialSharesPerToken = 0;
2481 
2482     //
2483     // User accounting state
2484     //
2485     // Represents a single stake for a user. A user may have multiple.
2486     struct Stake {
2487         uint256 stakingShares;
2488         uint256 timestampSec;
2489     }
2490 
2491     // Caches aggregated values from the User->Stake[] map to save computation.
2492     // If lastAccountingTimestampSec is 0, there's no entry for that user.
2493     struct UserTotals {
2494         uint256 stakingShares;
2495         uint256 stakingShareSeconds;
2496         uint256 lastAccountingTimestampSec;
2497     }
2498 
2499     // Aggregated staking values per user
2500     mapping(address => UserTotals) private _userTotals;
2501 
2502     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
2503     mapping(address => Stake[]) private _userStakes;
2504 
2505 
2506     //
2507     // Locked/Unlocked Accounting state
2508     //
2509     struct UnlockSchedule {
2510         uint256 initialLockedShares;
2511         uint256 unlockedShares;
2512         uint256 lastUnlockTimestampSec;
2513         uint256 endAtSec;
2514         uint256 durationSec;
2515     }
2516 
2517     UnlockSchedule[] public unlockSchedules;
2518 
2519     WarpNFT public _warpNFT;
2520     address public geyserManager;
2521     mapping(address => uint256) public originalAmounts;
2522     mapping(address => uint256) public extraAmounts;
2523     uint256 public totalExtra;
2524     mapping(address => uint256) userEarnings;
2525 
2526     /**
2527      * @param stakingToken The token users deposit as stake.
2528      * @param distributionToken The token users receive as they unstake.
2529      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
2530      * @param startBonus_ Starting time bonus
2531      *                    e.g. 25% means user gets 25% of max distribution tokens.
2532      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
2533      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
2534      * @param bonusDecimals_ The number of decimals for shares
2535      */
2536     constructor(
2537         IERC20 stakingToken,
2538         IERC20 distributionToken,
2539         uint256 maxUnlockSchedules,
2540         uint256 startBonus_,
2541         uint256 bonusPeriodSec_,
2542         uint256 initialSharesPerToken,
2543         uint256 bonusDecimals_,
2544         address warpNFT,
2545         address managerAddress
2546     ) public {
2547         // The start bonus must be some fraction of the max. (i.e. <= 100%)
2548         require(
2549             startBonus_ <= 10**bonusDecimals_,
2550             "TokenGeyser: start bonus too high"
2551         );
2552         // If no period is desired, instead set startBonus = 100%
2553         // and bonusPeriod to a small value like 1sec.
2554         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
2555         require(
2556             initialSharesPerToken > 0,
2557             "TokenGeyser: initialSharesPerToken is zero"
2558         );
2559 
2560         require(bonusDecimals_ > 0, "TokenGeyser: bonusDecimals_ is zero");
2561 
2562         _stakingPool = new TokenPool(stakingToken);
2563         _unlockedPool = new TokenPool(distributionToken);
2564         _lockedPool = new TokenPool(distributionToken);
2565         _unlockedPool.setRescuable(true);
2566 
2567         geyserManager = managerAddress;
2568         startBonus = startBonus_;
2569         bonusDecimals = bonusDecimals_;
2570         bonusPeriodSec = bonusPeriodSec_;
2571         _maxUnlockSchedules = maxUnlockSchedules;
2572         _initialSharesPerToken = initialSharesPerToken;
2573         _warpNFT = WarpNFT(warpNFT);
2574     }
2575 
2576     /**
2577      * @return Total earnings for a user
2578     */
2579     function getEarnings(address user) public view returns (uint256) {
2580         return userEarnings[user];
2581     }
2582 
2583     /**
2584      * @dev Rescue rewards
2585      */
2586     function rescueRewards(address user) external onlyOwner {
2587         require(totalUnlocked() > 0, "TokenGeyser: Nothing to rescue");
2588         require(
2589             _unlockedPool.transfer(user, _unlockedPool.balance()),
2590             "TokenGeyser: rescue rewards from rewards pool failed"
2591         );
2592     }
2593 
2594     /**
2595      * @return The token users deposit as stake.
2596      */
2597     function getStakingToken() public view returns (IERC20) {
2598         return _stakingPool.token();
2599     }
2600 
2601     /**
2602      * @return The token users receive as they unstake.
2603      */
2604     function getDistributionToken() public view returns (IERC20) {
2605         assert(_unlockedPool.token() == _lockedPool.token());
2606         return _unlockedPool.token();
2607     }
2608 
2609     /**
2610      * @dev Transfers amount of deposit tokens from the user.
2611      * @param amount Number of deposit tokens to stake.
2612      * @param data Not used.
2613      */
2614     function stake(
2615         address staker,
2616         uint256 amount,
2617         bytes calldata data,
2618         int256 nftId
2619     ) external override {
2620         require(
2621             geyserManager == msg.sender,
2622             "This method can be called by the geyser manager only"
2623         );
2624         _stakeFor(staker, staker, amount, nftId);
2625     }
2626 
2627     /**
2628      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
2629      * @param user User address who gains credit for this stake operation.
2630      * @param amount Number of deposit tokens to stake.
2631      * @param data Not used.
2632      */
2633     function stakeFor(
2634         address staker,
2635         address user,
2636         uint256 amount,
2637         bytes calldata data,
2638         int256 nftId
2639     ) external override onlyOwner {
2640         require(
2641             geyserManager == msg.sender,
2642             "This method can be called by the geyser manager only"
2643         );
2644         _stakeFor(staker, user, amount, nftId);
2645     }
2646 
2647     /**
2648      * @dev Retrieves the boost you get for a specific NFT
2649      * @param beneficiary The address who receives the bonus
2650      * @param amount The amount for which the bonus is calculated
2651      * @param nftId The NFT identifier
2652      */
2653     function getNftBoost(
2654         address beneficiary,
2655         uint256 amount,
2656         int256 nftId
2657     ) public view returns (uint256) {
2658         if (nftId < 0) return 0;
2659         if (_warpNFT.ownerOf(uint256(nftId)) != beneficiary) return 0;
2660 
2661         uint256 nftType = _warpNFT.tokenType(uint256(nftId));
2662         if (nftType == uint256(1)) return 0;
2663 
2664         // 1 | Social - no boost
2665         // 2 | Rare - 15% boost
2666         // 4 | Epic - 75% boost
2667         // 8 | Legendary - 150% boost
2668 
2669         uint256 bonus = 1;
2670 
2671         if (nftType == uint256(2)) {
2672             bonus = 15;
2673         }
2674         if (nftType == uint256(4)) {
2675             bonus = 75;
2676         }
2677         if (nftType == uint256(8)) {
2678             bonus = 150;
2679         }
2680 
2681         uint256 result = (amount * bonus) / 100;
2682         return result;
2683     }
2684 
2685     /**
2686      * @dev Private implementation of staking methods.
2687      * @param staker User address who deposits tokens to stake.
2688      * @param beneficiary User address who gains credit for this stake operation.
2689      * @param amount Number of deposit tokens to stake.
2690      */
2691     function _stakeFor(
2692         address staker,
2693         address beneficiary,
2694         uint256 amount,
2695         int256 nftId
2696     ) private {
2697         require(amount > 0, "TokenGeyser: stake amount is zero");
2698         require(
2699             beneficiary != address(0),
2700             "TokenGeyser: beneficiary is zero address"
2701         );
2702         require(
2703             totalStakingShares == 0 || totalStaked() > 0,
2704             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
2705         );
2706         uint256 sentAmount = 0;
2707         sentAmount += amount;
2708 
2709         uint256 extra = getNftBoost(beneficiary, amount, nftId);
2710         originalAmounts[beneficiary] += amount;
2711         extraAmounts[beneficiary] += extra;
2712         amount += extra;
2713         uint256 mintedStakingShares =
2714             (totalStakingShares > 0)
2715                 ? totalStakingShares.mul(amount).div(totalStaked())
2716                 : amount.mul(_initialSharesPerToken);
2717         totalExtra += extra;
2718 
2719         require(
2720             mintedStakingShares > 0,
2721             "TokenGeyser: Stake amount is too small"
2722         );
2723 
2724         updateAccounting(beneficiary);
2725 
2726         // 1. User Accounting
2727         UserTotals storage totals = _userTotals[beneficiary];
2728         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
2729         totals.lastAccountingTimestampSec = now;
2730 
2731         Stake memory newStake = Stake(mintedStakingShares, now);
2732         _userStakes[beneficiary].push(newStake);
2733 
2734         // 2. Global Accounting
2735         totalStakingShares = totalStakingShares.add(mintedStakingShares);
2736         // Already set in updateAccounting()
2737         // _lastAccountingTimestampSec = now;
2738 
2739         // interactions
2740         require(
2741             _stakingPool.token().transferFrom(
2742                 staker,
2743                 address(_stakingPool),
2744                 sentAmount
2745             ),
2746             "TokenGeyser: transfer into staking pool failed"
2747         );
2748 
2749         emit Staked(beneficiary, sentAmount, totalStakedFor(beneficiary), "");
2750     }
2751 
2752     /**
2753      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
2754      * alotted number of distribution tokens.
2755      * @param amount Number of deposit tokens to unstake / withdraw.
2756      * @param data Not used.
2757      */
2758     function unstake(address staker, uint256 amount, bytes calldata data) external override {
2759         require(
2760             geyserManager == msg.sender,
2761             "This method can be called by the geyser manager only"
2762         );
2763         _unstake(staker, amount);
2764     }
2765 
2766     /**
2767      * @param amount Number of deposit tokens to unstake / withdraw.
2768      * @return The total number of distribution tokens that would be rewarded.
2769      */
2770     function unstakeQuery(address staker, uint256 amount) public returns (uint256) {
2771         require(
2772             geyserManager == msg.sender,
2773             "This method can be called by the geyser manager only"
2774         );
2775         return _unstake(staker, amount);
2776     }
2777 
2778     /**
2779      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
2780      * alotted number of distribution tokens.
2781      * @param amount Number of deposit tokens to unstake / withdraw.
2782      * @return The total number of distribution tokens rewarded.
2783      */
2784     function _unstake(address user, uint256 amount) private returns (uint256) {
2785         updateAccounting(user);
2786 
2787         // checks
2788         require(amount == 0, "TokenGeyser: only full unstake is allowed");
2789 
2790         amount = originalAmounts[user] + extraAmounts[user];
2791         uint256 stakingSharesToBurn =
2792             totalStakingShares.mul(amount).div(totalStaked());
2793 
2794         require(
2795             stakingSharesToBurn > 0,
2796             "TokenGeyser: Unable to unstake amount this small"
2797         );
2798 
2799         // 1. User Accounting
2800         UserTotals storage totals = _userTotals[user];
2801         Stake[] storage accountStakes = _userStakes[user];
2802 
2803         // Redeem from most recent stake and go backwards in time.
2804         uint256 stakingShareSecondsToBurn = 0;
2805         uint256 sharesLeftToBurn = stakingSharesToBurn;
2806         uint256 rewardAmount = 0;
2807         while (sharesLeftToBurn > 0) {
2808             Stake storage lastStake = accountStakes[accountStakes.length - 1];
2809             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
2810             uint256 newStakingShareSecondsToBurn = 0;
2811 
2812             if (lastStake.stakingShares <= sharesLeftToBurn) {
2813                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
2814                     stakeTimeSec
2815                 );
2816                 rewardAmount = computeNewReward(
2817                     rewardAmount,
2818                     newStakingShareSecondsToBurn,
2819                     stakeTimeSec
2820                 );
2821 
2822                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
2823                     newStakingShareSecondsToBurn
2824                 );
2825                 sharesLeftToBurn = sharesLeftToBurn.sub(
2826                     lastStake.stakingShares
2827                 );
2828                 accountStakes.pop();
2829             } else {
2830                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
2831                     stakeTimeSec
2832                 );
2833                 rewardAmount = computeNewReward(
2834                     rewardAmount,
2835                     newStakingShareSecondsToBurn,
2836                     stakeTimeSec
2837                 );
2838                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
2839                     newStakingShareSecondsToBurn
2840                 );
2841                 lastStake.stakingShares = lastStake.stakingShares.sub(
2842                     sharesLeftToBurn
2843                 );
2844                 sharesLeftToBurn = 0;
2845             }
2846         }
2847         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
2848             stakingShareSecondsToBurn
2849         );
2850         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
2851         // Already set in updateAccounting
2852         // totals.lastAccountingTimestampSec = now;
2853 
2854         // 2. Global Accounting
2855         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
2856             stakingShareSecondsToBurn
2857         );
2858         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
2859         // Already set in updateAccounting
2860         // _lastAccountingTimestampSec = now;
2861 
2862         // interactions
2863         require(
2864             _stakingPool.transfer(user, originalAmounts[user]),
2865             "TokenGeyser: transfer out of staking pool failed"
2866         );
2867 
2868         //in case rescueRewards was called, there are no rewards to be transfered
2869         if (totalUnlocked() >= rewardAmount) {
2870             require(
2871                 _unlockedPool.transfer(user, rewardAmount),
2872                 "TokenGeyser: transfer out of unlocked pool failed"
2873             );
2874             emit TokensClaimed(user, rewardAmount);
2875 
2876             userEarnings[user] += rewardAmount;
2877         }
2878         
2879 
2880         emit Unstaked(user, amount, totalStakedFor(user), "");
2881 
2882         require(
2883             totalStakingShares == 0 || totalStaked() > 0,
2884             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
2885         );
2886 
2887         totalExtra -= extraAmounts[user];
2888         originalAmounts[user] = 0;
2889         extraAmounts[user] = 0;
2890 
2891         return rewardAmount;
2892     }
2893 
2894     /**
2895      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
2896      *      encourage long-term deposits instead of constant unstake/restakes.
2897      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
2898      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
2899      * @param currentRewardTokens The current number of distribution tokens already alotted for this
2900      *                            unstake op. Any bonuses are already applied.
2901      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
2902      *                            distribution tokens.
2903      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
2904      *                     the time-bonus.
2905      * @return Updated amount of distribution tokens to award, with any bonus included on the
2906      *         newly added tokens.
2907      */
2908     function computeNewReward(
2909         uint256 currentRewardTokens,
2910         uint256 stakingShareSeconds,
2911         uint256 stakeTimeSec
2912     ) private view returns (uint256) {
2913         uint256 newRewardTokens =
2914             totalUnlocked().mul(stakingShareSeconds).div(
2915                 _totalStakingShareSeconds
2916             );
2917 
2918         if (stakeTimeSec >= bonusPeriodSec) {
2919             return currentRewardTokens.add(newRewardTokens);
2920         }
2921 
2922         uint256 oneHundredPct = 10**bonusDecimals;
2923         uint256 bonusedReward =
2924             startBonus
2925                 .add(
2926                 oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(
2927                     bonusPeriodSec
2928                 )
2929             )
2930                 .mul(newRewardTokens)
2931                 .div(oneHundredPct);
2932 
2933         return currentRewardTokens.add(bonusedReward);
2934     }
2935 
2936 
2937     /**
2938      * @param addr The user to look up staking information for.
2939      * @return The number of staking tokens deposited for addr.
2940      */
2941     function totalStakedFor(address addr)
2942         public
2943         view
2944         override
2945         returns (uint256)
2946     {
2947         uint256 amountWithExtra =
2948             totalStakingShares > 0
2949                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
2950                     totalStakingShares
2951                 )
2952                 : 0;
2953 
2954         if (amountWithExtra == 0) return amountWithExtra;
2955         return amountWithExtra - extraAmounts[addr];
2956     }
2957 
2958     /**
2959      * @return The total number of deposit tokens staked globally, by all users.
2960      */
2961     function totalStaked() public view override returns (uint256) {
2962         return _stakingPool.balance() + totalExtra;
2963     }
2964 
2965     /**
2966      * @dev Note that this application has a staking token as well as a distribution token, which
2967      * may be different. This function is required by EIP-900.
2968      * @return The deposit token used for staking.
2969      */
2970     function token() external view override returns (address) {
2971         return address(getStakingToken());
2972     }
2973 
2974     /**
2975      * @dev A globally callable function to update the accounting state of the system.
2976      *      Global state and state for the caller are updated.
2977      * @return [0] balance of the locked pool
2978      * @return [1] balance of the unlocked pool
2979      * @return [2] caller's staking share seconds
2980      * @return [3] global staking share seconds
2981      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
2982      * @return [5] block timestamp
2983      */
2984     function updateAccounting(address user)
2985         public
2986         returns (
2987             uint256,
2988             uint256,
2989             uint256,
2990             uint256,
2991             uint256,
2992             uint256
2993         )
2994     {
2995         _unlockTokens();
2996 
2997         // Global accounting
2998         uint256 newStakingShareSeconds =
2999             now.sub(_lastAccountingTimestampSec).mul(totalStakingShares);
3000         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
3001             newStakingShareSeconds
3002         );
3003         _lastAccountingTimestampSec = now;
3004 
3005         // User Accounting
3006         UserTotals storage totals = _userTotals[user];
3007         uint256 newUserStakingShareSeconds =
3008             now.sub(totals.lastAccountingTimestampSec).mul(
3009                 totals.stakingShares
3010             );
3011         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
3012             newUserStakingShareSeconds
3013         );
3014         totals.lastAccountingTimestampSec = now;
3015 
3016         uint256 totalUserRewards =
3017             (_totalStakingShareSeconds > 0)
3018                 ? totalUnlocked().mul(totals.stakingShareSeconds).div(
3019                     _totalStakingShareSeconds
3020                 )
3021                 : 0;
3022 
3023         return (
3024             totalLocked(),
3025             totalUnlocked(),
3026             totals.stakingShareSeconds,
3027             _totalStakingShareSeconds,
3028             totalUserRewards,
3029             now
3030         );
3031     }
3032 
3033     /**
3034      * @return Total number of locked distribution tokens.
3035      */
3036     function totalLocked() public view returns (uint256) {
3037         return _lockedPool.balance();
3038     }
3039 
3040     /**
3041      * @return Total number of unlocked distribution tokens.
3042      */
3043     function totalUnlocked() public view returns (uint256) {
3044         return _unlockedPool.balance();
3045     }
3046 
3047     /**
3048      * @return Number of unlock schedules.
3049      */
3050     function unlockScheduleCount() public view returns (uint256) {
3051         return unlockSchedules.length;
3052     }
3053 
3054     /**
3055      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
3056      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
3057      *      linearly over the duraction of durationSec timeframe.
3058      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
3059      * @param durationSec Length of time to linear unlock the tokens.
3060      */
3061     function lockTokens(uint256 amount, uint256 durationSec)
3062         external
3063         onlyOwner
3064     {
3065         require(
3066             unlockSchedules.length < _maxUnlockSchedules,
3067             "TokenGeyser: reached maximum unlock schedules"
3068         );
3069 
3070         // Update lockedTokens amount before using it in computations after.
3071         updateAccounting(msg.sender);
3072 
3073         uint256 lockedTokens = totalLocked();
3074         uint256 mintedLockedShares =
3075             (lockedTokens > 0)
3076                 ? totalLockedShares.mul(amount).div(lockedTokens)
3077                 : amount.mul(_initialSharesPerToken);
3078 
3079         UnlockSchedule memory schedule;
3080         schedule.initialLockedShares = mintedLockedShares;
3081         schedule.lastUnlockTimestampSec = now;
3082         schedule.endAtSec = now.add(durationSec);
3083         schedule.durationSec = durationSec;
3084         unlockSchedules.push(schedule);
3085 
3086         totalLockedShares = totalLockedShares.add(mintedLockedShares);
3087 
3088         require(
3089             _lockedPool.token().transferFrom(
3090                 msg.sender,
3091                 address(_lockedPool),
3092                 amount
3093             ),
3094             "TokenGeyser: transfer into locked pool failed"
3095         );
3096         emit TokensLocked(amount, durationSec, totalLocked());
3097     }
3098 
3099     /**
3100      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
3101      *      previously defined unlock schedules. Publicly callable.
3102      * @return Number of newly unlocked distribution tokens.
3103      */
3104     function unlockTokens() public onlyOwner returns (uint256) {
3105         _unlockTokens();
3106     }
3107 
3108     function _unlockTokens() private returns (uint256) {
3109         uint256 unlockedTokens = 0;
3110         uint256 lockedTokens = totalLocked();
3111 
3112         if (totalLockedShares == 0) {
3113             unlockedTokens = lockedTokens;
3114         } else {
3115             uint256 unlockedShares = 0;
3116             for (uint256 s = 0; s < unlockSchedules.length; s++) {
3117                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
3118             }
3119             unlockedTokens = unlockedShares.mul(lockedTokens).div(
3120                 totalLockedShares
3121             );
3122             totalLockedShares = totalLockedShares.sub(unlockedShares);
3123         }
3124 
3125         if (unlockedTokens > 0) {
3126             require(
3127                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
3128                 "TokenGeyser: transfer out of locked pool failed"
3129             );
3130             emit TokensUnlocked(unlockedTokens, totalLocked());
3131         }
3132 
3133         return unlockedTokens;
3134     }
3135 
3136     /**
3137      * @dev Returns the number of unlockable shares from a given schedule. The returned value
3138      *      depends on the time since the last unlock. This function updates schedule accounting,
3139      *      but does not actually transfer any tokens.
3140      * @param s Index of the unlock schedule.
3141      * @return The number of unlocked shares.
3142      */
3143     function unlockScheduleShares(uint256 s) private returns (uint256) {
3144         UnlockSchedule storage schedule = unlockSchedules[s];
3145 
3146         if (schedule.unlockedShares >= schedule.initialLockedShares) {
3147             return 0;
3148         }
3149 
3150         uint256 sharesToUnlock = 0;
3151         // Special case to handle any leftover dust from integer division
3152         if (now >= schedule.endAtSec) {
3153             sharesToUnlock = (
3154                 schedule.initialLockedShares.sub(schedule.unlockedShares)
3155             );
3156             schedule.lastUnlockTimestampSec = schedule.endAtSec;
3157         } else {
3158             sharesToUnlock = now
3159                 .sub(schedule.lastUnlockTimestampSec)
3160                 .mul(schedule.initialLockedShares)
3161                 .div(schedule.durationSec);
3162             schedule.lastUnlockTimestampSec = now;
3163         }
3164 
3165         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
3166         return sharesToUnlock;
3167     }
3168 
3169     /**
3170      * @dev Lets the owner rescue funds air-dropped to the staking pool.
3171      * @param tokenToRescue Address of the token to be rescued.
3172      * @param to Address to which the rescued funds are to be sent.
3173      * @param amount Amount of tokens to be rescued.
3174      * @return Transfer success.
3175      */
3176     function rescueFundsFromStakingPool(
3177         address tokenToRescue,
3178         address to,
3179         uint256 amount
3180     ) public onlyOwner returns (bool) {
3181         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
3182     }
3183 
3184     function supportsHistory() external pure override returns (bool) {
3185         return false;
3186     }
3187 }
3188 
3189 // SPDX-License-Identifier: MIT
3190 /**
3191  * @title Staking interface, as defined by EIP-900.
3192  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
3193  */
3194 interface IStake {
3195     function stake(
3196         address staker,
3197         uint256 amount,
3198         bytes calldata data
3199     ) external;
3200 
3201     function stakeFor(
3202         address staker,
3203         address user,
3204         uint256 amount,
3205         bytes calldata data
3206     ) external;
3207 }
3208 
3209 // SPDX-License-Identifier: MIT
3210 /**
3211  * @title Non Nft Token Geyser
3212  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
3213  *      Compound and Uniswap.
3214  *
3215  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
3216  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
3217  *      claimed by users.
3218  *
3219  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
3220  *      is a function of the number of tokens deposited as well as the length of time deposited.
3221  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
3222  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
3223  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
3224  *
3225  *      More background and motivation available at:
3226  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
3227  */
3228 contract TokenGeyserWithoutNFT is IStaking, IStake, Ownable {
3229     using SafeMath for uint256;
3230 
3231     event Staked(
3232         address indexed user,
3233         uint256 amount,
3234         uint256 total,
3235         bytes data
3236     );
3237     event Unstaked(
3238         address indexed user,
3239         uint256 amount,
3240         uint256 total,
3241         bytes data
3242     );
3243     event TokensClaimed(address indexed user, uint256 amount);
3244     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
3245     // amount: Unlocked tokens, total: Total locked tokens
3246     event TokensUnlocked(uint256 amount, uint256 total);
3247 
3248     TokenPool private _stakingPool;
3249     TokenPool private _unlockedPool;
3250     TokenPool private _lockedPool;
3251 
3252     //
3253     // Time-bonus params
3254     //
3255     uint256 public bonusDecimals = 2;
3256     uint256 public startBonus = 0;
3257     uint256 public bonusPeriodSec = 0;
3258 
3259     //
3260     // Global accounting state
3261     //
3262     uint256 public totalLockedShares = 0;
3263     uint256 public totalStakingShares = 0;
3264     uint256 private _totalStakingShareSeconds = 0;
3265     uint256 private _lastAccountingTimestampSec = now;
3266     uint256 private _maxUnlockSchedules = 0;
3267     uint256 private _initialSharesPerToken = 0;
3268 
3269     //
3270     // User accounting state
3271     //
3272     // Represents a single stake for a user. A user may have multiple.
3273     struct Stake {
3274         uint256 stakingShares;
3275         uint256 timestampSec;
3276     }
3277 
3278     // Caches aggregated values from the User->Stake[] map to save computation.
3279     // If lastAccountingTimestampSec is 0, there's no entry for that user.
3280     struct UserTotals {
3281         uint256 stakingShares;
3282         uint256 stakingShareSeconds;
3283         uint256 lastAccountingTimestampSec;
3284     }
3285 
3286     // Aggregated staking values per user
3287     mapping(address => UserTotals) private _userTotals;
3288 
3289     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
3290     mapping(address => Stake[]) private _userStakes;
3291 
3292     mapping(address => uint256) userEarnings;
3293 
3294     //
3295     // Locked/Unlocked Accounting state
3296     //
3297     struct UnlockSchedule {
3298         uint256 initialLockedShares;
3299         uint256 unlockedShares;
3300         uint256 lastUnlockTimestampSec;
3301         uint256 endAtSec;
3302         uint256 durationSec;
3303     }
3304 
3305     UnlockSchedule[] public unlockSchedules;
3306 
3307     address public geyserManager;
3308 
3309     /**
3310      * @param stakingToken The token users deposit as stake.
3311      * @param distributionToken The token users receive as they unstake.
3312      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
3313      * @param startBonus_ Starting time bonus
3314      *                    e.g. 25% means user gets 25% of max distribution tokens.
3315      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
3316      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
3317      * @param bonusDecimals_ The number of decimals for shares
3318      */
3319     constructor(
3320         IERC20 stakingToken,
3321         IERC20 distributionToken,
3322         uint256 maxUnlockSchedules,
3323         uint256 startBonus_,
3324         uint256 bonusPeriodSec_,
3325         uint256 initialSharesPerToken,
3326         uint256 bonusDecimals_,
3327         address managerAddress
3328     ) public {
3329         // The start bonus must be some fraction of the max. (i.e. <= 100%)
3330         require(
3331             startBonus_ <= 10**bonusDecimals_,
3332             "TokenGeyser: start bonus too high"
3333         );
3334         // If no period is desired, instead set startBonus = 100%
3335         // and bonusPeriod to a small value like 1sec.
3336         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
3337         require(
3338             initialSharesPerToken > 0,
3339             "TokenGeyser: initialSharesPerToken is zero"
3340         );
3341 
3342         require(bonusDecimals_ > 0, "TokenGeyser: bonusDecimals_ is zero");
3343 
3344         _stakingPool = new TokenPool(stakingToken);
3345         _unlockedPool = new TokenPool(distributionToken);
3346         _lockedPool = new TokenPool(distributionToken);
3347         _unlockedPool.setRescuable(true);
3348 
3349         geyserManager = managerAddress;
3350         startBonus = startBonus_;
3351         bonusDecimals = bonusDecimals_;
3352         bonusPeriodSec = bonusPeriodSec_;
3353         _maxUnlockSchedules = maxUnlockSchedules;
3354         _initialSharesPerToken = initialSharesPerToken;
3355     }
3356 
3357     /**
3358      * @return Total earnings for a user
3359     */
3360     function getEarnings(address user) public view returns (uint256) {
3361         return userEarnings[user];
3362     }
3363 
3364     /**
3365      * @dev Rescue rewards
3366      */
3367     function rescueRewards(address user) external onlyOwner {
3368         require(totalUnlocked() > 0, "TokenGeyser: Nothing to rescue");
3369         require(
3370             _unlockedPool.transfer(user, _unlockedPool.balance()),
3371             "TokenGeyser: rescue rewards from rewards pool failed"
3372         );
3373     }
3374 
3375     /**
3376      * @return The token users deposit as stake.
3377      */
3378     function getStakingToken() public view returns (IERC20) {
3379         return _stakingPool.token();
3380     }
3381 
3382     /**
3383      * @return The token users receive as they unstake.
3384      */
3385     function getDistributionToken() public view returns (IERC20) {
3386         assert(_unlockedPool.token() == _lockedPool.token());
3387         return _unlockedPool.token();
3388     }
3389 
3390     event log(string s);
3391     event log(uint256 s);
3392     event log(address s);
3393 
3394     /**
3395      * @dev Transfers amount of deposit tokens from the user.
3396      * @param amount Number of deposit tokens to stake.
3397      * @param data Not used.
3398      */
3399     function stake(
3400         address staker,
3401         uint256 amount,
3402         bytes calldata data
3403     ) external override {
3404         require(
3405             geyserManager == msg.sender,
3406             "This method can be called by the geyser manager only"
3407         );
3408         _stakeFor(staker, staker, amount);
3409     }
3410 
3411     /**
3412      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
3413      * @param user User address who gains credit for this stake operation.
3414      * @param amount Number of deposit tokens to stake.
3415      * @param data Not used.
3416      */
3417     function stakeFor(
3418         address staker,
3419         address user,
3420         uint256 amount,
3421         bytes calldata data
3422     ) external override onlyOwner {
3423         require(
3424             geyserManager == msg.sender,
3425             "This method can be called by the geyser manager only"
3426         );
3427         _stakeFor(staker, user, amount);
3428     }
3429 
3430     /**
3431      * @dev Private implementation of staking methods.
3432      * @param staker User address who deposits tokens to stake.
3433      * @param beneficiary User address who gains credit for this stake operation.
3434      * @param amount Number of deposit tokens to stake.
3435      */
3436     function _stakeFor(
3437         address staker,
3438         address beneficiary,
3439         uint256 amount
3440     ) private {
3441         require(amount > 0, "TokenGeyser: stake amount is zero");
3442         require(
3443             beneficiary != address(0),
3444             "TokenGeyser: beneficiary is zero address"
3445         );
3446         require(
3447             totalStakingShares == 0 || totalStaked() > 0,
3448             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
3449         );
3450 
3451 
3452         uint256 mintedStakingShares =
3453             (totalStakingShares > 0)
3454                 ? totalStakingShares.mul(amount).div(totalStaked())
3455                 : amount.mul(_initialSharesPerToken);
3456 
3457         require(
3458             mintedStakingShares > 0,
3459             "TokenGeyser: Stake amount is too small"
3460         );
3461 
3462         updateAccounting(beneficiary);
3463 
3464         // 1. User Accounting
3465         UserTotals storage totals = _userTotals[beneficiary];
3466         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
3467         totals.lastAccountingTimestampSec = now;
3468 
3469         Stake memory newStake = Stake(mintedStakingShares, now);
3470         _userStakes[beneficiary].push(newStake);
3471 
3472         // 2. Global Accounting
3473         totalStakingShares = totalStakingShares.add(mintedStakingShares);
3474         // Already set in updateAccounting()
3475         // _lastAccountingTimestampSec = now;
3476 
3477         // interactions
3478         require(
3479             _stakingPool.token().transferFrom(
3480                 staker,
3481                 address(_stakingPool),
3482                 amount
3483             ),
3484             "TokenGeyser: transfer into staking pool failed"
3485         );
3486 
3487         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
3488     }
3489 
3490     /**
3491      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
3492      * alotted number of distribution tokens.
3493      * @param amount Number of deposit tokens to unstake / withdraw.
3494      * @param data Not used.
3495      */
3496     function unstake(
3497         address staker,
3498         uint256 amount,
3499         bytes calldata data
3500     ) external override {
3501         require(
3502             geyserManager == msg.sender,
3503             "This method can be called by the geyser manager only"
3504         );
3505         _unstake(staker, amount);
3506     }
3507 
3508     /**
3509      * @param amount Number of deposit tokens to unstake / withdraw.
3510      * @return The total number of distribution tokens that would be rewarded.
3511      */
3512     function unstakeQuery(address staker, uint256 amount)
3513         public
3514         returns (uint256)
3515     {
3516         require(
3517             geyserManager == msg.sender,
3518             "This method can be called by the geyser manager only"
3519         );
3520         return _unstake(staker, amount);
3521     }
3522 
3523     /**
3524      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
3525      * alotted number of distribution tokens.
3526      * @param amount Number of deposit tokens to unstake / withdraw.
3527      * @return The total number of distribution tokens rewarded.
3528      */
3529     function _unstake(address user, uint256 amount) private returns (uint256) {
3530         updateAccounting(user);
3531 
3532         uint256 stakingSharesToBurn =
3533             totalStakingShares.mul(amount).div(totalStaked());
3534 
3535         require(
3536             stakingSharesToBurn > 0,
3537             "TokenGeyser: Unable to unstake amount this small"
3538         );
3539 
3540         // 1. User Accounting
3541         UserTotals storage totals = _userTotals[user];
3542         Stake[] storage accountStakes = _userStakes[user];
3543 
3544         // Redeem from most recent stake and go backwards in time.
3545         uint256 stakingShareSecondsToBurn = 0;
3546         uint256 sharesLeftToBurn = stakingSharesToBurn;
3547         uint256 rewardAmount = 0;
3548         while (sharesLeftToBurn > 0) {
3549             Stake storage lastStake = accountStakes[accountStakes.length - 1];
3550             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
3551             uint256 newStakingShareSecondsToBurn = 0;
3552 
3553             if (lastStake.stakingShares <= sharesLeftToBurn) {
3554                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
3555                     stakeTimeSec
3556                 );
3557                 rewardAmount = computeNewReward(
3558                     rewardAmount,
3559                     newStakingShareSecondsToBurn,
3560                     stakeTimeSec
3561                 );
3562 
3563                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
3564                     newStakingShareSecondsToBurn
3565                 );
3566                 sharesLeftToBurn = sharesLeftToBurn.sub(
3567                     lastStake.stakingShares
3568                 );
3569                 accountStakes.pop();
3570             } else {
3571                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
3572                     stakeTimeSec
3573                 );
3574                 rewardAmount = computeNewReward(
3575                     rewardAmount,
3576                     newStakingShareSecondsToBurn,
3577                     stakeTimeSec
3578                 );
3579                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
3580                     newStakingShareSecondsToBurn
3581                 );
3582                 lastStake.stakingShares = lastStake.stakingShares.sub(
3583                     sharesLeftToBurn
3584                 );
3585                 sharesLeftToBurn = 0;
3586             }
3587         }
3588         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
3589             stakingShareSecondsToBurn
3590         );
3591         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
3592         // Already set in updateAccounting
3593         // totals.lastAccountingTimestampSec = now;
3594 
3595         // 2. Global Accounting
3596         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
3597             stakingShareSecondsToBurn
3598         );
3599         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
3600         // Already set in updateAccountingF
3601         // _lastAccountingTimestampSec = now;
3602 
3603         // interactions
3604         require(
3605             _stakingPool.transfer(user, amount),
3606             "TokenGeyser: transfer out of staking pool failed"
3607         );
3608 
3609         //in case rescueRewards was called, there are no rewards to be transfered
3610         if (totalUnlocked() >= rewardAmount) {
3611             require(
3612                 _unlockedPool.transfer(user, rewardAmount),
3613                 "TokenGeyser: transfer out of unlocked pool failed"
3614             );
3615             emit TokensClaimed(user, rewardAmount);
3616             
3617              userEarnings[user] += rewardAmount;
3618         }
3619 
3620         emit Unstaked(user, amount, totalStakedFor(user), "");
3621 
3622         require(
3623             totalStakingShares == 0 || totalStaked() > 0,
3624             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
3625         );
3626 
3627         return rewardAmount;
3628     }
3629 
3630     /**
3631      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
3632      *      encourage long-term deposits instead of constant unstake/restakes.
3633      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
3634      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
3635      * @param currentRewardTokens The current number of distribution tokens already alotted for this
3636      *                            unstake op. Any bonuses are already applied.
3637      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
3638      *                            distribution tokens.
3639      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
3640      *                     the time-bonus.
3641      * @return Updated amount of distribution tokens to award, with any bonus included on the
3642      *         newly added tokens.
3643      */
3644     function computeNewReward(
3645         uint256 currentRewardTokens,
3646         uint256 stakingShareSeconds,
3647         uint256 stakeTimeSec
3648     ) private view returns (uint256) {
3649         uint256 newRewardTokens =
3650             totalUnlocked().mul(stakingShareSeconds).div(
3651                 _totalStakingShareSeconds
3652             );
3653 
3654         if (stakeTimeSec >= bonusPeriodSec) {
3655             return currentRewardTokens.add(newRewardTokens);
3656         }
3657 
3658         uint256 oneHundredPct = 10**bonusDecimals;
3659         uint256 bonusedReward =
3660             startBonus
3661                 .add(
3662                 oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(
3663                     bonusPeriodSec
3664                 )
3665             )
3666                 .mul(newRewardTokens)
3667                 .div(oneHundredPct);
3668 
3669         return currentRewardTokens.add(bonusedReward);
3670     }
3671 
3672     /**
3673      * @param addr The user to look up staking information for.
3674      * @return The number of staking tokens deposited for addr.
3675      */
3676     function totalStakedFor(address addr)
3677         public
3678         view
3679         override
3680         returns (uint256)
3681     {
3682         return
3683             totalStakingShares > 0
3684                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
3685                     totalStakingShares
3686                 )
3687                 : 0;
3688     }
3689 
3690     /**
3691      * @return The total number of deposit tokens staked globally, by all users.
3692      */
3693     function totalStaked() public view override returns (uint256) {
3694         return _stakingPool.balance();
3695     }
3696 
3697     /**
3698      * @dev Note that this application has a staking token as well as a distribution token, which
3699      * may be different. This function is required by EIP-900.
3700      * @return The deposit token used for staking.
3701      */
3702     function token() external view override returns (address) {
3703         return address(getStakingToken());
3704     }
3705 
3706     /**
3707      * @dev A globally callable function to update the accounting state of the system.
3708      *      Global state and state for the caller are updated.
3709      * @return [0] balance of the locked pool
3710      * @return [1] balance of the unlocked pool
3711      * @return [2] caller's staking share seconds
3712      * @return [3] global staking share seconds
3713      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
3714      * @return [5] block timestamp
3715      */
3716     function updateAccounting(address user)
3717         public
3718         returns (
3719             uint256,
3720             uint256,
3721             uint256,
3722             uint256,
3723             uint256,
3724             uint256
3725         )
3726     {
3727         _unlockTokens();
3728 
3729         // Global accounting
3730         uint256 newStakingShareSeconds =
3731             now.sub(_lastAccountingTimestampSec).mul(totalStakingShares);
3732         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
3733             newStakingShareSeconds
3734         );
3735         _lastAccountingTimestampSec = now;
3736 
3737         // User Accounting
3738         UserTotals storage totals = _userTotals[user];
3739         uint256 newUserStakingShareSeconds =
3740             now.sub(totals.lastAccountingTimestampSec).mul(
3741                 totals.stakingShares
3742             );
3743         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
3744             newUserStakingShareSeconds
3745         );
3746         totals.lastAccountingTimestampSec = now;
3747 
3748         uint256 totalUserRewards =
3749             (_totalStakingShareSeconds > 0)
3750                 ? totalUnlocked().mul(totals.stakingShareSeconds).div(
3751                     _totalStakingShareSeconds
3752                 )
3753                 : 0;
3754 
3755         return (
3756             totalLocked(),
3757             totalUnlocked(),
3758             totals.stakingShareSeconds,
3759             _totalStakingShareSeconds,
3760             totalUserRewards,
3761             now
3762         );
3763     }
3764 
3765     /**
3766      * @return Total number of locked distribution tokens.
3767      */
3768     function totalLocked() public view returns (uint256) {
3769         return _lockedPool.balance();
3770     }
3771 
3772     /**
3773      * @return Total number of unlocked distribution tokens.
3774      */
3775     function totalUnlocked() public view returns (uint256) {
3776         return _unlockedPool.balance();
3777     }
3778 
3779     /**
3780      * @return Number of unlock schedules.
3781      */
3782     function unlockScheduleCount() public view returns (uint256) {
3783         return unlockSchedules.length;
3784     }
3785 
3786     /**
3787      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
3788      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
3789      *      linearly over the duraction of durationSec timeframe.
3790      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
3791      * @param durationSec Length of time to linear unlock the tokens.
3792      */
3793     function lockTokens(uint256 amount, uint256 durationSec)
3794         external
3795         onlyOwner
3796     {
3797         require(
3798             unlockSchedules.length < _maxUnlockSchedules,
3799             "TokenGeyser: reached maximum unlock schedules"
3800         );
3801 
3802         // Update lockedTokens amount before using it in computations after.
3803         updateAccounting(msg.sender);
3804 
3805         uint256 lockedTokens = totalLocked();
3806         uint256 mintedLockedShares =
3807             (lockedTokens > 0)
3808                 ? totalLockedShares.mul(amount).div(lockedTokens)
3809                 : amount.mul(_initialSharesPerToken);
3810 
3811         UnlockSchedule memory schedule;
3812         schedule.initialLockedShares = mintedLockedShares;
3813         schedule.lastUnlockTimestampSec = now;
3814         schedule.endAtSec = now.add(durationSec);
3815         schedule.durationSec = durationSec;
3816         unlockSchedules.push(schedule);
3817 
3818         totalLockedShares = totalLockedShares.add(mintedLockedShares);
3819 
3820         require(
3821             _lockedPool.token().transferFrom(
3822                 msg.sender,
3823                 address(_lockedPool),
3824                 amount
3825             ),
3826             "TokenGeyser: transfer into locked pool failed"
3827         );
3828         emit TokensLocked(amount, durationSec, totalLocked());
3829     }
3830 
3831     /**
3832      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
3833      *      previously defined unlock schedules. Publicly callable.
3834      * @return Number of newly unlocked distribution tokens.
3835      */
3836     function unlockTokens() public onlyOwner returns (uint256) {
3837         _unlockTokens();
3838     }
3839 
3840     function _unlockTokens() private returns (uint256) {
3841         uint256 unlockedTokens = 0;
3842         uint256 lockedTokens = totalLocked();
3843 
3844         if (totalLockedShares == 0) {
3845             unlockedTokens = lockedTokens;
3846         } else {
3847             uint256 unlockedShares = 0;
3848             for (uint256 s = 0; s < unlockSchedules.length; s++) {
3849                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
3850             }
3851             unlockedTokens = unlockedShares.mul(lockedTokens).div(
3852                 totalLockedShares
3853             );
3854             totalLockedShares = totalLockedShares.sub(unlockedShares);
3855         }
3856 
3857         if (unlockedTokens > 0) {
3858             require(
3859                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
3860                 "TokenGeyser: transfer out of locked pool failed"
3861             );
3862             emit TokensUnlocked(unlockedTokens, totalLocked());
3863         }
3864 
3865         return unlockedTokens;
3866     }
3867 
3868     /**
3869      * @dev Returns the number of unlockable shares from a given schedule. The returned value
3870      *      depends on the time since the last unlock. This function updates schedule accounting,
3871      *      but does not actually transfer any tokens.
3872      * @param s Index of the unlock schedule.
3873      * @return The number of unlocked shares.
3874      */
3875     function unlockScheduleShares(uint256 s) private returns (uint256) {
3876         UnlockSchedule storage schedule = unlockSchedules[s];
3877 
3878         if (schedule.unlockedShares >= schedule.initialLockedShares) {
3879             return 0;
3880         }
3881 
3882         uint256 sharesToUnlock = 0;
3883         // Special case to handle any leftover dust from integer division
3884         if (now >= schedule.endAtSec) {
3885             sharesToUnlock = (
3886                 schedule.initialLockedShares.sub(schedule.unlockedShares)
3887             );
3888             schedule.lastUnlockTimestampSec = schedule.endAtSec;
3889         } else {
3890             sharesToUnlock = now
3891                 .sub(schedule.lastUnlockTimestampSec)
3892                 .mul(schedule.initialLockedShares)
3893                 .div(schedule.durationSec);
3894             schedule.lastUnlockTimestampSec = now;
3895         }
3896 
3897         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
3898         return sharesToUnlock;
3899     }
3900 
3901     /**
3902      * @dev Lets the owner rescue funds air-dropped to the staking pool.
3903      * @param tokenToRescue Address of the token to be rescued.
3904      * @param to Address to which the rescued funds are to be sent.
3905      * @param amount Amount of tokens to be rescued.
3906      * @return Transfer success.
3907      */
3908     function rescueFundsFromStakingPool(
3909         address tokenToRescue,
3910         address to,
3911         uint256 amount
3912     ) public onlyOwner returns (bool) {
3913         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
3914     }
3915 
3916     function supportsHistory() external pure override returns (bool) {
3917         return false;
3918     }
3919 }
3920 
3921 // SPDX-License-Identifier: MIT
3922 /** @title Token Geyser Manager */
3923 contract TokenGeyserManager is Ownable, ITokenGeyserManager {
3924     bool public hasNFTBonus;
3925     mapping(address => address) public geysers;
3926     address[] public tokens;
3927 
3928     /**
3929        @dev Creates an empty Geyser token managers
3930     
3931      */
3932     constructor(bool _hasNftBonus) public {
3933         hasNFTBonus = _hasNftBonus;
3934 
3935         emit GeyserManagerCreated(msg.sender, address(this));
3936     }
3937 
3938     /**
3939         @dev Adds a new geyser in the team
3940         @param token - address of the staking token for which the geyser was created
3941         @param geyser - address of the geyser
3942      */
3943     function addGeyser(address token, address geyser)
3944         public
3945         override
3946         onlyOwner
3947         returns (bool)
3948     {
3949         require(token != address(0), "TokenGeyserManager: token is invalid");
3950 
3951         require(geyser != address(0), "TokenGeyserManager: geyser is invalid");
3952         tokens.push(token);
3953         geysers[token] = geyser;
3954 
3955         emit GeyserAdded(msg.sender, geyser, token);
3956         return true;
3957     }
3958 
3959     /**
3960         @dev Retrieves total rewards earned for a specific staking token
3961         @param token - address of the ERC20 token
3962     */
3963     function getEarned(address token) public view override returns (uint256) {
3964         if (hasNFTBonus) {
3965             return TokenGeyser(geysers[token]).getEarnings(msg.sender);
3966         }
3967         return TokenGeyserWithoutNFT(geysers[token]).getEarnings(msg.sender);
3968     }
3969 
3970     /**
3971         @dev Retrieves total rewards earned for all the staking tokens
3972     */
3973      function getEarnings() public view override returns (address[] memory, uint256[] memory){
3974         address[] memory addresses = new address[](tokens.length);
3975         uint256[] memory amounts = new uint256[](tokens.length);
3976 
3977         for (uint8 i = 0; i < tokens.length; i++) {
3978             addresses[i] = tokens[i];
3979             if (hasNFTBonus) {
3980                 amounts[i] = TokenGeyser(geysers[tokens[i]]).getEarnings(
3981                     msg.sender
3982                 );
3983             } else {
3984                 amounts[i] = TokenGeyserWithoutNFT(geysers[tokens[i]])
3985                     .getEarnings(msg.sender);
3986             }
3987         }
3988 
3989         return (addresses, amounts);
3990      }
3991 
3992 
3993     /**
3994         @dev Retrieves staked amount for a specific token address
3995         @param token - address of the ERC20 token
3996     */
3997     function getStake(address token) public view override returns (uint256) {
3998         if (hasNFTBonus) {
3999             return TokenGeyser(geysers[token]).totalStakedFor(msg.sender);
4000         }
4001         return TokenGeyserWithoutNFT(geysers[token]).totalStakedFor(msg.sender);
4002     }
4003 
4004 
4005     /**
4006         @dev Retrieves all stakes for sender
4007      */
4008     function getStakes()
4009         public
4010         view
4011         override
4012         returns (address[] memory, uint256[] memory)
4013     {
4014         address[] memory addresses = new address[](tokens.length);
4015         uint256[] memory amounts = new uint256[](tokens.length);
4016 
4017         for (uint8 i = 0; i < tokens.length; i++) {
4018             addresses[i] = tokens[i];
4019             if (hasNFTBonus) {
4020                 amounts[i] = TokenGeyser(geysers[tokens[i]]).totalStakedFor(
4021                     msg.sender
4022                 );
4023             } else {
4024                 amounts[i] = TokenGeyserWithoutNFT(geysers[tokens[i]])
4025                     .totalStakedFor(msg.sender);
4026             }
4027         }
4028 
4029         return (addresses, amounts);
4030     }
4031 
4032 
4033     /**
4034         @dev Stakes all tokens sent
4035         @param _tokens - array of tokens' addresses you want to stake
4036         @param amounts - stake amount you want for each token
4037      */
4038     function stake(
4039         address[] calldata _tokens,
4040         uint256[] calldata amounts,
4041         int256 nftId
4042     ) external override returns (bool) {
4043         //validation
4044         require(tokens.length > 0, "TokenGeyserManager: _tokens is empty");
4045         require(amounts.length > 0, "TokenGeyserManager: amounts is empty");
4046         require(
4047             _tokens.length == amounts.length,
4048             "TokenGeyserManager: tokens and amounts need to  be the same length"
4049         );
4050 
4051         for (uint8 i = 0; i < _tokens.length; i++) {
4052             ERC20 currentToken = ERC20(_tokens[i]);
4053             uint256 currentTokenBalance = currentToken.balanceOf(msg.sender);
4054             uint256 sentAmount = amounts[i];
4055             string memory tokenName = currentToken.name();
4056 
4057             require(
4058                 currentTokenBalance >= sentAmount,
4059                 string(
4060                     abi.encodePacked(
4061                         "TokenGeyserManager: Token ",
4062                         tokenName,
4063                         " balance is lower than the amount sent"
4064                     )
4065                 )
4066             );
4067         }
4068         //actions
4069         for (uint8 i = 0; i < _tokens.length; i++) {
4070             if (hasNFTBonus) {
4071                 TokenGeyser(geysers[_tokens[i]]).stake(
4072                     msg.sender,
4073                     amounts[i],
4074                     "",
4075                     nftId
4076                 );
4077             } else {
4078                 TokenGeyserWithoutNFT(geysers[_tokens[i]]).stake(
4079                     msg.sender,
4080                     amounts[i],
4081                     ""
4082                 );
4083             }
4084 
4085             emit Staked(msg.sender, tokens[i], amounts[i]);
4086         }
4087 
4088         return true;
4089     }
4090 
4091     /**
4092         @dev Unstakes all tokens sent
4093         @param _tokens - array of tokens' addresses you want to unstake
4094         @param amounts - unstake amount you want for each token
4095      */
4096     function unstake(address[] calldata _tokens, uint256[] calldata amounts)
4097         external
4098         override
4099     {
4100         //validation
4101         require(tokens.length > 0, "TokenGeyserManager: _tokens is empty");
4102         require(amounts.length > 0, "TokenGeyserManager: amounts is empty");
4103         require(
4104             _tokens.length == amounts.length,
4105             "TokenGeyserManager: tokens and amounts need to  be the same length"
4106         );
4107 
4108         for (uint8 i = 0; i < _tokens.length; i++) {
4109             if (hasNFTBonus) {
4110                 require(
4111                     amounts[i] == 0,
4112                     "TokenGeyserManager: only full unstake is allowed"
4113                 );
4114                 TokenGeyser(geysers[_tokens[i]]).unstake(
4115                     msg.sender,
4116                     amounts[i],
4117                     ""
4118                 );
4119             } else {
4120                 TokenGeyserWithoutNFT(geysers[_tokens[i]]).unstake(
4121                     msg.sender,
4122                     amounts[i],
4123                     ""
4124                 );
4125             }
4126 
4127             emit Unstaked(msg.sender, _tokens[i], amounts[i]);
4128         }
4129     }
4130 
4131 
4132         /**
4133         @dev get current eligible rewards from all farms
4134      */
4135     function unstakeQuery(address[] calldata _tokens, uint256[] calldata amounts)
4136         external
4137         override
4138         returns (address[] memory, uint256[] memory)
4139     {
4140         //validation
4141         require(tokens.length > 0, "TokenGeyserManager: _tokens is empty");
4142         require(amounts.length > 0, "TokenGeyserManager: amounts is empty");
4143         require(
4144             _tokens.length == amounts.length,
4145             "TokenGeyserManager: tokens and amounts need to  be the same length"
4146         );
4147 
4148         address[] memory addresses = new address[](tokens.length);
4149         uint256[] memory values = new uint256[](tokens.length);
4150 
4151         for (uint8 i = 0; i < _tokens.length; i++) {
4152             addresses[i] = _tokens[i];
4153             if (hasNFTBonus) {
4154                 require(
4155                     amounts[i] == 0,
4156                     "TokenGeyserManager: only full unstake is allowed"
4157                 );
4158                 values[i] = TokenGeyser(geysers[_tokens[i]]).unstakeQuery(
4159                     msg.sender,
4160                     amounts[i]
4161                 );
4162             } else {
4163                 values[i] = TokenGeyserWithoutNFT(geysers[_tokens[i]]).unstakeQuery(
4164                     msg.sender,
4165                     amounts[i]
4166                 );
4167             }
4168 
4169             emit Unstaked(msg.sender, _tokens[i], values[i]);
4170 
4171             return (addresses, values);
4172         }
4173     }
4174 }