1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
421 
422 pragma solidity ^0.5.0;
423 
424 
425 /**
426  * @dev Optional functions from the ERC20 standard.
427  */
428 contract ERC20Detailed is IERC20 {
429     string private _name;
430     string private _symbol;
431     uint8 private _decimals;
432 
433     /**
434      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
435      * these values are immutable: they can only be set once during
436      * construction.
437      */
438     constructor (string memory name, string memory symbol, uint8 decimals) public {
439         _name = name;
440         _symbol = symbol;
441         _decimals = decimals;
442     }
443 
444     /**
445      * @dev Returns the name of the token.
446      */
447     function name() public view returns (string memory) {
448         return _name;
449     }
450 
451     /**
452      * @dev Returns the symbol of the token, usually a shorter version of the
453      * name.
454      */
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @dev Returns the number of decimals used to get its user representation.
461      * For example, if `decimals` equals `2`, a balance of `505` tokens should
462      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
463      *
464      * Tokens usually opt for a value of 18, imitating the relationship between
465      * Ether and Wei.
466      *
467      * > Note that this information is only used for _display_ purposes: it in
468      * no way affects any of the arithmetic of the contract, including
469      * `IERC20.balanceOf` and `IERC20.transfer`.
470      */
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 }
475 
476 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
477 
478 pragma solidity ^0.5.0;
479 
480 
481 /**
482  * @dev Extension of `ERC20` that allows token holders to destroy both their own
483  * tokens and those that they have an allowance for, in a way that can be
484  * recognized off-chain (via event analysis).
485  */
486 contract ERC20Burnable is ERC20 {
487     /**
488      * @dev Destoys `amount` tokens from the caller.
489      *
490      * See `ERC20._burn`.
491      */
492     function burn(uint256 amount) public {
493         _burn(msg.sender, amount);
494     }
495 
496     /**
497      * @dev See `ERC20._burnFrom`.
498      */
499     function burnFrom(address account, uint256 amount) public {
500         _burnFrom(account, amount);
501     }
502 }
503 
504 // File: openzeppelin-solidity/contracts/access/Roles.sol
505 
506 pragma solidity ^0.5.0;
507 
508 /**
509  * @title Roles
510  * @dev Library for managing addresses assigned to a Role.
511  */
512 library Roles {
513     struct Role {
514         mapping (address => bool) bearer;
515     }
516 
517     /**
518      * @dev Give an account access to this role.
519      */
520     function add(Role storage role, address account) internal {
521         require(!has(role, account), "Roles: account already has role");
522         role.bearer[account] = true;
523     }
524 
525     /**
526      * @dev Remove an account's access to this role.
527      */
528     function remove(Role storage role, address account) internal {
529         require(has(role, account), "Roles: account does not have role");
530         role.bearer[account] = false;
531     }
532 
533     /**
534      * @dev Check if an account has this role.
535      * @return bool
536      */
537     function has(Role storage role, address account) internal view returns (bool) {
538         require(account != address(0), "Roles: account is the zero address");
539         return role.bearer[account];
540     }
541 }
542 
543 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
544 
545 pragma solidity ^0.5.0;
546 
547 
548 contract PauserRole {
549     using Roles for Roles.Role;
550 
551     event PauserAdded(address indexed account);
552     event PauserRemoved(address indexed account);
553 
554     Roles.Role private _pausers;
555 
556     constructor () internal {
557         _addPauser(msg.sender);
558     }
559 
560     modifier onlyPauser() {
561         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
562         _;
563     }
564 
565     function isPauser(address account) public view returns (bool) {
566         return _pausers.has(account);
567     }
568 
569     function addPauser(address account) public onlyPauser {
570         _addPauser(account);
571     }
572 
573     function renouncePauser() public {
574         _removePauser(msg.sender);
575     }
576 
577     function _addPauser(address account) internal {
578         _pausers.add(account);
579         emit PauserAdded(account);
580     }
581 
582     function _removePauser(address account) internal {
583         _pausers.remove(account);
584         emit PauserRemoved(account);
585     }
586 }
587 
588 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
589 
590 pragma solidity ^0.5.0;
591 
592 
593 /**
594  * @dev Contract module which allows children to implement an emergency stop
595  * mechanism that can be triggered by an authorized account.
596  *
597  * This module is used through inheritance. It will make available the
598  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
599  * the functions of your contract. Note that they will not be pausable by
600  * simply including this module, only once the modifiers are put in place.
601  */
602 contract Pausable is PauserRole {
603     /**
604      * @dev Emitted when the pause is triggered by a pauser (`account`).
605      */
606     event Paused(address account);
607 
608     /**
609      * @dev Emitted when the pause is lifted by a pauser (`account`).
610      */
611     event Unpaused(address account);
612 
613     bool private _paused;
614 
615     /**
616      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
617      * to the deployer.
618      */
619     constructor () internal {
620         _paused = false;
621     }
622 
623     /**
624      * @dev Returns true if the contract is paused, and false otherwise.
625      */
626     function paused() public view returns (bool) {
627         return _paused;
628     }
629 
630     /**
631      * @dev Modifier to make a function callable only when the contract is not paused.
632      */
633     modifier whenNotPaused() {
634         require(!_paused, "Pausable: paused");
635         _;
636     }
637 
638     /**
639      * @dev Modifier to make a function callable only when the contract is paused.
640      */
641     modifier whenPaused() {
642         require(_paused, "Pausable: not paused");
643         _;
644     }
645 
646     /**
647      * @dev Called by a pauser to pause, triggers stopped state.
648      */
649     function pause() public onlyPauser whenNotPaused {
650         _paused = true;
651         emit Paused(msg.sender);
652     }
653 
654     /**
655      * @dev Called by a pauser to unpause, returns to normal state.
656      */
657     function unpause() public onlyPauser whenPaused {
658         _paused = false;
659         emit Unpaused(msg.sender);
660     }
661 }
662 
663 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
664 
665 pragma solidity ^0.5.0;
666 
667 
668 
669 /**
670  * @title Pausable token
671  * @dev ERC20 modified with pausable transfers.
672  */
673 contract ERC20Pausable is ERC20, Pausable {
674     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
675         return super.transfer(to, value);
676     }
677 
678     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
679         return super.transferFrom(from, to, value);
680     }
681 
682     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
683         return super.approve(spender, value);
684     }
685 
686     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
687         return super.increaseAllowance(spender, addedValue);
688     }
689 
690     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
691         return super.decreaseAllowance(spender, subtractedValue);
692     }
693 }
694 
695 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
696 
697 pragma solidity ^0.5.0;
698 
699 /**
700  * @dev Contract module which provides a basic access control mechanism, where
701  * there is an account (an owner) that can be granted exclusive access to
702  * specific functions.
703  *
704  * This module is used through inheritance. It will make available the modifier
705  * `onlyOwner`, which can be aplied to your functions to restrict their use to
706  * the owner.
707  */
708 contract Ownable {
709     address private _owner;
710 
711     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
712 
713     /**
714      * @dev Initializes the contract setting the deployer as the initial owner.
715      */
716     constructor () internal {
717         _owner = msg.sender;
718         emit OwnershipTransferred(address(0), _owner);
719     }
720 
721     /**
722      * @dev Returns the address of the current owner.
723      */
724     function owner() public view returns (address) {
725         return _owner;
726     }
727 
728     /**
729      * @dev Throws if called by any account other than the owner.
730      */
731     modifier onlyOwner() {
732         require(isOwner(), "Ownable: caller is not the owner");
733         _;
734     }
735 
736     /**
737      * @dev Returns true if the caller is the current owner.
738      */
739     function isOwner() public view returns (bool) {
740         return msg.sender == _owner;
741     }
742 
743     /**
744      * @dev Leaves the contract without owner. It will not be possible to call
745      * `onlyOwner` functions anymore. Can only be called by the current owner.
746      *
747      * > Note: Renouncing ownership will leave the contract without an owner,
748      * thereby removing any functionality that is only available to the owner.
749      */
750     function renounceOwnership() public onlyOwner {
751         emit OwnershipTransferred(_owner, address(0));
752         _owner = address(0);
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public onlyOwner {
760         _transferOwnership(newOwner);
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      */
766     function _transferOwnership(address newOwner) internal {
767         require(newOwner != address(0), "Ownable: new owner is the zero address");
768         emit OwnershipTransferred(_owner, newOwner);
769         _owner = newOwner;
770     }
771 }
772 
773 // File: contracts/CenfuraToken.sol
774 
775 pragma solidity ^0.5.0;
776 
777 
778 
779 
780 
781 
782 /**
783  * @title CenfuraToken
784  */
785 contract CenfuraToken is ERC20, ERC20Detailed, ERC20Burnable, ERC20Pausable, Ownable {
786 
787   string public constant NAME = "Cenfura Token";
788   string public constant SYMBOL = "XCF";
789   uint8 public constant DECIMALS = 18;
790 
791   uint256 public constant INITIAL_SUPPLY = 1500000000 * (10 ** uint256(DECIMALS));
792 
793   mapping (address => bool) public frozenAccounts;
794   event FrozenFunds(address target, bool frozen);
795 
796   /**
797    * @dev Constructor that gives msg.sender all of existing tokens.
798    */
799   constructor() ERC20Detailed(NAME, SYMBOL, DECIMALS) public {
800     _mint(msg.sender, INITIAL_SUPPLY);
801   }
802 
803   function freezeAccount(address target, bool freeze) public onlyOwner {
804     frozenAccounts[target] = freeze;
805     emit FrozenFunds(target, freeze);
806   }
807 
808   // Check that transfer from or to is not a frozen account
809   function transfer(address _to, uint256 _value) public returns (bool) {
810     require(!frozenAccounts[msg.sender]);
811     return super.transfer(_to, _value);
812   }
813 
814   // Check that transfer from or to is not a fronzen account
815   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
816     require(!frozenAccounts[_from]);
817     return super.transferFrom(_from, _to, _value);
818   }
819 
820   // Limit the burn to be only allowed by owner
821   function burn(uint256 _value) public onlyOwner {
822     super.burn(_value);
823   }
824 
825 }