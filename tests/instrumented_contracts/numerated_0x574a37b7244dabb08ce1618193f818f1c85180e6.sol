1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
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
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SafeMath: subtraction overflow");
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the multiplication of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `*` operator.
56      *
57      * Requirements:
58      * - Multiplication cannot overflow.
59      */
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62         // benefit is lost if 'b' is also tested.
63         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64         if (a == 0) {
65             return 0;
66         }
67 
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the integer division of two unsigned integers. Reverts on
76      * division by zero. The result is rounded towards zero.
77      *
78      * Counterpart to Solidity's `/` operator. Note: this function uses a
79      * `revert` opcode (which leaves remaining gas untouched) while Solidity
80      * uses an invalid opcode to revert (consuming all remaining gas).
81      *
82      * Requirements:
83      * - The divisor cannot be zero.
84      */
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Solidity only automatically asserts when dividing by 0
87         require(b > 0, "SafeMath: division by zero");
88         uint256 c = a / b;
89         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
96      * Reverts when dividing by zero.
97      *
98      * Counterpart to Solidity's `%` operator. This function uses a `revert`
99      * opcode (which leaves remaining gas untouched) while Solidity uses an
100      * invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
106         require(b != 0, "SafeMath: modulo by zero");
107         return a % b;
108     }
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
112 
113 pragma solidity ^0.5.0;
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
117  * the optional functions; to access them see `ERC20Detailed`.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a `Transfer` event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through `transferFrom`. This is
142      * zero by default.
143      *
144      * This value changes when `approve` or `transferFrom` are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * > Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an `Approval` event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to `approve`. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 /**
196  * @dev Optional functions from the ERC20 standard.
197  */
198 contract ERC20Detailed is IERC20 {
199     string private _name;
200     string private _symbol;
201     uint8 private _decimals;
202 
203     /**
204      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
205      * these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor (string memory name, string memory symbol, uint8 decimals) public {
209         _name = name;
210         _symbol = symbol;
211         _decimals = decimals;
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view returns (string memory) {
226         return _symbol;
227     }
228 
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei.
236      *
237      * > Note that this information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * `IERC20.balanceOf` and `IERC20.transfer`.
240      */
241     function decimals() public view returns (uint8) {
242         return _decimals;
243     }
244 }
245 
246 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
247 
248 pragma solidity ^0.5.0;
249 
250 
251 
252 /**
253  * @dev Implementation of the `IERC20` interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using `_mint`.
257  * For a generic mechanism see `ERC20Mintable`.
258  *
259  * *For a detailed writeup see our guide [How to implement supply
260  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
261  *
262  * We have followed general OpenZeppelin guidelines: functions revert instead
263  * of returning `false` on failure. This behavior is nonetheless conventional
264  * and does not conflict with the expectations of ERC20 applications.
265  *
266  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See `IERC20.approve`.
274  */
275 contract ERC20 is IERC20 {
276     using SafeMath for uint256;
277 
278     mapping (address => uint256) private _balances;
279 
280     mapping (address => mapping (address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     /**
285      * @dev See `IERC20.totalSupply`.
286      */
287     function totalSupply() public view returns (uint256) {
288         return _totalSupply;
289     }
290 
291     /**
292      * @dev See `IERC20.balanceOf`.
293      */
294     function balanceOf(address account) public view returns (uint256) {
295         return _balances[account];
296     }
297 
298     /**
299      * @dev See `IERC20.transfer`.
300      *
301      * Requirements:
302      *
303      * - `recipient` cannot be the zero address.
304      * - the caller must have a balance of at least `amount`.
305      */
306     function transfer(address recipient, uint256 amount) public returns (bool) {
307         _transfer(msg.sender, recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See `IERC20.allowance`.
313      */
314     function allowance(address owner, address spender) public view returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See `IERC20.approve`.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 value) public returns (bool) {
326         _approve(msg.sender, spender, value);
327         return true;
328     }
329 
330     /**
331      * @dev See `IERC20.transferFrom`.
332      *
333      * Emits an `Approval` event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of `ERC20`;
335      *
336      * Requirements:
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `value`.
339      * - the caller must have allowance for `sender`'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
345         return true;
346     }
347 
348     /**
349      * @dev Atomically increases the allowance granted to `spender` by the caller.
350      *
351      * This is an alternative to `approve` that can be used as a mitigation for
352      * problems described in `IERC20.approve`.
353      *
354      * Emits an `Approval` event indicating the updated allowance.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
361         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically decreases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to `approve` that can be used as a mitigation for
369      * problems described in `IERC20.approve`.
370      *
371      * Emits an `Approval` event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      * - `spender` must have allowance for the caller of at least
377      * `subtractedValue`.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
380         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Moves tokens `amount` from `sender` to `recipient`.
386      *
387      * This is internal function is equivalent to `transfer`, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a `Transfer` event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(address sender, address recipient, uint256 amount) internal {
399         require(sender != address(0), "ERC20: transfer from the zero address");
400         require(recipient != address(0), "ERC20: transfer to the zero address");
401 
402         _balances[sender] = _balances[sender].sub(amount);
403         _balances[recipient] = _balances[recipient].add(amount);
404         emit Transfer(sender, recipient, amount);
405     }
406 
407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
408      * the total supply.
409      *
410      * Emits a `Transfer` event with `from` set to the zero address.
411      *
412      * Requirements
413      *
414      * - `to` cannot be the zero address.
415      */
416     function _mint(address account, uint256 amount) internal {
417         require(account != address(0), "ERC20: mint to the zero address");
418 
419         _totalSupply = _totalSupply.add(amount);
420         _balances[account] = _balances[account].add(amount);
421         emit Transfer(address(0), account, amount);
422     }
423 
424      /**
425      * @dev Destoys `amount` tokens from `account`, reducing the
426      * total supply.
427      *
428      * Emits a `Transfer` event with `to` set to the zero address.
429      *
430      * Requirements
431      *
432      * - `account` cannot be the zero address.
433      * - `account` must have at least `amount` tokens.
434      */
435     function _burn(address account, uint256 value) internal {
436         require(account != address(0), "ERC20: burn from the zero address");
437 
438         _totalSupply = _totalSupply.sub(value);
439         _balances[account] = _balances[account].sub(value);
440         emit Transfer(account, address(0), value);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
445      *
446      * This is internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an `Approval` event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(address owner, address spender, uint256 value) internal {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = value;
461         emit Approval(owner, spender, value);
462     }
463 
464     /**
465      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
466      * from the caller's allowance.
467      *
468      * See `_burn` and `_approve`.
469      */
470     function _burnFrom(address account, uint256 amount) internal {
471         _burn(account, amount);
472         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
473     }
474 }
475 
476 // File: openzeppelin-solidity/contracts/access/Roles.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /**
481  * @title Roles
482  * @dev Library for managing addresses assigned to a Role.
483  */
484 library Roles {
485     struct Role {
486         mapping (address => bool) bearer;
487     }
488 
489     /**
490      * @dev Give an account access to this role.
491      */
492     function add(Role storage role, address account) internal {
493         require(!has(role, account), "Roles: account already has role");
494         role.bearer[account] = true;
495     }
496 
497     /**
498      * @dev Remove an account's access to this role.
499      */
500     function remove(Role storage role, address account) internal {
501         require(has(role, account), "Roles: account does not have role");
502         role.bearer[account] = false;
503     }
504 
505     /**
506      * @dev Check if an account has this role.
507      * @return bool
508      */
509     function has(Role storage role, address account) internal view returns (bool) {
510         require(account != address(0), "Roles: account is the zero address");
511         return role.bearer[account];
512     }
513 }
514 
515 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
516 
517 pragma solidity ^0.5.0;
518 
519 
520 contract PauserRole {
521     using Roles for Roles.Role;
522 
523     event PauserAdded(address indexed account);
524     event PauserRemoved(address indexed account);
525 
526     Roles.Role private _pausers;
527 
528     constructor () internal {
529         _addPauser(msg.sender);
530     }
531 
532     modifier onlyPauser() {
533         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
534         _;
535     }
536 
537     function isPauser(address account) public view returns (bool) {
538         return _pausers.has(account);
539     }
540 
541     function addPauser(address account) public onlyPauser {
542         _addPauser(account);
543     }
544 
545     function renouncePauser() public {
546         _removePauser(msg.sender);
547     }
548 
549     function _addPauser(address account) internal {
550         _pausers.add(account);
551         emit PauserAdded(account);
552     }
553 
554     function _removePauser(address account) internal {
555         _pausers.remove(account);
556         emit PauserRemoved(account);
557     }
558 }
559 
560 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 /**
566  * @dev Contract module which allows children to implement an emergency stop
567  * mechanism that can be triggered by an authorized account.
568  *
569  * This module is used through inheritance. It will make available the
570  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
571  * the functions of your contract. Note that they will not be pausable by
572  * simply including this module, only once the modifiers are put in place.
573  */
574 contract Pausable is PauserRole {
575     /**
576      * @dev Emitted when the pause is triggered by a pauser (`account`).
577      */
578     event Paused(address account);
579 
580     /**
581      * @dev Emitted when the pause is lifted by a pauser (`account`).
582      */
583     event Unpaused(address account);
584 
585     bool private _paused;
586 
587     /**
588      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
589      * to the deployer.
590      */
591     constructor () internal {
592         _paused = false;
593     }
594 
595     /**
596      * @dev Returns true if the contract is paused, and false otherwise.
597      */
598     function paused() public view returns (bool) {
599         return _paused;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is not paused.
604      */
605     modifier whenNotPaused() {
606         require(!_paused, "Pausable: paused");
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      */
613     modifier whenPaused() {
614         require(_paused, "Pausable: not paused");
615         _;
616     }
617 
618     /**
619      * @dev Called by a pauser to pause, triggers stopped state.
620      */
621     function pause() public onlyPauser whenNotPaused {
622         _paused = true;
623         emit Paused(msg.sender);
624     }
625 
626     /**
627      * @dev Called by a pauser to unpause, returns to normal state.
628      */
629     function unpause() public onlyPauser whenPaused {
630         _paused = false;
631         emit Unpaused(msg.sender);
632     }
633 }
634 
635 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
636 
637 pragma solidity ^0.5.0;
638 
639 
640 
641 /**
642  * @title Pausable token
643  * @dev ERC20 modified with pausable transfers.
644  */
645 contract ERC20Pausable is ERC20, Pausable {
646     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
647         return super.transfer(to, value);
648     }
649 
650     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
651         return super.transferFrom(from, to, value);
652     }
653 
654     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
655         return super.approve(spender, value);
656     }
657 
658     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
659         return super.increaseAllowance(spender, addedValue);
660     }
661 
662     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
663         return super.decreaseAllowance(spender, subtractedValue);
664     }
665 }
666 
667 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
668 
669 pragma solidity ^0.5.0;
670 
671 
672 contract MinterRole {
673     using Roles for Roles.Role;
674 
675     event MinterAdded(address indexed account);
676     event MinterRemoved(address indexed account);
677 
678     Roles.Role private _minters;
679 
680     constructor () internal {
681         _addMinter(msg.sender);
682     }
683 
684     modifier onlyMinter() {
685         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
686         _;
687     }
688 
689     function isMinter(address account) public view returns (bool) {
690         return _minters.has(account);
691     }
692 
693     function addMinter(address account) public onlyMinter {
694         _addMinter(account);
695     }
696 
697     function renounceMinter() public {
698         _removeMinter(msg.sender);
699     }
700 
701     function _addMinter(address account) internal {
702         _minters.add(account);
703         emit MinterAdded(account);
704     }
705 
706     function _removeMinter(address account) internal {
707         _minters.remove(account);
708         emit MinterRemoved(account);
709     }
710 }
711 
712 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
713 
714 pragma solidity ^0.5.0;
715 
716 
717 
718 /**
719  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
720  * which have permission to mint (create) new tokens as they see fit.
721  *
722  * At construction, the deployer of the contract is the only minter.
723  */
724 contract ERC20Mintable is ERC20, MinterRole {
725     /**
726      * @dev See `ERC20._mint`.
727      *
728      * Requirements:
729      *
730      * - the caller must have the `MinterRole`.
731      */
732     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
733         _mint(account, amount);
734         return true;
735     }
736 }
737 
738 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
739 
740 pragma solidity ^0.5.0;
741 
742 /**
743  * @dev Contract module which provides a basic access control mechanism, where
744  * there is an account (an owner) that can be granted exclusive access to
745  * specific functions.
746  *
747  * This module is used through inheritance. It will make available the modifier
748  * `onlyOwner`, which can be aplied to your functions to restrict their use to
749  * the owner.
750  */
751 contract Ownable {
752     address private _owner;
753 
754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
755 
756     /**
757      * @dev Initializes the contract setting the deployer as the initial owner.
758      */
759     constructor () internal {
760         _owner = msg.sender;
761         emit OwnershipTransferred(address(0), _owner);
762     }
763 
764     /**
765      * @dev Returns the address of the current owner.
766      */
767     function owner() public view returns (address) {
768         return _owner;
769     }
770 
771     /**
772      * @dev Throws if called by any account other than the owner.
773      */
774     modifier onlyOwner() {
775         require(isOwner(), "Ownable: caller is not the owner");
776         _;
777     }
778 
779     /**
780      * @dev Returns true if the caller is the current owner.
781      */
782     function isOwner() public view returns (bool) {
783         return msg.sender == _owner;
784     }
785 
786     /**
787      * @dev Leaves the contract without owner. It will not be possible to call
788      * `onlyOwner` functions anymore. Can only be called by the current owner.
789      *
790      * > Note: Renouncing ownership will leave the contract without an owner,
791      * thereby removing any functionality that is only available to the owner.
792      */
793     function renounceOwnership() public onlyOwner {
794         emit OwnershipTransferred(_owner, address(0));
795         _owner = address(0);
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public onlyOwner {
803         _transferOwnership(newOwner);
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      */
809     function _transferOwnership(address newOwner) internal {
810         require(newOwner != address(0), "Ownable: new owner is the zero address");
811         emit OwnershipTransferred(_owner, newOwner);
812         _owner = newOwner;
813     }
814 }
815 
816 // File: contracts/whitelist/IWhitelist.sol
817 
818 pragma solidity ^0.5.0;
819 
820 
821 // Interface to be implemented by the Whitelist contract.
822 contract IWhitelist {
823     function isWhitelisted(address account) public view returns (bool);
824 }
825 
826 // File: contracts/token/BurnerRole.sol
827 
828 pragma solidity ^0.5.0;
829 
830 
831 
832 contract BurnerRole {
833     using Roles for Roles.Role;
834 
835     event BurnerAdded(address indexed account);
836     event BurnerRemoved(address indexed account);
837 
838     Roles.Role private _burners;
839 
840     constructor () internal {
841         _addBurner(msg.sender);
842     }
843 
844     modifier onlyBurner() {
845         require(isBurner(msg.sender));
846         _;
847     }
848 
849     function isBurner(address account) public view returns (bool) {
850         return _burners.has(account);
851     }
852 
853     function addBurner(address account) public onlyBurner {
854         _addBurner(account);
855     }
856 
857     function renounceBurner() public {
858         _removeBurner(msg.sender);
859     }
860 
861     function _addBurner(address account) internal {
862         _burners.add(account);
863         emit BurnerAdded(account);
864     }
865 
866     function _removeBurner(address account) internal {
867         _burners.remove(account);
868         emit BurnerRemoved(account);
869     }
870 }
871 
872 // File: contracts/token/ERC20Burnable.sol
873 
874 pragma solidity ^0.5.0;
875 
876 
877 
878 
879 // Only allow accounts with the burner role to burn tokens.
880 contract ERC20Burnable is ERC20, BurnerRole {
881     function burn(uint256 value) public onlyBurner() {
882         _burn(msg.sender, value);
883     }
884 
885     function burnFrom(address from, uint256 value) public onlyBurner() {
886         _burnFrom(from, value);
887     }
888 }
889 
890 // File: contracts/token/ERC20Whitelistable.sol
891 
892 pragma solidity ^0.5.0;
893 
894 
895 
896 
897 
898 
899 // Disallow transfers of the token to or from blacklisted accounts.
900 contract ERC20Whitelistable is ERC20Mintable, ERC20Burnable, Ownable {
901     event WhitelistChanged(IWhitelist indexed account);
902 
903     IWhitelist public whitelist;
904 
905     function setWhitelist(IWhitelist _whitelist) public onlyOwner {
906         whitelist = _whitelist;
907         emit WhitelistChanged(_whitelist);
908     }
909 
910     modifier onlyWhitelisted(address account) {
911         require(isWhitelisted(account));
912         _;
913     }
914 
915     modifier notWhitelisted(address account) {
916         require(!isWhitelisted(account));
917         _;
918     }
919 
920     // Returns true if the account is allowed to send and receive tokens.
921     function isWhitelisted(address account) public view returns (bool) {
922         return whitelist.isWhitelisted(account);
923     }
924 
925     function transfer(address to, uint256 value)
926         public
927         onlyWhitelisted(msg.sender)
928         onlyWhitelisted(to)
929         returns (bool)
930     {
931         return super.transfer(to, value);
932     }
933 
934     function transferFrom(address from, address to, uint256 value)
935         public
936         onlyWhitelisted(from)
937         onlyWhitelisted(to)
938         returns (bool)
939     {
940         return super.transferFrom(from, to, value);
941     }
942 
943     function mint(address to, uint256 value) public onlyWhitelisted(to) returns (bool) {
944         return super.mint(to, value);
945     }
946 
947     // Destroy the tokens held by a blacklisted account.
948     function burnBlacklisted(address from, uint256 value)
949         public
950         onlyBurner()
951         notWhitelisted(from)
952     {
953         _burn(from, value);
954     }
955 }
956 
957 // File: contracts/utils/CanReclaimEther.sol
958 
959 pragma solidity ^0.5.0;
960 
961 
962 
963 // Ether should not be sent to this contract. If any ether is accidentally sent to this
964 // contract, allow the contract owner to recover it.
965 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/2441fd7d17bffa1944f6f539b2cddd6d19997a31/contracts/ownership/HasNoEther.sol
966 contract CanReclaimEther is Ownable {
967     function reclaimEther() external onlyOwner {
968         msg.sender.transfer(address(this).balance);
969     }
970 }
971 
972 // File: openzeppelin-solidity/contracts/utils/Address.sol
973 
974 pragma solidity ^0.5.0;
975 
976 /**
977  * @dev Collection of functions related to the address type,
978  */
979 library Address {
980     /**
981      * @dev Returns true if `account` is a contract.
982      *
983      * This test is non-exhaustive, and there may be false-negatives: during the
984      * execution of a contract's constructor, its address will be reported as
985      * not containing a contract.
986      *
987      * > It is unsafe to assume that an address for which this function returns
988      * false is an externally-owned account (EOA) and not a contract.
989      */
990     function isContract(address account) internal view returns (bool) {
991         // This method relies in extcodesize, which returns 0 for contracts in
992         // construction, since the code is only stored at the end of the
993         // constructor execution.
994 
995         uint256 size;
996         // solhint-disable-next-line no-inline-assembly
997         assembly { size := extcodesize(account) }
998         return size > 0;
999     }
1000 }
1001 
1002 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1003 
1004 pragma solidity ^0.5.0;
1005 
1006 
1007 
1008 
1009 /**
1010  * @title SafeERC20
1011  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1012  * contract returns false). Tokens that return no value (and instead revert or
1013  * throw on failure) are also supported, non-reverting calls are assumed to be
1014  * successful.
1015  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1016  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1017  */
1018 library SafeERC20 {
1019     using SafeMath for uint256;
1020     using Address for address;
1021 
1022     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1023         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1024     }
1025 
1026     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1027         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1028     }
1029 
1030     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1031         // safeApprove should only be called when setting an initial allowance,
1032         // or when resetting it to zero. To increase and decrease it, use
1033         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1034         // solhint-disable-next-line max-line-length
1035         require((value == 0) || (token.allowance(address(this), spender) == 0),
1036             "SafeERC20: approve from non-zero to non-zero allowance"
1037         );
1038         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1039     }
1040 
1041     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1042         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1043         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1044     }
1045 
1046     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1047         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
1048         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1049     }
1050 
1051     /**
1052      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1053      * on the return value: the return value is optional (but if data is returned, it must not be false).
1054      * @param token The token targeted by the call.
1055      * @param data The call data (encoded using abi.encode or one of its variants).
1056      */
1057     function callOptionalReturn(IERC20 token, bytes memory data) private {
1058         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1059         // we're implementing it ourselves.
1060 
1061         // A Solidity high level call has three parts:
1062         //  1. The target address is checked to verify it contains contract code
1063         //  2. The call itself is made, and success asserted
1064         //  3. The return value is decoded, which in turn checks the size of the returned data.
1065         // solhint-disable-next-line max-line-length
1066         require(address(token).isContract(), "SafeERC20: call to non-contract");
1067 
1068         // solhint-disable-next-line avoid-low-level-calls
1069         (bool success, bytes memory returndata) = address(token).call(data);
1070         require(success, "SafeERC20: low-level call failed");
1071 
1072         if (returndata.length > 0) { // Return data is optional
1073             // solhint-disable-next-line max-line-length
1074             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1075         }
1076     }
1077 }
1078 
1079 // File: contracts/utils/CanReclaimToken.sol
1080 
1081 pragma solidity ^0.5.0;
1082 
1083 
1084 
1085 
1086 // Tokens should not be sent to this contract.  If any tokens are accidentally sent to
1087 // this contract, allow the contract owner to recover them.
1088 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/6c4c8989b399510a66d8b98ad75a0979482436d2/contracts/ownership/CanReclaimToken.sol
1089 contract CanReclaimToken is Ownable {
1090     using SafeERC20 for IERC20;
1091 
1092     function reclaimToken(IERC20 token) external onlyOwner {
1093         uint256 balance = token.balanceOf(address(this));
1094         token.safeTransfer(owner(), balance);
1095     }
1096 }
1097 
1098 // File: contracts/token/LeveragedToken.sol
1099 
1100 pragma solidity ^0.5.0;
1101 
1102 
1103 
1104 
1105 
1106 
1107 
1108 
1109 
1110 
1111 contract LeveragedToken is
1112     ERC20Detailed,
1113     ERC20Pausable,
1114     ERC20Mintable,
1115     ERC20Burnable,
1116     ERC20Whitelistable,
1117     CanReclaimEther,
1118     CanReclaimToken
1119 {
1120     string public underlying;
1121     int8 public leverage;
1122 
1123     constructor(string memory name, string memory symbol, string memory _underlying, int8 _leverage)
1124         ERC20Detailed(name, symbol, 18)
1125         public
1126     {
1127         underlying = _underlying;
1128         leverage = _leverage;
1129     }
1130 }