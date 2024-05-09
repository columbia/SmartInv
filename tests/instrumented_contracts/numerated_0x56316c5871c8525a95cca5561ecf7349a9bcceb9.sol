1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
79 
80 pragma solidity ^0.5.0;
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b <= a, "SafeMath: subtraction overflow");
123         uint256 c = a - b;
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `*` operator.
133      *
134      * Requirements:
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139         // benefit is lost if 'b' is also tested.
140         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
141         if (a == 0) {
142             return 0;
143         }
144 
145         uint256 c = a * b;
146         require(c / a == b, "SafeMath: multiplication overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Solidity only automatically asserts when dividing by 0
164         require(b > 0, "SafeMath: division by zero");
165         uint256 c = a / b;
166         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      */
182     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b != 0, "SafeMath: modulo by zero");
184         return a % b;
185     }
186 }
187 
188 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
189 
190 pragma solidity ^0.5.0;
191 
192 
193 
194 /**
195  * @dev Implementation of the `IERC20` interface.
196  *
197  * This implementation is agnostic to the way tokens are created. This means
198  * that a supply mechanism has to be added in a derived contract using `_mint`.
199  * For a generic mechanism see `ERC20Mintable`.
200  *
201  * *For a detailed writeup see our guide [How to implement supply
202  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
203  *
204  * We have followed general OpenZeppelin guidelines: functions revert instead
205  * of returning `false` on failure. This behavior is nonetheless conventional
206  * and does not conflict with the expectations of ERC20 applications.
207  *
208  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
209  * This allows applications to reconstruct the allowance for all accounts just
210  * by listening to said events. Other implementations of the EIP may not emit
211  * these events, as it isn't required by the specification.
212  *
213  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
214  * functions have been added to mitigate the well-known issues around setting
215  * allowances. See `IERC20.approve`.
216  */
217 contract ERC20 is IERC20 {
218     using SafeMath for uint256;
219 
220     mapping (address => uint256) private _balances;
221 
222     mapping (address => mapping (address => uint256)) private _allowances;
223 
224     uint256 private _totalSupply;
225 
226     /**
227      * @dev See `IERC20.totalSupply`.
228      */
229     function totalSupply() public view returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See `IERC20.balanceOf`.
235      */
236     function balanceOf(address account) public view returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See `IERC20.transfer`.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public returns (bool) {
249         _transfer(msg.sender, recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See `IERC20.allowance`.
255      */
256     function allowance(address owner, address spender) public view returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See `IERC20.approve`.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 value) public returns (bool) {
268         _approve(msg.sender, spender, value);
269         return true;
270     }
271 
272     /**
273      * @dev See `IERC20.transferFrom`.
274      *
275      * Emits an `Approval` event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of `ERC20`;
277      *
278      * Requirements:
279      * - `sender` and `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `value`.
281      * - the caller must have allowance for `sender`'s tokens of at least
282      * `amount`.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
285         _transfer(sender, recipient, amount);
286         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
287         return true;
288     }
289 
290     /**
291      * @dev Atomically increases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to `approve` that can be used as a mitigation for
294      * problems described in `IERC20.approve`.
295      *
296      * Emits an `Approval` event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
303         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
304         return true;
305     }
306 
307     /**
308      * @dev Atomically decreases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to `approve` that can be used as a mitigation for
311      * problems described in `IERC20.approve`.
312      *
313      * Emits an `Approval` event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      * - `spender` must have allowance for the caller of at least
319      * `subtractedValue`.
320      */
321     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
322         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
323         return true;
324     }
325 
326     /**
327      * @dev Moves tokens `amount` from `sender` to `recipient`.
328      *
329      * This is internal function is equivalent to `transfer`, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a `Transfer` event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(address sender, address recipient, uint256 amount) internal {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _balances[sender] = _balances[sender].sub(amount);
345         _balances[recipient] = _balances[recipient].add(amount);
346         emit Transfer(sender, recipient, amount);
347     }
348 
349     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
350      * the total supply.
351      *
352      * Emits a `Transfer` event with `from` set to the zero address.
353      *
354      * Requirements
355      *
356      * - `to` cannot be the zero address.
357      */
358     function _mint(address account, uint256 amount) internal {
359         require(account != address(0), "ERC20: mint to the zero address");
360 
361         _totalSupply = _totalSupply.add(amount);
362         _balances[account] = _balances[account].add(amount);
363         emit Transfer(address(0), account, amount);
364     }
365 
366      /**
367      * @dev Destoys `amount` tokens from `account`, reducing the
368      * total supply.
369      *
370      * Emits a `Transfer` event with `to` set to the zero address.
371      *
372      * Requirements
373      *
374      * - `account` cannot be the zero address.
375      * - `account` must have at least `amount` tokens.
376      */
377     function _burn(address account, uint256 value) internal {
378         require(account != address(0), "ERC20: burn from the zero address");
379 
380         _totalSupply = _totalSupply.sub(value);
381         _balances[account] = _balances[account].sub(value);
382         emit Transfer(account, address(0), value);
383     }
384 
385     /**
386      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
387      *
388      * This is internal function is equivalent to `approve`, and can be used to
389      * e.g. set automatic allowances for certain subsystems, etc.
390      *
391      * Emits an `Approval` event.
392      *
393      * Requirements:
394      *
395      * - `owner` cannot be the zero address.
396      * - `spender` cannot be the zero address.
397      */
398     function _approve(address owner, address spender, uint256 value) internal {
399         require(owner != address(0), "ERC20: approve from the zero address");
400         require(spender != address(0), "ERC20: approve to the zero address");
401 
402         _allowances[owner][spender] = value;
403         emit Approval(owner, spender, value);
404     }
405 
406     /**
407      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
408      * from the caller's allowance.
409      *
410      * See `_burn` and `_approve`.
411      */
412     function _burnFrom(address account, uint256 amount) internal {
413         _burn(account, amount);
414         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
415     }
416 }
417 
418 // File: openzeppelin-solidity/contracts/access/Roles.sol
419 
420 pragma solidity ^0.5.0;
421 
422 /**
423  * @title Roles
424  * @dev Library for managing addresses assigned to a Role.
425  */
426 library Roles {
427     struct Role {
428         mapping (address => bool) bearer;
429     }
430 
431     /**
432      * @dev Give an account access to this role.
433      */
434     function add(Role storage role, address account) internal {
435         require(!has(role, account), "Roles: account already has role");
436         role.bearer[account] = true;
437     }
438 
439     /**
440      * @dev Remove an account's access to this role.
441      */
442     function remove(Role storage role, address account) internal {
443         require(has(role, account), "Roles: account does not have role");
444         role.bearer[account] = false;
445     }
446 
447     /**
448      * @dev Check if an account has this role.
449      * @return bool
450      */
451     function has(Role storage role, address account) internal view returns (bool) {
452         require(account != address(0), "Roles: account is the zero address");
453         return role.bearer[account];
454     }
455 }
456 
457 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
458 
459 pragma solidity ^0.5.0;
460 
461 
462 contract PauserRole {
463     using Roles for Roles.Role;
464 
465     event PauserAdded(address indexed account);
466     event PauserRemoved(address indexed account);
467 
468     Roles.Role private _pausers;
469 
470     constructor () internal {
471         _addPauser(msg.sender);
472     }
473 
474     modifier onlyPauser() {
475         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
476         _;
477     }
478 
479     function isPauser(address account) public view returns (bool) {
480         return _pausers.has(account);
481     }
482 
483     function addPauser(address account) public onlyPauser {
484         _addPauser(account);
485     }
486 
487     function renouncePauser() public {
488         _removePauser(msg.sender);
489     }
490 
491     function _addPauser(address account) internal {
492         _pausers.add(account);
493         emit PauserAdded(account);
494     }
495 
496     function _removePauser(address account) internal {
497         _pausers.remove(account);
498         emit PauserRemoved(account);
499     }
500 }
501 
502 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
503 
504 pragma solidity ^0.5.0;
505 
506 
507 /**
508  * @dev Contract module which allows children to implement an emergency stop
509  * mechanism that can be triggered by an authorized account.
510  *
511  * This module is used through inheritance. It will make available the
512  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
513  * the functions of your contract. Note that they will not be pausable by
514  * simply including this module, only once the modifiers are put in place.
515  */
516 contract Pausable is PauserRole {
517     /**
518      * @dev Emitted when the pause is triggered by a pauser (`account`).
519      */
520     event Paused(address account);
521 
522     /**
523      * @dev Emitted when the pause is lifted by a pauser (`account`).
524      */
525     event Unpaused(address account);
526 
527     bool private _paused;
528 
529     /**
530      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
531      * to the deployer.
532      */
533     constructor () internal {
534         _paused = false;
535     }
536 
537     /**
538      * @dev Returns true if the contract is paused, and false otherwise.
539      */
540     function paused() public view returns (bool) {
541         return _paused;
542     }
543 
544     /**
545      * @dev Modifier to make a function callable only when the contract is not paused.
546      */
547     modifier whenNotPaused() {
548         require(!_paused, "Pausable: paused");
549         _;
550     }
551 
552     /**
553      * @dev Modifier to make a function callable only when the contract is paused.
554      */
555     modifier whenPaused() {
556         require(_paused, "Pausable: not paused");
557         _;
558     }
559 
560     /**
561      * @dev Called by a pauser to pause, triggers stopped state.
562      */
563     function pause() public onlyPauser whenNotPaused {
564         _paused = true;
565         emit Paused(msg.sender);
566     }
567 
568     /**
569      * @dev Called by a pauser to unpause, returns to normal state.
570      */
571     function unpause() public onlyPauser whenPaused {
572         _paused = false;
573         emit Unpaused(msg.sender);
574     }
575 }
576 
577 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
578 
579 pragma solidity ^0.5.0;
580 
581 
582 
583 /**
584  * @title Pausable token
585  * @dev ERC20 modified with pausable transfers.
586  */
587 contract ERC20Pausable is ERC20, Pausable {
588     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
589         return super.transfer(to, value);
590     }
591 
592     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
593         return super.transferFrom(from, to, value);
594     }
595 
596     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
597         return super.approve(spender, value);
598     }
599 
600     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
601         return super.increaseAllowance(spender, addedValue);
602     }
603 
604     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
605         return super.decreaseAllowance(spender, subtractedValue);
606     }
607 }
608 
609 // File: openzeppelin-solidity/contracts/access/roles/WhitelistAdminRole.sol
610 
611 pragma solidity ^0.5.0;
612 
613 
614 /**
615  * @title WhitelistAdminRole
616  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
617  */
618 contract WhitelistAdminRole {
619     using Roles for Roles.Role;
620 
621     event WhitelistAdminAdded(address indexed account);
622     event WhitelistAdminRemoved(address indexed account);
623 
624     Roles.Role private _whitelistAdmins;
625 
626     constructor () internal {
627         _addWhitelistAdmin(msg.sender);
628     }
629 
630     modifier onlyWhitelistAdmin() {
631         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
632         _;
633     }
634 
635     function isWhitelistAdmin(address account) public view returns (bool) {
636         return _whitelistAdmins.has(account);
637     }
638 
639     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
640         _addWhitelistAdmin(account);
641     }
642 
643     function renounceWhitelistAdmin() public {
644         _removeWhitelistAdmin(msg.sender);
645     }
646 
647     function _addWhitelistAdmin(address account) internal {
648         _whitelistAdmins.add(account);
649         emit WhitelistAdminAdded(account);
650     }
651 
652     function _removeWhitelistAdmin(address account) internal {
653         _whitelistAdmins.remove(account);
654         emit WhitelistAdminRemoved(account);
655     }
656 }
657 
658 // File: openzeppelin-solidity/contracts/access/roles/WhitelistedRole.sol
659 
660 pragma solidity ^0.5.0;
661 
662 
663 
664 /**
665  * @title WhitelistedRole
666  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
667  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
668  * it), and not Whitelisteds themselves.
669  */
670 contract WhitelistedRole is WhitelistAdminRole {
671     using Roles for Roles.Role;
672 
673     event WhitelistedAdded(address indexed account);
674     event WhitelistedRemoved(address indexed account);
675 
676     Roles.Role private _whitelisteds;
677 
678     modifier onlyWhitelisted() {
679         require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
680         _;
681     }
682 
683     function isWhitelisted(address account) public view returns (bool) {
684         return _whitelisteds.has(account);
685     }
686 
687     function addWhitelisted(address account) public onlyWhitelistAdmin {
688         _addWhitelisted(account);
689     }
690 
691     function removeWhitelisted(address account) public onlyWhitelistAdmin {
692         _removeWhitelisted(account);
693     }
694 
695     function renounceWhitelisted() public {
696         _removeWhitelisted(msg.sender);
697     }
698 
699     function _addWhitelisted(address account) internal {
700         _whitelisteds.add(account);
701         emit WhitelistedAdded(account);
702     }
703 
704     function _removeWhitelisted(address account) internal {
705         _whitelisteds.remove(account);
706         emit WhitelistedRemoved(account);
707     }
708 }
709 
710 // File: contracts/WhitelisterRole.sol
711 
712 pragma solidity 0.5.12;
713 
714 
715 
716 contract WhitelisterRole is WhitelistedRole {
717     using Roles for Roles.Role;
718 
719     event WhitelisterAdded(address indexed account);
720     event WhitelisterRemoved(address indexed account);
721 
722     Roles.Role private _whitelisters;
723 
724     modifier onlyWhitelister() {
725         require(isWhitelister(msg.sender), "WhitelisterRole: caller does not have the Whitelister role");
726         _;
727     }
728 
729     function isWhitelister(address account) public view returns (bool) {
730         return _whitelisters.has(account);
731     }
732 
733     function addWhitelisted(address account) public onlyWhitelister {
734         _addWhitelisted(account);
735     }
736 
737     function removeWhitelisted(address account) public onlyWhitelister {
738         _removeWhitelisted(account);
739     }
740 
741     function addWhitelister(address account) public onlyWhitelistAdmin {
742         _addWhitelister(account);
743     }
744 
745     function removeWhitelister(address account) public onlyWhitelistAdmin {
746         _removeWhitelister(account);
747     }
748 
749     function _addWhitelister(address account) internal {
750         _whitelisters.add(account);
751         emit WhitelisterAdded(account);
752     }
753 
754     function _removeWhitelister(address account) internal {
755         _whitelisters.remove(account);
756         emit WhitelisterRemoved(account);
757     }
758 }
759 
760 // File: contracts/NonRevocableWhitelistAdmin.sol
761 
762 pragma solidity 0.5.12;
763 
764 contract NonRevocableWhitelistAdmin {
765     address private _nonRevocableWhitelistAdmin;
766 
767     event NewNonRevocableWhitelistAdmin(address indexed account);
768 
769     function setNonRevocableWhitelistAdmin(address account) public onlyNonRevocableWhitelistAdmin {
770         _setNonRevocableWhitelistAdmin(account);
771     }
772 
773     function isNonRevocableWhitelistAdmin(address account) public view returns (bool) {
774         return account == _nonRevocableWhitelistAdmin;
775     }
776 
777     function getNonRevocableWhitelistAdmin() public view returns (address) {
778         return _nonRevocableWhitelistAdmin;
779     }
780 
781     function _setNonRevocableWhitelistAdmin(address account) internal {
782         require(account != _nonRevocableWhitelistAdmin, "New and old non-revocable whitelist admins cannot be the same");
783         require(account != address(0), "Cannot set the zero address as non-revocable whitelist admin");
784         _nonRevocableWhitelistAdmin = account;
785         emit NewNonRevocableWhitelistAdmin(account);
786     }
787 
788     modifier onlyRevocableWhitelistAdmin() {
789         require(msg.sender != _nonRevocableWhitelistAdmin, "Only revocable whitelist admins are allowed");
790         _;
791     }
792 
793     modifier onlyNonRevocableWhitelistAdmin() {
794         require(msg.sender == _nonRevocableWhitelistAdmin, "Only non-revocable admins are allowed");
795         _;
796     }
797 }
798 
799 // File: contracts/HonestoToken.sol
800 
801 pragma solidity 0.5.12;
802 
803 
804 
805 
806 /**
807  * @title HonestoToken
808  * @author Dominik Spicher, dominik.spicher@inacta.ch
809  */
810 
811 contract HonestoToken is ERC20Pausable, WhitelisterRole, NonRevocableWhitelistAdmin {
812 
813     string public constant name = "HonestoToken";
814     string public constant symbol = "HOTO";
815     uint8 public constant decimals = 0;
816 
817     uint256 private constant INITIAL_SUPPLY = 10 * (10 ** 6);
818 
819     constructor(address _honestoAccount, address _tokengateAccount) public
820     {
821         require(_honestoAccount != address(0), "_honestoAccount cannot be zero address");
822         require(_tokengateAccount != address(0), "_tokengateAccount cannot be zero address");
823         require(_honestoAccount != _tokengateAccount, "_honestoAccount and _tokengateAccount must be different");
824 
825         // make _honestoAccount and _tokengateAccount WhitelistAdmins
826         _addWhitelistAdmin(_honestoAccount);
827         _addWhitelistAdmin(_tokengateAccount);
828 
829         // make _honestoAccount and _tokengateAccount Whitelisters
830         _addWhitelister(_honestoAccount);
831         _addWhitelister(_tokengateAccount);
832         renounceWhitelistAdmin();
833 
834         // set _honestAccount as the whitelist admin that can't revoke
835         _setNonRevocableWhitelistAdmin(_honestoAccount);
836         assert(super.getNonRevocableWhitelistAdmin() != address(0));
837         // whitelist _honestoAccount so it can receive tokens
838         _addWhitelisted(_honestoAccount);
839 
840         // make _honestoAccount the only Pauser
841         _addPauser(_honestoAccount);
842         renouncePauser();
843 
844         // assign total supply to _honestoAccount
845         _mint(_honestoAccount, INITIAL_SUPPLY);
846     }
847 
848     /**
849      * @dev Transfer non-revocable whitelist admin status to another account
850      * @param account The account to make the non-revocable whitelist admin
851      */
852     function setNonRevocableWhitelistAdmin(address account) public onlyNonRevocableWhitelistAdmin
853     onlyWhitelistAdmin {
854         require(isWhitelistAdmin(account), "Cannot set non-revocable whitelist admin to a non-admin");
855         super.setNonRevocableWhitelistAdmin(account);
856     }
857 
858     /**
859      * @dev Renounce own whitelist admin status. We need to overwrite this
860      * method to add the onlyRevocableWhitelistAdmin modifier
861      */
862     function renounceWhitelistAdmin() public onlyRevocableWhitelistAdmin {
863         super.renounceWhitelistAdmin();
864     }
865 
866     /**
867      * @dev Transfer token to a whitelisted address
868      * @param to The address to transfer to.
869      * @param value The amount to be transferred.
870      */
871     function transfer(address to, uint256 value) public
872         onlyWhitelisted
873         validDestination(to) returns (bool) {
874         require(isWhitelisted(to), "recipient is not whitelisted");
875 
876         return super.transfer(to, value);
877     }
878 
879 
880     /**
881      * @dev Transfer token from an address to another one given sufficient approval
882      * @param to The address to transfer from.
883      * @param to The address to transfer to.
884      * @param value The amount to be transferred.
885      */
886     function transferFrom(address from, address to, uint256 value) public
887         validDestination(to) returns (bool) {
888         require(isWhitelisted(from), "sender is not whitelisted");
889         require(isWhitelisted(to), "recipient is not whitelisted");
890 
891         return super.transferFrom(from, to, value);
892     }
893 
894     /**
895     * @dev Prevent transferring tokens to the contract address
896     * @param to The address to check
897     */
898     modifier validDestination(address to) {
899         require(to != address(this), "No transfer to the token smart contract");
900         _;
901     }
902 
903 }