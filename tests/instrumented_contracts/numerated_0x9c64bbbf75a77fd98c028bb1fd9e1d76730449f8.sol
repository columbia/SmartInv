1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
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
31 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
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
110 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
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
269 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
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
501 // File: node_modules\@openzeppelin\contracts\access\Roles.sol
502 
503 pragma solidity ^0.5.0;
504 
505 /**
506  * @title Roles
507  * @dev Library for managing addresses assigned to a Role.
508  */
509 library Roles {
510     struct Role {
511         mapping (address => bool) bearer;
512     }
513 
514     /**
515      * @dev Give an account access to this role.
516      */
517     function add(Role storage role, address account) internal {
518         require(!has(role, account), "Roles: account already has role");
519         role.bearer[account] = true;
520     }
521 
522     /**
523      * @dev Remove an account's access to this role.
524      */
525     function remove(Role storage role, address account) internal {
526         require(has(role, account), "Roles: account does not have role");
527         role.bearer[account] = false;
528     }
529 
530     /**
531      * @dev Check if an account has this role.
532      * @return bool
533      */
534     function has(Role storage role, address account) internal view returns (bool) {
535         require(account != address(0), "Roles: account is the zero address");
536         return role.bearer[account];
537     }
538 }
539 
540 // File: node_modules\@openzeppelin\contracts\access\roles\PauserRole.sol
541 
542 pragma solidity ^0.5.0;
543 
544 
545 
546 contract PauserRole is Context {
547     using Roles for Roles.Role;
548 
549     event PauserAdded(address indexed account);
550     event PauserRemoved(address indexed account);
551 
552     Roles.Role private _pausers;
553 
554     constructor () internal {
555         _addPauser(_msgSender());
556     }
557 
558     modifier onlyPauser() {
559         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
560         _;
561     }
562 
563     function isPauser(address account) public view returns (bool) {
564         return _pausers.has(account);
565     }
566 
567     function addPauser(address account) public onlyPauser {
568         _addPauser(account);
569     }
570 
571     function renouncePauser() public {
572         _removePauser(_msgSender());
573     }
574 
575     function _addPauser(address account) internal {
576         _pausers.add(account);
577         emit PauserAdded(account);
578     }
579 
580     function _removePauser(address account) internal {
581         _pausers.remove(account);
582         emit PauserRemoved(account);
583     }
584 }
585 
586 // File: node_modules\@openzeppelin\contracts\lifecycle\Pausable.sol
587 
588 pragma solidity ^0.5.0;
589 
590 
591 
592 /**
593  * @dev Contract module which allows children to implement an emergency stop
594  * mechanism that can be triggered by an authorized account.
595  *
596  * This module is used through inheritance. It will make available the
597  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
598  * the functions of your contract. Note that they will not be pausable by
599  * simply including this module, only once the modifiers are put in place.
600  */
601 contract Pausable is Context, PauserRole {
602     /**
603      * @dev Emitted when the pause is triggered by a pauser (`account`).
604      */
605     event Paused(address account);
606 
607     /**
608      * @dev Emitted when the pause is lifted by a pauser (`account`).
609      */
610     event Unpaused(address account);
611 
612     bool private _paused;
613 
614     /**
615      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
616      * to the deployer.
617      */
618     constructor () internal {
619         _paused = false;
620     }
621 
622     /**
623      * @dev Returns true if the contract is paused, and false otherwise.
624      */
625     function paused() public view returns (bool) {
626         return _paused;
627     }
628 
629     /**
630      * @dev Modifier to make a function callable only when the contract is not paused.
631      */
632     modifier whenNotPaused() {
633         require(!_paused, "Pausable: paused");
634         _;
635     }
636 
637     /**
638      * @dev Modifier to make a function callable only when the contract is paused.
639      */
640     modifier whenPaused() {
641         require(_paused, "Pausable: not paused");
642         _;
643     }
644 
645     /**
646      * @dev Called by a pauser to pause, triggers stopped state.
647      */
648     function pause() public onlyPauser whenNotPaused {
649         _paused = true;
650         emit Paused(_msgSender());
651     }
652 
653     /**
654      * @dev Called by a pauser to unpause, returns to normal state.
655      */
656     function unpause() public onlyPauser whenPaused {
657         _paused = false;
658         emit Unpaused(_msgSender());
659     }
660 }
661 
662 // File: @openzeppelin\contracts\token\ERC20\ERC20Pausable.sol
663 
664 pragma solidity ^0.5.0;
665 
666 
667 
668 /**
669  * @title Pausable token
670  * @dev ERC20 with pausable transfers and allowances.
671  *
672  * Useful if you want to stop trades until the end of a crowdsale, or have
673  * an emergency switch for freezing all token transfers in the event of a large
674  * bug.
675  */
676 contract ERC20Pausable is ERC20, Pausable {
677     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
678         return super.transfer(to, value);
679     }
680 
681     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
682         return super.transferFrom(from, to, value);
683     }
684 
685     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
686         return super.approve(spender, value);
687     }
688 
689     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
690         return super.increaseAllowance(spender, addedValue);
691     }
692 
693     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
694         return super.decreaseAllowance(spender, subtractedValue);
695     }
696 }
697 
698 // File: @openzeppelin\contracts\access\roles\WhitelistAdminRole.sol
699 
700 pragma solidity ^0.5.0;
701 
702 
703 
704 /**
705  * @title WhitelistAdminRole
706  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
707  */
708 contract WhitelistAdminRole is Context {
709     using Roles for Roles.Role;
710 
711     event WhitelistAdminAdded(address indexed account);
712     event WhitelistAdminRemoved(address indexed account);
713 
714     Roles.Role private _whitelistAdmins;
715 
716     constructor () internal {
717         _addWhitelistAdmin(_msgSender());
718     }
719 
720     modifier onlyWhitelistAdmin() {
721         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
722         _;
723     }
724 
725     function isWhitelistAdmin(address account) public view returns (bool) {
726         return _whitelistAdmins.has(account);
727     }
728 
729     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
730         _addWhitelistAdmin(account);
731     }
732 
733     function renounceWhitelistAdmin() public {
734         _removeWhitelistAdmin(_msgSender());
735     }
736 
737     function _addWhitelistAdmin(address account) internal {
738         _whitelistAdmins.add(account);
739         emit WhitelistAdminAdded(account);
740     }
741 
742     function _removeWhitelistAdmin(address account) internal {
743         _whitelistAdmins.remove(account);
744         emit WhitelistAdminRemoved(account);
745     }
746 }
747 
748 // File: contracts\IndividualLockableToken.sol
749 
750 pragma solidity ^0.5.0;
751 
752 
753 
754 contract IndividualLockableToken is ERC20Pausable, WhitelistAdminRole{
755   using SafeMath for uint256;
756 
757   event LockTimeSetted(address indexed holder, uint256 old_release_time, uint256 new_release_time);
758   event Locked(address indexed holder, uint256 locked_balance_change, uint256 total_locked_balance, uint256 release_time);
759 
760   struct lockState {
761     uint256 locked_balance;
762     uint256 release_time;
763   }
764 
765   // default lock period
766   uint256 public lock_period = 4 weeks;
767 
768   mapping(address => lockState) internal userLock;
769 
770   // Specify the time that a particular person's lock will be released
771   function setReleaseTime(address _holder, uint256 _release_time)
772     public
773     onlyWhitelistAdmin
774     returns (bool)
775   {
776     require(_holder != address(0));
777     require(_release_time >= block.timestamp);
778 
779     uint256 old_release_time = userLock[_holder].release_time;
780 
781     userLock[_holder].release_time = _release_time;
782     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
783     return true;
784   }
785 
786   // Returns the point at which token holder's lock is released
787   function getReleaseTime(address _holder)
788     public
789     view
790     returns (uint256)
791   {
792     require(_holder != address(0));
793 
794     return userLock[_holder].release_time;
795   }
796 
797   // Unlock a specific person. Free trading even with a lock balance
798   function clearReleaseTime(address _holder)
799     public
800     onlyWhitelistAdmin
801     returns (bool)
802   {
803     require(_holder != address(0));
804     require(userLock[_holder].release_time > 0);
805 
806     uint256 old_release_time = userLock[_holder].release_time;
807 
808     userLock[_holder].release_time = 0;
809     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
810     return true;
811   }
812 
813   // Increase the lock balance of a specific person.
814   // If you only want to increase the balance, the release_time must be specified in advance.
815   function increaseLockBalance(address _holder, uint256 _value)
816     public
817     onlyWhitelistAdmin
818     returns (bool)
819   {
820     require(_holder != address(0));
821     require(_value > 0);
822     require(getFreeBalance(_holder) >= _value);
823 
824     if (userLock[_holder].release_time <= block.timestamp) {
825         userLock[_holder].release_time  = block.timestamp + lock_period;
826     }
827 
828     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
829     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
830     return true;
831   }
832 
833   // Increase the lock balance and release time of a specific person.
834   // If you only want to increase the balance, See increaseLockBalance function.
835   function increaseLockBalanceWithReleaseTime(address _holder, uint256 _value, uint256 _release_time)
836     public
837     onlyWhitelistAdmin
838     returns (bool)
839   {
840     require(_holder != address(0));
841     require(_value > 0);
842     require(getFreeBalance(_holder) >= _value);
843     require(_release_time >= block.timestamp);
844 
845     uint256 old_release_time = userLock[_holder].release_time;
846 
847     userLock[_holder].release_time = _release_time;
848     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
849 
850     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
851     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
852     return true;
853   }
854 
855   // Decrease the lock balance of a specific person.
856   function decreaseLockBalance(address _holder, uint256 _value)
857     public
858     onlyWhitelistAdmin
859     returns (bool)
860   {
861     require(_holder != address(0));
862     require(_value > 0);
863     require(userLock[_holder].locked_balance >= _value);
864 
865     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).sub(_value);
866     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
867     return true;
868   }
869 
870   // Clear the lock.
871   function clearLock(address _holder)
872     public
873     onlyWhitelistAdmin
874     returns (bool)
875   {
876     require(_holder != address(0));
877     
878     userLock[_holder].locked_balance = 0;
879     userLock[_holder].release_time = 0;
880     emit Locked(_holder, 0, userLock[_holder].locked_balance, userLock[_holder].release_time);
881     return true;
882   }
883 
884   // Check the amount of the lock
885   function getLockedBalance(address _holder)
886     public
887     view
888     returns (uint256)
889   {
890     if(block.timestamp >= userLock[_holder].release_time) return uint256(0);
891     return userLock[_holder].locked_balance;
892   }
893 
894   // Check your remaining balance
895   function getFreeBalance(address _holder)
896     public
897     view
898     returns (uint256)
899   {
900     if(block.timestamp    >= userLock[_holder].release_time  ) return balanceOf(_holder);
901     if(balanceOf(_holder) <= userLock[_holder].locked_balance) return uint256(0);
902     return balanceOf(_holder).sub(userLock[_holder].locked_balance);
903   }
904 
905   // transfer overrride
906   function transfer(
907     address _to,
908     uint256 _value
909   )
910     public
911     returns (bool)
912   {
913     require(getFreeBalance(_msgSender()) >= _value);
914     return super.transfer(_to, _value);
915   }
916 
917   // transferFrom overrride
918   function transferFrom(
919     address _from,
920     address _to,
921     uint256 _value
922   )
923     public
924     returns (bool)
925   {
926     require(getFreeBalance(_from) >= _value);
927     return super.transferFrom(_from, _to, _value);
928   }
929 
930   // approve overrride
931   function approve(
932     address _spender,
933     uint256 _value
934   )
935     public
936     returns (bool)
937   {
938     require(getFreeBalance(_msgSender()) >= _value);
939     return super.approve(_spender, _value);
940   }
941 
942   // increaseAllowance overrride
943   function increaseAllowance(
944     address _spender,
945     uint _addedValue
946   )
947     public
948     returns (bool success)
949   {
950     require(getFreeBalance(_msgSender()) >= allowance(_msgSender(), _spender).add(_addedValue));
951     return super.increaseAllowance(_spender, _addedValue);
952   }
953 
954   // decreaseAllowance overrride
955   function decreaseAllowance(
956     address _spender,
957     uint _subtractedValue
958   )
959     public
960     returns (bool success)
961   {
962     uint256 oldValue = allowance(_msgSender(), _spender);
963 
964     if (_subtractedValue < oldValue) {
965       require(getFreeBalance(_msgSender()) >= oldValue.sub(_subtractedValue));
966     }
967     return super.decreaseAllowance(_spender, _subtractedValue);
968   }
969   
970   function renounceWhitelistAdmin()
971     public 
972   {
973     _removeWhitelistAdmin(_msgSender());
974   }
975 }
976 
977 // File: contracts\MocaCoin.sol
978 
979 pragma solidity ^0.5.0;
980 
981 
982 contract MocaCoin is IndividualLockableToken {
983 	using SafeMath for uint256;
984 
985 	string public constant name     = "MocaCoin";
986 	string public constant symbol   = "MCC";
987 	uint8  public constant decimals = 18;
988 
989 	uint256 public constant INITIAL_SUPPLY = 11900000000 * (10 ** uint256(decimals));
990 
991 	constructor()
992 		public
993 	{
994 		_mint(_msgSender(), INITIAL_SUPPLY);
995 	}
996 }