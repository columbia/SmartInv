1 // File: contracts/libs/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/libs/Ownable.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Contract module which provides a basic access control mechanism, where
86  * there is an account (an owner) that can be granted exclusive access to
87  * specific functions.
88  *
89  * This module is used through inheritance. It will make available the modifier
90  * `onlyOwner`, which can be aplied to your functions to restrict their use to
91  * the owner.
92  */
93 contract Ownable {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev Initializes the contract setting the deployer as the initial owner.
100      */
101     constructor () internal {
102         _owner = msg.sender;
103         emit OwnershipTransferred(address(0), _owner);
104     }
105 
106     /**
107      * @dev Returns the address of the current owner.
108      */
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner(), "Ownable: caller is not the owner");
118         _;
119     }
120 
121     /**
122      * @dev Returns true if the caller is the current owner.
123      */
124     function isOwner() public view returns (bool) {
125         return msg.sender == _owner;
126     }
127 
128     /**
129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
130      * Can only be called by the current owner.
131      */
132     function transferOwnership(address newOwner) public onlyOwner {
133         _transferOwnership(newOwner);
134     }
135 
136     /**
137      * @dev Transfers ownership of the contract to a new account (`newOwner`).
138      */
139     function _transferOwnership(address newOwner) internal {
140         require(newOwner != address(0), "Ownable: new owner is the zero address");
141         emit OwnershipTransferred(_owner, newOwner);
142         _owner = newOwner;
143     }
144 }
145 
146 // File: contracts/libs/ERC20Detailed.sol
147 
148 pragma solidity ^0.5.0;
149 
150 
151 /**
152  * @dev Optional functions from the ERC20 standard.
153  */
154 contract ERC20Detailed is IERC20, Ownable {
155     string private _name;
156     string private _symbol;
157     uint8 private _decimals;
158 
159     /**
160      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
161      * these values are immutable: they can only be set once during
162      * construction.
163      */
164     constructor (string memory name, string memory symbol, uint8 decimals) public {
165         _name = name;
166         _symbol = symbol;
167         _decimals = decimals;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view returns (string memory) {
182         return _symbol;
183     }
184 
185     /**
186      * @dev Returns the number of decimals used to get its user representation.
187      * For example, if `decimals` equals `2`, a balance of `505` tokens should
188      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
189      *
190      * Tokens usually opt for a value of 18, imitating the relationship between
191      * Ether and Wei.
192      *
193      * > Note that this information is only used for _display_ purposes: it in
194      * no way affects any of the arithmetic of the contract, including
195      * `IERC20.balanceOf` and `IERC20.transfer`.
196      */
197     function decimals() public view returns (uint8) {
198         return _decimals;
199     }
200 
201     /**
202      * @dev change new name.
203      * @param newname new name.
204      * @return the new name of the token.
205      */
206     function changeName(string memory newname) public onlyOwner returns(string memory){
207         _name = newname;
208         return _name;
209     }
210 }
211 
212 // File: contracts/libs/SafeMath.sol
213 
214 pragma solidity ^0.5.0;
215 
216 /**
217  * @dev Wrappers over Solidity's arithmetic operations with added overflow
218  * checks.
219  *
220  * Arithmetic operations in Solidity wrap on overflow. This can easily result
221  * in bugs, because programmers usually assume that an overflow raises an
222  * error, which is the standard behavior in high level programming languages.
223  * `SafeMath` restores this intuition by reverting the transaction when an
224  * operation overflows.
225  *
226  * Using this library instead of the unchecked operations eliminates an entire
227  * class of bugs, so it's recommended to use it always.
228  */
229 library SafeMath {
230     /**
231      * @dev Returns the addition of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `+` operator.
235      *
236      * Requirements:
237      * - Addition cannot overflow.
238      */
239     function add(uint256 a, uint256 b) internal pure returns (uint256) {
240         uint256 c = a + b;
241         require(c >= a, "SafeMath: addition overflow");
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      * - Subtraction cannot overflow.
254      */
255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
256         require(b <= a, "SafeMath: subtraction overflow");
257         uint256 c = a - b;
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the multiplication of two unsigned integers, reverting on
264      * overflow.
265      *
266      * Counterpart to Solidity's `*` operator.
267      *
268      * Requirements:
269      * - Multiplication cannot overflow.
270      */
271     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
272         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
273         // benefit is lost if 'b' is also tested.
274         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
275         if (a == 0) {
276             return 0;
277         }
278 
279         uint256 c = a * b;
280         require(c / a == b, "SafeMath: multiplication overflow");
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         // Solidity only automatically asserts when dividing by 0
298         require(b > 0, "SafeMath: division by zero");
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b != 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 }
321 
322 // File: contracts/libs/ERC20.sol
323 
324 pragma solidity ^0.5.0;
325 
326 
327 
328 /**
329  * @dev Implementation of the `IERC20` interface.
330  *
331  * This implementation is agnostic to the way tokens are created. This means
332  * that a supply mechanism has to be added in a derived contract using `_mint`.
333  * For a generic mechanism see `ERC20Mintable`.
334  *
335  * *For a detailed writeup see our guide [How to implement supply
336  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
337  *
338  * We have followed general OpenZeppelin guidelines: functions revert instead
339  * of returning `false` on failure. This behavior is nonetheless conventional
340  * and does not conflict with the expectations of ERC20 applications.
341  *
342  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
343  * This allows applications to reconstruct the allowance for all accounts just
344  * by listening to said events. Other implementations of the EIP may not emit
345  * these events, as it isn't required by the specification.
346  *
347  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
348  * functions have been added to mitigate the well-known issues around setting
349  * allowances. See `IERC20.approve`.
350  */
351 contract ERC20 is IERC20 {
352     using SafeMath for uint256;
353 
354     mapping (address => uint256) private _balances;
355 
356     mapping (address => mapping (address => uint256)) private _allowances;
357 
358     uint256 private _totalSupply;
359 
360     /**
361      * @dev See `IERC20.totalSupply`.
362      */
363     function totalSupply() public view returns (uint256) {
364         return _totalSupply;
365     }
366 
367     /**
368      * @dev See `IERC20.balanceOf`.
369      */
370     function balanceOf(address account) public view returns (uint256) {
371         return _balances[account];
372     }
373 
374     /**
375      * @dev See `IERC20.transfer`.
376      *
377      * Requirements:
378      *
379      * - `recipient` cannot be the zero address.
380      * - the caller must have a balance of at least `amount`.
381      */
382     function transfer(address recipient, uint256 amount) public returns (bool) {
383         _transfer(msg.sender, recipient, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See `IERC20.allowance`.
389      */
390     function allowance(address owner, address spender) public view returns (uint256) {
391         return _allowances[owner][spender];
392     }
393 
394     /**
395      * @dev See `IERC20.approve`.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 value) public returns (bool) {
402         _approve(msg.sender, spender, value);
403         return true;
404     }
405 
406     /**
407      * @dev See `IERC20.transferFrom`.
408      *
409      * Emits an `Approval` event indicating the updated allowance. This is not
410      * required by the EIP. See the note at the beginning of `ERC20`;
411      *
412      * Requirements:
413      * - `sender` and `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `value`.
415      * - the caller must have allowance for `sender`'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
419         _transfer(sender, recipient, amount);
420         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to `approve` that can be used as a mitigation for
428      * problems described in `IERC20.approve`.
429      *
430      * Emits an `Approval` event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
437         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
438         return true;
439     }
440 
441     /**
442      * @dev Atomically decreases the allowance granted to `spender` by the caller.
443      *
444      * This is an alternative to `approve` that can be used as a mitigation for
445      * problems described in `IERC20.approve`.
446      *
447      * Emits an `Approval` event indicating the updated allowance.
448      *
449      * Requirements:
450      *
451      * - `spender` cannot be the zero address.
452      * - `spender` must have allowance for the caller of at least
453      * `subtractedValue`.
454      */
455     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
456         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
457         return true;
458     }
459 
460     /**
461      * @dev Moves tokens `amount` from `sender` to `recipient`.
462      *
463      * This is internal function is equivalent to `transfer`, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a `Transfer` event.
467      *
468      * Requirements:
469      *
470      * - `sender` cannot be the zero address.
471      * - `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      */
474     function _transfer(address sender, address recipient, uint256 amount) internal {
475         require(sender != address(0), "ERC20: transfer from the zero address");
476         require(recipient != address(0), "ERC20: transfer to the zero address");
477 
478         _balances[sender] = _balances[sender].sub(amount);
479         _balances[recipient] = _balances[recipient].add(amount);
480         emit Transfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a `Transfer` event with `from` set to the zero address.
487      *
488      * Requirements
489      *
490      * - `to` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _totalSupply = _totalSupply.add(amount);
496         _balances[account] = _balances[account].add(amount);
497         emit Transfer(address(0), account, amount);
498     }
499 
500      /**
501      * @dev Destoys `amount` tokens from `account`, reducing the
502      * total supply.
503      *
504      * Emits a `Transfer` event with `to` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `account` cannot be the zero address.
509      * - `account` must have at least `amount` tokens.
510      */
511     function _burn(address account, uint256 value) internal {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514         _totalSupply = _totalSupply.sub(value);
515         _balances[account] = _balances[account].sub(value);
516         emit Transfer(account, address(0), value);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
521      *
522      * This is internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an `Approval` event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(address owner, address spender, uint256 value) internal {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = value;
537         emit Approval(owner, spender, value);
538     }
539 
540     /**
541      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
542      * from the caller's allowance.
543      *
544      * See `_burn` and `_approve`.
545      */
546     function _burnFrom(address account, uint256 amount) internal {
547         _burn(account, amount);
548         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
549     }
550 }
551 
552 // File: contracts/libs/Roles.sol
553 
554 pragma solidity ^0.5.0;
555 
556 /**
557  * @title Roles
558  * @dev Library for managing addresses assigned to a Role.
559  */
560 library Roles {
561     struct Role {
562         mapping (address => bool) bearer;
563         uint activate;
564     }
565     uint constant  minOfOwner = 1;
566     /**
567      * @dev Give an account access to this role.
568      */
569     function add(Role storage role, address account) internal {
570         require(!has(role, account), "Roles: account already has role");
571         role.bearer[account] = true;
572         role.activate += 1;
573     }
574 
575     /**
576      * @dev Remove an account's access to this role.
577      */
578     function remove(Role storage role, address account) internal {
579         require(has(role, account), "Roles: account does not have role");
580         require(moreThenOneOwner(role), "Owner: only one");
581         role.bearer[account] = false;
582         role.activate -= 1;
583     }
584 
585     /**
586      * @dev Check if an account has this role.
587      * @return bool
588      */
589     function has(Role storage role, address account) internal view returns (bool) {
590         require(account != address(0), "Roles: account is the zero address");
591         return role.bearer[account];
592     }
593 
594     /**
595      * @dev Check more than one owner.
596      */
597     function moreThenOneOwner(Role storage role) internal view returns (bool){
598         if(role.activate > minOfOwner)
599             return true;
600         else
601             return false;
602     }
603 }
604 
605 // File: contracts/libs/MinterRole.sol
606 
607 pragma solidity ^0.5.0;
608 
609 
610 contract MinterRole {
611     using Roles for Roles.Role;
612 
613     event MinterAdded(address indexed account);
614     event MinterRemoved(address indexed account);
615 
616     Roles.Role private _minters;
617 
618     constructor () internal {
619         _addMinter(msg.sender);
620     }
621 
622     modifier onlyMinter() {
623         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
624         _;
625     }
626 
627     function isMinter(address account) public view returns (bool) {
628         return _minters.has(account);
629     }
630 
631     function addMinter(address account) public onlyMinter {
632         _addMinter(account);
633     }
634 
635     function renounceMinter() public {
636         _removeMinter(msg.sender);
637     }
638 
639     function _addMinter(address account) internal {
640         _minters.add(account);
641         emit MinterAdded(account);
642     }
643 
644     function _removeMinter(address account) internal {
645         _minters.remove(account);
646         emit MinterRemoved(account);
647     }
648 }
649 
650 // File: contracts/libs/ERC20Mintable.sol
651 
652 pragma solidity ^0.5.0;
653 
654 
655 
656 /**
657  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
658  * which have permission to mint (create) new tokens as they see fit.
659  *
660  * At construction, the deployer of the contract is the only minter.
661  */
662 contract ERC20Mintable is ERC20, MinterRole {
663     /**
664      * @dev See `ERC20._mint`.
665      *
666      * Requirements:
667      *
668      * - the caller must have the `MinterRole`.
669      */
670     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
671         _mint(account, amount);
672         return true;
673     }
674 }
675 
676 // File: contracts/libs/PauserRole.sol
677 
678 pragma solidity ^0.5.0;
679 
680 
681 contract PauserRole {
682     using Roles for Roles.Role;
683 
684     event PauserAdded(address indexed account);
685     event PauserRemoved(address indexed account);
686 
687     Roles.Role private _pausers;
688 
689     constructor () internal {
690         _addPauser(msg.sender);
691     }
692 
693     modifier onlyPauser() {
694         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
695         _;
696     }
697 
698     function isPauser(address account) public view returns (bool) {
699         return _pausers.has(account);
700     }
701 
702     function addPauser(address account) public onlyPauser {
703         _addPauser(account);
704     }
705 
706     function renouncePauser() public {
707         _removePauser(msg.sender);
708     }
709 
710     function _addPauser(address account) internal {
711         _pausers.add(account);
712         emit PauserAdded(account);
713     }
714 
715     function _removePauser(address account) internal {
716         _pausers.remove(account);
717         emit PauserRemoved(account);
718     }
719 }
720 
721 // File: contracts/libs/Pausable.sol
722 
723 pragma solidity ^0.5.0;
724 
725 
726 /**
727  * @dev Contract module which allows children to implement an emergency stop
728  * mechanism that can be triggered by an authorized account.
729  *
730  * This module is used through inheritance. It will make available the
731  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
732  * the functions of your contract. Note that they will not be pausable by
733  * simply including this module, only once the modifiers are put in place.
734  */
735 contract Pausable is PauserRole {
736     /**
737      * @dev Emitted when the pause is triggered by a pauser (`account`).
738      */
739     event Paused(address account);
740 
741     /**
742      * @dev Emitted when the pause is lifted by a pauser (`account`).
743      */
744     event Unpaused(address account);
745 
746     bool private _paused;
747 
748     /**
749      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
750      * to the deployer.
751      */
752     constructor () internal {
753         _paused = false;
754     }
755 
756     /**
757      * @dev Returns true if the contract is paused, and false otherwise.
758      */
759     function paused() public view returns (bool) {
760         return _paused;
761     }
762 
763     /**
764      * @dev Modifier to make a function callable only when the contract is not paused.
765      */
766     modifier whenNotPaused() {
767         require(!_paused, "Pausable: paused");
768         _;
769     }
770 
771     /**
772      * @dev Modifier to make a function callable only when the contract is paused.
773      */
774     modifier whenPaused() {
775         require(_paused, "Pausable: not paused");
776         _;
777     }
778 
779     /**
780      * @dev Called by a pauser to pause, triggers stopped state.
781      */
782     function pause() public onlyPauser whenNotPaused {
783         _paused = true;
784         emit Paused(msg.sender);
785     }
786 
787     /**
788      * @dev Called by a pauser to unpause, returns to normal state.
789      */
790     function unpause() public onlyPauser whenPaused {
791         _paused = false;
792         emit Unpaused(msg.sender);
793     }
794 }
795 
796 // File: contracts/libs/ERC20Pausable.sol
797 
798 pragma solidity ^0.5.0;
799 
800 
801 
802 /**
803  * @title Pausable token
804  * @dev ERC20 modified with pausable transfers.
805  */
806 contract ERC20Pausable is ERC20, Pausable {
807     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
808         return super.transfer(to, value);
809     }
810 
811     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
812         return super.transferFrom(from, to, value);
813     }
814 
815     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
816         return super.approve(spender, value);
817     }
818 
819     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
820         return super.increaseAllowance(spender, addedValue);
821     }
822 
823     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
824         return super.decreaseAllowance(spender, subtractedValue);
825     }
826 }
827 
828 // File: contracts/libs/ERC20Redeem.sol
829 
830 pragma solidity ^0.5.0;
831 
832 
833 
834 
835 
836 /**
837  * @title ERC20Redeem token
838  * @dev The decimals are only for visualization purposes.
839  * All the operations are done using the smallest and indivisible token unit,
840  * just as on Ethereum all the operations are done in wei.
841  */
842 contract ERC20Redeem is ERC20Pausable, Ownable{
843     ERC20Mintable private _newToken;
844     bool private _isMigration;
845 
846     /**
847      * @dev Modifier to check migration status
848      */
849     modifier isMigration() {
850         require(_isMigration, "Migration: start");
851         _;
852     }
853 
854     /**
855      * @dev set new migrate token.
856      * @param newToken_ address mintable token.
857      * @return success.
858      */
859     function setNewToken(ERC20Mintable newToken_) public onlyOwner returns(bool){
860         require(address(_newToken) == address(0));
861         require(address(newToken_) != address(0));
862         require(newToken_.isMinter(address(this)));
863         _newToken= newToken_;
864         return true;
865     }
866 
867     /**
868      * @dev redeem for individual owner of token.
869      * @return success.
870      */
871     function redeem() public isMigration returns(bool){
872         require(address(_newToken) != address(0));
873         uint256 balance  = balanceOf(msg.sender);
874         require(balance > 0);
875         _burn(msg.sender, balance);
876         _newToken.mint(msg.sender, balance);
877         return true;
878     }
879 
880     /**
881      * @dev owner redeem for individual owner of token.
882      * @return success.
883      */
884     function ownerRedeem( address[] memory addresses) public isMigration onlyOwner returns(bool){
885       require(address(_newToken) != address(0), "Have migrated");
886       for(uint i = 0; i < addresses.length; i++){
887         _ownerRedeem(addresses[i]);
888       }
889       return true;
890     }
891 
892     function _ownerRedeem(address account) internal{
893       uint256 balance = balanceOf(account);
894       require(balance > 0, "balance: empty");
895       _burn(account, balance);
896       _newToken.mint(account, balance);
897     }
898 
899     /**
900      * @dev set migration status
901      */
902     function setMigration(bool isMigration_) public onlyOwner{
903       require(address(_newToken) != address(0), "Have migrated");
904       _isMigration = isMigration_;
905     }
906 }
907 
908 // File: contracts/libs/ERC20Capped.sol
909 
910 pragma solidity ^0.5.0;
911 
912 
913 /**
914  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
915  */
916 contract ERC20Capped is ERC20Mintable {
917     uint256 private _cap;
918 
919     /**
920      * @dev Sets the value of the `cap`. This value is immutable, it can only be
921      * set once during construction.
922      */
923     constructor (uint256 cap) public {
924         require(cap > 0, "ERC20Capped: cap is 0");
925         _cap = cap;
926     }
927 
928     /**
929      * @dev Returns the cap on the token's total supply.
930      */
931     function cap() public view returns (uint256) {
932         return _cap;
933     }
934 
935     /**
936      * @dev See `ERC20Mintable.mint`.
937      *
938      * Requirements:
939      *
940      * - `value` must not cause the total supply to go over the cap.
941      */
942     function _mint(address account, uint256 value) internal {
943         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
944         super._mint(account, value);
945     }
946 }
947 
948 // File: contracts/InfinitoToken.sol
949 
950 pragma solidity ^0.5.0;
951 
952 
953 
954 
955 contract InfinitoToken is ERC20Redeem, ERC20Detailed, ERC20Capped{
956     constructor (
957         string memory name,
958         string memory symbol,
959         uint8 decimals,
960         uint256 cap)
961     public
962     ERC20Detailed(name, symbol, decimals)
963     ERC20Capped(cap)
964     {}
965 }