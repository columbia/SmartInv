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
420 // File: openzeppelin-solidity/contracts/access/Roles.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429     struct Role {
430         mapping (address => bool) bearer;
431     }
432 
433     /**
434      * @dev Give an account access to this role.
435      */
436     function add(Role storage role, address account) internal {
437         require(!has(role, account), "Roles: account already has role");
438         role.bearer[account] = true;
439     }
440 
441     /**
442      * @dev Remove an account's access to this role.
443      */
444     function remove(Role storage role, address account) internal {
445         require(has(role, account), "Roles: account does not have role");
446         role.bearer[account] = false;
447     }
448 
449     /**
450      * @dev Check if an account has this role.
451      * @return bool
452      */
453     function has(Role storage role, address account) internal view returns (bool) {
454         require(account != address(0), "Roles: account is the zero address");
455         return role.bearer[account];
456     }
457 }
458 
459 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 /**
511  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
512  * which have permission to mint (create) new tokens as they see fit.
513  *
514  * At construction, the deployer of the contract is the only minter.
515  */
516 contract ERC20Mintable is ERC20, MinterRole {
517     /**
518      * @dev See `ERC20._mint`.
519      *
520      * Requirements:
521      *
522      * - the caller must have the `MinterRole`.
523      */
524     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
525         _mint(account, amount);
526         return true;
527     }
528 }
529 
530 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 /**
536  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
537  */
538 contract ERC20Capped is ERC20Mintable {
539     uint256 private _cap;
540 
541     /**
542      * @dev Sets the value of the `cap`. This value is immutable, it can only be
543      * set once during construction.
544      */
545     constructor (uint256 cap) public {
546         require(cap > 0, "ERC20Capped: cap is 0");
547         _cap = cap;
548     }
549 
550     /**
551      * @dev Returns the cap on the token's total supply.
552      */
553     function cap() public view returns (uint256) {
554         return _cap;
555     }
556 
557     /**
558      * @dev See `ERC20Mintable.mint`.
559      *
560      * Requirements:
561      *
562      * - `value` must not cause the total supply to go over the cap.
563      */
564     function _mint(address account, uint256 value) internal {
565         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
566         super._mint(account, value);
567     }
568 }
569 
570 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 contract PauserRole {
576     using Roles for Roles.Role;
577 
578     event PauserAdded(address indexed account);
579     event PauserRemoved(address indexed account);
580 
581     Roles.Role private _pausers;
582 
583     constructor () internal {
584         _addPauser(msg.sender);
585     }
586 
587     modifier onlyPauser() {
588         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
589         _;
590     }
591 
592     function isPauser(address account) public view returns (bool) {
593         return _pausers.has(account);
594     }
595 
596     function addPauser(address account) public onlyPauser {
597         _addPauser(account);
598     }
599 
600     function renouncePauser() public {
601         _removePauser(msg.sender);
602     }
603 
604     function _addPauser(address account) internal {
605         _pausers.add(account);
606         emit PauserAdded(account);
607     }
608 
609     function _removePauser(address account) internal {
610         _pausers.remove(account);
611         emit PauserRemoved(account);
612     }
613 }
614 
615 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
616 
617 pragma solidity ^0.5.0;
618 
619 
620 /**
621  * @dev Contract module which allows children to implement an emergency stop
622  * mechanism that can be triggered by an authorized account.
623  *
624  * This module is used through inheritance. It will make available the
625  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
626  * the functions of your contract. Note that they will not be pausable by
627  * simply including this module, only once the modifiers are put in place.
628  */
629 contract Pausable is PauserRole {
630     /**
631      * @dev Emitted when the pause is triggered by a pauser (`account`).
632      */
633     event Paused(address account);
634 
635     /**
636      * @dev Emitted when the pause is lifted by a pauser (`account`).
637      */
638     event Unpaused(address account);
639 
640     bool private _paused;
641 
642     /**
643      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
644      * to the deployer.
645      */
646     constructor () internal {
647         _paused = false;
648     }
649 
650     /**
651      * @dev Returns true if the contract is paused, and false otherwise.
652      */
653     function paused() public view returns (bool) {
654         return _paused;
655     }
656 
657     /**
658      * @dev Modifier to make a function callable only when the contract is not paused.
659      */
660     modifier whenNotPaused() {
661         require(!_paused, "Pausable: paused");
662         _;
663     }
664 
665     /**
666      * @dev Modifier to make a function callable only when the contract is paused.
667      */
668     modifier whenPaused() {
669         require(_paused, "Pausable: not paused");
670         _;
671     }
672 
673     /**
674      * @dev Called by a pauser to pause, triggers stopped state.
675      */
676     function pause() public onlyPauser whenNotPaused {
677         _paused = true;
678         emit Paused(msg.sender);
679     }
680 
681     /**
682      * @dev Called by a pauser to unpause, returns to normal state.
683      */
684     function unpause() public onlyPauser whenPaused {
685         _paused = false;
686         emit Unpaused(msg.sender);
687     }
688 }
689 
690 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
691 
692 pragma solidity ^0.5.0;
693 
694 
695 
696 /**
697  * @title Pausable token
698  * @dev ERC20 modified with pausable transfers.
699  */
700 contract ERC20Pausable is ERC20, Pausable {
701     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
702         return super.transfer(to, value);
703     }
704 
705     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
706         return super.transferFrom(from, to, value);
707     }
708 
709     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
710         return super.approve(spender, value);
711     }
712 
713     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
714         return super.increaseAllowance(spender, addedValue);
715     }
716 
717     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
718         return super.decreaseAllowance(spender, subtractedValue);
719     }
720 }
721 
722 // File: contracts/SENSOToken.sol
723 
724 pragma solidity 0.5.11;
725 
726 
727 
728 contract SENSOToken is ERC20Capped, ERC20Pausable {
729 
730     string public symbol = "SENSO";
731     string public name = "Sensorium";
732 
733     /**
734      * @dev Emission constants, constraints:
735      * tokenCapAmount = closedSaleAmount +
736      *                  tokensaleAmount +
737      *                  reserveAmount
738      */
739 
740     uint256 public constant tokenCapAmount =   7692000000;
741     uint256 public constant closedSaleAmount = 2000000000;
742     uint256 public constant tokensaleAmount =  3000000000;
743 
744     // holds amount of total frozen tokens for cap checks
745     uint256 public totalFrozenTokens;
746 
747     /**
748      * @dev Admins wallets, used to override pause limitations
749      */
750 
751     address public closedSaleWallet;
752     address public tokensaleWallet;
753 
754     constructor ( address _closedSaleWallet, address _tokenSaleWallet)
755         public ERC20Capped(tokenCapAmount) ERC20Pausable()
756     {
757         closedSaleWallet = _closedSaleWallet;
758         tokensaleWallet = _tokenSaleWallet;
759 
760         mint(_closedSaleWallet,  closedSaleAmount);
761 
762         pause();
763     }
764 
765 
766     /**
767      * @dev closedSaleWallet and tokensaleWallet can ignore pause
768      */
769 
770     modifier whenNotPaused() {
771         require(msg.sender == closedSaleWallet ||
772             msg.sender == tokensaleWallet ||
773             !paused(), "Pausable: paused");
774         _;
775     }
776 
777     function mint(address account, uint256 amount, uint256 frozenAmount) public onlyMinter returns (bool) {
778         _mint(account, amount, frozenAmount);
779         return true;
780     }
781 
782     /**
783      * @dev See `ERC20Mintable.mint`.
784      *
785      * Requirements:
786      *
787      * - `value` must not cause the total supply to go over the cap.
788      * @param account wallet that will receive tokens
789      * @param value amount of tokens to be minted
790      * @param frozenValue number of tokens to be counted for freezing
791      */
792     function _mint(address account, uint256 value, uint256 frozenValue) internal {
793         // case: minting `value` tokens taking into account that some amount will be frozen
794         // if `frozenValue == 0`, this is unfreezing operation
795         // we do not have to do this check again
796         if (frozenValue != 0) {
797             require(totalSupply().add(totalFrozenTokens).add(value).add(frozenValue) <= cap(), "ERC20Capped: cap exceeded");
798             totalFrozenTokens = totalFrozenTokens.add(frozenValue);
799         }
800         super._mint(account, value);
801     }
802 
803     /**
804      * Reduces the value of frozen tokens counter
805      *
806      * @param unfrozenValue amount of tokens to be unfrozen
807      */
808     function unfreezeTokens(uint256 unfrozenValue) public onlyMinter returns (bool) {
809         totalFrozenTokens = totalFrozenTokens.sub(unfrozenValue);
810         return true;
811     }
812 
813 }