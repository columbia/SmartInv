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
54         @dev Adds a new geyser in the team
55         @param token - address of the staking token for which the geyser was created
56         @param geyser - address of the geyser
57      */
58     function addGeyser(address token, address geyser) external returns (bool);
59 
60     event Staked(address indexed sender, address indexed token, uint256 amount);
61     event Unstaked(
62         address indexed sender,
63         address indexed token,
64         uint256 amount
65     );
66 
67     event GeyserAdded(
68         address indexed sender,
69         address indexed geyser,
70         address token
71     );
72     event GeyserManagerCreated(
73         address indexed sender,
74         address indexed geyserManager
75     );
76 }
77 
78 // SPDX-License-Identifier: MIT
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 // SPDX-License-Identifier: MIT
236 /*
237  * @dev Provides information about the current execution context, including the
238  * sender of the transaction and its data. While these are generally available
239  * via msg.sender and msg.data, they should not be accessed in such a direct
240  * manner, since when dealing with GSN meta-transactions the account sending and
241  * paying for execution may not be the actual sender (as far as an application
242  * is concerned).
243  *
244  * This contract is only required for intermediate, library-like contracts.
245  */
246 abstract contract Context {
247     function _msgSender() internal view virtual returns (address payable) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes memory) {
252         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
253         return msg.data;
254     }
255 }
256 
257 // SPDX-License-Identifier: MIT
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * By default, the owner account will be the one that deploys the contract. This
264  * can later be changed with {transferOwnership}.
265  *
266  * This module is used through inheritance. It will make available the modifier
267  * `onlyOwner`, which can be applied to your functions to restrict their use to
268  * the owner.
269  */
270 abstract contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(_owner == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         emit OwnershipTransferred(_owner, address(0));
308         _owner = address(0);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         emit OwnershipTransferred(_owner, newOwner);
318         _owner = newOwner;
319     }
320 }
321 
322 // SPDX-License-Identifier: MIT
323 /**
324  * @dev Interface of the ERC20 standard as defined in the EIP.
325  */
326 interface IERC20 {
327     /**
328      * @dev Returns the amount of tokens in existence.
329      */
330     function totalSupply() external view returns (uint256);
331 
332     /**
333      * @dev Returns the amount of tokens owned by `account`.
334      */
335     function balanceOf(address account) external view returns (uint256);
336 
337     /**
338      * @dev Moves `amount` tokens from the caller's account to `recipient`.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transfer(address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Returns the remaining number of tokens that `spender` will be
348      * allowed to spend on behalf of `owner` through {transferFrom}. This is
349      * zero by default.
350      *
351      * This value changes when {approve} or {transferFrom} are called.
352      */
353     function allowance(address owner, address spender) external view returns (uint256);
354 
355     /**
356      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * IMPORTANT: Beware that changing an allowance with this method brings the risk
361      * that someone may use both the old and the new allowance by unfortunate
362      * transaction ordering. One possible solution to mitigate this race
363      * condition is to first reduce the spender's allowance to 0 and set the
364      * desired value afterwards:
365      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366      *
367      * Emits an {Approval} event.
368      */
369     function approve(address spender, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Moves `amount` tokens from `sender` to `recipient` using the
373      * allowance mechanism. `amount` is then deducted from the caller's
374      * allowance.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Emitted when `value` tokens are moved from one account (`from`) to
384      * another (`to`).
385      *
386      * Note that `value` may be zero.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     /**
391      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
392      * a call to {approve}. `value` is the new allowance.
393      */
394     event Approval(address indexed owner, address indexed spender, uint256 value);
395 }
396 
397 // SPDX-License-Identifier: MIT
398 /**
399  * @dev Implementation of the {IERC20} interface.
400  *
401  * This implementation is agnostic to the way tokens are created. This means
402  * that a supply mechanism has to be added in a derived contract using {_mint}.
403  * For a generic mechanism see {ERC20PresetMinterPauser}.
404  *
405  * TIP: For a detailed writeup see our guide
406  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
407  * to implement supply mechanisms].
408  *
409  * We have followed general OpenZeppelin guidelines: functions revert instead
410  * of returning `false` on failure. This behavior is nonetheless conventional
411  * and does not conflict with the expectations of ERC20 applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20 {
423     using SafeMath for uint256;
424 
425     mapping (address => uint256) private _balances;
426 
427     mapping (address => mapping (address => uint256)) private _allowances;
428 
429     uint256 private _totalSupply;
430 
431     string private _name;
432     string private _symbol;
433     uint8 private _decimals;
434 
435     /**
436      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
437      * a default value of 18.
438      *
439      * To select a different value for {decimals}, use {_setupDecimals}.
440      *
441      * All three of these values are immutable: they can only be set once during
442      * construction.
443      */
444     constructor (string memory name_, string memory symbol_) public {
445         _name = name_;
446         _symbol = symbol_;
447         _decimals = 18;
448     }
449 
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @dev Returns the symbol of the token, usually a shorter version of the
459      * name.
460      */
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     /**
466      * @dev Returns the number of decimals used to get its user representation.
467      * For example, if `decimals` equals `2`, a balance of `505` tokens should
468      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
469      *
470      * Tokens usually opt for a value of 18, imitating the relationship between
471      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
472      * called.
473      *
474      * NOTE: This information is only used for _display_ purposes: it in
475      * no way affects any of the arithmetic of the contract, including
476      * {IERC20-balanceOf} and {IERC20-transfer}.
477      */
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 
482     /**
483      * @dev See {IERC20-totalSupply}.
484      */
485     function totalSupply() public view override returns (uint256) {
486         return _totalSupply;
487     }
488 
489     /**
490      * @dev See {IERC20-balanceOf}.
491      */
492     function balanceOf(address account) public view override returns (uint256) {
493         return _balances[account];
494     }
495 
496     /**
497      * @dev See {IERC20-transfer}.
498      *
499      * Requirements:
500      *
501      * - `recipient` cannot be the zero address.
502      * - the caller must have a balance of at least `amount`.
503      */
504     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-allowance}.
511      */
512     function allowance(address owner, address spender) public view virtual override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     /**
517      * @dev See {IERC20-approve}.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         _approve(_msgSender(), spender, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-transferFrom}.
530      *
531      * Emits an {Approval} event indicating the updated allowance. This is not
532      * required by the EIP. See the note at the beginning of {ERC20}.
533      *
534      * Requirements:
535      *
536      * - `sender` and `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      * - the caller must have allowance for ``sender``'s tokens of at least
539      * `amount`.
540      */
541     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(sender, recipient, amount);
543         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
544         return true;
545     }
546 
547     /**
548      * @dev Atomically increases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      */
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically decreases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      * - `spender` must have allowance for the caller of at least
576      * `subtractedValue`.
577      */
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     /**
584      * @dev Moves tokens `amount` from `sender` to `recipient`.
585      *
586      * This is internal function is equivalent to {transfer}, and can be used to
587      * e.g. implement automatic token fees, slashing mechanisms, etc.
588      *
589      * Emits a {Transfer} event.
590      *
591      * Requirements:
592      *
593      * - `sender` cannot be the zero address.
594      * - `recipient` cannot be the zero address.
595      * - `sender` must have a balance of at least `amount`.
596      */
597     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600 
601         _beforeTokenTransfer(sender, recipient, amount);
602 
603         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
604         _balances[recipient] = _balances[recipient].add(amount);
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
609      * the total supply.
610      *
611      * Emits a {Transfer} event with `from` set to the zero address.
612      *
613      * Requirements:
614      *
615      * - `to` cannot be the zero address.
616      */
617     function _mint(address account, uint256 amount) internal virtual {
618         require(account != address(0), "ERC20: mint to the zero address");
619 
620         _beforeTokenTransfer(address(0), account, amount);
621 
622         _totalSupply = _totalSupply.add(amount);
623         _balances[account] = _balances[account].add(amount);
624         emit Transfer(address(0), account, amount);
625     }
626 
627     /**
628      * @dev Destroys `amount` tokens from `account`, reducing the
629      * total supply.
630      *
631      * Emits a {Transfer} event with `to` set to the zero address.
632      *
633      * Requirements:
634      *
635      * - `account` cannot be the zero address.
636      * - `account` must have at least `amount` tokens.
637      */
638     function _burn(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: burn from the zero address");
640 
641         _beforeTokenTransfer(account, address(0), amount);
642 
643         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
644         _totalSupply = _totalSupply.sub(amount);
645         emit Transfer(account, address(0), amount);
646     }
647 
648     /**
649      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
650      *
651      * This internal function is equivalent to `approve`, and can be used to
652      * e.g. set automatic allowances for certain subsystems, etc.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `owner` cannot be the zero address.
659      * - `spender` cannot be the zero address.
660      */
661     function _approve(address owner, address spender, uint256 amount) internal virtual {
662         require(owner != address(0), "ERC20: approve from the zero address");
663         require(spender != address(0), "ERC20: approve to the zero address");
664 
665         _allowances[owner][spender] = amount;
666         emit Approval(owner, spender, amount);
667     }
668 
669     /**
670      * @dev Sets {decimals} to a value other than the default one of 18.
671      *
672      * WARNING: This function should only be called from the constructor. Most
673      * applications that interact with token contracts will not expect
674      * {decimals} to ever change, and may work incorrectly if it does.
675      */
676     function _setupDecimals(uint8 decimals_) internal {
677         _decimals = decimals_;
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be to transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
695 }
696 
697 // SPDX-License-Identifier: MIT
698 /**
699  * @title Staking interface, as defined by EIP-900.
700  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
701  */
702 interface IStaking {
703     event Staked(
704         address indexed user,
705         uint256 amount,
706         uint256 total,
707         bytes data
708     );
709     event Unstaked(
710         address indexed user,
711         uint256 amount,
712         uint256 total,
713         bytes data
714     );
715 
716     function unstake(address staker, uint256 amount, bytes calldata data) external;
717 
718     function totalStakedFor(address addr) external view returns (uint256);
719 
720     function totalStaked() external view returns (uint256);
721 
722     function token() external view returns (address);
723 
724     function supportsHistory() external pure returns (bool);
725 }
726 
727 // SPDX-License-Identifier: MIT
728 /**
729  * @title Staking interface, as defined by EIP-900.
730  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
731  */
732 interface IStakeWithNFT {
733     function stake(
734         address staker,
735         uint256 amount,
736         bytes calldata data,
737         int256 nftId
738     ) external;
739 
740     function stakeFor(
741         address staker,
742         address user,
743         uint256 amount,
744         bytes calldata data,
745         int256 nftId
746     ) external;
747 }
748 
749 // SPDX-License-Identifier: MIT
750 /**
751  * @title A simple holder of tokens.
752  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
753  * needs to hold multiple distinct pools of the same token.
754  */
755 contract TokenPool is Ownable {
756     IERC20 public token;
757     bool private _isTokenRescuable;
758 
759     constructor(IERC20 _token) public {
760         token = _token;
761         _isTokenRescuable = false;
762     }
763 
764     function balance() public view returns (uint256) {
765         return token.balanceOf(address(this));
766     }
767 
768     function setRescuable(bool rescuable) public onlyOwner {
769         _isTokenRescuable = rescuable;
770     }
771 
772     function transfer(address to, uint256 value)
773         external
774         onlyOwner
775         returns (bool)
776     {
777         return token.transfer(to, value);
778     }
779 
780     function rescueFunds(
781         address tokenToRescue,
782         address to,
783         uint256 amount
784     ) external onlyOwner returns (bool) {
785         if (!_isTokenRescuable) {
786             require(
787                 address(token) != tokenToRescue,
788                 "TokenPool: Cannot claim token held by the contract"
789             );
790         }
791 
792         return IERC20(tokenToRescue).transfer(to, amount);
793     }
794 }
795 
796 // SPDX-License-Identifier: MIT
797 /**
798  * @dev Interface of the ERC165 standard, as defined in the
799  * https://eips.ethereum.org/EIPS/eip-165[EIP].
800  *
801  * Implementers can declare support of contract interfaces, which can then be
802  * queried by others ({ERC165Checker}).
803  *
804  * For an implementation, see {ERC165}.
805  */
806 interface IERC165 {
807     /**
808      * @dev Returns true if this contract implements the interface defined by
809      * `interfaceId`. See the corresponding
810      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
811      * to learn more about how these ids are created.
812      *
813      * This function call must use less than 30 000 gas.
814      */
815     function supportsInterface(bytes4 interfaceId) external view returns (bool);
816 }
817 
818 // SPDX-License-Identifier: MIT
819 /**
820  * @dev Required interface of an ERC721 compliant contract.
821  */
822 interface IERC721 is IERC165 {
823     /**
824      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
825      */
826     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
827 
828     /**
829      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
830      */
831     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
832 
833     /**
834      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
835      */
836     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
837 
838     /**
839      * @dev Returns the number of tokens in ``owner``'s account.
840      */
841     function balanceOf(address owner) external view returns (uint256 balance);
842 
843     /**
844      * @dev Returns the owner of the `tokenId` token.
845      *
846      * Requirements:
847      *
848      * - `tokenId` must exist.
849      */
850     function ownerOf(uint256 tokenId) external view returns (address owner);
851 
852     /**
853      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
854      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
855      *
856      * Requirements:
857      *
858      * - `from` cannot be the zero address.
859      * - `to` cannot be the zero address.
860      * - `tokenId` token must exist and be owned by `from`.
861      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
862      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
863      *
864      * Emits a {Transfer} event.
865      */
866     function safeTransferFrom(address from, address to, uint256 tokenId) external;
867 
868     /**
869      * @dev Transfers `tokenId` token from `from` to `to`.
870      *
871      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must be owned by `from`.
878      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
879      *
880      * Emits a {Transfer} event.
881      */
882     function transferFrom(address from, address to, uint256 tokenId) external;
883 
884     /**
885      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
886      * The approval is cleared when the token is transferred.
887      *
888      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
889      *
890      * Requirements:
891      *
892      * - The caller must own the token or be an approved operator.
893      * - `tokenId` must exist.
894      *
895      * Emits an {Approval} event.
896      */
897     function approve(address to, uint256 tokenId) external;
898 
899     /**
900      * @dev Returns the account approved for `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function getApproved(uint256 tokenId) external view returns (address operator);
907 
908     /**
909      * @dev Approve or remove `operator` as an operator for the caller.
910      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
911      *
912      * Requirements:
913      *
914      * - The `operator` cannot be the caller.
915      *
916      * Emits an {ApprovalForAll} event.
917      */
918     function setApprovalForAll(address operator, bool _approved) external;
919 
920     /**
921      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
922      *
923      * See {setApprovalForAll}
924      */
925     function isApprovedForAll(address owner, address operator) external view returns (bool);
926 
927     /**
928       * @dev Safely transfers `tokenId` token from `from` to `to`.
929       *
930       * Requirements:
931       *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934       * - `tokenId` token must exist and be owned by `from`.
935       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
936       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
937       *
938       * Emits a {Transfer} event.
939       */
940     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
941 }
942 
943 // SPDX-License-Identifier: MIT
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Metadata is IERC721 {
949 
950     /**
951      * @dev Returns the token collection name.
952      */
953     function name() external view returns (string memory);
954 
955     /**
956      * @dev Returns the token collection symbol.
957      */
958     function symbol() external view returns (string memory);
959 
960     /**
961      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
962      */
963     function tokenURI(uint256 tokenId) external view returns (string memory);
964 }
965 
966 // SPDX-License-Identifier: MIT
967 /**
968  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
969  * @dev See https://eips.ethereum.org/EIPS/eip-721
970  */
971 interface IERC721Enumerable is IERC721 {
972 
973     /**
974      * @dev Returns the total amount of tokens stored by the contract.
975      */
976     function totalSupply() external view returns (uint256);
977 
978     /**
979      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
980      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
981      */
982     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
983 
984     /**
985      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
986      * Use along with {totalSupply} to enumerate all tokens.
987      */
988     function tokenByIndex(uint256 index) external view returns (uint256);
989 }
990 
991 // SPDX-License-Identifier: MIT
992 /**
993  * @title ERC721 token receiver interface
994  * @dev Interface for any contract that wants to support safeTransfers
995  * from ERC721 asset contracts.
996  */
997 interface IERC721Receiver {
998     /**
999      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1000      * by `operator` from `from`, this function is called.
1001      *
1002      * It must return its Solidity selector to confirm the token transfer.
1003      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1004      *
1005      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1006      */
1007     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
1008 }
1009 
1010 // SPDX-License-Identifier: MIT
1011 /**
1012  * @dev Implementation of the {IERC165} interface.
1013  *
1014  * Contracts may inherit from this and call {_registerInterface} to declare
1015  * their support of an interface.
1016  */
1017 abstract contract ERC165 is IERC165 {
1018     /*
1019      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1020      */
1021     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1022 
1023     /**
1024      * @dev Mapping of interface ids to whether or not it's supported.
1025      */
1026     mapping(bytes4 => bool) private _supportedInterfaces;
1027 
1028     constructor () internal {
1029         // Derived contracts need only register support for their own interfaces,
1030         // we register support for ERC165 itself here
1031         _registerInterface(_INTERFACE_ID_ERC165);
1032     }
1033 
1034     /**
1035      * @dev See {IERC165-supportsInterface}.
1036      *
1037      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1038      */
1039     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1040         return _supportedInterfaces[interfaceId];
1041     }
1042 
1043     /**
1044      * @dev Registers the contract as an implementer of the interface defined by
1045      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1046      * registering its interface id is not required.
1047      *
1048      * See {IERC165-supportsInterface}.
1049      *
1050      * Requirements:
1051      *
1052      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1053      */
1054     function _registerInterface(bytes4 interfaceId) internal virtual {
1055         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1056         _supportedInterfaces[interfaceId] = true;
1057     }
1058 }
1059 
1060 // SPDX-License-Identifier: MIT
1061 /**
1062  * @dev Collection of functions related to the address type
1063  */
1064 library Address {
1065     /**
1066      * @dev Returns true if `account` is a contract.
1067      *
1068      * [IMPORTANT]
1069      * ====
1070      * It is unsafe to assume that an address for which this function returns
1071      * false is an externally-owned account (EOA) and not a contract.
1072      *
1073      * Among others, `isContract` will return false for the following
1074      * types of addresses:
1075      *
1076      *  - an externally-owned account
1077      *  - a contract in construction
1078      *  - an address where a contract will be created
1079      *  - an address where a contract lived, but was destroyed
1080      * ====
1081      */
1082     function isContract(address account) internal view returns (bool) {
1083         // This method relies on extcodesize, which returns 0 for contracts in
1084         // construction, since the code is only stored at the end of the
1085         // constructor execution.
1086 
1087         uint256 size;
1088         // solhint-disable-next-line no-inline-assembly
1089         assembly { size := extcodesize(account) }
1090         return size > 0;
1091     }
1092 
1093     /**
1094      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1095      * `recipient`, forwarding all available gas and reverting on errors.
1096      *
1097      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1098      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1099      * imposed by `transfer`, making them unable to receive funds via
1100      * `transfer`. {sendValue} removes this limitation.
1101      *
1102      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1103      *
1104      * IMPORTANT: because control is transferred to `recipient`, care must be
1105      * taken to not create reentrancy vulnerabilities. Consider using
1106      * {ReentrancyGuard} or the
1107      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1108      */
1109     function sendValue(address payable recipient, uint256 amount) internal {
1110         require(address(this).balance >= amount, "Address: insufficient balance");
1111 
1112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1113         (bool success, ) = recipient.call{ value: amount }("");
1114         require(success, "Address: unable to send value, recipient may have reverted");
1115     }
1116 
1117     /**
1118      * @dev Performs a Solidity function call using a low level `call`. A
1119      * plain`call` is an unsafe replacement for a function call: use this
1120      * function instead.
1121      *
1122      * If `target` reverts with a revert reason, it is bubbled up by this
1123      * function (like regular Solidity function calls).
1124      *
1125      * Returns the raw returned data. To convert to the expected return value,
1126      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1127      *
1128      * Requirements:
1129      *
1130      * - `target` must be a contract.
1131      * - calling `target` with `data` must not revert.
1132      *
1133      * _Available since v3.1._
1134      */
1135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1136       return functionCall(target, data, "Address: low-level call failed");
1137     }
1138 
1139     /**
1140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1141      * `errorMessage` as a fallback revert reason when `target` reverts.
1142      *
1143      * _Available since v3.1._
1144      */
1145     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1146         return functionCallWithValue(target, data, 0, errorMessage);
1147     }
1148 
1149     /**
1150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1151      * but also transferring `value` wei to `target`.
1152      *
1153      * Requirements:
1154      *
1155      * - the calling contract must have an ETH balance of at least `value`.
1156      * - the called Solidity function must be `payable`.
1157      *
1158      * _Available since v3.1._
1159      */
1160     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1161         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1166      * with `errorMessage` as a fallback revert reason when `target` reverts.
1167      *
1168      * _Available since v3.1._
1169      */
1170     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1171         require(address(this).balance >= value, "Address: insufficient balance for call");
1172         require(isContract(target), "Address: call to non-contract");
1173 
1174         // solhint-disable-next-line avoid-low-level-calls
1175         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1176         return _verifyCallResult(success, returndata, errorMessage);
1177     }
1178 
1179     /**
1180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1181      * but performing a static call.
1182      *
1183      * _Available since v3.3._
1184      */
1185     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1186         return functionStaticCall(target, data, "Address: low-level static call failed");
1187     }
1188 
1189     /**
1190      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1191      * but performing a static call.
1192      *
1193      * _Available since v3.3._
1194      */
1195     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1196         require(isContract(target), "Address: static call to non-contract");
1197 
1198         // solhint-disable-next-line avoid-low-level-calls
1199         (bool success, bytes memory returndata) = target.staticcall(data);
1200         return _verifyCallResult(success, returndata, errorMessage);
1201     }
1202 
1203     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1204         if (success) {
1205             return returndata;
1206         } else {
1207             // Look for revert reason and bubble it up if present
1208             if (returndata.length > 0) {
1209                 // The easiest way to bubble the revert reason is using memory via assembly
1210 
1211                 // solhint-disable-next-line no-inline-assembly
1212                 assembly {
1213                     let returndata_size := mload(returndata)
1214                     revert(add(32, returndata), returndata_size)
1215                 }
1216             } else {
1217                 revert(errorMessage);
1218             }
1219         }
1220     }
1221 }
1222 
1223 // SPDX-License-Identifier: MIT
1224 /**
1225  * @dev Library for managing
1226  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1227  * types.
1228  *
1229  * Sets have the following properties:
1230  *
1231  * - Elements are added, removed, and checked for existence in constant time
1232  * (O(1)).
1233  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1234  *
1235  * ```
1236  * contract Example {
1237  *     // Add the library methods
1238  *     using EnumerableSet for EnumerableSet.AddressSet;
1239  *
1240  *     // Declare a set state variable
1241  *     EnumerableSet.AddressSet private mySet;
1242  * }
1243  * ```
1244  *
1245  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1246  * and `uint256` (`UintSet`) are supported.
1247  */
1248 library EnumerableSet {
1249     // To implement this library for multiple types with as little code
1250     // repetition as possible, we write it in terms of a generic Set type with
1251     // bytes32 values.
1252     // The Set implementation uses private functions, and user-facing
1253     // implementations (such as AddressSet) are just wrappers around the
1254     // underlying Set.
1255     // This means that we can only create new EnumerableSets for types that fit
1256     // in bytes32.
1257 
1258     struct Set {
1259         // Storage of set values
1260         bytes32[] _values;
1261 
1262         // Position of the value in the `values` array, plus 1 because index 0
1263         // means a value is not in the set.
1264         mapping (bytes32 => uint256) _indexes;
1265     }
1266 
1267     /**
1268      * @dev Add a value to a set. O(1).
1269      *
1270      * Returns true if the value was added to the set, that is if it was not
1271      * already present.
1272      */
1273     function _add(Set storage set, bytes32 value) private returns (bool) {
1274         if (!_contains(set, value)) {
1275             set._values.push(value);
1276             // The value is stored at length-1, but we add 1 to all indexes
1277             // and use 0 as a sentinel value
1278             set._indexes[value] = set._values.length;
1279             return true;
1280         } else {
1281             return false;
1282         }
1283     }
1284 
1285     /**
1286      * @dev Removes a value from a set. O(1).
1287      *
1288      * Returns true if the value was removed from the set, that is if it was
1289      * present.
1290      */
1291     function _remove(Set storage set, bytes32 value) private returns (bool) {
1292         // We read and store the value's index to prevent multiple reads from the same storage slot
1293         uint256 valueIndex = set._indexes[value];
1294 
1295         if (valueIndex != 0) { // Equivalent to contains(set, value)
1296             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1297             // the array, and then remove the last element (sometimes called as 'swap and pop').
1298             // This modifies the order of the array, as noted in {at}.
1299 
1300             uint256 toDeleteIndex = valueIndex - 1;
1301             uint256 lastIndex = set._values.length - 1;
1302 
1303             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1304             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1305 
1306             bytes32 lastvalue = set._values[lastIndex];
1307 
1308             // Move the last value to the index where the value to delete is
1309             set._values[toDeleteIndex] = lastvalue;
1310             // Update the index for the moved value
1311             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1312 
1313             // Delete the slot where the moved value was stored
1314             set._values.pop();
1315 
1316             // Delete the index for the deleted slot
1317             delete set._indexes[value];
1318 
1319             return true;
1320         } else {
1321             return false;
1322         }
1323     }
1324 
1325     /**
1326      * @dev Returns true if the value is in the set. O(1).
1327      */
1328     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1329         return set._indexes[value] != 0;
1330     }
1331 
1332     /**
1333      * @dev Returns the number of values on the set. O(1).
1334      */
1335     function _length(Set storage set) private view returns (uint256) {
1336         return set._values.length;
1337     }
1338 
1339    /**
1340     * @dev Returns the value stored at position `index` in the set. O(1).
1341     *
1342     * Note that there are no guarantees on the ordering of values inside the
1343     * array, and it may change when more values are added or removed.
1344     *
1345     * Requirements:
1346     *
1347     * - `index` must be strictly less than {length}.
1348     */
1349     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1350         require(set._values.length > index, "EnumerableSet: index out of bounds");
1351         return set._values[index];
1352     }
1353 
1354     // Bytes32Set
1355 
1356     struct Bytes32Set {
1357         Set _inner;
1358     }
1359 
1360     /**
1361      * @dev Add a value to a set. O(1).
1362      *
1363      * Returns true if the value was added to the set, that is if it was not
1364      * already present.
1365      */
1366     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1367         return _add(set._inner, value);
1368     }
1369 
1370     /**
1371      * @dev Removes a value from a set. O(1).
1372      *
1373      * Returns true if the value was removed from the set, that is if it was
1374      * present.
1375      */
1376     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1377         return _remove(set._inner, value);
1378     }
1379 
1380     /**
1381      * @dev Returns true if the value is in the set. O(1).
1382      */
1383     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1384         return _contains(set._inner, value);
1385     }
1386 
1387     /**
1388      * @dev Returns the number of values in the set. O(1).
1389      */
1390     function length(Bytes32Set storage set) internal view returns (uint256) {
1391         return _length(set._inner);
1392     }
1393 
1394    /**
1395     * @dev Returns the value stored at position `index` in the set. O(1).
1396     *
1397     * Note that there are no guarantees on the ordering of values inside the
1398     * array, and it may change when more values are added or removed.
1399     *
1400     * Requirements:
1401     *
1402     * - `index` must be strictly less than {length}.
1403     */
1404     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1405         return _at(set._inner, index);
1406     }
1407 
1408     // AddressSet
1409 
1410     struct AddressSet {
1411         Set _inner;
1412     }
1413 
1414     /**
1415      * @dev Add a value to a set. O(1).
1416      *
1417      * Returns true if the value was added to the set, that is if it was not
1418      * already present.
1419      */
1420     function add(AddressSet storage set, address value) internal returns (bool) {
1421         return _add(set._inner, bytes32(uint256(value)));
1422     }
1423 
1424     /**
1425      * @dev Removes a value from a set. O(1).
1426      *
1427      * Returns true if the value was removed from the set, that is if it was
1428      * present.
1429      */
1430     function remove(AddressSet storage set, address value) internal returns (bool) {
1431         return _remove(set._inner, bytes32(uint256(value)));
1432     }
1433 
1434     /**
1435      * @dev Returns true if the value is in the set. O(1).
1436      */
1437     function contains(AddressSet storage set, address value) internal view returns (bool) {
1438         return _contains(set._inner, bytes32(uint256(value)));
1439     }
1440 
1441     /**
1442      * @dev Returns the number of values in the set. O(1).
1443      */
1444     function length(AddressSet storage set) internal view returns (uint256) {
1445         return _length(set._inner);
1446     }
1447 
1448    /**
1449     * @dev Returns the value stored at position `index` in the set. O(1).
1450     *
1451     * Note that there are no guarantees on the ordering of values inside the
1452     * array, and it may change when more values are added or removed.
1453     *
1454     * Requirements:
1455     *
1456     * - `index` must be strictly less than {length}.
1457     */
1458     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1459         return address(uint256(_at(set._inner, index)));
1460     }
1461 
1462 
1463     // UintSet
1464 
1465     struct UintSet {
1466         Set _inner;
1467     }
1468 
1469     /**
1470      * @dev Add a value to a set. O(1).
1471      *
1472      * Returns true if the value was added to the set, that is if it was not
1473      * already present.
1474      */
1475     function add(UintSet storage set, uint256 value) internal returns (bool) {
1476         return _add(set._inner, bytes32(value));
1477     }
1478 
1479     /**
1480      * @dev Removes a value from a set. O(1).
1481      *
1482      * Returns true if the value was removed from the set, that is if it was
1483      * present.
1484      */
1485     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1486         return _remove(set._inner, bytes32(value));
1487     }
1488 
1489     /**
1490      * @dev Returns true if the value is in the set. O(1).
1491      */
1492     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1493         return _contains(set._inner, bytes32(value));
1494     }
1495 
1496     /**
1497      * @dev Returns the number of values on the set. O(1).
1498      */
1499     function length(UintSet storage set) internal view returns (uint256) {
1500         return _length(set._inner);
1501     }
1502 
1503    /**
1504     * @dev Returns the value stored at position `index` in the set. O(1).
1505     *
1506     * Note that there are no guarantees on the ordering of values inside the
1507     * array, and it may change when more values are added or removed.
1508     *
1509     * Requirements:
1510     *
1511     * - `index` must be strictly less than {length}.
1512     */
1513     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1514         return uint256(_at(set._inner, index));
1515     }
1516 }
1517 
1518 // SPDX-License-Identifier: MIT
1519 /**
1520  * @dev Library for managing an enumerable variant of Solidity's
1521  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1522  * type.
1523  *
1524  * Maps have the following properties:
1525  *
1526  * - Entries are added, removed, and checked for existence in constant time
1527  * (O(1)).
1528  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1529  *
1530  * ```
1531  * contract Example {
1532  *     // Add the library methods
1533  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1534  *
1535  *     // Declare a set state variable
1536  *     EnumerableMap.UintToAddressMap private myMap;
1537  * }
1538  * ```
1539  *
1540  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1541  * supported.
1542  */
1543 library EnumerableMap {
1544     // To implement this library for multiple types with as little code
1545     // repetition as possible, we write it in terms of a generic Map type with
1546     // bytes32 keys and values.
1547     // The Map implementation uses private functions, and user-facing
1548     // implementations (such as Uint256ToAddressMap) are just wrappers around
1549     // the underlying Map.
1550     // This means that we can only create new EnumerableMaps for types that fit
1551     // in bytes32.
1552 
1553     struct MapEntry {
1554         bytes32 _key;
1555         bytes32 _value;
1556     }
1557 
1558     struct Map {
1559         // Storage of map keys and values
1560         MapEntry[] _entries;
1561 
1562         // Position of the entry defined by a key in the `entries` array, plus 1
1563         // because index 0 means a key is not in the map.
1564         mapping (bytes32 => uint256) _indexes;
1565     }
1566 
1567     /**
1568      * @dev Adds a key-value pair to a map, or updates the value for an existing
1569      * key. O(1).
1570      *
1571      * Returns true if the key was added to the map, that is if it was not
1572      * already present.
1573      */
1574     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1575         // We read and store the key's index to prevent multiple reads from the same storage slot
1576         uint256 keyIndex = map._indexes[key];
1577 
1578         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1579             map._entries.push(MapEntry({ _key: key, _value: value }));
1580             // The entry is stored at length-1, but we add 1 to all indexes
1581             // and use 0 as a sentinel value
1582             map._indexes[key] = map._entries.length;
1583             return true;
1584         } else {
1585             map._entries[keyIndex - 1]._value = value;
1586             return false;
1587         }
1588     }
1589 
1590     /**
1591      * @dev Removes a key-value pair from a map. O(1).
1592      *
1593      * Returns true if the key was removed from the map, that is if it was present.
1594      */
1595     function _remove(Map storage map, bytes32 key) private returns (bool) {
1596         // We read and store the key's index to prevent multiple reads from the same storage slot
1597         uint256 keyIndex = map._indexes[key];
1598 
1599         if (keyIndex != 0) { // Equivalent to contains(map, key)
1600             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1601             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1602             // This modifies the order of the array, as noted in {at}.
1603 
1604             uint256 toDeleteIndex = keyIndex - 1;
1605             uint256 lastIndex = map._entries.length - 1;
1606 
1607             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1608             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1609 
1610             MapEntry storage lastEntry = map._entries[lastIndex];
1611 
1612             // Move the last entry to the index where the entry to delete is
1613             map._entries[toDeleteIndex] = lastEntry;
1614             // Update the index for the moved entry
1615             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1616 
1617             // Delete the slot where the moved entry was stored
1618             map._entries.pop();
1619 
1620             // Delete the index for the deleted slot
1621             delete map._indexes[key];
1622 
1623             return true;
1624         } else {
1625             return false;
1626         }
1627     }
1628 
1629     /**
1630      * @dev Returns true if the key is in the map. O(1).
1631      */
1632     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1633         return map._indexes[key] != 0;
1634     }
1635 
1636     /**
1637      * @dev Returns the number of key-value pairs in the map. O(1).
1638      */
1639     function _length(Map storage map) private view returns (uint256) {
1640         return map._entries.length;
1641     }
1642 
1643    /**
1644     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1645     *
1646     * Note that there are no guarantees on the ordering of entries inside the
1647     * array, and it may change when more entries are added or removed.
1648     *
1649     * Requirements:
1650     *
1651     * - `index` must be strictly less than {length}.
1652     */
1653     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1654         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1655 
1656         MapEntry storage entry = map._entries[index];
1657         return (entry._key, entry._value);
1658     }
1659 
1660     /**
1661      * @dev Returns the value associated with `key`.  O(1).
1662      *
1663      * Requirements:
1664      *
1665      * - `key` must be in the map.
1666      */
1667     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1668         return _get(map, key, "EnumerableMap: nonexistent key");
1669     }
1670 
1671     /**
1672      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1673      */
1674     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1675         uint256 keyIndex = map._indexes[key];
1676         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1677         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1678     }
1679 
1680     // UintToAddressMap
1681 
1682     struct UintToAddressMap {
1683         Map _inner;
1684     }
1685 
1686     /**
1687      * @dev Adds a key-value pair to a map, or updates the value for an existing
1688      * key. O(1).
1689      *
1690      * Returns true if the key was added to the map, that is if it was not
1691      * already present.
1692      */
1693     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1694         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1695     }
1696 
1697     /**
1698      * @dev Removes a value from a set. O(1).
1699      *
1700      * Returns true if the key was removed from the map, that is if it was present.
1701      */
1702     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1703         return _remove(map._inner, bytes32(key));
1704     }
1705 
1706     /**
1707      * @dev Returns true if the key is in the map. O(1).
1708      */
1709     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1710         return _contains(map._inner, bytes32(key));
1711     }
1712 
1713     /**
1714      * @dev Returns the number of elements in the map. O(1).
1715      */
1716     function length(UintToAddressMap storage map) internal view returns (uint256) {
1717         return _length(map._inner);
1718     }
1719 
1720    /**
1721     * @dev Returns the element stored at position `index` in the set. O(1).
1722     * Note that there are no guarantees on the ordering of values inside the
1723     * array, and it may change when more values are added or removed.
1724     *
1725     * Requirements:
1726     *
1727     * - `index` must be strictly less than {length}.
1728     */
1729     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1730         (bytes32 key, bytes32 value) = _at(map._inner, index);
1731         return (uint256(key), address(uint256(value)));
1732     }
1733 
1734     /**
1735      * @dev Returns the value associated with `key`.  O(1).
1736      *
1737      * Requirements:
1738      *
1739      * - `key` must be in the map.
1740      */
1741     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1742         return address(uint256(_get(map._inner, bytes32(key))));
1743     }
1744 
1745     /**
1746      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1747      */
1748     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1749         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1750     }
1751 }
1752 
1753 // SPDX-License-Identifier: MIT
1754 /**
1755  * @dev String operations.
1756  */
1757 library Strings {
1758     /**
1759      * @dev Converts a `uint256` to its ASCII `string` representation.
1760      */
1761     function toString(uint256 value) internal pure returns (string memory) {
1762         // Inspired by OraclizeAPI's implementation - MIT licence
1763         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1764 
1765         if (value == 0) {
1766             return "0";
1767         }
1768         uint256 temp = value;
1769         uint256 digits;
1770         while (temp != 0) {
1771             digits++;
1772             temp /= 10;
1773         }
1774         bytes memory buffer = new bytes(digits);
1775         uint256 index = digits - 1;
1776         temp = value;
1777         while (temp != 0) {
1778             buffer[index--] = byte(uint8(48 + temp % 10));
1779             temp /= 10;
1780         }
1781         return string(buffer);
1782     }
1783 }
1784 
1785 // SPDX-License-Identifier: MIT
1786 /**
1787  * @title ERC721 Non-Fungible Token Standard basic implementation
1788  * @dev see https://eips.ethereum.org/EIPS/eip-721
1789  */
1790 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1791     using SafeMath for uint256;
1792     using Address for address;
1793     using EnumerableSet for EnumerableSet.UintSet;
1794     using EnumerableMap for EnumerableMap.UintToAddressMap;
1795     using Strings for uint256;
1796 
1797     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1798     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1799     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1800 
1801     // Mapping from holder address to their (enumerable) set of owned tokens
1802     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1803 
1804     // Enumerable mapping from token ids to their owners
1805     EnumerableMap.UintToAddressMap private _tokenOwners;
1806 
1807     // Mapping from token ID to approved address
1808     mapping (uint256 => address) private _tokenApprovals;
1809 
1810     // Mapping from owner to operator approvals
1811     mapping (address => mapping (address => bool)) private _operatorApprovals;
1812 
1813     // Token name
1814     string private _name;
1815 
1816     // Token symbol
1817     string private _symbol;
1818 
1819     // Optional mapping for token URIs
1820     mapping (uint256 => string) private _tokenURIs;
1821 
1822     // Base URI
1823     string private _baseURI;
1824 
1825     /*
1826      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1827      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1828      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1829      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1830      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1831      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1832      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1833      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1834      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1835      *
1836      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1837      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1838      */
1839     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1840 
1841     /*
1842      *     bytes4(keccak256('name()')) == 0x06fdde03
1843      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1844      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1845      *
1846      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1847      */
1848     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1849 
1850     /*
1851      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1852      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1853      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1854      *
1855      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1856      */
1857     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1858 
1859     /**
1860      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1861      */
1862     constructor (string memory name_, string memory symbol_) public {
1863         _name = name_;
1864         _symbol = symbol_;
1865 
1866         // register the supported interfaces to conform to ERC721 via ERC165
1867         _registerInterface(_INTERFACE_ID_ERC721);
1868         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1869         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1870     }
1871 
1872     /**
1873      * @dev See {IERC721-balanceOf}.
1874      */
1875     function balanceOf(address owner) public view override returns (uint256) {
1876         require(owner != address(0), "ERC721: balance query for the zero address");
1877 
1878         return _holderTokens[owner].length();
1879     }
1880 
1881     /**
1882      * @dev See {IERC721-ownerOf}.
1883      */
1884     function ownerOf(uint256 tokenId) public view override returns (address) {
1885         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1886     }
1887 
1888     /**
1889      * @dev See {IERC721Metadata-name}.
1890      */
1891     function name() public view override returns (string memory) {
1892         return _name;
1893     }
1894 
1895     /**
1896      * @dev See {IERC721Metadata-symbol}.
1897      */
1898     function symbol() public view override returns (string memory) {
1899         return _symbol;
1900     }
1901 
1902     /**
1903      * @dev See {IERC721Metadata-tokenURI}.
1904      */
1905     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1906         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1907 
1908         string memory _tokenURI = _tokenURIs[tokenId];
1909 
1910         // If there is no base URI, return the token URI.
1911         if (bytes(_baseURI).length == 0) {
1912             return _tokenURI;
1913         }
1914         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1915         if (bytes(_tokenURI).length > 0) {
1916             return string(abi.encodePacked(_baseURI, _tokenURI));
1917         }
1918         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1919         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1920     }
1921 
1922     /**
1923     * @dev Returns the base URI set via {_setBaseURI}. This will be
1924     * automatically added as a prefix in {tokenURI} to each token's URI, or
1925     * to the token ID if no specific URI is set for that token ID.
1926     */
1927     function baseURI() public view returns (string memory) {
1928         return _baseURI;
1929     }
1930 
1931     /**
1932      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1933      */
1934     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1935         return _holderTokens[owner].at(index);
1936     }
1937 
1938     /**
1939      * @dev See {IERC721Enumerable-totalSupply}.
1940      */
1941     function totalSupply() public view override returns (uint256) {
1942         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1943         return _tokenOwners.length();
1944     }
1945 
1946     /**
1947      * @dev See {IERC721Enumerable-tokenByIndex}.
1948      */
1949     function tokenByIndex(uint256 index) public view override returns (uint256) {
1950         (uint256 tokenId, ) = _tokenOwners.at(index);
1951         return tokenId;
1952     }
1953 
1954     /**
1955      * @dev See {IERC721-approve}.
1956      */
1957     function approve(address to, uint256 tokenId) public virtual override {
1958         address owner = ownerOf(tokenId);
1959         require(to != owner, "ERC721: approval to current owner");
1960 
1961         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1962             "ERC721: approve caller is not owner nor approved for all"
1963         );
1964 
1965         _approve(to, tokenId);
1966     }
1967 
1968     /**
1969      * @dev See {IERC721-getApproved}.
1970      */
1971     function getApproved(uint256 tokenId) public view override returns (address) {
1972         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1973 
1974         return _tokenApprovals[tokenId];
1975     }
1976 
1977     /**
1978      * @dev See {IERC721-setApprovalForAll}.
1979      */
1980     function setApprovalForAll(address operator, bool approved) public virtual override {
1981         require(operator != _msgSender(), "ERC721: approve to caller");
1982 
1983         _operatorApprovals[_msgSender()][operator] = approved;
1984         emit ApprovalForAll(_msgSender(), operator, approved);
1985     }
1986 
1987     /**
1988      * @dev See {IERC721-isApprovedForAll}.
1989      */
1990     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1991         return _operatorApprovals[owner][operator];
1992     }
1993 
1994     /**
1995      * @dev See {IERC721-transferFrom}.
1996      */
1997     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1998         //solhint-disable-next-line max-line-length
1999         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2000 
2001         _transfer(from, to, tokenId);
2002     }
2003 
2004     /**
2005      * @dev See {IERC721-safeTransferFrom}.
2006      */
2007     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
2008         safeTransferFrom(from, to, tokenId, "");
2009     }
2010 
2011     /**
2012      * @dev See {IERC721-safeTransferFrom}.
2013      */
2014     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
2015         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
2016         _safeTransfer(from, to, tokenId, _data);
2017     }
2018 
2019     /**
2020      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2021      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2022      *
2023      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2024      *
2025      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2026      * implement alternative mechanisms to perform token transfer, such as signature-based.
2027      *
2028      * Requirements:
2029      *
2030      * - `from` cannot be the zero address.
2031      * - `to` cannot be the zero address.
2032      * - `tokenId` token must exist and be owned by `from`.
2033      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2034      *
2035      * Emits a {Transfer} event.
2036      */
2037     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
2038         _transfer(from, to, tokenId);
2039         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2040     }
2041 
2042     /**
2043      * @dev Returns whether `tokenId` exists.
2044      *
2045      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2046      *
2047      * Tokens start existing when they are minted (`_mint`),
2048      * and stop existing when they are burned (`_burn`).
2049      */
2050     function _exists(uint256 tokenId) internal view returns (bool) {
2051         return _tokenOwners.contains(tokenId);
2052     }
2053 
2054     /**
2055      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2056      *
2057      * Requirements:
2058      *
2059      * - `tokenId` must exist.
2060      */
2061     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
2062         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2063         address owner = ownerOf(tokenId);
2064         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2065     }
2066 
2067     /**
2068      * @dev Safely mints `tokenId` and transfers it to `to`.
2069      *
2070      * Requirements:
2071      d*
2072      * - `tokenId` must not exist.
2073      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2074      *
2075      * Emits a {Transfer} event.
2076      */
2077     function _safeMint(address to, uint256 tokenId) internal virtual {
2078         _safeMint(to, tokenId, "");
2079     }
2080 
2081     /**
2082      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2083      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2084      */
2085     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
2086         _mint(to, tokenId);
2087         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
2088     }
2089 
2090     /**
2091      * @dev Mints `tokenId` and transfers it to `to`.
2092      *
2093      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2094      *
2095      * Requirements:
2096      *
2097      * - `tokenId` must not exist.
2098      * - `to` cannot be the zero address.
2099      *
2100      * Emits a {Transfer} event.
2101      */
2102     function _mint(address to, uint256 tokenId) internal virtual {
2103         require(to != address(0), "ERC721: mint to the zero address");
2104         require(!_exists(tokenId), "ERC721: token already minted");
2105 
2106         _beforeTokenTransfer(address(0), to, tokenId);
2107 
2108         _holderTokens[to].add(tokenId);
2109 
2110         _tokenOwners.set(tokenId, to);
2111 
2112         emit Transfer(address(0), to, tokenId);
2113     }
2114 
2115     /**
2116      * @dev Destroys `tokenId`.
2117      * The approval is cleared when the token is burned.
2118      *
2119      * Requirements:
2120      *
2121      * - `tokenId` must exist.
2122      *
2123      * Emits a {Transfer} event.
2124      */
2125     function _burn(uint256 tokenId) internal virtual {
2126         address owner = ownerOf(tokenId);
2127 
2128         _beforeTokenTransfer(owner, address(0), tokenId);
2129 
2130         // Clear approvals
2131         _approve(address(0), tokenId);
2132 
2133         // Clear metadata (if any)
2134         if (bytes(_tokenURIs[tokenId]).length != 0) {
2135             delete _tokenURIs[tokenId];
2136         }
2137 
2138         _holderTokens[owner].remove(tokenId);
2139 
2140         _tokenOwners.remove(tokenId);
2141 
2142         emit Transfer(owner, address(0), tokenId);
2143     }
2144 
2145     /**
2146      * @dev Transfers `tokenId` from `from` to `to`.
2147      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2148      *
2149      * Requirements:
2150      *
2151      * - `to` cannot be the zero address.
2152      * - `tokenId` token must be owned by `from`.
2153      *
2154      * Emits a {Transfer} event.
2155      */
2156     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2157         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
2158         require(to != address(0), "ERC721: transfer to the zero address");
2159 
2160         _beforeTokenTransfer(from, to, tokenId);
2161 
2162         // Clear approvals from the previous owner
2163         _approve(address(0), tokenId);
2164 
2165         _holderTokens[from].remove(tokenId);
2166         _holderTokens[to].add(tokenId);
2167 
2168         _tokenOwners.set(tokenId, to);
2169 
2170         emit Transfer(from, to, tokenId);
2171     }
2172 
2173     /**
2174      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2175      *
2176      * Requirements:
2177      *
2178      * - `tokenId` must exist.
2179      */
2180     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2181         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
2182         _tokenURIs[tokenId] = _tokenURI;
2183     }
2184 
2185     /**
2186      * @dev Internal function to set the base URI for all token IDs. It is
2187      * automatically added as a prefix to the value returned in {tokenURI},
2188      * or to the token ID if {tokenURI} is empty.
2189      */
2190     function _setBaseURI(string memory baseURI_) internal virtual {
2191         _baseURI = baseURI_;
2192     }
2193 
2194     /**
2195      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2196      * The call is not executed if the target address is not a contract.
2197      *
2198      * @param from address representing the previous owner of the given token ID
2199      * @param to target address that will receive the tokens
2200      * @param tokenId uint256 ID of the token to be transferred
2201      * @param _data bytes optional data to send along with the call
2202      * @return bool whether the call correctly returned the expected magic value
2203      */
2204     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
2205         private returns (bool)
2206     {
2207         if (!to.isContract()) {
2208             return true;
2209         }
2210         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
2211             IERC721Receiver(to).onERC721Received.selector,
2212             _msgSender(),
2213             from,
2214             tokenId,
2215             _data
2216         ), "ERC721: transfer to non ERC721Receiver implementer");
2217         bytes4 retval = abi.decode(returndata, (bytes4));
2218         return (retval == _ERC721_RECEIVED);
2219     }
2220 
2221     function _approve(address to, uint256 tokenId) private {
2222         _tokenApprovals[tokenId] = to;
2223         emit Approval(ownerOf(tokenId), to, tokenId);
2224     }
2225 
2226     /**
2227      * @dev Hook that is called before any token transfer. This includes minting
2228      * and burning.
2229      *
2230      * Calling conditions:
2231      *
2232      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2233      * transferred to `to`.
2234      * - When `from` is zero, `tokenId` will be minted for `to`.
2235      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2236      * - `from` cannot be the zero address.
2237      * - `to` cannot be the zero address.
2238      *
2239      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2240      */
2241     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
2242 }
2243 
2244 // SPDX-License-Identifier: MIT
2245 /**
2246  * @dev Contract module which allows children to implement an emergency stop
2247  * mechanism that can be triggered by an authorized account.
2248  *
2249  * This module is used through inheritance. It will make available the
2250  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2251  * the functions of your contract. Note that they will not be pausable by
2252  * simply including this module, only once the modifiers are put in place.
2253  */
2254 abstract contract Pausable is Context {
2255     /**
2256      * @dev Emitted when the pause is triggered by `account`.
2257      */
2258     event Paused(address account);
2259 
2260     /**
2261      * @dev Emitted when the pause is lifted by `account`.
2262      */
2263     event Unpaused(address account);
2264 
2265     bool private _paused;
2266 
2267     /**
2268      * @dev Initializes the contract in unpaused state.
2269      */
2270     constructor () internal {
2271         _paused = false;
2272     }
2273 
2274     /**
2275      * @dev Returns true if the contract is paused, and false otherwise.
2276      */
2277     function paused() public view returns (bool) {
2278         return _paused;
2279     }
2280 
2281     /**
2282      * @dev Modifier to make a function callable only when the contract is not paused.
2283      *
2284      * Requirements:
2285      *
2286      * - The contract must not be paused.
2287      */
2288     modifier whenNotPaused() {
2289         require(!_paused, "Pausable: paused");
2290         _;
2291     }
2292 
2293     /**
2294      * @dev Modifier to make a function callable only when the contract is paused.
2295      *
2296      * Requirements:
2297      *
2298      * - The contract must be paused.
2299      */
2300     modifier whenPaused() {
2301         require(_paused, "Pausable: not paused");
2302         _;
2303     }
2304 
2305     /**
2306      * @dev Triggers stopped state.
2307      *
2308      * Requirements:
2309      *
2310      * - The contract must not be paused.
2311      */
2312     function _pause() internal virtual whenNotPaused {
2313         _paused = true;
2314         emit Paused(_msgSender());
2315     }
2316 
2317     /**
2318      * @dev Returns to normal state.
2319      *
2320      * Requirements:
2321      *
2322      * - The contract must be paused.
2323      */
2324     function _unpause() internal virtual whenPaused {
2325         _paused = false;
2326         emit Unpaused(_msgSender());
2327     }
2328 }
2329 
2330 // SPDX-License-Identifier: MIT
2331 /**
2332  * @dev ERC721 token with pausable token transfers, minting and burning.
2333  *
2334  * Useful for scenarios such as preventing trades until the end of an evaluation
2335  * period, or having an emergency switch for freezing all token transfers in the
2336  * event of a large bug.
2337  */
2338 abstract contract ERC721Pausable is ERC721, Pausable {
2339     /**
2340      * @dev See {ERC721-_beforeTokenTransfer}.
2341      *
2342      * Requirements:
2343      *
2344      * - the contract must not be paused.
2345      */
2346     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
2347         super._beforeTokenTransfer(from, to, tokenId);
2348 
2349         require(!paused(), "ERC721Pausable: token transfer while paused");
2350     }
2351 }
2352 
2353 /*
2354     uint256 public constant socialNftIdentifier = uint256(1);
2355     uint256 public constant rareNftIdentifier = uint256(2);
2356     uint256 public constant epicNftIdentifier = uint256(4);
2357     uint256 public constant legendaryNftIdentifier = uint256(8);
2358 */
2359 contract WarpNFT is Ownable, ERC721Pausable {
2360     uint256 public idTracker;
2361 
2362     // converts id -> token type
2363     mapping(uint256 => uint256) public tokenType;
2364 
2365     /**
2366     @notice the constructor function is fired only once during contract deployment
2367     @dev assuming all NFT URI metadata is based on a URL he baseURI would be something like https://
2368     **/
2369     constructor() public ERC721("Warp Finance", "WNFT") {
2370         idTracker = 0;
2371     }
2372 
2373     /**
2374     @notice mintNewNFT allows the owner of this contract to mint an input address a newNFT
2375     @param _to is the address the NFT is being minted to
2376     **/
2377     function mintNewNFT(
2378         address _to,
2379         uint256 _type,
2380         string memory _tokenURI
2381     ) public onlyOwner {
2382         _safeMint(_to, idTracker);
2383         _setTokenURI(idTracker, _tokenURI);
2384         tokenType[idTracker] = _type;
2385         idTracker++;
2386     }
2387 
2388     function burn(uint256 tokenId) public onlyOwner {
2389         _burn(tokenId);
2390     }
2391 
2392     function setTokenURI(uint256 tokenId, string memory _tokenURI)
2393         public
2394         onlyOwner
2395     {
2396         _setTokenURI(tokenId, _tokenURI);
2397     }
2398 
2399     function setBaseURI(string memory baseURI_) public onlyOwner {
2400         _setBaseURI(baseURI_);
2401     }
2402 
2403     function pause() public onlyOwner {
2404         _pause();
2405     }
2406 
2407     function unpause() public onlyOwner {
2408         _unpause();
2409     }
2410 }
2411 
2412 // SPDX-License-Identifier: MIT
2413 /**
2414  * @title Token Geyser
2415  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
2416  *      Compound and Uniswap.
2417  *
2418  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
2419  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
2420  *      claimed by users.
2421  *
2422  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
2423  *      is a function of the number of tokens deposited as well as the length of time deposited.
2424  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
2425  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
2426  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
2427  *
2428  *      More background and motivation available at:
2429  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
2430  */
2431 contract TokenGeyser is IStaking, IStakeWithNFT, Ownable {
2432     using SafeMath for uint256;
2433 
2434     event Staked(
2435         address indexed user,
2436         uint256 amount,
2437         uint256 total,
2438         bytes data
2439     );
2440     event Unstaked(
2441         address indexed user,
2442         uint256 amount,
2443         uint256 total,
2444         bytes data
2445     );
2446     event TokensClaimed(address indexed user, uint256 amount);
2447     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
2448     // amount: Unlocked tokens, total: Total locked tokens
2449     event TokensUnlocked(uint256 amount, uint256 total);
2450 
2451     TokenPool private _stakingPool;
2452     TokenPool private _unlockedPool;
2453     TokenPool private _lockedPool;
2454 
2455     //
2456     // Time-bonus params
2457     //
2458     uint256 public bonusDecimals = 2;
2459     uint256 public startBonus = 0;
2460     uint256 public bonusPeriodSec = 0;
2461 
2462     //
2463     // Global accounting state
2464     //
2465     uint256 public totalLockedShares = 0;
2466     uint256 public totalStakingShares = 0;
2467     uint256 private _totalStakingShareSeconds = 0;
2468     uint256 private _lastAccountingTimestampSec = now;
2469     uint256 private _maxUnlockSchedules = 0;
2470     uint256 private _initialSharesPerToken = 0;
2471 
2472     //
2473     // User accounting state
2474     //
2475     // Represents a single stake for a user. A user may have multiple.
2476     struct Stake {
2477         uint256 stakingShares;
2478         uint256 timestampSec;
2479     }
2480 
2481     // Caches aggregated values from the User->Stake[] map to save computation.
2482     // If lastAccountingTimestampSec is 0, there's no entry for that user.
2483     struct UserTotals {
2484         uint256 stakingShares;
2485         uint256 stakingShareSeconds;
2486         uint256 lastAccountingTimestampSec;
2487     }
2488 
2489     // Aggregated staking values per user
2490     mapping(address => UserTotals) private _userTotals;
2491 
2492     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
2493     mapping(address => Stake[]) private _userStakes;
2494 
2495 
2496     //
2497     // Locked/Unlocked Accounting state
2498     //
2499     struct UnlockSchedule {
2500         uint256 initialLockedShares;
2501         uint256 unlockedShares;
2502         uint256 lastUnlockTimestampSec;
2503         uint256 endAtSec;
2504         uint256 durationSec;
2505     }
2506 
2507     UnlockSchedule[] public unlockSchedules;
2508 
2509     WarpNFT public _warpNFT;
2510     address public geyserManager;
2511     mapping(address => uint256) public originalAmounts;
2512     mapping(address => uint256) public extraAmounts;
2513     uint256 public totalExtra;
2514     mapping(address => uint256) userEarnings;
2515 
2516     /**
2517      * @param stakingToken The token users deposit as stake.
2518      * @param distributionToken The token users receive as they unstake.
2519      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
2520      * @param startBonus_ Starting time bonus
2521      *                    e.g. 25% means user gets 25% of max distribution tokens.
2522      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
2523      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
2524      * @param bonusDecimals_ The number of decimals for shares
2525      */
2526     constructor(
2527         IERC20 stakingToken,
2528         IERC20 distributionToken,
2529         uint256 maxUnlockSchedules,
2530         uint256 startBonus_,
2531         uint256 bonusPeriodSec_,
2532         uint256 initialSharesPerToken,
2533         uint256 bonusDecimals_,
2534         address warpNFT,
2535         address managerAddress
2536     ) public {
2537         // The start bonus must be some fraction of the max. (i.e. <= 100%)
2538         require(
2539             startBonus_ <= 10**bonusDecimals_,
2540             "TokenGeyser: start bonus too high"
2541         );
2542         // If no period is desired, instead set startBonus = 100%
2543         // and bonusPeriod to a small value like 1sec.
2544         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
2545         require(
2546             initialSharesPerToken > 0,
2547             "TokenGeyser: initialSharesPerToken is zero"
2548         );
2549 
2550         require(bonusDecimals_ > 0, "TokenGeyser: bonusDecimals_ is zero");
2551 
2552         _stakingPool = new TokenPool(stakingToken);
2553         _unlockedPool = new TokenPool(distributionToken);
2554         _lockedPool = new TokenPool(distributionToken);
2555         _unlockedPool.setRescuable(true);
2556 
2557         geyserManager = managerAddress;
2558         startBonus = startBonus_;
2559         bonusDecimals = bonusDecimals_;
2560         bonusPeriodSec = bonusPeriodSec_;
2561         _maxUnlockSchedules = maxUnlockSchedules;
2562         _initialSharesPerToken = initialSharesPerToken;
2563         _warpNFT = WarpNFT(warpNFT);
2564     }
2565 
2566     /**
2567      * @return Total earnings for a user
2568     */
2569     function getEarnings(address user) public view returns (uint256) {
2570         return userEarnings[user];
2571     }
2572 
2573     /**
2574      * @dev Rescue rewards
2575      */
2576     function rescueRewards(address user) external onlyOwner {
2577         require(totalUnlocked() > 0, "TokenGeyser: Nothing to rescue");
2578         require(
2579             _unlockedPool.transfer(user, _unlockedPool.balance()),
2580             "TokenGeyser: rescue rewards from rewards pool failed"
2581         );
2582     }
2583 
2584     /**
2585      * @return The token users deposit as stake.
2586      */
2587     function getStakingToken() public view returns (IERC20) {
2588         return _stakingPool.token();
2589     }
2590 
2591     /**
2592      * @return The token users receive as they unstake.
2593      */
2594     function getDistributionToken() public view returns (IERC20) {
2595         assert(_unlockedPool.token() == _lockedPool.token());
2596         return _unlockedPool.token();
2597     }
2598 
2599     /**
2600      * @dev Transfers amount of deposit tokens from the user.
2601      * @param amount Number of deposit tokens to stake.
2602      * @param data Not used.
2603      */
2604     function stake(
2605         address staker,
2606         uint256 amount,
2607         bytes calldata data,
2608         int256 nftId
2609     ) external override {
2610         require(
2611             geyserManager == msg.sender,
2612             "This method can be called by the geyser manager only"
2613         );
2614         _stakeFor(staker, staker, amount, nftId);
2615     }
2616 
2617     /**
2618      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
2619      * @param user User address who gains credit for this stake operation.
2620      * @param amount Number of deposit tokens to stake.
2621      * @param data Not used.
2622      */
2623     function stakeFor(
2624         address staker,
2625         address user,
2626         uint256 amount,
2627         bytes calldata data,
2628         int256 nftId
2629     ) external override onlyOwner {
2630         require(
2631             geyserManager == msg.sender,
2632             "This method can be called by the geyser manager only"
2633         );
2634         _stakeFor(staker, user, amount, nftId);
2635     }
2636 
2637     /**
2638      * @dev Retrieves the boost you get for a specific NFT
2639      * @param beneficiary The address who receives the bonus
2640      * @param amount The amount for which the bonus is calculated
2641      * @param nftId The NFT identifier
2642      */
2643     function getNftBoost(
2644         address beneficiary,
2645         uint256 amount,
2646         int256 nftId
2647     ) public view returns (uint256) {
2648         if (nftId < 0) return 0;
2649         if (_warpNFT.ownerOf(uint256(nftId)) != beneficiary) return 0;
2650 
2651         uint256 nftType = _warpNFT.tokenType(uint256(nftId));
2652         if (nftType == uint256(1)) return 0;
2653 
2654         // 1 | Social - no boost
2655         // 2 | Rare - 15% boost
2656         // 4 | Epic - 75% boost
2657         // 8 | Legendary - 150% boost
2658 
2659         uint256 bonus = 1;
2660 
2661         if (nftType == uint256(2)) {
2662             bonus = 15;
2663         }
2664         if (nftType == uint256(4)) {
2665             bonus = 75;
2666         }
2667         if (nftType == uint256(8)) {
2668             bonus = 150;
2669         }
2670 
2671         uint256 result = (amount * bonus) / 100;
2672         return result;
2673     }
2674 
2675     /**
2676      * @dev Private implementation of staking methods.
2677      * @param staker User address who deposits tokens to stake.
2678      * @param beneficiary User address who gains credit for this stake operation.
2679      * @param amount Number of deposit tokens to stake.
2680      */
2681     function _stakeFor(
2682         address staker,
2683         address beneficiary,
2684         uint256 amount,
2685         int256 nftId
2686     ) private {
2687         require(amount > 0, "TokenGeyser: stake amount is zero");
2688         require(
2689             beneficiary != address(0),
2690             "TokenGeyser: beneficiary is zero address"
2691         );
2692         require(
2693             totalStakingShares == 0 || totalStaked() > 0,
2694             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
2695         );
2696         uint256 sentAmount = 0;
2697         sentAmount += amount;
2698 
2699         uint256 extra = getNftBoost(beneficiary, amount, nftId);
2700         originalAmounts[beneficiary] += amount;
2701         extraAmounts[beneficiary] += extra;
2702         amount += extra;
2703         uint256 mintedStakingShares =
2704             (totalStakingShares > 0)
2705                 ? totalStakingShares.mul(amount).div(totalStaked())
2706                 : amount.mul(_initialSharesPerToken);
2707         totalExtra += extra;
2708 
2709         require(
2710             mintedStakingShares > 0,
2711             "TokenGeyser: Stake amount is too small"
2712         );
2713 
2714         updateAccounting(beneficiary);
2715 
2716         // 1. User Accounting
2717         UserTotals storage totals = _userTotals[beneficiary];
2718         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
2719         totals.lastAccountingTimestampSec = now;
2720 
2721         Stake memory newStake = Stake(mintedStakingShares, now);
2722         _userStakes[beneficiary].push(newStake);
2723 
2724         // 2. Global Accounting
2725         totalStakingShares = totalStakingShares.add(mintedStakingShares);
2726         // Already set in updateAccounting()
2727         // _lastAccountingTimestampSec = now;
2728 
2729         // interactions
2730         require(
2731             _stakingPool.token().transferFrom(
2732                 staker,
2733                 address(_stakingPool),
2734                 sentAmount
2735             ),
2736             "TokenGeyser: transfer into staking pool failed"
2737         );
2738 
2739         emit Staked(beneficiary, sentAmount, totalStakedFor(beneficiary), "");
2740     }
2741 
2742     /**
2743      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
2744      * alotted number of distribution tokens.
2745      * @param amount Number of deposit tokens to unstake / withdraw.
2746      * @param data Not used.
2747      */
2748     function unstake(address staker, uint256 amount, bytes calldata data) external override {
2749         require(
2750             geyserManager == msg.sender,
2751             "This method can be called by the geyser manager only"
2752         );
2753         _unstake(staker, amount);
2754     }
2755 
2756     /**
2757      * @param amount Number of deposit tokens to unstake / withdraw.
2758      * @return The total number of distribution tokens that would be rewarded.
2759      */
2760     function unstakeQuery(address staker, uint256 amount) public returns (uint256) {
2761         require(
2762             geyserManager == msg.sender,
2763             "This method can be called by the geyser manager only"
2764         );
2765         return _unstake(staker, amount);
2766     }
2767 
2768     /**
2769      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
2770      * alotted number of distribution tokens.
2771      * @param amount Number of deposit tokens to unstake / withdraw.
2772      * @return The total number of distribution tokens rewarded.
2773      */
2774     function _unstake(address user, uint256 amount) private returns (uint256) {
2775         updateAccounting(user);
2776 
2777         // checks
2778         require(amount == 0, "TokenGeyser: only full unstake is allowed");
2779 
2780         amount = originalAmounts[user] + extraAmounts[user];
2781         uint256 stakingSharesToBurn =
2782             totalStakingShares.mul(amount).div(totalStaked());
2783 
2784         require(
2785             stakingSharesToBurn > 0,
2786             "TokenGeyser: Unable to unstake amount this small"
2787         );
2788 
2789         // 1. User Accounting
2790         UserTotals storage totals = _userTotals[user];
2791         Stake[] storage accountStakes = _userStakes[user];
2792 
2793         // Redeem from most recent stake and go backwards in time.
2794         uint256 stakingShareSecondsToBurn = 0;
2795         uint256 sharesLeftToBurn = stakingSharesToBurn;
2796         uint256 rewardAmount = 0;
2797         while (sharesLeftToBurn > 0) {
2798             Stake storage lastStake = accountStakes[accountStakes.length - 1];
2799             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
2800             uint256 newStakingShareSecondsToBurn = 0;
2801 
2802             if (lastStake.stakingShares <= sharesLeftToBurn) {
2803                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
2804                     stakeTimeSec
2805                 );
2806                 rewardAmount = computeNewReward(
2807                     rewardAmount,
2808                     newStakingShareSecondsToBurn,
2809                     stakeTimeSec
2810                 );
2811 
2812                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
2813                     newStakingShareSecondsToBurn
2814                 );
2815                 sharesLeftToBurn = sharesLeftToBurn.sub(
2816                     lastStake.stakingShares
2817                 );
2818                 accountStakes.pop();
2819             } else {
2820                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
2821                     stakeTimeSec
2822                 );
2823                 rewardAmount = computeNewReward(
2824                     rewardAmount,
2825                     newStakingShareSecondsToBurn,
2826                     stakeTimeSec
2827                 );
2828                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
2829                     newStakingShareSecondsToBurn
2830                 );
2831                 lastStake.stakingShares = lastStake.stakingShares.sub(
2832                     sharesLeftToBurn
2833                 );
2834                 sharesLeftToBurn = 0;
2835             }
2836         }
2837         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
2838             stakingShareSecondsToBurn
2839         );
2840         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
2841         // Already set in updateAccounting
2842         // totals.lastAccountingTimestampSec = now;
2843 
2844         // 2. Global Accounting
2845         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
2846             stakingShareSecondsToBurn
2847         );
2848         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
2849         // Already set in updateAccounting
2850         // _lastAccountingTimestampSec = now;
2851 
2852         // interactions
2853         require(
2854             _stakingPool.transfer(user, originalAmounts[user]),
2855             "TokenGeyser: transfer out of staking pool failed"
2856         );
2857 
2858         //in case rescueRewards was called, there are no rewards to be transfered
2859         if (totalUnlocked() >= rewardAmount) {
2860             require(
2861                 _unlockedPool.transfer(user, rewardAmount),
2862                 "TokenGeyser: transfer out of unlocked pool failed"
2863             );
2864             emit TokensClaimed(user, rewardAmount);
2865 
2866             userEarnings[user] += rewardAmount;
2867         }
2868         
2869 
2870         emit Unstaked(user, amount, totalStakedFor(user), "");
2871 
2872         require(
2873             totalStakingShares == 0 || totalStaked() > 0,
2874             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
2875         );
2876 
2877         totalExtra -= extraAmounts[user];
2878         originalAmounts[user] = 0;
2879         extraAmounts[user] = 0;
2880 
2881         return rewardAmount;
2882     }
2883 
2884     /**
2885      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
2886      *      encourage long-term deposits instead of constant unstake/restakes.
2887      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
2888      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
2889      * @param currentRewardTokens The current number of distribution tokens already alotted for this
2890      *                            unstake op. Any bonuses are already applied.
2891      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
2892      *                            distribution tokens.
2893      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
2894      *                     the time-bonus.
2895      * @return Updated amount of distribution tokens to award, with any bonus included on the
2896      *         newly added tokens.
2897      */
2898     function computeNewReward(
2899         uint256 currentRewardTokens,
2900         uint256 stakingShareSeconds,
2901         uint256 stakeTimeSec
2902     ) private view returns (uint256) {
2903         uint256 newRewardTokens =
2904             totalUnlocked().mul(stakingShareSeconds).div(
2905                 _totalStakingShareSeconds
2906             );
2907 
2908         if (stakeTimeSec >= bonusPeriodSec) {
2909             return currentRewardTokens.add(newRewardTokens);
2910         }
2911 
2912         uint256 oneHundredPct = 10**bonusDecimals;
2913         uint256 bonusedReward =
2914             startBonus
2915                 .add(
2916                 oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(
2917                     bonusPeriodSec
2918                 )
2919             )
2920                 .mul(newRewardTokens)
2921                 .div(oneHundredPct);
2922 
2923         return currentRewardTokens.add(bonusedReward);
2924     }
2925 
2926 
2927     /**
2928      * @param addr The user to look up staking information for.
2929      * @return The number of staking tokens deposited for addr.
2930      */
2931     function totalStakedFor(address addr)
2932         public
2933         view
2934         override
2935         returns (uint256)
2936     {
2937         uint256 amountWithExtra =
2938             totalStakingShares > 0
2939                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
2940                     totalStakingShares
2941                 )
2942                 : 0;
2943 
2944         if (amountWithExtra == 0) return amountWithExtra;
2945         return amountWithExtra - extraAmounts[addr];
2946     }
2947 
2948     /**
2949      * @return The total number of deposit tokens staked globally, by all users.
2950      */
2951     function totalStaked() public view override returns (uint256) {
2952         return _stakingPool.balance() + totalExtra;
2953     }
2954 
2955     /**
2956      * @dev Note that this application has a staking token as well as a distribution token, which
2957      * may be different. This function is required by EIP-900.
2958      * @return The deposit token used for staking.
2959      */
2960     function token() external view override returns (address) {
2961         return address(getStakingToken());
2962     }
2963 
2964     /**
2965      * @dev A globally callable function to update the accounting state of the system.
2966      *      Global state and state for the caller are updated.
2967      * @return [0] balance of the locked pool
2968      * @return [1] balance of the unlocked pool
2969      * @return [2] caller's staking share seconds
2970      * @return [3] global staking share seconds
2971      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
2972      * @return [5] block timestamp
2973      */
2974     function updateAccounting(address user)
2975         public
2976         returns (
2977             uint256,
2978             uint256,
2979             uint256,
2980             uint256,
2981             uint256,
2982             uint256
2983         )
2984     {
2985         _unlockTokens();
2986 
2987         // Global accounting
2988         uint256 newStakingShareSeconds =
2989             now.sub(_lastAccountingTimestampSec).mul(totalStakingShares);
2990         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
2991             newStakingShareSeconds
2992         );
2993         _lastAccountingTimestampSec = now;
2994 
2995         // User Accounting
2996         UserTotals storage totals = _userTotals[user];
2997         uint256 newUserStakingShareSeconds =
2998             now.sub(totals.lastAccountingTimestampSec).mul(
2999                 totals.stakingShares
3000             );
3001         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
3002             newUserStakingShareSeconds
3003         );
3004         totals.lastAccountingTimestampSec = now;
3005 
3006         uint256 totalUserRewards =
3007             (_totalStakingShareSeconds > 0)
3008                 ? totalUnlocked().mul(totals.stakingShareSeconds).div(
3009                     _totalStakingShareSeconds
3010                 )
3011                 : 0;
3012 
3013         return (
3014             totalLocked(),
3015             totalUnlocked(),
3016             totals.stakingShareSeconds,
3017             _totalStakingShareSeconds,
3018             totalUserRewards,
3019             now
3020         );
3021     }
3022 
3023     /**
3024      * @return Total number of locked distribution tokens.
3025      */
3026     function totalLocked() public view returns (uint256) {
3027         return _lockedPool.balance();
3028     }
3029 
3030     /**
3031      * @return Total number of unlocked distribution tokens.
3032      */
3033     function totalUnlocked() public view returns (uint256) {
3034         return _unlockedPool.balance();
3035     }
3036 
3037     /**
3038      * @return Number of unlock schedules.
3039      */
3040     function unlockScheduleCount() public view returns (uint256) {
3041         return unlockSchedules.length;
3042     }
3043 
3044     /**
3045      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
3046      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
3047      *      linearly over the duraction of durationSec timeframe.
3048      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
3049      * @param durationSec Length of time to linear unlock the tokens.
3050      */
3051     function lockTokens(uint256 amount, uint256 durationSec)
3052         external
3053         onlyOwner
3054     {
3055         require(
3056             unlockSchedules.length < _maxUnlockSchedules,
3057             "TokenGeyser: reached maximum unlock schedules"
3058         );
3059 
3060         // Update lockedTokens amount before using it in computations after.
3061         updateAccounting(msg.sender);
3062 
3063         uint256 lockedTokens = totalLocked();
3064         uint256 mintedLockedShares =
3065             (lockedTokens > 0)
3066                 ? totalLockedShares.mul(amount).div(lockedTokens)
3067                 : amount.mul(_initialSharesPerToken);
3068 
3069         UnlockSchedule memory schedule;
3070         schedule.initialLockedShares = mintedLockedShares;
3071         schedule.lastUnlockTimestampSec = now;
3072         schedule.endAtSec = now.add(durationSec);
3073         schedule.durationSec = durationSec;
3074         unlockSchedules.push(schedule);
3075 
3076         totalLockedShares = totalLockedShares.add(mintedLockedShares);
3077 
3078         require(
3079             _lockedPool.token().transferFrom(
3080                 msg.sender,
3081                 address(_lockedPool),
3082                 amount
3083             ),
3084             "TokenGeyser: transfer into locked pool failed"
3085         );
3086         emit TokensLocked(amount, durationSec, totalLocked());
3087     }
3088 
3089     /**
3090      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
3091      *      previously defined unlock schedules. Publicly callable.
3092      * @return Number of newly unlocked distribution tokens.
3093      */
3094     function unlockTokens() public onlyOwner returns (uint256) {
3095         _unlockTokens();
3096     }
3097 
3098     function _unlockTokens() private returns (uint256) {
3099         uint256 unlockedTokens = 0;
3100         uint256 lockedTokens = totalLocked();
3101 
3102         if (totalLockedShares == 0) {
3103             unlockedTokens = lockedTokens;
3104         } else {
3105             uint256 unlockedShares = 0;
3106             for (uint256 s = 0; s < unlockSchedules.length; s++) {
3107                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
3108             }
3109             unlockedTokens = unlockedShares.mul(lockedTokens).div(
3110                 totalLockedShares
3111             );
3112             totalLockedShares = totalLockedShares.sub(unlockedShares);
3113         }
3114 
3115         if (unlockedTokens > 0) {
3116             require(
3117                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
3118                 "TokenGeyser: transfer out of locked pool failed"
3119             );
3120             emit TokensUnlocked(unlockedTokens, totalLocked());
3121         }
3122 
3123         return unlockedTokens;
3124     }
3125 
3126     /**
3127      * @dev Returns the number of unlockable shares from a given schedule. The returned value
3128      *      depends on the time since the last unlock. This function updates schedule accounting,
3129      *      but does not actually transfer any tokens.
3130      * @param s Index of the unlock schedule.
3131      * @return The number of unlocked shares.
3132      */
3133     function unlockScheduleShares(uint256 s) private returns (uint256) {
3134         UnlockSchedule storage schedule = unlockSchedules[s];
3135 
3136         if (schedule.unlockedShares >= schedule.initialLockedShares) {
3137             return 0;
3138         }
3139 
3140         uint256 sharesToUnlock = 0;
3141         // Special case to handle any leftover dust from integer division
3142         if (now >= schedule.endAtSec) {
3143             sharesToUnlock = (
3144                 schedule.initialLockedShares.sub(schedule.unlockedShares)
3145             );
3146             schedule.lastUnlockTimestampSec = schedule.endAtSec;
3147         } else {
3148             sharesToUnlock = now
3149                 .sub(schedule.lastUnlockTimestampSec)
3150                 .mul(schedule.initialLockedShares)
3151                 .div(schedule.durationSec);
3152             schedule.lastUnlockTimestampSec = now;
3153         }
3154 
3155         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
3156         return sharesToUnlock;
3157     }
3158 
3159     /**
3160      * @dev Lets the owner rescue funds air-dropped to the staking pool.
3161      * @param tokenToRescue Address of the token to be rescued.
3162      * @param to Address to which the rescued funds are to be sent.
3163      * @param amount Amount of tokens to be rescued.
3164      * @return Transfer success.
3165      */
3166     function rescueFundsFromStakingPool(
3167         address tokenToRescue,
3168         address to,
3169         uint256 amount
3170     ) public onlyOwner returns (bool) {
3171         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
3172     }
3173 
3174     function supportsHistory() external pure override returns (bool) {
3175         return false;
3176     }
3177 }
3178 
3179 // SPDX-License-Identifier: MIT
3180 /**
3181  * @title Staking interface, as defined by EIP-900.
3182  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
3183  */
3184 interface IStake {
3185     function stake(
3186         address staker,
3187         uint256 amount,
3188         bytes calldata data
3189     ) external;
3190 
3191     function stakeFor(
3192         address staker,
3193         address user,
3194         uint256 amount,
3195         bytes calldata data
3196     ) external;
3197 }
3198 
3199 // SPDX-License-Identifier: MIT
3200 /**
3201  * @title Non Nft Token Geyser
3202  * @dev A smart-contract based mechanism to distribute tokens over time, inspired loosely by
3203  *      Compound and Uniswap.
3204  *
3205  *      Distribution tokens are added to a locked pool in the contract and become unlocked over time
3206  *      according to a once-configurable unlock schedule. Once unlocked, they are available to be
3207  *      claimed by users.
3208  *
3209  *      A user may deposit tokens to accrue ownership share over the unlocked pool. This owner share
3210  *      is a function of the number of tokens deposited as well as the length of time deposited.
3211  *      Specifically, a user's share of the currently-unlocked pool equals their "deposit-seconds"
3212  *      divided by the global "deposit-seconds". This aligns the new token distribution with long
3213  *      term supporters of the project, addressing one of the major drawbacks of simple airdrops.
3214  *
3215  *      More background and motivation available at:
3216  *      https://github.com/ampleforth/RFCs/blob/master/RFCs/rfc-1.md
3217  */
3218 contract TokenGeyserWithoutNFT is IStaking, IStake, Ownable {
3219     using SafeMath for uint256;
3220 
3221     event Staked(
3222         address indexed user,
3223         uint256 amount,
3224         uint256 total,
3225         bytes data
3226     );
3227     event Unstaked(
3228         address indexed user,
3229         uint256 amount,
3230         uint256 total,
3231         bytes data
3232     );
3233     event TokensClaimed(address indexed user, uint256 amount);
3234     event TokensLocked(uint256 amount, uint256 durationSec, uint256 total);
3235     // amount: Unlocked tokens, total: Total locked tokens
3236     event TokensUnlocked(uint256 amount, uint256 total);
3237 
3238     TokenPool private _stakingPool;
3239     TokenPool private _unlockedPool;
3240     TokenPool private _lockedPool;
3241 
3242     //
3243     // Time-bonus params
3244     //
3245     uint256 public bonusDecimals = 2;
3246     uint256 public startBonus = 0;
3247     uint256 public bonusPeriodSec = 0;
3248 
3249     //
3250     // Global accounting state
3251     //
3252     uint256 public totalLockedShares = 0;
3253     uint256 public totalStakingShares = 0;
3254     uint256 private _totalStakingShareSeconds = 0;
3255     uint256 private _lastAccountingTimestampSec = now;
3256     uint256 private _maxUnlockSchedules = 0;
3257     uint256 private _initialSharesPerToken = 0;
3258 
3259     //
3260     // User accounting state
3261     //
3262     // Represents a single stake for a user. A user may have multiple.
3263     struct Stake {
3264         uint256 stakingShares;
3265         uint256 timestampSec;
3266     }
3267 
3268     // Caches aggregated values from the User->Stake[] map to save computation.
3269     // If lastAccountingTimestampSec is 0, there's no entry for that user.
3270     struct UserTotals {
3271         uint256 stakingShares;
3272         uint256 stakingShareSeconds;
3273         uint256 lastAccountingTimestampSec;
3274     }
3275 
3276     // Aggregated staking values per user
3277     mapping(address => UserTotals) private _userTotals;
3278 
3279     // The collection of stakes for each user. Ordered by timestamp, earliest to latest.
3280     mapping(address => Stake[]) private _userStakes;
3281 
3282     mapping(address => uint256) userEarnings;
3283 
3284     //
3285     // Locked/Unlocked Accounting state
3286     //
3287     struct UnlockSchedule {
3288         uint256 initialLockedShares;
3289         uint256 unlockedShares;
3290         uint256 lastUnlockTimestampSec;
3291         uint256 endAtSec;
3292         uint256 durationSec;
3293     }
3294 
3295     UnlockSchedule[] public unlockSchedules;
3296 
3297     address public geyserManager;
3298 
3299     /**
3300      * @param stakingToken The token users deposit as stake.
3301      * @param distributionToken The token users receive as they unstake.
3302      * @param maxUnlockSchedules Max number of unlock stages, to guard against hitting gas limit.
3303      * @param startBonus_ Starting time bonus
3304      *                    e.g. 25% means user gets 25% of max distribution tokens.
3305      * @param bonusPeriodSec_ Length of time for bonus to increase linearly to max.
3306      * @param initialSharesPerToken Number of shares to mint per staking token on first stake.
3307      * @param bonusDecimals_ The number of decimals for shares
3308      */
3309     constructor(
3310         IERC20 stakingToken,
3311         IERC20 distributionToken,
3312         uint256 maxUnlockSchedules,
3313         uint256 startBonus_,
3314         uint256 bonusPeriodSec_,
3315         uint256 initialSharesPerToken,
3316         uint256 bonusDecimals_,
3317         address managerAddress
3318     ) public {
3319         // The start bonus must be some fraction of the max. (i.e. <= 100%)
3320         require(
3321             startBonus_ <= 10**bonusDecimals_,
3322             "TokenGeyser: start bonus too high"
3323         );
3324         // If no period is desired, instead set startBonus = 100%
3325         // and bonusPeriod to a small value like 1sec.
3326         require(bonusPeriodSec_ != 0, "TokenGeyser: bonus period is zero");
3327         require(
3328             initialSharesPerToken > 0,
3329             "TokenGeyser: initialSharesPerToken is zero"
3330         );
3331 
3332         require(bonusDecimals_ > 0, "TokenGeyser: bonusDecimals_ is zero");
3333 
3334         _stakingPool = new TokenPool(stakingToken);
3335         _unlockedPool = new TokenPool(distributionToken);
3336         _lockedPool = new TokenPool(distributionToken);
3337         _unlockedPool.setRescuable(true);
3338 
3339         geyserManager = managerAddress;
3340         startBonus = startBonus_;
3341         bonusDecimals = bonusDecimals_;
3342         bonusPeriodSec = bonusPeriodSec_;
3343         _maxUnlockSchedules = maxUnlockSchedules;
3344         _initialSharesPerToken = initialSharesPerToken;
3345     }
3346 
3347     /**
3348      * @return Total earnings for a user
3349     */
3350     function getEarnings(address user) public view returns (uint256) {
3351         return userEarnings[user];
3352     }
3353 
3354     /**
3355      * @dev Rescue rewards
3356      */
3357     function rescueRewards(address user) external onlyOwner {
3358         require(totalUnlocked() > 0, "TokenGeyser: Nothing to rescue");
3359         require(
3360             _unlockedPool.transfer(user, _unlockedPool.balance()),
3361             "TokenGeyser: rescue rewards from rewards pool failed"
3362         );
3363     }
3364 
3365     /**
3366      * @return The token users deposit as stake.
3367      */
3368     function getStakingToken() public view returns (IERC20) {
3369         return _stakingPool.token();
3370     }
3371 
3372     /**
3373      * @return The token users receive as they unstake.
3374      */
3375     function getDistributionToken() public view returns (IERC20) {
3376         assert(_unlockedPool.token() == _lockedPool.token());
3377         return _unlockedPool.token();
3378     }
3379 
3380     event log(string s);
3381     event log(uint256 s);
3382     event log(address s);
3383 
3384     /**
3385      * @dev Transfers amount of deposit tokens from the user.
3386      * @param amount Number of deposit tokens to stake.
3387      * @param data Not used.
3388      */
3389     function stake(
3390         address staker,
3391         uint256 amount,
3392         bytes calldata data
3393     ) external override {
3394         require(
3395             geyserManager == msg.sender,
3396             "This method can be called by the geyser manager only"
3397         );
3398         _stakeFor(staker, staker, amount);
3399     }
3400 
3401     /**
3402      * @dev Transfers amount of deposit tokens from the caller on behalf of user.
3403      * @param user User address who gains credit for this stake operation.
3404      * @param amount Number of deposit tokens to stake.
3405      * @param data Not used.
3406      */
3407     function stakeFor(
3408         address staker,
3409         address user,
3410         uint256 amount,
3411         bytes calldata data
3412     ) external override onlyOwner {
3413         require(
3414             geyserManager == msg.sender,
3415             "This method can be called by the geyser manager only"
3416         );
3417         _stakeFor(staker, user, amount);
3418     }
3419 
3420     /**
3421      * @dev Private implementation of staking methods.
3422      * @param staker User address who deposits tokens to stake.
3423      * @param beneficiary User address who gains credit for this stake operation.
3424      * @param amount Number of deposit tokens to stake.
3425      */
3426     function _stakeFor(
3427         address staker,
3428         address beneficiary,
3429         uint256 amount
3430     ) private {
3431         require(amount > 0, "TokenGeyser: stake amount is zero");
3432         require(
3433             beneficiary != address(0),
3434             "TokenGeyser: beneficiary is zero address"
3435         );
3436         require(
3437             totalStakingShares == 0 || totalStaked() > 0,
3438             "TokenGeyser: Invalid state. Staking shares exist, but no staking tokens do"
3439         );
3440 
3441 
3442         uint256 mintedStakingShares =
3443             (totalStakingShares > 0)
3444                 ? totalStakingShares.mul(amount).div(totalStaked())
3445                 : amount.mul(_initialSharesPerToken);
3446 
3447         require(
3448             mintedStakingShares > 0,
3449             "TokenGeyser: Stake amount is too small"
3450         );
3451 
3452         updateAccounting(beneficiary);
3453 
3454         // 1. User Accounting
3455         UserTotals storage totals = _userTotals[beneficiary];
3456         totals.stakingShares = totals.stakingShares.add(mintedStakingShares);
3457         totals.lastAccountingTimestampSec = now;
3458 
3459         Stake memory newStake = Stake(mintedStakingShares, now);
3460         _userStakes[beneficiary].push(newStake);
3461 
3462         // 2. Global Accounting
3463         totalStakingShares = totalStakingShares.add(mintedStakingShares);
3464         // Already set in updateAccounting()
3465         // _lastAccountingTimestampSec = now;
3466 
3467         // interactions
3468         require(
3469             _stakingPool.token().transferFrom(
3470                 staker,
3471                 address(_stakingPool),
3472                 amount
3473             ),
3474             "TokenGeyser: transfer into staking pool failed"
3475         );
3476 
3477         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
3478     }
3479 
3480     /**
3481      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
3482      * alotted number of distribution tokens.
3483      * @param amount Number of deposit tokens to unstake / withdraw.
3484      * @param data Not used.
3485      */
3486     function unstake(
3487         address staker,
3488         uint256 amount,
3489         bytes calldata data
3490     ) external override {
3491         require(
3492             geyserManager == msg.sender,
3493             "This method can be called by the geyser manager only"
3494         );
3495         _unstake(staker, amount);
3496     }
3497 
3498     /**
3499      * @param amount Number of deposit tokens to unstake / withdraw.
3500      * @return The total number of distribution tokens that would be rewarded.
3501      */
3502     function unstakeQuery(address staker, uint256 amount)
3503         public
3504         returns (uint256)
3505     {
3506         require(
3507             geyserManager == msg.sender,
3508             "This method can be called by the geyser manager only"
3509         );
3510         return _unstake(staker, amount);
3511     }
3512 
3513     /**
3514      * @dev Unstakes a certain amount of previously deposited tokens. User also receives their
3515      * alotted number of distribution tokens.
3516      * @param amount Number of deposit tokens to unstake / withdraw.
3517      * @return The total number of distribution tokens rewarded.
3518      */
3519     function _unstake(address user, uint256 amount) private returns (uint256) {
3520         updateAccounting(user);
3521 
3522         uint256 stakingSharesToBurn =
3523             totalStakingShares.mul(amount).div(totalStaked());
3524 
3525         require(
3526             stakingSharesToBurn > 0,
3527             "TokenGeyser: Unable to unstake amount this small"
3528         );
3529 
3530         // 1. User Accounting
3531         UserTotals storage totals = _userTotals[user];
3532         Stake[] storage accountStakes = _userStakes[user];
3533 
3534         // Redeem from most recent stake and go backwards in time.
3535         uint256 stakingShareSecondsToBurn = 0;
3536         uint256 sharesLeftToBurn = stakingSharesToBurn;
3537         uint256 rewardAmount = 0;
3538         while (sharesLeftToBurn > 0) {
3539             Stake storage lastStake = accountStakes[accountStakes.length - 1];
3540             uint256 stakeTimeSec = now.sub(lastStake.timestampSec);
3541             uint256 newStakingShareSecondsToBurn = 0;
3542 
3543             if (lastStake.stakingShares <= sharesLeftToBurn) {
3544                 newStakingShareSecondsToBurn = lastStake.stakingShares.mul(
3545                     stakeTimeSec
3546                 );
3547                 rewardAmount = computeNewReward(
3548                     rewardAmount,
3549                     newStakingShareSecondsToBurn,
3550                     stakeTimeSec
3551                 );
3552 
3553                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
3554                     newStakingShareSecondsToBurn
3555                 );
3556                 sharesLeftToBurn = sharesLeftToBurn.sub(
3557                     lastStake.stakingShares
3558                 );
3559                 accountStakes.pop();
3560             } else {
3561                 newStakingShareSecondsToBurn = sharesLeftToBurn.mul(
3562                     stakeTimeSec
3563                 );
3564                 rewardAmount = computeNewReward(
3565                     rewardAmount,
3566                     newStakingShareSecondsToBurn,
3567                     stakeTimeSec
3568                 );
3569                 stakingShareSecondsToBurn = stakingShareSecondsToBurn.add(
3570                     newStakingShareSecondsToBurn
3571                 );
3572                 lastStake.stakingShares = lastStake.stakingShares.sub(
3573                     sharesLeftToBurn
3574                 );
3575                 sharesLeftToBurn = 0;
3576             }
3577         }
3578         totals.stakingShareSeconds = totals.stakingShareSeconds.sub(
3579             stakingShareSecondsToBurn
3580         );
3581         totals.stakingShares = totals.stakingShares.sub(stakingSharesToBurn);
3582         // Already set in updateAccounting
3583         // totals.lastAccountingTimestampSec = now;
3584 
3585         // 2. Global Accounting
3586         _totalStakingShareSeconds = _totalStakingShareSeconds.sub(
3587             stakingShareSecondsToBurn
3588         );
3589         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
3590         // Already set in updateAccountingF
3591         // _lastAccountingTimestampSec = now;
3592 
3593         // interactions
3594         require(
3595             _stakingPool.transfer(user, amount),
3596             "TokenGeyser: transfer out of staking pool failed"
3597         );
3598 
3599         //in case rescueRewards was called, there are no rewards to be transfered
3600         if (totalUnlocked() >= rewardAmount) {
3601             require(
3602                 _unlockedPool.transfer(user, rewardAmount),
3603                 "TokenGeyser: transfer out of unlocked pool failed"
3604             );
3605             emit TokensClaimed(user, rewardAmount);
3606             
3607              userEarnings[user] += rewardAmount;
3608         }
3609 
3610         emit Unstaked(user, amount, totalStakedFor(user), "");
3611 
3612         require(
3613             totalStakingShares == 0 || totalStaked() > 0,
3614             "TokenGeyser: Error unstaking. Staking shares exist, but no staking tokens do"
3615         );
3616 
3617         return rewardAmount;
3618     }
3619 
3620     /**
3621      * @dev Applies an additional time-bonus to a distribution amount. This is necessary to
3622      *      encourage long-term deposits instead of constant unstake/restakes.
3623      *      The bonus-multiplier is the result of a linear function that starts at startBonus and
3624      *      ends at 100% over bonusPeriodSec, then stays at 100% thereafter.
3625      * @param currentRewardTokens The current number of distribution tokens already alotted for this
3626      *                            unstake op. Any bonuses are already applied.
3627      * @param stakingShareSeconds The stakingShare-seconds that are being burned for new
3628      *                            distribution tokens.
3629      * @param stakeTimeSec Length of time for which the tokens were staked. Needed to calculate
3630      *                     the time-bonus.
3631      * @return Updated amount of distribution tokens to award, with any bonus included on the
3632      *         newly added tokens.
3633      */
3634     function computeNewReward(
3635         uint256 currentRewardTokens,
3636         uint256 stakingShareSeconds,
3637         uint256 stakeTimeSec
3638     ) private view returns (uint256) {
3639         uint256 newRewardTokens =
3640             totalUnlocked().mul(stakingShareSeconds).div(
3641                 _totalStakingShareSeconds
3642             );
3643 
3644         if (stakeTimeSec >= bonusPeriodSec) {
3645             return currentRewardTokens.add(newRewardTokens);
3646         }
3647 
3648         uint256 oneHundredPct = 10**bonusDecimals;
3649         uint256 bonusedReward =
3650             startBonus
3651                 .add(
3652                 oneHundredPct.sub(startBonus).mul(stakeTimeSec).div(
3653                     bonusPeriodSec
3654                 )
3655             )
3656                 .mul(newRewardTokens)
3657                 .div(oneHundredPct);
3658 
3659         return currentRewardTokens.add(bonusedReward);
3660     }
3661 
3662     /**
3663      * @param addr The user to look up staking information for.
3664      * @return The number of staking tokens deposited for addr.
3665      */
3666     function totalStakedFor(address addr)
3667         public
3668         view
3669         override
3670         returns (uint256)
3671     {
3672         return
3673             totalStakingShares > 0
3674                 ? totalStaked().mul(_userTotals[addr].stakingShares).div(
3675                     totalStakingShares
3676                 )
3677                 : 0;
3678     }
3679 
3680     /**
3681      * @return The total number of deposit tokens staked globally, by all users.
3682      */
3683     function totalStaked() public view override returns (uint256) {
3684         return _stakingPool.balance();
3685     }
3686 
3687     /**
3688      * @dev Note that this application has a staking token as well as a distribution token, which
3689      * may be different. This function is required by EIP-900.
3690      * @return The deposit token used for staking.
3691      */
3692     function token() external view override returns (address) {
3693         return address(getStakingToken());
3694     }
3695 
3696     /**
3697      * @dev A globally callable function to update the accounting state of the system.
3698      *      Global state and state for the caller are updated.
3699      * @return [0] balance of the locked pool
3700      * @return [1] balance of the unlocked pool
3701      * @return [2] caller's staking share seconds
3702      * @return [3] global staking share seconds
3703      * @return [4] Rewards caller has accumulated, optimistically assumes max time-bonus.
3704      * @return [5] block timestamp
3705      */
3706     function updateAccounting(address user)
3707         public
3708         returns (
3709             uint256,
3710             uint256,
3711             uint256,
3712             uint256,
3713             uint256,
3714             uint256
3715         )
3716     {
3717         _unlockTokens();
3718 
3719         // Global accounting
3720         uint256 newStakingShareSeconds =
3721             now.sub(_lastAccountingTimestampSec).mul(totalStakingShares);
3722         _totalStakingShareSeconds = _totalStakingShareSeconds.add(
3723             newStakingShareSeconds
3724         );
3725         _lastAccountingTimestampSec = now;
3726 
3727         // User Accounting
3728         UserTotals storage totals = _userTotals[user];
3729         uint256 newUserStakingShareSeconds =
3730             now.sub(totals.lastAccountingTimestampSec).mul(
3731                 totals.stakingShares
3732             );
3733         totals.stakingShareSeconds = totals.stakingShareSeconds.add(
3734             newUserStakingShareSeconds
3735         );
3736         totals.lastAccountingTimestampSec = now;
3737 
3738         uint256 totalUserRewards =
3739             (_totalStakingShareSeconds > 0)
3740                 ? totalUnlocked().mul(totals.stakingShareSeconds).div(
3741                     _totalStakingShareSeconds
3742                 )
3743                 : 0;
3744 
3745         return (
3746             totalLocked(),
3747             totalUnlocked(),
3748             totals.stakingShareSeconds,
3749             _totalStakingShareSeconds,
3750             totalUserRewards,
3751             now
3752         );
3753     }
3754 
3755     /**
3756      * @return Total number of locked distribution tokens.
3757      */
3758     function totalLocked() public view returns (uint256) {
3759         return _lockedPool.balance();
3760     }
3761 
3762     /**
3763      * @return Total number of unlocked distribution tokens.
3764      */
3765     function totalUnlocked() public view returns (uint256) {
3766         return _unlockedPool.balance();
3767     }
3768 
3769     /**
3770      * @return Number of unlock schedules.
3771      */
3772     function unlockScheduleCount() public view returns (uint256) {
3773         return unlockSchedules.length;
3774     }
3775 
3776     /**
3777      * @dev This funcion allows the contract owner to add more locked distribution tokens, along
3778      *      with the associated "unlock schedule". These locked tokens immediately begin unlocking
3779      *      linearly over the duraction of durationSec timeframe.
3780      * @param amount Number of distribution tokens to lock. These are transferred from the caller.
3781      * @param durationSec Length of time to linear unlock the tokens.
3782      */
3783     function lockTokens(uint256 amount, uint256 durationSec)
3784         external
3785         onlyOwner
3786     {
3787         require(
3788             unlockSchedules.length < _maxUnlockSchedules,
3789             "TokenGeyser: reached maximum unlock schedules"
3790         );
3791 
3792         // Update lockedTokens amount before using it in computations after.
3793         updateAccounting(msg.sender);
3794 
3795         uint256 lockedTokens = totalLocked();
3796         uint256 mintedLockedShares =
3797             (lockedTokens > 0)
3798                 ? totalLockedShares.mul(amount).div(lockedTokens)
3799                 : amount.mul(_initialSharesPerToken);
3800 
3801         UnlockSchedule memory schedule;
3802         schedule.initialLockedShares = mintedLockedShares;
3803         schedule.lastUnlockTimestampSec = now;
3804         schedule.endAtSec = now.add(durationSec);
3805         schedule.durationSec = durationSec;
3806         unlockSchedules.push(schedule);
3807 
3808         totalLockedShares = totalLockedShares.add(mintedLockedShares);
3809 
3810         require(
3811             _lockedPool.token().transferFrom(
3812                 msg.sender,
3813                 address(_lockedPool),
3814                 amount
3815             ),
3816             "TokenGeyser: transfer into locked pool failed"
3817         );
3818         emit TokensLocked(amount, durationSec, totalLocked());
3819     }
3820 
3821     /**
3822      * @dev Moves distribution tokens from the locked pool to the unlocked pool, according to the
3823      *      previously defined unlock schedules. Publicly callable.
3824      * @return Number of newly unlocked distribution tokens.
3825      */
3826     function unlockTokens() public onlyOwner returns (uint256) {
3827         _unlockTokens();
3828     }
3829 
3830     function _unlockTokens() private returns (uint256) {
3831         uint256 unlockedTokens = 0;
3832         uint256 lockedTokens = totalLocked();
3833 
3834         if (totalLockedShares == 0) {
3835             unlockedTokens = lockedTokens;
3836         } else {
3837             uint256 unlockedShares = 0;
3838             for (uint256 s = 0; s < unlockSchedules.length; s++) {
3839                 unlockedShares = unlockedShares.add(unlockScheduleShares(s));
3840             }
3841             unlockedTokens = unlockedShares.mul(lockedTokens).div(
3842                 totalLockedShares
3843             );
3844             totalLockedShares = totalLockedShares.sub(unlockedShares);
3845         }
3846 
3847         if (unlockedTokens > 0) {
3848             require(
3849                 _lockedPool.transfer(address(_unlockedPool), unlockedTokens),
3850                 "TokenGeyser: transfer out of locked pool failed"
3851             );
3852             emit TokensUnlocked(unlockedTokens, totalLocked());
3853         }
3854 
3855         return unlockedTokens;
3856     }
3857 
3858     /**
3859      * @dev Returns the number of unlockable shares from a given schedule. The returned value
3860      *      depends on the time since the last unlock. This function updates schedule accounting,
3861      *      but does not actually transfer any tokens.
3862      * @param s Index of the unlock schedule.
3863      * @return The number of unlocked shares.
3864      */
3865     function unlockScheduleShares(uint256 s) private returns (uint256) {
3866         UnlockSchedule storage schedule = unlockSchedules[s];
3867 
3868         if (schedule.unlockedShares >= schedule.initialLockedShares) {
3869             return 0;
3870         }
3871 
3872         uint256 sharesToUnlock = 0;
3873         // Special case to handle any leftover dust from integer division
3874         if (now >= schedule.endAtSec) {
3875             sharesToUnlock = (
3876                 schedule.initialLockedShares.sub(schedule.unlockedShares)
3877             );
3878             schedule.lastUnlockTimestampSec = schedule.endAtSec;
3879         } else {
3880             sharesToUnlock = now
3881                 .sub(schedule.lastUnlockTimestampSec)
3882                 .mul(schedule.initialLockedShares)
3883                 .div(schedule.durationSec);
3884             schedule.lastUnlockTimestampSec = now;
3885         }
3886 
3887         schedule.unlockedShares = schedule.unlockedShares.add(sharesToUnlock);
3888         return sharesToUnlock;
3889     }
3890 
3891     /**
3892      * @dev Lets the owner rescue funds air-dropped to the staking pool.
3893      * @param tokenToRescue Address of the token to be rescued.
3894      * @param to Address to which the rescued funds are to be sent.
3895      * @param amount Amount of tokens to be rescued.
3896      * @return Transfer success.
3897      */
3898     function rescueFundsFromStakingPool(
3899         address tokenToRescue,
3900         address to,
3901         uint256 amount
3902     ) public onlyOwner returns (bool) {
3903         return _stakingPool.rescueFunds(tokenToRescue, to, amount);
3904     }
3905 
3906     function supportsHistory() external pure override returns (bool) {
3907         return false;
3908     }
3909 }
3910 
3911 // SPDX-License-Identifier: MIT
3912 /** @title Token Geyser Manager */
3913 contract TokenGeyserManager is Ownable, ITokenGeyserManager {
3914     bool public hasNFTBonus;
3915     mapping(address => address) public geysers;
3916     address[] public tokens;
3917 
3918     /**
3919        @dev Creates an empty Geyser token managers
3920     
3921      */
3922     constructor(bool _hasNftBonus) public {
3923         hasNFTBonus = _hasNftBonus;
3924 
3925         emit GeyserManagerCreated(msg.sender, address(this));
3926     }
3927 
3928     /**
3929         @dev Adds a new geyser in the team
3930         @param token - address of the staking token for which the geyser was created
3931         @param geyser - address of the geyser
3932      */
3933     function addGeyser(address token, address geyser)
3934         public
3935         override
3936         onlyOwner
3937         returns (bool)
3938     {
3939         require(token != address(0), "TokenGeyserManager: token is invalid");
3940 
3941         require(geyser != address(0), "TokenGeyserManager: geyser is invalid");
3942         tokens.push(token);
3943         geysers[token] = geyser;
3944 
3945         emit GeyserAdded(msg.sender, geyser, token);
3946         return true;
3947     }
3948 
3949     /**
3950         @dev Retrieves total rewards earned for a specific staking token
3951         @param token - address of the ERC20 token
3952     */
3953     function getEarned(address token) public view override returns (uint256) {
3954         if (hasNFTBonus) {
3955             return TokenGeyser(geysers[token]).getEarnings(msg.sender);
3956         }
3957         return TokenGeyserWithoutNFT(geysers[token]).getEarnings(msg.sender);
3958     }
3959 
3960     /**
3961         @dev Retrieves total rewards earned for all the staking tokens
3962     */
3963      function getEarnings() public view override returns (address[] memory, uint256[] memory){
3964         address[] memory addresses = new address[](tokens.length);
3965         uint256[] memory amounts = new uint256[](tokens.length);
3966 
3967         for (uint8 i = 0; i < tokens.length; i++) {
3968             addresses[i] = tokens[i];
3969             if (hasNFTBonus) {
3970                 amounts[i] = TokenGeyser(geysers[tokens[i]]).getEarnings(
3971                     msg.sender
3972                 );
3973             } else {
3974                 amounts[i] = TokenGeyserWithoutNFT(geysers[tokens[i]])
3975                     .getEarnings(msg.sender);
3976             }
3977         }
3978 
3979         return (addresses, amounts);
3980      }
3981 
3982 
3983     /**
3984         @dev Retrieves staked amount for a specific token address
3985         @param token - address of the ERC20 token
3986     */
3987     function getStake(address token) public view override returns (uint256) {
3988         if (hasNFTBonus) {
3989             return TokenGeyser(geysers[token]).totalStakedFor(msg.sender);
3990         }
3991         return TokenGeyserWithoutNFT(geysers[token]).totalStakedFor(msg.sender);
3992     }
3993 
3994 
3995     /**
3996         @dev Retrieves all stakes for sender
3997      */
3998     function getStakes()
3999         public
4000         view
4001         override
4002         returns (address[] memory, uint256[] memory)
4003     {
4004         address[] memory addresses = new address[](tokens.length);
4005         uint256[] memory amounts = new uint256[](tokens.length);
4006 
4007         for (uint8 i = 0; i < tokens.length; i++) {
4008             addresses[i] = tokens[i];
4009             if (hasNFTBonus) {
4010                 amounts[i] = TokenGeyser(geysers[tokens[i]]).totalStakedFor(
4011                     msg.sender
4012                 );
4013             } else {
4014                 amounts[i] = TokenGeyserWithoutNFT(geysers[tokens[i]])
4015                     .totalStakedFor(msg.sender);
4016             }
4017         }
4018 
4019         return (addresses, amounts);
4020     }
4021 
4022 
4023     /**
4024         @dev Stakes all tokens sent
4025         @param _tokens - array of tokens' addresses you want to stake
4026         @param amounts - stake amount you want for each token
4027      */
4028     function stake(
4029         address[] calldata _tokens,
4030         uint256[] calldata amounts,
4031         int256 nftId
4032     ) external override returns (bool) {
4033         //validation
4034         require(tokens.length > 0, "TokenGeyserManager: _tokens is empty");
4035         require(amounts.length > 0, "TokenGeyserManager: amounts is empty");
4036         require(
4037             _tokens.length == amounts.length,
4038             "TokenGeyserManager: tokens and amounts need to  be the same length"
4039         );
4040 
4041         for (uint8 i = 0; i < _tokens.length; i++) {
4042             ERC20 currentToken = ERC20(_tokens[i]);
4043             uint256 currentTokenBalance = currentToken.balanceOf(msg.sender);
4044             uint256 sentAmount = amounts[i];
4045             string memory tokenName = currentToken.name();
4046 
4047             require(
4048                 currentTokenBalance >= sentAmount,
4049                 string(
4050                     abi.encodePacked(
4051                         "TokenGeyserManager: Token ",
4052                         tokenName,
4053                         " balance is lower than the amount sent"
4054                     )
4055                 )
4056             );
4057         }
4058         //actions
4059         for (uint8 i = 0; i < _tokens.length; i++) {
4060             if (hasNFTBonus) {
4061                 TokenGeyser(geysers[_tokens[i]]).stake(
4062                     msg.sender,
4063                     amounts[i],
4064                     "",
4065                     nftId
4066                 );
4067             } else {
4068                 TokenGeyserWithoutNFT(geysers[_tokens[i]]).stake(
4069                     msg.sender,
4070                     amounts[i],
4071                     ""
4072                 );
4073             }
4074 
4075             emit Staked(msg.sender, tokens[i], amounts[i]);
4076         }
4077 
4078         return true;
4079     }
4080 
4081     /**
4082         @dev Unstakes all tokens sent
4083         @param _tokens - array of tokens' addresses you want to unstake
4084         @param amounts - unstake amount you want for each token
4085      */
4086     function unstake(address[] calldata _tokens, uint256[] calldata amounts)
4087         external
4088         override
4089     {
4090         //validation
4091         require(tokens.length > 0, "TokenGeyserManager: _tokens is empty");
4092         require(amounts.length > 0, "TokenGeyserManager: amounts is empty");
4093         require(
4094             _tokens.length == amounts.length,
4095             "TokenGeyserManager: tokens and amounts need to  be the same length"
4096         );
4097 
4098         for (uint8 i = 0; i < _tokens.length; i++) {
4099             if (hasNFTBonus) {
4100                 require(
4101                     amounts[i] == 0,
4102                     "TokenGeyserManager: only full unstake is allowed"
4103                 );
4104                 TokenGeyser(geysers[_tokens[i]]).unstake(
4105                     msg.sender,
4106                     amounts[i],
4107                     ""
4108                 );
4109             } else {
4110                 TokenGeyserWithoutNFT(geysers[_tokens[i]]).unstake(
4111                     msg.sender,
4112                     amounts[i],
4113                     ""
4114                 );
4115             }
4116 
4117             emit Unstaked(msg.sender, _tokens[i], amounts[i]);
4118         }
4119     }
4120 }