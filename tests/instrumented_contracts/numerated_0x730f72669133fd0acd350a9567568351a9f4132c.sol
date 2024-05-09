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
476 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /**
481  * @dev Contract module which provides a basic access control mechanism, where
482  * there is an account (an owner) that can be granted exclusive access to
483  * specific functions.
484  *
485  * This module is used through inheritance. It will make available the modifier
486  * `onlyOwner`, which can be aplied to your functions to restrict their use to
487  * the owner.
488  */
489 contract Ownable {
490     address private _owner;
491 
492     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
493 
494     /**
495      * @dev Initializes the contract setting the deployer as the initial owner.
496      */
497     constructor () internal {
498         _owner = msg.sender;
499         emit OwnershipTransferred(address(0), _owner);
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(isOwner(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Returns true if the caller is the current owner.
519      */
520     function isOwner() public view returns (bool) {
521         return msg.sender == _owner;
522     }
523 
524     /**
525      * @dev Leaves the contract without owner. It will not be possible to call
526      * `onlyOwner` functions anymore. Can only be called by the current owner.
527      *
528      * > Note: Renouncing ownership will leave the contract without an owner,
529      * thereby removing any functionality that is only available to the owner.
530      */
531     function renounceOwnership() public onlyOwner {
532         emit OwnershipTransferred(_owner, address(0));
533         _owner = address(0);
534     }
535 
536     /**
537      * @dev Transfers ownership of the contract to a new account (`newOwner`).
538      * Can only be called by the current owner.
539      */
540     function transferOwnership(address newOwner) public onlyOwner {
541         _transferOwnership(newOwner);
542     }
543 
544     /**
545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
546      */
547     function _transferOwnership(address newOwner) internal {
548         require(newOwner != address(0), "Ownable: new owner is the zero address");
549         emit OwnershipTransferred(_owner, newOwner);
550         _owner = newOwner;
551     }
552 }
553 
554 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
593 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
594 
595 pragma solidity ^0.5.0;
596 
597 
598 contract PauserRole {
599     using Roles for Roles.Role;
600 
601     event PauserAdded(address indexed account);
602     event PauserRemoved(address indexed account);
603 
604     Roles.Role private _pausers;
605 
606     constructor () internal {
607         _addPauser(msg.sender);
608     }
609 
610     modifier onlyPauser() {
611         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
612         _;
613     }
614 
615     function isPauser(address account) public view returns (bool) {
616         return _pausers.has(account);
617     }
618 
619     function addPauser(address account) public onlyPauser {
620         _addPauser(account);
621     }
622 
623     function renouncePauser() public {
624         _removePauser(msg.sender);
625     }
626 
627     function _addPauser(address account) internal {
628         _pausers.add(account);
629         emit PauserAdded(account);
630     }
631 
632     function _removePauser(address account) internal {
633         _pausers.remove(account);
634         emit PauserRemoved(account);
635     }
636 }
637 
638 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
639 
640 pragma solidity ^0.5.0;
641 
642 
643 /**
644  * @dev Contract module which allows children to implement an emergency stop
645  * mechanism that can be triggered by an authorized account.
646  *
647  * This module is used through inheritance. It will make available the
648  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
649  * the functions of your contract. Note that they will not be pausable by
650  * simply including this module, only once the modifiers are put in place.
651  */
652 contract Pausable is PauserRole {
653     /**
654      * @dev Emitted when the pause is triggered by a pauser (`account`).
655      */
656     event Paused(address account);
657 
658     /**
659      * @dev Emitted when the pause is lifted by a pauser (`account`).
660      */
661     event Unpaused(address account);
662 
663     bool private _paused;
664 
665     /**
666      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
667      * to the deployer.
668      */
669     constructor () internal {
670         _paused = false;
671     }
672 
673     /**
674      * @dev Returns true if the contract is paused, and false otherwise.
675      */
676     function paused() public view returns (bool) {
677         return _paused;
678     }
679 
680     /**
681      * @dev Modifier to make a function callable only when the contract is not paused.
682      */
683     modifier whenNotPaused() {
684         require(!_paused, "Pausable: paused");
685         _;
686     }
687 
688     /**
689      * @dev Modifier to make a function callable only when the contract is paused.
690      */
691     modifier whenPaused() {
692         require(_paused, "Pausable: not paused");
693         _;
694     }
695 
696     /**
697      * @dev Called by a pauser to pause, triggers stopped state.
698      */
699     function pause() public onlyPauser whenNotPaused {
700         _paused = true;
701         emit Paused(msg.sender);
702     }
703 
704     /**
705      * @dev Called by a pauser to unpause, returns to normal state.
706      */
707     function unpause() public onlyPauser whenPaused {
708         _paused = false;
709         emit Unpaused(msg.sender);
710     }
711 }
712 
713 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
714 
715 pragma solidity ^0.5.0;
716 
717 
718 
719 /**
720  * @title Pausable token
721  * @dev ERC20 modified with pausable transfers.
722  */
723 contract ERC20Pausable is ERC20, Pausable {
724     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
725         return super.transfer(to, value);
726     }
727 
728     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
729         return super.transferFrom(from, to, value);
730     }
731 
732     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
733         return super.approve(spender, value);
734     }
735 
736     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
737         return super.increaseAllowance(spender, addedValue);
738     }
739 
740     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
741         return super.decreaseAllowance(spender, subtractedValue);
742     }
743 }
744 
745 // File: contracts/HUBToken.sol
746 
747 pragma solidity ^0.5.2;
748 
749 
750 
751 //2019/6/14 zephlee
752 
753 /**
754  * @title HUBToken token
755  * @dev The decimals are only for visualization purposes.
756  * All the operations are done using the smallest and indivisible token unit,
757  * just as on Ethereum all the operations are done in wei.
758  */
759 contract HUBToken is ERC20, ERC20Detailed, Ownable, ERC20Pausable {
760   
761   mapping (address => bool) _lockedSenders;
762 
763   constructor(
764    string memory _name,
765 	 string memory _symbol,
766 	 uint8 _decimals,
767    uint256 _initialSupply
768   ) 
769     ERC20Detailed(_name, _symbol, _decimals)
770     public
771   {
772     _mint(msg.sender, _initialSupply * 10 ** uint256(_decimals));
773   }
774 
775   /**
776   * @dev Give an account set to lock down.
777   */
778   function addLockdownSender(address account) public onlyOwner {
779     _lockedSenders[account] = true;
780   }
781 
782   /**
783   * @dev Release an account's lock.
784   */
785   function releaseLockdownSender(address account) public onlyOwner {
786     _lockedSenders[account] = false;
787   }
788 
789   /**
790   * @dev Check if an account is lock down.
791   * @return bool
792   */
793   function isLockdownSender(address account) public view returns (bool) {
794       require(account != address(0), "Roles: account is the zero address");
795       return _lockedSenders[account];
796   }
797 
798   /**
799   * @dev Moves tokens `amount` from `sender` to `recipient`.
800   *
801   * This is internal function is equivalent to `transfer`, and can be used to
802   * e.g. implement automatic token fees, slashing mechanisms, etc.
803   *
804   * Emits a `Transfer` event.
805   *
806   * Requirements:
807   *
808   * - `sender` cannot be the zero address.
809   * - `recipient` cannot be the zero address.
810   * - `sender` must have a balance of at least `amount`.
811   */
812   function _transfer(address sender, address recipient, uint256 amount) internal {
813     require(isLockdownSender(sender) == false, "HUBToken: sender's transaction is lock down");
814     super._transfer(sender, recipient, amount);
815   }
816 }