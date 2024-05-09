1 // File: src/main/solidity/zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be aplied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * > Note: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: src/main/solidity/zeppelin-solidity/contracts/token/ERC20/IERC20.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
85  * the optional functions; to access them see `ERC20Detailed`.
86  */
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a `Transfer` event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through `transferFrom`. This is
110      * zero by default.
111      *
112      * This value changes when `approve` or `transferFrom` are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * > Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an `Approval` event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a `Transfer` event.
140      */
141     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to `approve`. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 // File: src/main/solidity/zeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
159 
160 pragma solidity ^0.5.0;
161 
162 
163 /**
164  * @dev Optional functions from the ERC20 standard.
165  */
166 contract ERC20Detailed is IERC20 {
167     string private _name;
168     string private _symbol;
169     uint8 private _decimals;
170 
171     /**
172      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
173      * these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor (string memory name, string memory symbol, uint8 decimals) public {
177         _name = name;
178         _symbol = symbol;
179         _decimals = decimals;
180     }
181 
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() public view returns (string memory) {
186         return _name;
187     }
188 
189     /**
190      * @dev Returns the symbol of the token, usually a shorter version of the
191      * name.
192      */
193     function symbol() public view returns (string memory) {
194         return _symbol;
195     }
196 
197     /**
198      * @dev Returns the number of decimals used to get its user representation.
199      * For example, if `decimals` equals `2`, a balance of `505` tokens should
200      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
201      *
202      * Tokens usually opt for a value of 18, imitating the relationship between
203      * Ether and Wei.
204      *
205      * > Note that this information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * `IERC20.balanceOf` and `IERC20.transfer`.
208      */
209     function decimals() public view returns (uint8) {
210         return _decimals;
211     }
212 }
213 
214 // File: src/main/solidity/zeppelin-solidity/contracts/math/SafeMath.sol
215 
216 pragma solidity ^0.5.0;
217 
218 /**
219  * @dev Wrappers over Solidity's arithmetic operations with added overflow
220  * checks.
221  *
222  * Arithmetic operations in Solidity wrap on overflow. This can easily result
223  * in bugs, because programmers usually assume that an overflow raises an
224  * error, which is the standard behavior in high level programming languages.
225  * `SafeMath` restores this intuition by reverting the transaction when an
226  * operation overflows.
227  *
228  * Using this library instead of the unchecked operations eliminates an entire
229  * class of bugs, so it's recommended to use it always.
230  */
231 library SafeMath {
232     /**
233      * @dev Returns the addition of two unsigned integers, reverting on
234      * overflow.
235      *
236      * Counterpart to Solidity's `+` operator.
237      *
238      * Requirements:
239      * - Addition cannot overflow.
240      */
241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
242         uint256 c = a + b;
243         require(c >= a, "SafeMath: addition overflow");
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      * - Subtraction cannot overflow.
256      */
257     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
258         require(b <= a, "SafeMath: subtraction overflow");
259         uint256 c = a - b;
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the multiplication of two unsigned integers, reverting on
266      * overflow.
267      *
268      * Counterpart to Solidity's `*` operator.
269      *
270      * Requirements:
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         // Solidity only automatically asserts when dividing by 0
300         require(b > 0, "SafeMath: division by zero");
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         require(b != 0, "SafeMath: modulo by zero");
320         return a % b;
321     }
322 }
323 
324 // File: src/main/solidity/zeppelin-solidity/contracts/token/ERC20/ERC20.sol
325 
326 pragma solidity ^0.5.0;
327 
328 
329 
330 /**
331  * @dev Implementation of the `IERC20` interface.
332  *
333  * This implementation is agnostic to the way tokens are created. This means
334  * that a supply mechanism has to be added in a derived contract using `_mint`.
335  * For a generic mechanism see `ERC20Mintable`.
336  *
337  * *For a detailed writeup see our guide [How to implement supply
338  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
339  *
340  * We have followed general OpenZeppelin guidelines: functions revert instead
341  * of returning `false` on failure. This behavior is nonetheless conventional
342  * and does not conflict with the expectations of ERC20 applications.
343  *
344  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
345  * This allows applications to reconstruct the allowance for all accounts just
346  * by listening to said events. Other implementations of the EIP may not emit
347  * these events, as it isn't required by the specification.
348  *
349  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
350  * functions have been added to mitigate the well-known issues around setting
351  * allowances. See `IERC20.approve`.
352  */
353 contract ERC20 is IERC20 {
354     using SafeMath for uint256;
355 
356     mapping (address => uint256) private _balances;
357 
358     mapping (address => mapping (address => uint256)) private _allowances;
359 
360     uint256 private _totalSupply;
361 
362     /**
363      * @dev See `IERC20.totalSupply`.
364      */
365     function totalSupply() public view returns (uint256) {
366         return _totalSupply;
367     }
368 
369     /**
370      * @dev See `IERC20.balanceOf`.
371      */
372     function balanceOf(address account) public view returns (uint256) {
373         return _balances[account];
374     }
375 
376     /**
377      * @dev See `IERC20.transfer`.
378      *
379      * Requirements:
380      *
381      * - `recipient` cannot be the zero address.
382      * - the caller must have a balance of at least `amount`.
383      */
384     function transfer(address recipient, uint256 amount) public returns (bool) {
385         _transfer(msg.sender, recipient, amount);
386         return true;
387     }
388 
389     /**
390      * @dev See `IERC20.allowance`.
391      */
392     function allowance(address owner, address spender) public view returns (uint256) {
393         return _allowances[owner][spender];
394     }
395 
396     /**
397      * @dev See `IERC20.approve`.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function approve(address spender, uint256 value) public returns (bool) {
404         _approve(msg.sender, spender, value);
405         return true;
406     }
407 
408     /**
409      * @dev See `IERC20.transferFrom`.
410      *
411      * Emits an `Approval` event indicating the updated allowance. This is not
412      * required by the EIP. See the note at the beginning of `ERC20`;
413      *
414      * Requirements:
415      * - `sender` and `recipient` cannot be the zero address.
416      * - `sender` must have a balance of at least `value`.
417      * - the caller must have allowance for `sender`'s tokens of at least
418      * `amount`.
419      */
420     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
421         _transfer(sender, recipient, amount);
422         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically increases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to `approve` that can be used as a mitigation for
430      * problems described in `IERC20.approve`.
431      *
432      * Emits an `Approval` event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
439         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
440         return true;
441     }
442 
443     /**
444      * @dev Atomically decreases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to `approve` that can be used as a mitigation for
447      * problems described in `IERC20.approve`.
448      *
449      * Emits an `Approval` event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      * - `spender` must have allowance for the caller of at least
455      * `subtractedValue`.
456      */
457     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
458         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
459         return true;
460     }
461 
462     /**
463      * @dev Moves tokens `amount` from `sender` to `recipient`.
464      *
465      * This is internal function is equivalent to `transfer`, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a `Transfer` event.
469      *
470      * Requirements:
471      *
472      * - `sender` cannot be the zero address.
473      * - `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      */
476     function _transfer(address sender, address recipient, uint256 amount) internal {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _balances[sender] = _balances[sender].sub(amount);
481         _balances[recipient] = _balances[recipient].add(amount);
482         emit Transfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a `Transfer` event with `from` set to the zero address.
489      *
490      * Requirements
491      *
492      * - `to` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _totalSupply = _totalSupply.add(amount);
498         _balances[account] = _balances[account].add(amount);
499         emit Transfer(address(0), account, amount);
500     }
501 
502      /**
503      * @dev Destoys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a `Transfer` event with `to` set to the zero address.
507      *
508      * Requirements
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 value) internal {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _totalSupply = _totalSupply.sub(value);
517         _balances[account] = _balances[account].sub(value);
518         emit Transfer(account, address(0), value);
519     }
520 
521     /**
522      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
523      *
524      * This is internal function is equivalent to `approve`, and can be used to
525      * e.g. set automatic allowances for certain subsystems, etc.
526      *
527      * Emits an `Approval` event.
528      *
529      * Requirements:
530      *
531      * - `owner` cannot be the zero address.
532      * - `spender` cannot be the zero address.
533      */
534     function _approve(address owner, address spender, uint256 value) internal {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = value;
539         emit Approval(owner, spender, value);
540     }
541 
542     /**
543      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
544      * from the caller's allowance.
545      *
546      * See `_burn` and `_approve`.
547      */
548     function _burnFrom(address account, uint256 amount) internal {
549         _burn(account, amount);
550         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
551     }
552 }
553 
554 // File: src/main/solidity/zeppelin-solidity/contracts/access/Roles.sol
555 
556 pragma solidity ^0.5.0;
557 
558 /**
559  * @title Roles
560  * @dev Library for managing addresses assigned to a Role.
561  */
562 library Roles {
563     struct Role {
564         mapping (address => bool) bearer;
565     }
566 
567     /**
568      * @dev Give an account access to this role.
569      */
570     function add(Role storage role, address account) internal {
571         require(!has(role, account), "Roles: account already has role");
572         role.bearer[account] = true;
573     }
574 
575     /**
576      * @dev Remove an account's access to this role.
577      */
578     function remove(Role storage role, address account) internal {
579         require(has(role, account), "Roles: account does not have role");
580         role.bearer[account] = false;
581     }
582 
583     /**
584      * @dev Check if an account has this role.
585      * @return bool
586      */
587     function has(Role storage role, address account) internal view returns (bool) {
588         require(account != address(0), "Roles: account is the zero address");
589         return role.bearer[account];
590     }
591 }
592 
593 // File: src/main/solidity/zeppelin-solidity/contracts/access/roles/MinterRole.sol
594 
595 pragma solidity ^0.5.0;
596 
597 
598 contract MinterRole {
599     using Roles for Roles.Role;
600 
601     event MinterAdded(address indexed account);
602     event MinterRemoved(address indexed account);
603 
604     Roles.Role private _minters;
605 
606     constructor () internal {
607         _addMinter(msg.sender);
608     }
609 
610     modifier onlyMinter() {
611         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
612         _;
613     }
614 
615     function isMinter(address account) public view returns (bool) {
616         return _minters.has(account);
617     }
618 
619     function addMinter(address account) public onlyMinter {
620         _addMinter(account);
621     }
622 
623     function renounceMinter() public {
624         _removeMinter(msg.sender);
625     }
626 
627     function _addMinter(address account) internal {
628         _minters.add(account);
629         emit MinterAdded(account);
630     }
631 
632     function _removeMinter(address account) internal {
633         _minters.remove(account);
634         emit MinterRemoved(account);
635     }
636 }
637 
638 // File: src/main/solidity/zeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
639 
640 pragma solidity ^0.5.0;
641 
642 
643 
644 /**
645  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
646  * which have permission to mint (create) new tokens as they see fit.
647  *
648  * At construction, the deployer of the contract is the only minter.
649  */
650 contract ERC20Mintable is ERC20, MinterRole {
651     /**
652      * @dev See `ERC20._mint`.
653      *
654      * Requirements:
655      *
656      * - the caller must have the `MinterRole`.
657      */
658     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
659         _mint(account, amount);
660         return true;
661     }
662 }
663 
664 // File: src/main/solidity/zeppelin-solidity/contracts/access/roles/PauserRole.sol
665 
666 pragma solidity ^0.5.0;
667 
668 
669 contract PauserRole {
670     using Roles for Roles.Role;
671 
672     event PauserAdded(address indexed account);
673     event PauserRemoved(address indexed account);
674 
675     Roles.Role private _pausers;
676 
677     constructor () internal {
678         _addPauser(msg.sender);
679     }
680 
681     modifier onlyPauser() {
682         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
683         _;
684     }
685 
686     function isPauser(address account) public view returns (bool) {
687         return _pausers.has(account);
688     }
689 
690     function addPauser(address account) public onlyPauser {
691         _addPauser(account);
692     }
693 
694     function renouncePauser() public {
695         _removePauser(msg.sender);
696     }
697 
698     function _addPauser(address account) internal {
699         _pausers.add(account);
700         emit PauserAdded(account);
701     }
702 
703     function _removePauser(address account) internal {
704         _pausers.remove(account);
705         emit PauserRemoved(account);
706     }
707 }
708 
709 // File: src/main/solidity/zeppelin-solidity/contracts/lifecycle/Pausable.sol
710 
711 pragma solidity ^0.5.0;
712 
713 
714 /**
715  * @dev Contract module which allows children to implement an emergency stop
716  * mechanism that can be triggered by an authorized account.
717  *
718  * This module is used through inheritance. It will make available the
719  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
720  * the functions of your contract. Note that they will not be pausable by
721  * simply including this module, only once the modifiers are put in place.
722  */
723 contract Pausable is PauserRole {
724     /**
725      * @dev Emitted when the pause is triggered by a pauser (`account`).
726      */
727     event Paused(address account);
728 
729     /**
730      * @dev Emitted when the pause is lifted by a pauser (`account`).
731      */
732     event Unpaused(address account);
733 
734     bool private _paused;
735 
736     /**
737      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
738      * to the deployer.
739      */
740     constructor () internal {
741         _paused = false;
742     }
743 
744     /**
745      * @dev Returns true if the contract is paused, and false otherwise.
746      */
747     function paused() public view returns (bool) {
748         return _paused;
749     }
750 
751     /**
752      * @dev Modifier to make a function callable only when the contract is not paused.
753      */
754     modifier whenNotPaused() {
755         require(!_paused, "Pausable: paused");
756         _;
757     }
758 
759     /**
760      * @dev Modifier to make a function callable only when the contract is paused.
761      */
762     modifier whenPaused() {
763         require(_paused, "Pausable: not paused");
764         _;
765     }
766 
767     /**
768      * @dev Called by a pauser to pause, triggers stopped state.
769      */
770     function pause() public onlyPauser whenNotPaused {
771         _paused = true;
772         emit Paused(msg.sender);
773     }
774 
775     /**
776      * @dev Called by a pauser to unpause, returns to normal state.
777      */
778     function unpause() public onlyPauser whenPaused {
779         _paused = false;
780         emit Unpaused(msg.sender);
781     }
782 }
783 
784 // File: src/main/solidity/zeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
785 
786 pragma solidity ^0.5.0;
787 
788 
789 
790 /**
791  * @title Pausable token
792  * @dev ERC20 modified with pausable transfers.
793  */
794 contract ERC20Pausable is ERC20, Pausable {
795     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
796         return super.transfer(to, value);
797     }
798 
799     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
800         return super.transferFrom(from, to, value);
801     }
802 
803     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
804         return super.approve(spender, value);
805     }
806 
807     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
808         return super.increaseAllowance(spender, addedValue);
809     }
810 
811     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
812         return super.decreaseAllowance(spender, subtractedValue);
813     }
814 }
815 
816 // File: src/main/solidity/CrowdliToken.sol
817 
818 pragma solidity 0.5.0;
819 
820 
821 
822 
823 
824 /**
825 * @title CrowdliToken
826 */
827 contract CrowdliToken is ERC20Detailed, ERC20Mintable, ERC20Pausable, Ownable {
828 	/**
829 	 * Holds the addresses of the investors
830 	 */
831     address[] public investors;
832 
833     constructor (string memory _name, string memory _symbol, uint8 _decimals) ERC20Detailed(_name,_symbol,_decimals) public {
834     }
835     
836     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
837          if (balanceOf(account) == 0) {
838             investors.push(account);
839          }
840          return super.mint(account, amount);
841     }
842     
843     
844     function initToken(address _directorsBoard,address _crowdliSTO) external onlyOwner{
845     	addMinter(_directorsBoard);
846     	addMinter(_crowdliSTO);
847     	addPauser(_directorsBoard);
848     	addPauser(_crowdliSTO);
849     }
850     
851 }