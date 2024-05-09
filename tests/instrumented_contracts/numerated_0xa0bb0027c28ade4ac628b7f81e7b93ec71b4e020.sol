1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
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
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 
507 /**
508  * @dev Extension of {ERC20} that allows token holders to destroy both their own
509  * tokens and those that they have an allowance for, in a way that can be
510  * recognized off-chain (via event analysis).
511  */
512 contract ERC20Burnable is Context, ERC20 {
513     /**
514      * @dev Destroys `amount` tokens from the caller.
515      *
516      * See {ERC20-_burn}.
517      */
518     function burn(uint256 amount) public {
519         _burn(_msgSender(), amount);
520     }
521 
522     /**
523      * @dev See {ERC20-_burnFrom}.
524      */
525     function burnFrom(address account, uint256 amount) public {
526         _burnFrom(account, amount);
527     }
528 }
529 
530 // File: @openzeppelin/contracts/access/Roles.sol
531 
532 pragma solidity ^0.5.0;
533 
534 /**
535  * @title Roles
536  * @dev Library for managing addresses assigned to a Role.
537  */
538 library Roles {
539     struct Role {
540         mapping (address => bool) bearer;
541     }
542 
543     /**
544      * @dev Give an account access to this role.
545      */
546     function add(Role storage role, address account) internal {
547         require(!has(role, account), "Roles: account already has role");
548         role.bearer[account] = true;
549     }
550 
551     /**
552      * @dev Remove an account's access to this role.
553      */
554     function remove(Role storage role, address account) internal {
555         require(has(role, account), "Roles: account does not have role");
556         role.bearer[account] = false;
557     }
558 
559     /**
560      * @dev Check if an account has this role.
561      * @return bool
562      */
563     function has(Role storage role, address account) internal view returns (bool) {
564         require(account != address(0), "Roles: account is the zero address");
565         return role.bearer[account];
566     }
567 }
568 
569 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
570 
571 pragma solidity ^0.5.0;
572 
573 
574 
575 contract MinterRole is Context {
576     using Roles for Roles.Role;
577 
578     event MinterAdded(address indexed account);
579     event MinterRemoved(address indexed account);
580 
581     Roles.Role private _minters;
582 
583     constructor () internal {
584         _addMinter(_msgSender());
585     }
586 
587     modifier onlyMinter() {
588         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
589         _;
590     }
591 
592     function isMinter(address account) public view returns (bool) {
593         return _minters.has(account);
594     }
595 
596     function addMinter(address account) public onlyMinter {
597         _addMinter(account);
598     }
599 
600     function renounceMinter() public {
601         _removeMinter(_msgSender());
602     }
603 
604     function _addMinter(address account) internal {
605         _minters.add(account);
606         emit MinterAdded(account);
607     }
608 
609     function _removeMinter(address account) internal {
610         _minters.remove(account);
611         emit MinterRemoved(account);
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
616 
617 pragma solidity ^0.5.0;
618 
619 
620 
621 /**
622  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
623  * which have permission to mint (create) new tokens as they see fit.
624  *
625  * At construction, the deployer of the contract is the only minter.
626  */
627 contract ERC20Mintable is ERC20, MinterRole {
628     /**
629      * @dev See {ERC20-_mint}.
630      *
631      * Requirements:
632      *
633      * - the caller must have the {MinterRole}.
634      */
635     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
636         _mint(account, amount);
637         return true;
638     }
639 }
640 
641 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
642 
643 pragma solidity ^0.5.0;
644 
645 
646 /**
647  * @dev Optional functions from the ERC20 standard.
648  */
649 contract ERC20Detailed is IERC20 {
650     string private _name;
651     string private _symbol;
652     uint8 private _decimals;
653 
654     /**
655      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
656      * these values are immutable: they can only be set once during
657      * construction.
658      */
659     constructor (string memory name, string memory symbol, uint8 decimals) public {
660         _name = name;
661         _symbol = symbol;
662         _decimals = decimals;
663     }
664 
665     /**
666      * @dev Returns the name of the token.
667      */
668     function name() public view returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the symbol of the token, usually a shorter version of the
674      * name.
675      */
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the number of decimals used to get its user representation.
682      * For example, if `decimals` equals `2`, a balance of `505` tokens should
683      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
684      *
685      * Tokens usually opt for a value of 18, imitating the relationship between
686      * Ether and Wei.
687      *
688      * NOTE: This information is only used for _display_ purposes: it in
689      * no way affects any of the arithmetic of the contract, including
690      * {IERC20-balanceOf} and {IERC20-transfer}.
691      */
692     function decimals() public view returns (uint8) {
693         return _decimals;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
698 
699 pragma solidity ^0.5.0;
700 
701 
702 
703 /**
704  * @title WhitelistAdminRole
705  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
706  */
707 contract WhitelistAdminRole is Context {
708     using Roles for Roles.Role;
709 
710     event WhitelistAdminAdded(address indexed account);
711     event WhitelistAdminRemoved(address indexed account);
712 
713     Roles.Role private _whitelistAdmins;
714 
715     constructor () internal {
716         _addWhitelistAdmin(_msgSender());
717     }
718 
719     modifier onlyWhitelistAdmin() {
720         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
721         _;
722     }
723 
724     function isWhitelistAdmin(address account) public view returns (bool) {
725         return _whitelistAdmins.has(account);
726     }
727 
728     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
729         _addWhitelistAdmin(account);
730     }
731 
732     function renounceWhitelistAdmin() public {
733         _removeWhitelistAdmin(_msgSender());
734     }
735 
736     function _addWhitelistAdmin(address account) internal {
737         _whitelistAdmins.add(account);
738         emit WhitelistAdminAdded(account);
739     }
740 
741     function _removeWhitelistAdmin(address account) internal {
742         _whitelistAdmins.remove(account);
743         emit WhitelistAdminRemoved(account);
744     }
745 }
746 
747 // File: contracts/ERC20/ERC20TransferLiquidityLock.sol
748 
749 pragma solidity ^0.5.17;
750 
751 
752 contract ERC20TransferLiquidityLock is ERC20 {
753     using SafeMath for uint256;
754 
755     event LockLiquidity(uint256 tokenAmount, uint256 ethAmount);
756     event BurnLiquidity(uint256 lpTokenAmount);
757     event RewardLiquidityProviders(uint256 tokenAmount);
758 
759     address public uniswapV2Router;
760     address public uniswapV2Pair;
761 
762     // the amount of tokens to lock for liquidity during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
763     uint256 public liquidityLockDivisor;
764     uint256 public liquidityRewardsDivisor;
765 
766     function _transfer(address from, address to, uint256 amount) internal {
767         // calculate liquidity lock amount
768         // dont transfer burn from this contract
769         // or can never lock full lockable amount
770         if (liquidityLockDivisor != 0 && from != address(this)) {
771             uint256 liquidityLockAmount = amount.div(liquidityLockDivisor);
772             super._transfer(from, address(this), liquidityLockAmount);
773             super._transfer(from, to, amount.sub(liquidityLockAmount));
774         }
775         else {
776             super._transfer(from, to, amount);
777         }
778     }
779 
780     // receive eth from uniswap swap
781     function () external payable {}
782 
783     function lockLiquidity(uint256 _lockableSupply) public {
784         // lockable supply is the token balance of this contract
785         require(_lockableSupply <= balanceOf(address(this)), "ERC20TransferLiquidityLock::lockLiquidity: lock amount higher than lockable balance");
786         require(_lockableSupply != 0, "ERC20TransferLiquidityLock::lockLiquidity: lock amount cannot be 0");
787 
788         // reward liquidity providers if needed
789         if (liquidityRewardsDivisor != 0) {
790             // if no balance left to lock, don't lock
791             if (liquidityRewardsDivisor == 1) {
792                 _rewardLiquidityProviders(_lockableSupply);
793                 return;
794             }
795 
796             uint256 liquidityRewards = _lockableSupply.div(liquidityRewardsDivisor);
797             _lockableSupply = _lockableSupply.sub(liquidityRewards);
798             _rewardLiquidityProviders(liquidityRewards);
799         }
800 
801         uint256 amountToSwapForEth = _lockableSupply.div(2);
802         uint256 amountToAddLiquidity = _lockableSupply.sub(amountToSwapForEth);
803 
804         // needed in case contract already owns eth
805         uint256 ethBalanceBeforeSwap = address(this).balance;
806         swapTokensForEth(amountToSwapForEth);
807         uint256 ethReceived = address(this).balance.sub(ethBalanceBeforeSwap);
808 
809         addLiquidity(amountToAddLiquidity, ethReceived);
810         emit LockLiquidity(amountToAddLiquidity, ethReceived);
811     }
812 
813     // external util so anyone can easily distribute rewards
814     // must call lockLiquidity first which automatically
815     // calls _rewardLiquidityProviders
816     function rewardLiquidityProviders() external {
817         // lock everything that is lockable
818         lockLiquidity(balanceOf(address(this)));
819     }
820 
821     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
822         // avoid burn by calling super._transfer directly
823         super._transfer(address(this), uniswapV2Pair, liquidityRewards);
824         IUniswapV2Pair(uniswapV2Pair).sync();
825         emit RewardLiquidityProviders(liquidityRewards);
826     }
827 
828     function burnLiquidity() external {
829         uint256 balance = ERC20(uniswapV2Pair).balanceOf(address(this));
830         require(balance != 0, "ERC20TransferLiquidityLock::burnLiquidity: burn amount cannot be 0");
831         ERC20(uniswapV2Pair).transfer(address(0), balance);
832         emit BurnLiquidity(balance);
833     }
834 
835     function swapTokensForEth(uint256 tokenAmount) private {
836         address[] memory uniswapPairPath = new address[](2);
837         uniswapPairPath[0] = address(this);
838         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
839 
840         _approve(address(this), uniswapV2Router, tokenAmount);
841 
842         IUniswapV2Router02(uniswapV2Router)
843             .swapExactTokensForETHSupportingFeeOnTransferTokens(
844                 tokenAmount,
845                 0,
846                 uniswapPairPath,
847                 address(this),
848                 block.timestamp
849             );
850     }
851 
852     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
853         _approve(address(this), uniswapV2Router, tokenAmount);
854 
855         IUniswapV2Router02(uniswapV2Router)
856             .addLiquidityETH
857             .value(ethAmount)(
858                 address(this),
859                 tokenAmount,
860                 0,
861                 0,
862                 address(this),
863                 block.timestamp
864             );
865     }
866 
867     // returns token amount
868     function lockableSupply() external view returns (uint256) {
869         return balanceOf(address(this));
870     }
871 
872     // returns token amount
873     function lockedSupply() external view returns (uint256) {
874         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
875         uint256 lpBalance = lockedLiquidity();
876         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
877 
878         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
879         uint256 _lockedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
880         return _lockedSupply;
881     }
882 
883     // returns token amount
884     function burnedSupply() external view returns (uint256) {
885         uint256 lpTotalSupply = ERC20(uniswapV2Pair).totalSupply();
886         uint256 lpBalance = burnedLiquidity();
887         uint256 percentOfLpTotalSupply = lpBalance.mul(1e12).div(lpTotalSupply);
888 
889         uint256 uniswapBalance = balanceOf(uniswapV2Pair);
890         uint256 _burnedSupply = uniswapBalance.mul(percentOfLpTotalSupply).div(1e12);
891         return _burnedSupply;
892     }
893 
894     // returns LP amount, not token amount
895     function burnableLiquidity() public view returns (uint256) {
896         return ERC20(uniswapV2Pair).balanceOf(address(this));
897     }
898 
899     // returns LP amount, not token amount
900     function burnedLiquidity() public view returns (uint256) {
901         return ERC20(uniswapV2Pair).balanceOf(address(0));
902     }
903 
904     // returns LP amount, not token amount
905     function lockedLiquidity() public view returns (uint256) {
906         return burnableLiquidity().add(burnedLiquidity());
907     }
908 }
909 
910 interface IUniswapV2Router02 {
911     function WETH() external pure returns (address);
912     function swapExactTokensForETHSupportingFeeOnTransferTokens(
913         uint amountIn,
914         uint amountOutMin,
915         address[] calldata path,
916         address to,
917         uint deadline
918     ) external;
919     function addLiquidityETH(
920         address token,
921         uint amountTokenDesired,
922         uint amountTokenMin,
923         uint amountETHMin,
924         address to,
925         uint deadline
926     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
927 }
928 
929 interface IUniswapV2Pair {
930     function sync() external;
931 }
932 
933 // File: contracts/ERC20/ERC20Governance.sol
934 
935 pragma solidity ^0.5.17;
936 
937 
938 
939 contract ERC20Governance is ERC20, ERC20Detailed {
940     using SafeMath for uint256;
941 
942     function _transfer(address from, address to, uint256 amount) internal {
943         _moveDelegates(_delegates[from], _delegates[to], amount);
944         super._transfer(from, to, amount);
945     }
946 
947     function _mint(address account, uint256 amount) internal {
948         _moveDelegates(address(0), _delegates[account], amount);
949         super._mint(account, amount);
950     }
951 
952     function _burn(address account, uint256 amount) internal {
953         _moveDelegates(_delegates[account], address(0), amount);
954         super._burn(account, amount);
955     }
956 
957     // Copied and modified from YAM code:
958     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
959     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
960     // Which is copied and modified from COMPOUND:
961     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
962 
963     /// @notice A record of each accounts delegate
964     mapping (address => address) internal _delegates;
965 
966     /// @notice A checkpoint for marking number of votes from a given block
967     struct Checkpoint {
968         uint32 fromBlock;
969         uint256 votes;
970     }
971 
972     /// @notice A record of votes checkpoints for each account, by index
973     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
974 
975     /// @notice The number of checkpoints for each account
976     mapping (address => uint32) public numCheckpoints;
977 
978     /// @notice The EIP-712 typehash for the contract's domain
979     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
980 
981     /// @notice The EIP-712 typehash for the delegation struct used by the contract
982     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
983 
984     /// @notice A record of states for signing / validating signatures
985     mapping (address => uint) public nonces;
986 
987       /// @notice An event thats emitted when an account changes its delegate
988     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
989 
990     /// @notice An event thats emitted when a delegate account's vote balance changes
991     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
992 
993     /**
994      * @notice Delegate votes from `msg.sender` to `delegatee`
995      * @param delegator The address to get delegatee for
996      */
997     function delegates(address delegator)
998         external
999         view
1000         returns (address)
1001     {
1002         return _delegates[delegator];
1003     }
1004 
1005    /**
1006     * @notice Delegate votes from `msg.sender` to `delegatee`
1007     * @param delegatee The address to delegate votes to
1008     */
1009     function delegate(address delegatee) external {
1010         return _delegate(msg.sender, delegatee);
1011     }
1012 
1013     /**
1014      * @notice Delegates votes from signatory to `delegatee`
1015      * @param delegatee The address to delegate votes to
1016      * @param nonce The contract state required to match the signature
1017      * @param expiry The time at which to expire the signature
1018      * @param v The recovery byte of the signature
1019      * @param r Half of the ECDSA signature pair
1020      * @param s Half of the ECDSA signature pair
1021      */
1022     function delegateBySig(
1023         address delegatee,
1024         uint nonce,
1025         uint expiry,
1026         uint8 v,
1027         bytes32 r,
1028         bytes32 s
1029     )
1030         external
1031     {
1032         bytes32 domainSeparator = keccak256(
1033             abi.encode(
1034                 DOMAIN_TYPEHASH,
1035                 keccak256(bytes(name())),
1036                 getChainId(),
1037                 address(this)
1038             )
1039         );
1040 
1041         bytes32 structHash = keccak256(
1042             abi.encode(
1043                 DELEGATION_TYPEHASH,
1044                 delegatee,
1045                 nonce,
1046                 expiry
1047             )
1048         );
1049 
1050         bytes32 digest = keccak256(
1051             abi.encodePacked(
1052                 "\x19\x01",
1053                 domainSeparator,
1054                 structHash
1055             )
1056         );
1057 
1058         address signatory = ecrecover(digest, v, r, s);
1059         require(signatory != address(0), "ERC20Governance::delegateBySig: invalid signature");
1060         require(nonce == nonces[signatory]++, "ERC20Governance::delegateBySig: invalid nonce");
1061         require(now <= expiry, "ERC20Governance::delegateBySig: signature expired");
1062         return _delegate(signatory, delegatee);
1063     }
1064 
1065     /**
1066      * @notice Gets the current votes balance for `account`
1067      * @param account The address to get votes balance
1068      * @return The number of current votes for `account`
1069      */
1070     function getCurrentVotes(address account)
1071         external
1072         view
1073         returns (uint256)
1074     {
1075         uint32 nCheckpoints = numCheckpoints[account];
1076         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1077     }
1078 
1079     /**
1080      * @notice Determine the prior number of votes for an account as of a block number
1081      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1082      * @param account The address of the account to check
1083      * @param blockNumber The block number to get the vote balance at
1084      * @return The number of votes the account had as of the given block
1085      */
1086     function getPriorVotes(address account, uint blockNumber)
1087         external
1088         view
1089         returns (uint256)
1090     {
1091         require(blockNumber < block.number, "ERC20Governance::getPriorVotes: not yet determined");
1092 
1093         uint32 nCheckpoints = numCheckpoints[account];
1094         if (nCheckpoints == 0) {
1095             return 0;
1096         }
1097 
1098         // First check most recent balance
1099         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1100             return checkpoints[account][nCheckpoints - 1].votes;
1101         }
1102 
1103         // Next check implicit zero balance
1104         if (checkpoints[account][0].fromBlock > blockNumber) {
1105             return 0;
1106         }
1107 
1108         uint32 lower = 0;
1109         uint32 upper = nCheckpoints - 1;
1110         while (upper > lower) {
1111             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1112             Checkpoint memory cp = checkpoints[account][center];
1113             if (cp.fromBlock == blockNumber) {
1114                 return cp.votes;
1115             } else if (cp.fromBlock < blockNumber) {
1116                 lower = center;
1117             } else {
1118                 upper = center - 1;
1119             }
1120         }
1121         return checkpoints[account][lower].votes;
1122     }
1123 
1124     function _delegate(address delegator, address delegatee)
1125         internal
1126     {
1127         address currentDelegate = _delegates[delegator];
1128         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying ERC20Governances (not scaled);
1129         _delegates[delegator] = delegatee;
1130 
1131         emit DelegateChanged(delegator, currentDelegate, delegatee);
1132 
1133         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1134     }
1135 
1136     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1137         if (srcRep != dstRep && amount > 0) {
1138             if (srcRep != address(0)) {
1139                 // decrease old representative
1140                 uint32 srcRepNum = numCheckpoints[srcRep];
1141                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1142                 uint256 srcRepNew = srcRepOld.sub(amount);
1143                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1144             }
1145 
1146             if (dstRep != address(0)) {
1147                 // increase new representative
1148                 uint32 dstRepNum = numCheckpoints[dstRep];
1149                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1150                 uint256 dstRepNew = dstRepOld.add(amount);
1151                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1152             }
1153         }
1154     }
1155 
1156     function _writeCheckpoint(
1157         address delegatee,
1158         uint32 nCheckpoints,
1159         uint256 oldVotes,
1160         uint256 newVotes
1161     )
1162         internal
1163     {
1164         uint32 blockNumber = safe32(block.number, "ERC20Governance::_writeCheckpoint: block number exceeds 32 bits");
1165 
1166         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1167             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1168         } else {
1169             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1170             numCheckpoints[delegatee] = nCheckpoints + 1;
1171         }
1172 
1173         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1174     }
1175 
1176     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1177         require(n < 2**32, errorMessage);
1178         return uint32(n);
1179     }
1180 
1181     function getChainId() internal pure returns (uint) {
1182         uint256 chainId;
1183         assembly { chainId := chainid() }
1184         return chainId;
1185     }
1186 }
1187 
1188 // File: contracts/RugProofToken.sol
1189 
1190 pragma solidity ^0.5.17;
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 contract RugProofToken is
1200     ERC20,
1201     ERC20Detailed("Rug Proof Token", "RPT", 18),
1202     ERC20Burnable,
1203     ERC20Mintable,
1204     // governance must be before transfer liquidity lock
1205     // or delegates are not updated correctly
1206     ERC20Governance,
1207     ERC20TransferLiquidityLock,
1208     WhitelistAdminRole
1209 {
1210     function setUniswapV2Router(address _uniswapV2Router) public onlyWhitelistAdmin {
1211         require(uniswapV2Router == address(0), "RugProofToken::setUniswapV2Router: already set");
1212         uniswapV2Router = _uniswapV2Router;
1213     }
1214 
1215     function setUniswapV2Pair(address _uniswapV2Pair) public onlyWhitelistAdmin {
1216         require(uniswapV2Pair == address(0), "RugProofToken::setUniswapV2Pair: already set");
1217         uniswapV2Pair = _uniswapV2Pair;
1218     }
1219 
1220     function setLiquidityLockDivisor(uint256 _liquidityLockDivisor) public onlyWhitelistAdmin {
1221         if (_liquidityLockDivisor != 0) {
1222             require(_liquidityLockDivisor >= 10, "RugProofToken::setLiquidityLockDivisor: too small");
1223         }
1224         liquidityLockDivisor = _liquidityLockDivisor;
1225     }
1226 
1227     function setLiquidityRewardsDivisor(uint256 _liquidityRewardsDivisor) public onlyWhitelistAdmin {
1228         liquidityRewardsDivisor = _liquidityRewardsDivisor;
1229     }
1230 }