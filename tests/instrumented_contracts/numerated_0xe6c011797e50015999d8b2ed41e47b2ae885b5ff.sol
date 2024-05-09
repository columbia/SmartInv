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
530 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
531 
532 pragma solidity ^0.5.0;
533 
534 
535 /**
536  * @dev Optional functions from the ERC20 standard.
537  */
538 contract ERC20Detailed is IERC20 {
539     string private _name;
540     string private _symbol;
541     uint8 private _decimals;
542 
543     /**
544      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
545      * these values are immutable: they can only be set once during
546      * construction.
547      */
548     constructor (string memory name, string memory symbol, uint8 decimals) public {
549         _name = name;
550         _symbol = symbol;
551         _decimals = decimals;
552     }
553 
554     /**
555      * @dev Returns the name of the token.
556      */
557     function name() public view returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev Returns the symbol of the token, usually a shorter version of the
563      * name.
564      */
565     function symbol() public view returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the number of decimals used to get its user representation.
571      * For example, if `decimals` equals `2`, a balance of `505` tokens should
572      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573      *
574      * Tokens usually opt for a value of 18, imitating the relationship between
575      * Ether and Wei.
576      *
577      * > Note that this information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * `IERC20.balanceOf` and `IERC20.transfer`.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 }
585 
586 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 contract PauserRole {
592     using Roles for Roles.Role;
593 
594     event PauserAdded(address indexed account);
595     event PauserRemoved(address indexed account);
596 
597     Roles.Role private _pausers;
598 
599     constructor () internal {
600         _addPauser(msg.sender);
601     }
602 
603     modifier onlyPauser() {
604         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
605         _;
606     }
607 
608     function isPauser(address account) public view returns (bool) {
609         return _pausers.has(account);
610     }
611 
612     function addPauser(address account) public onlyPauser {
613         _addPauser(account);
614     }
615 
616     function renouncePauser() public {
617         _removePauser(msg.sender);
618     }
619 
620     function _addPauser(address account) internal {
621         _pausers.add(account);
622         emit PauserAdded(account);
623     }
624 
625     function _removePauser(address account) internal {
626         _pausers.remove(account);
627         emit PauserRemoved(account);
628     }
629 }
630 
631 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
632 
633 pragma solidity ^0.5.0;
634 
635 
636 /**
637  * @dev Contract module which allows children to implement an emergency stop
638  * mechanism that can be triggered by an authorized account.
639  *
640  * This module is used through inheritance. It will make available the
641  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
642  * the functions of your contract. Note that they will not be pausable by
643  * simply including this module, only once the modifiers are put in place.
644  */
645 contract Pausable is PauserRole {
646     /**
647      * @dev Emitted when the pause is triggered by a pauser (`account`).
648      */
649     event Paused(address account);
650 
651     /**
652      * @dev Emitted when the pause is lifted by a pauser (`account`).
653      */
654     event Unpaused(address account);
655 
656     bool private _paused;
657 
658     /**
659      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
660      * to the deployer.
661      */
662     constructor () internal {
663         _paused = false;
664     }
665 
666     /**
667      * @dev Returns true if the contract is paused, and false otherwise.
668      */
669     function paused() public view returns (bool) {
670         return _paused;
671     }
672 
673     /**
674      * @dev Modifier to make a function callable only when the contract is not paused.
675      */
676     modifier whenNotPaused() {
677         require(!_paused, "Pausable: paused");
678         _;
679     }
680 
681     /**
682      * @dev Modifier to make a function callable only when the contract is paused.
683      */
684     modifier whenPaused() {
685         require(_paused, "Pausable: not paused");
686         _;
687     }
688 
689     /**
690      * @dev Called by a pauser to pause, triggers stopped state.
691      */
692     function pause() public onlyPauser whenNotPaused {
693         _paused = true;
694         emit Paused(msg.sender);
695     }
696 
697     /**
698      * @dev Called by a pauser to unpause, returns to normal state.
699      */
700     function unpause() public onlyPauser whenPaused {
701         _paused = false;
702         emit Unpaused(msg.sender);
703     }
704 }
705 
706 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
707 
708 pragma solidity ^0.5.0;
709 
710 
711 
712 /**
713  * @title Pausable token
714  * @dev ERC20 modified with pausable transfers.
715  */
716 contract ERC20Pausable is ERC20, Pausable {
717     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
718         return super.transfer(to, value);
719     }
720 
721     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
722         return super.transferFrom(from, to, value);
723     }
724 
725     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
726         return super.approve(spender, value);
727     }
728 
729     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
730         return super.increaseAllowance(spender, addedValue);
731     }
732 
733     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
734         return super.decreaseAllowance(spender, subtractedValue);
735     }
736 }
737 
738 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
739 
740 pragma solidity ^0.5.0;
741 
742 
743 /**
744  * @dev Extension of `ERC20` that allows token holders to destroy both their own
745  * tokens and those that they have an allowance for, in a way that can be
746  * recognized off-chain (via event analysis).
747  */
748 contract ERC20Burnable is ERC20 {
749     /**
750      * @dev Destoys `amount` tokens from the caller.
751      *
752      * See `ERC20._burn`.
753      */
754     function burn(uint256 amount) public {
755         _burn(msg.sender, amount);
756     }
757 
758     /**
759      * @dev See `ERC20._burnFrom`.
760      */
761     function burnFrom(address account, uint256 amount) public {
762         _burnFrom(account, amount);
763     }
764 }
765 
766 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
767 
768 pragma solidity ^0.5.0;
769 
770 /**
771  * @dev Contract module which provides a basic access control mechanism, where
772  * there is an account (an owner) that can be granted exclusive access to
773  * specific functions.
774  *
775  * This module is used through inheritance. It will make available the modifier
776  * `onlyOwner`, which can be aplied to your functions to restrict their use to
777  * the owner.
778  */
779 contract Ownable {
780     address private _owner;
781 
782     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
783 
784     /**
785      * @dev Initializes the contract setting the deployer as the initial owner.
786      */
787     constructor () internal {
788         _owner = msg.sender;
789         emit OwnershipTransferred(address(0), _owner);
790     }
791 
792     /**
793      * @dev Returns the address of the current owner.
794      */
795     function owner() public view returns (address) {
796         return _owner;
797     }
798 
799     /**
800      * @dev Throws if called by any account other than the owner.
801      */
802     modifier onlyOwner() {
803         require(isOwner(), "Ownable: caller is not the owner");
804         _;
805     }
806 
807     /**
808      * @dev Returns true if the caller is the current owner.
809      */
810     function isOwner() public view returns (bool) {
811         return msg.sender == _owner;
812     }
813 
814     /**
815      * @dev Leaves the contract without owner. It will not be possible to call
816      * `onlyOwner` functions anymore. Can only be called by the current owner.
817      *
818      * > Note: Renouncing ownership will leave the contract without an owner,
819      * thereby removing any functionality that is only available to the owner.
820      */
821     function renounceOwnership() public onlyOwner {
822         emit OwnershipTransferred(_owner, address(0));
823         _owner = address(0);
824     }
825 
826     /**
827      * @dev Transfers ownership of the contract to a new account (`newOwner`).
828      * Can only be called by the current owner.
829      */
830     function transferOwnership(address newOwner) public onlyOwner {
831         _transferOwnership(newOwner);
832     }
833 
834     /**
835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
836      */
837     function _transferOwnership(address newOwner) internal {
838         require(newOwner != address(0), "Ownable: new owner is the zero address");
839         emit OwnershipTransferred(_owner, newOwner);
840         _owner = newOwner;
841     }
842 }
843 
844 // File: contracts/XSRToken.sol
845 
846 pragma solidity ^0.5.0;
847 
848 
849 
850 
851 
852 
853 
854 contract XSRToken is ERC20Detailed, ERC20, ERC20Mintable, ERC20Pausable, ERC20Burnable, Ownable {
855 
856     using SafeMath for uint256;
857     
858     constructor (
859             string memory name,
860             string memory symbol,
861             uint256 totalSupply,
862             uint8 decimals
863     ) ERC20Detailed(name, symbol, decimals)
864     public {
865         _mint(owner(), totalSupply * 10**uint(decimals));
866     }
867 }